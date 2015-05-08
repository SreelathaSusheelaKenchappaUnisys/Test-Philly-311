public with sharing class XedeObjectHolder extends XedeObject {
	public void add(XedeObjectHolder aHolder) {
		child.add(aHolder);
		aHolder.setParent(this);
		
		XedeLog.Write('{0} added child {1}', 
			getSobjectName(),
			aHolder.getSobjectName()
		);
	}
	
	public void add(sobject anSobject, string theParentFieldName)
	{
		add(new XedeObjectHolder(anSobject, theParentFieldName));
	}
	
	public string getId() { return sobjectData.id; }
	
	public string getSobjectName() { return sobjectData.getSobjectType().getDescribe().getName(); }
	
	public string getString(string aFieldName) { return (String) sobjectData.get(aFieldName); }
	
	public XedeObjectHolder remove(sobject anSobject)
	{
		XedeObjectHolder aHolder;
		integer index;
		
		for (integer i = 0; i < child.size(); i++) {
			if (anSobject == child[i].sobjectData) {
				index = i;
				aHolder = child[index];
				if (anSobject.id != null)
					deleteList.add(anSobject);
			}
		}	
		
		if (index != null)
			system.assertEquals(aHolder, child.remove(index));
		
		return aHolder;
	}
	
	public override void saveTo(list<sobject> aList, list<XedeObject> dependentList)
	{
		if (parent == null) {
			aList.add(sobjectData);
		
			for (XedeObjectHolder each : child)
				each.saveTo(aList, dependentList);
			
			return;
		}
		
		string parentId = parent.getId();
		
		if (parentId == null) {
			dependentList.add(this);
			return;
		}
		
		XedeLog.Write('{0}({1}) writing with {2}({3})', getSobjectName(), getId(), parent.getSobjectName(), parentId);
		
		if (sobjectData.get(parentFieldName) == null)
			sobjectData.put(parentFieldName, parentId);
			
		aList.add(sobjectData);
		
		return;
	}
	
	public void setParent(XedeObjectHolder aHolder) { 
		parent = aHolder; 
	}
	
	public integer size() { return child.size(); }
	
	public XedeObjectHolder(sobject anSobject) {
		sobjectData = anSobject;
	}
	
	public XedeObjectHolder(sobject anSobject, string aParentFieldName) {
		sobjectData = anSobject;
		parentFieldName = aParentFieldName;
	}
	
	public list<XedeObjectHolder> child = new list<XedeObjectHolder>();
	list<sobject> deleteList = new list<sobject>();
	public XedeObjectHolder parent { get; private set; }
	public string parentFieldName { get; private set; }
	public sobject sobjectData { get; private set; }
}