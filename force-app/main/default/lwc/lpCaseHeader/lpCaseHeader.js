import {LightningElement} from 'lwc';
import { registerListener, unregisterAllListeners } from 'c/lpPubSub';
import {caseLabels} from "c/lpLabels";

export default class LpCaseHeader extends LightningElement {

	caseLabels = caseLabels;
	orderNumber;

	connectedCallback(){
		registerListener('selectedOrder', this.displaySelectedOrder, this);
	}

	disconnectedCallback() {
		unregisterAllListeners(this);
	}

	displaySelectedOrder(orderInfo){
		const order = JSON.parse(orderInfo);
		this.orderNumber = '#'+order.orderNo;
	}

}