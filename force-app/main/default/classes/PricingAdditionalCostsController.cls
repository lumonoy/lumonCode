/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-02-2023
 * @last modified by  : Henk Reynders
**/
public with sharing class PricingAdditionalCostsController {
    @TestVisible
    public static final String ADDITIONAL_COST_PRODUCT_GROUP = 'LISAKUSTAN'; // Not used at the moment as Additional Costs relate to a Main Product
    @TestVisible
    public static final String ADDITIONAL_COST_PRODUCT_CATEGORY = 'Additional Costs';

    public with sharing class ComponentData {
        @AuraEnabled
        public Quote quote { get; private set; }
        @AuraEnabled
        public Boolean disabled { get; private set; }
        @AuraEnabled
        public Opportunity opportunity { get; private set; }
        @AuraEnabled
        public Boolean showAddCosts { get; private set; }
        @AuraEnabled
        public Map<String, List<PricingSummaryService.PicklistOption>> picklistValues { get; private set; }
        @AuraEnabled
        public Map<String, List<String>> picklistDependencies { get; private set; }
        @TestVisible
        @AuraEnabled
        public List<QuoteLineItem> quoteLineItems { get; private set; }
        public ComponentData(Id recordId) {
            opportunity = PricingSummaryService.queryOpportunity(recordId);
            try {
                quote = PricingSummaryService.queryQuote(opportunity.SyncedQuoteId);
            } catch (Exception e) {
                throw new PricingSummaryService.PricingDataException('The synced quote can\'t be found');
            }
            showAddCosts = PricingSummaryService.queryPricingSummary(opportunity.Id, quote.Id) != null
                && PricingSummaryService.opportunityHasProductItems(quote.Id)
                && !PricingSummaryService.componentDisabled(opportunity);
            quoteLineItems = [
                SELECT
                    Id,
                    Description,
                    QuoteId,
                    Product2Id,
                    Product2.Name,
                    Product2.ProductCode,
                    Product2.Product_Group__c,
                    Product2.Cost_Category__c,
                    Product2.Cost_Type__c,
                    Product2.Unit_Of_Measure__c,
                    Product2.Sales_Code__c,
                    Cost_Category__c,
                    Cost_Type__c,
                    toLabel(Cost_Type__c) costTypeLabel,
                    Product_Group__c,
                    toLabel(Product_Group__c) productGroupLabel,
                    Quantity,
                    List_Price__c,
                    UnitPrice,
                    ListPrice,
                    Min_Sales_Price__c,
                    Min_Price__c,
                    Transmission__c,
                    Discount,
                    Discount__c,
                    fxDiscount__c,
                    CurrencyIsoCode,
                    fxFactory__c,
                    Factory_Price__c,
                    fxCost__c,
                    Product_Cost__c,
                    fxSales__c,
                    Sales_Margin__c,
                    SubTotal,
                    TotalPrice,
                    Product_Code__c,
                    Base_Price__c,
                    Max_Quantity__c,
                    Configuration_Product__c,
                    Sales_Code__c
                FROM QuoteLineItem
                WHERE QuoteId = :quote.Id AND Product2.Product_Category__c = :ADDITIONAL_COST_PRODUCT_CATEGORY
                ORDER BY List_Price__c DESC, Product2.Product_Group__c, Product2.Cost_Type__c
            ];
            // Filter out the duplicate, 0 price items
            List<QuoteLineItem> filtered = new List<QuoteLineItem>();
            Set<String> filteredIds = new Set<String>();
            for(QuoteLineItem qli : quoteLineItems) {
                String filteredId = qli.Product2.Product_Group__c + '-' + qli.Product2.Cost_Type__c;
                if(!filteredIds.contains(filteredId)) {
                    filtered.add(qli);
                    filteredIds.add(filteredId);
                }
            }
            quoteLineItems = filtered;
            picklistValues = new Map<String, List<PricingSummaryService.PicklistOption>>{
                'Product_Group__c' => findAdditionalCostProductGroups(
                    PricingSummaryService.getQuoteLineItems(quote.Id)
                ),
                'Cost_Type__c' => findAdditionalCostCostTypes(opportunity.Pricebook2Id)
            };
        }
    }

    @AuraEnabled(cacheable=false)
    public static ComponentData getComponentData(Id recordId) {
        return new ComponentData(recordId);
    }

    @AuraEnabled
    public static void deleteAdditionalCost(Id opportunityId, Id quoteLineItemId) {
        QuoteLineItem quoteLineItem = [
            SELECT Id, Product2.Product_Group__c, Product2.Cost_Type__c
            FROM QuoteLineItem WHERE Id = :quoteLineItemId LIMIT 1
        ];
        List<QuoteLineItem> quoteLineItems = [
            SELECT Id
            FROM QuoteLineItem
            WHERE Quote.OpportunityId = :opportunityId
            AND Product2.Product_Group__c = :quoteLineItem.Product2.Product_Group__c
            AND Product2.Cost_Type__c = :quoteLineItem.Product2.Cost_Type__c
        ];
        if(!quoteLineItems.isEmpty()) {
            delete quoteLineItems;
        }
        PricingController.upsertQuoteLines(opportunityId);
    }

    @AuraEnabled
    public static String saveAdditionalCost(
        Id opportunityId,
        QuoteLineItem quoteLineItem,
        QuoteLineItem quoteLineItemWithPrices
    ) {
        Opportunity opportunity = PricingSummaryService.queryOpportunity(opportunityId);
        Quote quote = PricingSummaryService.queryQuote(opportunity.SyncedQuoteId);
        quoteLineItemWithPrices.Description = quoteLineItem.Description;

        Product2 product = [
            SELECT Product_Group__c, Cost_Type__c, Sales_Code__c
            FROM Product2 WHERE Id = :quoteLineItem.Product2Id
            LIMIT 1
        ];
        String productGroup = product.Product_Group__c;
        String costType = product.Cost_Type__c;
        String salesCode = product.Sales_Code__c;
        
        List<QuoteLineItem> oldQuoteLineItems = opportunity.SyncedQuoteId != null ? [
            SELECT Id FROM QuoteLineItem
            WHERE QuoteId = :opportunity.SyncedQuoteId
                AND Product_Group__c = :productGroup
                AND Cost_Type__c = :costType
        ] : new List<QuoteLineItem>();
        System.debug(oldQuoteLineItems);
        if(!oldQuoteLineItems.isEmpty()) {
            delete oldQuoteLineItems;
        }

        Integer maxQuoteLineItemNumber = 0;
        try {
            maxQuoteLineItemNumber = Integer.valueOf([
                SELECT MAX(Line_Number__c) FROM QuoteLineItem WHERE Quote.OpportunityId = :opportunityId][0].get('expr0')
            );
            if(maxQuoteLineItemNumber == null) {
                maxQuoteLineItemNumber = 1000;
            }
        } catch(Exception e) {
            maxQuoteLineItemNumber = 1000;
        }

        Id pricebook2Id = quote.Pricebook2Id;
        if(Test.isRunningTest()){
            //Invoke mock web service response
            pricebook2Id = Test.getStandardPricebookId();
        }
        PriceBookEntry entry = [
            SELECT Id, Product2Id
            FROM PriceBookEntry
            WHERE
                PriceBook2Id = :pricebook2Id
                AND Product2.Product_Group__c = :productGroup
                AND Product2.Cost_Type__c = :costType
                AND Product2.Product_Category__c = :ADDITIONAL_COST_PRODUCT_CATEGORY
                AND IsActive = TRUE
            LIMIT 1
        ];

        List<Configuration_Product__c> configurationProducts = [
            SELECT Id, RVN__c
            FROM Configuration_Product__c
            WHERE Product_Group__c = :productGroup
                AND Configuration__r.Opportunity__c = :opportunityId
        ];
        List<QuoteLineItem> newQuoteLineItems = new List<QuoteLineItem>();
        for(Integer i = 0; i < configurationProducts.size(); i++) {
            quoteLineItemWithPrices.Id = null;
            quoteLineItemWithPrices.Line_Number__c = maxQuoteLineItemNumber + 1 + i;
            quoteLineItemWithPrices.QuoteId = opportunity.SyncedQuoteId;
            quoteLineItemWithPrices.PriceBookEntryId = entry.Id;
            quoteLineItemWithPrices.Product2Id = entry.Product2Id;
            quoteLineItemWithPrices.Max_Quantity__c = 1;
            quoteLineItemWithPrices.Configuration_Product__c = configurationProducts.get(i).Id;
            quoteLineItemWithPrices.Sales_Code__c = productGroup + salesCode;
            quoteLineItemWithPrices.RVN_Number__c = configurationProducts.get(i).RVN__c;
            newQuoteLineItems.add(quoteLineItemWithPrices.clone());
        }
        upsert newQuoteLineItems;
        PricingController.upsertQuoteLines(opportunityId);
        return null;
    }

    public static List<PricingSummaryService.PicklistOption> findAdditionalCostProductGroups(
        List<QuoteLineItem> items
    ) {
        Map<String, PricingSummaryService.PicklistOption> productGroupPicklistOptions = new Map<String, PricingSummaryService.PicklistOption>();
        for (
            PricingSummaryService.PicklistOption option : PricingSummaryService.getPicklistOptions(
                Product2.Product_Group__c
            )
        ) {
            productGroupPicklistOptions.put(option.value, option);
        }
        List<String> orderedGroupNames = new List<String>();
        Map<String, String> groupNamesByName = new Map<String, String>();
        for (QuoteLineItem item : items) {
            String groupName = item.Product2.Product_Group__c;
            if (item.Product2.Product_Category__c == 'Product Options' && !groupNamesByName.containsKey(groupName)) {
                orderedGroupNames.add(groupName);
                groupNamesByName.put(groupName, productGroupPicklistOptions.get(item.Product2.Product_Group__c).label);
            }
        }
        orderedGroupNames.sort();
        List<PricingSummaryService.PicklistOption> options = new List<PricingSummaryService.PicklistOption>();
        for (String groupName : orderedGroupNames) {
            options.add(new PricingSummaryService.PicklistOption(groupName, groupNamesByName.get(groupName)));
        }
        return options;
    }

    public static List<PricingSummaryService.PicklistOption> findAdditionalCostCostTypes(Id pricebookId) {
        // TODO the LISÄKUSTAN entries are not active
        List<PriceBookEntry> entries = [
            SELECT Id, Product2Id, Product2.Cost_Type__c
            FROM PriceBookEntry
            WHERE
                PriceBook2Id = :pricebookId
                //AND Product2.Product_Group__c = :ADDITIONAL_COST_PRODUCT_GROUP
            	AND Product2.Product_Category__c = :ADDITIONAL_COST_PRODUCT_CATEGORY
                AND IsActive = TRUE
        ];
        List<Id> productIds = new List<Id>();
        for (PricebookEntry entry : entries) {
            productIds.add(entry.Product2Id);
        }
        List<Product2> products = [
            SELECT Cost_Type__c, Product_Group__c, toLabel(Cost_Type__c) costTypeLabel
            FROM Product2
            WHERE Id IN :productIds
        ];
        List<PricingSummaryService.PicklistOption> options = new List<PricingSummaryService.PicklistOption>();
        Set<String> uniqueCostTypes = new Set<String>();
        for (Product2 prod : products) {
            if (!uniqueCostTypes.contains(prod.Cost_Type__c)) {
                options.add(
                    new PricingSummaryService.PicklistOption(prod.Cost_Type__c, (String) prod.get('costTypeLabel'))
                );
                uniqueCostTypes.add(prod.Cost_Type__c);
            }
        }
        return options;
    }

    @AuraEnabled
    public static Product2 findProduct(String opportunityId, String productGroup, String costType) {
        Opportunity opportunity = PricingSummaryService.queryOpportunity(opportunityId);
        Quote quote = PricingSummaryService.queryQuote(opportunity.SyncedQuoteId);
        return PricingSummaryService.findProduct([
                SELECT Product2Id
                FROM PricebookEntry
                WHERE
                    PriceBook2Id = :quote.Pricebook2Id
                    AND Product2.Product_Group__c = :productGroup
                    AND Product2.Cost_Type__c = :costType
                    AND Product2.Product_Category__c = :ADDITIONAL_COST_PRODUCT_CATEGORY
                    AND IsActive = TRUE
                LIMIT 1
        ].Product2Id);
    }

    @AuraEnabled
    public static QuoteLineItem findPrices(String opportunityId, String productId, Decimal basePrice) {
        Product2 product = PricingSummaryService.findProduct(productId);
        return PricingSummaryService.findPrices(
            opportunityId,
            product.ProductCode,
            1,
            product.Product_Group__c,
            product.Cost_Type__c,
            basePrice
        );
    }
}