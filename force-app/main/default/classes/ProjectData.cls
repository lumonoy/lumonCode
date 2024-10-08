/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 08-25-2024
 * @last modified by  : Henk Reynders
**/
public class ProjectData {
	public OrderMessage orderMessage {get;set;}	
	public class OrderMessage  {
        public CustomerProject project {get;set;} 
        public DeliveryBatch delivery {get;set;} 

        public OrderMessage(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'order_info') {
                            project = new CustomerProject(parser);
                        } else if (text == 'groups') {
                            delivery = new DeliveryBatch(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'OrderMessage consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
	public ProjectData(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'order') {
						orderMessage = new OrderMessage(parser);
					} else {
						System.debug(LoggingLevel.WARN, '--- ProjectData - ProjectData consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	public static ProjectData parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new ProjectData(parser);
	}	
	public static void consumeObject(System.JSONParser parser) {
		Integer depth = 0;
		do {
			System.JSONToken curr = parser.getCurrentToken();
			if (curr == System.JSONToken.START_OBJECT || 
				curr == System.JSONToken.START_ARRAY) {
				depth++;
				System.debug('--- ProjectData - Level '+depth);
			} else if (curr == System.JSONToken.END_OBJECT ||
				curr == System.JSONToken.END_ARRAY) {
				depth--;
				System.debug('--- ProjectData - Level '+depth);
			}
		} while (depth > 0 && parser.nextToken() != null);
	}
	public class CustomerProject {
		// main Project
		public String projectType {get;set;} 
		public String projectNumber {get;set;} 
		public String mainProject {get;set;} 
		public SubProject subProject {get;set;} 

		public String customerNumber {get;set;} 
		public Budget budget {get;set;} 
		public String profitCenterCode {get;set;} 
		public String chargeable {get;set;} 
		public String currencyCode {get;set;} //currency in JSON
		public CustomerAddress customerAddress {get;set;} 
		public String customerReference {get;set;} 
		public String customerSegmentCode {get;set;} 
		public String customerSegment {get;set;} 
		public DeliveryAddress deliveryAddress {get;set;} 
		public String domesticHelp {get;set;} 
		public String domesticText {get;set;} 
		public InstallationAddress installationAddress {get;set;} 
		public InvoicingAddress invoicingAddress {get;set;} 
		public String languageCode {get;set;} 
		public String leadSource {get;set;}
		public String contractor {get;set;} 
		public String offerNumber {get;set;} 
		public String offerAttachment {get;set;} 
		public String orderType {get;set;} 
		
		public String organizationCode {get;set;}
		public Pricelist pricelist {get;set;} 
		
		public String deliveryDate {get;set;} 
		public String deliveryweek {get;set;} 
		public String propertyType {get;set;} 
		public SalesPerson salesPerson {get;set;} 
		
		public String factoryCode {get;set;} 
		public String worknumbername {get;set;} 


		public CustomerProject(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						// Identifiers
						if (text == 'worknumbername') {
							worknumbername = parser.getText();
						// Project
						} else if (text == 'parent_project') {
							mainProject = parser.getText();
						} else if (text == 'project_group') {
							projectType = parser.getText();
						} else if (text == 'project_number') {
							projectNumber = parser.getText();
						} else if (text == 'subproject_info') {
							subProject = new SubProject(parser);
						// Business Attributes
						} else if (text == 'axcompanyId') {
							organizationCode = parser.getText();
 						} else if (text == 'vendorid') {
							factoryCode = parser.getText();
						} else if (text == 'business_unit') {
							profitCenterCode = parser.getText();
						
						} else if (text == 'sales_person') {
							salesPerson = new SalesPerson(parser);
						} else if (text == 'customer_reference') {
							customerReference = parser.getText();

						// Invoicing
						} else if (text == 'currency') {
							currencyCode= parser.getText();
						} else if (text == 'chargeable') {
							chargeable = parser.getText();
						} else if (text == 'pricelist') {
							pricelist = new Pricelist(parser);
						} else if (text == 'budget') {
							budget = new Budget(parser);
						// Business Attributes
						
						} else if (text == 'propertytype') {
							propertyType = parser.getText();
						} else if (text == 'customer_segmentname') {
							customerSegment = parser.getText();
						} else if (text == 'customer_segmentid') {
							customerSegmentCode = parser.getText();
						// Offer
						} else if (text == 'order_number') {
							offerNumber = parser.getText();
						// Order
						} else if (text == 'order_type') {
							orderType = parser.getText();
						} else if (text == 'order_attachment') {
							offerAttachment = parser.getText();						
						// Delivery
						} else if (text == 'promised_deliveryweek') {
							deliveryWeek = parser.getText();
						} else if (text == 'promised_date') {
							deliveryDate = parser.getText();
						} else if (text == 'main_contractor') {
							contractor = parser.getText();


						// Addresses
						} else if (text == 'customer_address') {
							customerAddress = new CustomerAddress(parser);
						} else if (text == 'invoice_address') {
							invoicingAddress = new InvoicingAddress(parser);
						} else if (text == 'install_address') {
							installationAddress = new InstallationAddress(parser);
						} else if (text == 'delivery_address') {
							deliveryAddress = new DeliveryAddress(parser);

						
						// Other
						} else if (text == 'language_code_lan') {
							languageCode = parser.getText();
                        } else if (text == 'order_leadreference_vch'){
                            leadSource = parser.getText();

						} else if (text == 'domestic_text') {
							domesticText = parser.getText();
						} else if (text == 'domestic_help') {
							domesticHelp = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Order_info consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	public class SubProject {
		public String projectCategory {get;set;} //"subproject_category": "Warranty",
		public String chargeable {get;set;} //"subproject_chargeable": "non-chargeable"
		public String projectCost {get;set;} //"subproject_cost": "296.90",
		public String projectType {get;set;} //"subproject_group": "PROWar",
		public String projectNumber {get;set;} //"subproject_number": "803086_01",
		public String orderType {get;set;} //"subproject_orderType": "Reclamation",
		public String mainProject {get;set;} //"subproject_parentproject": "803086",
		
		public SubProject(JSONParser parser) {
			System.debug('--- ProjectData - Parse Project');
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'subproject_parentproject') {
							mainProject = parser.getText();
						} else if (text == 'subproject_orderType') {
							orderType = parser.getText();
						} else if (text == 'subproject_number') {
							projectNumber = parser.getText();
						} else if (text == 'subproject_group') {
							projectType = parser.getText();
						} else if (text == 'subproject_cost') {
							projectCost = parser.getText();
						} else if (text == 'subproject_chargeable') {
							chargeable = parser.getText();
						} else if (text == 'subproject_category') {
							projectCategory = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'SubProject consuming unrecognized property: '+text);
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
			System.debug('--- ProjectData - Parse SalesPerson');
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
		public String customerNumber {get;set;} // in json: number
		public String customerDescription {get;set;} 
		// Identifiers
		public String customerId {get;set;} 
		public String projectName {get;set;} 
		// Contact 
		public String contactPerson {get;set;} 		
		public String contactFirstName {get;set;} 
		public String contactLastName {get;set;} 
		public String contactPhone {get;set;} 		
		public String contactEmail {get;set;}
		public String contactFax {get;set;} 
		public String customerNote {get;set;} 
		// Customer Address
		public String customerProvince {get;set;} 
		public String customerStreet {get;set;}
		public String customerPostalCode {get;set;}  
		public String customerCity {get;set;} 
		public String customerCounty {get;set;} 
		public String customerCountry {get;set;} 
		

		public CustomerAddress(JSONParser parser) {
			System.debug('--- ProjectData - Parse Customer Address');
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'street_address') {
							customerStreet = parser.getText();
						} else if (text == 'province') {
							customerProvince = parser.getText();
						} else if (text == 'postal_code') {
							customerPostalCode = parser.getText();
						} else if (text == 'phone_number') {
							contactPhone = parser.getText();
						} else if (text == 'number') {
							customerNumber = parser.getText();
						} else if (text == 'note') {
							customerNote = parser.getText();
						} else if (text == 'lastname') {
							contactLastName = parser.getText();
						} else if (text == 'firstname') {
							contactFirstName = parser.getText();
						} else if (text == 'fax') {
							contactFax = parser.getText();
						} else if (text == 'email') {
							contactEmail = parser.getText();
						} else if (text == 'customer_id') {
							customerId = parser.getText();
						} else if (text == 'customer_name') {
							projectName = parser.getText();
						} else if (text == 'county') {
							customerCounty = parser.getText();
						} else if (text == 'country') {
							customerCountry = parser.getText();
						} else if (text == 'contact_person') {
							contactPerson = parser.getText();
						} else if (text == 'city') {
							customerCity = parser.getText();
						} else if (text == 'address_description') {
							customerDescription = parser.getText();
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
		// Account
		public String customerNumber {get;set;} // in json: number
		public String description {get;set;} 		
		// Contact 
		public String contactPerson {get;set;} 		
		public String contactFirstName {get;set;} 
		public String contactLastName {get;set;} 
		public String contactPhone {get;set;} 		
		public String contactEmail {get;set;}
		public String contactFax {get;set;} 
		// Address
		public String invoicingStreet {get;set;} 
		public String invoicingPostalCode {get;set;} 
		public String invoicingCity {get;set;}
		public String invoicingCounty {get;set;}
		public String invoicingProvince {get;set;} 
		public String invoicingCountry {get;set;} 
		// Invoicing
		public String invoicingType {get;set;} 
		
		public String invoicingNote {get;set;}
		public String paymentMethod {get;set;} 
		public String paymentTerms {get;set;} 
		public String financingReference {get;set;} 

		public InvoicingAddress(JSONParser parser) {
			System.debug('--- ProjectData - Parse Invoicing Address');
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'street_address') {
							invoicingStreet = parser.getText();
						} else if (text == 'province') {
							invoicingProvince = parser.getText();
						} else if (text == 'postal_code') {
							invoicingPostalCode = parser.getText();
						} else if (text == 'phone_number') {
							contactPhone = parser.getText();
						} else if (text == 'paytrail_reference_id') {
							financingReference = parser.getText();
						} else if (text == 'payment_terms') {
							paymentTerms = parser.getText();
						} else if (text == 'payment') {
							paymentMethod = parser.getText();
						} else if (text == 'number') {
							customerNumber = parser.getText();
						} else if (text == 'note') {
							invoicingNote = parser.getText();
						} else if (text == 'lastname') {
							contactLastName = parser.getText();
						} else if (text == 'invoice_type') {
							invoicingType = parser.getText();
						} else if (text == 'firstname') {
							contactFirstName = parser.getText();
						} else if (text == 'fax') {
							contactFax = parser.getText();
						} else if (text == 'email') {
							contactEmail = parser.getText();
						} else if (text == 'county') {
							invoicingCounty = parser.getText();
						} else if (text == 'country') {
							invoicingCountry = parser.getText();
						} else if (text == 'contact_person') {
							contactPerson = parser.getText();
						} else if (text == 'city') {
							invoicingCity = parser.getText();
						} else if (text == 'address_description') {
							description = parser.getText();
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
		public String description {get;set;} 
				
		//Account and Contact
		public String customerNumber {get;set;} 
		public String contactFirstName {get;set;} 
		public String contactLastName {get;set;} 
		public String contactPerson {get;set;} 
		public String contactPhone {get;set;} 
		public String contactEmail {get;set;}
		public String contactFax {get;set;} 
		//Address
		public String deliveryStreet {get;set;} 
		public String deliveryPostalCode {get;set;} 	
		public String deliveryCity {get;set;} 
		public String deliveryCounty {get;set;} 
		public String deliveryProvince {get;set;}
		public String deliveryCountry {get;set;} 
		// Delivery
		public String deliveryNote {get;set;} 
		public String deliveryTerms {get;set;} 
		public String deliveryType {get;set;} 
		
		public DeliveryAddress(JSONParser parser) {
			System.debug('--- ProjectData - Parse Delivery Address');
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'street_address') {
							deliveryStreet = parser.getText();
						} else if (text == 'province') {
							deliveryProvince = parser.getText();
						} else if (text == 'postal_code') {
							deliveryPostalCode = parser.getText();
						} else if (text == 'phone_number') {
							contactPhone = parser.getText();
						} else if (text == 'number1') {
							customerNumber = parser.getText();
						} else if (text == 'number') {
							customerNumber = parser.getText();
						} else if (text == 'note') {
							deliveryNote = parser.getText();
						} else if (text == 'lastname') {
							contactLastName = parser.getText();
						} else if (text == 'firstname') {
							contactFirstName = parser.getText();
						} else if (text == 'fax') {
							contactFax = parser.getText();
						} else if (text == 'email') {
							contactEmail = parser.getText();
						} else if (text == 'delivery_type') {
							deliveryType = parser.getText();
						} else if (text == 'delivery_terms') {
							deliveryTerms = parser.getText();
						} else if (text == 'county') {
							deliveryCounty = parser.getText();
						} else if (text == 'country') {
							deliveryCountry = parser.getText();
						} else if (text == 'contact_person') {
							contactPerson = parser.getText();
						} else if (text == 'city') {
							deliveryCity = parser.getText();
						} else if (text == 'address_description') {
							description = parser.getText();
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
		public String contactName {get;set;}
		public String description {get;set;} 
		public String customerNumber {get;set;} 
		public String contactPerson {get;set;} 
		public String contactFirstname {get;set;} 
		public String contactLastname {get;set;} 
		public String contactPhone {get;set;} 
		public String contactEmail {get;set;} 
		public String contactFax {get;set;}
		
		public String installationNote {get;set;} 		
		public String installationStreet {get;set;} 
		public String installationPostalCode {get;set;} 
		public String installationCity {get;set;} 
		public String installationCounty {get;set;}
		public String installationProvince {get;set;} 
		public String installationCountry {get;set;} 

		public InstallationAddress(JSONParser parser) {
			System.debug('--- ProjectData - Parse Installation Address');
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'street_address') {
							installationStreet = parser.getText();
						} else if (text == 'province') {
							installationProvince = parser.getText();
						} else if (text == 'postal_code') {
							installationPostalCode = parser.getText();
						} else if (text == 'phone_number') {
							contactPhone = parser.getText();
						} else if (text == 'number') {
							customerNumber = parser.getText();
						} else if (text == 'note') {
							installationNote = parser.getText();
						} else if (text == 'lastname') {
							contactLastname = parser.getText();
						} else if (text == 'firstname') {
							contactFirstname = parser.getText();
						} else if (text == 'name') {
							contactName = parser.getText();
						} else if (text == 'fax') {
							contactFax = parser.getText();
						} else if (text == 'email') {
							contactEmail = parser.getText();
						} else if (text == 'county') {
							installationCounty = parser.getText();
						} else if (text == 'country') {
							installationCountry = parser.getText();
						} else if (text == 'contact_person') {
							contactPerson = parser.getText();
						} else if (text == 'city') {
							installationCity = parser.getText();
						} else if (text == 'address_description') {
							description = parser.getText();
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
			System.debug('--- ProjectData - Parse Pricelist');
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
			System.debug('--- ProjectData - Parse Budget');
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
			System.debug('--- ProjectData - Parse Project Cost');
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
			System.debug('--- ProjectData - Parse Structure');
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
		public String upperProfileColour {get;set;} 
		public String upperProfile {get;set;} 
		public String telescopicProfile {get;set;} 
		public String systemAngle {get;set;} 
		public String StructureNumber {get;set;} 
		public String startAngle {get;set;} 
		public String sideWeight {get;set;} 
		public String sideNumber {get;set;} 
		public String profileLength {get;set;} 
		public String plasticColour {get;set;} 
		public String lowerProfilecolour {get;set;} 
		public String lowerProfile {get;set;} 
		public String glazingLength {get;set;} 
		public String glazingHeight {get;set;} 
		public String glassType {get;set;} 
		public String glassThickness {get;set;} 
		public String glassRightAmount {get;set;} 
		public String glassLeftAmount {get;set;} 
		public String endAngle {get;set;} 
		public String cornerBypass {get;set;} 

		public Side(JSONParser parser) {
			System.debug('--- ProjectData - Parse Side');
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'upperProfilecolour') {
							upperProfileColour = parser.getText();
						} else if (text == 'upperProfile') {
							upperProfile = parser.getText();
						} else if (text == 'telescopicProfile') {
							telescopicProfile = parser.getText();
						} else if (text == 'systemAngle') {
							systemAngle = String.valueOf(parser.getText());
						} else if (text == 'StructureNumber') {
							StructureNumber = parser.getText();
						} else if (text == 'startAngle') {
							startAngle = String.valueOf(parser.getText());
						} else if (text == 'side_weight') {
							sideWeight = String.valueOf(parser.getText());
						} else if (text == 'side_number') {
							sideNumber = String.valueOf(parser.getText());
						} else if (text == 'profile_length') {
							profileLength = String.valueOf(parser.getText());
						} else if (text == 'plastic_colour') {
							plasticColour = parser.getText();
						} else if (text == 'lowerProfilecolour') {
							lowerProfilecolour = parser.getText();
						} else if (text == 'lowerProfile') {
							lowerProfile = parser.getText();
						} else if (text == 'glazing_length') {
							glazingLength = String.valueOf(parser.getText());
						} else if (text == 'glazing_height') {
							glazingHeight = String.valueOf(parser.getText());
						} else if (text == 'glass_type') {
							glassType = parser.getText();
						} else if (text == 'glass_thickness') {
							glassThickness = String.valueOf(parser.getText());
						} else if (text == 'glass_right_pcs') {
							glassRightAmount = String.valueOf(parser.getText());
						} else if (text == 'glass_left_pcs') {
							glassLeftAmount = String.valueOf(parser.getText());
						} else if (text == 'endAngle') {
							endAngle = String.valueOf(parser.getText());
						} else if (text == 'corner_bypass') {
							cornerBypass = parser.getText();
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
		public List<LineItem> products {get;set;} 

		public DeliveryBatch(JSONParser parser) {
			System.debug('--- ProjectData - Parse Delivery Batch');
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'group') {
							if (String.isNotBlank(parser.getText())){
								products = arrayOfLineItem(parser);
							}
						} else if (text == 'group1') {
							if (String.isNotBlank(parser.getText())){
								products = arrayOfLineItem(parser);
							}
						} else {
							System.debug(LoggingLevel.WARN, 'DeliveryBatch consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}

	public class LineItem {

		public Id productId {get;set;} // Product2 reference

		// Asset	
		public Asset asset {get;set;}
		public Id assetId {get;set;}	
		public String serialNumber {get;set;} // Salestori RVN - "structurenumber": "9000780830016987",
		public String originalRVN {get;set;} // If cloned or reclamation - "originalstructurenumber": "",
		public String productName {get;set;} // Salestori Name of Product - "group_name": "Lumon Kiinteä seinä (uusi)",
		public String productCode {get;set;} // Salestori Sales Code - "product_code": "90400001",		
		public String quantity {get;set;} // Asset Quantity always 1 -		"pcs": "1",

		
		
		// Parent Asset 
		public Asset planAsset {get;set;}
		public Id planAssetId {get;set;}	
		public String planName {get;set;} // parent Asset - "salestori_plan_name": "Plan 2",
		public String floor {get;set;} // parent Asset - "floor": "",
		public String line {get;set;}  // parent Asset - "line": "",
		public String unit {get;set;} // parent Asset - "unit": "",

		/*
		"chargeable": "chargeable",
					"sales_price": "797.30",
					"sproduct": "290.70",
					"sfreight": "240.60",
					"sinstall": "204.20",
					"sother": "61.80",
					"purchase_price": "290.70",
					"pproduct": "290.70",
					"pfreight": "0.00",
					"pinstall": "0.00",
					"pother": "0.00",
					"calculated_salesprice": "797.30",
					"factory_price": "290.70",
					"fproduct": "290.70",
					"ffreight": "0.00",
					"finstall": "0.00",
					"fother": "0.00",
					"contract_price": "71.46",*/
		// Factory Price
		public String factoryPrice {get;set;} 
		public String ffreight {get;set;} 
		public String finstall {get;set;} 		
		public String fother {get;set;} 
		public String fproduct {get;set;} 
		// Asset Cost
		public String purchasePrice {get;set;} 
		public String pfreight {get;set;} 
		public String pinstall {get;set;} 
		public String pother {get;set;} 
		public String pproduct {get;set;} 
		// Sales Price
		public String salesPrice {get;set;} 
		public String sfreight {get;set;} 
		public String sinstall {get;set;} 
		public String sother {get;set;} 
		public String sproduct {get;set;} 

		// Order ORDER
		public String contractedPrice {get;set;} 
		public String listPrice {get;set;} 
		public String chargeable {get;set;} 		
		public String batchNumber {get;set;} //custom Field - "delivery_batch": "1",
		public String deliveryDate {get;set;} // custom Field - "delivery_batch_delivery_date": "25.09.2024",
		public String promisedDate {get;set;} // Custom Field Customer expected completion Date "DeliveryDatePromised": "04.10.2024",
		public String installDate {get;set;}  // Installation completed Date
		public String purchaseDate {get;set;} // Salestori Order Date = when batch is ordered 		"delivery_batch_receive_date": "30.09.2024",
		public String batchStatus {get;set;} // "delivery_batch_status": "Mitattu",
		
		// Delivery ORDERLINE
		public OrderItem orderLine {get;set;} 
		public Id orderLineItemId {get;set;} 
		public String extraDeliveryTime {get;set;} //"additional_deliverytime": "0",
		public String isAXconfiguration {get;set;} //"AXconfiguration": "no",
		public String packingOrder {get;set;} //"packing_order": "1",
		public String orderType {get;set;} //"process": "Normal",
		public String warehouseCode {get;set;} // "storageid": "VAN",
		public String specialOrder {get;set;} //"process": "Normal",


		//Work WORKORDER
		public WorkOrder workOrder {get;set;} 
		public Id workOrderId {get;set;} 
		public String installationManager {get;set;} 
		//Installation WORKORDERLINE
		public WorkOrderLine workOrderLine {get;set;} 
		public Id workOrderLineItemId {get;set;} 
		public String installationEnd {get;set;} // WorkOrderLineItem "install_end_date": "04.10.2024",
		public String installationStart {get;set;} // WorkOrderLineItem	"install_start_date": "30.09.2024",
		public String hasInstallation {get;set;} //		"installed": "True",

		/*"OrderLine": {
			"BOMVersion": "9000780830016987", => RVN SerialNumber
			"ItemID": "90400001", => ProductCode
			"ItemName": "LFIXEDWALL", => Is Group Attribute of Product
			"InventLocationID": "VAN", => WarehouseCode
			"Dimension1": "401", => Business Unit Profit Center
			"Dimension5": "mikaj", => Supervisor Installation Manager
			"DeliveryName": "Test FS Jukka Integration 20.8 Jukka", => Building Asset Name Address
			"DeliveryStreet": "Tahkotie 6 Jukka", => Building Asset Name Address
			"DeliveryZipCode": "01740", => Building Asset Name Address
			"DeliveryCity": "VANTAA", => Building Asset Name Address
			"DeliveryCountryRegionID": "FI", => Building Asset Name Address
			"LineAmount": "797.30",
			"Apartment": "",  => Apartment Asset Name Address
			"Floor": "", => Apartment Asset Name Address
			"DlvBatchID": "0", => WorkOrder Sequence
			"Line": "", => Apartment Asset Name Address
			"FactoryConfirmedDlv": "", => Unused Manufacture Date on asset
			"InstallHours": "0.00", => workOrderLineItem plannedInstallationTime
			"InstallStart": "30.09.2024", => workOrderLineItem plannedInstallationTime
			"ReservationStart": "2024-09-30T00.00.00", ==> serviceAppointment
			"DeliveryDatePromised": "04.10.2024", => expected Completion
			"Plan_name": "Plan 2", => plan Assset?
			"PieceWork_pay": "71.46" => workorderline
		*/
		/*"AssemblyInstructions": {
						"InstallNotes": "",
						"Attachments": {
							"Attachment": "salestori-asennuskortti-9000780830016895.pdf",
							"Folder": "\\270000\\270020\\"
						},*/
		public AssemblyInstructions instructions {get;set;} 
		
		// Product Attributes
		public Attribute productAttributes {get;set;} 
		public String productLength {get;set;} 
		public String productWeight {get;set;} 
		public String blindsSurface {get;set;} 
		public String glassSurface {get;set;} 
		public String glassAmount {get;set;} 
		public String attachment {get;set;} 

		// Structure
		public Structure sides {get;set;} 

		//Not Used 
		//"group_attachment": "",
		//"product_attributes": {"attributeid": "20090016"},

		public LineItem(JSONParser parser) {
			System.debug('--- ProjectData - Parse LineItem');
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'unit') {
							unit = parser.getText();
						} else if (text == 'structurenumber') {
							serialNumber = parser.getText();
						} else if (text == 'storageid') {
							warehouseCode = parser.getText();
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
							planName = parser.getText();
						} else if (text == 'sales_price') {
							salesPrice = String.valueOf(parser.getText());
						} else if (text == 'purchase_price') {
							purchasePrice = String.valueOf(parser.getText());
						} else if (text == 'product_length') {
							productLength = String.valueOf(parser.getText());
						} else if (text == 'product_code') {
							productCode = parser.getText();
						} else if (text == 'product_attributes') {
							if (String.isNotBlank(parser.getText())){
								productAttributes = new Attribute(parser);
							}
						} else if (text == 'process') {
							orderType = parser.getText();
						} else if (text == 'pproduct') {
							pproduct = String.valueOf(parser.getText());
						} else if (text == 'pother') {
							pother = String.valueOf(parser.getText());
						} else if (text == 'pinstall') {
							pinstall = String.valueOf(parser.getText());
						} else if (text == 'pfreight') {
							pfreight = String.valueOf(parser.getText());
						} else if (text == 'pcs') {
							quantity = String.valueOf(parser.getText());
						} else if (text == 'packing_order') {
							packingOrder = String.valueOf(parser.getText());
						} else if (text == 'originalstructurenumber') {
							originalRVN = parser.getText();
						} else if (text == 'line') {
							line = parser.getText();
						} else if (text == 'installed') {
							hasInstallation = parser.getText();
						} else if (text == 'install_start_date') {
							installationStart = parser.getText();
						} else if (text == 'install_end_date') {
							installationEnd = parser.getText();
						} else if (text == 'group_weight') {
							productWeight = String.valueOf(parser.getText());
						} else if (text == 'group_name') {
							productName = parser.getText();
						} else if (text == 'group_attachment') {
							attachment = parser.getText();
						} else if (text == 'glass_pcs') {
							glassAmount = String.valueOf(parser.getText());
						} else if (text == 'glass_m2') {
							glassSurface = String.valueOf(parser.getText());
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
							factoryPrice = String.valueOf(parser.getText());
						} else if (text == 'delivery_batch_status') {
							batchStatus = parser.getText();
						} else if (text == 'delivery_batch_receive_date') {
							promisedDate = parser.getText();
						} else if (text == 'delivery_batch_delivery_date') {
							deliveryDate = parser.getText();
						} else if (text == 'delivery_batch') {
							batchNumber = String.valueOf(parser.getText());
						} else if (text == 'contract_price') {
							contractedPrice = String.valueOf(parser.getText());
						} else if (text == 'chargeable') {
							chargeable = parser.getText();
						} else if (text == 'calculated_salesprice') {
							listPrice = String.valueOf(parser.getText());
						} else if (text == 'blinds_m2') {
							blindsSurface = String.valueOf(parser.getText());
						} else if (text == 'AXconfiguration') {
							isAXconfiguration = parser.getText();
						} else if (text == 'additional_deliverytime') {
							extraDeliveryTime = String.valueOf(parser.getText());
						} else if (text == 'product_attributes') {
							if (String.isNotBlank(parser.getText())){
								productAttributes = new Attribute(parser);
							}
						} else if (text == 'OrderLine') {
							if (String.isNotBlank(parser.getText())){
								workOrderLine = new WorkOrderLine(parser);
							}
						} else if (text == 'AssemblyInstructions') {
							// Not Needed at the moment
							if (String.isNotBlank(parser.getText())){
								instructions = new AssemblyInstructions(parser);
							}
						} else {
							System.debug(LoggingLevel.WARN, 'LineItem consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	public class WorkOrderLine {
		public String batchNumber {get;set;} 
		// ConfigurationProduct
		public String productSerialNumber {get;set;} 
		public String productCode {get;set;} 
		public String productName {get;set;} 	
		// Business
		public String warehouseCode {get;set;} 		
		public String organizationCode {get;set;} 
		public String superVisor {get;set;} 
		// Address
		public String contactName {get;set;} 
		public String street {get;set;} 
		public String postalCode {get;set;} 
		public String city {get;set;} 
		public String countryCode {get;set;} 		
		// Plan
		public String PlanName {get;set;} 
		public String floor {get;set;} 		
		public String line {get;set;} 
		public String unit {get;set;}
		// Planning
		public String productionDate {get;set;} 
		public String installationTime {get;set;} 
		public String installationStart {get;set;} 
		public String appointmentStart {get;set;} 
		public String promisedDate {get;set;} 
		// Price and Cost
		public String price {get;set;} 
		public String wages {get;set;} 

		public WorkOrderLine(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'BOMVersion') {
							productSerialNumber = parser.getText();
						} else if (text == 'ItemID') {
							productCode = parser.getText();
						} else if (text == 'ItemName') {
							productName = parser.getText();
						} else if (text == 'InventLocationID') {
							warehouseCode = parser.getText();
						} else if (text == 'Dimension1') {
							organizationCode = parser.getText();
						} else if (text == 'Dimension5') {
							superVisor = parser.getText();
						} else if (text == 'DeliveryName') {
							contactName = parser.getText();
						} else if (text == 'DeliveryStreet') {
							street = parser.getText();
						} else if (text == 'DeliveryZipCode') {
							postalCode = parser.getText();
						} else if (text == 'DeliveryCity') {
							city = parser.getText();
						} else if (text == 'DeliveryCountryRegionID') {
							countryCode = parser.getText();
						} else if (text == 'LineAmount') {
							price = parser.getText();
						} else if (text == 'Apartment') {
							unit = parser.getText();
						} else if (text == 'Floor') {
							floor = parser.getText();
						} else if (text == 'DlvBatchID') {
							batchNumber = parser.getText();
						} else if (text == 'Line') {
							line = parser.getText();
						} else if (text == 'FactoryConfirmedDlv') {
							productionDate = parser.getText();
						} else if (text == 'InstallHours') {
							installationTime = parser.getText();
						} else if (text == 'InstallStart') {
							installationStart = parser.getText();
						} else if (text == 'ReservationStart') {
							appointmentStart = parser.getText();
						} else if (text == 'DeliveryDatePromised') {
							promisedDate = parser.getText();
						} else if (text == 'Plan_name') {
							planName = parser.getText();
						} else if (text == 'PieceWork_pay') {
							wages = parser.getText();
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
			System.debug('--- ProjectData - Parse Attribute');
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
			System.debug('--- ProjectData - Parse Document');
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
		public String notes {get;set;} 
		public Attachments attachments {get;set;} 
		public List<AssemblyDocument> documents {get;set;} 

		public AssemblyInstructions(JSONParser parser) {
			System.debug('--- ProjectData - Parse Instructions');
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'InstallNotes') {
							notes = parser.getText();
						} else if (text == 'Attachments') {
							attachments = new Attachments(parser);
						} else if (text == 'AssemblyDocument') {
							documents = arrayOfAssemblyDocument(parser);
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
		public String title {get;set;} 
		public String content {get;set;} 

		public Paragraph(JSONParser parser) {
			System.debug('--- ProjectData - Parse Paragraph');
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'name') {
							title = parser.getText();
						} else if (text == 'text') {
							content = parser.getText();
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
		public String title {get;set;} 
		public List<Paragraph> paragraphs {get;set;} 

		public Chapter(JSONParser parser) {
			System.debug('--- ProjectData - Parse Chapter');
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'name') {
							title = parser.getText();
						} else if (text == 'Paragraph') {
							paragraphs = arrayOfParagraph(parser);
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
		public String attachment {get;set;} 
		public String folder {get;set;} 

		public Attachments(JSONParser parser) {
			System.debug('--- ProjectData - Parse Attachment');
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'Attachment') {
							attachment = parser.getText();
						} else if (text == 'Folder') {
							folder = parser.getText();
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

    private static List<LineItem> arrayOfLineItem(System.JSONParser p) {
        List<LineItem> res = new List<LineItem>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new LineItem(p));
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
	public class ProjectObjects {
		// Buyer Account
		public Id buyerId {get;set;}
		public Account buyer {get;set;}
		public Id buyerContactId {get;set;}
		public Contact buyerContact {get;set;}
		// main Customer Project
		public Id customerProjectId {get;set;} 
		public Building_Project__c customerProject {get;set;} 
		// Contract
		public Opportunity opportunityRecord {get;set;} 
		public Id offerId {get;set;}
		public Quote offer {get;set;} 
		public Id orderBatchId {get;set;}
		public Order orderBatch {get;set;}
		// Pricebook
		public Id priceBookId {get;set;}
		public Pricebook2 priceBook {get;set;}

		public Delivery_Project__c deliveryProject {get;set;} 
		// SalesUser
		public Id salesUserId {get;set;}
		public User salesUser {get;set;} 
		// Installation Manager/Project Manager
		public Id managerUserId {get;set;}
		public User managerUser {get;set;} 
	}
	public class ProjectAttributes {
		// Business Attributes
		public String organizationAttribute {get;set;}
		public String countryAttribute {get;set;} 
		public String profitCenterAttribute {get;set;}
		public String customerSegmentAttribute {get;set;}
		public String propertyTypeAttribute {get;set;}
		// Delivery Attributes
		public String orderTypeAttribute {get;set;} 
		// 
		public String currencyAttribute {get;set;}
		public String isChargeable {get;set;} 
		public String languagePreference {get;set;} 
		// Dates
		public String promisedDate {get;set;} 
		public String promisedweek {get;set;} 
		
		
		 

	}
}