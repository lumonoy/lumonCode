/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 04-12-2024
 * @last modified by  : Henk Reynders
**/
public with sharing class DeliveryBatchController {
    public static List<Delivery_Batch__c> getDeliveryBatches (Id recordId) {
        List<Delivery_Batch__c> deliveryBatches = new List<Delivery_Batch__c>();
        deliveryBatches = getDeliveryBatches(new List<Id> {recordId});
        return deliveryBatches;
    }
    public static List<Delivery_Batch__c> getDeliveryBatches (List<Id> recordIds) {
        List<Delivery_Batch__c> deliveryBatches = new List<Delivery_Batch__c>();
        deliveryBatches = [SELECT  Id, 
                                Name,
                                Opportunity__c,
                                Batch_Name__c, 
                                Batch_Number__c,                             
                                Batch_Description__c, 
                                Batch_Status__c,
                                Batch_Delivery_Date__c,
                                Batch_Installation_Date__c,
                                Batch_Installation_Start__c,
                                Batch_Installation_End__c,
                                Batch_Installation_Hours__c,
                                Batch_Order_Date__c,
                                Batch_Release_Date__c
                        FROM Delivery_Batch__c 
                        WHERE Id IN: recordIds
                        OR Opportunity__c IN: recordIds
                        ORDER BY Opportunity__c, Batch_Number__c DESC];
        return deliveryBatches;
    }
    public static Map<String,List<Delivery_Batch__c>> getDeliveryBatchMap (List<Id> recordIds) {
        List<Delivery_Batch__c> deliveryBatches = getDeliveryBatches(recordIds);
        Map<String,List<Delivery_Batch__c>> opportunityToBatchMap = new Map<String,List<Delivery_Batch__c>>();
        List<Delivery_Batch__c> batches = new List<Delivery_Batch__c>();
        for (Delivery_Batch__c batch : deliveryBatches) {
            if (!opportunityToBatchMap.containsKey(batch.Opportunity__c)) {
                opportunityToBatchMap.put(batch.Opportunity__c, new List<Delivery_Batch__c>());            
            }
            batches = opportunityToBatchMap.get(batch.Opportunity__c);
            batches.add(batch);
            opportunityToBatchMap.put(batch.Opportunity__c, batches);
        }
        return opportunityToBatchMap;
    }
    //Map<String,Delivery_Schedule__c>  deliveryScheduleMap = DeliveryScheduleController.getDeliveryScheduleMap(countryCode, postalCode);
}