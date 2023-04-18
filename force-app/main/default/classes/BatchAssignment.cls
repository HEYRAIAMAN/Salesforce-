global class BatchAssignment implements Database.Batchable<sObject>{
    global Database.QueryLocator start(Database.BatchableContext BC){     
        return Database.getQueryLocator([SELECT Id, Individual_or_organization__c ,Orgganization_Name__c,First_Name__c,Last_Name__c,Postal_Code__c,Date_Recieved__c,Amount__c,Error_Message__c,Description__c 
                                         FROM staging__c]);
    }    
    
  global void execute(Database.BatchableContext BC, List<staging__c> scope){
        List<Opportunity> newOpptyList = new List<Opportunity>();
      for(staging__c sc:scope){
        if(sc != null && sc.Individual_or_organization__c  == 'I') {
            Account objAccount = searchAccount(sc);
            if(objAccount != null) {
                List<Contact> linkContactList = searchContact(objAccount, sc);
                system.debug('contact'+linkContactList);
                try{
                    if(linkContactList != null && !linkContactList.isEmpty()) {
                        upsert linkContactList;
                        
                        //Create new opportunity;
                        for(Contact objCon : linkContactList) {
                            newOpptyList.add(new Opportunity(Name = objCon.LastName,
                                                             StageName = 'Prospecting',
                                                             AccountId = objAccount.Id,
                                                             ContactId = objCon.Id,
                                                             CLOSEDATE=Date.today()
                                                            ));                         //Add other required fields if needed.
                            
                        }
                        
                        if(newOpptyList != null && !newOpptyList.isEmpty()) {
                            insert newOpptyList;
                        }
                    }
                }catch(Exception ex) {
                    system.debug('---Exception--' + ex);
                }
                
            }
        }
      }
    }
    
    private Account searchAccount(staging__c scope) {
        Account acc= new Account();
        if(scope.Orgganization_Name__c != null && scope.Postal_Code__c != null) {
            acc= [SELECT Id, Name FROM Account WHERE Name = :scope.Orgganization_Name__c AND BillingPostalCode = :scope.Postal_Code__c];
            //Assuming here, there will be only one account with these combination in your system
        }
        return acc;
    }
    
    
    private List<Contact> searchContact(Account objAccount, staging__c scope) {
        List<Contact> linkContactList = new List<Contact>();
        if(scope.First_Name__c != null && scope.Last_Name__c != null && scope.Postal_Code__c != null) {
            List<Contact> existingContactList = [SELECT Id, FirstName, LastName, MailingPostalCode FROM Contact 
                                                 WHERE FirstName = :scope.First_Name__c AND LastName = :scope.Last_Name__c AND MailingPostalCode = :scope.Postal_Code__c];
            //For existing contacts
            system.debug('existing contact'+existingContactList);
            if(existingContactList.size()>0 ) {
                for(Contact objCon : existingContactList) {
                    objCon.AccountId = objAccount.Id;
                    linkContactList.add(objCon);
                }
            } else {
                //create new contact
                system.debug('into else');
                linkContactList.add(new Contact(FirstName = scope.First_Name__c, 
                                                LastName = scope.Last_Name__c,
                                                MailingPostalCode = scope.Postal_Code__c,
                                                AccountId = objAccount.Id));
                system.debug('linked contact2'+linkContactList);
            }
            
        }
        return linkContactList;
    }
    
    global void finish(Database.BatchableContext BC){        
    }
}