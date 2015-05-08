@isTest
private class Kizuna_CheckInCountTriggerTest {
    static Id createParticipantData() {
        Request__c request = new Request__c(
            LastName__c = 'test',
            FirstName__c = 'test'
        );
        insert request;

        Volunteer__c volunteer = new Volunteer__c(
            Request__c = request.Id,
            StartDate__c = Date.today()
        );
        insert volunteer;

        Candidate__c candidate = new Candidate__c(
            LastName__c = 'test',
            FirstName__c = 'test'
        );
        insert candidate;

        Participant__c participant = new Participant__c(
            Volunteer__c = volunteer.Id,
            Candidate__c = candidate.Id
        );
        insert participant;

        return participant.Id;
    }

    static testMethod void insertTest() {
        // init
        ID pid = createParticipantData();

        // test
        Test.startTest();
        CheckIn__c checkin1 = new CheckIn__c(
            Participant__c = pid
        );
        insert checkin1;
        CheckIn__c checkin2 = new CheckIn__c(
            Participant__c = pid
        );
        insert checkin2;
        Test.stopTest();

        // check
        Participant__c p = [Select NumberOfCheckin__c From Participant__c Where Id = :pid];
        System.assertEquals(2, p.NumberOfCheckin__c);
    }

    static testMethod void deleteTest() {
        // init
        ID pid = createParticipantData();

        CheckIn__c checkin1 = new CheckIn__c(
            Participant__c = pid
        );
        insert checkin1;
        CheckIn__c checkin2 = new CheckIn__c(
            Participant__c = pid
        );
        insert checkin2;

        // test
        Test.startTest();
        delete checkin1;
        delete checkin2;
        Test.stopTest();

        // check
        Participant__c p = [Select NumberOfCheckin__c From Participant__c Where Id = :pid];
        System.assertEquals(0, p.NumberOfCheckin__c);
    }
}