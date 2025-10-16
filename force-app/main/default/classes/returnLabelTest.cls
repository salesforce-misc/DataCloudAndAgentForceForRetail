@isTest
public with sharing class returnLabelTest {
   

    @isTest
    static void testGetContactDetails() {
        // Step 1: Create a test contact
        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'User',
            Phone = '1234567890',
            MailingStreet = '123 Test Street',
            MailingCity = 'Testville',
            MailingState = 'CA',
            MailingPostalCode = '98765',
            MailingCountry = 'USA'
        );
        insert testContact;

        // Step 2: Simulate VF page parameter
        Test.setCurrentPageReference(new PageReference('/apex/ReturnLabelPage'));
        ApexPages.currentPage().getParameters().put('contactId', testContact.Id);

        // Step 3: Instantiate the controller
        returnLabel controller = new returnLabel();

        // Step 4: Call the method
        controller.getContactDetails();

        // Step 5: Assert
        System.assertNotEquals(null, controller.contact, 'Contact should be retrieved.');
        System.assertEquals(testContact.Id, controller.contact.Id, 'Contact ID should match.');
        System.assertNotEquals(null, controller.shipDate, 'Ship date should be set.');
    }
    @isTest
    static void testGetContactDetails_MissingContactId() {
        // Simulate VF page without contactId
        Test.setCurrentPageReference(new PageReference('/apex/ReturnLabelPage'));

        // Instantiate the controller
        returnLabel controller = new returnLabel();

        // Call the method
        controller.getContactDetails();

        // Get messages (simulate user experience)
        List<ApexPages.Message> messages = ApexPages.getMessages();

        // Assert that an error message was added
        System.assertEquals(1, messages.size(), 'One error message should be added.');
        System.assertEquals(ApexPages.Severity.ERROR, messages[0].getSeverity(), 'Error severity should be ERROR.');
        System.assert(messages[0].getSummary().contains('Contact is missing'), 'Error message should mention missing contact.');
    }
}