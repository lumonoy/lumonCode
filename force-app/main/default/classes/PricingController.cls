/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-02-2023
 * @last modified by  : Henk Reynders
**/
public with sharing class PricingController{
    @AuraEnabled(cacheable=true)
    public static String getObjectType(String IdOrPrefix){
        String sObjectName = '';
        try{
            //Get prefix from record ID
            String recordIdPrefix = String.valueOf(IdOrPrefix).substring(0,3);
            System.debug('--- Get ObjectAPIName for prefix ' + recordIdPrefix);
            //Get schema information
            Map<String, Schema.SObjectType> sObjectDescribeSchema =  Schema.getGlobalDescribe();
            //Loop through all the sObject types returned by Schema
            for(Schema.SObjectType sObjType : sObjectDescribeSchema.values()){
                //if (!sObjType.contains('__')) to exclude managed package objects
                Schema.DescribeSObjectResult sObjectDescribeResult = sObjType.getDescribe();
                String objectTypePrefix = sObjectDescribeResult.getKeyPrefix();
                 //Check if the prefix matches with requested prefix
                if(objectTypePrefix!=null && objectTypePrefix.equals(recordIdPrefix)){
                    sObjectName = sObjectDescribeResult.getName();
                    System.debug('--- Set ObjectAPIName ' + sObjectName);
                    break;
                }
            }
        }catch(Exception e){
            System.debug(e);
        }
        return sObjectName;
    }
    @AuraEnabled(cacheable=true)
    public static Map<String,String> getRelatedObjects(String sObjectName) {
        System.Debug ('--- Get '+sObjectName+ ' Reference Objects');
        Map<String, Schema.SObjectType> globalDescribeMap = Schema.getGlobalDescribe();
        Schema.SObjectType sObjectTypeObj = globalDescribeMap.get(sObjectName);
        Schema.DescribeSObjectResult describeSObjectResultObj = sObjectTypeObj.getDescribe();
        Map<String, Schema.SObjectField> describeSObjectfieldsMap = describeSObjectResultObj.fields.getMap();
        Map<String,String> relatedObjectsMap=new Map<String,String>();
        // Loop Through Field Keys
        for (String fieldKey : describeSObjectfieldsMap.keySet()) {
            Schema.DisplayType fieldType = describeSObjectfieldsMap.get(fieldKey).getDescribe().getType();
            if (fieldType == Schema.DisplayType.Reference) {
            // describe of your lookup field
                Schema.DescribeFieldResult describeFieldResultObj = describeSObjectfieldsMap.get(fieldKey).getDescribe();
                String relatedFieldName = describeFieldResultObj.getName();
                String relatedFieldLabel = describeFieldResultObj.getLabel();
                List<Schema.SObjectType> objectReferences = describeFieldResultObj.getReferenceTo();
                for (Schema.SObjectType objectReference : objectReferences){
                    String relatedObjectName = objectReference.getDescribe().getName();
                    String relatedObjectLabel = objectReference.getDescribe().getLabel();
                    relatedObjectsMap.put(relatedObjectName, relatedFieldName);
                }
            }
        }
        return relatedObjectsMap;
    }
    @AuraEnabled(cacheable=true)
    public static String getPricingJSON(Id configId){
        String pricingJSON = string.valueOf([SELECT Pricing_JSON__c FROM Configuration__c WHERE Id =:configId]);
        System.debug('--- Pricing JSON on Record : '+pricingJSON);
        return pricingJSON;
    }
    @AuraEnabled(cacheable=true)
    public static Pricing_Summary__c getPricingSummary(String recordId){
        //Input: List of Pricing Summary Ids or Plan Ids
        //Output: pricingSummaries
        Pricing_Summary__c pricingSummary = new Pricing_Summary__c();
        pricingSummary = ([SELECT Id,
                                    Account__c,
                                    Contract__c,
                                    Opportunity__c,
                                    Quote__c,
                                    Organization__c,
                                    Country_Code__c,
                                    District__c,
                                    Profit_Center__c,
                                    Office__c
                            FROM Pricing_Summary__c
                            WHERE Opportunity__c = : recordId
                            OR Quote__c = : recordId
                            ORDER BY Id DESC
                            LIMIT 1]);
        return pricingSummary;
    }
    @AuraEnabled
    // Pricing Summary must be created for every Opportunity to store grouped pricing Information
    public static Pricing_Summary__c upsertPricingSummary(Id opportunityId){
        Id quoteId;
        Id summaryId;
        Quote quoteRecord = new Quote();
        Opportunity opportunityRecord = new Opportunity();
        Pricing_Summary__c pricingSummaryExisting = new Pricing_Summary__c(); // Offer Level Pricing
        Pricing_Summary__c pricingSummaryToUpsert = new Pricing_Summary__c();
        try {
            // Step 1: get Opportunity, Quote, Case or Order Records
            if (String.isNotBlank(opportunityId)){
                // Step 1a: get the Opportunity
                System.debug('--- opportunityId'+opportunityId);
                opportunityRecord = OpportunityController.getOpportunityRecord(opportunityId);
                quoteId = opportunityRecord.SyncedQuoteId;
                // Step 1b: get the Quote
                if (String.isNotBlank(quoteId)) {
                    quoteRecord = QuoteController.getQuoteRecord(quoteId);
                }
                System.debug('--- Using Opportunity '+opportunityId+' and Quote ' +quoteId);
                // Step 2: Get Existing Pricing 
                summaryId = [SELECT Id FROM Pricing_Summary__c WHERE Opportunity__c =: opportunityId LIMIT 1]?.Id;

                // Step 3: Prepare Pricing Summary
                if (String.isNotBlank(opportunityId)){
                    // Set Summary Attributes
                    if (String.isNotBlank(summaryId)){
                        pricingSummaryExisting = [SELECT Id,Sales_Price__c FROM Pricing_Summary__c WHERE Id =: summaryId];
                        pricingSummaryToUpsert.Id = summaryId;
                        pricingSummaryToUpsert.Sales_Price__c = pricingSummaryExisting.Sales_Price__c;
                    } else {
                        pricingSummaryToUpsert.Opportunity__c = opportunityRecord.Id; // Related Record
                    }
                    pricingSummaryToUpsert.Organization__c = opportunityRecord.Organization_Attribute__c; // Related Record
                    pricingSummaryToUpsert.Country_Code__c = opportunityRecord.Country_Attribute__c; // Related Record
                    pricingSummaryToUpsert.Business_Type__c = opportunityRecord.Business_Type_Attribute__c;
                    pricingSummaryToUpsert.District__c = opportunityRecord.District_Attribute__c; // Related Record
                    pricingSummaryToUpsert.Profit_Center__c = opportunityRecord.Owner_Profit_Center__c; // Related Record
                    pricingSummaryToUpsert.Profit_Center__c = opportunityRecord.Owner_Profit_Center__c; // Related Record
                    //pricingSummaryToUpsert.Office__c = opportunityRecord.Office__c; // Related Record

                    pricingSummaryToUpsert.User__c = opportunityRecord.OwnerId;// Related Record
                    pricingSummaryToUpsert.Account__c = opportunityRecord.AccountId; // Related Record
                    pricingSummaryToUpsert.Quote__c = quoteId; // Related Record
                    pricingSummaryToUpsert.Order__c = opportunityRecord.Order__c; // Related Record
                    pricingSummaryToUpsert.Contract__c = opportunityRecord.contractId; // Related Record
                    pricingSummaryToUpsert.currencyIsoCode = opportunityRecord.CurrencyIsoCode;

                    upsert (pricingSummaryToUpsert);
                    System.debug('--- Pricing Summary '+pricingSummaryToUpsert.Id+' Created or Updated');
                }
            }
        } catch (Exception e) {
            System.debug('--- The following exception has occurred: ' + e.getMessage());
            throw new CustomException(e.getMessage());
        }
        return pricingSummaryToUpsert;
    }
    @AuraEnabled
    // Quote Lines must be created for every Opportunity to store Line Item pricing Details
	// If called with the record Id (Opportunity or Quote) all related Configuration Plans are processed
	// If called with the config Id only one Plan is processed
    public static String upsertQuoteLines(Id recordId){
        System.debug('--- Processing New or Updated Configuration Items');
        String errorMessage;
        // Pricing related Variables
        String ParentObjectType;
        // Salesforce Configuration Plan Variables
        Id opportunityId;// Opportunity Id - the "Offer" the Plan(s) belong to
        Id syncedQuoteId;
        Id pricebookId;
        Id pricelistId;
        String currencyCode;
        Date closingDate;
        Opportunity opportunityRecord;
        Quote quoteRecord;

        // Configuration Variables
        List<Id> configPlanIds = new List<Id>();
        List<Configuration_Product__c> configProducts = new List<Configuration_Product__c>(); // Existing Configuration Products
        List<Id> configProductIds = new List<Id>();
        List<Configuration_Option__c> configOptions= new List<Configuration_Option__c>(); // Existing Configuration Items
        List<AggregateResult>  aggrGroupedConfigOptions = new List<AggregateResult>();

        // Salesforce Pricing Item Variables
        Map<String,PricebookEntry> pricebookEntryMap  = new Map<String,PricebookEntry>();  // Map for Lookup of Sellable Items
        Map<String,PricebookEntry> pricelistEntryMap  = new Map<String,PricebookEntry>();  // Map for Lookup or Product and Prices

        // Lookup Map Variables
        List<String> productGroups = new List<String>();
        Map<String,Map<String,Factory_Price__c>> factoryPriceMap = new Map<String,Map<String,Factory_Price__c>>();
        Map<String,Map<String,Product_Cost__c>> productCostMap = new Map<String,Map<String,Product_Cost__c>>();
        Map<String,Map<String,Sales_Price__c>> salesPriceMap = new Map<String,Map<String,Sales_Price__c>>();
        Map<String, QuoteLineItem> uniqueIdToLineItemMap = new Map<String,QuoteLineItem>();
        Map<String,Decimal> productCodeToQuantityMap = new  Map<String,Decimal>();

        List<QuoteLineItem> existingQuoteLineItems = new List<QuoteLineItem>();
        List<QuoteLineItem> quoteLineItemsToUpsert = new List<QuoteLineItem>();
        List<QuoteLineItem> obsoleteQuoteLineItems = new List<QuoteLineItem>(); // Outdated Configuration Options as in File configJSON
        List<Id> lineItemIds = new List<Id>();

        Boolean hasBasePrice;
        Boolean hasFactoryPrice;
        Boolean hasProductCost;
        Boolean hasSalesPrice;

        // Salesforce Configuration Item Variables
        Decimal itemQuantity; // Item Quantity
        String  itemProductId; // Item Product2Id
        Decimal itemLineNumber; // Item Line
        String  itemProductGroup; // Item Group (=main Product)
        String  itemProductCode; // Item Product Code (=main Product+SalesCode)
        String  itemSalesCode; // Item SalesCode (Ax Code)
        String  itemCostCategory; // Item Cost Category
        String  itemCostType; // Item Cost Type
        String  itemRVN; // Item RVN (Unique Code)
        Decimal itemBasePrice;
        Decimal itemFactoryMultiplier;
        Decimal itemFactoryPrice;
        Decimal itemCostMultiplier;
        Decimal itemProductCost;
        Decimal itemSalesMultiplier;
        Decimal itemUnitPrice;
        Decimal itemMaxQuantity;
        Decimal itemMinPrice;
        Decimal itemMinPricePerUnit;
        Decimal itemTransmission;
        String itemConfigOption; // Item Configuration Option Lookup
        String itemConfigProduct; // Item Configuration Product Lookup
        String itemConfigPlan; // Item Configuration Plan Lookup
        // Salesforce PriceBook2 Variables
        String pbEntryProductId; // Pricebook Entry Product Id
        String pbEntryProductCode;// Code of the Product
        String pbEntrySalesCode;
        String pbEntryName; // Pricebook Entry Product Name
        String pbEntryUoM; // Pricebook Entry Product UoM
        Decimal pbEntryUnitPrice;// List Price of the Product
        Decimal plEntryBasePrice; // PriceList Base Price
        Decimal plEntryMinimumPrice;// PriceList Min Price per Item per Product Group
        Decimal plEntryMaxQuantity; // Pricelist Max Amount per Order
        Decimal plEntryTransmission; // PriceList Multiplier reduction
        String plEntryUoM; // PriceList Quantity Unit Of Measure;
        try {
            //Check  which is the Parent Object based on RecordId
            System.debug('--- Get Configuration Items');
            // Step 1: check Parent Object
            if (String.isNotBlank(recordId)){
                parentObjectType = getObjectType(recordId);
            } else {
                errorMessage = 'No Parent Record Available!';
                System.debug('--- ABORT '+errorMessage);
                throw new CustomException(errorMessage);
            }
            // Step 2: get Opportunity and Quote Records
            if (parentObjectType=='Opportunity' && String.isNotBlank(recordId)){
                opportunityId = recordId;
                //Get Opportunity Record
                opportunityRecord = OpportunityController.getOpportunityRecord(opportunityId);
                // Set Related Records
                pricebookId = opportunityRecord.pricebook2Id;
                currencyCode = opportunityRecord.CurrencyIsoCode;
                syncedQuoteId = opportunityRecord.SyncedQuoteId;
                if (String.isNotBlank(syncedQuoteId)) {
                    quoteRecord = QuoteController.getQuoteRecord(syncedQuoteId);
                }
            } else if (parentObjectType=='Quote' && String.isNotBlank(recordId)){
                syncedQuoteId = recordId;
                //Get quote Record
                quoteRecord = QuoteController.getQuoteRecord(syncedQuoteId);
                opportunityId = quoteRecord.opportunityId;
                opportunityRecord = OpportunityController.getOpportunityRecord(opportunityId);
                // Set Related Records
                pricebookId = opportunityRecord.pricebook2Id;
                currencyCode = opportunityRecord.CurrencyIsoCode;
                syncedQuoteId = opportunityRecord.SyncedQuoteId;
            }
            // Step 3a: Get Pricebooks
            if (String.isNotBlank(pricebookId) && String.isNotBlank(currencyCode)) {
                // Pricebook Entries to identify Sellable Items
                Pricebook2 pricelist = new Pricebook2();
                if(Test.isRunningTest()){
                    //Invoke mock web service response
                    Id pbid = Test.getStandardPricebookId();
                    pricebookId = pbId;
                    pricelistId = pbId;
                } else{
                    pricelist = PriceBookEntryController.getPriceList(closingDate);
                    pricelistId = pricelist.Id;
                }
            } else {
                errorMessage = 'No Pricebook to Use!';
                System.debug('--- ABORT '+errorMessage);
                throw new CustomException(errorMessage);
            }
            // Step 3b: Get Pricebook Entries
            if (String.isNotBlank(pricebookId) && String.isNotBlank(currencyCode)) {
                // Get Pricebook Entry Map to find Product Ids
                pricebookEntryMap = PriceBookEntryController.getPricebookEntryMap(pricebookId,currencyCode);
                System.debug('--- Found Pricebook with '+pricebookEntryMap.size()+' Entries');
            } else {
                errorMessage = 'No PriceBook to Use!';
                System.debug('--- ABORT '+errorMessage);
                throw new CustomException(errorMessage);
            }
            // Step 3c: Get Pricelist Entries
            if (String.isNotBlank(pricelistId) && String.isNotBlank(currencyCode)) {
                // Get Pricebook Entry Map to find Product Ids
                pricelistEntryMap = PriceBookEntryController.getPricebookEntryMap(pricelistId,currencyCode);
                System.debug('--- Found PriceList with '+pricelistEntryMap.size()+' Entries');
            } else {
                errorMessage = 'No PriceList to Use!';
                System.debug('--- ABORT '+errorMessage);
                throw new CustomException(errorMessage);
            }
            // Step 4: Get Configuration Items
            // Get all Plans, Products and Options for the Opportunity
            if (String.isNotBlank(recordId) && String.isNotBlank(parentObjectType)) {
                configProducts = ConfigurationController.getConfigurationProductsByParentId(recordId);
                configProductIds = new List<Id>(new Map<Id, Configuration_Product__c>(configProducts).keySet());
                configOptions = ConfigurationController.getConfigurationOptions(configProductIds);
                //System.debug('--- '+configOptions.size()+'Configuration Options');
            }  else {
                errorMessage = 'No Configuration Options to Process!';
                System.debug('--- ABORT '+errorMessage);
                throw new CustomException(errorMessage);
            }
            // Step 5: Get Existing Quote Lines
            if(String.isnotBlank(syncedQuoteId)) {
                existingQuoteLineItems = ([SELECT Id,
                                        Configuration_Plan__c,
                                        Configuration_Product__c,
                                        Configuration_Option__c,
                                        Product2Id,
                                        Product2.ProductCode,
                                        Product2.Sales_Code__c,
                                        Product2.Product_Category__c,
                                        Product_Category__c,
                                        Discount__c,
                                        Cost_Category__c,
                                        Cost_Type__c,
                                        Line_Number__c,
                                        RVN_Number__c,
                                        Sales_Code__c,
                                        Product_Group__c,
                                        Quantity,
                                        UnitPrice,
                                        List_Price__c,
                                        Sales_Multiplier__c,
                                        Contracted_Sales_Price__c,
                                        Max_Quantity__c
                                FROM QuoteLineItem
                                WHERE QuoteId = :syncedQuoteId
                                ORDER BY CreatedDate DESC]);
                System.debug('--- '+existingQuoteLineItems.size()+' existing QuoteLineItem(s)');
                // Create Map with Unique Id
                if (!existingQuoteLineItems.isEmpty()){
                    for(QuoteLineItem qLineItem :existingQuoteLineItems){
                        String uniqueLineItemCode = qLineItem.Configuration_Plan__c+'-'
                                                    +qLineItem.Product_Group__c+'-'
                                                    +qLineItem.Sales_Code__c+'-'
                                                    +qLineItem.Quantity.setScale(5)+'-'
                                                    +qLineItem.Line_Number__c;
                        if(!uniqueIdToLineItemMap.containsKey(uniqueLineItemCode)){
                            uniqueIdToLineItemMap.put(uniqueLineItemCode, qLineItem);
                        }
                    }
                }
            }
            // Step 6: Get Pricing Summary - If there is some Configuration Pricing Summary is Required
            Pricing_Summary__c pricingSummary = null;
            if (configProducts.size()>0 && configProducts != null
                && String.isNotBlank(opportunityId)) {
                pricingSummary = upsertPricingSummary(opportunityId);
            }
            // Step 7: Get Pricing Parameters - Parameters are retrieved with Filters for quicker lookup later on
            if (configProducts.size()>0 && configProducts != null
                && OpportunityRecord != null) {
                for(Configuration_Product__c configProduct : configProducts){
                    if (String.isNotBlank(configProduct.Product_Group__c)) {
                        productGroups.add(configProduct.Product_Group__c);
                    }
                    if (productGroups.size()>0 && opportunityRecord != null) {
                        //Organization_Attribute__c,Country_Attribute__c,//Tier 1 Factory Prices
                        //Product Groups list is used to filter Parameters only to relative Products eg LG, LGS
                        String org = opportunityRecord.Organization_Attribute__c; // Lumon Organization eg LSU
                        String country = opportunityRecord.Country_Attribute__c; // Lumon Country (of Building) eg FI
                        String business =  opportunityRecord.Business_Type_Attribute__c; // Lumon Business Type eg Consumer
                        factoryPriceMap = PricingParameterController.getFactoryPrices(productGroups,org,country,business);
                        System.debug('--- '+factoryPriceMap.size()+ ' Factory Parameters');

                        //Territory_Attribute__c,Business_Type_Attribute__c,//Tier 2 Product Costs
                        String territory = opportunityRecord.Territory_Attribute__c;// Lumon Territories related to the Opportunity Territory eg Vantaa West
                        String district = opportunityRecord.District_Attribute__c;// Lumon Districts is a specific "Level" in the Territory Hierarchy eg FI-South
                        productCostMap = PricingParameterController.getProductCosts(productGroups,org,country,business,district);
                        System.debug('--- '+productCostMap.size()+ ' Cost Parameters');

                        //Owner_Profit_Center__c, Customer_Attribute__c, //Tier 3 Sales Prices
                        String profitCenter = opportunityRecord.Owner_Profit_Center__c;// Opportunity Owner (Sales Rep) Business Unit
                        String customer = opportunityRecord.Customer_Attribute__c;// For Consumers in Finland 1905514-0, else Business ID of Company (B2B)
                        salesPriceMap = PricingParameterController.getSalesPrices(productGroups,org,country,business,district,profitCenter,customer);
                    }
                }
            }
            // Step 8: Get Grouped Configuration Items (grouped by ProductCode)
            // Aggregated Query to prepare lookup of Total Quantity of an Item per Opportunity (Offer)
            // Used in price calculation for min Price and Max Quantity
            if (configProductIds.size()>0 && configProductIds != null) {
                aggrGroupedConfigOptions = ([SELECT Product_Group__c Product,
                                                    Product_Code__c ProductCode,
                                                    Sales_Code__c SalesCode,
                                                    SUM(Quantity__c) Quantity
                                            FROM Configuration_Option__c
                                            WHERE Configuration_Product__c IN: configProductIds
                                            GROUP BY Product_Group__c,Product_Code__c,Sales_Code__c]);
                List<String> productCodes =new List<String>();
                String aggrProductCode;
                if (aggrGroupedConfigOptions.size()>0 && aggrGroupedConfigOptions != null) {
                    for(AggregateResult aggrGroupedConfigOption :aggrGroupedConfigOptions){
                        String aggrProductGroup = (String)aggrGroupedConfigOption.get('Product');
                        if (String.isNotBlank(aggrProductGroup)) {
                            productGroups.add(aggrProductGroup);
                            System.debug('--- Adding Group to Map '+ aggrProductGroup);

                        }
                        aggrProductCode = (String)aggrGroupedConfigOption.get('ProductCode');
                        if (String.isNotBlank(aggrProductCode)) {
                            productCodes.add(aggrProductCode);
                            System.debug('--- Adding Code to Map '+ aggrProductCode);
                            if (!productCodeToQuantityMap.containsKey(itemProductCode)) {
                                Decimal itemTotalQuantity = (Decimal)aggrGroupedConfigOption.get('Quantity');
                                productCodeToQuantityMap.put(aggrProductCode,itemTotalQuantity);
                                System.debug('--- Adding Quantity to Map '+ itemTotalQuantity);
                            }
                        }
                    }
                }
            }
            
            // Step 9: Loop Configuration Items
            if (configOptions.size()>0) {
                for (Configuration_Option__c configItem : configOptions) {
                    // Find the Pricebook Entry and Product
                    String itemLookupCode = configItem.Product_Code__c; // Product Item Identifier
                    Id pbEntryId; // Pricebook Entry Id
                    PricebookEntry pbEntry; // Pricebook Entry Record
                    PricebookEntry plEntry; // PriceList Pricebook Entry Record
                    Decimal itemTotalQuantity = 0.0;
                    Boolean pbEntryKeyFound = pricebookEntryMap.containsKey(itemLookupCode);
                    if(pbEntryKeyFound) {
                        pbEntry = (PricebookEntry) pricebookEntryMap.get(itemLookupCode);
                        if (opportunityRecord.Order_type__c == 'Reclamation' && pbEntry.Product2.Reclamation__c) {
                            pbEntryProductId = pbEntry.Product2Id;
                            System.debug('--- Found Reclamation Pricebook Entry '+pbEntry);
                        } else if (opportunityRecord.Order_type__c != 'Reclamation' && !pbEntry.Product2.Reclamation__c) {
                            pbEntryProductId = pbEntry.Product2Id;
                            System.debug('--- Found Standard Pricebook Entry '+pbEntry);
                        }
                        pbEntryId = pbEntry.Id;
                        pbEntryProductCode = pbEntry.Product2.ProductCode;
                        pbEntrySalesCode = pbEntry.Product2.Sales_Code__c;
                        pbEntryUnitPrice = pbEntry.UnitPrice;
                        //pbEntryStandardPrice = pbEntry.StandardPrice;// Standard Price of the Product
                        pbEntryUoM = pbEntry.Product2.QuantityUnitOfMeasure;
                        pbEntryName = pbEntry.Product2.Name;
                        System.debug('--- Found Pricebook Entry for Item '+itemLookupCode+': '+pbEntry);
                        // Check if there is a Price Available for the Item
                        // retrieve all Price Attributes
                        hasBasePrice = pricelistEntryMap.containsKey(itemLookupCode);
                        if(hasBasePrice) {
                            plEntry = (PricebookEntry) pricelistEntryMap.get(itemLookupCode);
                            if (plEntry != null) {
                                System.debug('--- Found PriceList Entry for Item '+itemLookupCode+': '+plEntry);
                                plEntryBasePrice = plEntry.UnitPrice;
                                plEntryMinimumPrice = plEntry.Minimum_Price__c;
                                plEntryMaxQuantity = plEntry.Quantity_per_Order__c;
                                plEntryTransmission = plEntry.Transmission__c;
                                plEntryUoM = plEntry.Product2.QuantityUnitOfMeasure;
                            }
                        } else {
                            System.debug('--- No Base Price defined for Item: '+itemLookupCode);
                            // If Item has no Base Price skip to next Item in Loop
                            continue;
                        }
                    } else {
                        System.debug('--- NO Pricebook Entry for Item '+itemLookupCode);
                    }
         /**************** ITEM INITIAL VALUES *********************/
                    if(pbEntry != null && plEntry != null) {
                        itemBasePrice = 0;
                        itemFactoryMultiplier = 0;
                        itemFactoryPrice = 0;
                        itemCostMultiplier = 0;
                        itemProductCost = 0;
                        itemSalesMultiplier = 0;
                        itemUnitPrice = 0;
                        itemMaxQuantity = 0;
                        // Set the updated Variables
                        itemQuantity = configItem.Quantity__c;
                        itemProductId = configItem.Product__c;
                        itemLineNumber = configItem.Line_Number__c;
                        itemProductGroup = configItem.Product_Group__c;
                        itemProductCode = configItem.Product_Code__c;
                        itemSalesCode = configItem.Sales_Code__c;
                        itemCostCategory = configItem.Cost_Category__c;
                        itemCostType = configItem.Cost_Type__c;
                        // RVN and Configuration Records
                        itemRVN = configItem.RVN_Number__c;
                        itemConfigOption  = configItem.Id;
                        itemConfigProduct = configItem.Configuration_Product__c;
                        itemConfigPlan = configItem.Configuration_Plan__c;
                        configPlanIds.add(itemConfigPlan);
                        // Initial Price/Cost Values
                        itemBasePrice = plEntryBasePrice;
                        System.debug('--- itemBasePrice '+itemBasePrice);
                        // Retrieve the Factory Multiplier for Configurable Products and Accesories
                        hasFactoryPrice = factoryPriceMap.containsKey(itemProductGroup);
                        if(hasFactoryPrice) {
                            Map<String,Factory_Price__c> factoryCostTypeMap = factoryPriceMap.get(itemProductGroup);
                            //System.debug('--- Found Factory Price Parameter: '+factoryCostTypeMap);
                            Boolean hasFactoryCostType = factoryCostTypeMap.containsKey(itemCostType);
                            if(hasFactoryCostType) {
                                Factory_Price__c factoryPrice = factoryCostTypeMap.get(itemCostType);
                                itemFactoryMultiplier = factoryPrice.Factory_Multiplier__c;
                            }
                        }
                        System.debug('--- itemFactoryMultiplier '+itemFactoryMultiplier);
                        // Retrieve the Cost Multiplier for Services and Standard Products
                        // Only need to Check Product Cost if there is no Factory Multiplier as Factory Price and Cost Type are mutually exclusive
                        hasProductCost = productCostMap.containsKey(itemProductGroup);
                        if(hasProductCost) {
                            Map<String,Product_Cost__c> productCostTypeMap = productCostMap.get(itemProductGroup);
                            //System.debug('--- Found Product Cost Parameter: '+productCostTypeMap);
                            Boolean hasProductCostType = productCostTypeMap.containsKey(itemCostType);
                            if(hasProductCostType) {
                                Product_Cost__c productCost = productCostTypeMap.get(itemCostType);
                                itemCostMultiplier = productCost.Cost_Multiplier__c;
                            }
                        }
                        System.debug('--- itemCostMultiplier '+itemCostMultiplier);
                        // Retrieve the Sales Multiplier to define List Price of the Item
                        hasSalesPrice = salesPriceMap.containsKey(itemProductGroup);
                        //System.debug('--- Found '+itemProductGroup+' Sales Multipliers: '+hasSalesPrice);
                        if(hasSalesPrice) {
                            Map<String,sales_Price__c> salesCostTypeMap = salesPriceMap.get(itemProductGroup);
                            Boolean hasSalesCostType = salesCostTypeMap.containsKey(itemCostType);
                            //System.debug('--- Found '+itemProductGroup+'('+itemCostType+') Sales Multipliers: '+hasSalesPrice);
                            if(hasSalesCostType) {
                                sales_Price__c salesPrice = salesCostTypeMap.get(itemCostType);
                                if (salesPrice != null) {
                                    itemSalesMultiplier = salesPrice.sales_Multiplier__c;
                                    //System.debug('--- '+itemProductGroup+' itemSalesMultiplier: '+itemSalesMultiplier);
                                }
                            } else {
                            	System.debug('--- No '+itemProductGroup+' Sales Price Parameters with Cost Type '+itemCostType);
                            }
                        } else {
                            System.debug('--- No '+itemProductGroup+' Sales Price Parameters for Product Group: ' +itemProductGroup);
                            // If Item has no Sales Price skip to next Item in Loop
                            continue;
                        }
                        System.debug('--- Setting Prices!');
     /**************** PRICE CALCULATIONS *********************/
                        // Cost/Price per Unit -> Quote Line Items have "Unit" Prices as standard SalesCloud Features are applicable
                        //Decimal itemFactoryPricePerUnit = itemBasePrice * itemFactoryMultiplier;
                        //Decimal itemProductCostPerUnit = itemBasePrice * itemCostMultiplier;
                        //Decimal itemSalesPricePerUnit = itemBasePrice * itemSalesMultiplier;
                        //16.10.2023 Added Transmission
                        itemMaxQuantity = plEntryMaxQuantity;
                        itemMinPrice = plEntryMinimumPrice;
                        itemTransmission = plEntryTransmission;
                        Decimal itemFactoryPricePerUnit = itemBasePrice + (itemBasePrice * (itemFactoryMultiplier-1)*(itemTransmission/100));//BasePrice + (BasePrice *( FactoryX -1)* (Transmission/100)))
                        Decimal itemProductCostPerUnit = itemBasePrice + (itemBasePrice * (itemCostMultiplier-1)*(itemTransmission/100));//BasePrice + (BasePrice *( CostX -1)* (Transmission/100)))
                        Decimal itemSalesPricePerUnit = itemBasePrice + (itemBasePrice * (itemSalesMultiplier-1)*(itemTransmission/100));//BasePrice + (BasePrice *( SalesX -1)* (Transmission/100)))


                        System.debug('--- itemFactoryPricePerUnit '+itemFactoryPricePerUnit);
                        System.debug('--- itemProductCostPerUnit '+itemProductCostPerUnit);
                        System.debug('--- itemSalesPricePerUnit '+itemSalesPricePerUnit);
                        // 19.10.2023 Added Max Quantity update
                        // Check if Item has Max Quantity per Order
                        if (plEntryMaxQuantity>0 && plEntryMaxQuantity<itemQuantity) {
                            System.debug('--- Updating Item with Maximum Quantity ' +itemQuantity+' => '+plEntryMaxQuantity); 
                            itemQuantity = plEntryMaxQuantity;
                        }
                        
                        if(opportunityRecord.Chargeable__c != true) {
                            itemSalesPricePerUnit = 0;
                            itemSalesMultiplier = 0;
                        }

                        // Total Cost/Price per Line
                        Decimal itemTotalBasePrice = itemBasePrice * itemQuantity; // Total Factory Price for Line Item
                        Decimal itemTotalFactoryPrice = itemFactoryPricePerUnit * itemQuantity; // Total Factory Price for Line Item
                        Decimal itemTotalProductCost = itemProductCostPerUnit * itemQuantity; // Total Product Cost for Line Item
                        Decimal itemTotalSalesPrice = itemSalesPricePerUnit * itemQuantity; // Total Product Cost for Line Item
                        System.debug('--- itemTotalFactoryPrice '+itemTotalFactoryPrice);
                        System.debug('--- itemTotalProductCost '+itemTotalProductCost);
                        System.debug('--- itemTotalSalesPrice '+itemTotalSalesPrice);
                        /* For New Items add the parent Id = QuoteId and  Price Book Entry (from the Opportunity Pricebook) or Product */
                        QuoteLineItem quoteLineItemToUpsert = new QuoteLineItem();
                        // Optionally set these is Known
                        quoteLineItemToUpsert.Configuration_Plan__c = itemConfigPlan;
                        quoteLineItemToUpsert.Configuration_Product__c = itemConfigProduct;
                        quoteLineItemToUpsert.Configuration_Option__c = itemConfigOption;
                        // Item Identifiers
                        quoteLineItemToUpsert.Line_Number__c = itemLineNumber;
                        quoteLineItemToUpsert.Product_Group__c = itemProductGroup;
                        quoteLineItemToUpsert.Cost_Category__c = itemCostCategory;
                        quoteLineItemToUpsert.Cost_Type__c = itemCostType;
                        //quoteLineItemToUpsert.Product_Code__c = itemProductCode;
                        quoteLineItemToUpsert.Sales_Code__c = itemSalesCode;
                        quoteLineItemToUpsert.RVN_Number__c = itemRVN;
                        // Quantity
                        quoteLineItemToUpsert.Quantity = itemQuantity;
                        // Special Price Attributes
                        quoteLineItemToUpsert.Max_Quantity__c = itemMaxQuantity;
                        quoteLineItemToUpsert.Min_Price__c = itemMinPrice;
                        quoteLineItemToUpsert.Transmission__c = itemTransmission;
                        
                        //Price parameter multipliers updated (DONE BY SAI)
                        quoteLineItemToUpsert.Factory_Multiplier__c = itemFactoryMultiplier;
                        quoteLineItemToUpsert.Cost_Multiplier__c = itemCostMultiplier;
                        quoteLineItemToUpsert.Sales_Multiplier__c = itemSalesMultiplier; 
                        // Id.valueOf(...) used here to convert 15 char id to 18 char id
                        // For Configuration Products 
                        String uniquelookupCode = Id.valueOf(itemConfigPlan)+'-'+itemProductGroup+'-'+itemSalesCode+'-'+itemQuantity.setScale(5)+'-'+itemLineNumber;
                        System.debug('--- Looking for: '+uniquelookupCode);
                        Boolean isExisting = uniqueIdToLineItemMap.containskey(uniquelookupCode);
                        if (isExisting)  {
                            // Generate the Updated Configuration Item
                            QuoteLineItem existingQuoteLineItem = uniqueIdToLineItemMap.get(uniquelookupCode);
                            quoteLineItemToUpsert.Id = existingQuoteLineItem?.Id;
                            quoteLineItemToUpsert.UnitPrice = existingQuoteLineItem?.UnitPrice;
                            quoteLineItemToUpsert.Contracted_Sales_Price__c = existingQuoteLineItem?.Contracted_Sales_Price__c;
                            quoteLineItemToUpsert.Product_Category__c = existingQuoteLineItem?.Product2.Product_Category__c;
                            System.debug('--- Found existing QuoteLine Entry: '+quoteLineItemToUpsert.Id );
                        } else {
                            quoteLineItemToUpsert.quoteId = syncedQuoteId; // Parent Record = Configuration Product
                            quoteLineItemToUpsert.PricebookEntryId = pbEntryId;
                            System.debug('--- No Existing QuoteLine Entry for: '+uniquelookupCode);
                        }

                        /************** Price Updates ****************/
                        // Minimum Price Check
                        // Check if there the Item has a Quantity
                        System.debug('--- Item Total Quantity for '+itemProductCode);
                        System.debug('--- Item Total Quantity from '+productCodeToQuantityMap);
                        Boolean hasTotalQuantity = productCodeToQuantityMap.containsKey(itemProductCode);
                        if(hasTotalQuantity) {
                            itemTotalQuantity = productCodeToQuantityMap.get(itemProductCode);
                            System.debug('--- Item Total Quantity: '+itemTotalQuantity);
                        }
                        // Only for Minimal Price
                        Decimal itemTotalPriceInGroup = itemTotalQuantity * plEntryBasePrice;
                        if (hasTotalQuantity 
                            && plEntryMinimumPrice > 0 && itemTotalPriceInGroup > 0
                            && itemTotalPriceInGroup < plEntryMinimumPrice && itemTotalQuantity > 0) {
                            // Need to get Total Quantity for this Item per "Product Group" to determine if min Price needs to be Applied
                            // Using Total Quantity from Aggregated Query in Step 8
                            itemMinPricePerUnit = plEntryMinimumPrice/itemTotalQuantity;
                            // Update Factory Price after setting Minimum
                            //itemTotalFactoryPrice = plEntryMinimumPrice * itemFactoryMultiplier;
                            itemTotalFactoryPrice = plEntryMinimumPrice + (plEntryMinimumPrice * (itemFactoryMultiplier-1)*(itemTransmission/100));//MinPrice + (MinPrice *( FactoryX -1)* (Transmission/100)))
                            itemFactoryPricePerUnit = itemTotalFactoryPrice / itemTotalQuantity;
                            // Update Product Cost after setting Minimum
                            //itemTotalProductCost = plEntryMinimumPrice * itemCostMultiplier;
                            itemTotalProductCost = plEntryMinimumPrice + (plEntryMinimumPrice * (itemCostMultiplier-1)*(itemTransmission/100));//MinPrice + (MinPrice *( CostX -1)* (Transmission/100)))
                            itemProductCostPerUnit = itemTotalProductCost / itemTotalQuantity;
                            // Update Sales Price after setting Minimum
                            //itemTotalSalesPrice = plEntryMinimumPrice * itemSalesMultiplier;
                            itemTotalSalesPrice = plEntryMinimumPrice + (plEntryMinimumPrice * (itemSalesMultiplier-1)*(itemTransmission/100));//MinPrice + (MinPrice *( SalesX -1)* (Transmission/100)))
                            itemSalesPricePerUnit = itemTotalSalesPrice / itemTotalQuantity;
                            // Update Base Price
                            itemTotalBasePrice = plEntryMinimumPrice;
                            itemBasePrice = itemTotalBasePrice / itemTotalQuantity;
                        } else {
                            itemMinPricePerUnit = 0;
                        }
                        /******************* */
                        // Unit Prices
                        quoteLineItemToUpsert.Base_Price__c = itemBasePrice;
                        quoteLineItemToUpsert.Min_Sales_Price__c = itemMinPricePerUnit;               
                        quoteLineItemToUpsert.Factory_Price__c = itemFactoryPricePerUnit;// Factory Price per Unit
                        System.debug('--- Factory Price: '+itemFactoryPricePerUnit);
                        quoteLineItemToUpsert.Product_Cost__c = itemProductCostPerUnit; // Product Cost per Unit
                        System.debug('--- Product Cost: '+itemProductCostPerUnit);
                        quoteLineItemToUpsert.Sales_Price__c = itemSalesPricePerUnit;// Sales Price per Unit (UnitPrice)
                        System.debug('--- List Price: '+itemSalesPricePerUnit);
                        //quoteLineItemToUpsert.ListPrice = lineTotalPrice; // QuoteLineItem List Price (standard Field) not writeable
                        quoteLineItemToUpsert.UnitPrice = itemSalesPricePerUnit; // QuoteLineItem Unit Price (standard Field), actual Line Total not Unit Price    
                        System.debug('--- Unit Price: '+itemSalesPricePerUnit);                    
                        // Price Attributes
                        quoteLineItemToUpsert.List_Price__c = itemTotalSalesPrice; // For possible check in LWC Component
                        System.debug('--- Sales Price: '+itemSalesPricePerUnit);
                        // Add updated Option Record to Collection
                        quoteLineItemsToUpsert.add(quoteLineItemToUpsert);
                        System.debug('--- Adding Quote Line '+quoteLineItemToUpsert);
                    }  else {
                        System.debug('--- NO Pricing Data for Item '+itemLookupCode);
                    }
                }
            }
            System.debug('--- '+quoteLineItemsToUpsert.size()+' New or Changed QuoteLine(s)');
            if (!quoteLineItemsToUpsert.isEmpty()) {
                // The additional and extra quote line items are needed here
                Set<Id> quoteLineItemsToUpsertIds = new Set<Id>();
                for(QuoteLineItem qli : quoteLineItemsToUpsert) {
                    if(qli.Id != null) {
                        quoteLineItemsToUpsertIds.add(qli.Id);
                    }
                }
                for(QuoteLineItem quoteLineItem : uniqueIdToLineItemMap.values())  {
                    if((quoteLineItem.Product_Group__c == PricingExtraSalesController.EXTRA_SALES_PRODUCT_GROUP
                            || quoteLineItem.Product_Category__c == PricingAdditionalCostsController.ADDITIONAL_COST_PRODUCT_CATEGORY
                            || quoteLineItem.Product2.Product_Category__c == PricingAdditionalCostsController.ADDITIONAL_COST_PRODUCT_CATEGORY
                        ) && !quoteLineItemsToUpsertIds.contains(quoteLineItem.Id)
                    ) {
                        if(opportunityRecord.Chargeable__c != true) {
                            quoteLineItem.UnitPrice = 0;
                            quoteLineItem.Sales_Multiplier__c = 0;
                        }
                        quoteLineItemsToUpsert.add(quoteLineItem);
                    }
                }
                setOrderSpecificPrices(quoteLineItemsToUpsert);

                recalculateDiscountOrSalesprice(
                    PricingSummaryService.ALLOWED_OPPORTUNITY_STAGES.contains(opportunityRecord.StageName),
                    pricingSummary,
                    quoteLineItemsToUpsert
                );
                upsert quoteLineItemsToUpsert;
                for (QuoteLineItem upsertedLineItem : quoteLineItemsToUpsert){
                    lineItemIds.add(upsertedLineItem.Id);
                }
            }
            System.debug('--- '+lineItemIds.size()+' Created or Updated QuoteLine(s)');
            obsoleteQuoteLineItems = [
                SELECT Id
                FROM QuoteLineItem
                WHERE QuoteId =: syncedQuoteId
                AND Id NOT IN :lineItemIds
                AND Configuration_Plan__c IN: configPlanIds
                ORDER BY CreatedDate DESC
            ];
            System.debug('--- '+obsoleteQuoteLineItems.size()+' QuoteLine(s) to Delete');
            if (obsoleteQuoteLineItems.size()>0) {
                delete obsoleteQuoteLineItems;
            }
        } catch (Exception e) {
            System.debug('--- The following exception has occurred: ' + e.getMessage());
            throw new CustomException(e.getMessage());
        }
        System.debug('--- Updated '+lineItemIds.size()+' Quote Line(s)');
        System.debug('--- Deleted '+obsoleteQuoteLineItems.size()+' Quote Line(s)');
        return 'success';
    }
    
    public static void recalculateDiscountOrSalesprice(
        Boolean keepSalesPrice,
        Pricing_Summary__c pricingSummary,
        List<QuoteLineItem> quoteLineItems
    ) {
        Decimal listPrice = 0.0;
        Decimal salesPrice = 0.0;
        for (QuoteLineItem quoteLineItem : quoteLineItems) {
            listPrice += quoteLineItem.Sales_Multiplier__c > 0 ? quoteLineItem.List_Price__c : 0;
            salesPrice += quoteLineItem.Sales_Multiplier__c > 0 ? quoteLineItem.UnitPrice * quoteLineItem.Quantity : 0;
        }
        if (pricingSummary.Sales_Price__c == null) {
            pricingSummary.Sales_Price__c = salesPrice;
            upsert pricingSummary;
            return;
        } else if (listPrice == 0 || salesPrice == pricingSummary.Sales_Price__c) {
            return;
        }

        if (keepSalesPrice) {
            Decimal discount = 0.0;
            System.debug('--- Keep Sales Prices');
            if (listPrice != 0) {
                System.debug('--- List Price: '+listPrice);
                System.debug('--- locked SalesPrice: '+pricingSummary.Sales_Price__c);
                discount = (1 - pricingSummary.Sales_Price__c / listPrice) * 100;
                System.debug('--- Discount: '+discount);
            }
            for (QuoteLineItem quoteLineItem : quoteLineItems) {
                quoteLineItem.Discount__c = discount;
                System.debug('--- QuoteLine Item Code: '+quoteLineItem.Product2.ProductCode);
                System.debug('--- QuoteLine Item Quantity: '+quoteLineItem.Quantity);
                System.debug('--- QuoteLine Item Discount: '+quoteLineItem.Discount__c);
            }
        } else {
            Decimal discount = 0.0;
            if (listPrice != 0) {
                discount = (1 - pricingSummary.Sales_Price__c / listPrice) * 100;
            }
            for (QuoteLineItem quoteLineItem : quoteLineItems) {
                if (quoteLineItem.Quantity != 0 && quoteLineItem.Sales_Multiplier__c > 0) {
                    quoteLineItem.UnitPrice = ((1 - discount / 100) * quoteLineItem.List_Price__c) / quotelineItem.Quantity;
                }
            }
        }
    }
    
    private class CompareByListPrice implements Comparator<QuoteLineItem> {
        public Integer compare(QuoteLineItem q1, QuoteLineItem q2) {
            if(q1?.List_Price__c == null && q2?.List_Price__c == null) {
                return 0;
            } else if(q1?.List_Price__c == null) { 
                return -1; 
            } else if(q2?.List_Price__c == null) {
                return 1;
            }        
            return q1.List_Price__c > q2.List_Price__c ? -1 : 1;
        }
    }

    public static void setOrderSpecificPrices(List<QuoteLineItem> quoteLineItems) {
        Map<String, Decimal> itemMaxQuantities = new Map<String, Decimal>();
        Map<String, Integer> duplicateItemsWithMaxQuantity = new Map<String, Integer>();
        for (QuoteLineItem quoteLineItem : quoteLineItems) {
            if(quoteLineItem.Max_Quantity__c >= 1) {
                duplicateItemsWithMaxQuantity.put(quoteLineItem.Sales_Code__c, 0);
                itemMaxQuantities.put(quoteLineItem.Sales_Code__c, quoteLineItem.Max_Quantity__c);
            }
        }
        // Sort in ascending order by list price so that the most expensive QuoteLineItem is kept
        quoteLineItems.sort(new CompareByListPrice());
        for (QuoteLineItem quoteLineItem : quoteLineItems) {
            if(duplicateItemsWithMaxQuantity.containsKey(quoteLineItem.Sales_Code__c)) {
                Integer amountOfSalesCodes = duplicateItemsWithMaxQuantity.get(quoteLineItem.Sales_Code__c);
                if(amountOfSalesCodes == null) {
                    amountOfSalesCodes = 0;
                }
                amountOfSalesCodes += 1;
                duplicateItemsWithMaxQuantity.put(quoteLineItem.Sales_Code__c, amountOfSalesCodes);
                if(amountOfSalesCodes > quoteLineItem.Max_Quantity__c) {
                    quoteLineItem.Base_Price__c = 0;
                    quoteLineItem.Sales_Price__c = 0;
                    quoteLineItem.UnitPrice = 0;
                    quoteLineItem.List_Price__c = 0;
                }
            }
        }
    }
    
    public static void populateAdditionalProductParameters(List<Configuration_Product__c> configurationProducts) {
        Map<String, String> structureToConfigurationField = new Map<String, String>{
            'side_amount' => 'Side_Amount__c',
            'glass_panel_amount' => 'Glass_Panel_Amount__c',
            'upper_profile_color' => 'Upper_Profile_Color__c',
            'lower_profile_color' => 'Lower_Profile_Color__c',
            'lower_profile_seal' => 'Lower_Profile_Seal__c',
            'drain_holes' => 'Drain_Holes__c',
            'different_height_sides' => 'Different_Height_Sides__c',
            'lower_milling' => 'Lower_Milling__c',
            'upper_seal' => 'Upper_Seal__c',
            'upper_profile' => 'Upper_Profile__c',
            'lower_profile' => 'Lower_Profile__c',
            'upper_fastening_material' => 'Upper_Fastening_Material__c',
            'lower_fastening_material' => 'Lower_Fastening_Material__c'
        };
        Map<String, Configuration_Product__c> configurationProductsByVisualId = new Map<String, Configuration_Product__c>(
            configurationProducts
        );
        Set<Id> configurationPlanIds = new Set<Id>();
        for (Configuration_Product__c product : configurationProducts) {
            if(String.isNotBlank(product.Configuration__c)) {
                configurationProductsByVisualId.put('Visual Output_' + product.Visual_Structure_Number__c, product);
                configurationPlanIds.add(String.valueOf(product.Configuration__c));
            }
        }
        if(configurationPlanIds.isEmpty()) {
            return;
        }
        // Scoped query to save as much heap as possible
        for (ContentDocumentLink link : [
            SELECT ContentDocument.Title, ContentDocument.LatestPublishedVersion.VersionData
            FROM ContentDocumentLink
            WHERE
                LinkedEntityId IN (SELECT Id FROM Configuration__c WHERE Id IN :configurationPlanIds)
                AND ContentDocument.Title LIKE 'Visual Output%'
            LIMIT 100
        ]) {
            try {
                VisualStructure structure = (VisualStructure) JSON.deserialize(
                    link.ContentDocument.LatestPublishedVersion.VersionData.toString(),
                    VisualStructure.class
                );
                // TODO How to handle multiple product opnenings with multiple RVNs?
                Map<String, Object> productOpening = (Map<String, Object>) JSON.deserializeUntyped(
                    JSON.serialize(structure.Product_opening.get(0))
                );
                Configuration_Product__c configurationProduct = configurationProductsByVisualId.get(
                    link.ContentDocument.Title
                );
                for (String field : structureToConfigurationField.keySet()) {
                    configurationProduct.put(structureToConfigurationField.get(field), productOpening.get(field));
                }
            } catch (Exception e) {
                System.debug(e);
            }
        }
    }
}