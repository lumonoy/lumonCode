/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 04-05-2024
 * @last modified by  : Henk Reynders
**/
public with sharing class ConfigurationController {
	private static String sObjectName = 'Configuration_Product__c';
	private static String allowedFieldSet = 'Table_Fields';
	private static String visibleFieldSet = 'Table_View';
	private static String editableFieldSet = 'Table_Edit';
	@AuraEnabled(cacheable=true)
    public static String getVisualPricingJSON( String configId){
        String visualPricingJSON = string.valueOf([SELECT Visual_Pricing_JSON__c FROM Configuration__c WHERE Id =:configId]);
        return visualPricingJSON;
    }
    @AuraEnabled(cacheable=true)
    public static String getObjectType(String IdOrPrefix){
        String sObjectName = '';
        try{
            //Get prefix from record ID
            String recordIdPrefix = String.valueOf(IdOrPrefix).substring(0,3);     
            //System.debug('--- ConfigurationController - Get ObjectAPIName for prefix ' + recordIdPrefix);           
            //Get schema information
            Map<String, Schema.SObjectType> sObjectDescribeSchema =  Schema.getGlobalDescribe(); 
            //Loop through all the sObject types returned by Schema
            for(Schema.SObjectType sObjType : sObjectDescribeSchema.values()){
                //if (!sObjType.contains('__')) to exclude managed package objects
                Schema.DescribeSObjectResult sObjectDescribeResult = sObjType.getDescribe();
                String objectTypePrefix = sObjectDescribeResult.getKeyPrefix();
                 //Check if the prefix matches with requested prefix
                if(objectTypePrefix!=null && objectTypePrefix.equals(recordIdPrefix)){
                    sObjectName = sObjectDescribeResult.getName();
                    //System.debug('--- ConfigurationController - Set ObjectAPIName ' + sObjectName);
                    break;
                }
            }
        }catch(Exception e){
            System.debug(e);
        }
        return sObjectName;
    }
	@AuraEnabled(cacheable=true)
    public static VisualConfiguration getVisualConfigurationObjects(String visualPricingJSON){
        System.debug('--- ConfigurationController - Parsing File configJSON for Configuration Updates');
        VisualConfiguration visualConfigurationObject = new VisualConfiguration(); // Parsed Result Object  
        if (!String.isBlank(visualPricingJSON)){
            visualConfigurationObject = VisualConfiguration.parseVisualConfiguration(visualPricingJSON);
        }   
        return visualConfigurationObject;
    }
    @AuraEnabled(cacheable=true)
    public static SoveliaConfiguration getSoveliaConfigurationObjects(String soveliaPricingJSON){
        System.debug('--- ConfigurationController - Parsing File configJSON for Configuration Updates');
        SoveliaConfiguration soveliaConfigurationObject = new SoveliaConfiguration();
        if (String.isNotBlank(soveliaPricingJSON)){
            soveliaConfigurationObject = SoveliaConfiguration.parseSoveliaConfiguration(soveliaPricingJSON);
        }   
        return soveliaConfigurationObject;
    }
    @AuraEnabled(cacheable=true)
    public static String getConfigJSON( Id configId){
        String configJSON = string.valueOf([SELECT Config_JSON__c FROM Configuration__c WHERE Id =:configId]);
        System.debug('--- ConfigurationController - Config JSON Length on Record : '+configJSON.length());
        return configJSON;
    }
	@AuraEnabled(cacheable=true)
    public static List<Configuration__c> getAllConfigurations(Id configId, Id recordId, String visualPlanId){
        System.debug('--- ConfigurationController - Get Configuration Plan for Processing');
        Configuration__c configPlan = New Configuration__c(); // Existing Configuration Plan
        List<Configuration__c> configPlans = New List<Configuration__c>(); // Existing Configuration Plans  
        // Find Configuration based on configId, recordId or VisualPlanId
        if(String.isNotBlank(configId)){
            System.debug('--- ConfigurationController - Getting Configuration Plan Id for Config Id '+configId); 
            configPlan = ConfigurationController.getConfigurationPlan(configId);
            configPlans.add(configPlan);
            System.debug('--- ConfigurationController - Found '+configPlans.size()+' Configuration Plan(s) for Id: '+ configId);
        } else if (String.isBlank(configId) && String.isNotBlank(visualPlanId)){ 
            System.debug('--- ConfigurationController - Getting Configuration Plan Id for Visual Plan Id '+visualPlanId);  
            configPlan = ConfigurationController.getVisualConfigurationPlan(visualPlanId);
            configPlans.add(configPlan);
            System.debug('--- ConfigurationController - Found '+configPlans.size()+' Configuration Plan(s) for Id: '+ configId);
        } else if (String.isBlank(configId) && String.isBlank(visualPlanId) && String.isNotBlank(recordId)) {
            System.debug('--- ConfigurationController - Getting Configuration Plans from Record');       
            configPlans = ConfigurationController.getConfigurationPlans(recordId);
            System.debug('--- ConfigurationController - Found '+configPlans.size()+' related Configuration Plan(s) for Id: '+ recordId);
        }
        return configPlans;
    }
	@AuraEnabled(cacheable=true)
    public static List<Configuration_Message__c> getConfigurationMessages(List<Id> configProductIds){
        List<Configuration_Message__c> configMessages = new List<Configuration_Message__c>();
        if (configProductIds.size()>0 && configProductIds != null) {
            configMessages = [   SELECT Id,
                                        Name,
                                        Message_Key__c,
                                        Space_Side_Number__c,
                                        Configuration_Product__c
                                FROM Configuration_Message__c 
                                WHERE Configuration_Product__c IN: configProductIds];
        }
        return configMessages;
    }
	@AuraEnabled(cacheable=true)
    public static List<Configuration_Option__c> getConfigurationOptions(List<Id> configProductIds){
    List<Configuration_Option__c> configurationOptions = new List<Configuration_Option__c>();
        if (configProductIds.size()>0 && configProductIds != null) {
            configurationOptions = [   SELECT Id,
                                    Name,
                                    Line_Number__c,
                                    Cost_Category__c,
                                    Cost_Type__c,
                                    Quantity__c,
                                    Sales_Code__c,
                                    Product__c,
                                    Product__r.Product_Group__c,
                                    Product__r.Cost_Category__c,
                                    Product__r.Cost_Type__c,
                                    Product__r.Product_Category__c,  
                                    Product__r.Product_Type__c,  
                                    Product__r.Product_Item__c, 
                                    Product__r.ProductCode,  
                                    Product__r.Sales_Code__c,
                                    Product_Group__c,
                                    Product_Model__c,
                                    Product_Code__c,
                                    Configuration_Plan__c,
                                    Configuration_Product__c,
                                    Configuration_Product__r.Configuration__c,
									Configuration_Product__r.Product__c,
                                    Configuration_Product__r.RVN__c,
                                    Configuration_Product__r.Product_Group__c,
                                    Configuration_Product__r.Product_Model__c,
                                    RVN_Number__c
                            FROM Configuration_Option__c 
                            WHERE Configuration_Product__c IN: configProductIds];
        }
        return configurationOptions;
    }
    @AuraEnabled(cacheable=true)
    public static List<Configuration_Option__c> getConfigurationOptionsByIds(List<Id> configOptionIds){
    List<Configuration_Option__c> configurationOptions = new List<Configuration_Option__c>();
        if (configOptionIds.size()>0 && configOptionIds != null) {
            configurationOptions = [   SELECT Id,
                                            Name,
                                            Line_Number__c,
                                            Cost_Category__c,
                                            Cost_Type__c,
                                            Quantity__c,
                                            Sales_Code__c,
                                            Product__c,
                                            Product__r.Product_Group__c,
                                            Product__r.Cost_Category__c,
                                            Product__r.Cost_Type__c,
                                            Product__r.Product_Category__c,  
                                            Product__r.Product_Type__c,  
                                            Product__r.Product_Item__c, 
                                            Product__r.ProductCode,  
                                            Product__r.Sales_Code__c,
                                            Product_Group__c,
                                            Product_Model__c,
                                            Product_Code__c,
                                            Configuration_Plan__c,
                                            Configuration_Product__c,
                                            Configuration_Product__r.Configuration__c,
                                            Configuration_Product__r.Product__c,
                                            Configuration_Product__r.RVN__c,
                                            Configuration_Product__r.Product_Group__c,
                                            Configuration_Product__r.Product_Model__c
                                    FROM Configuration_Option__c 
                                    WHERE Id IN: configOptionIds];
        }
        return configurationOptions;
    }
    @AuraEnabled(cacheable=true)
	// Create a Map of Configuration Options and ProductCode
	public static Map<String,List<Configuration_Option__c>> getProductCodeToOptionsMap(List<Configuration_Option__c> configOptions){
		Map<String,List<Configuration_Option__c>>  productCodeToOptionsMap = new Map<String,List<Configuration_Option__c>> ();
		if (configOptions.size()>0 && configOptions != null) {
			for (Configuration_Option__c configOption : configOptions){
				String productCode = configOption.Product_Code__c;
				if(!productCodeToOptionsMap.containsKey(productCode)){
					productCodeToOptionsMap.put(productCode,new List<Configuration_Option__c>());
				}
                productCodeToOptionsMap.get(productCode).add(configOption);
			}
		}
		return productCodeToOptionsMap;
	}
    @AuraEnabled(cacheable=true)
	// Create a Map of Configuration Options and ProductCode
	public static Map<String,Configuration_Option__c> getUniqueIdToOptionMap(List<Configuration_Option__c> configOptions){
		Map<String,Configuration_Option__c>  uniqueIdToOptionMap = new Map<String,Configuration_Option__c> ();
		if (configOptions.size()>0 && configOptions != null) {
			for (Configuration_Option__c configOption : configOptions){
				String uniqueId;
                uniqueId = String.valueOf(configOption.Line_Number__c); 
                uniqueId += '-'+configOption.Product__r.Product_Group__c; // Visual Product Name
                uniqueId += '-'+configOption.Product__r.Sales_Code__c;// Visual Price Parameter Sales Code
                uniqueId += '-'+String.valueOf(configOption.Quantity__c.setScale(5)); // Visual Price Parameter Amount
				if(!uniqueIdToOptionMap.containsKey(uniqueId)){
					uniqueIdToOptionMap.put(uniqueId,configOption);
				}
			}
		}
		return uniqueIdToOptionMap;
	}
    @AuraEnabled(cacheable=true)
	// Retrieve the Configuration Products for One or more Plans
	public  static List<Configuration_Product__c> getConfigurationProducts(List<Id> configurationIds){
		List<Configuration_Product__c> configProducts = new List<Configuration_Product__c>();
		if (configurationIds.size()>0 && configurationIds !=null) {
			configProducts = [  SELECT  Id,
										Name,
										Quantity__c,
										Product_Group__c,
                                        Product_Model__c,
										Sales_Code__c,
										Product__c,
										Configuration__c,
										RVN_Number__c,
										RVN__c,
										Visual_Structure_Number__c,
										Sovelia_Structure_Number__c,
										Product__r.Product_Group__c,
                                        Visual_Product_Id__c,
                                        Sovelia_Product_Id__c
								FROM Configuration_Product__c 
								WHERE Configuration__c IN : configurationIds];
			System.Debug('--- ConfigurationController - '+configProducts.size()+' Products retrieved');
		}
        return configProducts;
    }//OK - Apex Test Passed
	@AuraEnabled(cacheable=true)
	// Retrieve the Configuration Products for One or more Plans
	public  static List<Configuration_Product__c> getConfigurationProductsById(List<Id> configProductIds){
		List<Configuration_Product__c> configProducts = new List<Configuration_Product__c>();
		if (configProductIds.size()>0 && configProductIds !=null) {
			configProducts = [  SELECT  Id,
										Name,
										Quantity__c,
										Sales_Code__c,
										Product__c,
                              			Product_Group__c,
                                        Product_Model__c,
										Configuration__c,
										RVN_Number__c,
                                        RVN__c,
										Visual_Structure_Number__c,
										Sovelia_Structure_Number__c,
										Product__r.Product_Group__c,
                                        Visual_Product_Id__c,
                                        Sovelia_Product_Id__c
								FROM Configuration_Product__c 
								WHERE Id IN : configProductIds];
			System.Debug('--- ConfigurationController - '+configProducts.size()+' Products retrieved');
		}
        return configProducts;
    }//OK - Apex Test Passed
	@AuraEnabled(cacheable=true)
    public static List<Configuration_Product__c> getConfigurationProductsByParentId(String recordId){
		List<Configuration_Product__c> configProducts = new List<Configuration_Product__c>();
		if (String.isNotBlank(recordId)) {
			configProducts = [  SELECT  Id,
                                        Name,
                                        Quantity__c,
                                        Sales_Code__c,
                                        Product__c,
                                        Product_Group__c,
                                        Product_Model__c,
                                        Configuration__c,
                                        RVN_Number__c,
                                        RVN__c,
                                        Visual_Structure_Number__c,
                                        Sovelia_Structure_Number__c,                                       
										Product__r.Product_Group__c,
                                        Visual_Product_Id__c,
                                        Sovelia_Product_Id__c
								FROM Configuration_Product__c 
								WHERE Configuration__r.Opportunity__c = : recordId];
			System.Debug('--- ConfigurationController - '+configProducts.size()+' Products retrieved');
		}
        return configProducts;
    }
	@AuraEnabled(cacheable=true)
	// Create a Map of Configuration Products and Visual Structure Number
	public static Map<String,Configuration_Product__c> getStructureToProductMap(List<Configuration_Product__c> configProducts){
		Map<String,Configuration_Product__c> structureToProductMap = new Map<String,Configuration_Product__c>();
		if (configProducts.size()>0) {
			for (Configuration_Product__c configProduct : configProducts){
				String structureNumber = configProduct.Visual_Structure_Number__c;
                if(structureNumber == null) {
                    structureNumber = configProduct.Sovelia_Structure_Number__c;
                }
				if(String.isNotBlank(structureNumber) && !structureToProductMap.containsKey(structureNumber)){
					structureToProductMap.put(structureNumber, configProduct);
				}
			}
		}
		return structureToProductMap;
	}
	@AuraEnabled(cacheable=true)
	// Create a Map of Configuration Products and Visual Structure Number
	public static Map<String,Configuration_Product__c> getRVNToProductMap(List<Configuration_Product__c> configProducts){
		Map<String,Configuration_Product__c> rvnToProductMap = new Map<String,Configuration_Product__c>();
		if (configProducts.size()>0 && configProducts != null) {
			for (Configuration_Product__c configProduct : configProducts){
				String rvnNumber = configProduct.RVN_Number__c;
				if(!rvnToProductMap.containsKey(rvnNumber)){
					rvnToProductMap.put(rvnNumber,configProduct);
				}
			}
		}
		return rvnToProductMap;
	}
	@AuraEnabled(cacheable=true)
	// Create a Map of Configuration Products and Visual Structure Number
	public static Map<String,List<Configuration_Product__c>> getGroupToProductsMap(List<Configuration_Product__c> configProducts){
		Map<String,List<Configuration_Product__c>> groupToProductsMap = new Map<String,List<Configuration_Product__c>>();
		if (configProducts.size()>0 && configProducts != null) {
			for (Configuration_Product__c configProduct : configProducts){
				String productGroup = configProduct.Product_Group__c;
				if(!groupToProductsMap.containsKey(productGroup)){
					groupToProductsMap.put(productGroup,new List<Configuration_Product__c>());
				}
				groupToProductsMap.get(productGroup).add(configProduct);
			}
		}
		return groupToProductsMap;
	}
	@AuraEnabled(cacheable=true)
    public static Map<String,List<Configuration_Option__c>> getConfigurationProductToItemsMap(List<Configuration_Product__c> configProducts){
        Map<String, List<Configuration_Option__c>> cProductToItemsMap = new Map<String, List<Configuration_Option__c>>();

        List<Id> configProductIds = new List<Id>(new Map<Id, Configuration_Product__c>(configProducts).keySet()); 
        List<Configuration_Option__c> configItems = getConfigurationOptions(configProductIds);
        if (configProducts.size()>0){      
            for(Configuration_Product__c cProduct :configProducts){
                String productGroup;
                if (String.isNotBlank(cProduct.Product_Group__c)){
                    productGroup =  cProduct.Product_Group__c;
                } else {
                    productGroup =  cProduct.Product__r.Product_Group__c;
                }               
                String configProductId = cProduct.Id;
                if(!cProductToItemsMap.containsKey(configProductId)){
                    cProductToItemsMap.put(configProductId, new List<Configuration_Option__c>());
                }
                if(configItems.size()>0){
                    for(Configuration_Option__c cItem :configItems){
                        cProductToItemsMap.get(configProductId).add(cItem);
                    }
                }
            }
        }
        return cProductToItemsMap;
    }   
	@AuraEnabled(cacheable=true)
	public static List<Configuration__c> getConfigurations(List<Id> configurationIds, String recordId, String visualPlanId){
		Configuration__c configPlan = New Configuration__c(); // Existing Configuration Plan
		List<Configuration__c> configurationPlans = New List<Configuration__c>(); // Existing Configuration Plans  
		// Find Configuration based on configurationId, recordId or VisualPlanId
		if (String.isNotBlank(visualPlanId)){ 
			configurationPlans = getConfigurationsByVisualId(visualPlanId);
			System.debug('--- ConfigurationController - Found '+configurationPlans.size()+' Configuration Plan(s) for Visual Id: '+ visualPlanId);
		} else if (configurationIds.size()>0 && configurationIds != null && String.isNotBlank(recordId)) {   
			configurationPlans = getConfigurationsByParentAndId(recordId,configurationIds);
			System.debug('--- ConfigurationController - Found '+configurationPlans.size()+' related Configuration Plan(s) for Id: '+ recordId);
		} else if(configurationIds.size()>0 && configurationIds != null){
			configurationPlans = getConfigurationsById(configurationIds);
			System.debug('--- ConfigurationController - Found '+configurationPlans.size()+' Configuration Plan(s) for Ids: '+ configurationIds);
		} else if (String.isNotBlank(recordId)) {   
			configurationPlans = getConfigurationsByParentId(recordId);
			System.debug('--- ConfigurationController - Found '+configurationPlans.size()+' related Configuration Plan(s) for Id: '+ recordId);
		}
		return configurationPlans;
	}
	@AuraEnabled(cacheable=true)
	public static List<Configuration__c> getConfigurationsById(List<Id> configurationIds){
		List<Configuration__c> configPlans = New List<Configuration__c>(); // Existing Configuration Plans  
		// Find Configuration based on ConfigurationIs
		if (configurationIds.size()>0 && configurationIds != null) {
			configPlans =  [ SELECT Id,
									Name,
									Account__c,
									Opportunity__c,
									Quote__c,
									Contract__c,
									Order__c,
									Work_Order__c,
									Case__c,
									Plan_Type__c,
									Visual_Id__c
							FROM Configuration__c 
							WHERE Id IN: configurationIds];
		}
		return configPlans;
	}
	@AuraEnabled(cacheable=true)
	public static List<Configuration__c> getConfigurationsByParentId(String recordId){
		List<Configuration__c> configPlans = New List<Configuration__c>(); // Existing Configuration Plans  
		// Find Configuration based on Opportunity or Quote recordId
		if (String.isNotBlank(recordId)) {
			configPlans = [ SELECT Id,
									Name,
									Account__c,
									Opportunity__c,
									Quote__c,
									Contract__c,
									Order__c,
									Work_Order__c,
									Case__c,
									Plan_Type__c,
									Visual_Id__c
							FROM Configuration__c 
							WHERE Account__c =: recordId
							OR Opportunity__c =: recordId
							OR Quote__c =: recordId
							OR Contract__c =: recordId
							OR Order__c =: recordId
							OR Work_Order__c =: recordId
							OR Case__c =: recordId];
		}
		return configPlans;
	}
	@AuraEnabled(cacheable=true)
	public static List<Configuration__c> getConfigurationsByParentAndId(String recordId, List<Id> configurationIds){
		List<Configuration__c> configPlans = New List<Configuration__c>(); // Existing Configuration Plans  
		// Find Configuration based on Opportunity or Quote recordId
		if (String.isNotBlank(recordId)) {
			configPlans = [ SELECT Id,
									Name,
									Account__c,
									Opportunity__c,
									Quote__c,
									Contract__c,
									Order__c,
									Work_Order__c,
									Case__c,
									Plan_Type__c,
									Visual_Id__c
							FROM Configuration__c 
							WHERE (Account__c =: recordId
							OR Opportunity__c =: recordId
							OR Quote__c =: recordId
							OR Contract__c =: recordId
							OR Order__c =: recordId
							OR Work_Order__c =: recordId
							OR Case__c =: recordId)
							AND Id IN: configurationIds];
		}
		return configPlans;
	}
	@AuraEnabled(cacheable=true)
	public static List<Configuration__c> getConfigurationsByVisualId(String visualPlanId){
		List<Configuration__c> configPlans = New List<Configuration__c>(); // Existing Configuration Plans  
		// Find Configuration based on Visual Confguration Id
		if (String.isNotBlank(visualPlanId)) {
			configPlans = [ SELECT Id,
									Name,
									Account__c,
									Opportunity__c,
									Quote__c,
									Contract__c,
									Order__c,
									Work_Order__c,
									Case__c,
									Plan_Type__c,
									Visual_Id__c
							FROM Configuration__c 
							WHERE Visual_Id__c =: visualPlanId];
		}
		return configPlans;
	}
	@AuraEnabled(cacheable=true)
	public static Map<Id,String> getConfigJSONsMap(List<Id> configIds){
		List<Configuration__c> configPlans = new List<Configuration__c>(); // Existing Configuration Plans  
		Map<Id,String> configJSONsMap = new Map<Id,String>(); // Existing Configuration JSONs  
		// Get Configuration
		if (configIds.size()>0 && configIds != null) {
			configPlans = [ SELECT Id,
									Plan_Type__c,
									Visual_Id__c,
									Config_JSON__c
							FROM Configuration__c 
							WHERE Id IN: configIds];
		}
		for (Configuration__c configWithJSON : configPlans){
			if (configWithJSON.Config_JSON__c != null) {
				if (!configJSONsMap.containsKey(configWithJSON.Id)){
					configJSONsMap.put(configWithJSON.Id,configWithJSON.Config_JSON__c);
				}
			}
		}
		return configJSONsMap;
	}
	@AuraEnabled(cacheable=true)
	// Create a Map of Configuration Products and Visual Structure Number
	public static Map<String,Configuration__c> getVisualIdToPlanMap(List<Configuration__c> configurations){
		Map<String,Configuration__c> visualToPlanMap = new Map<String,Configuration__c>();
		if (configurations.size()>0 && configurations != null) {
			for (Configuration__c configPlan : configurations){
				String visualId = configPlan.Visual_Id__c;
				if(!visualToPlanMap.containsKey(visualId)){
					visualToPlanMap.put(visualId,configPlan);
				}
			}
		}
		return visualToPlanMap;
	}
    @AuraEnabled 
    public static configWrapper getConfigurationData(String recordId, List<String> configurationIds, List<String> visualPlanIds){
    //get records from database
        List<Configuration__c> getConfigurations = [  SELECT Id,
																Name,
																Account__c,
																Opportunity__c,
																Quote__c,
																Contract__c,
																Order__c,
																Work_Order__c,
																Case__c
														FROM Configuration__c 
														WHERE Account__c =: recordId
														OR Opportunity__c =: recordId
														OR Quote__c =: recordId
														OR Contract__c =: recordId
														OR Order__c =: recordId
														OR Work_Order__c =: recordId
														OR Case__c =: recordId
														OR Id  IN: configurationIds
														OR Visual_Id__c IN: visualPlanIds];
        List<String>  configIds =  new List<String>();
        for (Configuration__c config :getConfigurations ) {
            configIds.add(config.Id);
        }                                     
        List<Configuration_Product__c> getConfigProducts = [ SELECT  Id
                                                FROM Configuration_Product__c 
                                                WHERE Configuration__c IN: configIds];
        List<String>  prodIds =  new List<String>();
        for (Configuration_Product__c configProd :getConfigProducts ) {
            prodIds.add(configProd.Id);
        }             
        List<Configuration_Option__c> getConfigOptions = [ SELECT  Id
                                                FROM Configuration_Option__c 
                                                WHERE Configuration_Product__c IN: prodIds];
        List<Configuration_Message__c> getConfigMessages = [ SELECT  Id
                                                FROM Configuration_Message__c 
                                                WHERE Configuration_Product__c IN: prodIds];
        
        //Create wrapper class instance 
        configWrapper wrp = new configWrapper();
        //wrp.cfg = new Configuration__c(getConfiguration);
        wrp.configProductList = new List<Configuration_Product__c>(getConfigProducts);
        wrp.configOptionList = new List<Configuration_Option__c>(getConfigOptions);
        wrp.configMessageList = new List<Configuration_Message__c>(getConfigMessages);
        return wrp;
    }
    // Configuration Wrapper
    public class configWrapper{
        @AuraEnabled public String recordId;
        @AuraEnabled public Configuration__c configPlans;
        @AuraEnabled public List<Configuration_Product__c> configProductList;
        @AuraEnabled public List<Configuration_Option__c> configOptionList;
        @AuraEnabled public List<Configuration_Message__c> configMessageList;      
    } 
	// POST PROCESSING
	@AuraEnabled(cacheable=true)
	public static List<ContentDocumentLink> getConfigurationFiles(String recordId){
		List<Configuration__c> configPlans = ConfigurationController.getConfigurationsByParentId(recordId);
		List<Id> configIds = new List<Id>(new Map<Id, Configuration__c>(configPlans).keySet()); 
		List<ContentDocumentLink> listCLDs = [  SELECT  LinkedEntityId, 
														ContentDocumentId,
														ContentDocument.CreatedDate, 
														ContentDocument.Title, 
														ContentDocument.ContentSize, 
														ContentDocument.FileType 
												FROM    ContentDocumentLink  
												WHERE   LinkedEntityId  IN :configIds];
		return listCLDs;
	}
	@AuraEnabled(cacheable=true)
	public static Map<ID, String> getVisualPricingFiles(String recordId){
		List<Configuration__c> configPlans = ConfigurationController.getConfigurationsByParentId(recordId);
		List<Id> configIds = new List<Id>(new Map<Id, Configuration__c>(configPlans).keySet()); 
		// Get pricing file IDs        
		List<ContentDocumentLink> files = [ SELECT  ContentDocumentId,
													ContentDocument.LatestPublishedVersionId
											FROM ContentDocumentLink 
											WHERE LinkedEntityId IN :configIds
											AND ContentDocument.Title Like '%Visual%'
											AND ContentDocument.Title Like '%Pric%'
											AND ContentDocument.FileType = 'json'];
		List<ID> fileIDs = new List<ID>();
		List<ID> versionIDs = new List<ID>();
		for (ContentDocumentLink docLink : files) {
			versionIDs.add(docLink.ContentDocument.LatestPublishedVersionId);
			fileIDs.add(docLink.ContentDocumentId);
		}
		List<ContentVersion> docs = [SELECT Id,ContentDocumentId, FileExtension, Title  
			FROM ContentVersion 
			WHERE ContentDocumentId IN : fileIDs
			AND Id IN : versionIds];
		Map<ID, String> mapIdTitle = new Map<ID, String>();     
		for (ContentVersion docLink : docs) {
			mapIdTitle.put(docLink.ContentDocumentId, docLink.Title);
		}
		return mapIdTitle;
	}
	@AuraEnabled
	public static void loadVisualPricingFile( Id contentDocumentId, String recordId, String sObjectType, String configId ) {
		String configJSON;
		List < VisualConfiguration > configList = new List < VisualConfiguration >();
		if ( contentDocumentId != null ) {  
			ContentDocument contentDocumentObj = [  SELECT  Id,
															LatestPublishedVersionId
													FROM ContentDocument 
													WHERE Id = :contentDocumentId];
			Id latestVersion  = contentDocumentObj.LatestPublishedVersionId;                   
			ContentVersion contentVersionObj = [ SELECT Id, VersionData 
													FROM ContentVersion 
													WHERE ContentDocumentId =:contentDocumentId 
													AND Id =: latestVersion];
			configJSON = contentVersionObj.VersionData.toString();
		}
		if(configJSON != Null){
			// Publish a new Configuration Event by calling the VisualConfigurationEvent (Controller)
			System.debug('--- ConfigurationController - publish Configuration Change Event');
			String cfgType = 'Visual';
			String cfgAction = 'Configure';
			String cfgRecordId = recordId; //Change to Support other objects
			String cfgObjectType = sObjectType;
			String cfgPlanId = configId;
			String cfgVisualId;
			String cfgDocLinkId; // DO NOT USE cdL.Id
			String cfgJSON = configJSON;
			ConfigurationEvent.publishConfigurationEvent(cfgType,cfgAction,cfgPlanId,//Visual, Price
															cfgRecordId,cfgObjectType,
															cfgVisualId,cfgDocLinkId,cfgJSON);
		} 
	} 
	@AuraEnabled(cacheable=true)
    public static Configuration__c getVisualConfigurationPlan(String visualPlanId){
        Configuration__c visualConfigPlan =  [ SELECT Id,
                                                Name,
                                                Account__c,
                                                Opportunity__c,
                                                Quote__c,
                                                Contract__c,
                                                Order__c,
                                                Work_Order__c,
                                                Case__c,
                                                Visual_Id__c
                                        FROM Configuration__c 
                                        WHERE Visual_Id__c =: visualPlanId
                                        LIMIT 1];
        return visualConfigPlan;
    }
    @AuraEnabled(cacheable=true)
    public static List<Configuration__c> getRelatedConfigurations(String recordId){
        System.debug('--- ConfigurationController - Get Configuration Plan for Processing');
        Configuration__c configPlan = New Configuration__c(); // Existing Configuration Plan
        List<Configuration__c> configurationPlans = New List<Configuration__c>(); // Existing Configuration Plans  
        // Find Configuration based on Opportunity or Quote recordId
        if (String.isNotBlank(recordId)) {
            System.debug('--- ConfigurationController - Getting Configuration Plans for Record: '+recordId);       
            configurationPlans = ConfigurationController.getConfigurationPlans(recordId);
            System.debug('--- ConfigurationController - Found '+configurationPlans.size()+' Related Configuration Plan(s) for Id: '+ recordId);
        }
        return configurationPlans;
    }
	@AuraEnabled(cacheable=true)
    public static Configuration__c getConfigurationPlan(String configurationId){
        Configuration__c configPlan =  [ SELECT Id,
                                                Name,
                                                Account__c,
                                                Opportunity__c,
                                                Quote__c,
                                                Contract__c,
                                                Order__c,
                                                Work_Order__c,
                                                Case__c
                                        FROM Configuration__c 
                                        WHERE Id =: configurationId
                                        LIMIT 1];
        System.debug('--- ConfigurationController - Configuration Plan: '+configPlan);
        return configPlan;
    }
    @AuraEnabled(cacheable=true)
    public static List<Configuration__c> getConfigurationPlans(String recordId){
        List<Configuration__c> configurationPlans = [ SELECT Id,
                                                        Name,
                                                        Account__c,
                                                        Opportunity__c,
                                                        Quote__c,
                                                        Contract__c,
                                                        Order__c,
                                                        Work_Order__c,
                                                        Case__c
                                                FROM Configuration__c 
                                                WHERE Account__c =: recordId
                                                OR Opportunity__c =: recordId
                                                OR Quote__c =: recordId
                                                OR Contract__c =: recordId
                                                OR Order__c =: recordId
                                                OR Work_Order__c =: recordId
                                                OR Case__c =: recordId];
        System.debug('--- ConfigurationController - Found '+configurationPlans.size()+' Configuration Plan(s)');
        return configurationPlans;
    }
    /********* START PROCESSING OF VISUAL PRICING **************/
    /**
    * @description Method used to loop through the pricing JSON received from Visual and create/update relevant Configuration Plan/Product/Option/Message 
    * @author Henk Reynders | 04-05-2024 
    * @param configId 
    * @param recordId 
    * @param visualPricingJSON 
    * @return String 
    **/
	@AuraEnabled(cacheable=true)
    public static String processVisualConfiguration(String configId, String recordId, String visualPricingJSON){
        System.debug('--- ConfigurationController - Parsing File pricingJSON for Configuration Updates');
        String errorMessage;
        String successMessage;
        // Salesforce Configuration Plan Variables
        String configPlanId; // Configuration Id
        Configuration__c existingPlan = New Configuration__c(); // Existing Configuration Plan
        List<Configuration__c> existingPlans = New List<Configuration__c>(); // Existing Configuration Plans 
        List<Id> existingPlanIds = new List<Id>(); // Existing Configuration Plan Ids 
        List<Configuration__c> plansToUpsert = New List<Configuration__c>(); // New or Changed Configuration Configuration Plans
        Integer planCount;

        // Salesforce Configuration Product Variables
        List<String> productRVNs = new List<String>();
        List<Configuration_Product__c> existingProducts = new List<Configuration_Product__c>(); // Existing Configuration Products
        List<Id> existingProductIds = new List<Id>(); // Existing Configuration Product Ids 
        List<Id> upsertedProductIds = new List<Id>(); 
        Integer productCount;
        
        // Salesforce Configuration Item Variables
        List<Configuration_Option__c> existingItems = new List<Configuration_Option__c>(); // Existing Configuration Items
        List<Configuration_Option__c> itemsToUpsert = new List<Configuration_Option__c>(); // New or Changed Configuration Items as in File visualPricingJSON
        List<Id> existingItemIds = new List<Id>(); // Existing Configuration Option Ids 
        List<Id> upsertedItemIds = new List<Id>();
        Integer itemCount;

        // Salesforce Configuration Message Variables
        List<Configuration_Message__c> existingMessages = new List<Configuration_Message__c>(); // Existing Configuration Messages
        Configuration_Message__c updatedMessage = new Configuration_Message__c();
        List<Configuration_Message__c> messagesToUpsert = new List<Configuration_Message__c>(); // New or Changed Configuration Messages as in File visualPricingJSON
        List<Id> existingMessageIds = new List<Id>();
        List<Id> upsertedMessageIds = new List<Id>();
        
        Integer messageCount;

        // Salesforce Parent Record Variables
        String parentObjectType;
        Opportunity opportunityRecord;
        Quote quoteRecord;
        Case caseRecord;
        Order orderRecord;
        WorkOrder workorderRecord;

        // Salesforce Pricing Attributes
        String opportunityNumber; // Number of the Opportunity, used for RVN on New Plan
        String pricebookId; // Pricebook Id
        String currencyCode; // Currency

        // Salesforce Product Lookup Variables
        String itemLookupCode; // Product Item Identifier
        String productLookupCode; // Product Identifier

        // Salesforce PriceBook2 Variables
        String pbEntryId; // Pricebook Entry Id
        String pbEntryProductId; // Pricebook Entry Product Id
        String pbEntryProductCode;// Code of the Product
        String pbEntrySalesCode;
        String pbEntryName; // Pricebook Entry Product Name
        String pbEntryUoM; // Pricebook Entry Product UoM 
        String pbEntryCostCategory; // Grouping of Cost Types for Order XML data prep
        String pbEntryCostType; // Grouping of Product for Pricing data prep
        String pbEntryProductCategory; // Product Category of the Product
        String pbEntryProductType;// Product Type of the Product
        String pbEntryProductItem;// Product Type of the Product
        Decimal pbEntryStandardPrice;// Standard Price of the Product
        Decimal pbEntryUnitPrice;// List Price of the Product
        PricebookEntry pbEntry; // Pricebook Entry Record
        Map<String, PricebookEntry> pricebookEntryConfigurationProductMap = new Map<String, PricebookEntry>();  // Normal or Reclamation pbentries used for Configuration Products
        Map<String, PricebookEntry> pricebookEntryMap = new Map<String, PricebookEntry>();  // Map for Lookup of Product and Prices
        
        // Salesforce Installation Time Variables
        String installationTimeId; // Installation Time  Id
        Decimal installationHours;
        Decimal installationMins;
        String installationUoM;
        String installationCostType;
        String installationCostCategory;                            
        String installationProductCategory;
        String installationProductType;
        String installationProductItem;
        String installationProductName;
        Installation_Time__c installationTime; // Installation Time Record
        Map<String,Installation_Time__c> installationTimeMap  = New Map<String,Installation_Time__c>();  // Map for Lookup of Product and installation Times
        Product2 installationTimeProduct;
        // Salesforce Installation Time Product Variables
        Map<String,Product2> installationTimeProductMap = New Map<String,Product2>();
        // Salesforce Production Time Variables
        String productionTimeId; // Production Time  Id
        Decimal productionDays;
        Decimal productionExtraDays;
        // Add Production Times 05.04.2024
        Production_Time__c productionTime; // Production Time Record
        Map<String,Production_Time__c> productionTimeMap  = New Map<String,Production_Time__c>();  // Map for Lookup of Product and Production Times
        Product2 productionTimeProduct;
        // Salesforce Product2 Variables
        //String productId; // Product2 Id
        String existingProductId;
        String itemProductId;
        
        // Visual Configuration Variables
        String visualPlanId; // Visual Plan Id
        VisualConfiguration visualConfigObject = new VisualConfiguration(); // Parsed Visual Configuration Result Object 
        String visualStructure; // Visual Structure Id
        String visualProductId; // Visual Product Id
        List<String> structureNumbers = new List<String>(); 
        List<VisualConfiguration.Product> visualConfigProducts = new List<VisualConfiguration.Product>(); // Products from Parsed Result Object    
        Double visualItemAmount; // Visual Param Quantity 
        String visualItemSalesCode; // Visual Param Code
        String visualItemCostCategory; // Cost Category
        String visualItemCostType; // Cost Type

        List<Object> visualConfigItems = new List<Object>(); // Product Items from Parsed Result Object   
        List<Object> visualConfigMessages = new List<Object>(); // Product Messages from Parsed Result Object  
        
        // Step 0: Check for Existing Configuration Records
        try {
            // Step 1: Validated the parent RecordId
            if (String.IsNotBlank(recordId)){
                parentObjectType = getObjectType(recordId);
                System.debug('--- ConfigurationController - Process Configurations for Object '+parentObjectType+' with Id '+recordId);
            } else {
                errorMessage = 'No Parent Object identified!';
                System.debug('--- ConfigurationController - ABORT '+errorMessage);
                throw new CustomException(errorMessage);
            } 
            // Step 2: Get the Parent Object
            if (String.IsNotBlank(recordId) && parentObjectType=='Opportunity') {
                // Get Related Opportunity Record
                opportunityRecord = OpportunityProductController.getOpportunityRecord(recordId);
                // Set Related Records
                pricebookId = opportunityRecord.pricebook2Id;                      
                currencyCode = opportunityRecord.CurrencyIsoCode; 
                opportunityNumber = opportunityRecord.Opportunity_Number__c;
            } else {
                errorMessage = 'No Opportunity Identified!';
                System.debug('--- ConfigurationController - ABORT '+errorMessage);
                throw new CustomException(errorMessage);
            } 
            // Step 3: Get the Pricebook Entries
            if (String.IsNotBlank(pricebookId)) {
                // Get Sellable Products from Opportunity Pricebook
                pricebookEntryConfigurationProductMap = PriceBookEntryController.getPricebookEntryMap(pricebookId, currencyCode, opportunityRecord);
                pricebookEntryMap = PriceBookEntryController.getPricebookEntryMap(pricebookId, currencyCode);
                System.debug('--- ConfigurationController - '+pricebookEntryMap.size()+' sellable  Product(s)');
                // Get Installable Products from installation Times         
                Boolean isActive = true;
                installationTimeMap = InstallationTimeController.getInstallationTimeMap(isActive);
                System.debug('--- ConfigurationController - '+installationTimeMap.size()+' Installation Time(s)');
                // Get Installable Products from Product2   
                installationTimeProductMap = InstallationTimeController.getInstallationTimeProductMap(isActive);
                System.debug('--- ConfigurationController - '+installationTimeProductMap.size()+' Installation Time Product(s)');
                // Add Production Times
                productionTimeMap = ProductionTimeController.getProductionTimeMap(isActive);
                System.debug('--- ConfigurationController - '+productionTimeMap.values().size()+' Production Time(s)');
            } else {
                errorMessage = 'No Pricebook Defined!';
                System.debug('--- ConfigurationController - ABORT '+errorMessage);
                throw new CustomException(errorMessage);
            } 
            // Step 4: Get the Visual Configuration by parsing the pricing File content = visualPricingJSON
            if (String.IsNotBlank(visualPricingJSON)) {
                // Get Products from Visual Pricing JSON
                visualConfigObject = ConfigurationController.getVisualConfigurationObjects(visualPricingJSON);  
                visualConfigProducts = visualConfigObject.products;
            } else {
                errorMessage = 'No Pricing File Content to Process!';
                System.debug('--- ConfigurationController - ABORT '+errorMessage);
                throw new CustomException(errorMessage);
            } 
            // Step 5: Get the Configuration Plan
            if (visualConfigObject !=null) {
                // Check for Existing Plans by configId, (parent) recordId or VisualPlanId
                existingPlans = ConfigurationController.getAllConfigurations(configId,recordId,visualPlanId);
                existingPlanIds = new List<Id>(new Map<Id, Configuration__c>(existingPlans).keySet()); 
                System.debug('--- ConfigurationController - '+existingPlans.size()+' Existing Configuration(s)');           
                for (Configuration__c planToUpsert : existingPlans){
                    // Prepare Plan to Insert or Update
                    if (!String.isBlank(configId)){
                        planToUpsert.Id = configId; // Parent Record = Configuration
                    } else {
                        configId = planToUpsert.Id;
                    }
                    // Update the Plan with Values from the New or Changed Pricing File Content
                    planToUpsert.Name = visualConfigObject.Name;
                    // Set Plan Values based on Visual Update
                    planToUpsert.Plan_Apartment__c = visualConfigObject.apartment;
                    if (visualConfigObject.floor != null && visualConfigObject.floor.isNumeric()) {
                        planToUpsert.Plan_Floor__c = Integer.valueOf(visualConfigObject.floor);
                    }
                    planToUpsert.Plan_Line__c = visualConfigObject.line;
                    planToUpsert.Plan_Name__c = visualConfigObject.name;
                    planToUpsert.Visual_Id__c = visualConfigObject.id;
                    planToUpsert.Visual_Version__c = visualConfigObject.version; 
                    // Store the Pricing JSON in the Configuration Record
                    planToUpsert.Visual_Pricing_JSON__c = visualPricingJSON;
                    planToUpsert.Visual_Products_JSON__c = JSON.serialize(visualConfigProducts);
                    planToUpsert.OwnerId = opportunityRecord.OwnerId;
                    // Created or Update the Configuration Record
                    upsert planToUpsert;
                    // Add the New or Changed Plan to Collection
                    plansToUpsert.add(planToUpsert);  
                }
                System.debug('--- ConfigurationController - '+plansToUpsert.size()+' New or Changed Configuration Plan(s)');   
            } else {
                errorMessage = 'No Visual Configuration Object to Process!';
                System.debug('--- ConfigurationController - ABORT '+errorMessage);
                throw new CustomException(errorMessage);
            } 
            // Step 6: Get the Configuration Products
            // Process the Visual Configuration Products
            productCount = visualConfigProducts.size();
            System.debug('--- ConfigurationController - '+productCount+' Visual Configuration Product(s)');
            if (visualConfigObject !=null && productCount>0){               
                List<Configuration_Product__c> productsToUpsert = new List<Configuration_Product__c>(); // New or Changed Configuration Products as in File visualPricingJSON
                // Check for Existing Products by configId, (parent) recordId or VisualPlanId
                existingProducts = ConfigurationController.getConfigurationProducts(existingPlanIds);
                System.debug('--- ConfigurationController - '+existingProducts.size()+' Existing Configuration Product(s)'); 
                if (existingProducts.size()>0) {   
                    Map<String,Configuration_Product__c> structureToProductMap =  getStructureToProductMap(existingProducts);
                    Boolean isProductExisting = structureToProductMap.containsKey(visualStructure);
                    if (isProductExisting) {
                        Configuration_Product__c existingProduct = structureToProductMap.get(visualStructure);
                        existingProductId = existingProduct.Id;
                    } else {
                        existingProductId = '';
                    } 
                } 
                // Loop through the Visual Configuration Products
                for (Integer j = 0; j < productCount; j++) {  
                    Integer productCounter = j+1;
                    //System.debug('--- ConfigurationController - Processing Visual Configuration Product '+productCounter+' of '+productCount);
                    Configuration_Product__c configurationProduct = new Configuration_Product__c(); // New or Changed Configuration Product as in File configJSON
                    // Find the Pricebook Entry for the Configuration Product
                    productLookupCode = visualConfigObject.products[j].name; 
                    // Check if productCode is in the pricebookEntry Map
                    Boolean pbEntryKeyFound = pricebookEntryConfigurationProductMap.containsKey(productLookupCode);
                    // Add Production Times 05.04.2024
                    Boolean productionTimeKeyFound = productionTimeMap.containsKey(productLookupCode);
                    // if Entry exists retrieve it else just log it
                    pbEntryId=''; 
                    if(pbEntryKeyFound) {   
                        pbEntry = (PricebookEntry) pricebookEntryConfigurationProductMap.get(productLookupCode);
                        //System.debug('--- ConfigurationController - Found Product Pricebook Entry '+pbEntry+' for ProductCode '+productLookupCode); 
                        //System.debug('--- ConfigurationController - pbEntry.Product2.Sales_Code__c'+pbEntry.Product2.Sales_Code__c);
                        // If Entry exists and is not a Reclamation Product get the Details
                        if (!pbEntry.Product2.Reclamation__c) {
                            pbEntryProductId = pbEntry.Product2Id; // reference to Product2 Record
                        } else if (opportunityRecord.Order_Type__c == 'Reclamation' 
                                    && pbEntry.Product2.Reclamation__c) {
                            pbEntryProductId = pbEntry.Product2Id; // reference to Product2 Record
                        }
                        if (String.isNotBlank(pbEntryProductId)){
                            pbEntryId = pbEntry.Id;// reference to Pricebook Entry Record
                            pbEntryUoM = pbEntry.Product2.QuantityUnitOfMeasure; // Unit Of Measure of the Product
                            pbEntryName = pbEntry.Product2.Name;// Name of the Product
                            pbEntryProductCode = pbEntry.Product2.ProductCode;// Code of the Product
                            pbEntrySalesCode = pbEntry.Product2.Sales_Code__c;// Code of the Product
                            pbEntryCostCategory = pbEntry.Product2.Cost_Category__c; // Cost Category of the Product
                            pbEntryCostType = pbEntry.Product2.Cost_Type__c;// Cost Type of the Product
                            pbEntryProductCategory = pbEntry.Product2.Product_Category__c; // Product Category of the Product
                            pbEntryProductType = pbEntry.Product2.Product_Type__c;// Product Type of the Product
                            pbEntryProductItem = pbEntry.Product2.Product_Item__c;// Product Item of the Product
                            // Add Production Times 05.04.2024
                            if (productionTimeKeyFound) {
                                productionTime = (Production_Time__c) productionTimeMap.get(productLookupCode);
                                // If Entry exists then add the production time to Configuration Product
                                productionTimeId = productionTime.Id;
                                productionDays = productionTime.Days__c; // Production Time Lookup
                                System.debug('--- ConfigurationController - Add Production Days: '+productionDays); 
                            }
                            
                        } else {
                            System.debug('--- ConfigurationController - No Pricebook Entry Product'); 
                        }
                    }  else {
                        System.debug('--- ConfigurationController - NO Pricebook Entry for Product '+productLookupCode); 
                        pbEntryId=''; 
                    }
                    
                    // Continue only if there was a Pricebook Entry Found
                    if (String.isNotBlank(pbEntryId)){
                        Configuration_Product__c productToUpsert = new Configuration_Product__c(); // Fix made to reset producttoupsert SAI 24.02.2023
                        // Set New or Changed Configuration Product Identifiers based on parsed Visual Pricing File Content
                        visualStructure = visualConfigObject.products[j].rvn;
                        visualProductId = visualConfigObject.products[j].Id;
                        //System.debug('--- ConfigurationController - Check for Configuration Product(s) with Visual Product Id '+visualProductId+' and Structure '+visualStructure); 
                        // Check Existing Configuration Products to find Id needed in upsert
                        // Loop Existing Configuration Products to find Id
                        Configuration_Product__c existingConfigurationProduct = null;
                        if (existingProducts.size()>0) {    
                            for (Configuration_Product__c existingProduct : existingProducts) {
                                if (existingProduct.Visual_Structure_Number__c == visualStructure
                                    && existingProduct.Visual_Product_Id__c == visualProductId) { // By SAI 24.02.2023
                                        existingProductId = existingProduct.Id;
                                        existingConfigurationProduct = existingProduct;
                                    //System.debug('--- ConfigurationController - Found matching Configuration Product: '+existingProductId); 
                                } else {
                                    System.debug('--- ConfigurationController - No matching Configuration Product with Code: '+productLookupCode); 
                                    existingProductId = ''; // By SAI 24.02.2023
                                }
                            }
                        } else {
                            System.debug('--- ConfigurationController - No Existing Configuration Product(s)');
                        }
                        System.debug('--- ConfigurationController - Checking Configuration Product for Plan with Id: '+configId);
                        if (String.isNotBlank(existingProductId)){
                            productToUpsert.Id = existingProductId;
                            System.debug('--- ConfigurationController - Use Existing Configuration Product with Id: '+existingProductId);
                            if(existingConfigurationProduct?.Configuration__c != null) {
                                productToUpsert.Configuration__c = existingConfigurationProduct.Configuration__c;
                            }
                        } else {
                            productToUpsert.Configuration__c = configId; // Parent Record = Configuration
                            System.debug('--- ConfigurationController - Add Configuration Product to Plan with Id: '+configId);
                        }
                        // Set Values for the New or Changed Configuration Product based on parsed Visual Pricing File Content                        
                        productToUpsert.Product_Group__c = visualConfigObject.products[j].name; // Product Name in Visual is Product Group in Salesforce
                        productToUpsert.Visual_Product_Id__c = visualConfigObject.products[j].Id; // Unique Visual Product Id,not used in Salesforce
                        productToUpsert.Visual_Structure_Number__c = visualConfigObject.products[j].rvn; // Unique Visual Product RVN is actually Structure number
                        productToUpsert.Product_Length__c = visualConfigObject.products[j].productLength; // Visual Product Length 
                        // Variables that affect the Coonfiguration Product Status
                        productToUpsert.Inspection_Code__c = visualConfigObject.products[j].productInspectCode; // Visual Inspection Error Code
                        productToUpsert.Features_Confirmed__c = visualConfigObject.products[j].hasFeaturesBeenConfirmed; // Visual Feature Confirmed Checkbox
                        productToUpsert.Measurements_Verified__c = visualConfigObject.products[j].hasMeasurementsBeenVerified; // Visual Mesaurements Confirmed Checkbox
                        // Variables relevant in Salesforce for Pricing etc
                        productToUpsert.Product__c = pbEntryProductId; // Reference to the related Product2 record in Salesforce
                        productToUpsert.Name = pbEntryName; // Use the Name of the Product2 record in Salesforce
                        productToUpsert.Quantity__c = 1; // As this is a Configurable Product Quantity must be 1
                        productToUpsert.Cost_Category__c = pbEntryCostCategory;
                        productToUpsert.Cost_Type__c = pbEntryCostType;
                        productToUpsert.Product_Category__c = pbEntryProductCategory;
                        productToUpsert.Product_Type__c = pbEntryProductType;
                        productToUpsert.Product_Item__c = pbEntryProductItem;
                        // Set the RVN Number to Opportunity Number + StructureNumber
                        String structureNumber = productToUpsert.Visual_Structure_Number__c;
                        productToUpsert.RVN_Number__c = opportunityNumber + structureNumber;
                        // Add Production Times 05.04.2024
                        productToUpsert.Production_Days__c = productionDays;
                        // upsert visualProduct;
                        // Add updated Product Record to Collection
                        productsToUpsert.add(productToUpsert);    
                        
                        //System.debug('--- ConfigurationController - Adding Configuration Product '+productToUpsert);            
                    }   
                }
                System.debug('--- ConfigurationController - '+productsToUpsert.size()+' Configuration Products to Create or Update');
                /********* FOR RECLAMATION  **************/
                // Check if the configuration_Product__c.Product__r.Reclamation__c = TRUE
                // If YES Then Check  if there is a reclaimedFeatureMessageKeys included in the Pricing File 
                // IF reclaimedFeatureMessageKeys != empty then upsert the Product
                // ELSE "Break" (clear the productsToUpsert as it will then also not continue with Processing Items)
                if (productsToUpsert.size()>0) {
                    upsert productsToUpsert;
                }
                upsertedProductIds = new List<Id>(new Map<Id, Configuration_Product__c>(productsToUpsert).keySet()); 
                System.debug('--- ConfigurationController - '+upsertedProductIds.size()+ ' Configuration Product(s) Created or Updated');
                // Get Existing Configuration Products to Delete
                List<Configuration_Product__c> obsoleteProducts = New List<Configuration_Product__c>();
                obsoleteProducts = ([SELECT Id                                  
                                    FROM Configuration_Product__c
                                    WHERE Configuration__c =: configId 
                                    AND Id NOT IN :upsertedProductIds
                                    ORDER BY CreatedDate DESC]);
                System.debug('--- ConfigurationController - '+obsoleteProducts.size()+' Configuration Product(s) to Delete');
                if (obsoleteProducts.size()>0) {
                    delete obsoleteProducts;
                }
            }
            // Step 7: Get the Configuration Items
            if (upsertedProductIds.size()>0 && upsertedProductIds != null){
                // Check for Existing Products by configId, (parent) recordId or VisualPlanId
                existingProducts = ConfigurationController.getConfigurationProductsById(upsertedProductIds);
                existingProductIds =  new List<Id>(new Map<Id, Configuration_Product__c>(existingProducts).keySet()); 
                System.debug('--- ConfigurationController - '+existingProducts.size()+' Existing Configuration Product(s)');
                // Check for Existing Items by (parent) product, Structure Number or RVN
                existingItems = ConfigurationController.getConfigurationOptions(upsertedProductIds);
                System.debug('--- ConfigurationController - '+existingItems.size()+' Existing Configuration Item(s)'); 
                // Check for Existing Messages by (parent) product, Structure Number or RVN
                existingMessages = ConfigurationController.getConfigurationMessages(upsertedProductIds);
                System.debug('--- ConfigurationController - '+existingMessages.size()+' Existing Configuration Message(s)'); 
            }
            // Step 8: Process the Configuration Items
            if (visualConfigObject !=null && productCount>0){
                for (Integer k=0;k<visualConfigProducts.size();k++){
                    String visualProductName = visualConfigObject.products[k].name;  
                    productLookupCode = visualProductName;  
                    //System.debug('--- ConfigurationController - Processing Visual Configuration Item(s) for Product '+productLookupCode);
                    Integer productCounter = k+1;
                    //System.debug('--- ConfigurationController - Processing Visual Configuration Product '+productCounter+' of '+visualConfigProducts.size());
                    // Process the Visual Configuration Products
                    visualConfigItems = visualConfigObject.products[k].priceParameters;
                    itemCount = visualConfigItems.size();
                    System.debug('--- ConfigurationController - '+itemCount+' Visual Configuration Item(s)');
                    // Loop through the Visual Configuration Items
					Integer itemCounter = 0;
                    for (Integer l = 0; l < itemCount; l++) {  
                        itemCounter = l+1;
                        //System.debug('--- ConfigurationController - Processing Visual Configuration Item '+itemCounter+' of '+itemCount);
                        Configuration_Option__c configurationItem = new Configuration_Option__c(); // New or Changed Configuration Item as in File configJSON
                        // Find the Pricebook Entry for the Configuration Item
                          
                        String salesCode = visualconfigObject.products[k].priceParameters[l].SalesCode;
                        itemLookupCode = productLookupCode+'-'+salesCode;          
                        //System.debug('--- ConfigurationController - Lookup Pricebook Entry for itemCode '+itemLookupCode);
                        // Check if itemCode is in the pricebookEntry Map
                        Boolean pbEntryKeyFound = pricebookEntryMap.containsKey(itemLookupCode);                                       
                        Boolean installTimeKeyFound = installationTimeMap.containsKey(itemLookupCode);
                        // Add Production Times 05.04.2024
                        Boolean productionTimeKeyFound = productionTimeMap.containsKey(itemLookupCode);

                        // if Entry exists retrieve it else just log it
                        pbEntryId=''; 
                        if(pbEntryKeyFound) {   
                            pbEntry = (PricebookEntry) pricebookEntryMap.get(itemLookupCode);
                            System.debug('--- ConfigurationController - Configuration Item PBE: '+pbEntry);
                            // If Entry exists and is not a Reclamation Product get the Details
                            if (!pbEntry.Product2.Reclamation__c) {
                                itemProductId = pbEntry.Product2Id;// reference to Product2 Record
                                pbEntryProductId = pbEntry.Product2Id; // reference to Product2 Record
                                pbEntryId = pbEntry.Id;// reference to Pricebook Entry Record
                                pbEntryUoM = pbEntry.Product2.QuantityUnitOfMeasure; // Unit Of Measure of the Product
                                pbEntryName = pbEntry.Product2.Name;// Name of the Product
                                pbEntryProductCode = pbEntry.Product2.ProductCode;// Unique Code of the Product
                                pbEntrySalesCode = pbEntry.Product2.Sales_Code__c;// Sales Code of the Product
                                pbEntryCostCategory = pbEntry.Product2.Cost_Category__c; // Cost Category of the Product
                                //System.debug('--- ConfigurationController - Found Reclamation Product Cost Category '+pbEntryCostCategory); 
                                pbEntryCostType = pbEntry.Product2.Cost_Type__c;// Cost Type of the Product
                                //System.debug('--- ConfigurationController - Found Reclamation Product Cost Type '+pbEntryCostType); 
                                pbEntryProductCategory = pbEntry.Product2.Product_Category__c; // Product Category of the Product
                                pbEntryProductType = pbEntry.Product2.Product_Type__c;// Product Type of the Product
                                pbEntryProductItem = pbEntry.Product2.Product_Item__c;// Product Item of the Product
                                // Add Production Times 05.04.2024
                                if (productionTimeKeyFound) {
                                    productionTime = (Production_Time__c) productionTimeMap.get(itemLookupCode);
                                    // If Entry exists then add the production time to Configuration Option
                                    productionTimeId = productionTime.Id;
                                    productionExtraDays = productionTime.Extra_Days__c; // Production Time Lookup
                                }
                            } else {
                                System.debug('--- ConfigurationController - Skipping Reclamation Product Pricebook Entry'); 
                                pbEntryId='';                                
                            }

                        } else if (installTimeKeyFound) {
                            installationTime = (Installation_Time__c) installationTimeMap.get(itemLookupCode);
                            System.debug('--- ConfigurationController - Installation Time: '+installationTime);
                            // If Entry exists and is not a Reclamation Product get the Details
                            Boolean installTimeProductKeyFound = installationTimeProductMap.containsKey(itemLookupCode);
                            if (installTimeProductKeyFound) {
                                System.Debug('--- ConfigurationController - Installation Time Item in Map: '+itemLookupCode);
                                installationTimeProduct = (Product2) installationTimeProductMap.get(itemLookupCode);
                                System.debug('--- ConfigurationController - Installation Item Product: '+installationTimeProduct);
                                installationTimeId = installationTime.Id;
                                itemProductId = installationTime.Product__c; // reference to Product2 Record
                                installationHours = installationTime.Hours__c; // Installation Time Lookup
                                installationMins = installationTime.Minutes__c; // Installation Time Lookup
                                installationUoM = installationTimeProduct.QuantityUnitOfMeasure;
                                installationCostType = installationTimeProduct.Cost_Type__c;
                                installationCostCategory = installationTimeProduct.Cost_Category__c;                      
                                installationProductCategory = installationTimeProduct.Product_Category__c;
                                installationProductType = installationTimeProduct.Product_Type__c;
                                installationProductItem = installationTimeProduct.Product_Item__c;
                                installationProductName = installationTimeProduct.Name;
                            }
                        } else {
                            System.debug('--- ConfigurationController - NO Pricebook Entry or Installation Time for Item '+itemLookupCode); 
                        }
                        // Continue only if there was a Pricebook Entry or Installaton Time Found
                        if (String.isNotBlank(itemProductId)){
                            // Set New or Changed Configuration Option Identifiers based on parsed Visual Pricing File Content
                            visualStructure = visualConfigObject.products[k].rvn;
                            visualProductId = visualConfigObject.products[k].Id;
                            visualItemAmount = visualConfigObject.products[k].priceParameters[l].Amount;
                            visualItemSalesCode = visualConfigObject.products[k].priceParameters[l].SalesCode;
                            // Loop Existing Configuration Products to find Id


                            if (existingProducts.size()>0) {   
                                Map<String,Configuration_Product__c> structureToProductMap =  getStructureToProductMap(existingProducts);
                                Boolean isProductExisting = structureToProductMap.containsKey(visualStructure);
                                if (isProductExisting) {
                                    Configuration_Product__c existingProduct = structureToProductMap.get(visualStructure);
                                    existingProductId = existingProduct.Id;

                                } else {
                                    existingProductId = '';
                                }
                                /*for (Configuration_Product__c existingProduct : existingProducts) {
                                    if (existingProduct.Visual_Structure_Number__c == visualStructure
                                        && existingProduct.Visual_Product_Id__c == visualProductId) { // By SAI 24.02.2023
                                            existingProductId = existingProduct.Id;
                                        System.debug('--- ConfigurationController - Found matching Configuration Product: '+existingProductId); 
                                    } else {
                                        System.debug('--- ConfigurationController - No matching Configuration Product with Code: '+productLookupCode); 
                                        existingProductId = ''; // By SAI 24.02.2023
                                    }
                                }*/
                            }
                            String existingItemId; // Fix made to reset existingItem value SAI 24.02.2023
                            // Loop Existing Configuration Items to find Id
                            Map<String,Configuration_Option__c> uniqueIdToOptionMap = getUniqueIdToOptionMap(existingItems);
                            String uniqueId;
                            uniqueId = String.valueOf(itemCounter); 
                            uniqueId += '-'+visualProductName; // Visual Product Name
                            uniqueId += '-'+visualItemSalesCode;// Visual Price Parameter Sales Code
                            
                            uniqueId += '-'+String.valueOf(Decimal.valueOf(visualItemAmount).setScale(5)); // Visual Price Parameter Amount*
                            Boolean isOptionExisting = uniqueIdToOptionMap.containsKey(uniqueId);
                            if (isOptionExisting) {
                                Configuration_Option__c existingItem = uniqueIdToOptionMap.get(uniqueId);
                                existingItemId = existingItem.Id;
                            } else {
                                existingItemId = '';
                            }                        
                            // prepare Configuration Item from Visual Data
                            Configuration_Option__c itemToUpsert = new Configuration_Option__c();
                            // Add Existing Item Id else set Parent Record
                            if (String.isNotBlank(existingItemId)){
                                itemToUpsert.Id = existingItemId;
                            } else {
                                itemToUpsert.Configuration_Product__c = existingProductId; // Parent Record = Configuration Product
                            }
                            // Update Configuration Item Visual Attributes
                            itemToUpsert.Local_Supplier__c= visualconfigObject.products[k].priceparameters[l].LocalSupplier;
                            itemToUpsert.Parameter_code__c = visualconfigObject.products[k].priceparameters[l].ParameterCode;
                            itemToUpsert.Sales_Code__c = visualconfigObject.products[k].priceparameters[l].SalesCode;
                            //itemToUpsert.Unique_Id__c = visualconfigObject.products[k].priceparameters[l].UniqueId;
                            itemToUpsert.Unit_Of_Measure__c = visualconfigObject.products[k].priceparameters[l].Unit;
                            
                            // Update Configuration Item for use in Pricing
                            itemToUpsert.Product_Group__c = visualconfigObject.products[k].name;
                            itemToUpsert.Quantity__c = visualconfigObject.products[k].priceparameters[l].Amount;
                            itemToUpsert.Line_Number__c = itemCounter;

                            // Product Identifiers
                            itemToUpsert.Product__c = itemProductId; 
                            itemToUpsert.Product_Code__c = itemLookupCode; 

                            // Pricing Variables
                            if (String.isNotBlank(pbEntryId)){
                                itemToUpsert.Unit_Of_Measure__c = pbEntryUoM;
                                itemToUpsert.Cost_Type__c = pbEntryCostType;
                                itemToUpsert.Cost_Category__c = pbEntryCostCategory;                            
                                itemToUpsert.Product_Category__c = pbEntryProductCategory;
                                itemToUpsert.Product_Type__c = pbEntryProductType;
                                itemToUpsert.Product_Item__c = pbEntryProductItem;
                                itemToUpsert.Name = pbEntryName +' '+itemToUpsert.Quantity__c+' '+pbEntryUoM;
                                itemToUpsert.isInstallationTime__c = false;
                                // Add Production Times 05.04.2024
                                itemToUpsert.Production_Extra_Days__c = productionExtraDays;
                                System.Debug('--- ConfigurationController - Configuration Item: '+itemToUpsert);
                            } else if (String.isNotBlank(installationTimeId)){
                                itemToUpsert.Unit_Of_Measure__c = installationUoM;
                                itemToUpsert.Cost_Type__c = installationCostType;
                                itemToUpsert.Cost_Category__c = installationCostCategory;                            
                                itemToUpsert.Product_Category__c = installationProductCategory;
                                itemToUpsert.Product_Type__c = installationProductType;
                                itemToUpsert.Product_Item__c = installationProductItem;
                                itemToUpsert.Name = installationProductName +' '+itemToUpsert.Quantity__c+' '+installationUoM;
                                itemToUpsert.Installation_Time_Per_Unit__c = installationHours;
                                itemToUpsert.Installation_Hours__c = installationHours*itemToUpsert.Quantity__c;
                                itemToUpsert.isInstallationTime__c = true;
                                System.Debug('--- ConfigurationController - Installation Item: '+itemToUpsert);
                            }
                            // Add updated Item Record to Collection
                            itemsToUpsert.add(itemToUpsert); 
                        }
                    }
					// List<Configuration_Option__c> specialOptions = SpecialProductsService.createAdditionalSpecialProducts(itemsToUpsert, itemCounter);
					// if(!specialOptions.isEmpty()){
					// 	itemsToUpsert.addAll(specialOptions);
					// 	update SpecialProductsService.setSpecialFlagForVisualConfiguration(itemsToUpsert);
					// }
                }
                System.debug('--- ConfigurationController - '+itemsToUpsert.size()+' Configuration Item(s) to Create or Update');
                    
                if (itemsToUpsert.size()>0) {
                    // For Reclamation when there is items to upsert check if there is "products" reclaimed
                    upsert itemsToUpsert;
                    upsertedItemIds = new List<Id>(new Map<Id, Configuration_Option__c>(itemsToUpsert).keySet()); 
                }
                System.debug('--- ConfigurationController - '+upsertedItemIds.size()+ ' Configuration Items(s) Created or Updated');
                // Get Existing Configuration Items to Delete
                List<Configuration_Option__c> obsoleteItems = New List<Configuration_Option__c>();
                System.debug('--- ConfigurationController - existingProductIds: '+existingProductIds);
                obsoleteItems = ([SELECT Id                                  
                                    FROM Configuration_Option__c
                                    WHERE Configuration_Product__c IN: existingProductIds 
                                    AND Id NOT IN :upsertedItemIds
                                    ORDER BY CreatedDate DESC]);
                System.debug('--- ConfigurationController - '+obsoleteItems.size()+' Configuration Item(s) to Delete');
                if (obsoleteItems.size()>0) {
                    delete obsoleteItems;
                }
            }
            // Step 9: Process the Configuration Messages
            if (visualConfigObject !=null && visualConfigProducts.size()>0 ){
                for (Integer k=0;k<visualConfigProducts.size();k++){
                    Integer productCounter = k+1;
                    // Process the Visual Configuration Messages
                    if(visualConfigObject.products[k].productInspectMessageKeys != null){
                        visualConfigMessages = visualConfigObject.products[k].productInspectMessageKeys;
                        System.debug('--- ConfigurationController - '+visualConfigMessages.size()+' Visual Configuration Message(s)');
                        messageCount = visualConfigMessages.size();
                        System.debug('--- ConfigurationController - '+messageCount+' Visual Configuration Message(s)');
                    }
                    if (visualConfigMessages.size()>0) {
                        // Loop through the Visual Configuration Messages
                        for (Integer l = 0; l < messageCount; l++) {  
                            Integer msgCounter = l+1;
                            System.debug('--- ConfigurationController - Processing Visual Configuration Message '+msgCounter+' of '+messageCount);
                            Configuration_Message__c configurationMessage = new Configuration_Message__c(); // New or Changed Configuration Message as in File configJSON
                            // Continue only if there was a Pricebook Entry Found
                            if (String.isNotBlank(pbEntryId)){
                                // Set New or Changed Configuration Option Identifiers based on parsed Visual Pricing File Content
                                visualStructure = visualConfigObject.products[k].rvn;
                                visualProductId = visualConfigObject.products[k].Id;
                                // Loop Existing Configuration Products to find Id
                                if (existingProducts.size()>0) {    
                                    for (Configuration_Product__c existingProduct : existingProducts) {
                                        if (existingProduct.Visual_Structure_Number__c == visualStructure) {
                                            //&& existingProduct.Visual_Product_Id__c == visualProductId) { // By SAI 24.02.2023
                                                existingProductId = existingProduct.Id;
                                        }
                                    }
                                }                        
                                // prepare Configuration Message from Visual Data
                                Configuration_Message__c messageToInsert = new Configuration_Message__c();
                                messageToInsert.Configuration_Product__c = existingProductId; // Parent Record = Configuration Product
                                // Update Configuration Item Visual Attributes
                                messageToInsert.Inspect_Message__c= visualconfigObject.products[k].productInspectMessageKeys[l].InspectMessage;
                                messageToInsert.Message_Key__c = visualconfigObject.products[k].productInspectMessageKeys[l].MessageKey;
                                if (visualconfigObject.products[k].productInspectMessageKeys[l].SpaceSideNumber != null
                                    && visualconfigObject.products[k].productInspectMessageKeys[l].SpaceSideNumber.isNumeric()) {
                                    messageToInsert.Space_Side_Number__c
                                        = Integer.valueOf(visualconfigObject.products[k].productInspectMessageKeys[l].SpaceSideNumber);
                                }
                                // Add updated Item Record to Collection
                                messagesToUpsert.add(messageToInsert); 
                            }         
                        }
                    }
                }
                System.debug('--- ConfigurationController - '+messagesToUpsert.size()+' Configuration Message(s) to Create');
                    
                if (messagesToUpsert.size()>0) {
                    insert messagesToUpsert;
                    upsertedMessageIds = new List<Id>(new Map<Id, Configuration_Message__c>(messagesToUpsert).keySet());
                }
                System.debug('--- ConfigurationController - '+upsertedMessageIds.size()+ ' Configuration Message(s) Created or Updated');
                // Get Existing Configuration Messages to Delete
                List<Configuration_Message__c> obsoleteMessages = New List<Configuration_Message__c>();
                obsoleteMessages = ([SELECT Id                                  
                                    FROM Configuration_Message__c
                                    WHERE Configuration_Product__c IN: existingProductIds 
                                    AND Id NOT IN :upsertedMessageIds
                                    ORDER BY CreatedDate DESC]);
                System.debug('--- ConfigurationController - '+obsoleteMessages.size()+' Configuration Message(s) to Delete');
                if (obsoleteMessages.size()>0) {
                    delete obsoleteMessages;
                }
            }
            successMessage='SUCCESS - Processing Configuration Finished!';
        } catch (Exception e) {
            System.debug('--- ConfigurationController - The following exception has occurred: ' + e.getMessage());
            throw new CustomException(e.getMessage());
        }
        return successMessage;
    } 
    /********* END PROCESSING OF VISUAL PRICING **************/
	@AuraEnabled(cacheable=true)
    public static String processSoveliaConfiguration(String configId, String recordId, String soveliaPricingJSON){
        System.debug('--- ConfigurationController - Parsing File pricingJSON for Configuration Updates');
        String errorMessage;
        String successMessage;
        // Salesforce Configuration Plan Variables
        String configPlanId; // Configuration Id
        Configuration__c existingPlan = New Configuration__c(); // Existing Configuration Plan
        List<Configuration__c> existingPlans = New List<Configuration__c>(); // Existing Configuration Plans 
        List<Id> existingPlanIds = new List<Id>(); // Existing Configuration Plan Ids 
        List<Configuration__c> plansToUpsert = New List<Configuration__c>(); // New or Changed Configuration Configuration Plans
        Integer planCount;

        // Salesforce Configuration Product Variables
        List<String> productRVNs = new List<String>();
        List<Configuration_Product__c> existingProducts = new List<Configuration_Product__c>(); // Existing Configuration Products
        List<Id> existingProductIds = new List<Id>(); // Existing Configuration Product Ids 
        List<Id> upsertedProductIds = new List<Id>(); 
        Integer productCount;
        
        // Salesforce Configuration Item Variables
        List<Configuration_Option__c> existingItems = new List<Configuration_Option__c>(); // Existing Configuration Items
        List<Configuration_Option__c> itemsToUpsert = new List<Configuration_Option__c>(); // New or Changed Configuration Items as in File soveliaPricingJSON
        List<Id> existingItemIds = new List<Id>(); // Existing Configuration Option Ids 
        List<Id> upsertedItemIds = new List<Id>();
        Integer itemCount;

        // Salesforce Configuration Message Variables
        List<Configuration_Message__c> existingMessages = new List<Configuration_Message__c>(); // Existing Configuration Messages
        Configuration_Message__c updatedMessage = new Configuration_Message__c();
        List<Configuration_Message__c> messagesToUpsert = new List<Configuration_Message__c>(); // New or Changed Configuration Messages as in File soveliaPricingJSON
        List<Id> existingMessageIds = new List<Id>();
        List<Id> upsertedMessageIds = new List<Id>();
        
        Integer messageCount;

        // Salesforce Parent Record Variables
        String parentObjectType;
        Opportunity opportunityRecord;
        Quote quoteRecord;
        Case caseRecord;
        Order orderRecord;
        WorkOrder workorderRecord;

        // Salesforce Pricing Attributes
        String opportunityNumber; // Number of the Opportunity, used for RVN on New Plan
        String pricebookId; // Pricebook Id
        String currencyCode; // Currency

        // Salesforce Product Lookup Variables
        String itemLookupCode; // Product Item Identifier
        String productLookupCode; // Product Identifier

        // Salesforce PriceBook2 Variables
        String pbEntryId; // Pricebook Entry Id
        String pbEntryProductId; // Pricebook Entry Product Id
        String pbEntryProductCode;// Code of the Product
        String pbEntrySalesCode;
        String pbEntryName; // Pricebook Entry Product Name
        String pbEntryUoM; // Pricebook Entry Product UoM 
        String pbEntryCostCategory; // Grouping of Cost Types for Order XML data prep
        String pbEntryCostType; // Grouping of Product for Pricing data prep
        String pbEntryProductCategory; // Product Category of the Product
        String pbEntryProductType;// Product Type of the Product
        String pbEntryProductItem;// Product Type of the Product
        Decimal pbEntryStandardPrice;// Standard Price of the Product
        Decimal pbEntryUnitPrice;// List Price of the Product
        PricebookEntry pbEntry; // Pricebook Entry Record
        Map<String, PricebookEntry> pricebookEntryConfigurationProductMap = new Map<String, PricebookEntry>();  // Normal or Reclamation pbentries used for Configuration Products
        Map<String, PricebookEntry> pricebookEntryMap = new Map<String, PricebookEntry>();  // Map for Lookup of Product and Prices
        
        // Salesforce Installation Time Variables
        String installationTimeId; // Installation Time  Id
        Decimal installationHours;
        Decimal installationMins;
        String installationUoM;
        String installationCostType;
        String installationCostCategory;                            
        String installationProductCategory;
        String installationProductType;
        String installationProductItem;
        String installationProductName;
        Installation_Time__c installationTime; // Installation Time Record
        Map<String,Installation_Time__c> installationTimeMap  = New Map<String,Installation_Time__c>();  // Map for Lookup of Product and installation Times
        Product2 installationTimeProduct;
        // Salesforce Installation Time Product Variables
        Map<String,Product2> installationTimeProductMap = New Map<String,Product2>();
        // Salesforce Production Time Variables
        String productionTimeId; // Production Time  Id
        Decimal productionDays;
        Decimal productionExtraDays;
        Production_Time__c productionTime; // Production Time Record
        Map<String,Production_Time__c> productionTimeMap  = New Map<String,Production_Time__c>();  // Map for Lookup of Product and Production Times
        Product2 productionTimeProduct;// Salesforce Product2 Variables
        //String productId; // Product2 Id
        String existingProductId;
        String itemProductId;
        
        // Sovelia Configuration Variables
        String soveliaPlanId; // Sovelia Plan Id
        SoveliaConfiguration soveliaConfigObject = new SoveliaConfiguration(); // Parsed Sovelia Configuration Result Object 
        // String soveliaStructure; // Sovelia Structure Id
        String soveliaProductId; // Sovelia Product Id
        List<String> structureNumbers = new List<String>(); 
        List<SoveliaConfiguration.Product> soveliaConfigProducts = new List<SoveliaConfiguration.Product>(); // Products from Parsed Result Object    
        Double soveliaItemAmount; // Sovelia Param Quantity 
        String soveliaItemSalesCode; // Sovelia Param Code
        String soveliaItemCostCategory; // Cost Category
        String soveliaItemCostType; // Cost Type

        List<Object> soveliaConfigItems = new List<Object>(); // Product Items from Parsed Result Object   
        List<Object> soveliaConfigMessages = new List<Object>(); // Product Messages from Parsed Result Object  
        
        // Step 0: Check for Existing Configuration Records
        try {
            // Step 1: Validated the parent RecordId
            if (String.IsNotBlank(recordId)){
                parentObjectType = getObjectType(recordId);
                System.debug('--- ConfigurationController - Process Configurations for Object '+parentObjectType+' with Id '+recordId);
            } else {
                errorMessage = 'No Parent Object identified!';
                System.debug('--- ConfigurationController - ABORT '+errorMessage);
                throw new CustomException(errorMessage);
            } 
            // Step 2: Get the Parent Object
            if (String.IsNotBlank(recordId) && parentObjectType=='Opportunity') {
                // Get Related Opportunity Record
                opportunityRecord = OpportunityController.getOpportunityRecord(recordId);
                // Set Related Records
                pricebookId = opportunityRecord.pricebook2Id;                      
                currencyCode = opportunityRecord.CurrencyIsoCode; 
                opportunityNumber = opportunityRecord.Opportunity_Number__c;
            } else {
                errorMessage = 'No Opportunity Identified!';
                System.debug('--- ConfigurationController - ABORT '+errorMessage);
                throw new CustomException(errorMessage);
            } 
            // Step 3: Get the Pricebook Entries
            if (String.IsNotBlank(pricebookId)) {
                // Get Sellable Products from Opportunity Pricebook
                pricebookEntryConfigurationProductMap = PriceBookEntryController.getPricebookEntryMap(pricebookId, currencyCode, opportunityRecord);
                pricebookEntryMap = PriceBookEntryController.getPricebookEntryMap(pricebookId, currencyCode);
                System.debug('--- ConfigurationController - '+pricebookEntryMap.size()+' sellable  Product(s)');
                // Get Installable Products from installation Times         
                Boolean isActive = true;
                installationTimeMap = InstallationTimeController.getInstallationTimeMap(isActive);
                System.debug('--- ConfigurationController - '+installationTimeMap.size()+' Installation Time(s)');
                // Get Installable Products from Product2   
                installationTimeProductMap = InstallationTimeController.getInstallationTimeProductMap(isActive);
                System.debug('--- ConfigurationController - '+installationTimeProductMap.size()+' Installation Time Product(s)');
            } else {
                errorMessage = 'No Pricebook Defined!';
                System.debug('--- ConfigurationController - ABORT '+errorMessage);
                throw new CustomException(errorMessage);
            } 
            // Step 4: Get the Sovelia Configuration by parsing the pricing File content = soveliaPricingJSON
            if (String.IsNotBlank(soveliaPricingJSON)) {
                // Get Products from Sovelia Pricing JSON
                soveliaConfigObject = getSoveliaConfigurationObjects(soveliaPricingJSON);  
                soveliaConfigProducts = soveliaConfigObject.products;
            } else {
                errorMessage = 'No Pricing File Content to Process!';
                System.debug('--- ConfigurationController - ABORT '+errorMessage);
                throw new CustomException(errorMessage);
            } 
            // Step 5: Get the Configuration Plan
            if (soveliaConfigObject !=null) {
                // Check for Existing Plans by configId, (parent) recordId or SoveliaPlanId
                existingPlans = ConfigurationController.getAllConfigurations(configId,recordId,soveliaPlanId);
                existingPlanIds = new List<Id>(new Map<Id, Configuration__c>(existingPlans).keySet()); 
                System.debug('--- ConfigurationController - '+existingPlans.size()+' Existing Configuration(s)');           
                for (Configuration__c planToUpsert : existingPlans){
                    // Prepare Plan to Insert or Update
                    if (!String.isBlank(configId)){
                        planToUpsert.Id = configId; // Parent Record = Configuration
                    } else {
                        configId = planToUpsert.Id;
                    }
                    // Update the Plan with Values from the New or Changed Pricing File Content
                    planToUpsert.Name = soveliaConfigObject.Name;
                    // Set Plan Values based on Sovelia Update
                    //planToUpsert.Plan_Apartment__c = soveliaConfigObject.apartment;
                    //if (soveliaConfigObject.floor != null && soveliaConfigObject.floor.isNumeric()) {
                    //    planToUpsert.Plan_Floor__c = Integer.valueOf(soveliaConfigObject.floor);
                    //}
                    //planToUpsert.Plan_Line__c = soveliaConfigObject.line;
                    planToUpsert.Plan_Name__c = soveliaConfigObject.name;
                    planToUpsert.Sovelia_Id__c = soveliaConfigObject.id;
                    planToUpsert.Sovelia_Version__c = soveliaConfigObject.version; 
                    // Store the Pricing JSON in the Configuration Record
                    planToUpsert.Sovelia_Pricing_JSON__c = soveliaPricingJSON;
                    planToUpsert.Sovelia_Products_JSON__c = JSON.serialize(soveliaConfigProducts);
                    planToUpsert.OwnerId = opportunityRecord.OwnerId;
                    // Created or Update the Configuration Record
                    upsert planToUpsert;
                    // Add the New or Changed Plan to Collection
                    plansToUpsert.add(planToUpsert);  
                }
                System.debug('--- ConfigurationController - '+plansToUpsert.size()+' New or Changed Configuration Plan(s)');   
            } else {
                errorMessage = 'No Sovelia Configuration Object to Process!';
                System.debug('--- ConfigurationController - ABORT '+errorMessage);
                throw new CustomException(errorMessage);
            } 
            // Step 6: Get the Configuration Products
            // Process the Sovelia Configuration Products
            productCount = soveliaConfigProducts.size();
            System.debug('--- ConfigurationController - '+productCount+' Sovelia Configuration Product(s)');
            if (soveliaConfigObject !=null && productCount>0){               
                List<Configuration_Product__c> productsToUpsert = new List<Configuration_Product__c>(); // New or Changed Configuration Products as in File soveliaPricingJSON
                // Check for Existing Products by configId, (parent) recordId or SoveliaPlanId
                existingProducts = ConfigurationController.getConfigurationProducts(existingPlanIds);
                System.debug('--- ConfigurationController - '+existingProducts.size()+' Existing Configuration Product(s)'); 
                if (existingProducts.size()>0) {   
                    // !! soveliaStructure is always empty here
                    // Map<String,Configuration_Product__c> structureToProductMap =  getStructureToProductMap(existingProducts);
                    // Boolean isProductExisting = structureToProductMap.containsKey(soveliaStructure);
                    // if (isProductExisting) {
                    //     Configuration_Product__c existingProduct = structureToProductMap.get(soveliaStructure);
                    //     existingProductId = existingProduct.Id;
                    // } else {
                    //     existingProductId = '';
                    // } 
                } 
                // Loop through the Sovelia Configuration Products
                for (Integer j = 0; j < productCount; j++) {  
                    Integer productCounter = j+1;
                    System.debug('--- ConfigurationController - Processing Sovelia Configuration Product '+productCounter+' of '+productCount);
                    Configuration_Product__c configurationProduct = new Configuration_Product__c(); // New or Changed Configuration Product as in File configJSON
                    // Find the Pricebook Entry for the Configuration Product                  
                    if (soveliaConfigObject.products[j].id == '30310020') {
                        productLookupCode = 'VISORBLINDSALES'; 
                    } else {
                        productLookupCode = soveliaConfigObject.products[j].name;   
                    }
                    // Check if productCode is in the pricebookEntry Map
                    Boolean pbEntryKeyFound = pricebookEntryConfigurationProductMap.containsKey(productLookupCode);
                    Boolean productionTimeKeyFound = productionTimeMap.containsKey(productLookupCode);
                    // if Entry exists retrieve it else just log it
                    pbEntryId=''; 
                    if(pbEntryKeyFound) {   
                        pbEntry = (PricebookEntry) pricebookEntryConfigurationProductMap.get(productLookupCode);
                        System.debug('--- ConfigurationController - Found Product Pricebook Entry '+pbEntry+' for ProductCode '+productLookupCode); 
                        System.debug('--- ConfigurationController - pbEntry.Product2.Sales_Code__c'+pbEntry.Product2.Sales_Code__c);
                        // If Entry exists and is not a Reclamation Product get the Details
                        if (!pbEntry.Product2.Reclamation__c) {
                            pbEntryProductId = pbEntry.Product2Id; // reference to Product2 Record
                        } else if (opportunityRecord.Order_Type__c == 'Reclamation' 
                                    && pbEntry.Product2.Reclamation__c) {
                            pbEntryProductId = pbEntry.Product2Id; // reference to Product2 Record
                        }
                        if (String.isNotBlank(pbEntryProductId)){
                            pbEntryId = pbEntry.Id;// reference to Pricebook Entry Record
                            pbEntryUoM = pbEntry.Product2.QuantityUnitOfMeasure; // Unit Of Measure of the Product
                            pbEntryName = pbEntry.Product2.Name;// Name of the Product
                            pbEntryProductCode = pbEntry.Product2.ProductCode;// Code of the Product
                            pbEntrySalesCode = pbEntry.Product2.Sales_Code__c;// Code of the Product
                            pbEntryCostCategory = pbEntry.Product2.Cost_Category__c; // Cost Category of the Product
                            pbEntryCostType = pbEntry.Product2.Cost_Type__c;// Cost Type of the Product
                            pbEntryProductCategory = pbEntry.Product2.Product_Category__c; // Product Category of the Product
                            pbEntryProductType = pbEntry.Product2.Product_Type__c;// Product Type of the Product
                            pbEntryProductItem = pbEntry.Product2.Product_Item__c;// Product Item of the Product
                            // Add Production Times
                            if (productionTimeKeyFound) {
                                productionTime = (Production_Time__c) productionTimeMap.get(itemLookupCode);
                                // If Entry exists then add the production time to Configuration Option
                                productionTimeId = productionTime.Id;
                                productionDays = productionTime.Days__c; // Production Time Lookup
                                //productionExtraDays = productionTime.Extra_Days__c; // Production Time Lookup
                            }
                        } else {
                            System.debug('--- ConfigurationController - No Pricebook Entry Product'); 
                        }
                    }  else {
                        System.debug('--- ConfigurationController - NO Pricebook Entry for Product '+productLookupCode); 
                        pbEntryId=''; 
                    }
                    
                    // Continue only if there was a Pricebook Entry Found
                    if (String.isNotBlank(pbEntryId)){
                        Configuration_Product__c productToUpsert = new Configuration_Product__c(); // Fix made to reset producttoupsert SAI 24.02.2023
                        // Set New or Changed Configuration Product Identifiers based on parsed Sovelia Pricing File Content
                        String soveliaStructure = soveliaConfigObject.products[j].rvn.substring(8, 16);
                        soveliaProductId = soveliaConfigObject.products[j].id;
                        //System.debug('--- ConfigurationController - Check for Configuration Product(s) with Sovelia Product Id '+soveliaProductId+' and Structure '+soveliaStructure); 
                        // Check Existing Configuration Products to find Id needed in upsert
                        // Loop Existing Configuration Products to find Id
                        Configuration_Product__c existingConfigurationProduct = null;
                        if (existingProducts.size()>0) {    
                            for (Configuration_Product__c existingProduct : existingProducts) {
                                if (existingProduct.RVN__c == opportunityNumber + soveliaStructure) {
                                    existingProductId = existingProduct.Id;
                                    existingConfigurationProduct = existingProduct;
                                } else {
                                    System.debug('--- ConfigurationController - No matching Configuration Product with Code: '+productLookupCode); 
                                    existingProductId = ''; // By SAI 24.02.2023
                                }
                            }
                        } else {
                            System.debug('--- ConfigurationController - No Existing Configuration Product(s)');
                        }
                        System.debug('--- ConfigurationController - Checking Configuration Product for Plan with Id: '+configId);
                        if (String.isNotBlank(existingProductId)){
                            productToUpsert.Id = existingProductId;
                            System.debug('--- ConfigurationController - Use Existing Configuration Product with Id: '+existingProductId);
                            if(existingConfigurationProduct?.Configuration__c != null) {
                                productToUpsert.Configuration__c = existingConfigurationProduct.Configuration__c;
                            }
                        } else {
                            productToUpsert.Configuration__c = configId; // Parent Record = Configuration
                            System.debug('--- ConfigurationController - Add Configuration Product to Plan with Id: '+configId);
                        }
                        // Set Values for the New or Changed Configuration Product based on parsed Sovelia Pricing File Content                        
                        productToUpsert.Product_Group__c = soveliaConfigObject.products[j].name; // Product Name in Sovelia is Product Group in Salesforce
                        productToUpsert.Sovelia_Product_Id__c = soveliaProductId; // Unique Sovelia Product Id,not used in Salesforce
                        productToUpsert.Sovelia_Structure_Number__c = soveliaStructure; // Unique Sovelia Product RVN is actually Structure number
                        // Variables relevant in Salesforce for Pricing etc
                        productToUpsert.Product__c = pbEntryProductId; // Reference to the related Product2 record in Salesforce
                        productToUpsert.Name = pbEntryName; // Use the Name of the Product2 record in Salesforce
                        productToUpsert.Quantity__c = 1; // As this is a Configurable Product Quantity must be 1
                        productToUpsert.Cost_Category__c = pbEntryCostCategory;
                        productToUpsert.Cost_Type__c = pbEntryCostType;
                        productToUpsert.Product_Category__c = pbEntryProductCategory;
                        productToUpsert.Product_Type__c = pbEntryProductType;
                        productToUpsert.Product_Item__c = pbEntryProductItem;
                        // Set the RVN Number to Opportunity Number + StructureNumber
                        String structureNumber = productToUpsert.Sovelia_Structure_Number__c;
                        productToUpsert.RVN_Number__c = opportunityNumber + structureNumber;
                        
                        // upsert soveliaProduct;
                        // Add updated Product Record to Collection
                        productsToUpsert.add(productToUpsert);    
                        
                        //System.debug('--- ConfigurationController - Adding Configuration Product '+productToUpsert);            
                    }   
                }
                System.debug('--- ConfigurationController - '+productsToUpsert.size()+' Configuration Products to Create or Update');
                if (productsToUpsert.size()>0) {
                    upsert productsToUpsert;
                }
                upsertedProductIds = new List<Id>(new Map<Id, Configuration_Product__c>(productsToUpsert).keySet()); 
                System.debug('--- ConfigurationController - '+upsertedProductIds.size()+ ' Configuration Product(s) Created or Updated');
                // Get Existing Configuration Products to Delete
                List<Configuration_Product__c> obsoleteProducts = New List<Configuration_Product__c>();
                obsoleteProducts = ([SELECT Id                                  
                                    FROM Configuration_Product__c
                                    WHERE Configuration__c =: configId 
                                    AND Id NOT IN :upsertedProductIds
                                    ORDER BY CreatedDate DESC]);
                System.debug('--- ConfigurationController - '+obsoleteProducts.size()+' Configuration Product(s) to Delete');
                if (obsoleteProducts.size()>0) {
                    delete obsoleteProducts;
                }
            }
            // Step 7: Get the Configuration Items
            if (upsertedProductIds.size()>0 && upsertedProductIds != null){
                // Check for Existing Products by configId, (parent) recordId or SoveliaPlanId
                existingProducts = ConfigurationController.getConfigurationProductsById(upsertedProductIds);
                existingProductIds =  new List<Id>(new Map<Id, Configuration_Product__c>(existingProducts).keySet()); 
                System.debug('--- ConfigurationController - '+existingProducts.size()+' Existing Configuration Product(s)');
                // Check for Existing Items by (parent) product, Structure Number or RVN
                existingItems = ConfigurationController.getConfigurationOptions(upsertedProductIds);
                System.debug('--- ConfigurationController - '+existingItems.size()+' Existing Configuration Item(s)'); 
                // Check for Existing Messages by (parent) product, Structure Number or RVN
                existingMessages = ConfigurationController.getConfigurationMessages(upsertedProductIds);
                System.debug('--- ConfigurationController - '+existingMessages.size()+' Existing Configuration Message(s)'); 
            }
            // Step 8: Process the Configuration Items
            if (soveliaConfigObject !=null && productCount>0){
                for (Integer k=0;k<soveliaConfigProducts.size();k++){
                    String soveliaProductName = soveliaConfigObject.products[k].name;  
                    productLookupCode = soveliaProductName;  
                    //System.debug('--- ConfigurationController - Processing Sovelia Configuration Item(s) for Product '+productLookupCode);
                    Integer productCounter = k+1;
                    //System.debug('--- ConfigurationController - Processing Sovelia Configuration Product '+productCounter+' of '+soveliaConfigProducts.size());
                    // Process the Sovelia Configuration Products
                    soveliaConfigItems = soveliaConfigObject.products[k].priceParameters;
                    itemCount = soveliaConfigItems.size();
                    System.debug('--- ConfigurationController - '+itemCount+' Sovelia Configuration Item(s)');
                    // Loop through the Sovelia Configuration Items
                    for (Integer l = 0; l < itemCount; l++) {  
                        Integer itemCounter = l+1;
                        //System.debug('--- ConfigurationController - Processing Sovelia Configuration Item '+itemCounter+' of '+itemCount);
                        Configuration_Option__c configurationItem = new Configuration_Option__c(); // New or Changed Configuration Item as in File configJSON
                        // Find the Pricebook Entry for the Configuration Item
                          
                        String salesCode = soveliaConfigObject.products[k].priceParameters[l].SalesCode;
                        itemLookupCode = productLookupCode+'-'+salesCode;          
                        //System.debug('--- ConfigurationController - Lookup Pricebook Entry for itemCode '+itemLookupCode);
                        // Check if itemCode is in the pricebookEntry Map
                        Boolean pbEntryKeyFound = pricebookEntryMap.containsKey(itemLookupCode);
                        Boolean installTimeKeyFound = installationTimeMap.containsKey(itemLookupCode);
                        Boolean productionTimeKeyFound = productionTimeMap.containsKey(itemLookupCode);

                        // if Entry exists retrieve it else just log it
                        pbEntryId=''; 
                        if(pbEntryKeyFound) {   
                            pbEntry = (PricebookEntry) pricebookEntryMap.get(itemLookupCode);
                            // If Entry exists and is not a Reclamation Product get the Details
                            if (!pbEntry.Product2.Reclamation__c) {
                                itemProductId = pbEntry.Product2Id;// reference to Product2 Record
                                pbEntryProductId = pbEntry.Product2Id; // reference to Product2 Record
                                pbEntryId = pbEntry.Id;// reference to Pricebook Entry Record
                                pbEntryUoM = pbEntry.Product2.QuantityUnitOfMeasure; // Unit Of Measure of the Product
                                pbEntryName = pbEntry.Product2.Name;// Name of the Product
                                pbEntryProductCode = pbEntry.Product2.ProductCode;// Unique Code of the Product
                                pbEntrySalesCode = pbEntry.Product2.Sales_Code__c;// Sales Code of the Product
                                pbEntryCostCategory = pbEntry.Product2.Cost_Category__c; // Cost Category of the Product
                                System.debug('--- ConfigurationController - Found Reclamation Product Cost Category '+pbEntryCostCategory); 
                                pbEntryCostType = pbEntry.Product2.Cost_Type__c;// Cost Type of the Product
                                System.debug('--- ConfigurationController - Found Reclamation Product Cost Type '+pbEntryCostType); 
                                pbEntryProductCategory = pbEntry.Product2.Product_Category__c; // Product Category of the Product
                                pbEntryProductType = pbEntry.Product2.Product_Type__c;// Product Type of the Product
                                pbEntryProductItem = pbEntry.Product2.Product_Item__c;// Product Item of the Product
                                // Add Production Times 05.04.2024
                                if (productionTimeKeyFound) {
                                    productionTime = (Production_Time__c) productionTimeMap.get(itemLookupCode);
                                    // If Entry exists then add the production time to Configuration Option
                                    productionTimeId = productionTime.Id;
                                    //productionDays = productionTime.Days__c; // Production Time Lookup
                                    productionExtraDays = productionTime.Extra_Days__c; // Production Time Lookup
                                }
                            } else {
                                System.debug('--- ConfigurationController - Skipping Reclamation Product Pricebook Entry'); 
                                pbEntryId='';                                
                            }
                        } else if (installTimeKeyFound) {
                            installationTime = (Installation_Time__c) installationTimeMap.get(itemLookupCode);
                            // If Entry exists and is not a Reclamation Product get the Details
                            Boolean installTimeProductKeyFound = installationTimeProductMap.containsKey(itemLookupCode);
                            if (installTimeProductKeyFound) {
                                installationTimeProduct = (Product2) installationTimeProductMap.get(itemLookupCode);
                                installationTimeId = installationTime.Id;
                                itemProductId = installationTime.Product__c; // reference to Product2 Record
                                installationHours = installationTime.Hours__c; // Installation Time Lookup
                                installationMins = installationTime.Minutes__c; // Installation Time Lookup
                                installationUoM = installationTimeProduct.QuantityUnitOfMeasure;
                                installationCostType = installationTimeProduct.Cost_Type__c;
                                installationCostCategory = installationTimeProduct.Cost_Category__c;                      
                                installationProductCategory = installationTimeProduct.Product_Category__c;
                                installationProductType = installationTimeProduct.Product_Type__c;
                                installationProductItem = installationTimeProduct.Product_Item__c;
                                installationProductName = installationTimeProduct.Name;
                            }
                        } else {
                            System.debug('--- ConfigurationController - NO Pricebook Entry or Installation Time for Item '+itemLookupCode); 
                        }
                        // Continue only if there was a Pricebook Entry or Installaton Time Found
                        if (String.isNotBlank(itemProductId)){
                            // Set New or Changed Configuration Option Identifiers based on parsed Sovelia Pricing File Content
                            String soveliaStructure = soveliaConfigObject.products[k].rvn.substring(8, 16);
                            soveliaProductId = soveliaConfigObject.products[k].Id;
                            soveliaItemAmount = soveliaConfigObject.products[k].priceParameters[l].Amount;
                            soveliaItemSalesCode = soveliaConfigObject.products[k].priceParameters[l].SalesCode;
                            // Loop Existing Configuration Products to find Id


                            if (existingProducts.size()>0) {   
                                Map<String,Configuration_Product__c> structureToProductMap = getStructureToProductMap(existingProducts);
                                Boolean isProductExisting = structureToProductMap.containsKey(soveliaStructure);
                                if (isProductExisting) {
                                    Configuration_Product__c existingProduct = structureToProductMap.get(soveliaStructure);
                                    existingProductId = existingProduct.Id;

                                } else {
                                    existingProductId = '';
                                }
                                /*for (Configuration_Product__c existingProduct : existingProducts) {
                                    if (existingProduct.Sovelia_Structure_Number__c == soveliaStructure
                                        && existingProduct.Sovelia_Product_Id__c == soveliaProductId) { // By SAI 24.02.2023
                                            existingProductId = existingProduct.Id;
                                        System.debug('--- ConfigurationController - Found matching Configuration Product: '+existingProductId); 
                                    } else {
                                        System.debug('--- ConfigurationController - No matching Configuration Product with Code: '+productLookupCode); 
                                        existingProductId = ''; // By SAI 24.02.2023
                                    }
                                }*/
                            }
                            String existingItemId; // Fix made to reset existingItem value SAI 24.02.2023
                            // Loop Existing Configuration Items to find Id
                            Map<String,Configuration_Option__c> uniqueIdToOptionMap = getUniqueIdToOptionMap(existingItems);
                            String uniqueId;
                            uniqueId = String.valueOf(itemCounter); 
                            uniqueId += '-'+soveliaProductName; // Sovelia Product Name
                            uniqueId += '-'+soveliaItemSalesCode;// Sovelia Price Parameter Sales Code
                            
                            uniqueId += '-'+String.valueOf(Decimal.valueOf(soveliaItemAmount).setScale(5)); // Sovelia Price Parameter Amount*
                            Boolean isOptionExisting = uniqueIdToOptionMap.containsKey(uniqueId);
                            if (isOptionExisting) {
                                Configuration_Option__c existingItem = uniqueIdToOptionMap.get(uniqueId);
                                existingItemId = existingItem.Id;
                            } else {
                                existingItemId = '';
                            }                        
                            // prepare Configuration Item from Sovelia Data
                            Configuration_Option__c itemToUpsert = new Configuration_Option__c();
                            // Add Existing Item Id else set Parent Record
                            if (String.isNotBlank(existingItemId)){
                                itemToUpsert.Id = existingItemId;
                            } else {
                                itemToUpsert.Configuration_Product__c = existingProductId; // Parent Record = Configuration Product
                            }
                            // Update Configuration Item Sovelia Attributes
                            itemToUpsert.Local_Supplier__c= soveliaConfigObject.products[k].priceparameters[l].LocalSupplier;
                            itemToUpsert.Parameter_code__c = soveliaConfigObject.products[k].priceparameters[l].ParameterCode;
                            itemToUpsert.Sales_Code__c = soveliaConfigObject.products[k].priceparameters[l].SalesCode;
                            //itemToUpsert.Unique_Id__c = soveliaConfigObject.products[k].priceparameters[l].UniqueId;
                            itemToUpsert.Unit_Of_Measure__c = soveliaConfigObject.products[k].priceparameters[l].Unit;
                            
                            // Update Configuration Item for use in Pricing
                            itemToUpsert.Product_Group__c = soveliaConfigObject.products[k].name;
                            itemToUpsert.Quantity__c = soveliaConfigObject.products[k].priceparameters[l].Amount;
                            itemToUpsert.Line_Number__c = itemCounter;

                            // Product Identifiers
                            itemToUpsert.Product__c = itemProductId; 
                            itemToUpsert.Product_Code__c = itemLookupCode; 

                            // Pricing Variables
                            if (String.isNotBlank(pbEntryId)){
                                itemToUpsert.Unit_Of_Measure__c = pbEntryUoM;
                                itemToUpsert.Cost_Type__c = pbEntryCostType;
                                itemToUpsert.Cost_Category__c = pbEntryCostCategory;                            
                                itemToUpsert.Product_Category__c = pbEntryProductCategory;
                                itemToUpsert.Product_Type__c = pbEntryProductType;
                                itemToUpsert.Product_Item__c = pbEntryProductItem;
                                itemToUpsert.Name = pbEntryName +' '+itemToUpsert.Quantity__c+' '+pbEntryUoM;
                                // Add Production Times
                                //itemToUpsert.Production_Days__c = productionDays; not for config Options
                                itemToUpsert.Production_Extra_Days__c = productionExtraDays;
                            } else if (String.isNotBlank(installationTimeId)){
                                itemToUpsert.Unit_Of_Measure__c = installationUoM;
                                itemToUpsert.Cost_Type__c = installationCostType;
                                itemToUpsert.Cost_Category__c = installationCostCategory;                            
                                itemToUpsert.Product_Category__c = installationProductCategory;
                                itemToUpsert.Product_Type__c = installationProductType;
                                itemToUpsert.Product_Item__c = installationProductItem;
                                itemToUpsert.Name = installationProductName +' '+itemToUpsert.Quantity__c+' '+installationUoM;
                            }
                            // Add updated Item Record to Collection
                            itemsToUpsert.add(itemToUpsert); 
                        }
                    }
                }
                System.debug('--- ConfigurationController - '+itemsToUpsert.size()+' Configuration Item(s) to Create or Update');
                    
                if (itemsToUpsert.size()>0) {
                    upsert itemsToUpsert;
                    upsertedItemIds = new List<Id>(new Map<Id, Configuration_Option__c>(itemsToUpsert).keySet()); 
                }
                System.debug('--- ConfigurationController - '+upsertedItemIds.size()+ ' Configuration Items(s) Created or Updated');
                // Get Existing Configuration Items to Delete
                List<Configuration_Option__c> obsoleteItems = New List<Configuration_Option__c>();
                System.debug('--- ConfigurationController - existingProductIds: '+existingProductIds);
                obsoleteItems = ([SELECT Id                                  
                                    FROM Configuration_Option__c
                                    WHERE Configuration_Product__c IN: existingProductIds 
                                    AND Id NOT IN :upsertedItemIds
                                    ORDER BY CreatedDate DESC]);
                System.debug('--- ConfigurationController - '+obsoleteItems.size()+' Configuration Item(s) to Delete');
                if (obsoleteItems.size()>0) {
                    delete obsoleteItems;
                }
            }
            // Step 9: Process the Configuration Messages
            /*if (soveliaConfigObject !=null && soveliaConfigProducts.size()>0 ){
                for (Integer k=0;k<soveliaConfigProducts.size();k++){
                    Integer productCounter = k+1;
                    // Process the Sovelia Configuration Messages
                    if(soveliaConfigObject.products[k].productInspectMessageKeys != null){
                        soveliaConfigMessages = soveliaConfigObject.products[k].productInspectMessageKeys;
                        System.debug('--- ConfigurationController - '+soveliaConfigMessages.size()+' Sovelia Configuration Message(s)');
                        messageCount = soveliaConfigMessages.size();
                        System.debug('--- ConfigurationController - '+messageCount+' Sovelia Configuration Message(s)');
                    }
                    if (soveliaConfigMessages.size()>0) {
                        // Loop through the Sovelia Configuration Messages
                        for (Integer l = 0; l < messageCount; l++) {  
                            Integer msgCounter = l+1;
                            System.debug('--- ConfigurationController - Processing Sovelia Configuration Message '+msgCounter+' of '+messageCount);
                            Configuration_Message__c configurationMessage = new Configuration_Message__c(); // New or Changed Configuration Message as in File configJSON
                            // Continue only if there was a Pricebook Entry Found
                            if (String.isNotBlank(pbEntryId)){
                                // Set New or Changed Configuration Option Identifiers based on parsed Sovelia Pricing File Content
                                soveliaStructure = soveliaConfigObject.products[k].rvn;
                                soveliaProductId = soveliaConfigObject.products[k].Id;
                                // Loop Existing Configuration Products to find Id
                                if (existingProducts.size()>0) {    
                                    for (Configuration_Product__c existingProduct : existingProducts) {
                                        if (existingProduct.Sovelia_Structure_Number__c == soveliaStructure) {
                                            //&& existingProduct.Sovelia_Product_Id__c == soveliaProductId) { // By SAI 24.02.2023
                                                existingProductId = existingProduct.Id;
                                        }
                                    }
                                }                        
                                // prepare Configuration Message from Sovelia Data
                                Configuration_Message__c messageToInsert = new Configuration_Message__c();
                                messageToInsert.Configuration_Product__c = existingProductId; // Parent Record = Configuration Product
                                // Update Configuration Item Sovelia Attributes
                                messageToInsert.Inspect_Message__c= soveliaConfigObject.products[k].productInspectMessageKeys[l].InspectMessage;
                                messageToInsert.Message_Key__c = soveliaConfigObject.products[k].productInspectMessageKeys[l].MessageKey;
                                if (soveliaConfigObject.products[k].productInspectMessageKeys[l].SpaceSideNumber != null
                                    && soveliaConfigObject.products[k].productInspectMessageKeys[l].SpaceSideNumber.isNumeric()) {
                                    messageToInsert.Space_Side_Number__c
                                        = Integer.valueOf(soveliaConfigObject.products[k].productInspectMessageKeys[l].SpaceSideNumber);
                                }
                                // Add updated Item Record to Collection
                                messagesToUpsert.add(messageToInsert); 
                            }         
                        }
                    }
                }
                System.debug('--- ConfigurationController - '+messagesToUpsert.size()+' Configuration Message(s) to Create');
                    
                if (messagesToUpsert.size()>0) {
                    insert messagesToUpsert;
                    upsertedMessageIds = new List<Id>(new Map<Id, Configuration_Message__c>(messagesToUpsert).keySet());
                }
                System.debug('--- ConfigurationController - '+upsertedMessageIds.size()+ ' Configuration Message(s) Created or Updated');
                // Get Existing Configuration Messages to Delete
                List<Configuration_Message__c> obsoleteMessages = New List<Configuration_Message__c>();
                obsoleteMessages = ([SELECT Id                                  
                                    FROM Configuration_Message__c
                                    WHERE Configuration_Product__c IN: existingProductIds 
                                    AND Id NOT IN :upsertedMessageIds
                                    ORDER BY CreatedDate DESC]);
                System.debug('--- ConfigurationController - '+obsoleteMessages.size()+' Configuration Message(s) to Delete');
                if (obsoleteMessages.size()>0) {
                    delete obsoleteMessages;
                }
            }*/
            successMessage='SUCCESS - Processing Configuration Finished!';
        } catch (Exception e) {
            System.debug('--- ConfigurationController - The following exception has occurred: ' + e.getStackTraceString());
            throw new CustomException(e.getMessage());
        }
        return successMessage;
    } 
       
}