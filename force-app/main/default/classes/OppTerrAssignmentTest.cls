/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-01-2023
 * @last modified by  : Henk Reynders
**/
@isTest
public class OppTerrAssignmentTest {
    @testSetup static void setupOpptTestData() {
        //SalesTestDataFactory.setupOpportunityRecords();
        String B2CRecordTypeId= [SELECT Id FROM RecordType WHERE (Name='B2C Account') and (SobjectType='Account')].Id;
        String B2BRecordTypeId= [SELECT Id FROM RecordType WHERE (Name='B2B Account') and (SobjectType='Account')].Id;
        Account p = new Account(      
            RecordTypeID=B2CRecordTypeId,
            FirstName='My',
            LastName='Person Account',
            PersonEmail='test@factory.com',
            PersonMailingCountry ='Finland',
            PersonMailingCity='Kaupunki',
            PersonMailingPostalCode = '1111',
            PersonMailingStreet='Katu 1');  
        Account a = new Account(
            RecordTypeID=B2BRecordTypeId,
            Name='Account Test Opportunity',
            BillingCountry ='Finland',
            BillingCity='Kaupunki',
            BillingPostalCode = '22222',
            BillingStreet = 'Katu 2');
        insert new List<Account> {p,a};    
        Id pbid = Test.getStandardPricebookId();   
        Opportunity o1 = new Opportunity(
            Name='B2C Opportunity', 
            StageName='Quoting', 
            CloseDate=system.Today()+10,
            Pricebook2Id=pbid,
            AccountId = p.Id
            );
        Opportunity o2 = new Opportunity(
            Name='B2B Opportunity', 
            StageName='Quoting', 
            CloseDate=system.Today()+10,
            Pricebook2Id=pbid,
            AccountId = a.Id
            );
        insert new List<Opportunity> {o1,o2};  
        System.debug('*** OppTerrAssignmentTest - setupOpptTestData CPU TIME: '+LIMITS.getCpuTime());   

    }  
    @isTest
    static void getOppTerritoryOnePerAccountTest() {
        List<Id> opportunityIds = New List<Id>();
        Account accnt = [SELECT Id,billingCountryCode FROM Account WHERE Name = 'Account Test Opportunity' LIMIT 1];
        List<Opportunity> oppts = [SELECT Id,Name FROM Opportunity WHERE accountId =: accnt.Id];
        System.debug('*** OppTerrAssignmentTest - Opportunities: '+oppts);  
        OppTerrAssignDefaultLogicFilter filter = new OppTerrAssignDefaultLogicFilter();
        Map<Id,Id> MyOpptyTerrMap = new Map<Id,Id>();
        filter.getOpportunityTerritory2Assignments(opportunityIds); 
        System.debug('*** OppTerrAssignmentTest - getOppTerritoryOnePerAccountTest CPU TIME: '+LIMITS.getCpuTime());   
    }
    @isTest
    static void getOppTerritoryTwoPerAccountTest() {
        List<Id> opportunityIds = New List<Id>();
        Account accnt = [SELECT Id,billingCountryCode FROM Account WHERE Name = 'Account Test Opportunity' LIMIT 1];
        List<Opportunity> oppts = [SELECT Id,Name FROM Opportunity WHERE accountId =: accnt.Id];
        System.debug('*** OppTerrAssignmentTest - Opportunities: '+oppts);  
        OppTerrAssignDefaultLogicFilter filter = new OppTerrAssignDefaultLogicFilter();
        for (Opportunity oppt : oppts ){
            opportunityIds.add(oppt.Id);
        }
        Map<Id,Id> MyOpptyTerrMap = new Map<Id,Id>();
        filter.getOpportunityTerritory2Assignments(opportunityIds); 
        System.debug('*** OppTerrAssignmentTest - getOppTerritoryTwoPerAccountTest CPU TIME: '+LIMITS.getCpuTime());   
    }
    @isTest
    static void setOpportunityTerritory2AssignmentsTest() {
		Account accnt = [SELECT Id,billingCountryCode FROM Account WHERE Name = 'Account Test Opportunity' LIMIT 1]; 
        List<Opportunity> oppts = [SELECT Id,Name FROM Opportunity WHERE accountId =: accnt.Id];
        System.debug('*** OppTerrAssignmentTest - Opportunities: '+oppts);   
        Opportunity opp = oppts[0];
        Id opportunityId = opp.Id;
        OppTerrAssignDefaultLogicFilter filter = new OppTerrAssignDefaultLogicFilter();
        Territory2 terr = [SELECT Id, Territory2.name,Territory2ModelId,Territory2Model.Name,Territory2Model.State, DeveloperName,ParentTerritory2Id FROM Territory2 WHERE Territory2Model.State = 'Active' limit 1];
        System.debug('*** terr value ***'+terr);
        ObjectTerritory2Association ota1 = new ObjectTerritory2Association(AssociationCause  = 'Territory2Manual', ObjectId = accnt.Id, Territory2Id = terr.Id);
        insert ota1; 
        Map<Id, Id> resultMap = filter.getOpportunityTerritory2Assignments(new List<Id> {opportunityId});
        System.assertEquals(1, resultMap.size());
        System.assertEquals(resultMap.get(opportunityId), terr.Id);
        //System.assertEquals(null, resultMap.get(opp.Id), 'No territory should be assinged as manual assignments are ignored in the rule');
    }
    @testVisible
    /**
    * Helper class to capture territory2Id, its priority, 
    * and check if there are more territories with same priority assigned to the account
    */
    private class Territory2Priority {
        public Id territory2Id { get; set; }
        public Integer priority { get; set; }
        public Boolean moreTerritoriesAtPriority { get; set; } 
        Territory2Priority(Id territory2Id, Integer priority, Boolean moreTerritoriesAtPriority){
            this.territory2Id = territory2Id;
            this.priority = priority;
            this.moreTerritoriesAtPriority = moreTerritoriesAtPriority;
        }
    }

}