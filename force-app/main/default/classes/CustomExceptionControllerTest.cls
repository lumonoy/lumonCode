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
            exceptionData.doinsert = true;
            CustomExceptionController.throwCustomException(exceptionData);
        }    
    } 
}