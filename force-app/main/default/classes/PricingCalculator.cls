/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-05-2023
 * @last modified by  : Henk Reynders
**/
public with sharing class PricingCalculator {
    @AuraEnabled
    public static String calculatePrices(String configId, String recordId){
        System.debug('--- Processing new or Updated QuoteLines');
        String errorMessage;
        String successMessage;
        // Pricing related Variables
        String ParentObject;
        // Salesforce Configuration Plan Variables
        String configPlanId; // Configuration Id
        String opportunityId;
        String quoteId;
        String pricebookId;
        String pricelistId;
        Date closingDate;
        String currencyCode;
        Boolean installation = false;
        Boolean reclamation = false;
        Opportunity opportunityRecord;
        Quote quoteRecord;

        // Configuration Variables
        List<Configuration__c> configPlans = new List<Configuration__c>(); // Existing Configuration Plans
        List<Configuration_Product__c> configProducts = new List<Configuration_Product__c>(); // Existing Configuration Products
        List<Configuration_Option__c> configItems= new List<Configuration_Option__c>(); // Existing Configuration Items

        // Line Item Variables
        String existingProductId;
        String existingQuoteLineItemId;
        List<QuoteLineItem> existingQuoteLineItems = new List<QuoteLineItem>(); 
        List<QuoteLineItem> lineItemsToUpdate = new List<QuoteLineItem>(); 
        List<QuoteLineItem> obsoleteQuoteLineItems = new List<QuoteLineItem>(); // Outdated Configuration Options as in File configJSON
        List<Id> lineItemIds = new List<Id>();

        List<String> updatedLineItemIds = new List<String>();

        // Salesforce Configuration Item Variables
        String  itemId; // QuoteLine Item Identifier
        String  itemLookupCode; // Product Item Identifier
        Decimal itemQuantity; // Item Quantity
        String  itemProductId; // Item Product2Id
        Decimal itemLineNumber; // Item Line
        String  itemProductGroup; // Item Group (=main Product)
        String  itemCostType;
        String itemCostCategory;
        String  itemProductCode; // Item Product Code (=main Product+SalesCode)
        String  itemSalesCode; // Item SalesCode (Ax Code)
        String  itemRVN; // Item RVN (Unique Code)
        Decimal itemBasePrice;
        Decimal itemListPrice; // Item List Price from Pricebook
        Decimal itemUnitPrice; // Standard Sales Price 
        Decimal itemSalesPrice; // Calculated and editable
        Decimal itemDiscount;
        Decimal itemSubTotal;
        Decimal itemTotal;
        Decimal itemFactory;
        Decimal itemCost;
        Decimal itemSales;

        // Salesforce PriceBook2 Variables
        String productLookupCode; // Product Identifier
        String pbEntryId; // Pricebook Entry Id
        String pbEntryProductId; // Pricebook Entry Product Id
        String pbEntryProductCode;// Code of the Product
        String pbEntrySalesCode;
        String pbEntryName; // Pricebook Entry Product Name
        String pbEntryUoM; // Pricebook Entry Product UoM 
        String pbEntryCostCategory; // Grouping of Cost Types for Order XML data prep
        String pbEntryCostType; // Grouping of Product for Pricing data prep
        String pbEntryProductCategory; // Product Category of the Product
        String pbEntryProductType;// Product Type of the Product
        String pbEntryProductItem;// Product Type of the Product
        Decimal pbEntryStandardPrice;// Standard Price of the Product
        Decimal pbEntryUnitPrice;// List Price of the Product
        Decimal pbEntryMinimumPrice;// Minimum Price of the Product
        Decimal pbEntryMaxQuantity;// Maximum Quantity of the Product per Order
        PricebookEntry pbEntry; // Pricebook Entry Record
        Boolean pbEntryKeyFound; // Pricebook Entry Map Key
        Map<String,PricebookEntry> pricebookEntryMap  = new Map<String,PricebookEntry>();  // Map for Lookup or Product and Prices
        // Salesforce Pricing Parameter Variables
        List<String> configuredProducts = new List<String>();
        Map<String,Map<String,Factory_Price__c>> factoryPriceMap = new Map<String,Map<String,Factory_Price__c>>();
        Map<String,Factory_Price__c> factoryPricePerCostType = new Map<String,Factory_Price__c>();
        Map<String,Map<String,Product_Cost__c>> productCostMap = new Map<String,Map<String,Product_Cost__c>>();
        Map<String,Product_Cost__c> productCostPerCostType = new Map<String,Product_Cost__c>();
        Map<String,Map<String,Sales_Price__c>> salesPriceMap = new Map<String,Map<String,Sales_Price__c>>();
        Map<String,Sales_Price__c> salesPricePerCostType = new Map<String,Sales_Price__c>();
        try { 
            //Check  which is the Parent Object based on RecordId 
            System.debug('--- Calculate Prices for Configuration Items');
            // Step 1: check Parent Object
            if (String.isNotBlank(recordId)){
                parentObject = DynamicObjectUtils.getObjectType(recordId);
            } else {
                errorMessage = 'No Parent Record Available!';
                System.debug('--- ABORT '+errorMessage);
                throw new CustomException(errorMessage);
            }
            // Step 2: get Opportunity and Quote Records
            if (parentObject=='Opportunity' && String.isNotBlank(recordId)){  
                opportunityId = recordId;
                //Get Opportunity Record 
                opportunityRecord = OpportunityProductController.getOpportunityRecord(opportunityId);
                // Set Pricing Related Attributes 
                pricebookId = opportunityRecord.pricebook2Id;                      
                currencyCode = opportunityRecord.CurrencyIsoCode; 
                closingDate = opportunityRecord.CloseDate;
                System.debug('--- Opportunity uses Pricebook '+pricebookId+' in ' +currencyCode); 
                if (String.isBlank(quoteId)){
                    quoteId = opportunityRecord.SyncedQuoteId;
                    quoteRecord = QuoteController.getQuoteRecord(quoteId);
                }
                System.debug('--- Using Opportunity '+opportunityId+' and Quote ' +quoteId); 
            } else if (parentObject=='Quote' && String.isNotBlank(recordId)){  
                quoteId = recordId;
                //Get quote Record 
                quoteRecord = QuoteController.getQuoteRecord(quoteId);
                opportunityId = quoteRecord.opportunityId;
                opportunityRecord = OpportunityProductController.getOpportunityRecord(opportunityId);
                // Set Related Records
                pricebookId = opportunityRecord.pricebook2Id;                      
                currencyCode = opportunityRecord.CurrencyIsoCode; 

                System.debug('--- Using Opportunity Pricebook '+pricebookId+' in ' +currencyCode); 
            }
            // Step 3a: set the expected Closure Date
            String closingDateStr = closingDate.format();
            if (String.isBlank(closingDateStr)) {    
                closingDate = system.Today();
            }
            // Step 3b: get Valid PriceList
            if (String.isNotBlank(closingDateStr)) {                  
                // Get PriceList
                Pricebook2 pricelist = new Pricebook2();
                if(Test.isRunningTest()){
                    //Invoke mock web service response
                    Id pbid = Test.getStandardPricebookId();
                    pricelistId = pbId;
                 } else{
                    //pricelist = PriceBookEntryController.getPriceList(pricebookId,closingDate);
                    pricelistId = pricelist.Id;
                 }
            } 
            // Step 3c: get PriceList Entries
            if (String.isNotBlank(pricelistId) && String.isNotBlank(currencyCode)) {                  
                // Get Pricebook Entry Map to find Product Ids
                pricebookEntryMap = PriceBookEntryController.getPricebookEntryMap(pricelistId,currencyCode);
                System.Debug('--- Found PriceList with '+pricebookEntryMap.size()+' Entries');
            } else {
                errorMessage = 'No PriceList to Use!';
                System.debug('--- ABORT '+errorMessage);
                throw new CustomException(errorMessage);
            }
            // Step 4: Get Existing Quote Lines
            if(String.isNotBlank(quoteId)) {
                existingQuoteLineItems = ([SELECT Id,
                                        Product2Id,
                                        Product2.ProductCode,
                                        Cost_Category__c,
                                        Cost_Type__c,
                                        Sales_Code__c,
                                        Line_Number__c,
                                        RVN_Number__c,
                                        Product_Group__c,
                                        Base_Price__c, 
                                        Quantity,                                     
                                        ListPrice,                                  
                                        UnitPrice, 
                                        SubTotal,
                                        Discount,
                                        TotalPrice                      
                                FROM QuoteLineItem
                                WHERE QuoteId =: quoteId 
                                ORDER BY CreatedDate DESC]);
                System.debug('--- '+existingQuoteLineItems.size()+' existing QuoteLineItem(s)');
            }
            // Step 5: Get Pricing Parameters
            if (existingQuoteLineItems.size()>0) {                  
                List<AggregateResult>  aggrItemGroups = ([SELECT Product_Group__c itemGroup
                                            FROM QuoteLineItem
                                            WHERE QuoteId =: quoteId 
                                            GROUP BY Product_Group__c]);
                for(AggregateResult aggrItemGroup :aggrItemGroups){
                    String itemGroup = (String)aggrItemGroup.get('itemGroup');
                    if (String.isNotBlank(itemGroup)) {
                        configuredProducts.add(itemGroup);
                    }
                }
            }
            if (configuredProducts.size()>0) {
                //Organization_Attribute__c,Country_Attribute__c,//Tier 1 Factory Prices
                String org = opportunityRecord.Organization_Attribute__c;
                String country = opportunityRecord.Country_Attribute__c;
                String business =  opportunityRecord.Business_Type_Attribute__c;
                factoryPriceMap = PricingParameterController.getFactoryPrices(configuredProducts,org,country,business); 
                System.debug('--- '+factoryPriceMap.size()+ ' Factory Parameters');
                for (String configuredProduct : configuredProducts ) {
                    System.debug('--- '+factoryPriceMap.get(configuredProduct).size() +' Factory Parameters');
                }
                
                //Territory_Attribute__c,Business_Type_Attribute__c,//Tier 2 Product Costs
                String territory = opportunityRecord.Territory_Attribute__c;
                String district = opportunityRecord.District_Attribute__c;
                productCostMap = PricingParameterController.getProductCosts(configuredProducts,org,country,business,district); 
                System.debug('--- '+productCostMap.size()+ ' Cost Parameters');

                //Owner_Profit_Center__c, Customer_Attribute__c, //Tier 3 Sales Prices   
                String profitCenter = opportunityRecord.Owner_Profit_Center__c;
                String customer = opportunityRecord.Customer_Attribute__c;// For Consumers in Finland 1905514-0
                salesPriceMap = PricingParameterController.getSalesPrices(configuredProducts,org,country,business,district,profitCenter,customer); 
                System.debug('--- '+salesPriceMap.size()+ ' Price Parameters');
            }
            // Step 6: Loop Configuration Items
            if (existingQuoteLineItems.size()>0) {    
                for (QuoteLineItem existingQuoteLineItem : existingQuoteLineItems) {
                    System.debug('--- existing QuoteLineItem: '+existingQuoteLineItem);
                    // Find the Pricebook Entry and Product
                    itemLookupCode = existingQuoteLineItem.Product2.ProductCode;
                    System.debug('--- Check Pricebook Entry for itemCode '+itemLookupCode);
                    pbEntryKeyFound = pricebookEntryMap.containsKey(itemLookupCode);
                    if(pbEntryKeyFound) {   
                        pbEntry = (PricebookEntry) pricebookEntryMap.get(itemLookupCode);
                        if (!pbEntry.Product2.Reclamation__c) {
                            pbEntryProductId = pbEntry.Product2Id;
                            pbEntryId = pbEntry.Id;
                            pbEntryProductCode = pbEntry.Product2.ProductCode;
                            pbEntrySalesCode = pbEntry.Product2.Sales_Code__c;
                            pbEntryUnitPrice = pbEntry.UnitPrice;
                            pbEntryMinimumPrice = pbEntry.Minimum_Price__c;
                            pbEntryMaxQuantity = pbEntry.Quantity_per_Order__c;
                            //pbEntryStandardPrice = pbEntry.StandardPrice;// Standard Price of the Product
                            pbEntryUoM = pbEntry.Product2.QuantityUnitOfMeasure;
                            pbEntryName = pbEntry.Product2.Name;
                            System.debug('--- Found Pricebook Entry for Item '+itemLookupCode+': '+pbEntry); 
                        } else {
                            System.debug('--- Found Reclamation Pricebook Entry '+pbEntry); 
                        }
                    } else {
                        System.debug('--- NO Pricebook Entry for Item '+itemLookupCode); 
                    }
                    // Set the Variables with existing Values
                    itemId = existingQuoteLineItem.Id; // Reference to QuoteLineItemId
                    itemQuantity = existingQuoteLineItem.Quantity;
                    itemProductId = existingQuoteLineItem.Product2Id;
                    itemLineNumber = existingQuoteLineItem.Line_Number__c;
                    itemProductCode = existingQuoteLineItem.Product2.ProductCode;
                    itemSalesCode = existingQuoteLineItem.Sales_Code__c;
                    itemRVN = existingQuoteLineItem.RVN_Number__c;
                    itemBasePrice = existingQuoteLineItem.Base_Price__c;
                    itemProductGroup = existingQuoteLineItem.Product_Group__c;
                    itemCostType = existingQuoteLineItem.Cost_Type__c;
                    itemCostCategory = existingQuoteLineItem.Cost_Category__c;
                    itemListPrice = existingQuoteLineItem.ListPrice;
                    itemUnitPrice = existingQuoteLineItem.UnitPrice;
                    itemDiscount = existingQuoteLineItem.Discount;
                    itemSubtotal = existingQuoteLineItem.Subtotal;
                    itemTotal = existingQuoteLineItem.TotalPrice;
                    // Get Price Parameters
                    System.debug('--- Factory Price Parameter per Product Map '+factoryPriceMap); 
                    Boolean factoryPriceKeyFound = factoryPriceMap.containsKey(itemProductGroup);
                    Decimal factoryMultiplier = 0;
                    if(factoryPriceKeyFound) {   
                        System.debug('--- Found Factory Price Parameter for Product '+itemProductGroup); 
                        Map<String,Factory_Price__c> factoryCostTypes = factoryPriceMap.get(itemProductGroup);
                        System.debug('--- Factory Price Parameter per Cost Type Map '+factoryCostTypes); 
                        Boolean factoryPriceTypeKeyFound = factoryCostTypes.containsKey(itemCostType);
                        if(factoryPriceTypeKeyFound) { 
                            Factory_Price__c factoryPrice = factoryCostTypes.get(itemCostType);
                            System.debug('--- Found Factory Price Parameter for Product Group '+itemProductGroup+' and Cost Type '+itemCostType); 
                            System.debug('--- Factory Price Parameter '+factoryPrice); 
                            factoryMultiplier = factoryPrice.Factory_Multiplier__c;
                        } else {
                            System.debug('--- No Factory Price Parameter for Product Group '+itemProductGroup+' and Cost Type '+itemCostType);
                        }
                    } else {
                        System.debug('--- No Factory Price Parameter for Product Group' +itemProductGroup); 
                    }
                    System.debug('--- Product Cost Parameter per Product Map '+productCostMap); 
                    Boolean productCostKeyFound = productCostMap.containsKey(itemProductGroup);
                    Decimal costMultiplier = 0;
                    if(productCostKeyFound) {   
                        System.debug('--- Found Product Cost Parameter for Product Group '+itemProductGroup); 
                        Map<String,Product_Cost__c> productCostTypes = productCostMap.get(itemProductGroup);
                        System.debug('--- Product Cost Parameter per Cost Type Map '+productCostTypes); 
                        Boolean productCostTypeKeyFound = productCostTypes.containsKey(itemCostType);
                        if(productCostTypeKeyFound) { 
                            Product_Cost__c productCost = productCostTypes.get(itemCostType);
                            System.debug('--- Found Product Cost Parameter for Product Group'+itemProductGroup+' and Cost Type '+itemCostType); 
                            System.debug('--- Product Cost Parameter '+productCost); 
                            costMultiplier = productCost.Cost_Multiplier__c;
                        } else {
                            System.debug('--- No Product Cost Parameter for Product Group'+itemProductGroup+' and Cost Type '+itemCostType);
                        }
                    } else {
                        System.debug('--- No Product Cost Parameter for Product Group'+itemProductGroup); 
                    }
                    System.debug('--- Sales Price Parameter per Product Map '+salesPriceMap); 
                    Boolean salesPriceKeyFound = salesPriceMap.containsKey(itemProductGroup);
                    Decimal salesMultiplier = 0;
                    if(salesPriceKeyFound) {   
                        System.debug('--- Found Sales Price Parameter for Product '+itemProductGroup); 
                        Map<String,sales_Price__c> salesCostTypes = salesPriceMap.get(itemProductGroup);
                        System.debug('--- Sales Price Parameter per Cost Type Map '+salesCostTypes); 
                        Boolean salesPriceTypeKeyFound = salesCostTypes.containsKey(itemCostType);
                        if(salesPriceTypeKeyFound) { 
                            sales_Price__c salesPrice = salesCostTypes.get(itemCostType);
                            System.debug('--- Found Sales Price Parameter for Product Group '+itemProductGroup+' and Cost Type '+itemCostType); 
                            System.debug('--- Sales Price Parameter '+salesPrice); 
                            salesMultiplier = salesPrice.sales_Multiplier__c;
                        } else {
                            System.debug('--- No Sales Price Parameter for Product Group '+itemProductGroup+' and Cost Type '+itemCostType);
                        }
                    } else {
                        System.debug('--- No Sales Price Parameter for Product Group' +itemProductGroup); 
                    }
                    // prepare QuoteLine Price updates
                    QuoteLineItem lineItemToUpdate = new QuoteLineItem();
                    if (!String.isBlank(itemId)){
                        lineItemToUpdate.Id = itemId;
                    } else {
                        // Should not enter here as items are only updated and parent record relation is already there
                        lineItemToUpdate.quoteId = quoteId; // Parent Record = Configuration Product
                    }
                    lineItemToUpdate.Base_Price__c = pbEntryUnitPrice; 
                    lineItemToUpdate.Factory_Multiplier__c = factoryMultiplier;
                    lineItemToUpdate.Cost_Multiplier__c = costMultiplier;
                    lineItemToUpdate.Sales_Multiplier__c = salesMultiplier;
                    // Set SalesPrice to Calculated result
                    Decimal calcSalesPrice = lineItemToUpdate.Base_Price__c * lineItemToUpdate.Sales_Multiplier__c; //Unit List Price
                    // Check if Item has Max Quantity per Order
                    if (pbEntryMaxQuantity>0 && pbEntryMaxQuantity<itemQuantity) {
                        System.debug('--- Updating Item with Maximum Quantity ' +itemQuantity+' => '+pbEntryMaxQuantity); 
                        itemQuantity = pbEntryMaxQuantity;
                    }
                    Decimal calcTotalPrice = calcSalesPrice * itemQuantity; // Sales Price for Total Quantity
                    // Check if Item has minimum Sales Price
                    Decimal minSalesPrice = pbEntryMinimumPrice;
                    if (minSalesPrice>0 && calcSalesPrice<minSalesPrice) {
                        System.debug('--- Updating Item with Minimum Price ' +calcSalesPrice+' => '+minSalesPrice); 
                        calcSalesPrice = minSalesPrice;
                    }
                    
                    // Check if User has changed Sales Price
                    Decimal currentSalesPrice = lineItemToUpdate.UnitPrice;
                    if (currentSalesPrice>0 && currentSalesPrice != calcSalesPrice) {
                        lineItemToUpdate.UnitPrice = currentSalesPrice;
                    } else {
                        lineItemToUpdate.UnitPrice = calcSalesPrice; // This is the Value that Sales User can Change 
                    }
                    // List Price can not be written as it is set by pricebook so use custom Field
                    lineItemToUpdate.List_Price__c = calcSalesPrice; // Keep this as reference for Calculated Price

                    // Fields not to update on price calculation
                    //lineItemToUpdate.ListPrice = pbEntryListPrice; 
                    //lineItemToUpdate.Quantity = itemQuantity;  => Except for Max Order Quantity
                    //lineItemToUpdate.PricebookEntryId = pbEntryId; // Not used on update 
                    //lineItemToUpdate.RVN_Number__c = itemRVN;
                    //lineItemToUpdate.Line_Number__c = itemLineNumber;

                    // Required Fields Price Book Entry, Quantity, Sales Price, Product
                    System.debug('--- Set QuoteLine Id to '+existingQuoteLineItemId); 
                    System.debug('--- Set QuoteLine QuoteId to '+quoteId); 
                    System.debug('--- Set QuoteLine Product Code to '+pbEntryProductCode); 
                    System.debug('--- Set QuoteLine PricebookEntry to '+pbEntryId); 
                    System.debug('--- Set QuoteLine Price to '+pbEntryUnitPrice); 
                    // Add updated Option Record to Collection
                    lineItemsToUpdate.add(lineItemToUpdate);    
                    System.debug('--- Adding Quote Line '+lineItemToUpdate);            
                }
                System.debug('--- '+lineItemsToUpdate.size()+' New or Changed QuoteLine(s)');
                if (lineItemsToUpdate.size()>0) {
                    update lineItemsToUpdate;
                    for (QuoteLineItem updatedLineItem : lineItemsToUpdate){
                        lineItemIds.add(updatedLineItem.Id);
                    }
                } 
                System.debug('--- '+lineItemIds.size()+' Created or Updated QuoteLine(s)');
            }
        } catch (Exception e) {
            System.debug('--- The following exception has occurred: ' + e.getMessage());
            throw new CustomException(e.getMessage());
        }
        System.debug('--- Updated '+lineItemIds.size()+' Quote Line(s)');
        return 'success';
    }  
}