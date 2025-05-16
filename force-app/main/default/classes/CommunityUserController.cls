public with sharing class CommunityUserController {
    @AuraEnabled(cacheable=true)
        public static User getCommunityUserId() {
            System.debug('current user id ->'+UserInfo.getUserId());
            //return UserInfo.getUserId();

            User currentUser = [SELECT Id, ContactId, FirstName,LastName , Email FROM User WHERE Id = :UserInfo.getUserId()];
            System.debug('current user  ->'+currentUser);

            return currentUser;
        }
    }