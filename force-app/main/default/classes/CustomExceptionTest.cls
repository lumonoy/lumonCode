@isTest
public class CustomExceptionTest {
    @isTest
    public static void CreateAccount() {
        try {
            Account m = new Account();
            insert m;
        } catch (Exception e) {
            HandleCustomException.LogException(e);
        }    
    } 
}