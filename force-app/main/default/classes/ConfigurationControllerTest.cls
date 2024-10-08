/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-11-2023
 * @last modified by  : Henk Reynders
**/
@IsTest(isParallel=false)
public with sharing class ConfigurationControllerTest {
    @TestSetup
    static void prepareData(){
        Test.startTest();
        //LumonTestDataFactory.setupProducts();
        LumonTestProducts.setupTestProducts();
        LumonTestDataFactory.setupProductSettings();
        LumonTestDataFactory.setupPriceBooks();
        LumonTestDataFactory.setupInstallationTimes();
        LumonTestDataFactory.setupProductionTimes();

        // B2C Setup
        LumonTestDataFactory.setupAccountB2C();
        LumonTestDataFactory.setupOpportunityB2C();        
        LumonTestDataFactory.setupConfigurations();
        //LumonTestDataFactory.setupConfigurationProductsB2C();
        //LumonTestDataFactory.setupConfigurationOptionsB2C();       
        //LumonTestDataFactory.setupConfigurationMessagesB2C();

        // While custom settings data is included in sandbox copies, 
        // it is treated as data for the purposes of Apex test isolation. 
        // Apex tests must use SeeAllData=true to see existing custom settings data in the organization. 
        // As a best practice, create the required custom settings data in your test setup.
        
        Test.stopTest();
        
    }
    private static Id b2cAccountId = LumonTestVariables.b2cAccountId;
    private static Id b2cOpportunityId = LumonTestVariables.b2cOpportunityId;
    private static List<Configuration__c> b2cConfigurations = LumonTestVariables.b2cConfigurations;
    private static List<Configuration_Product__c> b2cConfigProducts = LumonTestVariables.b2cConfigProducts;
    private static List<Configuration_Option__c> b2cConfigOptions = LumonTestVariables.b2cConfigOptions;
    private static List<Configuration_Message__c> b2cConfigMessages = LumonTestVariables.b2cConfigMessages;
    private static String visualPricingJSON = string.valueOf([SELECT Visual_Pricing_JSON__c FROM Configuration__c WHERE plan_Type__c = 'visual' LIMIT 1]);
    private static String soveliaPricingJSON = string.valueOf([SELECT Sovelia_Pricing_JSON__c FROM Configuration__c WHERE plan_Type__c = 'sovelia' LIMIT 1]);
    //private static String testPricingJSON = LumonTestConfigurations.testPricingJSON;
    @IsTest
    static void getConfigurationsByIdTest(){
        List<Configuration__c> configurations =  b2cConfigurations;
        List<Id> configurationIds = new List<Id>(new Map<Id, Configuration__c>(b2cConfigurations).keySet()); 
        System.debug('--- getConfigurationsByIdTest - configurationIds: '+configurationIds); 
        Test.startTest();
        List<Configuration__c> configPlans = ConfigurationController.getConfigurationsById(configurationIds);
        System.assertNotEquals(0, configPlans.size(), 'Expecting atleast 1 Configuration to be returned');
        System.debug('--- getConfigurationsByIdTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getConfigurationsByIdTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getConfigurationsByParentIdTest(){
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
        List<Configuration__c> configurations =  b2cConfigurations;
        List<Id> configurationIds = new List<Id>(new Map<Id, Configuration__c>(b2cConfigurations).keySet()); 
        String recordId = b2cOpportunityId;
        System.debug('--- getConfigurationsByParentAndIdTest - recordId: '+recordId); 
        System.debug('--- getConfigurationsByParentAndIdTest - configurationIds: '+configurationIds); 
        Test.startTest();
        List<Configuration__c> configPlans = ConfigurationController.getConfigurationsByParentAndId(recordId, configurationIds);
        System.assertNotEquals(0, configPlans.size(), 'Expecting atleast 1 Configuration to be returned');
        System.debug('--- getConfigurationsByParentAndIdTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getConfigurationsByParentAndIdTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getConfigurationPlansByIdTest(){
        List<Id> configurationIds = new List<Id>();
        String recordId = b2cOpportunityId;
        String visualPlanId;
        System.debug('--- getConfigurationPlansByIdTest - recordId: '+recordId); 
        Test.startTest();
        List<Configuration__c> configPlans = ConfigurationController.getConfigurations(configurationIds,recordId, visualPlanId);
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
        List<Configuration__c> configurations =  b2cConfigurations;
        List<Id> configurationIds = new List<Id>(new Map<Id, Configuration__c>(b2cConfigurations).keySet()); 
        System.debug('--- getConfigurationsByConfigIdTest - configurationIds: '+configurationIds); 
        Test.startTest();
        List<Configuration__c> configPlans = ConfigurationController.getConfigurationsById(configurationIds);
        System.assertNotEquals(0, configPlans.size(), 'Expecting atleast 1 Configuration to be returned');
        System.debug('--- getConfigurationsByConfigIdTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getConfigurationsByConfigIdTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getConfigurationPlansByVisualIdTest(){
        List<Id> configurationIds = new List<Id>();
        String recordId;
        String visualPlanId = 'ABCDE';
        System.debug('--- getConfigurationPlansByVisualIdTest - visualPlanId: '+visualPlanId); 
        System.debug('--- getConfigurationPlansByVisualIdTest - recordId: '+recordId); 
        Test.startTest();
        List<Configuration__c> configPlans = ConfigurationController.getConfigurations(configurationIds,recordId, visualPlanId);
        System.assertNotEquals(0, configPlans.size(), 'Expecting atleast 1 Configuration to be returned');
        System.debug('--- getConfigurationPlansByVisualIdTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getConfigurationPlansByVisualIdTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getConfigurationPlansByParentAndIdTest(){
        List<Configuration__c> configurations =  b2cConfigurations;
        List<Id> configurationIds = new List<Id>(new Map<Id, Configuration__c>(b2cConfigurations).keySet()); 
        String recordId = b2cOpportunityId;
        String visualPlanId;
        System.debug('--- getConfigurationPlansByParentAndIdTest - configurationIds: '+configurationIds); 
        System.debug('--- getConfigurationPlansByParentAndIdTest - recordId: '+recordId); 
        Test.startTest();
        List<Configuration__c> configPlans = ConfigurationController.getConfigurations(configurationIds,recordId, visualPlanId);
        System.assertNotEquals(0, configPlans.size(), 'Expecting atleast 1 Configuration to be returned');
        System.debug('--- getConfigurationPlansByVisualIdTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getConfigurationPlansByVisualIdTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getConfigurationPlansByConfigIdsTest(){
        List<Configuration__c> configurations =  b2cConfigurations;
        List<Id> configurationIds = new List<Id>(new Map<Id, Configuration__c>(b2cConfigurations).keySet()); 
        String recordId;
        String visualPlanId;
        System.debug('--- getConfigurationPlansByConfigIdsTest - configurationIds: '+configurationIds); 
        Test.startTest();
        List<Configuration__c> configPlans = ConfigurationController.getConfigurations(configurationIds,recordId, visualPlanId);
        System.assertNotEquals(0, configPlans.size(), 'Expecting atleast 1 Configuration to be returned');
        System.debug('--- getConfigurationPlansByConfigIdsTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getConfigurationPlansByConfigIdsTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getVisualIdToPlanMapTest(){
        List<Configuration__c> cfgPlans =  b2cConfigurations;
        Test.startTest();
        Map<String,Configuration__c> visualToPlanMap = ConfigurationController.getVisualIdToPlanMap(cfgPlans);
        System.assertNotEquals(null, visualToPlanMap, 'Expecting atleast 1 Configuration Plan to be returned');
        System.debug('--- getVisualIdToPlanMapTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getVisualIdToPlanMapTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getConfigurationProductsTest(){
        List<Configuration__c> configurations =  b2cConfigurations;
        List<Id> configurationIds = new List<Id>(new Map<Id, Configuration__c>(configurations).keySet()); 
        Test.startTest();
        List<Configuration_Product__c> configProducts = ConfigurationController.getConfigurationProducts(configurationIds);
        System.assertNotEquals(0, configProducts.size(), 'Expecting atleast 1 Configuration Product to be returned');
        System.debug('--- getConfigurationProductsTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getConfigurationProductsTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getConfigurationOptionsTest(){
        List<Configuration__c> configurations =  b2cConfigurations;
        List<Id> configurationIds = new List<Id>(new Map<Id, Configuration__c>(configurations).keySet()); 
        List<Configuration_Product__c> configProducts = ConfigurationController.getConfigurationProducts(configurationIds);
        List<Id> configurationProductIds = new List<Id>(new Map<Id, Configuration_Product__c>(configProducts).keySet()); 
        Test.startTest();
        List<Configuration_Option__c> configurationOptions = ConfigurationController.getConfigurationOptions(configurationProductIds); 
        System.assertNotEquals(0, configurationOptions.size(), 'Expecting one ore more Configuration Option(s)  to be returned');
        System.debug('--- getConfigurationOptionsTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getConfigurationOptionsTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getConfigurationOptionsByIdTest(){
        List<Configuration__c> configurations =  b2cConfigurations;
        List<Id> configurationIds = new List<Id>(new Map<Id, Configuration__c>(configurations).keySet()); 
        List<Configuration_Product__c> configProducts = b2cConfigProducts;
        List<Id> configurationProductIds = new List<Id>(new Map<Id, Configuration_Product__c>(configProducts).keySet()); 
        List<Configuration_Option__c> configOptions = b2cConfigOptions;
        List<Id> configurationOptionIds = new List<Id>(new Map<Id, Configuration_Option__c>(configOptions).keySet()); 
        Test.startTest();
        List<Configuration_Option__c> configurationOptions = ConfigurationController.getConfigurationOptionsByIds(configurationOptionIds); 
        System.assertNotEquals(0, configurationOptions.size(), 'Expecting one ore more Configuration Option(s)  to be returned');
        System.debug('--- getConfigurationOptionsByIdTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getConfigurationOptionsByIdTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getConfigurationProductsByIdTest(){
        List<Configuration_Product__c> cfgProducts =  b2cConfigProducts;
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
        List<Configuration_Product__c> cfgProducts =  b2cConfigProducts;
        Test.startTest();
        Map<String,Configuration_Product__c> structureToProductMap = ConfigurationController.getStructureToProductMap(cfgProducts);
        System.assertNotEquals(null, structureToProductMap, 'Expecting atleast 1 Configuration Product to be returned');
        System.debug('--- getStructureToProductMapTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getStructureToProductMapTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getRVNToProductMapTest(){
        List<Configuration_Product__c> cfgProducts =  b2cConfigProducts;
        Test.startTest();
        Map<String,Configuration_Product__c> rvnToProductMap = ConfigurationController.getRVNToProductMap(cfgProducts);
        System.assertNotEquals(null, rvnToProductMap, 'Expecting atleast 1 Configuration Product to be returned');
        System.debug('--- getRVNToProductMapTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getRVNToProductMapTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getGroupToProductsMapTest(){
        List<Configuration_Product__c> cfgProducts =  b2cConfigProducts;
        Test.startTest();
        Map<String,List<Configuration_Product__c>> groupToProductsMap = ConfigurationController.getGroupToProductsMap(cfgProducts);
        System.assertNotEquals(null, groupToProductsMap, 'Expecting atleast 1 Configuration Product to be returned');
        System.debug('--- getGroupToProductsMapTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getGroupToProductsMapTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getProductCodeToOptionsMapTest(){
        List<Configuration_Option__c> cfgOptions =  b2cConfigOptions;
        Test.startTest();
        Map<String,List<Configuration_Option__c>> ProductCodeToOptionsMap = ConfigurationController.getProductCodeToOptionsMap(cfgOptions);
        System.assertNotEquals(null, ProductCodeToOptionsMap, 'Expecting atleast 1 Configuration Option to be returned');
        System.debug('--- getProductCodeToOptionsMapTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getProductCodeToOptionsMapTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getUniqueIdToOptionMapTest(){
        List<Configuration_Option__c> cfgOptions =  b2cConfigOptions;
        Test.startTest();
        Map<String,Configuration_Option__c> UniqueIdToOptionMap = ConfigurationController.getUniqueIdToOptionMap(cfgOptions);
        System.assertNotEquals(null, UniqueIdToOptionMap, 'Expecting atleast 1 Configuration Option to be returned');
        System.debug('--- getUniqueIdToOptionMapTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getUniqueIdToOptionMapTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getConfigurationMessagesTest(){
        List<Configuration_Product__c> configProducts  = b2cConfigProducts;
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
        List<Configuration__c> configurations =  b2cConfigurations;
        List<Id> configurationIds = new List<Id>(new Map<Id, Configuration__c>(configurations).keySet()); 
        String configPlanId = configurationIds[0];
        Test.startTest();
        String visualPricingJSON = ConfigurationController.getVisualPricingJSON(configPlanId); 
        System.assertNotEquals(null, visualPricingJSON, 'Expecting a JSON to be returned');
        System.debug('--- getVisualPricingJSONTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getVisualPricingJSONTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getVisualConfigurationObjectsTest(){
        List<Configuration__c> configurations =  b2cConfigurations;
        List<Id> configurationIds = new List<Id>(new Map<Id, Configuration__c>(configurations).keySet()); 
        String configPlanId = configurationIds[0];
        
        Test.startTest();
        VisualConfiguration visualConfigObjects = ConfigurationController.getVisualConfigurationObjects(visualPricingJSON);
        System.assertNotEquals(null, visualPricingJSON, 'Expecting a JSON to be returned');
        System.debug('--- getVisualConfigurationObjectsTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getVisualConfigurationObjectsTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getConfigJSONsMapTest(){
        List<Configuration__c> configurations =  b2cConfigurations;
        List<Id> configurationIds = new List<Id>(new Map<Id, Configuration__c>(configurations).keySet()); 
        String configPlanId = configurationIds[0];
        Test.startTest();
        Map<Id,String>  configJSONsMap = ConfigurationController.getConfigJSONsMap(configurationIds); 
        System.assertNotEquals(null, configJSONsMap, 'Expecting a Map of JSONs to be returned');
        System.debug('--- getConfigJSONsMapTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getConfigJSONsMapTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getConfigurationDataWrapperTest(){
        String recordId;
        List<String> visualPlanIds = new List<String>{'ABCDE'};
        List<Configuration__c> configurations =  b2cConfigurations;
        List<Id> configurationIds = new List<Id>(new Map<Id, Configuration__c>(configurations).keySet()); 
        String configPlanId = configurationIds[0];
        Test.startTest();
        ConfigurationController.configWrapper  configData = ConfigurationController.getConfigurationData(recordId,configurationIds,visualPlanIds); 
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
        List<Configuration__c> configurations =  b2cConfigurations;
        List<Id> configurationIds = new List<Id>(new Map<Id, Configuration__c>(configurations).keySet()); 
        String configPlanId = configurationIds[0];
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
        List<Configuration__c> configurations =  b2cConfigurations;
        List<Id> configurationIds = new List<Id>(new Map<Id, Configuration__c>(configurations).keySet()); 
        String sObjectType;
        String contentDocumentId;
        String configId;
        String configPlanId = configurationIds[0];
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
        List<Configuration__c> configurations =  b2cConfigurations;
        List<Id> configurationIds = new List<Id>(new Map<Id, Configuration__c>(configurations).keySet()); 
        String configPlanId = configurationIds[0];
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
        List<Configuration__c> configurations =  b2cConfigurations;
        List<Id> configurationIds = new List<Id>(new Map<Id, Configuration__c>(configurations).keySet()); 
        String configPlanId = configurationIds[0];
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
        List<Configuration__c> configurations =  b2cConfigurations;
        List<Id> configurationIds = new List<Id>(new Map<Id, Configuration__c>(configurations).keySet()); 
        String configPlanId = configurationIds[0];
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
        List<Configuration__c> configurations =  b2cConfigurations;
        List<Id> configurationIds = new List<Id>(new Map<Id, Configuration__c>(configurations).keySet()); 
        String configPlanId = configurationIds[0];
        List<Configuration_Product__c> cfgProducts =  b2cConfigProducts;
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
        List<Configuration__c> configurations =  b2cConfigurations;
        List<Id> configurationIds = new List<Id>(new Map<Id, Configuration__c>(configurations).keySet()); 
        String recordId = b2cOpportunityId;
        String configPlanId = configurationIds[0];

        Test.startTest();
        String visualConfigResult = ConfigurationController.processVisualConfiguration(configPlanId,recordId,visualPricingJSON);
        System.assertNotEquals(null, visualConfigResult, 'Expecting a JSON to be processed');
        System.debug('--- processVisualConfigurationTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- processVisualConfigurationTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getAllConfigurationsTest1(){
        String recordId = b2cOpportunityId;
        String configPlanId = b2cConfigurations[0]?.Id;
        String visualPlanId = b2cConfigurations[0]?.Visual_Id__c;//'ABCDE';
        Test.startTest();
        List<Configuration__c> allConfigurations = ConfigurationController.getAllConfigurations(configPlanId,recordId,visualPlanId);
        System.assertNotEquals(0, allConfigurations.size(), 'Expecting a Configuration to be returned');
        System.debug('--- getAllConfigurationsTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getAllConfigurationsTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getAllConfigurationsTest2(){
        List<Configuration__c> configurations =  b2cConfigurations;
        List<Id> configurationIds = new List<Id>(new Map<Id, Configuration__c>(configurations).keySet()); 
        String recordId = b2cOpportunityId;
        String configPlanId = configurationIds[0];
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
        List<Configuration__c> configurations =  b2cConfigurations;
        List<Id> configurationIds = new List<Id>(new Map<Id, Configuration__c>(configurations).keySet()); 
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
        List<Configuration__c> configurations =  b2cConfigurations;
        List<Id> configurationIds = new List<Id>(new Map<Id, Configuration__c>(configurations).keySet()); 
        String recordId = b2cOpportunityId;
        String configPlanId = configurationIds[0];
        Test.startTest();
        String visualConfigResult = ConfigurationController.processVisualConfiguration(configPlanId,recordId,visualPricingJSON);
        System.assertNotEquals(null, visualConfigResult, 'Expecting Visual Pricing JSON to be processed');
        System.debug('--- processConfigurationVisualTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- processConfigurationVisualTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void processConfigurationSoveliaTest(){
        List<Configuration__c> configurations =  b2cConfigurations;
        List<Id> configurationIds = new List<Id>(new Map<Id, Configuration__c>(configurations).keySet()); 
        String recordId = b2cOpportunityId;
        String configPlanId = configurationIds[0];
        Test.startTest();
        String soveliaConfigResult = ConfigurationController.processSoveliaConfiguration(configPlanId,recordId,soveliaPricingJSON);
        System.assertNotEquals(null, soveliaConfigResult, 'Expecting Sovelia Pricing JSON to be processed');
        System.debug('--- processConfigurationSoveliaTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- processConfigurationSoveliaTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
}