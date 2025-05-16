@IsTest
public class CometDSessionControllerTest {
    //Mock Response
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
    Public static void testCometDSession(){
        
        //Map<String, String> TestSession = new Map<String, String>();
        
        Test.setMock(HttpCalloutMock.class, new RestMock());
        Test.startTest();
        Map<String, String> TestSession = CometDSessionController.getAccessToken();
        String TestSessionId = CometDSessionController.fetchSessionId();
        SurveyFlyoutConfig__mdt testdata= CometDSessionController.getSurveyFlyoutCongifMDT();
        Test.stopTest();
        
    }

}