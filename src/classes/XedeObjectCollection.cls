public with sharing class XedeObjectCollection extends XedeObject {
	public void add(XedeObject anXObject) {
		objectList.add(anXobject);
	}
	
	public boolean isEmpty() { return objectList.isEmpty(); }
	
	public override void saveTo(list<sobject> sobjectList, list<XedeObject> dependentList)
	{
		for (XedeObject each : objectList)
			each.saveTo(sobjectList, dependentList);
	}
	
	public integer size() { return objectList.size(); }
	
	public XedeObjectCollection() {}
	public XedeObjectCollection(list<XedeObject> aList) {
		objectList.addAll(aList);
	}
	
	list<XedeObject> objectList = new list<XedeObject>();
}