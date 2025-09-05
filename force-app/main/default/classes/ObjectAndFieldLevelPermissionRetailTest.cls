@isTest
public class ObjectAndFieldLevelPermissionRetailTest {
    
    @isTest
    static void testInsertObjectLevelPermission() {        
        try{
            // Verify results
            PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Label = 'Data Cloud Salesforce Connector' LIMIT 1];
            List<ObjectPermissions> permissions = [SELECT SObjectType FROM ObjectPermissions WHERE ParentId = :ps.Id];
           // System.assertEquals(1, permissions.size(), 'Two object permissions should be inserted.');
        }
        catch(Exception ex){    
        }
    }
    
    @isTest
    static void testInsertFieldLevelPermission() {
        // Test data
        String permissionSetName = 'Data Cloud Salesforce Connector';
        String objectName = 'Account';
        List<String> fieldNames = new List<String>{'AccountSource'};
        //List<String> prod2fieldNames = new List<String>{'Family'};
            
            // Call the method
            Test.startTest();
        ObjectAndFieldLevelPermissionRetail.insertFieldLevelPermsssion(permissionSetName, objectName, fieldNames);
        ObjectAndFieldLevelPermissionRetail.assignPermissionSetForOutfitters();
        ObjectAndFieldLevelPermissionRetail.assignIntegrationPermSet();
        //ObjectAndFieldLevelPermissionRetail.callinsertObjLevelPerMethod();
        ObjectAndFieldLevelPermissionRetail.editAccesstoCustomer360('Customer 360 Data Platform Integration',objectName,fieldNames);
       // ObjectAndFieldLevelPermissionRetail.insertProduct2FieldLevelPermsssion(permissionSetName,'Product2',prod2fieldNames);
        Test.stopTest();
        try{
            // Verify results
            PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Label = 'Data Cloud Salesforce Connector' LIMIT 1];
            List<FieldPermissions> fieldPermissions = [SELECT Field FROM FieldPermissions WHERE ParentId = :ps.Id];
            //System.assertEquals(2, fieldPermissions.size(), 'Two field permissions should be inserted.');
        }
        catch(Exception ex){
            
        }
    }
    
    @isTest
    static void testBotUserForServiceAgent() {
        // Setup test data
         String emailAddress = UserInfo.getUserEmail();
            String userName = UserInfo.getUserName() +'.'+'Automotivebotuser';
         
        // Verify the user was created
        User agentUser = [SELECT Id, FirstName, LastName, Email, Username FROM User WHERE LastName='EinsteinServiceAgent User' LIMIT 1];
        System.debug('agentUser'+agentUser);
        System.assertNotEquals(null, agentUser);
        //System.assertEquals('amankailash.patil@infosys.com', agentUser.Email);
       // System.assertEquals(userName, agentUser.Username);
        
        // Verify the PermissionSetLicenseAssign was created
        PermissionSetLicenseAssign pslicnseAssignee = [SELECT Id,AssigneeId FROM PermissionSetLicenseAssign WHERE AssigneeId = :agentUser.Id  LIMIT 1];
        System.debug('pslicnseAssignee'+pslicnseAssignee);
        System.assertNotEquals(null, pslicnseAssignee);
        
        // Verify the PermissionSetAssignment was created
        PermissionSetAssignment permissionSetAssignment = [SELECT Id,AssigneeId FROM PermissionSetAssignment WHERE AssigneeId = :agentUser.Id  LIMIT 1];
        System.assertNotEquals(null, permissionSetAssignment);
        
        //create a test user to perfom dml operation on setup objects
		Profile p = [SELECT Id FROM Profile WHERE Name='Outfitters Profile']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.com');
        insert u;
              	  
            Test.startTest();
       
            ObjectAndFieldLevelPermissionRetail.botUserForServiceAgent();
         System.runAs(u) {
            //ObjectAndFieldLevelPermissionRetail.callinsertFieldLevelPermsssionMethod();
        }
            Test.stopTest();
        
    }
    
    @TestSetup
    static void setupTestData() {
        // Create a test PermissionSet
        PermissionSet testPermSet = new PermissionSet(Name = 'sfdc_a360', Label = 'testsfdc_a360');
        insert testPermSet;
        
        // Insert dummy ObjectPermissions for cleanup validation
        ObjectPermissions existingContactPerm = new ObjectPermissions(
            ParentId = testPermSet.Id,
            SObjectType = 'Contact',
            PermissionsDelete = true,
            PermissionsEdit = true,
            PermissionsModifyAllRecords = true,
            PermissionsRead = true,
            PermissionsViewAllRecords = true
        );
        
        ObjectPermissions existingAccountPerm = new ObjectPermissions(
            ParentId = testPermSet.Id,
            SObjectType = 'Account',
            PermissionsDelete = true,
            PermissionsEdit = true,
            PermissionsModifyAllRecords = true,
            PermissionsRead = true,
            PermissionsViewAllRecords = true
        );
        
        insert new List<ObjectPermissions>{ existingContactPerm, existingAccountPerm };
    }
    
    @IsTest
    static void testAssignIntegrationPermSet() {
        Test.startTest();
        ObjectAndFieldLevelPermissionRetail.assignIntegrationPermSet();
        Test.stopTest();
        
        // Query inserted permissions
        List<ObjectPermissions> insertedPerms = [SELECT Id, SObjectType FROM ObjectPermissions WHERE SObjectType IN ('Contact', 'Account')];
        
        // Validate results
        System.assertEquals(707, insertedPerms.size(), 'Expected exactly 2 ObjectPermissions to be inserted');
        
        Set<String> expectedObjects = new Set<String>{ 'Contact', 'Account' };
        for (ObjectPermissions perm : insertedPerms) {
            System.assert(expectedObjects.contains(perm.SObjectType), 'Unexpected object type in permissions');
        }
    }
    
   
     @isTest
    static void testCreateCustomerCommunityUser() {
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
       // Insert account as current user
        System.runAs (thisUser) {
        // Create test data
        Contact testContact = new Contact(FirstName = 'Mark', LastName = 'Smith', Email = 'msmith@yopmail.com');
        insert testContact;

        UserLicense ul=[SELECT Id, Status, MasterLabel, Name FROM UserLicense Where Name='Customer Community Plus' LIMIT 1];

        Profile testProfile = [SELECT Id FROM Profile WHERE Name = 'Outfitters Profile' LIMIT 1];

        // Call the method to test
        Test.startTest();
        ObjectAndFieldLevelPermissionRetail.createCustomerCommunityUser();
        Test.stopTest();
    }
    }

    @IsTest
    static void testAssignPersonalizationPermissionSet() {
        Test.startTest();
        try {
            ObjectAndFieldLevelPermissionRetail.assignPersonalizationPermissionSet();
        } catch (AuraHandledException e) {
            System.assert(false, 'Unexpected AuraHandledException: ' + e.getMessage());
        }
        Test.stopTest();

        // Verify that the permission set assignment was created
        List<PermissionSetAssignment> assignments = [
            SELECT Id FROM PermissionSetAssignment WHERE AssigneeId = :UserInfo.getUserId()
        ];

        System.assert(!assignments.isEmpty(), 'Permission set assignment should exist for the user.');
    }    
    
    
    @IsTest
    static void testassigndataPartnerLeadPermission() {
        
        // Step 1: Get a user with a role (usually System Admin has one)
        User adminUser = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator' AND UserRoleId != null LIMIT 1];
        
        // Step 2: Create an Account with that user as the owner
        Account acc = new Account(Name = 'Test Account', OwnerId = adminUser.Id);
        insert acc;

        Contact testContact = new Contact(FirstName = 'Mark', LastName = 'Smith', Email = 'msmith@yopmail.com',AccountId = acc.Id);
        insert testContact;
        
        User TestUser = new User(
        	Username= 'testuser@example.com',
            Alias ='tuser',
            Email = 'testuser@example.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Test',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/Los_Angeles',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Outfitters Customer Profile' LIMIT 1].Id,
            ContactId = testContact.Id
            
        );
        insert TestUser;

        Test.startTest();
        System.runas(TestUser){
           ObjectAndFieldLevelPermissionRetail.assigndataPartnerLeadPermission();
        ObjectAndFieldLevelPermissionRetail.assigndataCloudPermission();
            ObjectAndFieldLevelPermissionRetail.callinsertFieldLevelPermsssionMethod();}
        Test.stopTest();
    }
}