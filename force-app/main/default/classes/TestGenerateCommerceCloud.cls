@isTest
public class TestGenerateCommerceCloud {
    @isTest(SeeAllData=true)
    static void testGenerateCommerceCloudAutomotiveData() {
        Test.startTest();
        GenerateCommerceCloudDataRetail.generateCommerceCloudRetailData();
        Test.stopTest();
        
        List<Product2> ProdList = [Select Name FROM Product2 where Name IN ('Men’s Chilkat Nylon Boots','Men’s Safien Mid Gtx Hiking Shoes','Duramo Speed Shoes','Furnace Sleeping Bags 20/-7',
                                          					'Homestead Domey 3 Tent','Homestead Roomy 2','Homestead Shelter','Northstar 4','Tires','Talus4')];
        
         Pricebook2 Stdpricebook = [SELECT Id,Name FROM Pricebook2 where Name = 'Standard Price Book' Limit 1];
         Pricebook2 AutoPriceBook = [SELECT Id,Name FROM Pricebook2 where Name = 'Outfitters Price Book' Limit 1];
        //Pricebook2 AutoStrikePriceBook = [SELECT Id,Name FROM Pricebook2 where Name = 'Outfitters Price Book' Limit 1];
        
        
        // Validate Pricebook Entries
        List<PricebookEntry> pricebookEntries = [SELECT Id FROM PricebookEntry];
        //System.assert(pricebookEntries.size() > 0, 'Pricebook entries should be created');
        
        // Validate Product Category Assignments
        List<ProductCategoryProduct> productCategoryProducts = [SELECT Id FROM ProductCategoryProduct];
        System.assert(productCategoryProducts.size() > 0, 'Product category assignments should be created');
        
        // Validate Commerce Entitlement Products
        List<CommerceEntitlementProduct> commerceEntProducts = [SELECT Id FROM CommerceEntitlementProduct];
        System.assert(commerceEntProducts.size() > 0, 'Commerce entitlement products should be created');
}
}