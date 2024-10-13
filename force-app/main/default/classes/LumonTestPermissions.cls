/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 10-01-2024
 * @last modified by  : Henk Reynders
**/
@IsTest(isParallel=false)
public with sharing class LumonTestPermissions {
    @TestVisible private static User adminUser{
        get{
            return  [SELECT Id, Name, FirstName, LastName,
                            Alias, UserName,
                            ProfileId, Profile.Name, 
                            UserRoleId,UserRole.Name, 
                            Country, Organization__c, ProfitCenter__c, District__c, Office__c 
                     FROM User WHERE(Alias='admin' OR username='admin.testuser@sandbox.com')];
        }
    }
    @TestVisible private static List<User> testUsers{
        get{
            return  [SELECT Id, Name, FirstName, LastName,
                            Alias, UserName,
                            ProfileId, Profile.Name, 
                             UserRoleId,UserRole.Name, 
                            Country, Organization__c, ProfitCenter__c, District__c, Office__c 
                     FROM User
                     WHERE UserName LIKE '%sandbox%'];
        }
    }
    @testVisible private static List<PermissionSetAssignment> groupAssignments {
        get {
            return [SELECT id, Assignee.alias, AssigneeId, PermissionSetGroupId, PermissionSetId FROM PermissionSetAssignment];
        }
    }
    @testVisible private static List<AutomationBypass__c> bypassSettings {
        get {
            return [SELECT Id, Name,SetupOwnerId, OrgDomain__c, SkipAccountApproval__c, SkipAutomation__c, SkipValidation__c FROM AutomationBypass__c ];
        }
    }
    

    public static Map<String,Id> setupPermissionSetGroups(){
        List<PermissionSet> permissionSetGroups = [SELECT Id,Name, permissionSetGroupId, permissionSetGroup.DeveloperName FROM PermissionSet WHERE Name LIKE 'Lumon%' AND permissionsetgroupId != null];
        Map<String,Id> groupsMap = new Map<String,Id>();
        for (PermissionSet permissionSetGroup : permissionSetGroups) {
            String alias;
            switch on (permissionSetGroup.Name){
                when 'System_Administrator' {
                    groupsMap.put('admin',permissionSetGroup.Id);
                } when 'Lumon_Salesforce_Admin' {
                    groupsMap.put('ladmin',permissionSetGroup.Id);
                } when 'Lumon_Marketing' { 
                    groupsMap.put('lmarket',permissionSetGroup.Id);
                } when 'Lumon_Customer_Service' { 
                    groupsMap.put('lcustom',permissionSetGroup.Id);
                } when 'Lumon_Installer' { 
                    groupsMap.put('linstal',permissionSetGroup.Id);
                } when 'Lumon_Installation_Manager' { 
                    groupsMap.put('lsuper',permissionSetGroup.Id);
                } when 'Lumon_Sales_B2C' { 
                    groupsMap.put('lsalb2c',permissionSetGroup.Id);
                } when 'Lumon_Sales_B2B' { 
                    groupsMap.put('lsalb2b',permissionSetGroup.Id);
                } when 'Lumon_Sales_Manager' { 
                    groupsMap.put('lsalesm',permissionSetGroup.Id);
                } when 'Lumon_ICT_Support' { 
                    groupsMap.put('lictsup',permissionSetGroup.Id);
                } when 'Lumon_Technical_Support' { 
                    groupsMap.put('ltecsup',permissionSetGroup.Id);
                } when 'Lumon_System_Admin' { 
                    groupsMap.put('lsysadm',permissionSetGroup.Id);
                } when else {
                    continue;
                }
            }
        }
        return groupsMap;
    }
    public static void setupUserPermissions(Map<String,Id> groupsMap){       
        List<PermissionSetAssignment> groupAssignmentsToInsert = new List<PermissionSetAssignment>();
        for (User testUser : testUsers) {
            System.debug('--- LumonTestPermissions - setupPermissionAssignments - user Id: '+testUser?.Id);
            System.debug('--- LumonTestPermissions - setupPermissionAssignments - user Alias: '+testUser?.Alias);
            PermissionSetAssignment groupAssignment = new PermissionSetAssignment();
            groupAssignment.AssigneeId = testUser.Id;
            if (groupsMap.containsKey(testUser?.alias)){
                System.debug('--- LumonTestPermissions - setupPermissionAssignments - group: '+groupsMap.get(testUser?.alias));
                groupAssignment.PermissionSetGroupId = groupsMap.get(testUser.alias);
                groupAssignments.add(groupAssignment); 
            }
        }
        if (groupAssignmentsToInsert.size()>0) {
            System.debug('--- LumonTestPermissions - setupPermissionAssignments - '+groupAssignmentsToInsert.size()+' groupAssignments');
            System.RunAs(adminUser) {
                insert groupAssignmentsToInsert;
                System.debug('--- LumonTestPermissions - setupPermissionAssignments - groupAssignments: '+groupAssignmentsToInsert);
            }
            System.debug('--- LumonTestPermissions - setupPermissionAssignments - CPU TIME: '+LIMITS.getCpuTime());
            System.debug('--- LumonTestPermissions - setupPermissionAssignments - SOQL USED: ' + LIMITS.getQueries());
        }
    }
    public static void setupPermissionData(){
        if(testUsers.size()>0) {
            LumonTestUsers.setupUserData();
        }
        Map<String,Id> groupMap = setupPermissionSetGroups();
        if (groupMap.keySet().size()>0) {
            setupUserPermissions(groupMap);
        }
    }
    /********** User Data Tests***********/
    @TestSetup
    public static void prepareData(){
        Test.startTest();
            LumonTestUsers.setupUserData(); // create Users
        Test.stopTest();
    }   

    
    @isTest
    public static void setupPermissionDataTest(){
        String testResult;
        
        Test.startTest();
        try {
            setupPermissionData();
            testResult = 'successfully inserted Permission Assignments';
        } catch (exception e){
            testResult = 'Error when inserting Permission Assignments: '+e.getMessage();
            System.debug('--- LumonTestPermissions - '+testResult);
        }
        System.debug('--- LumonTestPermissions - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestPermissions - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();       
        System.AssertNotEquals(true, testResult.contains('Error'));
    }
}