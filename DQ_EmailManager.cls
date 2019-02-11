public class DQ_EmailManager {

   public static Boolean sendMail(ID userID, String templateName) {
      Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
      List<EmailTemplate> emTempL = [SELECT id FROM EmailTemplate WHERE name =: templateName LIMIT 1];
      List<OrgWideEmailAddress> owea = [select Id from OrgWideEmailAddress where Address = 'salesforce.department@gmail.com'];      
      if(emTempL.size() == 0 || owea.size() == 0){
           return false;
      }
          mail.setOrgWideEmailAddressId(owea[0].Id);
          mail.setTemplateId(emTempL[0].Id);   
          mail.setTargetObjectId(userID);
          mail.setSaveAsActivity(false);
       
      Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
      return inspectResults(results);
   }
    
    
    public static Boolean checkWhoPassed(ID userId){
        Boolean result = true;
        List<Daily_Quiz__c> dq = [SELECT Id, CreatedById FROM Daily_Quiz__c WHERE CreatedById =: userId AND CreatedDate = TODAY];
        if(dq.size() == 0){
            result = false;
        }
        return result;
    }
    
   public static Boolean inspectResults(Messaging.SendEmailResult[] results) {
      Boolean sendResult = true;

      for (Messaging.SendEmailResult res : results) {
         if (res.isSuccess()) {
            System.debug('Email sent successfully');
         } else {
            sendResult = false;
            System.debug('The following errors occurred: ' + res.getErrors());                 
         }
      }
      return sendResult;
   }
}