/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 03-13-2024
 * @last modified by  : Henk Reynders
**/
@IsTest
public class QuoteLineItemControllerTest {
    private static Id b2cAccountId = LumonTestDataFactory.b2cAccountId;
    private static Id b2cOpportunityId = LumonTestDataFactory.b2cOpportunityId;
    private static Id b2cSyncedQuoteId = LumonTestDataFactory.b2cSyncedQuoteId;
    private static Id b2cQuoteId = LumonTestDataFactory.b2cQuoteId;
    private static List<Configuration__c> b2cConfigurations = LumonTestDataFactory.b2cConfigurations;
    private static List<Configuration_Product__c> b2cConfigProducts = LumonTestDataFactory.b2cConfigProducts;
    private static List<Configuration_Option__c> b2cConfigOptions = LumonTestDataFactory.b2cConfigOptions;
    private static List<Configuration_Message__c> b2cConfigMessages = LumonTestDataFactory.b2cConfigMessages;
    @TestSetup
    static void prepareData() {
        Test.startTest();
        LumonTestDataFactory.setupGlazingSliding();
        LumonTestDataFactory.setupGlazingRetractable();
        LumonTestDataFactory.setupAdditionalCosts();
        LumonTestDataFactory.setupExtraSales();
        // B2C Setup
        LumonTestDataFactory.setupAccountB2C();
        LumonTestDataFactory.setupOpportunityB2C();
        LumonTestDataFactory.setupPriceParameters();
        LumonTestDataFactory.setupPricingSummaryB2C();
        LumonTestDataFactory.setupSyncedQuoteB2C();        
        LumonTestDataFactory.setupConfigurationB2C();
        LumonTestDataFactory.setupSyncedQuoteLineItemsB2C();
        Test.stopTest();
    }     
    @IsTest
    static void getQuoteLineItemsTest(){
        Test.startTest();
        List<QuoteLineItem> qlis = QuoteLineItemController.getQuoteLineItems(b2cSyncedQuoteId);
        System.Debug ('--- '+ qlis.size() +' QuoteLineItems Returned');
		System.assertNotEquals(0,qlis.size(), 'Expected Quote Lines Items to be returned');
        System.debug('--- getQuoteLineItemsTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getQuoteLineItemsTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }   
    @IsTest
    static void getQuoteLineItemsByIdTest(){
        Test.startTest();
        List<Id> quoteIds = new List<Id>{b2cSyncedQuoteId};
        List<QuoteLineItem> qlis = QuoteLineItemController.getQuoteLineItemsById(quoteIds);
        System.Debug ('--- '+ qlis.size() +' QuoteLineItems Returned');
		System.assertNotEquals(0,qlis.size(), 'Expected Quote Lines Items to be returned');
        System.debug('--- getQuoteLineItemsByIdTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getQuoteLineItemsByIdTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getQuoteLineItemsToProductMapTest(){
        List<QuoteLineItem> qlis = QuoteLineItemController.getQuoteLineItems(b2cSyncedQuoteId);
        Test.startTest();
        Map<String,QuoteLineItem>  qliMap = QuoteLineItemController.getQuoteLineItemsToProductMap(qlis);
        System.Debug ('--- '+ qliMap.size() +' QuoteLineItems Returned in a Map');
		System.assertNotEquals(0,qliMap.size(), 'Expected Quote Lines Items to be returned');
        System.debug('--- getQuoteLineItemsByProductTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getQuoteLineItemsByProductTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getQuoteLineItemsToGroupMapTest(){
        List<QuoteLineItem> qlis = QuoteLineItemController.getQuoteLineItems(b2cSyncedQuoteId);
        Test.startTest();
        Map<String,QuoteLineItem>  qliMap = QuoteLineItemController.getQuoteLineItemsToGroupMap(qlis);
        System.Debug ('--- '+ qliMap.size() +' QuoteLineItems Returned in a Map');
		System.assertNotEquals(0,qliMap.size(), 'Expected Quote Lines Items to be returned');
        System.debug('--- getQuoteLineItemsToGroupMapTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getQuoteLineItemsToGroupMapTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
}