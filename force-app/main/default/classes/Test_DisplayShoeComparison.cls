@IsTest
public class Test_DisplayShoeComparison {
@IsTest
    public static void TestPublishEvent(){
        //creating testrequest
        DisplayShoeComparison.Request testRequest= new DisplayShoeComparison.Request();
        
        testRequest.ProductId= 'TestProductId';
        testRequest.ContactId= 'TestContactId';
        List<DisplayShoeComparison.Request> requests = new List<DisplayShoeComparison.Request>{testRequest};
        Test.startTest();
        List<DisplayShoeComparison.Response> testResponse = DisplayShoeComparison.getProductId(requests);
        Test.stopTest();
        
    }
}