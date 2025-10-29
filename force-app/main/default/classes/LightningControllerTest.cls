@isTest
public class LightningControllerTest{
  
    static testMethod void unitTest(){
      
        LightningOpenLeadController.getOpenLead();
        LightningOpenLeadController.getMyLeads();
        Lead l = new Lead(LastName = 'Test1',Company='Salesforce');
        System.debug('New Lead ' + l.LastName);

        insert l;
        l = [SELECT Id,LastName FROM Lead WHERE Id =:l.Id];
        System.debug('New Lead Data: ' + l.LastName);
        LightningOpenLeadController.updateLeadRecord(l.Id,UserInfo.getUserId());

        

        
    }
    
}