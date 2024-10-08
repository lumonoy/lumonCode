/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 07-06-2024
 * @last modified by  : Henk Reynders
**/
@isTest
public class LumonTestQuotes {
    @TestVisible private static Id pricebookId{
        get{
            return Test.getStandardPricebookId();
        }
    }
    @TestVisible private static List<Opportunity> opportunities{
        get{
            return [SELECT Id,Pricebook2Id,SyncedQuoteId,AccountId FROM Opportunity WHERE (Order_Type__c = 'Normal')];
        }
    }    
	@TestVisible private static Id b2cOpportunityId{
        get{
            return [SELECT Id,Pricebook2Id,SyncedQuoteId,AccountId FROM Opportunity WHERE (Account.IsPersonAccount = true AND Order_Type__c = 'Normal') LIMIT 1]?.Id;
        }
    }
    @TestVisible private static Id b2bOpportunityId{
        get{
            return [SELECT Id,Pricebook2Id,SyncedQuoteId,AccountId FROM Opportunity WHERE (Account.IsPersonAccount = false AND Order_Type__c = 'Normal') LIMIT 1]?.Id;
        }
    }
	@TestVisible private static List<Quote> quotes{
        get{
            return [SELECT Id,Pricebook2Id,opportunityId,AccountId FROM Quote];
        }
    }    
	@TestVisible private static Id b2cQuoteId{
        get{
            return [SELECT Id,Pricebook2Id, isSyncing, OpportunityId  FROM Quote WHERE (OpportunityId =: b2cOpportunityId AND IsSyncing = false) LIMIT 1]?.Id;
        }
    }
    @TestVisible private static Id b2bQuoteId{
        get{
            return [SELECT Id,Pricebook2Id,isSyncing, OpportunityId FROM Quote WHERE (OpportunityId =: b2bOpportunityId AND IsSyncing = false) LIMIT 1]?.Id;
        }
    }
    @TestVisible private static Id b2cSyncedQuoteId{
        get{
            return [SELECT Id,Pricebook2Id,isSyncing, OpportunityId FROM Quote WHERE (OpportunityId =: b2cOpportunityId AND IsSyncing = true) LIMIT 1]?.Id;
        }
    }
    @TestVisible private static Id b2bSyncedQuoteId{
        get{
            return [SELECT Id,Pricebook2Id,isSyncing, OpportunityId FROM Quote WHERE ( OpportunityId =: b2bOpportunityId  AND IsSyncing = true) LIMIT 1]?.Id;
        }
    }
    public static void setupQuoteB2C(){
        // Create B2C Quote             
        setupQuoteB2C('LSU', 'FI_South', 'Consumer');
    }
    public static void setupQuoteB2C(String org, String district, String businessType){        
        // Create B2C Quote
        Quote b2cQuote = new Quote(Name=('B2C Quote '+org+' '+district+' '+businessType),
                                    Status='Configure',
                                    Pricebook2Id=pricebookId
                                    );
        insert b2cQuote;
        System.debug('--- LumonTestQuotes - B2C setup CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestQuotes - B2C setup Queries used: '+LIMITS.getQueries());
    }
    public static void setupSyncedQuoteB2C(){
        Id b2cOpportunityId = LumonTestVariables.b2cOpportunityId;
        Id b2cQuoteId = LumonTestVariables.b2cQuoteId;    
        Opportunity oppty = [SELECT Id,SyncedQuoteId FROM Opportunity WHERE Id =: b2cOpportunityId];
        oppty.SyncedQuoteId = b2cQuoteId;
        update oppty;
        System.debug('--- setupSyncedQuoteB2C - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- setupSyncedQuoteB2C - Queries used: '+LIMITS.getQueries());
    }
    public static void setupQuoteB2B(){
        // Create B2C Quote          
        setupQuoteB2B('LSU', 'FI_South', 'Reseller');
    }  
    public static void setupQuoteB2B(String org, String district, String businessType){        
        // Create B2B Quote
        Quote b2bQuote = new Quote(Name=('B2B Quote '+org+' '+district+' '+businessType),
                                    Status='Configure',
                                    Pricebook2Id=pricebookId
                                    );
        insert b2bQuote;
        System.debug('--- LumonTestQuotes - B2B setup CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestQuotes - B2B setup Queries used: '+LIMITS.getQueries());
    }
    public static void setupSyncedQuoteB2B(){
        Id b2bOpportunityId = LumonTestVariables.b2bOpportunityId;
        Id b2bQuoteId = LumonTestVariables.b2bQuoteId;    
        Opportunity oppty = [SELECT Id,SyncedQuoteId FROM Opportunity WHERE Id =: b2bOpportunityId];
        oppty.SyncedQuoteId = b2bQuoteId;
        update oppty;
        System.debug('--- setupSyncedQuoteB2B - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- setupSyncedQuoteB2B - Queries used: '+LIMITS.getQueries());
    }
    public static void setupQuoteData(){ 
        setupQuoteB2C();
        System.debug('--- LumonTestQuotes - B2C Quote: '+b2cQuoteId);
        setupQuoteB2B();
        System.debug('--- LumonTestQuotes - B2B Quote: '+b2bQuoteId);
    }  
    @IsTest
    static void setupQuoteDataTest(){
        String testResult;
        Test.startTest();
        try {
            setupQuoteData();
            testResult = 'successfully inserted Quotes';
        } catch (exception e){
            testResult = 'Error when inserting Quotes: '+e.getMessage();
        }
        System.debug('--- LumonTestQuotes - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestQuotes - Queries used: '+LIMITS.getQueries());
        Test.stopTest();       
        System.AssertNotEquals(true, testResult.contains('Error'));
    }
}