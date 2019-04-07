try {
    var compQuery = arguments[0];
    compQuery = arguments[0].replace(/\[([^\[\]~^]*)=([^\[\]"]*)\]/g, function (a, attr, value) {
        var valRegex = '';
        for (var i = 0; i < value.length; i++) {
            var code = value.charCodeAt(i);
            var char = value.charAt(i);
            if (code > 64 && code < 91) {
                valRegex += '[' + char + char.toLowerCase() + ']';
            }
            else if (code > 96 && code < 123) {
                valRegex += '[' + char.toUpperCase() + char + ']';
            }
            else {
                valRegex += '[' + char + ']';
            }
        }
        return '[' + attr + '/="' + valRegex + '"]';
    });

    return compQuery;
} catch (e) {}