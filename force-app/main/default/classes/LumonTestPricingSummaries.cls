/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-03-2023
 * @last modified by  : Henk Reynders
**/
@isTest
public with sharing  class LumonTestPricingSummaries {
    @TestVisible private static List<Pricing_Summary__c> b2cPricingSummaries{
        get{
            return  [SELECT Id FROM Pricing_Summary__c];
        }
    }
	public static Id setupPricingSummaryB2C(Id opportunityId) {        
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
}