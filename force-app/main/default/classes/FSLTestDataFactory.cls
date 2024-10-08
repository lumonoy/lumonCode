/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 06-19-2024
 * @last modified by  : Henk Reynders
**/
@isTest
public with sharing class FSLTestDataFactory { 
    /** Determine if person account is enabled in current org **/
    @TestVisible
    private static Boolean isPersonAccountEnabled{
        get{
            return Schema.SObjectType.Account.fields.getMap().containsKey( 'isPersonAccount' );
        }
    }
    private static final Date Today = system.today();
     
    public static void setupAccountRecords(){
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
            insert p;   
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
            insert a;     
        system.debug ('*** accountRecordsSetup Account: '+a.id);
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
        insert o1;
        System.debug('*** location ***'+o1.Delivery_Location__c);
        System.debug('*** o1 city ***'+o1.Installation_Address__City__s);
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
        insert o2;
        system.debug ('*** setupWorkOrderRecords B2C Opportunity: '+o1.id);
        system.debug ('*** setupWorkOrderRecords B2B Opportunity: '+o2.id);
        // Create Parent Config
        Configuration__c cfg1 = new Configuration__c(
            Opportunity__c = o1.Id,
            Name='Test Config 1',
            Plan_Apartment__c = 'A1',// public String apartment; // Door Nbr in Apartment
            Plan_Floor__c = '1',// public Integer floor; // Floor Nbr in Building
            Visual_Id__c = 'ABCDE1',//public String id; // Unique Visual Configuration Id
            Plan_Line__c = '100',// public String line; //?
            Plan_Name__c = 'NAME',// public String name; // Name of the Configuration
            //public List<Products> products; // Product Model aka Configurable Product
            Visual_Version__c = 1);//public Integer version; // Configuration Version);
        insert cfg1;
        Configuration__c cfg2 = new Configuration__c(
            Opportunity__c = o2.Id,
            Name='Test Config 2',
            Plan_Apartment__c = 'B2',// public String apartment; // Door Nbr in Apartment
            Plan_Floor__c = '2',// public Integer floor; // Floor Nbr in Building
            Visual_Id__c = 'ABCDE2',//public String id; // Unique Visual Configuration Id
            Plan_Line__c = '200',// public String line; //?
            Plan_Name__c = 'NAME',// public String name; // Name of the Configuration
            //public List<Products> products; // Product Model aka Configurable Product
            Visual_Version__c =2);//public Integer version; // Configuration Version);
        insert cfg2;
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
        insert cfgOpt1; 
        Configuration_Option__c cfgOpt2 = new Configuration_Option__c(
            Name='Test Config Option 2',
            Configuration_Product__c = cfgProd1.Id,
            Quantity__c = 22.23, //public Double Amount;
            Local_Supplier__c = FALSE, //public Boolean LocalSupplier;
            Parameter_code__c = '123456',// public String ParameterCode;
            Sales_Code__c = 'Option 2',// public String SalesCode;
            //unique_id__c = 1,// public Integer UniqueId;
            Unit_Of_Measure__c = 'h');// public String Unit;)
        insert cfgOpt2;       
        // Create Config Message
        Configuration_Message__c cfgMsg1 = new Configuration_Message__c(
            Name='Test Config Message',
            Configuration_Product__c = cfgProd1.Id,
            Message_Key__c = 'E11111',
            Space_Side_Number__c = 1);
        insert cfgMsg1;  
        Configuration_Message__c cfgMsg2 = new Configuration_Message__c(
            Name='Test Config Message',
            Configuration_Product__c = cfgProd1.Id,
            Message_Key__c = 'E22222',
            Space_Side_Number__c = 2);
        insert cfgMsg2; 
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