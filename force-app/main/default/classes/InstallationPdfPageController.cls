/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 10-01-2024
 * @last modified by  : Henk Reynders
**/
public without sharing class InstallationPdfPageController {

    public List<Content> contents { get; private set; }

    public class Content {
        public String contentTitle { get; private set; }
        public String contentBody { get; private set; }
        public Content(String contentTitle, String contentBody) {
            this.contentTitle = contentTitle;
            this.contentBody = contentBody;
        }
    }

    public InstallationPdfPageController(){
        contents = new List<Content>();
        Id opportunityId;
        String spRecordId = ApexPages.currentPage().getParameters().get('service-appointment-id');
        String workOrderId = ApexPages.currentPage().getParameters().get('workorder-id');
        if (workOrderId != null) {
            opportunityId = [
                    SELECT Id, Opportunity__c
                    FROM WorkOrder
                    WHERE Id = :workOrderId
            ].Opportunity__c;

        } else if (spRecordId != null) {
            opportunityId = [
                    SELECT Id, LUM_Parent_Work_Order__r.Opportunity__c
                    FROM ServiceAppointment
                    WHERE Id = :spRecordId
            ].LUM_Parent_Work_Order__r.Opportunity__c;
        }

        /*if (opportunityId == null) {
            Log.get().publish('Unable to find opportunity for record id ' + workOrderId + ', or ' + spRecordId +
                    'unable to create installer instruction pdf',
                    new LogDetail(InstallerPDFController.class.toString()));
        }*/
        List<Configuration_Product__c> configurationProducts = [
                SELECT Id, RVN_Number__c, Product__r.Name, Installer_Message__c
                FROM Configuration_Product__c
                WHERE Configuration__r.Opportunity__c = :opportunityId
        ];
        for (Configuration_Product__c configurationProduct : configurationProducts) {
            if (configurationProduct.Installer_Message__c == null) {
                continue;
            }
            this.contents.add(new Content('<h3><b>' + configurationProduct.RVN_Number__c + ' - ' + configurationProduct.Product__r.Name + '</b></h3>',
                    '<p>' + configurationProduct.Installer_Message__c));
        }
    }
}