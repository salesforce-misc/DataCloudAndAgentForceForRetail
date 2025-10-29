global without sharing class InsertDataForRetail {
    @AuraEnabled
    public static void generateDemoData() {
        try{ 
  			//Create Account
            String [] AccountFLS = new String [] {'Salutation','FirstName','LastName','RecordTypeId','Type','Industry','Phone','NumberOfEmployees','AccountNumber','ShippingCity',
                'ShippingState','ShippingPostalCode','ShippingStreet'};
            Map<String,Schema.SObjectField> m1 = Schema.SObjectType.Account.fields.getMap();
            system.debug('m1:'+m1);
            for (String fieldToCheck : AccountFLS) {
                if(m1.get(fieldToCheck)!= null){
                    if (!m1.get(fieldToCheck).getDescribe().isCreateable() && (!m1.get(fieldToCheck).getDescribe().isupdateable())) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,
                                                                   'Insufficient access')); 
                    }
                }   
            }
            // Query RecordType IDs for the Account object
            Map<String, Id> recordTypeMap = new Map<String, Id>();
            for (RecordType rt : [SELECT Id, DeveloperName, Name FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName = 'SDO_PersonAccounts' LIMIT 1]) {
                recordTypeMap.put(rt.DeveloperName, rt.Id);
            }
            List<Account> accounts = new List<Account>{
                new Account(Salutation= 'Mr.', FirstName = 'Duncan', LastName = 'Macintosh', RecordTypeId = recordTypeMap.get('SDO_PersonAccounts'), Type = 'Partner', Industry = 'Retail', Phone = '(408) 555-5208', NumberOfEmployees = 1000, AccountNumber = 'AC001', Membership_Number__pc = 'RC-805755159',
                           PersonEmail = 'dmacintosh@yopmail.com',ShippingCity='San Francisco', ShippingState='CA', ShippingPostalCode='94123', ShippingStreet='1909 Union St'),
                new Account(Salutation= 'Mr.', FirstName = 'Mark', LastName = 'Smith', RecordTypeId = recordTypeMap.get('SDO_PersonAccounts'), Type = 'Partner', Industry = 'Retail', Phone = '(409) 555-5208', NumberOfEmployees = 4000, AccountNumber = 'AC002', Membership_Number__pc = 'RC-9251267912',
                           PersonEmail = 'msmith@yopmail.com',ShippingCity='East Palo Alto', ShippingState='CA', ShippingPostalCode='94303', ShippingStreet='1700 E Bayshore Rd'),
                new Account(Salutation= 'Mr.', FirstName = 'Nicole', LastName = 'Grace', RecordTypeId = recordTypeMap.get('SDO_PersonAccounts'), Type = 'Partner', Industry = 'Retail', Phone = '(401) 555-5208', NumberOfEmployees = 10000, AccountNumber = 'AC003', Membership_Number__pc = 'RC-367454631',
                           PersonEmail = 'ngrace@yopmail.com',ShippingCity='Mountain View', ShippingState='CA', ShippingPostalCode='94041', ShippingStreet='585 Franklin St'),
                new Account(Salutation= 'Mr.', FirstName = 'Karen', LastName = 'Wells', RecordTypeId = recordTypeMap.get('SDO_PersonAccounts'), Type = 'Partner', Industry = 'Retail', Phone = '(402) 555-5208', NumberOfEmployees = 5000, AccountNumber = 'AC004', Membership_Number__pc = 'RC-616325956',
                           PersonEmail = 'kwells@yopmail.com',ShippingCity='Fairfield', ShippingState='CT', ShippingPostalCode='6824', ShippingStreet='1839 Faifield Beach Rd')
                                    
            };
                
                if(Accounts != null && Accounts.Size() > 0){
               Insert Accounts;
                system.debug('Accounts:'+Accounts);
           	 } 

            Map<String, Account> accountMap = new Map<String, Account>();
            List<Account> accountRecentlyCreatedList = [SELECT Id, Name,CreatedDate FROM Account WHERE Name IN ('Duncan Macintosh','Mark Smith','Nicole Grace','Karen Wells')];
            	if(accountRecentlyCreatedList != null && accountRecentlyCreatedList.size() > 0){
                for (Account acc :accountRecentlyCreatedList) {
               		 accountMap.put(acc.Name, acc);
           		 }
            }
             system.debug('accountRecentlyCreatedList:'+accountRecentlyCreatedList);
            
           Map<String, Contact> contactMap1 = new Map<String, Contact>();
            List<Contact> contactList = [SELECT Id, FirstName, LastName,Name FROM Contact WHERE Email IN ('dmacintosh@yopmail.com','msmith@yopmail.com','ngrace@yopmail.com','kwells@yopmail.com')];
            if(contactList != null && contactList.size() > 0){
                  for (Contact contact :contactList ) {
                contactMap1.put(contact.Name, contact);
          	  } 
            }
             system.debug('contactMap1:'+contactMap1);  
        
            // Define the fields to check for the Promotion object
            String [] PromotionFLS = new String [] {
                'CurrencyIsoCode', 'Description', 'DiscountOrder', 'Discount__c', 'DisplayName', 'EndDate', 'IsActive', 'Name', 'PromotionCode', 'StartDate'};
            
            // Retrieve the metadata for the Promotion object
            Map<String, Schema.SObjectField> promotionFields = Schema.SObjectType.Promotion.fields.getMap();
            System.debug('PromotionFields:' + promotionFields);
            
            // Check FLS for each field
            for (String fieldToCheck : PromotionFLS) {
                if (promotionFields.get(fieldToCheck) != null) {
                    // Check if the field is both not createable and not updateable
                    if (!promotionFields.get(fieldToCheck).getDescribe().isCreateable() && 
                        !promotionFields.get(fieldToCheck).getDescribe().isUpdateable()) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Insufficient access to field: ' + fieldToCheck));
                    }
                }
            }
            
            List<Promotion> Promotions= new List<Promotion>();
            
            Date startDate = Date.today();
            Date endDate = startDate.addDays(30);
            
            Promotions.add(new Promotion(CurrencyIsoCode ='USD', Description = '20% Off', DiscountOrder = 'MostExpensive', Discount__c = 20,DisplayName = 'Winter Sale', EndDate = endDate, IsActive = TRUE, Name = 'Winter Sale', PromotionCode = 'WINTER20', StartDate = startDate));
            Promotions.add(new Promotion(CurrencyIsoCode ='USD', Description = 'Buy1 Get 1 at 50% Off', DiscountOrder = 'MostExpensive', Discount__c = 50,DisplayName = 'Running Gear Special', EndDate = endDate, IsActive = TRUE, Name = 'Running Gear Special', PromotionCode = 'RUN50', StartDate =startDate ));
            Promotions.add(new Promotion(CurrencyIsoCode ='USD', Description = '25% off', DiscountOrder = 'MostExpensive', Discount__c = 25,DisplayName = 'Adventure Sale', EndDate = endDate, IsActive = TRUE, Name = 'Adventure Sale', PromotionCode = 'HIKE25', StartDate =startDate ));
            Promotions.add(new Promotion(CurrencyIsoCode ='USD', Description = '30% off for orders above $100', DiscountOrder = 'MostExpensive', Discount__c = 30,DisplayName = 'Outdoor Essential Sale', EndDate = endDate, IsActive = TRUE, Name = 'Outdoor Essential Sale', PromotionCode = 'CAMP30', StartDate =startDate ));
            Promotions.add(new Promotion(CurrencyIsoCode ='USD', Description = '15%off + Free Shipping', DiscountOrder = 'MostExpensive', Discount__c = 15,DisplayName = 'Spring Camping Special', EndDate = endDate, IsActive = TRUE, Name = 'Spring Camping Special', PromotionCode = 'TENT15', StartDate =startDate ));
            Promotions.add(new Promotion(CurrencyIsoCode ='USD', Description = '$10 off on orders above $50', DiscountOrder = 'MostExpensive', Discount__c = 10,DisplayName = 'Marathon Season Offer', EndDate = endDate, IsActive = TRUE, Name = 'Marathon Season Offer', PromotionCode = 'ULTRA10', StartDate =startDate ));
            Promotions.add(new Promotion(CurrencyIsoCode ='USD', Description = '$25 off on orders above $100', DiscountOrder = 'MostExpensive', Discount__c = 10,DisplayName = 'Speed Shoes Offer', EndDate = endDate, IsActive = TRUE, Name = 'Speed Shoes Offer', PromotionCode = 'DSM2025', StartDate =startDate ));
            
              if(Promotions != null && Promotions.Size() > 0){
                             Insert Promotions;
                              system.debug('Promotions:'+Promotions);
                        }
            
            Map<String, Promotion> PromotionMap = new Map<String, Promotion>();
                        List<Promotion> promotionList = [SELECT Id, Name, IsActive FROM Promotion WHERE IsActive = TRUE];
                      
                        if(promotionList != null && promotionList.size() > 0){
                                    for (Promotion Prom : promotionList) {
                                              PromotionMap.put(Prom.Name, Prom);
                                     }
                        }
                        
                        system.debug('PromotionMap:'+PromotionMap);		
             Map<String, Product2> ProductMap = new Map<String, Product2>();
            List<Product2> productList = [SELECT Id, Name, StockKeepingUnit FROM Product2 WHERE Name IN ('Men Chilkat Nylon Boots','Men Safien Mid Gtx Hiking Shoes','Duramo Speed Shoes','Furnace Sleeping Bags',
                                          'Homestead Domey 3 Tent','Homestead Roomy','Homestead Shelter','UltraRunBreeze','Northstar','Talus4')];
          
            if(productList != null && productList.size() > 0){
                	    for (Product2 Prod : productList) {
              					  ProductMap.put(Prod.Name, Prod);
           				 }
            }
            system.debug('ProductMap:'+ProductMap);
            
            List<PromotionProduct> promoProducts = new List<PromotionProduct>();

            for (String productName : ProductMap.keySet()) {
                for (String promotionName : PromotionMap.keySet()) {
                    PromotionProduct promoProd = new PromotionProduct(
                        ProductId = ProductMap.get(productName).Id,
                        PromotionId = PromotionMap.get(promotionName).Id
                    );
                    promoProducts.add(promoProd);
                }
            }
            if (promoProducts != null && promoProducts.size() > 0) {
                insert promoProducts;
                system.debug('PromotionProduct records inserted: ' + promoProducts);
            }
            
            //Create a Location    
            
          Schema.Location loc = new Schema.Location(Name ='Outfitters Warehouse',LocationType = 'Warehouse',ShouldSyncWithOci = true,
                                       ExternalReference = 'Outfitters_Warehouse',IsInventoryLocation = true);
            insert loc;
            system.debug('Location:'+loc);
            
  			Id Locationid= [Select id from Location where Name =: 'Outfitters Warehouse' LIMIT 1].id;
            system.debug('Fetched Location:'+Locationid);
           //Id Locationid= [Select id from Location LIMIT 1].id;

	List<ProductItem> ProductItems = new List<ProductItem>();
             
	ProductItem prditm1 = new ProductItem(Product2Id = ProductMap.get('Men Chilkat Nylon Boots').Id, fulfilment_status_stock__c = '', LocationId = Locationid, QuantityOnHand = 1);
ProductItems.add(prditm1);
	ProductItem prditm2 = new ProductItem(Product2Id = ProductMap.get('Men Safien Mid Gtx Hiking Shoes').Id, fulfilment_status_stock__c = 'Fulfilled', LocationId =Locationid, QuantityOnHand = 98);
ProductItems.add(prditm2);
	ProductItem prditm3 = new ProductItem(Product2Id = ProductMap.get('Duramo Speed Shoes').Id, fulfilment_status_stock__c = 'Fulfilled', LocationId =Locationid, QuantityOnHand = 132);
ProductItems.add(prditm3);
	ProductItem prditm4 = new ProductItem(Product2Id = ProductMap.get('Furnace Sleeping Bags').Id, fulfilment_status_stock__c = 'Out of Stock', LocationId =Locationid, QuantityOnHand = 0);
ProductItems.add(prditm4);
	ProductItem prditm5 = new ProductItem(Product2Id = ProductMap.get('Homestead Domey 3 Tent').Id, fulfilment_status_stock__c = 'Fulfilled', LocationId =Locationid, QuantityOnHand = 0);
ProductItems.add(prditm5);
	ProductItem prditm6 = new ProductItem(Product2Id = ProductMap.get('Homestead Roomy').Id, fulfilment_status_stock__c = 'Out of Stock', LocationId =Locationid, QuantityOnHand = 2);
ProductItems.add(prditm6);
	ProductItem prditm7 = new ProductItem(Product2Id = ProductMap.get('Homestead Shelter').Id, fulfilment_status_stock__c = 'Out of Stock', LocationId =Locationid, QuantityOnHand = 0);
ProductItems.add(prditm7);
	ProductItem prditm8 = new ProductItem(Product2Id = ProductMap.get('UltraRunBreeze').Id, fulfilment_status_stock__c = 'Fulfilled', LocationId =Locationid, QuantityOnHand = 200);
ProductItems.add(prditm8);
	ProductItem prditm9 = new ProductItem(Product2Id = ProductMap.get('Northstar').Id, fulfilment_status_stock__c = 'Out of Stock', LocationId =Locationid, QuantityOnHand = 0);
ProductItems.add(prditm9);
	ProductItem prditm10 = new ProductItem(Product2Id = ProductMap.get('Talus4').Id, fulfilment_status_stock__c = 'Out of Stock', LocationId =Locationid, QuantityOnHand = 0);
ProductItems.add(prditm10);
			

            if (ProductItems != null && ProductItems.size() > 0) {

                insert ProductItems;

                system.debug('ProductItem records inserted: ' + ProductItems);

            }
 
    }
	catch(Exception e) {
            System.debug('Error: ' + e.getMessage());
            throw e;
        }
    }   
}