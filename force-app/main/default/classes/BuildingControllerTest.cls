/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 10-02-2024
 * @last modified by  : Henk Reynders
**/
@IsTest
public class BuildingControllerTest {
    public class CustomException extends Exception {}
    private static Id b2cAccountId = LumonTestVariables.b2cAccountId;
    private static Id b2bAccountId = LumonTestVariables.b2bAccountId;
    private static List<Id> buildingIds = LumonTestVariables.buildingIds;
    @TestSetup
    static void prepareData(){
        Test.startTest();
        LumonTestDataFactory.setupAccounts();
        LumonTestDataFactory.setupBuildings();
        Test.stopTest();
    }
    @IsTest
    static void getBuildingRecordTest(){      
        Test.startTest();
        Building__c buildingRecord = BuildingController.getBuildingRecord(buildingIds[0]);
        System.Debug ('--- '+ buildingRecord.Id +' Building Returned');
        System.assertNotEquals(null,buildingRecord, 'Expected Building Record to be returned');
        System.debug('--- getBuildingRecordTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getBuildingRecordTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getBuildingsTest(){
        Test.startTest();
        List<Building__c> buildings = BuildingController.getBuildings(buildingIds);
        System.Debug ('--- '+ buildings.size() +' Buildings Returned');
        System.assertNotEquals(0,buildings.size(), 'Expected Building Record to be returned');
        System.debug('--- getBuildingsTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getBuildingsTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
}