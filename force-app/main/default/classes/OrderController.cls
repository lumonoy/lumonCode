/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 08-07-2024
 * @last modified by  : Henk Reynders
**/
public with sharing class OrderController {
    @AuraEnabled(cacheable=true)
    public static Order getOrderRecord(Id recordId) {
      
        System.debug('--- Get Data for Order with Id: '+recordId);
        List<Id> recordIds = new List<Id>{recordId};
        List<Order> orders = getOrders(recordIds);
        Order orderRecord = orders[0];
        System.debug('--- OrderController - Order Record: '+orderRecord);
        return orderRecord;
    } 
    @AuraEnabled(cacheable=false)
    public static Order getOrderByNumber(String orderNumber) {
        // Populate List from SOQL query on Order
        Id orderId = [SELECT Id FROM Order WHERE orderNumber =: orderNumber LIMIT 1]?.Id; 
        List<Id> orderIds = new List<Id>();
        orderIds.add(orderId);
        Order order = new Order();
        System.debug('--- OrderController - Get Order with Id '+orderId); 
        List<Order> orders =  getOrders(orderIds); 
        if  (orders?.size()>0) {
            order = orders[0];
            System.debug('--- OrderController - Order: '+order.Name); 
        }        
        return order;
    }
    @AuraEnabled(cacheable=true)
    public static List<Order> getOrders(List<Id> recordIds) {
        // Populate map from SOQL query on Order
        System.debug('--- OrderController - Get Orders for recordIds: '+recordIds);
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
        System.debug('--- OrderController - Order Record Count : '+orders.size());
        return orders;
    } 
}