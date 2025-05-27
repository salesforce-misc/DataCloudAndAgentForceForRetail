trigger UserTrigger on User (after insert) {
    
    if(trigger.isInsert){
        if(trigger.isAfter){
            
            Set<Id> userIds = new Set<Id>();
            String UserId;
            
            Profile prof=[Select Id,Name from Profile where name='Outfitters Customer Profile' Limit 1];
            system.debug('prof:'+prof);
            
            for (User u : Trigger.new) {
                
                if(u.ProfileId==prof.id && u.ContactId !=null){
                    userIds.add(u.Id);
                    system.debug('User Set:'+userIds);
                }
                
            }
            if(userIds.size()>0){
                ClsRetailSelfRegisterDataProvider.init(userIds);
            }
            
            
            
        }
    }
    
    
    
}