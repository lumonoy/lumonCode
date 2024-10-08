/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 05-10-2024
 * @last modified by  : Henk Reynders
**/
@isTest
public with sharing  class LumonTestInstallationTimes {
    public static void setupInstallationTimes(){
        List<Id> productIds = LumonTestVariables.productIds;
        setupInstallationTimes(productIds);
    }
    public static void setupInstallationTimes(list<Id> productIds) {
        List<Product2> products = LumonTestVariables.products;
        Map<String,List<String>> productGroupMap = LumonTestVariables.productGroupMap;
        List<Id> installationProductIds = LumonTestVariables.installationProductIds;
        List<Installation_Time__c> its = new List<Installation_Time__c>();
        for (Product2 p : products) {
            if (installationProductIds.contains(p.Id)) {
                Installation_Time__c it = new Installation_Time__c();
                it.Hours__c=1;
                it.Product__c=p.Id;
                it.IsActive__c=true;
                its.add(it);
            }
        }
        insert its;
    }
    public static void setupInstallationTimeData(){
        List<Product2> products = LumonTestVariables.products;  
        if(products?.size()>0){
            System.debug('--- LumonTestInstallationTimes - Using existing Products');
        } else {
            LumonTestProducts.setupProductData();
        } 
        setupInstallationTimes();
        List<Installation_Time__c> installationTimes = LumonTestVariables.installationTimes;
        System.debug('--- LumonTestInstallationTimes - Inserted '+installationTimes.size()+' Installation Times'); 
    }  
    @TestSetup
    static void prepareData() {
        Test.startTest();
        List<Product2> products = LumonTestVariables.products; 
        List<PricebookEntry> pricebookEntries = LumonTestVariables.pricebookEntries;
        if(products?.size()>0){
            System.debug('--- LumonTestInstallationTimes - Using existing Products');
        } else {
            LumonTestProducts.setupProductData();
        }
        if(pricebookEntries?.size()>0){
            System.debug('--- LumonTestInstallationTimes - Using existing pricebookEntries');
        } else {
            LumonTestPricebooks.setupPricebookData();
        }
        Test.stopTest();
    }
    @IsTest
    static void setupInstallationTimeDataTest(){
        String testResult;
        Test.startTest();
        Try {
            setupInstallationTimes();
            testResult = 'successfully inserted Installation Times';
            List<Installation_Time__c> installationTimes = LumonTestVariables.installationTimes;
            System.debug('--- LumonTestInstallationTimes - Times: '+installationTimes);
        } catch (exception e){
            testResult = 'Error when inserting Installation Times: '+e.getMessage();
        }
        System.debug('--- LumonTestInstallationTimes - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestInstallationTimes - Queries used: '+LIMITS.getQueries());
        Test.stopTest();
        System.debug('--- LumonTestInstallationTimes - result: '+testResult);
        System.AssertNotEquals(true, testResult.contains('Error'));
    }

}