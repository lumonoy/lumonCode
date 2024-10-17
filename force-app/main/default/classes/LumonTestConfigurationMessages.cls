/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 10-01-2024
 * @last modified by  : Henk Reynders
**/
@IsTest 
public class LumonTestConfigurationMessages { 
	private static List<Product2> products = LumonTestVariables.products;
    private static List<Configuration__c> configPlans = LumonTestConfigurationPlans.configurationPlans; 
    private static List<Configuration_Product__c> configProducts = LumonTestConfigurationProducts.configurationProducts; 
    private static List<Configuration_Option__c> configOptions = LumonTestConfigurationOptions.configurationOptions;  
    @TestVisible public static List<Configuration_Message__c> configurationMessages {
        get{
            return [ SELECT Id,Name, Configuration_Product__c, MessageKey__c, SideNumber__c FROM Configuration_Message__c];
        }
    } 
    @TestVisible public static List<Id> configMessageIds {
        get{
            return new List<Id>(new Map<Id, Configuration_Message__c>(configurationMessages).keySet()); 
        } 
    } 
    public static void setupConfigurationMessages() {
        if (configProducts.size()>0){
            System.debug('--- LumonTestConfigurationMessages - Using existing Test Configuration Products');
        } else {
            System.debug('--- LumonTestConfigurationMessages - Insert Configuration Products');
            LumonTestConfigurationProducts.setupConfigurationProductData();
        }
        for (Configuration_Product__c configProduct : configProducts){
            setupConfigurationMessages(configProduct);
        }
        if (configProducts.size()>0){
            System.debug('No Configuration Products to Use as Parent');
            return;
        }
    }
    public static void setupConfigurationMessages(Configuration_Product__c configProduct) {
        List<Configuration_Message__c> configMessagesToUpsert = new List<Configuration_Message__c>();
        List<Product2 >configurableProducts = LumonTestVariables.configurableProducts;
        String productGroup = configProduct.Product_Group__c;
        for (Product2 configurableProduct : configurableProducts) {
            Configuration_Message__c configMessage = new Configuration_Message__c(
                                            Name='Test Config Message '+configurableProduct.Name,
                                            Configuration_Product__c = configurableProduct.Id,
                                            MessageKey__c = 'E1-1-1',
                                            SideNumber__c = 1);
            Configuration_Message__c b2cConfigMesssage2 = new Configuration_Message__c(
                                            Name='Test Config Message 2',
                                            Configuration_Product__c = configurableProduct.Id,
                                            MessageKey__c = '1-2-1',
                                            SideNumber__c = 2);
            configMessagesToUpsert.add(configMessage);   
        }
        if (configMessagesToUpsert?.size()>0){
                upsert configMessagesToUpsert;
        }       
        System.debug('--- LumonTestConfigurationMessages - setup Messages CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestConfigurationMessages - setup Messages SOQL USED: ' + LIMITS.getQueries());
    }

    public static void setupConfigurationMessageData() {
        if(products?.size()>0){
            System.debug('--- LumonTestConfigurationMessages - Using existing Products');
        } else {
            LumonTestProducts.setupProductData();
        }
        if(configPlans?.size()>0){
            System.debug('--- LumonTestConfigurationMessages - Using existing Configuration Plans');
        } else {
            LumonTestConfigurationPlans.setupConfigurationPlanData();
        }
        if(configProducts?.size()>0){
            System.debug('--- LumonTestConfigurationMessages - Using existing Configuration Products');
        } else {
            LumonTestConfigurationProducts.setupConfigurationProductData();
        }
        try {           
            setupConfigurationMessages();
        } catch (Exception e){
            System.debug('--- LumonTestConfigurationMessages - Exception '+e);
        } 
    }
    @TestSetup
    static void prepareData() {      
        Test.startTest();
        
        Test.stopTest();
    }
    @isTest
    public static void setupConfigurationMessageDataTest(){
        String testResult;
        Test.startTest();
        try {
            setupConfigurationMessageData();
            testResult = 'successfully inserted Configuration Messages';
        } catch (exception e){
            testResult = 'Error when inserting Configuration Messages: '+e.getMessage();
        }
        System.debug('--- LumonTestConfigurationMessages - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestConfigurationMessages - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();       
        System.AssertNotEquals(true, testResult.contains('Error'));
    }
}