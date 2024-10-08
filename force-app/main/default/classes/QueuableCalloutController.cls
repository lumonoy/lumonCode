/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 08-20-2024
 * @last modified by  : Henk Reynders
**/
public with sharing class QueuableCalloutController implements Queueable, Database.AllowsCallouts {
    // This allows us to cause a DML failure in execute batch, enabling testing.
    @testVisible
    private static Boolean throwError = false;
    @testVisible
    private static Boolean circuitBreakerThrown = false;
    public final List<Id> recordIds;
    
    public QueuableCalloutController(List<Id> recordIds){
            this.recordIds = recordIds;
    }
    public void execute(QueueableContext context) {
        // This method will make a REST API call
        InstallationDocumentController.getRemoteContent(recordIds);
    }
    public void finish(QueueableContext context) {
        // This method will make a DML
        //InstallationDocumentController.getRemoteContent(recordIds);
    }
    public class QueueableCalloutException extends Exception {
    }
}