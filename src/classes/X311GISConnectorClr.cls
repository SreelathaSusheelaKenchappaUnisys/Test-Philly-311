global class X311GISConnectorClr { 
	global class GeoCodeSpec {
		global string address;
		global string geocodeType;
		global List<string> layers;
		global Map<string, string> attributes;
		
		global GeoCodeSpec() {
			layers=new List<string>();
			attributes=new Map<string, string>();
		}
	}

	global class GeoCodeData {
		global string x;
		global string y;
		global string standardizedAddress;
		global string geocodeType;
		global Map<string, string> attributes;
		
		global GeoCodeData() {
			attributes=new Map<string, string>();
		}
	}

	global class GeoCode {
		global decimal lat;
		global decimal lng;
	}
	
	// this is actually what an ESRI "Extent" is, sans the type and spatialreference fields
	global class ViewPort {
		global double xmin;
		global double xmax;
		global double ymin;
		global double ymax;
	}
	
	global class CasePoint {
		global decimal x;
		global decimal y;
		global string label;
		global string description;
		global string id;
	}
	
	@RemoteAction
	global static List<CasePoint> Query(string aString, ViewPort vp) {
		system.debug(aString);
		system.debug(vp);
		
		ID anId = ID.ValueOf(aString);
		
		List<CasePoint> lstCasePoints= new List<CasePoint>();
		
		for (Case cs : [
				SELECT	Id, CaseNumber, Subject, Street__c, Centerline__longitude__s, Centerline__latitude__s 
				  FROM	Case 
				 WHERE	Centerline_2272x__c != null 
				   AND	Centerline_2272y__c != null
				   AND	Centerline_2272x__c >= :vp.xmin AND Centerline_2272x__c <= :vp.xmax 
				   AND	Centerline_2272y__c >= :vp.ymin AND Centerline_2272y__c <= :vp.ymax
				   AND	Centerline__Longitude__s != null 
				   AND	Centerline__Latitude__s != null
				   AND	RecordTypeId = :anId 
				   AND	IsClosed=false
			]) {
			CasePoint cp=new CasePoint();
			cp.x=cs.Centerline__longitude__s;
			cp.y=cs.Centerline__latitude__s;
			cp.id=cs.Id;
			cp.label=cs.CaseNumber;
			cp.Description = cs.Street__c + ' : ' + cs.Subject;
			
			lstCasePoints.add(cp);
		}
		return lstCasePoints;
	}	

	@RemoteAction
	global static GeoCodeSpec getGeoCodeSpec(string address, string aString) {
		system.debug(address);
		system.debug(aString);
		
		ID anId = ID.ValueOf(aString);
		
		RecordType aType = [ select id, name, developerName from RecordType where id = :anId limit 1 ];
		
		GeoCodeSpec gcs=new GeoCodeSpec();
		
		gcs.address=address;
		for (GISCaseRT__c grt : [SELECT GeoCode_Type__c FROM GISCaseRT__c WHERE RecordTypeDevName__c = :aType.DeveloperName]) {
			gcs.layers.add(grt.GeoCode_Type__c);
		}
		
		for (GISCaseRTLayers__c lyr : [SELECT GISLayerName__c FROM GISCaseRTLayers__c WHERE RecordTypeDevName__c = :aType.DeveloperName]) {
			gcs.layers.add(lyr.GISLayerName__c);
		}
		
		for (GISCaseRTAttributes__c atr : [SELECT GISAttributeName__c FROM GISCaseRTAttributes__c WHERE RecordTypeDevName__c = :aType.DeveloperName]) {
			gcs.attributes.put(atr.GISAttributeName__c, '');
		}
		
		return gcs;
	}	
}