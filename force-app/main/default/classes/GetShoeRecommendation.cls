public class GetShoeRecommendation {
	private static final String API_VERSION = 'v61.0';
    @AuraEnabled
    public static List<ProductListWrapper> getPromptResponse(String sessionId){
        List<ProductListWrapper> prodWrapperList = new List<ProductListWrapper>();
        String promptResponse = ''; 
        String accessToken=getAccessToken();
        System.debug('## accessToken = '+accessToken);
         String endpoint = String.format(
                    'callout:DataCloud/services/data/{0}/einstein/prompt-templates/Shoe_Recommendation/generations',
                    new String[]{ API_VERSION}
                );
        
        String reqBody = '{"isPreview": "false","inputParams": {"valueMap": {"Input:MessagingSession": {"value": {"id": "'+sessionId+'"}}}},"additionalConfig": {"numGenerations": 1, "temperature": 0,"frequencyPenalty": 0.0,"presencePenalty": 0.0,"additionalParameters": {},"applicationName": "PromptBuilderPreview"}}';
        System.debug('## endpoint = '+endpoint);
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/JSON');
       	req.setBody(reqBody);
		req.setHeader('Authorization', accessToken);
        Http http = new Http();
        HttpResponse res = http.send(req);
        System.debug('## res = '+res);
        System.debug('## res StatusCode = '+res.getStatusCode());
        System.debug('res body = '+res.getBody());
        if (res.getStatusCode() == 201) {
            String rawBody = res.getBody();
            System.debug('## rawBody = '+rawBody);
            Map<String, Object> fullResponse = (Map<String, Object>)JSON.deserializeUntyped(rawBody);
            System.debug('## fullResponse = '+fullResponse);
            if(fullResponse.containsKey('responseMessages')){
                List<Object> dataList = (List<Object>)fullResponse.get('responseMessages');
                System.debug('## dataList = '+dataList);
                if(dataList != NULL){
                    Map<String,Object> firstContentMessage = (Map<String,Object>)dataList[0];
                    System.debug('## firstContentMessage = '+firstContentMessage);
                    if(firstContentMessage.containsKey('content')){
                        String contentMessage = (String)firstContentMessage.get('content');
                        System.debug('## contentMessage = '+contentMessage);
                        Set<String> productNames = new Set<String>();
                        List<String> lines = contentMessage.split('\n');
                        System.debug('## lines = '+lines);
                        for(String line : lines){
                            System.debug('## line = '+line);
                            if(line.startsWithIgnoreCase('Product Name:') || line.startsWithIgnoreCase('**Product Name:**')){
                                if(line.startsWithIgnoreCase('Product Name:') || line.contains('Product Name:')){
                                    String productName = line.replace('Product Name:','').trim();
                                    System.debug('## productName = '+productName);
                                    productNames.add(productName);
                                    System.debug('## productNames = '+productNames);
                                }else if(line.startsWithIgnoreCase('**Product Name:') || line.contains('**Product Name:**')){
                                    String productName = line.replace('*','').trim();
                                    System.debug('## productName = '+productName);
                                    productNames.add(productName);
                                    System.debug('## productNames = '+productNames);
                                }
                                
                            }
                        }
                    	System.debug('## productNames Final = '+productNames);
                        if(productNames != NULL){   
                            List<String> tempList = new List<String>();
                            for(String prodName: productNames){
                                List<String> words = prodName.split(' ');
                                if(words.size() >=2){
                                    tempList.add(words[0]);
                                }else{
                                    tempList.add(prodName);
                                }
                            }
                            System.debug('## tempList = '+tempList);
                            productNames.clear();
                            System.debug('## productNames After Clear = '+productNames);
                            productNames.addAll(tempList);
                            System.debug('## productNames After Adding Templist = '+productNames);
                            String queryStr;
                            if(productNames != NULL){
                                List<String> conditions = new List<String>();
                                for (String key : productNames) {
                                    if (!String.isBlank(key)) {
                                        conditions.add('ssot__Name__c LIKE \'%' + String.escapeSingleQuotes(key) + '%\'');
                                    }
                                }
                                String whereClause = '';
                                if(!conditions.isEmpty()){
                                     whereClause = '(' + String.join(conditions, ' OR ') + ')';
                                        whereClause += ' AND IsActive__c = \'true\'';
                                        whereClause += ' AND ssot__Description__c != null';
                                        whereClause += ' AND ssot__ProductType__c = \'Base\'';
                                }
                                
                                queryStr = 'SELECT ssot__Id__c ,ssot__Name__c ,ssot__Description__c FROM ssot__Product__dlm';
                                if (!String.isBlank(whereClause)) {
                                    queryStr += ' WHERE ' + whereClause;
                                }
                                System.debug('## queryStr = '+queryStr);
                            }
                            List<ssot__Product__dlm> productDMOList = new List<ssot__Product__dlm>();
                            if(queryStr != NULL){
                                System.debug('## queryStr Final = '+queryStr);
                                productDMOList = Database.query(queryStr);
                                System.debug('## productDMOList = '+productDMOList);
                                System.debug('## productDMOList size= '+productDMOList.size());
                            }
                        	/*List<Product2> productList = [Select Id,Name,Description from Product2 Where Name IN: productNames and Description != NULL and Type = 'Base' and isActive = true];
                        	System.debug('## productList = '+productList);
                            List<ssot__Product__dlm> productDMOList = [Select ssot__Id__c ,ssot__Name__c ,ssot__Description__c FROM ssot__Product__dlm Where ssot__Name__c IN: productNames and IsActive__c  = 'true' and ssot__Description__c != NULL and ssot__ProductType__c = 'Base'];
                            System.debug('## productDMOList = '+productDMOList);*/
                            //if(!productList.isEmpty() || !productDMOList.isEmpty()){
                            if(!productDMOList.isEmpty()){
                                //productListToRetrun = productList;
                                //for(Product2 prod : productList){
                                for(ssot__Product__dlm prod : productDMOList){
                                    ProductListWrapper prodWrapper = new ProductListWrapper();
                                    prodWrapper.shoeName = prod.ssot__Name__c;
                                    
                                    String shotDes = prod.ssot__Description__c;
                                    Integer dotIndex = shotDes.indexOf('.');
                                    if(dotIndex > 0){
                                        shotDes = shotDes.substring(0,dotIndex + 1);
                                    }
                                    
                                    //prodWrapper.shoeDescription = prod.ssot__Description__c;
                                    prodWrapper.shoeDescription = shotDes;
                                    prodWrapper.shoeId = prod.ssot__Id__c;
                                    prodWrapper.shoeURL='/outfitters/product/detail/'+prod.ssot__Id__c;
                                    prodWrapperList.add(prodWrapper);
                                }
                            }
                        }
                        //promptResponse = productNames;
                    }
                   
                }
                
            }
            
        }
        
              
        System.debug('## prodWrapperList = '+prodWrapperList);
        return prodWrapperList;
    }
    
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
    
    public class ProductListWrapper{
        @AuraEnabled
        public String shoeName{get;set;}
        @AuraEnabled
        public String shoeDescription{get;set;}       
        @AuraEnabled
        public String shoeId{get;set;}        
        @AuraEnabled
        public String shoeURL{get;set;}
    }
}