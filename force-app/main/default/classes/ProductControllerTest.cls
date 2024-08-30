/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 03-18-2024
 * @last modified by  : Henk Reynders
**/
@IsTest
public with sharing class ProductControllerTest {
    @TestSetup
    public static void prepareData(){
        Test.startTest();
        //SalesTestDataFactory.setupProduct2Records();
        LumonTestDataFactory.setupProducts();
        Test.stopTest();
    }   
    @IsTest
    static void getProductTest(){
        Test.startTest();
        Id productId = [SELECT Id FROM Product2 LIMIT 1]?.Id;
        Product2 product = ProductController.getProduct(productId);
        System.Debug ('----'+ product?.ProductCode +' Product Returned');
        System.assertNotEquals(null,product?.Id, 'Expected One or More Products to be returned');
        System.debug('--- getProductTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getProductTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getProductsTest(){
        Test.startTest();
        List<Product2> prods = [SELECT Id FROM Product2 LIMIT 5];
        List<Id> productIds = new List<Id>(new Map<Id, Product2>(prods).keySet()); 
        List<Product2> products = ProductController.getProducts(productIds);
        System.Debug ('----'+ products?.size() +' Product2s Returned');
        if (products.size()>0){
            System.Debug (products);
        }
        System.assertNotEquals(0,products?.size(), 'Expected One or More Products to be returned');
        System.debug('--- getProductsTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getProductsTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getProductsByGroupTest(){
        Test.startTest();
        List<Product2> prods = [SELECT Id,Product_Group__c FROM Product2 LIMIT 5];
        Set<String> pGroups = new Set<String>();
        for (Product2 p : prods) {
            pGroups.add(p.Product_Group__c);
        }
        List<String> productGroups = new List<String>();
        productGroups.addAll(pGroups);
        Map<String,List<Product2>> productMap = ProductController.getProductsByGroup(productGroups);
        System.Debug ('----'+ productMap?.size() +' Products Returned');
        System.assertNotEquals(0,productMap?.size(), 'Expected One or More Product2s to be returned');
        System.debug('--- getProductsTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getProductsTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }

}