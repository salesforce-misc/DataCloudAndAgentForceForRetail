public class weatherBasedProduct {
    @AuraEnabled
    public static List<ssot__Product__dlm> recommendProducts(String weatherCondition) {
    weatherCondition = weatherCondition.trim().toLowerCase();
        
    // Define mapping of weather conditions to keywords
    Map<String, List<String>> conditionKeywords = new Map<String, List<String>>{
        'rain' => new List<String>{'breathable', 'lightweight','running','walking'},
        'dry' => new List<String>{'breathable', 'lightweight','running','walking'},
        'humid' => new List<String>{'moisture-wicking', 'ventilated','running'},
        'cold' => new List<String>{'thermal', 'insulated', 'warm','running'},
        'hot' => new List<String>{'cooling', 'UV-protect','running','walking'}
    };
    system.debug('Condition Keywords:' + conditionKeywords);
    if (!conditionKeywords.containsKey(weatherCondition)) {
        throw new AuraHandledException('Invalid weather condition provided.');
    }
    
    // Get keywords based on weather condition
    List<String> keywords = conditionKeywords.get(weatherCondition);
    system.debug('Keywords:' + conditionKeywords);
    // Fetch products that match the condition
    List<ssot__Product__dlm> filteredProducts = new List<ssot__Product__dlm>();
    system.debug('Before All Products Query');
    //List<Product2> allProducts = Database.query('SELECT Id, Name, Description, Product_Link__c FROM Product2 WHERE Description != NULL AND Type=\''+'Base'+'\' and isActive = true');
    List<ssot__Product__dlm> allProducts = [SELECT ssot__Id__c,ssot__Name__c,ssot__Description__c FROM ssot__Product__dlm Where ssot__Description__c != NULL and ssot__ProductType__c = 'Base' and IsActive__c = 'true'];
    system.debug('After All Products Query');
    system.debug('All Products:' + allProducts);
    for (ssot__Product__dlm product : allProducts) {
        System.debug('## ssot__Description = '+product.ssot__Description__c);
        if(product.ssot__Description__c != NULL && product.ssot__Description__c != ''){
            for (String keyword : keywords) {                
                System.debug('## keyword = '+keyword);
                if (product.ssot__Description__c.toLowerCase().contains(keyword)) {
                    filteredProducts.add(product);
                    break;
                }
            }
        }
        
    }
    system.debug('Filtered Products' + filteredProducts);
    if (filteredProducts.isEmpty()) {
        throw new AuraHandledException('No suitable products found.');
    }
    
    Integer maxProducts = Math.min(3, filteredProducts.size()); // Limit to 3 products
    System.debug('## maxProducts = '+maxProducts);
    List<ssot__Product__dlm> selectedProducts = new List<ssot__Product__dlm>();
    for (Integer i = 0; i < maxProducts; i++) {
        selectedProducts.add(filteredProducts[i]);
    }
    System.debug('## selectedProducts = '+selectedProducts);
    return selectedProducts;
}
         
}