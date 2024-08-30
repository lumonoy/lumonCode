import {LightningElement, api} from 'lwc';

export default class OppOverviewProductsModal extends LightningElement {
	@api productColumns;
	@api productRows;
	closeModal(){
		const modalEvent = new CustomEvent('close_modal', {});
		this.dispatchEvent(modalEvent);
	}
	handleOppProductFieldChange(){
		console.log('INSIDE MODAL EVENT');//
		const productEvent = new CustomEvent('product_field_change', {});
		this.dispatchEvent(productEvent);
		console.log('event sent..');
	}
}