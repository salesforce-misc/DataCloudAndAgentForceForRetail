@isTest
public with sharing class clsReturnOrderRelatedListControllerTest {
    @isTest
public static void testReturnOrderRelatedMethods() {
// Register stub provider for each DLM object
SoqlStubProvider stub = new ReturnOrderStubProvider();
Test.createSoqlStub(ssot__ReturnOrder__dlm.SObjectType, stub);
Test.createSoqlStub(ssot__ReturnOrderProduct__dlm.SObjectType, stub);
Test.createSoqlStub(ssot__Product__dlm.SObjectType, stub);

// Assert stub setup
System.assert(Test.isSoqlStubDefined(ssot__ReturnOrder__dlm.SObjectType));
System.assert(Test.isSoqlStubDefined(ssot__ReturnOrderProduct__dlm.SObjectType));
System.assert(Test.isSoqlStubDefined(ssot__Product__dlm.SObjectType));

// Use a dummy ExternalId for testing
// Create test Account and Contact
Account testAccount = new Account(Name = 'Test Account');
System.debug('Account: ' + JSON.serialize(testAccount));
insert testAccount;

Contact testContact = new Contact(LastName = 'Test Contact', AccountId = testAccount.Id);
insert testContact;

Test.startTest();
String ExternalId = 'EXT123';



// Call getReturnOrderRecords
List<ssot__ReturnOrder__dlm> returnOrders = clsReturnOrderRelatedListController.getReturnOrderRecords(externalId);
System.assertEquals(1, returnOrders.size());
System.assertEquals('EXT123', returnOrders[0].ssot__CustomerAccountId__c);

// Call getReturnOrderProductRecords
List<String> returnOrderIds = new List<String>{ returnOrders[0].ssot__Id__c };
List<clsReturnOrderRelatedListController.ReturnOrderProductWrapper> wrappers =
clsReturnOrderRelatedListController.getReturnOrderProductRecords(returnOrderIds);

System.assertEquals(1, wrappers.size());
System.assertEquals('P001', wrappers[0].product.ssot__ProductSKU__c);
System.assertEquals('Return123', wrappers[0].returnOrderProduct.ssot__ReturnOrderProductNumber__c);

Test.stopTest();
}

// Stub provider for Return Order test
class ReturnOrderStubProvider extends SoqlStubProvider {
public override List<sObject> handleSoqlQuery(Schema.SObjectType sobjectType, String soql, Map<String, Object> bindVariables) {
if (sobjectType == ssot__ReturnOrder__dlm.SObjectType) {
ssot__ReturnOrder__dlm returnOrder = (ssot__ReturnOrder__dlm)Test.createStubQueryRow(
sobjectType,
new Map<String, Object>{
'ssot__Id__c' => 'RO001',
'ssot__CustomerAccountId__c' => 'EXT123',
'Return_Order_Type__c' => 'Standard',
'ssot__ReturnOrderStatus__c' => 'Submitted',
'ssot__ReturnSubmittedDate__c' => Date.today()
}
);
return new List<sObject>{ returnOrder };

} else if (sobjectType == ssot__ReturnOrderProduct__dlm.SObjectType) {
ssot__ReturnOrderProduct__dlm product = (ssot__ReturnOrderProduct__dlm)Test.createStubQueryRow(
sobjectType,
new Map<String, Object>{
'ssot__Id__c' => 'ROP001',
'ssot__ReturnOrderId__c' => 'RO001',
'ssot__ProductId__c' => 'P001',
'ssot__ReturnOrderProductNumber__c' => 'Return123',
'ssot__ReturnedQuantityCount__c' => 2,
'ssot__TotalAmount__c' => 99.99,
'ssot__Description__c' => 'Defective Item'
}
);
return new List<sObject>{ product };

} else if (sobjectType == ssot__Product__dlm.SObjectType) {
ssot__Product__dlm prod = (ssot__Product__dlm)Test.createStubQueryRow(
sobjectType,
new Map<String, Object>{
'ssot__Id__c' => 'P001',
'ssot__Name__c' => 'Test Product',
'ssot__ProductCode__c' => 'TP123',
'ssot__ProductSKU__c' => 'P001',
'ssot__Description__c' => 'Product Desc'
}
);
return new List<sObject>{ prod };
}
return new List<sObject>();
}
}

}