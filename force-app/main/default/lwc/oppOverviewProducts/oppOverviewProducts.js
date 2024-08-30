import {api, track,wire, LightningElement} from 'lwc';
import fetchOverviewProducts from '@salesforce/apex/OppOverviewProductsCtrl.fetchOverviewProducts';
import updateConfigurations from '@salesforce/apex/OppOverviewProductsCtrl.updateConfigurations';
import caseOpportunityId from '@salesforce/apex/OppOverviewProductsCtrl.caseOpportunityId';
import { getRecord } from 'lightning/uiRecordApi';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import OPPTY_OBJECT from '@salesforce/schema/Opportunity';
import CASE_OBJECT from '@salesforce/schema/Case';
import CURRENTUSERID from '@salesforce/user/Id';

import LOCALE from "@salesforce/i18n/locale";
import TIME_ZONE from '@salesforce/i18n/timeZone';
import { NavigationMixin } from "lightning/navigation";
import { showToast } from 'lightning/platformShowToastEvent';

export default class OppOverviewProducts extends NavigationMixin(LightningElement) {
    // Flexipage provides recordId and objectApiName
    @api recordId;
    @api objectApiName;
	userId = CURRENTUSERID;
	@api flexipageRegionWidth = 'CLASSIC';
    @api invoke() {
        console.log("*** recordId: "+this.recordId);
        console.log("*** objectApiName: "+this.objectApiName);
        console.log("*** currentUserId: "+this.userId);
    }
    @wire(getObjectInfo, { objectApiName: CASE_OBJECT })
    objectInfo;
	// If Case the only show this for Reclamation Case
    get recordTypeId() {
        // Returns a map of record type Ids
        const caseRecordTypes = this.objectInfo.data.recordTypeInfos;
        return Object.keys(caseRecordTypes).find(caseRecordType => caseRecordTypes[caseRecordType].name === 'Reclamation');
    }

	@wire(getRecord, {recordId: "$recordId", fields: "$fields"})
	currentRecordData;
	get fields() {
		if(this.objectApiName === "Opportunity") {
			return ["Opportunity.Terrain_Type__c", "Opportunity.Building_Height__c"];
		} else if(this.objectApiName === "Case") {
			return ["Case.Id"];
		}
		return [];
	}

	get displayNewButton() {
		if(this.objectApiName === "Opportunity") {
			return this.orderType !== "Reclamation";
		}else if(this.objectApiName === "Case") {
			return false;
		}
	}

	get disabledNewButton() {
		const fields = this.currentRecordData?.data?.fields;
		return !fields?.Building_Height__c.value || !fields?.Terrain_Type__c.value;
	}

	@api productColumns = [];
	@api productRows = [];
	orderType;
	productRowsOriginal = [];
    displaySpinner = true;
	displayTable = false;
	sectionPadding = 20;
	timeZone = TIME_ZONE;

	recordFieldsToUpdateMap = new Map();
	displayCheckBox;
    displaySaveButton;
	displayCancelButton;
	displayExpandButton;
	displayDeleteButton;
	displayCopyButton;
	get parentSectionPadding(){
		return 'padding-bottom: ' + this.sectionPadding + 'px';
	}
	connectedCallback() {
		this.fetchOverviewProducts();
	}
	async fetchOverviewProducts(){
		try{
			const productDataSTR = await fetchOverviewProducts({recordId : this.recordId});
			const pData = JSON.parse(productDataSTR);
			console.log('*** PRODUCT DATA ### ## # ', pData);
			if(pData.productColumns.length > 0){
				this.productColumns = pData.productColumns;
				this.productColumnsOriginal = JSON.parse(JSON.stringify(pData.productColumns));
			    //this.productRows = this.modifyProductRows(pData.productRows);
				this.productRows = pData.productRows;
				this.productRowsOriginal = JSON.parse(JSON.stringify(this.productRows));
			}
			this.orderType = pData.orderType;
			this.displayTable = pData.productColumns.length > 0;
		}catch(e){
			console.log('*** E #### ', e);
		}

		this.displaySpinner = false;
	}
	handleTableCellClick(event){
		this.sectionPadding = event.detail.padding;
	}
	handleOppProductFieldChange(event) {
		let fieldValue = event.detail.changedValue;
		let fieldId = event.detail.tableCellId;
		//let fieldType = event.detail.fieldType;
		for(let row of this.productRows) {
			for (let field of row.fields) {
				if(field.id === fieldId){
                    let apiName = field.apiName.split('.')[1]; // raw value eg: Configuration__r.Plan_Line__c
                    if(!this.recordFieldsToUpdateMap.has(row?.configurationId)){
                        this.recordFieldsToUpdateMap.set(row.configurationId, [{ SobjecType: 'Configuration__c' , Id : row.configurationId, [apiName] : fieldValue }]);
                    }else{
                        let updateFields = this.updateFieldsMap([...this.recordFieldsToUpdateMap.get(row.configurationId)], apiName, fieldValue);
                        this.recordFieldsToUpdateMap.set(row.configurationId, updateFields);
                    }
                    field.value = fieldValue;
					break;
				}
			}
		}
		console.log('MAP W FIELDS TO UPDATE ', this.recordFieldsToUpdateMap);
		console.log('UPDATED ROWS ', JSON.parse(JSON.stringify(this.productRows)));
        this.displaySaveButton = true;
	}
    updateFieldsMap(fields, apiName, value){
        let updatedFields = [];
        for(let field of fields){
            field[apiName] = value;
            updatedFields.push(field);
        }
        return updatedFields;
    }
    handleSaveUpdatedFields(){
        let recordsToUpdate = [];
        for(let [id, fields] of this.recordFieldsToUpdateMap.entries()){
            for(let field of fields){
                recordsToUpdate.push(field);
            }
        }
        if(recordsToUpdate.length > 0){
            this.sendRecordsForUpdate(recordsToUpdate);
        }
    }
    async sendRecordsForUpdate(recordsToUpdate){
        console.log('RECORDS TO UPDATE ', recordsToUpdate);
        try{
            const apexResult = await updateConfigurations({configurations  : recordsToUpdate});
            if(apexResult.status === 'success'){
                showToast( this,'Success', 'Configurations updated', 'success', 'dismissible');
            }else{
                showToast(this, 'Error Updating Configurations ' ,apexResult.errorMessage, 'error', 'dismissible');
            }
        }catch(e){
            console.log('ERROR saving data ', e);
        }
    }
	// Configuration Table Buttons and Actions
    /*onClickOpenVisualNewPlan() {
		console.log('*** Opening New Plan for ', this.recordId);
        const navConfig = {
            fieldType: 'standard__component',
            attributes: {
                componentName: 'c__VisualContainer'
            },
			state: {
				c__recId: this.recordId
			}
        };

	}
	onClickOpenVisualEditPlan() {
		console.log('*** Editing Plan for ',this.tableCell.value);
		const navConfig = {
			fieldType: 'standard__component',
			attributes: {
				componentName: 'c__VisualEditPlan'
			},
			state: {
				c__recId : this.tableCell.value
			}
		};
	}*/
	async onClickOpenVisualNewPlan(){
		let opportunityId = this.recordId;
		if(this.objectApiName === "Case") {
			opportunityId = await caseOpportunityId({recordId: this.recordId});
		}
		const navConfig = {
			type: "standard__component",
			attributes: {
				componentName: "c__VisualApp"
			},
			state: {
				c__recId: opportunityId
			}
		};

		//4. Invoke Naviate method
		this[NavigationMixin.GenerateUrl](navConfig).then(url => {
			window.open(url, "_blank");
		});
	}

	handleSortColumn(event){
		const clickedColumn = event.currentTarget.dataset.id;
		this.updateColumnsCss(clickedColumn);
		const sortDirection = this.getSortDirection(clickedColumn);
		this.sortProductData(clickedColumn, sortDirection);
	}
	getSortDirection(clickedColumn){
		for(let col of this.productColumns){
			if(col.apiName === clickedColumn){
				col.sortDirection = col.sortDirection === 'ASC' ? 'DESC' : 'ASC';
				return col.sortDirection;
			}
		}
	}
	updateColumnsCss(clickedColumn){
		for(let col of this.productColumns){
			col.cssClass = col.apiName === clickedColumn ? 'table-header ' + col.sortDirection.toLowerCase() : 'table-header';
		}
	}
	// TODO Check sort logic
	sortProductData(columnApiToSort, sortDirection) {
		const fieldsToSort = this.getAllFieldsFromProductRows(columnApiToSort);
		const sortedFields = this.sortColumnFields(fieldsToSort, sortDirection);
		const sortedRowIds = sortedFields.map(field => field.rowId);
		this.productRows = this.sortRows(sortedRowIds, sortDirection);
		console.log('SORTED ROWS ', JSON.parse(JSON.stringify(this.productRows)));
	}
	getAllFieldsFromProductRows(columnApiToSort){
		let fieldsToSort = [];
		for(let row of this.productRows){
			for(let field of row.fields){
				field.rowId = row.rowId;
				if(field.apiName === columnApiToSort){
					fieldsToSort.push(field);
				}
			}
		}
		return fieldsToSort;
	}
	sortRows(sortedRowIds){
		return [...this.productRows].sort((a, b) => {
			const aIndex = sortedRowIds.indexOf(a.rowId);
			const bIndex = sortedRowIds.indexOf(b.rowId);
			return aIndex - bIndex;
		});
	}
	sortColumnFields(arr, direction){
		if(direction === 'ASC'){
			return arr.sort((a, b) => (a.value > b.value) ? 1 : -1);
		}else{
			return arr.sort((a, b) => (a.value > b.value) ? -1 : 1);
		}
	}



    // extended functionality to be done in next phase
    formatDate(dateSTR){
        const options = {
            year: "numeric",
            month: "short",
            day: "numeric",
        };
        const date = new Date(dateSTR);
        return new Intl.DateTimeFormat(LOCALE, options).format(date);
    }
    formatDateTime(dateTimeSTR) {
        const date = new Date(dateTimeSTR);
        return date.toLocaleString(LOCALE, { timeZone: TIME_ZONE });
    }
    /*modifyProductRows(productRows){
        let productRowsClone = [...productRows];
        for(let row of productRowsClone){
            for(let field of row.fields){
                if(field.type === 'DATE' && field.value){
                    field.value = this.formatDate(field.value)
                }
                if(field.type === 'DATETIME' && field.value){
                    field.value = this.formatDateTime(field.value);
                }
                if(field.apiName === 'Product__r.Name'){
                    field.productId = row.productId;
                }
            }
        }
        return productRowsClone;
    }*/
    handleSelectAllProducts(){

    }
    getFormattedValue(fieldType, fieldValue){
        if(fieldType === 'DATE'){
            return this.formatDate(fieldValue);
        }
        if(fieldType === 'DATETIME'){
            return this.formatDateTime(fieldValue);
        }
        return fieldValue;
    }
    // Filter table columns, expand fullscreen view and delete functionality
    /*
    handleFilterTableColumn(event){
		const filterApiName = event.currentTarget.dataset.id;
		let isFilterOn = event.target.checked;
		this.updateFilteredTable(isFilterOn, filterApiName);
	}
	updateFilteredTable(isFilterOn, filterApiName){
		this.updateTableHeaderColumns(isFilterOn, filterApiName)
		this.updateTableRows(isFilterOn, filterApiName)
	}

	updateTableHeaderColumns(isFilterOn, filterApiName){
		if(!isFilterOn){
			this.productColumns = [...this.productColumns].filter(column => column.apiName !== filterApiName);
		}else {
			const columnIndex = this.productColumnsOriginal.findIndex(column => column.apiName === filterApiName);
			const restoredColumn = this.productColumnsOriginal.find(column => column.apiName === filterApiName);
			this.productColumns = [...this.productColumns].splice(columnIndex, 0, restoredColumn);
		}
	}
	updateTableRows(isFilterOn, filterApiName){
		let productRowsCopy = JSON.parse(JSON.stringify(this.productRows));
		let updatedRows = [];
		for(let i = 0; i < productRowsCopy.length; i++){
			let updatedFields = productRowsCopy[i].fields;
			if(!isFilterOn){
				updatedFields = updatedFields.filter(field => filterApiName !== field.apiName);
			}else{
				let restoredField = this.restoreField(filterApiName, productRowsCopy[i].rowId);
				console.log('rESTRORED F ', restoredField);
				let columnIndex = this.productRowsOriginal[i].fields.findIndex(field => field.apiName === filterApiName);
				console.log('columnIndex F ', columnIndex);
				updatedFields.splice(columnIndex, 0, restoredField);
				console.log('UPDATED FIEDS ', updatedFields);
			}
			updatedRows.push({
				fields : updatedFields,
				productId : productRowsCopy[i].productId,
				rowId : productRowsCopy[i].rowId
			});
		}
		console.log('prod ROW UPDATED ', updatedRows);
		this.productRows = updatedRows;
	}
	restoreField(filterApiName, rowId){
		for(let row of this.productRowsOriginal){
			if(row.rowId === rowId){
				return row.fields.find(field => field.apiName === filterApiName);
			}

		}
	}
	isModalOpened = false;
	handleViewTableModal(){
		this.isModalOpened = true;
	}
	handleModalClose(){
		this.isModalOpened = false;
	}
	handleActionBtnClick(event){
		let btnClicked = event.currentTarget.dataset.id;
		if(btnClicked === 'filter'){
			this.template.querySelector('[data-id="filters"]').classList.toggle('expand');
		}
	}*/
}