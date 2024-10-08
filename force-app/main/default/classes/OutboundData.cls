/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 09-09-2024
 * @last modified by  : Henk Reynders
**/
public class OutboundData {
	public OrderMessage orderMessage {get;set;} 
	public OutboundData(JSONParser parser) {
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
		public BatchData batchData {get;set;} 
		public OrderMessage(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'order_info') {
							orderData = new OrderData(parser);
						} else if (text == 'groups') {
							batchData = new BatchData(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'OrderMessage consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}	
	public class OrderData {
		// Business Attributes
		public String organizationCode {get;set;} 
		public String profitCenterCode {get;set;} 
		public String segmentCode {get;set;} 
		public String segmentName {get;set;} 
		public String propertytype {get;set;} 

		// Owner
		public UserData userData {get;set;} 
		public ProjectData projectData {get;set;} 

		public CostData budget {get;set;} 
		public String chargeable {get;set;} 
		public String currencyCode {get;set;} // in json: currency		
		public String customerReference {get;set;} 
		
		
		// Addresses
		public AddressData mainAddress {get;set;} 
		public customerData customerData {get;set;} 
		public invoicingData invoicingData {get;set;} 
		public deliveryData deliveryData {get;set;} 
		public installationData installationData {get;set;} 
		
		public String languageCode {get;set;} 
		public String leadSource {get;set;}
		
		// Order
		public String attachmentFolder {get;set;} 
		public String offerNumber {get;set;} 
		public String orderType {get;set;} 
		
		public PricelistData pricelist {get;set;} 
		// Project
		public String parentProject {get;set;} 
		public String projectGroup {get;set;} 
		public String projectNumber {get;set;} 
		// Delivery
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
							projectNumber = parser.getText();
						} else if (text == 'parent_project') {
							parentProject = parser.getText();
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
							budget = new CostData(parser);
						} else if (text == 'domestic_help') {
							domesticHelp = parser.getText();
						} else if (text == 'domestic_text') {
							domesticText = parser.getText();
						} else if (text == 'chargeable') {
							chargeable = parser.getText();
						} else if (text == 'worknumbername') {
							workOrderReference = parser.getText();
						} else if (text == 'pricelist') {
							pricelist = new PricelistData(parser);
						} else if (text == 'customer_address') {
							customerData = new CustomerData(parser);
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
		public String username {get;set;} 
		public String supervisor {get;set;} 
		public String firstname {get;set;} 
		public String lastname {get;set;} 

		public UserData(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'username') {
							username = parser.getText();
						} else if (text == 'supervisor') {
							supervisor = parser.getText();
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
	public class AddressData {
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
	
		public AddressData(JSONParser parser) {
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
                            if (String.IsNotBlank(parser.getText())) {
								customerNumber = parser.getText();
                            }
						} else if (text == 'customer_id') {
							customerId = parser.getText();
						} else if (text == 'customer_name') {
							customerName = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'AddressData consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}	
	public class CustomerData {
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

		public CustomerData(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						// Account
						if (text == 'customer_id') {
							customerId = parser.getText();
						} else if (text == 'customer_name') {
							customerName = parser.getText();
						} else if (text == 'number') {
							if (String.IsNotBlank(parser.getText())) {
								customerNumber = parser.getText();
							} else {
								customerNumber = '';
							}
						} else if (text == 'address_description') {
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
						} else if (text == 'phone_number') {
							phone = parser.getText();
						} else if (text == 'email') {
							email = parser.getText();
						} else if (text == 'fax') {
							fax = parser.getText();
						// Address						
						} else if (text == 'street_address') {
							street = parser.getText();
						} else if (text == 'postal_code') {
							postalCode = parser.getText();
						} else if (text == 'city') {
							city = parser.getText();
						} else if (text == 'county') {
							county = parser.getText();
						} else if (text == 'province') {
							province = parser.getText();
						} else if (text == 'country') {
							country = parser.getText();
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
		// Invoicing
		public String invoicingType {get;set;} 
		public String payment {get;set;} 
		public String paymentTerms {get;set;} 
		public String financingReference {get;set;} 

		public InvoicingData(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						// Account
						if (text == 'customer_id') {
							customerId = parser.getText();
						} else if (text == 'customer_name') {
							customerName = parser.getText();
						} else if (text == 'number') {
							if (String.IsNotBlank(parser.getText())) {
								customerNumber = parser.getText();
							}
						} else if (text == 'address_description') {
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
						} else if (text == 'phone_number') {
							phone = parser.getText();
						} else if (text == 'email') {
							email = parser.getText();
						} else if (text == 'fax') {
							fax = parser.getText();
						// Address						
						} else if (text == 'street_address') {
							street = parser.getText();
						} else if (text == 'postal_code') {
							postalCode = parser.getText();
						} else if (text == 'city') {
							city = parser.getText();
						} else if (text == 'county') {
							county = parser.getText();
						} else if (text == 'province') {
							province = parser.getText();
						} else if (text == 'country') {
							country = parser.getText();
						// Invoicing
						} else if (text == 'invoice_type') {
							invoicingType = parser.getText();
						} else if (text == 'payment') {
							payment = parser.getText();
						} else if (text == 'payment_terms') {
							paymentTerms = parser.getText();
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
		// Delivery
		public String deliveryTerms {get;set;} 
		public String deliveryType {get;set;} 

		public DeliveryData(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						// Account
						if (text == 'customer_id') {
							if (String.IsNotBlank(parser.getText())) {	
								customerId = parser.getText();
							} else {
								customerId = '';
							}
						} else if (text == 'customer_name') {
							if (String.IsNotBlank(parser.getText())) {
								customerName = parser.getText();
							} else {
								customerName = '';
							}
						} else if (text == 'number') {
							if (String.IsNotBlank(parser.getText())) {
								customerNumber = parser.getText();
							} else {
								customerNumber = '';
							}
						} else if (text == 'address_description') {
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
						} else if (text == 'phone_number') {
							phone = parser.getText();
						} else if (text == 'email') {
							email = parser.getText();
						} else if (text == 'fax') {
							fax = parser.getText();
						// Address						
						} else if (text == 'street_address') {
							street = parser.getText();
						} else if (text == 'postal_code') {
							postalCode = parser.getText();
						} else if (text == 'city') {
							city = parser.getText();
						} else if (text == 'county') {
							county = parser.getText();
						} else if (text == 'province') {
							province = parser.getText();
						} else if (text == 'country') {
							country = parser.getText();
						// Delivery
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
					// Account
					if (text == 'customer_id') {
						customerId = parser.getText();
					} else if (text == 'customer_name') {
						customerName = parser.getText();
					} else if (text == 'number') {
						if (String.IsNotBlank(parser.getText())) {
							customerNumber = parser.getText();
						}
					} else if (text == 'address_description') {
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
					} else if (text == 'phone_number') {
						phone = parser.getText();
					} else if (text == 'email') {
						email = parser.getText();
					} else if (text == 'fax') {
						fax = parser.getText();
					// Address						
					} else if (text == 'street_address') {
						street = parser.getText();
					} else if (text == 'postal_code') {
						postalCode = parser.getText();
					} else if (text == 'city') {
						city = parser.getText();
					} else if (text == 'county') {
						county = parser.getText();
					} else if (text == 'province') {
						province = parser.getText();
					} else if (text == 'country') {
						country = parser.getText();
					} else {
						System.debug(LoggingLevel.WARN, 'Install_address consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
		}
	}	
	public class CostData {
		public List<CostItemData> costCategories {get;set;} 

		public CostData(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'project_category') {
							costCategories = arrayOfCostItemData(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'CostData consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	public class CostItemData {
		public String category {get;set;} 
		public String cost {get;set;} 

		public CostItemData(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'category') {
							category = parser.getText();
						} else if (text == 'cost') {
							cost = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'CostItemData consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}		
	private static List<CostItemData> arrayOfCostItemData(System.JSONParser p) {
        List<CostItemData> res = new List<CostItemData>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new CostItemData(p));
        }
        return res;
    }
	public class PricelistData {
		public String pricelist_name {get;set;} 

		public PricelistData(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'pricelist_name') {
							pricelist_name = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'PricelistData consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}	
	public class ProjectData {		
		public String projectCategory {get;set;} 
		public String isChargeable {get;set;} 
		public String projectCost {get;set;} 
		public String projectGroup {get;set;} 
		public String projectNumber {get;set;} 
		public String projectType {get;set;} 
		public String projectParent {get;set;} 

		public ProjectData(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'subproject_number') {
							projectNumber = parser.getText();
						} else if (text == 'subproject_group') {
							projectGroup = parser.getText();
						} else if (text == 'subproject_category') {
							projectCategory = parser.getText();
						} else if (text == 'subproject_cost') {
							projectCost = parser.getText();
						} else if (text == 'subproject_ordertype') {
							projectType = parser.getText();
						} else if (text == 'subproject_parentproject') {
							projectParent = parser.getText();
						} else if (text == 'subproject_chargeable') {
							isChargeable = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Subproject_info consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}	
	public class BatchData {
		public List<OrderLineData> orderLineData {get;set;} // in json: group

		public BatchData(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'group') {
							orderLineData = arrayOfOrderLineData(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'OrderLineData consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}	
	public class OrderLineData {
		// Batch
		public String deliveryBatch {get;set;} 
		public String deliveryStatus {get;set;} 
		public String orderDate {get;set;} 
		public String deliveryDate {get;set;}
		// Plan
		public String planName {get;set;} 
		public String planUnit {get;set;} 
		public String planLine {get;set;} 
		public String planFloor {get;set;} 
		// Product
		public String productCode {get;set;} 
		public String productName {get;set;} 
		public String quantity {get;set;} 
		public String serialNumber {get;set;} 
		public String originalSerialnumber {get;set;}
		// Delivery
		public String additionalTime {get;set;} 
		public String process {get;set;} 		
		public String warehouseCode {get;set;} 
		public String packingOrder {get;set;} 
	
		// Installation 
		public String attachment {get;set;}
		public String installed {get;set;} 
		public String axConfiguration {get;set;} 
		public String installationStart {get;set;} 
		public String installationEnd {get;set;} 

		// Invoicing
		public String chargeable {get;set;} 
		public String salesPrice {get;set;} 
		public String sproduct {get;set;} 
		public String sfreight {get;set;} 
		public String sinstall {get;set;} 
		public String sother {get;set;} 
		public String purchasePrice {get;set;} 
		public String pproduct {get;set;} 
		public String pfreight {get;set;} 
		public String pinstall {get;set;} 
		public String pother {get;set;} 		
		public String factoryPrice {get;set;} 
		public String fproduct {get;set;} 
		public String ffreight {get;set;} 
		public String finstall {get;set;} 
		public String fother {get;set;} 
		public String subTotal {get;set;} 
		public String contractedPrice {get;set;} 
		// Product Statistics
		public String glassSurface {get;set;} 
		public String blindsSurface {get;set;} 
		public String glassAmount {get;set;} 
		public String productLength {get;set;} 
		public String productWeight {get;set;} 
		public ProductAttributeData attribute {get;set;} 
		
		public WorkOrderLineData workOrderLineData {get;set;} 
		public InstructionData instructionData {get;set;} 

		public OrderLineData(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'delivery_batch') {
							deliveryBatch = parser.getText();
						} else if (text == 'delivery_batch_status') {
							deliveryStatus = parser.getText();
						} else if (text == 'delivery_batch_receive_date') {
							orderDate = parser.getText();
						} else if (text == 'delivery_batch_delivery_date') {
							deliveryDate = parser.getText();
						} else if (text == 'group_attachment') {
							attachment = parser.getText();
						} else if (text == 'AXconfiguration') {
							axConfiguration = parser.getText();
						} else if (text == 'group_name') {
							productName = parser.getText();
						} else if (text == 'pcs') {
							quantity = parser.getText();
						} else if (text == 'structurenumber') {
							serialNumber = parser.getText();
						} else if (text == 'originalstructurenumber') {
							originalSerialNumber = parser.getText();
						} else if (text == 'install_start_date') {
							installationStart = parser.getText();
						} else if (text == 'install_end_date') {
							installationEnd = parser.getText();
						} else if (text == 'additional_deliverytime') {
							additionalTime = parser.getText();
						} else if (text == 'process') {
							process = parser.getText();
						} else if (text == 'product_code') {
							productCode = parser.getText();
						} else if (text == 'storageid') {
							warehouseCode = parser.getText();
						} else if (text == 'packing_order') {
							packingOrder = parser.getText();
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
							glassSurface = parser.getText();
						} else if (text == 'blinds_m2') {
							blindsSurface = parser.getText();
						} else if (text == 'glass_pcs') {
							glassAmount = parser.getText();
						} else if (text == 'product_length') {
							productLength = parser.getText();
						} else if (text == 'group_weight') {
							productWeight = parser.getText();
						} else if (text == 'product_attributes') {
							if (String.isNotBlank(parser.getText())){
								attribute = new ProductAttributeData(parser);
							}
						} else if (text == 'installed') {
							installed = parser.getText();
						} else if (text == 'OrderLine') {
							workOrderLineData = new WorkOrderLineData(parser);
						} else if (text == 'AssemblyInstructions') {
							instructionData = new InstructionData(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'OrderLineData consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	private static List<OrderLineData> arrayOfOrderLineData(System.JSONParser p) {
        List<OrderLineData> res = new List<OrderLineData>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new OrderLineData(p));
        }
        return res;
    }
	public class WorkOrderLineData {
		public String BOMVersion {get;set;} 
		public String ItemID {get;set;} 
		public String ItemName {get;set;} 
		public String InventLocationID {get;set;} 
		public String Dimension1 {get;set;} 
		public String Dimension5 {get;set;} 
		public String DeliveryName {get;set;} 
		public String DeliveryStreet {get;set;} 
		public String DeliveryZipCode {get;set;} 
		public String DeliveryCity {get;set;} 
		public String DeliveryCountryRegionID {get;set;} 
		public String LineAmount {get;set;} 
		public String Apartment {get;set;} 
		public String Floor {get;set;} 
		public String DlvBatchID {get;set;} 
		public String Line {get;set;} 
		public String FactoryConfirmedDlv {get;set;} 
		public String InstallHours {get;set;} 
		public String InstallStart {get;set;} 
		public String ReservationStart {get;set;} 
		public String DeliveryDatePromised {get;set;} 
		public String Plan_name {get;set;} 
		public String PieceWork_pay {get;set;} 

		public WorkOrderLineData(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'BOMVersion') {
							BOMVersion = parser.getText();
						} else if (text == 'ItemID') {
							ItemID = parser.getText();
						} else if (text == 'ItemName') {
							ItemName = parser.getText();
						} else if (text == 'InventLocationID') {
							InventLocationID = parser.getText();
						} else if (text == 'Dimension1') {
							Dimension1 = parser.getText();
						} else if (text == 'Dimension5') {
							Dimension5 = parser.getText();
						} else if (text == 'DeliveryName') {
							DeliveryName = parser.getText();
						} else if (text == 'DeliveryStreet') {
							DeliveryStreet = parser.getText();
						} else if (text == 'DeliveryZipCode') {
							DeliveryZipCode = parser.getText();
						} else if (text == 'DeliveryCity') {
							DeliveryCity = parser.getText();
						} else if (text == 'DeliveryCountryRegionID') {
							DeliveryCountryRegionID = parser.getText();
						} else if (text == 'LineAmount') {
							LineAmount = parser.getText();
						} else if (text == 'Apartment') {
							Apartment = parser.getText();
						} else if (text == 'Floor') {
							Floor = parser.getText();
						} else if (text == 'DlvBatchID') {
							DlvBatchID = parser.getText();
						} else if (text == 'Line') {
							Line = parser.getText();
						} else if (text == 'FactoryConfirmedDlv') {
							FactoryConfirmedDlv = parser.getText();
						} else if (text == 'InstallHours') {
							InstallHours = parser.getText();
						} else if (text == 'InstallStart') {
							InstallStart = parser.getText();
						} else if (text == 'ReservationStart') {
							ReservationStart = parser.getText();
						} else if (text == 'DeliveryDatePromised') {
							DeliveryDatePromised = parser.getText();
						} else if (text == 'Plan_name') {
							Plan_name = parser.getText();
						} else if (text == 'PieceWork_pay') {
							PieceWork_pay = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'WorkOrderLineItem consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}		
	public class ProductAttributeData {
		public String attributeid {get;set;} 

		public ProductAttributeData(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'attributeid') {
							attributeid = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'ProductAttributeData consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	public class InstructionData {
		public String notes {get;set;} 
		public AttachmentData attachmentData {get;set;} 
		public List<DocumentData> documentData {get;set;} 

		public InstructionData(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'InstallNotes') {
							notes = parser.getText();
						} else if (text == 'Attachments') {
							attachmentData = new AttachmentData(parser);
						} else if (text == 'AssemblyDocument') {
							documentData = arrayOfDocumentData(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'InstructionData consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	public class DocumentData {
		public String name {get;set;} 
		public List<ChapterData> chapters {get;set;} 

		public DocumentData(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'name') {
							name = parser.getText();
						} else if (text == 'ChapterData') {
							chapters = arrayOfChapterData(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'DocumentData consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	private static List<DocumentData> arrayOfDocumentData(System.JSONParser p) {
        List<DocumentData> res = new List<DocumentData>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new DocumentData(p));
        }
        return res;
    } 	
	public class ChapterData {
		public String name {get;set;} 
		public List<ParagraphData> ParagraphData {get;set;} 

		public ChapterData(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'name') {
							name = parser.getText();
						} else if (text == 'ParagraphData') {
							ParagraphData = arrayOfParagraphData(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'ChapterData consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	private static List<ChapterData> arrayOfChapterData(System.JSONParser p) {
        List<ChapterData> res = new List<ChapterData>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new ChapterData(p));
        }
        return res;
    }	
	public class ParagraphData {
		public String name {get;set;} 
		public String text {get;set;} 

		public ParagraphData(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'name') {
							name = parser.getText();
						} else if (text == 'text') {
							text = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'ParagraphData consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	private static List<ParagraphData> arrayOfParagraphData(System.JSONParser p) {
        List<ParagraphData> res = new List<ParagraphData>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new ParagraphData(p));
        }
        return res;
    }
	public class AttachmentData {
		public String remoteFile {get;set;} 
		public String remoteFolder {get;set;} 

		public AttachmentData(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'Attachment') {
							remoteFile = parser.getText();
						} else if (text == 'Folder') {
							remoteFolder = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'AttachmentData consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
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