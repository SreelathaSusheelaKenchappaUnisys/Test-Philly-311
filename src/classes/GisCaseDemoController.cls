public with sharing class GisCaseDemoController extends XedeController {
	public PageReference doSomething()
	{		
		system.debug(pageParameters);
		system.debug(currentPage().getParameters());
		
		string jsonString = currentPage().getParameters().get('gisdata');
		XedeJObject gisData = new XedeJobject(jsonString);
		
		if (gisData.getObject('x2272') == null)
			return null;
			
		system.debug(jsonString);
		system.debug(gisData);
		
		RecordType aRecordtype = [ SELECT Id, Name from RecordType where sobjectType = 'Case' and isActive = true and name = 'Pothole Repair' limit 1];

		Case c = new Case(
			recordTypeId = aRecordType.Id,
			parentId = gisData.getString('parentId'),
			centerline__longitude__s = double.valueOf(gisData.getObject('x')),
			centerline__latitude__s  = double.valueOf(gisData.getObject('y')),
			centerline_2272x__c = double.valueOf(gisData.getObject('x2272')),
			centerline_2272y__c = double.valueOf(gisData.getObject('y2272')),
			subject = gisData.getString('description'),
			street__c = gisData.getString('description'),
			description = 'a description'
		);
		
		system.debug(c);
		
		insert c;
		
		return null;
	}
}