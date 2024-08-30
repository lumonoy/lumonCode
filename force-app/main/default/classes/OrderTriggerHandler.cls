/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-02-2023
 * @last modified by  : Henk Reynders
**/
public class OrderTriggerHandler {
	public static Boolean checkRecursion = FALSE;
    public static String response;
    public static String upsertOrderLineItems(String recordId){
        System.debug('*** order id ***'+recordId);
        Set<Id> syncedQuoteIds = new Set <Id> ();
        Set<Id> orderIds = new Set<Id>();
        Map<Id,Id> mapOfOppIdToOdrId = new Map<Id,Id>();
        List<OrderItem> orderItemsForUpsert = new List<OrderItem>();
        List<Order> triggeredOrders = new List<Order>();
        
        
        Order triggeredOrder = [SELECT Id,OpportunityId,Status,QuoteId from Order where OpportunityId =:recordId];
        if(triggeredOrder != null){
            System.debug('*** triggeredOrder.Status ***'+triggeredOrder.Status);
            if(triggeredOrder.OpportunityId  != null && 
               triggeredOrder.Status != 'Activated')
            {   
                triggeredOrders.add(triggeredOrder);
                upsertOrderLineItems(triggeredOrders,null, null);
            }
        }
        
        return null;
        
    }
    
    public static void upsertOrderLineItems(List<Order> triggeredOrders, Map<Id,Order> oldOrdersMap, Boolean fromTrigger){
        Set<Id> syncedQuoteIds = new Set <Id> ();
        List<Id> quoteIds = new List<Id>();
        Set<Id> orderIds = new Set<Id>();
        List<Order> orderList = new List<Order>();
        Map<Id,Id> mapOfOppIdToOdrId = new Map<Id,Id>();
        List<OrderItem> orderItemsForUpsert = new List<OrderItem>();

        for(Order o : triggeredOrders){
            if(o.OpportunityId  != null && o.Status != 'Activated'){ // New or Draft Order 
                    syncedQuoteIds.add(o.QuoteId);
                    mapOfOppIdToOdrId.put(o.OpportunityId ,o.Id);
                    orderIds.add(o.Id);
            }
        }
        
        if(syncedQuoteIds.size() > 0 ){
            quoteIds = new List<Id>(syncedQuoteIds);
            //Added Configuration_Product__r.RVN__c in query as part of LUM-2016
            List<QuoteLineItem> quoteItemList = QuoteLineItemController.getQuoteLineItemsById(quoteIds);
            List<OrderItem> orderItemExistingList = [SELECT Id,OrderId,Order.OpportunityId,QuoteLineItemId, Order.Status from OrderItem where OrderId IN:orderIds];
             
            Map<Id,Id> orderItemExistingMap= new Map<Id,Id>();
			List<OrderItem> orderItemsForDelete = new List<OrderItem>();
            
            if(!orderItemExistingList.isEmpty()){
                for(OrderItem orderLineItemExisting : orderItemExistingList){
                    orderItemsForDelete.add(orderLineItemExisting);
                }
                
                for(OrderItem orderLineItemExisting : orderItemExistingList){
                    if (!orderItemExistingMap.containsKey(orderLineItemExisting.QuoteLineItemId)){
                        orderItemExistingMap.put(orderLineItemExisting.QuoteLineItemId,orderLineItemExisting.Id);
                    } else {
                        // --------------- 07.10.2023 Would not be an expected situation 
                        orderItemExistingMap.put(orderLineItemExisting.QuoteLineItemId,orderLineItemExisting.Id);
                    }
                }
            }else{
                orderItemExistingMap = null;
            }
            
            if (!quoteItemList.isEmpty()) {
                
                for (QuoteLineItem qliToProcess: quoteItemList) {
                    
                    Id qliRecordId = qliToProcess.Id;
                    Id quoteRecordId = qliToProcess.QuoteId;
                    Id opportunityRecordId = qliToProcess.Quote.OpportunityId;  
                    if (String.isNotBlank(opportunityRecordId)) {
                        OrderItem orderItemVal = new OrderItem();
                        System.debug('--- OrderTriggerHandler - Processing QuoteLineItem ' + qliToProcess.Id);
                        if (orderItemExistingMap != NULL && orderItemExistingMap.containsKey(qliRecordId)){
                            orderItemVal.Id = orderItemExistingMap.get(qliRecordId);
                        }else if (qliToProcess.Quantity > 0) {
                            orderItemVal.OrderId = mapOfOppIdToOdrId.get(qliToProcess.Quote.OpportunityId);
                            orderItemVal.PricebookEntryId = qliToProcess.PricebookEntryId;
                            orderItemVal.Product2Id = qliToProcess.Product2Id;
                            orderItemVal.ListPrice = qliToProcess.ListPrice;
                            orderItemVal.UnitPrice = qliToProcess.UnitPrice;
                        }else {
                            System.debug('--- OrderTriggerHandler - No Available Quantity for Order Line Item');
                            break;
                        }
                        	System.debug('--- OrderTriggerHandler - QuoteLine Item Id: ' +qliRecordId);
                            orderItemVal.QuoteLineItemId = qliRecordId;
                            orderItemVal.Quantity = qliToProcess.Quantity;
                            orderItemVal.Description = qliToProcess.RVN__c+': '+qliToProcess.Product2.Name;
                            // 12.10.2023 Keep copying the custom Field Values for now
                            orderItemVal.Base_Price__c = qliToProcess.Base_Price__c != NULL ? qliToProcess.Base_Price__c : 0.00;
                            orderItemVal.Cost_Category__c = qliToProcess.Cost_Category__c != NULL ? qliToProcess.Cost_Category__c : 'Other';
                            orderItemVal.Cost_Multiplier__c = qliToProcess.Cost_Multiplier__c != NULL ? qliToProcess.Cost_Multiplier__c : 1;
                            orderItemVal.Cost_Type__c = qliToProcess.Cost_Type__c;
                            //orderItemVal.Description = qliToProcess.Description != NULL ? qliToProcess.Description : '';
                            orderItemVal.Discount__c = qliToProcess.Discount;
                            orderItemVal.Factory_Multiplier__c = qliToProcess.Factory_Multiplier__c != NULL ? qliToProcess.Factory_Multiplier__c : 1;
                            orderItemVal.fxCost__c = qliToProcess.fxCost__c;
                            orderItemVal.fxFactory__c = qliToProcess.fxFactory__c;
                            orderItemVal.fxSales__c = qliToProcess.fxSales__c;
                            orderItemVal.Product_Code__c = qliToProcess.Product_Code__c;
                            orderItemVal.Product_Group__c = qliToProcess.Product_Group__c;
                            orderItemVal.RVN_Number__c = qliToProcess.Configuration_Product__r.RVN__c;
                            orderItemVal.Sales_Code__c = qliToProcess.Sales_Code__c;
                            orderItemVal.Sales_Multiplier__c = qliToProcess.Sales_Multiplier__c;
                            orderItemVal.Subtotal__c = qliToProcess.Subtotal;
                            orderItemVal.Tax__c = qliToProcess.Tax__c;
                            System.debug('--- OrderTriggerHandler - Order Line Item '+orderItemVal);
                            orderItemsForUpsert.add(orderItemVal);
                    }
                    
                }
            }
            
        }
        System.debug('*** orderItemsForUpsert ***'+orderItemsForUpsert);
        List <Id> upsertedOrderLineItemIds = new List <Id> ();
        if(orderItemsForUpsert.size() > 0){
            try {
                upsert orderItemsForUpsert;
                upsertedOrderLineItemIds = new List < Id > (new Map < Id, OrderItem > (orderItemsForUpsert).keySet());
                System.debug('Order Line Items created successfully');
            }
            catch(Exception ex)
            {
                System.debug('Order line items insert failed'+ex.getMessage());
            }
        }

        // Get Existing Order Line Items to Delete
        List <OrderItem> obsoleteOrderLineItems = New List < OrderItem > ();
        obsoleteOrderLineItems = ([SELECT Id
            FROM OrderItem
            WHERE OrderId IN: orderIds
            AND Id NOT IN: upsertedOrderLineItemIds
            ORDER BY CreatedDate DESC
        ]);
        System.debug('--- ' + obsoleteOrderLineItems.size() + ' Order Line Item(s) to Delete');
        if (obsoleteOrderLineItems.size() > 0) {
            delete obsoleteOrderLineItems;
        }
         
    }

    public static OrderItem createOrderItems(QuoteLineItem ql, Map<Id,Id> mapOfOppIdToOdrId, Map<Id,Id> orderItemExistingMap){
        
        OrderItem oi = new OrderItem();
        if (orderItemExistingMap != NULL && orderItemExistingMap.containsKey(ql.Id)) {
            oi.Id = orderItemExistingMap.get(ql.Id);
        }
        /*else if(orderItemExistingMap == NULL){
            
        }*/
        oi.OrderId = mapOfOppIdToOdrId.get(ql.Quote.OpportunityId);
        oi.ListPrice = ql.ListPrice;
        oi.Product2Id = ql.Product2Id;
        oi.Quantity = ql.Quantity;
        oi.UnitPrice = ql.UnitPrice;
        oi.PricebookEntryId = ql.PricebookEntryId;
        oi.Base_Price__c = ql.Base_Price__c != NULL ? ql.Base_Price__c : 0.00;
        oi.Cost_Category__c = ql.Cost_Category__c != NULL ? ql.Cost_Category__c : 'Other';
        oi.Cost_Multiplier__c = ql.Cost_Multiplier__c != NULL ? ql.Cost_Multiplier__c : 1;
        oi.Cost_Type__c = ql.Cost_Type__c != NULL ? ql.Cost_Type__c : '';
        oi.Description = ql.RVN__c + ': ' + ql.Product2.Name;
        oi.Discount__c = ql.Discount;
        oi.Factory_Multiplier__c = ql.Factory_Multiplier__c != NULL ? ql.Factory_Multiplier__c : 1;
        oi.fxCost__c = ql.fxCost__c;
        oi.fxFactory__c = ql.fxFactory__c;
        oi.fxSales__c = ql.fxSales__c;
        
        oi.Product_Category__c = ql.Product_Category__c;
        oi.Product_Code__c = ql.Product_Code__c;
        oi.Product_Group__c = ql.Product_Group__c;
        oi.Product_Item__c = ql.Product_Item__c;
        oi.Product_Type__c = ql.Product_Type__c;
        //Replaced RVN Number with RVN as part of LUM-2016
        oi.RVN_Number__c = ql.Configuration_Product__r.RVN__c;
        oi.Sales_Code__c = ql.Sales_Code__c;
        oi.Sales_Multiplier__c = ql.Sales_Multiplier__c;
        oi.Subtotal__c = ql.Subtotal;
        oi.Tax__c = ql.Tax__c;        
        oi.Line_Number__c = ql.Line_Number__c;
        oi.QuoteLineItemId = ql.Id;
        return oi;
    }
    
     public static String deleteExistingOrderItems(List<OrderItem> oItemList){
        String message;
        //List<OrderItem> oliList = [SELECT Id from OrderItem where OrderId = :o.Id]; 
        try {
            if(!oItemList.isEmpty()){
                delete oItemList;
                message = 'Success';
            }
        }catch(Exception e){
            message = 'Error';
        }
        return message;
    }

}