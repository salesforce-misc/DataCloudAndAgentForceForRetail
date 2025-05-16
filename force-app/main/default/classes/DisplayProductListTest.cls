@isTest
public class DisplayProductListTest {
       //test data creation
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
            
            //Contact testContact= new Contact(LastName='TestContact');
            //insert testContact;
            
            //Messaging session with out Contact
            MessagingSession objSession = new MessagingSession();
            objSession.MessagingEndUserId = objMsgUser.Id;
            objSession.MessagingChannelId = objMsgChannel.Id;
            objSession.Status = 'New';
            insert objSession;
            //messaging sesssion For guest user
            //MessagingSession objSession1 = new MessagingSession();
            //objSession1.MessagingEndUserId = objMsgUser.Id;
            //objSession1.MessagingChannelId = objMsgChannel.Id;
            //objSession1.Status = 'New';
            //objSession1.Contact__c= testContact.Id;
            //insert objSession1;
                        
        }               
        
    }
    @isTest
    static void testGetInputQuestion_WithContact() {
        //Contact test data creation
        Contact Con= new Contact();
        Con.FirstName='test';
        Con.LastName ='123';
        insert Con;
        //messaging session test data creation
        MessagingSession LoggedInsession= [SELECT Id FROM MessagingSession LIMIT 1];


        // Prepare the test request
        DisplayProductList.Request testRequest = new DisplayProductList.Request();
        testRequest.Question = ' I’m running a marathon next month, can you suggest suitable shoes?';
        testRequest.SessionId= LoggedInsession.Id;
        
        List<DisplayProductList.Request> requests = new List<DisplayProductList.Request>{testRequest};
        // Invoke the method
        Test.startTest();
        List<DisplayProductList.Response> responses = DisplayProductList.getInputQuestion(requests);
        Test.stopTest();
    }
    @isTest
    static void testGetInputQuestion_NoContact() {
       Contact testContact= new Contact(LastName='TestContact');
       insert testContact; 
       MessagingSession Guestsession = [SELECT Id FROM MessagingSession LIMIT 1];
       Guestsession.Contact__c=testContact.id;
		upsert Guestsession;
        
        DisplayProductList.Request testRequest = new DisplayProductList.Request();
        testRequest.Question = 'I’m running a marathon next month, can you suggest suitable shoes?';
        testRequest.SessionId= Guestsession.Id;
        List<DisplayProductList.Request> requests = new List<DisplayProductList.Request>{testRequest};
       
            // Invoke the method
        
        Test.startTest();
        List<DisplayProductList.Response> responses = DisplayProductList.getInputQuestion(requests);
        Test.stopTest();
    }
}