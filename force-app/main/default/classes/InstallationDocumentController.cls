/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 08-20-2024
 * @last modified by  : Henk Reynders
**/
public with sharing class InstallationDocumentController {
    private final WorkOrderLineItem workOrderLineItem;
    private final Id workOrderLineItemId;

    public InstallationDocumentController(ApexPages.StandardController stdController) {
        this.workOrderLineItem = (WorkOrderLineItem)stdController.getRecord();
        this.workOrderLineItemId = stdController.getId();
    }
    public static WorkOrderLineItem getWorkOrderLineItem(Id woliId){
        return WorkOrderLineItemController.getWorkOrderLineItem(woliId);
    }
    public static String getRemoteFile(WorkOrderLineItem woli){
        return woli.RemoteFile__c;
    }
    public static String getRemoteFolder(WorkOrderLineItem woli){
        return woli.RemoteFolder__c;
    }
    @AuraEnabled(cacheable=true)
    public static List<ContentDocumentLink> getLinkedFiles(Id linkedRecordId){
        System.debug('--- InstallationDocumentController - getLinkedFiles for record '+linkedRecordId);
        List<ContentDocumentLink> linkedFiles = new List<ContentDocumentLink> ();
        linkedFiles = FileController.getLinkedDocuments(linkedRecordId);
        return  linkedFiles;
    }

    @AuraEnabled(cacheable=true)
    public static Id getCurrentVersionByName(List<ContentDocumentLink> linkedFiles, String documentTitle){
        System.debug('--- InstallationDocumentController - getCurrentVersionByName');
        Id versionId = FileController.getDocumentVersionByName(linkedFiles, documentTitle);
        ContentVersion latestVersion = new ContentVersion();
        if (String.IsNotBlank(versionId)){
            latestVersion = FileController.getLatestDocumentVersion(versionId);
        }
        System.debug('--- InstallationDocumentController - getCurrentVersionByName Version '+latestVersion.Id);
        return latestVersion.Id;
    }
    @AuraEnabled
    public static ContentVersion getCurrentVersion(Id versionId){
        System.debug('--- InstallationDocumentController - getCurrentVersion');
        ContentVersion currentVersion = new ContentVersion();
        if (String.IsNotBlank(versionId)){
            currentVersion = FileController.getLatestDocumentVersion(versionId);
        }
        System.debug('--- InstallationDocumentController - getCurrentVersion Version '+currentVersion.Id);
        return currentVersion;
    }
    @AuraEnabled
    public static void uploadInstallationDocument(Id documentId, String content){
        System.debug('--- InstallationDocumentController - uploadInstallationDocument');
        FileController.uploadNewFileVersion(content,documentId);
        //FileController.publishFileControllerEvent( 'upload', documentId, content);
    }  
    @AuraEnabled
    public static String getRemoteContent(List<Id> workOrderLineItemIds){
        List<WorkOrderLineItem> itemsToProcess = new List<WorkOrderLineItem>();
        String base64;
        String frendsEndPoint;
        String apiKey;
        String contentType;
        String integrationName;
        Integration_Credentials__mdt credentials = new Integration_Credentials__mdt();

        itemsToProcess = WorkOrderLineItemController.getWorkOrderLineItems(workOrderLineItemIds);

        Boolean isSandbox = [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
		System.debug('--- InstallationDocumentController - getRemoteContent isSandbox '+isSandbox);
		String envName = 'production';
		if ([SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox) {
			envName = String.valueOf(URL.getOrgDomainUrl()).substringBetween('--', '.sandbox');
			envName = envName.remove('--c');
            System.debug('--- InstallationDocumentController - getRemoteContent envName '+envName);
            switch on envName {
                when 'lumontest' {
                    integrationName = 'frendsAppTest';
                }
                when 'production' {
                    integrationName = 'frendsApp';
                }
                when else {
                    integrationName = 'frendsAppDev'; 
                }
            }
            System.debug('--- InstallationDocumentController - getRemoteContent integration '+integrationName);
            credentials = IntegrationController.getIntegrationCredentials(integrationName);
		}
		
        System.debug('--- InstallationDocumentController - getRemoteContent');
        frendsEndPoint = String.IsNotBlank(credentials.Endpoint__c) ? credentials.Endpoint__c : '';
        apiKey = String.IsNotBlank(credentials.ApiKey__c) ? credentials.ApiKey__c : '';
        contentType = 'application/pdf';
        Integer remotefileCounter = 0;
        for (WorkOrderLineItem itemToProcess : itemsToProcess){
            List<ContentDocumentLink> linkedFiles = new List<ContentDocumentLink>();
            List<ContentVersion> newVersions = new List<ContentVersion> ();
            ContentVersion currentVersion = new ContentVersion();
            Id documentId;
            Id documentVersionId;
            Id currentVersionId;
            HTTP h = new HTTP();
            HTTPRequest request = new HTTPRequest();
            String remoteFile;
            String remoteFolder;
            String endPoint;

            // Step 1 get the Name and Folder
            remotefileCounter++;
            remoteFile = String.isNotBlank(itemToProcess.remoteFile__c) ? itemToProcess.remoteFile__c : '';
            remoteFile = EncodingUtil.urlEncode(remoteFile, 'UTF-8');
            System.debug('--- InstallationDocumentController - getRemoteContent File: '+remoteFile);
            
            remoteFolder = String.isNotBlank(itemToProcess.remoteFolder__c) ? itemToProcess.remoteFolder__c : '';
            System.debug('--- InstallationDocumentController - getRemoteContent Folder: '+remoteFolder);
            remoteFolder = remoteFolder.right(2) == '\\'+'\\' ? remoteFolder = remoteFolder.left(remoteFolder.length()-2) : remoteFolder;
            //remoteFolder = EncodingUtil.urlEncode(remoteFolder, 'UTF-8');
            System.debug('--- InstallationDocumentController - getRemoteContent File: '+remoteFile);
            // Step 2 get the Current Installation Document
            linkedFiles = getLinkedFiles(itemToProcess.Id); 
            System.debug('--- InstallationDocumentController - getRemoteContent Work Order Line Item Files: '+linkedFiles);
            if (String.IsNotBlank(remoteFile)){            
                Integer localFileCounter = 0;
                for (ContentDocumentLink linkedFile : linkedFiles) {
                    localFileCounter++;
                    System.debug('--- InstallationDocumentController - getRemoteContent Linked File '+localFileCounter+': '+linkedFile.Id);
                }
                currentVersionId = getCurrentVersionByName(linkedFiles, remoteFile);
                System.debug('--- InstallationDocumentController - getRemoteContent Current Version: '+currentVersionId);
                currentVersion = getCurrentVersion(currentVersionId);
                System.debug('--- InstallationDocumentController - getRemoteContent Current Version Size: '+currentVersion.ContentSize);
                documentId = currentVersion?.ContentDocumentId;

            }
            // Step 3 get the Latest Installation Document
            if (currentVersion.ContentSize < 10) {
                endPoint = frendsEndPoint+'/getpdf?path='+remoteFolder+'&pdfname='+remoteFile;
                //https://lumon-test-agent.frendsapp.com:9999/getpdf?path=\\269000\\269518&pdfname=salestori-asennuskortti-9000732530014231.pdf'
                System.debug('--- InstallationDocumentController - getRemoteContent EndPoint: '+endPoint);
                if (String.isNotBlank(endPoint)){
                    request.setEndpoint(endPoint);
                    request.setHeader('contentType', contentType);
                    request.setMethod('GET');
                    request.setHeader('x-apikey', apiKey); 
                    HTTPResponse resp = h.send(request); 
                    System.debug('--- InstallationDocumentController - getRemoteContent HTTP Response '+resp);
                    if(resp.getStatusCode()==200){ 
                        base64 = resp.getBody();    
                    }
                    
                    if (base64 != null ) {
                        System.debug('--- InstallationDocumentController - getRemoteContent base64 '+base64);
                        uploadInstallationDocument(currentVersion.ContentDocumentId, base64);
                    }        
                }
            }
        }
        return base64;
    }
}