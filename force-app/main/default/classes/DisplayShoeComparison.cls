public class DisplayShoeComparison {
 @InvocableMethod
    public static List<Response> getProductId(List<Request> requests) {
        System.debug('## experiences requests = '+requests);
        Request input = requests[0];
      
        String ProductId=input.ProductId; 
        String ContactId= input.ContactId;
        //event publish for loggenin user asking to compare
        If(ProductId!=null){
               System.debug('user_Question contains pet = '+ProductId);
            ShoeComparisonPopup__e  evt = New ShoeComparisonPopup__e();
            evt.IsModalOpen__c=true;
            evt.ProductId__c= ProductId;
            evt.ContactId__c= ContactId;
            
            //if(user_Question.containsIgnoreCase('suggest suitable shoes'))
            //evt.Input_Type__c='pet-allowed-hotel';
            Database.SaveResult result = EventBus.publish(evt);
            system.debug('event result'+ result);
               }
        
        else{
            system.debug('....');
        }
        
        System.debug('##publIsh platform event After ##');

        List<Response> responses = new List<Response>();
        Response res = new Response();
        System.debug('## no response ');
        res.Prompt = 'Published';
        responses.add(res);
        return responses;
    }
    
    // The variables in this class need to match the prompt template inputs,
    public class Request {
        @InvocableVariable(required=true)
        public String ProductId;
         @InvocableVariable(required=true)
        public String ContactId;
    }
    public class Response {
        @InvocableVariable
        public String Prompt;
    }
}