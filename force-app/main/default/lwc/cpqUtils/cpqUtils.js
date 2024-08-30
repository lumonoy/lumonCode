export function getFieldValue(object, field) {
    if (!field) return null;
    if (field.indexOf(".") === -1) {
        return object[field];
    }
    return getFieldValue(object[field.substr(0, field.indexOf("."))], field.substr(field.indexOf(".") + 1));
}

export function flattenTree(tree, items) {
    for (const item of tree) {
        items.push(item);
        if (item.children) {
            flattenTree(item.children, items);
        }
    }
    return items;
}

export function collapseTree(items) {
    for (const item of items) {
        if (item.expandable) {
            item.expanded = false;
        }
        item.hidden = true;
        if (item.children) {
            collapseTree(item.children);
        }
    }
}

export function updateExpandCollapse(items, parent) {
    for (const item of items) {
        if (parent) {
            item.hidden = !parent.expanded;
        }
        if (item.children) {
            updateExpandCollapse(item.children, item);
        }
    }
}

export function evenRound(num, decimalPlaces = 2) {
    var d = decimalPlaces || 0;
    var m = Math.pow(10, d);
    var n = +(d ? num * m : num).toFixed(8);
    var i = Math.floor(n),
        f = n - i;
    var e = 1e-8;
    var r = f > 0.5 - e && f < 0.5 + e ? (i % 2 === 0 ? i : i + 1) : Math.round(n);
    return d ? r / m : r;
}
export function roundNumber(floatNumber) {
    return +floatNumber.toFixed(7);
}
import { ShowToastEvent } from "lightning/platformShowToastEvent";

/**
 * Reduces one or more LDS errors into a string[] of error messages.
 * @param {FetchResponse|FetchResponse[]} errors
 * @return {String[]} Error messages
 */
export function reduceErrors(errors) {
    if (!Array.isArray(errors)) {
        errors = [errors];
    }

    return (
        errors
            // Remove null/undefined items
            .filter((error) => !!error)
            // Extract an error message
            .map((error) => {
                // UI API read errors
                if (Array.isArray(error.body)) {
                    return error.body.map((e) => e.message);
                }
                // Page level errors
                else if (
                    error?.body?.pageErrors &&
                    error.body.pageErrors.length > 0
                ) {
                    return error.body.pageErrors.map((e) => e.message);
                }
                // Field level errors
                else if (
                    error?.body?.fieldErrors &&
                    Object.keys(error.body.fieldErrors).length > 0
                ) {
                    const fieldErrors = [];
                    Object.values(error.body.fieldErrors).forEach(
                        (errorArray) => {
                            fieldErrors.push(
                                ...errorArray.map((e) => e.message)
                            );
                        }
                    );
                    return fieldErrors;
                }
                // UI API DML page level errors
                else if (
                    error?.body?.output?.errors &&
                    error.body.output.errors.length > 0
                ) {
                    return error.body.output.errors.map((e) => e.message);
                }
                // UI API DML field level errors
                else if (
                    error?.body?.output?.fieldErrors &&
                    Object.keys(error.body.output.fieldErrors).length > 0
                ) {
                    const fieldErrors = [];
                    Object.values(error.body.output.fieldErrors).forEach(
                        (errorArray) => {
                            fieldErrors.push(
                                ...errorArray.map((e) => e.message)
                            );
                        }
                    );
                    return fieldErrors;
                }
                // UI API DML, Apex and network errors
                else if (error.body && typeof error.body.message === 'string') {
                    return error.body.message;
                }
                // JS errors
                else if (typeof error.message === 'string') {
                    return error.message;
                }
                // Unknown error shape so try HTTP status text
                return error.statusText;
            })
            // Flatten
            .reduce((prev, curr) => prev.concat(curr), [])
            // Remove empty strings
            .filter((message) => !!message)
    );
}

/**
 * Method for showing toast messages in LWC components.
 * @param {object} context
 * @param {string} title The title of the toast, displayed as a heading.
 * @param {(string | string[])} messages 	A string (or array of strings) containing a message for the user.
 * @param {string} variant The theme and icon displayed in the toast
 * @param {string} mode Determines how persistent the toast is
 * @see https://developer.salesforce.com/docs/component-library/documentation/en/lwc/lwc.use_toast
 */
export function showToast(context, title, messages, variant, mode) {
  context.dispatchEvent(
    new ShowToastEvent({
      title,
      message: Array.isArray(messages) ? messages.join("\n") : messages,
      variant,
      mode,
    })
  );
}

export async function asyncCall(context, fn) {
    context.processing = true;
    try {
        await fn(); 
    } catch(e) {
        showToast(context, "Error", reduceErrors(e), "error");
    }
    context.processing = false;
}