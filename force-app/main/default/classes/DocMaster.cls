public with sharing class DocMaster {
    @AuraEnabled(cacheable=true)
    public static list<Document_Master__c> docMasterRecord(string recordId) {
        //    System.debug('aman'+recordId );
       // string recordtypename = Schema.SObjectType.Opportunity.getRecordTypeInfosById().get().getname();
       // Id RecordTypeId = Schema.SObjectType.YOUROBJECT.getRecordTypeInfosByName().get('RECORDTYPENAME').getRecordTypeId();
        Opportunity opp = [select Id,RecordType.Name from Opportunity where id =: recordId limit 1];
         System.debug('RecordTypeName '+ opp.RecordType.Name);

         list<Document_Master__c> doc = [select Id,Name from Document_Master__c where RecordType.Name =:opp.RecordType.Name];
       //  list<Document_Master__c> docs = new List<Document_Master__c>();
        System.debug('Document_Master__c : '+doc);
        return doc;
    }

    @AuraEnabled
    public static void  docUpload(string uploadedFiles, Id recordId){
        List<ContentVersion> cvlist = [SELECT Id, Title, ContentDocumentId from ContentVersion Where Id=:uploadedFiles];
        Document_Master__c docMaster = [SELECT Id, Name FROM Document_Master__c WHERE Id = :recordId];
        List<Document__c> docListToUpdate = new List<Document__c>();

        
        Document__c doc = new Document__c();
        cvlist[0].Title = 'Driving';
        doc.Name = cvlist[0].Title;
        doc.Opportunity__c = recordId;
        insert doc;

        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = cvlist[0].ContentDocumentId;
        cdl.LinkedEntityId = doc.Id;
        insert cdl;
    }
}