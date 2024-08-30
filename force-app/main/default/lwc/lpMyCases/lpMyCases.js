import {LightningElement, wire, track} from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import CASE_OBJECT from '@salesforce/schema/Case';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import fetchMyCases from '@salesforce/apex/LP_MainController.fetchMyCases';
import USER_ID from '@salesforce/user/Id';
import USER_CONTACT_ID from '@salesforce/schema/User.ContactId';
import {showToast, reduceErrors} from "c/lpUtils";
import {myCasesLabels, errorLabels} from "c/lpLabels";

export default class LpMyCases extends LightningElement {
	userId = USER_ID;
	cases = [];
	apiNameLabelMap = new Map();
	contactId = null;
	displaySpinner = false;
	displayDataTable;
	sortDirection;
	myCasesLabels = myCasesLabels;
	errorLabels = errorLabels;
	@track columns = [
		{ label: '', hideDefaultActions: true,  sortable: true, fieldName: 'CaseNumberURL', title: 'CaseNumber', type: 'url', typeAttributes:{label: { fieldName: 'CaseNumber' }} },
		{ label: '', hideDefaultActions: true,  sortable: true, fieldName: 'Subject', title: 'Subject' },
		{ label: '', hideDefaultActions: true,  sortable: true, fieldName: 'Status' },
		{ label: '', hideDefaultActions: true,  sortable: true, fieldName: 'Origin' },
		{ label: '', hideDefaultActions: true,  sortable: true, fieldName: 'CreatedDate',  type: "date",
			typeAttributes:{
				year: "numeric",
				month: "2-digit",
				day: "2-digit",
				hour: "2-digit",
				minute: "2-digit"
			}
		}
	];

	get dynamicStyle(){
		return this.cases.length > 7 ? 'height: 300px;margin-bottom: 25px;' : 'margin-bottom: 25px;'
	}

	@wire(getObjectInfo, { objectApiName: CASE_OBJECT })
	caseObj({ data }) {
		if(data){
			this.apiNameLabelMap.set('CaseNumberURL',data.fields.CaseNumber.label);
			this.apiNameLabelMap.set(data.fields.Subject.apiName,data.fields.Subject.label);
			this.apiNameLabelMap.set(data.fields.Status.apiName,data.fields.Status.label);
			this.apiNameLabelMap.set(data.fields.Origin.apiName,data.fields.Origin.label);
			this.apiNameLabelMap.set(data.fields.CreatedDate.apiName,data.fields.CreatedDate.label);
		}
	}

	@wire(getRecord, { recordId: '$userId', fields: [USER_CONTACT_ID]})
	userDetails({data}) {
		try{
			this.contactId = data.fields.ContactId.value;
			this.fetchMyCases();
		}catch (error){
			console.log('ERROR wired userDetails ## ', reduceErrors(error));
			showToast(
				this,
				this.errorLabels.errorTitle,
				this.errorLabels.errorMessage,
				'error',
				'dismissible'
			);
		}
	}

	async fetchMyCases(){
		try{
			const cases = await fetchMyCases({contactId : this.contactId});
			this.modifyColumns();
			this.cases = this.modifyDataForUI(cases);
		}catch(error){
			console.log('ERROR fetchMyCases ## ', reduceErrors(error));
			showToast(
				this,
				this.errorLabels.errorTitle,
				this.errorLabels.errorMessage,
				'error',
				'dismissible'
			);
		}
		this.displaySpinner = false;
		this.displayDataTable = this.cases.length > 0;
	}

	modifyColumns(){
		for(let column of this.columns){
			column.label = this.apiNameLabelMap.get(column.fieldName);
		}
	}

	modifyDataForUI(records){
		let modifiedData = [];
		for (let row of records) {
			const finalSobjectRow = {};
			let rowIndexes = Object.keys(row);
			rowIndexes.forEach((rowIndex) => {
				const relatedFieldValue = row[rowIndex];
				if(rowIndex === 'CaseNumber'){
					finalSobjectRow[rowIndex+'URL'] = '/case/' + row.Id + '/detail';
				}
				finalSobjectRow[rowIndex] = relatedFieldValue;
			});
			modifiedData.push(finalSobjectRow);
		}
		return modifiedData;
	}

	onHandleSort(event) {
		const { fieldName: sortedBy, sortDirection } = event.detail;
		const cloneData = [...this.data];
		cloneData.sort(this.sortBy(sortedBy, sortDirection === 'asc' ? 1 : -1));
		this.data = cloneData;
		this.sortDirection = sortDirection;
	}

	sortBy(field, reverse, primer) {
		const key = primer
			? function (x) {
				return primer(x[field]);
			}
			: function (x) {
				return x[field];
			};
		return function (a, b) {
			a = key(a);
			b = key(b);
			return reverse * ((a > b) - (b > a));
		};
	}
}