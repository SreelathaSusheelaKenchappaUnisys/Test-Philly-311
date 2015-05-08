trigger triggerOnUser on User (after update) {
    
    for(user v : Trigger.new){
    String temp = '';
    user i = Trigger.oldMap.get(v.id);
    user u=Trigger.newMap.get(v.id);
   
    if(u.get('LastModifiedDate') != i.get('LastModifiedDate')){
         temp += 'LastModifiedDate' + ': '+u.get('LastModifiedDate') +'\n';
    } 
    if(u.get('Username') != i.get('Username')){
         temp += 'User Name' + ': '+u.get('Username') +'\n';
    }
    if(u.get('LastName') != i.get('LastName')){
         temp += 'Last Name' + ': '+u.get('LastName') +'\n';
    }
    if(u.get('FirstName') != i.get('FirstName')){
         temp += 'First Name' + ': '+u.get('FirstName') +'\n';
    }
    if(u.get('ProfileName__c') != i.get('ProfileName__c')){
         temp += 'Profile Name' + ': '+u.get('ProfileName__c') +'\n';
    }
    if(u.get('PortalRole') != i.get('PortalRole')){
         temp += 'Portal Role' + ': '+u.get('PortalRole') +'\n';
    }
    if(u.get('IsActive') != i.get('IsActive')){
         temp += 'Active' + ': '+u.get('IsActive') +'\n';
    }
     if(u.get('MobilePhone') != i.get('MobilePhone')){
         temp += 'Mobile Phone' + ': '+u.get('MobilePhone') +'\n';
    } 
     if(u.get('ReceivesInfoEmails') != i.get('ReceivesInfoEmails')){
         temp += 'Receives Information Emails' + ': '+u.get('ReceivesInfoEmails') +'\n';
    }
    if(u.get('SmallPhotoUrl') != i.get('SmallPhotoUrl')){
         temp += 'Small Photo Url' + ': '+u.get('SmallPhotoUrl') +'\n';
    }
    
    if(u.get('OfflineTrialExpirationDate') != i.get('OfflineTrialExpirationDate')){
         temp += 'Offline Trial Expiration Date' + ': '+u.get('OfflineTrialExpirationDate') +'\n';
    }
    if(u.get('Country') != i.get('Country')){
         temp += 'Country' + ': '+u.get('Country') +'\n';
    }
    if(u.get('Email') != i.get('Email')){
         temp += 'Email' + ': '+u.get('Email') +'\n';
    }
    if(u.get('Street') != i.get('Street')){
         temp += 'Street' + ': '+u.get('Street') +'\n';
    }
    if(u.get('StateCode') != i.get('StateCode')){
         temp += 'State Code' + ': '+u.get('StateCode') +'\n';
    }
     if(u.get('Latitude') != i.get('Latitude')){
         temp += 'Latitude' + ': '+u.get('Latitude') +'\n';
    }
    if(u.get('CountryCode') != i.get('CountryCode')){
         temp += 'Country Code' + ': '+u.get('CountryCode') +'\n';
    }
    if(u.get('Title') != i.get('Title')){
         temp += 'Title' + ': '+u.get('Title') +'\n';
    }
    if(u.get('City') != i.get('City')){
         temp += 'City' + ': '+u.get('City') +'\n';
    }
     if(u.get('CommunityNickname') != i.get('CommunityNickname')){
         temp += 'Community Nickname' + ': '+u.get('CommunityNickname') +'\n';
    }
    if(u.get('LastPasswordChangeDate') != i.get('LastPasswordChangeDate')){
         temp += 'Last Password Change Date' + ': '+u.get('LastPasswordChangeDate') +'\n';
    }
     if(u.get('Extension') != i.get('Extension')){
         temp += 'Extension' + ': '+u.get('Extension') +'\n';
    }
     if(u.get('UserType') != i.get('UserType')){
         temp += 'User Type' + ': '+u.get('UserType') +'\n';
    }
    if(u.get('Phone') != i.get('Phone')){
         temp += 'Phone' + ': '+u.get('Phone') +'\n';
    }
    if(u.get('EmployeeNumber') != i.get('EmployeeNumber')){
         temp += 'Employee Number' + ': '+u.get('EmployeeNumber') +'\n';
    }
    if(u.get('Department') != i.get('Department')){
         temp += 'Department' + ': '+u.get('Department') +'\n';
    }
    if(u.get('Fax') != i.get('Fax')){
         temp += 'Fax' + ': '+u.get('Fax') +'\n';
    }
    if(u.get('CompanyName') != i.get('CompanyName')){
         temp += 'Company Name' + ': '+u.get('CompanyName') +'\n';
    }
    if(u.get('PostalCode') != i.get('PostalCode')){
         temp += 'Postal Code' + ': '+u.get('PostalCode') +'\n';
    }
    if(u.get('Alias') != i.get('Alias')){
         temp += 'Alias' + ': '+u.get('Alias') +'\n';
    }
    if(u.get('State') != i.get('State')){
         temp += 'State' + ': '+u.get('State') +'\n';
    }
    if(u.get('Division') != i.get('Division')){
         temp += 'Division' + ': '+u.get('Division') +'\n';
    }
     
    
    list<String> toAddr = new list<String>();
    list<String> ccAddr = new list<String>();
    toAddr.add(u.email);
    
    Messaging.reserveSingleEmailCapacity(100);
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    
    mail.setToAddresses(toAddr);
    mail.setSenderDisplayName('Your User Has Been Modified');
    mail.setSubject('*** USER PERMISSION UPDATE NOTIFICATION *** ');
    mail.setBccSender(false);
    mail.setUseSignature(false);
    mail.setSaveAsActivity(false);
    //mail.setPlainTextBody('The following changes have been made to User with name '+u.firstName+' '+u.Lastname+'     \n\n\n'+temp+'\n\n'+'Click on the link to access the User details: '+'https://www.login.salesforce.com'+'\n\n'+'Thank you,'+'\n'+'311 Customer Support' );
    mail.setPlainTextBody('The following changes have been made to User with name '+u.firstName+' '+u.Lastname+'     \n\n\n'+temp+'\n\n'+'Thank you,'+'\n'+'311 Customer Support' );
    system.debug('id is '+ i);
    system.debug('name is '+ i.profilename__c);
    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });    
    
}

}