public class CasesTriggerhelper {
    public static void updateAccount(List<Case> newCase, Map<id, case> oldCase){
       set<Id> accId = new set<Id>();
        integer count = 0;
        for(Case cases : newCase){
            if(cases.AccountId != null){
            	accId.add(Cases.accountId);
            
            }  
        }
        system.debug('hello1');
        Map<String, Integer>  No_of_closed_case_on_last_month = new Map<String, Integer>();
        Map<String, Integer>  No_of_the_open_cases_in_last_month = new Map<String, Integer>();
        Map<String, Integer>  No_of_closed_cases_in_the_last_7_days = new Map<String, Integer>();
        Map<String, Integer>  No_of_open_cases_in_the_last_7_days = new Map<String, Integer>();
        
        list<Case> caseList = [select AccountID,Status, ClosedDate, CreatedDate from case where AccountId In : accId];
        for(case caseRecord : caseList ){
           date lastweeks = date.today()-7;
           date LastMonths = date.today()-30;
             system.debug('hello2');
            
            // Case is closed
            if(caseRecord.status == 'Closed'){
                
                // case closed in 7 days
                if(caseRecord.ClosedDate >= lastweeks){
                    system.debug('hello3');
                    
                    If(No_of_closed_cases_in_the_last_7_days.containskey(caseRecord.AccountId)){
                        system.debug('hello4');
                        No_of_closed_cases_in_the_last_7_days.put(caseRecord.AccountId, No_of_closed_cases_in_the_last_7_days.get(caseRecord.AccountId)+1);
                    }else {
                        system.debug('hello5');
                        No_of_closed_cases_in_the_last_7_days.put(caseRecord.AccountId, 1);
                }
               }
                 
                // Case opened in 7 days with status Closed
                if(caseRecord.CreatedDate >= lastWeeks)
                {
                    system.debug('hello6');
                    if(No_of_open_cases_in_the_last_7_days.containsKey(caseRecord.AccountId))
                    {
                        system.debug('hello7');
                        No_of_open_cases_in_the_last_7_days.put(caseRecord.AccountId, No_of_open_cases_in_the_last_7_days.get(caseRecord.AccountId) + 1);
                    }
                    else
                    {
                        system.debug('hello8');
                        No_of_open_cases_in_the_last_7_days.put(caseRecord.AccountId, 1);
                    }
                }
                  
                    // Case is closed within 30 days
                    if(caseRecord.ClosedDate >= lastmonths){
                    If(No_of_closed_case_on_last_month.containskey(caseRecord.AccountId)){
                        No_of_closed_case_on_last_month.put(caseRecord.AccountId, No_of_closed_case_on_last_month.get(caseRecord.AccountId)+1);
                    }else {
                        No_of_closed_case_on_last_month.put(caseRecord.AccountId, 1);
                }
                    }
                    // Case opened in 30 days and closed
					if(caseRecord.CreatedDate >= lastmonths)
                    {
                        if(No_of_the_open_cases_in_last_month.containsKey(caseRecord.AccountId))
                        {
                            No_of_the_open_cases_in_last_month.put(caseRecord.AccountId, No_of_the_open_cases_in_last_month.get(caseRecord.AccountId) + 1);
                        }
                        else
                        {
                            No_of_the_open_cases_in_last_month.put(caseRecord.AccountId, 1);
                        }
                    }
                        
            }
            // Case is open
            else
                system.debug('bye');
            {
                // Case opened in 7 days but not closed yet
                if(caseRecord.CreatedDate >= lastWeeks)
                {
                    if(No_of_open_cases_in_the_last_7_days.containsKey(caseRecord.AccountId))
                    {
                        No_of_open_cases_in_the_last_7_days.put(caseRecord.AccountId, No_of_open_cases_in_the_last_7_days.get(caseRecord.AccountId) + 1);
                    }
                    else
                    {
                        No_of_open_cases_in_the_last_7_days.put(caseRecord.AccountId, 1);
                    }
                
            }
                
                if(caseRecord.CreatedDate >= lastmonths)
                    {
                        if(No_of_the_open_cases_in_last_month.containsKey(caseRecord.AccountId))
                        {
                            No_of_the_open_cases_in_last_month.put(caseRecord.AccountId, No_of_the_open_cases_in_last_month.get(caseRecord.AccountId) + 1);
                        }
                        else
                        {
                            No_of_the_open_cases_in_last_month.put(caseRecord.AccountId, 1);
                        }
                    }
           	 }
            }
        list<Account> accList = [select id, No_of_closed_case_on_last_month__c, No_of_closed_cases_in_the_last_7_days__c ,
                                 No_of_open_cases_in_the_last_7_days__c, No_of_the_open_cases_in_last_month__c 
                                 from Account where id In :AccId ];
        for(Account acc : accList){
            if(No_of_closed_cases_in_the_last_7_days.containskey(acc.id)){
                acc.No_of_closed_cases_in_the_last_7_days__c = No_of_closed_cases_in_the_last_7_days.get(acc.id);
                
            }
           if(No_of_closed_case_on_last_month.containskey(acc.id)){
                acc.No_of_closed_case_on_last_month__c = No_of_closed_case_on_last_month.get(acc.id);
                
            }
            if(No_of_open_cases_in_the_last_7_days.containskey(acc.id)){
                acc.No_of_open_cases_in_the_last_7_days__c = No_of_open_cases_in_the_last_7_days.get(acc.id);
           }
           if(No_of_the_open_cases_in_last_month.containskey(acc.id)){
                acc.No_of_the_open_cases_in_last_month__c = No_of_the_open_cases_in_last_month.get(acc.id);
           }
            
        }
	update accList;
     
   
}
}