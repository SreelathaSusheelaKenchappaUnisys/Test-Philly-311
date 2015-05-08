/*
Copyright 2012, Xede Consulting Group, Inc.
*/

@isTest
private class XedeUtilTest {
   
	static testMethod void testDateFromYYYYMMDD() {
	
		Date testDate = Date.newInstance(2013, 6, 13);
		system.assertEquals(testDate, XedeUtil.DateFromYYYYMMDD('20130613'));
		
		system.assertEquals(null, XedeUtil.DateFromYYYYMMDD('garbage'));
		system.assertEquals(null, XedeUtil.DateFromYYYYMMDD('2013613'));
		system.assertEquals(null, XedeUtil.DateFromYYYYMMDD('201306013'));
		
		system.assertEquals(null, XedeUtil.DateFromYYYYMMDD('20131332'));
		system.assertNotEquals(null, XedeUtil.DateFromYYYYMMDD('20131231'));

		system.assertEquals(null, XedeUtil.DateFromYYYYMMDD(null));
	}
	
	static testMethod void testDecimalFormat() {
    	system.assertEquals('4', XedeUtil.DecimalFormat('d', 4));
    	system.assertEquals('4', XedeUtil.DecimalFormat('d', 4.000));
    	system.assertEquals('  4', XedeUtil.DecimalFormat('3d', 4));
    	system.assertEquals('004', XedeUtil.DecimalFormat('03d', 4));
    	system.assertEquals('04', XedeUtil.DecimalFormat('02d', 4.25));
    	system.assertEquals('4.25', XedeUtil.DecimalFormat('.2d', 4.25));
    	system.assertEquals('004.250', XedeUtil.DecimalFormat('03.3d', 4.25));
    	system.assertEquals('004.250', XedeUtil.DecimalFormat('03.3d', '4.25'));
    }

	static testMethod void testDecimalValueOf(){
		system.assertEquals(1.234,XedeUtil.DecimalValueOf('$1one.2two#3$4&*',0));
		system.assertEquals(1000.00,XedeUtil.DecimalValueOf('$1,000.00',null));
		system.assertEquals(-1,XedeUtil.DecimalValueOf('1.23.45',-1.0));
		system.assertEquals(0, XedeUtil.DecimalValueOf(null, 0));
	}

	static testMethod void testNumeralsOnly(){
		system.assertEquals('1234', XedeUtil.NumeralsOnly('$1one.2two#3$4&*', null));
		system.assertEquals('100000', XedeUtil.NumeralsOnly('$1,000.00', null));
		system.assertEquals('12345', XedeUtil.NumeralsOnly('1.23.45', null));
		system.assertEquals(null, XedeUtil.NumeralsOnly(null, null));
	}

	static testMethod void testIntegerValueOf(){
		system.assertEquals(1,XedeUtil.integerValueOf('$1one.2two#3$4&*',0));
		system.assertEquals(1000.00,XedeUtil.integerValueOf('$1,000.00',-1));
		system.assertEquals(null,XedeUtil.integerValueOf('1.23.45',null));
		system.assertEquals(-1,XedeUtil.integerValueOf('-1',0));
	}

    static testMethod void testStringJoin()
    {
    	List<string> wordList = new List<string> { 'two', 'three', 'four' };
    	
    	System.assertEquals('two,three,four', XedeUtil.Join(wordList, ','));
    	
    	set<string> wordSet = new set<string>(wordList);
    	string result = XedeUtil.join(wordSet, ',');    	
    }
    
    static testMethod void testStringReplace() {
    	System.assertEquals('here and there', XedeUtil.TypeToLabel('here_and_there__c'));
    }
    
    static testMethod void testStringSplits()
    {
    	List<String> stringList = XedeUtil.Trim('one, two, three'.split(','));
    	System.assertEquals('one', stringList[0]);
    	System.assertEquals('two', stringList[1]);
    	System.assertEquals('three', stringList[2]);
    	
    	stringList = XedeUtil.Trim(' '.trim().split(','));
    	System.assertEquals(0, stringList.size());   	
    }
    
    static testMethod void testTitleFromString()
    {
    	System.assertEquals('one', XedeUtil.SubjectFromString('one. two. three.  four.'));
    	System.assertEquals('one two', XedeUtil.SubjectFromString('one two.\nthree four\n'));
    }
    
	static testMethod void TruncateDecimalTest() {

		String currentAPR = '0139555';
		
		system.assertEquals('13.95', XedeUtil.TruncateDecimalString(currentAPR, 2, 10000));
		system.assertEquals('13.955', XedeUtil.TruncateDecimalString(currentAPR, 3, 10000));

		currentAPR = null;
		system.assertEquals(null, XedeUtil.TruncateDecimalString(currentAPR, 2, 10000.0));
		
		system.assertEquals(null, XedeUtil.TruncateDecimalString('', 3, 10000));
		
		system.assertEquals('123.400', XedeUtil.TruncateDecimalString('123.4', 3));

		system.assertEquals(123.45, XedeUtil.TruncateDecimal(123.45, 3));
		system.assertEquals(123.456, XedeUtil.TruncateDecimal(123.45678, 3));

		system.assertEquals(120, XedeUtil.TruncateDecimal(123.45678, -1));
		
		Decimal nullDecimal;
		system.assertEquals(null, XedeUtil.TruncateDecimal(nullDecimal, 3));
		
		try {
			Integer nullScale;
			system.assertEquals(123.456, XedeUtil.TruncateDecimal(123.45678, nullScale));
			system.assert(false, 'scale of null throws exception');
		}
		catch (XedeException ex) {
			system.assertEquals('invalid scale: null', ex.getMessage());
		}

		try {
			system.assertEquals(123.45, XedeUtil.TruncateDecimal(123.45, 3, 0));
			system.assert(false, 'divisor of 0 throws exception');
		}
		catch (XedeException ex) {
			system.assertEquals('invalid divisor: 0', ex.getMessage());
		}
		
    }

    static testMethod void testSplitExpressions()
    {
    	System.assertEquals('one', XedeUtil.SubjectFromString('one.two.three'));
    	System.assertEquals('one', XedeUtil.SubjectFromString('one.\n\rtwo.\n\rthree.\r'));
    	System.assertEquals('one', XedeUtil.SubjectFromString('one.\n\rtwo.\n\rthree.\r'));
    	System.assertEquals('one', XedeUtil.SubjectFromString('one?  two.\n\rthree.\r'));
    	System.assertEquals('xxxxxxxxx0xxxxxxxxx0xxxxxxxxx0xxxxxxxxx0', XedeUtil.SubjectFromString('xxxxxxxxx0xxxxxxxxx0xxxxxxxxx0xxxxxxxxx0yyyyyy'));
    }
    
    static testMethod void testFormatListForQuery(){
    	List<String> aList = new List<String>{'a','b','c'};
    	
    	String formattedString = XedeUtil.formatListForQuery(aList);
    	system.assert(formattedString.startsWith('( \''), formattedString);
    	system.assert(formattedString.endsWith('\' )'), formattedString);
    	system.assertEquals(2, formattedString.countMatches(','));
    	
    	formattedString = formattedString.replaceAll('[() \']', '');
    	list<string> afterList = formattedString.split(',');
    	system.assertEquals(3, afterList.size());
    	
    	set<string> afterSet = new set<string>(afterList);
    	for (string each : aList)
    		system.assert(afterSet.contains(each), XedeLog.Write('{0} does not contain {1}', afterSet, each));
    	
    	// check for proper handling of single null
    	
    	formattedString = XedeUtil.formatListForQuery(new string[] { 'null' });
    	system.assertEquals('( null )', formattedString);
    	
    	// check for proper handling of multiple nulls
    	formattedString = XedeUtil.formatListForQuery(new string[] { 'null', 'NULL', null });
    	system.assertEquals('( null )', formattedString);
    }
    
    static testMethod void testDateString()
    {
    	system.assertEquals('2012-04-15', XedeUtil.DateString(Date.newInstance(2012, 4, 15)));
    }
    
    static testMethod void testRightString()
    {
    	system.assertEquals('789', XedeUtil.right('6789', 3));
    }
    
    static testMethod void testDatesInSets()
    {
    	map<date, string> dateMap = new map<date, string>();
    	
    	dateMap.put(Date.today(), 'today');
    	dateMap.put(Date.today().addDays(1), 'tomorrow');
    	dateMap.put(Date.today().addDays(-1), 'yesterday');
    	
    	system.assertEquals('today', dateMap.get(Date.today()));
    	system.assertEquals('yesterday', dateMap.get(Date.today().addDays(-1)));
    	system.assertEquals('tomorrow', dateMap.get(Date.today().addDays(1)));
    }
    
    
    
    static testMethod void listFormatTest()
    {
		list<string> aList = new string[] { 'one', 'two', 'three', 'null' };
    	string listAnswer = XedeUtil.FormatListForQuery(aList);
    	string setAnswer = XedeUtil.FormatListForQuery(new set<string>(aList));
    	system.assertEquals(listAnswer, setAnswer);
    	system.assertEquals(true, XedeUtil.ListIncludesNulls(aList));
    	system.assertEquals(false, XedeUtil.ListIncludesNulls(new string[] { 'a', 'b', 'c' } ));
    }
    
    static testMethod void fieldTest()
    {
		string aString = XedeUtil.truncateStringAtFieldLength('000000000x000000000x000000000x000000000x000000000x000000000x000000000x000000000x000', User.Username);
		system.assertNotEquals(null, aString);
    }
    
    static testMethod void localUrlTest()
    {
    	system.assert(XedeUtil.LocalUrlFor('home').endsWith('/home'));
    }

	static testMethod void StringListforPickListTest()
	{
		list<string> aList = XedeUtil.StringListForPickListField(Opportunity.StageName);
		system.assert(aList.isEmpty() == false);
	}   
}