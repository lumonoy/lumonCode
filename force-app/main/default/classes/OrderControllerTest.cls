@IsTest
public class OrderControllerTest {
    @TestSetup
    static void prepareData(){
        Test.startTest();
        LumonTestDataFactory.setupProducts();
        LumonTestDataFactory.setupPrices();
        // B2C Setup
        LumonTestDataFactory.setupAccountB2C();
        LumonTestDataFactory.setupOpportunityB2C();
        LumonTestDataFactory.setupOrderB2C();
        Test.stopTest();
    }
    private static Id b2cAccountId = LumonTestDataFactory.b2cAccountId;
    private static Id b2cOpportunityId = LumonTestDataFactory.b2cOpportunityId;
    private static Id b2cSyncedQuoteId = LumonTestDataFactory.b2cSyncedQuoteId;
    private static Id b2cOrderId = LumonTestDataFactory.b2cOrderId;
    @IsTest
    static void getOrderRecordTest(){
        Test.startTest();
        Order orderRecord = OrderController.GetOrderRecord(b2cOrderId);
        System.Debug ('--- '+ orderRecord.Id +' Order Returned');
        System.assertNotEquals(null,orderRecord, 'Expected Order Record to be returned');
        System.debug('--- GetOrderRecordTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- GetOrderRecordTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getOrdersTest(){
        Test.startTest();
        List<Id> orderIds = new List<Id> {b2cOrderId};
        List<Order> orders = OrderController.GetOrders(orderIds);
        System.Debug ('--- '+ orders.size() +' Orders Returned');
        System.assertNotEquals(0,orders.size(), 'Expected Order Record to be returned');
        System.debug('--- GetOrdersTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- GetOrdersTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
}