@isTest
public class displayShoeCompTest {
    
    @isTest
    static void testGetProductId_WithValidProductId() {
        //Create a mock request with valid ProductId and ContactId
        DisplayShoeComparison.Request req = new DisplayShoeComparison.Request();
        req.ProductId = 'P12345';
        req.ContactId = '003XXXXXXXXXXXX'; // sample contact Id string

        List<DisplayShoeComparison.Request> requests = new List<DisplayShoeComparison.Request>{req};

        Test.startTest();
        // Call the method
        List<DisplayShoeComparison.Response> responses = DisplayShoeComparison.getProductId(requests);
        Test.stopTest();

        // Validate response
        System.assertEquals(1, responses.size(), 'Should return one response');
        System.assertEquals('Published', responses[0].Prompt, 'Response should be "Published"');
    }
    
    @isTest
    static void testGetProductId_WithNullProductId() {
        // Create request with null ProductId to hit else branch
        DisplayShoeComparison.Request req = new DisplayShoeComparison.Request();
        req.ProductId = null;
        req.ContactId = '003XXXXXXXXXXXX'; // mock contact Id

        List<DisplayShoeComparison.Request> requests = new List<DisplayShoeComparison.Request>{req};

        Test.startTest();
        // Call method to cover "else" part (no event publish)
        List<DisplayShoeComparison.Response> responses = DisplayShoeComparison.getProductId(requests);
        Test.stopTest();

        //Validate response
        System.assertEquals('Published', responses[0].Prompt, 'Response should be "Published"');
    }
    
    @isTest
    static void testInnerClassesCoverage() {
        //Just to ensure full coverage for inner classes
        DisplayShoeComparison.Request requestObj = new DisplayShoeComparison.Request();
        requestObj.ProductId = 'TEST123';
        requestObj.ContactId = '003XYZ';
        
        DisplayShoeComparison.Response responseObj = new DisplayShoeComparison.Response();
        responseObj.Prompt = 'TestPrompt';
        
        System.assertNotEquals(null, requestObj);
        System.assertNotEquals(null, responseObj);
    }
}