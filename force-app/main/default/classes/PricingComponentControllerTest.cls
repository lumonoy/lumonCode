/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 03-28-2024
 * @last modified by  : Henk Reynders
**/
@isTest(isParallel=false)
public class PricingComponentControllerTest {
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
    static void getComponentDataTest(){
        Test.startTest();
        PricingComponentController.ComponentData pricingData = PricingComponentController.getComponentData(b2cOpportunityId); 
        System.Debug ('--- getComponentDataTest - pricingData: '+ pricingData);
        System.assertNotEquals(null, pricingData, 'Expecting a result');
        System.debug('--- getComponentDataTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getComponentDataTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void saveDataTest(){
        String errorMessage;
        Opportunity opp = [SELECT Id,StageName FROM Opportunity WHERE Id = : b2cOpportunityId LIMIT 1];
        Pricing_Summary__c summary = [SELECT Id,Sales_Price__c FROM Pricing_Summary__c WHERE Opportunity__c = : b2cOpportunityId LIMIT 1];
        List<QuoteLineItem> qlis = [SELECT Id FROM QuoteLineItem WHERE Quote.OpportunityId = : b2cOpportunityId];
        System.Debug ('--- saveDataTest - opportunity: '+ opp);
        System.Debug ('--- saveDataTest - summary: '+ summary);
        System.Debug ('--- saveDataTest - qlis: '+ qlis);
        // Update opportunity Stage 
        opp.StageName = 'Quoting';
        update opp;
        // Update summary SalesPrice
        summary.Sales_Price__c = 10000;
        Test.startTest();
        try {
            PricingComponentController.saveData(b2cOpportunityId,summary,qlis); 
        } catch (Exception e) {
            errorMessage = ('Unable to save Data');
        }
        
        System.assertEquals(null, errorMessage, 'Expecting a result');
        System.debug('--- saveDataTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- saveDataTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
     @IsTest
    static void saveDataExceptionTest(){
        String errorMessage;
        Opportunity opp = [SELECT Id,StageName FROM Opportunity WHERE Id = : b2cOpportunityId LIMIT 1];
        Pricing_Summary__c summary = [SELECT Id,Sales_Price__c FROM Pricing_Summary__c WHERE Opportunity__c = : b2cOpportunityId LIMIT 1];
        List<QuoteLineItem> qlis = [SELECT Id FROM QuoteLineItem WHERE Quote.OpportunityId = : b2cOpportunityId];
        System.Debug ('--- saveDataExceptionTest - opportunity: '+ opp);
        System.Debug ('--- saveDataExceptionTest - summary: '+ summary);
        System.Debug ('--- saveDataExceptionTest - qlis: '+ qlis);
        // Update opportunity Stage 
        opp.StageName = 'Preparation & Analysis';
        update opp;
        // Update summary SalesPrice
        summary.Sales_Price__c = 10000;
        Test.startTest();
        try {
            PricingComponentController.saveData(b2cOpportunityId,summary,qlis); 
        } catch (Exception e) {
            errorMessage = ('Unable to save Data');
        }
        
        System.assertNotEquals(null, errorMessage, 'Expecting a result');
        System.debug('--- saveDataExceptionTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- saveDataExceptionTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
     
}