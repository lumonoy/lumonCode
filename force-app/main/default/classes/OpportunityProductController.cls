/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-02-2023
 * @last modified by  : Henk Reynders
**/
public class OpportunityProductController {
    @AuraEnabled(cacheable=false)
    public static Opportunity getOpportunityRecord(Id opportunityId) {
        // Populate map from SOQL query on Opportunity
        System.debug('--- Get Data for Opportunity: '+opportunityId);
        Opportunity opportunityRecord = ([SELECT    Id, Name, Order_type__c, Type, //Information
                                                    StageName, isClosed, // Status
                                                    Amount, CurrencyIsoCode, // Totals
                                                    Pricebook2Id,SyncedQuoteId, //Pricing Records
                                                    Opportunity_Number__c, //RVN Number
                                                    Organization_Attribute__c,Country_Attribute__c,//Tier 1 Factory Prices
                                                    District_Attribute__c,Territory_Attribute__c,Business_Type_Attribute__c,//Tier 2 Product Costs
                                                    Owner_Profit_Center__c, Customer_Attribute__c, //Tier 3 Sales Prices   
                                                    closeDate,
                                                    AccountId,
                                                    Order__c,
                                                    ContractId,
                                                    OwnerId,
                                                    Account.VAT__c
                                    FROM Opportunity 
                                    WHERE Id = :opportunityId]);
        System.debug('--- Opportunity Record: '+opportunityRecord);
        return opportunityRecord;
    } 
    @AuraEnabled(cacheable=true)
    public static List<OpportunityLineItem> getOpportunityLineItems(Id opportunityId) {
        // Populate map from SOQL query on OpportunityLineItem
        List<OpportunityLineItem> opportunityLineItems = ([SELECT  Id,
                                                            OpportunityId,
                                                            Product2Id,
                                                            Product2.ProductCode,
                                                            Quantity,
                                                            ListPrice,
                                                            UnitPrice,
                                                            CurrencyIsoCode
                                                            FROM OpportunityLineItem 
                                                            WHERE OpportunityId = :opportunityId]);
        System.debug('--- Opportunity Line Items: '+opportunityLineItems);                                         
        return opportunityLineItems;
    } 
    @AuraEnabled(cacheable=false)
    public static Map<String,OpportunityLineItem> getOpportunityLineItemMap(Id opportunityId,String currencyCode) {
        // Populate List from SOQL query on OpportunityLineItem
        Boolean isActive = True;
        System.debug('--- Get Opportunity Line Items for Opportunity '+opportunityId); 
        List<OpportunityLineItem> opportunityLineItems = ([SELECT  Id,
                                                            OpportunityId,
                                                            Product2Id,
                                                            Product2.ProductCode,
                                                            Quantity,
                                                            ListPrice,
                                                            UnitPrice,
                                                            CurrencyIsoCode
                                                            FROM OpportunityLineItem 
                                                            WHERE OpportunityId = :opportunityId]);
        System.debug('--- Existing Opportunity Line Items: '+opportunityLineItems.size()); 
        Map<String,OpportunityLineItem> oliMap = New Map<String,OpportunityLineItem>();     
        if (opportunityLineItems.size()>0) {                                
            for (OpportunityLineItem opportunityLineItem :opportunityLineItems) {
                String productCode = opportunityLineItem.Product2.ProductCode;
                String product2Id = opportunityLineItem.Product2Id;
                Decimal quantity = opportunityLineItem.Quantity;
                oliMap.put(productCode,opportunityLineItem);
            }
        }  
        return oliMap;  
    }

    @AuraEnabled
    public static List<ProductWrapper> getData(String recordId) {
        List<ProductWrapper> productsWrapper = new List<ProductWrapper>();
        List<OpportunityLineItem> opportunityLineItems = ([SELECT Id,
                OpportunityId,
                Product2Id,
                Product2.Name,
                Product2.ProductCode,
                Product2.Product_Group__c,
                Product2.Cost_Category__c,
                tolabel(Product2.Cost_Type__c),
                Quantity,
                UnitPrice,
                ListPrice,
                TotalPrice,
                CurrencyIsoCode
        FROM OpportunityLineItem
        WHERE OpportunityId = :recordId
        ]);

        Set<String> productGroups = new Set<String>();
        Map<String, Set<String>> productGroupToCostType = new Map<String, Set<String>>();
        Map<String, List<OpportunityLineItem>> productGroupAndCostToOLI = new Map<String, List<OpportunityLineItem>>();

        for (OpportunityLineItem oli : opportunityLineItems) {
            productGroups.add(oli.Product2.Product_Group__c);
            if (productGroupToCostType.get(oli.Product2.Product_Group__c) == null) {
                productGroupToCostType.put(oli.Product2.Product_Group__c, new Set<String>());
            }
            Set<String> current = productGroupToCostType.get(oli.Product2.Product_Group__c);
            current.add(oli.Product2.Cost_Type__c);
            productGroupToCostType.put(oli.Product2.Product_Group__c, current);

            String keyVal = oli.Product2.Product_Group__c + '-' + oli.Product2.Cost_Type__c;
            if (productGroupAndCostToOLI.get(keyVal) == null) {
                productGroupAndCostToOLI.put(keyVal, new List<OpportunityLineItem>());
            }
            List<OpportunityLineItem> currentOLIs = productGroupAndCostToOLI.get(keyVal);
            currentOLIs.add(oli);
            productGroupAndCostToOLI.put(keyVal, currentOLIs);
        }
        System.debug('aa: ' + productGroups);
        for (String prodGr : productGroupToCostType.keySet()) {
            ProductWrapper wrapper = new ProductWrapper();
            wrapper.name = prodGr;
            wrapper.productName = prodGr;
            Decimal listPrice = 0;
            Decimal salesPrice = 0;
            Decimal salesMargin = 0;
            List<ProductWrapper> children = new List<ProductWrapper>();
            for (String key : productGroupToCostType.get(prodGr)) {
                Decimal listPriceChild = 0;
                Decimal salesPriceChild = 0;
                Decimal salesMarginChild = 0;
                String keyVal = prodGr + '-' + key;
                ProductWrapper wrapperChild = new ProductWrapper();
                wrapperChild.name = key;
                wrapperChild.productName = key;
                List<ProductWrapper> children2ndLevel = new List<ProductWrapper>();
                for (OpportunityLineItem oliRecord : productGroupAndCostToOLI.get(keyVal)) {
                    ProductWrapper wrapperChild2nd = new ProductWrapper();
                    wrapperChild2nd.name = oliRecord.Id;
                    wrapperChild2nd.productName = oliRecord.Product2.Name;
                    wrapperChild2nd.factory = 1;
                    wrapperChild2nd.costs = 1;
                    wrapperChild2nd.listPrice = oliRecord.ListPrice.setScale(2);
                    listPrice += oliRecord.ListPrice;
                    listPriceChild += oliRecord.ListPrice;
                    wrapperChild2nd.salesPrice = oliRecord.UnitPrice.setScale(2);
                    salesPrice += oliRecord.UnitPrice;
                    salesPriceChild += oliRecord.UnitPrice;
                    wrapperChild2nd.salesMargin = oliRecord.TotalPrice.setScale(2);
                    salesMargin += oliRecord.TotalPrice;
                    salesMarginChild += oliRecord.UnitPrice;
                    wrapperChild2nd.discount = 1;
                    children2ndLevel.add(wrapperChild2nd);
                }
                wrapperChild.factory = 3;
                wrapperChild.costs = 4;
                wrapperChild.listPrice = listPriceChild.setScale(2);
                wrapperChild.salesPrice = salesPriceChild.setScale(2);
                wrapperChild.salesMargin = salesMarginChild.setScale(2);
                wrapperChild.discount = 8;
                wrapperChild.children = children2ndLevel;
                children.add(wrapperChild);
            }
            wrapper.children = children;
            wrapper.factory = 1;
            wrapper.costs = 2;
            wrapper.listPrice = listPrice.setScale(2);
            wrapper.salesPrice = salesPrice.setScale(2);
            wrapper.salesMargin = salesMargin.setScale(2);
            wrapper.discount = 6;
            productsWrapper.add(wrapper);
        }
        System.debug('bb: ' + productsWrapper);
        return productsWrapper;
    }
/*
    public class ProductWrapper {
        @AuraEnabled public String name {public get; public set;}
        @AuraEnabled public String productName {public get; public set;}
        @AuraEnabled public Decimal factory {public get; public set;}
        @AuraEnabled public Decimal costs {public get; public set;}
        @AuraEnabled public Decimal listPrice {public get; public set;}
        @AuraEnabled public Decimal listPriceName {public get; public set;}
        @AuraEnabled public Decimal salesPrice {public get; public set;}
        @AuraEnabled public Decimal salesMargin {public get; public set;}
        @AuraEnabled public Decimal discount {public get; public set;}
        @AuraEnabled public List<ProductWrapper> children {public get; public set;}
    }*/
    
    @AuraEnabled
    public static ResponseWrapper getData2(String recordId) {
        Opportunity opp = [SELECT Id,SyncedQuoteId FROM Opportunity WHERE Id = :recordId];
        Id quoteId = opp.SyncedQuoteId;
        List<ProductWrapper> productsWrapper = new List<ProductWrapper>();
        ProductWrapper summaryProduct = new ProductWrapper();
        ProductWrapper summaryProductWithVAT = new ProductWrapper();
        List<QuoteLineItem> quoteLineItems = ([SELECT Id, LineNumber, 
                                CurrencyIsoCode,
                                //Configuration__c, // Config this Item belongs to
                                QuoteId, // Parent Quote RecordId
                                Product2Id, // Product2 Entry
                                Product2.Name,
                                Product2.ProductCode,
                                Product2.Cost_Category__c, // Grouping on Cost Category
                                tolabel(Cost_Type__c) ,// Grouping on Cost Type
                                Product_Group__c, // Grouping on Cost Type
                                //PricebookEntryId, //Pricebook Entry
                                //OpportunityLineItemId, // (Synced) Opportunity Line Item
                                Quantity, // Amount 
                                ListPrice, // Pricebook Entry Price
                                UnitPrice, // Sales Price
                                fxCost__c,
                                fxFactory__c,
                                fxSales__c,
                                List_Price__c,
                                Discount, //% Discount
                                Discount__c, 
                                Sales_Margin__c,
                                Subtotal, // ?
                                TotalPrice //Quantity * SalesPrice
                                //Cost_Multiplier__c, // Lookup to Org Price Parameters
                                //Price_Multiplier__c, // Lookup to District Price Parameters
                                //Margin__c, // Total Price / Total Cost
                                //Hidden__c
                          FROM QuoteLineItem 
                          WHERE QuoteId = :quoteId 
                          ORDER BY Product2.Cost_Type__c]);

        Set<String> productGroups = new Set<String>();
        Map<String, Set<String>> productGroupToCostType = new Map<String, Set<String>>();
        Map<String, List<QuoteLineItem>> productGroupAndCostToQLI = new Map<String, List<QuoteLineItem>>();

        for (QuoteLineItem qli : quoteLineItems) {
            productGroups.add(qli.Product_Group__c); //Get the product group value (LGR,LGS ...)
            if (productGroupToCostType.get(qli.Product_Group__c) == null) {
                productGroupToCostType.put(qli.Product_Group__c, new Set<String>());
            }
            Set<String> current = productGroupToCostType.get(qli.Product_Group__c);
            current.add(qli.Cost_Type__c);
            productGroupToCostType.put(qli.Product_Group__c, current); //Map of product along with cost types

            String keyVal = qli.Product_Group__c + '-' + qli.Cost_Type__c;
            if (productGroupAndCostToQLI.get(keyVal) == null) {
                productGroupAndCostToQLI.put(keyVal, new List<QuoteLineItem>());
            }
            List<QuoteLineItem> currentQLIs = productGroupAndCostToQLI.get(keyVal);
            currentQLIs.add(qli);
            productGroupAndCostToQLI.put(keyVal, currentQLIs); //Map of keyval(prod-costtype, qli)
        }

        Decimal factorySum = 0;
        Decimal costsSum = 0;
        Decimal listPriceSum = 0;
        Decimal salesPriceSum = 0;
        Decimal salesMarginSum = 0;

        System.debug('aa: ' + productGroups);
        for (String prodGr : productGroupToCostType.keySet()) {
            //Product	Factory	Costs	List Price	Sales price	Sales margin	Discount %
            ProductWrapper wrapper = new ProductWrapper();
            wrapper.name = prodGr;
            wrapper.productName = prodGr;
            Decimal factory = 0.00;
            Decimal costs = 0.00;
            Decimal listPrice = 0;
            Decimal salesPrice = 0;
            Decimal salesMargin = 0;
            Decimal discount = 0;
            List<ProductWrapper> children = new List<ProductWrapper>();
            
            for (String key : productGroupToCostType.get(prodGr)) {
                Decimal factoryChild = 0.00;
            	Decimal costsChild = 0.00;
                Decimal listPriceChild = 0;
                Decimal salesPriceChild = 0;
                Decimal salesMarginChild = 0;
                Decimal discountChild = 0;
                String keyVal = prodGr + '-' + key;
                ProductWrapper wrapperChild = new ProductWrapper();
                wrapperChild.name = key;
                wrapperChild.productName = key;
                List<ProductWrapper> children2ndLevel = new List<ProductWrapper>();
                for (QuoteLineItem qliRecord : productGroupAndCostToQLI.get(keyVal)) {
                    ProductWrapper wrapperChild2nd = new ProductWrapper();
                    wrapperChild2nd.name = qliRecord.Id;
                    wrapperChild2nd.productName = qliRecord.Product2.Name;
                    wrapperChild2nd.factory = qliRecord.fxFactory__c.setScale(2);
                    factory += qliRecord.fxFactory__c;
                    factoryChild += qliRecord.fxFactory__c;
                    wrapperChild2nd.costs = qliRecord.fxCost__c.setScale(2);
                    costs += qliRecord.fxCost__c;
                    costsChild += qliRecord.fxCost__c;
                    wrapperChild2nd.listPrice = qliRecord.fxSales__c.setScale(2);
                    listPrice += qliRecord.fxSales__c;
                    listPriceChild += qliRecord.fxSales__c;
                    wrapperChild2nd.salesPrice = qliRecord.Subtotal.setScale(2);
                    salesPrice += qliRecord.Subtotal;
                    salesPriceChild += qliRecord.Subtotal;
                    if(qliRecord.Sales_Margin__c != null){
                        wrapperChild2nd.salesMargin = qliRecord.Sales_Margin__c.setScale(2);
                        salesMargin += qliRecord.Sales_Margin__c;
                        salesMarginChild += qliRecord.Sales_Margin__c;
                    }
                    if(qliRecord.Discount__c != null){
                    	wrapperChild2nd.discount = qliRecord.Discount__c;
                        discount += qliRecord.Discount__c;
                    	discountChild += qliRecord.Discount__c;
                    }
                    
                    children2ndLevel.add(wrapperChild2nd);
                    
                }
                wrapperChild.factory = factoryChild.setScale(2);
                wrapperChild.costs = costsChild.setScale(2);
                wrapperChild.listPrice = listPriceChild.setScale(2);
                wrapperChild.salesPrice = salesPriceChild.setScale(2);
                wrapperChild.salesMargin = salesMarginChild.setScale(2);
                wrapperChild.discount = discountChild.setScale(2);
                wrapperChild.children = children2ndLevel;
                children.add(wrapperChild);
            }
            wrapper.children = children;
            wrapper.factory = factory.setScale(2);
            wrapper.costs = costs.setScale(2);
            wrapper.listPrice = listPrice.setScale(2);
            wrapper.salesPrice = salesPrice.setScale(2);
            wrapper.salesMargin = salesMargin.setScale(2);
            wrapper.discount = discount.setScale(2);
            productsWrapper.add(wrapper);

            factorySum += factory;
            costsSum += costs;
            listPriceSum += listPrice;
            salesPriceSum += salesPrice;
            salesMarginSum += salesMargin;
        }
        System.debug('bb: ' + productsWrapper);

        ResponseWrapper wrapper = new ResponseWrapper();
        wrapper.products = productsWrapper;
        summaryProduct.factory = factorySum.setScale(2);
        summaryProduct.costs = costsSum.setScale(2);
        summaryProduct.listPrice = listPriceSum.setScale(2);
        summaryProduct.salesPrice = salesPriceSum.setScale(2);
        summaryProduct.salesMargin = salesMarginSum.setScale(2);
        wrapper.summaryProduct = summaryProduct;

        if (factorySum > 0) {
            summaryProductWithVAT.factory = (factorySum * 1.24).setScale(2);
        }
        if (costsSum > 0) {
            summaryProductWithVAT.costs = (costsSum * 1.24).setScale(2);
        }
        if (listPriceSum > 0) {
            summaryProductWithVAT.listPrice = (listPriceSum * 1.24).setScale(2);
        }
        if (salesPriceSum > 0) {
            summaryProductWithVAT.salesPrice = (salesPriceSum * 1.24).setScale(2);
        }
        if (salesMarginSum > 0) {
            summaryProductWithVAT.salesMargin = (salesMarginSum * 1.24).setScale(2);
        }

        wrapper.summaryProductWithVAT = summaryProductWithVAT;
        return wrapper;
    }

    public class ResponseWrapper {
        @AuraEnabled public List<ProductWrapper> products {public get; set;}
        @AuraEnabled public ProductWrapper summaryProduct {public get; set;}
        @AuraEnabled public ProductWrapper summaryProductWithVAT {public get; set;}
    }

    public class ProductWrapper {
        @AuraEnabled public String name {public get; public set;}
        @AuraEnabled public String productName {public get; public set;}
        @AuraEnabled public Decimal factory {public get; public set;}
        @AuraEnabled public Decimal costs {public get; public set;}
        @AuraEnabled public Decimal listPrice {public get; public set;}
        @AuraEnabled public Decimal listPriceName {public get; public set;}
        @AuraEnabled public Decimal salesPrice {public get; public set;}
        @AuraEnabled public Decimal salesMargin {public get; public set;}
        @AuraEnabled public Decimal discount {public get; public set;}
        @AuraEnabled public List<ProductWrapper> children {public get; public set;}
    }
}