public class OpportunityTriggerHelper {
    public static void updateAccount(list<Opportunity> newOpp, Map<id, Opportunity> oldOpp){
        set<Id> accId = new set<Id>();
        for(Opportunity Opp : newOpp){
            accId.add(Opp.accountId);
            if(Opp.id != oldOpp.get(Opp.Id).AccountId){
                accId.add(oldOpp.get(Opp.Id).AccountId);
                
            }
             
        }
        Map<String, Decimal> closedWon = new Map<String, Decimal>();
        Map<String, Decimal> closedLost = new Map<String, Decimal>();
        list<Opportunity> opp = [select id ,StageName, AccountId, Amount from Opportunity where AccountId IN : accId AND (StageName = 'Closed Won' Or StageName = 'Closed Lost')];
        for(Opportunity oppAcc : opp){
            if(oppAcc.StageName == 'Closed Won'){
                if(closedWon.containskey(oppAcc.AccountId)){
                    closedWon.put(oppAcc.AccountId, closedWon.get(oppAcc.AccountId)+oppAcc.Amount);
                  
                }else {
                    closedWon.put(oppAcc.AccountId, oppAcc.Amount); 
                   }  
            }
            else if(oppAcc.StageName == 'Closed Lost'){
                if(closedLost.containskey(oppAcc.AccountId)){
                    closedLost.put(oppAcc.AccountId, closedLost.get(oppAcc.AccountId)+oppAcc.Amount);
                }
                else{
                    closedWon.put(oppAcc.AccountId, oppAcc.Amount);
                }
            }
            
        }
        list<Account> accList = [select id, Closed_Won_Amounts__c, Closed_Lost__c  from Account where id In : AccId];
        
        for(Account Acc : accList){
            if(closedWon.containskey(Acc.id)){
                Acc.Closed_Won_Amounts__c = closedWon.get(Acc.id);
            }
            else{
                Acc.Closed_Won_Amounts__c = 0;
            }
           if(closedLost.containskey(Acc.id)){
                Acc.Closed_Lost__c = closedlost.get(Acc.id);
            }
            else{
                Acc.Closed_Lost__c = 0;
            }
            
        }
        
          
            }
    
    
    
    
    
    
}