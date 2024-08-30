import { LightningElement, api, track, } from 'lwc';
import { FlowAttributeChangeEvent, FlowNavigationNextEvent, FlowNavigationFinishEvent } from 'lightning/flowSupport';

export default class flowAutoNavigate extends LightningElement {
    renderedCallback() {
        var parentThis = this;
        // Navigate to the next step in the flow either next action or finish
        const navigateFinishEvent = new FlowNavigationFinishEvent();
        parentThis.dispatchEvent(navigateFinishEvent);
        console.log("navigate finish");
        parentThis.triggered = true;
    }




}