//if Account address change then update the related contact address as account address 
//date 26-3-2023
public class AccountTriggerHelper{
    
    public static void updateAccount(List<Account> accountData , Map<Id, Account> oldMap){
        Map<ID, Account> accountMap = new Map<ID, Account>();
        list<contact> updateContact = new list<contact>();
        for(Account acc : accountData){
            if((oldMap != null && acc.BillingStreet != oldMap.get(acc.Id).BillingStreet) || oldMap != null && acc.BillingCity != oldMap.get(acc.Id).BillingCity || oldMap != null && acc.BillingPostalCode   != oldMap.get(acc.Id).BillingPostalCode ) {
					accountMap.put(acc.Id, acc);                
            }
        }
           
            for(contact conList : [select id, MailingStreet, MailingCity, MailingPostalCode, AccountId from contact   where AccountId In : accountmap.keyset()]){
                contact newContact = new contact();
                if(accountMap.containsKey(conList.AccountId)){
                    newContact.Id = conList.Id;
                    newContact.MailingStreet = accountMap.get(conList.AccountId).BillingStreet;
                    newContact.MailingCity = accountMap.get(conList.AccountId).BillingCity;
                    newContact.MailingPostalCode = accountMap.get(conList.AccountId).BillingPostalCode;
                    updateContact.add(newContact);
                    
                }
            }
            if(!updateContact.isEmpty()){
            update updateContact;
            }
            
        
    }
    
/*  
    Write a trigger on the Account when the Account is updated check all 
    opportunities related to the account. Update all Opportunities Stage to close lost 
   	if an opportunity created date is greater than 30 days from today and stage not equal to close won.
    Date- 31-3-2023;
*/
    public static void accountRelatedOppUpdate(list<Account> newAcc){
        set<id> accId = new set<id>();
        for(Account acc : newAcc){
            accId.add(acc.Id);
        }
        list<opportunity> oppToBeUpdate = new list<opportunity>();
        DateTime dt = system.today()-30;
        for(Opportunity opp : [SELECT Id, Name, StageName, AccountId, CloseDate FROM Opportunity WHERE AccountId IN : accId AND StageName != 'Closed Won']){
            if(opp.CloseDate <= dt ){
                opp.CloseDate = system.today();
                opp.StageName = 'Closed Lost';
         		oppToBeUpdate.add(opp);
            }   
        }
        UPDATE oppToBeUpdate;
   
}
}