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
        
        try {
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint(orgURL + '/services/data/v62.0/ssot/segments/Get_Customers/members?Id__c=' + id);
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

                        if (item.containsKey('id') && (String) item.get('id') == id) {
                            String contactId = (String) item.get('id');
                            System.debug('Found matching contactId: ' + contactId);

                            // Fetching related accountId from the contact record
                            Contact contact = [SELECT AccountId FROM Contact WHERE Id = :contactId LIMIT 1];
                            accountId = contact.AccountId;
                            System.debug('Found related AccountId: ' + accountId);
                        }
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
}