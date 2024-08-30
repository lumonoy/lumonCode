@isTest
public with sharing class VisualTestDataFactory { 
    /** Determine if person account is enabled in current org **/
    @TestVisible
    private static Boolean isPersonAccountEnabled{
        get{
            return Schema.SObjectType.Account.fields.getMap().containsKey( 'isPersonAccount' );
        }
    }
    /*private static final Date Today = system.today();  
    public static void setupVisualConfigurationRecords1() {
        Product2 p1 = new Product2(Name='Test Visual Product 1', IsActive=True,ProductCode='COST',Product_Category__c='Product Models');
        Product2 p2 = new Product2(Name='Test Visual Product 2', IsActive=True,ProductCode='Option 1',Product_Category__c='Product Options');
        Product2 p3 = new Product2(Name='Test Visual Product 3', IsActive=True,ProductCode='Option 2',Product_Category__c='Product Options');
        insert new List<Product2> {p1,p2,p3};
        system.debug ('*** setupVisualConfigurationRecords product 1: '+p1);
        system.debug ('*** setupVisualConfigurationRecords product 2: '+p2);
        system.debug ('*** setupVisualConfigurationRecords product 2: '+p3);
        Id pbid = Test.getStandardPricebookId();
        PricebookEntry pbe1 = new PricebookEntry(Pricebook2Id=pbid, Product2Id=p1.id, UnitPrice=1, IsActive=True,CurrencyIsoCode = 'EUR');
        PricebookEntry pbe2 = new PricebookEntry(Pricebook2Id=pbid, Product2Id=p2.id, UnitPrice=2, IsActive=True,CurrencyIsoCode = 'EUR');
        PricebookEntry pbe3 = new PricebookEntry(Pricebook2Id=pbid, Product2Id=p3.id, UnitPrice=3, IsActive=True,CurrencyIsoCode = 'EUR');
        
        insert new List<PricebookEntry> {pbe1,pbe2,pbe3};
        system.debug ('*** setupVisualConfigurationRecords PricebookEntry 1: '+pbe1);
        system.debug ('*** setupVisualConfigurationRecords PricebookEntry 2: '+pbe2);
        system.debug ('*** setupVisualConfigurationRecords PricebookEntry 3: '+pbe3);
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
        system.debug ('*** setupVisualConfigurationRecords Person Account: '+p.id);
        system.debug ('*** setupVisualConfigurationRecords Account: '+a.id);
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
        system.debug ('*** setupVisualConfigurationRecords B2C Opportunity 1: '+o1.id);
        system.debug ('*** setupVisualConfigurationRecords B2B Opportunity 1: '+o2.id);
        // Create Parent Config
        Configuration__c cfg = new Configuration__c(
            Opportunity__c = o1.Id,
            Name='Test Visual Config 1',
            Plan_Apartment__c = 'A1',// public String apartment; // Door Nbr in Apartment
            Plan_Floor__c = 6,// public Integer floor; // Floor Nbr in Building
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
            Name='Test Visual Config Option 1',
            Configuration_Product__c = cfgProd.Id,
            Quantity__c = 1.23, //public Double Amount;
            Local_Supplier__c = FALSE, //public Boolean LocalSupplier;
            Parameter_code__c = '123456',// public String ParameterCode;
            Sales_Code__c = 'Option 1',// public String SalesCode;
            Unique_Id__c = 1,// public Integer UniqueId;
            Unit_Of_Measure__c = 'M');// public String Unit;)
        insert cfgOpt1; 
        Configuration_Option__c cfgOpt2 = new Configuration_Option__c(
            Name='Test Visual Config Option 2',
            Configuration_Product__c = cfgProd.Id,
            Quantity__c = 22.23, //public Double Amount;
            Local_Supplier__c = FALSE, //public Boolean LocalSupplier;
            Parameter_code__c = '123456',// public String ParameterCode;
            Sales_Code__c = 'Option 2',// public String SalesCode;
            Unique_Id__c = 1,// public Integer UniqueId;
            Unit_Of_Measure__c = 'h');// public String Unit;)
        insert cfgOpt2;       
        // Create Config Message
        Configuration_Message__c cfgMsg = new Configuration_Message__c(
            Name='Test Visual Config Message 1',
            Configuration_Product__c = cfgProd.Id,
            Message_Key__c = 'E12345',
            Space_Side_Number__c = 1);
        insert cfgMsg;  
        List<Object> nestedConfigs =   [SELECT  Configuration__r.Id,
                                                Configuration__r.Plan_Floor__c,
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
                                    FROM Configuration_Product__c WHERE Id =: cfgProd.Id];
        // Create Content Document Version
        ContentVersion imageFileVersion = new ContentVersion();
        imageFileVersion.Title='Picture'; 
        imageFileVersion.ContentLocation= 's';
        imageFileVersion.PathOnClient = imageFileVersion.Title + '.jpg';
        Blob imageBody=Blob.valueOf('*** configRecordsSetup Picture File'); 
        imageFileVersion.VersionData=imageBody; 
        insert imageFileVersion;
        system.debug ('*** setupVisualConfigurationRecords Image File Version : '+imageFileVersion.id);
        ContentVersion newFileVersion = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =:imageFileVersion.Id];
        // Create Content Document Version to Configuration
        ContentDocumentLink imageFileLink = new ContentDocumentLink();
        imageFileLink.ContentDocumentId = newFileVersion.ContentDocumentId;
        imageFileLink.ShareType = 'V';
        imageFileLink.LinkedEntityId = cfg.id;
        insert imageFileLink;
        system.debug ('*** setupVisualConfigurationRecords Image File Link : '+imageFileLink.id);
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
        Blob bodyBlob=Blob.valueOf(ConfigString); 
        pricingFileVersion.VersionData=bodyBlob; 
        insert pricingFileVersion;
        system.debug ('*** setupVisualConfigurationRecords Pricing File Version : '+pricingFileVersion.id);
        ContentVersion newPricingFileVersion = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =:pricingFileVersion.Id];
        // Create Content Document Version to Configuration
        ContentDocumentLink pricingFileLink = new ContentDocumentLink();
        pricingFileLink.ContentDocumentId = newPricingFileVersion.ContentDocumentId;
        pricingFileLink.ShareType = 'V';
        pricingFileLink.LinkedEntityId = cfg.id;
        insert pricingFileLink;
        system.debug ('*** setupVisualConfigurationRecords Image File Link : '+pricingFileLink.id);
    }      
    public static void setupVisualConfigurationRecords2() {
        Product2 p4 = new Product2(Name='Test Visual Product 4', IsActive=True,ProductCode='COST',Product_Category__c='Product Models');
        Product2 p5 = new Product2(Name='Test Visual Product 5', IsActive=True,ProductCode='Option 1',Product_Category__c='Product Options');
        Product2 p6 = new Product2(Name='Test Visual Product 6', IsActive=True,ProductCode='Option 2',Product_Category__c='Product Options');
        insert new List<Product2> {p4,p5,p6};
        system.debug ('*** setupVisualConfigurationRecords product 4: '+p4);
        system.debug ('*** setupVisualConfigurationRecords product 5: '+p5);
        system.debug ('*** setupVisualConfigurationRecords product 6: '+p6);
        Id pbid = Test.getStandardPricebookId();
        PricebookEntry pbe4 = new PricebookEntry(Pricebook2Id=pbid, Product2Id=p4.id, UnitPrice=4, IsActive=True,CurrencyIsoCode = 'EUR');
        PricebookEntry pbe5 = new PricebookEntry(Pricebook2Id=pbid, Product2Id=p5.id, UnitPrice=5, IsActive=True,CurrencyIsoCode = 'EUR');
        PricebookEntry pbe6 = new PricebookEntry(Pricebook2Id=pbid, Product2Id=p6.id, UnitPrice=6, IsActive=True,CurrencyIsoCode = 'EUR');
        
        insert new List<PricebookEntry> {pbe4,pbe5,pbe6};
        system.debug ('*** setupVisualConfigurationRecords PricebookEntry 4: '+pbe4);
        system.debug ('*** setupVisualConfigurationRecords PricebookEntry 5: '+pbe5);
        system.debug ('*** setupVisualConfigurationRecords PricebookEntry 6: '+pbe6);
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
        system.debug ('*** setupVisualConfigurationRecords Person Account: '+p.id);
        system.debug ('*** setupVisualConfigurationRecords Account: '+a.id);
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
        system.debug ('*** setupVisualConfigurationRecords B2C Opportunity 2: '+o3.id);
        system.debug ('*** setupVisualConfigurationRecords B2B Opportunity 2: '+o4.id);
        // Create Parent Config
        Configuration__c cfg = new Configuration__c(
            Opportunity__c = o3.Id,
            Name='Test Visual Config 2',
            Plan_Apartment__c = 'A3',// public String apartment; // Door Nbr in Apartment
            Plan_Floor__c = 6,// public Integer floor; // Floor Nbr in Building
            Visual_Id__c = 'ABCDE',//public String id; // Unique Visual Configuration Id
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
            Name='Test Visual Config Option 3',
            Configuration_Product__c = cfgProd2.Id,
            Quantity__c = 1.23, //public Double Amount;
            Local_Supplier__c = FALSE, //public Boolean LocalSupplier;
            Parameter_code__c = '123456',// public String ParameterCode;
            Sales_Code__c = 'Option 1',// public String SalesCode;
            Unique_Id__c = 1,// public Integer UniqueId;
            Unit_Of_Measure__c = 'M');// public String Unit;)
        insert cfgOpt3; 
        Configuration_Option__c cfgOpt4 = new Configuration_Option__c(
            Name='Test Visual Config Option 4',
            Configuration_Product__c = cfgProd2.Id,
            Quantity__c = 22.23, //public Double Amount;
            Local_Supplier__c = FALSE, //public Boolean LocalSupplier;
            Parameter_code__c = '123456',// public String ParameterCode;
            Sales_Code__c = 'Option 2',// public String SalesCode;
            Unique_Id__c = 1,// public Integer UniqueId;
            Unit_Of_Measure__c = 'h');// public String Unit;)
        insert cfgOpt4;       
        // Create Config Message
        Configuration_Message__c cfgMsg = new Configuration_Message__c(
            Name='Test Visual Config Message 2',
            Configuration_Product__c = cfgProd2.Id,
            Message_Key__c = 'E12345',
            Space_Side_Number__c = 1);
        insert cfgMsg;  
        List<Object> nestedConfigs =   [SELECT  Configuration__r.Id,
                                                Configuration__r.Plan_Floor__c,
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
        system.debug ('*** setupVisualConfigurationRecords Image File Version : '+imageFileVersion.id);
        ContentVersion newFileVersion = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =:imageFileVersion.Id];
        // Create Content Document Version to Configuration
        ContentDocumentLink imageFileLink = new ContentDocumentLink();
        imageFileLink.ContentDocumentId = newFileVersion.ContentDocumentId;
        imageFileLink.ShareType = 'V';
        imageFileLink.LinkedEntityId = cfg.id;
        insert imageFileLink;
        system.debug ('*** setupVisualConfigurationRecords Image File Link : '+imageFileLink.id);
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
        system.debug ('*** setupVisualConfigurationRecords Pricing File Version : '+pricingFileVersion.id);
        ContentVersion newPricingFileVersion = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =:pricingFileVersion.Id];
        // Create Content Document Version to Configuration
        ContentDocumentLink pricingFileLink = new ContentDocumentLink();
        pricingFileLink.ContentDocumentId = newPricingFileVersion.ContentDocumentId;
        pricingFileLink.ShareType = 'V';
        pricingFileLink.LinkedEntityId = cfg.id;
        insert pricingFileLink;
        system.debug ('*** setupVisualConfigurationRecords Image File Link : '+pricingFileLink.id);
    }  */
}