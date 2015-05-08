trigger ContactAfterUpdate on Contact (after insert, after update) {
	// only run for single-record updates
	if (Trigger.new.size() != 1)
		return;
	
	ContactWrapper.AddressAndAreas(Trigger.new[0].id);
}