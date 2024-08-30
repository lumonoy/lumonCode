/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-05-2023
 * @last modified by  : Henk Reynders
**/
@IsTest
public with sharing class ProductionTimeControllerTest {
    @TestSetup
    static void PrepareData(){   
        Test.startTest();
        LumonTestDataFactory.setupProducts();
        LumonTestDataFactory.setupProductionTimes();
        Test.stopTest();
    }
    private static List<product2> products = [SELECT Id, Name, ProductCode, Cost_Type__c, Product_Group__c, Product_Model__c, Sales_Code__c, isActive FROM Product2];
    private static List<Production_Time__c> productionTimes = LumonTestDataFactory.productionTimes;
    @IsTest
    static void getProductionTimesTest(){
        Boolean isActive = true;
        System.debug('--- getProductionTimesTest - isActive: '+isActive); 
        Test.startTest();
        List<Production_Time__c> factoryTimes = ProductionTimeController.getProductionTimes(isActive);
        System.assertNotEquals(0, factoryTimes.size(), 'Expecting atleast 1 Production Time to be returned');
        System.debug('--- getProductionTimesTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getProductionTimesTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getProductionTimeMapTest(){
        Boolean isActive = true;
        System.debug('--- getProductionTimeMapTest - isActive: '+isActive); 
        Test.startTest();
        Map<String,Production_Time__c> productCode2factoryTime = ProductionTimeController.getProductionTimeMap(isActive);
        System.assertNotEquals(0, productCode2factoryTime.values().size(), 'Expecting atleast 1 Installation Time to be returned');
        System.debug('--- getProductionTimeMapTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getProductionTimeMapTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }

}