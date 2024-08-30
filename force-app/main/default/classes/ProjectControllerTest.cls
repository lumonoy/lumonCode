/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-05-2023
 * @last modified by  : Henk Reynders
**/
@IsTest
public with sharing class ProjectControllerTest {
    @TestSetup
    public static void prepareData(){
        Test.startTest();
        LumonTestDataFactory.setupProducts();
        LumonTestDataFactory.setupPrices();
        LumonTestDataFactory.setupAccountB2C();
        LumonTestDataFactory.setupOpportunityB2C();
        Test.stopTest();
    }   
    private static Id b2cAccountId = LumonTestDataFactory.b2cAccountId;
    private static Id b2cOpportunityId = LumonTestDataFactory.b2cOpportunityId;
    @IsTest
    static void getProjectByIdTest(){
        Id  projectId = [SELECT Id, Project_Number__c FROM Opportunity WHERE Id =: b2cOpportunityId LIMIT 1]?.Project_Number__c;
        Test.startTest();
        Project__c prj = ProjectController.getProjectById(projectId);
        System.Debug ('----'+ prj.Name +' Projects Returned');
        System.assertNotEquals(null,prj.name, 'Expected One or More Projects to be returned');
        System.debug('--- getProjectByIdTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getProjectByIdTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
    @IsTest
    static void getProjectsbyRelatedIdTest(){
        Id  projectId = [SELECT Id, Project_Number__c FROM Opportunity WHERE Id =: b2cOpportunityId LIMIT 1]?.Project_Number__c;
        List<Id> projectIds = New List<Id>();
        projectIds.add(projectId);
        Test.startTest();
        List<Project__c> prjs = ProjectController.getProjectsbyIds(projectIds);
        System.Debug ('----'+ prjs.size() +' Projects Returned');
        if (prjs.size()>0){
            System.Debug (prjs);
        }
        System.assertNotEquals(0,prjs.size(), 'Expected One or More Projects to be returned');
        System.debug('--- getProjectsbyRelatedIdTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- getProjectsbyRelatedIdTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    }
}