/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-01-2023
 * @last modified by  : Henk Reynders
**/
@IsTest(isParallel=false)
public with sharing class LumonTestUsers {
	/********** User Data Records ***********/
    @TestVisible private static Id adminProfileId{
        get{
            return [SELECT Id FROM Profile WHERE Name='System Administrator']?.Id;
        }
    }
    @TestVisible private static User adminUser{
        get{
            return  [SELECT Id, Name, ProfileId, Profile.Name, UserName, UserRoleId,UserRole.Name, Country, Organization__c, Profit_Center__c, District__c, Office__c 
                     FROM User WHERE(username='admin.testuser@email123.com')];
        }
    }
    @TestVisible private static User salesUser{
        get{
            return  [SELECT Id, Name, ProfileId, Profile.Name, UserName, UserRoleId,UserRole.Name, Country, Organization__c, Profit_Center__c, District__c, Office__c 
                     FROM User WHERE(username='sales.testuser@email123.com')];
        }
    }
    @TestVisible private static User salesManagerUser{
        get{
            return  [SELECT Id, Name, ProfileId, Profile.Name, UserName, UserRoleId,UserRole.Name, Country, Organization__c, Profit_Center__c, District__c, Office__c 
                     FROM User WHERE(username='salesmgr.testuser@email123.com')];
        }
    }
    @TestVisible private static User installerUser{
        get{
            return  [SELECT Id, Name, ProfileId, Profile.Name, UserName, UserRoleId,UserRole.Name, Country, Organization__c, Profit_Center__c, District__c, Office__c 
                     FROM User WHERE(username='installer.testuser@email123.com')];
        }
    }
    @TestVisible private static User installationManagerUser{
        get{
            return  [SELECT Id, Name, ProfileId, Profile.Name, UserName, UserRoleId,UserRole.Name, Country, Organization__c, Profit_Center__c, District__c, Office__c 
                     FROM User WHERE(username='installmgr.testuser@email123.com')];
        }
    }
    @TestVisible private static User technicalSupportUser{
        get{
            return  [SELECT Id, Name, ProfileId, Profile.Name, UserName, UserRoleId,UserRole.Name, Country, Organization__c, Profit_Center__c, District__c, Office__c 
                     FROM User WHERE(username='techsupport.testuser@email123.com')];
        }
    }
    @TestVisible private static User customerServiceUser{
        get{
            return  [SELECT Id, Name, ProfileId, Profile.Name, UserName, UserRoleId,UserRole.Name, Country, Organization__c, Profit_Center__c, District__c, Office__c 
                     FROM User WHERE(username='customerService.testuser@email123.com')];
        }
    }
    @TestVisible private static User marketingUser{
        get{
            return  [SELECT Id, Name, ProfileId, Profile.Name, UserName, UserRoleId,UserRole.Name, Country, Organization__c, Profit_Center__c, District__c, Office__c 
                     FROM User WHERE(username='marketing.testuser@email123.com')];
        }
    }
    /********** User Data Setup ***********/
	public static void setupCPQSettingsDefault(){    
    	Id orgId = [SELECT Id FROM Organization].Id;
        // CPQ Settings
        CPQ_Settings__c cpqSettingOrg = new CPQ_Settings__c();
        cpqSettingOrg.Name = 'Organization Setting';
        cpqSettingOrg.SetupOwnerId = orgId;
        cpqSettingOrg.debug__c = false;
        insert cpqSettingOrg;
    }
    public static void setupAdminUser(){
        Profile prof = [SELECT Id FROM profile where name='System Administrator'];
        User adminUser = new User(
            alias = 'admin123',
            email='admin.testuser@email123.com',
            emailencodingkey='UTF-8',
            firstname='Admin',
            lastname='TestUser',
            languagelocalekey='en_US',
            localesidkey='en_GB',
            profileId = prof.Id,
            timezonesidkey='Europe/Helsinki',
            username='admin.testuser@email123.com'
        );
        insert adminUser;
        // Role Settings
        
        Role_Settings__c roleSettingProfile = new Role_Settings__c();
        roleSettingProfile.Name = 'Admin Role Setting';
        roleSettingProfile.SetupOwnerId = prof.Id;
        roleSettingProfile.isAdmin__c = true;
        roleSettingProfile.isSales__c = false;
        roleSettingProfile.isManager__c = false;
        roleSettingProfile.isService__c = false;
        roleSettingProfile.isSupport__c = false;
        roleSettingProfile.isMarketeer__c = false;
        insert roleSettingProfile;
        // CPQ Settings
        CPQ_Settings__c cpqSettingProfile = new CPQ_Settings__c();
        cpqSettingProfile.Name = 'Admin Profile Setting';
        cpqSettingProfile.SetupOwnerId = prof.Id;
        cpqSettingProfile.debug__c = true;
        cpqSettingProfile.maxDiscount__c = 10;
        insert cpqSettingProfile;
        CPQ_Settings__c cpqSettingUser = new CPQ_Settings__c();
        cpqSettingUser.Name = 'Admin User Setting';
        cpqSettingUser.SetupOwnerId = adminUser.Id;
        cpqSettingUser.debug__c = true;
        cpqSettingUser.maxDiscount__c = 100;
        insert cpqSettingUser;
        System.debug('---  setupAdminUser - adminUser: '+adminUser);
        System.debug('---  setupAdminUser - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('---  setupAdminUser - Queries used: '+LIMITS.getQueries());
    }
    public static void setupSalesUser(){
        Organization org = [SELECT Id FROM Organization];
        Profile prof = [SELECT Id FROM profile where name like '%B2C%Sales User'];
        User salesUser = new User(
            alias = 'sales123',
            email='sales.testuser@email123.com',
            emailencodingkey='UTF-8',
            firstname='Sales',
            lastname='TestUser',
            languagelocalekey='en_US',
            localesidkey='en_GB',
            profileId = prof.Id,
            timezonesidkey='Europe/Helsinki',
            username='sales.testuser@email123.com'
        );
        insert salesUser;
        // Role Settings
        Id orgId = [SELECT Id FROM Organization].Id;
        Role_Settings__c roleSettingProfile = new Role_Settings__c();
        roleSettingProfile.Name = 'Sales Role Setting';
        roleSettingProfile.SetupOwnerId = prof.Id;
        roleSettingProfile.isAdmin__c = false;
        roleSettingProfile.isSales__c = true;
        roleSettingProfile.isManager__c = false;
        roleSettingProfile.isService__c = false;
        roleSettingProfile.isSupport__c = false;
        roleSettingProfile.isMarketeer__c = false;
        insert roleSettingProfile;
        // CPQ Settings
        CPQ_Settings__c cpqSettingProfile = new CPQ_Settings__c();
        cpqSettingProfile.Name = 'Sales Profile Setting';
        cpqSettingProfile.SetupOwnerId = prof.Id;
        cpqSettingProfile.debug__c = true;
        insert cpqSettingProfile;
        CPQ_Settings__c cpqSettingUser = new CPQ_Settings__c();
        cpqSettingUser.Name = 'Sales User Setting';
        cpqSettingUser.SetupOwnerId = salesUser.Id;
        cpqSettingUser.maxDiscount__c = 100;
        insert cpqSettingUser;
        System.debug('---  setupSalesUser - salesUser: '+salesUser);
        System.debug('---  setupSalesUser - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('---  setupSalesUser - Queries used: '+LIMITS.getQueries());
    }
    public static void setupSalesManagerUser(){
        Profile prof = [SELECT Id FROM profile where name like '%B2C%Sales User'];
        User salesManager = new User(
            alias = 'salesmgr',
            email='salesmgr.testuser@email123.com',
            emailencodingkey='UTF-8',
            firstname='Salesmgr',
            lastname='TestUser',
            languagelocalekey='en_US',
            localesidkey='en_GB',
            profileId = prof.Id,
            timezonesidkey='Europe/Helsinki',
            username='salesmgr.testuser@email123.com'
        );
        insert salesManager;
        // Role Settings
        Id orgId = [SELECT Id FROM Organization].Id;
        Role_Settings__c roleSettingProfile = new Role_Settings__c();
        roleSettingProfile.Name = 'Manager Role Setting';
        roleSettingProfile.SetupOwnerId = prof.Id;
        roleSettingProfile.isAdmin__c = false;
        roleSettingProfile.isSales__c = false;
        roleSettingProfile.isManager__c = true;
        roleSettingProfile.isService__c = false;
        roleSettingProfile.isSupport__c = false;
        roleSettingProfile.isMarketeer__c = false;
        insert roleSettingProfile;
        // CPQ Settings
        CPQ_Settings__c cpqSettingProfile = new CPQ_Settings__c();
        cpqSettingProfile.Name = 'Sales Manager Profile Setting';
        cpqSettingProfile.SetupOwnerId = prof.Id;
        cpqSettingProfile.debug__c = true;
        insert cpqSettingProfile;
        CPQ_Settings__c cpqSettingUser = new CPQ_Settings__c();
        cpqSettingUser.Name = 'Sales User Setting';
        cpqSettingUser.SetupOwnerId = salesManager.Id;
        cpqSettingUser.maxDiscount__c = 100;
        insert cpqSettingUser;
        System.debug('---  setupSalesManager - salesManager: '+salesManager);
        System.debug('---  setupSalesManager - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('---  setupSalesManager - Queries used: '+LIMITS.getQueries());
    }
    public static void setupInstallerUser(){
        Profile prof = [SELECT Id FROM profile where name='Lumon Installer'];
        User installer = new User(
            alias = 'inst1234',
            email='installer.testuser@email123.com',
            emailencodingkey='UTF-8',
            firstname='Installer',
            lastname='TestUser',
            languagelocalekey='en_US',
            localesidkey='en_GB',
            profileId = prof.Id,
            timezonesidkey='Europe/Helsinki',
            username='installer.testuser@email123.com'
        );
        insert installer;
        // FSL_Resource_Permissions and FSL_Resource_License
        List<PermissionSet> fslPermSets = [
                SELECT Id FROM PermissionSet where Name = 'FSL_Resource_Permissions' OR Name ='FSL_Resource_License'];

        List<PermissionSetAssignment> fslPermSetAssignments = new List<PermissionSetAssignment>();
        for (PermissionSet fslPermSet : fslPermSets){
            fslPermSetAssignments.add(
                new PermissionSetAssignment(
                    PermissionSetId = fslPermSet.Id,
                    AssigneeId = installer.Id
                )
            );
        }
        insert fslPermSetAssignments;
		System.debug('---  setupInstaller - installer: '+installer);
        System.debug('---  setupInstaller - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('---  setupInstaller - Queries used: '+LIMITS.getQueries());
    }
    public static void setupInstallationManagerUser(){
        Profile prof = [SELECT Id FROM profile where name='Lumon Installation Manager'];
        User installationManager = new User(
            alias = 'instMgr',
            email='installmgr.testuser@email123.com',
            emailencodingkey='UTF-8',
            firstname='Installmgr',
            lastname='TestUser',
            languagelocalekey='en_US',
            localesidkey='en_GB',
            profileId = prof.Id,
            timezonesidkey='Europe/Helsinki',
            username='installmgr.testuser@email123.com'
        );
        insert installationManager;
		
        // FSL_Resource_Permissions and FSL_Resource_License
        List<PermissionSet> fslPermSets = [
                SELECT Id FROM PermissionSet where Name = 'FSL_Resource_Permissions' OR Name ='FSL_Resource_License'];

        List<PermissionSetAssignment> fslPermSetAssignments = new List<PermissionSetAssignment>();
        for (PermissionSet fslPermSet : fslPermSets){
            fslPermSetAssignments.add(
                new PermissionSetAssignment(
                    PermissionSetId = fslPermSet.Id,
                    AssigneeId = installationManager.Id
                )
            );
        }
        insert fslPermSetAssignments;
        System.debug('---  setupInstallationManager - installationManager: '+installationManager);
        System.debug('---  setupInstallationManager - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('---  setupInstallationManager - Queries used: '+LIMITS.getQueries());
    }
    public static void setupTechnicalSupportUser(){
        Profile prof = [SELECT Id FROM profile where name='Lumon Technical Support'];
        User technicalSupport = new User(
            alias = 'techSup',
            email='techsupport.testuser@email123.com',
            emailencodingkey='UTF-8',
            firstname='TechSupport',
            lastname='TestUser',
            languagelocalekey='en_US',
            localesidkey='en_GB',
            profileId = prof.Id,
            timezonesidkey='Europe/Helsinki',
            username='techsupport.testuser@email123.com'
        );
        insert technicalSupport;
        // Role Settings
        Id orgId = [SELECT Id FROM Organization].Id;
        Role_Settings__c roleSettingProfile = new Role_Settings__c();
        roleSettingProfile.Name = 'Support Role Setting';
        roleSettingProfile.SetupOwnerId = prof.Id;
        roleSettingProfile.isAdmin__c = false;
        roleSettingProfile.isSales__c = false;
        roleSettingProfile.isManager__c = false;
        roleSettingProfile.isService__c = false;
        roleSettingProfile.isSupport__c = true;
        roleSettingProfile.isMarketeer__c = false;
        insert roleSettingProfile;
        // CPQ Settings
        CPQ_Settings__c cpqSettingProfile = new CPQ_Settings__c();
        cpqSettingProfile.Name = 'Support Profile Setting';
        cpqSettingProfile.SetupOwnerId = prof.Id;
        cpqSettingProfile.debug__c = true;
        insert cpqSettingProfile;
        CPQ_Settings__c cpqSettingUser = new CPQ_Settings__c();
        cpqSettingUser.Name = 'Support User Setting';
        cpqSettingUser.SetupOwnerId = technicalSupport.Id;
        cpqSettingUser.maxDiscount__c = 100;
        insert cpqSettingUser;
		System.debug('---  setupTechnicalSupport - technicalSupport: '+technicalSupport);
        System.debug('---  setupTechnicalSupport - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('---  setupTechnicalSupport - Queries used: '+LIMITS.getQueries());
    }
    public static void setupCustomerServiceUser(){
        Profile prof = [SELECT Id FROM profile where name='Lumon Customer Service'];
        User customerService = new User(
            alias = 'custServ',
            email='customerService.testuser@email123.com',
            emailencodingkey='UTF-8',
            firstname='CustomerService',
            lastname='TestUser',
            languagelocalekey='en_US',
            localesidkey='en_GB',
            profileId = prof.Id,
            timezonesidkey='Europe/Helsinki',
            username='customerservice.testuser@email123.com'
        );
        insert customerService;
        // Role Settings
        Id orgId = [SELECT Id FROM Organization].Id;
        Role_Settings__c roleSettingProfile = new Role_Settings__c();
        roleSettingProfile.Name = 'Service Role Setting';
        roleSettingProfile.SetupOwnerId = prof.Id;
        roleSettingProfile.isAdmin__c = false;
        roleSettingProfile.isSales__c = false;
        roleSettingProfile.isManager__c = false;
        roleSettingProfile.isService__c = true;
        roleSettingProfile.isSupport__c = false;
        roleSettingProfile.isMarketeer__c = false;
        insert roleSettingProfile;
        // CPQ Settings
        CPQ_Settings__c cpqSettingProfile = new CPQ_Settings__c();
        cpqSettingProfile.Name = 'Service Profile Setting';
        cpqSettingProfile.SetupOwnerId = prof.Id;
        cpqSettingProfile.debug__c = true;
        insert cpqSettingProfile;
        CPQ_Settings__c cpqSettingUser = new CPQ_Settings__c();
        cpqSettingUser.Name = 'Service User Setting';
        cpqSettingUser.SetupOwnerId = customerService.Id;
        cpqSettingUser.maxDiscount__c = 0;
        insert cpqSettingUser;
		System.debug('---  setupCustomerService - customerService: '+customerService);
        System.debug('---  setupCustomerService - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('---  setupCustomerService - Queries used: '+LIMITS.getQueries());
    }
    public static void setupMarketingUser(){
        Profile prof = [SELECT Id FROM profile where name='Lumon Marketing User'];
        User marketeer = new User(
            alias = 'market',
            email='marketing.testuser@email123.com',
            emailencodingkey='UTF-8',
            firstname='Marketing',
            lastname='TestUser',
            languagelocalekey='en_US',
            localesidkey='en_GB',
            profileId = prof.Id,
            timezonesidkey='Europe/Helsinki',
            username='marketing.testuser@email123.com'
        );
        insert marketeer;
        // Role Settings
        Id orgId = [SELECT Id FROM Organization].Id;
        Role_Settings__c roleSettingProfile = new Role_Settings__c();
        roleSettingProfile.Name = 'Marketing Role Setting';
        roleSettingProfile.SetupOwnerId = prof.Id;
        roleSettingProfile.isAdmin__c = false;
        roleSettingProfile.isSales__c = false;
        roleSettingProfile.isManager__c = false;
        roleSettingProfile.isService__c = false;
        roleSettingProfile.isSupport__c = false;
        roleSettingProfile.isMarketeer__c = true;
        insert roleSettingProfile;
        // CPQ Settings
        CPQ_Settings__c cpqSettingProfile = new CPQ_Settings__c();
        cpqSettingProfile.Name = 'Marketing Profile Setting';
        cpqSettingProfile.SetupOwnerId = prof.Id;
        cpqSettingProfile.debug__c = true;
        insert cpqSettingProfile;
        CPQ_Settings__c cpqSettingUser = new CPQ_Settings__c();
        cpqSettingUser.Name = 'Marketing User Setting';
        cpqSettingUser.SetupOwnerId = marketeer.Id;
        cpqSettingUser.maxDiscount__c = 100;
        insert cpqSettingUser;
		System.debug('---  setupMarketeer - marketeer: '+marketeer);
        System.debug('---  setupMarketeer - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('---  setupMarketeer - Queries used: '+LIMITS.getQueries());
    }
    /********** User Data Tests***********/
    @IsTest
    static void setupAdminUserTest(){
        String testResult;
        Test.startTest();
        Try {
        	LumonTestUsers.setupAdminUser();
            testResult = 'successfully inserted Admin User';
        } catch (exception e){
            testResult = 'error when inserting Admin User: '+e.getMessage();
        }
        Test.stopTest();
        System.AssertNotEquals(true, testResult.contains('error'));
    }   
    @IsTest
    static void setupSalesUserTest(){
        String testResult;
        Test.startTest();
        Try {
        	LumonTestUsers.setupSalesUser();
            testResult = 'successfully inserted Sales User';
        } catch (exception e){
            testResult = 'error when inserting Sales User: '+e.getMessage();
        }
        Test.stopTest();
        System.AssertNotEquals(true, testResult.contains('error'));
    }  
    @IsTest
    static void setupSalesManagerTest(){
        String testResult;
        Test.startTest();
        Try {
        	LumonTestUsers.setupSalesManagerUser();
            testResult = 'successfully inserted Sales Manager User';
        } catch (exception e){
            testResult = 'error when inserting Sales Manager User: '+e.getMessage();
        }
        Test.stopTest();
        System.AssertNotEquals(true, testResult.contains('error'));
    }  
    @IsTest
    static void setupInstallerUserTest(){
        String testResult;
        Test.startTest();
        Try {
        	LumonTestUsers.setupInstallerUser();
            testResult = 'successfully inserted Installer User';
        } catch (exception e){
            testResult = 'error when inserting Installer User: '+e.getMessage();
        }
        Test.stopTest();
        System.AssertNotEquals(true, testResult.contains('error'));
    }    
    @IsTest
    static void setupInstallationManagerTest(){
        String testResult;
        Test.startTest();
        Try {
        	LumonTestUsers.setupInstallationManagerUser();
            testResult = 'successfully inserted Installation Manager User';
        } catch (exception e){
            testResult = 'error when inserting Installation Manager User: '+e.getMessage();
        }
        Test.stopTest();
        System.AssertNotEquals(true, testResult.contains('error'));
    }    
    @IsTest
    static void setupCustomerServiceTest(){
        String testResult;
        Test.startTest();
        Try {
        	LumonTestUsers.setupCustomerServiceUser();
            testResult = 'successfully inserted Customer Service User';
        } catch (exception e){
            testResult = 'error when inserting Customer Service User: '+e.getMessage();
        }
        Test.stopTest();
        System.AssertNotEquals(true, testResult.contains('error'));
    } 
    @IsTest
    static void setupTechnicalSupportUserTest(){
        String testResult;
        Test.startTest();
        Try {
        	LumonTestUsers.setupTechnicalSupportUser();
            testResult = 'successfully inserted Technical Support User';
        } catch (exception e){
            testResult = 'error when inserting Technical Support User: '+e.getMessage();
        }
        Test.stopTest();
        System.AssertNotEquals(true, testResult.contains('error'));
    }
    @IsTest
    static void setupMarketingUserTest(){
        String testResult;
        Test.startTest();
        Try {
        	LumonTestUsers.setupMarketingUser();
            testResult = 'successfully inserted Marketing User';
        } catch (exception e){
            testResult = 'error when inserting Marketing User: '+e.getMessage();
        }
        Test.stopTest();
        System.AssertNotEquals(true, testResult.contains('error'));
    } 
}