/**
 * @description       : NOT IN USE ConfigurationEventTriggerHandler commented Out
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 10-08-2024
 * @last modified by  : Henk Reynders
**/
@IsTest(isParallel=false)
public class ConfigurationEventTriggerHandlerTest {
    /*@TestSetup
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
	@IsTest
	static void ProcessConfigurationEventsTest () {
        List<ConfigurationEvent__e> configChangeEvents = new List<ConfigurationEvent__e>();
        ConfigurationEvent__e configChangeEvent = new ConfigurationEvent__e();
        configChangeEvent.configId__c='123'; 
        configChangeEvent.recordId__c=b2cOpportunityId; 
        configChangeEvent.objectType__c='Opportunity'; 
        configChangeEvents.add(configChangeEvent);
		Test.startTest();
			ConfigurationEventTriggerHandler.processConfiguration(configChangeEvents);
		Test.stopTest();
	}
    @IsTest
	static void ProcessConfigurationEventsVisualTest () {
        List<ConfigurationEvent__e> configChangeEvents = new List<ConfigurationEvent__e>();
        ConfigurationEvent__e configChangeEvent = new ConfigurationEvent__e();
        configChangeEvent.configType__c='Test'; 
        configChangeEvent.configAction__c='Price'; 
        configChangeEvent.configId__c='123'; 
        configChangeEvent.recordId__c=b2cOpportunityId; 
        configChangeEvent.visualPlanId__c='789'; 
        configChangeEvent.pricingJSON__c='some text'; 
        configChangeEvents.add(configChangeEvent);
		Test.startTest();
			ConfigurationEventTriggerHandler.processConfiguration(configChangeEvents);
		Test.stopTest();
	}*/
}