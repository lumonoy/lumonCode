/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 07-06-2024
 * @last modified by  : Henk Reynders
**/
trigger ProcessStepTrigger on ProcessStepEvent__e (after insert) {
    System.debug('--- ProcessStepTrigger - Event after Insert: ' + Trigger.new);
    ProcessStepTriggerHandler.initiateProcessStep(Trigger.new);
}