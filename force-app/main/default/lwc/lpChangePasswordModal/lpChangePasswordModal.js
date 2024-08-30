import {LightningElement, api} from 'lwc';
export default class LpChangePasswordModal extends LightningElement {
	@api modalHeading;
	handleModalClose = () => {
		const closeDialog = new CustomEvent('close_modal');
		this.dispatchEvent(closeDialog);
	}
}