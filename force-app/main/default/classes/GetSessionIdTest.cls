@isTest
public with sharing class GetSessionIdTest {
    @isTest
    static void testIsLoggedIn() {
        // Call the method
        Boolean result = GetSessionId.isLoggedIn();
        
        // Assert that a session ID exists in a test context
        System.assertEquals(true, result, 'User should be logged in during test context.');
    }
}