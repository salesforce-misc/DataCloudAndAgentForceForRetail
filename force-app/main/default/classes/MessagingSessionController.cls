public class MessagingSessionController {
    @AuraEnabled(cacheable=true)
    Public static String getSessionId(String CookieId){
        try{
            system.debug('CookieID'+ CookieId);
            MessagingSession messagingsesion=[Select Id From MessagingSession Where cookieId__c =: CookieId LIMIT 1];
            String sessionId= messagingsesion.Id;
                system.debug('sessionID'+ sessionId);
            return sessionId ;
           }
        catch(Exception e){
            system.debug('CookieID'+ CookieId);
            //log the exception
            System.debug('error fetching sessionId '+ e.getmessage());
            return e.getmessage();    
        }
    }
}