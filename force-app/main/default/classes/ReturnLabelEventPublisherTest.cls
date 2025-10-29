@isTest
public class ReturnLabelEventPublisherTest {

    @isTest
    static void testPublishEvent_Success() {
        // Create a test contact
        Contact testContact = new Contact(
            FirstName = 'Return',
            LastName = 'LabelUser',
            Email = 'returnuser@test.com'
        );
        insert testContact;

        // Prepare request param with valid contact ID
        ReturnLabelEventPublisher.RequestParams params = new ReturnLabelEventPublisher.RequestParams();
        params.contactId = testContact.Id;

        List<ReturnLabelEventPublisher.RequestParams> requestList = new List<ReturnLabelEventPublisher.RequestParams>{ params };

        Test.startTest();
        List<String> results = ReturnLabelEventPublisher.publishEvent(requestList);
        Test.stopTest(); // Ensures async publish is processed

        System.assertEquals(1, results.size(), 'Should return one result');
        System.assertEquals('Success', results[0], 'Should return Success for valid contact ID');
    }

    @isTest
    static void testPublishEvent_MissingContactId() {
        // Prepare request param with missing contact ID
        ReturnLabelEventPublisher.RequestParams params = new ReturnLabelEventPublisher.RequestParams();
        params.contactId = ''; // Empty ID

        List<ReturnLabelEventPublisher.RequestParams> requestList = new List<ReturnLabelEventPublisher.RequestParams>{ params };

        List<String> results = ReturnLabelEventPublisher.publishEvent(requestList);

        System.assertEquals(1, results.size(), 'Should return one result');
        System.assertEquals('Error:Missing contactId', results[0], 'Should return error for missing contact ID');
    }
}