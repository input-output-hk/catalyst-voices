"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.sendMessage = void 0;
const config_1 = require("@trezor/connect/lib/data/config");
const events_1 = require("@trezor/connect/lib/events");
const sendMessage = (message, origin) => {
    window.parent.postMessage(message, origin);
};
exports.sendMessage = sendMessage;
const broadcastPermissionFinished = () => {
    const channel = new BroadcastChannel(events_1.WEBEXTENSION.USB_PERMISSIONS_BROADCAST);
    channel.postMessage({ type: events_1.WEBEXTENSION.USB_PERMISSIONS_FINISHED });
    channel.close();
};
const onLoad = () => {
    (0, exports.sendMessage)(events_1.WEBEXTENSION.USB_PERMISSIONS_INIT, '*');
};
const init = (label) => {
    const extensionName = document.getElementsByClassName('extension-name')[0];
    extensionName.innerText = label;
    const usbButton = document.getElementsByClassName('confirm')[0];
    const cancelButton = document.getElementsByClassName('cancel')[0];
    usbButton.onclick = async () => {
        const { usb } = navigator;
        if (usb) {
            try {
                await usb.requestDevice({ filters: config_1.config.webusb });
                (0, exports.sendMessage)(events_1.WEBEXTENSION.USB_PERMISSIONS_CLOSE, '*');
                broadcastPermissionFinished();
            }
            catch (error) {
            }
        }
    };
    cancelButton.onclick = () => {
        (0, exports.sendMessage)(events_1.WEBEXTENSION.USB_PERMISSIONS_CLOSE, '*');
    };
};
const handleMessage = ({ data, origin }) => {
    if (data && data.type === events_1.WEBEXTENSION.USB_PERMISSIONS_INIT) {
        window.removeEventListener('message', handleMessage, false);
        const knownHost = config_1.config.knownHosts.find(host => host.origin === data.extension);
        const label = knownHost && knownHost.label ? knownHost.label : origin;
        init(label);
    }
};
window.addEventListener('load', onLoad, false);
window.addEventListener('message', handleMessage, false);
//# sourceMappingURL=extensionPermissions.js.map