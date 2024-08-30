/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 03-26-2024
 * @last modified by  : Henk Reynders
**/
public with sharing class LeadConverter {
    @InvocableMethod (label='Automatically Convert Leads')
    public static List<List<String>> convertLeads(List<Id> leadIds) {
    //public static List<String> convertLeads(List<Id> leadIds) {
        List<String> toReturn = new List<String>();
        List<List<string>> colToReturn = new List<List<String>>();
        List<Lead> leadsToConvert = [SELECT Id FROM Lead WHERE Id =: leadIds];
        LeadStatus leadConvertedStatus = [SELECT ApiName FROM LeadStatus WHERE IsConverted = TRUE LIMIT 1];
        List<Database.LeadConvert> dbLeads = new List<Database.LeadConvert>();
        List<Database.LeadConvert> dbDuplicates = new List<Database.LeadConvert>();

        if (String.isNotBlank(leadConvertedStatus?.ApiName)) {
            String convertedStatus = leadConvertedStatus.ApiName;        
            for (Lead currentLead: leadsToConvert){
                Id currentLeadId = currentLead.Id;
                // Check first for Possible Duplicates
                List<Lead> duplicateLeads = findDuplicateRecordsForLead(currentLead);
                if(duplicateLeads.size() == 0){
                    System.debug('--- LeadConverter - No Duplicates Found!');
                    Database.LeadConvert dbLead = new Database.LeadConvert();
                    dbLead.setLeadId(currentLeadId);
                    dbLead.setConvertedStatus(convertedStatus);
                    //leadConvert.setDoNotCreateOpportunity(true);
                    dbLeads.add(dbLead);
                } else {
                    System.debug('--- LeadConverter - '+duplicateLeads.size()+' Possible Duplicates Found!');
                    Database.LeadConvert dbDuplicate = new Database.LeadConvert();
                    dbDuplicate.setLeadId(currentLeadId);
                    dbDuplicate.setConvertedStatus(convertedStatus);
                    //leadConvert.setDoNotCreateOpportunity(true);
                    dbDuplicates.add(dbDuplicate);         
                } 
            }

            if (!dbLeads.isEmpty()) {
                List<Database.LeadConvertResult> lcr = Database.convertLead(dbLeads);
                for (Database.LeadConvertResult l : lcr) {
                    toReturn.add(l.getAccountId() + ';' + l.getOpportunityId());
                    colToReturn.add(toReturn);
                }
            }
            if (!dbDuplicates.isEmpty()) {
                Database.DMLOptions dml = new Database.DMLOptions();
                dml.DuplicateRuleHeader.AllowSave = true;
                List<Database.LeadConvertResult> lcr = Database.convertLead(dbDuplicates,dml);
                for (Database.LeadConvertResult l : lcr) {
                    toReturn.add(l.getAccountId() + ';' + l.getOpportunityId());
                    colToReturn.add(toReturn);
                }
            }
        }
        //return toReturn;
        return colToReturn;
    }
    public static List<Lead> findDuplicateRecordsForLead(Lead leadToConvert){ 
        List<Lead> leadsToConvert = new List<Lead>{leadToConvert};
        List<Datacloud.FindDuplicatesResult>  findDuplicatesResults = Datacloud.FindDuplicates.findDuplicates(leadsToConvert); 
        List<Lead> leadsWithDuplicates = new List<Lead>();
        if (findDuplicatesResults?.size()>0) {
            System.debug('--- LeadConverter - '+findDuplicatesResults.size()+' Possible Duplicates Found!');
            for (Integer i=0; i<findDuplicatesResults.size(); i++) {
            //for (Datacloud.DuplicateResult duplicateResult :  findDuplicatesResults) { 
                Datacloud.FindDuplicatesResult findDuplicateResult = findDuplicatesResults.get(i);    
                for (Integer j=0; j<findDuplicateResult.getDuplicateResults().size();j++) {
                    Datacloud.DuplicateResult duplicateResult = findDuplicatesResults.get(i).getDuplicateResults().get(j);
                    System.debug('--- LeadConverter - Duplicate Result: ' + duplicateResult);
                    List<Datacloud.MatchResult> matchResults = duplicateResult.getMatchResults();
                    System.debug('--- LeadConverter - Match Results: ' + matchResults);
                    for (Datacloud.MatchResult matchResult : matchResults){
                        System.debug('--- LeadConverter - Match Result: ' + matchResult);
                        List<Datacloud.MatchRecord> matchRecords = matchResult.getMatchRecords();  
                        System.debug('--- LeadConverter - Match Records: ' + matchRecords);
                        List<SObject> matchedRecords = new List<SObject>();
                        for(Datacloud.MatchRecord matchRecord : matchRecords){
                            SObject matchedRecord = matchRecord.getRecord();
                            System.debug('--- LeadConverter - Matched Record: ' + matchedRecord);
                            matchedRecords.add(matchedRecord);
                        }
                    }
                }
            }
            leadsWithDuplicates.add(leadToConvert);
        } else {
            System.debug('--- No Duplicates!');

        }
        return leadsWithDuplicates;
    }
}