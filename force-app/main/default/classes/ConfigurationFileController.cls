/**
 * @description       :  Configuration File Controller to define a common way to Query Configuration related Files
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 11-20-2023
 * @last modified by  : Henk Reynders
**/

public without sharing class ConfigurationFileController {
    /**
    * @description retrieve all Configuration Plan related ContentDocumentLinks 
    * @author Henk Reynders | 11-19-2023 
    * @param recordId 
    * @return List<ContentDocumentLink> 
    **/
    @AuraEnabled(cacheable=true)
    public static List<ContentDocumentLink> getConfigurationFiles(Id recordId){
        List<Configuration__c> configPlans = ConfigurationPlanController.getConfigurationsByRelatedId(recordId);
        List<Id> configIds = new List<Id>(new Map<Id, Configuration__c>(configPlans).keySet()); 
        List<ContentDocumentLink> configurationFileLinks = new List<ContentDocumentLink>();
        // Get pricing file IDs        
        try {
            configurationFileLinks = [ SELECT  ContentDocumentId,                                              
                                                ContentDocument.Title, 
                                                ContentDocument.FileExtension, 
                                                ContentDocument.FileType, 
                                                ContentDocument.LatestPublishedVersionId,
                                                ContentDocument.LatestPublishedVersion.VersionData, 
                                                ContentDocument.LatestPublishedVersion.PathOnClient,
                                                LinkedEntityId
                                        FROM ContentDocumentLink 
                                        WHERE LinkedEntityId IN :configIds];
        } catch(System.QueryException qe) {
            System.debug(qe.getMessage());
        }
        return configurationFileLinks;
    }
    /**
    * @description retrieve all Configuration Plan related ContentDocumentLinks and put them in a Map
    * @author Henk Reynders | 11-19-2023 
    * @param recordId 
    * @return Map<String, ContentDocumentLink> 
    **/
    @AuraEnabled(cacheable=true)
    public static Map<String,ContentDocumentLink> getFileNameToLinkMap(Id recordId){
        List<ContentDocumentLink> configurationFileLinks = getConfigurationFiles(recordId);
        Map<String,ContentDocumentLink> fileNameToLinkMap = new Map<String,ContentDocumentLink>();     
        for (ContentDocumentLink configurationFileLink : configurationFileLinks) {
            String fileName =  configurationFileLink.ContentDocument.LatestPublishedVersion.PathOnClient;
            fileNameToLinkMap.put(fileName, configurationFileLink);
            System.Debug('--- Configuration File: '+fileName);
        }
        return fileNameToLinkMap;
    }
    /**
    * @description retrieve all Configuration Plan related ContentDocumentLinks for Pricing JSONs
    * @author Henk Reynders | 11-19-2023 
    * @param recordId 
    * @return List<ContentDocumentLink> 
    **/
    @AuraEnabled(cacheable=true)
    public static List<ContentDocumentLink> getVisualPricingFiles(Id recordId){
        List<Configuration__c> configPlans = ConfigurationPlanController.getConfigurationsByRelatedId(recordId);
        List<Id> configIds = new List<Id>(new Map<Id, Configuration__c>(configPlans).keySet());
        List<ContentDocumentLink> visualPricingfiles = new List<ContentDocumentLink>();
        // Get pricing file IDs        
        try {
            visualPricingfiles = [ SELECT  ContentDocumentId,                                              
                                            ContentDocument.Title, 
                                            ContentDocument.FileExtension, 
                                            ContentDocument.FileType, 
                                            ContentDocument.LatestPublishedVersionId,
                                            ContentDocument.LatestPublishedVersion.VersionData, 
                                            ContentDocument.LatestPublishedVersion.PathOnClient,
                                            LinkedEntityId
                                    FROM ContentDocumentLink 
                                    WHERE LinkedEntityId IN :configIds
                                    AND ContentDocument.Title Like '%Visual%'
                                    AND ContentDocument.Title Like '%Pric%'
                                    AND ContentDocument.FileType = 'json'];
        } catch(System.QueryException qe) {
            System.debug(qe.getMessage());
        }
        return visualPricingfiles;
    }
    /**
    * @description retrieve all Configuration Plan related ContentDocumentLinks for Structure JSONs
    * @author Henk Reynders | 11-19-2023 
    * @param recordId 
    * @return List<ContentDocumentLink> 
    **/
    @AuraEnabled(cacheable=true)
    public static List<ContentDocumentLink> getVisualStructureFiles(Id recordId){
        List<Configuration__c> configPlans = ConfigurationPlanController.getConfigurationsByRelatedId(recordId);
        List<Id> configIds = new List<Id>(new Map<Id, Configuration__c>(configPlans).keySet());
        List<ContentDocumentLink> visualStructureFiles =  new List<ContentDocumentLink>();
        // Get structure file IDs        
        try { 
            visualStructureFiles = [ SELECT  ContentDocumentId,                                              
                                            ContentDocument.Title, 
                                            ContentDocument.FileExtension, 
                                            ContentDocument.FileType, 
                                            ContentDocument.LatestPublishedVersionId,
                                            ContentDocument.LatestPublishedVersion.VersionData, 
                                            ContentDocument.LatestPublishedVersion.PathOnClient,
                                            LinkedEntityId
                            FROM ContentDocumentLink 
                            WHERE LinkedEntityId IN :configIds
                            AND ContentDocument.Title Like '%Visual%'
                            AND (ContentDocument.Title Like '%Structu%'
                                OR ContentDocument.Title Like '%Output%')
                            AND ContentDocument.FileType = 'json'];
        } catch(System.QueryException qe) {
            System.debug(qe.getMessage());
        }
        return visualStructureFiles;
    }
    /**
    * @description retrieve all Configuration Plan related ContentDocumentLinks for Documentation XMLs
    * @author Henk Reynders | 11-19-2023 
    * @param recordId 
    * @return List<ContentDocumentLink> 
    **/
    @AuraEnabled(cacheable=true)
    public static List<ContentDocumentLink> getVisualDocumentationFiles(String recordId){
        List<Configuration__c> configPlans = ConfigurationPlanController.getConfigurationsByRelatedId(recordId);
        List<Id> configIds = new List<Id>(new Map<Id, Configuration__c>(configPlans).keySet()); 
        List<ContentDocumentLink> visualDocumentationFiles =  new List<ContentDocumentLink>();
        // Get Documentation file IDs        
        try { 
            visualDocumentationFiles = [ SELECT  ContentDocumentId,                                              
                                                    ContentDocument.Title, 
                                                    ContentDocument.FileExtension, 
                                                    ContentDocument.FileType, 
                                                    ContentDocument.LatestPublishedVersionId,
                                                    ContentDocument.LatestPublishedVersion.VersionData, 
                                                    ContentDocument.LatestPublishedVersion.PathOnClient,
                                                    LinkedEntityId
                                        FROM ContentDocumentLink 
                                        WHERE LinkedEntityId IN :configIds
                                        AND ContentDocument.Title Like '%Visual%'
                                        AND (ContentDocument.Title Like '%Structu%'
                                            OR ContentDocument.Title Like '%Output%')
                                        AND ContentDocument.FileType = 'json'];
        } catch(System.QueryException qe) {
            System.debug(qe.getMessage());
        }
        return visualDocumentationFiles;
    }

    //@future (callout=true)
	/*public static String getFileContent (Id contentVersionId) {
        String endpoint = (URL.getOrgDomainURL().toExternalForm() +'/services/data/v58.0/sobjects/ContentVersion/'+contentVersionId+'/VersionData');
        String errorMessage;
        String fileContent;
		Http http = new Http();
		HttpRequest request = new HttpRequest();     
		request.setEndpoint(endpoint);
		request.setMethod('GET');
		request.setHeader('Content-Type', 'application/json;charset=UTF-8');
		request.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
		HttpResponse response = http.send(request);
		System.debug('--- STATUS: ' + response.getStatus());
		if (response.getStatusCode() != 200) {
			System.debug('--- ERROR: ' + response.getBody());
            errorMessage = response.getBody();
		} else {
			System.debug('--- SUCCESS: ' + response.getBody());
            fileContent = response.getBody();		
		}
        return fileContent;
	}*/
}