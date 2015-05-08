public class myWeb2LeadExtension {

    public Lead weblead;
    public String cName { get; set; }  
    Set<String> originalvalues = new Set<String>();
    Public List<string> leftselected{get;set;}
    Public List<string> rightselected{get;set;}
    Set<string> leftvalues = new Set<string>();
    Set<string> rightvalues = new Set<string>();
    public  PageReference p{get;set;}
     
    public List<SelectOption> getStoryItems()    {
        List<SelectOption> options = new List<SelectOption>();
        List<Campaign> campList = [Select id ,Name, IsActive from campaign where IsActive = True]; 
        for(Campaign camp:campList )
            options.add(new SelectOption(camp.Name,camp.Name));
        return options;
    }
    public PageReference selectclick(){
        rightselected.clear();
        for(String s : leftselected){
            leftvalues.remove(s);
            rightvalues.add(s);
        }
        return null;
    }
     
    public PageReference unselectclick(){
        leftselected.clear();
        for(String s : rightselected){
            rightvalues.remove(s);
            leftvalues.add(s);
        }
        return null;
    }
 
    public List<SelectOption> getunSelectedValues(){
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(leftvalues);
        tempList.sort();
        for(string s : tempList)
            options.add(new SelectOption(s,s));
        return options;
    }
 
    public List<SelectOption> getSelectedValues(){
        List<SelectOption> options1 = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(rightvalues);
        tempList.sort();
        for(String s : tempList)
            options1.add(new SelectOption(s,s));
        return options1;
    }
    
    String[] stories= new String[]{};
        
    public String[] getStories()  {
        return stories;
    }
    
    public void setStories(String[] stories) {
        this.stories= stories;
    }
    
    
    public myWeb2LeadExtension(ApexPages.StandardController stdController) {
       weblead = (Lead)stdController.getRecord();
        cName =ApexPages.currentPage().getParameters().get('CampaignName');     
        List<Campaign> campList = [Select id ,Name, IsActive from campaign where IsActive = True]; 
        for(Campaign camp:campList )
            originalValues.add(camp.Name);
        leftselected = new List<String>();
        rightselected = new List<String>();
        leftvalues.addAll(originalValues);
        weblead.Campaign_Name__c = cName;

    }
    
    public void setcampName(String camp) {
        weblead.campaign_Name__c = camp;
     }   

     public PageReference saveLead() {
        
        if(null==weblead.company) {
             weblead.company='Not Provided';
        }
        weblead.LeadSource='Registered Campaign Member';
        insert(weblead);
        Lead l=[select id,campaign_Name__c from lead where id=:weblead.id ];
        List<Campaign> campList2 = [Select id ,Name, IsActive from campaign where IsActive = True]; 
        list<CampaignMember> cm1=new List<CampaignMember>();
        for (Campaign c : campList2 ) {
            if(l.campaign_Name__c.contains(c.Name)) {
                  CampaignMember cm = new CampaignMember();
                  cm.LeadId=l.id;
                  cm.CampaignId=c.id;
                  cm.Status='Responded';
                  cm1.add(cm);    
              } 
            }
          
          try {
              insert cm1;
          } catch(Exception e ) {
              ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,e.getMEssage()));
              return new pageReference('https://citywide-philadelphia.cs10.force.com/campaign/CampaignRegistrationFailure');
              
          } 
          
       return new pageReference('https://citywide-philadelphia.cs10.force.com/campaign/CampaignRegistrationSuccess');
     }

}