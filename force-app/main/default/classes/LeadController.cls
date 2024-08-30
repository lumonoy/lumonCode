/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 03-26-2024
 * @last modified by  : Henk Reynders
**/
public with sharing class LeadController {
    /**** Methods for Finding Lead Entries ****/
    @AuraEnabled(cacheable=false)
    public static Lead getLead(Id recordId ) {
        // Populate List from SOQL query on Lead
        //System.Debug('--- Get Lead with Id: '+recordId); 
        List<Id> recordIds = new List<Id>();
        recordIds.add(recordId);
        List<Lead> leads = getLeads(recordIds);
        Lead lead = leads[0];

        //System.Debug('--- Lead: '+lead.Name); 
        return lead;  
    }
    @AuraEnabled(cacheable=false)
    public static List<Lead> getLeads(List<Id> recordIds ) {
        // Populate List from SOQL query on Lead
        //System.Debug('--- Get Leads'); 
        List<Lead> leads = ([  SELECT  Id, 
                                        MasterRecordId, 
                                        LastName, 
                                        FirstName, 
                                        Salutation, 
                                        Name, 
                                        RecordTypeId, 
                                        Phone, MobilePhone, Fax, 
                                        Email, EmailBouncedReason, EmailBouncedDate,
                                        Description, LeadSource, Status,
                                        IsConverted, ConvertedDate, 
                                        ConvertedAccountId, ConvertedContactId, ConvertedOpportunityId,
                                        Customer_meeting_booked__c, Visit_Booked__c,
                                        Customer_Segment__c, Business_Type__c, Property_Type__c,
                                        Language__c,
                                        Title,
                                        Company, Industry, Rating, 
                                        Address,Street,City,State, PostalCode, Country,StateCode, CountryCode, Latitude, Longitude, GeocodeAccuracy,
                             			SMS_Opt_In_Date_Time__c,SMS_Opt_In__c, Email_Opt_In_Date_Time__c,Email_Opt_In__c,
                             			Finland_Sync_to_MC__c,Other_Countries_Sync_to_MC__c,Spain_Sync_to_MC__c,
                             			ConvertedAccount.Finland_Sync_to_MC__pc, ConvertedAccount.Other_Countries_Sync_to_MC__pc,ConvertedAccount.Spain_Sync_to_MC__pc,
                             			ConvertedContact.Finland_Sync_to_MC__c, ConvertedContact.Other_Countries_Sync_to_MC__c,ConvertedContact.Spain_Sync_to_MC__c,
                             			ConvertedOpportunity.Finland_Sync_to_MC__c, ConvertedOpportunity.Other_Countries_Sync_to_MC__c,ConvertedOpportunity.Spain_Sync_to_MC__c
                                    FROM Lead 
                                    WHERE Id IN: recordIds
                                    ]);  
        //System.Debug('--- Leads: '+leads.size()); 
        return leads;  
    }
    @InvocableMethod (label='Convert Leads' description='Converts Leads to Accounts and Opportunities' category='Lead')
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
                    //System.Debug('--- LeadConverter - No Duplicates Found!');
                    Database.LeadConvert dbLead = new Database.LeadConvert();
                    dbLead.setLeadId(currentLeadId);
                    dbLead.setConvertedStatus(convertedStatus);
                    //leadConvert.setDoNotCreateOpportunity(true);
                    dbLeads.add(dbLead);
                } else {
                    //System.Debug('--- LeadConverter - '+duplicateLeads.size()+' Possible Duplicates Found!');
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
            //System.Debug('--- LeadConverter - '+findDuplicatesResults.size()+' Possible Duplicates Found!');
            for (Integer i=0; i<findDuplicatesResults.size(); i++) {
            //for (Datacloud.DuplicateResult duplicateResult :  findDuplicatesResults) { 
                Datacloud.FindDuplicatesResult findDuplicateResult = findDuplicatesResults.get(i);    
                for (Integer j=0; j<findDuplicateResult.getDuplicateResults().size();j++) {
                    Datacloud.DuplicateResult duplicateResult = findDuplicatesResults.get(i).getDuplicateResults().get(j);
                    //System.Debug('--- LeadConverter - Duplicate Result: ' + duplicateResult);
                    List<Datacloud.MatchResult> matchResults = duplicateResult.getMatchResults();
                    //System.Debug('--- LeadConverter - Match Results: ' + matchResults);
                    for (Datacloud.MatchResult matchResult : matchResults){
                        //System.Debug('--- LeadConverter - Match Result: ' + matchResult);
                        List<Datacloud.MatchRecord> matchRecords = matchResult.getMatchRecords();  
                        //System.Debug('--- LeadConverter - Match Records: ' + matchRecords);
                        List<SObject> matchedRecords = new List<SObject>();
                        for(Datacloud.MatchRecord matchRecord : matchRecords){
                            SObject matchedRecord = matchRecord.getRecord();
                            //System.Debug('--- LeadConverter - Matched Record: ' + matchedRecord);
                            matchedRecords.add(matchedRecord);
                        }
                    }
                }
            }
            leadsWithDuplicates.add(leadToConvert);
        } else {
            //System.Debug('--- No Duplicates!');

        }
        return leadsWithDuplicates;
    }
}