public with sharing class LP_ManagedContent {
	@AuraEnabled
	public static Map<String, ConnectApi.ManagedContentNodeValue> getContent(String contentId, Integer page,
			Integer pageSize, String language, String filterBy)
	{
		try {
			String networkId = Network.getNetworkId();
			ConnectApi.ManagedContentVersionCollection contentCollection = ConnectApi.ManagedContent.getManagedContentByContentKeys(
				networkId,
				new List<String>{ contentId },
				page,
				pageSize,
				language,
				filterBy,
				false
			);
			return contentCollection.items[0].contentNodes;
		} catch (ConnectApi.ConnectApiException e) {
			System.debug('Get Managed Content Error Message : ' + e);
			Map<String, ConnectApi.ManagedContentNodeValue> mcNodeValue = new Map<String, ConnectApi.ManagedContentNodeValue>();
			return mcNodeValue;
		}
	}
}