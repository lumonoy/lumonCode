import { LightningElement, api, wire } from "lwc";
import getComponentData from "@salesforce/apex/PricingAdditionalCostsController.getComponentData";
import saveAdditionalCost from "@salesforce/apex/PricingAdditionalCostsController.saveAdditionalCost";
import deleteAdditionalCost from "@salesforce/apex/PricingAdditionalCostsController.deleteAdditionalCost";
import findPrices from "@salesforce/apex/PricingAdditionalCostsController.findPrices";
import findProduct from "@salesforce/apex/PricingAdditionalCostsController.findProduct";
import { reduceErrors, showToast } from "c/lwcUtils";
import pricingComponentResources from "@salesforce/resourceUrl/PricingComponentResources";
import { getRecord, notifyRecordUpdateAvailable } from "lightning/uiRecordApi";
import { refreshApex } from "@salesforce/apex";

export default class PricingAdditionalCosts extends LightningElement {
    @api
    recordId;

    intialized = false;
    processing = false;
    showAddCosts = false;
    availableColumns = [
        {
            label: "Product",
            fieldName: "productGroup",
            type: "picklist",
            cellAttributes: {
                values: [],
            },
            editable: true,
            disabled: (item) => item.recordId, 
        },
        {
            label: "Cost type",
            fieldName: "costType",
            type: "picklist",
            cellAttributes: {
                values: [],
            },
            editable: true,
            disabled: (item) => !item.productGroup || item.recordId, 
        },
        {
            label: "Description",
            fieldName: "description",
            type: "text",
            editable: true,
        },
        {
            label: "Cost",
            fieldName: "cost",
            type: "number",
            headerClass: "slds-text-align_right",
            editable: true,
        },
        {
            label: "Actions",
            fieldName: "actions",
            type: "actions",
            cellAttributes: {
                values: [
                    {
                        label: (item) => (item.recordId ? "Save" : "Create"),
                        name: "save",
                        class: (item) =>
                            "slds-button slds-button_neutral slds-var-m-right_x-small" +
                            (item.dirty ? " slds-button_brand" : ""),
                        disabled: (item) => this.disabled || !item.productGroup || !item.costType || !item.dirty,
                    },
                    {
                        label: "Delete",
                        name: "delete",
                        class: "slds-button slds-button_neutral",
                    },
                ],
            },
        },
    ];
    columns = [];
    items = null;
    keyField = "id";
    cssResourcePath;
    opportunity;

    @wire(getRecord, {
        recordId: "$recordId",
        fields: ["Opportunity.Id", "Opportunity.Count_Opportunity_Products__c", "Opportunity.CurrencyIsoCode"],
    })
    async wiredRecord({ data, error }) {
        this.opportunity = data;
        if (data) {
            await this.init();
        } else if (error) {
            showToast(this, "Could not load the opportuntiy", "Try to refresh the page", "error");
        }
    }

    renderedCallback() {
        if (this.intialized) {
            return;
        }
        this.intialized = true;
    }

    recordToItem(item) {
        return {
            id: item.Id,
            recordId: item.Id,
            productId: item.Product2Id,
            productGroup: item.Product2.Product_Group__c,
            costType: item.Product2.Cost_Type__c,
            salesCode: item.Product2.Sales_Code__c,
            description: item.Description,
            cost: item.Base_Price__c,
            dirty: false,
            record: item,
        };
    }

    async init() {
        try {
            this.processing = true;
            this.cssResourcePath = pricingComponentResources + "/datatable.css";
            const data = await getComponentData({ recordId: this.recordId });
            this.showAddCosts = data.showAddCosts;
            const picklistFieldMapping = {
                productGroup: "Product_Group__c",
                costType: "Cost_Type__c",
            };
            this.columns = this.availableColumns.map((column) => {
                if (column.type === "picklist") {
                    column.cellAttributes.values = data.picklistValues[picklistFieldMapping[column.fieldName]];
                }
                return column;
            });

            if (!this.items || !this.items.length) {
                this.items = data.quoteLineItems.map((item) => this.recordToItem(item));
            } else {
                for (const item of data.quoteLineItems) {
                    if (!this.items.find((o) => item.recordId !== o.recordId)) {
                        this.items.push(this.recordToItem(item));
                    }
                }
                this.items = [...this.items];
            }
        } catch (e) {
            showToast(this, "Additional costs error", reduceErrors(e), "error");
        }
        this.processing = false;
    }

    handleAddItem() {
        let randomId = null;
        while (!randomId || this.items.find((i) => randomId === i.id)) {
            randomId = Math.random() + "";
        }
        this.items = [
            ...this.items,
            {
                id: randomId,
                recordId: null,
                productGroup: "",
                salesCode: "",
                costType: "",
                description: "",
                productId: null,
                cost: 0,
                dirty: true,
            },
        ];
    }

    async handleActionValueChange(event) {
        this.processing = true;
        await this.handleValueChange(event);
        await this.handleAction(event);
        this.processing = false;
    }

    async handleAction(event) {
        const eventData = event.detail;
        const item = this.items.find((o) => o.id === eventData.id);
        if (item) {
            if (eventData.action === "delete") {
                await this.deleteItem(item);
                await this.init();
                refreshApex(this.opportunity);
                notifyRecordUpdateAvailable([{ recordId: this.recordId }]);
            } else if (eventData.action === "save") {
                await this.saveItem(item);
                await this.init();
                refreshApex(this.opportunity);
                notifyRecordUpdateAvailable([{ recordId: this.recordId }]);
            }
        }
    }

    async handleValueChange(event) {
        const eventData = event.detail;
        const item = this.items.find((o) => o.id === eventData.id);
        if (item) {
            item[eventData.fieldName] = eventData.value;
            if (["cost", "costType"].includes(eventData.fieldName)) {
                this.processing = true;
                try {
                    const product = await findProduct({
                        opportunityId: this.recordId,
                        productGroup: item.productGroup,
                        costType: item.costType,
                    });
                    const quoteLineItem = await findPrices({
                        opportunityId: this.recordId,
                        productId: product.Id,
                        basePrice: item.cost,
                    });
                    quoteLineItem.Product2Id = product.Id;
                    item.record = quoteLineItem;
                } catch(e) {
                    showToast(this, "Error", reduceErrors(e), "error");
                }
                this.processing = false;
            }
            item.dirty = true;
        }
        this.items = [...this.items];
    }

    get showSpinner() {
        return !this.intialized || this.processing;
    }

    get saveDisabled() {
        return !this.intialized || this.processing;
    }

    async saveItem(item) {
        if (this.processing) return;
        this.processing = true;
        try {
            const quoteLineItem = {
                Description: item.description,
                Product2Id: item.record.Product2Id,
            };
            const itemRecordId = await saveAdditionalCost({
                opportunityId: this.recordId,
                quoteLineItem,
                quoteLineItemWithPrices: item.record,
            });
            item.recordId = itemRecordId;
            item.dirty = false;
            this.items = this.items.filter(o => o.id !== item.id);
            await this.init();
            showToast(this, "Saved", "Pricing changes saved", "success");
        } catch (e) {
            showToast(this, "We hit a snag", reduceErrors(e), "error", "sticky");
        }
        refreshApex(this.opportunity);
        notifyRecordUpdateAvailable([{ recordId: this.recordId }]);
        this.processing = false;
    }

    async deleteItem(item) {
        if (this.processing) return;
        this.processing = true;
        try {
            if (item.recordId) {
                await deleteAdditionalCost({
                    opportunityId: this.recordId,
                    quoteLineItemId: item.recordId,
                });
                showToast(this, "Deleted", "Item deleted", "success");
            }
            this.items = this.items.filter((o) => o.id !== item.id);
        } catch (e) {
            showToast(this, "We hit a snag", reduceErrors(e), "error", "sticky");
        }
        refreshApex(this.opportunity);
        notifyRecordUpdateAvailable([{ recordId: this.recordId }]);
        this.processing = false;
    }
}