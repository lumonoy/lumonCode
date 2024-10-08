/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 07-06-2024
 * @last modified by  : Henk Reynders
**/
@IsTest
public class QuoteControllerTest {
    
    @TestSetup
    static void prepareData(){
        Test.startTest();
        LumonTestQuotes.setupQuoteData();
        Test.stopTest();
    }
    public static Id b2cQuoteId = LumonTestVariables.b2cQuoteId;
    public static Id b2bQuoteId = LumonTestVariables.b2bQuoteId;
    public static String b2cQuoteNumber = LumonTestVariables.b2cQuoteNumber;
    public static String b2bQuoteNumber = LumonTestVariables.b2bQuoteNumber;

    @IsTest
    static void getQuoteTest(){
        Test.startTest();
        Quote quote = QuoteController.getQuote(b2cQuoteId);
        System.Debug ('--- QuoteControllerTest - getQuoteTest '+ quote.Id +' Quote Returned');
        System.assertNotEquals(null,quote, 'Expected Quote Record to be returned');
        System.debug('--- QuoteControllerTest - getQuoteTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- QuoteControllerTest - getQuoteTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }    
    @IsTest
    static void getQuoteByNumberTest(){
        Test.startTest();
        Quote quote = QuoteController.getQuoteByNumber(b2cQuoteNumber);
        System.Debug ('--- QuoteControllerTest - getQuoteByNumberTest '+ quote.Id +' Quote Returned');
        System.assertNotEquals(null,quote, 'Expected Quote Record to be returned');
        System.debug('--- QuoteControllerTest - getQuoteByNumberTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- QuoteControllerTest - getQuoteByNumberTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
}