/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 10-08-2024
 * @last modified by  : Henk Reynders
**/
public class InboundDataController {
    // Inbound Order Data
    //public static InboundData inboundData {get; set;}
    public static InboundData.OrderMessage orderMessage {get; set;}
    public static InboundData.OrderData orderData {get; set;}
    public static InboundData.UserData userData {get; set;}
    public static InboundData.ProjectData projectData {get; set;}
    public static InboundData.CostData costData {get; set;}
    public static InboundData.CustomerData customerData {get; set;}
    public static InboundData.InvoicingData invoicingData {get; set;}
    public static InboundData.DeliveryData deliveryData {get; set;}
    public static InboundData.InstallationData installationData {get; set;}
    public static InboundData.ProductData productData {get; set;}
    public static List<InboundData.Product> products {get; set;}
    public static List<InboundData.Service> services {get; set;}
    // Salesforce Records
    public static Map<String,String> countryLookup {get;set;}
    public static Map<String,String> attributeLookup {get;set;}
    public static User salesUser;
    public static User servicesUser;
    public static String salesAttribute {get;set;}
    public static String serviceAttribute {get;set;}
    public static Building_Project__c mainProject {get; set;}
    public static Delivery_Project__c subProject {get; set;}
    public static List<Delivery_Project__c> subProjects {get; set;}
    public static Account customer {get; set;}
    public static Contact customerContact {get; set;}
    public static Account invoicingAccount {get; set;}
    public static Contact invoicingContact {get; set;}
    public static Contact deliveryContact {get; set;}
    public static Contact installationContact {get; set;}
    public static List<Contact> contacts {get; set;}
    public static Opportunity opportunity {get; set;}
    public static List<OpportunityLineItem> productLineItems {get; set;}
    public static Quote quote {get; set;}
    public static List<QuoteLineItem> quoteLineItems {get; set;}
    public static Order order {get; set;}
    public static List<OrderItem> orderLineItems {get; set;}
    public static WorkOrder workOrder {get; set;}
    public static List<WorkOrderLineItem> workOrderLineItems {get; set;}
    public static List<Asset> assets {get; set;}
    public static ServiceTerritory serviceTerritory {get; set;}
    public static List<ServiceResource> serviceResources {get; set;} 
    public static List<ServiceAppointment> appointments {get; set;}    

    private static Id B2BAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('B2B_Account').getRecordTypeId();
    private static Id B2CAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
    private static Id buildingRecordTypeId = Schema.SObjectType.Asset.getRecordTypeInfosByDeveloperName().get('Product').getRecordTypeId();
    private static Id apartmentRecordTypeId = Schema.SObjectType.Asset.getRecordTypeInfosByDeveloperName().get('Apartment').getRecordTypeId();
    private static Id planRecordTypeId = Schema.SObjectType.Asset.getRecordTypeInfosByDeveloperName().get('Plan').getRecordTypeId();
    private static Id productRecordTypeId = Schema.SObjectType.Asset.getRecordTypeInfosByDeveloperName().get('Product').getRecordTypeId();

    

    /**
    * @description Parse the Order JSON into the InboundData Wrapper
    * @author Henk Reynders | 09-06-2024 
    * @return InboundData 
    **/
    public static InboundData getInboundData(String inboundJson) {
        return InboundData.parse(inboundJson);
    }   
    /**
    * @description Parse the Order JSON into the InboundData Wrapper
    * @author Henk Reynders | 09-06-2024 
    * @return InboundData 
    **/
    public static InboundData.OrderMessage  getOrderMessage(String inboundJson) {
        InboundData  inboundData = getInboundData(inboundJson);
        orderMessage = inboundData.orderMessage;
        return orderMessage;
    }   
    /**
    * @description Parse the Order JSON into the InboundData Wrapper
    * @author Henk Reynders | 09-06-2024 
    * @return InboundData 
    **/
    public static InboundData.OrderData getOrderData() {
        orderData = orderMessage.orderData;
        return orderData;
    }   
    /**
    * @description Get the projectData from orderData Object 
    * @author Henk Reynders | 09-06-2024 
    * @return InboundData 
    **/
    public static InboundData.ProjectData getProjectData() {    
        projectData = orderData.projectData;
        System.Debug ('--- InboundDataController - getProjectData: '+projectData);
        return projectData;
    } 
   /**
    * @description Get the costData from orderData Object 
    * @author Henk Reynders | 09-06-2024 
    * @return InboundData 
    **/
    public static InboundData.CostData getCostData() {    
        costData = orderData.costData;
        System.Debug ('--- InboundDataController - getCostData: '+costData);
        return costData;
    } 
   /**
    * @description Get the invoicingData from orderData Object 
    * @author Henk Reynders | 09-06-2024 
    * @return InboundData 
    **/
    public static InboundData.InvoicingData getInvoicingData() {    
        invoicingData = orderData.invoicingData;
        System.Debug ('--- InboundDataController - getInvoicingData: '+invoicingData);
        return invoicingData;
    }

    //public String invoicingType {get;set;} 
    //public String payment {get;set;} 
    //public String paymentTerms {get;set;} 
    //public String financingReference {get;set;} 
    /**
    * @description Get the deliveryData from orderData Object 
    * @author Henk Reynders | 09-06-2024 
    * @return InboundData 
    **/
    public static InboundData.DeliveryData getDeliveryData() {    
        deliveryData = orderData.deliveryData;
        System.Debug ('--- InboundDataController - getDeliveryData: '+deliveryData);
        return deliveryData;
    }
    /**
    * @description Get the deliveryData from orderData Object 
    * @author Henk Reynders | 09-06-2024 
    * @return InboundData 
    **/
    public static InboundData.InstallationData getInstallationData() {    
        installationData = orderData.installationData;
        System.Debug ('--- InboundDataController - getInstallationData: '+installationData);
        return installationData;
    }
    /**
    * @description Get the customerData from orderData Object 
    * @author Henk Reynders | 09-06-2024 
    * @return InboundData 
    **/
    public static InboundData.CustomerData getCustomerData() {    
        customerData = orderData.customerData;
        System.Debug ('--- InboundDataController - getCustomerData: '+customerData);
        return customerData;
    } 
    /**
    * @description Get Customer Number from OrderData
    * @author Henk Reynders | 09-06-2024 
    * @return String 
    **/
    public static String getCustomerNumber() {       
        String customerNumber = String.IsNotBlank(String.valueOf(customerData.customerNumber)) ? String.valueOf(customerData.customerNumber) : '';
        return customerNumber;
    }
    /**
    * @description Get Customer Name from OrderData
    * @author Henk Reynders | 09-06-2024 
    * @return String 
    **/
    public static String getCustomerName() {
        String customerName = String.IsNotBlank(String.valueOf(customerData.customerName)) ? String.valueOf(customerData.customerName) : '';
        return customerName;
    }
    /**
    * @description Get Customer Id from OrderData
    * @author Henk Reynders | 09-06-2024 
    * @return String 
    **/
    public static String getCustomerId() {
        String customerId = String.IsNotBlank(String.valueOf(customerData.customerId)) ? String.valueOf(customerData.customerId) : '';
        return customerId;
    } 
    /**
    * @description Get Customer Country 
    * @author Henk Reynders | 09-06-2024 
    * @return String 
    **/
    public static String getCustomerCountryCode() {
        countryLookup = getCountryLookup();
        String countryCode = String.isNotBlank(customerData.country) ? countryLookup.get(customerData.country) : getUserCountry();   
        return countryCode;
    }
    /**
    * @description Get the Country Codes to lookup the alpha2 from alpha3 eg 'FIN' => 'FI'
    * @author Henk Reynders | 09-06-2024 
    * @return Map<String, String> 
    **/
    public static Map<String,String> getCountryLookup(){
        List<Country_Mapping__mdt> countryMappings = new List<Country_Mapping__mdt>();
        Map<String,String> countryLookup = new Map<String,String>();
        countryMappings = [SELECT CountryCodeAlpha3__c, CountryCodeAlpha2__c ,Country_Name__c  FROM Country_Mapping__mdt];
        System.debug('--- InboundDataController - getCountryLookup '+countryLookup.KeySet().size()+ 'Countries Mapped'); 
        if(countryMappings.size() > 0){
            for(Country_Mapping__mdt countryMapping : countryMappings){
                countryLookup.put(countryMapping.CountryCodeAlpha3__c, countryMapping.CountryCodeAlpha2__c);
            }
        }
        System.debug('--- InboundDataController - getCountryLookup '+countryLookup.KeySet().size()+ 'Countries Mapped'); 
        return countryLookup;
    }
    /**
    * @description Query for a Active User with matching AD shortName
    * @author Henk Reynders | 09-06-2024 
    * @param 
    * @return User 
    **/
    public static User getUser(String shortName){
        User sfUser;
        List<User> sfUsers = [SELECT Id,Name,IsActive, Profile.Name, UserRole.DeveloperName, CountryAttribute__c,ProfitCenterAttribute__c, OfficeAttribute__c  
                            FROM User 
                            WHERE AD_Short_Username__c =:shortName 
                                AND IsActive = true];
        sfUser = sfUsers?.size() > 0 ? sfUsers[0] : new User();
        return sfUser;
    }
    /**
    * @description Get the userData from orderData Object 
    * @author Henk Reynders | 09-06-2024 
    * @param 
    * @return User 
    **/
    public static InboundData.UserData getUserData(){
        userData = orderData.userData;
        System.Debug ('--- InboundDataController - getUserData: '+userData);
        return userData;
    }
    /**
    * @description Query for a User with shortName as salesperson.username
    * @author Henk Reynders | 09-06-2024 
    * @return User 
    **/
    public static User getSalesUser() {
        String shortName = String.isNotBlank(userData?.salesUserName) ? userData?.salesUserName : '';
        salesUser = getUser(shortName);
        return salesUser;
    }
    /**
    * @description Query for a User with shortName as salesperson.supervisor
    * @author Henk Reynders | 09-06-2024 
    * @return User 
    **/
    public static User getServicesUser() {
        String shortName = String.isNotBlank(userData?.servicesUserName) ? userData?.servicesUserName : '';
        servicesUser = getUser(shortName);
        return servicesUser;
    }
    /**
    * @description Get from User Object the CountryAttribute__c
    * @author Henk Reynders | 09-06-2024 
    * @return String 
    **/
    public static String getUserCountry() {
        String userCountryCode = String.isNotBlank(servicesUser.ProfitCenterAttribute__c) ? servicesUser.ProfitCenterAttribute__c : salesUser.ProfitCenterAttribute__c;
        return userCountryCode;
    }
    /**
    * @description Get from User Object the ProfitCenterAttribute__c
    * @author Henk Reynders | 09-06-2024 
    * @return String 
    **/
    public static String getUserProfitCenter() {
        String userProfitCenterCode = String.isNotBlank(servicesUser.ProfitCenterAttribute__c) ? servicesUser.ProfitCenterAttribute__c : salesUser.ProfitCenterAttribute__c;
        return userProfitCenterCode;
    }
    /**
    * @description Get from User Object the OfficeAttribute__c
    * @author Henk Reynders | 09-06-2024 
    * @return String 
    **/
    public static String getUserOffice() {
        String userOfficeCode = String.isNotBlank(servicesUser.OfficeAttribute__c) ? servicesUser.OfficeAttribute__c : salesUser.OfficeAttribute__c;
        return userOfficeCode;
    }
    /**
    * @description Get from User Object the OfficeAttribute__c
    * @author Henk Reynders | 09-06-2024 
    * @return String 
    **/
    public static String getSalesOffice() {
        String salesOfficeCode = String.isNotBlank(salesUser.OfficeAttribute__c) ? salesUser.OfficeAttribute__c : '';
        return salesOfficeCode;
    }
    /**
    * @description Get from User Object the OfficeAttribute__c
    * @author Henk Reynders | 09-06-2024 
    * @return String 
    **/
    public static String getServicesOffice() {
        String servicesOfficeCode = String.isNotBlank(servicesUser.OfficeAttribute__c) ? servicesUser.OfficeAttribute__c : salesUser.OfficeAttribute__c;
        return servicesOfficeCode;
    }
    /**
    * @description Get Business Country 
    * @author Henk Reynders | 09-06-2024 
    * @return String 
    **/
    public static String getCountryCode() {
        String countryCode = String.isNotBlank(deliveryData.country) ? countryLookup.get(deliveryData.country) : getUserCountry();   
        return countryCode;
    }

    /**
    * @description Get Invoice Country 
    * @author Henk Reynders | 09-06-2024 
    * @return String 
    **/
    public static String getBillingCountryCode() {
        String countryCode = String.isNotBlank(invoicingData.country) ? countryLookup.get(invoicingData.country) : getUserCountry();   
        return countryCode;
    }
    /**
    * @description Get Installation Country Attribute
    * @author Henk Reynders | 09-06-2024 
    * @return String 
    **/
    public static String getInstallationCountryCode() {
        String countryCode = String.isNotBlank(installationData.country) ? countryLookup.get(installationData.country) : getUserCountry();   
        return countryCode;
    }
    /**
    * @description Get Delivery Country Attribute
    * @author Henk Reynders | 09-06-2024 
    * @return String 
    **/
    public static String getShippingCountryCode() {
        String countryCode = String.isNotBlank(deliveryData.country) ? countryLookup.get(deliveryData.country) : getUserCountry();   
        return countryCode;
    }
   
    /**
    * @description Get Organization Business Attribute
    * @author Henk Reynders | 09-06-2024 
    * @return String 
    **/
    public static String getOrganizationCode() {
        String organizationCode  = String.isNotBlank(orderData.organizationCode) ? orderData.organizationCode : '';       
        return organizationCode;
    }
    
    /**
    * @description Get Profit Center (BU) Business Attribute
    * @author Henk Reynders | 09-06-2024 
    * @return String 
    **/
    public static String getProfitCenterCode() {
        String profitCenterCode  = String.isNotBlank(orderData.profitCenterCode) ? orderData.profitCenterCode : getUserProfitCenter();
        return profitCenterCode;
    }
    /**
    * @description Get Business Type Business Attribute
    * @author Henk Reynders | 09-06-2024 
    * @return String 
    **/
    public static String getBusinessType() {
        String segmentCode = String.isNotBlank(orderData.segmentCode) ? orderData.segmentCode : '';
        String businessTypeCode = String.isNotBlank(segmentCode) ? segmentCode.left(1) : '0';
        return businessTypeCode;
    }
    /**
    * @description Get Customer Segment Business Attribute
    * @author Henk Reynders | 09-06-2024 
    * @return String 
    **/
    public static String getCustomerSegment() {
        String segmentCode = String.isNotBlank(orderData.segmentCode) ? orderData.segmentCode : '';
        return segmentCode;
    }
    /**
    * @description Get from User Object the CountryAttribute__c
    * @author Henk Reynders | 09-06-2024 
    * @return String 
    **/
    public static String getPropertyType() {
        String propertyTypeCode  = String.isNotBlank(orderData.propertytype) ? orderData.propertytype : '';
        return propertyTypeCode;
    }
    /**
    * @description Get the values for the Business Attributes from the OrderData Inner Classes of the Wrapper
    * @author Henk Reynders | 09-06-2024 
    * @return Map<String,String>
    **/
    public static Map<String,String> getBusinessAttributes () {
        Map<String,String> businessAttributes = new Map<String,String>();
        Map<String,String> adPersons = getPersons();
        Map<String,User> sfUsers = getUsers();
        Map<String,Office__c> sfOffices = getOffices();
        
        String organizationCode  = getOrganizationCode();
        String countryCode = getShippingCountryCode();
        String profitCenterCode  = getProfitCenterCode();
        String salesOfficeCode= userData?.salesOfficeCode;
        String servicesOfficeCode = userData?.servicesOfficeCode;
        Id salesUserId = userData?.salesUser?.Id;
        Id servicesUserId = userData?.servicesUser?.Id;
        Id salesOfficeId= userData?.salesOffice?.Id;
        Id servicesOfficeId = userData?.servicesOffice?.Id;
        String officeCode = String.isNotBlank(servicesOfficeCode) ? servicesOfficeCode : salesOfficeCode;
        String businessTypeCode = String.isNotBlank(orderData.segmentCode) ? orderData.segmentCode.left(1) : '';
        String segmentCode  = String.isNotBlank(orderData.segmentCode) ? orderData.segmentCode : '';
        String propertyTypeCode  = String.isNotBlank(orderData.propertytype) ? orderData.propertytype : '';
        
        businessAttributes.put('organizationCode',organizationCode); // Organization "LSU"
        businessAttributes.put('countryCode',countryCode); //Delivery or Installation Country "FI"
        businessAttributes.put('profitCenterCode',profitCenterCode); // Profit Center "402"
        businessAttributes.put('officeCode',officeCode); // Office Country/Postal Code "FI-43510"
        businessAttributes.put('businessTypeCode',businessTypeCode); // Business "1" (Consumer)
        businessAttributes.put('segmentCode',segmentCode); // Customer Segment "1000" (Consumer Apartments)
        businessAttributes.put('propertyTypeCode',propertyTypeCode); // Building Type "APA" (Apartment)
        businessAttributes.put('salesUser',salesUserId); // Id of Sales User
        businessAttributes.put('salesOffice',salesOfficeId); // Id of Sales Office
        businessAttributes.put('servicesUser',servicesUserId); // Id of Field Services User
        businessAttributes.put('servicesOffice',servicesOfficeId); // Id of Field Services Office
        return businessAttributes;
    }

    /**
    * @description Get the Sales and Installation Manager Users based on their AD usernames
    * @author Henk Reynders | 09-14-2024 
    * @param persons 
    * @return Map<String, User> 
    **/
    public static Map<String,User> getUsers() {
        salesUser = getUser(userData?.salesUserName);
        servicesUser = getUser(userData?.servicesUserName);
        Map<String,User> users = new Map<String,User>();
        users.put('salesUser',salesUser);
        users.put('servicesUser',servicesUser);
        if (String.IsNotBlank(salesUser?.Id)) {
            userData.salesUser = salesUser;
        }
        if (String.IsNotBlank(servicesUser?.Id)) {
            userData.servicesUser = servicesUser;
        }
        return users;
    }
    /**
    * @description Get the Sales Person and Supervisor (Installation Manager) Usernames
    * @author Henk Reynders | 09-14-2024 
    * @return Map<String, String> 
    **/
    public static Map<String,String> getPersons() {
        String salesUsername  = String.isNotBlank(userData?.salesUsername) ? userData?.salesUsername : '';  
        String servicesUserName = String.isNotBlank(userData?.servicesUserName) ? userData?.servicesUserName: '';
        Map<String,String> persons = new Map<String,String>();
        persons.put('sales', salesUsername);
        persons.put('services',servicesUserName);
        return persons;
    }
    /**
    * @description Get the Sales and Field Service Offices associated the Sales User and Installation Manager
    * @author Henk Reynders | 09-14-2024 
    * @param users 
    * @return Map<String, Office__c> 
    **/
    public static Map<String,Office__c> getOffices() {
        Map<String,Office__c> offices = new Map<String,Office__c>();     
        String salesOfficeCode = userData?.salesUser?.OfficeAttribute__c;
        String servicesOfficeCode = userData?.servicesUser?.OfficeAttribute__c;
        if (String.IsNotBlank(salesOfficeCode)) {            
            userData.salesOfficeCode = salesOfficeCode;
            Office__c salesOffice = [SELECT Id,Name, OfficeCode__c FROM Office__c WHERE OfficeCode__c =: salesOfficeCode LIMIT 1];
            if (String.IsNotBlank(salesOffice?.Id)) {
                userData.salesOffice = salesOffice;
                offices.put('salesOffice', salesOffice);
            } 
        }
        if (String.IsNotBlank(servicesOfficeCode)) {
            userData.servicesOfficeCode = servicesOfficeCode;
            Office__c servicesOffice = [SELECT Id,Name, OfficeCode__c FROM Office__c WHERE OfficeCode__c =: servicesOfficeCode LIMIT 1];
            if (String.IsNotBlank(servicesOffice?.Id)) {
                userData.servicesOffice = servicesOffice;
                offices.put('servicesOffice', servicesOffice);
            }
        }
        return offices;
    }  
    
    /**
    * @description Get (Salestori) Offer Number from OrderData
    * @author Henk Reynders | 09-06-2024 
    * @return String 
    **/
    public static String getOfferNumber() {
        String offerNumber = String.IsNotBlank(String.valueOf(orderData.offerNumber)) ? String.valueOf(orderData.offerNumber) : '';
        return offerNumber;
    }
    /**
    * @description Get (Salestori) Main Project Number from OrderData
    * @author Henk Reynders | 09-06-2024 
    * @return String 
    **/
    public static String getProjectNumber() {
        String projectNumber = String.IsNotBlank(String.valueOf(orderData.projectNumber)) ? String.valueOf(orderData.projectNumber) : '';
        return projectNumber;
    }
    /**
    * @description Get Order Type from OrderData
    * @author Henk Reynders | 09-06-2024 
    * @return String 
    **/
    public static String getOrderType() {
        String orderType = String.IsNotBlank(String.valueOf(orderData.orderType)) ? String.valueOf(orderData.orderType) : '';
        return orderType;
    }
    /**
    * @description Get the generated salesAttribute based on the Business Attributes
    * @author Henk Reynders | 09-06-2024 
    * @param 
    **/
    public static String getSalesAttribute(){        
        String organizationCode  = attributeLookup.get('organization');
        String countryCode = attributeLookup.get('country');
        String profitCenterCode  = attributeLookup.get('profitCenter');
        String officeCode  = attributeLookup.get('office');
        String segmentCode  = attributeLookup.get('segment');
        salesAttribute = String.IsBlank(salesAttribute) && String.IsNotBlank(organizationCode) ? organizationCode : '';
        salesAttribute = String.IsBlank(salesAttribute) && String.IsNotBlank(countryCode) ? countryCode : '_'+countryCode;
        salesAttribute = String.IsBlank(salesAttribute) && String.IsNotBlank(profitCenterCode) ? profitCenterCode : '_'+profitCenterCode;
        salesAttribute = String.IsBlank(salesAttribute) && String.IsNotBlank(officeCode) ? officeCode : '_'+officeCode;
        salesAttribute = String.IsBlank(salesAttribute) && String.IsNotBlank(segmentCode) ? segmentCode : '_'+segmentCode;
        return salesAttribute;
    }
    /**
    * @description Get the generated serviceAttribute based on the Business Attributes
    * @author Henk Reynders | 09-06-2024 
    * @param  
    **/
    public static String getServiceAttribute(){
        String organizationCode  = attributeLookup.get('organization');
        String officeCode  = attributeLookup.get('office');
        String segmentCode  = attributeLookup.get('segment');
        salesAttribute = String.IsBlank(salesAttribute) && String.IsNotBlank(organizationCode) ? organizationCode : '';
        salesAttribute = String.IsBlank(salesAttribute) && String.IsNotBlank(officeCode) ? officeCode : '_'+officeCode;
        salesAttribute = String.IsBlank(salesAttribute) && String.IsNotBlank(segmentCode) ? segmentCode : '_'+segmentCode;
        return serviceAttribute;
    }  
    /**
    * @description Query for the applicable Service Territory matching the Service Attribute (org,country,office and segment)
    * @author Henk Reynders | 09-06-2024 
    * @param 
    * @return ServiceTerritory 
    **/
    public static ServiceTerritory getServiceTerritory(){
        serviceTerritory = [SELECT Id,Name,IsActive 
                            FROM ServiceTerritory 
                            WHERE ServiceAttribute__c =: serviceAttribute 
                                AND IsActive = true LIMIT 1];
        return serviceTerritory;
    }
    /**
    * @description Get the (Main) Project based on projectNumber or create a new Project
    * @author Henk Reynders | 09-24-2024 
    * @return Building_Project__c 
    **/
    public static Building_Project__c getBuildingProject(){   
        Id projectId =   projectData.mainProjectId;           
        String projectNumber = projectData.projectNumber;
        if (String.IsNotBlank(projectNumber) && String.IsBlank(projectId)) {
            System.debug('--- InboundDataController - getBuildingProject - Project Number '+projectNumber); 
            projectId = [SELECT Id FROM Building_Project__c WHERE ProjectNumber__c =: projectNumber LIMIT 1]?.Id; 
            if (String.IsNotBlank(projectId)){
                System.debug('--- InboundDataController - getBuildingProject - Existing Project : '+projectId); 
                mainProject = [SELECT Id, Name, ProjectNumber__c  
                            FROM Building_Project__c 
                            WHERE Id =: projectId 
                            LIMIT 1]; 
            } else {
                System.debug('--- InboundDataController - getBuildingProject - No Existing Project'); 
                mainProject = setBuildingProject(); 
            }
        } else {
            System.debug('--- InboundDataController - getBuildingProject - No Project Number'); 
        }
        System.debug('--- InboundDataController - getBuildingProject - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- InboundDataController - getBuildingProject - SOQL USED: ' + LIMITS.getQueries());
        return mainProject;
    }         
    /**
    * @description Set the (Main) ProjectRecord by creating a new Building Project
    * @author Henk Reynders | 09-06-2024 
    * @param  
    * @return Building_Project__c 
    **/
    public static Building_Project__c setBuildingProject(){
        try{
            System.debug('--- InboundDataController - setBuildingProject - Creating New Project'); 
            Building_Project__c newProject = new Building_Project__c();
            Building_Project__c duplicateProject = new Building_Project__c();
            //newProject.Name;
            newProject.ProjectNumber__c = projectData.projectParent;     
            newProject.isMigrated__c = true;
            newProject.UniqueId__c = projectData.projectParent;    
            System.debug('--- InboundDataController - setBuildingProject - Project to Create '+newProject);       
            if (String.IsNotBlank(newProject.Name)){
                Database.DMLOptions dml = new Database.DMLOptions(); 
                dml.DuplicateRuleHeader.allowSave = false;
                Database.SaveResult saveResultAttempt1 =  Database.insert(newProject,dml) ;
                if (!saveResultAttempt1.isSuccess()) {
                    List<Database.Error> error = saveResultAttempt1.getErrors();
                    System.Debug('--- InboundDataController - Database Error on Project Create : '+error[0] );
                    if (error[0] instanceof Database.DuplicateError) {
                        Database.DuplicateError duplicateError = (Database.DuplicateError)error[0];
                        Datacloud.DuplicateResult duplicateResult = duplicateError.getDuplicateResult();
                        Datacloud.MatchResult[] matchResults = duplicateResult.getMatchResults();
                        Datacloud.MatchResult matchResult = matchResults[0];
                        Datacloud.MatchRecord[] matchRecords = matchResult.getMatchRecords();
                        for (Datacloud.MatchRecord matchRecord : matchRecords) {
                            duplicateProject = (Building_Project__c)matchRecord.getRecord();
                        }
                        // If the duplicate rule is an alert rule, we can try to bypass it
                        dml.DuplicateRuleHeader.AllowSave = true;
                        Database.SaveResult saveResultAttempt2 = Database.insert(newProject, dml);
                        if (saveResultAttempt2.isSuccess()) {
                            System.Debug('--- InboundDataController - Duplicate Project Created: '+newProject?.Id);
                            System.Debug('--- InboundDataController - Duplicate Project Existing: '+duplicateProject?.Id);
                        }
                    }
                }else{
                    System.Debug('--- InboundDataController - New Project Created: '+newProject?.Id);
                    
                }
            }
            return newProject;

        } catch (Exception e){
            return null;
        }
    }
    /**
    * @description Get the (Sub) Project based on projectNumber or create a new Project
    * @author Henk Reynders | 09-24-2024 
    * @return Delivery_Project__c 
    **/
    public static Delivery_Project__c getDeliveryProject(){   
        Id projectId =   projectData.subProjectId;           
        String projectNumber = projectData.projectNumber;
            
        if (String.IsNotBlank(projectNumber) && String.IsBlank(projectId)) {
            System.debug('--- InboundDataController - getBuildingProject - Project Number '+projectNumber); 
            projectId = [SELECT Id FROM Delivery_Project__c WHERE ProjectNumber__c =: projectNumber LIMIT 1]?.Id; 
            if (String.IsNotBlank(projectId)){
                System.debug('--- InboundDataController - getBuildingProject - Existing Project : '+projectId); 
                subProject = [SELECT Id, Name, ProjectNumber__c,BuildingProject__c
                            FROM Delivery_Project__c 
                            WHERE Id =: projectId 
                            LIMIT 1]; 
            } else {
                System.debug('--- InboundDataController - getBuildingProject - No Existing Project'); 
                subProject = setDeliveryProject(); 
            }
        } else {
            System.debug('--- InboundDataController - getBuildingProject - No Project Number'); 
        }
        System.debug('--- InboundDataController - getBuildingProject - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- InboundDataController - getBuildingProject - SOQL USED: ' + LIMITS.getQueries());
        return subProject;
    }         
    /**
    * @description Set the (Sub) ProjectRecord by creating a new Delivery Project
    * @author Henk Reynders | 09-06-2024 
    * @param  
    * @return Delivery_Project__c 
    **/
    public static Delivery_Project__c setDeliveryProject(){
        try{
            System.debug('--- InboundDataController - setDeliveryProject - Creating New Delivery Project'); 
            Delivery_Project__c newProject = new Delivery_Project__c();
            Delivery_Project__c duplicateProject = new Delivery_Project__c();
            //newProject.Name;
            //newProject.BuildingProject__c = projectData.projectId;
            newProject.ProjectNumber__c = projectData.projectParent; // "subproject_parentproject": "100001", 
            newProject.SubprojectNumber__c =  projectData.projectNumber; // "subproject_number": "100001_01",
            newProject.ProjectCost__c = Decimal.ValueOf(projectData.ProjectCost); //"subproject_cost": "0.00",
            newProject.ProjectCategory__c = projectData.projectCategory; //"subproject_category": "Warranty", NOTE Seems always Warranty
            newProject.ProjectGroup__c = projectData.projectGroup; //"subproject_group": "CONWAR",
            newProject.OrderType__c = projectData.orderType; //"subproject_ordertype": "Normal",
            //newProject.ProjectType__c = projectData.projectType; //"subproject_ordertype": "Normal",
            newProject.isChargeable__c = projectData.isChargeable == 'chargable' ? true : false; //"subproject_chargeable": "non-chargeable"
            newProject.isMigrated__c = true;
            newProject.UniqueId__c = projectData.projectNumber;  
            //newProject.underWarranty__c

            System.debug('--- InboundDataController - setDeliveryProject - Project to Create '+newProject);       
            if (String.IsNotBlank(newProject.Name)){
                Database.DMLOptions dml = new Database.DMLOptions(); 
                dml.DuplicateRuleHeader.allowSave = false;
                Database.SaveResult saveResultAttempt1 =  Database.insert(newProject,dml) ;
                if (!saveResultAttempt1.isSuccess()) {
                    List<Database.Error> error = saveResultAttempt1.getErrors();
                    System.Debug('--- InboundDataController - Database Error on Project Create : '+error[0] );
                    if (error[0] instanceof Database.DuplicateError) {
                        Database.DuplicateError duplicateError = (Database.DuplicateError)error[0];
                        Datacloud.DuplicateResult duplicateResult = duplicateError.getDuplicateResult();
                        Datacloud.MatchResult[] matchResults = duplicateResult.getMatchResults();
                        Datacloud.MatchResult matchResult = matchResults[0];
                        Datacloud.MatchRecord[] matchRecords = matchResult.getMatchRecords();
                        for (Datacloud.MatchRecord matchRecord : matchRecords) {
                            duplicateProject = (Delivery_Project__c)matchRecord.getRecord();
                        }
                         // If the duplicate rule is an alert rule, we can try to bypass it
                        dml.DuplicateRuleHeader.AllowSave = true;
                        Database.SaveResult saveResultAttempt2 = Database.insert(newProject, dml);
                        if (saveResultAttempt2.isSuccess()) {
                            System.Debug('--- InboundDataController - Duplicate Delivery Project Created: '+newProject?.Id);
                            System.Debug('--- InboundDataController - Duplicate Delivery Project Existing: '+duplicateProject?.Id);
                        }
                    }
                }else{
                    System.Debug('--- InboundDataController - New Delivery Project Created: '+newProject?.Id);
                    
                }
            }
            return newProject;

        } catch (Exception e){
            return null;
        }
    }
    /**
    * @description Get the Account based on customerNumber or create a new Account
    * @author Henk Reynders | 09-07-2024 
    * @return Account 
    **/
    public static Account getCustomerAccount(){   
        Id accountId =   customerData.accountId;           
        String customerNumber = customerData.customerNumber; 
        String customerName= String.IsNotBlank(customerData.description) ? customerData.description : customerData.firstName+' '+customerData.lastName;
        String customerIdentifier = String.IsNotBlank(customerNumber) ? customerNumber : customerName;
        
        if (String.IsNotBlank(customerIdentifier) && String.IsBlank(accountId)) {
            System.debug('--- InboundDataController - getCustomerAccount - Customer Number '+customerNumber); 
            accountId = [SELECT Id FROM Account WHERE AccountNumber =: customerIdentifier OR Name =: customerIdentifier LIMIT 1]?.Id; 
        } else {
            System.debug('--- InboundDataController - getCustomerAccount - No Customer Number or Name'); 
        }
        if (String.IsNotBlank(accountId)){
            System.debug('--- InboundDataController - getCustomerAccount - Existing Account : '+accountId); 
            customer = [SELECT Id, Name, RecordTypeId, isPersonAccount, BillingAddress, ShippingAddress  
                        FROM Account 
                        WHERE Id =: accountId 
                        LIMIT 1]; 
        } else {
            System.debug('--- InboundDataController - getCustomerAccount - No Existing Account'); 
            customer = setCustomerAccount(); 
        }
        System.debug('--- InboundDataController - getCustomerAccount - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- InboundDataController - getCustomerAccount - SOQL USED: ' + LIMITS.getQueries());
        return customer;
    }
    /**
    * @description Set the Account Record by creating a new Account
    * @author Henk Reynders | 09-06-2024 
    * @param  
    * @return Account 
    **/
    public static Account setCustomerAccount(){
        try{
            System.debug('--- InboundDataController - setCustomerAccount - Creating New Account');
            Account newAccount = new Account();
            Account duplicateAccount = new Account();
            Account customerAccount = new Account();
            String segmentCode = getCustomerSegment();
            String businessCode = getBusinessType();
            String countryCode = getCustomerCountryCode();
            Id ownerId = getSalesUser()?.Id;

            switch on businessCode {
                when '1' { // Consumer
                    System.debug('--- InboundDataController - setCustomerAccount - Preparing New B2C Account'); 
                    //newAccount.IsPersonAccount = true;
                    newAccount.RecordTypeId = B2CAccountRecordTypeId;
                    newAccount.FirstName = customerData.firstName;
                    newAccount.LastName = customerData.lastName;
                    newAccount.PersonEmail = customerData.email;
                    newAccount.PersonMobilePhone = customerData.phone;
                    newAccount.PersonLeadSource = orderData.leadSource; 
                    newAccount.LanguagePreference__c = orderData.languageCode; 
                    newAccount.CurrencyIsoCode = orderData.currencyCode;
                    //newAccount.OwnerId = ownerId;
                    newAccount.PersonMailingCity= customerData.city;
                    newAccount.PersonMailingCountryCode = countryCode;
                    newAccount.PersonMailingPostalCode = customerData.postalCode;
                    newAccount.PersonMailingStreet = customerData.street;
                    newAccount.BillingCity= customerData.city;
                    newAccount.BillingCountryCode = countryCode;
                    newAccount.BillingPostalCode = customerData.postalCode;
                    newAccount.BillingStreet = customerData.street;
                    newAccount.ShippingCity= customerData.city;
                    newAccount.ShippingCountryCode = countryCode;
                    newAccount.ShippingPostalCode = customerData.postalCode;
                    newAccount.ShippingStreet = customerData.street;
                    newAccount.isMigrated__c = true;
                    newAccount.UniqueId__c = customerData.customerId; 
                    //newPersonAccount.BusinessType__c = getBusinessType();
                    
                }
                when '4' {// Project
                    System.debug('--- InboundDataController - setCustomerAccount - Preparing New B2B Account'); 
                    //newAccount.IsPersonAccount = false;
                    newAccount.RecordTypeId = B2BAccountRecordTypeId;
                    newAccount.Name = customerData.description;
                    //newAccount.Email = customerData.email;
                    newAccount.Phone = customerData.phone;
                    //newAccount.AccountSource = orderData.leadSource;
                    //newAccount.LanguagePreference__c = orderData.languageCode; 
                    //newAccount.CurrencyIsoCode = orderData.currencyCode;
                    //newAccount.OwnerId = ownerId;
                    //newAccount.BillingCity= invoicingData.city;
                    //newAccount.BillingCountryCode = countryCode;
                    //newAccount.BillingPostalCode = invoicingData.postalCode;
                    //newAccount.BillingStreet = invoicingData.street;
                    newAccount.ShippingCity= customerData.city;
                    newAccount.ShippingCountryCode = countryCode;
                    newAccount.ShippingPostalCode = customerData.postalCode;
                    newAccount.ShippingStreet = customerData.street;
                    newAccount.isMigrated__c = true;
                    newAccount.UniqueId__c = customerData.customerId; 
                }
                when '7' {//after Sales
                }
                when '9' { //Reseller
                }
                when else {// Other
                }
            }          
            System.debug('--- InboundDataController - setCustomerAccount - Account to Create '+newAccount);       
            if (String.IsNotBlank(newAccount.Name)){
                Database.DMLOptions dml = new Database.DMLOptions(); 
                dml.DuplicateRuleHeader.allowSave = false;
                Database.SaveResult saveResultAttempt1 =  Database.insert(newAccount,dml) ;
                if (!saveResultAttempt1.isSuccess()) {
                    List<Database.Error> error = saveResultAttempt1.getErrors();
                    System.Debug('--- InboundDataController - Database Error on Account Create : '+error[0] );
                    if (error[0] instanceof Database.DuplicateError) {
                        Database.DuplicateError duplicateError = (Database.DuplicateError)error[0];
                        Datacloud.DuplicateResult duplicateResult = duplicateError.getDuplicateResult();
                        Datacloud.MatchResult[] matchResults = duplicateResult.getMatchResults();
                        Datacloud.MatchResult matchResult = matchResults[0];
                        Datacloud.MatchRecord[] matchRecords = matchResult.getMatchRecords();
                        for (Datacloud.MatchRecord matchRecord : matchRecords) {
                            duplicateAccount = (Account)matchRecord.getRecord();
                        }
                        // If the duplicate rule is an alert rule, we can try to bypass it
                        dml.DuplicateRuleHeader.AllowSave = true;
                        Database.SaveResult saveResultAttempt2 = Database.insert(newAccount, dml);
                        if (saveResultAttempt2.isSuccess()) {
                            System.Debug('--- InboundDataController - Duplicate Account Created: '+newAccount?.Id);
                            System.Debug('--- InboundDataController - Duplicate Account Existing: '+duplicateAccount?.Id);
                        }
                    }
                }else{
                    System.Debug('--- InboundDataController - New Account Created: '+newAccount?.Id);
                    
                }
            }
            return newAccount;

        } catch (Exception e){
            return null;
        }
    }
    /**
    * @description Get the Contact based on customerNumber or create a new Contact
    * @author Henk Reynders | 09-07-2024 
    * @return Contact 
    **/
    public static Contact getCustomerContact(){   
        Id accountId =   customerData.accountId;      
        Id contactId =   customerData.contactId;
        String firstName = customerData.firstName;
        String lastName = customerData.firstName;
        String contactName = firstName+' '+lastName;
        String phone = customerData.firstName;
        String email = customerData.email;
        String fax = customerData.fax;

        if (String.IsNotBlank(contactName) && String.IsBlank(contactId)) {
            System.debug('--- InboundDataController - getContact - Name '+contactName); 
            contactId = [SELECT Id FROM Contact WHERE Name =: contactName LIMIT 1]?.Id; 
            if (String.IsNotBlank(contactId)){ 
                System.debug('--- InboundDataController - getContact - Existing Contact : '+contactId); 
                customerContact = [SELECT Id, Name, IsPersonAccount , MailingAddress, OtherAddress  
                            FROM Contact 
                            WHERE Id =: contactId
                            LIMIT 1]; 
                if (String.IsNotBlank(customerContact.Id)){
                    customerData.contactId = customerContact.Id;
                    if(customerContact.isPersonAccount){
                        customerData.accountId = [SELECT Id FROM Account WHERE PersonContactId =: customerContact.Id LIMIT 1]?.Id; 
                    }
                }
            } else {
                System.debug('--- InboundDataController - getContact - No Existing Contact'); 
                customerContact = setCustomerContact(); 
            }
        } else {
            System.debug('--- InboundDataController - getContact - No Contact Name'); 
        }
        System.debug('--- InboundDataController - getContact - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- InboundDataController - getContact - SOQL USED: ' + LIMITS.getQueries());
        return customerContact;
    }
    /**
    * @description Set the Contact Record by creating a new Contact
    * @author Henk Reynders | 09-06-2024 
    * @param  
    * @return Contact 
    **/
    public static Contact setCustomerContact(){
        try{
            System.debug('--- InboundDataController - setContact - Creating New Contact'); 
            Contact newContact = new Contact();
            Contact duplicateContact = new Contact();
            Contact customerContact = new Contact();
            Account newAccount = new Account();
            Account duplicateAccount = new Account();
            Account customerAccount = new Account();
            String segmentCode = getCustomerSegment();
            String businessCode = getBusinessType();
            String countryCode = getCustomerCountryCode(); 
            Id ownerId = getSalesUser()?.Id;
            switch on businessCode {
                when '1' { // Consumer
                    System.debug('--- InboundDataController - setContact - Preparing New B2C Person Account (Contact)'); 
                    newAccount.RecordTypeId = B2CAccountRecordTypeId;
                    newAccount.FirstName = customerData.firstName;
                    newAccount.LastName = customerData.lastName;
                    newAccount.PersonEmail = customerData.email;
                    newAccount.PersonMobilePhone = customerData.phone;
                    newAccount.PersonLeadSource = orderData.leadSource; 
                    newAccount.LanguagePreference__c = orderData.languageCode; 
                    newAccount.CurrencyIsoCode = orderData.currencyCode;
                    newAccount.OwnerId = ownerId;
                    newAccount.PersonMailingCity= customerData.city;
                    newAccount.PersonMailingCountryCode = countryCode;
                    newAccount.PersonMailingPostalCode = customerData.postalCode;
                    newAccount.PersonMailingStreet = customerData.street;
                    //public String county {get;set;} 
                    //public String province {get;set;} 

                } 
                when '4' { // Project
                    newContact.accountId = customerData.accountId;
                    newContact.FirstName = customerData.firstName;
                    newContact.LastName = customerData.lastName;
                    newContact.Email = customerData.email;
                    newContact.MobilePhone = customerData.phone;
                    newContact.Fax = customerData.fax;
                    newContact.LeadSource = orderData.leadSource; 
                    newContact.LanguagePreference__c = orderData.languageCode; 
                    newContact.CurrencyIsoCode = orderData.currencyCode;
                    newContact.OwnerId = ownerId;
                    newContact.MailingCity= customerData.city;
                    newContact.MailingCountryCode = countryCode;
                    newContact.MailingPostalCode = customerData.postalCode;
                    newContact.MailingStreet = customerData.street; 
                }
                when '7' {//after Sales
                }
                when '9' { //Reseller
                }
                when else {// Other
                }  
            }      
            System.debug('--- InboundDataController - setContact - Contact to Create '+newContact);       
            if (String.IsNotBlank(newContact.Name)){
                Database.DMLOptions dml1 = new Database.DMLOptions(); 
                dml1.DuplicateRuleHeader.allowSave = false;
                Database.SaveResult saveResultAttempt1 =  Database.insert(newContact,dml1) ;
                if (!saveResultAttempt1.isSuccess()) {
                    List<Database.Error> error = saveResultAttempt1.getErrors();
                    System.Debug('--- InboundDataController - Database Error on Contact Create : '+error[0] );
                    if (error[0] instanceof Database.DuplicateError) {
                        Database.DuplicateError duplicateError = (Database.DuplicateError)error[0];
                        Datacloud.DuplicateResult duplicateResult = duplicateError.getDuplicateResult();
                        Datacloud.MatchResult[] matchResults = duplicateResult.getMatchResults();
                        Datacloud.MatchResult matchResult = matchResults[0];
                        Datacloud.MatchRecord[] matchRecords = matchResult.getMatchRecords();
                        for (Datacloud.MatchRecord matchRecord : matchRecords) {
                            duplicateContact = (Contact)matchRecord.getRecord();
                        }
                        // If the duplicate rule is an alert rule, we can try to bypass it
                        dml1.DuplicateRuleHeader.AllowSave = true;
                        Database.SaveResult saveResultAttempt2 = Database.insert(newContact, dml1);
                        if (saveResultAttempt2.isSuccess()) {
                            System.Debug('--- InboundDataController - Duplicate Contact Created: '+newContact?.Id);
                            System.Debug('--- InboundDataController - Duplicate Contact Existing: '+duplicateContact?.Id);
                        }
                    }
                } else if (String.IsNotBlank(newAccount.Name)){
                    Database.DMLOptions dml2 = new Database.DMLOptions(); 
                    dml2.DuplicateRuleHeader.allowSave = false;
                    Database.SaveResult saveResultAttempt3 =  Database.insert(newAccount,dml2) ;
                    if (!saveResultAttempt1.isSuccess()) {
                        List<Database.Error> error = saveResultAttempt3.getErrors();
                        System.Debug('--- InboundDataController - Database Error on Account Create : '+error[0] );
                        if (error[0] instanceof Database.DuplicateError) {
                            Database.DuplicateError duplicateError = (Database.DuplicateError)error[0];
                            Datacloud.DuplicateResult duplicateResult = duplicateError.getDuplicateResult();
                            Datacloud.MatchResult[] matchResults = duplicateResult.getMatchResults();
                            Datacloud.MatchResult matchResult = matchResults[0];
                            Datacloud.MatchRecord[] matchRecords = matchResult.getMatchRecords();
                            for (Datacloud.MatchRecord matchRecord : matchRecords) {
                                duplicateAccount = (Account)matchRecord.getRecord();
                            }
                            // If the duplicate rule is an alert rule, we can try to bypass it
                            dml2.DuplicateRuleHeader.AllowSave = true;
                            Database.SaveResult saveResultAttempt4 = Database.insert(newAccount, dml2);
                            if (saveResultAttempt4.isSuccess()) {
                                System.Debug('--- InboundDataController - Duplicate Account Created: '+newAccount?.Id);
                                System.Debug('--- InboundDataController - Duplicate Account Existing: '+duplicateAccount?.Id);
                            }
                        }
                    }
                }else{
                    System.Debug('--- InboundDataController - New Contact Created: '+newContact?.Id);
                    
                }
            }
            return newContact;

        } catch (Exception e){
            return null;
        }
    }

    /**
    * @description Get the Opportunity based on customerNumber or create a new Opportunity
    * @author Henk Reynders | 09-07-2024 
    * @return Opportunity 
    **/
    public static Opportunity getOpportunity(){
        Opportunity opportunity;
        String offerNumber = getOfferNumber();
        if (String.IsNotBlank(offerNumber)) {
            Id opportunityId = [SELECT Id FROM Opportunity WHERE CurrentOfferNumber__c =: offerNumber LIMIT 1]?.Id; 
            if (String.IsNotBlank(opportunityId)){
                opportunity = [SELECT Id, Name, RecordTypeId, accountId, StageName 
                            FROM Opportunity 
                            WHERE Id =: opportunityId
                            LIMIT 1]; 
            } else {
                opportunity = setOpportunity();
            }
        }         
        System.debug('--- InboundDataController - getOpportunity - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- InboundDataController - getOpportunity - SOQL USED: ' + LIMITS.getQueries());
        return opportunity;
    }
    /**
    * @description Set the Opportunity Record by creating a new Opportunity
    * @author Henk Reynders | 09-07-2024 
    * @return Opportunity 
    **/
    public static Opportunity setOpportunity(){
        Id B2BOpportunityRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('B2B_Opportunity').getRecordTypeId();
        Id B2COpportunityRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('B2C_Opportunity').getRecordTypeId();
        try{
            Opportunity newOpportunity = new Opportunity();
            Opportunity duplicateOpportunity = new Opportunity();
            // OrderData
            // Attributes
            Map<String,String> businessAttributes =  getBusinessAttributes();
            String businessType = businessAttributes.get('businessType');
            // Salesforce Records
            Id customerId = getCustomerAccount()?.Id;
            Id salesUserId = getSalesUser()?.Id;

            switch on businessType {
                when '1' { // Consumer                   
                    newOpportunity.RecordTypeId = B2COpportunityRecordTypeId;
                }
                when '4' { // Project
                    newOpportunity.RecordTypeId = B2BOpportunityRecordTypeId;
                }
                when else { // Other or Reseller} 
                    return newOpportunity;
                }
            }
            newOpportunity.isMigrated__c = true;
            newOpportunity.AccountId = customerId;
            //newOpportunity.ContactId = contactId;
            newOpportunity.OwnerId = salesUserId;
            //newOpportunity.Name = opportunityName;
            newOpportunity.Type = getOrderType();            
            // newOpportunity.OfferNumber__c = getOfferNumber(); Set in Quote then displayed on Opportunity
            // Business Attribute
            newOpportunity.Organization__c  = businessAttributes.get('organizationCode');
            newOpportunity.CountryCode__c  = businessAttributes.get('countryCode');
            //newOpportunity.District__c;
            newOpportunity.ProfitCenter__c  = businessAttributes.get('profitCenterCode');
            newOpportunity.BusinessType__c = businessAttributes.get('businessTypeCode');
            newOpportunity.CustomerSegment__c = businessAttributes.get('segmentCode');
            // Close on Creation
            newOpportunity.closeDate = system.today();
            newOpportunity.StageName ='Closed Won';
            // Customer
            newOpportunity.Customer_Address__City__s = customerData.city;
            newOpportunity.Customer_Address__CountryCode__s = getCustomerCountryCode();
            newOpportunity.Customer_Address__Street__s = customerData.street;
            newOpportunity.Customer_Address__PostalCode__s = customerData.postalCode;
            // Invoicing
            newOpportunity.Invoicing_Address__City__s = invoicingData.city;
            newOpportunity.Invoicing_Address__CountryCode__s = getBillingCountryCode();
            newOpportunity.Invoicing_Address__Street__s = invoicingData.street;
            newOpportunity.Invoicing_Address__PostalCode__s = invoicingData.postalCode;
            // Delivery 
            newOpportunity.Deliver_To__c  = 'Other';
            newOpportunity.Delivery_Address__City__s = deliveryData.city;
            newOpportunity.Delivery_Address__CountryCode__s = getShippingCountryCode();
            newOpportunity.Delivery_Address__Street__s = deliveryData.street;
            newOpportunity.Delivery_Address__PostalCode__s = deliveryData.postalCode; 
            //Installation
            newOpportunity.Install_At__c  = 'Other';
            newOpportunity.Installation_Address__City__s = installationData.city;
            newOpportunity.Installation_Address__CountryCode__s = getInstallationCountryCode();
            newOpportunity.Installation_Address__Street__s = installationData.street;
            newOpportunity.Installation_Address__PostalCode__s = installationData.postalCode;
          
            // Attempt to create the Opportunity
            if (newOpportunity.isMigrated__c = true){
                Database.DMLOptions dml = new Database.DMLOptions(); 
                dml.DuplicateRuleHeader.allowSave = false;
                Database.SaveResult saveResultAttempt1 =  Database.insert(newOpportunity,dml) ;
                if (!saveResultAttempt1.isSuccess()) {
                    List<Database.Error> error = saveResultAttempt1.getErrors();
                    System.Debug('--- InboundDataController - Database Error on Opportunity Create : '+error[0] );
                    if (error[0] instanceof Database.DuplicateError) {
                        Database.DuplicateError duplicateError = (Database.DuplicateError)error[0];
                        Datacloud.DuplicateResult duplicateResult = duplicateError.getDuplicateResult();
                        Datacloud.MatchResult[] matchResults = duplicateResult.getMatchResults();
                        Datacloud.MatchResult matchResult = matchResults[0];
                        Datacloud.MatchRecord[] matchRecords = matchResult.getMatchRecords();
                        for (Datacloud.MatchRecord matchRecord : matchRecords) {
                            duplicateOpportunity = (Opportunity)matchRecord.getRecord();
                        }
                        // If the duplicate rule is an alert rule, we can try to bypass it
                        dml.DuplicateRuleHeader.AllowSave = true;
                        Database.SaveResult saveResultAttempt2 = Database.insert(newOpportunity, dml);
                        if (saveResultAttempt2.isSuccess()) {
                            System.Debug('--- InboundDataController - Duplicate Opportunity Created: '+newOpportunity?.Id);
                            System.Debug('--- InboundDataController - Duplicate Opportunity Existing: '+duplicateOpportunity?.Id);
                        }
                    }
                }else{
                    System.Debug('--- InboundDataController - New Opportunity Created: '+newOpportunity?.Id);
                    
                }
            }
            return newOpportunity;
        } catch (Exception e){
            return null;
        }
    }
    /**
    * @description Get the Quote based on customerNumber or create a new (Standalone) Quote
    * @author Henk Reynders | 09-07-2024 
    * @return Quote 
    **/
    public static Quote getQuote(){
        Quote quote;
        String offerNumber = getOfferNumber();
        if (String.IsNotBlank(offerNumber)) {
            Id quoteId = [SELECT Id FROM Quote WHERE OfferNumber__c =: offerNumber LIMIT 1]?.Id; 
            if (String.IsNotBlank(quoteId)){
                quote = [SELECT Id, Name, AccountId, isSyncing, OfferNumber__c 
                            FROM Quote 
                            WHERE Id =: quoteId
                            LIMIT 1]; 
            } else {
                quote = setQuote();
            }
        }         
        System.debug('--- InboundDataController - getQuote - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- InboundDataController - getQuote - SOQL USED: ' + LIMITS.getQueries());
        orderData.quote = quote;
        return quote;
    }
    /**
    * @description Set the Quote Record by creating a new (Standalone) Quote
    * @author Henk Reynders | 09-07-2024 
    * @return Quote 
    **/
    public static Quote setQuote(){
        Id B2BQuoteRecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByDeveloperName().get('B2B_Quote').getRecordTypeId();
        Id B2CQuoteRecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByDeveloperName().get('B2C_Quote').getRecordTypeId();
        try{
            Quote newQuote = new Quote();
            Quote duplicateQuote = new Quote();
            // OrderData
            String organizationCode  = getOrganizationCode();   
            String countryCode = getCountryCode();
            String profitCenterCode  = getProfitCenterCode();
            String officeCode = getUserOffice();
            String segmentCode  = getCustomerSegment();
            String propertyType  = getPropertyType();
            String businessType = getBusinessType();
            String orderType = getOrderType();
            String offerNumber = getOfferNumber();
            // Salesforce Records
            Id customerId = getCustomerAccount()?.Id;
            Id salesUserId = getSalesUser()?.Id;

            switch on businessType {
                when '1' { // Consumer
                    if (String.IsNotBlank(orderData?.account?.Id)){
                        //newQuote.AccountId = orderData?.account?.Id;
                        newQuote.QuoteAccountId = orderData?.account?.Id;
                    }
                    if (String.IsNotBlank(orderData?.contact?.Id)){
                        newQuote.ContactId = orderData?.contact?.Id;
                    }
                    if (String.IsNotBlank(orderData?.opportunity?.Id)){
                        newQuote.opportunityId = orderData?.opportunity?.Id;
                    }
                    if (String.IsNotBlank(userData?.salesUser?.Id)){
                        newQuote.OwnerId = userData?.salesUser?.Id;
                    }
                    // Quote Values
                    //newQuote.Name = opportunityName;
                    newQuote.isMigrated__c = true;
                    newQuote.OfferNumber__c = orderData?.offerNumber;                                    
                    // Business Attribute
                    newQuote.Organization__c  = organizationCode;
                    //newQuote.CountryCode__c  = countryCode;
                    //newQuote.District__c;
                    //newQuote.ProfitCenter__c  = profitCenterCode;
                    //newQuote.BusinessType__c = businessType;
                    //newQuote.CustomerSegment__c = segmentCode;
                    // Close on Creation
                    //newQuote.closeDate = system.today();
                    //newQuote.Status ='Closed Won';
                    // Customer
                    
                    
                    // Invoicing

                    // Delivery 

                    //Installation

                }
                when else {// Other
                }    
            }            
            if (newQuote.isMigrated__c){
                Database.DMLOptions dml = new Database.DMLOptions(); 
                dml.DuplicateRuleHeader.allowSave = false;
                Database.SaveResult saveResultAttempt1 =  Database.insert(newQuote,dml) ;
                if (!saveResultAttempt1.isSuccess()) {
                    List<Database.Error> error = saveResultAttempt1.getErrors();
                    System.Debug('--- InboundDataController - Database Error on Opportunity Create : '+error[0] );
                    if (error[0] instanceof Database.DuplicateError) {
                        Database.DuplicateError duplicateError = (Database.DuplicateError)error[0];
                        Datacloud.DuplicateResult duplicateResult = duplicateError.getDuplicateResult();
                        Datacloud.MatchResult[] matchResults = duplicateResult.getMatchResults();
                        Datacloud.MatchResult matchResult = matchResults[0];
                        Datacloud.MatchRecord[] matchRecords = matchResult.getMatchRecords();
                        for (Datacloud.MatchRecord matchRecord : matchRecords) {
                            duplicateQuote = (Quote)matchRecord.getRecord();
                        }
                        // If the duplicate rule is an alert rule, we can try to bypass it
                        dml.DuplicateRuleHeader.AllowSave = true;
                        Database.SaveResult saveResultAttempt2 = Database.insert(newQuote, dml);
                        if (saveResultAttempt2.isSuccess()) {
                            System.Debug('--- InboundDataController - Duplicate Quote Created: '+newQuote?.Id);
                        System.Debug('--- InboundDataController - Duplicate Quote Existing: '+duplicateQuote?.Id);
                        }
                    }
                }else{
                    System.Debug('--- InboundDataController - New Quote Created: '+newQuote?.Id);
                    
                }
            }
            return newQuote;
        } catch (Exception e){
            return null;
        }
    }
    /**
    * @description Get the Order based on offernumber and batch Id or create a new  Order
    * @author Henk Reynders | 09-07-2024 
    * @return Order 
    **/
    public static Order getOrder(){
        Order order;
        Id accountId = orderData?.account?.Id;
        String batchId;
        String offerNumber = getOfferNumber();
        if (String.IsNotBlank(offerNumber)) {
            Id orderId = [SELECT Id 
                            FROM Order 
                            WHERE OfferNumber__c =: offerNumber 
                            AND AccountId =: accountId
                            LIMIT 1]?.Id; 
            if (String.IsNotBlank(orderId)){
                order = [SELECT Id, Name, AccountId, OfferNumber__c 
                            FROM Order 
                            WHERE Id =: orderId
                            LIMIT 1]; 
            } else {
                order = setOrder();
            }
        }         
        System.debug('--- InboundDataController - getOrder - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- InboundDataController - getOrder - SOQL USED: ' + LIMITS.getQueries());
        List<Order> orders =  orderData.orders;
        orders.add(order);
        //orderMessage.orderData.orders = orders;
        return order;
    }
    /**
    * @description Set the Order Record by creating a new Order
    * @author Henk Reynders | 09-07-2024 
    * @return Order 
    **/
    public static Order setOrder(){
        Id B2BOrderRecordTypeId = Schema.SObjectType.Order.getRecordTypeInfosByDeveloperName().get('B2B_Order').getRecordTypeId();
        Id B2COrderRecordTypeId = Schema.SObjectType.Order.getRecordTypeInfosByDeveloperName().get('B2C_Order').getRecordTypeId();
        try{
            Order newOrder = new Order();
            Order duplicateOrder = new Order();
            // OrderData
            String organizationCode  = getOrganizationCode();   
            String countryCode = getCountryCode();
            String profitCenterCode  = getProfitCenterCode();
            String officeCode = getUserOffice();
            String segmentCode  = getCustomerSegment();
            String propertyType  = getPropertyType();
            String businessType = getBusinessType();
            String orderType = getOrderType();
            String offerNumber = getOfferNumber();
            // Salesforce Records
            Id customerId = getCustomerAccount()?.Id;
            Id salesUserId = getSalesUser()?.Id;

            switch on businessType {
                when '1' { // Consumer
                    if (String.IsNotBlank(orderData?.account?.Id)){
                        //newOrder.AccountId = orderData?.account?.Id;
                        newOrder.AccountId = orderData?.account?.Id;
                    }

                    if (String.IsNotBlank(orderData?.opportunity?.Id)){
                        newOrder.opportunityId = orderData?.opportunity?.Id;
                    }
                    if (String.IsNotBlank(orderData?.contract?.Id)){
                        newOrder.ContractId = orderData?.contract?.Id;
                    }
                    if (String.IsNotBlank(userData?.salesUser?.Id)){
                        newOrder.OwnerId = userData?.salesUser?.Id;
                    }
                    // Order Values
                    //newOrder.Name = opportunityName;
                    newOrder.isMigrated__c = true;
                    newOrder.OfferNumber__c = orderData?.offerNumber;                    
                    newOrder.Type = orderType;                 
                }
                when else {// Other
                }    
            }            
            if (newOrder.isMigrated__c){
                Database.DMLOptions dml = new Database.DMLOptions(); 
                dml.DuplicateRuleHeader.allowSave = false;
                Database.SaveResult saveResultAttempt1 =  Database.insert(newOrder,dml) ;
                if (!saveResultAttempt1.isSuccess()) {
                    List<Database.Error> error = saveResultAttempt1.getErrors();
                    System.Debug('--- InboundDataController - Database Error on Order Create : '+error[0] );
                    if (error[0] instanceof Database.DuplicateError) {
                        Database.DuplicateError duplicateError = (Database.DuplicateError)error[0];
                        Datacloud.DuplicateResult duplicateResult = duplicateError.getDuplicateResult();
                        Datacloud.MatchResult[] matchResults = duplicateResult.getMatchResults();
                        Datacloud.MatchResult matchResult = matchResults[0];
                        Datacloud.MatchRecord[] matchRecords = matchResult.getMatchRecords();
                        for (Datacloud.MatchRecord matchRecord : matchRecords) {
                            duplicateOrder = (Order)matchRecord.getRecord();
                        }
                        // If the duplicate rule is an alert rule, we can try to bypass it
                        dml.DuplicateRuleHeader.AllowSave = true;
                        Database.SaveResult saveResultAttempt2 = Database.insert(newOrder, dml);
                        if (saveResultAttempt2.isSuccess()) {
                            System.Debug('--- InboundDataController - Duplicate Order Created: '+newOrder?.Id);
                            System.Debug('--- InboundDataController - Duplicate Order Existing: '+duplicateOrder?.Id);
                        }
                    }
                }else{
                    System.Debug('--- InboundDataController - New Order Created: '+newOrder?.Id);
                    
                }
            }
            return newOrder;
        } catch (Exception e){
            return null;
        }
    }
    /**
    * @description Get the Contract based on offernumber and batch Id or create a new Contract
    * @author Henk Reynders | 09-07-2024 
    * @return Order 
    **/
    public static Contract getContract(){
        Contract contract;
        Id accountId = orderData?.account?.Id;
        String batchId;
        String offerNumber = getOfferNumber();
        if (String.IsNotBlank(offerNumber)) {
            Id contractId = [SELECT Id 
                            FROM Contract 
                            WHERE OfferNumber__c =: offerNumber 
                            AND AccountId =: accountId
                            LIMIT 1]?.Id; 
            if (String.IsNotBlank(contractId)){
                contract = [SELECT Id, Name, AccountId, OfferNumber__c 
                            FROM Contract 
                            WHERE Id =: contractId
                            LIMIT 1]; 
            } else {
                contract = setContract();
            }
        }         
        System.debug('--- InboundDataController - getContract - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- InboundDataController - getContract - SOQL USED: ' + LIMITS.getQueries());
        //orderMessage.orderData.contract = contract;
        return contract;
    }
    /**
    * @description Set the Contract Record by creating a new Contract
    * @author Henk Reynders | 09-07-2024 
    * @return Contract 
    **/
    public static Contract setContract(){
        Id B2BContractRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByDeveloperName().get('B2B_Contract').getRecordTypeId();
        Id B2CContractRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByDeveloperName().get('B2C_Contract').getRecordTypeId();
        try{
            Contract newContract = new Contract();
            Contract duplicateContract = new Contract();
            // ContractData
            String organizationCode  = getOrganizationCode();   
            String countryCode = getCountryCode();
            String profitCenterCode  = getProfitCenterCode();
            String officeCode = getUserOffice();
            String segmentCode  = getCustomerSegment();
            String propertyType  = getPropertyType();
            String businessType = getBusinessType();
            String orderType = getOrderType();
            String offerNumber = getOfferNumber();
            // Salesforce Records
            Id customerId = getCustomerAccount()?.Id;
            Id salesUserId = getSalesUser()?.Id;

            switch on businessType {
                when '1' { // Consumer
                    if (String.IsNotBlank(orderData?.account?.Id)){
                        //newContract.AccountId = orderData?.account?.Id;
                        newContract.AccountId = orderData?.account?.Id;
                    }
                    if (String.IsNotBlank(userData?.salesUser?.Id)){
                        newContract.OwnerId = userData?.salesUser?.Id;
                    }
                    // Contract Values
                    //newContract.Name = opportunityName;
                    newContract.isMigrated__c = true;
                    newContract.OfferNumber__c = orderData?.offerNumber;                                    
                }
                when else {// Other
                }    
            }            
            if (newContract.isMigrated__c){
                Database.DMLOptions dml = new Database.DMLOptions(); 
                dml.DuplicateRuleHeader.allowSave = false;
                Database.SaveResult saveResultAttempt1 =  Database.insert(newContract,dml) ;
                if (!saveResultAttempt1.isSuccess()) {
                    List<Database.Error> error = saveResultAttempt1.getErrors();
                    System.Debug('--- InboundDataController - Database Error on Contract Create : '+error[0] );
                    if (error[0] instanceof Database.DuplicateError) {
                        Database.DuplicateError duplicateError = (Database.DuplicateError)error[0];
                        Datacloud.DuplicateResult duplicateResult = duplicateError.getDuplicateResult();
                        Datacloud.MatchResult[] matchResults = duplicateResult.getMatchResults();
                        Datacloud.MatchResult matchResult = matchResults[0];
                        Datacloud.MatchRecord[] matchRecords = matchResult.getMatchRecords();
                        for (Datacloud.MatchRecord matchRecord : matchRecords) {
                            duplicateContract = (Contract)matchRecord.getRecord();
                        }
                        // If the duplicate rule is an alert rule, we can try to bypass it
                        dml.DuplicateRuleHeader.AllowSave = true;
                        Database.SaveResult saveResultAttempt2 = Database.insert(newContract, dml);
                        if (saveResultAttempt2.isSuccess()) {
                            System.Debug('--- InboundDataController - Duplicate Contract Created: '+newContract?.Id);
                            System.Debug('--- InboundDataController - Duplicate Contract Existing: '+duplicateContract?.Id);
                        }
                    }
                }else{
                    System.Debug('--- InboundDataController - New Contract Created: '+newContract?.Id);
                    
                }
            }
            return newContract;
        } catch (Exception e){
            return null;
        }
    }
    /**
    * @description Get the productData from orderData Object 
    * @author Henk Reynders | 09-06-2024 
    * @return InboundData.ProductData 
    **/
    public static InboundData.ProductData getProductData() {    
        productData = orderMessage.productData;
        System.Debug ('--- InboundDataController - getProductData: '+productData);
        return productData;
    } 
    /**
    * @description Get the products from productData Object 
    * @author Henk Reynders | 09-06-2024 
    * @return List<InboundData.Product>
    **/
    public static List<InboundData.Product> getProducts() {    
        products = productData.products;
        System.Debug ('--- InboundDataController - getProducts: '+products);
        return products;
    } 
    /**
    * @description Get the Building based on Account and Type or create new Building
    * @author Henk Reynders | 09-07-2024 
    * @return List<Asset> 
    **/
    public static Asset getBuildingAsset(Id assetId, Id accountId){
        Id buildingAssetRecordTypeId = Schema.SObjectType.Asset.getRecordTypeInfosByDeveloperName().get('Building').getRecordTypeId();
        Asset building = new Asset();
        List<Asset> buildings = new List<Asset>();
        if (String.IsNotBlank(accountId)){
            building = [SELECT Id, OwnerId,
                                Name, Description,
                                RecordTypeId,
                                Status,StatusReason,
                                RootAssetId,AssetLevel,ParentId,
                                AccountId,ContactId,
                                Address, LocationId,
                                ManufactureDate, InstallDate,
                                Product2Id,ProductCode, ProductDescription,
                                Quantity,Price, 
                                SerialNumber
                        FROM Asset 
                        WHERE Id =: assetId
                        AND AccountId =: accountId
                        AND RecordTypeId =: buildingAssetRecordTypeId
                        LIMIT 1];
        } else {
            building = setBuildingAsset();
        }      
        System.debug('--- InboundDataController - getBuildingAsset - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- InboundDataController - getBuildingAsset - SOQL USED: ' + LIMITS.getQueries());
        buildings = orderData.buildings;
        buildings.add(building);

        orderData.buildings = buildings;
        return building;
    }
    /**
    * @description Set the Building by creating new Building
    * @author Henk Reynders | 09-07-2024 
    * @return Asset
    **/
    public static Asset setBuildingAsset(){
        Id buildingAssetRecordTypeId = Schema.SObjectType.Asset.getRecordTypeInfosByDeveloperName().get('Building').getRecordTypeId();
        try{
            Asset newBuilding = new Asset();
            Asset duplicateBuilding = new Asset();
            // Salesforce Records
            Id accountId = getCustomerAccount()?.Id;
            newBuilding.RecordTypeId = buildingAssetRecordTypeId;
            //newBuilding.AddressCity = orderData.customerData.city;
            //newBuilding.LocationId = getLocation();
            if (newBuilding != NULL){
                Database.DMLOptions dml = new Database.DMLOptions(); 
                dml.DuplicateRuleHeader.allowSave = false;
                Database.SaveResult saveResultAttempt1 =  Database.insert(newBuilding,dml) ;
                if (!saveResultAttempt1.isSuccess()) {
                    List<Database.Error> error = saveResultAttempt1.getErrors();
                    System.Debug('--- InboundDataController - Database Error on Building Create : '+error[0] );
                    if (error[0] instanceof Database.DuplicateError) {
                        Database.DuplicateError duplicateError = (Database.DuplicateError)error[0];
                        Datacloud.DuplicateResult duplicateResult = duplicateError.getDuplicateResult();
                        Datacloud.MatchResult[] matchResults = duplicateResult.getMatchResults();
                        Datacloud.MatchResult matchResult = matchResults[0];
                        Datacloud.MatchRecord[] matchRecords = matchResult.getMatchRecords();
                        for (Datacloud.MatchRecord matchRecord : matchRecords) {
                            duplicateBuilding = (Asset)matchRecord.getRecord();
                        }
                        // If the duplicate rule is an alert rule, we can try to bypass it
                        dml.DuplicateRuleHeader.AllowSave = true;
                        Database.SaveResult saveResultAttempt2 = Database.insert(newBuilding, dml);
                        if (saveResultAttempt2.isSuccess()) {
                            System.Debug('--- InboundDataController - Duplicate Building Created: '+newBuilding?.Id);
                            System.Debug('--- InboundDataController - Duplicate Building Existing: '+duplicateBuilding?.Id);
                        }
                    }
                }else{
                    System.Debug('--- InboundDataController - New Building Created: '+newBuilding?.Id);
                    
                }
            }
            return newBuilding;
        } catch (Exception e){
            return null;
        }
    }
    /**
    * @description Set the Apartment by creating new Apartment
    * @author Henk Reynders | 09-07-2024 
    * @return Asset
    **/
    public static Asset setApartmentAsset(){
        Id ApartmentAssetRecordTypeId = Schema.SObjectType.Asset.getRecordTypeInfosByDeveloperName().get('Apartment').getRecordTypeId();
        try{
            Asset newApartment = new Asset();
            Asset duplicateApartment = new Asset();
            // Salesforce Records
            Id accountId = getCustomerAccount()?.Id;
            /*newApartment.RecordTypeId = ApartmentAssetRecordTypeId;
            //newApartment.Address = orderData.customerData.city;
            //newApartment.LocationId = getLocation();
            if (newApartment != NULL){
                Database.DMLOptions dml = new Database.DMLOptions(); 
                dml.DuplicateRuleHeader.allowSave = false;
                Database.SaveResult saveResultAttempt1 =  Database.insert(newApartment,dml) ;
                if (!saveResultAttempt1.isSuccess()) {
                    List<Database.Error> error = saveResultAttempt1.getErrors();
                    System.Debug('--- InboundDataController - Database Error on Apartment Create : '+error[0] );
                    if (error[0] instanceof Database.DuplicateError) {
                        Database.DuplicateError duplicateError = (Database.DuplicateError)error[0];
                        Datacloud.DuplicateResult duplicateResult = duplicateError.getDuplicateResult();
                        Datacloud.MatchResult[] matchResults = duplicateResult.getMatchResults();
                        Datacloud.MatchResult matchResult = matchResults[0];
                        Datacloud.MatchRecord[] matchRecords = matchResult.getMatchRecords();
                        for (Datacloud.MatchRecord matchRecord : matchRecords) {
                            duplicateApartment = (Asset)matchRecord.getRecord();
                        }
                        // If the duplicate rule is an alert rule, we can try to bypass it
                        dml.DuplicateRuleHeader.AllowSave = true;
                        Database.SaveResult saveResultAttempt2 = Database.insert(newApartment, dml);
                        if (saveResultAttempt2.isSuccess()) {
                            System.Debug('--- InboundDataController - Duplicate Apartment Created: '+newApartment?.Id);
                            System.Debug('--- InboundDataController - Duplicate Apartment Existing: '+duplicateApartment?.Id);
                        }
                    }
                }else{
                    System.Debug('--- InboundDataController - New Apartment Created: '+newApartment?.Id);
                    
                }
            }*/
            return newApartment;
        } catch (Exception e){
            return null;
        }
    }
    /**
    * @description Set the Plan by creating new Plan
    * @author Henk Reynders | 09-07-2024 
    * @return Asset
    **/
    public static Asset setPlanAsset(){
        Id planAssetRecordTypeId = Schema.SObjectType.Asset.getRecordTypeInfosByDeveloperName().get('Plan').getRecordTypeId();
        
        Asset newPlan = new Asset();
        Asset duplicatePlan = new Asset();
        try{           
            newPlan.RecordTypeId = planAssetRecordTypeId;
            //newPlan.Address = orderData.customerData.city;
            //newPlan.LocationId = getLocation();
            if (newPlan != NULL){
                Database.DMLOptions dml = new Database.DMLOptions(); 
                dml.DuplicateRuleHeader.allowSave = false;
                Database.SaveResult saveResultAttempt1 =  Database.insert(newPlan,dml) ;
                if (!saveResultAttempt1.isSuccess()) {
                    List<Database.Error> error = saveResultAttempt1.getErrors();
                    System.Debug('--- InboundDataController - Database Error on Plan Create : '+error[0] );
                    if (error[0] instanceof Database.DuplicateError) {
                        Database.DuplicateError duplicateError = (Database.DuplicateError)error[0];
                        Datacloud.DuplicateResult duplicateResult = duplicateError.getDuplicateResult();
                        Datacloud.MatchResult[] matchResults = duplicateResult.getMatchResults();
                        Datacloud.MatchResult matchResult = matchResults[0];
                        Datacloud.MatchRecord[] matchRecords = matchResult.getMatchRecords();
                        for (Datacloud.MatchRecord matchRecord : matchRecords) {
                            duplicatePlan = (Asset)matchRecord.getRecord();
                        }
                        // If the duplicate rule is an alert rule, we can try to bypass it
                        dml.DuplicateRuleHeader.AllowSave = true;
                        Database.SaveResult saveResultAttempt2 = Database.insert(newPlan, dml);
                        if (saveResultAttempt2.isSuccess()) {
                            System.Debug('--- InboundDataController - Duplicate Plan Created: '+newPlan?.Id);
                            System.Debug('--- InboundDataController - Duplicate Plan Existing: '+duplicatePlan?.Id);
                        }
                    }
                }else{
                    System.Debug('--- InboundDataController - New Plan Created: '+newPlan?.Id);
                    
                }
            }
            return newPlan;
        } catch (Exception e){
            return null;
        }
    }
    /**
    * @description Get Assets based on Account and Type or create new Building
    * @author Henk Reynders | 09-07-2024 
    * @return List<Asset> 
    **/
    public static Map<String,Asset> getProductAssets(){
        List<Asset> assets = new List<Asset>();
        List<Asset> products = new List<Asset>();
        Id accountId = customerData?.accountId;
        Map<String,Asset> productAssets = new Map<String,Asset>(); 
        if (String.IsNotBlank(accountId)){
            assets = [SELECT Id, OwnerId,
                                Name, Description,
                                RecordTypeId,
                                Status,StatusReason,
                                RootAssetId,AssetLevel,ParentId,
                                AccountId,ContactId,
                                Address, LocationId,
                                ManufactureDate, InstallDate,
                                Product2Id,ProductCode, ProductDescription,
                                Quantity,Price, 
                                SerialNumber
                        FROM Asset 
                        WHERE AccountId =: accountId
                        AND RecordTypeId =: productRecordTypeId];
        } 
        for (Asset asset : assets) {
            if (productAssets.containsKey(asset.SerialNumber)) {
            } else if (!productAssets.containsKey(asset.SerialNumber)) {
                productAssets.put(asset.SerialNumber,asset);
            }
        }
        System.debug('--- InboundDataController - getProductAssets - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- InboundDataController - getProductAssets - SOQL USED: ' + LIMITS.getQueries());
        products = orderData.products;
        products.addAll(assets);

        orderData.products = products;
        return productAssets;
    }
    /**
    * @description Set the Product by creating new Product
    * @author Henk Reynders | 09-07-2024 
    * @return Asset
    **/
    public static Asset setProductAsset(){
        Asset newProduct = new Asset();
        Asset duplicateProduct = new Asset();
        Id accountId = customerData?.accountId;
        try{    
            // Salesforce Records
           
            newProduct.RecordTypeId = productRecordTypeId;
            //newProduct.Address = orderData.customerData.city;
            //newProduct.LocationId = getLocation();
            if (newProduct != NULL){
                Database.DMLOptions dml = new Database.DMLOptions(); 
                dml.DuplicateRuleHeader.allowSave = false;
                Database.SaveResult saveResultAttempt1 =  Database.insert(newProduct,dml) ;
                if (!saveResultAttempt1.isSuccess()) {
                    List<Database.Error> error = saveResultAttempt1.getErrors();
                    System.Debug('--- InboundDataController - Database Error on Product Create : '+error[0] );
                    if (error[0] instanceof Database.DuplicateError) {
                        Database.DuplicateError duplicateError = (Database.DuplicateError)error[0];
                        Datacloud.DuplicateResult duplicateResult = duplicateError.getDuplicateResult();
                        Datacloud.MatchResult[] matchResults = duplicateResult.getMatchResults();
                        Datacloud.MatchResult matchResult = matchResults[0];
                        Datacloud.MatchRecord[] matchRecords = matchResult.getMatchRecords();
                        for (Datacloud.MatchRecord matchRecord : matchRecords) {
                            duplicateProduct = (Asset)matchRecord.getRecord();
                        }
                        // If the duplicate rule is an alert rule, we can try to bypass it
                        dml.DuplicateRuleHeader.AllowSave = true;
                        Database.SaveResult saveResultAttempt2 = Database.insert(newProduct, dml);
                        if (saveResultAttempt2.isSuccess()) {
                            System.Debug('--- InboundDataController - Duplicate Product Created: '+newProduct?.Id);
                            System.Debug('--- InboundDataController - Duplicate Product Existing: '+duplicateProduct?.Id);
                        }
                    }
                }else{
                    System.Debug('--- InboundDataController - New Product Created: '+newProduct?.Id);
                    
                }
            }
            return newProduct;
        } catch (Exception e){
            return null;
        }
    }
    /**
    * @description Set the Assets by creating new Assets
    * @author Henk Reynders | 09-07-2024 
    * @return List<Asset> 
    **/
    public static List<Asset> setProductAssets(){ 
        try{
            List<Asset> newProductAssets = new List<Asset>();
            List<Asset> duplicateAssets = new List<Asset>();
            // Salesforce Records
            Id accountId = customerData?.accountId;
            Id contactId = getContract()?.Id;
            Id salesUserId = getSalesUser()?.Id; // Better to add this attribute to rvn Product
            Id servicesUserId = getServicesUser()?.Id; // Better to add this attribute to rvn Product
            String projectNumber = getProjectNumber(); // Better to add this attribute to rvn Product
            String offerNumber = getOfferNumber(); // Better to add this attribute to rvn Product
            String assetType = 'Product';
            // AssetData
            //List<Asset> buildings = getBuildingAssets();
            //List<Asset> apartments = getApartmentAssets();
            //List<Asset> plans = getPlanAssets();
            //List<Asset> rvnProducts = getProductAssets();

            // Get data from Wrapper
            List<InboundData.Product> rvnProducts = productData.products;
            for (InboundData.Product rvnProduct : rvnProducts) {
                System.Debug('--- InboundDataController - Ordered RVN Product: '+rvnProduct);
                // Batch
                String deliveryBatch = rvnProduct.deliveryBatch;
                String deliveryStatus = rvnProduct.deliveryStatus;
                String orderDate = rvnProduct.orderDate;
                String deliveryDate = rvnProduct.deliveryDate;
                String batchIdentifier = projectNumber+' / '+offerNumber+'-'+deliveryBatch;
                System.Debug('--- InboundDataController - Batch: '+batchIdentifier);
                // Plan
                String planName = rvnProduct.planName; // Plan
                String planUnit = rvnProduct.planUnit; // Apartment
                String planLine = rvnProduct.planLine; // Apartment Attribute
                String planFloor = rvnProduct.planFloor; // Apartment Attribute
                String planIdentifier = batchIdentifier + '_'+planName + '_'+ planLine + '_'+ planFloor + '_'+planUnit;
                System.Debug('--- InboundDataController - Plan: '+planIdentifier);

                // Product
                String productCode = rvnProduct.productCode; // Product 
                String productName = rvnProduct.productName;
                String quantity = rvnProduct.quantity; 
                String serialNumber = rvnProduct.serialNumber;
                String originalSerialnumber = rvnProduct.originalSerialnumber;
                String productIdentifier = productName + '_'+ productCode + '_'+serialNumber;
                System.Debug('--- InboundDataController - Product: '+productIdentifier);
                // Delivery
                String additionalTime = rvnProduct.additionalTime;
                String process = rvnProduct.process;		
                String warehouseCode = rvnProduct.warehouseCode;
                String packingOrder = rvnProduct.packingOrder;

                // Installation 
                String attachment = rvnProduct.attachment;
                String installed = rvnProduct.installed;
                String axConfiguration = rvnProduct.axConfiguration;
                String installationStart = rvnProduct.installationStart;
                String installationEnd = rvnProduct.installationEnd;

                // Invoicing
                String chargeable = rvnProduct.chargeable;
                String salesPrice = rvnProduct.salesPrice;
                String sproduct = rvnProduct.sProduct;
                String sfreight = rvnProduct.sfreight;
                String sinstall = rvnProduct.sinstall;
                String sother = rvnProduct.sother;
                String purchasePrice = rvnProduct.purchasePrice;
                String pproduct = rvnProduct.pproduct;
                String pfreight = rvnProduct.pfreight;
                String pinstall = rvnProduct.pinstall;
                String pother = rvnProduct.pother;		
                String factoryPrice = rvnProduct.factoryPrice;
                String fproduct = rvnProduct.fproduct;
                String ffreight = rvnProduct.ffreight;
                String finstall = rvnProduct.finstall;
                String fother = rvnProduct.fother;
                String subTotal = rvnProduct.subTotal;
                String contractedPrice = rvnProduct.contractedPrice;
                // Product Statistics
                Decimal glassSurface = decimal.valueOf(rvnProduct.glass_m2);
                Decimal blindsSurface = decimal.valueOf(rvnProduct.blinds_m2);
                Integer glassAmount = integer.valueOf(rvnProduct.glass_pcs);
                Integer productLength = integer.valueOf(rvnProduct.product_mm);
                Decimal productWeight = decimal.valueOf(rvnProduct.product_kg);

                switch on assetType {
                    when 'Product' { // Product Asset
                        Asset newProductAsset = new Asset(); 
                        //newProductAsset.Name;
                        newProductAsset.RecordTypeId = productRecordTypeId;
                        newProductAsset.Status = 'Measured';
                        newProductAsset.Description = ('RVN: '+serialNumber+ ' \r\n' 
                                                        +'Product: '+productName + ' \r\n'        
                                                        +'Glass:' + glassSurface +'m2'+ ' \r\n' 
                                                        +'Blinds:' +blindsSurface +'m2'+ ' \r\n' 
                                                        +'Glass Count:' + glassAmount +'pcs' + ' \r\n' 
                                                        +'Lenght :'+ productLength + 'mm'+ ' \r\n' 
                                                        +'Weight :'+ productWeight + 'kg'+ ' \r\n');   
                        newProductAsset.NumberOfGlassPanels__c = glassAmount;
                        newProductAsset.ProductName__c = productName;
                        newProductAsset.SerialNumber = serialNumber;
                        newProductAsset.GlassSurface__c = glassSurface;
                        newProductAsset.BlindsSurface__c = blindsSurface;
                        newProductAsset.ProductLength__c = productLength;
                        newProductAsset.ProductWeight__c = productWeight;                                 
                        //ProductAttribute attribute = rvnProduct.productCode;
                        //Service service = rvnProduct.productCode;
                        //public Instruction instruction = rvnProduct.productCode;
                        //newProductAsset.AssetServicedBy;
                        //newProductAsset.LocationId;
                        //newProductAsset.AccountId = serialNumber;
                        //newProductAsset.ContactId = serialNumber;
                        //newProductAsset.ParentId;
                        //newProductAsset.Price;
                        //newProductAsset.Product2Id;
                        //newProductAsset.Quantity = quantity;
                        newProductAsset.SerialNumber = serialNumber;
                        newProductAsset.ExternalIdentifier = serialNumber;
                        //newProductAsset.InstallDate = serialNumber;
                        //newProductAsset.ManufactureData = serialNumber;
                        //newProductAsset.isMigrated__c = true;
                        //newProductAsset.addressStreet = true;
                        //newProductAsset.addressPostalCode = true;
                        //newProductAsset.addressCity = true;
                        //newProductAsset.addressCountry = true;
                        newProductAssets.add(newProductAsset);

                    }
                    when else {

                    }   

                }
            }            
            if (newProductAssets.size()>0){
                List<Datacloud.FindDuplicatesResult> duplicates = Datacloud.FindDuplicates.findDuplicates(newProductAssets);
                if(duplicates.size() == 0) { 
                    insert newProductAssets;
                }
            }   
            return newProductAssets;
        } catch (Exception e){
            return null;
        }
    }
    /**
    * @description Set the values for each of the Inner Classes of the Wrapper
    * @author Henk Reynders | 09-06-2024 
    * @param inboundJson 
    **/
    public static void prepareData(String inboundJson){
        // Do not Process Delivery Only Orders
        orderMessage =  getOrderMessage(inboundJson);
        
        getCustomerData();
        
        getCustomerAccount();
        getOpportunity();        
        getQuote();
        getContract();
        getProductAssets();
        /*System.debug('--- InboundDataController - Process OrderMessage: '+orderMessage);
        customerAccount = checkCustomerRecord(orderData);
        System.debug('--- InboundDataController - customerAccount: '+customerAccount);
        if(customerAccount != NULL){
            opportunity = checkOpportunityRecord(orderData, customerAccount);
            System.debug('--- InboundDataController - opportunity: '+opportunity);
        }
        Delivery_Batch__c newDeliveryBatch = new Delivery_Batch__c();
        WorkOrder newWorkOrder = new WorkOrder();
        List<WorkOrderLineItem> newWorkOrderLineItems = new List<WorkOrderLineItem>();
        List<Id> newWorkOrderLineItemsIds = new List<Id>();
        Map<String,ContentDocumentLink> installationDocumentsMap = new Map<String,ContentDocumentLink>();
        if(opportunity != NULL && customerAccount != NULL){
            newDeliveryBatch = createDeliveryBatch(orderData,customerAccount,opportunity);
            System.debug('--- InboundDataController - deliveryBatch: '+newDeliveryBatch);
        }
        if (opportunity != NULL && customerAccount != NULL && newDeliveryBatch != NULL){ 
            manageConfigurationPlanAndProduct(orderData,customerAccount,opportunity,newDeliveryBatch);    
            newWorkOrder = createWorkOrder(orderData,customerAccount, opportunity, newDeliveryBatch);
            System.debug('--- InboundDataController - workOrder: '+newWorkOrder);
            newWorkOrderLineItems =  createWorkOrderLines( orderData, newWorkOrder, newDeliveryBatch);
            System.debug('--- InboundDataController - new workOrderlineItem Count: '+newWorkOrderLineItems.size());
            newWorkOrderLineItemsIds = new List<Id>(new Map<Id, WorkOrderLineItem>(newWorkOrderLineItems).keySet());
            installationDocumentsMap = getExistingInstallationPDFFiles(newWorkOrderLineItemsIds);
            System.debug('--- InboundDataController - existing Document Count: '+installationDocumentsMap.keyset().size());
            createInstallationPDFFiles(orderData,installationDocumentsMap,newWorkOrderLineItems); 
        }*/
        
    }
    /*
    // Method to create work order
    public static WorkOrder createWorkOrder(InboundData.Order orderData,  Account customerAccount, Opportunity opportunity,  Delivery_Batch__c deliveryBatch){
        WorkOrder newWorkOrder = new WorkOrder();
        newWorkOrder.AccountId = customerAccount.Id;
        newWorkOrder.Opportunity__c = opportunity.Id;

        //newWorkOrder.ProfitCenter__c = orderData.business_unit;//"business_unit": "401",
        // newWorkOrder.CustomerSegment__c = orderData.customer_segmentid; //"customer_segmentid": "1000",
        newWorkOrder.CountryCode = countryMap.get(installationData.country).CountryCodeAlpha2__c;// "FIN"
        //newWorkOrder.Quote__c = quoteRec.Id;
        //newWorkOrder.Delivery_Batch__c = deliveryBatch.Id;
        //newWorkOrder.IsMigrated__c =true;        
        //newWorkOrder.IsIntegrationData__c =true;
        newWorkOrder.OwnerId = servicesUser != NULL ? servicesUser.Id : UserInfo.getUserId();
        //newWorkOrder.SalesToriUniqueKey__c = deliveryBatch.SalesToriUniqueKey__c;
        if (orderData.itemData != NULL && orderData.itemData.products.size()>0) {
            newWorkOrder.Soft_Reserved_Date__c  = Date.parse(orderData.itemData.products[0].install_start_date);
            newWorkOrder.StartDate = Date.parse(orderData.itemData.products[0].install_start_date);
            newWorkOrder.EndDate = Date.parse(orderData.itemData.products[0].install_end_date);
        }
        newWorkOrder.City = installationData.city;
        newWorkOrder.Country = countryMap.get(installationData.country).Country_Name__c ;
        newWorkOrder.PostalCode = String.valueOf(installationData.postalCode);
        newWorkOrder.Street = installationData.street;
        database.upsert(newWorkOrder,WorkOrder.SalesToriUniqueKey__c);
        System.debug('--- InboundDataController - createWorkOrder newWorkOrder: '+newWorkOrder);
        return newWorkOrder;
    }
        
    public static List<WorkOrderLineItem> createWorkOrderLines(InboundData.Order orderData, WorkOrder workRec, Delivery_Batch__c deliveryBatch){
        Map<String, WorkOrderLineItem> workOrderLineMaps = getExisitingWorkOrderLines(deliveryBatch.SalesToriUniqueKey__c);
        List<WorkOrderLineItem> workOrderLineListToUpdate = new List<WorkOrderLineItem>();
        if (orderData.itemData != NULL && orderData.itemData.products.size()>0) {
            for(InboundData.GroupRec lineItem: orderData.itemData.products){
                // NEW 09.08.2024 Store the path and installation File Name to WOLI
                String remoteFile = lineItem.AssemblyInstructions.Attachments.Attachment;
                String remoteFolder = lineItem.AssemblyInstructions.Attachments.Folder;

                WorkOrderLineItem workLineRec = new WorkOrderLineItem();
                workLineRec.WorkOrderId = workRec.Id;
                Configuration_Product__c configProduct = new Configuration_Product__c(RVN_Number__c = String.valueOf(lineItem.OrderLine.BOMVersion));
                WorkType wType = [SELECT Id,Type__c from WorkType where Type__c = 'New Product installation' limit 1]; 
                workLineRec.Configuration_Product__r = configProduct;
                //workLineRec.Line__c = String.valueof(lineItem.OrderLine.Line);
                //workLineRec.Floor__c = !String.isBlank(lineItem.OrderLine.Floor) ? Integer.valueOf(lineItem.OrderLine.Floor) : 0 ;
                //workLineRec.Apartment_Number__c = lineItem.OrderLine.Apartment;
                workLineRec.RVN_Number__c  = String.valueOf(lineItem.OrderLine.BOMVersion);

                
                
                workLineRec.Is_installable__c  = TRUE;
                workLineRec.WorkTypeId = wType.Id;
                workLineRec.Duration = Decimal.valueOf(lineItem.OrderLine.InstallHours);
                workLineRec.DurationType = 'Minutes';
                workLineRec.StartDate  = Date.parse(lineItem.install_start_date);
                workLineRec.EndDate  = Date.parse(lineItem.install_end_date);
                // NEW 09.08.2024 Details for Installation Card
                workLineRec.RVN__c  = String.isNotBlank(String.valueOf(lineItem.OrderLine.BOMVersion)) ? String.valueOf(lineItem.OrderLine.BOMVersion) :'';
                workLineRec.RemoteFile__c  = String.isNotBlank(remoteFile) ? remoteFile : '';
                workLineRec.RemoteFolder__c  = String.isNotBlank(remoteFolder) ? remoteFolder.replace('\\', '\\'+'\\') : '';
                if(workOrderLineMaps.containsKey(lineItem.OrderLine.BOMVersion)){
                    workLineRec.Id = workOrderLineMaps.get(lineItem.OrderLine.BOMVersion).Id;
                }
                workLineRec.Description = lineItem.AssemblyInstructions.InstallNotes;
                workOrderLineListToUpdate.add(workLineRec);
            }
        }
        Database.UpsertResult[] saveResult = Database.upsert(workOrderLineListToUpdate,false) ;
        for (Database.UpsertResult sr : saveResult) {
            if(sr.isSuccess()){
                deliveryBatch.Batch_Status__c = 'Data imported';
            }else{
                deliveryBatch.Batch_Status__c = 'New';
            }
        }
        update deliveryBatch;
        return workOrderLineListToUpdate;
    }
	public static void createInstallationPDFFiles(InboundData.Order orderData, Map<String,ContentDocumentLink> installationDocumentsMap, List<WorkOrderLineItem> woliList){
        
        // If the incoming file name already exists in the existing PDF then the file already exists in the system
        // Next step is to check is this file already part of a WOLI. If so is it the right WOLI ?
        //Map<Id,WorkOrderLineItem> woliListMap = new Map<Id,WorkOrderLineItem>(
            									//[SELECT Id,Configuration_Product__r.RVN_Number__c
                                                 //FROM WorkOrderLineItem 
                                                 //WHERE Id IN : woliList limit 1000]);
        
        
        List<ContentVersion> documentsToUpsert = new List<ContentVersion>();
        Set<String> fileNames = new Set<String>();
        if (orderData.itemData != NULL && orderData.itemData.products.size()>0) {
        	for(InboundData.GroupRec lineItem: orderData.itemData.products){
                String attachment = lineItem.AssemblyInstructions.Attachments.Attachment;
                String rvn = attachment.substringBefore('.pdf');
                rvn = rvn.RIGHT(16);
                for(WorkOrderLineItem wl : woliList){
                    if(wl.RVN_Number__c  == rvn){
                    if(installationDocumentsMap.keyset().contains(lineItem.AssemblyInstructions.Attachments.Attachment)){
                            ContentVersion cv = new ContentVersion();
                            cv.Title = attachment;
                            cv.ContentLocation= 's';
                            cv.ContentDocumentId = installationDocumentsMap.get(attachment).ContentDocumentId;
                            cv.PathOnClient= attachment;
                            cv.VersionData = Blob.valueOf('test');
                            //cv.RVN_Number__c = rvn;
                            fileNames.add(rvn);
                            documentsToUpsert.add(cv);
                            // createInstallationPDFFiles(lineItem,installationDocumentsMap, woliList);
                        }else {
                            ContentVersion cv = new ContentVersion();
                            cv.Title = attachment;
                            cv.ContentLocation= 's';
                            cv.PathOnClient= attachment;
                            cv.VersionData = Blob.valueOf('test');
                            //cv.RVN_Number__c = rvn;
                            fileNames.add(rvn);
                            documentsToUpsert.add(cv);
                        } 
                    }
                }
            }
        }
        List<Database.UpsertResult> upsertContentForIC = Database.upsert(documentsToUpsert);
        System.debug('--- InboundDataController - createInstallationPDFFiles - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- InboundDataController - createInstallationPDFFiles - SOQL USED: ' + LIMITS.getQueries());
        List<ContentVersion> docs = [SELECT ContentDocumentId, Title, PathOnClient,RVN_Number__c FROM ContentVersion WHERE RVN_Number__c IN: fileNames and IsLatest = TRUE];
        
        List<ContentDocumentLink> contDocLinks = new List<ContentDocumentLink>();
        Map<Id,ContentDocumentLink> cdlMap = new Map<Id,ContentDocumentLink>();
        Map<String,WorkOrderLineItem> woliMap = new Map<String,WorkOrderLineItem>();
        
        Set<Id> conDocIds = new Set<Id>();
        for(ContentVersion cv1 : docs){
            conDocIds.add(cv1.ContentDocumentId);
        }
        
        // Get the content versions that has been upserted
        // Get contentdocumentlinks for that contentdocumentids
        // Store them in a map with contentdocumentid, rvn
        // If there is an existing cdl then no actions needed for that contentdocument
        // If there is no existing cdl then new cdl has to be created where the content version will be linked to the WOLI for that rvn
        if (conDocIds.size() > 0) {
            List<ContentDocumentLink> documentLinks = [SELECT ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE ContentDocumentId IN:conDocIds and LinkedEntityId in ( SELECT Id FROM WorkOrderLineItem)];
            List<WorkOrderLineItem> woliItems = [SELECT Id,RVN_Number__c FROM WorkOrderLineItem WHERE RVN_Number__c IN: fileNames];
            for(ContentDocumentLink cdl : documentLinks){
                cdlMap.put(cdl.ContentDocumentId,cdl);
            }
            for(WorkOrderLineItem wli : woliItems){
                woliMap.put(wli.RVN_Number__c,wli);
            }
			          
            for (ContentVersion statsFile : docs) {
                if(cdlMap.keyset().contains(statsFile.ContentDocumentId) && !(String.valueOf(cdlMap.get(statsFile.ContentDocumentId).LinkedEntityId).startsWith('005'))){
                    System.debug('--- InboundDataController - Content Document Link already exists');
                }else{
                    //if(woliMap.keyset().contains(statsFile.RVN_Number__c)){
                    //    contDocLinks.add(new ContentDocumentLink(ContentDocumentId = statsFile.ContentDocumentId, ShareType = 'V', LinkedEntityId = woliMap.get(statsFile.RVN_Number__c).Id));
                    //}
                }
            }
        }
        
        if (!contDocLinks.isEmpty()) {
            upsert contDocLinks;
        }
        System.debug('--- InboundDataController - createInstallationPDFFiles - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- InboundDataController - createInstallationPDFFiles - SOQL USED: ' + LIMITS.getQueries());
    } 
    public static Delivery_Batch__c createDeliveryBatch(InboundData.Order orderData, Account customerAccount, Opportunity opportunity){
        Delivery_Batch__c  deliveryBatch = new Delivery_Batch__c();
        String salesToriOrderNumber;
        String salesToriBatchNumber;
        String salesToriKey;
        if (opportunity != null &&  customerAccount != null) {
            deliveryBatch.Account__c = customerAccount.Id;
            deliveryBatch.Opportunity__c = opportunity.Id;
            deliveryBatch.Batch_Name__c = installationData.street; 
            deliveryBatch.Planned_Installation_Address__City__s = installationData.city;
            deliveryBatch.Planned_Installation_Address__PostalCode__s = String.valueOf(installationData.postalCode);
            deliveryBatch.Planned_Installation_Address__Street__s = installationData.street;        
            //deliveryBatch.Installation_address__CountryCode__s = countryMap.get(installationData.country);
            deliveryBatch.OwnerId = servicesUser != NULL ? servicesUser.Id : UserInfo.getUserId();
            if(orderData.itemData != NULL && orderData.itemData.products.size() > 0 ){
                deliveryBatch.Batch_Id__c = orderData.itemData.grouplist[0].OrderLine.DlvBatchID;
                System.Debug('--- InboundDataController - batchId: '+orderData.itemData.grouplist[0].OrderLine.DlvBatchID);          
                deliveryBatch.Batch_number__c = Integer.valueOf(orderData.itemData.grouplist[0].delivery_batch);
                System.Debug('--- InboundDataController - batchNumber: '+orderData.itemData.grouplist[0].delivery_batch);
                //deliveryBatch.Batch_Name__c = orderData.itemData.grouplist[0].salestori_plan_name;
                //System.Debug('--- InboundDataController - planName: '+orderData.itemData.grouplist[0].salestori_plan_name);
                System.Debug('--- InboundDataController - orderNumber: '+String.valueOf(orderData.order_number));
                salesToriBatchNumber = orderData.order_number + '_'+orderData.itemData.grouplist[0].delivery_batch;
                
                deliveryBatch.Planned_installation_start_date__c  = Date.parse(orderData.itemData.products[0].install_start_date);
                deliveryBatch.Planned_installation_end_date__c  = Date.parse(orderData.itemData.products[0].install_end_date);
                deliveryBatch.Planned_delivery_date__c  = Date.parse(orderData.itemData.products[0].delivery_batch_delivery_date);
            
            } else {
                salesToriBatchNumber = String.ValueOf(0);
            }
            salesToriOrderNumber = String.valueOf(orderData.order_number);
            salesToriKey = salesToriOrderNumber+salesToriBatchNumber;
            deliveryBatch.SalesToriUniqueKey__c = salesToriKey;
            System.Debug('--- InboundDataController - batch to Upsert: '+deliveryBatch);
            System.Debug('--- InboundDataController - batch Identifier: '+salesToriKey);
            Database.UpsertResult upsertResult = Database.upsert(deliveryBatch, Delivery_Batch__c.SalesToriUniqueKey__c);
        }
        System.debug('--- InboundDataController - createDeliveryBatch - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- InboundDataController - createDeliveryBatch - SOQL USED: ' + LIMITS.getQueries());
        return deliveryBatch;
    }
    
    public static void manageConfigurationPlanAndProduct(InboundData.Order orderData, Account customerAccount, Opportunity opportunity, Delivery_Batch__c deliveryBatch){
        List<String> configProdsToBeDeleted = new List<String>();
        List<configuration__c> configurationPlanList = new List<configuration__c>();
        List<Configuration_Product__c> configurationProductList = new List<Configuration_Product__c>();
        
        String offerNumber = orderData?.orderData?.order_number;
        Map<String,List<String>>  cfgPlanMap = getExisitingConfigPlanMap(offerNumber);
        
        
        System.Debug('--- InboundDataController - account : '+customerAccount?.Id);
        System.Debug('--- InboundDataController - opportunity : '+opportunity?.Id);
        System.Debug('--- InboundDataController - offer : '+offerNumber);
        System.Debug('--- InboundDataController - batch : '+deliveryBatch?.Batch_Id__c);
        System.Debug('--- InboundDataController - lineItems : '+lineItemList[0]);        
        System.Debug('--- InboundDataController - '+cfgPlanMap?.keySet().size()+' Existing Configuration Plans');
        
        Map<String, List<InboundData.GroupRec>> configMap = getConfigurationPlanMap(orderData);
        System.Debug('--- InboundDataController - Configuration Key Count : '+configMap.keySet().size());
        for(String configKey: configMap.keySet()){
            System.Debug('--- InboundDataController - Configuration Key : '+configKey);
            List<String> rvns = new List<String>();
            if(!cfgPlanMap.containsKey(configKey)){
                rvns = cfgPlanMap.get(configKey);
                cfgPlanMap.remove(configKey);
            }
            
            List<InboundData.GroupRec> lineItemList =  configMap.get(configKey);

            configuration__c cfgPlan = prepareConfigurationPlan(lineItemList[0],configKey, customerAccount, opportunity, deliveryBatch);
            if (cfgplan != NULL) {
                System.Debug('--- InboundDataController - prepared Plan : '+cfgPlan);
                configurationPlanList.add(prepareConfigurationPlan(lineItemList[0],configKey, customerAccount, opportunity, deliveryBatch));            
                for(InboundData.GroupRec lineItem :lineItemList ){
                    Configuration_Product__c cfgProduct = prepareConfigurationProducts(lineItem ,configKey, rvns);
                    if (cfgProduct != NULL) {
                        configurationProductList.add(cfgProduct);
                    }
                }
                configProdsToBeDeleted.addAll(rvns);
            }
        }
        // Why REMOVE everything first?
        
        List<Configuration_Product__c> configurationProducts =[SELECT id,Name from Configuration_Product__c where RVN_Number__c IN:configProdsToBeDeleted];
        delete configurationProducts;
        
        List<Configuration__c> configurationPlans =[SELECT id,Name,SalesToriConfigKey__c from Configuration__c where SalesToriConfigKey__c IN:cfgPlanMap.keySet()];
        delete configurationPlans;
        System.Debug('--- InboundDataController - plans to Upsert : '+configurationPlanList);
        System.Debug('--- InboundDataController - products to Upsert : '+configurationProductList);
        //List<Database.upsertResult> upsertConfigPlanResult = Database.upsert(configurationPlanList, configuration__c.SalesToriConfigKey__c);
        for ( Configuration_Product__c cfgProduct : configurationProductList){
            System.Debug('--- InboundDataController - product to Upsert : '+cfgProduct);
        }
        List<Database.upsertResult> upsertConfigProdResult = Database.upsert(configurationProductList, Configuration_Product__c.RVN_Number__c);
        System.debug('--- InboundDataController - manageConfigurationPlanAndProduct - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- InboundDataController - manageConfigurationPlanAndProduct - SOQL USED: ' + LIMITS.getQueries());
        
    }
    
    public static void getExistingContent(List<Configuration_Product__c> configurationProductList){
        Set<Id> configProdIds = new Set<Id>();
        Map<String,Id> fileToRVN = new Map<String,Id>();
        for(Configuration_Product__c cp : configurationProductList){
            configProdIds.add(cp.Id);
        }
        List<ContentDocumentLink> cdlsForRVNs = [SELECT ContentDocumentId,ContentDocument.title, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId IN :configProdIds];
        if(cdlsForRVNs.size() > 0){
           for (ContentDocumentLink cdlRVN : cdlsForRVNs) {
                fileToRVN.put(cdlRVN.ContentDocument.title, cdlRVN.LinkedEntityId);
            }
        }
        
        
    }
    // Method to create configuration Plan
    public static Map<String, List<InboundData.GroupRec>> getConfigurationPlanMap(InboundData.Order orderData){
        Map<String, List<InboundData.GroupRec>> configMap = new Map<String, List<InboundData.GroupRec>>();
        if (orderData?.itemData != NULL && orderData?.itemData?.products?.size()>0) {
            for(InboundData.GroupRec lineItem: orderData.itemData.products){

                String uniqueKey = orderData.order_number+lineItem.delivery_batch+lineItem.salestori_plan_name+lineItem.unit+lineItem.line+lineItem.floor;
                System.Debug('--- InboundDataController - Configuration Plan Map Entry: '+uniqueKey);
                if(!configMap.containsKey(uniqueKey)){
                    configMap.put(uniqueKey, new List<InboundData.GroupRec>{lineItem});
                }else{
                    configMap.get(uniqueKey).add(lineItem);
                }
            }
        }
        return configMap;
    }
    // Method to create configurationPlan
    public static configuration__c prepareConfigurationPlan(InboundData.GroupRec lineItem, String uniqueKey, Account customerAccount, Opportunity opportunity, Delivery_Batch__c deliveryBatch){
        System.Debug('--- InboundDataController - find Configuration Plan for Configuration Product');
        configuration__c newConfiguration = new configuration__c();
        newConfiguration.Account__c = customerAccount.Id;
        
        newConfiguration.Opportunity__c = opportunity.Id;
        //newConfiguration.DeliveryBatch__c= deliveryBatch.Id;
        //newConfiguration.DeliveryBatchNumber__c= deliveryBatch.Batch_number__c ;
        //newConfiguration.SalesToriConfigKey__c = uniqueKey;
        newConfiguration.OwnerId = salesPerson != NULL ? salesPerson.Id : UserInfo.getUserId();
        //newConfiguration.PlanName__c = lineItem.salestori_plan_name;
        newConfiguration.Line__c =  String.valueOf(lineItem.OrderLine.Line);
        newConfiguration.Floor__c  = String.valueOf(lineItem.OrderLine.Floor);
        //newConfiguration.ApartmentUnit__c  = lineItem.OrderLine.Apartment;
        System.Debug('--- InboundDataController - Configuration Plan Name: '+newConfiguration.PlanName__c);
        System.Debug('--- InboundDataController - Configuration Plan Floor: '+newConfiguration.Floor__c);
        System.Debug('--- InboundDataController - Configuration Plan Line: '+newConfiguration.Line__c);
        System.Debug('--- InboundDataController - Configuration Plan Unit: '+newConfiguration.ApartmentUnit__c);

        return newConfiguration;
    }
    
    
    // Method to create configuration product
    public static Configuration_Product__c prepareConfigurationProducts(InboundData.GroupRec lineItem, String configurationKey, List<String> rvnList){     
        Configuration_Product__c  configProdRec = new Configuration_Product__c ();
        Configuration__c configurationRec = new Configuration__c(SalesToriConfigKey__c = configurationKey);
        configProdRec.Configuration__r = configurationRec;
        //Product2 productRec = new Product2(Sales_Code__c= String.valueOf(lineItem.OrderLine.ItemID)); 

        // PROBLEM -- this is called too Often 
        Product2 productRec;// = [SELECT Id,Name,Product_Group__c from Product2 where Sales_Code__c = : String.valueOf(lineItem.OrderLine.ItemID) limit 1];
        
        if(productRec != NULL){
            configProdRec.Product__c = productRec.Id;
            configProdRec.Name = productRec.Name;
            configProdRec.Product_Group__c = productRec.Product_Group__c;
            configProdRec.Delivery_Batch_Number__c = String.isNotBlank(lineItem.delivery_batch) ? Integer.valueOf(lineItem.delivery_batch): 0;
        }
        configProdRec.Quantity__c   = 1.00;
        configProdRec.RVN_Number__c = String.valueOf(lineItem.OrderLine.BOMVersion);
        String installationProduct = String.isNotBlank(lineItem.OrderLine.BOMVersion) ? lineItem.OrderLine.BOMVersion: '';
        System.Debug('--- InboundDataController - installationProduct: '+installationProduct);
        
        if(rvnList?.size()>0){
            System.Debug('--- InboundDataController - rvnList: '+rvnList);
            if (rvnList.contains(installationProduct)){
                rvnList.remove(rvnList.indexOf(installationProduct));
            }
        } else {
            
        }
        return configProdRec;
    }

    
    
    public static Map<String,List<String>> getExisitingConfigPlanMap(String orderNumber){
        Map<String,List<String>> exsistingConfigProdMap = new Map<String,List<String>>();
        List<Configuration__c> configurationRecords = [SELECT Id,Name,Opportunity__c,Opportunity__r.order_number__c,SalesToriConfigKey__c,
                                                       (SELECT ID,Name,RVN_Number__c FROM configuration_Products__r) 
                                                       FROM Configuration__c  WHERE Opportunity__r.order_number__c != null ];
        
        for(Configuration__c configPlan: configurationRecords){
            List<String> productRvns = new List<String>();
            for(configuration_Product__c configProd:  configPlan.configuration_Products__r){
                productRvns.add(configProd.RVN_Number__c);
            }
            exsistingConfigProdMap.put(configPlan.SalesToriConfigKey__c, productRvns);
        }
        return exsistingConfigProdMap;
    }
    
    public static Map<String, WorkOrderLineItem> getExisitingWorkOrderLines(String salesToriKey){
        Map<String, WorkOrderLineItem> workOrderLineItemMap = new  Map<String, WorkOrderLineItem>();
        List<WorkOrderLineItem> workOrderLineItems = [SELECT Id, Configuration_Product__c,Configuration_Product__r.RVN_Number__c,
                                                      WorkOrder.SalesToriUniqueKey__c, WorkOrderId, WorkOrder.Delivery_Batch__r.SalesToriUniqueKey__c  
                                                      FROM WorkOrderLineItem WHERE WorkOrder.Delivery_Batch__r.SalesToriUniqueKey__c =:salesToriKey];
        
        for(WorkOrderLineItem workLineRec : workOrderLineItems){
            if(workLineRec.Configuration_Product__c != null && workLineRec.Configuration_Product__r.RVN_Number__c != null
               && !workOrderLineItemMap.containsKey(workLineRec.Configuration_Product__r.RVN_Number__c)){
                   workOrderLineItemMap.put(workLineRec.Configuration_Product__r.RVN_Number__c, workLineRec);
               }
        }
        return workOrderLineItemMap;
    }
    
    public static Account getCustomerRecord(String accountNumber){
        List<Account> customerAccount = [SELECT Id,Name,AccountNumber,IsPersonAccount FROM Account Where AccountNumber =:accountNumber LIMIT 1 ];
        if(customerAccount.size() >0){
            return customerAccount[0];
        }else{
            return null;
        }
    }
    
    public static Account createAccountRecord(InboundData.Customer_address custAddress){
        System.Debug('--- InboundDataController - Create Account from : '+custAddress);
        try{
            Account newPersonAccount = new Account();
            Account duplicateAccount = new Account();
            Account customerAccount = new Account();
            newPersonAccount.RecordTypeID = B2CAccountRecordTypeId;
            System.Debug('--- InboundDataController - Person Account Record Type : '+newPersonAccount.RecordTypeID);
            System.Debug('--- InboundDataController - Create Person Account with First Name: '+custAddress.firstname);
            System.Debug('--- InboundDataController - Create Person Account with Last Name: '+custAddress.lastname);
            newPersonAccount.FirstName= custAddress.firstname;
            newPersonAccount.LastName= custAddress.lastname;

            newPersonAccount.PersonEmail= custAddress.email;
            newPersonAccount.PersonMobilePhone = custAddress.phone_number;

            newPersonAccount.PersonLeadSource = leadSource; 
            newPersonAccount.CurrencyIsoCode = currencyCode;
            newPersonAccount.OwnerId = salesPerson != NULL ? salesPerson.Id : UserInfo.getUserId();

            newPersonAccount.PersonMailingCity= custAddress.city;
            newPersonAccount.PersonMailingCountryCode = countryMap.get(custAddress.country).CountryCodeAlpha2__c;
            newPersonAccount.PersonMailingPostalCode = custAddress.postalCode;
            newPersonAccount.PersonMailingStreet= custAddress.street;
            
            //District__c = custAddress.city,
            // FI from maintori should be converted to fi_FI
            //newPersonAccount.Language_Preference__c = langPrefered;

            newPersonAccount.Business_Type__c = '1';// Changed from 'Consumer' to '1'nsumer';                
            
            System.Debug('--- InboundDataController - Account to Create : '+newPersonAccount);
            Database.DMLOptions dml = new Database.DMLOptions(); 
            dml.DuplicateRuleHeader.allowSave = false;
            Database.SaveResult saveResultAttempt1 =  Database.insert(newPersonAccount,dml) ;
           	if (!saveResultAttempt1.isSuccess()) {
                List<Database.Error> error = saveResultAttempt1.getErrors();
                System.Debug('--- InboundDataController - Database Error on Account Create : '+error[0] );
                if (error[0] instanceof Database.DuplicateError) {
                    Database.DuplicateError duplicateError = (Database.DuplicateError)error[0];
                    Datacloud.DuplicateResult duplicateResult = duplicateError.getDuplicateResult();
                    Datacloud.MatchResult[] matchResults = duplicateResult.getMatchResults();
                    Datacloud.MatchResult matchResult = matchResults[0];
                    Datacloud.MatchRecord[] matchRecords = matchResult.getMatchRecords();
                    for (Datacloud.MatchRecord matchRecord : matchRecords) {
                        duplicateAccount = (Account)matchRecord.getRecord();
                    }
                    // If the duplicate rule is an alert rule, we can try to bypass it
                    dml.DuplicateRuleHeader.AllowSave = true;
                    Database.SaveResult saveResultAttempt2 = Database.insert(newPersonAccount, dml);
                    if (saveResultAttempt2.isSuccess()) {
                        System.Debug('--- InboundDataController - Duplicate Account Created: '+newPersonAccount?.Id);
                        System.Debug('--- InboundDataController - Duplicate Account Existing: '+duplicateAccount?.Id);
                    }
                }
            }else{
                System.Debug('--- InboundDataController - Created Account : '+newPersonAccount?.Id);
                
            }
            return newPersonAccount;
        }catch(Exception e){
            return null;
        }
    }
    
    public static Opportunity getOpportunityRecord(String orderNumber){
        Opportunity opportunity;
        List<Opportunity> customerOpportunities = [SELECT Id,Name FROM Opportunity WHERE Order_Number__c =:orderNumber LIMIT 1 ];
        if(customerOpportunities.size() >0){
            opportunity = customerOpportunities[0];
        }
        System.debug('--- InboundDataController - getOpportunityRecord - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- InboundDataController - getOpportunityRecord - SOQL USED: ' + LIMITS.getQueries());
        return opportunity;
        
    }
	
	public static Map<String,ContentDocumentLink> getExistingInstallationPDFFiles(List<Id> workOrderLineItemIds){
        System.Debug('--- InboundDataController - getExistingInstallationPDFFiles for recordIds: '+workOrderLineItemIds);
        System.debug('--- InboundDataController - getExistingInstallationPDFFiles - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- InboundDataController - getExistingInstallationPDFFiles - SOQL USED: ' + LIMITS.getQueries());
        Map<String,ContentDocumentLink> fileToWOLI = new Map<String,ContentDocumentLink>();
        if (workOrderLineItemIds.size()>0) {
        	List<ContentDocumentLink> cdlsForWOLI = [SELECT Id, ContentDocumentId,
                                                 ContentDocument.Title,LinkedEntityId
                                             	 FROM ContentDocumentLink WHERE LinkedEntityId IN :workOrderLineItemIds LIMIT 10000];
            if(cdlsForWOLI.size() > 0){
               for (ContentDocumentLink cdl : cdlsForWOLI) {
                    fileToWOLI.put(cdl.ContentDocument.title, cdl);
                }
            }
        }
       	return fileToWOLI;
    }
        */
    public Static CustomException__c assignCustomException(String className, String message,double LineNumber,String methodName,String type, boolean doInsert){
        CustomException__c  customException = new CustomException__c ();
        customException.ClassName__c = className;
        customException.Exception_Message__c = message;
        customException.Line_Number__c = lineNumber; 
        customException.MethodName__c = methodName; 
        customException.Exception_Type__c = type;
        if(doInsert){
            insert customException;
        }
        return customException;
    }
}