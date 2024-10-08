/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 06-19-2024
 * @last modified by  : Henk Reynders
**/
@isTest
public with sharing class LumonTestDataFactory {
    /** Determine if person account is enabled in current org **/
    @TestVisible private static Id adminProfileId  {
        get{
            return  LumonTestVariables.adminProfileId;
        }
    }

    @TestVisible private static Id adminUser{
        get{
            return  [SELECT Id FROM User WHERE(username='admin.testuser@email123.com')]?.Id;
        }
    }
    @TestVisible private static Id salesUser{
        get{
            return  [SELECT Id FROM User WHERE(username='sales.testuser@email123.com')]?.Id;
        }
    }
    @TestVisible private static Id salesManager{
        get{
            return  [SELECT Id FROM User WHERE(username='salesmgr.testuser@email123.com')]?.Id;
        }
    }
    @TestVisible private static Id installerUser{
        get{
            return  [SELECT Id FROM User WHERE(username='installer.testuser@email123.com')]?.Id;
        }
    }
    @TestVisible private static Boolean isPersonAccountEnabled{
        get{
            return Schema.SObjectType.Account.fields.getMap().containsKey( 'isPersonAccount' );
        }
    }
    @TestVisible private static Id b2cRecordTypeId{
        get{
            return [SELECT Id FROM RecordType WHERE (IsPersonType = true) AND (SobjectType='Account')]?.Id;
        }
    }
    @TestVisible private static Id b2bRecordTypeId{
        get{
            return [SELECT Id FROM RecordType WHERE (IsPersonType = false) AND (SobjectType='Account')]?.Id;
        }
    }
    @TestVisible private static Id b2cLeadId{
        get{
            return [SELECT Id FROM Lead WHERE (FirstName = 'My' AND LastName = 'Lead' AND Company = null)]?.Id;
        }
    }
    @TestVisible private static Id mcLeadId{
        get{
            return [SELECT Id FROM Lead WHERE (FirstName = 'MC' AND Company = null)]?.Id;
        }
    }
    @TestVisible private static Lead mcLead{
        get{
            return [SELECT Id, Finland_Sync_to_MC__c, Other_Countries_Sync_to_MC__c, Spain_Sync_to_MC__c, 
                            Email_Opt_In__c, Email_Opt_In_Date_Time__c, SMS_Opt_In__c, SMS_Opt_In_Date_Time__c, 
                            HasOptedOutOfEmail,
                            ConvertedContactId, ConvertedAccountId,ConvertedOpportunityId,
                            ConvertedAccount.Finland_Sync_to_MC__pc,  ConvertedAccount.Spain_Sync_to_MC__pc, ConvertedAccount.Other_Countries_Sync_to_MC__pc, 
                            ConvertedAccount.Finland_Sync_to_MC__c,  ConvertedAccount.Spain_Sync_to_MC__c, ConvertedAccount.Other_Countries_Sync_to_MC__c, 
                            ConvertedContact.Finland_Sync_to_MC__c, ConvertedContact.Spain_Sync_to_MC__c, ConvertedContact.Other_Countries_Sync_to_MC__c, 
                            ConvertedOpportunity.Finland_Sync_to_MC__c, ConvertedOpportunity.Spain_Sync_to_MC__c, ConvertedOpportunity.Other_Countries_Sync_to_MC__c, 
                            ConvertedDate
                    FROM Lead WHERE (FirstName = 'MC' AND Company = null) LIMIT 1];
        }
    }
    @TestVisible private static List<Lead> leads{
        get{
            return [SELECT Id, Finland_Sync_to_MC__c, Other_Countries_Sync_to_MC__c, Spain_Sync_to_MC__c, 
                            Email_Opt_In__c, Email_Opt_In_Date_Time__c, SMS_Opt_In__c, SMS_Opt_In_Date_Time__c, 
                            HasOptedOutOfEmail,
                            ConvertedContactId, ConvertedAccountId,ConvertedOpportunityId,
                            ConvertedAccount.Finland_Sync_to_MC__pc,  ConvertedAccount.Spain_Sync_to_MC__pc, ConvertedAccount.Other_Countries_Sync_to_MC__pc, 
                            ConvertedAccount.Finland_Sync_to_MC__c,  ConvertedAccount.Spain_Sync_to_MC__c, ConvertedAccount.Other_Countries_Sync_to_MC__c, 
                            ConvertedContact.Finland_Sync_to_MC__c, ConvertedContact.Spain_Sync_to_MC__c, ConvertedContact.Other_Countries_Sync_to_MC__c, 
                            ConvertedOpportunity.Finland_Sync_to_MC__c, ConvertedOpportunity.Spain_Sync_to_MC__c, ConvertedOpportunity.Other_Countries_Sync_to_MC__c, 
                            ConvertedDate
                    FROM Lead];
        }
    }
    @TestVisible private static Id b2cContactId{
        get{
            return [SELECT Id FROM Contact WHERE (IsPersonAccount = true)]?.Id;
        }
    }
    @TestVisible private static Id b2cAccountId{
        get{
            return [SELECT Id FROM Account WHERE (IsPersonAccount = true)]?.Id;
        }
    }
    @TestVisible private static Id b2bAccountId{
        get{
            return [SELECT Id FROM Account WHERE (IsPersonAccount = false)]?.Id;
        }
    }
    @TestVisible private static List<product2> products{
        get{
            return [SELECT Id,Name,ProductCode,IsActive FROM Product2];
        }
    }
    @TestVisible private static List<product2> productList{
        get{
            return [SELECT Id,Name,ProductCode,IsActive FROM Product2];
        }
    }
    @TestVisible private static Id pricebookId{
        get{
            return Test.getStandardPricebookId();
        }
    }
    @TestVisible private static List<PricebookEntry> pricebookEntries{
        get{
            return [SELECT Id,Name,Product2Id,IsActive FROM PricebookEntry WHERE Pricebook2Id =: pricebookId];
        }
    }
    @TestVisible private static List<Factory_Price__c> factoryMultipliers{
        get{
            return [SELECT Id,Name,Product_Group__c, Cost_Type__c FROM Factory_Price__c];
        }
    }
    @TestVisible private static List<Product_Cost__c> costMultipliers{
        get{
            return [SELECT Id,Name,Product_Group__c, Cost_Type__c FROM Product_Cost__c];
        }
    }
    @TestVisible private static List<Sales_Price__c> priceMultipliers{
        get{
            return [SELECT Id,Name,Product_Group__c, Cost_Type__c FROM Sales_Price__c];
        }
    }
    @TestVisible private static Id b2cOpportunityId{
        get{
            return [SELECT Id,Pricebook2Id,SyncedQuoteId,AccountId FROM Opportunity WHERE (Account.IsPersonAccount = true AND Order_Type__c = 'Normal') LIMIT 1]?.Id;
        }
    }
    @TestVisible private static Id b2cReclamationId{
        get{
            return [SELECT Id,Pricebook2Id,SyncedQuoteId,AccountId FROM Opportunity WHERE (Account.IsPersonAccount = true AND Order_Type__c = 'Reclamation') LIMIT 1]?.Id;
        }
    }
    @TestVisible private static List<Opportunity> b2cOpportunities{
        get{
            return [SELECT Id,Pricebook2Id,SyncedQuoteId,AccountId FROM Opportunity WHERE (Account.IsPersonAccount = true)];
        }
    }
    @TestVisible private static Id b2bOpportunityId{
        get{
            return [SELECT Id,Pricebook2Id,SyncedQuoteId,AccountId FROM Opportunity WHERE (Account.IsPersonAccount = false) LIMIT 1]?.Id;
        }
    }
    @TestVisible private static List<Opportunity> b2bOpportunities{
        get{
            return [SELECT Id,Pricebook2Id,SyncedQuoteId,AccountId FROM Opportunity WHERE (Account.IsPersonAccount = false)];
        }
    }
    @TestVisible private static List<Opportunity> opportunities{
        get{
            return [SELECT Id,Pricebook2Id,SyncedQuoteId,AccountId FROM Opportunity];
        }
    }
    @TestVisible private static Id b2cQuoteId{
        get{
            return [SELECT Id FROM Quote WHERE (Account.IsPersonAccount = true AND OpportunityId =: b2cOpportunityId AND IsSyncing = false) LIMIT 1]?.Id;
        }
    }
    @TestVisible private static Id b2cSyncedQuoteId{
        get{
            return [SELECT Id, isSyncing, OpportunityId FROM Quote WHERE (Account.IsPersonAccount = true AND OpportunityId =: b2cOpportunityId AND IsSyncing = true)]?.Id;
        }
    }
    @TestVisible private static List<Quote> b2cQuotes{
        get{
            return [SELECT Id,Name,OpportunityId,IsSyncing FROM Quote WHERE (Account.IsPersonAccount = true AND OpportunityId =: b2cOpportunityId AND IsSyncing = false)];
        }
    }
    @TestVisible private static Id b2bQuoteId{
        get{
            return [SELECT Id FROM Quote WHERE (Account.IsPersonAccount = false AND OpportunityId =: b2bOpportunityId AND IsSyncing = false) LIMIT 1]?.Id;
        }
    }
    /*@TestVisible private static Id b2bSyncedQuoteId{
        get{
            return [SELECT Id,isSyncing, OpportunityId  FROM Quote WHERE (Account.IsPersonAccount = false AND OpportunityId =: b2bOpportunityId AND IsSyncing = true)]?.Id;
        }
    }*/
    @TestVisible private static Id b2bSyncedQuoteId{
        get{
            return [SELECT Id,SyncedQuoteId  FROM Opportunity WHERE (Id =: b2bOpportunityId)]?.SyncedQuoteId;
        }
    }
    @TestVisible private static List<Quote> b2bQuotes{
        get{
            return [SELECT Id,Name,OpportunityId,IsSyncing FROM Quote WHERE (Account.IsPersonAccount = false AND OpportunityId =: b2bOpportunityId AND IsSyncing = false)];
        }
    }
    @TestVisible private static Id b2cContractId{
        get{
            return [SELECT Id FROM Contract WHERE (AccountId=: b2cAccountId) LIMIT 1]?.Id;
        }
    }
    @TestVisible private static Id b2cOrderId{
        get{
            return [SELECT Id FROM Order WHERE (OpportunityId =: b2cOpportunityId) LIMIT 1]?.Id;
        }
    }
    @TestVisible private static List<Installation_Time__c> installationTimes{
        get{
            return [SELECT Id,Product__c, Hours__c,Minutes__c,IsActive__c FROM Installation_Time__c WHERE (IsActive__c = true)];
        }
    }
    @TestVisible private static List<Production_Time__c> productionTimes{
        get{
            return [SELECT Id,Product__c, Days__c,Extra_Days__c,IsActive__c FROM Production_Time__c WHERE (IsActive__c = true)];
        }
    }
    @TestVisible private static Id installableProductId{
        get{
            return [SELECT Id FROM Product2 WHERE (Installation__c = true)]?.Id;
        }
    }
    @TestVisible private static Id reclamationProductId{
        get{
            return [SELECT Id FROM Product2 WHERE (Reclamation__c = true)]?.Id;
        }
    }
    @TestVisible private static Id visualProductId{
        get{
            return [SELECT Id FROM Product2 WHERE (Sovelia__c = true)]?.Id;
        }
    }
    @TestVisible private static Id soveliaProductId{
        get{
            return [SELECT Id FROM Product2 WHERE (Visual__c = true)]?.Id;
        }
    }
    @TestVisible private static Id b2cImageDocumentVersionId{
        get{
            return [SELECT Id FROM ContentVersion WHERE (Title = 'Picture')]?.Id;
        }
    }
    @TestVisible private static Id b2cPricingDocumentVersionId{
        get{
            return [SELECT Id FROM ContentVersion WHERE (Title = 'Visual Pricing')]?.Id;
        }
    }
    @TestVisible private static Id b2cConfigurationPlanId{
        get{
            return LumonTestVariables.b2cConfigurationPlanId;
        }
    }
    @TestVisible private static List<ContentDocumentLink> b2cConfigurationFiles{
        get{
            return LumonTestVariables.b2cConfigurationFiles;
        }
    }
    @TestVisible private static List<QuoteLineItem> b2cQuoteLineItems{
        get{
            return [SELECT Id,QuoteId,PricebookEntryId,Product2Id,UnitPrice FROM QuoteLineItem WHERE QuoteId =: b2cQuoteId];
        }
    }
    @TestVisible private static List<QuoteLineItem> b2cSyncedQuoteLineItems{
        get{
            return [SELECT Id,QuoteId,PricebookEntryId,Product2Id,UnitPrice FROM QuoteLineItem WHERE QuoteId =: b2cSyncedQuoteId];
        }
    }
    @TestVisible private static List<QuoteLineItem> b2bQuoteLineItems{
        get{
            return [SELECT Id,Product2Id,UnitPrice FROM QuoteLineItem WHERE QuoteId =: b2bQuoteId];
        }
    }
    @TestVisible private static List<QuoteLineItem> b2bSyncedQuoteLineItems{
        get{
            return [SELECT Id,Product2Id,UnitPrice FROM QuoteLineItem WHERE QuoteId =: b2bSyncedQuoteId];
        }
    }
    @TestVisible private static Id serviceTerritoryId{
        get{
            return [SELECT Id,Name,Appointment_Booking_Offset__c,OperatingHoursId,IsActive FROM ServiceTerritory LIMIT 1]?.Id;
        }
    }   
    @TestVisible private static Id policyId{
        get{
            return  [SELECT Id,Name FROM FSL__Scheduling_Policy__c LIMIT 1]?.Id;
        }
    }
    @TestVisible private static Id workOrderId{
        get{
            return  [SELECT Id,Subject, WorkOrderNumber,AccountId,ContactId,CaseId,EntitlementId,ServiceContractId,AssetId,RootWorkOrderId,WorkTypeId,ServiceTerritoryId,StatusCategory,Opportunity__c FROM WorkOrder LIMIT 1]?.Id;
        }
    }
    @TestVisible private static Id serviceAppointmentId{
        get{
            return [SELECT Id,Status,EarliestStartTime,DueDate ,ServiceTerritoryId,ParentRecordId FROM ServiceAppointment LIMIT 1]?.Id;
        }
    }
    @TestVisible private static Id b2cConfiguration{
        get{
            return [SELECT Id, Opportunity__c, Quote__c FROM Configuration__c WHERE (Opportunity__c =: b2cOpportunityId AND Quote__c =:b2cSyncedQuoteId) LIMIT 1]?.Id;
        }
    }
    @TestVisible private static List<Configuration__c> b2cConfigurations{
        get{
            return LumonTestVariables.b2cConfigurations;
        }
    }
    @TestVisible private static List<Configuration_Product__c> b2cConfigProducts{
        get{
            return LumonTestVariables.b2cConfigProducts;
        }
    }
    @TestVisible private static List<Configuration_Option__c> b2cConfigOptions{
        get{
            return LumonTestVariables.b2cConfigOptions;
        }
    }
    @TestVisible private static List<Configuration_Message__c> b2cConfigMessages{
        get{
            return LumonTestVariables.b2cConfigMessages;
        }
    }
    @TestVisible private static Pricing_Summary__c b2cPricingSummary{
        get{
            return  [SELECT Id FROM Pricing_Summary__c WHERE(Opportunity__c = :b2cOpportunityId) LIMIT 1];
        }
    }
    @TestVisible private static List<Pricing_Summary__c> b2cPricingSummaries{
        get{
            return  [SELECT Id FROM Pricing_Summary__c WHERE(Opportunity__c = :b2cOpportunityId)];
        }
    }
    @TestVisible private static List<Order> b2cOrders{
        get{
            return [SELECT Id,Pricebook2Id, QuoteId, OpportunityId,AccountId  FROM Order WHERE (Account.IsPersonAccount = true AND OpportunityId =: b2cOpportunityId)];
        }
    }

    /***************** Custom Settings ********************/
    public static void setupProductSettings(){
        LumonTestProductSettings.setupProductSettings();
        System.debug('--- LumonTestDataFactory - setupProductSettings - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupProductSettings - Queries used: '+LIMITS.getQueries());
    }
    public static void setupRoleSettings(){
        LumonTestRoleSettings.setupRoleSettings();
        System.debug('--- LumonTestDataFactory - setupRoleSettings - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupRoleSettings - Queries used: '+LIMITS.getQueries());
    }
    public static void setupCPQSettings(){
        LumonTestCPQSettings.setupCPQSettings();
        System.debug('--- LumonTestDataFactory - setupCPQSettings - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupCPQSettings - Queries used: '+LIMITS.getQueries());
    }
    /***************** Users ********************/
    public static void setupAdminUser(){
        LumonTestUsers.setupAdminUser();
        System.debug('--- LumonTestDataFactory - setupAdminUser - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupAdminUser - Queries used: '+LIMITS.getQueries());
    }
    public static void setupSalesUser(){
        LumonTestUsers.setupSalesUser();
        System.debug('--- LumonTestDataFactory - setupSalesUser - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupSalesUser - Queries used: '+LIMITS.getQueries());
    }
    public static void setupSalesManager(){
        LumonTestUsers.setupSalesManagerUser();
        System.debug('--- LumonTestDataFactory - setupSalesManager - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupSalesManager - Queries used: '+LIMITS.getQueries());
    }
    public static void setupInstaller(){
        LumonTestUsers.setupInstallerUser();
        System.debug('--- LumonTestDataFactory - setupInstaller - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupInstaller - Queries used: '+LIMITS.getQueries());
    }
    public static void setupInstallationManager(){
        LumonTestUsers.setupInstallationManagerUser();
        System.debug('--- LumonTestDataFactory - setupInstallationManager - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupInstallationManager - Queries used: '+LIMITS.getQueries());
    }
    /***************** Products ********************/
    public static void setupProducts(){
        LumonTestProducts.setupProductData();
        System.debug('--- LumonTestDataFactory - setupProducts - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupProducts - Queries used: '+LIMITS.getQueries());
    }
    /***************** Lead Times ********************/
	public static void setupProductionTimes() {
        LumonTestProductionTimes.setupProductionTimeData();
        System.debug('--- LumonTestDataFactory - setupProductionTimes - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupProductionTimes - Queries used: '+LIMITS.getQueries());
    }
    public static void setupInstallationTimes() {
        LumonTestInstallationTimes.setupInstallationTimes();
        System.debug('--- LumonTestDataFactory - setupInstallationTimes - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupInstallationTimes - Queries used: '+LIMITS.getQueries());
    }
    /***************** Prices ********************/
    public static void setupPriceParameters(){
        setupPriceMultipliers();
    }
    public static void setupPriceMultipliers(){
        LumonTestPriceMultipliers.setupPriceMultiplierData();
        System.debug('--- LumonTestDataFactory - setupPriceMultipliers - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupPriceMultipliers - Queries used: '+LIMITS.getQueries());
    }
    public static void setupBasePrices(){
        LumonTestBasePrices.setupBasePriceData();
        System.debug('--- LumonTestDataFactory - setupBasePrices - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupBasePrices - Queries used: '+LIMITS.getQueries());
    }
    public static void setupPrices(){
        setupPricebooks();
    }
    public static void setupPricebookEntries(){
        setupPricebooks();
    }
    public static void setupPricebooks(){
        LumonTestPricebooks.setupPricebookData();
        System.debug('--- LumonTestDataFactory - setupPricebooks - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupPricebooks - Queries used: '+LIMITS.getQueries());
    }
/***************** Leads ********************/
    public static void setupLeadB2C(){
        RecordType leadB2C = [SELECT Id FROM RecordType WHERE Name = 'B2C Lead' LIMIT 1];
        Lead lead1 = new Lead(RecordTypeId = leadB2C.Id, FirstName = 'My',
                                    LastName = 'Lead',
									MobilePhone = '+34800500500', 
                                    PostalCode = '01740', Country = 'Finland', 
                                    City = 'Vantaa',Street = 'Vanha Kalliosolantie 10',
                                    Business_Type__c = 'Consumer', Property_Type__c = 'COT',
                                    Customer_Segment__c = '1100');
        insert lead1;
        System.debug('--- LumonTestDataFactory - setupLeadB2C - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupLeadB2C - Queries used: '+LIMITS.getQueries());
    }
    @future public static void setupLeadMC(){
        RecordType leadB2C = [SELECT Id FROM RecordType WHERE Name = 'B2C Lead' LIMIT 1];
        Lead lead2 = new Lead(RecordTypeId = leadB2C.Id, 
                                    FirstName = 'MC',
                                    LastName = 'Lead',
									MobilePhone = '+3581501500', 
                                    PostalCode = '01740', 
                                    Country = 'Finland', 
                                    CountryCode = 'FI',
                                    Street = 'Vanha Kalliosolantie 10',
                                    City = 'Vantaa',
                                    Business_Type__c = 'Consumer', 
                                    Property_Type__c = 'COT',
                                    Customer_Segment__c = '1100');
        insert lead2;
        System.debug('--- LumonTestDataFactory - setupLeadMC - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupLeadMC - Queries used: '+LIMITS.getQueries()); 
    }
    /***************** Contacts ********************/
    public static void setupContactB2C(){
        LumonTestContacts.setupContactData();
        System.debug('--- LumonTestDataFactory - setupContacts - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupContacts - Queries used: '+LIMITS.getQueries());
    }
    public static void setupContacts(){
        LumonTestContacts.setupContactData();
        System.debug('--- LumonTestDataFactory - setupContacts - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupContacts - Queries used: '+LIMITS.getQueries());
    }
    /***************** Accounts ********************/
    public static void setupAccountB2C(){
        LumonTestAccounts.setupAccountB2C();
        System.debug('--- LumonTestDataFactory - setupAccountB2C - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupAccountB2C - Queries used: '+LIMITS.getQueries());
    }
    public static void setupAccountB2B(){
        LumonTestAccounts.setupAccountB2B();
        System.debug('--- LumonTestDataFactory - setupAccountB2B - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupAccountB2B - Queries used: '+LIMITS.getQueries());
    }
    /***************** Opportunities ********************/
    public static void setupOpportunityB2C(){
        LumonTestOpportunities.setupOpportunityB2C();
        System.debug('--- LumonTestDataFactory - setupOpportunityB2C - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupOpportunityB2C - Queries used: '+LIMITS.getQueries());
    }
    public static void setupOpportunityB2B(){
        LumonTestOpportunities.setupOpportunityB2B();
        System.debug('--- LumonTestDataFactory - setupOpportunityB2B - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupOpportunityB2B - Queries used: '+LIMITS.getQueries());
    }
    /***************** Quotes ********************/
    public static void setupQuoteB2C(){
        LumonTestQuotes.setupQuoteB2C();
        System.debug('--- LumonTestDataFactory - setupQuoteB2C - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupQuoteB2C - Queries used: '+LIMITS.getQueries());
    }
    public static void setupSyncedQuoteB2C(){
        LumonTestQuotes.setupSyncedQuoteB2C();
        System.debug('--- LumonTestDataFactory - setupSyncedQuoteB2C - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupSyncedQuoteB2C - Queries used: '+LIMITS.getQueries());
    }
    public static void setupQuoteB2B(){
        LumonTestQuotes.setupQuoteB2B();
        System.debug('--- LumonTestDataFactory - setupQuoteB2B - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupQuoteB2B - Queries used: '+LIMITS.getQueries());
    }
    public static void setupSyncedQuoteB2B(){
        LumonTestQuotes.setupSyncedQuoteB2B();
        System.debug('--- LumonTestDataFactory - setupSyncedQuoteB2B - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupSyncedQuoteB2B - Queries used: '+LIMITS.getQueries());
    }
    
    /***************** QuoteLines ********************/
    public static void setupSyncedQuoteLineItemsB2C(){
        LumonTestQuoteLines.setupQuoteLineItems();
        System.debug('--- LumonTestDataFactory - setupQuoteLines - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupQuoteLines - Queries used: '+LIMITS.getQueries());
    }
    public static void setupQuoteLines(){
        LumonTestQuoteLines.setupQuoteLineItems();
        System.debug('--- LumonTestDataFactory - setupQuoteLines - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupQuoteLines - Queries used: '+LIMITS.getQueries());
    }
    /***************** Summaries ********************/
    public static void setupPricingSummaryB2C() {
        LumonTestPricingSummaries.setupPricingSummaryB2C();
        System.debug('--- LumonTestDataFactory - setupQuoteLines - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupQuoteLines - Queries used: '+LIMITS.getQueries());
    }
    /***************** Contracts ********************/
        public static void setupContractB2C(){
            LumonTestContracts.setupContractB2C();
            System.debug('--- LumonTestDataFactory - setupContractB2C - CPU TIME: '+LIMITS.getCpuTime());
            System.debug('--- LumonTestDataFactory - setupContractB2C - Queries used: '+LIMITS.getQueries());
        }
    /***************** Orders ********************/
    public static void setupOrderB2C(){
        LumonTestOrders.setupOrderB2C();
        System.debug('--- LumonTestDataFactory - setupOrderB2C - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupOrderB2C - Queries used: '+LIMITS.getQueries());
    }
    public static void setupNormalOrderB2C(){
        LumonTestOrders.setupOrderB2C();
        System.debug('--- LumonTestDataFactory - setupNormalOrderB2C - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupNormalOrderB2C - Queries used: '+LIMITS.getQueries());
    }
    public static void setupSpecialOrderB2C(){
        LumonTestOrders.setupSpecialOrderB2C();
        System.debug('--- LumonTestDataFactory - setupSpecialOrderB2C - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupSpecialOrderB2C - Queries used: '+LIMITS.getQueries());
    }
    public static void setupReclamationOrderB2C(){
        LumonTestOrders.setupReclamationOrderB2C();
        System.debug('--- LumonTestDataFactory - setupReclamationOrderB2C - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupReclamationOrderB2C - Queries used: '+LIMITS.getQueries());
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
    /***************** Reclamations ********************/
    public static void setupReclamationB2C(){
        LumonTestReclamations.setupReclamationB2C();
        System.debug('--- LumonTestDataFactory - setupReclamationB2C - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupReclamationB2C - Queries used: '+LIMITS.getQueries());
    }
    public static void setupReclamationB2B(){
        LumonTestReclamations.setupReclamationB2B();
        System.debug('--- LumonTestDataFactory - setupReclamationB2B - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupReclamationB2B - Queries used: '+LIMITS.getQueries());
    }

/***************** Real Life Data  ********************/    
    
    @TestVisible private static String visualPricingJSON {
        get {return ('{'+
            '    \"apartment\": \"C3\",'+
            '    \"floor\": \"3\",'+
            '    \"id\": \"B2C-ABCDE1\",'+
            '    \"line\": \"123\",'+
            '    \"name\": \"Test Plan 3\",'+
            '    \"version\": 3,'+
            '    \"products\": ['+
            '      {'+
            '        \"id\": \"visualProductId1\",'+
            '        \"name\": \"LG\",'+
            '        \"productLength\": 0.0,'+
            '        \"priceParameters\": ['+
            '          {'+
            '            \"Amount\": 1.0,'+
            '            \"LocalSupplier\": true,'+
            '            \"ParameterCode\": \"\",'+
            '            \"SalesCode\": \"Option1\",'+
            '            \"UniqueId\": 1,'+
            '            \"Unit\": \"PCS\"'+
            '          },'+
            '          {'+
            '            \"Amount\": 200.0,'+
            '            \"LocalSupplier\": true,'+
            '            \"ParameterCode\": \"\",'+
            '            \"SalesCode\": \"Option2\",'+
            '            \"UniqueId\": 2,'+
            '            \"Unit\": \"h\"'+
            '          }'+
            '        ],'+
            '        \"rvn\": \"33333-3\",'+
            '        \"hasFeaturesBeenConfirmed\": true,'+
            '        \"hasMeasurementsBeenVerified\": true,'+
            '        \"productInspectCode\": 2,'+
            '        \"productInspectMessageKeys\": ['+
            '          {'+
            '            \"MessageKey\": \"E11111\",'+
            '            \"SpaceSideNumber\": 1'+
            '          }'+
            '        ],'+
            '        \"reclaimedFeatureMessageKeys\": []'+
            '      }'+
            '    ]'+
            '  }');
        }
    }

/***************** Real Life Data  ********************/
    /*public static void setupMainProjectB2C(){
        // Create B2C Main Project
        Id b2bOpportunityId = [SELECT Id FROM Opportunity WHERE (Account.IsPersonAccount = false)]?.Id;
        System.debug('--- LumonTestDataFactory - setupMainProjectB2C - Opportunity: '+b2cOpportunityId);
        Project__c b2cProject1 = new Project__c( 
                                            Name='B2C Main Project',
                                            Status='Draft',
                                            //Type='Normal',
                                            Pricebook2Id=pricebookId,
                                            OpportunityId=b2cOpportunityId,
                                            ContractId=b2cContractId,
                                            QuoteId=b2cSyncedQuoteId
                                            );
        insert b2cProject1;
        System.debug('--- LumonTestDataFactory - setupMainProjectB2C - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupMainProjectB2C - Queries used: '+LIMITS.getQueries());
    }*/
    /*public static void setupOpportunityProductsB2C() {
        List<OpportunityLineItem> opportunityProducts = new List<OpportunityLineItem>();
        for (Integer i = 0; i<pricebookEntries.size();i++) {
            OpportunityLineItem oli = new OpportunityLineItem(OpportunityId=b2cOpportunityId,
                                                    Product2Id=pricebookEntries[i].Product2Id,
                                                    PricebookEntryId=pricebookEntries[i].Id,
                                                    Quantity=1,
                                                    UnitPrice=1);
            opportunityProducts.add(oli);
        }
        insert opportunityProducts;
    }*/
    /*@future
    public static void setupOpportunityProductsB2B() {
        List<OpportunityLineItem> opportunityProducts = new List<OpportunityLineItem>();
        for (Integer i = 0; i<pricebookEntries.size();i++) {
            OpportunityLineItem oli = new OpportunityLineItem(OpportunityId=b2bOpportunityId,
                                                    Product2Id=pricebookEntries[i].Product2Id,
                                                    PricebookEntryId=pricebookEntries[i].Id,
                                                    Quantity=1,
                                                    UnitPrice=1);
            opportunityProducts.add(oli);
        }
        insert opportunityProducts;
    }*/
    //@future 
    public static void setupGlazingRetractable() {
        // Add Product
        Product2 p1 = new Product2();
        p1.Name='Test Product Retractable';
        p1.IsActive=True;
        p1.ProductCode='LG-PRODUCT';
        p1.Product_Group__c='LG';
        p1.Product_Category__c='Product Groups';
        p1.Cost_Category__c = 'FactoryPurchase';
        p1.Cost_Type__c='tuotteet';
        Product2 p2 = new Product2();
        p2.Name='Test Product Vakuutus';
        p2.IsActive=True;
        p2.ProductCode='LG-OPTION';
        p2.Product_Group__c='LG';
        p2.Product_Category__c='Product Options';
        p2.Cost_Category__c = 'FactoryPurchase';
        p2.Cost_Type__c='tuotteet';  
        Product2 p3 = new Product2();
        p3.Name='Test Product Vakuutus';
        p3.IsActive=True;
        p3.ProductCode='LG-BLINDS';
        p3.Product_Group__c='LG';
        p3.Product_Category__c='Product Options';
        p3.Cost_Category__c = 'FactoryPurchase';
        p3.Cost_Type__c='verhot';  
        Product2 p4 = new Product2();
        p4.Name='Test Product Freight';
        p4.IsActive=True;
        p4.ProductCode='LG-FREIGHT';
        p4.Product_Group__c='LG';
        p4.Product_Category__c='Product Options';
        p4.Cost_Category__c = 'SalesFreight';
        p4.Cost_Type__c='rahti';  
        Product2 p5 = new Product2();
        p5.Name='Test Product Installation';
        p5.IsActive=True;
        p5.ProductCode='LG-INSTALL';
        p5.Product_Group__c='LG';
        p5.Product_Category__c='Product Options';
        p5.Cost_Category__c = 'Wages';
        p5.Cost_Type__c='asennus';  
        insert new List<Product2>{p1,p2,p3,p4,p5};
        // Add PricebookEntries
        Id pricebookId = Test.getStandardPricebookId();
        Decimal basePrice = 10;
        Decimal unitPrice = 100;
        List<Product2> Products = [SELECT Id FROM Product2 WHERE Isactive = True AND Product_Category__c IN ('Product Groups','Product Options') And Product_Group__c = 'LG'];
        List<PricebookEntry> pricebookEntries = new List<PricebookEntry>();
        for (Integer i = 0; i<products.size();i++) {
            Integer counter= i+1;
            PricebookEntry pbe = new PricebookEntry(Pricebook2Id=pricebookId,
                                                    Product2Id=products[i].Id,
                                                    UnitPrice=unitPrice,
                                                    IsActive=True,
                                                    CurrencyIsoCode = 'EUR',
                                                    Base_Price__c=basePrice);
            pricebookEntries.add(pbe);
        }
        insert pricebookEntries;
    }
    //@future 
    public static void setupGlazingSliding() {
        Factory_Price__c fp1 = new Factory_Price__c();
        fp1.Organization__c = 'LSU';
        fp1.Country__c = 'FI';
        fp1.Business_Type__c = 'Consumer';
        fp1.Product_Group__c = 'LGS';
        fp1.Cost_Type__c = 'tuotteet';
        fp1.Factory_Multiplier__c = 10.0;
        fp1.IsActive__c  = true;
        Factory_Price__c fp2 = new Factory_Price__c();
        fp2.Organization__c = 'LSU';
        fp2.Country__c = 'FI';
        fp2.Business_Type__c = 'Consumer';
        fp2.Product_Group__c = 'LGS';
        fp2.Cost_Type__c = 'verhot';
        fp2.Factory_Multiplier__c = 10.0;
        fp2.IsActive__c  = true;
        insert new List<Factory_Price__c>{fp1,fp2};
        Product_Cost__c pc1 = new Product_Cost__c();
        pc1.Organization__c = 'LSU';
        pc1.Country__c = 'FI';
        pc1.Business_Type__c = 'Consumer';
        pc1.District__c = 'FI_North';
        pc1.Product_Group__c = 'LGS';
        pc1.Cost_Type__c = 'rahti';
        pc1.Cost_Multiplier__c = 20.0;
        pc1.IsActive__c  = true;
        Product_Cost__c pc2= new Product_Cost__c();
        pc2.Organization__c = 'LSU';
        pc2.Country__c = 'FI';
        pc2.Business_Type__c = 'Consumer';
        pc2.District__c = 'FI_North';
        pc2.Product_Group__c = 'LGS';
        pc2.Cost_Type__c = 'asennus';
        pc2.Cost_Multiplier__c = 20.0;
        pc2.IsActive__c  = true;
        insert new List<Product_Cost__c>{pc1,pc2};
        Sales_Price__c sp1 = new Sales_Price__c();
        sp1.Organization__c = 'LSU';
        sp1.Country__c = 'FI';
        sp1.Business_Type__c = 'Consumer';
        sp1.District__c = 'FI_North';
        sp1.Product_Group__c = 'LGS';
        sp1.Profit_Center__c = '4043 LSU Oulu';
        sp1.Cost_Type__c = 'tuotteet';
        sp1.Sales_Multiplier__c = 30.0;
        sp1.IsActive__c  = true;
        Sales_Price__c sp2 = new Sales_Price__c();
        sp2.Organization__c = 'LSU';
        sp2.Country__c = 'FI';
        sp2.Business_Type__c = 'Reseller';
        sp2.District__c = 'FI_North';
        sp2.Product_Group__c = 'LGS';
        sp2.Profit_Center__c = '4043 LSU Oulu';
        sp2.BusinessId__c = '1234-56';
        sp2.Cost_Type__c = 'verhot';
        sp2.Sales_Multiplier__c = 30.0;
        sp2.IsActive__c  = true;
        Sales_Price__c sp3 = new Sales_Price__c();
        sp3.Organization__c = 'LSU';
        sp3.Country__c = 'FI';
        sp3.Business_Type__c = 'Reseller';
        sp3.District__c = 'FI_North';
        sp3.Product_Group__c = 'LGS';
        sp3.Profit_Center__c = '4043 LSU Oulu';
        sp3.BusinessId__c = '1234-56';
        sp3.Cost_Type__c = 'rahti';
        sp3.Sales_Multiplier__c = 30.0;
        sp3.IsActive__c  = true;
        Sales_Price__c sp4 = new Sales_Price__c();
        sp4.Organization__c = 'LSU';
        sp4.Country__c = 'FI';
        sp4.Business_Type__c = 'Reseller';
        sp4.District__c = 'FI_North';
        sp4.Product_Group__c = 'LGS';
        sp4.Profit_Center__c = '4043 LSU Oulu';
        sp4.BusinessId__c = '1234-56';
        sp4.Cost_Type__c = 'asennus';
        sp4.Sales_Multiplier__c = 30.0;
        sp4.IsActive__c  = true;
        insert new List<Sales_Price__c>{sp1,sp2,sp3,sp4};
        // Add Product

                //Product2 p10 = new Product2(Name='Test Product 10 Inactive', IsActive=False,ProductCode='LG-Servivces',Product_Group__c='HUOLTO',Product_Category__c='Product Options',Cost_Type__c='verhot');
        Product2 p1 = new Product2();
        p1.Name='Test Product Retractable';
        p1.IsActive=True;
        p1.ProductCode='LGS-PRODUCT';
        p1.Product_Group__c='LGS';
        p1.Product_Category__c='Product Groups';
        p1.Cost_Category__c='FactoryPurchase';
        p1.Cost_Type__c='tuotteet';
        Product2 p2 = new Product2();
        p2.Name='Test Product Vakuutus';
        p2.IsActive=True;
        p2.ProductCode='LGS-OPTION';
        p2.Product_Group__c='LGS';
        p2.Product_Category__c='Product Options';
        p2.Cost_Category__c='FactoryPurchase';
        p2.Cost_Type__c='tuotteet';  
        Product2 p3 = new Product2();
        p3.Name='Test Product Vakuutus';
        p3.IsActive=True;
        p3.ProductCode='LGS-BLINDS';
        p3.Product_Group__c='LGS';
        p3.Product_Category__c='Product Options';
        p3.Cost_Category__c='FactoryPurchase';
        p3.Cost_Type__c='verhot';  
        Product2 p4 = new Product2();
        p4.Name='Test Product Freight';
        p4.IsActive=True;
        p4.ProductCode='LGS-FREIGHT';
        p4.Product_Group__c='LGS';
        p4.Product_Category__c='Product Options';
        p4.Cost_Category__c='SalesFreight';
        p4.Cost_Type__c='rahti';  
        Product2 p5 = new Product2();
        p5.Name='Test Product Installation';
        p5.IsActive=True;
        p5.ProductCode='LGS-INSTALL';
        p5.Product_Group__c='LGS';
        p5.Product_Category__c='Product Options';
        p5.Cost_Category__c='Wages';
        p5.Cost_Type__c='asennus';  
        insert new List<Product2>{p1,p2,p3,p4,p5};
        // Add PricebookEntries
        Id pricebookId = Test.getStandardPricebookId();
        Decimal basePrice = 10;
        Decimal unitPrice = 100;
        List<Product2> Products = [SELECT Id FROM Product2 WHERE Isactive = True AND Product_Category__c IN ('Product Groups','Product Options') And Product_Group__c = 'LGS'];
        List<PricebookEntry> pricebookEntries = new List<PricebookEntry>();
        for (Integer i = 0; i<products.size();i++) {
            Integer counter= i+1;
            PricebookEntry pbe = new PricebookEntry(Pricebook2Id=pricebookId,
                                                    Product2Id=products[i].Id,
                                                    UnitPrice=unitPrice,
                                                    IsActive=True,
                                                    CurrencyIsoCode = 'EUR',
                                                    Base_Price__c=basePrice);
            pricebookEntries.add(pbe);
        }
        insert pricebookEntries;
    }
    //@future 
    public static void setupAdditionalCosts() {
        Factory_Price__c fp1 = new Factory_Price__c();
        fp1.Organization__c = 'LSU';
        fp1.Country__c = 'FI';
        fp1.Business_Type__c = 'Consumer';
        fp1.Product_Group__c = 'LGS';
        fp1.Cost_Type__c = 'vakuutus';
        fp1.Factory_Multiplier__c = 10.0;
        fp1.IsActive__c  = true;
        Factory_Price__c fp2 = new Factory_Price__c();
        fp2.Organization__c = 'LSU';
        fp2.Country__c = 'FI';
        fp2.Business_Type__c = 'Consumer';
        fp2.Product_Group__c = 'LG';
        fp2.Cost_Type__c = 'vakuutus';
        fp2.Factory_Multiplier__c = 10.0;
        fp2.IsActive__c  = true;
        insert new List<Factory_Price__c>{fp1,fp2};
        Product_Cost__c pc1 = new Product_Cost__c();
        pc1.Organization__c = 'LSU';
        pc1.Country__c = 'FI';
        pc1.Business_Type__c = 'Consumer';
        pc1.District__c = 'FI_North';
        pc1.Product_Group__c = 'LGS';
        pc1.Cost_Type__c = 'vakuutus';
        pc1.Cost_Multiplier__c = 20.0;
        pc1.IsActive__c  = true;
        Product_Cost__c pc2= new Product_Cost__c();
        pc2.Organization__c = 'LSU';
        pc2.Country__c = 'FI';
        pc2.Business_Type__c = 'Consumer';
        pc2.District__c = 'FI_North';
        pc2.Product_Group__c = 'LG';
        pc2.Cost_Type__c = 'vakuutus';
        pc2.Cost_Multiplier__c = 20.0;
        pc2.IsActive__c  = true;
        insert new List<Product_Cost__c>{pc1,pc2};
        Sales_Price__c sp1 = new Sales_Price__c();
        sp1.Organization__c = 'LSU';
        sp1.Country__c = 'FI';
        sp1.Business_Type__c = 'Consumer';
        sp1.District__c = 'FI_North';
        sp1.Product_Group__c = 'LGS';
        sp1.Profit_Center__c = '4043 LSU Oulu';
        sp1.Cost_Type__c = 'vakuutus';
        sp1.Sales_Multiplier__c = 30.0;
        sp1.IsActive__c  = true;
        Sales_Price__c sp2 = new Sales_Price__c();
        sp2.Organization__c = 'LSU';
        sp2.Country__c = 'FI';
        sp2.Business_Type__c = 'Reseller';
        sp2.District__c = 'FI_North';
        sp2.Product_Group__c = 'LG';
        sp2.Profit_Center__c = '4043 LSU Oulu';
        sp2.BusinessId__c = '1234-56';
        sp2.Cost_Type__c = 'vakuutus';
        sp2.Sales_Multiplier__c = 30.0;
        sp2.IsActive__c  = true;
        insert new List<Sales_Price__c>{sp1,sp2};
        // Add Product
        Product2 p1 = new Product2();
        p1.Name='Test Product Vakuutus';
        p1.IsActive=True;
        p1.ProductCode='LGS-INSURANCE';
        p1.Product_Group__c='LGS';
        p1.Product_Category__c='Additional Costs';
        p1.Cost_Category__c='SalesService';
        p1.Cost_Type__c='vakuutus';
        Product2 p2 = new Product2();
        p2.Name='Test Product Vakuutus';
        p2.IsActive=True;
        p2.ProductCode='LG-INSURANCE';
        p2.Product_Group__c='LG';
        p2.Product_Category__c='Additional Costs';
        p2.Cost_Category__c='SalesService';
        p2.Cost_Type__c='vakuutus';  
        Product2 p3 = new Product2();
        p3.Name='Test Product Vakuutus';
        p3.IsActive=True;
        p3.ProductCode='INSURANCE';
        p3.Product_Group__c='LISAKUSTAN';
        p3.Product_Category__c='Additional Costs';
        p3.Cost_Category__c='SalesService';
        p3.Cost_Type__c='vakuutus';  
        insert new List<Product2>{p1,p2,p3};
        System.debug('--- LumonTestDataFactory - LG product: '+p1);
        System.debug('--- LumonTestDataFactory - LGS product: '+p2);
        System.debug('--- LumonTestDataFactory - COST product: '+p3);
        // Add PricebookEntries
        Id pricebookId = Test.getStandardPricebookId();
        Decimal basePrice = 10;
        Decimal unitPrice = 100;
        List<Product2> Products = [SELECT Id FROM Product2 WHERE Isactive = True AND Product_Category__c = 'Additional Costs'];
        List<PricebookEntry> pricebookEntries = new List<PricebookEntry>();
        for (Integer i = 0; i<products.size();i++) {
            Integer counter= i+1;
            PricebookEntry pbe = new PricebookEntry(Pricebook2Id=pricebookId,
                                                    Product2Id=products[i].Id,
                                                    UnitPrice=unitPrice,
                                                    IsActive=True,
                                                    CurrencyIsoCode = 'EUR',
                                                    Base_Price__c=basePrice);
            pricebookEntries.add(pbe);
        }
        insert pricebookEntries;
    }
    //@future 
    public static void setupExtraSales() {
        Factory_Price__c fp1 = new Factory_Price__c();
        fp1.Organization__c = 'LSU';
        fp1.Country__c = 'FI';
        fp1.Business_Type__c = 'Consumer';
        fp1.Product_Group__c = 'LISAHIN';
        fp1.Cost_Type__c = 'myynti fi';
        fp1.Factory_Multiplier__c = 10.0;
        fp1.IsActive__c  = true;
        Factory_Price__c fp2 = new Factory_Price__c();
        fp2.Organization__c = 'LSU';
        fp2.Country__c = 'FI';
        fp2.Business_Type__c = 'Consumer';
        fp2.Product_Group__c = 'LISAHIN';
        fp2.Cost_Type__c = 'asennus fi';
        fp2.Factory_Multiplier__c = 10.0;
        fp2.IsActive__c  = true;
        insert new List<Factory_Price__c>{fp1,fp2};
        Product_Cost__c pc1 = new Product_Cost__c();
        pc1.Organization__c = 'LSU';
        pc1.Country__c = 'FI';
        pc1.Business_Type__c = 'Consumer';
        pc1.District__c = 'FI_North';
        pc1.Product_Group__c = 'LISAHIN';
        pc1.Cost_Type__c = 'myynti fi';
        pc1.Cost_Multiplier__c = 20.0;
        pc1.IsActive__c  = true;
        Product_Cost__c pc2= new Product_Cost__c();
        pc2.Organization__c = 'LSU';
        pc2.Country__c = 'FI';
        pc2.Business_Type__c = 'Consumer';
        pc2.District__c = 'FI_North';
        pc2.Product_Group__c = 'LISAHIN';
        pc2.Cost_Type__c = 'asennus fi';
        pc2.Cost_Multiplier__c = 20.0;
        pc2.IsActive__c  = true;
        insert new List<Product_Cost__c>{pc1,pc2};
        Sales_Price__c sp1 = new Sales_Price__c();
        sp1.Organization__c = 'LSU';
        sp1.Country__c = 'FI';
        sp1.Business_Type__c = 'Consumer';
        sp1.District__c = 'FI_North';
        sp1.Product_Group__c = 'LISAHIN';
        sp1.Profit_Center__c = '4043 LSU Oulu';
        sp1.Cost_Type__c = 'asennus fi';
        sp1.Sales_Multiplier__c = 30.0;
        sp1.IsActive__c  = true;
        Sales_Price__c sp2 = new Sales_Price__c();
        sp2.Organization__c = 'LSU';
        sp2.Country__c = 'FI';
        sp2.Business_Type__c = 'Consumer';
        sp2.District__c = 'FI_North';
        sp2.Product_Group__c = 'LG';
        sp2.Profit_Center__c = '4043 LSU Oulu';
        sp2.BusinessId__c = '1234-56';
        sp2.Cost_Type__c = 'myynti fi';
        sp2.Sales_Multiplier__c = 30.0;
        sp2.IsActive__c  = true;
        insert new List<Sales_Price__c>{sp1,sp2};
        // Add Product
        Product2 p1 = new Product2();
        p1.Name='Test Product Crane Rent';
        p1.IsActive=True;
        p1.ProductCode='LISAHIN-Crane';
        p1.Product_Group__c='LISAHIN';
        p1.Product_Category__c='Extra Sales';
        p1.Cost_Category__c = 'RentedMachinery';
        p1.Cost_Type__c='nostok. fi';  
        Product2 p2 = new Product2();
        p2.Name='Test Product Vakuutus';
        p2.IsActive=True;
        p2.ProductCode='LISAHIN-Removal';
        p2.Product_Group__c='LISAHIN';
        p2.Product_Category__c='Extra Sales';
        p2.Cost_Category__c = 'Wages';
        p2.Cost_Type__c='asennus fi';
        Product2 p3 = new Product2();
        p3.Name='Test Product Vakuutus';
        p3.IsActive=True;
        p3.ProductCode='LISAHIN-Sales';
        p3.Product_Group__c='LISAHIN';
        p3.Product_Category__c='Extra Sales';
        p3.Cost_Category__c = 'AdditionalSales';
        p3.Cost_Type__c='myynti fi'; 
        insert new List<Product2>{p1,p2,p3};
        // Add PricebookEntries
        Id pricebookId = Test.getStandardPricebookId();
        Decimal basePrice = 10;
        Decimal unitPrice = 100;
        List<Product2> Products = [SELECT Id FROM Product2 WHERE Isactive = True AND Product_Category__c = 'Extra Sales'];
        List<PricebookEntry> pricebookEntries = new List<PricebookEntry>();
        for (Integer i = 0; i<products.size();i++) {
            Integer counter= i+1;
            PricebookEntry pbe = new PricebookEntry(Pricebook2Id=pricebookId,
                                                    Product2Id=products[i].Id,
                                                    UnitPrice=unitPrice,
                                                    IsActive=True,
                                                    CurrencyIsoCode = 'EUR',
                                                    Base_Price__c=basePrice);
            pricebookEntries.add(pbe);
        }
        insert pricebookEntries;
    }       

    /***************** Location Objects ********************/
    public static void setupFactories() {
        LumonTestLocations.setupFactories();
        System.debug('--- LumonTestDataFactory - setupFactories - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupFactories - Queries used: '+LIMITS.getQueries());
    }
    public static void setupWarehouses() {
        LumonTestLocations.setupWarehouses();
        System.debug('--- LumonTestDataFactory - setupWarehouses - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupWarehouses - Queries used: '+LIMITS.getQueries());
    }

    /***************** Configuration ********************/
    public static void setupConfigurationB2C(){
        LumonTestConfigurations.setupConfigurationPlanB2C();
        System.debug('--- LumonTestDataFactory - setupConfigurationB2C - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupConfigurationB2C - Queries used: '+LIMITS.getQueries());
    }
    public static void setupConfigurations() {
        LumonTestConfigurations.setupConfigurationData();
        System.debug('--- LumonTestDataFactory - setupConfigurations - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupConfigurations - Queries used: '+LIMITS.getQueries());
    }
    
    public static void setupConfigurationProductsB2C() {
        LumonTestConfigurationProducts.setupConfigurationProductData();
    }
    public static void setupConfigurationProducts() {
        LumonTestConfigurationProducts.setupConfigurationProductData();
        System.debug('--- LumonTestDataFactory - setupConfigurationProducts - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupConfigurationProducts - Queries used: '+LIMITS.getQueries());
    }
    public static void setupConfigurationOptionsB2C() {
        LumonTestConfigurationOptions.setupConfigurationOptionData();
    }
    public static void setupConfigurationOptions() {
        LumonTestConfigurationOptions.setupConfigurationOptionData();
        System.debug('--- LumonTestDataFactory - setupConfigurationOptions - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupConfigurationOptions - Queries used: '+LIMITS.getQueries());
    }
    /*public static void setupConfigurationMessages() {
        LumonTestConfigurationMessages.setupConfigurationMessageData();
        System.debug('--- LumonTestDataFactory - setupConfigurationMessages - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupConfigurationMessages - Queries used: '+LIMITS.getQueries());
    }*/
    @future public static void setupConfigurationMessagesB2C() {
        List<Configuration_Message__c> b2cConfigMessages = new List<Configuration_Message__c>();
        // Create B2C
        for (Integer i = 0; i <b2cConfigProducts.size();i++) {
            Configuration_Message__c b2cConfigMesssage1 = new Configuration_Message__c(
                                            Name='Test Config Message 1',
                                            Configuration_Product__c = b2cConfigProducts[i].Id,
                                            Message_Key__c = 'E1-1-1',
                                            Space_Side_Number__c = 1);
            Configuration_Message__c b2cConfigMesssage2 = new Configuration_Message__c(
                                            Name='Test Config Message 2',
                                            Configuration_Product__c = b2cConfigProducts[i].Id,
                                            Message_Key__c = '1-2-1',
                                            Space_Side_Number__c = 2);
            b2cConfigMessages.add(b2cConfigMesssage1);
            b2cConfigMessages.add(b2cConfigMesssage2);
        }
        upsert b2cConfigMessages;
        System.debug('--- LumonTestDataFactory - setupConfigurationMessagesB2C - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupConfigurationMessagesB2C - Queries used: '+LIMITS.getQueries());
    }
    @future public static void setupVisualImageDocument() {
        // Create Content Document Version
        if (String.isBlank(b2cOpportunityId)){
            System.debug('No Parent Opportunity created');
        }
        Configuration__c b2cConfigurationPlan = new Configuration__c(
            Opportunity__c = b2cOpportunityId,
            Name='B2C Configuration 3',
            Plan_Apartment__c = 'C3',// public String apartment; // Door Nbr in Apartment
            Plan_Floor__c = '6',// public Integer floor; // Floor Nbr in Building
            Visual_Id__c = 'B2C-ABCDE3',//public String Id; // Unique Visual Configuration Id
            Plan_Line__c = '100',// public String line; //?
            Plan_Name__c = 'B2C Plan 3',// public String name; // Name of the Configuration
            //public List<Products> products; // Product Model aka Configurable Product
            Visual_Version__c = 3);//public Integer version; // Configuration Version);
        insert b2cConfigurationPlan;
        String b2cConfigurationPlanId = b2cConfigurationPlan.Id;
        System.debug('--- LumonTestDataFactory - setupVisualImageDocument - Plan: '+b2cConfigurationPlan);
        ContentVersion imageDocumentVersion = new ContentVersion();
        imageDocumentVersion.Title='Picture';
        imageDocumentVersion.ContentLocation= 's';
        imageDocumentVersion.PathOnClient = imageDocumentVersion.Title + '.jpg';
        Blob imageBody=Blob.valueOf('----Visual Picture Document');
        imageDocumentVersion.VersionData=imageBody;
        insert imageDocumentVersion;
        ContentVersion newDocumentVersion = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =:imageDocumentVersion.Id];
        // Create Content Document Version to Configuration
        ContentDocumentLink imageDocumentLink = new ContentDocumentLink();
        imageDocumentLink.ContentDocumentId = newDocumentVersion.ContentDocumentId;
        imageDocumentLink.ShareType = 'V';
        imageDocumentLink.LinkedEntityId = b2cConfigurationPlanId;
        insert imageDocumentLink;
        System.debug('--- LumonTestDataFactory - setupVisualImageDocument - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupVisualImageDocument - Queries used: '+LIMITS.getQueries());
    }
    @future public static void setupVisualPricingDocument() {
        // Create Content Document Version
        if (String.isBlank(b2cOpportunityId)){
            System.debug('No Parent Opportunity created');
        }
        Configuration__c b2cConfigurationPlan = new Configuration__c(
            Opportunity__c = b2cOpportunityId,
            Name='B2C Configuration 3',
            Plan_Apartment__c = 'C3',// public String apartment; // Door Nbr in Apartment
            Plan_Floor__c = '6',// public Integer floor; // Floor Nbr in Building
            Visual_Id__c = 'B2C-ABCDE3',//public String Id; // Unique Visual Configuration Id
            Plan_Line__c = '100',// public String line; //?
            Plan_Name__c = 'B2C Plan 3',// public String name; // Name of the Configuration
            //public List<Products> products; // Product Model aka Configurable Product
            Visual_Version__c = 3);//public Integer version; // Configuration Version);
        insert b2cConfigurationPlan;
        String b2cConfigurationPlanId = b2cConfigurationPlan.Id;
        System.debug('--- LumonTestDataFactory - setupVisualImageDocument - Plan: '+b2cConfigurationPlan);
        // Create Content Document Version
        ContentVersion pricingDocumentVersion = new ContentVersion();
        pricingDocumentVersion.Title='Visual Pricing';
        pricingDocumentVersion.ContentLocation= 's';
        pricingDocumentVersion.PathOnClient = pricingDocumentVersion.Title + '.json';
        String ConfigString = '{'+
        '    \"apartment\": \"A1\",'+
        '    \"floor\": \"6\",'+
        '    \"Id\": \"B2C-ABCDE1\",'+
        '    \"line\": \"123\",'+
        '    \"name\": \"Test Plan 1\",'+
        '    \"version\": 2,'+
        '    \"products\": ['+
        '      {'+
        '        \"Id\": \"visualProductId1\",'+
        '        \"name\": \"COST\",'+
        '        \"productLength\": 0.0,'+
        '        \"priceParameters\": ['+
        '          {'+
        '            \"Amount\": 1.0,'+
        '            \"LocalSupplier\": true,'+
        '            \"ParameterCode\": \"\",'+
        '            \"SalesCode\": \"Option 1\",'+
        '            \"UniqueId\": 1,'+
        '            \"Unit\": \"PCS\"'+
        '          }'+
        '        ],'+
        '        \"rvn\": \"12345678\",'+
        '        \"hasFeaturesBeenConfirmed\": true,'+
        '        \"hasMeasurementsBeenVerified\": true,'+
        '        \"productInspectCode\": 2,'+
        '        \"productInspectMessageKeys\": ['+
        '          {'+
        '            \"MessageKey\": \"E11111\",'+
        '            \"SpaceSideNumber\": 1'+
        '          }'+
        '        ],'+
        '        \"reclaimedFeatureMessageKeys\": []'+
        '      }'+
        '    ]'+
        '  }';
        Blob bodyBlob=Blob.valueOf(ConfigString);
        pricingDocumentVersion.VersionData=bodyBlob;
        insert pricingDocumentVersion;
        ContentVersion newPricingDocumentVersion = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =:pricingDocumentVersion.Id];
        // Link Content Document to Configuration
        ContentDocumentLink pricingDocumentLink = new ContentDocumentLink();
        pricingDocumentLink.ContentDocumentId = newPricingDocumentVersion.ContentDocumentId;
        pricingDocumentLink.ShareType = 'V';
        pricingDocumentLink.LinkedEntityId = b2cConfigurationPlanId;
        insert pricingDocumentLink;
        System.debug('--- LumonTestDataFactory - setupVisualPricingDocument - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- LumonTestDataFactory - setupVisualPricingDocument - Queries used: '+LIMITS.getQueries());
    }/*
    @future public static void setupContentFiles(){
        List<ContentVersion> contentVersions = new List<ContentVersion>();
        System.debug('*** b2cConfigurations 1 ***'+b2cConfigurations[0].Id);
        System.debug('*** b2cConfigurations 2 ***'+b2cConfigurations[1].Id);
        Configuration__c b2cConfigurationPlan =  [SELECT Id from Configuration__c where Id = :b2cConfigurations[1].Id];
        String b2cConfigurationPlanId = b2cConfigurationPlan.Id;
        Configuration_Product__c b2cConfigProduct = [SELECT Id,RVN__c,Configuration__r.Opportunity__r.Opportunity_Number__c from Configuration_Product__c where Configuration__c = :b2cConfigurations[1].Id limit 1];
        String RVN = b2cConfigProduct.RVN__c;
        String oppNumber = b2cConfigProduct.Configuration__r.Opportunity__r.Opportunity_Number__c;
        RVN = RVN.replace(oppNumber,'');
        //String json = '{\"country\":\"FI5\",\"product_type\":\"LGS\",\"terrain_class\":1,\"building_height\":90,\"reference_windspeed\":9,\"slope\":0,\"wind_pressure\":0.8,\"corner_coefficient\":0,\"structure\":0,\"product_openings\":1,\"report\":0,\"structure_number\":\"B2C-0-1\"}';
        String json = '{\"country\":\"FI5\",\"product_type\":\"LG\",\"terrain_class\":1,\"building_height\":90,\"reference_windspeed\":9,\"slope\":0,\"wind_pressure\":0.8,\"corner_coefficient\":0,\"structure\":0,\"product_openings\":1,\"report\":0,\"structure_number\":';
        json += RVN;
        json += '}';
        System.debug('*** json ***'+json);
        contentVersions.add(new ContentVersion(VersionData = Blob.valueOf(json), Title = 'Visual Output_12345678', PathOnClient = 'VisualOutput_12345678.json'));
        String xml = '<?xml version="1.0" encoding="utf-16"?><products xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">';
        xml += '<structural_version_number>';
        xml += RVN;
        xml += '</structural_version_number>';
        xml += '<balconyglazing><product_name>LFIXEDWALL</product_name><weight><value>303.609344482422</value></weight></balconyglazing>';
        xml += '<area><value>321</value></area><blinds_area><value>11</value></blinds_area><glass_count><value>1</value></glass_count></products>';
		System.debug('*** xml ***'+xml);
        contentVersions.add(new ContentVersion(VersionData = Blob.valueOf(xml), Title = 'Visual Plan Statistics_LG_JJwh5kqCaUm_attxb4b5Jg_12345678', PathOnClient = 'Visual%20Plan%20Statistics_LG_JJwh5kqCaUm_attxb4b5Jg_12345678.xml'));

        String documentationXml = '<?xml version="1.0" encoding="utf-16"?><products xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">';
        documentationXml += '<name>TESTVisualDocumentation</name>';
        documentationXml += '<space><corner_multiplier>No</corner_multiplier></space>';
        documentationXml += '<balconyglazing><product_code>LFIXEDWALL</product_code>';
        documentationXml += '<product_code_short>LFIXEDWALL</product_code_short><structural_version_number>';
        documentationXml += RVN;
        documentationXml += '</structural_version_number>';
        documentationXml += '<unique_system_id>-Ei7ms2lCkKX-OgKYSUlhQ</unique_system_id><product_weight>303.609344482422</product_weight>';
        documentationXml += '<order_xml_info>&lt;rivipaino&gt;303.609344482422&lt;/rivipaino&gt;&lt;sivut&gt;&lt;sivu&gt;&lt;numero&gt;1&lt;/numero&gt;&lt;profiilivari-yla&gt;RAL9006&lt;/profiilivari-yla&gt;&lt;profiilivari-ala&gt;RAL9006&lt;/profiilivari-ala&gt;&lt;lasi-vahvuus&gt;8&lt;/lasi-vahvuus&gt;&lt;lasi-vari&gt;20090017&lt;/lasi-vari&gt;&lt;lasi-karkaisu&gt;1&lt;/lasi-karkaisu&gt;&lt;muovivari-yla&gt;Tummanharmaa&lt;/muovivari-yla&gt;&lt;muovivari-ala&gt;Tummanharmaa&lt;/muovivari-ala&gt;&lt;profiili-yla&gt;11222206&lt;/profiili-yla&gt;&lt;profiili-ala&gt;11243001&lt;/profiili-ala&gt;&lt;profiili-saato&gt;11241205&lt;/profiili-saato&gt;&lt;profiilipituus&gt;3000&lt;/profiilipituus&gt;&lt;lasitus-pituus&gt;3000&lt;/lasitus-pituus&gt;&lt;lasitus-korkeus&gt;2000&lt;/lasitus-korkeus&gt;&lt;lasivasen-kpl&gt;4&lt;/lasivasen-kpl&gt;&lt;lasioikea-kpl&gt;0&lt;/lasioikea-kpl&gt;&lt;kulmanylitys&gt;0&lt;/kulmanylitys&gt;&lt;sivun-paino&gt;220.997283935547&lt;/sivun-paino&gt;&lt;alkukulma&gt;90&lt;/alkukulma&gt;&lt;loppukulma&gt;90&lt;/loppukulma&gt;&lt;jarjestelmakulma&gt;&lt;/jarjestelmakulma&gt;&lt;/sivu&gt;&lt;/sivut&gt;</order_xml_info>';
        documentationXml += '</balconyglazing></products>';

		System.debug('*** documentationXml ***'+documentationXml);
        contentVersions.add(new ContentVersion(VersionData = Blob.valueOf(documentationXml), Title = 'Visual Documentation Test', PathOnClient = 'Visual%20Documentation%20Test.xml'));

        String outputXml = '<?xml version="1.0" encoding="utf-16"?><configuration><PAATASO><REKLAMAATIO>0</REKLAMAATIO>';
        outputXml += '<RAKENNENUMERO>#ORDER_NO#12345678</RAKENNENUMERO><ERIKOISTILAUS>0</ERIKOISTILAUS></PAATASO></configuration>';


        contentVersions.add(new ContentVersion(VersionData = Blob.valueOf(outputXml), Title = 'Visual Output_'+b2cConfigProduct.RVN__c, PathOnClient = 'VisualOutput_12345678.xml'));

        insert contentVersions;

        ContentDocumentLink cdl1 = new ContentDocumentLink(ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :contentVersions[0].Id LIMIT 1].ContentDocumentId, LinkedEntityId = b2cConfigurations[1].Id);
        ContentDocumentLink cdl2 = new ContentDocumentLink(ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :contentVersions[1].Id LIMIT 1].ContentDocumentId, LinkedEntityId = b2cConfigurations[1].Id);
        ContentDocumentLink cdl3 = new ContentDocumentLink(ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :contentVersions[2].Id LIMIT 1].ContentDocumentId, LinkedEntityId = b2cConfigurations[1].Id);
        ContentDocumentLink cdl4 = new ContentDocumentLink(ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :contentVersions[3].Id LIMIT 1].ContentDocumentId, LinkedEntityId = b2cConfigurations[1].Id);
        insert new List<ContentDocumentLink>{
                cdl1, cdl2, cdl3, cdl4
        };
    }*/
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