@isTest
public with sharing class SalesTestDataFactory { 
    /** Determine if person account is enabled in current org **/
    @TestVisible
    private static Boolean isPersonAccountEnabled{
        get{
            return Schema.SObjectType.Account.fields.getMap().containsKey( 'isPersonAccount' );
        }
    }
    private static final Date Today = system.today();  
    @future
    public static void setupAccountRecords(){
        List<Account> accts = new List<Account>();
        // Create B2C Account
        if(isPersonAccountEnabled) {
            String B2CRecordTypeId = [SELECT Id FROM RecordType WHERE (IsPersonType = true) and (SobjectType='Account') LIMIT 1].Id;
            Account p = new Account(      
                RecordTypeID=B2CRecordTypeId,
                FirstName='B2C',
                LastName='Account',
                PersonEmail='test@factory.com',
                PersonMailingCountry ='Finland',
                PersonMailingCity='Kaupunki',
                PersonMailingPostalCode = '1111',
                PersonMailingStreet='Katu 1');
            accts.add(p);  
            system.debug ('*** accountRecordsSetup Person Account: '+p.id);
        }
        // Create B2BAccount
        String B2BRecordTypeId= [SELECT Id FROM RecordType WHERE (IsPersonType = false) and (SobjectType='Account')LIMIT 1].Id;
            Account a = new Account(
                RecordTypeID=B2BRecordTypeId,
                Name='B2B Account',
                BillingCountry ='Finland',
                BillingCity='Kaupunki',
                BillingPostalCode = '22222',
                BillingStreet = 'Katu 2');
            accts.add(a);
        system.debug ('*** accountRecordsSetup Account: '+a.id);
        insert accts;
    } 
    @future
    public static void setupB2BOpportunity() {
        Product2 p1 = new Product2(Name='Test Contract Product 1', IsActive=True,ProductCode='COST',Product_Category__c='Product Models');
        Product2 p2 = new Product2(Name='Test Contract Product 2', IsActive=True,ProductCode='Option 1',Product_Category__c='Product Options');
        Product2 p3 = new Product2(Name='Test Contract Product 3', IsActive=True,ProductCode='Option 2',Product_Category__c='Product Options');
        insert new List<Product2> {p1,p2,p3};
        system.debug ('*** setupB2BOpportunity product 1: '+p1);
        system.debug ('*** setupB2BOpportunity product 2: '+p2);
        system.debug ('*** setupB2BOpportunity product 2: '+p3);
        Id pbid = Test.getStandardPricebookId();
        PricebookEntry pbe1 = new PricebookEntry(Pricebook2Id=pbid, Product2Id=p1.id, UnitPrice=1, IsActive=True,CurrencyIsoCode = 'EUR');
        PricebookEntry pbe2 = new PricebookEntry(Pricebook2Id=pbid, Product2Id=p2.id, UnitPrice=2, IsActive=True,CurrencyIsoCode = 'EUR');
        PricebookEntry pbe3 = new PricebookEntry(Pricebook2Id=pbid, Product2Id=p3.id, UnitPrice=3, IsActive=True,CurrencyIsoCode = 'EUR');
        
        insert new List<PricebookEntry> {pbe1,pbe2,pbe3};
        system.debug ('*** setupB2BOpportunity PricebookEntry 1: '+pbe1);
        system.debug ('*** setupB2BOpportunity PricebookEntry 2: '+pbe2);
        system.debug ('*** setupB2BOpportunity PricebookEntry 3: '+pbe3);
        String B2CRecordTypeId= [SELECT Id FROM RecordType WHERE (Name='B2C Account') and (SobjectType='Account')].Id;
        String B2BRecordTypeId= [SELECT Id FROM RecordType WHERE (Name='B2B Account') and (SobjectType='Account')].Id;
        List<Account> accts = new List<Account>();
        // Create B2B Account
        Account a = new Account( Name='Account Test Opportunity',
                                    RecordTypeID=B2BRecordTypeId,
                                    BillingCountry ='Finland',
                                    BillingCity='Kaupunki',
                                    BillingPostalCode = '22222',
                                    BillingStreet = 'Katu 2');
        insert a;     
        system.debug ('*** setupB2BOpportunity Account: '+a.id);
        Opportunity o1 = new Opportunity(Name='B2B Opportunity', 
                                            StageName='Quoting', 
                                            CloseDate=system.Today()+10,
                                            Pricebook2Id=pbid,
                                            AccountId = a.Id
                                            );
        insert o1;
        system.debug ('*** setupB2BOpportunity Quoting Opportunity: '+o1.id);
        OpportunityLineItem oli1 = new OpportunityLineItem(  OpportunityId=o1.id, 
                                                            Product2Id=p1.id, 
                                                            PricebookEntryId=pbe1.Id,
                                                            Quantity=2,
                                                            UnitPrice=pbe1.UnitPrice    
                                                            );
        
        OpportunityLineItem oli2 = new OpportunityLineItem(  OpportunityId=o1.id, 
                                                            Product2Id=p1.id, 
                                                            PricebookEntryId=pbe2.Id,
                                                            Quantity=2,
                                                            UnitPrice=pbe2.UnitPrice    
                                                            );
        insert new List<OpportunityLineItem> {oli1,oli2}; 
    } 
    @future 
    public static void setupB2COpportunity() {
        Product2 p1 = new Product2(Name='Test Contract Product 1', IsActive=True,ProductCode='COST',Product_Category__c='Product Models');
        Product2 p2 = new Product2(Name='Test Contract Product 2', IsActive=True,ProductCode='Option 1',Product_Category__c='Product Options');
        Product2 p3 = new Product2(Name='Test Contract Product 3', IsActive=True,ProductCode='Option 2',Product_Category__c='Product Options');
        insert new List<Product2> {p1,p2,p3};
        system.debug ('*** setupB2COpportunity product 1: '+p1);
        system.debug ('*** setupB2COpportunity product 2: '+p2);
        system.debug ('*** setupB2COpportunity product 2: '+p3);
        Id pbid = Test.getStandardPricebookId();
        PricebookEntry pbe1 = new PricebookEntry(Pricebook2Id=pbid, Product2Id=p1.id, UnitPrice=1, IsActive=True,CurrencyIsoCode = 'EUR');
        PricebookEntry pbe2 = new PricebookEntry(Pricebook2Id=pbid, Product2Id=p2.id, UnitPrice=2, IsActive=True,CurrencyIsoCode = 'EUR');
        PricebookEntry pbe3 = new PricebookEntry(Pricebook2Id=pbid, Product2Id=p3.id, UnitPrice=3, IsActive=True,CurrencyIsoCode = 'EUR');
        
        insert new List<PricebookEntry> {pbe1,pbe2,pbe3};
        system.debug ('*** setupB2COpportunity PricebookEntry 1: '+pbe1);
        system.debug ('*** setupB2COpportunity PricebookEntry 2: '+pbe2);
        system.debug ('*** setupB2COpportunity PricebookEntry 3: '+pbe3);
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
        insert p;       
        system.debug ('*** setupB2COpportunity Person Account: '+p.id);
        Opportunity o1 = new Opportunity(Name='B2C Opportunity', 
                                            StageName='Quoting', 
                                            CloseDate=system.Today()+10,
                                            Pricebook2Id=pbid,
                                         	Property_Type__c = 'ROW',
                                            AccountId = p.Id
                                            );
        insert o1;
        system.debug ('*** setupB2COpportunity Quoting Opportunity: '+o1.id);
        OpportunityLineItem oli1 = new OpportunityLineItem(  OpportunityId=o1.id, 
                                                            Product2Id=p1.id, 
                                                            PricebookEntryId=pbe1.Id,
                                                            Quantity=1,
                                                            UnitPrice=pbe1.UnitPrice    
                                                            );
        
        OpportunityLineItem oli2 = new OpportunityLineItem(  OpportunityId=o1.id, 
                                                                Product2Id=p1.id, 
                                                                PricebookEntryId=pbe2.Id,
                                                                Quantity=2,
                                                                UnitPrice=pbe2.UnitPrice    
                                                                );
        insert new List<OpportunityLineItem> {oli1,oli2};
    } 
    @future      
    public static void setupQuoteRecords() {
        Product2 p1 = new Product2(Name='Test Contract Product 1', IsActive=True,ProductCode='COST',Product_Category__c='Product Models');
        Product2 p2 = new Product2(Name='Test Contract Product 2', IsActive=True,ProductCode='Option 1',Product_Category__c='Product Options');        insert new List<Product2> {p1,p2};
        system.debug ('*** setupQuoteRecords product 1: '+p1);
        system.debug ('*** setupQuoteRecords product 2: '+p2);
        Id pbid = Test.getStandardPricebookId();
        PricebookEntry pbe1 = new PricebookEntry(Pricebook2Id=pbid, Product2Id=p1.id, UnitPrice=1, IsActive=True,CurrencyIsoCode = 'EUR');
        PricebookEntry pbe2 = new PricebookEntry(Pricebook2Id=pbid, Product2Id=p2.id, UnitPrice=2, IsActive=True,CurrencyIsoCode = 'EUR');
        insert new List<PricebookEntry> {pbe1,pbe2};
        system.debug ('*** setupQuoteRecords PricebookEntry 1: '+pbe1);
        system.debug ('*** setupQuoteRecords PricebookEntry 2: '+pbe2);
        String B2CRecordTypeId= [SELECT Id FROM RecordType WHERE (Name='B2C Account') and (SobjectType='Account')].Id;
        String B2BRecordTypeId= [SELECT Id FROM RecordType WHERE (Name='B2B Account') and (SobjectType='Account')].Id;
        List<Account> accts = new List<Account>();
        // Create B2C Account
            Account p = new Account(      
                RecordTypeID=B2CRecordTypeId,
                FirstName='My',
                LastName='Person Account',
                PersonEmail='test.quote@factory.com',
                PersonMailingCountry ='Finland',
                PersonMailingCity='Kaupunki',
                PersonMailingPostalCode = '1111',
                PersonMailingStreet='Katu 1');
            accts.add(p);    
            Account a = new Account(
                RecordTypeID=B2BRecordTypeId,
                Name='Account Test Quote',
                BillingCountry ='Finland',
                BillingCity='Kaupunki',
                BillingPostalCode = '22222',
                BillingStreet = 'Katu 2');
            accts.add(a);
        insert accts;        
        system.debug ('*** setupQuoteRecords Person Account: '+p.id);
        system.debug ('*** setupQuoteRecords Account: '+a.id);
        Opportunity o1 = new Opportunity(
            Name='B2C Opportunity', 
            StageName='Quoting', 
            CloseDate=system.Today()+10,
            Pricebook2Id=pbid,
            Property_Type__c = 'ROW',
            AccountId = p.Id
            );
        Opportunity o2 = new Opportunity(
            Name='B2B Opportunity', 
            StageName='Quoting', 
            CloseDate=system.Today()+10,
            Property_Type__c = 'ROW',
            Pricebook2Id=pbid,
            AccountId = p.Id
            );
        insert new List<Opportunity> {o1,o2};
        Quote q1 = [SELECT Id,IsSyncing,OpportunityId FROM Quote WHERE OpportunityId =: o1.Id]; //Changes made by SAI -> This points to the Synced Quote autocreated by Flow
        system.debug ('*** setupQuoteRecords B2C Quote 1: '+q1);
        Quote q2= new Quote( //Added Non-syncing Quote -> Oppty not updated with this Id as syncedQuoteId
            Name='B2B Quote', 
            Status='Draft', 
            Pricebook2Id=pbid,
            OpportunityId=o2.Id
            );
        insert q2;
        system.debug ('*** setupQuoteRecords B2B Quote: '+q2);
        o2.SyncedQuoteId = q2.Id;
        update o2;
        // Create QuoteLines
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
        
        // Create QuoteLines
        QuoteLineItem ql3 = new QuoteLineItem(  QuoteId=q2.id, 
                                                Product2Id=p2.id, 
                                                PricebookEntryId=pbe2.Id,
                                                Quantity=2,
                                                UnitPrice=pbe1.UnitPrice    
                                                );
        QuoteLineItem ql4 = new QuoteLineItem(  QuoteId=q2.id, 
                                                Product2Id=p2.id, 
                                                PricebookEntryId=pbe2.Id,
                                                Quantity=1,
                                                UnitPrice=pbe2.UnitPrice   
                                                );
        insert new List<QuoteLineItem> {ql1,ql2,ql3,ql4};
    } 
    @future
    public static void setupPriceRecords(){
        Product2 p1 = new Product2(Name='Test Pricing Product 1', IsActive=True,ProductCode='COST',Product_Category__c='Product Models');
        Product2 p2 = new Product2(Name='Test Pricing Product 2', IsActive=True,ProductCode='COST-Option1',Product_Category__c='Product Options',Sales_Code__c='Option1');
        Product2 p3 = new Product2(Name='Test Pricing Product 3', IsActive=True,ProductCode='COST-Option2',Product_Category__c='Product Options',Sales_Code__c='Option2');
        Product2 p4 = new Product2(Name='Test Pricing Product 4', IsActive=True,ProductCode='LG',Product_Category__c='Product Models');
        Product2 p5 = new Product2(Name='Test Pricing Product 5', IsActive=True,ProductCode='LG-Option1',Product_Category__c='Product Options',Sales_Code__c='Option1');
        Product2 p6 = new Product2(Name='Test Pricing Product 6', IsActive=True,ProductCode='LG-Option2',Product_Category__c='Product Options',Sales_Code__c='Option2');
        Product2 p7 = new Product2(Name='Test Pricing Product 7', IsActive=True,ProductCode='LG-Option3',Product_Category__c='Product Options',Sales_Code__c='Option3');
        Product2 p8 = new Product2(Name='Test Pricing Product 8', IsActive=True,ProductCode='LG-Option4',Product_Category__c='Product Options',Sales_Code__c='Option4');
        insert new List<Product2> {p1,p2,p3,p4,p5,p6,p7,p8};
       
        Id pbid = Test.getStandardPricebookId();
        PricebookEntry pbe1 = new PricebookEntry(Pricebook2Id=pbid, Product2Id=p1.id, UnitPrice=1, IsActive=True,CurrencyIsoCode = 'EUR');
        PricebookEntry pbe2 = new PricebookEntry(Pricebook2Id=pbid, Product2Id=p2.id, UnitPrice=2, IsActive=True,CurrencyIsoCode = 'EUR');
        PricebookEntry pbe3 = new PricebookEntry(Pricebook2Id=pbid, Product2Id=p3.id, UnitPrice=3, IsActive=True,CurrencyIsoCode = 'EUR');
        PricebookEntry pbe4 = new PricebookEntry(Pricebook2Id=pbid, Product2Id=p4.id, UnitPrice=4, IsActive=True,CurrencyIsoCode = 'EUR');
        PricebookEntry pbe5 = new PricebookEntry(Pricebook2Id=pbid, Product2Id=p5.id, UnitPrice=5, IsActive=True,CurrencyIsoCode = 'EUR');
        PricebookEntry pbe6 = new PricebookEntry(Pricebook2Id=pbid, Product2Id=p6.id, UnitPrice=6, IsActive=True,CurrencyIsoCode = 'EUR');
        PricebookEntry pbe7 = new PricebookEntry(Pricebook2Id=pbid, Product2Id=p7.id, UnitPrice=5, IsActive=True,CurrencyIsoCode = 'EUR');
        PricebookEntry pbe8 = new PricebookEntry(Pricebook2Id=pbid, Product2Id=p8.id, UnitPrice=6, IsActive=True,CurrencyIsoCode = 'EUR');
        insert new List<PricebookEntry> {pbe1,pbe2,pbe3,pbe4,pbe5,pbe6,pbe7,pbe8};

        String B2CRecordTypeId= [SELECT Id FROM RecordType WHERE (Name='B2C Account') and (SobjectType='Account')].Id;
        String B2BRecordTypeId= [SELECT Id FROM RecordType WHERE (Name='B2B Account') and (SobjectType='Account')].Id;
        // Create B2C Account
        Account pa1 = new Account(RecordTypeID=B2CRecordTypeId,
                    FirstName='My',
                    LastName='Person Account',
                    PersonEmail='test1@factory.com',
                    PersonMailingCountry ='Finland',
                    PersonMailingCity='Kaupunki',
                    PersonMailingPostalCode = '1111',
                    PersonMailingStreet='Katu 1'); 
        // Create B2B Account
        Account a1 = new Account(Name='Business Account',
                    RecordTypeID=B2BRecordTypeId,
                    BillingCountry ='Finland',
                    BillingCity='Kaupunki',
                    BillingPostalCode = '3333',
                    BillingStreet = 'Katu 3');
        insert new List<Account> {a1,pa1};       
        system.debug ('*** setupPriceRecords Person Account: '+pa1.id);
        system.debug ('*** setupPriceRecords Business Account: '+a1.id);
        Opportunity o1 = new Opportunity(
                                    Name='B2C Opportunity', 
                                    StageName='Quoting', 
                                    CloseDate=system.Today()+10,
                                    Pricebook2Id=pbid,
            						Property_Type__c = 'ROW',
                                    AccountId = pa1.Id
                                    );
        Opportunity o2 = new Opportunity(
                                    Name='B2B Opportunity', 
                                    StageName='Quoting', 
                                    CloseDate=system.Today()+30,
            						Property_Type__c = 'ROW',
                                    Pricebook2Id=pbid,
                                    AccountId = a1.Id
                                    );
        insert new List<Opportunity>{o1,o2};
        system.debug ('*** setupPriceRecords Quoting Opportunity: '+o1.id);
        OpportunityLineItem oli1 = new OpportunityLineItem(  OpportunityId=o1.id, 
                                                            Product2Id=p1.id, 
                                                            PricebookEntryId=pbe1.Id,
                                                            Quantity=1,
                                                            UnitPrice=pbe1.UnitPrice    
                                                            );
        
        OpportunityLineItem oli2 = new OpportunityLineItem(  OpportunityId=o1.id, 
                                                                Product2Id=p1.id, 
                                                                PricebookEntryId=pbe2.Id,
                                                                Quantity=2,
                                                                UnitPrice=pbe2.UnitPrice    
                                                                );
        insert new List<OpportunityLineItem> {oli1,oli2};
        Quote q1 = new Quote(
                        Name='B2C Pricing Quote', 
                        Status='Configure', 
                        Pricebook2Id=pbid,
                        OpportunityId=o1.Id
                        );
        
        Quote q2 = new Quote(
                        Name='B2B Pricing Quote', 
                        Status='Configure', 
                        Pricebook2Id=pbid,
                        OpportunityId=o2.Id
                        );
        insert new List<Quote> {q1,q2};

        // Synced quote
        Opportunity o = [SELECT Id,SyncedQuoteId FROM Opportunity WHERE Id =: o1.Id  LIMIT 1];
        Id syncedQuoteId;
        if (o.SyncedQuoteId == null) { 
            System.Debug ('*** Synced Quote: '+o.SyncedQuoteId);
            Quote q = [SELECT Id,OpportunityId,IsSyncing FROM Quote WHERE OpportunityId =: o.Id LIMIT 1];
            o.syncedQuoteId = q.Id;
            update o;
            syncedQuoteId = q.Id;
        } else {
            syncedQuoteId = o.SyncedQuoteId;
        }
        // Create QuoteLines
        system.debug ('*** setupPriceRecords Quote : '+q1.id);
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
        QuoteLineItem ql4 = new QuoteLineItem(  QuoteId=syncedQuoteId, 
                                                Product2Id=p4.id, 
                                                PricebookEntryId=pbe4.Id,
                                                Quantity=4,
                                                UnitPrice=pbe4.UnitPrice    
                                                );
        QuoteLineItem ql5 = new QuoteLineItem(  QuoteId=syncedQuoteId, 
                                                Product2Id=p5.id, 
                                                PricebookEntryId=pbe5.Id,
                                                Quantity=5,
                                                UnitPrice=pbe5.UnitPrice   
                                                );
        QuoteLineItem ql6 = new QuoteLineItem(  QuoteId=syncedQuoteId, 
                                                Product2Id=p6.id, 
                                                PricebookEntryId=pbe6.Id,
                                                Quantity=6,
                                                UnitPrice=pbe6.UnitPrice   
                                                );
        insert new List<QuoteLineItem> {ql1,ql2,ql3,ql4,ql5,ql6};
        system.debug ('*** setupPriceRecords Quote Line: '+ql1.id+'for Quote '+q1);
        system.debug ('*** setupPriceRecords Quote Line: '+ql4.id+'for Quote '+syncedQuoteId);
        // Create Parent Config B2C
        Configuration__c cfg1 = new Configuration__c(
                                        Opportunity__c = o1.Id,
                                        Name='Test Pricing Config 1',
                                        Plan_Apartment__c = 'A1',// public String apartment; // Door Nbr in Apartment
                                        Plan_Floor__c = 6,// public Integer floor; // Floor Nbr in Building
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
                                        Plan_Floor__c = 6,// public Integer floor; // Floor Nbr in Building
                                        Visual_Id__c = 'ABCDE2',//public String id; // Unique Visual Configuration Id
                                        Plan_Line__c = '200',// public String line; //?
                                        Plan_Name__c = 'plan 2',// public String name; // Name of the Configuration
                                        //public List<Products> products; // Product Model aka Configurable Product
                                        Visual_Version__c = 2);//public Integer version; // Configuration Version);
        // Create Parent Config B2B
        Configuration__c cfg3 = new Configuration__c(
                                        Opportunity__c = o2.Id,
                                        Name='Test Pricing Config 3',
                                        Plan_Apartment__c = 'C3',// public String apartment; // Door Nbr in Apartment
                                        Plan_Floor__c = 6,// public Integer floor; // Floor Nbr in Building
                                        Visual_Id__c = 'ABCDE3',//public String id; // Unique Visual Configuration Id
                                        Plan_Line__c = '300',// public String line; //?
                                        Plan_Name__c = 'plan 3',// public String name; // Name of the Configuration
                                        //public List<Products> products; // Product Model aka Configurable Product
                                        Visual_Version__c = 3);//public Integer version; // Configuration Version);
        Configuration__c cfg4 = new Configuration__c(
                                        Opportunity__c = o2.Id,
                                        Name='Test Pricing Config 4',
                                        Plan_Apartment__c = 'D4',// public String apartment; // Door Nbr in Apartment
                                        Plan_Floor__c = 6,// public Integer floor; // Floor Nbr in Building
                                        Visual_Id__c = 'ABCDE4',//public String id; // Unique Visual Configuration Id
                                        Plan_Line__c = '400',// public String line; //?
                                        Plan_Name__c = 'plan 4',// public String name; // Name of the Configuration
                                        //public List<Products> products; // Product Model aka Configurable Product
                                        Visual_Version__c = 4);//public Integer version; // Configuration Version);
        insert new List<Configuration__c>{cfg1,cfg2,cfg3,cfg4};
        // Create Config Product(s)
        Configuration_Product__c cfgProd1 = new Configuration_Product__c(
                                        Name='COST', //public String name; // Name of the Product Model
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
                                        Name='COST', //public String name; // Name of the Product Model
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
        // Create Config Option
        Configuration_Option__c cfgOpt1 = new Configuration_Option__c(
                                        Name='Test Pricing Config Option 1',
                                        Configuration_Product__c = cfgProd1.Id,
                                        Quantity__c = 11.11, //public Double Amount;
                                        Local_Supplier__c = FALSE, //public Boolean LocalSupplier;
                                        Parameter_code__c = 'param1',// public String ParameterCode;
                                        Product_Code__c = 'LG-Option1',// public String SalesCode;
                                        Sales_Code__c = 'Option1',// public String SalesCode;
                                        //unique_id__c = 1,// public Integer UniqueId;
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
                                        //unique_id__c = 1,// public Integer UniqueId;
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
                                        //unique_id__c = 1,// public Integer UniqueId;
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
                                        //unique_id__c = 1,// public Integer UniqueId;
                                        Unit_Of_Measure__c = 'M2');//public String Unit
                                        //RVN_Number__c = '22222-2'// (oppty Number+) Visual Structure nbr   
        Configuration_Option__c cfgOpt5 = new Configuration_Option__c(
                                        Name='Test Data Config Option 5',
                                        Configuration_Product__c = cfgProd3.Id,
                                        Quantity__c = 33.11, //public Double Amount;
                                        Local_Supplier__c = FALSE, //public Boolean LocalSupplier;
                                        Parameter_code__c = 'param5',// public String ParameterCode;
                                        Product_Code__c = 'COST-Option1',// public String SalesCode;
                                        Sales_Code__c = 'Option1',// public String SalesCode;
                                        //unique_id__c = 1,// public Integer UniqueId;
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
                                        //unique_id__c = 1,// public Integer UniqueId;
                                        Unit_Of_Measure__c = 'M3');//public String Unit
                                        //RVN_Number__c = '33333-3'// (oppty Number+) Visual Structure nbr 
        insert new List<Configuration_Option__c>{cfgOpt1,cfgOpt2,cfgOpt3,cfgOpt4,cfgOpt5,cfgOpt6};    
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
        Factory_Price__c fp1 = new Factory_Price__c();
        fp1.Organization__c = 'LSU'; 
        fp1.Country__c = 'FI'; 
        fp1.Business_Type__c = 'Consumer';
        fp1.Product_Group__c = 'COST';
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
        insert new List<Factory_Price__c> {fp1,fp2};
        Product_Cost__c pc1 = new Product_Cost__c();
        pc1.Organization__c = 'LSU'; 
        pc1.Country__c = 'FI'; 
        pc1.Business_Type__c = 'Consumer';
        pc1.District__c = 'FI_North';
        pc1.Product_Group__c = 'COST';
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
        insert new List<Product_Cost__c> {pc1,pc2};
            
        Sales_Price__c sp1 = new Sales_Price__c();
        sp1.Organization__c = 'LSU'; 
        sp1.Country__c = 'FI'; 
        sp1.Business_Type__c = 'Consumer';
        sp1.District__c = 'FI_North';
        sp1.Product_Group__c = 'COST';
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
        insert new List<Sales_Price__c> {sp1,sp2};
    }  
	@future    
    public static void setupContractRecords() {
        Product2 p1 = new Product2(Name='Test Contract Product 1', IsActive=True,ProductCode='COST',Product_Category__c='Product Models');
        Product2 p2 = new Product2(Name='Test Contract Product 2', IsActive=True,ProductCode='Option 1',Product_Category__c='Product Options');
        insert new List<Product2> {p1,p2};
        system.debug ('*** setupContractRecords product 1: '+p1);
        system.debug ('*** setupContractRecords product 2: '+p2);
        Id pbid = Test.getStandardPricebookId();
        PricebookEntry pbe1 = new PricebookEntry(Pricebook2Id=pbid, Product2Id=p1.id, UnitPrice=1, IsActive=True,CurrencyIsoCode = 'EUR');
        PricebookEntry pbe2 = new PricebookEntry(Pricebook2Id=pbid, Product2Id=p2.id, UnitPrice=2, IsActive=True,CurrencyIsoCode = 'EUR');    
        insert new List<PricebookEntry> {pbe1,pbe2};
        system.debug ('*** setupContractRecords PricebookEntry 1: '+pbe1);
        system.debug ('*** setupContractRecords PricebookEntry 2: '+pbe2);
        String B2CRecordTypeId= [SELECT Id FROM RecordType WHERE (Name='B2C Account') and (SobjectType='Account')].Id;
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
        insert p;        
        system.debug ('*** setupContractRecords Person Account: '+p.id);
        // Prepare Offer
        Opportunity o1 = new Opportunity(
            Name='B2C Opportunity', 
            StageName='Quoting', 
            CloseDate=system.Today()+10,
            Delivery_Date__c=System.Today()+90,
            Property_Type__c = 'ROW',
            Pricebook2Id=pbid,
            AccountId = p.Id
            );
        insert o1;
        OpportunityLineItem ol1 = new OpportunityLineItem(  OpportunityId=o1.id, 
                                                Product2Id=p1.id, 
                                                PricebookEntryId=pbe1.Id,
                                                Quantity=1,
                                                UnitPrice=pbe1.UnitPrice    
                                                );
        OpportunityLineItem ol2 = new OpportunityLineItem(  OpportunityId=o1.id, 
                                                Product2Id=p2.id, 
                                                PricebookEntryId=pbe2.Id,
                                                Quantity=2,
                                                UnitPrice=pbe2.UnitPrice    
                                                );
        insert new List<OpportunityLineItem> {ol1,ol2};
        // Offer Send Pending Customer
        Contract c1 = new Contract(
            Name = 'B2C Draft Contract',
            AccountId = p.Id, 
            Status = 'Draft', 
            Opportunity__c = o1.Id
            );
        insert c1;
        system.debug ('*** setupContractRecords contract 1: '+c1);
    }     
    public static void setupOrderRecords() {
        Product2 p1 = new Product2(Name='Test Order Product 1', IsActive=True,ProductCode='COST',Product_Category__c='Product Models');
        Product2 p2 = new Product2(Name='Test Order Product 2', IsActive=True,ProductCode='Option 1',Product_Category__c='Product Options');
        Product2 p3 = new Product2(Name='Test Order Product 3', IsActive=True,ProductCode='Option 2',Product_Category__c='Product Options');
        insert new List<Product2> {p1,p2};
            
        Id pbid = Test.getStandardPricebookId();
        PricebookEntry pbe1 = new PricebookEntry(Pricebook2Id=pbid, Product2Id=p1.id, UnitPrice=1, IsActive=True,CurrencyIsoCode = 'EUR');
        PricebookEntry pbe2 = new PricebookEntry(Pricebook2Id=pbid, Product2Id=p2.id, UnitPrice=2, IsActive=True,CurrencyIsoCode = 'EUR');
        PricebookEntry pbe3 = new PricebookEntry(Pricebook2Id=pbid, Product2Id=p3.id, UnitPrice=3, IsActive=True,CurrencyIsoCode = 'EUR');
        
        insert new List<PricebookEntry> {pbe1,pbe2};
            
        String B2CRecordTypeId= [SELECT Id FROM RecordType WHERE (Name='B2C Account') and (SobjectType='Account')].Id;
        List<Account> accts = new List<Account>();
        // Create B2C Account
        Account p = new Account(      
            RecordTypeID=B2CRecordTypeId,
            FirstName='My',
            LastName='Person Account',
            PersonEmail='test.order@factory.com',
            PersonMailingCountry ='Finland',
            PersonMailingCity='City',
            PersonMailingPostalCode = '33333',
            PersonMailingStreet='Street 1');
        accts.add(p);  
        insert accts;        
        system.debug ('*** setupOrderRecords Person Account: '+p.id);
        
        Schema.Location l = new Schema.Location(Name = 'TestL');
        
        insert l;
        
        // Prepare Offer
        List<Opportunity> oppList = new List<Opportunity>(); 
        Opportunity o1 = new Opportunity(
            Name='B2C Opportunity 1', 
            StageName='Quoting', 
            Customer_Segment__c = '1000',
            CloseDate=system.Today()+10,
            Delivery_Date__c=System.Today()+90,
            Delivery_Location__c = l.Id,
            Terrain_Type__c = 'Terrain Class I', // Not sure where needed
            Confirmed_installation_time__c = system.today()+90,
            Property_Type__c = 'ROW',
            Pricebook2Id=pbid,
            AccountId = p.Id
            );
        oppList.add(o1);
        Opportunity o2 = new Opportunity(
            Name='B2C Opportunity 2', 
            Customer_Segment__c = '1000',
            StageName='Quoting', 
            CloseDate=system.Today()+10,
            Delivery_Date__c=System.Today()+90,
            Terrain_Type__c = 'Terrain Class II', // Not sure where needed
            Confirmed_installation_time__c = system.today()+90,
            Property_Type__c = 'ROW',
            Pricebook2Id=pbid,
            AccountId = p.Id
            );
        oppList.add(o2);
        insert oppList;
        
        Opportunity o = [SELECT Id, Name, AccountId, Delivery_Location__c, Delivery_date__c, Installation_duration__c  FROM Opportunity WHERE Id =: o1.Id limit 1];

		OperatingHours oh = new OperatingHours(Name = 'testOH');
		insert oh;

		FSL__Scheduling_Policy__c sp = new FSL__Scheduling_Policy__c(Name = 'Custom Component Reservation');
		insert sp;

		ServiceTerritory st = new ServiceTerritory(Name = 'testT', Appointment_Booking_Offset__c = 5, OperatingHoursId = oh.Id, IsActive = true);
		insert st;
		st = [SELECT Id, Appointment_Booking_Offset__c FROM ServiceTerritory Limit 1];

		WorkOrder wo = new WorkOrder(Subject = o.Name, Opportunity__c = o.Id, AccountId = o.AccountId, LocationId = o.Delivery_Location__c, Duration = o.Installation_duration__c, DurationType = 'Hours', ServiceTerritoryId = st.Id);
        insert wo;

		ServiceAppointment sa = new ServiceAppointment(ParentRecordId = wo.Id, EarliestStartTime = o.Delivery_date__c, DueDate = o.Delivery_date__c.addDays(5), Duration = o.Installation_duration__c);
        insert sa;
        
        Quote q1 = [SELECT Id,IsSyncing,OpportunityId FROM Quote WHERE OpportunityId =: o1.Id]; //This points to the Synced Quote autocreated by Flow
        system.debug ('*** setupQuoteRecords B2C Quote 1: '+q1);
        
        Quote q2= new Quote( //Added Non-syncing Quote -> Oppty not updated with this Id as syncedQuoteId
            Name='B2B Quote', 
            Status='Draft', 
            Pricebook2Id=pbid,
            OpportunityId=o2.Id
            );
        insert q2;
        system.debug ('*** setupQuoteRecords B2B Quote: '+q2);
        o2.SyncedQuoteId = q2.Id;
        update o2;
        // Create QuoteLines
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
        insert ql1;
        insert ql2;
        system.debug ('*** quoteRecordsSetup Quote 1 QuoteLine 1: '+ql1.id);   
        system.debug ('*** quoteRecordsSetup Quote 1 QuoteLine 2: '+ql2.id);
        
        
        // Offer Send Pending Customer
        system.debug ('*** setupOrderRecords B2C Opportunity 1: '+o1.id);
        List<Contract> conList = new List<Contract>();
        system.debug ('*** setupOrderRecords B2C Opportunity 1: '+o1.id);
        Contract c1 = new Contract(
            Name = 'B2C Draft Contract 1',
            AccountId = p.Id, 
            Status = 'Draft', 
            Contract_type__c = 'Final Contract',
            StartDate = Date.today(),
            Opportunity__c = o1.Id
            );
        conList.add(c1);
        Contract c2 = new Contract(
            Name = 'B2C Draft Contract 2',
            AccountId = p.Id, 
            Status = 'Draft', 
            Contract_type__c = 'Final Contract',
            StartDate = Date.today(),
            Opportunity__c = o2.Id
            );
        conList.add(c2);
        insert conList;
        
        // Create Parent Config B2C
        Configuration__c cfg1 = new Configuration__c(
            Opportunity__c = o1.Id,
            Name='Test Order Config 1',
            Plan_Apartment__c = 'A1',// public String apartment; // Door Nbr in Apartment
            Plan_Floor__c = 6,// public Integer floor; // Floor Nbr in Building
            Visual_Id__c = 'ABCDE1',//public String id; // Unique Visual Configuration Id
            Plan_Line__c = '100',// public String line; //?
            Plan_Name__c = 'plan 1',// public String name; // Name of the Configuration
            //public List<Products> products; // Product Model aka Configurable Product
            Visual_Version__c = 1);//public Integer version; // Configuration Version);
        
        // Create Parent Config B2C
        Configuration__c cfg2 = new Configuration__c(
            Opportunity__c = o2.Id,
            Name='Test Order Config 2',
            Plan_Apartment__c = 'A2',// public String apartment; // Door Nbr in Apartment
            Plan_Floor__c = 6,// public Integer floor; // Floor Nbr in Building
            Visual_Id__c = 'ABCDE2',//public String id; // Unique Visual Configuration Id
            Plan_Line__c = '100',// public String line; //?
            Plan_Name__c = 'plan 2',// public String name; // Name of the Configuration
            //public List<Products> products; // Product Model aka Configurable Product
            Visual_Version__c = 2);//public Integer version; // Configuration Version);
        
        insert new List<Configuration__c>{cfg1,cfg2};
        
        // Create Config Product(s)
        Configuration_Product__c cfgProd1 = new Configuration_Product__c(
            Name='LG', //public String name; // Name of the Product Model
            Configuration__c = cfg1.Id, // Parent Configuration
            Quantity__c = 1, // Amount must be 1 for each Product in a configuration
            Features_Confirmed__c = False,//public Boolean hasFeaturesBeenConfirmed;
            Measurements_Verified__c = False,// public Boolean hasMeasurementsBeenVerified;
            Visual_Product_Id__c = 'abcde1x',//public String id; // Product Code of Product Model
            Product_Type__c = 'Glazing',
            Inspection_Code__c = 2,//public Integer productInspectCode;
            Product_Length__c = 2.5, //public Double productLength;
            Visual_Structure_Number__c = '12345678',
            RVN_Number__c = '11111-1'); // public String rvn; //ProjectNbr + Structure);
        
        Configuration_Product__c cfgProd2 = new Configuration_Product__c(
            Name='COST', //public String name; // Name of the Product Model
            Configuration__c = cfg2.Id, // Parent Configuration
            Quantity__c = 1, // Amount must be 1 for each Product in a configuration
            Features_Confirmed__c = False,//public Boolean hasFeaturesBeenConfirmed;
            Measurements_Verified__c = False,// public Boolean hasMeasurementsBeenVerified;
            Visual_Product_Id__c = 'abcde2x',//public String id; // Product Code of Product Model
            Product_Type__c = 'Glazing',
            Inspection_Code__c = 2,//public Integer productInspectCode;
            Product_Length__c = 2.5, //public Double productLength;
            Visual_Structure_Number__c = '23456789',
            RVN_Number__c = '22222-2'); // public String rvn; //ProjectNbr + Structure);
        insert new List<Configuration_Product__c>{cfgProd1,cfgProd2};
        
        // Create Config Option
        Configuration_Option__c cfgOpt1 = new Configuration_Option__c(
            Name='Test Order Config Option 1',
            Configuration_Product__c = cfgProd1.Id,
            Quantity__c = 11.11, //public Double Amount;
            Local_Supplier__c = FALSE, //public Boolean LocalSupplier;
            Parameter_code__c = 'param1',// public String ParameterCode;
            Sales_Code__c = 'Option 1',// public String SalesCode;
            //unique_id__c = 1,// public Integer UniqueId;
            Unit_Of_Measure__c = 'M');//public String Unit
            //RVN_Number__c = '11111-1'// (oppty Number+) Visual Structure nbr  
        Configuration_Option__c cfgOpt2 = new Configuration_Option__c(
            Name='Test Order Config Option 2',
            Configuration_Product__c = cfgProd1.Id,
            Quantity__c = 11.22, //public Double Amount;
            Local_Supplier__c = FALSE, //public Boolean LocalSupplier;
            Parameter_code__c = 'param2',// public String ParameterCode;
            Sales_Code__c = 'Option 2',// public String SalesCode;
            //unique_id__c = 1,// public Integer UniqueId;
            Unit_Of_Measure__c = 'h');//public String Unit
            //RVN_Number__c = '11111-1'// (oppty Number+) Visual Structure nbr   
        Configuration_Option__c cfgOpt3 = new Configuration_Option__c(
            Name='Test Order Config Option 3',
            Configuration_Product__c = cfgProd2.Id,
            Quantity__c = 22.11, //public Double Amount;
            Local_Supplier__c = FALSE, //public Boolean LocalSupplier;
            Parameter_code__c = 'param3',// public String ParameterCode;
            Sales_Code__c = 'Option 3',// public String SalesCode;
            //unique_id__c = 1,// public Integer UniqueId;
            Unit_Of_Measure__c = 'pcs');//public String Unit
            //RVN_Number__c = '22222-2'// (oppty Number+) Visual Structure nbr   
        Configuration_Option__c cfgOpt4 = new Configuration_Option__c(
            Name='Test Order Config Option 4',
            Configuration_Product__c = cfgProd2.Id,
            Quantity__c = 22.22, //public Double Amount;
            Local_Supplier__c = FALSE, //public Boolean LocalSupplier;
            Parameter_code__c = 'param4',// public String ParameterCode;
            Sales_Code__c = 'Option 4',// public String SalesCode;
            //unique_id__c = 1,// public Integer UniqueId;
            Unit_Of_Measure__c = 'M2');//public String Unit
            //RVN_Number__c = '22222-2'// (oppty Number+) Visual Structure nbr   
        insert new List<Configuration_Option__c>{cfgOpt1,cfgOpt2,cfgOpt3,cfgOpt4};    
        
        // Create Config Message
        Configuration_Message__c cfgMsg1 = new Configuration_Message__c(
            Name='Test Order Config Message',
            Configuration_Product__c = cfgProd1.Id,
            Message_Key__c = 'E12345',
            Space_Side_Number__c = 1);
        Configuration_Message__c cfgMsg2 = new Configuration_Message__c(
            Name='Test Order Config Message',
            Configuration_Product__c = cfgProd2.Id,
            Message_Key__c = 'E12345',
            Space_Side_Number__c = 3);
        insert new List<Configuration_Message__c>{cfgMsg1,cfgMsg2}; 
        
        Order ord1 = new Order(
            Name='Test Order 1',
            ContractId = c1.Id,
            OpportunityId = o1.Id,
            AccountId = p.Id,
            Status = 'Draft', 
            EffectiveDate = Date.today(), 
            Pricebook2Id = pbId
            );
        insert new List<Order>{ord1};  
        
        OrderItem oi1 = new OrderItem(
            OrderId = ord1.Id, 
            Quantity = 100, 
            PricebookEntryId = pbe1.Id, 
            UnitPrice = 1000);
        insert oi1;
         
        List<ContentDocumentLink> cdlList = new List<ContentDocumentLink>(); 
        String json = '{\"country\":\"FI5\",\"product_type\":\"LGS\",\"terrain_class\":1,\"building_height\":90,\"reference_windspeed\":9,\"slope\":0,\"wind_pressure\":0.8,\"corner_coefficient\":0,\"structure\":0,\"product_openings\":1,\"report\":0,\"structure_number\":\"12345678\"}';  
        ContentVersion cv = new ContentVersion(VersionData = Blob.valueOf(json), Title = 'Visual Output_12345678', PathOnClient = 'VisualOutput_12345678.json');
        insert cv;
         
        String xml = '<?xml version="1.0" encoding="utf-16"?><products xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">';
        xml += '<structural_version_number>12345678</structural_version_number>';
        xml += '<balconyglazing><product_name>LFIXEDWALL</product_name><weight><value>303.609344482422</value></weight></balconyglazing>';
        xml+= '<area><value>321</value></area><blinds_area><value>11</value></blinds_area><glass_count><value>1</value></glass_count></products>';
        
        ContentVersion cv2 = new ContentVersion(VersionData = Blob.valueOf(xml), Title = 'Visual Plan Statistics_LG_JJwh5kqCaUm_attxb4b5Jg_12345678', PathOnClient = 'Visual%20Plan%20Statistics_LG_JJwh5kqCaUm_attxb4b5Jg_12345678.xml');
        insert cv2;
        
        String documentationXml = '<?xml version="1.0" encoding="utf-16"?><products xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">';
        documentationXml += '<name>TESTVisualDocumentation</name>';
        documentationXml += '<structural_version_number>12345678</structural_version_number>';
        documentationXml += '<space><corner_multiplier>No</corner_multiplier></space>';
        documentationXml += '<balconyglazing><product_code>LFIXEDWALL</product_code>';
        documentationXml += '<product_code_short>LFIXEDWALL</product_code_short><structural_version_number>12345678</structural_version_number>';
        documentationXml += '<unique_system_id>-Ei7ms2lCkKX-OgKYSUlhQ</unique_system_id><product_weight>303.609344482422</product_weight>';
        documentationXml += '<order_xml_info>&lt;rivipaino&gt;303.609344482422&lt;/rivipaino&gt;&lt;sivut&gt;&lt;sivu&gt;&lt;numero&gt;1&lt;/numero&gt;&lt;profiilivari-yla&gt;RAL9006&lt;/profiilivari-yla&gt;&lt;profiilivari-ala&gt;RAL9006&lt;/profiilivari-ala&gt;&lt;lasi-vahvuus&gt;8&lt;/lasi-vahvuus&gt;&lt;lasi-vari&gt;20090017&lt;/lasi-vari&gt;&lt;lasi-karkaisu&gt;1&lt;/lasi-karkaisu&gt;&lt;muovivari-yla&gt;Tummanharmaa&lt;/muovivari-yla&gt;&lt;muovivari-ala&gt;Tummanharmaa&lt;/muovivari-ala&gt;&lt;profiili-yla&gt;11222206&lt;/profiili-yla&gt;&lt;profiili-ala&gt;11243001&lt;/profiili-ala&gt;&lt;profiili-saato&gt;11241205&lt;/profiili-saato&gt;&lt;profiilipituus&gt;3000&lt;/profiilipituus&gt;&lt;lasitus-pituus&gt;3000&lt;/lasitus-pituus&gt;&lt;lasitus-korkeus&gt;2000&lt;/lasitus-korkeus&gt;&lt;lasivasen-kpl&gt;4&lt;/lasivasen-kpl&gt;&lt;lasioikea-kpl&gt;0&lt;/lasioikea-kpl&gt;&lt;kulmanylitys&gt;0&lt;/kulmanylitys&gt;&lt;sivun-paino&gt;220.997283935547&lt;/sivun-paino&gt;&lt;alkukulma&gt;90&lt;/alkukulma&gt;&lt;loppukulma&gt;90&lt;/loppukulma&gt;&lt;jarjestelmakulma&gt;&lt;/jarjestelmakulma&gt;&lt;/sivu&gt;&lt;/sivut&gt;</order_xml_info>';
        documentationXml += '</balconyglazing></products>';
        
        
        ContentVersion cv3 = new ContentVersion(VersionData = Blob.valueOf(documentationXml), Title = 'Visual Documentation Test', PathOnClient = 'Visual%20Documentation%20Test.xml');
        insert cv3;
        
        String outputXml = '<?xml version="1.0" encoding="utf-16"?><configuration><PAATASO><REKLAMAATIO>0</REKLAMAATIO>';
        outputXml += '<RAKENNENUMERO>#ORDER_NO#12345678</RAKENNENUMERO><ERIKOISTILAUS>0</ERIKOISTILAUS></PAATASO></configuration>';
    
    	
        ContentVersion cv4 = new ContentVersion(VersionData = Blob.valueOf(outputXml), Title = 'Visual Output_12345678', PathOnClient = 'VisualOutput_12345678.xml');
        insert cv4;
        
        
        cv = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =: cv.Id];
        cv2 = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =: cv2.Id];
        cv3 = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =: cv3.Id];
        cv4 = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =: cv4.Id];
        
        ContentDocumentLink cdl1 = new ContentDocumentLink(ContentDocumentId = cv.ContentDocumentId, LinkedEntityId = cfg1.Id);
        ContentDocumentLink cdl2 = new ContentDocumentLink(ContentDocumentId = cv2.ContentDocumentId, LinkedEntityId = cfg1.Id);
        ContentDocumentLink cdl3 = new ContentDocumentLink(ContentDocumentId = cv3.ContentDocumentId, LinkedEntityId = cfg1.Id);
        ContentDocumentLink cdl4 = new ContentDocumentLink(ContentDocumentId = cv4.ContentDocumentId, LinkedEntityId = cfg1.Id);
        insert new List<ContentDocumentLink>{cdl1,cdl2,cdl3,cdl4};  
            
    }
 	
    public static void setupConfigurationRecords() {
        Product2 p1 = new Product2(Name='Test Configuration Product 1', IsActive=True,ProductCode='COST',Product_Category__c='Product Models');
        Product2 p2 = new Product2(Name='Test Configuration Product 2', IsActive=True,ProductCode='COST-Option1',Product_Category__c='Product Options',Sales_Code__c='Option1');
        Product2 p3 = new Product2(Name='Test Configuration Product 3', IsActive=True,ProductCode='COST-Option2',Product_Category__c='Product Options',Sales_Code__c='Option2');
        Product2 p4 = new Product2(Name='Test Configuration Product 4', IsActive=True,ProductCode='LG',Product_Category__c='Product Models');
        Product2 p5 = new Product2(Name='Test Configuration Product 5', IsActive=True,ProductCode='LG-Option1',Product_Category__c='Product Options',Sales_Code__c='Option1');
        Product2 p6 = new Product2(Name='Test Configuration Product 6', IsActive=True,ProductCode='LG-Option2',Product_Category__c='Product Options',Sales_Code__c='Option2');
        insert new List<Product2> {p1,p2,p3,p4,p5,p6};
        
        Id pbid = Test.getStandardPricebookId();
        
        PricebookEntry pbe1 = new PricebookEntry(Pricebook2Id=pbid, Product2Id=p1.id, UnitPrice=1, IsActive=True,CurrencyIsoCode = 'EUR');
        PricebookEntry pbe2 = new PricebookEntry(Pricebook2Id=pbid, Product2Id=p2.id, UnitPrice=2, IsActive=True,CurrencyIsoCode = 'EUR');
        PricebookEntry pbe3 = new PricebookEntry(Pricebook2Id=pbid, Product2Id=p3.id, UnitPrice=3, IsActive=True,CurrencyIsoCode = 'EUR');
        PricebookEntry pbe4 = new PricebookEntry(Pricebook2Id=pbid, Product2Id=p4.id, UnitPrice=4, IsActive=True,CurrencyIsoCode = 'EUR');
        PricebookEntry pbe5 = new PricebookEntry(Pricebook2Id=pbid, Product2Id=p5.id, UnitPrice=5, IsActive=True,CurrencyIsoCode = 'EUR');
        PricebookEntry pbe6 = new PricebookEntry(Pricebook2Id=pbid, Product2Id=p6.id, UnitPrice=6, IsActive=True,CurrencyIsoCode = 'EUR');        
        insert new List<PricebookEntry> {pbe1,pbe2,pbe3,pbe4,pbe5,pbe6};
        
        String B2CRecordTypeId= [SELECT Id FROM RecordType WHERE (Name='B2C Account') and (SobjectType='Account')].Id;
        String B2BRecordTypeId= [SELECT Id FROM RecordType WHERE (Name='B2B Account') and (SobjectType='Account')].Id;
        List<Account> accts = new List<Account>();
        // Create B2C Account
            Account p = new Account(      
                RecordTypeID=B2CRecordTypeId,
                FirstName='My',
                LastName='Config Account',
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
        Opportunity o1 = new Opportunity(
            Name='B2C Opportunity', 
            StageName='Quoting', 
            CloseDate=system.Today()+10,
            Pricebook2Id=pbid,
            Property_Type__c = 'ROW',
            AccountId = p.Id
            );
        
        Opportunity o2 = new Opportunity(
            Name='B2B Opportunity', 
            StageName='Quoting', 
            CloseDate=system.Today()+30,
            Property_Type__c = 'APA',
            Pricebook2Id=pbid,
            AccountId = a.Id
            );
        insert new List<Opportunity>{o1,o2};
        // Create Parent Config
        Configuration__c cfg1 = new Configuration__c(
            Opportunity__c = o1.Id,
            Name='Test Config 1',
            Plan_Apartment__c = 'A1',// public String apartment; // Door Nbr in Apartment
            Plan_Floor__c = 6,// public Integer floor; // Floor Nbr in Building
            Visual_Id__c = 'ABCDE1',//public String id; // Unique Visual Configuration Id
            Plan_Line__c = '100',// public String line; //?
            Plan_Name__c = 'NAME',// public String name; // Name of the Configuration
            //public List<Products> products; // Product Model aka Configurable Product
            Visual_Version__c = 3);//public Integer version; // Configuration Version);
        
        Configuration__c cfg2 = new Configuration__c(
            Opportunity__c = o2.Id,
            Name='Test Config 2',
            Plan_Apartment__c = 'B2',// public String apartment; // Door Nbr in Apartment
            Plan_Floor__c = 6,// public Integer floor; // Floor Nbr in Building
            Visual_Id__c = 'ABCDE2',//public String id; // Unique Visual Configuration Id
            Plan_Line__c = '200',// public String line; //?
            Plan_Name__c = 'NAME',// public String name; // Name of the Configuration
            //public List<Products> products; // Product Model aka Configurable Product
            Visual_Version__c =4);//public Integer version; // Configuration Version);
        
        insert new List<Configuration__c>{cfg1,cfg2};
        // Create Config Product
        Configuration_Product__c cfgProd1 = new Configuration_Product__c(
            Name='COST', //public String name; // Name of the Product Model
            Configuration__c = cfg1.Id, // Parent Configuration
            Quantity__c = 1, // Amount must be 1 for each Product in a configuration
            Features_Confirmed__c = False,//public Boolean hasFeaturesBeenConfirmed;
            Measurements_Verified__c = False,// public Boolean hasMeasurementsBeenVerified;
            Visual_Product_Id__c = 'abcde1',//public String id; // Product Code of Product Model
            Inspection_Code__c = 2,//public Integer productInspectCode;
            Product_Length__c = 2.5, //public Double productLength;
            RVN_Number__c = '12345678'); // public String rvn; //ProjectNbr + Structure);
        insert cfgProd1;
        // Create Config Option
        Configuration_Option__c cfgOpt1 = new Configuration_Option__c(
            Name='Test Config Option 1',
            Configuration_Product__c = cfgProd1.Id,
            Quantity__c = 1.23, //public Double Amount;
            Local_Supplier__c = FALSE, //public Boolean LocalSupplier;
            Parameter_code__c = '123456',// public String ParameterCode;
            Sales_Code__c = 'Option 1',// public String SalesCode;
            //unique_id__c = 1,// public Integer UniqueId;
            Unit_Of_Measure__c = 'M');// public String Unit;)
         
        Configuration_Option__c cfgOpt2 = new Configuration_Option__c(
            Name='Test Config Option 2',
            Configuration_Product__c = cfgProd1.Id,
            Quantity__c = 22.23, //public Double Amount;
            Local_Supplier__c = FALSE, //public Boolean LocalSupplier;
            Parameter_code__c = '123456',// public String ParameterCode;
            Sales_Code__c = 'Option 2',// public String SalesCode;
            //unique_id__c = 1,// public Integer UniqueId;
            Unit_Of_Measure__c = 'h');// public String Unit;)
        
        insert new List<Configuration_Option__c>{cfgOpt1,cfgOpt2};
            
        // Create Config Message
        Configuration_Message__c cfgMsg = new Configuration_Message__c(
            Name='Test Config Message',
            Configuration_Product__c = cfgProd1.Id,
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
        imageFileLink.LinkedEntityId = cfg1.id;
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
        '    \"id\": \"ABCDE1\",'+
        '    \"line\": \"123\",'+
        '    \"name\": \"Test Plan 1\",'+
        '    \"version\": 3,'+
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
        pricingFileLink.LinkedEntityId = cfg1.id;
        insert pricingFileLink;
        system.debug ('*** setupConfigurationRecords Image File Link : '+pricingFileLink.id);
    } 
    
    public static void setupWorkOrderRecords() {
        Product2 p1 = new Product2(Name='Test Config Product 1', IsActive=True,ProductCode='COST',Product_Category__c='Product Models');
        Product2 p2 = new Product2(Name='Test Config Product 2', IsActive=True,ProductCode='Option 1',Product_Category__c='Product Options');
        Product2 p3 = new Product2(Name='Test Config Product 3', IsActive=True,ProductCode='Option 2',Product_Category__c='Product Options');
        insert new List<Product2> {p1,p2,p3};
        system.debug ('*** setupWorkOrderRecords product 1: '+p1);
        system.debug ('*** setupWorkOrderRecords product 2: '+p2);
        system.debug ('*** setupWorkOrderRecords product 3: '+p3);
        Id pbid = Test.getStandardPricebookId();
        PricebookEntry pbe1 = new PricebookEntry(Pricebook2Id=pbid, Product2Id=p1.id, UnitPrice=1, IsActive=True,CurrencyIsoCode = 'EUR');
        PricebookEntry pbe2 = new PricebookEntry(Pricebook2Id=pbid, Product2Id=p2.id, UnitPrice=2, IsActive=True,CurrencyIsoCode = 'EUR');
        PricebookEntry pbe3 = new PricebookEntry(Pricebook2Id=pbid, Product2Id=p3.id, UnitPrice=3, IsActive=True,CurrencyIsoCode = 'EUR');     
        insert new List<PricebookEntry> {pbe1,pbe2,pbe3};
        system.debug ('*** setupWorkOrderRecords PricebookEntry 1: '+pbe1);
        system.debug ('*** setupWorkOrderRecords PricebookEntry 2: '+pbe2);
        system.debug ('*** setupWorkOrderRecords PricebookEntry 3: '+pbe3);
        String B2CRecordTypeId= [SELECT Id FROM RecordType WHERE (Name='B2C Account') and (SobjectType='Account')].Id;
        String B2BRecordTypeId= [SELECT Id FROM RecordType WHERE (Name='B2B Account') and (SobjectType='Account')].Id;
        Schema.Location l = new Schema.Location(Name = 'TestL');
        insert l;
        l = [SELECT Id FROM Location Limit 1];
        List<Account> accts = new List<Account>();
        // Create B2C Account
        Account p = new Account(      
            RecordTypeID=B2CRecordTypeId,
            FirstName='My',
            LastName='Person Account',
            PersonEmail='test@workorder.com',
            PersonMailingCountry ='Finland',
            PersonMailingCity='Kaupunki',
            PersonMailingPostalCode = '33333',
            PersonMailingStreet='Katu 3');
        accts.add(p);    
        Account a = new Account(
            RecordTypeID=B2BRecordTypeId,
            Name='Business Account',
            BillingCountry ='Finland',
            BillingCity='Kaupunki',
            BillingPostalCode = '33333',
            BillingStreet = 'Katu 33');
        accts.add(a);
        insert accts;        
        system.debug ('*** setupWorkOrderRecords Person Account: '+p.id);
        system.debug ('*** setupWorkOrderRecords Account: '+a.id);
        Opportunity o1 = new Opportunity(
            Name='B2C Opportunity', 
            StageName='Quoting', 
            CloseDate=system.Today()+10,
            Pricebook2Id=pbid,
            AccountId = p.Id,
            Customer_Segment__c = '1000',
            //Delivery_Location__c = l.Id, 
            Delivery_date__c = System.today().addDays(5),
            Property_Type__c = 'ROW'
            //Installation_Address__City__s = 'Espoo',
            //Installation_Address__Street__s = 'Test Espoo Street',
            //Installation_Address__PostalCode__s = '00100'
            );
        Opportunity o2 = new Opportunity(
            Name='B2B Opportunity', 
            StageName='Quoting', 
            CloseDate=system.Today()+30,
            Pricebook2Id=pbid,
            AccountId = a.Id
            //Installation_Address__City__s = 'Helsinki',
            //Installation_Address__Street__s = 'Test Helsinki Street',
            //Installation_Address__PostalCode__s = '00200'
            );
        insert new List<Opportunity> {o1,o2};
        // Create Parent Config
        Configuration__c cfg1 = new Configuration__c(
            Opportunity__c = o1.Id,
            Name='Test Config 1',
            Plan_Apartment__c = 'A1',// public String apartment; // Door Nbr in Apartment
            Plan_Floor__c = 1,// public Integer floor; // Floor Nbr in Building
            Visual_Id__c = 'ABCDE1',//public String id; // Unique Visual Configuration Id
            Plan_Line__c = '100',// public String line; //?
            Plan_Name__c = 'NAME',// public String name; // Name of the Configuration
            //public List<Products> products; // Product Model aka Configurable Product
            Visual_Version__c = 1);//public Integer version; // Configuration Version);
        
        Configuration__c cfg2 = new Configuration__c(
            Opportunity__c = o2.Id,
            Name='Test Config 2',
            Plan_Apartment__c = 'B2',// public String apartment; // Door Nbr in Apartment
            Plan_Floor__c = 2,// public Integer floor; // Floor Nbr in Building
            Visual_Id__c = 'ABCDE2',//public String id; // Unique Visual Configuration Id
            Plan_Line__c = '200',// public String line; //?
            Plan_Name__c = 'NAME',// public String name; // Name of the Configuration
            //public List<Products> products; // Product Model aka Configurable Product
            Visual_Version__c =2);//public Integer version; // Configuration Version);
        insert new List<Configuration__c> {cfg1,cfg2};
        // Create Config Product
        Configuration_Product__c cfgProd1 = new Configuration_Product__c(
            Name='LG', //public String name; // Name of the Product Model
            Configuration__c = cfg1.Id, // Parent Configuration
            Quantity__c = 1, // Amount must be 1 for each Product in a configuration
            Features_Confirmed__c = False,//public Boolean hasFeaturesBeenConfirmed;
            Measurements_Verified__c = False,// public Boolean hasMeasurementsBeenVerified;
            Visual_Product_Id__c = 'abcde12345',//public String id; // Product Code of Product Model
            Inspection_Code__c = 2,//public Integer productInspectCode;
            Product_Length__c = 2.5, //public Double productLength;
            RVN_Number__c = '12345678'); // public String rvn; //ProjectNbr + Structure);
        insert cfgProd1;
        // Create Config Option
        Configuration_Option__c cfgOpt1 = new Configuration_Option__c(
            Name='Test Config Option 1',
            Configuration_Product__c = cfgProd1.Id,
            Quantity__c = 1.23, //public Double Amount;
            Local_Supplier__c = FALSE, //public Boolean LocalSupplier;
            Parameter_code__c = '123456',// public String ParameterCode;
            Sales_Code__c = 'Option 1',// public String SalesCode;
            //unique_id__c = 1,// public Integer UniqueId;
            Unit_Of_Measure__c = 'M');// public String Unit;)
        
        Configuration_Option__c cfgOpt2 = new Configuration_Option__c(
            Name='Test Config Option 2',
            Configuration_Product__c = cfgProd1.Id,
            Quantity__c = 22.23, //public Double Amount;
            Local_Supplier__c = FALSE, //public Boolean LocalSupplier;
            Parameter_code__c = '123456',// public String ParameterCode;
            Sales_Code__c = 'Option 2',// public String SalesCode;
            //unique_id__c = 1,// public Integer UniqueId;
            Unit_Of_Measure__c = 'h');// public String Unit;)
        
        insert new List<Configuration_Option__c> {cfgOpt1,cfgOpt2};
            
        // Create Config Message
        Configuration_Message__c cfgMsg1 = new Configuration_Message__c(
            Name='Test Config Message',
            Configuration_Product__c = cfgProd1.Id,
            Message_Key__c = 'E11111',
            Space_Side_Number__c = 1);
        
        Configuration_Message__c cfgMsg2 = new Configuration_Message__c(
            Name='Test Config Message',
            Configuration_Product__c = cfgProd1.Id,
            Message_Key__c = 'E22222',
            Space_Side_Number__c = 2);
        
        insert new List<Configuration_Message__c> {cfgMsg1,cfgMsg2};
            
        // Create Content Document Version
        ContentVersion imageFileVersion = new ContentVersion();
        imageFileVersion.Title='Picture'; 
        imageFileVersion.ContentLocation= 's';
        imageFileVersion.PathOnClient = imageFileVersion.Title + '.jpg';
        Blob imageBody=Blob.valueOf('*** setupWorkOrderRecords Picture File'); 
        imageFileVersion.VersionData=imageBody; 
        insert imageFileVersion;
        system.debug ('*** setupWorkOrderRecords Image File Version : '+imageFileVersion.id);
        ContentVersion newFileVersion = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =:imageFileVersion.Id];
        // Create Content Document Version to Configuration
        ContentDocumentLink imageFileLink = new ContentDocumentLink();
        imageFileLink.ContentDocumentId = newFileVersion.ContentDocumentId;
        imageFileLink.ShareType = 'V';
        imageFileLink.LinkedEntityId = cfg1.id;
        insert imageFileLink;
        system.debug ('*** setupWorkOrderRecords Image File Link : '+imageFileLink.id);
        // Create Content Document Version
        ContentVersion pricingFileVersion = new ContentVersion();
        pricingFileVersion.Title='Visual Pricing'; 
        pricingFileVersion.ContentLocation= 's';
        pricingFileVersion.PathOnClient = pricingFileVersion.Title + '.json';
        String ConfigString = '{'+
        '    \"apartment\": \"A1\",'+
        '    \"floor\": \"6\",'+
        '    \"id\": \"ABCDE3\",'+
        '    \"line\": \"123\",'+
        '    \"name\": \"Test Plan 3\",'+
        '    \"version\": 3,'+
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
        system.debug ('*** setupWorkOrderRecords Pricing File Version : '+pricingFileVersion.id);
        ContentVersion newPricingFileVersion = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =:pricingFileVersion.Id];
        // Create Content Document Version to Configuration
        ContentDocumentLink pricingFileLink = new ContentDocumentLink();
        pricingFileLink.ContentDocumentId = newPricingFileVersion.ContentDocumentId;
        pricingFileLink.ShareType = 'V';
        pricingFileLink.LinkedEntityId = cfg1.id;
        insert pricingFileLink;
        system.debug ('*** setupWorkOrderRecords Image File Link : '+pricingFileLink.id);
        
        OperatingHours oh = new OperatingHours(Name = 'Operating Hours Test');
        insert oh;
        system.debug ('*** setupWorkOrderRecords Operating Hours : '+oh.id);
        FSL__Scheduling_Policy__c sp = new FSL__Scheduling_Policy__c(Name = 'Custom Component Reservation');
        insert sp;
        system.debug ('*** setupWorkOrderRecords Scheduling Policy : '+sp.id);
        ServiceTerritory st = new ServiceTerritory(Name = 'testT', 
                                                   Appointment_Booking_Offset__c = 5, 
                                                   OperatingHoursId = oh.Id, IsActive = true);
        insert st;
        system.debug ('*** setupWorkOrderRecords Service Territory : '+st.id);
        st = [SELECT Id, Appointment_Booking_Offset__c FROM ServiceTerritory Limit 1];
        WorkOrder wo = new WorkOrder(Subject = o1.Name, 
                                     Opportunity__c = o1.Id, 
                                     AccountId = o1.AccountId, 
                                     ContactId = a.PersonContactId, 
                                     LocationId = o1.Delivery_Location__c, 
                                     Duration = o1.Installation_duration__c, 
                                     DurationType = 'Hours', 
                                     ServiceTerritoryId = st.Id);
        insert wo;
        system.debug ('*** setupWorkOrderRecords Work Order : '+wo);
        ServiceAppointment sa = new ServiceAppointment(ParentRecordId = wo.Id, 
                                                       EarliestStartTime = system.Today(),//o1.Delivery_date__c, 
                                                       DueDate = system.Today()+5,//o1.Delivery_date__c.addDays(5), 
                                                       Duration = 20);//o1.Installation_duration__c);
        insert sa;
        system.debug ('*** setupWorkOrderRecords Service Appointment : '+wo.id);
    } 
}