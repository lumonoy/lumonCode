/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 05-10-2024
 * @last modified by  : Henk Reynders
**/
@isTest
public class LumonTestProductionTimes {
    public static void setupProductionTimes(){
        List<Id> productIds = LumonTestVariables.productIds;
        setupProductionTimes(productIds);
    }
    public static void setupProductionTimes(list<Id> productIds) {
        List<Production_Time__c> pts = new List<Production_Time__c>();
        Factory__c factory = new Factory__c(Name = 'Test Factory');
        insert factory;     
        List<Product2> products = LumonTestVariables.products;  
        for (Product2 p : products) {
            if (p.QuantityUnitOfMeasure != 'h'){
                Production_Time__c pt = new Production_Time__c();
                if (p.ProductCode == p.Product_Group__c) {
                    pt.Days__c=22;
                    pt.Extra_Days__c=0;
                    System.debug('--- LumonTestProductionTimes - Production Days for '+p.Name);
                } else if (p.productCode == p.Product_Group__c+'-SPECIAL') {
                    pt.Days__c=0;
                    pt.Extra_Days__c=3;
                    System.debug('--- LumonTestProductionTimes - Extra Production Days for '+p.Name);
                } else {
                    //System.debug('--- No Production Days for '+p.Name);
                    continue;
                }
                pt.Factory__c =factory.Id;
                pt.Product__c=p.Id;
                pt.IsActive__c=true;
                pts.add(pt);
            }
        }
        insert pts;
    }
    public static void setupProductionTimeData(){
        List<Product2> products = LumonTestVariables.products;  
        if(products?.size()>0){
            System.debug('--- LumonTestProductionTime - Using existing Products');
        } else {
            LumonTestProducts.setupProductData();
        }
        setupProductionTimes();
        List<Production_Time__c> productionTimes = LumonTestVariables.productionTimes;
        System.debug('--- LumonTestProductionTimes - productionTimes '+products.size()+' Production Times'); 
    }  
    @TestSetup
    static void prepareData() {
        List<Product2> products = LumonTestVariables.products;
        List<PricebookEntry> pricebookEntries = LumonTestVariables.pricebookEntries;
        Test.startTest();
        if(products?.size()>0){
            System.debug('--- LumonTestProductionTime - Using existing Products');
        } else {
            LumonTestProducts.setupProductData();
        }
        if(pricebookEntries?.size()>0){
            System.debug('--- LumonTestProductionTime - Using existing pricebookEntries');
        } else {
            LumonTestPricebooks.setupPricebookData();
        }
        Test.stopTest();
    }
    @Istest
    public static void setupProductionTimeDataTest(){
        String testResult;
        Test.startTest();
        try {
            setupProductionTimeData();
            List<Production_Time__c> productionTimes = LumonTestVariables.productionTimes;
            testResult = ('Inserted '+productionTimes.size()+' Test Production Times');
            System.assertNotEquals(0,productionTimes.size(), 'Expected Production Times to be Created');
        } catch (exception e){
            testResult = ('Error when inserting Production Times: '+e.getMessage());
        }
        Test.stopTest();
        System.debug('LumonTestProductionTime - result: '+testResult);
        System.AssertNotEquals(true, testResult.contains('error'));
    }
}