public virtual class LP_MainControllerUtil {

	public static String STATUS_SUCCESS = 'success';
	public static String STATUS_ERROR = 'error';
	public class ApexResult {
		@AuraEnabled
		public Object result;
		@AuraEnabled
		public String status;
		@AuraEnabled
		public String errorMessage;

		public ApexResult() {
			this(null, STATUS_SUCCESS, null);
		}
		public ApexResult(Exception e) {
			this(null, STATUS_ERROR, e.getTypeName() == 'System.DmlException' ? e.getDmlMessage(0) : e.getMessage());
		}

		public ApexResult(Object result, String status, String errorMessage) {
			this.result = result;
			this.status = status;
			this.errorMessage = errorMessage;
		}
	}

	public class OrderDetail{
		@AuraEnabled public String product;
		@AuraEnabled public String installDate;
		@AuraEnabled public String installAddressStreet;
		@AuraEnabled public String installAddressZipCityState;
		@AuraEnabled public Decimal totalCost;
		@AuraEnabled public String orderNo;
		@AuraEnabled public String orderContractSTR;
		@AuraEnabled public String currencyIsoCode;
		@AuraEnabled public List<OrderDetailProduct> odProducts = new List<OrderDetailProduct>();
	}

	public class OrderDetailProduct{
		public String name;
		public Date warrantyStart;
		public Date warrantyEnd;
	}

	public class OrderWrapper{
		@AuraEnabled public String orderTabLabel;
		@AuraEnabled public String orderNo;
		@AuraEnabled public String orderId;
		@AuraEnabled public String opportunityId;
		@AuraEnabled public String installAddressStreet;
		@AuraEnabled public String installAddressZipCityState;
		@AuraEnabled public String orderComment;
		@AuraEnabled public String dynamicContentCss = 'os-dynamic-content';
		@AuraEnabled public String toggleButtonCss = 'toggle-content-button';
		@AuraEnabled public String orderDatesProgressSTR;
		@AuraEnabled public String installationDataSTR;
		@AuraEnabled public String orderContractSTR;
		@AuraEnabled public List<OrderProduct> orderProducts;
		@AuraEnabled public String currencyIsoCode;
		@AuraEnabled public Decimal totalCost;
	}

	public class OrderProduct{
		public String productName;
		public String productImageName;
		//public String productDimensions;
	}

	public class OrderDatesProgress{
		public Datetime orderDate;
		public String deliveryDate;
		public String installDate;
		public OrderDatesProgress(Datetime orderDate, String deliveryDate, String installDate){
			this.orderDate = orderDate;
			this.deliveryDate = deliveryDate;
			this.installDate = installDate;
		}
	}

	public class UpcomingInstallation{
		public String iDate;
		public String iComment;
	}

	public class OrderContract{
		@AuraEnabled public Date signedDate;
		@AuraEnabled public String orderId;
		@AuraEnabled public List<SignedDocument> signedDocuments;
	}

	public class SignedDocument{
		public String name;
		public String downloadUrl;
		public SignedDocument(String name, String downloadUrl){
			this.name = name;
			this.downloadUrl = downloadUrl;
		}
	}

	public class ContactPerson{
		@AuraEnabled public String firstName;
		@AuraEnabled public String lastName;
		@AuraEnabled public String position;
		@AuraEnabled public String email;
		@AuraEnabled public String emailHref;
		@AuraEnabled public String phone;
		@AuraEnabled public String phoneHref;
		@AuraEnabled public String profileImgUrl;
		public ContactPerson(String firstName, String lastName, String position, String email, String emailHref, String phone, String phoneHref, String profileImgUrl){
			this.firstName = firstName;
			this.lastName = lastName;
			this.position = position;
			this.email = email;
			this.emailHref = 'mailto:' + emailHref;
			this.phone = phone;
			this.phoneHref = 'tel:' + phoneHref;
			this.profileImgUrl = profileImgUrl;
		}
	}

	/*Portal Util Methods*/
	public static String getOrdersContractSTR(Date customerSignDate, String oppId){
		OrderContract oContract = new OrderContract();
		oContract.signedDate = customerSignDate;
		oContract.signedDocuments = getContractDownloadLinks(oppId);
		return JSON.serialize(oContract);
	}

	public static List<SignedDocument> getContractDownloadLinks(String oppId){
		List<ContentVersion> contentVersions = new List<ContentVersion>();
		List<ContentDocumentLink> cdLinks = [
			SELECT
				ContentDocumentId,
				LinkedEntityId
			FROM ContentDocumentLink
			WHERE LinkedEntityId =: oppId
			AND  ContentDocument.FileExtension = 'pdf'
			AND ContentDocument.Title LIKE '%signed%'
			LIMIT 50
		];
		if(!cdLinks.isEmpty()) {
			contentVersions = [
				SELECT
					Id,
					Title,
					ContentDocumentId
				FROM ContentVersion
				WHERE ContentDocumentId = :cdLinks[0].ContentDocumentId
				LIMIT 50
			];
		}
		List<SignedDocument> signedDocs = new List<SignedDocument>();
		if(!contentVersions.isEmpty()){
			for(ContentVersion cV : contentVersions) {
				String baseURL = Url.getOrgDomainUrl().toExternalForm();
				String downloadLink = baseURL + '/sfc/servlet.shepherd/version/download/' + cV.Id;
				signedDocs.add(new SignedDocument(cV.Title, downloadLink));

			}
		}
		return signedDocs;
	}

	public static String getInstallAddressZipCityState(Address address){
		String iAddress = '';
		if(address?.postalCode != null){
			iAddress +=  address.postalCode + ', ';
		}
		if(address?.city != null){
			iAddress +=  address.city + ', ';
		}
		if(address?.state != null){
			iAddress +=  address.state + ', ';
		}
		if(address?.country != null){
			iAddress += address.country;
		}
		return iAddress;
	}

	public static List<OrderDetailProduct> createOrderDetailProducts(List<OrderItem> orderItems, List<Entitlement> entitlements){
		List<OrderDetailProduct> orderProducts = new List<OrderDetailProduct>();
		Set<String> alreadyAddedProduct = new Set<String>();
		for(OrderItem oItem : orderItems){
			if(!alreadyAddedProduct.contains(oItem.Product_Group__c)){
				alreadyAddedProduct.add(oItem.Product_Group__c);
				OrderDetailProduct odProduct = createOrderDetailProduct(oItem.Product_Group__c, entitlements);
				orderProducts.add(odProduct);
			}
		}
		return orderProducts;
	}

	private static OrderDetailProduct createOrderDetailProduct(String productName, List<Entitlement> entitlements){
		OrderDetailProduct odProduct = new OrderDetailProduct();
		odProduct.name = productName;
		if(!entitlements.isEmpty()){
			for(Entitlement e : entitlements){
				if(e.Asset.Configuration_Product__r.Name == productName){
					odProduct.warrantyStart = e.StartDate;
					odProduct.warrantyEnd = e.EndDate;
					break;
				}
			}
		}
		return odProduct;
	}

	/*SOQL Methods*/
	public static List<Order> queryOrder(String orderId){
		return [
			SELECT
				OpportunityId,
				Opportunity.Installation_Time_Calc__c,
				Opportunity.Building__r.Building_Address__c,
				Opportunity.Net_Total_Price__c,
				OrderNumber,
				Contract.CustomerSignedDate,
				CurrencyIsoCode
			FROM Order
			WHERE Id =: orderId
			LIMIT 1
		];
	}
	public static List<Entitlement> queryEntitlement(String assetId){
		return [
			SELECT
				StartDate,
				EndDate,
				Asset.Configuration_Product__r.Name
			FROM Entitlement
			WHERE AssetId =: assetId
			LIMIT 1
		];
	}
	public static List<Asset> queryAssets(String oppId){
		return [
			SELECT
				Name
			FROM Asset
			WHERE Id IN (
				SELECT
					AssetId
				FROM WorkOrder
				WHERE Opportunity__c =: oppId)
			LIMIT 1
		];
	}
	public static List<OrderItem> queryOrderItems(String orderId){
		return [
			SELECT
				tolabel(Product_Group__c)
			FROM OrderItem
			WHERE OrderId =: orderId
			LIMIT 500
		];
	}
	public static List<Order> queryOrders(String accId){
		return [
			SELECT
				Id,
				OpportunityId,
				Opportunity.Installation_Comments_for_Customer__c,
				Opportunity.Order_Comments_for_Customer__c,
				Opportunity.Delivery_Date_Calc__c,
				Opportunity.Installation_Time_Calc__c,
				Opportunity.Building__r.Building_Address__c,
				Opportunity.Net_Total_Price__c,
				Contract.CustomerSignedDate,
				OrderNumber,
				CreatedDate,
				CurrencyIsoCode
			FROM Order
			WHERE IsDeleted = FALSE
			AND AccountId =: accId
			ORDER BY CreatedDate DESC
			LIMIT 100
		];
	}
	public static List<Account> fetchAccount(String contactId){
		return [
			SELECT
				Id
			FROM Account
			WHERE IsPersonAccount = TRUE
			AND IsCustomerPortal = TRUE
			AND PersonContactId =: contactId
			LIMIT 1
		];
	}
}