/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 10-02-2024
 * @last modified by  : Henk Reynders
**/
@IsTest(isParallel=false)
public with sharing class DeliveryBatchControllerTest {
    public class CustomException extends Exception {}
    private static Id b2cAccountId = LumonTestVariables.b2cAccountId;
    private static Id b2bAccountId = LumonTestVariables.b2bAccountId;
    private static Id b2cOpportunityId = LumonTestVariables.b2cOpportunityId;
    private static Id b2bOpportunityId = LumonTestVariables.b2cOpportunityId;
    
	private static List<Id> configurationPlanIds = LumonTestVariables.configurationPlanIds;
    private static List<Id> configurationProductIds = LumonTestVariables.configurationProductIds;
    private static List<Id> configurationOptionIds = LumonTestVariables.configurationOptionIds;

    private static List<Configuration__c> configurationPlans = LumonTestVariables.configurationPlans;
    private static List<Configuration_Product__c> configurationProducts = LumonTestVariables.configurationProducts;
    private static List<Configuration_Option__c> configurationOptions = LumonTestVariables.configurationOptions;
    private static List<Configuration_Message__c> configurationMessages = LumonTestVariables.configurationMessages;
    private static String visualPricingJSON = LumonTestData.visualPricing;
    private static String soveliaPricingJSON = LumonTestData.soveliaPricing;
    @TestSetup
    static void prepareData(){
        Test.startTest();
        LumonTestDataFactory.setupProducts();
        LumonTestDataFactory.setupPrices();
        LumonTestDataFactory.setupConfigurations();
        Test.stopTest();
    }
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