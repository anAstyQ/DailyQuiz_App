public class DQ_Answer_Helper {

    public static List<Daily_Quiz__c> formDailyReport(Date fDate){
		if(fDate == null){ return null;}
		List<Daily_Quiz__c> mainList = new List<Daily_Quiz__c>();
        String sDate = fDate.year() + '-' + fDate.month() + '-' + fDate.day();
        mainList = [SELECT Id, Name, CreatedById, CreatedDateStr__c , Answered__c, AddInfo__c, Commerce_Project__c, Estimated_Time__c, In_Time__c, Workload_Product__c, Workload_Today__c, Workload_Yesterday__c, Owner.Name FROM Daily_Quiz__c
                    WHERE CreatedDateStr__c =: sDate];
		return mainList;
    }
    
    public static List<String> formListOfDates(List<List<Daily_Quiz__c>> dqLL){
        List<String> datesL = new List<String>();
        String dayOfWeek;
        if(dqLL.size() > 0){
            for(List<Daily_Quiz__c> innerL : dqLL){
                dayOfWeek = ', ' + DateTime.newInstance(Date.valueOf(innerL[0].CreatedDateStr__c), Time.newInstance(0, 0, 0, 0)).format('EEEE');
                datesL.add(innerL[0].CreatedDateStr__c + dayOfWeek);
            }
        }
        return datesL;
    }
    
    public static List<List<Daily_Quiz__c>> formMonthlyReport(Date fDate){
        List<List<Daily_Quiz__c>> monthL = new List<List<Daily_Quiz__c>>();
        Integer daysInMonth = Date.daysInMonth(fDate.year(), fDate.month());
        Date iterTmp = fDate.toStartOfMonth().addDays(daysInMonth-1);
        for(Integer i = 0; i < daysInMonth; i++){
            List<Daily_Quiz__c> tmpL = formDailyReport(iterTmp);
            if(tmpL.size() > 0){
                monthL.add(tmpL);
            }
            iterTmp = iterTmp.addDays(-1);
        }
        return monthL;
    }
    
    public static List<User> getUsersWithoutQuiz(List<Daily_Quiz__c> dqL){
        Set<ID> usersWithQuiz = new Set<ID>();
        for(Integer i = 0; i < dqL.size(); i++){
            usersWithQuiz.add(dqL[i].CreatedById);
        }
        List<User> userL = [SELECT Id, Name FROM user WHERE Department = 'Salesforce' AND IsActive = true AND Id NOT IN: usersWithQuiz];
        system.debug('***users:'+userL);
        return userL;
    }
    
    public static Boolean checkProfile(String profId){
        String profileName = [SELECT Id, Name FROM Profile WHERE Id =: profId].Name;
        if(profileName == 'System Administrator'){
            return true;
        } else {
            return false;
        }
    }
}