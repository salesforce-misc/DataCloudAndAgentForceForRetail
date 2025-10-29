public class AgentSession_CheckUserId {
	@InvocableMethod
    public static List<Response>  getSessionId(List<Request> requests) {
        // Retrieve the session ID using UserInfo.getSessionId()
        String sessionId = UserInfo.getSessionId();
        List<Response> responses = new List<Response>();
       
        if(sessionId!=null){
        	Response res = new Response();
        	System.debug('## no response ');
        	res.Prompt = 'Logged-in user';
        	responses.add(res);
        	return responses;
        }
        
        else
        {
            Response res = new Response();
        	System.debug('## no response ');
        	res.Prompt = 'Guest user';
        	responses.add(res);
        	return responses;
        }
        
    }
    public class Request {
       @InvocableVariable(required=true)
        public String Id;
   		 }
    public class Response {
        @InvocableVariable
       public String Prompt;
    	}
}