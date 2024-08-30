/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-02-2023
 * @last modified by  : Henk Reynders
**/
@IsTest
public with sharing class InstallationTimeControllerTest {
    @TestSetup
    static void PrepareData(){
        Test.startTest();
        //LumonTestProducts.setupTestProducts();
        LumonTestProducts.setupProducts('LG');
        LumonTestDataFactory.setupInstallationTimes();
        Test.stopTest();
    }
    private static List<product2> products = LumonTestProducts.testProducts;
    private static List<Installation_Time__c> installationTimes = LumonTestDataFactory.installationTimes;
    @IsTest
    static void getInstallationTimesTest(){
        Boolean isActive = true;
        System.debug('--- getInstallationTimesTest - isActive: '+isActive);
        System.debug('--- getInstallationTimesTest - products: '+products); 
        Test.startTest();
        List<Installation_Time__c> installTimes = InstallationTimeController.getInstallationTimes(isActive);
        System.assertNotEquals(0, installTimes.size(), 'Expecting atleast 1 Installation Time to be returned');
        System.debug('--- getInstallationTimesTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getInstallationTimesTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getInstallationTimeMapTest(){
        Boolean isActive = true;
        System.debug('--- getInstallationTimeMapTest - isActive: '+isActive); 
        Test.startTest();
        Map<String,Installation_Time__c> productCode2installTime = InstallationTimeController.getInstallationTimeMap(isActive);
        System.assertNotEquals(0, productCode2installTime.values().size(), 'Expecting atleast 1 Installation Time to be returned');
        System.debug('--- getInstallationTimeMapTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getInstallationTimeMapTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getInstallationTimeProductsTest(){
        Boolean isActive = true;
        System.debug('--- getInstallationTimeProductsTest - isActive: '+isActive); 
        Test.startTest();
        List<Product2> installTimeProducts = InstallationTimeController.getInstallationTimeProducts(isActive);
        System.assertNotEquals(0, installTimeProducts.size(), 'Expecting atleast 1 Installation Time Products to be returned');
        System.debug('--- getInstallationTimeProductsTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getInstallationTimeProductsTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getInstallationTimeProductMapTest(){
        Product2 p4 = new Product2(Name='Test Installation Times Product 4', IsActive=True,ProductCode='LG-Time3',Sales_Code__c='Time3',Cost_Category__c='Manhours',Cost_Type__c='askuormitu');
        Product2 p5 = new Product2(Name='Test Installation Times Product 5', IsActive=True,ProductCode='LG-Time4',Sales_Code__c='Time4',Cost_Category__c='Manhours',Cost_Type__c='askuormitu');
        Product2 p6 = new Product2(Name='Test Installation Times Product 6', IsActive=True,ProductCode='LG-Time5',QuantityUnitOfMeasure='h',Sales_Code__c='Time5');
        insert new List<Product2> {p4,p5,p6};
        Boolean isActive = true;
        System.debug('--- getInstallationTimeProductMapTest - isActive: '+isActive); 
        Test.startTest();
        Map<String,Product2> productCode2installProduct = InstallationTimeController.getInstallationTimeProductMap(isActive);
        System.assertNotEquals(0, productCode2installProduct.values().size(), 'Expecting atleast 1 Installation Time Products to be returned');
        System.debug('--- getInstallationTimeProductMapTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getInstallationTimeProductMapTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
}