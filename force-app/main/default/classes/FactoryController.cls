/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 05-12-2024
 * @last modified by  : Henk Reynders
**/
public with sharing class FactoryController {
    @AuraEnabled(cacheable=true)
    public static Factory__c getFactoryRecord(Id recordId) {
        // Populate map from SOQL query on Factory
        List<Id> recordIds = new List<Id>{recordId};
        List<Factory__c> factoryRecords = getFactories(recordIds);        
        Factory__c factoryRecord = factoryRecords[0];
        System.debug('--- Factory Record: '+factoryRecord);
        return factoryRecord;
    } 
    @AuraEnabled(cacheable=true)
    public static List<Factory__c> getFactories(List<Id> recordIds) {
        List<Factory__c> factories = ([SELECT Id,
                                                Name, 
                                                Default_Factory__c,    
                                                Factory_code__c, 
                                                Operating_Hours__c,
                                                Factory_Address__Street__s, 
                                                Factory_Address__City__s, 
                                                Factory_Address__PostalCode__s, 
                                                Factory_Address__StateCode__s, 
                                                Factory_Address__CountryCode__s, 
                                                Factory_Address__Latitude__s, 
                                                Factory_Address__Longitude__s, 
                                                Factory_Address__GeocodeAccuracy__s, 
                                                Factory_Address__c, 
                                                Factory_Location__c                              
                                    FROM Factory__c 
                                    WHERE Id IN :recordIds
                                    ]);
        System.debug('--- Factory Record Count : '+factories.size());
        return factories;
    } 
}