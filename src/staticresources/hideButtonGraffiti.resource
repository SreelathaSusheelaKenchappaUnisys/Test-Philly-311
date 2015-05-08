j$ = jQuery.noConflict(); 
j$(document).ready(function() {  
var sid = getCookie('sid');	
sforce.connection.init(sid, '../../services/Soap/u/29.0');	
var user = sforce.connection.getUserInfo();
var userName= user.userFullName; 
var profileId = user.profileId;  
j$("input[value='Send Email for Graffiti']").hide();
j$("input[value='Generate PDF']").hide();
if(userName == 'John Tucci' || profileId == '00eG0000000zzC4IAI' || profileId == '00eG0000000zzCDIAY' || profileId == '00eG0000001BxiCIAS')	{
	j$("input[value='Send Email for Graffiti']").show();
}
if(userName == 'Mary Bibbo' || profileId == '00eG0000000zzC4IAI' || profileId == '00eG0000000zzCDIAY' || profileId == '00eG0000001BxiCIAS')	{
	j$("input[value='Generate PDF']").show();
}
});