/*
Copyright 2012, Xede Consulting Group, Inc.
*/

public virtual class XedeObject {
    public void addDependent(XedeObject anObject)
    {
        if (anObject != null)
            dependents.add(anObject);
    }
    
    public string addErrorMessage(string message) {
        addMessage(Apexpages.Severity.ERROR, message);
        return message;
    }
    
    public string addErrorMessage(string format, string arg1) {
        return addErrorMessage(String.Format(format, new string[] { '' + arg1 }));
    }
    
    public string addInfoMessage(string message) {
        StackHelper aStack = new StackHelper();
        addMessage(Apexpages.Severity.INFO, aStack.getFirstForeignFrame().getPrintString() + '\n' + message);
        return message;
    }
    
    public string addInfoMessage(string format, object arg1) {
        return addInfoMessage(String.Format(format, new string[] { '' + arg1 }));
    }
    
    public string addInfoMessage(string format, object arg1, object arg2) {
        return addInfoMessage(String.Format(format, new string[] { '' + arg1, '' + arg2 }));
    }
    
    public string addInfoMessage(string format, object arg1, object arg2, object arg3) {
        return addInfoMessage(String.Format(format, new string[] { '' + arg1, '' + arg2, '' + arg3 }));
    }
    
    public void addMessage(Apexpages.Severity aSeverity, string aMessage) {
        ApexPages.addMessage(new Apexpages.Message(aSeverity, aMessage));
    }    
    
    public void addWarningMessage(string message) {
        addMessage(Apexpages.Severity.WARNING, message);
    } 
       
    public date coalesce(date arg1, date arg2)
    {
        return arg1 == null ? arg2 : arg1;
    }
    
    public decimal coalesce(decimal arg1, decimal arg2)
    {
        return arg1 == null ? arg2 : arg1;
    }
    
    public string coalesce(string arg1, string arg2)
    {
        return String.IsBlank(arg1) ? arg2 : arg1;
    }
    
    public string coalesce(string arg1, string arg2, string arg3)
    {
        return coalesce(coalesce(arg1, arg2), arg3);
    }
    
    public string coalesce(ID arg1, string arg2)
    {
        return coalesce((string) arg1, arg2);
    }
    
    public virtual list<XedeObject> getDependents() { return dependents; }
    
    public virtual string printString() { return '' + this; }    
    
    public void removeDependent(XedeObject anObject)
    {
    	if (anObject == null)
    		return;
    		
    	list<integer> aList = new list<integer>();
    	
        for (integer i = 0; i < dependents.size(); i++)
        	if (dependents[i] == anObject)
        		aList.add(i);
        
        for (integer i = aList.size() - 1; i > -1; i--)
        	dependents.remove(aList[i]);
    }
    
    // the save and saveTo methods are inspired by Kent Beck's "collecting parameter"
    // pattern
    
    public virtual void save() 
	{		
		list<XedeObject> objectList = new list<XedeObject>();
		list<XedeObject> dependentList = new list<XedeObject> { this };
		
		do {
			List<sobject> aList = new List<sobject>();
			List<sobject> updateList = new List<sobject>();
			List<sobject> insertList = new List<sobject>();
			
			objectList = new list<XedeObject>(dependentList);
			dependentList.clear();
			
			for (XedeObject each: objectList)
				each.saveTo(aList, dependentList);
			
			for (sobject each : aList) {
				if (each.id == null)
					insertList.add(each);
				else
					updateList.add(each);
			}
			
			updateList.sort();
			insertList.sort();
			
			saveUpdateList(updateList);
			saveInsertList(insertList);
			
		} while (dependentList.isEmpty() == false);
	}
	
	// protected for the sole purpose of unit testing, not intended for sub-class override
    protected virtual void saveUpdateList(List<sobject> updateList) 
	{
		try {
			update updateList;
		}
		catch (DMLException ex) 
		{
			saveDMLException('Update error', updateList, ex);
		}
		catch (TypeException ex) 
		{
			saveTypeException('Update error', ex);
		}
	}

	// protected for the sole purpose of unit testing, not intended for sub-class override
    protected virtual void saveInsertList(List<sobject> insertList) 
	{
		try {
			insert insertList;
		}
		catch (DMLException dex) 
		{
			saveDMLException('Insert error', insertList, dex);
		}
		catch (TypeException ex) 
		{
			saveTypeException('Insert error', ex);
		}
	}
	
	void saveDMLException(string subject, list<sobject> slist, DMLException aDMLException)
	{
		string message = subject + '\n';
		
		for (Integer i = 0; i < aDMLException.getNumDml(); i++)
			message += 
				'\nerror #' + i +  
				'\nstatus code : ' + aDMLException.getDmlStatusCode(i) + 
				'\nmessage     : ' + aDMLException.getDmlMessage(i) + 
				'\nobject name : ' + slist[aDMLException.getDmlIndex(i)].getSObjectType().getDescribe().getName() +
				'\n' + slist[aDMLException.getDmlIndex(i)]; 
		
		XedeException.Raise(message);
	}
        
	void saveTypeException(string subject, TypeException aTypeException)
	{
		string message = subject + '\n';
		
		message += 
			'\ncause : ' + aTypeException.getCause() +  
			'\nline number : ' + aTypeException.getLineNumber() + 
			'\nmessage     : ' + aTypeException.getMessage() + 
			'\nstack trace : ' + aTypeException.getStackTraceString();
	
		XedeException.Raise(message);
	}
        
    public virtual void saveTo(List<sobject> aList)
	{
		subclassMethodError();
	}
	
	public virtual void saveTo(list<sobject> aList, list<XedeObject> dependentList)
	{
		saveTo(aList);
	}
	
	public string singleQuote(string aString) { return '\'' + aString + '\''; }

    protected virtual void subclassMethodError()
	{
		XedeException.Raise('My subclass should have implemented this method.');
	}
	
	protected list<XedeObject> dependents {
        get {
            if (dependents == null)
                dependents = new list<XedeObject>();
            
            return dependents;
        }
        
        private set;
    }
}