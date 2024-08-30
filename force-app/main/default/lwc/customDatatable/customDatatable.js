import { LightningElement, api } from "lwc";
import numberDecimalSeparator from "@salesforce/i18n/number.decimalSeparator";
import numberGroupingSeparator from "@salesforce/i18n/number.groupingSeparator";
import { showToast } from "c/lwcUtils";
import { loadStyle } from "lightning/platformResourceLoader";
export default class CustomDatatable extends LightningElement {
    @api customStylePath;
    @api tableClass;
    @api flexipageRegionWidth;
    @api fullWidth;
    @api sortBy;
    @api sortOrder;
    @api keyField;
    @api columns;
    headerColumns;
    @api
    get tableData() {
        return this._tableData;
    }
    _tableData;
    _data;
    get noData() {
        return !this._data || !this._data.length;
    }

    initialized = false;
    stylesLoaded = false;
    
    actionPending = null;

    renderedCallback() {
        this.init();
    }

    get tableClasses() {
        return (
            "slds-table "+
            "slds-no-row-hover slds-table_bordered slds-table_col-bordered" + //slds-table_fixed-layout" +
            (this.tableClass ? " " + this.tableClass : "") +
            (!this.fullWidth ? " variable-width" : "" )
        );
    }

    async init() {
        if (this.customStylePath && !this.stylesLoaded) {
            await loadStyle(this, this.customStylePath);
            this.stylesLoaded = true;
        }
        if (this.initialized) {
            return;
        }
        this.initialized = true;

        this.template.addEventListener("click", this.handleClick);
        this.template.addEventListener("dblclick", this.handleDoubleClick);
        // TODO this one is a bit too greedy. Think about doing this only with required elements.
        this.template.addEventListener("change", this.handleChange);
        this.template.addEventListener("keydown", this.handleMouseOrKeyDown);
        this.template.addEventListener("mousedown", this.handleMouseOrKeyDown);
    }

    disconnectedCallback() {
        this.initialized = false;
        this.template.removeEventListener("click", this.handleClick);
        this.template.removeEventListener("dblclick", this.handleDoubleClick);
        this.template.removeEventListener("keydown", this.handleMouseOrKeyDown);
        this.template.removeEventListener("mousedown", this.handleMouseOrKeyDown);
    }
    
    handleMouseOrKeyDown = (event) => {
        if(event.target.tagName === "BUTTON" && this.template.activeElement.tagName === "INPUT") {
            this.actionPending = event;
        }
    }

    handleLookupUpdate(event) {
        const tdElement = this.findEventElement(event.target, "TD");
        this.dispatchEvent(
            new CustomEvent("lookupchanged", {
                detail: {
                    value: event.detail,
                    id: tdElement.dataset.id,
                    fieldName: tdElement.dataset.fieldName,
                },
            })
        );
    }

    handleLookupSearch(event) {
        this.handleChange(event, true);
    }
    
    handleChange = (event, lookupSearch) => {
        const actionPending = this.actionPending ? {...this.actionPending} : null;
        this.actionPending = null;

        const tdElement = this.findEventElement(event.target, "TD");
        if (!tdElement) {
            return;
        }
        const inputElement = this.findEventElement(event.target, "INPUT");
        const column = this.columns.find((col) => col.fieldName === tdElement.dataset.fieldName);
        let value;
        if (lookupSearch) {
            column.cellAttributes.search({
                ...column.cellAttributes.filters,
                searchText: event.detail.value,
            });
            return;
        } else if (inputElement) {
            value = inputElement.value;
            if (column.type === "number") {
                value = this.parseNumber(value);
                if (isNaN(value) || (column.validator && column.validator(value))) {
                    // TODO Move this validation outside of this component
                    showToast(this, "Invalid number", "The value has to be numeric and < 100", "warning");
                    value = this.formatNumber(inputElement.defaultValue);
                    inputElement.value = isNaN(value) ? 0 : value;
                    return;
                }
            } else if (column.type === "checkbox") {
                value = inputElement.checked;
            }
            inputElement.defaultValue = inputElement.value;
        } else if (event.detail) {
            value = event.detail.value;
        }

        if(actionPending !== null) {
            this.dispatchEvent(
                new CustomEvent("actionvaluechanged", {
                    detail: {
                        id: tdElement.dataset.id,
                        action: "save", //this.findEventElement(actionPending.target, "BUTTON").dataset.id,
                        value,
                        fieldName: tdElement.dataset.fieldName,
                    },
                })
            );
        } else {
            this.dispatchEvent(
                new CustomEvent("valuechanged", {
                    detail: {
                        value,
                        id: tdElement.dataset.id,
                        fieldName: tdElement.dataset.fieldName,
                    },
                })
            );
        }
    };

    handleDoubleClick = (event) => {
        const tdElement = this.findEventElement(event.target, "TD");
        const fieldName = tdElement.dataset.fieldName;
        const column = this.columns.find((col) => col.fieldName === fieldName);
        if (tdElement && column) {
            this.dispatchEvent(
                new CustomEvent("doubleclick", {
                    detail: {
                        id: tdElement.dataset.id,
                        fieldName: tdElement.dataset.fieldName,
                    },
                })
            );
        }
    };

    handleClick = (event) => {
        console.log(event.target.nodeName);
        const tdElement = this.findEventElement(event.target, "TD");
        const thElement = this.findEventElement(event.target, "TH");
        const fieldName = (tdElement || thElement).dataset.fieldName;
        const column = this.columns.find((col) => col.fieldName === fieldName);
        if(thElement && column) {
            if(column.sortable) {
                this.dispatchEvent(
                    new CustomEvent("sort", {
                        detail: {
                            fieldName,
                        }
                    })
                );
            }
            return;
        }
        if (tdElement && column) {
            if (column.type === "expandable") {
                this.dispatchEvent(
                    new CustomEvent("expandcollapse", {
                        detail: {
                            id: tdElement.dataset.id,
                            fieldName,
                        },
                    })
                );
            } else if (["icon", "link"].includes(column.type)) {
                this.dispatchEvent(
                    new CustomEvent("linkclick", {
                        detail: {
                            id: tdElement.dataset.id,
                            fieldName,
                        },
                    })
                );
            } else if (column.type === "actions") {
                const buttonElement = this.findEventElement(event.target, "BUTTON");
                this.dispatchEvent(
                    new CustomEvent("action", {
                        detail: {
                            id: tdElement.dataset.id,
                            action: buttonElement.dataset.id,
                        },
                    })
                );
            }
        }
    };

    findEventElement(eventTarget, tagName) {
        let element;
        while (!element && eventTarget) {
            if (eventTarget.tagName === tagName) {
                element = eventTarget;
                break;
            }
            eventTarget = eventTarget.parentNode;
        }
        return element;
    }

    set tableData(value) {
        console.log("set tableData", value);
        this._tableData = value;
        this._data = [];
        if (value) {
            this.initData(this._tableData, this._data);
        }
    }

    columnTypes = {
        number: "isNumber",
        text: "isText",
        expandable: "isExpandable",
        actions: "isAction",
        picklist: "isPicklist",
        lookup: "isLookup",
        icon: "isIcon",
        link: "isLink",
        checkbox: "isCheckbox",
    };
    addColumnType(item) {
        if (this.columnTypes[item.type]) {
            item[this.columnTypes[item.type]] = true;
        }
        return item;
    }

    initData(items, data) {
        if (!items || !items.length) {
            return;
        }
        // The JSON roundrip is needed for the headerClasses sort classes
        this.headerColumns = JSON.parse(JSON.stringify(this.columns));
        for (const column of this.headerColumns) {
            if(column.sortable) {
                column.headerClass = (column.headerClass ? column.headerClass : "")
                    + (column.sortable
                        ? " sortable" + (this.sortBy === column.fieldName ? (this.sortOrder === "ASC" ? " sort-asc" : " sort-desc") : "")
                        : "");

            }
        }
        for (const item of items) {
            const tableItem = {
                key: item[this.keyField],
                hidden:
                    item.hidden ||
                    (typeof item.hiddenFromUser === "function" ? item.hiddenFromUser(item) : item.hiddenFromUser),
                columns: [],
            };
            for (const column of this.columns) {
                let picklistValues = [];
                if (column.cellAttributes?.dependentField) {
                    picklistValues = column.cellAttributes?.dependentValues[item[column.cellAttributes.dependentField]];
                } else if (column.cellAttributes?.values) {
                    picklistValues = column.cellAttributes?.values;
                }

                tableItem.columns.push(
                    this.addColumnType({
                        key: tableItem.key + "-" + column.fieldName,
                        value: column.type === "number"
                                ? this.formatNumber(item[column.fieldName])
                                : item[column.fieldName],
                        record: column.type === "lookup" && typeof column.cellAttributes?.defaultRecord === "function"
                                ? column.cellAttributes?.defaultRecord(item) : null,
                        fields: column.cellAttributes?.fields,
                        lookupSearchClass: column.cellAttributes?.searchImplementation,
                        type: column.type,
                        fieldName: column.fieldName,
                        id: item.id,
                        editable: typeof column.editable === "function" ? column.editable(item) : column.editable,
                        expanded: item.expanded,
                        expandable: item.expandable,
                        disabled: typeof column.disabled === "function" ? column.disabled(item) : false,
                        iconName: item.expandable
                            ? item.expanded
                                ? column.cellAttributes?.expandedIcon
                                : column.cellAttributes?.collapsedIcon
                            : typeof column.cellAttributes?.iconName === "function"
                                ? column.cellAttributes?.iconName(item) 
                                : column.cellAttributes?.iconName,
                        iconClass: typeof column.cellAttributes?.iconClass === "function"
                                    ? column.cellAttributes?.iconClass(item) 
                                    : column.cellAttributes?.iconClass ,
                        iconVariant: typeof column.cellAttributes?.iconVariant === "function"
                                    ? column.cellAttributes?.iconVariant(item) 
                                    : column.cellAttributes?.iconVariant ,
                        iconSize: typeof column.cellAttributes?.iconSize === "function"
                                    ? column.cellAttributes?.iconSize(item) 
                                    : column.cellAttributes?.iconSize ,
                        class: (column.class ? column.class : "") + (item.class ? " " + item.class : ""),
                        columnClass: (column.class ? column.class : ""),
                        itemClass: (item.class ? " " + item.class : ""),
                        cellClass: (column.cellAttributes?.class ? column.cellAttributes.class : ""),
                        valueHidden: typeof column.valueHidden === "function" ? column.valueHidden(item) : undefined,
                        actions: column.cellAttributes?.values
                            ? column.cellAttributes.values
                                  .filter((o) => {
                                      if (typeof o.visible === "function") {
                                          return o.visible(item);
                                      }
                                      return true;
                                  })
                                  .map((o) => ({
                                      ...o,
                                      label: typeof o.label === "function" ? o.label(item) : o.label,
                                      class: typeof o.class === "function" ? o.class(item) : o.class,
                                      disabled: typeof o.disabled === "function" ? o.disabled(item) : false,
                                  }))
                            : null,
                        options: picklistValues,
                    })
                );
                tableItem.columns[0].class += " level level-" + item.level;
            }
            data.push(tableItem);

            // In case a support for a real tree structure is needed. At the moment a flat list is expected.
            // if (item.children) {
            //     this.initData(item.children, data);
            // }
        }
        if(this.sortBy) {
            const sortOrder = this.sortOrder === "ASC" ? 1 : -1;
            data.sort((a, b) => {
                const valueA = a.columns.find((col) => col.fieldName === this.sortBy).value;
                const valueB = b.columns.find((col) => col.fieldName === this.sortBy).value;
                return valueA + "" > valueB + "" ? (sortOrder)
                    : valueA + "" === valueB + "" ? 0
                    : (-sortOrder);
            });
        }
    }

    formatNumber(value = 0, decimals = 2) {
        return parseFloat(value)
            .toFixed(decimals ? decimals : 0)
            .replace(/\B(?=(\d{3})+(?!\d))/g, " ")
            .replace(/\./g, numberDecimalSeparator);
    }

    parseNumber(stringValue = "") {
        let value = stringValue
            .split(numberGroupingSeparator)
            .join("")
            .replace(/ /g, "")
            .split(numberDecimalSeparator)
            .join(".");
        if (!/^-?\d+(?:[.]\d*?)?$/.test(value)) {
            return isNaN;
        }
        return parseFloat(value);
    }
}