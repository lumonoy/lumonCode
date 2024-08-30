@IsTest
public with sharing class OppOverviewProductsCtrlTest {
     @TestSetup
    static void prepareData(){
        Test.startTest();
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
    static void fetchOverviewProductsTest(){
        Test.startTest();
        String configProductsJSON = OppOverviewProductsCtrl.fetchOverviewProducts(b2cOpportunityId);
    
        System.Debug ('--- fetchOverviewProductsTest - Returned Product String: '+configProductsJSON);
        System.assertNotEquals(null, configProductsJSON, 'Expecting atleast 1 Configuration Product to be returned');
        Test.StopTest();
        System.debug('--- fetchOverviewProductsTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- fetchOverviewProductsTest - SOQL USED: ' + LIMITS.getQueries());
    }
    
    @IsTest
    static void fetchOverviewProductsTestForCase(){
        
        Case c = new Case();
        c.Subject = 'Test Reclamation Case';
        insert c;
        
        Opportunity opp = [SELECT Id,Order_type__c FROM Opportunity where Id = :b2cOpportunityId LIMIT 1];
        opp.Order_type__c = 'Reclamation';
        opp.Case__c = c.Id;
        update opp;
        
        String visualplanId;
        String configProductsJSON = OppOverviewProductsCtrl.fetchOverviewProducts(c.Id);
    
        System.Debug ('*** Returned Product String: '+configProductsJSON);
        System.assertNotEquals(null, configProductsJSON, 'Expecting atleast 1 Configuration Product to be returned');
    }

}