public with sharing class OrderController {
    @AuraEnabled(cacheable=true)
    public static Order getOrderRecord(Id recordId) {
      
        System.debug('--- Get Data for Order with Id: '+recordId);
        List<Id> recordIds = new List<Id>{recordId};
        List<Order> orders = getOrders(recordIds);
        Order orderRecord = orders[0];
        System.debug('--- Order Record: '+orderRecord);
        return orderRecord;
    } 
    @AuraEnabled(cacheable=true)
    public static List<Order> getOrders(List<Id> recordIds) {
        // Populate map from SOQL query on Order
        System.debug('--- Get Orders for recordIds: '+recordIds);
        List<Order> orders = ([SELECT    Id, 
                                        OwnerId, 
                                        ContractId, 
                                        AccountId, 
                                        Pricebook2Id, 
                                        OriginalOrderId, 
                                        OpportunityId, 
                                        QuoteId, 
                                        EffectiveDate, 
                                        EndDate, 
                                        IsReductionOrder, 
                                        Status, 
                                        Type,
                                        OrderNumber,
                                        TotalAmount,
                                        BillingAddress,
                                        ShippingAddress                                   
                                    FROM Order 
                                    WHERE Id IN:recordIds
                                    OR AccountId IN: recordIds
                                    OR ContractId IN: recordIds
                                    OR OpportunityId IN: recordIds
                                    OR QuoteId IN:recordIds
                                    ]);
        System.debug('--- Order Record Count : '+orders.size());
        return orders;
    } 
}