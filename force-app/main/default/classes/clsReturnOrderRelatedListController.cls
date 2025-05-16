public without sharing class clsReturnOrderRelatedListController {
    public clsReturnOrderRelatedListController() {
 
    }
    public class ReturnOrderProductWrapper {
        @AuraEnabled public ssot__ReturnOrderProduct__dlm returnOrderProduct;
        @AuraEnabled public ssot__Product__dlm product;
    }
    @AuraEnabled(cacheable=true)
    public static List<ssot__ReturnOrder__dlm> getReturnOrderRecords(String ExternalId) {
        // Query ssot__ReturnOrder__dlm and join with Contact based on MembershipNumber
        List<ssot__ReturnOrder__dlm> returnOrder = [
            SELECT ssot__Id__c, Return_Order_Type__c, ssot__CustomerAccountId__c, ssot__ReturnOrderStatus__c, ssot__ReturnSubmittedDate__c
           FROM ssot__ReturnOrder__dlm WHERE  ssot__CustomerAccountId__c=:ExternalId
           
        ];

        return returnOrder;
    }
    @AuraEnabled(cacheable=true)
    public static List<ReturnOrderProductWrapper> getReturnOrderProductRecords(List<String> returnOrderIds) {
        // Query ssot__ReturnOrderProduct__dlm based on the provided returnOrderIds
        List<ssot__ReturnOrderProduct__dlm> returnOrderProduct = [
            SELECT ssot__Description__c,
                   ssot__Id__c,
                   ssot__ProductId__c,
                   ssot__ReturnOrderId__c,
                   ssot__ReturnOrderProductNumber__c,
                   ssot__ReturnedQuantityCount__c,
                   ssot__TotalAmount__c
            FROM ssot__ReturnOrderProduct__dlm 
            WHERE ssot__ReturnOrderId__c IN :returnOrderIds
        ];

        Set<String> productIds = new Set<String>();
        for (ssot__ReturnOrderProduct__dlm prod : returnOrderProduct) {
            if (prod.ssot__ProductId__c != null) {
                productIds.add(prod.ssot__ProductId__c);
            }
        }

        // Query the Product2 object to get the details of the products
        List<ssot__Product__dlm> products = [
            SELECT ssot__Description__c, ssot__Id__c, ssot__Name__c, ssot__ProductCode__c, ssot__ProductSKU__c
            FROM ssot__Product__dlm 
            WHERE ssot__ProductSKU__c IN :productIds
        ];

        // Map the product records by ProductId to quickly retrieve the product details later
        Map<String, ssot__Product__dlm> productMap = new Map<String, ssot__Product__dlm>();
        for (ssot__Product__dlm product : products) {
            productMap.put(product.ssot__ProductSKU__c, product);
        }

        // Prepare the results as a list of ReturnOrderProductWrapper
        List<ReturnOrderProductWrapper> results = new List<ReturnOrderProductWrapper>();
        for (ssot__ReturnOrderProduct__dlm prod : returnOrderProduct) {
            ReturnOrderProductWrapper wrapper = new ReturnOrderProductWrapper();
            wrapper.returnOrderProduct = prod;
            wrapper.product = productMap.get(prod.ssot__ProductId__c);
            results.add(wrapper);
        }

        return results; // Return the list of wrappers
    }
}