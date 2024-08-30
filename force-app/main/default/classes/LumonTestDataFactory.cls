/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 05-31-2024
 * @last modified by  : Henk Reynders
**/
@isTest
public with sharing class LumonTestDataFactory {
    /** Determine if person account is enabled in current org **/
    @TestVisible private static Id adminProfileId{
        get{
            return [SELECT Id FROM Profile WHERE Name='System Administrator']?.Id;
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
            return [SELECT Id,Opportunity__c FROM Configuration__c WHERE Opportunity__c =:b2cOpportunityId AND Name = 'B2C Configuration 1']?.Id;
        }
    }
    @TestVisible private static List<ContentDocumentLink> b2cConfigurationFiles{
        get{
            return [SELECT Id FROM ContentDocumentLink WHERE LinkedEntityId =:b2cConfigurationPlanId];
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
    @TestVisible private static List<Configuration__c> b2cConfigurations{
        get{
            return [SELECT  Id,
                            Name,
                            Account__c,
                            Opportunity__c,
                            Quote__c,
                            Contract__c,
                            Order__c,
                            Work_Order__c,
                            Case__c,
                            Visual_Id__c
                    FROM Configuration__c WHERE (Opportunity__c = :b2cOpportunityId)];
        }
    }
    @TestVisible private static List<Configuration_Product__c> b2cConfigProducts{
        get{
            return [SELECT  Id,
                            Name,
                            Quantity__c,
                            Product_Group__c,
                            Product_Model__c,
                            Sales_Code__c,
                            Product__c,
                            Configuration__c,
                            RVN_Number__c,
                            RVN__c,
                            Visual_Structure_Number__c,
                            Sovelia_Structure_Number__c,
                            Product__r.Product_Group__c,
                            Visual_Product_Id__c,
                            Sovelia_Product_Id__c
                    FROM Configuration_Product__c WHERE (Configuration__c in :b2cConfigurations)];
        }
    }
    @TestVisible private static List<Configuration_Option__c> b2cConfigOptions{
        get{
            return [SELECT  Id,
                            Name,
                            Line_Number__c,
                            Quantity__c,
                            Product__c,
                            Product__r.Product_Group__c,
                            Product__r.Cost_Category__c,
                            Product__r.Cost_Type__c,
                            Product__r.Product_Category__c,
                            Product__r.Product_Type__c,
                            Product__r.Product_Item__c,
                            Product__r.ProductCode,
                            Product__r.Sales_Code__c,
                            Product_Code__c,
                            Product_Group__c,
                            Product_Model__c,
                            Configuration_Plan__c,
                            Configuration_Product__c,
                            Configuration_Product__r.Configuration__c,
                            RVN_Number__c
                    FROM Configuration_Option__c WHERE (Configuration_Product__c IN :b2cConfigProducts)];
        }
    }
    @TestVisible private static List<Configuration_Message__c> b2cConfigMessages{
        get{
            return [SELECT Id FROM Configuration_Message__c WHERE (Configuration_Product__c IN :b2cConfigProducts)];
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


    /***************** Users ********************/
    public static void setupAdminUser(){
        LumonTestUsers.setupAdminUser();
        System.debug('--- setupAdminUser - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- setupAdminUser - Queries used: '+LIMITS.getQueries());
    }
    public static void setupSalesUser(){
        LumonTestUsers.setupSalesUser();
        System.debug('--- setupSalesUser - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- setupSalesUser - Queries used: '+LIMITS.getQueries());
    }
    public static void setupSalesManager(){
        LumonTestUsers.setupSalesManagerUser();
        System.debug('--- setupSalesManager - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- setupSalesManager - Queries used: '+LIMITS.getQueries());
    }
    public static void setupInstaller(){
        LumonTestUsers.setupInstallerUser();
        System.debug('--- setupInstaller - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- setupInstaller - Queries used: '+LIMITS.getQueries());
    }
    public static void setupInstallationManager(){
        LumonTestUsers.setupInstallationManagerUser();
        System.debug('--- setupInstallationManager - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- setupInstallationManager - Queries used: '+LIMITS.getQueries());
    }

    public static void setupProductSettings(){
        Id orgId = [SELECT Id FROM Organization].Id;
        System.debug('--- setupProductSettings');
        Product_Settings__c productSettings = new Product_Settings__c();
        productSettings.SetupOwnerId = orgId;
        productSettings.Installable_Products__c = 'LG;LGS;LFIXEDWALL;LUMONKAIDE;VT3;VT4';
        productSettings.Extra_Sales_Product__c = 'Sales';
        productSettings.Additional_Cost_Product_Group__c = 'Additional Costs';
        productSettings.Service_Product_Group__c = 'HUOLTO';
        productSettings.AX_Products__c = 'LUMON5;LUMON6;LUMON6T;LT3;VT3;KIINTEÄSEI;LUMON7S';
        productSettings.Visual_Products__c = 'LG;LGS;LFIXEDWALL;LUMONKAIDE;LUMONTOLPK;VT3;VT4';
        productSettings.Other_Products__c = 'LISAHIN;HUOLTO;TERRACEMAT;LISÄPROF 1';
        productSettings.Sovelia_Products__c = 'VISORBLIND';
        productSettings.Reclamation_Product_Codes__c = '30210020R;90379999;90409999;90249999;90269999;90759999;90789999;62860090';
        productSettings.Main_Product_Codes__c = '30310020;90370001;90400001;90240001;90260001;90750001;90780001;62860088';
        //productSettings.Special_Terrace_Products__c = 'PD9750050;PD9780010;PD9750050;PD975004;PD9750043;PD9750042,PD9780052';
        //productSettings.Special_Balcony_Products__c = 'PD9240105;PD9240106;PD9240107:PD9390017';
        insert productSettings;
    }

    /***************** Products and Prices ********************/
    public static void setupProducts(){
        Product2 p1 = new Product2(Name='Test Product 1 Installation', IsActive=True,ProductCode='LG',Product_Group__c='LG',Product_Category__c='Product Groups',Installation__c = true,Configurator__c = 'Visual');
        Product2 p2 = new Product2(Name='Test Product 2 Reclamation', IsActive=True,ProductCode='LG',Product_Group__c='LG',Product_Category__c='Product Groups',Installation__c = true,Reclamation__c = true,Configurator__c = 'Visual',Cost_Category__c='RentedMachinery',Cost_Type__c='nostvuokra');
        Product2 p3 = new Product2(Name='Test Product 3 Option', IsActive=True,ProductCode='LG-Option1',Product_Group__c='LG',Product_Category__c='Product Options',Cost_Category__c='FactoryPurchase',Cost_Type__c='tuotteet');
        Product2 p4 = new Product2(Name='Test Product 4 Option', IsActive=True,ProductCode='LG-Option2',Product_Group__c='LG',Product_Category__c='Product Options',Cost_Category__c='SalesFreight',Cost_Type__c='rahti');
        Product2 p5 = new Product2(Name='Test Product 5 Min Price', IsActive=True,ProductCode='LG-MinPrice',Product_Group__c='LG',Product_Category__c='Product Options',Cost_Category__c='AdditionalSales',Cost_Type__c='myynti fi');
        Product2 p6 = new Product2(Name='Test Product 6 Max Quantity', IsActive=True,ProductCode='LG-MaxQuantity',Product_Group__c='LG',Product_Category__c='Product Options',Cost_Category__c='InstallSupplies',Cost_Type__c='	as.tarvike');
        Product2 p7 = new Product2(Name='Test Product 7 Transmission', IsActive=True,ProductCode='LG-Transmission',Product_Group__c='LG',Product_Category__c='Product Options',Cost_Category__c='CostReserv',Cost_Type__c='costreserv');
        Product2 p8 = new Product2(Name='Test Product 8 Inactive', IsActive=False,ProductCode='LG-Obsolete',Product_Group__c='LG',Product_Category__c='Product Options',Cost_Category__c='FactoryPurchase',Cost_Type__c='verhot');
        Product2 p9 = new Product2(Name='Test Product 9 Installation Time', IsActive=True,ProductCode='LG-Installation',Product_Group__c='LG',Product_Category__c='Product Options',Cost_Category__c='Manhours',Cost_Type__c ='askuormitu');
        //Product2 p10 = new Product2(Name='Test Product 10 Inactive', IsActive=False,ProductCode='LG-Servivces',Product_Group__c='HUOLTO',Product_Category__c='Product Options',Cost_Type__c='verhot');
 
    	insert new List<Product2> {p1,p2,p3,p4,p5,p6,p7,p8,p9};
    }
    public static void setupPrices(){
        setupPricebookEntries();
    }
    public static void setupPricebookEntries(){
        List<PricebookEntry> pricebookEntries = new List<PricebookEntry>();
        List<Product2> products = [SELECT Id,Name,ProductCode,IsActive FROM Product2];
        for (Integer i = 0; i<products.size();i++) {
            Integer counter= i+1;
            Decimal basePrice = (counter)*10;
            Decimal unitPrice = (counter)*100;
            
            PricebookEntry pbe = new PricebookEntry(Pricebook2Id=pricebookId,
                                                    Product2Id=products[i].Id,
                                                    UnitPrice=unitPrice,
                                                    IsActive=True,
                                                    CurrencyIsoCode = 'EUR',
                                                    Base_Price__c=basePrice);
            switch on counter {
                when 5 {
                    pbe.Minimum_Price__c = 5000;
                }
                when 6 {
                    pbe.Quantity_per_Order__c = 1;
                }
                when 7 {
                    pbe.Transmission__c = 100;
                }
            }
            pricebookEntries.add(pbe);
        }
        insert pricebookEntries;
    }
    /***************** Sales Objects ********************/
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
        System.debug('--- setupLeadB2C - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- setupLeadB2C - Queries used: '+LIMITS.getQueries());
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
        System.debug('--- setupLeadMC - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- setupLeadMC - Queries used: '+LIMITS.getQueries()); 
    }
    @future public static void setupContactB2C(){
        Contact contact1 = new Contact(FirstName = 'My',
                                    LastName = 'Contact',
									MobilePhone = '+34800500100',                                
                                    MailingPostalCode = '01740', MailingCountry = 'Finland', 
                                    MailingCity = 'Vantaa',MailingStreet = 'Vanha Kalliosolantie 1');
        insert contact1;
        System.debug('--- setupContactB2C - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- setupContactB2C - Queries used: '+LIMITS.getQueries());
    }
    //@future 
    public static void setupAccountB2C(){
        // Create B2C Account
        Account personAccount1 = new Account(RecordTypeID=b2cRecordTypeId,
                    FirstName='My',
                    LastName='Person Account',
                    PersonEmail='test123@lumonCustomer.com',
                    PersonMailingCountry ='Finland',
                    PersonMailingCity='Vantaa',
                    PersonMailingPostalCode = '01740',
                    PersonMailingStreet='Vanha Kalliosolantie 8',
                    BillingCountry ='Finland',
                    BillingCity='Vantaa',
                    BillingPostalCode = '01740',
                    BillingStreet = 'Vanha Kalliosolantie 8',
                    District__c = 'FI_North',
                    District_Type__c = 'P4');
        insert personAccount1;
        System.debug('--- setupAccountB2C - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- setupAccountB2C - Queries used: '+LIMITS.getQueries());
    }
    //@future 
    public static void setupAccountB2B(){
        // Create B2B Account
        Account businessAccount1 = new Account(RecordTypeID=b2bRecordTypeId,
                    Name='B2B Account',
                    BillingCountry ='Finland',
                    BillingCity='Kouvola',
                    BillingPostalCode = '45130',
                    BillingStreet = 'Kaitilankatu 11');
        insert businessAccount1;
        System.debug('--- setupAccountB2B - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- setupAccountB2B - Queries used: '+LIMITS.getQueries());
    }
    //@future 
    public static void setupOpportunityB2C(){
        Account b2cAccount = [SELECT Id,BillingCountryCode,BillingCountry,BillingStateCode,BillingCity,
                              BillingPostalCode,BillingStreet,BillingLatitude,BillingLongitude 
                              from Account where Id =:b2cAccountId];
        // Create B2C Opportunity
        Opportunity b2cOpp1 = new Opportunity(Name='B2C Opportunity 1',
                                            StageName='Quoting',
                                            CloseDate=system.Today()+10,
                                            Pricebook2Id=pricebookId,
                                            AccountId = b2cAccount.Id,
                                            Organization__c = 'LSU',
                                            //Country_Attribute__c,
                                            Business_Type__c ='Consumer',
                                            District__c = 'FI_North',
                                            Order_Type__c = 'Normal',
                                            Property_Type__c = 'APA' //Apartment
                                            );
        insert b2cOpp1;
        
        System.debug('--- setupOpportunityB2C - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- setupOpportunityB2C - Queries used: '+LIMITS.getQueries());
    }
    //@future 
    public static void setupReclamationB2C(){
        // Create B2C Opportunity
        Opportunity b2cOpp2 = new Opportunity(Name='B2C Opportunity 1',
                                            StageName='Quoting',
                                            CloseDate=system.Today()+10,
                                            Pricebook2Id=pricebookId,
                                            AccountId = b2cAccountId,
                                            Organization__c = 'LSU',
                                            //Country_Attribute__c,
                                            Business_Type__c ='Consumer',
                                            District__c = 'FI_North',
                                            Order_Type__c = 'Reclamation'
                                            );
        insert b2cOpp2;
        System.debug('--- setupReclamationB2C - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- setupReclamationB2C - Queries used: '+LIMITS.getQueries());
    }
    //@future 
    public static void setupOpportunityB2B(){
        // Create B2B Opportunity
        Opportunity b2bOpp1 = new Opportunity(Name='B2B Opportunity 1',
                                            StageName='Quoting',
                                            CloseDate=system.Today()+10,
                                            Pricebook2Id=pricebookId,
                                            AccountId = b2bAccountId
                                            );
        insert b2bOpp1;
        System.debug('--- Setup B2B Opportunity - Queries used: ' + LIMITS.getQueries());
    }
    @future public static void setupQuoteB2C(){
        // Create B2C Quote
        Id b2bOpportunityId = [SELECT Id FROM Opportunity WHERE (Account.IsPersonAccount = false)]?.Id;
        System.debug('--- setupQuoteB2C - Opportunity to Sync: '+b2cOpportunityId);
        Quote b2cQuote1 = new Quote( //Added Non-syncing Quote -> Oppty not updated with this Id as syncedQuoteId
                                            Name='B2C Standalone Quote',
                                            Status='Configure',
                                            Pricebook2Id=pricebookId,
                                            OpportunityId=b2cOpportunityId
                                            );
        insert b2cQuote1;
        System.debug('--- setupQuoteB2C - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- setupQuoteB2C - Queries used: '+LIMITS.getQueries());
    }
    @future public static void setupSyncedQuoteB2C(){
        // Broken
        // Create B2C Quote
        Quote b2cSyncedQuote1 = new Quote( //Added Syncing Quote -> Oppty not updated with this Id as syncedQuoteId
                                            Name='B2C Synced Quote',
                                            Status='Configure',
                                            Pricebook2Id=pricebookId,
                                            OpportunityId=b2cOpportunityId
                                            );
        insert b2cSyncedQuote1;
        Opportunity oppty = [SELECT Id,SyncedQuoteId FROM Opportunity WHERE Id =: b2cOpportunityId];
        System.debug('--- setupSyncedQuoteB2C - Opportunity '+oppty+' before Syncing');
        System.debug('--- setupSyncedQuoteB2C - Quote '+b2cSyncedQuote1+' before Syncing');
        oppty.SyncedQuoteId = b2cSyncedQuote1.Id;
        update oppty;
        System.debug('--- setupSyncedQuoteB2C - Opportunity '+oppty+' after Syncing');
        System.debug('--- setupSyncedQuoteB2C - Quote '+b2cSyncedQuote1+' after Syncing');
        System.debug('--- setupSyncedQuoteB2C - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- setupSyncedQuoteB2C - Queries used: '+LIMITS.getQueries());
    }
    @future public static void setupQuoteB2B(){
        // Create B2B Quote
        Quote b2bQuote1 = new Quote( //Added Non-syncing Quote -> Oppty not updated with this Id as syncedQuoteId
                                            Name='B2B Standalone Quote',
                                            Status='Configure',
                                            Pricebook2Id=pricebookId,
                                            OpportunityId=b2bOpportunityId
                                            );
        insert b2bQuote1;
        System.debug('--- setupQuoteB2B - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- setupQuoteB2B - Queries used: '+LIMITS.getQueries());
    }
    @future public static void setupSyncedQuoteB2B(){
        // Create B2B Quote
        Quote b2bSyncedQuote1 = new Quote( //Added Syncing Quote -> Oppty not updated with this Id as syncedQuoteId
                                            Name='B2B Synced Quote',
                                            Status='Configure',
                                            Pricebook2Id=pricebookId,
                                            OpportunityId=b2bOpportunityId
                                            );
        insert b2bSyncedQuote1;
        Opportunity oppty = [SELECT Id,SyncedQuoteId FROM Opportunity WHERE Id =: b2bOpportunityId];
        oppty.SyncedQuoteId = b2bSyncedQuote1.Id;
        update oppty;
        System.debug('--- setupSyncedQuoteB2C - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- setupSyncedQuoteB2C - Queries used: '+LIMITS.getQueries());
    }
    @future public static void setupQuoteLineItemsB2C() {
        List<QuoteLineItem> quoteLineItems = new List<QuoteLineItem>();
        for (Integer i = 0; i<pricebookEntries.size();i++) {
            QuoteLineItem qli = new QuoteLineItem(QuoteId=b2cSyncedQuoteId,
                                                    Product2Id=pricebookEntries[i].Product2Id,
                                                    PricebookEntryId=pricebookEntries[i].Id,
                                                    Quantity=1,
                                                    UnitPrice=1);
            quoteLineItems.add(qli);
        }
        insert quoteLineItems;
    }
    @future public static void setupSyncedQuoteLineItemsB2C() {
        List<QuoteLineItem> quoteLineItems = new List<QuoteLineItem>();
        for (Integer i = 0; i<pricebookEntries.size();i++) {
            QuoteLineItem qli = new QuoteLineItem(QuoteId=b2cSyncedQuoteId,
                                                    Product2Id=pricebookEntries[i].Product2Id,
                                                    PricebookEntryId=pricebookEntries[i].Id,
                                                    Quantity=1,
                                                    UnitPrice=1);
            quoteLineItems.add(qli);
        }
        insert quoteLineItems;
    }
    @future public static void setupQuoteLineItemsB2B() {
        List<QuoteLineItem> quoteLineItems = new List<QuoteLineItem>();
        Id b2bOpportunity = [SELECT Id FROM Opportunity WHERE (Account.IsPersonAccount = false)]?.Id;
        Id syncedQuote = [SELECT Id FROM Quote WHERE (Account.IsPersonAccount = false AND OpportunityId =: b2bOpportunity AND IsSyncing = true)]?.Id;
        for (Integer i = 0; i<pricebookEntries.size();i++) {

            QuoteLineItem qli = new QuoteLineItem(QuoteId=b2bQuoteId,
                                                    Product2Id=pricebookEntries[i].Product2Id,
                                                    PricebookEntryId=pricebookEntries[i].Id,
                                                    Quantity=1,
                                                    UnitPrice=1);
            quoteLineItems.add(qli);
        }
        insert quoteLineItems;
    }
    @future public static void setupSyncedQuoteLineItemsB2B() {
        List<QuoteLineItem> quoteLineItems = new List<QuoteLineItem>();
        for (Integer i = 0; i<pricebookEntries.size();i++) {
            QuoteLineItem qli = new QuoteLineItem(QuoteId=b2bSyncedQuoteId,
                                                    Product2Id=pricebookEntries[i].Product2Id,
                                                    PricebookEntryId=pricebookEntries[i].Id,
                                                    Quantity=1,
                                                    UnitPrice=1);
            quoteLineItems.add(qli);
        }
        insert quoteLineItems;
    }
    @future public static void setupContractB2C(){
        // Create B2C Contract
        Id b2cOpportunityId = [SELECT Id FROM Opportunity WHERE (Account.IsPersonAccount = true)]?.Id;
        Id finalContractRecordTypeId= [SELECT Id FROM RecordType WHERE (Name='Final Contract') and (SobjectType='Contract')].Id;
        System.debug('--- setupContractB2C - Opportunity: '+b2cOpportunityId);
        Contract b2cContract1 = new Contract(  Name='B2C Contract',
                                            Status='Draft',
                                            AccountId=b2cAccountId,
                                            Pricebook2Id=pricebookId,
                                            Opportunity__c=b2cOpportunityId,
                                            //BillingAddress,
                                            //ShippingAddress,
                                            ContractTerm=1
                                            );
        insert b2cContract1;
        System.debug('--- setupContractB2C - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- setupContractB2C - Queries used: '+LIMITS.getQueries());
    }
    @future public static void setupOrderB2C(){
        // Create B2C Order
        Id b2cOpportunityId = [SELECT Id FROM Opportunity WHERE (Account.IsPersonAccount = true) And Id =: b2cOpportunityId]?.Id;
        System.debug('--- setupOrderB2C - Opportunity: '+b2cOpportunityId);
        Order b2cOrder1 = new Order( 
                                            Name='B2C Order',
                                            Status='Draft',
                                            //Type='Normal',
                                            Pricebook2Id=pricebookId,
            								AccountId=b2cAccountId,
                                            OpportunityId=b2cOpportunityId,
                                            ContractId=b2cContractId,
                                            QuoteId=b2cSyncedQuoteId,
            								EffectiveDate=system.Today()+1
                                            );
        insert b2cOrder1;
        System.debug('--- setupOrderB2C - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- setupOrderB2C - Queries used: '+LIMITS.getQueries());
    }
    @future public static void setupOrderItemsB2C() {
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
    }
    /*public static void setupMainProjectB2C(){
        // Create B2C Main Project
        Id b2bOpportunityId = [SELECT Id FROM Opportunity WHERE (Account.IsPersonAccount = false)]?.Id;
        System.debug('--- setupMainProjectB2C - Opportunity: '+b2cOpportunityId);
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
        System.debug('--- setupMainProjectB2C - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- setupMainProjectB2C - Queries used: '+LIMITS.getQueries());
    }*/
    public static void setupOpportunityProductsB2C() {
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
    }
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

    public static void setupPriceParameters() {
        Factory_Price__c fp1 = new Factory_Price__c();
        fp1.Organization__c = 'LSU';
        fp1.Country__c = 'FI';
        fp1.Business_Type__c = 'Consumer';
        fp1.Product_Group__c = 'LGS';
        fp1.Cost_Type__c = 'asennus';
        fp1.Factory_Multiplier__c = 10.0;
        fp1.IsActive__c  = true;
        Factory_Price__c fp2 = new Factory_Price__c();
        fp2.Organization__c = 'LSU';
        fp2.Country__c = 'FI';
        fp2.Business_Type__c = 'Consumer';
        fp2.Product_Group__c = 'LG';
        fp2.Cost_Type__c = 'tuotteet';
        fp2.Factory_Multiplier__c = 10.0;
        fp2.IsActive__c  = true;
        Factory_Price__c fp3 = new Factory_Price__c();
        fp3.Organization__c = 'LSU';
        fp3.Country__c = 'FI';
        fp3.Business_Type__c = 'Reseller';
        fp3.Product_Group__c = 'LG';
        fp3.Cost_Type__c = 'tuotteet';
        fp3.Factory_Multiplier__c = 10.0;
        fp3.IsActive__c  = true;
        insert new List<Factory_Price__c>{fp1,fp2,fp3};
        Product_Cost__c pc1 = new Product_Cost__c();
        pc1.Organization__c = 'LSU';
        pc1.Country__c = 'FI';
        pc1.Business_Type__c = 'Consumer';
        pc1.District__c = 'FI_North';
        pc1.Product_Group__c = 'LG';
        pc1.Cost_Type__c = 'asennus';
        pc1.Cost_Multiplier__c = 20.0;
        pc1.IsActive__c  = true;
        Product_Cost__c pc2= new Product_Cost__c();
        pc2.Organization__c = 'LSU';
        pc2.Country__c = 'FI';
        pc2.Business_Type__c = 'Consumer';
        pc2.District__c = 'FI_North';
        pc2.Product_Group__c = 'LG';
        pc2.Cost_Type__c = 'tuotteet';
        pc2.Cost_Multiplier__c = 20.0;
        pc2.IsActive__c  = true;
        Product_Cost__c pc3= new Product_Cost__c();
        pc3.Organization__c = 'LSU';
        pc3.Country__c = 'FI';
        pc3.Business_Type__c = 'Reseller';
        pc3.District__c = 'FI_North';
        pc3.Product_Group__c = 'LG';
        pc3.Cost_Type__c = 'tuotteet';
        pc3.Cost_Multiplier__c = 20.0;
        pc3.IsActive__c  = true;
        insert new List<Product_Cost__c>{pc1,pc2,pc3};
        Sales_Price__c sp1 = new Sales_Price__c();
        sp1.Organization__c = 'LSU';
        sp1.Country__c = 'FI';
        sp1.Business_Type__c = 'Consumer';
        sp1.District__c = 'FI_North';
        sp1.Product_Group__c = 'LG';
        sp1.Profit_Center__c = '4043 LSU Oulu';
        sp1.Cost_Type__c = 'tuotteet';
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
        sp2.Cost_Type__c = 'tuotteet';
        sp2.Sales_Multiplier__c = 30.0;
        sp2.IsActive__c  = true;
        Sales_Price__c sp3 = new Sales_Price__c();
        sp3.Organization__c = 'LSU';
        sp3.Country__c = 'FI';
        sp3.Business_Type__c = 'Reseller';
        sp3.District__c = 'FI_North';
        sp3.Product_Group__c = 'LG';
        sp3.Profit_Center__c = '4043 LSU Oulu';
        sp3.BusinessId__c = '1234-56';
        sp3.Cost_Type__c = 'tuotteet';
        sp3.Sales_Multiplier__c = 30.0;
        sp3.IsActive__c  = true;
        insert new List<Sales_Price__c>{sp1,sp2,sp3};
    }
    //@future 
    public static void setupGlazingRetractable() {
        Factory_Price__c fp1 = new Factory_Price__c();
        fp1.Organization__c = 'LSU';
        fp1.Country__c = 'FI';
        fp1.Business_Type__c = 'Consumer';
        fp1.Product_Group__c = 'LG';
        fp1.Cost_Type__c = 'tuotteet';
        fp1.Factory_Multiplier__c = 10.0;
        fp1.IsActive__c  = true;
        Factory_Price__c fp2 = new Factory_Price__c();
        fp2.Organization__c = 'LSU';
        fp2.Country__c = 'FI';
        fp2.Business_Type__c = 'Consumer';
        fp2.Product_Group__c = 'LG';
        fp2.Cost_Type__c = 'verhot';
        fp2.Factory_Multiplier__c = 10.0;
        fp2.IsActive__c  = true;
        insert new List<Factory_Price__c>{fp1,fp2};
        Product_Cost__c pc1 = new Product_Cost__c();
        pc1.Organization__c = 'LSU';
        pc1.Country__c = 'FI';
        pc1.Business_Type__c = 'Consumer';
        pc1.District__c = 'FI_North';
        pc1.Product_Group__c = 'LG';
        pc1.Cost_Type__c = 'rahti';
        pc1.Cost_Multiplier__c = 20.0;
        pc1.IsActive__c  = true;
        Product_Cost__c pc2= new Product_Cost__c();
        pc2.Organization__c = 'LSU';
        pc2.Country__c = 'FI';
        pc2.Business_Type__c = 'Consumer';
        pc2.District__c = 'FI_North';
        pc2.Product_Group__c = 'LG';
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
        sp2.Product_Group__c = 'LG';
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
        sp3.Product_Group__c = 'LG';
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
        sp4.Product_Group__c = 'LG';
        sp4.Profit_Center__c = '4043 LSU Oulu';
        sp4.BusinessId__c = '1234-56';
        sp4.Cost_Type__c = 'asennus';
        sp4.Sales_Multiplier__c = 30.0;
        sp4.IsActive__c  = true;
        insert new List<Sales_Price__c>{sp1,sp2,sp3,sp4};
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
        System.debug('--- LG product: '+p1);
        System.debug('--- LGS product: '+p2);
        System.debug('--- COST product: '+p3);
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
    @future public static void setupPricingSummaryB2C() {
        Opportunity opp = [SELECT Id, AccountId,SyncedQuoteId,Organization_Attribute__c, Country_Attribute__c, Business_Type_Attribute__c,District_Attribute__c,  Owner_Profit_Center__c FROM Opportunity WHERE Id =: b2cOpportunityId];
        Pricing_Summary__c summary = new Pricing_Summary__c();
        summary.Account__c = opp.AccountId; // Related Record
        summary.Quote__c = opp.SyncedQuoteId; // Related Record
        summary.Opportunity__c = b2cOpportunityId; // Related Record
        summary.Organization__c = opp.Organization_Attribute__c; // Related Record
        summary.Country_Code__c = opp.Country_Attribute__c; // Related Record
        summary.Business_Type__c = opp.Business_Type_Attribute__c;
        summary.District__c = opp.District_Attribute__c; // Related Record
        summary.Profit_Center__c = opp.Owner_Profit_Center__c; // Related Record
        //summary.Office__c = opportunityRecord.Office__c; // Related Record        
        //summary.User__c = opportunityRecord.OwnerId;// Related Record        
        //summary.Order__c; // Related Record
        //summary.Contract__c; // Related Record
        summary.currencyIsoCode = 'EUR';

        insert summary;
    }
    /***************** Custom Objects ********************/
	public static void setupProductionTimes() {
        Factory__c factory = new Factory__c(Name = 'Test Factory');
        insert factory;
        List<Production_Time__c> productionTimes = new List<Production_Time__c>();
        List<Product2> products = [SELECT Id FROM product2 WHERE Product_Category__c = :'Product Groups'];
        for (Integer i = 0; i<products.size();i++) {
            Production_Time__c productionTime = new Production_Time__c(
                			Factory__c=factory.Id,
                            Days__c=20,
                			Extra_Days__c=0,
                            Product__c=products[i].Id,
                            IsActive__c=true
            );
            productionTimes.add(productionTime);
        }
        List<Product2> productOptions = [SELECT Id FROM product2 WHERE Product_Category__c = :'Product Options'];
        for (Integer j = 0; j<productOptions.size();j++) {
            Production_Time__c productionTime = new Production_Time__c(
                			Factory__c=factory.Id,
                            Days__c=0,
                			Extra_Days__c=1,
                            Product__c=productOptions[j].Id,
                            IsActive__c=true
            );
            productionTimes.add(productionTime);
        }
        insert productionTimes;
    }
    @future public static void setupInstallationTimes() {
        List<Installation_Time__c> installationTimes = new List<Installation_Time__c>();
        List<Product2> products = [SELECT Id FROM product2 WHERE Product_Category__c = :'Product Options'];
        for (Integer i = 0; i<products.size();i++) {
            Installation_Time__c installTime = new Installation_Time__c(
                            Hours__c=1,
                            Product__c=products[i].Id,
                            IsActive__c=true
             
            );
            //System.debug('Adding Installation Time: '+installTime);  
            installationTimes.add(installTime);
        }
        insert installationTimes;
    }
    @future public static void setupConfigurationB2C() {
        if (String.isBlank(b2cOpportunityId)){
            System.debug('No Parent Opportunity created');
        }
        // Create Parent Config B2C
        Configuration__c b2cConfigPlan1 = new Configuration__c(
                                            Opportunity__c = b2cOpportunityId,
                                            Name='B2C Configuration 1',
                                            Plan_Apartment__c = 'C1',// public String apartment; // Door Nbr in Apartment
                                            Plan_Floor__c = 6,// public Integer floor; // Floor Nbr in Building
                                            Visual_Id__c = 'B2C-ABCDE1',//public String Id; // Unique Visual Configuration Id
                                            Plan_Line__c = '100',// public String line; //?
                                            Plan_Name__c = 'B2C Plan 1',// public String name; // Name of the Configuration
            								Plan_Type__c = 'Visual',
                                            //public List<Products> products; // Product Model aka Configurable Product
                                            Visual_Version__c = 1);//public Integer version; // Configuration Version);
        Configuration__c b2cConfigPlan2 = new Configuration__c(
                                            Opportunity__c = b2cOpportunityId,
                                            Name='B2C Configuration 2',
                                            Plan_Apartment__c = 'C2',// public String apartment; // Door Nbr in Apartment
                                            Plan_Floor__c = 6,// public Integer floor; // Floor Nbr in Building
                                            Visual_Id__c = 'B2C-ABCDE2',//public String Id; // Unique Visual Configuration Id
                                            Plan_Line__c = '200',// public String line; //?
                                            Plan_Name__c = 'B2C Plan 2',// public String name; // Name of the Configuration
                                            //public List<Products> products; // Product Model aka Configurable Product
                                            Visual_Version__c = 1);//public Integer version; // Configuration Version);
        upsert b2cConfigPlan1;
        upsert b2cConfigPlan2;


        System.debug('--- setupConfigurationB2C - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- setupConfigurationB2C - Queries used: '+LIMITS.getQueries());
    }
    @future public static void setupConfigurationProductsB2C() {
        // Create Parent Config B2C
        List<Configuration_Product__c> configProducts = new List<Configuration_Product__c>();
        List<Product2> prodList = new List<Product2>([SELECT Product_Group__c,Id FROM Product2 WHERE Product_Category__c = 'Product Groups' AND IsActive  = TRUE AND Name IN ('Test Product 1 Installation','Test Product 2 Reclamation')]);
        System.debug('*** prodList ***'+prodList);
        Map<String,Product2> productGroupMap = new Map<String,Product2>();
        for(Product2 prod : prodList){
            productGroupMap.put(prod.Product_Group__c,prod);
        }
        System.debug('*** productGroupMap ***'+b2cConfigurations);
        for (Integer i = 0; i<b2cConfigurations.size();i++){
            for (Integer counter=1;counter<4;counter++) {
                String RVN = 'B2C-'+i+'-'+counter;
                String productGroup;
                
                switch on counter {
                    when 1 {productGroup = 'LG';}
                    when 2 {productGroup = 'LG';}
                    when 3 {productGroup = 'LG';}
                }
                System.debug('*** productGroup ***'+productGroup);
                System.debug('*** productGroupMap 2 ***'+productGroupMap);
                Configuration_Product__c configProduct = new Configuration_Product__c(
                                            Name=productGroup, //public String name; // Name of the Product Model
                                            Configuration__c = b2cConfigurations[i].Id, // Parent Configuration
                                            Quantity__c = i*counter, // Amount must be 1 for each Product in a configuration
                                            Product_Group__c = productGroup,
                    						Product__c = productGroupMap.get(productGroup).Id,
                    						Features_Confirmed__c = False,//public Boolean hasFeaturesBeenConfirmed;
                                            Measurements_Verified__c = False,// public Boolean hasMeasurementsBeenVerified;
                                            Visual_Product_Id__c = 'b2c-'+productGroup+'-'+counter,//public String Id; // Product Code of Product Model
                                            Inspection_Code__c = 2,//public Integer productInspectCode;
                                            Product_Length__c = 2.5, //public Double productLength;
                                            RVN_Number__c = RVN); // public String rvn; //ProjectNbr + Structure);

                configProducts.add(configProduct);
            }
        }
        System.debug('*** configProducts ***'+configProducts);
        upsert configProducts;
        System.debug('--- setupConfigurationProductsB2C - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- setupConfigurationProductsB2C - Queries used: '+LIMITS.getQueries());
    }
    @future public static void setupConfigurationOptionsB2C() {
        List<Configuration_Option__c> b2cConfigOptions = new List<Configuration_Option__c>();
        // Create B2C
        for (Integer i = 0; i <b2cConfigProducts.size();i++) {
            Configuration_Option__c b2cConfigOption1 = new Configuration_Option__c(
                                            Name='LG Option 1',
                                            Configuration_Product__c = b2cConfigProducts[i].Id,
                                            //Product_Group__c = 'LG',
                                            Quantity__c = 11.11, //public Double Amount;
                                            Local_Supplier__c = FALSE, //public Boolean LocalSupplier;
                                            Parameter_code__c = 'param1',// public String ParameterCode;
                                            Product_Code__c = 'LG-Option1',// public String SalesCode;
                                            Sales_Code__c = 'Option1',// public String SalesCode;
                                            Unique_Id__c = '1-LG-Option1-11.11',// public Integer UniqueId;
                                            Unit_Of_Measure__c = 'M');//public String Unit
                                            //RVN_Number__c = 'B2C-1-1'// (oppty Number+) Visual Structure nbr
            Configuration_Option__c b2cConfigOption2 = new Configuration_Option__c(
                                            Name='LG Option 2',
                                            Configuration_Product__c = b2cConfigProducts[i].Id,
                                            //Product_Group__c = 'LG',
                                            Quantity__c = 22.22, //public Double Amount;
                                            Local_Supplier__c = FALSE, //public Boolean LocalSupplier;
                                            Parameter_code__c = 'param2',// public String ParameterCode;
                                            Product_Code__c = 'LG-Option2',// public String SalesCode;
                                            Sales_Code__c = 'Option2',// public String SalesCode;
                                            Unique_Id__c = '2-LG-Option2-22.22',// public Integer UniqueId;
                                            Unit_Of_Measure__c = 'M');//public String Unit
                                            //RVN_Number__c = 'B2C-1-1'// (oppty Number+) Visual Structure nbr
             b2cConfigOptions.add(b2cConfigOption1);
             b2cConfigOptions.add(b2cConfigOption2);
        }
        upsert b2cConfigOptions;
        System.debug('--- setupConfigurationOptionsB2C - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- setupConfigurationOptionsB2C - Queries used: '+LIMITS.getQueries());
    }
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
        System.debug('--- setupConfigurationMessagesB2C - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- setupConfigurationMessagesB2C - Queries used: '+LIMITS.getQueries());
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
            Plan_Floor__c = 6,// public Integer floor; // Floor Nbr in Building
            Visual_Id__c = 'B2C-ABCDE3',//public String Id; // Unique Visual Configuration Id
            Plan_Line__c = '100',// public String line; //?
            Plan_Name__c = 'B2C Plan 3',// public String name; // Name of the Configuration
            //public List<Products> products; // Product Model aka Configurable Product
            Visual_Version__c = 3);//public Integer version; // Configuration Version);
        insert b2cConfigurationPlan;
        String b2cConfigurationPlanId = b2cConfigurationPlan.Id;
        System.debug('--- setupVisualImageDocument - Plan: '+b2cConfigurationPlan);
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
        System.debug('--- setupVisualImageDocument - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- setupVisualImageDocument - Queries used: '+LIMITS.getQueries());
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
            Plan_Floor__c = 6,// public Integer floor; // Floor Nbr in Building
            Visual_Id__c = 'B2C-ABCDE3',//public String Id; // Unique Visual Configuration Id
            Plan_Line__c = '100',// public String line; //?
            Plan_Name__c = 'B2C Plan 3',// public String name; // Name of the Configuration
            //public List<Products> products; // Product Model aka Configurable Product
            Visual_Version__c = 3);//public Integer version; // Configuration Version);
        insert b2cConfigurationPlan;
        String b2cConfigurationPlanId = b2cConfigurationPlan.Id;
        System.debug('--- setupVisualImageDocument - Plan: '+b2cConfigurationPlan);
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
        System.debug('--- setupVisualPricingDocument - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- setupVisualPricingDocument - Queries used: '+LIMITS.getQueries());
    }
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
    }
    /*public static void setupSalesObjects(){
        System.debug('--- Setup B2C PriceRecords at Start - Number of Queries used in this apex code so far: ' + Limits.getQueries());
        Product2 p1 = new Product2(Name='Test Pricing Product 4', IsActive=True,ProductCode='LG',Product_Category__c='Product Groups');
        insert p1;
        Id pbid = Test.getStandardPricebookId();
        PricebookEntry pbe1 = new PricebookEntry(Pricebook2Id=pbid, Product2Id=p1.Id, UnitPrice=1, IsActive=True,CurrencyIsoCode = 'EUR');
        insert pbe1;
        String B2CRecordTypeId= [SELECT Id FROM RecordType WHERE (Name='B2C Account') and (SobjectType='Account')].Id;
        System.debug('--- Setup B2C Account Record Types - Number of Queries used in this apex code so far: ' + Limits.getQueries());
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
        System.debug('--- Setup B2C Opportunity - Number of Queries used in this apex code so far: ' + Limits.getQueries());
        Opportunity o1 = new Opportunity(
                                    Name='B2C Opportunity',
                                    StageName='Quoting',
                                    CloseDate=system.Today()+10,
                                    Pricebook2Id=pbid,
                                    Property_Type__c = 'ROW',
                                    AccountId = pa1.Id
                                    );
        insert o1;
        System.debug('--- Setup B2C Quote - Number of Queries used in this apex code so far: ' + Limits.getQueries());
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
    public static void setupFieldServices(){
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
                System.debug('--- FSL Admin Permissions already assigned');
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
}
public static void setupNormalOrderB2C(){
    // Create B2C Order
    System.debug('---- setupOrderB2C - Opportunity: '+b2cOpportunityId);
    Order b2cOrder1 = new Order( Name='B2C Normal Order',
                                        Status='Draft',
                                        Pricebook2Id=pricebookId,                                  
                                        AccountId=b2cAccountId,
                                        OpportunityId=b2cOpportunityId,
                                        QuoteId=b2cQuoteId,
                                        Type='Normal'
                                        );
    insert b2cOrder1;
    System.debug('---- setupOrderB2C - CPU TIME: '+LIMITS.getCpuTime());
    System.debug('---- setupOrderB2C - Queries used: '+LIMITS.getQueries());
}
public static void setupSpecialOrderB2C(){
    // Create B2C Special Order
    System.debug('---- setupSpecialOrderB2C - Opportunity: '+b2cOpportunityId);
    Order b2cOrder2 = new Order( Name='B2C Special Order',
                                        Status='Draft',
                                        Pricebook2Id=pricebookId,
                                        AccountId=b2cAccountId,
                                        OpportunityId=b2cOpportunityId,
                                        QuoteId=b2cQuoteId,
                                        Type='Special'
                                        );
    insert b2cOrder2;
    System.debug('---- setupSpecialOrderB2C - CPU TIME: '+LIMITS.getCpuTime());
    System.debug('---- setupSpecialOrderB2C - Queries used: '+LIMITS.getQueries());
}
public static void setupReclamationOrderB2C(){
    // Create B2C Reclamation Order
    System.debug('---- setupReclamationOrderB2C - Opportunity: '+b2cOpportunityId);
    Order b2cOrder3 = new Order( Name='B2C Reclamation Order',
                                        Status='Draft',
                                        Pricebook2Id=pricebookId,                                 
                                        AccountId=b2cAccountId,
                                        OpportunityId=b2cOpportunityId,
                                        QuoteId=b2cQuoteId,
                                        Type='Reclamation'
                                        );
    insert b2cOrder3;
    System.debug('---- setupReclamationOrderB2C - CPU TIME: '+LIMITS.getCpuTime());
    System.debug('---- setupReclamationOrderB2C - Queries used: '+LIMITS.getQueries());
}
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