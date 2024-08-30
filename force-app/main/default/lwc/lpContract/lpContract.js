import {LightningElement, track} from 'lwc';
import {contractLabels} from "c/lpLabels";
import { registerListener, unregisterAllListeners } from 'c/lpPubSub';
import {formatDateForUI} from "c/lpUtils";
export default class LpContract extends LightningElement {
	contractLabels = contractLabels;
	@track signedDate = '';
	@track signedDocuments = [];

	connectedCallback(){
		registerListener('selectedOrder', this.getSelectedOrderData, this);
	}

	disconnectedCallback(){
		unregisterAllListeners(this);
	}

	getSelectedOrderData(orderDataSTR){
	    this.setContractDetails(orderDataSTR);
    }

    setContractDetails(orderDataSTR){
	    const orderData = JSON.parse(orderDataSTR);
	    const orderContracts = JSON.parse(orderData?.orderContractSTR);
	    this.signedDate = orderContracts?.signedDate ? formatDateForUI(orderContracts?.signedDate) : null;
		let contractDocs = [];
		if(orderContracts?.signedDocuments !== null && orderContracts?.signedDocuments.length > 0){
			for(let signedDoc of orderContracts.signedDocuments){
				contractDocs.push({
					fileName : signedDoc?.name ? signedDoc?.name : null,
					pdfDownloadLink : signedDoc?.downloadUrl ? signedDoc?.downloadUrl : null
				});
			}
		}
	    this.signedDocuments = contractDocs;
    }
}