public class OpportunityRecordTypeHelper {
    
    public static void beforeInsertoppRecord(list<Opportunity> newOpp){
        system.debug('insde class');
        id recordTypeRetail = [select Name from RecordType where (sObjectType = 'Opportunity' And Name = 'Retails')].id;
        id priceBookRetail = [select id,Name from Pricebook2 where Name = 'Retail'].id;
        id recordTypeWholesale = [select Name from RecordType where (sObjectType = 'Opportunity' And Name = 'Wholesaler')].id;
		id priceBookWholesaler = [select Name from Pricebook2 where Name = 'Wholesaler'].id;
        system.debug(recordTypeRetail);
        system.debug(priceBookRetail);
        system.debug(recordTypeWholesale);
        system.debug(priceBookWholesaler);
        for(Opportunity opp : newOpp){
            if(opp.RecordTypeId == recordTypeRetail){
                opp.Pricebook2Id = priceBookRetail;
                
            }
            else if(opp.RecordTypeId == recordTypeWholesale){
                opp.Pricebook2Id = priceBookWholesaler;
                
            }        
        }

    }
    
    public static void afterInsertOppRecord(list<Opportunity> newOpp){
        Map<String, id> recordTypes = new Map<String, id>();
        Map<String, Id> Pricebooks = new Map<String, id>();
        
        for(RecordType rt: [select id, name from RecordType where sObjectType = 'Opportunity' And Name in ('Retails','Wholesaler') ]){
            recordTypes.put(rt.Name, rt.id);
            system.debug(rt.Name);
            system.debug(rt.id);
            
          }
        
        for(PriceBook2 pb : [Select id, Name From PriceBook2 where Name in ('Retail','Wholesaler')]){
            Pricebooks.put(pb.Name, pb.id);
            system.debug(pb.Name);
            system.debug(pb.id);
            
        }
        //related product:
	//	list<priceBookentry> pbeList = [select id, name, product.id, PriceBook2.id from priceBookentry where PriceBook2.name IN Pricebooks2.keySet()];
        
        
       
     
       //LineItems 
       
    
    }
}