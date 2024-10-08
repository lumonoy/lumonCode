/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 05-12-2024
 * @last modified by  : Henk Reynders
**/
public with sharing class WarehouseController {
    @AuraEnabled(cacheable=true)
    public static Warehouse__c getWarehouseRecord(Id recordId) {
        // Populate map from SOQL query on Warehouse
        List<Id> recordIds = new List<Id>{recordId};
        List<Warehouse__c> warehouseRecords = getWarehouses(recordIds);        
        Warehouse__c warehouseRecord = warehouseRecords[0];
        System.debug('--- Warehouse Record: '+warehouseRecord);
        return warehouseRecord;
    } 
    @AuraEnabled(cacheable=true)
    public static List<Warehouse__c> getWarehouses(List<Id> recordIds) {
        List<Warehouse__c> warehouses = ([SELECT Id,
                                                Name, 
                                                Data_Source__c, 
                                                Description__c, 
                                                Organization__c, 
                                                Owned_By__c, 
                                                WarehouseCode__c, 
                                                WarehouseId__c,  
                                                Warehouse_Address__Street__s, 
                                                Warehouse_Address__City__s, 
                                                Warehouse_Address__PostalCode__s, 
                                                Warehouse_Address__StateCode__s, 
                                                Warehouse_Address__CountryCode__s, 
                                                Warehouse_Address__Latitude__s, 
                                                Warehouse_Address__Longitude__s, 
                                                Warehouse_Address__GeocodeAccuracy__s, 
                                                Warehouse_Address__c, 
                                                Warehouse_Location__c    
                                        FROM Warehouse__c 
                                    WHERE Id IN :recordIds
                                    OR Owned_By__c IN:recordIds
                                    ]);
        System.debug('--- Warehouse Record Count : '+warehouses.size());
        return warehouses;
    } 
}