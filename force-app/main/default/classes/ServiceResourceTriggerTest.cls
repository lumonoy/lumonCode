/**
 * @author Reijo Mattila, reijo.mattila@fluidogroup.com
 * 01.12.2023
 *
 * Trigger Test Class
 */

@isTest
public class ServiceResourceTriggerTest {

    @IsTest
    public static void testSetSTMActiveAndInactive() {
        
        ServiceTerritoryMemberTriggerHandler.dontRunInsertTriggerForTest = true;
        OperatingHoursHolidayTriggerHandler.dontRunInsertTriggerForTest = true;
        OperatingHours oh = new OperatingHours(Name='TestOH');
        insert oh;
        Holiday h = [SELECT Id, ActivityDate FROM Holiday Limit 1];
        ServiceResource sr = new ServiceResource(Name='TestRes', isActive = true, RelatedRecordId = UserInfo.getUserId());
        insert sr;
        sr = [SELECT Id, isActive FROM ServiceResource WHERE Id =: sr.Id];
        ServiceTerritory st = new ServiceTerritory(Name='TestTer', OperatingHoursId = oh.Id, isActive = true);
        insert st;
        OperatingHoursHoliday ohh = new OperatingHoursHoliday(OperatingHoursId = oh.Id, HolidayId = h.Id);
        insert ohh;
        ServiceTerritoryMember stm = new ServiceTerritoryMember(ServiceResourceId = sr.Id, ServiceTerritoryId = st.Id, EffectiveStartDate=system.today());
        insert stm;
        DateTime start = DateTime.newInstance(h.ActivityDate.year(), h.ActivityDate.month(), h.ActivityDate.day(), 00, 00, 01);
        DateTime end2 = DateTime.newInstance(h.ActivityDate.year(), h.ActivityDate.month(), h.ActivityDate.day(), 23, 59, 59);
        ResourceAbsence ra = new ResourceAbsence(ResourceId = sr.Id, Start = start, End = end2, HolidayId__c = ohh.Id, Operating_Hours_Holiday__c = ohh.Id, Service_Territory__c = st.Id, FSL__Approved__c = true, Approval_handled_by__c = 'System');
        insert ra;
        System.assertEquals(1,[SELECT Id FROM ResourceAbsence].size());
        Test.startTest();
        sr.isActive = false;
        update sr;
        System.assertEquals(0,[SELECT Id FROM ResourceAbsence].size());
        sr.isActive = true;
        ServiceTerritoryMemberTriggerHandler.dontRunInsertTriggerForTest = false;
        update sr;
        Test.stopTest();
        System.assertEquals(1,[SELECT Id FROM ResourceAbsence].size());
    }
}