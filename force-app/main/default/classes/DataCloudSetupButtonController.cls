public class DataCloudSetupButtonController {
    
  //To get the install package details 
    @AuraEnabled
    public static Map<String,Boolean> getInstalledPackageDetails(){
        Map<String,Boolean> isPackageInstalled = new Map<String,Boolean>();
      try{            
            List<Profile> listOfProfile = [SELECT Id, UserLicenseId FROM Profile Where Name = 'Outfitters Profile' LIMIT 1];
            List<Install_Package_Settings_Enabled__mdt> listOfInstallPackages = [Select Id,Is_Order_and_OrderItem__c, Is_Data_ML_Created__c,Enable_Buyer_Group_Member__c,DeveloperName,Is_Sample_Data_Enable__c,Installation_Settings_Enabled__c, Outfitters_Settings_Enable__c,Is_Commerce_Data_Created__c,Data_Cloud_Permission__c from Install_Package_Settings_Enabled__mdt Where DeveloperName = 'Package_Settings_Enabled' Limit 1];
            if(!listOfInstallPackages.isEmpty()){
                isPackageInstalled.put('Assign Permissions For Objects',listOfInstallPackages[0].Installation_Settings_Enabled__c);
                //isPackageInstalled.put('Assign Permissions For Custom Object',listOfInstallPackages[0].Data_Cloud_Permission__c);
                isPackageInstalled.put('Create Commerce Data',listOfInstallPackages[0].Is_Commerce_Data_Created__c);
                isPackageInstalled.put('Create Test Data',listOfInstallPackages[0].Is_Sample_Data_Enable__c);
                isPackageInstalled.put('Create order and orderitem',listOfInstallPackages[0].Is_Order_and_OrderItem__c);
                isPackageInstalled.put('Create ML Data',listOfInstallPackages[0].Is_Data_ML_Created__c);
                if(!listOfProfile.isEmpty()){
                    isPackageInstalled.put('Create Buyer Group Member Data',listOfInstallPackages[0].Enable_Buyer_Group_Member__c);
                }else{
                    isPackageInstalled.put('Create Buyer Group Member Data',false);
                }
                
            }else if(!listOfInstallPackages.isEmpty() && listOfInstallPackages[0].Data_Cloud_Permission__c == true){
                isPackageInstalled.put('Assign Permissions For Objects',listOfInstallPackages[0].Installation_Settings_Enabled__c);
                //isPackageInstalled.put('Assign Permissions For Custom Object',listOfInstallPackages[0].Data_Cloud_Permission__c);
                isPackageInstalled.put('Create Commerce Data',listOfInstallPackages[0].Is_Commerce_Data_Created__c);
                isPackageInstalled.put('Create Test Data',listOfInstallPackages[0].Is_Sample_Data_Enable__c);
                isPackageInstalled.put('Create Buyer Group Member Data',listOfInstallPackages[0].Enable_Buyer_Group_Member__c);
                isPackageInstalled.put('Create order and orderitem',listOfInstallPackages[0].Is_Order_and_OrderItem__c);
               isPackageInstalled.put('Create opportunity ML',listOfInstallPackages[0].Is_Data_ML_Created__c);
            }else if(!listOfInstallPackages.isEmpty() && listOfInstallPackages[0].Is_Commerce_Data_Created__c == true){
                isPackageInstalled.put('Assign Permissions For Objects',listOfInstallPackages[0].Installation_Settings_Enabled__c);
                //isPackageInstalled.put('Assign Permissions For Custom Object',listOfInstallPackages[0].Data_Cloud_Permission__c);
                isPackageInstalled.put('Create Commerce Data',listOfInstallPackages[0].Is_Commerce_Data_Created__c);
                isPackageInstalled.put('Create Test Data',listOfInstallPackages[0].Is_Sample_Data_Enable__c);
                isPackageInstalled.put('Create Buyer Group Member Data',listOfInstallPackages[0].Enable_Buyer_Group_Member__c);
                isPackageInstalled.put('Create order and orderitem',listOfInstallPackages[0].Is_Order_and_OrderItem__c);
                isPackageInstalled.put('Create opportunity ML',listOfInstallPackages[0].Is_Data_ML_Created__c);
            }else if(!listOfInstallPackages.isEmpty() && listOfInstallPackages[0].Is_Sample_Data_Enable__c == true){
                isPackageInstalled.put('Assign Permissions For Objects',listOfInstallPackages[0].Installation_Settings_Enabled__c);
                //isPackageInstalled.put('Assign Permissions For Custom Object',listOfInstallPackages[0].Data_Cloud_Permission__c);
                isPackageInstalled.put('Create Commerce Data',listOfInstallPackages[0].Is_Commerce_Data_Created__c);
                isPackageInstalled.put('Create Test Data',listOfInstallPackages[0].Is_Sample_Data_Enable__c);
                isPackageInstalled.put('Create Buyer Group Member Data',listOfInstallPackages[0].Enable_Buyer_Group_Member__c);
                isPackageInstalled.put('Create order and orderitem',listOfInstallPackages[0].Is_Order_and_OrderItem__c);
                isPackageInstalled.put('Create opportunity ML',listOfInstallPackages[0].Is_Data_ML_Created__c);
            }else if(!listOfInstallPackages.isEmpty() && listOfInstallPackages[0].Enable_Buyer_Group_Member__c == true && !listOfProfile.isEmpty()){
                isPackageInstalled.put('Assign Permissions For Objects',listOfInstallPackages[0].Installation_Settings_Enabled__c);
               // isPackageInstalled.put('Assign Permissions For Custom Object',listOfInstallPackages[0].Data_Cloud_Permission__c);
                isPackageInstalled.put('Create Commerce Data',listOfInstallPackages[0].Is_Commerce_Data_Created__c);
                isPackageInstalled.put('Create Test Data',listOfInstallPackages[0].Is_Sample_Data_Enable__c);
                isPackageInstalled.put('Create Buyer Group Member Data',listOfInstallPackages[0].Enable_Buyer_Group_Member__c);
                isPackageInstalled.put('Create order and orderitem',listOfInstallPackages[0].Is_Order_and_OrderItem__c);
                isPackageInstalled.put('Create opportunity ML',listOfInstallPackages[0].Is_Data_ML_Created__c);
            }
            else if(!listOfInstallPackages.isEmpty() && listOfInstallPackages[0].Is_Order_and_OrderItem__c == true ){
                isPackageInstalled.put('Assign Permissions For Objects',listOfInstallPackages[0].Installation_Settings_Enabled__c);
               // isPackageInstalled.put('Assign Permissions For Custom Object',listOfInstallPackages[0].Data_Cloud_Permission__c);
                isPackageInstalled.put('Create Commerce Data',listOfInstallPackages[0].Is_Commerce_Data_Created__c);
                isPackageInstalled.put('Create Test Data',listOfInstallPackages[0].Is_Sample_Data_Enable__c);
                isPackageInstalled.put('Create Buyer Group Member Data',listOfInstallPackages[0].Enable_Buyer_Group_Member__c);
                isPackageInstalled.put('Create order and orderitem',listOfInstallPackages[0].Is_Order_and_OrderItem__c);
                isPackageInstalled.put('Create opportunity ML',listOfInstallPackages[0].Is_Data_ML_Created__c);
            }
          System.debug('isPackageInstalled'+ isPackageInstalled);
            return isPackageInstalled;
      } catch (Exception e) {
            System.debug('Error occurred:' + e.getMessage());
            throw new AuraHandledException('An Error Occured:' +e.getMessage());
            
        }
    }
    
    @AuraEnabled
    public static void orgSetupOnButtonClicked(Integer buttonId, String buttonLabel){
        try {
            if(buttonId == 1 && buttonLabel == 'Assign Permissions For Objects'){
                
                ObjectAndFieldLevelPermissionRetail.assignIntegrationPermSet();
                ObjectAndFieldLevelPermissionRetail.assignPermissionSetForOutfitters();
                ObjectAndFieldLevelPermissionRetail.callinsertFieldLevelPermsssionMethod();
                ObjectAndFieldLevelPermissionRetail.botUserForServiceAgent();
                ObjectAndFieldLevelPermissionRetail.assignCopyFieldPermission();
                
                system.debug('Inside-- Assign Permissions For Objects');
                Map<String, Object> metadataFieldValueMap = new Map<String, Object>();
                metadataFieldValueMap.put('Installation_Settings_Enabled__c', false);            
                metadataFieldValueMap.put('Is_Commerce_Data_Created__c', true);
                CustomMetadataUtils.updateCustomMetadata('Install_Package_Settings_Enabled__mdt','Package_Settings_Enabled', 'Package Settings Enabled',metadataFieldValueMap);
                
            }
           
             if(buttonId == 3 && buttonLabel == 'Create Test Data'){
                
                InsertDataForRetail.generateDemoData();
                updateCustomNonSteupMetadata();
                
            }
            
            if(buttonId == 2 && buttonLabel == 'Create Commerce Data'){
                
               GenerateCommerceCloudDataRetail.generateCommerceCloudRetailData();
               updateCustomNonSteupMetadataForTestData();
                
            }
            
             if(buttonId == 5 && buttonLabel == 'Create Buyer Group Member Data'){
                 
               ObjectAndFieldLevelPermissionRetail.createCustomerCommunityUser();
               ObjectAndFieldLevelPermissionRetail.assignCommunityUserToBuyerGroup();
              
                 updateCustomNonSteupMetadataForOpportunity();
                
            }
            
            if(buttonId == 4 && buttonLabel == 'Create order and orderitem'){
               
                insertDataForOrderAnddOrderItemRetail.generateOrderAndOrderItemRetail();
                updateCustomNonSteupMetadataForOrder();
                             
            }
            
             if(buttonId == 6 && buttonLabel == 'Create ML Data'){
              clsMLBuilderDataCreations.accountContactDataCreation();       //Account Contact is being created here  
              clsMLBuilderDataCreations.updateExistingContact(); // Existing Account is updating
            }
            
            
            
        } catch (Exception e) { 
            System.debug('Error occurred:' + e.getMessage());
            System.debug('Error Location:' + e.getStackTraceString());
            throw new AuraHandledException('An Error Occured:' +e.getMessage() + '\nLocation :'+ e.getStackTraceString());
            
        }       
    }  
    
    @future
    public static void updateCustomNonSteupMetadata(){ 
        Map<String, Object> metadataFieldValueMap = new Map<String, Object>();
        metadataFieldValueMap.put('Is_Order_and_OrderItem__c', true);
        metadataFieldValueMap.put('Is_Sample_Data_Enable__c', false);
        CustomMetadataUtils.updateCustomMetadata('Install_Package_Settings_Enabled__mdt','Package_Settings_Enabled', 'Package Settings Enabled',metadataFieldValueMap);
    }

    @future
    public static void updateCustomNonSteupMetadataForTestData(){
        Map<String, Object> metadataFieldValueMap = new Map<String, Object>();
        metadataFieldValueMap.put('Is_Commerce_Data_Created__c', false);
        metadataFieldValueMap.put('Is_Sample_Data_Enable__c', true);
        CustomMetadataUtils.updateCustomMetadata('Install_Package_Settings_Enabled__mdt','Package_Settings_Enabled', 'Package Settings Enabled',metadataFieldValueMap);
    }
    
    @future
    public static void updateCustomNonSteupMetadataForOrder(){
        Map<String, Object> metadataFieldValueMap = new Map<String, Object>();
        metadataFieldValueMap.put('Is_Order_and_OrderItem__c', false);
        metadataFieldValueMap.put('Enable_Buyer_Group_Member__c', true);
        CustomMetadataUtils.updateCustomMetadata('Install_Package_Settings_Enabled__mdt','Package_Settings_Enabled', 'Package Settings Enabled',metadataFieldValueMap);
    }
    
     @future
    public static void updateCustomNonSteupMetadataForOpportunity(){
        Map<String, Object> metadataFieldValueMap = new Map<String, Object>();
        metadataFieldValueMap.put('Enable_Buyer_Group_Member__c', false);
        metadataFieldValueMap.put('Is_Data_ML_Created__c', true);
        CustomMetadataUtils.updateCustomMetadata('Install_Package_Settings_Enabled__mdt','Package_Settings_Enabled', 'Package Settings Enabled',metadataFieldValueMap);
    }
    
}