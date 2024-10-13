/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 09-20-2024
 * @last modified by  : Henk Reynders
**/
@isTest
public class LumonTestPricingSummaries {
	public static Id setupPricingSummary(Id opportunityId) {        
        Opportunity opp = [SELECT Id,AccountId, SyncedQuoteId,
                                  Organization__c,Business_Type__c ,
                           			Country_Attribute__c,District__c,
                           			OwnerId, Owner_Profit_Center__c, Owner_Office__c
                          FROM Opportunity WHERE Id =:OpportunityId LIMIT 1];
        Id accountId = opp.AccountId;
        Id quoteId = opp.SyncedQuoteId;
        Id owner = opp.OwnerId;
        String org = opp.Organization__c;
        String business = opp.Business_Type__c;
        String district = opp.District__c;
        String country = opp.Country_Attribute__c;
        String profit = opp.Owner_Profit_Center__c;
        String office = opp.Owner_Office__c;
        Pricing_Summary__c summary = new Pricing_Summary__c();
        summary.Opportunity__c = opportunityId; 
        summary.Organization__c = org; 
        summary.Country_Code__c = country;
        summary.Business_Type__c = business;
        summary.District__c = district;
        summary.Profit_Center__c = profit;
        summary.Office__c = office;
		summary.User__c = owner;// Related Record
        summary.Account__c = accountId; // Related Record
        summary.Quote__c = quoteId; // Related Record
        //summary.Order__c; // Related Record
        //summary.Contract__c; // Related Record
        summary.currencyIsoCode = 'EUR';
		upsert summary;
        return summary.Id;
    }
    public static void setupPricingSummaryB2C(){ 
        Id b2cOpportunityId = LumonTestVariables.b2cOpportunityId;
        setupPricingSummary(b2cOpportunityId);
    } 
    public static void setupPricingSummaryB2B(){ 
        Id b2cOpportunityId = LumonTestVariables.b2cOpportunityId;
        setupPricingSummary(b2cOpportunityId);
    } 
    public static void setupPricingSummaryData(){ 
        setupPricingSummaryB2C();
        setupPricingSummaryB2B();
    }  
    @TestSetup
    static void prepareData() {
        List<Opportunity> opportunities = LumonTestVariables.opportunities;
        Test.startTest();
        if (Opportunities?.size()>0){
            system.debug('--- LumonTestPricingSummaries - Using existing Test Opportunities');
        } else {
            LumonTestOpportunities.setupOpportunityData();
        }
        Id b2cOpportunityId = LumonTestVariables.b2cOpportunityId;
        if (String.isBlank(b2cOpportunityId)){
            LumonTestOpportunities.setupOpportunityB2C();
        }
        Id b2bOpportunityId = LumonTestVariables.b2bOpportunityId;
        if (String.isBlank(b2bOpportunityId)){
            LumonTestOpportunities.setupOpportunityB2B();
        }
        Test.stopTest();
    }
    @IsTest
    static void setupPricingSummaryDataTest(){
        String testResult;
        Test.startTest();
        try {
            setupPricingSummaryData();
            testResult = 'successfully inserted Pricing Summaries';
            List<Pricing_Summary__c> pricingSummaries = LumonTestVariables.pricingSummaries;
        } catch (exception e){
            testResult = 'Error when inserting Opportunities: '+e.getMessage();
        }
        System.debug('--- LumonTestPricingSummaries - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestPricingSummaries - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();    
        System.debug('--- LumonTestPricingSummaries - Test Result: '+testResult);   
        System.AssertNotEquals(true, testResult.contains('Error'));      
    }
}