/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 09-30-2024
 * @last modified by  : Henk Reynders
**/
@IsTest(isParallel=false)
public with sharing class LumonTestUsers {
    @TestVisible public static User adminUser{
        get{
            return  [SELECT Id, Name, FirstName, LastName,
                            ProfileId, Profile.Name, 
                            Alias, UserName,
                            UserRoleId,UserRole.Name, 
                            Country, Organization__c, ProfitCenter__c, District__c, Office__c 
                     FROM User 
                     WHERE(username='admin.testuser@sandbox.com'
                        AND Alias = 'admin') 
                     LIMIT 1];
        }
    }
    @TestVisible public static User b2cSalesUser{
        get{
            return  [SELECT Id, Name, FirstName, LastName,
                            ProfileId, Profile.Name, 
                            Alias, UserName,
                            UserRoleId,UserRole.Name, 
                            Country, Organization__c, ProfitCenter__c, District__c, Office__c 
                     FROM User 
                     WHERE(username='lsalb2c.testuser@sandbox.com'
                        AND Alias = 'lsalb2c') 
                     LIMIT 1];
        }
    }
    @TestVisible public static User b2bSalesUser{
        get{
            return  [SELECT Id, Name, FirstName, LastName,
                            ProfileId, Profile.Name, 
                            Alias, UserName,
                            UserRoleId,UserRole.Name, 
                            Country, Organization__c, ProfitCenter__c, District__c, Office__c 
                     FROM User 
                     WHERE(username='lsalb2b.testuser@sandbox.com'
                        AND Alias = 'lsalb2b') 
                     LIMIT 1];
        }
    }
    @TestVisible public static User salesManagerUser{
        get{
            return  [SELECT Id, Name, FirstName, LastName,
                            ProfileId, Profile.Name, 
                            Alias, UserName,
                            UserRoleId,UserRole.Name, 
                            Country, Organization__c, ProfitCenter__c, District__c, Office__c 
                     FROM User 
                     WHERE(username='lsalesm.testuser@sandbox.com'
                        AND Alias = 'lsalesm') 
                     LIMIT 1];
        }
    }
    @TestVisible public static User installerUser{
        get{
            return  [SELECT Id, Name, FirstName, LastName,
                            ProfileId, Profile.Name, 
                            Alias, UserName,
                            UserRoleId,UserRole.Name, 
                            Country, Organization__c, ProfitCenter__c, District__c, Office__c 
                     FROM User 
                     WHERE(username='linstal.testuser@sandbox.com'
                        AND Alias = 'linstal') 
                     LIMIT 1];
        }
    }
    @TestVisible public static User installationManagerUser{
        get{
            return  [SELECT Id, Name, FirstName, LastName,
                            ProfileId, Profile.Name, 
                            Alias, UserName,
                            UserRoleId,UserRole.Name, 
                            Country, Organization__c, ProfitCenter__c, District__c, Office__c 
                     FROM User 
                     WHERE(username='lsuper.testuser@sandbox.com'
                        AND Alias = 'lsuper') 
                     LIMIT 1];
        }
    }
    @TestVisible public static User customerServiceUser{
        get{
            return  [SELECT Id, Name, FirstName, LastName,
                            ProfileId, Profile.Name, 
                            Alias, UserName,
                            UserRoleId,UserRole.Name, 
                            Country, Organization__c, ProfitCenter__c, District__c, Office__c 
                     FROM User 
                     WHERE(username='lcustom.testuser@sandbox.com'
                        AND Alias = 'lcustom') 
                     LIMIT 1];
        }
    }
    @TestVisible public static User technicalSupportUser{
        get{
            return  [SELECT Id, Name, FirstName, LastName,
                            ProfileId, Profile.Name, 
                            Alias, UserName,
                            UserRoleId,UserRole.Name, 
                            Country, Organization__c, ProfitCenter__c, District__c, Office__c 
                     FROM User 
                     WHERE(username='ltecsup.testuser@sandbox.com'
                        AND Alias = 'ltecsup') 
                     LIMIT 1];
        }
    }
    @TestVisible public static User marketingUser{
        get{
            return  [SELECT Id, Name, FirstName, LastName,
                            ProfileId, Profile.Name, 
                            Alias, UserName,
                            UserRoleId,UserRole.Name, 
                            Country, Organization__c, ProfitCenter__c, District__c, Office__c 
                     FROM User 
                     WHERE(username='lmarket.testuser@sandbox.com'
                        AND Alias = 'lmarket') 
                     LIMIT 1];
        }
    }
    @TestVisible public static User lumonAdminUser{
        get{
            return  [SELECT Id, Name, FirstName, LastName,
                            ProfileId, Profile.Name, 
                            Alias, UserName,
                            UserRoleId,UserRole.Name, 
                            Country, Organization__c, ProfitCenter__c, District__c, Office__c 
                     FROM User 
                     WHERE(username='lsysadm.testuser@sandbox.com'
                        AND Alias = 'lsysadm') 
                     LIMIT 1];
        }
    }
    @TestVisible public static User ictSupportUser{
        get{
            return  [SELECT Id, Name, FirstName, LastName,
                            ProfileId, Profile.Name, 
                            Alias, UserName,
                            UserRoleId,UserRole.Name, 
                            Country, Organization__c, ProfitCenter__c, District__c, Office__c 
                     FROM User 
                     WHERE(username='lictsup.testuser@sandbox.com'
                        AND Alias = 'lictsup') 
                     LIMIT 1];
        }
    }
    @TestVisible public static List<User> testUsers{
        get{
            return  [SELECT Id, Name, FirstName, LastName,
                            Alias, UserName,
                            ProfileId, Profile.Name, 
                            UserRoleId,UserRole.Name, 
                            Country, Organization__c, ProfitCenter__c, District__c, Office__c 
                     FROM User
                     WHERE UserName LIKE '%sandbox%' AND Alias != 'admin'];
        }
    }
    /*********** Custom Settings *************/
    @TestVisible public static AutomationBypass__c automationBypass {
        get {
            return AutomationBypass__c.getInstance();
        }
    }
    public static void setupUser(String profileName, Integer usercount){
        List<Profile> profiles = [SELECT Id,Name FROM Profile WHERE Name Like :  profileName];
        List<User> testUsersToInsert = new List<User>();
        usercount++;
        Integer usercounter = 1;
        for (Integer i = 0; i < usercount; i++) { //
            for (Profile profile : profiles) {
                String alias;
                switch on (profile.Name){
                    when 'Lumon Salesforce Admin' {
                        alias = 'ladmin';
                    } when 'Lumon Marketing' { 
                        alias ='lmarket';
                    } when 'Lumon Customer Service' { 
                        alias ='lcustom';
                    } when 'Lumon Installer' { 
                        alias ='linstal';
                    } when 'Lumon Installation Manager' { 
                        alias ='lsuper';
                    } when 'Lumon Sales B2C' { 
                        alias ='lsalb2c';
                    } when 'Lumon Sales B2B' { 
                        alias ='lsalb2b';
                    } when 'Lumon Sales Manager' { 
                        alias ='lsalesm';
                    } when 'Lumon ICT Support' { 
                        alias ='lictsup';
                    } when 'Lumon Technical Support' { 
                        alias ='ltecsup';
                    } when 'Lumon System Admin' { 
                        alias ='lsysadm';
                    } when else {
                        continue;
                    }                    
                }
                alias = alias +String.ValueOf(usercounter);
                User testUser = new User(Alias = alias
                                        ,Email=alias+'.testuser@mail.me'
                                        ,Emailencodingkey='UTF-8'
                                        ,Firstname=alias
                                        ,Lastname='TestUser'
                                        ,Languagelocalekey='en_US'
                                        ,Localesidkey='en_GB'
                                        ,ProfileId = profile.Id
                                        ,Timezonesidkey='Europe/Helsinki'
                                        ,Username=alias+'.testuser@sandbox.com'
                                        ,IsActive = true
                );
                testUsersToInsert.add(testUser);
                System.debug('--- LumonTestUsers - setupUser  - testUser '+usercounter+': '+testUser);
            }
        }
        if (testUsersToInsert.size()>0) {
            System.RunAs(adminUser) {
                Integer i = 1;
                for (User testUserToInsert : testUsersToInsert) {
                    System.debug('--- LumonTestUsers - setupUser  - testUser to insert'+i+': '+testUserToInsert);
                    i++;
                }
                insert testUsersToInsert;
            }
        }
        System.debug('--- LumonTestUsers - setupUser - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestUsers - setupUser  - SOQL USED: ' + LIMITS.getQueries());
    }
    public static void setupUsers(){
        List<Profile> profiles = [SELECT Id,Name FROM Profile WHERE Name LIKE 'Lumon%'];
        List<User> testUsersToInsert = new List<User>();
        for (Profile profile : profiles) {
            String alias;
            switch on (profile.Name){
                when 'Lumon Salesforce Admin' {
                    alias = 'ladmin';
                } when 'Lumon Marketing' { 
                    alias ='lmarket';
                } when 'Lumon Customer Service' { 
                    alias ='lcustom';
                } when 'Lumon Installer' { 
                    alias ='linstal';
                } when 'Lumon Installation Manager' { 
                    alias ='lsuper';
                } when 'Lumon Sales B2C' { 
                    alias ='lsalb2c';
                } when 'Lumon Sales B2B' { 
                    alias ='lsalb2b';
                } when 'Lumon Sales Manager' { 
                    alias ='lsalesm';
                } when 'Lumon ICT Support' { 
                    alias ='lictsup';
                } when 'Lumon Technical Support' { 
                    alias ='ltecsup';
                } when 'Lumon System Admin' { 
                    alias ='lsysadm';
                } when else {
                    continue;
                }
            }

            User testUser = new User(Alias = alias
                                    ,Email=alias+'.testuser@mail.me'
                                    ,Emailencodingkey='UTF-8'
                                    ,Firstname=alias
                                    ,Lastname='TestUser'
                                    ,Languagelocalekey='en_US'
                                    ,Localesidkey='en_GB'
                                    ,ProfileId = profile.Id
                                    ,Timezonesidkey='Europe/Helsinki'
                                    ,Username=alias+'.testuser@sandbox.com'
                                    ,IsActive = true
            );
            testUsersToInsert.add(testUser);
            System.debug('--- LumonTestUsers - setupUsers - testUser: '+testUser);
        }
        if (testUsersToInsert.size()>0) {
            System.RunAs(adminUser) {
                Integer i = 1;
                for (User testUserToInsert : testUsersToInsert) {
                    System.debug('--- LumonTestUsers - setupUser  - testUser to insert'+i+': '+testUserToInsert);
                    i++;
                }
                insert testUsersToInsert;
            }
        }
        System.debug('--- LumonTestUsers - setupUsers - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestUsers - setupUsers - SOQL USED: ' + LIMITS.getQueries());
    }
    public static void setupUserData(){
        setupUsers();
    }
    
    /********** User Data Tests***********/
    @TestSetup
    public static void prepareData(){
        Test.startTest();
        LumonTestAdmin.setupAdminData();
        LumonTestRoleSettings.setupRoleSettingsForProfiles();
        Test.stopTest();
    }   
    @isTest
    public static void setupUserDataTest(){
        String testResult;
        LumonTestBypassSettings.enableBypassSettingsForAdmin();
        Test.startTest();
        try {
            setupUserData();
            testResult = 'successfully inserted Users';
            for (User newTestUser : testUsers) {
                System.debug('--- LumonTestUsers - User: '+newTestUser);
            }
        } catch (exception e){
            testResult = 'Error when inserting User: '+e.getMessage();
            System.debug('--- LumonTestUsers - '+testResult);
        }
        System.debug('--- LumonTestUsers - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestUsers - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();       
        System.AssertNotEquals(true, testResult.contains('Error'));
    }
    @isTest
    public static void setupUserDataNoBypassTest(){
        String testResult;
        LumonTestBypassSettings.disableBypassSettingsForAdmin();
        Test.startTest();
        try {
            setupUserData();
            testResult = 'successfully inserted Users';
            for (User newTestUser : testUsers) {
                System.debug('--- LumonTestUsers - NoBypass User: '+newTestUser);
            }
        } catch (exception e){
            testResult = 'Error when inserting User: '+e.getMessage();
            System.debug('--- LumonTestUsers - NoBypass '+testResult);
        }
        System.debug('--- LumonTestUsers - NoBypass CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestUsers - NoBypass SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();       
        System.AssertNotEquals(true, testResult.contains('Error'));
    }
    @isTest
    public static void setupUserTest(){
        String testResult;
        Test.startTest();
        try {
            setupUser('Installer',10);
            testResult = 'successfully inserted Users';
            for (User newTestUser : testUsers) {
                System.debug('--- LumonTestUsers - setupUserTest User: '+newTestUser);
            }
        } catch (exception e){
            testResult = 'Error when inserting User: '+e.getMessage();
            System.debug('--- LumonTestUsers - setupUserTest '+testResult);
        }
        System.debug('--- LumonTestUsers - setupUserTest CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestUsers - setupUserTest SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();       
        System.AssertNotEquals(true, testResult.contains('Error'));
    }
}