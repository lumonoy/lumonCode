/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 08-25-2024
 * @last modified by  : Henk Reynders
**/
public class FieldServiceWorkController {
    public static String b2bOpportunityRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('B2B_Opportunity').getRecordTypeId();
    public static String b2cOpportunityRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('B2C_Opportunity').getRecordTypeId();
    public static String b2bAccount = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('B2B_Account').getRecordTypeId();
    public static String b2cAccount = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
    public static User projectOwner;
    public static User projectManager;
    public static String languageCode;
    public static String leadSource;
    public static String currencyCode;
   	public static Map<String,Country_Mapping__mdt> countryMap = new Map<String,Country_Mapping__mdt>();
    public static List<Country_Mapping__mdt> countryMapList = [SELECT CountryCodeAlpha3__c, CountryCodeAlpha2__c ,Country_Name__c  FROM Country_Mapping__mdt];
    
    /**
    * @description 
    * @author Henk Reynders | 07-04-2024 
    * @param projectData 
    **/
    public static void getProjectData(ProjectData projectData){	
        ProjectData.OrderMessage orderMessage = projectData.orderMessage;
        ProjectData.CustomerProject mainProjectData = orderMessage.project;
        ProjectData.CustomerAddress customerData = mainProjectData.customerAddress;
        ProjectData.SalesPerson salesPerson = mainProjectData.salesPerson;
        Account customerAccount = new Account();
        String salesPersonUserName;
        String supervisorUserName;
        String customerProjectNumber;
        Building_Project__c customerProject = new Building_Project__c();
        System.debug('--- FieldServiceWorkController - orderMessage '+orderMessage);
        System.debug('--- FieldServiceWorkController - customerProject: '+mainProjectData);

        // Step 1: Customer => "Buyer Account" 
        customerAccount = findCustomer(customerData,salesPerson);

        // Step 2: Responsible Users => "SalesPerson" + "Installation Manager" 
        salesPersonUserName = String.isNotBlank(salesPerson.username) ? salesPerson.username : '';
        supervisorUserName = String.isNotBlank(salesPerson.supervisor) ? salesPerson.supervisor : '';

        // Step 2: Main Project => "Project" = bundle of Customer Related Orders     
        customerProjectNumber = String.isNotBlank(mainProjectData.projectNumber) ? mainProjectData.projectNumber : ''; //"project_number": "803086",
        System.debug('--- FieldServiceWorkController - customerProject Identifier: '+customerProjectNumber);
        customerProject = findCustomerProject(mainProjectData);
        System.debug('--- FieldServiceWorkController - customerProject: '+customerProject);

        // Step 3: SubProject => "Offer/Contract" = single Customer related Order
        ProjectData.SubProject subProject = mainProjectData.subProject;
        System.debug('--- FieldServiceWorkController - subProject: '+subProject);
        String subProjectNumber = String.isNotBlank(subProject.projectNumber) ? subProject.projectNumber : ''; //"subproject_number": "803086_01",
        System.debug('--- FieldServiceWorkController - subProjectNumber: '+subProjectNumber);
        Delivery_Project__c deliveryProject = findDeliveryProject(subProject);
        System.debug('--- FieldServiceWorkController - deliveryProject: '+deliveryProject);
    }
        
    public static ProjectData.ProjectAttributes setCustomerProjectData(ProjectData.CustomerProject mainProjectData){
        ProjectData.ProjectAttributes attributes = new ProjectData.ProjectAttributes();
        // Business Attributes
        String organizationCode = String.isNotBlank(mainProjectData.organizationCode) ? mainProjectData.organizationCode : ''; //"axcompanyid": "LSU"
        String profitCenterCode = String.isNotBlank(mainProjectData.profitCenterCode) ? mainProjectData.profitCenterCode : ''; //"business_unit": "401",
        String customerSegmentCode = String.isNotBlank(mainProjectData.customerSegmentCode) ? mainProjectData.customerSegmentCode : ''; //"customer_segmentid": "4000",
        String currencyCode = String.isNotBlank(mainProjectData.currencyCode) ? mainProjectData.currencyCode : ''; // "currency": "EUR"
        //Order
        String orderType = String.isNotBlank(mainProjectData.orderType) ? mainProjectData.orderType : ''; //"order_type": "Normal"
        String languageCode = String.isNotBlank(mainProjectData.languageCode) ? mainProjectData.languageCode : '';//"promised_deliveryweek": "2024/31",
        String leadSource = String.isNotBlank(mainProjectData.leadSource) ? mainProjectData.leadSource : '';//"promised_date": "01.11.2024",
        // Delivery
        String deliveryWeek = String.isNotBlank(mainProjectData.deliveryWeek) ? mainProjectData.deliveryWeek : '';//"promised_deliveryweek": "2024/31",
        String deliveryDate = String.isNotBlank(mainProjectData.deliveryDate) ? mainProjectData.deliveryDate : '';//"promised_date": "01.11.2024",
        String factoryCode = String.isNotBlank(mainProjectData.factoryCode) ? mainProjectData.factoryCode : '';//"vendorid": "LU"
        String contractor = String.isNotBlank(mainProjectData.contractor) ? mainProjectData.contractor : '';//"main_contractor": "no",
        // Users
        // Find Project  
        /*Opportunity opportunity = getOpportunity(ProjectData, customerAccount);*/
        // Process the Order Line Items
        //getAssetData(projectData);
        //getOrderData(projectData);
        return attributes;
    }
    public static void getOrderData(ProjectData projectData){
        // Order aka Delivery Batch
        ProjectData.DeliveryBatch deliveryData = projectData.orderMessage.delivery;
        System.debug('--- FieldServiceWorkController - delivery Data: '+deliveryData);
        Integer batchNumber;
        Set<String> batchNumbers = new Set<String>(); 
        List<String> batchNumberList = new List<String>();
        // LineItems
        List<ProjectData.LineItem> productData = deliveryData.products;
        for (ProjectData.LineItem lineItem : productData) {
            System.debug('--- FieldServiceWorkController - Order Sequence Number for Offer (BatchNumber): '+lineItem.batchNumber);
            batchNumbers.add(lineItem.batchNumber);
        }
        if (batchNumbers?.size() > 0) {
            batchNumberList.addAll(batchNumbers);
            batchNumber = String.isNotBlank(batchNumberList[0]) ? Integer.ValueOf(batchNumberList[0]) : 0; //Set to 0 for default Batch
        } else {
            batchNumber = 0;
        }
        //Delivery_Batch__c batch = getBatch(batchNumber, offer.Id);
        //System.debug('--- FieldServiceWorkController - batch: '+batch);
        
        //Delivery_Batch__c deliveryBatchRec = createDeliveryBatch(ProjectData,customerAccount,oppRec);
        //manageConfigurationPlanAndProduct(ProjectData,customerAccount,oppRec,deliveryBatchRec);
        
        //Order newOrder = createOrder(ProjectData,customerAccount,oppRec);
        //manageConfigurationPlanAndProduct(ProjectData,customerAccount,oppRec,deliveryBatchRec);
        //WorkOrder workOrderRec = createWorkOrder(ProjectData,customerAccount, oppRec, deliveryBatchRec);
        //List<WorkOrderLineItem> woliList =  createWorkOrderLines( ProjectData, workOrderRec, deliveryBatchRec);
        
        //Map<String,ContentDocumentLink> existingPDFMap = getExistingInstallationPDFFiles(woliList);
        //createInstallationPDFFiles(ProjectData,existingPDFMap,woliList);
    }

    public static Building_Project__c findCustomerProject(ProjectData.CustomerProject mainProjectData){
        Building_Project__c customerProject = new Building_Project__c();
        String projectNumber = String.isNotBlank(mainProjectData.projectNumber) ? mainProjectData.projectNumber : ''; //"number": "320719",
        System.debug('--- FieldServiceWorkController - Building Project Number: '+projectNumber);
        customerProject = getCustomerProject(projectNumber);
        if (String.isBlank(customerProject.Id)) {
            //customerProject = upsertCustomerProject(mainProjectData);
        }
        return customerProject;
    }
    public static Delivery_Project__c findDeliveryProject(ProjectData.SubProject DeliveryProjectData){
        Delivery_Project__c deliveryProject = new Delivery_Project__c();
        String projectNumber = String.isNotBlank(DeliveryProjectData.projectNumber) ? DeliveryProjectData.projectNumber : ''; //"number": "320719",
        System.debug('--- FieldServiceWorkController - Delivery Project Number: '+projectNumber);
        deliveryProject = getDeliveryProject(projectNumber);
        if (String.isBlank(deliveryProject.Id)) {
            //customerProject = upsertcustomerProject(projectNumber);
        }
        return deliveryProject;
    }
    public static Account findCustomer(ProjectData.CustomerAddress customerData, ProjectData.SalesPerson salesPersonData){ 
        Account customerAccount = new Account();
        String customerNumber = String.isNotBlank(customerData.customerNumber) ? customerData.customerNumber : ''; //"number": "320719",
        System.debug('--- FieldServiceWorkController - customerNumber: '+customerNumber);
        if (String.isNotBlank(customerNumber)) {
            customerAccount = getCustomer(customerNumber);
        }
        if (String.isBlank(customerAccount.Id)) {
            //customerAccount = upsertCustomer(customerData, salesPersonData);
        }
        return customerAccount;
    }
    public static Contact findContact(ProjectData.CustomerProject CustomerProject, String contactType){
        Contact contact = new Contact();
        String contactPerson;
        switch on contactType {
            when 'customer' {
                contactPerson = String.isNotBlank(CustomerProject.customerAddress.contactPerson) ? CustomerProject.customerAddress.contactPerson : '';
            }
            when 'invoicing' {
                contactPerson = String.isNotBlank(CustomerProject.invoicingAddress.contactPerson) ? CustomerProject.invoicingAddress.contactPerson : ''; 
            }
            when 'installation' {}
            when 'delivery'{}
            when else {}
        }
        contact = getContact(contactPerson);
        if (String.isBlank(contact.Id)) {
            //contact = upsertContact(contactPerson);
        }
        return contact;
    }
    public static Delivery_Batch__c findDeliveryBatch(ProjectData.DeliveryBatch batchData){
        Delivery_Batch__c deliveryBatch = new Delivery_Batch__c();
        //String batchIdentifier = batchData.products.;
        //deliveryBatch = getDeliveryBatch(batchIdentifier);

        //if (String.isBlank(deliveryBatch.Id)) {
        //    //contact = upsertContact(contactPerson);
        //}
        return deliveryBatch;
    }
    public static Configuration__c findConfiguration(ProjectData.LineItem configProductData){
        Configuration__c configPlan = new Configuration__c();
        String planIdentifier = configProductData.planName;
        //configPlan = getConfigurationPlan(planIdentifier);
        if (String.isBlank(configPlan.Id)) {
            //contact = upsertContact(contactPerson);
        }
        return configPlan;
    }
    public static Configuration_Product__c findConfigurationProduct(ProjectData.LineItem configProductData){
        Configuration_Product__c configProduct = new Configuration_Product__c();
        String serialNumber = configProductData.serialNumber;
        //configProduct = getConfigurationProduct(serialNumber);
        if (String.isBlank(configProduct.Id)) {
            //contact = upsertContact(contactPerson);
        }
        return configProduct;
    }
    public static String getCountryCode(String countryAlpha3)  {
        String countryAlpha2 = [SELECT CountryCodeAlpha3__c, CountryCodeAlpha2__c ,Country_Name__c  FROM Country_Mapping__mdt WHERE CountryCodeAlpha3__c =: countryAlpha3]?.CountryCodeAlpha2__c;
        return countryAlpha2;
    }
    public static User getUserRecord(String userIdentifier){
        List<User> userRec =[SELECT Id,Name FROM User WHERE AD_Short_Username__c =:userIdentifier];
        if(userRec.size() > 0){
            return userRec[0]; 
        }else{
            return null;
        }
    }
    public static Building_Project__c getCustomerProject(String projectNumber){
        return ProjectController.getCustomerProjectByNumber(projectNumber);
    }
    public static Delivery_Project__c getDeliveryProject(String projectNumber){
        return ProjectController.getDeliveryProjectByNumber(projectNumber);
    }
    public static Account getCustomer(String customerNumber){
        return AccountController.getAccountByNumber(customerNumber);
    }
    public static Contact getContact(String contactName){
        return ContactController.getContactByName(contactName);
    }
    public static Product2 getProduct(String productNumber){
        return ProductController.getProductByNumber(productNumber);
    }

    /**
    * @description Retrieve the Building Asset
    * @author Henk Reynders | 08-25-2024 
    * @param serialNumber 
    * @return Asset 
    **/
    public static Asset getBuildingAsset(String serialNumber){
        return AssetController.getAssetByNumber(serialNumber);
    }
    public static Asset setBuildingAsset(ProjectData.CustomerProject mainProject){
        ProjectData.DeliveryAddress deliveryAddress;
        ProjectData.InstallationAddress installationAddress;
               
        Asset newBuilding = new Asset();     
        newBuilding.Name =  installationAddress.contactName;//   
        newBuilding.Description =  installationAddress.description;//"address_description": "Integration 24.6 Test FS",
        //newBuilding.Address = ;
        newBuilding.Street = installationAddress.installationStreet;
        newBuilding.PostalCode = installationAddress.installationPostalCode;
        newBuilding.City = installationAddress.installationCity;
        //newBuilding.State,                      
        //newBuilding.StateCode, 
        //newBuilding.Country, 
        //newBuilding.CountryCode, 
        //newBuilding.Latitude, 
        //newBuilding.Longitude
            /* {get;set;} 
		public String contactPerson {get;set;} 
		public String contactFirstname {get;set;} 
		public String contactLastname {get;set;} 
		public String contactPhone {get;set;} 
		public String contactEmail {get;set;} 
		public String contactFax {get;set;} */
            /*OwnerId, 
            LocationId, 
            ContactId, 
            AccountId, 
            ParentId, RootAssetId, 
            Product2Id, ProductCode, 
            ProductFamily, ProductDescription, 
            IsCompetitorProduct,                                    
            CreatedDate, CreatedById, 
            LastModifiedDate, LastModifiedById, 
            SystemModstamp, IsDeleted, 
            CurrencyIsoCode, SerialNumber, 
            InstallDate, ManufactureDate, 
            PurchaseDate, UsageEndDate,
            Status, 
            StatusReason,                                     
            Uuid, ExternalIdentifier, 
            Price, Quantity, 
            Description, 
            AssetProvidedById, AssetServicedById, 
            IsInternal, AssetLevel, StockKeepingUnit, */
        return newBuilding;
    }
    public static Asset getApartmentAsset(String serialNumber){
        return AssetController.getAssetByNumber(serialNumber);
    }
    public static Asset getPlanAsset(String serialNumber){
        return AssetController.getAssetByNumber(serialNumber);
    }
    public static Asset getProductAsset(String serialNumber){
        return AssetController.getAssetByNumber(serialNumber);
    }
    public static Asset getAsset(String serialNumber){
        return AssetController.getAssetByNumber(serialNumber);
    }
    public static Configuration__c getConfigurationPlan(String planNumber){
        return ConfigurationPlanController.getConfigurationPlanByNumber(planNumber);
    }
    public static Configuration_Product__c getConfigurationProduct(String rvnNumber){
        return ConfigurationProductController.getConfigurationProductByNumber(rvnNumber);
    }
    public static Quote getQuote(String offerNumber){
        return QuoteController.getQuoteByNumber(offerNumber);
    }
    public static Contract getContract(String contractNumber){
        return ContractController.getContractByNumber(contractNumber);
    }
    public static Order getOrder(String orderNumber){
        return OrderController.getOrderByNumber(orderNumber);
    }
    public static List<OrderItem> getOrderProducts(Id recordId){
        List<OrderItem> existingOrderProducts = OrderLineItemController.getOrderLineItems(recordId);
        return existingOrderProducts;
    }
    /*public static Delivery_Batch__c getDeliveryBatch(String batchNumber){
        Delivery_Batch__c deliveryBatch = DeliveryBatchController.getDeliveryByNumber(batchNumber);
        return deliveryBatch;
    } */
    public static Delivery_Batch__c getBatch(Integer batchNumber, Id quoteId){
        Id batchId;
        Delivery_Batch__c deliveryBatch = new Delivery_Batch__c();
        Map<String,List<Delivery_Batch__c>> deliveryBatchMap = DeliveryBatchController.getDeliveryBatchMap(new List<Id> {quoteId});
        if (deliveryBatchMap.containsKey(quoteId)) {
            List<Delivery_Batch__c> batches = deliveryBatchMap.get(quoteId);
            if (batches?.size()>0) {
                for (Delivery_Batch__c batch : batches) {
                    if (Integer.ValueOf(batch.Batch_Number__c) == batchNumber){
                        batchId = batch.Id;
                    }
                }
            }
            if (String.IsNotBlank(batchId)) {
                deliveryBatch  = DeliveryBatchController.getDeliveryBatch(batchId);
            }
        }
        return deliveryBatch;
    } 
    public static WorkOrder getWorkOrder(String workOrderNumber){
        return WorkOrderController.getWorkOrderByNumber(workOrderNumber);
    } 
    public static List<WorkOrderLineItem> getWorkOrderLineItems(Id recordId){
        List<WorkOrderLineItem> existingWorkOrderLines = new List<WorkOrderLineItem>();
        return WorkOrderLineItemController.getWorkOrderLineItems(new List<Id> {recordId});
    }

    public static Account upsertCustomer(ProjectData.CustomerAddress customerData,ProjectData.SalesPerson salesPerson){       
        Account newAccount = new Account();    
        User salesUser = getUserRecord(salesPerson.username);
        String customerNumber = customerData?.customerId;       
        try{
            if (String.isBlank(customerNumber)) {
                System.Debug('--- FieldServiceWorkController - Create New Account from : '+customerData);

                newAccount.Business_Type__c = '1'; //'Consumer';
                newAccount.RecordTypeID=b2cAccount;
                newAccount.FirstName= customerData?.contactFirstName;
                newAccount.LastName= customerData?.contactLastName;
                newAccount.PersonEmail= customerData?.contactEmail;
                newAccount.PersonMobilePhone = customerData?.contactphone;
                newAccount.PersonMailingCity= customerData?.customerCity;
                newAccount.PersonMailingCountryCode = getCountryCode(customerData?.customerCountry);
                newAccount.PersonMailingPostalCode = customerData?.customerPostalCode;
                newAccount.PersonMailingStreet= customerData?.customerStreet;
                newAccount.OwnerId = String.isNotBlank(salesUser.Id) ? salesUser.Id : UserInfo.getUserId();                                
                System.Debug('--- FieldServiceWorkController - New Account to Create : '+newAccount);
                Database.UpsertResult upsertResult =  Database.upsert(newAccount,Account.Person_Id__c) ;
                if (!upsertResult.isSuccess()) {
                    List<Database.Error> error = upsertResult.getErrors();
                    System.Debug('--- FieldServiceWorkController - Database Error on Account Upsert : '+error[0] );
                    if (error[0] instanceof Database.DuplicateError) {
                        Database.DuplicateError duplicateError = (Database.DuplicateError)error[0];
                        Datacloud.DuplicateResult duplicateResult = duplicateError.getDuplicateResult();
                        Datacloud.MatchResult[] matchResults = duplicateResult.getMatchResults();
                        Datacloud.MatchResult matchResult = matchResults[0];
                        Datacloud.MatchRecord[] matchRecords = matchResult.getMatchRecords();
                        for (Datacloud.MatchRecord matchRecord : matchRecords) {
                            newAccount = (Account)matchRecord.getRecord();
                        }
                    }
                    System.Debug('--- FieldServiceWorkController - Existing Account : '+newAccount?.Id);
                    return newAccount;
                }else{
                    System.Debug('--- FieldServiceWorkController - Created Account : '+newAccount?.Id);
                    return newAccount;
                }
            }
        }catch(Exception e){
            return null;
        }
        return newAccount;
    }
    public static Building_Project__c upsertCustomerProject(ProjectData.CustomerProject mainProjectData){           
        Building_Project__c newCustomerProject = new Building_Project__c();

        Account customer = findCustomer(mainProjectData.customerAddress, mainProjectData.salesPerson);
        newCustomerProject.Customer__c = customer.Id;
        //newCustomerProject.Name = customerProject.
        //newCustomerProject.ProjectStartData__c = Date.Today();
        //newCustomerProject.ProjectEndData__c = Date.Today();
        newCustomerProject.ProjectType__c = String.IsNotBlank(mainProjectData.projectType) ? mainProjectData.projectType : '';
        //newCustomerProject.ProjectStatus__c; Default is Draft
        //newCustomerProject.ProjectManager__c;
        //newCustomerProject.SalesManager__c;
        //newCustomerProject.Organization__c= delbatchRec.Id;
        //newCustomerProject.Vendor__c= delbatchRec.Id; // 'LU'
        return newCustomerProject;
    }
        // Method to create configurationPlan
    public static configuration__c upsertConfigurationPlan(ProjectData.DeliveryBatch delivery, Id customerId){
            
        configuration__c configPlanRec = new configuration__c();
        configPlanRec.Account__c = customerId;
        //configPlanRec.Name = groupRec.salestori_plan_name;
        //configPlanRec.Opportunity__c = oppRec.Id;
        //configPlanRec.Delivery_Batch__c= delbatchRec.Id;
        //configPlanRec.SalesToriConfigKey__c = uniqueKey;
        //configPlanRec.OwnerId = salesPerson != NULL ? salesPerson.Id : UserInfo.getUserId();
        return configPlanRec;
    }
    /*public static List<Configuration_Product__c> upsertConfigurationProducts(ProjectData.DeliveryBatch delivery){
        List<Configuration_Product__c> configProductsToUpsert = new List<Configuration_Product__c>();
        Configuration_Product__c  newConfigProduct = new Configuration_Product__c ();
        for (ProjectData.ConfigurationProduct rvnProduct : delivery.products) {
            String planName = String.isNotBlank(rvnProduct.planName)? rvnProduct.planName : ''; //salestori_plan_name
            String floor = String.isNotBlank(rvnProduct.floor)? rvnProduct.floor : '';
            String line = String.isNotBlank(rvnProduct.line)? rvnProduct.line : ''; 
            String unit = String.isNotBlank(rvnProduct.unit)? rvnProduct.unit : '';
            String planIdentifier = String.isNotBlank(planName)? planName : '';
            Configuration__c configPlan = findConfiguration(rvnProduct);
            String productCode = rvnProduct.productCode;
            String serialNumber = rvnProduct.productSerialNumber;
            //Product2 productRec = new Product2(Sales_Code__c= String.valueOf(groupRec.OrderLine.ItemID)); 
            Product2 product = getProduct(productCode);
            Configuration_Product__c configProduct = getConfigurationProduct(serialNumber);
            if(String.isNotBlank(configPlan.Id)){
                newConfigProduct.Configuration__c = configPlan.Id;
                if(String.isNotBlank(product.Id)){
                    newConfigProduct.Product__c = product.Id;
                    newconfigProduct.Name = product.Name;
                }
                if(String.isNotBlank(configProduct.Id)){
                    newConfigProduct.Id = configProduct.Id;
                }
                
                //newConfigProduct.Product_Group__c = productRec.Product_Group__c;
                //newConfigProduct.Delivery_Batch__c = Integer.valueOf(groupRec.delivery_batch);
                newConfigProduct.Quantity__c   = 1.00; // Always 1
                newConfigProduct.SerialNumber__c = serialNumber;
                configProductsToUpsert.add(newConfigProduct);
                System.Debug('--- FieldServiceWorkController - Product to Upsert : '+newConfigProduct);
            }
        }
        if(configProductsToUpsert?.size()>0){
            System.Debug('--- FieldServiceWorkController - '+configProductsToUpsert?.size()+ ' Configuration Product(s) to Upsert');
            upsert configProductsToUpsert;
        }
        return configProductsToUpsert;
    }*/
    public static Delivery_Project__c upsertDeliveryProject(ProjectData.SubProject subProject, Id projectId, Id customerId){       
        Delivery_Project__c newDeliveryProject = new Delivery_Project__c();
        try {
            newDeliveryProject.BuildingProject__c = projectId; //"subproject_parentproject": "803086",
            newDeliveryProject.ProjectNumber__c = subProject.projectNumber; //"subproject_number": "803086_01",
            //newDeliveryProject.ProjectCategory__c = subProject.projectCategory; //"subproject_category": "Warranty",
            newDeliveryProject.ProjectType__c = subProject.projectType; //"subproject_group": "PROWar",
            newDeliveryProject.OrderType__c = subProject.orderType; //"subproject_orderType": "Reclamation",
            
            newDeliveryProject.isChargeable__c = subProject.chargeable == 'non-chargeable' ? false : true ; //"subproject_chargeable": "non-chargeable"
            newDeliveryProject.underWarranty__c = subProject.projectCategory == 'Warranty' ? true : false ;
            
            //newDeliveryProject.ProjectCost__c = subProject.projectCost; //"subproject_cost": "296.90",
            newDeliveryProject.Customer__c = customerId;
            upsert newDeliveryProject;
            
        }catch(Exception e){
            throw new customException(e.getMessage());
        }
        return newDeliveryProject;      
    }

    /*public static Opportunity upsertOpportunity(ProjectData.SubProject subProject, Id projectId, Id customerId){       
        Opportunity newOpportunity = new Opportunity();    
        newOpportunity = offer.chargeable;

        public String offerCategory {get;set;} //"subproject_category": "Warranty",
		public String isChargeable__c{get;set;} //"subproject_chargeable": "non-chargeable"
		public String offerCost {get;set;} //"subproject_cost": "296.90",
		public String offerGroup {get;set;} //"subproject_group": "PROWar",
		public String offerNumber {get;set;} //"subproject_number": "803086_01",
		public String offerType {get;set;} //"subproject_ordertype": "Reclamation",
		public String offerParent {get;set;} //"subproject_parentproject": "803086",
        
        newQuote.QuoteAccountId = customerId;
        ContractNumber:
        newQuote.Status;
    public static Quote upsertQuote(ProjectData.Offer offer, Id projectId, Id customerId){       
        Quote newQuote = new Quote();    

        public String offerCategory {get;set;} //"subproject_category": "Warranty",
		public String offerChargeable {get;set;} //"subproject_chargeable": "non-chargeable"
		public String offerCost {get;set;} //"subproject_cost": "296.90",
		public String offerGroup {get;set;} //"subproject_group": "PROWar",
		public String offerNumber {get;set;} //"subproject_number": "803086_01",
		public String offerType {get;set;} //"subproject_ordertype": "Reclamation",
		public String offerParent {get;set;} //"subproject_parentproject": "803086",
        
        newQuote.QuoteAccountId = customerId;
        ContractNumber:
        newQuote.Status;*/
    /*public static Contract upsertContract(ProjectData.SalesOrder salesOrder, Id customerProjectId){       
        Contract newContract = new Contract();    

        public String orderCategory {get;set;} //"subproject_category": "Warranty",
		public String orderChargeable {get;set;} //"subproject_chargeable": "non-chargeable"
		public String orderCost {get;set;} //"subproject_cost": "296.90",
		public String orderGroup {get;set;} //"subproject_group": "PROWar",
		public String orderNumber {get;set;} //"subproject_number": "803086_01",
		public String orderType {get;set;} //"subproject_ordertype": "Reclamation",
		public String orderParent {get;set;} //"subproject_parentproject": "803086",
        newContract.ContractNumber:
        newContract.Status;

        ProjectData.CustomerProject customerProject = orderMessage.project;
        ProjectData.CustomerAddress customerData = customerProject.customerData;
        ProjectData.InvoicingAddress invoicingAddress = customerProject.invoicingAddress;
        Account customer = findCustomer(orderMessage);
        Id accountId = customer.Id;
        System.Debug('--- FieldServiceWorkController - Create New Contract for Customer : '+accountId);
        String customerNumber = customer.AccountNumber;
        String offerNumber = customerProject?.offerNumber;
        String projectNumber = customerProject?.customerProjectNumber;
        String currencyCode = customerProject?.currencyCode;
        String salesPerson = customerProject?.salesPerson?.salesPersonId;
        User salesUser = getUserRecord(salesPerson);  

        System.Debug('--- FieldServiceWorkController - Create New Contract on behalf of User : '+salesUser.Id);     
        try{
            System.Debug('--- FieldServiceWorkController - Create New Contract from : '+CustomerProject);
            newContract.OfferNumber__c = offerNumber;
            newContract.isMigrated__c = true;
            newContract.AccountId = accountId;
            //newContract.ActivatedById
            //newContract.ActivatedDate
            //newContract.BillingAddress
            //newContract.CompanySignedId
            //newContract.CompanySignedDate
            //newContract.CurrencyIsoCode
            //newContract.EndDate
            //newContract.Name
            //newContract.ContractNumber
            //newContract.OwnerId
            //newContract.RecordTypeId
            //newContract.StartDate
            //newContract.ContractTerm
            //newContract.CreatedById
            //newContract.CustomerSignedId
            //newContract.CustomerSignedDate
            //newContract.CustomerSignedTitle
            //newContract.Description
            //newContract.LastModifiedById
            //newContract.OwnerExpirationNotice
            //newContract.Pricebook2Id
            //newContract.ShippingAddress
            //newContract.SpecialTerms
            newContract.Status = 'Draft';
            System.Debug('--- FieldServiceWorkController - Contract to Upsert : '+newContract);
            Database.SaveResult upsertResult =  Database.insert(newContract,false) ;
            //Database.UpsertResult upsertResult =  Database.upsert(newContract,Order.ProjectNumber__c) ;
            if (!upsertResult.isSuccess()) {
                List<Database.Error> errors = upsertResult.getErrors();
                for(Database.Error err : errors) {
                    System.debug('The following error has occurred.');                    
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('Contract fields that affected this error: ' + err.getFields());
                    if (err instanceof Database.DuplicateError) {
                        Database.DuplicateError duplicateError = (Database.DuplicateError)err;
                        Datacloud.DuplicateResult duplicateResult = duplicateError.getDuplicateResult();
                        Datacloud.MatchResult[] matchResults = duplicateResult.getMatchResults();
                        Datacloud.MatchResult matchResult = matchResults[0];
                        Datacloud.MatchRecord[] matchRecords = matchResult.getMatchRecords();
                        for (Datacloud.MatchRecord matchRecord : matchRecords) {
                            newContract = (Contract)matchRecord.getRecord();
                        }
                    }
                }
                System.Debug('--- FieldServiceWorkController - Existing Contract : '+newContract?.Id);
                return newContract;
            }else{
                System.Debug('--- FieldServiceWorkController - Created Contract : '+newContract?.Id);
                return newContract;
            }
        } catch(Exception ex){
            System.debug('Exception type caught: ' + ex.getTypeName());    
            System.debug('Message: ' + ex.getMessage());    
            System.debug('Cause: ' + ex.getCause());    
            System.debug('Line number: ' + ex.getLineNumber());    
            System.debug('Stack trace: ' + ex.getStackTraceString());  
            System.Debug('--- FieldServiceWorkController - Exception Occured : '+ex.getMessage());
            return null;
        }
    }*/
    public static Order upsertOrder(ProjectData.OrderMessage orderMessage){   
        Order newOrder = new Order();    
        ProjectData.CustomerProject mainProjectData = orderMessage.project;
        Account customer = findCustomer(mainProjectData.customerAddress, mainProjectData.salesPerson);
        Id accountId = customer.Id;
        System.Debug('--- FieldServiceWorkController - Create New Order for Customer : '+accountId);
        String customerNumber = customer.AccountNumber;
        //String projectNumber = CustomerProjectData?.projectNumber;
        //String currencyCode = CustomerProjectData?.currencyCode;
        //String salesPerson = CustomerProjectData?.salesPerson?.salesPersonId;
        //User salesUser = getUserRecord(salesPerson);  

        //System.Debug('--- FieldServiceWorkController - Create New Order on behalf of User : '+salesUser.Id);     
        try{
            System.Debug('--- FieldServiceWorkController - Create New Order from : '+mainProjectData);
            newOrder.AccountId = accountId;
            //newOrder.AccountNumber = customerNumber;
            //newOrder.ActivatedById
            //newOrder.ActivatedDate
            //newOrder.BillToContactId = invoicingAddress.contactPerson;
            //newOrder.BillingAddress;
            //newOrder.BillingEmailAddress;
            //newOrder.BillingPhoneNumber;
            //newOrder.CompanyAuthorizedById
            //newOrder.CompanyAuthorizedDate
            //newOrder.ContractEndDate
            //newOrder.ContractName
            //newOrder.ContractId
            //newOrder.CreatedById
            //newOrder.CustomerAuthorizedById
            //newOrder.CustomerAuthorizedDate
            //newOrder.Description
            //newOrder.LastModifiedById
            //newOrder.OpportunityId
            //newOrder.TotalAmount
            //newOrder.CurrencyIsoCode
            //newOrder.EndDate
            //newOrder.Name
            //newOrder.OrderNumber = CustomerProject.offerNumber;
            newOrder.OrderNumber__c = mainProjectData.offerNumber;
            //newOrder.OwnerId = salesUser.Id;
            //newOrder.OrderReferenceNumber
            newOrder.EffectiveDate = Date.Today();
            newOrder.Type = mainProjectData.orderType;
            //newOrder.OrderedDate
            //newOrder.OriginalOrderId
            //newOrder.PoDate
            //newOrder.PoNumber
            //newOrder.Pricebook2Id
            //newOrder.QuoteId
            //newOrder.IsReductionOrder
            //newOrder.RelatedOrderId
            //newOrder.SalesChannelId
            //newOrder.SalesStoreId
            //newOrder.ShipToContactId
            //newOrder.ShippingAddress
            newOrder.Status = 'Draft';
            //newOrder.TaxLocaleType
            //newOrder.TotalAdjustedDeliveryAmount
            //newOrder.TotalAdjDeliveryAmtWithTax
            //newOrder.TotalAdjustedDeliveryTaxAmount
            //newOrder.TotalAdjustedProductAmount
            //newOrder.TotalAdjProductAmtWithTax
            //newOrder.TotalAdjustedProductTaxAmount
            //newOrder.TotalDeliveryAdjDistTaxAmount
            //newOrder.TotalDeliveryAdjDistAmount
            //newOrder.TotalDeliveryAdjDistAmtWithTax
            //newOrder.TotalProductAdjDistTaxAmount
            //newOrder.TotalProductAdjDistAmount
            //newOrder.TotalProductAdjDistAmtWithTax
            //newOrder.TotalTaxAmount
            //newOrder.GrandTotalAmount
            System.Debug('--- FieldServiceWorkController - Order to Upsert : '+newOrder);
            Database.SaveResult upsertResult =  Database.insert(newOrder,false) ;
            //Database.UpsertResult upsertResult =  Database.upsert(newOrder,Order.OrderNumber__c) ;
            if (!upsertResult.isSuccess()) {
                List<Database.Error> errors = upsertResult.getErrors();
                for(Database.Error err : errors) {
                    System.debug('The following error has occurred.');                    
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('Order fields that affected this error: ' + err.getFields());
                    if (err instanceof Database.DuplicateError) {
                        Database.DuplicateError duplicateError = (Database.DuplicateError)err;
                        Datacloud.DuplicateResult duplicateResult = duplicateError.getDuplicateResult();
                        Datacloud.MatchResult[] matchResults = duplicateResult.getMatchResults();
                        Datacloud.MatchResult matchResult = matchResults[0];
                        Datacloud.MatchRecord[] matchRecords = matchResult.getMatchRecords();
                        for (Datacloud.MatchRecord matchRecord : matchRecords) {
                            newOrder = (Order)matchRecord.getRecord();
                        }
                    }
                }
                System.Debug('--- FieldServiceWorkController - Existing Order : '+newOrder?.Id);
                return newOrder;
            }else{
                System.Debug('--- FieldServiceWorkController - Created Order : '+newOrder?.Id);
                return newOrder;
            }
        } catch(Exception ex){
            System.debug('Exception type caught: ' + ex.getTypeName());    
            System.debug('Message: ' + ex.getMessage());    
            System.debug('Cause: ' + ex.getCause());    
            System.debug('Line number: ' + ex.getLineNumber());    
            System.debug('Stack trace: ' + ex.getStackTraceString());  
            System.Debug('--- FieldServiceWorkController - Exception Occured : '+ex.getMessage());
            return null;
        }
    }
    
   


	/*public static void createInstallationPDFFiles(InboundOrderData.Order ProjectData, Map<String,ContentDocumentLink> existingPDFMap, List<WorkOrderLineItem> woliList){
        
        // If the incoming file name already exists in the existing PDF then the file already exists in the system
        // Next step is to check is this file already part of a WOLI. If so is it the right WOLI ?
        //Map<Id,WorkOrderLineItem> woliListMap = new Map<Id,WorkOrderLineItem>(
            									//[SELECT Id,Configuration_Product__r.RVN_Number__c
                                                 //FROM WorkOrderLineItem 
                                                 //WHERE Id IN : woliList limit 1000]);
        
        
        List<ContentVersion> documentsToUpsert = new List<ContentVersion>();
        Set<String> fileNames = new Set<String>();
        for(InboundOrderData.GroupRec groupRec: mainProjectData.groups.groupList){
            String attachment = groupRec.AssemblyInstructions.Attachments.Attachment;
            String rvn = attachment.substringBefore('.pdf');
            rvn = rvn.RIGHT(16);
            for(WorkOrderLineItem wl : woliList){
                if(wl.RVN_Number__c  == rvn){
                   if(existingPDFMap.keyupsert().contains(groupRec.AssemblyInstructions.Attachments.Attachment)){
                        ContentVersion cv = new ContentVersion();
                        cv.Title = attachment;
                        cv.ContentLocation= 's';
                        cv.ContentDocumentId = existingPDFMap.get(attachment).ContentDocumentId;
                        cv.PathOnClient= attachment;
                        cv.VersionData = Blob.valueOf('test');
                        cv.RVN_Number__c = rvn;
                        fileNames.add(rvn);
                        documentsToUpsert.add(cv);
                       // createInstallationPDFFiles(groupRec,existingPDFMap, woliList);
                    }else {
                        ContentVersion cv = new ContentVersion();
                        cv.Title = attachment;
                        cv.ContentLocation= 's';
                        cv.PathOnClient= attachment;
                        cv.VersionData = Blob.valueOf('test');
                        cv.RVN_Number__c = rvn;
                        fileNames.add(rvn);
                        documentsToUpsert.add(cv);
                    } 
                }
            }
        }
        List<Database.UpsertResult> upsertContentForIC = Database.upsert(documentsToUpsert);
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
                if(cdlMap.keyupsert().contains(statsFile.ContentDocumentId) && !(String.valueOf(cdlMap.get(statsFile.ContentDocumentId).LinkedEntityId).startsWith('005'))){
                    System.debug('--- FieldServiceInstallationHelper cdl already exists ---');
                }else{
                    if(woliMap.keyupsert().contains(statsFile.RVN_Number__c)){
                        contDocLinks.add(new ContentDocumentLink(ContentDocumentId = statsFile.ContentDocumentId, ShareType = 'V', LinkedEntityId = woliMap.get(statsFile.RVN_Number__c).Id));
                    }
                }
            }
        }
        
        if (!contDocLinks.isEmpty()) {
            upsert contDocLinks;
        }
    }*/

    /*public static WorkOrder upsertWorkOrder(InboundOrderData.Order ProjectData,  Account customerAccount, Opportunity oppRec,  Delivery_Batch__c delbatchRec){
        WorkOrder workRec = new WorkOrder();
        workRec.AccountId = customerAccount.Id;
        workRec.Opportunity__c = oppRec.Id;
        workRec.Delivery_Batch__c = delbatchRec.Id;
        workRec.IsIntegrationData__c =true;
        workRec.OwnerId = installationManager != NULL ? installationManager.Id : UserInfo.getUserId();
        workRec.SalesToriUniqueKey__c = delbatchRec.SalesToriUniqueKey__c;
        workRec.Soft_Reserved_Date__c  = Date.parse(mainProjectData.groups.groupList[0].install_start_date);
        workRec.StartDate = Date.parse(mainProjectData.groups.groupList[0].install_start_date);
        workRec.EndDate = Date.parse(mainProjectData.groups.groupList[0].install_end_date);
        workRec.City = mainProjectData.order_info.install_address.city;
        workRec.Country = countryMap.get(mainProjectData.order_info.install_address.country).Country_Name__c ;
        workRec.PostalCode = String.valueOf(mainProjectData.order_info.install_address.postal_code);
        workRec.Street = mainProjectData.order_info.install_address.street_address;
        database.upsert(workRec,WorkOrder.SalesToriUniqueKey__c);
        return workRec;
    }
    
    public static List<WorkOrderLineItem> upsertWorkOrderLines(InboundOrderData.Order ProjectData, WorkOrder workRec, Delivery_Batch__c delbatchRec){
        Map<String, WorkOrderLineItem> workOrderLineMaps = getExisitingWorkOrderLines(delbatchRec.SalesToriUniqueKey__c);
        List<WorkOrderLineItem> workOrderLineListToUpdate = new List<WorkOrderLineItem>();
        for(InboundOrderData.GroupRec groupRec: mainProjectData.groups.groupList){
            WorkOrderLineItem workLineRec = new WorkOrderLineItem();
            workLineRec.WorkOrderId = workRec.Id;
            Configuration_Product__c configProduct = new Configuration_Product__c(RVN_Number__c = String.valueOf(groupRec.OrderLine.BOMVersion));
            WorkType wType = [SELECT Id,Type__c from WorkType where Type__c = 'New Product installation' limit 1]; 
            workLineRec.Configuration_Product__r = configProduct;
            //workLineRec.Line__c = String.valueof(groupRec.OrderLine.Line);
            //workLineRec.Floor__c = !String.isBlank(groupRec.OrderLine.Floor) ? Integer.valueOf(groupRec.OrderLine.Floor) : 0 ;
            //workLineRec.Apartment_Number__c = groupRec.OrderLine.Apartment;
            workLineRec.RVN_Number__c  = String.valueOf(groupRec.OrderLine.BOMVersion);
            workLineRec.Is_installable__c  = TRUE;
            workLineRec.WorkTypeId = wType.Id;
            workLineRec.Duration = Decimal.valueOf(groupRec.OrderLine.InstallHours);
            workLineRec.DurationType = 'Hours';
            workLineRec.StartDate  = Date.parse(groupRec.install_start_date);
            workLineRec.EndDate  = Date.parse(groupRec.install_end_date);
            if(workOrderLineMaps.containsKey(groupRec.OrderLine.BOMVersion)){
                workLineRec.Id = workOrderLineMaps.get(groupRec.OrderLine.BOMVersion).Id;
            }
            workOrderLineListToUpdate.add(workLineRec);
        }
        Database.UpsertResult[] saveResult = Database.upsert(workOrderLineListToUpdate,false) ;
        for (Database.UpsertResult sr : saveResult) {
            if(sr.isSuccess()){
                delbatchRec.Batch_Status__c = 'Data imported';
            }else{
                delbatchRec.Batch_Status__c = 'New';
            }
        }
        update delbatchRec;
        return workOrderLineListToUpdate;
    }*/
    
	
	
    public Static CustomException__c insertCustomException(String className, String message,double LineNumber,String methodName,String type, boolean doInsert){
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