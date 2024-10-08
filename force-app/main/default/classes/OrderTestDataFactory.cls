/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 06-19-2024
 * @last modified by  : Henk Reynders
**/
@isTest
public with sharing class OrderTestDataFactory {
    @TestVisible
    private static Boolean isPersonAccountEnabled{
        get{
            return Schema.SObjectType.Account.fields.getMap().containsKey( 'isPersonAccount' );
        }
    }
    private static final Date Today = system.today(); 
    @future
    public static void setupOrderRecords() {
        Product2 p1 = new Product2(Name='Test Order Product 1', IsActive=True,ProductCode='COST',Product_Category__c='Product Models');
        Product2 p2 = new Product2(Name='Test Order Product 2', IsActive=True,ProductCode='Option 1',Product_Category__c='Product Options');
        Product2 p3 = new Product2(Name='Test Order Product 3', IsActive=True,ProductCode='Option 2',Product_Category__c='Product Options');
        insert new List<Product2> {p1,p2};
        system.debug ('*** setupOrderRecords product 1: '+p1);
        system.debug ('*** setupOrderRecords product 2: '+p2);
        system.debug ('*** setupOrderRecords product 2: '+p3);
        Id pbid = Test.getStandardPricebookId();
        PricebookEntry pbe1 = new PricebookEntry(Pricebook2Id=pbid, Product2Id=p1.id, UnitPrice=1, IsActive=True,CurrencyIsoCode = 'EUR');
        PricebookEntry pbe2 = new PricebookEntry(Pricebook2Id=pbid, Product2Id=p2.id, UnitPrice=2, IsActive=True,CurrencyIsoCode = 'EUR');
        PricebookEntry pbe3 = new PricebookEntry(Pricebook2Id=pbid, Product2Id=p3.id, UnitPrice=3, IsActive=True,CurrencyIsoCode = 'EUR');
        
        insert new List<PricebookEntry> {pbe1,pbe2};
        system.debug ('*** setupOrderRecords PricebookEntry 1: '+pbe1);
        system.debug ('*** setupOrderRecords PricebookEntry 2: '+pbe2);
        system.debug ('*** setupOrderRecords PricebookEntry 3: '+pbe3);
        String B2CRecordTypeId= [SELECT Id FROM RecordType WHERE (Name='B2C Account') and (SobjectType='Account')].Id;
        String B2BRecordTypeId= [SELECT Id FROM RecordType WHERE (Name='B2B Account') and (SobjectType='Account')].Id;
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
        Account a = new Account(
            RecordTypeID=B2BRecordTypeId,
            Name='Account Test Order',
            BillingCountry ='Finland',
            BillingCity='City',
            BillingPostalCode = '44444',
            BillingStreet = 'Street 2');
        accts.add(a);
        insert accts;        
        system.debug ('*** setupOrderRecords Person Account: '+p.id);
        system.debug ('*** setupOrderRecords Account: '+a.id);
        // Prepare Offer
        Opportunity o1 = new Opportunity(
            Name='B2C Opportunity 1', 
            StageName='Quoting', 
            CloseDate=system.Today()+10,
            Delivery_Date__c=System.Today()+90,
            Terrain_Type__c = 'Terrain Class I', // Not sure where needed
            Confirmed_installation_time__c = system.today()+90,
            Property_Type__c = 'ROW',
            Pricebook2Id=pbid,
            AccountId = p.Id
            );
        insert o1;
        Opportunity o2 = new Opportunity(
            Name='B2C Opportunity 2', 
            StageName='Quoting', 
            CloseDate=system.Today()+10,
            Delivery_Date__c=System.Today()+90,
            Terrain_Type__c = 'Terrain Class II', // Not sure where needed
            Confirmed_installation_time__c = system.today()+90,
            Property_Type__c = 'ROW',
            Pricebook2Id=pbid,
            AccountId = p.Id
            );
        insert o2;
        // Offer Send Pending Customer
        system.debug ('*** setupOrderRecords B2C Opportunity 1: '+o1.id);
        Contract c1 = new Contract(
            Name = 'B2C Draft Contract 1',
            AccountId = p.Id, 
            Status = 'Draft', 
            Contract_type__c = 'Final Contract',
            StartDate = Date.today(),
            Opportunity__c = o1.Id
            );
        insert c1;
        Contract c2 = new Contract(
            Name = 'B2C Draft Contract 2',
            AccountId = p.Id, 
            Status = 'Draft', 
            Contract_type__c = 'Final Contract',
            StartDate = Date.today(),
            Opportunity__c = o2.Id
            );
        insert c2;
        // Create Parent Config B2C
        Configuration__c cfg1 = new Configuration__c(
            Opportunity__c = o1.Id,
            Name='Test Order Config 1',
            Plan_Apartment__c = 'A1',// public String apartment; // Door Nbr in Apartment
            Plan_Floor__c = '6',// public Integer floor; // Floor Nbr in Building
            Visual_Id__c = 'ABCDE1',//public String id; // Unique Visual Configuration Id
            Plan_Line__c = '100',// public String line; //?
            Plan_Name__c = 'plan 1',// public String name; // Name of the Configuration
            //public List<Products> products; // Product Model aka Configurable Product
            Visual_Version__c = 1);//public Integer version; // Configuration Version);
        insert cfg1;
            // Create Parent Config B2C
            Configuration__c cfg2 = new Configuration__c(
                Opportunity__c = o2.Id,
                Name='Test Order Config 2',
                Plan_Apartment__c = 'A2',// public String apartment; // Door Nbr in Apartment
                Plan_Floor__c = '6',// public Integer floor; // Floor Nbr in Building
                Visual_Id__c = 'ABCDE2',//public String id; // Unique Visual Configuration Id
                Plan_Line__c = '100',// public String line; //?
                Plan_Name__c = 'plan 2',// public String name; // Name of the Configuration
                //public List<Products> products; // Product Model aka Configurable Product
                Visual_Version__c = 2);//public Integer version; // Configuration Version);
            insert cfg2;
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

        // Prepare FSL Appointment
        OperatingHours oh = new OperatingHours(Name = 'testOH');
		insert oh;

		FSL__Scheduling_Policy__c sp = new FSL__Scheduling_Policy__c(Name = 'Custom Component Reservation');
		insert sp;

		ServiceTerritory st = new ServiceTerritory(Name = 'testT', Appointment_Booking_Offset__c = 5, OperatingHoursId = oh.Id, IsActive = true);
		insert st;
		st = [SELECT Id, Appointment_Booking_Offset__c FROM ServiceTerritory Limit 1];

		WorkOrder wo = new WorkOrder(Subject = o1.Name, Opportunity__c = o1.Id, AccountId = o1.AccountId, ContactId = p.PersonContactId, LocationId = o1.Delivery_Location__c, Duration = o1.Installation_duration__c, DurationType = 'Hours', ServiceTerritoryId = st.Id);
        insert wo;

		ServiceAppointment sa = new ServiceAppointment(ParentRecordId = wo.Id, EarliestStartTime = o1.Delivery_date__c, DueDate = o1.Delivery_date__c.addDays(5), Duration = o1.Installation_duration__c);
        insert sa;
        
        
    }
}