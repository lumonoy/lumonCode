/**
 * @description       : NOT IN USE
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 10-09-2024
 * @last modified by  : Henk Reynders
**/
public with sharing class PricingPaymentInstallmentsController {
    /*public with sharing class ComponentData {
        @AuraEnabled
        public Quote quote { get; private set; }
        @AuraEnabled
        public Opportunity opportunity { get; private set; }
        @AuraEnabled
        public List<Payment_Batch__c> items { get; private set; }
        public ComponentData(Id recordId) {
            opportunity = OpportunityController.getOpportunity(recordId);
            try {
                quote = QuoteController.getQuote(opportunity.SyncedQuoteId);
            } catch (Exception e) {
                throw new PricingSummaryService.PricingDataException('The synced quote can\'t be found');
            }
            items = [
                SELECT Amount__c, Description__c, Number__c, Type__c
                FROM Payment_Batch__c
                WHERE Payment_Plan__r.Opportunity__c = :opportunity.Id
            ];
        }
    }

    @AuraEnabled(cacheable=false)
    public static ComponentData getComponentData(Id recordId) {
        return new ComponentData(recordId);
    }*/
}