/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 10-13-2024
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
    public static List<InboundData.ProductLineData> productLineData {get; set;}
    public static List<InboundData.ServiceLineData> serviceLineData {get; set;} //One Line per Installabale ProductLineItem
    public static InboundData.SalesforceData importedData {get; set;}
    // Lookup Maps
    public static Map<String,String> countryLookup {get;set;}
    public static Map<String,String> businessLookup {get;set;}
    public static Map<String,String> projectLookup {get;set;}
    public static Map<String,String> personLookup {get;set;}
    public static Map<String,User> userLookup {get;set;}
    public static Map<String,Office__c> officeLookup {get;set;}
    public static Map<String,Building__c> buildingLookup {get; set;}
    public static Map<String,Apartment__c> apartmentLookup {get; set;}
    public static Map<String,Configuration__c> planLookup {get; set;}
    public static Map<String,Configuration_Product__c> productLookup {get; set;}
    public static Map<String,Configuration_Attribute__c> attributeLookup {get; set;}
    public static Map<String,Asset> buildingAssetLookup {get; set;}
    public static Map<String,Asset> apartmentAssetLookup {get; set;}
    public static Map<String,Asset> planAssetLookup {get; set;}
    public static Map<String,Asset> productAssetLookup {get; set;}
    // Business Attributes
    public static String organizationCode {get; set;}  
    public static String countryCode {get; set;} 
    public static String profitCenterCode {get; set;} 
    public static String businessType {get; set;} 
    public static String businessTypeCode {get; set;} 
    public static String officeCode {get; set;} 
    public static String segmentCode {get; set;} 
    public static String propertyType {get; set;} 
    public static String propertyTypeCode {get; set;} 
    // Sales Attributes
    public static String salesPerson {get;set;} 
    public static String salesCountryCode {get;set;} 
    public static String salesOfficeCode {get;set;}
    public static String salesAttribute {get;set;}
    // Service Attributes
    public static String servicesPerson {get;set;} 
    public static String servicesCountryCode {get;set;}  
    public static String servicesOfficeCode {get;set;}   
    public static String servicesAttribute {get;set;}
    // Customer Attributes
    public static String customerId {get;set;}  
    public static String customerNumber {get;set;}   
    public static String customerName {get;set;}
    // Project Attributes
    public static String orderType {get;set;}  
    public static String offerNumber {get;set;}  
    public static String projectNumber {get;set;}  
    public static String subProjectNumber {get;set;}   
    // Salesforce Records    
    public static User salesUser {get;set;}  
    public static User servicesUser {get;set;}     
    public static Building_Project__c mainProject {get; set;}
    public static Delivery_Project__c subProject {get; set;}
    public static List<Delivery_Project__c> subProjects {get; set;}
    public static Delivery_Batch__c deliveryBatch {get; set;}
    public static List<Delivery_Batch__c> deliveryBatches {get; set;}
    public static Account customer {get; set;}
    public static Contact customerContact {get; set;}
    public static Account invoicingAccount {get; set;}
    public static Contact invoicingContact {get; set;}
    public static Contact deliveryContact {get; set;}
    public static Contact installationContact {get; set;}
    public static List<Contact> contacts {get; set;}
    public static Opportunity opportunity {get; set;}
    public static List<OpportunityLineItem> opportunityLineItems {get; set;}
    public static Quote quote {get; set;}
    public static List<QuoteLineItem> quoteLineItems {get; set;}
    public static Contract contract {get; set;}
    public static List<ContractLineItem> contractLineItems {get; set;}
    public static Order order {get; set;}
    public static List<OrderItem> orderLineItems {get; set;}
    public static WorkOrder workOrder {get; set;}
    public static List<WorkOrderLineItem> workOrderLineItems {get; set;}
    public static List<Configuration__c> plans {get; set;}
    public static List<Configuration_Product__c> products {get; set;}
    public static List<Configuration_Option__c> options {get; set;}
    public static List<Configuration_Message__c> messages {get; set;}
    public static List<Configuration_Attribute__c> attributes {get; set;}
    public static List<Asset> buildingAssets {get; set;}
    public static List<Asset> apartmentAssets {get; set;}
    public static List<Asset> planAssets {get; set;}
    public static List<Asset> productAssets {get; set;}
    public static ServiceTerritory serviceTerritory {get; set;}
    public static List<ServiceResource> serviceResources {get; set;} 
    public static List<ServiceAppointment> appointments {get; set;}   
    
    public static Office__c salesOffice {get; set;} 
    
    private static Id B2BAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('B2B_Account').getRecordTypeId();
    private static Id B2CAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
    private static Id B2BOpportunityRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('B2B_Opportunity').getRecordTypeId();
    private static Id B2COpportunityRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('B2C_Opportunity').getRecordTypeId();
    //private static Id B2BQuoteRecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByDeveloperName().get('B2B_Quote').getRecordTypeId();
    //private static Id B2CQuoteRecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByDeveloperName().get('B2C_Quote').getRecordTypeId();
    //private static Id B2BContractRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByDeveloperName().get('B2B_Contract').getRecordTypeId();
    //private static Id B2CContractRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByDeveloperName().get('B2C_Contract').getRecordTypeId();
    //private static Id B2BOrderRecordTypeId = Schema.SObjectType.Order.getRecordTypeInfosByDeveloperName().get('B2B_Order').getRecordTypeId();
    //private static Id B2COrderRecordTypeId = Schema.SObjectType.Order.getRecordTypeInfosByDeveloperName().get('B2C_Order').getRecordTypeId();
    private static Id buildingAssetRecordTypeId = Schema.SObjectType.Asset.getRecordTypeInfosByDeveloperName().get('Product').getRecordTypeId();
    private static Id apartmentAssetRecordTypeId = Schema.SObjectType.Asset.getRecordTypeInfosByDeveloperName().get('Apartment').getRecordTypeId();
    private static Id planAssetRecordTypeId = Schema.SObjectType.Asset.getRecordTypeInfosByDeveloperName().get('Plan').getRecordTypeId();
    private static Id productAssetRecordTypeId = Schema.SObjectType.Asset.getRecordTypeInfosByDeveloperName().get('Product').getRecordTypeId();
    /**
    * @description Parse the Order JSON into the InboundData Wrapper
    * @author Henk Reynders | 10-11-2024
    * @return InboundData 
    **/
    public static InboundData getInboundData(String inboundJson) {
        return InboundData.parse(inboundJson);
    }   
    /**
    * @description Parse the Order JSON into the InboundData Wrapper
    * @author Henk Reynders | 10-11-2024
    * @return InboundData 
    **/
    public static InboundData.OrderMessage getOrderMessage(String inboundJson) {
        InboundData inboundData = InboundData.parse(inboundJson);
        return inboundData?.orderMessage;
    }   
    /* -------------------- METHODS to GET DATA -------------------- */
    /**
    * @description Parse the Order JSON into the InboundData Wrapper
    * @author Henk Reynders | 10-11-2024
    * @return InboundData 
    **/
    public static InboundData.OrderData getOrderData() { 
        return orderMessage?.orderData;
    }   
    /**
    * @description Get the projectData from orderData Object 
    * @author Henk Reynders | 10-11-2024
    * @return InboundData 
    **/
    public static InboundData.ProjectData getProjectData() { 
        if (orderData == null) {
            orderData = getOrderData();
        }     
        return orderData?.projectData;
    } 
    /**
    * @description Get the costData from orderData Object 
    * @author Henk Reynders | 10-11-2024
    * @return InboundData 
    **/
    public static InboundData.CostData getCostData() {
        if (orderData == null) {
            orderData = getOrderData();
        }   
        return orderData?.costData;
    } 
    /**
    * @description Get the invoicingData from orderData Object 
    * @author Henk Reynders | 10-11-2024
    * @return InboundData 
    **/
    public static InboundData.InvoicingData getInvoicingData() { 
        if (orderData == null) {
            orderData = getOrderData();
        }     
        return orderData?.invoicingData;
    }
    /**
    * @description Get the deliveryData from orderData Object 
    * @author Henk Reynders | 10-11-2024
    * @return InboundData 
    **/
    public static InboundData.DeliveryData getDeliveryData() { 
        if (orderData == null) {
            orderData = getOrderData();
        }     
        return orderData?.deliveryData;
    }
    /**
    * @description Get the deliveryData from orderData Object 
    * @author Henk Reynders | 10-11-2024
    * @return InboundData 
    **/
    public static InboundData.InstallationData getInstallationData() { 
        if (orderData == null) {
            orderData = getOrderData();
        }     
        return orderData?.installationData;
    }
    /**
    * @description Get the customerData from orderData Object 
    * @author Henk Reynders | 10-11-2024
    * @return InboundData 
    **/
    public static InboundData.CustomerData getCustomerData() {  
        if (orderData == null) {
            orderData = getOrderData();
        }    
        return orderData?.customerData;
    } 
    /**
    * @description Get the productData from orderData Object 
    * @author Henk Reynders | 10-11-2024
    * @return InboundData.ProductData 
    **/
    public static InboundData.ProductData getProductData() { 
        if (orderData == null) {
            orderData = getOrderData();
        }     
        return orderMessage?.productData;
    }
    /**
    * @description Get the userData from orderData Object 
    * @author Henk Reynders | 10-11-2024
    * @param 
    * @return User 
    **/
    public static InboundData.UserData getUserData(){
        if (orderData == null) {
            orderData = getOrderData();
        }   
        return orderData?.userData;
    }
    /**
    * @description Get the Product Line Items from productData Object 
    * @author Henk Reynders | 10-11-2024
    * @return List<InboundData.Product>
    **/
    public static List<InboundData.ProductLineData> getProductLineData() {  
        if (productData == null) {
            productData = getProductData();
        }  
        return productData?.productLineItems;
    } 

    /* -------------------- METHODS to SET Lookup Maps -------------------- */
    /**
    * @description Set the Country Codes to lookup the alpha2 from alpha3 eg 'FIN' => 'FI'
    * @author Henk Reynders | 10-11-2024
    * @return Map<String, String> 
    **/
    public static Map<String,String> setCountryCodes(){
        countryLookup = new Map<String,String>();
        List<Country_Mapping__mdt> countryMappings = new List<Country_Mapping__mdt>();       
        countryMappings = [SELECT CountryCodeAlpha3__c, CountryCodeAlpha2__c ,Country_Name__c  FROM Country_Mapping__mdt];
        if(countryMappings.size() > 0){
            for(Country_Mapping__mdt countryMapping : countryMappings){
                countryLookup.put(countryMapping.CountryCodeAlpha3__c, countryMapping.CountryCodeAlpha2__c);
            }
        }
        System.debug('--- InboundDataController - setCountryCodes '+countryLookup.KeySet().size()+ ' Country Codes'); 
        return countryLookup;
    }
    /**
    * @description Set the values for the Business Attributes from the OrderData Inner Classes of the Wrapper
    * @author Henk Reynders | 10-11-2024
    * @return Map<String,String>
    **/
    public static Map<String,String> setProjectAttributes () {
        projectLookup = new Map<String,String>();   
        // Order Values
        orderType = getOrderType();
        offerNumber = getOfferNumber();
        projectNumber = getProjectNumber(); 
        subProjectNumber = getSubProjectNumber();           
        projectLookup.put('orderType',orderType); //
        projectLookup.put('offerNumber',offerNumber); //
        projectLookup.put('projectNumber',projectNumber); // 
        projectLookup.put('subProjectNumber',subProjectNumber);
        return projectLookup;
    }
    /**
    * @description Set the values for the Business Attributes from the OrderData Inner Classes of the Wrapper
    * @author Henk Reynders | 10-11-2024
    * @return Map<String,String>
    **/
    public static Map<String,String> setBusinessAttributes () {
        businessLookup = new Map<String,String>();   
        System.Debug ('--- InboundDataController - setBusinessAttributes');      
        organizationCode  = getOrganizationCode();
        countryCode = getCountryCode();
        profitCenterCode  = getProfitCenterCode();
        segmentCode  = getSegmentCode();
        businessTypeCode = getBusinessType();        
        salesOfficeCode= getSalesOfficeCode();
        servicesOfficeCode = getServicesOfficeCode();
        officeCode = String.isNotBlank(servicesOfficeCode) ? servicesOfficeCode : salesOfficeCode;              
        propertyTypeCode  = getPropertyType();
        businessLookup.put('organizationCode',organizationCode); // Organization "LSU"
        businessLookup.put('countryCode',countryCode); //Delivery or Installation Country "FI"
        businessLookup.put('profitCenterCode',profitCenterCode); // Profit Center "402"
        businessLookup.put('officeCode',officeCode); // Office Country/Postal Code "FI-43510"
        businessLookup.put('businessTypeCode',businessTypeCode); // Business "1" (Consumer)
        businessLookup.put('segmentCode',segmentCode); // Customer Segment "1000" (Consumer Apartments)
        businessLookup.put('propertyTypeCode',propertyTypeCode); // Building Type "APA" (Apartment)
        return businessLookup;
    }
    /**
    * @description Set the Sales Person and Supervisor (Installation Manager) Usernames
    * @author Henk Reynders | 10-11-2024 
    * @return Map<String, String> 
    **/
    public static Map<String,String> setPersons() {
        personLookup = new Map<String,String>();
        if (userData == null ) {
            userData = getUserData();
        }
        System.Debug ('--- InboundDataController - setPersons sales => '+userData?.salesUsername);
        salesPerson  = String.isNotBlank(userData?.salesUsername) ? userData?.salesUsername : '';  
        System.Debug ('--- InboundDataController - setPersons services => '+userData?.servicesUserName);
        servicesPerson = String.isNotBlank(userData?.servicesUserName) ? userData?.servicesUserName: '';
        personLookup.put('sales', salesPerson);
        personLookup.put('services',servicesPerson);
        if (personLookup?.keySet().size()>0) {
            System.Debug ('--- InboundDataController - setPersons Map => '+personLookup);
        }
        return personLookup;
    }
    /**
    * @description Set the Sales and Installation Manager Users based on their AD usernames
    * @author Henk Reynders | 10-11-2024 
    * @param  
    * @return Map<String, User> 
    **/
    public static Map<String,User> setUsers() {
        userLookup = new Map<String,User>(); 
        if (personLookup.keyset().size() == 0 ) {
            personLookup = setPersons();
        }
        for (String personType  : personLookup.keySet()) {
            User sfUser = getUser(personLookup.get(personType));
            userLookup.put(personType,sfUser);
        }
        if (userLookup?.keySet().size()>0) {
            System.Debug ('--- InboundDataController - setUsers Map => '+userLookup);
        }
        return userLookup;
    }
    /**
    * @description Set Configuration Plans based on Account and Type or create new Building
    * @author Henk Reynders | 10-12-2024 
    * @return List<Asset> 
    **/
    public static Map<String,Configuration__c> setPlans(){
        planLookup = new Map<String,Configuration__c>(); 
        List<Configuration__c> configPlans = new List<Configuration__c>();
        Id accountId = importedData?.account?.Id;
        if (String.IsNotBlank(accountId)){
            configPlans = [SELECT Id, 
                            Building__c,
                            Apartment__c,                                                      
                            Floor__c,
                            Line__c,
                            Unit__c,
                            Name, 
                            PlanName__c,
                            ProjectNumber__c,
                            OfferNumber__c,
                            isMigrated__c,
                            UniqueId__c
                        FROM Configuration__c 
                        WHERE ProjectNumber__c =: projectNumber
                        //AND OfferNumber__c =: offerNumber
                        ];
        } 
        Integer planCounter = 0;
        for (Configuration__c configPlan : configPlans) {
            planCounter++;
            String planIdentifier;
            planIdentifier = configPlan.PlanName__c;
            planIdentifier = planIdentifier + ('-'+configPlan.Floor__c);
            planIdentifier = planIdentifier + ('-'+configPlan.Line__c);
            planIdentifier = planIdentifier + ('-'+configPlan.Unit__c);
            if (!planLookup.containsKey(planIdentifier)) {
                planLookup.put(planIdentifier,configPlan);
                System.debug('--- InboundDataController - setPlans - Plan '+planCounter+' => '+configPlan); 
            }
        }       
        System.debug('--- InboundDataController - setPlans - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- InboundDataController - setPlans - SOQL USED: ' + LIMITS.getQueries());

        return planLookup;
    }
    /**
    * @description Set Configuration Plans based on Account and Type or create new Building
    * @author Henk Reynders | 10-12-2024 
    * @return List<Asset> 
    **/
    public static Map<String,Configuration_Product__c> setProducts(){
        productLookup = new Map<String,Configuration_Product__c>(); 
        List<Configuration_Product__c> configProducts = new List<Configuration_Product__c>();
        Id accountId = importedData?.account?.Id;
        if (String.IsNotBlank(accountId)){
            configProducts = [SELECT Id, 
                            //Building__c,
                            //Apartment__c,                                                      
                            //Floor__c,
                            //Line__c,
                            //Unit__c,
                            Name, 
                            //PlanName__c,
                            ProjectNumber__c,
                            //OfferNumber__c,
                            isMigrated__c,
                            UniqueId__c
                        FROM Configuration_Product__c 
                        WHERE ProjectNumber__c =: projectNumber
                        AND OfferNumber__c =: offerNumber];
        } 
        Integer productCounter = 0;
        for (Configuration_Product__c configProduct : configProducts) {
            productCounter++;
            String productIdentifier;
            productIdentifier = configProduct.SerialNumber__c;
            //productIdentifier = productIdentifier + ('-'+configPlan.Floor__c);
            //productIdentifier = productIdentifier + ('-'+configPlan.Line__c);
            //productIdentifier = productIdentifier + ('-'+configPlan.Unit__c);
            if (!productLookup.containsKey(productIdentifier)) {
                productLookup.put(productIdentifier,configProduct);
                System.debug('--- InboundDataController - setProducts - Product '+productCounter+' => '+configProduct); 
            }
        }       
        System.debug('--- InboundDataController - setProducts - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- InboundDataController - setProducts - SOQL USED: ' + LIMITS.getQueries());

        return productLookup;
    }
    /* -------------------- METHODS to GET Values from DATA -------------------- */
    /**
    * @description Get shortName of salesperson
    * @author Henk Reynders | 10-11-2024
    * @return String 
    **/
    public static String getSalesPerson() {
        if (personLookup.keyset().size() == 0 ) {
            personLookup = setPersons();
        }
        salesPerson = String.isNotBlank(personLookup.get('sales')) ? personLookup.get('sales') : '';
        System.Debug ('--- InboundDataController - getSalesPerson shortName => '+salesPerson);
        return salesPerson;
    }
    /**
    * @description Get shortName of salesperson.supervisor
    * @author Henk Reynders | 10-11-2024
    * @return String 
    **/
    public static String getServicesPerson() {
        if (personLookup.keyset().size() == 0 ) {
            personLookup = setPersons();
        }
        servicesPerson = String.isNotBlank(personLookup.get('services')) ? personLookup.get('services') : '';
        System.Debug ('--- InboundDataController - getServicesPerson shortName => '+servicesPerson);
        return servicesPerson;
    }
    /**
    * @description Get Customer Number from OrderData
    * @author Henk Reynders | 10-11-2024
    * @return String 
    **/
    public static String getCustomerNumber() {       
        customerNumber = String.IsNotBlank(String.valueOf(customerData.customerNumber)) ? String.valueOf(customerData.customerNumber) : '';
        System.debug('--- InboundDataController - getCustomerNumber => '+customerNumber);  
        return customerNumber;
    }
    /**
    * @description Get Customer Name from OrderData
    * @author Henk Reynders | 10-11-2024
    * @return String 
    **/
    public static String getCustomerName() {
        customerName = String.IsNotBlank(String.valueOf(customerData.customerName)) ? String.valueOf(customerData.customerName) : '';
        System.debug('--- InboundDataController - getCustomerName => '+customerName);  
        return customerName;
    }
    /**
    * @description Get Customer Id from OrderData
    * @author Henk Reynders | 10-11-2024
    * @return String 
    **/
    public static String getCustomerId() {
        customerId = String.IsNotBlank(String.valueOf(customerData.customerId)) ? String.valueOf(customerData.customerId) : '';
        System.debug('--- InboundDataController - getCustomerId => '+customerId);  
        return customerId;
    } 
    /**
    * @description Get Customer Country 
    * @author Henk Reynders | 10-11-2024
    * @return String 
    **/
    public static String getCustomerCountryCode() {
        if (countryLookup.keyset().size() == 0 ) {
            countryLookup = setCountryCodes();
        }
        String countryCode = String.isNotBlank(customerData.country) ? countryLookup.get(customerData.country) : getUserCountry();  
        System.debug('--- InboundDataController - getCustomerCountryCode => '+countryCode);  
        return countryCode;
    }
    /* -------------------- METHODS to GET Users from Person and User Lookup -------------------- */ 
    /**
    * @description Query for a User with shortName as salesperson.username
    * @author Henk Reynders | 10-11-2024
    * @return User 
    **/
    public static User getSalesUser() {
        if (userLookup.keyset().size() == 0 ) {
            userLookup = setUsers();
        }
        salesUser = userLookup.containsKey('sales') ? userLookup.get('sales') : new User();
        System.Debug ('--- InboundDataController - getSalesUser User => '+salesUser);
        return salesUser;
    }
    /**
    * @description Query for a User with shortName as salesperson.supervisor
    * @author Henk Reynders | 10-11-2024
    * @return User 
    **/
    public static User getServicesUser() {
        if (userLookup.keyset().size() == 0 ) {
            userLookup = setUsers();
        }
        servicesUser = userLookup.containsKey('services') ? userLookup.get('services') : new User();
        System.Debug ('--- InboundDataController - getServicesUser User => '+servicesUser);
        return servicesUser;
    }
    /* -------------------- METHODS to GET Business Attributes from Attribute Lookup -------------------- */
    /**
    * @description Get (Salestori) Offer Number from OrderData
    * @author Henk Reynders | 10-11-2024
    * @return String 
    **/
    public static String getOfferNumber() {
        if (orderData == null) {
            orderData = getOrderData();
        }
        return String.IsNotBlank(String.valueOf(orderData?.offerNumber)) ? String.valueOf(orderData?.offerNumber) : '';
    }
    /**
    * @description Get (Salestori) Main Project Number from OrderData
    * @author Henk Reynders | 10-13-2024
    * @return String 
    **/
    public static String getProjectNumber() {
        if (projectData == null) {
            projectData = getProjectData();
        }
        return String.IsNotBlank(String.valueOf(projectData?.mainProjectNumber)) ? String.valueOf(projectData?.mainProjectNumber) : '';
    }
    /**
    * @description Get (Salestori) Sub Project Number from OrderData
    * @author Henk Reynders | 10-13-2024
    * @return String 
    **/
    public static String getSubProjectNumber() {
        if (projectData == null) {
            projectData = getProjectData();
        }
        return String.IsNotBlank(String.valueOf(projectData?.subProjectNumber)) ? String.valueOf(projectData?.subProjectNumber) : '';
    }
    /**
    * @description Get Order Type from OrderData
    * @author Henk Reynders | 10-11-2024
    * @return String 
    **/
    public static String getOrderType() {
        if (orderData == null) {
            orderData = getOrderData();
        }
        orderType = String.IsNotBlank(String.valueOf(orderData?.orderType)) ? String.valueOf(orderData?.orderType) : '';
        return orderType;
    }
    /* -------------------- METHODS to GET Country Codes from Country Lookup -------------------- */
    /**
    * @description Get from User Object the CountryAttribute__c
    * @author Henk Reynders | 10-11-2024
    * @return String 
    **/
    public static String getSalesCountryCode() {
        if (countryLookup.keyset().size() == 0 ) {
            countryLookup = setCountryCodes();
        }
        return String.isNotBlank(salesUser?.CountryAttribute__c) ? salesUser?.CountryAttribute__c : '';
    }
    /**
    * @description Get from User Object the CountryAttribute__c
    * @author Henk Reynders | 10-11-2024
    * @return String 
    **/
    public static String getServicesCountryCode() {
        if (countryLookup.keyset().size() == 0 ) {
            countryLookup = setCountryCodes();
        }
        return String.isNotBlank(servicesUser?.CountryAttribute__c) ? servicesUser?.CountryAttribute__c : '';
    }
    /**
    * @description Get from User Object the CountryAttribute__c
    * @author Henk Reynders | 10-11-2024
    * @return String 
    **/
    public static String getUserCountry() {
        if (String.IsBlank(salesCountryCode)) {
            salesCountryCode = getSalesCountryCode();
        }
        if (String.IsBlank(servicesCountryCode)) {
            servicesCountryCode = getServicesCountryCode();
        }
        return String.isNotBlank(salesCountryCode) ? servicesCountryCode : salesCountryCode;
    }
    /**
    * @description Get Business Country 
    * @author Henk Reynders | 10-11-2024
    * @return String 
    **/
    public static String getCountryCode() {     
        if (countryLookup == null) {
            System.Debug ('--- InboundDataController - getCountryCode - countryLookup => '+countryLookup);
            countryLookup = setCountryCodes();
        }
        String countryCodeAlpha3 = String.isNotBlank(deliveryData?.country) ? deliveryData?.country :'';
        countryCode = countryLookup.containsKey(countryCodeAlpha3) ? countryLookup.get(countryCodeAlpha3) :'';   
        System.Debug ('--- InboundDataController - getCountryCode => '+countryCode);
        return countryCode;
    }
    /**
    * @description Get Invoice Country 
    * @author Henk Reynders | 10-11-2024
    * @return String 
    **/
    public static String getBillingCountryCode() {
        if (countryLookup == null || countryLookup?.isEmpty()) {
            countryLookup = setCountryCodes();
        }
        String countryCode = String.isNotBlank(invoicingData?.country) ? countryLookup.get(invoicingData?.country) : '';   
        System.Debug ('--- InboundDataController - getBillingCountryCode => '+countryCode);
        return countryCode;
    }
    /**
    * @description Get Installation Country Attribute
    * @author Henk Reynders | 10-11-2024
    * @return String 
    **/
    public static String getInstallationCountryCode(){
        if (countryLookup == null || countryLookup?.isEmpty()) {
            countryLookup = setCountryCodes();
        }
        String countryCode = String.isNotBlank(installationData?.country) ? countryLookup.get(installationData?.country) : '';
        System.Debug ('--- InboundDataController - getInstallationCountryCode => '+countryCode);   
        return countryCode;
    }
    /**
    * @description Get Delivery Country Attribute
    * @author Henk Reynders | 10-11-2024
    * @return String 
    **/
    public static String getShippingCountryCode() {
        if (countryLookup == null || countryLookup?.isEmpty()){
            countryLookup = setCountryCodes();
        }
        String countryCode = String.isNotBlank(deliveryData?.country) ? countryLookup.get(deliveryData?.country) : '';   
        System.Debug ('--- InboundDataController - getShippingCountryCode => '+countryCode);  
        return countryCode;
    }  
    /* -------------------- METHODS to GET Office Codes from User Lookup -------------------- */
    /**
    * @description Get from User Object the OfficeAttribute__c
    * @author Henk Reynders | 10-11-2024
    * @return String 
    **/
    public static String getUserOffice() {
        String userOfficeCode = String.isNotBlank(servicesUser?.OfficeAttribute__c) ? servicesUser?.OfficeAttribute__c : salesUser?.OfficeAttribute__c;
        System.Debug ('--- InboundDataController - getUserOffice => '+userOfficeCode);
        return userOfficeCode;
    }
    /**
    * @description Get from User Object the OfficeAttribute__c
    * @author Henk Reynders | 10-11-2024
    * @return String 
    **/
    public static String getSalesOfficeCode() {
        if (salesUser == null ) {
            getSalesUser();
        }
        salesOfficeCode = String.isNotBlank(salesUser?.OfficeAttribute__c) ? salesUser?.OfficeAttribute__c :'';
        System.Debug ('--- InboundDataController - getSalesOfficeCode => '+salesOfficeCode);
        return salesOfficeCode;
    }
    /**
    * @description Get the Sales Offices associated with the Sales User
    * @author Henk Reynders | 10-11-2024 
    * @param
    * @return Office__c 
    **/
    public static Office__c getSalesOffice() {
        Office__c salesOffice = new Office__c();    
        salesOfficeCode = getSalesOfficeCode();
        if (String.IsNotBlank(salesOfficeCode)) {            
            importedData.salesOfficeCode = salesOfficeCode;
            salesOffice = [SELECT Id,Name, OfficeCode__c 
                            FROM Office__c
                            WHERE OfficeCode__c =: salesOfficeCode 
                            LIMIT 1];
        }
        if (String.IsNotBlank(salesOffice?.Id)) {
            importedData.salesOffice = salesOffice;
        }
        return salesOffice;
    }  
    /**
    * @description Get from User Object the OfficeAttribute__c
    * @author Henk Reynders | 10-11-2024
    * @return String 
    **/
    public static String getServicesOfficeCode() {
        if (servicesUser == null ) {
            getServicesUser();
        }
        servicesOfficeCode = String.isNotBlank(servicesUser?.OfficeAttribute__c) ? servicesUser?.OfficeAttribute__c :'';
        System.Debug ('--- InboundDataController - getServicesOfficeCode => '+servicesOfficeCode);
        return servicesOfficeCode;
    }
    /**
    * @description Get the Services Office associated with the SuperVisor/Installation Manager
    * @author Henk Reynders | 10-11-2024 
    * @param
    * @return Office__c
    **/
    public static Office__c getServicesOffice() {
        Office__c servicesOffice = new Office__c();    
        servicesOfficeCode = getServicesOfficeCode();
        if (String.IsNotBlank(servicesOfficeCode)) {            
            servicesOffice = [SELECT Id,Name, OfficeCode__c 
                            FROM Office__c
                            WHERE OfficeCode__c =: servicesOfficeCode 
                            LIMIT 1];
        }
        return servicesOffice;
    }  
    /**
    * @description Get the Sales and Field Service Offices associated the Sales User and Installation Manager
    * @author Henk Reynders | 10-11-2024 
    * @param
    * @return Map<String, Office__c> 
    **/
    public static Map<String,Office__c> getOffices() {  
        officeLookup = new Map<String,Office__c>();
        if (userLookup.keyset().size() == 0 ) {
            userLookup = setUsers();
        }
        for (String personType  : userLookup.keySet()) {
            String officeCode = userLookup.get(personType)?.OfficeAttribute__c;
            Office__c userOffice = getOffice(officeCode);
            officeLookup.put(personType,userOffice);
        }
        if (officeLookup?.keySet().size()>0) {
            System.Debug ('--- InboundDataController - getOffices Map => '+officeLookup);
        }
        return officeLookup;
    }  
    /* -------------------- METHODS to GET Business Attributes from Attribute Lookup -------------------- */
    /**
    * @description Get Organization Business Attribute
    * @author Henk Reynders | 10-11-2024
    * @return String 
    **/
    public static String getOrganizationCode() {
        String organizationCode  = String.isNotBlank(orderData?.organizationCode) ? orderData?.organizationCode : '';     
        System.Debug ('--- InboundDataController - getOrganizationCode => '+organizationCode);   
        return organizationCode;
    }   
    /**
    * @description Get Profit Center (BU) Business Attribute
    * @author Henk Reynders | 10-11-2024
    * @return String 
    **/
    public static String getProfitCenterCode() {
        profitCenterCode  = String.isNotBlank(orderData?.profitCenterCode) ? orderData?.profitCenterCode : '';
        System.Debug ('--- InboundDataController - getProfitCenterCode => '+profitCenterCode); 
        return profitCenterCode;
    }
    /**
    * @description Get Business Type Business Attribute
    * @author Henk Reynders | 10-11-2024
    * @return String 
    **/
    public static String getSegmentCode() {
        segmentCode = String.isNotBlank(orderData?.segmentCode) ? orderData?.segmentCode : '';
        System.Debug ('--- InboundDataController - getSegmentCode => '+segmentCode); 
        return segmentCode;
    }
    /**
    * @description Get Business Type Business Attribute
    * @author Henk Reynders | 10-11-2024
    * @return String 
    **/
    public static String getBusinessType() {
        if (String.IsBlank(segmentCode)) {
            segmentCode = getSegmentCode();
        }
        businessTypeCode = String.isNotBlank(segmentCode) ? segmentCode.left(1) : '0';
        System.Debug ('--- InboundDataController - getBusinessType => '+businessTypeCode); 
        return businessTypeCode;
    }
    /**
    * @description Get from User Object the CountryAttribute__c
    * @author Henk Reynders | 10-11-2024
    * @return String 
    **/
    public static String getPropertyType() {
        propertyTypeCode  = String.isNotBlank(orderData?.propertytype) ? orderData?.propertytype : '';
        System.Debug ('--- InboundDataController - getPropertyType => '+propertyTypeCode); 
        return propertyTypeCode;
    }  
    /**
    * @description Get the generated salesAttribute based on the Business Attributes
    * @author Henk Reynders | 10-11-2024
    * @param 
    **/
    public static String getSalesAttribute(){        
        salesAttribute = String.IsNotBlank(organizationCode) ? organizationCode : '';
        salesAttribute = salesAttribute +(String.IsNotBlank(countryCode) ? countryCode : '_'+countryCode);
        salesAttribute = salesAttribute +(String.IsNotBlank(profitCenterCode) ? profitCenterCode : '_'+profitCenterCode);
        salesAttribute = salesAttribute +(String.IsNotBlank(officeCode) ? officeCode : '_'+officeCode);
        salesAttribute = salesAttribute +(String.IsNotBlank(segmentCode) ? segmentCode : '_'+segmentCode);
        return salesAttribute;
    }
    /**
    * @description Get the generated servicesAttribute based on the Business Attributes
    * @author Henk Reynders | 10-11-2024
    * @param  
    **/
    public static String getServicesAttribute(){
        servicesAttribute = String.IsNotBlank(organizationCode) ? organizationCode : '';
        servicesAttribute = servicesAttribute + (String.IsNotBlank(officeCode) ? officeCode : '_'+officeCode);
        servicesAttribute = servicesAttribute + (String.IsBlank(servicesAttribute) && String.IsNotBlank(segmentCode) ? segmentCode : '_'+segmentCode);
        return servicesAttribute;
    } 
    /* -------------------- METHODS to GET Records from Salesforce -------------------- */
    /**
    * @description Query for a Active User with matching AD shortName
    * @author Henk Reynders | 10-11-2024
    * @param 
    * @return User 
    **/
    public static User getUser(String shortName){
        User sfUser;
        List<User> sfUsers = new List<User>();
        sfUsers = [SELECT Id,Name,Alias,AD_UserName__c, IsActive, Profile.Name, UserRole.DeveloperName, CountryAttribute__c,ProfitCenterAttribute__c, OfficeAttribute__c  
                            FROM User 
                            WHERE AD_UserName__c =:shortName 
                            AND IsActive = true];
        if (sfUsers.size() == 0) {
            sfUsers = [SELECT Id,Name,Alias,AD_UserName__c, IsActive, Profile.Name, UserRole.DeveloperName, CountryAttribute__c,ProfitCenterAttribute__c, OfficeAttribute__c  
            FROM User 
            WHERE Alias =:shortName 
            AND IsActive = true];
        }
        sfUser = sfUsers?.size() > 0 ? sfUsers[0] : new User();
        System.Debug ('--- InboundDataController - getUser => '+sfUser);
        return sfUser;
    }
    /**
    * @description Get the Office associated the User
    * @author Henk Reynders | 10-11-2024 
    * @param
    * @return Office__c
    **/
    public static Office__c getOffice(String officeCode) {
        Office__c sfOffice;  
        List<Office__c> sfOffices = new List<Office__c>();
        sfOffices = [SELECT Id,Name, OfficeCode__c, OfficeName__c
                        FROM Office__c
                        WHERE OfficeCode__c =: officeCode];
        if (sfOffices.size() == 0) {
            sfOffices = [SELECT Id,Name, OfficeCode__c, OfficeName__c
                        FROM Office__c
                        WHERE OfficeName__c =: officeCode];
        }
        sfOffice = sfOffices?.size() > 0 ? sfOffices[0] : new Office__c();
        System.Debug ('--- InboundDataController - getOffice => '+sfOffice);
        return sfOffice;
    }  
    /**
    * @description Get the (Main) Project based on projectNumber or create a new Project
    * @author Henk Reynders | 09-24-2024 
    * @return Building_Project__c 
    **/
    public static Building_Project__c getBuildingProject(){   
        mainProject = new Building_Project__c();          
        if (String.isNotBlank(projectNumber)) {
            projectNumber = getProjectNumber();
        }
        if (String.IsNotBlank(projectNumber)) {
            System.debug('--- InboundDataController - getBuildingProject - Project Number '+projectNumber); 
            Id projectId = [SELECT Id FROM Building_Project__c WHERE ProjectNumber__c =: projectNumber LIMIT 1]?.Id; 
            if (String.IsNotBlank(projectId)){
                System.debug('--- InboundDataController - getBuildingProject - Existing Project : '+projectId); 
                mainProject = [SELECT Id, Name, ProjectNumber__c, isMigrated__c 
                            FROM Building_Project__c 
                            WHERE Id =: projectId 
                            LIMIT 1]; 
            } else {
                System.debug('--- InboundDataController - getBuildingProject - No Existing Project'); 
                mainProject = setBuildingProject(); 
            }
        } else {
            System.debug('--- InboundDataController - getBuildingProject - No Main Project Number'); 
        }
        System.debug('--- InboundDataController - getBuildingProject - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- InboundDataController - getBuildingProject - SOQL USED: ' + LIMITS.getQueries());
        return mainProject;
    }   
    /**
    * @description Get the (Sub) Project based on projectNumber or create a new Project
    * @author Henk Reynders | 09-24-2024 
    * @return Delivery_Project__c 
    **/
    public static Delivery_Project__c getDeliveryProject(){  
        subProject = new Delivery_Project__c();  
        if (String.isNotBlank(subProjectNumber)) {
            subProjectNumber = getSubProjectNumber();
        }  
        if (String.IsNotBlank(subProjectNumber)) {
            System.debug('--- InboundDataController - getDeliveryProject - Sub Project Number '+subProjectNumber); 
            Id subProjectId = [SELECT Id FROM Delivery_Project__c WHERE 	SubProjectNumber__c =: subProjectNumber LIMIT 1]?.Id; 
            if (String.IsNotBlank(subProjectId)){
                System.debug('--- InboundDataController - getDeliveryProject - Existing Project : '+subProjectId); 
                subProject = [SELECT Id, Name, ProjectNumber__c,BuildingProject__c, SubProjectNumber__c
                            FROM Delivery_Project__c 
                            WHERE Id =: subProjectId 
                            LIMIT 1]; 
            } else {
                System.debug('--- InboundDataController - getDeliveryProject - No Existing Project'); 
                subProject = setDeliveryProject(); 
            }
        } else {
            System.debug('--- InboundDataController - getDeliveryProject - No SubProject Number'); 
        }
        System.debug('--- InboundDataController - getDeliveryProject - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- InboundDataController - getDeliveryProject - SOQL USED: ' + LIMITS.getQueries());
        return subProject;
    } 
    /**
    * @description Get the Account based on customerNumber or create a new Account
    * UniqueId field will hold the external customerIdentifier
    * @author Henk Reynders | 10-12-2024 
    * @return Account 
    **/
    public static Account getCustomerAccount(){   
        customer = new Account();  
        Id customerAccountId; 
        String customerIdentifier;
        if (String.isBlank(customerNumber)){
            customerNumber = getCustomerNumber();
        }
        if (String.isBlank(customerName)){
            customerName = getCustomerName();
        }
        if (String.isBlank(customerId)){
            customerId = getCustomerId();
        }     
        System.debug('--- InboundDataController - getCustomerAccount - Customer Name => '+customerName); 
        System.debug('--- InboundDataController - getCustomerAccount - Customer Number => '+customerNumber); 
        System.debug('--- InboundDataController - getCustomerAccount - Customer Id => '+customerId); 
        customerIdentifier = String.isNotBlank(customerName) ? '-'+customerName : '';
        customerIdentifier = customerIdentifier + (String.isNotBlank(customerNumber) ? '-'+customerNumber : '');
        customerIdentifier = customerIdentifier + (String.isNotBlank(customerId) ? '-'+customerId : '');
        if (String.IsNotBlank(customerIdentifier)) {
            System.debug('--- InboundDataController - getCustomerAccount - Customer Identifier '+customerIdentifier); 
            customerAccountId = [SELECT Id FROM Account WHERE AccountNumber =: customerIdentifier OR Name =: customerIdentifier LIMIT 1]?.Id; 
        } else {
            System.debug('--- InboundDataController - getCustomerAccount - No Customer Identifier provided'); 
        }
        if (String.IsNotBlank(customerAccountId)){
            System.debug('--- InboundDataController - getCustomerAccount - Existing Account : '+customerAccountId); 
            customer = [SELECT Id, Name, RecordTypeId, isPersonAccount, BillingAddress, ShippingAddress  
                        FROM Account 
                        WHERE Id =: customerAccountId 
                        LIMIT 1]; 
        } else {
            System.debug('--- InboundDataController - getCustomerAccount - No Existing Account'); 
            customer = setCustomerAccount(); 
        }
        //System.debug('--- InboundDataController - getCustomerAccount - CPU TIME: '+LIMITS.getCpuTime()); 
        //System.debug('--- InboundDataController - getCustomerAccount - SOQL USED: ' + LIMITS.getQueries());
        return customer;
    }
    /**
    * @description Get the Contact based on customerNumber or create a new Contact
    * @author Henk Reynders | 10-12-2024 
    * @return Contact 
    **/
    public static Contact getCustomerContact(){   
        Id accountId =   importedData?.account?.Id;      
        Id contactId =   importedData?.contact?.Id;
        // Customer Data Values
        String firstName = customerData.firstName;
        String lastName = customerData.firstName;
        String contactName = firstName+' '+lastName;
        String phone = customerData.firstName;
        String email = customerData.email;
        String fax = customerData.fax;
        // find Contact based on Name 
        if (String.IsNotBlank(contactName) && String.IsBlank(contactId)) {
            System.debug('--- InboundDataController - getContact - Name '+contactName); 
            contactId = [SELECT Id FROM Contact WHERE Name =: contactName LIMIT 1]?.Id; 
            if (String.IsNotBlank(contactId)){ 
                System.debug('--- InboundDataController - getContact - Existing Contact => '+contactId); 
                customerContact = [SELECT Id, Name, IsPersonAccount , MailingAddress, OtherAddress  
                            FROM Contact 
                            WHERE Id =: contactId
                            LIMIT 1]; 
            } else {
                customerContact = setCustomerContact(); 
            }
            if (String.IsNotBlank(customerContact.Id)){
                importedData.contact = customerContact;
                //if(customerContact.isPersonAccount){
                //    importedData.account = [SELECT Id FROM Account WHERE PersonContactId =: customerContact.Id LIMIT 1]?.Id; 
                //}
            }
        } else {
            System.debug('--- InboundDataController - getContact - No Contact Name'); 
        }
        System.debug('--- InboundDataController - getContact - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- InboundDataController - getContact - SOQL USED: ' + LIMITS.getQueries());
        return customerContact;
    }
    /**
    * @description Get the Opportunity based on customerNumber or create a new Opportunity
    * @author Henk Reynders | 10-12-2024 
    * @return Opportunity 
    **/
    public static Opportunity getOpportunity(){
        opportunity = new Opportunity();
        if (String.isBlank(projectNumber)){
            projectNumber = getProjectNumber();
        }
        if (String.isBlank(offerNumber)){
            offerNumber = getOfferNumber();
        }
        System.debug('--- InboundDataController - getOpportunity - projectNumber => '+projectNumber); 
        System.debug('--- InboundDataController - getOpportunity - offerNumber => '+offerNumber);        
        if (String.IsNotBlank(offerNumber)) {
            Id opportunityId = [SELECT Id FROM Opportunity WHERE OfferNumber__c =: offerNumber LIMIT 1]?.Id; 
            if (String.IsNotBlank(opportunityId)){
                System.debug('--- InboundDataController - getOpportunity - Existing opportunityId => '+opportunityId);  
                opportunity = [SELECT Id, Name, RecordTypeId, accountId, StageName 
                            FROM Opportunity 
                            WHERE Id =: opportunityId
                            LIMIT 1]; 
            } else {
                opportunity = setOpportunity();
            }
        }  
        System.debug('--- InboundDataController - getOpportunity - opportunityId => '+opportunity?.Id);         
        System.debug('--- InboundDataController - getOpportunity - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- InboundDataController - getOpportunity - SOQL USED: ' + LIMITS.getQueries());
        return opportunity;
    }
    /**
    * @description Get the Quote based on customerNumber or create a new (Standalone) Quote
    * @author Henk Reynders | 10-12-2024 
    * @return Quote 
    **/
    public static Quote getQuote(){
        quote = new Quote();
        if (String.isBlank(projectNumber)){
            projectNumber = getProjectNumber();
        }
        if (String.isBlank(offerNumber)){
            offerNumber = getOfferNumber();
        }   
        System.debug('--- InboundDataController - getQuote - projectNumber => '+projectNumber);
        System.debug('--- InboundDataController - getQuote - offerNumber => '+offerNumber);    
        if (String.IsNotBlank(offerNumber)) {                     
            Id quoteId = [SELECT Id FROM Quote WHERE OfferNumber__c =: offerNumber LIMIT 1]?.Id; 
            if (String.IsNotBlank(quoteId)){
                System.debug('--- InboundDataController - getQuote - Existing quoteId => '+quoteId);   
                quote = [SELECT Id, Name, AccountId, isSyncing, OfferNumber__c 
                            FROM Quote 
                            WHERE Id =: quoteId
                            LIMIT 1]; 
            } else {
                quote = setQuote();
            }
        }         
        System.debug('--- InboundDataController - getQuote - quoteId => '+quote?.Id);     
        System.debug('--- InboundDataController - getQuote - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- InboundDataController - getQuote - SOQL USED: ' + LIMITS.getQueries());
        return quote;
    }
    /**
    * @description Get the Contract based on offernumber and batch Id or create a new Contract
    * @author Henk Reynders | 10-12-2024 
    * @return Order 
    **/
    public static Contract getContract(){
        contract = new Contract();
        if (String.isBlank(projectNumber)){
            projectNumber = getProjectNumber();
        }
        if (String.isBlank(offerNumber)){
            offerNumber = getOfferNumber();
        }   
        System.debug('--- InboundDataController - getContract - projectNumber => '+projectNumber);
        System.debug('--- InboundDataController - getContract - offerNumber => '+offerNumber);    
        if (String.IsNotBlank(offerNumber)) {
            Id accountId = importedData?.account?.Id;
            Id contractId = [SELECT Id 
                            FROM Contract 
                            WHERE OfferNumber__c =: offerNumber 
                            AND AccountId =: accountId
                            LIMIT 1]?.Id; 
            if (String.IsNotBlank(contractId)){
                System.debug('--- InboundDataController - getContract - Existing contractId => '+contractId); 
                contract = [SELECT Id, Name, AccountId, OfferNumber__c 
                            FROM Contract 
                            WHERE Id =: contractId
                            LIMIT 1]; 
            } else {
                contract = setContract();
            }
        }      
        System.debug('--- InboundDataController - getContract - contractId => '+contract?.Id);       
        System.debug('--- InboundDataController - getContract - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- InboundDataController - getContract - SOQL USED: ' + LIMITS.getQueries());
        //orderMessage.orderData.contract = contract;
        return contract;
    }
    /**
    * @description Get the Order based on offernumber and batch Id or create a new  Order
    * @author Henk Reynders | 10-12-2024 
    * @return Order 
    **/
    public static Order getOrder(){
        order = new Order();
        if (String.isBlank(projectNumber)){
            projectNumber = getProjectNumber();
        }
        if (String.isBlank(offerNumber)){
            offerNumber = getOfferNumber();
        }   
        System.debug('--- InboundDataController - getOrder - projectNumber => '+projectNumber);
        System.debug('--- InboundDataController - getOrder - offerNumber => '+offerNumber);         
        Order duplicateOrder = new Order();
        Id accountId = importedData?.account?.Id;
        if (String.IsNotBlank(offerNumber)) {
            Id orderId = [SELECT Id
                            FROM Order 
                            WHERE OfferNumber__c =: offerNumber 
                            AND AccountId =: accountId
                            LIMIT 1]?.Id; 
            if (String.IsNotBlank(orderId)){
                System.debug('--- InboundDataController - getOrder - Existing orderId => '+orderId); 
                order = [SELECT Id, Name, AccountId, OfferNumber__c 
                            FROM Order 
                            WHERE Id =: orderId
                            LIMIT 1]; 
            } else {
                order = setOrder();
            }
        }         
        System.debug('--- InboundDataController - getOrder - orderId => '+order?.Id); 
        System.debug('--- InboundDataController - getOrder - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- InboundDataController - getOrder - SOQL USED: ' + LIMITS.getQueries());
        return order;
    }
    /**
    * @description 
    * @author Henk Reynders | 10-12-2024 
    * @return Delivery_Batch__c 
    **/
    public static Delivery_Batch__c getDeliveryBatch(){
        deliveryBatch = new Delivery_Batch__c();
        if (String.isBlank(projectNumber)){
            projectNumber = getProjectNumber();
        }
        if (String.isBlank(offerNumber)){
            offerNumber = getOfferNumber();
        } 
        if (String.isBlank(profitCenterCode)){
            profitCenterCode = getProfitCenterCode();
        } 
        System.Debug ('--- InboundDataController - getDeliveryBatch - Project => '+projectNumber);
        System.Debug ('--- InboundDataController - getDeliveryBatch - Order => '+offerNumber);
        System.Debug ('--- InboundDataController - getDeliveryBatch - Profit Center => '+profitCenterCode);
        // To identify the Batch use the first ProductLineItem (=group)
        if (productLineData == null) {
            productLineData = getProductLineData();
        }
        if(productLineData.size()>0) {
            InboundData.ProductLineData rvnProduct = productLineData[0];
            // Batch
            String batchNumber = rvnProduct.batchNumber; // "delivery_batch": "1",
            System.Debug ('--- InboundDataController - getDeliveryBatch - Batch Number => '+batchNumber);
            String batchIdentifier = projectNumber+'-'+offerNumber+'-'+batchNumber;
            System.Debug ('--- InboundDataController - getDeliveryBatch - Batch Number Identifier => '+batchIdentifier);
            if (String.isNotBlank(batchIdentifier)) {
                Id batchId = [SELECT Id
                            FROM Delivery_Batch__c 
                            WHERE UniqueId__c = : batchIdentifier
                            LIMIT 1]?.Id; 
                if (String.IsNotBlank(batchId)){
                    System.debug('--- InboundDataController - getDeliveryBatch - Existing batchId => '+batchId); 
                    // Batch
                    deliveryBatch = [SELECT Id, 
                                            Name, // Batch Name => SF autonumber
                                            CreatedDate, CreatedById, 
                                            BatchNumber__c,  // Batch Number => "delivery_batch": "1",
                                            BatchStatus__c, // Batch Status => "delivery_batch_status": "Mitattu",
                                            BatchDeliveryDate__c, //estimated or Confirmed Delivery Date
                                            BatchEarliestStartDate__c, // "monday" after delivery
                                            BatchDueDate__c, //promised Date
                                            WarehouseCode__c, //warehous location
                                            //PackingOrderCode__c,//"packing_order": "1",
                                            OrderType__c, // "process": "Normal"
                                            ProjectNumber__c, 
                                            OfferNumber__c, 
                                            IsMigrated__c,
                                            hasInstallation__c,
                                            UniqueId__c
                                            //NumberOfProducts__c,
                                            //NumberOfCompletedInstallations__c, 
                                            //NumberOfPlannedInstallations__c, 
                                            //NumberOfStartedInstallations__c
                                FROM Delivery_Batch__c
                                WHERE Id = : batchId
                                LIMIT 1];                       
                } else {
                    deliveryBatch = setDeliveryBatch();
                }  
            }
        }            
        System.debug('--- InboundDataController - getDeliveryBatch - batchId => '+deliveryBatch?.Id); 
        System.debug('--- InboundDataController - getDeliveryBatch - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- InboundDataController - getDeliveryBatch - SOQL USED: ' + LIMITS.getQueries());
        return deliveryBatch;
    }  
    /**
    * @description Get Assets based on Account and Type or create new Building
    * @author Henk Reynders | 10-12-2024 
    * @return List<Asset> 
    **/
    public static Map<String,Asset> getPlanAssets(){
        Map<String,Asset> planAssetMap = new Map<String,Asset>(); 
        List<Asset> assets = new List<Asset>();
        Id accountId = importedData?.account?.Id;
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
                        AND RecordTypeId =: planAssetRecordTypeId];
        } 
        // For Plans the Unique Id is <PlanName>-<planFloor>-<planLine>-planUnit
        for (Asset asset : assets) {
            if (planAssetMap.containsKey(asset.UniqueId__c)) {
            } else if (!planAssetMap.containsKey(asset.UniqueId__c)) {
                planAssetMap.put(asset.UniqueId__c,asset);
            }
        }

        planAssets.addAll(assets);
        if (planAssets?.size()>0) {
            System.debug('--- InboundDataController - getPlanAssets => '+planAssets?.size()+' Existing Plan Assets'); 
            importedData.planAssets = planAssets;
        }        
        System.debug('--- InboundDataController - getPlanAssets - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- InboundDataController - getPlanAssets - SOQL USED: ' + LIMITS.getQueries());

        return planAssetMap;
    }
    /**
    * @description Get a single Plan Asset 
    * @author Henk Reynders | 10-12-2024 
    * @return Asset 
    **/
    public static Asset getPlanAsset(InboundData.ProductLineData productLineItem){
        Asset planAsset = new Asset();
        return planAsset;
    }
    /**
    * @description Get the Building based on Account and Type or create new Building
    * @author Henk Reynders | 10-12-2024 
    * @return List<Asset> 
    **/
    public static List<Asset> getBuildingAssets(Id assetId, Id accountId){
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
        System.debug('--- InboundDataController - getBuildingAssets - CPU TIME: '+LIMITS.getCpuTime());
        System.debug('--- InboundDataController - getBuildingAssets - SOQL USED: ' + LIMITS.getQueries());
        buildingAssets.add(building);

        importedData.buildingAssets = buildingAssets;
        return buildingAssets;
    }
    /**
    * @description Get Assets based on Account and Type or create new Building
    * @author Henk Reynders | 10-12-2024 
    * @return List<Asset> 
    **/
    public static Map<String,Asset> getProductAssets(){
        Map<String,Asset> productAssetMap = new Map<String,Asset>(); 
        List<Asset> assets = new List<Asset>();
        Id accountId = importedData?.account?.Id;
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
                        AND RecordTypeId =: productAssetRecordTypeId];
        } 
        for (Asset asset : assets) {
            if (productAssetMap.containsKey(asset.SerialNumber)) {
            } else if (!productAssetMap.containsKey(asset.SerialNumber)) {
                productAssetMap.put(asset.SerialNumber,asset);
            }
        }

        productAssets.addAll(assets);
        if (productAssets?.size()>0) {
            System.debug('--- InboundDataController - getProductAssets => '+productAssets?.size()+' Existing Product Assets'); 
            importedData.productAssets = productAssets;
        }        
        System.debug('--- InboundDataController - getProductAssets - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- InboundDataController - getProductAssets - SOQL USED: ' + LIMITS.getQueries());

        return productAssetMap;
    }
    /**
    * @description Query for the applicable Service Territory matching the Service Attribute (org,country,office and segment)
    * @author Henk Reynders | 10-11-2024
    * @param 
    * @return ServiceTerritory 
    **/
    public static ServiceTerritory getServiceTerritory(){
        serviceTerritory = [SELECT Id,Name,IsActive 
                            FROM ServiceTerritory 
                            WHERE serviceAttribute__c =: servicesAttribute 
                                AND IsActive = true LIMIT 1];
        return serviceTerritory;
    }
    /* -------------------- METHODS to SET Records to Salesforce -------------------- */      
    /**
    * @description Set the (Main) ProjectRecord by creating a new Building Project
    * @author Henk Reynders | 10-11-2024
    * @param  
    * @return Building_Project__c 
    **/
    public static Building_Project__c setBuildingProject(){
        try{
            System.debug('--- InboundDataController - setBuildingProject - Creating New Project'); 
            Building_Project__c newProject = new Building_Project__c();
            Building_Project__c duplicateProject = new Building_Project__c();
            newProject.Name = projectNumber+' '+customer?.Name; 
            newProject.ProjectNumber__c = projectNumber;    
            newProject.Organization__c = businessLookup.get('organizationCode'); 
            newProject.Customer__c = customer?.Id;   
            newProject.isMigrated__c = true;
            newProject.UniqueId__c = projectNumber;    
            
            //newProject.ProfitCenter__c = businessAttributes.get('profitCenterCode');

            System.debug('--- InboundDataController - setBuildingProject - Project to Create '+newProject);       
            if (newProject.isMigrated__c){
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
            if (String.isNotBlank(newProject?.Id))  {
                mainProject = newProject;
                System.debug('--- InboundDataController - setBuildingProject - Main Project => '+mainProject);
            }
            System.debug('--- InboundDataController - setBuildingProject - CPU TIME: '+LIMITS.getCpuTime()); 
            System.debug('--- InboundDataController - setBuildingProject - SOQL USED: ' + LIMITS.getQueries());
            return newProject;

        } catch (Exception e){
            return null;
        }
    }        
    /**
    * @description Set the (Sub) ProjectRecord by creating a new Delivery Project
    * @author Henk Reynders | 10-11-2024
    * @param  
    * @return Delivery_Project__c 
    **/
    public static Delivery_Project__c setDeliveryProject(){
        Delivery_Project__c newProject = new Delivery_Project__c();
        Delivery_Project__c duplicateProject = new Delivery_Project__c();
        if (projectData == null) {
            projectData = getProjectData();
        }
        try{
            System.debug('--- InboundDataController - setDeliveryProject - Creating New Delivery Project'); 
            
            //newProject.Name;
            Id parentProjectId = mainProject?.Id;
            if (String.isNotBlank(parentProjectId)) {
                newProject.BuildingProject__c = parentProjectId;
                newProject.Customer__c = customer?.Id;
                newProject.ProjectNumber__c = ProjectNumber; // "subproject_parentproject": "100001", 
                newProject.SubprojectNumber__c =  subProjectNumber; // "subproject_number": "100001_01",
                
                newProject.ProjectCost__c = Decimal.ValueOf(projectData.ProjectCost); //"subproject_cost": "0.00",
                newProject.ProjectCategory__c = projectData.projectCategory; //"subproject_category": "Warranty", NOTE Seems always Warranty
                newProject.ProjectGroup__c = projectData.projectGroup; //"subproject_group": "CONWAR",
                newProject.OrderType__c = projectData.orderType; //"subproject_ordertype": "Normal",
                //newProject.ProjectType__c = projectData.projectType; 
                newProject.isChargeable__c = projectData.isChargeable == 'chargable' ? true : false; //"subproject_chargeable": "non-chargeable"
                newProject.isMigrated__c = true;
                newProject.UniqueId__c = projectData.subProjectNumber;  
                //newProject.underWarranty__c
                System.debug('--- InboundDataController - setDeliveryProject - Project to Create '+newProject);       
                if (newProject?.isMigrated__c){
                    Database.DMLOptions dml = new Database.DMLOptions(); 
                    dml.DuplicateRuleHeader.allowSave = false;
                    Database.SaveResult saveResultAttempt1 =  Database.insert(newProject,dml) ;
                    if (!saveResultAttempt1.isSuccess()) {
                        List<Database.Error> error = saveResultAttempt1.getErrors();
                        System.Debug('--- InboundDataController - setDeliveryProject - Database Error on Project Create : '+error[0] );
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
                                System.Debug('--- InboundDataController - setDeliveryProject - Duplicate Delivery Project Created: '+newProject?.Id);
                                System.Debug('--- InboundDataController - setDeliveryProject - Duplicate Delivery Project Existing: '+duplicateProject?.Id);
                            }
                        }
                    }else{
                        System.Debug('--- InboundDataController - setDeliveryProject- New Delivery Project Created: '+newProject?.Id);
                        
                    }
                }
                if (String.isNotBlank(newProject?.Id))  {
                    subProject = newProject;
                    System.debug('--- InboundDataController - setDeliveryProject - subProject => '+subProject);
                }
            }
            System.debug('--- InboundDataController - setDeliveryProject - CPU TIME: '+LIMITS.getCpuTime()); 
            System.debug('--- InboundDataController - setDeliveryProject - SOQL USED: ' + LIMITS.getQueries());
            return newProject;
        } catch (Exception e){
            return null;
        }
    }
    /**
    * @description Set the Account Record by creating a new Account
    * @author Henk Reynders | 10-11-2024
    * @param  
    * @return Account 
    **/
    public static Account setCustomerAccount(){
        customer = new Account();
        Account newAccount = new Account();
        Account duplicateAccount = new Account();
        String customerIdentifier;
        if (String.isBlank(customerNumber)){
            customerNumber = getCustomerNumber();
        }
        if (String.isBlank(customerName)){
            customerName = getCustomerName();
        }
        if (String.isBlank(customerId)){
            customerId = getCustomerId();
        }     
        System.debug('--- InboundDataController - setCustomerAccount - Customer Name => '+customerName); 
        System.debug('--- InboundDataController - setCustomerAccount - Customer Number => '+customerNumber); 
        System.debug('--- InboundDataController - setCustomerAccount - Customer Id => '+customerId); 
        customerIdentifier = String.isNotBlank(customerName) ? '-'+customerName : '';
        customerIdentifier = customerIdentifier + (String.isNotBlank(customerNumber) ? '-'+customerNumber : '');
        customerIdentifier = customerIdentifier + (String.isNotBlank(customerId) ? '-'+customerId : '');
        try{
            System.debug('--- InboundDataController - setCustomerAccount - Creating New Account');

            System.debug('--- InboundDataController - new Account Segment Code: '+segmentCode); 
            System.debug('--- InboundDataController - new Account Business Type Code: '+businessTypeCode); 
            System.debug('--- InboundDataController - new Account Country Code: '+countryCode); 
            Id ownerId = salesUser?.Id;
            System.debug('--- InboundDataController - new Account Owner(Sales User) Id: '+ownerId); 
            switch on businessTypeCode {
                when '1' { // Consumer
                    System.debug('--- InboundDataController - setCustomerAccount - Preparing New B2C Account'); 
                    //newAccount.IsPersonAccount = true;
                    newAccount.RecordTypeId = B2CAccountRecordTypeId;
                    newAccount.FirstName = customerData.firstName;
                    newAccount.LastName = customerData.lastName;
                    newAccount.PersonEmail = customerData.email;
                    newAccount.PersonMobilePhone = customerData.phone;
                    newAccount.PersonLeadSource = orderData.leadSource; 
                    //newAccount.LanguagePreference__c = orderData.languageCode; 
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
                    newAccount.UniqueId__c = customerIdentifier; 
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
            if (newAccount.isMigrated__c){
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
            if (String.isNotBlank(newAccount?.Id))  {
                customer = newAccount;
                System.debug('--- InboundDataController - setCustomerAccount - Customer => '+customer);
            }
            System.debug('--- InboundDataController - setCustomerAccount - CPU TIME: '+LIMITS.getCpuTime()); 
            System.debug('--- InboundDataController - setCustomerAccount - SOQL USED: ' + LIMITS.getQueries());
            return customer;

        } catch (Exception e){
            return null;
        }
    }
    /**
    * @description Set the Contact Record by creating a new Contact
    * @author Henk Reynders | 10-11-2024
    * @param  
    * @return Contact 
    **/
    public static Contact setCustomerContact(){
        try{
            System.debug('--- InboundDataController - setCustomerContact - Creating New Contact'); 
            Contact newContact = new Contact();
            Contact duplicateContact = new Contact();
            Contact customerContact = new Contact();
            Account newAccount = new Account();
            Account duplicateAccount = new Account();
            Account customerAccount = new Account();
            Id ownerId = getSalesUser()?.Id;
            switch on businessTypeCode {
                when '1' { // Consumer
                    System.debug('--- InboundDataController - setCustomerContact - Preparing New B2C Person Account (Contact)'); 
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
                    newContact.accountId = importedData?.account?.Id;
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
            System.debug('--- InboundDataController - setCustomerContact - Contact to Create => '+newContact);       
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
                            System.Debug('--- InboundDataController - setCustomerContact - Duplicate Contact Created: '+newContact?.Id);
                            System.Debug('--- InboundDataController - setCustomerContact - Duplicate Contact Existing: '+duplicateContact?.Id);
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
                                System.Debug('--- InboundDataController - setCustomerContact - Duplicate Account Created => '+newAccount?.Id);
                                System.Debug('--- InboundDataController - setCustomerContact - Duplicate Account Existing => '+duplicateAccount?.Id);
                            }
                        }
                    }
                }else{
                    System.Debug('--- InboundDataController - setCustomerContact - New Contact Created =>'+newContact?.Id);
                    
                }
                if (String.isNotBlank(newContact?.Id))  {
                    customerContact = newContact;
                    System.debug('--- InboundDataController - setCustomerContact - CustomerContact => '+customerContact);
                }
                if (String.isNotBlank(newAccount?.Id))  {
                    customer = newAccount;
                    System.debug('--- InboundDataController - setCustomerContact - Customer => '+customer);
                }
                System.debug('--- InboundDataController - setCustomerContact - CPU TIME: '+LIMITS.getCpuTime()); 
                System.debug('--- InboundDataController - setCustomerContact - SOQL USED: ' + LIMITS.getQueries());
            }
            return newContact;

        } catch (Exception e){
            return null;
        }
    }
    /**
    * @description Set the Opportunity Record by creating a new Opportunity
    * @author Henk Reynders | 10-12-2024 
    * @return Opportunity 
    **/
    public static Opportunity setOpportunity(){
        try{
            Opportunity newOpportunity = new Opportunity();
            Opportunity duplicateOpportunity = new Opportunity();
            // OrderData
            // Attributes
            Map<String,String> businessAttributes =  setBusinessAttributes();
            businessType = businessAttributes.get('businessType');
            // Salesforce Records
            Id customerId = getCustomerAccount()?.Id;
            System.Debug('--- InboundDataController - Opportunity Account Id : '+customerId );
            Id salesUserId = getSalesUser()?.Id;
            System.Debug('--- InboundDataController - Opportunity Owner : '+salesUserId );
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
            newOpportunity.Type = orderType;            
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
            if (String.isNotBlank(newOpportunity?.Id))  {
                opportunity = newOpportunity;
                System.debug('--- InboundDataController - setOpportunity - Opportunity => '+opportunity);
            }
            System.debug('--- InboundDataController - setOpportunity - CPU TIME: '+LIMITS.getCpuTime()); 
            System.debug('--- InboundDataController - setOpportunity - SOQL USED: ' + LIMITS.getQueries());
            return newOpportunity;
        } catch (Exception e){
            return null;
        }
    }
    /**
    * @description Set the Quote Record by creating a new (Standalone) Quote
    * @author Henk Reynders | 10-12-2024 
    * @return Quote 
    **/
    public static Quote setQuote(){
        Quote newQuote = new Quote();
        Quote duplicateQuote = new Quote();
        try{           
            switch on businessType {
                when '1' { // Consumer
                    if (String.IsNotBlank(importedData?.account?.Id)){
                        //newQuote.AccountId = orderData?.account?.Id;
                        newQuote.QuoteAccountId = importedData?.account?.Id;
                    }
                    if (String.IsNotBlank(importedData?.contact?.Id)){
                        newQuote.ContactId = importedData?.contact?.Id;
                    }
                    if (String.IsNotBlank(importedData?.opportunity?.Id)){
                        newQuote.opportunityId = importedData?.opportunity?.Id;
                    }
                    if (String.IsNotBlank(importedData?.salesUser?.Id)){
                        newQuote.OwnerId = importedData?.salesUser?.Id;
                    }
                    // Quote Values
                    //newQuote.Name = opportunityName;
                    newQuote.isMigrated__c = true;
                    newQuote.OfferNumber__c = offerNumber;                                    
                    // Business Attribute
                    newQuote.Organization__c  = organizationCode;
                    //newQuote.CountryCode__c  = countryCode;
                    //newQuote.District__c;
                    newQuote.ProfitCenter__c  = profitCenterCode;
                    newQuote.BusinessType__c = businessType;
                    newQuote.CustomerSegment__c = segmentCode;
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
            if (String.isNotBlank(newQuote?.Id))  {
                quote = newQuote;
                System.debug('--- InboundDataController - setQuote - Quote => '+quote);
            }
            System.debug('--- InboundDataController - setQuote - CPU TIME: '+LIMITS.getCpuTime()); 
            System.debug('--- InboundDataController - setQuote - SOQL USED: ' + LIMITS.getQueries());
            return newQuote;
        } catch (Exception e){
            return null;
        }
    }
    /**
    * @description Set the Contract Record by creating a new Contract
    * @author Henk Reynders | 10-12-2024 
    * @return Contract 
    **/
    public static Contract setContract(){
        try{
            Contract newContract = new Contract();
            Contract duplicateContract = new Contract();

            switch on businessType {
                when '1' { // Consumer
                    if (String.IsNotBlank(importedData?.account?.Id)){
                        //newContract.AccountId = orderData?.account?.Id;
                        newContract.AccountId = importedData?.account?.Id;
                    }
                    if (String.IsNotBlank(importedData?.salesUser?.Id)){
                        newContract.OwnerId = importedData?.salesUser?.Id;
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
                            System.Debug('--- InboundDataController - setContract - Duplicate Contract Created: '+newContract?.Id);
                            System.Debug('--- InboundDataController - setContract - Duplicate Contract Existing: '+duplicateContract?.Id);
                        }
                    }
                }else{
                    System.Debug('--- InboundDataController - setContract - New Contract => '+newContract?.Id);
                    
                }
            }
            System.debug('--- InboundDataController - setContract - CPU TIME: '+LIMITS.getCpuTime()); 
            System.debug('--- InboundDataController - setContract - SOQL USED: ' + LIMITS.getQueries());
            return newContract;
        } catch (Exception e){
            return null;
        }
    }
    /**
    * @description Set the Order Record by creating a new Order
    * @author Henk Reynders | 10-12-2024 
    * @return Order 
    **/
    public static Order setOrder(){
        try{
            Order newOrder = new Order();
            Order duplicateOrder = new Order();
            Id accountId = importedData?.account?.Id;
            switch on businessType {
                when '1' { // Consumer
                    if (String.IsNotBlank(importedData?.account?.Id)){
                        //newOrder.AccountId = orderData?.account?.Id;
                        newOrder.AccountId = importedData?.account?.Id;
                    }

                    if (String.IsNotBlank(importedData?.opportunity?.Id)){
                        newOrder.opportunityId = importedData?.opportunity?.Id;
                    }
                    if (String.IsNotBlank(importedData?.contract?.Id)){
                        newOrder.ContractId = importedData?.contract?.Id;
                    }
                    if (String.IsNotBlank(importedData?.salesUser?.Id)){
                        newOrder.OwnerId = importedData?.salesUser?.Id;
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
            if (String.isNotBlank(newOrder?.Id))  {
                order = newOrder;
                System.debug('--- InboundDataController - setOrder - Order => '+order);
            }
            System.debug('--- InboundDataController - setOrder - CPU TIME: '+LIMITS.getCpuTime()); 
            System.debug('--- InboundDataController - setOrder - SOQL USED: ' + LIMITS.getQueries());
            return newOrder;
        } catch (Exception e){
            return null;
        }
    }  
    /**
    * @description 
    * @author Henk Reynders | 10-12-2024 
    * @return Delivery_Batch__c 
    **/
    public static Delivery_Batch__c setDeliveryBatch(){   
        Delivery_Batch__c newBatch = new Delivery_Batch__c();
        InboundData.ProductLineData rvnProduct = productLineData[0];
        System.Debug ('--- InboundDataController - getDeliveryBatch - Project => '+projectNumber);
        System.Debug ('--- InboundDataController - getDeliveryBatch - Order => '+offerNumber);
        System.Debug ('--- InboundDataController - getDeliveryBatch - Profit Center => '+profitCenterCode);
        // Batch
        String batchNumber = rvnProduct.batchNumber; // "delivery_batch": "1",
        String batchStatus = rvnProduct.batchStatus; //"delivery_batch_status": "Mitattu",
        String orderDate = rvnProduct.orderDate; // "delivery_batch_receive_date": "25.10.2025",
        String deliveryDate = rvnProduct.deliveryDate; //"delivery_batch_delivery_date": "22.10.2025",
        String earliestStartDate = rvnProduct.earliestStartDate;//"install_start_date": "25.10.2025",
        String dueDate = rvnProduct.promisedDate;//"install_end_date": "21.11.2025",
        String warehouseCode = rvnProduct.warehouseCode; //"storageid": "VAN",
        String packingOrderCode = rvnProduct.packingOrderCode; //"packing_order": "1",
        String orderType = rvnProduct.orderType; // "process": "Normal"
        String batchIdentifier = projectNumber+' / '+offerNumber+'-'+deliveryBatch;
        newBatch.batchName__c = batchNumber;
        //newBatch.batchId__c = batchNumber;
        newBatch.BatchDeliveryDate__c = String.IsNotBlank(deliveryDate)? Date.parse(deliveryDate) : null; // Date sampleDate = Date.valueOf('2023-23-12');
        newBatch.BatchEarliestStartDate__c = String.IsNotBlank(earliestStartDate)? Date.parse(earliestStartDate) : null; // 
        newBatch.BatchDueDate__c = String.IsNotBlank(dueDate)? Date.parse(dueDate) : null; // 
        newBatch.Building_Project__c = mainProject?.Id; // 
        newBatch.Delivery_Project__c = subProject?.Id; // 
        Database.UpsertResult saveResult = Database.upsert(newBatch,false) ;
        if(saveResult.isSuccess()){
            //deliveryBatch.Batch_Status__c = 'Data imported';
        }else{
            //deliveryBatch.Batch_Status__c = 'New';
        }
        if (String.isNotBlank(newBatch?.Id))  {
            deliveryBatch = newBatch;
            System.debug('--- InboundDataController - setDeliveryBatch - Batch => '+deliveryBatch);
        }
        System.debug('--- InboundDataController - setDeliveryBatch - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- InboundDataController - setDeliveryBatch - SOQL USED: ' + LIMITS.getQueries());
        return newBatch;
    }
    /*public static void manageConfigurationPlanAndProduct(InboundOrderData.Order orderData, Account customer, Opportunity opportunityRecord, Delivery_Batch__c delbatchRec){
        Map<String,List<String>>  existingPlanMap = getExistingConfigPlanMap(orderData.order_info.order_number);
        for(String planKey : existingPlanMap.keySet()){
            System.Debug('--- FieldServiceInstallationHelper - Configuration Plan Key : '+planKey);
        }
        List<String> configProdsToBeDeleted = new List<String>();
        List<configuration__c> configurationPlanList = new List<configuration__c>();
        List<Configuration_Product__c> configurationProductList = new List<Configuration_Product__c>();
        System.debug('--- FieldServiceInstallationHelper - manageConfigurationPlanAndProduct - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- FieldServiceInstallationHelper - manageConfigurationPlanAndProduct - SOQL USED: ' + LIMITS.getQueries());
        
        Map<String, List<InboundOrderData.GroupRec>> configMap = getConfigurationPlanMap(orderData);
        System.Debug('--- FieldServiceInstallationHelper - Configuration Key Count : '+configMap.keySet().size());
        for(String configPlanKey: configMap.keySet()){
            System.Debug('--- FieldServiceInstallationHelper - Configuration Key : '+configPlanKey);
            List<String> rvns = new List<String>();
            if(existingPlanMap.containsKey(configPlanKey)){
                rvns = existingPlanMap.get(configPlanKey);
                existingPlanMap.remove(configPlanKey);
            }
            
            List<InboundOrderData.GroupRec> groupRecList =  configMap.get(configPlanKey);
            System.Debug('--- FieldServiceInstallationHelper - order : '+delbatchRec);
            System.Debug('--- FieldServiceInstallationHelper - group : '+groupRecList[0]);
            System.Debug('--- FieldServiceInstallationHelper - batch : '+delbatchRec.Batch_Id__c);

            configuration__c cfgPlan = assignConfigurationPlan(groupRecList[0],configPlanKey, customer, opportunityRecord, delbatchRec);
            if (cfgplan != NULL) {
                System.Debug('--- FieldServiceInstallationHelper - prepared Plan : '+cfgPlan);
                configurationPlanList.add(assignConfigurationPlan(groupRecList[0],configPlanKey, customer, opportunityRecord, delbatchRec));            
                for(InboundOrderData.GroupRec groupRec :groupRecList ){
                    Configuration_Product__c cfgProduct = assignConfigurationProduct(groupRec ,configPlanKey, rvns);
                    if (cfgProduct != NULL) {
                        configurationProductList.add(cfgProduct);
                    }
                }
                configProdsToBeDeleted.addAll(rvns);
            }
        }
        // Why REMOVE everything first?
        
        List<Configuration_Product__c> configurationProducts =[SELECT id,Name 
                                                                FROM Configuration_Product__c 
                                                                WHERE RVN_Number__c IN:configProdsToBeDeleted];
        delete configurationProducts;
        
        List<Configuration__c> configurationPlans =[SELECT id,Name,UniqueId__c 
                                                    FROM Configuration__c 
                                                    WHERE UniqueId__c IN:existingPlanMap.keySet()];
        delete configurationPlans;

        for ( Configuration__c cfgPlan : configurationPlanList){
            System.Debug('--- FieldServiceInstallationHelper - plan to Upsert : '+cfgPlan);
        }

        System.Debug('--- FieldServiceInstallationHelper - plans to Upsert : '+configurationPlanList);
        
        List<Database.upsertResult> upsertConfigPlanResult = Database.upsert(configurationPlanList, configuration__c.UniqueId__c);
        for ( Configuration_Product__c cfgProduct : configurationProductList){
            System.Debug('--- FieldServiceInstallationHelper - product to Upsert : '+cfgProduct);
        }
        
        List<Database.upsertResult> upsertConfigProdResult = Database.upsert(configurationProductList, Configuration_Product__c.RVN_Number__c);

        System.debug('--- FieldServiceInstallationHelper - manageConfigurationPlanAndProduct - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- FieldServiceInstallationHelper - manageConfigurationPlanAndProduct - SOQL USED: ' + LIMITS.getQueries());       
    }  */
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
    // Method to create configurationPlan
    /*public static configuration__c setConfigurationPlan(){
        System.Debug('--- FieldServiceInstallationHelper - find Configuration Plan for Configuration Product');
        configuration__c newConfiguration = new configuration__c();
        newConfiguration.Account__c = customerAccount.Id;
        
        newConfiguration.Opportunity__c = customerOpportunity.Id;
        newConfiguration.DeliveryBatch__c= deliveryBatch.Id;
        newConfiguration.DeliveryBatchNumber__c= deliveryBatch.Batch_number__c ;
        newConfiguration.UniqueId__c = configPlanKey;
        newConfiguration.OwnerId = salesPerson != NULL ? salesPerson.Id : UserInfo.getUserId();
        newConfiguration.PlanName__c = groupRec.salestori_plan_name;
        newConfiguration.Line__c =  String.valueOf(groupRec.OrderLine.Line);
        newConfiguration.Floor__c  = String.valueOf(groupRec.OrderLine.Floor);
        newConfiguration.ApartmentUnit__c  = groupRec.OrderLine.Apartment;
        //System.Debug('--- FieldServiceInstallationHelper - Configuration Plan Name: '+newConfiguration.PlanName__c);
        //System.Debug('--- FieldServiceInstallationHelper - Configuration Plan Floor: '+newConfiguration.Floor__c);
        //System.Debug('--- FieldServiceInstallationHelper - Configuration Plan Line: '+newConfiguration.Line__c);
        //System.Debug('--- FieldServiceInstallationHelper - Configuration Plan Unit: '+newConfiguration.ApartmentUnit__c);

        return newConfiguration;
    }
   
    // Method to create configuration product
    public static Configuration_Product__c setConfigurationProduct(InboundOrderData.GroupRec groupRec, String configPlanKey, List<String> rvnList){
        
        Configuration_Product__c  configProdRec = new Configuration_Product__c ();
        Configuration__c configurationRec = new Configuration__c(UniqueId__c= configPlanKey);
        configProdRec.Configuration__r = configurationRec;
        //Product2 productRec = new Product2(Sales_Code__c= String.valueOf(groupRec.OrderLine.ItemID)); 

        // PROBLEM -- this is called too Often 
        Product2 productRec;// = [SELECT Id,Name,Product_Group__c from Product2 where Sales_Code__c = : String.valueOf(groupRec.OrderLine.ItemID) limit 1];
        
        if(productRec != NULL){
            configProdRec.Product__c = productRec.Id;
            configProdRec.Name = productRec.Name;
            configProdRec.Product_Group__c = productRec.Product_Group__c;
            //configProdRec.Delivery_Batch__c = Integer.valueOf(groupRec.delivery_batch);
        }
        configProdRec.Quantity__c   = 1.00;
        configProdRec.RVN_Number__c = String.valueOf(groupRec.OrderLine.BOMVersion);
        //configProdRec.line=  String.valueOf(groupRec.OrderLine.Line);
        //configProdRec.Plan_Floor__c  = !String.isBlank(groupRec.OrderLine.Floor) ? Integer.valueOf(groupRec.OrderLine.Floor) : 0 ;
        //configProdRec.Plan_Apartment__c  = groupRec.OrderLine.Apartment;
        if(rvnList.contains(groupRec.OrderLine.BOMVersion)){
            rvnList.remove(rvnList.indexOf(groupRec.OrderLine.BOMVersion));
        }
        return configProdRec;
    }*/


    /**
    * @description Set the Building by creating new Building
    * @author Henk Reynders | 10-12-2024 
    * @return Asset
    **/
    public static Asset setBuildingAsset(){

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
                    System.Debug('--- InboundDataController - setBuildingAsset - Database Error on Building Create : '+error[0] );
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
                            System.Debug('--- InboundDataController - setBuildingAsset - Duplicate Building Created: '+newBuilding?.Id);
                            System.Debug('--- InboundDataController - setBuildingAsset - Duplicate Building Existing: '+duplicateBuilding?.Id);
                        }
                    }
                }else{
                    System.Debug('--- InboundDataController - setBuildingAsset - New Building Created: '+newBuilding?.Id);
                    
                }
            }
            System.debug('--- InboundDataController - setBuildingAsset - CPU TIME: '+LIMITS.getCpuTime()); 
            System.debug('--- InboundDataController - setBuildingAsset - SOQL USED: ' + LIMITS.getQueries());
            return newBuilding;
        } catch (Exception e){
            return null;
        }
    }
    /**
    * @description Set the Apartment by creating new Apartment
    * @author Henk Reynders | 10-12-2024 
    * @return Asset
    **/
    public static Asset setApartmentAsset(){
        try{
            Asset newApartment = new Asset();
            Asset duplicateApartment = new Asset();
            // Salesforce Records
            Id accountId = importedData?.account?.Id;
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
    * @author Henk Reynders | 10-12-2024 
    * @return Asset
    **/
    public static Asset setPlanAsset(){     
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
    * @description Set the Assets by creating new Assets
    * @author Henk Reynders | 10-12-2024 
    * @return List<Asset> 
    **/
    public static List<Asset> setProductAssets(){ 
        try{
            List<Asset> newProductAssets = new List<Asset>();
            List<Asset> duplicateAssets = new List<Asset>();
            // Salesforce Records
            Id accountId = importedData?.account?.Id;
            Id contactId = importedData?.contract?.Id;
            Id salesUserId = importedData?.salesUser?.Id; // Better to add this attribute to rvn Product
            Id servicesUserId = importedData?.servicesUser?.Id; // Better to add this attribute to rvn Product
            String assetType = 'Product';
            // ProductLineItem Data
            List<InboundData.ProductLineData> rvnProducts = getProductLineData();
            // Loop Through the Data
            Delivery_Batch__c parentBatch = getDeliveryBatch();
            Integer productCounter = 0;
            for (InboundData.ProductLineData rvnProduct : rvnProducts) {
                productCounter++;
                System.Debug('--- InboundDataController - setProductAssets Processing RVN Product '+productCounter+' : '+rvnProduct);
                Asset planAsset = getPlanAsset(rvnProduct);
                // Plan
                String planName = rvnProduct.planName; // Plan
                String planUnit = rvnProduct.planUnit; // Apartment
                String planLine = rvnProduct.planLine; // Apartment Attribute
                String planFloor = rvnProduct.planFloor; // Apartment Attribute
                String planIdentifier = planName + '_'+ planLine + '_'+ planFloor + '_'+planUnit;
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
                String orderType = rvnProduct.orderType;		
                String warehouseCode = rvnProduct.warehouseCode;
                String packingOrderCode = rvnProduct.packingOrderCode;

                // Installation 
                String attachment = rvnProduct.attachment;
                String hasInstallation = rvnProduct.hasInstallation;
                String isAxConfiguration = rvnProduct.isAxConfiguration;
                String earliestStartDate = rvnProduct.earliestStartDate;
                String dueDate = rvnProduct.promisedDate;

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
                        newProductAsset.RecordTypeId = productAssetRecordTypeId;
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
    /* -------------------- METHODS to PROCESS the Inbound Data -------------------- */      
    /**
    * @description Set the values for each of the Inner Classes of the Wrapper
    * @author Henk Reynders | 10-11-2024
    * @param inboundJson 
    **/
    public static void processInboundData(String inboundJson){
        // Do not Process Delivery Only Orders
        // Parse the Message into Inbound Order Data Wrapper Class
        try {
            //setInboundData(inboundJson);
            setOrderMessage(inboundJson);
            setRecordData();
            setLookups();
            setRecords();
        } catch (Exception e){

        }
        System.debug('--- InboundDataController - OrderMessage => '+orderMessage); 
    }  
    /**
    * @description Set the values for each of the Main Classes of the Wrapper
    * @author Henk Reynders | 10-11-2024
    * @param inboundJson 
    **/
    public static void setOrderMessage(String inboundJson){
        orderMessage =  getOrderMessage(inboundJson); 
        System.debug('--- InboundDataController - OrderMessage => '+orderMessage); 
    }  
    /**
    * @description Set the values for each of the Inner Classes of the Wrapper
    * @author Henk Reynders | 10-11-2024
    * @param inboundJson 
    **/
    public static void setRecordData(){
        // Get the various Innerclasses
        orderData = getOrderData();
        System.debug('--- InboundDataController - setData - OrderData => '+orderData);   
        projectData = getProjectData();
        System.debug('--- InboundDataController - setData - ProjectData => '+projectData); 
        costData = getCostData();   
        System.debug('--- InboundDataController - setData - CostData => '+costData); 
        userData = getUserData();   
        System.debug('--- InboundDataController - setData - UserData => '+userData); 
        customerData = getCustomerData();   
        System.debug('--- InboundDataController - setData - CustomerData => '+customerData); 
        invoicingData = getInvoicingData();   
        System.debug('--- InboundDataController - setData - InvoicingData => '+invoicingData); 
        deliveryData = getDeliveryData();   
        System.debug('--- InboundDataController - setData - DeliveryData => '+deliveryData);  
        installationData = getInstallationData();   
        System.debug('--- InboundDataController - setData - InstallationData => '+installationData); 
        productData =  getProductData();
        System.debug('--- InboundDataController - setData - ProductData => '+productData);
        productLineData =  getProductLineData();
        System.debug('--- InboundDataController - setData - ProductLineData => '+productLineData);
    }
    /**
    * @description Set the values for each of the Inner Classes of the Wrapper
    * @author Henk Reynders | 10-11-2024
    * @param inboundJson 
    **/
    public static void setLookups(){
        countryLookup = setCountryCodes(); 
        System.debug('--- InboundDataController - getLookups - Country Map => '+countryLookup); 
        personLookup = setPersons(); 
        System.debug('--- InboundDataController - getLookups - Person Map => '+personLookup);  
        userLookup = setUsers(); 
        System.debug('--- InboundDataController - getLookups - User Map => '+userLookup);  
        officeLookup = getOffices(); 
        System.debug('--- InboundDataController - getLookups - Office Map => '+officeLookup);  
        projectLookup = setProjectAttributes();   
        System.debug('--- InboundDataController - getLookups - Project Attributes => '+projectLookup);  
        businessLookup = setBusinessAttributes();   
        System.debug('--- InboundDataController - getLookups - Business Attributes => '+businessLookup);  
        planLookup = setPlans();
        System.debug('--- InboundDataController - getLookups - Plans => '+planLookup);  
        //productAssetLookup = getProductAssets();       
        //System.debug('--- InboundDataController - Product Assets: '+productAssets);   
    }
    /**
    * @description Set the Records for the required Objects and store them
    * @author Henk Reynders | 10-11-2024
    * @param inboundJson 
    **/
    public static void setRecords(){
        // Do not Process Delivery Only Orders
        // Parse the Message into Inbound Order Data Wrapper Class
        // Check for Salesforce Records  
        customer = getCustomerAccount();
        System.debug('--- InboundDataController - Customer Account => '+customer);   
        mainProject = getBuildingProject();
        System.debug('--- InboundDataController - Building Project => '+mainProject);   
        subProject = getDeliveryProject();       
        System.debug('--- InboundDataController - Delivery Project => '+subProject);   
        opportunity = getOpportunity();        
        System.debug('--- InboundDataController - Opportunity => '+opportunity);   
        quote = getQuote();
        System.debug('--- InboundDataController - Quote => '+quote);   
        contract = getContract();
        System.debug('--- InboundDataController - Contract => '+contract);        
        deliveryBatch = getDeliveryBatch();
        System.debug('--- InboundDataController - Batch => '+deliveryBatch); 
            
    }
}