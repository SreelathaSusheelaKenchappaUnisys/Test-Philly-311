j$ = jQuery.noConflict(); 
j$(document).ready(function() {
	j$("input[value='Redress']").hide(); 
	var pathname = window.location.pathname;
	pathname = pathname.substring(1,pathname.length);
	try{ 
		var query = "SELECT Id, CaseNumber, Status, ClosedDate,Days_Elapsed_after_Case_Close__c  from Case WHERE Days_Elapsed_after_Case_Close__c != null AND Department__c IN ('Streets Department','Water Department (PWD)') AND id = '"+ pathname + "'"; 
		var records = sforce.connection.query(query); 
		var records1 = records.getArray('records'); 
	//	alert(records);
		if(records1.length == 1)	{
			if(records1[0].Days_Elapsed_after_Case_Close__c < 31)
				j$("input[value='Redress']").show(); 
		}
	}	
	catch(e){
		
	}
});	