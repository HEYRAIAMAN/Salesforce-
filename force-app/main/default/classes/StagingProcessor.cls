public class StagingProcessor {
    public static void processStagingRecords(List<staging__c> stagingRecords) {
        // Create a set to hold unique combinations of FirstName, LastName, and PostalCode
        Set<String> contactKeySet = new Set<String>();
        set<String> stagingFirstName = new Set<String>();
        set<String> stagingLastName = new Set<String>();
        set<String> stagingPostalCode = new Set<String>();
        set<String> stagingOrggName = new Set<String>();
        for (staging__c stagingRecord : stagingRecords) {
            if (stagingRecord.Individual_or_Organization__c == 'I') {
                stagingFirstName.add(stagingRecord.First_Name__c);
                stagingLastName.add(stagingRecord.Last_Name__c);
                stagingPostalCode.add(stagingRecord.Postal_Code__c);
                stagingOrggName.add(stagingRecord.Orgganization_Name__c); 
            }
        }

        // Query for all contacts that match the FirstName, LastName, and PostalCode combinations
        Map<String, Contact> contactMap = new Map<String, Contact>();
        for (Contact contactRecord : [SELECT Id, FirstName, LastName, MailingPostalCode FROM Contact WHERE FirstName IN :stagingFirstName OR LastName IN :stagingLastName OR MailingPostalCode IN :stagingPostalCode]) {
            contactMap.put(contactRecord.FirstName + contactRecord.LastName + contactRecord.MailingPostalCode, contactRecord);
        }
        
        Map<String, Account> accountMap = new Map<String, Account>();
        for(Account accountRecord : [SELECT id, Name, BillingPostalCode from Account where Name In : stagingOrggName OR BillingPostalCode IN : stagingPostalCode]){
            accountMap.put(accountRecord.Name + accountRecord.BillingPostalCode, accountRecord );
        }
        
        
        List<opportunity> oppList = new List<opportunity>();
        List<Contact> conList = new List<Contact>();
        List<Account> AccList = new List<Account>();
        // Process each staging record
        for (staging__c stagingRecord : stagingRecords) {
            if (stagingRecord.Individual_or_Organization__c == 'I') {
                // Get the matching contact record from the map, or create a new contact record if not found
                Contact existingContact = contactMap.get(stagingRecord.First_Name__c + stagingRecord.Last_Name__c + stagingRecord.Postal_Code__c);
                if (existingContact == null) {
                    Contact newContact = new Contact();
                    newContact.FirstName = stagingRecord.First_Name__c;
                    newContact.LastName = stagingRecord.Last_Name__c;
                    newContact.MailingPostalCode = stagingRecord.Postal_Code__c;
                    conList.add(newContact);
                    existingContact = newContact;
                    if(stagingRecord.Orgganization_Name__c != null && stagingRecord.Postal_Code__c != null && accountMap.containsKey(stagingRecord.Orgganization_Name__c + stagingRecord.Postal_Code__c)){
                        newContact.AccountId = accountMap.get(stagingRecord.Orgganization_Name__c + stagingRecord.Postal_Code__c).id;
                        
                    }
                    Opportunity newOpp = new Opportunity();
                    newOpp.ContactId = existingContact.Id;
                    newOpp.Name = existingContact.LastName + ' ' + stagingRecord.Date_Recieved__c.format();
                    newOpp.CloseDate = stagingRecord.Date_Recieved__c;
                    newOpp.Amount = stagingRecord.Amount__c;
                    newOpp.Description = stagingRecord.Description__c;
                    newOpp.StageName = 'Prospecting';
                    oppList.add(newOpp);
                        
                    
                }

                
            }
            
            else if(stagingRecord.Individual_or_Organization__c=='O'){
                 Account existingAccount = accountMap.get(stagingRecord.Orgganization_Name__c + stagingRecord.Postal_Code__c);
                if (existingAccount == null) {
                    Account newAccount = new Account();
                    newAccount.Name = stagingRecord.Orgganization_Name__c;
                    newAccount.BillingPostalCode = stagingRecord.Postal_Code__c;
                    
                   
                    
                    
                    accList.add(newAccount);
                    existingAccount = newAccount;
                    
                     if(stagingRecord.Orgganization_Name__c != null && stagingRecord.Postal_Code__c != null && contactMap.containsKey(stagingRecord.First_Name__c + stagingRecord.Last_Name__c + stagingRecord.Postal_Code__c)){
                        
                     
                         Contact newContact = contactMap.get(stagingRecord.First_Name__c +stagingRecord.Last_Name__c +stagingRecord.Postal_Code__c);
                         newContact.AccountId = newAccount.Id;
                         conList.add(newContact);
                         
                        
                    }
                
                
                
                
            }
        }
        upsert conList;
        insert oppList;
        insert accList;
            
            
    }
}
}