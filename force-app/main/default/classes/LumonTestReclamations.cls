/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-10-2023
 * @last modified by  : Henk Reynders
**/
@IsTest(isParallel=false)
public with sharing class LumonTestReclamations {
	@TestVisible private static Id b2cReclamationId{
        get{
            return [SELECT Id,Pricebook2Id,SyncedQuoteId,AccountId FROM Opportunity WHERE (Account.IsPersonAccount = true AND Order_Type__c = 'Reclamation') LIMIT 1]?.Id;
        }
    }
    @TestVisible private static Opportunity b2cReclamation{
        get{
            return [SELECT Id,Pricebook2Id,SyncedQuoteId,AccountId FROM Opportunity WHERE (Id =: b2cReclamationId) LIMIT 1];
        }
    } 
    //@future 
    public static void setupReclamationB2C(){
        LumonTestAccounts.setupAccountB2C();
        Id accountId = LumonTestAccounts.b2cAccountId;
        // Create B2C Opportunity
		setupReclamationB2C(accountId,'LSU', 'FI_South', 'Consumer');
        System.debug('--- setupReclamationB2C - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- setupReclamationB2C - Queries used: '+LIMITS.getQueries());
    }
    //@future 
    public static void setupReclamationB2C(Id accountId, String org, String district, String businessType){        
        // Create B2C Opportunity
        Opportunity b2cOpp = new Opportunity(Name=('B2C Reclamation '+org+' '+district+' '+businessType),
                                             Description = ('B2C Reclamation '+org+' '+district+' '+businessType), 
                                            StageName='Quoting',
                                            CloseDate=system.Today()+10,
                                            //Pricebook2Id=pricebookId,
                                            AccountId = accountId,
                                            Organization__c = org,
                                            //Country_Attribute__c,
                                            Business_Type__c =businessType,
                                            District__c = district,
                                            Order_Type__c = 'Reclamation'
                                            );
        insert b2cOpp;
        System.debug('--- setupReclamationB2C - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- setupReclamationB2C - Queries used: '+LIMITS.getQueries());
    }
    @IsTest
    static void setupReclamationB2CTest(){
        String testResult;
        Test.startTest();
        Try {
            setupReclamationB2C();
            testResult = 'successfully inserted B2C Reclamation';
            System.Debug('--- setupReclamationB2CTest - Reclamation: '+b2cReclamation);
        } catch (exception e){
            testResult = 'error when inserting B2C Reclamation: '+e.getMessage();
        }
        Test.stopTest();
        System.Debug('--- setupReclamationB2CTest - Reclamation After Test: '+b2cReclamation);
        System.AssertNotEquals(true, testResult.contains('error'));
    } 
}