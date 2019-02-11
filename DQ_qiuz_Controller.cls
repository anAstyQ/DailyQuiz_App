public with sharing class DQ_qiuz_Controller {
	
    public Boolean doUpdate {get; set;}
    public String currentUser {get; set;}
    public Daily_Quiz__c dq {get; set;}
    public String prodWorkload = null;
    public String Workload_Yesterday {get; set;}
    public String Workload_Today {get; set;}
    public String Commerce_Project {get; set;}
    public Double Estimated_Time {get; set;}
    public String AddInfo {get; set;}
    public String todayD {get; set;}
    public String dayOfWeek {get; set;}

    public DQ_qiuz_Controller(){
        currentUser = System.UserInfo.getName();
        dq = new Daily_Quiz__c();
        String sDate = Date.today().year() + '-' + Date.today().month() + '-' + Date.today().day();
        List<Daily_Quiz__c> dqL = [SELECT Id, Name, Owner.Name, CreatedDateStr__c , Answered__c, AddInfo__c, Commerce_Project__c, 
                                   Estimated_Time__c, In_Time__c, Workload_Product__c, Workload_Today__c, Workload_Yesterday__c 
                                   FROM Daily_Quiz__c WHERE CreatedById =: System.UserInfo.getUserId() AND CreatedDateStr__c =: sDate LIMIT 1];
        if(dqL.size() == 1) {
            Workload_Today = dqL[0].Workload_Today__c;
            Workload_Yesterday = dqL[0].Workload_Yesterday__c;
            prodWorkload = '' + dqL[0].Workload_Product__c + '';
            Commerce_Project = dqL[0].Commerce_Project__c;
            Estimated_Time = dqL[0].Estimated_Time__c;
            AddInfo = dqL[0].AddInfo__c;
            doUpdate = true;
            dq.Id = dqL[0].Id;
        }
        if(dqL.size() == 0){
            doUpdate = false;
        }
        Datetime dt = System.now();
		todayD = dt.format('dd-MM-YYYY');
        dayOfWeek = dt.format('EEE');
    }
    
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('true','Yes')); 
        options.add(new SelectOption('false','No')); 
        return options; 
    }
    
    public String getprodWorkload() {
        return prodWorkload;
    }
                    
    public void setprodWorkload(String prodWorkload) { this.prodWorkload = prodWorkload; }
    
    public PageReference saveRecord(){
        PageReference pageRef = new PageReference('/apex/DQ_Answer');
        dq.Workload_Yesterday__c = Workload_Yesterday;
        dq.Workload_Today__c = Workload_Today;
        if(prodWorkload == 'true'){
            dq.Workload_Product__c = true;
            dq.Commerce_Project__c = Commerce_Project;
        	dq.Estimated_Time__c = Integer.valueOf(Estimated_Time);
        } else {
            dq.Workload_Product__c = false;
            dq.Commerce_Project__c = '';
        	dq.Estimated_Time__c = null;
        }
        dq.AddInfo__c = AddInfo;
        dq.Answered__c = true;
        Datetime d = System.now();
        dq.Sent__c = d.format('hh:mm a');
        
        if(doUpdate){
            try{
                update dq;
                pageRef.setRedirect(true);
                return pageRef; 
            } catch (DMLException e){
                System.debug('>> [DQ_quiz_Controller] => updating => e : ' + e.getMessage());
                pageRef.setRedirect(false);
                return null;
            }
            
        } else {
            try{
            	insert dq;
                pageRef.setRedirect(true);
                return pageRef; 
            } catch(DMLException e){
                System.debug('>> [DQ_quiz_Controller] => inserting => e : ' + e.getMessage());
                pageRef.setRedirect(false);
                return null;
            }
        }
    }
}