@isTest
public class DQ_ScheduledEmail_Test {

   @isTest static void test() {
        List<User> userL = [SELECT Id, Name FROM User WHERE Department = 'Salesforfe' AND IsActive = true];

   		
			DQ_ScheduledEmail_00 batch = new DQ_ScheduledEmail_00(); 
			Id batchId = Database.executeBatch(batch); 
        
       /* AsyncApexJob aaj = [SELECT Id, Status, JobItemsProcessed, TotalJobItems, NumberOfErrors FROM AsyncApexJob WHERE ID =: batchId_00];
        System.assertEquals(userL.size(), aaj[0].JobItemsProcessed);
        System.assertEquals('Success', aaj[0].Status);
        System.assertEquals(0, aaj[0].NumberOfErrors);

        Daily_Quiz__c dq = new Daily_Quiz__c();
            dq.Answered__c = true;
            dq.Workload_Today__c = 'Test Data';
            dq.Workload_Yesterday__c = 'Test Data';
            dq.Workload_Product__c = false;
        insert dq;
        
        List<Daily_Quiz__c> dqL = [SELECT Id, CreatedById, Name FROM Daily_Quiz__c WHERE CreatedDate = TODAY];
        System.assertEquals(1, dqL.size());

        Test.startTest();
			DQ_ScheduledEmail_15 batch_15 = new DQ_ScheduledEmail_15(); 
			Id batchId_15 = Database.executeBatch(batch_15); 
        Test.stopTest(); */

       /* aaj = [SELECT Id, Status, JobItemsProcessed, TotalJobItems, NumberOfErrors FROM AsyncApexJob WHERE ID =: batchId_15];
        System.assertEquals(userL.size() - 1, Integer.valueOf(aaj[0].JobItemsProcessed));
        System.assertEquals('Success', aaj[0].Status);
        System.assertEquals(0, aaj[0].NumberOfErrors);*/
    }
    
    @isTest static void test15() {
        Test.startTest();
			DQ_ScheduledEmail_15 batch = new DQ_ScheduledEmail_15(); 
			Id batchId = Database.executeBatch(batch);
        Test.stopTest(); 
    }
    
    @isTest static void test30() {
        Test.startTest();
			DQ_ScheduledEmail_30 batch = new DQ_ScheduledEmail_30(); 
			Id batchId = Database.executeBatch(batch);
        Test.stopTest(); 
    }
}