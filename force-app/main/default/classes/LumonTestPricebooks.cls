/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-09-2023
 * @last modified by  : Henk Reynders
**/
@IsTest(isParallel=false)
public with sharing class LumonTestPricebooks {
	@TestVisible private static Id pricebookId{
        get{
            return Test.getStandardPricebookId();
        }
    }
    @TestVisible private static List<PricebookEntry> pricebookEntries{
        get{
            return [SELECT Id,Name,Product2Id,IsActive FROM PricebookEntry WHERE Pricebook2Id =: pricebookId];
        }
    }
    public static void setupPrices(){      
        List<Product2> products = [SELECT Id, Name,ProductCode,Product_Group__c,Cost_Type__c,IsActive FROM Product2];
        for (Product2 p : products) {
            if (p.ProductCode != p.Product_Group__c) {
            	String setting = p.ProductCode.remove(p.Product_Group__c+'-');
            	setupPricebookEntry(p.Id,setting);
            } else {
                setupPricebookEntry(p.Id,'GROUP');
            }
        }
    }
    public static void setupPricebookEntry(Id productId){
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id=pricebookId,
                                                Product2Id=productId,
                                                UnitPrice=5,
                                                IsActive=True,
                                                CurrencyIsoCode = 'EUR',
                                                Base_Price__c=5);
        insert pbe;
    }
    public static void setupPricebookEntry(Id productId,String setting){
        
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id=pricebookId,
                                                Product2Id=productId,
                                                UnitPrice=5,
                                                IsActive=True,
                                                CurrencyIsoCode = 'EUR',
                                                Base_Price__c=5);
        switch on setting {
            when 'GROUP' {
                pbe.Base_Price__c=0;
                pbe.UnitPrice=0;
            }
            when 'MIN' {
                pbe.Minimum_Price__c = 500;
            }
            when 'MAX' {
                pbe.Quantity_per_Order__c = 1;
            }
            when 'TRANS' {
                pbe.Transmission__c = 0;
            }
        }        
        insert pbe;
    }
    public static void setupPricebookEntries(){
        List<Product2> products = [SELECT Id,Name,ProductCode,IsActive FROM Product2];
        List<Id> productIds = new List<Id>(new Map<Id, Product2>(products).keySet()); 
        setupPricebookEntries(productIds);
    }
    public static void setupPricebookEntries(List<Id> productIds){
        List<PricebookEntry> pricebookEntries = new List<PricebookEntry>();
        for (Integer i = 0; i<productIds.size();i++) {
            Integer counter= i+1;
            Decimal basePrice = (counter)*1;
            Decimal unitPrice = (counter)*10;
            PricebookEntry pbe = new PricebookEntry(Pricebook2Id=pricebookId,
                                                    Product2Id=productIds[i],
                                                    UnitPrice=unitPrice,
                                                    IsActive=True,
                                                    CurrencyIsoCode = 'EUR',
                                                    Base_Price__c=basePrice,
                                                    Minimum_Price__c = 0,
                                                    Quantity_per_Order__c = 0,
                                                    Transmission__c = 100
                                                   );
            pricebookEntries.add(pbe);
        }
        insert pricebookEntries;
    }
    @IsTest
    static void setupPricesTest(){
        String testResult;
        LumonTestDataFactory.setupProducts();
        Test.startTest();
        Try {
            LumonTestDataFactory.setupPricebookEntries();
            testResult = 'successfully inserted Prices';
            System.debug('--- setupPricesTest: '+pricebookEntries);
        } catch (exception e){
            testResult = 'error when inserting Prices: '+e.getMessage();
        }
        Test.stopTest();
        System.debug('--- setupPricesTest: '+testResult);
        
        System.AssertNotEquals(true, testResult.contains('error'));
    }
}