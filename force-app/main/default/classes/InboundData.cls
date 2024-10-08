/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 09-15-2024
 * @last modified by  : Henk Reynders
**/
public class InboundData {
	public OrderMessage orderMessage {get;set;} 
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

		public CostData costData {get;set;} 
		public String chargeable {get;set;} 
		public String currencyCode {get;set;} // in json: currency		
		public String customerReference {get;set;} 
		
		
		// Addresses
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
		
		public Pricelist pricelist {get;set;} 
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
							System.debug(LoggingLevel.WARN, 'ProjectData consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}	

	
	public class ProductData {
		public List<Product> products {get;set;} // in json: group

		public ProductData(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'group') {
							products = arrayOfProduct(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'OrderItems consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}	
	public class Product {
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
		public ProductAttribute attribute {get;set;} 
		
		public Service service {get;set;} 
		public Instruction instruction {get;set;} 

		public Product(JSONParser parser) {
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
								attribute = new ProductAttribute(parser);
							}
						} else if (text == 'installed') {
							installed = parser.getText();
						} else if (text == 'OrderItem') {
							service = new Service(parser);
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
	
	private static List<Product> arrayOfProduct(System.JSONParser p) {
        List<Product> res = new List<Product>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Product(p));
        }
        return res;
    }
	public class Service {
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

		public Service(JSONParser parser) {
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
							System.debug(LoggingLevel.WARN, 'Service consuming unrecognized property: '+text);
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
						} else if (text == 'InstructionDocument') {
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
}