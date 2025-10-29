public class ContactController {
    @AuraEnabled(cacheable=true)
    public static String getContactId(String UserId){
        User Cont = [Select Id,ContactId from User where Id=:UserId LIMIT 1];
        String ContactId= Cont.ContactId;
        return ContactId;
    }

}