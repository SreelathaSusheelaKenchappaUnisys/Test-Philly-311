/*
Copyright 2012, Xede Consulting Group, Inc.
*/

public with sharing class XedeException extends Exception {
    public static void Raise(string aString)
    {
        throw new XedeException(aString);
    }
    
    public static void Raise(string aString, Exception anException)
    {
        throw new XedeException(aString, anException);
    }
    
    public static void Raise(string format, object arg1)
    {
        Raise(String.Format(format, new string[] { '' + arg1 }));
    }
    
    public static void Raise(string format, object arg1, object arg2)
    {
		Raise(String.Format(format, new string[] { '' + arg1, '' + arg2 }));
    }
    
    public static void Raise(string format, object arg1, object arg2, object arg3)
    {
        Raise(String.Format(format, new string[] { '' + arg1, '' + arg2, '' + arg3 }));
    }
    
    public static void Raise(string format, object arg1, object arg2, object arg3, object arg4)
    {
        Raise(String.Format(format, new string[] { '' + arg1, '' + arg2, '' + arg3, '' + arg4 }));
    }
}