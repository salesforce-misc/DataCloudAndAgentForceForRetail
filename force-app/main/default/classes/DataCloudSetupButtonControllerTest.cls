@isTest
public class DataCloudSetupButtonControllerTest {
    
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
    public static void Controllertest(){
        
         // Step 1: Get a user with a role (usually System Admin has one)
        User adminUser = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator' AND UserRoleId != null LIMIT 1];
        
        // Step 2: Create an Account with that user as the owner
        Account acc1 = new Account(Name = 'Test Account1', OwnerId = adminUser.Id);
        insert acc1;

        Contact testContact1 = new Contact(FirstName = 'MarkTest', LastName = 'SmithTest', Email = 'msmith1@yopmail.com',AccountId = acc1.Id);
        insert testContact1;
        
        User TestUser = new User(
        	Username= 'testuser@example.com',
            Alias ='tuser',
            Email = 'testuser@example.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Test',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/Los_Angeles',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Outfitters Customer Profile' LIMIT 1].Id,
            ContactId = testContact1.Id
            
        );
        insert TestUser;
        
        // Insert test product catalog
        ProductCatalog testCatalog = new ProductCatalog(Name='Outfitters Catalog');
        insert testCatalog;
        
        // Insert test product category
        ProductCategory testCategory = new ProductCategory(Name='Test Category', CatalogId=testCatalog.Id);
        insert testCategory;
        
        //call
      Map<String,Boolean> testdata = DataCloudSetupButtonController.getInstalledPackageDetails();
       Test.startTest();
         
             //DataCloudSetupButtonController.orgSetupOnButtonClicked(1, 'Assign Permissions For Objects');
        
       // DataCloudSetupButtonController.orgSetupOnButtonClicked(2, 'Create Commerce Data');
        DataCloudSetupButtonController.orgSetupOnButtonClicked(3, 'Create Test Data');
        //DataCloudSetupButtonController.orgSetupOnButtonClicked(5, 'Create Buyer Group Member Data');
        //DataCloudSetupButtonController.orgSetupOnButtonClicked(4, 'Create order and orderitem');
             //DataCloudSetupButtonController.orgSetupOnButtonClicked(6, 'Create ML Data');
        Test.StopTest();
    }
   
    @isTest
    public static void OrderandOrderItemtest(){
    Test.startTest();
    DataCloudSetupButtonController.orgSetupOnButtonClicked(4, 'Create order and orderitem');   
     Test.StopTest();
    }
    
    @isTest
    public static void BuyerGrouptest(){
    Test.startTest();
    DataCloudSetupButtonController.orgSetupOnButtonClicked(5, 'Create Buyer Group Member Data');    
     Test.StopTest();
    }
    @isTest
    public static void MLtest(){
    Test.startTest();
     DataCloudSetupButtonController.orgSetupOnButtonClicked(6, 'Create ML Data');
     Test.StopTest();
    }
    
    
    @Istest
    static void testHandleResult(){
        //create fake deployment result
        Metadata.DeployResult mockResult = new Metadata.DeployResult();
        mockResult.status = Metadata.DeployStatus.Succeeded;
        
        Metadata.DeployCallbackContext mockContext =  new Metadata.DeployCallbackContext();
        
        //call the callback handler
        CustommetadataUtils callback = new CustommetadataUtils();
        callback.handleResult(mockResult, mockContext);
        
        System.assertEquals(Metadata.DeployStatus.Succeeded,mockResult.status);
    }

}