trigger AccountNameUpdateTrigger on Contact (before insert,before update){/**/

    Boolean noAccount = false;
    list<id> cid = new list<id>();
    for (Contact c1 : Trigger.new) {
        cid.add(c1.id);
        if (c1.AccountId == null) {
         
           Id profileId = userinfo.getProfileId();
           Id contactid = userinfo.getuserId();
            
           list<User> c2 = [select Contactid from user where id =: contactid];  
           list<Contact> c3 = [Select Accountid,Name from contact where id =: c2[0].contactid];    
           list<Profile> profileName = [Select Id from Profile where Id=:profileId];
       
           if ((ProfileName[0].Id=='00e1600000103vS')){            
                c1.AccountId = c3[0].Accountid;                 
           } 
           
           else if ((ProfileName[0].Id == '00eG000000103qD')){
                 
                 Account a = new Account();
                 
                 list<Account> a1 = [Select Name,Id from Account where Name =: c1.Name Limit 1];
                 if(a1.size() == 0){
                // a.Name = c3[0].Name;
                 
                  string cName = (c1.FirstName + ' ' + c1.LastName);
                    a.Name = cName;
                 //a.IsPartner = true;
                 insert a;               
                 c1.AccountId = a.Id;
                            }
           else 
           c1.AccountId = a1[0].Id;
           }                
        }                        
    }
}