/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-02-2023
 * @last modified by  : Henk Reynders
**/
@isTest
public class FeedbackEventTest {
    @TestSetup
    static void prepareData(){
        Test.startTest();
        LumonTestDataFactory.setupProducts();
        LumonTestDataFactory.setupPrices();
        // B2C Setup
        LumonTestDataFactory.setupAccountB2C();
        LumonTestDataFactory.setupOpportunityB2C();        
        Test.stopTest();
    }
    private static Id b2cAccountId = LumonTestDataFactory.b2cAccountId;
    private static Id b2cOpportunityId = LumonTestDataFactory.b2cOpportunityId;

    @isTest static void TestValidEvent() {
        String recordId = b2cOpportunityId;//Opportunity.Id
        String key ='TestToast'; //Toast Identifier -> Set in feedbackEventToastLWC  
        String title ='Toast Title'; //Toast Title
        String message='Toast Message'; //Toast Message
        String mode='pester'; //dismissable, pester or sticky
        String variant='error';//info , success, warning or error
        // Create a test event instance
        FeedbackEvent__e feedbackEvent = new FeedbackEvent__e(RecordId__c=recordId, 
                                                                Key__c=key, 
                                                                Title__c=title,
                                                                Message__c=message,
                                                                Mode__c=mode, 
                                                                Variant__c=variant);   
        Test.startTest();       
        // Publish test event
        Database.SaveResult sr = EventBus.publish(feedbackEvent);          
        Test.stopTest();       
        System.assertEquals(true, sr.isSuccess());
    }
    
    @isTest static void TestInvalidEvent() {     
        // Create a test event instance with invalid data.
        // We assume for this test that the Serial_Number__c field is required.
        // Publishing with a missing required field should fail.
        String recordId = b2cOpportunityId;//Opportunity.Id
        String key; //Toast Identifier -> Set in feedbackEventToastLWC  
        String title ='Toast Title'; //Toast Title
        String message='Toast Message'; //Toast Message
        String mode='pester'; //dismissable, pester or sticky
        String variant='error';//info , success, warning or error
        // Create a test event instance
        FeedbackEvent__e feedbackEvent = new FeedbackEvent__e(RecordId__c=recordId, 
                                                                Key__c=key, 
                                                                Title__c=title,
                                                                Message__c=message,
                                                                Mode__c=mode, 
                                                                Variant__c=variant);   
        
        Test.startTest(); 
        // Publish test event
        Database.SaveResult sr = EventBus.publish(feedbackEvent);
        Test.stopTest();       
        System.assertEquals(false, sr.isSuccess());      
        // Log the error message
        for(Database.Error err : sr.getErrors()) {
            System.debug('Error returned: ' +
                        err.getStatusCode() +
                        ' - ' +
                        err.getMessage()+' - '+err.getFields());
        }
        // Verify that something did not happen
    }
}