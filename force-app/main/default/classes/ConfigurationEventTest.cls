/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-02-2023
 * @last modified by  : Henk Reynders
**/
@isTest(isParallel=false)
public class ConfigurationEventTest {
    @TestSetup
    static void prepareData(){
        Test.startTest();
        LumonTestDataFactory.setupProducts();
        LumonTestDataFactory.setupPriceBookEntries();
        // B2C Setup
        LumonTestDataFactory.setupAccountB2C();
        LumonTestDataFactory.setupOpportunityB2C();        
        LumonTestDataFactory.setupConfigurationB2C();
        LumonTestDataFactory.setupConfigurationProductsB2C();
        LumonTestDataFactory.setupConfigurationOptionsB2C();       
        LumonTestDataFactory.setupConfigurationMessagesB2C();
        Test.stopTest();
    }
    private static Id b2cAccountId = LumonTestDataFactory.b2cAccountId;
    private static Id b2cOpportunityId = LumonTestDataFactory.b2cOpportunityId;
    private static List<Configuration__c> b2cConfigurations = LumonTestDataFactory.b2cConfigurations;
    private static List<Configuration_Product__c> b2cConfigProducts = LumonTestDataFactory.b2cConfigProducts;
    private static List<Configuration_Option__c> b2cConfigOptions = LumonTestDataFactory.b2cConfigOptions;
    private static List<Configuration_Message__c> b2cConfigMessages = LumonTestDataFactory.b2cConfigMessages;  
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