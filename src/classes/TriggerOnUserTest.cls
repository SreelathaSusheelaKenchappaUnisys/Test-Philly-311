@isTest 
//Test class for testing the trigger on cases
private class TriggerOnUserTest {

    //update user and see whether the email is being sent 
    static testMethod void validate1() { 
        profile p = [select id, name from profile where name = 'SFDC Administrators' LIMIT 1];
        user us = new user();
        us.email = 'harikrishna.ogirala@in.unisys.com';
        us.alias = 'hogir';
        us.LastName = 'hari krishna';
        us.DigestFrequency = 'D';
        us.DefaultGroupNotificationFrequency = 'D';
        us.EmailEncodingKey = 'UTF-8';
        us.profileId = p.id;
        us.Username = 'TestTriggerOnUser@in.unisys.com';
        us.UserPermissionsCallCenterAutoLogin = false;
        us.UserPermissionsMarketingUser = false;
        us.UserPermissionsOfflineUser = false;
        us.LanguageLocaleKey = 'en_US'; 
        us.LocaleSidKey = 'en_US' ;
        us.TimeZoneSidKey = 'America/Los_Angeles';
        
        insert us;
        p=[select id,name from profile where name = 'System Administrator' LIMIT 1];
        user u = [select LastName,FirstName,ProfileName__c,PortalRole,IsActive,longitude,MobilePhone,ReceivesInfoEmails,SmallPhotoUrl,OfflineTrialExpirationDate,Country,Email,Street,StateCode,Latitude,CountryCode,Title,City,CommunityNickname,LastPasswordChangeDate,Extension,UserType,Phone,EmployeeNumber,Department,Fax,CompanyName,PostalCode,Alias,State,Division  from user where id=:us.id ];
        u.lastName = 'kousik';
        u.firstName = 'test';
        u.email = 'testtest@test.com';
        u.userName = 'test@citywide.com';
        u.IsActive = false;
        u.MobilePhone = '8951050900';
        u.ReceivesInfoEmails = true;
        u.Country = 'India';
        u.Street = 'test';
        u.StateCode = 'KA';
        u.CountryCode = 'IN';
        u.Title = 'Mr';
        u.City = 'Bangalore';
        u.CommunityNickname = 'commnickname';
        u.Extension = '23232322';
        u.Phone = '1234567890';
        u.EmployeeNumber = '212121';
        u.Department = 'dept';
        u.Fax = '212121';
        u.CompanyName = 'Unisys';
        u.PostalCode = '560066';
        u.State = 'Karnataka';
        u.Division = 'Test';
        u.alias = 'ogir';
        u.profileId = p.id;
        u.Latitude = 37.764;
        u.longitude = 54.090;
       
        update u;
        
        system.assertEquals(u.lastName, 'kousik');
        system.assertEquals(u.longitude , 54.090);
        system.assertEquals(u.Latitude , 37.764);
        system.assertEquals(u.profileId , p.id);
        system.assertEquals(u.alias , 'ogir');
        system.assertEquals(u.Division , 'Test');
        system.assertEquals(u.State , 'Karnataka');
        system.assertEquals(u.PostalCode, '560066');        
        system.assertEquals(u.CompanyName, 'Unisys');        
        system.assertEquals(u.Fax , '212121');  
        system.assertEquals(u.Department , 'dept');  
        system.assertEquals(u.EmployeeNumber  , '212121'); 
        system.assertEquals(u.Phone , '1234567890'); 
        system.assertEquals(u.Extension , '23232322'); 
        system.assertEquals(u.CommunityNickname , 'commnickname'); 
        system.assertEquals(u.City , 'Bangalore'); 
        system.assertEquals(u.Title , 'Mr'); 
        system.assertEquals(u.CountryCode , 'IN'); 
        system.assertEquals(u.StateCode , 'KA'); 
        system.assertEquals(u.Street , 'test'); 
        system.assertEquals(u.Country, 'India'); 
        system.assertEquals(u.ReceivesInfoEmails, true); 
        system.assertEquals(u.MobilePhone , '8951050900');
        system.assertEquals(u.IsActive, false);
        system.assertEquals(u.userName , 'test@citywide.com');
        system.assertEquals(u.email , 'testtest@test.com');
        system.assertEquals(u.firstName , 'test');
     
   }
}