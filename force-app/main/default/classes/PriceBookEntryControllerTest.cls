/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-10-2023
 * @last modified by  : Henk Reynders
**/
@isTest
public with sharing class PriceBookEntryControllerTest {
    @TestSetup
    static void preparePriceBookEntryData(){    
        LumonTestDataFactory.setupProducts();   
        LumonTestDataFactory.setupPricebookEntries();
    }
    private static List<Product2> products = [SELECT Id,Name,ProductCode,IsActive FROM Product2];
    private static Id pricebookId = LumonTestDataFactory.pricebookId;
    private static List<PricebookEntry> salesProducts = LumonTestDataFactory.pricebookEntries;
    @IsTest
    static void getPricebookRecordTest(){
        test.startTest();
        String errorMessage;
        Id testPricebookId = Test.getStandardPricebookId();
        try {
            Pricebook2 pb = PriceBookEntryController.getPricebookRecord(testPricebookId);
        } catch (Exception e) {
            //Any other exceptions that occur will go here
            errorMessage = e.getMessage(); 
            System.Debug ('--- No Pricebook Returned');
        }
        System.assertNotEquals(null,errorMessage, 'In Test Class not Expected a Pricebook to be returned');
        System.debug('--- getPricebookRecordTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getPricebookRecordTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getPriceListTest(){
        Date closureDate = system.Today()+10;
        String errorMessage;
        Test.startTest();
        try {
            Pricebook2 pb = PriceBookEntryController.getPriceList(closureDate);
        } catch (Exception e) {
            //Any other exceptions that occur will go here
            errorMessage = e.getMessage(); 
            System.Debug ('--- No PriceList Returned');
        }
        System.assertEquals(null,errorMessage, 'In Test Class not Expected a Pricelist to be returned');
        System.debug('--- getPriceListTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getPriceListTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getPricebookEntriesTest(){
        Test.startTest();
        List<PricebookEntry> pbes = PriceBookEntryController.getPricebookEntries(pricebookId);
        System.Debug ('--- '+ pbes.size() +' PricebookEntries Returned');
        System.assertNotEquals(0,pbes.size(), 'Expected Pricebook Entries to be returned');
        System.debug('--- getPricebookEntriesTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getPricebookEntriesTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getPricebookEntryMapTest(){
        Test.startTest();
        Map<String,PricebookEntry> pbEntryMap = PriceBookEntryController.getPriceBookEntryMap(pricebookId,'EUR');
        System.Debug ('--- '+ pbEntryMap.size() +' Pricebook Entries Returned in a Map');
        System.assertNotEquals(0,pbEntryMap.size(), 'Expected Pricebook Entries to be returned');
        System.debug('--- getPricebookEntriesTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getPricebookEntriesTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
}