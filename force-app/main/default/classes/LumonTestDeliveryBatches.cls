/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 07-07-2024
 * @last modified by  : Henk Reynders
**/
@IsTest(isParallel=false)
public class LumonTestDeliveryBatches {
    public static void setupDeliveryBatches(){
        List<Quote> quotes = LumonTestVariables.quotes;
        List<Delivery_Batch__c> batches = new List<Delivery_Batch__c>();        
        for (Quote q : quotes) {
            System.debug('--- LumonTestDeliveryBatches - Quote: '+quote.id);
            for (Integer batchCounter= 0; batchCounter<3;batchCounter++) {
                Delivery_Batch__c batch = new Delivery_Batch__c();
                batch.Quote__c = q.Id;
                batch.BatchName__c = q.Name + ' Batch '+ batchCounter;
                batch.BatchNumber__c = batchCounter;                             
                //batch.Batch_Description__c;
                //batch.Batch_Status__c;
                //batch.Batch_Delivery_Date__c;
                //batch.Batch_Installation_Date__c;
                //batch.Batch_Installation_Start__c;
                //batch.Batch_Installation_End__c;
                //batch.Batch_Installation_Hours__c;
                //batch.Batch_Order_Date__c;
                //batch.Batch_Release_Date__c;    
            batches.add(batch);
            System.debug('--- LumonTestDeliveryBatches - Delivery Batch: '+batch.id);
            }
        }
        if (batches?.size()>0){
            System.debug('--- LumonTestDeliveryBatches - '+batches?.size()+' Batches to Insert');
            insert batches;
        }
    } 
    public static void setupDeliveryBatchData() {
        setupDeliveryBatches();
    }
    @TestSetup
    static void prepareData() {
        Test.startTest();
        List<Quote> quotes = LumonTestVariables.quotes;
        if(quotes?.size()>0){
            System.debug('--- LumonTestDeliveryBatches - Using existing Quotes');
        } else {
            System.debug('--- LumonTestDeliveryBatches - Creating New Quotes');
            LumonTestQuotes.setupQuoteData();
        }
        Test.stopTest();
    }
    @isTest
    public static void setupDeliveryBatchDataTest(){
        String testResult;
        Test.startTest();
        try {
            setupDeliveryBatchData();
            testResult = 'successfully inserted Delivery Batches';
        } catch (exception e){
            testResult = 'Error when inserting Delivery Batches: '+e.getMessage();
        }
        System.debug('--- LumonTestDeliveryBatches - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDeliveryBatches - Queries used: '+LIMITS.getQueries());
        Test.stopTest();       
        System.AssertNotEquals(true, testResult.contains('Error'));
    }
}