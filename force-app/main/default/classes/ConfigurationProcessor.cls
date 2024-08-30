/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-12-2023
 * @last modified by  : Henk Reynders
**/
public with sharing class ConfigurationProcessor {

    @AuraEnabled(cacheable=true)
    public static String processConfiguration(String configId, String recordId, String pricingJSON){
        System.debug('--- Processing PricingJSON for Configuration');
        String errorMessage;
        String successMessage;
        // Salesforce Product Settings
        Id userOrgId = userInfo.getOrganizationId();
        System.debug('--- Salesforce Org: '+userOrgId);
        Product_Settings__c productSettings = Product_Settings__c.getInstance();
        Product_Settings__c productSettingsOrg = Product_Settings__c.getInstance(userOrgId);
        String visualProducts = productSettingsOrg.Visual_Products__c;
        System.debug('--- visualProducts: '+visualProducts);
        
        String soveliaProducts = ('VISORBLINDSALES;30310020');
        System.debug('--- soveliaProducts Org: '+productSettingsOrg.Sovelia_Products__c);
        System.debug('--- soveliaProducts: '+productSettings.Sovelia_Products__c);
        // Salesforce Configuration Plan Variables
        String configPlanId; // Configuration Id
        Configuration__c existingPlan = New Configuration__c(); // Existing Configuration Plan
        List<Configuration__c> existingPlans = New List<Configuration__c>(); // Existing Configuration Plans 
        List<Id> existingPlanIds = new List<Id>(); // Existing Configuration Plan Ids 
        List<Configuration__c> plansToUpsert = New List<Configuration__c>(); // New or Changed Configuration Configuration Plans
        Integer planCount;
        String planUnit;
        String planFloor;
        String planLine;
        String planName;
        String planVisualId;
        Integer planVisualVersion;
        String planPricingJSON;
        String visualPricingJSON;
        String visualProductsJSON;
        String planSoveliaId;
        Integer planSoveliaVersion;
        String soveliaPricingJSON;
        String soveliaProductsJSON;

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
        Production_Time__c productionTime; // Production Time Record
        Map<String,Production_Time__c> productionTimeMap  = New Map<String,Production_Time__c>();  // Map for Lookup of Product and Production Times
        Product2 productionTimeProduct;
        // Salesforce Product2 Variables
        //String productId; // Product2 Id
        String existingProductId;
        String itemProductId;
        List<String> structureNumbers = new List<String>();      
        // Visual Configuration Variables
        String visualPlanId; // Visual Plan Id
        VisualConfiguration visualConfigObject = new VisualConfiguration(); // Parsed Visual Configuration Result Object 
        String visualStructure; // Visual Structure Id
        String visualProductId; // Visual Product Id

        List<VisualConfiguration.Product> visualConfigProducts = new List<VisualConfiguration.Product>(); // Products from Parsed Result Object    
        Double visualItemAmount; // Visual Param Quantity 
        String visualItemSalesCode; // Visual Param Code
        String visualItemCostCategory; // Cost Category
        String visualItemCostType; // Cost Type

        List<Object> visualConfigItems = new List<Object>(); // Product Items from Parsed Result Object   
        List<Object> visualConfigMessages = new List<Object>(); // Product Messages from Parsed Result Object  
        
        // Sovelia Configuration Variables
        String soveliaPlanId; // Sovelia Plan Id
        SoveliaConfiguration soveliaConfigObject = new SoveliaConfiguration(); // Parsed Sovelia Configuration Result Object 
        String soveliaStructure; // Sovelia Structure Id
        String soveliaProductId; // Sovelia Product Id
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
                parentObjectType = DynamicObjectUtils.getObjectType(recordId);
                System.debug('--- Process Configurations for Object '+parentObjectType+' with Id '+recordId);
            } else {
                errorMessage = 'No Parent Object identified!';
                System.debug('--- ABORT '+errorMessage);
                throw new CustomException(errorMessage);
            } 
            // Step 2: Get the Parent Object
            if (String.IsNotBlank(recordId) && parentObjectType=='Opportunity') {
                // Get Related Opportunity Record
                opportunityRecord = OpportunityProductController.getOpportunityRecord(recordId);
                // Set Related Records
                if(Test.isRunningTest()){
                    //Invoke mock web service response
                    pricebookId = Test.getStandardPricebookId();
                } else {
                    pricebookId = opportunityRecord.pricebook2Id;        
                }              
                currencyCode = opportunityRecord.CurrencyIsoCode; 
                opportunityNumber = opportunityRecord.Opportunity_Number__c;
            } else {
                errorMessage = 'No Opportunity Identified!';
                System.debug('--- ABORT '+errorMessage);
                throw new CustomException(errorMessage);
            } 
            // Step 3: Get the Pricebook Entries
            if (String.IsNotBlank(pricebookId)) {
                // Get Sellable Products from Opportunity Pricebook
                pricebookEntryConfigurationProductMap = PriceBookEntryController.getPricebookEntryMap(pricebookId, currencyCode, opportunityRecord);
                pricebookEntryMap = PriceBookEntryController.getPricebookEntryMap(pricebookId, currencyCode);
                System.debug('--- '+pricebookEntryMap.values().size()+' sellable  Product(s)');
                // Get Installable Products from installation Times         
                Boolean isActive = true;
                installationTimeMap = InstallationTimeController.getInstallationTimeMap(isActive);
                System.debug('--- '+installationTimeMap.values().size()+' Installation Time(s)');
                // Get Installable Products from Product2   
                installationTimeProductMap = InstallationTimeController.getInstallationTimeProductMap(isActive);
                System.debug('--- '+installationTimeProductMap.size()+' Installation Time Product(s)');
                // Add Production Times
                productionTimeMap = ProductionTimeController.getProductionTimeMap(isActive);
                System.debug('--- '+productionTimeMap.values().size()+' Production Time(s)');
            } else {
                errorMessage = 'No Pricebook Defined!';
                System.debug('--- ABORT '+errorMessage);
                throw new CustomException(errorMessage);
            } 
            // Step 4: Get the Visual or Sovelia Configuration by parsing the pricing File content
            if (String.IsNotBlank(pricingJSON)) {
                System.debug('--- Checking the Type of Pricing File!');
				System.debug('--- Pricing File:'+pricingJSON);
                System.debug('--- Get Visual Products: '+visualProducts);
                List<String> visualProductCodes = visualProducts.split(';');
                System.debug('--- Checking if Pricing File includes on of these: '+visualProductCodes);
                Integer countVisualProductCodes = 0;
                for (String visualProductCode : visualProductCodes) {
                    System.debug('--- Checking if Pricing File includes '+visualProductCode);
                    countVisualProductCodes += pricingJSON.countMatches(visualProductCode);
                }
                System.debug('--- Get Sovelia Products: '+soveliaProducts);
                List<String> soveliaProductCodes = soveliaProducts.split(';');
                Integer countSoveliaProductCodes = 0;
                for (String soveliaProductCode : soveliaProductCodes) {
                    System.debug('--- Checking if Pricing File includes '+soveliaProductCode);
                    countSoveliaProductCodes += pricingJSON.countMatches(soveliaProductCode);
                }
                if (countVisualProductCodes>0){
                    System.debug('--- Using Visual Pricing JSON');
                    visualPricingJSON = pricingJSON;
                } else if (countSoveliaProductCodes>0){
                    System.debug('--- Using Sovelia Pricing JSON');
                    soveliaPricingJSON = pricingJSON;                    
                } else {
                    System.debug('--- Unknown Pricing JSON');
                }
            }
            if (String.IsNotBlank(visualPricingJSON)) {
                // Get Products from Visual Pricing JSON
                System.debug('--- Visual Pricing JSON to Process');
                visualConfigObject = ConfigurationController.getVisualConfigurationObjects(visualPricingJSON);  
                visualConfigProducts = visualConfigObject.products;
            } else if (String.IsNotBlank(soveliaPricingJSON)) {
                // Get Products from sovelia Pricing JSON
                System.debug('--- Sovelia Pricing JSON to Process');
                soveliaConfigObject = ConfigurationController.getSoveliaConfigurationObjects(soveliaPricingJSON);  
                soveliaConfigProducts = soveliaConfigObject.products;
            } else {
                errorMessage = 'No Pricing File to Process!';
                System.debug('--- ABORT '+errorMessage);
                throw new CustomException(errorMessage);
            } 
            // Step 5: Get the Configuration Plan
            if (visualConfigObject !=null || soveliaConfigObject !=null) {
                if (visualConfigObject !=null){
                    existingPlans = ConfigurationController.getAllConfigurations(configId,recordId,visualPlanId);
                    planName = visualConfigObject.Name;
                    planUnit = visualConfigObject.apartment;
                    planFloor = visualConfigObject.floor;
                    planLine = visualConfigObject.line;
                    planVisualId = visualConfigObject.id;
                    planVisualVersion = visualConfigObject.version; 
                    // Store the Pricing JSON in the Configuration Record
                    visualPricingJSON = visualPricingJSON;
                    visualProductsJSON = JSON.serialize(visualConfigProducts);
                } else if (soveliaConfigObject !=null) {
                    existingPlans = ConfigurationController.getAllConfigurations(configId,recordId,soveliaPlanId);
                    planName = soveliaConfigObject.name;
                    planSoveliaId = soveliaConfigObject.id;
                    planSoveliaVersion = soveliaConfigObject.version; 
                    // Store the Pricing JSON in the Configuration Record
                    soveliaPricingJSON = soveliaPricingJSON;
                    soveliaProductsJSON = JSON.serialize(soveliaConfigProducts);
                }
                // Check for Existing Plans by configId, (parent) recordId or VisualPlanId               
                existingPlanIds = new List<Id>(new Map<Id, Configuration__c>(existingPlans).keySet()); 
                System.debug('--- '+existingPlans.size()+' Existing Configuration(s)');           
                for (Configuration__c planToUpsert : existingPlans){
                    // Prepare Plan to Insert or Update
                    if (!String.isBlank(configId)){
                        planToUpsert.Id = configId; // Parent Record = Configuration
                    } else {
                        configId = planToUpsert.Id;
                    }
                    // Update the Plan with Values from the New or Changed Pricing File Content
                    planToUpsert.Name = String.IsNotBlank(planName)? planName : '';
                    // Set Plan Values based on Visual Update
                    planToUpsert.Unit__c = String.IsNotBlank(planUnit) ? planUnit : '';
                    planToUpsert.Floor__c = String.IsNotBlank(planFloor)? planFloor : '';
                    planToUpsert.Line__c = String.IsNotBlank(planLine)? planLine : '';
                    planToUpsert.Plan_Name__c = String.IsNotBlank(planName)? planName : '';
                    planToUpsert.Visual_Id__c = String.IsNotBlank(planVisualId)? planVisualId : '';
                    planToUpsert.Visual_Version__c = planVisualVersion;
                    planToUpsert.Visual_Pricing_JSON__c = String.IsNotBlank(visualPricingJSON)? visualPricingJSON : '';
                    planToUpsert.Visual_Products_JSON__c = String.IsNotBlank(visualProductsJSON)? visualProductsJSON : '';
                    planToUpsert.Sovelia_Id__c = String.IsNotBlank(planSoveliaId)? planSoveliaId : '';
                    planToUpsert.Sovelia_Version__c = planSoveliaVersion;
                    planToUpsert.Sovelia_Pricing_JSON__c = String.IsNotBlank(soveliaPricingJSON)? soveliaPricingJSON : '';
                    planToUpsert.Sovelia_Products_JSON__c = String.IsNotBlank(soveliaProductsJSON)? soveliaProductsJSON : '';

                    planToUpsert.OwnerId = opportunityRecord.OwnerId;
                    // Created or Update the Configuration Record
                    upsert planToUpsert;
                    // Add the New or Changed Plan to Collection
                    plansToUpsert.add(planToUpsert);  
                }
                System.debug('--- '+plansToUpsert.size()+' New or Changed Configuration Plan(s)');   
            } else {
                errorMessage = 'No Visual or Sovelia Configuration Object to Process!';
                System.debug('--- ABORT '+errorMessage);
                throw new CustomException(errorMessage);
            } 
            // Step 6: Get the Configuration Products
            productCount = visualConfigProducts.size() + soveliaConfigProducts.size();
            System.debug('--- '+productCount+' Configuration Product(s)');
            if (productCount>0){               
                List<Configuration_Product__c> productsToUpsert = new List<Configuration_Product__c>(); // New or Changed Configuration Products from Pricing JSON
                // Check for Existing Products by configId, (parent) recordId, SoveliaPlanId or VisualPlanId
                existingProducts = ConfigurationController.getConfigurationProducts(existingPlanIds);
                System.debug('--- '+existingProducts.size()+' Existing Configuration Product(s)'); 

                if (existingProducts.size()>0) {   
                    Map<String,Configuration_Product__c> structureToProductMap =  ConfigurationController.getStructureToProductMap(existingProducts);
                    Boolean isProductExisting = structureToProductMap.containsKey(visualStructure);
                    if (isProductExisting) {
                        Configuration_Product__c existingProduct = structureToProductMap.get(visualStructure);
                        existingProductId = existingProduct.Id;
                    } else {
                        existingProductId = '';
                    } 
                } 
                // Loop through the Configuration Products
                for (Integer j = 0; j < productCount; j++) {  
                    Integer productCounter = j+1;
                    System.debug('--- Processing Configuration Product '+productCounter+' of '+productCount);
                    Configuration_Product__c configurationProduct = new Configuration_Product__c(); // New or Changed Configuration Product as in File configJSON

                    if (visualConfigProducts.size()  >0) {
                        // Find the Pricebook Entry for the Configuration Product
                        productLookupCode = visualConfigObject.products[j].name; 
                    } else if (soveliaConfigProducts.size() >0){
                        productLookupCode = soveliaConfigObject.products[j].name; 
                    }
                    // Check if productCode is in the pricebookEntry Map
                    Boolean pbEntryKeyFound = pricebookEntryConfigurationProductMap.containsKey(productLookupCode);
                    // if Entry exists retrieve it else just log it
                    pbEntryId=''; 
                    if(pbEntryKeyFound) {   
                        pbEntry = (PricebookEntry) pricebookEntryConfigurationProductMap.get(productLookupCode);
                        //System.debug('--- Found Product Pricebook Entry '+pbEntry+' for ProductCode '+productLookupCode); 
                        //System.debug('--- pbEntry.Product2.Sales_Code__c'+pbEntry.Product2.Sales_Code__c);
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
                        } else {
                            System.debug('--- No Pricebook Entry Product'); 
                        }
                    }  else {
                        System.debug('--- NO Pricebook Entry for Product '+productLookupCode); 
                        pbEntryId=''; 
                    }
                    
                    // Continue only if there was a Pricebook Entry Found
                    if (String.isNotBlank(pbEntryId)){
                        Configuration_Product__c productToUpsert = new Configuration_Product__c(); 
                        // Set New or Changed Configuration Product Identifiers based on parsed Pricing File Content
                        if (visualConfigProducts.size()  >0) {
                            // Find the Pricebook Entry for the Configuration Product
                            visualStructure = visualConfigObject.products[j].rvn;
                            visualProductId = visualConfigObject.products[j].Id;
                        } else if (soveliaConfigProducts.size() >0){
                            soveliaStructure = soveliaConfigObject.products[j].rvn.substring(8, 16);
                            soveliaProductId = soveliaConfigObject.products[j].id;
                        }
                        

                        //System.debug('--- Check for Configuration Product(s) with Visual Product Id '+visualProductId+' and Structure '+visualStructure); 
                        // Check Existing Configuration Products to find Id needed in upsert
                        // Loop Existing Configuration Products to find Id
                        Configuration_Product__c existingConfigurationProduct = null;
                        if (existingProducts.size()>0) {    
                            for (Configuration_Product__c existingProduct : existingProducts) {
                                if (visualConfigProducts.size()  >0 
                                    && existingProduct.Visual_Structure_Number__c == visualStructure
                                    && existingProduct.Visual_Product_Id__c == visualProductId) { 
                                        existingProductId = existingProduct.Id;
                                        existingConfigurationProduct = existingProduct;
                                } else if (soveliaConfigProducts.size() >0 
                                        && existingProduct.RVN__c == opportunityNumber + soveliaStructure) {
                                        existingProductId = existingProduct.Id;
                                        existingConfigurationProduct = existingProduct;
                                } else {
                                    System.debug('--- No matching Configuration Product with Code: '+productLookupCode); 
                                    existingProductId = ''; 
                                }
                            }
                        } else {
                            System.debug('--- No Existing Configuration Product(s)');
                        }
                        System.debug('--- Checking Configuration Product for Plan with Id: '+configId);
                        if (String.isNotBlank(existingProductId)){
                            productToUpsert.Id = existingProductId;
                            System.debug('--- Use Existing Configuration Product with Id: '+existingProductId);
                            if(existingConfigurationProduct?.Configuration__c != null) {
                                productToUpsert.Configuration__c = existingConfigurationProduct.Configuration__c;
                            }
                        } else {
                            productToUpsert.Configuration__c = configId; // Parent Record = Configuration
                            System.debug('--- Add Configuration Product to Plan with Id: '+configId);
                        }
                        // Set Values for the New or Changed Configuration Product based on parsed Visual Pricing File Content 
                        if (visualConfigProducts.size()  >0 ) { 
                            productToUpsert.Product_Group__c = productLookupCode; // Product Name in Visual is Product Group in Salesforce
                            productToUpsert.Visual_Product_Id__c = visualProductId; // Unique Visual Product Id,not used in Salesforce
                            productToUpsert.Visual_Structure_Number__c = visualStructure; // Unique Visual Product RVN is actually Structure number
                            productToUpsert.Product_Length__c = visualConfigObject.products[j].productLength; // Visual Product Length 
                            // Variables that affect the Coonfiguration Product Status
                            productToUpsert.Inspection_Code__c = visualConfigObject.products[j].productInspectCode; // Visual Inspection Error Code
                            productToUpsert.Features_Confirmed__c = visualConfigObject.products[j].hasFeaturesBeenConfirmed; // Visual Feature Confirmed Checkbox
                            productToUpsert.Measurements_Verified__c = visualConfigObject.products[j].hasMeasurementsBeenVerified; // Visual Mesaurements Confirmed Checkbox
                            // Set the RVN Number to Opportunity Number + StructureNumber
                            String structureNumber = productToUpsert.Visual_Structure_Number__c;
                            productToUpsert.RVN_Number__c = opportunityNumber + structureNumber;
                        } else if (soveliaConfigProducts.size() >0 ){
                            // Set Values for the New or Changed Configuration Product based on parsed Sovelia Pricing File Content                        
                            productToUpsert.Product_Group__c = productLookupCode; // Product Name in Sovelia is Product Group in Salesforce
                            productToUpsert.Sovelia_Product_Id__c = soveliaProductId; // Unique Sovelia Product Id,not used in Salesforce
                            productToUpsert.Sovelia_Structure_Number__c = soveliaStructure; // Unique Sovelia Product RVN is actually Structure number
                            // Set the RVN Number to Opportunity Number + StructureNumber
                            String structureNumber = productToUpsert.Sovelia_Structure_Number__c;
                            productToUpsert.RVN_Number__c = opportunityNumber + structureNumber;
                        }
                        // Variables relevant in Salesforce for Pricing etc
                        productToUpsert.Product__c = pbEntryProductId; // Reference to the related Product2 record in Salesforce
                        productToUpsert.Name = pbEntryName; // Use the Name of the Product2 record in Salesforce
                        productToUpsert.Quantity__c = 1; // As this is a Configurable Product Quantity must be 1
                        productToUpsert.Cost_Category__c = pbEntryCostCategory;
                        productToUpsert.Cost_Type__c = pbEntryCostType;
                        productToUpsert.Product_Category__c = pbEntryProductCategory;
                        productToUpsert.Product_Type__c = pbEntryProductType;
                        productToUpsert.Product_Item__c = pbEntryProductItem;
                        // Add updated Product Record to Collection
                        productsToUpsert.add(productToUpsert);    
                        
                        //System.debug('--- Adding Configuration Product '+productToUpsert);            
                    }   
                }
                System.debug('--- '+productsToUpsert.size()+' Configuration Products to Create or Update');
                if (productsToUpsert.size()>0) {
                    upsert productsToUpsert;
                }
                upsertedProductIds = new List<Id>(new Map<Id, Configuration_Product__c>(productsToUpsert).keySet()); 
                System.debug('--- '+upsertedProductIds.size()+ ' Configuration Product(s) Created or Updated');
                // Get Existing Configuration Products to Delete
                List<Configuration_Product__c> obsoleteProducts = New List<Configuration_Product__c>();
                obsoleteProducts = ([SELECT Id                                  
                                    FROM Configuration_Product__c
                                    WHERE Configuration__c =: configId 
                                    AND Id NOT IN :upsertedProductIds
                                    ORDER BY CreatedDate DESC]);
                System.debug('--- '+obsoleteProducts.size()+' Configuration Product(s) to Delete');
                if (obsoleteProducts.size()>0) {
                    delete obsoleteProducts;
                }
            }
            // Step 7: Get the Configuration Items
            if (upsertedProductIds.size()>0 && upsertedProductIds != null){
                // Check for Existing Products by configId, (parent) recordId or VisualPlanId
                existingProducts = ConfigurationController.getConfigurationProductsById(upsertedProductIds);
                existingProductIds =  new List<Id>(new Map<Id, Configuration_Product__c>(existingProducts).keySet()); 
                System.debug('--- '+existingProducts.size()+' Existing Configuration Product(s)');
                // Check for Existing Items by (parent) product, Structure Number or RVN
                existingItems = ConfigurationController.getConfigurationOptions(upsertedProductIds);
                System.debug('--- '+existingItems.size()+' Existing Configuration Item(s)'); 
                // Check for Existing Messages by (parent) product, Structure Number or RVN
                existingMessages = ConfigurationController.getConfigurationMessages(upsertedProductIds);
                System.debug('--- '+existingMessages.size()+' Existing Configuration Message(s)'); 
            }
            // Step 8: Process the Configuration Items
            if (productCount>0){
                itemCount = 0;
                for (Integer k=0;k<productCount;k++){
                    Integer productCounter = k+1;
                    if (visualConfigProducts.size() >0 ) {                       
                        String visualProductName = visualConfigObject.products[k].name;  
                        productLookupCode = visualProductName;  
                        visualConfigItems = visualConfigObject.products[k].priceParameters;
                        itemCount = visualConfigItems.size();
                        System.debug('--- '+itemCount+' Visual Configuration Item(s)');
                    } else if (soveliaConfigProducts.size() >0 ) {
                        String soveliaProductName = soveliaConfigObject.products[k].name;  
                        productLookupCode = soveliaProductName;  
                        soveliaConfigItems = soveliaConfigObject.products[k].priceParameters;
                        itemCount = soveliaConfigItems.size();
                        System.debug('--- '+itemCount+' Sovelia Configuration Item(s)');
                    }
                    // Loop through the Configuration Items
                    for (Integer l = 0; l < itemCount; l++) {  
                        Integer itemCounter = l+1;
                        //System.debug('--- Processing Visual Configuration Item '+itemCounter+' of '+itemCount);
                        Configuration_Option__c configurationItem = new Configuration_Option__c(); // New or Changed Configuration Item as in File configJSON
                        // Find the Pricebook Entry for the Configuration Item
                        if (visualConfigProducts.size() >0 ) {   
                            String salesCode = visualconfigObject.products[k].priceParameters[l].SalesCode; 
                            itemLookupCode = productLookupCode+'-'+salesCode;    
                        } else if (soveliaConfigProducts.size() >0 ) { 
                            String salesCode = soveliaConfigObject.products[k].priceParameters[l].SalesCode;
                            itemLookupCode = productLookupCode+'-'+salesCode;   
                        }       
                        System.debug('--- Lookup Pricebook Entry for itemCode '+itemLookupCode);     
                        //System.debug('--- Lookup Pricebook Entry for itemCode '+itemLookupCode);
                        // Check if itemCode is in the pricebookEntry Map
                        Boolean pbEntryKeyFound = pricebookEntryMap.containsKey(itemLookupCode);
                        Boolean installTimeKeyFound = installationTimeMap.containsKey(itemLookupCode);
                        Boolean factoryTimeKeyFound = productionTimeMap.containsKey(itemLookupCode);
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
                                //System.debug('--- Found Reclamation Product Cost Category '+pbEntryCostCategory); 
                                pbEntryCostType = pbEntry.Product2.Cost_Type__c;// Cost Type of the Product
                                //System.debug('--- Found Reclamation Product Cost Type '+pbEntryCostType); 
                                pbEntryProductCategory = pbEntry.Product2.Product_Category__c; // Product Category of the Product
                                pbEntryProductType = pbEntry.Product2.Product_Type__c;// Product Type of the Product
                                pbEntryProductItem = pbEntry.Product2.Product_Item__c;// Product Item of the Product
                            } else {
                                System.debug('--- Skipping Reclamation Product Pricebook Entry'); 
                                pbEntryId='';                                
                            }
                            // Add Production Times
                            if (factoryTimeKeyFound) {
                                productionTime = (Production_Time__c) productionTimeMap.get(itemLookupCode);
                                // If Entry exists then add the production time to Configuration Option
                                productionTimeId = productionTime.Id;
                                itemProductId = productionTime.Product__c; // reference to Product2 Record
                                productionDays = productionTime.Days__c; // Production Time Lookup
                                productionExtraDays = productionTime.Extra_Days__c; // Production Time Lookup
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
                            System.debug('--- NO Pricebook Entry or Installation Time for Item '+itemLookupCode); 
                        }
                        // Continue only if there was a Pricebook Entry or Installaton Time Found
                        if (String.isNotBlank(itemProductId)){
                            // Set New or Changed Configuration Option Identifiers based on parsed  Pricing File Content
                            String structureNumber;
                            if (visualConfigProducts.size() >0 ) { 
                                //visualStructure = visualConfigObject.products[k].rvn;
                                //visualProductId = visualConfigObject.products[k].Id;
                                visualItemAmount = visualConfigObject.products[k].priceParameters[l].Amount;
                                visualItemSalesCode = visualConfigObject.products[k].priceParameters[l].SalesCode;
                                structureNumber = visualStructure;
                            // Loop Existing Configuration Products to find Id
                            } else if (soveliaConfigProducts.size() >0 ) { 
                                //soveliaStructure = soveliaConfigObject.products[k].rvn.substring(8, 16);
                                //soveliaProductId = soveliaConfigObject.products[k].Id;
                                soveliaItemAmount = soveliaConfigObject.products[k].priceParameters[l].Amount;
                                soveliaItemSalesCode = soveliaConfigObject.products[k].priceParameters[l].SalesCode;
                                structureNumber = soveliaStructure;
                            }
                            if (existingProducts.size()>0) {   
                                Map<String,Configuration_Product__c> structureToProductMap =  ConfigurationController.getStructureToProductMap(existingProducts);
                                Boolean isProductExisting = structureToProductMap.containsKey(visualStructure);
                                if (isProductExisting) {
                                    Configuration_Product__c existingProduct = structureToProductMap.get(structureNumber);
                                    existingProductId = existingProduct.Id;

                                } else {
                                    existingProductId = '';
                                }
                            }
                            String existingItemId; 
                            // Loop Existing Configuration Items to find Id
                            Map<String,Configuration_Option__c> uniqueIdToOptionMap = ConfigurationController.getUniqueIdToOptionMap(existingItems);
                            String uniqueId;
                            uniqueId = String.valueOf(itemCounter);
                            if (visualConfigProducts.size() >0 ) { 
                                uniqueId = String.valueOf(itemCounter); 
                                uniqueId += '-'+productLookupCode; // Visual Product Name
                                uniqueId += '-'+visualItemSalesCode;// Visual Price Parameter Sales Code                       
                                uniqueId += '-'+String.valueOf(Decimal.valueOf(visualItemAmount).setScale(5)); // Visual Price Parameter Amount*
                            } else if (soveliaConfigProducts.size() >0 ) { 
                                uniqueId += '-'+productLookupCode; // Sovelia Product Name
                                uniqueId += '-'+soveliaItemSalesCode;// Sovelia Price Parameter Sales Code
                                uniqueId += '-'+String.valueOf(Decimal.valueOf(soveliaItemAmount).setScale(5)); // Sovelia Price Parameter Amount*
                            }
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
                            if (visualConfigProducts.size() >0 ) { 
                                // Update Configuration Item Visual Attributes
                                itemToUpsert.Local_Supplier__c= visualconfigObject.products[k].priceparameters[l].LocalSupplier;
                                itemToUpsert.Parameter_code__c = visualconfigObject.products[k].priceparameters[l].ParameterCode;
                                itemToUpsert.Sales_Code__c = visualconfigObject.products[k].priceparameters[l].SalesCode;
                                //itemToUpsert.Unique_Id__c = visualconfigObject.products[k].priceparameters[l].UniqueId;
                                itemToUpsert.Unit_Of_Measure__c = visualconfigObject.products[k].priceparameters[l].Unit;                           
                                // Update Configuration Item for use in Pricing
                                itemToUpsert.Product_Group__c = visualconfigObject.products[k].name;
                                itemToUpsert.Quantity__c = visualconfigObject.products[k].priceparameters[l].Amount;
                            } else if (soveliaConfigProducts.size() >0 ) {
                                // Update Configuration Item Sovelia Attributes
                                itemToUpsert.Local_Supplier__c= soveliaConfigObject.products[k].priceparameters[l].LocalSupplier;
                                itemToUpsert.Parameter_code__c = soveliaConfigObject.products[k].priceparameters[l].ParameterCode;
                                itemToUpsert.Sales_Code__c = soveliaConfigObject.products[k].priceparameters[l].SalesCode;
                                //itemToUpsert.Unique_Id__c = soveliaConfigObject.products[k].priceparameters[l].UniqueId;
                                itemToUpsert.Unit_Of_Measure__c = soveliaConfigObject.products[k].priceparameters[l].Unit;
                                
                                // Update Configuration Item for use in Pricing
                                itemToUpsert.Product_Group__c = soveliaConfigObject.products[k].name;
                                itemToUpsert.Quantity__c = soveliaConfigObject.products[k].priceparameters[l].Amount;
                            }
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
                                // Add Production Times
                                itemToUpsert.Production_Days__c = productionDays;
                                itemToUpsert.Production_Extra_Days__c = productionDays;
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
                            }
                            // Add updated Item Record to Collection
                            itemsToUpsert.add(itemToUpsert); 
                        }
                    }
                }
                System.debug('--- '+itemsToUpsert.size()+' Configuration Item(s) to Create or Update');
                    
                if (itemsToUpsert.size()>0) {
                    upsert itemsToUpsert;
                    upsertedItemIds = new List<Id>(new Map<Id, Configuration_Option__c>(itemsToUpsert).keySet()); 
                }
                System.debug('--- '+upsertedItemIds.size()+ ' Configuration Items(s) Created or Updated');
                // Get Existing Configuration Items to Delete
                List<Configuration_Option__c> obsoleteItems = New List<Configuration_Option__c>();
                System.debug('--- existingProductIds: '+existingProductIds);
                obsoleteItems = ([SELECT Id                                  
                                    FROM Configuration_Option__c
                                    WHERE Configuration_Product__c IN: existingProductIds 
                                    AND Id NOT IN :upsertedItemIds
                                    ORDER BY CreatedDate DESC]);
                System.debug('--- '+obsoleteItems.size()+' Configuration Item(s) to Delete');
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
                        System.debug('--- '+visualConfigMessages.size()+' Visual Configuration Message(s)');
                        messageCount = visualConfigMessages.size();
                        System.debug('--- '+messageCount+' Visual Configuration Message(s)');
                    }
                    if (visualConfigMessages.size()>0) {
                        // Loop through the Visual Configuration Messages
                        for (Integer l = 0; l < messageCount; l++) {  
                            Integer msgCounter = l+1;
                            System.debug('--- Processing Visual Configuration Message '+msgCounter+' of '+messageCount);
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
                System.debug('--- '+messagesToUpsert.size()+' Configuration Message(s) to Create');
                    
                if (messagesToUpsert.size()>0) {
                    insert messagesToUpsert;
                    upsertedMessageIds = new List<Id>(new Map<Id, Configuration_Message__c>(messagesToUpsert).keySet());
                }
                System.debug('--- '+upsertedMessageIds.size()+ ' Configuration Message(s) Created or Updated');
                // Get Existing Configuration Messages to Delete
                List<Configuration_Message__c> obsoleteMessages = New List<Configuration_Message__c>();
                obsoleteMessages = ([SELECT Id                                  
                                    FROM Configuration_Message__c
                                    WHERE Configuration_Product__c IN: existingProductIds 
                                    AND Id NOT IN :upsertedMessageIds
                                    ORDER BY CreatedDate DESC]);
                System.debug('--- '+obsoleteMessages.size()+' Configuration Message(s) to Delete');
                if (obsoleteMessages.size()>0) {
                    delete obsoleteMessages;
                }
            }
            successMessage='SUCCESS - Processing Configuration Finished!';
        } catch (Exception e) {
            System.debug('--- The following exception has occurred: ' + e.getMessage());
            throw new CustomException(e.getMessage());
        }
        return successMessage;
    }  
}