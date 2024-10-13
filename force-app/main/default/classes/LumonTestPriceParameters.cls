/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 10-08-2024
 * @last modified by  : Henk Reynders
**/
@isTest
public with sharing class LumonTestPriceParameters {
    public class CustomException extends Exception {}
    @TestVisible private static List<String> businessTypes = LumonTestData.businessTypes;
    @TestVisible private static List<String> countryCodes = LumonTestData.countryCodes;
    @TestVisible private static List<String> organizations = LumonTestData.organizations;
    @TestVisible private static List<String> districts = LumonTestData.districts;
    @TestVisible private static List<String> profitCenters = LumonTestData.profitCenters;
    @TestVisible private static List<Product2> products = LumonTestProducts.products;
	@TestVisible public static List<Factory_Price__c> factoryPrices{
        get{
            return [SELECT Id, Name,  
                    		Organization__c, Country__c, 
                    		Business_Type__c,
                    		Factory_Multiplier__c, 
                    		IsActive__c, 
                    		Product_Group__c,
                            //Product_Model__c, 
                            Cost_Type__c  
                    FROM Factory_Price__c ];
        }
    }
    @TestVisible public static List<Product_Cost__c> productCosts{
        get{
            return [SELECT Id, Name,  
                    		Organization__c, Country__c, 
                    		Business_Type__c,District__c,
                    		Cost_Multiplier__c, 
                    		IsActive__c, 
                    		Product_Group__c,
                            //Product_Model__c, 
                            Cost_Type__c                    		
                    FROM Product_Cost__c ];
        }
    }
    @TestVisible public static List<Sales_Price__c> salesPrices{
        get{
            return [SELECT Id, Name,   
                    		Organization__c, Country__c, 
                    		Business_Type__c,District__c,
                    		Profit_Center__c,BusinessId__c,
                    		Sales_Multiplier__c, 
                    		IsActive__c, 
                    		Product_Group__c,
                            //Product_Model__c, 
                            Cost_Type__c  
                    FROM Sales_Price__c ];
        }
    }
    public static void setupPriceParameters(){
        List<Product2> products = [SELECT Id, ProductCode,Product_Group__c,Cost_Type__c,IsActive FROM Product2];
        List<Id> productIds = new List<Id>(new Map<Id, Product2>(products).keySet()); 
        Map<String,List<String>> productGroupMap = new Map<String,List<String>>();
        List<String> productGroups = new List<String>();
        List<String> costTypes = new List<String>();
        List<AggregateResult> aggrGroupCosttype = [SELECT Count(Id) productCount, ProductGroup__c productGroup,CostType__c costType FROM Product2
                                                   group by ProductGroup__c, CostType__c];
        if(aggrGroupCosttype != null && aggrGroupCosttype.size() > 0){ 
            for(AggregateResult agr : aggrGroupCosttype){
                String productGroup = (STRING) agr.get('productGroup');
                String costType = (STRING) agr.get('costType');
                System.debug('--- productGroup: '+productGroup);
                System.debug('--- costType: '+costType);
                if (!productGroups.contains(productGroup)) {
                	productGroups.add(productGroup);
                }
                if (!costTypes.contains(costType)) {
                	costTypes.add(costType);  
                }
                if (!productGroupMap.containsKey(productGroup)){
                    productGroupMap.put(productGroup,new List<String>());
                } else {
                    List<String> groupCostTypes = productGroupMap.get(productGroup);
                    groupCostTypes.add(costType);
                    productGroupMap.put(productGroup,groupCostTypes);
                }                
                //System.debug('--- productGroupMap ---'+productGroupMap);
            }
            System.debug('--- productGroups ---'+productGroups);
        }

        List<Factory_Price__c> fps = new List<Factory_Price__c>();
        List<Product_Cost__c> pcs = new List<Product_Cost__c>();
        List<Sales_Price__c> sps = new List<Sales_Price__c>();
        for(String org : organizations){
            for(String countryCode : countryCodes){
                for(String businessType : businessTypes){
                    for(String profitCenter : profitCenters){
                        for (String pg : productGroupMap.keySet()) {
                            for (String  ct: productGroupMap.get(pg)) {
                                Factory_Price__c fp = new Factory_Price__c();
                                fp.Organization__c = org;
                                fp.Country__c = countryCode;
                                fp.BusinessType__c = businessType;
                                fp.ProductGroup__c = pg;
                                fp.CostType__c = ct;
                                fp.FactoryPriceMultiplier__c = 10.0;
                                fp.IsActive__c  = true;
                                fps.add(fp);
                                for (String district : districts) {
                                    Product_Cost__c pc = new Product_Cost__c();
                                    pc.Organization__c = org;
                                    pc.Country__c = countryCode;
                                    pc.BusinessType__c = businessType;
                                    pc.District__c = district;
                                    pc.ProductGroup__c = pg;
                                    pc.CostType__c = ct;
                                    pc.ProductCostMultiplier__c = 20.0;
                                    pc.IsActive__c  = true;
                                    pcs.add(pc);
                                    Sales_Price__c sp = new Sales_Price__c();
                                    sp.Organization__c = org;
                                    sp.Country__c = countryCode;
                                    sp.BusinessType__c = businessType;
                                    sp.District__c = district;
                                    sp.ProfitCenter__c = profitCenter;
                                    sp.ProductGroup__c = pg;
                                    sp.CostType__c = ct;
                                    sp.SalesPriceMultiplier__c = 30.0;
                                    sp.IsActive__c  = true;
                                    sps.add(sp);
                                }
                            }
                        }
                    }
                }
            }
        }
        if (fps.size()>0) {
            insert fps;
            //System.debug('--- setupPriceParameters - Factory: '+fps);
        }
        if (pcs.size()>0) {
            insert pcs;
            //System.debug('--- setupPriceParameters - Cost: '+pcs);
        }
        if (sps.size()>0) {
            insert sps;
            //System.debug('--- setupPriceParameters - Sales: '+sps);
        }  
    }
    public static void setupPriceParameterData(){ 
        if(products?.size()>0){
            System.debug('--- LumonTestPricebooks - Using Existing Products');
        } else {
            lumonTestProducts.setupProductData();
        }
        setupPriceParameters();
    }  
    @TestSetup
    static void prepareData() {
        Test.startTest();
        Test.stopTest();
    }
    @Istest
    public static void setupPriceParametersTest(){
        String testResult;
        Test.startTest();       
        try {
            setupPriceParameters();
            System.debug('--- setupPriceParametersTest - '+factoryPrices.size()+' Factory PriceParameters');
            System.debug('--- setupPriceParametersTest - '+productCosts.size()+' Product PriceParameters');
            System.debug('--- setupPriceParametersTest - '+salesPrices.size()+' Sales PriceParameters');
            Integer totalParameters = 0;
            if (factoryPrices.size()>0 && productCosts.size()>0 && salesPrices.size()>0){
                totalParameters = factoryPrices.size()+ productCosts.size()+ salesPrices.size();
            } 
            testResult = ('Inserted '+totalParameters+' Test PriceParameters');
            System.assertNotEquals(0,totalParameters, 'Expected PriceParameters to be Created');
            
        } catch (exception e){
            testResult = ('Error when inserting PriceParameters: '+e.getMessage());
        }
        System.debug('--- LumonTestPriceParameters - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- LumonTestPriceParameters - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
        System.debug('--- LumonTestPriceParameters - Test Result = '+testResult);
    }
}