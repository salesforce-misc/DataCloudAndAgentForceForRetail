@isTest
private class ActivationAudienceResultTest {
    
    // Mock HTTP response class
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            
            if (req.getEndpoint().contains('/token')) {
                // OAuth token response
                res.setHeader('Content-Type', 'application/json');
                res.setBody('{"access_token": "mocked_token"}');
                res.setStatusCode(200);
            } else if (req.getEndpoint().contains('/queryv2')) {
                // Main query response
                String responseBody = '{ "data": [ ["{\\"SalesOrder\\":[{\\"OrderNumber\\":\\"SO123\\",\\"SoldToCustomerId\\":\\"0037y00000wOOjKAAW\\",\\"Product\\":[{\\"Product-Id\\":\\"P001\\",\\"Name\\":\\"Brake Pad\\",\\"Recall\\":true}]}]}"] ] }';
                res.setHeader('Content-Type', 'application/json');
                res.setBody(responseBody);
                res.setStatusCode(201);
            } else {
                res.setStatusCode(400);
            }

            return res;
        }
    }

    @isTest
    static void testGetAAQueryData() {
        // Set mock callout
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        // Prepare input
        ActivationAudienceResult.Request input = new ActivationAudienceResult.Request();
        input.contactId = '0037y00000wOOjKAAW';

        List<ActivationAudienceResult.Request> requests = new List<ActivationAudienceResult.Request>{ input };

        Test.startTest();
        List<ActivationAudienceResult.Response> responses = ActivationAudienceResult.getAAQueryData(requests);
        Test.stopTest();

        // Validate result
        system.debug('Responses key'+responses[0].value);
        System.assertEquals(1, responses.size(), 'Expected one response');
        System.assertEquals('productId', responses[0].key);
        System.assertEquals('Brake Pad', responses[0].value);
        System.assert(responses[0].message.contains('Brake Pad'), 'Expected message to mention Brake Pad');
    }
}