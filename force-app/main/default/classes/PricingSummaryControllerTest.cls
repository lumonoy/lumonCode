/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 03-18-2024
 * @last modified by  : Henk Reynders
**/
@IsTest
public with sharing class PricingSummaryControllerTest {
    @TestSetup
    public static void prepareData(){
        Test.startTest();
        LumonTestDataFactory.setupProducts();
        LumonTestDataFactory.setupPrices();
        // B2C Setup
        LumonTestDataFactory.setupAccountB2C();
        LumonTestDataFactory.setupOpportunityB2C(); 
        // B2B Setup
        LumonTestDataFactory.setupAccountB2B();
        LumonTestDataFactory.setupOpportunityB2B();  
        Test.stopTest();
    }   
    static Id b2cAccountId = LumonTestDataFactory.b2cAccountId;
    private static Id b2cOpportunityId = LumonTestDataFactory.b2cOpportunityId;
    private static List<Opportunity> b2cOpportunities = LumonTestDataFactory.b2cOpportunities;
    private static Id b2bAccountId = LumonTestDataFactory.b2bAccountId;
    private static Id b2bOpportunityId = LumonTestDataFactory.b2bOpportunityId;
    private static List<Opportunity> b2bOpportunities = LumonTestDataFactory.b2bOpportunities;
    private static List<Opportunity> opportunities = LumonTestDataFactory.opportunities;
    @IsTest
    static void getPricingSummaryTest(){
        String summaryId = PricingSummaryController.upsertPricingSummary(b2cOpportunityId);
        Test.startTest();
        Pricing_Summary__c summary = PricingSummaryController.getPricingSummary(b2cOpportunityId);
        System.Debug ('--- getPricingSummaryTest - Summary '+summary?.Id);
        System.assertNotEquals(null,summary?.Id, 'Expected One Summary to be returned');
        System.debug('--- getPricingSummaryTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getPricingSummaryTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getPricingSummariesTest(){
        String summaryId = PricingSummaryController.upsertPricingSummary(b2cOpportunityId);
        List<Id> recordIds = new List<Id>{b2cAccountId,b2cOpportunityId}; 
        Test.startTest();
        List<Pricing_Summary__c> summaries = PricingSummaryController.getPricingSummaries(recordIds);
        System.Debug ('--- getPricingSummariesTest - Summary Count  '+summaries?.size());
        System.assertNotEquals(0,summaries?.size(), 'Expected One or More Summaries to be returned');
        System.debug('--- getPricingSummariesTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getPricingSummariesTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void createPricingSummaryTest(){
        Pricing_Summary__c summary = PricingSummaryController.getPricingSummary(b2cOpportunityId);
        if (String.IsNotBlank(summary?.Id)) {
            delete summary;
        }
        Test.startTest();
        String summaryId = PricingSummaryController.createPricingSummary(b2cOpportunityId);
        System.Debug ('--- createPricingSummaryTest - Summary '+ summaryId);
        System.assertNotEquals(null,summaryId, 'Expected One Summary to be returned');
        System.debug('--- createPricingSummaryTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- createPricingSummaryTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void upsertPricingSummaryTest(){
        Pricing_Summary__c summary = PricingSummaryController.getPricingSummary(b2cOpportunityId);
        if (String.IsNotBlank(summary?.Id)) {
            delete summary;
        }
        Test.startTest();
        String summaryId = PricingSummaryController.upsertPricingSummary(b2cOpportunityId);
        System.Debug ('--- upsertPricingSummaryTest - Summary '+ summaryId);
        System.assertNotEquals(null,summaryId, 'Expected One Summary to be returned');
        System.debug('--- upsertPricingSummaryTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- upsertPricingSummaryTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void insertPricingSummaryTest(){
        Pricing_Summary__c summary = PricingSummaryController.getPricingSummary(b2cOpportunityId);
        if (String.IsBlank(summary?.Id)) {
            String summaryId = PricingSummaryController.createPricingSummary(b2cOpportunityId);
        }
        Test.startTest();
        String summaryId = PricingSummaryController.upsertPricingSummary(b2cOpportunityId);
        System.Debug ('--- insertPricingSummaryTest - Summary '+ summaryId);
        System.assertNotEquals(null,summaryId, 'Expected One Summary to be returned');
        System.debug('--- insertPricingSummaryTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- insertPricingSummaryTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }

}