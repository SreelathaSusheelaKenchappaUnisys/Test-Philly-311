/*
Copyright 2013, Xede Consulting Group, Inc.
*/

public class Vics {
	public class Attendee {
		public string email;
	}
	
	public class vEvent {
		public string uid;
		public string summary;
		public string description;
		public string location;
		public string status;
		public string startTime;
		public string endTime;
		public string organizer;
		public list<string> attendees;
		
		public boolean isCancelled {
			get {
				if(status == 'CANCELLED' || (status == null && summary.startsWith('Canceled: ')))
					return true;
				
				return false;
			}
		}
	}
	
	public class Calendar {
		public list<Vics.vEvent> events;
	}
	
	public list<Vics.Calendar> getCalendarFromIcs(string ics)
	{
		Http http = new Http();
		HttpRequest request = new HttpRequest();
		
		request.setTimeout(60000);
		request.setMethod('POST');
		request.setHeader('Content-type', 'text/plain');
		request.setBodyAsBlob(Blob.ValueOf(ics));
		request.setEndpoint('http://blooming-shore-6714.herokuapp.com/ics2json');

		string responseBody;
	
		HttpResponse response = http.send(request);
		responseBody = response.getBody();
        
		return getCalendarFromJson(responseBody);
	}
	
	public list<Vics.Calendar> getCalendarFromJson(string aString)
	{
		return (list<Vics.Calendar>) JSON.deserialize(aString, list<Vics.Calendar>.class);
	}
	
	public list<Event> insertEventsFromCalendars(list<Vics.Calendar> calendarList, string anId)
	{
/*
we need to collect all the email addresses
for all the attendees so we can select all
the users and contacts regardless how many
events there are.
*/
		set<string> emailAddressList = new set<string>();
		for (Vics.Calendar eachCalendar : calendarList) {
			for (Vics.vEvent eachEvent : eachCalendar.events) { 
				emailAddressList.addAll(eachEvent.attendees);
				emailAddressList.add(eachEvent.organizer);
			}
		}
		
		list<User> userList = [ 
			select	id, name, email 
			  from	User 
			 where	isActive = true 
			   and	email in :emailAddressList
			   and	id != :UserInfo.getUserId() // invitees can't be the owner (whomever I may be)
		];
		list<Contact> contactList = [ select id, name, email from Contact where email in :emailAddressList ];
/*
We prefer users over contacts, so
overwrite contact id with user ids.
*/
		map<string, string> emailIdMap = new map<string, string>();
		for (Contact each: contactList)
			emailIdMap.put(each.email, each.id);		
		for (User each: userList)
			emailIdMap.put(each.email, each.id);
/*
EventRelations are children of events, and so must
have their id.  We'll go through the list now
(again) to build the events and insert them.
*/		
		set<String> eventsToDelete = new set<String>();
		list<Event> newEvents = new list<Event>();
		
		for (Vics.Calendar eachCalendar : calendarList) {
			for (Vics.vEvent eachEvent : eachCalendar.events) {
				eventsToDelete.add(eachEvent.uid);
				
				if (eachEvent.isCancelled)
					continue;
				
				Event anEvent = new Event(whatId = anId);
				
				anEvent.startDateTime = icstime2apex(eachEvent.startTime);
				anEvent.endDateTime = icstime2apex(eachEvent.endTime);				
				
				anEvent.Event_UID__c = eachEvent.uid;
				
				anEvent.Subject = eachEvent.summary;
				anEvent.description = eachEvent.description;
				anEvent.location = eachEvent.location;
				
				anEvent.ShowAs = 'Busy';
				
				newEvents.add(anEvent);				
			}			
		}
		
		delete [select Id from Event where whatid = :anId and Event_UID__c in :eventsToDelete];
		
		insert newEvents;
/*
Now that we have the events inserted, we'll
create their relations for the attendees.
I really hope that when I save them we don't 
send out emails.
*/		
		integer index = 0;
		list<EventRelation> relationList = new list<EventRelation>();	
		for (Vics.Calendar eachCalendar : calendarList) {
			for (Vics.vEvent eachEvent : eachCalendar.events) {
				
				if (eachEvent.isCancelled)
					continue;
					
				for (string eachEmail : eachEvent.attendees) {
					EventRelation invitee = new EventRelation(
						EventId = newEvents[index].id,
						RelationId = emailIdMap.get(eachEmail)
					);
					if (invitee.RelationId != null)
						relationList.add(invitee);
				}
				index++;
			}
		}
		
		insert relationList;
		
		return newEvents;
	}
/*
The callout doesn't know when its going to be 
called, or whether there will be other saves
pending.  To get around this (it messed me 
up), we run as a future method.
*/	
	@future (callout=true)
	public static void InsertEventFromIcs(string icsString, string anId)
	{
		Vics converter = new Vics();	        			
		list<Vics.Calendar> calList = converter.getCalendarFromIcs(icsString);
		converter.insertEventsFromCalendars(calList, anId);
	}
	
	DateTime icstime2apex(string aString)
	{
		list<string> datePart = aString.split('[T+]');
		system.assertEquals(3, datePart.size(), aString + ' did not look like yyyy-mm-ddThh:mm:ss+00:00');
		
		Date aDate = Date.valueOf(datePart[0]);
		
		list<String> timePart = datePart[1].split(':');
    	Time aTime = Time.newInstance(
    		Integer.valueOf(timePart[0]), 
    		Integer.valueOf(timePart[1]), 
    		Integer.valueOf(timePart[2]), 
    		0);
    	
    	return DateTime.newInstanceGmt(aDate, aTime);
    	
	}
	
    public static void TestRun()
    {
    	XedeTestData testData = new XedeTestData('VicsTestData');
        string aString = testData.find('invite1ics');
        system.debug(aString);
        
        Vics converter = new Vics();
        list<Vics.Calendar> aList = converter.getCalendarFromIcs(aString);
        system.assertNotEquals(null, aList);
        system.assertEquals(1, aList.size());
    }
}