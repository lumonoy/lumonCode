/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 08-20-2024
 * @last modified by  : Henk Reynders
**/
public with sharing class FileControllerEventTriggerHandler {
    public static void executeAction(List<FileControllerEvent__e> fileActionEvents) {
        for (FileControllerEvent__e stepfileActionEvent : fileActionEvents) { 
            String fileAction = stepfileActionEvent.FileAction__c;
            String documentId = stepfileActionEvent.FileDocumentId__c;
            String content = stepfileActionEvent.FileContent__c;
            System.debug('--- FileControllerEventTriggerHandler - executeAction: ' + fileAction);
            switch on fileAction {
                when 'upload' {
                    System.debug('--- FileControllerEventTriggerHandler - upload new Vresion for Document: ' + documentId);
                    FileController.uploadNewFileVersion(content,documentId);
                }
            }
        }
    }
}