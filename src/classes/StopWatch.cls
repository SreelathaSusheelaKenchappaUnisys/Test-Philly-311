public class StopWatch {
	
	public with sharing class Duration {
		Duration(long aMilliseconds) {
			milliseconds = aMilliseconds;
		}
		
		public long asLong() { return milliseconds; }
		public string asString() { return DateTime.NewInstance(milliseconds).format('mm:ss.SSS'); }
		
		long milliseconds;
	}
	
	public void reset() 
	{
		startTime = DateTime.Now().getTime();		
	}
	
	public Duration split() { return new Duration(Datetime.Now().getTime() - startTime); }
	public Duration startTime() { return new Duration(startTime); }

	public StopWatch() {
		this(DateTime.Now().getTime());
	}
	
	public StopWatch(long milliseconds)
	{
		startTime = milliseconds;
	}

	long startTime;
	list<string> log = new list<string>();
}