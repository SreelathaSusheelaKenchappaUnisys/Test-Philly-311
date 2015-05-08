global class IntegrationRelatedTask    {

    global void parseDetailsFieldfromPS(Case cs)    {
        System.debug('IntegrationRelatedTask.parseDetailsFieldfromPS Method.');   
        System.debug('Description before parsing: ' + cs.Description);
        String descr = null,oldDesc = null;
        descr = cs.Description;
        oldDesc = cs.Description;
        List<String> descSplit = new List<String>();
        List<String> updatedDescSplit = new List<String>();
        Map<String, String> fieldMap = new Map<String, String>();
        List<PS_Fields_Mapping__c> fieldList = [Select Name ,Field_Name__c, Value__c from PS_Fields_Mapping__c];
        if(fieldList != null && fieldList.size() > 0)    {
            for(PS_Fields_Mapping__c f : fieldList)    {
                fieldMap.put(f.Field_Name__c,f.Value__c);        
            }
        }
        
        System.debug('Field Map: ' + fieldMap);
        if(descr == null)
            descr = '  ';
        integer index = descr.toLowerCase().indexOf('custom fields:');
        System.debug('Description coming from PS: ' + descr);
        System.debug('Index of Custom Field: ' + index);
        
        if(index != -1)    {
           String val1 = null, val2 = null, val3 = null, val4 = null; 
           descr = descr.subString(index, descr.length());
           oldDesc = oldDesc.subString(0,index);
           descSplit = descr.split('\n');
           System.debug('List Values.');
           for(String d : descSplit)    { 
               if(d.trim() != '' && d.indexOf(':') != -1 && !d.trim().equalsIgnoreCase('Custom fields:'))    {
                   val1 = d.subString(0,d.indexOf(':')).trim();
                   val2 = fieldMap.get(val1);
                   val3 = d.subString(d.indexOf(':')+1, d.length()).trim();
                   System.debug('Field: ' + val1 + '  API Name: ' + val2 + '  Value: ' + val3);
                   if(val2 != null && val3 != null)    {
                       System.debug('Intializing Field value for: ' + val2);
                       if(val2.equals('Type_of_Materials__c'))    {
                           val4 = cs.Type_of_Materials__c;
                           if(val4 != null)
                               val3 = val3 + ';' + val4;                                       
                       }
                       cs.put(val2,val3);                       
                   }
                   else   {
                      System.debug('Updating updatedDescSplit List with: ' + d.trim()); 
                      updatedDescSplit.add(d.trim());
                   }   
               }    
            }
        }    
        if (updatedDescSplit != null & updatedDescSplit.size() > 0 )    {
            oldDesc += '\n Custom Fields: ';
            String Name = '';
            if(cs.ContactID != null)    {
                List<Contact> con = [Select id, name from Contact where id =: cs.ContactID];
                if(con != null && con.size() != 0)
                    Name = con[0].Name;
            }
            System.debug('Contact Name: ' + Name);    
            for(String temp : updatedDescSplit)    {       
                if(temp.toLowerCase().indexOf('your name') != -1 )    {
                    if(Name.equals('Anonymous') || Name == '' || Name.equals('PublicStuff User'))   
                        oldDesc += '\n' + temp;    
                }                              
                else 
                    oldDesc += '\n' + temp;               
            }
        }
        System.debug('Index of Custom Field: ' + oldDesc.toLowerCase().indexOf('custom fields:'));
        System.debug('Description Length: ' + oldDesc.length()); 
        if(oldDesc.toLowerCase().indexOf('custom fields:') != -1 && oldDesc.toLowerCase().indexOf('custom fields:') + 20 > oldDesc.length())
            oldDesc = oldDesc.subString(0,oldDesc.toLowerCase().indexOf('custom fields:')).trim();
        System.debug('Updating Description: ' + oldDesc);
        cs.Description = oldDesc;
        cs.PublicStuff_Custom_Fields__c = descr.trim();
    }
    
    global void updateDetailsField(Case cs)    {
        
        System.debug('IntegrationRelatedTask.updateDetailsField1 Method.');        
        if(cs.Description == null)
            cs.Description = '';
        String details = cs.Description;    
        List<Required_Streets_Field__c> reqdStFields = Required_Streets_Field__c.getall().values();
        Map<String,String> f = new Map<String,String>();
        
        if( reqdStFields  != null && reqdStFields .size() >0)    {
            for(Required_Streets_Field__c r : reqdStFields )    {
                if(r.Case_Record_Type__c.trim() == cs.Case_Record_Type__c && r.Required__c == true)  
                    f.put(r.API_Name__c.trim(),r.Label__c.trim());
            }
        }
        
        System.debug('Map : ' + f); 
        String variable = null, value = null;
        if(f!= null && f.size()>0)    {
            for(String key : f.keyset())    {
                variable=f.get(key);
                value = String.valueOf(cs.get(key));
                System.debug(key + '  ' + variable + '  ' + value);
                
                // Support Ticket #08867027 Marion asked for all fields value even if it is null
              //  if(value != null && value != '')    
                    details += '\n' + variable + ': ' + value + '. ';
            }
        }
        
        if(cs.Ticket__c == null && cs.Streets_request_ID__c == null)    {
            if(details.length() > 500)    {
                integer temp =0, temp2 = 0;
                temp = details.substring(0, 465).lastIndexOf('\n');
                temp2 = details.substring(0, 465).lastIndexOf('.');
                temp = ( temp>temp2 ? temp : temp2);
                if(details.length()- temp >  450) 
                    cs.Description.addError('Max Length Exceeded by ' + String.valueOf( details.length() - temp - 450) + ' characters.');
            }
        }
         cs.Details__c = details;    
    }
        
}