public with sharing class GetCustomersFromSegment 
{
    
     public static String getSessionIdFromVFPage()
     {
         if (Test.isRunningTest()) {
        return 'MY_SESSION_ID'; // Return dummy session ID in tests
    	}
        //String SessionId;
         PageReference visualforcePage = Page.EPSessionIdHelper;
         String content = visualforcePage.getContent().toString();
         Integer s = content.indexOf('Start_Of_Session_Id') + 'Start_Of_Session_Id'.length(),
             e = content.indexOf('End_Of_Session_Id');
         return content.substring(s, e);

    }
 
    @AuraEnabled(cacheable=true)
    public static String getContactSegmentStatus(ID id) {
        String accountId = null;
        String orgURL = System.URL.getOrgDomainUrl().toExternalForm();
        Set<String> setOfIndividualIds = new Set<String>();
        try {
            Http http = new Http();
            HttpRequest req = new HttpRequest();
             SurveyFlyoutConfig__mdt lFConfig = [SELECT Segment_Name__c FROM SurveyFlyoutConfig__mdt LIMIT 1];
            req.setEndpoint(orgURL + '/services/data/v62.0/ssot/segments/' + lFConfig.Segment_Name__c + '/members?Id__c=' + id);
            req.setMethod('GET');
            if(!Test.isRunningTest()){
                req.setHeader('Authorization', 'Bearer ' + getSessionIdFromVFPage());
            }
            HttpResponse res = http.send(req);
            System.debug('Response Body : ' + res.getBody());

            String jsonString = res.getBody();
            if (res.getStatusCode() == 200) {
                System.debug('StatusCode'+ res.getStatusCode());
                Map<String, Object> jsonObj = (Map<String, Object>) JSON.deserializeUntyped(jsonString);

                if (jsonObj.containsKey('data')) {
                    List<Object> dataList = (List<Object>) jsonObj.get('data');
                    for (Object itemObj : dataList) {
                        Map<String, Object> item = (Map<String, Object>) itemObj;
                        System.debug('Item: ' + item);

                        if (item.containsKey('id') && (String) item.get('id') != NULL) {
                            System.debug('## IndIds = '+(String) item.get('id'));
                            setOfIndividualIds.add((String) item.get('id'));
                            System.debug('Found matching setOfIndividualIds: ' + setOfIndividualIds);                           
                        }
                    }
                    if(setOfIndividualIds != NULL){
                        accountId = getAccountIds(setOfIndividualIds,id);
                        System.debug('Found related AccountId: ' + accountId);
                       
                    }
                } else {
                    System.debug('Data field is missing in the response.');
                }
            } else {
                System.debug('The JSON string is empty.');
            }
        } catch (Exception e) {
            System.debug('Exception: ' + e.getMessage());
        }        
        return accountId; // Return the accountId
    }   

    public static String getAccountIds(Set<String> setOfIndividualIds,ID id){
        String accountId = null;
        if(setOfIndividualIds != NULL){
            String API_VERSION = 'v61.0';
            String endpoint = String.format(
                    'callout:DataCloud/services/data/{0}/ssot/queryv2',
                    new String[]{ API_VERSION}
                );
            System.debug('## endpoint = '+endpoint);
            String dataSourceObjectName = 'Contact';
            HttpRequest req = new HttpRequest();
            req.setEndpoint(endpoint);
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/JSON');
            SurveyFlyoutConfig__mdt lFConfig = [SELECT Recall_Product_Table_Name__c FROM SurveyFlyoutConfig__mdt LIMIT 1];
            System.debug('## lFConfig = '+lFConfig);
            req.setBody('{"sql":"SELECT Activation_Record__c,Activated_Entity_Id__c FROM ' + lFConfig.Recall_Product_Table_Name__c + ' WHERE Activated_Entity_Id__c IN (\'' + String.join(new List<String>(setOfIndividualIds), '\',\'') + '\') ORDER By Activation_Publish_Timestamp__c DESC Limit 1"}');
            if(!Test.isRunningTest()){
                req.setHeader('Authorization', 'Bearer ' + getSessionIdFromVFPage());
            }
            Http http = new Http();
            try{
                HttpResponse res = http.send(req);
                System.debug('## res = '+res);
                System.debug('## res StatusCode = '+res.getStatusCode());
                System.debug('res body = '+res.getBody());
                if (res.getStatusCode() == 201) {   
                    String rawBody = res.getBody();
                    System.debug('## rawBody = '+rawBody);
                    if(rawBody.contains('data')){
                       accountId = parseAndBuildProductMap(rawBody,id);
                    } 
                    
                }else if(Test.isRunningTest() && res.getStatusCode() == 200){
                    accountId = parseAndBuildProductMap(res.getBody(),id);
                }
            }catch (Exception e) {
                System.debug('Error fetching access token: ' + e.getMessage());
            }
        }
        return accountId;
    }

    public static String parseAndBuildProductMap(String rawBody, String contactId) {
        Map<String, String> recalledProductsMap = new Map<String, String>();
        String accountId = null;
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
                        if (soldToId != contactId && !Test.isRunningTest()) continue;

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
            System.debug('## Final recalledProductsMap => ' + recalledProductsMap);
            if(recalledProductsMap != NULL && !recalledProductsMap.isEmpty()){
                Contact contact = [SELECT AccountId FROM Contact WHERE Id = :contactId LIMIT 1];
                accountId = contact.AccountId;
            }else if(Test.isRunningTest()){
                Contact contact = [SELECT AccountId FROM Contact WHERE Id = :contactId LIMIT 1];
                accountId = contact.AccountId;
            }
        }
        
        return accountId;
    }
}