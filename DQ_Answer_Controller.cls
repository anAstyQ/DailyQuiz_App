public class DQ_Answer_Controller {

    public Date pickedDate {get; set;}
    public String pickedMonth {get; set;}
    public List<Daily_Quiz__c> dqL {get; set;}
    public List<User> dqNotAnswL {get; set;}
    public List<String> datesL {get; set;}
    public List<List<Daily_Quiz__c>> dqLL {get; set;}
    public Boolean sysAdmin {get; set;}
    public Boolean monthlyView {get; set;}
    public String currentUser {get; set;}
    public String months {get; set;} 
    public String years {get; set;}
    
    public DQ_Answer_Controller(){
        sysAdmin = DQ_Answer_Helper.checkProfile(System.UserInfo.getProfileId());
        monthlyView = false;
        currentUser = System.UserInfo.getName();
        pickedDate = Date.today();
        months = String.valueOf(System.now().month());
        years = String.valueOf(System.now().year());
        dqL = new List<Daily_Quiz__c>();
        dqL = DQ_Answer_Helper.formDailyReport(pickedDate); 
        dqNotAnswL = new List<User>();
        dqNotAnswL = DQ_Answer_Helper.getUsersWithoutQuiz(dqL);
    }
    
    public void handleDateDatepicker(){
        dqL = DQ_Answer_Helper.formDailyReport(pickedDate);
        dqNotAnswL = DQ_Answer_Helper.getUsersWithoutQuiz(dqL);
    }
    
    public void handleDateArrowUp(){
        pickedDate = pickedDate.addDays(1);
        dqL = DQ_Answer_Helper.formDailyReport(pickedDate);
        dqNotAnswL = DQ_Answer_Helper.getUsersWithoutQuiz(dqL);
    }
    
    public void handleDateArrowDown(){
        pickedDate = pickedDate.addDays(-1);
        dqL = DQ_Answer_Helper.formDailyReport(pickedDate);
        dqNotAnswL = DQ_Answer_Helper.getUsersWithoutQuiz(dqL);
    }
    
    public void handleMonthlyView(){
        monthlyView = true;
        dqLL = new List<List<Daily_Quiz__c>>();
        dqLL = DQ_Answer_Helper.formMonthlyReport(pickedDate);
        datesL = DQ_Answer_Helper.formListOfDates(dqLL);
    }
    
    public void changeMonthChecklists(){
        dqLL = new List<List<Daily_Quiz__c>>();
        dqLL = DQ_Answer_Helper.formMonthlyReport(Date.newInstance(Integer.valueOf(years), Integer.valueOf(months), 13));
        datesL = DQ_Answer_Helper.formListOfDates(dqLL);
    }
    
    public void handleDailyView(){
        monthlyView = false;
        dqL = DQ_Answer_Helper.formDailyReport(pickedDate); 
        dqNotAnswL = DQ_Answer_Helper.getUsersWithoutQuiz(dqL);
    }
    
    public List<SelectOption> getItemsMonths() {
        List<SelectOption> options = new List<SelectOption>();
        DateTime dt = DateTime.newInstance(Date.today().year(), 1, 1, 1, 0, 0);
        for(Integer i = 1; i < 13; i++){
            options.add(new SelectOption(String.valueOf(i), dt.addMonths(i-1).format('MMMM')));
        }
        return options;
    }
    
    public List<SelectOption> getItemsYears() {
        List<SelectOption> options = new List<SelectOption>();
        for(Integer i = 2019; i <= Date.today().year(); i++){
            options.add(new SelectOption(String.valueOf(i), String.valueOf(i)));
        }
        return options;
    }
}