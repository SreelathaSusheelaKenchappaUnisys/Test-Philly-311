/*
Sammer, I need some unit tests for XedeJObject.  I'm currently using it inside
the Customer class, but it has no unit tests of its own.

We need tests to see how it handles member objects and arrays.

{ 'color' = 'red' } should have a size of 1, and when I ask jobject.getString('color') 
I should get 'red'.  If I ask getString('name') I should get null.

{ "color" = "red", "person" = { "first" = "sammer", "last" = "bashir" }} should
return another jobject when I ask getJobject('person'), then that jobject should
return 'sammer' when I ask for 'first' and 'bashir' when I ask for 'last'.

What I don't know is what will happen when the json string contains an array.  Will you find out?
*/

@isTest
private class XedeJObjectTest {
	
	class Shallow {
		public string color;
	}
	
	class Person {
		public Person(string aFirst, string aLast, string aCity) { first = aFirst; last = aLast; city = aCity;}
		public string first;
		public string last;
		public string city;
		public integer age;
	}
	
	class Deep {
		public string color;
		public Person person;
	}
	
	class DeepList {
		public string color;
		public Person person;
		public list<Person> people;
	}
    
    static testMethod void shallowTest() {
        Shallow aClass = new Shallow();
    	aClass.color = 'red';
    	
        string jsonString = JSON.serialize(aClass);
        
        XedeJObject jobject = new XedeJObject(jsonString);
        system.assertEquals('red', jobject.getString('color'));
    }

    static testMethod void deepTest() {
    	DeepList aClass = new DeepList();
    	aClass.color = 'red';
    	
    	Person aPerson = new Person('sammer', 'bashir', 'Canton');
    	aClass.person = aPerson;
    	
        string jsonString = JSON.serialize(aClass);
        
        XedeJObject jobject = new XedeJObject(jsonString);
        system.assertEquals('red', jobject.getString('color'));
        
        XedeJobject jPerson = jobject.getJobject('person');
        system.assertEquals('sammer', jPerson.getString('first'));
        system.assertEquals('bashir', jPerson.getString('last'));
        system.assertEquals('Canton', jPerson.getString('city'));
    }
    
    static testMethod void deepListTest() {
    	DeepList aClass = new DeepList();
    	aClass.color = 'red';
    	
    	Person aPerson = new Person('sammer', 'bashir', 'Canton');
    	aClass.person = aPerson;
    	
    	list<Person> aList = new list<Person>();
    	aList.add(new Person('haidar', 'douglah', 'Farmington Hills'));
    	aList.add(new Person('brian', 'piggins', 'Romulus'));
    	aList.add(new Person('Tom', 'Gagne', 'Frendale'));
    	
    	aClass.people = aList;
    	
        string jsonString = JSON.serialize(aClass);
        
        XedeJObject jobject = new XedeJObject(jsonString);
		List<XedeJObject> jList = jobject.getList('people');
		
		system.assertEquals(3, jList.size());
		
		Set<String> aSet = new Set<String>();
    	for (XedeJObject each : jList)
    		aSet.add(each.getString('last'));
    	system.assertEquals(3, aSet.size());
    	system.assert(aSet.contains('douglah'));
    	system.assert(aSet.contains('piggins'));
    	system.assert(aSet.contains('Gagne'));
    	   	
    }
    
	static testMethod void testWithObjectMap() {
		String dispCode = '125365985745';
		
		Map<String, Object> objectMap = new Map<String, Object>();
		
		objectMap.put('dispCode', dispCode);

		Map<String, String> fieldMap = new Map<String, String>();
		
		fieldMap.put('Disposition_Code__c', 'dispCode');
		
		objectMap.put('fieldMap', fieldMap);
		
		XedeJObject jobject = new XedeJObject(objectMap);
		
		system.assertEquals(dispCode, jobject.getString('dispCode'));
		
		Map<String, String> fieldMapFromJobject = (Map<String, String>)jobject.getObject('fieldMap');
		
		system.assertEquals('dispCode', fieldMapFromJobject.get('Disposition_Code__c'));
	}
	
	static testMethod void testPhoneStrings() {
		Map<string, string> stringMap = new Map<String, string> {
			'leadingzeroes' => '002482841600',
			'noleadingzeroes' => '2482841600',
			'formatted' => '(248) 284-1600',
			'shortstring' => '2841600'
		};
		
		XedeJObject jobject = new XedeJobject(Json.Serialize(stringMap));
		
		system.assertEquals('2482841600', jobject.getUSPhoneDigits('leadingzeroes'));
		system.assertEquals('2482841600', jobject.getUSPhoneDigits('noleadingzeroes'));
		system.assertEquals('2482841600', jobject.getUSPhoneDigits('formatted'));
		system.assertEquals('2841600', jobject.getUSPhoneDigits('shortstring'));
		system.assertEquals('', jobject.getUSPhoneDigits('missing'));
	}
	
	static testMethod void putTest() {
		Person aPerson = new Person('sammer', 'bashir', 'Canton');
		aPerson.age = 18;
    	
    	XedeJObject aJobject = new XedeJObject(Json.Serialize(aPerson));
    	aJobject.putObject('first', 'John');
    	aJobject.putObject('last', 'Doe');
    	aJobject.putObject('age', 21);
    	
    	aPerson = (Person) aJobject.deserialize(Person.class);
    	system.assertEquals('John', aPerson.first);
    	system.assertEquals('Doe', aPerson.last);
    	system.assertEquals(21, aPerson.age);
    	system.assertEquals('Canton', aPerson.city);
	}
}