public class LightningOpenLeadController {
  
    @AuraEnabled
    public static List<Lead> getOpenLead(){
        User loggedInUser=[Select Id, ContactId, Contact.AccountId From User Where Id =:UserInfo.getUserId()];
        return   [Select Id, Name,Title, City, Company,CreatedDate,OwnerId, Owner.Name,LeadSource, ConvertedOpportunityId, ConvertedOpportunity.Name 
                     From Lead 
                     Where IsConverted = false and Owner.Type='Queue'
                     Order by CreatedDate desc limit 5];
    }
    
    @AuraEnabled
    public static List<Lead> updateLeadRecord(String leadId, String ownerId){
        Lead theLead = [Select id, Name, OwnerID from Lead where id =: leadId Limit 1];
        theLead.OwnerId = UserInfo.getUserID();
        update theLead; 
        return getOpenLead();
    }
     
    @AuraEnabled
    public static List<Lead> getMyLeads(){
        User loggedInUser=[Select Id, ContactId, Contact.AccountId From User Where Id =:UserInfo.getUserId()];
        return   [Select Id, Name, Title, City, Company, toLabel(Industry),CreatedDate, IsConverted, IsUnreadByOwner, OwnerId, Owner.Type,LeadSource, ConvertedOpportunityId, ConvertedOpportunity.Name 
                     From Lead Where IsConverted = false and Owner.id=:loggedInUser.id
                     Order by CreatedDate desc limit 5];      
    }
}