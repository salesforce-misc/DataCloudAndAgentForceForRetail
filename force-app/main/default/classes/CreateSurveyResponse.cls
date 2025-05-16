public class CreateSurveyResponse {
    @AuraEnabled
    Public static void createRecords(List<SurveyResponse__c> SurveyResponses){
                
        if(SurveyResponses == null || SurveyResponses.isEmpty()){ throw new AuraHandledException('No records provided');}
        try{
            System.debug('records inserted'+SurveyResponses);
                insert SurveyResponses;
                System.debug('records inserted');
            }
        catch(DmlException e){
                
                System.debug('Error creating record'+e.getMessage());
            }       
    }
}