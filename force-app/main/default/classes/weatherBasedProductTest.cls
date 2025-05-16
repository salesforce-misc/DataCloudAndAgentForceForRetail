@isTest
public class weatherBasedProductTest {

    // Test case for a valid weather condition with matching products
    @isTest
    static void testRecommendProducts_WithMatchingProducts() {
        // Create test products with descriptions that match "rain" keywords
        List<Product2> testProducts = new List<Product2>{
            new Product2(Name = 'Rain Runner', Description = 'Lightweight running shoes for rainy days', Type = 'Base'),
            new Product2(Name = 'Breathable Walkers', Description = 'Breathable walking shoes', Type = 'Base'),
            new Product2(Name = 'All-Weather Joggers', Description = 'Running shoes with breathable mesh', Type = 'Base'),
            new Product2(Name = 'Non-Matching', Description = 'Heavy-duty hiking boots', Type = 'Base') // Will be ignored
        };
        insert testProducts;

        Test.startTest();
        List<Product2> recommended = weatherBasedProduct.recommendProducts('rain');
        Test.stopTest();

        // Assert that products are returned
        System.assertNotEquals(0, recommended.size(), 'Should return matching products');
        System.assert(recommended.size() <= 3, 'Should return a maximum of 3 products');

        // Optional: Print recommended products for debugging
        System.debug('Recommended Products: ' + recommended);
    }

   
}