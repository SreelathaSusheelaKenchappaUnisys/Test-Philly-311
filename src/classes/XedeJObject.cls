public class XedeJObject {
	public XedeJObject(string aJsonString) {
		this((map<string, object>) Json.deserializeUntyped(aJsonString));
	}
	
	public XedeJObject(map<string, object> aMap) {
		jsonMap = aMap;
	}
	
	public Boolean containsKey(String aString) {
		return jsonMap.containsKey(aString);
	}
	
	public Object deserialize(System.Type aType)
	{
		string aString = Json.Serialize(jsonMap);
		return Json.Deserialize(aString, aType);
	}
	
	public Date getDateYYYYMMDD(string aString)
	{
		object value = jsonMap.get(aString);
		try {			
			return value == null ? null : XedeUtil.DateFromYYYYMMDD(String.ValueOf(value));
		} catch (system.typeexception tex) {
			XedeLog.Write('{0} is not a valid YYYYMMDD date.', String.ValueOf(value));
		}

		return null;
	}
	
	public XedeJObject getJObject(string aString)
	{
		object value = jsonMap.get(aString);		
		return value == null ? null : new XedeJobject((map<string, object>) value);
	}
	
	public Object getObject(string aString)
	{
		return getObject(aString, null);		
	}
	
	public Object getObject(string aString, object valueIfAbsent)
	{
		return jsonMap.containsKey(aString) ? jsonMap.get(aString) : valueIfAbsent; 
	}
	
	public void putObject(string aKey, object anObject)
	{
		if (jsonMap.containsKey(aKey) == false)
			return;
		
		jsonMap.put(aKey, anObject);
	}
	
	//US phone numbers ignore all digits before the last 10
	public string getUSPhoneDigits(string aString)
	{
		string svalue = getString(aString, '');
		svalue = svalue.replaceAll('[/[^0-9]+/g]','');
		return svalue.right(10);
	}
	
	public List<XedeJObject> getList(string aString)
	{
		object value = jsonMap.get(aString);
		system.debug(value);		
		if (value == null) 
			return null;
			
		List<XedeJObject> aList = new List<XedeJObject>();
		for (object each : (List<object>) value)
			aList.add(new XedeJObject((Map<string, object>)each));
		return aList;
	}
		
	public string getString(string aString)
	{
		object value = getObject(aString);
		return value == null ? null : String.ValueOf(value).trim();
	}
	
	public string getString(string aString, string valueIfAbsent)
	{
		object value = getObject(aString, valueIfAbsent);
		return value == null ? null : String.ValueOf(value).trim();
	}
	
	public integer size() { return jsonMap.size(); }

	transient map<string, object> jsonMap;
}