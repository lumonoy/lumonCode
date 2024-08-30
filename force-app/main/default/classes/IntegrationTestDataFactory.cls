@isTest
public class IntegrationTestDataFactory {

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
        insert ol1;
        insert ol2;
        system.debug ('*** setupContractRecords opportunity Product 1: '+ol1);
        system.debug ('*** setupContractRecords opportunity Product 2: '+ol2);
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
    
}