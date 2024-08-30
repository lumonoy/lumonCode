import { LightningElement ,wire,track,api} from 'lwc';
import getServiceAppointments from  '@salesforce/apex/FSL_Work_Order_View_Controller.getServiceAppointments';
import getOppoStageName from  '@salesforce/apex/FSL_Work_Order_View_Controller.getOppoStageName';
import getWorkOrders from '@salesforce/apex/FSL_Work_Order_View_Controller.getWorkOrders';
import getWorkOrders2 from '@salesforce/apex/FSL_Work_Order_View_Controller.getWorkOrders2';
import getNull from '@salesforce/apex/FSL_Work_Order_View_Controller.getNull';
import getAppointmentDependency from  '@salesforce/apex/FSL_Work_Order_View_Controller.getAppointmentDependency';
import isSAMultiDayWork from  '@salesforce/apex/FSL_Work_Order_View_Controller.isSAMultiDayWork';
import getIsReserveOkForProfile from  '@salesforce/apex/FSL_Work_Order_View_Controller.getIsReserveOkForProfile';
import getSAScheduled from  '@salesforce/apex/FSL_Work_Order_View_Controller.getSAScheduled';
import getDebugMode from  '@salesforce/apex/FSL_Work_Order_View_Controller.getDebugMode';
import createWorkOrder from '@salesforce/apex/FSL_Work_Order_View_Controller.createWorkOrder';
import saveSA from '@salesforce/apex/FSL_Work_Order_View_Controller.saveSA';
import scheduleExtended from '@salesforce/apex/FSL_Work_Order_View_Controller.scheduleExtended';
import cancelBooking from '@salesforce/apex/FSL_Work_Order_View_Controller.cancelBooking';
import deleteWorkOrder from '@salesforce/apex/FSL_Work_Order_View_Controller.deleteWorkOrder';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import LightningConfirm from 'lightning/confirm';
import { NavigationMixin } from 'lightning/navigation';

//slot stuff
import getDualSASlotsMap from  '@salesforce/apex/FSL_GetAppointmentController.getDualSASlotsMap';
import getAvailableSlotsMap from '@salesforce/apex/FSL_GetAppointmentController.getAvailableSlotsMap';
import updateServiceAppointments from '@salesforce/apex/FSL_GetAppointmentController.updateServiceAppointments';

import {
    subscribe,
    onError,
} from 'lightning/empApi';

export default class Lumon_WorkOrderCreation extends NavigationMixin(LightningElement) {
    @api recordId;
    @api objectApiName;
    @track slotsOptions = [];

    //slot stuff
    listOfSlots = [];
	isSaveSelectedSlotShown = false;
	isLoading = false;
	isLoaded = false;
	isBookedShown = false;
	selectedTimeSlot = null;
    
    //Variables
    serviceAppointments;
    workOrders;
    error;
    isLoading = true;
    opportunityId;
    oppoStageName;
    selectedWorkOrderId;
    selectedSAId;
    appointmentDependecyId;
    appointmentDependecyFound = false;
    show_wo_list_section = false;
    show_save_wo_section = false;
    show_reschedule_section = false;
    showBookViewSection = false;
    startedFromWO = false;
    isRescheduling = false;
    showArrivalTimes = false;
    dontAllowEdit = false;
    showOnlyBack = false;
    noServiceAppointments = false;
    isReserveOK = false;
    waitingListener = false;
    estNotValid = false;
    isAdminUser = false;

    //Values
    workOrderNumberValue = "12345";
    workOrderSubjectValue = "test";
    statusValue;
    scheduledStartValue;
    scheduledEndValue;
    arrivalWindowStartValue;
    arrivalWindowEndValue;
    durationValue = "10";
    ESTValue = "";
    estLimitValue = ""; //User cant set ESTValue earlier than this
    dueDateValue = "";
    amountOfInstallers = 1;

    //Select options
    get aOIoptions() {
        return [
            { label: '1', value: 1 },
            { label: '2', value: 2 }
        ];
    }

    @track slots;
    @track error;

    /********* Init methods *************/

    /*
	 * Get Record data
	 */
	@wire(getNull, { recordId: '$recordId'})
	wiredObject({ error, data }) {
		if (data) {
            //Do nothing
		} else if (error) {
            this.setIsAdminUser();
            if(this.objectApiName === 'Opportunity'){
                this.opportunityId = this.recordId;
                this.getWorkOrderJS();
            }
            if(this.objectApiName === 'WorkOrder'){
                this.selectedWorkOrderId = this.recordId;
                this.startedFromWO = true;
                this.getWorkOrderJS2();
            }
		}
        this.handleSubscribe();
	}

    /********* Getter methods *************/

    /*
    * Get WorkOrder data for list
    */
    async getWorkOrderJS(){
        this.isLoading = true;
        this.oppoStageName = await getOppoStageName({oppoId: this.opportunityId});
        this.workOrders = await getWorkOrders({oppoId: this.opportunityId});

        //Add boolean field which is true if SA is found to the WO list
        this.workOrders = this.workOrders.map((elem) => {
            const self = this;
            return {
                ...elem,
                get serviceAppointmentFound() {
                    if(this.ServiceAppointmentCount > 0){
                        return true;
                    }
                    return false;
                }
            };
        });

        //Add boolean field which is true if WO is not scheduled with below oppo stage to the WO list
        this.workOrders = this.workOrders.map((elem) => {
            const self = this;
            return {
                ...elem,
                get isNotScheduledOK() {
                    if(this.Opportunity__r.StageName == 'Contract Signed' && this.Hard_Reserved_Date__c == null){
                        return true;
                    }
                    return false;
                }
            };
        });

        //Add boolean field which is true if WO has unscheduled multiday sas
        this.workOrders = this.workOrders.map((elem) => {
            const self = this;
            return {
                ...elem,
                get manuallyScheduleServices() {
                    if(this.Hard_Reserved_Date__c != null && this.Duration > 7.5 && this.ServiceAppointmentCount > 1){
                        return true;
                    }
                    return false;
                }
            };
        });

        //Add boolean field which is true if WO is scheduled to the WO list
        this.workOrders = this.workOrders.map((elem) => {
            const self = this;
            return {
                ...elem,
                get isScheduledOK() {
                    if(this.Hard_Reserved_Date__c != null){
                        return true;
                    }
                    return false;
                }
            };
        });

        //Add boolean field which is true if WO is soft saved correctly to the WO list
        this.workOrders = this.workOrders.map((elem) => {
            const self = this;
            return {
                ...elem,
                get isBookedOK() {
                    if(this.Hard_Reserved_Date__c == null && this.Soft_Reserved_Date__c  != null){
                        return true;
                    }
                    return false;
                }
            };
        });

        this.setIsReserveOk();
        this.showWOList();
        this.isLoading = false;
    }

    /*
    * Get WorkOrder data
    */
    async getWorkOrderJS2(){
        this.workOrders = await getWorkOrders2({woId: this.selectedWorkOrderId});
        this.opportunityId = this.workOrders[0].Opportunity__c;
        this.oppoStageName = await getOppoStageName({oppoId: this.opportunityId});
        if(this.workOrders[0].ServiceAppointmentCount < 1){
            this.isLoading = false;
            this.noServiceAppointments = true;
        }
        else{
            this.setIsReserveOk();
            this.fetchWOForSaveJS();
        }
    }

    /*
    * Get Service Appointment data
    */
    getServiceAppointmentsJS(event){
        this.isLoading = true;
        this.selectedWorkOrderId = event.currentTarget.dataset.woid;
        this.fetchWOForSaveJS();
    }

    /*
    * Get users permission level
    */
    async setIsAdminUser(){
        this.isAdminUser = await getIsReserveOkForProfile();
    }

    /*
    * Get status for showing Reserve Button
    */
    setIsReserveOk(){
        this.isReserveOK = false;
        if(this.isAdminUser || this.oppoStageName == 'Contract Signed'){
            this.isReserveOK = true;
        }
    }

    get isEmptyListMessageShown() {
		return this.isLoaded && this.listOfSlots.length === 0;
	}

    /********* DML methods *************/

    /*
    * Save WorkOrder and ServiceAppointment and show slot section
    */
    async bookSlots(){
        this.isLoading = true;
        this.isSaveSelectedSlotShown = false;
        const saveOK = await saveSA({saId:this.selectedSAId, duration: this.durationValue, estValue: this.ESTValue, dueDate: this.dueDateValue, woId: this.selectedWorkOrderId, workOrderSubject: this.workOrderSubjectValue, amountOfInstallers: this.amountOfInstallers});
        if(saveOK){
            this.isLoaded = false;
            this.listOfSlots = [];
            this.showBookingSection();
            this.handleLoadSlots();
        }
        else{
            this.showToast('Error','Error when starting booking, please contact Support!', 'Error');
            this.isLoading = false;
        }
    }

    /*
    * Fetch Component Data for WorkOrder and ServiceAppointment
    * Select which section to show next
    */
    async fetchWOForSaveJS(){
        //init values
        this.dontAllowEdit = false;
        this.showOnlyBack = false;
        this.amountOfInstallers = 1;

        //Call apex
        this.serviceAppointments = await getServiceAppointments({workOrderId: this.selectedWorkOrderId});
        this.appointmentDependecyFound = await getAppointmentDependency({saId: this.serviceAppointments[0].Id});

        //Init installer amount
        this.amountOfInstallers = 1;
        if(this.appointmentDependecyFound){
            this.amountOfInstallers = 2;
        }

        //Init WorkOrder
        for (var i = 0; i < this.workOrders.length; i++) {
            if(this.selectedWorkOrderId === this.workOrders[i].Id){
                this.workOrderNumberValue = this.workOrders[i].WorkOrderNumber;
                this.workOrderSubjectValue = this.workOrders[i].Subject;
                if(this.workOrders[i].Status != 'New'){
                    this.dontAllowEdit = true;
                    this.showOnlyBack = true;
                }
            }  
        }
        
        //Init ServiceAppointment
        this.selectedSAId = this.serviceAppointments[0].Id;
        this.statusValue = this.serviceAppointments[0].Status;
        this.durationValue = this.serviceAppointments[0].Duration;
        this.ESTValue = this.serviceAppointments[0].EarliestStartTime;
        this.estLimitValue = this.serviceAppointments[0].EarliestStartTime;
        this.dueDateValue = this.serviceAppointments[0].DueDate;
        this.scheduledStartValue = this.serviceAppointments[0].SchedStartTime;
        this.scheduledEndValue = this.serviceAppointments[0].SchedEndTime;
        this.arrivalWindowStartValue = this.serviceAppointments[0].ArrivalWindowStartTime;
        this.showArrivalTimes = false;
        if(this.arrivalWindowStartValue){
            this.showArrivalTimes = true;
            this.dontAllowEdit = true;
        }
        this.arrivalWindowEndValue = this.serviceAppointments[0].ArrivalWindowEndTime;

        //Init editable sections
        if(this.serviceAppointments[0].Status != 'None'){
            this.dontAllowEdit = true;
        }
        if(this.serviceAppointments[0].Status == 'Dispatched'){
            if(!this.isAdminUser){
                this.showOnlyBack = true;
            }
        }

        //Select which section to next
        if(this.statusValue == 'Scheduled' || this.statusValue == 'Dispatched'){
            this.isRescheduling = true;
            this.showRescheduleSection();
        }
        else{
            this.isRescheduling = false;
            this.showSaveWorkOrder();
        }
        this.isLoading = false;
    }

    /*
    * Call apex to create Work Order and Service Appointment
    */
    async createWorkOrderAndSAJS(){
        this.isLoading = true;
        this.selectedWorkOrderId = await createWorkOrder({oppoId: this.opportunityId});
        if(this.selectedWorkOrderId == 'oppo_fields_error'){
            this.showToast('Mandatory Opportunity field(s) missing!','Check Installation Address, Installation Duration and Delivery Date', 'Warning');
            this.isLoading = false;
        }
        else if(this.selectedWorkOrderId == 'location_error'){
            this.showToast('Location unavailable!',"You don't have access to the Location record, please contact support!", 'Warning');
            this.isLoading = false;
        }
        else if(this.selectedWorkOrderId == 'oppo_error'){
            this.showToast('Opportunity unavailable!',"You don't have access to the Opportunity record, please contact support!", 'Warning');
            this.isLoading = false;
        }
        else if(this.selectedWorkOrderId == 'account_error'){
            this.showToast('Account unavailable!',"You don't have access to the Account record, please contact support!", 'Warning');
            this.isLoading = false;
        }
        else if(this.selectedWorkOrderId.includes('main_error')){
            this.showToast('Error','Error when creating Work Order, please contact Support!', 'Error');
            //console.log(this.selectedWorkOrderId);
            this.isLoading = false;
        }
        else if(this.selectedWorkOrderId){
            this.workOrders = await getWorkOrders({oppoId: this.opportunityId});
            this.workOrders = this.workOrders.map((elem) => {
                const self = this;
                return {
                    ...elem,
                    get findSA() {
                        if(this.ServiceAppointmentCount > 0){
                            return true;
                        }
                        return false;
                    }
                };
            });
            this.showToast('Success','This Work Order was created successfully', 'success');
            this.fetchWOForSaveJS();
        }
    }

    /*
    * Call apex to save Work Order and Service Appointment
    */
    async saveSAJS(){
        this.isLoading = true;
        const saveOK = await saveSA({saId:this.selectedSAId, duration: this.durationValue, estValue: this.ESTValue, dueDate: this.dueDateValue, woId: this.selectedWorkOrderId, workOrderSubject: this.workOrderSubjectValue, amountOfInstallers: this.amountOfInstallers});
        this.showToast('Success','This Work Order was saved successfully', 'success');
        this.isLoading = false;
    }

    /*
    * Call apex to book the Appointment
    */
    async handleBook() {
		this.isLoading = true;
		try {
			const bookStatus = await scheduleExtended({ serviceId: this.selectedSAId });
            if(!await getAppointmentDependency({ saId: this.selectedSAId }) || await isSAMultiDayWork({saId: this.selectedSAId})){
                if(bookStatus == 'success'){
                    this.showToast('Success','This Appointment was booked successfully', 'success');
                }
                else if(bookStatus == 'time_not_available'){
                    this.showToast('Slots not available','Slots for the reserve are not available!', 'error');
                }
                else if(bookStatus == 'general_error'){
                    this.showToast('Error','Error when scheduling this Appointment, contact support!', 'error');
                }
                //console.log(bookStatus);
                //Init the view
                this.fetchWOForSaveJS();
                this.isLoading = false;
            }
            else{
                //console.log('Wait for listener message, starting Timer for 30 seconds.');
                this.waitingListener = true;
                setTimeout(() => {
                    //console.log("Timer ended");
                    if(this.waitingListener){
                        this.isLoading = false;
                        this.waitingListener = false;
                        this.showToast('Error','Error when scheduling this Appointment, contact support!', 'error');
                    }
                }, 30000)
            }    
		} catch (error) {
            this.showToast('Error','Error when scheduling this Appointment, contact support!', 'error');
            //Init the view
            this.fetchWOForSaveJS();
            this.isLoading = false;
		}
	}

    /*
    * Call apex to cancel the Appointment
    */
    async cancelBookingJS() {
		this.isLoading = true;
        const cancelOK = await cancelBooking({saId:this.selectedSAId});
        this.fetchWOForSaveJS();
        if(cancelOK){
            this.showToast('Success','The Appointment was canceled successfully', 'success');
        }
        else{
            this.showToast('Error','The Appointment cancellation failed!', 'error');
        }
        this.isLoading = false;
	}

    /*
    * Handle WorkOrder delete
    */
    async handleDeletePrompt(event) {
        var woid = event.currentTarget.dataset.woid;
        const result = await LightningConfirm.open({
            message: 'Do you really want to delete this Work Order?',
            label: 'Delete Work Order',
        });
        if(result){
            this.isLoading = true;
            const deleteOK = await deleteWorkOrder({woId: woid});
            if(deleteOK.includes('true')){
                this.showToast('Success','The Work Order was deleted successfully', 'success');
                this.getWorkOrderJS();
            }
            else{
                this.showToast('Error','The Work Order delete failed!', 'error');
                this.isLoading = false;
            }
        }
    }

    /********* Helper methods *************/

    /*
    * Show proper view when coming back from slot view
    */
    backFromBookViewSection() {
        this.fetchWOForSaveJS();
        if(isRescheduling){
            this.showRescheduleSection();
        }
        this.showSaveWorkOrder();
    }

    /*
    * Show toast message
    */
    showToast(title, message, type) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: type
        });
        this.dispatchEvent(event);
    }

    /*
    * Open WorkOrder record page
    */
    viewWORecord(event) {
        // Navigate to Work Order record page
        this[NavigationMixin.GenerateUrl]({
            type: "standard__recordPage",
            attributes: {
                recordId: event.currentTarget.dataset.woid,
                objectApiName: 'WorkOrder',
                actionName: 'view'
            }
        }).then(url => {
            window.open(url, "_blank");
        });
    }

    /********* Value change methods *************/

	changeDurationValue(event) {
		this.durationValue = event.target.value;
	}

    changeESTValue(event) {
        if((new Date(event.target.value) < new Date(this.estLimitValue)) && !this.isAdminUser){
            this.estNotValid = true;
        }
        else{
            this.estNotValid = false;
		    this.ESTValue = event.target.value;
        }
	}

    changeDueDateValue(event) {
		this.dueDateValue = event.target.value;
	}

    changeWOSubjectValue(event) {
		this.workOrderSubjectValue = event.target.value;
	}

    changeAOIValue(event) {
		this.amountOfInstallers = Number(event.target.value);
	}

    /********* Show/Hide methods *************/

    showWOList(){
        this.show_wo_list_section = true;
        this.show_save_wo_section = false;
        this.show_reschedule_section = false;
        this.showBookViewSection = false;
    }

    showSaveWorkOrder(){
        this.show_wo_list_section = false;
        this.show_save_wo_section = true;
        this.show_reschedule_section = false;
        this.showBookViewSection = false;
    }

    showRescheduleSection(){
        this.show_wo_list_section = false;
        this.show_save_wo_section = false;
        this.show_reschedule_section = true;
        this.showBookViewSection = false;
    }

    showBookingSection(){
        this.show_wo_list_section = false;
        this.show_save_wo_section = false;
        this.show_reschedule_section = false;
        this.showBookViewSection = true;
    }

    /******* Slot view method ********/

    /*
	 * Update Service Appointment with selected slot
	 */
	async handleSlotSelect(event) {
		this.isLoading = true;
		try {
			const slotClicked = this.slotsOptions.find((slot) => slot.id === event.detail.id);
			await updateServiceAppointments({
				serviceAppointmentId: this.selectedSAId,
				startTime: slotClicked.start,
				endTime: slotClicked.finish
			});
			this.isBookedShown = false;
			this.isSaveSelectedSlotShown = true;
			this.selectedTimeSlot = slotClicked;
		} catch (error) {
			this.showToast('Error','Error when selecting available slot, please contact Support!', 'Error');
			console.error('Error selecting slot: ', error);
		}
		this.isLoading = false;
	}

	/*
	 * Get available slots or show error message
	 */
	async handleLoadSlots() {
		this.isLoading = true;
		try {
			const returnMap = await getAvailableSlotsMap({ saId: this.selectedSAId });
            //in case of dependency wait for the listener message instead
            if(!await getAppointmentDependency({ saId: this.selectedSAId }) || await isSAMultiDayWork({saId: this.selectedSAId})){
                for(var key in returnMap){
                    //create slots when success
                    if(key == 'success'){
                        this.slotsOptions = returnMap[key];
                        const newSlotsOptions = returnMap[key].map((item) => ({
                            ...item,
                            id: item.id,
                            label: item.grade,
                            grade: item.grade,
                            day: item.dayString,
                            month: item.monthString,
                            year: item.yearString,
                            dayOfMonth: item.dayOfMonth,
                            date: item.startDateString,
                            startTime: item.startTimeString,
                            endTime: item.endTimeString,
                            status: '',
                            startTimeForSort: item.startTimeString.replace(':',''),
                        }));
                        //Sort by starttime
                        const newSlotsOptionsSorted = newSlotsOptions.sort((a, b) => parseFloat(a.startTimeForSort) - parseFloat(b.startTimeForSort));
                        const groupByCategory = newSlotsOptionsSorted.reduce(
                            (acc, slot) => ({
                                ...acc,
                                [parseInt(slot.dayOfMonth)]: [...(acc[parseInt(slot.dayOfMonth)] ?? []), slot]
                            }),
                            {}
                        );
                        this.listOfSlots = Object.entries(groupByCategory).map(([dayOfMonth, slotsGroup]) => ({
                            dayOfMonth,
                            slotsGroup,
                            slotDateString: `${slotsGroup?.[0].day}, ${slotsGroup?.[0].month}  ${slotsGroup?.[0].dayOfMonth}, ${slotsGroup?.[0].year}`,
                            month: parseInt(slotsGroup?.[0].startDateString.substring(3, 5))
                        }));
                        this.listOfSlots.sort((a, b) => a.month - b.month || a.dayOfMonth - b.dayOfMonth);
                    }

                    //check failure messages
                    if(key == 'sc_missing'){
                        this.showToast('Missing data','Shceduling Calendar missing!', 'Warning');
                    }

                    if(key == 'check_st_access'){
                        this.showToast('Missing data','Service Territory not available!', 'Warning');
                    }

                    if(key == 'st_missing_from_sa'){
                        this.showToast('Missing data','Service Territory missing from Service Appointment!', 'Warning');
                    }

                    if(key == 'sa_missing'){
                        this.showToast('Missing data','Service Appointment missing from Work Order!', 'Warning');
                    }

                    if(key == 'general_error'){
                        this.showToast('Error','Error when checking available slots, please contact Support!', 'Error');
                    }
                }
                this.isLoaded = true;
                this.isLoading = false;
            } 
            else{
                this.waitingListener = true;
                //console.log('WaitingForListenerData, Starting Timer for 15 seconds.');
                setTimeout(() => {
                    //console.log("Timer ended");
                    if(this.waitingListener){
                        this.isLoading = false;
                        this.waitingListener = false;
                        this.showToast('Error','Error when checking available slots, please contact Support!', 'Error');
                    }
                }, 15000)
            }   
		} catch (error) {
			console.error(error);
			this.showToast('Error','Error when checking available slots, please contact Support!', 'Error');
            this.isLoading = false;
		}
	}

    /******* Streaming API **********/

    channelName = '/topic/MstCompletedChannel';
    isSubscribeDisabled = false;
    isUnsubscribeDisabled = !this.isSubscribeDisabled;
    alreadySubscribed = false;

    subscription = {};

    // Tracks changes to channelName text field
    handleChannelName(event) {
        this.channelName = event.target.value;
    }

    // Initializes the component
    connectedCallback() {
        // Register error listener
        this.registerErrorListener();
    }

    // Handles subscribe button click
    handleSubscribe() {
        if(!this.alreadySubscribed){
            // Callback invoked whenever a new event message is received
            let messageCallback = async function (message) {

                try{
                    //console.log('New message received: ', JSON.stringify(message));
                    // not relevant - deleted event
                    if (message.data.event.type === 'updated') {
                        if(this.selectedSAId === message.data.sobject.FSL__Initiator__c){
                            this.waitingListener = false;
                            const returnMap = await getDualSASlotsMap({operationId: message.data.sobject.Id});
                            console.log('returnMap:'+JSON.stringify(returnMap));
                            for(var key in returnMap){
                                //create slots when success
                                if(key == 'success'){
                                    this.slotsOptions = returnMap[key];
                                    const newSlotsOptions = returnMap[key].map((item) => ({
                                        ...item,
                                        id: item.id,
                                        label: item.grade,
                                        grade: item.grade,
                                        day: item.dayString,
                                        month: item.monthString,
                                        year: item.yearString,
                                        dayOfMonth: item.dayOfMonth,
                                        date: item.startDateString,
                                        startTime: item.startTimeString,
                                        endTime: item.endTimeString,
                                        status: '',
                                    }));
                                    const groupByCategory = newSlotsOptions.reduce(
                                        (acc, slot) => ({
                                            ...acc,
                                            [parseInt(slot.dayOfMonth)]: [...(acc[parseInt(slot.dayOfMonth)] ?? []), slot]
                                        }),
                                        {}
                                    );
                                    this.listOfSlots = Object.entries(groupByCategory).map(([dayOfMonth, slotsGroup]) => ({
                                        dayOfMonth,
                                        slotsGroup,
                                        slotDateString: `${slotsGroup?.[0].day}, ${slotsGroup?.[0].month}  ${slotsGroup?.[0].dayOfMonth}, ${slotsGroup?.[0].year}`,
                                        month: parseInt(slotsGroup?.[0].startDateString.substring(3, 5))
                                    }));
                                    this.listOfSlots = this.listOfSlots.sort((a, b) => a.month - b.month || a.dayOfMonth - b.dayOfMonth);
                                    this.isLoaded = true;
                                    this.isLoading = false;    
                                }

                                //in case of schedule messages
                                if(key == 'scheduling_message'){
                                    if(await getSAScheduled({ saId: this.selectedSAId })){
                                        this.showToast('Success','This Appointment was booked successfully', 'success');
                                    }else{
                                        this.showToast('Error','Error when scheduling this Appointment, contact support!', 'error');
                                    }
                                    //Init the view
                                    this.fetchWOForSaveJS();
                                    this.isLoading = false;    
                                }

                                //check failure messages
                                if(key == 'general_error'){
                                    this.showToast('Error','Error when checking available slots, please contact Support!', 'Error');
                                    this.isLoading = false;    
                                }
                            }    
                        }
                        else{
                            //console.log("ServiceAppointment Ids didn't match, still listening!");
                        }
                    }
                }
                catch(error){
                    this.showToast('Error','Error when checking available slots, please contact Support!', 'Error');
                    this.isLoading = false;
                }    
            };
            messageCallback = messageCallback.bind(this);

            // Invoke subscribe method of empApi. Pass reference to messageCallback
            subscribe(this.channelName, -1, messageCallback).then((response) => {
                // Response contains the subscription information on subscribe call
                //console.log('Subscription request sent to: ', JSON.stringify(response.channel));
                this.subscription = response;
                this.alreadySubscribed = true;
                this.toggleSubscribeButton(true);
            });
        }    
    }

    toggleSubscribeButton(enableSubscribe) {
        this.isSubscribeDisabled = enableSubscribe;
        this.isUnsubscribeDisabled = !enableSubscribe;
    }

    registerErrorListener() {
        // Invoke onError empApi method
        onError((error) => {
            //console.log('Received error from server: ', JSON.stringify(error));
            // Error contains the server-side error
        });
    }
}