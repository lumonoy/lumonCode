/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 09-17-2024
 * @last modified by  : Henk Reynders
**/
@IsTest
private class IntegrationControllerTest {
	@IsTest static void getOrgDomainTest() {
        String orgDomain = IntegrationController.getOrgDomain();
        System.assertNotEquals(null, orgDomain, 'Expected to return a String');
    }
    @IsTest static void getEnvironmentTest() {
        String env = IntegrationController.getEnvironment();
        System.assertNotEquals(null, env, 'Expected to return a String');
    }
    @IsTest static void getEnvironmentTypeTest() {
        String envType = IntegrationController.getEnvironmentType();
        System.assertNotEquals(null, envType, 'Expected to return a String');
    }
    
    @IsTest static void getCredentialsApiTest() {
        String integration = 'frends';
        String type = 'api';
        Integration_Credentials__mdt cred = IntegrationController.getIntegrationCredentials(integration,type);
        System.assertNotEquals(null, cred.DeveloperName, 'Expected to return a String');
    }
    @IsTest static void getCredentialsOrderTest() {
        String integration = 'frends';
        String type = 'orders';
        Integration_Credentials__mdt cred = IntegrationController.getIntegrationCredentials(integration,type);
        System.assertNotEquals(null, cred.DeveloperName, 'Expected to return a String');
    }
    @IsTest static void getCredentialsFilesTest() {
        String integration = 'frends';
        String type = 'files';
        Integration_Credentials__mdt cred = IntegrationController.getIntegrationCredentials(integration,type);
        System.assertNotEquals(null, cred.DeveloperName, 'Expected to return a String');
    }
    @IsTest static void getCredentialsContractTest() {
        String integration = 'frends';
        String type = 'contract';
        Integration_Credentials__mdt cred = IntegrationController.getIntegrationCredentials(integration,type);
        System.assertNotEquals(null, cred.DeveloperName, 'Expected to return a String');
    }
    @IsTest static void getCredentialsMepcoTest() {
        String integration = 'frends';
        String type = 'mepco';
        Integration_Credentials__mdt cred = IntegrationController.getIntegrationCredentials(integration,type);
        System.assertNotEquals(null, cred.DeveloperName, 'Expected to return a String');
    }
    @IsTest static void getCredentialsVisualTest() {
        String integration = 'visual';
        String type = 'clone';
        Integration_Credentials__mdt cred = IntegrationController.getIntegrationCredentials(integration,type);
        System.assertNotEquals(null, cred.DeveloperName, 'Expected to return a String');
    }
}