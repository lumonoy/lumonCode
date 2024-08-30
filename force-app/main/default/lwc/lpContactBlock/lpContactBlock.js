import {LightningElement} from 'lwc';
import fetchContactInformation from '@salesforce/apex/LP_MainController.fetchContactInformation';
import { registerListener, unregisterAllListeners } from 'c/lpPubSub';
import {contactLabels, errorLabels} from "c/lpLabels";
import { showToast} from "c/lpUtils";
import {reduceErrors} from "c/lpUtils";

export default class LpContactBlock extends LightningElement {

	contactLabels = contactLabels;
	errorLabels = errorLabels;

	orderId = null;
	contactPeople = [];

	connectedCallback(){
		registerListener('selectedOrder', this.displaySelectedOrder, this);
	}

	disconnectedCallback() {
		unregisterAllListeners(this);
	}

	displaySelectedOrder(orderInfo){
		this.orderId = JSON.parse(orderInfo).orderId;
		this.getContactInformation();
	}

	async getContactInformation(){
		try{
			const contactPeopleSTR = await fetchContactInformation({orderId : this.orderId});
			this.contactPeople = JSON.parse(contactPeopleSTR);
		}catch(e){
			console.log('ERROR getContactInformation ## ', reduceErrors(e));
			showToast(
				this,
				this.errorLabels.errorTitle,
				this.errorLabels.errorMessage,
				'error',
				'dismissible'
			);
		}
	}
}