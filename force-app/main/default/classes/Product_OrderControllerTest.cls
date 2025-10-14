@IsTest
private class Product_OrderControllerTest {

    @TestSetup
    static void setupData() {
        // Create Account (required for Contact & Order)
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        // Create Contact
        Contact c = new Contact(
            FirstName = 'Tami',
            LastName  = 'Tester',
            Email     = 'tami@test.com',
            AccountId = acc.Id
        );
        insert c;

        // Create Product
        Product2 p = new Product2(
            Name = 'Stub Product',
            ProductCode = 'SP001',
            IsActive = true
        );
        insert p;

        // Activate and get Standard Pricebook ID
        Id standardPricebookId = Test.getStandardPricebookId();

        // Create PricebookEntry
        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = standardPricebookId,
            Product2Id = p.Id,
            UnitPrice = 123.45,
            IsActive = true
        );
        insert pbe;

        //Create Order with required Pricebook2Id
        Order o = new Order(
            AccountId = acc.Id,
            BillToContactId = c.Id,
            Status = 'Draft',
            EffectiveDate = Date.today(),
            Pricebook2Id = standardPricebookId
        );
        insert o;

        // Create OrderItem
        OrderItem oi = new OrderItem(
            OrderId = o.Id,
            Product2Id = p.Id,
            Quantity = 1,
            UnitPrice = 123.45,
            PricebookEntryId = pbe.Id
        );
        insert oi;
    }

    // -------------------------------
    // Test getProductDetail()
    // -------------------------------
    @IsTest
    static void testGetProductDetail_WithStubs() {
        Product2 p = [SELECT Id FROM Product2 WHERE ProductCode = 'SP001' LIMIT 1];

        // Build and register stub
        ProductOrderTestStubProvider stub = new ProductOrderTestStubProvider(null, p.Id);
        Test.createSoqlStub(ssot__ProductAttribute__dlm.SObjectType, stub);
        Test.createSoqlStub(ssot__Product__dlm.SObjectType, stub);
        Test.createSoqlStub(ssot__PriceBook__dlm.SObjectType, stub);
        Test.createSoqlStub(ssot__PriceBookEntry__dlm.SObjectType, stub);

        Test.startTest();
            String json = Product_OrderController.getProductDetail(p.Id);
        Test.stopTest();

        System.assertNotEquals(null, json, 'JSON should not be null');
        System.assert(json.contains('"Name":"StubProdName"'));
        System.assert(json.contains('"Weight":"StubWeight"'));
        System.assert(json.contains('"Category":"StubCategory"'));
        System.assert(json.contains('"Durability":"StubDurability"'));
        System.assert(json.contains('"Stars":"5"'));
        System.assert(json.contains('"Ventilation":"StubVent"'));
        System.assert(json.contains('"Price":123.45'));
    }

    // -------------------------------
    // Test getMostRecentPurchase()
    // -------------------------------
    @IsTest
    static void testGetMostRecentPurchase_WithStubs() {
        Contact c = [SELECT Id FROM Contact WHERE Email = 'tami@test.com' LIMIT 1];
        Product2 p = [SELECT Id FROM Product2 WHERE ProductCode = 'SP001' LIMIT 1];

        // Register stubs for DLM objects
        ProductOrderTestStubProvider stub = new ProductOrderTestStubProvider(c.Id, p.Id);
        Test.createSoqlStub(ssot__ProductAttribute__dlm.SObjectType, stub);
        Test.createSoqlStub(ssot__Product__dlm.SObjectType, stub);
        Test.createSoqlStub(ssot__PriceBook__dlm.SObjectType, stub);
        Test.createSoqlStub(ssot__PriceBookEntry__dlm.SObjectType, stub);
        Test.createSoqlStub(ssot__SalesOrder__dlm.SObjectType, stub);
        Test.createSoqlStub(ssot__SalesOrderProduct__dlm.SObjectType, stub);

        Test.startTest();
            String json = Product_OrderController.getMostRecentPurchase(c.Id);
        Test.stopTest();

        System.assertNotEquals(null, json, 'JSON should not be null');
        System.assert(json.contains('"Name":"StubProdName"'));
        System.assert(json.contains('"Price":123.45'));
    }

    // ----------------------------------------
    // Stub Provider for DLM objects
    // ----------------------------------------
    private class ProductOrderTestStubProvider extends SoqlStubProvider {
        private final String contactId;
        private final String productId;

        public ProductOrderTestStubProvider(String contactId, String productId) {
            this.contactId = contactId;
            this.productId = productId;
        }

        public override List<sObject> handleSoqlQuery(
            Schema.SObjectType sot,
            String stubbedQuery,
            Map<String, Object> bindVars
        ) {
            // 1) PRODUCT ATTRIBUTE
            if (sot == ssot__ProductAttribute__dlm.SObjectType) {
                ssot__ProductAttribute__dlm row = (ssot__ProductAttribute__dlm)
                    Test.createStubQueryRow(
                        ssot__ProductAttribute__dlm.SObjectType,
                        new Map<String, Object>{
                            'ssot__ProductId__c' => productId,
                            'ssot__Name__c' => 'StubProdName',
                            'Weight__c' => 'StubWeight',
                            'Category__c' => 'StubCategory',
                            'Durability__c' => 'StubDurability',
                            'Stars__c' => '5',
                            'Ventilation__c' => 'StubVent',
                            'Id' => 'AttribId'
                        }
                    );
                return new List<sObject>{ row };
            }

            // 2) PRODUCT
            if (sot == ssot__Product__dlm.SObjectType) {
                ssot__Product__dlm row = (ssot__Product__dlm)
                    Test.createStubQueryRow(
                        ssot__Product__dlm.SObjectType,
                        new Map<String, Object>{
                            'ssot__Id__c' => productId,
                            'ssot__Name__c' => 'StubProdName'
                        }
                    );
                return new List<sObject>{ row };
            }

            // 3) PRICEBOOK
            if (sot == ssot__PriceBook__dlm.SObjectType) {
                ssot__PriceBook__dlm row = (ssot__PriceBook__dlm)
                    Test.createStubQueryRow(
                        ssot__PriceBook__dlm.SObjectType,
                        new Map<String, Object>{
                            'ssot__Id__c' => 'StubPriceBookId',
                            'ssot__Name__c' => 'Outfitters Price Book'
                        }
                    );
                return new List<sObject>{ row };
            }

            // 4) PRICEBOOK ENTRY
            if (sot == ssot__PriceBookEntry__dlm.SObjectType) {
                ssot__PriceBookEntry__dlm row = (ssot__PriceBookEntry__dlm)
                    Test.createStubQueryRow(
                        ssot__PriceBookEntry__dlm.SObjectType,
                        new Map<String, Object>{
                            'ssot__UnitListPriceAmount__c' => 123.45,
                            'ssot__PricebookId__c' => 'StubPriceBookId',
                            'ssot__ProductId__c' => productId
                        }
                    );
                return new List<sObject>{ row };
            }

            // 5) SALES ORDER
            if (sot == ssot__SalesOrder__dlm.SObjectType) {
                ssot__SalesOrder__dlm row = (ssot__SalesOrder__dlm)
                    Test.createStubQueryRow(
                        ssot__SalesOrder__dlm.SObjectType,
                        new Map<String, Object>{
                            'ssot__Id__c' => 'StubSOId',
                            'ssot__SoldToCustomerId__c' => contactId,
                            'ssot__OrderStartDate__c' => Date.today()
                        }
                    );
                return new List<sObject>{ row };
            }

            // 6) SALES ORDER PRODUCT
            if (sot == ssot__SalesOrderProduct__dlm.SObjectType) {
                ssot__SalesOrderProduct__dlm row = (ssot__SalesOrderProduct__dlm)
                    Test.createStubQueryRow(
                        ssot__SalesOrderProduct__dlm.SObjectType,
                        new Map<String, Object>{
                            'ssot__SalesOrderId__c' => 'StubSOId',
                            'ssot__ProductId__c' => productId
                        }
                    );
                return new List<sObject>{ row };
            }

            // Default: no records
            return new List<sObject>();
        }
    }
}