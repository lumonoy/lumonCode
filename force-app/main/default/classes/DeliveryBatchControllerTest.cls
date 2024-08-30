/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 04-08-2024
 * @last modified by  : Henk Reynders
**/
@IsTest(isParallel=false)
public with sharing class DeliveryBatchControllerTest {
    @TestSetup
    static void prepareData(){
        Test.startTest();
        LumonTestProducts.setupProducts('LG');
        LumonTestProducts.setupProducts('VISORBLINDSALES');
        LumonTestPricebooks.setupPricebookEntries();
        LumonTestPriceParameters.setupPriceParameters();
        LumonTestInstallationTimes.setupInstallationTimes();
        LumonTestProductionTimes.setupProductionTimes();
        LumonTestDeliverySchedules.setupDeliverySchedules();
        LumonTestConfigurations.setupConfigurationData();
        Test.stopTest();
    }
    private static Id b2cAccountId = LumonTestDataFactory.b2cAccountId;
    private static Id b2cOpportunityId = LumonTestDataFactory.b2cOpportunityId;
    private static List<Configuration__c> b2cConfigurations = LumonTestDataFactory.b2cConfigurations;
    private static List<Configuration_Product__c> b2cConfigProducts = LumonTestDataFactory.b2cConfigProducts;
    private static List<Configuration_Option__c> b2cConfigOptions = LumonTestDataFactory.b2cConfigOptions;
    private static List<Configuration_Message__c> b2cConfigMessages = LumonTestDataFactory.b2cConfigMessages;
    private static String visualPricingJSON = LumonTestConfigurations.visualPricingJSON;
    private static String soveliaPricingJSON = LumonTestConfigurations.soveliaPricingJSON;
    //private static String testPricingJSON = LumonTestConfigurations.testPricingJSON;
    @IsTest
    static void getDeliveryBatchesTest(){
        Test.startTest();
        Delivery_Batch__c newBatch = new Delivery_Batch__c(Opportunity__c = b2cOpportunityId);
        insert newBatch;
        List<Delivery_Batch__c> deliveryBatches = DeliveryBatchController.getDeliveryBatches(b2cOpportunityId);
        System.assertNotEquals(0, deliveryBatches.size(), 'Expecting atleast 1 DeliveryBatch to be returned');
        System.debug('--- getDeliveryBatchesTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getDeliveryBatchesTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
}