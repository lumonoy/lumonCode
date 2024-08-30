/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-02-2023
 * @last modified by  : Henk Reynders
**/
 @RestResource(urlMapping='/processOutput/*')
 global with sharing class ProcessVisualOutput {
	 @HttpPost
	 global static void doPost() {
		 String result = '';
		 RestRequest request = RestContext.request;
		 String allParams = request.requestURI.substringAfter('/processOutput/');
		 Integer indexOfSlash = allParams.indexOf('/');
		 String configsId = allParams.substring(0, indexOfSlash);
		 String confAndSlash = configsId + '/';
		 String methodAndExt = allParams.substringAfter(confAndSlash);
		 String method = methodAndExt.substring(0, methodAndExt.indexOf('/'));
		 String fileExtension = allParams.substringAfter(method + '/');
		 List<String> imagesExtensions = new List<String>{'jpg', 'jpeg', 'png', 'pdf'};
		 String visualId = '';
		 String configId = '';
		 String recordId = '';
 
		 if (configsId.contains('&')) {
			 recordId = configsId.substringBefore('&');
			 System.debug('---  recordId: ' +recordId);
			 visualId = configsId.substringBetween('&');
			 System.debug('---  visualId --- '+visualId);
			 configId = configsId.substringAfterLast('&');
			 System.debug('---  configId --- '+configId);
		 } else {
			 recordId = configsId;
			 System.debug('---  recordId --- '+recordId);
		 }
		 //Find Configuration parent Record 
		 List<Opportunity> opps = [SELECT Id FROM Opportunity WHERE Id =: recordId];
		 if (!opps.isEmpty()) {
			 Configuration__c configToInsert;
			 String methodName = method.replaceAll('%20', ' ');
			 String structureNumber = '';
			 System.debug('---  methodName: '+methodName);
			 structureNumber = methodName.contains('Visual Output_') ? methodName.substringAfter('Visual Output_') : methodName.substringAfter('Visual_Structure_');
			 System.debug('---  Structure number: ' + structureNumber);
			 
			 if (!String.isBlank(structureNumber) && structureNumber.contains('.')) {
				structureNumber = structureNumber.substringBefore('.');
			 }
			 Id relatedConfigId;
			 System.debug('---  configs for record with Id: '+recordId);
			 ContentVersion contVerFile = new ContentVersion();
			 if (imagesExtensions.contains(fileExtension)) {
				 contVerFile.VersionData = EncodingUtil.base64Decode(request.requestBody.toString());
			 } else {
				 contVerFile.VersionData = request.requestBody;
			 }
			 contVerFile.Title = method.replaceAll('%20', ' ');
			 contVerFile.ContentLocation= 's';
			 contVerFile.PathOnClient = method + '.' + fileExtension;
 
			 String planName = '';
			 String planApartment = '';
			 Integer planFloor;
             String planType = 'Visual';
			 String planLine = '';
			 Boolean isPricingJson = false;
			 String content = '';
			 System.debug('---  fileExtension: ' + fileExtension + ', name: ' + methodName);
			 if (fileExtension == 'json' && methodName.contains('Pricing')) {
				 System.debug('---  Visual Pricing Data');
				 isPricingJson = true;
				 VisualConfiguration configObject = VisualConfiguration.parseVisualConfiguration(request.requestBody.toString());
				 System.debug('---  configObject: ' + configObject);
				 content = request.requestBody.toString();
				 System.debug('---  request body: ' + content);
				 if (configObject != null) {
					 planName = configObject.name != null ? configObject.name : '';
					 planApartment = configObject.apartment != null ? configObject.apartment : '';
					 planFloor = configObject.floor != null && configObject.floor.isNumeric()? Integer.valueOf(configObject.floor) : null;
					 planLine = configObject.line != null ? configObject.line : '';
				 }
			 }
			 System.debug('--- planName: ' + planName);
			 System.debug('--- planApartment: ' + planApartment);
			 System.debug('--- planFloor: ' + planFloor);
			 System.debug('--- planLine: ' + planLine);
			 if (configId != null && configId != '') {
				 // On EDIT Plan (when Configuration__c record exists)
				 relatedConfigId = configId;
				 List<Configuration__c> configs = [SELECT Id, Visual_Structure_Number__c FROM Configuration__c WHERE Id =: configId];
				 System.debug('--- configs: ' + configs);
				 if (!configs.isEmpty() && structureNumber != '') {
					 configs[0].Visual_Structure_Number__c = structureNumber;
					 System.debug('--- configs[0]: ' + configs[0]);
					 update configs[0];
				 }
				 if (!configs.isEmpty() && isPricingJson) {
					 // On EDIT Plan (when Configuration__c record exists) and it is  Pricing Data
					 System.debug('--- Step 1a: Config Plan(s) '+configs);
					 configs[0].Visual_Structure_Number__c = structureNumber;
					 /*configs[0].Plan_Apartment__c = planApartment;
					 if (planFloor != null) {
						 configs[0].Plan_Floor__c = planFloor;
					 }
					 configs[0].Plan_Line__c = planLine;
					 configs[0].Plan_Name__c = planName;
					 System.debug('--- configs[0]: ' + configs[0]);*/
					 update configs[0];
				 }
				 List<ContentDocumentLink> docs = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId =: configId AND ContentDocument.Title =: methodName];
				 if (!docs.isEmpty()) {
					 contVerFile.ContentDocumentId = docs[0].ContentDocumentId;
				 }
			 } else if (visualId != null && visualId != '') {
				 // On EDIT Plan (when Configuration__c record does not exist)
				 List<Configuration__c> configs = [SELECT Id, Visual_Structure_Number__c FROM Configuration__c WHERE Visual_Id__c =: visualId];
				 if (!configs.isEmpty()) {
					 relatedConfigId = configs[0].Id;
					 if (structureNumber != '') {
						 configs[0].Visual_Structure_Number__c = structureNumber;
						 update configs[0];
					 }
					 if (isPricingJson) {
						 configs[0].Plan_Apartment__c = planApartment;
						 if (planFloor != null) {
							 configs[0].Plan_Floor__c = planFloor;
						 }
						 configs[0].Plan_Line__c = planLine;
						 configs[0].Plan_Name__c = planName;
                         configs[0].Plan_Type__c = planType;
						 update configs[0];
					 }
					 List<ContentDocumentLink> docs = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId =: configs[0].Id AND ContentDocument.Title =: methodName];
					 if (!docs.isEmpty()) {
						 contVerFile.ContentDocumentId = docs[0].ContentDocumentId;
					 }
				 } else {
					 // On NEW Plan (when Configuration__c record does NOT exist)
					 configToInsert = new Configuration__c(Name = planName, Opportunity__c = recordId, Visual_Id__c = visualId);
					 if (structureNumber != '') {
						 configToInsert.Visual_Structure_Number__c = structureNumber;
					 }
					 if (isPricingJson) {
						 configToInsert.Plan_Apartment__c = planApartment;
						 if (planFloor != null) {
							 configToInsert.Plan_Floor__c = planFloor;
						 }
						 configToInsert.Plan_Line__c = planLine;
						 configToInsert.Plan_Name__c = planName;
                         configToInsert.Plan_Type__c = planType;
						 configToInsert.Name = planName;
					 }
					 insert configToInsert;
					 relatedConfigId = configToInsert.Id;
				 }
			 } else {
				 configToInsert = new Configuration__c(Name = planName,Opportunity__c = recordId, Visual_Id__c = visualId);
				 if (structureNumber != '') {
					 configToInsert.Visual_Structure_Number__c = structureNumber;
				 }
				 if (isPricingJson) {
					 configToInsert.Plan_Apartment__c = planApartment;
					 if (planFloor != null) {
						 configToInsert.Plan_Floor__c = planFloor;
					 }
					 configToInsert.Plan_Line__c = planLine;
					 configToInsert.Plan_Name__c = planName;
                     configToInsert.Plan_Type__c = planType;
				 }
				 insert configToInsert;
				 relatedConfigId = configToInsert.Id;
				 
			 }
 
			 insert contVerFile;
 
			 if (relatedConfigId != null) {
				 Configuration__c relatedConfig = [SELECT Id,Opportunity__c,Visual_Id__c from Configuration__c where ID =:relatedConfigId];
				 ContentVersion contDoc = [SELECT ContentDocumentId,Title FROM ContentVersion WHERE Id =: contVerFile.Id and isLatest = TRUE];
				 System.debug('---  contDoc --- '+contDoc.Title);
				 Integer linkedDocs = [SELECT count() FROM ContentDocumentLink WHERE ContentDocumentId =: contDoc.ContentDocumentId AND LinkedEntityId =: relatedConfigId];
				 System.debug('---  linkedDocs --- '+linkedDocs);
				 if (linkedDocs == 0) {
					 insert new ContentDocumentLink(ContentDocumentId = contDoc.ContentDocumentId, ShareType = 'V', LinkedEntityId = relatedConfigId);
				 }
				 if(isPricingJson){
					 // Publish a new Configuration Event by calling the VisualConfigurationEvent (Controller)
					 System.debug('---  publish Configuration Change Event --- ');
					 String cfgType = 'Visual';
					 String cfgAction = 'Configure';
					 String cfgRecordId = relatedConfig.Opportunity__c; //Change to Support other objects
					 String cfgObjectType = 'Opportunity'; // Fixed for now
					 String cfgPlanId = relatedConfig.Id;
					 String cfgVisualId = relatedConfig.Visual_Id__c;
					 String cfgDocLinkId; // DO NOT USE cdL.Id
					 String cfgJSON = content;
					 ConfigurationEvent.publishConfigurationEvent(cfgType,cfgAction,cfgPlanId,//Visual, Price
					 												cfgRecordId,cfgObjectType,
																	 cfgVisualId,cfgDocLinkId,cfgJSON);
				 }
			 }
			 
		 }
		 
		 result = '{"status" : "success"}';
		 RestContext.response.addHeader('Content-Type','application/json');
		 System.debug('--- resp: ' + result);
		 RestContext.response.responseBody = Blob.valueOf(result);
	 }
 }