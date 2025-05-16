public with sharing class ReturnLabelEventPublisher {
    public class RequestParams {
        @InvocableVariable(label='Contact ID' required=true)
        public String contactId;
        
    }
    
    @InvocableMethod(label='Publish Return Label Event' description='Publishes an event to trigger return label Flyout')
    public static List<String> publishEvent(List<RequestParams> requestList) {
    List<returnLabelEvent__e> events = new List<returnLabelEvent__e>();
    List<String> results = new List<String>();

        for (RequestParams request : requestList) {
            if (String.isEmpty(request.contactId)) {
                results.add('Error:Missing contactId');
            continue;
            }

            returnLabelEvent__e eventMessage = new returnLabelEvent__e(
                isVisible__c = true,
                contactId__c = request.contactId
                //productId__c = request.productId
            );
            events.add(eventMessage);
        }

        if (!events.isEmpty()) {
            EventBus.publish(events);
            results.add('Success');
        }
            return results;
                
    }
}