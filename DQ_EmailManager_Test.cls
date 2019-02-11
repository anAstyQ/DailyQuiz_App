@isTest
public class DQ_EmailManager_Test {
    
    @isTest
    public static void sendMailNeg(){
        ID userID = [Select Id, SenderEmail, Name From User WHERE Department = 'Salesforce' AND Name =: System.UserInfo.getName() LIMIT 1].Id;
        String emailTemplate = 'Email Notification. 01 am';
        Boolean actual = DQ_EmailManager.sendMail(userID, emailTemplate);
        System.assertEquals(false, actual);
    }
    
    @isTest
    public static void sendMailPos(){
        ID userID = [Select Id, SenderEmail, Name From User WHERE Department = 'Salesforce' AND Name =: System.UserInfo.getName() LIMIT 1].Id;
        String emailTemplate = 'Email Notification. 10 am';
        Boolean actual = DQ_EmailManager.sendMail(userID, emailTemplate);
        System.assertEquals(true, actual);
    }
    
    @isTest
    public static void checkWhoPassedNeg(){
        ID userID = [Select Id, SenderEmail, Name From User WHERE Department = 'Salesforce' AND Name =: System.UserInfo.getName() LIMIT 1].Id;
        Boolean actual = DQ_EmailManager.checkWhoPassed(userId);
        System.assertEquals(false, actual);
    }
    
    @isTest
    public static void checkWhoPassedPos(){
        Daily_Quiz__c dq = new Daily_Quiz__c();
            dq.Answered__c = true;
            dq.Workload_Today__c = 'Test Data';
            dq.Workload_Yesterday__c = 'Test Data';
            dq.Workload_Product__c = false;
        insert dq;
        
        ID userID = [Select Id, SenderEmail, Name From User WHERE Department = 'Salesforce' AND Name =: System.UserInfo.getName() LIMIT 1].Id;
        Boolean actual = DQ_EmailManager.checkWhoPassed(userId);
        System.assertEquals(true, actual);
    }
}