public with sharing class GetSessionId {
    @AuraEnabled( cacheable=true )
    public static Boolean isLoggedIn() {
        return UserInfo.getSessionId()!=null;
    }
}