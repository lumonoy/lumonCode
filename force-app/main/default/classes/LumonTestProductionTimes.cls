/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-10-2023
 * @last modified by  : Henk Reynders
**/
@isTest
public with sharing class LumonTestProductionTimes {
    @TestVisible private static List<Production_Time__c> productionDays{
        get{
            return [SELECT Id,Product__c, Days__c,Extra_Days__c,IsActive__c FROM Production_Time__c WHERE (IsActive__c = true) AND Days__c > 0];
        }
    }
    @TestVisible private static List<Production_Time__c> extraDays{
        get{
            return [SELECT Id,Product__c, Days__c,Extra_Days__c,IsActive__c FROM Production_Time__c WHERE (IsActive__c = true) AND Extra_Days__c > 0];
        }
    }
    public static void setupProductionTimes(){
        List<Product2> products = [SELECT Id, ProductCode,Product_Group__c,Cost_Type__c,IsActive FROM Product2];
        List<Id> productIds = new List<Id>(new Map<Id, Product2>(products).keySet()); 
        setupProductionTimes(productIds);
    }
    public static void setupProductionTimes(list<Id> productIds) {
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
                if (costType == 'tuotteet' || costType == 'verhot') {
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
                }
                //System.debug('--- productGroupMap:'+productGroupMap);
            }
            System.debug('--- productGroups: '+productGroups);
        }
        List<Product2> validProducts = [SELECT Id, Name,ProductCode,Product_Group__c,Cost_Type__c,IsActive,Special__c FROM Product2 WHERE Id IN:productIds AND Product_Group__c IN: productGroups];
        List<Production_Time__c> pts = new List<Production_Time__c>();
        Factory__c factory = new Factory__c(Name = 'Test Factory');
        insert factory;
        
        for (Product2 p : validProducts) {
            Production_Time__c pt = new Production_Time__c();
            //System.debug('--- Product Group '+p.Product_Group__c);
            //System.debug('--- Product Code '+p.ProductCode);
            
            if (p.ProductCode == p.Product_Group__c) {
                pt.Days__c=22;
                pt.Extra_Days__c=0;
                System.debug('--- Production Days for '+p.Name);
            } else if (p.productCode == p.Product_Group__c+'-SPECIAL') {
                pt.Days__c=0;
                pt.Extra_Days__c=3;
                System.debug('--- Extra Production Days for '+p.Name);
            } else {
                //System.debug('--- No Production Days for '+p.Name);
                continue;
            }
            pt.Factory__c =factory.Id;
            pt.Product__c=p.Id;
            pt.IsActive__c=true;
            pts.add(pt);
        }
        insert pts;
    }
    @IsTest
    static void setupProductionTimesTest(){
        String testResult;
        LumonTestProducts.setupProducts();
        Test.startTest();
        Try {
            setupProductionTimes();
            testResult = 'successfully inserted Production Times';
            System.debug('--- setupProductionTimesTest - Days: '+productionDays);
            System.debug('--- setupProductionTimesTest - Extra Days: '+extraDays);
        } catch (exception e){
            testResult = 'error when inserting Production Times: '+e.getMessage();
        }
        Test.stopTest();
        System.debug('--- setupProductionTimesTest: '+testResult);
        System.AssertNotEquals(true, testResult.contains('error'));
    }
}