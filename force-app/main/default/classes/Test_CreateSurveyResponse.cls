@IsTest
public class Test_CreateSurveyResponse {
    @IsTest
    public static void TestCreateRecords(){
        List<SurveyResponse__c> testrecords= new List<SurveyResponse__c>();
        for(integer i=0; i<3; i++){
            SurveyResponse__c testdata = new SurveyResponse__c(
            Name = 'Testdata'+i,
                Question__c= 'TestQuestion'+i,
                Response__c = 'TestResponse'+i
            );
            testrecords.add(testdata);
        }
       
        Test.startTest();
        CreateSurveyResponse.createRecords(testrecords);
        Test.stopTest();
    }
    
    @IsTest
    public static void Testexception(){
        
        List<SurveyResponse__c> testrecords1= new List<SurveyResponse__c>();
        for(integer i=0; i<3; i++){
            SurveyResponse__c testdata = new SurveyResponse__c(
                Name = NULL,
                Question__c= 'i',
                Response__c = 'TestResponse'+i
            );
            testrecords1.add(testdata);
        }
        try{
        Test.startTest();
        //for exception
        CreateSurveyResponse.createRecords(testrecords1);
            Test.stopTest();}
        catch(DmlException e){
            System.assert(e.getMessage().contains('Required fields are missing'), 'Unexpected exception message');
        }
    }

}