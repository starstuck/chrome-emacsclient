/*global chrome*/

/**
 * TODO: Add some authentication token to improve security of connection. Somehow there should be way to
 *       pair emacs and browser
 */
function EmacsClient() {
    var host = 'localhost',
        port = 8080;

    function visit(resource, lineNo) {
        var req = new XMLHttpRequest();
        req.open('POST', 'http://' + host + ':' + port + '/chromeserv/visit');
        req.onerror = function() {
            alert('There was error sending request to emacs: '  +req.statusText);
        };
        req.send([
            'url=' + encodeURIComponent(resource.url),
            'line=' + lineNo
        ].join('&'));
    };

    this.visit = visit;
};

var client = new EmacsClient();
chrome.devtools.panels.setOpenResourceHandler(client.visit);
