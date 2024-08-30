function getFieldValue(object, field) {
    if (!field) return null;
    if (field.indexOf(".") === -1) {
        return object[field];
    }
    return getFieldValue(object[field.substr(0, field.indexOf("."))], field.substr(field.indexOf(".") + 1));
}

function flattenTree(tree, items) {
    for (const item of tree) {
        items.push(item);
        if (item.children) {
            flattenTree(item.children, items);
        }
    }
    return items;
}

function collapseTree(items) {
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

function updateExpandCollapse(items, parent) {
    for (const item of items) {
        if (parent) {
            item.hidden = !parent.expanded;
        }
        if (item.children) {
            updateExpandCollapse(item.children, item);
        }
    }
}

function evenRound(num, decimalPlaces = 2) {
    var d = decimalPlaces || 0;
    var m = Math.pow(10, d);
    var n = +(d ? num * m : num).toFixed(8);
    var i = Math.floor(n),
        f = n - i;
    var e = 1e-8;
    var r = f > 0.5 - e && f < 0.5 + e ? (i % 2 === 0 ? i : i + 1) : Math.round(n);
    return d ? r / m : r;
}

export { getFieldValue, flattenTree, collapseTree, updateExpandCollapse, evenRound };