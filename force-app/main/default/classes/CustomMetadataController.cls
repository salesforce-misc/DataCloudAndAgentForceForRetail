public with sharing class CustomMetadataController {
@AuraEnabled(cacheable=true)
    public static List<Retail_GuestUserQuestionnaire__mdt> getMetadataRecords(){
        return [SELECT Questions__c,Option1__c,Option2__c,Option3__c,
                Option4__c FROM Retail_GuestUserQuestionnaire__mdt LIMIT 3];
    }
}