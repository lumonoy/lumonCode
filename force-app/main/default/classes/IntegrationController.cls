/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 09-17-2024
 * @last modified by  : Henk Reynders
**/
public with sharing class IntegrationController {
	public static String getOrgDomain () {
		String orgDomain = String.valueOf(URL.getOrgDomainUrl());
		System.debug('--- IntegrationController - getOrgDomain: '+orgDomain);
		return orgDomain;
	}
	public static String getEnvironment() {
		String orgDomain;
		Boolean isSandbox;
		String envName;		
		orgDomain = getOrgDomain();
    	isSandbox = [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
		if (isSandbox) {
			//https://lumonoy--lumontest.sandbox.my.salesforce.com
			envName = orgDomain.substringBetween('--', '.sandbox');
			envName = envName.remove('--c');			
		} else {
			// https://lumonoy.my.salesforce.com
			envName = orgDomain.substringBetween('https://', '.my');
		}
		System.debug('--- IntegrationController - getEnvironment envName: '+envName);
		return envName;
	}
	public static String getEnvironmentType() {
		Boolean isSandbox;
		String envName;
		String envType;		
    	envName = getEnvironment();
		isSandbox = [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
		if (isSandbox) {
			if (envName != 'lumontest') {
					envType = 'test';
			} else {
					envType = 'development';
			}
		} else {
			envType = 'production';
		}
		System.debug('--- IntegrationController - getEnvironmentType: '+envType);
		return envType;
	}
    public static Integration_Credentials__mdt getIntegrationCredentials (String integration, String type) {
		List<Integration_Credentials__mdt>  credentials = new List<Integration_Credentials__mdt> ();
		String environment = getEnvironment();
		String domain = getOrgDomain();
		String stage = getEnvironmentType();
		//credentials = [SELECT API_Key__c, Endpoint__c FROM Integration_Credentials__mdt WHERE Integration_Name__c = 'FrendsInstallation' AND Environment_Name__c =: envName];
      
		Integration_Credentials__mdt  credential;
		credentials = [SELECT Id,
							  Domain__c,
							  Stage__c,
                              Integration__c,
                              Environment__c,
                              ApiKey__c, 
                              Endpoint__c 
						FROM Integration_Credentials__mdt 
						WHERE Integration__c =: integration 
						AND Type__c =: type
						AND Domain__c =: domain
						LIMIT 1];
		if ( credentials.size()>0){
			credential = credentials[0];
		}
		System.debug('--- IntegrationController - getIntegrationCredentials: '+credential);
        return credential;
    }
}