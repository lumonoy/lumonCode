/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 07-07-2024
 * @last modified by  : Henk Reynders
**/
@IsTest(isParallel=false)
public with sharing class DeliveryBatchControllerTest {
    @TestSetup
    static void prepareData(){
        Test.startTest();
        LumonTestQuotes.setupQuoteData();
        LumonTestDeliveryBatches.setupDeliveryBatchData();
        Test.stopTest();
    }
    private static Id b2cAccountId = LumonTestDataFactory.b2cAccountId;
    private static Id b2cOpportunityId = LumonTestDataFactory.b2cOpportunityId;
    private static Id b2cQuoteId = LumonTestDataFactory.b2cQuoteId;
    private static Id b2bAccountId = LumonTestDataFactory.b2bAccountId;
    private static Id b2bOpportunityId = LumonTestDataFactory.b2bOpportunityId;
    private static Id b2bQuoteId = LumonTestDataFactory.b2bQuoteId;

    @IsTest
    static void getDeliveryBatchTest(){
        Test.startTest();
        Delivery_Batch__c deliveryBatch = DeliveryBatchController.getDeliveryBatch(b2cQuoteId);
        System.assertNotEquals(null, deliveryBatch.Id, 'Expecting atleast 1 DeliveryBatch to be returned');
        System.debug('--- getDeliveryBatchTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getDeliveryBatchTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getDeliveryBatchByNumberTest(){
        Delivery_Batch__c batch = [SELECT Id, BatchNumber__c FROM Delivery_Batch__c LIMIT 1];
        Test.startTest();
        Delivery_Batch__c deliveryBatch = DeliveryBatchController.getDeliveryBatchByNumber(Integer.ValueOf(batch.BatchNumber__c));
        System.assertNotEquals(null, deliveryBatch.Id, 'Expecting atleast 1 DeliveryBatch to be returned');
        System.debug('--- getDeliveryBatchByNumberTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getDeliveryBatchByNumberTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getDeliveryBatchesTest(){
        Test.startTest();
        List<Delivery_Batch__c> deliveryBatches = DeliveryBatchController.getDeliveryBatches(b2cQuoteId);
        System.assertNotEquals(0, deliveryBatches.size(), 'Expecting atleast 1 DeliveryBatch to be returned');
        System.debug('--- getDeliveryBatchesTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getDeliveryBatchesTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getDeliveryBatches2Test(){
        List<Id> relatedIds = new List<Id> {b2cQuoteId, b2bQuoteId};

        Test.startTest();
        List<Delivery_Batch__c> deliveryBatches = DeliveryBatchController.getDeliveryBatches(relatedIds);
        System.assertNotEquals(0, deliveryBatches.size(), 'Expecting atleast 1 DeliveryBatch to be returned');
        System.debug('--- getDeliveryBatchesTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getDeliveryBatchesTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getDeliveryBatchMapTest(){
        List<Id> relatedIds = new List<Id> {b2cQuoteId, b2bQuoteId};
        Test.startTest();
        Map<String,List<Delivery_Batch__c>> deliveryBatchMap = DeliveryBatchController.getDeliveryBatchMap(relatedIds);
        System.assertNotEquals(0, deliveryBatchMap.KeySet().size(), 'Expecting atleast 1 DeliveryBatch to be returned');
        System.debug('--- getDeliveryBatchMapTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getDeliveryBatchMapTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
}