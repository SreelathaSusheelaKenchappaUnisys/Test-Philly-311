j$ = jQuery.noConflict(); 
j$(document).ready(function() {  
	var sid = getCookie('sid');	 
	sforce.connection.init(sid, '../../services/Soap/u/27.0');	
	var user = sforce.connection.getUserInfo();
	var userName= user.userFullName; 
	var profileId = user.profileId;   
    var pathname = window.location.pathname;
	pathname = pathname.substring(1,pathname.length);

	j$("input[value='Agent Button']").hide(); 
	if((profileId == '00eG0000000zzC0') || (profileId == '00eG0000000zzC0IAI'))  {	
		j$("input[value='Delete']").hide();  	 
	    j$("input[value=' Clone ']").hide();  	 
		
	}	
    
    if((profileId == '00eJ0000000HxcLIAS') || (profileId == '00eJ0000000Hx6oIAC')) {
        j$("input[value='Close Service Request']").hide();  	 
	}
    
    try{ 
		var query = "SELECT Id, Status  from Case WHERE id = '"+ pathname + "'"; 
		var records = sforce.connection.query(query); 
		var records1 = records.getArray('records'); 
		if(records1.length == 1)	{
			if(records1[0].Status == 'Closed')
				j$("input[value='Close Service Request']").hide();  
		}
	}	
	catch(e){
		
	}
}); 