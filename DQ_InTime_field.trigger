trigger DQ_InTime_field on Daily_Quiz__c (before insert, before update) {

    if(Trigger.isBefore){
        if(Trigger.isInsert){
            for ( Daily_Quiz__c dq : Trigger.new ) {
                dq.In_Time__c = DQ_InTime_Helper.checkTimeliness(System.now());
            }
        }
        if(Trigger.isUpdate){
            for ( Daily_Quiz__c dq : Trigger.new ) {
                dq.In_Time__c = DQ_InTime_Helper.checkTimeliness(System.now());
            }
        }
    }
}