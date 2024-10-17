/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 10-02-2024
 * @last modified by  : Henk Reynders
**/
@isTest
public with sharing class LumonTestDataFactory {
    public class CustomException extends Exception {}
    @TestVisible private static Boolean isPersonAccountEnabled{
        get{
            return Schema.SObjectType.Account.fields.getMap().containsKey( 'isPersonAccount' );
        }
    }
    /******** Users *******/
    @TestVisible private static User adminUser = LumonTestUsers.adminUser;
    @TestVisible private static User b2cSalesUser = LumonTestUsers.b2cSalesUser;
    @TestVisible private static User b2bSalesUser = LumonTestUsers.b2bSalesUser;
    @TestVisible private static User salesManagerUser = LumonTestUsers.salesManagerUser;
    @TestVisible private static User installerUser= LumonTestUsers.installerUser;
    @TestVisible private static User installationManagerUser = LumonTestUsers.installationManagerUser;
    /******** User Ids *******/
    @TestVisible private static Id adminUserId = adminUser?.Id;
    @TestVisible private static Id b2cSalesUserId = b2cSalesUser?.Id;
    @TestVisible private static Id b2bSalesUserId = b2bSalesUser?.Id;
    @TestVisible private static Id salesManagerId = salesManagerUser?.Id;
    @TestVisible private static Id installerUserId = installerUser?.Id;
    @TestVisible private static Id installationManagerUserId = installationManagerUser?.Id;
    /****** Sales Record Ids *******/
    @TestVisible private static Id pricebookId =  Test.getStandardPricebookId();
    @TestVisible private static Id b2cLeadId = LumonTestVariables.b2cLeadId;
    @TestVisible private static Id b2bLeadId = LumonTestVariables.b2bLeadId;
    @TestVisible private static Id b2cAccountId = LumonTestVariables.b2cAccountId;
    @TestVisible private static Id b2bAccountId = LumonTestVariables.b2bAccountId;
    @TestVisible private static Id b2bContactId = LumonTestVariables.b2bContactId;
    @TestVisible private static Id b2cOpportunityId = LumonTestVariables.b2cOpportunityId;
    @TestVisible private static Id b2bOpportunityId = LumonTestVariables.b2bOpportunityId;


    /***************** Custom Settings ********************/
    public static void setupProductSettings(){
        LumonTestProductSettings.setupProductSettings();
        System.debug('--- LumonTestDataFactory - setupProductSettings - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupProductSettings - SOQL USED: ' + LIMITS.getQueries());
    }
    public static void setupRoleSettings(){
        LumonTestRoleSettings.setupRoleSettings();
        System.debug('--- LumonTestDataFactory - setupRoleSettings - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupRoleSettings - SOQL USED: ' + LIMITS.getQueries());
    }
    public static void setupCPQSettings(){
        LumonTestCPQSettings.setupCPQSettings();
        System.debug('--- LumonTestDataFactory - setupCPQSettings - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupCPQSettings - SOQL USED: ' + LIMITS.getQueries());
    }
    /***************** Users ********************/
    public static void setupAdmin(){
        LumonTestAdmin.setupAdmin();
        System.debug('--- LumonTestDataFactory - setupAdminUser - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupAdminUser - SOQL USED: ' + LIMITS.getQueries());
    }
    public static void setupUsers(){
        LumonTestUsers.setupUserData();
        System.debug('--- LumonTestDataFactory - setupSalesUser - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupSalesUser - SOQL USED: ' + LIMITS.getQueries());
    }
    /***************** Products ********************/
    public static void setupProducts(){
        LumonTestProducts.setupProductData();
        System.debug('--- LumonTestDataFactory - setupProducts - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupProducts - SOQL USED: ' + LIMITS.getQueries());
    }
    /***************** Lead Times ********************/
	public static void setupProductionTimes() {
        LumonTestProductionTimes.setupProductionTimeData();
        System.debug('--- LumonTestDataFactory - setupProductionTimes - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupProductionTimes - SOQL USED: ' + LIMITS.getQueries());
    }
    public static void setupInstallationTimes() {
        LumonTestInstallationTimes.setupInstallationTimes();
        System.debug('--- LumonTestDataFactory - setupInstallationTimes - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupInstallationTimes - SOQL USED: ' + LIMITS.getQueries());
    }
    /***************** Prices ********************/
    public static void setupPriceParameters(){
        LumonTestPriceParameters.setupPriceParameterData();
        System.debug('--- LumonTestDataFactory - setupPriceParameters - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupPriceParameters - SOQL USED: ' + LIMITS.getQueries());
    }
    /*public static void setupBasePrices(){
        LumonTestBasePrices.setupBasePriceData();
        System.debug('--- LumonTestDataFactory - setupBasePrices - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupBasePrices - SOQL USED: ' + LIMITS.getQueries());
    }*/
    public static void setupPrices(){
        setupPricebooks();
    }
    public static void setupPricebookEntries(){
        setupPricebooks();
    }
    public static void setupPricebooks(){
        LumonTestPricebooks.setupPricebookData();
        System.debug('--- LumonTestDataFactory - setupPricebooks - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupPricebooks - SOQL USED: ' + LIMITS.getQueries());
    }
    /***************** Leads ********************/
    public static void setupLeads(){
        LumonTestLeads.setupLeadData();
        System.debug('--- LumonTestDataFactory - setupLeads - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupLeads - SOQL USED: ' + LIMITS.getQueries());
    }
    /***************** Contacts ********************/
    public static void setupContacts(){
        LumonTestContacts.setupContactData();
        System.debug('--- LumonTestDataFactory - setupContacts - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupContacts - SOQL USED: ' + LIMITS.getQueries());
    }
    /***************** Accounts ********************/
    public static void setupAccounts(){
        setupAccountB2C();
        setupAccountB2B();
        System.debug('--- LumonTestDataFactory - setupAccounts - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupAccounts - SOQL USED: ' + LIMITS.getQueries());
    }
    public static void setupAccountB2C(){
        LumonTestAccounts.setupAccountB2C();
        System.debug('--- LumonTestDataFactory - setupAccountB2C - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupAccountB2C - SOQL USED: ' + LIMITS.getQueries());
    }
    public static void setupAccountB2B(){
        LumonTestAccounts.setupAccountB2B();
        System.debug('--- LumonTestDataFactory - setupAccountB2B - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupAccountB2B - SOQL USED: ' + LIMITS.getQueries());
    }
    /***************** Buildings ********************/
    public static void setupBuildings(){
        setupApartmentBuilding();
        setupSingleHouse();
        System.debug('--- LumonTestDataFactory - setupBuildings - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupBuildings - SOQL USED: ' + LIMITS.getQueries());
    }
    public static void setupApartmentBuilding(){
        LumonTestBuildings.setupApartmentBuilding();
        System.debug('--- LumonTestDataFactory - setupApartmentBuilding - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupApartmentBuilding - SOQL USED: ' + LIMITS.getQueries());
    }
    public static void setupSingleHouse(){
        LumonTestBuildings.setupSingleHouse();
        System.debug('--- LumonTestDataFactory - setupSingleHouse - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupSingleHouse - SOQL USED: ' + LIMITS.getQueries());
    }
    /***************** Apartments ********************/
    
    /***************** Opportunities ********************/
    public static void setupOpportunities(){
        setupOpportunityB2C();
        setupOpportunityB2B();
        System.debug('--- LumonTestDataFactory - setupOpportunities - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupOpportunities - SOQL USED: ' + LIMITS.getQueries());
    }
    public static void setupOpportunityB2C(){
        LumonTestOpportunities.setupOpportunityB2C();
        System.debug('--- LumonTestDataFactory - setupOpportunityB2C - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupOpportunityB2C - SOQL USED: ' + LIMITS.getQueries());
    }
    public static void setupOpportunityB2B(){
        LumonTestOpportunities.setupOpportunityB2B();
        System.debug('--- LumonTestDataFactory - setupOpportunityB2B - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupOpportunityB2B - SOQL USED: ' + LIMITS.getQueries());
    }
    /***************** Quotes ********************/
    public static void setupQuotes(){
        setupQuoteB2C();
        setupQuoteB2B();
        System.debug('--- LumonTestDataFactory - setupQuotes - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupQuotes - SOQL USED: ' + LIMITS.getQueries());
    }
    public static void setupQuoteB2C(){
        LumonTestQuotes.setupQuoteB2C();
        System.debug('--- LumonTestDataFactory - setupQuoteB2C - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupQuoteB2C - SOQL USED: ' + LIMITS.getQueries());
    }
    public static void setupSyncedQuoteB2C(){
        LumonTestQuotes.setupSyncedQuoteB2C();
        System.debug('--- LumonTestDataFactory - setupSyncedQuoteB2C - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupSyncedQuoteB2C - SOQL USED: ' + LIMITS.getQueries());
    }
    public static void setupQuoteB2B(){
        LumonTestQuotes.setupQuoteB2B();
        System.debug('--- LumonTestDataFactory - setupQuoteB2B - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupQuoteB2B - SOQL USED: ' + LIMITS.getQueries());
    }
    public static void setupSyncedQuoteB2B(){
        LumonTestQuotes.setupSyncedQuoteB2B();
        System.debug('--- LumonTestDataFactory - setupSyncedQuoteB2B - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupSyncedQuoteB2B - SOQL USED: ' + LIMITS.getQueries());
    }
    
    /***************** QuoteLines ********************/
    public static void setupSyncedQuoteLineItemsB2C(){
        LumonTestQuoteLines.setupQuoteLineItems();
        System.debug('--- LumonTestDataFactory - setupQuoteLines - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupQuoteLines - SOQL USED: ' + LIMITS.getQueries());
    }
    public static void setupQuoteLines(){
        LumonTestQuoteLines.setupQuoteLineItems();
        System.debug('--- LumonTestDataFactory - setupQuoteLines - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupQuoteLines - SOQL USED: ' + LIMITS.getQueries());
    }
    /***************** Summaries ********************/
    public static void setupPricingSummaryB2C() {
        LumonTestPricingSummaries.setupPricingSummaryB2C();
        System.debug('--- LumonTestDataFactory - setupQuoteLines - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupQuoteLines - SOQL USED: ' + LIMITS.getQueries());
    }
    /***************** Contracts ********************/
        public static void setupContractB2C(){
            LumonTestContracts.setupContractB2C();
            System.debug('--- LumonTestDataFactory - setupContractB2C - CPU TIME: '+LIMITS.getCpuTime());
            System.debug('--- LumonTestDataFactory - setupContractB2C - SOQL USED: ' + LIMITS.getQueries());
        }
    /***************** Orders ********************/
    public static void setupOrderB2C(){
        LumonTestOrders.setupOrderB2C();
        System.debug('--- LumonTestDataFactory - setupOrderB2C - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupOrderB2C - SOQL USED: ' + LIMITS.getQueries());
    }
    public static void setupNormalOrderB2C(){
        LumonTestOrders.setupOrderB2C();
        System.debug('--- LumonTestDataFactory - setupNormalOrderB2C - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupNormalOrderB2C - SOQL USED: ' + LIMITS.getQueries());
    }
    public static void setupSpecialOrderB2C(){
        LumonTestOrders.setupSpecialOrderB2C();
        System.debug('--- LumonTestDataFactory - setupSpecialOrderB2C - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupSpecialOrderB2C - SOQL USED: ' + LIMITS.getQueries());
    }
    public static void setupReclamationOrderB2C(){
        LumonTestOrders.setupReclamationOrderB2C();
        System.debug('--- LumonTestDataFactory - setupReclamationOrderB2C - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupReclamationOrderB2C - SOQL USED: ' + LIMITS.getQueries());
    }
    /***************** OrderLines ********************/
    /*public static void setupOrderItemsB2C() {
        List<OrderItem> orderItems = new List<OrderItem>();
        for (Integer i = 0; i<pricebookEntries.size();i++) {
            OrderItem oi = new OrderItem(OrderId=b2cOrderId,
                                        Product2Id=pricebookEntries[i].Product2Id,
                                        PricebookEntryId=pricebookEntries[i].Id,
                                        Quantity=1,
                                        UnitPrice=1
                                        );
            orderItems.add(oi);
        }
        insert orderItems;
    }*/
    /***************** Cases ********************/
    public static void setupCases(){
        LumonTestCases.setupCaseData();
        System.debug('--- LumonTestDataFactory - setupCases - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupCases - SOQL USED: ' + LIMITS.getQueries());
    }
    /***************** Reclamations ********************/
    public static void setupReclamations(){
        setupReclamationB2C();
        setupReclamationB2B();
        System.debug('--- LumonTestDataFactory - setupReclamations - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupReclamations - SOQL USED: ' + LIMITS.getQueries());
    }
    public static void setupReclamationB2C(){
        LumonTestReclamations.setupReclamationB2C();
        System.debug('--- LumonTestDataFactory - setupReclamationB2C - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupReclamationB2C - SOQL USED: ' + LIMITS.getQueries());
    }
    public static void setupReclamationB2B(){
        LumonTestReclamations.setupReclamationB2B();
        System.debug('--- LumonTestDataFactory - setupReclamationB2B - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupReclamationB2B - SOQL USED: ' + LIMITS.getQueries());
    }    

    /***************** Location Objects ********************/
    public static void setupFactories() {
        LumonTestLocations.setupFactories();
        System.debug('--- LumonTestDataFactory - setupFactories - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupFactories - SOQL USED: ' + LIMITS.getQueries());
    }
    public static void setupWarehouses() {
        LumonTestLocations.setupWarehouses();
        System.debug('--- LumonTestDataFactory - setupWarehouses - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupWarehouses - SOQL USED: ' + LIMITS.getQueries());
    }

    /***************** Configuration ********************/
    public static void setupConfigurations() {
        setupConfigurationPlans();
        setupConfigurationProducts();
        setupConfigurationOptions();
        setupConfigurationMessages();
        System.debug('--- LumonTestDataFactory - setupConfigurations - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupConfigurations - SOQL USED: ' + LIMITS.getQueries());
    }
    public static void setupConfigurationPlans() {
        LumonTestConfigurationPlans.setupConfigurationPlanData();
        System.debug('--- LumonTestDataFactory - setupConfigurationPlans - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupConfigurationPlans - SOQL USED: ' + LIMITS.getQueries());
    }
    public static void setupConfigurationProducts() {
        LumonTestConfigurationProducts.setupConfigurationProductData();
        System.debug('--- LumonTestDataFactory - setupConfigurationProducts - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupConfigurationProducts - SOQL USED: ' + LIMITS.getQueries());
    }
    public static void setupConfigurationOptions() {
        LumonTestConfigurationOptions.setupConfigurationOptionData();
        System.debug('--- LumonTestDataFactory - setupConfigurationOptions - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupConfigurationOptions - SOQL USED: ' + LIMITS.getQueries());
    }
    public static void setupConfigurationMessages() {
        LumonTestConfigurationMessages.setupConfigurationMessageData();
        System.debug('--- LumonTestDataFactory - setupConfigurationMessages - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupConfigurationMessages - SOQL USED: ' + LIMITS.getQueries());
    }
    public static void setupConfigurationFiles() {
        LumonTestConfigurationFiles.setupConfigurationFileData();
        System.debug('--- LumonTestDataFactory - setupConfigurationFiles - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupConfigurationFiles - SOQL USED: ' + LIMITS.getQueries());
    }

    /*public static void setupSalesObjects(){
        System.debug('--- LumonTestDataFactory - Setup B2C PriceRecords at Start - Number of Queries used in this apex code so far: ' + Limits.getQueries());
        Product2 p1 = new Product2(Name='Test Pricing Product 4', IsActive=True,ProductCode='LG',Product_Category__c='Product Groups');
        insert p1;
        Id pbid = Test.getStandardPricebookId();
        PricebookEntry pbe1 = new PricebookEntry(Pricebook2Id=pbid, Product2Id=p1.Id, UnitPrice=1, IsActive=True,CurrencyIsoCode = 'EUR');
        insert pbe1;
        String B2CRecordTypeId= [SELECT Id FROM RecordType WHERE (Name='B2C Account') and (SobjectType='Account')].Id;
        System.debug('--- LumonTestDataFactory - Setup B2C Account Record Types - Number of Queries used in this apex code so far: ' + Limits.getQueries());
        // Create B2C Account
        Account pa1 = new Account(RecordTypeID=B2CRecordTypeId,
                    FirstName='My',
                    LastName='Person Account',
                    PersonEmail='test123@factory.com',
                    PersonMailingCountry ='Finland',
                    PersonMailingCity='Kaupunki',
                    PersonMailingPostalCode = '1234567',
                    PersonMailingStreet='Katu 1');
        insert pa1;
        System.debug('--- LumonTestDataFactory - Setup B2C Opportunity - Number of Queries used in this apex code so far: ' + Limits.getQueries());
        Opportunity o1 = new Opportunity(
                                    Name='B2C Opportunity',
                                    StageName='Quoting',
                                    CloseDate=system.Today()+10,
                                    Pricebook2Id=pbid,
                                    Property_Type__c = 'ROW',
                                    AccountId = pa1.Id
                                    );
        insert o1;
        System.debug('--- LumonTestDataFactory - Setup B2C Quote - Number of Queries used in this apex code so far: ' + Limits.getQueries());
        Quote q1 = new Quote( //Added Non-syncing Quote -> Oppty not updated with this Id as syncedQuoteId
            Name='B2C Standalone Quote',
            Status='Configure',
            Pricebook2Id=pbid,
            OpportunityId=o1.Id
            );
        insert q1;

        Quote quoteToSync = [SELECT Id,IsSyncing,OpportunityId,pricebook2Id FROM Quote WHERE OpportunityId =: o1.Id];
        system.debug ('----B2C Quote To Sync : '+quoteToSync);
        Opportunity opptyToSync = [SELECT Id,SyncedQuoteId,pricebook2Id FROM Opportunity WHERE Id =: o1.Id];
        system.debug ('----B2C Opportunity To Sync : '+opptyToSync);
        if (opptyToSync.syncedQuoteId != quoteToSync.Id || opptyToSync.syncedQuoteId  == Null ) {
            system.debug ('----B2C Opportunity Start Sync');
            opptyToSync.syncedQuoteId = quoteToSync.Id;
            update o1;
        } else {
            system.debug ('----B2C Opportunity Already Syncing');
        }


        List<Quote> quotes = [SELECT Id,IsSyncing,OpportunityId FROM Quote WHERE OpportunityId =: o1.Id]; //Changes made by SAI -> This points to the Synced Quote autocreated by Flow
        system.debug ('----setupQuoteRecords B2C Quotes : '+quotes);
    }*/
/***************** Field Services ********************/
    /*public static void setupFieldServices(){
        // Setup FSL Admin User
        Profile prof = [SELECT Id FROM profile where name='System Administrator'];
        User fslAdmin = new User(
            alias = 'fsladmin',
            email='admin.testuser@fsl123.com',
            emailencodingkey='UTF-8',
            firstname='Dummy',
            lastname='Admin',
            languagelocalekey='en_US',
            localesidkey='en_GB',
            profileId = prof.Id,
            timezonesidkey='Europe/Helsinki',
            username='admin.testuser@fsl123.com'
        );
        insert fslAdmin;
        System.runAs(fslAdmin){
            PermissionSet fslAdminPermissions =[SELECT Id FROM PermissionSet WHERE Name = 'FSL_Admin_Permissions'];
            try {
                insert new PermissionSetAssignment(
                    PermissionSetId = fslAdminPermissions.Id,
                    AssigneeId = UserInfo.getUserId()
                );
            } catch (Exception e){
                System.debug('--- LumonTestDataFactory - FSL Admin Permissions already assigned');
            }
        }
        // Scheduling Policy - this can be extended with additional Work Rules and Objectives
        FSL__Scheduling_Policy__c schedulingPolicy = new FSL__Scheduling_Policy__c();
        schedulingPolicy.Name = 'Test Scheduling Policy';
        insert schedulingPolicy;
        // Operating Hours for availability
        OperatingHours operatingHours1 = new OperatingHours();
        operatingHours1.Name = 'Test Availability Calendar';
        operatingHours1.TimeZone = UserInfo.getTimeZone().getID();
        insert operatingHours1;
        
        // Create time slots for operating hours  
        TimeSlot timeSlot1 = new TimeSlot();
        TimeSlot1.OperatingHoursId = operatingHours1.Id;
        timeSlot1.Type = 'Normal';
        timeSlot1.StartTime = Time.newInstance(08, 00, 00, 0);
        timeSlot1.EndTime = Time.newInstance(17, 00, 00, 0);
        timeSlot1.DayOfWeek = 'Monday';    
		TimeSlot timeSlot2 = new TimeSlot();
        TimeSlot2.OperatingHoursId = operatingHours1.Id;
        timeSlot2.Type = 'Normal';
        timeSlot2.StartTime = Time.newInstance(08, 00, 00, 0);
        timeSlot2.EndTime = Time.newInstance(17, 00, 00, 0);
        timeSlot2.DayOfWeek = 'Tuesday'; 
        TimeSlot timeSlot3 = new TimeSlot();
        TimeSlot3.OperatingHoursId = operatingHours1.Id;
        timeSlot3.Type = 'Normal';
        timeSlot3.StartTime = Time.newInstance(08, 00, 00, 0);
        timeSlot3.EndTime = Time.newInstance(12, 00, 00, 0);
        timeSlot3.DayOfWeek = 'Wednesday'; 
        TimeSlot timeSlot4 = new TimeSlot();
        TimeSlot4.OperatingHoursId = operatingHours1.Id;
        timeSlot4.Type = 'Normal';
        timeSlot4.StartTime = Time.newInstance(08, 00, 00, 0);
        timeSlot4.EndTime = Time.newInstance(17, 00, 00, 0);
        timeSlot4.DayOfWeek = 'Thursday'; 
        TimeSlot timeSlot5 = new TimeSlot();
        TimeSlot5.OperatingHoursId = operatingHours1.Id;
        timeSlot5.Type = 'Normal';
        timeSlot5.StartTime = Time.newInstance(08, 00, 00, 0);
        timeSlot5.EndTime = Time.newInstance(14, 00, 00, 0);
        timeSlot5.DayOfWeek = 'Friday'; 
        insert new List<Timeslot>{timeSlot1,timeSlot2,timeSlot3,timeSlot4,timeSlot5};

        ServiceTerritory serviceTerritory = new ServiceTerritory();
        serviceTerritory.Name = 'Test Service Territory';
        serviceTerritory.Appointment_Booking_Offset__c = 5;
        serviceTerritory.OperatingHoursId = operatingHours1.Id;
        serviceTerritory.IsActive = true;
        insert serviceTerritory;
        
        // Operating Hours for Time Slots
        OperatingHours operatingHours2 = new OperatingHours();
        operatingHours2.Name = 'Test Time Slots Calendar';
        operatingHours2.TimeZone = UserInfo.getTimeZone().getID();
        insert operatingHours2;
        
        // Create time slots for 
        TimeSlot timeSlot_1_1 = new TimeSlot();
        timeSlot_1_1.OperatingHoursId = operatingHours2.Id;
        timeSlot_1_1.Type = 'Normal';
        timeSlot_1_1.StartTime = Time.newInstance(08, 00, 00, 0);
        timeSlot_1_1.EndTime = Time.newInstance(17, 00, 00, 0);
        timeSlot_1_1.DayOfWeek = 'Monday';    
        TimeSlot timeSlot_1_2 = new TimeSlot();
        timeSlot_1_2.OperatingHoursId = operatingHours2.Id;
        timeSlot_1_2.Type = 'Normal';
        timeSlot_1_2.StartTime = Time.newInstance(08, 00, 00, 0);
        timeSlot_1_2.EndTime = Time.newInstance(17, 00, 00, 0);
        timeSlot_1_2.DayOfWeek = 'Tuesday'; 
        TimeSlot timeSlot_1_3 = new TimeSlot();
        timeSlot_1_3.OperatingHoursId = operatingHours2.Id;
        timeSlot_1_3.Type = 'Normal';
        timeSlot_1_3.StartTime = Time.newInstance(08, 00, 00, 0);
        timeSlot_1_3.EndTime = Time.newInstance(12, 00, 00, 0);
        timeSlot_1_3.DayOfWeek = 'Wednesday'; 
        TimeSlot timeSlot_1_4 = new TimeSlot();
        timeSlot_1_4.OperatingHoursId = operatingHours2.Id;
        timeSlot_1_4.Type = 'Normal';
        timeSlot_1_4.StartTime = Time.newInstance(08, 00, 00, 0);
        timeSlot_1_4.EndTime = Time.newInstance(17, 00, 00, 0);
        timeSlot_1_4.DayOfWeek = 'Thursday'; 
        TimeSlot timeSlot_1_5 = new TimeSlot();
        timeSlot_1_5.OperatingHoursId = operatingHours2.Id;
        timeSlot_1_5.Type = 'Normal';
        timeSlot_1_5.StartTime = Time.newInstance(08, 00, 00, 0);
        timeSlot_1_5.EndTime = Time.newInstance(14, 00, 00, 0);
        timeSlot_1_5.DayOfWeek = 'Friday'; 
        insert new List<Timeslot>{timeSlot_1_1,timeSlot_1_2,timeSlot_1_3,timeSlot_1_4,timeSlot_1_5};


  
        Schema.Location installationLocation = new Schema.Location();
        installationLocation.Name = 'Test Installation Location';
        insert installationLocation;
        // Create B2C Account
        setupAccountB2C();
        // Create B2C Opportunity
        setupAccountB2C();

        // Create FSL Opportunity
        Opportunity fslOpportunity = new Opportunity(
        Name = 'Test FSL Opportunity',
        Customer_Segment__c = '1000', 
		StageName='Quoting', 
        CloseDate = System.today().addDays(30), 
		AccountId = b2cAccountId, 
		Delivery_Location__c = installationLocation.Id, 
		Delivery_date__c = System.today().addDays(5));
        insert fslOpportunity;
         
        WorkOrder workOrder = new WorkOrder();
        workOrder.AccountId = b2cAccountId;
        workOrder.Subject = 'Test Work Order';
        workOrder.Opportunity__c = fslOpportunity.Id;
        //workOrder.ContactId; 
        workOrder.LocationId = installationLocation.Id;
        workOrder.Duration = 2;
        workOrder.DurationType = 'Hours';
        workOrder.ServiceTerritoryId = serviceTerritoryId;
        insert workOrder;
        
        ServiceAppointment serviceAppointment = new ServiceAppointment();
        //serviceAppointment.Status; // For Softbooking status is None
        serviceAppointment.EarliestStartTime = Date.today();
        serviceAppointment.DueDate = Date.today().addDays(10);
        serviceAppointment.ServiceTerritoryId = serviceTerritory.Id;
        serviceAppointment.ParentRecordId = workOrder.Id;
        serviceAppointment.Duration = 2;
        insert serviceAppointment;
    // Create user for a field technician resource with the right permission sets
    // Lookup the user that was created in the runAs context
    List<User> users = [SELECT Id, FirstName,LastName, ProfileId ,username FROM User];
    Id InstallerProfile = [SELECT Id FROM Profile WHERE Name ='Lumon Installer']?.Id;
    User installerResource= [SELECT Id, FirstName,LastName FROM User WHERE ProfileId =: InstallerProfile LIMIT 1];

    // Create Service Resource for Installer
    ServiceResource serviceResource = new ServiceResource(
        Name = installerResource.FirstName + ' ' + installerResource.LastName,
        isActive = true,
        IsOptimizationCapable = true, // This is important otherwise the resource is not available for scheduling
        ResourceType = 'T',
        RelatedRecordId = installerResource.Id
    );
    insert serviceResource;
    // Add resource part of the service territory
    insert new ServiceTerritoryMember(
        ServiceTerritoryId = serviceTerritoryId,
        ServiceResourceId = serviceResource.Id,
        TerritoryType = 'P',
        EffectiveStartDate = System.now().addDays(-3)
    );
    // Create Work Type record 
    insert new WorkType(
        Name = 'Maintenance',
        ShouldAutoCreateSvcAppt = true,
        FSL__Due_Date_Offset__c = 60*24*7, // 1 week in minutes
        DurationType = 'Minutes',
        EstimatedDuration = 60
    );
    // Update Opportunity
    //Opportunity fslOpportunity = [SELECT Id, Name, AccountId, Delivery_Location__c, Delivery_date__c, Installation_duration__c  FROM Opportunity WHERE Id =: b2cOpportunityId];
    /*fslOpportunity.Delivery_date__c;
    fslOpportunity.Delivery_Location__c;
    fslOpportunity.Installation_duration__c;
    fslOpportunity.Installation_Location__c;*/
//}*/

/*@IsTest
static void setupMaintenanceServices(){
    
    // Retrieve Work Type Id
    Id wtId = [SELECT Id FROM WorkType where Name = 'Maintenance'].Id;

    // Create Work Order. Service Appointment is created via the Work Type
    WorkOrder wo = new WorkOrder(
        WorkTypeId = wtId,
        Subject = 'Test',
        Street = 'Kerkstraat 2',
        PostalCode = '3581 RD',
        City = 'Utrecht',
        Country = 'NL'
    );
    insert wo;

    // Get the details for getSlots
    OperatingHours oh = [SELECT Id, TimeZone FROM OperatingHours where Name = 'Time Slot Hours'];
    Timezone tz = Timezone.getTimeZone(oh.TimeZone);
    Id spId = [SELECT Id FROM FSL__Scheduling_Policy__c limit 1].Id;
    
    Test.startTest();

    // Lookup the service appointment and retrieve slots
    Id saId = [SELECT Id FROM ServiceAppointment where ParentRecordId = :wo.Id].Id;
    List<FSL.AppointmentBookingSlot> slots = FSL.AppointmentBookingService.getSlots(saId, spId, oh.Id, tz, false);  

    System.debug(slots);

    // Perform the necessary assets!

    Test.stopTest();

    }*/
}