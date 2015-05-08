global class ScheduleBatchUpdateCase implements Schedulable {

    // This test runs a scheduled job at midnight Sept. 3rd. 2022
    public static String CRON_EXP = '0 0 0 3 9 ? 2022';
   
    global void execute(SchedulableContext ctx) {
        
        Integer ran = Integer.valueOf(Math.Random()*10);
        Integer previousHr = System.now().hour();
        DateTime temp = System.now().addMinutes(15+ran);
        String day = string.valueOf(temp.day());
        String month = string.valueOf(temp.month());       
        String hour  = string.valueOf(temp.hour());  
        String minute = string.valueOf(temp.minute());  
        String second = string.valueOf(temp.second());
        String year = string.valueOf(temp.year());
        List<String> mon = new List<String>();
        mon.add(' ');
        mon.add('Jan');
        mon.add('Feb');
        mon.add('Mar');
        mon.add('Apr');
        mon.add('May');
        mon.add('Jun');
        mon.add('Jul');
        mon.add('Aug');
        mon.add('Sep');
        mon.add('Oct');
        mon.add('Nov');
        mon.add('Dec');
        
        if(previousHr < 5 && temp.hour() >= 5)    {
            temp = temp.addDays(1);
            day = String.valueOf(temp.day());
            minute = '0';
            hour = '22';
            month = String.valueOf(temp.month()); 
        }
            
        String strJobName = 'BatchUpdateCase at' + hour + ':' + minute + ' ' + day + ', ' + mon[Integer.valueOf(month)];
        String strSchedule = '0 ' + minute + ' ' + hour + ' ' + day + ' ' + month + ' ?' + ' ' + year; 
        BatchUpdateCase buc = new BatchUpdateCase();
        ScheduleBatchUpdateCase obj = new ScheduleBatchUpdateCase();
        Database.executebatch(buc);
        System.schedule('BatchUpdateCase', strSchedule, obj);      
        
    }
}