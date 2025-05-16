@isTest(SeeAllData=false)
public class callServiceClassAPITest {
    
	@isTest
    static void testGetContactSegmentStatusAndSessionId() {
        // Create test Account
    Account acc = new Account(Name = 'Test Account');
    insert acc;

    // Create test Contact with matching ID
    Contact con = new Contact(
        
        LastName = 'Test Contact',
        AccountId = acc.Id
    );
    insert con;
        Test.setMock(HttpCalloutMock.class, new callServiceClassAPIMock());
        Test.startTest();
            String sessionId = GetCustomersFromSegment.getSessionIdFromVFPage();
            System.assertEquals('MY_SESSION_ID', sessionId);

            String accountId = GetCustomersFromSegment.getContactSegmentStatus(acc.Id);
	        String id = GetCustomersFromSegment.getContactSegmentStatus('0037y00000wOOhXAAW');
			system.debug('Id'+id);
        	system.debug('AccountID'+accountId);
         	System.assertNotEquals(null, accountId);
    		System.assertEquals(acc.Id, accountId);
        
            //System.assertNotEquals(accountId, accountId); // Or assert based on expected AccountId if inserted
        Test.stopTest();
    }
}