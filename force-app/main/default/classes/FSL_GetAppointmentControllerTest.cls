/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-05-2023
 * @last modified by  : Henk Reynders
**/
@IsTest
public with sharing class FSL_GetAppointmentControllerTest {
    @TestSetup
    public static void prepareData(){
        Test.startTest();
		LumonTestFieldServices.setupFieldServices();      
        Test.stopTest();
    }   
    private static Id fslAccountId = LumonTestFieldServices.fslAccountId;
    private static Id fslOpportunityId = LumonTestFieldServices.fslOpportunityId;
    private static Id serviceTerritoryId = LumonTestFieldServices.serviceTerritoryId;
    private static Id policyId = LumonTestFieldServices.policyId;
    private static Id workOrderId = LumonTestFieldServices.workOrderId;
    private static Id serviceAppointmentId = LumonTestFieldServices.serviceAppointmentId;
	@IsTest
	static void getAvailableSlotsTest() {
		Test.startTest();
		Map<String,List<FSL_GetAppointmentController.SlotDetail>> slots = FSL_GetAppointmentController.getAvailableSlotsMap(serviceAppointmentId);
        System.assertNotEquals(null, slots.get('success'), 'getAvailableSlots reply should not be null');
		System.debug('----getAvailableSlotsTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('----getAvailableSlotsTest - SOQL USED: ' + LIMITS.getQueries());
		Test.stopTest();
	}
	@IsTest
	static void updateAppointmentTest() {
		Test.startTest();
        DateTime timeNow =(Datetime.now());
        String startTime = string.valueOfGmt(timeNow);
        String endTime = string.valueOfGmt(timeNow.addHours(2));
        FSL_GetAppointmentController.updateServiceAppointments(serviceAppointmentId,startTime , endTime);
        ServiceAppointment updatedAppointment = [SELECT Id, ArrivalWindowStartTime, ArrivalWindowEndTime, FSL__IsMultiDay__c, Status FROM ServiceAppointment WHERE Id =: serviceAppointmentId  LIMIT 1 ];
        System.assertNotEquals(null, updatedAppointment.Id, 'updated Service Appointment should not be null');
		System.debug('----updateAppointmentTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('----updateAppointmentTest - SOQL USED: ' + LIMITS.getQueries());
		Test.stopTest();
	}
	@IsTest
	static void getSlotsWithCalendarTest() {
		Test.startTest();
		Map<String,List<FSL_GetAppointmentController.SlotDetail>> slots = FSL_GetAppointmentController.getAvailableSlotsMap(serviceAppointmentId);
		System.assertNotEquals(null, slots.get('success'), 'getAvailableSlots reply should not be null');
        System.debug('----getAvailableSlotsWithCalendarTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('----getAvailableSlotsWithCalendarTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
	}

	@IsTest
	static void getSlotsWithoutTerritoryTest() {
		WorkOrder workOrder = new WorkOrder();
		workOrder.AccountId = fslAccountId;
		workOrder.Subject = 'Test WorkOrder No Territory';
		insert workOrder;
        ServiceAppointment serviceAppointment = new ServiceAppointment();
		serviceAppointment.Status = 'In Progress';
		serviceAppointment.EarliestStartTime = Date.today();
		serviceAppointment.DueDate = Date.today().addDays(10);
		//serviceAppointment.ServiceTerritoryId;
		serviceAppointment.ParentRecordId = workOrder.Id;
		insert serviceAppointment;
		System.Debug('----getSlotsWithoutTerritoryTest - WorkOrder: '+[SELECT Id,AccountId,Subject FROM WorkOrder WHERE Id = : workOrder.Id]);
		System.Debug('----getSlotsWithoutTerritoryTest - Appointment: '+[SELECT Id,Status,serviceTerritoryId,ParentRecordId FROM ServiceAppointment WHERE Id =: serviceAppointment.Id]);
		Test.startTest();
		Map<String,List<FSL_GetAppointmentController.SlotDetail>> slots = FSL_GetAppointmentController.getAvailableSlotsMap(serviceAppointment.Id);
		System.assertNotEquals(null, slots.get('st_missing_from_sa'), 'getAvailableSlots reply should not be null');
        System.debug('----getSlotsWithoutTerritoryTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('----getSlotsWithoutTerritoryTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
	}

	@IsTest
	static void getSlotsWithoutAppointmentTest() {
		Test.startTest();
		Map<String,List<FSL_GetAppointmentController.SlotDetail>> slots = FSL_GetAppointmentController.getAvailableSlotsMap('abcd');
        System.assertNotEquals(null, slots.get('sa_missing'), 'getAvailableSlots reply should not be null');
        System.debug('----getSlotsWithoutAppointmentTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('----getSlotsWithoutAppointmentTest - SOQL USED: ' + LIMITS.getQueries());
		Test.stopTest();
	}

	@IsTest
	static void gGetDualSlotsForSchedulingTest() {
		Case a = new Case(Subject = 'parentCase');
		insert a;
		Attachment att = new Attachment(Name = 'ScheduleResult.json', ParentId = a.Id, Body = Blob.valueOf('{}'));
		insert att;
		System.assertNotEquals(null, FSL_GetAppointmentController.getDualSASlotsMap(a.Id).get('scheduling_message'), 'Key scheduling_message was not returned!');
	}

	@IsTest
	static void getDualSlotsForSlotsTest() {
		Case a = new Case(Subject = 'parentCase');
		insert a;

		Attachment att = new Attachment(Name = 'AppointmentBookingResult.json', ParentId = a.Id, Body = Blob.valueOf('{"Slots":[{"SortByObjective":null,"m_sortBy":"SORT_BY_GRADE","Interval":{"Type":"OperationalSlot","Start":"2023-01-19T09:00:00.000Z","Finish":"2023-01-19T11:00:00.000Z"},"Grade":72.7272727272727272727272727272727,"BestSlotGrades":[{"Text":null,"RankInAppointments":27,"ObjectiveRecordTypeName":"Objective_PreferredEngineer","ObjectiveId":null,"NumberOfAppointmentsWithGrade100":27,"IsYesOrNoObjective":true,"IconName":"users","HeaderText":"Preferred Service Resource","Grade":100},{"Text":"1674111600000","RankInAppointments":1,"ObjectiveRecordTypeName":"Objective_Asap","ObjectiveId":null,"NumberOfAppointmentsWithGrade100":1,"IsYesOrNoObjective":false,"IconName":"clock-o","HeaderText":"ASAP","Grade":100.00000000000000000000000000000000000},{"Text":null,"RankInAppointments":1,"ObjectiveRecordTypeName":"Objective_Minimize_Travel","ObjectiveId":null,"NumberOfAppointmentsWithGrade100":0,"IsYesOrNoObjective":false,"IconName":"car","HeaderText":"Minimize Travel","Grade":0},{"Text":"Resource NA value is NA","RankInAppointments":1,"ObjectiveRecordTypeName":"Objective_Resource_Priority","ObjectiveId":null,"NumberOfAppointmentsWithGrade100":0,"IsYesOrNoObjective":false,"IconName":"exclamation","HeaderText":"Resource Priority","Grade":0}]},{"SortByObjective":null,"m_sortBy":"SORT_BY_GRADE","Interval":{"Type":"OperationalSlot","Start":"2023-01-27T15:00:00.000Z","Finish":"2023-01-27T17:00:00.000Z"},"Grade":36.3636363636363636363636363636364,"BestSlotGrades":[{"Text":null,"RankInAppointments":1,"ObjectiveRecordTypeName":"Objective_PreferredEngineer","ObjectiveId":null,"NumberOfAppointmentsWithGrade100":27,"IsYesOrNoObjective":true,"IconName":"users","HeaderText":"Preferred Service Resource","Grade":100},{"Text":"1674824400000","RankInAppointments":27,"ObjectiveRecordTypeName":"Objective_Asap","ObjectiveId":null,"NumberOfAppointmentsWithGrade100":1,"IsYesOrNoObjective":false,"IconName":"clock-o","HeaderText":"ASAP","Grade":-2.960E-32},{"Text":null,"RankInAppointments":27,"ObjectiveRecordTypeName":"Objective_Minimize_Travel","ObjectiveId":null,"NumberOfAppointmentsWithGrade100":0,"IsYesOrNoObjective":false,"IconName":"car","HeaderText":"Minimize Travel","Grade":0},{"Text":"Resource NA value is NA","RankInAppointments":27,"ObjectiveRecordTypeName":"Objective_Resource_Priority","ObjectiveId":null,"NumberOfAppointmentsWithGrade100":0,"IsYesOrNoObjective":false,"IconName":"exclamation","HeaderText":"Resource Priority","Grade":0}]}],"PartialResults":[],"NumberOfServices":2,"IsMST":true,"IsFallback":false,"FSLOperationId":null}'));
		insert att;
		System.assertNotEquals(null, FSL_GetAppointmentController.getDualSASlotsMap(a.Id).get('success'), 'Key success was not returned!');
	}
}