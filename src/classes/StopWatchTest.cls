@isTest
public class StopWatchTest {
	static testMethod void QuickTest() {
		StopWatch aStopWatch = new StopWatch();
		
		StopWatch.Duration aSplit = aStopWatch.split();
		
		system.assert(aSplit.asLong() >= 0, 'should be positive');
		system.assert(aSplit.asLong() < 10L, 'should be < 10 milliseconds');
		system.assert(String.IsNotBlank(aSplit.asString()));
    }
}