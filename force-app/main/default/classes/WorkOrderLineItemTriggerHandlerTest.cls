/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 08-18-2024
 * @last modified by  : Henk Reynders
**/

@IsTest
private class WorkOrderLineItemTriggerHandlerTest {
	@TestSetup
    public static void prepareData(){
        Test.startTest();
		LumonTestDataFactory.setupAccountB2C();
        //LumonTestAccounts.setupAccountB2C();
        Test.stopTest();
    }  
	@TestVisible private static Id b2cAccountId{
        get{
            return LumonTestVariables.b2cAccountId;
        }
    }
	@IsTest
	static void getRemoteInstallationDocumentsTest () {
		WorkOrder workOrderRecord = new WorkOrder(AccountId = b2cAccountId);
		insert workOrderRecord;
		String body = '{"response": "success"}';
		MockResponseGenerator mockResp = new MockResponseGenerator(body, 200);
		Test.setMock(HttpCalloutMock.class, mockResp);

		Test.startTest();
		
			WorkOrderLineItem woli = new WorkOrderLineItem();
			woli.WorkOrderId = workOrderRecord.Id; 
			woli.RemoteFile__c = '123456.pdf';
			woli.RemoteFolder__c = '"\\12345\\56789\\"'; //\\269000\\269961\\
			insert woli;
		

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