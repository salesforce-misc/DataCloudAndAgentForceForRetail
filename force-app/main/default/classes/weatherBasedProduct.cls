public class weatherBasedProduct {
    @AuraEnabled
    public static List<Product2> recommendProducts(String weatherCondition) {
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
    List<Product2> filteredProducts = new List<Product2>();
    List<Product2> allProducts = [SELECT Id, Name, Description, Product_Link__c FROM Product2 WHERE Description != NULL AND Type='Base'];
    system.debug('All Products:' + allProducts);
    for (Product2 product : allProducts) {
        for (String keyword : keywords) {
            if (product.Description.toLowerCase().contains(keyword)) {
                filteredProducts.add(product);
                break;
            }
        }
    }
    system.debug('Filtered Products' + filteredProducts);
    if (filteredProducts.isEmpty()) {
        throw new AuraHandledException('No suitable products found.');
    }
    
    Integer maxProducts = Math.min(3, filteredProducts.size()); // Limit to 3 products
    
    List<Product2> selectedProducts = new List<Product2>();
    for (Integer i = 0; i < maxProducts; i++) {
        selectedProducts.add(filteredProducts[i]);
    }
    
    return selectedProducts;
}
         
}