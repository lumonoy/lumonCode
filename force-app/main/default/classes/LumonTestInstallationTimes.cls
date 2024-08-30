/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-10-2023
 * @last modified by  : Henk Reynders
**/
@isTest
public with sharing  class LumonTestInstallationTimes {
	@TestVisible private static List<Installation_Time__c> installationTimes{
        get{
            return [SELECT Id,Product__c, Hours__c,Minutes__c,IsActive__c FROM Installation_Time__c WHERE (IsActive__c = true)];
        }
    }
    public static void setupInstallationTimes(){
        List<Product2> products = [SELECT Id, ProductCode,Product_Group__c,Cost_Type__c,IsActive FROM Product2];
        List<Id> productIds = new List<Id>(new Map<Id, Product2>(products).keySet()); 
        setupInstallationTimes(productIds);
    }
    public static void setupInstallationTimes(list<Id> productIds) {
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
                if (costType == 'askuormitu') {
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
        List<Product2> validProducts = [SELECT Id, ProductCode,Product_Group__c,Cost_Type__c,IsActive FROM Product2 WHERE Id IN:productIds AND Product_Group__c IN: productGroups];
        List<Installation_Time__c> its = new List<Installation_Time__c>();
        for (Product2 p : validProducts) {
            Installation_Time__c it = new Installation_Time__c();
            it.Hours__c=1;
            it.Product__c=p.Id;
            it.IsActive__c=true;
            its.add(it);
        }
        insert its;
    }
    @IsTest
    static void setupInstallationTimesTest(){
        String testResult;
        LumonTestProducts.setupProducts();
        Test.startTest();
        Try {
            setupInstallationTimes();
            testResult = 'successfully inserted Installation Times';
            System.debug('--- setupInstallationTimesTest - Times: '+installationTimes);
        } catch (exception e){
            testResult = 'error when inserting Installation Times: '+e.getMessage();
        }
        Test.stopTest();
        System.debug('--- setupInstallationTimesTest: '+testResult);
        System.AssertNotEquals(true, testResult.contains('error'));
    }
}