import {LightningElement, wire} from 'lwc';
import {getRecord, updateRecord} from 'lightning/uiRecordApi';
import USER_ID from '@salesforce/user/Id';
import USER_CONTACT_ID from '@salesforce/schema/User.ContactId';
import fetchMyOrders from '@salesforce/apex/LP_MainController.fetchMyOrders';
import {ongoingShipmentLabels, errorLabels} from "c/lpLabels";
import { fireEvent } from 'c/lpPubSub';
import {showToast, reduceErrors} from "c/lpUtils";

export default class LpMyOrders extends LightningElement{

	orderLabels = ongoingShipmentLabels;
	errorLabels = errorLabels;

	userId = USER_ID;
	myOrders = [];

	contactId = null;
	displaySpinner = true;
	activeOrderId = null;

	@wire(getRecord, { recordId: '$userId', fields: [USER_CONTACT_ID]})
	userDetails({error, data}){
		if(data){
			this.contactId = data.fields.ContactId.value;
			this.fetchMyOrders();
		}else if(error){
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

	async fetchMyOrders(){
		try{
			const myOrderSTR = await fetchMyOrders({contactId : this.contactId});
			this.myOrders = JSON.parse(myOrderSTR);
		}catch(e){
			console.log('ERROR fetchMyOrders ## ', reduceErrors(e));
			showToast(
				this,
				this.errorLabels.errorTitle,
				this.errorLabels.errorMessage,
				'error',
				'dismissible'
			);
		}
		this.displaySpinner = false;
	}

	handleOrderOnActiveTab(event){
		const activeOrderData = this.getOrderData(event.currentTarget.dataset.id);
		this.activeOrderId = activeOrderData.orderId;
		this.sendDataToDependentComponents(JSON.stringify(activeOrderData));
		this.updateUserOrderField();
	}

	getOrderData(orderId){
		for(let myOrder of this.myOrders){
			if(myOrder.orderId === orderId){
				return myOrder;
			}
		}
		return null;
	}

	sendDataToDependentComponents(orderInfoSTR) {
		fireEvent('selectedOrder', orderInfoSTR);
	}

	updateUserOrderField() {
		const fields = {};
		fields['Id'] = this.userId;
		fields['myLumonPortal_OrderNumber__c'] = this.activeOrderId;
		const recordInput = { fields };
		updateRecord(recordInput)
        .then()
        .catch();
	}

	toggleDynamicContent(event){
		let myOrdersCopy = [...this.myOrders];
		for(let myOrder of myOrdersCopy){
			if(myOrder.orderId === event.currentTarget.dataset.id){
				myOrder.dynamicContentCss = myOrder.dynamicContentCss.includes('hide') ?
					'os-dynamic-content' :
					'os-dynamic-content hide';
				myOrder.toggleButtonCss = myOrder.toggleButtonCss.includes('minimized') ?
					'toggle-content-button' :
					'toggle-content-button minimized';
				break;
			}
		}
		this.myOrders = myOrdersCopy;
	}
}