@IsTest
public class Test_GetShoeRecommendation {
    
    //HttpCalloutMock class to simulate web service response
    private class RestMock implements HttpCalloutMock {
		public HTTPResponse respond(HTTPRequest req) {
		HTTPResponse res = new HTTPResponse();
            if(req.getEndpoint().contains('auth')){
				res.setHeader('Content-Type', 'application/json');
                res.setBody('{"status":"success", "access_token":"testAccessToken"}');
				res.setStatusCode(200);
                return res;
                    }
            else{
              	res.setHeader('Content-Type', 'application/json');
				res.setBody('{"status":"success", "responseMessages":[{"content":"Product Name: Shoe A\\nProduct Description: Comfortable running shoe\\nProduct ID: 123\\n\\nProduct Name: Shoe B\\nProduct Description: Stylish casual shoe\\nProduct ID: 456"}]}');
				res.setStatusCode(201);
                return res;
            }
		}
    }
    /* private class RestMock1 implements HttpCalloutMock {
		public HTTPResponse respond(HTTPRequest req) {
		HTTPResponse res = new HTTPResponse();
		res.setHeader('Content-Type', 'application/json');
		res.setBody('{"status":"success", "access_token":"your_access_token_here", "responseMessages":[{"content":"Product Name: Shoe A\\nProduct Description: Comfortable running shoe\\nProduct ID: 123\\n\\nProduct Name: Shoe B\\nProduct Description: Stylish casual shoe\\nProduct ID: 456"}]}');
		res.setStatusCode(201);
		return res;
		}
    }*/
    
    @IsTest
    public static void TestgetResponse(){
        String SessionId= 'TestSessionId';
         //setting up the mock response    
        Test.setMock(HttpCalloutMock.class, new RestMock());
        Test.startTest();
        List<GetShoeRecommendation.ProductListWrapper> TestProductList = GetShoeRecommendation.getPromptResponse(SessionId);
        Test.stopTest();
        
    }

}