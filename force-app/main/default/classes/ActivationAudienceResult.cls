public with sharing class ActivationAudienceResult {
    private static final String API_VERSION = 'v61.0';
    @InvocableMethod(label='Get Activation Audience Result')
    public static List<Response> getAAQueryData(List<Request> requests){
        Map<String, String> recalledProductsMap = new Map<String, String>();
		Request input = requests[0];
        String conid = input.contactId;        
        String accessToken=getAccessToken();
        System.debug('## accessToken = '+accessToken);
         String endpoint = String.format(
                    'callout:DataCloud/services/data/{0}/ssot/queryv2',
                    new String[]{ API_VERSION}
                );
        System.debug('## endpoint = '+endpoint);
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/JSON');
        SurveyFlyoutConfig__mdt lFConfig = [SELECT Recall_Product_Table_Name__c FROM SurveyFlyoutConfig__mdt LIMIT 1];
       	System.debug('## lFConfig = '+lFConfig);
        req.setBody('{"sql":"SELECT Activation_Record__c,Activated_Entity_Id__c FROM ' + lFConfig.Recall_Product_Table_Name__c + ' WHERE Activated_Entity_Id__c=\''+conid +'\' ORDER By Activation_Publish_Timestamp__c DESC"}');
        //req.setBody('{"sql":"SELECT Activation_Record__c,Activated_Entity_Id__c FROM AAL_DataCloud_85UO40000017gLJMAY__dlm WHERE Activated_Entity_Id__c=\''+'003NS00001EMkhxYAD'+'\' ORDER By Activation_Publish_Timestamp__c DESC"}');
		req.setHeader('Authorization', accessToken);
        Http http = new Http();
        HttpResponse res = http.send(req);
        System.debug('## res = '+res);
        System.debug('## res StatusCode = '+res.getStatusCode());
        System.debug('res body = '+res.getBody());
        if (res.getStatusCode() == 201) {
            String rawBody = res.getBody();
            System.debug('## rawBody = '+rawBody);
            //recalledProductsMap = parseAndBuildProductMap(rawBody,'0037y00000wOOjKAAW');
            recalledProductsMap = parseAndBuildProductMap(rawBody,conid);
        }
        List<Response> responses = new List<Response>();
        if (!recalledProductsMap.isEmpty()) {
            // Get the first product name from the map (assuming only one product is found)
            String productName = recalledProductsMap.values().iterator().next(); // Assuming one product
            if (String.isNotEmpty(productName)) {
               // String message = Response.generateMessage(productName);
                String message = new Response('productId', productName, '').generateMessage(productName);
                responses.add(new Response('productId', productName, message));
            }
                // Create the response with the message
                //responses.add(new Response('productId', productName,message));
            }
            return responses;
        }

        
        
        // if(!recalledProductsMap.isEmpty() && recalledProductsMap != null){
        //     for(String key : recalledProductsMap.keySet()){
        //         responses.add(new Response(key,recalledProductsMap.get(key)));
        //     }
        // }          
        // System.debug('## responses = '+responses);
        // return responses;
    //}
    
    public static String getAccessToken() {
        String accessToken;
        try {
            Secret_Key__mdt secretKetRecord = [Select Client_Id__c,Client_Secret__c from Secret_Key__mdt Where MasterLabel = 'HMAC_Secret' Limit 1];
            System.debug('## secretKetRecord = '+secretKetRecord);
            HttpRequest req = new HttpRequest();
            req.setEndpoint('callout:GuestCometDNew1/services/oauth2/token');
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
            req.setBody('grant_type=client_credentials'+ '&client_id='+secretKetRecord.Client_Id__c + '&client_secret='+secretKetRecord.Client_Secret__c);

            Http http = new Http();
            HttpResponse res = http.send(req);  
            System.debug('## getStatusCode = '+res.getStatusCode());
            if (res.getStatusCode() == 200) {
                Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                System.debug('## jsonResponse = '+jsonResponse);
                accessToken = 'Bearer '+(String) jsonResponse.get('access_token');     
                System.debug('## accessToken = '+accessToken);
                return accessToken;
            } else {
                System.debug('Failed to retrieve token: ' + res.getBody());
                return null;
            }
        } catch (Exception e) {
            System.debug('Error fetching access token: ' + e.getMessage());
            return null;
        }
    }
    
    public static Map<String, String> parseAndBuildProductMap(String rawBody, String contactId) {
        Map<String, String> recalledProductsMap = new Map<String, String>();

        Map<String, Object> fullResponse = (Map<String, Object>) JSON.deserializeUntyped(rawBody);
        List<Object> data = (List<Object>) fullResponse.get('data');

        for (Object rowObj : data) {
            List<Object> row = (List<Object>) rowObj;

            if (row.isEmpty()) continue;

            String escapedJsonStr = (String) row[0];

            // Step 1: Convert &quot; to actual double quotes
            String cleanJsonStr = escapedJsonStr.replace('&quot;', '"');

            try {
                Map<String, Object> jsonMap = (Map<String, Object>) JSON.deserializeUntyped(cleanJsonStr);

                // Step 2: Check for SalesOrder
                if (jsonMap.containsKey('SalesOrder')) {
                    List<Object> salesOrders = (List<Object>) jsonMap.get('SalesOrder');

                    for (Object soObj : salesOrders) {
                        Map<String, Object> soMap = (Map<String, Object>) soObj;

                        // Step 3: Check if OrderNumber exists
                        if (!soMap.containsKey('OrderNumber')) continue;

                        // Step 4: Check SoldToCustomerId match
                        String soldToId = (String) soMap.get('SoldToCustomerId');
                        if (soldToId != contactId) continue;

                        // Step 5: Check Product array
                        if (!soMap.containsKey('Product')) continue;

                        List<Object> productList = (List<Object>) soMap.get('Product');
                        for (Object prodObj : productList) {
                            Map<String, Object> prodMap = (Map<String, Object>) prodObj;

                            Boolean recall = (Boolean) prodMap.get('Recall');
                            if (recall == true) {
                                String prodId = (String) prodMap.get('Product-Id');
                                String prodName = (String) prodMap.get('Name');
                                if (prodId != null && prodName != null) {
                                    recalledProductsMap.put(prodId, prodName);
                                }
                            }
                        }
                    }
                }
            } catch (Exception ex) {
                System.debug('Failed to parse inner JSON: ' + ex.getMessage());
                continue;
            }
        }

        System.debug('## Final recalledProductsMap => ' + recalledProductsMap);
        return recalledProductsMap;
    }
    
    public class Request {
        @InvocableVariable
        public String contactId;      
    }

    public class Response {
        @InvocableVariable
        public String key;
        
        @InvocableVariable
        public String value;  

        @InvocableVariable
        public String message; 

        public Response(string key, String value, String message){
            this.key = key;
            this.value = value;
            this.message = message;
        }
        public String generateMessage(String productName) {
            if (String.isNotEmpty(productName)) {
                return 'You should have received an email about ' + productName + ' that has been recalled. ' + 
                       'Looking at the return history, we noticed you still have not returned ' + 
                       productName + '. Do you want us to send the mailing label again as a reminder?';
            }else{
                return 'Hi there How can i assist you today ?';
            }
           
        }
    }
}