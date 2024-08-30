import { LightningElement, api } from "lwc";
// import search from "@salesforce/apex/CustomLookup.search";
// import getRecord from "@salesforce/apex/CustomLookup.getRecord";
const DEBOUNCE_DELAY = 300;

export default class CustomLookup extends LightningElement {
    @api
    label = "";
    @api
    placeholder = "Search...";
    @api
    iconName = "standard:opportunity";
    @api
    defaultRecord = null;
    @api
    defaultRecordId = "";
    @api
    fields = ["Id", "Name"];
    @api
    searchClass;
    @api
    idField = "Product2Id";
    @api
    nameField = "Description";
    
    _results = [];
    @api
    get results() {
        return this._results;
    }
    set results(value) {
        this.loading = false;
        this._results = value.map((item) => ({
            id: item[this.idField],
            name: item[this.nameField],
        }));
    }

    hasRecords = true;
    searchKey = "";
    loading = false;
    delayTimeoutId;
    selectedRecord = {};

    @api
    value() {
        return this.searchKey;
    }

    initialized = false;
    renderedCallback() {
        if(this.initialized) {
            return;
        }
        this.initialized = true;
        this.init();
    }

    async init() {
        if (this.defaultRecord?.[this.idField]) {
            try {
                const record = {
                    id: this.defaultRecord?.[this.idField],
                    name: this.defaultRecord?.[this.nameField],
                };
                if (record) {
                    this.selectedRecord = record;
                    this.handelSelectRecordHelper();
                }
            } catch (error) {
                this.error = error;
                this.selectedRecord = {};
            }
        }
    }

    // TODO Implement if you want to use this as a generic lookup search component
    async handleSearch() {
        // try {
        //     const response = await search({
        //         filters: {
        //             text: this.searchKey,
        //             fields: this.fields,
        //             searchClass: this.searchClass,
        //         },
        //     });
        //     this.isSearchLoading = false;
        //     this.hasRecords = response.records.length;
        //     this.results = JSON.parse(JSON.stringify(response.records));
        // } catch (error) {
        //     console.log(error);
        // }
    }

    handleKeyChange(event) {
        // this.isSearchLoading = true;
        // if (this.delayTimeoutId) {
        //     window.clearTimeout(this.delayTimeoutId);
        // }
        // const searchKey = event.target.value;
        // // eslint-disable-next-line @lwc/lwc/no-async-operation
        // this.delayTimeoutId = setTimeout(() => {
        //     this.searchKey = searchKey;
        //     this.handleSearch();
        // }, DEBOUNCE_DELAY);
        clearTimeout(this.delayTimeoutId);
        const value = event.target.value;
        // eslint-disable-next-line @lwc/lwc/no-async-operation
        this.delayTimeoutId = setTimeout(() => {
            this.loading = true;
            this.dispatchEvent(new CustomEvent("searchchange", {
                detail: { value },
            }));
        }, DEBOUNCE_DELAY);
    }

    toggleResult(event) {
        const lookupInputContainer = this.template.querySelector(".lookupInputContainer");
        const clsList = lookupInputContainer.classList;
        const whichEvent = event.target.getAttribute("data-source");
        switch (whichEvent) {
            case "searchInputField":
                clsList.add("slds-is-open");
                break;
            case "lookupContainer":
                clsList.remove("slds-is-open");
                break;
            default:
                break;
        }
    }

    handleRemove() {
        this.searchKey = "";
        this.selectedRecord = {};
        this.handleLookupUpdate(undefined);

        const searchBoxWrapper = this.template.querySelector(".searchBoxWrapper");
        searchBoxWrapper.classList.remove("slds-hide");
        searchBoxWrapper.classList.add("slds-show");
        const pillDiv = this.template.querySelector(".pillDiv");
        pillDiv.classList.remove("slds-show");
        pillDiv.classList.add("slds-hide");
    }

    handelSelectedRecord(event) {
        const objId = event.target.getAttribute("data-recid");
        this.selectedRecord = this.results.find((data) => data.id === objId);
        this.handleLookupUpdate(this.selectedRecord);
        this.handelSelectRecordHelper();
    }

    handelSelectRecordHelper() {
        this.template.querySelector(".lookupInputContainer").classList.remove("slds-is-open");
        const searchBoxWrapper = this.template.querySelector(".searchBoxWrapper");
        searchBoxWrapper.classList.remove("slds-show");
        searchBoxWrapper.classList.add("slds-hide");
        const pillDiv = this.template.querySelector(".pillDiv");
        pillDiv.classList.remove("slds-hide");
        pillDiv.classList.add("slds-show");
    }

    handleLookupUpdate(value) {
        this.dispatchEvent(new CustomEvent("lookupupdate", {
            detail: value ? JSON.parse(JSON.stringify(value)) : undefined
        }));
    }
}