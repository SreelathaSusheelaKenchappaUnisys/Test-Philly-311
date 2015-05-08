trigger PopulateAccountName on Contact (before insert,before update) {
    id uid = userInfo.getUserId() ;
    id profileId = userInfo.getProfileID();
    Profile p = [select name from profile where id=: profileId];
    for(Contact c : Trigger.new) {
        if((p.name == 'City Council') || (p.name == 'Neighborhood Liaison') || (p.name == 'Police Department Liaisons')){
                try {
                        id accId;
                        user u = [select AccountId from user where  id=: uid]; 
                        if(u != null){
                            c.accountid = u.accountid;  
                        }
                } catch(Exception e) {
                    c.addError(e.getMessage());
                  }
            }    
    }
}