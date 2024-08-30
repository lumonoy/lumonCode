/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-09-2023
 * @last modified by  : Henk Reynders
**/
@IsTest(isParallel=false)
public with sharing class LumonTestOpportunities {
    @TestVisible private static Id pricebookId{
        get{
            return Test.getStandardPricebookId();
        }
    }
	@TestVisible private static Id b2cOpportunityId{
        get{
            return [SELECT Id,Pricebook2Id,SyncedQuoteId,AccountId FROM Opportunity WHERE (Account.IsPersonAccount = true AND Order_Type__c = 'Normal') LIMIT 1]?.Id;
        }
    }
    @TestVisible private static Opportunity b2cOpportunity{
        get{
            return [SELECT Id,Pricebook2Id,SyncedQuoteId,AccountId FROM Opportunity WHERE (Id =: b2cOpportunityId) LIMIT 1];
        }
    }
    @TestVisible private static Id b2cReclamationId{
        get{
            return [SELECT Id,Pricebook2Id,SyncedQuoteId,AccountId FROM Opportunity WHERE (Account.IsPersonAccount = true AND Order_Type__c = 'Reclamation') LIMIT 1]?.Id;
        }
    }
    @TestVisible private static List<Opportunity> b2cOpportunities{
        get{
            return [SELECT Id,Pricebook2Id,SyncedQuoteId,AccountId FROM Opportunity WHERE (Account.IsPersonAccount = true)];
        }
    }
    @TestVisible private static Id b2bOpportunityId{
        get{
            return [SELECT Id,Pricebook2Id,SyncedQuoteId,AccountId FROM Opportunity WHERE (Account.IsPersonAccount = false) LIMIT 1]?.Id;
        }
    }
     @TestVisible private static Opportunity b2bOpportunity{
        get{
            return [SELECT Id,Pricebook2Id,SyncedQuoteId,AccountId FROM Opportunity WHERE (Id =: b2bOpportunityId) LIMIT 1];
        }
    }
    @TestVisible private static List<Opportunity> b2bOpportunities{
        get{
            return [SELECT Id,Pricebook2Id,SyncedQuoteId,AccountId FROM Opportunity WHERE (Account.IsPersonAccount = false)];
        }
    }
    //@future 
    public static void setupOpportunityB2C(){
        LumonTestAccounts.setupAccountB2C();
        Id accountId = LumonTestAccounts.b2cAccountId;
        // Create B2C Opportunity
		setupOpportunityB2C(accountId,'LSU', 'FI_South', 'Consumer');
        System.debug('--- setupOpportunityB2C - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- setupOpportunityB2C - Queries used: '+LIMITS.getQueries());
    }
    //@future 
    public static void setupOpportunityB2C(Id accountId, String org, String district, String businessType){        
        // Create B2C Opportunity
        Opportunity b2cOpp = new Opportunity(Name=('B2C Opportunity '+org+' '+district+' '+businessType),
                                             Description = ('B2C Opportunity '+org+' '+district+' '+businessType), 
                                            StageName='Quoting',
                                            CloseDate=system.Today()+10,
                                            Pricebook2Id=pricebookId,
                                            AccountId = accountId,
                                            Organization__c = org,
                                            //Country_Attribute__c,
                                            Business_Type__c =businessType,
                                            District__c = district,
                                            Order_Type__c = 'Normal'
                                            );
        insert b2cOpp;
        System.debug('--- setupOpportunityB2C - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- setupOpportunityB2C - Queries used: '+LIMITS.getQueries());
    }
        //@future 
    public static void setupOpportunityB2B(){
        LumonTestAccounts.setupAccountB2B();
        Id accountId = LumonTestAccounts.b2bAccountId;
        // Create B2B Opportunity
		setupOpportunityB2B(accountId,'LSU', 'FI_South', 'Reseller');
        System.debug('--- setupOpportunityB2B - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- setupOpportunityB2B - Queries used: '+LIMITS.getQueries());
    }
    //@future 
    public static void setupOpportunityB2B(Id accountId, String org, String district, String businessType){        
        // Create B2B Opportunity
        Opportunity b2bOpp = new Opportunity(Name=('B2B Opportunity '+org+' '+district+' '+businessType),
                                             Description = ('B2B Opportunity '+org+' '+district+' '+businessType), 
                                            StageName='Quoting',
                                            CloseDate=system.Today()+30,
                                            Pricebook2Id=pricebookId,
                                            AccountId = accountId,
                                            Organization__c = org,
                                            //Country_Attribute__c,
                                            Business_Type__c =businessType,
                                            District__c = district,
                                            Order_Type__c = 'Normal'
                                            );
        insert b2bOpp;
        System.debug('--- setupOpportunityB2C - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- setupOpportunityB2C - Queries used: '+LIMITS.getQueries());
    }
    @IsTest
    static void setupOpportunityB2CTest(){
        String testResult;
        Test.startTest();
        Try {
            setupOpportunityB2C();
            testResult = 'successfully inserted B2C Opportunity';
            System.Debug('--- setupOpportunityB2CTest - Opportunity: '+b2cOpportunity);
        } catch (exception e){
            testResult = 'error when inserting B2C Opportunity: '+e.getMessage();
        }
        Test.stopTest();
        System.Debug('--- setupOpportunityB2CTest - Opportunity After Test: '+b2cOpportunity);
        System.AssertNotEquals(true, testResult.contains('error'));
    } 
    /*@IsTest
    static void setupOpportunityB2BTest(){
        String testResult;
        Test.startTest();
        Try {
            setupOpportunityB2B();
            testResult = 'successfully inserted B2B Opportunity';
            System.Debug('--- setupOpportunityB2BTest - Opportunity: '+b2bOpportunity);
        } catch (exception e){
            testResult = 'error when inserting B2B Opportunity: '+e.getMessage();
        }
        Test.stopTest();
        System.AssertNotEquals(true, testResult.contains('error'));
    } */
}