public with sharing class XedeLog {
	
	public static StopWatch.Duration GetDuration() { return epoch.split(); }
	
	public static list<string> GetLog() { return log; }
	
	public static string GetLogString() {
		return String.Join(GetLog(), '\n');
	}
	
	public Static Integer Size() { return log.size(); }
	
	public static void Debug(string aString) { system.debug(Write(aString)); }
	public static void Debug(string aString, object arg1) { system.debug(Write(aString, arg1)); }
	public static void Debug(string aString, object arg1, object arg2) { system.debug(Write(aString, arg1, arg2)); }
	public static void Debug(string aString, object arg1, object arg2, object arg3) { system.debug(Write(aString, arg1, arg2, arg3)); }
	public static void Debug(string aString, object arg1, object arg2, object arg3, object arg4) { system.debug(Write(aString, arg1, arg2, arg3, arg4)); }
	public static void Debug(string aString, object arg1, object arg2, object arg3, object arg4, object arg5) { system.debug(Write(aString, arg1, arg2, arg3, arg4, arg5)); }
	public static void Debug(string aString, object arg1, object arg2, object arg3, object arg4, object arg5, object arg6) { system.debug(Write(aString, arg1, arg2, arg3, arg4, arg5, arg6)); }
	
	public static string Write(string aString)
	{
		log.add(epoch.split().asString() + ' : ' + aString);
		
		return aString;
	}
	
	public static string Write(string format, object arg1)
    {
        return Write(String.Format(format, new string[] { '' + arg1 }));
    }
    
    public static string Write(string format, object arg1, object arg2)
    {
		return Write(String.Format(format, new string[] { '' + arg1, '' + arg2 }));
    }
    
    public static string Write(string format, object arg1, object arg2, object arg3)
    {
        return Write(String.Format(format, new string[] { '' + arg1, '' + arg2, '' + arg3 }));
    }
    
    public static string Write(string format, object arg1, object arg2, object arg3, object arg4)
    {
        return Write(String.Format(format, new string[] { '' + arg1, '' + arg2, '' + arg3, '' + arg4 }));
    }
    
    public static string Write(string format, object arg1, object arg2, object arg3, object arg4, object arg5)
    {
        return Write(String.Format(format, new string[] { '' + arg1, '' + arg2, '' + arg3, '' + arg4, '' + arg5 }));
    }
    
    public static string Write(string format, object arg1, object arg2, object arg3, object arg4, object arg5, object arg6)
    {
        return Write(String.Format(format, new string[] { '' + arg1, '' + arg2, '' + arg3, '' + arg4, '' + arg5, '' + arg6 }));
    }
    
    public static string WriteLimits() {
    	return Write(
    		'script statements : {0}\n' +
			'call outs         : {1}\n' +
			'dml statements    : {2}\n', 
			Limits.getScriptStatements(),
			Limits.getCallouts(),
			Limits.getDmlStatements()
		);
    }
		
	static list<string> log = new list<string>();
	static StopWatch epoch = new StopWatch();
}