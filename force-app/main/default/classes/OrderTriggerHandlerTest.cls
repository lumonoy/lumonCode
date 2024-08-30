/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-11-2023
 * @last modified by  : Henk Reynders
**/
@IsTest
public class OrderTriggerHandlerTest {
    @TestSetup
    static void prepareData(){
        Test.startTest();
        LumonTestDataFactory.setupProducts();
        LumonTestDataFactory.setupPrices();
        // B2C Setup
        LumonTestDataFactory.setupAccountB2C();
        LumonTestDataFactory.setupOpportunityB2C();        
        LumonTestDataFactory.setupOrderB2C();  
        Test.stopTest();
    }
    private static Id b2cAccountId = LumonTestDataFactory.b2cAccountId;
    private static Id b2cOpportunityId = LumonTestDataFactory.b2cOpportunityId;
    private static Id b2cSyncedQuoteId = LumonTestDataFactory.b2cSyncedQuoteId;
    private static Id b2cOrderId = LumonTestDataFactory.b2cOrderId;

     @IsTest
     public static void createOrderLineItemsTest() {
        Test.startTest();
        String errorMessage;
        Order orderRecord = OrderController.GetOrderRecord(b2cOrderId);
        List<Order> orders = new List<Order>{orderRecord};
        Boolean isTriggered = true;
        try {
            OrderTriggerHandler.upsertOrderLineItems(orderRecord.OpportunityId);
            System.debug('--- createOrderLineItemsTest - Trigger Executed');
        } catch (Exception e){
            System.debug('--- createOrderLineItemsTest - Exception Occured'+e.getMessage());
            errorMessage = e.getMessage();
        }
        System.debug('*** errorMessage ***'+errorMessage);
        System.assertEquals(null,errorMessage, ' Trigger executed');
        System.debug('--- createOrderLineItemsTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- createOrderLineItemsTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
     }

         
}