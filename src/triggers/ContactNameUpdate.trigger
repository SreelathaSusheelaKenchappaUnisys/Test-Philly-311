trigger ContactNameUpdate on Case (after insert,after update) {
  Boolean noContact = false;
         list<id> cid = new list<id>();
         for (Case c : Trigger.new) {
             cid.add(c.id);
             if (c.ContactId == null) {
                 noContact = true;    
             break;
             }
         }
          if (noContact) {
        Id profileId = userinfo.getProfileId();
        String Contact = userinfo.getName()  ;
        list<Profile> profileName=[Select Id from Profile where Id=:profileId];
        list<Contact> ContactName=[Select id, Name from Contact where Name =:Contact];
          if ((ProfileName[0].Id=='00e11000000Lx2B')|| (ProfileName[0].Id == '00e11000000LxBS') || (ProfileName[0].Id=='00eG0000000zzC9')||(ProfileName[0].Id=='00eG0000000zzC7') ||(ProfileName[0].Id=='00eG0000000zJev'))
         
         {
               
             
             List<Case> con = [Select id, ContactId from Case where id in: cid];
             for(Case c : con) {
                 //set contact as a citizen
                 if (c.ContactId == null && ContactName != null) {
                     c.ContactId = ContactName[0].Id;
                     update c;
                 }
           }  
           }

}
}