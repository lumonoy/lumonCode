/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-02-2023
 * @last modified by  : Henk Reynders
**/
public without sharing class WorkOrderLineItemTriggerHandler {
	public static void populateJSON(List<WorkOrderLineItem> newWorkOrderLineItems, Map<Id, WorkOrderLineItem> oldWorkOrderLineItems, Boolean resubmitOrder) { //Added resubmitOrder as part of LUM-1282
		List<WorkOrderLineItem> itemsToProcess = new List<WorkOrderLineItem>();
		Set<Id> installExpenseIds = new Set<Id>();
		Set<Id> installerIds = new Set<Id>();
        
        Boolean isSandbox = [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
		System.debug('--- isSandbox ---'+isSandbox);
		String envName = 'production';
		if ([SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox) {
			envName = String.valueOf(URL.getOrgDomainUrl()).substringBetween('--', '.sandbox');
			envName = envName.remove('--c');
			if (envName != 'lumonTest' && envName != 'develop1' ) {
				envName = 'sandbox';
			}
		}
		Integration_Credentials__mdt credentials;
		credentials = [SELECT API_Key__c, Endpoint__c FROM Integration_Credentials__mdt WHERE Integration_Name__c = 'FrendsInstallation' AND Environment_Name__c =: envName];
        
		//Added resubmitOrder as part of LUM-1282
        for (WorkOrderLineItem worOrdLinItem : newWorkOrderLineItems) {
			WorkOrderLineItem oldItem = oldWorkOrderLineItems.containsKey(worOrdLinItem.Id) ? oldWorkOrderLineItems.get(worOrdLinItem.Id): new WorkOrderLineItem();
			
            if ((worOrdLinItem.Status == 'Completed'&& oldItem.Status != 'Completed' && 
                 worOrdLinItem.RVN_Number__c != null ) || resubmitOrder) 
            {
                 itemsToProcess.add(worOrdLinItem);
				 installExpenseIds.add(worOrdLinItem.Install_Expense__c);
                 if (worOrdLinItem.LastModifiedById != null) 
                 {
                    installerIds.add(worOrdLinItem.LastModifiedById);
                 }
			}
		}
        
		Map<Id,Install_Expense__c> installExpenseMap = new  Map<Id,Install_Expense__c>( [SELECT Id,Hourly_Expense__c from Install_Expense__c where Id IN : installExpenseIds]);
		Map<Id, User> userIdToUser = new Map<Id, User>([SELECT Username FROM User WHERE Id IN :installerIds]);
        Decimal installExpense = 0.00;
		
        for (WorkOrderLineItem item : itemsToProcess) {
			SalesLineWrapper wrapper = new SalesLineWrapper();
			SalesLineDef sLineDef = new SalesLineDef();
			sLineDef.Installed = 'Yes';
            sLineDef.company = 'LSU'; // This is hardcoded but this should be taken from Installer Organization Attribute
			sLineDef.TVN = item.RVN_Number__c;

			UpdateDef upd = new UpdateDef();
			upd.InstallerName = item.LastModifiedById != null ? userIdToUser.get(item.LastModifiedById).Username : '';
			upd.InstallDate = item.StartDate != null ? String.valueOf(item.StartDate).substring(0,10) : '';
            //LUM-1483 Install Expense calculation
            if(installExpenseMap.get(item.Install_Expense__c).Hourly_Expense__c != NULL && item.Duration != NULL){
                installExpense = installExpenseMap.get(item.Install_Expense__c).Hourly_Expense__c * item.Duration;
                installExpense = installExpense.setScale(2);
            }
            upd.InstallExpense = installExpense != null ?  String.valueOf(installExpense) : '';
			upd.DeliveryDateRealised = item.EndDate != null ? String.valueOf(item.EndDate).substring(0,10) : '';

			sLineDef.Update1 = upd;
			wrapper.SalesLine = sLineDef;
			String jsonBody = JSON.serialize(wrapper);
			jsonBody = jsonBody.replace('Update1', 'Update');
			System.debug('!! json: ' + jsonBody);
			notifyFrends(jsonBody, credentials.Endpoint__c, credentials.API_Key__c);
		}
	}

	@future (callout=true)
	public static void notifyFrends (String jsonBody, String endpoint, String apiKey) {
		Http http = new Http();
		HttpRequest request = new HttpRequest();
		request.setEndpoint(endpoint);
		request.setMethod('POST');
		request.setHeader('Content-Type', 'application/json;charset=UTF-8');
		request.setHeader('Authorization', apiKey);
		request.setBody(jsonBody);
		HttpResponse response = http.send(request);

		System.debug('STATUS: ' + response.getStatus());

		if (response.getStatusCode() != 200) {
			System.debug('ERROR: ' + response.getBody());
		} else {
			System.debug('SUCCESS: ' + response.getBody());
		}
	}

	public class SalesLineWrapper {
		public SalesLineDef SalesLine {public get; public set;}
	}

	public class SalesLineDef {
		public String Installed {public get; public set;}
		public String TVN {public get; public set;}
        public String company {public get; public set;}
		public UpdateDef Update1 {public get; public set;}
	}

	public class UpdateDef {
		public String InstallerName {public get; public set;}
		public String InstallExpense {public get; public set;}
		public String DeliveryDateRealised {public get; public set;}
		public String InstallDate {public get; public set;}
	}
}