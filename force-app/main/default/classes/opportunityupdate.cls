public class opportunityupdate {
    public static void updateOpportunity(list<opportunity> opportunityData) {
        date todayDate =  system.today();
        set<string> accountid= new set<string>();
        for(opportunity opp : opportunityData){
            if(opp.accountid != Null){
                accountid.add(opp.accountid);
            }
        }
        Map<id,Account> accountMap = new Map<id,Account>([select id, name from Account where id in : accountid]);
        for(opportunity opp : opportunityData){
            if(accountMap.containsKey(opp.accountid)){
                opp.Name = AccountMap.get(opp.accountid).Name + todayDate;
            }
        

        }




    }
}