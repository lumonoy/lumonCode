import { LightningElement, api, wire } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import getComponentData from '@salesforce/apex/PricingComponentController.getComponentData';
import saveData from '@salesforce/apex/PricingComponentController.saveData';
import Summary_VAT_X from '@salesforce/label/c.Summary_VAT_X';
import { reduceErrors, showToast } from 'c/lwcUtils';
import { flattenTree, collapseTree, updateExpandCollapse, evenRound } from './utils';
import * as utils from './utils';
import pricingComponentResources from '@salesforce/resourceUrl/PricingComponentResources';
import { getRecord, notifyRecordUpdateAvailable } from 'lightning/uiRecordApi';
import { subscribe, unsubscribe } from 'lightning/empApi';
import LightningConfirm from 'lightning/confirm';

const SUMMARY_0_ID = 'summary0';
const SUMMARY_VAT_ID = 'summaryVAT';
const SUMMARY_0_GROUP_ID = 'Product_Group.' + SUMMARY_0_ID;
const SUMMARY_VAT_GROUP_ID = 'Product_Group.' + SUMMARY_VAT_ID;

export { utils };

function roundNumber(floatNumber) {
    return +floatNumber.toFixed(7);
}

export default class Pricing extends LightningElement {
    @api
    recordId;

    channelName = '/event/ConfigurationEvent__e';
    subscription = {};

    errorMessage = '';
    intialized = false;
    processing = false;
    showPricing = true;
    availableColumns = [
        {
            label: 'Product',
            fieldName: 'name',
            type: 'expandable',
            cellAttributes: {
                expandedIcon: 'utility:chevrondown',
                collapsedIcon: 'utility:chevronright',
                fieldName: 'expanded',
                iconClass: '',
                iconName: (item) => item.expanded
                    ? this.expandedIcon
                    : this.collapsedIcon,
                iconVariant:  '',
                iconSize:  'x-small',
            }
        },
        {
            label: 'Factory',
            fieldName: 'factory',
            type: 'number',
            headerClass: 'slds-text-align_right',
            class: 'slds-text-align_right',
            valueHidden: (item) => !item.factory
        },
        {
            label: 'Cost',
            fieldName: 'cost',
            type: 'number',
            headerClass: 'slds-text-align_right',
            class: 'slds-text-align_right',
            valueHidden: (item) => !item.cost
        },
        {
            label: 'List Price',
            fieldName: 'listPrice',
            type: 'number',
            class: 'slds-text-align_right',
            headerClass: 'slds-text-align_right'
        },
        {
            label: 'Sales Price',
            fieldName: 'salesPrice',
            type: 'number',
            headerClass: 'slds-text-align_right',
            class: 'slds-text-align_right',
            editable: (item) => !this.disabled && item.level < 2,
            valueHidden: (item) => item.level >= 2
        },
        {
            label: 'Sales Margin %',
            fieldName: 'salesMargin',
            type: 'number',
            headerClass: 'slds-text-align_right',
            class: 'slds-text-align_right',
            editable: (item) => !this.disabled && item.level < 2,
            validator: (value) => isNaN(value) || value >= 100,
            valueHidden: (item) => item.level >= 2
        },
        {
            label: 'Discount %',
            fieldName: 'discount',
            type: 'number',
            headerClass: 'slds-text-align_right',
            class: 'slds-text-align_right',
            editable: (item) => !this.disabled && item.summaryWithVAT,
            valueHidden: (item) => item.level >= 2
        }
    ];
    hiddenColumns = ['factory', 'cost', 'salesMargin'];
    summaryFields = ['factory', 'cost', 'listPrice'];
    columns = [];
    pricingData = null;
    pricingTree = null;
    keyField = 'id';
    isAdmin = false;
    isManager = false;
    isSupport = false;
    isSales = false;
    maxDiscount = 0;
    disabled = false;
    debugMode = false;
    fullScreen = false;
    cssResourcePath;
    vat = 24;
    dirty = false;
    pricingSummary = null;
    opportunity;

    @wire(getRecord, {
        recordId: '$recordId',
        fields: ['Opportunity.Id', 'Opportunity.Count_Opportunity_Products__c', 'Opportunity.CurrencyIsoCode']
    })
    async wiredRecord({ data, error }) {
        this.opportunity = data;
        if (data) {
            await this.init();
        } else if (error) {
            showToast(this, 'Could not load the opportuntiy', 'Try to refresh the page', 'error');
        }
    }

    renderedCallback() {
        if (this.intialized) {
            return;
        }
        this.intialized = true;
        this.subscribeToCongfigurationEvent();
    }

    disconnectedCallback() {
        this.unsubscribeToCongfigurationEvent();
    }

    async subscribeToCongfigurationEvent() {
        const response = await subscribe(this.channelName, -1, async ({ data, channel }) => {
            if (data?.payload?.recordId__c === this.recordId &&
                data?.payload?.configAction__c === 'Price'
            ) { this.processing = true;}
            if (
                channel === this.channelName &&
                data?.payload?.recordId__c === this.recordId &&
                data?.payload?.configAction__c === 'Quote'
            ) {
                if (!this.dirty) {
                    this.init();
                } else if (
                    await LightningConfirm.open({
                        label: 'The configuration was updated',
                        message: 'Click OK to dicard the changes and refresh the pricing summary component.',
                        variant: 'header'
                    })
                ) {
                    this.init();
                }
            }
        });
        this.subscription = response;
    }

    unsubscribeToCongfigurationEvent() {
        unsubscribe(this.subscription);
    }

    columnVisibleForUser(isAdminUser,isManagerUser, isSupportUser, column) {
        // Show columns if User is System Admin, Installation Manager, SalesManager or Technical Support
        return isAdminUser || isManagerUser ||isSupportUser ||(!isAdminUser && !isManagerUser && !isSupportUser && !this.hiddenColumns.includes(column.fieldName));
    }

    itemVisibleForUser(isAdminUser, item) {
        return isAdminUser || (!isAdminUser && item);
    }

    summaryId(summary) {
        return summary.Group_Level__c + '.' + summary.Group_Name__c;
    }

    groupItems(items, labels) {
        const idDelimiter = '____';
        const itemsByUniquePath = {};
        const itemTree = [];
        for (const item of items) {
            const path = [
                item.Product2.Product_Group__c,
                item.Product2.Cost_Type__c,
                item.Product2.ProductCode,
                item.Id
            ];
            const parentPathReverse = path.slice(0, path.length - 1).reverse();
            const parentPaths = [];
            while (parentPaths.length !== path.length - 1) {
                parentPaths.push(parentPathReverse.pop());

                const parentPathString = parentPaths.join(idDelimiter);
                if (!itemsByUniquePath[parentPathString]) {
                    const level = parentPaths.length - 1;
                    const parent = {
                        id: parentPathString,
                        groupId: parentPathString,
                        name:
                            level === 0
                                ? labels.Product_Group__c.find(o => o.value === item.Product2.Product_Group__c)?.label
                                : level === 1
                                ? labels.Cost_Type__c.find(o => o.value === item.Product2.Cost_Type__c)?.label
                                : level === 2
                                ? `${item.Product2.Name} {0} ${item.Product2.QuantityUnitOfMeasure}`
                                : parentPaths[parentPaths.length - 1],
                        expandable: (this.isAdmin && level < 2) || this.debugMode || (!this.isAdmin && level === 0),
                        expanded: false,
                        factory: 0,
                        cost: 0,
                        listPrice: 0,
                        salesPrice: 0,
                        salesMargin: 0,
                        discount: 0,
                        quantity: 0,
                        hiddenFromUser: (o) => (o.level === 1 && o.listPrice.toFixed(0) === '0' && o.salesPrice.toFixed(0) === '0'),
                        level,
                        children: []
                    };
                    itemsByUniquePath[parentPathString] = parent;
                    if (level === 0) {
                        itemTree.push(parent);
                    } else {
                        const itemParent =
                            itemsByUniquePath[parentPaths.slice(0, parentPaths.length - 1).join(idDelimiter)];
                        itemParent.children.push(parent);
                    }
                }
            }
            const pathString = path.join(idDelimiter);
            itemsByUniquePath[pathString] = {
                id: pathString,
                recordId: item.Id,
                name: `${item.Product2.Name} ${evenRound(item.Quantity)}`,
                factory: item.fxFactory__c,
                cost: item.fxCost__c,
                quantity: item.Quantity,
                // NOTE: Column Labels and Field names are in reverse
                listPrice: item.fxSales__c, //item.fxUnitSalesPrice__c * item.Quantity,               
                salesPrice: item.fxList__c,
                //listPrice: item.fxList__c, //item.fxUnitSalesPrice__c * item.Quantity,               
                //salesPrice: item.fxSales__c,
                // salesPrice: item.Sales_Multiplier__c > 0 ? roundNumber(item.UnitPrice * item.Quantity) : 0, //item.fxSales__c // the fxSales__c causes rounding errors
                // salesPrice: !this.pricingSummary.Sales_Price__c && this.pricingSummary.Sales_Price__c !== 0 ? item.fxList__c : item.Sales_Multiplier__c > 0 ? item.UnitPrice * item.Quantity : 0,
                salesMargin: item.Sales_Margin__c,
                discount: item.Discount__c,
                level: 3,
                hiddenFromUser: !this.debugMode
            };
            const itemParent = itemsByUniquePath[[...path].slice(0, path.length - 1).join(idDelimiter)];
            itemParent.quantity += itemsByUniquePath[pathString].quantity;
            itemParent.children.push(
                itemsByUniquePath[pathString]
            );
        }
        if(itemTree.length) {
            itemTree.push({
                id: SUMMARY_0_ID,
                groupId: SUMMARY_0_GROUP_ID,
                name: Summary_VAT_X.replace('{0}', '0').replace('{1}', this.opportunity.fields.CurrencyIsoCode.value),
                factory: 0,
                cost: 0,
                listPrice: 0,
                salesPrice: 0,
                salesMargin: 0,
                discount: 0,
                level: 0,
                // headerClasses: 'summary summary-first'
                class: 'summary summary-first'
            });
            itemTree.push({
                id: SUMMARY_VAT_ID,
                groupId: SUMMARY_VAT_GROUP_ID,
                name: Summary_VAT_X.replace('{0}', this.vat).replace('{1}', this.opportunity.fields.CurrencyIsoCode.value),
                factory: 0,
                cost: 0,
                listPrice: 0,
                salesPrice: 0,
                salesMargin: 0,
                discount: 0,
                level: 0,
                summaryWithVAT: true,
                // headerClasses: 'summary',
                class: 'summary'
            });
        }
        return itemTree;
    }

    async init() {
        try {
            this.processing = true;
            this.dirty = false;
            this.cssResourcePath = pricingComponentResources + '/datatable.css';
            const data = await getComponentData({ recordId: this.recordId });
            this.pricingSummary = data.pricingSummary;
            
            this.isManager= data.isManager;
            this.isSupport = data.isSupport;
            this.isAdmin = data.isAdmin;
            this.maxDiscount = data.maxDiscount;
            this.debugMode = data.debugMode;
            this.disabled = data.disabled;
            if(data.opportunity.Account.VAT__c) {
                this.vat = evenRound(parseFloat(data.opportunity.Account.VAT__c));
            }
            this.columns = [...this.availableColumns].filter((column) =>
                this.columnVisibleForUser(this.isAdmin, this.isManager, this.isSupport, column)
            );

            const tree = this.groupItems(data.quoteLineItems, data.fieldLabels);
            if(tree.length) {
                this.pricingTree = tree;
                this.pricingData = flattenTree(this.pricingTree, []);
                this.pricingData.map(item => {
                    if(item.level === 2) {
                        item.name = item.name.replace('{0}', evenRound(item.quantity));
                    }
                    return item;
                });

                updateExpandCollapse(this.pricingTree);

                this.pricingTree.filter((item) => item.recordId).map((item) => this.calculateDiscountChange(item));
                this.recalculateAll(false); // TODO keep the salesprice when and after the contract is sent
            }
        } catch (e) {
            console.error(e);
            showToast(this, 'Error when loading the pricing component', reduceErrors(e), 'error');
        }
        this.processing = false;
    }

    recalculateAll(lockDiscount) {
        console.log('--- Recalculate All');
        this.calculateSalesPrices(this.pricingTree);//Item Sales Prices for Items
        this.calculateAll(this.pricingTree, lockDiscount); // Cost Type/ Product Sales Prices
        this.calculateSummaryData(lockDiscount); // Total Sales Prices 
    }

    calculateSalesPrices(items) {
        console.log('--- Calculate SalesPrices');
        for (const item of items) {
            if (item.children) {
                item.salesPrice = 0;
                for (const child of item.children) {
                    item.salesPrice += roundNumber(parseFloat(child.salesPrice));
                }
            }
        }
    }

    calculateAll(items, lockDiscount) {
        console.log('--- Calculate All');
        let sums = {};
        for (const field of this.summaryFields) {
            sums[field] = 0;
        }
        for (const item of items) {
            if (item.children) {
                for (const field of this.summaryFields) {
                    item[field] = 0;
                }
                const childSums = this.calculateAll(item.children);
                for (const field of this.summaryFields) {
                    item[field] += roundNumber(parseFloat(childSums[field]));
                }
            }
            if (item.children) {
                item.salesPrice = 0;
                for (const child of item.children) {
                    item.salesPrice += roundNumber(child.salesPrice);
                }
            }
            if(lockDiscount || !item.recordId) {
                item.discount = this.calculateDiscount(item);
            }
            item.salesMargin = this.calculateSalesMargin(item);

            for (const field of this.summaryFields) {
                sums[field] += roundNumber(parseFloat(item[field]));
            }
        }
        return sums;
    }

    calculateSummaryData(lockDiscount) {
        console.log('--- Calculate Summary Data');
        const summary0 = this.pricingTree.find((item) => item.groupId === SUMMARY_0_GROUP_ID);
        const summaryVAT = this.pricingTree.find((item) => item.groupId === SUMMARY_VAT_GROUP_ID);
        for (const field of this.summaryFields) {
            summary0[field] = 0;
            summaryVAT[field] = 0;
        }
        summary0.salesPrice = 0;
        summaryVAT.salesPrice = 0;
        for (const item of this.pricingData) {
            if (item.recordId) {
                if (!this.disabled) {
                    console.log('--- Opportunity Sales Prices Not Locked');
                    summary0.salesPrice += roundNumber(parseFloat(item.salesPrice)); // Total Without VAT
                    summaryVAT.salesPrice += roundNumber(parseFloat(item.salesPrice) * (1 + this.vat / 100)); // Total With VAT
                } else {
                    console.log('--- Opportunity Sales Prices Locked');
                    summary0.salesPrice += roundNumber(parseFloat(item.salesPrice)); // Total Without VAT
                    summaryVAT.salesPrice += roundNumber(parseFloat(item.salesPrice) * (1 + this.vat / 100)); // Total With VAT
                }
                for (const field of this.summaryFields) {
                    summary0[field] += roundNumber(parseFloat(item[field]));
                    summaryVAT[field] += roundNumber(parseFloat(item[field]) * (1 + this.vat / 100));
                }
            }
        }
        
        if(lockDiscount) {
            console.log('--- Discount Locked');
            summary0.discount = this.calculateDiscount(summary0);
            summary0.discount = this.calculateDiscountChange(summary0);
            if (!summaryVAT.salesPrice) {
                summaryVAT.salesPrice = roundNumber(summaryVAT.listPrice);
            }
            summaryVAT.discount = this.calculateDiscount(summaryVAT);
            summaryVAT.discount = this.calculateDiscountChange(summaryVAT);
        } else {
            console.log('--- Discount Not Locked');
            summary0.salesMargin = this.calculateSalesMargin(summary0);
            summaryVAT.salesMargin = this.calculateSalesMargin(summary0);
            summary0.discount = this.calculateDiscount(summary0);
            summaryVAT.discount = this.calculateDiscount(summaryVAT);
        }
    }

    handleDoubleClick(event) {
        if (this.isAdmin) {
            const eventData = event.detail;
            const item = this.pricingData.find((o) => o.id === eventData.id);
            if (eventData.fieldName === 'name' && item.recordId) {
                window.open('/' + item.recordId, '_blank');
            }
        }
    }

    savePricingSummaries() {}

    showDiscountError(discount) {
        showToast(
            this,
            'Invalid discount',
            'Maximum discount of '+ this.maxDiscount+'% exceeded (' + evenRound(discount) + ')',
            'warning'
        );
    }

    handleGroupLevelChange(item, eventData) {
        const oldSalesMargin = item.salesMargin;
        const oldSalesPrice = item.salesPrice;
        const oldValue = item[eventData.fieldName];
        const value = eventData.value;
        item[eventData.fieldName] = value;
        if (['salesPrice', 'salesMargin'].includes(eventData.fieldName)) {
            if (eventData.fieldName === 'salesPrice') {
                item.salesMargin = this.calculateSalesMargin(item);
            } else if (eventData.fieldName === 'salesMargin') {
                item.salesPrice = roundNumber(this.calculateSalesPrice(item));
            }
            const discount = this.calculateDiscount(item);
            // Display Message if User is Sales User and Discount exceeds the threshold
            if (discount > this.maxDiscount) {
                this.showDiscountError(discount);
                item.salesMargin = oldSalesMargin;
                item.salesPrice = oldSalesPrice;
                return;
            }
            item.discount = discount;
            if (item.groupId === SUMMARY_0_GROUP_ID) {
                this.calculateDiscountOnAllChidren(
                    this.pricingTree.filter(
                        (groupItem) => ![SUMMARY_0_GROUP_ID, SUMMARY_VAT_GROUP_ID].includes(groupItem.groupId)
                    ),
                    'discount',
                    discount
                );
            }
            if (item.groupId === SUMMARY_VAT_GROUP_ID) {
                this.calculateDiscountOnAllChidren(
                    this.pricingTree.filter((groupItem) => ![SUMMARY_VAT_GROUP_ID].includes(groupItem.groupId)),
                    'discount',
                    discount
                );
            }
            if (item.children && item.children[0].level < 3) {
                this.calculateDiscountOnAllChidren(item.children, 'discount', discount);
            }
            this.recalculateAll();
            this.dirty = true;
        } else if (eventData.fieldName === 'discount') {
            if (item.discount >  this.maxDiscount) {
                this.showDiscountError(item.discount);
                item.discount = oldValue;
                return;
            }
            if (item.groupId === SUMMARY_VAT_GROUP_ID) {
                this.calculateDiscountOnAllChidren(this.pricingTree, 'discount', item.discount);
            }
            this.calculateDiscountChange(item);
            this.recalculateAll();
            this.dirty = true;
        }
    }

    calculateDiscountOnAllChidren(items, field, value) {
        for (const item of items) {
            if (item.children) {
                this.calculateDiscountOnAllChidren(item.children, field, value);
            }
            item[field] = value;
            
            this.calculateDiscountChange(item);
        }
    }

    // When discount is explicitly modified in the UI
    calculateDiscountChange(item) {
        item.salesPrice = roundNumber((1 - item.discount / 100) * item.listPrice);
        item.salesMargin = this.calculateSalesMargin(item);
    }

    calculateDiscount(item) {
        if (item.listPrice) {
            return (1 - item.salesPrice / item.listPrice) * 100;
        }
        return 0;
    }

    calculateSalesMargin(item) {
        if (item.salesPrice) {
            // Is this correct ?? 
            return ((item.salesPrice - item.cost - item.factory) / item.salesPrice) * 100;
        }
        return 0;
    }

    calculateSalesPrice(item) {
        if (item.salesMargin !== 100) {
            return (-item.cost - item.factory) / (item.salesMargin / 100 - 1);
        }
        return 0;
    }

    handleValueChange(event) {
        const eventData = event.detail;
        const item = this.pricingData.find((o) => o.id === eventData.id);
        if (item.level < 2) {
            this.handleGroupLevelChange(item, eventData);
        }
        this.recalculateAll();
        this.pricingData = [...this.pricingData];
    }

    handleExpandCollapse(event) {
        const eventData = event.detail;
        const item = this.pricingData.find((o) => o.id === eventData.id);
        if (item?.expandable) {
            item.expanded = !item.expanded;
            if (!item.expanded) {
                collapseTree(item.children);
            }
            updateExpandCollapse(this.pricingTree);
            this.pricingData = [...this.pricingData];
        }
    }

    get showSpinner() {
        return !this.intialized || this.processing;
    }

    openFullScreen() {
        this.fullScreen = true;
    }

    exitFullScreen() {
        this.fullScreen = false;
    }

    get pristine() {
        return !this.dirty;
    }

    get saveDisabled() {
        return !this.dirty || !this.intialized || this.processing;
    }
    
    serializePricingTree(pricingTree, tree) {
        for(const item of pricingTree) {
            const optimizedItem = {
                id: item.id,
                name: item.name,
                factory: item.factory,
                cost: item.cost,
                listPrice: item.listPrice,
                salesPrice: item.salesPrice,
                salesMargin: item.salesMargin,
                discount: item.discount,
                quantity: item.quantity,
                children: [],
            }
            tree.push(optimizedItem);
            if(item.children) {
                this.serializePricingTree(item.children, optimizedItem.children);
            }
        }
        return tree;
    }

    async handleSaveChanges() {
        this.processing = true;
        try {
            const summary0 = this.pricingTree.find((item) => item.groupId === SUMMARY_0_GROUP_ID);
            await saveData({
                opportunityId: this.recordId,
                pricingSummary: {
                    Id: this.pricingSummary.Id,
                    Sales_Price__c: summary0.salesPrice,
                    Sales_Margin__: summary0.salesMargin,
                    Discount__c: summary0.discount,
                    Pricing_Changes__c: JSON.stringify(this.serializePricingTree(this.pricingTree, [])),
                },
                quoteLineItems: this.pricingData
                    .filter((item) => item.level > 2)
                    .map((item) => ({
                        Id: item.recordId,
                        UnitPrice: item.salesPrice / item.quantity,
                        Discount__c: item.discount,
                        Discount: 0
                    }))
            });
            showToast(this, 'Saved', 'Pricing changes saved', 'success');
            // This would update data on other components but causes this component to refresh as well
            // refreshApex(this.opportunity);
            // notifyRecordUpdateAvailable([{ recordId: this.recordId }]);
            this.dirty = false;
        } catch (e) {
            showToast(this, 'We hit a snag', reduceErrors(e), 'error', 'sticky');
        }
        this.processing = false;
    }

    async handleRefresh() {
        await this.init();
    }
}