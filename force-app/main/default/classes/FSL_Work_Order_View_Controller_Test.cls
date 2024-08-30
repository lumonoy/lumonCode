/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-07-2023
 * @last modified by  : Henk Reynders
**/
@isTest
public class FSL_Work_Order_View_Controller_Test {
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
    public static void GetServiceAppointmentsTest() {
        Id WOId = workOrderId;
    	Id SAId = serviceAppointmentId; 
        System.debug('--- WO: '+WOId);
        System.debug('--- SA: '+SAId);
        Test.startTest();
        List<ServiceAppointment> SAs = FSL_Work_Order_View_Controller.getServiceAppointments(WOId);
        Test.stopTest();
        System.assertEquals(false,SAs.isEmpty());
    }
    @IsTest
    public static void GetWOsbyParentTest() {
        Id OPPId = fslOpportunityId;
        List<WorkOrder> WOs = FSL_Work_Order_View_Controller.getWorkOrders(OPPId);
        System.assertEquals(true,!WOs.isEmpty());
    }
    @IsTest
    public static void GetWOsbyIdTest() {
        Id WOId = workOrderId;
        List<WorkOrder> WOs = FSL_Work_Order_View_Controller.getWorkOrders2(WOId);
        System.assertEquals(true,!WOs.isEmpty());
    }

    @IsTest
    public static void GetAppointmentDependencyWithoutDependencyTest() {
        Id WOId = workOrderId;
    	Id SAId = serviceAppointmentId;
        Boolean SACheck = FSL_Work_Order_View_Controller.getAppointmentDependency(SAId);
        System.assertEquals(false,SACheck);
    }

    @IsTest
    public static void GetAppointmentDependencyWithDependencyTest() {
        Id WOId = workOrderId;
    	Id SAId = serviceAppointmentId;
        ServiceAppointment sa = new ServiceAppointment(ParentRecordId = WOId);
        insert sa;
        FSL__Time_Dependency__c td = new FSL__Time_Dependency__c(FSL__Dependency__c = 'Same Start', FSL__Service_Appointment_1__c = SAId, FSL__Service_Appointment_2__c = sa.Id, FSL__Root_Service_Appointment__c =SAId);
        insert td;
        System.assertEquals(true,FSL_Work_Order_View_Controller.getAppointmentDependency(SAId));
    }

    @IsTest
    public static void CreateWorkOrderTest() {
        Id OPPId = fslOpportunityId;
        Opportunity OPP = [SELECT Id,AccountId,Account.PersonContactId,
                           			StageName,
                           			Building__c,
                           			Deliver_To__c, Delivery_Address__c, Delivery_Location__c,
                           			Install_At__c,Installation_Address__c
                           FROM Opportunity LIMIT 1];
        System.debug('--- Opportunity Before: '+OPP);
        OPP.Installation_Address__City__s = 'Helsinki';
        OPP.Installation_Address__Street__s = 'Test Helsinki Street';
        OPP.Installation_Address__PostalCode__s = '00200';
        OPP.Installation_Address__CountryCode__s = 'FI';
        OPP.Installation_Address__StateCode__s = '';
        OPP.Installation_Address__Latitude__s=80.34;
		OPP.Installation_Address__Longitude__s=80.35;
		OPP.Installation_Address__GeocodeAccuracy__s='Address';
        OPP.Description = 'update Oppty';
        update OPP;
        System.debug('--- Opportunity After: '+OPP);
        System.debug('--- Account: '+OPP.AccountId);
        System.debug('--- Contact: '+OPP.Account.PersonContactId);
        System.debug('--- Location: '+OPP.Delivery_Location__c);
        System.debug('--- Deliver Address: '+OPP.Delivery_Address__c);
        System.debug('--- Installation_Address__c ---'+OPP.Installation_Address__c);
        System.debug('--- Install Address Street: '+OPP.Installation_Address__Street__s);
        System.debug('--- Install Address Country: '+OPP.Installation_Address__CountryCode__s);
        System.debug('--- Stage: '+OPP.StageName);
        Test.startTest();
        String flowResult = FSL_Work_Order_View_Controller.createWorkOrder(OPPId);
        Test.stopTest();
        System.assert(!flowResult.contains('error'));
    }

    
    @IsTest
    public static void testSaveSA() {
        Id WOId = workOrderId;
    	Id SAId = serviceAppointmentId;
        Decimal duration = 1;
        Date estValue = System.today();
        Date dueDate = System.today().addDays(5);
        String workOrderSubject = 'New WO';
        Integer amountOfInstallers = 1;
        Boolean SAsaved = FSL_Work_Order_View_Controller.saveSA(SAId,duration,estValue, dueDate,WOId,workOrderSubject,amountOfInstallers);
        System.assertEquals(true,SAsaved);
    }

    @IsTest
    public static void testSaveSAandAddInstaller() {
        Id WOId = workOrderId;
    	Id SAId = serviceAppointmentId;
        Decimal duration = 1;
        Date estValue = System.today();
        Date dueDate = System.today().addDays(5);
        String workOrderSubject = 'New WO';
        Integer amountOfInstallers = 2;
        Boolean SAsaved = FSL_Work_Order_View_Controller.saveSA(SAId,duration,estValue, dueDate,WOId,workOrderSubject,amountOfInstallers);
        System.assertEquals(true,SAsaved);
    }

    @IsTest
    public static void testSaveSAandDeleteInstaller() {
        Id WOId = workOrderId;
    	Id SAId = serviceAppointmentId;
        Boolean SACheck = FSL_Work_Order_View_Controller.getAppointmentDependency(SAId);
        ServiceAppointment sa = new ServiceAppointment(ParentRecordId = WOId);
        insert sa;
        FSL__Time_Dependency__c td = new FSL__Time_Dependency__c(FSL__Dependency__c = 'Same Start', FSL__Service_Appointment_1__c = SAId, FSL__Service_Appointment_2__c = sa.Id, FSL__Root_Service_Appointment__c = SAId);
        insert td;
        Decimal duration = 1;
        Date estValue = System.today();
        Date dueDate = System.today().addDays(5);
        String workOrderSubject = 'New WO';
        Integer amountOfInstallers = 1;
        Boolean SAsaved = FSL_Work_Order_View_Controller.saveSA(SAId,duration,estValue, dueDate,WOId,workOrderSubject,amountOfInstallers);
        System.assertEquals(true,SAsaved);
    }

    @IsTest
    public static void testSaveSAandUpdateInstaller() {
        Id WOId = workOrderId;
    	Id SAId = serviceAppointmentId;
        Boolean SACheck = FSL_Work_Order_View_Controller.getAppointmentDependency(SAId);
        ServiceAppointment sa = new ServiceAppointment(ParentRecordId = WOId);
        insert sa;
        FSL__Time_Dependency__c td = new FSL__Time_Dependency__c(FSL__Dependency__c = 'Same Start', FSL__Service_Appointment_1__c = SAId, FSL__Service_Appointment_2__c = sa.Id, FSL__Root_Service_Appointment__c = SAId);
        insert td;
        Decimal duration = 1;
        Date estValue = System.today();
        Date dueDate = System.today().addDays(5);
        String workOrderSubject = 'New WO';
        Integer amountOfInstallers = 2;
        Boolean SAsaved = FSL_Work_Order_View_Controller.saveSA(SAId,duration,estValue, dueDate,WOId,workOrderSubject,amountOfInstallers);
        System.assertEquals(true,SAsaved);    }

    @IsTest
    public static void testCancelBooking() {
        Id WOId = workOrderId;
    	Id SAId = serviceAppointmentId;
		Boolean SAdeleted = FSL_Work_Order_View_Controller.cancelBooking(SAId);
        System.assertEquals(true,SAdeleted);
    }

    @IsTest
    public static void testScheduleExtended() {
        Id WOId = workOrderId;
    	Id SAId = serviceAppointmentId;
		String SAextended = FSL_Work_Order_View_Controller.scheduleExtended(SAId);
        System.assertNotEquals(null,SAextended);
    }

    @IsTest
    public static void testCallWOLIFlow() {
        Id WOId = workOrderId;
    	Id SAId = serviceAppointmentId;
        FSL_Work_Order_View_Controller.callWOLIFlow(WOId);
    }

    @IsTest
    public static void testCallTerritoryFlow() {
        Id WOId = workOrderId;
    	Id SAId = serviceAppointmentId;
        FSL_Work_Order_View_Controller.callTerritoryFlow(WOId);
    }

    @IsTest
    public static void testGetNull() {
        System.assertEquals(null,FSL_Work_Order_View_Controller.getNull('test'));
    
    }
    @IsTest
    public static void testSAMultiDayWork() {        
        Id WOId = workOrderId;
    	Id SAId = serviceAppointmentId;
        ServiceAppointment SA = [SELECT Id, EarliestStartTime, DueDate,ServiceTerritoryId,ParentRecordId,Duration FROM ServiceAppointment WHERE Id =:SAId];
        SA.Duration = 10;
        Update SA;
    	Boolean SAmultiday = FSL_Work_Order_View_Controller.isSAMultiDayWork(SAId); 
        System.assertEquals(true,SAmultiday);
    }
    @IsTest
    public static void testOppoStage() { 
        Id OPPId = fslOpportunityId;
        String Stage = FSL_Work_Order_View_Controller.getOppoStageName(OPPId);
        System.assertNotEquals(null,Stage);
    }
    @IsTest
    public static void testSAScheduled() { 
        Id WOId = workOrderId;
    	Id SAId = serviceAppointmentId;
        Boolean SACheck = FSL_Work_Order_View_Controller.getAppointmentDependency(SAId);
        ServiceAppointment sa = new ServiceAppointment(ParentRecordId = WOId);
        insert sa;
        Boolean SAScheduled = FSL_Work_Order_View_Controller.getSAScheduled(SAId);
        System.assertNotEquals(null,SAScheduled);
    }
    @IsTest
    public static void testProfileAccess() { 
        Boolean ProfileAccess = FSL_Work_Order_View_Controller.getIsReserveOkForProfile();
        System.assertNotEquals(null,ProfileAccess);
    } 
    @IsTest
    public static void testDeleteWorkOrder() { 
        Id OPPId = fslOpportunityId;
        List<WorkOrder> WOs = FSL_Work_Order_View_Controller.getWorkOrders(OPPId);
        Test.startTest();
        String deleteResult = FSL_Work_Order_View_Controller.deleteWorkOrder(WOs[0].Id);
        Test.stopTest();
        System.assert(!deleteResult.contains('error'));
    } 
    @IsTest
    public static void testDebugMode() { 
        Boolean DebugMode = FSL_Work_Order_View_Controller.getDebugMode();
        System.assertNotEquals(null,DebugMode);
    } 
}