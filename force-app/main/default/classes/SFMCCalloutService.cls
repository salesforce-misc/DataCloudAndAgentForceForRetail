public with sharing class SFMCCalloutService {
 
     @InvocableMethod(label='Call Journey API' description='Call Journey API')
    public static List<Response> callJourneyApi(List<FlowInputs> request) {
       		
        	String Name = request[0].Name;                   
            String Emailadress =request[0].EmailAddress;         
			Response res = new Response();
            List<Response> responses = new List<Response>(); 
            SFMC_API_EVENT__mdt ups = SFMC_API_EVENT__mdt.getInstance('RetailJourneyAPI');
        	         
        if(Name!=null && Emailadress!=null){
            if(ups != NULL && ups.ClientId__c != NULL && ups.ClientSecret__c != NULL && ups.eventKey__c != NULL){
                callSFMCEvent(Name,Emailadress);
            }                   	
            res.setMessage = 'success';
           	responses.add(res);            
        } 
        else{
          	 res.setMessage = 'Error';
              	responses.add(res);
           }
                return responses;
  }
        
    
    //response class for copilot 
    public class Response {
        @InvocableVariable
        public String setMessage;
    }
    
    //wrapper class for invocable variables
    public class FlowInputs {
       
        @InvocableVariable public String Name;
       
        @InvocableVariable public String EmailAddress;
       
    }
    
    //Token generation callout
    public static String SFMCtokenGeneraion(){
        SFMC_API_EVENT__mdt ups = SFMC_API_EVENT__mdt.getInstance('RetailJourneyAPI');// Use Custom setting to store your data & Credential
        String clientId = ups.ClientId__c;
        String clientSecret = ups.ClientSecret__c;
        String accountID = ups.accountID__c;
       	String eventKey = ups.eventKey__c;
        String authURL = ups.AuthenticationBaseURI__c;
        String restBaseURL = ups.restBaseURL__c;
        System.debug('SFMC API Details ->'+ups);
        System.debug('SFMC clientId Details ->'+clientId);
        System.debug('SFMC clientSecret Details ->'+clientSecret);
        System.debug('SFMC accountID Details ->'+accountID);
        System.debug('SFMC eventKey Details ->'+eventKey);
        System.debug('SFMC authURL Details ->'+authURL);
        System.debug('SFMC restBaseURL Details ->'+restBaseURL);

        String jsonBody = GetAccessTokenJsonBody(clientId, clientSecret,accountID,eventKey).getAsString();
        //String authURL = ups.AuthenticationBaseURI__c;
        String accessToken;
        system.debug('jsonBody---'+jsonBody);
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(authURL);
        req.setHeader('Content-Type', 'application/json');
        req.setMethod('POST');
        req.setBody(jsonBody);

        HttpResponse res = h.send(req);
        String responseBody = res.getBody();
        system.debug('responseBody---'+responseBody);
        Map<String, Object> result = (Map<String, Object>)JSON.deserializeUntyped(responseBody);
        if(res.getStatusCode() == 200){
            accessToken = 'Bearer '+result.get('access_token').toString();
        }
        system.debug('accessToken---'+accessToken);
        return accessToken;     
    }
  
    //call from flow
    public static void callSFMCEvent(String Name, String Email){
   
        String CustName;
        String EmailAdress; 
        
        String AccessToken=SFMCtokenGeneraion();
        SFMC_API_Event__mdt ups = SFMC_API_Event__mdt.getInstance('RetailJourneyAPI');
        String restBaseURL = ups.restBaseURL__c;
        String eventKey = ups.eventKey__c;  
       
        HttpRequest req1 = new HttpRequest();
        req1.setEndpoint(restBaseURL);
        req1.setMethod('POST');  // Use 'POST' for POST requests
        req1.setHeader('Authorization', accessToken ); // Use OAuth token if required
        req1.setHeader('Content-Type', 'application/json');
        String reqBody = getRequestBodyToSendEvent(Name,Email,eventKey).getAsString();
        System.debug('\n Request Body --> '+reqBody);
        req1.setBody(reqBody);
        // Create the HTTP object
        Http http1 = new Http();
        HttpResponse res2;
        try {
            // Send the request and capture the response
            res2 = http1.send(req1);
            if (res2.getStatusCode() == 201) {
                // Success - process the response body
                String resp2Body = res2.getBody();
                System.debug('API Response: ' + resp2Body);
            } else {
                // Handle errors if the response code is not 201
                System.debug('Error: ' + res2.getStatusCode() + ' - ' + res2.getStatus());
            }
        } catch (Exception e) {
            // Handle any exceptions that occur during the HTTP request
            System.debug('Exception: ' + e.getMessage());
        }
    }
   
    
    public static JSONGenerator GetAccessTokenJsonBody(String clientID, String clientSecret,String accountID, String eventKey){
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeStringField('grant_type', 'client_credentials');
        gen.writeStringField('client_id', clientID);
        gen.writeStringField('client_secret', clientSecret);
        gen.writeStringField('account_id', accountID);
        gen.writeEndObject();
        return gen;
    }
    
     public static JSONGenerator getRequestBodyToSendEvent(String Name, String Email, String eventKey )
         
     {
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
	//gen.writeStringField('EventDefinitionKey','APIEvent-d6866b63-d91a-e5c7-43b2-7f970f39e1a9');');
        gen.writeStringField('ContactKey', Email);
        if(eventKey!=null){
                gen.writeStringField('EventDefinitionKey',eventKey);}      
                gen.writeFieldName('Data');
                gen.writeStartObject();
         
        
       
        if(Email!=null){
             gen.writeStringField('SubscriberKey',Email);
                gen.writeStringField('Email', Email);}
        if(Name!=null){
                gen.writeStringField('Name', Name);}
                gen.writeEndObject();
                gen.writeEndObject();
               
                system.debug('responseBody---'+gen.getAsString());
                return gen;
    }


}