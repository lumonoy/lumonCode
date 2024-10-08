/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 05-15-2024
 * @last modified by  : Henk Reynders
**/
@isTest
public class LumonTestOpportunityProducts {
    public static void setupOpportunityProducts() {
        List<Opportunity> opportunities = LumonTestVariables.opportunities;
        if (opportunities.size()>0){
            System.debug('--- LumonTestOpportunityProducts - Using existing Test Opportunities');
        } else {
            LumonTestOpportunities.setupOpportunityData();
        }
        for (Opportunity opportunity : opportunities){
            setupOpportunityProducts(opportunity.Id);
        }
    }
    public static void setupOpportunityProducts(Id opportunityId) {
        List<Configuration_Option__c> configOptions = LumonTestVariables.configOptions;
        setupOpportunityProducts(opportunityId,configOptions);
    }
    public static void setupOpportunityProducts(Id opportunityId, List<Configuration_Option__c> configOptions) {
        List<PricebookEntry> pricebookEntries = LumonTestVariables.pricebookEntries;
        List<OpportunityLineItem> opportunityLineItems = new List<OpportunityLineItem >();
        Map<String,PricebookEntry> priceMap = new Map<String,PricebookEntry>();
        for (PricebookEntry pbe : pricebookEntries) {
            String productCode = pbe.Product2.ProductCode;
            priceMap.put(productCode,pbe);
        }
        if(!configOptions.isEmpty()){
            for (Configuration_Option__c configOption : configOptions){         
                OpportunityLineItem op = new OpportunityLineItem();
                op.OpportunityId=opportunityId;
                op.Product2Id=configOption.Product__c;               
                op.PricebookEntryId=priceMap.get(configOption.Product__r.ProductCode)?.Id;
                op.Quantity=1;
                op.UnitPrice=priceMap.get(configOption.Product__r.ProductCode)?.UnitPrice;
                opportunityLineItems.add(op);
            }
        }
        insert opportunityLineItems;
    }


    public static void setupOpportunityProductData() {
        try {
                setupOpportunityProducts();
        }catch (Exception e){
            System.debug('--- LumonTestOpportunityProducts - Error setupConfigurationData Exception '+e);
        } 
    }
    @TestSetup
    static void prepareData() {
        Test.startTest();
        List<Opportunity> opportunities = LumonTestVariables.opportunities;
        if (opportunities.size()>0) {
            System.debug('--- LumonTestOpportunityLines - Using existing Opportunities');
        } else {
            LumonTestOpportunities.setupOpportunityData();
        }
        List<Configuration_Option__c> configOptions = LumonTestVariables.configOptions;
        if (configOptions.size()>0) {
            System.debug('--- LumonTestOpportunityLines - Using existing Configuration Options');
        } else {
            LumonTestConfigurationOptions.setupConfigurationOptionData();
        }
        Test.stopTest();
    }
    @IsTest
    static void setupOpportunityProductDataTest(){
        String testResult;
        Test.startTest();
        try {
            setupOpportunityProductData();
            testResult = 'successfully inserted Opportunity Lines';
        } catch (exception e){
            testResult = 'Error when inserting Opportunity Lines: '+e.getMessage();
        }
        System.debug('--- LumonTestOpportunityProducts - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestOpportunityProducts - Queries used: '+LIMITS.getQueries());
        Test.stopTest();       
        System.AssertNotEquals(true, testResult.contains('Error'));
    }
}