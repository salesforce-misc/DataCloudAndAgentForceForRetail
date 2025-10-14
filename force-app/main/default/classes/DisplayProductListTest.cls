@isTest
public class DisplayProductListTest {

    @TestSetup
    static void setupTestData() {
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];

        System.runAs(thisUser) {
            // Messaging Channel
            MessagingChannel channel = new MessagingChannel(
                MasterLabel = 'TestChannel',
                DeveloperName = 'TestChannel',
                IsActive = true,
                MessageType = 'Text',
                MessagingPlatformKey = 'TestChannel'
            );
            insert channel;

            // Messaging End User
            MessagingEndUser endUser = new MessagingEndUser(
                Name = 'Messaging User',
                MessagingChannelId = channel.Id,
                MessageType = 'EmbeddedMessaging',
                MessagingPlatformKey = 'TestChannel'
            );
            insert endUser;

            // Guest Messaging Session (no Contact)
            MessagingSession guestSession = new MessagingSession(
                MessagingEndUserId = endUser.Id,
                MessagingChannelId = channel.Id,
                Status = 'New'
            );
            insert guestSession;

            // Messaging session for logged-in user will be created in test method
        }
    }

    @IsTest
    static void testGetInputQuestion_LoggedInUser() {
        // Create a Contact
        Contact con = new Contact(FirstName='Test', LastName='User');
        insert con;

        // Assign Contact to MessagingSession
        MessagingSession session = [SELECT Id FROM MessagingSession LIMIT 1];
        session.Contact__c = con.Id;
        update session;

        // Prepare request
        DisplayProductList.Request request = new DisplayProductList.Request();
        request.Question = 'I’m running a marathon next month, can you suggest suitable shoes?';
        request.SessionId = session.Id;

        List<DisplayProductList.Request> requests = new List<DisplayProductList.Request>{request};

        Test.startTest();
        List<DisplayProductList.Response> responses = DisplayProductList.getInputQuestion(requests);
        Test.stopTest();

        System.assertEquals(1, responses.size(), 'One response should be returned for logged-in user');
        // Cannot assert product content because DLM query returns empty in tests
    }

    @IsTest
    static void testGetInputQuestion_GuestUser() {
        // Get guest messaging session (Contact__c == NULL)
        MessagingSession guestSession = [SELECT Id FROM MessagingSession WHERE Contact__c = NULL LIMIT 1];

        // Prepare request
        DisplayProductList.Request req = new DisplayProductList.Request();
        req.Question = 'I want to run a marathon';
        req.SessionId = guestSession.Id;

        List<DisplayProductList.Request> requests = new List<DisplayProductList.Request>{ req };

        Test.startTest();
        List<DisplayProductList.Response> responses = DisplayProductList.getInputQuestion(requests);
        Test.stopTest();

        System.assertEquals(1, responses.size(), 'One response should be returned for guest user');
        System.assertEquals('Guest User', responses[0].Prompt, 'Guest user response should match');
    }

    @IsTest
    static void testRequestAndResponseClasses() {
        // Cover Request and Response class instantiation
        DisplayProductList.Request dummyReq = new DisplayProductList.Request();
        dummyReq.Question = 'test';
        dummyReq.SessionId = 'dummy';

        DisplayProductList.Response dummyRes = new DisplayProductList.Response();
        dummyRes.Prompt = 'test prompt';
    }
}