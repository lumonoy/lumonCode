/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 03-13-2024
 * @last modified by  : Henk Reynders
**/
public with sharing class PricingSummaryService {
    public static final List<String> ALLOWED_OPPORTUNITY_STAGES = new List<String>{
        //'Preparation & Analysis',
        'Quoting'
    };
    public static final String CONTRACT_SENT_STAGE = 'Contract Sent';

    public class PricingDataException extends Exception {
    }
    public class ComponentDataException extends Exception {
    }

    private class PickListInfo {
        public String validFor;
    }

    public class PicklistOption {
        @AuraEnabled
        public String value { get; private set; }
        @AuraEnabled
        public String label { get; private set; }
        public PicklistOption(String value, String label) {
            this.value = value;
            this.label = label;
        }
    }
    
    public static Boolean componentDisabled(Opportunity opportunity) {
        return new Set<String>{ 'Closed Won', 'Closed Lost' }.contains(opportunity.StageName);
    }

    public static List<QuoteLineItem> getQuoteLineItems(String quoteId) {
        return [
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
                Product2.QuantityUnitOfMeasure,
                Product2.Product_Category__c,
                Cost_Category__c,
                Cost_Type__c,
                toLabel(Cost_Type__c) costTypeLabel,
                Product_Group__c,
                toLabel(Product_Group__c) productGroupLabel,
                Quantity,
                List_Price__c,
                UnitPrice,
                Contracted_Sales_Price__c,
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
                fxUnitSalesPrice__c,
                fxList__c,
                Sales_Margin__c,
                SubTotal,
                TotalPrice,
                Product_Code__c,
                Sales_Multiplier__c
            FROM QuoteLineItem
            WHERE QuoteId = :quoteId
            ORDER BY Product2.Product_Group__c, Product2.Cost_Type__c
        ];
    }

    public static Opportunity queryOpportunity(Id recordId) {
        return OpportunityProductController.getOpportunityRecord(recordId);
    }

    public static Quote queryQuote(Id recordId) {
        return [
            SELECT Id, Name, PriceBook2Id
            FROM Quote
            WHERE Id = :recordId
            LIMIT 1
        ];
    }
    // Get Role Settings
    public static Boolean isAdmin() {
        return RoleSettingsController.getRoleSettingsMap().get(UserInfo.getProfileId()).isAdmin__c;
    }
    public static Boolean isManager() {
        return RoleSettingsController.getRoleSettingsMap().get(UserInfo.getProfileId()).isManager__c;
    }
    public static Boolean isSupport() {
        return RoleSettingsController.getRoleSettingsMap().get(UserInfo.getProfileId()).isSupport__c;
    }
    public static Boolean isSales() {
        return RoleSettingsController.getRoleSettingsMap().get(UserInfo.getProfileId()).isSales__c;
    }
    public static Boolean isService() {
        return RoleSettingsController.getRoleSettingsMap().get(UserInfo.getProfileId()).IsService__c;
    }
    // Get CPQ Settings
    public static Boolean isDebug() {
        return CPQSettingsController.getCPQSettingsMap().get(UserInfo.getUserId()).debug__c;
    }
    public static Decimal maxDiscount() {
        return CPQSettingsController.getCPQSettingsMap().get(UserInfo.getUserId()).maxDiscount__c;
    }
    public static Pricing_Summary__c queryPricingSummary(Id opportunityId, Id quoteId) {
        List<Pricing_Summary__c> summaries = [
            SELECT Id, Pricing_Changes__c, Sales_Price__c, Sales_Margin__c, Discount__c
            FROM Pricing_Summary__c
            WHERE Opportunity__c = :opportunityId AND Quote__c = :quoteId
            LIMIT 1
        ];
        return summaries.isEmpty() ? null : summaries.get(0);
    }

    public static Boolean opportunityHasProductItems(Id quoteId) {
        return ![
                SELECT Id
                FROM QuoteLineItem
                WHERE
                    QuoteId = :quoteId
                    AND Product2.Product_Category__c != :PricingAdditionalCostsController.ADDITIONAL_COST_PRODUCT_CATEGORY
                    AND Product2.Product_Group__c != :PricingExtraSalesController.EXTRA_SALES_PRODUCT_GROUP
                LIMIT 1
            ]
            .isEmpty();
    }

    public static List<PicklistOption> getPicklistOptions(Schema.SObjectField field) {
        List<PicklistOption> options = new List<PicklistOption>();
        for (Schema.PicklistEntry entry : getPicklistValues(field)) {
            options.add(new PicklistOption(entry.getValue(), entry.getLabel()));
        }
        return options;
    }

    public static List<Schema.PicklistEntry> getPicklistValues(Schema.SObjectField field) {
        return field.getDescribe().getPicklistValues();
    }

    /**
    * @description Called by Opportunity Trigger
    * @author Henk Reynders | 02-12-2024 
    * @param opportunities 
    * @param oldOpportunities 
    **/
    public static void updateContractedSalesPrices(List<Opportunity> opportunities,Map<Id, Opportunity> oldOpportunities) {
        Set<Id> syncedQuoteIds = new Set<Id>();
        for (Opportunity opportunity : opportunities) {
            Opportunity oldOpportunity = oldOpportunities.get(opportunity.Id);
            //If Quote exist and contract is send and Stage Changed
            if (opportunity.SyncedQuoteId != null &&
                opportunity.StageName == CONTRACT_SENT_STAGE &&
                opportunity.StageName != oldOpportunity.StageName
            ) {
                syncedQuoteIds.add(opportunity.SyncedQuoteId);
            }
        }
        if (syncedQuoteIds.isEmpty()) {
            return;
        }
        List<QuoteLineItem> quoteLineItems = [
            SELECT UnitPrice, Contracted_Sales_Price__c
            FROM QuoteLineItem
            WHERE QuoteId IN :syncedQuoteIds
        ];
        for (QuoteLineItem quoteLineItem : quoteLineItems) {
            quoteLineItem.Contracted_Sales_Price__c = quoteLineItem.UnitPrice;
        }
        if (!quoteLineItems.isEmpty()) {
            // No need to update more than once
            //OpportunityTriggerHandler.bypass(OpportunityTriggerHandler.class.getName());
            update quoteLineItems;
        }
    }
    /**
    * @description Retrieve the Pricing Multipliers 
    * @author Henk Reynders | 02-07-2024 
    * @param opportunityId 
    * @param searchProductCode 
    * @param itemQuantity 
    * @param itemProductGroup 
    * @param itemCostType 
    * @return QuoteLineItem 
    **/
    public static QuoteLineItem findPrices(String opportunityId,String searchProductCode,Decimal itemQuantity,String itemProductGroup,String itemCostType) {
        System.Debug('--- PricingSummaryService - Find Price for ProductCode: '+searchProductCode);
        return findPrices(opportunityId, searchProductCode, itemQuantity, itemProductGroup, itemCostType, null);
    }

    /**
    * @description Retrieve the Pricing Multipliers and Price List Entries
    * @author Henk Reynders | 02-07-2024 
    * @param opportunityId 
    * @param searchProductCode 
    * @param itemQuantity 
    * @param itemProductGroup 
    * @param itemCostType 
    * @param basePrice 
    * @return QuoteLineItem 
    **/
    public static QuoteLineItem findPrices(String opportunityId,String searchProductCode,Decimal itemQuantity,String itemProductGroup,String itemCostType,Decimal basePrice) {
        System.Debug('--- PricingSummaryService - Find Price for Opportunity: '+opportunityId);
        System.Debug('--- PricingSummaryService - Find Price for ProductCode: '+searchProductCode);
        // Stage 0: Declare the Variables
        String itemProductCode = searchProductCode;
        Opportunity opportunity = OpportunityProductController.getOpportunityRecord(opportunityId);
        String currencyCode = opportunity.CurrencyIsoCode;
        String pricebookId = opportunity.Pricebook2Id;
        String pricelistId;
        // Stage 0a: Check for existing Configurations
        List<Configuration_Product__c> configProducts = ConfigurationController.getConfigurationProductsByParentId(opportunityId);
        List<Id> configProductIds = new List<Id>(new Map<Id, Configuration_Product__c>(configProducts).keySet());
        List<String> productGroups = new List<String>{ itemProductGroup };
        System.Debug('--- PricingSummaryService - '+configProducts?.size()+' Configuration Products');
        System.Debug('--- PricingSummaryService - Group: '+itemProductGroup );
        System.Debug('--- PricingSummaryService - Code: '+itemProductCode );
        // Stage 0b: Declare the Pricing Attributes
        String org = opportunity.Organization_Attribute__c;
        String country = opportunity.Country_Attribute__c;
        String business = opportunity.Business_Type_Attribute__c;
        String territory = opportunity.Territory_Attribute__c;
        String district = opportunity.District_Attribute__c;
        //String costCenter = opportunity.Sales_Cost_Center__c;
        String profitCenter = opportunity.Owner_Profit_Center__c;
        String customer = opportunity.Customer_Attribute__c;
        // Stage 1: Get Factory Prices
        // For Services this will not return any
        Map<String, Map<String, Factory_Price__c>>  factoryPriceMap = PricingParameterController.getFactoryPrices(
            productGroups,
            org,
            country,
            business
        );
         System.Debug('--- PricingSummaryService - Factory Parameter Map ('+factoryPriceMap.keySet().size()+')');
        // Stage 2: Get Product Costs
        // For Services expecting atleast 1 result
        Map<String, Map<String, Product_Cost__c>> productCostMap = PricingParameterController.getProductCosts(
            productGroups,
            org,
            country,
            business,
            district
        );
        System.Debug('--- PricingSummaryService - Cost Parameter Map ('+productCostMap.keySet().size()+')');
        // Stage 3: Get Sales Prices (=List Prices)
        // For Services expecting atleast 1 result
        System.Debug('--- PricingSummaryService - Business Attributes productGroups: '+productGroups);
        System.Debug('--- PricingSummaryService - Business Attributes org: '+org);
        System.Debug('--- PricingSummaryService - Business Attributes country: '+country);
        System.Debug('--- PricingSummaryService - Business Attributes business: '+business);
        System.Debug('--- PricingSummaryService - Business Attributes district: '+district);
        System.Debug('--- PricingSummaryService - Business Attributes territory: '+territory);
        System.Debug('--- PricingSummaryService - Business Attributes profitCenter: '+profitCenter);
        System.Debug('--- PricingSummaryService - Business Attributes customer: '+customer);
        Map<String, Map<String, Sales_Price__c>> salesPriceMap = PricingParameterController.getSalesPrices(
            productGroups,
            org,
            country,
            business,
            district,
            profitCenter,
            customer
        );
        System.Debug('--- PricingSummaryService - Price Parameter Map ('+salesPriceMap.keySet().size()+')');
        // Stage 4: Get the Opportunity Pricebook Entries to identify Sellable Items    
        Map<String, PricebookEntry> pricebookEntryMap = PriceBookEntryController.getPricebookEntriesByProductCodes(
            pricebookId,
            currencyCode,
            opportunity,
            new List<String> { itemProductCode } 
        );
        System.Debug('--- PricingSummaryService - Price Book Entry Map ('+pricebookEntryMap.keySet().size()+')');
        // Stage 5: Find the valid PriceList
		if(Test.isRunningTest()){
            //Invoke mock web service response
            pricelistId = Test.getStandardPricebookId();
        } else { 
            // Use the Opportunity Close Date
            PriceBook2 pricelist = PriceBookEntryController.getPriceList(null);
            pricelistId = pricelist.Id;
        }
        Map<String, PricebookEntry> pricelistEntryMap = PriceBookEntryController.getPricebookEntriesByProductCodes(
            pricelistId,
            currencyCode,
            opportunity,
            new List<String> { itemProductCode } 
        );
        // Stage 6: Prepare Configuration and Quote Line Item Records
        String itemLookupCode = searchProductCode; // Product Item Identifier
        PricebookEntry pbEntry = (PricebookEntry) pricebookEntryMap.get(itemLookupCode);
        PricebookEntry plEntry = (PricebookEntry) pricelistEntryMap.get(itemLookupCode);
        Decimal itemFactoryMultiplier = 0;
        Decimal itemCostMultiplier = 0;
        Decimal itemSalesMultiplier = 0;
        Decimal itemBasePrice = basePrice != null ? basePrice : plEntry?.UnitPrice;
        // Stage 6a: Get Factory Multipliers for Items Product Group and Cost Type
        if (factoryPriceMap.containsKey(itemProductGroup)) {
            Map<String, Factory_Price__c> factoryCostTypeMap = factoryPriceMap.get(itemProductGroup);
            Boolean hasFactoryCostType = factoryCostTypeMap.containsKey(itemCostType);
            if (hasFactoryCostType) {
                itemFactoryMultiplier = factoryCostTypeMap.get(itemCostType).Factory_Multiplier__c;
                System.debug('--- PricingSummaryService - Item '+searchProductCode+' Factory Multiplier  '+itemFactoryMultiplier);
            }
        }
        // Stage 6b: Get Cost Multipliers for Items Product Group and Cost Type
        if (productCostMap.containsKey(itemProductGroup)) {
            Map<String, Product_Cost__c> productCostTypeMap = productCostMap.get(itemProductGroup);
            if (productCostTypeMap.containsKey(itemCostType)) {
                itemCostMultiplier = productCostTypeMap.get(itemCostType).Cost_Multiplier__c;
                System.debug('--- PricingSummaryService - Item '+searchProductCode+' Cost Multiplier  '+itemCostMultiplier);
            }
        }
        // Stage 6c: Get Price Multipliers for Items Product Group and Cost Type
        if (salesPriceMap.containsKey(itemProductGroup)) {
            Map<String, Sales_Price__c> salesCostTypeMap = salesPriceMap.get(itemProductGroup);
            Boolean hasSalesCostType = salesCostTypeMap.containsKey(itemCostType);
            if (hasSalesCostType) {
                Sales_Price__c salesPrice = salesCostTypeMap.get(itemCostType);
                if (salesPrice != null) {
                    itemSalesMultiplier = salesPrice.sales_Multiplier__c;
                    System.debug('--- PricingSummaryService - Item '+searchProductCode+' Price Multiplier  '+itemSalesMultiplier);
                }
            }
        } else {
            System.debug('--- PricingSummaryService - No Sales Price Multiplier for '+itemProductGroup+'('+itemCostType+')');
            return null;
        }
        System.debug('--- PricingSummaryService - Item '+searchProductCode+' Base Price  '+itemBasePrice);
        // Stage 6d: Set Factory, Cost and Price per Unit
        Decimal itemFactoryPricePerUnit = itemBasePrice * itemFactoryMultiplier;
        Decimal itemProductCostPerUnit = itemBasePrice * itemCostMultiplier;
        Decimal itemSalesPricePerUnit = itemBasePrice * itemSalesMultiplier;
        // Stage 6e: Set Factory, Cost and Price per Item
        Decimal itemTotalBasePrice = itemBasePrice * itemQuantity; // Total Factory Price for Line Item
        Decimal itemTotalFactoryPrice = itemFactoryPricePerUnit * itemQuantity; // Total Factory Price for Line Item
        Decimal itemTotalProductCost = itemProductCostPerUnit * itemQuantity; // Total Product Cost for Line Item
        Decimal itemTotalSalesPrice = itemSalesPricePerUnit * itemQuantity; // Total Product Cost for Line Item

        // Stage 6f: Prepare QuoteLine Item
        QuoteLineItem quoteLineItemToUpsert = new QuoteLineItem();
        quoteLineItemToUpsert.Product_Group__c = itemProductGroup;
        quoteLineItemToUpsert.Cost_Type__c = itemCostType;
        quoteLineItemToUpsert.Quantity = itemQuantity;
        quoteLineItemToUpsert.Max_Quantity__c = plEntry.Quantity_per_Order__c;
        quoteLineItemToUpsert.Min_Price__c = plEntry.Minimum_Price__c;
        quoteLineItemToUpsert.Transmission__c = plEntry.Transmission__c;
        quoteLineItemToUpsert.Factory_Multiplier__c = itemFactoryMultiplier;
        quoteLineItemToUpsert.Cost_Multiplier__c = itemCostMultiplier;
        quoteLineItemToUpsert.Sales_Multiplier__c = itemSalesMultiplier;
        quoteLineItemToUpsert.QuoteId = opportunity.SyncedQuoteId; // Parent Record = Configuration Product
        quoteLineItemToUpsert.PricebookEntryId = pbEntry.Id;

        // Stage 6g: Check Max Quantity per Order
        // For Services this is not applicable
        Map<String, Decimal> productCodeToQuantityMap = new Map<String, Decimal>();
        
        if (configProductIds.size() > 0) {
            List<AggregateResult> aggrGroupedConfigOptions = ([
                SELECT
                    Product_Group__c Product,
                    Product_Code__c ProductCode,
                    Sales_Code__c SalesCode,
                    SUM(Quantity__c) Quantity
                FROM Configuration_Option__c
                WHERE Configuration_Product__c IN :configProductIds
                GROUP BY Product_Group__c, Product_Code__c, Sales_Code__c
            ]);
            List<String> productCodes = new List<String>();
            String aggrProductCode;
            if (!aggrGroupedConfigOptions.isEmpty()) {
                for (AggregateResult aggrGroupedConfigOption : aggrGroupedConfigOptions) {
                    String aggrProductGroup = (String) aggrGroupedConfigOption.get('Product');
                    if (String.isNotBlank(aggrProductGroup)) {
                        productGroups.add(aggrProductGroup);
                    }
                    aggrProductCode = (String) aggrGroupedConfigOption.get('ProductCode');
                    if (String.isNotBlank(aggrProductCode)) {
                        productCodes.add(aggrProductCode);
                        if (!productCodeToQuantityMap.containsKey(itemProductCode)) {
                            Decimal itemTotalQuantity = (Decimal) aggrGroupedConfigOption.get('Quantity');
                            productCodeToQuantityMap.put(aggrProductCode, itemTotalQuantity);
                        }
                    }
                }
            }
        }

        Decimal itemTotalQuantity = 0;
        Boolean hasTotalQuantity = productCodeToQuantityMap.containsKey(itemProductCode);
        if (hasTotalQuantity) {
            itemTotalQuantity = productCodeToQuantityMap.get(itemProductCode);
        }
        Decimal itemTotalPriceInGroup = itemTotalQuantity * plEntry.UnitPrice;
        Decimal plEntryMinimumPrice = plEntry.Minimum_Price__c;
        Decimal itemMinPricePerUnit = 0;
        if (
            hasTotalQuantity &&
            plEntryMinimumPrice > 0 &&
            itemTotalPriceInGroup > 0 &&
            itemTotalPriceInGroup < plEntryMinimumPrice &&
            itemTotalQuantity > 0
        ) {
            itemMinPricePerUnit = plEntryMinimumPrice / itemTotalQuantity;
            itemTotalFactoryPrice = plEntryMinimumPrice * itemFactoryMultiplier;
            itemFactoryPricePerUnit = itemTotalFactoryPrice / itemTotalQuantity;
            itemTotalProductCost = plEntryMinimumPrice * itemCostMultiplier;
            itemProductCostPerUnit = itemTotalProductCost / itemTotalQuantity;
            itemTotalSalesPrice = plEntryMinimumPrice * itemSalesMultiplier;
            itemSalesPricePerUnit = itemTotalSalesPrice / itemTotalQuantity;
            itemTotalBasePrice = plEntryMinimumPrice;
            itemBasePrice = itemTotalBasePrice / itemTotalQuantity;
        }
        quoteLineItemToUpsert.Base_Price__c = itemBasePrice;
        quoteLineItemToUpsert.Min_Sales_Price__c = itemMinPricePerUnit;
        quoteLineItemToUpsert.Factory_Price__c = itemFactoryPricePerUnit;
        quoteLineItemToUpsert.Product_Cost__c = itemProductCostPerUnit;
        quoteLineItemToUpsert.Sales_Price__c = itemSalesPricePerUnit;
        quoteLineItemToUpsert.UnitPrice = itemSalesPricePerUnit;
        quoteLineItemToUpsert.List_Price__c = itemSalesPricePerUnit;
        quoteLineItemToUpsert.Max_Quantity__c = 0;
        quoteLineItemToUpsert.Configuration_Product__c = null;
        quoteLineItemToUpsert.Sales_Code__c = null;
        return quoteLineItemToUpsert;
    }
    
    /**
    * @description 
    * @author Henk Reynders | 02-12-2024 
    * @param productId 
    * @return Product2 
    **/
    public static Product2 findProduct(String productId) {
        return [
            SELECT Name, QuantityUnitOfMeasure, ProductCode, Product_Group__c, Cost_Type__c
            FROM Product2
            WHERE Id = :productId
            LIMIT 1
        ];
    }


    /**
    * @description Method to ensure the QuoteLine has correct related Record Lookups
    * Configuration Records are created if not present
    * @author Henk Reynders | 02-07-2024 
    * @param opportunityId 
    * @param planType 
    * @param quoteLineItem 
    * @return QuoteLineItem 
    **/
    @AuraEnabled
    public static QuoteLineItem findConfiguration(Id opportunityId, String planType, QuoteLineItem quoteLineItem) {
        QuoteLineItem quoteLineItemRecord = new QuoteLineItem();
        if (String.IsNotBlank(quoteLineItem.Id)){
            //System.Debug('--- PricingSummaryService - findConfiguration for existing QuoteLine: '+quoteLineItem);
            quoteLineItemRecord = QuoteLineItemController.getQuoteLines(quoteLineItem.Id)?.get(0);
            //System.Debug('--- PricingSummaryService - Retrieved existing QuoteLine: '+quoteLineItemRecord);
        } else {
            System.Debug('--- PricingSummaryService - findConfiguration for new QuoteLine');
        }
        String productGroupCode = quoteLineItemRecord?.product2?.Product_Group__c;
		System.Debug('--- PricingSummaryService - Quoteline ProductGroup: '+productGroupCode);
        Product2 groupProduct = [
            SELECT Id,Name
            FROM Product2
            WHERE ProductCode =  :productGroupCode 
            LIMIT 1
        ];
        if (String.isBlank(groupProduct.Id)) {
            System.Debug('-- PricingSummaryService - No Active Product for Group: '+productGroupCode);
            return quoteLineItemRecord;
        }
        //Stage 0: Prepare Configuration Plan(s)
        Id configId;
        List<Id> configurationIds = new List<Id>();
        Id configProductId;
        List<Id> configProductIds = new List<Id>();
        Id configOptionId;
        List<Id> configOptionIds = new List<Id>();
        String configProductRVN;
        //Stage 1: Prepare Configuration Plan(s)
        if (String.IsNotBlank(quoteLineItem.Id)) {
            configId = quoteLineItemRecord?.Configuration_Plan__c;        
            System.Debug('--- PricingSummaryService - Quote Line has Configuration: '+configId);   
            configProductId = quoteLineItemRecord?.Configuration_Product__c;
            System.Debug('--- PricingSummaryService - Quote Line has Configuration Product: '+configProductId);
            configOptionId = quoteLineItemRecord?.Configuration_Option__c;          
            System.Debug('-- PricingSummaryService -  Quote Line has Configuration Option: '+configOptionId);
        } 
        if (String.IsNotBlank(configId)){ 
            configurationIds.add(configId);
            System.Debug('--- PricingSummaryService - Quote Line has Configuration: '+configId);
        } else {
            List<Configuration__c> configurations = [
                SELECT Id
                FROM Configuration__c
                WHERE Opportunity__c = :opportunityId 
                AND Plan_Type__c =: planType
            ];
            System.Debug('--- PricingSummaryService - '+configurations.size()+' Existing '+planType+' Configuration(s)');
            if (configurations.isEmpty() || planType == 'Services' ) {
                Configuration__c newConfiguration = new Configuration__c(
                                                    Name = planType,
                                                    Plan_Name__c = planType,
                                                    Opportunity__c = opportunityId, 
                                                    Plan_Type__c = planType
                );
                // Add Try and Catch
                insert newConfiguration;           
                configurations.add(newConfiguration);
                configId = newConfiguration?.Id;
            System.Debug('--- PricingSummaryService - Created Configuration: '+configId);
            } else {
                configId = configurations.get(0)?.Id;
                System.Debug('--- PricingSummaryService - Use Existing '+planType+' Configuration: '+configId);
            }
            configurationIds = new List<Id>(new Map<Id, Configuration__c>(configurations).keySet()); 
        }
 
        //Stage 2: Prepare Configuration Product(s)
        if (String.IsNotBlank(configProductId)){ 
            configProductIds.add(configProductId);
            System.Debug('--- PricingSummaryService - Quote Line has Configuration Product: '+configProductId);
        } else {      
            List<Configuration_Product__c> configurationProducts = [
                SELECT Id, RVN__c
                FROM Configuration_Product__c
                WHERE Product__c = :groupProduct.Id AND Configuration__c IN: configurationIds
            ];       
            System.Debug('-- PricingSummaryService - '+configurationProducts.size()+' Existing Configuration Product(s)');
            //Quantity always 1 for Product Groups)
            Configuration_Product__c newConfigProduct = new Configuration_Product__c(
                                                        Configuration__c = configId,
                                                        Name = groupProduct.Name,
                                                        Product__c = groupProduct.Id,
                                                        Quantity__c = 1
            );
            // Add Try and Catch
            insert newConfigProduct;           
            configurationProducts.add(newConfigProduct);
            configProductId = newConfigProduct?.Id;
            configProductRVN = newConfigProduct?.RVN__c;
            System.Debug('-- PricingSummaryService - Created Configuration Product: '+configProductId);
            configProductIds = new List<Id>(new Map<Id, Configuration_Product__c>(configurationProducts).keySet());  
        }
        //Stage 3: Prepare Configuration Option(s)
        if (String.IsNotBlank(configOptionId)){ 
            configOptionIds.add(configOptionId);
        } else {
            List<Configuration_Option__c> configurationOptions = new List<Configuration_Option__c>();

            System.Debug('-- PricingSummaryService - Related Configuration Option on Quote Line: '+configOptionId);
            // Set the Configuration Option Values based on the QuoteLine
            String itemName = quoteLineItem?.Product2?.Name;
            String itemUoM = quoteLineItem?.Product2?.QuantityUnitOfMeasure;
            Id itemProduct = quoteLineItem?.Product2Id;
            Decimal itemQuantity = quoteLineItem?.Quantity;
            // Upsert the configuration Option
            if (configurationOptions.isEmpty()) {
                Configuration_Option__c newConfigItem = new Configuration_Option__c(
                                                        Configuration_Product__c = configProductId,
                                                        Product__c = itemProduct,
                                                        Name = (itemName+' '+itemQuantity+' '+itemUoM),
                                                        Quantity__c = itemQuantity
                );
                // Add Try and Catch
                upsert newConfigItem;
                configurationOptions.add(newConfigItem);
                configOptionId = newConfigItem.Id;
                System.Debug('-- PricingSummaryService - Created Configuration Option: '+configOptionId);
            } else {
                System.Debug('-- PricingSummaryService - Existing Configuration Option: '+configOptionId);
            }
        }
        //Stage 4: Check for Current Items and Update with Configuration Ids
        QuoteLineItem oldItem = quoteLineItem.Id != null
            ? [SELECT Id, Product2Id FROM QuoteLineItem WHERE Id = :quoteLineItem.Id LIMIT 1]
            : null;
        if (oldItem != null && oldItem.Product2Id != quoteLineItem.Product2Id) {
            delete new QuoteLineItem(Id = quoteLineItem.Id);
            quoteLineItem.Id = null;
        }
        quoteLineItem.RVN_Number__c = configProductRVN;
        quoteLineItem.Configuration_Plan__c = configId;
        quoteLineItem.Configuration_Product__c = configProductId;
        quoteLineItem.Configuration_Option__c = configOptionId;
        return quoteLineItem;
    }
    /**
    * @description 
    * @author Henk Reynders | 02-12-2024 
    * @param opportunityId 
    * @param quoteLineItemId 
    * @return Id 
    **/
    @AuraEnabled
    public static Id deleteConfiguration(Id opportunityId, Id quoteLineItemId) {
        QuoteLineItem quoteLineItem = [SELECT Id,QuoteId,Configuration_Plan__c,Configuration_Product__c, Configuration_Option__c
                                        FROM QuoteLineItem
                                        WHERE Id =: quoteLineItemId
                                        LIMIT 1]; 
        quoteLineItemId = quoteLineItem?.Id;
        if (String.IsNotBlank(quoteLineItemId)){
            System.Debug('--- PricingSummaryService - Checking related Configuration Records for existing QuoteLine: '+quoteLineItemId);
        }
        //Stage 0: Get Configuration Ids
        Id configId;
        List<Id> configurationIds = new List<Id>();
        String configPlanType;
        Id configProductId;
        List<Id> configProductIds = new List<Id>();
        Id configOptionId;
        List<Id> configOptionIds = new List<Id>();
        String configProductRVN;        
        //Stage 1: Prepare Configuration Plan(s)
        if (String.IsNotBlank(quotelineItemId)) {
            configId = quoteLineItem?.Configuration_Plan__c;           
            configProductId = quoteLineItem?.Configuration_Product__c;
            configOptionId = quoteLineItem?.Configuration_Option__c;
        } 
        // Add Config plan Id to List for Deletion
        if (String.IsNotBlank(configId)){ 
            configurationIds.add(configId);
            System.Debug('-- PricingSummaryService - Quote Line has Configuration: '+configId);
            List<Configuration__c> configurations = [
                SELECT Id, Plan_Type__c
                FROM Configuration__c
                WHERE Opportunity__c = :opportunityId 
                AND Id =: configId 
            ];
            System.Debug('-- PricingSummaryService - '+configurations.size()+' Existing Configuration Plan(s)');
            configurationIds = new List<Id>(new Map<Id, Configuration__c>(configurations).keySet());
            List<Configuration_Product__c> configurationProducts = [
                SELECT Id, RVN__c
                FROM Configuration_Product__c
                WHERE Configuration__c IN: configurationIds
            ];       
            configProductIds = new List<Id>(new Map<Id, Configuration_Product__c>(configurationProducts).keySet());
            System.Debug('-- PricingSummaryService - '+configurationProducts.size()+' Existing Configuration Product(s)');
            List<Configuration_Option__c> configurationOptions = [
                SELECT Id, Configuration_Product__c
                FROM Configuration_Option__c
                WHERE Configuration_Product__c IN: configProductIds
            ]; 
            System.Debug('-- PricingSummaryService - '+configurationOptions.size()+' Existing Configuration Options(s)');
            configPlanType = configurations.get(0)?.Plan_Type__c;
        } else {
            return quoteLineItemId;
        }
        if (!configurationIds.isEmpty() && configPlanType == 'Services') {
            try {
                delete new Configuration__c(Id = configId);
                System.Debug('-- PricingSummaryService - Deleted Configuration Plan');
                return quoteLineItemId;
            } catch (Exception e) {
                throw new ComponentDataException('The '+configPlanType+' Configuration Plan can\'t be delete');
            }
        } else if (!configurationIds.isEmpty()){
            if (configOptionIds.size()>1) {
                try {
                    delete new Configuration_Option__c (Id = configOptionId);
                    System.Debug('-- PricingSummaryService - Deleted Configuration Option');
                    return quoteLineItemId;
                } catch (Exception e) {
                    throw new ComponentDataException('The Configuration Option can\'t be delete');
                }
            } else {
                try {
                    delete new Configuration_Product__c (Id = configProductId);
                    System.Debug('-- PricingSummaryService - Deleted Configuration Product');
                    return quoteLineItemId;
                } catch (Exception e) {
                    throw new ComponentDataException('The Configuration Product can\'t be delete');
                }
            }           
        }
        return quoteLineItemId;
    }
    /**
    * @description Add Installation Time for Configurations in Salesfoce Configurator like Services Products
    * @author Henk Reynders | 02-09-2024 
    * @param opportunityId 
    * @param planType 
    * @param configOptionId 
    * @return Configuration_Option__c 
    **/
    @AuraEnabled
    public static Configuration_Option__c findServiceTime(Id opportunityId, String planType, Id configOptionId) {
        Map<String,Installation_Time__c> installationTimeMap  = New Map<String,Installation_Time__c>();  // Map for Lookup of Product and installation Times
        Product2 timeProduct;
        Map<String,Product2> timeProductMap = New Map<String,Product2>();
    
        // Get the Active Installation Time Map
        Boolean isActive = true;      
        installationTimeMap = InstallationTimeController.getInstallationTimeMap(isActive);
        System.debug('--- PricingSummaryService - '+installationTimeMap.size()+' Installation Time(s)');
        // Get Installable Products from Product2   
        timeProductMap = InstallationTimeController.getInstallationTimeProductMap(isActive);
        System.debug('--- PricingSummaryService - '+timeProductMap.size()+' Installation Time Product(s)');
        // Check for the Installable Configuration Option
        Configuration_Option__c configItemToProcess = ConfigurationOptionController.getConfigurationOption(configOptionId);
        System.debug('--- PricingSummaryService - Configuration Option to Process: '+configItemToProcess.Id);
        Id configProductId = configItemToProcess?.Configuration_Product__c;
        System.debug('--- PricingSummaryService - Related Configuration Product: '+configProductId);
        // Prepare the Installation Time Config Option
        Configuration_Option__c timeToUpsert = new Configuration_Option__c();
        String itemLookupCode = configItemToProcess?.Product__r?.ProductCode;//'SF3000010'
        Decimal itemQuantity = configItemToProcess?.Quantity__c;
        String timeLookupCode;
        Decimal timeBatchsize;
        Decimal timeQuantity;
        System.debug('--- PricingSummaryService - Item Code '+itemLookupCode);
        if (planType == 'Services') {
            timeLookupCode = itemLookupCode.replace('SF','MH'); //'MH3000010'
        } else {
            timeLookupCode = itemLookupCode;
        }
        System.debug('--- PricingSummaryService - Time Code '+timeLookupCode); 
        // Check for matching Installation Time Records 
        Boolean installTimeKeyFound = installationTimeMap.containsKey(timeLookupCode);          
        Installation_Time__c installationTime;
        Id installationTimeId;
        Id timeProductId;
        Decimal installationHours;
        String installationUoM;
        String installationProductName;
        Decimal installationTimeBatchSize;
        if (installTimeKeyFound) {         
            InstallationTime = (Installation_Time__c) installationTimeMap.get(timeLookupCode);
            installationTimeId = installationTime.Id;
            System.debug('--- PricingSummaryService - Found Installation Time Record '+installationTime.Id); 
            timeProductId = installationTime.Product__c; // reference to Product2 Record
            installationHours = installationTime.Hours__c; // Installation Time Lookup
            // If Installation Time exists prepare the Configuration Option
            Boolean installTimeProductKeyFound = timeProductMap.containsKey(timeLookupCode);
            if (installTimeProductKeyFound) {
                timeProduct = (Product2) timeProductMap.get(timeLookupCode);
                timeProductId = timeProduct.Id;
                System.debug('--- PricingSummaryService - Found Installation Time Product Record '+timeProductId); 
                installationUoM = timeProduct.QuantityUnitOfMeasure;
                installationProductName = timeProduct.Name;
                installationTimeBatchSize = timeProduct.Batch_Size__c;
            }
        }
        if (String.isNotBlank(installationTimeId)){
            // Check for existing Configuration Options for the exact same Installation Time Product
            System.debug('--- PricingSummaryService - Lookup Filter1 Config Product: '+configProductId); 
            System.debug('--- PricingSummaryService - Lookup Filter2 Config Option: '+configOptionId); 
            System.debug('--- PricingSummaryService - Lookup Filter3 Time Product: '+timeProductId); 
            List<Configuration_Option__c> matchingConfigOptions = [
                SELECT Id,Line_Number__c,Quantity__c
                FROM Configuration_Option__c
                WHERE Configuration_Product__c = :configProductId
                    AND Related_Configuration_Option__c = :configOptionId
                    AND Product__c =:timeProductId
            ];
            Id timeRecordId;
            // Prepare the Configuration Option to Upsert
            if (!matchingConfigOptions.isEmpty()) {
                timeRecordId = matchingConfigOptions.get(0)?.Id;
                timeToUpsert.Id = timeRecordId;
                System.debug('--- PricingSummaryService - Existing Installation Time Record: '+timeToUpsert);
            }
            if (String.isBlank(timeRecordId)) {
                timeToUpsert.Configuration_Product__c = configProductId; 
                timeToUpsert.Related_Configuration_Option__c = configOptionId; 
                System.debug('--- PricingSummaryService - New Installation Time Record: '+timeToUpsert);
            }
            // Determine the Quantity to set
            timeBatchsize = installationTimeBatchSize > 0 ? installationTimeBatchSize: 1; 
            // Use Batchsize to multiple the servicable item quantity 
            timeQuantity = (itemQuantity * timeBatchsize);
            timeToUpsert.Name = installationProductName +' '+timeQuantity+' '+installationUoM;
            timeToUpsert.Unit_Of_Measure__c = installationUoM;
            // Product Identifiers
            timeToUpsert.Product__c = timeProductId; 
            timeToUpsert.Installation_Time_Per_Unit__c = installationHours;
            timeToUpsert.Quantity__c = timeQuantity;
            timeToUpsert.Installation_Hours__c = installationHours*timeQuantity;
            timeToUpsert.isInstallationTime__c = true;
            System.Debug('--- Installation Item: '+timeToUpsert);
            upsert timeToUpsert;
        }
        return timeToUpsert;
    }
    @AuraEnabled(cacheable=false)
    public static void calculateLeadTimes(Id opportunityId) {
        Map<String, Object> params = new Map<String, Object>{
            'recordId' => opportunityId
        };
        // Update Opportunity Lead Times after adding serviceTime
        Flow.Interview.Assign_Lead_Times_SubFlow leadTimeFlow = new Flow.Interview.Assign_Lead_Times_SubFlow(params);
        leadTimeFlow.start();
        Opportunity updatedOpportunity = (Opportunity)leadTimeFlow.getvariableValue('pricingSummaryId');      
        if (String.isEmpty(updatedOpportunity?.Id)) {
            throw new PricingSummaryService.PricingDataException('Unable to calculate Lead Times');
        } else {
            System.Debug('--- PricingSummaryController - Updated Opportunity Id: '+updatedOpportunity?.Id);
        }
    }
}