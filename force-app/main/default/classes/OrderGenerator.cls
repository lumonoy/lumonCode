/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 03-04-202
 * @last modified by  : Henk Reynders
**/
public  class OrderGenerator {
    public static Boolean isSandbox = [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
    public static final List<String> VISUAL_PRODUCTS = new List<String>{
        'LG', 'LGS', 'LFIXEDWALL', 'LUMONKAIDE', 'LUMONTOLPK', 'VT3', 'VT4'
    };
    public static final List<String> AX_PRODUCTS = new List<String>{
        'LUMON5', 'LUMON6', 'LUMON6T', 'LT3', 'VT3', 'KIINTEÄSEI', 'LUMON7S'
    };
    public static final List<String> OTHER_PRODUCTS = new List<String>{
        'LISAHIN', 'HUOLTO','PERUSHUOLTO', 'MÄÄRÄAIKAISHUOLTO','TUNTITYÖ','VISORBLIND','VISORBLINDSALES','TERRACEMAT'
    };
    public static Map<Id,Opportunity> opportunityMap = new Map<Id,Opportunity>();
    public static Map<Id,Configuration__c> configurationMap = new Map<Id,Configuration__c>();
    public static Map<Id,List<Configuration__c>> oppToConfigMap = new Map<Id,List<Configuration__c>>();
    public static Map<String,Configuration_Product__c> configurationProductMap = new Map<String,Configuration_Product__c>();
    public static Map<Id, List<Configuration_Product__c>> configToConfigProduct = new Map<Id, List<Configuration_Product__c>>();
    public static Map<Id, List<Configuration_Product__c>> oppToConfigProductMap = new Map<Id, List<Configuration_Product__c>>();
    // Check Order status and proceed towards the Order JSON
    public static void populateOrderJSONForActivatedOrders (List<Order> orders, Map<Id, Order> oldOrders) {
      List<Order> ordersToPopulateJSON = new List<Order>();
        for (Order o : orders) {
            Order oldOrder = oldOrders.get(o.Id);
            if (o.Status == 'Activated' && oldOrder.Status != 'Activated') {
                ordersToPopulateJSON.add(o);
            }
        }
        if (!ordersToPopulateJSON.isEmpty()) {
            populateOrderJSON(ordersToPopulateJSON);
        }
    }
	
    // Check Order status and proceed towards the Order JSON from Submit Action
    @AuraEnabled
    public static String populateOrderJSONFromComponent (String recordId) {
        List<Order> orders = [SELECT OpportunityId, AccountId,Status, Method_of_Payment__c,ContractId, Payment_Term__c,OrderNumber FROM Order WHERE Id =: recordId];
        List<Order> ordersToPopulateJSON = new List<Order>();
        for (Order o : orders) {
            if (o.Status == 'Activated') {
                ordersToPopulateJSON.add(o);
            }
        }
        if (!ordersToPopulateJSON.isEmpty()) {
            return populateOrderJSON(ordersToPopulateJSON);
        } else {
            return 'Order has incorrect status to submit.';
        }
    }
    public static String populateOrderJSON(List<Order> orders) {
        
        System.debug('--- isSandbox ---'+isSandbox);
		String envName = 'production';
		if ([SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox) {
			envName = String.valueOf(URL.getOrgDomainUrl()).substringBetween('--', '.sandbox');
			envName = envName.remove('--c');
			if (envName != 'lumonTest' && envName != 'develop1' ) {
				envName = 'sandbox';
			}
		}
        List<ContentVersion> documentsToInsert = new List<ContentVersion>();
        // Custom metadata holding the frends integration credentials
        Integration_Credentials__mdt credentials;
        Integration_Credentials__mdt credentialsFiles;
        credentials = [SELECT API_Key__c, Endpoint__c FROM Integration_Credentials__mdt WHERE Integration_Name__c = 'FrendsOrder' AND Environment_Name__c =: envName];
        credentialsFiles = [SELECT API_Key__c, Endpoint__c FROM Integration_Credentials__mdt WHERE Integration_Name__c = 'FrendsFiles' AND Environment_Name__c =: envName];
        
        // Fetch all the needed IDs(Opportunity,Account,Contract,ContracttoProject)
        Set<Id> oppIds = new Set<Id>();
        List<Id> opportunityIds = new List<Id>();
        Set<Id> accountIds = new Set<Id>();
        Set<Id> contractIds = new Set<Id>();
        Set<Id> orderIds = new Set<Id>();
        Map<Id,Id> contDocIdToOrderId = new Map<Id, Id>();
        Map<Id,Id> orderIdToContentDocumentId = new Map<Id, Id>();

        for (Order orderRecord : orders) {
            if (orderRecord.Id != null) {
                orderIds.add(orderRecord.Id);
            }
            if (orderRecord.OpportunityId != null) {
                oppIds.add(orderRecord.OpportunityId);
                opportunityIds.add(orderRecord.OpportunityId);
                accountIds.add(orderRecord.AccountId);
            }
            if(orderRecord.ContractId != null){
                contractIds.add(orderRecord.ContractId);
            }
        }
        

        
        // Get map of Contentdocumentid and LinkedEntityId(OrderId) for all files related to Order 
        List<ContentDocumentLink> cdlsForOrders = [SELECT ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId IN :orderIds];
        for (ContentDocumentLink cdlOrd : cdlsForOrders) {
            contDocIdToOrderId.put(cdlOrd.ContentDocumentId, cdlOrd.LinkedEntityId);
        }
        System.debug('--- contDocIdToOrderId ---'+contDocIdToOrderId);
        // Get map of OrderId and ContentDocumentId for files Title like 'Order.JSON' and Latest 
        List<ContentVersion> cVersions = [SELECT ContentDocumentId, PathOnClient,Title FROM ContentVersion WHERE IsLatest = TRUE AND ContentDocumentId IN: contDocIdToOrderId.keySet() AND Title LIKE 'OrderJSON%'];
        
        for (ContentVersion cv : cVersions) {
            
            if (contDocIdToOrderId.get(cv.ContentDocumentId) != null) {
                System.debug('--- contDocIdToOrderId.get(cv.ContentDocumentId) ---'+contDocIdToOrderId.get(cv.ContentDocumentId));
                orderIdToContentDocumentId.put(contDocIdToOrderId.get(cv.ContentDocumentId), cv.ContentDocumentId);
            }
        }

        Map<Id,Id> orderIdToStructureDocumentId = new Map<Id, Id>();
        List<ContentVersion> cVersionsStructure = [SELECT ContentDocumentId, PathOnClient FROM ContentVersion WHERE IsLatest = TRUE AND ContentDocumentId IN: contDocIdToOrderId.keySet() AND Title LIKE 'StructureMessage%'];
        for (ContentVersion cv : cVersionsStructure) {
            system.debug('contDocIdToOrderId.get(cv.ContentDocumentId)---'+contDocIdToOrderId.get(cv.ContentDocumentId));
            if (contDocIdToOrderId.get(cv.ContentDocumentId) != null) {
                orderIdToStructureDocumentId.put(contDocIdToOrderId.get(cv.ContentDocumentId), cv.ContentDocumentId);
            }
        }

        Map<Id,Id> orderIdToBlindsDocumentId = new Map<Id, Id>();
        List<ContentVersion> cVersionsBlinds = [SELECT ContentDocumentId, PathOnClient FROM ContentVersion WHERE IsLatest = TRUE AND ContentDocumentId IN: contDocIdToOrderId.keySet() AND Title LIKE 'BlindsMessage%'];
        for (ContentVersion cv : cVersionsBlinds) {
            system.debug('contDocIdToOrderId.get(cv.ContentDocumentId)102---'+contDocIdToOrderId.get(cv.ContentDocumentId));
            if (contDocIdToOrderId.get(cv.ContentDocumentId) != null) {
                orderIdToBlindsDocumentId.put(contDocIdToOrderId.get(cv.ContentDocumentId), cv.ContentDocumentId);
            }
        }

        Map<Id,Id> orderIdToOMDocumentId = new Map<Id, Id>();
        List<ContentVersion> cVersionsOMs = [SELECT ContentDocumentId, PathOnClient FROM ContentVersion WHERE IsLatest = TRUE AND ContentDocumentId IN: contDocIdToOrderId.keySet() AND Title LIKE 'OrderMessage%'];
        for (ContentVersion cv : cVersionsOMs) {
            if (contDocIdToOrderId.get(cv.ContentDocumentId) != null) {
                orderIdToOMDocumentId.put(contDocIdToOrderId.get(cv.ContentDocumentId), cv.ContentDocumentId);
            }
        }
        
        
        // Get OrderLineItem Map for different cost types and categories
		Map<Id,List<AggregateResult>> costAggregateMap = new Map<Id,List<AggregateResult>>();
		List<AggregateResult> agrList = new List<AggregateResult>();
		Id orderVal;
		
		List<AggregateResult> costAggregateList = [SELECT OrderId,SUM(fxFactory__c) factory,
                                                   SUM(fxCost__c) productcost,SUM(TotalPrice) salesprice,
                                                   Product2.Cost_Category__c,Product2.Cost_Type__c,RVN_Number__c 
                                                   from OrderItem where OrderId IN :orderIds 
                                                   group by Product2.Cost_Category__c,Product2.Cost_Type__c,OrderId,RVN_Number__c];
		for(AggregateResult agr : costAggregateList){
            orderVal = (Id) agr.get('OrderId');
            agrList.add(agr);
			costAggregateMap.put(orderVal,agrList);
		}
        
        // Code by SAI on 15.11.2023
        List<Opportunity> opportunityList = OpportunityController.getOpportunities(opportunityIds); 
        List<Configuration__c> configPlans = [SELECT Id,Opportunity__c,Visual_Structure_Number__c,
                                              Plan_Floor__c, Plan_Line__c, Plan_Name__c 
                                              from Configuration__c  
                                              where Opportunity__c IN:opportunityIds];
        List<Configuration__c> confList = new List<Configuration__c>();
        List<Configuration_Product__c> configProducts =  new List<Configuration_Product__c>();
        List<Configuration_Product__c> conProdList =  new List<Configuration_Product__c>();
        List<Configuration_Product__c> conProdList2 =  new List<Configuration_Product__c>();
        List<Configuration_Option__c> configOptions = new List<Configuration_Option__c>();
        List<Id> configIds = new List<Id>();
        List<String> configProductIds = new List<String>();
        if(configPlans.size() > 0){
            configIds = new List<Id>(new Map<Id, Configuration__c>(configPlans).keySet());
            configProducts = ConfigurationProductController.getConfigurationProducts(configIds);
        }
        if(configProducts.size() > 0){
            configProductIds = new List<String>(new Map<String, Configuration_Product__c>(configProducts).keySet()); 
            configOptions = ConfigurationOptionController.getConfigurationOptions(configProductIds);
        }
        
        if(opportunityList.size() > 0){
            for(Opportunity opp : opportunityList){
                opportunityMap.put(opp.Id,opp);
            }
        }
        
        if(configPlans.size() > 0){
            for (Configuration__c configPlan : configPlans) {
                configurationMap.put(configPlan.Id,configPlan);
                if(!oppToConfigMap.containsKey(configPlan.Opportunity__c)){
                    confList.add(configPlan);
                    oppToConfigMap.put(configPlan.Opportunity__c,confList);
                }else{
                    oppToConfigMap.get(configPlan.Opportunity__c).add(configPlan);
                } 
                
            }
        }
        
        if(configProducts.size() > 0){
            for(Configuration_Product__c configProduct : configProducts){
                configurationProductMap.put(configProduct.RVN__c,configProduct);
                if(!configToConfigProduct.containsKey(configProduct.Configuration__c)){
                    conProdList.add(configProduct);
                    configToConfigProduct.put(configProduct.Configuration__c,conProdList);
                }else{
                    configToConfigProduct.get(configProduct.Configuration__c).add(configProduct);
                }
                if(!oppToConfigProductMap.containsKey(configProduct.Configuration__r.Opportunity__c)){
                    conProdList2.add(configProduct);
                    oppToConfigProductMap.put(configProduct.Configuration__r.Opportunity__c,conProdList2);
                }else{
                    oppToConfigProductMap.get(configProduct.Configuration__r.Opportunity__c).add(configProduct);
                }
            }
        }
        List<Id> configurationIds = new List<Id>(new Map<Id, Configuration__c>(configPlans).keySet()); 
        List<ContentDocumentLink> structureFileLinks = ([SELECT ContentDocument.Title, 
                            ContentDocument.LatestPublishedVersion.VersionData, 
                            LinkedEntityId
                    FROM ContentDocumentLink
                    WHERE LinkedEntityId IN :configurationIds
                    AND (
                            ((ContentDocument.Title LIKE 'Visual%Structure%' 
                                    OR ContentDocument.Title LIKE 'Visual%Output%')
                                AND ContentDocument.FileType = 'JSON')                                                                                 
                    )
                    LIMIT 100
                ]);
		//Code end by SAI 15.11.2023
        
        //Get the Doc XML File from the Opp's related configurations
        Map<Id,Id> oppConfigMap = new Map<Id,Id>();
        Map<String,Configuration_Product__c> configurationProductMap = new Map<String,Configuration_Product__c>();
        Map<Id,Configuration_Option__c> configurationItemsMap = new Map<Id,Configuration_Option__c>();
        Map<Id,String> configIdToRVN = new Map<Id, String>();
        
		//	1. Get Configurations related to the Order's connected opportunity        
        List<Configuration__c> configList = [SELECT Id,Opportunity__c,Visual_Structure_Number__c, Plan_Floor__c, Plan_Line__c, Plan_Name__c from Configuration__c  where Opportunity__c IN:oppIds];
        
        
        //	2. Create map oppConfigMap connecting configuration and opportunity
        for(Configuration__c c : configList){
            oppConfigMap.put(c.Id,c.Opportunity__c);
        }
        System.debug('--- oppConfigMap ---'+oppConfigMap);

        
        Map<Id,Id> contentMap = new Map<Id,Id>();
        Map<Id,Id> contentConfigMap = new Map<Id,Id>();
        Set<Id> oppConfigMapKeySet = oppConfigMap.keyset();
        List<ContentDocumentLink> contentDocLinkList = new List<ContentDocumentLink>();
        List<Configuration_Product__c> cpList = new List<Configuration_Product__c>();
        List<Configuration_Option__c> conItemList = new List<Configuration_Option__c>();
        //	3. Get Configuration products from the (oppConfigMap)
        //	3. Get List of files related to the configuration (oppConfigMap)[AS OF NOW ALL FILES ARE UNDER CONFIG PLAN AND NOT CONFIG PRODUCTS]
        system.debug('oppConfigMapKeySet---'+oppConfigMapKeySet);
        if (oppConfigMapKeySet.size() > 0) {
            cpList = [select Id,Configuration__r.Opportunity__c,Configuration__c,Inspection_Code__c,RVN_Number__c,RVN__c,Sales_Code__c,Visual_Structure_Number__c,Product__r.Name,Product__r.Product_Type__c from Configuration_Product__c where Configuration__c IN: oppConfigMapKeySet];
            conItemList = [select Id,Configuration_Product__c,Product__r.Product_Type__c from Configuration_Option__c where Configuration_Product__r.Configuration__c  IN: oppConfigMapKeySet AND Product__r.Product_Type__c = 'Special'];
            contentDocLinkList = [SELECT LinkedEntityId,ContentDocumentId from ContentDocumentLink where LinkedEntityId IN : oppConfigMapKeySet]; //Added RVN in query as part of LUM-2016
        }
        system.debug('contentDocLinkList--'+contentDocLinkList);
        
        //	4. Create a map of with RVN and configuration product (configurationProductMap)
        //	5. Create a map configIdToRVN with Related Configuration and RVN number(from Config product)
        //replaced RVN number with RVN in configurationProductMap, configIdToRVN maps. As part of LUM-2016
        for(Configuration_Product__c cp : cpList){
            configurationProductMap.put(cp.RVN__c,cp);
            System.debug('--- cp rvn value ---'+cp.RVN__c);
            configIdToRVN.put(cp.Configuration__c, cp.RVN__c);
        }

        //5a. Create a map of Configuration Item List with Related configuration product

        if(conItemList.size() > 0){
            for(Configuration_Option__c cItem : conItemList){
                configurationItemsMap.put(cItem.Configuration_Product__c, cItem);
            }
            System.debug('--- configurationItemsMap ---'+configurationItemsMap);
        }
		
        //	6. Prepare the contentmap that holds all the files where this configuration is the linkedEntity
        //	6. Create a map contentMap that holds the ContentDocumentId and the related Opportunity
        for(ContentDocumentLink cd : contentDocLinkList){ 
            contentMap.put(cd.ContentDocumentId,oppConfigMap.get(cd.LinkedEntityId));
            contentConfigMap.put(cd.ContentDocumentId,cd.LinkedEntityId);
        }
        system.debug('contentConfigMap---'+contentConfigMap);
        System.debug('--- configurationProductMap ---'+configurationProductMap);
        System.debug('--- contentMap ---'+contentMap);
        
        //	7. Get all the active content version files related to the contentdocument 
        //	7. prepare a map Opp & contentversionlist
        Map<Id,List<ContentVersion>> oppFileMap = new Map<Id,List<ContentVersion>>();
        Map<Id,List<ContentVersion>> configFileMap = new Map<Id,List<ContentVersion>>();
        
        List<ContentVersion> cvList = [SELECT Id,VersionData,ContentDocumentId,Title 
                                        FROM ContentVersion 
                                        WHERE ContentDocumentId IN:contentMap.keySet() 
                                            AND IsLatest = TRUE];

        
        System.debug('--- cvList ---'+cvList);        
        for(ContentVersion cv : cvList){
            oppFileMap.put(contentMap.get(cv.ContentDocumentId),cvList);
            configFileMap.put(contentConfigMap.get(cv.ContentDocumentId),cvList);
        }
        System.debug('--- oppFileMap ---'+oppFileMap);
        
        
        // Get configurations map from opportunity
        Map<Id, Set<Id>> oppIdToConfigs = new Map<Id, Set<Id>>();
        Set<Id> allConfigIds = new Set<Id>();
        Map<Id,Configuration__c> configs = new Map<Id, Configuration__c>([SELECT Id, Opportunity__c, Opportunity__r.Order_type__c, Visual_Structure_Number__c, Plan_Floor__c, Plan_Line__c, Plan_Name__c,Plan_Apartment__c FROM Configuration__c WHERE Opportunity__c IN: oppIds]);
                
        for (Configuration__c config : configs.values()) {
            allConfigIds.add(config.Id);
            if (oppIdToConfigs.get(config.Opportunity__c) == null) {
                oppIdToConfigs.put(config.Opportunity__c, new Set<Id>());
            }
            Set<Id> currentValues = oppIdToConfigs.get(config.Opportunity__c);
            currentValues.add(config.Id);
            oppIdToConfigs.put(config.Opportunity__c, currentValues);
        }
		
        List<ContentVersion> outputJsonVersions = [SELECT VersionData, ContentDocumentId, FileExtension,Title 
                                                    FROM ContentVersion 
                                                    WHERE ContentDocumentId IN :contentMap.keyset() 
                                                    AND Title LIKE '%Visual%' 
                                                    AND (Title LIKE '%Structure%'
                                                         OR Title LIKE '%Output%')
                                                    AND FileType = 'JSON'
                                                    AND IsLatest = TRUE 
                                                    ORDER BY CreatedDate DESC];
        List<ContentVersion> blindsVersions = [SELECT VersionData, ContentDocumentId,Title,FileExtension FROM ContentVersion WHERE ContentDocumentId IN :contentMap.keyset() AND Title LIKE '%Blind%'  AND IsLatest = TRUE ORDER BY CreatedDate DESC];
        
        List<ContentVersion> outputXmlVersions = [SELECT VersionData, ContentDocumentId, FileExtension,Title 
                                                    FROM ContentVersion 
                                                    WHERE ContentDocumentId IN :contentMap.keyset() 
                                                    AND Title LIKE '%Visual%' 
                                                    AND (Title LIKE '%Structure%'
                                                         OR Title LIKE '%Output%')
                                                    AND FileType = 'XML'
                                                    AND IsLatest = TRUE 
                                                    ORDER BY CreatedDate DESC];
        Map<Id,List<ContentVersion>> configOutputFileMap = new Map<Id,List<ContentVersion>>();
        Map<Id,List<ContentVersion>> configBlindsFileMap = new Map<Id,List<ContentVersion>>();
        Map<Id,Id> contVersionIdToConfigId = new Map<Id, Id>();
        
        system.debug('outputJsonVersions--'+outputJsonVersions);
        if (outputJsonVersions.size()>0) {
            for(ContentVersion cvout : outputJsonVersions){
                configOutputFileMap.put(contentConfigMap.get(cvout.ContentDocumentId),outputJsonVersions);
                contVersionIdToConfigId.put(cvout.Id, contentConfigMap.get(cvout.ContentDocumentId));
            }
        	system.debug('configOutputFileMap--'+configOutputFileMap);
        }
        if (outputXmlVersions.size()>0) {
            for(ContentVersion cvout : outputXmlVersions){
                configOutputFileMap.put(contentConfigMap.get(cvout.ContentDocumentId),outputXmlVersions);
                contVersionIdToConfigId.put(cvout.Id, contentConfigMap.get(cvout.ContentDocumentId));
            }
            system.debug('configOutputFileMap--'+configOutputFileMap);
        }
        system.debug('configOutputFileMap--'+configOutputFileMap);
        system.debug('configOutputFileMap--'+configOutputFileMap);
        for(ContentVersion cvblind : blindsVersions){
            configBlindsFileMap.put(contentConfigMap.get(cvblind.ContentDocumentId),blindsVersions);
            contVersionIdToConfigId.put(cvblind.Id, contentConfigMap.get(cvblind.ContentDocumentId));
        }
        
        // Map to get account related data for Billing. Query using the accountIds related to the Order's opportunity
        Map<Id, Account> accountIdToAccount = new Map<Id, Account>(
            [SELECT FirstName, LastName, Phone, PersonMailingStreet,PersonMailingCountryCode, PersonMailingCity, PersonMailingPostalCode,
                PersonMailingCountry, PersonMailingState, Fax, PersonEmail, AccountNumber,Account.BillingStreet, Account.BillingPostalCode, 
                Account.BillingState, Account.BillingCountryCode, Account.BillingCity,Financing_Customer_Number__c
            FROM Account WHERE Id IN: accountIds]
        );
        
        // Map to get contract related data for order message (all fields are in Contract)
        Map<Id, Contract> contractIdMap = new Map<Id, Contract>(
            [SELECT Status, AccountId, Chargeable__c,ContractNumber, Customer_Segment__c, Customer_segment_name__c,
                    Organization__c, CurrencyIsoCode, Customer_reference__c,Order_type__c, Opportunity_Number__c, Opportunity__c,
                    Opportunity__r.Project_Number__c,Project_Number__c,Parent_Project__c ,PriceBook_Name__c,Factory__c,Payment_Term__c,
                    Project_Group__c, Delivery_week__c, Delivery_Date__c,Main_Contractor__c,Business_Unit__c,
                    Opportunity__r.Invoice_type__c,Opportunity__r.Method_of_Payment__c,Method_of_Payment__c,
                    Opportunity__r.Customer_Address__City__s,Opportunity__r.Customer_Address__CountryCode__s,
                    Opportunity__r.Customer_Address__PostalCode__s,Opportunity__r.Customer_Address__StateCode__s,
                    Opportunity__r.Customer_Address__Street__s,
                    Opportunity__r.Delivery_Address__City__s,Opportunity__r.Delivery_Address__CountryCode__s,
                    Opportunity__r.Delivery_Address__PostalCode__s,Opportunity__r.Delivery_Address__StateCode__s,
                    Opportunity__r.Delivery_Address__Street__s,
                    Opportunity__r.Installation_Address__City__s,Opportunity__r.Installation_Address__CountryCode__s,
                    Opportunity__r.Installation_Address__PostalCode__s,Opportunity__r.Installation_Address__StateCode__s,
                    Opportunity__r.Installation_Address__Street__s,
                    Opportunity__r.Invoicing_Address__City__s,Opportunity__r.Invoicing_Address__CountryCode__s,
                    Opportunity__r.Invoicing_Address__PostalCode__s,Opportunity__r.Invoicing_Address__StateCode__s,
                    Opportunity__r.Invoicing_Address__Street__s,Opportunity__r.Phone__c,Opportunity__r.Contact_Email__c
            FROM Contract WHERE Id IN: contractIds]
        );
        
        
        // From contract get the project(main project in case of new sales) related to the opportunity
        Set<Id> contractToProjIds = new Set<Id>();
        for(Contract c : contractIdMap.values()){
            contractToProjIds.add(c.Opportunity__r.Project_Number__c);
        }
        System.debug('--- contractToProjIds ---'+contractToProjIds);
        
        //Opp Team Data to map the Installation Manager/Supervisor (LUM-979)
        Map<Id,OpportunityTeamMember> opportunityTeamMemberMap = new Map<Id,OpportunityTeamMember>();
        List<OpportunityTeamMember> opportunityTeamMemberList = new List<OpportunityTeamMember>([SELECT Id,OpportunityId,UserId, User.Alias from OpportunityTeamMember where OpportunityId IN:oppIds]);
        if(opportunityTeamMemberList.size() > 0){
            OpportunityTeamMember oppTeamMember = [SELECT Id,OpportunityId,UserId, User.Alias from OpportunityTeamMember where OpportunityId IN:oppIds limit 1];
                for(OpportunityTeamMember otm : opportunityTeamMemberList){
                if(!opportunityTeamMemberMap.containsKey(otm.OpportunityId)){
                    opportunityTeamMemberMap.put(otm.OpportunityId,otm);
                }
            } 
        }

        
        //Prepare map for subproject connected to the main project
        Map<Id,Project__c> subProjToMain = new Map<Id,Project__c>();
        List<Project__c> subProjList = new List<Project__c>();
        subProjList = [SELECT Parent_Project__c,Proj_number__c,Project_Value__c,Project_Number__c,Project_Group__c,Project_Category__c,Parent_Project__r.Project_Number__c,Chargeable__c 
                        FROM Project__c where Parent_Project__c IN:contractToProjIds];
        if(!subProjList.isEmpty()){
            for(Project__c sub : subProjList){
                subProjToMain.put(sub.Parent_Project__c,sub);
            }
        }
        System.debug('--- subProjToMain ---'+subProjToMain);
        
        //Getting opportunity owner details for sales person
        Map<Id,Opportunity> opportunityMap = new Map<Id,Opportunity>([	SELECT Id,Owner.Name,Owner.username,Phone__c,Contact_Email__c,Order_type__c,
                                                                          	Owner.Alias,Owner.Supervisor__c,Owner.FirstName,Owner.LastName,
                                                                           	Customer_Address__Street__s,Customer_Address__City__s,Customer_Address__PostalCode__s,
                                                                            Customer_Address__StateCode__s,Invoicing_Address__Street__s,Invoicing_Address__City__s,
                                                                            Invoicing_Address__PostalCode__s,Invoicing_Address__StateCode__s,Invoice_type__c,Delivery_Note__c,
                                                                            Installation_Address__Street__s,Installation_Address__City__s,Installation_Address__PostalCode__s,
                                                                            Installation_Address__StateCode__s,Delivery_Address__Street__s,Delivery_Address__City__s,
                                                                            Delivery_Address__PostalCode__s,Delivery_Address__StateCode__s,Warehouse__r.WarehouseId__c,
                                                                      		Delivery_Start_Date__c,Confirmed_installation_time__c,Preliminary_installation_time__c,
                                                                            Installation_Date__c,Installation_Duration__c,Installation_Time__c,Delivery_End_Date__c,
                                                                            Delivery_Date__c,Delivery_Week__c, Reason_for_preliminary_contract__c,Case__r.Process_Class__c,Case__r.Cause_Code__c,Case__c,
                                                                            Case__r.Target_Code__c,Case__r.Description,Case__r.CreatedDate,Parent_Opportunity__r.Opportunity_Number__c,
                                                                            Case__r.Type,Case__r.Configuration_Product__r.RVN__c,Installation_Start_Date__c,Installation_End_Date__c
                                                                            from Opportunity where ID IN:oppIds]);
        System.debug('--- opportunityMap ---'+opportunityMap);
        
        // Get the opportunity to warehouse map(mainly for cases where warehouse is selected as the delivery option)
        /*Map<Id, String> opportunityIdToWarehouseId = new Map<Id, String>();
        for (Id oppId : opportunityMap.keyset()) {
                opportunityIdToWarehouseId.put(oppId, opportunityMap.get(oppId).Warehouse__r.WarehouseId__c);
        }*/
        
        
        Set<String> fileNames = new Set<String>();
        Decimal salesPrice = 0.00;
        Decimal FactoryPrice = 0.00;
        Decimal salesProductCost = 0.00;
		Decimal installationSupply = 0.00;
        Decimal salesSupplyCost = 0.00;
		Decimal factorySupplyCost = 0.00;
        Decimal freightCost = 0.00;
        Decimal salesFreightCost = 0.00;
        Decimal factoryFreightCost = 0.00;
        Decimal installationCost = 0.00;
        Decimal salesInstallationCost = 0.00;
        Decimal factoryInstallationCost = 0.00;
        Decimal additionalProductCost = 0.00;
        Decimal additionalSalesCost = 0.00;
        Decimal additionalFactoryCost = 0.00;
        Decimal costReservCost = 0.00;
        Decimal salesCostReservCost = 0.00;
        Decimal factoryCostReservCost = 0.00;
        Decimal rentedMachineryCost = 0.00;
        Decimal salesRentedMachineryCost = 0.00;
        Decimal factoryRentedMachineryCost = 0.00;
        Decimal permitCost = 0.00;
        Decimal salesPermitCost = 0.00;
        Decimal factoryPermitCost = 0.00;
        Decimal externalServiceCost = 0.00;
        Decimal salesExternalServiceCost = 0.00;
        Decimal factoryExternalServiceCost = 0.00;
        Decimal serviceCost = 0.00;
        Decimal salesServiceCost = 0.00;
        Decimal factorySalesServiceCost = 0.00;
        Decimal travelCost = 0.00;
        Decimal salesTravelCost = 0.00;
        Decimal factoryTravelCost = 0.00;
		Decimal quaranteeCost = 0.00;
        Decimal salesQuaranteeCost= 0.00;
        Decimal salesOtherCost = 0.00;
        Decimal factoryOtherCost = 0.00;
        
        
        for (Order orderRecord : orders) {
            System.debug('--- OrderGenerator - ContractId: '+orderRecord.ContractId);
            if (orderRecord.ContractId != null && contractIdMap.get(orderRecord.ContractId) != null) {
                
                Contract contractRecord = contractIdMap.get(orderRecord.ContractId);
				//System.debug('--- contractRecord ---'+contractRecord);
                
                // Preparing the cost and price values based on the cost category
                for(Id ordval : costAggregateMap.keyset()){
                    if(ordval == orderRecord.Id){
                        System.debug('costAggregateMap.get(opval)'+costAggregateMap.get(ordval));
                        List<AggregateResult> relatedAgr = costAggregateMap.get(ordval);
                        for(AggregateResult result : relatedAgr){
                            System.debug('--- result ---'+result.get('Cost_Category__c'));
                            if(result.get('Cost_Category__c') == 'FactoryPurchase'){
                                    FactoryPrice = FactoryPrice + (Decimal) result.get('factory');
                                    salesProductCost = salesProductCost + (Decimal) result.get('salesprice');
                            }else if(result.get('Cost_Category__c') == 'SalesFreight'){
                                    freightCost = freightCost + (Decimal) result.get('productcost');
                                    salesFreightCost = salesFreightCost + (Decimal) result.get('salesprice');
                                	factoryFreightCost = factoryFreightCost + (Decimal) result.get('factory');
                            }else if(result.get('Cost_Category__c') == 'Wages'){
                                    installationCost = installationCost + (Decimal) result.get('productcost');
                                    salesInstallationCost = salesInstallationCost + (Decimal) result.get('salesprice');
                                    factoryInstallationCost = factoryInstallationCost + (Decimal) result.get('factory');
                            }else if(result.get('Cost_Category__c') == 'CostReserv'){
                                    quaranteeCost = quaranteeCost + (Decimal) result.get('productcost');
                                    salesQuaranteeCost = salesQuaranteeCost + (Decimal) result.get('salesprice');
                            }else if(result.get('Cost_Category__c') == 'InstallSupplies'){
                                    installationSupply = installationSupply + (Decimal) result.get('productcost');
                                    salesSupplyCost = salesSupplyCost + (Decimal) result.get('salesprice');
                                	salesOtherCost = salesOtherCost + (Decimal) result.get('salesprice');
                                	factorySupplyCost = factorySupplyCost + (Decimal) result.get('factory');
                                	factoryOtherCost = factoryOtherCost + (Decimal) result.get('factory');
                            }else if(result.get('Cost_Category__c') == 'AdditionalSales'){
                                    additionalProductCost = additionalProductCost + (Decimal) result.get('productcost');
                                    additionalSalesCost = additionalSalesCost + (Decimal) result.get('salesprice');
                                    additionalFactoryCost = additionalFactoryCost + (Decimal) result.get('factory');
                            }else if(result.get('Cost_Category__c') == 'RentedMachinery'){
                                    rentedMachineryCost = rentedMachineryCost + (Decimal) result.get('productcost');
                                    salesRentedMachineryCost = salesRentedMachineryCost + (Decimal) result.get('salesprice');
                                    factoryRentedMachineryCost = factoryRentedMachineryCost + (Decimal) result.get('factory');
                            }else if(result.get('Cost_Category__c') == 'BuildingPermits'){
                                    permitCost = permitCost + (Decimal) result.get('productcost');
                                    salesPermitCost = salesPermitCost + (Decimal) result.get('salesprice');
                                    factoryPermitCost = factoryPermitCost + (Decimal) result.get('factory');
                            }else if(result.get('Cost_Category__c') == 'ExternalService'){
                                    externalServiceCost = externalServiceCost + (Decimal) result.get('productcost');
                                    salesExternalServiceCost = salesExternalServiceCost + (Decimal) result.get('salesprice');
                                    factoryExternalServiceCost = factoryExternalServiceCost + (Decimal) result.get('factory');
                            }else if(result.get('Cost_Category__c') == 'SalesService'){
                                    serviceCost = serviceCost + (Decimal) result.get('productcost');
                                    salesServiceCost = salesServiceCost + (Decimal) result.get('salesprice');
                                    factorySalesServiceCost = factorySalesServiceCost + (Decimal) result.get('factory');
                            }else if(result.get('Cost_Category__c') == 'TravelExpenses'){
                                    travelCost = travelCost + (Decimal) result.get('productcost');
                                    salesTravelCost = salesTravelCost + (Decimal) result.get('salesprice');
                                    factoryTravelCost = factoryTravelCost + (Decimal) result.get('factory');
                            }
                            salesPrice = salesProductCost  + salesFreightCost + salesInstallationCost + salesQuaranteeCost + salesSupplyCost + additionalSalesCost
                                         + salesRentedMachineryCost + salesPermitCost + salesExternalServiceCost
                                         + salesServiceCost + salesTravelCost;
                            //System.debug('--- salesPrice ---'+salesPrice);
                        }
                        
                    }
                }
                

                OrderJSON jsonContent = new OrderJSON();
                OrderInfo ordInfo = new OrderInfo();
                Opportunity o = opportunityMap.get(contractRecord.Opportunity__c);
                ordInfo.axcompanyId = contractRecord.Organization__c;//'LCE';
                ordInfo.currency1 = contractRecord.CurrencyIsoCode; //'EUR';
                ordInfo.customer_reference = (contractRecord.Customer_reference__c != null ? contractRecord.Customer_reference__c : ''); //'';
                if(contractRecord.Order_type__c == 'Reclamation'){
                    ordInfo.order_type = 'Claim'; //'Normal';
                }else{
                    ordInfo.order_type = contractRecord.Order_type__c; //'Normal';
                }
                ordInfo.order_number = contractRecord.Opportunity_Number__c ; //'90500086';
                ordInfo.vendorid = '';//contractRecord.Factory__c; //'';
                ordInfo.project_number = contractRecord.Project_Number__c; //'801062';
                ordInfo.parent_project = (contractRecord.Parent_Project__c != NULL ? contractRecord.Parent_Project__c : '');// ''
                ordInfo.project_group = contractRecord.Project_Group__c;
                ordInfo.customer_segmentid = contractRecord.Customer_Segment__c; //'1000';
                ordInfo.customer_segmentname = contractRecord.Customer_segment_name__c;//'Consumer apartment building';
                ordInfo.promised_deliveryweek = o.Delivery_week__c;//'2022/52';
                ordInfo.promised_date = String.valueOf(o.Delivery_Date__c); //Date.today();
                ordInfo.main_contractor = contractRecord.Main_Contractor__c; //'no';
                ordInfo.business_unit = contractRecord.Business_Unit__c;//'551';
                ordInfo.order_attachment = '\\\\\\\\frendsprod\\\\D365TEST\\\\SalesTori\\\\OUT\\\\attachments\\\\';// Just a Placeholder
            	
                //SubProject details
                SubprojectInfo subprojectInfo = new SubprojectInfo();
                Project__c subProj = subProjToMain.get(contractRecord.Opportunity__r.Project_Number__c);
                if(contractRecord.Parent_Project__c == NULL && contractRecord.Project_Number__c != NULL && o.Order_type__c != 'Reclamation'){
                    subprojectInfo.subproject_number = subProj.Project_Value__c;//'801062_01'contractRecord.Project_Number__c; //todo duplicated value
                    subprojectInfo.subproject_group = 'CONWar';//subProj.Project_Group__c;//'CONWar';//contractRecord.Project_Group__c;  //todo duplicated value
                    subprojectInfo.subproject_category = subProj.Project_Category__c;//'Warranty';//contractRecord.Project_Category__c;
                    subprojectInfo.subproject_cost =  quaranteeCost != 0.00 ? quaranteeCost : 0.00;  //36.03; //todo missed field - cost from asennus 2 
                    subprojectInfo.subproject_ordertype = 'Reclamation';//contractRecord.Order_type__c; //todo duplicated value
                    subprojectInfo.subproject_parentproject = subProj.Parent_Project__r.Project_Number__c;//'801062';//contractRecord.Parent_Project__c;
                    subprojectInfo.subproject_chargeable = subProj.Chargeable__c ? 'chargeable' : 'non-chargeable';//'non-chargeable';//String.valueOf(contractRecord.Chargeable__c);
                    ordInfo.subproject_info = subprojectInfo;
                }else{
                    ordInfo.subproject_info = subprojectInfo;
                }
            	
                // Budget values based on project categories
                Budget budget = new Budget();
                List<ProjectCategory> categories = new List<ProjectCategory>();
                if(FactoryPrice != 0.00){
                    categories.add(new ProjectCategory('FactoryPurchase', FactoryPrice)); // cost from Factory cost
                }
                if(installationSupply != 0.00){
                	categories.add(new ProjectCategory('InstallSupplies', installationSupply));
                }
                if(freightCost != 0.00){
                    categories.add(new ProjectCategory('SalesFreight', freightCost));
                }
                if(installationCost != 0.00){
                    categories.add(new ProjectCategory('Wages', installationCost));
                }
                if(quaranteeCost != 0.00){
                    categories.add(new ProjectCategory('CostReserv', quaranteeCost));
                }
                if(additionalProductCost != 0.00){
                    categories.add(new ProjectCategory('AdditionalSales', additionalProductCost));
                }
                if(rentedMachineryCost != 0.00){
                    categories.add(new ProjectCategory('RentedMachinery', rentedMachineryCost));
                }
                if(permitCost != 0.00){
                    categories.add(new ProjectCategory('BuildingPermits', permitCost));
                }
                if(externalServiceCost != 0.00){
                    categories.add(new ProjectCategory('ExternalService', externalServiceCost));
                }
                if(serviceCost != 0.00){
                    categories.add(new ProjectCategory('SalesService', serviceCost));
                }
                if(travelCost != 0.00){
                    categories.add(new ProjectCategory('TravelExpenses', travelCost));
                }
                
                
                budget.project_category = categories;
                ordInfo.budget = budget;
            
                ordInfo.domestic_help = ''; //todo missed field
                ordInfo.domestic_text = ''; //todo missed field
                ordInfo.chargeable = contractRecord.Chargeable__c;//String.valueOf(contractRecord.Chargeable__c); //todo duplicated value
                ordInfo.worknumbername = ''; //todo missed field
            
                PriceList plist = new PriceList();
                plist.pricelist_name = contractRecord.PriceBook_Name__c; //'Basic price list 1.4.2022';//contractRecord.PriceBook_Name__c;
                ordInfo.pricelist = plist;
                
                //Address details
                CustomerAddress custAdd = new CustomerAddress();
                if (contractRecord.AccountId != null && accountIdToAccount.get(contractRecord.AccountId) != null) {
                Account acc = accountIdToAccount.get(contractRecord.AccountId);
                custAdd.address_description = acc.LastName + ' ' +  acc.FirstName; // 'Kontkanen Veikko'
				custAdd.firstname = acc.FirstName; //'Veikko'
				custAdd.lastname = acc.LastName; // 'Kontkanen'
				custAdd.contact_person = ''; //todo missed field
				custAdd.street_address = o.Customer_Address__Street__s; //acc.BillingStreet; //'PL 36'
				custAdd.city = o.Customer_Address__City__s ;//acc.BillingCity; //'HELSINKI'
				custAdd.postal_code = o.Customer_Address__PostalCode__s;//acc.BillingPostalCode;//'621';
				custAdd.fax = acc.Fax;
				custAdd.country = 'FIN';//acc.BillingCountryCode;//
				custAdd.province = o.Customer_Address__StateCode__s;//acc.BillingState;
				custAdd.county = ''; //todo missed field
				custAdd.phone_number = o.Phone__c;//'3585073765';
				custAdd.email = o.Contact_Email__c;//'j@n.fi';
				custAdd.note = '';//todo missed field
				custAdd.number1 = '';//acc.AccountNumber;
				custAdd.customer_id = ''; // For B2C Empty For B2B this has to be filled in
				ordInfo.customer_address = custAdd;
				//System.debug('!! add: ' + custAdd);
				
				InvoiceAddress invAdd = new InvoiceAddress();
				invAdd.address_description = acc.LastName + ' ' +  acc.FirstName;
				invAdd.firstname = acc.FirstName; //'Veikko';
				invAdd.lastname = acc.LastName; //'Kontkanen';
				invAdd.contact_person = '';
				invAdd.street_address = o.Invoicing_Address__Street__s;//acc.BillingStreet; //'PL 36';
				invAdd.city = o.Invoicing_Address__City__s;//acc.BillingCity; //'HELSINKI';
				invAdd.postal_code = o.Invoicing_Address__PostalCode__s;//acc.BillingPostalCode; //'621';
				invAdd.fax = acc.Fax;
				invAdd.country = 'FIN';//acc.BillingCountryCode;
				invAdd.province = o.Invoicing_Address__StateCode__s;//acc.BillingState; //'';
				invAdd.county = '';
				invAdd.phone_number = o.Phone__c; //'3585073765';
				invAdd.email = o.Contact_Email__c; //'j@n.fi';
				invAdd.note = '';
				invAdd.payment_terms = contractRecord.Payment_Term__c;//'7';
				invAdd.invoice_type = o.Invoice_type__c;//'Email';
				if(contractRecord.Method_of_Payment__c == 'Financing'){
                    invAdd.number1 = acc.Financing_Customer_Number__c;
                }else{
                    invAdd.number1 = '';//acc.AccountNumber; //'';
                }
				invAdd.payment = contractRecord.Method_of_Payment__c;//'REF';
				invAdd.paytrail_reference_id = '';
				ordInfo.invoice_address = invAdd;


				InstallAddress instAdd = new InstallAddress();
				instAdd.address_description = acc.LastName + ' ' +  acc.FirstName; //'Kontkanen Veikko';
				instAdd.firstname = acc.FirstName; //'Veikko';
				instAdd.lastname = acc.LastName; //'Kontkanen';
				instAdd.contact_person = '';
				instAdd.street_address = o.Installation_Address__Street__s;//'PL 36';
				instAdd.city = o.Installation_Address__City__s;//'HELSINKI';
				instAdd.postal_code = o.Installation_Address__PostalCode__s;//'621';
				instAdd.fax = '';
				instAdd.country = 'FIN'; //contractRecord.Opportunity__r.Installation_Address__CountryCode__s;//'FIN';
				instAdd.province = o.Installation_Address__StateCode__s;//'';
				instAdd.county = '';
				instAdd.phone_number = o.Phone__c; //'3585073765';
				instAdd.email = o.Contact_Email__c; //'j@n.fi';
				instAdd.note = '';
				instAdd.number1 = '';
				ordInfo.install_address = instAdd;

				DeliveryAddress delivAdd = new DeliveryAddress();
                delivAdd.address_description = acc.LastName + ' ' +  acc.FirstName; //'Kontkanen Veikko';
                delivAdd.firstname = acc.FirstName; //'Veikko';
                delivAdd.lastname = acc.LastName; //'Kontkanen';
                delivAdd.contact_person = '';
                delivAdd.street_address = o.Delivery_Address__Street__s;//'PL 36';
                delivAdd.city =  o.Delivery_Address__City__s;//contractRecord.Opportunity__r.Building__r.Building_Address__City__s;//'HELSINKI';
                delivAdd.postal_code = o.Delivery_Address__PostalCode__s;//'621';
                delivAdd.fax = '';
                delivAdd.country = 'FIN';
                delivAdd.province = o.Delivery_Address__StateCode__s;//'';
                delivAdd.county = '';
                delivAdd.phone_number = o.Phone__c;//'3585073765';
                delivAdd.email = o.Contact_Email__c;//'j@n.fi';
                delivAdd.note = String.isNotBlank(o.Delivery_Note__c) ? o.Delivery_Note__c : '';//Added as part of LUM-2204
                delivAdd.number1 = '';
                delivAdd.delivery_terms = 'DAP';
                delivAdd.delivery_type = 'delivery';
                ordInfo.delivery_address = delivAdd;
                }
                SalesPerson salesPerson = new SalesPerson();
                OpportunityTeamMember ot = opportunityTeamMemberMap.get(contractRecord.Opportunity__c);   
                salesPerson.username = (o.OwnerId != null && o.Owner.Alias != null) ? o.Owner.Alias : '';
                salesPerson.supervisor = ot != NULL ? ot.User.Alias : ''; //LUM-979
                salesPerson.firstname = o.Owner.FirstName;
                salesPerson.lastname = o.Owner.LastName;
                ordInfo.sales_person = salesPerson;

                OrderWrapper ordWrap = new OrderWrapper();
                ordWrap.order_info = ordInfo;
                // How to get Product code value. Product group value is in Product group object
                GroupsWrapper groups = new GroupsWrapper();
                List<BaseGroup> grp = new List<BaseGroup>();
                
                

                //System.debug('--- contractRecord.Opportunity__c ---'+contractRecord.Opportunity__c);
                //System.debug('--- oppFileMap.keyset() ---'+oppFileMap.keyset().contains(contractRecord.Opportunity__c));
                
                if(oppToConfigProductMap.containsKey(o.Id)) {
                    // Get the Plan Ids
                    List<Configuration_Product__c> orderConfigProducts = new List<Configuration_Product__c> (oppToConfigProductMap.get(o.Id));                     
                    if(orderConfigProducts.size()>0) {
                        
                        List<BaseGroup> grpList = new List<BaseGroup>();
                        Map<String,BaseGroup> grpListMap = new Map<String,BaseGroup>();
                        Map<String,List<BaseGroup>> grpListMap2 = new Map<String,List<BaseGroup>>();
                        Map<String,List<Side>> singleSideListMap = new Map<String,List<Side>>();
                        String productAttribute = '';
                        for (Configuration_Product__c orderConfigProduct : orderConfigProducts){
                            BaseGroup g1 = new Group1();
                            Id orderConfigProductId = orderConfigProduct.Id;
                            String orderConfigProductRVN = orderConfigProduct.RVN__c;
                            //System.debug('--- orderConfigProduct Product__c ***'+orderConfigProduct.Product__c);
                            //System.debug('--- orderConfigProduct Product__r.Product_Group__c ***'+orderConfigProduct.Product__r.Product_Group__c);
                            String orderConfigProductGroup = orderConfigProduct.Product__r.Product_Group__c;
                            g1.delivery_batch = 1; 																	// For B2C always 1
                            g1.delivery_batch_status = 'Mitattu';													// Status of the delivery batch translated to selected language. Status is always “Measured”.                                       
                            g1.delivery_batch_receive_date = o.Delivery_End_Date__c != null ? String.valueOf(o.Delivery_End_Date__c) : ''; 		//Project sales: Delivery batch installation start date / Consumer sales: Order installation start date
                            g1.delivery_batch_delivery_date = o.Delivery_Start_Date__c!= null ? String.valueOf(o.Delivery_Start_Date__c) : '';
                            g1.group_attachment = ''; 																//location of  product card
                            g1.AXconfiguration = AX_PRODUCTS.contains(orderConfigProductGroup) ? 'yes' : 'no';		// (From Visual Plan Statistics xml we have to get product_name)product code is LUMON5 or LUMON6 or LUMON6T or LT3 or VT3  or KIINTEÄSEI or LUMON7S then ‘Yes’ else ‘No’
                            g1.group_name = orderConfigProductGroup; 											    // 'Abatible'; product group name with translation (LG, LGR) // Need to check SAI
                            g1.pcs = 1; 																			// hardcoded to 1 amount of visual plan products in group
                            
                            g1.structurenumber = orderConfigProductRVN;
                            if(o.Order_type__c == 'Reclamation' && o.Case__c != NULL){
                                g1.originalstructurenumber = o.Case__r.Configuration_Product__r.RVN__c;
                            }else{
                                g1.originalstructurenumber = ''; 
                            }														// Not needed right now (From JSON)IN case of claim this would be rvn number of parent
                            
                            g1.install_start_date = o.Installation_Start_Date__c !=null ? String.valueOf(o.Installation_Start_Date__c): ''; 
                            g1.install_end_date = o.Installation_End_Date__c != null ? String.valueOf(o.Installation_End_Date__c): ''; 
                            g1.additional_deliverytime = 1; 										// Need to check SAI
                            g1.process = orderConfigProduct.Inspection_Code__c  != 1 ? 'Special' : 'Normal';// --- (From JSON)Inspection_Code__c 1 then normal else special
                            g1.product_code = orderConfigProduct.Product__r.Sales_Code__c;//prodGroupCodeAxToCodeSales.get(prodName);//'90240001'; // Product name as LG --> converted to a code(From JSON)
                            g1.storageid = o.Warehouse__r.WarehouseId__c; //'ESP';													//opportunityIdToWarehouseId.get(orderRecord.OpportunityId) != null ? opportunityIdToWarehouseId.get(orderRecord.OpportunityId) : '';//'MAD'; // If delivery is to warehouse then opp.warehouse(From opp.deliverylocation query warehouse id from warehouse object) // Need to check SAI
                            g1.packing_order = 1;
                            g1.unit = orderConfigProduct.Configuration__r.Plan_Apartment__c != null ? orderConfigProduct.Configuration__r.Plan_Apartment__c : '';// The apartment of the visual plan. Need to Check SAI
                            g1.line = orderConfigProduct.Configuration__r.Plan_Line__c != null ? orderConfigProduct.Configuration__r.Plan_Line__c : '';
                            g1.floor = orderConfigProduct.Configuration__r.Plan_Floor__c != null ? String.valueOf(orderConfigProduct.Configuration__r.Plan_Floor__c) : '';
                            g1.salestori_plan_name = orderConfigProduct.Configuration__r.Plan_Name__c != null ? orderConfigProduct.Configuration__r.Plan_Name__c : '';
                            g1.chargeable = contractRecord.Chargeable__c;

                            if (String.isNotBlank(orderConfigProductId)) {
                                // Cost and Prices per Config Product (RVN)                               
                                Decimal factoryPriceRVN = 0.00;
                                Decimal productCostRVN = 0.00;
                                Decimal salesPriceRVN = 0.00;

                                Decimal factoryProductRVN = 0.00;
                                Decimal purchaseCostRVN = 0.00;                                                              
                                Decimal salesProductCostRVN = 0.00;

                                Decimal factoryFreightCostRVN = 0.00;
                                Decimal freightCostRVN = 0.00;
                                Decimal salesFreightCostRVN = 0.00;
                                

                                Decimal factoryInstallationCostRVN = 0.00;
                                Decimal installationCostRVN = 0.00;
                                Decimal salesInstallationCostRVN = 0.00;
                                

                                Decimal factoryOtherCostRVN = 0.00;
                                Decimal otherCostRVN = 0.00;
                                Decimal salesOtherCostRVN = 0.00;
                                

                                //11.10.2023 Check if Group Exists udpated to cotnains key
                                if(costAggregateMap.containsKey(orderRecord.Id)){
                                    List<AggregateResult> relatedAgr = costAggregateMap.get(orderRecord.Id);                                       
                                    for(AggregateResult result : relatedAgr){
                                        System.debug('--- result.get ---'+result.get('RVN_Number__c'));
                                        // PRODUCTS
                                        if(result.get('Cost_Category__c') == 'FactoryPurchase' && result.get('RVN_Number__c') == orderConfigProductRVN){                                               
                                                factoryProductRVN = factoryProductRVN + (Decimal) result.get('factory');     
                                                purchaseCostRVN = purchaseCostRVN + (Decimal) result.get('productcost');//Expected 0              
                                                salesProductCostRVN = salesProductCostRVN + (Decimal) result.get('salesprice');
                                                //System.debug('--- factoryProductRVN ---'+factoryProductRVN);
                                                //System.debug('--- purchaseCostRVN ---'+purchaseCostRVN);
                                                //System.debug('--- salesProductCostRVN ---'+salesProductCostRVN);
                                        // FREIGHT
                                        }else if(result.get('Cost_Category__c') == 'SalesFreight' && result.get('RVN_Number__c') == orderConfigProductRVN){
                                                freightCostRVN = freightCostRVN + (Decimal) result.get('productcost');                                                
                                                factoryFreightCostRVN = factoryFreightCostRVN + (Decimal) result.get('factory');// Expect 0
                                                salesFreightCostRVN = salesFreightCostRVN + (Decimal) result.get('salesprice');
                                                //System.debug('--- freightCostRVN ---'+freightCostRVN);                                               
                                                //System.debug('--- factoryFreightCostRVN ---'+factoryFreightCostRVN);
                                                //System.debug('--- salesFreightCostRVN ---'+salesFreightCostRVN);
                                        // INSTALLATION  = WAGES AND SUPPLIES
                                        }else if((result.get('Cost_Category__c') == 'Wages' || result.get('Cost_Category__c') == 'InstallSupplies') && result.get('RVN_Number__c') == orderConfigProductRVN){
                                            installationCostRVN = installationCostRVN + (Decimal) result.get('productcost');
                                            salesInstallationCostRVN = salesInstallationCostRVN + (Decimal) result.get('salesprice');
                                            factoryInstallationCostRVN = factoryInstallationCostRVN + (Decimal) result.get('factory');// Expect 0
                                            //System.debug('--- installationCostRVN ---'+installationCostRVN);
                                            //System.debug('--- salesInstallationCostRVN ---'+salesInstallationCostRVN);
                                            //System.debug('--- factoryInstallationCostRVN ---'+factoryInstallationCostRVN);
                                        // OTHER COSTS
                                        }else if(result.get('RVN_Number__c') == orderConfigProductRVN){
                                            otherCostRVN = otherCostRVN + (Decimal) result.get('productcost');
                                            factoryOtherCostRVN = factoryOtherCostRVN + (Decimal) result.get('factory');
                                            salesOtherCostRVN = salesOtherCostRVN + (Decimal) result.get('salesprice');
                                            //System.debug('--- otherCostRVN ---'+otherCostRVN);
                                            //System.debug('--- factoryOtherCostRVN ---'+factoryOtherCostRVN);
                                            //System.debug('--- salesOtherCostRVN ---'+salesOtherCostRVN);                                       
                                        } 
                                        
                                                        
                                        //System.debug('--- salesInstallationCostRVN ---'+salesInstallationCostRVN);
                                    }
                                    // Sum to get the Column Totals
                                    factoryPriceRVN = factoryProductRVN + factoryFreightCostRVN  + factoryInstallationCostRVN + factoryOtherCostRVN;
                                    productCostRVN = purchaseCostRVN  + freightCostRVN + installationCostRVN + otherCostRVN;
                                    salesPriceRVN = salesProductCostRVN  + salesFreightCostRVN + salesInstallationCostRVN + salesOtherCostRVN;
                                    System.debug('--- salesPriceRVN ---'+salesPriceRVN);
                                }
                                //Factory Prices
                                
                                g1.fproduct = factoryProductRVN.setScale(2); //3.2;
                                g1.ffreight = factoryFreightCostRVN.setScale(2); //3.2;
                                g1.finstall = factoryInstallationCostRVN.setScale(2);//90.2;
                                g1.fother = factoryOtherCostRVN.setScale(2);
                                g1.factory_price = factoryPriceRVN.setScale(2); //87.2;
                                // Purchase Prices aka Cost 
                                // 30.01.2024 Update Purchase Price is not only Cost                              
                                g1.pproduct = factoryProductRVN.setScale(2);  //purchaseCostRVN.setScale(2);//12.3;
                                g1.pfreight = factoryFreightCostRVN.setScale(2);//freightCostRVN.setScale(2);// 124.2;
                                g1.pinstall = factoryInstallationCostRVN.setScale(2);//installationCostRVN.setScale(2); //3123.1;
                                g1.pother = factoryOtherCostRVN.setScale(2); //otherCostRVN.setScale(2);
                                g1.purchase_price = factoryPriceRVN.setScale(2); //productCostRVN.setScale(2);//4324.2;
                                // Sales Prices
                                g1.sales_price = salesPriceRVN.setScale(2);//4324.2;
                                g1.sproduct = salesProductCostRVN.setScale(2);//12.3;
                                g1.sfreight = salesFreightCostRVN.setScale(2);// 124.2;
                                g1.sinstall = salesInstallationCostRVN.setScale(2); //3123.1;
                                g1.sother = salesOtherCostRVN.setScale(2);
                                // Totals
                                g1.calculated_salesprice = salesPriceRVN.setScale(2);// Need to check SAI
                                g1.contract_price = 0;// Need to check SAI @contractPrice = @contractPercent / 100.00 * @cost (installation cost (tier2))

                            }
							System.debug('--- OrderGenerator - VISUAL_PRODUCTS ='+VISUAL_PRODUCTS);
                            System.debug('--- OrderGenerator - Product Group: '+orderConfigProductGroup);
                            if(VISUAL_PRODUCTS.contains(orderConfigProductGroup)) {
								if(oppFileMap.keyset().contains(o.Id)){
                                    List<ContentVersion> cvDataList = oppFileMap.get(o.Id);
                                    for(ContentVersion statsFile : cvDataList){
                                        // Check whether the product belongs to balcony glazing or terrace products
                                        
                                        if(statsFile.title.contains('Visual Plan Statistics')|| statsFile.title.contains('Visual_Plan_Statistics')){
                                            String prodVal = statsFile.Title.contains('Visual Plan Statistics_') ? statsFile.Title.substringAfter('Visual Plan Statistics_') :  statsFile.Title.substringAfter('Visual_Plan_Statistics_');

                                            prodVal = prodVal.substringBefore('_');
                                            System.debug('--- prodVal ---'+prodVal);
                                            Set<String> mainProducts = new Set<String>{'LG','LGS', 'LFIXEDWALL', 'LRAILV', 'LRAILH', 'VT3', 'VT4'};
                                            if(mainProducts.contains(prodVal)){
                                                String planName = '';
                                                String productName = '';
                                                DOM.Document doc=new DOM.Document();
                                                doc.load(statsFile.VersionData.toString());
                                                Dom.XMLNode productRoot = doc.getRootElement();
                                                Dom.XMLNode weight;
                                            
                                                for(Dom.XMLNode product : productRoot.getChildElements()){
                                                    
                                                    String rvnnumber;
                                                    if(product.getname() == 'balconyglazing'){
                                                        weight = product.getChildElement('weight', null);
                                                        productName = 'balconyglazing';
                                                    }else if(product.getName().contains('terrace')){
                                                        productName = 'terrace';
                                                    }else if(product.getName().contains('balustrade')){
                                                        productName = 'balustrade';
                                                    }
                                                    String vps = statsFile.VersionData.toString();
                                                    String rvnVps = vps.substringBetween('<structural_version_number>', '</structural_version_number>');
                                                    rvnnumber =  contractRecord.Opportunity_Number__c + rvnVps;
                                                    //System.debug('--- rvnnumber 1 ---'+rvnnumber);
                                                    //System.debug('--- rvnnumber 1a ---'+grpListMap.keyset().contains(orderConfigProductRVN));
                                                    //System.debug('--- rvnnumber 1b ---'+orderConfigProductRVN);
                                                    if(!grpListMap.keyset().contains(orderConfigProductRVN) && orderConfigProductRVN == rvnnumber && productName != ''){
                                                        													//For B2B
                                                        
                                                        //System.debug('--- came inside for rvn 1 ---'+rvnnumber+ '--- conprod 1 ---'+orderConfigProductRVN);
                                                        if(productName == 'balconyglazing'){
                                                            String areaVal = vps.substringBetween('<area><value>', '</value></area>');
                                                            String blindsVal = vps.substringBetween('<blinds_area><value>', '</value></blinds_area>');
                                                            String glassCount = vps.substringBetween('<glass_count><value>', '</value></glass_count>');
                                                            String groupWeight = vps.substringBetween('<weight><value>', '</value></weight>');
                                                            String productLength = vps.substringBetween('<product_width><value>', '</value></product_width>');
                                                            productAttribute = vps.substringBetween('<salescode><value>', '</value></salescode>');
                                                            if (areaVal != null) {
                                                                g1.glass_m2 = (Double)Decimal.valueOf(areaVal).setScale(2);
                                                            }  
                                                            if (blindsVal != null) {
                                                                g1.blinds_m2 = (Double)Decimal.valueOf(blindsVal).setScale(2);
                                                            }
                                                            if (glassCount != null) {
                                                                g1.glass_pcs = Integer.valueOf(glassCount);
                                                            }
                                                            if (groupWeight != null && String.isNotBlank(groupWeight)) {
                                                                g1.group_weight = (Double)Decimal.valueOf(groupWeight).setScale(2);
                                                            }
                                                            if(productLength != null && String.isNotBlank(productLength)){
                                                                //g1.product_length = Integer.valueOf(productLength);
                                                                //System.debug('--- productLength val ---'+productLength);
                                                                g1.product_length = (Integer)Decimal.valueOf(productLength).setScale(0);
                                                                //System.debug('--- g1.product_length val ---'+g1.product_length);
                                                            }
                                                        }else if(productName == 'terrace'){
                                                            g1.glass_m2 = 0.00;
                                                            g1.blinds_m2 = 0.00;
                                                            g1.glass_pcs = 0;
                                                            g1.group_weight = 0;
                                                            g1.product_length = 0;
                                                            productAttribute = '';
                                                        }else if(productName == 'balustrade'){
                                                            String areaVal = vps.substringBetween('<area><value>', '</value></area>');
                                                            String postCount = vps.substringBetween('<post_count><value>', '</value></post_count>');
                                                            String groupWeight = vps.substringBetween('<weight><value>', '</value></weight>');
                                                            String productLength = vps.substringBetween('<length><value>', '</value></length>');
                                                            productAttribute = '';
                                                            if (areaVal != null) {
                                                                g1.glass_m2 = (Double)Decimal.valueOf(areaVal).setScale(2);
                                                            } 
                                                            g1.blinds_m2 = 0.00;
                                                            if (postCount != null) {
                                                                g1.glass_pcs = Integer.valueOf(postCount);
                                                            }
                                                            if (groupWeight != null && String.isNotBlank(groupWeight)) {
                                                                g1.group_weight = (Double)Decimal.valueOf(groupWeight).setScale(2);
                                                            }
                                                            if(productLength != null && String.isNotBlank(productLength)){
                                                                //g1.product_length = Integer.valueOf(productLength);
                                                                //System.debug('--- productLength val ---'+productLength);
                                                                g1.product_length = (Integer)Decimal.valueOf(productLength).setScale(0);
                                                                //System.debug('--- g1.product_length val ---'+g1.product_length);
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                                
                                        }
                                    }
                                    for(ContentVersion docFile : cvDataList){   
                                        //System.debug('--- docFile title ---'+docFile.title);
                                        String rvnDoc;
                                        List<Side> singleSideList = new List<Side>();
                                        // Get the doc file related to the 
                                        // 15.02.2024 Start Updates for Balustrade Structure
                                        
                                        if(docFile.title.contains('Documentation')){
                                            System.debug('--- OrderGenerator - Processing Documentation.xml with Name: '+docFile.title);
                                            DOM.Document doc=new DOM.Document();
                                            String docXmlString = docFile.VersionData.toString();
                                            // 01.02.2024 replace CDATA tag if it is present
                                            if (docXmlString.contains('[CDATA[')){
                                                docXmlString = docXmlString.replace('<![CDATA[', '');
                                                docXmlString = docXmlString.replace(']]>', '');
                                                docXmlString = docXmlString.replace('&lt;![CDATA[', '');
                                                docXmlString = docXmlString.replace(']]&gt;', '');
                                            }
                                            doc.load(docXmlString);

                                            Dom.XMLNode product = doc.getRootElement();
                                            //System.debug('--- OrderGenerator - Root Node: '+product.getChildElements());
                                            Integer productCount = 0;
                                            for(Dom.XMLNode prod : product.getChildElements()){
                                                System.debug('--- OrderGenerator - Product Node: '+prod);
                                                String rvnNumber = orderConfigProductRVN;
                                                String structureNumber = rvnNumber.right(8);
                                                //List<Side> singleSideList = new List<Side>();
                                                String productFamily = prod.getName();
                                                System.debug('--- OrderGenerator - Product Family '+productFamily+' Elements: '+prod.getChildElements());
                                                if(productFamily == 'balustrade' && productCount <1){
                                                    for(Dom.XMLNode child : prod.getChildElements()) {
                                                        if(child.getName() == 'structural_version_number'){
                                                            String xmlStructureNumber = child.getText();
                                                            if (structureNumber != xmlStructureNumber) {
                                                                break;
                                                            }
                                                            productCount++;
                                                            System.debug('--- OrderGenerator - Product Counter: '+productCount);
                                                            Integer fileCount=0;
                                                            for(ContentDocumentLink link : structureFileLinks){   
                                                                fileCount++;
                                                                System.debug('--- OrderGenerator - File Counter: '+fileCount);
                                                                String structureFileName = link.ContentDocument.Title;
                                                                System.debug('--- OrderGenerator - structureFile Name: '+structureFileName);
                                                                
                                                                // Get the Structure file related to the RVN
                                                                if(structureFileName.contains('Structure') && structureFileName.contains(structureNumber)){ 
                                                                System.debug('--- OrderGenerator - Processing structure File for RVN: '+rvnNumber);
                                                                String structureContent = link.ContentDocument.LatestPublishedVersion.VersionData.toString(); 
                                                                System.debug('--- OrderGenerator - JSON String: '+JSON.serializePretty(structureContent));
                                                                StructureData.Structure structure = (StructureData.Structure) JSON.deserialize(structureContent,StructureData.Structure.class);

                                                                //List<StructureData.Structure> structures = StructureData.parseStructure (structureContent);

                                                                Integer openingCount = 0;
                                                                Integer sideCount = 0;
                                                                if (String.isNotBlank(structure.structure_number)) {
                                                                    System.debug('--- OrderGenerator - structure RVN: '+structure.structure_number);
                                                                    List<StructureData.ProductOpening> openings = structure.Product_opening;                                                                   
                                                                    for (StructureData.ProductOpening opening :openings){
                                                                        openingCount++;
                                                                        System.debug('--- OrderGenerator - Opening Counter: '+openingCount);
                                                                        String upperProfile = opening.upper_profile;
                                                                        String upperProfileColor = opening.upper_profile_color;
                                                                        String lowerProfile = opening.lower_profile;
                                                                        String lowerProfileColor = opening.lower_profile_color;
                                                                        Double glassThickness = opening.glass_thickness;
                                                                        String telescopicProfile = opening.telescopic_profile;

                                                                        List<StructureData.Side> sides = opening.side;
                                                                        //System.debug('--- OrderGenerator - structure Sides: '+sides);
                                                                        for (StructureData.Side side : sides){
                                                                            sideCount++;
                                                                            System.debug('--- OrderGenerator - Side Counter: '+sideCount);
                                                                            System.debug('--- OrderGenerator - structure Side: '+side);
                                                                            System.debug('--- OrderGenerator - structure Side Number: '+side.side_number);
                                                                            /* Attributes expected in Item Requirements for each Side
                                                                            <sivu>
                                                                                <numero>1</numero>
                                                                                <alkukulma>90</alkukulma>
                                                                                <loppukulma>90</loppukulma>
                                                                                <jarjestelmakulma>90</jarjestelmakulma>
                                                                                <lasitus-pituus>3500</lasitus-pituus>
                                                                                <lasitus-korkeus>1100</lasitus-korkeus>
                                                                                <profiilipituus>3500</profiilipituus>
                                                                                <lasivasen-kpl>4</lasivasen-kpl>
                                                                            </sivu>
                                                                            */
                                                                            Side s = new Side();
                                                                            s.StructureNumber = rvnnumber;
                                                                            s.side_number = side.side_number;
                                                                            // 04.03.2024 Fix for null values in balustrade Structure File
                                                                            s.start_angle = String.isNotBlank(String.valueof(side.start_angle)) ? Integer.valueOf(side.start_angle): 0;
                                                                            s.end_angle = String.isNotBlank(String.valueof(side.end_angle)) ? Integer.valueOf(side.end_angle): 0;
                                                                            s.system_angle = String.isNotBlank(String.valueof(side.system_angle)) ? Integer.valueOf(side.system_angle): 0;
                                                                            s.glazing_length = Integer.valueOf(side.product_length);
                                                                            s.glazing_height = Integer.valueOf(side.balcony_glazing_height);
                                                                            s.profile_length = Integer.valueOf(side.length);
                                                                            s.glass_left_pcs = side.glass_panels_left;
                                                                            s.upper_profile = 0;
                                                                            s.upper_profilecolour = '';
                                                                            s.lower_profile = 0;
                                                                            s.lower_profilecolour = '';
                                                                            s.glass_thickness = 0;
                                                                            s.glass_type = '';
                                                                            s.plastic_colour = '';
                                                                            s.telescopic_profile = 0;
                                                                            s.glass_right_pcs = 0;
                                                                            s.corner_bypass = 0;
                                                                            s.side_weight = 0;
                                                                            System.debug('--- OrderGenerator - RVN '+rvnnumber+' side '+sideCount+' - Adding Side to Map');
                                                                            if(!singleSideListMap.containsKey(rvnnumber)) {
                                                                                singleSideListMap.put(rvnnumber, new List<OrderGenerator.Side>());
                                                                                System.debug('--- OrderGenerator - RVN '+rvnnumber+' side '+sideCount+' - Adding New RVN to Map');
                                                                            }
                                                                            System.debug('--- OrderGenerator - RVN '+rvnnumber+' side '+sideCount+' - Adding New Side to Map');
                                                                            singleSideListMap.get(rvnnumber).add(s);
                                                                            System.debug('--- OrderGenerator - RVN '+rvnnumber+' side '+sideCount+' - Side List '+singleSideList);   
                                                                        }
                                                                    }
                                                                }
                                                                }
                                                            }
                                                        }
                                                    }   
                                                } else if(productFamily == 'balconyglazing' 
                                                    || productFamily == 'terrace' 
                                                    || productFamily== 'vt4terrace' 
                                                    ){
                                                    for(Dom.XMLNode child : prod.getChildElements()) {
                                                        System.debug('--- OrderGenerator - Product Child Element Name: '+child.getName());
                                                        if(child.getName() == 'structural_version_number'){
                                                            rvnDoc = child.getText();
                                                            System.debug('--- OrderGenerator - Product Child Element Value:-'+rvnDoc);
                                                            rvnnumber =  contractRecord.Opportunity_Number__c + child.getText();
                                                            System.debug('--- OrderGenerator - Product Child Element Name:-'+rvnnumber);                                                        
                                                        }
                                                        
                                                        if (child.getName() == 'order_xml_info') {
                                                            // 15.02.2024 End Updates for Balustrade Structure
                                                            if(orderConfigProductRVN == rvnnumber && prod.getName() != ''){
                                                                //System.debug('--- came inside for rvn 2 ---'+rvnnumber+ '--- conprod 2 ---'+orderConfigProductRVN);
                                                                String orderXmlInfoValue = child.getText();
                                                                String sivut = orderXmlInfoValue.substringBetween('<sivut>','</sivut>');
                                                                List<String> sivus = sivut.split('</sivu>');
                                                                for (String sivuVal : sivus) {
                                                                    Side s = new Side();
                                                                    System.debug('--- rvnnumber 2 ---'+rvnnumber);
                                                                    System.debug('--- side number value ---'+sivuVal.substringBetween('<numero>', '</numero>'));
                                                                    s.StructureNumber = rvnnumber;
                                                                    if(sivuVal.contains('<numero>')){
                                                                            s.side_number = sivuVal.substringBetween('<numero>', '</numero>') != '' ? Integer.valueOf(sivuVal.substringBetween('<numero>', '</numero>')) : 0;//11241205; // Doc xml order_xml_info -  profiili-saato
                                                                        }
                                                                        if(sivuVal.contains('<profiilivari-yla>')){ 
                                                                            s.upper_profilecolour = sivuVal.substringBetween('<profiilivari-yla>', '</profiilivari-yla>') != '' ? sivuVal.substringBetween('<profiilivari-yla>', '</profiilivari-yla>') : '';//'RAL7012'; // (Doc xml order_xml_info - profiilivari-yla)
                                                                        }else{
                                                                            s.upper_profilecolour = '';
                                                                        }
                                                                        if(sivuVal.contains('<profiilivari-ala>')){ 
                                                                            s.lower_profilecolour = sivuVal.substringBetween('<profiilivari-ala>', '</profiilivari-ala>') != '' ? sivuVal.substringBetween('<profiilivari-ala>', '</profiilivari-ala>') : '';//'RAL7012'; // (Doc xml order_xml_info - profiilivari-yla)
                                                                        }else{
                                                                            s.lower_profilecolour = '';
                                                                        } 
                                                                        //s.lower_profilecolour = sivuVal.substringBetween('<profiilivari-ala>', '</profiilivari-ala>');//'RAL7012'; // Doc xml order_xml_info - profiilivari-ala
                                                                        if(sivuVal.contains('<lasi-vahvuus>')){
                                                                            s.glass_thickness = sivuVal.substringBetween('<lasi-vahvuus>', '</lasi-vahvuus>') != '' ? Integer.valueOf(sivuVal.substringBetween('<lasi-vahvuus>', '</lasi-vahvuus>')) : 0;//6; // Doc xml order_xml_info -  lasi-vahvuus
                                                                        }else{
                                                                            s.glass_thickness = 0;
                                                                        }
                                                                        if(sivuVal.contains('<lasi-vari>')){
                                                                            s.glass_type = sivuVal.substringBetween('<lasi-vari>', '</lasi-vari>') != '' ? sivuVal.substringBetween('<lasi-vari>', '</lasi-vari>') : '';
                                                                        }else{
                                                                            s.glass_type = '';
                                                                        }
                                                                        
                                                                        //s.glass_type = sivuVal.substringBetween('<lasi-vari>', '</lasi-vari>');//'20090016'; // Doc xml order_xml_info -  lasi-vari
                                                                        if(sivuVal.contains('<muovivari-yla>')){
                                                                            s.plastic_colour = sivuVal.substringBetween('<muovivari-yla>', '</muovivari-yla>') != '' ? sivuVal.substringBetween('<muovivari-yla>', '</muovivari-yla>') : '';//'Tummanharmaa'; //Doc xml order_xml_info -  muovivari-yla
                                                                        }else{
                                                                            s.plastic_colour = '';
                                                                        }
                                                                        if(sivuVal.contains('<profiili-yla>')){
                                                                            s.upper_profile = sivuVal.substringBetween('<profiili-yla>', '</profiili-yla>') != '' ? Integer.valueOf(sivuVal.substringBetween('<profiili-yla>', '</profiili-yla>')) : 0;//11222208; //Doc xml order_xml_info -  profiili-yla
                                                                        }else{
                                                                            s.upper_profile = 0;
                                                                        }
                                                                        if(sivuVal.contains('<profiili-ala>')){
                                                                            s.lower_profile = sivuVal.substringBetween('<profiili-ala>', '</profiili-ala>') != '' ? Integer.valueOf(sivuVal.substringBetween('<profiili-ala>', '</profiili-ala>')) : 0;//11243001; //Doc xml order_xml_info -  profiili-ala
                                                                        }else{
                                                                            s.lower_profile = 0;
                                                                        }
                                                                        
                                                                        if(sivuVal.contains('<profiili-saato>')){
                                                                            s.telescopic_profile = sivuVal.substringBetween('<profiili-saato>', '</profiili-saato>') != '' ? Integer.valueOf(sivuVal.substringBetween('<profiili-saato>', '</profiili-saato>')) : 0;//11241205; // Doc xml order_xml_info -  profiili-saato
                                                                        }else{
                                                                            s.telescopic_profile = 0;
                                                                        }
                                                                        if(sivuVal.contains('<profiilipituus>')){
                                                                            s.profile_length = sivuVal.substringBetween('<profiilipituus>', '</profiilipituus>') != '' ? Integer.valueOf(sivuVal.substringBetween('<profiilipituus>', '</profiilipituus>')) : 0;//6440; // Doc xml order_xml_info -  profiilipituus
                                                                        }
                                                                        if(sivuVal.contains('<lasitus-pituus>')){
                                                                            s.glazing_length = sivuVal.substringBetween('<lasitus-pituus>', '</lasitus-pituus>') != '' ? Integer.valueOf(sivuVal.substringBetween('<lasitus-pituus>', '</lasitus-pituus>')) : 0;//6440; //Doc xml order_xml_info -  lasitus-pituus
                                                                        }else{
                                                                            s.glazing_length = 0;
                                                                        }
                                                                        if(sivuVal.contains('<lasitus-korkeus>')){
                                                                            s.glazing_height = sivuVal.substringBetween('<lasitus-korkeus>', '</lasitus-korkeus>') != '' ? Integer.valueOf(sivuVal.substringBetween('<lasitus-korkeus>', '</lasitus-korkeus>')) : 0;//1170; //Doc xml order_xml_info -  lasitus-korkeus
                                                                        }else{
                                                                            s.glazing_height = 0;
                                                                        }
                                                                        if(sivuVal.contains('<lasivasen-kpl>')){
                                                                            s.glass_left_pcs = sivuVal.substringBetween('<lasivasen-kpl>', '</lasivasen-kpl>') != '' ? Integer.valueOf(sivuVal.substringBetween('<lasivasen-kpl>', '</lasivasen-kpl>')) : 0;//3; //Doc xml order_xml_info -  lasivasen-kpl
                                                                        }else{
                                                                            s.glass_left_pcs = 0;
                                                                        }
                                                                        if(sivuVal.contains('<lasioikea-kpl>')){
                                                                            s.glass_right_pcs = sivuVal.substringBetween('<lasioikea-kpl>', '</lasioikea-kpl>') != '' ? Integer.valueOf(sivuVal.substringBetween('<lasioikea-kpl>', '</lasioikea-kpl>')) : 0;//5; //Doc xml order_xml_info -  lasioikea-kpl
                                                                        }else{
                                                                            s.glass_right_pcs = 0;
                                                                        }
                                                                        if(sivuVal.contains('<kulmanylitys>')){
                                                                            s.corner_bypass = sivuVal.substringBetween('<kulmanylitys>', '</kulmanylitys>') != '' ? Integer.valueOf(sivuVal.substringBetween('<kulmanylitys>', '</kulmanylitys>')) : 0;//0; //Doc xml order_xml_info -  kulmanylitys
                                                                        }else{
                                                                            s.corner_bypass = 0;
                                                                        }
                                                                        if(sivuVal.contains('<sivun-paino>')){
                                                                            s.side_weight = sivuVal.substringBetween('<sivun-paino>', '</sivun-paino>') != '' ?Double.valueOf(sivuVal.substringBetween('<sivun-paino>', '</sivun-paino>')) : 0;//194.223; //(Doc xml order_xml_info - sivun-paino)
                                                                        }else{
                                                                            s.side_weight = 0;
                                                                        }
                                                                        if(sivuVal.contains('<alkukulma>')){
                                                                            s.start_angle = sivuVal.substringBetween('<alkukulma>', '</alkukulma>') != '' ? Integer.valueOf(sivuVal.substringBetween('<alkukulma>', '</alkukulma>')) : 0;//90; //Doc xml order_xml_info -  alkukulma
                                                                        }else{
                                                                            s.start_angle = 0;
                                                                        }
                                                                        if(sivuVal.contains('<loppukulma>')){
                                                                            s.end_angle = sivuVal.substringBetween('<loppukulma>', '</loppukulma>') != '' ? Integer.valueOf(sivuVal.substringBetween('<loppukulma>', '</loppukulma>')) : 0;//90; //Doc xml order_xml_info -  loppukulma
                                                                        }else{
                                                                            s.end_angle = 0;
                                                                        }
                                                                        if(sivuVal.contains('<jarjestelmakulma>')){
                                                                            s.system_angle = sivuVal.substringBetween('<jarjestelmakulma>', '</jarjestelmakulma>') != '' ? Integer.valueOf(sivuVal.substringBetween('<jarjestelmakulma>', '</jarjestelmakulma>')) : 0;//Integer.valueOf(orderXmlInfoValue.substringBetween('<jarjestelmakulma>', '</jarjestelmakulma>'));//0; //Doc xml order_xml_info -  jarjestelmakulma
                                                                        }else{
                                                                            s.system_angle = 0;
                                                                        }
                                                                        if(!singleSideListMap.containsKey(rvnnumber)) {
                                                                            singleSideListMap.put(rvnnumber, new List<OrderGenerator.Side>());
                                                                        }
                                                                        singleSideListMap.get(rvnnumber).add(s);
                                                                        System.debug('--- singleSideList ---'+singleSideList);
                                                                        System.debug('--- rvnnumber ---'+rvnnumber);
                                                                }
                                                            }
                                                        }
                                                    }
                                                } 
                                            }
                                         }
                                    }   
                                }
                            }else if(!OTHER_PRODUCTS.contains(orderConfigProductGroup)){
                                g1.glass_m2 = 0.00;
                                g1.blinds_m2 = 0.00;
                                g1.glass_pcs = 0;
                                g1.group_weight = 0;
                                g1.product_length = 0;
                                productAttribute = '';
                                System.debug('--- Other Product - Continue---'); 
                            } else {
                                g1.glass_m2 = 0.00;
                                g1.blinds_m2 = 0.00;
                                g1.glass_pcs = 0;
                                g1.group_weight = 0;
                                g1.product_length = 0;
                                productAttribute = '';
                                System.debug('--- '+orderConfigProductGroup+' is Not an Activated Product');   
                            } 
                            ProductAttributes pdAttr = new ProductAttributes();
                            if(productAttribute != null && String.isNotBlank(productAttribute)){
                                pdAttr.attributeid = productAttribute;
                            }else{
                                pdAttr.attributeid = '';
                            }

                            g1.product_attributes = pdAttr;
                            if(o.Order_type__c == 'Reclamation' && o.Case__c != NULL && o.Case__r.Type == 'Reclamation order'){
                                Reclamation recl = new Reclamation();
                                recl.class1 = o.Case__r.Process_Class__c;
                                recl.class2 = o.Case__r.Target_Code__c;
                                recl.class3 = o.Case__r.Cause_Code__c;
                                recl.description = o.Case__r.Description;
                                recl.reclamation_order = o.Parent_Opportunity__r.Opportunity_Number__c;
                                Date caseLoggedDate = Date.newInstance(o.Case__r.CreatedDate.year(), o.Case__r.CreatedDate.month(), o.Case__r.CreatedDate.day());
                                recl.caselog = caseLoggedDate;
                                ((Group1)g1).reclamation = recl;
                            } else {
                                g1 = (BaseGroup)(JSON.deserialize(JSON.serialize(g1), BaseGroup.class));
                            }
                            
                            System.debug('--- g1 value ---'+g1);
                            grpList.add(g1);
                            grpListMap.put(orderConfigProductRVN,g1);
                            grpListMap2.put(orderConfigProductRVN,grpList);    
                        }
                        System.debug('--- grpListMap.keyset() ---'+grpListMap.keyset());
                        System.debug('--- singleSideListMap.keyset() ---'+singleSideListMap.keyset());
                        System.debug('--- grpListMap() ---'+grpListMap);
                        System.debug('--- singleSideListMap() ---'+singleSideListMap);
                        for(String grpval : grpListMap.keyset()){
                            System.debug('--- grpval ---'+grpval);
                            for(String sval : singleSideListMap.keySet()){ //todo SAI- please check it
                                System.debug('--- sval ---'+sval);
                                Sides sides = new Sides();
                                if(grpval == sval){
                                    System.debug('--- grpval 2---'+grpval);
                                    System.debug('--- sval 2 ---'+sval);
                                    sides.side = singleSideListMap.get(sval);
                                    grpListMap.get(grpval).sides =sides;
                                    System.debug('--- grplistmap value ---'+grpListMap.get(grpval));
                                    
                                }
                            }
                            System.debug('--- grp value ---'+grpval);
                            grp.add(grpListMap.get(grpval));
                        }
                        
                    }
                }                
                
                
                groups.group1 = grp;
                System.debug('--- groups value ---'+groups);
                ordWrap.groups = groups;
            	System.debug('--- ordWrap.groups value ---'+ordWrap.groups);
                jsonContent.order = ordWrap;
            
                ContentVersion contVerFile = new ContentVersion();
                contVerFile.VersionData = Blob.valueOf(JSON.serialize(jsonContent));
                contVerFile.Title = 'OrderJSON-' +  orderRecord.OrderNumber +'.json';
                contVerFile.ContentLocation= 's';
                if (orderIdToContentDocumentId.get(orderRecord.Id) != null) {
                    System.debug('--- orderIdToContentDocumentId.get(orderRecord.Id) ---'+orderIdToContentDocumentId.get(orderRecord.Id));
                    contVerFile.ContentDocumentId = orderIdToContentDocumentId.get(orderRecord.Id);
                }
                contVerFile.PathOnClient='OrderJSON-' +  orderRecord.Id +'.json';
                fileNames.add('OrderJSON-' +  orderRecord.Id +'.json');
                documentsToInsert.add(contVerFile);
                
                
                
                for(Configuration_Product__c conProd : configurationProductMap.values()){
                    List<ContentVersion> docList = configOutputFileMap.get(conProd.Configuration__c);

                    if (docList != null && docList.size() > 0) {
                        for(ContentVersion doc : docList){
                            System.debug('--- Preparing '+doc.FileExtension+' File to Production doc ---'+doc.Title);
                            System.debug('--- doc file extension ---'+doc.Title);
                            if (doc != null && doc.FileExtension == 'xml') {
                                System.debug('--- Processing Document: '+doc.Title);
                                String versionData = doc.VersionData.toString();
                                String currentRVN = '';
                                String updatedRVN = '';
                                String updatedSalesCode = '';
                                String specialOrder = '';
                                String docTitle = doc.Title.contains('Output') ? doc.Title.substringAfter('Output_') :  doc.Title.substringAfter('Structure_');
                                String fileRVNString = doc.Title.contains('Output') ? doc.Title.substringAfter('Output_') :  doc.Title.substringAfter('Structure_');
                                String endpoint = credentialsFiles.Endpoint__c;
                                ContentVersion structureFile = new ContentVersion();
                                System.debug('--- Processing Structure File for '+docTitle);
                                System.debug('--- Checking Visual Structure Number: '+conProd.Visual_Structure_Number__c);
                                System.debug('--- Checking RVN Number:'+conProd.RVN__c);
                                // Replaced RVN number with RVN in if condition as part of LUM-2016
                                if (conProd.RVN__c != null // Configuration Product must have RVN
                                    && versionData.contains('<RAKENNENUMERO>') // Document is VT3
                                    && docTitle == conProd.Visual_Structure_Number__c) { //FileName match to Visual Structure Number
                                    currentRVN = versionData.substringBetween('<RAKENNENUMERO>', '</RAKENNENUMERO>');
                                    System.debug('--- Checking Structure Number: '+currentRVN);
                                    versionData = versionData.replace(currentRVN, conProd.RVN__c); // Replaced RVN number with RVN as part of LUM-2016
                                    System.debug('--- Update Structure Number from '+currentRVN+ ' to RVN: '+conProd.RVN__c);
                                    updatedRVN = versionData.substringBetween('<RAKENNENUMERO>', '</RAKENNENUMERO>');

                                    specialOrder = versionData.substringBetween('<ERIKOISTILAUS>', '</ERIKOISTILAUS>');
                                    System.debug('--- Special Order Flag '+specialOrder);
                                    // Modified by Vishal on 20-10 for the story LUM-1804
                                    if(configurationItemsMap.keyset().contains(conProd.Id)){
                                        versionData = versionData.replace(specialOrder, '1');
                                        System.debug('--- Update Special Order Flag from '+specialOrder+ ' to 1');
                                    }

                                    updatedSalesCode = conProd.Sales_Code__c;
                                    System.debug('--- Product Sales Code '+updatedSalesCode);   
                                    endpoint += '?fileName=product=' + updatedSalesCode + '&name=' + updatedSalesCode +'_' + updatedRVN + '.xml';
                                        
                                    System.debug('--- Frends Endpoint '+endpoint);    
                                    sendFilesToFrends(versionData, endpoint, credentialsFiles.API_Key__c, orderRecord.Id, 'structure');
									System.debug('--- Generate Updated VT Structure File');    
                                    structureFile.VersionData = Blob.valueOf(versionData);
                                    structureFile.Title = 'StructureMessage-' +  conProd.RVN__c +'.xml'; // Replaced RVN number with RVN as part of LUM-2016
                                    System.debug('--- Set Updated File Name: '+structureFile.Title);   
                                    structureFile.ContentLocation= 's';
                                    if (orderIdToStructureDocumentId.get(orderRecord.Id) != null) {
                                        contVerFile.ContentDocumentId = orderIdToStructureDocumentId.get(orderRecord.Id);
                                    }

                                }
                                // Replaced RVN number with RVN as part of LUM-2016
                                else if(conProd.RVN__c != null && versionData.contains('<BOMNUMBER>') && docTitle == conProd.Visual_Structure_Number__c) {
                                    currentRVN = versionData.substringBetween('<BOMNUMBER>', '</BOMNUMBER>');
                                    versionData = versionData.replace(currentRVN, conProd.RVN__c); // Replaced RVN number with RVN as part of LUM-2016
                                    updatedRVN = versionData.substringBetween('<BOMNUMBER>', '</BOMNUMBER>');

                                    specialOrder = versionData.substringBetween('<SPECIALORDER>', '</SPECIALORDER>');
                                    // Modified by Vishal on 20-10 for the story LUM-1804
                                    if(configurationItemsMap.keyset().contains(conProd.Id)){
                                        versionData = versionData.replace(specialOrder, '1');
                                    }
                                    updatedSalesCode = conProd.Sales_Code__c;
                                    endpoint += '?fileName=product=' + updatedSalesCode + '&name=' + updatedSalesCode +'_' + updatedRVN + '.xml';
                                    
                                    sendFilesToFrends(versionData, endpoint, credentialsFiles.API_Key__c, orderRecord.Id, 'structure');

                                    structureFile.VersionData = Blob.valueOf(versionData);
                                    structureFile.Title = 'StructureMessage-' +  conProd.RVN__c +'.xml'; // Replaced RVN number with RVN as part of LUM-2016
                                    structureFile.ContentLocation= 's';
                                    if (orderIdToStructureDocumentId.get(orderRecord.Id) != null) {
                                        contVerFile.ContentDocumentId = orderIdToStructureDocumentId.get(orderRecord.Id);
                                    }
                                }

                            } else {
                                
                                Map<String,Object> structureMap = (Map<String,Object>) JSON.deserializeUntyped(doc.VersionData.toString());
                                String docTitle = doc.Title.contains('Output') ? doc.Title.substringAfter('Output_') :  doc.Title.substringAfter('Structure_');
                                String updatedRVN = '';
                                String updatedSalesCode = '';
                                String endpoint = credentialsFiles.Endpoint__c;
							    if(docTitle == conProd.Visual_Structure_Number__c){

                                    structureMap.put('structure_number',conProd.RVN__c); // Replaced RVN number with RVN as part of LUM-2016
                                    structureMap.put('vendorid','LU');
                                    structureMap.put('deliverybatch',0);
                                    
                                    if(configurationItemsMap.keyset().contains(conProd.Id)){
                                        System.debug('--- Special Order available from configuration ---');
                                        structureMap.put('special_order',1);
                                    }else if(o.Reason_for_preliminary_contract__c != NULL && o.Reason_for_preliminary_contract__c == 'Special Order'){
                                        System.debug('--- Special Order available manually ---');
                                        structureMap.put('special_order',1);
                                    }
                                    updatedRVN = conProd.RVN__c; // Replaced RVN number with RVN as part of LUM-2016
                                    updatedSalesCode = conProd.Sales_Code__c;
                                    endpoint += '?fileName=product=' + updatedSalesCode + '&name=' + updatedSalesCode +'_' + updatedRVN + '.json';
                                    sendFilesToFrends(JSON.serialize(structureMap), endpoint, credentialsFiles.API_Key__c, orderRecord.Id, 'structure');


                                    ContentVersion structureFile = new ContentVersion();
                                    structureFile.VersionData = Blob.valueOf(JSON.serialize(structureMap));
                                    structureFile.Title = 'StructureMessage-' +  conProd.RVN__c +'.json'; // Replaced RVN number with RVN as part of LUM-2016
                                    structureFile.ContentLocation= 's';
                                    if (orderIdToStructureDocumentId.get(orderRecord.Id) != null) {
                                        contVerFile.ContentDocumentId = orderIdToStructureDocumentId.get(orderRecord.Id);
                                    }
                                    structureFile.PathOnClient='StructureMessage-' + orderRecord.Id +'.json';
                                    fileNames.add('StructureMessage-' + orderRecord.Id +'.json');
                                    //structureFile.FirstPublishLocationId = orderRecord.Id;
                                    system.debug('structureFile--'+structureFile);
                                    documentsToInsert.add(structureFile);
                                }
                            }
                        }
                    }

                    // Blinds related messages are handled here
                    if(configBlindsFileMap != null && configBlindsFileMap.isEmpty() == FALSE){
                        System.debug('--- configBlindsFileMap ---'+configBlindsFileMap);
                        System.debug('--- conProd.Configuration__c ---'+conProd.Configuration__c);
                        List<ContentVersion> docBlList = configBlindsFileMap.get(conProd.Configuration__c);
                        if(docBlList != null && docBlList.size() > 0){
                            System.debug('--- docBlList not empty ---');
                            for(ContentVersion docBl : docBlList){
                                if (docBl != null && docBl.FileExtension == 'xml') {
                                    String versionData = docBl.VersionData.toString();
                                    String currentBOM = versionData.substringBetween('<BOMNUMBER>', '</BOMNUMBER>');
                                    String structureVal = currentBOM.substringAfter('#ORDER_NO#');
                                    String endpoint = credentialsFiles.Endpoint__c;
                                    if(structureVal == conProd.Visual_Structure_Number__c){
                                        versionData = versionData.replace(currentBOM, conProd.RVN__c); // Replaced RVN number with RVN as part of LUM-2016
                                        String currentRecl = versionData.substringBetween('<reclamation>', '</reclamation>');
                                        versionData = versionData.replace(currentRecl, '0');
                                        endpoint += '?fileName=' + conProd.RVN__c + '_BlindsD365.xml'; // Replaced RVN number with RVN as part of LUM-2016
                                        System.debug('--- versionData ---'+versionData);
                                        System.debug('--- blinds file to Frends new endpoint ---'+endpoint);
                                        sendFilesToFrends(versionData, endpoint, credentialsFiles.API_Key__c, orderRecord.Id, 'blinds');

                                        ContentVersion blindsFile = new ContentVersion();
                                        blindsFile.VersionData = docBl.VersionData;
                                        blindsFile.Title = 'BlindsMessage-' +  conProd.RVN__c +'.xml'; // Replaced RVN number with RVN as part of LUM-2016
                                        blindsFile.ContentLocation= 's';
                                        if (orderIdToBlindsDocumentId.get(orderRecord.Id) != null) {
                                            blindsFile.ContentDocumentId = orderIdToBlindsDocumentId.get(orderRecord.Id);
                                        }
                                        blindsFile.PathOnClient='BlindsMessage-' + orderRecord.Id +'.xml';
                                        fileNames.add('BlindsMessage-' + orderRecord.Id +'.xml');
                                        //blindsFile.FirstPublishLocationId = orderRecord.Id;
                                        documentsToInsert.add(blindsFile);
                                    }
                                }else{
                                    String jsonData = '{"configurator":"SC","product_type":"'+conProd.Sales_Code__c +'","structure_number":"'+conProd.RVN__c +'","original_sn":"","special_order": 0}';
                                    System.debug('--- jsonData ---'+jsonData);
                                    String endpoint = credentialsFiles.Endpoint__c;
                                    endpoint += '?fileName=product=' + conProd.Sales_Code__c + '&name=' + conProd.Sales_Code__c +'_' + conProd.RVN__c + '_BlindsD365.json';
                                    sendFilesToFrends(jsonData, endpoint, credentialsFiles.API_Key__c, orderRecord.Id, 'blinds');
                                    ContentVersion blindsFile = new ContentVersion();
                                    blindsFile.VersionData = docBl.VersionData;
                                    blindsFile.Title = 'BlindsMessage-' +  conProd.RVN__c +'.json';
                                    blindsFile.ContentLocation= 's';
                                    if (orderIdToBlindsDocumentId.get(orderRecord.Id) != null) {
                                        blindsFile.ContentDocumentId = orderIdToBlindsDocumentId.get(orderRecord.Id);
                                    }
                                    blindsFile.PathOnClient='BlindsMessage-' + orderRecord.Id +'.json';
                                    fileNames.add('BlindsMessage-' + orderRecord.Id +'.json');
                                    //blindsFile.FirstPublishLocationId = orderRecord.Id;
                                    documentsToInsert.add(blindsFile);
                                }
                            }
                        }
                    }
                    
                    
                }

                System.debug('--- order file to Frends old and new endpoint ---');
                notifyFrends(JSON.serialize(jsonContent), credentials.Endpoint__c, credentials.API_Key__c, orderRecord.Id); 
            }
        }

        try {
            insert documentsToInsert;
            List<ContentVersion> docs = [SELECT ContentDocumentId, Title, PathOnClient FROM ContentVersion WHERE PathOnClient IN: fileNames];
            
            List<ContentDocumentLink> contDocLinks = new List<ContentDocumentLink>();
            Set<Id> conDocIds = new Set<Id>();
            for(ContentVersion cv1 : docs){
                conDocIds.add(cv1.ContentDocumentId);
            }
            if (conDocIds.size() > 0) {
                List<ContentDocumentLink> documentLinks = [SELECT ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE ContentDocumentId IN:conDocIds];
                Set<String> docIdOrderIdPairs = new Set<String>();
                for (ContentDocumentLink cdl : documentLinks) {
                    docIdOrderIdPairs.add(cdl.ContentDocumentId + ':' + cdl.LinkedEntityId);
                }

                for (ContentVersion statsFile : docs) {
                    system.debug('statsFile.PathOnClient--'+statsFile.PathOnClient);
                    String orderId = statsFile.PathOnClient.substringBetween('OrderJSON-', '.json');
                    //String structureId = statsFile.PathOnClient.substringBetween('StructureMessage-', '.xml');
                    system.debug('orderId--'+orderId);
                    String orderPairToCheck = statsFile.ContentDocumentId + ':' + orderId;
                    //String structurePairToCheck = statsFile.ContentDocumentId + ':' + structureId;
                    system.debug('docIdOrderIdPairs---'+docIdOrderIdPairs);
                    if (!docIdOrderIdPairs.contains(orderPairToCheck)) {
                        if(orderId != null){
                        	contDocLinks.add(new ContentDocumentLink(ContentDocumentId = statsFile.ContentDocumentId, ShareType = 'V', LinkedEntityId = orderId));
                    	}
                    }
                    system.debug('contDocLinks---'+contDocLinks);
                    /*if(!docIdOrderIdPairs.contains(structurePairToCheck)) {
                        contDocLinks.add(new ContentDocumentLink(ContentDocumentId = statsFile.ContentDocumentId, ShareType = 'V', LinkedEntityId = orderId));
                    }*/
                }
            }

            if (!contDocLinks.isEmpty()) {
                upsert contDocLinks;
            }

            return 'success';
        } catch (Exception e) {
            System.debug('??? ex: ' + e.getMessage());
//          throw new Exception(e.getMessage());
            return 'fail: ' + e.getMessage();
        }
    }
    @future (callout=true)
    public static void notifyFrends (String jsonBody, String endpoint, String apiKey, String recordId) {
        Order orderRecord = [SELECT Error_Message__c, Is_Blinds_Processed__c, Is_Structure_JSON_Processed__c, Is_Frends_JSON_Processed__c FROM Order WHERE Id =: recordId];
        String currentError = orderRecord.Error_Message__c;
        if (currentError == 'null' || currentError == null) {
            currentError = '';
        }

        try {
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(endpoint);
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json;charset=UTF-8');
            request.setHeader('Authorization', apiKey);
            request.setBody(jsonBody);
            request.setTimeout(120000);
            HttpResponse response = http.send(request);

            System.debug('STATUS: ' + response.getStatus());
            if (response.getStatusCode() != 200) {
                System.debug('ERROR: ' + response.getBody());
                orderRecord.Is_Frends_JSON_Processed__c = false;
                currentError += 'Order Message: ' + response.getBody();
                currentError += '\n\n';
                orderRecord.Error_Message__c = currentError;
                //ErrorLog.logError('OrderGenerator', 'notifyFrends', response.getBody(), 'Error making api request', 1294, orderRecord.Id);
				
            } else {
                System.debug('SUCCESS: ' + response.getBody());
                orderRecord.Is_Frends_JSON_Processed__c = true;
            }
            update orderRecord;
        } catch(System.Exception e) {
            orderRecord.Is_Frends_JSON_Processed__c = false;
            update orderRecord;
            //ErrorLog.LogException(e,orderRecord.Id);
        }
    }
    @future (callout=true)
    public static void sendFilesToFrends (String jsonBody, String endpoint, String apiKey, String recordId, String processedFile) {
        Order orderRecord = [SELECT Error_Message__c, Is_Blinds_Processed__c, Is_Structure_JSON_Processed__c, Is_Frends_JSON_Processed__c FROM Order WHERE Id =: recordId];
        String currentError = orderRecord.Error_Message__c;
        if (currentError == 'null' || currentError == null) {
            currentError = '';
        }

        try {
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(endpoint); //TODO Temporary hardcoded
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json;charset=UTF-8');
            request.setHeader('Authorization', apiKey);
            request.setBody(jsonBody);
            request.setTimeout(120000);
            HttpResponse response = http.send(request);

            System.debug('STATUS: ' + response.getStatus());
            if (response.getStatusCode() != 200) {
                System.debug('ERROR: ' + response.getBody());
                if (processedFile == 'blinds') {
                    orderRecord.Is_Blinds_Processed__c = false;
                    currentError += 'Blinds Message: ' + response.getBody();
                    //ErrorLog.logError('OrderGenerator', 'sendFilesToFrends', currentError, 'Error making api request', 1333, orderRecord.Id);
				
                } else if (processedFile == 'structure') {
                    orderRecord.Is_Structure_JSON_Processed__c = false;
                    currentError += 'Structure Message: ' + response.getBody();
                    //ErrorLog.logError('OrderGenerator', 'sendFilesToFrends', currentError, 'Error making api request', 1338, orderRecord.Id);
                } else {
                    orderRecord.Is_Frends_JSON_Processed__c = false;
                    currentError += 'Order Message: ' + response.getBody();
                    //ErrorLog.logError('OrderGenerator', 'sendFilesToFrends', currentError, 'Error making api request', 1342, orderRecord.Id);
                }

                currentError += '\n\n';
                orderRecord.Error_Message__c = currentError;
            } else {
                System.debug('SUCCESS: ' + response.getBody());
                System.debug('processedFile: ' +processedFile);
                if (processedFile == 'blinds') {
                    orderRecord.Is_Blinds_Processed__c = true;
                } else if (processedFile == 'structure') {
                    orderRecord.Is_Structure_JSON_Processed__c = true;
                } else {
                    orderRecord.Is_Frends_JSON_Processed__c = true;
                }
            }
            update orderRecord;
        } catch(System.Exception e) {
            if (processedFile == 'blinds') {
                orderRecord.Is_Blinds_Processed__c = false;
                currentError += 'Blinds Mesage: ' + e.getMessage();
            } else if (processedFile == 'structure') {
                orderRecord.Is_Structure_JSON_Processed__c = false;
                currentError += 'Structure Message: ' + e.getMessage();
            } else {
                orderRecord.Is_Frends_JSON_Processed__c = false;
                currentError += 'Order Message: ' + e.getMessage();
            }
            currentError += '\n\n';
            orderRecord.Error_Message__c = currentError;
            update orderRecord;
            //ErrorLog.LogException(e,orderRecord.Id);
        }
    }
    public class OrderJSON {
        public OrderWrapper order {public get; public set;}
    }
    public class OrderWrapper {
        public OrderInfo order_info {public get; public set;}
        public GroupsWrapper groups {public get; public set;}
    }
    public class OrderInfo {
        public String axcompanyId {public get; public set;}
        public String currency1 {public get; public set;}
        public String customer_reference {public get; public set;}
        public String order_type {public get; public set;}
        public String order_number {public get; public set;}
        public String vendorid {public get; public set;}
        public String project_number {public get; public set;}
        public String parent_project {public get; public set;}
        public String project_group {public get; public set;}
        public String customer_segmentid {public get; public set;}
        public String customer_segmentname {public get; public set;}
        public String promised_deliveryweek {public get; public set;}
        public String promised_date {public get; public set;}
        public String main_contractor {public get; public set;}
        public String business_unit {public get; public set;}
        public String order_attachment {public get; public set;}
        public SubprojectInfo subproject_info {public get; public set;}
        public Budget budget {public get; public set;}
        public String domestic_help {public get; public set;}
        public String domestic_text {public get; public set;}
        public String chargeable {public get; public set;}
        public String worknumbername {public get; public set;}
        public PriceList pricelist {public get; public set;}
        public CustomerAddress customer_address {public get; public set;}
        public InvoiceAddress invoice_address {public get; public set;}
        public InstallAddress install_address {public get; public set;}
        public DeliveryAddress delivery_address {public get; public set;}
        public SalesPerson sales_person {public get; public set;}
    }
    public class SubprojectInfo {
        public String subproject_number {public get; public set;}
        public String subproject_group {public get; public set;}
        public String subproject_category {public get; public set;}
        public Double subproject_cost {public get; public set;}
        public String subproject_ordertype {public get; public set;}
        public String subproject_parentproject {public get; public set;}
        public String subproject_chargeable {public get; public set;}
    }
    public class Budget {
        public List<ProjectCategory> project_category {public get; public set;}
    }

    public class ProjectCategory {
        public String category;
        public Decimal cost;
        public ProjectCategory(String category, Decimal cost) {
            this.category = category;
            this.cost = cost;
        }
    }
    public class PriceList {
        public String pricelist_name {public get; public set;}
    }
    public class CustomerAddress {
        public String address_description {public get; public set;}
        public String firstname {public get; public set;}
        public String lastname {public get; public set;}
        public String contact_person {public get; public set;}
        public String street_address {public get; public set;}
        public String city {public get; public set;}
        public String postal_code {public get; public set;}
        public String fax {public get; public set;}
        public String country {public get; public set;}
        public String province {public get; public set;}
        public String county {public get; public set;}
        public String phone_number {public get; public set;}
        public String email {public get; public set;}
        public String note {public get; public set;}
        public String number1 {public get; public set;}
        public String customer_id {public get; public set;}
    }
    public class InvoiceAddress {
        public String address_description {public get; public set;}
        public String firstname {public get; public set;}
        public String lastname {public get; public set;}
        public String contact_person {public get; public set;}
        public String street_address {public get; public set;}
        public String city {public get; public set;}
        public String postal_code {public get; public set;}
        public String fax {public get; public set;}
        public String country {public get; public set;}
        public String province {public get; public set;}
        public String county {public get; public set;}
        public String phone_number {public get; public set;}
        public String email {public get; public set;}
        public String note {public get; public set;}
        public String payment_terms {public get; public set;}
        public String invoice_type {public get; public set;}
        public String number1 {public get; public set;}
        public String payment {public get; public set;}
        public String paytrail_reference_id {public get; public set;}
    }
    public class InstallAddress {
        public String address_description {public get; public set;}
        public String firstname {public get; public set;}
        public String lastname {public get; public set;}
        public String contact_person {public get; public set;}
        public String street_address {public get; public set;}
        public String city {public get; public set;}
        public String postal_code {public get; public set;}
        public String fax {public get; public set;}
        public String country {public get; public set;}
        public String province {public get; public set;}
        public String county {public get; public set;}
        public String phone_number {public get; public set;}
        public String email {public get; public set;}
        public String note {public get; public set;}
        public String number1 {public get; public set;}
    }
    public class DeliveryAddress {
        public String address_description {public get; public set;}
        public String firstname {public get; public set;}
        public String lastname {public get; public set;}
        public String contact_person {public get; public set;}
        public String street_address {public get; public set;}
        public String city {public get; public set;}
        public String postal_code {public get; public set;}
        public String fax {public get; public set;}
        public String country {public get; public set;}
        public String province {public get; public set;}
        public String county {public get; public set;}
        public String phone_number {public get; public set;}
        public String email {public get; public set;}
        public String note {public get; public set;}
        public String number1 {public get; public set;}
        public String delivery_terms {public get; public set;}
        public String delivery_type {public get; public set;}
    }

    public class SalesPerson {
        public String username {public get; public set;}
        public String supervisor {public get; public set;}
        public String firstname {public get; public set;}
        public String lastname {public get; public set;}
    }
    public class GroupsWrapper {
        //public Group1 group1 {public get; public set;}
        public List<BaseGroup> group1 {public get; public set;}
    }
    public virtual class BaseGroup {
        public Integer delivery_batch {public get; public set;}
        public String delivery_batch_status {public get; public set;}
        public String delivery_batch_receive_date {public get; public set;}
        public String delivery_batch_delivery_date {public get; public set;}
        public String group_attachment {public get; public set;}
        public String AXconfiguration {public get; public set;}
        public String group_name {public get; public set;}
        public Integer pcs {public get; public set;}
        public String structurenumber {public get; public set;}
        public String originalstructurenumber {public get; public set;}
        public String install_start_date {public get; public set;}
        public String install_end_date {public get; public set;}
        public Integer additional_deliverytime {public get; public set;}
        public String process {public get; public set;}
        public String product_code {public get; public set;}
        public String storageid {public get; public set;}
        public Integer packing_order {public get; public set;}
        public String unit {public get; public set;}
        public String line {public get; public set;}
        public String floor {public get; public set;}
        public String chargeable {public get; public set;}
        public Double sales_price {public get; public set;}
        public Double sproduct {public get; public set;}
        public Double sfreight {public get; public set;}
        public Double sinstall {public get; public set;}
        public Double sother {public get; public set;}
        public Double purchase_price {public get; public set;}
        public Double pproduct {public get; public set;}
        public Double pfreight {public get; public set;}
        public Double pinstall {public get; public set;}
        public Double pother {public get; public set;}
        public Double calculated_salesprice {public get; public set;}
        public Double factory_price {public get; public set;}
        public Double fproduct {public get; public set;}
        public Double ffreight {public get; public set;}
        public Double finstall {public get; public set;}
        public Double fother {public get; public set;}
        public Double contract_price {public get; public set;}
        public String salestori_plan_name {public get; public set;}
        public Double glass_m2 {public get; public set;}
        public Double blinds_m2 {public get; public set;}
        public Integer glass_pcs {public get; public set;}
        public Integer product_length {public get; public set;}
        public Double group_weight {public get; public set;}
        public ProductAttributes product_attributes {public get; public set;}
        public Sides sides {public get; public set;}
        public Boolean installed {public get; public set;}
    }    
    public class Group1 extends BaseGroup {
        public Reclamation reclamation {public get; public set;}
    }
    public class ProductAttributes {
        public String attributeid {public get; public set;}
    }
    public class Sides {
        public List<Side> side {public get; public set;}
    }
    public class Side {
        public Integer side_number {public get; public set;}
        public String upper_profilecolour {public get; public set;}
        public String lower_profilecolour {public get; public set;}
        public Integer glass_thickness {public get; public set;}
        public String glass_type {public get; public set;}
        public String plastic_colour {public get; public set;}
        public Integer upper_profile {public get; public set;}
        public Integer lower_profile {public get; public set;}
        public Integer telescopic_profile {public get; public set;}
        public Integer profile_length {public get; public set;}
        public Integer glazing_length {public get; public set;}
        public String StructureNumber {public get; public set;}
        public Integer glazing_height {public get; public set;}
        public Integer glass_left_pcs {public get; public set;}
        public Integer glass_right_pcs {public get; public set;}
        public Integer corner_bypass {public get; public set;}
        public Double side_weight {public get; public set;}
        public Integer start_angle {public get; public set;}
        public Integer end_angle {public get; public set;}
        public Integer system_angle {public get; public set;}
    }
    public class Reclamation{
        public String class1 {public get; public set;}
        public String class2 {public get; public set;}
        public String class3 {public get; public set;}
        public String description {public get; public set;}
        public String parts {public get; public set;}
        public String reclamation_order {public get; public set;}
        public Date caselog {public get; public set;}
    }
}