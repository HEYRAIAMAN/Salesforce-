/*
 when user insert the email if email already exists it will show error message to email field :-
 date :- 24-3-2023
*/

public class contactTriggerHelper {
    public static void duplicateEmailCheck(List<Contact> newContacts) {
        Set<String> emailSet = new Set<String>();
        for(Contact newCon : newContacts) {
            emailSet.add(newCon.Email);
        }
        Map<String, Contact> emailMap = new Map<String, Contact>();
        for(Contact oldCon : [SELECT Id, Email FROM Contact WHERE Email IN :emailSet]) {
            emailMap.put(oldCon.Email, oldCon);
        }
        for(Contact newCon : newContacts) {
            if(emailMap.containsKey(newCon.Email)) {
                newCon.Email.addError('This email already exists, please use a different email.');
            }
        }
    }
   
    
    public static void sendEmailToInserContact(List<Contact> newContacts){
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        
        // Loop through the new contact records and create an email message for each one
        for (Contact contact : newContacts) {
            String contactEmail = contact.Email;
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setToAddresses(new List<String>{contactEmail});
            email.setSubject('New Contact Created');
            email.setPlainTextBody('A new contact has been created.');
            email.setTemplateId('2F00X2w000002hRnY');
            emails.add(email);
        }
        
        // Send the emails
        Messaging.sendEmail(emails);
    

    }
    
}