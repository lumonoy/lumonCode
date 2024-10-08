/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 05-10-2024
 * @last modified by  : Henk Reynders
**/
@IsTest(isParallel=false)
public class PriceMultiplierControllerTest {
    @TestSetup
    static void prepareData(){
        List<Product2> products = LumonTestVariables.products;
        Test.startTest();
        if(products?.size()>0){
            System.debug('--- LumonTestPriceMultipliers - Using Existing Products');
        } else {
            LumonTestProducts.setupProductData();
        }
        LumonTestPriceMultipliers.setupPriceMultiplierData();
        List<Factory_Price__c> factoryPrices = LumonTestVariables.factoryPrices;
        List<Product_Cost__c> productCosts = LumonTestVariables.productCosts;
        List<Sales_Price__c> salesPrices = LumonTestVariables.salesPrices;
        System.AssertNotEquals(0, factoryPrices.size(),'Expected Factory Prices to be Inserted');
        System.AssertNotEquals(0, productCosts.size(),'Expected Prodyct Costs to be Inserted');
        System.AssertNotEquals(0, salesPrices.size(),'Expected Sales Prices to be Inserted');
        Test.stopTest();
    }    
    @IsTest
    static void getFactoryPricesTest(){
        String org = LumonTestVariables.organizations[0];
        String country = LumonTestVariables.countries[0];
        String businessType = LumonTestVariables.businessTypes[0];
        List<String> productGroups= LumonTestVariables.productGroups;
        Map<String,Map<String,Factory_Price__c>> factoryPriceMap = PriceMultiplierController.getFactoryPrices(productGroups,org,country,businessType); 
        System.assertNotEquals(0, factoryPriceMap.size(), 'Expecting One or More Items to be returned');
        System.debug('--- PriceMultiplierController - getFactoryPrices Test - CPU TIME: '+LIMITS.getCpuTime()); 
    }
    @IsTest
    static void getProductCostsTest(){
        String org = LumonTestVariables.organizations[0];
        String country = LumonTestVariables.countries[0];
        String businessType = LumonTestVariables.businessTypes[0];
        String district = LumonTestVariables.districts[0];
        List<String> productGroups= LumonTestVariables.productGroups;
        Map<String,Map<String,Product_Cost__c>> productCostMap = PriceMultiplierController.getProductCosts(productGroups,org,country,businessType,district); 
        System.assertNotEquals(0, productCostMap.size(), 'Expecting One or More Items to be returned');
        System.debug('--- PriceMultiplierControllerTest - getProductCostsTest - CPU TIME: '+LIMITS.getCpuTime()); 
    }
    @IsTest
    static void getSalesPricesTest(){
        String org = LumonTestVariables.organizations[0];
        String country = LumonTestVariables.countries[0];
        String businessType = LumonTestVariables.businessTypes[0];
        String district = LumonTestVariables.districts[0];
        String profitCenter = LumonTestVariables.profitCenters[0];
        String customer = '';
        List<String> productGroups= LumonTestVariables.productGroups;
        Map<String,Map<String,Sales_Price__c>> salesPriceMap = PriceMultiplierController.getSalesPrices(productGroups,org,country,businessType,district,profitCenter,customer); 
        System.assertNotEquals(0, salesPriceMap.size(), 'Expecting One or More Items to be returned');
        System.debug('--- PriceMultiplierControllerTest - getSalesPricesTest - CPU TIME: '+LIMITS.getCpuTime()); 
    }
    @IsTest
    static void getFactoryPriceTest(){ 
        String org = LumonTestVariables.organizations[0];
        String country = LumonTestVariables.countries[0];
        String businessType = LumonTestVariables.businessTypes[0];
        String costType = LumonTestVariables.costTypes[0];
        String productGroup= LumonTestVariables.productGroups[0];
        Factory_Price__c factoryPriceEntry = PriceMultiplierController.getFactoryPrice(productGroup,costType,org,country,businessType); 
        System.assertNotEquals(null,String.isNotBlank(factoryPriceEntry.Id), 'Expecting a Item to be returned');
        System.debug('--- PriceMultiplierController - getFactoryPriceTest - CPU TIME: '+LIMITS.getCpuTime()); 
    }
    @IsTest
    static void getProductCostTest(){ 
        String org = LumonTestVariables.organizations[0];
        String country = LumonTestVariables.countries[0];
        String businessType = LumonTestVariables.businessTypes[0];       
        String district = LumonTestVariables.districts[0];
        String profitCenter = LumonTestVariables.profitCenters[0];
        String customer = '';
        String costType = LumonTestVariables.costTypes[0];
        String productGroup= LumonTestVariables.productGroups[0];
        Product_Cost__c productCostEntry = PriceMultiplierController.getProductCost(productGroup,costType,org,country,businessType,district); 
        System.assertNotEquals(null,String.isNotBlank(productCostEntry.Id), 'Expecting a Item to be returned');
        System.debug('--- PriceMultiplierController - getProductCostTest - CPU TIME: '+LIMITS.getCpuTime()); 
    }
    @IsTest
    static void getSalesPriceTest(){ 
        String org = LumonTestVariables.organizations[0];
        String country = LumonTestVariables.countries[0];
        String businessType = LumonTestVariables.businessTypes[0];
        String district = LumonTestVariables.districts[0];
        String profitCenter = LumonTestVariables.profitCenters[0];
        String customer = '';
        String costType = LumonTestVariables.costTypes[0];
        String productGroup= LumonTestVariables.productGroups[0];
        Sales_Price__c salesPriceEntry = PriceMultiplierController.getSalesPrice(productGroup,costType,org,country,businessType,district,profitCenter,customer); 
        System.assertNotEquals(null,String.isNotBlank(salesPriceEntry.Id), 'Expecting a Item to be returned');
        System.debug('--- PriceMultiplierController - getSalesPriceTest - CPU TIME: '+LIMITS.getCpuTime()); 
    }
}