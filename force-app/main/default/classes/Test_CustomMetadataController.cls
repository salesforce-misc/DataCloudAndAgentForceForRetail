@IsTest
public class Test_CustomMetadataController {
    
    @IsTest
    public static void TestController(){
        
        Test.startTest();
        CustomMetadataController.getMetadataRecords();
        Test.stopTest();
    }

}