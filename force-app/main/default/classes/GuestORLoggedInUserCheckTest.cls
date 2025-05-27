@IsTest
public class GuestORLoggedInUserCheckTest {
    @TestSetup
    public static void setupTestData(){
   User thisUser = [
            SELECT Id 
            FROM User 
            WHERE Id = :UserInfo.getUserId()
        ];
        
        System.runAs ( thisUser ) {
            
            MessagingChannel objMsgChannel = new MessagingChannel();
            objMsgChannel.MasterLabel = 'TestChannel';
            objMsgChannel.DeveloperName = 'TestChannel';
            objMsgChannel.IsActive = true;
            objMsgChannel.MessageType = 'Text'; 
            objMsgChannel.MessagingPlatformKey = 'TestChannel';
            insert objMsgChannel;
            
            MessagingEndUser objMsgUser = new MessagingEndUser();
            objMsgUser.Name = 'Messaging User';
            objMsgUser.MessagingChannelId = objMsgChannel.Id;
            objMsgUser.MessageType = 'EmbeddedMessaging';
            objMsgUser.MessagingPlatformKey = 'TestChannel';
            insert objMsgUser;
            
            //Messaging session with out Contact
            MessagingSession objSession = new MessagingSession();
            objSession.MessagingEndUserId = objMsgUser.Id;
            objSession.MessagingChannelId = objMsgChannel.Id;
            objSession.Status = 'New';
            insert objSession;                   
        }               
        
    }
    
    @IsTest
    public static void TestGuestUserCheck(){
    //Invoke method
        GuestORLoggedInUserCheck.Response testResponse = new GuestORLoggedInUserCheck.Response();
        List<GuestORLoggedInUserCheck.Response> TestResponses = new List<GuestORLoggedInUserCheck.Response>();
        GuestORLoggedInUserCheck.Request testRequest= new GuestORLoggedInUserCheck.Request();
        MessagingSession Guestsession= [SELECT Id FROM MessagingSession LIMIT 1];
        testRequest.SessionId=Guestsession.Id;
        List<GuestORLoggedInUserCheck.Request> testRequests = new List<GuestORLoggedInUserCheck.Request>{testRequest};
        Test.startTest();
        TestResponses = GuestORLoggedInUserCheck.getInputQuestion(testRequests);
        Test.stopTest();        
    }
    @IsTest
    public static void TestLoggedInUserCheck(){
    //Invoke method
        GuestORLoggedInUserCheck.Response testResponse = new GuestORLoggedInUserCheck.Response();
        List<GuestORLoggedInUserCheck.Response> TestResponses = new List<GuestORLoggedInUserCheck.Response>();
        GuestORLoggedInUserCheck.Request testRequest= new GuestORLoggedInUserCheck.Request();
        //Test Contact and loggedin sessionId data
        Contact testContact= new Contact(LastName='TestContact');
        insert testContact; 
        MessagingSession LoggedInsession = [SELECT Id FROM MessagingSession LIMIT 1];
        LoggedInsession.Contact__c=testContact.id;
		upsert LoggedInsession;
        
        testRequest.SessionId=LoggedInsession.Id;
        List<GuestORLoggedInUserCheck.Request> testRequests = new List<GuestORLoggedInUserCheck.Request>{testRequest};
        Test.startTest();
        TestResponses = GuestORLoggedInUserCheck.getInputQuestion(testRequests);
        Test.stopTest();        
    }
}