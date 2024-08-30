/**
 * @description       : Keep SalesTestDataFactory for now
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-12-2023
 * @last modified by  : Henk Reynders
**/
@isTest(isParallel=false)
public class OpportunityProductControllerTest {
    @TestSetup
    static void prepareData(){
        Test.startTest();
        
        // B2C Setup
        
        LumonTestDataFactory.setupProducts();
        LumonTestDataFactory.setupPriceBookEntries();
        LumonTestDataFactory.setupAdditionalCosts();
        LumonTestDataFactory.setupExtraSales();
        
        LumonTestDataFactory.setupAccountB2C();
        LumonTestDataFactory.setupOpportunityB2C();
		LumonTestDataFactory.setupPriceParameters();
        LumonTestDataFactory.setupPricingSummaryB2C();
        LumonTestDataFactory.setupSyncedQuoteB2C();       
        LumonTestDataFactory.setupConfigurationB2C();
        LumonTestDataFactory.setupConfigurationProductsB2C();
        LumonTestDataFactory.setupConfigurationOptionsB2C();       
        LumonTestDataFactory.setupConfigurationMessagesB2C();
        LumonTestDataFactory.setupSyncedQuoteLineItemsB2C();
        Test.stopTest();
    }
    private static Id b2cAccountId = LumonTestDataFactory.b2cAccountId;
    private static Id b2cOpportunityId = LumonTestDataFactory.b2cOpportunityId;
    private static List<Opportunity> b2cOpportunities = LumonTestDataFactory.b2cOpportunities;
    private static Id b2cSyncedQuoteId = LumonTestDataFactory.b2cSyncedQuoteId;
    private static Id b2cQuoteId = LumonTestDataFactory.b2cQuoteId;
    @IsTest
    static void getOpportunityRecordTest(){
        Test.startTest();
        Opportunity opportunity = OpportunityProductController.GetOpportunityRecord(b2cOpportunityId);
        System.Debug ('--- OpportunityProductController - '+ opportunity.Id +' Opportunity Returned');
        System.assertNotEquals(null,opportunity, 'Expected Opportunity Lines Items to be returned');
        Test.StopTest();
        System.debug('--- getOpportunityRecordTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getOpportunityRecordTest - SOQL USED: ' + LIMITS.getQueries());
    }
    @IsTest
    static void getOpportunityLineItemsTest(){
        Test.startTest();
        List<OpportunityLineItem> olis = OpportunityProductController.getOpportunityLineItems(b2cOpportunityId);
        System.Debug ('-- getOpportunityLineItemsTest - '+ olis.size() +' OpportunityLineItems Returned');
        System.assertNotEquals(0,olis.size(), 'Expected Opportunity Lines Items to be returned');
        Test.StopTest();
        System.debug('--- getOpportunityLineItemsTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getOpportunityLineItemsTest - SOQL USED: ' + LIMITS.getQueries());
    }
    @IsTest
    static void getOpportunityLineItemMapTest(){
        Test.startTest();
        Map<String,OpportunityLineItem>  oliMap = OpportunityProductController.getOpportunityLineItemMap(b2cOpportunityId,'EUR');
        System.Debug ('--- getOpportunityLineItemMapTest - '+ oliMap.size() +' OpportunityLineItems Returned in a Map');
        System.assertNotEquals(0,oliMap.size(), 'Expected Opportunity Lines Items to be returned');
        Test.StopTest();
        System.debug('--- getOpportunityLineItemMapTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getOpportunityLineItemMapTest - SOQL USED: ' + LIMITS.getQueries());
    }
    @IsTest
    static void getQuoteLineDataTest(){
        OpportunityProductController.ResponseWrapper qliWrapper = new OpportunityProductController.ResponseWrapper();
        Test.startTest();
        qliWrapper = OpportunityProductController.getData2(b2cOpportunityId);
        System.Debug ('---  QuoteLine Data Returned in a Wrapper');
        System.assertNotEquals(null,qliWrapper, 'Expected Quote Lines Items to be returned');
        Test.StopTest();
        System.debug('--- getQuoteLineDataTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getQuoteLineDataTest - SOQL USED: ' + LIMITS.getQueries());
    }
    @IsTest
    static void getOpportunityProductDataTest(){
        List<OpportunityProductController.ProductWrapper> oliWrapper = new List<OpportunityProductController.ProductWrapper>();
        Test.startTest();
        oliWrapper = OpportunityProductController.getData(b2cOpportunityId);
        System.Debug ('--- getOpportunityProductDataTest - Opporunity Product Data Returned in a Wrapper');
        System.assertNotEquals(null,oliWrapper, 'Expected Opportunity Lines Items to be returned');
        Test.StopTest();
        System.debug('--- getOpportunityProductDataTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getOpportunityProductDataTest - SOQL USED: ' + LIMITS.getQueries());
    }
 
}