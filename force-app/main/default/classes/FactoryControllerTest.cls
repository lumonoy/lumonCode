/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 05-12-2024
 * @last modified by  : Henk Reynders
**/
@IsTest
public class FactoryControllerTest {
    @TestSetup
    static void prepareData(){
        Test.startTest();
        LumonTestLocations.setupFactories();
        Test.stopTest();
    }
    @IsTest
    static void getFactoryRecordTest(){
        Id factoryId = [SELECT Id FROM Factory__c LIMIT 1]?.Id;
        Test.startTest();
        Factory__c buildingRecord = FactoryController.getFactoryRecord(factoryId);
        System.Debug ('--- '+ buildingRecord.Id +' Factory Returned');
        System.assertNotEquals(null,buildingRecord, 'Expected Factory Record to be returned');
        System.debug('--- getFactoryRecordTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getFactoryRecordTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
}