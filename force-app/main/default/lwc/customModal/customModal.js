import { LightningElement, api } from "lwc";

export default class CustomModal extends LightningElement {
    @api
    header;
    @api
    size = "medium";
    @api
    noPadding = false;
    @api
    relativeContent;
    @api
    fixedMinimumHeight;
    loading = false;

    @api
    showHideLoader(value) {
        this.loading = value;
    }

    get classes() {
        return "slds-modal slds-fade-in-open " + this.sizeClass();
    }

    get contentClass() {
        return "slds-modal__content no-padding" + (!this.noPadding ? " slds-p-around_medium" : "")
            + (this.relativeContent ? " slds-is-relative" : "")
            + (this.fixedMinimumHeight ? " fixed-minimum-height" : "");
    }

    sizeClass() {
        if (this.size === "small") return "slds-modal_small";
        else if (this.size === "large") return "slds-modal_large";
        return "slds-modal_medium";
    }
}