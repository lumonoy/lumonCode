/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 05-30-2024
 * @last modified by  : Henk Reynders
**/
@IsTest 
public class LumonTestConfigurationProducts {
    private static List<Product2> products = LumonTestVariables.products;
    private static List<Configuration__c> configPlans = LumonTestVariables.configPlans;
    private static List<Product2> mainProducts = LumonTestVariables.mainProducts;
    private static Map<String,Id> mainProductMap = LumonTestVariables.mainProductMap;
    public static void setupConfigurationProducts() {       
        if (configPlans?.size()>0) {
            System.debug('--- LumonTestConfigurationProducts - Using existing Configurations');
        } else {
            System.debug('--- LumonTestConfigurationProducts - Setup new Configurations');
            LumonTestConfigurations.setupConfigurationData();
            System.debug('--- LumonTestConfigurationProducts - ConfigIds: '+LumonTestVariables.configPlanIds);
        }
        setupConfigurationProducts(configPlans);
    }
    public static void setupConfigurationProducts(List<Configuration__c> configPlans) {
        List<Configuration_Product__c> configProductsToUpsert = new List<Configuration_Product__c>();
        List<String> visualProductGroups = LumonTestVariables.visualProductGroups;
        List<String> soveliaProductGroups = LumonTestVariables.soveliaProductGroups;
        List<String> servicesProducts = LumonTestVariables.servicesProducts;
        List<String> extraSalesProducts = LumonTestVariables.extraSalesProducts;
        List<String> sparepartsProducts = LumonTestVariables.sparepartsProducts;
        List<Configuration__c> plans = LumonTestVariables.configPlans;
        if (plans?.size()>0) {
            for (Configuration__c configPlan : plans){
                System.debug('--- LumonTestConfigurationProducts - Setup Products for Configuration Plan: '+configPlan?.Id);
                Id configurationId = configPlan?.Id;
                String planType = configPlan?.plan_Type__c;
                System.debug('--- LumonTestConfigurationProducts - Plan Type: '+planType);
                if (planType == 'Visual') {
                    setupVisualConfigurationProducts(configPlan);
                } else if (planType == 'Sovelia') {
                    for (Product2 mainProduct : mainProducts) {
                        String productGroup = mainProduct.Product_Group__c;
                        if (soveliaProductGroups.contains(productGroup)){
                            Id productId = mainProductMap.get(productGroup);
                            Configuration_Product__c configProduct = new Configuration_Product__c();
                            configProduct.Name=productGroup; //public String name; // Name of the Product Model
                            configProduct.Configuration__c = configurationId; // Parent Configuration
                            configProduct.Quantity__c = 1; // Amount must be 1 for each Product in a configuration
                            configProduct.Product_Group__c = productGroup;
                            configProduct.Product__c = productId;
                            configProduct.Installer_Message__c = '<p>Testing Installer Message for Sovelia Product</p>';
                            configProduct.Features_Confirmed__c = true;//public Boolean hasFeaturesBeenConfirmed;
                            configProduct.Measurements_Verified__c = true;// public Boolean hasMeasurementsBeenVerified;
                            //configProduct.Sovelia_Product_Id__c = productId;//public String Id; // Product Code of Product Model
                            configProductsToUpsert.add(configProduct);
                        }
                    }
                } else if (planType == 'Services') {
                    for (Product2 mainProduct : mainProducts) {
                        String productGroup = mainProduct.Product_Group__c;
                        if (servicesProducts.contains(productGroup)){
                            Id productId = mainProductMap.get(productGroup);
                            Configuration_Product__c configProduct = new Configuration_Product__c();
                            configProduct.Name=productGroup; //public String name; // Name of the Product Model
                            configProduct.Configuration__c = configurationId; // Parent Configuration
                            configProduct.Quantity__c = 1; // Amount must be 1 for each Product in a configuration
                            configProduct.Product_Group__c = productGroup;
                            configProduct.Product__c = productId;
                            //configProduct.Sovelia_Product_Id__c = productId;//public String Id; // Product Code of Product Model
                            configProductsToUpsert.add(configProduct);
                        }
                    }
                } else if (planType == 'Sales') {
                    for (Product2 mainProduct : mainProducts) {
                        String productGroup = mainProduct.Product_Group__c;
                        if (extraSalesProducts.contains(productGroup)){
                            Id productId = mainProductMap.get(productGroup);
                            Configuration_Product__c configProduct = new Configuration_Product__c();
                            configProduct.Name=productGroup; //public String name; // Name of the Product Model
                            configProduct.Configuration__c = configurationId; // Parent Configuration
                            configProduct.Quantity__c = 1; // Amount must be 1 for each Product in a configuration
                            configProduct.Product_Group__c = productGroup;
                            configProduct.Product__c = productId;
                            //configProduct.Sovelia_Product_Id__c = productId;//public String Id; // Product Code of Product Model
                            configProductsToUpsert.add(configProduct);
                        }
                    }
                } else if (planType == 'Spares') {
                    for (Product2 mainProduct : mainProducts) {
                        String productGroup = mainProduct.Product_Group__c;
                        if (sparepartsProducts.contains(productGroup)){
                            Id productId = mainProductMap.get(productGroup);
                            Configuration_Product__c configProduct = new Configuration_Product__c();
                            configProduct.Name=productGroup; //public String name; // Name of the Product Model
                            configProduct.Configuration__c = configurationId; // Parent Configuration
                            configProduct.Quantity__c = 1; // Amount must be 1 for each Product in a configuration
                            configProduct.Product_Group__c = productGroup;
                            configProduct.Product__c = productId;
                            //configProduct.Sovelia_Product_Id__c = productId;//public String Id; // Product Code of Product Model
                            configProductsToUpsert.add(configProduct);
                        }
                    }
                } 
            }  
            if (configProductsToUpsert?.size()>0){
                System.debug('--- LumonTestConfigurationProducts - prepared '+configProductsToUpsert?.size()+' Config Products to Upsert');
                upsert configProductsToUpsert;
            } 
        }    
        System.debug('--- LumonTestConfigurationProducts - setup Configuration Products CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestConfigurationProducts - setup Configuration Products Queries used: '+LIMITS.getQueries());
    }
    public static void setupVisualConfigurationProducts(Configuration__c configPlan) {
        List<Configuration_Product__c> configProductsToUpsert = new List<Configuration_Product__c>();
        List<String> visualProductGroups = LumonTestVariables.visualProductGroups;
        System.debug('--- LumonTestConfigurationProducts - Setup Visual Products for Configuration Plan: '+configPlan?.Id);
        Id configurationId = configPlan?.Id;
        String planType = configPlan?.plan_Type__c;
        System.debug('--- LumonTestConfigurationProducts - Plan Type: '+planType);
        if (planType == 'Visual') {
            for (Product2 mainProduct : mainProducts) {
                String productGroup = mainProduct.Product_Group__c;
                System.debug('--- LumonTestConfigurations - Product Group: '+productGroup);
                if (visualProductGroups.contains(productGroup)){
                    Id productId = mainProductMap.get(productGroup);
                    Configuration_Product__c configProduct = new Configuration_Product__c();
                    configProduct.Name=productGroup; //public String name; // Name of the Product Model
                    configProduct.Configuration__c = configurationId; // Parent Configuration
                    configProduct.Quantity__c = 1; // Amount must be 1 for each Product in a configuration
                    configProduct.Product_Group__c = productGroup;
                    configProduct.Product__c = productId;
                    configProduct.Installer_Message__c = '<p>Testing Installer Message for Visual Product</p>';
                    configProduct.Features_Confirmed__c = true;//public Boolean hasFeaturesBeenConfirmed;
                    configProduct.Measurements_Verified__c = true;// public Boolean hasMeasurementsBeenVerified;
                    //configProduct.Visual_Product_Id__c = productId;//public String Id; // Product Code of Product Model
                    configProduct.Inspection_Code__c = 0;//public Integer productInspectCode;
                    //configProduct.Product_Length__c = 2.5 //public Double productLength;
                    configProductsToUpsert.add(configProduct);
                }
            }
        } 
        if (configProductsToUpsert?.size()>0){
            System.debug('--- LumonTestConfigurationProducts - prepared '+configProductsToUpsert?.size()+' Config Products to Upsert');
            upsert configProductsToUpsert;
        }   
        System.debug('--- LumonTestConfigurationProducts - setup Visual Configuration Products CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestConfigurationProducts - setup Visual Configuration Products Queries used: '+LIMITS.getQueries());
    }
    public static void setupSoveliaConfigurationProducts(Configuration__c configPlan) {
        List<Configuration_Product__c> configProductsToUpsert = new List<Configuration_Product__c>();
        List<String> soveliaProductGroups = LumonTestVariables.soveliaProductGroups;
        List<Product2> soveliaProducts = LumonTestVariables.soveliaProducts;

        System.debug('--- LumonTestConfigurationProducts - Setup Sovelia Products for Configuration Plan: '+configPlan?.Id);
        Id configurationId = configPlan?.Id;
        String planType = configPlan?.plan_Type__c;
        System.debug('--- LumonTestConfigurationProducts - Plan Type: '+planType);
        if (planType == 'Sovelia') {
            for (Product2 soveliaProduct : soveliaProducts) {
                String productGroup = soveliaProduct.Product_Group__c;
                System.debug('--- LumonTestConfigurations - Product Group: '+productGroup);
                if (soveliaProductGroups.contains(productGroup)){
                    Id productId = mainProductMap.get(productGroup);
                    Configuration_Product__c configProduct = new Configuration_Product__c();
                    configProduct.Name=productGroup; //public String name; // Name of the Product Model
                    configProduct.Configuration__c = configurationId; // Parent Configuration
                    configProduct.Quantity__c = 1; // Amount must be 1 for each Product in a configuration
                    configProduct.Product_Group__c = productGroup;
                    configProduct.Product__c = productId;
                    configProduct.Installer_Message__c = '<p>Testing Installer Message for Visual Product</p>';
                    configProduct.Features_Confirmed__c = true;//public Boolean hasFeaturesBeenConfirmed;
                    configProduct.Measurements_Verified__c = true;// public Boolean hasMeasurementsBeenVerified;
                    //configProduct.Visual_Product_Id__c = productId;//public String Id; // Product Code of Product Model
                    configProduct.Inspection_Code__c = 0;//public Integer productInspectCode;
                    //configProduct.Product_Length__c = 2.5 //public Double productLength;
                    configProductsToUpsert.add(configProduct);
                }
            }
        } 
        if (configProductsToUpsert?.size()>0){
            System.debug('--- LumonTestConfigurationProducts - prepared '+configProductsToUpsert?.size()+' Config Products to Upsert');
            upsert configProductsToUpsert;
        }   
        System.debug('--- LumonTestConfigurationProducts - setup Visual Configuration Products CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestConfigurationProducts - setup Visual Configuration Products Queries used: '+LIMITS.getQueries());
    }
    public static void setupConfigurationProductsB2C() {
        Configuration__c configPlan = LumonTestvariables.b2cConfiguration;
        setupVisualConfigurationProducts(configPlan);
    }
    public static void setupConfigurationProductData() {
        try {           
            setupConfigurationProducts();
        } catch (Exception e){
            System.debug('--- LumonTestConfigurationProducts - Exception '+e);
        } 
    }
    @TestSetup
    static void prepareData() {
        Test.startTest();
        if(products?.size()>0){
            System.debug('--- LumonTestConfigurationProducts - Using existing Products');
        } else {
            LumonTestProducts.setupProductData();
        }
        if(configPlans?.size()>0){
            System.debug('--- LumonTestConfigurationProducts - Using existing Configuration Plans');
        } else {
            LumonTestConfigurations.setupConfigurationData();
        }
        Test.stopTest();
    }
    @isTest
    public static void setupConfigurationProductDataTest(){
        String testResult;
        Test.startTest();
        try {
            setupConfigurationProductData();
            testResult = 'successfully inserted Configuration Products';
        } catch (exception e){
            testResult = 'Error when inserting Configuration Products: '+e.getMessage();
        }
        System.debug('--- LumonTestConfigurationProducts - Result: '+testResult);
        System.debug('--- LumonTestConfigurationProducts - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestConfigurationProducts - Queries used: '+LIMITS.getQueries());
        Test.stopTest();       
        System.AssertNotEquals(true, testResult.contains('Error'));
        
        List<Configuration_Product__c> configProducts = LumonTestVariables.configProducts;
        System.debug('--- LumonTestConfigurationProducts - Products: '+configProducts);
        System.AssertNotEquals(0, configProducts?.size(), ' Expected Configuration Products to be Inserted');
    }
}