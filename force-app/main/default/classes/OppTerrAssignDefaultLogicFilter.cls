/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-02-2023
 * @last modified by  : Henk Reynders
**/
global class OppTerrAssignDefaultLogicFilter implements TerritoryMgmt.OpportunityTerritory2AssignmentFilter { 
    /*** Apex version of the default logic.
    * If opportunity's assigned account is assigned to
    *  Case 1: 0 territories in active model
    *            then set territory2Id = null
    *  Case 2: 1 territory in active model
    *            then set territory2Id = account's territory2Id
    *  Case 3: 2 or more territories in active model
    *            then set territory2Id = account's territory2Id that is of highest priority.
    *            But if multiple territories have same highest priority, then set territory2Id = null 
    */
    /**
     * No-arg constructor.
     */ 
     global OppTerrAssignDefaultLogicFilter() {}

     /**
      * Get mapping of opportunity to territory2Id. The incoming list of opportunityIds contains only those with IsExcludedFromTerritory2Filter=false.
      * If territory2Id = null in result map, clear the opportunity.territory2Id if set.
      * If opportunity is not present in result map, its territory2Id remains intact.
      */
    global Map<Id,Id> getOpportunityTerritory2Assignments(List<Id> opportunityIds) { 
        Map<Id, Id> OppIdTerritoryIdResult = new Map<Id, Id>();
        // Get the active territory model Id
        Id activeModelId = getActiveModelId();
		// If Active Territory Model then get Opportunities
        if(activeModelId != null){
            List<Opportunity> opportunities =
              [Select Id, Name,AccountId,Account.Name, Territory2Id from Opportunity where Id IN :opportunityIds];
            System.debug('OppTerrAssignDefaultLogicFilter - '+opportunities.size()+' Opportunities');
            Set<Id> accountIds = new Set<Id>();
            // Create set of parent accountIds
            // For Each Opportunity check if there is an Account and then Assign it to accountIds Collection
            for(Opportunity opp:opportunities){
                if(opp.AccountId != null){
                    accountIds.add(opp.AccountId);
                    System.debug('OppTerrAssignDefaultLogicFilter - adding Account '+opp.Account.Name);
                }
            }
            // For Get the Max Account Priority for Relevant (Opportunity) Accounts
            Map<Id,Territory2Priority> accountMaxPriorityTerritory = getAccountMaxPriorityTerritory(activeModelId, accountIds);
            // For each opportunity, assign the highest priority territory if there is no conflict, else assign null.
            for(Opportunity opp: opportunities){
                if(opp.AccountId != null){
            	    Territory2Priority tp = accountMaxPriorityTerritory.get(opp.AccountId);
                    // Assign highest priority territory if there is only 1.
                    if((tp != null) && (tp.moreTerritoriesAtPriority == false)){ // REMOVE This BIT && (tp.territory2Id != opp.Territory2Id)){
                        System.debug('OppTerrAssignDefaultLogicFilter - Opportunity: '+opp.Name+' related Territory Priority '+tp) ; 
                        OppIdTerritoryIdResult.put(opp.Id, tp.territory2Id);
                        
                    }else{
                        System.debug('OppTerrAssignDefaultLogicFilter - Opportunity: '+opp.Name+' related Territory Priority '+tp) ;
                        OppIdTerritoryIdResult.put(opp.Id, null);
                    }
                }
            }
            
        }
        System.debug('OppTerrAssignDefaultLogicFilter - Get Opportunity Territory Assignments: '+OppIdTerritoryIdResult.size());
        return OppIdTerritoryIdResult;
    }
    
    
    
    /**
      * Query assigned territoryIds in active model for given accountIds.
      * Create a map of accountId to max priority territory.
      */
     private Map<Id,Territory2Priority> getAccountMaxPriorityTerritory(Id activeModelId, Set<Id> accountIds){
        Map<Id,Territory2Priority> accountMaxPriorityTerritory = new Map<Id,Territory2Priority>();
        // For Each Territory Associated with Opportunity Account get the Priority via TerritoryType
        List<ObjectTerritory2Association> associatedTerritories = new List<ObjectTerritory2Association>();
         if(!Test.isRunningTest()){
             associatedTerritories = [SELECT 	ObjectId, 
                                      Territory2.Territory2ModelId,
                                      Territory2Id,Territory2.Name, 
                                      Territory2.Territory2Type.DeveloperName, 
                                      Territory2.Territory2Type.Priority,
                                      AssociationCause 
                                      FROM ObjectTerritory2Association 
                                      WHERE objectId IN :accountIds 
                                      AND Territory2.Territory2ModelId = :activeModelId
                                      AND AssociationCause = 'Territory2AssignmentRule'];
         }else{
             associatedTerritories = [SELECT 	ObjectId, 
                                      Territory2.Territory2ModelId,
                                      Territory2Id,Territory2.Name, 
                                      Territory2.Territory2Type.DeveloperName, 
                                      Territory2.Territory2Type.Priority
                                      FROM ObjectTerritory2Association 
                                      WHERE objectId IN :accountIds 
                                      AND Territory2.Territory2ModelId = :activeModelId];
         }
        
        System.debug('OppTerrAssignDefaultLogicFilter - Associated Territories: '+associatedTerritories.size());
        for(ObjectTerritory2Association associatedTerritory:associatedTerritories){
            String accountId = '';
            String territoryId = associatedTerritory.Territory2Id;
            String territoryName = associatedTerritory.Territory2.Name;
            String territoryType = associatedTerritory.Territory2.Territory2Type.DeveloperName;
                
            Integer territoryPriority = associatedTerritory.Territory2.Territory2Type.Priority;
            if(associatedTerritory.ObjectId != NULL){
                accountId = associatedTerritory.ObjectId;
            }
            
            
            Territory2Priority tpWrapper = accountMaxPriorityTerritory.get(accountId);
			System.debug('OppTerrAssignDefaultLogicFilter - Territory Priority : '+territoryPriority+' for '+territoryName +' of Type '+territoryType) ;
            
            if((tpWrapper == null) || (territoryPriority > tpWrapper.priority)){
                // If this is the first territory examined for account or it has greater priority than current highest priority territory, then set this as new highest priority territory.
                tpWrapper = new Territory2Priority(territoryId,territoryPriority,false);
                
            }else if(territoryPriority == tpWrapper.priority){
                // Two Territories with Same Highest Priority
                tpWrapper.moreTerritoriesAtPriority = true;
            }
            accountMaxPriorityTerritory.put(associatedTerritory.ObjectId, tpWrapper);
            System.debug('*** accountMaxPriorityTerritory ***'+accountMaxPriorityTerritory);
        }
        System.debug('OppTerrAssignDefaultLogicFilter - Get Account Max Priority Territory: '+accountMaxPriorityTerritory.size());
        return accountMaxPriorityTerritory;
    }

    /**
     * Get the Id of the Active Territory Model.
     * If none exists, return null.
     */
    private Id getActiveModelId() {
        List<Territory2Model> models = [Select Id from Territory2Model where State = 'Active'];
        Id activeModelId = null;
        if(models.size() == 1){
            activeModelId = models.get(0).Id;
        }
        System.debug('OppTerrAssignDefaultLogicFilter - Get Active Model: '+activeModelId);
        return activeModelId;
    }

    /**
    * Helper class to help capture territory2Id, its priority, and whether there are more territories with same priority assigned to the account.
    */
    private class Territory2Priority {
        public Id territory2Id { get; set; } // Boolean to indicate if more that one Territory has same Priority
        public Integer priority { get; set; } // Boolean to indicate if more that one Territory has same Priority
        public Boolean moreTerritoriesAtPriority { get; set; } // Boolean to indicate if more that one Territory has same Priority

        Territory2Priority(Id territory2Id, Integer priority, Boolean moreTerritoriesAtPriority){
            this.territory2Id = territory2Id;
            this.priority = priority;
            this.moreTerritoriesAtPriority = moreTerritoriesAtPriority;
        }
    }
}