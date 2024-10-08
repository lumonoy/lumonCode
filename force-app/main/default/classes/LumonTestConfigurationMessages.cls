/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 06-02-2024
 * @last modified by  : Henk Reynders
**/
@IsTest 
public class LumonTestConfigurationMessages { 
	private static List<Product2> products = LumonTestVariables.products;
    private static List<Configuration__c> configPlans = LumonTestVariables.configPlans; 
    private static List<Configuration_Product__c> configProducts = LumonTestVariables.configProducts; 
    private static List<Configuration_Option__c> configOptions = LumonTestVariables.configOptions;  
    private static List<Configuration_Message__c> configMessages = LumonTestVariables.configMessages;   
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
                                            Message_Key__c = 'E1-1-1',
                                            Space_Side_Number__c = 1);
            Configuration_Message__c b2cConfigMesssage2 = new Configuration_Message__c(
                                            Name='Test Config Message 2',
                                            Configuration_Product__c = configurableProduct.Id,
                                            Message_Key__c = '1-2-1',
                                            Space_Side_Number__c = 2);
            configMessagesToUpsert.add(configMessage);   
        }
        if (configMessagesToUpsert?.size()>0){
                upsert configMessagesToUpsert;
        }       
        System.debug('--- LumonTestConfigurationMessages - setup Messages CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestConfigurationMessages - setup Messages Queries used: '+LIMITS.getQueries());
    }

    public static void setupConfigurationMessageData() {
        try {           
            setupConfigurationMessages();
        } catch (Exception e){
            System.debug('--- LumonTestConfigurationMessages - Exception '+e);
        } 
    }
    @TestSetup
    static void prepareData() {      
        Test.startTest();
        if(products?.size()>0){
            System.debug('--- LumonTestConfigurationMessages - Using existing Products');
        } else {
            LumonTestProducts.setupProductData();
        }
        if(configPlans?.size()>0){
            System.debug('--- LumonTestConfigurationMessages - Using existing Configuration Plans');
        } else {
            LumonTestConfigurations.setupConfigurationData();
        }
        if(configProducts?.size()>0){
            System.debug('--- LumonTestConfigurationMessages - Using existing Configuration Products');
        } else {
            LumonTestConfigurationProducts.setupConfigurationProductData();
        }
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
        System.debug('--- LumonTestConfigurationMessages - Queries used: '+LIMITS.getQueries());
        Test.stopTest();       
        System.AssertNotEquals(true, testResult.contains('Error'));
        List<Configuration__c> configPlans = LumonTestVariables.configPlans;
        System.AssertNotEquals(0, configPlans.size(), ' Expected Configuration Plans to be Inserted');
        List<Configuration_Product__c> configProducts = LumonTestVariables.configProducts;
        System.AssertNotEquals(0, configProducts.size(), ' Expected Configuration Products to be Inserted');
        List<Configuration_Message__c> configMessages = LumonTestVariables.configMessages;
        System.AssertNotEquals(0, configMessages.size(), ' Expected Configuration Messages to be Inserted');
    }
}