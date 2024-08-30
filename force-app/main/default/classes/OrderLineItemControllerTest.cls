@IsTest
public class OrderLineItemControllerTest {
    @TestSetup
    static void prepareData(){
        Test.startTest();
        LumonTestDataFactory.setupProducts();
        LumonTestDataFactory.setupPrices();
        // B2C Setup
        LumonTestDataFactory.setupAccountB2C();
        LumonTestDataFactory.setupOpportunityB2C();
        LumonTestDataFactory.setupOrderB2C();
        LumonTestDataFactory.setupOrderItemsB2C();
        LumonTestDataFactory.setupConfigurationB2C();
        LumonTestDataFactory.setupConfigurationProductsB2C();
        LumonTestDataFactory.setupConfigurationOptionsB2C();       
        LumonTestDataFactory.setupConfigurationMessagesB2C();
        Test.stopTest();
    }
    private static Id b2cAccountId = LumonTestDataFactory.b2cAccountId;
    private static Id b2cOrderId = LumonTestDataFactory.b2cOrderId;
    private static Id b2cOpportunityId = LumonTestDataFactory.b2cOpportunityId;
    private static Id b2cSyncedQuoteId = LumonTestDataFactory.b2cSyncedQuoteId;
    private static List<Configuration__c> b2cConfigurations = LumonTestDataFactory.b2cConfigurations;
    private static List<Configuration_Product__c> b2cConfigProducts = LumonTestDataFactory.b2cConfigProducts;
    private static List<Configuration_Option__c> b2cConfigOptions = LumonTestDataFactory.b2cConfigOptions;
    private static List<Configuration_Message__c> b2cConfigMessages = LumonTestDataFactory.b2cConfigMessages;
    @IsTest
    static void getOrderLineItemsTest(){
        Test.startTest();
        List<OrderItem> ois = OrderLineItemController.GetOrderLineItems(b2cOrderId);
        System.Debug ('--- '+ ois.size() +' Order Line Items Returned');
		System.assertNotEquals(0,ois.size(), 'Expected Order Lines Items to be returned');
        System.debug('--- GetOrderLineItemsTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- GetOrderLineItemsTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getOrderLineItemMapTest(){
        Test.startTest();
        Map<String,OrderItem>  oiMap = OrderLineItemController.getProductCodeToOrderLineItemMap(b2cOrderId,'EUR');
        System.Debug ('--- '+ oiMap.size() +' OrderLineItems Returned in a Map');
		System.assertNotEquals(0,oiMap.size(), 'Expected Order Lines Items to be returned');
        System.debug('--- GetOrderLineItemMapTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- GetOrderLineItemMapTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
}