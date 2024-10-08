/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 05-12-2024
 * @last modified by  : Henk Reynders
**/
@isTest
public with sharing class LumonTestData {
    public static void setupLumonTestData() {
        try {     
            LumonTestUsers.setupUserData();   
            LumonTestLocations.setupLocationData();   
            LumonTestProductSettings.setupProductSettings();
            LumonTestProducts.setupProductData();
            LumonTestBasePrices.setupBasePriceData();
            LumonTestInstallationTimes.setupInstallationTimeData();
            LumonTestProductionTimes.setupProductionTimeData();
            LumonTestPriceMultipliers.setupPriceMultiplierData();
            LumonTestPricebooks.setupPricebookData();
            LumonTestAccounts.setupAccountData();
            LumonTestOpportunities.setupOpportunityData();
            LumonTestConfigurations.setupConfigurationData();
            LumonTestConfigurationProducts.setupConfigurationProductData();
            LumonTestConfigurationOptions.setupConfigurationOptionData();
            LumonTestQuoteLines.setupQuoteLineData();
            LumonTestReclamations.setupReclamationData();
        }catch (Exception e){
            System.debug('--- LumonTestData - Exception '+e);
        } 
    }
    @isTest
    public static void setupLumonDataTest(){
        String testResult;
        Test.startTest();
        try {
            setupLumonTestData();
            testResult = 'successfully inserted Test Data';
        } catch (exception e){
            testResult = 'Error when inserting Test Data: '+e.getMessage();
        }
        System.debug('--- LumonTestData - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestData - Queries used: '+LIMITS.getQueries());
        Test.stopTest();       
        System.AssertNotEquals(true, testResult.contains('Error'));
    }
}