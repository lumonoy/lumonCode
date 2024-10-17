/**
 * @description       : NOT IN USE
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 10-08-2024
 * @last modified by  : Henk Reynders
**/
 public without sharing class ContractTriggerHandler {
    /*public static Boolean isSandbox = [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
	@AuraEnabled
	public static void submitContract(String recordId) {
		Contract c = [SELECT Status, AccountId, Chargeable__c,ContractNumber, Customer_Segment__c,Customer_segment_name__c,
					  Organization__c,CurrencyIsoCode, Customer_reference__c,Order_type__c, Opportunity_Number__c,
					  Opportunity__r.Project_Number__c,Project_Number__c,
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
					  Opportunity__r.Invoicing_Address__Street__s,
                      Opportunity__r.Delivery_Date__c, Opportunity__r.Delivery_week__c,
					  Parent_Project__c ,PriceBook_Name__c,Factory__c, Project_Group__c, Delivery_week__c, Delivery_Date__c, 
					  Main_Contractor__c,Business_Unit__c,Opportunity__c,Payment_Term__c,Method_of_Payment__c,Opportunity__r.Invoice_type__c,
					  Opportunity__r.Preliminary_installation_time__c,Opportunity__r.Phone__c,Opportunity__r.Contact_Email__c
                      
					FROM Contract WHERE Id =: recordId];
		populateJSON(new List<Contract>{c}, null, false);
	}

	public static void populateJSON(List<Contract> newContracts, Map<Id, Contract> oldContractsMap, Boolean fromTrigger){
        List<Contract> signedContracts = new List<Contract>();
        Set<String> contractToProjIds = new Set<String>();
        Set<Id> contractToOpportunityIds = new Set<Id>();
		Set<Id> signedContractIds = new Set<Id>();
        System.debug('--- oldContractsMap ---'+oldContractsMap);
        for(Contract c : newContracts){
			if (oldContractsMap != null) {
				Contract oldContract = oldContractsMap.get(c.Id);
				if(oldContract.Status != 'Signed' && c.Status == 'Signed'){ // AP : SAI Need to check how the process works
					signedContracts.add(c);
					signedContractIds.add(c.Id);
				}
			} else {
                System.debug('--- c.Status 2 ---'+c.Status);
				if(c.Status == 'Activated' || c.Status == 'Signed'){ // AP : SAI Need to check how the process works
					signedContracts.add(c);
					signedContractIds.add(c.Id);
				}
			}
        }
        System.debug('--- signedContracts ---'+signedContracts);
		
        System.debug('--- isSandbox ---'+isSandbox);
		String envName = 'production';
		if ([SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox) {
			envName = String.valueOf(URL.getOrgDomainUrl()).substringBetween('--', '.sandbox');
			envName = envName.remove('--c');
			if (envName != 'lumonTest' && envName != 'develop1' ) {
				envName = 'sandbox';
			}
		}
		Integration_Credentials__mdt credentials;
        Integration_Credentials__mdt credentialsFiles;
		credentials = [SELECT API_Key__c, Endpoint__c FROM Integration_Credentials__mdt WHERE Integration_Name__c = 'Frends' AND Environment_Name__c =: envName];
		credentialsFiles = [SELECT API_Key__c, Endpoint__c FROM Integration_Credentials__mdt WHERE Integration_Name__c = 'FrendsFiles' AND Environment_Name__c =: envName];
		List<ContentVersion> documentsToInsert = new List<ContentVersion>();
		Set<String> fileNames = new Set<String>();
		Set<String> contractNumbers = new Set<String>();
		Set<Id> accountIds = new Set<Id>();
        String custSegId = '';
		String custSegName = '';
		for (Contract contractRecord : signedContracts) {
            	System.debug('--- contractRecord ---'+contractRecord.Opportunity__c);
            	System.debug('--- contractRecord proj ---'+contractRecord.Project_Number__c);
				accountIds.add(contractRecord.AccountId);
            	contractToProjIds.add(contractRecord.Project_Number__c);
            	contractToOpportunityIds.add(contractRecord.Opportunity__c);
		}
        System.debug('--- contractToProjIds ---'+contractToProjIds);
        System.debug('--- contractToOpportunityIds ---'+contractToOpportunityIds);
        System.debug('--- accountIds ---'+accountIds);
		// Account map data
		Map<Id, Account> accountIdToAccount = new Map<Id, Account>(
			[SELECT FirstName, LastName, Phone, PersonMailingStreet,PersonMailingCountryCode, PersonMailingCity, PersonMailingPostalCode,
				PersonMailingCountry, Financing_Customer_Number__c ,PersonMailingState, Fax, PersonEmail, AccountNumber,Account.BillingStreet, Account.BillingPostalCode, 
				Account.BillingState, Account.BillingCountryCode, Account.BillingCity
			FROM Account WHERE Id IN: accountIds]
		);
		
		//Opp owner data
        Map<Id,Opportunity> opportunityOwnerMap = new Map<Id,Opportunity>([	SELECT Id,Owner.Name,Owner.username,Phone__c,Contact_Email__c,
                                                                          	Owner.Alias,Owner.AD_Short_Username__c,Owner.Supervisor__c,Owner.FirstName,Owner.LastName,
                                                                           	Customer_Address__Street__s,Customer_Address__City__s,Customer_Address__PostalCode__s,
                                                                            Customer_Address__StateCode__s,Invoicing_Address__Street__s,Invoicing_Address__City__s,
                                                                            Invoicing_Address__PostalCode__s,Invoicing_Address__StateCode__s,Invoice_type__c,
                                                                            Installation_Address__Street__s,Installation_Address__City__s,Installation_Address__PostalCode__s,
                                                                            Installation_Address__StateCode__s,Delivery_Address__Street__s,Delivery_Address__City__s,
                                                                            Delivery_Address__PostalCode__s,Delivery_Address__StateCode__s,Preliminary_installation_time__c,
                                                                           	Delivery_Date__c, Delivery_week__c
                                                                           	from Opportunity where ID IN:contractToOpportunityIds]);
        System.debug('--- opportunityOwnerMap ---'+opportunityOwnerMap);
        
        //Opp Team Data to map the Installation Manager/Supervisor (LUM-979)
        Map<Id,OpportunityTeamMember> opportunityTeamMemberMap = new Map<Id,OpportunityTeamMember>();
        List<OpportunityTeamMember> opportunityTeamMemberList = new List<OpportunityTeamMember>([SELECT Id,OpportunityId,UserId, User.Alias,User.AD_Short_Username__c from OpportunityTeamMember where OpportunityId IN:contractToOpportunityIds]);
        if(opportunityTeamMemberList.size() > 0){
            OpportunityTeamMember oppTeamMember = [SELECT Id,OpportunityId,UserId, User.Alias,User.AD_Short_Username__c from OpportunityTeamMember where OpportunityId IN:contractToOpportunityIds limit 1];
                for(OpportunityTeamMember otm : opportunityTeamMemberList){
                if(!opportunityTeamMemberMap.containsKey(otm.OpportunityId)){
                    opportunityTeamMemberMap.put(otm.OpportunityId,otm);
                }
            } 
        }
		//Subproject Data
		System.debug('--- Parent_Project__r.Project_Number__c ---'+contractToProjIds);
        Map<String,Project__c> subProjToMain = new Map<String,Project__c>();
        List<Project__c> subProjList = new List<Project__c>();
        subProjList = [SELECT Parent_Project__c,Project_Number__c,Proj_Number__c,Project_Value__c,Project_Group__c,Project_Category__c,Parent_Project__r.Project_Number__c,Chargeable__c 
             			FROM Project__c where Parent_Project__r.Project_Number__c IN:contractToProjIds];
        if(!subProjList.isEmpty()){
            for(Project__c sub : subProjList){
                subProjToMain.put(sub.Parent_Project__r.Project_Number__c,sub);
            }
        }
        System.debug('--- subProjToMain ---'+subProjToMain);

		// Get QuotelineItem Map for different cost types and categories

		Map<Id,List<AggregateResult>> costAggregateMap = new Map<Id,List<AggregateResult>>();
		List<AggregateResult> agrList = new List<AggregateResult>();
		Id oppId;
		Decimal FactoryPrice = 0.00;
		Decimal installationSupply = 0.00;
        Decimal freightCost = 0.00;
        Decimal installationCost = 0.00;
		Decimal quaranteeCost = 0.00;
        Decimal additionalProductCost = 0.00;
        Decimal rentedMachineryCost = 0.00;
        Decimal permitCost = 0.00;
        Decimal externalServiceCost = 0.00;
        Decimal serviceCost = 0.00;
        Decimal travelCost = 0.00;
        
		List<AggregateResult> costAggregateList = [SELECT Quote.OpportunityId,SUM(fxFactory__c) factory,
                                                   SUM(fxCost__c) productcost,SUM(TotalPrice) salesprice,
                                                   Product2.Cost_Category__c,Product2.Cost_Type__c 
                                                   from QuoteLineItem 
                                                   where Quote.OpportunityId IN :contractToOpportunityIds 
                                                   group by Product2.Cost_Category__c,Product2.Cost_Type__c,Quote.OpportunityId];
		for(AggregateResult agr : costAggregateList){
            oppId = (Id) agr.get('OpportunityId');
            agrList.add(agr);
			costAggregateMap.put(oppId,agrList);
            System.debug('--- costAggregateMap ---'+costAggregateMap);
		}

		


		List<ContentDocumentLink> existingDocs = new List<ContentDocumentLink>();
		if (signedContractIds.size() > 0) {
			existingDocs = [SELECT LinkedEntityId, ContentDocumentId, ContentDocument.Title FROM ContentDocumentLink WHERE LinkedEntityId IN :signedContractIds];
			System.debug('!! existingDocs: ' + existingDocs);
		}
		Map<Id,Id> contractIdToDocumentId = new Map<Id, Id>();
		for (ContentDocumentLink cdl : existingDocs) {
			System.debug('!! cdl.ContentDocument.Title : ' + cdl.ContentDocument.Title);
			if (cdl.ContentDocument.Title.contains('Contract JSON')) {
				contractIdToDocumentId.put(cdl.LinkedEntityId, cdl.ContentDocumentId);
			}
		}
		System.debug('!!! map contractIdToDocumentId: ' + contractIdToDocumentId);
        try{
            for (Contract contractRecord : signedContracts) {
				System.debug('--- opval contractRecord.Opportunity__c ---'+contractRecord.Opportunity__c);
                for(Id opval : costAggregateMap.keyset()){
                    if(opval == contractRecord.Opportunity__c){
                        System.debug('costAggregateMap.get(opval)'+costAggregateMap.get(opval));
                        List<AggregateResult> relatedAgr = costAggregateMap.get(opval);
                        
                        for(AggregateResult result : relatedAgr){
                            System.debug('--- result ---'+result.get('Cost_Category__c'));
                            if(result.get('Cost_Category__c') == 'FactoryPurchase'){
                                FactoryPrice = FactoryPrice + (Decimal) result.get('factory');
                            }else if(result.get('Cost_Category__c') == 'InstallSupplies'){
                                installationSupply = installationSupply + (Decimal) result.get('productcost');
                            }else if(result.get('Cost_Category__c') == 'SalesFreight'){
                                freightCost = freightCost + (Decimal) result.get('productcost');
                            }else if(result.get('Cost_Category__c') == 'Wages'){
                                installationCost = installationCost + (Decimal) result.get('productcost');
                            }else if(result.get('Cost_Category__c') == 'CostReserv'){
                                quaranteeCost = quaranteeCost + (Decimal) result.get('productcost');
                            }else if(result.get('Cost_Category__c') == 'AdditionalSales'){
                                additionalProductCost = additionalProductCost + (Decimal) result.get('productcost');
                            }else if(result.get('Cost_Category__c') == 'RentedMachinery'){
                                rentedMachineryCost = rentedMachineryCost + (Decimal) result.get('productcost');
                            }else if(result.get('Cost_Category__c') == 'BuildingPermits'){
                                permitCost = permitCost + (Decimal) result.get('productcost');
                            }else if(result.get('Cost_Category__c') == 'ExternalService'){
                                externalServiceCost = externalServiceCost + (Decimal) result.get('productcost');
                            }else if(result.get('Cost_Category__c') == 'SalesService'){
                                serviceCost = serviceCost + (Decimal) result.get('productcost');
                            }else if(result.get('Cost_Category__c') == 'TravelExpenses'){
                                travelCost = travelCost + (Decimal) result.get('productcost');
                            }
                        }
                        
                    }
                }
                ContractJSON jsonContent = new ContractJSON();
                fileNames.add('Contract JSON ' + contractRecord.ContractNumber);
                contractNumbers.add(contractRecord.ContractNumber);
                OrderInfo ordInfo = new OrderInfo();
				Opportunity o = opportunityOwnerMap.get(contractRecord.Opportunity__c);
                ordInfo.axcompanyId = contractRecord.Organization__c; // Field that Specifies the Organization in which this contract is made
                ordInfo.currency1 = contractRecord.CurrencyIsoCode; // Standard currency field populated based on the user currency
                ordInfo.customer_reference = contractRecord.Customer_reference__c; // Customer reference to be included in invoice document by request of the customer
                ordInfo.order_type = contractRecord.Order_type__c; //Values can be either Normal or Reclamation
                ordInfo.order_number = contractRecord.Opportunity_Number__c ; //order number the customer gets as a reference 
                ordInfo.vendorid = contractRecord.Factory__c; //'LU'; 
                ordInfo.project_number = contractRecord.Project_Number__c;//'801062';//contractRecord.Project_Number__c;
                ordInfo.parent_project = contractRecord.Parent_Project__c;// ''
                ordInfo.project_group = contractRecord.Project_Group__c;
                ordInfo.customer_segmentid = contractRecord.Customer_Segment__c;//contractRecord.Customer_Segment__c;
                ordInfo.customer_segmentname = contractRecord.Customer_segment_name__c;//contractRecord.Customer_Segment__c;
                
				// 23.01.2024 Update to send 
				/* ordInfo.promised_deliveryweek = contractRecord.Delivery_week__c;
					if(o.Preliminary_installation_time__c != null){
					Datetime promisedDateTime = o.Preliminary_installation_time__c;
					System.debug('--- promisedDateTime ---'+promisedDateTime);
					Date promisedDate = Date.newInstance(promisedDateTime.year(), promisedDateTime.month(), promisedDateTime.day());
					ordInfo.promised_date = String.valueOf(promisedDate);
					System.debug('--- ordInfo.promised_date ---'+ordInfo.promised_date);
				}else{
					ordInfo.promised_date = '';
				}*/
				/*ordInfo.promised_deliveryweek = o.Delivery_week__c;//'2022/52';
                ordInfo.promised_date = String.valueOf(o.Delivery_Date__c); //Date.today();
                
                ordInfo.main_contractor = contractRecord.Main_Contractor__c;
                ordInfo.business_unit = contractRecord.Business_Unit__c;
                ordInfo.order_attachment = '\\\\\\\\frendsprod\\\\D365TEST\\\\SalesTori\\\\OUT\\\\attachments\\\\';

                SubprojectInfo subprojectInfo = new SubprojectInfo();
                //if(parentproject is empty then this is a new sales project)
                //In that case we need to add warranty project data
                //Get the child project related to the parent project
                System.debug('--- contractRecord.Project_Number__c ---'+contractRecord.Project_Number__c);
                Project__c subProj = subProjToMain.get(contractRecord.Project_Number__c);
                System.debug('--- subProj ---'+subProj);
                System.debug('--- contractRecord.Parent_Project__c ---'+contractRecord.Parent_Project__c);
                System.debug('--- contractRecord.Project_Number__c ---'+contractRecord.Project_Number__c);
                if(contractRecord.Parent_Project__c == NULL && contractRecord.Project_Number__c != NULL){
                    subprojectInfo.subproject_number = subProj.Project_Value__c;//subProj.Proj_Number__c;//'801062_01'contractRecord.Project_Number__c; //todo duplicated value
                    subprojectInfo.subproject_group = subProj.Project_Group__c;//'CONWar';//contractRecord.Project_Group__c;  //todo duplicated value
                    subprojectInfo.subproject_category = subProj.Project_Category__c;//'Warranty';//contractRecord.Project_Category__c;
                    subprojectInfo.subproject_cost = quaranteeCost != 0.00 ? quaranteeCost : 0.00; //todo missed field
                    subprojectInfo.subproject_ordertype = 'Reclamation';//contractRecord.Order_type__c; //todo duplicated value
                    subprojectInfo.subproject_parentproject = subProj.Parent_Project__r.Project_Number__c;//'801062';//contractRecord.Parent_Project__c;
                    subprojectInfo.subproject_chargeable = subProj.Chargeable__c ? 'chargeable' : 'non-chargeable';//subProj.Chargeable__c;//'non-chargeable';//String.valueOf(contractRecord.Chargeable__c);
                    ordInfo.subproject_info = subprojectInfo;
                }else{
                    ordInfo.subproject_info = subprojectInfo;
                }
			
			
                Budget budget = new Budget();
                List<ProjectCategory> categories = new List<ProjectCategory>();
                //todo - comes from the Quote
                //FactoryPurchase Sum of prices from cost types 'tuotekust.', 'tuotteet', 'verhot', 'tarvikealu', 'tarvikeast', 'tarvikekmp'
                //InstallSupplies Sum of prices from cost types 'as.tarvike'
                //ExternalService Sum of prices from cost types 'alihankint', 'ulk.as.pal'
                //RentedMachinery Sum of prices from cost types 'nostvuokra' + LISAHIN/ 'Nostok.*'
                //SalesFreight Sum of prices from cost types 'rahti','rahti1','rahti2','rahti3'
                //BuildingPermits Sum of prices from cost types 'lupahakem.'
                //Wages Sum of prices from cost types 'asennus','asennus1','asennus3' + LISAHIN/ 'asennus*'
                //TravelExpenses Sum of prices from cost types 'kulukorv.'
                //AdditionalSales Sum of prices from cost types LISAHIN/ 'Myynti*'
    
    
                //FactoryPurchase (Cost category)
                    //Cost Type				Cost Category
                    //tuotekust. 		- 	Additional Product Expenses (http://sales.lumon.fi/offer/offersummary.aspx?id=267354)
                    //tuotteet			-	Products (http://sales.lumon.fi/offer/offersummary.aspx?id=267354)
                    //verhot			-	Blinds (http://sales.lumon.fi/offer/offersummary.aspx?id=267632)
                    //tarvikealu		-	Accessories	(Aluminum Accessories) (http://sales.lumon.fi/offer/offersummary.aspx?id=266154)
                    //tarvikeast		-	Accessories (http://sales.lumon.fi/offer/offersummary.aspx?id=266154)
                    //tarvikekmp		-	Accessories (Accessories components) (http://sales.lumon.fi/offer/offersummary.aspx?id=266154)
    
                //InstallSupplies (cost category)
                    //Cost Type				
                    //as.tarvike		-	Installation supplies (http://sales.lumon.fi/offer/offersummary.aspx?id=266154)
                
                //ExternalService
                    //Cost Type				
                    //alihankint		-	SubContracting (Need to check with Lumon)
                    //ulk.as.pal		-	Third Party Installation (Need to check with Lumon)
                
                //RentedMachinery
                    //Cost Type				Cost Category
                    //nostvuokra		-	Need to check with Lumon (http://sales.lumon.fi/offer/offersummary.aspx?id=267632)
                    //LISAHIN/ 'Nostok.*-	Need to check with Lumon
                
                //SalesFreight
                    //Cost Type				Cost Category
                    //rahti				-	Freight
                    //rahti1			-	Freight
                    //rahti2			-	Freight
                    //rahti3			-	Freight
    
                //BuildingPermits
                    //Cost Type				Cost Category
                    //lupahakem			-	Permit applications(http://sales.lumon.fi/offer/offersummary.aspx?id=267116)
                
                //Wages
                    //Cost Type				Cost Category
                    //asennus			-	Installation
                    //asennus1			-	Installation
                    //asennus3			-	Installation
                    //LISAHIN/'asennus*'-
                    //asennus ca		- 	Installation
                    //asennus fi		-	Installation
                    //asennus es		-	Installation
                    //asennus se		-	Installation
    
                //TravelExpenses (Only for Lumon 5 products ??)
                    //Cost Type				
                    //kulukorv.			-	Expense reimbursement(http://sales.lumon.fi/offer/offersummary.aspx?id=258109)
    
                //AdditionalSales
                    //Cost Type				Cost Category
                    //LISAHIN/ 'Myynti*'- 
                    //myynti ca			-	Extra Sales (Extra Sales --> Myynti CA)
                    //myynti fi			-	Extra Sales (Extra Sales --> Myynti FI) (http://sales.lumon.fi/offer/offersummary.aspx?id=266881)
                    //myynti es			-	Extra Sales 
                    //myynti se			-	Extra Sales
			
                if(FactoryPrice != 0.00){
                    categories.add(new ProjectCategory('FactoryPurchase', FactoryPrice));
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
                System.debug('--- contractRecord.Chargeable__c ---'+contractRecord.Chargeable__c);
                ordInfo.domestic_help = ''; //todo missed field
                ordInfo.domestic_text = ''; //todo missed field
                ordInfo.chargeable = contractRecord.Chargeable__c; //'chargeable';//String.valueOf(contractRecord.Chargeable__c); //todo duplicated value
                ordInfo.worknumbername = ''; //todo missed field
        
                PriceList plist = new PriceList();
                plist.pricelist_name = contractRecord.PriceBook_Name__c;//'Basic price list 1.4.2022';
                ordInfo.pricelist = plist;


				CustomerAddress custAdd = new CustomerAddress();
                
                if (contractRecord.AccountId != null && accountIdToAccount.get(contractRecord.AccountId) != null) {
                    Account acc = accountIdToAccount.get(contractRecord.AccountId);
                    
                    custAdd.address_description = acc.LastName + ' ' + acc.FirstName; // 'Kontkanen Veikko'
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
                    System.debug('!! add: ' + custAdd);
                    
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
                    delivAdd.address_description = acc.LastName + ' ' + acc.FirstName; //'Kontkanen Veikko';
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
                    delivAdd.note = '';
                    delivAdd.number1 = '';
                    delivAdd.delivery_terms = 'DAP';
                    delivAdd.delivery_type = 'delivery';
                    ordInfo.delivery_address = delivAdd;
                }
            	
				SalesPerson salesPerson = new SalesPerson();
                OpportunityTeamMember ot = opportunityTeamMemberMap.get(contractRecord.Opportunity__c);   
                salesPerson.username = (o.OwnerId != null && o.Owner.AD_Short_Username__c != null) ? o.Owner.AD_Short_Username__c : '';
                salesPerson.supervisor = (ot != NULL &&  ot.User.AD_Short_Username__c != null) ? ot.User.AD_Short_Username__c : ''; //LUM-979
                salesPerson.firstname = o.OwnerId != NULL ? o.Owner.FirstName : '';
                salesPerson.lastname = o.OwnerId != NULL ? o.Owner.LastName : '';
                ordInfo.sales_person = salesPerson;
			

                OrderWrapper ordWrap = new OrderWrapper();
                ordWrap.order_info = ordInfo;

                PaymentBatches batches = new PaymentBatches();
                PaymentBatch batch1 = new PaymentBatch();
                List<PaymentBatch> batchList = new List<PaymentBatch>();
                List<Payment_Batch__c> payBatchList = [select Id,Amount__c, Amount_percentage__c, Send_in_xml__c, Description__c, Name, Number__c, Payment_Plan__c, Type__c,Payment_Plan__r.Opportunity__c from Payment_Batch__c where Payment_Plan__r.Opportunity__c  =:contractRecord.Opportunity__c];
                if(payBatchList.size() > 0){
                    for(Payment_Batch__c pb : payBatchList){
                        if(pb.Send_in_xml__c == TRUE && pb.Amount__c != 0){
                            batch1.number1 = Integer.valueOf(pb.Number__c);//todo missed field
                            batch1.type = pb.Type__c;//todo missed field
                            batch1.description = pb.Description__c;//todo missed field
                            batch1.sum = pb.Amount__c;//todo missed field
                            batchList.add(batch1);
                        }
                    }
                }            
                batches.payment_batch = batchList;//todo missed field
                ordWrap.payment_batches = batches;
    
                jsonContent.order = ordWrap;

                ContentVersion contVerFile = new ContentVersion();
                ContVerFile.VersionData = Blob.valueOf(JSON.serialize(jsonContent));
                ContVerFile.Title = 'Contract JSON ' + contractRecord.ContractNumber;
                ContVerFile.ContentLocation= 's';
                ContVerFile.PathOnClient='ContractJSON' + contractRecord.ContractNumber + '.json';
                if (contractIdToDocumentId.get(contractRecord.Id) != null) {
                    System.debug('!!! doc id not null');
                    contVerFile.ContentDocumentId = contractIdToDocumentId.get(contractRecord.Id);
                }
				documentsToInsert.add(contVerFile);

                if (fromTrigger) {
                    notifyFrends(JSON.serialize(jsonContent), credentials.Endpoint__c, credentials.API_Key__c, contractRecord.Id);
                    //sendFilesToFrends(JSON.serialize(jsonContent), credentialsFiles.Endpoint__c, credentials.API_Key__c, contractRecord.Id);
                } else {
                    notifyFrendsFromComponent(JSON.serialize(jsonContent), credentials.Endpoint__c, credentials.API_Key__c, contractRecord.Id);
                    //sendFilesToFrends(JSON.serialize(jsonContent), credentialsFiles.Endpoint__c, credentials.API_Key__c, contractRecord.Id);
                }
				System.debug('--- jsonBody ---'+JSON.serialize(jsonContent));
			}	
            
        }catch(Exception e){
            throw new customException(e.getMessage());
        }
		
		try {
			if (documentsToInsert.size() > 0) {
				insert documentsToInsert;

				List<ContentVersion> docs = [SELECT ContentDocumentId, Title FROM ContentVersion WHERE Title IN: fileNames];
				List<Contract> contracts = [SELECT Id, ContractNumber FROM Contract WHERE ContractNumber IN: contractNumbers];

				Map<String, Id> contractNumberToId = new Map<String, Id>();
				for (Contract c : contracts) {
					contractNumberToId.put(c.ContractNumber, c.Id);
				}

				List<ContentDocumentLink> contDocLinks = new List<ContentDocumentLink>();
				Set<Id> conDocIds = new Set<Id>();
				for(ContentVersion cv1 : docs){
					conDocIds.add(cv1.ContentDocumentId);
				}
				List<ContentDocumentLink> documentLinks = [SELECT ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE ContentDocumentId IN: conDocIds];
				Set<String> docIdContractIdPairs = new Set<String>();
				for (ContentDocumentLink cdl : documentLinks) {
					docIdContractIdPairs.add(cdl.ContentDocumentId + ':' + cdl.LinkedEntityId);
				}

				for (ContentVersion cv : docs) {
					String contractNumber = cv.Title.substringAfter('Contract JSON ');

					if(contractNumberToId.get(contractNumber) != null){
						String pairToCheck = cv.ContentDocumentId + ':' + contractNumberToId.get(contractNumber);
						if (!docIdContractIdPairs.contains(pairToCheck)) {
							contDocLinks.add(new ContentDocumentLink(ContentDocumentId = cv.ContentDocumentId, ShareType = 'V', LinkedEntityId = contractNumberToId.get(contractNumber)));
						}
					}

				}

				if (!contDocLinks.isEmpty()) {
					upsert contDocLinks;
				}
			}
		} catch (Exception e) {
		//			throw new Exception(e.getMessage());
		}
	}

	@future (callout=true)
	public static void notifyFrends (String jsonBody, String endpoint, String apiKey, String contractId) {
		Http http = new Http();
        //jsonBody = jsonBody.replace('"currency":', '"currency1":');
		HttpRequest request = new HttpRequest();
		request.setEndpoint(endpoint);
		request.setMethod('POST');
        request.setTimeout(120000);
		request.setHeader('Content-Type', 'application/json;charset=UTF-8');
		request.setHeader('Authorization', apiKey);
		request.setBody(jsonBody);
		System.debug(jsonBody);
		HttpResponse response = http.send(request);

		System.debug('STATUS: ' + response.getStatus());

		if (response.getStatusCode() != 200) {
			System.debug('ERROR: ' + response.getBody());
			update new Contract(Id = contractId, Error_Message__c = response.getBody(), Is_Frends_JSON_Processed__c = false);
		} else {
			System.debug('SUCCESS: ' + response.getBody());
			update new Contract(Id = contractId, Error_Message__c = response.getBody(), Is_Frends_JSON_Processed__c = true);
		}
	}

	@AuraEnabled
	public static void notifyFrendsFromComponent (String jsonBody, String endpoint, String apiKey, String contractId) {
		Http http = new Http();
		HttpRequest request = new HttpRequest();
		request.setEndpoint(endpoint);
		request.setMethod('POST');
		request.setHeader('Content-Type', 'application/json;charset=UTF-8');
		request.setHeader('Authorization', apiKey);
		request.setBody(jsonBody);
		System.debug(jsonBody);
		HttpResponse response = http.send(request);

		System.debug('STATUS: ' + response.getStatus());

		if (response.getStatusCode() != 200) {
			System.debug('ERROR: ' + response.getBody());
			update new Contract(Id = contractId, Error_Message__c = response.getBody(), Is_Frends_JSON_Processed__c = false);
		} else {
			System.debug('SUCCESS: ' + response.getBody());
			update new Contract(Id = contractId, Is_Frends_JSON_Processed__c = true);
		}
	}
     
    @future (callout=true)
	public static void sendFilesToFrends (String jsonBody, String endpoint, String apiKey, String recordId) {
		try {
			Http http = new Http();
			HttpRequest request = new HttpRequest();
			request.setEndpoint(endpoint); //TODO Temporary hardcoded
			request.setMethod('POST');
			request.setHeader('Content-Type', 'application/json;charset=UTF-8');
			request.setHeader('Authorization', apiKey);
			request.setBody(jsonBody);
			HttpResponse response = http.send(request);

			System.debug('STATUS: ' + response.getStatus());
			if (response.getStatusCode() != 200) {
				System.debug('ERROR: ' + response.getBody());
				update new Contract(Id = recordId, Error_Message__c = response.getBody(), Is_Frends_JSON_Processed__c = false);
			} else {
				System.debug('SUCCESS: ' + response.getBody());
				update new Contract(Id = recordId, Is_Frends_JSON_Processed__c = true);
			}
		} catch(System.Exception e) {
			update new Contract(Id = recordId, Is_Frends_JSON_Processed__c = true);
		}
	}

	public class ContractJSON {
		public OrderWrapper order {public get; public set;}
	}

	public class OrderWrapper {
		public OrderInfo order_info {public get; public set;}
		public PaymentBatches payment_batches {public get; public set;}
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

	public class PaymentBatches {
		public List<PaymentBatch> payment_batch {public get; public set;}
	}

	public class PaymentBatch {
		public Integer number1 {public get; public set;}
		public String type {public get; public set;}
		public String description {public get; public set;}
		public Double sum {public get; public set;}
	}*/
}