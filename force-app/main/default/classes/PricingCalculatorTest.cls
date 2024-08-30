/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-01-2023
 * @last modified by  : Henk Reynders
**/
@IsTest(isParallel=false)
public class PricingCalculatorTest {
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
    static void calculatePricesTest(){
        String recordId = b2cQuoteId;
        List<Configuration__c> configurations =  b2cConfigurations;
        List<Id> configurationIds = new List<Id>(new Map<Id, Configuration__c>(b2cConfigurations).keySet()); 
        Test.startTest();
            String configId = String.valueOf(configurationIds[0]);
            String upsertResult = PricingController.upsertQuoteLines(recordId); 
            String calculationResult = PricingCalculator.calculatePrices(configId,b2cOpportunityId); 
            System.assertNotEquals(FALSE, String.isNotBlank(calculationResult), 'Expecting a result');
            System.debug('---calculatePricesTest - CPU TIME: '+LIMITS.getCpuTime()); 
            System.debug('---calculatePricesTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    } 
}