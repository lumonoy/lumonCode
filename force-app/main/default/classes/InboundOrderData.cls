/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 09-06-2024
 * @last modified by  : Henk Reynders
**/
public class InboundOrderData {
	public Order order {get;set;} 
	public InboundOrderData(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'order') {
						order = new Order(parser);
					} else {
						System.debug(LoggingLevel.WARN, 'InboundOrderData consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	public class Order {
		public Order_info order_info {get;set;} 
		public Groups groups {get;set;} 

		public Order(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'order_info') {
							order_info = new Order_info(parser);
						} else if (text == 'groups') {
							groups = new Groups(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Order consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}


	
	public class Product_attributes {
		public String attributeid {get;set;} 

		public Product_attributes(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'attributeid') {
							attributeid = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Product_attributes consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Customer_address {
		public String address_description {get;set;} 
		public String city {get;set;} 
		public String contact_person {get;set;} 
		public String country {get;set;} 
		public String county {get;set;} 
		public String customer_id {get;set;} 
		public String customer_name {get;set;} 
		public String customerNumber {get;set;} // in json: number
		public String email {get;set;} 
		public String fax {get;set;} 
		public String firstName {get;set;} 
		public String lastName {get;set;} 
		public String note {get;set;} 
		public String phone_number {get;set;} 
		public String postal_code {get;set;} 
		public String province {get;set;} 
		public String street_address {get;set;} 

		public Customer_address(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'address_description') {
							address_description = parser.getText();
						} else if (text == 'firstname') {
							firstname = parser.getText();
						} else if (text == 'lastname') {
							lastname = parser.getText();
						} else if (text == 'contact_person') {
							contact_person = parser.getText();
						} else if (text == 'street_address') {
							street_address = parser.getText();
						} else if (text == 'city') {
							city = parser.getText();
						} else if (text == 'postal_code') {
							postal_code = parser.getText();
						} else if (text == 'fax') {
							fax = parser.getText();
						} else if (text == 'country') {
							country = parser.getText();
						} else if (text == 'province') {
							province = parser.getText();
						} else if (text == 'county') {
							county = parser.getText();
						} else if (text == 'phone_number') {
							phone_number = parser.getText();
						} else if (text == 'email') {
							email = parser.getText();
						} else if (text == 'note') {
							note = parser.getText();
						} else if (text == 'number') {
                            if (String.IsNotBlank(parser.getText())) {
								customerNumber = parser.getText();
                            }
						} else if (text == 'customer_id') {
							customer_id = parser.getText();
						} else if (text == 'customer_name') {
							customer_name = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Customer_address consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Invoice_address {
		public String address_description {get;set;} 
		public String city {get;set;} 
		public String contact_person {get;set;} 
		public String country {get;set;} 
		public String county {get;set;} 
		public String email {get;set;} 
		public String fax {get;set;} 
		public String firstname {get;set;} 
		public String invoice_type {get;set;} 
		public String lastname {get;set;} 
		public String note {get;set;} 
		public String number_Z {get;set;} // in json: number
		public String payment {get;set;} 
		public String payment_terms {get;set;} 
		public String paytrail_reference_id {get;set;} 
		public String phone_number {get;set;} 
		public String postal_code {get;set;} 
		public String province {get;set;} 
		public String street_address {get;set;} 


		public Invoice_address(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'address_description') {
							address_description = parser.getText();
						} else if (text == 'firstname') {
							firstname = parser.getText();
						} else if (text == 'lastname') {
							lastname = parser.getText();
						} else if (text == 'contact_person') {
							contact_person = parser.getText();
						} else if (text == 'street_address') {
							street_address = parser.getText();
						} else if (text == 'city') {
							city = parser.getText();
						} else if (text == 'postal_code') {
							postal_code = parser.getText();
						} else if (text == 'fax') {
							fax = parser.getText();
						} else if (text == 'country') {
							country = parser.getText();
						} else if (text == 'province') {
							province = parser.getText();
						} else if (text == 'county') {
							county = parser.getText();
						} else if (text == 'phone_number') {
							phone_number = parser.getText();
						} else if (text == 'email') {
							email = parser.getText();
						} else if (text == 'note') {
							note = parser.getText();
						} else if (text == 'payment_terms') {
							payment_terms = parser.getText();
						} else if (text == 'invoice_type') {
							invoice_type = parser.getText();
						} else if (text == 'number') {
							number_Z = parser.getText();
						} else if (text == 'payment') {
							payment = parser.getText();
						} else if (text == 'paytrail_reference_id') {
							paytrail_reference_id = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Invoice_address consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Delivery_address {
		public String address_description {get;set;} 
		public String city {get;set;} 
		public String contact_person {get;set;} 
		public String country {get;set;} 
		public String county {get;set;} 
		public String delivery_terms {get;set;} 
		public String delivery_type {get;set;} 
		public String email {get;set;} 
		public String fax {get;set;} 
		public String firstname {get;set;} 
		public String lastname {get;set;} 
		public String note {get;set;} 
		public Object number_Z {get;set;} // in json: number
		public String phone_number {get;set;} 
		public String postal_code {get;set;} 
		public String province {get;set;} 
		public String street_address {get;set;} 

		public Delivery_address(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'address_description') {
							address_description = parser.getText();
						} else if (text == 'firstname') {
							firstname = parser.getText();
						} else if (text == 'lastname') {
							lastname = parser.getText();
						} else if (text == 'contact_person') {
							contact_person = parser.getText();
						} else if (text == 'street_address') {
							street_address = parser.getText();
						} else if (text == 'city') {
							city = parser.getText();
						} else if (text == 'postal_code') {
							postal_code = parser.getText();
						} else if (text == 'fax') {
							fax = parser.getText();
						} else if (text == 'country') {
							country = parser.getText();
						} else if (text == 'province') {
							province = parser.getText();
						} else if (text == 'county') {
							county = parser.getText();
						} else if (text == 'phone_number') {
							phone_number = parser.getText();
						} else if (text == 'email') {
							email = parser.getText();
						} else if (text == 'note') {
							note = parser.getText();
						} else if (text == 'number') {
							number_Z = parser.getText();
						} else if (text == 'delivery_terms') {
							delivery_terms = parser.getText();
						} else if (text == 'delivery_type') {
							delivery_type = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Delivery_address consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}

	public class Install_address {
		public String address_description {get;set;} 
		public String city {get;set;} 
		public String contact_person {get;set;} 
		public String country {get;set;} 
		public String county {get;set;} 
		public String email {get;set;} 
		public String fax {get;set;} 
		public String firstname {get;set;} 
		public String lastname {get;set;} 
		public String name {get;set;} 
		public String note {get;set;} 
		public String customer_number {get;set;} // in json: number
		public String phone_number {get;set;} 
		public String postal_code {get;set;} 
		public String province {get;set;} 
		public String street_address {get;set;} 
	public Install_address(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'address_description') {
						address_description = parser.getText();
					} else if (text == 'firstname') {
						firstname = parser.getText();
					} else if (text == 'lastname') {
						lastname = parser.getText();
					} else if (text == 'name') {
						name = parser.getText();
					} else if (text == 'contact_person') {
						contact_person = parser.getText();
					} else if (text == 'street_address') {
						street_address = parser.getText();
					} else if (text == 'city') {
						city = parser.getText();
					} else if (text == 'postal_code') {
						postal_code = parser.getText();
					} else if (text == 'fax') {
						fax = parser.getText();
					} else if (text == 'country') {
						country = parser.getText();
					} else if (text == 'province') {
						province = parser.getText();
					} else if (text == 'county') {
						county = parser.getText();
					} else if (text == 'phone_number') {
						phone_number = parser.getText();
					} else if (text == 'email') {
						email = parser.getText();
					} else if (text == 'note') {
						note = parser.getText();
					} else if (text == 'number') {
						customer_number = parser.getText();
					} else {
						System.debug(LoggingLevel.WARN, 'Install_address consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
}
	
	public class Project_category {
		public String category {get;set;} 
		public String cost {get;set;} 

		public Project_category(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'category') {
							category = parser.getText();
						} else if (text == 'cost') {
							cost = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Project_category consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
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
	
	public class Subproject_info {		
		public String subproject_category {get;set;} 
		public String subproject_chargeable {get;set;} 
		public String subproject_cost {get;set;} 
		public String subproject_group {get;set;} 
		public String subproject_number {get;set;} 
		public String subproject_ordertype {get;set;} 
		public String subproject_parentproject {get;set;} 

		public Subproject_info(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'subproject_number') {
							subproject_number = parser.getText();
						} else if (text == 'subproject_group') {
							subproject_group = parser.getText();
						} else if (text == 'subproject_category') {
							subproject_category = parser.getText();
						} else if (text == 'subproject_cost') {
							subproject_cost = parser.getText();
						} else if (text == 'subproject_ordertype') {
							subproject_ordertype = parser.getText();
						} else if (text == 'subproject_parentproject') {
							subproject_parentproject = parser.getText();
						} else if (text == 'subproject_chargeable') {
							subproject_chargeable = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Subproject_info consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	
	public class GroupRec {
		public String delivery_batch {get;set;} 
		public String delivery_batch_status {get;set;} 
		public String delivery_batch_receive_date {get;set;} 
		public String delivery_batch_delivery_date {get;set;} 
		public String group_attachment {get;set;} 
		public String AXconfiguration {get;set;} 
		public String group_name {get;set;} 
		public String pcs {get;set;} 
		public String structurenumber {get;set;} 
		public String originalstructurenumber {get;set;} 
		public String install_start_date {get;set;} 
		public String install_end_date {get;set;} 
		public String additional_deliverytime {get;set;} 
		public String process {get;set;} 
		public String product_code {get;set;} 
		public String storageid {get;set;} 
		public String packing_order {get;set;} 
		public String unit {get;set;} 
		public String line {get;set;} 
		public String floor {get;set;} 
		public String chargeable {get;set;} 
		public String sales_price {get;set;} 
		public String sproduct {get;set;} 
		public String sfreight {get;set;} 
		public String sinstall {get;set;} 
		public String sother {get;set;} 
		public String purchase_price {get;set;} 
		public String pproduct {get;set;} 
		public String pfreight {get;set;} 
		public String pinstall {get;set;} 
		public String pother {get;set;} 
		public String calculated_salesprice {get;set;} 
		public String factory_price {get;set;} 
		public String fproduct {get;set;} 
		public String ffreight {get;set;} 
		public String finstall {get;set;} 
		public String fother {get;set;} 
		public String contract_price {get;set;} 
		public String salestori_plan_name {get;set;} 
		public String glass_m2 {get;set;} 
		public String blinds_m2 {get;set;} 
		public String glass_pcs {get;set;} 
		public String product_length {get;set;} 
		public String group_weight {get;set;} 
		public Product_attributes product_attributes {get;set;} 
		public String installed {get;set;} 
		public OrderLine OrderLine {get;set;} 
		public AssemblyInstructions AssemblyInstructions {get;set;} 

		public GroupRec(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'delivery_batch') {
							delivery_batch = parser.getText();
						} else if (text == 'delivery_batch_status') {
							delivery_batch_status = parser.getText();
						} else if (text == 'delivery_batch_receive_date') {
							delivery_batch_receive_date = parser.getText();
						} else if (text == 'delivery_batch_delivery_date') {
							delivery_batch_delivery_date = parser.getText();
						} else if (text == 'group_attachment') {
							group_attachment = parser.getText();
						} else if (text == 'AXconfiguration') {
							AXconfiguration = parser.getText();
						} else if (text == 'group_name') {
							group_name = parser.getText();
						} else if (text == 'pcs') {
							pcs = parser.getText();
						} else if (text == 'structurenumber') {
							structurenumber = parser.getText();
						} else if (text == 'originalstructurenumber') {
							originalstructurenumber = parser.getText();
						} else if (text == 'install_start_date') {
							install_start_date = parser.getText();
						} else if (text == 'install_end_date') {
							install_end_date = parser.getText();
						} else if (text == 'additional_deliverytime') {
							additional_deliverytime = parser.getText();
						} else if (text == 'process') {
							process = parser.getText();
						} else if (text == 'product_code') {
							product_code = parser.getText();
						} else if (text == 'storageid') {
							storageid = parser.getText();
						} else if (text == 'packing_order') {
							packing_order = parser.getText();
						} else if (text == 'unit') {
							unit = parser.getText();
						} else if (text == 'line') {
							line = parser.getText();
						} else if (text == 'floor') {
							floor = parser.getText();
						} else if (text == 'chargeable') {
							chargeable = parser.getText();
						} else if (text == 'sales_price') {
							sales_price = parser.getText();
						} else if (text == 'sproduct') {
							sproduct = parser.getText();
						} else if (text == 'sfreight') {
							sfreight = parser.getText();
						} else if (text == 'sinstall') {
							sinstall = parser.getText();
						} else if (text == 'sother') {
							sother = parser.getText();
						} else if (text == 'purchase_price') {
							purchase_price = parser.getText();
						} else if (text == 'pproduct') {
							pproduct = parser.getText();
						} else if (text == 'pfreight') {
							pfreight = parser.getText();
						} else if (text == 'pinstall') {
							pinstall = parser.getText();
						} else if (text == 'pother') {
							pother = parser.getText();
						} else if (text == 'calculated_salesprice') {
							calculated_salesprice = parser.getText();
						} else if (text == 'factory_price') {
							factory_price = parser.getText();
						} else if (text == 'fproduct') {
							fproduct = parser.getText();
						} else if (text == 'ffreight') {
							ffreight = parser.getText();
						} else if (text == 'finstall') {
							finstall = parser.getText();
						} else if (text == 'fother') {
							fother = parser.getText();
						} else if (text == 'contract_price') {
							contract_price = parser.getText();
						} else if (text == 'salestori_plan_name') {
							salestori_plan_name = parser.getText();
						} else if (text == 'glass_m2') {
							glass_m2 = parser.getText();
						} else if (text == 'blinds_m2') {
							blinds_m2 = parser.getText();
						} else if (text == 'glass_pcs') {
							glass_pcs = parser.getText();
						} else if (text == 'product_length') {
							product_length = parser.getText();
						} else if (text == 'group_weight') {
							group_weight = parser.getText();
						} else if (text == 'product_attributes') {
							if (String.isNotBlank(parser.getText())){
								product_attributes = new Product_attributes(parser);
							}
						} else if (text == 'installed') {
							installed = parser.getText();
						} else if (text == 'OrderLine') {
							OrderLine = new OrderLine(parser);
						} else if (text == 'AssemblyInstructions') {
							AssemblyInstructions = new AssemblyInstructions(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'GroupRec consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	
	


		
	
	public class OrderLine {
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

		public OrderLine(JSONParser parser) {
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
							System.debug(LoggingLevel.WARN, 'OrderLine consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Groups {
		public List<GroupRec> groupList {get;set;} // in json: group

		public Groups(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'group') {
							groupList = arrayOfGroupRec(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Groups consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Budget {
		public List<Project_category> project_category {get;set;} 

		public Budget(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'project_category') {
							project_category = arrayOfProject_category(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Budget consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Order_info {
		public String axcompanyid {get;set;} 
		public Budget budget {get;set;} 
		public String business_unit {get;set;} 
		public String chargeable {get;set;} 
		public String currency_Z {get;set;} // in json: currency
		public Customer_address customer_address {get;set;} 
		public String customer_reference {get;set;} 
		public String customer_segmentid {get;set;} 
		public String customer_segmentname {get;set;} 
		public Delivery_address delivery_address {get;set;} 
		public String domestic_help {get;set;} 
		public String domestic_text {get;set;} 
		public Install_address install_address {get;set;} 
		public Invoice_address invoice_address {get;set;} 
		public String language_code {get;set;} 
		public String leadSource {get;set;}
		public String main_contractor {get;set;} 
		public String order_attachment {get;set;} 
		public String order_number {get;set;} 
		public String order_type {get;set;} 
		public String parent_project {get;set;} 
		public Pricelist pricelist {get;set;} 
		public String project_group {get;set;} 
		public String project_number {get;set;} 
		public String promised_date {get;set;} 
		public String promised_deliveryweek {get;set;} 
		public String propertytype {get;set;} 
		public Sales_person sales_person {get;set;} 
		public Subproject_info subproject_info {get;set;} 
		public String vendorid {get;set;} 
		public String worknumbername {get;set;} 


		public Order_info(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'axcompanyid') {
							axcompanyid = parser.getText();
						} else if (text == 'currency') {
							currency_Z = parser.getText();
						} else if (text == 'customer_reference') {
							customer_reference = parser.getText();
						} else if (text == 'order_type') {
							order_type = parser.getText();
						} else if (text == 'order_number') {
							order_number = parser.getText();
						} else if (text == 'vendorid') {
							vendorid = parser.getText();
						} else if (text == 'project_number') {
							project_number = parser.getText();
						} else if (text == 'parent_project') {
							parent_project = parser.getText();
						} else if (text == 'project_group') {
							project_group = parser.getText();
						} else if (text == 'customer_segmentid') {
							customer_segmentid = parser.getText();
						} else if (text == 'customer_segmentname') {
							customer_segmentname = parser.getText();
						} else if (text == 'promised_deliveryweek') {
							promised_deliveryweek = parser.getText();
						} else if (text == 'promised_date') {
							promised_date = parser.getText();
						} else if (text == 'main_contractor') {
							main_contractor = parser.getText();
						} else if (text == 'business_unit') {
							business_unit = parser.getText();
						} else if (text == 'order_attachment') {
							order_attachment = parser.getText();
						} else if (text == 'subproject_info') {
							subproject_info = new Subproject_info(parser);
						} else if (text == 'budget') {
							budget = new Budget(parser);
						} else if (text == 'domestic_help') {
							domestic_help = parser.getText();
						} else if (text == 'domestic_text') {
							domestic_text = parser.getText();
						} else if (text == 'chargeable') {
							chargeable = parser.getText();
						} else if (text == 'worknumbername') {
							worknumbername = parser.getText();
						} else if (text == 'pricelist') {
							pricelist = new Pricelist(parser);
						} else if (text == 'customer_address') {
							customer_address = new Customer_address(parser);
						} else if (text == 'invoice_address') {
							invoice_address = new Invoice_address(parser);
						} else if (text == 'install_address') {
							install_address = new Install_address(parser);
						} else if (text == 'delivery_address') {
							delivery_address = new Delivery_address(parser);
						} else if (text == 'sales_person') {
							sales_person = new Sales_person(parser);
						} else if (text == 'propertytype') {
							propertytype = parser.getText();
						} else if (text == 'language_code_lan') {
							language_code = parser.getText();
                        } else if (text == 'order_leadreference_vch'){
                            leadSource = parser.getText();
                        }
                        
                        else {
							System.debug(LoggingLevel.WARN, 'Order_info consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	public static InboundOrderData parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new InboundOrderData(parser);
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
	public class Sales_person {
		public String username {get;set;} 
		public String supervisor {get;set;} 
		public String firstname {get;set;} 
		public String lastname {get;set;} 

		public Sales_person(JSONParser parser) {
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
							System.debug(LoggingLevel.WARN, 'Sales_person consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
		
	public class AssemblyDocument {
		public String name {get;set;} 
		public List<Chapter> Chapter {get;set;} 

		public AssemblyDocument(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'name') {
							name = parser.getText();
						} else if (text == 'Chapter') {
							Chapter = arrayOfChapter(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'AssemblyDocument consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}

	public class AssemblyInstructions {
		public String InstallNotes {get;set;} 
		public Attachments Attachments {get;set;} 
		public List<AssemblyDocument> AssemblyDocument {get;set;} 

		public AssemblyInstructions(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'InstallNotes') {
							InstallNotes = parser.getText();
						} else if (text == 'Attachments') {
							Attachments = new Attachments(parser);
						} else if (text == 'AssemblyDocument') {
							AssemblyDocument = arrayOfAssemblyDocument(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'AssemblyInstructions consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
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
	public class Attachments {
		public String Attachment {get;set;} 
		public String Folder {get;set;} 

		public Attachments(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'Attachment') {
							Attachment = parser.getText();
						} else if (text == 'Folder') {
							Folder = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Attachments consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	private static List<Project_category> arrayOfProject_category(System.JSONParser p) {
        List<Project_category> res = new List<Project_category>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Project_category(p));
        }
        return res;
    }

    private static List<GroupRec> arrayOfGroupRec(System.JSONParser p) {
        List<GroupRec> res = new List<GroupRec>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new GroupRec(p));
        }
        return res;
    }


    private static List<AssemblyDocument> arrayOfAssemblyDocument(System.JSONParser p) {
        List<AssemblyDocument> res = new List<AssemblyDocument>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new AssemblyDocument(p));
        }
        return res;
    }
    
    private static List<Chapter> arrayOfChapter(System.JSONParser p) {
        List<Chapter> res = new List<Chapter>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Chapter(p));
        }
        return res;
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