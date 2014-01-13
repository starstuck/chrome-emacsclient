/*global chrome*/

function handleOpenResource(resource, lineNo) {
    alert('Resource opened: ' + resource.url + ':' + lineNo);
    console.log('Asked to open resource: ', resource.url, lineNo);
}

setTimeout(function() {

    chrome.devtools.panels.setOpenResourceHandler(handleOpenResource);
    alert('extension loaded:' + chrome.devtools.panels.setOpenResourceHandler);

}, 1000);


//TODO: use chrome.devtools.inspectedWindow.onResourceContentCommitted.addListener to send updated
// content to editor
