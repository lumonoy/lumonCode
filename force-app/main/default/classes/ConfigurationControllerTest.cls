/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 10-01-2024
 * @last modified by  : Henk Reynders
**/
@IsTest(isParallel=false)
public with sharing class ConfigurationControllerTest {
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
    static void getConfigurationsByIdTest(){
        List<Id> configPlanIds = configurationPlanIds;
        System.debug('--- getConfigurationsByIdTest - configPlanIds: '+configPlanIds); 
        Test.startTest();
        List<Configuration__c> configPlans = ConfigurationController.getConfigurationsById(configPlanIds);
        System.assertNotEquals(0, configPlans.size(), 'Expecting atleast 1 Configuration to be returned');
        System.debug('--- getConfigurationsByIdTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getConfigurationsByIdTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getConfigurationsByParentIdTest(){
        List<Id> configPlanIds = configurationPlanIds;
        String recordId = b2cOpportunityId;
        System.debug('--- getConfigurationsByParentIdTest - recordId: '+recordId); 
        Test.startTest();
        List<Configuration__c> configPlans = ConfigurationController.getConfigurationsByParentId(recordId);
        System.assertNotEquals(0, configPlans.size(), 'Expecting atleast 1 Configuration to be returned');
        System.debug('--- getConfigurationsByParentIdTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getConfigurationsByParentIdTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getConfigurationsByParentAndIdTest(){
        String recordId = b2cOpportunityId;
        List<Id> configPlanIds = configurationPlanIds;
        System.debug('--- getConfigurationsByParentAndIdTest - recordId: '+recordId); 
        System.debug('--- getConfigurationsByParentAndIdTest - configPlanIds: '+configPlanIds); 
        Test.startTest();
        List<Configuration__c> configPlans = ConfigurationController.getConfigurationsByParentAndId(recordId, configPlanIds);
        System.assertNotEquals(0, configPlans.size(), 'Expecting atleast 1 Configuration to be returned');
        System.debug('--- getConfigurationsByParentAndIdTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getConfigurationsByParentAndIdTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getConfigurationPlansByIdTest(){
        List<Id> configPlanIds = new List<Id>();
        String recordId = b2cOpportunityId;
        String visualPlanId;
        System.debug('--- getConfigurationPlansByIdTest - recordId: '+recordId); 
        Test.startTest();
        List<Configuration__c> configPlans = ConfigurationController.getConfigurations(configPlanIds,recordId, visualPlanId);
        System.assertNotEquals(0, configPlans.size(), 'Expecting atleast 1 Configuration to be returned');
        System.debug('--- getConfigurationPlansByIdTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getConfigurationPlansByIdTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getConfigurationsByVisualIdTest(){
        String visualPlanId = 'ABCDE';
        System.debug('--- getConfigurationsByVisualIdTest - visualPlanId: '+visualPlanId); 
        Test.startTest();
        List<Configuration__c> configPlans = ConfigurationController.getConfigurationsByVisualId(visualPlanId);
        System.assertNotEquals(0, configPlans.size(), 'Expecting atleast 1 Configuration to be returned');
        System.debug('--- getConfigurationsByVisualIdTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getConfigurationsByVisualIdTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getConfigurationsByConfigIdTest(){
        List<Id> configPlanIds = configurationPlanIds;
        System.debug('--- getConfigurationsByConfigIdTest - configPlanIds: '+configPlanIds); 
        Test.startTest();
        List<Configuration__c> configPlans = ConfigurationController.getConfigurationsById(configPlanIds);
        System.assertNotEquals(0, configPlans.size(), 'Expecting atleast 1 Configuration to be returned');
        System.debug('--- getConfigurationsByConfigIdTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getConfigurationsByConfigIdTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getConfigurationPlansByVisualIdTest(){
        List<Id> configPlanIds = new List<Id>();
        String recordId;
        String visualPlanId = 'ABCDE';
        System.debug('--- getConfigurationPlansByVisualIdTest - visualPlanId: '+visualPlanId); 
        System.debug('--- getConfigurationPlansByVisualIdTest - recordId: '+recordId); 
        Test.startTest();
        List<Configuration__c> configPlans = ConfigurationController.getConfigurations(configPlanIds,recordId, visualPlanId);
        System.assertNotEquals(0, configPlans.size(), 'Expecting atleast 1 Configuration to be returned');
        System.debug('--- getConfigurationPlansByVisualIdTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getConfigurationPlansByVisualIdTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getConfigurationPlansByParentAndIdTest(){
        List<Id> configPlanIds = configurationPlanIds;
        String recordId = b2cOpportunityId;
        String visualPlanId;
        System.debug('--- getConfigurationPlansByParentAndIdTest - configPlanIds: '+configPlanIds); 
        System.debug('--- getConfigurationPlansByParentAndIdTest - recordId: '+recordId); 
        Test.startTest();
        List<Configuration__c> configPlans = ConfigurationController.getConfigurations(configPlanIds,recordId, visualPlanId);
        System.assertNotEquals(0, configPlans.size(), 'Expecting atleast 1 Configuration to be returned');
        System.debug('--- getConfigurationPlansByVisualIdTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getConfigurationPlansByVisualIdTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getConfigurationPlansByConfigIdsTest(){
        List<Id> configPlanIds = configurationPlanIds;
        String recordId;
        String visualPlanId;
        System.debug('--- getConfigurationPlansByConfigIdsTest - configPlanIds: '+configPlanIds); 
        Test.startTest();
        List<Configuration__c> configPlans = ConfigurationController.getConfigurations(configPlanIds,recordId, visualPlanId);
        System.assertNotEquals(0, configPlans.size(), 'Expecting atleast 1 Configuration to be returned');
        System.debug('--- getConfigurationPlansByConfigIdsTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getConfigurationPlansByConfigIdsTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getVisualIdToPlanMapTest(){
        List<Configuration__c> cfgPlans =  configurationPlans;
        Test.startTest();
        Map<String,Configuration__c> visualToPlanMap = ConfigurationController.getVisualIdToPlanMap(cfgPlans);
        System.assertNotEquals(null, visualToPlanMap, 'Expecting atleast 1 Configuration Plan to be returned');
        System.debug('--- getVisualIdToPlanMapTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getVisualIdToPlanMapTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getConfigurationProductsTest(){
        List<Id> configPlanIds = configurationPlanIds;
        Test.startTest();
        List<Configuration_Product__c> configProducts = ConfigurationController.getConfigurationProducts(configPlanIds);
        System.assertNotEquals(0, configProducts.size(), 'Expecting atleast 1 Configuration Product to be returned');
        System.debug('--- getConfigurationProductsTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getConfigurationProductsTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getConfigurationOptionsTest(){
        List<Id> configPlanIds = configurationPlanIds;
        List<Id> configProductIds = configurationProductIds; 
        Test.startTest();
        List<Configuration_Option__c> configurationOptions = ConfigurationController.getConfigurationOptions(configProductIds); 
        System.assertNotEquals(0, configurationOptions.size(), 'Expecting one ore more Configuration Option(s)  to be returned');
        System.debug('--- getConfigurationOptionsTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getConfigurationOptionsTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getConfigurationOptionsByIdTest(){
        List<Id> configPlanIds = configurationPlanIds;
        List<Id> configProductIds = configurationProductIds; 

        Test.startTest();
        List<Configuration_Option__c> configurationOptions = ConfigurationController.getConfigurationOptionsByIds(configurationOptionIds); 
        System.assertNotEquals(0, configurationOptions.size(), 'Expecting one ore more Configuration Option(s)  to be returned');
        System.debug('--- getConfigurationOptionsByIdTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getConfigurationOptionsByIdTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getConfigurationProductsByIdTest(){
        List<Configuration_Product__c> cfgProducts =  configurationProducts;
        List<Id> cfgProductIds = new List<Id>(new Map<Id, Configuration_Product__c>(cfgProducts).keySet()); 
        Test.startTest();
        List<Configuration_Product__c> configProducts = ConfigurationController.getConfigurationProductsById(cfgProductIds);
        System.assertNotEquals(0, configProducts.size(), 'Expecting atleast 1 Configuration Product to be returned');
        System.debug('--- getConfigurationProductsByIdTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getConfigurationProductsByIdTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getConfigurationProductsByParentIdTest(){
        String recordId = b2cOpportunityId;
        Test.startTest();
        List<Configuration_Product__c> configProducts = ConfigurationController.getConfigurationProductsByParentId(recordId);
        System.assertNotEquals(0, configProducts.size(), 'Expecting atleast 1 Configuration Product to be returned');
        System.debug('--- getConfigurationProductsByParentIdTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getConfigurationProductsByParentIdTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getStructureToProductMapTest(){
        List<Configuration_Product__c> cfgProducts =  configurationProducts;
        Test.startTest();
        Map<String,Configuration_Product__c> structureToProductMap = ConfigurationController.getStructureToProductMap(cfgProducts);
        System.assertNotEquals(null, structureToProductMap, 'Expecting atleast 1 Configuration Product to be returned');
        System.debug('--- getStructureToProductMapTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getStructureToProductMapTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getRVNToProductMapTest(){
        List<Configuration_Product__c> cfgProducts =  configurationProducts;
        Test.startTest();
        Map<String,Configuration_Product__c> rvnToProductMap = ConfigurationController.getRVNToProductMap(cfgProducts);
        System.assertNotEquals(null, rvnToProductMap, 'Expecting atleast 1 Configuration Product to be returned');
        System.debug('--- getRVNToProductMapTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getRVNToProductMapTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getGroupToProductsMapTest(){
        List<Configuration_Product__c> cfgProducts =  configurationProducts;
        Test.startTest();
        Map<String,List<Configuration_Product__c>> groupToProductsMap = ConfigurationController.getGroupToProductsMap(cfgProducts);
        System.assertNotEquals(null, groupToProductsMap, 'Expecting atleast 1 Configuration Product to be returned');
        System.debug('--- getGroupToProductsMapTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getGroupToProductsMapTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getProductCodeToOptionsMapTest(){
        List<Configuration_Option__c> cfgOptions =  configurationOptions;
        Test.startTest();
        Map<String,List<Configuration_Option__c>> ProductCodeToOptionsMap = ConfigurationController.getProductCodeToOptionsMap(cfgOptions);
        System.assertNotEquals(null, ProductCodeToOptionsMap, 'Expecting atleast 1 Configuration Option to be returned');
        System.debug('--- getProductCodeToOptionsMapTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getProductCodeToOptionsMapTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getUniqueIdToOptionMapTest(){
        List<Configuration_Option__c> cfgOptions =  configurationOptions;
        Test.startTest();
        Map<String,Configuration_Option__c> UniqueIdToOptionMap = ConfigurationController.getUniqueIdToOptionMap(cfgOptions);
        System.assertNotEquals(null, UniqueIdToOptionMap, 'Expecting atleast 1 Configuration Option to be returned');
        System.debug('--- getUniqueIdToOptionMapTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getUniqueIdToOptionMapTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getConfigurationMessagesTest(){
        List<Configuration_Product__c> configProducts  = configurationProducts;
        List<Id> configProductIds = new List<Id>(new Map<Id, Configuration_Product__c>(configProducts).keySet());
        Test.startTest();
        List<Configuration_Message__c> messages = ConfigurationController.getConfigurationMessages(configProductIds); 
        System.assertNotEquals(0, messages.size(), 'Expecting One or More Items to be returned');
        System.debug('--- getConfigurationMessagesTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getConfigurationMessagesTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getVisualPricingJSONTest(){
        List<Configuration__c> configurations = configurationPlans;
        List<Id> configPlanIds = new List<Id>(new Map<Id, Configuration__c>(configurations).keySet()); 
        String configPlanId = configPlanIds[0];
        Test.startTest();
        String visualPricingJSON = ConfigurationController.getVisualPricingJSON(configPlanId); 
        System.assertNotEquals(null, visualPricingJSON, 'Expecting a JSON to be returned');
        System.debug('--- getVisualPricingJSONTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getVisualPricingJSONTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getVisualConfigurationObjectsTest(){
        List<Configuration__c> configurations =  configurationPlans;
        List<Id> configPlanIds = new List<Id>(new Map<Id, Configuration__c>(configurations).keySet()); 
        String configPlanId = configPlanIds[0];
        String visualPricingJSON = LumonTestConfigurations.visualPricingJSON;
        Test.startTest();
        VisualConfiguration visualConfigObjects = ConfigurationController.getVisualConfigurationObjects(visualPricingJSON);
        System.assertNotEquals(null, visualPricingJSON, 'Expecting a JSON to be returned');
        System.debug('--- getVisualConfigurationObjectsTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getVisualConfigurationObjectsTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getConfigJSONsMapTest(){
        List<Configuration__c> configurations =  configurationPlans;
        List<Id> configPlanIds = new List<Id>(new Map<Id, Configuration__c>(configurations).keySet()); 
        String configPlanId = configPlanIds[0];
        Test.startTest();
        Map<Id,String>  configJSONsMap = ConfigurationController.getConfigJSONsMap(configPlanIds); 
        System.assertNotEquals(null, configJSONsMap, 'Expecting a Map of JSONs to be returned');
        System.debug('--- getConfigJSONsMapTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getConfigJSONsMapTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getConfigurationDataWrapperTest(){
        String recordId;
        List<String> visualPlanIds = new List<String>{'ABCDE'};
        List<Configuration__c> configurations =  configurationPlans;
        List<Id> configPlanIds = new List<Id>(new Map<Id, Configuration__c>(configurations).keySet()); 
        String configPlanId = configPlanIds[0];
        Test.startTest();
        ConfigurationController.configWrapper  configData = ConfigurationController.getConfigurationData(recordId,configPlanIds,visualPlanIds); 
        System.assertNotEquals(null, configData, 'Expecting a Configuration Data to be returned');
        System.debug('--- getConfigurationDataWrapperTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getConfigurationDataWrapperTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }  
    @IsTest
    static void getConfigurationFilesTest(){
        String recordId = b2cOpportunityId;
        Test.startTest();
        List<ContentDocumentLink>  configFiles = ConfigurationController.getConfigurationFiles(recordId); 
        System.assertNotEquals(0, configFiles.size(), 'Expecting Configuration Files to be returned');
        System.debug('--- getConfigurationFilesTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getConfigurationFilesTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }  
    @IsTest
    static void getVisualPricingFilesTest(){
        String recordId = b2cOpportunityId;
        List<String> visualPlanIds = new List<String>{'ABCDE'};
        List<Configuration__c> configurations =  configurationPlans;
        List<Id> configPlanIds = new List<Id>(new Map<Id, Configuration__c>(configurations).keySet()); 
        String configPlanId = configPlanIds[0];
        Test.startTest();
        Map<ID, String>  visualPricingFilesMap = ConfigurationController.getVisualPricingFiles(recordId); 
        System.assertNotEquals(null, visualPricingFilesMap, 'Expecting Visual Pricing Files to be returned');
        System.debug('--- getVisualPricingFilesTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getVisualPricingFilesTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }  
    @IsTest
    static void loadVisualPricingFileTest(){
        String recordId = b2cOpportunityId;
        List<String> visualPlanIds = new List<String>{'ABCDE'};
        List<Configuration__c> configurations =  configurationPlans;
        List<Id> configPlanIds = new List<Id>(new Map<Id, Configuration__c>(configurations).keySet()); 
        String sObjectType;
        String contentDocumentId;
        String configId;
        String configPlanId = configPlanIds[0];
        Test.startTest();
        ConfigurationController.loadVisualPricingFile(contentDocumentId,recordId,sObjectType,configId); 
        
        System.debug('--- loadVisualPricingFileTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- loadVisualPricingFileTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }  

    @IsTest
    static void getVisualConfigurationPlanTest(){
        String recordId = b2cOpportunityId;
        List<String> visualPlanIds = new List<String>{'ABCDE'};
        String visualPlanId = visualPlanIds[0];
        List<Configuration__c> configurations =  configurationPlans;
        List<Id> configPlanIds = new List<Id>(new Map<Id, Configuration__c>(configurations).keySet()); 
        String configPlanId = configPlanIds[0];
        Test.startTest();
        Configuration__c visualConfigurationPlan = ConfigurationController.getVisualConfigurationPlan(visualplanId); 
        System.assertNotEquals(null, visualConfigurationPlan, 'Expecting a Configuration Plan to be returned');
        System.debug('--- getVisualConfigurationPlanTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getVisualConfigurationPlanTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }  
    @IsTest
    static void getConfigurationPlanTest(){
        String recordId = b2cOpportunityId;
        List<String> visualPlanIds = new List<String>{'ABCDE'};
        String visualPlanId = visualPlanIds[0];
        List<Configuration__c> configurations =  configurationPlans;
        List<Id> configPlanIds = new List<Id>(new Map<Id, Configuration__c>(configurations).keySet()); 
        String configPlanId = configPlanIds[0];
        Test.startTest();
        Configuration__c configurationPlan = ConfigurationController.getConfigurationPlan(configPlanId); 
        System.assertNotEquals(null, configurationPlan, 'Expecting  a Configuration Plan  to be returned');
        System.debug('--- getConfigurationPlanTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getConfigurationPlanTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }  
    @IsTest
    static void getRelatedConfigurationsTest(){
        String recordId = b2cOpportunityId;
        List<String> visualPlanIds = new List<String>{'ABCDE'};
        String visualPlanId = visualPlanIds[0];
        List<Configuration__c> configurations =  configurationPlans;
        List<Id> configPlanIds = new List<Id>(new Map<Id, Configuration__c>(configurations).keySet()); 
        String configPlanId = configPlanIds[0];
        Test.startTest();
        List<Configuration__c> configurationPlans = ConfigurationController.getRelatedConfigurations(recordId); 
        System.assertNotEquals(0, configurationPlans.size(), 'Expecting one ore more Configuration Plan(s)  to be returned');
        System.debug('--- getRelatedConfigurationsTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getRelatedConfigurationsTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getConfigurationProductToItemsMapTest(){
        String recordId = b2cOpportunityId;
        List<String> visualPlanIds = new List<String>{'ABCDE'};
        String visualPlanId = visualPlanIds[0];
        List<Configuration__c> configurations =  configurationPlans;
        List<Id> configPlanIds = new List<Id>(new Map<Id, Configuration__c>(configurations).keySet()); 
        String configPlanId = configPlanIds[0];
        List<Configuration_Product__c> cfgProducts =  configurationProducts;
        List<Id> cfgProductIds = new List<Id>(new Map<Id, Configuration_Product__c>(cfgProducts).keySet()); 
        Test.startTest();
        Map<String,List<Configuration_Option__c>> configProductToItemsMap = ConfigurationController.getConfigurationProductToItemsMap(cfgProducts); 
        System.assertNotEquals(null, configProductToItemsMap, 'Expecting one ore more Configuration Products  to be returned');
        System.debug('--- getConfigurationProductToItemsMapTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getConfigurationProductToItemsMapTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getConfigurationPlansTest(){
        String recordId = b2cOpportunityId;
        Test.startTest();
        List<Configuration__c>  configPlans = ConfigurationController.getConfigurationPlans(recordId); 
        System.assertNotEquals(0, configPlans.size(), 'Expecting one ore more Configuration Plans  to be returned');
        System.debug('--- getConfigurationPlansTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getConfigurationPlansTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }

    @IsTest
    static void processVisualConfigurationTest(){
        List<Configuration__c> configurations =  configurationPlans;
        List<Id> configPlanIds = new List<Id>(new Map<Id, Configuration__c>(configurations).keySet()); 
        String recordId = b2cOpportunityId;
        String configPlanId = configPlanIds[0];
        String visualPricingJSON = LumonTestConfigurations.visualPricingJSON;
        Test.startTest();
        String visualConfigResult = ConfigurationController.processVisualConfiguration(configPlanId,recordId,visualPricingJSON);
        System.assertNotEquals(null, visualConfigResult, 'Expecting a JSON to be processed');
        System.debug('--- processVisualConfigurationTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- processVisualConfigurationTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getAllConfigurationsTest1(){
        List<Configuration__c> configurations =  configurationPlans;
        List<Id> configPlanIds = new List<Id>(new Map<Id, Configuration__c>(configurations).keySet()); 
        String recordId = b2cOpportunityId;
        String configPlanId = configPlanIds[0];
        String visualPlanId = 'ABCDE';
        Test.startTest();
        List<Configuration__c> allConfigurations = ConfigurationController.getAllConfigurations(configPlanId,recordId,visualPlanId);
        System.assertNotEquals(0, allConfigurations.size(), 'Expecting a Configuration to be returned');
        System.debug('--- getAllConfigurationsTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getAllConfigurationsTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getAllConfigurationsTest2(){
        List<Configuration__c> configurations =  configurationPlans;
        List<Id> configPlanIds = new List<Id>(new Map<Id, Configuration__c>(configurations).keySet()); 
        String recordId = b2cOpportunityId;
        String configPlanId = configPlanIds[0];
        String visualPlanId = 'ABCDE-1';
        Test.startTest();
        List<Configuration__c> allConfigurations = ConfigurationController.getAllConfigurations(configPlanId,recordId,visualPlanId);
        System.assertNotEquals(0, allConfigurations.size(), 'Expecting a Configuration to be returned');
        System.debug('--- getAllConfigurationsTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getAllConfigurationsTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getAllConfigurationsTest3(){
        List<Configuration__c> configurations =  configurationPlans;
        List<Id> configPlanIds = new List<Id>(new Map<Id, Configuration__c>(configurations).keySet()); 
        String recordId = b2cOpportunityId;
        String configPlanId;
        String visualPlanId;
        Test.startTest();
        List<Configuration__c> allConfigurations = ConfigurationController.getAllConfigurations(configPlanId,recordId,visualPlanId);
        System.assertNotEquals(0, allConfigurations.size(), 'Expecting a Configuration to be returned');
        System.debug('--- getAllConfigurationsTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getAllConfigurationsTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }

    @IsTest
    static void testDeleteOpportunity(){
        Test.startTest();
        delete new Opportunity(Id = b2cOpportunityId);
        System.assert([SELECT Id FROM Opportunity WHERE Id = :b2cOpportunityId].isEmpty(),
            'The opportunity should have been deleted');
        Test.stopTest();
    }
    @IsTest
    static void processConfigurationVisualTest(){
        List<Configuration__c> configurations =  configurationPlans;
        List<Id> configPlanIds = new List<Id>(new Map<Id, Configuration__c>(configurations).keySet()); 
        String recordId = b2cOpportunityId;
        String configPlanId = configPlanIds[0];
        Test.startTest();
        String visualConfigResult = ConfigurationController.processVisualConfiguration(configPlanId,recordId,visualPricingJSON);
        System.assertNotEquals(null, visualConfigResult, 'Expecting Visual Pricing JSON to be processed');
        System.debug('--- processConfigurationVisualTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- processConfigurationVisualTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void processConfigurationSoveliaTest(){
        List<Configuration__c> configurations =  configurationPlans;
        List<Id> configPlanIds = new List<Id>(new Map<Id, Configuration__c>(configurations).keySet()); 
        String recordId = b2cOpportunityId;
        String configPlanId = configPlanIds[0];
        Test.startTest();
        String soveliaConfigResult = ConfigurationController.processSoveliaConfiguration(configPlanId,recordId,soveliaPricingJSON);
        System.assertNotEquals(null, soveliaConfigResult, 'Expecting Sovelia Pricing JSON to be processed');
        System.debug('--- processConfigurationSoveliaTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- processConfigurationSoveliaTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
}