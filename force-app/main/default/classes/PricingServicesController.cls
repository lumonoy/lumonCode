/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 11-21-2023
 * @last modified by  : Henk Reynders
**/
public with sharing class PricingServicesController {
    @TestVisible
    public static final List<String> SERVICES_PRODUCT_GROUPS = new List<String>{'HUOLTO','PERUSHUOLTO', 'MÄÄRÄAIKAISHUOLTO','TUNTITYÖ'};

    public with sharing class ComponentData {
        @AuraEnabled
        public Quote quote { get; private set; }
        @AuraEnabled
        public Opportunity opportunity { get; private set; }
        @AuraEnabled
        public Boolean disabled { get; private set; }
        @AuraEnabled
        public Map<String, List<PricingSummaryService.PicklistOption>> picklistValues { get; private set; }
        @AuraEnabled
        public Map<String, Map<String, List<PricingSummaryService.PicklistOption>>> picklistDependencies {
            get;
            private set;
        }
        @TestVisible
        @AuraEnabled
        public List<QuoteLineItem> quoteLineItems { get; private set; }
        public ComponentData(Id recordId) {
            if (recordId.getSobjectType() == Case.getSObjectType()) {
                recordId = [SELECT Reclamation__c FROM Case WHERE Id = :recordId LIMIT 1].Reclamation__c;
            }
            opportunity = PricingSummaryService.queryOpportunity(recordId);
            try {
                quote = PricingSummaryService.queryQuote(opportunity.SyncedQuoteId);
            } catch (Exception e) {
                throw new PricingSummaryService.PricingDataException('The synced quote can\'t be found');
            }
            // Existing additional items
            quoteLineItems = [
                SELECT
                    Id,
                    Description,
                    QuoteId,
                    Product2Id,
                    Product2.Name,
                    Product2.ProductCode,
                    Product2.Cost_Type__c,
                    Product2.Product_Group__c,
                    Product2.Cost_Category__c,
                    Product2.Unit_Of_Measure__c,
                    Product2.QuantityUnitOfMeasure,
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
                    Sales_Multiplier__c,
                    Configuration_Plan__c,
                    Configuration_Product__c,
                    Configuration_Option__c
                FROM QuoteLineItem
                WHERE QuoteId = :quote.Id AND Product2.Product_Group__c IN :SERVICES_PRODUCT_GROUPS
                ORDER BY Product2.Product_Group__c, Product2.Cost_Type__c
            ];

            List<AggregateResult> results = [
                SELECT Product2.Product_Group__c
                FROM QuoteLineItem
                WHERE QuoteId = :quote.Id AND Product2.Product_Group__c != NULL
                GROUP BY Product2.Product_Group__c
            ];
            List<String> productGroups =  SERVICES_PRODUCT_GROUPS;

            List<PricingSummaryService.PicklistOption> costTypeValues = new List<PricingSummaryService.PicklistOption>();
            for (AggregateResult result : [
                SELECT toLabel(Cost_Type__c) costTypeLabel, Cost_Type__c
                FROM Product2
                WHERE
                    IsActive = TRUE
                    AND Cost_Type__c != NULL
                    AND Id IN (
                        SELECT Product2Id
                        FROM PricebookEntry
                        WHERE IsActive = TRUE AND Pricebook2Id = :opportunity.Pricebook2Id
                    )
                    AND Product2.Product_Group__c IN :SERVICES_PRODUCT_GROUPS
                    AND Product2.Product_Category__c NOT IN ('Product Models','Product Groups')
                GROUP BY Cost_Type__c
            ]) {
                costTypeValues.add(
                    new PricingSummaryService.PicklistOption(
                        (String) result.get('Cost_Type__c'),
                        (String) result.get('costTypeLabel')
                    )
                );
            }
            picklistValues = new Map<String, List<PricingSummaryService.PicklistOption>>{
                'Cost_Type__c' => costTypeValues
            };
            List<String> costTypes = new List<String>();
            for (PricingSummaryService.PicklistOption costType : picklistValues.get('Cost_Type__c')) {
                costTypes.add(costType.value);
            }
            picklistDependencies = new Map<String, Map<String, List<PricingSummaryService.PicklistOption>>>{
                'Cost_Type__c' => getRelatedProducts(opportunity.Id, costTypes, productGroups)
            };
            disabled = !PricingSummaryService.ALLOWED_OPPORTUNITY_STAGES.contains(opportunity.StageName);
        }
    }

    @AuraEnabled
    public static Map<String, List<PricingSummaryService.PicklistOption>> getRelatedProducts(
        String opportunityId,
        List<String> costTypes,
        List<String> productGroups
    ) {
        Map<String, List<PricingSummaryService.PicklistOption>> options = new Map<String, List<PricingSummaryService.PicklistOption>>();
        if (costTypes.isEmpty()) {
            return options;
        }
        Opportunity opportunity = PricingSummaryService.queryOpportunity(opportunityId);
        for (PriceBookEntry pbEntry : [
            SELECT Product2Id, Product2.Id, Product2.Name, Product2.Cost_Type__c, Product2.Product_Group__c
            FROM PricebookEntry
            WHERE
                Pricebook2Id = :opportunity.Pricebook2Id
                AND IsActive = TRUE
                AND Product2.Cost_Type__c IN :costTypes
                AND Product2.Product_Group__c = :SERVICES_PRODUCT_GROUPS
                AND Product2.Product_Category__c NOT IN ('Product Models','Product Groups')
            ORDER BY Product2.Cost_Type__c, Product2.Name
        ]) {
            if (!options.containsKey(pbEntry.Product2.Cost_Type__c)) {
                options.put(pbEntry.Product2.Cost_Type__c, new List<PricingSummaryService.PicklistOption>());
            }
            options.get(pbEntry.Product2.Cost_Type__c)
                .add(new PricingSummaryService.PicklistOption(pbEntry.Product2Id, pbEntry.Product2.Name));
        }
        return options;
    }

    @AuraEnabled
    public static Product2 findProduct(String productId) {
        return PricingSummaryService.findProduct(productId);
    }

    @AuraEnabled
    public static QuoteLineItem findPrices(String opportunityId, String productId, Decimal quantity) {
        Product2 product = findProduct(productId);
        return PricingSummaryService.findPrices(
            opportunityId,
            product.ProductCode,
            quantity,
            product.Product_Group__c,
            product.Cost_Type__c
        );
    }

    @AuraEnabled(cacheable=false)
    public static ComponentData getComponentData(Id recordId) {
        return new ComponentData(recordId);
    }

    @AuraEnabled
    public static void deleteItem(Id opportunityId, Id quoteLineItemId) {
        if (
            !PricingSummaryService.ALLOWED_OPPORTUNITY_STAGES.contains(
                PricingSummaryService.queryOpportunity(opportunityId).StageName
            )
        ) {
            return;
        }
        delete new QuoteLineItem(Id = quoteLineItemId);
        PricingController.upsertQuoteLines(opportunityId);
    }

    @AuraEnabled
    public static QuoteLineItem updateItem(Id opportunityId, QuoteLineItem quoteLineItem) {
        QuoteLineItem item = findPrices(opportunityId, quoteLineItem.Product2Id, quoteLineItem.Quantity);
        item.Id = quoteLineItem.Id;
        update item;
        PricingController.upsertQuoteLines(opportunityId);
        return item;
    }

    @AuraEnabled
    public static QuoteLineItem saveItem(Id opportunityId, QuoteLineItem quoteLineItem) {
        if (
            !PricingSummaryService.ALLOWED_OPPORTUNITY_STAGES.contains(
                PricingSummaryService.queryOpportunity(opportunityId).StageName
            )
        ) {
            return null;
        }
        String productGroupCode = quoteLineItem.product2.Product_Group__c;
        Product2 servicesProduct = [
            SELECT Id
            FROM Product2
            WHERE ProductCode =  :productGroupCode 
            LIMIT 1
        ];
        List<Configuration__c> configurations = [
            SELECT Id
            FROM Configuration__c
            WHERE Opportunity__c = :opportunityId AND Plan_Type__c = 'Services'
        ];
        List<Configuration_Product__c> configurationProducts = [
            SELECT Id, RVN__c
            FROM Configuration_Product__c
            WHERE Product__c = :servicesProduct.Id AND Configuration__r.Opportunity__c = :opportunityId
        ];
        if (configurations.isEmpty()) {
            configurations.add(new Configuration__c(Opportunity__c = opportunityId, Plan_Type__c = 'Services'));
            insert configurations;
        }
        if (configurationProducts.isEmpty()) {
            configurationProducts.add(
                new Configuration_Product__c(
                    Configuration__c = configurations.get(0).Id,
                    Product__c = servicesProduct.Id,
                    Quantity__c = 1
                )
            );
            insert configurationProducts;
            configurationProducts = [
                SELECT Id, RVN__c
                FROM Configuration_Product__c
                WHERE Id IN :configurationProducts
            ];
        }

        List<Configuration_Option__c> configurationOptions = new List<Configuration_Option__c>();
        if (quoteLineItem.Configuration_Option__c != null) {
            configurationOptions = [
                SELECT Id
                FROM Configuration_Option__c
                WHERE Id = :quoteLineItem.Configuration_Option__c
            ];
        }
        if (configurationOptions.isEmpty()) {
            configurationOptions.add(
                new Configuration_Option__c(Configuration_Product__c = configurationProducts.get(0).Id)
            );
            insert configurationOptions;
        }
        QuoteLineItem oldItem = quoteLineItem.Id != null
            ? [SELECT Id, Product2Id FROM QuoteLineItem WHERE Id = :quoteLineItem.Id LIMIT 1]
            : null;
        if (oldItem != null && oldItem.Product2Id != quoteLineItem.Product2Id) {
            delete new QuoteLineItem(Id = quoteLineItem.Id);
            quoteLineItem.Id = null;
        }
        quoteLineItem.RVN_Number__c = configurationProducts.get(0).RVN__c;
        quoteLineItem.Configuration_Plan__c = configurations.get(0).Id;
        quoteLineItem.Configuration_Product__c = configurationProducts.get(0).Id;
        quoteLineItem.Configuration_Option__c = configurationOptions.get(0).Id;
        upsert quoteLineItem;
        PricingController.upsertQuoteLines(opportunityId);
        return quoteLineItem;
    }
}