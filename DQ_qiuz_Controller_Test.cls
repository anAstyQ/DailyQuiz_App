@isTest
private class DQ_qiuz_Controller_Test {

    static void makeData(Integer endI){
        List<Daily_Quiz__c> dqL = new List<Daily_Quiz__c>();
        Daily_Quiz__c dq = new Daily_Quiz__c();
            dq.Workload_Yesterday__c = 'Workload_Yesterday__c Test Data';
        	dq.AddInfo__c = 'AddInfo__c Test Data';
        	dq.Workload_Product__c = false;
        for(Integer i = 0; i < endI; i++){
            dq.Workload_Today__c = 'Workload_Today__c Test Data ' + i;
            dqL.add(dq);
        }
        insert(dqL);
    }
    
    @isTest static void DQ_qiuz_Controller_Test(){
        String sDate = Date.today().year() + '-' + Date.today().month() + '-' + Date.today().day();
        List<Daily_Quiz__c> dqL = [SELECT Id, Name, Owner.Name, CreatedDateStr__c , Answered__c, AddInfo__c, Commerce_Project__c, 
                                   Estimated_Time__c, In_Time__c, Workload_Product__c, Workload_Today__c, Workload_Yesterday__c 
                                   FROM Daily_Quiz__c WHERE CreatedById =: System.UserInfo.getUserId() AND CreatedDateStr__c =: sDate LIMIT 1];
        DQ_qiuz_Controller contr = new DQ_qiuz_Controller();
        System.assertEquals(0, dqL.size());
        System.assertEquals(false, contr.doUpdate);
        
        makeData(1);
        contr = new DQ_qiuz_Controller();
        dqL = [SELECT Id, Name, Owner.Name, CreatedDateStr__c , Answered__c, AddInfo__c, Commerce_Project__c, 
              Estimated_Time__c, In_Time__c, Workload_Product__c, Workload_Today__c, Workload_Yesterday__c 
              FROM Daily_Quiz__c WHERE CreatedById =: System.UserInfo.getUserId() AND CreatedDateStr__c =: sDate LIMIT 1];
        System.assertEquals(1, dqL.size());
        System.assertEquals(true, contr.doUpdate);
        System.assertEquals(dqL[0].Workload_Today__c, contr.Workload_Today);
        System.assertEquals(dqL[0].Workload_Yesterday__c, contr.Workload_Yesterday);
        System.assertEquals('' + dqL[0].Workload_Product__c + '', contr.prodWorkload);
        System.assertEquals(dqL[0].Commerce_Project__c, contr.Commerce_Project);
        System.assertEquals(dqL[0].Estimated_Time__c, contr.Estimated_Time);
        System.assertEquals(dqL[0].AddInfo__c, contr.AddInfo);
        System.assertEquals(dqL[0].Id, contr.dq.Id);
        
        System.assertEquals(System.UserInfo.getName(), contr.currentUser);
        DateTime dtTest = System.now();
        System.assertEquals(dtTest.format('dd-MM-YYYY'), contr.todayD);
        System.assertEquals(dtTest.format('EEEE'), contr.dayOfWeek);
    }
    
    @isTest static void getItems_Test(){
        DQ_qiuz_Controller contr = new DQ_qiuz_Controller();
        System.assertEquals(2, contr.getItems().size());
    }
    
    @isTest static void getSetprodWorkload_Test(){
        DQ_qiuz_Controller contr = new DQ_qiuz_Controller();
        System.assertEquals(null, contr.getprodWorkload());
        contr.setprodWorkload('true');
        System.assertEquals('true', contr.getprodWorkload());
    }
    
    @isTest static void saveRecord_Test_Insert_prodYes(){
        DQ_qiuz_Controller contr = new DQ_qiuz_Controller();
        String sDate = Date.today().year() + '-' + Date.today().month() + '-' + Date.today().day();
        List<Daily_Quiz__c> dqL = [SELECT Id, Name, Owner.Name, CreatedDateStr__c , Answered__c, AddInfo__c, Commerce_Project__c, 
                                   Estimated_Time__c, In_Time__c, Workload_Product__c, Workload_Today__c, Workload_Yesterday__c 
                                   FROM Daily_Quiz__c WHERE CreatedById =: System.UserInfo.getUserId() AND CreatedDateStr__c =: sDate LIMIT 1];
        System.assertEquals(0, dqL.size());
        System.assertEquals(false, contr.doUpdate);
        
        contr.Workload_Today = 'Test Data Workload_Today';
        contr.Workload_Yesterday = 'Test Data Workload_Yesterday';
        contr.setprodWorkload('true');
        contr.Commerce_Project = 'Test Data Commerce_Project';
        contr.Estimated_Time = 5;
        contr.AddInfo = 'Test Data AddInfo';
        
        contr.saveRecord();
        
        dqL = [SELECT Id, Name, Owner.Name, CreatedDateStr__c , Answered__c, AddInfo__c, Commerce_Project__c, 
                                   Estimated_Time__c, In_Time__c, Workload_Product__c, Workload_Today__c, Workload_Yesterday__c 
                                   FROM Daily_Quiz__c WHERE CreatedById =: System.UserInfo.getUserId() AND CreatedDateStr__c =: sDate LIMIT 1];
        System.assertEquals(1, dqL.size());
        System.assertEquals(contr.Workload_Today, dqL[0].Workload_Today__c);
        System.assertEquals(contr.Workload_Yesterday, dqL[0].Workload_Yesterday__c);
        System.assertEquals(true, dqL[0].Workload_Product__c );
        System.assertEquals(contr.Commerce_Project, dqL[0].Commerce_Project__c);
        System.assertEquals(contr.Estimated_Time, dqL[0].Estimated_Time__c);
        System.assertEquals(contr.AddInfo, dqL[0].AddInfo__c);  
    }
    
    @isTest static void saveRecord_Test_Insert_prodNo(){
        DQ_qiuz_Controller contr = new DQ_qiuz_Controller();
        String sDate = Date.today().year() + '-' + Date.today().month() + '-' + Date.today().day();
        List<Daily_Quiz__c> dqL = [SELECT Id, Name, Owner.Name, CreatedDateStr__c , Answered__c, AddInfo__c, Commerce_Project__c, 
                                   Estimated_Time__c, In_Time__c, Workload_Product__c, Workload_Today__c, Workload_Yesterday__c 
                                   FROM Daily_Quiz__c WHERE CreatedById =: System.UserInfo.getUserId() AND CreatedDateStr__c =: sDate LIMIT 1];
        System.assertEquals(0, dqL.size());
        System.assertEquals(false, contr.doUpdate);
        
        contr.Workload_Today = 'Test Data Workload_Today';
        contr.Workload_Yesterday = 'Test Data Workload_Yesterday';
        contr.setprodWorkload('false');
        contr.Commerce_Project = 'Test Data Commerce_Project';
        contr.Estimated_Time = 5;
        contr.AddInfo = 'Test Data AddInfo';
        
        contr.saveRecord();
        
        dqL = [SELECT Id, Name, Owner.Name, CreatedDateStr__c , Answered__c, AddInfo__c, Commerce_Project__c, 
                                   Estimated_Time__c, In_Time__c, Workload_Product__c, Workload_Today__c, Workload_Yesterday__c 
                                   FROM Daily_Quiz__c WHERE CreatedById =: System.UserInfo.getUserId() AND CreatedDateStr__c =: sDate LIMIT 1];
        System.assertEquals(1, dqL.size());
        System.assertEquals(contr.Workload_Today, dqL[0].Workload_Today__c);
        System.assertEquals(contr.Workload_Yesterday, dqL[0].Workload_Yesterday__c);
        System.assertEquals(false, dqL[0].Workload_Product__c );
        System.assertEquals(null, dqL[0].Commerce_Project__c);
        System.assertEquals(null, dqL[0].Estimated_Time__c);
        System.assertEquals(contr.AddInfo, dqL[0].AddInfo__c); 
    }
   
    @isTest static void saveRecord_Test_Update_prodYes(){
        DQ_qiuz_Controller contr = new DQ_qiuz_Controller();
        String sDate = Date.today().year() + '-' + Date.today().month() + '-' + Date.today().day();
        List<Daily_Quiz__c> dqL = [SELECT Id, Name, Owner.Name, CreatedDateStr__c , Answered__c, AddInfo__c, Commerce_Project__c, 
                                   Estimated_Time__c, In_Time__c, Workload_Product__c, Workload_Today__c, Workload_Yesterday__c 
                                   FROM Daily_Quiz__c WHERE CreatedById =: System.UserInfo.getUserId() AND CreatedDateStr__c =: sDate LIMIT 1];
        System.assertEquals(0, dqL.size());
        System.assertEquals(false, contr.doUpdate);
        
        
        contr.Workload_Today = 'Test Data Workload_Today';
        contr.Workload_Yesterday = 'Test Data Workload_Yesterday';
        contr.setprodWorkload('false');
        contr.Commerce_Project = 'Test Data Commerce_Project';
        contr.Estimated_Time = 5;
        contr.AddInfo = 'Test Data AddInfo';
        
        contr.saveRecord();
        contr = new DQ_qiuz_Controller();
        dqL = [SELECT Id, Name, Owner.Name, CreatedDateStr__c , Answered__c, AddInfo__c, Commerce_Project__c, 
                                   Estimated_Time__c, In_Time__c, Workload_Product__c, Workload_Today__c, Workload_Yesterday__c 
                                   FROM Daily_Quiz__c WHERE CreatedById =: System.UserInfo.getUserId() AND CreatedDateStr__c =: sDate LIMIT 1];
        System.assertEquals(1, dqL.size());
        System.assertEquals(true, contr.doUpdate);
        
        System.assertEquals(contr.Workload_Today, dqL[0].Workload_Today__c);
        System.assertEquals(contr.Workload_Yesterday, dqL[0].Workload_Yesterday__c);
        System.assertEquals(false, dqL[0].Workload_Product__c );
        System.assertEquals(null, dqL[0].Commerce_Project__c);
        System.assertEquals(null, dqL[0].Estimated_Time__c);
        System.assertEquals(contr.AddInfo, dqL[0].AddInfo__c); 
        
        contr.setprodWorkload('true');
        contr.Commerce_Project = 'Test Data Commerce_Project';
        contr.Estimated_Time = 5;
        
        contr.saveRecord();
        
        dqL = [SELECT Id, Name, Owner.Name, CreatedDateStr__c , Answered__c, AddInfo__c, Commerce_Project__c, 
                                   Estimated_Time__c, In_Time__c, Workload_Product__c, Workload_Today__c, Workload_Yesterday__c 
                                   FROM Daily_Quiz__c WHERE CreatedById =: System.UserInfo.getUserId() AND CreatedDateStr__c =: sDate LIMIT 1];
        System.assertEquals(1, dqL.size());
        System.assertEquals(true, contr.doUpdate);
        System.assertEquals(contr.Workload_Today, dqL[0].Workload_Today__c);
        System.assertEquals(contr.Workload_Yesterday, dqL[0].Workload_Yesterday__c);
        System.assertEquals(true, dqL[0].Workload_Product__c );
        System.assertEquals(contr.Commerce_Project, dqL[0].Commerce_Project__c);
        System.assertEquals(contr.Estimated_Time, dqL[0].Estimated_Time__c);
        System.assertEquals(contr.AddInfo, dqL[0].AddInfo__c); 
    }
    
    @isTest static void saveRecord_Test_Update_prodNo(){
        DQ_qiuz_Controller contr = new DQ_qiuz_Controller();
        String sDate = Date.today().year() + '-' + Date.today().month() + '-' + Date.today().day();
        List<Daily_Quiz__c> dqL = [SELECT Id, Name, Owner.Name, CreatedDateStr__c , Answered__c, AddInfo__c, Commerce_Project__c, 
                                   Estimated_Time__c, In_Time__c, Workload_Product__c, Workload_Today__c, Workload_Yesterday__c 
                                   FROM Daily_Quiz__c WHERE CreatedById =: System.UserInfo.getUserId() AND CreatedDateStr__c =: sDate LIMIT 1];
        System.assertEquals(0, dqL.size());
        System.assertEquals(false, contr.doUpdate);
        
        
        contr.Workload_Today = 'Test Data Workload_Today';
        contr.Workload_Yesterday = 'Test Data Workload_Yesterday';
        contr.setprodWorkload('true');
        contr.Commerce_Project = 'Test Data Commerce_Project';
        contr.Estimated_Time = 5;
        contr.AddInfo = 'Test Data AddInfo';
        
        contr.saveRecord();
        contr = new DQ_qiuz_Controller();
        dqL = [SELECT Id, Name, Owner.Name, CreatedDateStr__c , Answered__c, AddInfo__c, Commerce_Project__c, 
                                   Estimated_Time__c, In_Time__c, Workload_Product__c, Workload_Today__c, Workload_Yesterday__c 
                                   FROM Daily_Quiz__c WHERE CreatedById =: System.UserInfo.getUserId() AND CreatedDateStr__c =: sDate LIMIT 1];
        System.assertEquals(1, dqL.size());
        System.assertEquals(true, contr.doUpdate);
        
        System.assertEquals(contr.Workload_Today, dqL[0].Workload_Today__c);
        System.assertEquals(contr.Workload_Yesterday, dqL[0].Workload_Yesterday__c);
        System.assertEquals(true, dqL[0].Workload_Product__c );
        System.assertEquals(contr.Commerce_Project, dqL[0].Commerce_Project__c);
        System.assertEquals(contr.Estimated_Time, dqL[0].Estimated_Time__c);
        System.assertEquals(contr.AddInfo, dqL[0].AddInfo__c); 
        
        contr.setprodWorkload('false');
        contr.Commerce_Project = 'Test Data Commerce_Project';
        contr.Estimated_Time = 5;
        
        contr.saveRecord();
        
        dqL = [SELECT Id, Name, Owner.Name, CreatedDateStr__c , Answered__c, AddInfo__c, Commerce_Project__c, 
                                   Estimated_Time__c, In_Time__c, Workload_Product__c, Workload_Today__c, Workload_Yesterday__c 
                                   FROM Daily_Quiz__c WHERE CreatedById =: System.UserInfo.getUserId() AND CreatedDateStr__c =: sDate LIMIT 1];
        System.assertEquals(1, dqL.size());
        System.assertEquals(true, contr.doUpdate);
        System.assertEquals(contr.Workload_Today, dqL[0].Workload_Today__c);
        System.assertEquals(contr.Workload_Yesterday, dqL[0].Workload_Yesterday__c);
        System.assertEquals(false, dqL[0].Workload_Product__c );
        System.assertEquals(null, dqL[0].Commerce_Project__c);
        System.assertEquals(null, dqL[0].Estimated_Time__c);
        System.assertEquals(contr.AddInfo, dqL[0].AddInfo__c); 
    }
    
    @isTest static void saveRecord_Test_Insert_DMLException(){
        DQ_qiuz_Controller contr = new DQ_qiuz_Controller();
        String sDate = Date.today().year() + '-' + Date.today().month() + '-' + Date.today().day();
        List<Daily_Quiz__c> dqL = [SELECT Id, Name, Owner.Name, CreatedDateStr__c , Answered__c, AddInfo__c, Commerce_Project__c, 
                                   Estimated_Time__c, In_Time__c, Workload_Product__c, Workload_Today__c, Workload_Yesterday__c 
                                   FROM Daily_Quiz__c WHERE CreatedById =: System.UserInfo.getUserId() AND CreatedDateStr__c =: sDate LIMIT 1];
        System.assertEquals(0, dqL.size());
        System.assertEquals(false, contr.doUpdate);
        
        contr.Workload_Today = 'Test Data Workload_Today';
        contr.Workload_Yesterday = 'Test Data Workload_Yesterday';
        contr.setprodWorkload('true');
        contr.Commerce_Project = 'Test Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_Project' + 
            'Test Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_Project' + 
            'Test Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_Project' + 
            'Test Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_Project' + 
            'Test Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_Project' + 
            'Test Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_Project' + 
            'Test Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_Project' + 
            'Test Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_Project' + 
            'Test Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_Project' + 
            'Test Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_Project' + 
            'Test Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_Project' + 
            'Test Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_Project' + 
            'Test Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_Project' + 
            'Test Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_Project' + 
            'Test Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_Project' + 
            'Test Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_Project' + 
            'Test Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_Project' + 
            'Test Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_Project' ;
        contr.Estimated_Time = 5;
        contr.AddInfo = 'Test Data AddInfo';
        System.assertEquals(null, contr.saveRecord());
    }
    
    @isTest static void saveRecord_Test_Update_DMLException(){
        DQ_qiuz_Controller contr = new DQ_qiuz_Controller();
        String sDate = Date.today().year() + '-' + Date.today().month() + '-' + Date.today().day();
       
        contr.Workload_Today = 'Test Data Workload_Today';
        contr.Workload_Yesterday = 'Test Data Workload_Yesterday';
        contr.setprodWorkload('false');
        contr.AddInfo = 'Test Data AddInfo';
        
        contr.saveRecord();
        contr = new DQ_qiuz_Controller();
        List<Daily_Quiz__c> dqL = [SELECT Id, Name, Owner.Name, CreatedDateStr__c , Answered__c, AddInfo__c, Commerce_Project__c, 
                                   Estimated_Time__c, In_Time__c, Workload_Product__c, Workload_Today__c, Workload_Yesterday__c 
                                   FROM Daily_Quiz__c WHERE CreatedById =: System.UserInfo.getUserId() AND CreatedDateStr__c =: sDate LIMIT 1];
        System.assertEquals(1, dqL.size());
        System.assertEquals(true, contr.doUpdate);
        
        contr.setprodWorkload('true');
        contr.Commerce_Project = 'Test Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_Project' + 
            'Test Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_Project' + 
            'Test Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_Project' + 
            'Test Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_Project' + 
            'Test Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_Project' + 
            'Test Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_Project' + 
            'Test Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_Project' + 
            'Test Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_Project' + 
            'Test Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_Project' + 
            'Test Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_Project' + 
            'Test Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_Project' + 
            'Test Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_Project' + 
            'Test Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_Project' + 
            'Test Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_Project' + 
            'Test Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_Project' + 
            'Test Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_Project' + 
            'Test Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_Project' + 
            'Test Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_ProjectTest Data Commerce_Project' ;
        contr.Estimated_Time = 5;
        
        System.assertEquals(null, contr.saveRecord()); 
    }
}