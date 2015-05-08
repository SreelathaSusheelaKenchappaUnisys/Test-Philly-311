/*
Copyright 2012, Xede Consulting Group, Inc.
*/

trigger FeedbackAfterUpdate on Feedback__c (after insert, after update) {
	Feedback.HandleAfterUpdate(trigger.new, trigger.old);
}