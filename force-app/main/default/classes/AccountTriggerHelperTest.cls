@isTest
private class AccountTriggerHelperTest {
    static testmethod void testUpdateRelatedContacts() {
        // Create test data
      
       list<Account> testList = new list<Account>();
       map<id, Account> testMap = new map<id, Account>();
        Account test = new Account();
        test.Name = 'Aman';
        test.BillingCity = 'Jaipur';
        insert test;
        
        testMap.put(test.Id, test);
        
        contact testCon = new contact();
        testCon.lastName = 'rai';
        testCon.AccountId = test.id;
        
        insert testCon;
        test.BillingCity = 'Noida';
        testList.add(test);
        update test;
     AccountTriggerHelper.UpdateAccount(testList , testMap);
       
    }
}