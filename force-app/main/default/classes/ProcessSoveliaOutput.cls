/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-03-2023
 * @last modified by  : Henk Reynders
**/

@RestResource(urlMapping='/soveliaOutput/*')
global without sharing class ProcessSoveliaOutput {
	@HttpPost
	global static void doPost() {
		String result = '';
		RestRequest request = RestContext.request;
		String allParams = request.requestURI.substringAfter('/soveliaOutput/');
		Integer indexOfSlash = allParams.indexOf('/');
		String recordId = allParams.substring(0, indexOfSlash);
		String recIdAndSlash = recordId + '/';
		String fileName = allParams.substringBetween(recIdAndSlash, '/');

		List<Opportunity> opps = [SELECT Id FROM Opportunity WHERE Id =: recordId];
		if (!opps.isEmpty()) {
			String rvn = '';
			String fileNameToSave = '';
			if (fileName == 'report') {
				fileNameToSave = 'Report';
				BlindsReportWrapper reportWrapper = (BlindsReportWrapper) JSON.deserialize(EncodingUtil.base64Decode(request.requestBody.toString()).toString(), BlindsReportWrapper.class);
				if (reportWrapper != null && reportWrapper.RVN != null) {
					rvn = reportWrapper.RVN;
				}
			} else if (fileName == 'pricing') {
				fileNameToSave = 'Pricing';
				BlindsWrapper wrapper = (BlindsWrapper) JSON.deserialize(EncodingUtil.base64Decode(request.requestBody.toString()).toString(), BlindsWrapper.class);
				if (wrapper != null && wrapper.products != null && wrapper.products[0].rvn != null) {
					rvn = wrapper.products[0].rvn;
				}
			}

			if (!String.isBlank(rvn)) {
				ContentVersion contVerFile = new ContentVersion();
				contVerFile.VersionData = EncodingUtil.base64Decode(request.requestBody.toString());
				contVerFile.Title = 'Blinds_' + fileNameToSave + '_' + rvn.substring(8);
				contVerFile.ContentLocation = 's';
				contVerFile.PathOnClient = contVerFile.Title + '.json';

				List<Configuration_Product__c> prods = [
                    SELECT Configuration__c, Opportunity__c, RVN__c
                    FROM Configuration_Product__c WHERE RVN__c = :rvn AND Configuration__r.Opportunity__c = :recordId
                ];
				if (prods.size() > 0 && prods[0].Configuration__c != null) {
					String relatedConfigId = prods[0].Configuration__c;

					try {
						List<ContentDocumentLink> existingContentDocuments = [
							SELECT ContentDocumentId FROM ContentDocumentLink
							WHERE LinkedEntityId = :relatedConfigId
							AND ContentDocument.LatestPublishedVersion.PathOnClient = :contVerFile.PathOnClient
						];
						if(!existingContentDocuments.isEmpty()) {
							contVerFile.ContentDocumentId = existingContentDocuments.get(0).ContentDocumentId;
						} else {
							contVerFile.FirstPublishLocationId = relatedConfigId;
						}

						insert contVerFile;

						ContentVersion contDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =: contVerFile.Id AND IsLatest = TRUE];
						Integer linkedDocs = [SELECT count() FROM ContentDocumentLink WHERE ContentDocumentId =: contDoc.ContentDocumentId AND LinkedEntityId =: relatedConfigId];
						if (linkedDocs == 0) {
							insert new ContentDocumentLink(ContentDocumentId = contDoc.ContentDocumentId, ShareType = 'V', LinkedEntityId = relatedConfigId);
						}

						update new Configuration__c(Id = relatedConfigId, Status__c = 'Configured');
						result = '{"status" : "success"}';
						RestContext.response.addHeader('Content-Type','application/json');
						RestContext.response.responseBody = Blob.valueOf(result);
                        
                        if(fileNameToSave == 'Pricing') {
                            publishConfigurationEvent(prods.get(0), contVerFile.VersionData.toString());
                        }
					} catch (DmlException ex) {
						result = '{"status" : "error", "message" : ' + ex.getDmlMessage(0) + '}';
						RestContext.response.addHeader('Content-Type','application/json');
						RestContext.response.responseBody = Blob.valueOf(result);
					}
				} else {
					result = '{"status" : "error", "message" : "Configuration not found!"}';
					RestContext.response.addHeader('Content-Type','application/json');
					RestContext.response.responseBody = Blob.valueOf(result);
				}
			} else {
				result = '{"status" : "error", "message" : "JSON file does not contain RVN attribute"}';
				RestContext.response.addHeader('Content-Type','application/json');
				RestContext.response.responseBody = Blob.valueOf(result);
			}
		} else {
			result = '{"status" : "error", "message" : "No opportunity found with given ID."}';
			RestContext.response.addHeader('Content-Type','application/json');
			RestContext.response.responseBody = Blob.valueOf(result);
		}
	}

    private static void publishConfigurationEvent(Configuration_Product__c configurationProduct, String blindsJSON) {
        ConfigurationEvent.publishConfigurationEvent(
            'Blinds',
            'Configure',
            configurationProduct.Configuration__c,
            configurationProduct.Opportunity__c,
            'Opportunity',
            configurationProduct.RVN__c,
            null,
            blindsJSON
        );
    }

	public class BlindsWrapper {
		public String id;
		public String name;
		public List<ProductWrapper> products;
	}

	public class ProductWrapper {
		public String id;
		public String name;
		public String rvn;
	}

	public class BlindsReportWrapper {
		public String RVN;
	}
}