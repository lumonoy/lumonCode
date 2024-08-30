/**
 * @author Reijo Mattila, reijo.mattila@fluidogroup.com
 * 01.12.2023
 *
 * Trigger Test Class
 */

 @isTest
 public class ServiceTerritoryMemberTriggerTest {
     
 
    @IsTest
    public static void testInsertSTMs() {
        
        OperatingHoursHolidayTriggerHandler.dontRunInsertTriggerForTest = true;
        OperatingHours oh = new OperatingHours(Name='TestOH');
        insert oh;
        Holiday h = [SELECT Id FROM Holiday Limit 1];
        ServiceResource sr = new ServiceResource(Name='TestRes', isActive = true, RelatedRecordId = UserInfo.getUserId());
        insert sr;
        ServiceTerritory st = new ServiceTerritory(Name='TestTer', OperatingHoursId = oh.Id, isActive = true);
        insert st;
        OperatingHoursHoliday ohh = new OperatingHoursHoliday(OperatingHoursId = oh.Id, HolidayId = h.Id);
        insert ohh;

        Test.startTest();
        ServiceTerritoryMember stm = new ServiceTerritoryMember(ServiceResourceId = sr.Id, ServiceTerritoryId = st.Id, EffectiveStartDate=system.today());
        insert stm;
        Test.stopTest();

        System.assertEquals(1,[SELECT Id FROM ResourceAbsence].size());
    }

    @IsTest
    public static void testDeleteSTMs() {

        ServiceTerritoryMemberTriggerHandler.dontRunInsertTriggerForTest = true;
        OperatingHoursHolidayTriggerHandler.dontRunInsertTriggerForTest = true;
        OperatingHours oh = new OperatingHours(Name='TestOH');
        insert oh;
        Holiday h = [SELECT Id, ActivityDate FROM Holiday Limit 1];
        ServiceResource sr = new ServiceResource(Name='TestRes', isActive = true, RelatedRecordId = UserInfo.getUserId());
        insert sr;
        ServiceTerritory st = new ServiceTerritory(Name='TestTer', OperatingHoursId = oh.Id, isActive = true);
        insert st;
        ServiceTerritoryMember stm = new ServiceTerritoryMember(ServiceResourceId = sr.Id, ServiceTerritoryId = st.Id, EffectiveStartDate=system.today());
        insert stm;
        OperatingHoursHoliday ohh = new OperatingHoursHoliday(OperatingHoursId = oh.Id, HolidayId = h.Id);
        insert ohh;
        DateTime start = DateTime.newInstance(h.ActivityDate.year(), h.ActivityDate.month(), h.ActivityDate.day(), 00, 00, 01);
        DateTime end2 = DateTime.newInstance(h.ActivityDate.year(), h.ActivityDate.month(), h.ActivityDate.day(), 23, 59, 59);
        ResourceAbsence ra = new ResourceAbsence(ResourceId = sr.Id, Start = start, End = end2, HolidayId__c = ohh.Id, Operating_Hours_Holiday__c = ohh.Id, Service_Territory__c = st.Id, FSL__Approved__c = true, Approval_handled_by__c = 'System');
        insert ra;

        Test.startTest();
        delete [SELECT Id FROM ServiceTerritoryMember WHERE Id =: stm.Id];
        Test.stopTest();

        System.assertEquals(0,[SELECT Id FROM ResourceAbsence].size());
    }
 }