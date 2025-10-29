@isTest
public without sharing class ClsRetailSelfRegTest {
 // Test method to create a community user, insert contact/account, and test the Init method
    @isTest
    static void testInitMethod() {
       
            // Insert the product if it does not exist
           Product2 prdt = new Product2(
                Name = 'UltraRunBreeze',
                IsActive = TRUE,
                Description = 'Test UltraRunBreez sports shoes'
            );
            insert prdt;
        
        Pricebook2 standardPricebook = new Pricebook2(
            
            Id = Test.getStandardPricebookId(),
            
            IsActive = true
            
        );
        
        update standardPricebook;
        
        // Re-Query for the Pricebook2 record, for debugging
        
        standardPricebook = [SELECT IsStandard FROM Pricebook2 WHERE Id = :standardPricebook.Id];
        
        // This should return true now
        
        system.assertEquals(true, standardPricebook.IsStandard, 'The Standard Pricebook should now return IsStandard = true');
        
        // Create the PricebookEntry
        
        PricebookEntry standardPricebookEntry = new PricebookEntry( Pricebook2Id = standardPricebook.Id, 
                         Product2Id = prdt.Id,UnitPrice = 100,IsActive = true);
        
        insert standardPricebookEntry;
        
        // Re-Query the PBE
        
        standardPricebookEntry = [SELECT Id, Pricebook2.IsStandard FROM PricebookEntry];
        
        // Should also return true
        
        system.assertEquals(true, standardPricebookEntry.Pricebook2.IsStandard, 'The Standard Pricebook should return true from the PBE as well.');
        
         // Create another custom Pricebook
        Pricebook2 outfitterPB = new Pricebook2(Name = 'Outfitters Price Book', IsActive = true);
        insert outfitterPB;
        
        PricebookEntry outfittersPricebookEntries = new PricebookEntry(Product2Id = prdt.Id, Pricebook2Id = outfitterPB.Id, UnitPrice = 120.0, IsActive = true);
        insert outfittersPricebookEntries;
        
        System.runAs(new User(Id=UserInfo.getUserId())) {
            // Step 1: Create Test Data for person Account
           RecordType recType = [Select id,developername from RecordType where developername = 'PersonAccount' Limit 1];
            
            Account testAccount = new Account(FirstName = 'John', LastName = 'Doe', PersonEmail = 'johndoe@test.com',RecordTypeId = recType.id);
              insert testAccount;
            
        }
        Account acc = [Select id,FirstName,LastName,PersonEmail from Account where PersonEmail = 'johndoe@test.com'];
        system.debug('test acc:'+acc);
        Contact cn=[Select id,AccountId,LastName from contact where AccountId = :acc.id];
         system.debug('test cn:'+cn);
        
        // Step 2: Create a Profile and Community User
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Outfitters Customer Profile' LIMIT 1];
        
        User communityUser = new User(
            Alias = 'jdoe',
            Email = 'johndoe@test.com',
            Username = 'johndoe@test.com' + Math.random(),
            LastName='Doe',
            FirstName='John',
            ProfileId = p.Id,
            ContactId = cn.Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            
            IsActive = true
        );
        insert communityUser;
         system.debug('test communityUser:'+communityUser);
        
        // Step 3: Create the Set of UserIds to pass to the Init method
        Set<Id> userIds = new Set<Id>{communityUser.Id};
            
            // Step 4: Call the Init method
            Test.startTest();
        ClsRetailSelfRegisterDataProvider.Init(userIds);  // Replace 'YourClassName' with the actual class name containing Init method
        Test.stopTest();
        
        // Step 5: Assert Statements to Verify the Results
        String calulatedMembershipNumber = 'RC-92'+String.valueOf(Math.round((Math.random() * (9000000) + 1000000)));
        // Verify that the Contact's Mailing Information has been updated
        Account updateAccount = [SELECT id,name,BillingStreet, BillingCity, BillingState, BillingPostalCode,BillingCountry,
                                 ShippingStreet,ShippingCity,ShippingState,ShippingPostalCode,ShippingCountry
                                  FROM Account WHERE Id = :cn.AccountId];
        system.debug('updateAccount:'+updateAccount);
        System.assertEquals('585 Franklin St', updateAccount.BillingStreet);
        System.assertEquals('Mountain View', updateAccount.BillingCity);
        System.assertEquals('CA', updateAccount.BillingState);
        System.assertEquals('94041', updateAccount.BillingPostalCode);
        System.assertEquals('USA', updateAccount.BillingCountry);
        System.assertEquals('585 Franklin St', updateAccount.ShippingStreet);
        System.assertEquals('Mountain View', updateAccount.ShippingCity);
        System.assertEquals('CA', updateAccount.ShippingState);
        System.assertEquals('94041', updateAccount.ShippingPostalCode);
        System.assertEquals('USA', updateAccount.ShippingCountry);
        
        // Verify that the Asset has been created
        Asset createdAsset = [SELECT Id, Name FROM Asset WHERE ContactId = :cn.id  LIMIT 1];
        System.assertNotEquals(null, createdAsset);
        
        List<Order> createdOrder = [Select id,name,BillToContactId from Order where BillToContactId =:cn.Id Limit 1];
          System.assertNotEquals(null, createdOrder);
        
        List<OrderItem> createdOrderProd = [Select id,OrderId from OrderItem where OrderId IN :createdOrder];
         System.assertNotEquals(null, createdOrderProd);
       
    }
    
}