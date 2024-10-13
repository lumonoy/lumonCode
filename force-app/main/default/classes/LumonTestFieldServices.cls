/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 09-30-2024
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
                     FROM User WHERE(alias='admin')];
        }
    }
    @TestVisible private static List<User> installers{
        get{
            return  [SELECT Id, Name, FirstName, LastName, ProfileId, Profile.Name, UserName, UserRoleId,UserRole.Name, Country, Organization__c, Profit_Center__c, District__c, Office__c 
                     FROM User WHERE(Profile.Name = 'Lumon Installer')];
        }
    }
    @TestVisible private static List<User> installationManagers{
        get{
            return  [SELECT Id, Name, ProfileId, Profile.Name, UserName, UserRoleId,UserRole.Name, Country, Organization__c, Profit_Center__c, District__c, Office__c 
                     FROM User WHERE(Profile.Name = 'Lumon Installation Manager')];
        }
    }
    @TestVisible private static List<Contact> fslContacts{
        get{
            return [SELECT Id, AccountId FROM Contact ];
        }
    }
    @TestVisible private static List<Account> fslAccounts{
        get{
            return [SELECT Id, Name,  RecordType.DeveloperName,IsPersonAccount FROM Account];
        }
    }
    @TestVisible private static List<Opportunity> fslOpportunities{
        get{
            return [SELECT Id,RecordType.DeveloperName FROM Opportunity];
        }
    }
    @TestVisible private static List<ServiceTerritory> fslTerritories{
        get{
            return [SELECT Id,Name,OperatingHoursId,IsActive FROM ServiceTerritory];
        }
    }   
    @TestVisible private static List<ServiceTerritoryMember> fslTerritoryMembers{
        get{
            return [SELECT Id,ServiceResourceId,serviceTerritoryId, operatingHoursId FROM ServiceTerritoryMember];
        }
    } 
    @TestVisible private static List<FSL__Scheduling_Policy__c> fslPolicies{
        get{
            return  [SELECT Id,Name FROM FSL__Scheduling_Policy__c];
        }
    }
    @TestVisible private static List<ServiceResource> fslResources{
        get{
            return [SELECT Id,Name,IsActive FROM ServiceResource];
        }
    }   
    @TestVisible private static List<AssignedResource> fslAssignedResources{
        get{
            return [SELECT Id FROM AssignedResource];
        }
    }   
    @TestVisible private static List<WorkOrder> fslWorkOrders{
        get{
            return  [SELECT Id,Subject, WorkOrderNumber,AccountId,ContactId,CaseId,EntitlementId,ServiceContractId,AssetId,RootWorkOrderId,WorkTypeId,ServiceTerritoryId,StatusCategory,Opportunity__c FROM WorkOrder];
        }
    }
    @TestVisible private static List<WorkOrderLineItem> fslWorkOrderLineItems{
        get{
            return  [SELECT Id,Subject, WorkOrderId,AssetId,WorkTypeId,ServiceTerritoryId FROM WorkOrderLineItem];
        }
    }
    @TestVisible private static List<ServiceAppointment> fslAppointments{
        get{
            return [SELECT Id,Status,EarliestStartTime,DueDate ,ServiceTerritoryId,ParentRecordId FROM ServiceAppointment];
        }
    }
    /***************** Field Services ********************/
    public static void setupFieldServices(){
        // Create FSL Admin 
        LumonTestAdmin.setupAdmin();
        System.debug('--- Admin User: '+fslAdmin);
        // Add FSL Admin Permissions 
        System.runAs(fslAdmin){
            PermissionSet fslAdminPermissions =[SELECT Id FROM PermissionSet WHERE Name = 'FSL_Admin_Permissions'];
            try {
                insert new PermissionSetAssignment(
                    PermissionSetId = fslAdminPermissions.Id,
                    AssigneeId = fslAdmin.Id
                );
            } catch (Exception e){
                System.debug('--- FSL Admin Permissions already assigned');
            }
            //LumonTestUsers.setupInstallerUser();
        	//System.debug('--- Installer User: '+installer);
            //setupWorkTypes();
            //Id serviceTerritoryId = setupServiceTerritory();        
            //Id serviceResourceId = setupServiceResource(installer);
            //Id installerResourceId = setupServiceTerritoryMember(serviceTerritoryId, serviceResourceId);
            //Id locationId = setupLocation();
            //Id accountId = setupAccount();
            //Id opportunityId = setupOpportunity(accountId, locationId);
            //Id workOrderId = setupWorkOrder(accountId, opportunityId, locationId, serviceTerritoryId);
            //Id appointmentId = setupAppointment(serviceTerritoryId,workOrderId);
            //Id configurationId = setupConfiguration(opportunityId);
            //Id configurationProductId = setupConfigurationProduct(configurationId);
            //Id installationFileLinkId = setupInstallationFile(configurationId);
        }
        
    } 
    public static Id setupServiceTerritories(){
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
    public static List<ServiceResource> setupServiceResources(List<User> installers){   
        // Create user for a field technician resource with the right permission sets
        // Lookup the user that was created in the runAs context
        // Create Service Resource for Installer
        List<ServiceResource> serviceResources = new List<ServiceResource>();
        for (User fslnstaller : installers){ 
            ServiceResource serviceResource = new ServiceResource(
                Name = fslnstaller.Name + ' Installer',
                isActive = true,
                IsOptimizationCapable = true, // This is important otherwise the resource is not available for scheduling
                ResourceType = 'T', // Indicates this is a Technician
                RelatedRecordId = fslnstaller.Id
            );
            System.debug('--- Service Resource: '+serviceResource); 
            serviceResources.add(serviceResource);
        }
        if (serviceResources.size()>0) {
            insert serviceResources;           
        }
        System.debug('--- Created '+serviceResources.size()+ ' Service Resources');
        return serviceResources;
    }
    public static List<ServiceTerritoryMember> setupServiceTerritoryMembers(Id serviceTerritoryId, List<ServiceResource> resources, String territoryType){ 
        // Add resource part of the service territory
        List<ServiceTerritoryMember> territoryMembers = new List<ServiceTerritoryMember>();
        for (ServiceResource resource : resources){ 
            ServiceTerritoryMember territoryMember =  new ServiceTerritoryMember(
                                ServiceTerritoryId = serviceTerritoryId,
                                ServiceResourceId = resource.Id,
                                TerritoryType = territoryType,    
                                EffectiveStartDate = System.now().addDays(-3)
                                );
            System.debug('--- Territory Member: '+territoryMember); 
            territoryMembers.add(territoryMember);
        }
        if (territoryMembers.size()>0) {
            insert territoryMembers;           
        }
        System.debug('--- Created '+territoryMembers.size()+ ' TerritoryMembers');
        return territoryMembers;
    }
    public static List<WorkTypeGroup> setupWorkTypeGroups(List<String> workTypeGroupValues){ 
        // Create Work Type Group record 
        List<WorkTypeGroup> workTypeGroups = new List<WorkTypeGroup>();
        for (String workTypeGroupValue : workTypeGroupValues) {
            WorkTypeGroup workTypeGroup = new WorkTypeGroup(
                                            Name = workTypeGroupValue,
                                            IsActive = true
                                            );
            workTypeGroups.add(workTypeGroup);
        }
        if (workTypeGroups.size()>0) {
            insert workTypeGroups;           
        }
        System.debug('--- Created '+workTypeGroups.size()+ ' Work Type Groups');
        return workTypeGroups;
    }
    public static List<WorkType> setupWorkTypes(List<String> workTypeValues, Id WorkTypeGroupId, Id category, Boolean autoCreate ){ 
        // Create Work Type record 
        List<WorkType> workTypes = new List<WorkType>();
        for (String workTypeValue : workTypeValues) {
            WorkType workType = new WorkType(
                                            Name = workTypeValue,
                                            //AppointmentCategoryId = category,
                                            ShouldAutoCreateSvcAppt = autoCreate,// If true appointment is created automatically
                                            FSL__Due_Date_Offset__c = 60*24*7, // 1 week in minutes
                                            DurationType = 'Minutes',
                                            EstimatedDuration = 15
                                            );
            workTypes.add(workType);
        }
        if (workTypes.size()>0) {
            insert workTypes;           
        }
        System.debug('--- Created '+workTypes.size()+ ' Work Types');
        return workTypes;
    }
    public static List<OperatingHours> setupOperatingHours(){ 
        // Add Operating Hours for Time Slots
        List<OperatingHours> operatingHours = new List<OperatingHours>();
        // Slots 1,2,4
        insert new OperatingHours(  
                                    Name = '2h Time Slots Calendar',
                                    TimeZone = UserInfo.getTimeZone().getID());
        insert new OperatingHours(  
                                    Name = '4h Time Slots Calendar',
                                    TimeZone = UserInfo.getTimeZone().getID());  
        insert new OperatingHours(  
                                    Name = 'Whole Day Time Slots Calendar',
                                    TimeZone = UserInfo.getTimeZone().getID());
        operatingHours =[SELECT Id, Name,Timezone FROM OperatingHours];  
        System.debug('--- Operating Hours: '+operatingHours);  
        return operatingHours;
    }
    public static List<TimeSlot> setupTimeSlots(Id operatingHoursId, List<String> weekDays, Integer slots){ 
        // Create Time Slots 
        List<TimeSlot> timeSlots = new List<TimeSlot>();
        for (String weekDay : weekDays) {
            Time dayStart = Time.newInstance(07, 30, 00, 0);
            Time dayEnd = Time.newInstance(16, 00, 00, 0);
            Time slotStart = dayStart;
            Time slotEnd = dayEnd;
            for (Integer i = 0; i<slots; i++ ) {
                slotStart = slotStart+ i*(2*1000*60*60);
                slotEnd = slotStart+ ((8/slots)*1000*60*60);// 8 hr days divided by # slots in ms
                TimeSlot timeSlot = new TimeSlot();
                timeSlot.OperatingHoursId = operatingHoursId;
                timeSlot.Type = 'Normal';
                timeSlot.StartTime = slotStart;
                timeSlot.EndTime = slotEnd;
                timeSlot.DayOfWeek = weekDay;    
                timeSlots.add(timeSlot);
            }
        }
        if (timeSlots.size()>0) {
            insert timeSlots;
        }
        System.debug('--- Created '+timeSlots.size()+ ' Time Slots');
        return timeSlots;   
    }    
    public static List<Holiday> setupHolidays(){
        List<List<Object>> holidayDays = LumonTestData.holidayDays;
        //Select Id, Name, Description, IsAllDay, ActivityDate, StartTimeInMinutes, EndTimeInMinutes, 
        //IsRecurrence, RecurrenceStartDate, RecurrenceEndDateOnly, RecurrenceType, RecurrenceInterval, 
        //RecurrenceDayOfWeekMask, RecurrenceDayOfMonth, RecurrenceInstance, RecurrenceMonthOfYear, NextOccurrenceDate from holiday
        // Add Holidays to Operating Hours
        List<Holiday> holidays = new List<Holiday>();
        for (List<Object> holidayDay : holidayDays) {
            Holiday holiday = new Holiday();
            holiday.Name = String.ValueOf(holidayDay[0]);
            holiday.IsAllDay = Boolean.ValueOf(holidayDay[1]);
            holiday.ActivityDate = Date.ValueOf(holidayDay[2]);
            holidays.add(holiday);
        }
        if (holidays.size()>0) {
            insert holidays;
        }
        System.debug('--- Created '+holidays.size()+ ' Holidays');
        return holidays;  
    }
    public static List<OperatingHoursHoliday> setupOperatingHoursHolidays(Id operatingHoursId,List<Id> holidayIds){
        //SELECT Id, IsDeleted, OperatingHoursHolidayNumber, OperatingHoursId, HolidayId, DateAndTime from OperatingHoursHoliday
        // Add Holidays to Operating Hours
        List<OperatingHoursHoliday> operatingHoursHolidays = new List<OperatingHoursHoliday>();
        for (Id holidayId : holidayIds) {
            OperatingHoursHoliday operatingHoursHoliday = new OperatingHoursHoliday();
            operatingHoursHoliday.OperatingHoursId = operatingHoursId;
            operatingHoursHoliday.HolidayId = holidayId;
            operatingHoursHolidays.add(operatingHoursHoliday);
        }
        if (operatingHoursHolidays.size()>0) {
            insert operatingHoursHolidays;
        }
        System.debug('--- Created '+operatingHoursHolidays.size()+ ' Operating Hours Holidays');
        return operatingHoursHolidays;  
    }
	public static Id setupAccount(){
        // Create B2C Account
        Id b2cRecordTypeId = [SELECT Id FROM RecordType WHERE (IsPersonType = TRUE) AND (SobjectType='Account')]?.Id;
        Account b2cAccount = new Account(RecordTypeID=b2cRecordTypeId,
                    FirstName='My',
                    LastName='FSL Person Account',
                    PersonEmail='test123@lumonCustomer.fsl',
                    PersonMailingCountry ='Finland',
                    PersonMailingCity='Vantaa',
                    PersonMailingPostalCode = '01740',
                    PersonMailingStreet='Vanha Kalliosolantie 8',
                    District__c = 'FI_North',
                    District_Type__c = 'P4');
        insert b2cAccount;
        System.debug('--- FSL B2C AccountId: '+b2cAccount.Id);
        System.debug('--- FSL B2C Account: '+b2cAccount);
        return b2cAccount.Id;
    }
    public static Id setupOpportunity(Id b2cAccountId, Id installationLocationId){
        // Create B2C Opportunity
        Opportunity fslOpportunity = new Opportunity(Name='FSL Opportunity',
                                            StageName='Quoting',
                                            CloseDate=system.Today()+10,
                                            Pricebook2Id=Test.getStandardPricebookId(),
                                            AccountId = b2cAccountId
                                            //Organization__c = 'LSU',
                                            //Country_Attribute__c,
                                            //BusinessType__c ='1',
                                            //District__c = 'FI_North',
                                            //Order_Type__c = 'Normal'
                                            );
        insert fslOpportunity;
        System.debug('--- FSL Opportunity: '+fslOpportunity);
        // Create FSL Opportunity
        fslOpportunity.CustomerSegment__c = '1000';
		fslOpportunity.StageName='Quoting';
        fslOpportunity.CloseDate = System.today().addDays(30); 
		//fslOpportunity.DeliveryLocation__c = installationLocationId;
		//fslOpportunity.DeliveryDate__c = System.today().addDays(5);
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
    /*public static Id setupConfiguration(Id opportunityId) {
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
    }*/
}