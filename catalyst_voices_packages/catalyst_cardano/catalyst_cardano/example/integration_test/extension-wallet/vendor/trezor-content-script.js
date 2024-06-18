"use strict";
let port = chrome.runtime.connect({ name: 'trezor-connect' });
port.onMessage.addListener(message => {
    window.postMessage(message, window.location.origin);
});
port.onDisconnect.addListener(() => {
    port = null;
});
window.addEventListener('message', event => {
    if (port && event.source === window && event.data) {
        port.postMessage({ data: event.data });
    }
});
//# sourceMappingURL=trezor-content-script.js.map