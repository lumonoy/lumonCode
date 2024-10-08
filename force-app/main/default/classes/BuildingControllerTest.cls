/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 06-02-2024
 * @last modified by  : Henk Reynders
**/
@IsTest
public class BuildingControllerTest {
    @TestSetup
    static void prepareData(){
        Test.startTest();
        LumonTestLocations.setupBuildings();
        Test.stopTest();
    }
    private static List<Building__c> buildings = LumonTestVariables.buildings;
    private static List<Id> buildingIds = LumonTestVariables.buildingIds;
    @IsTest
    static void getBuildingRecordTest(){   
        System.Debug ('--- BuildingControllerTest - Building to Query: '+buildings[0]?.Id);   
        Test.startTest();
        Building__c buildingRecord = BuildingController.getBuildingRecord(buildings[0]?.Id);
        System.Debug ('--- BuildingControllerTest - '+ buildingRecord.Id +' Building Returned');
        System.assertNotEquals(null,buildingRecord, 'Expected Building Record to be returned');
        System.debug('--- BuildingControllerTest - getBuildingRecordTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- BuildingControllerTest - getBuildingRecordTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getBuildingsTest(){
        System.Debug ('--- BuildingControllerTest - Buildings to Query: '+buildingIds);   
        Test.startTest();
        List<Building__c> buildings = BuildingController.getBuildings(buildingIds);
        System.Debug ('--- BuildingControllerTest - '+ buildings.size() +' Buildings Returned');
        System.assertNotEquals(0,buildings.size(), 'Expected Building Record to be returned');
        System.debug('--- BuildingControllerTest - getBuildingsTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- BuildingControllerTest - getBuildingsTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
}