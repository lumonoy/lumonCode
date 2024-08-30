/**
 * @author Reijo Mattila, reijo.mattila@fluidogroup.com
 * @since 2022 December
 * Update 13.09.2023
 *
 * The Invocable method test class
 */
@isTest
public class FSL_ScheduleAppointmentFlowTest {
	@TestSetup
    public static void prepareData(){
        Test.startTest();
		LumonTestFieldServices.setupFieldServices();  
        Test.stopTest();
    }   
    private static Id accountId = LumonTestFieldServices.fslAccountId;
    private static Id opportunityId = LumonTestFieldServices.fslOpportunityId;
    private static Id serviceTerritoryId = LumonTestFieldServices.serviceTerritoryId;
    private static Id policyId = LumonTestFieldServices.policyId;
	private static Id workOrderId = LumonTestFieldServices.workOrderId;
	private static Id serviceAppointmentId = LumonTestFieldServices.serviceAppointmentId;
	

    @IsTest
	public static void scheduleServiceTest() {
        List<String> workOrderIds = new List<String>();
        workOrderIds.add(workOrderId);
        List<List<String>> listlist = new List<List<String>>{workOrderIds};
        //FSL_ScheduleAppointmentFlow.callSchedule(policyId,serviceAppointmentId);
        Map<String, Object> flowParams = new Map<String, Object>();
        flowParams.put('OppoId', opportunityId);
        Flow.Interview.Request_Work_Scheduling_Subflow scheduleWorkSubFlow = new Flow.Interview.Request_Work_Scheduling_Subflow(flowParams);

        Test.StartTest();
        String result;
        try {
            scheduleWorkSubFlow.start();
            result = 'success';
        } catch (Exception e) {
            result = 'error';
            System.debug(e.getMessage());

        }
		System.assertEquals('success',result, 'Flow failure'); 
		System.debug('----scheduleServiceTest - CPU TIME: '+LIMITS.getCpuTime()); 
        System.debug('----scheduleServiceTest - SOQL USED: ' + LIMITS.getQueries());
		Test.stopTest();
        
	}
}