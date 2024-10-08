/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 06-04-2024
 * @last modified by  : Henk Reynders
**/
@IsTest
public with sharing class PricingSummaryServiceTest {
    private static Id b2cAccountId = LumonTestDataFactory.b2cAccountId;
    private static Id b2cOpportunityId = LumonTestDataFactory.b2cOpportunityId;
    private static Id b2cSyncedQuoteId = LumonTestDataFactory.b2cSyncedQuoteId;
    private static Id b2cQuoteId = LumonTestDataFactory.b2cQuoteId;

    private static List<Configuration__c> b2cConfigurations = LumonTestDataFactory.b2cConfigurations;
    private static List<Configuration_Product__c> b2cConfigProducts = LumonTestDataFactory.b2cConfigProducts;
    private static List<Configuration_Option__c> b2cConfigOptions = LumonTestDataFactory.b2cConfigOptions;
    private static List<Configuration_Message__c> b2cConfigMessages = LumonTestDataFactory.b2cConfigMessages;
    
    @TestSetup
    static void prepareData() {
        Test.startTest();
        LumonTestDataFactory.setupProducts();
        LumonTestDataFactory.setupPriceParameters();
        LumonTestDataFactory.setupPriceBookEntries();
        // B2C Setup
        LumonTestDataFactory.setupAccountB2C();
        LumonTestDataFactory.setupOpportunityB2C();
        LumonTestDataFactory.setupPricingSummaryB2C();
        LumonTestDataFactory.setupSyncedQuoteB2C();        
        LumonTestDataFactory.setupConfigurationB2C();
        LumonTestDataFactory.setupConfigurationProductsB2C();
        LumonTestDataFactory.setupConfigurationOptionsB2C(); 
        LumonTestDataFactory.setupSyncedQuoteLineItemsB2C();
        Test.stopTest();
    }

    

    @IsTest
    static void queryOpportunityTest(){
        Test.startTest();
        Opportunity b2cOpportunity = PricingSummaryService.queryOpportunity(b2cOpportunityId);
        System.assertNotEquals(null, b2cOpportunity, 'Expecting a result');
        System.debug('--- PricingSummaryServiceTest - queryOpportunityTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- PricingSummaryServiceTest - queryOpportunityTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    } 
    @IsTest
    static void queryQuoteTest(){
        Test.startTest();
        Quote syncedQuote = PricingSummaryService.queryQuote(b2cSyncedQuoteId);
        System.assertNotEquals(null, syncedQuote, 'Expecting a result');
        System.debug('--- PricingSummaryServiceTest - queryQuoteTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- PricingSummaryServiceTest - queryQuoteTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    } 
    @IsTest
    static void getQuoteLineItemsTest(){
        Test.startTest();
        List<QuoteLineItem> quoteLines = PricingSummaryService.getQuoteLineItems(b2cSyncedQuoteId);
        System.assertNotEquals(0, quoteLines.size(), 'Expecting a result');
        System.debug('--- PricingSummaryServiceTest - getQuoteLineItemsTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- PricingSummaryServiceTest - getQuoteLineItemsTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    } 

    @IsTest
    static void queryPricingSummaryTest(){
        LumonTestDataFactory.setupPricingSummaryB2C();
        List<Pricing_Summary__c> summaries = [SELECT Id, Opportunity__c, Quote__c FROM Pricing_Summary__c];
        System.debug('--- PricingSummaryServiceTest - queryPricingSummaryTest - Summaries: '+summaries); 
        Test.startTest();
        System.debug('--- PricingSummaryServiceTest - queryPricingSummaryTest - Opportunity: '+b2cOpportunityId); 
        System.debug('--- PricingSummaryServiceTest - queryPricingSummaryTest - Synced Quote: '+b2cSyncedQuoteId); 
        Pricing_Summary__c summary = PricingSummaryService.queryPricingSummary(b2cOpportunityId,b2cSyncedQuoteId);
        System.assertNotEquals(null, summary, 'Expecting a result');
        System.debug('--- PricingSummaryServiceTest - queryPricingSummaryTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- PricingSummaryServiceTest - queryPricingSummaryTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest();
    } 
    @IsTest
    static void isAdminTest(){
        LumonTestDataFactory.setupAdminUser();
        Id adminUserId = LumonTestDataFactory.adminUser;
        System.Debug ('--- PricingSummaryServiceTest - isAdminTest - adminUserId '+adminUserId);
        System.Debug ('--- PricingSummaryServiceTest - isAdminTest - adminProfileId '+[SELECT Id FROM Profile WHERE Name='System Administrator']?.Id);
        System.Debug ('--- PricingSummaryServiceTest - isAdminTest - adminUser '+[SELECT Id FROM User WHERE(username='admin.testuser@email123.com')]?.Id);
        User adminUser = [SELECT Id,Name FROM User WHERE Id = :adminUserId];
        Test.startTest();
        System.Debug ('--- PricingSummaryServiceTest - isAdminTest - Runas Admin '+adminUser.Name);
        System.runAs(adminUser){
            boolean isAdminRole = PricingSummaryService.isAdmin();
            System.assertEquals(true, isAdminRole, 'Expecting a result');
            System.debug('--- PricingSummaryServiceTest - isAdminTest - CPU TIME: '+LIMITS.getCpuTime()); 
            System.debug('--- PricingSummaryServiceTest - isAdminTest - SOQL USED: ' + LIMITS.getQueries());
        }
        Test.stopTest();
    } 
    @IsTest
    static void isSalesTest(){
        LumonTestDataFactory.setupSalesUser();
        Id salesUserId = LumonTestDataFactory.salesUser;
        User salesUser = [SELECT Id,Name FROM User WHERE Id = :salesUserId];
        Test.startTest();
        System.Debug ('--- PricingSummaryServiceTest - isSalesTest - Runas Sales User '+salesUser.Name);
        System.runAs(salesUser){
            boolean isSalesRole = PricingSummaryService.isSales();
            System.assertEquals(true, isSalesRole, 'Expecting a result');
            System.debug('--- PricingSummaryServiceTest - isSalesTest - CPU TIME: '+LIMITS.getCpuTime()); 
            System.debug('--- PricingSummaryServiceTest - isSalesTest - SOQL USED: ' + LIMITS.getQueries());
        }
        Test.stopTest();
    } 
    @IsTest
    static void isManagerTest(){
        LumonTestUsers.setupSalesManagerUser();
        Id salesMgrId = LumonTestUsers.salesManagerUser?.Id;
        User salesMgr = [SELECT Id,Name FROM User WHERE Id = :salesMgrId];
        Test.startTest();
        System.Debug ('--- PricingSummaryServiceTest - isManagerTest - Runas Sales Manager '+salesMgr.Name);
        System.runAs(salesMgr){
            boolean isManagerRole = PricingSummaryService.isManager();
            System.assertEquals(true, isManagerRole, 'Expecting a result');
            System.debug('--- PricingSummaryServiceTest - isManagerTest - CPU TIME: '+LIMITS.getCpuTime()); 
            System.debug('--- PricingSummaryServiceTest - isManagerTest - SOQL USED: ' + LIMITS.getQueries());
        }
        Test.stopTest();
    } 
    @IsTest
    static void isSupportTest(){
        LumonTestUsers.setupTechnicalSupportUser();
        Id technicalSupportId = LumonTestUsers.technicalSupportUser?.Id;
        User technicalSupport = [SELECT Id,Name FROM User WHERE Id = :technicalSupportId];
        Test.startTest();
        System.Debug ('--- PricingSummaryServiceTest - isSupportTest - Runas Technical Support User '+technicalSupport.Name);
        System.runAs(technicalSupport){
            boolean isSupportRole = PricingSummaryService.isSupport();
            System.assertEquals(true, isSupportRole, 'Expecting a result');
            System.debug('--- PricingSummaryServiceTest - isSupportTest - CPU TIME: '+LIMITS.getCpuTime()); 
            System.debug('--- PricingSummaryServiceTest - isSupportTest - SOQL USED: ' + LIMITS.getQueries());
        }
        Test.stopTest();
    } 
    @IsTest
    static void isServiceTest(){
        LumonTestUsers.setupCustomerServiceUser();
        Id customerServiceId = LumonTestUsers.customerServiceUser?.Id;
        User customerService = [SELECT Id,Name FROM User WHERE Id = :customerServiceId];
        Test.startTest();
        System.Debug ('--- PricingSummaryServiceTest - isServiceTest - Runas Customer Support User '+customerService.Name);
        System.runAs(customerService){
            boolean isServiceRole = PricingSummaryService.isService();
            System.assertEquals(true, isServiceRole, 'Expecting a result');
            System.debug('--- PricingSummaryServiceTest - isServiceTest - CPU TIME: '+LIMITS.getCpuTime()); 
            System.debug('--- PricingSummaryServiceTest - isServiceTest - SOQL USED: ' + LIMITS.getQueries());
        }
        Test.stopTest();
    } 
    /*@IsTest
    static void isMarketeerTest(){
        LumonTestUsers.setupMarketingUser();
        Id marketeerId = LumonTestUsers.marketingUser?.Id;
        User marketeer = [SELECT Id,Name FROM User WHERE Id = :marketeerId];
        Test.startTest();
        System.Debug ('--- PricingSummaryServiceTest isMarketeerTest - Runas Marketing User '+marketeer.Name);
        System.runAs(marketeer){
            boolean isMarketingRole = PricingSummaryService.isMarketeer();
            System.assertEquals(true, isMarketingRole, 'Expecting a result');
            System.debug('--- PricingSummaryServiceTest isMarketeerTest - CPU TIME: '+LIMITS.getCpuTime()); 
            System.debug('--- PricingSummaryServiceTest isMarketeerTest - SOQL USED: ' + LIMITS.getQueries());
        }
        Test.stopTest();
    } */
    @IsTest
    public static void discountCPQSettingsTest() {
		List<User> adminUser = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator'
			AND UserRoleId != null
			AND IsActive = TRUE
			LIMIT 1
		];
        Id adminProfileId = [SELECT Id FROM Profile WHERE Profile.Name = 'System Administrator' LIMIT 1]?.Id;
        User user = new User();
        user.firstName = 'test';
        user.lastName = 'admin';
        user.profileId = adminProfileId;
        user.username = 'admin.test@lumon.com';
        user.email = 'admin@test.com';
        user.Alias = 'admin'; 
        user.TimeZoneSidKey = 'Europe/Helsinki';
        user.LocaleSidKey = 'fi_FI_EURO'; 
        user.EmailEncodingKey = 'UTF-8';
        user.LanguageLocaleKey = 'en_US';
        insert user;
        // Profile Setting
        CPQ_Settings__c setting1 = new CPQ_Settings__c();
        setting1.Name = 'Admin Profile Setting';
        setting1.SetupOwnerId = userinfo.getProfileId();
        setting1.debug__c = true;
        insert setting1;
        CPQ_Settings__c setting2 = new CPQ_Settings__c();
        setting2.Name = 'Admin User Setting';
        setting2.SetupOwnerId = userinfo.getUserId();
        setting2.maxDiscount__c = 0.10;
        insert setting2;
        CPQ_Settings__c setting3 = new CPQ_Settings__c();
        setting3.Name = 'Organization Setting';
        setting3.SetupOwnerId = userinfo.getOrganizationId();
        setting3.debug__c = true;
        insert setting3;
        String errorMessage;
        Test.startTest();     
        try {
            System.Debug ('----QuotingManagerCPQSettingsTest- Runas '+user.name);
            System.runAs(user){
            CPQ_Settings__c cpqSettings = CPQSettingsController.getCPQSettings();
            }
        } catch (Exception e) {
            //Any other exceptions that occur will go here
            errorMessage = e.getMessage(); 
            System.Debug ('----QuotingManagerCPQSettingsTest - An Exception Occured:'+errorMessage);
        }
        System.assertEquals(null,errorMessage, 'Expected to find CPQ Settings');
        Boolean isDebug  = PricingSummaryService.isDebug();
		Decimal maxDiscount  = PricingSummaryService.maxDiscount();
        System.debug('----QuotingManagerCPQSettingsTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('----QuotingManagerCPQSettingsTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest(); 
    } 
    @IsTest
    public static void QuotingManagerRoleSettingsTest() {
        List<User> adminUser = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator'
			AND UserRoleId != null
			AND IsActive = TRUE
			LIMIT 1
		];
        Id adminProfileId = [SELECT Id FROM Profile WHERE Profile.Name = 'System Administrator' LIMIT 1]?.Id;
        User user = new User();
        user.firstName = 'test';
        user.lastName = 'admin';
        user.profileId = adminProfileId;
        user.username = 'admin.test@lumon.com';
        user.email = 'admin@test.com';
        user.Alias = 'admin'; 
        user.TimeZoneSidKey = 'Europe/Helsinki';
        user.LocaleSidKey = 'fi_FI_EURO'; 
        user.EmailEncodingKey = 'UTF-8';
        user.LanguageLocaleKey = 'en_US';
        insert user;
        // Profile Setting
        Role_Settings__c setting1 = new Role_Settings__c();
        setting1.Name = 'Admin Profile Setting';
        setting1.SetupOwnerId = userinfo.getProfileId();
        setting1.isAdmin__c = true;
        insert setting1;
        Role_Settings__c setting2 = new Role_Settings__c();
        setting2.Name = 'Admin User Setting';
        setting2.SetupOwnerId = userinfo.getUserId();
        setting2.isAdmin__c = false;
        insert setting2;
        Role_Settings__c setting3 = new Role_Settings__c();
        setting3.Name = 'Organization Setting';
        setting3.SetupOwnerId = userinfo.getOrganizationId();
        setting3.isAdmin__c = true;
        insert setting3;
        String errorMessage;
        Test.startTest();     
        try {
            System.runAs(user){
            Role_Settings__c roleSettings = RoleSettingsController.getRoleSettings();
            }
        } catch (Exception e) {
            //Any other exceptions that occur will go here
            errorMessage = e.getMessage(); 
            System.Debug ('----QuotingManagerRoleSettingsTest - An Exception Occured:'+errorMessage);
        }
        System.assertEquals(null,errorMessage, 'Expected to find Role Settings');
        System.debug('----QuotingManagerRoleSettingsTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('----QuotingManagerRoleSettingsTest - SOQL USED: ' + LIMITS.getQueries());
        Test.stopTest(); 
    } 
    
    @IsTest
    public static void findPricesTest() {
        String errorMessage;
        List<User> salesUsers = [SELECT Id FROM User WHERE(username='sales.testuser@email123.com') LIMIT 1];
        if (salesUsers.size()!=1) {
        	LumonTestDataFactory.setupSalesUser();
        }
        Id salesUserId = LumonTestDataFactory.salesUser;        
        User salesUser = [SELECT Id, Country, CountryCode, District__c, Profit_Center__c  FROM User WHERE Id = :salesUserId];
        Opportunity opp = [SELECT Id,AccountId, SyncedQuoteId,
                                    Organization__c,Business_Type__c ,
                                    Country_Attribute__c,District__c,
                                    OwnerId, Owner_Profit_Center__c, Owner_Office__c
                            FROM Opportunity WHERE Id =:b2copportunityId LIMIT 1];
        Id accountId = opp.AccountId;
        Id quoteId = opp.SyncedQuoteId;
        Id owner = opp.OwnerId;
        String org = opp.Organization__c;
        String business = opp.Business_Type__c;
        String district = opp.District__c;
        String country = opp.Country_Attribute__c;
        String profit = opp.Owner_Profit_Center__c;
        String office = opp.Owner_Office__c;
        System.debug('----findPricesTest - Created Sales User: '+salesUser); 
        salesUser.CountryCode = country;
        salesUser.District__c = district;       
        salesUser.Profit_Center__c = profit;
        update salesUser;
        System.debug('----findPricesTest - Updated Sales User: '+salesUser);     

        /*public static QuoteLineItem findPrices(String opportunityId,String searchProductCode,Decimal itemQuantity,String itemProductGroup,String itemCostType) { */
        String searchProductCode = 'LG-PRODUCT';
        Decimal itemQuantity = 1;
        String itemProductGroup = 'LG';
        String itemCostType = 'tuotteet';
        System.debug('----findPricesTest - Opportunity: '+OpportunityController.getOpportunityRecord(b2cOpportunityId)); 
        Boolean hasItems = PricingSummaryService.opportunityHasProductItems(b2cSyncedQuoteId);
        Pricing_Summary__c summary = [SELECT Pricing_Changes__c FROM Pricing_Summary__c LIMIT 1];
        Test.startTest();
        try {
            System.runAs(salesUser){
            	QuoteLineItem qli = PricingSummaryService.findPrices(b2cOpportunityId, searchProductCode, itemQuantity, itemProductGroup, itemCostType);
                System.debug('----findPricesTest - QuoteLine Item: '+qli); 
       			System.AssertNotEquals(null,qli, 'Expected a quoteline to be returned');
            }
        } catch (Exception e) {
            //Any other exceptions that occur will go here
            errorMessage = e.getMessage(); 
            System.Debug ('----findPricesTest - An Exception Occured:'+errorMessage);
        }
        System.debug('----findPricesTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('----findPricesTest - SOQL USED: ' + LIMITS.getQueries());       
        Test.stopTest();
    }
    
    @IsTest
    public static void findProduct() {
        /*public static Product2 findProduct(String productId) { */
        Product2 p =[SELECT Id FROM Product2 LIMIT 1];

        Test.startTest();
        Product2 p2 = PricingSummaryService.findProduct(p.Id);
        
        System.AssertNotEquals(null,p2, 'Expected a product to be returned');
        System.debug('----findProductTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('----findProductTest - SOQL USED: ' + LIMITS.getQueries());           
        Test.stopTest();
    }
    @IsTest
    public static void findConfigurationTest() {
      

        //public static QuoteLineItem findConfiguration(Id opportunityId, String planType, QuoteLineItem quoteLineItem) {
		List<Configuration__c> plans =[SELECT Id,Plan_Type__c FROM Configuration__c];
        List<Id> configIds = new List<Id>(new Map<Id, Configuration__c>(plans).keySet()); 
        List<Configuration_Product__c> products =[SELECT Id,RVN__c FROM Configuration_Product__c WHERE Configuration__c IN:configIds];
        List<Id> configProductIds = new List<Id>(new Map<Id, Configuration_Product__c>(products).keySet()); 
        List<Configuration_Option__c> options =[SELECT Id,Configuration_Plan__c, Configuration_Product__c,Product__c FROM Configuration_Option__c WHERE Configuration_Product__c IN:configProductIds];
        List<Id> configOptionIds = new List<Id>(new Map<Id, Configuration_Option__c>(options).keySet()); 
        System.debug('--- PricingSummaryServiceTest - findConfigurationTest - plans: '+plans);
        System.debug('--- PricingSummaryServiceTest - findConfigurationTest - products: '+products);
        System.debug('--- PricingSummaryServiceTest - findConfigurationTest -  options: '+options);
        List<QuoteLineItem> items =[SELECT Id,Product2Id,Product2.ProductCode,Product2.Product_Group__c,Configuration_Plan__c, Configuration_Product__c, Configuration_Option__c FROM QuoteLineItem];
        System.debug('--- PricingSummaryServiceTest - findConfigurationTest - items: '+items);
        System.debug('--- PricingSummaryServiceTest - findConfigurationTest - option count: '+options.size());
        System.debug('--- PricingSummaryServiceTest - findConfigurationTest - item count: '+items.size());
        Integer i = 0;
        for (Configuration_Option__c option : options) {
            System.debug('--- PricingSummaryServiceTest - findConfigurationTest - Find Configuration Option '+i+': '+option);
            if (i<items.size()) {
                QuoteLineItem qli = items[i];
                if (i<options.size()) {
                    qli.Configuration_Plan__c = options[i].Configuration_Plan__c;
                    qli.Configuration_Product__c = options[i].Configuration_Product__c;
                    qli.Configuration_Option__c = options[i].Id;
                    System.debug('--- PricingSummaryServiceTest - findConfigurationTest - Quoteline: '+qli);
                    update qli;
                }
            }
            i++;
        }
        
   		Configuration__c plan =[SELECT Id,Plan_Type__c FROM Configuration__c LIMIT 1];
        QuoteLineItem qliInput =[SELECT Id,Product2Id,Product2.ProductCode,Product2.Product_Group__c,Configuration_Plan__c, Configuration_Product__c, Configuration_Option__c 
                                 FROM QuoteLineItem WHERE Product2.Product_Group__c = 'LG' LIMIT 1];
        System.debug('--- PricingSummaryServiceTest - findConfigurationTest - Quoteline ProductGroup: '+Product2.Product_Group__c);
        Test.startTest();
        QuoteLineItem qliOutput = PricingSummaryService.findConfiguration(b2cOpportunityId,plan?.plan_Type__c,qliInput);
        System.debug('--- PricingSummaryServiceTest - findConfigurationTest - Quoteline ProductGroup: '+Product2.Product_Group__c);
        System.AssertNotEquals(null,qliOutput, 'Expected a quoteline to be returned');
        System.debug('--- PricingSummaryServiceTest - findConfigurationTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- PricingSummaryServiceTest - findConfigurationTest - SOQL USED: ' + LIMITS.getQueries());
            
        Test.stopTest();
    }
}