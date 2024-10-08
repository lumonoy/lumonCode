/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 06-19-2024
 * @last modified by  : Henk Reynders
**/
@isTest
public with sharing class PricingTestDataFactory { 
    /** Determine if person account is enabled in current org **/
    @TestVisible
    private static Boolean isPersonAccountEnabled{
        get{
            return Schema.SObjectType.Account.fields.getMap().containsKey( 'isPersonAccount' );
        }
    }
    private static final Date Today = system.today(); 
    private static final Date ThisMonth = system.today().toStartOfMonth(); 
    @future
    public static void setupPricingRecords(){
        System.debug('*** Setup B2C PriceRecords at Start - Number of Queries used in this apex code so far: ' + Limits.getQueries());
        Product2 p1 = new Product2(Name='Test Pricing Product 4', IsActive=True,ProductCode='LG',Product_Category__c='Product Models');
        Product2 p2 = new Product2(Name='Test Pricing Product 5', IsActive=True,ProductCode='LG-Option1',Product_Category__c='Product Options',Sales_Code__c='Option1');
        Product2 p3 = new Product2(Name='Test Pricing Product 6', IsActive=True,ProductCode='LG-Option2',Product_Category__c='Product Options',Sales_Code__c='Option2');
        Product2 p4 = new Product2(Name='Test Pricing Product 7', IsActive=True,ProductCode='LG-Option3',Product_Category__c='Product Options',Sales_Code__c='Option3');
        Product2 p5 = new Product2(Name='Test Pricing Product 8', IsActive=True,ProductCode='LG-Option4',Product_Category__c='Product Options',Sales_Code__c='Option4');
        insert new List<Product2> {p1,p2,p3,p4,p5};
        System.debug('*** Setup B2C PriceRecords Products - Number of Queries used in this apex code so far: ' + Limits.getQueries());
        Id pbid = Test.getStandardPricebookId();
        System.debug('*** Setup B2C PriceRecords Pricebook - Number of Queries used in this apex code so far: ' + Limits.getQueries());
        PricebookEntry pbe1 = new PricebookEntry(Pricebook2Id=pbid, Product2Id=p1.id, UnitPrice=1, IsActive=True,CurrencyIsoCode = 'EUR');
        PricebookEntry pbe2 = new PricebookEntry(Pricebook2Id=pbid, Product2Id=p2.id, UnitPrice=2, IsActive=True,CurrencyIsoCode = 'EUR');
        PricebookEntry pbe3 = new PricebookEntry(Pricebook2Id=pbid, Product2Id=p3.id, UnitPrice=3, IsActive=True,CurrencyIsoCode = 'EUR');
        PricebookEntry pbe4 = new PricebookEntry(Pricebook2Id=pbid, Product2Id=p4.id, UnitPrice=4, IsActive=True,CurrencyIsoCode = 'EUR');
        PricebookEntry pbe5 = new PricebookEntry(Pricebook2Id=pbid, Product2Id=p5.id, UnitPrice=5, IsActive=True,CurrencyIsoCode = 'EUR');
        insert new List<PricebookEntry> {pbe1,pbe2,pbe3,pbe4,pbe5};
        System.debug('*** Setup B2C PriceRecords Pricebook Entries - Number of Queries used in this apex code so far: ' + Limits.getQueries());
        String B2CRecordTypeId= [SELECT Id FROM RecordType WHERE (Name='B2C Account') and (SobjectType='Account')].Id;
        System.debug('*** Setup B2C PriceRecords Record Types - Number of Queries used in this apex code so far: ' + Limits.getQueries());
        // Create B2C Account
        Account pa1 = new Account(RecordTypeID=B2CRecordTypeId,
                    FirstName='My',
                    LastName='Person Account',
                    PersonEmail='test1@factory.com',
                    PersonMailingCountry ='Finland',
                    PersonMailingCity='Kaupunki',
                    PersonMailingPostalCode = '1111',
                    PersonMailingStreet='Katu 1'); 
        insert pa1;
        System.debug('*** Setup B2C PriceRecords Accounts - Number of Queries used in this apex code so far: ' + Limits.getQueries());
 
        system.debug ('*** setupPricingRecords Person Account: '+pa1.id);
        Opportunity o1 = new Opportunity(
                                    Name='B2C Opportunity', 
                                    StageName='Quoting', 
                                    CloseDate=system.Today()+10,
                                    Pricebook2Id=pbid,
                                    Property_Type__c = 'ROW',
                                    AccountId = pa1.Id
                                    );
        insert o1;
        System.debug('*** Setup B2C PriceRecords Opportunity1 - Number of Queries used in this apex code so far: ' + Limits.getQueries());
        Quote q1 = [SELECT Id,IsSyncing,OpportunityId FROM Quote WHERE OpportunityId =: o1.Id]; //Changes made by SAI -> This points to the Synced Quote autocreated by Flow
        system.debug ('*** setupQuoteRecords B2C Synced Quote: '+q1);
        Quote q2= new Quote( //Added Non-syncing Quote -> Oppty not updated with this Id as syncedQuoteId
            Name='B2C Standalone Quote', 
            Status='Configure', 
            Pricebook2Id=pbid,
            OpportunityId=o1.Id
            );
        insert q2;
        system.debug ('*** setupQuoteRecords B2C Standalone Quote: '+q2);
        System.debug('*** Setup B2C PriceRecords Quote1 - Number of Queries used in this apex code so far: ' + Limits.getQueries());
        // Create QuoteLines
        system.debug ('*** quoteRecordsSetup Quote : '+q1.id);
        QuoteLineItem ql1 = new QuoteLineItem(  QuoteId=q1.id, 
                                                Product2Id=p1.id, 
                                                PricebookEntryId=pbe1.Id,
                                                Quantity=1,
                                                UnitPrice=pbe1.UnitPrice    
                                                );
        QuoteLineItem ql2 = new QuoteLineItem(  QuoteId=q1.id, 
                                                Product2Id=p2.id, 
                                                PricebookEntryId=pbe2.Id,
                                                Quantity=2,
                                                UnitPrice=pbe2.UnitPrice   
                                                );
        QuoteLineItem ql3 = new QuoteLineItem(  QuoteId=q1.id, 
                                                Product2Id=p3.id, 
                                                PricebookEntryId=pbe3.Id,
                                                Quantity=3,
                                                UnitPrice=pbe3.UnitPrice   
                                                );
        QuoteLineItem ql4 = new QuoteLineItem(  QuoteId=q1.id, 
                                                Product2Id=p4.id, 
                                                PricebookEntryId=pbe4.Id,
                                                Quantity=4,
                                                UnitPrice=pbe4.UnitPrice    
                                                );
        QuoteLineItem ql5 = new QuoteLineItem(  QuoteId=q1.id, 
                                                Product2Id=p5.id, 
                                                PricebookEntryId=pbe5.Id,
                                                Quantity=5,
                                                UnitPrice=pbe5.UnitPrice   
                                                );
        insert new List<QuoteLineItem> {ql1,ql2,ql3,ql4,ql5};
        System.debug('*** Setup B2C PriceRecords QuoteLines - Number of Queries used in this apex code so far: ' + Limits.getQueries());
        // Create Parent Config B2C
        Configuration__c cfg1 = new Configuration__c(
                                        Opportunity__c = o1.Id,
                                        Name='Test Pricing Config 1',
                                        Plan_Apartment__c = 'A1',// public String apartment; // Door Nbr in Apartment
                                        Plan_Floor__c = '6',// public Integer floor; // Floor Nbr in Building
                                        Visual_Id__c = 'ABCDE1',//public String id; // Unique Visual Configuration Id
                                        Plan_Line__c = '100',// public String line; //?
                                        Plan_Name__c = 'plan 1',// public String name; // Name of the Configuration
                                        //public List<Products> products; // Product Model aka Configurable Product
                                        Visual_Version__c = 1);//public Integer version; // Configuration Version);
         // Create Parent Config B2B
        Configuration__c cfg2 = new Configuration__c(
                                        Opportunity__c = o1.Id,
                                        Name='Test Pricing Config 2',
                                        Plan_Apartment__c = 'B2',// public String apartment; // Door Nbr in Apartment
                                        Plan_Floor__c = '6',// public Integer floor; // Floor Nbr in Building
                                        Visual_Id__c = 'ABCDE2',//public String id; // Unique Visual Configuration Id
                                        Plan_Line__c = '200',// public String line; //?
                                        Plan_Name__c = 'plan 2',// public String name; // Name of the Configuration
                                        //public List<Products> products; // Product Model aka Configurable Product
                                        Visual_Version__c = 2);//public Integer version; // Configuration Version);
        insert new List<Configuration__c>{cfg1,cfg2};
        System.debug('*** Setup B2C PriceRecords Configurations - Number of Queries used in this apex code so far: ' + Limits.getQueries());
        // Create Config Product(s)
        Configuration_Product__c cfgProd1 = new Configuration_Product__c(
                                        Name='LISAKUSTAN', //public String name; // Name of the Product Model
                                        Configuration__c = cfg1.Id, // Parent Configuration
                                        Quantity__c = 1, // Amount must be 1 for each Product in a configuration
                                        Features_Confirmed__c = False,//public Boolean hasFeaturesBeenConfirmed;
                                        Measurements_Verified__c = False,// public Boolean hasMeasurementsBeenVerified;
                                        Visual_Product_Id__c = 'abcde1x',//public String id; // Product Code of Product Model
                                        Inspection_Code__c = 2,//public Integer productInspectCode;
                                        Product_Length__c = 2.5, //public Double productLength;
                                        RVN_Number__c = '11111-1'); // public String rvn; //ProjectNbr + Structure);
        Configuration_Product__c cfgProd2 = new Configuration_Product__c(
                                        Name='LG', //public String name; // Name of the Product Model
                                        Configuration__c = cfg1.Id, // Parent Configuration
                                        Quantity__c = 1, // Amount must be 1 for each Product in a configuration
                                        Features_Confirmed__c = False,//public Boolean hasFeaturesBeenConfirmed;
                                        Measurements_Verified__c = False,// public Boolean hasMeasurementsBeenVerified;
                                        Visual_Product_Id__c = 'abcde2x',//public String id; // Product Code of Product Model
                                        Inspection_Code__c = 2,//public Integer productInspectCode;
                                        Product_Length__c = 2.5, //public Double productLength;
                                        RVN_Number__c = '11111-1'); // public String rvn; //ProjectNbr + Structure);
        Configuration_Product__c cfgProd3 = new Configuration_Product__c(
                                        Name='LISAKUSTAN', //public String name; // Name of the Product Model
                                        Configuration__c = cfg2.Id, // Parent Configuration
                                        Quantity__c = 1, // Amount must be 1 for each Product in a configuration
                                        Features_Confirmed__c = False,//public Boolean hasFeaturesBeenConfirmed;
                                        Measurements_Verified__c = False,// public Boolean hasMeasurementsBeenVerified;
                                        Visual_Product_Id__c = 'abcde1x',//public String id; // Product Code of Product Model
                                        Inspection_Code__c = 2,//public Integer productInspectCode;
                                        Product_Length__c = 2.5, //public Double productLength;
                                        RVN_Number__c = '22222-2'); // public String rvn; //ProjectNbr + Structure);
        Configuration_Product__c cfgProd4 = new Configuration_Product__c(
                                        Name='LG', //public String name; // Name of the Product Model
                                        Configuration__c = cfg2.Id, // Parent Configuration
                                        Quantity__c = 1, // Amount must be 1 for each Product in a configuration
                                        Features_Confirmed__c = False,//public Boolean hasFeaturesBeenConfirmed;
                                        Measurements_Verified__c = False,// public Boolean hasMeasurementsBeenVerified;
                                        Visual_Product_Id__c = 'abcde2x',//public String id; // Product Code of Product Model
                                        Inspection_Code__c = 2,//public Integer productInspectCode;
                                        Product_Length__c = 2.5, //public Double productLength;
                                        RVN_Number__c = '22222-2'); // public String rvn; //ProjectNbr + Structure);
        insert new List<Configuration_Product__c>{cfgProd1,cfgProd2,cfgProd3,cfgProd4};
        System.debug('*** Setup B2C PriceRecords Configuration Products - Number of Queries used in this apex code so far: ' + Limits.getQueries());
        // Create Config Option
        Configuration_Option__c cfgOpt1 = new Configuration_Option__c(
                                        Name='Test Pricing Config Option 1',
                                        Configuration_Product__c = cfgProd1.Id,
                                        Quantity__c = 11.11, //public Double Amount;
                                        Local_Supplier__c = FALSE, //public Boolean LocalSupplier;
                                        Parameter_code__c = 'param1',// public String ParameterCode;
                                        Product_Code__c = 'LG-Option1',// public String SalesCode;
                                        Sales_Code__c = 'Option1',// public String SalesCode;
                                        //Unique_Id__c = 1,// public Integer UniqueId;
                                        Unit_Of_Measure__c = 'M');//public String Unit
                                    //RVN_Number__c = '11111-1'// (oppty Number+) Visual Structure nbr  
        Configuration_Option__c cfgOpt2 = new Configuration_Option__c(
                                        Name='Test Pricing Config Option 2',
                                        Configuration_Product__c = cfgProd1.Id,
                                        Quantity__c = 11.22, //public Double Amount;
                                        Local_Supplier__c = FALSE, //public Boolean LocalSupplier;
                                        Parameter_code__c = 'param2',// public String ParameterCode;
                                        Product_Code__c = 'LG-Option2',// public String SalesCode;
                                        Sales_Code__c = 'Option2',// public String SalesCode;
                                        //Unique_Id__c = 1,// public Integer UniqueId;
                                        Unit_Of_Measure__c = 'h');//public String Unit
                                        //RVN_Number__c = '11111-1'// (oppty Number+) Visual Structure nbr   
        Configuration_Option__c cfgOpt3 = new Configuration_Option__c(
                                        Name='Test Pricing Config Option 3',
                                        Configuration_Product__c = cfgProd2.Id,
                                        Quantity__c = 22.11, //public Double Amount;
                                        Local_Supplier__c = FALSE, //public Boolean LocalSupplier;
                                        Parameter_code__c = 'param3',// public String ParameterCode;
                                        Product_Code__c = 'LG-Option3',// public String SalesCode;
                                        Sales_Code__c = 'Option3',// public String SalesCode;
                                        //Unique_Id__c = 1,// public Integer UniqueId;
                                        Unit_Of_Measure__c = 'pcs');//public String Unit
                                        //RVN_Number__c = '22222-2'// (oppty Number+) Visual Structure nbr   
        Configuration_Option__c cfgOpt4 = new Configuration_Option__c(
                                        Name='Test Pricing Config Option 4',
                                        Configuration_Product__c = cfgProd2.Id,
                                        Quantity__c = 22.22, //public Double Amount;
                                        Local_Supplier__c = FALSE, //public Boolean LocalSupplier;
                                        Parameter_code__c = 'param4',// public String ParameterCode;
                                        Product_Code__c = 'LG-Option4',// public String SalesCode;
                                        Sales_Code__c = 'Option4',// public String SalesCode;
                                        //Unique_Id__c = 1,// public Integer UniqueId;
                                        Unit_Of_Measure__c = 'M2');//public String Unit
                                        //RVN_Number__c = '22222-2'// (oppty Number+) Visual Structure nbr   
        Configuration_Option__c cfgOpt5 = new Configuration_Option__c(
                                        Name='Test Data Config Option 5',
                                        Configuration_Product__c = cfgProd3.Id,
                                        Quantity__c = 33.11, //public Double Amount;
                                        Local_Supplier__c = FALSE, //public Boolean LocalSupplier;
                                        Parameter_code__c = 'param5',// public String ParameterCode;
                                        Product_Code__c = 'LISAKUSTAN-Option1',// public String SalesCode;
                                        Sales_Code__c = 'Option1',// public String SalesCode;
                                        //Unique_Id__c = 1,// public Integer UniqueId;
                                        Unit_Of_Measure__c = 'pcs');//public String Unit
                                        //RVN_Number__c = '33333-3'// (oppty Number+) Visual Structure nbr   
        Configuration_Option__c cfgOpt6 = new Configuration_Option__c(
                                        Name='Test Data Config Option 6',
                                        Configuration_Product__c = cfgProd4.Id,
                                        Quantity__c = 33.22, //public Double Amount;
                                        Local_Supplier__c = FALSE, //public Boolean LocalSupplier;
                                        Parameter_code__c = 'param6',// public String ParameterCode;
                                        Product_Code__c = 'LG-Option2',// public String SalesCode;
                                        Sales_Code__c = 'Option2',// public String SalesCode;
                                        //Unique_Id__c = 1,// public Integer UniqueId;
                                        Unit_Of_Measure__c = 'M3');//public String Unit
                                        //RVN_Number__c = '33333-3'// (oppty Number+) Visual Structure nbr 
        insert new List<Configuration_Option__c>{cfgOpt1,cfgOpt2,cfgOpt3,cfgOpt4,cfgOpt5,cfgOpt6};   
        System.debug('*** Setup B2C PriceRecords Configuration Options - Number of Queries used in this apex code so far: ' + Limits.getQueries());
 
        // Create Config Message
        Configuration_Message__c cfgMsg1 = new Configuration_Message__c(
                                        Name='Test Pricing Config Message',
                                        Configuration_Product__c = cfgProd1.Id,
                                        Message_Key__c = 'E1-1-1',
                                        Space_Side_Number__c = 1);
        Configuration_Message__c cfgMsg2 = new Configuration_Message__c(
                                        Name='Test Pricing Config Message',
                                        Configuration_Product__c = cfgProd1.Id,
                                        Message_Key__c = '1-2-1',
                                        Space_Side_Number__c = 2);
        insert new List<Configuration_Message__c>{cfgMsg1,cfgMsg2};  
        System.debug('*** Setup B2C PriceRecords Configuration Messages - Number of Queries used in this apex code so far: ' + Limits.getQueries());
        Factory_Price__c fp1 = new Factory_Price__c();
        fp1.Organization__c = 'LSU'; 
        fp1.Country__c = 'FI'; 
        fp1.Business_Type__c = 'Consumer';
        fp1.Product_Group__c = 'LISAKUSTAN';
        fp1.Cost_Type__c = 'asennus';
        fp1.Factory_Multiplier__c = 10.0;
        fp1.IsActive__c  = true;
        Factory_Price__c fp2 = new Factory_Price__c();
        fp2.Organization__c = 'LSU'; 
        fp2.Country__c = 'FI'; 
        fp2.Business_Type__c = 'Consumer';
        fp2.Product_Group__c = 'LG';
        fp2.Cost_Type__c = 'asennus';
        fp2.Factory_Multiplier__c = 10.0;
        fp2.IsActive__c  = true;
        insert new List<Factory_Price__c>{fp1,fp2};
        System.debug('*** Setup B2C PriceRecords Factory Prices - Number of Queries used in this apex code so far: ' + Limits.getQueries());
        Product_Cost__c pc1 = new Product_Cost__c();
        pc1.Organization__c = 'LSU'; 
        pc1.Country__c = 'FI'; 
        pc1.Business_Type__c = 'Consumer';
        pc1.District__c = 'FI_North';
        pc1.Product_Group__c = 'LISAKUSTAN';
        pc1.Cost_Type__c = 'asennus';
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
        System.debug('*** Setup B2C PriceRecords Factory Prices - Number of Queries used in this apex code so far: ' + Limits.getQueries());
        Sales_Price__c sp1 = new Sales_Price__c();
        sp1.Organization__c = 'LSU'; 
        sp1.Country__c = 'FI'; 
        sp1.Business_Type__c = 'Consumer';
        sp1.District__c = 'FI_North';
        sp1.Product_Group__c = 'LISAKUSTAN';
        sp1.Profit_Center__c = '4043 LSU Oulu';
        sp1.Cost_Type__c = 'asennus';
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
        sp2.Cost_Type__c = 'asennus';
        sp2.Sales_Multiplier__c = 30.0;
        sp2.IsActive__c  = true;
        insert new List<Sales_Price__c>{sp1,sp2};

        List<Quote> quotes = [SELECT Id,IsSyncing,OpportunityId FROM Quote WHERE OpportunityId =: o1.Id]; //Changes made by SAI -> This points to the Synced Quote autocreated by Flow
        system.debug ('*** setupQuoteRecords B2C Quotes : '+quotes);

        System.debug('*** Setup B2C PriceRecords Factory Prices - Number of Queries used in this apex code so far: ' + Limits.getQueries());
        System.debug('*** Setup B2C PriceRecords at End - Number of Queries used in this apex code so far: ' + Limits.getQueries());
    }   
}