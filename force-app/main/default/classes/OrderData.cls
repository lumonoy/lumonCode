/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 06-15-2024
 * @last modified by  : Henk Reynders
**/
public class OrderData {
	public Order orderRecord {get;set;}
	public Opportunity opportunityRecord {get;set;} 
	public OrderMessage orderMessage {get;set;}
	public OrderData(JSONParser parser) {
		System.debug('--- OrderData - Parse OrderData');
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'order') {
						orderMessage = new OrderMessage(parser);
					} else {
						System.debug(LoggingLevel.WARN, '--- OrderData - OrderData consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	public class OrderMessage  {
        public OrderDetails order_info {get;set;} 
        public DeliveryBatch batch {get;set;} 

        public OrderMessage(JSONParser parser) {
			System.debug('--- OrderData - Parse OrderMessage');
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'order_info') {
                            order_info = new OrderDetails(parser);
                        } else if (text == 'groups') {
                            batch = new DeliveryBatch(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'OrderMessage consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
	public class OrderDetails {
		public String axcompanyId {get;set;} 
		public Budget budget {get;set;} 
		public String business_unit {get;set;} 
		public String chargeable {get;set;} 
		public String currencyCode {get;set;} //currency in JSON
		public CustomerAddress customer_address {get;set;} 
		public String customer_reference {get;set;} 
		public String customer_segmentid {get;set;} 
		public String customer_segmentname {get;set;} 
		public DeliveryAddress delivery_address {get;set;} 
		public String domestic_help {get;set;} 
		public String domestic_text {get;set;} 
		public InstallationAddress install_address {get;set;} 
		public InvoicingAddress invoice_address {get;set;} 
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
		public SalesPerson sales_person {get;set;} 
		public Project Project_info {get;set;} 
		public String vendorid {get;set;} 
		public String worknumbername {get;set;} 


		public OrderDetails(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'worknumbername') {
							worknumbername = parser.getText();
						} else if (text == 'vendorid') {
							vendorid = parser.getText();
						} else if (text == 'Project_info') {
							Project_info = new Project(parser);
						} else if (text == 'sales_person') {
							sales_person = new SalesPerson(parser);
						} else if (text == 'promised_deliveryweek') {
							promised_deliveryweek = parser.getText();
						} else if (text == 'promised_date') {
							promised_date = parser.getText();
						} else if (text == 'project_number') {
							project_number = parser.getText();
						} else if (text == 'project_group') {
							project_group = parser.getText();
						} else if (text == 'pricelist') {
							pricelist = new Pricelist(parser);
						} else if (text == 'parent_project') {
							parent_project = parser.getText();
						} else if (text == 'order_type') {
							order_type = parser.getText();
						} else if (text == 'order_number') {
							order_number = parser.getText();
						} else if (text == 'order_attachment') {
							order_attachment = parser.getText();
						} else if (text == 'main_contractor') {
							main_contractor = parser.getText();
						} else if (text == 'invoice_address') {
							invoice_address = new InvoicingAddress(parser);
						} else if (text == 'install_address') {
							install_address = new InstallationAddress(parser);
						} else if (text == 'domestic_text') {
							domestic_text = parser.getText();
						} else if (text == 'domestic_help') {
							domestic_help = parser.getText();
						} else if (text == 'delivery_address') {
							delivery_address = new DeliveryAddress(parser);
						} else if (text == 'customer_segmentname') {
							customer_segmentname = parser.getText();
						} else if (text == 'customer_segmentid') {
							customer_segmentid = parser.getText();
						} else if (text == 'customer_reference') {
							customer_reference = parser.getText();
						} else if (text == 'customer_address') {
							customer_address = new CustomerAddress(parser);
						} else if (text == 'currency1') {
							currencyCode= parser.getText();
						} else if (text == 'chargeable') {
							chargeable = parser.getText();
						} else if (text == 'business_unit') {
							business_unit = parser.getText();
						} else if (text == 'budget') {
							budget = new Budget(parser);
						} else if (text == 'axcompanyId') {
							axcompanyId = parser.getText();
						} else if (text == 'propertytype') {
							propertytype = parser.getText();
						} else if (text == 'language_code_lan') {
							language_code = parser.getText();
                        } else if (text == 'order_leadreference_vch'){
                            leadSource = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Order_info consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	public class Project {
		public String Project_category {get;set;} 
		public String Project_chargeable {get;set;} 
		public String Project_cost {get;set;} 
		public String Project_group {get;set;} 
		public String Project_number {get;set;} 
		public String Project_ordertype {get;set;} 
		public String Project_parentproject {get;set;} 

		public Project(JSONParser parser) {
			System.debug('--- OrderData - Parse Project');
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'Project_parentproject') {
							Project_parentproject = parser.getText();
						} else if (text == 'Project_ordertype') {
							Project_ordertype = parser.getText();
						} else if (text == 'Project_number') {
							Project_number = parser.getText();
						} else if (text == 'Project_group') {
							Project_group = parser.getText();
						} else if (text == 'Project_cost') {
							Project_cost = parser.getText();
						} else if (text == 'Project_chargeable') {
							Project_chargeable = parser.getText();
						} else if (text == 'Project_category') {
							Project_category = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Project consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	public class SalesPerson {
		public String username {get;set;} 
		public String supervisor {get;set;} 
		public String firstname {get;set;} 
		public String lastname {get;set;} 

		public Id salesPersonId {get;set;} 
		public Id superVisorId {get;set;} 

		public SalesPerson(JSONParser parser) {
			System.debug('--- OrderData - Parse SalesPerson');
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
							System.debug(LoggingLevel.WARN, 'SalesPerson consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}

	public class CustomerAddress {
		public Id accountId {get;set;} 
		public String address_description {get;set;} 
		public String city {get;set;} 
		public String contact_person {get;set;} 
		public String country {get;set;} 
		public String county {get;set;} 
		public String customerId {get;set;} 
		public String customerName {get;set;} 
		public String customerNumber {get;set;} // in json: number
		public String email {get;set;} 
		public String fax {get;set;} 
		public String firstname {get;set;} 
		public String lastname {get;set;} 
		public String note {get;set;}
		public String number1 {get;set;} // customer Number
		public String phone_number {get;set;} 
		public String postal_code {get;set;} 
		public String province {get;set;} 
		public String street_address {get;set;} 

		public CustomerAddress(JSONParser parser) {
			System.debug('--- OrderData - Parse Customer Address');
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'street_address') {
							street_address = parser.getText();
						} else if (text == 'province') {
							province = parser.getText();
						} else if (text == 'postal_code') {
							postal_code = parser.getText();
						} else if (text == 'phone_number') {
							phone_number = parser.getText();
						} else if (text == 'number1') {
							number1 = parser.getText();
						} else if (text == 'note') {
							note = parser.getText();
						} else if (text == 'lastname') {
							lastname = parser.getText();
						} else if (text == 'firstname') {
							firstname = parser.getText();
						} else if (text == 'fax') {
							fax = parser.getText();
						} else if (text == 'email') {
							email = parser.getText();
						} else if (text == 'customer_id') {
							customerId = parser.getText();
						} else if (text == 'customer_name') {
							customerName = parser.getText();
						} else if (text == 'county') {
							county = parser.getText();
						} else if (text == 'country') {
							country = parser.getText();
						} else if (text == 'contact_person') {
							contact_person = parser.getText();
						} else if (text == 'city') {
							city = parser.getText();
						} else if (text == 'address_description') {
							address_description = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'CustomerAddress consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class InvoicingAddress {
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
		public String number1 {get;set;} // in json: number
		public String payment {get;set;} 
		public String payment_terms {get;set;} 
		public String paytrail_reference_id {get;set;} 
		public String phone_number {get;set;} 
		public String postal_code {get;set;} 
		public String province {get;set;} 
		public String street_address {get;set;} 
		

		public InvoicingAddress(JSONParser parser) {
			System.debug('--- OrderData - Parse Invoicing Address');
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'street_address') {
							street_address = parser.getText();
						} else if (text == 'province') {
							province = parser.getText();
						} else if (text == 'postal_code') {
							postal_code = parser.getText();
						} else if (text == 'phone_number') {
							phone_number = parser.getText();
						} else if (text == 'paytrail_reference_id') {
							paytrail_reference_id = parser.getText();
						} else if (text == 'payment_terms') {
							payment_terms = parser.getText();
						} else if (text == 'payment') {
							payment = parser.getText();
						} else if (text == 'number1') {
							number1 = parser.getText();
						} else if (text == 'note') {
							note = parser.getText();
						} else if (text == 'lastname') {
							lastname = parser.getText();
						} else if (text == 'invoice_type') {
							invoice_type = parser.getText();
						} else if (text == 'firstname') {
							firstname = parser.getText();
						} else if (text == 'fax') {
							fax = parser.getText();
						} else if (text == 'email') {
							email = parser.getText();
						} else if (text == 'county') {
							county = parser.getText();
						} else if (text == 'country') {
							country = parser.getText();
						} else if (text == 'contact_person') {
							contact_person = parser.getText();
						} else if (text == 'city') {
							city = parser.getText();
						} else if (text == 'address_description') {
							address_description = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'InvoicingAddress consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class DeliveryAddress {
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
		public String number1 {get;set;} 
		public String phone_number {get;set;} 
		public String postal_code {get;set;} 
		public String province {get;set;} 
		public String street_address {get;set;} 	

		public DeliveryAddress(JSONParser parser) {
			System.debug('--- OrderData - Parse Delivery Address');
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'street_address') {
							street_address = parser.getText();
						} else if (text == 'province') {
							province = parser.getText();
						} else if (text == 'postal_code') {
							postal_code = parser.getText();
						} else if (text == 'phone_number') {
							phone_number = parser.getText();
						} else if (text == 'number1') {
							number1 = parser.getText();
						} else if (text == 'note') {
							note = parser.getText();
						} else if (text == 'lastname') {
							lastname = parser.getText();
						} else if (text == 'firstname') {
							firstname = parser.getText();
						} else if (text == 'fax') {
							fax = parser.getText();
						} else if (text == 'email') {
							email = parser.getText();
						} else if (text == 'delivery_type') {
							delivery_type = parser.getText();
						} else if (text == 'delivery_terms') {
							delivery_terms = parser.getText();
						} else if (text == 'county') {
							county = parser.getText();
						} else if (text == 'country') {
							country = parser.getText();
						} else if (text == 'contact_person') {
							contact_person = parser.getText();
						} else if (text == 'city') {
							city = parser.getText();
						} else if (text == 'address_description') {
							address_description = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'DeliveryAddress consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class InstallationAddress {
		public String address_description {get;set;} 
		public String city {get;set;} 
		public String contact_person {get;set;} 
		public String country {get;set;} 
		public String county {get;set;} 
		public String email {get;set;} 
		public String fax {get;set;} 
		public String firstname {get;set;} 
		public String lastname {get;set;} 
		//public String name {get;set;}
		public String note {get;set;} 
		public String number1 {get;set;} 
		public String phone_number {get;set;} 
		public String postal_code {get;set;} 
		public String province {get;set;} 
		public String street_address {get;set;} 


		public InstallationAddress(JSONParser parser) {
			System.debug('--- OrderData - Parse Installation Address');
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'street_address') {
							street_address = parser.getText();
						} else if (text == 'province') {
							province = parser.getText();
						} else if (text == 'postal_code') {
							postal_code = parser.getText();
						} else if (text == 'phone_number') {
							phone_number = parser.getText();
						} else if (text == 'number1') {
							number1 = parser.getText();
						} else if (text == 'note') {
							note = parser.getText();
						} else if (text == 'lastname') {
							lastname = parser.getText();
						} else if (text == 'firstname') {
							firstname = parser.getText();
						} else if (text == 'fax') {
							fax = parser.getText();
						} else if (text == 'email') {
							email = parser.getText();
						} else if (text == 'county') {
							county = parser.getText();
						} else if (text == 'country') {
							country = parser.getText();
						} else if (text == 'contact_person') {
							contact_person = parser.getText();
						} else if (text == 'city') {
							city = parser.getText();
						} else if (text == 'address_description') {
							address_description = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'InstallationAddress consuming unrecognized property: '+text);
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
			System.debug('--- OrderData - Parse Pricelist');
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


	public class Budget {
		public List<ProjectCost> project_category {get;set;} 

		public Budget(JSONParser parser) {
			System.debug('--- OrderData - Parse Budget');
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'project_category') {
							project_category = arrayOfProjectCost(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Budget consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class ProjectCost {
		public String category {get;set;}
		public String cost {get;set;}

		public ProjectCost(JSONParser parser) {
			System.debug('--- OrderData - Parse Project Cost');
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'category') {
							category = parser.getText();
						} else if (text == 'cost') {
							cost = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'ProjectCost consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}

	public class Structure {
		public List<Side> side {get;set;} 

		public Structure(JSONParser parser) {
			System.debug('--- OrderData - Parse Structure');
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'side') {
							side = arrayOfSide(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Sides consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}

	public class Side {
		public String upper_profilecolour {get;set;} 
		public String upper_profile {get;set;} 
		public String telescopic_profile {get;set;} 
		public String system_angle {get;set;} 
		public String StructureNumber {get;set;} 
		public String start_angle {get;set;} 
		public String side_weight {get;set;} 
		public String side_number {get;set;} 
		public String profile_length {get;set;} 
		public String plastic_colour {get;set;} 
		public String lower_profilecolour {get;set;} 
		public String lower_profile {get;set;} 
		public String glazing_length {get;set;} 
		public String glazing_height {get;set;} 
		public String glass_type {get;set;} 
		public String glass_thickness {get;set;} 
		public String glass_right_pcs {get;set;} 
		public String glass_left_pcs {get;set;} 
		public String end_angle {get;set;} 
		public String corner_bypass {get;set;} 

		public Side(JSONParser parser) {
			System.debug('--- OrderData - Parse Side');
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'upper_profilecolour') {
							upper_profilecolour = parser.getText();
						} else if (text == 'upper_profile') {
							upper_profile = parser.getText();
						} else if (text == 'telescopic_profile') {
							telescopic_profile = parser.getText();
						} else if (text == 'system_angle') {
							system_angle = String.valueOf(parser.getText());
						} else if (text == 'StructureNumber') {
							StructureNumber = parser.getText();
						} else if (text == 'start_angle') {
							start_angle = String.valueOf(parser.getText());
						} else if (text == 'side_weight') {
							side_weight = String.valueOf(parser.getText());
						} else if (text == 'side_number') {
							side_number = String.valueOf(parser.getText());
						} else if (text == 'profile_length') {
							profile_length = String.valueOf(parser.getText());
						} else if (text == 'plastic_colour') {
							plastic_colour = parser.getText();
						} else if (text == 'lower_profilecolour') {
							lower_profilecolour = parser.getText();
						} else if (text == 'lower_profile') {
							lower_profile = parser.getText();
						} else if (text == 'glazing_length') {
							glazing_length = String.valueOf(parser.getText());
						} else if (text == 'glazing_height') {
							glazing_height = String.valueOf(parser.getText());
						} else if (text == 'glass_type') {
							glass_type = parser.getText();
						} else if (text == 'glass_thickness') {
							glass_thickness = String.valueOf(parser.getText());
						} else if (text == 'glass_right_pcs') {
							glass_right_pcs = String.valueOf(parser.getText());
						} else if (text == 'glass_left_pcs') {
							glass_left_pcs = String.valueOf(parser.getText());
						} else if (text == 'end_angle') {
							end_angle = String.valueOf(parser.getText());
						} else if (text == 'corner_bypass') {
							corner_bypass = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Side consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class DeliveryBatch {
		public List<Product> product {get;set;} 

		public DeliveryBatch(JSONParser parser) {
			System.debug('--- OrderData - Parse Delivery Batch');
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'group') {
							product = arrayOfProduct(parser);
						} else if (text == 'group1') {
							product = arrayOfProduct(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'DeliveryBatch consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}

	public class Product {
		public String additional_deliverytime {get;set;} 
		public String AXconfiguration {get;set;} 
		public String blinds_m2 {get;set;} 
		public String calculated_salesprice {get;set;} 
		public String chargeable {get;set;} 
		public String contract_price {get;set;} 
		public String delivery_batch {get;set;} 
		public String delivery_batch_delivery_date {get;set;} 
		public String delivery_batch_receive_date {get;set;} 
		public String delivery_batch_status {get;set;} 
		public String factory_price {get;set;} 
		public String ffreight {get;set;} 
		public String finstall {get;set;} 
		public String floor {get;set;} 
		public String fother {get;set;} 
		public String fproduct {get;set;} 
		public String glass_m2 {get;set;} 
		public String glass_pcs {get;set;} 
		public String group_attachment {get;set;} 
		public String group_name {get;set;} 
		public String group_weight {get;set;} 
		public String install_end_date {get;set;} 
		public String install_start_date {get;set;} 
		public String installed {get;set;} 
		public String line {get;set;} 
		public String originalstructurenumber {get;set;} 
		public String packing_order {get;set;} 
		public String pcs {get;set;} 
		public String pfreight {get;set;} 
		public String pinstall {get;set;} 
		public String pother {get;set;} 
		public String pproduct {get;set;} 
		public String process {get;set;} 
		public Attribute product_attributes {get;set;} 
		public String product_code {get;set;} 
		public String product_length {get;set;} 
		public String purchase_price {get;set;} 
		public String sales_price {get;set;} 
		public String salestori_plan_name {get;set;} 
		public String sfreight {get;set;} 
		public Structure sides {get;set;} 
		public String sinstall {get;set;} 
		public String sother {get;set;} 
		public String sproduct {get;set;} 
		public String storageid {get;set;} 
		public String structurenumber {get;set;} 
		public String unit {get;set;} 		
		public WorkOrderLine OrderLine {get;set;} 
		public AssemblyInstructions AssemblyInstructions {get;set;} 

		public Product(JSONParser parser) {
			System.debug('--- OrderData - Parse Product');
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'unit') {
							unit = parser.getText();
						} else if (text == 'structurenumber') {
							structurenumber = parser.getText();
						} else if (text == 'storageid') {
							storageid = parser.getText();
						} else if (text == 'sproduct') {
							sproduct = String.valueOf(parser.getText());
						} else if (text == 'sother') {
							sother = String.valueOf(parser.getText());
						} else if (text == 'sinstall') {
							sinstall = String.valueOf(parser.getText());
						} else if (text == 'sides') {
							sides = new Structure(parser);
						} else if (text == 'sfreight') {
							sfreight = String.valueOf(parser.getText());
						} else if (text == 'salestori_plan_name') {
							salestori_plan_name = parser.getText();
						} else if (text == 'sales_price') {
							sales_price = String.valueOf(parser.getText());
						} else if (text == 'purchase_price') {
							purchase_price = String.valueOf(parser.getText());
						} else if (text == 'product_length') {
							product_length = String.valueOf(parser.getText());
						} else if (text == 'product_code') {
							product_code = parser.getText();
						} else if (text == 'product_attributes') {
							if (String.isNotBlank(parser.getText())){
								product_attributes = new Attribute(parser);
							}
						} else if (text == 'process') {
							process = parser.getText();
						} else if (text == 'pproduct') {
							pproduct = String.valueOf(parser.getText());
						} else if (text == 'pother') {
							pother = String.valueOf(parser.getText());
						} else if (text == 'pinstall') {
							pinstall = String.valueOf(parser.getText());
						} else if (text == 'pfreight') {
							pfreight = String.valueOf(parser.getText());
						} else if (text == 'pcs') {
							pcs = String.valueOf(parser.getText());
						} else if (text == 'packing_order') {
							packing_order = String.valueOf(parser.getText());
						} else if (text == 'originalstructurenumber') {
							originalstructurenumber = parser.getText();
						} else if (text == 'line') {
							line = parser.getText();
						} else if (text == 'installed') {
							installed = parser.getText();
						} else if (text == 'install_start_date') {
							install_start_date = parser.getText();
						} else if (text == 'install_end_date') {
							install_end_date = parser.getText();
						} else if (text == 'group_weight') {
							group_weight = String.valueOf(parser.getText());
						} else if (text == 'group_name') {
							group_name = parser.getText();
						} else if (text == 'group_attachment') {
							group_attachment = parser.getText();
						} else if (text == 'glass_pcs') {
							glass_pcs = String.valueOf(parser.getText());
						} else if (text == 'glass_m2') {
							glass_m2 = String.valueOf(parser.getText());
						} else if (text == 'fproduct') {
							fproduct = String.valueOf(parser.getText());
						} else if (text == 'fother') {
							fother = String.valueOf(parser.getText());
						} else if (text == 'floor') {
							floor = parser.getText();
						} else if (text == 'finstall') {
							finstall = String.valueOf(parser.getText());
						} else if (text == 'ffreight') {
							ffreight = String.valueOf(parser.getText());
						} else if (text == 'factory_price') {
							factory_price = String.valueOf(parser.getText());
						} else if (text == 'delivery_batch_status') {
							delivery_batch_status = parser.getText();
						} else if (text == 'delivery_batch_receive_date') {
							delivery_batch_receive_date = parser.getText();
						} else if (text == 'delivery_batch_delivery_date') {
							delivery_batch_delivery_date = parser.getText();
						} else if (text == 'delivery_batch') {
							delivery_batch = String.valueOf(parser.getText());
						} else if (text == 'contract_price') {
							contract_price = String.valueOf(parser.getText());
						} else if (text == 'chargeable') {
							chargeable = parser.getText();
						} else if (text == 'calculated_salesprice') {
							calculated_salesprice = String.valueOf(parser.getText());
						} else if (text == 'blinds_m2') {
							blinds_m2 = String.valueOf(parser.getText());
						} else if (text == 'AXconfiguration') {
							AXconfiguration = parser.getText();
						} else if (text == 'additional_deliverytime') {
							additional_deliverytime = String.valueOf(parser.getText());
						} else {
							System.debug(LoggingLevel.WARN, 'ItemRequirement consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	public class WorkOrderLine {
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

		public WorkOrderLine(JSONParser parser) {
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
							System.debug(LoggingLevel.WARN, 'WorkOrderLine consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	public class Attribute {
		public String attributeid {get;set;} 

		public Attribute(JSONParser parser) {
			System.debug('--- OrderData - Parse Attribute');
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'attributeid') {
							attributeid = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Attribute consuming unrecognized property: '+text);
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
			System.debug('--- OrderData - Parse Document');
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
			System.debug('--- OrderData - Parse Instructions');
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
			System.debug('--- OrderData - Parse Paragraph');
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
			System.debug('--- OrderData - Parse Chapter');
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
			System.debug('--- OrderData - Parse Attachment');
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
	
    private static List<ProjectCost> arrayOfProjectCost(System.JSONParser p) {
        List<ProjectCost> res = new List<ProjectCost>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new ProjectCost(p));
        }
        return res;
    }

    private static List<Product> arrayOfProduct(System.JSONParser p) {
        List<Product> res = new List<Product>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Product(p));
        }
        return res;
    }

    private static List<Side> arrayOfSide(System.JSONParser p) {
        List<Side> res = new List<Side>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Side(p));
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
	private static List<Paragraph> arrayOfParagraph(System.JSONParser p) {
        List<Paragraph> res = new List<Paragraph>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Paragraph(p));
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

	public static OrderData parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new OrderData(parser);
	}
	
	public static void consumeObject(System.JSONParser parser) {
		Integer depth = 0;
		do {
			System.JSONToken curr = parser.getCurrentToken();
			if (curr == System.JSONToken.START_OBJECT || 
				curr == System.JSONToken.START_ARRAY) {
				depth++;
				System.debug('--- OrderData - Level '+depth);
			} else if (curr == System.JSONToken.END_OBJECT ||
				curr == System.JSONToken.END_ARRAY) {
				depth--;
				System.debug('--- OrderData - Level '+depth);
			}
		} while (depth > 0 && parser.nextToken() != null);
	}
}