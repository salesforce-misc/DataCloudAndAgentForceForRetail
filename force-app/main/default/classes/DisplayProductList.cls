public class DisplayProductList {
    @InvocableMethod
    public static List<Response> getInputQuestion(List<Request> requests) {
        System.debug('## experiences requests = '+requests);
        System.debug('## GetSession Id = '+UserInfo.getSessionId());
        System.debug('## Get User Id = '+UserInfo.getUserId());
        Request input = requests[0];
        String user_Question = input.Question;
        String MSessionId= input.SessionId;
        
        List<MessagingSession> messagingSessionList = [SELECT Id,cookieId__c,UsersId__c,User_Email__c,User__c,Contact__c,CreatedDate  FROM MessagingSession Where Id =: MSessionId];
        
        List<Response> responses = new List<Response>();        
        if(!messagingSessionList.isEmpty() && messagingSessionList[0].Contact__c == NULL && user_Question.containsIgnoreCase('marathon')){   
            System.debug('## Coming inside for guest user');
            //Event publish for guest user asking to recommend shoes
            System.debug('user_Question contains pet = '+user_Question);
            Survey_Popup__e  evt = New Survey_Popup__e();
            evt.isVisible__c=true;
            evt.MessagingSessionId__c= MSessionId;
            //if(user_Question.containsIgnoreCase('suggest suitable shoes'))
            //evt.Input_Type__c='pet-allowed-hotel';
            Database.SaveResult result = EventBus.publish(evt);
            System.debug('##publIsh platform event After ##');
            system.debug('event result'+ result);
            Response res = new Response();
            res.Prompt = 'Guest User';
            responses.add(res);
        }
        else if(!messagingSessionList.isEmpty() && messagingSessionList[0].Contact__c != NULL && user_Question.containsIgnoreCase('marathon')){
            System.debug('## Coming inside for logged in user');
            String searchKey = 'marathon';
            List<ssot__Product__dlm>  productList = [Select ssot__Name__c,ssot__Description__c from ssot__Product__dlm Where  ssot__ProductType__c = 'Base' and ssot__Description__c LIKE '%marathon%' and IsActive__c = 'true']; 
            System.debug('## productList = '+productList);
            String agentResponse = 'Absolutely! Here are some top-rated running shoes designed for endurance and comfort. These options provide great support for long-distance running.\n';
            if(!productList.isEmpty()){
                for(ssot__Product__dlm product : productList){
                    String shotDes = product.ssot__Description__c;
                    Integer dotIndex = shotDes.indexOf('.');
                    if(dotIndex > 0){
                        shotDes = shotDes.substring(0,dotIndex + 1);
                    }
                    agentResponse += '\nName: '+ product.ssot__Name__c + '\nDescription: ' + shotDes + '\n';
                }
            }
            System.debug('## agentResponse = '+agentResponse);
            Response res = new Response();
            res.prompt = agentResponse;
            responses.add(res);
        } 
        
        System.debug('## responses = '+responses);       
        
        return responses;
    }
    
    // The variables in this class need to match the prompt template inputs,
    public class Request {
        @InvocableVariable(required=true)
        public String Question;
        @InvocableVariable(required=true)
        public String SessionId; 
    }
    public class Response {
        @InvocableVariable
        public String Prompt;
    }
}