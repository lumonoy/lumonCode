import {api, LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { reduceErrors, showToast } from "c/lwcUtils";
import getConfigurationProducts from "@salesforce/apex/GenerateInstallerPdfController.getConfigurationProducts";
import deletePDF from "@salesforce/apex/ServiceAppointmentService.deletePDF";
import createPDF from "@salesforce/apex/ServiceAppointmentService.createPDF";
export default class GenerateInstallerPdf extends NavigationMixin(LightningElement) {

    @api recordId;
    initialized = false;
    disableBtn = false;

    connectedCallback() {
        if (!this.initialized) {
            this.init();
        }
        this.initialized = true;
    }

    async init() {
        try {
            const confProducts = await getConfigurationProducts({
                orderId: this.recordId
            });
            this.disableBtn = !confProducts.filter((prod) => prod.hasOwnProperty('Installer_Message__c')).length > 0;
        } catch (error) {
            showToast(this, "GenerateInstallerPdf error", reduceErrors(error),"error", 'sticky');
        }
    }

    async generatePDF() {
        await this.deletePDF(this.recordId);
        await this.createPDF(this.recordId);
        this[NavigationMixin.GenerateUrl]({
            type: 'standard__webPage',
            attributes: {
                url: '/apex/InstallerPDF?workorder-id='+this.recordId,
            }
        }).then(generatedUrl => {
            window.open(generatedUrl, "_blank");
        });
    }

    async deletePDF(recordId){
        try {
            await deletePDF({
                id: recordId
            });
        } catch (error) {
            showToast(this, "delete error", reduceErrors(error),"error", 'sticky');
        }
    }

    async createPDF(recordId){
        try {
            await createPDF({
                id: recordId
            });
        } catch (error) {
            showToast(this, "create error", reduceErrors(error),"error", 'sticky');
        }
    }
}