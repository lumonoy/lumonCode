/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-03-2023
 * @last modified by  : Henk Reynders
**/
public without sharing class VisualConfigurationController {
	@InvocableMethod(callout=true label='Clone Configuration')
	public static List<String> cloneConfiguration(List<String> webId) {
		String sourceOppId = webId != null ? webId[0] : '';
		List<String> message  = cloneConfigurationResusable(sourceOppId);
		return message;
	}	
	public static List<String> cloneConfigurationResusable(String webId) {	
		if (webId != '' && webId !=  null) {
			Opportunity opp = [SELECT Order_type__c FROM Opportunity WHERE Id =: webId LIMIT 1];
			if (opp != null && opp.Order_type__c == 'Reclamation') {
				List<Configuration__c> plans = [SELECT Visual_Id__c FROM Configuration__c WHERE Opportunity__c =: webId];
				if (plans != null) {
					String visualId = plans[0].Visual_Id__c;
					String configId = plans[0].Id;

					if (!String.isBlank(visualId)) {
						String envName = 'production';
						if ([SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox) {
							envName = String.valueOf(URL.getSalesforceBaseUrl()).substringBetween('--', '.sandbox');
						}
						Integration_Credentials__mdt credentials = [SELECT API_Key__c, Endpoint__c FROM Integration_Credentials__mdt WHERE Integration_Name__c = 'CloneConfig' AND Environment_Name__c =: envName];

						String secretKey = credentials.API_Key__c;//'62AAD32D3D9AE71C520F113843B1F7902F5174361E82911213811AAC1D0A5138';
						String requestBody = '{"Algorithm":"HMACSHA256","Parameters":[{"WebId":"' + visualId + '","Count":1}]}';
						String encodedBody = EncodingUtil.base64Encode(Blob.valueOf(requestBody));
						String signedRequest = EncodingUtil.base64Encode(Crypto.generateMac('hmacSHA256', Blob.valueOf(encodedBody), Blob.valueOf(secretKey)));
//						System.debug('signedRequest: ' + signedRequest + ', body: ' + encodedBody);

						Http http = new Http();
						String endpoint = credentials.Endpoint__c;
						HttpRequest request = new HttpRequest();
						request.setEndpoint(endpoint);
						request.setMethod('POST');
						request.setTimeout(120000);
						request.setHeader('Content-Type', 'application/json;charset=UTF-8');
						String body = signedRequest + '.' + encodedBody;
						request.setBody(body);
						System.debug('!!! Request body: ' + body);
						HttpResponse response = http.send(request);

						String copyVal = '';
						if (response.getStatusCode() != 200) {
							System.debug('ERROR: ' + response.getBody());
						} else {
							ResponseWrapper resp = (ResponseWrapper) JSON.deserialize(response.getBody(),ResponseWrapper.class);
							if (resp.error == null && resp.items != null) {
								copyVal = resp.items[0].copies != null ? resp.items[0].copies[0] : '';
							} else {
								System.debug('ERROR from callout: ' + resp.error);
							}
						}

						System.debug('!! returned val: ' + copyVal);
						try {
							update new Configuration__c(Id = configId, Visual_Id__c = copyVal);
						} catch (DmlException ex) {
							System.debug('!!! EXCEPTION: ' + ex.getDmlMessage(0));
						}
					}
				}
			}
		}
		return new List<String>{'success'};

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
			envName = String.valueOf(URL.getSalesforceBaseUrl()).substringBetween('--', '.sandbox');
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
                    system.debug('item--'+item);
					Configuration__c configurationPlan = configurationPlansToUpdate.get(i);
                    system.debug('configurationPlan.Visual_Id__c--'+configurationPlan.Visual_Id__c);
					configurationPlan.Visual_Id__c = !item.copies.isEmpty() ? item.copies.get(0) : '';
                    system.debug('configurationPlan.Visual_Id__c-----'+configurationPlan.Visual_Id__c);
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
	public static void cloneConfigurationPlan(Id opportunityId,List<Id> configurationIdList) {
        for(Id configurationId : configurationIdList){
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
                        
                       Map<String, List<String>> sObjectWhereConditions = new Map<String, List<String>>{
                            'Configuration__c' => new List<String>{ 'Id = :configurationId' },
                                'Configuration_Product__c' => new List<String>{ 'Configuration__r.Id = :configurationId' },
                                    'Configuration_Option__c' => new List<String>{
                                        'Configuration_Product__r.Configuration__r.Id = :configurationId'
                                            },
                                                'Pricing_Summary__c' => new List<String>{ 'Opportunity__c = :opportunityId' },
                                                    'QuoteLineItem' => new List<String>{ 'Configuration_Plan__c = :configurationId' }
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
                                system.debug('records--'+records);
                                List<String> relationShipFields = sObjectRelationsToUpdate.get(sObjectName);
                                List<SObject> clones = recordsToClone.get(sObjectName);
                                List<Id> oldIds = new List<Id>();
                                for (SObject record : records) {
                                    SObject clonedRecord = record.clone(false);
                                    if(sObjectName == 'Configuration__c') {
                                        clonedRecord.put('Visual_Id__c', ((String)clonedRecord.get('Visual_Id__c')));
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
                                system.debug('clones--'+clones);
                                insert clones;
                                
                                for(Integer i = 0; i < clones.size(); i++) {
                                    Id oldId = oldIds.get(i);
                                    SObject clonedRecord = clones.get(i);
                                    Id clonedRecordId = (Id) clonedRecord.get('Id');
                                    oldToNewId.put(oldId, clonedRecordId);
                                }
                                
                                // TODO Update operation is needed if there are lookups to the same object (from X to X)
                            }
            
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