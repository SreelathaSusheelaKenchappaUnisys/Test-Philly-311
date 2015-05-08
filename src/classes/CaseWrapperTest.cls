/*
obsolescent test should probably be moved to PublicStuffCaseAfterUpdateTest to verify non-web cases aren't geocoded
*/


@isTest
private class CaseWrapperTest {

    static testMethod void goodTest() {
    
        GISMock.Bootstrap();
    
        Group reject = [ select id from group where developerName = 'CitiWorks_Reject' limit 1 ];
        RecordType rt = [ select id, name, developerName from RecordType where developerName = 'Miscellaneous' limit 1 ];
        system.assertNotEquals(null, rt);
        system.assertEquals('Miscellaneous', rt.name);
        
        X311RequestType__c aRequestType = new X311RequestType__c(
             Case_RecordTypeId__c = rt.id,
             requiresGeocode__c = true
        );
    
        insert aRequestType;
    
        Case aCase = new Case(
        Description = 'Test Description',
        Subject = 'Test Subject',
        Street__c = '1234 Market',
        RecordTypeId = rt.Id,
        Origin = 'Phone',
        Customer_Declined__c = TRUE,
        Translator_Required__c = 'No'
        );
    
        test.startTest();
        GISMock.SetAnswer1200Yerkes();
        insert aCase;
        test.stopTest();
    
        aCase = [ 
        select  id, 
            ownerId, 
            centerline_match_type__c, 
            centerline__longitude__s, 
            centerline_2272x__c,
            hansenAddressKey__c,
            Center_City_District__c,
            Pickup_Day__c
          from  case 
         where  id = :aCase.id 
        ];
    
        system.assertEquals(-75.1725044104416, aCase.Centerline__longitude__s);
        system.assertEquals(2689875.0426430465, aCase.Centerline_2272x__c);
        system.assertNotEquals(reject.id, aCase.OwnerId);
        system.assertNotEquals(null, aCase.hansenAddressKey__c);
        system.assertEquals('FRI', aCase.Pickup_Day__c);
        system.assertEquals(null, aCase.Center_City_District__c);
    }
    
       // same as test above, but I want the geocoding to fail
    
    static testMethod void failTest() {
        GISMock.Bootstrap();
        
        Group reject = [ select id from group where developerName = 'CitiWorks_Reject' limit 1 ];
        RecordType rt = [ select id, name, developerName from RecordType where developerName = 'Miscellaneous' limit 1 ];
        system.assertNotEquals(null, rt);
        system.assertEquals('Miscellaneous', rt.name);
        
        X311RequestType__c aRequestType = new X311RequestType__c(
             Case_RecordTypeId__c = rt.id,
             requiresGeocode__c = true
        );
        
        insert aRequestType;
        
        Case aCase = new Case(
            Description = 'Test Description',
            Subject = 'Test Subject',
            Street__c = '1234 Market',
            RecordTypeId = rt.Id,
            Origin = 'Phone',
            Customer_Declined__c = TRUE,
            Translator_Required__c = 'No'
            
        );
        
        test.startTest();
        GISMock.SetAnswerNotFound();
        insert aCase;
        test.stopTest();
        
        aCase = [ select id, ownerId, centerline_match_type__c, centerline__longitude__s, centerline_2272x__c from case where id = :aCase.id ];
        system.assertEquals(reject.id, aCase.OwnerId);
    }
}