public with sharing class OrderLineItemController {
    @AuraEnabled(cacheable=true)
    public static List<OrderItem> getOrderLineItems(Id orderId) {
        // Populate map from SOQL query on QuotelineItem
        List<OrderItem> orderlineItems = ([ SELECT  Id,
                                                    //AvailableQuantity, Only for reduction Orders
                                                    OrderItemNumber,
                                                    Description,
                                                    OrderId, 
                                                    PricebookEntryId,
                                                    OriginalOrderItemId, 
                                                    QuoteLineItemId, 
                                                    QuoteLineItem.Quantity,
                                                    QuoteLineItem.Configuration_Option__c,
                                                    RVN__c,
                                                    Quantity,
                                                    CurrencyIsoCode,
                                                    UnitPrice, 
                                                    ListPrice, 
                                                    TotalPrice,
                                                    ServiceDate, 
                                                    EndDate,
                                                    Product2Id,
                                                    Product2.Name,
                                                    Product2.Product_Group__c,
                                                    Product2.Cost_Category__c,
                                                    Product2.Cost_Type__c,
                                                    Product2.Product_Category__c, 
                                                    Product2.Product_Type__c, 
                                                    Product2.Product_Item__c, 
                                                    Product2.ProductCode, 
                                                    Product2.Sales_Code__c,
                                                    Product2.QuantityUnitOfMeasure,
                                                    Product2.Reclamation__c,
                                                    Product2.Installation__c,
                                                    Product2.IsActive
                                            FROM OrderItem
                                            WHERE OrderId = :orderId
                                            ORDER BY Product2.Product_Group__c, Product2.Cost_Type__c]);
        System.debug('--- Order Line Items: '+orderlineItems);                                         
        return orderlineItems;
    }
    @AuraEnabled(cacheable=true)
    public static Map<String,OrderItem> getProductCodeToOrderLineItemMap(Id orderId,String currencyCode) {
        // Populate List from SOQL query on OrderLineItem
        Boolean isActive = True;
        System.debug('--- Get Order Line Items for Order '+orderId); 
        List<OrderItem> orderLineItems = getOrderLineItems(orderId);
        System.debug('--- Order Line Items: '+orderLineItems.size()); 
        Map<String,OrderItem> oiMap = New Map<String,OrderItem>();     
        if (orderLineItems.size()>0) {                               
            for (OrderItem orderLineItem :orderLineItems) {
                String productCode = orderLineItem.Product2.ProductCode;
                String product2Id = orderLineItem.Product2Id;
                Decimal quantity = orderLineItem.Quantity;
                oiMap.put(productCode,orderLineItem);
            }
        }  
        return oiMap;  
    } 
}