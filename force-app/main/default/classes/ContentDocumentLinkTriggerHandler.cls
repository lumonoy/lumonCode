public class ContentDocumentLinkTriggerHandler {

	public static void beforeInsert(List<ContentDocumentLink> cdlNewList){
		updateOppSignedContractShareType(cdlNewList);
	}

	private static void updateOppSignedContractShareType(List<ContentDocumentLink> cdlNewList){
		Set<Id> fileIdsToCheck = new Set<Id>();
		for(ContentDocumentLink cdLink : cdlNewList){
			if(String.valueOf(cdLink.LinkedEntityId).startsWith('006')){
				fileIdsToCheck.add(cdLink.ContentDocumentId);
			}
		}
		Map<Id, ContentDocument> contentDocumentsMap;
		if(!fileIdsToCheck.isEmpty()){
			contentDocumentsMap = new Map<Id, ContentDocument>([
				SELECT
					Id,
					FileExtension,
					Title
				FROM ContentDocument
				WHERE Id IN :fileIdsToCheck
				AND Title LIKE '%signed%'
				AND FileExtension = 'pdf'
				LIMIT 100
			]);
		}
		if(contentDocumentsMap != null && !contentDocumentsMap.isEmpty()){
			List<ContentDistribution> cDistributions = new List<ContentDistribution>();
			List<ContentVersion> cVersions = [
				SELECT
					Id,
					ContentDocument.Title
				FROM ContentVersion
				WHERE ContentDocumentId IN :contentDocumentsMap.keySet()
				LIMIT 500
			];
			if(!cVersions.isEmpty()){
				for(ContentVersion cV : cVersions){
					ContentDistribution conDis = new ContentDistribution();
					conDis.Name = cV?.ContentDocument?.Title;
					conDis.ContentVersionId = cV?.Id;
					conDis.PreferencesAllowViewInBrowser = true;
					cDistributions.add(conDis);
				}
			}
			for(ContentDocumentLink cdLink : cdlNewList){
				if(contentDocumentsMap.containsKey(cdLink?.ContentDocumentId) && String.valueOf(cdLink?.LinkedEntityId).startsWith('006')){
					cdLink.ShareType = 'V';
					cdLink.Visibility = 'AllUsers';
				}
			}
			if(!cDistributions.isEmpty()){
				insert cDistributions;
			}
		}
	}
}