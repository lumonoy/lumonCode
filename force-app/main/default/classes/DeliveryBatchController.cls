/**
 * @description       : FSL Delivery Batch
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 10-09-2024
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
    public static List<Delivery_Batch__c> getDeliveryBatchesByNumber(String offerNumber) {
        // Populate List from SOQL query on Batch
        List<Delivery_Batch__c> offerBatches = new List<Delivery_Batch__c>(); 
        List<Id> offerBatchIds = new List<Id>(new Map<Id, Delivery_Batch__c>(offerBatches).keySet()); 
        List<Delivery_Batch__c> batches =  getDeliveryBatches(offerBatchIds);  
        return batches;  
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
                                    ,BatchNumber__c
                                    ,BatchName__c
                                    ,OfferNumber__c
                                    ,isMigrated__c
                                    ,CreatedDate
                                    ,CreatedById
                                    ,LastModifiedDate
                                    ,LastModifiedById
                        FROM Delivery_Batch__c 
                        WHERE Id IN: recordIds 
                        ORDER BY OfferNumber__c, Batch_Number__c DESC];
        return deliveryBatches;
    }
}