/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 08-25-2024
 * @last modified by  : Henk Reynders
**/
public with sharing class ProjectController {
    @AuraEnabled(cacheable=false)
    public static Building_Project__c getCustomerProject(Id projectId) {
        // Populate List from SOQL query on Building_Project__c
        List<Id> projectIds = new List<Id>();
        projectIds.add(projectId);
        Building_Project__c project = new Building_Project__c();
        System.debug('--- ProjectController - Get Building Project with Id '+projectId); 
        List<Building_Project__c> projects =  getCustomerProjects(projectIds); 
        if  (projects?.size()>0) {
            project = projects[0];
            System.debug('--- ProjectController - Building Project: '+project.Name); 
        }        
        return project;  
    }
    @AuraEnabled(cacheable=false)
    public static Building_Project__c getCustomerProjectByNumber(String projectNumber) {
        // Populate List from SOQL query on Building_Project__c
        Id projectId;// = [SELECT Id FROM Building_Project__c WHERE Project_Number__c =: projectNumber LIMIT 1]?.Id; 
        List<Id> projectIds = new List<Id>();
        projectIds.add(projectId);
        Building_Project__c project = new Building_Project__c();
        System.debug('--- ProjectController - Get Building Project with Id '+projectId); 
        List<Building_Project__c> projects =  getCustomerProjects(projectIds); 
        if  (projects?.size()>0) {
            project = projects[0];
            System.debug('--- ProjectController - Building Project: '+project.Name); 
        }        
        return project;
    }
    @AuraEnabled(cacheable=false)
    public static List<Building_Project__c> getCustomerProjects(List<Id> projectIds) {
        // Populate List from SOQL query on Building_Project__c
        System.debug('--- ProjectController - Get Projects'); 
        List<Building_Project__c> projects = ([  SELECT Id,
                                                        OwnerId, 
                                                        Name, 
                                                        CurrencyIsoCode, 
                                                        CreatedDate, 
                                                        CreatedById, 
                                                        LastModifiedDate, 
                                                        LastModifiedById, 
                                                        ProjectNumber__c,                                                         
                                                        Customer__c, 
                                                        Organization__c,     
                                                        ProfitCenter__c,
                                                        ProjectManager__c,
                                                        SalesManager__c,
                                                        ProjectType__c,
                                                        ProjectStartDate__c,
                                                        ProjectEndDate__c
                                                    FROM Building_Project__c 
                                                    WHERE Id IN: projectIds]);  
        System.debug('--- ProjectController - Building Projects: '+projects.size()); 
        return projects;  
    }
    @AuraEnabled(cacheable=false)
    public static Delivery_Project__c getDeliveryProject(Id projectId) {
        // Populate List from SOQL query on Delivery_Project__c
        List<Id> projectIds = new List<Id>();
        projectIds.add(projectId);
        Delivery_Project__c subProject = new Delivery_Project__c();
        System.debug('--- ProjectController - Get Delivery Project with Id '+projectId); 
        List<Delivery_Project__c> subProjects =  getSubProjects(projectIds); 
        if  (subProjects?.size()>0) {
            subProject = subProjects[0];
            System.debug('--- ProjectController - Delivery Project: '+subProject.Name); 
        }        
        return subProject;  
    }
    @AuraEnabled(cacheable=false)
    public static Delivery_Project__c getDeliveryProjectByNumber(String projectNumber) {
        // Populate List from SOQL query on Delivery_Project__c
        Id projectId;// = [SELECT Id FROM Building_Project__c WHERE Project_Number__c =: projectNumber LIMIT 1]?.Id; 
        List<Id> projectIds = new List<Id>();
        projectIds.add(projectId);
        Delivery_Project__c subProject = new Delivery_Project__c();
        System.debug('--- ProjectController - Get Delivery Project with Id '+projectId); 
        List<Delivery_Project__c> subProjects =  getSubProjects(projectIds); 
        if  (subProjects?.size()>0) {
            subProject = subProjects[0];
            System.debug('--- ProjectController - Delivery Project: '+subProject.Name); 
        }        
        return subProject;
    }
    @AuraEnabled(cacheable=false)
    public static List<Delivery_Project__c> getSubProjects(List<Id> projectIds) {
        // Populate List from SOQL query on Building_Project__c
        System.debug('--- ProjectController - Get Delivery Projects'); 
        List<Delivery_Project__c> subProjects = ([  SELECT Id,
                                                        Name, 
                                                        //ProjectCategory__c, 
                                                        ProjectType__c, 
                                                        ProjectCost__c,
                                                        BuildingProject__c,
                                                        OrderType__c,
                                                        Customer__c, 
                                                        ProjectNumber__c,  
                                                        CustomerAddress__c,                                                         
                                                        InvoicingAddress__c,
                                                        InstallationAddress__c, 
                                                        DeliveryAddress__c,
                                                        Status__c,
                                                        isChargeable__c,
                                                        underWarranty__c            
                                                    FROM Delivery_Project__c 
                                                    WHERE Id IN: projectIds]);  
        System.debug('--- ProjectController - Delivery Projects: '+subProjects.size()); 
        return subProjects;  
    }
}