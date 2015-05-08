/*
new XedeReportTabular('Cases_With_Geodata2');

see : https://www.salesforce.com/us/developer/docs/apexcode/Content/apex_analytics_report_data.htm
*/

public with sharing class XedeReportTabular {
	public list<string> getHeader() { return header; }
	public list<list<string>> getRow() { return row; }
	
	public XedeReportTabular(string aDeveloperName) {
		// get the report's id using its developerName
		Report aReport = [ select DeveloperName, Format, Id, Name from Report where developerName = :aDeveloperName limit 1 ];
		
		// this class only works for tabular reports
		if (aReport.Format.equalsIgnoreCase('Tabular') == false)
			XedeException.Raise('Expected "Tabular" but got "{0}."', aReport.Format);
		
		// run the report
		Reports.ReportResults rr = Reports.ReportManager.runReport(aReport.id, true);
		
		// I need the metadata to discovere each column's data type
		Reports.ReportExtendedMetadata xmeta = rr.getReportExtendedMetadata();
		map<string, Reports.DetailColumn> columnMap = xmeta.getDetailColumnInfo();
		system.debug(columnMap);
		
		// the order of the columns as described in the report are in the standard metadata
		Reports.ReportMetadata meta = rr.getReportMetadata();
		system.debug(meta);
		
		// here's the list of field names
		list<string> reportFieldNames = meta.getDetailColumns();
		for (string each : reportFieldNames)
			header.add(columnMap.get(each).getLabel());
			
		rr.getAllData();
		
		// the report's data is in the fact maps
		map<string, Reports.ReportFact> rfm = rr.getFactMap();
		Reports.ReportFactWithDetails details = (Reports.ReportFactWithDetails) rfm.get('T!T');
		system.debug(details);

		string[] column;
		integer objectLimit = 1000; // it would be great if this were a limits.getLImit*() method
		
		for (Reports.ReportDetailRow eachRow : details.getRows()) {
			column = new string[]{};
			
			list<Reports.ReportDataCell> cells = eachRow.getDataCells();
			
			for (integer i = 0; i < reportFieldNames.size(); i++) {
				Reports.ReportDataCell eachCell = cells[i];				// get the cell data
				Reports.DetailColumn cellType = columnMap.get(reportFieldNames[i]);	// get the cell type
				
				// if getValue() returns an id, use getLabel instead
				string columnValue = String.ValueOf(eachCell.getValue());
				
				try {
					Id.ValueOf(String.ValueOf(eachCell.getValue()));
					columnValue = eachCell.getLabel();
				}
				catch (Exception ex) {	// ignore exceptions
				}
				
				if (cellType.getDataType() == Reports.ColumnDataType.STRING_DATA)
					columnValue = '"' + columnValue + '"';
					
				// in-case you're wondering why this is here, it's because I can't figure
				// out how to get a newline at the start of every data row in the VisualForce page
				if (column.size() == 0)
					columnValue = '\n' + columnValue;
				
				column.add(columnValue);
			}
			
			row.add(column);
			
			if (objectLimit-- <= 1)
				break;
		}
	}
	
	public list<string> header = new list<string>();
	public list<list<string>> row = new list<list<string>>();
}