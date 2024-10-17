/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 10-01-2024
 * @last modified by  : Henk Reynders
**/
@isTest(isParallel=false)
public class ConfigurationEventTest {
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
    @isTest static void validEventTest() {
        List<Opportunity> opps = ([SELECT Id FROM Opportunity LIMIT 1]);
        String recordId = opps[0].Id;
        // Create a test event instance
        ConfigurationEvent__e cfgEvent = new ConfigurationEvent__e(recordId__c=recordId, 
                                                                    configId__c=null, 
                                                                    visualPlanId__c='12345',
                                                                    configJSON__c='');
        Test.startTest();       
        // Publish test event
        Database.SaveResult sr = EventBus.publish(cfgEvent);          
        Test.stopTest();       
        System.assertEquals(true, sr.isSuccess());
    }

    @isTest static void allParamsEventTest() {
        List<Opportunity> opps = ([SELECT Id FROM Opportunity LIMIT 1]);
        String recordId = opps[0].Id;
        // Create a test event instance
        ConfigurationEvent__e cfgEvent = new ConfigurationEvent__e(configType__c='Type',
                                                                    configAction__c ='Action',
                                                                    recordId__c=recordId, 
                                                                    objectType__c = 'Opportunity',
                                                                    configId__c='123', 
                                                                    externalId__c='123ABC',
                                                                    visualPlanId__c='ABCDE',
                                                                    documentId__c='456',
                                                                    blindsJSON__c='',
                                                                    configJSON__c='',
                                                                    itemJSON__c='',
                                                                    pricingJSON__c='',
                                                                    structureJSON__c='');
        Test.startTest();       
        // Publish test event
        Database.SaveResult sr = EventBus.publish(cfgEvent);          
        Test.stopTest();       
        System.assertEquals(true, sr.isSuccess());
    }
    
    @isTest static void invalidEventTest() {     
        // Create a test event instance with invalid data.
        // We assume for this test that the Serial_Number__c field is required.
        // Publishing with a missing required field should fail.
        ConfigurationEvent__e cfgEvent = new ConfigurationEvent__e(recordId__c=null, 
                                                                    configId__c=null, 
                                                                    visualPlanId__c='12345',
                                                                    configJSON__c='');
        
        Test.startTest(); 
        // Publish test event
        Database.SaveResult sr = EventBus.publish(cfgEvent);
        Test.stopTest();       
        System.assertEquals(false, sr.isSuccess());      
        // Log the error message
        for(Database.Error err : sr.getErrors()) {
            System.debug('Error returned: ' +
                        err.getStatusCode() +
                        ' - ' +
                        err.getMessage()+' - '+err.getFields());
        }
        // Verify that something did not happen
    }
}