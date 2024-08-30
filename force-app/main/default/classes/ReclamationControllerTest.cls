/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-06-2023
 * @last modified by  : Henk Reynders
**/

@isTest
private class ReclamationControllerTest {
    @TestSetup
    static void prepareData(){
        Test.startTest();
        LumonTestReclamations.setupReclamationB2C();
        Test.stopTest();
    }
    private static Id reclamationId = LumonTestReclamations.b2cReclamationId;
    @IsTest
    static void prepareReclamationOrderTest(){
        String configId;
        Id docId;
        String recordId = reclamationId;
        String objectType = 'Opportunity';      
        String configPlanId;
        String documentId;
        String configJSON;
        String errorMessage;
        Test.startTest();
        try {
            QuotingManager.executeQuotingProcess('Prepare', 'Order', configId, recordId,objectType, configPlanId,documentId, configJSON);
        //String result =  ReclamationController.prepareOrder(reclamationId);
        } catch (Exception e) {
            //Any other exceptions that occur will go here
            errorMessage = e.getMessage(); 
            System.Debug ('*** QuotingManagerFeedbackTest - An Exception Occured:'+errorMessage);
        }
        System.assertEquals(null,errorMessage, 'Expected Reclamation Record update');
        System.debug('--- prepareReclamationOrderTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- prepareReclamationOrderTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
}