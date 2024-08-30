/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-01-2023
 * @last modified by  : Henk Reynders
**/
 public with sharing class FSL_GetAppointmentController {
	public class SlotDetail {
		@AuraEnabled
		public String id;
		@AuraEnabled
		public Decimal grade;
		@AuraEnabled
		public Datetime start;
		@AuraEnabled
		public String startDateString;
		@AuraEnabled
		public String startTimeString;
		@AuraEnabled
		public String monthString;
		@AuraEnabled
		public String dayString;
		@AuraEnabled
		public String dayOfMonth;
		@AuraEnabled
		public String yearString;
		@AuraEnabled
		public String endDateString;
		@AuraEnabled
		public String endTimeString;
		@AuraEnabled
		public Datetime finish;
	}

	public class ABSlotsResponse {
		@AuraEnabled
		public Id FSLOperationId;
		@AuraEnabled
		public List<AppointmentBookingSlot> Slots;
	}

	public class AppointmentBookingSlot {
		@AuraEnabled
		public Decimal Grade;
		@AuraEnabled
		public IntervalClass Interval;
	}

	public class IntervalClass {
		@AuraEnabled
		public String Type;
		@AuraEnabled
		public Datetime Start;
		@AuraEnabled
		public Datetime Finish;
	}

	@AuraEnabled
	public static Map<String, List<SlotDetail>> getAvailableSlotsMap(String saId) {

		Map<String,List<SlotDetail>> mapToReturn = new Map<String,List<SlotDetail>>();
		//List<SlotDetail> slotsToReturn = new List<SlotDetail>();
		
		try{
			List<ServiceAppointment> sa = [SELECT Id, ServiceTerritoryId FROM ServiceAppointment WHERE Id =: saId Limit 1];

			if(!sa.isEmpty()){
				if(sa[0].ServiceTerritoryId != null){
					// Get Scheduling Calendar from ServiceTerritory or from Metadata
					List<ServiceTerritory> serviceTerritory = [SELECT Id, Scheduling_Calendar__c, Scheduling_Calendar__r.Name FROM ServiceTerritory WHERE Id = : sa[0].ServiceTerritoryId];
					String schedulingCalendar = null;

					if(!serviceTerritory.isEmpty()){
						if (serviceTerritory[0].Scheduling_Calendar__c != null) {
							schedulingCalendar = serviceTerritory[0].Scheduling_Calendar__r.Name;
						} else {
							FSL_Variable__mdt[] fsl_variables = [SELECT MasterLabel, Value__c FROM FSL_Variable__mdt];
							for (FSL_Variable__mdt var : fsl_variables) {
								if (var.MasterLabel == 'Default Scheduling Calendar') {
									schedulingCalendar = var.Value__c;
								}
							}
						}
						if(schedulingCalendar == null){
							mapToReturn.put('sc_missing',new List<SlotDetail>());
							return mapToReturn;	
						}
					}
					else{
						mapToReturn.put('check_st_access',new List<SlotDetail>());
						return mapToReturn;	
					}

					List<OperatingHours> operatingHours = [
						SELECT Id, (SELECT EndTime, StartTime, Type, DayOfWeek FROM TimeSlots)
						FROM OperatingHours
						WHERE Name = :schedulingCalendar
						LIMIT 1
					];

					List<FSL.AppointmentBookingSlot> abSlots = new List<FSL.AppointmentBookingSlot>();
					//If test create mockup data
					if(Test.isRunningTest()){
						FSL.AppointmentBookingSlot slotTestOne = new FSL.AppointmentBookingSlot();
						slotTestOne.Grade = 100;
						slotTestOne.Interval =  new FSL.TimeInterval
								(Datetime.newInstance(2022,12, 12, 09, 00,00), Datetime.newInstance(2022,12, 12, 11, 00,00)
								);
						FSL.AppointmentBookingSlot slotTestTwo = new FSL.AppointmentBookingSlot();
						slotTestTwo.Grade = 100;
						slotTestTwo.Interval =  new FSL.TimeInterval
								(Datetime.newInstance(2022,12, 12, 11, 00,00), Datetime.newInstance(2022,12, 12, 13, 00,00)
								);
						List<FSL.AppointmentBookingSlot> abSlotsTest = new List<FSL.AppointmentBookingSlot>();
						abSlots.add(slotTestOne);
						abSlots.add(slotTestTwo);
					} else {
						Id schedulingPolicyId = [SELECT Id FROM FSL__Scheduling_Policy__c WHERE Name = 'Receive Slots' LIMIT 1].Id;
						TimeZone timeZone = UserInfo.getTimeZone();
						FSL.ABSlotsResponse abSlotsResponse = FSL.AppointmentBookingService.GetABSlots(saId, schedulingPolicyId, operatingHours[0], timeZone, 'SORT_BY_GRADE', false);
						abSlots = abSlotsResponse.Slots;
					}
					mapToReturn.put('success',createSlotDetailsListFromJSONFSL(abSlots));
					return mapToReturn;
				}
				mapToReturn.put('st_missing_from_sa',new List<SlotDetail>());
				return mapToReturn;	
			}
			mapToReturn.put('sa_missing',new List<SlotDetail>());
			return mapToReturn;	
		}
		catch(Exception e){
			System.debug('Error when checking slots: '+e);
			mapToReturn.put('general_error',new List<SlotDetail>());
			return mapToReturn;	
		}	
	}

	/*
    * Return slotMap and delete FSL Operation record 
    */
    @AuraEnabled
    public static Map<String, List<SlotDetail>> getDualSASlotsMap(String operationId){

		Map<String,List<SlotDetail>> mapToReturn = new Map<String,List<SlotDetail>>();

        try{
            Attachment att = [SELECT Body, Name FROM Attachment WHERE ParentId =: operationId];
			//In case of Scheduling message
			if(att.Name == 'ScheduleResult.json'){
				mapToReturn.put('scheduling_message',new List<SlotDetail>());
			}
			//In case of Appointment Booking
			if(att.Name == 'AppointmentBookingResult.json'){
				ABSlotsResponse res = (ABSlotsResponse) JSON.deserialize(att.Body.toString(), ABSlotsResponse.class);
				mapToReturn.put('success',createSlotDetailsListFromJSON(res.Slots));
			}	
        }
        catch(Exception e){
            mapToReturn.put('general_error' + e,new List<SlotDetail>());
        }    

		return mapToReturn;
    }

	// Method to save/update the time slot fields in the service appointment:
	@AuraEnabled
	public static void updateServiceAppointments(String serviceAppointmentId, String startTime, String endTime) {

		List<FSL__Time_Dependency__c> tdcs = [SELECT Id FROM FSL__Time_Dependency__c WHERE FSL__Service_Appointment_1__c =: serviceAppointmentId];
		String workOrderId = [SELECT Id, ParentRecordId FROM ServiceAppointment WHERE Id =: serviceAppointmentId].ParentRecordId;
		List<ServiceAppointment> sas = [SELECT Id, ArrivalWindowStartTime, ArrivalWindowEndTime, FSL__IsMultiDay__c, Status FROM ServiceAppointment WHERE ParentRecordId =: workOrderId];

		//If complex multiday work manual update is needed
		if(!tdcs.isEmpty() && sas[0].FSL__IsMultiDay__c){

			for(ServiceAppointment sa : sas){
				sa.ArrivalWindowStartTime = Datetime.valueOf(startTime.replace('T', ' '));
				sa.ArrivalWindowEndTime = Datetime.valueOf(endTime.replace('T', ' '));
			}
			update sas;

			// Reschedule also if already scheduled
			if (sas[0].Status == 'Scheduled') {
				Id schedulingPolicyId = [SELECT Id FROM FSL__Scheduling_Policy__c WHERE Name = 'Custom Component Reservation' LIMIT 1].Id;
				for(ServiceAppointment sa : sas){
					scheduleExtended(schedulingPolicyId, sa.Id);
				}
			}

		}	
		else{
			ServiceAppointment serviceAppointment = new ServiceAppointment();
			serviceAppointment.Id = serviceAppointmentId;
			serviceAppointment.ArrivalWindowStartTime = Datetime.valueOf(startTime.replace('T', ' '));
			serviceAppointment.ArrivalWindowEndTime = Datetime.valueOf(endTime.replace('T', ' '));
			update serviceAppointment;
			
			// Reschedule also if already scheduled
			if ([SELECT Id, Status FROM ServiceAppointment WHERE Id = :serviceAppointmentId].Status == 'Scheduled') {
				Id schedulingPolicyId = [SELECT Id FROM FSL__Scheduling_Policy__c WHERE Name = 'Custom Component Reservation' LIMIT 1].Id;
				scheduleExtended(schedulingPolicyId, serviceAppointmentId);
			}
		}
	}

	//	Method to schedule the appointment - should run after the updateServiceAppointments()
	@AuraEnabled
	public static List<FSL.ScheduleResult> scheduleExtended(Id policy, Id serviceId) {
		return FSL.ScheduleService.ScheduleExtended(policy, serviceId);
	}

	public static List<SlotDetail> createSlotDetailsListFromJSONFSL(List<FSL.AppointmentBookingSlot> slotJSON){
		List<SlotDetail> slotsToReturn = new List<SlotDetail>();

		for (FSL.AppointmentBookingSlot slot : slotJSON) {
			SlotDetail slotToReturn = new SlotDetail();
			slotToReturn.id = slot.Interval.toString();
			slotToReturn.grade = slot.Grade;
			// start of each slot:
			slotToReturn.start = slot.Interval.Start;
			slotToReturn.startDateString = slot.Interval?.Start?.formatGmt('dd-MM-yyyy');
			slotToReturn.startTimeString = slot.Interval?.Start?.formatGmt('HH:mm');
			// end of each slot:
			slotToReturn.finish = slot.Interval.Finish;
			slotToReturn.endDateString = slot.Interval?.Finish?.formatGmt('dd-MM-yyyy');
			slotToReturn.endTimeString = slot.Interval?.Finish?.formatGmt('HH:mm');
			// date info:
			slotToReturn.dayOfMonth = slot.Interval?.Start?.formatGmt('dd');
			slotToReturn.monthString = slot.Interval?.Start?.formatGmt('MMMM');
			slotToReturn.dayString = slot.Interval?.Start?.formatGmt('EEEE');
			slotToReturn.yearString = slot.Interval?.Start?.formatGmt('YYYY');

			slotsToReturn.add(slotToReturn);
		}

		return slotsToReturn;
	}

	public static List<SlotDetail> createSlotDetailsListFromJSON(List<AppointmentBookingSlot> slotJSON){
		List<SlotDetail> slotsToReturn = new List<SlotDetail>();

		for (AppointmentBookingSlot slot : slotJSON) {
			SlotDetail slotToReturn = new SlotDetail();
			slotToReturn.id = slot.Interval.toString();
			slotToReturn.grade = slot.Grade;
			// start of each slot:
			slotToReturn.start = slot.Interval.Start;
			slotToReturn.startDateString = slot.Interval?.Start?.formatGmt('dd-MM-yyyy');
			slotToReturn.startTimeString = slot.Interval?.Start?.formatGmt('HH:mm');
			// end of each slot:
			slotToReturn.finish = slot.Interval.Finish;
			slotToReturn.endDateString = slot.Interval?.Finish?.formatGmt('dd-MM-yyyy');
			slotToReturn.endTimeString = slot.Interval?.Finish?.formatGmt('HH:mm');
			// date info:
			slotToReturn.dayOfMonth = slot.Interval?.Start?.formatGmt('dd');
			slotToReturn.monthString = slot.Interval?.Start?.formatGmt('MMMM');
			slotToReturn.dayString = slot.Interval?.Start?.formatGmt('EEEE');
			slotToReturn.yearString = slot.Interval?.Start?.formatGmt('YYYY');

			slotsToReturn.add(slotToReturn);
		}

		return slotsToReturn;
	}
}