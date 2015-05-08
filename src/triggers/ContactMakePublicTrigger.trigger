trigger ContactMakePublicTrigger on Case (after insert, after update) {
Id roleid = Userinfo.getUserRoleId();
system.debug('=============Role===============' +roleid);
  if (Trigger.isInsert) 
{
    List<CaseShare> sharesToCreate = new List<CaseShare>();
    for (Case c: Trigger.new) {
      if (c.Created_By_RoleId__c == roleid) 
        {
        // create the new share for group
        system.debug('=============First===============' +c.Created_By_RoleId__c);
        
        
        CaseShare cs = new CaseShare();
        cs.CaseAccessLevel = 'Edit';
        cs.CaseId = c.Id;
        cs.UserOrGroupId =   [select id from group where name='Partner Role'].id; //'00G17000000NWel'; */
        
        for(user u : [select id from user where userrole.id =: userinfo.getUserRoleId()]) {
            CaseShare cs1 = new CaseShare();
            cs1.CaseAccessLevel = 'Edit';
            cs1.CaseId = c.Id;
            cs1.UserOrGroupId = u.id;
            sharesToCreate.add(cs1);    
        }
        //list<Database.saveResult> sr2 =Database.insert(sharesToCreate);
        //system.debug('result IS' + sr2); 
        
        
        Database.SaveResult sr = Database.insert(cs,false);
         if(sr.isSuccess()){
            // Indicates success
            System.debug('CaseSharing class returns : TRUE');
        }
        else {
            // Get first save result error.
            Database.Error err = sr.getErrors()[0];
            System.debug('CaseSharing class thrown error: ' + String.valueOf(err));
            // Check if the error is related to trival access level.
            // Access levels equal or more permissive than the object's default 
            // access level are not allowed. 
            // These sharing records are not required and thus an insert exception is acceptable. 
            if(err.getStatusCode() == StatusCode.FIELD_FILTER_VALIDATION_EXCEPTION  &&  
                    err.getMessage().contains('AccessLevel')){
                // Indicates success.
                System.debug('CaseSharing class returns : TRUE');
            }
            else{
                // Indicates failure.
                System.debug('CaseSharing class returns : FALSE');
            }
        }
      }
    }

    // do the DML to create shares
   /* if (!sharesToCreate.isEmpty())
    system.debug('insert'+String.ValueOf(sharesToCreate));
          Database.upsert(sharesToCreate,false);*/
     }
}