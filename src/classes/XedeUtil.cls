/*
Copyright 2012, Xede Consulting Group, Inc.
*/

public with sharing class XedeUtil {
	
	
	public static Date DateFromYYYYMMDD(String value) {
		
		if(value == null || value.trim().length() != 8)
			return null;
		
		try {
			return Date.valueOf( value.mid(0,4) +'-'+ value.mid(4,2) +'-'+ value.mid(6,2) );
		}
		catch (system.Typeexception ex) {
			system.debug('Unable to parse \''+ value +'\' into a date. Returning null.');
			return null;
		}
	}
	
	// see unit tests for instructions
	public static string DecimalFormat(string format, object stringOrDecimal)
    {
    	Decimal aDecimal = Decimal.ValueOf(String.ValueOf(stringOrDecimal)).stripTrailingZeros();
    	boolean leftJustify = format.contains('-'); format = format.replace('-', '');
    	boolean zeroPad = format.startsWith('0');
    	
    	integer leftPad = 0;
    	Pattern p = Pattern.Compile('^\\d+');
		Matcher m = p.matcher(format);
		while (m.find())
			leftPad = Integer.ValueOf(m.group());
			
		integer rightPad = 0;
		p = Pattern.Compile('\\.\\d+');
		m = p.matcher(format);
		while (m.find())
			rightPad = Integer.ValueOf(m.group().substring(1));
		
		aDecimal = aDecimal.setScale(rightPad);
		
		string decimalString = String.ValueOf(aDecimal);
		integer length = aDecimal.precision() - aDecimal.scale();
		
		return String.Format(
			'{0}{1}',
			new string[] {
				''.leftPad(Math.Max(leftPad - length, 0)).replace(' ', zeroPad ? '0' : ' '),
				decimalString
			}
		);
    }
	
	//
    // you may wonder why we need this if we can just return '' + aDate.  Well,
    // we can't.  Dates constructed with NewInstance() include GMT offset data
    // that are included with we '' + them.
    //
    public static string DateString(Date aDate)
    {
    	return DateTime.newInstance(aDate, Time.NewInstance(0, 0, 0, 0)).format('yyyy-MM-dd');
    }
    
	public static Decimal DecimalValueOf(String aStringValue, Decimal errorValue){
		try{
			Decimal returnValue = Decimal.valueOf(aStringValue.replaceAll('[^-.\\d]',''));
			return returnValue;
		}
		catch(system.TypeException te){
			return errorValue;
		}		
		catch(system.NullPointerException npe){
			return errorValue;
		}		
	}
    
	public static String FormatListForQuery(List<String> aList)
	{
		return FormatListForQuery(alist, false);
	}
	
	public static String FormatListForQuery(Set<string> aSet)
	{
		return FormatListForQuery(new list<string>(aSet));
	}
	
	public static String FormatListForQuery(List<String> aList, boolean ignoreNulls) {
		
		set<string> stringSet = new set<string>(aList);
		
		boolean hasNull = stringSet.removeAll(new string[]{null, 'null', 'NULL'});
		
		list<string> stringList = new list<string>(stringSet);
			
		String formattedString = Join(stringList, '\',\'');
		
		if (hasNull && stringList.isEmpty())
			formattedString = '( null )';
		else if (hasNull)
			formattedString = '( null, \'' + formattedString + '\' )';
		else 
			formattedString = '( \'' + formattedString + '\' )';
			
		return formattedString;
	}
	
	public static Integer IntegerValueOf(String aStringValue, Integer errorValue){
		try{
			Integer returnValue = DecimalValueOf(aStringValue,errorValue).intValue();
			return returnValue;
		}
		catch(system.NullPointerException npe){
			return errorValue;
		}		
	}
    
    public static boolean IsFieldTooLong(String aString, Schema.Sobjectfield aField)
    {
    	return IsFieldTooLong(aString, aField.getDescribe().getLength());
    }
    
    public static boolean IsFieldTooLong(String aString, integer length)
    {
    	return aString.length() > length;
    }
    
    // these next two methods /must/ have been implemented before String.Join().
    // or at least I hope that was the case.  I'm not removing them in-case
    // other code depends on them.
    public static string Join(Set<string> stringSet, string separator)
	{
		return String.Join(new list<string>(stringSet), separator);
	}
	
	public static String Join(List<string> stringList, string separator)
	{
		return String.Join(stringList, separator);
	}

	public static boolean ListIncludesNulls(list<string> aList)
	{
		for (string each : aList)
			if (each.toLowerCase() == 'null')
				return true;
		
		return false;
	}

	public static string LocalUrlFor(string localResourceLocation)
    {
    	if (localResourceLocation.startsWith('/') == false)
    		localResourceLocation = '/' + localResourceLocation;
    		
    	return URL.getSalesforceBaseUrl().toExternalForm() + localResourceLocation;
    }
    
    public static String NumeralsOnly(String aString, String errorValue)
    {
		try{
			String returnValue = aString.replaceAll('[/[^0-9]+/g]','');
			return returnValue;
		}
		catch(system.TypeException te){
			return errorValue;
		}		
		catch(system.NullPointerException npe){
			return errorValue;
		}		
    }
    
    public static String Right(string aString, integer numChars)
	{
		integer length = aString.length();
		
		return aString.substring(length - numChars);
	}
	
	public static list<string> StringListForPickListField(Schema.sobjectField aField) {
		list<string> aList = new list<string>();
		
		for (Schema.PicklistEntry each : aField.getDescribe().getPicklistValues())
			aList.add(each.getValue());
		
		return aList;
	}

	public static String SubjectFromString(String aString)
	{
		if (aString.trim().length() == 0)	
			return '';
			
		string sentence;
		string[] strings = aString.split('[\\.\n\r\\?\\!]');
		
		if (strings.isEmpty())
			sentence = aString.substring(0, Math.max(40, aString.length() + 1));
		else
			sentence = strings[0];
			
		return sentence.substring(0, Math.min(40, sentence.length()));
	}

	public static string TypeToLabel(String aType)
	{
		return aType.replace('__c', '').replace('_', ' ');
	}
	
	public static List<String> Trim(List<String> aStringList)
	{
		List<String> newList = new List<String>();
		
		for (String each : aStringList) {
			if (each.trim().length() > 0)
				newList.add(each.trim());
		}
			
		return newList;
	}
	
	public static string truncateStringAtFieldLength(string aString, Schema.Sobjectfield aField)
    {
    	return aString.abbreviate(aField.getDescribe().getLength());
    }
    
	public static Decimal TruncateDecimal(Decimal value, Integer scale, Decimal divisor) {
		if (value == null)
			return null;
		
		if (scale == null)
			XedeException.Raise('invalid scale: ' + scale);

		if (divisor == null || divisor == 0)
			XedeException.Raise('invalid divisor: ' + divisor);
		
		value = value / divisor;
		return value.setScale(scale, system.Roundingmode.DOWN);
	}
	
	public static Decimal TruncateDecimal(Decimal value, Integer scale) {
		return TruncateDecimal(value, scale, 1.0);
	}
	
	public static String TruncateDecimalString(String value, Integer scale, Decimal divisor) {
		Decimal aDecimalValue = XedeUtil.DecimalValueOf(value, null);

		if (aDecimalValue == null)
			return null;
			
		return TruncateDecimal(aDecimalValue, scale, divisor).toPlainString();
	}

	public static String TruncateDecimalString(String value, Integer scale) {
		Decimal aDecimalValue = XedeUtil.DecimalValueOf(value, null);

		if (aDecimalValue == null)
			return null;

		return TruncateDecimal(aDecimalValue, scale, 1.0).toPlainString();
	}
}