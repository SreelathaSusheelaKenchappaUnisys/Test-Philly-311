trigger DirectoryBeforeInsert on Directory__c (before insert) {
	for (Directory__c each : Trigger.new) {
		each.Name = each.firstName__c + ' ' + each.lastName__c;
		each.Phone__c = String.Format('({0}) {1}-{2}', new string[] { 
			each.phone__c.mid(0, 3), 
			each.phone__c.mid(3, 3), 
			each.phone__c.mid(6, 4) 
		});
	}
}