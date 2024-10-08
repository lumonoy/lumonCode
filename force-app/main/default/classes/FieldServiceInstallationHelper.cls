/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 10-08-2024
 * @last modified by  : Henk Reynders
**/
public class FieldServiceInstallationHelper {
    public static String B2BOpportunityRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('B2B_Opportunity').getRecordTypeId();
    public static String B2COpportunityRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('B2C_Opportunity').getRecordTypeId();
    public static String B2BAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('B2B_Account').getRecordTypeId();
    public static String B2CAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
    public static User salesPerson;
    public static User installationManager;
    public static String langPrefered;
    public static String leadSource;
    public static String currency_Z;
   	public static Map<String,Country_Mapping__mdt> countryMap = new Map<String,Country_Mapping__mdt>();
    public static List<Country_Mapping__mdt> countryMapList = [SELECT CountryCodeAlpha3__c, CountryCodeAlpha2__c ,Country_Name__c  FROM Country_Mapping__mdt];
    
    public static Map<String,String> getBusinessAttributes (InboundOrderData.order orderData) {
        Map<String,String> businessAttributes = new Map<String,String>();
        InboundOrderData.Order_info orderDetails = orderData.order_info;
        InboundOrderData.Sales_Person salesperson = orderDetails.sales_person;
        Map<String,String> adPersons = getPersons(salesperson);
        Map<String,User> sfUsers = getUsers(adPersons);
        Map<String,Office__c> sfOffices = getOffices(sfUsers);
        
        String organizationCode  = String.isNotBlank(orderDetails.axcompanyid) ? orderDetails.axcompanyid : '';  
        String countryCode = String.isNotBlank(orderDetails.delivery_address.country) ? countryMap.get(orderDetails.delivery_address.country)?.CountryCodeAlpha2__c : '';
        String profitCenterCode  = String.isNotBlank(orderDetails.business_unit) ? orderDetails.business_unit : '';
        String salesOfficeCode= sfOffices.get('salesOffice')?.OfficeCode__c;
        String fieldOfficeCode = sfOffices.get('fieldOffice')?.OfficeCode__c;
        String officeCode = String.isNotBlank(fieldOfficeCode) ? fieldOfficeCode : salesOfficeCode;
        String businessType = String.isNotBlank(orderDetails.customer_segmentid) ? orderDetails.customer_segmentid.left(1) : '';
        String segmentCode  = String.isNotBlank(orderDetails.customer_segmentid) ? orderDetails.customer_segmentid : '';
        String propertyType  = String.isNotBlank(orderDetails.propertytype) ? orderDetails.propertytype : '';
        
        businessAttributes.put('organizationCode',organizationCode); // Organization "LSU"
        businessAttributes.put('countryCode',countryCode); //Delivery or Installation Country "FI"
        businessAttributes.put('profitCenterCode',profitCenterCode); // Profit Center "402"
        businessAttributes.put('officeCode',officeCode); // Office Country/Postal Code "FI-43510"
        businessAttributes.put('businessType',businessType); // Business "1" (Consumer)
        businessAttributes.put('segmentCode',segmentCode); // Customer Segment "1000" (Consumer Apartments)
        businessAttributes.put('propertyType',propertyType); // Building Type "APA" (Apartment)
        return businessAttributes;
    }
    public static Map<String,User> getUsers( Map<String,String> persons) {
        User salesUser = getUserRecord(persons.get('sales'));
        User imUser = getUserRecord(persons.get('fieldService'));
        Map<String,User> users = new Map<String,User>();
        users.put('salesUser',salesUser);
        users.put('imUser',imUser);
        return users;
    }
    public static Map<String,String> getPersons(InboundOrderData.Sales_Person salesperson) {
        String username  = String.isNotBlank(salesPerson.username) ? salesPerson.username : '';  
        String supervisor = String.isNotBlank(salesPerson.supervisor) ? salesPerson.supervisor: '';
        Map<String,String> persons = new Map<String,String>();
        persons.put('sales', username);
        persons.put('fieldService',supervisor);
        return persons;
    }
    public static Map<String,Office__c> getOffices(Map<String,User> users) {
        
        String salesOfficeCode = users.get('salesUser')?.Office__c;
        String fieldOfficeCode = users.get('imUser')?.Office__c;
        Office__c salesOffice = [SELECT Id,Name, OfficeCode__c FROM Office__c WHERE OfficeCode__c =: salesOfficeCode LIMIT 1];
        Office__c fieldOffice = [SELECT Id,Name, OfficeCode__c FROM Office__c WHERE OfficeCode__c =: fieldOfficeCode LIMIT 1];
        Map<String,Office__c> offices = new Map<String,Office__c>();
        offices.put('salesOffice', salesOffice);
        offices.put('fieldOffice', fieldOffice);
        return offices;
    }   
  
    public static String processInboundOrderData(String inboundOrderJson){
        System.debug('--- FieldServiceInstallationHelper - Parse JSON');
        String errorMessage;
        String successMessage;
        System.debug('--- FieldServiceInstallationHelper - Parse JSON');
        try {
            if (String.IsNotBlank(inboundOrderJson)){
                InboundOrderData  orderData =  InboundOrderData.parse(inboundOrderJson);
                if (String.IsNotBlank(orderData.order.order_info.order_number)){
                    String offerNumber = orderData.order.order_info.order_number;
                    System.Debug('--- FieldServiceInstallationHelper - Process InboundOrderData for Offer: '+offerNumber);
                    FieldServiceInstallationHelper.createData(orderData.Order);
                } else {
                    errorMessage = 'No Offer Details in processed Inbound OrderMessage JSON';
                    System.debug('--- FieldServiceInstallationHelper - ABORT '+errorMessage);
                    throw new CustomException(errorMessage);
                }
            } else {
                errorMessage = 'No Inbound OrderMessage JSON';
                System.debug('--- FieldServiceInstallationHelper - ABORT '+errorMessage);
                throw new CustomException(errorMessage);
            }
        } catch (Exception e) {
            System.debug('--- FieldServiceInstallationHelper - The following exception has occurred: ' + e.getMessage());
            throw new CustomException(e.getMessage());
        }
        return successMessage;
    }
    public static String createData(InboundOrderData.order orderData){
        System.debug('--- FieldServiceInstallationHelper - Create Data');
        String errorMessage;
        String successMessage;
        Account customer;
        try {
            System.debug('--- FieldServiceInstallationHelper - Step 1: Get Country Map');
            if(countryMapList.size() > 0){
                for(Country_Mapping__mdt countryMapping : countryMapList){
                    countryMap.put(countryMapping.CountryCodeAlpha3__c, countryMapping);
                }
            }
            System.debug('--- FieldServiceInstallationHelper - Step 2a: Get Supervisor');
            if(getUserRecord(orderData.order_info.sales_person.supervisor) != NULL){
                installationManager = getUserRecord(orderData.order_info.sales_person.supervisor);
            }
            System.debug('--- FieldServiceInstallationHelper - Step 2b: Get Sales User');
            if(getUserRecord(orderData.order_info.sales_person.username) != NULL){
                salesPerson = getUserRecord(orderData.order_info.sales_person.username);
            }
            langPrefered = orderData.order_info.language_code.substringAfter('-');
            leadSource = orderData.order_info.leadSource;
            currency_Z = orderData.order_info.currency_Z;
            System.debug('--- FieldServiceInstallationHelper - Step 3: Get Customer');
            customer = checkCustomerRecord(orderData);
            System.debug('--- FieldServiceInstallationHelper - Step 4: Get Opportunity');
            Opportunity opportunityRecord = checkOpportunityRecord(orderData, customer);
            System.debug('--- FieldServiceInstallationHelper - Step 5: Create Batch');
            if(opportunityRecord != NULL){
                Delivery_Batch__c deliveryBatchRec = createDeliveryBatch(orderData,customer,opportunityRecord);
                manageConfigurationPlanAndProduct(orderData,customer,opportunityRecord,deliveryBatchRec);
                System.debug('--- FieldServiceInstallationHelper - Step 6: Create WorkOrder');
                WorkOrder workOrderRec = createWorkOrder(orderData,customer, opportunityRecord, deliveryBatchRec);
                List<WorkOrderLineItem> woliList =  createWorkOrderLines( orderData, workOrderRec, deliveryBatchRec);
                System.debug('--- FieldServiceInstallationHelper - Step 7: Create WorkOrder Lines');
                List<Id> woliIds = new List<Id>(new Map<Id, WorkOrderLineItem>(woliList).keySet()); 
                System.debug('--- FieldServiceInstallationHelper - Step 8: Create Installation Document');
                Map<String,ContentDocumentLink> existingPDFMap = getExistingInstallationPDFFiles(woliIds);
                createInstallationPDFFiles(orderData,existingPDFMap,woliList); 
            }
            System.debug('--- FieldServiceInstallationHelper - createData - CPU TIME: '+LIMITS.getCpuTime()); 
            System.debug('--- FieldServiceInstallationHelper - createData - SOQL USED: ' + LIMITS.getQueries());
        } catch (Exception e) {
            System.debug('--- FieldServiceInstallationHelper - The following exception has occurred: ' + e.getMessage());
            throw new CustomException(e.getMessage());
        }
        return successMessage;
    }
	public static void createInstallationPDFFiles(InboundOrderData.Order orderData, Map<String,ContentDocumentLink> installationDocumentsMap, List<WorkOrderLineItem> woliList){
        
        // If the incoming file name already exists in the existing PDF then the file already exists in the system
        // Next step is to check is this file already part of a WOLI. If so is it the right WOLI ?
        //Map<Id,WorkOrderLineItem> woliListMap = new Map<Id,WorkOrderLineItem>(
            									//[SELECT Id,Configuration_Product__r.RVN_Number__c
                                                 //FROM WorkOrderLineItem 
                                                 //WHERE Id IN : woliList limit 1000]);
        
        
        List<ContentVersion> documentsToUpsert = new List<ContentVersion>();
        Set<String> fileNames = new Set<String>();
        if (orderData.groups != NULL && orderData.groups.groupList.size()>0) {
        	for(InboundOrderData.GroupRec groupRec: orderData.groups.groupList){
                String attachment = groupRec.AssemblyInstructions.Attachments.Attachment;
                String rvn = attachment.substringBefore('.pdf');
                rvn = rvn.RIGHT(16);
                for(WorkOrderLineItem wl : woliList){
                    if(wl.RVN_Number__c  == rvn){
                    if(installationDocumentsMap.keyset().contains(groupRec.AssemblyInstructions.Attachments.Attachment)){
                            ContentVersion cv = new ContentVersion();
                            cv.Title = attachment;
                            cv.ContentLocation= 's';
                            cv.ContentDocumentId = installationDocumentsMap.get(attachment).ContentDocumentId;
                            cv.PathOnClient= attachment;
                            cv.VersionData = Blob.valueOf('test');
                            //cv.RVN_Number__c = rvn;
                            fileNames.add(attachment);
                            documentsToUpsert.add(cv);
                            // createInstallationPDFFiles(groupRec,installationDocumentsMap, woliList);
                        }else {
                            ContentVersion cv = new ContentVersion();
                            cv.Title = attachment;
                            cv.ContentLocation= 's';
                            cv.PathOnClient= attachment;
                            cv.VersionData = Blob.valueOf('test');
                            //cv.RVN_Number__c = rvn;
                            fileNames.add(attachment);
                            documentsToUpsert.add(cv);
                        } 
                    }
                }
            }
        }
        List<Database.UpsertResult> upsertContentForIC = Database.upsert(documentsToUpsert);
        System.debug('--- FieldServiceInstallationHelper - createInstallationPDFFiles - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- FieldServiceInstallationHelper - createInstallationPDFFiles - SOQL USED: ' + LIMITS.getQueries());
        List<ContentVersion> docs = [SELECT ContentDocumentId, Title, PathOnClient FROM ContentVersion WHERE Title IN: fileNames and IsLatest = TRUE];
        
        List<ContentDocumentLink> contDocLinks = new List<ContentDocumentLink>();
        Map<Id,ContentDocumentLink> cdlMap = new Map<Id,ContentDocumentLink>();
        Map<String,WorkOrderLineItem> woliMap = new Map<String,WorkOrderLineItem>();
        
        Set<Id> contentDocumentIds = new Set<Id>();
        for(ContentVersion cv1 : docs){
            contentDocumentIds.add(cv1.ContentDocumentId);
        }
        
        // Get the content versions that has been upserted
        // Get contentdocumentlinks for that contentdocumentids
        // Store them in a map with contentdocumentid, rvn
        // If there is an existing cdl then no actions needed for that contentdocument
        // If there is no existing cdl then new cdl has to be created where the content version will be linked to the WOLI for that rvn
        if (contentDocumentIds.size() > 0) {
            List<ContentDocumentLink> documentLinks = [SELECT ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE ContentDocumentId IN:contentDocumentIds and LinkedEntityId in ( SELECT Id FROM WorkOrderLineItem)];
            List<WorkOrderLineItem> woliItems = [SELECT Id,RVN_Number__c FROM WorkOrderLineItem WHERE RVN_Number__c IN: fileNames];
            for(ContentDocumentLink cdl : documentLinks){
                cdlMap.put(cdl.ContentDocumentId,cdl);
            }
            for(WorkOrderLineItem wli : woliItems){
                woliMap.put(wli.RVN_Number__c,wli);
            }
			          
            for (ContentVersion statsFile : docs) {
                if(cdlMap.keyset().contains(statsFile.ContentDocumentId) && !(String.valueOf(cdlMap.get(statsFile.ContentDocumentId).LinkedEntityId).startsWith('005'))){
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
        System.debug('--- FieldServiceInstallationHelper - createInstallationPDFFiles - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- FieldServiceInstallationHelper - createInstallationPDFFiles - SOQL USED: ' + LIMITS.getQueries());
    }
    public static Account checkCustomerRecord(InboundOrderData.Order orderData){
        Account customer;
        if(orderData.order_info != null && orderData.order_info.customer_address != null) {
            if (String.isNotBlank(orderData.order_info.customer_address.customer_number)){
               InboundOrderData.Customer_address addressRec= orderData.order_info.customer_address;
               customer = getAccountRecord(String.valueOf(addressRec.customer_number));
               if(customer == null){
                   System.debug('No Account is found with the Customer Number');
               }
           }else if (String.isBlank(orderData.order_info.customer_address.customer_number)){
              System.debug('Customer Number is Blank');
              customer= createAccountRecord(orderData.order_info.customer_address); 
           }else{
               System.debug('Customer Number is Missing');
           }
        }
        return customer;
    }
    public static Opportunity checkOpportunityRecord(InboundOrderData.Order orderData, Account customer){
        opportunity opportunityRecord;
        if(orderData.order_info != null && orderData.order_info.order_number != null ){
            if(getOpportunityRecord(String.valueOf(orderData.order_info.order_number)) != NULL){
                opportunityRecord = getOpportunityRecord(String.valueOf(orderData.order_info.order_number));
            }
            if(customer != NULL){
                customer = [SELECT Id,Name,BusinessType__c,IsPersonAccount from Account where Id = :customer.Id limit 1];
            }
            if(opportunityRecord == null && customer != null){
                opportunityRecord =  createOpportunityRecord(orderData, customer);
            }
        }else{
            System.debug('order_number is Missing');
        }
        return opportunityRecord;
    }   
    public static opportunity createOpportunityRecord(InboundOrderData.Order orderData, Account customer){
        List<Schema.PicklistEntry> values = Opportunity.Property_Type__c.getDescribe().getPicklistValues();
        Map<String,String> propertyApiToLabelMap = new Map<String,String>();
       
        for(Schema.PicklistEntry sp :values){
            //Map to hold Picklist API as Key and Picklist Label as Value
            propertyApiToLabelMap.put(sp.getLabel(),sp.getValue());
        }
        InboundOrderData.Order_info orderDetails = orderData.order_info;
        String organizationCode  = String.isNotBlank(orderDetails.axcompanyid) ? orderDetails.axcompanyid : '';  
        String countryCode = String.isNotBlank(orderDetails.delivery_address.country) ? countryMap.get(orderDetails.delivery_address.country)?.CountryCodeAlpha2__c : '';
        String profitCenterCode  = String.isNotBlank(orderDetails.business_unit) ? orderDetails.business_unit : '';
        //String officeCode = getUserOffice();
        String segmentCode  = String.isNotBlank(orderDetails.customer_segmentid) ? orderDetails.customer_segmentid : '';
        String propertyType  = String.isNotBlank(orderDetails.propertytype) ? orderDetails.propertytype : '';
        String businessType = String.isNotBlank(orderDetails.customer_segmentid) ? orderDetails.customer_segmentid.left(1) : '';

        String offerNumber = String.isNotBlank(orderDetails.order_number) ? String.valueOf(orderDetails.order_number): '';
        String orderType = String.isNotBlank(orderDetails.order_type) ? String.valueOf(orderDetails.order_type): '';
        String contactEmail = String.isNotBlank(orderDetails.customer_address.email) ? String.valueOf(orderDetails.customer_address.email): '';


        // Prepare the Opportunity
        Opportunity opportunityRecord = new Opportunity();
        

        // Standard Fields
        opportunityRecord.Name =  orderDetails.install_address.street_address; //customer.Name; // Set Street not Account Name
        opportunityRecord.closeDate = system.today();
        opportunityRecord.AccountId =  customer.Id;
        opportunityRecord.StageName ='Closed Won';
        // OLD Fields 
        opportunityRecord.Order_Number__c = offerNumber;        
        opportunityRecord.Contact_Email__c = contactEmail;
        opportunityRecord.Customer_Segment__c = segmentCode;
        opportunityRecord.Order_Type__c = orderType;
        if(orderDetails.install_address.contact_person != NULL){
            opportunityRecord.Special_Instructions__c = orderDetails.install_address.contact_person + ' ' + 
                							 orderDetails.install_address.street_address + ' ' + 
                							 orderDetails.install_address.city + ' ' + 
                							 orderDetails.install_address.postal_code + ' ' +
                							 orderDetails.install_address.phone_number;
        }
        opportunityRecord.Customer_Address__City__s = orderDetails.customer_address.city;
        opportunityRecord.Customer_Address__CountryCode__s = countryMap.get(orderDetails.customer_address.country).CountryCodeAlpha2__c;
        opportunityRecord.Customer_Address__Street__s = orderDetails.customer_address.street_address;
        opportunityRecord.Customer_Address__PostalCode__s = orderDetails.customer_address.postal_code;
        opportunityRecord.Invoicing_Address__City__s = orderDetails.invoice_address.city;
        opportunityRecord.Invoicing_Address__CountryCode__s = countryMap.get(orderDetails.invoice_address.country).CountryCodeAlpha2__c;
        opportunityRecord.Invoicing_Address__Street__s = orderDetails.invoice_address.street_address;
        opportunityRecord.Invoicing_Address__PostalCode__s = orderDetails.invoice_address.postal_code;
        opportunityRecord.Deliver_To__c  = 'Other';
        opportunityRecord.Delivery_Address__City__s = orderDetails.delivery_address.city;
        opportunityRecord.Delivery_Address__CountryCode__s = countryMap.get(orderDetails.delivery_address.country).CountryCodeAlpha2__c;
        opportunityRecord.Delivery_Address__Street__s = orderDetails.delivery_address.street_address;
        opportunityRecord.Delivery_Address__PostalCode__s = orderDetails.delivery_address.postal_code;
        opportunityRecord.Install_At__c  = 'Other';       
        opportunityRecord.Installation_Address__City__s = orderDetails.install_address.city;
        opportunityRecord.Installation_Address__CountryCode__s = countryMap.get(orderDetails.install_address.country).CountryCodeAlpha2__c;
        opportunityRecord.Installation_Address__Street__s = orderDetails.install_address.street_address;
        opportunityRecord.Installation_Address__PostalCode__s = orderDetails.install_address.postal_code;

        // NEW Fields
        // Set Owner and Users
        opportunityRecord.OwnerId = salesPerson != NULL ? salesPerson.Id : UserInfo.getUserId();
        opportunityRecord.SalesPersonUser__c = salesPerson != NULL ? salesPerson.Id : UserInfo.getUserId();
        opportunityRecord.InstallationManagerUser__c = installationManager != NULL ? installationManager.Id : UserInfo.getUserId();
        
        System.debug('--- FieldServiceInstallationHelper - createOpportunityRecord - SalesPerson: ' + opportunityRecord.SalesPersonUser__c);
        System.debug('--- FieldServiceInstallationHelper - createOpportunityRecord - Installation Manager: ' + opportunityRecord.InstallationManagerUser__c);
        // Business Attributes
        opportunityRecord.Organization__c = organizationCode;
        //opportunityRecord.CountryCode__c
        opportunityRecord.ProfitCenterCode__c = profitCenterCode;
        opportunityRecord.BusinessType__c = businessType;
        opportunityRecord.CustomerSegment__c = segmentCode;
        //opportunityRecord.PropertyType__c = propertyType;
        System.debug('--- FieldServiceInstallationHelper - createOpportunityRecord - Organization: ' + opportunityRecord.Organization__c);
        System.debug('--- FieldServiceInstallationHelper - createOpportunityRecord - Profit Center: ' + opportunityRecord.ProfitCenterCode__c); 
        System.debug('--- FieldServiceInstallationHelper - createOpportunityRecord - BusinessType: ' + opportunityRecord.BusinessType__c);
        System.debug('--- FieldServiceInstallationHelper - createOpportunityRecord - Segment: ' + opportunityRecord.CustomerSegment__c);
        // Salestori Identifiers
        opportunityRecord.OfferNumber__c = orderData.order_info.order_number;
        opportunityRecord.ProjectNumber__c = orderData.order_info.project_number;
        // Set Flags
        opportunityRecord.IsMigrated__c  = true;
        opportunityRecord.IsLocked__c  = true;


        
        if(customer.BusinessType__c == '1'){
            opportunityRecord.recordtypeId = B2COpportunityRecordTypeId;
            if(orderData.order_info.customer_segmentid == '1000'){
               //opportunityRecord.Property_Type__c  = 'APA';
            }else if(orderDetails.customer_segmentid == '1100'){
               //opportunityRecord.Property_Type__c = 'HOU';
            }
        }else{
            opportunityRecord.recordtypeId = B2BOpportunityRecordTypeId;
        }
        
        Database.UpsertResult upsertOpportunityResult = Database.upsert(opportunityRecord, Opportunity.OfferNumber__c);
        return opportunityRecord;
    }   
    public static User getUserRecord(String salesuser){
        List<User> userRec =[SELECT Id,Name FROM User WHERE AD_Username__c =:salesuser];
        if(userRec.size() > 0){
            return userRec[0]; 
        }else{
            return null;
        }
    }
    public static Delivery_Batch__c createDeliveryBatch(InboundOrderData.Order orderData, Account customer, Opportunity opportunityRecord){
        InboundOrderData.Order_info orderDetails = orderData.order_info;
        Delivery_Batch__c  delBatchRec = new Delivery_Batch__c();
        delBatchRec.Account__c = customer.Id;
       	delBatchRec.Batch_Id__c = orderData.groups.grouplist[0].OrderLine.DlvBatchID;
        delBatchRec.Batch_number__c = Integer.valueOf(orderData.groups.grouplist[0].delivery_batch);
        delBatchRec.Opportunity__c = opportunityRecord.Id;
        // NEW FIELDS
        // Salestori References
        delBatchRec.OfferNumber__c = orderData.order_info.order_number;
        delBatchRec.ProjectNumber__c = orderData.order_info.project_number;
        // Installation Address from File
        delBatchRec.Planned_Installation_Address__City__s= orderDetails.install_address.city;
        delBatchRec.Planned_Installation_Address__PostalCode__s = String.valueOf(orderDetails.install_address.postal_code);
        delBatchRec.Planned_Installation_Address__Street__s = orderDetails.install_address.street_address;
        //delBatchRec.Installation_address__CountryCode__s = countryMap.get(orderData.order_info.install_address.country);
        // Migration Flags
        delBatchRec.isMigrated__c = true;
        delBatchRec.UniqueId__c = String.valueOf(orderData.order_info.project_number) 
                                    + String.valueOf(orderData.order_info.order_number)
                                    + orderData.groups.grouplist[0].delivery_batch;
        // Batch Owner< 
        delBatchRec.OwnerId = installationManager != NULL ? installationManager.Id : UserInfo.getUserId();
        if(orderData.groups.groupList.size() > 0 ){
            delBatchRec.Planned_installation_start_date__c  = Date.parse(orderData.groups.groupList[0].install_start_date);
            delBatchRec.Planned_installation_end_date__c  = Date.parse(orderData.groups.groupList[0].install_end_date);
            delBatchRec.Planned_delivery_date__c  = Date.parse(orderData.groups.groupList[0].delivery_batch_delivery_date);
            delBatchRec.Batch_Name__c = orderData.groups.grouplist[0].salestori_plan_name;
        }
        Database.UpsertResult upsertResult = Database.upsert(delBatchRec, Delivery_Batch__c.UniqueId__c);
        return delBatchRec;
    }   
    public static void manageConfigurationPlanAndProduct(InboundOrderData.Order orderData, Account customer, Opportunity opportunityRecord, Delivery_Batch__c delbatchRec){
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
    // Method to create configurationPlan
    public static configuration__c assignConfigurationPlan(InboundOrderData.GroupRec groupRec, String configPlanKey, Account customerAccount, Opportunity customerOpportunity, Delivery_Batch__c deliveryBatch){
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
    // Method to create configuration Plan
    public static Map<String, List<InboundOrderData.GroupRec>> getConfigurationPlanMap(InboundOrderData.Order orderData){
        Map<String, List<InboundOrderData.GroupRec>> configMap = new Map<String, List<InboundOrderData.GroupRec>>();
        for(InboundOrderData.GroupRec groupRec: orderData.groups.groupList){
            System.Debug('--- FieldServiceInstallationHelper - Offer Number: '+orderData.order_info.order_number);
            System.Debug('--- FieldServiceInstallationHelper - Batch Number: '+groupRec.delivery_batch);
            System.Debug('--- FieldServiceInstallationHelper - Configuration Plan Floor: '+groupRec.floor);
            System.Debug('--- FieldServiceInstallationHelper - Configuration Plan Line: '+groupRec.line);
            System.Debug('--- FieldServiceInstallationHelper - Configuration Plan Unit: '+groupRec.unit);
            String configPlanKey = orderData.order_info.order_number+groupRec.delivery_batch+groupRec.unit+groupRec.line+groupRec.floor;
            System.Debug('--- FieldServiceInstallationHelper - Configuration Plan Key: '+configPlanKey);
            if(!configMap.containsKey(configPlanKey)){
                configMap.put(configPlanKey, new List<InboundOrderData.GroupRec>{groupRec});
            }else{
                configMap.get(configPlanKey).add(groupRec);
            }
        }
        return configMap;
    }    
    // Method to create configuration product
    public static Configuration_Product__c assignConfigurationProduct(InboundOrderData.GroupRec groupRec, String configPlanKey, List<String> rvnList){
        
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
    }
    // Method to create work order
    public static WorkOrder createWorkOrder(InboundOrderData.Order orderData,  Account customer, Opportunity opportunityRecord,  Delivery_Batch__c delbatchRec){
        WorkOrder workRec = new WorkOrder();
        workRec.AccountId = customer.Id;
        workRec.Opportunity__c = opportunityRecord.Id;
        workRec.Delivery_Batch__c = delbatchRec.Id;
        workRec.IsIntegrationData__c =true;
        workRec.OwnerId = installationManager != NULL ? installationManager.Id : UserInfo.getUserId();
        workRec.UniqueId__c = delbatchRec.UniqueId__c;
        workRec.Soft_Reserved_Date__c  = Date.parse(orderData.groups.groupList[0].install_start_date);
        workRec.StartDate = Date.parse(orderData.groups.groupList[0].install_start_date);
        workRec.EndDate = Date.parse(orderData.groups.groupList[0].install_end_date);
        workRec.City = orderData.order_info.install_address.city;
        workRec.Country = countryMap.get(orderData.order_info.install_address.country).Country_Name__c ;
        workRec.PostalCode = String.valueOf(orderData.order_info.install_address.postal_code);
        workRec.Street = orderData.order_info.install_address.street_address;
        database.upsert(workRec,WorkOrder.UniqueId__c);
        return workRec;
    }
    public static List<WorkOrderLineItem> createWorkOrderLines(InboundOrderData.Order orderData, WorkOrder workRec, Delivery_Batch__c delbatchRec){
        Map<String, WorkOrderLineItem> workOrderLineMaps = getExistingWorkOrderLines(delbatchRec.UniqueId__c);
        List<WorkOrderLineItem> workOrderLineListToUpdate = new List<WorkOrderLineItem>();
        for(InboundOrderData.GroupRec groupRec: orderData.groups.groupList){
            WorkOrderLineItem workOrderLine = new WorkOrderLineItem();
            workOrderLine.WorkOrderId = workRec.Id;
            Configuration_Product__c configProduct = new Configuration_Product__c(RVN_Number__c = String.valueOf(groupRec.OrderLine.BOMVersion));
            WorkType wType = [SELECT Id,Type__c from WorkType where Type__c = 'New Product installation' limit 1]; 
            workOrderLine.Configuration_Product__r = configProduct;
            //workOrderLine.Line__c = String.valueof(groupRec.OrderLine.Line);
            //workOrderLine.Floor__c = !String.isBlank(groupRec.OrderLine.Floor) ? Integer.valueOf(groupRec.OrderLine.Floor) : 0 ;
            //workOrderLine.Apartment_Number__c = groupRec.OrderLine.Apartment;
            workOrderLine.RVN_Number__c  = String.valueOf(groupRec.OrderLine.BOMVersion);
            workOrderLine.Is_installable__c  = TRUE;
            workOrderLine.WorkType = wType;
            workOrderLine.Duration = Decimal.valueOf(groupRec.OrderLine.InstallHours);
            workOrderLine.DurationType = 'Hours';
            workOrderLine.StartDate  = Date.parse(groupRec.install_start_date);
            workOrderLine.EndDate  = Date.parse(groupRec.install_end_date);

            /******* ADD WOLI DESCRIPTION */
            // Product Statistics
            String serialNumber = groupRec.structurenumber; //String RVN 
            String productName = groupRec.group_name; // Main Product Name
            String productCode = groupRec.product_code; // Main Product Code
            Decimal glassSurface = decimal.valueOf(groupRec.glass_m2);
            Decimal blindsSurface = decimal.valueOf(groupRec.blinds_m2);
            Integer glassAmount = integer.valueOf(groupRec.glass_pcs);
            Integer productLength = integer.valueOf(groupRec.product_length);
            Decimal productWeight = decimal.valueOf(groupRec.group_weight);

            //ProductAttribute attribute = rvnProduct.productCode;
            //Service service = rvnProduct.productCode;
            //public Instruction instruction = rvnProduct.productCode;
            workOrderLine.Subject = (productName +': '+serialNumber
                                    );
            System.Debug('--- FieldServiceInstallationHelper - Work Order Line Item Subject: '+workOrderLine.Subject);
            workOrderLine.NumberOfGlassPanels__c = glassAmount;
            workOrderLine.ProductName__c = productName;
            workOrderLine.SerialNumber__c = serialNumber;
            workOrderLine.GlassSurface__c = glassSurface;
            workOrderLine.BlindsSurface__c = blindsSurface;
            workOrderLine.ProductLength__c = productLength;
            workOrderLine.ProductWeight__c = productWeight;
            
            System.Debug('--- FieldServiceInstallationHelper - Work Order Line Item Description: '+workOrderLine.Description);
            /*workOrderLine.Detailed_Description__c = ('RVN: '+serialNumber+ ' \r\n' 
                                    +'Product: '+productName + ' \r\n'        
                                    +'Glass:' + glassSurface +'m2'+ ' \r\n' 
                                    +'Blinds:' +blindsSurface +'m2'+ ' \r\n' 
                                    +'Glass Count:' + glassAmount +'pcs' + ' \r\n' 
                                    +'Lenght :'+ productLength + 'mm'+ ' \r\n' 
                                    +'Weight :'+ productWeight + 'kg'+ ' \r\n' 
                                    );
            System.Debug('--- FieldServiceInstallationHelper - Work Order Line Item Detailed: '+workOrderLine.Detailed_Description__c);*/
            /******************* */
            if(workOrderLineMaps.containsKey(groupRec.OrderLine.BOMVersion)){
                workOrderLine.Id = workOrderLineMaps.get(groupRec.OrderLine.BOMVersion).Id;
            }
            if (String.isNotBlank(groupRec.AssemblyInstructions.InstallNotes)) {
                workOrderLine.Description = workOrderLine.Description + '\r\n'+ + '\r\n' +groupRec.AssemblyInstructions.InstallNotes;
                System.Debug('--- FieldServiceInstallationHelper - Work Order Line Item Description: '+workOrderLine.Description);
            }
            workOrderLineListToUpdate.add(workOrderLine);
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
    }
    public static Map<String,List<String>> getExistingConfigPlanMap(String orderNumber){
        Map<String,List<String>> existingConfigProdMap = new Map<String,List<String>>();
        List<Configuration__c> configurationRecords = [SELECT Id,Name,Opportunity__c,Opportunity__r.order_number__c,UniqueId__c,
                                                        (SELECT ID,Name,RVN_Number__c 
                                                            FROM configuration_Products__r) 
                                                       FROM Configuration__c  
                                                       WHERE Opportunity__r.order_number__c != null ];
        
        for(Configuration__c configPlan: configurationRecords){
            List<String> productRvns = new List<String>();
            for(configuration_Product__c configProd:  configPlan.configuration_Products__r){
                productRvns.add(configProd.RVN_Number__c);
            }
            existingConfigProdMap.put(configPlan.UniqueId__c, productRvns);
        }
        return existingConfigProdMap;
    }  
    public static Map<String, WorkOrderLineItem> getExistingWorkOrderLines(String salesToriKey){
        Map<String, WorkOrderLineItem> workOrderLineItemMap = new  Map<String, WorkOrderLineItem>();
        List<WorkOrderLineItem> workOrderLineItems = [SELECT Id, Configuration_Product__c,Configuration_Product__r.RVN_Number__c,
                                                      WorkOrder.UniqueId__c, WorkOrderId, WorkOrder.Delivery_Batch__r.UniqueId__c  
                                                      FROM WorkOrderLineItem WHERE WorkOrder.Delivery_Batch__r.UniqueId__c =:salesToriKey];
        
        for(WorkOrderLineItem workOrderLine : workOrderLineItems){
            if(workOrderLine.Configuration_Product__c != null && workOrderLine.Configuration_Product__r.RVN_Number__c != null
               && !workOrderLineItemMap.containsKey(workOrderLine.Configuration_Product__r.RVN_Number__c)){
                   workOrderLineItemMap.put(workOrderLine.Configuration_Product__r.RVN_Number__c, workOrderLine);
               }
        }
        return workOrderLineItemMap;
    }  
    public static Account getAccountRecord(String customerountNumber){
        Account existingAccount = new Account();
        List<Account> customerords = new List<Account>();
        if (String.IsNotBlank(customerountNumber)) {
            customerords = [SELECT Id,Name,AccountNumber,IsPersonAccount FROM Account Where AccountNumber =:customerountNumber LIMIT 1 ];
        }
        if(customerords.size() >0){
            existingAccount =  customerords[0];
        }
        return existingAccount;
    }  
    public static Account createAccountRecord(InboundOrderData.Customer_address custAddress){
        try{
            Account newPersonAccount = new Account();
            Account duplicateAccount = new Account();
            Account customerAccount = new Account();
            newPersonAccount.RecordTypeID = B2CAccountRecordTypeId;
            System.Debug('--- FieldServiceInstallationHelper - Person Account Record Type : '+newPersonAccount.RecordTypeID);
            System.Debug('--- FieldServiceInstallationHelper - Create Person Account with First Name: '+custAddress.firstname);
            System.Debug('--- FieldServiceInstallationHelper - Create Person Account with Last Name: '+custAddress.lastname);
            newPersonAccount.FirstName= custAddress.firstname;
            newPersonAccount.LastName= custAddress.lastname;

            newPersonAccount.PersonEmail= custAddress.email;
            newPersonAccount.PersonMobilePhone = custAddress.phone_number;

            newPersonAccount.PersonLeadSource = leadSource; 
            newPersonAccount.CurrencyIsoCode = currency_Z;
            newPersonAccount.OwnerId = salesPerson != NULL ? salesPerson.Id : UserInfo.getUserId();

            newPersonAccount.PersonMailingCity= custAddress.city;
            newPersonAccount.PersonMailingCountryCode = countryMap.get(custAddress.country).CountryCodeAlpha2__c;
            newPersonAccount.PersonMailingPostalCode = custAddress.postal_code;
            newPersonAccount.PersonMailingStreet= custAddress.street_address;
            
            //District__c = custAddress.city,
            // FI from maintori should be converted to fi_FI
            //newPersonAccount.Language_Preference__c = langPrefered;

            //newPersonAccount.Business_Type__c = '1';// Changed from 'Consumer' to '1'nsumer';     
            newPersonAccount.BusinessType__c = '1';// Changed from 'Consumer' to '1'nsumer';             
            
            System.Debug('--- FieldServiceInstallationHelper - Account to Create : '+newPersonAccount);
            Database.DMLOptions dml = new Database.DMLOptions(); 
            dml.DuplicateRuleHeader.allowSave = false;
            Database.SaveResult saveResultAttempt1 =  Database.insert(newPersonAccount,dml) ;
           	if (!saveResultAttempt1.isSuccess()) {
                List<Database.Error> error = saveResultAttempt1.getErrors();
                System.Debug('--- FieldServiceInstallationHelper - Database Error on Account Create : '+error[0] );
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
                        System.Debug('--- FieldServiceInstallationHelper - Duplicate Account Created: '+newPersonAccount?.Id);
                        System.Debug('--- FieldServiceInstallationHelper - Duplicate Account Existing: '+duplicateAccount?.Id);
                    }
                }
            }else{
                System.Debug('--- FieldServiceInstallationHelper - Created Account : '+newPersonAccount?.Id);
                
            }
            return newPersonAccount;
        }catch(Exception e){
            return null;
        }
    }   
    public static Opportunity getOpportunityRecord(String orderNumber){
        Opportunity opportunityRecord;
        List<Opportunity> opportunityRecordord = [SELECT Id,Name FROM Opportunity Where Order_Number__c =:orderNumber LIMIT 1 ];
        if(opportunityRecordord.size() >0){
            opportunityRecord = opportunityRecordord[0];
            return opportunityRecordord[0];
        }else{
            return opportunityRecord;
        }
    }	
	public static Map<String,ContentDocumentLink> getExistingInstallationPDFFiles(List<Id> workOrderLineItemIds){
        System.Debug('--- FieldServiceInstallationHelper - getExistingInstallationPDFFiles for recordIds: '+workOrderLineItemIds);
        System.debug('--- FieldServiceInstallationHelper - getExistingInstallationPDFFiles - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('--- FieldServiceInstallationHelper - getExistingInstallationPDFFiles - SOQL USED: ' + LIMITS.getQueries());
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