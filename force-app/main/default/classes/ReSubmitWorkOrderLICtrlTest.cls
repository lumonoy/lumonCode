/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-03-2023
 * @last modified by  : Henk Reynders
**/

@isTest
public class ReSubmitWorkOrderLICtrlTest {
    @TestSetup
    public static void prepareData(){
        Test.startTest();
        //SalesTestDataFactory.setupAccountRecords();
        LumonTestDataFactory.setupAccountB2C();
        LumonTestDataFactory.setupAccountB2B();
        Test.stopTest();
    }   
    private static Id b2cAccountId = LumonTestDataFactory.b2cAccountId;
    private static Id b2bAccountId = LumonTestDataFactory.b2bAccountId;
    @IsTest
	static void reSubmitWOLITest () {
		WorkOrder wo = new WorkOrder(AccountId = b2cAccountId);
		insert wo;
        Install_Expense__c insExpense = new Install_Expense__c(Profit_Center__c = '4010 LSU Vantaa West', Hourly_Expense__c = 52, Name ='Vantaa West');
        insert insExpense;
		WorkOrderLineItem woli = new WorkOrderLineItem(WorkOrderId = wo.Id, Install_Expense__c = insExpense.Id, RVN_Number__c = '123456', Installed_By__c = UserInfo.getUserId());
		insert woli;
		Test.startTest();
        String body = '{"response": "success"}';
		MockResponseGenerator mockResp = new MockResponseGenerator(body, 200);
		Test.setMock(HttpCalloutMock.class, mockResp);
		ReSubmitWorkOrderLIController.reSubmitWOLI(woli.Id);
		Test.stopTest();
	}
}