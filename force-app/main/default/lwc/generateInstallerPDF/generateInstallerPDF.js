import {api, LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { reduceErrors, showToast } from "c/lwcUtils";
import getConfigurationProducts from "@salesforce/apex/GenerateInstallerPdfController.getConfigurationProducts";
//import getConfigBlindProducts from "@salesforce/apex/GenerateInstallerPdfController.getConfigBlindProducts";
import checkBlindProducts from "@salesforce/apex/BlindInstructionPdfController.checkBlindsData";
import deletePDF from "@salesforce/apex/ServiceAppointmentService.deletePDF";
import createPDF from "@salesforce/apex/ServiceAppointmentService.createPDF";
export default class GenerateInstallerPdf extends NavigationMixin(LightningElement) {

    @api recordId;
    initialized = false;
    disableBtn = false;
    disableBlindsBtn = true;

    connectedCallback() {
        if (!this.initialized) {
            this.init();
            this.checkBlinds();
        }
        this.initialized = true;
    }

    async init() {
        try {
            const confProducts = await getConfigurationProducts({recordId: this.recordId});
            this.disableBtn = !confProducts.filter((prod) => prod.hasOwnProperty('Installer_Message__c')).length > 0;
        } catch (error) {
            showToast(this, "GenerateInstallerPdf error", reduceErrors(error),"error", 'sticky');
        }
    }
    async checkBlinds() {
        try {
            const blindProds = await checkBlindProducts({recordId: this.recordId});
            //if(confProducts.length > 0){
                this.disableBlindsBtn = blindProds;
            //}
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

    async generateBlindsPDF() {
       // await this.deletePDF(this.recordId);
        //await this.createPDF(this.recordId);
        this[NavigationMixin.GenerateUrl]({
            type: 'standard__webPage',
            attributes: {
                url:'/apex/GenerateConfigurationProductPdf?workorderId='+this.recordId,
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