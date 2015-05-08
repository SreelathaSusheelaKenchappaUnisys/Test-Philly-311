/*
Copyright 2012, Xede Consulting Group, Inc.
*/

trigger FeedbackInsert on Feedback__c (before insert) {
	Feedback.HandleInsert(trigger.new, trigger.old);
}