global class scheduleCommentInsertionPS implements Schedulable {

    // Schedule Class for CommentInsertionPS 
    global void execute(SchedulableContext SC) {
        CommentInsertionPS comIns =  new CommentInsertionPS();
        Database.executeBatch(comIns,5); //optional scope value can be given
        scheduleCommentInsertionPS obj = new scheduleCommentInsertionPS();
        DateTime temp = System.now().addHours(2);
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
        
        String strJobName = 'Comment Insert in PS Job at' + hour + ':' + minute + ' ' + day + ', ' + mon[Integer.valueOf(month)];
        String strSchedule = '0 ' + minute + ' ' + hour + ' ' + day + ' ' + month + ' ?' + ' ' + year; 
        System.schedule(strJobName, strSchedule, obj);      
    }  

}