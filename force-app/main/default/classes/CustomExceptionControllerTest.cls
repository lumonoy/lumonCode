/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 09-12-2024
 * @last modified by  : Henk Reynders
**/
@isTest
public class CustomExceptionControllerTest {
    @isTest
    public static void throwCustomExceptionDMLTest() {
        try {
            Account emptyAccount = new Account();
            insert emptyAccount;
        } catch (Exception e) {
            CustomExceptionData exceptionData = new CustomExceptiondata();
            exceptionData.type = e.getTypeName();
            exceptionData.message = e.getMessage();
            exceptionData.method = 'TESTMETHOD';
            exceptionData.doinsert = true;
            CustomExceptionController.throwCustomException(exceptionData);
            CustomException__c cException = CustomExceptionController.getCustomException();
            System.Debug ('--- CustomExceptionControllerTest: '+ cException);
            System.assertNotEquals(null,cException, 'Expected One or More Exceptions to be returned');
            System.Debug('--- Check 1: Any Exception: '+[SELECT Id FROM CustomException__c]);
            List<CustomException__c> allExceptions = CustomExceptionController.getCustomExceptions();
            System.assertNotEquals(0,allExceptions.size(), 'Expected One or More Exceptions to be returned');
            System.Debug('--- Check 2: Type Exception: '+[SELECT Id,Exception_Type__c FROM CustomException__c WHERE Exception_Type__c LIKE '%dml%']);
            String exceptionType = 'dml';//cException?.Exception_Type__c;
            List<CustomException__c> typeExceptions = CustomExceptionController.getCustomExceptionsByClass(exceptionType);
            System.assertNotEquals(0,typeExceptions.size(), 'Expected One or More Exceptions to be returned');
            System.Debug('--- Check 3: Method Exception: '+[SELECT Id,MethodName__c FROM CustomException__c WHERE MethodName__c LIKE '%TEST%']);           
            String exceptionMethod = cException?.MethodName__c;
            List<CustomException__c> methodExceptions = CustomExceptionController.getCustomExceptionsByMethod(exceptionMethod);
            System.assertEquals(0,methodExceptions.size(), 'Expected One or More Exceptions to be returned');
            System.debug('--- CustomExceptionControllerTest - CPU TIME: '+LIMITS.getCpuTime()); 
            System.debug('--- CustomExceptionControllerTest - SOQL USED: ' + LIMITS.getQueries());
        }    
    } 
}