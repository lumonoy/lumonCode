/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-20-2023
 * @last modified by  : Henk Reynders
**/
public with sharing class ConfigurationDataController {

	@AuraEnabled(cacheable=true)
    public static Map<ID, String> getVisualPricingFiles(String recordId){
        List<Configuration__c> configPlans = ConfigurationPlanController.getConfigurationsByRelatedId(recordId);
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
            System.debug('*** publish Configuration Change Event ***');
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
    
    private static final Map<String, Schema.DescribeFieldResult> CONFIGURATION_PRODUCT_XML_FIELDS = new Map<String, Schema.DescribeFieldResult>{
        'products/balconyglazing/upper_profile' => Configuration_Attribute__c.Upper_Profile__c.getDescribe(),
        'products/balconyglazing/upper_profile_color' => Configuration_Attribute__c.Upper_Profile_Color__c.getDescribe(),
        'products/balconyglazing/lower_profile' => Configuration_Attribute__c.Lower_Profile__c.getDescribe(),
        'products/balconyglazing/lower_profile_color' => Configuration_Attribute__c.Lower_Profile_Color__c.getDescribe(),
        'products/balconyglazing/glass_thickness' => Configuration_Attribute__c.Glass_Thickness__c.getDescribe(),
        'products/balconyglazing/glass_color' => Configuration_Attribute__c.Glass_Color__c.getDescribe(),
        'products/balconyglazing/left_edge_seal' => Configuration_Attribute__c.Left_Edge_Seal__c.getDescribe(),
        'products/balconyglazing/right_edge_seal' => Configuration_Attribute__c.Right_Edge_Seal__c.getDescribe(),
        'products/balconyglazing/glass_seals' => Configuration_Attribute__c.Glass_Seals__c.getDescribe(),
        'products/balconyglazing/pull_latch' => Configuration_Attribute__c.Pull_Latch__c.getDescribe(),
        'products/balconyglazing/decibel_sealing' => Configuration_Attribute__c.Decibel_Sealing__c.getDescribe(),
        'products/balconyglazing/upper_seal' => Configuration_Attribute__c.Upper_Seal__c.getDescribe(),
        'products/balconyglazing/lower_seal' => Configuration_Attribute__c.Lower_Seal__c.getDescribe(),
        'products/balconyglazing/balustrade_seal' => Configuration_Attribute__c.Balustrade_Seal__c.getDescribe(),
        'products/balconyglazing/embedded_feature' => Configuration_Attribute__c.Embedded_Feature__c.getDescribe(),
        'products/balconyglazing/vertical_frame' => Configuration_Attribute__c.Vertical_Frame__c.getDescribe(),
        'products/terrace/roof_glass_material' => Configuration_Attribute__c.Roof_Glass_Material__c.getDescribe(),
        'products/terrace/frame_color' => Configuration_Attribute__c.Frame_Color__c.getDescribe(),
        'products/terrace/width1' => Configuration_Attribute__c.Width1__c.getDescribe(),
        'products/terrace/depth1' => Configuration_Attribute__c.Depth1__c.getDescribe(),
        'products/terrace/height2' => Configuration_Attribute__c.Height2__c.getDescribe(),
        'products/terrace/height1' => Configuration_Attribute__c.Height1__c.getDescribe(),
        'products/terrace/drain_pipe' => Configuration_Attribute__c.Drain_Pipe__c.getDescribe(),
        'products/terrace/eaves_left' => Configuration_Attribute__c.Eaves_Left__c.getDescribe(),
        'products/terrace/eaves_right' => Configuration_Attribute__c.Eaves_Right__c.getDescribe(),
        'products/terrace/led_lights' => Configuration_Attribute__c.Led_Lights__c.getDescribe(),
        'products/balustrade/mounting_type' => Configuration_Attribute__c.Installation_Method__c.getDescribe(),
        'products/balustrade/handrailing_material' => Configuration_Attribute__c.Handrail_Color__c.getDescribe(),
        'products/balustrade/handrailing_pipe_material' => Configuration_Attribute__c.Handrail_Pipe_Color__c.getDescribe(),
        'products/balustrade/handrailing_pipe_material' => Configuration_Attribute__c.Posts_Color__c.getDescribe(),
        'products/balustrade/upholstery_profile_material' => Configuration_Attribute__c.Upholstery_Color__c.getDescribe(),
        'products/balustrade/handrailing' => Configuration_Attribute__c.Handrail_Type__c.getDescribe(),
        'products/balustrade/upholstery_type' => Configuration_Attribute__c.Cladding_Type__c.getDescribe(),
        'products/balustrade/upholstery_material' => Configuration_Attribute__c.Cladding_Material__c.getDescribe(),
        'products/balustrade/toe_list' => Configuration_Attribute__c.Lower_gap_profile__c.getDescribe()
    };

    private static final Map<String, Schema.DescribeFieldResult> STRUCTURE_TO_CONFIGURATION_FIELD = new Map<String, Schema.DescribeFieldResult>{
        'side_amount' => Configuration_Attribute__c.Side_Amount__c.getDescribe(),
        'glass_panel_amount' => Configuration_Attribute__c.Glass_Panel_Amount__c.getDescribe(),
        'upper_profile_color' => Configuration_Attribute__c.Upper_Profile_Color__c.getDescribe(),
        'lower_profile_color' => Configuration_Attribute__c.Lower_Profile_Color__c.getDescribe(),
        'lower_profile_seal' => Configuration_Attribute__c.Lower_Profile_Seal__c.getDescribe(),
        'drain_holes' => Configuration_Attribute__c.Drain_Holes__c.getDescribe(),
        'different_height_sides' => Configuration_Attribute__c.Different_Height_Sides__c.getDescribe(),
        'lower_milling' => Configuration_Attribute__c.Lower_Milling__c.getDescribe(),
        'upper_seal' => Configuration_Attribute__c.Upper_Seal__c.getDescribe(),
        'upper_profile' => Configuration_Attribute__c.Upper_Profile__c.getDescribe(),
        'lower_profile' => Configuration_Attribute__c.Lower_Profile__c.getDescribe(),
        'upper_fastening_material' => Configuration_Attribute__c.Upper_Fastening_Material__c.getDescribe(),
        'lower_fastening_material' => Configuration_Attribute__c.Lower_Fastening_Material__c.getDescribe()
    };
        
    public static void populateAdditionalProductParameters(Id opportunityId) {
        List<Configuration_Product__c> configProducts = [
            SELECT Id, Configuration__c, Visual_Structure_Number__c, Product__r.Product_Group__c
            FROM Configuration_Product__c WHERE Configuration__r.Opportunity__c = :opportunityId];
        System.debug('--- configProducts: '+configProducts);
        if(opportunityId != null) {
            populateAdditionalProductParameters(configProducts);
        }
    }

    public static void populateAdditionalProductParameters(List<Configuration_Product__c> configurationProducts) {
        if(configurationProducts.isEmpty()) {
            return;
        }
        Map<Id, List<Configuration_Product__c>> configurationsProductsByPlan = new Map<Id, List<Configuration_Product__c>>();
        Map<Id, Configuration_Attribute__c> configurationAttributesByProductId = new Map<Id, Configuration_Attribute__c>();
        for(Configuration_Product__c configProduct : configurationProducts) {
            System.debug('--- configProduct: '+configProduct);
            if(!configurationsProductsByPlan.containsKey(configProduct.Configuration__c)) {
                configurationsProductsByPlan.put(configProduct.Configuration__c, new List<Configuration_Product__c>());
            }
            configurationsProductsByPlan.get(configProduct.Configuration__c).add(configProduct);
            configurationAttributesByProductId.put(configProduct.Id, new Configuration_Attribute__c(
                Configuration_Product__c = configProduct.Id
            ));
        }
        Map<String, Configuration_Product__c> configurationProductsByVisualId = new Map<String, Configuration_Product__c>(
            configurationProducts
        );
        Set<Id> configurationPlanIds = new Set<Id>();
        for (Configuration_Product__c configProduct : configurationProducts) {
            System.debug('*** configProduct.Configuration__c ***'+configProduct.Configuration__c);
            if(String.isNotBlank(configProduct.Configuration__c)) {
                String visualStructureNumber = configProduct.Visual_Structure_Number__c;
                System.debug('--- configurationProduct: '+configProduct);
                configurationProductsByVisualId.put('Visual_Structure_' + visualStructureNumber, configProduct);
                configurationPlanIds.add(String.valueOf(configProduct.Configuration__c));
            }
        }
        System.debug('*** configurationPlanIds ***'+configurationPlanIds);
        if(configurationPlanIds.isEmpty()) {
            return;
        }
        // Prepare the Attribute records
        List<Configuration_Attribute__c> attributesToUpdate = new List<Configuration_Attribute__c>();
        List<ConfigurationSide> sidesPanes = new List<ConfigurationSide>();
        List<ConfigurationSide> blindsPanes = new List<ConfigurationSide>();
        System.debug('--- configurationPlanIds: '+configurationPlanIds);
        List<ContentDocumentLink> docLinks = ([SELECT ContentDocument.Title, ContentDocument.LatestPublishedVersion.VersionData, LinkedEntityId
                                                FROM ContentDocumentLink
                                                WHERE
                                                    LinkedEntityId IN (SELECT Id FROM Configuration__c WHERE Id IN :configurationPlanIds)
                                                    AND (
                                                            ((ContentDocument.Title LIKE 'Visual%Structure%' 
                                                                    OR ContentDocument.Title LIKE 'Visual%Output%')
                                                                AND ContentDocument.FileType = 'JSON')
                                                            OR 	((ContentDocument.Title LIKE 'Visual%Structure%' 
                                                                    OR ContentDocument.Title LIKE 'Visual%Output%')
                                                                AND ContentDocument.FileType = 'XML')
                                                            OR    (ContentDocument.Title LIKE 'Visual%Documentation%'
                                                                AND  ContentDocument.FileType = 'XML')
                                                        	OR    (ContentDocument.Title LIKE 'Blinds%Report%'
                                                                AND  ContentDocument.FileType = 'JSON')
                                                    )
                                                LIMIT 100
                                            ]);
        System.debug('*** docLinks ***'+docLinks);
        // Process the Configuration Plan Files
        for (ContentDocumentLink link : docLinks) {
            try {
                String docTitle = link.ContentDocument.Title;
                System.debug('*** link ***'+link);
                // If Visual Structure then Process the Structure JSON/XML
                if(docTitle.Contains('Documentation')) { 
                    //System.debug('--- Skipping Structure File Name: '+docTitle);     
                    //continue;
                    // Documentation XML
                    System.debug('--- Processing Documentation File Name: '+docTitle);   
                    String docContent = link.ContentDocument.LatestPublishedVersion.VersionData.toString();
                    if(!configurationsProductsByPlan.containsKey(link.LinkedEntityId)) {
                        continue;
                    }
                    final String BALCONY_GLAZING_NODE_NAME = 'balconyglazing';
                    final String LUMON_RAILING_NODE_NAME = 'balustrade';
                    final Set<String> TERRACE_NODE_NAMES = new Set<String>{ 'terrace', 'vt4terrace' };
                    final Set<String> BALCONY_PRODUCTS = new Set<String> { 'LGS', 'LG', 'LGR', 'LFW', 'LFIXEDWALL'};
                    final Set<String> TERRACE_PRODUCTS = new Set<String> { 'VT3', 'VT4' };
                    final Set<String> RAILING_PRODUCTS = new Set<String> { 'LUMONKAIDE' };
                    DOM.Document doc = new DOM.Document();
                    doc.load(link.ContentDocument.LatestPublishedVersion.VersionData.toString());
                    Dom.XMLNode products = doc.getRootElement();
                    for(Configuration_Product__c configurationProduct : configurationsProductsByPlan.get(link.LinkedEntityId)) {
                        System.debug('--- populateAdditionalProductParameters - configProduct '+configurationProduct);
                        System.debug('--- populateAdditionalProductParameters - Processing '+configurationProduct.Product__r.Product_Group__c);
                        Dom.XMLNode balconyProduct = null;
                        Dom.XMLNode railingProduct = null;
                        Dom.XMLNode terraceProduct = null;
                        Dom.XMLNode configuredProduct = null;
                        String configuredProductName = '';
                        Configuration_Attribute__c configurationProductAttribute =
                            configurationAttributesByProductId.containsKey(configurationProduct.Id)
                                ? configurationAttributesByProductId.get(configurationProduct.Id)
                                : new Configuration_Attribute__c(
                                    Configuration_Product__c = configurationProduct.Id
                                );
                        System.debug('--- products.getChildElements() '+products.getChildElements());
                        for(Dom.XMLNode node : products.getChildElements()) {
                            String nodeName = node.getName();
                            String xmlVisualStructureNumber = node.getChildElement('structural_version_number', null)?.getText();
                            System.debug('--- populateAdditionalProductParameters - xmlVisualStructureNumber '+xmlVisualStructureNumber);
                            String xmlProductCode = node.getChildElement('product_code', null)?.getText();
                            System.debug('--- populateAdditionalProductParameters - xmlProductCode '+xmlProductCode);
                            System.debug('--- configurationProduct.Visual_Structure_Number__c '+configurationProduct.Visual_Structure_Number__c);
                            if(configurationProduct.Visual_Structure_Number__c != xmlVisualStructureNumber) {
                                continue;
                            }
                            System.debug('RAILING_PRODUCTS '+RAILING_PRODUCTS);
                            if(BALCONY_PRODUCTS.contains(configurationProduct.Product__r.Product_Group__c)
                                && BALCONY_PRODUCTS.contains(xmlProductCode) && nodeName == BALCONY_GLAZING_NODE_NAME
                            ) {
                                balconyProduct = node;
                                configuredProduct = node;
                                configuredProductName = nodeName;
                                break;
                            } else if(RAILING_PRODUCTS.contains(configurationProduct.Product__r.Product_Group__c) 
                                      && nodeName == LUMON_RAILING_NODE_NAME)
                            {
                                System.debug('--- Railing products ');
                                railingProduct = node;
                                configuredProduct = node;
                                configuredProductName = nodeName;
                                break;
                            }
                            else if(TERRACE_PRODUCTS.contains(configurationProduct.Product__r.Product_Group__c)
                                	&& TERRACE_NODE_NAMES.contains(nodeName)
                            ) {
                                System.debug('--- Terrace products ');
                                terraceProduct = node;
                                configuredProduct = node;
                                configuredProductName = nodeName;
                                break;
                            }
                        }
                        if(balconyProduct == null && railingProduct == null && terraceProduct == null) {
                            continue;
                        }
                        System.debug('--- railingProduct'+configuredProduct);
                        populateValuesToRecordFromXML(configuredProduct, 'products/' + configuredProductName, configurationProductAttribute, CONFIGURATION_PRODUCT_XML_FIELDS);
                        // The xmlFields map doesn't have separate mappings for 'v4terrace'.
                        // It uses the same mapping as 'terrace'.
                        //populateValuesToRecordFromXML(terraceProduct, 'products/' + 'terrace', configurationProductAttribute, CONFIGURATION_PRODUCT_XML_FIELDS);
                        System.debug('--- Configuration Product Attribute: '+configurationProductAttribute);
                        attributesToUpdate.add(configurationProductAttribute);
                        if(!TERRACE_PRODUCTS.contains(configurationProduct.Product__r.Product_Group__c)){ // No side & sidepane for Terrace products
                            sidesPanes.addAll(
                                populateSidesAndPanes(configuredProduct, 'products/' + configuredProductName, configurationProduct)
                            );
                        }
                        
                    }
                } /*} else if(docTitle.Contains('Structure') || docTitle.Contains('Output')) { 
                    System.debug('--- Processing Structure File Name: '+docTitle);    
                    String structureContent = link.ContentDocument.LatestPublishedVersion.VersionData.toString(); 
                    VisualStructure structure = (VisualStructure) JSON.deserialize(structureContent,VisualStructure.class);
                    // TODO How to handle multiple product opnenings with multiple RVNs?
                    // Retrieve the product Opening Data
                    Map<String, Object> productOpening = (Map<String, Object>) JSON.deserializeUntyped(
                        JSON.serialize(structure.Product_opening.get(0))
                    );
                    Configuration_Product__c configurationProduct = configurationProductsByVisualId.get(
                        link.ContentDocument.Title
                    );
                    if(configurationProduct == null) {
                        continue;
                    }
                    Configuration_Attribute__c configurationProductAttribute =
                        configurationAttributesByProductId.containsKey(configurationProduct.Id)
                            ? configurationAttributesByProductId.get(configurationProduct.Id)
                            : new Configuration_Attribute__c(
                                Configuration_Product__c = configurationProduct.Id
                            );
                    for (String field : STRUCTURE_TO_CONFIGURATION_FIELD.keySet()) {
                        System.debug('--- Configuration Product Attribute Field: '+STRUCTURE_TO_CONFIGURATION_FIELD.get(field).getName());
                        configurationProductAttribute.put(
                            STRUCTURE_TO_CONFIGURATION_FIELD.get(field).getName(),
                            productOpening.get(field)
                        );
                    }
                    //attributesToUpdate.add(configurationProductAttribute);
                    System.debug('--- Configuration Product Attribute: '+configurationProductAttribute);
                */
                else if(docTitle.Contains('Report')) {
                    System.debug('--- Processing Report File Name: '+docTitle);
                    String blindsContent = link.ContentDocument.LatestPublishedVersion.VersionData.toString();
                    System.debug('*** configurationsProductsByPlan ***'+configurationsProductsByPlan);
                    System.debug('*** link.LinkedEntityId ***'+link.LinkedEntityId);
                    if(!configurationsProductsByPlan.containsKey(link.LinkedEntityId)) {
                        continue;
                    }
                    Integer sideCounter = 1;
                    List<Configuration_Product__c> cfgProdList = [SELECT Id,Sovelia_Structure_Number__c,Configuration__r.Opportunity__r.Contract_Locale__c from Configuration_Product__c where ID IN: configurationsProductsByPlan.get(link.LinkedEntityId)];
                    for(Configuration_Product__c configurationProduct : cfgProdList) {
                        System.debug('*** docTitle ***'+docTitle);
                        System.debug('*** configurationProduct ***'+configurationProduct.Sovelia_Structure_Number__c);
                        if(docTitle.contains(configurationProduct.Sovelia_Structure_Number__c)){
                            Map<String, Object> blindsJSONMap = (Map<String, Object>) JSON.deserializeUntyped(blindsContent);
                            Map<String, Integer> blindsSideMap = new Map<String, Integer>();
                            system.debug('blindsJSONMap------'+ blindsJSONMap);
                            for (String blindsVal : blindsJSONMap.keyset()) {
                                
                                if(blindsVal != 'RVN'){
                                    ConfigurationSide sideAndPanes2 = new ConfigurationSide();
                                    Configuration_Side__c blindsSide = new Configuration_Side__c();
                            		Configuration_Side_Pane__c blindsSidePane = new Configuration_Side_Pane__c();
                                    String blindsObj = JSON.serialize(blindsJSONMap.get(blindsVal));
                                    Map<String,Object> blindsMap  = (Map<String,Object>) JSON.deserializeUntyped(blindsObj);
                                    
                                    if(blindsMap.get('blind_ID') == null && blindsSideMap.get(String.valueOf(blindsMap.get('blind_ID'))) == null){
                                        blindsSide.put('Side_Number__c',sideCounter);
                                        blindsSide.put('Configuration_Product__c',configurationProduct.Id);
                                        blindsSide.put('Name',String.valueOf(blindsMap.get('blind_ID')));
                                        blindsSideMap.put(String.valueOf(blindsMap.get('blind_ID')),sideCounter);
                                        sideCounter++;
                                        sideAndPanes2.side = blindsSide;
                                    }
                                    else if(blindsSideMap.keyset() != NULL && !blindsSideMap.keyset().contains(String.valueOf(blindsMap.get('blind_ID'))) && blindsMap.get('blind_ID') != null){
                                        blindsSide.put('Side_Number__c',sideCounter);
                                        blindsSide.put('Configuration_Product__c',configurationProduct.Id);
                                        blindsSide.put('Name',String.valueOf(blindsMap.get('blind_ID')));
                                        blindsSideMap.put(String.valueOf(blindsMap.get('blind_ID')),sideCounter);
                                        sideCounter++;
                                        sideAndPanes2.side = blindsSide;
                                    }
                                    
                                    Map<String,Object> blindCodesMap = getBlindCodesByMap();
                                    
                                    String contractLocale = configurationProduct.Configuration__r.Opportunity__r.Contract_Locale__c;
                                    String blindColortranslation = contractLocale + '-' + String.valueOf(blindsMap.get('fabric'));
                                    blindColortranslation  = (blindCodesMap != NULL && blindCodesMap.get(blindColortranslation) != NULL) ? JSON.serialize(blindCodesMap.get(blindColortranslation)) : String.valueOf(blindsMap.get('fabric'));
                                    blindColortranslation = blindColortranslation.replace('\\"','');
                                    
                                    String profileColortranslation = contractLocale + '-' + String.valueOf(blindsMap.get('profile_color'));
                                    profileColortranslation  = (blindCodesMap != NULL && blindCodesMap.get(profileColortranslation) != NULL)  ? JSON.serialize(blindCodesMap.get(profileColortranslation)) : String.valueOf(blindsMap.get('profile_color'));
                                    profileColortranslation = profileColortranslation.replace('\\"','');
                                    
                                    
                                    System.debug('--- ConfigurationDataController blindColortranslation ---'+blindColortranslation);
                                    System.debug('--- ConfigurationDataController profileColortranslation ---'+profileColortranslation);
                                    
                                    blindsSidePane.put('Blinds_Color__c',blindColortranslation);
                                    blindsSidePane.put('Blinds_Profile_Color__c',profileColortranslation);
                                    blindsSidePane.put('Blinds_Type__c',blindsMap.get('blind_type'));
                                    blindsSidePane.put('Glass_Number__c',blindsMap.get('blind_number'));
                                    blindsSidePane.put('Height__c',blindsMap.get('height'));
                                    blindsSidePane.put('Width__c',blindsMap.get('width'));
                                    blindsSidePane.put('Blind_Id__c',blindsMap.get('blind_ID'));
                                    blindsSidePane.put('Edge_Profile_Color__c',blindsMap.get('edge_profilecolor'));
                                    blindsSidePane.put('Case_Profile_Color__c',blindsMap.get('housing_profilecolor'));
                                    blindsSidePane.put('Quantity__c',blindsMap.get('qty'));
                                     
                               		sideAndPanes2.panes.add(blindsSidePane);
                                    blindsPanes.add(sideAndPanes2);
                                }
                            }
                            
                        }
                        
                    }
                    
                }else {
                    System.debug('--- Unknown File');
                }
            } catch (Exception e) {
                System.debug(e.getStackTraceString());
                System.debug(e);
            }
        }
        System.Debug('--- Process Side and Panes'+sidesPanes);
        updateSidesAndPanes(sidesPanes);
        updateBlindsSidesAndPanes(blindsPanes);
        delete [
            SELECT Id, Configuration_Product__c
            FROM Configuration_Attribute__c WHERE Configuration_Product__c IN :configurationProducts
        ];
        upsert attributesToUpdate;
    }
    
    private static void populateValuesToRecordFromXML(
        Dom.XmlNode node,
        String nodePath,
        SObject record,
        Map<String, Schema.DescribeFieldResult> fields
    ) {
        if (node == null) {
            return;
        }
        
        for (Dom.XmlNode child : node.getChildElements()) {
            if(child != null) {
                String elementName = child.getName();
                String key = nodePath + '/' + elementName;
                if (fields.containsKey(key)) {
                    Schema.DescribeFieldResult field = fields.get(key);
                    if(field.getType() == DisplayType.String){
                        record.put(field.getName(), child.getText());
                    } else if(field.getType() == DisplayType.Double){
                        Integer adder = new Set<String>{'side/number', 'glass/number','upholstery/upholstery_number'}.contains(key) ? 1 : 0;
                        record.put(field.getName(), Integer.valueOf(child.getText()) + adder);
                    } else if(field.getType() == DisplayType.Boolean
                        && new Set<String>{'LUMON_NO_BLINDS', 'DOCXML_NO'}.contains(child.getText())
                    ) {
                        record.put(field.getName(), false);                        
                    }
                }
            }
        }
    }
    
    // Populate from XML node where key is given element (keyField) and value is in another element (valueField)
    private static void populateValuesToRecordFromXML(
        Dom.XmlNode node,
        String nodePath,
        SObject record,
        Map<String, Schema.DescribeFieldResult> fields,
        String keyField,
        String valueField
    ) {
        
        if (node == null) {
            return;
        }
        Dom.XmlNode keyElement = node.getChildElement(keyField, null);
        Dom.XmlNode valueElement = node.getChildElement(valueField, null);
        if(keyElement == null || valueElement == null) {
            return;
        }
        String keyElementText = keyElement.getText();
        String key = nodePath + '/' + keyField + '/' + keyElementText;
        if (fields.containsKey(key)) {
            Schema.DescribeFieldResult field = fields.get(key);
            if(field.getType() == DisplayType.String){
                record.put(field.getName(), valueElement.getText());
                // Force update
                if(keyElementText == 'Blinds') record.put('Has_Blinds__c', true);
            } else if(field.getType() == DisplayType.Double){
                record.put(field.getName(), Integer.valueOf(valueElement.getText()));
            } else if(field.getType() == DisplayType.Boolean
                && ((keyElementText == 'Blinds' && String.isNotBlank(valueElement.getText()))
                    || (keyField == 'feature_name' && keyElement.getText() == 'SandBlasting'))
            ) {
                record.put(field.getName(), true);
            }
        }
    }
    
    private static final Map<String, Schema.DescribeFieldResult> SIDE_FIELDS = new Map<String, Schema.DescribeFieldResult> {
        'side/glasses_left' => Configuration_Side__c.Glass_Opening_Left__c.getDescribe(),
        'side/glasses_right' => Configuration_Side__c.Glass_Opening_Right__c.getDescribe(),
        'side/latch_left' => Configuration_Side__c.Left_Latch__c.getDescribe(),
        'side/latch_right' => Configuration_Side__c.Right_Latch__c.getDescribe(),
        'side/number' => Configuration_Side__c.Side_Number__c.getDescribe(),
        'side/structural_width' => Configuration_Side__c.Side_Width__c.getDescribe(),
        'side/opening_width' => Configuration_Side__c.Opening_Width__c.getDescribe(),
        'side/number_of_posts' => Configuration_Side__c.Number_Of_Posts__c.getDescribe()
    };
    private static final Map<String, Schema.DescribeFieldResult> SIDE_PANE_FIELDS = new Map<String, Schema.DescribeFieldResult> {
        'glass/number' => Configuration_Side_Pane__c.Glass_Number__c.getDescribe(),
        'glass/blinds' => Configuration_Side_Pane__c.Has_Blinds__c.getDescribe(),
        'glass/sandblasting' => Configuration_Side_Pane__c.Has_Sand_Blasting__c.getDescribe(),
        'upholstery/upholstery_number' => Configuration_Side_Pane__c.Glass_Number__c.getDescribe(),
        'upholstery/upholstery_width' => Configuration_Side_Pane__c.Width__c.getDescribe(),
        'upholstery/upholstery_height' => Configuration_Side_Pane__c.Height__c.getDescribe(),
        'upholstery/upholstery_material' => Configuration_Side_Pane__c.Upholstery_Material__c.getDescribe(),
        'upholstery/upholstery_silkprint' => Configuration_Side_Pane__c.SilkPrint__c.getDescribe(),
        'upholstery/upholstery_color' => Configuration_Side_Pane__c.Glass_Color__c.getDescribe(),
        'upholstery/upholstery_sandblasting' => Configuration_Side_Pane__c.Sandblasting__c.getDescribe(),
        'upholstery/upholstery_sandblasting_height' => Configuration_Side_Pane__c.Sandblasting_Height__c.getDescribe(),
        'upholstery/upholstery_glasswithhole' => Configuration_Side_Pane__c.GlasswithHole__c.getDescribe()
              
    };
    private static final Map<String, Schema.DescribeFieldResult> SIDE_PANE_GLASSCOLOR_FIELD = new Map<String, Schema.DescribeFieldResult> {
    	'products/balconyglazing/glass_color'=> Configuration_Side_Pane__c.Glass_Color__c.getDescribe(), // Temporary fix to get glass color value for the panels
        'products/balustrade/upholstery_material' => Configuration_Side_Pane__c.Glass_Color__c.getDescribe() // Temporary fix to get glass color value for the panels
    };
    private static final Map<String, Schema.DescribeFieldResult> SIDE_PANE_DIFFERENCE_FIELDS = new Map<String, Schema.DescribeFieldResult> {
        'difference/feature_name/BlindsColor' => Configuration_Side_Pane__c.Blinds_Color__c.getDescribe(),
        'difference/feature_name/BlindsProfileColor' => Configuration_Side_Pane__c.Blinds_Profile_Color__c.getDescribe(),
        'difference/feature_name/Blinds' => Configuration_Side_Pane__c.Blinds_Type__c.getDescribe(),
        // Glass
        'difference/feature_name/GlassType' => Configuration_Side_Pane__c.Glass_Type__c.getDescribe(),
        'difference/feature_name/UpholsteryPlateColor' => Configuration_Side_Pane__c.Glass_Color__c.getDescribe(),
        // Check this only if Has_Sand_Blasting__c is null
        'difference/feature_name/SandBlasting' => Configuration_Side_Pane__c.Has_Sand_Blasting__c.getDescribe(),
        // Latch
        'difference/feature_name/MiddleLatchHeightLeft' => Configuration_Side_Pane__c.Middle_Latch_Height_Left__c.getDescribe(),
        'difference/feature_name/MiddleLatchHeightRight' => Configuration_Side_Pane__c.Middle_Latch_Height_Right__c.getDescribe(),
        'difference/feature_name/MiddleLatchLeft' => Configuration_Side_Pane__c.Middle_Latch_Left__c.getDescribe(),
        'difference/feature_name/MiddleLatchRight' => Configuration_Side_Pane__c.Middle_Latch_Right__c.getDescribe()
    };

    private static List<ConfigurationSide> populateSidesAndPanes(
        Dom.XmlNode node,
        String nodePath,
        Configuration_Product__c product 
    ) {
        String paneNode = '';
        String paneChildNode = '';
        List<ConfigurationSide> sidesPanes = new List<ConfigurationSide>();
        Dom.XmlNode sidesElement = node.getChildElement('sides', null);
        List<Dom.XmlNode> sides = sidesElement?.getChildElements();
        if(sides == null || sides.isEmpty()) {
            return sidesPanes;
        }

        for(Dom.XmlNode side : sides) {
            ConfigurationSide sideAndPanes = new ConfigurationSide();
            Integer paneCounter = 0;
            sideAndPanes.side.Configuration_Product__c = product.Id;
            populateValuesToRecordFromXML(side, 'side', sideAndPanes.side, SIDE_FIELDS);
            
            if(nodePath.contains('balustrade')){
                paneNode = 'upholsterys';
                paneChildNode = 'upholstery';
            }else{
                paneNode = 'glasses';
                paneChildNode = 'glass';
            }
            Dom.XmlNode glassesElement = side.getChildElement(paneNode, null);
            List<Dom.XmlNode> glasses = glassesElement?.getChildElements();
            if(glasses != null) {
                for(Dom.XmlNode glass : glasses) {
                    Configuration_Side_Pane__c pane = new Configuration_Side_Pane__c();
                    sideAndPanes.panes.add(pane);
                    paneCounter++;
                    sideAndPanes.side.Number_Of_Panels__c = paneCounter;
                    populateValuesToRecordFromXML(glass, paneChildNode , pane, SIDE_PANE_FIELDS);
                    
                    Dom.XmlNode differencesElement = glass.getChildElement('differences', null);
                    List<Dom.XmlNode> differences = differencesElement?.getChildElements();
                    
                    if(differences != null) {
                        for(Dom.XmlNode difference : differences) {
                            // Temporary fix to get Glass color values to the side pane from config attibute
                            Dom.XmlNode keyElement = difference.getChildElement('feature_name', null);
                            if(keyElement.getText() == 'GlassColor' || keyElement.getText() == 'UpholsteryPlateColor'){
                                populateValuesToRecordFromXML(node, nodePath , pane, SIDE_PANE_GLASSCOLOR_FIELD);
                            }
                            if(paneChildNode == 'upholstery'){
                                populateValuesToRecordFromXML(
                    				difference, 'difference', pane, SIDE_PANE_DIFFERENCE_FIELDS, 'feature_name', 'translation');
                            }else{
                                populateValuesToRecordFromXML(
                                	difference, 'difference', pane, SIDE_PANE_DIFFERENCE_FIELDS, 'feature_name', 'value');
                            }
                        }
                    }
                }
            }
            sidesPanes.add(sideAndPanes);
        }
        return sidesPanes;
    }

    private static void updateSidesAndPanes(List<ConfigurationSide> sidesPanes) {
        if(sidesPanes.isEmpty()) {
            return;
        }
        List<Configuration_Side__c> sides = new List<Configuration_Side__c>();
        Set<Id> configurationProductIds = new Set<Id>();
        List<Configuration_Side_Pane__c> sidePanes = new List<Configuration_Side_Pane__c>();
        for(ConfigurationSide sideAndPane : sidesPanes) {
            Configuration_Side__c side = sideAndPane.side;
            if(side != null) {
                sides.add(side);
                if(side.Configuration_Product__c != null) {
                    configurationProductIds.add(side.Configuration_Product__c);
                }
            }
        }
        if(configurationProductIds.isEmpty()) {
            return;
        }
        delete [
            SELECT Id FROM Configuration_Side_Pane__c
            WHERE Configuration_Side__r.Configuration_Product__c IN :configurationProductIds
        ];
        delete [SELECT Id FROM Configuration_Side__c WHERE Configuration_Product__c IN :configurationProductIds];
        insert sides;
        for(ConfigurationSide sideAndPane : sidesPanes) {
            Configuration_Side__c side = sideAndPane.side; 
            if(side != null) {
                for(Configuration_Side_Pane__c pane : sideAndPane.panes) {
                    pane.Configuration_Side__c = side.Id;
                    sidePanes.add(pane);
                }
            }
        }
        insert sidePanes;
    }
    
    private static void updateBlindsSidesAndPanes(List<ConfigurationSide> sidesPanes) {
        if(sidesPanes.isEmpty()) {
            return;
        }
        List<Configuration_Side__c> sides = new List<Configuration_Side__c>();
        Set<Id> configurationProductIds = new Set<Id>();
        List<Configuration_Side_Pane__c> sidePanes = new List<Configuration_Side_Pane__c>();
        for(ConfigurationSide sideAndPane : sidesPanes) {
            Configuration_Side__c side = sideAndPane.side;
            if(side != null) {
                if(side.Configuration_Product__c != null) {
                    sides.add(side);
                    configurationProductIds.add(side.Configuration_Product__c);
                }
            }
        }
        if(configurationProductIds.isEmpty()) {
            return;
        }
        delete [
            SELECT Id FROM Configuration_Side_Pane__c
            WHERE Configuration_Side__r.Configuration_Product__c IN :configurationProductIds
        ];
        delete [SELECT Id FROM Configuration_Side__c WHERE Configuration_Product__c IN :configurationProductIds];
        insert sides;
        Map<String,Id> paneMap = new Map<String,Id>();
        for(ConfigurationSide sideAndPane : sidesPanes) {
            Configuration_Side__c side = sideAndPane.side;
                for(Configuration_Side_Pane__c pane : sideAndPane.panes) {
                    if(side.Id != NULL && pane.Blind_Id__c == side.Name){
                    	pane.Configuration_Side__c = side.Id;
                        paneMap.put(pane.Blind_Id__c,pane.Configuration_Side__c);
                        sidePanes.add(pane);
                    }else if(side.Id == NULL && paneMap.get(pane.Blind_Id__c) != NULL){
                        pane.Configuration_Side__c = paneMap.get(pane.Blind_Id__c);
                        sidePanes.add(pane);
                    }
                }
        }
        insert sidePanes;
    }
    
    // method return the BlindCode translation with the language+code as akey and value as a codevad
    public static Map<String,Object> getBlindCodesByMap(){
        Map<String, object> languageBlindCodeMap = new Map<String, Object>();
        List<cadmus_core__Data_Source__c> cadmusCoreRec = [SELECT ID,Name,cadmus_core__Static_Data_JSON__c 
                                                     FROM cadmus_core__Data_Source__c 
                                                     WHERE Name ='Visual Blinds Translations' LIMIT 1]; 
        if(cadmusCoreRec.size() > 0){
            Map<String, Object> intialBlindMap = (Map<String, Object>)JSON.deserializeUntyped(cadmusCoreRec[0].cadmus_core__Static_Data_JSON__c);
        
            Map<String, Object> languageBlindMap = (Map<String, Object>)JSON.deserializeUntyped(JSON.Serialize(intialBlindMap.get('PDFBUTLERLocales')));
            
            
            
            for(String langugeKey: languageBlindMap.keySet()) {
                Map<String, Object> blindCodeMap =(Map<String, Object>)JSON.deserializeUntyped(JSON.Serialize(languageBlindMap.get(langugeKey)));
                for(String  codeValue :blindCodeMap.keySet()){
                    languageBlindCodeMap.Put(langugeKey+'-'+codeValue, blindCodeMap.get(codeValue));
                }
            }
        	String blindColortranslation = 'en_US-3501';
        }
        return languageBlindCodeMap;
    }
    
    private class ConfigurationSide {
        public Configuration_Side__c side = new Configuration_Side__c();
        public Integer numberOfPanes;
        public List<Configuration_Side_Pane__c> panes = new List<Configuration_Side_Pane__c>();
    }
}