/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 10-01-2024
 * @last modified by  : Henk Reynders
**/
@IsTest(isParallel=false)
public with sharing class LumonTestPricebooks { 
    public class CustomException extends Exception {}  
    @TestVisible private static Id pricebookId =  Test.getStandardPricebookId();
    @TestVisible public static List<PricebookEntry> pricebookEntries{
        get{
            return [SELECT Id,Name,Product2Id,IsActive,Product2.ProductCode, Product2.Product_Group__c, Product2.Sales_Code__c FROM PricebookEntry WHERE Pricebook2Id =: pricebookId];
        }
    }
    
    /**
    * @description Pricebook Entries need to exist for all products that are in use 
    * without sales Process in Salesforce at minimum Entries need to exist for Main Produts
    * @author Henk Reynders | 09-30-2024 
    **/
    public static void setupPricebookEntries(){
        Id testPricebookId = Test.getStandardPricebookId();
        List<PricebookEntry> pricebookEntries = new List<PricebookEntry>();
        Integer unitPrice;
        Integer basePrice;
        for (Id productId : LumonTestProducts.mainProductIds) {
            System.debug('--- LumonTestPricebooks - adding Price for Main Product: '+productId);
            unitPrice = 0;
            basePrice = 0;
            PricebookEntry pbe = new PricebookEntry(Pricebook2Id=testPricebookId,
                                                    Product2Id=productId,
                                                    UnitPrice=unitPrice,
                                                    IsActive=True,
                                                    CurrencyIsoCode = 'EUR');
            pricebookEntries.add (pbe);
        }
        for (Id productId : LumonTestProducts.productIds) {
            System.debug('--- LumonTestPricebooks - adding Price for Product (Option): '+productId);
            unitPrice = 1;
            basePrice = 10;
            PricebookEntry pbe = new PricebookEntry(Pricebook2Id=testPricebookId,
                                                    Product2Id=productId,
                                                    UnitPrice=unitPrice,
                                                    IsActive=True,
                                                    CurrencyIsoCode = 'EUR');
            pricebookEntries.add (pbe);
        }
        if( pricebookEntries.size()>0) {
            insert pricebookEntries;
        }
        System.debug('--- Created '+pricebookEntries.size()+ ' Pricebook Entries');
    }
    public static void setupPricebookData(){ 
        setupPricebookEntries();
        System.debug('--- LumonTestPricebooks - Setup Pricebooks SOQL USED: ' + LIMITS.getQueries());
    }  
    @TestSetup
    static void prepareData() {
        Test.startTest();
        List<Product2> products = LumonTestVariables.products; 
        if(products?.size()>0){
            System.debug('--- LumonTestPricebooks - Using Existing Products');
        } else {
            lumonTestProducts.setupProductData();
        }
        Test.stopTest();
    }
    @Istest
    public static void setupPricebookDataTest(){
        String testResult;
        Test.startTest();       
        try {
            setupPricebookData();
            List<PricebookEntry> pricebookEntries = LumonTestVariables.pricebookEntries; 
            testResult = ('Inserted '+pricebookEntries.size()+' Test PricebookEntries');
            System.assertNotEquals(0,pricebookEntries?.size(), 'Expected Pricebook Entries to be Created');
        } catch (exception e){
            testResult = ('Error when inserting PricebookEntries: '+e.getMessage());
        }
        System.debug('--- LumonTestPricebooks - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- LumonTestPricebooks - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
        System.debug('--- LumonTestPricebooks - Test Result = '+testResult);
    }
}