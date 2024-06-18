(function webpackUniversalModuleDefinition(root, factory) {
	if(typeof exports === 'object' && typeof module === 'object')
		module.exports = factory();
	else if(typeof define === 'function' && define.amd)
		define([], factory);
	else if(typeof exports === 'object')
		exports["TrezorConnect"] = factory();
	else
		root["TrezorConnect"] = factory();
})(self, () => {
return /******/ (() => { // webpackBootstrap
/******/ 	"use strict";
/******/ 	var __webpack_modules__ = ({

/***/ 776:
/***/ ((__unused_webpack_module, exports) => {



Object.defineProperty(exports, "__esModule", ({
  value: true
}));
exports.LIBUSB_ERROR_MESSAGE = exports.serializeError = exports.TypedError = exports.TrezorError = exports.ERROR_CODES = void 0;
exports.ERROR_CODES = {
  Init_NotInitialized: 'TrezorConnect not initialized',
  Init_AlreadyInitialized: 'TrezorConnect has been already initialized',
  Init_IframeBlocked: 'Iframe blocked',
  Init_IframeTimeout: 'Iframe timeout',
  Init_ManifestMissing: 'Manifest not set. Read more at https://github.com/trezor/trezor-suite/blob/develop/docs/packages/connect/index.md',
  Popup_ConnectionMissing: 'Unable to establish connection with iframe',
  Transport_Missing: 'Transport is missing',
  Transport_InvalidProtobuf: '',
  Method_InvalidPackage: 'This package is not suitable to work with browser. Use @trezor/connect-web package instead',
  Method_InvalidParameter: '',
  Method_NotAllowed: 'Method not allowed for this configuration',
  Method_PermissionsNotGranted: 'Permissions not granted',
  Method_Cancel: 'Cancelled',
  Method_Interrupted: 'Popup closed',
  Method_UnknownCoin: 'Coin not found',
  Method_AddressNotMatch: 'Addresses do not match',
  Method_FirmwareUpdate_DownloadFailed: 'Failed to download firmware binary',
  Method_Discovery_BundleException: '',
  Method_Override: 'override',
  Method_NoResponse: 'Call resolved without response',
  Backend_NotSupported: 'BlockchainLink settings not found in coins.json',
  Backend_WorkerMissing: '',
  Backend_Disconnected: 'Backend disconnected',
  Backend_Invalid: 'Invalid backend',
  Backend_Error: '',
  Runtime: '',
  Device_NotFound: 'Device not found',
  Device_InitializeFailed: '',
  Device_FwException: '',
  Device_ModeException: '',
  Device_Disconnected: 'Device disconnected',
  Device_UsedElsewhere: 'Device is used in another window',
  Device_InvalidState: 'Passphrase is incorrect',
  Device_CallInProgress: 'Device call in progress'
};
class TrezorError extends Error {
  constructor(code, message) {
    super(message);
    this.code = code;
    this.message = message;
  }
}
exports.TrezorError = TrezorError;
const TypedError = (id, message) => new TrezorError(id, message || exports.ERROR_CODES[id]);
exports.TypedError = TypedError;
const serializeError = payload => {
  if (payload && payload.error instanceof Error) {
    return {
      error: payload.error.message,
      code: payload.error.code
    };
  }
  return payload;
};
exports.serializeError = serializeError;
exports.LIBUSB_ERROR_MESSAGE = 'LIBUSB_ERROR';

/***/ }),

/***/ 608:
/***/ ((__unused_webpack_module, exports, __webpack_require__) => {

var __webpack_unused_export__;


__webpack_unused_export__ = ({
  value: true
});
exports.E = void 0;
const constants_1 = __webpack_require__(528);
exports.E = {
  webusb: constants_1.TREZOR_USB_DESCRIPTORS,
  whitelist: [{
    origin: 'chrome-extension://imloifkgjagghnncjkhggdhalmcnfklk',
    priority: 1
  }, {
    origin: 'chrome-extension://niebkpllfhmpfbffbfifagfgoamhpflf',
    priority: 1
  }, {
    origin: 'file://',
    priority: 2
  }, {
    origin: 'trezor.io',
    priority: 0
  }, {
    origin: 'sldev.cz',
    priority: 0
  }, {
    origin: 'localhost',
    priority: 0
  }, {
    origin: 'trezoriovpjcahpzkrewelclulmszwbqpzmzgub37gbcjlvluxtruqad.onion',
    priority: 0
  }],
  management: [{
    origin: 'trezor.io'
  }, {
    origin: 'sldev.cz'
  }, {
    origin: 'localhost'
  }],
  knownHosts: [{
    origin: 'imloifkgjagghnncjkhggdhalmcnfklk',
    label: 'Trezor Password Manager (Develop)',
    icon: ''
  }, {
    origin: 'niebkpllfhmpfbffbfifagfgoamhpflf',
    label: 'Trezor Password Manager',
    icon: ''
  }, {
    origin: 'mnpfhpndmjholfdlhpkjfmjkgppmodaf',
    label: 'MetaMask',
    icon: ''
  }, {
    origin: 'webextension@metamask.io',
    label: 'MetaMask',
    icon: ''
  }, {
    origin: 'nkbihfbeogaeaoehlefnkodbefgpgknn',
    label: 'MetaMask',
    icon: ''
  }, {
    origin: 'file://',
    label: ' ',
    icon: ''
  }],
  onionDomains: {
    'trezor.io': 'trezoriovpjcahpzkrewelclulmszwbqpzmzgub37gbcjlvluxtruqad.onion'
  },
  assets: [{
    name: 'coins',
    url: './data/coins.json'
  }, {
    name: 'coinsEth',
    url: './data/coins-eth.json'
  }, {
    name: 'bridge',
    url: './data/bridge/releases.json'
  }, {
    name: 'firmware-t1b1',
    url: './data/firmware/t1b1/releases.json'
  }, {
    name: 'firmware-t2t1',
    url: './data/firmware/t2t1/releases.json'
  }, {
    name: 'firmware-t2b1',
    url: './data/firmware/t2b1/releases.json'
  }],
  messages: './data/messages/messages.json',
  supportedBrowsers: {
    chrome: {
      version: 59,
      download: 'https://www.google.com/chrome/',
      update: 'https://support.google.com/chrome/answer/95414'
    },
    chromium: {
      version: 59,
      download: 'https://www.chromium.org/',
      update: 'https://www.chromium.org/'
    },
    electron: {
      version: 0,
      download: 'https://www.electronjs.org/',
      update: 'https://www.electronjs.org/'
    },
    firefox: {
      version: 54,
      download: 'https://www.mozilla.org/en-US/firefox/new/',
      update: 'https://support.mozilla.org/en-US/kb/update-firefox-latest-version'
    }
  },
  supportedFirmware: [{
    coin: ['xrp', 'txrp'],
    methods: ['getAccountInfo'],
    min: {
      T1B1: '0',
      T2T1: '2.1.0'
    },
    max: undefined,
    comment: ["Since firmware 2.1.0 there is a new protobuf field 'destination_tag' in RippleSignTx"]
  }, {
    coin: ['bnb'],
    min: {
      T1B1: '1.9.0',
      T2T1: '2.3.0'
    },
    comment: ['There were protobuf backwards incompatible changes with introduction of 1.9.0/2.3.0 firmwares']
  }, {
    coin: ['eth', 'tsep', 'tgor', 'thol'],
    min: {
      T1B1: '1.8.0',
      T2T1: '2.1.0'
    },
    comment: ['There were protobuf backwards incompatible changes.']
  }, {
    coin: ['ada', 'tada'],
    min: {
      T1B1: '0',
      T2T1: '2.4.3'
    },
    comment: ['Since 2.4.3 there is initialize.derive_cardano message']
  }, {
    methods: ['rippleGetAddress', 'rippleSignTransaction'],
    min: {
      T1B1: '0',
      T2T1: '2.1.0'
    },
    comment: ["Since firmware 2.1.0 there is a new protobuf field 'destination_tag' in RippleSignTx"]
  }, {
    methods: ['cardanoGetAddress', 'cardanoGetPublicKey'],
    min: {
      T1B1: '0',
      T2T1: '2.3.2'
    },
    comment: ['Shelley fork support since firmware 2.3.2']
  }, {
    methods: ['cardanoSignTransaction'],
    min: {
      T1B1: '0',
      T2T1: '2.4.2'
    },
    comment: ['Non-streamed signing no longer supported']
  }, {
    methods: ['cardanoGetNativeScriptHash'],
    min: {
      T1B1: '0',
      T2T1: '2.4.3'
    },
    comment: ['Cardano GetNativeScriptHash call added in 2.4.3']
  }, {
    methods: ['tezosSignTransaction'],
    min: {
      T1B1: '0',
      T2T1: '2.1.8'
    },
    comment: ['Since 2.1.8 there are new protobuf fields in tezos transaction (Babylon fork)']
  }, {
    methods: ['stellarSignTransaction'],
    min: {
      T1B1: '1.9.0',
      T2T1: '2.3.0'
    },
    comment: ['There were protobuf backwards incompatible changes with introduction of 1.9.0/2.3.0 firmwares']
  }, {
    capabilities: ['replaceTransaction', 'amountUnit'],
    min: {
      T1B1: '1.9.4',
      T2T1: '2.3.5'
    },
    comment: ['new sign tx process since 1.9.4/2.3.5']
  }, {
    capabilities: ['decreaseOutput'],
    min: {
      T1B1: '1.10.0',
      T2T1: '2.4.0'
    },
    comment: ['allow reduce output in RBF transaction since 1.10.0/2.4.0']
  }, {
    capabilities: ['eip1559'],
    min: {
      T1B1: '1.10.4',
      T2T1: '2.4.2'
    },
    comment: ['new eth transaction pricing mechanism (EIP1559) since 1.10.4/2.4.2']
  }, {
    capabilities: ['taproot', 'signMessageNoScriptType'],
    min: {
      T1B1: '1.10.4',
      T2T1: '2.4.3'
    },
    comment: ['new btc accounts taproot since 1.10.4/2.4.3 (BTC + TEST only)', 'SignMessage with no_script_type support']
  }, {
    coin: ['dcr', 'tdcr'],
    methods: ['signTransaction'],
    min: {
      T1B1: '1.10.1',
      T2T1: '2.4.0'
    },
    comment: ['']
  }, {
    methods: ['ethereumSignTypedData'],
    min: {
      T1B1: '1.10.5',
      T2T1: '2.4.3'
    },
    comment: ['EIP-712 typed signing support added in 1.10.5/2.4.3']
  }, {
    capabilities: ['eip712-domain-only'],
    min: {
      T1B1: '1.10.6',
      T2T1: '2.4.4'
    },
    comment: ['EIP-712 domain-only signing, when primaryType=EIP712Domain']
  }, {
    capabilities: ['coinjoin'],
    methods: ['authorizeCoinjoin', 'cancelCoinjoinAuthorization', 'getOwnershipId', 'getOwnershipProof', 'setBusy', 'unlockPath'],
    min: {
      T1B1: '1.12.1',
      T2T1: '2.5.3'
    }
  }, {
    methods: ['showDeviceTutorial', 'authenticateDevice'],
    min: {
      T1B1: '0',
      T2T1: '0',
      T2B1: '2.6.1'
    },
    comment: ['Only on T2B1']
  }, {
    methods: ['rebootToBootloader'],
    min: {
      T1B1: '1.10.0',
      T2T1: '2.6.0'
    }
  }, {
    methods: ['getFirmwareHash'],
    min: {
      T1B1: '1.11.1',
      T2T1: '2.5.1'
    }
  }, {
    methods: ['solanaGetPublicKey', 'solanaGetAddress', 'solanaSignTransaction'],
    min: {
      T1B1: '0',
      T2T1: '2.6.4',
      T2B1: '2.6.4'
    }
  }, {
    capabilities: ['chunkify'],
    min: {
      T1B1: '0',
      T2T1: '2.6.3',
      T2B1: '2.6.3'
    },
    comment: ["Since firmware 2.6.3 there is a new protobuf field 'chunkify' in almost all getAddress and signTx methods"]
  }]
};

/***/ }),

/***/ 632:
/***/ ((__unused_webpack_module, exports, __webpack_require__) => {

var __webpack_unused_export__;


__webpack_unused_export__ = ({
  value: true
});
exports.a8 = exports.yq = exports.qQ = void 0;
const version_1 = __webpack_require__(187);
exports.qQ = 2;
const initialSettings = {
  configSrc: './data/config.json',
  version: version_1.VERSION,
  debug: false,
  priority: exports.qQ,
  trustedHost: true,
  connectSrc: version_1.DEFAULT_DOMAIN,
  iframeSrc: `${version_1.DEFAULT_DOMAIN}iframe.html`,
  popup: false,
  popupSrc: `${version_1.DEFAULT_DOMAIN}popup.html`,
  webusbSrc: `${version_1.DEFAULT_DOMAIN}webusb.html`,
  transports: undefined,
  pendingTransportEvent: true,
  env: 'node',
  lazyLoad: false,
  timestamp: new Date().getTime(),
  interactionTimeout: 600,
  sharedLogger: true
};
const parseManifest = manifest => {
  if (!manifest) return;
  if (typeof manifest.email !== 'string') return;
  if (typeof manifest.appUrl !== 'string') return;
  return {
    email: manifest.email,
    appUrl: manifest.appUrl
  };
};
const corsValidator = url => {
  if (typeof url !== 'string') return;
  if (url.match(/^https:\/\/([A-Za-z0-9\-_]+\.)*trezor\.io\//)) return url;
  if (url.match(/^https?:\/\/localhost:[58][0-9]{3}\//)) return url;
  if (url.match(/^https:\/\/([A-Za-z0-9\-_]+\.)*sldev\.cz\//)) return url;
  if (url.match(/^https?:\/\/([A-Za-z0-9\-_]+\.)*trezoriovpjcahpzkrewelclulmszwbqpzmzgub37gbcjlvluxtruqad\.onion\//)) return url;
};
exports.yq = corsValidator;
const parseConnectSettings = (input = {}) => {
  var _a;
  const settings = {
    ...initialSettings
  };
  if ('debug' in input) {
    if (typeof input.debug === 'boolean') {
      settings.debug = input.debug;
    } else if (typeof input.debug === 'string') {
      settings.debug = input.debug === 'true';
    }
  }
  if (input.trustedHost === false) {
    settings.trustedHost = input.trustedHost;
  }
  if (typeof input.connectSrc === 'string' && ((_a = input.connectSrc) === null || _a === void 0 ? void 0 : _a.startsWith('http'))) {
    settings.connectSrc = (0, exports.yq)(input.connectSrc);
  } else if (settings.trustedHost) {
    settings.connectSrc = input.connectSrc;
  }
  const src = settings.connectSrc || version_1.DEFAULT_DOMAIN;
  settings.iframeSrc = `${src}iframe.html`;
  settings.popupSrc = `${src}popup.html`;
  settings.webusbSrc = `${src}webusb.html`;
  if (typeof input.transportReconnect === 'boolean') {
    settings.transportReconnect = input.transportReconnect;
  }
  if (typeof input.webusb === 'boolean') {
    settings.webusb = input.webusb;
  }
  if (Array.isArray(input.transports)) {
    settings.transports = input.transports;
  }
  if (typeof input.popup === 'boolean') {
    settings.popup = input.popup;
  }
  if (typeof input.lazyLoad === 'boolean') {
    settings.lazyLoad = input.lazyLoad;
  }
  if (typeof input.pendingTransportEvent === 'boolean') {
    settings.pendingTransportEvent = input.pendingTransportEvent;
  }
  if (typeof input.extension === 'string') {
    settings.extension = input.extension;
  }
  if (typeof input.env === 'string') {
    settings.env = input.env;
  }
  if (typeof input.timestamp === 'number') {
    settings.timestamp = input.timestamp;
  }
  if (typeof input.interactionTimeout === 'number') {
    settings.interactionTimeout = input.interactionTimeout;
  }
  if (typeof input.manifest === 'object') {
    settings.manifest = parseManifest(input.manifest);
  }
  if (typeof input.sharedLogger === 'boolean') {
    settings.sharedLogger = input.sharedLogger;
  }
  if (typeof input.useCoreInPopup === 'boolean') {
    settings.useCoreInPopup = input.useCoreInPopup;
  }
  return settings;
};
exports.a8 = parseConnectSettings;

/***/ }),

/***/ 187:
/***/ ((__unused_webpack_module, exports) => {



Object.defineProperty(exports, "__esModule", ({
  value: true
}));
exports.DEFAULT_DOMAIN = exports.VERSION = void 0;
exports.VERSION = '9.2.1';
const versionN = exports.VERSION.split('.').map(s => parseInt(s, 10));
exports.DEFAULT_DOMAIN = `https://connect.trezor.io/${versionN[0]}/`;

/***/ }),

/***/ 996:
/***/ ((__unused_webpack_module, exports) => {



Object.defineProperty(exports, "__esModule", ({
  value: true
}));
exports.createBlockchainMessage = exports.BLOCKCHAIN = exports.BLOCKCHAIN_EVENT = void 0;
exports.BLOCKCHAIN_EVENT = 'BLOCKCHAIN_EVENT';
exports.BLOCKCHAIN = {
  CONNECT: 'blockchain-connect',
  RECONNECTING: 'blockchain-reconnecting',
  ERROR: 'blockchain-error',
  BLOCK: 'blockchain-block',
  NOTIFICATION: 'blockchain-notification',
  FIAT_RATES_UPDATE: 'fiat-rates-update'
};
const createBlockchainMessage = (type, payload) => ({
  event: exports.BLOCKCHAIN_EVENT,
  type,
  payload
});
exports.createBlockchainMessage = createBlockchainMessage;

/***/ }),

/***/ 91:
/***/ ((__unused_webpack_module, exports, __webpack_require__) => {



Object.defineProperty(exports, "__esModule", ({
  value: true
}));
exports.createResponseMessage = exports.RESPONSE_EVENT = void 0;
const errors_1 = __webpack_require__(776);
exports.RESPONSE_EVENT = 'RESPONSE_EVENT';
const createResponseMessage = (id, success, payload) => ({
  event: exports.RESPONSE_EVENT,
  type: exports.RESPONSE_EVENT,
  id,
  success,
  payload: success ? payload : (0, errors_1.serializeError)(payload)
});
exports.createResponseMessage = createResponseMessage;

/***/ }),

/***/ 336:
/***/ ((__unused_webpack_module, exports) => {



Object.defineProperty(exports, "__esModule", ({
  value: true
}));
exports.createErrorMessage = exports.parseMessage = exports.CORE_EVENT = void 0;
exports.CORE_EVENT = 'CORE_EVENT';
const parseMessage = messageData => {
  const message = {
    event: messageData.event,
    type: messageData.type,
    payload: messageData.payload
  };
  if (typeof messageData.id === 'number') {
    message.id = messageData.id;
  }
  if (typeof messageData.success === 'boolean') {
    message.success = messageData.success;
  }
  return message;
};
exports.parseMessage = parseMessage;
const createErrorMessage = error => ({
  success: false,
  payload: {
    error: error.message,
    code: error.code
  }
});
exports.createErrorMessage = createErrorMessage;

/***/ }),

/***/ 912:
/***/ ((__unused_webpack_module, exports) => {



Object.defineProperty(exports, "__esModule", ({
  value: true
}));
exports.createDeviceMessage = exports.DEVICE = exports.DEVICE_EVENT = void 0;
exports.DEVICE_EVENT = 'DEVICE_EVENT';
exports.DEVICE = {
  CONNECT: 'device-connect',
  CONNECT_UNACQUIRED: 'device-connect_unacquired',
  DISCONNECT: 'device-disconnect',
  CHANGED: 'device-changed',
  ACQUIRE: 'device-acquire',
  RELEASE: 'device-release',
  ACQUIRED: 'device-acquired',
  RELEASED: 'device-released',
  USED_ELSEWHERE: 'device-used_elsewhere',
  LOADING: 'device-loading',
  BUTTON: 'button',
  PIN: 'pin',
  PASSPHRASE: 'passphrase',
  PASSPHRASE_ON_DEVICE: 'passphrase_on_device',
  WORD: 'word'
};
const createDeviceMessage = (type, payload) => ({
  event: exports.DEVICE_EVENT,
  type,
  payload
});
exports.createDeviceMessage = createDeviceMessage;

/***/ }),

/***/ 360:
/***/ ((__unused_webpack_module, exports, __webpack_require__) => {



Object.defineProperty(exports, "__esModule", ({
  value: true
}));
exports.createIFrameMessage = exports.IFRAME = void 0;
const ui_request_1 = __webpack_require__(956);
exports.IFRAME = {
  BOOTSTRAP: 'iframe-bootstrap',
  LOADED: 'iframe-loaded',
  INIT: 'iframe-init',
  ERROR: 'iframe-error',
  CALL: 'iframe-call',
  LOG: 'iframe-log'
};
const createIFrameMessage = (type, payload) => ({
  event: ui_request_1.UI_EVENT,
  type,
  payload
});
exports.createIFrameMessage = createIFrameMessage;

/***/ }),

/***/ 660:
/***/ ((__unused_webpack_module, exports, __webpack_require__) => {



Object.defineProperty(exports, "__esModule", ({
  value: true
}));
exports.UI = void 0;
const tslib_1 = __webpack_require__(376);
const ui_request_1 = __webpack_require__(956);
const ui_response_1 = __webpack_require__(600);
tslib_1.__exportStar(__webpack_require__(996), exports);
tslib_1.__exportStar(__webpack_require__(91), exports);
tslib_1.__exportStar(__webpack_require__(336), exports);
tslib_1.__exportStar(__webpack_require__(912), exports);
tslib_1.__exportStar(__webpack_require__(360), exports);
tslib_1.__exportStar(__webpack_require__(176), exports);
tslib_1.__exportStar(__webpack_require__(324), exports);
tslib_1.__exportStar(__webpack_require__(124), exports);
tslib_1.__exportStar(__webpack_require__(956), exports);
tslib_1.__exportStar(__webpack_require__(600), exports);
tslib_1.__exportStar(__webpack_require__(948), exports);
exports.UI = {
  ...ui_request_1.UI_REQUEST,
  ...ui_response_1.UI_RESPONSE
};

/***/ }),

/***/ 176:
/***/ ((__unused_webpack_module, exports, __webpack_require__) => {



Object.defineProperty(exports, "__esModule", ({
  value: true
}));
exports.createPopupMessage = exports.POPUP = void 0;
const ui_request_1 = __webpack_require__(956);
exports.POPUP = {
  BOOTSTRAP: 'popup-bootstrap',
  LOADED: 'popup-loaded',
  CORE_LOADED: 'popup-core-loaded',
  INIT: 'popup-init',
  ERROR: 'popup-error',
  EXTENSION_USB_PERMISSIONS: 'open-usb-permissions',
  HANDSHAKE: 'popup-handshake',
  CLOSED: 'popup-closed',
  CANCEL_POPUP_REQUEST: 'ui-cancel-popup-request',
  CLOSE_WINDOW: 'window.close',
  ANALYTICS_RESPONSE: 'popup-analytics-response',
  CONTENT_SCRIPT_LOADED: 'popup-content-script-loaded',
  METHOD_INFO: 'popup-method-info'
};
const createPopupMessage = (type, payload) => ({
  event: ui_request_1.UI_EVENT,
  type,
  payload
});
exports.createPopupMessage = createPopupMessage;

/***/ }),

/***/ 324:
/***/ ((__unused_webpack_module, exports, __webpack_require__) => {



Object.defineProperty(exports, "__esModule", ({
  value: true
}));
exports.createTransportMessage = exports.TRANSPORT_EVENT = exports.TRANSPORT = void 0;
const errors_1 = __webpack_require__(776);
var constants_1 = __webpack_require__(528);
Object.defineProperty(exports, "TRANSPORT", ({
  enumerable: true,
  get: function () {
    return constants_1.TRANSPORT;
  }
}));
exports.TRANSPORT_EVENT = 'TRANSPORT_EVENT';
const createTransportMessage = (type, payload) => ({
  event: exports.TRANSPORT_EVENT,
  type,
  payload: 'error' in payload ? (0, errors_1.serializeError)(payload) : payload
});
exports.createTransportMessage = createTransportMessage;

/***/ }),

/***/ 124:
/***/ ((__unused_webpack_module, exports) => {



Object.defineProperty(exports, "__esModule", ({
  value: true
}));

/***/ }),

/***/ 956:
/***/ ((__unused_webpack_module, exports) => {



Object.defineProperty(exports, "__esModule", ({
  value: true
}));
exports.createUiMessage = exports.UI_REQUEST = exports.UI_EVENT = void 0;
exports.UI_EVENT = 'UI_EVENT';
exports.UI_REQUEST = {
  TRANSPORT: 'ui-no_transport',
  BOOTLOADER: 'ui-device_bootloader_mode',
  NOT_IN_BOOTLOADER: 'ui-device_not_in_bootloader_mode',
  REQUIRE_MODE: 'ui-device_require_mode',
  INITIALIZE: 'ui-device_not_initialized',
  SEEDLESS: 'ui-device_seedless',
  FIRMWARE_OLD: 'ui-device_firmware_old',
  FIRMWARE_OUTDATED: 'ui-device_firmware_outdated',
  FIRMWARE_NOT_SUPPORTED: 'ui-device_firmware_unsupported',
  FIRMWARE_NOT_COMPATIBLE: 'ui-device_firmware_not_compatible',
  FIRMWARE_NOT_INSTALLED: 'ui-device_firmware_not_installed',
  FIRMWARE_PROGRESS: 'ui-firmware-progress',
  DEVICE_NEEDS_BACKUP: 'ui-device_needs_backup',
  REQUEST_UI_WINDOW: 'ui-request_window',
  CLOSE_UI_WINDOW: 'ui-close_window',
  REQUEST_PERMISSION: 'ui-request_permission',
  REQUEST_CONFIRMATION: 'ui-request_confirmation',
  REQUEST_PIN: 'ui-request_pin',
  INVALID_PIN: 'ui-invalid_pin',
  REQUEST_PASSPHRASE: 'ui-request_passphrase',
  REQUEST_PASSPHRASE_ON_DEVICE: 'ui-request_passphrase_on_device',
  INVALID_PASSPHRASE: 'ui-invalid_passphrase',
  CONNECT: 'ui-connect',
  LOADING: 'ui-loading',
  SET_OPERATION: 'ui-set_operation',
  SELECT_DEVICE: 'ui-select_device',
  SELECT_ACCOUNT: 'ui-select_account',
  SELECT_FEE: 'ui-select_fee',
  UPDATE_CUSTOM_FEE: 'ui-update_custom_fee',
  INSUFFICIENT_FUNDS: 'ui-insufficient_funds',
  REQUEST_BUTTON: 'ui-button',
  REQUEST_WORD: 'ui-request_word',
  LOGIN_CHALLENGE_REQUEST: 'ui-login_challenge_request',
  BUNDLE_PROGRESS: 'ui-bundle_progress',
  ADDRESS_VALIDATION: 'ui-address_validation',
  IFRAME_FAILURE: 'ui-iframe_failure'
};
const createUiMessage = (type, payload) => ({
  event: exports.UI_EVENT,
  type,
  payload
});
exports.createUiMessage = createUiMessage;

/***/ }),

/***/ 600:
/***/ ((__unused_webpack_module, exports, __webpack_require__) => {



Object.defineProperty(exports, "__esModule", ({
  value: true
}));
exports.createUiResponse = exports.UI_RESPONSE = void 0;
const ui_request_1 = __webpack_require__(956);
exports.UI_RESPONSE = {
  RECEIVE_PERMISSION: 'ui-receive_permission',
  RECEIVE_CONFIRMATION: 'ui-receive_confirmation',
  RECEIVE_PIN: 'ui-receive_pin',
  RECEIVE_PASSPHRASE: 'ui-receive_passphrase',
  RECEIVE_DEVICE: 'ui-receive_device',
  RECEIVE_ACCOUNT: 'ui-receive_account',
  RECEIVE_FEE: 'ui-receive_fee',
  RECEIVE_WORD: 'ui-receive_word',
  INVALID_PASSPHRASE_ACTION: 'ui-invalid_passphrase_action',
  CHANGE_SETTINGS: 'ui-change_settings',
  LOGIN_CHALLENGE_RESPONSE: 'ui-login_challenge_response'
};
const createUiResponse = (type, payload) => ({
  event: ui_request_1.UI_EVENT,
  type,
  payload
});
exports.createUiResponse = createUiResponse;

/***/ }),

/***/ 948:
/***/ ((__unused_webpack_module, exports) => {



Object.defineProperty(exports, "__esModule", ({
  value: true
}));
exports.WEBEXTENSION = void 0;
exports.WEBEXTENSION = {
  USB_PERMISSIONS_BROADCAST: 'usb-permissions',
  USB_PERMISSIONS_INIT: 'usb-permissions-init',
  USB_PERMISSIONS_CLOSE: 'usb-permissions-close',
  USB_PERMISSIONS_FINISHED: 'usb-permissions-finished',
  CHANNEL_HANDSHAKE_CONFIRM: 'channel-handshake-confirm'
};

/***/ }),

/***/ 464:
/***/ ((__unused_webpack_module, exports, __webpack_require__) => {

var __webpack_unused_export__;


__webpack_unused_export__ = ({
  value: true
});
exports.i = void 0;
const events_1 = __webpack_require__(660);
const factory = ({
  eventEmitter,
  manifest,
  init,
  call,
  requestLogin,
  uiResponse,
  renderWebUSBButton,
  disableWebUSB,
  requestWebUSBDevice,
  cancel,
  dispose
}) => {
  const api = {
    manifest,
    init,
    getSettings: () => call({
      method: 'getSettings'
    }),
    on: (type, fn) => {
      eventEmitter.on(type, fn);
    },
    off: (type, fn) => {
      eventEmitter.removeListener(type, fn);
    },
    removeAllListeners: type => {
      if (typeof type === 'string') {
        eventEmitter.removeAllListeners(type);
      } else {
        eventEmitter.removeAllListeners();
      }
    },
    uiResponse,
    blockchainGetAccountBalanceHistory: params => call({
      ...params,
      method: 'blockchainGetAccountBalanceHistory'
    }),
    blockchainGetCurrentFiatRates: params => call({
      ...params,
      method: 'blockchainGetCurrentFiatRates'
    }),
    blockchainGetFiatRatesForTimestamps: params => call({
      ...params,
      method: 'blockchainGetFiatRatesForTimestamps'
    }),
    blockchainDisconnect: params => call({
      ...params,
      method: 'blockchainDisconnect'
    }),
    blockchainEstimateFee: params => call({
      ...params,
      method: 'blockchainEstimateFee'
    }),
    blockchainGetTransactions: params => call({
      ...params,
      method: 'blockchainGetTransactions'
    }),
    blockchainSetCustomBackend: params => call({
      ...params,
      method: 'blockchainSetCustomBackend'
    }),
    blockchainSubscribe: params => call({
      ...params,
      method: 'blockchainSubscribe'
    }),
    blockchainSubscribeFiatRates: params => call({
      ...params,
      method: 'blockchainSubscribeFiatRates'
    }),
    blockchainUnsubscribe: params => call({
      ...params,
      method: 'blockchainUnsubscribe'
    }),
    blockchainUnsubscribeFiatRates: params => call({
      ...params,
      method: 'blockchainUnsubscribeFiatRates'
    }),
    requestLogin: params => requestLogin(params),
    cardanoGetAddress: params => call({
      ...params,
      method: 'cardanoGetAddress',
      useEventListener: eventEmitter.listenerCount(events_1.UI.ADDRESS_VALIDATION) > 0
    }),
    cardanoGetNativeScriptHash: params => call({
      ...params,
      method: 'cardanoGetNativeScriptHash'
    }),
    cardanoGetPublicKey: params => call({
      ...params,
      method: 'cardanoGetPublicKey'
    }),
    cardanoSignTransaction: params => call({
      ...params,
      method: 'cardanoSignTransaction'
    }),
    cardanoComposeTransaction: params => call({
      ...params,
      method: 'cardanoComposeTransaction'
    }),
    cipherKeyValue: params => call({
      ...params,
      method: 'cipherKeyValue'
    }),
    composeTransaction: params => call({
      ...params,
      method: 'composeTransaction'
    }),
    ethereumGetAddress: params => call({
      ...params,
      method: 'ethereumGetAddress',
      useEventListener: eventEmitter.listenerCount(events_1.UI.ADDRESS_VALIDATION) > 0
    }),
    ethereumGetPublicKey: params => call({
      ...params,
      method: 'ethereumGetPublicKey'
    }),
    ethereumSignMessage: params => call({
      ...params,
      method: 'ethereumSignMessage'
    }),
    ethereumSignTransaction: params => call({
      ...params,
      method: 'ethereumSignTransaction'
    }),
    ethereumSignTypedData: params => call({
      ...params,
      method: 'ethereumSignTypedData'
    }),
    ethereumVerifyMessage: params => call({
      ...params,
      method: 'ethereumVerifyMessage'
    }),
    getAccountDescriptor: params => call({
      ...params,
      method: 'getAccountDescriptor'
    }),
    getAccountInfo: params => call({
      ...params,
      method: 'getAccountInfo'
    }),
    getAddress: params => call({
      ...params,
      method: 'getAddress',
      useEventListener: eventEmitter.listenerCount(events_1.UI.ADDRESS_VALIDATION) > 0
    }),
    getDeviceState: params => call({
      ...params,
      method: 'getDeviceState'
    }),
    getFeatures: params => call({
      ...params,
      method: 'getFeatures'
    }),
    getFirmwareHash: params => call({
      ...params,
      method: 'getFirmwareHash'
    }),
    getOwnershipId: params => call({
      ...params,
      method: 'getOwnershipId'
    }),
    getOwnershipProof: params => call({
      ...params,
      method: 'getOwnershipProof'
    }),
    getPublicKey: params => call({
      ...params,
      method: 'getPublicKey'
    }),
    nemGetAddress: params => call({
      ...params,
      method: 'nemGetAddress',
      useEventListener: eventEmitter.listenerCount(events_1.UI.ADDRESS_VALIDATION) > 0
    }),
    nemSignTransaction: params => call({
      ...params,
      method: 'nemSignTransaction'
    }),
    pushTransaction: params => call({
      ...params,
      method: 'pushTransaction'
    }),
    rippleGetAddress: params => call({
      ...params,
      method: 'rippleGetAddress',
      useEventListener: eventEmitter.listenerCount(events_1.UI.ADDRESS_VALIDATION) > 0
    }),
    rippleSignTransaction: params => call({
      ...params,
      method: 'rippleSignTransaction'
    }),
    signMessage: params => call({
      ...params,
      method: 'signMessage'
    }),
    signTransaction: params => call({
      ...params,
      method: 'signTransaction'
    }),
    solanaGetPublicKey: params => call({
      ...params,
      method: 'solanaGetPublicKey'
    }),
    solanaGetAddress: params => call({
      ...params,
      method: 'solanaGetAddress'
    }),
    solanaSignTransaction: params => call({
      ...params,
      method: 'solanaSignTransaction'
    }),
    stellarGetAddress: params => call({
      ...params,
      method: 'stellarGetAddress',
      useEventListener: eventEmitter.listenerCount(events_1.UI.ADDRESS_VALIDATION) > 0
    }),
    stellarSignTransaction: params => call({
      ...params,
      method: 'stellarSignTransaction'
    }),
    tezosGetAddress: params => call({
      ...params,
      method: 'tezosGetAddress',
      useEventListener: eventEmitter.listenerCount(events_1.UI.ADDRESS_VALIDATION) > 0
    }),
    tezosGetPublicKey: params => call({
      ...params,
      method: 'tezosGetPublicKey'
    }),
    tezosSignTransaction: params => call({
      ...params,
      method: 'tezosSignTransaction'
    }),
    unlockPath: params => call({
      ...params,
      method: 'unlockPath'
    }),
    eosGetPublicKey: params => call({
      ...params,
      method: 'eosGetPublicKey'
    }),
    eosSignTransaction: params => call({
      ...params,
      method: 'eosSignTransaction'
    }),
    binanceGetAddress: params => call({
      ...params,
      method: 'binanceGetAddress',
      useEventListener: eventEmitter.listenerCount(events_1.UI.ADDRESS_VALIDATION) > 0
    }),
    binanceGetPublicKey: params => call({
      ...params,
      method: 'binanceGetPublicKey'
    }),
    binanceSignTransaction: params => call({
      ...params,
      method: 'binanceSignTransaction'
    }),
    verifyMessage: params => call({
      ...params,
      method: 'verifyMessage'
    }),
    resetDevice: params => call({
      ...params,
      method: 'resetDevice'
    }),
    wipeDevice: params => call({
      ...params,
      method: 'wipeDevice'
    }),
    checkFirmwareAuthenticity: params => call({
      ...params,
      method: 'checkFirmwareAuthenticity'
    }),
    applyFlags: params => call({
      ...params,
      method: 'applyFlags'
    }),
    applySettings: params => call({
      ...params,
      method: 'applySettings'
    }),
    authenticateDevice: params => call({
      ...params,
      method: 'authenticateDevice'
    }),
    authorizeCoinjoin: params => call({
      ...params,
      method: 'authorizeCoinjoin'
    }),
    cancelCoinjoinAuthorization: params => call({
      ...params,
      method: 'cancelCoinjoinAuthorization'
    }),
    showDeviceTutorial: params => call({
      ...params,
      method: 'showDeviceTutorial'
    }),
    backupDevice: params => call({
      ...params,
      method: 'backupDevice'
    }),
    changeLanguage: params => call({
      ...params,
      method: 'changeLanguage'
    }),
    changePin: params => call({
      ...params,
      method: 'changePin'
    }),
    changeWipeCode: params => call({
      ...params,
      method: 'changeWipeCode'
    }),
    firmwareUpdate: params => call({
      ...params,
      method: 'firmwareUpdate'
    }),
    recoveryDevice: params => call({
      ...params,
      method: 'recoveryDevice'
    }),
    getCoinInfo: params => call({
      ...params,
      method: 'getCoinInfo'
    }),
    rebootToBootloader: params => call({
      ...params,
      method: 'rebootToBootloader'
    }),
    setBusy: params => call({
      ...params,
      method: 'setBusy'
    }),
    setProxy: params => call({
      ...params,
      method: 'setProxy'
    }),
    dispose,
    cancel,
    renderWebUSBButton,
    disableWebUSB,
    requestWebUSBDevice
  };
  return api;
};
exports.i = factory;

/***/ }),

/***/ 76:
/***/ ((__unused_webpack_module, exports) => {

var __webpack_unused_export__;


__webpack_unused_export__ = ({
  value: true
});
__webpack_unused_export__ = __webpack_unused_export__ = __webpack_unused_export__ = exports.UZ = exports.O2 = __webpack_unused_export__ = void 0;
const green = '#bada55';
const blue = '#20abd8';
const orange = '#f4a744';
const yellow = '#fbd948';
const colors = {
  '@trezor/connect': `color: ${blue}; background: #000;`,
  '@trezor/connect-web': `color: ${blue}; background: #000;`,
  '@trezor/connect-webextension': `color: ${blue}; background: #000;`,
  IFrame: `color: ${orange}; background: #000;`,
  Core: `color: ${orange}; background: #000;`,
  DeviceList: `color: ${green}; background: #000;`,
  Device: `color: ${green}; background: #000;`,
  DeviceCommands: `color: ${green}; background: #000;`,
  '@trezor/transport': `color: ${green}; background: #000;`,
  InteractionTimeout: `color: ${green}; background: #000;`,
  '@trezor/connect-popup': `color: ${yellow}; background: #000;`
};
const MAX_ENTRIES = 100;
class Log {
  constructor(prefix, enabled, logWriter) {
    this.prefix = prefix;
    this.enabled = enabled;
    this.messages = [];
    this.css = typeof window !== 'undefined' && colors[prefix] ? colors[prefix] : '';
    if (logWriter) {
      this.logWriter = logWriter;
    }
  }
  addMessage({
    level,
    prefix,
    timestamp
  }, ...args) {
    const message = {
      level,
      prefix,
      css: this.css,
      message: args,
      timestamp: timestamp || Date.now()
    };
    this.messages.push(message);
    if (this.logWriter) {
      try {
        this.logWriter.add(message);
      } catch (err) {
        console.error('There was an error adding log message', err, message);
      }
    }
    if (this.messages.length > MAX_ENTRIES) {
      this.messages.shift();
    }
  }
  setWriter(logWriter) {
    this.logWriter = logWriter;
  }
  log(...args) {
    this.addMessage({
      level: 'log',
      prefix: this.prefix
    }, ...args);
    if (this.enabled) {
      console.log(`%c${this.prefix}`, this.css, ...args);
    }
  }
  error(...args) {
    this.addMessage({
      level: 'error',
      prefix: this.prefix
    }, ...args);
    if (this.enabled) {
      console.error(`%c${this.prefix}`, this.css, ...args);
    }
  }
  warn(...args) {
    this.addMessage({
      level: 'warn',
      prefix: this.prefix
    }, ...args);
    if (this.enabled) {
      console.warn(`%c${this.prefix}`, this.css, ...args);
    }
  }
  debug(...args) {
    this.addMessage({
      level: 'debug',
      prefix: this.prefix
    }, ...args);
    if (this.enabled) {
      if (this.css) {
        console.log(`%c${this.prefix}`, this.css, ...args);
      } else {
        console.log(this.prefix, ...args);
      }
    }
  }
}
__webpack_unused_export__ = Log;
const _logs = {};
let writer;
const initLog = (prefix, enabled, logWriter) => {
  const instanceWriter = logWriter || writer;
  const instance = new Log(prefix, !!enabled, instanceWriter);
  _logs[prefix] = instance;
  return instance;
};
exports.O2 = initLog;
const setLogWriter = logWriterFactory => {
  Object.keys(_logs).forEach(key => {
    writer = logWriterFactory();
    if (writer) {
      _logs[key].setWriter(writer);
      const {
        messages
      } = _logs[key];
      messages.forEach(message => {
        writer === null || writer === void 0 ? void 0 : writer.add(message);
      });
    }
  });
};
exports.UZ = setLogWriter;
const enableLog = enabled => {
  Object.keys(_logs).forEach(key => {
    _logs[key].enabled = !!enabled;
  });
};
__webpack_unused_export__ = enableLog;
const enableLogByPrefix = (prefix, enabled) => {
  if (_logs[prefix]) {
    _logs[prefix].enabled = enabled;
  }
};
__webpack_unused_export__ = enableLogByPrefix;
const getLog = () => {
  let logs = [];
  Object.keys(_logs).forEach(key => {
    logs = logs.concat(_logs[key].messages);
  });
  logs.sort((a, b) => a.timestamp - b.timestamp);
  return logs;
};
__webpack_unused_export__ = getLog;

/***/ }),

/***/ 264:
/***/ ((__unused_webpack_module, exports, __webpack_require__) => {

var __webpack_unused_export__;


__webpack_unused_export__ = ({
  value: true
});
__webpack_unused_export__ = __webpack_unused_export__ = exports.iK = void 0;
const utils_1 = __webpack_require__(700);
const getOrigin = url => {
  var _a;
  if (typeof url !== 'string') return 'unknown';
  if (url.indexOf('file://') === 0) return 'file://';
  const [origin] = (_a = url.match(/^https?:\/\/[^/]+/)) !== null && _a !== void 0 ? _a : [];
  return origin !== null && origin !== void 0 ? origin : 'unknown';
};
exports.iK = getOrigin;
const getHost = url => {
  var _a;
  if (typeof url !== 'string') return;
  const [,, uri] = (_a = url.match(/^(https?):\/\/([^:/]+)?/i)) !== null && _a !== void 0 ? _a : [];
  if (uri) {
    const parts = uri.split('.');
    return parts.length > 2 ? parts.slice(parts.length - 2, parts.length).join('.') : uri;
  }
};
__webpack_unused_export__ = getHost;
const getOnionDomain = (url, dict) => {
  var _a;
  if (Array.isArray(url)) return url.map(u => {
    var _a;
    return (_a = (0, utils_1.urlToOnion)(u, dict)) !== null && _a !== void 0 ? _a : u;
  });
  if (typeof url === 'string') return (_a = (0, utils_1.urlToOnion)(url, dict)) !== null && _a !== void 0 ? _a : url;
  return url;
};
__webpack_unused_export__ = getOnionDomain;

/***/ }),

/***/ 528:
/***/ ((__unused_webpack_module, exports) => {



Object.defineProperty(exports, "__esModule", ({
  value: true
}));
exports.TRANSPORT = exports.ACTION_TIMEOUT = exports.TREZOR_USB_DESCRIPTORS = exports.T1_HID_VENDOR = exports.ENDPOINT_ID = exports.INTERFACE_ID = exports.CONFIGURATION_ID = void 0;
exports.CONFIGURATION_ID = 1;
exports.INTERFACE_ID = 0;
exports.ENDPOINT_ID = 1;
exports.T1_HID_VENDOR = 0x534c;
exports.TREZOR_USB_DESCRIPTORS = [{
  vendorId: 0x534c,
  productId: 0x0001
}, {
  vendorId: 0x1209,
  productId: 0x53c0
}, {
  vendorId: 0x1209,
  productId: 0x53c1
}];
exports.ACTION_TIMEOUT = 10000;
exports.TRANSPORT = {
  START: 'transport-start',
  ERROR: 'transport-error',
  UPDATE: 'transport-update',
  DISABLE_WEBUSB: 'transport-disable_webusb',
  REQUEST_DEVICE: 'transport-request_device'
};

/***/ }),

/***/ 316:
/***/ ((__unused_webpack_module, __webpack_exports__, __webpack_require__) => {

/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   E: () => (/* binding */ createDeferred)
/* harmony export */ });
// unwrap promise response from Deferred

const createDeferred = id => {
  let localResolve = () => {};
  let localReject = () => {};
  const promise = new Promise((resolve, reject) => {
    localResolve = resolve;
    localReject = reject;
  });
  return {
    id,
    resolve: localResolve,
    reject: localReject,
    promise
  };
};

/***/ }),

/***/ 812:
/***/ ((__unused_webpack_module, __webpack_exports__, __webpack_require__) => {

/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   C: () => (/* binding */ createDeferredManager)
/* harmony export */ });
/* harmony import */ var _createDeferred__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(316);

/**
 * Handles the frequently repeated pattern of many deferred promises with unique ids
 * (usually requests), which can be resolved or rejected in a random order, or they can
 * time out
 *
 * @param options optional default timeout and onTimeout callback
 *
 * @returns Deferred promise manager instance
 */
const createDeferredManager = options => {
  const {
    initialId = 0,
    timeout: defaultTimeout = 0,
    onTimeout
  } = options ?? {};
  const promises = [];
  let ID = initialId;
  let timeoutHandle;
  const length = () => promises.length;
  const nextId = () => ID;
  const replanTimeout = () => {
    const now = Date.now();
    const nearestDeadline = promises.reduce((prev, {
      deadline
    }) => (prev && deadline ? Math.min : Math.max)(prev, deadline), 0);
    if (timeoutHandle) clearTimeout(timeoutHandle);
    timeoutHandle = nearestDeadline ?
    // eslint-disable-next-line @typescript-eslint/no-use-before-define
    setTimeout(timeoutCallback, Math.max(nearestDeadline - now, 0)) // TODO min safe interval instead of zero?
    : undefined;
  };
  const timeoutCallback = () => {
    const now = Date.now();
    promises.filter(promise => promise.deadline && promise.deadline <= now).forEach(promise => {
      onTimeout?.(promise.id);
      promise.deadline = 0;
    });
    replanTimeout();
  };
  const create = (timeout = defaultTimeout) => {
    const promiseId = ID++;
    const deferred = (0,_createDeferred__WEBPACK_IMPORTED_MODULE_0__/* .createDeferred */ .E)(promiseId);
    const deadline = timeout && Date.now() + timeout;
    promises.push({
      ...deferred,
      deadline
    });
    if (timeout) replanTimeout();
    return {
      promiseId,
      promise: deferred.promise
    };
  };
  const extract = promiseId => {
    const index = promises.findIndex(({
      id
    }) => id === promiseId);
    const [promise] = index >= 0 ? promises.splice(index, 1) : [undefined];
    if (promise?.deadline) replanTimeout();
    return promise;
  };
  const resolve = (promiseId, value) => {
    const promise = extract(promiseId);
    promise?.resolve(value);
    return !!promise;
  };
  const reject = (promiseId, error) => {
    const promise = extract(promiseId);
    promise?.reject(error);
    return !!promise;
  };
  const rejectAll = error => {
    promises.forEach(promise => promise.reject(error));
    const deleted = promises.splice(0, promises.length);
    if (deleted.length) replanTimeout();
  };
  return {
    length,
    nextId,
    create,
    resolve,
    reject,
    rejectAll
  };
};

/***/ }),

/***/ 700:
/***/ ((__unused_webpack_module, __webpack_exports__, __webpack_require__) => {

// ESM COMPAT FLAG
__webpack_require__.r(__webpack_exports__);

// EXPORTS
__webpack_require__.d(__webpack_exports__, {
  TypedEmitter: () => (/* reexport */ typedEventEmitter/* TypedEmitter */.I),
  addDashesToSpaces: () => (/* reexport */ addDashesToSpaces),
  arrayDistinct: () => (/* reexport */ arrayDistinct),
  arrayPartition: () => (/* reexport */ arrayPartition),
  arrayShuffle: () => (/* reexport */ arrayShuffle),
  arrayToDictionary: () => (/* reexport */ arrayToDictionary),
  bufferUtils: () => (/* reexport */ bufferUtils_namespaceObject),
  bytesToHumanReadable: () => (/* reexport */ bytesToHumanReadable),
  capitalizeFirstLetter: () => (/* reexport */ capitalizeFirstLetter),
  cloneObject: () => (/* reexport */ cloneObject),
  countBytesInString: () => (/* reexport */ countBytesInString),
  createCooldown: () => (/* reexport */ createCooldown),
  createDeferred: () => (/* reexport */ createDeferred/* createDeferred */.E),
  createDeferredManager: () => (/* reexport */ createDeferredManager/* createDeferredManager */.C),
  createTimeoutPromise: () => (/* reexport */ createTimeoutPromise),
  enumUtils: () => (/* reexport */ enumUtils_namespaceObject),
  getLocaleSeparators: () => (/* reexport */ getLocaleSeparators),
  getNumberFromPixelString: () => (/* reexport */ getNumberFromPixelString),
  getRandomNumberInRange: () => (/* reexport */ getRandomNumberInRange),
  getSynchronize: () => (/* reexport */ getSynchronize),
  getWeakRandomId: () => (/* reexport */ getWeakRandomId),
  hasUppercaseLetter: () => (/* reexport */ hasUppercaseLetter),
  isAscii: () => (/* reexport */ isAscii),
  isHex: () => (/* reexport */ isHex),
  isNotUndefined: () => (/* reexport */ isNotUndefined),
  isUrl: () => (/* reexport */ isUrl),
  mergeDeepObject: () => (/* reexport */ mergeDeepObject),
  objectPartition: () => (/* reexport */ objectPartition),
  parseElectrumUrl: () => (/* reexport */ parseElectrumUrl),
  parseHostname: () => (/* reexport */ parseHostname),
  promiseAllSequence: () => (/* reexport */ promiseAllSequence),
  redactUserPathFromString: () => (/* reexport */ redactUserPathFromString),
  scheduleAction: () => (/* reexport */ scheduleAction/* scheduleAction */.a),
  splitStringEveryNCharacters: () => (/* reexport */ splitStringEveryNCharacters),
  startOfUserPathRegex: () => (/* reexport */ startOfUserPathRegex),
  throwError: () => (/* reexport */ throwError),
  topologicalSort: () => (/* reexport */ topologicalSort),
  truncateMiddle: () => (/* reexport */ truncateMiddle),
  urlToOnion: () => (/* reexport */ urlToOnion),
  versionUtils: () => (/* reexport */ versionUtils_namespaceObject),
  xssFilters: () => (/* reexport */ xssFilters_namespaceObject)
});

// NAMESPACE OBJECT: ../utils/src/bufferUtils.ts
var bufferUtils_namespaceObject = {};
__webpack_require__.r(bufferUtils_namespaceObject);
__webpack_require__.d(bufferUtils_namespaceObject, {
  getChunkSize: () => (getChunkSize),
  reverseBuffer: () => (reverseBuffer)
});

// NAMESPACE OBJECT: ../utils/src/enumUtils.ts
var enumUtils_namespaceObject = {};
__webpack_require__.r(enumUtils_namespaceObject);
__webpack_require__.d(enumUtils_namespaceObject, {
  getKeyByValue: () => (getKeyByValue),
  getValueByKey: () => (getValueByKey)
});

// NAMESPACE OBJECT: ../utils/src/versionUtils.ts
var versionUtils_namespaceObject = {};
__webpack_require__.r(versionUtils_namespaceObject);
__webpack_require__.d(versionUtils_namespaceObject, {
  isEqual: () => (isEqual),
  isNewer: () => (isNewer),
  isNewerOrEqual: () => (isNewerOrEqual),
  isVersionArray: () => (isVersionArray),
  normalizeVersion: () => (normalizeVersion)
});

// NAMESPACE OBJECT: ../utils/src/xssFilters.ts
var xssFilters_namespaceObject = {};
__webpack_require__.r(xssFilters_namespaceObject);
__webpack_require__.d(xssFilters_namespaceObject, {
  inDoubleQuotes: () => (inDoubleQuotes),
  inHTML: () => (inHTML),
  inSingleQuotes: () => (inSingleQuotes)
});

;// CONCATENATED MODULE: ../utils/src/bufferUtils.ts
const reverseBuffer = src => {
  if (src.length < 1) return src;
  const buffer = Buffer.alloc(src.length);
  let j = buffer.length - 1;
  for (let i = 0; i < buffer.length / 2; i++) {
    buffer[i] = src[j];
    buffer[j] = src[i];
    j--;
  }
  return buffer;
};
const getChunkSize = n => {
  const buf = Buffer.allocUnsafe(1);
  buf.writeUInt8(n);
  return buf;
};
;// CONCATENATED MODULE: ../utils/src/enumUtils.ts
/**
 * Find enum value and return corresponding key
 */
function getKeyByValue(obj, value) {
  return obj && Object.keys(obj).find(x => obj[x] === value);
}

/**
 * Find enum key and return corresponding value
 */
function getValueByKey(obj, enumKey) {
  const key = obj && Object.keys(obj).find(x => x === enumKey);
  return key && obj[key];
}
;// CONCATENATED MODULE: ../utils/src/versionUtils.ts
const isVersionArray = arr => {
  // Check if argument is an actual array
  if (!Array.isArray(arr)) {
    return false;
  }

  // Array has invalid length
  if (arr.length !== 3) {
    return false;
  }

  // Check for invalid numbers in the array
  for (let i = 0; i < arr.length; i++) {
    const versionNumber = arr[i];
    if (typeof versionNumber !== 'number' || versionNumber < 0) {
      return false;
    }
  }
  return true;
};
const parse = versionArr => ({
  major: versionArr[0],
  minor: versionArr[1],
  patch: versionArr[2]
});
const split = version => {
  const arr = version.split('.').map(v => Number(v));
  if (!isVersionArray(arr)) {
    throw new Error(`version string is in wrong format: ${version}`);
  }
  return arr;
};
const versionToString = arr => `${arr[0]}.${arr[1]}.${arr[2]}`;

/**
 * Is versionX (first arg) newer than versionY (second arg)
 * accepts version in two formats:
 * - string: '1.0.0'
 * - array:  [1, 0, 0]
 */
const isNewer = (versionX, versionY) => {
  const parsedX = parse(typeof versionX === 'string' ? split(versionX) : versionX);
  const parsedY = parse(typeof versionY === 'string' ? split(versionY) : versionY);
  if (parsedX.major - parsedY.major !== 0) {
    return parsedX.major > parsedY.major;
  }
  if (parsedX.minor - parsedY.minor !== 0) {
    return parsedX.minor > parsedY.minor;
  }
  if (parsedX.patch - parsedY.patch !== 0) {
    return parsedX.patch > parsedY.patch;
  }
  return false;
};

/**
 * Is versionX (first arg) equal versionY (second arg)
 * accepts version in two formats:
 * - string: '1.0.0'
 * - array:  [1, 0, 0]
 */
const isEqual = (versionX, versionY) => {
  const strX = typeof versionX === 'string' ? versionX : versionToString(versionX);
  const strY = typeof versionY === 'string' ? versionY : versionToString(versionY);
  return strX === strY;
};

/**
 * Is versionX (first arg) newer or equal than versionY (second arg)
 * accepts version in two formats:
 * - string: '1.0.0'
 * - array:  [1, 0, 0]
 */
const isNewerOrEqual = (versionX, versionY) => isNewer(versionX, versionY) || isEqual(versionX, versionY);
const normalizeVersion = version =>
// remove any zeros that are not preceded by Latin letters, decimal digits, underscores
version.replace(/\b0+(\d)/g, '$1');
;// CONCATENATED MODULE: ../utils/src/xssFilters.ts
const LT = /</g;
const SQUOT = /'/g;
const QUOT = /"/g;
const inHTML = value => value.replace(LT, '&lt;');
const inSingleQuotes = value => value.replace(SQUOT, '&#39;');
const inDoubleQuotes = value => value.replace(QUOT, '&quot;');
;// CONCATENATED MODULE: ../utils/src/addDashesToSpaces.ts
const addDashesToSpaces = inputString =>
// Use a regular expression to replace spaces with dashes
inputString.replace(/\s+/g, '-');
;// CONCATENATED MODULE: ../utils/src/arrayDistinct.ts
/**
 * Helper function to filter only distinct elements of an array
 */
const arrayDistinct = (item, index, self) => self.indexOf(item) === index;
;// CONCATENATED MODULE: ../utils/src/arrayPartition.ts
/**
 *
 * @param array Array to be divided into two parts.
 * @param condition Condition for inclusion in the first part.
 * @returns Array of two arrays - the items in the first array satisfy the condition and the rest is in the second array. Preserving original order.
 */
const arrayPartition = (array, condition) => array.reduce(([pass, fail], elem) => condition(elem) ? [[...pass, elem], fail] : [pass, [...fail, elem]], [[], []]);
;// CONCATENATED MODULE: ../utils/src/arrayShuffle.ts
/**
 * Randomly shuffles the elements in an array. This method
 * does not mutate the original array.
 */
const arrayShuffle = array => {
  const shuffled = array.slice();
  for (let i = shuffled.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [shuffled[i], shuffled[j]] = [shuffled[j], shuffled[i]];
  }
  return shuffled;
};
;// CONCATENATED MODULE: ../utils/src/arrayToDictionary.ts
/**
 * @param array Array to be converted to dictionary
 * @param getKey Function extracting string from an array item T, which will become its
 * key in the dictionary (if not unique, latter item could replace the former one)
 * Item will not be added to dictionary if key is not defined
 * @param multiple If true, dictionary values are arrays of all items with the given key
 * @returns Dictionary object with array items as values
 */

const validateKey = key => {
  if (['string', 'number'].includes(typeof key)) {
    return true;
  }
  return false;
};
const arrayToDictionary = (array, getKey, multiple) => multiple ? array.reduce((prev, cur) => {
  const key = getKey(cur);
  if (validateKey(key)) {
    return {
      ...prev,
      [key]: [...(prev[key] ?? []), cur]
    };
  }
  return prev;
}, {}) : array.reduce((prev, cur) => {
  const key = getKey(cur);
  if (validateKey(key)) {
    return {
      ...prev,
      [key]: cur
    };
  }
  return prev;
}, {});
;// CONCATENATED MODULE: ../utils/src/bytesToHumanReadable.ts
const units = ['B', 'KB', 'MB', 'GB', 'TB'];

/**
 *
 * @param bytes amount fo bytes
 * @returns String with the human redable size of bytes
 */
const bytesToHumanReadable = bytes => {
  let size = Math.abs(bytes);
  let i = 0;
  while (size >= 1024 || i >= units.length) {
    size /= 1024;
    i++;
  }
  return `${size.toFixed(1)} ${units[i]}`;
};
;// CONCATENATED MODULE: ../utils/src/capitalizeFirstLetter.ts
const capitalizeFirstLetter = str => str.charAt(0).toUpperCase() + str.slice(1);
;// CONCATENATED MODULE: ../utils/src/cloneObject.ts
// Makes a deep copy of an object.
const cloneObject = obj => {
  const jsonString = JSON.stringify(obj);
  if (jsonString === undefined) {
    // jsonString === undefined IF and only IF obj === undefined
    // therefore no need to clone
    return obj;
  }
  return JSON.parse(jsonString);
};
;// CONCATENATED MODULE: ../utils/src/countBytesInString.ts
const countBytesInString = input => encodeURI(input).split(/%..|./).length - 1;
;// CONCATENATED MODULE: ../utils/src/createCooldown.ts
/**
 * Function returned by `createCooldown` returns `true` only when previous `true` was returned
 * `cooldownMs` or more millis ago, and `false` otherwise. First call always returns `true`.
 */
const createCooldown = cooldownMs => {
  let last = 0;
  return () => {
    const now = Date.now();
    if (now - last >= cooldownMs) {
      last = now;
      return true;
    }
    return false;
  };
};
// EXTERNAL MODULE: ../utils/src/createDeferred.ts
var createDeferred = __webpack_require__(316);
// EXTERNAL MODULE: ../utils/src/createDeferredManager.ts
var createDeferredManager = __webpack_require__(812);
;// CONCATENATED MODULE: ../utils/src/createTimeoutPromise.ts
const createTimeoutPromise = timeout => new Promise(resolve => setTimeout(resolve, timeout));
;// CONCATENATED MODULE: ../utils/src/getLocaleSeparators.ts
const getLocaleSeparators = locale => {
  const numberFormat = new Intl.NumberFormat(locale);
  const parts = numberFormat.formatToParts(10000.1);
  const decimalSeparator = parts.find(({
    type
  }) => type === 'decimal')?.value;
  const thousandsSeparator = parts.find(({
    type
  }) => type === 'group')?.value;
  return {
    decimalSeparator,
    thousandsSeparator
  };
};
;// CONCATENATED MODULE: ../utils/src/getNumberFromPixelString.ts
const getNumberFromPixelString = size => parseInt(size.replace('px', ''), 10);
;// CONCATENATED MODULE: ../utils/src/getRandomNumberInRange.ts
const getRandomNumberInRange = (min, max) => Math.floor(Math.random() * (max - min + 1)) + min;
;// CONCATENATED MODULE: ../utils/src/getSynchronize.ts
/**
 * Ensures that all async actions passed to the returned function are called
 * immediately one after another, without interfering with each other.
 *
 * Example:
 *
 * ```
 * const synchronize = getSynchronize();
 * synchronize(() => asyncAction1());
 * synchronize(() => asyncAction2());
 * ```
 */
const getSynchronize = () => {
  let lock;
  return action => {
    const newLock = (lock ?? Promise.resolve()).catch(() => {}).then(action).finally(() => {
      if (lock === newLock) {
        lock = undefined;
      }
    });
    lock = newLock;
    return lock;
  };
};
;// CONCATENATED MODULE: ../utils/src/getWeakRandomId.ts
const getWeakRandomId = length => {
  let id = '';
  const list = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  for (let i = 0; i < length; i++) {
    id += list.charAt(Math.floor(Math.random() * list.length));
  }
  return id;
};
;// CONCATENATED MODULE: ../utils/src/hasUppercaseLetter.ts
const HAS_UPPERCASE_LATER_REGEXP = new RegExp('^(.*[A-Z].*)$');
const hasUppercaseLetter = value => HAS_UPPERCASE_LATER_REGEXP.test(value);
;// CONCATENATED MODULE: ../utils/src/isAscii.ts
function isAscii(value) {
  if (!value) return true;
  return /^[\x00-\x7F]*$/.test(value);
}
;// CONCATENATED MODULE: ../utils/src/isHex.ts
const isHex = str => {
  const regExp = /^(0x|0X)?[0-9A-Fa-f]+$/g;
  return regExp.test(str);
};
;// CONCATENATED MODULE: ../utils/src/isNotUndefined.ts
/**
 * Type safe helper function mostly to filter out undefined items of an array
 */
const isNotUndefined = item => typeof item !== 'undefined';
;// CONCATENATED MODULE: ../utils/src/isUrl.ts
const URL_REGEXP = /^(http|ws)s?:\/\/[a-z0-9]([a-z0-9.-]+)?(:[0-9]{1,5})?((\/)?(([a-z0-9-_])+(\/)?)+)$/i;
const isUrl = value => URL_REGEXP.test(value);
;// CONCATENATED MODULE: ../utils/src/mergeDeepObject.ts
// code shamelessly stolen from https://github.com/voodoocreation/ts-deepmerge

// istanbul ignore next
const isObject = obj => {
  if (typeof obj === 'object' && obj !== null) {
    if (typeof Object.getPrototypeOf === 'function') {
      const prototype = Object.getPrototypeOf(obj);
      return prototype === Object.prototype || prototype === null;
    }
    return Object.prototype.toString.call(obj) === '[object Object]';
  }
  return false;
};
const mergeDeepObject = (...objects) => objects.reduce((result, current) => {
  if (Array.isArray(current)) {
    throw new TypeError('Arguments provided to ts-deepmerge must be objects, not arrays.');
  }
  Object.keys(current).forEach(key => {
    if (['__proto__', 'constructor', 'prototype'].includes(key)) {
      return;
    }
    if (Array.isArray(result[key]) && Array.isArray(current[key])) {
      result[key] = mergeDeepObject.options.mergeArrays ? Array.from(new Set(result[key].concat(current[key]))) : current[key];
    } else if (isObject(result[key]) && isObject(current[key])) {
      result[key] = mergeDeepObject(result[key], current[key]);
    } else {
      result[key] = current[key];
    }
  });
  return result;
}, {});
const defaultOptions = {
  mergeArrays: true
};
mergeDeepObject.options = defaultOptions;
mergeDeepObject.withOptions = (options, ...objects) => {
  mergeDeepObject.options = {
    mergeArrays: true,
    ...options
  };
  const result = mergeDeepObject(...objects);
  mergeDeepObject.options = defaultOptions;
  return result;
};
;// CONCATENATED MODULE: ../utils/src/objectPartition.ts
/**
 *
 * @param obj Object to be divided into two parts.
 * @param keys Array of object keys for inclusion in the first object.
 * @returns Array of two objects - the first object has only keys from the array and the second the remaining keys
 */
const objectPartition = (obj, keys) => keys.reduce(([included, excluded], key) => {
  const {
    [key]: value,
    ...rest
  } = excluded;
  return typeof value !== 'undefined' ? [{
    ...included,
    [key]: value
  }, rest] : [included, excluded];
}, [{}, obj]);
;// CONCATENATED MODULE: ../utils/src/parseElectrumUrl.ts
// URL is in format host:port:[t|s] (t for tcp, s for ssl)
const ELECTRUM_URL_REGEX = /^(?:([a-zA-Z0-9.-]+)|\[([a-f0-9:]+)\]):([0-9]{1,5}):([ts])$/;
const parseElectrumUrl = url => {
  const match = url.match(ELECTRUM_URL_REGEX);
  if (!match) return undefined;
  return {
    host: match[1] ?? match[2],
    port: Number.parseInt(match[3], 10),
    protocol: match[4]
  };
};
;// CONCATENATED MODULE: ../utils/src/parseHostname.ts
/**
 * ^([a-z0-9.+-]+:\/\/)? - optionally starts with scheme (http://, wss://, ...)
 * ([a-z0-9.-]+) - all valid hostname characters until first slash, colon or end of line
 * ([:/][^:/]+)* - any number of sequences starting with colon (ports) or slash (path segments)
 * \/?$ - optionally ends with slash
 */
const HOSTNAME_REGEX = /^([a-z0-9.+-]+:\/\/)?([a-z0-9.-]+)([:/][^:/]+)*\/?$/i;

/**
 * Tries to parse hostname from maybe url string, with support of unconventional electrum urls.
 * @see {@link file://./../tests/parseHostname.test.ts}
 */
const parseHostname = url => url.match(HOSTNAME_REGEX)?.[2]?.toLowerCase();
;// CONCATENATED MODULE: ../utils/src/promiseAllSequence.ts
/**
 * Promise.all in sequence
 *
 * @param actions list of async actions to be processed
 * @returns Array of results from actions
 */

const promiseAllSequence = async actions => {
  const results = [];
  // For some reason, the previous implementation with promise chaining
  // (https://github.com/trezor/trezor-suite/blob/100015c45451ed50e2b0906d78de73c0fd2883d1/packages/utils/src/promiseAllSequence.ts)
  // was significantly slower in some cases, therefore simple for cycle is used instead
  for (let i = 0; i < actions.length; ++i) {
    const result = await actions[i]();
    results.push(result);
  }
  return results;
};
;// CONCATENATED MODULE: ../utils/src/redactUserPath.ts
/**
 * From paths like /Users/username/, C:\Users\username\, C:\\Users\\username\\,
 * this matches /Users/, \Users\ or \Users\\ as first group
 * and text (supposed to be a username) before the next slash (or special character not allowed in username)
 * as second group.
 */
const startOfUserPathRegex = /([/\\][Uu]sers[/\\]{1,4})([^"^'^[^\]^/^\\]*)/g;
const redactUserPathFromString = text => text.replace(startOfUserPathRegex, '$1[*]');
// EXTERNAL MODULE: ../utils/src/scheduleAction.ts
var scheduleAction = __webpack_require__(108);
;// CONCATENATED MODULE: ../utils/src/splitStringEveryNCharacters.ts
function splitStringEveryNCharacters(value, n) {
  if (n === 0) {
    return [];
  }
  const regex = new RegExp(`.{1,${n}}`, 'g');
  return value.match(regex) ?? [];
}
;// CONCATENATED MODULE: ../utils/src/throwError.ts
// Tiny helper for throwing errors from expressions
const throwError = reason => {
  throw new Error(reason);
};
;// CONCATENATED MODULE: ../utils/src/topologicalSort.ts


/**
 * Not very effective implementation of topological sorting. Returns the `elements` sorted
 * so that x always precedes y if `precedes(x, y) === true` and the incomparable
 * elements' order is either preserved or sorted according to `tie`. Throws when there is
 * a cycle found in precedences.
 */
const topologicalSort = (elements, precedes, tie) => {
  const result = [];
  const filterRoots = verts => arrayPartition(verts, succ => !verts.some(pred => precedes(pred, succ)));
  let elem = elements;
  while (elem.length) {
    const [roots, rest] = filterRoots(elem);
    if (!roots.length) throw new Error('Cycle detected');
    result.push(...(tie ? roots.sort(tie) : roots));
    elem = rest;
  }
  return result;
};
;// CONCATENATED MODULE: ../utils/src/truncateMiddle.ts
const truncateMiddle = (text, startChars, endChars) => {
  if (text.length <= startChars + endChars) return text;
  const start = text.substring(0, startChars);
  const end = text.substring(text.length - endChars, text.length);
  return `${start}…${end}`;
};
// EXTERNAL MODULE: ../utils/src/typedEventEmitter.ts
var typedEventEmitter = __webpack_require__(932);
;// CONCATENATED MODULE: ../utils/src/urlToOnion.ts
/**
 * Tries to replace clearnet domain name in given `url` by any of the onion domain names in
 * `onionDomains` map and return it. When no onion replacement is found, returns `undefined`.
 */
const urlToOnion = (url, onionDomains) => {
  const [, protocol, subdomain, domain, rest] = url.match(/^(http|ws)s?:\/\/([^:/]+\.)?([^/.]+\.[^/.]+)(\/.*)?$/i) ?? [];
  // ^(http|ws)s?:\/\/ - required http(s)/ws(s) protocol
  // ([^:/]+\.)? - optional subdomains, e.g. 'blog.'
  // ([^/.]+\.[^/.]+) - required two-part domain name, e.g. 'trezor.io'
  // (\/.*)?$ - optional path and/or query, e.g. '/api/data?id=1234'

  if (!domain || !onionDomains[domain]) return;
  return `${protocol}://${subdomain ?? ''}${onionDomains[domain]}${rest ?? ''}`;
};
;// CONCATENATED MODULE: ../utils/src/index.ts









































/***/ }),

/***/ 108:
/***/ ((__unused_webpack_module, __webpack_exports__, __webpack_require__) => {

/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   a: () => (/* binding */ scheduleAction)
/* harmony export */ });
// Ignored when attempts is AttemptParams[]

const isArray = attempts => Array.isArray(attempts);
const abortedBySignal = () => new Error('Aborted by signal');
const abortedByDeadline = () => new Error('Aborted by deadline');
const abortedByTimeout = () => new Error('Aborted by timeout');
const resolveAfterMs = (ms, clear) => new Promise((resolve, reject) => {
  if (clear.aborted) return reject();
  if (ms === undefined) return resolve();
  const timeout = setTimeout(resolve, ms);
  const onClear = () => {
    clearTimeout(timeout);
    clear.removeEventListener('abort', onClear);
    reject();
  };
  clear.addEventListener('abort', onClear);
});
const rejectAfterMs = (ms, reason, clear) => new Promise((_, reject) => {
  if (clear.aborted) return reject();
  const timeout = ms !== undefined ? setTimeout(() => reject(reason()), ms) : undefined;
  const onClear = () => {
    clearTimeout(timeout);
    clear.removeEventListener('abort', onClear);
    reject();
  };
  clear.addEventListener('abort', onClear);
});
const rejectWhenAborted = (signal, clear) => new Promise((_, reject) => {
  if (clear.aborted) return reject();
  if (signal?.aborted) return reject(abortedBySignal());
  const onAbort = () => reject(abortedBySignal());
  signal?.addEventListener('abort', onAbort);
  const onClear = () => {
    signal?.removeEventListener('abort', onAbort);
    clear.removeEventListener('abort', onClear);
    reject();
  };
  clear.addEventListener('abort', onClear);
});
const resolveAction = async (action, clear) => {
  const aborter = new AbortController();
  const onClear = () => aborter.abort();
  if (clear.aborted) onClear();
  clear.addEventListener('abort', onClear);
  try {
    return await new Promise(resolve => resolve(action(aborter.signal)));
  } finally {
    clear.removeEventListener('abort', onClear);
  }
};
const attemptLoop = async (attempts, attempt, failure, clear) => {
  // Tries only (attempts - 1) times, because the last attempt throws its error
  for (let a = 0; a < attempts - 1; a++) {
    if (clear.aborted) break;
    const aborter = new AbortController();
    const onClear = () => aborter.abort();
    clear.addEventListener('abort', onClear);
    try {
      return await attempt(a, aborter.signal);
    } catch {
      onClear();
      await failure(a);
    } finally {
      clear.removeEventListener('abort', onClear);
    }
  }
  return clear.aborted ? Promise.reject() : attempt(attempts - 1, clear);
};
const scheduleAction = async (action, params) => {
  const {
    signal,
    delay,
    attempts,
    timeout,
    deadline,
    gap
  } = params;
  const deadlineMs = deadline && deadline - Date.now();
  const attemptCount = isArray(attempts) ? attempts.length : attempts ?? (deadline ? Infinity : 1);
  const clearAborter = new AbortController();
  const clear = clearAborter.signal;
  const getParams = isArray(attempts) ? attempt => attempts[attempt] : () => ({
    timeout,
    gap
  });
  try {
    return await Promise.race([rejectWhenAborted(signal, clear), rejectAfterMs(deadlineMs, abortedByDeadline, clear), resolveAfterMs(delay, clear).then(() => attemptLoop(attemptCount, (attempt, abort) => Promise.race([rejectAfterMs(getParams(attempt).timeout, abortedByTimeout, clear), resolveAction(action, abort)]), attempt => resolveAfterMs(getParams(attempt).gap ?? 0, clear), clear))]);
  } finally {
    clearAborter.abort();
  }
};

/***/ }),

/***/ 932:
/***/ ((__unused_webpack_module, __webpack_exports__, __webpack_require__) => {

/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   I: () => (/* binding */ TypedEmitter)
/* harmony export */ });
/* harmony import */ var events__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(928);
/* harmony import */ var events__WEBPACK_IMPORTED_MODULE_0___default = /*#__PURE__*/__webpack_require__.n(events__WEBPACK_IMPORTED_MODULE_0__);
/*
Usage example:
type EventMap = {
    obj: { id: string };
    primitive: boolean | number | string | symbol;
    noArgs: undefined;
    multipleArgs: (a: number, b: string, c: boolean) => void;
    [type: `dynamic/${string}`]: boolean;
};
*/


// NOTE: case 1. looks like case 4. but works differently. the order matters

// 4. default

// eslint-disable-next-line @typescript-eslint/no-unsafe-declaration-merging
class TypedEmitter extends events__WEBPACK_IMPORTED_MODULE_0__.EventEmitter {
  // implement at least one function
  listenerCount(eventName) {
    return super.listenerCount(eventName);
  }
}

/***/ }),

/***/ 928:
/***/ ((module) => {

// Copyright Joyent, Inc. and other Node contributors.
//
// Permission is hereby granted, free of charge, to any person obtaining a
// copy of this software and associated documentation files (the
// "Software"), to deal in the Software without restriction, including
// without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to permit
// persons to whom the Software is furnished to do so, subject to the
// following conditions:
//
// The above copyright notice and this permission notice shall be included
// in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
// OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN
// NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
// OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
// USE OR OTHER DEALINGS IN THE SOFTWARE.



var R = typeof Reflect === 'object' ? Reflect : null
var ReflectApply = R && typeof R.apply === 'function'
  ? R.apply
  : function ReflectApply(target, receiver, args) {
    return Function.prototype.apply.call(target, receiver, args);
  }

var ReflectOwnKeys
if (R && typeof R.ownKeys === 'function') {
  ReflectOwnKeys = R.ownKeys
} else if (Object.getOwnPropertySymbols) {
  ReflectOwnKeys = function ReflectOwnKeys(target) {
    return Object.getOwnPropertyNames(target)
      .concat(Object.getOwnPropertySymbols(target));
  };
} else {
  ReflectOwnKeys = function ReflectOwnKeys(target) {
    return Object.getOwnPropertyNames(target);
  };
}

function ProcessEmitWarning(warning) {
  if (console && console.warn) console.warn(warning);
}

var NumberIsNaN = Number.isNaN || function NumberIsNaN(value) {
  return value !== value;
}

function EventEmitter() {
  EventEmitter.init.call(this);
}
module.exports = EventEmitter;
module.exports.once = once;

// Backwards-compat with node 0.10.x
EventEmitter.EventEmitter = EventEmitter;

EventEmitter.prototype._events = undefined;
EventEmitter.prototype._eventsCount = 0;
EventEmitter.prototype._maxListeners = undefined;

// By default EventEmitters will print a warning if more than 10 listeners are
// added to it. This is a useful default which helps finding memory leaks.
var defaultMaxListeners = 10;

function checkListener(listener) {
  if (typeof listener !== 'function') {
    throw new TypeError('The "listener" argument must be of type Function. Received type ' + typeof listener);
  }
}

Object.defineProperty(EventEmitter, 'defaultMaxListeners', {
  enumerable: true,
  get: function() {
    return defaultMaxListeners;
  },
  set: function(arg) {
    if (typeof arg !== 'number' || arg < 0 || NumberIsNaN(arg)) {
      throw new RangeError('The value of "defaultMaxListeners" is out of range. It must be a non-negative number. Received ' + arg + '.');
    }
    defaultMaxListeners = arg;
  }
});

EventEmitter.init = function() {

  if (this._events === undefined ||
      this._events === Object.getPrototypeOf(this)._events) {
    this._events = Object.create(null);
    this._eventsCount = 0;
  }

  this._maxListeners = this._maxListeners || undefined;
};

// Obviously not all Emitters should be limited to 10. This function allows
// that to be increased. Set to zero for unlimited.
EventEmitter.prototype.setMaxListeners = function setMaxListeners(n) {
  if (typeof n !== 'number' || n < 0 || NumberIsNaN(n)) {
    throw new RangeError('The value of "n" is out of range. It must be a non-negative number. Received ' + n + '.');
  }
  this._maxListeners = n;
  return this;
};

function _getMaxListeners(that) {
  if (that._maxListeners === undefined)
    return EventEmitter.defaultMaxListeners;
  return that._maxListeners;
}

EventEmitter.prototype.getMaxListeners = function getMaxListeners() {
  return _getMaxListeners(this);
};

EventEmitter.prototype.emit = function emit(type) {
  var args = [];
  for (var i = 1; i < arguments.length; i++) args.push(arguments[i]);
  var doError = (type === 'error');

  var events = this._events;
  if (events !== undefined)
    doError = (doError && events.error === undefined);
  else if (!doError)
    return false;

  // If there is no 'error' event listener then throw.
  if (doError) {
    var er;
    if (args.length > 0)
      er = args[0];
    if (er instanceof Error) {
      // Note: The comments on the `throw` lines are intentional, they show
      // up in Node's output if this results in an unhandled exception.
      throw er; // Unhandled 'error' event
    }
    // At least give some kind of context to the user
    var err = new Error('Unhandled error.' + (er ? ' (' + er.message + ')' : ''));
    err.context = er;
    throw err; // Unhandled 'error' event
  }

  var handler = events[type];

  if (handler === undefined)
    return false;

  if (typeof handler === 'function') {
    ReflectApply(handler, this, args);
  } else {
    var len = handler.length;
    var listeners = arrayClone(handler, len);
    for (var i = 0; i < len; ++i)
      ReflectApply(listeners[i], this, args);
  }

  return true;
};

function _addListener(target, type, listener, prepend) {
  var m;
  var events;
  var existing;

  checkListener(listener);

  events = target._events;
  if (events === undefined) {
    events = target._events = Object.create(null);
    target._eventsCount = 0;
  } else {
    // To avoid recursion in the case that type === "newListener"! Before
    // adding it to the listeners, first emit "newListener".
    if (events.newListener !== undefined) {
      target.emit('newListener', type,
                  listener.listener ? listener.listener : listener);

      // Re-assign `events` because a newListener handler could have caused the
      // this._events to be assigned to a new object
      events = target._events;
    }
    existing = events[type];
  }

  if (existing === undefined) {
    // Optimize the case of one listener. Don't need the extra array object.
    existing = events[type] = listener;
    ++target._eventsCount;
  } else {
    if (typeof existing === 'function') {
      // Adding the second element, need to change to array.
      existing = events[type] =
        prepend ? [listener, existing] : [existing, listener];
      // If we've already got an array, just append.
    } else if (prepend) {
      existing.unshift(listener);
    } else {
      existing.push(listener);
    }

    // Check for listener leak
    m = _getMaxListeners(target);
    if (m > 0 && existing.length > m && !existing.warned) {
      existing.warned = true;
      // No error code for this since it is a Warning
      // eslint-disable-next-line no-restricted-syntax
      var w = new Error('Possible EventEmitter memory leak detected. ' +
                          existing.length + ' ' + String(type) + ' listeners ' +
                          'added. Use emitter.setMaxListeners() to ' +
                          'increase limit');
      w.name = 'MaxListenersExceededWarning';
      w.emitter = target;
      w.type = type;
      w.count = existing.length;
      ProcessEmitWarning(w);
    }
  }

  return target;
}

EventEmitter.prototype.addListener = function addListener(type, listener) {
  return _addListener(this, type, listener, false);
};

EventEmitter.prototype.on = EventEmitter.prototype.addListener;

EventEmitter.prototype.prependListener =
    function prependListener(type, listener) {
      return _addListener(this, type, listener, true);
    };

function onceWrapper() {
  if (!this.fired) {
    this.target.removeListener(this.type, this.wrapFn);
    this.fired = true;
    if (arguments.length === 0)
      return this.listener.call(this.target);
    return this.listener.apply(this.target, arguments);
  }
}

function _onceWrap(target, type, listener) {
  var state = { fired: false, wrapFn: undefined, target: target, type: type, listener: listener };
  var wrapped = onceWrapper.bind(state);
  wrapped.listener = listener;
  state.wrapFn = wrapped;
  return wrapped;
}

EventEmitter.prototype.once = function once(type, listener) {
  checkListener(listener);
  this.on(type, _onceWrap(this, type, listener));
  return this;
};

EventEmitter.prototype.prependOnceListener =
    function prependOnceListener(type, listener) {
      checkListener(listener);
      this.prependListener(type, _onceWrap(this, type, listener));
      return this;
    };

// Emits a 'removeListener' event if and only if the listener was removed.
EventEmitter.prototype.removeListener =
    function removeListener(type, listener) {
      var list, events, position, i, originalListener;

      checkListener(listener);

      events = this._events;
      if (events === undefined)
        return this;

      list = events[type];
      if (list === undefined)
        return this;

      if (list === listener || list.listener === listener) {
        if (--this._eventsCount === 0)
          this._events = Object.create(null);
        else {
          delete events[type];
          if (events.removeListener)
            this.emit('removeListener', type, list.listener || listener);
        }
      } else if (typeof list !== 'function') {
        position = -1;

        for (i = list.length - 1; i >= 0; i--) {
          if (list[i] === listener || list[i].listener === listener) {
            originalListener = list[i].listener;
            position = i;
            break;
          }
        }

        if (position < 0)
          return this;

        if (position === 0)
          list.shift();
        else {
          spliceOne(list, position);
        }

        if (list.length === 1)
          events[type] = list[0];

        if (events.removeListener !== undefined)
          this.emit('removeListener', type, originalListener || listener);
      }

      return this;
    };

EventEmitter.prototype.off = EventEmitter.prototype.removeListener;

EventEmitter.prototype.removeAllListeners =
    function removeAllListeners(type) {
      var listeners, events, i;

      events = this._events;
      if (events === undefined)
        return this;

      // not listening for removeListener, no need to emit
      if (events.removeListener === undefined) {
        if (arguments.length === 0) {
          this._events = Object.create(null);
          this._eventsCount = 0;
        } else if (events[type] !== undefined) {
          if (--this._eventsCount === 0)
            this._events = Object.create(null);
          else
            delete events[type];
        }
        return this;
      }

      // emit removeListener for all listeners on all events
      if (arguments.length === 0) {
        var keys = Object.keys(events);
        var key;
        for (i = 0; i < keys.length; ++i) {
          key = keys[i];
          if (key === 'removeListener') continue;
          this.removeAllListeners(key);
        }
        this.removeAllListeners('removeListener');
        this._events = Object.create(null);
        this._eventsCount = 0;
        return this;
      }

      listeners = events[type];

      if (typeof listeners === 'function') {
        this.removeListener(type, listeners);
      } else if (listeners !== undefined) {
        // LIFO order
        for (i = listeners.length - 1; i >= 0; i--) {
          this.removeListener(type, listeners[i]);
        }
      }

      return this;
    };

function _listeners(target, type, unwrap) {
  var events = target._events;

  if (events === undefined)
    return [];

  var evlistener = events[type];
  if (evlistener === undefined)
    return [];

  if (typeof evlistener === 'function')
    return unwrap ? [evlistener.listener || evlistener] : [evlistener];

  return unwrap ?
    unwrapListeners(evlistener) : arrayClone(evlistener, evlistener.length);
}

EventEmitter.prototype.listeners = function listeners(type) {
  return _listeners(this, type, true);
};

EventEmitter.prototype.rawListeners = function rawListeners(type) {
  return _listeners(this, type, false);
};

EventEmitter.listenerCount = function(emitter, type) {
  if (typeof emitter.listenerCount === 'function') {
    return emitter.listenerCount(type);
  } else {
    return listenerCount.call(emitter, type);
  }
};

EventEmitter.prototype.listenerCount = listenerCount;
function listenerCount(type) {
  var events = this._events;

  if (events !== undefined) {
    var evlistener = events[type];

    if (typeof evlistener === 'function') {
      return 1;
    } else if (evlistener !== undefined) {
      return evlistener.length;
    }
  }

  return 0;
}

EventEmitter.prototype.eventNames = function eventNames() {
  return this._eventsCount > 0 ? ReflectOwnKeys(this._events) : [];
};

function arrayClone(arr, n) {
  var copy = new Array(n);
  for (var i = 0; i < n; ++i)
    copy[i] = arr[i];
  return copy;
}

function spliceOne(list, index) {
  for (; index + 1 < list.length; index++)
    list[index] = list[index + 1];
  list.pop();
}

function unwrapListeners(arr) {
  var ret = new Array(arr.length);
  for (var i = 0; i < ret.length; ++i) {
    ret[i] = arr[i].listener || arr[i];
  }
  return ret;
}

function once(emitter, name) {
  return new Promise(function (resolve, reject) {
    function errorListener(err) {
      emitter.removeListener(name, resolver);
      reject(err);
    }

    function resolver() {
      if (typeof emitter.removeListener === 'function') {
        emitter.removeListener('error', errorListener);
      }
      resolve([].slice.call(arguments));
    };

    eventTargetAgnosticAddListener(emitter, name, resolver, { once: true });
    if (name !== 'error') {
      addErrorHandlerIfEventEmitter(emitter, errorListener, { once: true });
    }
  });
}

function addErrorHandlerIfEventEmitter(emitter, handler, flags) {
  if (typeof emitter.on === 'function') {
    eventTargetAgnosticAddListener(emitter, 'error', handler, flags);
  }
}

function eventTargetAgnosticAddListener(emitter, name, listener, flags) {
  if (typeof emitter.on === 'function') {
    if (flags.once) {
      emitter.once(name, listener);
    } else {
      emitter.on(name, listener);
    }
  } else if (typeof emitter.addEventListener === 'function') {
    // EventTarget does not have `error` event semantics like Node
    // EventEmitters, we do not listen for `error` events here.
    emitter.addEventListener(name, function wrapListener(arg) {
      // IE does not have builtin `{ once: true }` support so we
      // have to do it manually.
      if (flags.once) {
        emitter.removeEventListener(name, wrapListener);
      }
      listener(arg);
    });
  } else {
    throw new TypeError('The "emitter" argument must be of type EventEmitter. Received type ' + typeof emitter);
  }
}


/***/ }),

/***/ 376:
/***/ ((__unused_webpack___webpack_module__, __webpack_exports__, __webpack_require__) => {

__webpack_require__.r(__webpack_exports__);
/* harmony export */ __webpack_require__.d(__webpack_exports__, {
/* harmony export */   __addDisposableResource: () => (/* binding */ __addDisposableResource),
/* harmony export */   __assign: () => (/* binding */ __assign),
/* harmony export */   __asyncDelegator: () => (/* binding */ __asyncDelegator),
/* harmony export */   __asyncGenerator: () => (/* binding */ __asyncGenerator),
/* harmony export */   __asyncValues: () => (/* binding */ __asyncValues),
/* harmony export */   __await: () => (/* binding */ __await),
/* harmony export */   __awaiter: () => (/* binding */ __awaiter),
/* harmony export */   __classPrivateFieldGet: () => (/* binding */ __classPrivateFieldGet),
/* harmony export */   __classPrivateFieldIn: () => (/* binding */ __classPrivateFieldIn),
/* harmony export */   __classPrivateFieldSet: () => (/* binding */ __classPrivateFieldSet),
/* harmony export */   __createBinding: () => (/* binding */ __createBinding),
/* harmony export */   __decorate: () => (/* binding */ __decorate),
/* harmony export */   __disposeResources: () => (/* binding */ __disposeResources),
/* harmony export */   __esDecorate: () => (/* binding */ __esDecorate),
/* harmony export */   __exportStar: () => (/* binding */ __exportStar),
/* harmony export */   __extends: () => (/* binding */ __extends),
/* harmony export */   __generator: () => (/* binding */ __generator),
/* harmony export */   __importDefault: () => (/* binding */ __importDefault),
/* harmony export */   __importStar: () => (/* binding */ __importStar),
/* harmony export */   __makeTemplateObject: () => (/* binding */ __makeTemplateObject),
/* harmony export */   __metadata: () => (/* binding */ __metadata),
/* harmony export */   __param: () => (/* binding */ __param),
/* harmony export */   __propKey: () => (/* binding */ __propKey),
/* harmony export */   __read: () => (/* binding */ __read),
/* harmony export */   __rest: () => (/* binding */ __rest),
/* harmony export */   __runInitializers: () => (/* binding */ __runInitializers),
/* harmony export */   __setFunctionName: () => (/* binding */ __setFunctionName),
/* harmony export */   __spread: () => (/* binding */ __spread),
/* harmony export */   __spreadArray: () => (/* binding */ __spreadArray),
/* harmony export */   __spreadArrays: () => (/* binding */ __spreadArrays),
/* harmony export */   __values: () => (/* binding */ __values),
/* harmony export */   "default": () => (__WEBPACK_DEFAULT_EXPORT__)
/* harmony export */ });
/******************************************************************************
Copyright (c) Microsoft Corporation.

Permission to use, copy, modify, and/or distribute this software for any
purpose with or without fee is hereby granted.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
PERFORMANCE OF THIS SOFTWARE.
***************************************************************************** */
/* global Reflect, Promise, SuppressedError, Symbol */

var extendStatics = function(d, b) {
  extendStatics = Object.setPrototypeOf ||
      ({ __proto__: [] } instanceof Array && function (d, b) { d.__proto__ = b; }) ||
      function (d, b) { for (var p in b) if (Object.prototype.hasOwnProperty.call(b, p)) d[p] = b[p]; };
  return extendStatics(d, b);
};

function __extends(d, b) {
  if (typeof b !== "function" && b !== null)
      throw new TypeError("Class extends value " + String(b) + " is not a constructor or null");
  extendStatics(d, b);
  function __() { this.constructor = d; }
  d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
}

var __assign = function() {
  __assign = Object.assign || function __assign(t) {
      for (var s, i = 1, n = arguments.length; i < n; i++) {
          s = arguments[i];
          for (var p in s) if (Object.prototype.hasOwnProperty.call(s, p)) t[p] = s[p];
      }
      return t;
  }
  return __assign.apply(this, arguments);
}

function __rest(s, e) {
  var t = {};
  for (var p in s) if (Object.prototype.hasOwnProperty.call(s, p) && e.indexOf(p) < 0)
      t[p] = s[p];
  if (s != null && typeof Object.getOwnPropertySymbols === "function")
      for (var i = 0, p = Object.getOwnPropertySymbols(s); i < p.length; i++) {
          if (e.indexOf(p[i]) < 0 && Object.prototype.propertyIsEnumerable.call(s, p[i]))
              t[p[i]] = s[p[i]];
      }
  return t;
}

function __decorate(decorators, target, key, desc) {
  var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
  if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
  else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
  return c > 3 && r && Object.defineProperty(target, key, r), r;
}

function __param(paramIndex, decorator) {
  return function (target, key) { decorator(target, key, paramIndex); }
}

function __esDecorate(ctor, descriptorIn, decorators, contextIn, initializers, extraInitializers) {
  function accept(f) { if (f !== void 0 && typeof f !== "function") throw new TypeError("Function expected"); return f; }
  var kind = contextIn.kind, key = kind === "getter" ? "get" : kind === "setter" ? "set" : "value";
  var target = !descriptorIn && ctor ? contextIn["static"] ? ctor : ctor.prototype : null;
  var descriptor = descriptorIn || (target ? Object.getOwnPropertyDescriptor(target, contextIn.name) : {});
  var _, done = false;
  for (var i = decorators.length - 1; i >= 0; i--) {
      var context = {};
      for (var p in contextIn) context[p] = p === "access" ? {} : contextIn[p];
      for (var p in contextIn.access) context.access[p] = contextIn.access[p];
      context.addInitializer = function (f) { if (done) throw new TypeError("Cannot add initializers after decoration has completed"); extraInitializers.push(accept(f || null)); };
      var result = (0, decorators[i])(kind === "accessor" ? { get: descriptor.get, set: descriptor.set } : descriptor[key], context);
      if (kind === "accessor") {
          if (result === void 0) continue;
          if (result === null || typeof result !== "object") throw new TypeError("Object expected");
          if (_ = accept(result.get)) descriptor.get = _;
          if (_ = accept(result.set)) descriptor.set = _;
          if (_ = accept(result.init)) initializers.unshift(_);
      }
      else if (_ = accept(result)) {
          if (kind === "field") initializers.unshift(_);
          else descriptor[key] = _;
      }
  }
  if (target) Object.defineProperty(target, contextIn.name, descriptor);
  done = true;
};

function __runInitializers(thisArg, initializers, value) {
  var useValue = arguments.length > 2;
  for (var i = 0; i < initializers.length; i++) {
      value = useValue ? initializers[i].call(thisArg, value) : initializers[i].call(thisArg);
  }
  return useValue ? value : void 0;
};

function __propKey(x) {
  return typeof x === "symbol" ? x : "".concat(x);
};

function __setFunctionName(f, name, prefix) {
  if (typeof name === "symbol") name = name.description ? "[".concat(name.description, "]") : "";
  return Object.defineProperty(f, "name", { configurable: true, value: prefix ? "".concat(prefix, " ", name) : name });
};

function __metadata(metadataKey, metadataValue) {
  if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(metadataKey, metadataValue);
}

function __awaiter(thisArg, _arguments, P, generator) {
  function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
  return new (P || (P = Promise))(function (resolve, reject) {
      function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
      function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
      function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
      step((generator = generator.apply(thisArg, _arguments || [])).next());
  });
}

function __generator(thisArg, body) {
  var _ = { label: 0, sent: function() { if (t[0] & 1) throw t[1]; return t[1]; }, trys: [], ops: [] }, f, y, t, g;
  return g = { next: verb(0), "throw": verb(1), "return": verb(2) }, typeof Symbol === "function" && (g[Symbol.iterator] = function() { return this; }), g;
  function verb(n) { return function (v) { return step([n, v]); }; }
  function step(op) {
      if (f) throw new TypeError("Generator is already executing.");
      while (g && (g = 0, op[0] && (_ = 0)), _) try {
          if (f = 1, y && (t = op[0] & 2 ? y["return"] : op[0] ? y["throw"] || ((t = y["return"]) && t.call(y), 0) : y.next) && !(t = t.call(y, op[1])).done) return t;
          if (y = 0, t) op = [op[0] & 2, t.value];
          switch (op[0]) {
              case 0: case 1: t = op; break;
              case 4: _.label++; return { value: op[1], done: false };
              case 5: _.label++; y = op[1]; op = [0]; continue;
              case 7: op = _.ops.pop(); _.trys.pop(); continue;
              default:
                  if (!(t = _.trys, t = t.length > 0 && t[t.length - 1]) && (op[0] === 6 || op[0] === 2)) { _ = 0; continue; }
                  if (op[0] === 3 && (!t || (op[1] > t[0] && op[1] < t[3]))) { _.label = op[1]; break; }
                  if (op[0] === 6 && _.label < t[1]) { _.label = t[1]; t = op; break; }
                  if (t && _.label < t[2]) { _.label = t[2]; _.ops.push(op); break; }
                  if (t[2]) _.ops.pop();
                  _.trys.pop(); continue;
          }
          op = body.call(thisArg, _);
      } catch (e) { op = [6, e]; y = 0; } finally { f = t = 0; }
      if (op[0] & 5) throw op[1]; return { value: op[0] ? op[1] : void 0, done: true };
  }
}

var __createBinding = Object.create ? (function(o, m, k, k2) {
  if (k2 === undefined) k2 = k;
  var desc = Object.getOwnPropertyDescriptor(m, k);
  if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
  }
  Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
  if (k2 === undefined) k2 = k;
  o[k2] = m[k];
});

function __exportStar(m, o) {
  for (var p in m) if (p !== "default" && !Object.prototype.hasOwnProperty.call(o, p)) __createBinding(o, m, p);
}

function __values(o) {
  var s = typeof Symbol === "function" && Symbol.iterator, m = s && o[s], i = 0;
  if (m) return m.call(o);
  if (o && typeof o.length === "number") return {
      next: function () {
          if (o && i >= o.length) o = void 0;
          return { value: o && o[i++], done: !o };
      }
  };
  throw new TypeError(s ? "Object is not iterable." : "Symbol.iterator is not defined.");
}

function __read(o, n) {
  var m = typeof Symbol === "function" && o[Symbol.iterator];
  if (!m) return o;
  var i = m.call(o), r, ar = [], e;
  try {
      while ((n === void 0 || n-- > 0) && !(r = i.next()).done) ar.push(r.value);
  }
  catch (error) { e = { error: error }; }
  finally {
      try {
          if (r && !r.done && (m = i["return"])) m.call(i);
      }
      finally { if (e) throw e.error; }
  }
  return ar;
}

/** @deprecated */
function __spread() {
  for (var ar = [], i = 0; i < arguments.length; i++)
      ar = ar.concat(__read(arguments[i]));
  return ar;
}

/** @deprecated */
function __spreadArrays() {
  for (var s = 0, i = 0, il = arguments.length; i < il; i++) s += arguments[i].length;
  for (var r = Array(s), k = 0, i = 0; i < il; i++)
      for (var a = arguments[i], j = 0, jl = a.length; j < jl; j++, k++)
          r[k] = a[j];
  return r;
}

function __spreadArray(to, from, pack) {
  if (pack || arguments.length === 2) for (var i = 0, l = from.length, ar; i < l; i++) {
      if (ar || !(i in from)) {
          if (!ar) ar = Array.prototype.slice.call(from, 0, i);
          ar[i] = from[i];
      }
  }
  return to.concat(ar || Array.prototype.slice.call(from));
}

function __await(v) {
  return this instanceof __await ? (this.v = v, this) : new __await(v);
}

function __asyncGenerator(thisArg, _arguments, generator) {
  if (!Symbol.asyncIterator) throw new TypeError("Symbol.asyncIterator is not defined.");
  var g = generator.apply(thisArg, _arguments || []), i, q = [];
  return i = {}, verb("next"), verb("throw"), verb("return"), i[Symbol.asyncIterator] = function () { return this; }, i;
  function verb(n) { if (g[n]) i[n] = function (v) { return new Promise(function (a, b) { q.push([n, v, a, b]) > 1 || resume(n, v); }); }; }
  function resume(n, v) { try { step(g[n](v)); } catch (e) { settle(q[0][3], e); } }
  function step(r) { r.value instanceof __await ? Promise.resolve(r.value.v).then(fulfill, reject) : settle(q[0][2], r); }
  function fulfill(value) { resume("next", value); }
  function reject(value) { resume("throw", value); }
  function settle(f, v) { if (f(v), q.shift(), q.length) resume(q[0][0], q[0][1]); }
}

function __asyncDelegator(o) {
  var i, p;
  return i = {}, verb("next"), verb("throw", function (e) { throw e; }), verb("return"), i[Symbol.iterator] = function () { return this; }, i;
  function verb(n, f) { i[n] = o[n] ? function (v) { return (p = !p) ? { value: __await(o[n](v)), done: false } : f ? f(v) : v; } : f; }
}

function __asyncValues(o) {
  if (!Symbol.asyncIterator) throw new TypeError("Symbol.asyncIterator is not defined.");
  var m = o[Symbol.asyncIterator], i;
  return m ? m.call(o) : (o = typeof __values === "function" ? __values(o) : o[Symbol.iterator](), i = {}, verb("next"), verb("throw"), verb("return"), i[Symbol.asyncIterator] = function () { return this; }, i);
  function verb(n) { i[n] = o[n] && function (v) { return new Promise(function (resolve, reject) { v = o[n](v), settle(resolve, reject, v.done, v.value); }); }; }
  function settle(resolve, reject, d, v) { Promise.resolve(v).then(function(v) { resolve({ value: v, done: d }); }, reject); }
}

function __makeTemplateObject(cooked, raw) {
  if (Object.defineProperty) { Object.defineProperty(cooked, "raw", { value: raw }); } else { cooked.raw = raw; }
  return cooked;
};

var __setModuleDefault = Object.create ? (function(o, v) {
  Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
  o["default"] = v;
};

function __importStar(mod) {
  if (mod && mod.__esModule) return mod;
  var result = {};
  if (mod != null) for (var k in mod) if (k !== "default" && Object.prototype.hasOwnProperty.call(mod, k)) __createBinding(result, mod, k);
  __setModuleDefault(result, mod);
  return result;
}

function __importDefault(mod) {
  return (mod && mod.__esModule) ? mod : { default: mod };
}

function __classPrivateFieldGet(receiver, state, kind, f) {
  if (kind === "a" && !f) throw new TypeError("Private accessor was defined without a getter");
  if (typeof state === "function" ? receiver !== state || !f : !state.has(receiver)) throw new TypeError("Cannot read private member from an object whose class did not declare it");
  return kind === "m" ? f : kind === "a" ? f.call(receiver) : f ? f.value : state.get(receiver);
}

function __classPrivateFieldSet(receiver, state, value, kind, f) {
  if (kind === "m") throw new TypeError("Private method is not writable");
  if (kind === "a" && !f) throw new TypeError("Private accessor was defined without a setter");
  if (typeof state === "function" ? receiver !== state || !f : !state.has(receiver)) throw new TypeError("Cannot write private member to an object whose class did not declare it");
  return (kind === "a" ? f.call(receiver, value) : f ? f.value = value : state.set(receiver, value)), value;
}

function __classPrivateFieldIn(state, receiver) {
  if (receiver === null || (typeof receiver !== "object" && typeof receiver !== "function")) throw new TypeError("Cannot use 'in' operator on non-object");
  return typeof state === "function" ? receiver === state : state.has(receiver);
}

function __addDisposableResource(env, value, async) {
  if (value !== null && value !== void 0) {
    if (typeof value !== "object" && typeof value !== "function") throw new TypeError("Object expected.");
    var dispose;
    if (async) {
        if (!Symbol.asyncDispose) throw new TypeError("Symbol.asyncDispose is not defined.");
        dispose = value[Symbol.asyncDispose];
    }
    if (dispose === void 0) {
        if (!Symbol.dispose) throw new TypeError("Symbol.dispose is not defined.");
        dispose = value[Symbol.dispose];
    }
    if (typeof dispose !== "function") throw new TypeError("Object not disposable.");
    env.stack.push({ value: value, dispose: dispose, async: async });
  }
  else if (async) {
    env.stack.push({ async: true });
  }
  return value;
}

var _SuppressedError = typeof SuppressedError === "function" ? SuppressedError : function (error, suppressed, message) {
  var e = new Error(message);
  return e.name = "SuppressedError", e.error = error, e.suppressed = suppressed, e;
};

function __disposeResources(env) {
  function fail(e) {
    env.error = env.hasError ? new _SuppressedError(e, env.error, "An error was suppressed during disposal.") : e;
    env.hasError = true;
  }
  function next() {
    while (env.stack.length) {
      var rec = env.stack.pop();
      try {
        var result = rec.dispose && rec.dispose.call(rec.value);
        if (rec.async) return Promise.resolve(result).then(next, function(e) { fail(e); return next(); });
      }
      catch (e) {
          fail(e);
      }
    }
    if (env.hasError) throw env.error;
  }
  return next();
}

/* harmony default export */ const __WEBPACK_DEFAULT_EXPORT__ = ({
  __extends,
  __assign,
  __rest,
  __decorate,
  __param,
  __metadata,
  __awaiter,
  __generator,
  __createBinding,
  __exportStar,
  __values,
  __read,
  __spread,
  __spreadArrays,
  __spreadArray,
  __await,
  __asyncGenerator,
  __asyncDelegator,
  __asyncValues,
  __makeTemplateObject,
  __importStar,
  __importDefault,
  __classPrivateFieldGet,
  __classPrivateFieldSet,
  __classPrivateFieldIn,
  __addDisposableResource,
  __disposeResources,
});


/***/ })

/******/ 	});
/************************************************************************/
/******/ 	// The module cache
/******/ 	var __webpack_module_cache__ = {};
/******/ 	
/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {
/******/ 		// Check if module is in cache
/******/ 		var cachedModule = __webpack_module_cache__[moduleId];
/******/ 		if (cachedModule !== undefined) {
/******/ 			return cachedModule.exports;
/******/ 		}
/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = __webpack_module_cache__[moduleId] = {
/******/ 			// no module.id needed
/******/ 			// no module.loaded needed
/******/ 			exports: {}
/******/ 		};
/******/ 	
/******/ 		// Execute the module function
/******/ 		__webpack_modules__[moduleId](module, module.exports, __webpack_require__);
/******/ 	
/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}
/******/ 	
/************************************************************************/
/******/ 	/* webpack/runtime/compat get default export */
/******/ 	(() => {
/******/ 		// getDefaultExport function for compatibility with non-harmony modules
/******/ 		__webpack_require__.n = (module) => {
/******/ 			var getter = module && module.__esModule ?
/******/ 				() => (module['default']) :
/******/ 				() => (module);
/******/ 			__webpack_require__.d(getter, { a: getter });
/******/ 			return getter;
/******/ 		};
/******/ 	})();
/******/ 	
/******/ 	/* webpack/runtime/define property getters */
/******/ 	(() => {
/******/ 		// define getter functions for harmony exports
/******/ 		__webpack_require__.d = (exports, definition) => {
/******/ 			for(var key in definition) {
/******/ 				if(__webpack_require__.o(definition, key) && !__webpack_require__.o(exports, key)) {
/******/ 					Object.defineProperty(exports, key, { enumerable: true, get: definition[key] });
/******/ 				}
/******/ 			}
/******/ 		};
/******/ 	})();
/******/ 	
/******/ 	/* webpack/runtime/global */
/******/ 	(() => {
/******/ 		__webpack_require__.g = (function() {
/******/ 			if (typeof globalThis === 'object') return globalThis;
/******/ 			try {
/******/ 				return this || new Function('return this')();
/******/ 			} catch (e) {
/******/ 				if (typeof window === 'object') return window;
/******/ 			}
/******/ 		})();
/******/ 	})();
/******/ 	
/******/ 	/* webpack/runtime/hasOwnProperty shorthand */
/******/ 	(() => {
/******/ 		__webpack_require__.o = (obj, prop) => (Object.prototype.hasOwnProperty.call(obj, prop))
/******/ 	})();
/******/ 	
/******/ 	/* webpack/runtime/make namespace object */
/******/ 	(() => {
/******/ 		// define __esModule on exports
/******/ 		__webpack_require__.r = (exports) => {
/******/ 			if(typeof Symbol !== 'undefined' && Symbol.toStringTag) {
/******/ 				Object.defineProperty(exports, Symbol.toStringTag, { value: 'Module' });
/******/ 			}
/******/ 			Object.defineProperty(exports, '__esModule', { value: true });
/******/ 		};
/******/ 	})();
/******/ 	
/************************************************************************/
var __webpack_exports__ = {};
// This entry need to be wrapped in an IIFE because it need to be isolated against other modules in the chunk.
(() => {

// EXPORTS
__webpack_require__.d(__webpack_exports__, {
  "default": () => (/* binding */ src)
});

// EXTERNAL MODULE: ../../node_modules/events/events.js
var events = __webpack_require__(928);
var events_default = /*#__PURE__*/__webpack_require__.n(events);
// EXTERNAL MODULE: ../connect/lib/constants/errors.js
var errors = __webpack_require__(776);
// EXTERNAL MODULE: ../connect/lib/events/index.js
var lib_events = __webpack_require__(660);
// EXTERNAL MODULE: ../connect/lib/factory.js
var factory = __webpack_require__(464);
// EXTERNAL MODULE: ../connect/lib/utils/debug.js
var debug = __webpack_require__(76);
// EXTERNAL MODULE: ../connect/lib/data/config.js
var config = __webpack_require__(608);
// EXTERNAL MODULE: ../utils/src/createDeferredManager.ts
var createDeferredManager = __webpack_require__(812);
// EXTERNAL MODULE: ../utils/src/createDeferred.ts
var createDeferred = __webpack_require__(316);
// EXTERNAL MODULE: ../connect/lib/utils/urlUtils.js
var urlUtils = __webpack_require__(264);
;// CONCATENATED MODULE: ./src/iframe/inlineStyles.ts
// origin: https://github.com/trezor/connect/blob/develop/src/js/iframe/inline-styles.js

const css = '.trezorconnect-container{position:fixed!important;display:-webkit-box!important;display:-webkit-flex!important;display:-ms-flexbox!important;display:flex!important;-webkit-box-orient:vertical!important;-webkit-box-direction:normal!important;-webkit-flex-direction:column!important;-ms-flex-direction:column!important;flex-direction:column!important;-webkit-box-align:center!important;-webkit-align-items:center!important;-ms-flex-align:center!important;align-items:center!important;z-index:10000!important;width:100%!important;height:100%!important;top:0!important;left:0!important;background:rgba(0,0,0,.35)!important;overflow:auto!important;padding:20px!important;margin:0!important}.trezorconnect-container .trezorconnect-window{position:relative!important;display:block!important;width:370px!important;font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,"Helvetica Neue",Arial,sans-serif!important;margin:auto!important;border-radius:3px!important;background-color:#fff!important;text-align:center!important;overflow:hidden!important}.trezorconnect-container .trezorconnect-window .trezorconnect-head{text-align:left;padding:12px 24px!important;display:-webkit-box!important;display:-webkit-flex!important;display:-ms-flexbox!important;display:flex!important;-webkit-box-align:center!important;-webkit-align-items:center!important;-ms-flex-align:center!important;align-items:center!important}.trezorconnect-container .trezorconnect-window .trezorconnect-head .trezorconnect-logo{-webkit-box-flex:1;-webkit-flex:1;-ms-flex:1;flex:1}.trezorconnect-container .trezorconnect-window .trezorconnect-head .trezorconnect-close{cursor:pointer!important;height:24px!important}.trezorconnect-container .trezorconnect-window .trezorconnect-head .trezorconnect-close svg{fill:#757575;-webkit-transition:fill .3s ease-in-out!important;transition:fill .3s ease-in-out!important}.trezorconnect-container .trezorconnect-window .trezorconnect-head .trezorconnect-close:hover svg{fill:#494949}.trezorconnect-container .trezorconnect-window .trezorconnect-body{padding:24px 24px 32px!important;background:#FBFBFB!important;border-top:1px solid #EBEBEB}.trezorconnect-container .trezorconnect-window .trezorconnect-body h3{color:#505050!important;font-size:16px!important;font-weight:500!important}.trezorconnect-container .trezorconnect-window .trezorconnect-body p{margin:8px 0 24px!important;font-weight:400!important;color:#A9A9A9!important;font-size:12px!important}.trezorconnect-container .trezorconnect-window .trezorconnect-body button{width:100%!important;padding:12px 24px!important;margin:0!important;border-radius:3px!important;font-size:14px!important;font-weight:300!important;cursor:pointer!important;background:#01B757!important;color:#fff!important;border:0!important;-webkit-transition:background-color .3s ease-in-out!important;transition:background-color .3s ease-in-out!important}.trezorconnect-container .trezorconnect-window .trezorconnect-body button:hover{background-color:#00AB51!important}.trezorconnect-container .trezorconnect-window .trezorconnect-body button:active{background-color:#009546!important}/*# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbImlucHV0IiwiJHN0ZGluIl0sIm5hbWVzIjpbXSwibWFwcGluZ3MiOiJBQWNBLHlCQUNJLFNBQUEsZ0JBQ0EsUUFBQSxzQkFDQSxRQUFBLHVCQUNBLFFBQUEsc0JBRUEsUUFBQSxlQUNBLG1CQUFBLG1CQUNBLHNCQUFBLGlCQUNBLHVCQUFBLGlCQUNBLG1CQUFBLGlCQUNBLGVBQUEsaUJBRUEsa0JBQUEsaUJBQ0Esb0JBQUEsaUJBQ0EsZUFBQSxpQkNmTSxZQUFhLGlCREFyQixRQUFTLGdCQWtCSCxNQUFBLGVBQ0EsT0FBQSxlQUNBLElBQUEsWUFDQSxLQUFBLFlBQ0EsV0FBQSwwQkFDQSxTQUFBLGVBQ0EsUUFBQSxlQUNBLE9BQUEsWUNkUiwrQ0RYRSxTQUFVLG1CQTZCQSxRQUFBLGdCQUNBLE1BQUEsZ0JBQ0EsWUFBQSxjQUFBLG1CQUFBLFdBQUEsT0FBQSxpQkFBQSxNQUFBLHFCQUNBLE9BQUEsZUNmVixjQUFlLGNEakJmLGlCQWlCRSxlQWtCWSxXQUFBLGlCQ2ZkLFNBQVUsaUJEbUJJLG1FQUNBLFdBQUEsS0NoQmQsUUFBUyxLQUFLLGVEeEJkLFFBQVMsc0JBMENTLFFBQUEsdUJBQ0EsUUFBQSxzQkNmbEIsUUFBUyxlRGlCSyxrQkE1QlosaUJBOEJvQixvQkFBQSxpQkNoQmxCLGVBQWdCLGlCRC9CWixZQWlCTixpQkFzQ1EsdUZBQ0EsaUJBQUEsRUNwQlYsYUFBYyxFRHBDVixTQUFVLEVBMkRBLEtBQUEsRUFFQSx3RkNwQmQsT0FBUSxrQkR6Q1IsT0FBUSxlQWlFTSw0RkFDQSxLQUFBLFFBQ0EsbUJBQUEsS0FBQSxJQUFBLHNCQ3BCZCxXQUFZLEtBQUssSUFBSyxzQkR3QlIsa0dBQ0EsS0FBQSxRQUVBLG1FQUNBLFFBQUEsS0FBQSxLQUFBLGVBQ0EsV0FBQSxrQkFDQSxXQUFBLElBQUEsTUFBQSxRQUVBLHNFQUNBLE1BQUEsa0JBQ0EsVUFBQSxlQ3JCZCxZQUFhLGNEd0JLLHFFQ3JCbEIsT0FBUSxJQUFJLEVBQUksZUR3QkYsWUFBQSxjQUNJLE1BQUEsa0JDdEJsQixVQUFXLGVBRWIsMEVBQ0UsTUFBTyxlQUNQLFFBQVMsS0FBSyxlQUNkLE9BQVEsWUFDUixjQUFlLGNBQ2YsVUFBVyxlQUNYLFlBQWEsY0FDYixPQUFRLGtCQUNSLFdBQVksa0JBQ1osTUFBTyxlQUNQLE9BQVEsWUFDUixtQkFBb0IsaUJBQWlCLElBQUssc0JBQzFDLFdBQVksaUJBQWlCLElBQUssc0JBRXBDLGdGQUNFLGlCQUFrQixrQkFFcEIsaUZBQ0UsaUJBQWtCIn0= */';
/* harmony default export */ const inlineStyles = (css);
;// CONCATENATED MODULE: ./src/iframe/index.ts
// origin: https://github.com/trezor/connect/blob/develop/src/js/iframe/builder.js







let instance;
let origin;
let initPromise = (0,createDeferred/* createDeferred */.E)();
let timeout = 0;
let error;
const dispose = () => {
  if (instance && instance.parentNode) {
    try {
      instance.parentNode.removeChild(instance);
    } catch (e) {
      // do nothing
    }
  }
  instance = null;
  timeout = 0;
};
const handleIframeBlocked = () => {
  window.clearTimeout(timeout);
  error = errors.TypedError('Init_IframeBlocked');
  dispose();
  initPromise.reject(error);
};
const injectStyleSheet = () => {
  if (!instance) {
    throw errors.TypedError('Init_IframeBlocked');
  }
  const doc = instance.ownerDocument;
  const head = doc.head || doc.getElementsByTagName('head')[0];
  const style = document.createElement('style');
  style.setAttribute('type', 'text/css');
  style.setAttribute('id', 'TrezorConnectStylesheet');

  // @ts-expect-error
  if (style.styleSheet) {
    // @ts-expect-error
    style.styleSheet.cssText = inlineStyles;
    head.appendChild(style);
  } else {
    style.appendChild(document.createTextNode(inlineStyles));
    head.append(style);
  }
};
const init = async settings => {
  initPromise = (0,createDeferred/* createDeferred */.E)();
  const existedFrame = document.getElementById('trezorconnect');
  if (existedFrame) {
    instance = existedFrame;
  } else {
    instance = document.createElement('iframe');
    instance.frameBorder = '0';
    instance.width = '0px';
    instance.height = '0px';
    instance.style.position = 'absolute';
    instance.style.display = 'none';
    instance.style.border = '0px';
    instance.style.width = '0px';
    instance.style.height = '0px';
    instance.id = 'trezorconnect';
  }
  let src;
  if (settings.env === 'web') {
    const manifestString = settings.manifest ? JSON.stringify(settings.manifest) : 'undefined'; // note: btoa(undefined) === btoa('undefined') === "dW5kZWZpbmVk"
    const manifest = `version=${settings.version}&manifest=${encodeURIComponent(btoa(JSON.stringify(manifestString)))}`;
    src = `${settings.iframeSrc}?${manifest}`;
  } else {
    src = settings.iframeSrc;
  }
  instance.setAttribute('src', src);
  if (settings.webusb) {
    console.warn('webusb option is deprecated. use `transports: ["WebUsbTransport"] instead`');
  }
  if (navigator.usb) {
    instance.setAttribute('allow', 'usb');
  }
  origin = (0,urlUtils/* getOrigin */.iK)(instance.src);
  timeout = window.setTimeout(() => {
    initPromise.reject(errors.TypedError('Init_IframeTimeout'));
  }, 10000);
  const onLoad = () => {
    if (!instance) {
      initPromise.reject(errors.TypedError('Init_IframeBlocked'));
      return;
    }
    try {
      // if hosting page is able to access cross-origin location it means that the iframe is not loaded
      const iframeOrigin = instance.contentWindow?.location.origin;
      if (!iframeOrigin || iframeOrigin === 'null') {
        handleIframeBlocked();
        return;
      }
    } catch (e) {
      // empty
    }
    let extension;
    if (typeof chrome !== 'undefined' && chrome.runtime && typeof chrome.runtime.onConnect !== 'undefined') {
      chrome.runtime.onConnect.addListener(() => {});
      extension = chrome.runtime.id;
    }
    instance.contentWindow?.postMessage({
      type: lib_events.IFRAME.INIT,
      payload: {
        settings,
        extension
      }
    }, origin);
    instance.onload = null;
  };

  // IE hack
  // @ts-expect-error
  if (instance.attachEvent) {
    // @ts-expect-error
    instance.attachEvent('onload', onLoad);
  } else {
    instance.onload = onLoad;
  }
  // inject iframe into host document body
  if (document.body) {
    document.body.appendChild(instance);
    injectStyleSheet();
  }
  try {
    await initPromise.promise;
  } catch (e) {
    // reset state to allow initialization again
    if (instance) {
      if (instance.parentNode) {
        instance.parentNode.removeChild(instance);
      }
      instance = null;
    }
    throw e;
  } finally {
    window.clearTimeout(timeout);
    timeout = 0;
  }
};
const postMessage = message => {
  if (!instance) {
    throw errors.TypedError('Init_IframeBlocked');
  }
  instance.contentWindow?.postMessage(message, origin);
};
const iframe_clearTimeout = () => {
  window.clearTimeout(timeout);
};
const initIframeLogger = () => {
  const logWriterFactory = () => ({
    add: message => {
      postMessage({
        type: lib_events.IFRAME.LOG,
        payload: message
      });
    }
  });
  (0,debug/* setLogWriter */.UZ)(logWriterFactory);
};
;// CONCATENATED MODULE: ./src/popup/showPopupRequest.ts
// origin: https://github.com/trezor/connect/blob/develop/src/js/popup/showPopupRequest.js

const LAYER_ID = 'TrezorConnectInteractionLayer';
const HTML = `
    <div class="trezorconnect-container" id="${LAYER_ID}">
        <div class="trezorconnect-window">
            <div class="trezorconnect-head">
                <svg class="trezorconnect-logo" x="0px" y="0px" viewBox="0 0 163.7 41.9" width="78px" height="20px" preserveAspectRatio="xMinYMin meet">
                    <polygon points="101.1,12.8 118.2,12.8 118.2,17.3 108.9,29.9 118.2,29.9 118.2,35.2 101.1,35.2 101.1,30.7 110.4,18.1 101.1,18.1"/>
                    <path d="M158.8,26.9c2.1-0.8,4.3-2.9,4.3-6.6c0-4.5-3.1-7.4-7.7-7.4h-10.5v22.3h5.8v-7.5h2.2l4.1,7.5h6.7L158.8,26.9z M154.7,22.5 h-4V18h4c1.5,0,2.5,0.9,2.5,2.2C157.2,21.6,156.2,22.5,154.7,22.5z"/>
                    <path d="M130.8,12.5c-6.8,0-11.6,4.9-11.6,11.5s4.9,11.5,11.6,11.5s11.7-4.9,11.7-11.5S137.6,12.5,130.8,12.5z M130.8,30.3 c-3.4,0-5.7-2.6-5.7-6.3c0-3.8,2.3-6.3,5.7-6.3c3.4,0,5.8,2.6,5.8,6.3C136.6,27.7,134.2,30.3,130.8,30.3z"/>
                    <polygon points="82.1,12.8 98.3,12.8 98.3,18 87.9,18 87.9,21.3 98,21.3 98,26.4 87.9,26.4 87.9,30 98.3,30 98.3,35.2 82.1,35.2 "/>
                    <path d="M24.6,9.7C24.6,4.4,20,0,14.4,0S4.2,4.4,4.2,9.7v3.1H0v22.3h0l14.4,6.7l14.4-6.7h0V12.9h-4.2V9.7z M9.4,9.7 c0-2.5,2.2-4.5,5-4.5s5,2,5,4.5v3.1H9.4V9.7z M23,31.5l-8.6,4l-8.6-4V18.1H23V31.5z"/>
                    <path d="M79.4,20.3c0-4.5-3.1-7.4-7.7-7.4H61.2v22.3H67v-7.5h2.2l4.1,7.5H80l-4.9-8.3C77.2,26.1,79.4,24,79.4,20.3z M71,22.5h-4V18 h4c1.5,0,2.5,0.9,2.5,2.2C73.5,21.6,72.5,22.5,71,22.5z"/>
                    <polygon points="40.5,12.8 58.6,12.8 58.6,18.1 52.4,18.1 52.4,35.2 46.6,35.2 46.6,18.1 40.5,18.1 "/>
                </svg>
                <div class="trezorconnect-close">
                    <svg x="0px" y="0px" viewBox="24 24 60 60" width="24px" height="24px" preserveAspectRatio="xMinYMin meet">
                        <polygon class="st0" points="40,67.9 42.1,70 55,57.1 67.9,70 70,67.9 57.1,55 70,42.1 67.9,40 55,52.9 42.1,40 40,42.1 52.9,55 "/>
                    </svg>
                </div>
            </div>
            <div class="trezorconnect-body">
                <h3>Popup was blocked</h3>
                <p>Please click to "Continue" to open popup manually</p>
                <button class="trezorconnect-open">Continue</button>
            </div>
        </div>
    </div>
`;
const showPopupRequest = (open, cancel) => {
  if (document.getElementById(LAYER_ID)) {
    return;
  }
  const div = document.createElement('div');
  div.id = LAYER_ID;
  div.className = 'trezorconnect-container';
  div.innerHTML = HTML;
  if (document.body) {
    document.body.appendChild(div);
  }
  const button = div.getElementsByClassName('trezorconnect-open')[0];
  button.onclick = () => {
    open();
    if (document.body) {
      document.body.removeChild(div);
    }
  };
  const close = div.getElementsByClassName('trezorconnect-close')[0];
  close.onclick = () => {
    cancel();
    if (document.body) {
      document.body.removeChild(div);
    }
  };
};
// EXTERNAL MODULE: ../utils/src/typedEventEmitter.ts
var typedEventEmitter = __webpack_require__(932);
;// CONCATENATED MODULE: ../connect-common/src/storage.ts
// https://github.com/trezor/connect/blob/develop/src/js/storage/index.js


const storageVersion = 2;
const storageName = `storage_v${storageVersion}`;

/**
 * remembered:
 *  - physical device from webusb pairing dialogue
 *  - passphrase to be used
 */

// TODO: move storage somewhere else. Having it here brings couple of problems:
// - We can not import types from connect (would cause cyclic dependency)
// - it has here dependency on window object, not good

const getEmptyState = () => ({
  origin: {}
});
let memoryStorage = getEmptyState();
const getPermanentStorage = () => {
  const ls = localStorage.getItem(storageName);
  return ls ? JSON.parse(ls) : getEmptyState();
};
class Storage extends typedEventEmitter/* TypedEmitter */.I {
  save(getNewState, temporary = false) {
    if (temporary || !__webpack_require__.g.window) {
      memoryStorage = getNewState(memoryStorage);
      return;
    }
    try {
      const newState = getNewState(getPermanentStorage());
      localStorage.setItem(storageName, JSON.stringify(newState));
      this.emit('changed', newState);
    } catch (err) {
      // memory storage is fallback of the last resort
      console.warn('long term storage not available');
      memoryStorage = getNewState(memoryStorage);
    }
  }
  saveForOrigin(getNewState, origin, temporary = false) {
    this.save(state => ({
      ...state,
      origin: {
        ...state.origin,
        [origin]: getNewState(state.origin?.[origin] || {})
      }
    }), temporary);
  }
  load(temporary = false) {
    if (temporary || !__webpack_require__.g?.window?.localStorage) {
      return memoryStorage;
    }
    try {
      return getPermanentStorage();
    } catch (err) {
      // memory storage is fallback of the last resort
      console.warn('long term storage not available');
      return memoryStorage;
    }
  }
  loadForOrigin(origin, temporary = false) {
    const state = this.load(temporary);
    return state.origin?.[origin] || {};
  }
}
const storage = new Storage();

// EXTERNAL MODULE: ../utils/src/scheduleAction.ts
var scheduleAction = __webpack_require__(108);
;// CONCATENATED MODULE: ../connect-common/src/messageChannel/abstract.ts
/**
 * IMPORTS WARNING
 * this file is bundled into content script so be careful what you are importing not to bloat the bundle
 */





// TODO: so logger should be probably moved to connect common, or this file should be moved to connect
// import type { Log } from '@trezor/connect/lib/utils/debug';

/**
 * concepts:
 * - it handshakes automatically with the other side of the channel
 * - it queues messages fired before handshake and sends them after handshake is done
 */
class AbstractMessageChannel extends typedEventEmitter/* TypedEmitter */.I {
  messagePromises = {};
  /** queue of messages that were scheduled before handshake */
  messagesQueue = [];
  messageID = 0;
  isConnected = false;
  handshakeMaxRetries = 5;
  handshakeRetryInterval = 2000;

  /**
   * function that passes data to the other side of the channel
   */

  /**
   * channel identifiers that pairs AbstractMessageChannel instances on sending and receiving end together
   */

  constructor({
    sendFn,
    channel,
    logger,
    lazyHandshake = false,
    legacyMode = false
  }) {
    super();
    this.channel = channel;
    this.sendFn = sendFn;
    this.lazyHandshake = lazyHandshake;
    this.legacyMode = legacyMode;
    this.logger = logger;
  }

  /**
   * initiates handshake sequence with peer. resolves after communication with peer is established
   */
  init() {
    if (!this.handshakeFinished) {
      this.handshakeFinished = (0,createDeferred/* createDeferred */.E)();
      if (this.legacyMode) {
        // Bypass handshake for communication with legacy components
        // We add a delay for enough time for the other side to be ready
        setTimeout(() => {
          this.handshakeFinished?.resolve();
        }, 500);
      }
      if (!this.lazyHandshake) {
        // When `lazyHandshake` handshakeWithPeer will start when received channel-handshake-request.
        this.handshakeWithPeer();
      }
    }
    return this.handshakeFinished.promise;
  }

  /**
   * handshake between both parties of the channel.
   * both parties initiate handshake procedure and keep asking over time in a loop until they time out or receive confirmation from peer
   */
  handshakeWithPeer() {
    this.logger?.log(this.channel.here, 'handshake');
    return (0,scheduleAction/* scheduleAction */.a)(async () => {
      this.postMessage({
        type: 'channel-handshake-request',
        data: {
          success: true,
          payload: undefined
        }
      }, {
        usePromise: false,
        useQueue: false
      });
      await this.handshakeFinished?.promise;
    }, {
      attempts: this.handshakeMaxRetries,
      timeout: this.handshakeRetryInterval
    }).then(() => {
      this.logger?.log(this.channel.here, 'handshake confirmed');
      this.messagesQueue.forEach(message => {
        message.channel = this.channel;
        this.sendFn(message);
      });
      this.messagesQueue = [];
    }).catch(() => {
      this.handshakeFinished?.reject(new Error('handshake failed'));
      this.handshakeFinished = undefined;
    });
  }

  /**
   * message received from communication channel in descendants of this class
   * should be handled by this common onMessage method
   */
  onMessage(_message) {
    // Older code used to send message as a data property of the message object.
    // This is a workaround to keep backward compatibility.
    let message = _message;
    if (this.legacyMode && message.type === undefined && 'data' in message && typeof message.data === 'object' && message.data !== null && 'type' in message.data && typeof message.data.type === 'string') {
      // @ts-expect-error
      message = message.data;
    }
    const {
      channel,
      id,
      type,
      payload,
      success
    } = message;

    // Don't verify channel in legacy mode
    if (!this.legacyMode) {
      if (!channel?.peer || channel.peer !== this.channel.here) {
        // To wrong peer
        return;
      }
      if (!channel?.here || this.channel.peer !== channel.here) {
        // From wrong peer
        return;
      }
    }
    if (type === 'channel-handshake-request') {
      this.postMessage({
        type: 'channel-handshake-confirm',
        data: {
          success: true,
          payload: undefined
        }
      }, {
        usePromise: false,
        useQueue: false
      });
      if (this.lazyHandshake) {
        // When received channel-handshake-request in lazyHandshake mode we start from this side.
        this.handshakeWithPeer();
      }
      return;
    }
    if (type === 'channel-handshake-confirm') {
      this.handshakeFinished?.resolve(undefined);
      return;
    }
    if (this.messagePromises[id]) {
      this.messagePromises[id].resolve({
        id,
        payload,
        success
      });
      delete this.messagePromises[id];
    }
    const messagePromisesLength = Object.keys(this.messagePromises).length;
    if (messagePromisesLength > 5) {
      this.logger?.warn(`too many message promises (${messagePromisesLength}). this feels unexpected!`);
    }

    // @ts-expect-error TS complains for odd reasons
    this.emit('message', message);
  }

  // todo: outgoing messages should be typed
  postMessage(message, {
    usePromise = true,
    useQueue = true
  } = {}) {
    message.channel = this.channel;
    if (!usePromise) {
      try {
        this.sendFn(message);
      } catch (err) {
        if (useQueue) {
          this.messagesQueue.push(message);
        }
      }
      return;
    }
    this.messageID++;
    message.id = this.messageID;
    this.messagePromises[message.id] = (0,createDeferred/* createDeferred */.E)();
    try {
      this.sendFn(message);
    } catch (err) {
      if (useQueue) {
        this.messagesQueue.push(message);
      }
    }
    return this.messagePromises[message.id].promise;
  }
  resolveMessagePromises(resolvePayload) {
    // This is used when we know that the connection has been interrupted but there might be something waiting for it.
    Object.keys(this.messagePromises).forEach(id => this.messagePromises[id].resolve({
      id,
      payload: resolvePayload
    }));
  }
  clear() {
    this.handshakeFinished = undefined;
  }
}
;// CONCATENATED MODULE: ../connect-common/src/index.ts



;// CONCATENATED MODULE: ./src/channels/serviceworker-window.ts


/**
 * Communication channel between:
 * - here: chrome message port (in service worker)
 * - peer: window.onMessage in trezor-content-script
 */
class ServiceWorkerWindowChannel extends AbstractMessageChannel {
  constructor({
    name,
    channel,
    logger,
    lazyHandshake,
    legacyMode,
    allowSelfOrigin = false,
    currentId
  }) {
    super({
      channel,
      sendFn: message => {
        if (!this.port) throw new Error('port not assigned');
        this.port.postMessage(message);
      },
      logger,
      lazyHandshake,
      legacyMode
    });
    this.name = name;
    this.allowSelfOrigin = allowSelfOrigin;
    this.currentId = currentId;
    this.connect();
  }
  connect() {
    chrome.runtime.onConnect.addListener(port => {
      if (port.name !== this.name) return;
      // Ignore port if name does match, but port created by different popup
      if (this.currentId?.() && this.currentId?.() !== port.sender?.tab?.id) return;
      this.port = port;
      this.port.onMessage.addListener((message, {
        sender
      }) => {
        if (!sender) {
          this.logger?.error('service-worker-window', 'no sender');
          return;
        }
        const {
          origin
        } = sender;
        const whitelist = ['https://connect.trezor.io', 'https://staging-connect.trezor.io', 'https://suite.corp.sldev.cz', 'http://localhost:8088'];

        // If service worker is running in web extension and other env of this webextension
        // want to communicate with service worker it should be whitelisted.
        const webextensionId = chrome?.runtime?.id;
        if (webextensionId) {
          whitelist.push(`chrome-extension://${webextensionId}`);
        }
        if (!origin) {
          this.logger?.error('connect-webextension/messageChannel/extensionPort/onMessage', 'no origin');
          return;
        }
        if (!whitelist.includes(origin)) {
          this.logger?.error('connect-webextension/messageChannel/extensionPort/onMessage', 'origin not whitelisted', origin);
          return;
        }

        // TODO: not completely sure that is necessary to prevent self origin communication sometimes.
        if (origin === self.origin && !this.allowSelfOrigin) {
          return;
        }
        this.onMessage(message);
      });
    });
    this.isConnected = true;
  }
  disconnect() {
    if (!this.isConnected) return;
    this.port?.disconnect();
    this.clear();
    this.isConnected = false;
  }
}
;// CONCATENATED MODULE: ./src/channels/window-window.ts


/**
 * Communication channel between:
 * - here: window.postMessage
 * - peer: window.onMessage
 */

class WindowWindowChannel extends AbstractMessageChannel {
  constructor({
    windowHere,
    windowPeer,
    channel,
    logger,
    origin
  }) {
    super({
      channel,
      sendFn: message => {
        windowPeer()?.postMessage(message, origin);
      },
      logger
    });
    this._listener = this.listener.bind(this);
    this._windowHere = windowHere;
    this.connect();
  }
  listener(event) {
    const message = {
      ...event.data,
      success: true,
      origin: event.origin,
      payload: event.data.payload || {},
      // This is added for compatibility when communicating with iframe/popup that doesn't have channel defined yet
      channel: event.data.channel || {
        peer: this.channel.here,
        here: this.channel.peer
      }
    };
    this.onMessage(message);
  }
  connect() {
    this._windowHere.addEventListener('message', this._listener);
    this.isConnected = true;
  }
  disconnect() {
    if (!this.isConnected) return;
    this._windowHere.removeEventListener('message', this._listener);
    this.isConnected = false;
  }
}
;// CONCATENATED MODULE: ./src/popup/index.ts
// origin: https://github.com/trezor/connect/blob/develop/src/js/popup/PopupManager.js









// Util
const checkIfTabExists = tabId => new Promise(resolve => {
  if (!tabId) return resolve(false);
  function callback() {
    if (chrome.runtime.lastError) {
      resolve(false);
    } else {
      // Tab exists
      resolve(true);
    }
  }
  chrome.tabs.get(tabId, callback);
});

// Event `POPUP_REQUEST_TIMEOUT` is used to close Popup window when there was no handshake from iframe.
const POPUP_REQUEST_TIMEOUT = 850;
const POPUP_CLOSE_INTERVAL = 500;
const POPUP_OPEN_TIMEOUT = 3000;
class PopupManager extends (events_default()) {
  locked = false;
  extensionTabId = 0;
  constructor(settings, {
    logger
  }) {
    super();
    this.settings = settings;
    this.origin = (0,urlUtils/* getOrigin */.iK)(settings.popupSrc);
    this.logger = logger;
    if (this.settings.env === 'webextension') {
      this.channel = new ServiceWorkerWindowChannel({
        name: 'trezor-connect',
        channel: {
          here: '@trezor/connect-webextension',
          peer: '@trezor/connect-content-script'
        },
        logger,
        currentId: () => {
          if (this.popupWindow?.mode === 'tab') return this.popupWindow?.tab.id;
        },
        legacyMode: !this.settings.useCoreInPopup
      });
    } else {
      this.channel = new WindowWindowChannel({
        windowHere: window,
        windowPeer: () => {
          if (this.popupWindow?.mode === 'window') return this.popupWindow?.window;
        },
        channel: {
          here: '@trezor/connect-web',
          peer: '@trezor/connect-popup'
        },
        logger,
        origin: this.origin
      });
    }
    if (!this.settings.useCoreInPopup) {
      // If not in core, we need to create a channel for the iframe
      this.iframeHandshakePromise = (0,createDeferred/* createDeferred */.E)(lib_events.IFRAME.LOADED);
      this.channelIframe = new WindowWindowChannel({
        windowHere: window,
        windowPeer: () => window,
        channel: {
          here: '@trezor/connect-web',
          peer: '@trezor/connect-iframe'
        },
        logger,
        origin: this.origin
      });
      this.channelIframe?.on('message', this.handleMessage.bind(this));
    }
    if (this.settings.useCoreInPopup) {
      // Core mode
      this.handshakePromise = (0,createDeferred/* createDeferred */.E)();
      this.channel.on('message', this.handleCoreMessage.bind(this));
    } else if (this.settings.env === 'webextension') {
      // Webextension iframe
      this.channel.on('message', this.handleExtensionMessage.bind(this));
    } else {
      // Web
      this.channel.on('message', this.handleMessage.bind(this));
    }
    this.channel.init();
  }
  async request() {
    // popup request

    // check if current popup window is still open
    if (this.settings.useCoreInPopup && this.popupWindow?.mode === 'tab') {
      const currentPopupExists = await checkIfTabExists(this.popupWindow?.tab?.id);
      if (!currentPopupExists) {
        this.clear();
      }
    }

    // bring popup window to front
    if (this.locked) {
      if (this.popupWindow?.mode === 'tab' && this.popupWindow.tab.id) {
        chrome.tabs.update(this.popupWindow.tab.id, {
          active: true
        });
      } else if (this.popupWindow?.mode === 'window') {
        this.popupWindow.window.focus();
      }
      return;
    }

    // When requesting a popup window and there is a reference to popup window and it is not locked
    // we close it so we can open a new one.
    // This is necessary when popup window is in error state and we want to open a new one.
    if (this.popupWindow && !this.locked) {
      this.close();
    }
    const openFn = this.open.bind(this);
    this.locked = true;
    const timeout = this.settings.env === 'webextension' ? 1 : POPUP_REQUEST_TIMEOUT;
    this.requestTimeout = setTimeout(() => {
      this.requestTimeout = undefined;
      openFn();
    }, timeout);
  }
  unlock() {
    this.locked = false;
  }
  open() {
    const src = this.settings.popupSrc;
    if (this.settings.useCoreInPopup) {
      // Timeout not used in Core mode, we can't run showPopupRequest with no DOM
      this.openWrapper(src);
      return;
    }
    this.popupPromise = (0,createDeferred/* createDeferred */.E)(lib_events.POPUP.LOADED);
    this.openWrapper(src);
    this.closeInterval = setInterval(() => {
      if (!this.popupWindow) return;
      if (this.popupWindow.mode === 'tab' && this.popupWindow.tab.id) {
        chrome.tabs.get(this.popupWindow.tab.id, tab => {
          if (!tab) {
            // If no reference to popup window, it was closed by user or by this.close() method.
            this.emit(lib_events.POPUP.CLOSED);
            this.clear();
          }
        });
      } else if (this.popupWindow.mode === 'window' && this.popupWindow.window.closed) {
        this.clear();
        this.emit(lib_events.POPUP.CLOSED);
      }
    }, POPUP_CLOSE_INTERVAL);

    // open timeout will be cancelled by POPUP.BOOTSTRAP message
    this.openTimeout = setTimeout(() => {
      this.clear();
      showPopupRequest(this.open.bind(this), () => {
        this.emit(lib_events.POPUP.CLOSED);
      });
    }, POPUP_OPEN_TIMEOUT);
  }
  openWrapper(url) {
    if (this.settings.env === 'webextension') {
      chrome.windows.getCurrent(currentWindow => {
        this.logger.debug('opening popup. currentWindow: ', currentWindow);
        // Request coming from extension popup,
        // create new window above instead of opening new tab
        if (currentWindow.type !== 'normal') {
          chrome.windows.create({
            url
          }, newWindow => {
            chrome.tabs.query({
              windowId: newWindow?.id,
              active: true
            }, tabs => {
              this.popupWindow = {
                mode: 'tab',
                tab: tabs[0]
              };
              this.injectContentScript(tabs[0].id);
            });
          });
        } else {
          chrome.tabs.query({
            currentWindow: true,
            active: true
          }, tabs => {
            this.extensionTabId = tabs[0].id;
            chrome.tabs.create({
              url,
              index: tabs[0].index + 1
            }, tab => {
              this.popupWindow = {
                mode: 'tab',
                tab
              };
              this.injectContentScript(tab.id);
            });
          });
        }
      });
    } else {
      const windowResult = window.open(url, 'modal');
      if (!windowResult) return;
      this.popupWindow = {
        mode: 'window',
        window: windowResult
      };
    }
    if (!this.channel.isConnected) {
      this.channel.connect();
    }
  }
  injectContentScript = tabId => {
    chrome.permissions.getAll(permissions => {
      if (permissions.permissions?.includes('scripting')) {
        chrome.scripting.executeScript({
          target: {
            tabId
          },
          // content script is injected into body of func in build time.
          func: () => {
            // <!--content-script-->
          }
        }).then(() => this.logger.debug('content script injected')).catch(error => this.logger.error('content script injection error', error));
      } else {
        // When permissions for `scripting` are not provided 3rd party integrations have include content-script.js manually.
      }
    });
  };
  handleCoreMessage(message) {
    if (message.type === lib_events.POPUP.CORE_LOADED) {
      this.channel.postMessage({
        type: lib_events.POPUP.HANDSHAKE,
        // in this case, settings will be validated in popup
        payload: {
          settings: this.settings
        }
      });
      this.handshakePromise?.resolve();
    } else if (message.type === lib_events.POPUP.CLOSED) {
      // When popup is closed we should create a not-real response as if the request was interrupted.
      // Because when popup closes and TrezorConnect is living there it cannot respond, but we know
      // it was interrupted so we safely fake it.
      this.channel.resolveMessagePromises({
        code: 'Method_Interrupted',
        error: lib_events.POPUP.CLOSED
      });
    }
  }
  handleExtensionMessage(data) {
    if (data.type === lib_events.POPUP.ERROR || data.type === lib_events.POPUP.LOADED || data.type === lib_events.POPUP.BOOTSTRAP) {
      this.handleMessage(data);
    } else if (data.type === lib_events.POPUP.EXTENSION_USB_PERMISSIONS) {
      chrome.tabs.query({
        currentWindow: true,
        active: true
      }, tabs => {
        chrome.tabs.create({
          url: 'trezor-usb-permissions.html',
          index: tabs[0].index + 1
        }, _tab => {
          // do nothing
        });
      });
    } else if (data.type === lib_events.POPUP.CLOSE_WINDOW) {
      this.clear();
    }
  }
  handleMessage(data) {
    if (data.type === lib_events.IFRAME.LOADED) {
      this.iframeHandshakePromise?.resolve(data.payload);
    } else if (data.type === lib_events.POPUP.BOOTSTRAP) {
      // popup is opened properly, now wait for POPUP.LOADED message
      if (this.openTimeout) clearTimeout(this.openTimeout);
    } else if (data.type === lib_events.POPUP.ERROR && this.popupWindow) {
      // handle popup error
      const errorMessage = data.payload && typeof data.payload.error === 'string' ? data.payload.error : null;
      this.emit(lib_events.POPUP.CLOSED, errorMessage ? `Popup error: ${errorMessage}` : null);
      this.clear();
    } else if (data.type === lib_events.POPUP.LOADED) {
      // in case of webextension where bootstrap message is not sent
      if (this.openTimeout) clearTimeout(this.openTimeout);
      if (this.popupPromise) {
        this.popupPromise.resolve();
      }
      // popup is successfully loaded
      this.iframeHandshakePromise?.promise.then(payload => {
        // send ConnectSettings to popup
        // note this settings and iframe.ConnectSettings could be different (especially: origin, popup, webusb, debug)
        // now popup is able to load assets
        this.channel.postMessage({
          type: lib_events.POPUP.INIT,
          payload: {
            ...payload,
            settings: this.settings
          }
        });
      });
    } else if (data.type === lib_events.POPUP.CANCEL_POPUP_REQUEST || data.type === lib_events.UI.CLOSE_UI_WINDOW) {
      this.clear(false);
    }
  }
  clear(focus = true) {
    this.locked = false;
    this.popupPromise = undefined;
    this.handshakePromise = (0,createDeferred/* createDeferred */.E)();
    if (this.channel) {
      this.channel.disconnect();
    }
    if (this.requestTimeout) {
      clearTimeout(this.requestTimeout);
      this.requestTimeout = undefined;
    }
    if (this.openTimeout) {
      clearTimeout(this.openTimeout);
      this.openTimeout = undefined;
    }
    if (this.closeInterval) {
      clearInterval(this.closeInterval);
      this.closeInterval = undefined;
    }

    // switch to previously focused tab

    if (focus && this.extensionTabId) {
      chrome.tabs.update(this.extensionTabId, {
        active: true
      });
      this.extensionTabId = 0;
    }
  }
  close() {
    if (!this.popupWindow) return;
    this.logger.debug('closing popup');
    if (this.popupWindow.mode === 'tab') {
      let _e = chrome.runtime.lastError;
      if (this.popupWindow.tab.id) {
        chrome.tabs.remove(this.popupWindow.tab.id, () => {
          _e = chrome.runtime.lastError;
          if (_e) {
            this.logger.error('closed with error', _e);
          }
        });
      }
    } else if (this.popupWindow.mode === 'window') {
      this.popupWindow.window.close();
    }
    this.popupWindow = undefined;
  }
  async postMessage(message) {
    // NOTE: This method only seems to be used in one case to show UI.IFRAME_FAILURE
    // Maybe we could handle this in a simpler way?

    // device needs interaction but there is no popup/ui
    // maybe popup request wasn't handled
    // ignore "ui_request_window" type
    if (!this.popupWindow && message.type !== lib_events.UI.REQUEST_UI_WINDOW && this.openTimeout) {
      this.clear();
      showPopupRequest(this.open.bind(this), () => {
        this.emit(lib_events.POPUP.CLOSED);
      });
      return;
    }

    // post message before popup request finalized
    if (this.popupPromise) {
      await this.popupPromise.promise;
    }
    // post message to popup window
    if (this.popupWindow?.mode === 'window') {
      this.popupWindow.window.postMessage(message, this.origin);
    } else if (this.popupWindow?.mode === 'tab') {
      this.channel.postMessage(message);
    }
  }
}
;// CONCATENATED MODULE: ./src/webusb/button.ts
// origin: https://github.com/trezor/connect/blob/develop/src/js/webusb/button.js

const render = (className = '', url) => {
  const query = className || '.trezor-webusb-button';
  const buttons = document.querySelectorAll(query);
  const src = `${url}?${Date.now()}`;
  buttons.forEach(b => {
    if (b.getElementsByTagName('iframe').length < 1) {
      const bounds = b.getBoundingClientRect();
      const btnIframe = document.createElement('iframe');
      btnIframe.frameBorder = '0';
      btnIframe.width = `${Math.round(bounds.width)}px`;
      btnIframe.height = `${Math.round(bounds.height)}px`;
      btnIframe.style.position = 'absolute';
      btnIframe.style.top = '0px';
      btnIframe.style.left = '0px';
      btnIframe.style.zIndex = '1';
      // btnIframe.style.opacity = '0'; // this makes click impossible on cross-origin
      btnIframe.setAttribute('allow', 'usb');
      btnIframe.setAttribute('scrolling', 'no');
      btnIframe.src = src;

      // inject iframe into button
      b.append(btnIframe);
    }
  });
};
/* harmony default export */ const webusb_button = (render);
// EXTERNAL MODULE: ../connect/lib/data/connectSettings.js
var connectSettings = __webpack_require__(632);
;// CONCATENATED MODULE: ./src/connectSettings.ts

const getEnv = () => {
  if (typeof chrome !== 'undefined' && typeof chrome.runtime?.onConnect !== 'undefined') {
    return 'webextension';
  }
  if (typeof navigator !== 'undefined') {
    if (typeof navigator.product === 'string' && navigator.product.toLowerCase() === 'reactnative') {
      return 'react-native';
    }
    const userAgent = navigator.userAgent.toLowerCase();
    if (userAgent.indexOf(' electron/') > -1) {
      return 'electron';
    }
  }
  return 'web';
};
const processQueryString = (url, keys) => {
  const searchParams = new URLSearchParams(url);
  const result = {};
  const paramArray = Array.from(searchParams.entries());
  paramArray.forEach(([key, value]) => {
    if (keys.includes(key)) {
      result[key] = decodeURIComponent(value);
    }
  });
  return result;
};

/**
 * Settings from host
 * @param input Partial<ConnectSettings>
 */
const parseConnectSettings = (input = {}) => {
  const settings = {
    popup: true,
    ...input
  };
  // For debugging purposes `connectSrc` could be defined in `global.__TREZOR_CONNECT_SRC` variable
  let globalSrc;
  if (typeof window !== 'undefined') {
    // @ts-expect-error not defined in globals outside of the package
    globalSrc = window.__TREZOR_CONNECT_SRC;
  } else if (typeof __webpack_require__.g !== 'undefined') {
    globalSrc = __webpack_require__.g.__TREZOR_CONNECT_SRC;
  }
  if (typeof globalSrc === 'string') {
    settings.connectSrc = globalSrc;
    settings.debug = true;
  }
  if (typeof window !== 'undefined' && typeof window.location?.search === 'string') {
    const query = processQueryString(window.location.search, ['trezor-connect-src']);
    // For debugging purposes `connectSrc` could be defined in url query of hosting page. Usage:
    // https://3rdparty-page.com/?trezor-connect-src=https://localhost:8088/
    if (query['trezor-connect-src']) {
      settings.debug = true;
      settings.connectSrc = query['trezor-connect-src'];
    }
  }
  if (typeof input.env !== 'string') {
    settings.env = getEnv();
  }
  return (0,connectSettings/* parseConnectSettings */.a8)(settings);
};
;// CONCATENATED MODULE: ./src/index.ts


// NOTE: @trezor/connect part is intentionally not imported from the index due to NormalReplacementPlugin
// in packages/suite-build/configs/web.webpack.config.ts










const eventEmitter = new (events_default())();
const _log = (0,debug/* initLog */.O2)('@trezor/connect-web');
let _settings = parseConnectSettings();
let _popupManager;
const messagePromises = (0,createDeferredManager/* createDeferredManager */.C)({
  initialId: 1
});
const initPopupManager = () => {
  const pm = new PopupManager(_settings, {
    logger: _log
  });
  pm.on(lib_events.POPUP.CLOSED, error => {
    postMessage({
      type: lib_events.POPUP.CLOSED,
      payload: error ? {
        error
      } : null
    });
  });
  return pm;
};
const manifest = data => {
  _settings = parseConnectSettings({
    ..._settings,
    manifest: data
  });
};
const src_dispose = () => {
  eventEmitter.removeAllListeners();
  dispose();
  _settings = parseConnectSettings();
  if (_popupManager) {
    _popupManager.close();
  }
  return Promise.resolve(undefined);
};
const cancel = error => {
  if (_popupManager) {
    _popupManager.emit(lib_events.POPUP.CLOSED, error);
  }
};

// handle message received from iframe
const handleMessage = messageEvent => {
  // ignore messages from domain other then iframe origin
  if (messageEvent.origin !== origin) return;
  const message = (0,lib_events.parseMessage)(messageEvent.data);
  _log.log('handleMessage', message);
  switch (message.event) {
    case lib_events.RESPONSE_EVENT:
      {
        const {
          id = 0,
          success,
          payload
        } = message;
        const resolved = messagePromises.resolve(id, {
          id,
          success,
          payload
        });
        if (!resolved) _log.warn(`Unknown message id ${id}`);
        break;
      }
    case lib_events.DEVICE_EVENT:
      // pass DEVICE event up to html
      eventEmitter.emit(message.event, message);
      eventEmitter.emit(message.type, message.payload); // DEVICE_EVENT also emit single events (connect/disconnect...)
      break;
    case lib_events.TRANSPORT_EVENT:
      eventEmitter.emit(message.event, message);
      eventEmitter.emit(message.type, message.payload);
      break;
    case lib_events.BLOCKCHAIN_EVENT:
      eventEmitter.emit(message.event, message);
      eventEmitter.emit(message.type, message.payload);
      break;
    case lib_events.UI_EVENT:
      if (message.type === lib_events.IFRAME.BOOTSTRAP) {
        iframe_clearTimeout();
        break;
      }
      if (message.type === lib_events.IFRAME.LOADED) {
        initPromise.resolve();
      }
      if (message.type === lib_events.IFRAME.ERROR) {
        initPromise.reject(message.payload.error);
      }

      // pass UI event up
      eventEmitter.emit(message.event, message);
      eventEmitter.emit(message.type, message.payload);
      break;
    default:
      _log.log('Undefined message', messageEvent.data);
  }
};
const src_init = async (settings = {}) => {
  if (instance) {
    throw errors.TypedError('Init_AlreadyInitialized');
  }
  _settings = parseConnectSettings({
    ..._settings,
    ...settings
  });
  if (!_settings.manifest) {
    throw errors.TypedError('Init_ManifestMissing');
  }

  // defaults for connect-web
  if (!_settings.transports?.length) {
    _settings.transports = ['BridgeTransport', 'WebUsbTransport'];
  }
  if (_settings.lazyLoad) {
    // reset "lazyLoad" after first use
    _settings.lazyLoad = false;
    return;
  }
  if (!_popupManager) {
    _popupManager = initPopupManager();
  }
  _log.enabled = !!_settings.debug;
  window.addEventListener('message', handleMessage);
  window.addEventListener('unload', src_dispose);
  await init(_settings);

  // sharedLogger can be disable but it is enable by default.
  if (_settings.sharedLogger !== false) {
    // connect-web is running in third-party domain so we use iframe to pass logs to shared worker.
    initIframeLogger();
  }
};
const call = async params => {
  if (!instance && !timeout) {
    // init popup with lazy loading before iframe initialization
    _settings = parseConnectSettings(_settings);
    if (!_settings.manifest) {
      return (0,lib_events.createErrorMessage)(errors.TypedError('Init_ManifestMissing'));
    }
    if (!_popupManager) {
      _popupManager = initPopupManager();
    }
    _popupManager.request();

    // auto init with default settings
    try {
      await src_init(_settings);
    } catch (error) {
      if (_popupManager) {
        // Catch fatal iframe errors (not loading)
        if (['Init_IframeBlocked', 'Init_IframeTimeout'].includes(error.code)) {
          _popupManager.postMessage((0,lib_events.createUiMessage)(lib_events.UI.IFRAME_FAILURE));
        } else {
          _popupManager.clear();
        }
      }
      return (0,lib_events.createErrorMessage)(error);
    }
  }
  if (timeout) {
    // this.init was called, but iframe doesn't return handshake yet
    return (0,lib_events.createErrorMessage)(errors.TypedError('Init_ManifestMissing'));
  }
  if (error) {
    // iframe was initialized with error
    return (0,lib_events.createErrorMessage)(error);
  }

  // request popup window it might be used in the future
  if (_settings.popup && _popupManager) {
    _popupManager.request();
  }

  // post message to iframe
  try {
    const {
      promiseId,
      promise
    } = messagePromises.create();
    postMessage({
      id: promiseId,
      type: lib_events.IFRAME.CALL,
      payload: params
    });
    const response = await promise;
    if (response) {
      if (!response.success && response.payload.code !== 'Device_CallInProgress' && _popupManager) {
        _popupManager.unlock();
      }
      return response;
    }
    if (_popupManager) {
      _popupManager.unlock();
    }
    return (0,lib_events.createErrorMessage)(errors.TypedError('Method_NoResponse'));
  } catch (error) {
    _log.error('__call error', error);
    if (_popupManager) {
      _popupManager.clear(false);
    }
    return (0,lib_events.createErrorMessage)(error);
  }
};
const uiResponse = response => {
  if (!instance) {
    throw errors.TypedError('Init_NotInitialized');
  }
  postMessage(response);
};
const renderWebUSBButton = className => {
  webusb_button(className, _settings.webusbSrc);
};
const requestLogin = async params => {
  if (typeof params.callback === 'function') {
    const {
      callback
    } = params;

    // TODO: set message listener only if iframe is loaded correctly
    const loginChallengeListener = async event => {
      const {
        data
      } = event;
      if (data && data.type === lib_events.UI.LOGIN_CHALLENGE_REQUEST) {
        try {
          const payload = await callback();
          postMessage({
            type: lib_events.UI.LOGIN_CHALLENGE_RESPONSE,
            payload
          });
        } catch (error) {
          postMessage({
            type: lib_events.UI.LOGIN_CHALLENGE_RESPONSE,
            payload: error.message
          });
        }
      }
    };
    window.addEventListener('message', loginChallengeListener, false);
    const response = await call({
      method: 'requestLogin',
      ...params,
      asyncChallenge: true,
      callback: null
    });
    window.removeEventListener('message', loginChallengeListener);
    return response;
  }
  return call({
    method: 'requestLogin',
    ...params
  });
};
const disableWebUSB = () => {
  if (!instance) {
    throw errors.TypedError('Init_NotInitialized');
  }
  postMessage({
    type: lib_events.TRANSPORT.DISABLE_WEBUSB
  });
};

/**
 * Initiate device pairing procedure.
 */
const requestWebUSBDevice = async () => {
  try {
    await window.navigator.usb.requestDevice({
      filters: config/* config */.E.webusb
    });
    postMessage({
      type: lib_events.TRANSPORT.REQUEST_DEVICE
    });
  } catch (_err) {
    // user hits cancel gets "DOMException: No device selected."
    // no need to log this
  }
};
const TrezorConnect = (0,factory/* factory */.i)({
  eventEmitter,
  manifest,
  init: src_init,
  call,
  requestLogin,
  uiResponse,
  renderWebUSBButton,
  disableWebUSB,
  requestWebUSBDevice,
  cancel,
  dispose: src_dispose
});
/* harmony default export */ const src = (TrezorConnect);

})();

__webpack_exports__ = __webpack_exports__["default"];
/******/ 	return __webpack_exports__;
/******/ })()
;
});