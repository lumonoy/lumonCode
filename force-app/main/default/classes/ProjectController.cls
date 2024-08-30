public with sharing class ProjectController {
    @AuraEnabled(cacheable=true)
    public static Project__c getProjectById(Id recordId) {
        List<Project__c> projects = New List<Project__c>(); 
        // Find Projects based on recordId
        List<Id> recordIds = new List<Id>();
        recordIds.add(recordId);
        projects = getProjectsByIds(recordIds);
        return projects[0];
    } 
    @AuraEnabled(cacheable=true)
    public static List<Project__c> getProjectsbyIds(List<Id> recordIds) {
        // Populate map from SOQL query on Project__c
        List<Project__c> projects = ([SELECT    Id, 
                                      			Name,
                                                Parent_Project__c,
                                                Project_Category__c,
                                                Project_Group__c,
                                                Project_Number__c,
                                                Stage__c,
                                                Proj_number__c,
                                                Status__c,
                                                Project_Value__c,
                                                Chargeable__c
                                    FROM Project__c 
                                    WHERE Id IN:recordIds
                                    ]);
        System.debug('--- Project__c Record Count : '+projects.size());
        return projects;
    } 
}