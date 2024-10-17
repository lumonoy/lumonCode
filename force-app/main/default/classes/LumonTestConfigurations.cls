/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-20-2023
 * @last modified by  : Henk Reynders
**/
@IsTest 
public with sharing class LumonTestConfigurations {
    @TestVisible private static String visualPricingJSON {
        get {return retractablePricing;}
    }  
    @TestVisible private static String soveliaPricingJSON {
        get {return soveliaPricing; }
    }
    @TestVisible private static String testPricingJSON {
        get {return [SELECT Body FROM StaticResource WHERE Name = 'TestPricingJSON' ].Body.toString();}
    }
    @TestVisible private static String roboPricing {
        get {return [SELECT Body FROM StaticResource WHERE Name = 'Visual_Pricing_Robo_99' ].Body.toString();}
    }
    @TestVisible private static String retractablePricing {
        get {return [SELECT Body FROM StaticResource WHERE Name = 'RetractablePricing' ].Body.toString();}
    }
    @TestVisible private static String soveliaPricing {
        get {return [SELECT Body FROM StaticResource WHERE Name = 'Sovelia_Pricing' ].Body.toString();}
    }
    @TestVisible private static String soveliaReport {
        get {return [SELECT Body FROM StaticResource WHERE Name = 'Sovelia_Report' ].Body.toString();}
    }
    public static Id setupAccount(){
        // Create B2C Account
        LumonTestAccounts.setupAccountB2C();
     	Id accountId = [SELECT Id FROM Account WHERE (IsPersonAccount = true)]?.Id;
        System.debug('--- setupAccount - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- setupAccount - Queries used: '+LIMITS.getQueries());
        return accountId;
    }
    public static Id setupOpportunity(Id accountId){
        // Create B2C Opportunity
        String org = 'LSU';
        String district = 'FI_South';
        String businessType = '1';
        LumonTestOpportunities.setupOpportunityB2C(accountId, org,district, businessType);
		Id oportunityId = [SELECT Id FROM Opportunity WHERE (AccountId =: accountId )]?.Id;
        System.debug('--- setupOpportunity - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- setupOpportunity - Queries used: '+LIMITS.getQueries());
        return oportunityId;
    }
    public static Id setupQuote(Id opportunityId){
    	//Adding new Quote -> Oppty is updated with this Id as syncedQuoteId
        Quote q = new Quote( 
                            Name='B2C New Quote',
                            Status='Configure',
                            Pricebook2Id=Test.getStandardPricebookId(),
                            OpportunityId=opportunityId
                        );
        insert q;
        System.debug('--- setupQuote - quoteId: '+q.Id);
        return q.Id;
    }
    public static Id setupQuoteSyncing(Id opportunityId,Id quoteId){
        Opportunity o = new Opportunity(Id=opportunityId, SyncedQuoteId = quoteId);
        update o;
        Id syncedQuoteId = o.SyncedQuoteId;
        System.debug('--- PricingControllerTest - syncedQuoteId: '+syncedQuoteId); 
        String syncingQuoteId = [SELECT Id FROM Quote WHERE IsSyncing = True AND OpportunityId =:opportunityId]?.Id;
        System.debug('--- PricingControllerTest - syncing quoteId: '+syncingQuoteId);
        return syncedQuoteId;
    }
    public static Id setupConfigurationPlan(Id opportunityId) {
        if (String.isBlank(opportunityId)){
            System.debug('No Parent Opportunity existing');
        }
        String planId = 'ABCDE';
        // Create Parent Config B2C
        Configuration__c configPlan = new Configuration__c(
                                            Opportunity__c = opportunityId,
                                            Name='Configuration Plan '+planId,
                                            Plan_Apartment__c = 'A1',// public String apartment; // Door Nbr in Apartment
                                            Plan_Floor__c = 2,// public Integer floor; // Floor Nbr in Building
                                            Visual_Id__c = planId,//public String Id; // Unique Visual Configuration Id
                                            Plan_Line__c = '1',// public String line; //?
                                            Plan_Name__c = planId,// public String name; // Name of the Configuration
                                            Visual_Version__c = 1);//public Integer version; // Configuration Version    
        insert configPlan;
        System.debug('--- setupConfigurationPlan - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- setupConfigurationPlan - Queries used: '+LIMITS.getQueries());
        return configPlan.Id;
    }
    public static Id setupConfigurationPlan(Id opportunityId, String planId) {
        if (String.isBlank(opportunityId)){
            System.debug('No Parent Opportunity existing');
        }
        // Create Parent Config B2C
        Configuration__c configPlan = new Configuration__c(
                                            Opportunity__c = opportunityId,
                                            Name='Configuration Plan '+planId,
                                            Plan_Apartment__c = 'A1',// public String apartment; // Door Nbr in Apartment
                                            Plan_Floor__c = 2,// public Integer floor; // Floor Nbr in Building
                                            Visual_Id__c = planId,//public String Id; // Unique Visual Configuration Id
                                            Plan_Line__c = '1',// public String line; //?
                                            Plan_Name__c = planId,// public String name; // Name of the Configuration
                                            Visual_Version__c = 1);//public Integer version; // Configuration Version    
        insert configPlan;
        System.debug('--- setupConfigurationPlan - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- setupConfigurationPlan - Queries used: '+LIMITS.getQueries());
        return configPlan.Id;
    }
    public static List<Id> setupConfigurationProducts(Id configurationId) {
        List<Product2> products = [SELECT Id, ProductCode,Product_Group__c,Cost_Type__c,IsActive FROM Product2];
        List<Id> productIds = new List<Id>(new Map<Id, Product2>(products).keySet()); 
        List<Id> configProductIds = setupConfigurationProducts(configurationId,productIds);
        return configProductIds;
    }
    public static List<Id> setupConfigurationProducts(Id configurationId, List<Id> productIds) {
        Map<String,Product2> productGroupMap = new Map<String,Product2>();
        List<Configuration_Product__c> cps = new List<Configuration_Product__c>();
        List<Product2> products = new List<Product2>([SELECT Id, Product_Group__c,ProductCode, Name FROM Product2 
                                                      WHERE Product_Category__c = 'Product Groups' 
                                                      AND IsActive  = TRUE AND Id IN: productIds]);  
        for (Product2 p : products){
            Configuration_Product__c cp = new Configuration_Product__c();
			cp.Name=p.Product_Group__c; //public String name; // Name of the Product Model
            cp.Configuration__c = configurationId; // Parent Configuration
            cp.Quantity__c = 1; // Amount must be 1 for each Product in a configuration
            cp.Product__c = p.Id;
            cp.Visual_Product_Id__c = p.Id;//public String Id; // Product Code of Product Model
            cp.Visual_Structure_Number__c = '12345678';
            cp.Features_Confirmed__c = False;//public Boolean hasFeaturesBeenConfirmed;
            cp.Measurements_Verified__c = False;// public Boolean hasMeasurementsBeenVerified;                                       
            cp.Inspection_Code__c = 2;//public Integer productInspectCode;
            cp.Product_Length__c = 2.5; //public Double productLength;
            cps.add(cp);
        }
        insert cps;
        System.debug('--- setupConfigurationProducts - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- setupConfigurationProducts - Queries used: '+LIMITS.getQueries());
        List<Id> configProductIds = new List<Id>(new Map<Id, Configuration_Product__c>(cps).keySet()); 
        return configProductIds;
    }
    public static List<Id> setupConfigurationOptions(Id configurationId) {
        List<Product2> products = new List<Product2>([SELECT Id, Product_Group__c,ProductCode, Name FROM Product2 
                                                      WHERE Product_Category__c != 'Product Groups' 
                                                      AND IsActive  = TRUE]);  
        List<Configuration_Product__c> cfgProducts = [SELECT Id,Configuration__c FROM Configuration_Product__c WHERE Configuration__c =: configurationId];
        List<Id> productIds = new List<Id>(new Map<Id, Product2>(products).keySet()); 
        List<Id> cfgProductIds = new List<Id>(new Map<Id, Configuration_Product__c>(cfgProducts).keySet());
        List<Id> configOptionIds = setupConfigurationOptions(cfgProductIds,productIds);
        return configOptionIds;
    }
    public static List<Id> setupConfigurationOptions(List<Id> configurationProductIds, List<Id> productIds) {
        Map<String,Product2> productGroupMap = new Map<String,Product2>();
        List<Configuration_Option__c> cos = new List<Configuration_Option__c>();
        List<Product2> products = new List<Product2>([SELECT Id, Product_Group__c,ProductCode, Name FROM Product2 
                                                      WHERE Product_Category__c != 'Product Groups' 
                                                      AND IsActive  = TRUE AND Id IN: productIds]);  
        for (id cpId : configurationProductIds) {
            for (Product2 p : products){ 
                Configuration_Option__c co = new Configuration_Option__c();
                co.Name=p.Name;
                co.Configuration_Product__c = cpId;
                co.Quantity__c = 10; //public Double Amount;
                //co.Local_Supplier__c = FALSE; //public Boolean LocalSupplier;
                //co.Parameter_code__c = 'param1';// public String ParameterCode;
                co.Product_Code__c = p.ProductCode;// public String SalesCode;
                co.Sales_Code__c = p.ProductCode.length()<20 ? p.ProductCode : p.ProductCode.Left(20) ;// public String SalesCode;
                co.Unique_Id__c = p.ProductCode;// public Integer UniqueId;
                co.Unit_Of_Measure__c = 'M';//public String Unit
                //RVN_Number__c = 'B2C-1-1'// (oppty Number+) Visual Structure nbr
            	cos.add(co);   
            }
        }
        insert cos;
        System.debug('--- setupConfigurationOptions - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- setupConfigurationOptions - Queries used: '+LIMITS.getQueries());
        List<Id> configOptionIds = new List<Id>(new Map<Id, Configuration_Option__c>(cos).keySet()); 
        return configOptionIds;//
    }
    public static List<Id> setupConfigurationMessages() {
        List<Configuration_Product__c> cps = [SELECT Id FROM Configuration_Product__c];
        List<Id> configProductIds = new List<Id>(new Map<Id, Configuration_Product__c>(cps).keySet()); 
        List<Id> cmIds = setupConfigurationMessages(configProductIds);
        return cmIds;
    }
    public static List<Id> setupConfigurationMessages(List<Id> configProductIds) {
        List<Configuration_Message__c> cms = new List<Configuration_Message__c>();
        // Create B2C
        for (Integer i = 0; i <configProductIds.size();i++) {
            Configuration_Message__c cm = new Configuration_Message__c(
                                            Name='Test Config Message 1',
                                            Configuration_Product__c = configProductIds[i],
                                            Message_Key__c = 'E1-1-1',
                                            Space_Side_Number__c = 1);
            cms.add(cm);
        }
        upsert cms;
        List<Id> cmIds = new List<Id>(new Map<Id, Configuration_Message__c>(cms).keySet()); 
        return cmIds;
    }
    public static Id setupPricingDocument(Id configurationId) {
        List<ContentVersion> pricingDocumentVersions = new List<ContentVersion>();
        List<ContentDocumentLink> pricingDocumentLinks = new List<ContentDocumentLink>();
            ContentVersion pricingDocumentVersion = new ContentVersion();
            pricingDocumentVersion.Title='Visual Pricing';
            pricingDocumentVersion.ContentLocation= 's';
            pricingDocumentVersion.PathOnClient = pricingDocumentVersion.Title + '.json';
            String configString = retractablePricing;
            Blob bodyBlob=Blob.valueOf(configString);
            pricingDocumentVersion.VersionData=bodyBlob;
        insert pricingDocumentVersion;
            ContentVersion newPricingDocumentVersion = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =:pricingDocumentVersion.Id];  
            // Link Content Document to Configuration
            ContentDocumentLink pricingDocumentLink = new ContentDocumentLink();
            pricingDocumentLink.ContentDocumentId = newPricingDocumentVersion.ContentDocumentId;
            pricingDocumentLink.ShareType = 'V';
            pricingDocumentLink.LinkedEntityId = configurationId;

        insert pricingDocumentLink;
        System.debug('--- setupPricingDocument - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- setupPricingDocument - Queries used: '+LIMITS.getQueries());
        return pricingDocumentLink.Id;
    }
    public static Id setupVisualDocumentation(Id configurationId) {
        List<ContentVersion> documentationVersions = new List<ContentVersion>();
        List<ContentDocumentLink> documentationLinks = new List<ContentDocumentLink>();
            ContentVersion documentationVersion = new ContentVersion();
            documentationVersion.Title='Visual_Documentation';
            documentationVersion.ContentLocation= 's';
            documentationVersion.PathOnClient = documentationVersion.Title + '.xml';
            String documentationString = (
                '<?xml version="1.0" encoding="utf-16"?>'+
                '<products xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">'+
                '  <name>AYXWQ</name>'+
                '  <balconyglazing>'+
                '    <product_code>LG</product_code>'+
                '    <product_code_short>LG</product_code_short>'+
                '    <structural_version_number>12345678</structural_version_number>'+
                '    <glass_type>20090016</glass_type>'+
                '    <glass_thickness>6</glass_thickness>'+
                '    <sides>'+
                '      <side>'+
                '        <number>0</number>'+
                '        <space_side_number>0</space_side_number>'+
                '        <glasses>'+
                '          <glass>'+
                '            <is_reclaimed>false</is_reclaimed>'+
                '            <number>0</number>'+
                '            <height>1861</height>'+
                '            <width>656</width>'+
                '            <rail>0</rail>'+
                '            <blinds>LUMON_NO_BLINDS</blinds>'+
                '            <sandblasting>DOCXML_NO</sandblasting>'+
                '            <differences>'+
                '              <difference>'+
                '                <feature_name>MiddleLatchLeft</feature_name>'+
                '                <value>LUMON_PD9240061</value>'+
                '                <translation>DOCXML_MIDDLE_LATCH_LEFT</translation>'+
                '              </difference>'+
                '              <difference>'+
                '                <feature_name>MiddleLatchHeightLeft</feature_name>'+
                '                <value>0 mm</value>'+
                '                <translation>DOCXML_MIDDLE_LATCH_HEIGHT_LEFT</translation>'+
                '              </difference>'+
                '            </differences>'+
                '          </glass>'+
                '        </glasses>'+
                '      </side>'+
                '    </sides>'+
                '  </balconyglazing>'+
                '</products>'
            );

            Blob bodyBlob=Blob.valueOf(documentationString);
            documentationVersion.VersionData=bodyBlob;
        insert documentationVersion;
            ContentVersion newDocumentationVersion = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =:documentationVersion.Id];  
            // Link Content Document to Configuration
            ContentDocumentLink documentationLink = new ContentDocumentLink();
            documentationLink.ContentDocumentId = newDocumentationVersion.ContentDocumentId;
            documentationLink.ShareType = 'V';
            documentationLink.LinkedEntityId = configurationId;

        insert documentationLink;
        System.debug('--- setupVisualDocumentation - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- setupVisualDocumentation - Queries used: '+LIMITS.getQueries());
        return documentationLink.Id;
    }
    public static Id setupStructureDocument(Id configurationId) {
        List<ContentVersion> structureDocumentVersions = new List<ContentVersion>();
        List<ContentDocumentLink> structureDocumentLinks = new List<ContentDocumentLink>();
            ContentVersion structureDocumentVersion = new ContentVersion();
            structureDocumentVersion.Title='Visual_Structure_12345678';
            structureDocumentVersion.ContentLocation= 's';
            structureDocumentVersion.PathOnClient = structureDocumentVersion.Title + '.json';
            String structureString = (
                '{'+
                '    "product_type": "LG",'+
                '    "structure_number": "12345678",'+
                '    "Product_opening": ['+
                '        {'+
                '            "embedded": 0,'+
                '            "glass_gap_seal": "0",'+
                '            "side": ['+
                '                {'+
                '                    "length": 2000,'+
                '                    "height": 2000,'+
                '                    "pull_handle_reclamation": 0,'+
                '                    "glass": ['+
                '                        {'+
                '                            "glass_number": 1,'+
                '                            "glass_reclamation": 0,'+
                '                            "glass_item": "20090016"'+
                '                        }'+
                '                    ]'+
                '                }'+
                '            ]'+
                '        }'+
                '    ]'+
                '}'
            );
            Blob bodyBlob=Blob.valueOf(structureString);
            structureDocumentVersion.VersionData=bodyBlob;
        insert structureDocumentVersion;
            ContentVersion newStructureDocumentVersion = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =:structureDocumentVersion.Id];  
            // Link Content Document to Configuration
            ContentDocumentLink structureDocumentLink = new ContentDocumentLink();
            structureDocumentLink.ContentDocumentId = newStructureDocumentVersion.ContentDocumentId;
            structureDocumentLink.ShareType = 'V';
            structureDocumentLink.LinkedEntityId = configurationId;

        insert structureDocumentLink;
        System.debug('--- setupStructureDocument - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- setupStructureDocument - Queries used: '+LIMITS.getQueries());
        return structureDocumentLink.Id;
    }
    public static void setupConfigurationData() {
        Try {
            Id accountId = setupAccount();  
            Id opportunityId = setupOpportunity(accountId);
            Id quoteId = setupQuote(opportunityId);
            Id syncedQuoteId = setupQuoteSyncing(opportunityId,quoteId);
            
            Id configPlanId = setupConfigurationPlan(opportunityId);
            
            List<Id> configProductIds = setupConfigurationProducts(configPlanId);
            List<Id> configOptionIds = setupConfigurationOptions(configPlanId);
            List<Id> configMessageIds = setupConfigurationMessages();
            Id pricingFile = setupPricingDocument(configPlanId);
            Id documentationFile = setupVisualDocumentation(configPlanId);
            Id strcutureFile = setupStructureDocument(configPlanId);
        }catch (Exception e){
            System.debug('--- setupConfigurationData Exception '+e);
        } 
    }

    @isTest
    public static void setupConfigurationTest(){
        Test.startTest();
        setupConfigurationData();
        Test.stopTest();
        System.debug('--- setupConfigurationTest - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- setupConfigurationTest - Queries used: '+LIMITS.getQueries());
    }
    
}