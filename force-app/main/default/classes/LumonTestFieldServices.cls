/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 06-19-2024
 * @last modified by  : Henk Reynders
**/
@IsTest
public with sharing class LumonTestFieldServices {
    @TestVisible private static Id adminProfileId{
        get{
            return [SELECT Id FROM Profile WHERE Name='System Administrator']?.Id;
        }
    }
    @TestVisible private static User fslAdmin{
        get{
            return  [SELECT Id, Name, ProfileId, Profile.Name, UserName, UserRoleId,UserRole.Name, Country, Organization__c, Profit_Center__c, District__c, Office__c 
                     FROM User WHERE(username='admin.testuser@email123.com')];
        }
    }
    @TestVisible private static User installer{
        get{
            return  [SELECT Id, Name, FirstName, LastName, ProfileId, Profile.Name, UserName, UserRoleId,UserRole.Name, Country, Organization__c, Profit_Center__c, District__c, Office__c 
                     FROM User WHERE(username='installer.testuser@email123.com')];
        }
    }
    @TestVisible private static User installationManager{
        get{
            return  [SELECT Id, Name, ProfileId, Profile.Name, UserName, UserRoleId,UserRole.Name, Country, Organization__c, Profit_Center__c, District__c, Office__c 
                     FROM User WHERE(username='installmgr.testuser@email123.com')];
        }
    }
    @TestVisible private static Id fslContactId{
        get{
            return [SELECT Id FROM Contact WHERE (IsPersonAccount = true)]?.Id;
        }
    }
    @TestVisible private static Id fslAccountId{
        get{
            return [SELECT Id FROM Account WHERE (IsPersonAccount = true)]?.Id;
        }
    }
    @TestVisible private static Account fslAccount{
        get{
            return [SELECT Id FROM Account WHERE Id =:fslAccountId];
        }
    }
    @TestVisible private static Id fslOpportunityId{
        get{
            return [SELECT Id,Pricebook2Id,SyncedQuoteId,AccountId FROM Opportunity WHERE (Account.IsPersonAccount = true AND Order_Type__c = 'Normal') LIMIT 1]?.Id;
        }
    }
    @TestVisible private static Opportunity fslOpportunity{
        get{
            return [SELECT Id FROM Opportunity WHERE Id =:fslOpportunityId LIMIT 1];
        }
    }
    @TestVisible private static Id reclamationId{
        get{
            return [SELECT Id,Pricebook2Id,SyncedQuoteId,AccountId FROM Opportunity WHERE (Account.IsPersonAccount = true AND Order_Type__c = 'Reclamation') LIMIT 1]?.Id;
        }
    }
    @TestVisible private static Opportunity reclamation{
        get{
            return [SELECT Id,Pricebook2Id,SyncedQuoteId,AccountId FROM Opportunity WHERE Id =:reclamationId LIMIT 1];
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
    /***************** Field Services ********************/
    public static void setupFieldServices(){
        // Create FSL Admin 
        LumonTestUsers.setupAdminUser();
        System.debug('--- Admin User: '+fslAdmin);
        // Add FSL Admin Permissions 
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
            LumonTestUsers.setupInstallerUser();
        	System.debug('--- Installer User: '+installer);
            setupWorkType();
            Id serviceTerritoryId = setupServiceTerritory();        
            Id serviceResourceId = setupServiceResource(installer);
            Id installerResourceId = setupServiceTerritoryMember(serviceTerritoryId, serviceResourceId);
            Id locationId = setupLocation();
            Id accountId = setupAccount();
            Id opportunityId = setupOpportunity(accountId, locationId);
            Id workOrderId = setupWorkOrder(accountId, opportunityId, locationId, serviceTerritoryId);
            Id appointmentId = setupAppointment(serviceTerritoryId,workOrderId);
            Id configurationId = setupConfiguration(opportunityId);
            Id configurationProductId = setupConfigurationProduct(configurationId);
            Id installationFileLinkId = setupInstallationFile(configurationId);
        }
        
    } 
    public static Id setupServiceTerritory(){
        // Scheduling Policy - this can be extended with additional Work Rules and Objectives
        FSL__Scheduling_Policy__c schedulingPolicy = new FSL__Scheduling_Policy__c();
        schedulingPolicy.Name = 'Test FSL Scheduling Policy';
        insert schedulingPolicy;
        System.debug('--- Policy: '+schedulingPolicy);
        // Operating Hours for availability
        OperatingHours operatingHours1 = new OperatingHours();
        operatingHours1.Name = 'Test FSL Availability Calendar';
        operatingHours1.TimeZone = UserInfo.getTimeZone().getID();
        insert operatingHours1;    
        System.debug('--- Operating Hours: '+operatingHours1);    
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
        System.debug('--- Time Slots: '+[SELECT Id,Type,DayOfWeek,StartTime,EndTime FROM TimeSlot]);
        
        
        // Add Service Territory
        System.debug('--- Service Territories Before: '+[SELECT Id,Name FROM ServiceTerritory]); 
        ServiceTerritory serviceTerritory = new ServiceTerritory(
            Name = 'FSL Service Territory 1',
            Appointment_Booking_Offset__c = 5,
            OperatingHoursId = operatingHours1.Id,
            IsActive = true);
        insert serviceTerritory;
        System.debug('--- Service Territories After: '+[SELECT Id,Name FROM ServiceTerritory]); 
        System.debug('--- Service Territory: '+serviceTerritory); 
        return serviceTerritory.Id;
    }
    public static Id setupServiceResource(User installer){   
        // Create user for a field technician resource with the right permission sets
        // Lookup the user that was created in the runAs context
        // Create Service Resource for Installer
        ServiceResource serviceResource = new ServiceResource(
            Name = installer.FirstName + ' ' + installer.LastName,
            isActive = true,
            IsOptimizationCapable = true, // This is important otherwise the resource is not available for scheduling
            ResourceType = 'T',
            RelatedRecordId = installer.Id
        );
        insert serviceResource;
        System.debug('--- Service Resource: '+serviceResource); 
        return serviceResource.Id;
    }
    public static Id setupServiceTerritoryMember(Id serviceTerritoryId, Id serviceResourceId){ 
        // Add resource part of the service territory
        insert new ServiceTerritoryMember(
            ServiceTerritoryId = serviceTerritoryId,
            ServiceResourceId = serviceResourceId,
            TerritoryType = 'P',
            EffectiveStartDate = System.now().addDays(-3)
        );
        System.debug('--- Service Territory Member: '+[SELECT Id FROM ServiceTerritoryMember LIMIT 1]); 
        return [SELECT Id FROM ServiceTerritoryMember LIMIT 1]?.Id;
    }
    public static void setupWorkType(){ 
        // Create Work Type record 
        insert new WorkType(
            Name = 'Maintenance',
            ShouldAutoCreateSvcAppt = true,
            FSL__Due_Date_Offset__c = 60*24*7, // 1 week in minutes
            DurationType = 'Minutes',
            EstimatedDuration = 60
        );
    
     // Add Operating Hours for Time Slots
        OperatingHours operatingHours2 = new OperatingHours();
        operatingHours2.Name = 'Test Time Slots Calendar';
        operatingHours2.TimeZone = UserInfo.getTimeZone().getID();
        insert operatingHours2;   
        System.debug('--- Operating Hours: '+operatingHours2);  
        // Create Time Slots 
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
        System.debug('--- Time Slots: '+[SELECT Id,Type,DayOfWeek,StartTime,EndTime FROM TimeSlot]);
      // Update Opportunity
    //Opportunity fslOpportunity = [SELECT Id, Name, AccountId, Delivery_Location__c, Delivery_date__c, Installation_duration__c  FROM Opportunity WHERE Id =: b2cOpportunityId];
    /*fslOpportunity.Delivery_date__c;
    fslOpportunity.Delivery_Location__c;
    fslOpportunity.Installation_duration__c;
    fslOpportunity.Installation_Location__c;*/      
    }    
	public static Id setupLocation(){
        // Add Installation Location
        Schema.Location installationLocation = new Schema.Location();
        installationLocation.Name = 'Test Installation Location';
        insert installationLocation;
        System.debug('--- Installation Location: '+installationLocation);
        return installationLocation.Id;
    }
	public static Id setupAccount(){
        // Create B2C Account
        Id b2cRecordTypeId = [SELECT Id FROM RecordType WHERE (IsPersonType = TRUE) AND (SobjectType='Account')]?.Id;
        Account fslAccount = new Account(RecordTypeID=b2cRecordTypeId,
                    FirstName='My',
                    LastName='FSL Person Account',
                    PersonEmail='test123@lumonCustomer.fsl',
                    PersonMailingCountry ='Finland',
                    PersonMailingCity='Vantaa',
                    PersonMailingPostalCode = '01740',
                    PersonMailingStreet='Vanha Kalliosolantie 8',
                    District__c = 'FI_North',
                    District_Type__c = 'P4');
        insert fslAccount;
        System.debug('--- FSL AccountId: '+fslAccount.Id);
        System.debug('--- FSL Account: '+fslAccount);
        return fslAccountId;
    }
    public static Id setupOpportunity(Id fslAccountId, Id installationLocationId){
        // Create B2C Opportunity
        Opportunity fslOpportunity = new Opportunity(Name='FSL Opportunity',
                                            StageName='Quoting',
                                            CloseDate=system.Today()+10,
                                            Pricebook2Id=Test.getStandardPricebookId(),
                                            AccountId = fslAccountId,
                                            Organization__c = 'LSU',
                                            //Country_Attribute__c,
                                            Business_Type__c ='Consumer',
                                            District__c = 'FI_North',
                                            Order_Type__c = 'Normal'
                                            );
        insert fslOpportunity;
        System.debug('--- FSL Opportunity: '+fslOpportunity);
        // Create FSL Opportunity
        fslOpportunity.Customer_Segment__c = '1000';
		fslOpportunity.StageName='Quoting';
        fslOpportunity.CloseDate = System.today().addDays(30); 
		fslOpportunity.Delivery_Location__c = installationLocationId;
		fslOpportunity.Delivery_date__c = System.today().addDays(5);
        update fslOpportunity;
        System.debug('--- FSL Opportunity: '+fslOpportunity);
        return fslOpportunity.Id;
    }
    public static Id setupWorkOrder(Id accountId, Id opportunityId, Id locationId, Id serviceTerritoryId){
        // Create WorkOrder
        WorkOrder workOrder = new WorkOrder();
        workOrder.AccountId = accountId;
        workOrder.Subject = 'Test Work Order';
        workOrder.Opportunity__c = opportunityId;
        //workOrder.ContactId; 
        workOrder.LocationId = locationId;
        workOrder.Duration = 2;
        workOrder.DurationType = 'Hours';
        workOrder.ServiceTerritoryId = serviceTerritoryId;
        insert workOrder;
        System.debug('--- FSL Work Order: '+workOrder);
        return workOrder.Id;
    }
    public static Id setupAppointment (Id serviceTerritoryId, Id workOrderId){    
        // Create Appointment
        ServiceAppointment serviceAppointment = new ServiceAppointment();
        //serviceAppointment.Status; // For Softbooking status is None
        serviceAppointment.EarliestStartTime = Date.today();
        serviceAppointment.DueDate = Date.today().addDays(10);
        serviceAppointment.ServiceTerritoryId = serviceTerritoryId;
        serviceAppointment.ParentRecordId = workOrderId;
        serviceAppointment.Duration = 2;
        insert serviceAppointment;
        System.debug('--- FSL Service Appointment: '+serviceAppointment);
        return serviceAppointment.Id;
    }
    public static Id setupConfiguration(Id opportunityId) {
        // Create Configuration Plan
        Configuration__c configPlan = new Configuration__c(
                                            Opportunity__c = opportunityId,
                                            Name='FSL Configuration',
                                            Plan_Apartment__c = 'C1',// public String apartment; // Door Nbr in Apartment
                                            Plan_Floor__c = '6',// public Integer floor; // Floor Nbr in Building
                                            Visual_Id__c = 'FSL-ABCDE1',//public String Id; // Unique Visual Configuration Id
                                            Plan_Line__c = '100',// public String line; //?
                                            Plan_Name__c = 'FSL Plan 1',// public String name; // Name of the Configuration
                                            //public List<Products> products; // Product Model aka Configurable Product
                                            Visual_Version__c = 1);//public Integer version; // Configuration Version);
		insert configPlan;
        System.debug('--- FSL Configuration Plan: '+configPlan);
        return configPlan.Id;
    } 
    public static Id setupConfigurationProduct(Id configurationId) {   
        // Create Configuration Product
        List<Configuration_Product__c> configProducts = new List<Configuration_Product__c>();
        List<Product2> prodList = new List<Product2>();
        Product2 p1 = new Product2(Name='Test Product 1 Installation', IsActive=True,ProductCode='LG',Product_Group__c='LG',Product_Category__c='Product Groups',Installation__c = true,Configurator__c = 'Visual');
		insert p1;
        System.debug('--- FSL Product: '+p1);
        Configuration_Product__c configProduct = new Configuration_Product__c(
                                            Name='FSL Config Product', //public String name; // Name of the Product Model
                                            Configuration__c = configurationId, // Parent Configuration
                                            Quantity__c = 1, // Amount must be 1 for each Product in a configuration
                                            Product_Group__c = 'LG',
                    						Product__c = p1.Id,
                    						Features_Confirmed__c = False,//public Boolean hasFeaturesBeenConfirmed;
                                            Measurements_Verified__c = False,// public Boolean hasMeasurementsBeenVerified;
                                            Visual_Product_Id__c = 'VisualId',//public String Id; // Product Code of Product Model
                                            Inspection_Code__c = 2,//public Integer productInspectCode;
                                            Product_Length__c = 2.5, //public Double productLength;
                                            RVN_Number__c = '1234567890'); // public String rvn; //ProjectNbr + Structure);
		insert configProduct;
        System.debug('--- FSL Config Product: '+configProduct);
		return configProduct.Id;
    }
    public static Id setupInstallationFile(Id configurationId) {  
        // Create visual_installation Document Version
        ContentVersion visualInstallation = new ContentVersion();
        visualInstallation.Title = 'visual_installation_'+configurationId;
        visualInstallation.ContentLocation = 's';
        visualInstallation.PathOnClient = visualInstallation.Title + '.pdf';
        visualInstallation.VersionData = Blob.valueOf('testing');
        insert visualInstallation;

        ContentDocumentLink visualInstallationFileLink = new ContentDocumentLink();
        visualInstallationFileLink.ContentDocumentId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id = :visualInstallation.Id LIMIT 1].ContentDocumentId;
        visualInstallationFileLink.ShareType = 'V';
        visualInstallationFileLink.LinkedEntityId = configurationId;
        insert visualInstallationFileLink;
        System.debug('--- Installation Content Document Link: '+visualInstallationFileLink);
        return visualInstallationFileLink.Id;  
    }
}