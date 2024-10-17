/**
 * @description       : NOT IN USE
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 10-08-2024
 * @last modified by  : Henk Reynders
**/
public class OpportunityTriggerHandler extends TriggerHandler {
    private Map<Id, Opportunity> newMap;
    private Map<Id, Opportunity> oldMap;
    private List<Opportunity> newRecords;
    private List<Opportunity> oldRecords;

    public OpportunityTriggerHandler() {
        this.newMap = (Map<Id, Opportunity>) Trigger.newMap;
        this.oldMap = (Map<Id, Opportunity>) Trigger.oldMap;
        this.newRecords = (List<Opportunity>) Trigger.new;
        this.oldRecords = (List<Opportunity>) Trigger.old;
    }

    public override void afterUpdate() {
        //PricingSummaryService.updateContractedSalesPrices(newRecords, oldMap);
    }
}