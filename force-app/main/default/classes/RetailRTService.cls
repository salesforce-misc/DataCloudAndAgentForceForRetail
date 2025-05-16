public with sharing class RetailRTService {
    private static final String API_VERSION = 'v61.0';
    @AuraEnabled(cacheable=true)
    public static String fetch(String recordId, String dataGraphName) {
        System.debug('## Account recordId = '+recordId);
        if(recordId != NULL){
            Contact con = [Select Id,AccountId from Contact Where AccountId =: recordId];
            System.debug('## con = '+con);
            if(con != NULL){
                recordId = con.Id;
            }
        }
        System.debug('## Contact recordId = '+recordId);
        String rawBody;
        //String endpoint = '';
        String endpoint = String.format(
            'callout:DataCloud/services/data/{0}/ssot/data-graphs/data/{1}',
            new String[]{ API_VERSION, dataGraphName }
        );
        
        String lookupKeys = 'UnifiedLinkssotIndividualReal__dlm.SourceRecordId__c=' + recordId;
        System.debug('## Final Endpoint = '+endpoint + '?lookupKeys=' + EncodingUtil.urlEncode(lookupKeys, 'UTF-8'));
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint + '?lookupKeys=' + EncodingUtil.urlEncode(lookupKeys, 'UTF-8'));
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/json');
        
        Http http = new Http();
        HttpResponse res = http.send(req);
        System.debug('## res = '+res);
        if (res.getStatusCode() == 200) {
             rawBody = res.getBody();
            System.debug('## rawBody = '+rawBody);
        }

        return rawBody;


    }
}