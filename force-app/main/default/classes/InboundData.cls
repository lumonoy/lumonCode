/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 10-13-2024
 * @last modified by  : Henk Reynders
**/
public class InboundData {
	public OrderMessage orderMessage {get;set;} 
	public SalesforceData importedData {get;set;} 
	public InboundData(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'order') {
						orderMessage = new OrderMessage(parser);
					} else {
						System.debug(LoggingLevel.WARN, 'InboundOrderData consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	public static InboundData parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new InboundData(parser);
	}	
	public static void consumeObject(System.JSONParser parser) {
		Integer depth = 0;
		do {
			System.JSONToken curr = parser.getCurrentToken();
			if (curr == System.JSONToken.START_OBJECT || 
				curr == System.JSONToken.START_ARRAY) {
				depth++;
			} else if (curr == System.JSONToken.END_OBJECT ||
				curr == System.JSONToken.END_ARRAY) {
				depth--;
			}
		} while (depth > 0 && parser.nextToken() != null);
	}
	public class OrderMessage {
		public OrderData orderData {get;set;} 
		public ProductData productData {get;set;} 
		public OrderMessage(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'order_info') {
							orderData = new OrderData(parser);
						} else if (text == 'groups') {
							productData = new ProductData(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'OrderMessage consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}	
	public class SalesforceData {
		// Business Attributes
		public String organizationCode {get; set;}  
		public String countryCode {get; set;} 
		public String profitCenterCode {get; set;} 
		public String officeCode {get; set;} 
		public String segmentCode {get; set;} 
		public String propertyType {get; set;} 
		public String businessType {get; set;} 
		//Office Codes
		public String salesOfficeCode {get;set;} 
		public String servicesOfficeCode {get;set;} 
		// Salesforce Records	
		public Building_Project__c project {get;set;} // Unique Key "project_number": "100001",
		public Delivery_Project__c subProject {get;set;} // Unique Key "subproject_number": "100001_01",
		public Delivery_Batch__c batch {get;set;} // Unique Key  "9000010011-1" => order_number": "900010011","delivery_batch": "1", 
		public Account account {get;set;} // Unique Key  "customer_name": "Test B2C Customer 1","number": "","customer_id": "",
		public Contact contact {get;set;} // Unique Key "contact_person": "B2C Contact 1",
		public Pricebook2 pricebook {get;set;} // Unique Key "pricelist_name": "Lumon Prices"
		public Opportunity opportunity {get;set;}  // Unique Key 
		public List<OpportunityLineItem> opportunityProducts {get;set;} 
		public Quote quote {get;set;} // Unique Key  "9000010011" => order_number": "900010011"
		public List<QuoteLineItem> quoteLines {get;set;} 
		public Contract contract {get;set;}
		public List<ContractLineItem> contractLineItems {get; set;}
		public List<Order> orders {get;set;} // Unique Key  "9000010011" => order_number": "900010011"
		public List<OrderItem> orderLines {get;set;} 
		public List<WorkOrder> workOrders {get;set;} 
		public List<WorkOrderLineItem> workOrderLines {get;set;} 
		public List<Asset> buildingAssets {get;set;} 		
		public List<Asset> apartmentAssets {get;set;}		
		public List<Asset> planAssets {get;set;} 	
		public List<Asset> productAssets {get;set;} 
		// Users
		public User salesUser {get;set;} 
		public User servicesUser {get;set;}  
		// Offices
		public Office__c salesOffice {get;set;} 
		public Office__c servicesOffice {get;set;} 
	}
	public class OrderData {
		// Business Attributes
		public String organizationCode {get;set;} 
		public String profitCenterCode {get;set;} 
		public String segmentCode {get;set;} 
		public String segmentName {get;set;} 
		public String propertyType {get;set;} 
		public String propertyTypeCode {get;set;} 
		// Owner
		public UserData userData {get;set;} 

		public String customerReference {get;set;} 
		
		// Addresses
		//public AddressData mainAddress {get;set;} 
		public customerData customerData {get;set;} // To identify Customer Account and Address
		public invoicingData invoicingData {get;set;} // To identify Billing Account and Address plus payment Terms/Method
		public deliveryData deliveryData {get;set;} // To identify Delivery Contact and Address plus delivery Terms/Method
		public installationData installationData {get;set;} // To identify Installation Contact and Address 
		// Offer/Contract/Order
		public String languageCode {get;set;} 
		public String leadSource {get;set;}
		public String attachmentFolder {get;set;} 
		public String offerNumber {get;set;} 
		public String orderType {get;set;} 
		public Pricelist pricelist {get;set;} 
		// Project
		public String projectNumber {get;set;} 
		public String projectGroup {get;set;} 
		public String subProjectNumber {get;set;} 
		public ProjectData projectData {get;set;} 
		public CostData costData {get;set;} 
		public String chargeable {get;set;} 
		public String currencyCode {get;set;} // in json: currency		
		// Delivery Schedule
		public String promisedDate {get;set;} 
		public String promisedWeek {get;set;} 
		public String factoryCode {get;set;} 
		public String contractor {get;set;} 
		public String workOrderReference {get;set;} 
		// Unused
		public String domesticHelp {get;set;} 
		public String domesticText {get;set;} 


		public OrderData(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'axcompanyid') {
							organizationCode = parser.getText();
						} else if (text == 'currency') {
							currencyCode = parser.getText();
						} else if (text == 'customer_reference') {
							customerReference = parser.getText();
						} else if (text == 'order_type') {
							orderType = parser.getText();
						} else if (text == 'order_number') {
							offerNumber = parser.getText();
						} else if (text == 'vendorid') {
							factoryCode = parser.getText();
						} else if (text == 'project_number') {
							subProjectNumber = parser.getText();
						} else if (text == 'parent_project') {
							projectNumber = parser.getText();
						} else if (text == 'project_group') {
							projectGroup = parser.getText();
						} else if (text == 'customer_segmentid') {
							segmentCode = parser.getText();
						} else if (text == 'customer_segmentname') {
							segmentName = parser.getText();
						} else if (text == 'promised_deliveryweek') {
							promisedWeek = parser.getText();
						} else if (text == 'promised_date') {
							promisedDate = parser.getText();
						} else if (text == 'main_contractor') {
							contractor = parser.getText();
						} else if (text == 'business_unit') {
							profitCenterCode = parser.getText();
						} else if (text == 'order_attachment') {
							attachmentFolder = parser.getText();
						} else if (text == 'subproject_info') {
							projectData = new ProjectData(parser);
						} else if (text == 'budget') {
							costData = new CostData(parser);
						} else if (text == 'domestic_help') {
							domesticHelp = parser.getText();
						} else if (text == 'domestic_text') {
							domesticText = parser.getText();
						} else if (text == 'chargeable') {
							chargeable = parser.getText();
						} else if (text == 'worknumbername') {
							workOrderReference = parser.getText();
						} else if (text == 'pricelist') {
							pricelist = new Pricelist(parser);
						} else if (text == 'customer_address') {
							customerData= new CustomerData(parser);
						} else if (text == 'invoice_address') {
							invoicingData = new InvoicingData(parser);
						} else if (text == 'install_address') {
							installationData = new InstallationData(parser);
						} else if (text == 'delivery_address') {
							deliveryData = new DeliveryData(parser);
						} else if (text == 'sales_person') {
							userData = new UserData(parser);
						} else if (text == 'propertytype') {
							propertyType = parser.getText();
						} else if (text == 'language_code_lan') {
							languageCode = parser.getText();
                        } else if (text == 'order_leadreference_vch'){
                            leadSource = parser.getText();
                        }
                        
                        else {
							System.debug(LoggingLevel.WARN, 'OrderData consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	public class UserData {
		public String salesUserName {get;set;} // "username": "lsalb2c",
		public String servicesUserName {get;set;} // "supervisor": "lsuper",
		public String firstname {get;set;} // "firstname": "Sales",
		public String lastname {get;set;} // "lastname": "Test"

		public UserData(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'username') {
							salesUserName = parser.getText();
						} else if (text == 'supervisor') {
							servicesUserName = parser.getText();
						} else if (text == 'firstname') {
							firstname = parser.getText();
						} else if (text == 'lastname') {
							lastname = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'UserData consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}	
	public class CustomerData {
		// Account
		public String customerId {get;set;} // "customer_id": "",
		public String customerName {get;set;} // "customer_name": "Test B2C Customer 1",
		public String customerNumber {get;set;} // "number": "",
		public String description {get;set;} // "address_description": "Test B2C Customer Address",
		public String note {get;set;} // "note": "",
		// Contact
		public String contact {get;set;} // "contact_person": "B2C Contact 1",
		public String firstName {get;set;} // "firstname": "B2C",
		public String lastName {get;set;} // "lastname": "Contact 1",
		public String phone {get;set;} // "phone_number": "100-1111111",
		public String email {get;set;} // "email": "b2c.contact1@test.me",
		public String fax {get;set;} // "fax": "",
		// Address
		public Id addressId {get; set;}
		public String street {get;set;} // "street_address": "Street 10",
		public String postalCode {get;set;} // "postal_code": "12345",
		public String city {get;set;} // "city": "Town",		
		public String county {get;set;} // "county": ""
		public String province {get;set;} // "province": "",
		public String country {get;set;} // "country": "FIN",

		public CustomerData(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'address_description') {
							description = parser.getText();
						} else if (text == 'firstname') {
							firstname = parser.getText();
						} else if (text == 'lastname') {
							lastname = parser.getText();
						} else if (text == 'contact_person') {
							contact = parser.getText();
						} else if (text == 'street_address') {
							street= parser.getText();
						} else if (text == 'city') {
							city = parser.getText();
						} else if (text == 'postal_code') {
							postalCode = parser.getText();
						} else if (text == 'fax') {
							fax = parser.getText();
						} else if (text == 'country') {
							country = parser.getText();
						} else if (text == 'province') {
							province = parser.getText();
						} else if (text == 'county') {
							county = parser.getText();
						} else if (text == 'phone_number') {
							phone = parser.getText();
						} else if (text == 'email') {
							email = parser.getText();
						} else if (text == 'note') {
							note = parser.getText();
						} else if (text == 'number') {
                            if (String.IsNotBlank(parser.getText())) {
								customerNumber = parser.getText();
                            }
						} else if (text == 'customer_id') {
							customerId = parser.getText();
						} else if (text == 'customer_name') {
							customerName = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'CustomerData consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}	
	public class InvoicingData {
		// Account
		public String customerId {get;set;} //
		public String customerName {get;set;} //
		public String customerNumber {get;set;} // "number": "",
		public String description {get;set;} // "address_description": "Test B2C Billing Address",
		public String note {get;set;} // "note": "",
		// Contact
		public String contact {get;set;} // "contact_person": "B2C Contact 2",
		public String firstName {get;set;} // "firstname": "B2C",
		public String lastName {get;set;} // "lastname": "Contact 2",
		public String phone {get;set;} // "phone_number": "100-2222222",
		public String email {get;set;} // "email": "b2c.contact2@test.me",
		public String fax {get;set;} // "fax": "",
		// Address
		public String street {get;set;} // "street_address": "Street 20",
		public String postalCode {get;set;} // "postal_code": "12345",
		public String city {get;set;} // "city": "Town",
		public String county {get;set;} // "country": "FIN",
		public String province {get;set;} // "province": "",
		public String country {get;set;} // "county": "",
		// Invoicing
		public String invoicingType {get;set;} // "invoice_type": "Email",
		public String payment {get;set;} // "payment": "REF",
		public String paymentTerms {get;set;} // "payment_terms": "07",
		public String financingReference {get;set;} // "paytrail_reference_id": ""

		public InvoicingData(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'address_description') {
							description = parser.getText();
						} else if (text == 'firstname') {
							firstname = parser.getText();
						} else if (text == 'lastname') {
							lastname = parser.getText();
						} else if (text == 'contact_person') {
							contact = parser.getText();
						} else if (text == 'street_address') {
							street = parser.getText();
						} else if (text == 'city') {
							city = parser.getText();
						} else if (text == 'postal_code') {
							postalCode = parser.getText();
						} else if (text == 'fax') {
							fax = parser.getText();
						} else if (text == 'country') {
							country = parser.getText();
						} else if (text == 'province') {
							province = parser.getText();
						} else if (text == 'county') {
							county = parser.getText();
						} else if (text == 'phone_number') {
							phone = parser.getText();
						} else if (text == 'email') {
							email = parser.getText();
						} else if (text == 'note') {
							note = parser.getText();
						} else if (text == 'payment_terms') {
							paymentTerms = parser.getText();
						} else if (text == 'invoice_type') {
							invoicingType = parser.getText();
						} else if (text == 'number') {
							customerNumber = parser.getText();
						} else if (text == 'payment') {
							payment = parser.getText();
						} else if (text == 'paytrail_reference_id') {
							financingReference = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'InvoicingData consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}	
	public class DeliveryData {
		// Account
		public String customerId {get;set;} 
		public String customerName {get;set;} 
		public String customerNumber {get;set;} // "number": "",
		public String description {get;set;} // "address_description": "Test B2C Delivery Address",
		public String note {get;set;} // "note": "",
		// Contact
		public String contact {get;set;} // "contact_person": "B2C Contact 4",
		public String firstName {get;set;} // "firstname": "B2C",
		public String lastName {get;set;} // "lastname": "Contact 4",
		public String phone {get;set;} // "phone_number": "100-4444444",
		public String email {get;set;} // "email": "b2c.contact4@test.me",
		public String fax {get;set;} // "fax": "",
		// Address
		public String street {get;set;} // "street_address": "Street 40",
		public String postalCode {get;set;} // "postal_code": "12345",
		public String city {get;set;} // "city": "Town",
		public String county {get;set;} // "county": "",
		public String province {get;set;} // "province": "",
		public String country {get;set;} // "country": "FIN",
		// Delivery
		public String deliveryTerms {get;set;} // "delivery_terms": "DAP",
		public String deliveryType {get;set;} // "delivery_type": "delivery"
		
		public DeliveryData(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'address_description') {
							description = parser.getText();
						} else if (text == 'firstname') {
							firstname = parser.getText();
						} else if (text == 'lastname') {
							lastname = parser.getText();
						} else if (text == 'contact_person') {
							contact = parser.getText();
						} else if (text == 'street_address') {
							street = parser.getText();
						} else if (text == 'city') {
							city = parser.getText();
						} else if (text == 'postal_code') {
							postalCode = parser.getText();
						} else if (text == 'fax') {
							fax = parser.getText();
						} else if (text == 'country') {
							country = parser.getText();
						} else if (text == 'province') {
							province = parser.getText();
						} else if (text == 'county') {
							county = parser.getText();
						} else if (text == 'phone_number') {
							phone = parser.getText();
						} else if (text == 'email') {
							email = parser.getText();
						} else if (text == 'note') {
							note = parser.getText();
						} else if (text == 'number') {
							customerNumber = parser.getText();
						} else if (text == 'delivery_terms') {
							deliveryTerms = parser.getText();
						} else if (text == 'delivery_type') {
							deliveryType = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'DeliveryData consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	public class InstallationData {
		// Account
		public String customerId {get;set;} 
		public String customerName {get;set;} 
		public String customerNumber {get;set;} // in json: number
		public String description {get;set;} 
		public String note {get;set;} 
		// Contact
		public String contact {get;set;} 
		public String firstName {get;set;} 
		public String lastName {get;set;}
		public String phone {get;set;} 
		public String email {get;set;} 
		public String fax {get;set;} 
		// Address
		public String street {get;set;} 
		public String postalCode {get;set;} 
		public String city {get;set;} 		
		public String county {get;set;} 
		public String province {get;set;} 
		public String country {get;set;} 
		
		public InstallationData(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'address_description') {
						description = parser.getText();
					} else if (text == 'note') {
						note = parser.getText();
					// Contact
					} else if (text == 'contact_person') {
						contact = parser.getText();
					} else if (text == 'firstname') {
						firstname = parser.getText();
					} else if (text == 'lastname') {
						lastname = parser.getText();
					} else if (text == 'name') {
						customerName = parser.getText();
					} else if (text == 'contact_person') {
						contact = parser.getText();
					} else if (text == 'street_address') {
						street = parser.getText();
					} else if (text == 'city') {
						city = parser.getText();
					} else if (text == 'postal_code') {
						postalCode = parser.getText();
					} else if (text == 'fax') {
						fax = parser.getText();
					} else if (text == 'country') {
						country = parser.getText();
					} else if (text == 'province') {
						province = parser.getText();
					} else if (text == 'county') {
						county = parser.getText();
					} else if (text == 'phone_number') {
						phone = parser.getText();
					} else if (text == 'email') {
						email = parser.getText();
					} else if (text == 'note') {
						note = parser.getText();
					} else if (text == 'number') {
						customerNumber = parser.getText();
					} else {
						System.debug(LoggingLevel.WARN, 'InstallData consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
		}
	}	
	public class CostData {
		public List<CostCategory> costCategories {get;set;} 

		public CostData(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'project_category') {
							costCategories = arrayOfCostCategory(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'CostData consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	public class CostCategory {
		public String category {get;set;} 
		public String cost {get;set;} 

		public CostCategory(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'category') {
							category = parser.getText();
						} else if (text == 'cost') {
							cost = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'CostCategory consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}		
	private static List<CostCategory> arrayOfCostCategory(System.JSONParser p) {
        List<CostCategory> res = new List<CostCategory>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new CostCategory(p));
        }
        return res;
    }
	public class Pricelist {
		public String pricelist_name {get;set;} 

		public Pricelist(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'pricelist_name') {
							pricelist_name = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Pricelist consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}	
	public class ProjectData {	
		public Id mainProjectId {get;set;} 	
		public Id subProjectId {get;set;} 
		public String projectCategory {get;set;} 
		public String isChargeable {get;set;} 
		public String projectCost {get;set;} 
		public String projectGroup {get;set;} 
		public String mainProjectNumber {get;set;} 
		public String orderType {get;set;} 
		public String subProjectNumber {get;set;} 

		public ProjectData(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'subproject_number') {
							subProjectNumber = parser.getText();
						} else if (text == 'subproject_group') {
							projectGroup = parser.getText();
						} else if (text == 'subproject_category') {
							projectCategory = parser.getText();
						} else if (text == 'subproject_cost') {
							projectCost = parser.getText();
						} else if (text == 'subproject_ordertype') {
							orderType = parser.getText();
						} else if (text == 'subproject_parentproject') {
							mainProjectNumber = parser.getText();
						} else if (text == 'subproject_chargeable') {
							isChargeable = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'ProjectData consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}	
	public class ProductData {
		public List<ProductLineData> productLineItems {get;set;} // in json: group

		public ProductData(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'group') {
							productLineItems = arrayOfProductLineData(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'OrderItems consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}	
	public class ProductLineData {
		// Batch
		public String batchNumber {get;set;} // Batch Number => "delivery_batch": "1",
		public String batchStatus {get;set;} // Batch Status => "delivery_batch_status": "Mitattu",
		// Dates
		public String deliveryDate {get;set;} //"delivery_batch_delivery_date": "22.10.2025",
		public String earliestStartDate {get;set;} //"install_start_date": "25.10.2025",		
		public String promisedDate {get;set;} //"install_end_date": "21.11.2025",
		// Plan
		public String planName {get;set;} // planName => "salestori_plan_name": "LGR Basic",
		public String planUnit {get;set;} // planName => "unit": "A",
		public String planLine {get;set;} // planLine => "line": "1",
		public String planFloor {get;set;} // planFloor => "floor": "9",	
		// Product
		public String productCode {get;set;} // ProductCode => "product_code": "90240001",
		public String productName {get;set;} // ProductName => "group_name": "Avautuva (LGR)",
		public String quantity {get;set;} // Product Quantity always 1 => 	"pcs": "1",
		public String serialNumber {get;set;} // serialNumber (RVN) =>	"structurenumber": "9000100100001001",
		public String originalSerialnumber {get;set;} // reclamation SerialNumber (RVN)	=>"originalstructurenumber": "",
		// Delivery	
		public String orderDate {get;set;} //"delivery_batch_receive_date": "25.10.2025",
		public String orderType {get;set;} //order Type => "process": "Normal",	
		public String additionalTime {get;set;} //"additional_deliverytime": "0",	
		public String warehouseCode {get;set;} //warehouseCode => "storageid": "VAN",
		public String packingOrderCode {get;set;} //packingOrderCode line or floor => "packing_order": "1",
		// Installation 
		public String attachment {get;set;} // "group_attachment": "",
		public String hasInstallation {get;set;} // "installed": "True",
		public String isAxConfiguration {get;set;} //"AXconfiguration": "no",
		// Factory Prices
		public String factoryPrice {get;set;} // Factory Price => "factory_price": "200.00",
		public String fproduct {get;set;} // Factory Cost => "fproduct": "200.00",
		public String ffreight {get;set;} // NOT IN USE Factory Freight Cost => "ffreight": "0.00",
		public String finstall {get;set;} // NOT IN USE Factory Installation Cost => "finstall": "0.00",
		public String fother {get;set;}  // NOT IN USE Factory Other Cost =>"fother": "0.00",
		// Product Costs aka Purchase Price
		public String purchasePrice {get;set;} //Product Cost =>  "purchase_price": "100.00",
		public String pproduct {get;set;}  // NOT IN USE => "pproduct": "0.00",
		public String pfreight {get;set;} // NOT IN USE => "pfreight": "0.00",
		public String pinstall {get;set;} // Installation/Service Cost => "pinstall": "100.00",
		public String pother {get;set;} // NOT IN USE => "pother": "0.00",
		// Sales Prices aka List Price
		public String salesPrice {get;set;} // List Price => "sales_price": "400.00",
		public String sproduct {get;set;} // List Service + Product Price => "sproduct": "200.00",
		public String sfreight {get;set;} // Delivery List Price => "sfreight": "25.00",
		public String sinstall {get;set;} // Services List Price => "sinstall": "150.00",
		public String sother {get;set;} // Other Items => "sother": "25.00",	
		// Invoicing
		public String chargeable {get;set;} // "chargeable": "chargeable",
		public String subTotal {get;set;} // "calculated_salesprice": "500.00",
		public String contractedPrice {get;set;}  //"contract_price": "550.00",
		// Product Attributes
		public String glass_m2 {get;set;} // Glass Surface => "glass_m2": "4.00",
		public String blinds_m2 {get;set;} // Blinds Surface => "blinds_m2": "0.00",
		public String glass_pcs {get;set;} // Number of Glasses => "glass_pcs": "4",
		public String product_mm {get;set;} // Product Lenght in mm => "product_length": "2000",
		public String product_kg {get;set;} // Product Weight in kg => "group_weight": "100.000",
		//Related
		public ProductAttribute attribute {get;set;} //???	"product_attributes": {"attributeid": "20001111"},	
		public ServiceLineData serviceLineItem {get;set;} 
		public Instruction instruction {get;set;} 

		public ProductLineData(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'delivery_batch') {
							batchNumber = parser.getText();
						} else if (text == 'delivery_batch_status') {
							batchStatus = parser.getText();
						} else if (text == 'delivery_batch_receive_date') {
							orderDate = parser.getText();
						} else if (text == 'delivery_batch_delivery_date') {
							deliveryDate = parser.getText();
						} else if (text == 'group_attachment') {
							attachment = parser.getText();
						} else if (text == 'AXconfiguration') {
							isAxConfiguration = parser.getText();
						} else if (text == 'group_name') {
							productName = parser.getText();
						} else if (text == 'pcs') {
							quantity = parser.getText();
						} else if (text == 'structurenumber') {
							serialNumber = parser.getText();
						} else if (text == 'originalstructurenumber') {
							originalSerialNumber = parser.getText();
						} else if (text == 'install_start_date') {
							earliestStartDate= parser.getText();
						} else if (text == 'install_end_date') {
							promisedDate = parser.getText();
						} else if (text == 'additional_deliverytime') {
							additionalTime = parser.getText();
						} else if (text == 'process') {
							orderType = parser.getText();
						} else if (text == 'product_code') {
							productCode = parser.getText();
						} else if (text == 'storageid') {
							warehouseCode = parser.getText();
						} else if (text == 'packing_order') {
							packingOrderCode = parser.getText();
						} else if (text == 'unit') {
							planUnit = parser.getText();
						} else if (text == 'line') {
							planLine = parser.getText();
						} else if (text == 'floor') {
							planFloor = parser.getText();
						} else if (text == 'chargeable') {
							chargeable = parser.getText();
						} else if (text == 'sales_price') {
							salesPrice = parser.getText();
						} else if (text == 'sproduct') {
							sproduct = parser.getText();
						} else if (text == 'sfreight') {
							sfreight = parser.getText();
						} else if (text == 'sinstall') {
							sinstall = parser.getText();
						} else if (text == 'sother') {
							sother = parser.getText();
						} else if (text == 'purchase_price') {
							purchasePrice = parser.getText();
						} else if (text == 'pproduct') {
							pproduct = parser.getText();
						} else if (text == 'pfreight') {
							pfreight = parser.getText();
						} else if (text == 'pinstall') {
							pinstall = parser.getText();
						} else if (text == 'pother') {
							pother = parser.getText();
						} else if (text == 'calculated_salesprice') {
							subTotal = parser.getText();
						} else if (text == 'factory_price') {
							factoryPrice = parser.getText();
						} else if (text == 'fproduct') {
							fproduct = parser.getText();
						} else if (text == 'ffreight') {
							ffreight = parser.getText();
						} else if (text == 'finstall') {
							finstall = parser.getText();
						} else if (text == 'fother') {
							fother = parser.getText();
						} else if (text == 'contract_price') {
							contractedPrice = parser.getText();
						} else if (text == 'salestori_plan_name') {
							planName = parser.getText();
						} else if (text == 'glass_m2') {
							glass_m2 = parser.getText();
						} else if (text == 'blinds_m2') {
							blinds_m2 = parser.getText();
						} else if (text == 'glass_pcs') {
							glass_pcs = parser.getText();
						} else if (text == 'product_length') {
							product_mm = parser.getText();
						} else if (text == 'group_weight') {
							product_kg = parser.getText();
						} else if (text == 'product_attributes') {
							if (String.isNotBlank(parser.getText())){
								attribute = new ProductAttribute(parser);
							}
						} else if (text == 'installed') {
							hasInstallation = parser.getText();
						} else if (text == 'OrderLine') {
							ServiceLineItem = new ServiceLineData(parser);
						} else if (text == 'AssemblyInstructions') {
							instruction = new Instruction(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Product consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	public class ProductAttribute {
		public String attributeid {get;set;} 

		public ProductAttribute(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'attributeid') {
							attributeid = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'ProductAttribute consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}	
	private static List<ProductLineData> arrayOfProductLineData(System.JSONParser p) {
        List<ProductLineData> res = new List<ProductLineData>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new ProductLineData(p));
        }
        return res;
    }
	public class ServiceLineData {               
		// Business Attributes
		public String warehouseCode {get;set;} // WarehouseCode => "InventLocationID": "VAN",
		public String profitCenterCode {get;set;} // OrganizationCode => "Dimension1": "401",
		public String servicesUserName {get;set;} // Supervisor => "Dimension5": "imTest",
		public String orderDate {get;set;} //"delivery_batch_receive_date": "25.10.2025",
		// Product
		public String serialNumber {get;set;} // RVN => "BOMVersion": "9000100100001001",
		public String productCode {get;set;} // ProductCode => "ItemID": "90240001",
		public String productName {get;set;}  // ProductName => "ItemID": "LG",
		public String lineCount {get;set;} // Cost => "LineAmount": "1000.00",
		// Batch
		public String batchNumber {get;set;} // Batch Number => "DlvBatchID": "1",	
		//Plan
		public String planName {get;set;} // Plan Name => "Plan_name": "LGR Basic",
		public String planUnit {get;set;} // Apartment/Unit =>  "Apartment": "A",
		public String planFloor {get;set;} // Floor => "Floor": "1",
		public String planLine {get;set;} // Line => "Line": "1",		
		// Delivery		
		public String deliveryDate {get;set;} // Confirmed Delivery Date => "FactoryConfirmedDlv": "",
		public String deliveryName {get;set;} // Customer Name => "DeliveryName": "Test B2B Delivery Address",
		public String deliveryStreet {get;set;} // Installation Street => "DeliveryStreet": "Street 1a",
		public String deliveryPostalCode {get;set;} // Installation Street => "DeliveryZipCode": "12345",
		public String deliveryCity {get;set;} // Installation Street => "DeliveryCity": "Town",
		public String deliveryCountryCode {get;set;} // Installation Street => "DeliveryCountryRegionID": "FI",
		// Services 
		public String earliestStartDate {get;set;} //"install_start_date": "25.10.2025",		
		public String promisedDate {get;set;} // Due Date => "DeliveryDatePromised": "01.11.2025",	
		public String installationHours {get;set;} // Estimated Installation Time (RVN) => "InstallHours": "5",
		public String installationStart {get;set;} // Earliest Start Date => "InstallStart": "25.10.2025",      
		public String reservationStart {get;set;} // "ReservationStart": "2025-10-25T00.00.00",	
		public String servicesPrice {get;set;} // Service Costs => "PieceWork_pay": "150.00"

		public ServiceLineData(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'BOMVersion') {
							serialNumber = parser.getText();
						} else if (text == 'ItemID') {
							productCode = parser.getText();
						} else if (text == 'ItemName') {
							productName = parser.getText();
						} else if (text == 'InventLocationID') {
							warehouseCode = parser.getText();
						} else if (text == 'Dimension1') {
							profitCenterCode = parser.getText();
						} else if (text == 'Dimension5') {
							servicesUserName = parser.getText();
						} else if (text == 'DeliveryName') {
							deliveryName = parser.getText();
						} else if (text == 'DeliveryStreet') {
							deliveryStreet = parser.getText();
						} else if (text == 'DeliveryZipCode') {
							deliveryPostalCode = parser.getText();
						} else if (text == 'DeliveryCity') {
							deliveryCity = parser.getText();
						} else if (text == 'DeliveryCountryRegionID') {
							deliveryCountryCode = parser.getText();
						} else if (text == 'LineAmount') {
							lineCount= parser.getText();
						} else if (text == 'Apartment') {
							planUnit = parser.getText();
						} else if (text == 'Floor') {
							planFloor = parser.getText();
						} else if (text == 'DlvBatchID') {
							batchNumber = parser.getText();
						} else if (text == 'Line') {
							planLine = parser.getText();
						} else if (text == 'FactoryConfirmedDlv') {
							deliveryDate = parser.getText();
						} else if (text == 'InstallHours') {
							installationHours = parser.getText();
						} else if (text == 'InstallStart') {
							installationStart = parser.getText();
						} else if (text == 'ReservationStart') {
							reservationStart = parser.getText();
						} else if (text == 'DeliveryDatePromised') {
							promisedDate = parser.getText();
						} else if (text == 'Plan_name') {
							PlanName = parser.getText();
						} else if (text == 'PieceWork_pay') {
							servicesPrice = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'ServiceLineData consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}	
	public class Attachment {
		public String Attachment {get;set;} 
		public String Folder {get;set;} 

		public Attachment(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'Attachment') {
							Attachment = parser.getText();
						} else if (text == 'Folder') {
							Folder = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Attachment consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}	
	public class Instruction {
		public String notes {get;set;} 
		public Attachment attachment {get;set;} 
		public List<InstructionDocument> documents {get;set;} 

		public Instruction(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'InstallNotes') {
							notes = parser.getText();
						} else if (text == 'Attachments') {
							attachment = new Attachment(parser);
						} else if (text == 'AssemblyDocument') {
							documents = arrayOfInstructionDocument(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Instruction consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	public class InstructionDocument {
		public String name {get;set;} 
		public List<Chapter> chapters {get;set;} 

		public InstructionDocument(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'name') {
							name = parser.getText();
						} else if (text == 'Chapter') {
							chapters = arrayOfChapter(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'InstructionDocument consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	private static List<InstructionDocument> arrayOfInstructionDocument(System.JSONParser p) {
        List<InstructionDocument> res = new List<InstructionDocument>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new InstructionDocument(p));
        }
        return res;
    } 	
	public class Chapter {
		public String name {get;set;} 
		public List<Paragraph> Paragraph {get;set;} 

		public Chapter(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'name') {
							name = parser.getText();
						} else if (text == 'Paragraph') {
							Paragraph = arrayOfParagraph(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Chapter consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	private static List<Chapter> arrayOfChapter(System.JSONParser p) {
        List<Chapter> res = new List<Chapter>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Chapter(p));
        }
        return res;
    }	
	public class Paragraph {
		public String name {get;set;} 
		public String text {get;set;} 

		public Paragraph(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'name') {
							name = parser.getText();
						} else if (text == 'text') {
							text = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Paragraph consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	private static List<Paragraph> arrayOfParagraph(System.JSONParser p) {
        List<Paragraph> res = new List<Paragraph>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Paragraph(p));
        }
        return res;
    }
}