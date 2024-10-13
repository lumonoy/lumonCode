/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 10-01-2024
 * @last modified by  : Henk Reynders
**/
@IsTest 
public class LumonTestConfigurationOptions { 
    private static List<Product2> products = LumonTestProducts.products;
    private static List<Configuration__c> configPlans = LumonTestConfigurationPlans.configurationPlans; 
    private static List<Configuration_Product__c> configProducts = LumonTestConfigurationProducts.configurationProducts; 
    
    public static List<Configuration_Option__c> configurationOptions {
        get{
            return [ SELECT Id,Name, Configuration_Product__c, Product__c,RVN__c,Quantity__c, 
                            Product__r.QuantityUnitOfMeasure, Product__r.ProductGroup__c,Product__r.ProductCode__c 
                        FROM Configuration_Option__c];
        }
    }
    public static void setupConfigurationOptions() {
        List<Configuration_Option__c> configOptionsToUpsert = new List<Configuration_Option__c>();
        if (configProducts.size()>0){
            for (Configuration_Product__c configProduct : configProducts){
                for (Product2 p : products) {
                    if (p.ProductGroup__c == configProduct.Product__r.ProductGroup__c) {
                        Configuration_Option__c configOption = new Configuration_Option__c();
                        configOption.Name=p.Name;
                        configOption.Configuration_Product__c = configProduct.Id;
                        configOption.Product__c = p.Id;
                        //configOption.UniqueId__c = productCode,// public Integer UniqueId;
                        configOption.Quantity__c = 10; //public Double Amount;  
                        configOptionsToUpsert.add(configOption);   
                    }
                }
            }           
        }
        if (configOptionsToUpsert?.size()>0){
            upsert configOptionsToUpsert;
            System.debug('--- LumonTestConfigurationOptions - Upserted '+configOptionsToUpsert?.size()+' Configuration Options');
            
        }       
        System.debug('--- LumonTestConfigurationOptions - setup Options CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestConfigurationOptions - setup Options SOQL USED: ' + LIMITS.getQueries());
    }

    public static void setupConfigurationOptionData() {
        try {    
            if(configProducts?.size()>0){
                System.debug('--- LumonTestConfigurationOptions - Using existing Configuration Products');
            } else {
                LumonTestConfigurationProducts.setupConfigurationProductData();
            }       
            setupConfigurationOptions();
        } catch (Exception e){
            System.debug('--- LumonTestConfigurationOptions - Exception '+e);
        } 
    }
    @TestSetup
    static void prepareData() {
        Test.startTest();
        Test.stopTest();
    }
    @isTest
    public static void setupConfigurationOptionDataTest(){
        String testResult;
        Test.startTest();
        try {            
            System.debug('--- LumonTestConfigurationProducts - Use '+configPlans.size()+' Plans');
            System.debug('--- LumonTestConfigurationProducts - Use '+configProducts.size()+' Products');
            System.debug('--- LumonTestConfigurationProducts - Use '+products.size()+' Items');
            setupConfigurationOptionData();
            testResult = 'successfully inserted Configuration Options';
        } catch (exception e){
            testResult = 'Error when inserting Configuration Options: '+e.getMessage();
        }
        System.debug('--- LumonTestConfigurationOptions - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestConfigurationOptions - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();       
        System.AssertNotEquals(true, testResult.contains('Error'));
        System.AssertNotEquals(0, configurationOptions.size(), ' Expected Configuration Options to be Inserted');
    }
}