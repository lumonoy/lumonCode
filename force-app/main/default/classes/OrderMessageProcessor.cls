/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 06-19-2024
 * @last modified by  : Henk Reynders
**/
public class OrderMessageProcessor {
    public static String B2BOpportunityRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('B2B_Opportunity').getRecordTypeId();
    public static String B2COpportunityRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('B2C_Opportunity').getRecordTypeId();
    public static String B2BAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('B2B_Account').getRecordTypeId();
    public static String B2CAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
    
    
   	public static Map<String,Country_Mapping__mdt> countryMap = new Map<String,Country_Mapping__mdt>();
    public static List<Country_Mapping__mdt> countryMapList = [SELECT CountryCodeAlpha3__c, CountryCodeAlpha2__c ,Country_Name__c  FROM Country_Mapping__mdt];
    
    public static String processInboundOrderMessage (String orderMessageJSON){
        try{
            OrderData orderdata = OrderData.parse(orderMessageJSON);
            return 'OrderMessage Processed!';
        } catch(Exception e){            
            System.debug(e);
            return 'OrderMessage Processing Failed!';
        }
    }   
    public static OrderData.OrderMessage deserializeOrderMessage (String orderMessageJSON){
        
        OrderData.OrderMessage orderMessage = 
          (OrderData.OrderMessage)JSON.deserialize(orderMessageJSON, OrderData.OrderMessage.class);
          return orderMessage;
    }
    /*public static void getOrderDetails(OrderData.OrderMessage orderMessage){
        OrderData.OrderDetails orderDetails = orderMessage.orderDetails;
        OrderData.SalesPerson salesPersonDetails = orderDetails.sales_person;
        User salesPerson;
        User installationManager;
        String languagePreference;
        String leadSource;
        String currencyCode;
        Account existingAccount;
        if(countryMapList.size() > 0){
            for(Country_Mapping__mdt ctry : countryMapList){
                countryMap.put(ctry.CountryCodeAlpha3__c, ctry);
            }
        }
        // Step 1: Check for Account based on accountNumber
        existingAccount = findAccount(orderData);
        // Find Existing Salesforce Users to Assign
        installationManager = findUser(salesPersonDetails.supervisor); // Find User by Employee_Id Mepco_SuperVisor Id 
        salesPerson = findUser(salesPersonDetails.username); // Find User by Employee_Id

        languagePreference = String.isNotBlank(orderDetails.language_code) ? orderDetails.language_code : ''; // Use Default??
        leadSource = orderDetails.leadSource;
        currencyCode = orderDetails.currencyCode;
        
        
        Opportunity opportunityRecord = checkOpportunityRecord(orderData, existingAccount);
        
        Delivery_Batch__c deliveryBatchRecord = createDeliveryBatch(orderData,existingAccount,opportunityRecord);
        manageConfigurationPlanAndProduct(orderData,existingAccount,opportunityRecord,deliveryBatchRecord);
        
        WorkOrder workOrderRecord = createWorkOrder(orderData,existingAccount, opportunityRecord, deliveryBatchRecord);
        List<WorkOrderLineItem> woliList =  createWorkOrderLines( orderData, workOrderRecord, deliveryBatchRecord);
        
        Map<String,ContentDocumentLink> existingPDFMap = getExistingInstallationPDFFiles(woliList);
        createInstallationPDFFiles(orderData,existingPDFMap,woliList);
    }
    public static Account findAccount(String accountNumber){
        Account accountRecord = new Account();
        if(String.isNotBlank(accountNumber)) {
            List<Account> accounts = [SELECT Id,Name,AccountNumber,IsPersonAccount FROM Account Where AccountNumber =:accountNumber LIMIT 1 ];
            if(accounts?.size() >0){
                accountRecord  = accounts[0];
            }
        }
        return accountRecord;
    }
    public static Opportunity findOpportunity(InboundOrderData.Order orderData, Id accountId){
        opportunity opportunityRecord;
        String orderNumber = String.isNotBlank(orderData.order_info.order_number) ? orderData.order_info.order_number : ''; 
        List<Opportunity> opportunities = [SELECT Id,Name 
                                            FROM Opportunity 
                                            WHERE Account =: accountId 
                                                AND Order_Number__c =:orderNumber LIMIT 1 ];
        if(opportunities?.size() >0){
            System.debug('--- OrderMessageProcessor - findOpportunity - Opportunity Existing');
            opportunityRecord = opportunities[0];
        } else {
            System.debug('--- OrderMessageProcessor - findOpportunity - Creating New Opportunity');
            opportunityRecord =  createOpportunity(orderData, accountId);
        }
        return opportunityRecord;
    }
    public static User findUser(String adUserName){
        User userRecord = new User();
        List<User> users =[SELECT Id,Name FROM User WHERE AD_Short_Username__c =:adUserName LIMIT 1];
        if(users.size() > 0){
            userRecord = users[0]; 
        }
        return userRecord;
    }

    public static Opportunity createOpportunity(OrderData.OrderDetails orderDetails, Id accountId){
        Opportunity opportunityToCreate = new Opportunity();
        String accountName;
        List<Schema.PicklistEntry> values = Opportunity.Property_Type__c.getDescribe().getPicklistValues();
        Map<String,String> propertyApiToLabelMap = new Map<String,String>();
       
        for(Schema.PicklistEntry sp :values){
            //Map to hold Picklist API as Key and Picklist Label as Value
            propertyApiToLabelMap.put(sp.getLabel(),sp.getValue());
        }
        System.debug('*** propertyApiToLabelMap ***'+propertyApiToLabelMap);
        
        accountName = orderDetails.customer_address.customerName;
        opportunityToCreate.Name = existingAccount.Name; // Should not be Account Name
        opportunityToCreate.Customer_Segment__c = String.valueOf(orderData.order_info.customer_segmentid);
        opportunityToCreate.Order_Number__c = String.valueOf(orderData.order_info.order_number);
        opportunityToCreate.Order_Type__c = orderData.order_info.order_type;

        opportunityToCreate.AccountId =  existingAccount.Id;
        if(existingAccount.Business_Type__c == 'Consumer'){
            opportunityToCreate.recordtypeId = B2COpportunityRecordTypeId;
        }else{
            opportunityToCreate.recordtypeId = B2BOpportunityRecordTypeId;
        }
        
        opportunityToCreate.Property_Type__c  = propertyApiToLabelMap.get(orderData.order_info.propertytype);
        opportunityToCreate.OwnerId = salesPerson != NULL ? salesPerson.Id : UserInfo.getUserId();
        opportunityToCreate.closeDate = system.today().adddays(30);
        opportunityToCreate.IsLocked__c  = true;
        //opportunityToCreate.StageName ='Closed Won';
        upsert opportunityToCreate;
        //Database.UpsertResult upsertOpportunityResult = Database.upsert(opportunityRecord, Opportunity.Order_Number__c);
        return opportunityToCreate;
    }
    

    
    public static Delivery_Batch__c createDeliveryBatch(InboundOrderData.Order orderData, Account existingAccount, Opportunity opportunityRecord){
        System.debug('createDeliveryBatch');
        Delivery_Batch__c  delBatchRecord = new Delivery_Batch__c();
        delBatchRecord.Account__c = existingAccount.Id;
       	delBatchRecord.Batch_Id__c = orderData.groups.grouplist[0].OrderLine.DlvBatchID;
        delBatchRecord.Batch_number__c = Integer.valueOf(orderData.groups.grouplist[0].delivery_batch);
        delBatchRecord.Opportunity__c = opportunityRecord.Id;
        //////
        delBatchRecord.Planned_Installation_Address__City__s = orderData.order_info.install_address.city;
        delBatchRecord.Planned_Installation_Address__PostalCode__s = String.valueOf(orderData.order_info.install_address.postal_code);
        delBatchRecord.Planned_Installation_Address__Street__s = orderData.order_info.install_address.street_address;
        //////////////////
        delBatchRecord.SalesToriUniqueKey__c = String.valueOf(orderData.order_info.order_number)+orderData.groups.grouplist[0].delivery_batch;
        //delBatchRecord.Installation_address__CountryCode__s = countryMap.get(orderData.order_info.install_address.country);
        delBatchRecord.OwnerId = installationManager != NULL ? installationManager.Id : UserInfo.getUserId();
        if(orderData.groups.groupList.size() > 0 ){
            delBatchRecord.Planned_installation_start_date__c  = Date.parse(orderData.groups.groupList[0].install_start_date);
            delBatchRecord.Planned_installation_end_date__c  = Date.parse(orderData.groups.groupList[0].install_end_date);
            delBatchRecord.Planned_delivery_date__c  = Date.parse(orderData.groups.groupList[0].delivery_batch_delivery_date);
            delBatchRecord.Batch_Name__c = orderData.groups.grouplist[0].salestori_plan_name;
        }
        Database.UpsertResult upsertResult = Database.upsert(delBatchRecord, Delivery_Batch__c.SalesToriUniqueKey__c);
        return delBatchRecord;
    }
    
    public static void manageConfigurationPlanAndProduct(InboundOrderData.Order orderData, Account existingAccount, Opportunity opportunityRecord, Delivery_Batch__c delbatchRecord){
        Map<String,List<String>>  exisistingData = getExisitingConfigPlanMap(orderData.order_info.order_number);
        system.debug(exisistingData);
        List<String> configProdsToBeDeleted = new List<String>();
        List<configuration__c> configurationPlanList = new List<configuration__c>();
        List<Configuration_Product__c> configurationProductList = new List<Configuration_Product__c>();
        
        Map<String, List<InboundOrderData.GroupRecord>> configMap = getConfigurationPlanMap(orderData);
        for(String configKey: configMap.keySet()){
            List<String> rvns = new List<String>();
            if(exisistingData.containsKey(configKey)){
                rvns = exisistingData.get(configKey);
                exisistingData.remove(configKey);
            }
            
            List<InboundOrderData.GroupRecord> groupRecordList =  configMap.get(configKey);
            configurationPlanList.add(assignConfigurationPlan(groupRecordList[0],configKey, existingAccount, opportunityRecord, delbatchRecord));
            
            for(InboundOrderData.GroupRecord groupRecord :groupRecordList ){
                configurationProductList.add(assignConfigurationProduct(groupRecord ,configKey, rvns));
            }
            configProdsToBeDeleted.addAll(rvns);
        }
        
        
        List<Configuration_Product__c> configurationProducts =[SELECT id,Name from Configuration_Product__c where RVN_Number__c IN:configProdsToBeDeleted];
        delete configurationProducts;
        
        List<Configuration__c> configurationPlans =[SELECT id,Name,SalesToriConfigKey__c from Configuration__c where SalesToriConfigKey__c IN:exisistingData.keySet()];
        delete configurationPlans;
        
        List<Database.upsertResult> upsertConfigPlanResult = Database.upsert(configurationPlanList, configuration__c.SalesToriConfigKey__c);
        List<Database.upsertResult> upsertConfigProdResult = Database.upsert(configurationProductList, Configuration_Product__c.RVN_Number__c);
        
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
    public static void createInstallationFiles(OrderData.Order orderData, Map<String,ContentDocumentLink> existingPDFMap, List<WorkOrderLineItem> woliList){
        
        // If the incoming file name already exists in the existing PDF then the file already exists in the system
        // Next step is to check is this file already part of a WOLI. If so is it the right WOLI ?
        //Map<Id,WorkOrderLineItem> woliListMap = new Map<Id,WorkOrderLineItem>(
            									//[SELECT Id,Configuration_Product__r.RVN_Number__c
                                                 //FROM WorkOrderLineItem 
                                                 //WHERE Id IN : woliList limit 1000]);
        
        
        List<ContentVersion> documentsToUpsert = new List<ContentVersion>();
        Set<String> fileNames = new Set<String>();
        for(InboundOrderData.GroupRecord groupRecord: orderData.groups.groupList){
            String attachment = groupRecord.AssemblyInstructions.Attachments.Attachment;
            String rvn = attachment.substringBefore('.pdf');
            rvn = rvn.RIGHT(16);
            System.debug('*** existingPDFMap.keyset ***'+existingPDFMap.keyset());
            System.debug('*** existingPDFMap.value ***'+existingPDFMap.get(attachment));
            for(WorkOrderLineItem wl : woliList){
                if(wl.RVN_Number__c  == rvn){
                   if(existingPDFMap.keyset().contains(groupRecord.AssemblyInstructions.Attachments.Attachment)){
                        ContentVersion cv = new ContentVersion();
                        cv.Title = attachment;
                        cv.ContentLocation= 's';
                        cv.ContentDocumentId = existingPDFMap.get(attachment).ContentDocumentId;
                        cv.PathOnClient= attachment;
                        cv.VersionData = Blob.valueOf('test');
                        cv.RVN_Number__c = rvn;
                        fileNames.add(rvn);
                        documentsToUpsert.add(cv);
                       // createInstallationPDFFiles(groupRecord,existingPDFMap, woliList);
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
        System.debug('*** documentsToUpsert ***'+documentsToUpsert);
        System.debug('*** fileNames ***'+fileNames);
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
            System.debug('*** cdlMap ***'+cdlMap);
            for(WorkOrderLineItem wli : woliItems){
                woliMap.put(wli.RVN_Number__c,wli);
            }
			          
            for (ContentVersion statsFile : docs) {
                System.debug('*** cdlMap keyset ***'+cdlMap.keyset());
                System.debug('*** statsFile.ContentDocumentId ***'+statsFile.ContentDocumentId);
                if(cdlMap.keyset().contains(statsFile.ContentDocumentId) && !(String.valueOf(cdlMap.get(statsFile.ContentDocumentId).LinkedEntityId).startsWith('005'))){
                    System.debug('*** cdl already exists ***');
                }else{
                    if(woliMap.keyset().contains(statsFile.RVN_Number__c)){
                        contDocLinks.add(new ContentDocumentLink(ContentDocumentId = statsFile.ContentDocumentId, ShareType = 'V', LinkedEntityId = woliMap.get(statsFile.RVN_Number__c).Id));
                    }
                    System.debug('*** cdl not exists ***');
                }
                
                system.debug('contDocLinks---'+contDocLinks);
            }
        }
        
        if (!contDocLinks.isEmpty()) {
            upsert contDocLinks;
        }
    }
    
    // Method to create configurationPlan
    public static configuration__c assignConfigurationPlan(InboundOrderData.GroupRecord groupRecord, String uniqueKey, Account existingAccount, Opportunity opportunityRecord, Delivery_Batch__c delbatchRecord){
        
        configuration__c configPlanRecord = new configuration__c();
        configPlanRecord.Account__c = existingAccount.Id;
        configPlanRecord.Name = groupRecord.salestori_plan_name;
        configPlanRecord.Opportunity__c = opportunityRecord.Id;
        configPlanRecord.Delivery_Batch__c= delbatchRecord.Id;
        configPlanRecord.SalesToriConfigKey__c = uniqueKey;
        configPlanRecord.OwnerId = salesPerson != NULL ? salesPerson.Id : UserInfo.getUserId();
        return configPlanRecord;
    }
    // Method to create configuration Plan
    public static Map<String, List<InboundOrderData.GroupRecord>> getConfigurationPlanMap(InboundOrderData.Order orderData){
        Map<String, List<InboundOrderData.GroupRecord>> configMap = new Map<String, List<InboundOrderData.GroupRecord>>();
        for(InboundOrderData.GroupRecord groupRecord: orderData.groups.groupList){
            String uniqueKey = orderData.order_info.order_number+groupRecord.delivery_batch+groupRecord.unit+groupRecord.line+groupRecord.floor;
            if(!configMap.containsKey(uniqueKey)){
                configMap.put(uniqueKey, new List<InboundOrderData.GroupRecord>{groupRecord});
            }else{
                configMap.get(uniqueKey).add(groupRecord);
            }
        }
        return configMap;
    }
    
    // Method to create configuration product
    public static Configuration_Product__c assignConfigurationProduct(InboundOrderData.GroupRecord groupRecord, String configurationKey, List<String> rvnList){
        
        Configuration_Product__c  configProdRecord = new Configuration_Product__c ();
        Configuration__c configurationRecord = new Configuration__c(SalesToriConfigKey__c = configurationKey);
        configProdRecord.Configuration__r = configurationRecord;
        //Product2 productRecord = new Product2(Sales_Code__c= String.valueOf(groupRecord.OrderLine.ItemID)); 
        Product2 productRecord = [SELECT Id,Name,Product_Group__c from Product2 where Sales_Code__c = : String.valueOf(groupRecord.OrderLine.ItemID) limit 1];
        
        if(productRecord != NULL){
            configProdRecord.Product__c = productRecord.Id;
            configProdRecord.Name = productRecord.Name;
            configProdRecord.Product_Group__c = productRecord.Product_Group__c;
            configProdRecord.Delivery_Batch__c = Integer.valueOf(groupRecord.delivery_batch);
        }
        configProdRecord.Quantity__c   = 1.00;
        configProdRecord.RVN_Number__c = String.valueOf(groupRecord.OrderLine.BOMVersion);
        configProdRecord.Plan_Line__c =  String.valueOf(groupRecord.OrderLine.Line);
        configProdRecord.Plan_Floor__c  = !String.isBlank(groupRecord.OrderLine.Floor) ? Integer.valueOf(groupRecord.OrderLine.Floor) : 0 ;
        configProdRecord.Plan_Apartment__c  = groupRecord.OrderLine.Apartment;
        if(rvnList.contains(groupRecord.OrderLine.BOMVersion)){
            rvnList.remove(rvnList.indexOf(groupRecord.OrderLine.BOMVersion));
        }
        return configProdRecord;
    }
    // Method to create work order
    public static WorkOrder createWorkOrder(InboundOrderData.Order orderData,  Account existingAccount, Opportunity opportunityRecord,  Delivery_Batch__c delbatchRecord){
        WorkOrder workRecord = new WorkOrder();
        workRecord.AccountId = existingAccount.Id;
        workRecord.Opportunity__c = opportunityRecord.Id;
        workRecord.Delivery_Batch__c = delbatchRecord.Id;
        workRecord.IsIntegrationData__c =true;
        workRecord.OwnerId = installationManager != NULL ? installationManager.Id : UserInfo.getUserId();
        workRecord.SalesToriUniqueKey__c = delbatchRecord.SalesToriUniqueKey__c;
        workRecord.Soft_Reserved_Date__c  = Date.parse(orderData.groups.groupList[0].install_start_date);
        workRecord.StartDate = Date.parse(orderData.groups.groupList[0].install_start_date);
        workRecord.EndDate = Date.parse(orderData.groups.groupList[0].install_end_date);
        workRecord.City = orderData.order_info.install_address.city;
        System.debug('*** countryMap.get(orderData.order_info.install_address.country) ***'+countryMap.get(orderData.order_info.install_address.country).Country_Name__c);
        workRecord.Country = countryMap.get(orderData.order_info.install_address.country).Country_Name__c ;
        workRecord.PostalCode = String.valueOf(orderData.order_info.install_address.postal_code);
        workRecord.Street = orderData.order_info.install_address.street_address;
        database.upsert(workRecord,WorkOrder.SalesToriUniqueKey__c);
        return workRecord;
    }
    
    public static List<WorkOrderLineItem> createWorkOrderLines(InboundOrderData.Order orderData, WorkOrder workRecord, Delivery_Batch__c delbatchRecord){
        Map<String, WorkOrderLineItem> workOrderLineMaps = getExisitingWorkOrderLines(delbatchRecord.SalesToriUniqueKey__c);
        List<WorkOrderLineItem> workOrderLineListToUpdate = new List<WorkOrderLineItem>();
        System.debug('createWorkOrderLines');
        for(InboundOrderData.GroupRecord groupRecord: orderData.groups.groupList){
            WorkOrderLineItem workLineRecord = new WorkOrderLineItem();
            workLineRecord.WorkOrderId = workRecord.Id;
            Configuration_Product__c configProduct = new Configuration_Product__c(RVN_Number__c = String.valueOf(groupRecord.OrderLine.BOMVersion));
            WorkType wType = [SELECT Id,Type__c from WorkType where Type__c = 'New Product installation' limit 1]; 
            workLineRecord.Configuration_Product__r = configProduct;
            //workLineRecord.Line__c = String.valueof(groupRecord.OrderLine.Line);
            //workLineRecord.Floor__c = !String.isBlank(groupRecord.OrderLine.Floor) ? Integer.valueOf(groupRecord.OrderLine.Floor) : 0 ;
            //workLineRecord.Apartment_Number__c = groupRecord.OrderLine.Apartment;
            workLineRecord.RVN_Number__c  = String.valueOf(groupRecord.OrderLine.BOMVersion);
            workLineRecord.Is_installable__c  = TRUE;
            workLineRecord.WorkType = wType;
            workLineRecord.Duration = Decimal.valueOf(groupRecord.OrderLine.InstallHours);
            workLineRecord.DurationType = 'Hours';
            workLineRecord.StartDate  = Date.parse(groupRecord.install_start_date);
            workLineRecord.EndDate  = Date.parse(groupRecord.install_end_date);
            if(workOrderLineMaps.containsKey(groupRecord.OrderLine.BOMVersion)){
                workLineRecord.Id = workOrderLineMaps.get(groupRecord.OrderLine.BOMVersion).Id;
            }
            workOrderLineListToUpdate.add(workLineRecord);
        }
        System.debug('workOrderLineListToUpdate'+workOrderLineListToUpdate);
        Database.UpsertResult[] saveResult = Database.upsert(workOrderLineListToUpdate,false) ;
        System.debug('saveResult'+saveResult);
        for (Database.UpsertResult sr : saveResult) {
            if(sr.isSuccess()){
                System.debug('*** sr ***'+sr);
                delbatchRecord.Batch_Status__c = 'Data imported';
            }else{
                delbatchRecord.Batch_Status__c = 'New';
            }
        }
        System.debug('*** delbatchRecord.Batch_Status__c ***'+delbatchRecord.Batch_Status__c);
        update delbatchRecord;
        return workOrderLineListToUpdate;
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
        
        for(WorkOrderLineItem workLineRecord : workOrderLineItems){
            if(workLineRecord.Configuration_Product__c != null && workLineRecord.Configuration_Product__r.RVN_Number__c != null
               && !workOrderLineItemMap.containsKey(workLineRecord.Configuration_Product__r.RVN_Number__c)){
                   workOrderLineItemMap.put(workLineRecord.Configuration_Product__r.RVN_Number__c, workLineRecord);
               }
        }
        return workOrderLineItemMap;
    }
    

    
    public static Account createAccountRecord(InboundOrderData.Customer_address custAddress){
        System.debug('*** acc country ***'+countryMap.get(custAddress.country).CountryCodeAlpha2__c);
        try{
            Account b2cAcc = new Account(
            RecordTypeID=B2CAccountRecordTypeId,
            FirstName= custAddress.firstname,
            LastName= custAddress.lastname,
            PersonEmail= custAddress.email,
            PersonMobilePhone = custAddress.phone_number,
            PersonMailingCity= custAddress.city,
           	PersonMailingCountryCode = countryMap.get(custAddress.country).CountryCodeAlpha2__c,
            PersonMailingPostalCode = custAddress.postal_code,
            PersonMailingStreet= custAddress.street_address,
            District__c = custAddress.city,
            Language_Preference__c = langPrefered,
            PersonLeadSource = leadSource,
            Business_Type__c = 'Consumer',
            CurrencyIsoCode	= currency_Z,
            OwnerId = salesPerson.Id);
        	Database.SaveResult saveResult =  Database.insert(b2cAcc,false) ;
            System.debug('saveResult: ' + saveResult);
            if (!saveResult.isSuccess()) {
                List<Database.Error> error = saveResult.getErrors();
                if (error[0] instanceof Database.DuplicateError) {
                    Database.DuplicateError duplicateError = (Database.DuplicateError)error[0];
                    Datacloud.DuplicateResult duplicateResult = duplicateError.getDuplicateResult();
                    Datacloud.MatchResult[] matchResults = duplicateResult.getMatchResults();
                    Datacloud.MatchResult matchResult = matchResults[0];
                    System.debug('matchResult: ' + matchResult);
                    Datacloud.MatchRecord[] matchRecords = matchResult.getMatchRecords();
                    for (Datacloud.MatchRecord matchRecord : matchRecords) {
                        System.debug('MatchRecord: ' + (Account)matchRecord.getRecord());
                        b2cAcc = (Account)matchRecord.getRecord();
                    }
                }
                return b2cAcc;
            }else{
                return b2cAcc;
            }
            
        }catch(Exception e){
            return null;
        }
    }
    

	
	public static Map<String,ContentDocumentLink> getExistingInstallationPDFFiles(List<WorkOrderLineItem> woliList){
        Set<Id> woliIds = new Map<Id, WorkOrderLineItem>(woliList).keySet();
        Map<String,ContentDocumentLink> fileToWOLI = new Map<String,ContentDocumentLink>();
        List<ContentDocumentLink> cdlsForWOLI = [SELECT Id, ContentDocumentId,
                                                 ContentDocument.Title,LinkedEntityId
                                             	 FROM ContentDocumentLink WHERE LinkedEntityId IN :woliIds LIMIT 10000];
        
        if(cdlsForWOLI.size() > 0){
           for (ContentDocumentLink cdl : cdlsForWOLI) {
                fileToWOLI.put(cdl.ContentDocument.title, cdl);
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
    }*/
    
}