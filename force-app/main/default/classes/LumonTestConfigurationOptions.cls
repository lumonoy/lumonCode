/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 05-15-2024
 * @last modified by  : Henk Reynders
**/
@IsTest 
public class LumonTestConfigurationOptions { 
    private static List<Product2> products = LumonTestVariables.products;
    private static List<Configuration__c> configPlans = LumonTestVariables.configPlans; 
    private static List<Configuration_Product__c> configProducts = LumonTestVariables.configProducts; 
    private static List<Configuration_Option__c> configOptions = LumonTestVariables.configOptions;  
    public static void setupConfigurationOptions() {
        if (configProducts.size()>0){
            System.debug('--- LumonTestConfigurationProducts - Using existing Test Configuration Products');
        } else {
            LumonTestConfigurationProducts.setupConfigurationProductData();
        }
        for (Configuration_Product__c configProduct : configProducts){
            setupConfigurationOptions(configProduct);
        }
        if (configProducts.size()>0){
            System.debug('No Parent Record existing');
            return;
        }
    }
    public static void setupConfigurationOptions(Configuration_Product__c configProduct) {
        List<Configuration_Option__c> configOptionsToUpsert = new List<Configuration_Option__c>();
        List<Product2 >configurableProducts = LumonTestVariables.configurableProducts;
        String productGroup = configProduct.Product_Group__c;
        for (Product2 configurableProduct : configurableProducts) {
            Id configurationProductId = configProduct.Id;
            Id productId = configurableProduct.Id;
            String productName = configurableProduct.Name;     
            String productCode = configurableProduct.ProductCode;
            String salesCode = configurableProduct.Sales_Code__c;
            Configuration_Option__c configOption = new Configuration_Option__c(
                                                    Name=productName,
                                                    Configuration_Product__c = configurationProductId,
                                                    //co.Local_Supplier__c = FALSE; //public Boolean LocalSupplier;
                                                    //co.Parameter_code__c = 'param1';// public String ParameterCode;
                                                    Product_Code__c = productCode,// public String SalesCode;
                                                    Sales_Code__c =  salesCode,// public String SalesCode;
                                                    Unique_Id__c = productCode,// public Integer UniqueId;
                                                    Quantity__c = 10, //public Double Amount;
                                                    Unit_Of_Measure__c = 'pcs'//public String Unit
            );
            configOptionsToUpsert.add(configOption);   
        }
        if (configOptionsToUpsert?.size()>0){
            upsert configOptionsToUpsert;
            System.debug('--- LumonTestConfigurationOptions - Upserted '+configOptionsToUpsert?.size()+' Configuration Options');
            
        }       
        System.debug('--- LumonTestConfigurationOptions - setup Options CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestConfigurationOptions - setup Options Queries used: '+LIMITS.getQueries());
    }

    public static void setupConfigurationOptionData() {
        try {           
            setupConfigurationOptions();
        } catch (Exception e){
            System.debug('--- LumonTestConfigurationOptions - Exception '+e);
        } 
    }
    @TestSetup
    static void prepareData() {
        Test.startTest();
        if(products?.size()>0){
            System.debug('--- LumonTestConfigurationOptions - Using existing Products');
        } else {
            LumonTestProducts.setupProductData();
        }
        if(configPlans?.size()>0){
            System.debug('--- LumonTestConfigurationOptions - Using existing Configuration Plans');
        } else {
            LumonTestConfigurations.setupConfigurationData();
        }
        if(configProducts?.size()>0){
            System.debug('--- LumonTestConfigurationOptions - Using existing Configuration Products');
        } else {
            LumonTestConfigurationProducts.setupConfigurationProductData();
        }
        Test.stopTest();
    }
    @isTest
    public static void setupConfigurationOptionDataTest(){
        String testResult;
        Test.startTest();
        try {
            setupConfigurationOptionData();
            testResult = 'successfully inserted Configuration Options';
        } catch (exception e){
            testResult = 'Error when inserting Configuration Options: '+e.getMessage();
        }
        System.debug('--- LumonTestConfigurationOptions - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestConfigurationOptions - Queries used: '+LIMITS.getQueries());
        Test.stopTest();       
        System.AssertNotEquals(true, testResult.contains('Error'));
        List<Configuration__c> configPlans = LumonTestVariables.configPlans;
        System.AssertNotEquals(0, configPlans.size(), ' Expected Configuration Plans to be Inserted');
        List<Configuration_Product__c> configProducts = LumonTestVariables.configProducts;
        System.AssertNotEquals(0, configProducts.size(), ' Expected Configuration Products to be Inserted');
        List<Configuration_Option__c> configOptions = LumonTestVariables.configOptions;
        System.AssertNotEquals(0, configOptions.size(), ' Expected Configuration Options to be Inserted');
    }
}