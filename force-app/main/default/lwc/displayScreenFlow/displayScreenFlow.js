import { api } from "lwc";
import LightningModal from "lightning/modal";

export default class DisplayScreenFlow extends LightningModal {
    @api
    flowName;
    @api
    variables;

    handleStatusChange(event) {
        if(["FINISHED", "FINISHED_SCREEN"].includes(event?.detail?.status)) {
            this.close(); 
        }
    }
}