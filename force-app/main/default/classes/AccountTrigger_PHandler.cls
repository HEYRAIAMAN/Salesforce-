public class AccountTrigger_PHandler {
    //when industry is media and not null than update rating as hot

    public static void before(list<Account> newList){
        for(Account acc : newList){
            if(acc.Industry != null && acc.Industry == 'Media'){
                acc.Rating = 'Hot';

            }  
        }   
    }
    // when Account is created related Oppertunity is update
    public static void createRelatedOppertunity(list<Account> newList){
        list<opportunity> newOpp = new list<opportunity>();
        for(Account acc: newList){
            Opportunity opp = new Opportunity();
            opp.Name = acc.Name;
            opp.AccountId = acc.Id;
            opp.StageName = 'Prospecting';
            opp.CloseDate = System.today();
            newOpp.add(opp);     
        }
        if(!newOpp.isEmpty()){
           insert newOpp;
}
    }
    
   // if Account phone is update then put the update masge in description 
   public static void phoneISUpdate(list<Account> newList, Map<Id, Account> oldMap ){
        for(Account acc : newList){
            if(oldMap != null && acc.Phone != oldMap.get(acc.Id).Phone){
                acc.Description = 'Update is happen';
            }
           }  
        } 
    
    // update the all related account phone number when account phone number change 
    public static void updateRelatedOppPhone(List<Account> newList, Map<Id,Account> oldMap){
        map<Id, Account> AccountIDs = new map<Id, Account>();
        list<Opportunity> Updatelist = new list<Opportunity>();
        
        for(Account acc : newList){
            if(oldMap != null && acc.Phone != oldMap.get(acc.id).Phone){
                AccountIDs.put(acc.Id, acc);
            }
          }
        for(Opportunity opp : [select id , Opportunity_Phone__C, AccountId from Opportunity where AccountId IN : AccountIDs.keySet()]){
            Opportunity NewOpp = new Opportunity();
            if(AccountIDs.containsKey(opp.AccountId)){
                NewOpp.id = opp.Id;
                NewOpp.Opportunity_Phone__C = AccountIDs.get(opp.AccountId).Phone;
                Updatelist.add(NewOpp);
            }
        }
        if(!Updatelist.isEmpty()){
            update Updatelist;
        }
        
}
    
    
    }