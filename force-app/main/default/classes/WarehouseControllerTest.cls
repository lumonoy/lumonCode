/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 05-15-2024
 * @last modified by  : Henk Reynders
**/
@IsTest
public class WarehouseControllerTest {
    @TestSetup
    static void prepareData(){
        Test.startTest(); 
        LumonTestLocations.setupLocationData();
        Test.stopTest();
    }
    private static Id b2cAccountId = LumonTestVariables.b2cAccountId;
    private static Id b2bAccountId = LumonTestVariables.b2bAccountId;
    private static Id b2cOpportunityId = LumonTestVariables.b2cOpportunityId;
    private static Id b2bOpportunityId = LumonTestVariables.b2bOpportunityId;
    @IsTest
    static void getWarehouseRecordTest(){          
        Id buildingId = [SELECT Id FROM Warehouse__c LIMIT 1]?.Id;
        Test.startTest();
        Warehouse__c buildingRecord = WarehouseController.getWarehouseRecord(buildingId);
        System.Debug ('--- '+ buildingRecord.Id +' Warehouse Returned');
        System.assertNotEquals(null,buildingRecord, 'Expected Warehouse Record to be returned');
        System.debug('--- getWarehouseRecordTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getWarehouseRecordTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getWarehousesTest(){     
        Id buildingId = [SELECT Id FROM Warehouse__c LIMIT 1]?.Id;
        Test.startTest();
        List<Id> buildingIds = new List<Id> {buildingId};
        List<Warehouse__c> buildings = WarehouseController.getWarehouses(buildingIds);
        System.Debug ('--- '+ buildings.size() +' Warehouses Returned');
        System.assertNotEquals(0,buildings.size(), 'Expected Warehouse Record to be returned');
        System.debug('--- getWarehousesTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getWarehousesTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
}