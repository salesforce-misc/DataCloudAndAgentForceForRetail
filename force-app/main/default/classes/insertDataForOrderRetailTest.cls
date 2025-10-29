@isTest
public class insertDataForOrderRetailTest {
	 @testSetup
    static void setupData() {
        List<Account> TestAccount = New List<Account> {
			new Account(Name = 'Duncan', Industry = 'Manufacturing', Phone = '1234567890'),
                new Account(Name= 'Mark', Industry = 'Manufacturing', Phone = '9999999990'),
                new Account(Name = 'Nicole', Industry = 'Technology', Phone = '9999999992'),
                new Account(Name = 'Karen', Industry = 'Technology', Phone = '9999999993')
	};
        
        insert TestAccount;
        List<Account> fetchedTestAccnts = [SELECT Id, Name, Phone FROM Account];
        
        List<Contact> TestContact = New List<Contact>{new Contact(FirstName = 'Duncan', LastName = 'Macintosh', Email = 'dmacintosh@yopmail.com',AccountId=fetchedTestAccnts[0].Id),
            											new Contact(FirstName = 'Mark', LastName = 'Smith', Email = 'msmith@yopmail.com',AccountId=fetchedTestAccnts[1].Id),
            											new Contact(FirstName = 'Nicole', LastName = 'Grace', Email = 'ngrace@yopmail.com',AccountId=fetchedTestAccnts[2].Id),
            											new Contact(FirstName = 'Karen', LastName = 'Wells', Email = 'kwells@yopmail.com',AccountId=fetchedTestAccnts[3].Id)};
        insert TestContact;
       /* Map<String, Contact> contactMap2 = new Map<String, Contact>();
            List<Contact> contactList = [SELECT Id, AccountId,Name FROM Contact WHERE Email IN ('dmacintosh@example.com','msmith@example.com','ngrace@example.com','kwells@example.com')];
            if(contactList != null && contactList.size() > 0){
                  for (Contact contact :contactList ) {
                contactMap2.put(contact.Name, contact);
          	  } 
            }
             system.debug('testcontactMap2:'+contactMap2);*/
        
        // Create Products
        List<Product2> productList = new List<Product2>{
            new Product2(Name = 'Men Chilkat Nylon Boots', IsActive = true),
            new Product2(Name = 'Men Safien Mid Gtx Hiking Shoes', IsActive = true),
            new Product2(Name = 'Duramo Speed Shoes', IsActive = true),
                new Product2(Name = 'Furnace Sleeping Bags', IsActive = true),
                new Product2(Name = 'Homestead Domey 3 Tent', IsActive = true),
                new Product2(Name = 'Homestead Roomy', IsActive = true),
                new Product2(Name = 'Homestead Shelter', IsActive = true),
                new Product2(Name = 'UltraRunBreeze', IsActive = true),
                new Product2(Name = 'Northstar', IsActive = true),
                new Product2(Name = 'Talus4', IsActive = true)
        };
        insert productList;
        
        // Create Pricebook
        Pricebook2 pricebook = new Pricebook2(Name = 'Outfitters Price Book', IsActive = true);
        insert pricebook;
        
        // Get the Standard Pricebook Id
        Id pricebookId = Test.getStandardPricebookId();
       Pricebook2 standardPricebook = [SELECT Id FROM Pricebook2 WHERE Name = 'Outfitters Price Book' LIMIT 1];
        

        // Create Standard PricebookEntries
        List<PricebookEntry> standardPriceEntries = new List<PricebookEntry>();
        for (Product2 prod : [SELECT Id FROM Product2 WHERE Name IN ('Men Chilkat Nylon Boots', 'Men Safien Mid Gtx Hiking Shoes', 'Duramo Speed Shoes','Talus4','Northstar','UltraRunBreeze','Homestead Shelter','Homestead Roomy','Homestead Domey 3 Tent','Furnace Sleeping Bags')]) {
            standardPriceEntries.add(new PricebookEntry(
                Pricebook2Id = pricebookId, 
                Product2Id = prod.Id, 
                UnitPrice = 100, 
                IsActive = true
            ));
        }
        insert standardPriceEntries;

        // Create PricebookEntries
        List<PricebookEntry> pricebookEntries = new List<PricebookEntry>();
        for (Product2 prod : productList) {
            pricebookEntries.add(new PricebookEntry(Pricebook2Id = standardPricebook.Id, Product2Id = prod.Id, UnitPrice = 100, IsActive = true));
        }
        insert pricebookEntries;
    } 
    @isTest
    static void testOrderCreation() {
        Test.startTest();
          // Invoke the method
        insertDataForOrderAnddOrderItemRetail.generateOrderAndOrderItemRetail();
        
        // Perform assertions to verify functionality
        List<Order> orders = [SELECT Id, Name, Status FROM Order];
        System.assertEquals(19, orders.size(), 'Expected 9 orders to be created.');
        for (Order ord : orders) {
            System.assertNotEquals(null, ord.Id, 'Order ID should not be null.');
        }
        
        Test.stopTest();
    }
}