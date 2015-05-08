@isTest 
private class UnitTestCoverage2Test{

    static testMethod void giveMeCodeCoverage(){
        string x;
        x = UnitTestCoverage2.lotsOCode();
        
        system.assertNotEquals(0, x.length());
      }

}