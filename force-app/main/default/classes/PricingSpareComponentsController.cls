/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 11-21-2023
 * @last modified by  : Henk Reynders
**/
public with sharing class PricingSpareComponentsController {
    @AuraEnabled
    public static SearchResult search(SearchFilter filters) {
        SearchResult result = new SearchResult();
        String freeText = '%' + filters.text + '%';
        Id priceBookId = filters.quote.Pricebook2Id;
        result.totalNumberOfRecords = Database.countQuery(
            'SELECT count() FROM PriceBookEntry'+
            'WHERE (PriceBook2Id = :priceBookId'+
            'AND IsActive = true'+
            'AND('+
            'Product2.ProductCode LIKE :freeText'+
            'OR Product2.Name LIKE :freeText'+
            'OR Product2.Product_Name__FI__c LIKE :freeText'+
            'OR Product2.Product_Name__EN__c LIKE :freeText'+
            'OR Product2.Product_Name__ES__c LIKE :freeText'+
            ')'
        );
        result.records = new List<SObject>();
        for(PriceBookEntry pbEntry : Database.query(
            String.join(
                new List<String>{
                    'SELECT',
                    String.join(new List<String> {
                        'Product2Id', 'Product2.Name', 'Product2.QuantityUnitOfMeasure', 'UnitPrice'
                    }, ', '),
                    'WHERE (PriceBook2Id = :priceBookId',
                    'AND IsActive = true',
                    'AND (Product2.Product_Group__c =: (\'TARVIKE\')',
                            'OR Product2.Cost_Type__c IN (\'tarvikeast\', \'tarvikealu\', \'tarvikekmp\')',
                    'AND(',
                    'Product2.ProductCode LIKE :freeText',
                    'OR Product2.Name LIKE :freeText',
                    'OR Product2.Product_Name__FI__c LIKE :freeText',
                    'OR Product2.Product_Name__EN__c LIKE :freeText',
                    'OR Product2.Product_Name__ES__c LIKE :freeText',
                    ')',
                    'LIMIT 200'
                },
                ' '
            )
        )) {
            result.records.add(new QuoteLineItem(
                Product2Id = pbEntry.Product2Id,
                Description = pbEntry.Product2.Name,
                Product2 = new Product2(Id = pbEntry.Product2Id, QuantityUnitOfMeasure = pbEntry.Product2.QuantityUnitOfMeasure),
                UnitPrice = pbEntry.UnitPrice // TODO get proper price
            ));
        }
        return result;
    }

    public class SearchFilter {
        @AuraEnabled
        public Id id { get; set; }
        @AuraEnabled
        public List<String> fields { get; set; }
        @AuraEnabled
        public String text { get; set; }
        @AuraEnabled
        public Quote quote { get; set; }
    }

    public class SearchResult {
        @AuraEnabled
        public List<SObject> records { get; set; }
        @AuraEnabled
        public Integer totalNumberOfRecords { get; set; }
    }

    public with sharing class ComponentData {
        @AuraEnabled
        public Quote quote { get; private set; }
        @AuraEnabled
        public Opportunity opportunity { get; private set; }
        @AuraEnabled
        public Boolean visible { get; private set; }
        @AuraEnabled
        public Boolean disabled { get; private set; }
        @AuraEnabled
        public List<QuoteLineItem> quoteLineItems { get; private set; }
        public ComponentData(Id recordId) {
            opportunity = PricingSummaryService.queryOpportunity(recordId);
            try {
                quote = PricingSummaryService.queryQuote(opportunity.SyncedQuoteId);
            } catch (Exception e) {
                throw new PricingSummaryService.PricingDataException('The synced quote can\'t be found');
            }
            visible = PricingSummaryService.queryPricingSummary(opportunity.Id, quote.Id) != null
                && PricingSummaryService.opportunityHasProductItems(quote.Id);
            disabled = PricingSummaryService.componentDisabled(opportunity);
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
                    Product2.QuantityUnitOfMeasure,
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
                    Product_Code__c
                FROM QuoteLineItem
                WHERE QuoteId = :quote.Id 
                AND (Product2.Cost_Type__c IN ('tarvikeast', 'tarvikealu', 'tarvikekmp')
                OR Product2.Product_Group__c =: ('TARVIKE'))
                ORDER BY Product2.Product_Group__c, Product2.Product_Model__c, Product2.Cost_Type__c
            ];
        }
    }

    @AuraEnabled
    public static Product2 findProduct(String productId) {
        return [
            SELECT Name, QuantityUnitOfMeasure
            FROM Product2
            WHERE Id = :productId
            LIMIT 1
        ];
    }

    @AuraEnabled
    public static PricebookEntry findBasePrice(String productId) {
        return [
            SELECT UnitPrice
            FROM PricebookEntry
            WHERE Product2Id = :productId AND Pricebook2.isPriceList__c = true
            LIMIT 1
        ];
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
        delete new QuoteLineItem(Id = quoteLineItemId);
        PricingController.upsertQuoteLines(opportunityId);
    }

    @AuraEnabled
    public static QuoteLineItem saveItem(Id opportunityId, QuoteLineItem quoteLineItem) {
        Opportunity opportunity = PricingSummaryService.queryOpportunity(opportunityId);
        Quote quote = PricingSummaryService.queryQuote(opportunity.SyncedQuoteId);
        QuoteLineItem oldQuoteLineItem = quoteLineItem.Id != null
            ? [
                  SELECT Product2Id
                  FROM QuoteLineItem
                  WHERE Id = :quoteLineItem.Id
                  LIMIT 1
              ]
            : null;
        if (oldQuoteLineItem != null && quoteLineItem.Product2Id != oldQuoteLineItem.Product2Id) {
            // This is needed as the Product2Id field can't be updated
            delete new QuoteLineItem(Id = quoteLineItem.Id);
            quoteLineItem.Id = null;
        }
        if (String.isBlank(quoteLineItem.Id)) {
            PriceBookEntry entry = [
                SELECT
                    Id,
                    Product2Id,
                    UnitPrice,
                    Minimum_Price__c,
                    Transmission__c,
                    Quantity_per_Order__c,
                    Product2.Product_Group__c,
                    Product2.Cost_Type__c,
                    Product2.QuantityUnitOfMeasure,
                    Product2.Name
                FROM PriceBookEntry
                WHERE PriceBook2Id = :quote.Pricebook2Id 
                AND Product2Id = :quoteLineItem.Product2Id 
                AND IsActive = TRUE
                LIMIT 1
            ];
            quoteLineItem.Product_Group__c = 'LISAHIN'; // TODO check if this is correct value
            quoteLineItem.PriceBookEntryId = entry.Id;
            quoteLineItem.Min_Price__c = entry.Minimum_Price__c;
            quoteLineItem.Max_Quantity__c = entry.Quantity_per_Order__c;
            // quoteLineItem. = entry.Product2.QuantityUnitOfMeasure;
            quoteLineItem.QuoteId = opportunity.SyncedQuoteId;
            quoteLineItem.Factory_Multiplier__c = 0;
            quoteLineItem.Cost_Multiplier__c = 0;
            quoteLineItem.Sales_Multiplier__c = 1;
            quoteLineItem.Cost_Type__c = entry.Product2.Cost_Type__c;
            quoteLineItem.Product2 = entry.Product2;
            // quoteLineItem.Cost_Category__c = ADDITIONAL_SALES_CATEGORY;
        }
        quoteLineItem.Base_Price__c = quoteLineItem.UnitPrice;
        quoteLineItem.List_Price__c = quoteLineItem.UnitPrice;
        upsert quoteLineItem;
        PricingController.upsertQuoteLines(opportunityId);
        return quoteLineItem;
    }

}