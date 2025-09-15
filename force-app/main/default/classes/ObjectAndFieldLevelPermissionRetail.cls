public class ObjectAndFieldLevelPermissionRetail {
    
    public static void assigndataCloudPermission(){
        
        String currentUserId = UserInfo.getUserId(); 
        // Query the Permission Set
        PermissionSet pSet = [SELECT Id, Name FROM PermissionSet WHERE Name ='B2BBuyer'  LIMIT 1]; 
        List<PermissionSetAssignment> perassignmnt=[SELECT Id, PermissionSetId, AssigneeId FROM PermissionSetAssignment WHERE AssigneeId =:currentUserId AND PermissionSetId =:pSet.Id];
        if(perassignmnt.isEmpty()){
            system.debug('perassignmnt'+perassignmnt);
            // Create the Permission Set Assignment
            PermissionSetAssignment permSetAssign = new PermissionSetAssignment(
                AssigneeId = currentUserId,
                PermissionSetId = pSet.Id
            );
            // Insert the Permission Set Assignment
            insert permSetAssign;
            system.debug('permSetAssign1'+permSetAssign);
        }
    }
    //Partner lead management- //Are we creating any Lead in Retail? //Done
    public static void assigndataPartnerLeadPermission(){
        String currentUserId = UserInfo.getUserId(); 
        // Query the Permission Set
        PermissionSet pSet = [SELECT Id FROM PermissionSet WHERE Name ='B2BBuyer' limit 1];
        List<PermissionSetAssignment> perassignmnt=[SELECT Id, PermissionSetId, AssigneeId FROM PermissionSetAssignment WHERE AssigneeId =:currentUserId AND PermissionSetId =:pSet.Id];
        if(perassignmnt.isEmpty()){
            system.debug('perassignmnt'+perassignmnt);
            PermissionSetAssignment permSetAssign = new PermissionSetAssignment(
                AssigneeId = currentUserId,
                PermissionSetId = pSet.Id
            );
            insert permSetAssign;
            system.debug('permSetAssign2'+permSetAssign); 
        }
    }
    
    //Assign Read Access to Custom Field to Data Cloud Salesforce Connector //Pending
    //@AuraEnabled
    public static void callinsertFieldLevelPermsssionMethod(){
        
        try {
            List<String> fieldsToUpdateforOpportunity = new List<String>{'Custom_Primary_Contact__c'}; 
                ObjectAndFieldLevelPermissionRetail.insertFieldLevelPermsssion('Data Cloud Salesforce Connector','Opportunity',fieldsToUpdateforOpportunity); 
        } catch (Exception ex) {
            System.debug('Permissions already exist or failed: ' + ex.getMessage());
        }
        
        try {
            List<String> fieldsToUpdateforMessagingSession = new List<String>{'UsersId__c','User_Email__c','User__c','Contact__c','cookieId__c','UserId__c','Contact__c','AuthRequestTime__c','AuthSessionId__c'}; 
                ObjectAndFieldLevelPermissionRetail.insertFieldLevelPermsssion('Data Cloud Salesforce Connector','MessagingSession',fieldsToUpdateforMessagingSession);
        } catch (Exception ex) {
            System.debug('Permissions already exist or failed: ' + ex.getMessage());
        }
        
        try {
            List<String> fieldsToUpdateforPromotion = new List<String>{'Discount__c'};   
                ObjectAndFieldLevelPermissionRetail.insertFieldLevelPermsssion('Data Cloud Salesforce Connector','Promotion',fieldsToUpdateforPromotion);
        } catch (Exception ex) {
            System.debug('Permissions already exist or failed: ' + ex.getMessage());
        }
        
        /*List<String> fieldsToUpdateforLead = new List<String>{'Intrested_In__c','CookieId__c'};   
        ObjectAndFieldLevelPermissionRetail.insertFieldLevelPermsssion('Data Cloud Salesforce Connector','Lead',fieldsToUpdateforLead); */
        
        //List<String> fieldsToUpdateforUser = new List<String>{'Account_Id_Formula__c'};   
        //  ObjectAndFieldLevelPermissionRetail.insertFieldLevelPermsssion('Data Cloud Salesforce Connector','User',fieldsToUpdateforUser);
        try {
            List<String> fieldsToUpdateforAccount = new List<String>{'PhotoURL__c'};   
                ObjectAndFieldLevelPermissionRetail.insertFieldLevelPermsssion('Data Cloud Salesforce Connector','Account',fieldsToUpdateforAccount);
        } catch (Exception ex) {
            System.debug('Permissions already exist or failed: ' + ex.getMessage());
        }
        
        try {
            List<String> fieldsToUpdateforContact = new List<String>{'LifetimeValue__c','EngagementScore__c','AveragePurchaseValue__c','Propensity_to_purchase__c',
                'CategoryPreference__c','ChannelPreference__c','SubcategoryPreference__c','PreferredStore__c','OptInDate__c','OptInSource__c','Interest__c',
                'Gender__c','Age__c','Average_Order__c','Average_order_value__c','Average_Quantity_per_Order__c','Average_time_between_orders__c','Engagement_Frequency__c',
                'Churn_Score__c','Days_since_the_last_order__c','Customer_Lifetime_Value_CLV__c','Customer_Satisfaction_CSAT__c','Income_Level__c','Last_Purchased_Product_Categories__c',
                'Location__c','Most_Frequently_Purchased__c','Membership_Number__c','Maximum_order_value__c','Net_Promoter_Score_NPS__c','Number_of_Complaint__c','Number_of_Product_Return__c',
                'Number_of_orders_period__c','Number_of_Unique_Products_Purchased__c','Payment_Method__c','Recency_Of_Purchase__c','Total_Amount_Spent_LTV__c',
                'Total_amount_spent_period__c','Ordered_In_Last_30_Days__c','Propensity_To_Churn__c'}; 
                    ObjectAndFieldLevelPermissionRetail.insertFieldLevelPermsssion('Data Cloud Salesforce Connector','Contact',fieldsToUpdateforContact); 
        } catch (Exception ex) {
            System.debug('Permissions already exist or failed: ' + ex.getMessage());
        }
        
        try {
            List<String> fieldsToUpdateforContactForRetail = new List<String>{'Propensity_To_Churn__c'}; 
                    ObjectAndFieldLevelPermissionRetail.insertFieldLevelPermsssion('RetailPermissionSet','Contact',fieldsToUpdateforContactForRetail); 
        } catch (Exception ex) {
            System.debug('Permissions already exist or failed: ' + ex.getMessage());
        }
        
        try {
            List<String> fieldsToUpdateforProduct = new List<String>{'ManagedContentName__c','RT_Description__c','Total_Quantity__c','Recall_flag__c','Product_Catalog__c'};   
                ObjectAndFieldLevelPermissionRetail.insertFieldLevelPermsssion('Data Cloud Salesforce Connector','Product2',fieldsToUpdateforProduct);
        } catch (Exception ex) {
            System.debug('Permissions already exist or failed: ' + ex.getMessage());
        }
        
        try {
            List<String> fieldsToUpdateforProductAttribute = new List<String>{'Weight__c','Star__c','Ventilation__c','Size__c','Durability__c','Category__c'};   
                ObjectAndFieldLevelPermissionRetail.insertFieldLevelPermsssion('Data Cloud Salesforce Connector','ProductAttribute',fieldsToUpdateforProductAttribute);
        } catch (Exception ex) {
            System.debug('Permissions already exist or failed: ' + ex.getMessage());
        }
        try {
            List<String> fieldsToUpdateforProductItem = new List<String>{'next_stock_date__c', 'fulfilment_status_stock__c'};   
                ObjectAndFieldLevelPermissionRetail.insertFieldLevelPermsssion('Data Cloud Salesforce Connector','ProductItem',fieldsToUpdateforProductItem);
        } catch (Exception ex) {
            System.debug('Permissions already exist or failed: ' + ex.getMessage());
        }   
        
        try {
            List<String> fieldsToUpdateforOrder = new List<String>{'Contact__c','Product_Name__c'};  
                ObjectAndFieldLevelPermissionRetail.insertFieldLevelPermsssion('Data Cloud Salesforce Connector','Order',fieldsToUpdateforOrder);
        } catch (Exception ex) {
            System.debug('Permissions already exist or failed: ' + ex.getMessage());
        }
        
        try {
            List<String> fieldsToUpdateforOrderItem = new List<String>{'ProductName__c'};  
                ObjectAndFieldLevelPermissionRetail.insertFieldLevelPermsssion('Data Cloud Salesforce Connector','OrderItem',fieldsToUpdateforOrderItem);
        } catch (Exception ex) {
            System.debug('Permissions already exist or failed: ' + ex.getMessage());
        } 
        
        System.debug('Inside method callinsertFieldLevelPermsssionMethod'); 
        try {
            assigndataCloudPermission(); 
        } catch (Exception ex) {
            System.debug('Failed to assign Data Cloud permissions: ' + ex.getMessage());
        }
        
        try {
            assigndataPartnerLeadPermission();
        } catch (Exception ex) {
            System.debug('Failed to assign Partner Lead permissions: ' + ex.getMessage());
        }
        //assigndatavehicleassetfinance();
    }
    
    /*public static void assignPermission(String objectName, List<String> fields) {
try {
ObjectAndFieldLevelPermissionRetail.insertFieldLevelPermsssion('Data Cloud Salesforce Connector', objectName, fields);
} catch (Exception e) {
System.debug('Error assigning permission for ' + objectName + ': ' + e.getMessage());
}
} */
    
    public static void editAccesstoCustomer360(String permissionSetName, String objectName, List<String> fieldNames){
        PermissionSet permissionSetId = [Select Id from PermissionSet Where Label =: permissionSetName Limit 1];
        System.debug('## permissionSetId 360= '+permissionSetId);
        List<FieldPermissions> listOfFieldPermissions = new List<FieldPermissions>();
        for (String field : fieldNames) {
            FieldPermissions fieldPermission = new FieldPermissions();
            fieldPermission.Field = objectName + '.' + field;
            fieldPermission.SobjectType = objectName;
            fieldPermission.ParentId = permissionSetId.Id;
            fieldPermission.PermissionsEdit = true;
            fieldPermission.PermissionsRead = true;
            listOfFieldPermissions.add(fieldPermission);
        }
        if(!listOfFieldPermissions.isEmpty()){
            upsert listOfFieldPermissions;
            System.debug('## listOfFieldPermissions = '+listOfFieldPermissions);
        }
    }
    
    @future
    public static void assignCopyFieldPermission(){
        
        List<String> copyFieldAccess = new List<String>{'LifetimeValue__c','EngagementScore__c','AveragePurchaseValue__c'};  
            ObjectAndFieldLevelPermissionRetail.editAccesstoCustomer360('Customer 360 Data Platform Integration','Contact',copyFieldAccess);
    }
    
    //Pending
    public static void insertFieldLevelPermsssion(String permissionSetName, String objectName, List<String> fieldNames){
        PermissionSet permissionSetId = [Select Id from PermissionSet Where Label =: permissionSetName Limit 1];
        System.debug('## permissionSetId = '+permissionSetId);
        List<FieldPermissions> listOfFieldPermissions = new List<FieldPermissions>();
		List<FieldPermissions> fps= [SELECT Id,Field,ParentId,SobjectType,PermissionsEdit,PermissionsRead  FROM FieldPermissions Where ParentId =: permissionSetId.Id and SobjectType =:objectName and PermissionsRead = true];
        Map<String,Boolean> mapss = new Map<String,Boolean>();
		if(!fps.isEmpty()){            
            for(FieldPermissions fp : fps){
                mapss.put(fp.Field,fp.PermissionsRead);
            }
		}
        for (String field : fieldNames) {
			String obName = objectName + '.' + field;
			if((mapss.get(obName) != true && !mapss.isEmpty()) || mapss.isEmpty()){
				FieldPermissions fieldPermission = new FieldPermissions();
				fieldPermission.Field = objectName + '.' + field;
				fieldPermission.SobjectType = objectName;
				fieldPermission.ParentId = permissionSetId.Id;
				fieldPermission.PermissionsEdit = false;
				fieldPermission.PermissionsRead = true;
				listOfFieldPermissions.add(fieldPermission);//
			}            
        }
        if(!listOfFieldPermissions.isEmpty() && !Test.isrunningTest()){
            upsert listOfFieldPermissions;
            System.debug('## listOfFieldPermissions = '+listOfFieldPermissions);
        }
    }
    
    //Automation For automotive standard object , Assign read Access to retail object to Data Cloud Salesforce Connector //custom 360 is pending
    @AuraEnabled
    public static void assignPermissionSetForOutfitters(){
        try {
            String permissionSetName = 'sfdc_a360_sfcrm_data_extract'; 
            // Fetch the Permission Set ID
            PermissionSet permSet = [SELECT Id FROM PermissionSet WHERE Name = :permissionSetName LIMIT 1];
            system.debug('permSet'+permSet);
            if (permSet == null) {
                System.debug('Permission Set not found: ' + permissionSetName);
                return;
            }
            // List of Objects (Modify as needed)
            List<String> objectNames = new List<String>{
                'Order','Product2','ProductItem','Promotion','PromotionProduct','Pricebook2','pricebookEntry','OrderItem', 'ProductAttribute',
                    'ProductAttributeSet','ProductAttributeSetProduct','ProductCategoryProduct','CommerceEntitlementProduct','CommerceEntitlementPolicy',
                    'ProductCatalog','ProductCategory','Account','Contact','BuyerGroup','BuyerGroupMember', 'Lead','Opportunity', 'Location'};
                        system.debug('Object Name'+objectNames);
            // Fetch existing permissions for these objects under this Permission Set
            Map<String, ObjectPermissions> existingPerms = new Map<String, ObjectPermissions>();
            for (ObjectPermissions op : [SELECT Id, SObjectType 
                                         FROM ObjectPermissions 
                                         WHERE ParentId = :permSet.Id 
                                         AND SObjectType IN :objectNames]) {
                                             existingPerms.put(op.SObjectType, op);
                                         }
            // Prepare ObjectPermissions records to insert
            List<ObjectPermissions> objPermsToInsert = new List<ObjectPermissions>();
            for (String objectName : objectNames) {
                if (!existingPerms.containsKey(objectName)) {
                    ObjectPermissions objPerm = new ObjectPermissions(
                        ParentId = permSet.Id,
                        SObjectType = objectName,
                        PermissionsRead = true,
                        PermissionsViewAllRecords = true
                    );
                    System.debug('Object to insert'+objPerm);
                    objPermsToInsert.add(objPerm);
                } else {
                    System.debug('Skipping ' + objectName + ' - Permission already exists.');
                }
            } 
            
            // Insert only new permissions
            if (!objPermsToInsert.isEmpty()) {
                try {
                    insert objPermsToInsert;
                    System.debug('Object Permissions Assigned Successfully!');
                } catch (Exception e) {
                    System.debug('Error Assigning Permissions: ' + e.getMessage());
                }
            } else {
                System.debug('No new permissions needed - Everything is already assigned.');
            }
            
            // Query permiaaion set 
            String currentUserId = UserInfo.getUserId(); 
            List<PermissionSet> retailPS = [Select id, Name from PermissionSet where Name = 'RetailPermissionSet' limit 1];    
            List<PermissionSetAssignment> loyaltyPSetAssignmnt =  [SELECT Id,AssigneeId,PermissionSetId FROM PermissionSetAssignment WHERE  PermissionSetId =:retailPS[0].Id AND AssigneeId =:currentUserId LIMIT 1];
            
            system.debug('retail PS'+retailPS);
            
            if(!retailPS.isEmpty() && loyaltyPSetAssignmnt.isEmpty()){
                PermissionSetAssignment retailAdmin = new PermissionSetAssignment(
                    AssigneeId = currentUserId,
                    PermissionSetId = retailPS[0].Id
                );
                // Insert the Permission Set Assignment
                insert retailAdmin;
            }   
        } catch (Exception e) {
            System.debug('Error occurred:' + e.getMessage());
            throw new AuraHandledException('An Error Occured:' +e.getMessage());
            
        }
    }
    
    //Automation for Create an AgentUser
    @AuraEnabled
    public static void botUserForServiceAgent(){
        //to create Agent User
        try {
            String emailAddress = UserInfo.getUserEmail();
            String userName;
            if (Test.isRunningTest()){
                userName= UserInfo.getUserName() +'.'+'Outfittersbotuser1';
            }
            else{
                username= UserInfo.getUserName() +'.'+'agentuser1';
                system.debug('username'+username);
            }
            
            List<UserLicense> ul=[SELECT Id, Status, MasterLabel, Name FROM UserLicense Where Name='Einstein Agent' LIMIT 1];
            system.debug('ul'+ul);
            if(!ul.isEmpty()){
                Profile prof = [SELECT Id, UserLicenseId FROM Profile WHERE Name='Einstein Agent User' AND UserLicenseId =: ul[0].Id limit 1];
                system.debug('prof'+prof);
                if(prof !=null){
                    User usr = new user();
                    usr.FirstName = 'Agent';
                    usr.LastName='User';
                    usr.Email = emailAddress;
                    usr.Alias = 'agtuser';
                    usr.Username = userName;
                    usr.LocaleSidKey = 'en_US';
                    usr.TimeZoneSidKey = 'GMT';
                    usr.ProfileID = prof.id;
                    usr.LanguageLocaleKey = 'en_US';
                    usr.EmailEncodingKey = 'UTF-8';
                    insert usr;
                    system.debug('insert user'+usr);
                }
                map<string,string> mapOfPSwithAgentUser = new map<string,string>();
                
                User agentUser = [SELECT Id FROM User WHERE FirstName='Agent' AND LastName ='User' LIMIT 1];
                List<PermissionSet> permSet = [SELECT Id,Name FROM PermissionSet Where Name IN ('AgentforceServiceAgentUser', 'Outfitters_Service_Agent', 'CopilotSalesforceUser','GenieUserEnhancedSecurity')];//3
                List<PermissionSetLicense> pslicense= [SELECT DeveloperName,Id,MasterLabel FROM PermissionSetLicense Where MasterLabel ='Agentforce Service Agent User' LIMIT 1];
                List<PermissionSetAssignment> listOfPSA = [SELECT Id,AssigneeId,PermissionSetId FROM PermissionSetAssignment WHERE AssigneeId=:agentUser.Id and PermissionSetId IN:permSet];
                if(listOfPSA.size()>0){
                    for(PermissionSetAssignment psaRec:listOfPSA){
                        System.debug('psaRec -->'+psaRec);
                        mapOfPSwithAgentUser.put(psaRec.PermissionSetId,psaRec.AssigneeId);
                    } 
                }
                List<PermissionSetLicenseAssign> listOfPSLwithAgent = [SELECT id,AssigneeId,PermissionSetLicenseId FROM PermissionSetLicenseAssign 
                                                                       WHERE AssigneeId=:agentUser.id AND PermissionSetLicenseId=:pslicense[0].id];
                
                
                //Assign 'Agentforce Service Agent User' Permission Set License to Agent User
                
                if(listOfPSLwithAgent.isEmpty() && !pslicense.isEmpty()){
                    
                    PermissionSetLicenseAssign pslicnseAssignee = New PermissionSetLicenseAssign();
                    pslicnseAssignee.AssigneeId=agentUser.Id;
                    pslicnseAssignee.PermissionSetLicenseId =pslicense[0].Id;
                    if(!Test.isRunningTest()){
                        Insert pslicnseAssignee;
                        System.debug('pslicnseAssignee -->'+pslicnseAssignee);
                    }
                    
                }
                List<PermissionSetAssignment> psToAssign = new List<PermissionSetAssignment>();
                if(!permSet.isEmpty()){
                    for(PermissionSet ps : permSet){
                        if(!mapOfPSwithAgentUser.containskey(ps.id)){                           
                            PermissionSetAssignment permissionSetAssignment = new PermissionSetAssignment();
                            permissionSetAssignment.PermissionSetId = ps.Id;
                            permissionSetAssignment.AssigneeId = agentUser.Id;
                            psToAssign.add(permissionSetAssignment);
                        }
                        
                    }
                    
                    if(!psToAssign.isEmpty() && !Test.isRunningTest()){
                        insert psToAssign;
                    }       
                }
            }
        }   catch (Exception e) {
            System.debug('Error occurred:' + e.getMessage());
            throw new AuraHandledException('An Error Occured:' +e.getMessage());
        }
        
    }
    
    
    //Automation for assigning Permission Set to Integration User
    @AuraEnabled
    public static void assignIntegrationPermSet(){
        String permissionSetName='sfdc_a360';
        PermissionSet permSet = [SELECT Id FROM PermissionSet WHERE Name = :permissionSetName LIMIT 1];
        System.debug('Permission Set After Query ' + permSet);
        if (permSet == null) {
            System.debug('Permission Set not found: ' + permissionSetName);
            return;
        }
        String objectName = 'Contact';
        String objectAccount = 'Account';
        
        List<ObjectPermissions> existingPermAcc = [SELECT Id, SObjectType 
                                                   FROM ObjectPermissions 
                                                   WHERE ParentId = :permSet.Id 
                                                   AND SObjectType= :objectAccount  LIMIT 1 ];
        System.debug('Existing Permission Set Check'+existingPermAcc);
        if(existingPermAcc!=null){
            System.debug('Contact Permissions already exist-Skipping');
            delete existingPermAcc;
        }
        List<ObjectPermissions> existingPerm = [SELECT Id, SObjectType 
                                                FROM ObjectPermissions 
                                                WHERE ParentId = :permSet.Id 
                                                AND SObjectType= :objectName LIMIT 1 ];
        System.debug('Existing Permission Set Check'+existingPerm);
        if(existingPerm!=null){
            System.debug('Contact Permissions already exist-Skipping');
            delete existingPerm;
        }
        ObjectPermissions contactPerm = new ObjectPermissions(
            ParentId = permSet.Id,
            SObjectType = objectName,
            PermissionsDelete = true,
            PermissionsEdit=true,
            PermissionsModifyAllRecords=true,
            PermissionsRead = true,
            PermissionsViewAllRecords=true
        );
        
        ObjectPermissions accPerm = new ObjectPermissions(
            ParentId = permSet.Id,
            SObjectType = objectAccount,
            PermissionsDelete = true,
            PermissionsEdit=true,
            PermissionsModifyAllRecords=true,
            PermissionsRead = true,
            PermissionsViewAllRecords=true
        );
        try{
            insert contactPerm;
            insert accPerm;
            
            system.debug('Contact object Permission Set Assigned Successfully');
        }catch(Exception e){
            System.debug('Error Assigning Permissions'+e.getMessage());
        }
    }
    //Create Community User //Done
    public static void createCustomerCommunityUser(){
        try {
            List<Contact> contactRecord = [SELECT Id, FirstName, Name, LastName, Email FROM Contact WHERE Name = 'Mark Smith' AND Email='msmith@yopmail.com' LIMIT 1];
            List<UserLicense> ul=[SELECT Id, Status, MasterLabel, Name FROM UserLicense Where Name='Customer Community Plus' LIMIT 1];
            List<Profile> profList = [SELECT Id, UserLicenseId FROM Profile Where Name = 'Outfitters Profile' LIMIT 1];
            
            if (!contactRecord.isEmpty() && !profList.isEmpty()) {
                String emailAddress = contactRecord[0].Email;
                System.debug('community user email ->'+emailAddress);
                String userName = emailAddress +'.'+'customerUser'+System.now().format('ddMMyyyyHHmmss').substring(8,14);
                
                User usr = new user();
                usr.FirstName = 'Mark';
                usr.LastName='smith';
                usr.Email = emailAddress;
                usr.Alias = 'msmith';
                usr.Username = userName;
                usr.LocaleSidKey = 'en_US';
                usr.TimeZoneSidKey = 'GMT';
                usr.ProfileID = profList[0].Id;
                usr.LanguageLocaleKey = 'en_US';
                usr.EmailEncodingKey = 'UTF-8';
                usr.ContactId = contactRecord[0].Id;
                //usr.IsPortalEnabled = true;
                insert usr;
                System.debug(usr + 'usr');
                
                User userRecord = [SELECT Id, IsPortalEnabled, ProfileId FROM User WHERE ContactId = :contactRecord[0].Id LIMIT 1]; 
                If(userRecord != NULL){
                    userRecord.IsPortalEnabled = true;
                    UPDATE userRecord;
                }
                List<PermissionSet> pSet = [SELECT Id FROM PermissionSet WHERE Name ='Commerce_Shopper' LIMIT 1]; //Check
                
                //List<PermissionSet> pSet = [SELECT Id FROM PermissionSet WHERE Name ='SDO_Community_Customer_Community_Plus_Permissions' LIMIT 1];//Need to check
                System.debug('Retail perm set'+pSet);
                // Create the Permission Set Assignment
                if(!pSet.isEmpty()){
                    System.debug('Retail perm set 333'+pSet);
                    PermissionSetAssignment permSetAssign = new PermissionSetAssignment(
                        AssigneeId = usr.Id,
                        PermissionSetId = pSet[0].Id
                    );
                    // Insert the Permission Set Assignment
                    insert permSetAssign;
                }
                List<PermissionSet> permSet = [SELECT Id FROM PermissionSet WHERE Name ='B2BBuyer' LIMIT 1]; //Need to check
                
                if(!permSet.isEmpty()){
                    // Create the Permission Set Assignment
                    PermissionSetAssignment permSetAssign = new PermissionSetAssignment(
                        AssigneeId = usr.Id,
                        PermissionSetId = permSet[0].Id
                    );
                    // Insert the Permission Set Assignment
                    Insert permSetAssign;
                }                
            }
        } catch (Exception e) {
            System.debug('Exception: ' + e.getMessage());
        }
        
    }
    
    
    //assign account buyer group 
    @future
    public static void assignCommunityUserToBuyerGroup(){
        List<BuyerGroup> buyerGroups = [SELECT Id, Name FROM BuyerGroup WHERE Name IN ('Outfitters Authenticated users', 'Outfitters Buyer Group')]; //Outfitters Authenticated users / Outfitters Buyer Group
        system.debug('buyerGroups'+buyerGroups);
        List<Contact> con = [SELECT Id,AccountId,Email FROM Contact WHERE Email ='dmacintosh@yopmail.com'];
        system.debug('con'+con[0].AccountId);
        if(!con.isEmpty() && buyerGroups != null){
            /*BuyerGroupMember buyerGroupMember = new BuyerGroupMember(BuyerId = con[0].AccountId,BuyerGroupId= buyerGroupId);
insert buyerGroupMember;
} */
            List<BuyerGroupMember> buyerGroupMembers = new List<BuyerGroupMember>();
            
            for (BuyerGroup bg : buyerGroups) {
                BuyerGroupMember buyerGroupMember = new BuyerGroupMember(
                    BuyerId = con[0].AccountId,
                    BuyerGroupId = bg.Id
                );
                buyerGroupMembers.add(buyerGroupMember);
            }
            insert buyerGroupMembers;
        }
    } 
    
    public static void assignPersonalizationPermissionSet() {
        try {
            String permissionSetName = 'Personalization'; 
            List<PermissionSet> permSetList = [SELECT Id FROM PermissionSet WHERE Name = :permissionSetName LIMIT 1];
            if (permSetList.isEmpty()) {
                System.debug('Permission Set not found: ' + permissionSetName);
                return;
            }
            PermissionSet permSet = permSetList[0];
            
            String currentUserId = UserInfo.getUserId();
            List<PermissionSetAssignment> existingAssignments = [
                SELECT Id FROM PermissionSetAssignment 
                WHERE AssigneeId = :currentUserId AND PermissionSetId = :permSet.Id
            ];
            
            if (existingAssignments.isEmpty()) {
                PermissionSetAssignment psa = new PermissionSetAssignment(
                    AssigneeId = currentUserId,
                    PermissionSetId = permSet.Id
                );
                insert psa;
                System.debug('Permission set "Personalization" assigned to current user.');
            } else {
                System.debug('Current user already has the "Personalization" permission set.');
            }
            
        } catch (Exception e) {
            System.debug('Error assigning personalization permissions: ' + e.getMessage());
            throw new AuraHandledException('An Error Occurred: ' + e.getMessage());
        }
    }
    
}