@isTest
public class InsertDataForRetailTest {
    @isTest
    static void generateDemoDataTest() {
        
        
          // Invoke the method
        

        // Step 1: Define the fields to check
        String[] AccountFLS = new String[] {'Salutation', 'FirstName', 'LastName', 'RecordTypeId', 'Type', 'Industry', 'Phone', 'NumberOfEmployees', 'AccountNumber', 'ShippingCity',
            'ShippingState', 'ShippingPostalCode', 'ShippingStreet', 'PhotoURL__c', 'PersonContactId'};
        Map<String, Schema.SObjectField> m1 = Schema.SObjectType.Account.fields.getMap();
        for (String fieldToCheck : AccountFLS) {
            if (m1.get(fieldToCheck) != null) {
                System.assert(m1.get(fieldToCheck) != null, fieldToCheck + ' field should not be null');
                //System.assert(m1.get(fieldToCheck).getDescribe().isCreateable() || m1.get(fieldToCheck).getDescribe().isUpdateable(),
                    //'Insufficient access to field: ' + fieldToCheck);
            }
        }

        // Step 2: Set up test data for RecordType
        RecordType rt = [SELECT Id FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName = 'SDO_PersonAccounts' LIMIT 1];
        System.assert(rt != null, 'RecordType should not be null');

        // Step 3: Create and insert accounts
        List<Account> accounts = new List<Account>{
            new Account(Salutation = 'Mr.', FirstName = 'Test', LastName = 'User1', RecordTypeId = rt.Id, Type = 'Partner', Industry = 'Retail', Phone = '1234567890', NumberOfEmployees = 10, AccountNumber = 'AC001'),
            new Account(Salutation = 'Ms.', FirstName = 'Test', LastName = 'User2', RecordTypeId = rt.Id, Type = 'Partner', Industry = 'Retail', Phone = '1234567891', NumberOfEmployees = 20, AccountNumber = 'AC002')
        };
        insert accounts;

        // Validate account insertion
        List<Account> insertedAccounts = [SELECT Id, FirstName, LastName FROM Account WHERE FirstName IN ('Test', 'User1', 'Test', 'User2')];
        System.assertEquals(2, insertedAccounts.size(), 'two accounts should be inserted');

        // Step 4: Validate queries for Account and Contact records
        List<Contact> contacts = [SELECT Id, FirstName, LastName, Name FROM Contact WHERE Email IN ('user1@example.com', 'user2@example.com')];
        System.assertEquals(0, contacts.size(), 'No contacts should be retrieved initially');
		
        // Step 1: Define the fields to check for Promotion object
        String[] PromotionFLS = new String[] {'CurrencyIsoCode', 'Description', 'DiscountOrder', 'Discount__c', 'DisplayName', 'EndDate', 'IsActive', 'Name', 'PromotionCode', 'StartDate'};
        Map<String, Schema.SObjectField> promotionFields = Schema.SObjectType.Promotion.fields.getMap();
        for (String fieldToCheck : PromotionFLS) {
            if (promotionFields.get(fieldToCheck) != null) {
                System.assert(promotionFields.get(fieldToCheck) != null, fieldToCheck + ' field should not be null');
                System.assert(promotionFields.get(fieldToCheck).getDescribe().isCreateable() || promotionFields.get(fieldToCheck).getDescribe().isUpdateable(),
                    'Insufficient access to field: ' + fieldToCheck);
            }
        }

        
        // Step 4: Create test ProductMap (Mocking Product2 records)
        Map<String, Product2> productMap = new Map<String, Product2>();
        List<Product2> testProducts = new List<Product2>{
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
                    
        insert testProducts;
        system.debug('testProducts:'+testProducts);
        Schema.Location loc = new Schema.Location(Name ='Outfitters Warehouse',LocationType = 'Warehouse',ShouldSyncWithOci = true,
                                       ExternalReference = 'Outfitters_Warehouse',IsInventoryLocation = true);
            insert loc;
            system.debug('Location:'+loc);
        
        Test.startTest();
        
        InsertDataForRetail.generateDemoData();
        
        Test.stopTest();
    }   
}