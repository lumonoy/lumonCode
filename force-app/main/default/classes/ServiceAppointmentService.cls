/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-03-2023
 * @last modified by  : Henk Reynders
**/
public with sharing class ServiceAppointmentService {

    public static void createInstallationPDF(List<ServiceAppointment> newServiceAppointments, Map<Id, ServiceAppointment> oldServiceAppointmentMap) {
        List<ServiceAppointment> serviceAppointments = new List<ServiceAppointment>();
        Set<Id> workOrderIds = new Set<Id>();
        for (ServiceAppointment newServiceAppointment : newServiceAppointments) {
            if ((oldServiceAppointmentMap != null
                    && (newServiceAppointment.Status == 'Dispatched'
                    && newServiceAppointment.LUM_Parent_Work_Order__c!=null
                    && oldServiceAppointmentMap.get(newServiceAppointment.Id).Status != 'Dispatched'))) {
                serviceAppointments.add(newServiceAppointment);
                workOrderIds.add(newServiceAppointment.LUM_Parent_Work_Order__c);
            }
        }
        if (!serviceAppointments.isEmpty() && !workOrderIds.isEmpty()) {
            deletePDFs(workOrderIds);
            createPDFsFuture(JSON.serialize(serviceAppointments),
                    'Installation instructions for products.pdf');
            createWorkOrderLinksForInstallationCard(workOrderIds);
        }
    }
    @Future(callout=true)
    public static void createPDFsFuture(String objectJSON, String pdfName) {
        List<SObject> records = (List<SObject>)JSON.deserialize(objectJSON, List<SObject>.class);
        createPDFs(records, pdfName, false);
    }

    public static void createPDFs(List<SObject> records, String pdfName, Boolean workOrder) {
        Map<Id, ContentVersion> pdfs = new Map<Id, ContentVersion>();
        ContentVersion pdfFile;
        for (SObject record : records) {
            /*String recordName = (String) workOrder.get(nameField);
            String pdfName = String.format(pdfNameFormat, new String[]{
                    recordName
            });*/
            PageReference pdfPage = Page.InstallerPDF;
            if(!workOrder){
                pdfPage.getParameters().put('service-appointment-id', record.Id);
            } else {
                pdfPage.getParameters().put('workorder-id', record.Id);
            }
            pdfFile = new ContentVersion(
                    // Methods defined as TestMethod do not support getContent call
                    VersionData = Test.isRunningTest() ? Blob.valueOf('abcd') : pdfPage.getContentAsPDF(),
                    Title = pdfName.replace('.pdf', ''),
                    PathOnClient = pdfName);
            pdfs.put((Id) record.get('Id'), pdfFile);
            insert pdfFile;
            System.debug('--- pdfFile: '+pdfFile);
        }
        ContentVersion contentVersion = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id = :pdfFile.Id LIMIT 1];
        List<ContentDocumentLink> pdfLinks = new List<ContentDocumentLink>();
        for (SObject record : records) {
            Id linkedEntityId = workOrder ? (Id)record.get('Id') : (Id)record.get('LUM_Parent_Work_Order__c');
            pdfLinks.add(new ContentDocumentLink(
                    LinkedEntityId = linkedEntityId,
                    ContentDocumentId = contentVersion.ContentDocumentId,
                    ShareType = 'V'
            ));
        }
        Database.insert(pdfLinks, false);
    }

    public static void createWorkOrderLinksForInstallationCard(Set<Id> ids) {
        Set<Id> opportunityIds = new Set<Id>();
        Set<Id> configurationIds = new Set<Id>();
        Map<Id, Id> mapOfOppToConfiguration = new Map<Id, Id>();
        Map<Id, Id> mapOfConfigurationToContentDocumentId = new Map<Id, Id>();
        List<WorkOrder> workOrders = [SELECT Id, Opportunity__c FROM WorkOrder WHERE Id IN :ids];
        for (WorkOrder workOrder : workOrders) {
            opportunityIds.add(workOrder.Opportunity__c);
        }
        if (!opportunityIds.isEmpty()) {
            List<Configuration__c> configurations = [SELECT Id, Opportunity__c FROM Configuration__c WHERE Opportunity__c IN :opportunityIds];
            for (Configuration__c configuration : configurations) {
                configurationIds.add(configuration.Id);
                mapOfOppToConfiguration.put(configuration.Opportunity__c, configuration.Id);
            }
        }
        if (!configurationIds.isEmpty()) {
            List<ContentDocumentLink> contentDocumentLinks = [
                    SELECT Id, LinkedEntityId, ContentDocumentId
                    FROM ContentDocumentLink
                    WHERE LinkedEntityId IN :configurationIds
                    AND ContentDocument.Title LIKE 'visual_installation%'
                    LIMIT 10000
            ];
            for (ContentDocumentLink contentDocumentLink : contentDocumentLinks) {
                mapOfConfigurationToContentDocumentId.put(contentDocumentLink.LinkedEntityId, contentDocumentLink.ContentDocumentId);
            }
        }

        List<ContentDocumentLink> contentDocumentLinks = new List<ContentDocumentLink>();
        for (WorkOrder workOrder : workOrders) {
            if (mapOfOppToConfiguration.containsKey(workOrder.Opportunity__c)) {
                Id configurationId = mapOfOppToConfiguration.get(workOrder.Opportunity__c);
                if (mapOfConfigurationToContentDocumentId.containsKey((configurationId))) {
                    Id contentDocumentId = mapOfConfigurationToContentDocumentId.get((configurationId));
                    contentDocumentLinks.add(new ContentDocumentLink(
                            LinkedEntityId = workOrder.Id,
                            ContentDocumentId = contentDocumentId,
                            ShareType = 'V'
                    ));

                }
            }
        }
        Database.insert(contentDocumentLinks, false);
    }
    @AuraEnabled
    public static void deletePDF(Id id){
        deletePDFs(new Set<Id>{id});
    }

    public static void deletePDFs(Set<Id> ids){
        Set<Id> contentDocumentLinkIds = new Set<Id>();
        List<ContentDocumentLink> contentDocumentLinks = [SELECT Id, ContentDocumentId
                                                            FROM ContentDocumentLink WHERE LinkedEntityId IN :ids
                                                                AND ContentDocument.Title
                                                            LIKE 'Installation instructions%' LIMIT 10000];

        for(ContentDocumentLink contentDocumentLink: contentDocumentLinks){
            contentDocumentLinkIds.add(contentDocumentLink.ContentDocumentId);
        }
        if(!contentDocumentLinkIds.isEmpty()){
            delete [SELECT Id FROM ContentDocument WHERE Id IN :contentDocumentLinkIds LIMIT 10000];
        }
    }

    @AuraEnabled
    public static void createPDF(Id id){
        WorkOrder workOrder = [SELECT Id FROM WorkOrder WHERE Id = :id LIMIT 1];
        createPDFs(new List<SObject>{workOrder}, 'Installation instructions for products.pdf', true);
    }
}