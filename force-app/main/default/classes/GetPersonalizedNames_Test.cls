@isTest
public class GetPersonalizedNames_Test {
    
    @isTest
    public static void testGetProducts() {
        SoqlStubProvider stub = new ProductSoqlStub();
        
        Test.createSoqlStub(ssot__Product__dlm.sObjectType, stub);
        
        Assert.isTrue(Test.isSoqlStubDefined(ssot__Product__dlm.sObjectType), 'The SOQL stub for ssot__Product__dlm should be defined');
        
        Test.startTest();
        
        List<String> productIds = new List<String>{'P123', 'P124', 'P125'};
            
            List<GetPersonalizedNames.ProductWrapper> result = GetPersonalizedNames.getProducts(productIds);
        
        Test.stopTest();
        
        System.assertNotEquals(result, null, 'The result should not be null');
        System.assertEquals(result.size(), 3, 'The result should contain 3 products');
        
        System.assertEquals(result[0].id, 'P123', 'Product ID should be P123');
        System.assertEquals(result[0].name, 'Product 1', 'Product name should be Product 1');
        System.assert(result[0].imageUrl.contains('image1.jpg'), 'Image URL should contain image1.jpg');
        
        System.assertEquals(result[1].id, 'P124', 'Product ID should be P124');
        System.assertEquals(result[1].name, 'Product 2', 'Product name should be Product 2');
        //System.assertEquals(result[1].imageUrl, '/resource/DuramoSpeedShoes', 'Image URL should be DuramoSpeedShoes for Product 2');
        
        System.assertEquals(result[2].id, 'P125', 'Product ID should be P125');
        System.assertEquals(result[2].name, 'Product 3', 'Product name should be Product 3');
        System.assert(result[2].imageUrl.contains('image3.jpg'), 'Image URL should contain image3.jpg');
    }
    
    class ProductSoqlStub extends SoqlStubProvider {
        public override List<sObject> handleSoqlQuery(sObjectType sot, String stubbedQuery, Map<String, Object> bindVars) {
            if (sot == ssot__Product__dlm.sObjectType) {
                // Mock product data
                ssot__Product__dlm product1 = (ssot__Product__dlm)Test.createStubQueryRow(
                    sot,
                    new Map<String, Object> {
                        'ssot__Id__c' => 'P123',
                            'ssot__Name__c' => 'Product 1',
                            'ManagedContentName__c' => 'image1.jpg'
                            }
                );
                ssot__Product__dlm product2 = (ssot__Product__dlm)Test.createStubQueryRow(
                    sot,
                    new Map<String, Object> {
                        'ssot__Id__c' => 'P124',
                            'ssot__Name__c' => 'Product 2',
                            'ManagedContentName__c' => null
                            }
                );
                ssot__Product__dlm product3 = (ssot__Product__dlm)Test.createStubQueryRow(
                    sot,
                    new Map<String, Object> {
                        'ssot__Id__c' => 'P125',
                            'ssot__Name__c' => 'Product 3',
                            'ManagedContentName__c' => 'image3.jpg'
                            }
                );
                return new List<sObject> { product1, product2, product3 };
                    }
            return new List<sObject>();
        }
    }
    
    class ExperienceSiteSoqlStub extends SoqlStubProvider {
        public override List<sObject> handleSoqlQuery(sObjectType sot, String stubbedQuery, Map<String, Object> bindVars) {
            return new List<sObject>();
        }
    }
    
    @isTest
    static void testSendRecommendationEmail() {
        // Create a test Person Account
        Account testAccount = new Account(
            RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName = 'SDO_PersonAccounts' LIMIT 1].Id,
            LastName = 'Test User',
            PersonEmail = 'testuser@example.com'
        );
        insert testAccount;

        // Retrieve a verified OrgWideEmailAddress (must already exist in the org)
        OrgWideEmailAddress owea = [SELECT Id FROM OrgWideEmailAddress WHERE IsVerified = TRUE LIMIT 1];

        // Set up test data for product info
        String productId = 'dummyProductId';
        String productName = 'Test Product';
        String productDescription = 'This is a test product.';

        Test.startTest();
        try {
            // Call the method under test
            GetPersonalizedNames.sendRecommendationEmail(testAccount.Id, productId, productName, productDescription);
        } catch (Exception e) {
            System.assert(false, 'Method threw an exception: ' + e.getMessage());
        }
        Test.stopTest();
    }
}