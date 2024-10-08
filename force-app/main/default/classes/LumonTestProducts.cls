/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 05-30-2024
 * @last modified by  : Henk Reynders
**/
@isTest
public with sharing class LumonTestProducts {
    public static void setupProductGroups(List<String> mainProducts) {
        for (String productGroup : mainProducts) {
            //.debug('--- LumonTestProducts - setup products for Group: '+productGroup);
            setupProducts(productGroup);
        }
        return;
    }
    public static List<Product2> setupProducts(){
        List<Product2> rectractableProducts = setupProducts('LG');
        return rectractableProducts;
    }
    public static List<Product2> setupProducts(String productGroup){
        List<Product2> testProducts = new List<Product2>();    
        Product2 p1 = new Product2();
        p1.Name=productGroup;
        p1.IsActive=True;
        p1.ProductCode=productGroup;
        p1.Product_Group__c=productGroup;
        p1.Product_Category__c='Product Groups';
        p1.Cost_Category__c='FactoryPurchase';
        p1.Cost_Type__c='tuotteet';
        p1.QuantityUnitOfMeasure = 'pcs';
        testProducts.add(p1);
        Product2 p2 = new Product2();
        p2.Name='Test '+productGroup+'-OPTION'; 
        p2.IsActive=True;
        p2.ProductCode=productGroup+'-OPTION';
        p2.Product_Group__c=productGroup;
        p2.Product_Category__c='Product Options';
        p2.Cost_Category__c='FactoryPurchase';
        p2.Cost_Type__c='tuotteet';
        p2.QuantityUnitOfMeasure = 'pcs'; 
        testProducts.add(p2);
        Product2 p3 = new Product2();
        p3.Name='Test '+productGroup+'-BLINDS'; 
        p3.IsActive=True;
        p3.ProductCode=productGroup+'-BLINDS';
        p3.Product_Group__c=productGroup;
        p3.Product_Category__c='Product Options';
        p3.Cost_Category__c='FactoryPurchase';
        p3.Cost_Type__c='verhot';  
        p3.QuantityUnitOfMeasure = 'pcs';
        testProducts.add(p3);
        Product2 p4 = new Product2();
        p4.Name='Test '+productGroup+'-FREIGHT'; 
        p4.IsActive=True;
        p4.ProductCode=productGroup+'-FREIGHT';
        p4.Product_Group__c=productGroup;
        p4.Product_Category__c='Product Options';
        p4.Cost_Category__c='SalesFreight';
        p4.Cost_Type__c='rahti';  
        p4.QuantityUnitOfMeasure = 'pcs';
        testProducts.add(p4);
        Product2 p5 = new Product2();
        p5.Name='Test '+productGroup+'-INSTALL'; 
        p5.IsActive=True;
        p5.ProductCode=productGroup+'-INSTALL';
        p5.Product_Group__c='LG';
        p5.Product_Category__c='Product Options';
        p5.Cost_Category__c='Wages';
        p5.Cost_Type__c='asennus';
        p5.QuantityUnitOfMeasure = 'pcs'; 
        testProducts.add(p5);
        Product2 p6 = new Product2();
        p6.Name='Test '+productGroup+'-MIN'; 
        p6.IsActive=True;
        p6.ProductCode=productGroup+'-MIN';
        p6.Product_Group__c=productGroup;
        p6.Product_Category__c='Product Options';
        p6.Cost_Category__c='FactoryPurchase';
        p6.Cost_Type__c='verhot';
        p6.QuantityUnitOfMeasure = 'pcs';
        testProducts.add(p6);
        Product2 p7 = new Product2();
        p7.Name='Test '+productGroup+'-MAX'; 
        p7.IsActive=True;
        p7.ProductCode=productGroup+'-MAX';
        p7.Product_Group__c=productGroup;
        p7.Product_Category__c='Product Options';
        p7.Cost_Category__c='FactoryPurchase';
        p7.Cost_Type__c='tuotteet';
        p7.QuantityUnitOfMeasure = 'pcs';
        testProducts.add(p7);
        Product2 p8 = new Product2();
        p8.Name='Test '+productGroup+'-TRANS'; 
        p8.IsActive=True;
        p8.ProductCode=productGroup+'-TRANS';
        p8.Product_Group__c=productGroup;
        p8.Product_Category__c='Product Options';
        p8.Cost_Category__c='FactoryPurchase';
        p8.Cost_Type__c='tuotteet';
        p8.QuantityUnitOfMeasure = 'pcs';
        testProducts.add(p8);
        Product2 p9 = new Product2();
        p9.Name='Test '+productGroup+'-SPECIAL'; 
        p9.IsActive=True;
        p9.ProductCode=productGroup+'-SPECIAL';
        p9.Product_Group__c=productGroup;
        p9.Product_Category__c='Product Options';
        p9.Cost_Category__c='FactoryPurchase';
        p9.Cost_Type__c='tuotteet';
        p9.QuantityUnitOfMeasure = 'pcs';
        testProducts.add(p9);
        Product2 p10 = new Product2();
        p10.Name='Test '+productGroup+'-TIME'; 
        p10.IsActive=True;
        p10.ProductCode=productGroup+'-TIME';
        p10.Product_Group__c=productGroup;
        p10.Product_Category__c='Product Options';
        p10.Cost_Category__c='Manhours';
        p10.Cost_Type__c='askuormitu';
        p10.QuantityUnitOfMeasure = 'h';  
        testProducts.add(p10);
        //insert new List<Product2>{p1,p2,p3,p4,p5,p6,p7,p8,p9,p10};
        insert testProducts;
        System.debug('--- setupProducts: '+testProducts);
        return testProducts;
    }
    public static void setupGlazingRetractable() {
        String testResult;      
        Test.startTest();
        Try {
            setupProducts('LG');
            testResult = 'successfully inserted Products';
        } catch (exception e){
            testResult = 'error when inserting Products: '+e.getMessage();
        }
        Test.stopTest();
        System.debug('--- setupGlazingRetractable: '+testResult);
        System.AssertNotEquals(true, testResult.contains('error'));
    }
    public static void setupGlazingSliding() {
        setupProducts('LGS');  
    } 
    public static void setupGlazingFixed() {
        setupProducts('LFIXEDWALL');  
    } 
    public static void setupTerraceVT3() {
        setupProducts('VT3'); 
    }  
    public static void setupTerraceVT4() {
        setupProducts('VT4'); 
    }  
    public static void setupBalustrade() {
        setupProducts('LUMONKAIDE');  
    } 
    public static void setupBalustradeWithPosts() {
        setupProducts('LUMONTOLPK');  
    } 
    public static void setupAdditionalCosts() {
        setupProducts('LISAKUSTAN');  
    } 
    public static void setupExtraSales() {   
        setupProducts('LISAHIN');  
    }  
    public static void setupServices() {   
        setupProducts('LISAHIN');  
    }    
    public static void setupSpares() {   
        setupProducts('TARVIKE');  
    } 
    public static void setupSoveliaProducts() {   
        setupProducts('VISORBLINDSALES');  
    } 
    
    @TestVisible private static List<Product2> testProducts {
        get {return [SELECT  name,Product_Group__c, Product_Model__c, Product_Category__c, Cost_Category__c, Cost_Type__c, ProductCode, Sales_Code__c, IsActive FROM Product2];}
    }  
    
    @Istest
    public static void setupSoveliaProductsTest(){
        //List<Product2> soveliaProducts = 
        setupSoveliaProducts();
        System.Debug('--- setupSoveliaProductsTest - Inserted '+testProducts.size()+' Sovelia Products');
        System.assert(testProducts.size() > 0);
    }
    @Istest
    public static void setupRetractableProductsTest(){
        setupRetractableProducts();
        System.Debug('--- setupRetractableProductsTest - Inserted '+testProducts.size()+' LG Products');
        System.assert(testProducts.size() > 0);
    } 
    public static void setupTestProducts(){
        setupRetractableProducts();
        setupSoveliaProducts();
    }
    public static void setupProductData(){ 
        Id productSettingsOwner = Product_Settings__c.getOrgDefaults().SetupOwnerId;
        if (String.IsNotBlank(productSettingsOwner)) {
            System.debug('--- LumonTestProducts - Using existing Product Settings');
        } else {
            LumonTestProductSettings.setupProductSettings();
        }
        List<Product2> mainProducts = LumonTestVariables.mainProducts;
        List<String> productGroups = LumonTestVariables.productGroups;
        
        System.debug('--- LumonTestProducts - Inserting Products for '+productGroups?.size()+' Product Groups');
        setupProductGroups(productGroups);
        System.debug('--- LumonTestProducts - Setup Products CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestProducts - Setup Products SOQL USED: ' + LIMITS.getQueries());
        List<Product2> products = LumonTestVariables.products;
        System.debug('--- LumonTestProducts - Inserted '+products.size()+' Products'); 
    }  
    public static void setupRetractableProducts(){
        setupProducts('LG');
    }
    public static void setupSlidingProducts(){
        setupProducts('LGS');
    }
    public static void setupFixedWallProducts(){
        setupProducts('LFIXEDWALL');
    }
    public static void setupBalustradeProducts(){
        setupProducts('LUMONKAIDE');
    }
    public static void setupTerraceProducts(){
        setupProducts('VT3');
        setupProducts('VT4');
    }
    @TestSetup
    static void prepareData() {
        Test.startTest();
        Id productSettingsOwner = Product_Settings__c.getOrgDefaults().SetupOwnerId;
        if (String.IsNotBlank(productSettingsOwner)) {
            System.debug('--- LumonTestProducts - Using existing Product Settings');
        } else {
            LumonTestProductSettings.setupProductSettings();
        }
        Test.stopTest();
    }
    @Istest
    public static void setupProductDataTest(){
        String testResult;  
        Test.startTest();
        try {
            setupProductData();
            List<Product2> products = LumonTestVariables.products;
            testResult = ('Inserted '+products?.size()+' Test Products');
            System.assertNotEquals(0,products?.size(), 'Expected Products to be Created');
            
        } catch (exception e){
            testResult =('Error when inserting Products: '+e.getMessage());
        }
        System.debug('--- LumonTestProducts - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- LumonTestProducts - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
        System.debug('--- LumonTestProducts - Test Result = '+testResult);
        System.AssertNotEquals(true, testResult.contains('Error'));
    }
    @Istest
    public static void setupRetractableProductDataTest(){
        String testResult;  
        Test.startTest();
        try {
            setupRetractableProducts();
            List<Product2> products = LumonTestVariables.retractableProducts;
            testResult = ('Inserted '+products?.size()+' LG Test Products');
            System.assertNotEquals(0,products?.size(), 'Expected LG Products to be Created');
            
        } catch (exception e){
            testResult =('Error when inserting LG Products: '+e.getMessage());
        }
        System.debug('--- LumonTestProducts - Setup LG Products CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- LumonTestProducts - Setup LG Products SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
        System.debug('--- LumonTestProducts - Setup LG Products Test Result = '+testResult);
        System.AssertNotEquals(true, testResult.contains('Error'));
    }
}