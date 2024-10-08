/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 07-07-2024
 * @last modified by  : Henk Reynders
**/
public with sharing class DeliveryBatchController {
    @AuraEnabled(cacheable=false)
    public static Delivery_Batch__c getDeliveryBatch(Id batchId) {
        // Populate List from SOQL query on Delivery_Batch__c
        List<Id> batchIds = new List<Id>();
        batchIds.add(batchId);
        System.debug('--- DeliveryBatchController - Get Delivery Batch with Id '+batchId); 
        List<Delivery_Batch__c> batches =  getDeliveryBatches(batchIds);  
        Delivery_Batch__c batch = batches[0];
        System.debug('--- DeliveryBatchController - Delivery Batch: '+batch.Name); 
        return batch;  
    }
    @AuraEnabled(cacheable=false)
    public static Delivery_Batch__c getDeliveryBatchByNumber(Integer batchNumber) {
        // Populate List from SOQL query on Account
        Id batchId = [SELECT Id FROM Delivery_Batch__c WHERE BatchNumber__c =: Decimal.valueOf(batchNumber) LIMIT 1]?.Id; 
        List<Id> batchIds = new List<Id>();
        batchIds.add(batchId);
        System.debug('--- DeliveryBatchController - Get Delivery Batch with Id '+batchId); 
        List<Delivery_Batch__c> batches =  getDeliveryBatches(batchIds);  
        Delivery_Batch__c batch = batches[0];
        System.debug('--- DeliveryBatchController - Delivery Batch: '+batch.Name); 
        return batch;  
    }
    public static List<Delivery_Batch__c> getDeliveryBatches (Id recordId) {
        List<Delivery_Batch__c> deliveryBatches = new List<Delivery_Batch__c>();
        deliveryBatches = getDeliveryBatches(new List<Id> {recordId});
        return deliveryBatches;
    }
    public static List<Delivery_Batch__c> getDeliveryBatches (List<Id> recordIds) {
        List<Delivery_Batch__c> deliveryBatches = new List<Delivery_Batch__c>();
        deliveryBatches = [SELECT  Id
                                    ,Name
                                    ,BatchId__c
                                    ,OfferId__c
                                    ,BatchNumber__c
                                    ,BatchName__c
                                    ,BatchInstallationDate__c
                                    ,BatchPromisedDate__c
                                    ,BatchDeliveryDate__c
                                    ,BatchOrderDate__c
                                    ,BatchInstallationEnd__c
                                    ,BatchInstallationStart__c
                                    ,BatchInstallationTime__c
                                    ,BatchStatus__c
                                    ,NumberOfCompletedInstallations__c
                                    ,NumberOfPlannedInstallations__c
                                    ,NumberOfStartedInstallations__c
                                    ,Account__c
                                    ,Quote__c
                                    ,Opportunity__c
                                    ,hasOpportunity__c
                                    ,SalesToriUniqueKey__c
                                    ,CreatedDate
                                    ,CreatedById
                                    ,LastModifiedDate
                                    ,LastModifiedById
                        FROM Delivery_Batch__c 
                        WHERE Id IN: recordIds 
                        OR Account__c IN: recordIds                       
                        OR Opportunity__c IN: recordIds
                        OR Quote__c IN: recordIds
                        ORDER BY Quote__c, Batch_Number__c DESC];
        return deliveryBatches;
    }
    public static Map<String,List<Delivery_Batch__c>> getDeliveryBatchMap (List<Id> recordIds) {
        List<Delivery_Batch__c> deliveryBatches = getDeliveryBatches(recordIds);
        Map<String,List<Delivery_Batch__c>> opportunityToBatchMap = new Map<String,List<Delivery_Batch__c>>();
        List<Delivery_Batch__c> batches = new List<Delivery_Batch__c>();
        for (Delivery_Batch__c batch : deliveryBatches) {
            if (!opportunityToBatchMap.containsKey(batch.Quote__c)) {
                opportunityToBatchMap.put(batch.Quote__c, new List<Delivery_Batch__c>());            
            }
            batches = opportunityToBatchMap.get(batch.Quote__c);
            batches.add(batch);
            opportunityToBatchMap.put(batch.Quote__c, batches);
        }
        return opportunityToBatchMap;
    }
    //Map<String,Delivery_Schedule__c>  deliveryScheduleMap = DeliveryScheduleController.getDeliveryScheduleMap(countryCode, postalCode);
}