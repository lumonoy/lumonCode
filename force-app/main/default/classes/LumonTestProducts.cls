/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 10-01-2024
 * @last modified by  : Henk Reynders
**/
@isTest
public with sharing class LumonTestProducts {
    @TestVisible public static List<String> productGroups {
        get {
            return LumonTestData.productGroups;
        }
    }
    @TestVisible public static List<Product2> mainProducts {
        get{
            return [SELECT name,ProductGroup__c, ProductModel__c, ProductCategory__c, CostCategory__c, CostType__c, ProductCode, ProductCode__c, IsActive FROM Product2 WHERE isMainProduct__c = True];
        }  
    }
    @TestVisible public static List<Id> mainProductIds {
        get{
            return new List<Id>(new Map<Id, Product2>(mainProducts).keySet()); 
        }
    } 
    @TestVisible public static List<Product2> products {
        get{
            return [SELECT name,ProductGroup__c, ProductModel__c, ProductCategory__c, CostCategory__c, CostType__c, ProductCode, ProductCode__c, IsActive FROM Product2 WHERE isMainProduct__c = False];
        }  
    }
    @TestVisible public static List<Id> productIds {
        get{
            return new List<Id>(new Map<Id, Product2>(products).keySet()); 
        }
    } 
    @TestVisible public static List<Product2> soveliaProducts {
        get{
            return [SELECT name,ProductGroup__c, ProductModel__c, ProductCategory__c, CostCategory__c, CostType__c, ProductCode, ProductCode__c, IsActive FROM Product2 WHERE isMainProduct__c = True AND Configurator__c = 'Sovelia'];
        }
    } 
    @TestVisible public static List<Product2> visualProducts {
        get{
            return [SELECT name,ProductGroup__c, ProductModel__c, ProductCategory__c, CostCategory__c, CostType__c, ProductCode, ProductCode__c, IsActive FROM Product2 WHERE isMainProduct__c = True AND Configurator__c = 'Visualovelia'];
        }
    }
    @TestVisible public static List<Product2> retractableProducts {
        get{
            return [SELECT name,ProductGroup__c, ProductModel__c, ProductCategory__c, CostCategory__c, CostType__c, ProductCode, ProductCode__c, IsActive FROM Product2 WHERE Product_Group__c = 'LG'];
        }
    } 
    @TestVisible public static List<Product2> slidingProducts {
        get{
            return [SELECT name,ProductGroup__c, ProductModel__c, ProductCategory__c, CostCategory__c, CostType__c, ProductCode, ProductCode__c, IsActive FROM Product2 WHERE Product_Group__c = 'LGS'];
        }
    } 
    @TestVisible public static List<Product2> fixedWallProducts {
        get{
            return [SELECT name,ProductGroup__c, ProductModel__c, ProductCategory__c, CostCategory__c, CostType__c, ProductCode, ProductCode__c, IsActive FROM Product2 WHERE Product_Group__c = 'LFIXEDWALL'];
        }
    } 
    @TestVisible public static List<Product2> balustradeProducts {
        get{
            return [SELECT name,ProductGroup__c, ProductModel__c, ProductCategory__c, CostCategory__c, CostType__c, ProductCode, ProductCode__c, IsActive FROM Product2 WHERE Product_Group__c = 'LUMONKAIDE'];
        }
    }  
    @TestVisible public static List<Product2> terraceProducts {
        get{
            return [SELECT name,ProductGroup__c, ProductModel__c, ProductCategory__c, CostCategory__c, CostType__c, ProductCode, ProductCode__c, IsActive FROM Product2 WHERE Product_Group__c IN ('VT3','VT4')];
        }
    }   
    @TestVisible public static List<Product2> blindsProducts {
        get{
            return [SELECT name,ProductGroup__c, ProductModel__c, ProductCategory__c, CostCategory__c, CostType__c, ProductCode, ProductCode__c, IsActive FROM Product2 WHERE Product_Group__c = 'VISORBLINDSALES'];
        }
    }  
    public static List<Product2> setupMainProducts(){
        List<Product2> testProducts = new List<Product2>();    
        for (String productGroup : productGroups) {       
            Product2 p1 = new Product2();
            p1.Name=productGroup;
            p1.IsActive=True;
            p1.ProductCode=productGroup;
            p1.ProductGroup__c=productGroup;
            p1.ProductCategory__c='Product Groups';
            p1.CostCategory__c='FactoryPurchase';
            p1.CostType__c='tuotteet';
            p1.QuantityUnitOfMeasure = 'pcs';
            testProducts.add(p1);
            //System.debug('--- Main Product: '+p1);
        }
        if( testProducts.size()>0) {
            insert testProducts;
            List<Product2> insertedProducts = [SELECT Id,Name,ProductGroup__c, ProductCode, ProductCode__c, ProductCategory__c,IsActive,isMainProduct__c FROM Product2];
        }
        System.debug('--- Created '+testProducts.size()+ ' Main Products');
        
        return testProducts;
    }
    public static List<Product2> setupProducts(){
        List<Product2> testProducts = new List<Product2>();  
        for (String productGroup : productGroups) {     
            Product2 p1 = new Product2();
            p1.Name=productGroup;
            p1.IsActive=True;
            p1.ProductCode=productGroup+'-OPTION1';
            p1.ProductGroup__c=productGroup;
            p1.ProductCategory__c='Product Options';
            p1.CostCategory__c='FactoryPurchase';
            p1.CostType__c='tuotteet';
            p1.QuantityUnitOfMeasure = 'pcs';
            testProducts.add(p1);
            Product2 p2 = new Product2();
            p2.Name='Test '+productGroup+'-OPTION2'; 
            p2.IsActive=True;
            p2.ProductCode=productGroup+'-OPTION2';
            p2.ProductGroup__c=productGroup;
            p2.ProductCategory__c='Product Options';
            p2.CostCategory__c='FactoryPurchase';
            p2.CostType__c='tuotteet';
            p2.QuantityUnitOfMeasure = 'pcs'; 
            testProducts.add(p2);
            Product2 p3 = new Product2();
            p3.Name='Test '+productGroup+'-BLINDS'; 
            p3.IsActive=True;
            p3.ProductCode=productGroup+'-BLINDS';
            p3.ProductGroup__c=productGroup;
            p3.ProductCategory__c='Product Options';
            p3.CostCategory__c='FactoryPurchase';
            p3.CostType__c='verhot';  
            p3.QuantityUnitOfMeasure = 'pcs';
            testProducts.add(p3);
            Product2 p4 = new Product2();
            p4.Name='Test '+productGroup+'-FREIGHT'; 
            p4.IsActive=True;
            p4.ProductCode=productGroup+'-FREIGHT';
            p4.ProductGroup__c=productGroup;
            p4.ProductCategory__c='Product Options';
            p4.CostCategory__c='SalesFreight';
            p4.CostType__c='rahti';  
            p4.QuantityUnitOfMeasure = 'pcs';
            testProducts.add(p4);
            Product2 p5 = new Product2();
            p5.Name='Test '+productGroup+'-INSTALL'; 
            p5.IsActive=True;
            p5.ProductCode=productGroup+'-INSTALL';
            p5.ProductGroup__c='LG';
            p5.ProductCategory__c='Product Options';
            p5.CostCategory__c='Wages';
            p5.CostType__c='asennus';
            p5.QuantityUnitOfMeasure = 'pcs'; 
            testProducts.add(p5);
            Product2 p6 = new Product2();
            p6.Name='Test '+productGroup+'-MIN'; 
            p6.IsActive=True;
            p6.ProductCode=productGroup+'-MIN';
            p6.ProductGroup__c=productGroup;
            p6.ProductCategory__c='Product Options';
            p6.CostCategory__c='FactoryPurchase';
            p6.CostType__c='verhot';
            p6.QuantityUnitOfMeasure = 'pcs';
            testProducts.add(p6);
            Product2 p7 = new Product2();
            p7.Name='Test '+productGroup+'-MAX'; 
            p7.IsActive=True;
            p7.ProductCode=productGroup+'-MAX';
            p7.ProductGroup__c=productGroup;
            p7.ProductCategory__c='Product Options';
            p7.CostCategory__c='FactoryPurchase';
            p7.CostType__c='tuotteet';
            p7.QuantityUnitOfMeasure = 'pcs';
            testProducts.add(p7);
            Product2 p8 = new Product2();
            p8.Name='Test '+productGroup+'-TRANS'; 
            p8.IsActive=True;
            p8.ProductCode=productGroup+'-TRANS';
            p8.ProductGroup__c=productGroup;
            p8.ProductCategory__c='Product Options';
            p8.CostCategory__c='FactoryPurchase';
            p8.CostType__c='tuotteet';
            p8.QuantityUnitOfMeasure = 'pcs';
            testProducts.add(p8);
            Product2 p9 = new Product2();
            p9.Name='Test '+productGroup+'-SPECIAL'; 
            p9.IsActive=True;
            p9.ProductCode=productGroup+'-SPECIAL';
            p9.ProductGroup__c=productGroup;
            p9.ProductCategory__c='Product Options';
            p9.CostCategory__c='FactoryPurchase';
            p9.CostType__c='tuotteet';
            p9.QuantityUnitOfMeasure = 'pcs';
            testProducts.add(p9);
            Product2 p10 = new Product2();
            p10.Name='Test '+productGroup+'-TIME'; 
            p10.IsActive=True;
            p10.ProductCode=productGroup+'-TIME';
            p10.ProductGroup__c=productGroup;
            p10.ProductCategory__c='Product Options';
            p10.CostCategory__c='Manhours';
            p10.CostType__c='askuormitu';
            p10.QuantityUnitOfMeasure = 'h';  
            testProducts.add(p10);
        }
        //insert new List<Product2>{p1,p2,p3,p4,p5,p6,p7,p8,p9,p10};
        insert testProducts;
        System.debug('--- setupProducts: '+testProducts);
        return testProducts;
    }
    
    public static void setupProductData(){ 
        Id productSettingsOwner = Product_Settings__c.getOrgDefaults().SetupOwnerId;
        if (String.IsNotBlank(productSettingsOwner)) {
            System.debug('--- LumonTestProducts - Using existing Product Settings');
        } else {
            LumonTestProductSettings.setupProductSettings();
        }      
        System.debug('--- LumonTestProducts - Inserting Products for '+productGroups?.size()+' Product Groups');
        setupMainProducts();
        System.debug('--- LumonTestProducts - Inserted '+mainProducts.size()+' Products');
        setupProducts();
        System.debug('--- LumonTestProducts - Inserted '+products.size()+' Products');
        System.debug('--- LumonTestProducts - Setup Products CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestProducts - Setup Products SOQL USED: ' + LIMITS.getQueries());
        
        Integer productCounter1 = 0;
        for (Product2 p: mainProducts) {
            productCounter1++;
            System.debug('--- LumonTestProducts - Main Product '+productCounter1+': '+p);
        } 
        Integer productCounter2 = 0;
        for (Product2 p: products) {
            productCounter2++;
            System.debug('--- LumonTestProducts - Product (Item)'+productCounter2+': '+p);
        } 
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
            

            List<Product2> testproducts = [SELECT name,ProductGroup__c, ProductCode, ProductCode__c, IsActive FROM Product2 WHERE isMainProduct__c = True];
            testResult = ('Inserted '+testproducts?.size()+' Test Products');
            System.assertNotEquals(0,testproducts?.size(), 'Expected Products to be Created');
            
        } catch (exception e){
            testResult =('Error when inserting Products: '+e.getMessage());
        }
        System.debug('--- LumonTestProducts - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- LumonTestProducts - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
        System.debug('--- LumonTestProducts - Test Result = '+testResult);
        System.AssertNotEquals(true, testResult.contains('Error'));
    }
}