@IsTest
public class Test_SFMCCallout{
    
    //HttpCalloutMock class to simulate web service response
    private class RestMock implements HttpCalloutMock {
		public HTTPResponse respond(HTTPRequest req) {
		HTTPResponse res = new HTTPResponse();
		res.setHeader('Content-Type', 'application/json');
		res.setBody('{"status":"success", "access_token":"Test_Token"}');
		res.setStatusCode(200);
		return res;
		}
    }
	@IsTest
    public static void testCallout(){
        SFMCCalloutService.FlowInputs TestRequest = new SFMCCalloutService.FlowInputs();
        TestRequest.Name= 'TestName';
        TestRequest.EmailAddress ='Test@test.com';
        List<SFMCCalloutService.FlowInputs> requests = new List<SFMCCalloutService.FlowInputs>{TestRequest};
            
        //setting up the mock response    
        Test.setMock(HttpCalloutMock.class, new RestMock());
        Test.startTest();
        List<SFMCCalloutService.Response> responses = SFMCCalloutService.callJourneyApi(requests);
        Test.stopTest();
    }
}