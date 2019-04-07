try {
    var compQuery = arguments[0];
    var idFn = arguments[1];

    var comp = Ext.ComponentQuery.query(compQuery)[0];
    var elId;
    if (typeof comp[idFn] === 'function') {
        elId = comp[idFn]();
    }
    else {
        elId = comp[idFn];
    }
    return window.document.getElementById(elId);
} catch (e) {}