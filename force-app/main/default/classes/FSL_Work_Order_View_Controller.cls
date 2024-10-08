/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 06-07-2024
 * @last modified by  : Henk Reynders
**/
public  class FSL_Work_Order_View_Controller {

    /*--- WorkOrderViewController - Getter methods ****/

    /*
    * Return ServiceAppointments by WorkOrderId
    */
    @AuraEnabled
    public static List<ServiceAppointment>  getServiceAppointments (String workOrderId) {
        System.debug('--- WorkOrderViewController - WorkOrder: '+workOrderId);
        List<ServiceAppointment> saList = [SELECT Id, AppointmentNumber, Status, EarliestStartTime, DueDate, ParentRecordId, Duration, SchedStartTime, SchedEndTime, ArrivalWindowStartTime, ArrivalWindowEndTime FROM ServiceAppointment WHERE ParentRecordId =: workOrderId /*AND (Status = 'None' OR Status = 'Scheduled' OR Status = 'Dispatched')*/ ORDER BY CreatedDate ASC];
        System.debug('--- WorkOrderViewController - Appointment List: '+saList);
        return [SELECT Id, AppointmentNumber, Status, EarliestStartTime, DueDate, ParentRecordId, Duration, SchedStartTime, SchedEndTime, ArrivalWindowStartTime, ArrivalWindowEndTime FROM ServiceAppointment WHERE ParentRecordId =: workOrderId /*AND (Status = 'None' OR Status = 'Scheduled' OR Status = 'Dispatched')*/ ORDER BY CreatedDate ASC];
        
    }

    /*
    * Return WorkOrder list by OpportunityId
    */
    @AuraEnabled
    public static List<WorkOrder> getWorkOrders(String oppoId) {
        List<WorkOrder> workOrders =([SELECT Id, Subject, WorkOrderNumber, Status, CreatedDate, ServiceAppointmentCount, 
                                            Opportunity__r.StageName, Soft_Reserved_Date__c, Hard_Reserved_Date__c, Duration 
                                    FROM WorkOrder 
                                    WHERE Opportunity__c =: oppoId ORDER BY CreatedDate DESC]);
        System.debug('--- WorkOrderViewController - WorkOrder List: '+workOrders);      
        return workOrders;
    }

    /*
    * Return WorkOrder list by WordOrderId
    */
    @AuraEnabled
    public static List<WorkOrder> getWorkOrders2(String woId) {
        List<WorkOrder> workOrders =([SELECT Id, Subject, WorkOrderNumber, Status, CreatedDate, ServiceAppointmentCount, 
                                            Opportunity__r.StageName, Soft_Reserved_Date__c, Hard_Reserved_Date__c, Duration 
                                    FROM WorkOrder 
                                    WHERE Id =: woId ORDER BY CreatedDate DESC]);
        System.debug('--- WorkOrderViewController - WorkOrder List: '+workOrders);      
        return workOrders;
    }

    /*
    * Return true if dependency is found for ServiceAppointment
    */
    @AuraEnabled
    public static Boolean getAppointmentDependency(String saId) {
        List<FSL__Time_Dependency__c> tdcs = [SELECT Id FROM FSL__Time_Dependency__c WHERE FSL__Service_Appointment_1__c =: saId];
        if(!tdcs.isEmpty()){
            return true;
        }
        return false;
    }

    /*
    * Return true if ServiceAppointment is multiday work
    */
    @AuraEnabled
    public static Boolean isSAMultiDayWork(String saId) {
        List<ServiceAppointment> sas = [SELECT Id, FSL__IsMultiDay__c FROM ServiceAppointment WHERE Id =: saId];
        if(!sas.isEmpty()){
            if(sas[0].FSL__IsMultiDay__c){
                return true;
            }
        }    
        return false;
    }

    /*
    * Return true is ServiceAppointment was scheduled
    */
    @AuraEnabled
    public static Boolean getSAScheduled (String saId) {
        try{
            if([SELECT Id, Status FROM ServiceAppointment WHERE Id =: saId].Status == 'Scheduled'){
                return true;
            }
            return false;
        }
        catch(Exception e){
            System.debug('--- WorkOrderViewController - getSAScheduled failed: '+e);
            return false;
        }
    }

    /*
    * Return Opportunity Stage Name by OpportunityId
    */
    @AuraEnabled
    public static String getOppoStageName(String oppoId) {
        return [SELECT Id, StageName FROM Opportunity WHERE Id =: oppoId].StageName;
    }

    /*
    * Return true if profile can show reserve button
    */
    @AuraEnabled
    public static Boolean getIsReserveOkForProfile() {
        if([Select Name from Profile where Id =: UserInfo.getProfileId()].Name == 'System Administrator' 
            || [Select Name from Profile where Id =: UserInfo.getProfileId()].Name == 'Lumon Installation Manager'){
            return true;
        }
        return false;
    }

    /*--- WorkOrderViewController - DML methods ****/

    /*
    * Create WorkOrder and ServiceAppointment for Opportynity
    * Call 2 Flows for additional logic
    * Return the WorkOrderId
    */
    @AuraEnabled
    public static String createWorkOrder(String oppoId) {
        try{
            List<Opportunity> oList = [SELECT Id, Name, Building__c,AccountId,
                                                   Installation_Address__c,
                                                   Installation_Address__Street__s, 
                                                   Installation_Address__PostalCode__s, 
                                                   Installation_Address__City__s, 
                                                   Installation_Address__StateCode__s, 
                                                   Installation_Address__CountryCode__s, 
                                                   Delivery_Location__c, 
                                                    Delivery_date__c  
                                        FROM Opportunity WHERE Id =: oppoId];

            //Check if user has access to opportunity
            if(oList.isEmpty()){
                return 'oppo_error';
            }
            Opportunity o = oList[0];
            System.debug('--- WorkOrderViewController - Source Opportunity: '+o);
            //Show the user error message if these fields are missing
            if(o.Delivery_date__c == null){
                System.debug('--- WorkOrderViewController - Delivery Date Missing!');
                return 'oppo_fields_error';
            }
            //if(o.Installation_Address__c.getStreet() == null ){
            /*if(o.Installation_Address__Street__s == null ){  
                System.debug('--- WorkOrderViewController - Installation Address Missing!');
                return 'oppo_fields_error';
            }*/
            List<Account> a = [SELECT Id, PersonContactId FROM Account WHERE Id =: o.AccountId]; 
            //Check if user has access to account
            if(a.isEmpty()){
                return 'account_error';
            }
            //Check if user has access to location
            List<Schema.Location> loc = [SELECT Id FROM Location WHERE Id =: o.Delivery_Location__c];
            System.debug('--- WorkOrderViewController - Opportunity Delivery Location: '+o.Delivery_Location__c);
            if(loc.isEmpty() && o.Delivery_Location__c != null){
                return 'location_error';
            }
            System.debug('--- WorkOrderViewController - Installation Country Code: '+o.Installation_Address__CountryCode__s);
            System.debug('--- WorkOrderViewController - Installation Country: '+o.Installation_Address__c.getCountry());
            System.debug('--- WorkOrderViewController - Installation State: '+o.Installation_Address__StateCode__s);
            WorkOrder wo = new WorkOrder(Subject = o.Name, 
                                         Opportunity__c = oppoId, 
                                         AccountId = o.AccountId, 
                                         ContactId = a[0].PersonContactId, 
                                         LocationId = o.Delivery_Location__c, 
                                         /*
                                         Street = o.Installation_Address__Street__s, 
                                         City = o.Installation_Address__City__s,
                                         PostalCode = o.Installation_Address__PostalCode__s, 
                                         Country = o.Installation_Address__CountryCode__s,
                                         State = o.Installation_Address__StateCode__s);*/
                                         Street = o.Installation_Address__c.getStreet(), 
                                         City = o.Installation_Address__c.getCity(),
                                         PostalCode = o.Installation_Address__c.getPostalCode(),
                                         Country = o.Installation_Address__c.getCountry(),
                                         State = o.Installation_Address__c.getState());
            insert wo;
            System.debug('--- WorkOrderViewController - WorkOrder without Territory: '+wo.Id);
            //Call Flow to add ServiceTerritory for the WorkOrder
            callTerritoryFlow(wo.Id);
            wo = [SELECT Id, ServiceTerritoryId FROM WorkOrder WHERE Id =: wo.Id];
            System.debug('--- WorkOrderViewController - WorkOrder with Territory: '+wo.Id);
            String stId = null; //Default value just in case
            if(wo.ServiceTerritoryId != null){
                stId = wo.ServiceTerritoryId;
            }
            System.debug('--- WorkOrderViewController - Service Territory: '+stId);
            //Get bookingOffset from ServiceTerritory or from Metadata
            List<ServiceTerritory> st = [SELECT Id, Appointment_Booking_Offset__c FROM ServiceTerritory WHERE Id =: stId];
            Integer bookingOffset = 0;
            if(!st.isEmpty()){
                if(st[0].Appointment_Booking_Offset__c != null){
                    bookingOffset = Integer.valueOf(st[0].Appointment_Booking_Offset__c);
                }    
            }
            if(bookingOffset == 0){
                FSL_Variable__mdt[] fsl_variables = [Select MasterLabel, Value__c from FSL_Variable__mdt];
                for(FSL_Variable__mdt var : fsl_variables){
                    if(var.MasterLabel == 'Default Appointment Booking Offset'){
                        bookingOffset = Integer.valueOf(var.Value__c);
                    }
                }
            }

            //Call Flow to add WorkOrderLineItems for the WorkOrder
            System.debug('--- WorkOrderViewController - Trigger WOLI Flow!');
            callWOLIFlow(wo.Id);

            Decimal duration = [SELECT Total_Duration__c FROM WorkOrder WHERE Id =: wo.Id].Total_Duration__c;
            System.debug('--- WorkOrderViewController - Installation Duration: '+duration);
            //Value 0 is not valid duration so replace with 1
            if(duration == 0){
                duration = 1;
                System.debug('--- WorkOrderViewController - Min Installation Duration: '+duration);
            }
            //Otherwise convert to hours
            else{
                duration = duration.setScale(4);
                System.debug('--- WorkOrderViewController - Installation Hours: '+duration);
            }

            ServiceAppointment sa = new ServiceAppointment(ParentRecordId = wo.Id, 
                                                           EarliestStartTime = o.Delivery_date__c.addDays(bookingOffset), 
                                                           DueDate = o.Delivery_date__c.addDays(bookingOffset+7), 
                                                           Duration = duration);
            insert sa;
            System.debug('--- WorkOrderViewController - Service Appointment: '+sa);
            return wo.Id;
        }
        catch(Exception e){
            system.debug('Error in creating Work Order and Service Appointment: '+ e);
            return 'main_error: '+e;
        }    
    }

    /*
    * Update WorkOrder and ServiceAppointment with the given data
    * Create, update or delete Service Appointment Dependency if 2 installers are selected
    * Return the true if success
    */
    @AuraEnabled
    public static Boolean saveSA(String saId, Decimal duration, Date estValue, Date dueDate, String woId, String workOrderSubject, Integer amountOfInstallers) {
        try{
            //Check if dependency is found
            List<FSL__Time_Dependency__c> tdcs = [SELECT Id, FSL__Service_Appointment_2__c FROM FSL__Time_Dependency__c WHERE FSL__Service_Appointment_1__c =: saId];
            //If amount of installers were changed from 2 to 1 delete the dependecy
            if(!tdcs.isEmpty() && amountOfInstallers == 1){
                String ap2Id = tdcs[0].FSL__Service_Appointment_2__c;
                delete tdcs;
                delete [SELECT Id FROM ServiceAppointment WHERE Id =: ap2Id];
            }
            //If amount of installers is changed to 2 without dependency create it
            else if(tdcs.isEmpty() && amountOfInstallers == 2){
                ServiceAppointment sa = new ServiceAppointment(ParentRecordId = woId, Duration = duration, EarliestStartTime = estValue, DueDate = dueDate);
                insert sa;
                FSL__Time_Dependency__c td = new FSL__Time_Dependency__c(FSL__Dependency__c = 'Same Start', FSL__Service_Appointment_1__c = saId, FSL__Service_Appointment_2__c = sa.Id, FSL__Root_Service_Appointment__c = saId);
                insert td;
            }
            //If amount of installer is still 2 with existing dependency update it
            else if(!tdcs.isEmpty() && amountOfInstallers == 2){
                ServiceAppointment sa2 = new ServiceAppointment(Id=tdcs[0].FSL__Service_Appointment_2__c, Duration = duration, EarliestStartTime = estValue, DueDate = dueDate);
                update sa2;
            }
            WorkOrder wo = new WorkOrder(Id = woId, Subject = workOrderSubject, Duration = duration);
            update wo;
            ServiceAppointment sa = new ServiceAppointment(Id=saId, Duration = duration, EarliestStartTime = estValue, DueDate = dueDate);
            update sa;

            return true;
        }
        catch(Exception e){
            system.debug('Error in updating Service Appointment: '+ e);
        }    
        return false;
    }

    /*
    * Clear soft save and booking values from ServiceAppointment
    * Return the true if success
    */
    @AuraEnabled
    public static Boolean cancelBooking(String saId) {
        try{
            //Check if dependency is found
            List<FSL__Time_Dependency__c> tdcs = [SELECT Id, FSL__Service_Appointment_2__c FROM FSL__Time_Dependency__c WHERE FSL__Service_Appointment_1__c =: saId];
            ServiceAppointment sa = new ServiceAppointment(Id=saId, Status='None', ArrivalWindowStartTime=null, ArrivalWindowEndTime=null, SchedStartTime=null, SchedEndTime=null);
            update sa;
            if(!tdcs.isEmpty()){
                sa = new ServiceAppointment(Id=tdcs[0].FSL__Service_Appointment_2__c, Status='None', ArrivalWindowStartTime=null, ArrivalWindowEndTime=null, SchedStartTime=null, SchedEndTime=null);
                update sa;
            }
            return true;
        }
        catch(Exception e){
            system.debug('Error in cancelling Service Appointment: '+ e);
        }    
        return false;
    }

    /*
    * Delete WorkOrder
    * Return the true if success
    */
    @AuraEnabled
    public static String deleteWorkOrder(String woId) {
        try{
            List<ServiceAppointment> sas = [SELECT Id FROM ServiceAppointment WHERE ParentRecordId =: woId ORDER BY CreatedDate];
            if(sas.size()>1){
                delete [SELECT Id FROM FSL__Time_Dependency__c WHERE FSL__Service_Appointment_1__c =: sas[0].Id];
            }
            delete [SELECT Id FROM WorkOrder WHERE Id =: woId];
            return 'true';
        }
        catch(Exception e){
            system.debug('Error in deleting WorkOrder: '+ e);
            return 'false: '+e;
        }    
    }

    /*
    * Call FSL Booking(Reserve) method
    */
    @AuraEnabled
	public static String scheduleExtended(Id serviceId){

        try{
            //String workOrderId = [SELECT Id, ParentRecordId FROM ServiceAppointment WHERE Id =: serviceId].ParentRecordId;
            //List<ServiceAppointment> sas = [SELECT Id, ArrivalWindowStartTime, ArrivalWindowEndTime, FSL__IsMultiDay__c FROM ServiceAppointment WHERE ParentRecordId =: workOrderId];
            //String policyId = [SELECT Id FROM FSL__Scheduling_Policy__c WHERE Name = 'Custom Component Reservation' LIMIT 1].Id;

            //If complex multiday work manual update is needed
            /*if(sas.size() > 1 && sas[0].FSL__IsMultiDay__c){
                Boolean scheduleOK = true;
                
                for(ServiceAppointment sa : sas){
                    system.debug('sched:'+sa.Id);
                    FSL.ScheduleResult res = FSL.ScheduleService.schedule(policyId, sa.Id);
                    if(res == null){
                        system.debug('schedBreak');
                        scheduleOK = false;
                        break;
                    }
                    system.debug('schedContinue');
                }

                //If scheduling fails revert to soft reserve status
                if(!scheduleOK){
                    for(ServiceAppointment sa : sas){
                        sa.Status = 'None';
                        sa.SchedStartTime = null;
                        sa.SchedEndTime = null;
                    }
                    update sas;
                    return 'time_not_available';
                }

                return 'success';
            }	
            else{*/
                FSL.ScheduleService.ScheduleExtended([SELECT Id FROM FSL__Scheduling_Policy__c WHERE Name = 'Custom Component Reservation' LIMIT 1].Id, serviceId);
                return 'success';
            //}
        }catch(Exception e){
            return 'general_error'+e;
        }    
	}

    /*--- WorkOrderViewController - Flow methods ****/

    /*
    * Call Flow to create WorkOrderLineItems for WorkOrder
    */
    public static void callWOLIFlow(String woId){
        //Create parameter
        Map<String, Object> Params = new Map<String, Object>();
        Params.put('recordId', woId);

        //create instance of Interview
        Flow.Interview.WO_Create_WOLIs stage = new Flow.Interview.WO_Create_WOLIs(Params);

        //Invoke start method
        stage.start();
    }

    /*
    * Call Flow to fill ServiceTerritory for WorkOrder
    */
    public static void callTerritoryFlow(String woId){
        //Create parameter
        Map<String, Object> Params = new Map<String, Object>();
        Params.put('recordId', woId);

        //create instance of Interview
        Flow.Interview.Assign_Service_Territory_SubFlow stage = new Flow.Interview.Assign_Service_Territory_SubFlow(Params);

        //Invoke start method
        stage.start();
    }

    /*--- WorkOrderViewController - Helper methods ****/

    @AuraEnabled
    public static Opportunity getNull(String recordId){
        return null;
    }

    @AuraEnabled
    public static boolean getDebugMode(){
        try {
            FSL_Variable__mdt[] fsl_variables = [Select MasterLabel, Value__c from FSL_Variable__mdt WHERE MasterLabel =: 'Work Order View Debug Mode'];
            if(fsl_variables.size() > 0){
                if(fsl_variables[0].Value__c == '1'){
                    return true;
                }
            }
            return false;
        } catch (Exception e) {
            system.debug(e);
            return false;
        }
    }
}