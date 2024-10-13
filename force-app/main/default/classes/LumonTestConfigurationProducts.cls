/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 10-01-2024
 * @last modified by  : Henk Reynders
**/
@IsTest 
public class LumonTestConfigurationProducts {
    @TestVisible private static List<Product2> products = LumonTestProducts.products;
    @TestVisible private static List<Product2> mainProducts = LumonTestProducts.mainProducts;
    @TestVisible private static List<Configuration__c> configPlans = LumonTestConfigurationPlans.configurationPlans;
    
    @TestVisible private static List<String> visualProductGroups = LumonTestData.visualProducts;
    @TestVisible private static List<String> soveliaProductGroups = LumonTestData.soveliaProducts;
    @TestVisible private static List<String> servicesProducts = LumonTestData.servicesProducts;
    @TestVisible private static List<String> extraSalesProducts = LumonTestData.extraSalesProducts;
    @TestVisible private static List<String> sparepartsProducts = LumonTestData.sparepartsProducts;

    @TestVisible public static List<Configuration_Product__c> configurationProducts {
        get{
            return [ SELECT Id,Name, Configuration__c, Product__c,Quantity__c, 
                    Product__r.ProductGroup__c, Product__r.ProductCode__c,Product__r.QuantityUnitOfMeasure  
                    FROM Configuration_Product__c];
        }
    } 
    @TestVisible public static List<Id> configProductIds {
        get{
            return new List<Id>(new Map<Id, Configuration_Product__c>(configurationProducts).keySet()); 
        } 
    } 
    
    public static void setupConfigurationProducts() {
        List<Configuration_Product__c> configProductsToUpsert = new List<Configuration_Product__c>();
        if (configPlans?.size()>0) {
            for (Configuration__c configPlan : configPlans){
                System.debug('--- LumonTestConfigurationProducts - Configuration Plan : '+configPlan.Name);
                if (mainProducts?.size()>0) {
                    for (Product2 p : mainProducts) {
                        System.debug('--- LumonTestConfigurationProducts - Product : '+p.Name);
                        Configuration_Product__c configProduct = new Configuration_Product__c();
                        configProduct.Name=p.ProductGroup__c; //public String name; // Name of the Product Model
                        configProduct.Configuration__c = configPlan.Id; // Parent Configuration
                        configProduct.Product__c = p.Id;
                        configProduct.Quantity__c = 1; // Amount must be 1 for each Product in a configuration
                        //configProduct.ProductGroup__c = product.ProductGroup__c;
                        //configProduct.ProductLength__c = 2.5 //public Double productLength;
                        //configProduct.ProductWeight__c = 2.5; 
                        //configProduct.NumberOfPanels__c = 2.5;
                        //configProduct.GlassSurface__c = 2.5;
                        //configProduct.BlindSurface__c = 2.5;
                        switch on configPlan.planType__c {
                            when 'Visual' {
                            //configProduct.Features_Confirmed__c = true;//public Boolean hasFeaturesBeenConfirmed;
                            //configProduct.Measurements_Verified__c = true;// public Boolean hasMeasurementsBeenVerified;
                            //configProduct.Visual_Product_Id__c = productId;//public String Id; // Product Code of Product Model
                            }
                            when 'Sovelia' {

                            } when else {

                            }
                        }
                        System.debug('--- LumonTestConfigurationProducts - Configuration Product to Add: '+configProduct);
                        configProductsToUpsert.add(configProduct);
                    }
                } else {
                    System.debug('--- LumonTestConfigurationProducts - No Product(s) to Add!');
                }
            }
        }
        if (configProductsToUpsert?.size()>0){
            System.debug('--- LumonTestConfigurationProducts - prepared '+configProductsToUpsert?.size()+' Config Products to Upsert');
            upsert configProductsToUpsert;
        }   
        System.debug('--- LumonTestConfigurationProducts - setup Configuration Products CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestConfigurationProducts - setup Configuration Products SOQL USED: ' + LIMITS.getQueries());
    }

    public static void setupConfigurationProductData() {
        try {     
            if(mainProducts?.size()>0){
                System.debug('--- LumonTestConfigurationProducts - Using existing Products');
            } else {
                LumonTestProducts.setupProductData();
            }
            if(configPlans?.size()>0){
                System.debug('--- LumonTestConfigurationProducts - Using existing Configuration Plans');
            } else {
                LumonTestConfigurationPlans.setupConfigurationPlanData();
            }      
            setupConfigurationProducts();
        }catch (Exception e){
            System.debug('--- LumonTestConfigurationProducts - Exception '+e);
        } 
    }
    @TestSetup
    static void prepareData() {
        Test.startTest();
        Test.stopTest();
    }
    @isTest
    public static void setupConfigurationProductDataTest(){
        String testResult;
        Test.startTest();
        try {
            System.debug('--- LumonTestConfigurationProducts - Use '+configPlans.size()+' Plans');
            System.debug('--- LumonTestConfigurationProducts - Use '+mainProducts.size()+' Products');
            setupConfigurationProductData();
            testResult = 'successfully inserted Configuration Products';
        } catch (exception e){
            testResult = 'Error when inserting Configuration Products: '+e.getMessage();
        }
        System.debug('--- LumonTestConfigurationProducts - Result: '+testResult);
        System.debug('--- LumonTestConfigurationProducts - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestConfigurationProducts - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();       
        System.AssertNotEquals(true, testResult.contains('Error'));
        System.debug('--- LumonTestConfigurationProducts - '+configurationProducts?.size()+' Products Created');
        System.AssertNotEquals(0, configurationProducts?.size(), ' Expected Configuration Products to be Inserted');
    }
}