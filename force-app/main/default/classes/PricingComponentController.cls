/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 03-19-2024
 * @last modified by  : Henk Reynders
**/
public class PricingComponentController {
    public with sharing class ComponentData {
        @AuraEnabled
        public Quote quote { get; private set; }
        @AuraEnabled
        public Opportunity opportunity { get; private set; }
        @AuraEnabled
        public Pricing_Summary__c pricingSummary { get; private set; }
        @AuraEnabled
        public Boolean isAdmin { get; private set; }
        @AuraEnabled
        public Boolean isManager { get; private set; }
        @AuraEnabled
        public Boolean isSupport { get; private set; }
        @AuraEnabled
        public Boolean isSales { get; private set; }
        @AuraEnabled
        public Boolean isService { get; private set; }
        @AuraEnabled
        public Decimal maxDiscount { get; private set; }
        @AuraEnabled
        public Boolean debugMode { get; private set; }
        @AuraEnabled
        public Boolean disabled { get; private set; }
        @AuraEnabled
        public Map<String, List<PricingSummaryService.PicklistOption>> fieldLabels { get; private set; }
        
        @TestVisible
        @AuraEnabled
        public List<QuoteLineItem> quoteLineItems { get; private set; }
        public ComponentData(Id recordId) {
            //isAdmin = PricingSummaryService.isAdmin();
            // Check the Role of the User
            Role_Settings__c roleSettings = RoleSettingsController.getRoleSettingsMap().get(UserInfo.getProfileId());
            isAdmin = roleSettings.isAdmin__c;
            isManager = roleSettings.isManager__c;           
            isSales = roleSettings.isSales__c;
            isService = roleSettings.isService__c;
            isSupport = roleSettings.isSupport__c;
            // Check the max Discount per Profile
            maxDiscount = CPQSettingsController.getCPQSettingsMap().get(UserInfo.getProfileId()).maxDiscount__c;
            // Check if debugmode is enabled for the User
            debugMode = CPQSettingsController.getCPQSettingsMap().get(UserInfo.getUserId()).Debug__c;
            // Look for Opportunity if not found trigger exception
            try {
                opportunity = PricingSummaryService.queryOpportunity(recordId);
            } catch (Exception e) {
                throw new PricingSummaryService.PricingDataException('The opportunity can\'t be found');
            }
            // Look for Opportunities Synced Quote if not found trigger exception
            // Pricing only applicable when "Quoting"
            try {
                quote = PricingSummaryService.queryQuote(opportunity.SyncedQuoteId);
            } catch (Exception e) {
                throw new PricingSummaryService.PricingDataException('The synced quote can\'t be found');
            }  
            // Look for Opportunities Pricing Summary if not found trigger exception
            // Always trigger Assign Pricing Summary flow to either get or create the Pricing Summary
            try {
                getPricingSummaryId(opportunity.Id);
            } catch (Exception e) {
                throw new PricingSummaryService.PricingDataException('The pricing summary can\'t be found');
            }
            //new WithoutSharing().upsertPricingSummary(opportunity.Id);
            pricingSummary = PricingSummaryService.queryPricingSummary(opportunity.Id, quote.Id);
            disabled = !PricingSummaryService.ALLOWED_OPPORTUNITY_STAGES.contains(opportunity.StageName);
            quoteLineItems = PricingSummaryService.getQuoteLineItems(quote.Id);
            fieldLabels = new Map<String, List<PricingSummaryService.PicklistOption>> {
                'Cost_Type__c' => PricingSummaryService.getPicklistOptions(Product2.Cost_Type__c),
                'Product_Group__c' => PricingSummaryService.getPicklistOptions(Product2.Product_Group__c)
            };
        }
    }

    @AuraEnabled(cacheable=false)
    public static void getPricingSummaryId(Id recordId) {
        Map<String, Object> params = new Map<String, Object>{
            'recordId' => recordId
        };
        // Create Pricing Summary if none exists using a Flow
        Flow.Interview.Assign_Summary_SubFlow summaryFlow = new Flow.Interview.Assign_Summary_SubFlow(params);
        summaryFlow.start();
        String summaryId = (String)summaryFlow.getvariableValue('pricingSummaryId');
        if (String.isEmpty(summaryId)) {
            throw new PricingSummaryService.PricingDataException('Unable to create Pricing Summary');
        } else {
            System.debug('summaryId::: '+summaryId);
        }
    }

    @AuraEnabled(cacheable=false)
    public static ComponentData getComponentData(Id recordId) {
        return new ComponentData(recordId);
    }

    @AuraEnabled
    public static void saveData(
        String opportunityId,
        Pricing_Summary__c pricingSummary,
        List<QuoteLineItem> quoteLineItems
    ) {
        Opportunity opportunity = PricingSummaryService.queryOpportunity(opportunityId);
        if (!PricingSummaryService.ALLOWED_OPPORTUNITY_STAGES.contains(opportunity.StageName)) {
            throw new PricingSummaryService.PricingDataException(
                'You can only edit pricing of an opportunity in ' +
                    String.join(PricingSummaryService.ALLOWED_OPPORTUNITY_STAGES, ' or ') +
                    ' stages'
            );
        } 
        update pricingSummary;
        update quoteLineItems;
    }
}