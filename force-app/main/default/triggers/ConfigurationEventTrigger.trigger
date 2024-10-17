/**
 * @description       : Trigger to initate Actions related to CPQ 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 10-08-2024
 * @last modified by  : Henk Reynders
**/

trigger ConfigurationEventTrigger on ConfigurationEvent__e (after insert) {
    //System.debug('Configuration Event after Insert: ' + Trigger.new);
    //ConfigurationEventTriggerHandler.processConfiguration(Trigger.new);
}