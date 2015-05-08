@isTest
private class XedeRemoteTest {

    static testMethod void OneTaskTest() {  
    	Task t = new Task(subject = 'test');
    	insert t;
    	  	
        XedeRemote.Response aResponse = XedeRemote.Query('select id from Task');
        system.assertEquals(1, aResponse.size());
    }
    
    static testMethod void OneEventTest() {  
    	DateTime aStarttime = DateTime.Now().addDays(10);
    	
    	Event t = new Event(subject = 'test', startDateTime = aStartTime, durationInMinutes = 11);
    	insert t;
    	  	
        XedeRemote.Response aResponse = XedeRemote.Query('Select Id, WhatID, StartDateTime, EndDateTime, durationInMinutes From Event');
        system.assertEquals(1, aResponse.size());
        
        system.assertEquals(aStartTime, ((Event) aResponse.queryData[0]).startDateTime);
        system.assertEquals(11, ((Event) aResponse.queryData[0]).durationInMinutes);
        system.assertEquals(aStartTime.addMinutes(11), ((Event) aResponse.queryData[0]).endDateTime);
    }
}