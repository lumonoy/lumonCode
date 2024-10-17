/**
 * @description       : NOT USED related to Customer Portal
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 10-08-2024
 * @last modified by  : Henk Reynders
**/
trigger ContentDocumentLinkTrigger on ContentDocumentLink (before insert) {
    if (Trigger.isBefore) {
        //ContentDocumentLinkTriggerHandler.beforeInsert(Trigger.new);
    }
}