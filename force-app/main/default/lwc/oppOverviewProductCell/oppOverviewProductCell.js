/**
 * Created by Filip on 17. 2. 2023.
 */

import {LightningElement, api} from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
export default class OppOverviewProductCell extends NavigationMixin(LightningElement) {
	@api tableCell;
	@api hoveredCellId;
	@api timeZone;
	editModeEnabled;
	get displayEditIcon(){
		return (this.tableCell.apiName !== 'RowCheckBox' &&
				this.tableCell.isEditable &&
				this.tableCell.id === this.hoveredCellId
		);
	}

	get textCellCss(){
		return this.tableCell.apiName === 'Product__r.Name' ?  'slds-truncate cell-link' : 'slds-truncate';
	}
	get inputType() {
		switch (this.tableCell.type.toUpperCase()) {
			case "STRING":
				return "text";
			case "DOUBLE":
				return "number";
			case "PERCENT":
				return "number";
			case "DATETIME":
				return "datetime";
			case "DATE":
				return "date";
			case "BOOLEAN":
				return "checkbox";
			case "CURRENCY":
				return "number";
			default:
				return "text";
		}
	}
	get isPicklist(){
		return (this.tableCell.type.toUpperCase() === 'PICKLIST');
	}
	get isInput(){
		return (this.tableCell.type.toUpperCase() === 'STRING' ||
			this.tableCell.type.toUpperCase() === 'TEXT' ||
			this.tableCell.type.toUpperCase() === "DOUBLE" ||
			this.tableCell.type.toUpperCase() === "NUMBER" ||
			this.tableCell.type.toUpperCase() === "BOOLEAN" ||
			this.tableCell.type.toUpperCase() === "PERCENT" ||
			this.tableCell.type.toUpperCase() === "DATE" ||
			this.tableCell.type.toUpperCase() === "CURRENCY" ||
			this.tableCell.type.toUpperCase() === "DATETIME");
	}
	get isQuantityInput(){
		return (this.tableCell.type.toUpperCase() === "DOUBLE" &&
			this.tableCell.apiName === "Quantity");
	}
	get isRowCheckBox(){
		return (this.tableCell.type.toUpperCase() === "BOOLEAN" && this.tableCell.apiName === "RowCheckBox");
	}
	get isVerificationField(){
		return (this.tableCell.type === 'ICON' && this.tableCell.apiName === "Verification__c");
	}

	get isQuickActionField(){
		return (this.tableCell.type === 'QuickAction' && this.tableCell.apiName === 'EditPlanAction');
	}
	get isTextField(){
		return (this.tableCell.type.toUpperCase() === 'STRING' ||
			this.tableCell.type.toUpperCase() === 'TEXT' ||
			this.tableCell.type.toUpperCase() === 'PICKLIST' ||
			this.tableCell.type.toUpperCase() === 'TEXTAREA'
		);
	}
	get isDateField(){
		return (this.tableCell.type.toUpperCase() === 'DATE' ||
			this.tableCell.type.toUpperCase() === 'DATETIME');
	}
	get isURLField(){
		return (this.tableCell.type === 'URL');
	}
	get isCurrencyField(){
		return this.tableCell.type.toUpperCase() === "CURRENCY";
	}
	get isNumberField(){
		return (this.tableCell.type.toUpperCase() === "DOUBLE" ||
			this.tableCell.type.toUpperCase() === "NUMBER");
	}
	setEditMode(){
		this.editModeEnabled = !this.editModeEnabled;
		if(this.editModeEnabled){
			setTimeout(()=>this.template.querySelector('[data-id="focus-input"]').focus());
		}
	}
	setParentSectionPadding(){
		let sectionPadding = 20;
		if(this.tableCell.type.toUpperCase() === 'DATE' ||
			this.tableCell.type.toUpperCase() === 'DATETIME' ||
			this.tableCell.type.toUpperCase() === 'PICKLIST'){
			sectionPadding = 300;
		}
		this.sendSectionPaddingToParent(sectionPadding);
	}
	sendSectionPaddingToParent(padding){
		const paddEvent = new CustomEvent('table_cell_click', {
			detail: {
				padding : padding
			},
			bubbles : true,
			composed : true
		});
		this.dispatchEvent(paddEvent);
	}
	handleOnFieldBlur(){
		this.setEditMode();
		this.sendSectionPaddingToParent(50);
	}
	handleFieldChange(event){
		let changedValue = this.tableCell.type.toUpperCase() === 'BOOLEAN' ? event.target.checked : event.detail.value;
		//let fieldApi = event.target.dataset.name;
		const productEvent = new CustomEvent('product_field_change', {
			detail: {
				changedValue   : changedValue,
				changedField   : this.tableCell.apiName,
				tableCellId    : this.tableCell.id,
				fieldType      : this.tableCell.type
			},
			bubbles : true,
			composed : true
		});
		this.dispatchEvent(productEvent);
	}

	handleTableCellClick(){
		this[NavigationMixin.GenerateUrl]({
			type: 'standard__recordPage',
			attributes: {
				recordId: this.tableCell.id,
				objectApiName: 'Product2',
				actionName: 'view'
			}
		}).then(url => {
			window.open(url, "_blank");
		});
	}
	onClickOpenVisualEditPlan(){
		const navConfig = {
			type: "standard__component",
			attributes: {
				componentName: "c__VisualApp"
			},
			state: {
				c__recId : this.tableCell.value
			}
		};

		//4. Invoke Naviate method
		this[NavigationMixin.GenerateUrl](navConfig).then(url => {
			window.open(url, "_blank");
		});
	}

}