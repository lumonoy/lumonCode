@IsTest 
public class OpportunityControllerTest {
    @TestSetup
    static void prepareData(){
        Test.startTest();
        LumonTestDataFactory.setupProducts();
        LumonTestDataFactory.setupPrices();
        // B2C Setup
        LumonTestDataFactory.setupAccountB2C();
        LumonTestDataFactory.setupOpportunityB2C();  
        // B2B Setup
        LumonTestDataFactory.setupAccountB2B();
        LumonTestDataFactory.setupOpportunityB2B();        
        Test.stopTest();
    }
    private static Id b2cAccountId = LumonTestDataFactory.b2cAccountId;
    private static Id b2cOpportunityId = LumonTestDataFactory.b2cOpportunityId;
    private static List<Opportunity> b2cOpportunities = LumonTestDataFactory.b2cOpportunities;
    private static Id b2bAccountId = LumonTestDataFactory.b2bAccountId;
    private static Id b2bOpportunityId = LumonTestDataFactory.b2bOpportunityId;
    private static List<Opportunity> b2bOpportunities = LumonTestDataFactory.b2bOpportunities;
    private static List<Opportunity> opportunities = LumonTestDataFactory.opportunities;
    @IsTest
    static void GetOpportunityRecordTest(){
        Test.startTest();
        Opportunity opportunity = OpportunityController.GetOpportunityRecord(b2cOpportunityId);
        System.Debug ('--- GetOpportunityRecordTest - '+ opportunity.Id +' Opportunity Returned');
        System.assertNotEquals(null,opportunity, 'Expected Opportunity Record to be returned');
        System.debug('--- GetOpportunityRecordTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- GetOpportunityRecordTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void GetOpportunitiesTest(){
        Test.startTest();
        List<Id> recordIds = new List<Id>(new Map<Id, Opportunity>(b2cOpportunities).keySet()); 
        List<Opportunity> opportunities = OpportunityController.getOpportunities(recordIds);
        System.Debug ('--- GetOpportunitiesTest - '+ opportunities.size() +' Opportunities Returned');
        System.assertNotEquals(0,opportunities.size(), 'Expected atleast one Opportunity Record to be returned');
        System.debug('--- GetOpportunitiesTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- GetOpportunitiesTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
}