@isTest
public class RecentPurchaseController_Test {

    @IsTest
    public static void testGetRecentProducts() {
        // Define the stub provider
        SoqlStubProvider stub = new RecentPurchaseSoqlStub();
        
        // Mock SOQL queries
        Test.createSoqlStub(ssot__Account__dlm.sObjectType, stub);
        Test.createSoqlStub(ssot__SalesOrder__dlm.sObjectType, stub);
        Test.createSoqlStub(ssot__SalesOrderProduct__dlm.sObjectType, stub);
        Test.createSoqlStub(ssot__Product__dlm.sObjectType, stub);

        // Assert that the SOQL stubs have been successfully created
        Assert.isTrue(Test.isSoqlStubDefined(ssot__Account__dlm.sObjectType));
        Assert.isTrue(Test.isSoqlStubDefined(ssot__SalesOrder__dlm.sObjectType));
        Assert.isTrue(Test.isSoqlStubDefined(ssot__SalesOrderProduct__dlm.sObjectType));
        Assert.isTrue(Test.isSoqlStubDefined(ssot__Product__dlm.sObjectType));

        // Start the test to call the actual method
        Test.startTest();
        Id accountId = '001000000000001'; 
        List<RecentPurchaseController.OrderItemWrapper> results = RecentPurchaseController.getRecentProducts(accountId);
        Test.stopTest();

    }

    // Stub provider to mock the SOQL queries
    class RecentPurchaseSoqlStub extends SoqlStubProvider {
        public override List<sObject> handleSoqlQuery(sObjectType sot, String stubbedQuery, Map<String, Object> bindVars) {
            if (sot == ssot__Account__dlm.sObjectType) {
                // Return a mock Account record with the necessary fields
                ssot__Account__dlm account = (ssot__Account__dlm)Test.createStubQueryRow(
                    sot,
                    new Map<String, Object> {
                        'ssot__Id__c' => bindVars.get('accountId'),
                        'Is_Person_Account__c' => 'true',
                        'Contact_Id__c' => '003000000000001'  
                    }
                );
                return new List<sObject> { account };
            } else if (sot == ssot__SalesOrder__dlm.sObjectType) {
                // Mock the Sales Order records
                ssot__SalesOrder__dlm salesOrder1 = (ssot__SalesOrder__dlm)Test.createStubQueryRow(
                    sot,
                    new Map<String, Object> {
                        'ssot__SoldToCustomerId__c' => '003000000000001'
                    }
                );
                ssot__SalesOrder__dlm salesOrder2 = (ssot__SalesOrder__dlm)Test.createStubQueryRow(
                    sot,
                    new Map<String, Object> {
                        'ssot__SoldToCustomerId__c' => '003000000000001'
                    }
                );
                return new List<sObject> { salesOrder1, salesOrder2 };
            } 
            else if (sot == ssot__SalesOrderProduct__dlm.sObjectType) {
                ssot__SalesOrderProduct__dlm orderProduct1 = (ssot__SalesOrderProduct__dlm)Test.createStubQueryRow(
                    sot,
                    new Map<String, Object> {
                        'ssot__OrderedQuantity__c' => 1,
                        'ssot__UnitPriceAmount__c' => 100,
                        'ssot__ProductId__c' => '01t8d000000Xg1JEAQ'
                    }
                );
                ssot__SalesOrderProduct__dlm orderProduct2 = (ssot__SalesOrderProduct__dlm)Test.createStubQueryRow(
                    sot,
                    new Map<String, Object> {
                        'ssot__OrderedQuantity__c' => 2,
                        'ssot__UnitPriceAmount__c' => 200,
                        'ssot__ProductId__c' => '01t8d000000Xg1JEAR'
                    }
                );
                return new List<sObject> { orderProduct1, orderProduct2 };
            } else if (sot == ssot__Product__dlm.sObjectType) {
                ssot__Product__dlm product1 = (ssot__Product__dlm)Test.createStubQueryRow(
                    sot,
                    new Map<String, Object> {
                        'ssot__Id__c' => '01t8d000000Xg1JEAQ',
                        'ssot__Name__c' => 'Product A',
                        'ssot__Description__c' => 'Description for Product A',
                        'ssot__ProductFamily__c' => 'Family A',
                        'ManagedContentName__c' => 'content_A'
                    }
                );
                ssot__Product__dlm product2 = (ssot__Product__dlm)Test.createStubQueryRow(
                    sot,
                    new Map<String, Object> {
                        'ssot__Id__c' => '01t8d000000Xg1JEAR',
                        'ssot__Name__c' => 'Product B',
                        'ssot__Description__c' => 'Description for Product B',
                        'ssot__ProductFamily__c' => 'Family B',
                        'ManagedContentName__c' => 'content_B'
                    }
                );
                return new List<sObject> { product1, product2 };
            }
            return new List<sObject>();
        }
    }
}