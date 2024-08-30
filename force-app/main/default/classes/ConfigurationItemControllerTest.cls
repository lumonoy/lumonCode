/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-02-2023
 * @last modified by  : Henk Reynders
**/
@IsTest(isParallel=false)
public class ConfigurationItemControllerTest {
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
    @IsTest
    static void getConfigurationPlanTest(){
        List<Configuration__c> configurations =  b2cConfigurations;
        List<Id> configurationIds = new List<Id>(new Map<Id, Configuration__c>(b2cConfigurations).keySet()); 
        Test.startTest();
        Configuration__c configPlan = ConfigurationItemController.getConfigurationPlan(configurationIds[0]);
        System.assertNotEquals(null, configPlan, 'Expecting atleast 1 Configuration to be returned');
        System.debug('--- getConfigurationPlanTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getConfigurationPlanTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getConfigurationPlansTest(){
        String recordId = b2cOpportunityId;
        List<Configuration__c> configurations =  b2cConfigurations;
        List<Id> configurationIds = new List<Id>(new Map<Id, Configuration__c>(b2cConfigurations).keySet()); 
        Test.startTest();
        List<Configuration__c>  configPlans = ConfigurationItemController.getConfigurationPlans(recordId);
        System.assertNotEquals(0, configPlans.size(), 'Expecting atleast 1 Configuration to be returned');
        System.debug('--- getConfigurationPlansTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getConfigurationPlansTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getConfigurationJSONTest(){
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        String oppId = opp.Id;
        String visualplanId;
        System.Debug ('--- Get Plan for (record): '+oppId);
        String cfgJSON = ConfigurationItemController.getConfigurationObject(oppId);
        System.Debug ('--- Returned Object JSON: '+cfgJSON);
        System.assertNotEquals(null, cfgJSON, 'Expecting atleast 1 Configuration Item to be returned');
    }

    
    @IsTest
    static void getConfigurationItemJSONTest() {
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        String oppId = opp.Id;
        String cfgJSON = ConfigurationItemController.getItemJSON(oppId);
        System.Debug ('--- Returned Items JSON: '+cfgJSON);
        System.assertNotEquals(null, cfgJSON, 'Expecting atleast 1 Configuration Item to be returned');
    }
}