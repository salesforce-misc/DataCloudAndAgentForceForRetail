@isTest
public with sharing class AgentAuthenticatorTest {
    @isTest
    static void testGetAuthSessionId() {
        // Call the method
        List<AgentAuthenticator.ActionResponse> responses = AgentAuthenticator.getAuthSessionId();

        // Assert the response is not null or empty
        System.assertNotEquals(null, responses, 'Response list should not be null');
        System.assertEquals(1, responses.size(), 'Response list should contain exactly one item');

        // Assert the session ID is not null or empty
        AgentAuthenticator.ActionResponse response = responses[0];
        System.debug('Auth Session ID: ' + response.authSessionId);
        System.assertNotEquals(null, response.authSessionId, 'AuthSession ID should not be null');
        System.assert(response.authSessionId.length() > 0, 'AuthSession ID should not be empty');
    }
}