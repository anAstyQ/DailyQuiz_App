global class DQ_ScheduledEmail_00 implements Database.Batchable<SObject>, Database.Stateful, Schedulable {

    private Integer sentEmails;
    
	global void execute( SchedulableContext SC ){
        DQ_ScheduledEmail_00 batch = new DQ_ScheduledEmail_00();
        Database.executeBatch(batch, 1);
	}

    global Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'Select Id, SenderEmail, Name From User WHERE Department = \'Salesforce\' AND IsActive = true';
        return Database.getQueryLocator(query);
    }

	global void execute(Database.BatchableContext BC, List<SObject> scope){           
		for( SObject user : scope ){
            Boolean passed = DQ_EmailManager.checkWhoPassed(user.Id);
            if(passed == false){ 
                DQ_EmailManager.sendMail(user.Id, 'Email Notification. 10 am');
            }
        }
        update scope;
    }


    global void finish(Database.BatchableContext BC){
      
    }
}