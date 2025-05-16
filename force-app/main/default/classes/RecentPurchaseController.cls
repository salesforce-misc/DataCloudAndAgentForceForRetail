public with sharing class RecentPurchaseController {

    @AuraEnabled(cacheable=true)
    public static List<OrderItemWrapper> getRecentProducts(Id accountId) {
        List<OrderItemWrapper> results = new List<OrderItemWrapper>();

        ssot__Account__dlm acc = [
            SELECT ssot__Id__c, ssot__Name__c, Is_Person_Account__c, Contact_Id__c 
            FROM ssot__Account__dlm
            WHERE ssot__Id__c = :accountId
            LIMIT 1
        ];

        Id contactId;
        Boolean isPersonAccount = acc.Is_Person_Account__c != null && acc.Is_Person_Account__c.toLowerCase() == 'true';
        Boolean hasContactId = acc.Contact_Id__c != null;

        if (!(isPersonAccount && hasContactId)) {
            return results;
        }

        contactId = acc.Contact_Id__c;

        List<ssot__SalesOrder__dlm> salesOrders = [
            SELECT ssot__Id__c, ssot__OrderStartDate__c, ssot__SoldToCustomerId__c
            FROM ssot__SalesOrder__dlm
            WHERE ssot__SoldToCustomerId__c = :contactId
            ORDER BY ssot__OrderStartDate__c DESC
            LIMIT 5
        ];

        Set<Id> salesOrderIds = new Set<Id>();
        for (ssot__SalesOrder__dlm salesOrder : salesOrders) {
            salesOrderIds.add(salesOrder.ssot__Id__c);
        }

        List<ssot__SalesOrderProduct__dlm> salesOrderProducts = [
            SELECT ssot__Id__c, ssot__OrderedQuantity__c, ssot__UnitPriceAmount__c, ssot__SalesOrderId__c, ssot__ProductId__c
            FROM ssot__SalesOrderProduct__dlm
            WHERE ssot__SalesOrderId__c IN :salesOrderIds
        ];

        Set<Id> productIds = new Set<Id>();
        for (ssot__SalesOrderProduct__dlm orderProduct : salesOrderProducts) {
            if (orderProduct.ssot__ProductId__c != null) {
                productIds.add(orderProduct.ssot__ProductId__c);
            }
        }

        List<ssot__Product__dlm> productlist = [
            SELECT ssot__Id__c, ssot__Name__c, ssot__Description__c, 
                   ssot__ProductFamily__c, ManagedContentName__c
            FROM ssot__Product__dlm 
            WHERE ssot__Id__c IN :productIds
        ];

        Map<Id, ssot__Product__dlm> productsMap = new Map<Id, ssot__Product__dlm>();
        for (ssot__Product__dlm prod : productlist) {
            productsMap.put(prod.ssot__Id__c, prod);
        }

        // Get the Salesforce Org Domain and construct the Visualforce base URL
     /*   String orgDomain = URL.getOrgDomainUrl().toExternalForm();
        String baseURL = orgDomain.replace('.my.salesforce.com', '.vf.force.com'); 
        Long timestamp = DateTime.now().getTime();

        Map<Id, String> productImageURLs = new Map<Id, String>();
        for (ssot__Product__dlm prod : productlist) {
            if (prod.ManagedContentName__c != null) {
                String contentUrl = baseURL + '/resource/' + String.valueOf(timestamp) + '/' + prod.ManagedContentName__c;
                productImageURLs.put(prod.ssot__Id__c, contentUrl);
            }
        }*/

        Integer productCount = 0;

        for (ssot__SalesOrder__dlm salesOrder : salesOrders) {
            for (ssot__SalesOrderProduct__dlm orderProduct : salesOrderProducts) {
                if (orderProduct.ssot__SalesOrderId__c == salesOrder.ssot__Id__c && orderProduct.ssot__ProductId__c != null) {
                    ssot__Product__dlm product = productsMap.get(orderProduct.ssot__ProductId__c);
                    if (product != null) {
                        //String imageUrl = productImageURLs.get(product.ssot__Id__c);
                        results.add(new OrderItemWrapper(
                            product.ssot__Name__c,
                            product.ssot__Description__c,
                            product.ssot__ProductFamily__c,
                            orderProduct.ssot__OrderedQuantity__c,
                            orderProduct.ssot__UnitPriceAmount__c,
                            salesOrder.ssot__OrderStartDate__c,
                            product.ManagedContentName__c
                        ));
                        productCount++;
                    }
                }
                if (productCount >= 3) break;
            }
            if (productCount >= 3) break;
        }

        return results;
    }

    public class OrderItemWrapper {
        @AuraEnabled public String productName;
        @AuraEnabled public String description;
        @AuraEnabled public String family;
        @AuraEnabled public Decimal quantity;
        @AuraEnabled public Decimal unitPrice;
        @AuraEnabled public Datetime orderDate;
        @AuraEnabled public String imageUrl; 

        public OrderItemWrapper(String productName, String description, String family,
                                Decimal quantity, Decimal unitPrice, Datetime orderDate,
                                String imageUrl) {
            this.productName = productName;
            this.description = description;
            this.family = family;
            this.quantity = quantity;
            this.unitPrice = unitPrice;
            this.orderDate = orderDate;
            this.imageUrl = imageUrl;
        }
    }
}