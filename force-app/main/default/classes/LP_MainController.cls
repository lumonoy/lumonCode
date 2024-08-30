public without sharing class LP_MainController extends LP_MainControllerUtil{

	public static Map<String, String> orderProductNameImageMap = getOrderProductsImageMap();

	private static Map<String, String> getOrderProductsImageMap(){
		Map<String, String> orderProductNameImageMap = new Map<String, String>();
		List<LP_Product_Image_Map__mdt> productImageMaps = LP_Product_Image_Map__mdt.getAll().values();
		for(LP_Product_Image_Map__mdt prodImg : productImageMaps) {
			orderProductNameImageMap.put(prodImg.Product_Name__c, prodImg.Product_Image_Name__c);
		}
		return orderProductNameImageMap;
	}

	@AuraEnabled public static String fetchOrderDetails(String orderId){
		List<Order> orders = queryOrder(orderId);
		List<Asset> assets = new List<Asset>();
		List<Entitlement> entitlements = new List<Entitlement>();
		List<OrderItem> orderItems  = new List<OrderItem>();
		if(!orders.isEmpty()){
			assets = queryAssets(orders[0].OpportunityId);
			orderItems = queryOrderItems(orderId);
		}
		if(!assets.isEmpty()){
			entitlements = queryEntitlement(assets[0].Id);
		}
		OrderDetail oD = new OrderDetail();
		if(!assets.isEmpty()){
			oD.product = assets[0].Name;
		}
		if(!orderItems.isEmpty()){
			oD.odProducts = createOrderDetailProducts(orderItems, entitlements);
		}
		if(!orders.isEmpty()){
			oD.installDate = String.valueOf(orders[0]?.Opportunity.Installation_Time_Calc__c);
			oD.installAddressStreet = orders[0]?.Opportunity.Building__r.Building_Address__c?.street;
			oD.installAddressZipCityState = getInstallAddressZipCityState(orders[0]?.Opportunity.Building__r.Building_Address__c);
			oD.totalCost = orders[0]?.Opportunity.Net_Total_Price__c;
			oD.orderNo = orders[0]?.OrderNumber;
			oD.currencyIsoCode = orders[0]?.CurrencyIsoCode;
			oD.orderContractSTR = getOrdersContractSTR(orders[0]?.Contract?.CustomerSignedDate, orders[0].OpportunityId);
		}
		return JSON.serialize(oD);
	}

	@AuraEnabled
	public static String fetchMyOrders(String contactId){

		List<OrderWrapper> orderWrappers = new List<OrderWrapper>();
		Map<Id, Id> oppOrderIdsMap = new Map<Id, Id>();
		Set<Id> orderIds = new Set<Id>();
		Map<String, Date> orderIdContractSignDateMap = new Map<String, Date>();

		List<Account> account = fetchAccount(contactId);
		List<Order> orders = queryOrders(account[0].Id);
		Integer orderTabNumber = 0;

		for(Order o : orders){
			OrderWrapper oW = createOrderWrapper(o, ++orderTabNumber);
			orderWrappers.add(oW);
			orderIds.add(o.Id);
			oppOrderIdsMap.put(o.OpportunityId, o.Id);
			orderIdContractSignDateMap.put(o.Id, o.Contract.CustomerSignedDate);
		}

		Map<String, List<OrderProduct>> orderIdProductsMap = createOrderIdProductsMap(orderIds);
		Map<String, List<SignedDocument>> orderIdSignedDocumentsMap = createOrderIdSignedDocumentsMap(oppOrderIdsMap);
		// update orderWRapper with products and contract data
		for(OrderWrapper oW : orderWrappers){
			OrderContract oContract = new OrderContract();
			oContract.signedDate = orderIdContractSignDateMap.get(oW.orderId);
			oContract.signedDocuments = orderIdSignedDocumentsMap.get(oW.orderId);
			oW.orderContractSTR = JSON.serialize(oContract);
			oW.orderProducts = orderIdProductsMap.get(oW.orderId);

		}
		return JSON.serialize(orderWrappers);
	}

	private static Map<String, List<SignedDocument>> createOrderIdSignedDocumentsMap(Map<Id, Id> oppOrderIdsMap){

		Map<String, List<SignedDocument>> orderIdContractLinksMap = new Map<String, List<SignedDocument>>();
		List<ContentVersion> contentVersions = new List<ContentVersion>();
		Set<Id> oppIdSet = oppOrderIdsMap.keySet();
		List<ContentDocumentLink> cdLinks = [
			SELECT
				ContentDocumentId,
				LinkedEntityId
			FROM ContentDocumentLink
			WHERE LinkedEntityId IN :oppIdSet
			AND ContentDocument.FileExtension = 'pdf'
			AND ContentDocument.Title LIKE '%signed%'
			LIMIT 50
		];
		Map<Id, Id> cDocIdOrderIdMap = new Map<Id, Id>();
		if(!cdLinks.isEmpty()) {
			cDocIdOrderIdMap = createContentDocIdOrderIdMap(cdLinks, oppOrderIdsMap);
			Set<Id> cDocIdSet = cDocIdOrderIdMap.keySet();
			contentVersions = [
				SELECT
					Id,
					Title,
					ContentDocumentId
				FROM ContentVersion
				WHERE ContentDocumentId IN : cDocIdSet
				LIMIT 50
			];
		}

		if(!contentVersions.isEmpty()){
			String baseURL = Url.getOrgDomainUrl().toExternalForm();
			for(ContentVersion cV : contentVersions){
				String orderId = cDocIdOrderIdMap.get(cV.ContentDocumentId);
				String contractPdfUrl = baseURL +'/sfc/servlet.shepherd/version/download/' + cV.Id;
				SignedDocument sD = new SignedDocument(cV.Title, contractPdfUrl);
				if(!orderIdContractLinksMap.containsKey(orderId)){
					orderIdContractLinksMap.put(orderId, new List<SignedDocument>{sD});
				}else{
					orderIdContractLinksMap.get(orderId).add(sD);
				}
			}
		}

		return orderIdContractLinksMap;
	}

	private static Map<Id, Id> createContentDocIdOrderIdMap(List<ContentDocumentLink> cdLinks, Map<Id, Id> oppOrderIdsMap){
		Map<Id, Id> cDocIdOrderIdMap = new Map<Id, Id>();
		for(ContentDocumentLink cdLink : cdLinks){
			if(oppOrderIdsMap.containsKey(cdLink.LinkedEntityId)){
				String orderId = oppOrderIdsMap.get(cdLink.LinkedEntityId);
				cDocIdOrderIdMap.put(cdLink.ContentDocumentId, orderId);
			}
		}
		return cDocIdOrderIdMap;
	}

	private static OrderWrapper createOrderWrapper(Order o, Integer orderTabNumber){
		OrderWrapper oW = new OrderWrapper();
		oW.orderTabLabel = System.Label.LP_Active_Order_Tab + ' ' + String.valueOf(orderTabNumber);
		oW.orderNo = o.OrderNumber;
		oW.orderId = o.Id;
		oW.opportunityId = o.OpportunityId;
		oW.currencyIsoCode = o.CurrencyIsoCode;
		oW.totalCost = o.Opportunity.Net_Total_Price__c;
		oW.orderComment = o.Opportunity.Order_Comments_for_Customer__c;
		oW.installAddressStreet = o.Opportunity.Building__r.Building_Address__c?.street;
		oW.installAddressZipCityState = getInstallAddressZipCityState(o.Opportunity.Building__r.Building_Address__c);
		oW.orderDatesProgressSTR = getOrderProgressDates(o);
		oW.installationDataSTR = getUpcomingInstallation(o);
		return oW;
	}
	private static String getOrderProgressDates(Order o){
		return JSON.serialize(
			new OrderDatesProgress(
				o.CreatedDate,
				o.Opportunity.Delivery_Date_Calc__c,
				o.Opportunity.Installation_Time_Calc__c)
		);
	}

	private static String getUpcomingInstallation(Order o){
		UpcomingInstallation installation = new UpcomingInstallation();
		installation.iDate = o.Opportunity.Installation_Time_Calc__c;
		installation.iComment = o.Opportunity.Installation_Comments_for_Customer__c;
		return JSON.serialize(installation);
	}

	private static Map<String, List<OrderProduct>> createOrderIdProductsMap(Set<Id> orderIds){
		List<OrderItem> orderItems = [
			SELECT
				OrderId,
				toLabel(Product_Group__c)
			FROM OrderItem
			WHERE OrderId IN :orderIds
			LIMIT 5000
		];
		Map<String, List<OrderProduct>> orderIdProductsWrapperMap = new Map<String, List<OrderProduct>>();
		for(OrderItem oItem : orderItems){
			OrderProduct oP = new OrderProduct();
			oP.productName = oItem.Product_Group__c;
			oP.productImageName = getProductImageName(oItem.Product_Group__c);
			if(!orderIdProductsWrapperMap.containsKey(oItem.OrderId)){
				orderIdProductsWrapperMap.put(oItem.OrderId, new List<OrderProduct>{oP});
			}else{
				List<OrderProduct> orderProducts = orderIdProductsWrapperMap.get(oItem.OrderId);
				if(!orderProducts.isEmpty()){
					Boolean productAlreadyAdded = false;
					for(OrderProduct oProd : orderProducts){
						if(oProd.productName == oItem.Product_Group__c){
							productAlreadyAdded = true;
							break;
						}
					}
					if(!productAlreadyAdded){
						orderIdProductsWrapperMap.get(oItem.OrderId).add(oP);
					}
				}
			}
		}
		return orderIdProductsWrapperMap;
	}

	private static String getProductImageName(String productName){
		return orderProductNameImageMap.containsKey(productName) ? orderProductNameImageMap.get(productName) : 'Product-No-Preview-Available';
	}

	@AuraEnabled public static String fetchContactInformation(String orderId){
		List<ContactPerson> contactPeople = new List<ContactPerson>();
		List<Order> orders = [
			SELECT
				CreatedBy.FirstName,
				CreatedBy.LastName,
				CreatedBy.Email,
				CreatedBy.Phone,
				CreatedBy.FullPhotoUrl
			FROM Order
			WHERE Id =: orderId
			LIMIT 1
		];
		if(!orders.isEmpty()){
			contactPeople.add(
				new ContactPerson(
					orders[0].CreatedBy.FirstName,
					orders[0].CreatedBy.LastName,
					System.Label.LP_Contact_Sales_Agent,
					orders[0].CreatedBy.Email,
					orders[0].CreatedBy.Email,
					orders[0].CreatedBy.Phone,
					orders[0].CreatedBy.Phone,
					orders[0].CreatedBy.FullPhotoUrl
				)
			);
		}
		return JSON.serialize(contactPeople);
	}

	@AuraEnabled
	public static List<Account> fetchMyAccountDetails(String contactId){
		return [
			SELECT
				Id,
				FirstName,
				LastName,
				PersonEmail,
				PersonMailingStreet,
				PersonMailingPostalCode,
				PersonMailingCity,
				PersonMailingCountry,
				Email_Opt_In__pc,
				SMS_Opt_In__pc,
				New_products_and_services__pc,
				Current_discounts__pc,
				Phone
			FROM Account
			WHERE PersonContactId =: contactId
			LIMIT 1
		];
	}

	@AuraEnabled public static ApexResult updateAccount(Account account){
		ApexResult response = new ApexResult();
		try {
			update account;
		}catch (Exception e){
			return new ApexResult(e);
		}
		return response;
	}

	@AuraEnabled public static List<Case> fetchMyCases(String contactId){
		return [
			SELECT
				Id,
				CaseNumber,
				Subject,
				Status,
				Origin,
				CreatedDate
			FROM Case
			WHERE ContactId =: contactId
			AND RecordType.DeveloperName = 'Customer_Service'
			ORDER BY CreatedDate DESC
			LIMIT 500
		];
	}

	// for orderHistoryPage datatable
	/*@AuraEnabled
	public static List<Order> fetchOrderHistory(String contactId){
		List<Account> account = fetchAccount(contactId);
		String accId = account.size() == 1 ? account[0].Id : null;
		List<Order> orders = [
			SELECT
				Id,
				OrderNumber,
				TotalAmount,
				Opportunity.Confirmed_installation_time__c,
				Opportunity.Building__r.Building_Address__c
			FROM Order
			WHERE AccountId =: accId
			AND IsDeleted = FALSE
			LIMIT 100
		];
		return orders;
	}*/
}