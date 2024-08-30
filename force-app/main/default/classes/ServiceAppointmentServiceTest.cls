/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-03-2023
 * @last modified by  : Henk Reynders
**/
@IsTest
private class ServiceAppointmentServiceTest {
	@TestSetup
    public static void prepareData(){
        Test.startTest();
		LumonTestFieldServices.setupFieldServices();  
        Test.stopTest();
    }   
    private static Id accountId = LumonTestFieldServices.fslAccountId;
    private static Id opportunityId = LumonTestFieldServices.fslOpportunityId;
    private static Id serviceTerritoryId = LumonTestFieldServices.serviceTerritoryId;
    private static Id policyId = LumonTestFieldServices.policyId;
	private static Id workOrderId = LumonTestFieldServices.workOrderId;
	private static Id serviceAppointmentId = LumonTestFieldServices.serviceAppointmentId;

    @IsTest
    static void createInstallationPDFStatusChangeTest() {
        ServiceAppointment createdAppointment = [SELECT Id,Status,LUM_Parent_Work_Order__c FROM ServiceAppointment WHERE Id=:serviceAppointmentId];
        System.debug('--- createInstallationPDFStatusChangeTest - New Service Appointment: '+createdAppointment);
        update new ServiceAppointment(Id = serviceAppointmentId, Status = 'Scheduled');
        ServiceAppointment scheduledAppointment = [SELECT Id,Status,LUM_Parent_Work_Order__c FROM ServiceAppointment WHERE Id=:serviceAppointmentId];
        System.debug('--- createInstallationPDFStatusChangeTest - Scheduled Service Appointment: '+scheduledAppointment);
        Test.startTest();
        update new ServiceAppointment(Id = serviceAppointmentId, Status = 'Dispatched');
        ServiceAppointment dispatchedAppointment = [SELECT Id,Status,LUM_Parent_Work_Order__c FROM ServiceAppointment WHERE Id=:serviceAppointmentId];  
        System.debug('--- createInstallationPDFStatusChangeTest - Dispatched Service Appointment: '+dispatchedAppointment);
        Id parentWorkOrderId = dispatchedAppointment.LUM_Parent_Work_Order__c;
        
        // Status Change Triggered by Flow?
        Test.stopTest();
        List<ContentVersion> installerPDFVersions = [SELECT Id,Title,fileType FROM ContentVersion];  
        System.debug('--- createInstallationPDFStatusChangeTest - installerPDFVersions: '+installerPDFVersions);
        System.assertNotEquals(0,installerPDFVersions.size(),'Expected atleast One Installer PDF');      
        List<ContentDocumentLink> installerMessageLinks = [SELECT Id FROM ContentDocumentLink WHERE LinkedEntityId = :parentWorkOrderId];     
		System.debug('--- createInstallationPDFStatusChangeTest - installerMessageLinks: '+installerMessageLinks);
        List<ContentDocumentLink> installerMessageLink = [SELECT Id FROM ContentDocumentLink WHERE LinkedEntityId = :parentWorkOrderId AND  ContentDocument.Title = 'Installation instructions for products'];     
        System.debug('--- createInstallationPDFStatusChangeTest - installerMessageLink: '+installerMessageLink);
        List<ContentDocumentLink> visualPDFLink = [SELECT Id FROM ContentDocumentLink WHERE LinkedEntityId = :parentWorkOrderId AND  ContentDocument.Title = 'Installation instructions for products'];     
        System.debug('--- createInstallationPDFStatusChangeTest - installerPDFVersions: '+installerPDFVersions);
    }

}