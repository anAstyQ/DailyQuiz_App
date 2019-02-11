@isTest
private class DQ_InTime_Test {
	
    @isTest static void checkTimelinessPos(){
        DateTime lastModifiedDate = DateTime.newInstanceGmt(2019, 2, 4, 0, 0, 0);
        System.debug(lastModifiedDate.format('a'));
        Boolean actual = DQ_InTime_Helper.checkTimeliness(lastModifiedDate);
        System.assertEquals(true, actual);
    }
    
    @isTest static void checkTimelinessNeg(){
        DateTime lastModifiedDate = DateTime.newInstanceGmt(2019, 2, 4, 10, 31, 13);
        Boolean actual = DQ_InTime_Helper.checkTimeliness(lastModifiedDate);
        System.assertEquals(false, actual);
    }
    
    @isTest static void DQ_InTime_field_Insert(){
        Daily_Quiz__c dq = new Daily_Quiz__c();
            dq.Answered__c = true;
            dq.Workload_Today__c = 'Test Data';
            dq.Workload_Yesterday__c = 'Test Data';
            dq.Workload_Product__c = false;
        
        Test.startTest();
        	Database.SaveResult result = Database.insert(dq);
        Test.stopTest();
        
        System.assertEquals(true, result.isSuccess());
        System.assertEquals(0, result.getErrors().size());
        Daily_Quiz__c dqInserted = [SELECT Id, Name, In_Time__c FROM Daily_Quiz__c WHERE Id =: result.getId() LIMIT 1];
        System.assertEquals(DQ_InTime_Helper.checkTimeliness(System.now()), dqInserted.In_Time__c);
    }
    
    @isTest static void DQ_InTime_field_Update(){
        Daily_Quiz__c dq = new Daily_Quiz__c();
            dq.Answered__c = true;
            dq.Workload_Today__c = 'Test Data';
            dq.Workload_Yesterday__c = 'Test Data';
            dq.Workload_Product__c = false;
        insert dq;
        
        Daily_Quiz__c dqInserted = [SELECT Id, Name, In_Time__c FROM Daily_Quiz__c LIMIT 1];
        dqInserted.AddInfo__c = 'Test addInfo';
        Test.startTest();
        	Database.SaveResult result = Database.update(dqInserted);
        Test.stopTest();
        
        System.assertEquals(true, result.isSuccess());
        System.assertEquals(0, result.getErrors().size());
        Daily_Quiz__c dqUpdated = [SELECT Id, Name, In_Time__c FROM Daily_Quiz__c WHERE Id =: result.getId() LIMIT 1];
        System.assertEquals(DQ_InTime_Helper.checkTimeliness(System.now()), dqUpdated.In_Time__c);
    }
}