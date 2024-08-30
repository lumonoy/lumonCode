/**
 * Created by Filip on 1. 8. 2023.
 */

trigger ContentDocumentLinkTrigger on ContentDocumentLink (before insert) {
    if (Trigger.isBefore) {
        ContentDocumentLinkTriggerHandler.beforeInsert(Trigger.new);
    }
}