import { LightningElement, api } from "lwc";

export default class ConditionalModal extends LightningElement {
    @api
    header = "";
    @api
    size = "large";
    @api
    showModal = false;
}