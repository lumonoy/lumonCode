import { LightningElement,api } from 'lwc';

export default class ConfirmationScreen extends LightningElement {
    @api visible; 
    @api title; 
    @api name;
    @api message;
    @api confirmLabel; 
    @api cancelLabel;
    @api originalMessage; 

    get showMessage()
    {
        return this.message && this.message.length>0?true:false;
    }
    //Button Click Handler
    handleConfirmClick(event) {
        //creates object which will be published to the parent component
        if (event.target) {
            let finalEvent = {
                originalMessage: this.originalMessage,
                status: event.target.name
            };

            //dispatch a 'click' event so the parent component can handle it
            this.dispatchEvent(new CustomEvent('click', { detail: finalEvent }));
        }
    }
    @api handleCancel()
    {
        this.visible=false;
    }
    @api openmodal() {
        this.visible = true
    }
    @api closeModal() {
        this.visible = false
    }
}