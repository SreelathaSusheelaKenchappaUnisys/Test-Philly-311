/*
Copyright 2013, Xede Consulting Group, Inc.
*/

@isTest
public class VicsTest {
    static testMethod void testCreateEvent() {
        Account anAccount = CreateNewAccount('fake name');
        insert anAccount;
        system.assertNotEquals(null, anAccount.id);
        
        XedeTestData testData = new XedeTestData('VicsTestData');
        string aString = testData.find('invite1json');
        system.assertNotEquals(null, aString);
        
        Vics converter = new Vics();                        
        list<Vics.Calendar> calList = converter.getCalendarFromJson(aString);
        converter.insertEventsFromCalendars(calList, anAccount.id);
        
        list<Event> eventList = [ 
            select  id, Event_UID__c,
                    startDateTime, endDateTime, 
                    subject, description, location 
              from  Event 
             where  whatId = :anAccount.id 
        ];
        system.assertEquals(1, eventList.size(), 'Passes when Event was created.');
        Event anEvent = eventList[0];
        system.assertEquals('FB-00463 - Review Dana Estimate and Questions', anEvent.Subject);
        system.assertEquals(true, anEvent.Description.startsWith('Run our'), anEvent.Description);
        system.assertEquals('Rick\'s office', anEvent.Location);
        system.assertEquals('2013-03-14 18:30:00', anEvent.StartDateTime.formatGMT('yyyy-MM-dd HH:mm:ss'));
        system.assertEquals('2013-03-14 19:20:00', anEvent.EndDateTime.formatGMT('yyyy-MM-dd HH:mm:ss'));
    }
    
    static testMethod void testCancelledEvent() {
        Account anAccount = CreateNewAccount('fake name');
        insert anAccount;
        system.assertNotEquals(null, anAccount.id);
        
        XedeTestData testData = new XedeTestData('VicsTestData');
        string aString = testData.find('invite1json');
        system.assertNotEquals(null, aString);
        
        Vics converter = new Vics();                        
        list<Vics.Calendar> calList = converter.getCalendarFromJson(aString);
        converter.insertEventsFromCalendars(calList, anAccount.id);
        
        list<Event> eventList = [ 
            select  id, Event_UID__c,
                    startDateTime, endDateTime, 
                    subject, description, location 
              from  Event 
             where  whatId = :anAccount.id 
        ];
        system.assertEquals(1, eventList.size(), 'Passes when Event was created.');

        Event anEvent = eventList[0];
        system.assertEquals('oj3cqef2gp3ssa7kqh3jn9f2qs@google.com', anEvent.Event_UID__c); // fb-00611

        String anotherString = testData.find('invite2json');
        system.assertNotEquals(null, anotherString);
        system.assert(anotherString.contains(anEvent.Event_UID__c), 'Passes when UID of the previously created event is found.');
        system.assert(anotherString.contains('CANCELLED'), 'Passes when the event status is CANCELLED.');

        list<Vics.Calendar> anotherCalList = converter.getCalendarFromJson(anotherString);
        
        converter.insertEventsFromCalendars(anotherCalList, anAccount.id);
        
        eventList = [ 
            select  id, Event_UID__c,
                    startDateTime, endDateTime, 
                    subject, description, location 
              from  Event 
             where  whatId = :anAccount.id 
        ];
        system.assertEquals(0, eventList.size(), 'Passes when Event was cancelled.');
    }
    
    static testMethod void testCreateOutlookEvent() {
        Account anAccount = CreateNewAccount('fake name');
        insert anAccount;
        system.assertNotEquals(null, anAccount.id);
        
        XedeTestData testData = new XedeTestData('VicsTestData');
        string aString = testData.find('invite3json');
        system.assertNotEquals(null, aString);
        
        Vics converter = new Vics();                        
        list<Vics.Calendar> calList = converter.getCalendarFromJson(aString);
        converter.insertEventsFromCalendars(calList, anAccount.id);
        
        list<Event> eventList = [ 
            select  id, Event_UID__c,
                    startDateTime, endDateTime, 
                    subject, description, location 
              from  Event 
             where  whatId = :anAccount.id
        ];
        system.assertEquals(1, eventList.size(), 'Passes when Event was created.');
        Event anEvent = eventList[0];
        system.assertEquals('FB-00067 Test Meeting', anEvent.Subject);
        system.assertEquals(null, anEvent.Location);
        system.assertEquals('2013-04-04 08:30:00', anEvent.StartDateTime.formatGMT('yyyy-MM-dd HH:mm:ss'));
        system.assertEquals('2013-04-04 09:00:00', anEvent.EndDateTime.formatGMT('yyyy-MM-dd HH:mm:ss'));
    }
    
    static testMethod void testCanceledOutlookEvent() {
        Account anAccount = CreateNewAccount('fake name');
        insert anAccount;
        system.assertNotEquals(null, anAccount.id);
        
        XedeTestData testData = new XedeTestData('VicsTestData');
        string aString = testData.find('invite3json');
        system.assertNotEquals(null, aString);
        
        Vics converter = new Vics();                        
        list<Vics.Calendar> calList = converter.getCalendarFromJson(aString);
        converter.insertEventsFromCalendars(calList, anAccount.id);
        
        list<Event> eventList = [ 
            select  id, Event_UID__c,
                    startDateTime, endDateTime, 
                    subject, description, location 
              from  Event 
             where  whatId = :anAccount.id 
        ];
        system.assertEquals(1, eventList.size(), 'Passes when Event was created.');

        Event anEvent = eventList[0];
        system.assertEquals('040000008200E00074C5B7101A82E0080000000060E8FDD96130CE010000000000000000100000004450F32BEB7BB24FAA12A6C125896847', anEvent.Event_UID__c);  // fb-00611

        String anotherString = testData.find('invite4json');
        system.assertNotEquals(null, anotherString);
        system.assert(anotherString.contains(anEvent.Event_UID__c), 'Passes when UID of the previously created event is found.');
        system.assert(anotherString.contains('"summary" : "Canceled:'), 'Passes when the event Summary starts with \'Canceled:\'.');

        list<Vics.Calendar> anotherCalList = converter.getCalendarFromJson(anotherString);
        
        converter.insertEventsFromCalendars(anotherCalList, anAccount.id);
        
        eventList = [ 
            select  id, Event_UID__c,
                    startDateTime, endDateTime, 
                    subject, description, location 
              from  Event 
             where  whatId = :anAccount.id 
        ];
        system.assertEquals(0, eventList.size(), 'Passes when Event was canceled.');
    }
    
    static testMethod void testJsonConversion() {
        XedeTestData testData = new XedeTestData('VicsTestData');
        string aString = testData.find('invite1json');
        
        Vics aVics = new Vics();
        list<Vics.Calendar> calList = aVics.getCalendarFromJson(aString);
/*
I'm not going to test the numbers of anything, because I know 
there's only one event.  If I have trouble accessing it, I'll
know there's problems elsewhere.
*/
        Vics.vEvent anEvent = calList[0].events[0];
        
        system.assertEquals('oj3cqef2gp3ssa7kqh3jn9f2qs@google.com', anEvent.uid);  // fb-00611
        system.assertEquals('FB-00463 - Review Dana Estimate and Questions', anEvent.summary);
        system.assertEquals('CONFIRMED', anEvent.status);
        system.assertEquals('tgagne@xede.com', anEvent.organizer);

/*
A cancelled event was added to the static resource, tested below
*/
        string anotherString = testData.find('invite2json');
        
        Vics anotherVics = new Vics();
        list<Vics.Calendar> anotherCalList = anotherVics.getCalendarFromJson(anotherString);

        Vics.vEvent aCancelledEvent = anotherCalList[0].events[0];
        
        system.assertEquals('CANCELLED', aCancelledEvent.status);
        system.assertEquals(anEvent.uid, aCancelledEvent.uid);  // fb-00611
    }
    
    static testMethod void iHateApexTimeClasses()
    {
        Date aDate = Date.ValueOf('2013-03-31');
                
        string timeString = '04:00:00';
        list<String> parts = timeString.split(':');
        Time aTime = Time.newInstance(Integer.valueOf(parts[0]), Integer.valueOf(parts[1]), Integer.valueOf(parts[2]), 0);
        
        DateTime aDateTime = DateTime.newInstanceGmt(aDate, aTime);
        system.assertEquals(2013, aDateTime.yearGmt());
        system.assertEquals(03, aDateTime.monthGmt());
        system.assertEquals(31, aDateTime.dayGmt());
        system.assertEquals(4, aDateTime.hourGmt());
    }
    
    static Account CreateNewAccount(string anAccountName)
    {
        return new Account(
            name = anAccountName,
            billingCity = 'Troy',
            billingState = 'Michigan',
            billingStreet = '50 W Big Beaver',
            billingPostalCode = '48084'
        );
    }
}