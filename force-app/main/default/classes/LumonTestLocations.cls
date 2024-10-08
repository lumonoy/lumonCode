/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 05-14-2024
 * @last modified by  : Henk Reynders
**/
@isTest
public class LumonTestLocations{
    public static void setupFactories(){
        List<Factory__c> factories = new List<Factory__c>();
        Factory__c factory = new Factory__c();
        factory.Name = 'Finland Factory';
        factory.Default_Factory__c = true;       		  
        factory.Factory_code__c = 'LU';       
        factory.Factory_Address__Street__s ='Korjalankatu 28'; 
        factory.Factory_Address__City__s = 'Kouvola'; 
        factory.Factory_Address__PostalCode__s = '45130';
        //factory.Factory_Address__StateCode__s; 
        factory.Factory_Address__CountryCode__s = 'FI'; 
        //factory.Factory_Address__Latitude__s; 
        //factory.Factory_Address__Longitude__s;
        //factory.Factory_Address__GeocodeAccuracy__s; 
        //factory.Factory_Address__c, 
        //factory.Operating_Hours__c
        //factory.Factory_Location__c  
        factories.add(factory);
        insert factories;
    }
    public static void setupWarehouses(){
        List<Warehouse__c> warehouses = new List<Warehouse__c>();
        Warehouse__c warehouse = new Warehouse__c();
        warehouse.Name = 'Finland Warehouse';
        warehouse.Organization__c = 'LSU';   
        warehouse.warehouseId__c = '2195';    		  
        warehouse.WarehouseCode__c = 'MC';      
        warehouse.Warehouse_Address__Street__s ='Kaitilankatu 11'; 
        warehouse.Warehouse_Address__City__s = 'Kouvola'; 
        warehouse.Warehouse_Address__PostalCode__s = '45130';
        //warehouse.Warehouse_Address__StateCode__s; 
        warehouse.Warehouse_Address__CountryCode__s = 'FI'; 
        warehouses.add(warehouse);
        insert warehouses;
    }
    public static void setupBuildings(){
        List<Building__c> buildings = new List<Building__c>();
        Building__c building = new Building__c(); 
        building.Name = 'Apartment Building';
        /*building.BuildingAddress__Street__s = 'Asematie 1'; 
        building.BuildingAddress__City__s = 'Vantaa';
        building.BuildingAddress__PostalCode__s = '01300'; 
        //building.BuildingAddress__StateCode__s;
        building.BuildingAddress__CountryCode__s = 'FI';
        //building.BuildingAddress__Latitude__s, 
        //building.BuildingAddress__Longitude__s, 
        //building.BuildingAddress__GeocodeAccuracy__s, 
        //Building_Address__c, 
        building.BuildingHeight__c = 10000;
        //building.BuildingLocation__c;
        building.NumberOfFloors__c = 3;
        //building.OwnedBy__c = b2cAccountId;
        building.PropertyType__c = 'APA';
        //building.StructuralAnalysis__c;*/
        buildings.add(building);
        insert buildings;
    }
    public static void setupLocationData(){ 
        setupFactories();
        setupWarehouses();
        setupBuildings();
    }  
    @IsTest
    static void setupLocationDataTest(){
        String testResult;
        Test.startTest();
        try {
            setupLocationData();
            testResult = 'successfully inserted Locations';
        } catch (exception e){
            testResult = 'Error when inserting Locations: '+e.getMessage();
        }
        System.debug('--- LumonTestLocations - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestLocations - Queries used: '+LIMITS.getQueries());
        Test.stopTest();       
        System.AssertNotEquals(true, testResult.contains('Error'));
        List<Id> warehouseIds = LumonTestVariables.warehouseIds;
        System.AssertNotEquals(null, warehouseIds, ' Expected Warehouse(s) to be Inserted');
        List<Id> factoryIds = LumonTestVariables.factoryIds;
        System.AssertNotEquals(null, factoryIds, ' Expected Factories to be Inserted');
        List<Id> buildingIds = LumonTestVariables.buildingIds;
        System.AssertNotEquals(null, buildingIds, ' Expected Buildings to be Inserted');
    }

}