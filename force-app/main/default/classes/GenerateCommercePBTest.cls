@isTest
public class GenerateCommercePBTest {
    @testSetup
    Static void createtestData(){
 		// Insert test product catalog
        ProductCatalog testCatalog = new ProductCatalog(Name='Outfitters Catalog');
        insert testCatalog;
        
        // Insert test product category
        ProductCategory testCategory = new ProductCategory(Name='Test Category', CatalogId=testCatalog.Id);
        insert testCategory;
    }
    
    @isTest
    static void testPricebookAndEntries() {
        Product2 product = new Product2(Name = 'Test Product', Description = 'Test Product Description');
        insert product;

        // 2. Get the standard pricebook ID
        Id standardPricebookId = Test.getStandardPricebookId();

        // 3. Create a custom pricebook
        Pricebook2 customPricebook = new Pricebook2(Name = 'Test Custom Pricebook', IsActive = true);
        insert customPricebook;
        
        PricebookEntry sPBE = new PricebookEntry(
        Product2Id = product.Id,
        Pricebook2Id = Test.getStandardPricebookId(), 
        UnitPrice = 100.00, // Set a unit price
        IsActive = true);
    	insert sPBE;

     
        PricebookEntry customPBE = new PricebookEntry(
        Product2Id = product.Id,
        Pricebook2Id = customPricebook.Id,
        UnitPrice = 100.00, 
        IsActive = true	);
    	insert customPBE;
        
            
        try {
            GenerateCommerceCloudDataRetail.generateCommerceCloudRetailData(); 
        } catch (Exception e) {
            System.debug('Error: ' + e.getMessage());
        }
    }
}