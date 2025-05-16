public with sharing class RetailRTDBService {
    @AuraEnabled(cacheable=true)
    public static Map<String, String> getProductNames(String lookupEntry, Long uniqueParam) {
        Map<String, String> productNames = new Map<String, String>();
       
        // Split the lookupEntry string to get lookupTable, lookupName, and lookupId
        List<String> lookupParams = lookupEntry.split(',');
        if (lookupParams.size() != 3) {
            throw new IllegalArgumentException('Invalid lookupEntry format. Expected format: "lookupTable,lookupName,lookupId"');
        }
       
        String lookupTable = lookupParams[0];
        String lookupName = lookupParams[1];
        String lookupId = lookupParams[2];
       
        // Construct the SOQL query
        String query = 'SELECT Id, ' + lookupName + ' FROM ' + lookupTable;
       
        // Execute the query
        List<SObject> results = Database.query(query);
       
        // Populate the resultMap with Id and the lookupName values
        for (SObject record : results) {
            productNames.put((String)record.get('Id'), (String)record.get(lookupName));
        }
       
        System.debug('## productNames = '+productNames);
        return productNames;
    }
 
    @AuraEnabled(cacheable=true)
    public static Map<String, String> lookupObjectValues(String objectName, String fieldName, List<String> objectIds) {
        String queryText = 'SELECT Id, ' + fieldName + ' FROM ' + objectName + ' WHERE Id IN (\'' + String.join(objectIds, '\',\'') + '\')';
 
        System.debug('Executing query: ' + queryText);
         
        List<SObject> queryResult = Database.query(queryText);
       
        Map<String, String> resultMap = new Map<String, String>();
 
        for (Sobject rec : queryResult) {
            resultMap.put((String)rec.get('Id'), (String)rec.get(fieldName));
        }
        System.debug('## resultMap = '+resultMap);
        return resultMap;
    }
}