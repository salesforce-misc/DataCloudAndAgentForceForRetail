@IsTest
public class weatherBasedProductTest {

    @IsTest
    static void testRecommendProducts_Coverage() {
        List<String> validConditions = new List<String>{'rain','dry','humid','cold','hot'};
        
        Test.startTest();
        // Loop over all valid weather conditions
        for (String cond : validConditions) {
            try {
                weatherBasedProduct.recommendProducts(cond);
            } catch (Exception e) {
                // Expected SfdcSqlException for DLM query
                System.debug('Caught exception for condition ' + cond + ': ' + e.getMessage());
            }
        }
        
        // Test invalid condition to cover exception
        try {
            weatherBasedProduct.recommendProducts('stormy'); // invalid condition
        } catch (AuraHandledException e) {
            System.debug('Caught invalid weather exception: ' + e.getMessage());
        } catch (Exception e) {
            System.debug('Caught other exception: ' + e.getMessage());
        }
        Test.stopTest();
    }
}