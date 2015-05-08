trigger Kizuna_CheckInCountTrigger on CheckIn__c (after insert, after delete) {

    Set<ID> participantIds = new Set<ID>();
    if (Trigger.isInsert) {
        for (CheckIn__c ci : Trigger.new) {
            participantIds.add(ci.Participant__c);
        }
    } else {
        for (CheckIn__c ci : Trigger.old) {
            participantIds.add(ci.Participant__c);
        }
    }

    Map<ID, Participant__c> participantMap = new Map<ID, Participant__c>(
        [Select Id From Participant__c Where Id In :participantIds]
    );

    List<AggregateResult > res = [
        Select
            Participant__c,
            Count(Id) cnt
        From
            CheckIn__c
        Where
            Participant__c In :participantIds
        Group By
            Participant__c
    ];
    Map<ID, Integer> reMap = new Map<ID, Integer>();
    for(AggregateResult ar : res) {
        ID participantId = (ID)ar.get('Participant__c');
        Integer cnt = (Integer)ar.get('cnt');
        reMap.put(participantId, cnt);
    }

    for (ID participantId : participantIds) {
        Participant__c participant = participantMap.get(participantId);
        Integer cnt = reMap.get(participantId);
        if (cnt != null) {
            participant.NumberOfCheckin__c = cnt;
        } else {
            participant.NumberOfCheckin__c = 0;
        }
    }
    update participantMap.values();
    
}