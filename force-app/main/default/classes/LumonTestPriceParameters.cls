/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-12-2023
 * @last modified by  : Henk Reynders
**/
@isTest
public with sharing class LumonTestPriceParameters {
	@TestVisible private static List<Factory_Price__c> factoryPrices{
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
    @TestVisible private static List<Product_Cost__c> productCosts{
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
    @TestVisible private static List<Sales_Price__c> salesPrices{
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
        setupPriceParameters(productIds);
    }
    public static void setupPriceParameters(list<Id> productIds) {
        List<Product2> products = [SELECT Id, ProductCode,Product_Group__c,Cost_Type__c,IsActive FROM Product2 WHERE Id IN:productIds];
        Map<String,List<String>> productGroupMap = new Map<String,List<String>>();
        List<String> productGroups = new List<String>();
        List<String> costTypes = new List<String>();
        List<AggregateResult> aggrGroupCosttype = [SELECT Count(Id) productCount, Product_Group__c productGroup,Cost_Type__c costType FROM Product2
                                                   group by Product_Group__c, Cost_Type__c];
        if(aggrGroupCosttype != null && aggrGroupCosttype.size() > 0){ 
            for(AggregateResult agr : aggrGroupCosttype){
                String productGroup = (STRING) agr.get('productGroup');
                String costType = (STRING) agr.get('costType');
                //System.debug('--- productGroup: '+productGroup);
                //System.debug('--- costType: '+costType);
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
        String org = 'LSU';
        String country = 'FI';
        String businessType = 'Consumer';
        List<String> districts = New List<String>{'FI_North','FI_South','FI_West','FI_East'};
        String profit = '4043 LSU Oulu';
        List<Factory_Price__c> fps = new List<Factory_Price__c>();
        List<Product_Cost__c> pcs = new List<Product_Cost__c>();
        List<Sales_Price__c> sps = new List<Sales_Price__c>();
        
        for (String pg : productGroupMap.keySet()) {
            for (String  ct: productGroupMap.get(pg)) {
                Factory_Price__c fp = new Factory_Price__c();
                fp.Organization__c = org;
                fp.Country__c = country;
                fp.Business_Type__c = businessType;
                fp.Product_Group__c = pg;
                fp.Cost_Type__c = ct;
                fp.Factory_Multiplier__c = 10.0;
                fp.IsActive__c  = true;
                fps.add(fp);
                for (String district : districts) {
                    Product_Cost__c pc = new Product_Cost__c();
                    pc.Organization__c = org;
                    pc.Country__c = country;
                    pc.Business_Type__c = businessType;
                    pc.District__c = district;
                    pc.Product_Group__c = pg;
                    pc.Cost_Type__c = ct;
                    pc.Cost_Multiplier__c = 20.0;
                    pc.IsActive__c  = true;
                    pcs.add(pc);
                    Sales_Price__c sp = new Sales_Price__c();
                    sp.Organization__c = org;
                    sp.Country__c = country;
                    sp.Business_Type__c = businessType;
                    sp.District__c = district;
                    sp.Profit_Center__c = profit;
                    sp.Product_Group__c = pg;
                    sp.Cost_Type__c = ct;
                    sp.Sales_Multiplier__c = 30.0;
                    sp.IsActive__c  = true;
                    sps.add(sp);
                }
            }
        }
        insert fps;
        insert pcs;
        insert sps;
        System.debug('--- setupPriceParameters - Factory: '+fps);
        System.debug('--- setupPriceParameters - Cost: '+pcs);
        System.debug('--- setupPriceParameters - Sales: '+sps);
    }
    @IsTest
    static void setupPriceParametersTest(){
        String testResult;
        List<Product2> products = LumonTestProducts.setupProducts();
        List<Id> productIds = new List<Id>(new Map<Id, Product2>(products).keySet()); 
        Test.startTest();
        Try {
            setupPriceParameters(productIds);
            testResult = 'successfully inserted Price Parameters';
            System.debug('--- setupPriceParametersTest - Factory: '+factoryPrices);
            System.debug('--- setupPriceParametersTest - Cost: '+productCosts);
            System.debug('--- setupPriceParametersTest - Sales: '+salesPrices);
        } catch (exception e){
            testResult = 'error when inserting Price Parameters: '+e.getMessage();
        }
        Test.stopTest();
        System.debug('--- setupPriceParametersTest: '+testResult);
        System.AssertNotEquals(true, testResult.contains('error'));
    }
}