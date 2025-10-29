public with sharing class GetAccounts {
    @AuraEnabled(cacheable=true)
    public static Account getAccountDetails(Id accountId) {
        Account accountDetails = [SELECT Id, Name, Membership_Number__pc, ShippingCity, ShippingState, ShippingPostalCode, 
        ShippingStreet, PhotoURL__c, PersonContactId, 
                                          (SELECT LifetimeValue__c, Propensity_to_purchase__c,
                                           AveragePurchaseValue__c,EngagementScore__c,Propensity_To_Churn__c 
                                           FROM Contacts 
                                           WHERE AccountId = :accountId 
                                           LIMIT 1)
                                      FROM Account
                                      WHERE Id = :accountId 
                                      LIMIT 1];
    
            return accountDetails;
        }
    }