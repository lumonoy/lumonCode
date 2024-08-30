/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 03-17-2024
 * @last modified by  : Henk Reynders
**/
@isTest
public with sharing class LumonTestProducts {
    @TestVisible private static List<Product2> testProducts {
        get {return [SELECT  name,Product_Group__c, Product_Model__c, Product_Category__c, Cost_Category__c, Cost_Type__c, ProductCode, Sales_Code__c, IsActive FROM Product2];}
    }  
    public static List<Product2> setupTestProducts(){
        // Load the test products from the static resource
        List<Product2> realProducts = Test.loadData(Product2.sObjectType, 'TestProducts');
        upsert realProducts;
        return realProducts;
    }
    public static List<Product2> setupRetractableProducts(){
        // Load the test products from the static resource
        List<Product2> retractableProducts = Test.loadData(Product2.sObjectType, 'retractableProducts');
        upsert retractableProducts;
        return retractableProducts;
    }
    public static List<Product2> setupSoveliaProducts(){
        // Load the test products from the static resource
        List<Product2> soveliaProducts = Test.loadData(Product2.sObjectType, 'SoveliaProducts');
        upsert soveliaProducts;
        return soveliaProducts;
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
        testProducts.add(p1);
        Product2 p2 = new Product2();
        p2.Name='Test '+productGroup+'-OPTION'; 
        p2.IsActive=True;
        p2.ProductCode=productGroup+'-OPTION';
        p2.Product_Group__c=productGroup;
        p2.Product_Category__c='Product Options';
        p2.Cost_Category__c='FactoryPurchase';
        p2.Cost_Type__c='tuotteet'; 
        testProducts.add(p2);
        Product2 p3 = new Product2();
        p3.Name='Test '+productGroup+'-BLINDS'; 
        p3.IsActive=True;
        p3.ProductCode=productGroup+'-BLINDS';
        p3.Product_Group__c=productGroup;
        p3.Product_Category__c='Product Options';
        p3.Cost_Category__c='FactoryPurchase';
        p3.Cost_Type__c='verhot';  
        testProducts.add(p3);
        Product2 p4 = new Product2();
        p4.Name='Test '+productGroup+'-FREIGHT'; 
        p4.IsActive=True;
        p4.ProductCode=productGroup+'-FREIGHT';
        p4.Product_Group__c=productGroup;
        p4.Product_Category__c='Product Options';
        p4.Cost_Category__c='SalesFreight';
        p4.Cost_Type__c='rahti';  
        testProducts.add(p4);
        Product2 p5 = new Product2();
        p5.Name='Test '+productGroup+'-INSTALL'; 
        p5.IsActive=True;
        p5.ProductCode=productGroup+'-INSTALL';
        p5.Product_Group__c='LG';
        p5.Product_Category__c='Product Options';
        p5.Cost_Category__c='Wages';
        p5.Cost_Type__c='asennus'; 
        testProducts.add(p5);
        Product2 p6 = new Product2();
        p6.Name='Test '+productGroup+'-MIN'; 
        p6.IsActive=True;
        p6.ProductCode=productGroup+'-MIN';
        p6.Product_Group__c=productGroup;
        p6.Product_Category__c='Product Options';
        p6.Cost_Category__c='FactoryPurchase';
        p6.Cost_Type__c='verhot';
        testProducts.add(p6);
        Product2 p7 = new Product2();
        p7.Name='Test '+productGroup+'-MAX'; 
        p7.IsActive=True;
        p7.ProductCode=productGroup+'-MAX';
        p7.Product_Group__c=productGroup;
        p7.Product_Category__c='Product Options';
        p7.Cost_Category__c='FactoryPurchase';
        p7.Cost_Type__c='tuotteet';
        testProducts.add(p7);
        Product2 p8 = new Product2();
        p8.Name='Test '+productGroup+'-TRANS'; 
        p8.IsActive=True;
        p8.ProductCode=productGroup+'-TRANS';
        p8.Product_Group__c=productGroup;
        p8.Product_Category__c='Product Options';
        p8.Cost_Category__c='FactoryPurchase';
        p8.Cost_Type__c='tuotteet';
        testProducts.add(p8);
        Product2 p9 = new Product2();
        p9.Name='Test '+productGroup+'-SPECIAL'; 
        p9.IsActive=True;
        p9.ProductCode=productGroup+'-SPECIAL';
        p9.Product_Group__c=productGroup;
        p9.Product_Category__c='Product Options';
        p9.Cost_Category__c='FactoryPurchase';
        p9.Cost_Type__c='tuotteet';
        testProducts.add(p9);
        Product2 p10 = new Product2();
        p10.Name='Test '+productGroup+'-TIME'; 
        p10.IsActive=True;
        p10.ProductCode=productGroup+'-TIME';
        p10.Product_Group__c=productGroup;
        p10.Product_Category__c='Product Options';
        p10.Cost_Category__c='Manhours';
        p10.Cost_Type__c='askuormitu';  
        testProducts.add(p10);
        //insert new List<Product2>{p1,p2,p3,p4,p5,p6,p7,p8,p9,p10};
        for (Product2 testProduct : testProducts) {
            System.Debug('--- Test Product: '+testProduct);
        }
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
    @Istest
    public static void setupTestProductsTest(){
        List<Product2> testProducts = setupTestProducts();
        System.Debug('--- setupTestProductsTest - Inserted '+testProducts.size()+' Test Products');
        System.assert(testProducts.size() > 0);
    } 
    @Istest
    public static void setupSoveliaProductsTest(){
        List<Product2> soveliaProducts = setupSoveliaProducts();
        System.Debug('--- setupSoveliaProductsTest - Inserted '+soveliaProducts.size()+' Sovelia Products');
        System.assert(soveliaProducts.size() > 0);
    }
    @Istest
    public static void setupRetractableProductsTest(){
        List<Product2> retractableProducts = setupRetractableProducts();
        System.Debug('--- setupRetractableProductsTest - Inserted '+retractableProducts.size()+' LG Products');
        System.assert(retractableProducts.size() > 0);
    } 
}