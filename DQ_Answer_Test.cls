@isTest
private class DQ_Answer_Test {

    static void makeData(){
        Daily_Quiz__c dq = new Daily_Quiz__c();
            dq.Workload_Today__c = 'Test Data Workload_Today__c';
            dq.Workload_Yesterday__c = 'Test Data Workload_Yesterday__c';
            dq.Workload_Product__c = true;
            dq.Commerce_Project__c = 'Test Data Commerce_Project__c';
            dq.Estimated_Time__c = 8;
            dq.AddInfo__c = 'Test Data AddInfo__c';
        insert dq;
    }
    
    static void makeDataByDifferentUsers(){
        List<User> userL = [SELECT Id, Name FROM user WHERE Department = 'Salesforce' AND IsActive = true];
        if(userL.size() > 0){
            for(Integer i = 0; i <userL.size(); i++){
                System.runAs(userL[i]){
                    makeData();
                }
            }
        }
    }
    
    @isTest static void formDailyReport_TestNeg(){
        System.assertEquals(null, DQ_Answer_Helper.formDailyReport(null));
        System.assertEquals(0, DQ_Answer_Helper.formDailyReport(Date.today()).size());
    }
    
    @isTest static void formDailyReport_TestPos(){
        makeData();
        List<Daily_Quiz__c> dq = [SELECT Id, Name, CreatedById, CreatedDateStr__c , Answered__c, AddInfo__c, Commerce_Project__c, Estimated_Time__c, In_Time__c, 
                    Workload_Product__c, Workload_Today__c, Workload_Yesterday__c, Owner.Name FROM Daily_Quiz__c WHERE CreatedDate = TODAY];
        System.assertEquals(dq.size(), DQ_Answer_Helper.formDailyReport(Date.today()).size());
    }
    
    @isTest static void formListOfDates_TestPos(){
        List<List<Daily_Quiz__c>> dqLL = new List<List<Daily_Quiz__c>>();
        List<Daily_Quiz__c> dqL = new List<Daily_Quiz__c>();
        makeData();
        List<Daily_Quiz__c> dq = [SELECT Id, Name, CreatedById, CreatedDateStr__c , Answered__c, AddInfo__c, Commerce_Project__c, Estimated_Time__c, In_Time__c, 
                    Workload_Product__c, Workload_Today__c, Workload_Yesterday__c, Owner.Name FROM Daily_Quiz__c WHERE CreatedDate = TODAY];
        dqLL.add(dq);
        System.debug(dqLL);
        String expected = dq[0].CreatedDateStr__c + ', ' + DateTime.newInstance(Date.valueOf(dq[0].CreatedDateStr__c), Time.newInstance(0, 0, 0, 0)).format('EEEE');
        List<String> actual = DQ_Answer_Helper.formListOfDates(dqLL);
        System.assertEquals(dqLL.size(), actual.size());
        System.assertEquals(expected, actual[0]);
    }
    
    @isTest static void formListOfDates_TestNeg(){
        List<List<Daily_Quiz__c>> dqLL = new List<List<Daily_Quiz__c>>();

        List<String> actual = DQ_Answer_Helper.formListOfDates(dqLL);
        System.assertEquals(dqLL.size(), actual.size());
        System.assertEquals(0, actual.size());
    }
    
    @isTest static void getUsersWithoutQuiz_TestPos(){
        makeData();
        List<User> actual = DQ_Answer_Helper.getUsersWithoutQuiz(DQ_Answer_Helper.formDailyReport(Date.today()));
        List<Daily_Quiz__c> dqL = [SELECT Id, Name, CreatedById, CreatedDateStr__c , Answered__c, AddInfo__c, Commerce_Project__c, Estimated_Time__c, In_Time__c, 
                    Workload_Product__c, Workload_Today__c, Workload_Yesterday__c, Owner.Name FROM Daily_Quiz__c WHERE CreatedDate = TODAY];
        List<User> userL = [SELECT Id, Name FROM user WHERE Department = 'Salesforce' AND IsActive = true];
        System.assertEquals(userL.size() - dqL.size(), actual.size());
    }
    
    @isTest static void getUsersWithoutQuiz_TestNeg(){
        makeDataByDifferentUsers();
        List<User> actual = DQ_Answer_Helper.getUsersWithoutQuiz(DQ_Answer_Helper.formDailyReport(Date.today()));
        List<Daily_Quiz__c> dqL = [SELECT Id, Name, CreatedById, CreatedDateStr__c , Answered__c, AddInfo__c, Commerce_Project__c, Estimated_Time__c, In_Time__c, 
                    Workload_Product__c, Workload_Today__c, Workload_Yesterday__c, Owner.Name FROM Daily_Quiz__c WHERE CreatedDate = TODAY];
        List<User> userL = [SELECT Id, Name FROM user WHERE Department = 'Salesforce' AND IsActive = true];
        System.assertEquals(userL.size() - dqL.size(), actual.size());
        System.assertEquals(0, actual.size());
    }
    
    @isTest static void checkProfile_TestNeg(){
        List<Profile> profL = [SELECT Id, Name FROM Profile WHERE Name = 'Daily Quiz Standard User' LIMIT 1];
        if(profL.size() == 1){
        	System.assertEquals(false, DQ_Answer_Helper.checkProfile(profL[0].Id)); 
        }
    }
    
    @isTest static void checkProfile_TestPos(){
        List<Profile> profL = [SELECT Id, Name FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        if(profL.size() == 1){
        	System.assertEquals(true, DQ_Answer_Helper.checkProfile(profL[0].Id)); 
        }
    }
    
    @isTest static void formMonthlyReport_TestNeg(){
        List<List<Daily_Quiz__c>> dqLL = DQ_Answer_Helper.formMonthlyReport(Date.today());
        System.assertEquals(0, dqLL.size());
    }
    
    @isTest static void formMonthlyReport_TestPos(){
        makeDataByDifferentUsers();
        List<List<Daily_Quiz__c>> dqLL = DQ_Answer_Helper.formMonthlyReport(Date.today());
        System.assertEquals(1, dqLL.size());
        List<User> userL = [SELECT Id, Name FROM user WHERE Department = 'Salesforce' AND IsActive = true];
        System.assertEquals(userL.size(), dqLL[0].size());
    }
    
    @isTest static void DQ_Answer_Controller_TestController(){
        List<User> userL = [SELECT Id, Name FROM user WHERE Department = 'Salesforce' AND IsActive = true];
        
        ID sysAdmID = [SELECT Id, Name FROM Profile WHERE Name = 'System Administrator'].Id;
        User admin = [SELECT Id, Name FROM User WHERE ProfileId =: sysAdmID AND IsActive = true LIMIT 1];
        System.runAs(admin){
            DQ_Answer_Controller dq = new DQ_Answer_Controller();
            System.assertEquals(true, dq.sysAdmin);
            System.assertEquals(false, dq.monthlyView);
            System.assertEquals(admin.Name, dq.currentUser);
            System.assertEquals(Date.today(), dq.pickedDate);
            System.assertEquals(String.valueOf(System.now().month()), dq.months);
            System.assertEquals(String.valueOf(System.now().year()), dq.years);
            System.assertEquals(0, dq.dqL.size());
            System.assertEquals(userL.size(), dq.dqNotAnswL.size());
            
            makeData();
            List<Daily_Quiz__c> dqL = [SELECT Id, Name, CreatedById, CreatedDateStr__c , Answered__c, AddInfo__c, Commerce_Project__c, Estimated_Time__c, In_Time__c, 
                    Workload_Product__c, Workload_Today__c, Workload_Yesterday__c, Owner.Name FROM Daily_Quiz__c WHERE CreatedDate = TODAY];
            dq = new DQ_Answer_Controller();
            System.assertEquals(true, dq.sysAdmin);
            System.assertEquals(false, dq.monthlyView);
            System.assertEquals(admin.Name, dq.currentUser);
            System.assertEquals(Date.today(), dq.pickedDate);
            System.assertEquals(String.valueOf(System.now().month()), dq.months);
            System.assertEquals(dq.years, String.valueOf(System.now().year()));
            System.assertEquals(dqL.size(), dq.dqL.size());
        }
        
        ID standartID = [SELECT Id, Name FROM Profile WHERE Name = 'Daily Quiz Standard User'].Id;
        User standart = [SELECT Id, Name FROM User WHERE ProfileId =: standartID AND IsActive = true LIMIT 1];
        System.runAs(standart){
            List<Daily_Quiz__c> dqL = [SELECT Id, Name, CreatedById, CreatedDateStr__c , Answered__c, AddInfo__c, Commerce_Project__c, Estimated_Time__c, In_Time__c, 
                    Workload_Product__c, Workload_Today__c, Workload_Yesterday__c, Owner.Name FROM Daily_Quiz__c WHERE CreatedDate = TODAY];
            DQ_Answer_Controller dq = new DQ_Answer_Controller();
            System.assertEquals(false, dq.sysAdmin);
            System.assertEquals(false, dq.monthlyView);
            System.assertEquals(standart.Name, dq.currentUser);
            System.assertEquals(Date.today(), dq.pickedDate);
            System.assertEquals(String.valueOf(System.now().month()), dq.months);
            System.assertEquals(String.valueOf(System.now().year()), dq.years);
            System.assertEquals(dqL.size(), dq.dqL.size());
            System.assertEquals(userL.size(), dq.dqNotAnswL.size());
            
            makeData();
            dqL = [SELECT Id, Name, CreatedById, CreatedDateStr__c , Answered__c, AddInfo__c, Commerce_Project__c, Estimated_Time__c, In_Time__c, 
                    Workload_Product__c, Workload_Today__c, Workload_Yesterday__c, Owner.Name FROM Daily_Quiz__c WHERE CreatedDate = TODAY];
            dq = new DQ_Answer_Controller();
            System.assertEquals(false, dq.sysAdmin);
            System.assertEquals(false, dq.monthlyView);
            System.assertEquals(standart.Name, dq.currentUser);
            System.assertEquals(Date.today(), dq.pickedDate);
            System.assertEquals(String.valueOf(System.now().month()), dq.months);
            System.assertEquals(dq.years, String.valueOf(System.now().year()));
            System.assertEquals(dqL.size(), dq.dqL.size());
        }
    }
    
    @isTest static void handleDateDatepicker_TestNeg(){
        DQ_Answer_Controller dq = new DQ_Answer_Controller();
        System.assertEquals(Date.today(), dq.pickedDate);
        System.assertEquals(0, dq.dqL.size());
        
        dq.handleDateDatepicker();
        System.assertEquals(0, dq.dqL.size());
        
        dq.pickedDate = Date.today().addDays(1);
        dq.handleDateDatepicker();
        System.assertEquals(0, dq.dqL.size());
    }

    @isTest static void handleDateDatepicker_TestPos(){
        DQ_Answer_Controller dq = new DQ_Answer_Controller();
        System.assertEquals(Date.today(), dq.pickedDate);
        System.assertEquals(0, dq.dqL.size());
        makeData();
        dq.pickedDate = Date.today();
        dq.handleDateDatepicker();
        System.assertEquals(1, dq.dqL.size());
    }
    
    @isTest static void handleDateArrowUpDown_Test(){
		DQ_Answer_Controller dq = new DQ_Answer_Controller();
        System.assertEquals(Date.today(), dq.pickedDate);
        
        dq.pickedDate = Date.today();
        dq.handleDateArrowUp();
        System.assertEquals(Date.today().addDays(1), dq.pickedDate);    
        
        dq.handleDateArrowDown();
        System.assertEquals(Date.today(), dq.pickedDate);
        
        dq.handleDateArrowDown();
        System.assertEquals(Date.today().addDays(-1), dq.pickedDate); 
        
        for(Integer i = 0; i < 5; i++){
            dq.handleDateArrowUp();
        }
        System.assertEquals(Date.today().addDays(4), dq.pickedDate);   
    }
    
    @isTest static void handleMonthly_DailyView(){
        DQ_Answer_Controller dq = new DQ_Answer_Controller();
        System.assertEquals(false, dq.monthlyView);
        System.assertEquals(null, dq.dqLL);
        
        makeData();
        dq.handleMonthlyView();
        System.assertEquals(true, dq.monthlyView);
        System.assertEquals(1, dq.dqLL.size());
        
        makeData();
        dq.handleDailyView();
        System.assertEquals(false, dq.monthlyView);
    }
    
    @isTest static void handle_ChangeMonthly_DailyView(){
        DQ_Answer_Controller dq = new DQ_Answer_Controller();
        System.assertEquals(false, dq.monthlyView);
        System.assertEquals(null, dq.dqLL);
        
        makeData();
        dq.handleMonthlyView();
        System.assertEquals(true, dq.monthlyView);
        System.assertEquals(1, dq.dqLL.size());
        
        dq.handleDailyView();
        System.assertEquals(false, dq.monthlyView);
        System.assertEquals(Date.today(), dq.pickedDate);
        
        dq.handleMonthlyView();
        System.assertEquals('' + Date.today().month() + '', dq.months);
        
        dq.months = '5';
        dq.changeMonthChecklists();
        System.assertEquals('5', dq.months);   
    }
    
    @isTest static void getItemsMonths_Test(){
        DQ_Answer_Controller dq = new DQ_Answer_Controller();
        List<SelectOption> soL = dq.getItemsMonths();
        System.assertEquals(12, soL.size());
        System.assertEquals(new SelectOption('4', 'April'), soL[3]);
    }
    
        
    @isTest static void getItemsYears_Test(){
        DQ_Answer_Controller dq = new DQ_Answer_Controller();
        List<SelectOption> expectedSO = new List<SelectOption>();
        for(Integer i = 2019; i <= Date.today().year(); i++){
            expectedSO.add(new SelectOption(String.valueOf(i), String.valueOf(i)));
        }
        
        List<SelectOption> soL = dq.getItemsYears();
        System.assertEquals(expectedSO.size(), soL.size());
        System.assertEquals(expectedSO[0], soL[0]);
    }
}