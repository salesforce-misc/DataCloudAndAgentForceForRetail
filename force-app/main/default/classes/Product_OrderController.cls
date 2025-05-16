public with sharing class Product_OrderController {
    
    // Define the custom class to hold the combined data
    public class CombinedData {
        public String Name;
        public String Weight;
        public String Category;
        public String Durability;
        public String Stars;
        public String Ventilation;
        public String Id;
        public Double Price;
    }
    
    @AuraEnabled(cacheable=true)
    public static String getProductDetail(String ProductId){
       system.debug('the product chosen'+ProductId);
        List<ssot__ProductAttribute__dlm> ProdAttributes = [Select ssot__ProductId__c, ssot__Name__c,Weight__c,Category__c,Durability__c,
               Stars__c, Ventilation__c FROM ssot__ProductAttribute__dlm WHERE ssot__ProductId__c =: ProductId LIMIT 1];
        List<ssot__Product__dlm> Prods= [SELECT ssot__Name__c FROM ssot__Product__dlm WHERE ssot__Id__c =: ProductId LIMIT 1];
        
        List<ssot__PriceBook__dlm> Pricebook = [SELECT ssot__Id__c,ssot__Name__c FROM ssot__PriceBook__dlm WHERE ssot__Name__c='Outfitters Price Book' ORDER BY ssot__Name__c ASC];
        String PriceBookId= Pricebook[0].ssot__Id__c;
        
        List<ssot__PriceBookEntry__dlm> PBEntries = [SELECT ssot__UnitListPriceAmount__c,ssot__PricebookId__c, ssot__ProductId__c
                                                   FROM ssot__PriceBookEntry__dlm 
													WHERE ssot__PricebookId__c=: PriceBookId 
                                                   AND ssot__ProductId__c =: ProductId];
            
        ssot__ProductAttribute__dlm prodAttribute = ProdAttributes.isEmpty() ? null : ProdAttributes[0];
         ssot__Product__dlm prod = Prods.isEmpty() ? null : Prods[0];
        ssot__PriceBookEntry__dlm PBEntry= PBEntries.isEmpty() ? null : PBEntries[0];

        // Populate the custom class with data
        CombinedData combinedData = new CombinedData();
        if (prodAttribute != null && prod != null  ) {
            combinedData.Name=prod.ssot__Name__c;
            combinedData.Weight=prodAttribute.Weight__c;
            combinedData.Category=prodAttribute.Category__c;
            combinedData.Durability=prodAttribute.Durability__c;
            combinedData.Stars=prodAttribute.Stars__c;
            combinedData.Ventilation=prodAttribute.Ventilation__c;
            combinedData.Id=prodAttribute.Id;
            combinedData.Price= PBEntry.ssot__UnitListPriceAmount__c;
        }
        system.debug('product detail'+combinedData);
        String combinedatainJson= JSON.serialize(combinedData);
        system.debug('product detail'+combinedData);
        return combinedatainJson;
    }
    
    @AuraEnabled(cacheable=true)
    public static String getMostRecentPurchase(String ContactId){
       System.debug('received contactid'+ContactId);
        // List<ssot__SalesOrder__dlm> salesorders = [SELECT ssot__Id__c,ssot__BillToContactId__c,ssot__ConfirmationDate__c FROM ssot__SalesOrder__dlm 
        //                                     				WHERE ssot__BillToContactId__c = : ContactId 
        //                                                   ORDER BY ssot__ConfirmationDate__c DESC LIMIT 1 ];
		// 	 String OrderId= salesorders[0].ssot__Id__c;
        /*List<Order> salesorders = [SELECT Id,BillToContactId,EffectiveDate FROM Order 
                                            				WHERE BillToContactId = : ContactId 
                                                          ORDER BY EffectiveDate DESC LIMIT 1];*/
        List<ssot__SalesOrder__dlm> salesorders = [SELECT ssot__Id__c,ssot__SoldToCustomerId__c,ssot__OrderStartDate__c FROM ssot__SalesOrder__dlm 
                                                            WHERE ssot__SoldToCustomerId__c=:ContactId 
                                                            ORDER BY ssot__OrderStartDate__c DESC LIMIT 1];
                                                                                                                                                                                                                                                                        // ORDER BY ssot__OrderStartDate__c DESC LIMIT 1 ]; 
        String OrderId = salesorders[0].ssot__Id__c;
       
         System.debug('orderid'+OrderId);
        
        List<ssot__SalesOrderProduct__dlm> salesProduct = [SELECT ssot__ProductId__c,ssot__SalesOrderId__c FROM ssot__SalesOrderProduct__dlm 
                                                     WHERE ssot__SalesOrderId__c =: OrderId LIMIT 1]; 
        String SalesProductId= salesProduct[0].ssot__ProductId__c;
        System.debug('ProductId'+SalesProductId);
        
        List<ssot__ProductAttribute__dlm> ProdAttributes = [SELECT ssot__ProductId__c,ssot__Name__c,Weight__c,Category__c,Durability__c,Stars__c, Ventilation__c FROM ssot__ProductAttribute__dlm
                                                        WHERE ssot__ProductId__c=: SalesProductId LIMIT 1];
        System.debug('ProdAttributes'+ProdAttributes);
        List<ssot__Product__dlm> Prods= [SELECT ssot__Id__c,ssot__Name__c FROM ssot__Product__dlm WHERE ssot__Id__c =: SalesProductId LIMIT 1];
        String ProductId= Prods[0].ssot__Id__c;
        System.debug('Prods'+Prods);
		 List<ssot__PriceBook__dlm> Pricebook = [SELECT ssot__Id__c,ssot__Name__c FROM ssot__PriceBook__dlm WHERE ssot__Name__c='Outfitters Price Book' ORDER BY ssot__Name__c ASC];
        String PriceBookId= Pricebook[0].ssot__Id__c;
        System.debug('PriceBookId'+PriceBookId);
        List<ssot__PriceBookEntry__dlm> PBEntries = [SELECT ssot__UnitListPriceAmount__c,ssot__PricebookId__c, ssot__ProductId__c
                                                   FROM ssot__PriceBookEntry__dlm 
													WHERE ssot__PricebookId__c=: PriceBookId 
                                                   AND ssot__ProductId__c =: ProductId];
        System.debug('PBEntries'+PBEntries);
        ssot__ProductAttribute__dlm prodAttribute = ProdAttributes.isEmpty() ? null : ProdAttributes[0];
        System.debug('prodAttribute'+prodAttribute);
        ssot__Product__dlm prod = Prods.isEmpty() ? null : Prods[0];
         System.debug('prod'+prod);
		ssot__PriceBookEntry__dlm PBEntry= PBEntries.isEmpty() ? null : PBEntries[0];
         System.debug('PBEntry'+PBEntry);
        // Populate the custom class with data
        CombinedData combinedData = new CombinedData();
        if (prodAttribute != null && prod != null ) {
            combinedData.Name=prod.ssot__Name__c;
            combinedData.Weight=prodAttribute.Weight__c;
            combinedData.Category=prodAttribute.Category__c;
            combinedData.Durability=prodAttribute.Durability__c;
            combinedData.Stars=prodAttribute.Stars__c;
            combinedData.Ventilation=prodAttribute.Ventilation__c;
            combinedData.Id=prodAttribute.Id;
			combinedData.Price= PBEntry.ssot__UnitListPriceAmount__c;
        }
       system.debug('product detail'+combinedData);
        String combinedatainJson= JSON.serialize(combinedData);
        system.debug('product detail'+combinedData);
        return combinedatainJson;   
    } 
}