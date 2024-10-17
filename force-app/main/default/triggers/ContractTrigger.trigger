/**
 * @description       : NOT USED Related to Sales Process
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 10-08-2024
 * @last modified by  : Henk Reynders
**/
trigger ContractTrigger on Contract (before insert, before update, after insert, after update) {
	if (Trigger.isBefore) {
		if (Trigger.isInsert) {

		}
	} else if (Trigger.isAfter) {
		if (Trigger.isInsert) {
			//ContractTriggerHandler.populateJSON(Trigger.new, null, true);
		} else if (Trigger.isUpdate) {
			//ContractTriggerHandler.populateJSON(Trigger.new, Trigger.oldMap, true);
		}
	}
}