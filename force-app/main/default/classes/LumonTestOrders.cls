/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 09-30-2024
 * @last modified by  : Henk Reynders
**/
@IsTest(isParallel=false)
public class LumonTestOrders {
    public class CustomException extends Exception {}
	/********** Order Data Records ***********/
    @TestVisible private static Id b2cOpportunityId = LumonTestOpportunities.b2cOpportunity?.Id;
    @TestVisible private static Id b2bOpportunityId = LumonTestOpportunities.b2cOpportunity?.Id;
    @TestVisible private static Id pricebookId{
        get{
            return Test.getStandardPricebookId();
        }
    }
    @TestVisible private static List<PricebookEntry> pricebookEntries{
        get{
            return [SELECT Id,Name,Product2Id,IsActive FROM PricebookEntry WHERE Pricebook2Id =: pricebookId];
        }
    }
    @TestVisible private static Id b2cQuoteId{
        get{
            return [SELECT Id FROM Quote WHERE (Account.IsPersonAccount = true AND OpportunityId =: b2cOpportunityId AND IsSyncing = false) LIMIT 1]?.Id;
        }
    }
    @TestVisible private static Id b2cSyncedQuoteId{
        get{
            return [SELECT Id, isSyncing, OpportunityId FROM Quote WHERE (Account.IsPersonAccount = true AND OpportunityId =: b2cOpportunityId AND IsSyncing = true)]?.Id;
        }
    }
    @TestVisible private static List<Quote> b2cQuotes{
        get{
            return [SELECT Id,Name,OpportunityId,IsSyncing FROM Quote WHERE (Account.IsPersonAccount = true AND OpportunityId =: b2cOpportunityId AND IsSyncing = false)];
        }
    }
    @TestVisible private static Id b2bQuoteId{
        get{
            return [SELECT Id FROM Quote WHERE (Account.IsPersonAccount = false AND OpportunityId =: b2bOpportunityId AND IsSyncing = false) LIMIT 1]?.Id;
        }
    }
    @TestVisible private static Id b2bSyncedQuoteId{
        get{
            return [SELECT Id,isSyncing, OpportunityId  FROM Quote WHERE (Account.IsPersonAccount = false AND OpportunityId =: b2bOpportunityId AND IsSyncing = true)]?.Id;
        }
    }
    @TestVisible private static List<Quote> b2bQuotes{
        get{
            return [SELECT Id,Name,OpportunityId,IsSyncing FROM Quote WHERE (Account.IsPersonAccount = false AND OpportunityId =: b2bOpportunityId AND IsSyncing = false)];
        }
    }
    @TestVisible private static Id b2cOrderId{
        get{
            return [SELECT Id,Pricebook2Id, QuoteId, OpportunityId,AccountId  FROM Order WHERE (Account.IsPersonAccount = true AND OpportunityId =: b2cOpportunityId)]?.Id;
        }
    }
    @TestVisible private static List<Order> b2cOrders{
        get{
            return [SELECT Id,Pricebook2Id, QuoteId, OpportunityId,AccountId  FROM Order WHERE (Account.IsPersonAccount = true AND OpportunityId =: b2cOpportunityId)];
        }
    }
    
    /********** Order Data Setup ***********/
    public static void setupOrderB2C(){
        // Create B2C Order
        System.debug('---- setupOrderB2C - Opportunity: '+b2cOpportunityId);
        Order b2cOrder1 = new Order( Name='B2C Normal Order',
                                            Status='Draft',
                                            Pricebook2Id=pricebookId,
                                            OpportunityId=b2cOpportunityId,
                                            QuoteId=b2cQuoteId,
                                            Type='Normal'
                                            );
        insert b2cOrder1;
        System.debug('---- setupOrderB2C - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('---- setupOrderB2C - SOQL USED: ' + LIMITS.getQueries());
    }
    public static void setupSpecialOrderB2C(){
        // Create B2C Special Order
        System.debug('---- setupSpecialOrderB2C - Opportunity: '+b2cOpportunityId);
        Order b2cOrder2 = new Order( Name='B2C Special Order',
                                            Status='Draft',
                                            Pricebook2Id=pricebookId,
                                            OpportunityId=b2cOpportunityId,
                                            QuoteId=b2cQuoteId,
                                            Type='Special'
                                            );
        insert b2cOrder2;
        System.debug('---- setupSpecialOrderB2C - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('---- setupSpecialOrderB2C - SOQL USED: ' + LIMITS.getQueries());
    }
    public static void setupReclamationOrderB2C(){
        // Create B2C Reclamation Order
        System.debug('---- setupSpecialOrderB2C - Opportunity: '+b2cOpportunityId);
        Order b2cOrder3 = new Order( Name='B2C Reclamation Order',
                                            Status='Draft',
                                            Pricebook2Id=pricebookId,
                                            OpportunityId=b2cOpportunityId,
                                            QuoteId=b2cQuoteId,
                                            Type='Reclamation'
                                            );
        insert b2cOrder3;
        System.debug('---- setupSpecialOrderB2C - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('---- setupSpecialOrderB2C - SOQL USED: ' + LIMITS.getQueries());
    }
    public static void setupOrderB2B(){
        // Create B2B Order
        System.debug('---- setupOrderB2B - Opportunity to Sync: '+b2cOpportunityId);
        Order b2bOrder4 = new Order( Name='B2B Normal Order',
                                            Status='Draft',
                                            Pricebook2Id=pricebookId,
                                            OpportunityId=b2cOpportunityId,
                                            QuoteId=b2bQuoteId,
                                            Type='Normal'
                                            );
        insert b2bOrder4;
        System.debug('---- setupOrderB2B - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('---- setupOrderB2B - SOQL USED: ' + LIMITS.getQueries());
    }   
    @future
    public static void setupOrderItemsB2C() {
        List<OrderItem> orderItems = new List<OrderItem>();
        for (Integer i = 0; i<pricebookEntries.size();i++) {
            OrderItem oi = new OrderItem(OrderId=b2cOrderId,
                                         Product2Id=pricebookEntries[i].Product2Id,
                                         PricebookEntryId=pricebookEntries[i].Id,
                                         Quantity=1,
                                         UnitPrice=1
                                         );
            orderItems.add(oi);
        }
        insert orderItems;
    }
}