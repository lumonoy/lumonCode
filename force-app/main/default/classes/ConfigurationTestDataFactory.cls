/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 06-19-2024
 * @last modified by  : Henk Reynders
**/
@isTest
public with sharing class ConfigurationTestDataFactory { 
    /** Determine if person account is enabled in current org **/
    @TestVisible
    private static Boolean isPersonAccountEnabled{
        get{
            return Schema.SObjectType.Account.fields.getMap().containsKey( 'isPersonAccount' );
        }
    }
    private static final Date Today = system.today();  
    public static void setupConfigurationRecords1() {
        Product2 p1 = new Product2(Name='Test Config Product 1', IsActive=True,ProductCode='COST',Product_Category__c='Product Models');
        Product2 p2 = new Product2(Name='Test Config Product 2', IsActive=True,ProductCode='COST-Option1',Product_Category__c='Product Options');
        Product2 p3 = new Product2(Name='Test Config Product 3', IsActive=True,ProductCode='COST-Option2',Product_Category__c='Product Options');
        insert new List<Product2> {p1,p2,p3};
        system.debug ('*** setupConfigurationRecords product 1: '+p1);
        system.debug ('*** setupConfigurationRecords product 2: '+p2);
        system.debug ('*** setupConfigurationRecords product 2: '+p3);
        Id pbid = Test.getStandardPricebookId();
        PricebookEntry pbe1 = new PricebookEntry(Pricebook2Id=pbid, Product2Id=p1.id, UnitPrice=1, IsActive=True,CurrencyIsoCode = 'EUR');
        PricebookEntry pbe2 = new PricebookEntry(Pricebook2Id=pbid, Product2Id=p2.id, UnitPrice=2, IsActive=True,CurrencyIsoCode = 'EUR');
        PricebookEntry pbe3 = new PricebookEntry(Pricebook2Id=pbid, Product2Id=p3.id, UnitPrice=3, IsActive=True,CurrencyIsoCode = 'EUR');
        
        insert new List<PricebookEntry> {pbe1,pbe2,pbe3};
        system.debug ('*** setupConfigurationRecords PricebookEntry 1: '+pbe1);
        system.debug ('*** setupConfigurationRecords PricebookEntry 2: '+pbe2);
        system.debug ('*** setupConfigurationRecords PricebookEntry 3: '+pbe3);
        String B2CRecordTypeId= [SELECT Id FROM RecordType WHERE (Name='B2C Account') and (SobjectType='Account')].Id;
        String B2BRecordTypeId= [SELECT Id FROM RecordType WHERE (Name='B2B Account') and (SobjectType='Account')].Id;
        List<Account> accts = new List<Account>();
        // Create B2C Account
            Account p = new Account(      
                RecordTypeID=B2CRecordTypeId,
                FirstName='My',
                LastName='Person Account',
                PersonEmail='test@factory.com',
                PersonMailingCountry ='Finland',
                PersonMailingCity='Kaupunki',
                PersonMailingPostalCode = '1111',
                PersonMailingStreet='Katu 1');
            accts.add(p);    
            Account a = new Account(
                RecordTypeID=B2BRecordTypeId,
                Name='Account Test Config',
                BillingCountry ='Finland',
                BillingCity='Kaupunki',
                BillingPostalCode = '22222',
                BillingStreet = 'Katu 2');
            accts.add(a);
        insert accts;        
        system.debug ('*** setupConfigurationRecords Person Account: '+p.id);
        system.debug ('*** setupConfigurationRecords Account: '+a.id);
        Opportunity o1 = new Opportunity(
            Name='B2C Opportunity 1', 
            StageName='Quotation', 
            CloseDate=system.Today()+10,
            Pricebook2Id=pbid,
            AccountId = a.Id
            );
        insert o1;
        Opportunity o2 = new Opportunity(
            Name='B2B Opportunity 1', 
            StageName='Quotation', 
            CloseDate=system.Today()+30,
            Pricebook2Id=pbid,
            AccountId = a.Id
            );
        insert o2;
        system.debug ('*** setupConfigurationRecords B2C Opportunity 1: '+o1.id);
        system.debug ('*** setupConfigurationRecords B2B Opportunity 1: '+o2.id);
        // Create Parent Config
        Configuration__c cfg = new Configuration__c(
            Opportunity__c = o1.Id,
            Name='Test Config 1',
            Plan_Apartment__c = 'A1',// public String apartment; // Door Nbr in Apartment
            Plan_Floor__c = '6',// public Integer floor; // Floor Nbr in Building
            Visual_Id__c = 'ABCDE1',//public String id; // Unique Visual Configuration Id
            Plan_Line__c = '100',// public String line; //?
            Plan_Name__c = 'NAME',// public String name; // Name of the Configuration
            //public List<Products> products; // Product Model aka Configurable Product
            Visual_Version__c = 2);//public Integer version; // Configuration Version);
        insert cfg;
        // Create Config Product
        Configuration_Product__c cfgProd = new Configuration_Product__c(
            Name='COST', //public String name; // Name of the Product Model
            Configuration__c = cfg.Id, // Parent Configuration
            Quantity__c = 1, // Amount must be 1 for each Product in a configuration
            Features_Confirmed__c = False,//public Boolean hasFeaturesBeenConfirmed;
            Measurements_Verified__c = False,// public Boolean hasMeasurementsBeenVerified;
            Visual_Product_Id__c = 'abcde12345',//public String id; // Product Code of Product Model
            Inspection_Code__c = 2,//public Integer productInspectCode;
            Product_Length__c = 2.5, //public Double productLength;
            RVN_Number__c = '12345678'); // public String rvn; //ProjectNbr + Structure);
        insert cfgProd;
        // Create Config Option
        Configuration_Option__c cfgOpt1 = new Configuration_Option__c(
            Name='Test Config Option 1',
            Configuration_Product__c = cfgProd.Id,
            Quantity__c = 1.23, //public Double Amount;
            Local_Supplier__c = FALSE, //public Boolean LocalSupplier;
            Parameter_code__c = '123456',// public String ParameterCode;
            Sales_Code__c = 'Option 1',// public String SalesCode;
            //Unique_Id__c = 1,// public Integer UniqueId;
            Unit_Of_Measure__c = 'M');// public String Unit;)
        insert cfgOpt1; 
        Configuration_Option__c cfgOpt2 = new Configuration_Option__c(
            Name='Test Config Option 2',
            Configuration_Product__c = cfgProd.Id,
            Quantity__c = 22.23, //public Double Amount;
            Local_Supplier__c = FALSE, //public Boolean LocalSupplier;
            Parameter_code__c = '123456',// public String ParameterCode;
            Sales_Code__c = 'Option 2',// public String SalesCode;
            //Unique_Id__c = 1,// public Integer UniqueId;
            Unit_Of_Measure__c = 'h');// public String Unit;)
        insert cfgOpt2;       
        // Create Config Message
        Configuration_Message__c cfgMsg = new Configuration_Message__c(
            Name='Test Config Message 1',
            Configuration_Product__c = cfgProd.Id,
            Message_Key__c = 'E12345',
            Space_Side_Number__c = 1);
        insert cfgMsg;  
        // Create Content Document Version
        ContentVersion imageFileVersion = new ContentVersion();
        imageFileVersion.Title='Picture'; 
        imageFileVersion.ContentLocation= 's';
        imageFileVersion.PathOnClient = imageFileVersion.Title + '.jpg';
        Blob imageBody=Blob.valueOf('*** configRecordsSetup Picture File'); 
        imageFileVersion.VersionData=imageBody; 
        insert imageFileVersion;
        system.debug ('*** setupConfigurationRecords Image File Version : '+imageFileVersion.id);
        ContentVersion newFileVersion = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =:imageFileVersion.Id];
        // Create Content Document Version to Configuration
        ContentDocumentLink imageFileLink = new ContentDocumentLink();
        imageFileLink.ContentDocumentId = newFileVersion.ContentDocumentId;
        imageFileLink.ShareType = 'V';
        imageFileLink.LinkedEntityId = cfg.id;
        insert imageFileLink;
        system.debug ('*** setupConfigurationRecords Image File Link : '+imageFileLink.id);
        // Create Content Document Version
        ContentVersion pricingFileVersion = new ContentVersion();
        pricingFileVersion.Title='Visual Pricing'; 
        pricingFileVersion.ContentLocation= 's';
        pricingFileVersion.PathOnClient = pricingFileVersion.Title + '.json';

        String pricingString = '{'+
        '    \"apartment\": \"A1\",'+
        '    \"floor\": \"6\",'+
        '    \"id\": \"ABCDE1\",'+
        '    \"line\": \"123\",'+
        '    \"name\": \"Test Plan 1\",'+
        '    \"version\": 2,'+
        '    \"products\": ['+
        '      {'+
        '        \"id\": \"visualProductId1\",'+
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
        // Add JSON to Config Record
        cfg.Visual_Pricing_JSON__c = pricingString;
        update cfg;
        Blob bodyBlob=Blob.valueOf(pricingString); 
        pricingFileVersion.VersionData=bodyBlob; 
        insert pricingFileVersion;
        system.debug ('*** setupConfigurationRecords Pricing File Version : '+pricingFileVersion.id);
        ContentVersion newPricingFileVersion = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =:pricingFileVersion.Id];
        // Create Content Document Version to Configuration
        ContentDocumentLink pricingFileLink = new ContentDocumentLink();
        pricingFileLink.ContentDocumentId = newPricingFileVersion.ContentDocumentId;
        pricingFileLink.ShareType = 'V';
        pricingFileLink.LinkedEntityId = cfg.id;
        insert pricingFileLink;
        system.debug ('*** setupConfigurationRecords Image File Link : '+pricingFileLink.id);
    }      
    public static void setupConfigurationRecords2() {
        Product2 p4 = new Product2(Name='Test Config Product 4', IsActive=True,ProductCode='LG',Product_Category__c='Product Models');
        Product2 p5 = new Product2(Name='Test Config Product 5', IsActive=True,ProductCode='LG-Option1',Product_Category__c='Product Options');
        Product2 p6 = new Product2(Name='Test Config Product 6', IsActive=True,ProductCode='LG-Option2',Product_Category__c='Product Options');
        insert new List<Product2> {p4,p5,p6};
        system.debug ('*** setupConfigurationRecords product 4: '+p4);
        system.debug ('*** setupConfigurationRecords product 5: '+p5);
        system.debug ('*** setupConfigurationRecords product 6: '+p6);
        Id pbid = Test.getStandardPricebookId();
        PricebookEntry pbe4 = new PricebookEntry(Pricebook2Id=pbid, Product2Id=p4.id, UnitPrice=4, IsActive=True,CurrencyIsoCode = 'EUR');
        PricebookEntry pbe5 = new PricebookEntry(Pricebook2Id=pbid, Product2Id=p5.id, UnitPrice=5, IsActive=True,CurrencyIsoCode = 'EUR');
        PricebookEntry pbe6 = new PricebookEntry(Pricebook2Id=pbid, Product2Id=p6.id, UnitPrice=6, IsActive=True,CurrencyIsoCode = 'EUR');
        
        insert new List<PricebookEntry> {pbe4,pbe5,pbe6};
        system.debug ('*** setupConfigurationRecords PricebookEntry 4: '+pbe4);
        system.debug ('*** setupConfigurationRecords PricebookEntry 5: '+pbe5);
        system.debug ('*** setupConfigurationRecords PricebookEntry 6: '+pbe6);
        String B2CRecordTypeId= [SELECT Id FROM RecordType WHERE (Name='B2C Account') and (SobjectType='Account')].Id;
        String B2BRecordTypeId= [SELECT Id FROM RecordType WHERE (Name='B2B Account') and (SobjectType='Account')].Id;
        List<Account> accts = new List<Account>();
        // Create B2C Account
            Account p = new Account(      
                RecordTypeID=B2CRecordTypeId,
                FirstName='My',
                LastName='Person Account',
                PersonEmail='test@factory.com',
                PersonMailingCountry ='Finland',
                PersonMailingCity='Kaupunki',
                PersonMailingPostalCode = '1111',
                PersonMailingStreet='Katu 1');
            accts.add(p);    
            Account a = new Account(
                RecordTypeID=B2BRecordTypeId,
                Name='Account Test Visual',
                BillingCountry ='Finland',
                BillingCity='Kaupunki',
                BillingPostalCode = '22222',
                BillingStreet = 'Katu 2');
            accts.add(a);
        insert accts;        
        system.debug ('*** setupConfigurationRecords Person Account: '+p.id);
        system.debug ('*** setupConfigurationRecords Account: '+a.id);
        Opportunity o3 = new Opportunity(
            Name='B2C Opportunity 2', 
            StageName='Quotation', 
            CloseDate=system.Today()+10,
            Pricebook2Id=pbid,
            AccountId = a.Id
            );
        insert o3;
        Opportunity o4 = new Opportunity(
            Name='B2B Opportunity 2', 
            StageName='Quotation', 
            CloseDate=system.Today()+30,
            Pricebook2Id=pbid,
            AccountId = a.Id
            );
        insert o4;
        system.debug ('*** setupConfigurationRecords B2C Opportunity 2: '+o3.id);
        system.debug ('*** setupConfigurationRecords B2B Opportunity 2: '+o4.id);
        // Create Parent Config
        Configuration__c cfg = new Configuration__c(
            Opportunity__c = o3.Id,
            Name='Test Config 2',
            Plan_Apartment__c = 'A3',// public String apartment; // Door Nbr in Apartment
            Plan_Floor__c = '6',// public Integer floor; // Floor Nbr in Building
            Visual_Id__c = 'ABCDE2',//public String id; // Unique Visual Configuration Id
            Plan_Line__c = '100',// public String line; //?
            Plan_Name__c = 'NAME',// public String name; // Name of the Configuration
            //public List<Products> products; // Product Model aka Configurable Product
            Visual_Version__c = 3);//public Integer version; // Configuration Version);
        insert cfg;
        // Create Config Product
        Configuration_Product__c cfgProd2 = new Configuration_Product__c(
            Name='COST', //public String name; // Name of the Product Model
            Configuration__c = cfg.Id, // Parent Configuration
            Quantity__c = 1, // Amount must be 1 for each Product in a configuration
            Features_Confirmed__c = False,//public Boolean hasFeaturesBeenConfirmed;
            Measurements_Verified__c = False,// public Boolean hasMeasurementsBeenVerified;
            Visual_Product_Id__c = 'abcde12345',//public String id; // Product Code of Product Model
            Inspection_Code__c = 2,//public Integer productInspectCode;
            Product_Length__c = 2.5, //public Double productLength;
            RVN_Number__c = '12345678'); // public String rvn; //ProjectNbr + Structure);
        insert cfgProd2;
        // Create Config Option
        Configuration_Option__c cfgOpt3 = new Configuration_Option__c(
            Name='Test Config Option 3',
            Configuration_Product__c = cfgProd2.Id,
            Quantity__c = 1.23, //public Double Amount;
            Local_Supplier__c = FALSE, //public Boolean LocalSupplier;
            Parameter_code__c = '123456',// public String ParameterCode;
            Sales_Code__c = 'Option 1',// public String SalesCode;
            //Unique_Id__c = 1,// public Integer UniqueId;
            Unit_Of_Measure__c = 'M');// public String Unit;)
        insert cfgOpt3; 
        Configuration_Option__c cfgOpt4 = new Configuration_Option__c(
            Name='Test Config Option 4',
            Configuration_Product__c = cfgProd2.Id,
            Quantity__c = 22.23, //public Double Amount;
            Local_Supplier__c = FALSE, //public Boolean LocalSupplier;
            Parameter_code__c = '123456',// public String ParameterCode;
            Sales_Code__c = 'Option 2',// public String SalesCode;
            //Unique_Id__c = 1,// public Integer UniqueId;
            Unit_Of_Measure__c = 'h');// public String Unit;)
        insert cfgOpt4;       
        // Create Config Message
        Configuration_Message__c cfgMsg = new Configuration_Message__c(
            Name='Test Config Message 2',
            Configuration_Product__c = cfgProd2.Id,
            Message_Key__c = 'E12345',
            Space_Side_Number__c = 1);
        insert cfgMsg;  
        List<Object> nestedConfigs =   [SELECT  Configuration__r.Id,
                                                //Configuration__r.Plan_Floor__c,
                                                Configuration__r.Plan_Apartment__c,
                                                Configuration__r.Visual_Id__c,
                                                (SELECT Message_Key__c,
                                                        Space_Side_Number__c 
                                                FROM Configuration_Messages__r),
                                                (SELECT Quantity__c,
                                                        Local_Supplier__c,
                                                        Parameter_code__c,
                                                        Sales_Code__c,  
                                                        Unique_Id__c,
                                                        Unit_Of_Measure__c
                                                FROM Configuration_Options__r)
                                                Name,
                                                Configuration__c,
                                                Quantity__c,
                                                Features_Confirmed__c,
                                                Measurements_Verified__c,
                                                Visual_Product_Id__c,
                                                Inspection_Code__c,
                                                Product_Length__c,
                                                RVN_Number__c
                                    FROM Configuration_Product__c WHERE Id =: cfgProd2.Id];
        // Create Content Document Version
        ContentVersion imageFileVersion = new ContentVersion();
        imageFileVersion.Title='Picture'; 
        imageFileVersion.ContentLocation= 's';
        imageFileVersion.PathOnClient = imageFileVersion.Title + '.jpg';
        Blob imageBody=Blob.valueOf('*** configRecordsSetup Picture File'); 
        imageFileVersion.VersionData=imageBody; 
        insert imageFileVersion;
        system.debug ('*** setupConfigurationRecords Image File Version : '+imageFileVersion.id);
        ContentVersion newFileVersion = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =:imageFileVersion.Id];
        // Create Content Document Version to Configuration
        ContentDocumentLink imageFileLink = new ContentDocumentLink();
        imageFileLink.ContentDocumentId = newFileVersion.ContentDocumentId;
        imageFileLink.ShareType = 'V';
        imageFileLink.LinkedEntityId = cfg.id;
        insert imageFileLink;
        system.debug ('*** setupConfigurationRecords Image File Link : '+imageFileLink.id);
        // Create Content Document Version
        ContentVersion pricingFileVersion = new ContentVersion();
        pricingFileVersion.Title='Visual Pricing'; 
        pricingFileVersion.ContentLocation= 's';
        pricingFileVersion.PathOnClient = pricingFileVersion.Title + '.json';

        String ConfigString = '{'+
        '    \"apartment\": \"A1\",'+
        '    \"floor\": \"6\",'+
        '    \"id\": \"ABCDE\",'+
        '    \"line\": \"123\",'+
        '    \"name\": \"Test Plan 2\",'+
        '    \"version\": 2,'+
        '    \"products\": ['+
        '      {'+
        '        \"id\": \"visualProductId1\",'+
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
        pricingFileVersion.VersionData=bodyBlob; 
        insert pricingFileVersion;
        system.debug ('*** setupConfigurationRecords Pricing File Version : '+pricingFileVersion.id);
        ContentVersion newPricingFileVersion = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =:pricingFileVersion.Id];
        // Create Content Document Version to Configuration
        ContentDocumentLink pricingFileLink = new ContentDocumentLink();
        pricingFileLink.ContentDocumentId = newPricingFileVersion.ContentDocumentId;
        pricingFileLink.ShareType = 'V';
        pricingFileLink.LinkedEntityId = cfg.id;
        insert pricingFileLink;
        system.debug ('*** setupConfigurationRecords Image File Link : '+pricingFileLink.id);
    }  
    public static void setupConfigurationRecords3() {
        Product2 p7 = new Product2(Name='Test Config Product 7', IsActive=True,ProductCode='LG',Product_Category__c='Product Models');
        Product2 p8 = new Product2(Name='Test Config Product 8', IsActive=True,ProductCode='LG-Option1',Product_Category__c='Product Options');
   		Product2 p9 = new Product2(Name='Test Config Product 9', IsActive=True,ProductCode='COST',Product_Category__c='Product Models');      
        Product2 p10 = new Product2(Name='Test Config Product 10', IsActive=True,ProductCode='COST-Option2',Product_Category__c='Product Options');
        insert new List<Product2> {p7,p8,p9,p10};
        system.debug ('*** setupConfigurationRecords product 7: '+p7);
        system.debug ('*** setupConfigurationRecords product 8: '+p8);
        system.debug ('*** setupConfigurationRecords product 9: '+p9);
        system.debug ('*** setupConfigurationRecords product 10: '+p10);
        Id pbid = Test.getStandardPricebookId();
        PricebookEntry pbe7 = new PricebookEntry(Pricebook2Id=pbid, Product2Id=p7.id, UnitPrice=7, IsActive=True,CurrencyIsoCode = 'EUR');
        PricebookEntry pbe8 = new PricebookEntry(Pricebook2Id=pbid, Product2Id=p8.id, UnitPrice=8, IsActive=True,CurrencyIsoCode = 'EUR');
        PricebookEntry pbe9 = new PricebookEntry(Pricebook2Id=pbid, Product2Id=p9.id, UnitPrice=9, IsActive=True,CurrencyIsoCode = 'EUR');
        PricebookEntry pbe10 = new PricebookEntry(Pricebook2Id=pbid, Product2Id=p10.id, UnitPrice=10, IsActive=True,CurrencyIsoCode = 'EUR');

        insert new List<PricebookEntry> {pbe7,pbe8,pbe9,pbe10};
        system.debug ('*** setupConfigurationRecords PricebookEntry 7: '+pbe7);
        system.debug ('*** setupConfigurationRecords PricebookEntry 8: '+pbe8);
        system.debug ('*** setupConfigurationRecords PricebookEntry 9: '+pbe9);
        system.debug ('*** setupConfigurationRecords PricebookEntry 10: '+pbe10);
        String B2CRecordTypeId= [SELECT Id FROM RecordType WHERE (Name='B2C Account') and (SobjectType='Account')].Id;
        String B2BRecordTypeId= [SELECT Id FROM RecordType WHERE (Name='B2B Account') and (SobjectType='Account')].Id;
        List<Account> accts = new List<Account>();
        // Create B2C Account
            Account p = new Account(      
                RecordTypeID=B2CRecordTypeId,
                FirstName='My',
                LastName='Person Account',
                PersonEmail='test.config3@factory.com',
                PersonMailingCountry ='Finland',
                PersonMailingCity='Kaupunki',
                PersonMailingPostalCode = '33333',
                PersonMailingStreet='Katu 3');
            accts.add(p);    
            Account a = new Account(
                RecordTypeID=B2BRecordTypeId,
                Name='Account Test Config 3',
                BillingCountry ='Finland',
                BillingCity='Kaupunki',
                BillingPostalCode = '33333',
                BillingStreet = 'Katu 33');
            accts.add(a);
        insert accts;        
        system.debug ('*** setupConfigurationRecords Person Account: '+p.id);
        system.debug ('*** setupConfigurationRecords Account: '+a.id);
        Opportunity o5 = new Opportunity(
            Name='B2C Opportunity 3', 
            StageName='Quotation', 
            CloseDate=system.Today()+10,
            Pricebook2Id=pbid,
            AccountId = a.Id
            );
        insert o5;
        Opportunity o6 = new Opportunity(
            Name='B2B Opportunity 3', 
            StageName='Quotation', 
            CloseDate=system.Today()+30,
            Pricebook2Id=pbid,
            AccountId = a.Id
            );
        insert o6;
        system.debug ('*** setupConfigurationRecords B2C Opportunity 3: '+o5.id);
        system.debug ('*** setupConfigurationRecords B2B Opportunity 3: '+o6.id);
        // Create Parent Config
        Configuration__c cfg = new Configuration__c(
            Opportunity__c = o5.Id,
            Name='Test Config 3',
            Plan_Apartment__c = 'A3',// public String apartment; // Door Nbr in Apartment
            Plan_Floor__c = '6',// public Integer floor; // Floor Nbr in Building
            Visual_Id__c = 'ABCDE3',//public String id; // Unique Visual Configuration Id
            Plan_Line__c = '100',// public String line; //?
            Plan_Name__c = 'NAME',// public String name; // Name of the Configuration
            //public List<Products> products; // Product Model aka Configurable Product
            Visual_Version__c = 3);//public Integer version; // Configuration Version);
        insert cfg;
        // Create Config Product
        Configuration_Product__c cfgProd1 = new Configuration_Product__c(
            Name='COST', //public String name; // Name of the Product Model
            Configuration__c = cfg.Id, // Parent Configuration
            Quantity__c = 1, // Amount must be 1 for each Product in a configuration
            Features_Confirmed__c = False,//public Boolean hasFeaturesBeenConfirmed;
            Measurements_Verified__c = False,// public Boolean hasMeasurementsBeenVerified;
            Visual_Product_Id__c = 'abcde12345',//public String id; // Product Code of Product Model
            Inspection_Code__c = 2,//public Integer productInspectCode;
            Product_Length__c = 2.5, //public Double productLength;
            RVN_Number__c = '33333-3'); // public String rvn; //ProjectNbr + Structure);
        insert cfgProd1;
        Configuration_Product__c cfgProd2 = new Configuration_Product__c(
            Name='LG', //public String name; // Name of the Product Model
            Configuration__c = cfg.Id, // Parent Configuration
            Quantity__c = 1, // Amount must be 1 for each Product in a configuration
            Features_Confirmed__c = False,//public Boolean hasFeaturesBeenConfirmed;
            Measurements_Verified__c = False,// public Boolean hasMeasurementsBeenVerified;
            Visual_Product_Id__c = 'abcde12345',//public String id; // Product Code of Product Model
            Inspection_Code__c = 2,//public Integer productInspectCode;
            Product_Length__c = 2.5, //public Double productLength;
            RVN_Number__c = '33333-3'); // public String rvn; //ProjectNbr + Structure);
        insert cfgProd2;
        // Create Config Option
        Configuration_Option__c cfgOpt1 = new Configuration_Option__c(
            Name='Test Config Option 1',
            Configuration_Product__c = cfgProd1.Id,
            Quantity__c = 1.23, //public Double Amount;
            Local_Supplier__c = FALSE, //public Boolean LocalSupplier;
            Parameter_code__c = '123456',// public String ParameterCode;
            Product_Code__c = 'COST-Option1',
            Sales_Code__c = 'Option1',// public String SalesCode;
            //Unique_Id__c = 1,// public Integer UniqueId;
            Unit_Of_Measure__c = 'M');// public String Unit;)
        insert cfgOpt1; 
        Configuration_Option__c cfgOpt2 = new Configuration_Option__c(
            Name='Test Config Option 2',
            Configuration_Product__c = cfgProd2.Id,
            Quantity__c = 22.23, //public Double Amount;
            Local_Supplier__c = FALSE, //public Boolean LocalSupplier;
            Parameter_code__c = '123456',// public String ParameterCode;
            Product_Code__c = 'LG-Option1',
            Sales_Code__c = 'Option1',// public String SalesCode;
            //Unique_Id__c = 1,// public Integer UniqueId;
            Unit_Of_Measure__c = 'h');// public String Unit;)
        insert cfgOpt2;       
        // Create Config Message
        Configuration_Message__c cfgMsg = new Configuration_Message__c(
            Name='Test Config Message 2',
            Configuration_Product__c = cfgProd2.Id,
            Message_Key__c = 'E12345',
            Space_Side_Number__c = 1);
        insert cfgMsg;  
        // Create Content Document Version
        ContentVersion imageFileVersion = new ContentVersion();
        imageFileVersion.Title='Picture'; 
        imageFileVersion.ContentLocation= 's';
        imageFileVersion.PathOnClient = imageFileVersion.Title + '.jpg';
        Blob imageBody=Blob.valueOf('*** configRecordsSetup Picture File'); 
        imageFileVersion.VersionData=imageBody; 
        insert imageFileVersion;
        system.debug ('*** setupConfigurationRecords Image File Version : '+imageFileVersion.id);
        ContentVersion newFileVersion = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =:imageFileVersion.Id];
        // Create Content Document Version to Configuration
        ContentDocumentLink imageFileLink = new ContentDocumentLink();
        imageFileLink.ContentDocumentId = newFileVersion.ContentDocumentId;
        imageFileLink.ShareType = 'V';
        imageFileLink.LinkedEntityId = cfg.id;
        insert imageFileLink;
        system.debug ('*** setupConfigurationRecords Image File Link : '+imageFileLink.id);
        // Create Content Document Version
        ContentVersion pricingFileVersion = new ContentVersion();
        pricingFileVersion.Title='Visual Pricing'; 
        pricingFileVersion.ContentLocation= 's';
        pricingFileVersion.PathOnClient = pricingFileVersion.Title + '.json';

        String ConfigString = '{'+
        '    \"apartment\": \"C3\",'+
        '    \"floor\": \"3\",'+
        '    \"id\": \"ABCDE3\",'+
        '    \"line\": \"123\",'+
        '    \"name\": \"Test Plan 3\",'+
        '    \"version\": 3,'+
        '    \"products\": ['+
        '      {'+
        '        \"id\": \"visualProductId1\",'+
        '        \"name\": \"COST\",'+
        '        \"productLength\": 10.0,'+
        '        \"priceParameters\": ['+
        '          {'+
        '            \"Amount\": 1.0,'+
        '            \"LocalSupplier\": true,'+
        '            \"ParameterCode\": \"\",'+
        '            \"SalesCode\": \"Option1\",'+
        '            \"UniqueId\": 1,'+
        '            \"Unit\": \"PCS\"'+
        '          }'+
        '        ],'+
        '	   },{'+
        '        \"id\": \"visualProductId2\",'+
        '        \"name\": \"LG\",'+
        '        \"productLength\": 20.0,'+
        '        \"priceParameters\": ['+
        '          {'+
        '            \"Amount\": 1.0,'+
        '            \"LocalSupplier\": true,'+
        '            \"ParameterCode\": \"\",'+
        '            \"SalesCode\": \"Option1\",'+
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
        pricingFileVersion.VersionData=bodyBlob; 
        insert pricingFileVersion;
        system.debug ('*** setupConfigurationRecords Pricing File Version : '+pricingFileVersion.id);
        ContentVersion newPricingFileVersion = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =:pricingFileVersion.Id];
        // Create Content Document Version to Configuration
        ContentDocumentLink pricingFileLink = new ContentDocumentLink();
        pricingFileLink.ContentDocumentId = newPricingFileVersion.ContentDocumentId;
        pricingFileLink.ShareType = 'V';
        pricingFileLink.LinkedEntityId = cfg.id;
        insert pricingFileLink;
        system.debug ('*** setupConfigurationRecords Image File Link : '+pricingFileLink.id);
    }  
}