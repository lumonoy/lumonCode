/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 02-13-2024
 * @last modified by  : Henk Reynders
**/
public with sharing class BuildingController {
    @AuraEnabled(cacheable=true)
    public static Building__c getBuildingRecord(Id recordId) {
        // Populate map from SOQL query on Building
        List<Id> recordIds = new List<Id>{recordId};
        List<Building__c> buildingRecords = getBuildings(recordIds);        
        Building__c buildingRecord = buildingRecords[0];
        System.debug('--- Building Record: '+buildingRecord);
        return buildingRecord;
    } 
    @AuraEnabled(cacheable=true)
    public static List<Building__c> getBuildings(List<Id> recordIds) {
        List<Building__c> buildings = ([SELECT Id,
                                                Name
                                                //BuildingAddress__Street__s, 
                                                //BuildingAddress__City__s, 
                                                //BuildingAddress__PostalCode__s, 
                                                //BuildingAddress__StateCode__s, 
                                                //BuildingAddress__CountryCode__s, 
                                                //BuildingAddress__Latitude__s, 
                                                //BuildingAddress__Longitude__s, 
                                                //BuildingAddress__GeocodeAccuracy__s, 
                                                //BuildingAddress__c, 
                                                //BuildingHeight__c,
                                                //BuildingLocation__c, 
                                                //NumberOfFloors__c, 
                                                //OnHillOrSlope__c, 
                                                //OwnedBy__c, 
                                                //PropertyType__c, 
                                                //StructuralAnalysis__c                              
                                    FROM Building__c 
                                    WHERE Id IN :recordIds
                                    //OR OwnedBy__c IN: recordIds
                                    //OR StructuralAnalysis__c IN: recordIds
                                    ]);
        System.debug('--- Building Record Count : '+buildings.size());
        return buildings;
    } 
}