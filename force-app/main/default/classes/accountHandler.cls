public with sharing class accountHandler {
    @auraEnabled(cacheable=true)
    public static list<Account> accountHandlerOnCase() {
        list<Account> accList = [select Id, Name from Account];
        System.debug('Accounts : '+accList);
        return accList;
    }
    @auraEnabled
     public static list<Contact> contactRelated(String value){
        System.debug('Value '+ value);
        list<Contact> conList = [select AccountId, Name, Email, Phone from Contact where AccountId =:value];
        System.debug('Contact : '+conList);
        return conList;
}
@AuraEnabled
public static void deleteContact(String contactId){
    try {
        System.debug(contactId);
        Contact contactToDelete = new Contact(Id = contactId);
        delete contactToDelete;
        System.debug('Delete Successfull');
        
    } catch (Exception e) {
        throw new AuraHandledException('Error deleting : '+ e.getMessage());
    }
}
@AuraEnabled
public static list<Contact> getContactData(String value){
    List<Contact> contactList = [SELECT Id, AccountId, Name, Email, Phone FROM Contact where AccountId =: value] ;
    return contactList; 
}
}