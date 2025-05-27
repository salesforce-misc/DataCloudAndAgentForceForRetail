public class GuestORLoggedInUserCheck {
	@InvocableMethod
    public static List<Response> getInputQuestion(List<Request> requests) {
        Request input = requests[0];
        String MSessionId= input.SessionId;
        System.debug('MSession'+MSessionId);
        List<Response> responses = new List<Response>(); 
        List<MessagingSession> messagingSessionList = [SELECT Id,cookieId__c,UsersId__c,User_Email__c,User__c,Contact__c,CreatedDate  FROM MessagingSession Where Id =: MSessionId];
        if(!messagingSessionList.isEmpty() && messagingSessionList[0].Contact__c == NULL){
            Response res = new Response();
            res.Prompt = false;
            responses.add(res);
        }else if(!messagingSessionList.isEmpty() && messagingSessionList[0].Contact__c != NULL){
            Response res = new Response();
            res.Prompt = true;
            responses.add(res);
        }
        
        System.debug('## responses = '+responses);  
        return responses;
    }
    
    public class Request {
        @InvocableVariable(required=true)
        public String SessionId; 
    }
    public class Response {
        @InvocableVariable
        public Boolean Prompt;
    }
}