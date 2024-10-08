/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 06-13-2024
 * @last modified by  : Henk Reynders
**/
@IsTest
public without sharing class CustomExceptionControllerTest {
    @TestSetup
    public static void prepareData(){
        Test.startTest();
        Test.stopTest();
    }   
    @IsTest
    static void createCustomExceptionTest(){
        Test.startTest();      
        String className = 'CustomExceptionControllerTest';
        String message = 'Some Exception occured';
        double LineNumber = 100;
        String methodName = 'createCustomExceptionTest';
        String type = 'exceptionType';
        Boolean doInsert = true;
        CustomException__c customException = CustomExceptionController.createCustomException(className, message, LineNumber, methodName, type,  doInsert);
        System.debug('--- CustomExceptionControllerTest - createCustomExceptionTest - Exception: '+customException); 
        System.assertNotEquals(null, customException, 'Expected a Custom Exception to be Created');
        System.debug('--- CustomExceptionControllerTest - createCustomExceptionTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- CustomExceptionControllerTest - createCustomExceptionTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    public static void triggerCustomException() {
        try {
            Account bogusAccount = new Account();
            insert bogusAccount;
        } catch (Exception e) {
            CustomException.logCustomException(e);
            CustomException__c customException = CustomExceptionController.getCustomException();
            System.debug('--- CustomExceptionControllerTest - createCustomExceptionTest - Exception: '+customException); 
            System.assertNotEquals(null, customException, 'Expected a Custom Exception to be Created');
            System.debug('--- CustomExceptionControllerTest - createCustomExceptionTest - CPU TIME: '+LIMITS.getCpuTime()); 
            System.debug('--- CustomExceptionControllerTest - createCustomExceptionTest - SOQL USED: ' + LIMITS.getQueries());
        }    
    } 
}