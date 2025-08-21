@isTest
public class GetAccounts_Test {

    @isTest
    static void testGetAccountDetails() {
        Account testAccount = new Account(
            Name = 'Test Account',
            ShippingCity = 'Test City',
            ShippingState = 'Test State', 
            ShippingPostalCode = '123456',
            ShippingStreet = '123 Test Street',
            PhotoURL__c = 'http://example.com/photo.png'
        );
        insert testAccount;

        Contact testContact = new Contact(
            FirstName = 'John',
            LastName = 'Doe',
            AccountId = testAccount.Id,
            LifetimeValue__c = 1000,
            Propensity_to_purchase__c = 0.75,
            AveragePurchaseValue__c = 250
        );
        insert testContact;

        Test.startTest();
        Account result = GetAccounts.getAccountDetails(testAccount.Id);
        Test.stopTest();
      
    }
}