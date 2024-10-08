import { LightningElement, api, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { refreshApex } from '@salesforce/apex';
import { loadStyle } from 'lightning/platformResourceLoader';
import { getRecord, notifyRecordUpdateAvailable } from 'lightning/uiRecordApi';
import { getObjectInfos } from 'lightning/uiObjectInfoApi';
import { subscribe, unsubscribe } from 'lightning/empApi';
import LightningConfirm from 'lightning/confirm';
import CASE_OBJECT from '@salesforce/schema/Case';
import OPPORTUNITY_OBJECT from '@salesforce/schema/Opportunity';
import QUOTE_OBJECT from '@salesforce/schema/Quote';

import customComponentResources from '@salesforce/resourceUrl/CustomComponentResources';
import getComponentData from '@salesforce/apex/OfferContentController.getComponentData';
import caseOpportunityId from '@salesforce/apex/OfferContentController.caseOpportunityId';
import deleteConfigurationProducts from '@salesforce/apex/OfferContentController.deleteConfigurationProducts';


//import addManuallySpecialItems from '@salesforce/apex/OfferContentController.addManuallySpecialItems';
//import removeManuallyAddedSpecialItems from '@salesforce/apex/OfferContentController.removeManuallyAddedSpecialItems';

import cloneConfigurationPlan from '@salesforce/apex/CloneConfigurationController.cloneConfigurationPlan';
import cloneVisualConfigurations from '@salesforce/apex/CloneConfigurationController.cloneVisualConfigurations';


import { reduceErrors, showToast, asyncCall } from 'c/lwcUtils';


const SORT_ORDER_ASC = 'ASC';
const SORT_ORDER_DESC = 'DESC';
import DisplayScreenFlow from 'c/displayScreenFlow';

export default class OfferContent extends NavigationMixin(LightningElement) {
    @api recordId;
    @api flexipageRegionWidth;
    @api compWidth;

    channelName = '/event/ConfigurationEvent__e';
    subscription = {};

    initialized = false;
    keyField = 'id';
    columns = [];
    cssResourcePath = customComponentResources + '/datatable.css';
    //componentStyles = customComponentResources + '/components.css';
    //buttonStyles = customComponentResources + '/buttons.css';
    //tableStyles= customComponentResources + '/datatable.css';
    sortBy;
    sortOrder = SORT_ORDER_DESC;
    processing = false;
    tableData = [];
    displayCheckBox;
    displaySaveButton;
    displayCancelButton;
    displayExpandButton;
    opportunity;
    showNewPlanModal = false;
    showCloneModal = false;
    cloneToNewPlan = false;
    currentRecordData = {};
    objectApiName = 'Opportunity';
    reclamationOrderError;
    fullScreen = false;    
    tableClass = 'custom-table'




    objectInfos = {};
    @wire(getObjectInfos, { objectApiNames: [OPPORTUNITY_OBJECT, CASE_OBJECT, QUOTE_OBJECT] })
    wiredObjectInfos(response) {
        this.objectInfos = response; 
    }

    @wire(getRecord, { recordId: '$recordId', fields: '$fields' })
    async wiredRecord({ data, error }) {
        if (data) {
            this.currentRecordData = { data };
            console.log('this.currentRecordData', this.currentRecordData)
            await this.init();
        } else if (error) {
            showToast(this, 'Could not load the opportunity', reduceErrors(error), 'error');
        }
    }

    connectedCallback(){
        this.setCompWidth();   
        window.addEventListener('resize', ()=> this.setCompWidth());
          }
     

    async handleRefresh() {
        await this.init();
    }
   
    
    setCompWidth(){
        let containerElem = this.template.querySelector(".main");
    
        if(containerElem){
            this.compWidth = containerElem.offsetWidth;   
    
        }
    }

    // Handle Button Click Events
    handleButtonClick(event){
        const attributes = event.attributes;
        console.log('--- attributes: '+attributes);

    }
    handleRefresh(){
            refreshApex(this.componentData);
    }
    
    
    // Other Things
    get configureStage(){
        return this.currentRecordData?.data?.fields?.StageName?.value === 'Quoting'

    }

    get fields() {
        const recordId = this.recordId;
        const objectInfo = this.objectInfos.data.results.find(result => result.result.keyPrefix === recordId.substring(0, 3)).result;
        this.objectApiName = objectInfo.apiName;
        if (objectInfo.apiName === 'Opportunity') {
            return [
                'Opportunity.Id',
                'Opportunity.Order_type__c',
                'Opportunity.Count_Opportunity_Products__c',
                'Opportunity.CurrencyIsoCode',
                'Opportunity.StageName',
                'Opportunity.Building__r.Structural_Analysis__r.Terrain_Type__c',
                'Opportunity.Building__r.Structural_Analysis__r.Building_Height__c',
                'Opportunity.Building__r.Structural_Analysis__r.Wind_Pressure__c',
                'Opportunity.Building__r.Structural_Analysis__r.Wind_Speed__c',
            ];
        } else if (objectInfo.apiName === 'Case') {
            return [
                'Case.Id',
                'Case.Type',
                'Case.Reclamation__c',
                'Case.Reclamation__r.CurrencyIsoCode',
                'Case.Reclamation__r.StageName',
                'Case.Reclamation__r.Building__r.Structural_Analysis__r.Terrain_Type__c',
                'Case.Reclamation__r.Building__r.Structural_Analysis__r.Building_Height__c',
                'Case.Reclamation__r.Building__r.Structural_Analysis__r.Wind_Pressure__c',
                'Case.Reclamation__r.Building__r.Structural_Analysis__r.Wind_Speed__c',
            ];
        }
        return [];
    }

    _displayDeleteButton() {
        return this.currentRecordData?.data?.fields?.StageName?.value === 'Quoting';
    }
    get displayDeleteButton() {
        return this._displayDeleteButton();
    }
    get disableDeleteButton() {
        return !this.tableData.some((item) => item.selected);
    }

    _displayCloneButton() {
        return this.currentRecordData?.data?.fields?.StageName?.value === 'Quoting';
    }
    get displayCloneButton() {
        return this._displayCloneButton();
    }
    get disableCloneButton() {
        return !this.tableData.some((item) => item.selected);
    }
    _displayValidateButton() {
        return this.currentRecordData?.data?.fields?.StageName?.value === 'Quoting';
    }
    get displayValidateButton() {
        return this._displayValidateButton();
    }
    _displayMessageButton() {
        return this.currentRecordData?.data?.fields?.StageName?.value === 'Quoting';
    }
    get displayMessageButton() {
        return this._displayMessageButton();
    }
    get disableMessageButton() {
        return !this.tableData.some((item) => item.selected);
    }

    get disabledAddBlinds() {
        return false;
    }
    get displayAddBlinds() {
        if (this.objectApiName === 'Opportunity') {
            return this.currentRecordData?.data?.fields?.Order_type__c?.value !== 'Reclamation';
        }
        return false;
    }

    get disabledAddSoveliaPlan() {
        return false;
    }
    get displayAddSoveliaPlan() {
        if (this.objectApiName === 'Opportunity') {
            return this.currentRecordData?.data?.fields?.Order_type__c?.value !== 'Reclamation';
        }
        return false;
    }
    // Temporary fix to conditionally display new button
    get displayAddPlan() {
        if (this.objectApiName === 'Opportunity') {
            return this.currentRecordData?.data?.fields?.Order_type__c?.value !== 'Reclamation';
        }
        return false;
    }

    get disabledAddPlan() {
        let fields = null;
        if (this.objectApiName === 'Opportunity') {
            fields =
                this.currentRecordData?.data?.fields.Building__r?.value?.fields?.Structural_Analysis__r?.value?.fields;
        } else if (this.objectApiName === 'Case' && this.currentRecordData?.data?.fields?.Type?.value === 'Reclamation order') {
            fields =
                this.currentRecordData?.data?.fields.Reclamation__r?.value?.fields?.Building__r?.value?.fields?.Structural_Analysis__r?.value?.fields;
        }

        // Logic is Height + Terrain Type + Wind Speed OR 
        return (
            (!fields?.Wind_Pressure__c?.value &&
            (!fields?.Terrain_Type__c?.value || !fields?.Building_Height__c?.value || !fields?.Wind_Speed__c?.value))
        );
    }

    get visible() {
        return this.objectInfos?.data && this.currentRecordData?.data;
    }
    /*get planData() {
        return data.configurationProducts.map((item) => ({
            configurationId: item.Configuration__r.Id,           
            planName: item.Configuration__r.Plan_Name__c,
            planLine: item.Configuration__r.Plan_Line__c,
            planFloor: item.Configuration__r.Plan_Floor__c,
            planType: item.Configuration__r.Plan_Type__c,
            planApartment: item.Configuration__r.Plan_Apartment__c,
        }));
    }
    get productData() {
        return data.configurationProducts.map((item) => ({
            id: item.Id,
            productId: !item.Configuration__r.Plan_Type__c === 'Extra Sales' ? item.Product__r?.Id : '',
            productName:
                item.Configuration__r.Plan_Type__c === 'Extra Sales'
                    ? item.Configuration__r.Plan_Type__c
                    : item.Product__r?.Name,
            rvn: item.RVN__c,                                    
            quantity: item.Quantity__c,
            status: item.Status__c,
            verification: item.Verification__c,
            functional: item.Verification_Status__c,
            special: item.Special__c, 
            manual:item.Manual_Processing__c,
            automatic: item.Manual_Processing__c ? false : true,
            selected: false,
        }));
    }*/

    renderedCallback() {
        Promise.all([
            loadStyle(this, this.componentStyles),
            loadStyle(this, this.buttonStyles),
            loadStyle(this, this.tableStyles),
        ])
        if (this.initialized || !this.recordId || !this.currentRecordData?.data || !this.objectInfos?.data) return;
        this.initialized = true;
        this.subscribeToConfigurationEvent();
        this.init();
    }

    disconnectedCallback() {
        this.unsubscribeToConfigurationEvent();
    }

    async subscribeToConfigurationEvent() {
        const response = await subscribe(this.channelName, -1, async ({ data, channel }) => {
            if (channel === this.channelName ) {
                console.log('--- configuration event - Type: '+data.payload.configType__c);
                console.log('--- configuration event - Action: '+data.payload.configAction__c);
                console.log('--- configuration event - Record: '+data.payload.recordId__c);
                if (data?.payload?.recordId__c === this.recordId &&
                    data?.payload?.configAction__c === 'Configure'
                ) { this.processing = true;}
                if (data?.payload?.recordId__c === this.recordId &&
                    data?.payload?.configType__c === 'Calculate' &&
                    data?.payload?.configAction__c === 'Price'
                ) {
                    console.log('--- configuration event - Configuration Updated');
                    if (!this.dirty) {
                        this.init();
                    } else if (
                        await LightningConfirm.open({
                            label: 'The configuration was updated',
                            message: 'Click OK to discard the changes and refresh the pricing summary component.',
                            variant: 'header'
                        })
                    ) {
                        this.init();
                    }
                }
            }
        });
        this.subscription = response;
    }

    unsubscribeToConfigurationEvent() {
        unsubscribe(this.subscription);
    }
    get deleteButtonLabel() {
        const selected = this.tableData.reduce((current, item) => (item.selected ? current + 1 : current), 0);
        return `Delete${selected ? ' (' + selected + ')' : ''}`;
    }

    get cloneButtonLabel() {
        const selected = this.tableData.reduce((current, item) => (item.selected ? current + 1 : current), 0);
        return `Clone${selected ? ' (' + selected + ')' : ''}`;
    }

    get specialButtonLabel() {
        const selected = this.tableData.reduce((current, item) => (item.selected ? current + 1 : current), 0);
        const special = this.tableData.filter((item) => item.selected && item.special);
        return special.length > 0 ? `Remove special${selected ? ' (' + selected + ')' : ''}`
            : `Set as special${selected ? ' (' + selected + ')' : ''}`;
    }
    
    toggleFullScreen() {
        this.fullScreen = !this.fullScreen;
    }

    async init() {
        if (this.customStylePath && !this.stylesLoaded) {
            await loadStyle(this, this.customStylePath);
            this.stylesLoaded = true;
        }
        await asyncCall(this, async () => {
            this.columns = [];
            if (this._displayDeleteButton()) {
                this.columns = [
                    {
                        label: '',
                        fieldName: 'selected',
                        type: 'checkbox',
                    },
                ];
            }
            this.columns = [
                ...this.columns,
                ...[
                    {
                        label: '',
                        fieldName: 'id',
                        type: 'icon',
                        class: 'clickable-icon',
                        cellAttributes: {
                            iconClass: 'slds-align_absolute-center',
                            iconName: (item) =>
                                ['Visual', 'Blinds','Sovelia'].includes(item.planType) || !item.planType
                                    ? 'utility:record_update'
                                    : '',
                            iconVariant:  '',
                            iconSize:  'x-small',
                        },
                    },
                    {
                        label: 'RVN Number',
                        fieldName: 'rvn',
                        type: 'text',
                        sortable: true,
                    },
                    {
                        label: 'Product',
                        fieldName: 'productName',
                        type: 'link',
                        sortable: true,
                    },
                    {
                        label: 'Quantity',
                        fieldName: 'quantity',
                        type: 'text',
                        sortable: true,
                    },
                    {
                        label: 'Name',
                        fieldName: 'planName',
                        type: 'text',
                        sortable: true,
                    },
                    {
                        label: 'Line',
                        fieldName: 'planLine',
                        type: 'text',
                        sortable: true,
                        inlineEdit: true,
                    },
                    {
                        label: 'Floor',
                        fieldName: 'planFloor',
                        type: 'text',
                        sortable: true,
                    },
                    {
                        label: 'Apartment',
                        fieldName: 'planApartment',
                        type: 'text',
                        sortable: true,
                        inlineEdit: true,
                    },
                    {
                        label: 'Verification',
                        fieldName: 'verification',
                        type: 'icon',
                        sortable: true,
                        class: 'slds-align_absolute-center',
                        cellAttributes: {
                            iconClass: 'slds-align_absolute-center',
                            iconName: (item) => {
                                return item.verification.includes('error')
                                    ? 'utility:error'
                                    : item.verification.includes('confirm')
                                    ? 'utility:check'
                                    : item.verification.includes('warning')
                                    ? 'utility:warning'
                                    : 'utility:question_mark';
                            },
                            iconVariant: (item) => {
                                return item.verification.includes('error')
                                    ? 'error'
                                    : item.verification.includes('confirm')
                                    ? 'success'
                                    : item.verification.includes('warning')
                                    ? 'warning'
                                    : '';
                            },
                            iconSize: 'x-small' // xx-small, x-small, small, medium, or large
                            
                        },
                    },
                    {
                        label: 'Automatic',
                        fieldName: 'automatic',
                        type: 'icon', 
                        class: 'clickable-icon',
                        cellAttributes: {
                            iconClass: 'slds-align_absolute-center',
                            iconName: (item) =>
                                (item.manual ? 'product_transfer_state' : 'cancel_transfer'),
                            iconVariant: (item) => 
                                (item.manual ? 'error' : 'success'),                           
                            iconSize: 'x-small' // xx-small, x-small, small, medium, or large
                        },
                    },
                    {
                        label: 'Status',
                        fieldName: 'status',
                        type: 'text',
                        sortable: true,
                    },
                    {
                        label: 'Installer Message',
                        fieldName: 'installerMessage',
                        type: 'icon',
                        class: 'clickable-icon',
                        cellAttributes: {
                            iconName: 'utility:edit_form',
                            iconClass: 'slds-align_absolute-center',
                            iconVariant:  '',
                            iconSize:  'x-small',
                        },
                    },
                ],
            ];
            console.log('--- Standard Columns: '+this.columns);
            // Add Additional Columns 
            this.modalColumns = [
                ...this.columns,
                ...[

                    {
                        label: 'Manual',
                        fieldName: 'manual',
                        type: 'icon',
                        sortable: true,
                         cellAttributes: {
                             class: 'slds-align_absolute-center',
                             iconName: (item) => (item.special ? 'utility:check' : ''),
                         }
                    },
                    {
                        label: 'Batch',
                        fieldName: 'batch',
                        type: 'text',
                        sortable: true,
                        inlineEdit: true,
                    },
                    //Additional delivery time	
                    //Delivery batch	
                    //Order	
                    //Preferred delivery date	
                    //Confirmed delivery date	
                    //Installation start date	
                    //Installation completed	
                ],
            ];

            try {
                this.reclamationOrderError = null;
                if(this.currentRecordData?.data?.fields?.Type?.value === 'Reclamation order'
                    && !this.currentRecordData?.data?.fields?.Reclamation__c?.value
                ) {
                    this.reclamationOrderError = 'A reclamation has not been created yet.';
                    return;
                }
                const data = await getComponentData({
                    recordId: this.recordId,
                });
                this.tableData = data.configurationProducts.map((item) => ({
                    id: item.Id,
                    configurationId: item.Configuration__r.Id,
                    rvn: item.RVN__c,
                    productId: !item.Configuration__r.Plan_Type__c === 'Extra Sales' ? item.Product__r?.Id : '',
                    productName:
                        item.Configuration__r.Plan_Type__c === 'Extra Sales'
                            ? item.Configuration__r.Plan_Type__c
                            : item.Product__r?.Name,
                    planName: item.Configuration__r.Plan_Name__c,
                    planLine: item.Configuration__r.Plan_Line__c,
                    planFloor: item.Configuration__r.Plan_Floor__c,
                    planType: item.Configuration__r.Plan_Type__c,
                    planApartment: item.Configuration__r.Plan_Apartment__c,
                    quantity: item.Quantity__c,
                    verification: item.Verification__c,
                    status: item.Status__c,     
                    functional: item.Verification_Status__c,
                    inspection: item.Inspection_Code__c,
                    measurement: item.Measurements_Verified__c,
                    features: item.Features_Confirmed__c,
                    special: item.Special__c, 
                    manual:item.Manual_Processing__c,
                    automatic: item.Manual_Processing__c ? false : true,
                    selected: false,
                }));
            } catch (e) {
                showToast(this, 'Error', reduceErrors(e), 'error');
            }
            this.processing = false;
            //this.componentStyles= customComponentResources + '/components.css';
            this.buttonStyles = customComponentResources + '/buttons.css';
            this.tableStyles= customComponentResources + '/datatable.css';
        });
    }


    async handleClickAddPlan(event) {
        event.preventDefault();
        let opportunityId = this.recordId;
        if (this.objectApiName === 'Case') {
            opportunityId = (await caseOpportunityId({ recordId: this.recordId })).Id;
        }
        this.openConfigurationPlan(opportunityId, 'Visual');
    }

    async handleClickAddBlinds(event) {
        event.preventDefault();
        //this.processing = true;
        let opportunityId = this.recordId;
        if (this.objectApiName === 'Case') {
            opportunityId = await caseOpportunityId({ recordId: this.recordId });
        }
        this.openConfigurationPlan(opportunityId, 'Blinds');
    }

    handleValueChange(event) {
        const eventData = event.detail;
        const item = this.tableData.find((o) => o.id === eventData.id);
        if (eventData.fieldName === 'selected') {
            item.selected = eventData.value;
            this.tableData = [...this.tableData];
        }
    }

    handleDoubleClick() {}

    async handleDelete() {
        await asyncCall(this, async () => {
            if (
                await LightningConfirm.open({
                    label: 'Confirm deletion',
                    message: 'Click OK to delete the configuration products and related configuration plans.',
                    variant: 'header',
                })
            ) {
                await deleteConfigurationProducts({
                    configurationProductIds: this.tableData.filter((item) => item.selected).map((item) => item.id),
                });
                await this.init();
                showToast(this, 'Deleted', 'Configurations deleted', 'success');
                refreshApex(this.currentRecordData);

                  
                notifyRecordUpdateAvailable([{ recordId: this.recordId }]);
            }
        });
    }

    async handleSpecial() {
        const special = this.tableData.find((item) => item.selected && item.special);
        await asyncCall(this, async () => {
            if (
                await LightningConfirm.open({
                    label: special ? 'Confirm removing special items'
                        : 'Confirm adding special items',
                    message: special ? 'Click OK to remove special items from selected RVN'
                        : 'Click OK to set selected RVN to special and adding additional special items to the configuration.',
                    variant: 'header',
                })
            ) {
                const ids = this.tableData.filter((item) => item.selected).map((item) => item.id);
                try {
                    if (special) {
                        await removeManuallyAddedSpecialItems({
                            configurationProductIds: ids,
                            opportunityId: this.recordId
                        });
                    } else {
                        await addManuallySpecialItems({
                            configurationProductIds: ids,
                            opportunityId: this.recordId
                        });
                    }
                    await this.init();
                } catch (e) {
                    showToast(this, 'Error', reduceErrors(e), 'error');
                }
                refreshApex(this.currentRecordData);
                notifyRecordUpdateAvailable([{recordId: this.recordId}]);
            }
        });
    }
    async handleRefresh() {
        await this.init();
    }
    handleClone() {
        this.showCloneModal = true;
    }

    handleOkPlan(event){
        this.showCloneModal = false;
    }
    
    handleCloneToNewPlan(event) {
        this.cloneToNewPlan = event.detail.checked;
    }

    async clonePlans(){
        if( 
            await LightningConfirm.open({
                label: 'Confirm clone',
                message: 'Click OK to clone the configuration products and related configuration plans.',
                variant: 'header',
            })
        ) {
            await asyncCall(this, async () => {
                const seletedConfigurationIds = this.tableData.filter((o) => o.selected).map((c) => c.configurationId);
                const clonedConfigurationIds = await cloneConfigurationPlan({
                    opportunityId: this.recordId,
                    configurationIds: seletedConfigurationIds,
                });
                await cloneVisualConfigurations({
                    opportunityId: this.recordId,
                    configurationPlanIds: clonedConfigurationIds,
                });
                await this.init();
                refreshApex(this.currentRecordData);
                notifyRecordUpdateAvailable([{ recordId: this.recordId }]);
                this.showCloneModal = false;
            });
        }
    }

    handleSort(event) {
        const fieldName = event.detail.fieldName;
        this.sortOrder =
            fieldName === this.sortBy && this.sortOrder === SORT_ORDER_ASC ? SORT_ORDER_DESC : SORT_ORDER_ASC;
        this.sortBy = fieldName;
        this.tableData = [...this.tableData];
    }

    async handleLinkClick(event) {
        const eventData = event.detail;
        const item = this.tableData.find((o) => o.id === eventData.id);
        if (eventData.fieldName === 'id') {
            this.openConfigurationPlan(item.planType === 'Blinds' ? item.id : item.configurationId, item.planType);
        } else if (eventData.fieldName === 'productName') {
            this.openLink(item.id, 'Configuration_Product__c');
        } else if (eventData.fieldName === 'installerMessage') {
            await DisplayScreenFlow.open({
                size: 'large',
                variables: [{
                    name: 'recordId',
                    type: 'String',
                    value: item.id,
                }],
                flowName: 'Opportunity_Edit_Installer_Message',
            });
        } else {
            console.log('>> offer content', eventData.fieldName);
        }
    }
    
    async handleInlineEdit(event) {
        await Promise.resolve();
        console.log(JSON.stringify(event.detail));
    }

    async openLink(recordId, sObjectName) {
        window.open(
            await this[NavigationMixin.GenerateUrl]({
                type: 'standard__recordPage',
                attributes: {
                    recordId,
                    objectApiName: sObjectName,
                    actionName: 'view',
                },
            }),
            '_blank'
        );
    }

    async openConfigurationPlan(recordId, planType) {
        const planTypes = {
            Visual: 'c__VisualApp',
            Blinds: 'c__SoveliaContainer',
        };
        window.open(
            await this[NavigationMixin.GenerateUrl]({
                type: 'standard__component',
                attributes: {
                    componentName: planTypes[planType] ? planTypes[planType] : planTypes.Visual,
                },
                state: {
                    c__recId: recordId,
                },
            }),
            '_blank'
        );
    }
    async handleConfigUpdates() {
        // Do something before the record is updated
        showSpinner();
  
        // Update the record via Apex
        await apexUpdateRecord(this.recordId);
  
        // Notify LDS that you've changed the record outside its mechanisms
        // Await the Promise object returned by notifyRecordUpdateAvailable()
        await notifyRecordUpdateAvailable([{recordId: this.recordId}]);
        hideSpinner();
      }
}