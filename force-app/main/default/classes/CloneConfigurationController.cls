/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-05-2023
 * @last modified by  : Henk Reynders
**/
public class CloneConfigurationController {
    @InvocableMethod(callout=true label='Clone Configuration')
    public static List<String> cloneConfiguration(List<Id> reclamationConfigId) {
        // Only first Plan in List will be Processed
        Configuration__c configPlan = [SELECT Id,Opportunity__c,Visual_Id__c, Plan_Type__c FROM Configuration__c WHERE Id =: reclamationConfigId[0]];
		String configPlanType = configPlan.Plan_Type__c;
		List<String> copyPlanResult = new List<String>();
		if (String.IsNotBlank(configPlanType) && configPlanType == 'Visual') {
        	List<Configuration__c> clonedConfigList = cloneVisualConfigurations(configPlan.Opportunity__c,new List<Id>{configPlan.Id});
			if(clonedConfigList.size() > 0){
				copyPlanResult =  new List<String>{'success'};
			}else{
				copyPlanResult = new List<String>{'Error while Cloning Configuration Plan'};     
			}
		} else {
			copyPlanResult = new List<String>{'Error while Cloning Configuration Plan'};     
		}
		return copyPlanResult;
    }
	// This and cloneConfigurationPlan needs to be called in separate transactions
	@AuraEnabled 
	public static List<Configuration__c> cloneVisualConfigurations(Id opportunityId, List<Id> configurationPlanIds) {
        Opportunity opportunity = [SELECT Order_type__c FROM Opportunity WHERE Id = :opportunityId LIMIT 1];
		List<Configuration__c> configurationPlans = [
			SELECT Visual_Id__c
			FROM Configuration__c WHERE Opportunity__c = :opportunityId
			AND Id IN :configurationPlanIds
			AND Visual_Id__c != ''
		];
		if(configurationPlans.isEmpty()) {
			return null;
		}
		String envName = 'production';
		if ([SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox) {
			envName = String.valueOf(URL.getOrgDomainUrl()).substringBetween('--', '.sandbox');
			envName = envName.remove('--c');
			if (envName != 'lumonTest' && envName != 'develop1' ) {
				envName = 'sandbox';
			}
		}
		Integration_Credentials__mdt credentials = [
			SELECT API_Key__c, Endpoint__c
			FROM Integration_Credentials__mdt
			WHERE Integration_Name__c = 'CloneConfig' AND Environment_Name__c = :envName
		];
		Map<Id, Id> newOldConfigurationPlans = new Map<Id, Id>();
		VisualRequestBody visualRequest = new VisualRequestBody();
		visualRequest.Parameters = new List<VisualRequestParameter>();
		visualRequest.Algorithm = 'HMACSHA256';
		List<Configuration__c> configurationPlansToUpdate = new List<Configuration__c>();
		for(Configuration__c configurationPlan : configurationPlans) {
			String configurationPlanId = configurationPlan.Id;
			String visualId = configurationPlan.Visual_Id__c;
			VisualRequestParameter parameter = new VisualRequestParameter();
			parameter.WebId = visualId;
			parameter.Count = 1;
			visualRequest.Parameters.add(parameter);
			configurationPlansToUpdate.add(configurationPlan);
		}

		// TODO If you can add multiple parameters to the request, the for loop is not needed
		String secretKey = credentials.API_Key__c;
		String encodedBody = EncodingUtil.base64Encode(Blob.valueOf(JSON.serialize(visualRequest)));
		String signedRequest = EncodingUtil.base64Encode(
			Crypto.generateMac('hmacSHA256', Blob.valueOf(encodedBody), Blob.valueOf(secretKey))
		);

		Http http = new Http();
		String endpoint = credentials.Endpoint__c;
		HttpRequest request = new HttpRequest();
		request.setEndpoint(endpoint);
		request.setMethod('POST');
		request.setTimeout(120000);
		request.setHeader('Content-Type', 'application/json;charset=UTF-8');
		String body = signedRequest + '.' + encodedBody;
		request.setBody(body);
		HttpResponse visualResponse = http.send(request);

		Integer statusCode = visualResponse.getStatusCode();
		if (statusCode >= 200 && statusCode < 300) {
			ResponseWrapper response = (ResponseWrapper) JSON.deserialize(visualResponse.getBody(), ResponseWrapper.class);
			if (String.isBlank(response.error) && response.items != null) {
				for(Integer i = 0; i < response.items.size(); i++) {
					ItemWrapper item = response.items.get(i);
					Configuration__c configurationPlan = configurationPlansToUpdate.get(i);
					configurationPlan.Visual_Id__c = item.copies != null ? item.copies.get(0) : '';
					configurationPlan.Plan_Name__c = configurationPlan.Visual_Id__c;
					configurationPlan.Name = configurationPlan.Visual_Id__c;
				}
			}
		}
		update configurationPlansToUpdate;
		return configurationPlansToUpdate;	
	}
	
	private static Map<String, List<String>> getFields(List<String> sObjectNames) {
		Map<String, List<String>> sObjectFields = new Map<String, List<String>>();
		List<Schema.DescribeSObjectResult> sObjectDescResults = Schema.describeSObjects(sObjectNames);
		for (Schema.DescribeSObjectResult sObjectDescResult : sObjectDescResults) {
			List<String> fields = new List<String>();
			sObjectFields.put(sObjectDescResult.getName(), fields);
			for (Schema.SObjectField field : sObjectDescResult.fields.getMap().values()) {
				Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
				fields.add(fieldDescribe.getName());
			}
		}
		return sObjectFields;
	}

	@AuraEnabled
	public static List<Id> cloneConfigurationPlan(Id opportunityId, List<Id> configurationIds) {
		List<Id> clonedConfigurationIds = new List<Id>();
        for(Id configurationId : configurationIds) {
			List<String> sObjectNames = new List<String>{
				'Configuration__c',
				'Configuration_Product__c'
				// 'Configuration_Option__c',
				// 'Pricing_Summary__c',
				// 'QuoteLineItem'
			};
			Map<String, List<String>> fields = getFields(sObjectNames);

			Map<String, List<String>> sObjectRelationsToUpdate = new Map<String, List<String>>{
				'Configuration_Product__c' => new List<String>{ 'Configuration__c' },
				'Configuration_Option__c' => new List<String>{ 'Configuration_Product__c' },
				'Pricing_Summary__c' => new List<String>{ 'Configuration_Plan__c' },
				'QuoteLineItem' => new List<String>{
					'Configuration_Plan__c',
					'Configuration_Product__c',
					'Configuration_Option__c'
				}
			};

			Map<String, List<String>> sObjectWhereConditions = new Map<String, List<String>>{
				'Configuration__c' => new List<String>{ 'Id = :configurationId' },
				'Configuration_Product__c' => new List<String>{ 'Configuration__r.Id = :configurationId' },
				'Configuration_Option__c' => new List<String>{
					'Configuration_Product__r.Configuration__r.Id = :configurationId'
				},
				'Pricing_Summary__c' => new List<String>{ 'Opportunity__c = :opportunityId' },
				'QuoteLineItem' => new List<String>{ 'Configuration_Plan__c = :configurationId' }
			};

			Map<Id, SObject> oldRecords = new Map<Id, SObject>();
			Map<Id, Id> oldToNewId = new Map<Id, Id>();
			Map<Id, SObject> clonedRecords = new Map<Id, SObject>();
			Map<String, List<SObject>> recordsToClone = new Map<String, List<SObject>>{
				'Configuration__c' => new List<SObject>(),
				'Configuration_Product__c' => new List<SObject>(),
				'Configuration_Option__c' => new List<SObject>(),
				'Pricing_Summary__c' => new List<SObject>(),
				'QuoteLineItem' => new List<SObject>()
			};

			for (String sObjectName : sObjectNames) {
				List<SObject> records = Database.query(
					String.join(
						new List<String>{
							'SELECT',
							String.join(fields.get(sObjectName), ', '),
							'FROM',
							sObjectName,
							'WHERE',
							String.join(sObjectWhereConditions.get(sObjectName), 'AND')
						},
						' '
					)
				);

				List<String> relationShipFields = sObjectRelationsToUpdate.get(sObjectName);
				List<SObject> clones = recordsToClone.get(sObjectName);
				List<Id> oldIds = new List<Id>();
				for (SObject record : records) {
					SObject clonedRecord = record.clone(false);
					if(sObjectName == 'Configuration__c') {
						clonedRecord.put('Visual_Id__c', ((String)clonedRecord.get('Visual_Id__c')));
						clonedRecord.put('Name', null);
						clonedRecord.put('Plan_Name__c', null);
					}
					Id recordId = (Id) record.get('Id');
					oldIds.add(recordId);
					oldRecords.put(recordId, record);
					clones.add(clonedRecord);
					if (relationShipFields != null) {
						for(String field : relationShipFields) {
							clonedRecord.put(field, oldToNewId.get((Id)(oldRecords.get(recordId).get(field))));
						}
					}
				}
				insert clones;
				
				for(Integer i = 0; i < clones.size(); i++) {
					Id oldId = oldIds.get(i);
					SObject clonedRecord = clones.get(i);
					Id clonedRecordId = (Id) clonedRecord.get('Id');
					oldToNewId.put(oldId, clonedRecordId);
					if(sObjectName == 'Configuration__c') {
						clonedConfigurationIds.add(clonedRecordId);
					}
				}

				// TODO Update operation is needed if there are lookups to the same object (from X to X)
			}
		}
		return clonedConfigurationIds;
	}
    
    @AuraEnabled
	public static void cloneOpportunity(Id opportunityId) {
			List<String> sObjectNames = new List<String>{
				'Opportunity'
			};
			Map<String, List<String>> fields = getFields(sObjectNames);

			Map<String, List<String>> sObjectWhereConditions = new Map<String, List<String>>{
				'Opportunity' => new List<String>{ 'Id = :opportunityId' }
			};

			Map<Id, SObject> oldRecords = new Map<Id, SObject>();
			Map<Id, Id> oldToNewId = new Map<Id, Id>();
			Map<Id, SObject> clonedRecords = new Map<Id, SObject>();
			Map<String, List<SObject>> recordsToClone = new Map<String, List<SObject>>{
				'Opportunity' => new List<SObject>()
			};

			for (String sObjectName : sObjectNames) {
				List<SObject> records = Database.query(
					String.join(
						new List<String>{
							'SELECT',
							String.join(fields.get(sObjectName), ', '),
							'FROM',
							sObjectName,
							'WHERE',
							String.join(sObjectWhereConditions.get(sObjectName), 'AND')
						},
						' '
					)
				);

				//List<String> relationShipFields = sObjectRelationsToUpdate.get(sObjectName);
				List<SObject> clones = recordsToClone.get(sObjectName);
				List<Id> oldIds = new List<Id>();
				for (SObject record : records) {
					SObject clonedRecord = record.clone(false);					
					Id recordId = (Id) record.get('Id');
					oldIds.add(recordId);
					oldRecords.put(recordId, record);
					clones.add(clonedRecord);
					
				}
				insert clones;
                system.debug('New Opp Id--'+ clones.get(0).id );
                /*List<Configuration__c> configList = [SELECT Id, Opportunity__c from Configuration__c
                                                    WHERE Opportunity__c =: opportunityId];
                List<Configuration__c> configListtoUpdate = new List<Configuration__c>();
                if(configList.size() > 0 ){
                    for(Configuration__c con : configList){
                        con.Opportunity__c = 
                    }
                }*/
		}
	}
	
	public class VisualRequestBody {
		public String Algorithm;
		public List<VisualRequestParameter> Parameters;
	}
	public class VisualRequestParameter {
		public String WebId;
		public Integer Count;
	}

	public class ResponseWrapper {
		public String error {public get; public set;}
		public List<ItemWrapper> items {public get; public set;}
	}

	public class ItemWrapper {
		public String origWebId {public get; public set;}
		public List<String> copies {public get; public set;}
	}
}