/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 05-12-2024
 * @last modified by  : Henk Reynders
**/
@isTest
public class LumonTestQuoteLines {
    public static void setupQuoteLineItems() {
        List<Quote> quotes = LumonTestVariables.quotes;
        if (quotes.size()>0){
            System.debug('--- LumonTestQuoteLines - Using existing Test Quotes');
        } else {
            LumonTestQuotes.setupQuoteData();
        }
        for (Quote quote : quotes){
            setupQuoteLineItems(quote.Id);
        }
    }
    public static void setupQuoteLineItems(Id quoteId) {
        List<Configuration_Option__c> configOptions = LumonTestVariables.configOptions;
        setupQuoteLineItems(quoteId,configOptions);
    }
    public static void setupQuoteLineItems(Id quoteId, List<Configuration_Option__c> configOptions) {
        List<PricebookEntry> pricebookEntries = LumonTestVariables.pricebookEntries;
        List<QuoteLineItem> quoteLineItems = new List<QuoteLineItem>();
        Map<String,PricebookEntry> priceMap = new Map<String,PricebookEntry>();
        for (PricebookEntry pbe : pricebookEntries) {
            String productCode = pbe.Product2.ProductCode;
            priceMap.put(productCode,pbe);
        }
        if(!configOptions.isEmpty()){
            for (Configuration_Option__c configOption : configOptions){         
                QuoteLineItem qli = new QuoteLineItem();
                qli.QuoteId=quoteId;
                qli.Product2Id=configOption.Product__c;               
                qli.PricebookEntryId=priceMap.get(configOption.Product__r.ProductCode)?.Id;
                qli.Quantity=1;
                qli.UnitPrice=priceMap.get(configOption.Product__r.ProductCode)?.UnitPrice;
                quoteLineItems.add(qli);
            }
        }
        insert quoteLineItems;
    }


    public static void setupQuoteLineData() {
        try {
                setupQuoteLineItems();
        }catch (Exception e){
            System.debug('--- LumonTestQuoteLines - Error setupConfigurationData Exception '+e);
        } 
    }
    @TestSetup
    static void prepareData() {
        Test.startTest();
        List<Quote> quotes = LumonTestVariables.quotes;
        if (quotes.size()>0) {
            System.debug('--- LumonTestQuoteLines - Using existing Quotes');
        } else {
            LumonTestQuotes.setupQuoteData();
        }
        List<Configuration_Option__c> configOptions = LumonTestVariables.configOptions;
        if (configOptions.size()>0) {
            System.debug('--- LumonTestQuoteLines - Using existing Configuration Options');
        } else {
            LumonTestConfigurationOptions.setupConfigurationOptionData();
        }
        Test.stopTest();
    }
    @IsTest
    static void setupQuoteLineDataTest(){
        String testResult;
        Test.startTest();
        try {
            setupQuoteLineData();
            testResult = 'successfully inserted Quote Lines';
        } catch (exception e){
            testResult = 'Error when inserting Quote Lines: '+e.getMessage();
        }
        System.debug('--- LumonTestQuotes - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestQuotes - Queries used: '+LIMITS.getQueries());
        Test.stopTest();       
        System.AssertNotEquals(true, testResult.contains('Error'));
    }
}