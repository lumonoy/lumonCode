/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 05-12-2024
 * @last modified by  : Henk Reynders
**/
@IsTest(isParallel=false)
public with sharing class LumonTestPricebooks {   
    public static void setupPrices(){  
        List<Product2> products = LumonTestVariables.products;          
        for (Product2 p : products) {
            System.debug('--- LumonTestPricebooks - adding Price for Product: '+p);
            if (p.ProductCode != p.Product_Group__c) {
            	String setting = p.ProductCode.remove(p.Product_Group__c+'-');
            	setupPricebookEntry(p.Id,setting);
            } else {
                setupPricebookEntry(p.Id,'GROUP');
            }
        }
    }
    public static void setupPricebookEntry(Id productId){
        Id pricebookId = LumonTestVariables.pricebookId;
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id=pricebookId,
                                                Product2Id=productId,
                                                UnitPrice=5,
                                                IsActive=True,
                                                CurrencyIsoCode = 'EUR',
                                                Base_Price__c=5);
        insert pbe;
    }
    public static void setupPricebookEntry(Id productId,String setting){ 
        Id pricebookId = LumonTestVariables.pricebookId;       
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
        Id pricebookId = LumonTestVariables.pricebookId;
        List<Product2> products = [SELECT Id,Name,ProductCode,IsActive FROM Product2 WHERE Cost_Category__c !='Manhours'];
        List<Id> productIds = new List<Id>(new Map<Id, Product2>(products).keySet()); 
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
        System.debug('--- LumonTestPricebooks - setupPricebookEntries - '+pricebookEntries.size()+' Pricebook Entries Added'); 
        return;
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