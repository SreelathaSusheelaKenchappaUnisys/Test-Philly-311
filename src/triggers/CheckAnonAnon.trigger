trigger CheckAnonAnon on Contact (before insert,before update ) {
    String name ;
    for(Contact c : Trigger.new ) {
        if(c.firstName != null)
            name = c.firstName+ ' ' + c.lastName;
        else 
            name = c.lastName;    
        if(name.equalsIgnoreCase('ANON ANON')) {
            c.addError('Contact Name Not Permissible');
        }
        if(trigger.isUpdate) {
            
            if(c.id == '003G000001lF2wN'  || c.Email == 'anonymous@publicstuff.com') {
                c.addError('You Dont Have Permission To Update This Contact');
            }
        }
    }
}