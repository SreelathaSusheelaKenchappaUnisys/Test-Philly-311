public with sharing class X311SystemSettings {
	public static string SAGURL() { return hasSAGURL() ? aSetting.SAGURL__c : 'http://isdev.phila.gov:5555'; }
	
	public static boolean hasSAGURL() { 
		if (aSetting == null)
			return false;
		
		if (String.IsBlank(aSetting.SAGURL__c))
			return false;
		
		return true;
	}
	
	static X311SystemSettings__c aSetting = X311SystemSettings__c.GetOrgDefaults();
}