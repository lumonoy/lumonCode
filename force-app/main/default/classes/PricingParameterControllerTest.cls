/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 03-14-2024
 * @last modified by  : Henk Reynders
**/
@IsTest(isParallel=false)
public class PricingParameterControllerTest {
    @TestSetup
    static void prepareData(){
        Test.startTest();
        LumonTestDataFactory.setupProducts();
        LumonTestDataFactory.setupPriceParameters();
        Test.stopTest();
    }
    private static Id b2cAccountId = LumonTestDataFactory.b2cAccountId;
    private static Id b2cOpportunityId = LumonTestDataFactory.b2cOpportunityId;
    private static Id b2cSyncedQuoteId = LumonTestDataFactory.b2cSyncedQuoteId;
    private static Id b2cQuoteId = LumonTestDataFactory.b2cQuoteId;
    
    @IsTest
    static void getFactoryPricesConsumerTest(){
        String org = 'LSU';
        String country = 'FI';
        String business = 'Consumer';
        List<String> products = new List<string>();
        products.add('LG');
        products.add('LGS');
        Map<String,Map<String,Factory_Price__c>> factoryPriceMap = PricingParameterController.getFactoryPrices(products,org,country,business); 
        System.assertNotEquals(0, factoryPriceMap.size(), 'Expecting One or More Items to be returned');
        System.debug('--- Pricing Test - CPU TIME: '+LIMITS.getCpuTime()); 
    }
    @IsTest
    static void getProductCostsConsumerTest(){
        String org = 'LSU';
        String country = 'FI';
        String business = 'Consumer';
        String district = 'FI_North';
        List<String> products = new List<string>();
        products.add('LG');
        products.add('LGS');
        Map<String,Map<String,Product_Cost__c>> productCostMap = PricingParameterController.getProductCosts(products,org,country,business,district); 
        System.assertNotEquals(0, productCostMap.size(), 'Expecting One or More Items to be returned');
        System.debug('--- Pricing Test - CPU TIME: '+LIMITS.getCpuTime()); 
    }
    @IsTest
    static void getSalesPricesConsumerTest(){
        String org = 'LSU';
        String country = 'FI';
        String business = 'Consumer';
        String district = 'FI_North';
        String bu = '4043 LSU Oulu';
        String customer = '';
        List<String> products = new List<string>();
        products.add('LG');
        products.add('LGS');
        Map<String,Map<String,Sales_Price__c>> salesPriceMap = PricingParameterController.getSalesPrices(products,org,country,business,district,bu,customer); 
        System.assertNotEquals(0, salesPriceMap.size(), 'Expecting One or More Items to be returned');
        System.debug('--- Pricing Test - CPU TIME: '+LIMITS.getCpuTime()); 
    }
    @IsTest
    static void getSalesPriceResellerTest(){
        String org = 'LSU';
        String country = 'FI';
        String business = 'Reseller';
        String district = 'FI_North';
        String bu = '4043 LSU Oulu';
        String customer = '1234-56';
        List<String> products = new List<string>();
        products.add('LG');
        Map<String,Map<String,Sales_Price__c>> salesPriceMap = PricingParameterController.getSalesPrices(products,org,country,business,district,bu,customer); 
        System.assertNotEquals(0, salesPriceMap.size(), 'Expecting One or More Items to be returned');
        System.debug('--- Pricing Test - CPU TIME: '+LIMITS.getCpuTime()); 
    }  
    @IsTest
    static void getFactoryPriceConsumerTest(){
        String org = 'LSU';
        String country = 'FI';
        String business = 'Consumer';
        String productGroup = 'LG';
        String costType = 'tuotteet';
        Factory_Price__c factoryPrice = PricingParameterController.getFactoryPrice(productGroup, costType,org,country,business); 
        System.assertNotEquals(null, factoryPrice, 'Expecting One or More Items to be returned');
        System.debug('--- Pricing Test - CPU TIME: '+LIMITS.getCpuTime()); 
    }
    @IsTest
    static void getProductCostConsumerTest(){
        String org = 'LSU';
        String country = 'FI';
        String business = 'Consumer';
        String district = 'FI_North';
        List<String> products = new List<string>();
        String productGroup = 'LG';
        String costType = 'tuotteet';
        Product_Cost__c productCost = PricingParameterController.getProductCost(productGroup, costType,org,country,business,district); 
        System.assertNotEquals(null, productCost, 'Expecting One or More Items to be returned');
        System.debug('--- Pricing Test - CPU TIME: '+LIMITS.getCpuTime()); 
    }
    @IsTest
    static void getSalesPriceConsumerTest(){
        String org = 'LSU';
        String country = 'FI';
        String business = 'Consumer';
        String district = 'FI_North';
        String bu = '4043 LSU Oulu';
        String customer = '';
        String productGroup = 'LG';
        String costType = 'tuotteet';
        Sales_Price__c salesPrice = PricingParameterController.getSalesPrice(productGroup, costType,org,country,business,district,bu,customer); 
        System.assertNotEquals(null, salesPrice, 'Expecting One or More Items to be returned');
        System.debug('--- Pricing Test - CPU TIME: '+LIMITS.getCpuTime()); 
    }
}