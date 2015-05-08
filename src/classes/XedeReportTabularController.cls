global with sharing class XedeReportTabularController extends XedeController {
	@RemoteAction
	global static list<map<string, string>> TabularReport(String aReportName) {
        XedeReportTabular xReport = new XedeReportTabular(aReportName);
        
        list<map<string, string>> aMapList = new list<map<string, string>>();
        
        for (list<string> eachRow : xReport.row) {
        	map<string, string> rowMap = new map<string, string>();

        	for (integer i = 0; i < eachRow.size(); i++) {
        		string header = xReport.header[i].replace(' ', '');
        		string value = eachRow[i];
        		
        		if (header.equalsIgnoreCase('reportid'))
        			value = value.substring(1);
        			
        		rowMap.put(header, value.replace('"', ''));
        	} 
        	
        	aMapList.add(rowMap);
        }
        
        return aMapList;
	}
	
	public void setReportUniqueName(string aString) {
		if (String.IsNotBlank(aString))
			aReport = new XedeReportTabular(aString);
	}
	
	public XedeReportTabularController() {
		setReportUniqueName(pageParameters.get('report'));
	}
	
	public XedeReportTabular aReport { get; private set; }
}