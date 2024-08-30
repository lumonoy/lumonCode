/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 02-13-2024
 * @last modified by  : Henk Reynders
**/
@IsTest
public class BuildingControllerTest {
    @TestSetup
    static void prepareData(){
        Test.startTest();
        LumonTestDataFactory.setupProducts();
        LumonTestDataFactory.setupPrices();
        // B2C Setup
        LumonTestDataFactory.setupAccountB2C();
        LumonTestDataFactory.setupOpportunityB2C();
        Test.stopTest();
    }
    private static Id b2cAccountId = LumonTestDataFactory.b2cAccountId;
    private static Id b2cOpportunityId = LumonTestDataFactory.b2cOpportunityId;
    private static Id b2cSyncedQuoteId = LumonTestDataFactory.b2cSyncedQuoteId;
    @IsTest
    static void getBuildingRecordTest(){      
		Opportunity opp = OpportunityController.getOpportunityRecord(b2copportunityId);     
        Id buildingId = [SELECT Id FROM Building__c LIMIT 1]?.Id;
        Test.startTest();
        Building__c buildingRecord = BuildingController.getBuildingRecord(buildingId);
        System.Debug ('--- '+ buildingRecord.Id +' Building Returned');
        System.assertNotEquals(null,buildingRecord, 'Expected Building Record to be returned');
        System.debug('--- getBuildingRecordTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getBuildingRecordTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getBuildingsTest(){
        Opportunity opp = OpportunityController.getOpportunityRecord(b2copportunityId);     
        Id buildingId = [SELECT Id FROM Building__c LIMIT 1]?.Id;
        Test.startTest();
        List<Id> buildingIds = new List<Id> {buildingId};
        List<Building__c> buildings = BuildingController.getBuildings(buildingIds);
        System.Debug ('--- '+ buildings.size() +' Buildings Returned');
        System.assertNotEquals(0,buildings.size(), 'Expected Building Record to be returned');
        System.debug('--- getBuildingsTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getBuildingsTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
}