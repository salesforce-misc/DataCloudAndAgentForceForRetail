@IsTest
public class WeatherBasedProductInvocableTest {

    // ----------------------------
    // Stub Provider for DLM Query
    // ----------------------------
    private class ProductStubProvider extends SoqlStubProvider {
        public override List<SObject> handleSoqlQuery(Schema.SObjectType sot, String soql, Map<String, Object> bindVars) {
            if (sot == ssot__Product__dlm.SObjectType) {
                // Return multiple products to cover the for loop and maxProducts logic
                List<SObject> products = new List<SObject>();
                for (Integer i = 1; i <= 4; i++) {
                    ssot__Product__dlm product = (ssot__Product__dlm)
                        Test.createStubQueryRow(
                            ssot__Product__dlm.SObjectType,
                            new Map<String, Object>{
                                'ssot__Id__c' => 'StubProdId' + i,
                                'ssot__Name__c' => 'Stub Product ' + i,
                                'ssot__Description__c' => 'Lightweight running shoes for rainy days ' + i
                            }
                        );
                    products.add(product);
                }
                return products;
            }
            return new List<SObject>();
        }
    }

    // ----------------------------
    // Test valid weather input
    // ----------------------------
    @IsTest
    static void testValidWeather_Rain() {
        WeatherBasedProductInvocable.Request req = new WeatherBasedProductInvocable.Request();
        req.weatherData = 'rain';
        List<WeatherBasedProductInvocable.Request> requests = new List<WeatherBasedProductInvocable.Request>{req};

        // Register the stub for ssot__Product__dlm
        ProductStubProvider stub = new ProductStubProvider();
        Test.createSoqlStub(ssot__Product__dlm.SObjectType, stub);

        Test.startTest();
        List<WeatherBasedProductInvocable.Response> responses = WeatherBasedProductInvocable.getInputQuestion(requests);
        Test.stopTest();

        // Check that the response has product IDs (max 3)
        System.assertNotEquals(0, responses.size(), 'Response list should not be empty');
        System.assertEquals(3, responses[0].Prompt.size(), 'Should return maximum 3 products');
        System.assertEquals('StubProdId1', responses[0].Prompt[0], 'First product ID should match stub');
    }

    // ----------------------------
    // Test invalid weather input
    // ----------------------------
    @IsTest
    static void testInvalidWeather() {
        WeatherBasedProductInvocable.Request req = new WeatherBasedProductInvocable.Request();
        req.weatherData = 'stormy';
        List<WeatherBasedProductInvocable.Request> requests = new List<WeatherBasedProductInvocable.Request>{req};

        Boolean exceptionThrown = false;

        try {
            Test.startTest();
            WeatherBasedProductInvocable.getInputQuestion(requests);
            Test.stopTest();
        } catch (AuraHandledException ex) {
            exceptionThrown = true;
            System.debug('Caught exception: ' + ex.getMessage());
        }

        System.assert(exceptionThrown, 'AuraHandledException should be thrown for invalid weather');
    }

    // ----------------------------
    // Cover inner Request and Response classes
    // ----------------------------
    @IsTest
    static void testInnerClasses() {
        WeatherBasedProductInvocable.Request dummyReq = new WeatherBasedProductInvocable.Request();
        dummyReq.weatherData = 'rain';

        WeatherBasedProductInvocable.Response dummyRes = new WeatherBasedProductInvocable.Response();
        dummyRes.Prompt = new List<String>{'prod1', 'prod2'};
    }
}