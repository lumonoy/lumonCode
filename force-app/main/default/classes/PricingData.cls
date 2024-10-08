/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 06-15-2024
 * @last modified by  : Henk Reynders
**/
public class PricingData {
    public static ConfigurationPlan parsePricingJSON(String pricingJSON) {
        return (ConfigurationPlan) System.JSON.deserialize(pricingJSON, ConfigurationPlan.class);
    }
    // Pricing File Contain a Tree Structure of the Configuration
    // Level 1: Configuration Plan
    // Level 2: Configuration Product(s)
    // Level 3: Configuration Option(s)
    //          Configuration Message(s) aka Inspect Messages
    public class ConfigurationPlan {
        @AuraEnabled public String apartment{get; set;} // User Input Text, Number or Null
        @AuraEnabled public String floor{get; set;} // User Input Text, Number or Null
        @AuraEnabled public String id{get; set;} // Configurator unique Id
        @AuraEnabled public String line{get; set;} // User Input Text, Number or Null
        @AuraEnabled public String name{get; set;} // User Input Text, Number or Null
        @AuraEnabled public List<ConfigurationProduct> products{get; set;} // Product Included with the Plan
        @AuraEnabled public String version{get; set;} // Configurator Version
    }
    public class ConfigurationProduct {
        @AuraEnabled public String hasFeaturesBeenConfirmed{get; set;}
        @AuraEnabled public String hasMeasurementsBeenVerified{get; set;}
        @AuraEnabled public String id{get; set;}
        @AuraEnabled public String name{get; set;}
        @AuraEnabled public List<ConfigurationItem> configurationItems{get; set;}
        @AuraEnabled public String productInspectCode{get; set;}
        @AuraEnabled public List<ConfigurationMessages> productInspectMessageKeys{get; set;}
        @AuraEnabled public String productLength{get; set;}
        @AuraEnabled public List<String> reclaimedFeatureMessageKeys{get; set;}
        @AuraEnabled public String rvn{get; set;}
    }
    public class ConfigurationItem {
        @AuraEnabled public Double Amount{get; set;}
        @AuraEnabled public Boolean LocalSupplier{get; set;}
        @AuraEnabled public String ParameterCode{get; set;}
        @AuraEnabled public String SalesCode{get; set;}
        @AuraEnabled public String UniqueId{get; set;}
        @AuraEnabled public String Unit{get; set;}
    }
    public class ConfigurationMessages {
        @AuraEnabled public String MessageKey{get; set;}
        @AuraEnabled public String SpaceSideNumber{get; set;}
    }
    @AuraEnabled public Id recordId {get; set;}
	@AuraEnabled public String sObjectType {get; set;}
	@AuraEnabled public Id opportunityId {get; set;}
	@AuraEnabled public Opportunity opportunityRecord {get; set;}
	@AuraEnabled public Id syncedQuoteId {get; set;}
	@AuraEnabled public Quote syncedQuote {get; set;}
	@AuraEnabled public List<Quote> quotes {get; set;}
	@AuraEnabled public List<QuoteLineItem> quoteLineItems {get; set;}
	@AuraEnabled public Id accountId {get; set;}
	@AuraEnabled public Account accountRecord {get; set;}
	@AuraEnabled public List<Case> cases {get; set;}
	@AuraEnabled public List<Order> orders {get; set;}
	@AuraEnabled public List<Contract> contracts {get; set;}
	@AuraEnabled public List<Configuration__c> configPlans {get; set;}
	@AuraEnabled public List<Id> configPlanIds {get; set;}
	@AuraEnabled public List<Configuration_Product__c> configProducts {get; set;}
	@AuraEnabled public List<Id> configProductIds {get; set;}
	@AuraEnabled public List<Configuration_Option__c> configItems {get; set;}
	@AuraEnabled public List<Id> configItemIds {get; set;}
	@AuraEnabled public List<Configuration_Message__c> configMessages {get; set;}
	@AuraEnabled public List<Id> configMessageIds {get; set;}  
    // Pricing Data
    @AuraEnabled public Id pricingSummaryId {get; set;}  
    @AuraEnabled public Pricing_Summary__c pricingSummary {get;set;}
    @AuraEnabled public List<Pricing_Summary__c> pricingSummaries {get;set;}
    @AuraEnabled public List<Id> pricingSummaryIds {get; set;}
    // Price books
    @AuraEnabled public Date closingDate {get; set;}
    @AuraEnabled public Id pricebook2Id {get; set;}
	@AuraEnabled public Pricebook2 pricebookRecord {get; set;}
	@AuraEnabled public Id pricelistId {get; set;}
	@AuraEnabled public Pricebook2 pricelistRecord {get; set;}
	@AuraEnabled public String CurrencyIsoCode {get; set;}
    @AuraEnabled public Map<String,PricebookEntry> sellableProductsMap {get;set;}
    @AuraEnabled public List<PricebookEntry> basePrices {get;set;}
    @AuraEnabled public Map<String,PricebookEntry> pricelistEntryMap {get;set;}
    // Price Multipliers
    @AuraEnabled public List<Factory_Price__c> factoryMultipliers {get;set;}
    @AuraEnabled public List<Product_Cost__c> costMultipliers {get;set;}
    @AuraEnabled public List<Sales_Price__c> salesMultipliers {get;set;}
    @AuraEnabled public List<String> productGroups {get;set;}
    @AuraEnabled public List<String> costTypes {get;set;}
    // Installation Time Data
    @AuraEnabled public Map<String,Installation_Time__c> installationTimeMap {get;set;}
    @AuraEnabled public Map<String,Product2> installationTimeProductMap {get;set;}
    //@AuraEnabled public List<ProductWrapper> products {public get; set;}
    //@AuraEnabled public ProductWrapper summaryProduct {public get; set;}
    //@AuraEnabled public ProductWrapper summaryProductWithVAT {public get; set;
    public class TypeAttribute{
		@AuraEnabled public List<String> label {get; set;}
		@AuraEnabled public List<String> rowActions {get; set;}
	}

    public class PricingAttribute {
        @AuraEnabled public String opportunity{get; set;} // The Opportunity this Pricing Table relates to
        @AuraEnabled public String factoryParameter{get; set;} // The relevant Factory Cost Parameter -> Organization Attribute
        @AuraEnabled public String productParameter{get; set;} // The relevant Product Cost Parameter -> Territory Attribute
        @AuraEnabled public String salesParameter{get; set;} // The relevant Sales Price Parameter -> Business Attribute
        @AuraEnabled public String name{get; set;} // Name of the Pricing Table
        @AuraEnabled public String description{get; set;} // Description of the Pricing Table
        //@AuraEnabled public List<PricingParameter> ConfigurationPlan{get; set;} // Product Model aka Configurable Product
    }       
    public class PricingParameter {
        // Pricebook Attributes
        @AuraEnabled public Boolean sellable {get; set;} 
        // PriceList Attributes
        @AuraEnabled public Decimal basePrice {get; set;} // Price from Valid Pricelist Pricebook
        // Factory Price Attributes
        @AuraEnabled public Decimal factoryMultiplier {get; set;} // Lookup to Factory Cost Object
        @AuraEnabled public Decimal factoryCost {get; set;} // Calculated Result basePrice * factoryMultiplier
        // Product Cost Attributes
        @AuraEnabled public Decimal productMultiplier {get; set;} // Lookup to Product Cost Object
        @AuraEnabled public Decimal productCost {get; set;} // Calculated Result basePrice * productMultiplier
        // Sales Price Attributes
        @AuraEnabled public Decimal salesMultiplier {get; set;} // Lookup to Sales Price Object
        @AuraEnabled public Decimal salesPrice {get; set;} // Calculated Result basePrice * salesMultiplier
        // Special Price Attributes
        @AuraEnabled public Decimal minPrice {get; set;} 
        @AuraEnabled public Decimal maxQuantity {get; set;} 
        @AuraEnabled public Decimal maxDiscount {get; set;} 
       
        @AuraEnabled public Boolean taxPercentage {get; set;} 
        // Item Attributes
        @AuraEnabled public String itemName {get; set;} 
        @AuraEnabled public String itemCode {get; set;} 
        @AuraEnabled public String itemDescription {get; set;} 
        // Cost Attributes
        @AuraEnabled public String itemCostType {get; set;} 
        @AuraEnabled public String itemCostCategory {get; set;} 
       
        @AuraEnabled public String itemProductGroup {get; set;} 
        @AuraEnabled public String itemProduct {get; set;} 
        @AuraEnabled public String itemProductCode {get; set;} 
        @AuraEnabled public String itemProductCategory {get; set;} 
        @AuraEnabled public String itemProductType {get; set;} 
        @AuraEnabled public String itemProductItem {get; set;} 
        // Configuration Attributes
        @AuraEnabled public String itemConfigPlan {get; set;} 
        @AuraEnabled public String itemConfigProduct {get; set;} 
        @AuraEnabled public String itemConfigOption {get; set;} 
        @AuraEnabled public String itemRVN {get; set;} 
        // Volume Attributes
        @AuraEnabled public Decimal itemQuantity {get; set;} 
        // Sales Attributes
        @AuraEnabled public String itemSalesCode {get; set;} 
        @AuraEnabled public String itemSalesGroup {get; set;} 
        // Field Attributes
        @AuraEnabled public String fieldLabel {get;set;}
		@AuraEnabled public String fieldName {get;set;}
        @AuraEnabled public Decimal itemLineNumber {get; set;} 
    }
    public class BusinessAttribute {
        @AuraEnabled public String organization;
        @AuraEnabled public String countryCode;
        @AuraEnabled public String territory;
        @AuraEnabled public String district;
        @AuraEnabled public String businesType;
        @AuraEnabled public String profitCenter;
        @AuraEnabled public String office;
        @AuraEnabled public String customerNumber;
    }
}