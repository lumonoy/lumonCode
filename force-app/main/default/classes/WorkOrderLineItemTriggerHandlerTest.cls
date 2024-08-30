/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-01-2023
 * @last modified by  : Henk Reynders
**/

@IsTest
private class WorkOrderLineItemTriggerHandlerTest {
	@TestSetup
    public static void prepareData(){
        Test.startTest();
        //SalesTestDataFactory.setupAccountRecords();
        LumonTestDataFactory.setupAccountB2C();
        Test.stopTest();
    }   
	@IsTest
	static void updateToCompletedTest () {
		Account acc = [SELECT Id FROM Account WHERE Name =: 'My Person Account' LIMIT 1];
		Install_Expense__c insExpense = new Install_Expense__c(Profit_Center__c = '4010 LSU Vantaa West', Hourly_Expense__c = 52, Name ='Vantaa West');
        insert insExpense;
		WorkOrder wo = new WorkOrder(AccountId = acc.Id);
		insert wo;
		WorkOrderLineItem woli = new WorkOrderLineItem(WorkOrderId = wo.Id, Install_Expense__c = insExpense.Id, RVN_Number__c = '123456', Installed_By__c = UserInfo.getUserId());
		insert woli;

		Test.startTest();

		String body = '{"response": "success"}';
		MockResponseGenerator mockResp = new MockResponseGenerator(body, 200);
		Test.setMock(HttpCalloutMock.class, mockResp);

		update new WorkOrderLineItem(Id = woli.Id, Status = 'Completed');

		Test.stopTest();
	}
}