/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 08-20-2024
 * @last modified by  : Henk Reynders
**/
public class FileController {
    @AuraEnabled
    public static List<ContentDocumentLink> getLinkedDocuments(Id linkedRecordId){
        List<ContentDocumentLink> docLinks = new List<ContentDocumentLink> ();
        if (String.isNotBlank(linkedRecordId)) {
            docLinks = [ SELECT ContentDocumentId,                                              
                            ContentDocument.Title, 
                            ContentDocument.FileExtension, 
                            ContentDocument.FileType, 
                            ContentDocument.ContentSize,
                            ContentDocument.LatestPublishedVersionId,
                            ContentDocument.LatestPublishedVersion.Title,
                            ContentDocument.LatestPublishedVersion.VersionData, 
                            ContentDocument.LatestPublishedVersion.PathOnClient,
                            ContentDocument.LatestPublishedVersion.CreatedDate,
                            ContentDocument.LatestPublishedVersion.CreatedBy.Name,
                            LinkedEntityId
                FROM ContentDocumentLink 
                WHERE LinkedEntityId = :linkedRecordId];
        }
        System.debug('--- FileController - getLinkedDocuments '+docLinks.size()+ ' Related Files');  
        return docLinks;
    }
    public static Id getDocumentByName(List<ContentDocumentLink> docLinks, String documentName){
        Id contentDocumentId;
        for (ContentDocumentLink doclink : docLinks){
            if (docLink.ContentDocument.Title == documentName){
                contentDocumentId =  docLink.ContentDocumentId;
            }
        }
        System.debug('--- FileController - getDocumentByName Document: '+contentDocumentId);
        return contentDocumentId;
    }
    public static ContentVersion getDocumentVersion(Id recordId){
        ContentVersion docVersion = new ContentVersion();
        docVersion = [ SELECT Id,                                              
                        Title, 
                        ContentSize,
                        ContentUrl,
                        FileType,
                        FileExtension,
                        CreatedDate,
                        CreatedBy.Name,
                        IsLatest,
                        ReasonForChange,
                        VersionData,
                        ContentDocumentId
                FROM ContentVersion 
                WHERE (Id =: recordId
                    OR ContentDocumentId = :recordId)
                LIMIT 1];
        System.debug('--- FileController - getDocumentVersion Version: '+docVersion.Id);
        return docVersion;
    }
    public static ContentVersion getLatestDocumentVersion(Id recordId){
        ContentVersion docVersion = new ContentVersion();
        docVersion = [ SELECT Id,                                              
                        Title, 
                        ContentSize,
                        ContentUrl,
                        FileType,
                        FileExtension,
                        CreatedDate,
                        CreatedBy.Name,
                        IsLatest,
                        ReasonForChange,
                        VersionData,
                        ContentDocumentId
                FROM ContentVersion 
                WHERE (Id =: recordId
                    OR ContentDocumentId = :recordId)
                    AND IsLatest = true
                LIMIT 1];
        System.debug('--- FileController - getLatestDocumentVersion Version: '+docVersion.Id);
        return docVersion;
    }
    public static Id getDocumentVersionByName(List<ContentDocumentLink> docLinks, String documentName){
        Id contentVersionId;
        for (ContentDocumentLink doclink : docLinks){
            if (docLink.ContentDocument.Title == documentName){
                contentVersionId =  docLink.ContentDocument.LatestPublishedVersionId;
                System.debug('--- FileController - getDocumentVersionByName Match Link: '+doclink);
            } else {
                System.debug('--- FileController - getDocumentVersionByName Other Link: '+doclink);
            }
        }
        System.debug('--- FileController - getDocumentVersionByName Version: '+contentVersionId);
        return contentVersionId;
    }
    public static List<ContentVersion> getDocumentVersions(List<Id> recordIds){
        List<ContentVersion> docVersions = new List<ContentVersion> ();
        docVersions = [ SELECT Id,                                              
                            Title, 
                            ContentSize,
                            ContentUrl,
                            FileType,
                            FileExtension,
                            CreatedDate,
                            CreatedBy.Name,
                            IsLatest,
                            ReasonForChange,
                            VersionData,
                            ContentDocumentId
                FROM ContentVersion 
                WHERE ID IN: recordIds
                    OR ContentDocumentId IN :recordIds];
        System.debug('--- FileController - getDocumentVersions '+docVersions.size()+' Version(s)');
        return docVersions;
    }
    public static Blob getFileContent(Id recordId){
        System.debug('--- FileController - getFileContent for Id: '+recordId);
        ContentVersion contentVersion = getDocumentVersion(recordId);
        return contentVersion.VersionData;
    }
    public static void uploadNewFileVersion(String content, Id documentId){
        String documentTitle;
        ContentVersion latestVersion = getLatestDocumentVersion(documentId);       
        ContentVersion newVersion = new ContentVersion();
        documentTitle = String.isNotBlank(latestVersion.Title) ? latestVersion.Title : 'New Version';
        System.debug('--- FileController - uploadNewFileVersion with Id'+documentId);
        System.debug('--- FileController - uploadNewFileVersion content'+content);
        newVersion.Title = documentTitle;
        newVersion.ContentLocation= 's';
        newVersion.ContentDocumentId = documentId;
        newVersion.PathOnClient= documentTitle;
        newVersion.VersionData = EncodingUtil.base64Decode(content);               
        // Upload new Version
        Database.UpsertResult upsertResult = Database.upsert(newVersion,false);
        
        if (!upsertResult.isSuccess()) {
            List<Database.Error> error = upsertResult.getErrors();
            System.Debug('--- FileController - uploadNewFileVersion Error: '+error[0] );
        }
        System.Debug('--- FileController - uploadNewFileVersion Document Version: '+newVersion.Id );
        // Remove older Versions
        
    }
    @AuraEnabled
    public static Id relateFileToRecord(Id contentVersionId, Id linkedRecordId) {
        Id versionId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :contentVersionId].ContentDocumentId;
        ContentDocumentLink newLink = new ContentDocumentLink(ContentDocumentId = versionId, LinkedEntityId = linkedRecordId);
        insert newLink;
        System.Debug('--- FileController - relateFileToRecord Document Link: '+newLink.Id );
        return newLink.Id;
    }
    @AuraEnabled
    public static void publishFileControllerEvent(  String action, 
                                                    String documentId, 
                                                    String content
                                                    ){
        List<FileControllerEvent__e> fileActionEvents = new List<FileControllerEvent__e>();    
        FileControllerEvent__e  fileActionEvent  = new FileControllerEvent__e ( 
                                                        FileAction__c = action, //upload
                                                        FileDocumentId__c = documentId, //Existing Content Document Id
                                                        FileContent__c = content //Fetched base64 String
                                                        );      
        fileActionEvents.add(fileActionEvent);
        // Call method to publish events
        List<Database.SaveResult> results = EventBus.publish(fileActionEvents);
        // Inspect publishing result for each event
        for (Database.SaveResult sr : results) {
            if (sr.isSuccess()) {
                System.debug('Successfully published event.');
            } else {
                for(Database.Error err : sr.getErrors()) {
                    System.debug('Error returned: ' +
                                err.getStatusCode() +
                                ' - ' +
                                err.getMessage());
                }
            }       
        }
    }
    /// Fluido
    @AuraEnabled(cacheable=true)
    public static FilesWrapper[] getFilesList(Id recordId) {
        FilesWrapper[] filesList = new List<FilesWrapper>{};
            for (ContentDocumentLink link : [
                SELECT
                ContentDocumentId,
                ContentDocument.LatestPublishedVersion.Title,
                ContentDocument.LatestPublishedVersion.CreatedDate,
                ContentDocument.LatestPublishedVersion.CreatedBy.Name
                FROM ContentDocumentLink
                WHERE LinkedEntityId = :recordId
            ]) {
                filesList.add(
                    new FilesWrapper(
                        link.ContentDocumentId,
                        link.ContentDocument.LatestPublishedVersion.Title,
                        link.ContentDocument.LatestPublishedVersion.CreatedBy.Name,
                        Date.valueOf(link.ContentDocument.LatestPublishedVersion.CreatedDate),
                        link.ContentDocument.LatestPublishedVersionId
                    )
                );
            }
        return filesList;
    } 
    
    @AuraEnabled
    public static FileVersionWrapper[] getFileVersionDetails(Id fileId) {
        FileVersionWrapper[] contentversions = new List<FileVersionWrapper>{};
            for (ContentVersion cv : [SELECT id,title,contenturl,createddate, createdby.name, ReasonForChange FROM ContentVersion WHERE ContentDocumentId = :fileId]) {
                contentVersions.add(new FileVersionWrapper(cv.id, cv.title, cv.createdby.name, Date.valueOf(cv.createddate), cv.ReasonForChange,cv.contenturl));
            }
        return contentVersions;
    } 
  
    @AuraEnabled(cacheable=true)
    public static Id  getInstallationCard(Id fileId){
        System.debug('*** fileId ***'+fileId);
        ContentVersion cVer = [SELECT Id,RVN_Number__c,loadPDF__c,Title,ContentDocumentId from ContentVersion where ContentDocumentId = : fileId limit 1];
        System.debug('*** cVer ***'+cVer);
        if(cVer != NULL && cVer.loadPDF__c == FALSE){
            HTTP h = new HTTP();
            HTTPRequest request = new HTTPRequest();
            request.setEndpoint('https://lumon-test-agent.frendsapp.com:9999/getpdf?path=\\269000\\269518&pdfname=salestori-asennuskortti-9000732530014231.pdf');
            request.setHeader('contentType', 'application/json');
            request.setMethod('GET');
            request.setHeader('x-apikey', 'b1061af1-0ab9-44da-9a77-2b260cc62b49'); 
            HTTPResponse resp = h.send(request); 
            System.debug('*** resp ***'+resp);
            if(resp.getStatusCode()==200){ 
                String base64Response = resp.getBody();
                System.debug('*** base64Response ***'+base64Response);
                System.debug('*** base64Response encoded ***'+EncodingUtil.base64Decode(base64Response));
                ContentVersion cv = new ContentVersion();
                cv.Title = cVer.Title;
                cv.ContentLocation= 's';
                cv.ContentDocumentId = cVer.ContentDocumentId;
                cv.PathOnClient= cVer.Title;
                cv.VersionData = EncodingUtil.base64Decode(base64Response);
                upsert cv;
            }
        }
        return cVer.Id;
        
    }
    
    @AuraEnabled(cacheable=false)
    public static void  upsertInstallationCard(String resp, Id fileId){
        System.debug('*** Id ***'+fileId);
        System.debug('*** resp ***'+resp);
        ContentVersion cVer = [SELECT Id,RVN_Number__c,loadPDF__c,ContentDocumentId,Title from ContentVersion where ContentDocumentId = : fileId limit 1];
        if(cVer != NULL && cVer.loadPDF__c == FALSE){
                System.debug('*** response ***'+resp);
                String base64Response = resp;
                
                ContentVersion cv = new ContentVersion();
                cv.Title = cVer.Title;
                cv.ContentLocation= 's';
                cv.ContentDocumentId = cVer.ContentDocumentId;
                cv.PathOnClient= cVer.Title;
                cv.VersionData = EncodingUtil.base64Decode(base64Response);
                Database.upsert(cv,false);
        }
    }
    
    // Wrapper
    public virtual class File{
        @AuraEnabled
        public String id { get; set; }
        @AuraEnabled
        public String title { get; set; }
        @AuraEnabled
        public String createdBy { get; set; }
        @AuraEnabled
        public Date createdDate { get; set; }
        public File(String id, String title, String createdBy, Date createdDate) {
            this.id = id;
            this.title = title;
            this.createdBy = createdBy;
            this.createdDate = createdDate;
        }
    }
    
    public class FilesWrapper extends File{
        @AuraEnabled
        public String latestVersionId { get; set; }
        
        public FilesWrapper(String id, String title, String createdBy, Date createdDate, String latestVersionId) {
           	super(id, title, createdBy, createdDate);
            this.latestVersionId = latestVersionId;
        }
    }
    
    public class FileVersionWrapper extends File{
       	@AuraEnabled
        public String reasonForChange { get; set; }
        @AuraEnabled
        public String contentUrl { get; set; }
        public FileVersionWrapper(String id, String title, String createdBy, Date createdDate, String reasonForChange,string contentUrl) {
           	super(id, title, createdBy, createdDate);
            this.reasonForChange = reasonForChange;
            this.contentUrl=contentUrl;
        }
    } 
    
    @AuraEnabled
    public static Id createContentDocLink(Id contentVersionId, Id recordId) {
        Id docId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :contentVersionId].ContentDocumentId;
        insert new ContentDocumentLink(ContentDocumentId = docId, LinkedEntityId = recordId);
        return docId;
    }
}