import {LightningElement, wire} from 'lwc';
import fetchOrderDetails from '@salesforce/apex/LP_MainController.fetchOrderDetails';
import LOCALE from "@salesforce/i18n/locale";
import {CurrentPageReference} from 'lightning/navigation';
import {orderDetailLabels, errorLabels} from "c/lpLabels"
import {showToast} from "c/lpUtils";
import {fireEvent} from 'c/lpPubSub';
import {reduceErrors} from "c/lpUtils";

export default class LpOrderDetails extends LightningElement {

	recordId;
	orderLabels = orderDetailLabels;
	errorLabels = errorLabels;
	order = {};

	@wire(CurrentPageReference)
	pageReference({ state }) {
		if (state && state.orderId) {
			this.recordId = state.orderId;
			this.getOrderDetails();
		}
	}

	async getOrderDetails(){
		try{
			const orderDetailsSTR = await fetchOrderDetails({orderId : this.recordId});
			let order = JSON.parse(orderDetailsSTR);
			if(order.odProducts.length > 0){
				for(let product of order.odProducts){
					if(product?.warrantyStart){
						product.warrantyStart = this.formattedDate(product.warrantyStart);
					}
					if(product?.warrantyEnd){
						product.warrantyEnd = this.formattedDate(product.warrantyEnd);
					}
				}
			}
			if(order.installDate){
				order.installDate = this.formattedDate(order.installDate)
			}
			this.sendDataToDependentComponents(orderDetailsSTR);
			this.order = order;
		}catch(e){
			console.log('ERROR getOrderDetails ## ', reduceErrors(e));
			showToast(
				this,
				this.errorLabels.errorTitle,
				this.errorLabels.errorMessage,
				'error',
				'dismissible'
			);
		}
	}

	sendDataToDependentComponents(orderInfoSTR) {
		fireEvent('selectedOrder', orderInfoSTR);
	}

	formattedDate = (date) => (
		new Date(date).toLocaleDateString(
			LOCALE, { weekday:"long", year:"numeric", month:"short", day:"numeric"}
		)
	);
}