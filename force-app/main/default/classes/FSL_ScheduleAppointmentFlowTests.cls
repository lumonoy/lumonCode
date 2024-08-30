/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-01-2023
 * @last modified by  : Henk Reynders
**/
@isTest
public class FSL_ScheduleAppointmentFlowTests {

    public static void setTestData(){
		String B2CRecordTypeId = [SELECT Id FROM RecordType WHERE (IsPersonType = true) and (SobjectType='Account') LIMIT 1].Id;
		Account p = new Account(      
			RecordTypeID=B2CRecordTypeId,
			FirstName='B2C',
			LastName='Account',
			PersonEmail='test@factory.com',
			PersonMailingCountry ='Finland',
			PersonMailingCity='Kaupunki',
			PersonMailingPostalCode = '1111',
			PersonMailingStreet='Katu 1');
		insert p;   
        String B2BRecordTypeId= [SELECT Id FROM RecordType WHERE (IsPersonType = false) and (SobjectType='Account')LIMIT 1].Id;
		Account a = new Account(
			RecordTypeID=B2BRecordTypeId,
			Name='B2B Account',
			BillingCountry ='Finland',
			BillingCity='Kaupunki',
			BillingPostalCode = '22222',
			BillingStreet = 'Katu 2');
		insert a;    

        Schema.Location l = new Schema.Location(Name = 'TestL');
        insert l;

        Opportunity o = new Opportunity(Name = 'TestO', Customer_Segment__c = '1000', StageName='Quoting', CloseDate = System.today(), AccountId = a.Id, Delivery_Location__c = l.Id, Delivery_date__c = System.today().addDays(5));
        insert o;
		o = [SELECT Id, Name, AccountId, Delivery_Location__c, Delivery_date__c, Installation_duration__c  FROM Opportunity WHERE Id =: o.Id];

		OperatingHours oh = new OperatingHours(Name = 'testOH');
		insert oh;

		FSL__Scheduling_Policy__c sp = new FSL__Scheduling_Policy__c(Name = 'Custom Component Reservation');
		insert sp;

		ServiceTerritory st = new ServiceTerritory(Name = 'testT', Appointment_Booking_Offset__c = 5, OperatingHoursId = oh.Id, IsActive = true);
		insert st;
		st = [SELECT Id, Appointment_Booking_Offset__c FROM ServiceTerritory Limit 1];

		WorkOrder wo = new WorkOrder(Subject = o.Name, Opportunity__c = o.Id, AccountId = o.AccountId, ContactId = a.PersonContactId, LocationId = o.Delivery_Location__c, Duration = o.Installation_duration__c, DurationType = 'Hours', ServiceTerritoryId = st.Id);
        insert wo;

		ServiceAppointment sa = new ServiceAppointment(ParentRecordId = wo.Id, EarliestStartTime = o.Delivery_date__c, DueDate = o.Delivery_date__c.addDays(5), Duration = o.Installation_duration__c);
        insert sa;
    }

	@IsTest
	public static void testScheduleFlow() {
		setTestData();
        List<String> woIdList = new List<String>{[Select Id From WorkOrder Limit 1][0].Id};
        List<List<String>> listlist = new List<List<String>>{woIdList};
        FSL_ScheduleAppointmentFlow.reserveAppointment(listlist);
	}
}