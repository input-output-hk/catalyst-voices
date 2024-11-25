var __defProp = Object.defineProperty;
var __defNormalProp = (obj, key2, value) => key2 in obj ? __defProp(obj, key2, { enumerable: true, configurable: true, writable: true, value }) : obj[key2] = value;
var __publicField = (obj, key2, value) => __defNormalProp(obj, typeof key2 !== "symbol" ? key2 + "" : key2, value);
import { dn as getAugmentedNamespace, dp as eventsExports, dq as Buffer$1, dr as global, ds as getDefaultExportFromCjs, dt as commonjsRequire$1, du as requireCryptoBrowserify, dv as process$1, dw as commonjsGlobal, dx as BN$9, dy as hash$2, dz as require$$0$4, dA as minimalisticAssert$1, dB as utils$c, dC as inherits_browserExports, dD as hash$3, dE as requireBrorand, dF as hmacDrbg$1, dG as es, dH as DataError, bT as json, bO as Dexie, aF as getObjRef, z as ref, S as reactive, f as computed, K as networkId, bm as dispatchSignal, dI as doSendUpdateWalletConnectList, aW as addSignalListener, dJ as BroadcastMsgType, dK as error, dL as ErrorDB, be as useWalletAccount, dm as getRewardAddressFromCred, a2 as now, dM as cip30_getRewardAddresses, dN as cip30_getChangeAddress, dO as cip30_getForcedUnusedAddresses, dP as cip30_getUnusedAddresses, dQ as cip30_getUsedAddresses, dR as cip30_getNetworkId, dS as cip30_getUtxos, dT as cip30_getPaginate, dU as cip30_getAmount, dV as cip30_getCollateral, dW as cip30_getBalance, dX as cip30_submitTx, dY as prepareData, dZ as prepareTx, aZ as ErrorSignTx, d_ as setApiRequest, cf as getRandomId, d$ as METHOD, D as watch$3, e0 as onAllConnectionsDisconnected, e1 as onWalletConnectSaved, e2 as onWalletConnectAdded, e3 as useQuasarInternal, e4 as getRandomUUID } from "./index.js";
import { n as networkIdList } from "./NetworkId.js";
var cjs$3 = {};
/*! *****************************************************************************
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
var extendStatics$1 = function(d4, b2) {
  extendStatics$1 = Object.setPrototypeOf || { __proto__: [] } instanceof Array && function(d5, b3) {
    d5.__proto__ = b3;
  } || function(d5, b3) {
    for (var p3 in b3) if (b3.hasOwnProperty(p3)) d5[p3] = b3[p3];
  };
  return extendStatics$1(d4, b2);
};
function __extends$1(d4, b2) {
  extendStatics$1(d4, b2);
  function __() {
    this.constructor = d4;
  }
  d4.prototype = b2 === null ? Object.create(b2) : (__.prototype = b2.prototype, new __());
}
var __assign$1 = function() {
  __assign$1 = Object.assign || function __assign2(t) {
    for (var s2, i3 = 1, n4 = arguments.length; i3 < n4; i3++) {
      s2 = arguments[i3];
      for (var p3 in s2) if (Object.prototype.hasOwnProperty.call(s2, p3)) t[p3] = s2[p3];
    }
    return t;
  };
  return __assign$1.apply(this, arguments);
};
function __rest$1(s2, e2) {
  var t = {};
  for (var p3 in s2) if (Object.prototype.hasOwnProperty.call(s2, p3) && e2.indexOf(p3) < 0)
    t[p3] = s2[p3];
  if (s2 != null && typeof Object.getOwnPropertySymbols === "function")
    for (var i3 = 0, p3 = Object.getOwnPropertySymbols(s2); i3 < p3.length; i3++) {
      if (e2.indexOf(p3[i3]) < 0 && Object.prototype.propertyIsEnumerable.call(s2, p3[i3]))
        t[p3[i3]] = s2[p3[i3]];
    }
  return t;
}
function __decorate$1(decorators, target, key2, desc) {
  var c2 = arguments.length, r2 = c2 < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key2) : desc, d4;
  if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r2 = Reflect.decorate(decorators, target, key2, desc);
  else for (var i3 = decorators.length - 1; i3 >= 0; i3--) if (d4 = decorators[i3]) r2 = (c2 < 3 ? d4(r2) : c2 > 3 ? d4(target, key2, r2) : d4(target, key2)) || r2;
  return c2 > 3 && r2 && Object.defineProperty(target, key2, r2), r2;
}
function __param$1(paramIndex, decorator) {
  return function(target, key2) {
    decorator(target, key2, paramIndex);
  };
}
function __metadata$1(metadataKey, metadataValue) {
  if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(metadataKey, metadataValue);
}
function __awaiter$1(thisArg, _arguments, P2, generator) {
  function adopt(value) {
    return value instanceof P2 ? value : new P2(function(resolve) {
      resolve(value);
    });
  }
  return new (P2 || (P2 = Promise))(function(resolve, reject) {
    function fulfilled(value) {
      try {
        step(generator.next(value));
      } catch (e2) {
        reject(e2);
      }
    }
    function rejected(value) {
      try {
        step(generator["throw"](value));
      } catch (e2) {
        reject(e2);
      }
    }
    function step(result) {
      result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected);
    }
    step((generator = generator.apply(thisArg, _arguments || [])).next());
  });
}
function __generator$1(thisArg, body) {
  var _3 = { label: 0, sent: function() {
    if (t[0] & 1) throw t[1];
    return t[1];
  }, trys: [], ops: [] }, f3, y3, t, g3;
  return g3 = { next: verb(0), "throw": verb(1), "return": verb(2) }, typeof Symbol === "function" && (g3[Symbol.iterator] = function() {
    return this;
  }), g3;
  function verb(n4) {
    return function(v3) {
      return step([n4, v3]);
    };
  }
  function step(op) {
    if (f3) throw new TypeError("Generator is already executing.");
    while (_3) try {
      if (f3 = 1, y3 && (t = op[0] & 2 ? y3["return"] : op[0] ? y3["throw"] || ((t = y3["return"]) && t.call(y3), 0) : y3.next) && !(t = t.call(y3, op[1])).done) return t;
      if (y3 = 0, t) op = [op[0] & 2, t.value];
      switch (op[0]) {
        case 0:
        case 1:
          t = op;
          break;
        case 4:
          _3.label++;
          return { value: op[1], done: false };
        case 5:
          _3.label++;
          y3 = op[1];
          op = [0];
          continue;
        case 7:
          op = _3.ops.pop();
          _3.trys.pop();
          continue;
        default:
          if (!(t = _3.trys, t = t.length > 0 && t[t.length - 1]) && (op[0] === 6 || op[0] === 2)) {
            _3 = 0;
            continue;
          }
          if (op[0] === 3 && (!t || op[1] > t[0] && op[1] < t[3])) {
            _3.label = op[1];
            break;
          }
          if (op[0] === 6 && _3.label < t[1]) {
            _3.label = t[1];
            t = op;
            break;
          }
          if (t && _3.label < t[2]) {
            _3.label = t[2];
            _3.ops.push(op);
            break;
          }
          if (t[2]) _3.ops.pop();
          _3.trys.pop();
          continue;
      }
      op = body.call(thisArg, _3);
    } catch (e2) {
      op = [6, e2];
      y3 = 0;
    } finally {
      f3 = t = 0;
    }
    if (op[0] & 5) throw op[1];
    return { value: op[0] ? op[1] : void 0, done: true };
  }
}
function __createBinding$1(o3, m2, k2, k22) {
  if (k22 === void 0) k22 = k2;
  o3[k22] = m2[k2];
}
function __exportStar$1(m2, exports) {
  for (var p3 in m2) if (p3 !== "default" && !exports.hasOwnProperty(p3)) exports[p3] = m2[p3];
}
function __values$1(o3) {
  var s2 = typeof Symbol === "function" && Symbol.iterator, m2 = s2 && o3[s2], i3 = 0;
  if (m2) return m2.call(o3);
  if (o3 && typeof o3.length === "number") return {
    next: function() {
      if (o3 && i3 >= o3.length) o3 = void 0;
      return { value: o3 && o3[i3++], done: !o3 };
    }
  };
  throw new TypeError(s2 ? "Object is not iterable." : "Symbol.iterator is not defined.");
}
function __read$1(o3, n4) {
  var m2 = typeof Symbol === "function" && o3[Symbol.iterator];
  if (!m2) return o3;
  var i3 = m2.call(o3), r2, ar2 = [], e2;
  try {
    while ((n4 === void 0 || n4-- > 0) && !(r2 = i3.next()).done) ar2.push(r2.value);
  } catch (error2) {
    e2 = { error: error2 };
  } finally {
    try {
      if (r2 && !r2.done && (m2 = i3["return"])) m2.call(i3);
    } finally {
      if (e2) throw e2.error;
    }
  }
  return ar2;
}
function __spread$1() {
  for (var ar2 = [], i3 = 0; i3 < arguments.length; i3++)
    ar2 = ar2.concat(__read$1(arguments[i3]));
  return ar2;
}
function __spreadArrays$1() {
  for (var s2 = 0, i3 = 0, il = arguments.length; i3 < il; i3++) s2 += arguments[i3].length;
  for (var r2 = Array(s2), k2 = 0, i3 = 0; i3 < il; i3++)
    for (var a3 = arguments[i3], j2 = 0, jl = a3.length; j2 < jl; j2++, k2++)
      r2[k2] = a3[j2];
  return r2;
}
function __await$1(v3) {
  return this instanceof __await$1 ? (this.v = v3, this) : new __await$1(v3);
}
function __asyncGenerator$1(thisArg, _arguments, generator) {
  if (!Symbol.asyncIterator) throw new TypeError("Symbol.asyncIterator is not defined.");
  var g3 = generator.apply(thisArg, _arguments || []), i3, q2 = [];
  return i3 = {}, verb("next"), verb("throw"), verb("return"), i3[Symbol.asyncIterator] = function() {
    return this;
  }, i3;
  function verb(n4) {
    if (g3[n4]) i3[n4] = function(v3) {
      return new Promise(function(a3, b2) {
        q2.push([n4, v3, a3, b2]) > 1 || resume(n4, v3);
      });
    };
  }
  function resume(n4, v3) {
    try {
      step(g3[n4](v3));
    } catch (e2) {
      settle(q2[0][3], e2);
    }
  }
  function step(r2) {
    r2.value instanceof __await$1 ? Promise.resolve(r2.value.v).then(fulfill, reject) : settle(q2[0][2], r2);
  }
  function fulfill(value) {
    resume("next", value);
  }
  function reject(value) {
    resume("throw", value);
  }
  function settle(f3, v3) {
    if (f3(v3), q2.shift(), q2.length) resume(q2[0][0], q2[0][1]);
  }
}
function __asyncDelegator$1(o3) {
  var i3, p3;
  return i3 = {}, verb("next"), verb("throw", function(e2) {
    throw e2;
  }), verb("return"), i3[Symbol.iterator] = function() {
    return this;
  }, i3;
  function verb(n4, f3) {
    i3[n4] = o3[n4] ? function(v3) {
      return (p3 = !p3) ? { value: __await$1(o3[n4](v3)), done: n4 === "return" } : f3 ? f3(v3) : v3;
    } : f3;
  }
}
function __asyncValues$1(o3) {
  if (!Symbol.asyncIterator) throw new TypeError("Symbol.asyncIterator is not defined.");
  var m2 = o3[Symbol.asyncIterator], i3;
  return m2 ? m2.call(o3) : (o3 = typeof __values$1 === "function" ? __values$1(o3) : o3[Symbol.iterator](), i3 = {}, verb("next"), verb("throw"), verb("return"), i3[Symbol.asyncIterator] = function() {
    return this;
  }, i3);
  function verb(n4) {
    i3[n4] = o3[n4] && function(v3) {
      return new Promise(function(resolve, reject) {
        v3 = o3[n4](v3), settle(resolve, reject, v3.done, v3.value);
      });
    };
  }
  function settle(resolve, reject, d4, v3) {
    Promise.resolve(v3).then(function(v4) {
      resolve({ value: v4, done: d4 });
    }, reject);
  }
}
function __makeTemplateObject$1(cooked, raw) {
  if (Object.defineProperty) {
    Object.defineProperty(cooked, "raw", { value: raw });
  } else {
    cooked.raw = raw;
  }
  return cooked;
}
function __importStar$1(mod) {
  if (mod && mod.__esModule) return mod;
  var result = {};
  if (mod != null) {
    for (var k2 in mod) if (Object.hasOwnProperty.call(mod, k2)) result[k2] = mod[k2];
  }
  result.default = mod;
  return result;
}
function __importDefault$1(mod) {
  return mod && mod.__esModule ? mod : { default: mod };
}
function __classPrivateFieldGet$1(receiver, privateMap) {
  if (!privateMap.has(receiver)) {
    throw new TypeError("attempted to get private field on non-instance");
  }
  return privateMap.get(receiver);
}
function __classPrivateFieldSet$1(receiver, privateMap, value) {
  if (!privateMap.has(receiver)) {
    throw new TypeError("attempted to set private field on non-instance");
  }
  privateMap.set(receiver, value);
  return value;
}
const tslib_es6$1 = /* @__PURE__ */ Object.freeze(/* @__PURE__ */ Object.defineProperty({
  __proto__: null,
  get __assign() {
    return __assign$1;
  },
  __asyncDelegator: __asyncDelegator$1,
  __asyncGenerator: __asyncGenerator$1,
  __asyncValues: __asyncValues$1,
  __await: __await$1,
  __awaiter: __awaiter$1,
  __classPrivateFieldGet: __classPrivateFieldGet$1,
  __classPrivateFieldSet: __classPrivateFieldSet$1,
  __createBinding: __createBinding$1,
  __decorate: __decorate$1,
  __exportStar: __exportStar$1,
  __extends: __extends$1,
  __generator: __generator$1,
  __importDefault: __importDefault$1,
  __importStar: __importStar$1,
  __makeTemplateObject: __makeTemplateObject$1,
  __metadata: __metadata$1,
  __param: __param$1,
  __read: __read$1,
  __rest: __rest$1,
  __spread: __spread$1,
  __spreadArrays: __spreadArrays$1,
  __values: __values$1
}, Symbol.toStringTag, { value: "Module" }));
const require$$0$3 = /* @__PURE__ */ getAugmentedNamespace(tslib_es6$1);
var utils$b = {};
var delay = {};
var hasRequiredDelay;
function requireDelay() {
  if (hasRequiredDelay) return delay;
  hasRequiredDelay = 1;
  Object.defineProperty(delay, "__esModule", { value: true });
  delay.delay = void 0;
  function delay$1(timeout) {
    return new Promise((resolve) => {
      setTimeout(() => {
        resolve(true);
      }, timeout);
    });
  }
  delay.delay = delay$1;
  return delay;
}
var convert = {};
var constants = {};
var misc = {};
var hasRequiredMisc;
function requireMisc() {
  if (hasRequiredMisc) return misc;
  hasRequiredMisc = 1;
  Object.defineProperty(misc, "__esModule", { value: true });
  misc.ONE_THOUSAND = misc.ONE_HUNDRED = void 0;
  misc.ONE_HUNDRED = 100;
  misc.ONE_THOUSAND = 1e3;
  return misc;
}
var time = {};
var hasRequiredTime;
function requireTime() {
  if (hasRequiredTime) return time;
  hasRequiredTime = 1;
  (function(exports) {
    Object.defineProperty(exports, "__esModule", { value: true });
    exports.ONE_YEAR = exports.FOUR_WEEKS = exports.THREE_WEEKS = exports.TWO_WEEKS = exports.ONE_WEEK = exports.THIRTY_DAYS = exports.SEVEN_DAYS = exports.FIVE_DAYS = exports.THREE_DAYS = exports.ONE_DAY = exports.TWENTY_FOUR_HOURS = exports.TWELVE_HOURS = exports.SIX_HOURS = exports.THREE_HOURS = exports.ONE_HOUR = exports.SIXTY_MINUTES = exports.THIRTY_MINUTES = exports.TEN_MINUTES = exports.FIVE_MINUTES = exports.ONE_MINUTE = exports.SIXTY_SECONDS = exports.THIRTY_SECONDS = exports.TEN_SECONDS = exports.FIVE_SECONDS = exports.ONE_SECOND = void 0;
    exports.ONE_SECOND = 1;
    exports.FIVE_SECONDS = 5;
    exports.TEN_SECONDS = 10;
    exports.THIRTY_SECONDS = 30;
    exports.SIXTY_SECONDS = 60;
    exports.ONE_MINUTE = exports.SIXTY_SECONDS;
    exports.FIVE_MINUTES = exports.ONE_MINUTE * 5;
    exports.TEN_MINUTES = exports.ONE_MINUTE * 10;
    exports.THIRTY_MINUTES = exports.ONE_MINUTE * 30;
    exports.SIXTY_MINUTES = exports.ONE_MINUTE * 60;
    exports.ONE_HOUR = exports.SIXTY_MINUTES;
    exports.THREE_HOURS = exports.ONE_HOUR * 3;
    exports.SIX_HOURS = exports.ONE_HOUR * 6;
    exports.TWELVE_HOURS = exports.ONE_HOUR * 12;
    exports.TWENTY_FOUR_HOURS = exports.ONE_HOUR * 24;
    exports.ONE_DAY = exports.TWENTY_FOUR_HOURS;
    exports.THREE_DAYS = exports.ONE_DAY * 3;
    exports.FIVE_DAYS = exports.ONE_DAY * 5;
    exports.SEVEN_DAYS = exports.ONE_DAY * 7;
    exports.THIRTY_DAYS = exports.ONE_DAY * 30;
    exports.ONE_WEEK = exports.SEVEN_DAYS;
    exports.TWO_WEEKS = exports.ONE_WEEK * 2;
    exports.THREE_WEEKS = exports.ONE_WEEK * 3;
    exports.FOUR_WEEKS = exports.ONE_WEEK * 4;
    exports.ONE_YEAR = exports.ONE_DAY * 365;
  })(time);
  return time;
}
var hasRequiredConstants;
function requireConstants() {
  if (hasRequiredConstants) return constants;
  hasRequiredConstants = 1;
  (function(exports) {
    Object.defineProperty(exports, "__esModule", { value: true });
    const tslib_1 = require$$0$3;
    tslib_1.__exportStar(requireMisc(), exports);
    tslib_1.__exportStar(requireTime(), exports);
  })(constants);
  return constants;
}
var hasRequiredConvert;
function requireConvert() {
  if (hasRequiredConvert) return convert;
  hasRequiredConvert = 1;
  Object.defineProperty(convert, "__esModule", { value: true });
  convert.fromMiliseconds = convert.toMiliseconds = void 0;
  const constants_1 = requireConstants();
  function toMiliseconds(seconds) {
    return seconds * constants_1.ONE_THOUSAND;
  }
  convert.toMiliseconds = toMiliseconds;
  function fromMiliseconds(miliseconds) {
    return Math.floor(miliseconds / constants_1.ONE_THOUSAND);
  }
  convert.fromMiliseconds = fromMiliseconds;
  return convert;
}
var hasRequiredUtils;
function requireUtils() {
  if (hasRequiredUtils) return utils$b;
  hasRequiredUtils = 1;
  (function(exports) {
    Object.defineProperty(exports, "__esModule", { value: true });
    const tslib_1 = require$$0$3;
    tslib_1.__exportStar(requireDelay(), exports);
    tslib_1.__exportStar(requireConvert(), exports);
  })(utils$b);
  return utils$b;
}
var watch$2 = {};
var hasRequiredWatch$1;
function requireWatch$1() {
  if (hasRequiredWatch$1) return watch$2;
  hasRequiredWatch$1 = 1;
  Object.defineProperty(watch$2, "__esModule", { value: true });
  watch$2.Watch = void 0;
  class Watch {
    constructor() {
      this.timestamps = /* @__PURE__ */ new Map();
    }
    start(label) {
      if (this.timestamps.has(label)) {
        throw new Error(`Watch already started for label: ${label}`);
      }
      this.timestamps.set(label, { started: Date.now() });
    }
    stop(label) {
      const timestamp = this.get(label);
      if (typeof timestamp.elapsed !== "undefined") {
        throw new Error(`Watch already stopped for label: ${label}`);
      }
      const elapsed = Date.now() - timestamp.started;
      this.timestamps.set(label, { started: timestamp.started, elapsed });
    }
    get(label) {
      const timestamp = this.timestamps.get(label);
      if (typeof timestamp === "undefined") {
        throw new Error(`No timestamp found for label: ${label}`);
      }
      return timestamp;
    }
    elapsed(label) {
      const timestamp = this.get(label);
      const elapsed = timestamp.elapsed || Date.now() - timestamp.started;
      return elapsed;
    }
  }
  watch$2.Watch = Watch;
  watch$2.default = Watch;
  return watch$2;
}
var types = {};
var watch$1 = {};
var hasRequiredWatch;
function requireWatch() {
  if (hasRequiredWatch) return watch$1;
  hasRequiredWatch = 1;
  Object.defineProperty(watch$1, "__esModule", { value: true });
  watch$1.IWatch = void 0;
  class IWatch {
  }
  watch$1.IWatch = IWatch;
  return watch$1;
}
var hasRequiredTypes;
function requireTypes() {
  if (hasRequiredTypes) return types;
  hasRequiredTypes = 1;
  (function(exports) {
    Object.defineProperty(exports, "__esModule", { value: true });
    const tslib_1 = require$$0$3;
    tslib_1.__exportStar(requireWatch(), exports);
  })(types);
  return types;
}
(function(exports) {
  Object.defineProperty(exports, "__esModule", { value: true });
  const tslib_1 = require$$0$3;
  tslib_1.__exportStar(requireUtils(), exports);
  tslib_1.__exportStar(requireWatch$1(), exports);
  tslib_1.__exportStar(requireTypes(), exports);
  tslib_1.__exportStar(requireConstants(), exports);
})(cjs$3);
class IEvents {
}
let n$3 = class n extends IEvents {
  constructor(e2) {
    super();
  }
};
const s = cjs$3.FIVE_SECONDS, r$1 = { pulse: "heartbeat_pulse" };
let i$1 = class i extends n$3 {
  constructor(e2) {
    super(e2), this.events = new eventsExports.EventEmitter(), this.interval = s, this.interval = (e2 == null ? void 0 : e2.interval) || s;
  }
  static async init(e2) {
    const t = new i(e2);
    return await t.init(), t;
  }
  async init() {
    await this.initialize();
  }
  stop() {
    clearInterval(this.intervalRef);
  }
  on(e2, t) {
    this.events.on(e2, t);
  }
  once(e2, t) {
    this.events.once(e2, t);
  }
  off(e2, t) {
    this.events.off(e2, t);
  }
  removeListener(e2, t) {
    this.events.removeListener(e2, t);
  }
  async initialize() {
    this.intervalRef = setInterval(() => this.pulse(), cjs$3.toMiliseconds(this.interval));
  }
  pulse() {
    this.events.emit(r$1.pulse);
  }
};
const suspectProtoRx = /"(?:_|\\u0{2}5[Ff]){2}(?:p|\\u0{2}70)(?:r|\\u0{2}72)(?:o|\\u0{2}6[Ff])(?:t|\\u0{2}74)(?:o|\\u0{2}6[Ff])(?:_|\\u0{2}5[Ff]){2}"\s*:/;
const suspectConstructorRx = /"(?:c|\\u0063)(?:o|\\u006[Ff])(?:n|\\u006[Ee])(?:s|\\u0073)(?:t|\\u0074)(?:r|\\u0072)(?:u|\\u0075)(?:c|\\u0063)(?:t|\\u0074)(?:o|\\u006[Ff])(?:r|\\u0072)"\s*:/;
const JsonSigRx = /^\s*["[{]|^\s*-?\d{1,16}(\.\d{1,17})?([Ee][+-]?\d+)?\s*$/;
function jsonParseTransform(key2, value) {
  if (key2 === "__proto__" || key2 === "constructor" && value && typeof value === "object" && "prototype" in value) {
    warnKeyDropped(key2);
    return;
  }
  return value;
}
function warnKeyDropped(key2) {
  console.warn(`[destr] Dropping "${key2}" key to prevent prototype pollution.`);
}
function destr(value, options = {}) {
  if (typeof value !== "string") {
    return value;
  }
  const _value = value.trim();
  if (
    // eslint-disable-next-line unicorn/prefer-at
    value[0] === '"' && value.endsWith('"') && !value.includes("\\")
  ) {
    return _value.slice(1, -1);
  }
  if (_value.length <= 9) {
    const _lval = _value.toLowerCase();
    if (_lval === "true") {
      return true;
    }
    if (_lval === "false") {
      return false;
    }
    if (_lval === "undefined") {
      return void 0;
    }
    if (_lval === "null") {
      return null;
    }
    if (_lval === "nan") {
      return Number.NaN;
    }
    if (_lval === "infinity") {
      return Number.POSITIVE_INFINITY;
    }
    if (_lval === "-infinity") {
      return Number.NEGATIVE_INFINITY;
    }
  }
  if (!JsonSigRx.test(value)) {
    if (options.strict) {
      throw new SyntaxError("[destr] Invalid JSON");
    }
    return value;
  }
  try {
    if (suspectProtoRx.test(value) || suspectConstructorRx.test(value)) {
      if (options.strict) {
        throw new Error("[destr] Possible prototype pollution");
      }
      return JSON.parse(value, jsonParseTransform);
    }
    return JSON.parse(value);
  } catch (error2) {
    if (options.strict) {
      throw error2;
    }
    return value;
  }
}
function wrapToPromise(value) {
  if (!value || typeof value.then !== "function") {
    return Promise.resolve(value);
  }
  return value;
}
function asyncCall(function_, ...arguments_) {
  try {
    return wrapToPromise(function_(...arguments_));
  } catch (error2) {
    return Promise.reject(error2);
  }
}
function isPrimitive(value) {
  const type = typeof value;
  return value === null || type !== "object" && type !== "function";
}
function isPureObject(value) {
  const proto = Object.getPrototypeOf(value);
  return !proto || proto.isPrototypeOf(Object);
}
function stringify(value) {
  if (isPrimitive(value)) {
    return String(value);
  }
  if (isPureObject(value) || Array.isArray(value)) {
    return JSON.stringify(value);
  }
  if (typeof value.toJSON === "function") {
    return stringify(value.toJSON());
  }
  throw new Error("[unstorage] Cannot stringify value!");
}
function checkBufferSupport() {
  if (typeof Buffer$1 === "undefined") {
    throw new TypeError("[unstorage] Buffer is not supported!");
  }
}
const BASE64_PREFIX = "base64:";
function serializeRaw(value) {
  if (typeof value === "string") {
    return value;
  }
  checkBufferSupport();
  const base642 = Buffer$1.from(value).toString("base64");
  return BASE64_PREFIX + base642;
}
function deserializeRaw(value) {
  if (typeof value !== "string") {
    return value;
  }
  if (!value.startsWith(BASE64_PREFIX)) {
    return value;
  }
  checkBufferSupport();
  return Buffer$1.from(value.slice(BASE64_PREFIX.length), "base64");
}
function normalizeKey(key2) {
  if (!key2) {
    return "";
  }
  return key2.split("?")[0].replace(/[/\\]/g, ":").replace(/:+/g, ":").replace(/^:|:$/g, "");
}
function joinKeys(...keys2) {
  return normalizeKey(keys2.join(":"));
}
function normalizeBaseKey(base3) {
  base3 = normalizeKey(base3);
  return base3 ? base3 + ":" : "";
}
function defineDriver(factory) {
  return factory;
}
const DRIVER_NAME = "memory";
const memory = defineDriver(() => {
  const data = /* @__PURE__ */ new Map();
  return {
    name: DRIVER_NAME,
    getInstance: () => data,
    hasItem(key2) {
      return data.has(key2);
    },
    getItem(key2) {
      return data.get(key2) ?? null;
    },
    getItemRaw(key2) {
      return data.get(key2) ?? null;
    },
    setItem(key2, value) {
      data.set(key2, value);
    },
    setItemRaw(key2, value) {
      data.set(key2, value);
    },
    removeItem(key2) {
      data.delete(key2);
    },
    getKeys() {
      return [...data.keys()];
    },
    clear() {
      data.clear();
    },
    dispose() {
      data.clear();
    }
  };
});
function createStorage(options = {}) {
  const context = {
    mounts: { "": options.driver || memory() },
    mountpoints: [""],
    watching: false,
    watchListeners: [],
    unwatch: {}
  };
  const getMount = (key2) => {
    for (const base3 of context.mountpoints) {
      if (key2.startsWith(base3)) {
        return {
          base: base3,
          relativeKey: key2.slice(base3.length),
          driver: context.mounts[base3]
        };
      }
    }
    return {
      base: "",
      relativeKey: key2,
      driver: context.mounts[""]
    };
  };
  const getMounts = (base3, includeParent) => {
    return context.mountpoints.filter(
      (mountpoint) => mountpoint.startsWith(base3) || includeParent && base3.startsWith(mountpoint)
    ).map((mountpoint) => ({
      relativeBase: base3.length > mountpoint.length ? base3.slice(mountpoint.length) : void 0,
      mountpoint,
      driver: context.mounts[mountpoint]
    }));
  };
  const onChange = (event, key2) => {
    if (!context.watching) {
      return;
    }
    key2 = normalizeKey(key2);
    for (const listener of context.watchListeners) {
      listener(event, key2);
    }
  };
  const startWatch = async () => {
    if (context.watching) {
      return;
    }
    context.watching = true;
    for (const mountpoint in context.mounts) {
      context.unwatch[mountpoint] = await watch(
        context.mounts[mountpoint],
        onChange,
        mountpoint
      );
    }
  };
  const stopWatch = async () => {
    if (!context.watching) {
      return;
    }
    for (const mountpoint in context.unwatch) {
      await context.unwatch[mountpoint]();
    }
    context.unwatch = {};
    context.watching = false;
  };
  const runBatch = (items, commonOptions, cb) => {
    const batches = /* @__PURE__ */ new Map();
    const getBatch = (mount) => {
      let batch = batches.get(mount.base);
      if (!batch) {
        batch = {
          driver: mount.driver,
          base: mount.base,
          items: []
        };
        batches.set(mount.base, batch);
      }
      return batch;
    };
    for (const item of items) {
      const isStringItem = typeof item === "string";
      const key2 = normalizeKey(isStringItem ? item : item.key);
      const value = isStringItem ? void 0 : item.value;
      const options2 = isStringItem || !item.options ? commonOptions : { ...commonOptions, ...item.options };
      const mount = getMount(key2);
      getBatch(mount).items.push({
        key: key2,
        value,
        relativeKey: mount.relativeKey,
        options: options2
      });
    }
    return Promise.all([...batches.values()].map((batch) => cb(batch))).then(
      (r2) => r2.flat()
    );
  };
  const storage = {
    // Item
    hasItem(key2, opts = {}) {
      key2 = normalizeKey(key2);
      const { relativeKey, driver } = getMount(key2);
      return asyncCall(driver.hasItem, relativeKey, opts);
    },
    getItem(key2, opts = {}) {
      key2 = normalizeKey(key2);
      const { relativeKey, driver } = getMount(key2);
      return asyncCall(driver.getItem, relativeKey, opts).then(
        (value) => destr(value)
      );
    },
    getItems(items, commonOptions) {
      return runBatch(items, commonOptions, (batch) => {
        if (batch.driver.getItems) {
          return asyncCall(
            batch.driver.getItems,
            batch.items.map((item) => ({
              key: item.relativeKey,
              options: item.options
            })),
            commonOptions
          ).then(
            (r2) => r2.map((item) => ({
              key: joinKeys(batch.base, item.key),
              value: destr(item.value)
            }))
          );
        }
        return Promise.all(
          batch.items.map((item) => {
            return asyncCall(
              batch.driver.getItem,
              item.relativeKey,
              item.options
            ).then((value) => ({
              key: item.key,
              value: destr(value)
            }));
          })
        );
      });
    },
    getItemRaw(key2, opts = {}) {
      key2 = normalizeKey(key2);
      const { relativeKey, driver } = getMount(key2);
      if (driver.getItemRaw) {
        return asyncCall(driver.getItemRaw, relativeKey, opts);
      }
      return asyncCall(driver.getItem, relativeKey, opts).then(
        (value) => deserializeRaw(value)
      );
    },
    async setItem(key2, value, opts = {}) {
      if (value === void 0) {
        return storage.removeItem(key2);
      }
      key2 = normalizeKey(key2);
      const { relativeKey, driver } = getMount(key2);
      if (!driver.setItem) {
        return;
      }
      await asyncCall(driver.setItem, relativeKey, stringify(value), opts);
      if (!driver.watch) {
        onChange("update", key2);
      }
    },
    async setItems(items, commonOptions) {
      await runBatch(items, commonOptions, async (batch) => {
        if (batch.driver.setItems) {
          return asyncCall(
            batch.driver.setItems,
            batch.items.map((item) => ({
              key: item.relativeKey,
              value: stringify(item.value),
              options: item.options
            })),
            commonOptions
          );
        }
        if (!batch.driver.setItem) {
          return;
        }
        await Promise.all(
          batch.items.map((item) => {
            return asyncCall(
              batch.driver.setItem,
              item.relativeKey,
              stringify(item.value),
              item.options
            );
          })
        );
      });
    },
    async setItemRaw(key2, value, opts = {}) {
      if (value === void 0) {
        return storage.removeItem(key2, opts);
      }
      key2 = normalizeKey(key2);
      const { relativeKey, driver } = getMount(key2);
      if (driver.setItemRaw) {
        await asyncCall(driver.setItemRaw, relativeKey, value, opts);
      } else if (driver.setItem) {
        await asyncCall(driver.setItem, relativeKey, serializeRaw(value), opts);
      } else {
        return;
      }
      if (!driver.watch) {
        onChange("update", key2);
      }
    },
    async removeItem(key2, opts = {}) {
      if (typeof opts === "boolean") {
        opts = { removeMeta: opts };
      }
      key2 = normalizeKey(key2);
      const { relativeKey, driver } = getMount(key2);
      if (!driver.removeItem) {
        return;
      }
      await asyncCall(driver.removeItem, relativeKey, opts);
      if (opts.removeMeta || opts.removeMata) {
        await asyncCall(driver.removeItem, relativeKey + "$", opts);
      }
      if (!driver.watch) {
        onChange("remove", key2);
      }
    },
    // Meta
    async getMeta(key2, opts = {}) {
      if (typeof opts === "boolean") {
        opts = { nativeOnly: opts };
      }
      key2 = normalizeKey(key2);
      const { relativeKey, driver } = getMount(key2);
      const meta = /* @__PURE__ */ Object.create(null);
      if (driver.getMeta) {
        Object.assign(meta, await asyncCall(driver.getMeta, relativeKey, opts));
      }
      if (!opts.nativeOnly) {
        const value = await asyncCall(
          driver.getItem,
          relativeKey + "$",
          opts
        ).then((value_) => destr(value_));
        if (value && typeof value === "object") {
          if (typeof value.atime === "string") {
            value.atime = new Date(value.atime);
          }
          if (typeof value.mtime === "string") {
            value.mtime = new Date(value.mtime);
          }
          Object.assign(meta, value);
        }
      }
      return meta;
    },
    setMeta(key2, value, opts = {}) {
      return this.setItem(key2 + "$", value, opts);
    },
    removeMeta(key2, opts = {}) {
      return this.removeItem(key2 + "$", opts);
    },
    // Keys
    async getKeys(base3, opts = {}) {
      base3 = normalizeBaseKey(base3);
      const mounts = getMounts(base3, true);
      let maskedMounts = [];
      const allKeys = [];
      for (const mount of mounts) {
        const rawKeys = await asyncCall(
          mount.driver.getKeys,
          mount.relativeBase,
          opts
        );
        for (const key2 of rawKeys) {
          const fullKey = mount.mountpoint + normalizeKey(key2);
          if (!maskedMounts.some((p3) => fullKey.startsWith(p3))) {
            allKeys.push(fullKey);
          }
        }
        maskedMounts = [
          mount.mountpoint,
          ...maskedMounts.filter((p3) => !p3.startsWith(mount.mountpoint))
        ];
      }
      return base3 ? allKeys.filter(
        (key2) => key2.startsWith(base3) && key2[key2.length - 1] !== "$"
      ) : allKeys.filter((key2) => key2[key2.length - 1] !== "$");
    },
    // Utils
    async clear(base3, opts = {}) {
      base3 = normalizeBaseKey(base3);
      await Promise.all(
        getMounts(base3, false).map(async (m2) => {
          if (m2.driver.clear) {
            return asyncCall(m2.driver.clear, m2.relativeBase, opts);
          }
          if (m2.driver.removeItem) {
            const keys2 = await m2.driver.getKeys(m2.relativeBase || "", opts);
            return Promise.all(
              keys2.map((key2) => m2.driver.removeItem(key2, opts))
            );
          }
        })
      );
    },
    async dispose() {
      await Promise.all(
        Object.values(context.mounts).map((driver) => dispose(driver))
      );
    },
    async watch(callback) {
      await startWatch();
      context.watchListeners.push(callback);
      return async () => {
        context.watchListeners = context.watchListeners.filter(
          (listener) => listener !== callback
        );
        if (context.watchListeners.length === 0) {
          await stopWatch();
        }
      };
    },
    async unwatch() {
      context.watchListeners = [];
      await stopWatch();
    },
    // Mount
    mount(base3, driver) {
      base3 = normalizeBaseKey(base3);
      if (base3 && context.mounts[base3]) {
        throw new Error(`already mounted at ${base3}`);
      }
      if (base3) {
        context.mountpoints.push(base3);
        context.mountpoints.sort((a3, b2) => b2.length - a3.length);
      }
      context.mounts[base3] = driver;
      if (context.watching) {
        Promise.resolve(watch(driver, onChange, base3)).then((unwatcher) => {
          context.unwatch[base3] = unwatcher;
        }).catch(console.error);
      }
      return storage;
    },
    async unmount(base3, _dispose = true) {
      base3 = normalizeBaseKey(base3);
      if (!base3 || !context.mounts[base3]) {
        return;
      }
      if (context.watching && base3 in context.unwatch) {
        context.unwatch[base3]();
        delete context.unwatch[base3];
      }
      if (_dispose) {
        await dispose(context.mounts[base3]);
      }
      context.mountpoints = context.mountpoints.filter((key2) => key2 !== base3);
      delete context.mounts[base3];
    },
    getMount(key2 = "") {
      key2 = normalizeKey(key2) + ":";
      const m2 = getMount(key2);
      return {
        driver: m2.driver,
        base: m2.base
      };
    },
    getMounts(base3 = "", opts = {}) {
      base3 = normalizeKey(base3);
      const mounts = getMounts(base3, opts.parents);
      return mounts.map((m2) => ({
        driver: m2.driver,
        base: m2.mountpoint
      }));
    },
    // Aliases
    keys: (base3, opts = {}) => storage.getKeys(base3, opts),
    get: (key2, opts = {}) => storage.getItem(key2, opts),
    set: (key2, value, opts = {}) => storage.setItem(key2, value, opts),
    has: (key2, opts = {}) => storage.hasItem(key2, opts),
    del: (key2, opts = {}) => storage.removeItem(key2, opts),
    remove: (key2, opts = {}) => storage.removeItem(key2, opts)
  };
  return storage;
}
function watch(driver, onChange, base3) {
  return driver.watch ? driver.watch((event, key2) => onChange(event, base3 + key2)) : () => {
  };
}
async function dispose(driver) {
  if (typeof driver.dispose === "function") {
    await asyncCall(driver.dispose);
  }
}
function promisifyRequest(request) {
  return new Promise((resolve, reject) => {
    request.oncomplete = request.onsuccess = () => resolve(request.result);
    request.onabort = request.onerror = () => reject(request.error);
  });
}
function createStore(dbName, storeName) {
  const request = indexedDB.open(dbName);
  request.onupgradeneeded = () => request.result.createObjectStore(storeName);
  const dbp = promisifyRequest(request);
  return (txMode, callback) => dbp.then((db) => callback(db.transaction(storeName, txMode).objectStore(storeName)));
}
let defaultGetStoreFunc;
function defaultGetStore() {
  if (!defaultGetStoreFunc) {
    defaultGetStoreFunc = createStore("keyval-store", "keyval");
  }
  return defaultGetStoreFunc;
}
function get(key2, customStore = defaultGetStore()) {
  return customStore("readonly", (store) => promisifyRequest(store.get(key2)));
}
function set$1(key2, value, customStore = defaultGetStore()) {
  return customStore("readwrite", (store) => {
    store.put(value, key2);
    return promisifyRequest(store.transaction);
  });
}
function del(key2, customStore = defaultGetStore()) {
  return customStore("readwrite", (store) => {
    store.delete(key2);
    return promisifyRequest(store.transaction);
  });
}
function clear(customStore = defaultGetStore()) {
  return customStore("readwrite", (store) => {
    store.clear();
    return promisifyRequest(store.transaction);
  });
}
function eachCursor(store, callback) {
  store.openCursor().onsuccess = function() {
    if (!this.result)
      return;
    callback(this.result);
    this.result.continue();
  };
  return promisifyRequest(store.transaction);
}
function keys(customStore = defaultGetStore()) {
  return customStore("readonly", (store) => {
    if (store.getAllKeys) {
      return promisifyRequest(store.getAllKeys());
    }
    const items = [];
    return eachCursor(store, (cursor) => items.push(cursor.key)).then(() => items);
  });
}
const JSONStringify = (data) => JSON.stringify(data, (_3, value) => typeof value === "bigint" ? value.toString() + "n" : value);
const JSONParse = (json2) => {
  const numbersBiggerThanMaxInt = /([\[:])?(\d{17,}|(?:[9](?:[1-9]07199254740991|0[1-9]7199254740991|00[8-9]199254740991|007[2-9]99254740991|007199[3-9]54740991|0071992[6-9]4740991|00719925[5-9]740991|007199254[8-9]40991|0071992547[5-9]0991|00719925474[1-9]991|00719925474099[2-9])))([,\}\]])/g;
  const serializedData = json2.replace(numbersBiggerThanMaxInt, '$1"$2n"$3');
  return JSON.parse(serializedData, (_3, value) => {
    const isCustomFormatBigInt = typeof value === "string" && value.match(/^\d+n$/);
    if (isCustomFormatBigInt)
      return BigInt(value.substring(0, value.length - 1));
    return value;
  });
};
function safeJsonParse(value) {
  if (typeof value !== "string") {
    throw new Error(`Cannot safe json parse value of type ${typeof value}`);
  }
  try {
    return JSONParse(value);
  } catch (_a) {
    return value;
  }
}
function safeJsonStringify(value) {
  return typeof value === "string" ? value : JSONStringify(value) || "";
}
const x$6 = "idb-keyval";
var z$6 = (i3 = {}) => {
  const t = i3.base && i3.base.length > 0 ? `${i3.base}:` : "", e2 = (s2) => t + s2;
  let n4;
  return i3.dbName && i3.storeName && (n4 = createStore(i3.dbName, i3.storeName)), { name: x$6, options: i3, async hasItem(s2) {
    return !(typeof await get(e2(s2), n4) > "u");
  }, async getItem(s2) {
    return await get(e2(s2), n4) ?? null;
  }, setItem(s2, a3) {
    return set$1(e2(s2), a3, n4);
  }, removeItem(s2) {
    return del(e2(s2), n4);
  }, getKeys() {
    return keys(n4);
  }, clear() {
    return clear(n4);
  } };
};
const D$3 = "WALLET_CONNECT_V2_INDEXED_DB", E$2 = "keyvaluestorage";
let _$3 = class _ {
  constructor() {
    this.indexedDb = createStorage({ driver: z$6({ dbName: D$3, storeName: E$2 }) });
  }
  async getKeys() {
    return this.indexedDb.getKeys();
  }
  async getEntries() {
    return (await this.indexedDb.getItems(await this.indexedDb.getKeys())).map((t) => [t.key, t.value]);
  }
  async getItem(t) {
    const e2 = await this.indexedDb.getItem(t);
    if (e2 !== null) return e2;
  }
  async setItem(t, e2) {
    await this.indexedDb.setItem(t, safeJsonStringify(e2));
  }
  async removeItem(t) {
    await this.indexedDb.removeItem(t);
  }
};
var l$2 = typeof globalThis < "u" ? globalThis : typeof window < "u" ? window : typeof global < "u" ? global : typeof self < "u" ? self : {}, c$2 = { exports: {} };
(function() {
  let i3;
  function t() {
  }
  i3 = t, i3.prototype.getItem = function(e2) {
    return this.hasOwnProperty(e2) ? String(this[e2]) : null;
  }, i3.prototype.setItem = function(e2, n4) {
    this[e2] = String(n4);
  }, i3.prototype.removeItem = function(e2) {
    delete this[e2];
  }, i3.prototype.clear = function() {
    const e2 = this;
    Object.keys(e2).forEach(function(n4) {
      e2[n4] = void 0, delete e2[n4];
    });
  }, i3.prototype.key = function(e2) {
    return e2 = e2 || 0, Object.keys(this)[e2];
  }, i3.prototype.__defineGetter__("length", function() {
    return Object.keys(this).length;
  }), typeof l$2 < "u" && l$2.localStorage ? c$2.exports = l$2.localStorage : typeof window < "u" && window.localStorage ? c$2.exports = window.localStorage : c$2.exports = new t();
})();
function k$3(i3) {
  var t;
  return [i3[0], safeJsonParse((t = i3[1]) != null ? t : "")];
}
let K$3 = class K {
  constructor() {
    this.localStorage = c$2.exports;
  }
  async getKeys() {
    return Object.keys(this.localStorage);
  }
  async getEntries() {
    return Object.entries(this.localStorage).map(k$3);
  }
  async getItem(t) {
    const e2 = this.localStorage.getItem(t);
    if (e2 !== null) return safeJsonParse(e2);
  }
  async setItem(t, e2) {
    this.localStorage.setItem(t, safeJsonStringify(e2));
  }
  async removeItem(t) {
    this.localStorage.removeItem(t);
  }
};
const N$1 = "wc_storage_version", y$4 = 1, O$5 = async (i3, t, e2) => {
  const n4 = N$1, s2 = await t.getItem(n4);
  if (s2 && s2 >= y$4) {
    e2(t);
    return;
  }
  const a3 = await i3.getKeys();
  if (!a3.length) {
    e2(t);
    return;
  }
  const m2 = [];
  for (; a3.length; ) {
    const r2 = a3.shift();
    if (!r2) continue;
    const o3 = r2.toLowerCase();
    if (o3.includes("wc@") || o3.includes("walletconnect") || o3.includes("wc_") || o3.includes("wallet_connect")) {
      const f3 = await i3.getItem(r2);
      await t.setItem(r2, f3), m2.push(r2);
    }
  }
  await t.setItem(n4, y$4), e2(t), j$2(i3, m2);
}, j$2 = async (i3, t) => {
  t.length && t.forEach(async (e2) => {
    await i3.removeItem(e2);
  });
};
let h$2 = class h {
  constructor() {
    this.initialized = false, this.setInitialized = (e2) => {
      this.storage = e2, this.initialized = true;
    };
    const t = new K$3();
    this.storage = t;
    try {
      const e2 = new _$3();
      O$5(t, e2, this.setInitialized);
    } catch {
      this.initialized = true;
    }
  }
  async getKeys() {
    return await this.initialize(), this.storage.getKeys();
  }
  async getEntries() {
    return await this.initialize(), this.storage.getEntries();
  }
  async getItem(t) {
    return await this.initialize(), this.storage.getItem(t);
  }
  async setItem(t, e2) {
    return await this.initialize(), this.storage.setItem(t, e2);
  }
  async removeItem(t) {
    return await this.initialize(), this.storage.removeItem(t);
  }
  async initialize() {
    this.initialized || await new Promise((t) => {
      const e2 = setInterval(() => {
        this.initialized && (clearInterval(e2), t());
      }, 20);
    });
  }
};
function tryStringify(o3) {
  try {
    return JSON.stringify(o3);
  } catch (e2) {
    return '"[Circular]"';
  }
}
var quickFormatUnescaped = format$1;
function format$1(f3, args, opts) {
  var ss = opts && opts.stringify || tryStringify;
  var offset = 1;
  if (typeof f3 === "object" && f3 !== null) {
    var len = args.length + offset;
    if (len === 1) return f3;
    var objects = new Array(len);
    objects[0] = ss(f3);
    for (var index = 1; index < len; index++) {
      objects[index] = ss(args[index]);
    }
    return objects.join(" ");
  }
  if (typeof f3 !== "string") {
    return f3;
  }
  var argLen = args.length;
  if (argLen === 0) return f3;
  var str = "";
  var a3 = 1 - offset;
  var lastPos = -1;
  var flen = f3 && f3.length || 0;
  for (var i3 = 0; i3 < flen; ) {
    if (f3.charCodeAt(i3) === 37 && i3 + 1 < flen) {
      lastPos = lastPos > -1 ? lastPos : 0;
      switch (f3.charCodeAt(i3 + 1)) {
        case 100:
        case 102:
          if (a3 >= argLen)
            break;
          if (args[a3] == null) break;
          if (lastPos < i3)
            str += f3.slice(lastPos, i3);
          str += Number(args[a3]);
          lastPos = i3 + 2;
          i3++;
          break;
        case 105:
          if (a3 >= argLen)
            break;
          if (args[a3] == null) break;
          if (lastPos < i3)
            str += f3.slice(lastPos, i3);
          str += Math.floor(Number(args[a3]));
          lastPos = i3 + 2;
          i3++;
          break;
        case 79:
        case 111:
        case 106:
          if (a3 >= argLen)
            break;
          if (args[a3] === void 0) break;
          if (lastPos < i3)
            str += f3.slice(lastPos, i3);
          var type = typeof args[a3];
          if (type === "string") {
            str += "'" + args[a3] + "'";
            lastPos = i3 + 2;
            i3++;
            break;
          }
          if (type === "function") {
            str += args[a3].name || "<anonymous>";
            lastPos = i3 + 2;
            i3++;
            break;
          }
          str += ss(args[a3]);
          lastPos = i3 + 2;
          i3++;
          break;
        case 115:
          if (a3 >= argLen)
            break;
          if (lastPos < i3)
            str += f3.slice(lastPos, i3);
          str += String(args[a3]);
          lastPos = i3 + 2;
          i3++;
          break;
        case 37:
          if (lastPos < i3)
            str += f3.slice(lastPos, i3);
          str += "%";
          lastPos = i3 + 2;
          i3++;
          a3--;
          break;
      }
      ++a3;
    }
    ++i3;
  }
  if (lastPos === -1)
    return f3;
  else if (lastPos < flen) {
    str += f3.slice(lastPos);
  }
  return str;
}
const format = quickFormatUnescaped;
var browser$2 = pino;
const _console = pfGlobalThisOrFallback().console || {};
const stdSerializers = {
  mapHttpRequest: mock,
  mapHttpResponse: mock,
  wrapRequestSerializer: passthrough,
  wrapResponseSerializer: passthrough,
  wrapErrorSerializer: passthrough,
  req: mock,
  res: mock,
  err: asErrValue
};
function shouldSerialize(serialize, serializers) {
  if (Array.isArray(serialize)) {
    const hasToFilter = serialize.filter(function(k2) {
      return k2 !== "!stdSerializers.err";
    });
    return hasToFilter;
  } else if (serialize === true) {
    return Object.keys(serializers);
  }
  return false;
}
function pino(opts) {
  opts = opts || {};
  opts.browser = opts.browser || {};
  const transmit2 = opts.browser.transmit;
  if (transmit2 && typeof transmit2.send !== "function") {
    throw Error("pino: transmit option must have a send function");
  }
  const proto = opts.browser.write || _console;
  if (opts.browser.write) opts.browser.asObject = true;
  const serializers = opts.serializers || {};
  const serialize = shouldSerialize(opts.browser.serialize, serializers);
  let stdErrSerialize = opts.browser.serialize;
  if (Array.isArray(opts.browser.serialize) && opts.browser.serialize.indexOf("!stdSerializers.err") > -1) stdErrSerialize = false;
  const levels = ["error", "fatal", "warn", "info", "debug", "trace"];
  if (typeof proto === "function") {
    proto.error = proto.fatal = proto.warn = proto.info = proto.debug = proto.trace = proto;
  }
  if (opts.enabled === false) opts.level = "silent";
  const level = opts.level || "info";
  const logger2 = Object.create(proto);
  if (!logger2.log) logger2.log = noop;
  Object.defineProperty(logger2, "levelVal", {
    get: getLevelVal
  });
  Object.defineProperty(logger2, "level", {
    get: getLevel,
    set: setLevel
  });
  const setOpts = {
    transmit: transmit2,
    serialize,
    asObject: opts.browser.asObject,
    levels,
    timestamp: getTimeFunction(opts)
  };
  logger2.levels = pino.levels;
  logger2.level = level;
  logger2.setMaxListeners = logger2.getMaxListeners = logger2.emit = logger2.addListener = logger2.on = logger2.prependListener = logger2.once = logger2.prependOnceListener = logger2.removeListener = logger2.removeAllListeners = logger2.listeners = logger2.listenerCount = logger2.eventNames = logger2.write = logger2.flush = noop;
  logger2.serializers = serializers;
  logger2._serialize = serialize;
  logger2._stdErrSerialize = stdErrSerialize;
  logger2.child = child;
  if (transmit2) logger2._logEvent = createLogEventShape();
  function getLevelVal() {
    return this.level === "silent" ? Infinity : this.levels.values[this.level];
  }
  function getLevel() {
    return this._level;
  }
  function setLevel(level2) {
    if (level2 !== "silent" && !this.levels.values[level2]) {
      throw Error("unknown level " + level2);
    }
    this._level = level2;
    set(setOpts, logger2, "error", "log");
    set(setOpts, logger2, "fatal", "error");
    set(setOpts, logger2, "warn", "error");
    set(setOpts, logger2, "info", "log");
    set(setOpts, logger2, "debug", "log");
    set(setOpts, logger2, "trace", "log");
  }
  function child(bindings, childOptions) {
    if (!bindings) {
      throw new Error("missing bindings for child Pino");
    }
    childOptions = childOptions || {};
    if (serialize && bindings.serializers) {
      childOptions.serializers = bindings.serializers;
    }
    const childOptionsSerializers = childOptions.serializers;
    if (serialize && childOptionsSerializers) {
      var childSerializers = Object.assign({}, serializers, childOptionsSerializers);
      var childSerialize = opts.browser.serialize === true ? Object.keys(childSerializers) : serialize;
      delete bindings.serializers;
      applySerializers([bindings], childSerialize, childSerializers, this._stdErrSerialize);
    }
    function Child(parent) {
      this._childLevel = (parent._childLevel | 0) + 1;
      this.error = bind(parent, bindings, "error");
      this.fatal = bind(parent, bindings, "fatal");
      this.warn = bind(parent, bindings, "warn");
      this.info = bind(parent, bindings, "info");
      this.debug = bind(parent, bindings, "debug");
      this.trace = bind(parent, bindings, "trace");
      if (childSerializers) {
        this.serializers = childSerializers;
        this._serialize = childSerialize;
      }
      if (transmit2) {
        this._logEvent = createLogEventShape(
          [].concat(parent._logEvent.bindings, bindings)
        );
      }
    }
    Child.prototype = this;
    return new Child(this);
  }
  return logger2;
}
pino.levels = {
  values: {
    fatal: 60,
    error: 50,
    warn: 40,
    info: 30,
    debug: 20,
    trace: 10
  },
  labels: {
    10: "trace",
    20: "debug",
    30: "info",
    40: "warn",
    50: "error",
    60: "fatal"
  }
};
pino.stdSerializers = stdSerializers;
pino.stdTimeFunctions = Object.assign({}, { nullTime, epochTime, unixTime, isoTime });
function set(opts, logger2, level, fallback) {
  const proto = Object.getPrototypeOf(logger2);
  logger2[level] = logger2.levelVal > logger2.levels.values[level] ? noop : proto[level] ? proto[level] : _console[level] || _console[fallback] || noop;
  wrap(opts, logger2, level);
}
function wrap(opts, logger2, level) {
  if (!opts.transmit && logger2[level] === noop) return;
  logger2[level] = /* @__PURE__ */ function(write) {
    return function LOG() {
      const ts = opts.timestamp();
      const args = new Array(arguments.length);
      const proto = Object.getPrototypeOf && Object.getPrototypeOf(this) === _console ? _console : this;
      for (var i3 = 0; i3 < args.length; i3++) args[i3] = arguments[i3];
      if (opts.serialize && !opts.asObject) {
        applySerializers(args, this._serialize, this.serializers, this._stdErrSerialize);
      }
      if (opts.asObject) write.call(proto, asObject(this, level, args, ts));
      else write.apply(proto, args);
      if (opts.transmit) {
        const transmitLevel = opts.transmit.level || logger2.level;
        const transmitValue = pino.levels.values[transmitLevel];
        const methodValue = pino.levels.values[level];
        if (methodValue < transmitValue) return;
        transmit(this, {
          ts,
          methodLevel: level,
          methodValue,
          transmitLevel,
          transmitValue: pino.levels.values[opts.transmit.level || logger2.level],
          send: opts.transmit.send,
          val: logger2.levelVal
        }, args);
      }
    };
  }(logger2[level]);
}
function asObject(logger2, level, args, ts) {
  if (logger2._serialize) applySerializers(args, logger2._serialize, logger2.serializers, logger2._stdErrSerialize);
  const argsCloned = args.slice();
  let msg = argsCloned[0];
  const o3 = {};
  if (ts) {
    o3.time = ts;
  }
  o3.level = pino.levels.values[level];
  let lvl = (logger2._childLevel | 0) + 1;
  if (lvl < 1) lvl = 1;
  if (msg !== null && typeof msg === "object") {
    while (lvl-- && typeof argsCloned[0] === "object") {
      Object.assign(o3, argsCloned.shift());
    }
    msg = argsCloned.length ? format(argsCloned.shift(), argsCloned) : void 0;
  } else if (typeof msg === "string") msg = format(argsCloned.shift(), argsCloned);
  if (msg !== void 0) o3.msg = msg;
  return o3;
}
function applySerializers(args, serialize, serializers, stdErrSerialize) {
  for (const i3 in args) {
    if (stdErrSerialize && args[i3] instanceof Error) {
      args[i3] = pino.stdSerializers.err(args[i3]);
    } else if (typeof args[i3] === "object" && !Array.isArray(args[i3])) {
      for (const k2 in args[i3]) {
        if (serialize && serialize.indexOf(k2) > -1 && k2 in serializers) {
          args[i3][k2] = serializers[k2](args[i3][k2]);
        }
      }
    }
  }
}
function bind(parent, bindings, level) {
  return function() {
    const args = new Array(1 + arguments.length);
    args[0] = bindings;
    for (var i3 = 1; i3 < args.length; i3++) {
      args[i3] = arguments[i3 - 1];
    }
    return parent[level].apply(this, args);
  };
}
function transmit(logger2, opts, args) {
  const send = opts.send;
  const ts = opts.ts;
  const methodLevel = opts.methodLevel;
  const methodValue = opts.methodValue;
  const val = opts.val;
  const bindings = logger2._logEvent.bindings;
  applySerializers(
    args,
    logger2._serialize || Object.keys(logger2.serializers),
    logger2.serializers,
    logger2._stdErrSerialize === void 0 ? true : logger2._stdErrSerialize
  );
  logger2._logEvent.ts = ts;
  logger2._logEvent.messages = args.filter(function(arg) {
    return bindings.indexOf(arg) === -1;
  });
  logger2._logEvent.level.label = methodLevel;
  logger2._logEvent.level.value = methodValue;
  send(methodLevel, logger2._logEvent, val);
  logger2._logEvent = createLogEventShape(bindings);
}
function createLogEventShape(bindings) {
  return {
    ts: 0,
    messages: [],
    bindings: bindings || [],
    level: { label: "", value: 0 }
  };
}
function asErrValue(err) {
  const obj = {
    type: err.constructor.name,
    msg: err.message,
    stack: err.stack
  };
  for (const key2 in err) {
    if (obj[key2] === void 0) {
      obj[key2] = err[key2];
    }
  }
  return obj;
}
function getTimeFunction(opts) {
  if (typeof opts.timestamp === "function") {
    return opts.timestamp;
  }
  if (opts.timestamp === false) {
    return nullTime;
  }
  return epochTime;
}
function mock() {
  return {};
}
function passthrough(a3) {
  return a3;
}
function noop() {
}
function nullTime() {
  return false;
}
function epochTime() {
  return Date.now();
}
function unixTime() {
  return Math.round(Date.now() / 1e3);
}
function isoTime() {
  return new Date(Date.now()).toISOString();
}
function pfGlobalThisOrFallback() {
  function defd(o3) {
    return typeof o3 !== "undefined" && o3;
  }
  try {
    if (typeof globalThis !== "undefined") return globalThis;
    Object.defineProperty(Object.prototype, "globalThis", {
      get: function() {
        delete Object.prototype.globalThis;
        return this.globalThis = this;
      },
      configurable: true
    });
    return globalThis;
  } catch (e2) {
    return defd(self) || defd(window) || defd(this) || {};
  }
}
const qt$3 = /* @__PURE__ */ getDefaultExportFromCjs(browser$2);
const c$1 = { level: "info" }, n$2 = "custom_context", l$1 = 1e3 * 1024;
let O$4 = class O {
  constructor(e2) {
    this.nodeValue = e2, this.sizeInBytes = new TextEncoder().encode(this.nodeValue).length, this.next = null;
  }
  get value() {
    return this.nodeValue;
  }
  get size() {
    return this.sizeInBytes;
  }
};
let d$2 = class d {
  constructor(e2) {
    this.head = null, this.tail = null, this.lengthInNodes = 0, this.maxSizeInBytes = e2, this.sizeInBytes = 0;
  }
  append(e2) {
    const t = new O$4(e2);
    if (t.size > this.maxSizeInBytes) throw new Error(`[LinkedList] Value too big to insert into list: ${e2} with size ${t.size}`);
    for (; this.size + t.size > this.maxSizeInBytes; ) this.shift();
    this.head ? (this.tail && (this.tail.next = t), this.tail = t) : (this.head = t, this.tail = t), this.lengthInNodes++, this.sizeInBytes += t.size;
  }
  shift() {
    if (!this.head) return;
    const e2 = this.head;
    this.head = this.head.next, this.head || (this.tail = null), this.lengthInNodes--, this.sizeInBytes -= e2.size;
  }
  toArray() {
    const e2 = [];
    let t = this.head;
    for (; t !== null; ) e2.push(t.value), t = t.next;
    return e2;
  }
  get length() {
    return this.lengthInNodes;
  }
  get size() {
    return this.sizeInBytes;
  }
  toOrderedArray() {
    return Array.from(this);
  }
  [Symbol.iterator]() {
    let e2 = this.head;
    return { next: () => {
      if (!e2) return { done: true, value: null };
      const t = e2.value;
      return e2 = e2.next, { done: false, value: t };
    } };
  }
};
let L$3 = class L {
  constructor(e2, t = l$1) {
    this.level = e2 ?? "error", this.levelValue = browser$2.levels.values[this.level], this.MAX_LOG_SIZE_IN_BYTES = t, this.logs = new d$2(this.MAX_LOG_SIZE_IN_BYTES);
  }
  forwardToConsole(e2, t) {
    t === browser$2.levels.values.error ? console.error(e2) : t === browser$2.levels.values.warn ? console.warn(e2) : t === browser$2.levels.values.debug ? console.debug(e2) : t === browser$2.levels.values.trace ? console.trace(e2) : console.log(e2);
  }
  appendToLogs(e2) {
    this.logs.append(safeJsonStringify({ timestamp: (/* @__PURE__ */ new Date()).toISOString(), log: e2 }));
    const t = typeof e2 == "string" ? JSON.parse(e2).level : e2.level;
    t >= this.levelValue && this.forwardToConsole(e2, t);
  }
  getLogs() {
    return this.logs;
  }
  clearLogs() {
    this.logs = new d$2(this.MAX_LOG_SIZE_IN_BYTES);
  }
  getLogArray() {
    return Array.from(this.logs);
  }
  logsToBlob(e2) {
    const t = this.getLogArray();
    return t.push(safeJsonStringify({ extraMetadata: e2 })), new Blob(t, { type: "application/json" });
  }
};
class m {
  constructor(e2, t = l$1) {
    this.baseChunkLogger = new L$3(e2, t);
  }
  write(e2) {
    this.baseChunkLogger.appendToLogs(e2);
  }
  getLogs() {
    return this.baseChunkLogger.getLogs();
  }
  clearLogs() {
    this.baseChunkLogger.clearLogs();
  }
  getLogArray() {
    return this.baseChunkLogger.getLogArray();
  }
  logsToBlob(e2) {
    return this.baseChunkLogger.logsToBlob(e2);
  }
  downloadLogsBlobInBrowser(e2) {
    const t = URL.createObjectURL(this.logsToBlob(e2)), o3 = document.createElement("a");
    o3.href = t, o3.download = `walletconnect-logs-${(/* @__PURE__ */ new Date()).toISOString()}.txt`, document.body.appendChild(o3), o3.click(), document.body.removeChild(o3), URL.revokeObjectURL(t);
  }
}
let B$3 = class B {
  constructor(e2, t = l$1) {
    this.baseChunkLogger = new L$3(e2, t);
  }
  write(e2) {
    this.baseChunkLogger.appendToLogs(e2);
  }
  getLogs() {
    return this.baseChunkLogger.getLogs();
  }
  clearLogs() {
    this.baseChunkLogger.clearLogs();
  }
  getLogArray() {
    return this.baseChunkLogger.getLogArray();
  }
  logsToBlob(e2) {
    return this.baseChunkLogger.logsToBlob(e2);
  }
};
var x$5 = Object.defineProperty, S$6 = Object.defineProperties, _$2 = Object.getOwnPropertyDescriptors, p$2 = Object.getOwnPropertySymbols, T$2 = Object.prototype.hasOwnProperty, z$5 = Object.prototype.propertyIsEnumerable, f$3 = (r2, e2, t) => e2 in r2 ? x$5(r2, e2, { enumerable: true, configurable: true, writable: true, value: t }) : r2[e2] = t, i2 = (r2, e2) => {
  for (var t in e2 || (e2 = {})) T$2.call(e2, t) && f$3(r2, t, e2[t]);
  if (p$2) for (var t of p$2(e2)) z$5.call(e2, t) && f$3(r2, t, e2[t]);
  return r2;
}, g$3 = (r2, e2) => S$6(r2, _$2(e2));
function k$2(r2) {
  return g$3(i2({}, r2), { level: (r2 == null ? void 0 : r2.level) || c$1.level });
}
function v$4(r2, e2 = n$2) {
  return r2[e2] || "";
}
function b$3(r2, e2, t = n$2) {
  return r2[t] = e2, r2;
}
function y$3(r2, e2 = n$2) {
  let t = "";
  return typeof r2.bindings > "u" ? t = v$4(r2, e2) : t = r2.bindings().context || "", t;
}
function w$2(r2, e2, t = n$2) {
  const o3 = y$3(r2, t);
  return o3.trim() ? `${o3}/${e2}` : e2;
}
function E$1(r2, e2, t = n$2) {
  const o3 = w$2(r2, e2, t), a3 = r2.child({ context: o3 });
  return b$3(a3, o3, t);
}
function C$4(r2) {
  var e2, t;
  const o3 = new m((e2 = r2.opts) == null ? void 0 : e2.level, r2.maxSizeInBytes);
  return { logger: qt$3(g$3(i2({}, r2.opts), { level: "trace", browser: g$3(i2({}, (t = r2.opts) == null ? void 0 : t.browser), { write: (a3) => o3.write(a3) }) })), chunkLoggerController: o3 };
}
function I$4(r2) {
  var e2;
  const t = new B$3((e2 = r2.opts) == null ? void 0 : e2.level, r2.maxSizeInBytes);
  return { logger: qt$3(g$3(i2({}, r2.opts), { level: "trace" }), t), chunkLoggerController: t };
}
function A$1(r2) {
  return typeof r2.loggerOverride < "u" && typeof r2.loggerOverride != "string" ? { logger: r2.loggerOverride, chunkLoggerController: null } : typeof window < "u" ? C$4(r2) : I$4(r2);
}
let n$1 = class n2 extends IEvents {
  constructor(s2) {
    super(), this.opts = s2, this.protocol = "wc", this.version = 2;
  }
};
let h$1 = class h2 extends IEvents {
  constructor(s2, t) {
    super(), this.core = s2, this.logger = t, this.records = /* @__PURE__ */ new Map();
  }
};
let a$1 = class a {
  constructor(s2, t) {
    this.logger = s2, this.core = t;
  }
};
let g$2 = class g extends IEvents {
  constructor(s2, t) {
    super(), this.relayer = s2, this.logger = t;
  }
};
class u extends IEvents {
  constructor(s2) {
    super();
  }
}
let p$1 = class p {
  constructor(s2, t, e2, f3) {
    this.core = s2, this.logger = t, this.name = e2;
  }
};
let d$1 = class d2 extends IEvents {
  constructor(s2, t) {
    super(), this.relayer = s2, this.logger = t;
  }
};
let x$4 = class x extends IEvents {
  constructor(s2, t) {
    super(), this.core = s2, this.logger = t;
  }
};
let y$2 = class y {
  constructor(s2, t, e2) {
    this.core = s2, this.logger = t, this.store = e2;
  }
};
let v$3 = class v {
  constructor(s2, t) {
    this.projectId = s2, this.logger = t;
  }
};
let C$3 = class C {
  constructor(s2, t, e2) {
    this.core = s2, this.logger = t, this.telemetryEnabled = e2;
  }
};
var ed25519 = {};
var random = {};
var system = {};
var browser$1 = {};
Object.defineProperty(browser$1, "__esModule", { value: true });
browser$1.BrowserRandomSource = void 0;
const QUOTA = 65536;
class BrowserRandomSource {
  constructor() {
    this.isAvailable = false;
    this.isInstantiated = false;
    const browserCrypto = typeof self !== "undefined" ? self.crypto || self.msCrypto : null;
    if (browserCrypto && browserCrypto.getRandomValues !== void 0) {
      this._crypto = browserCrypto;
      this.isAvailable = true;
      this.isInstantiated = true;
    }
  }
  randomBytes(length) {
    if (!this.isAvailable || !this._crypto) {
      throw new Error("Browser random byte generator is not available.");
    }
    const out = new Uint8Array(length);
    for (let i3 = 0; i3 < out.length; i3 += QUOTA) {
      this._crypto.getRandomValues(out.subarray(i3, i3 + Math.min(out.length - i3, QUOTA)));
    }
    return out;
  }
}
browser$1.BrowserRandomSource = BrowserRandomSource;
var node = {};
var wipe$b = {};
Object.defineProperty(wipe$b, "__esModule", { value: true });
function wipe$a(array) {
  for (var i3 = 0; i3 < array.length; i3++) {
    array[i3] = 0;
  }
  return array;
}
wipe$b.wipe = wipe$a;
Object.defineProperty(node, "__esModule", { value: true });
node.NodeRandomSource = void 0;
const wipe_1$3 = wipe$b;
class NodeRandomSource {
  constructor() {
    this.isAvailable = false;
    this.isInstantiated = false;
    if (typeof commonjsRequire$1 !== "undefined") {
      const nodeCrypto = requireCryptoBrowserify();
      if (nodeCrypto && nodeCrypto.randomBytes) {
        this._crypto = nodeCrypto;
        this.isAvailable = true;
        this.isInstantiated = true;
      }
    }
  }
  randomBytes(length) {
    if (!this.isAvailable || !this._crypto) {
      throw new Error("Node.js random byte generator is not available.");
    }
    let buffer = this._crypto.randomBytes(length);
    if (buffer.length !== length) {
      throw new Error("NodeRandomSource: got fewer bytes than requested");
    }
    const out = new Uint8Array(length);
    for (let i3 = 0; i3 < out.length; i3++) {
      out[i3] = buffer[i3];
    }
    (0, wipe_1$3.wipe)(buffer);
    return out;
  }
}
node.NodeRandomSource = NodeRandomSource;
Object.defineProperty(system, "__esModule", { value: true });
system.SystemRandomSource = void 0;
const browser_1 = browser$1;
const node_1 = node;
class SystemRandomSource {
  constructor() {
    this.isAvailable = false;
    this.name = "";
    this._source = new browser_1.BrowserRandomSource();
    if (this._source.isAvailable) {
      this.isAvailable = true;
      this.name = "Browser";
      return;
    }
    this._source = new node_1.NodeRandomSource();
    if (this._source.isAvailable) {
      this.isAvailable = true;
      this.name = "Node";
      return;
    }
  }
  randomBytes(length) {
    if (!this.isAvailable) {
      throw new Error("System random byte generator is not available.");
    }
    return this._source.randomBytes(length);
  }
}
system.SystemRandomSource = SystemRandomSource;
var binary$3 = {};
var int$3 = {};
(function(exports) {
  Object.defineProperty(exports, "__esModule", { value: true });
  function imulShim(a3, b2) {
    var ah = a3 >>> 16 & 65535, al = a3 & 65535;
    var bh = b2 >>> 16 & 65535, bl = b2 & 65535;
    return al * bl + (ah * bl + al * bh << 16 >>> 0) | 0;
  }
  exports.mul = Math.imul || imulShim;
  function add7(a3, b2) {
    return a3 + b2 | 0;
  }
  exports.add = add7;
  function sub(a3, b2) {
    return a3 - b2 | 0;
  }
  exports.sub = sub;
  function rotl(x3, n4) {
    return x3 << n4 | x3 >>> 32 - n4;
  }
  exports.rotl = rotl;
  function rotr(x3, n4) {
    return x3 << 32 - n4 | x3 >>> n4;
  }
  exports.rotr = rotr;
  function isIntegerShim(n4) {
    return typeof n4 === "number" && isFinite(n4) && Math.floor(n4) === n4;
  }
  exports.isInteger = Number.isInteger || isIntegerShim;
  exports.MAX_SAFE_INTEGER = 9007199254740991;
  exports.isSafeInteger = function(n4) {
    return exports.isInteger(n4) && (n4 >= -exports.MAX_SAFE_INTEGER && n4 <= exports.MAX_SAFE_INTEGER);
  };
})(int$3);
Object.defineProperty(binary$3, "__esModule", { value: true });
var int_1$3 = int$3;
function readInt16BE$3(array, offset) {
  if (offset === void 0) {
    offset = 0;
  }
  return (array[offset + 0] << 8 | array[offset + 1]) << 16 >> 16;
}
binary$3.readInt16BE = readInt16BE$3;
function readUint16BE$3(array, offset) {
  if (offset === void 0) {
    offset = 0;
  }
  return (array[offset + 0] << 8 | array[offset + 1]) >>> 0;
}
binary$3.readUint16BE = readUint16BE$3;
function readInt16LE$3(array, offset) {
  if (offset === void 0) {
    offset = 0;
  }
  return (array[offset + 1] << 8 | array[offset]) << 16 >> 16;
}
binary$3.readInt16LE = readInt16LE$3;
function readUint16LE$3(array, offset) {
  if (offset === void 0) {
    offset = 0;
  }
  return (array[offset + 1] << 8 | array[offset]) >>> 0;
}
binary$3.readUint16LE = readUint16LE$3;
function writeUint16BE$3(value, out, offset) {
  if (out === void 0) {
    out = new Uint8Array(2);
  }
  if (offset === void 0) {
    offset = 0;
  }
  out[offset + 0] = value >>> 8;
  out[offset + 1] = value >>> 0;
  return out;
}
binary$3.writeUint16BE = writeUint16BE$3;
binary$3.writeInt16BE = writeUint16BE$3;
function writeUint16LE$3(value, out, offset) {
  if (out === void 0) {
    out = new Uint8Array(2);
  }
  if (offset === void 0) {
    offset = 0;
  }
  out[offset + 0] = value >>> 0;
  out[offset + 1] = value >>> 8;
  return out;
}
binary$3.writeUint16LE = writeUint16LE$3;
binary$3.writeInt16LE = writeUint16LE$3;
function readInt32BE$3(array, offset) {
  if (offset === void 0) {
    offset = 0;
  }
  return array[offset] << 24 | array[offset + 1] << 16 | array[offset + 2] << 8 | array[offset + 3];
}
binary$3.readInt32BE = readInt32BE$3;
function readUint32BE$3(array, offset) {
  if (offset === void 0) {
    offset = 0;
  }
  return (array[offset] << 24 | array[offset + 1] << 16 | array[offset + 2] << 8 | array[offset + 3]) >>> 0;
}
binary$3.readUint32BE = readUint32BE$3;
function readInt32LE$3(array, offset) {
  if (offset === void 0) {
    offset = 0;
  }
  return array[offset + 3] << 24 | array[offset + 2] << 16 | array[offset + 1] << 8 | array[offset];
}
binary$3.readInt32LE = readInt32LE$3;
function readUint32LE$3(array, offset) {
  if (offset === void 0) {
    offset = 0;
  }
  return (array[offset + 3] << 24 | array[offset + 2] << 16 | array[offset + 1] << 8 | array[offset]) >>> 0;
}
binary$3.readUint32LE = readUint32LE$3;
function writeUint32BE$3(value, out, offset) {
  if (out === void 0) {
    out = new Uint8Array(4);
  }
  if (offset === void 0) {
    offset = 0;
  }
  out[offset + 0] = value >>> 24;
  out[offset + 1] = value >>> 16;
  out[offset + 2] = value >>> 8;
  out[offset + 3] = value >>> 0;
  return out;
}
binary$3.writeUint32BE = writeUint32BE$3;
binary$3.writeInt32BE = writeUint32BE$3;
function writeUint32LE$3(value, out, offset) {
  if (out === void 0) {
    out = new Uint8Array(4);
  }
  if (offset === void 0) {
    offset = 0;
  }
  out[offset + 0] = value >>> 0;
  out[offset + 1] = value >>> 8;
  out[offset + 2] = value >>> 16;
  out[offset + 3] = value >>> 24;
  return out;
}
binary$3.writeUint32LE = writeUint32LE$3;
binary$3.writeInt32LE = writeUint32LE$3;
function readInt64BE$3(array, offset) {
  if (offset === void 0) {
    offset = 0;
  }
  var hi2 = readInt32BE$3(array, offset);
  var lo2 = readInt32BE$3(array, offset + 4);
  return hi2 * 4294967296 + lo2 - (lo2 >> 31) * 4294967296;
}
binary$3.readInt64BE = readInt64BE$3;
function readUint64BE$3(array, offset) {
  if (offset === void 0) {
    offset = 0;
  }
  var hi2 = readUint32BE$3(array, offset);
  var lo2 = readUint32BE$3(array, offset + 4);
  return hi2 * 4294967296 + lo2;
}
binary$3.readUint64BE = readUint64BE$3;
function readInt64LE$3(array, offset) {
  if (offset === void 0) {
    offset = 0;
  }
  var lo2 = readInt32LE$3(array, offset);
  var hi2 = readInt32LE$3(array, offset + 4);
  return hi2 * 4294967296 + lo2 - (lo2 >> 31) * 4294967296;
}
binary$3.readInt64LE = readInt64LE$3;
function readUint64LE$3(array, offset) {
  if (offset === void 0) {
    offset = 0;
  }
  var lo2 = readUint32LE$3(array, offset);
  var hi2 = readUint32LE$3(array, offset + 4);
  return hi2 * 4294967296 + lo2;
}
binary$3.readUint64LE = readUint64LE$3;
function writeUint64BE$3(value, out, offset) {
  if (out === void 0) {
    out = new Uint8Array(8);
  }
  if (offset === void 0) {
    offset = 0;
  }
  writeUint32BE$3(value / 4294967296 >>> 0, out, offset);
  writeUint32BE$3(value >>> 0, out, offset + 4);
  return out;
}
binary$3.writeUint64BE = writeUint64BE$3;
binary$3.writeInt64BE = writeUint64BE$3;
function writeUint64LE$3(value, out, offset) {
  if (out === void 0) {
    out = new Uint8Array(8);
  }
  if (offset === void 0) {
    offset = 0;
  }
  writeUint32LE$3(value >>> 0, out, offset);
  writeUint32LE$3(value / 4294967296 >>> 0, out, offset + 4);
  return out;
}
binary$3.writeUint64LE = writeUint64LE$3;
binary$3.writeInt64LE = writeUint64LE$3;
function readUintBE$3(bitLength, array, offset) {
  if (offset === void 0) {
    offset = 0;
  }
  if (bitLength % 8 !== 0) {
    throw new Error("readUintBE supports only bitLengths divisible by 8");
  }
  if (bitLength / 8 > array.length - offset) {
    throw new Error("readUintBE: array is too short for the given bitLength");
  }
  var result = 0;
  var mul7 = 1;
  for (var i3 = bitLength / 8 + offset - 1; i3 >= offset; i3--) {
    result += array[i3] * mul7;
    mul7 *= 256;
  }
  return result;
}
binary$3.readUintBE = readUintBE$3;
function readUintLE$3(bitLength, array, offset) {
  if (offset === void 0) {
    offset = 0;
  }
  if (bitLength % 8 !== 0) {
    throw new Error("readUintLE supports only bitLengths divisible by 8");
  }
  if (bitLength / 8 > array.length - offset) {
    throw new Error("readUintLE: array is too short for the given bitLength");
  }
  var result = 0;
  var mul7 = 1;
  for (var i3 = offset; i3 < offset + bitLength / 8; i3++) {
    result += array[i3] * mul7;
    mul7 *= 256;
  }
  return result;
}
binary$3.readUintLE = readUintLE$3;
function writeUintBE$3(bitLength, value, out, offset) {
  if (out === void 0) {
    out = new Uint8Array(bitLength / 8);
  }
  if (offset === void 0) {
    offset = 0;
  }
  if (bitLength % 8 !== 0) {
    throw new Error("writeUintBE supports only bitLengths divisible by 8");
  }
  if (!int_1$3.isSafeInteger(value)) {
    throw new Error("writeUintBE value must be an integer");
  }
  var div = 1;
  for (var i3 = bitLength / 8 + offset - 1; i3 >= offset; i3--) {
    out[i3] = value / div & 255;
    div *= 256;
  }
  return out;
}
binary$3.writeUintBE = writeUintBE$3;
function writeUintLE$3(bitLength, value, out, offset) {
  if (out === void 0) {
    out = new Uint8Array(bitLength / 8);
  }
  if (offset === void 0) {
    offset = 0;
  }
  if (bitLength % 8 !== 0) {
    throw new Error("writeUintLE supports only bitLengths divisible by 8");
  }
  if (!int_1$3.isSafeInteger(value)) {
    throw new Error("writeUintLE value must be an integer");
  }
  var div = 1;
  for (var i3 = offset; i3 < offset + bitLength / 8; i3++) {
    out[i3] = value / div & 255;
    div *= 256;
  }
  return out;
}
binary$3.writeUintLE = writeUintLE$3;
function readFloat32BE$3(array, offset) {
  if (offset === void 0) {
    offset = 0;
  }
  var view = new DataView(array.buffer, array.byteOffset, array.byteLength);
  return view.getFloat32(offset);
}
binary$3.readFloat32BE = readFloat32BE$3;
function readFloat32LE$3(array, offset) {
  if (offset === void 0) {
    offset = 0;
  }
  var view = new DataView(array.buffer, array.byteOffset, array.byteLength);
  return view.getFloat32(offset, true);
}
binary$3.readFloat32LE = readFloat32LE$3;
function readFloat64BE$3(array, offset) {
  if (offset === void 0) {
    offset = 0;
  }
  var view = new DataView(array.buffer, array.byteOffset, array.byteLength);
  return view.getFloat64(offset);
}
binary$3.readFloat64BE = readFloat64BE$3;
function readFloat64LE$3(array, offset) {
  if (offset === void 0) {
    offset = 0;
  }
  var view = new DataView(array.buffer, array.byteOffset, array.byteLength);
  return view.getFloat64(offset, true);
}
binary$3.readFloat64LE = readFloat64LE$3;
function writeFloat32BE$3(value, out, offset) {
  if (out === void 0) {
    out = new Uint8Array(4);
  }
  if (offset === void 0) {
    offset = 0;
  }
  var view = new DataView(out.buffer, out.byteOffset, out.byteLength);
  view.setFloat32(offset, value);
  return out;
}
binary$3.writeFloat32BE = writeFloat32BE$3;
function writeFloat32LE$3(value, out, offset) {
  if (out === void 0) {
    out = new Uint8Array(4);
  }
  if (offset === void 0) {
    offset = 0;
  }
  var view = new DataView(out.buffer, out.byteOffset, out.byteLength);
  view.setFloat32(offset, value, true);
  return out;
}
binary$3.writeFloat32LE = writeFloat32LE$3;
function writeFloat64BE$3(value, out, offset) {
  if (out === void 0) {
    out = new Uint8Array(8);
  }
  if (offset === void 0) {
    offset = 0;
  }
  var view = new DataView(out.buffer, out.byteOffset, out.byteLength);
  view.setFloat64(offset, value);
  return out;
}
binary$3.writeFloat64BE = writeFloat64BE$3;
function writeFloat64LE$3(value, out, offset) {
  if (out === void 0) {
    out = new Uint8Array(8);
  }
  if (offset === void 0) {
    offset = 0;
  }
  var view = new DataView(out.buffer, out.byteOffset, out.byteLength);
  view.setFloat64(offset, value, true);
  return out;
}
binary$3.writeFloat64LE = writeFloat64LE$3;
(function(exports) {
  Object.defineProperty(exports, "__esModule", { value: true });
  exports.randomStringForEntropy = exports.randomString = exports.randomUint32 = exports.randomBytes = exports.defaultRandomSource = void 0;
  const system_1 = system;
  const binary_12 = binary$3;
  const wipe_12 = wipe$b;
  exports.defaultRandomSource = new system_1.SystemRandomSource();
  function randomBytes(length, prng = exports.defaultRandomSource) {
    return prng.randomBytes(length);
  }
  exports.randomBytes = randomBytes;
  function randomUint32(prng = exports.defaultRandomSource) {
    const buf = randomBytes(4, prng);
    const result = (0, binary_12.readUint32LE)(buf);
    (0, wipe_12.wipe)(buf);
    return result;
  }
  exports.randomUint32 = randomUint32;
  const ALPHANUMERIC = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
  function randomString(length, charset = ALPHANUMERIC, prng = exports.defaultRandomSource) {
    if (charset.length < 2) {
      throw new Error("randomString charset is too short");
    }
    if (charset.length > 256) {
      throw new Error("randomString charset is too long");
    }
    let out = "";
    const charsLen = charset.length;
    const maxByte = 256 - 256 % charsLen;
    while (length > 0) {
      const buf = randomBytes(Math.ceil(length * 256 / maxByte), prng);
      for (let i3 = 0; i3 < buf.length && length > 0; i3++) {
        const randomByte = buf[i3];
        if (randomByte < maxByte) {
          out += charset.charAt(randomByte % charsLen);
          length--;
        }
      }
      (0, wipe_12.wipe)(buf);
    }
    return out;
  }
  exports.randomString = randomString;
  function randomStringForEntropy(bits, charset = ALPHANUMERIC, prng = exports.defaultRandomSource) {
    const length = Math.ceil(bits / (Math.log(charset.length) / Math.LN2));
    return randomString(length, charset, prng);
  }
  exports.randomStringForEntropy = randomStringForEntropy;
})(random);
var sha512 = {};
var binary$2 = {};
var int$2 = {};
(function(exports) {
  Object.defineProperty(exports, "__esModule", { value: true });
  function imulShim(a3, b2) {
    var ah = a3 >>> 16 & 65535, al = a3 & 65535;
    var bh = b2 >>> 16 & 65535, bl = b2 & 65535;
    return al * bl + (ah * bl + al * bh << 16 >>> 0) | 0;
  }
  exports.mul = Math.imul || imulShim;
  function add7(a3, b2) {
    return a3 + b2 | 0;
  }
  exports.add = add7;
  function sub(a3, b2) {
    return a3 - b2 | 0;
  }
  exports.sub = sub;
  function rotl(x3, n4) {
    return x3 << n4 | x3 >>> 32 - n4;
  }
  exports.rotl = rotl;
  function rotr(x3, n4) {
    return x3 << 32 - n4 | x3 >>> n4;
  }
  exports.rotr = rotr;
  function isIntegerShim(n4) {
    return typeof n4 === "number" && isFinite(n4) && Math.floor(n4) === n4;
  }
  exports.isInteger = Number.isInteger || isIntegerShim;
  exports.MAX_SAFE_INTEGER = 9007199254740991;
  exports.isSafeInteger = function(n4) {
    return exports.isInteger(n4) && (n4 >= -exports.MAX_SAFE_INTEGER && n4 <= exports.MAX_SAFE_INTEGER);
  };
})(int$2);
Object.defineProperty(binary$2, "__esModule", { value: true });
var int_1$2 = int$2;
function readInt16BE$2(array, offset) {
  if (offset === void 0) {
    offset = 0;
  }
  return (array[offset + 0] << 8 | array[offset + 1]) << 16 >> 16;
}
binary$2.readInt16BE = readInt16BE$2;
function readUint16BE$2(array, offset) {
  if (offset === void 0) {
    offset = 0;
  }
  return (array[offset + 0] << 8 | array[offset + 1]) >>> 0;
}
binary$2.readUint16BE = readUint16BE$2;
function readInt16LE$2(array, offset) {
  if (offset === void 0) {
    offset = 0;
  }
  return (array[offset + 1] << 8 | array[offset]) << 16 >> 16;
}
binary$2.readInt16LE = readInt16LE$2;
function readUint16LE$2(array, offset) {
  if (offset === void 0) {
    offset = 0;
  }
  return (array[offset + 1] << 8 | array[offset]) >>> 0;
}
binary$2.readUint16LE = readUint16LE$2;
function writeUint16BE$2(value, out, offset) {
  if (out === void 0) {
    out = new Uint8Array(2);
  }
  if (offset === void 0) {
    offset = 0;
  }
  out[offset + 0] = value >>> 8;
  out[offset + 1] = value >>> 0;
  return out;
}
binary$2.writeUint16BE = writeUint16BE$2;
binary$2.writeInt16BE = writeUint16BE$2;
function writeUint16LE$2(value, out, offset) {
  if (out === void 0) {
    out = new Uint8Array(2);
  }
  if (offset === void 0) {
    offset = 0;
  }
  out[offset + 0] = value >>> 0;
  out[offset + 1] = value >>> 8;
  return out;
}
binary$2.writeUint16LE = writeUint16LE$2;
binary$2.writeInt16LE = writeUint16LE$2;
function readInt32BE$2(array, offset) {
  if (offset === void 0) {
    offset = 0;
  }
  return array[offset] << 24 | array[offset + 1] << 16 | array[offset + 2] << 8 | array[offset + 3];
}
binary$2.readInt32BE = readInt32BE$2;
function readUint32BE$2(array, offset) {
  if (offset === void 0) {
    offset = 0;
  }
  return (array[offset] << 24 | array[offset + 1] << 16 | array[offset + 2] << 8 | array[offset + 3]) >>> 0;
}
binary$2.readUint32BE = readUint32BE$2;
function readInt32LE$2(array, offset) {
  if (offset === void 0) {
    offset = 0;
  }
  return array[offset + 3] << 24 | array[offset + 2] << 16 | array[offset + 1] << 8 | array[offset];
}
binary$2.readInt32LE = readInt32LE$2;
function readUint32LE$2(array, offset) {
  if (offset === void 0) {
    offset = 0;
  }
  return (array[offset + 3] << 24 | array[offset + 2] << 16 | array[offset + 1] << 8 | array[offset]) >>> 0;
}
binary$2.readUint32LE = readUint32LE$2;
function writeUint32BE$2(value, out, offset) {
  if (out === void 0) {
    out = new Uint8Array(4);
  }
  if (offset === void 0) {
    offset = 0;
  }
  out[offset + 0] = value >>> 24;
  out[offset + 1] = value >>> 16;
  out[offset + 2] = value >>> 8;
  out[offset + 3] = value >>> 0;
  return out;
}
binary$2.writeUint32BE = writeUint32BE$2;
binary$2.writeInt32BE = writeUint32BE$2;
function writeUint32LE$2(value, out, offset) {
  if (out === void 0) {
    out = new Uint8Array(4);
  }
  if (offset === void 0) {
    offset = 0;
  }
  out[offset + 0] = value >>> 0;
  out[offset + 1] = value >>> 8;
  out[offset + 2] = value >>> 16;
  out[offset + 3] = value >>> 24;
  return out;
}
binary$2.writeUint32LE = writeUint32LE$2;
binary$2.writeInt32LE = writeUint32LE$2;
function readInt64BE$2(array, offset) {
  if (offset === void 0) {
    offset = 0;
  }
  var hi2 = readInt32BE$2(array, offset);
  var lo2 = readInt32BE$2(array, offset + 4);
  return hi2 * 4294967296 + lo2 - (lo2 >> 31) * 4294967296;
}
binary$2.readInt64BE = readInt64BE$2;
function readUint64BE$2(array, offset) {
  if (offset === void 0) {
    offset = 0;
  }
  var hi2 = readUint32BE$2(array, offset);
  var lo2 = readUint32BE$2(array, offset + 4);
  return hi2 * 4294967296 + lo2;
}
binary$2.readUint64BE = readUint64BE$2;
function readInt64LE$2(array, offset) {
  if (offset === void 0) {
    offset = 0;
  }
  var lo2 = readInt32LE$2(array, offset);
  var hi2 = readInt32LE$2(array, offset + 4);
  return hi2 * 4294967296 + lo2 - (lo2 >> 31) * 4294967296;
}
binary$2.readInt64LE = readInt64LE$2;
function readUint64LE$2(array, offset) {
  if (offset === void 0) {
    offset = 0;
  }
  var lo2 = readUint32LE$2(array, offset);
  var hi2 = readUint32LE$2(array, offset + 4);
  return hi2 * 4294967296 + lo2;
}
binary$2.readUint64LE = readUint64LE$2;
function writeUint64BE$2(value, out, offset) {
  if (out === void 0) {
    out = new Uint8Array(8);
  }
  if (offset === void 0) {
    offset = 0;
  }
  writeUint32BE$2(value / 4294967296 >>> 0, out, offset);
  writeUint32BE$2(value >>> 0, out, offset + 4);
  return out;
}
binary$2.writeUint64BE = writeUint64BE$2;
binary$2.writeInt64BE = writeUint64BE$2;
function writeUint64LE$2(value, out, offset) {
  if (out === void 0) {
    out = new Uint8Array(8);
  }
  if (offset === void 0) {
    offset = 0;
  }
  writeUint32LE$2(value >>> 0, out, offset);
  writeUint32LE$2(value / 4294967296 >>> 0, out, offset + 4);
  return out;
}
binary$2.writeUint64LE = writeUint64LE$2;
binary$2.writeInt64LE = writeUint64LE$2;
function readUintBE$2(bitLength, array, offset) {
  if (offset === void 0) {
    offset = 0;
  }
  if (bitLength % 8 !== 0) {
    throw new Error("readUintBE supports only bitLengths divisible by 8");
  }
  if (bitLength / 8 > array.length - offset) {
    throw new Error("readUintBE: array is too short for the given bitLength");
  }
  var result = 0;
  var mul7 = 1;
  for (var i3 = bitLength / 8 + offset - 1; i3 >= offset; i3--) {
    result += array[i3] * mul7;
    mul7 *= 256;
  }
  return result;
}
binary$2.readUintBE = readUintBE$2;
function readUintLE$2(bitLength, array, offset) {
  if (offset === void 0) {
    offset = 0;
  }
  if (bitLength % 8 !== 0) {
    throw new Error("readUintLE supports only bitLengths divisible by 8");
  }
  if (bitLength / 8 > array.length - offset) {
    throw new Error("readUintLE: array is too short for the given bitLength");
  }
  var result = 0;
  var mul7 = 1;
  for (var i3 = offset; i3 < offset + bitLength / 8; i3++) {
    result += array[i3] * mul7;
    mul7 *= 256;
  }
  return result;
}
binary$2.readUintLE = readUintLE$2;
function writeUintBE$2(bitLength, value, out, offset) {
  if (out === void 0) {
    out = new Uint8Array(bitLength / 8);
  }
  if (offset === void 0) {
    offset = 0;
  }
  if (bitLength % 8 !== 0) {
    throw new Error("writeUintBE supports only bitLengths divisible by 8");
  }
  if (!int_1$2.isSafeInteger(value)) {
    throw new Error("writeUintBE value must be an integer");
  }
  var div = 1;
  for (var i3 = bitLength / 8 + offset - 1; i3 >= offset; i3--) {
    out[i3] = value / div & 255;
    div *= 256;
  }
  return out;
}
binary$2.writeUintBE = writeUintBE$2;
function writeUintLE$2(bitLength, value, out, offset) {
  if (out === void 0) {
    out = new Uint8Array(bitLength / 8);
  }
  if (offset === void 0) {
    offset = 0;
  }
  if (bitLength % 8 !== 0) {
    throw new Error("writeUintLE supports only bitLengths divisible by 8");
  }
  if (!int_1$2.isSafeInteger(value)) {
    throw new Error("writeUintLE value must be an integer");
  }
  var div = 1;
  for (var i3 = offset; i3 < offset + bitLength / 8; i3++) {
    out[i3] = value / div & 255;
    div *= 256;
  }
  return out;
}
binary$2.writeUintLE = writeUintLE$2;
function readFloat32BE$2(array, offset) {
  if (offset === void 0) {
    offset = 0;
  }
  var view = new DataView(array.buffer, array.byteOffset, array.byteLength);
  return view.getFloat32(offset);
}
binary$2.readFloat32BE = readFloat32BE$2;
function readFloat32LE$2(array, offset) {
  if (offset === void 0) {
    offset = 0;
  }
  var view = new DataView(array.buffer, array.byteOffset, array.byteLength);
  return view.getFloat32(offset, true);
}
binary$2.readFloat32LE = readFloat32LE$2;
function readFloat64BE$2(array, offset) {
  if (offset === void 0) {
    offset = 0;
  }
  var view = new DataView(array.buffer, array.byteOffset, array.byteLength);
  return view.getFloat64(offset);
}
binary$2.readFloat64BE = readFloat64BE$2;
function readFloat64LE$2(array, offset) {
  if (offset === void 0) {
    offset = 0;
  }
  var view = new DataView(array.buffer, array.byteOffset, array.byteLength);
  return view.getFloat64(offset, true);
}
binary$2.readFloat64LE = readFloat64LE$2;
function writeFloat32BE$2(value, out, offset) {
  if (out === void 0) {
    out = new Uint8Array(4);
  }
  if (offset === void 0) {
    offset = 0;
  }
  var view = new DataView(out.buffer, out.byteOffset, out.byteLength);
  view.setFloat32(offset, value);
  return out;
}
binary$2.writeFloat32BE = writeFloat32BE$2;
function writeFloat32LE$2(value, out, offset) {
  if (out === void 0) {
    out = new Uint8Array(4);
  }
  if (offset === void 0) {
    offset = 0;
  }
  var view = new DataView(out.buffer, out.byteOffset, out.byteLength);
  view.setFloat32(offset, value, true);
  return out;
}
binary$2.writeFloat32LE = writeFloat32LE$2;
function writeFloat64BE$2(value, out, offset) {
  if (out === void 0) {
    out = new Uint8Array(8);
  }
  if (offset === void 0) {
    offset = 0;
  }
  var view = new DataView(out.buffer, out.byteOffset, out.byteLength);
  view.setFloat64(offset, value);
  return out;
}
binary$2.writeFloat64BE = writeFloat64BE$2;
function writeFloat64LE$2(value, out, offset) {
  if (out === void 0) {
    out = new Uint8Array(8);
  }
  if (offset === void 0) {
    offset = 0;
  }
  var view = new DataView(out.buffer, out.byteOffset, out.byteLength);
  view.setFloat64(offset, value, true);
  return out;
}
binary$2.writeFloat64LE = writeFloat64LE$2;
var wipe$9 = {};
Object.defineProperty(wipe$9, "__esModule", { value: true });
function wipe$8(array) {
  for (var i3 = 0; i3 < array.length; i3++) {
    array[i3] = 0;
  }
  return array;
}
wipe$9.wipe = wipe$8;
(function(exports) {
  Object.defineProperty(exports, "__esModule", { value: true });
  var binary_12 = binary$2;
  var wipe_12 = wipe$9;
  exports.DIGEST_LENGTH = 64;
  exports.BLOCK_SIZE = 128;
  var SHA512 = (
    /** @class */
    function() {
      function SHA5122() {
        this.digestLength = exports.DIGEST_LENGTH;
        this.blockSize = exports.BLOCK_SIZE;
        this._stateHi = new Int32Array(8);
        this._stateLo = new Int32Array(8);
        this._tempHi = new Int32Array(16);
        this._tempLo = new Int32Array(16);
        this._buffer = new Uint8Array(256);
        this._bufferLength = 0;
        this._bytesHashed = 0;
        this._finished = false;
        this.reset();
      }
      SHA5122.prototype._initState = function() {
        this._stateHi[0] = 1779033703;
        this._stateHi[1] = 3144134277;
        this._stateHi[2] = 1013904242;
        this._stateHi[3] = 2773480762;
        this._stateHi[4] = 1359893119;
        this._stateHi[5] = 2600822924;
        this._stateHi[6] = 528734635;
        this._stateHi[7] = 1541459225;
        this._stateLo[0] = 4089235720;
        this._stateLo[1] = 2227873595;
        this._stateLo[2] = 4271175723;
        this._stateLo[3] = 1595750129;
        this._stateLo[4] = 2917565137;
        this._stateLo[5] = 725511199;
        this._stateLo[6] = 4215389547;
        this._stateLo[7] = 327033209;
      };
      SHA5122.prototype.reset = function() {
        this._initState();
        this._bufferLength = 0;
        this._bytesHashed = 0;
        this._finished = false;
        return this;
      };
      SHA5122.prototype.clean = function() {
        wipe_12.wipe(this._buffer);
        wipe_12.wipe(this._tempHi);
        wipe_12.wipe(this._tempLo);
        this.reset();
      };
      SHA5122.prototype.update = function(data, dataLength) {
        if (dataLength === void 0) {
          dataLength = data.length;
        }
        if (this._finished) {
          throw new Error("SHA512: can't update because hash was finished.");
        }
        var dataPos = 0;
        this._bytesHashed += dataLength;
        if (this._bufferLength > 0) {
          while (this._bufferLength < exports.BLOCK_SIZE && dataLength > 0) {
            this._buffer[this._bufferLength++] = data[dataPos++];
            dataLength--;
          }
          if (this._bufferLength === this.blockSize) {
            hashBlocks(this._tempHi, this._tempLo, this._stateHi, this._stateLo, this._buffer, 0, this.blockSize);
            this._bufferLength = 0;
          }
        }
        if (dataLength >= this.blockSize) {
          dataPos = hashBlocks(this._tempHi, this._tempLo, this._stateHi, this._stateLo, data, dataPos, dataLength);
          dataLength %= this.blockSize;
        }
        while (dataLength > 0) {
          this._buffer[this._bufferLength++] = data[dataPos++];
          dataLength--;
        }
        return this;
      };
      SHA5122.prototype.finish = function(out) {
        if (!this._finished) {
          var bytesHashed = this._bytesHashed;
          var left = this._bufferLength;
          var bitLenHi = bytesHashed / 536870912 | 0;
          var bitLenLo = bytesHashed << 3;
          var padLength = bytesHashed % 128 < 112 ? 128 : 256;
          this._buffer[left] = 128;
          for (var i3 = left + 1; i3 < padLength - 8; i3++) {
            this._buffer[i3] = 0;
          }
          binary_12.writeUint32BE(bitLenHi, this._buffer, padLength - 8);
          binary_12.writeUint32BE(bitLenLo, this._buffer, padLength - 4);
          hashBlocks(this._tempHi, this._tempLo, this._stateHi, this._stateLo, this._buffer, 0, padLength);
          this._finished = true;
        }
        for (var i3 = 0; i3 < this.digestLength / 8; i3++) {
          binary_12.writeUint32BE(this._stateHi[i3], out, i3 * 8);
          binary_12.writeUint32BE(this._stateLo[i3], out, i3 * 8 + 4);
        }
        return this;
      };
      SHA5122.prototype.digest = function() {
        var out = new Uint8Array(this.digestLength);
        this.finish(out);
        return out;
      };
      SHA5122.prototype.saveState = function() {
        if (this._finished) {
          throw new Error("SHA256: cannot save finished state");
        }
        return {
          stateHi: new Int32Array(this._stateHi),
          stateLo: new Int32Array(this._stateLo),
          buffer: this._bufferLength > 0 ? new Uint8Array(this._buffer) : void 0,
          bufferLength: this._bufferLength,
          bytesHashed: this._bytesHashed
        };
      };
      SHA5122.prototype.restoreState = function(savedState) {
        this._stateHi.set(savedState.stateHi);
        this._stateLo.set(savedState.stateLo);
        this._bufferLength = savedState.bufferLength;
        if (savedState.buffer) {
          this._buffer.set(savedState.buffer);
        }
        this._bytesHashed = savedState.bytesHashed;
        this._finished = false;
        return this;
      };
      SHA5122.prototype.cleanSavedState = function(savedState) {
        wipe_12.wipe(savedState.stateHi);
        wipe_12.wipe(savedState.stateLo);
        if (savedState.buffer) {
          wipe_12.wipe(savedState.buffer);
        }
        savedState.bufferLength = 0;
        savedState.bytesHashed = 0;
      };
      return SHA5122;
    }()
  );
  exports.SHA512 = SHA512;
  var K3 = new Int32Array([
    1116352408,
    3609767458,
    1899447441,
    602891725,
    3049323471,
    3964484399,
    3921009573,
    2173295548,
    961987163,
    4081628472,
    1508970993,
    3053834265,
    2453635748,
    2937671579,
    2870763221,
    3664609560,
    3624381080,
    2734883394,
    310598401,
    1164996542,
    607225278,
    1323610764,
    1426881987,
    3590304994,
    1925078388,
    4068182383,
    2162078206,
    991336113,
    2614888103,
    633803317,
    3248222580,
    3479774868,
    3835390401,
    2666613458,
    4022224774,
    944711139,
    264347078,
    2341262773,
    604807628,
    2007800933,
    770255983,
    1495990901,
    1249150122,
    1856431235,
    1555081692,
    3175218132,
    1996064986,
    2198950837,
    2554220882,
    3999719339,
    2821834349,
    766784016,
    2952996808,
    2566594879,
    3210313671,
    3203337956,
    3336571891,
    1034457026,
    3584528711,
    2466948901,
    113926993,
    3758326383,
    338241895,
    168717936,
    666307205,
    1188179964,
    773529912,
    1546045734,
    1294757372,
    1522805485,
    1396182291,
    2643833823,
    1695183700,
    2343527390,
    1986661051,
    1014477480,
    2177026350,
    1206759142,
    2456956037,
    344077627,
    2730485921,
    1290863460,
    2820302411,
    3158454273,
    3259730800,
    3505952657,
    3345764771,
    106217008,
    3516065817,
    3606008344,
    3600352804,
    1432725776,
    4094571909,
    1467031594,
    275423344,
    851169720,
    430227734,
    3100823752,
    506948616,
    1363258195,
    659060556,
    3750685593,
    883997877,
    3785050280,
    958139571,
    3318307427,
    1322822218,
    3812723403,
    1537002063,
    2003034995,
    1747873779,
    3602036899,
    1955562222,
    1575990012,
    2024104815,
    1125592928,
    2227730452,
    2716904306,
    2361852424,
    442776044,
    2428436474,
    593698344,
    2756734187,
    3733110249,
    3204031479,
    2999351573,
    3329325298,
    3815920427,
    3391569614,
    3928383900,
    3515267271,
    566280711,
    3940187606,
    3454069534,
    4118630271,
    4000239992,
    116418474,
    1914138554,
    174292421,
    2731055270,
    289380356,
    3203993006,
    460393269,
    320620315,
    685471733,
    587496836,
    852142971,
    1086792851,
    1017036298,
    365543100,
    1126000580,
    2618297676,
    1288033470,
    3409855158,
    1501505948,
    4234509866,
    1607167915,
    987167468,
    1816402316,
    1246189591
  ]);
  function hashBlocks(wh, wl, hh, hl, m2, pos, len) {
    var ah0 = hh[0], ah1 = hh[1], ah2 = hh[2], ah3 = hh[3], ah4 = hh[4], ah5 = hh[5], ah6 = hh[6], ah7 = hh[7], al0 = hl[0], al1 = hl[1], al2 = hl[2], al3 = hl[3], al4 = hl[4], al5 = hl[5], al6 = hl[6], al7 = hl[7];
    var h4, l2;
    var th, tl;
    var a3, b2, c2, d4;
    while (len >= 128) {
      for (var i3 = 0; i3 < 16; i3++) {
        var j2 = 8 * i3 + pos;
        wh[i3] = binary_12.readUint32BE(m2, j2);
        wl[i3] = binary_12.readUint32BE(m2, j2 + 4);
      }
      for (var i3 = 0; i3 < 80; i3++) {
        var bh0 = ah0;
        var bh1 = ah1;
        var bh2 = ah2;
        var bh3 = ah3;
        var bh4 = ah4;
        var bh5 = ah5;
        var bh6 = ah6;
        var bh7 = ah7;
        var bl0 = al0;
        var bl1 = al1;
        var bl2 = al2;
        var bl3 = al3;
        var bl4 = al4;
        var bl5 = al5;
        var bl6 = al6;
        var bl7 = al7;
        h4 = ah7;
        l2 = al7;
        a3 = l2 & 65535;
        b2 = l2 >>> 16;
        c2 = h4 & 65535;
        d4 = h4 >>> 16;
        h4 = (ah4 >>> 14 | al4 << 32 - 14) ^ (ah4 >>> 18 | al4 << 32 - 18) ^ (al4 >>> 41 - 32 | ah4 << 32 - (41 - 32));
        l2 = (al4 >>> 14 | ah4 << 32 - 14) ^ (al4 >>> 18 | ah4 << 32 - 18) ^ (ah4 >>> 41 - 32 | al4 << 32 - (41 - 32));
        a3 += l2 & 65535;
        b2 += l2 >>> 16;
        c2 += h4 & 65535;
        d4 += h4 >>> 16;
        h4 = ah4 & ah5 ^ ~ah4 & ah6;
        l2 = al4 & al5 ^ ~al4 & al6;
        a3 += l2 & 65535;
        b2 += l2 >>> 16;
        c2 += h4 & 65535;
        d4 += h4 >>> 16;
        h4 = K3[i3 * 2];
        l2 = K3[i3 * 2 + 1];
        a3 += l2 & 65535;
        b2 += l2 >>> 16;
        c2 += h4 & 65535;
        d4 += h4 >>> 16;
        h4 = wh[i3 % 16];
        l2 = wl[i3 % 16];
        a3 += l2 & 65535;
        b2 += l2 >>> 16;
        c2 += h4 & 65535;
        d4 += h4 >>> 16;
        b2 += a3 >>> 16;
        c2 += b2 >>> 16;
        d4 += c2 >>> 16;
        th = c2 & 65535 | d4 << 16;
        tl = a3 & 65535 | b2 << 16;
        h4 = th;
        l2 = tl;
        a3 = l2 & 65535;
        b2 = l2 >>> 16;
        c2 = h4 & 65535;
        d4 = h4 >>> 16;
        h4 = (ah0 >>> 28 | al0 << 32 - 28) ^ (al0 >>> 34 - 32 | ah0 << 32 - (34 - 32)) ^ (al0 >>> 39 - 32 | ah0 << 32 - (39 - 32));
        l2 = (al0 >>> 28 | ah0 << 32 - 28) ^ (ah0 >>> 34 - 32 | al0 << 32 - (34 - 32)) ^ (ah0 >>> 39 - 32 | al0 << 32 - (39 - 32));
        a3 += l2 & 65535;
        b2 += l2 >>> 16;
        c2 += h4 & 65535;
        d4 += h4 >>> 16;
        h4 = ah0 & ah1 ^ ah0 & ah2 ^ ah1 & ah2;
        l2 = al0 & al1 ^ al0 & al2 ^ al1 & al2;
        a3 += l2 & 65535;
        b2 += l2 >>> 16;
        c2 += h4 & 65535;
        d4 += h4 >>> 16;
        b2 += a3 >>> 16;
        c2 += b2 >>> 16;
        d4 += c2 >>> 16;
        bh7 = c2 & 65535 | d4 << 16;
        bl7 = a3 & 65535 | b2 << 16;
        h4 = bh3;
        l2 = bl3;
        a3 = l2 & 65535;
        b2 = l2 >>> 16;
        c2 = h4 & 65535;
        d4 = h4 >>> 16;
        h4 = th;
        l2 = tl;
        a3 += l2 & 65535;
        b2 += l2 >>> 16;
        c2 += h4 & 65535;
        d4 += h4 >>> 16;
        b2 += a3 >>> 16;
        c2 += b2 >>> 16;
        d4 += c2 >>> 16;
        bh3 = c2 & 65535 | d4 << 16;
        bl3 = a3 & 65535 | b2 << 16;
        ah1 = bh0;
        ah2 = bh1;
        ah3 = bh2;
        ah4 = bh3;
        ah5 = bh4;
        ah6 = bh5;
        ah7 = bh6;
        ah0 = bh7;
        al1 = bl0;
        al2 = bl1;
        al3 = bl2;
        al4 = bl3;
        al5 = bl4;
        al6 = bl5;
        al7 = bl6;
        al0 = bl7;
        if (i3 % 16 === 15) {
          for (var j2 = 0; j2 < 16; j2++) {
            h4 = wh[j2];
            l2 = wl[j2];
            a3 = l2 & 65535;
            b2 = l2 >>> 16;
            c2 = h4 & 65535;
            d4 = h4 >>> 16;
            h4 = wh[(j2 + 9) % 16];
            l2 = wl[(j2 + 9) % 16];
            a3 += l2 & 65535;
            b2 += l2 >>> 16;
            c2 += h4 & 65535;
            d4 += h4 >>> 16;
            th = wh[(j2 + 1) % 16];
            tl = wl[(j2 + 1) % 16];
            h4 = (th >>> 1 | tl << 32 - 1) ^ (th >>> 8 | tl << 32 - 8) ^ th >>> 7;
            l2 = (tl >>> 1 | th << 32 - 1) ^ (tl >>> 8 | th << 32 - 8) ^ (tl >>> 7 | th << 32 - 7);
            a3 += l2 & 65535;
            b2 += l2 >>> 16;
            c2 += h4 & 65535;
            d4 += h4 >>> 16;
            th = wh[(j2 + 14) % 16];
            tl = wl[(j2 + 14) % 16];
            h4 = (th >>> 19 | tl << 32 - 19) ^ (tl >>> 61 - 32 | th << 32 - (61 - 32)) ^ th >>> 6;
            l2 = (tl >>> 19 | th << 32 - 19) ^ (th >>> 61 - 32 | tl << 32 - (61 - 32)) ^ (tl >>> 6 | th << 32 - 6);
            a3 += l2 & 65535;
            b2 += l2 >>> 16;
            c2 += h4 & 65535;
            d4 += h4 >>> 16;
            b2 += a3 >>> 16;
            c2 += b2 >>> 16;
            d4 += c2 >>> 16;
            wh[j2] = c2 & 65535 | d4 << 16;
            wl[j2] = a3 & 65535 | b2 << 16;
          }
        }
      }
      h4 = ah0;
      l2 = al0;
      a3 = l2 & 65535;
      b2 = l2 >>> 16;
      c2 = h4 & 65535;
      d4 = h4 >>> 16;
      h4 = hh[0];
      l2 = hl[0];
      a3 += l2 & 65535;
      b2 += l2 >>> 16;
      c2 += h4 & 65535;
      d4 += h4 >>> 16;
      b2 += a3 >>> 16;
      c2 += b2 >>> 16;
      d4 += c2 >>> 16;
      hh[0] = ah0 = c2 & 65535 | d4 << 16;
      hl[0] = al0 = a3 & 65535 | b2 << 16;
      h4 = ah1;
      l2 = al1;
      a3 = l2 & 65535;
      b2 = l2 >>> 16;
      c2 = h4 & 65535;
      d4 = h4 >>> 16;
      h4 = hh[1];
      l2 = hl[1];
      a3 += l2 & 65535;
      b2 += l2 >>> 16;
      c2 += h4 & 65535;
      d4 += h4 >>> 16;
      b2 += a3 >>> 16;
      c2 += b2 >>> 16;
      d4 += c2 >>> 16;
      hh[1] = ah1 = c2 & 65535 | d4 << 16;
      hl[1] = al1 = a3 & 65535 | b2 << 16;
      h4 = ah2;
      l2 = al2;
      a3 = l2 & 65535;
      b2 = l2 >>> 16;
      c2 = h4 & 65535;
      d4 = h4 >>> 16;
      h4 = hh[2];
      l2 = hl[2];
      a3 += l2 & 65535;
      b2 += l2 >>> 16;
      c2 += h4 & 65535;
      d4 += h4 >>> 16;
      b2 += a3 >>> 16;
      c2 += b2 >>> 16;
      d4 += c2 >>> 16;
      hh[2] = ah2 = c2 & 65535 | d4 << 16;
      hl[2] = al2 = a3 & 65535 | b2 << 16;
      h4 = ah3;
      l2 = al3;
      a3 = l2 & 65535;
      b2 = l2 >>> 16;
      c2 = h4 & 65535;
      d4 = h4 >>> 16;
      h4 = hh[3];
      l2 = hl[3];
      a3 += l2 & 65535;
      b2 += l2 >>> 16;
      c2 += h4 & 65535;
      d4 += h4 >>> 16;
      b2 += a3 >>> 16;
      c2 += b2 >>> 16;
      d4 += c2 >>> 16;
      hh[3] = ah3 = c2 & 65535 | d4 << 16;
      hl[3] = al3 = a3 & 65535 | b2 << 16;
      h4 = ah4;
      l2 = al4;
      a3 = l2 & 65535;
      b2 = l2 >>> 16;
      c2 = h4 & 65535;
      d4 = h4 >>> 16;
      h4 = hh[4];
      l2 = hl[4];
      a3 += l2 & 65535;
      b2 += l2 >>> 16;
      c2 += h4 & 65535;
      d4 += h4 >>> 16;
      b2 += a3 >>> 16;
      c2 += b2 >>> 16;
      d4 += c2 >>> 16;
      hh[4] = ah4 = c2 & 65535 | d4 << 16;
      hl[4] = al4 = a3 & 65535 | b2 << 16;
      h4 = ah5;
      l2 = al5;
      a3 = l2 & 65535;
      b2 = l2 >>> 16;
      c2 = h4 & 65535;
      d4 = h4 >>> 16;
      h4 = hh[5];
      l2 = hl[5];
      a3 += l2 & 65535;
      b2 += l2 >>> 16;
      c2 += h4 & 65535;
      d4 += h4 >>> 16;
      b2 += a3 >>> 16;
      c2 += b2 >>> 16;
      d4 += c2 >>> 16;
      hh[5] = ah5 = c2 & 65535 | d4 << 16;
      hl[5] = al5 = a3 & 65535 | b2 << 16;
      h4 = ah6;
      l2 = al6;
      a3 = l2 & 65535;
      b2 = l2 >>> 16;
      c2 = h4 & 65535;
      d4 = h4 >>> 16;
      h4 = hh[6];
      l2 = hl[6];
      a3 += l2 & 65535;
      b2 += l2 >>> 16;
      c2 += h4 & 65535;
      d4 += h4 >>> 16;
      b2 += a3 >>> 16;
      c2 += b2 >>> 16;
      d4 += c2 >>> 16;
      hh[6] = ah6 = c2 & 65535 | d4 << 16;
      hl[6] = al6 = a3 & 65535 | b2 << 16;
      h4 = ah7;
      l2 = al7;
      a3 = l2 & 65535;
      b2 = l2 >>> 16;
      c2 = h4 & 65535;
      d4 = h4 >>> 16;
      h4 = hh[7];
      l2 = hl[7];
      a3 += l2 & 65535;
      b2 += l2 >>> 16;
      c2 += h4 & 65535;
      d4 += h4 >>> 16;
      b2 += a3 >>> 16;
      c2 += b2 >>> 16;
      d4 += c2 >>> 16;
      hh[7] = ah7 = c2 & 65535 | d4 << 16;
      hl[7] = al7 = a3 & 65535 | b2 << 16;
      pos += 128;
      len -= 128;
    }
    return pos;
  }
  function hash3(data) {
    var h4 = new SHA512();
    h4.update(data);
    var digest = h4.digest();
    h4.clean();
    return digest;
  }
  exports.hash = hash3;
})(sha512);
(function(exports) {
  Object.defineProperty(exports, "__esModule", { value: true });
  exports.convertSecretKeyToX25519 = exports.convertPublicKeyToX25519 = exports.verify = exports.sign = exports.extractPublicKeyFromSecretKey = exports.generateKeyPair = exports.generateKeyPairFromSeed = exports.SEED_LENGTH = exports.SECRET_KEY_LENGTH = exports.PUBLIC_KEY_LENGTH = exports.SIGNATURE_LENGTH = void 0;
  const random_1 = random;
  const sha512_1 = sha512;
  const wipe_12 = wipe$9;
  exports.SIGNATURE_LENGTH = 64;
  exports.PUBLIC_KEY_LENGTH = 32;
  exports.SECRET_KEY_LENGTH = 64;
  exports.SEED_LENGTH = 32;
  function gf(init2) {
    const r2 = new Float64Array(16);
    if (init2) {
      for (let i3 = 0; i3 < init2.length; i3++) {
        r2[i3] = init2[i3];
      }
    }
    return r2;
  }
  const _9 = new Uint8Array(32);
  _9[0] = 9;
  const gf0 = gf();
  const gf1 = gf([1]);
  const D2 = gf([
    30883,
    4953,
    19914,
    30187,
    55467,
    16705,
    2637,
    112,
    59544,
    30585,
    16505,
    36039,
    65139,
    11119,
    27886,
    20995
  ]);
  const D22 = gf([
    61785,
    9906,
    39828,
    60374,
    45398,
    33411,
    5274,
    224,
    53552,
    61171,
    33010,
    6542,
    64743,
    22239,
    55772,
    9222
  ]);
  const X2 = gf([
    54554,
    36645,
    11616,
    51542,
    42930,
    38181,
    51040,
    26924,
    56412,
    64982,
    57905,
    49316,
    21502,
    52590,
    14035,
    8553
  ]);
  const Y2 = gf([
    26200,
    26214,
    26214,
    26214,
    26214,
    26214,
    26214,
    26214,
    26214,
    26214,
    26214,
    26214,
    26214,
    26214,
    26214,
    26214
  ]);
  const I2 = gf([
    41136,
    18958,
    6951,
    50414,
    58488,
    44335,
    6150,
    12099,
    55207,
    15867,
    153,
    11085,
    57099,
    20417,
    9344,
    11139
  ]);
  function set25519(r2, a3) {
    for (let i3 = 0; i3 < 16; i3++) {
      r2[i3] = a3[i3] | 0;
    }
  }
  function car25519(o3) {
    let c2 = 1;
    for (let i3 = 0; i3 < 16; i3++) {
      let v3 = o3[i3] + c2 + 65535;
      c2 = Math.floor(v3 / 65536);
      o3[i3] = v3 - c2 * 65536;
    }
    o3[0] += c2 - 1 + 37 * (c2 - 1);
  }
  function sel25519(p3, q2, b2) {
    const c2 = ~(b2 - 1);
    for (let i3 = 0; i3 < 16; i3++) {
      const t = c2 & (p3[i3] ^ q2[i3]);
      p3[i3] ^= t;
      q2[i3] ^= t;
    }
  }
  function pack25519(o3, n4) {
    const m2 = gf();
    const t = gf();
    for (let i3 = 0; i3 < 16; i3++) {
      t[i3] = n4[i3];
    }
    car25519(t);
    car25519(t);
    car25519(t);
    for (let j2 = 0; j2 < 2; j2++) {
      m2[0] = t[0] - 65517;
      for (let i3 = 1; i3 < 15; i3++) {
        m2[i3] = t[i3] - 65535 - (m2[i3 - 1] >> 16 & 1);
        m2[i3 - 1] &= 65535;
      }
      m2[15] = t[15] - 32767 - (m2[14] >> 16 & 1);
      const b2 = m2[15] >> 16 & 1;
      m2[14] &= 65535;
      sel25519(t, m2, 1 - b2);
    }
    for (let i3 = 0; i3 < 16; i3++) {
      o3[2 * i3] = t[i3] & 255;
      o3[2 * i3 + 1] = t[i3] >> 8;
    }
  }
  function verify32(x3, y3) {
    let d4 = 0;
    for (let i3 = 0; i3 < 32; i3++) {
      d4 |= x3[i3] ^ y3[i3];
    }
    return (1 & d4 - 1 >>> 8) - 1;
  }
  function neq25519(a3, b2) {
    const c2 = new Uint8Array(32);
    const d4 = new Uint8Array(32);
    pack25519(c2, a3);
    pack25519(d4, b2);
    return verify32(c2, d4);
  }
  function par25519(a3) {
    const d4 = new Uint8Array(32);
    pack25519(d4, a3);
    return d4[0] & 1;
  }
  function unpack25519(o3, n4) {
    for (let i3 = 0; i3 < 16; i3++) {
      o3[i3] = n4[2 * i3] + (n4[2 * i3 + 1] << 8);
    }
    o3[15] &= 32767;
  }
  function add7(o3, a3, b2) {
    for (let i3 = 0; i3 < 16; i3++) {
      o3[i3] = a3[i3] + b2[i3];
    }
  }
  function sub(o3, a3, b2) {
    for (let i3 = 0; i3 < 16; i3++) {
      o3[i3] = a3[i3] - b2[i3];
    }
  }
  function mul7(o3, a3, b2) {
    let v3, c2, t0 = 0, t1 = 0, t2 = 0, t3 = 0, t4 = 0, t5 = 0, t6 = 0, t7 = 0, t8 = 0, t9 = 0, t10 = 0, t11 = 0, t12 = 0, t13 = 0, t14 = 0, t15 = 0, t16 = 0, t17 = 0, t18 = 0, t19 = 0, t20 = 0, t21 = 0, t22 = 0, t23 = 0, t24 = 0, t25 = 0, t26 = 0, t27 = 0, t28 = 0, t29 = 0, t30 = 0, b0 = b2[0], b1 = b2[1], b22 = b2[2], b3 = b2[3], b4 = b2[4], b5 = b2[5], b6 = b2[6], b7 = b2[7], b8 = b2[8], b9 = b2[9], b10 = b2[10], b11 = b2[11], b12 = b2[12], b13 = b2[13], b14 = b2[14], b15 = b2[15];
    v3 = a3[0];
    t0 += v3 * b0;
    t1 += v3 * b1;
    t2 += v3 * b22;
    t3 += v3 * b3;
    t4 += v3 * b4;
    t5 += v3 * b5;
    t6 += v3 * b6;
    t7 += v3 * b7;
    t8 += v3 * b8;
    t9 += v3 * b9;
    t10 += v3 * b10;
    t11 += v3 * b11;
    t12 += v3 * b12;
    t13 += v3 * b13;
    t14 += v3 * b14;
    t15 += v3 * b15;
    v3 = a3[1];
    t1 += v3 * b0;
    t2 += v3 * b1;
    t3 += v3 * b22;
    t4 += v3 * b3;
    t5 += v3 * b4;
    t6 += v3 * b5;
    t7 += v3 * b6;
    t8 += v3 * b7;
    t9 += v3 * b8;
    t10 += v3 * b9;
    t11 += v3 * b10;
    t12 += v3 * b11;
    t13 += v3 * b12;
    t14 += v3 * b13;
    t15 += v3 * b14;
    t16 += v3 * b15;
    v3 = a3[2];
    t2 += v3 * b0;
    t3 += v3 * b1;
    t4 += v3 * b22;
    t5 += v3 * b3;
    t6 += v3 * b4;
    t7 += v3 * b5;
    t8 += v3 * b6;
    t9 += v3 * b7;
    t10 += v3 * b8;
    t11 += v3 * b9;
    t12 += v3 * b10;
    t13 += v3 * b11;
    t14 += v3 * b12;
    t15 += v3 * b13;
    t16 += v3 * b14;
    t17 += v3 * b15;
    v3 = a3[3];
    t3 += v3 * b0;
    t4 += v3 * b1;
    t5 += v3 * b22;
    t6 += v3 * b3;
    t7 += v3 * b4;
    t8 += v3 * b5;
    t9 += v3 * b6;
    t10 += v3 * b7;
    t11 += v3 * b8;
    t12 += v3 * b9;
    t13 += v3 * b10;
    t14 += v3 * b11;
    t15 += v3 * b12;
    t16 += v3 * b13;
    t17 += v3 * b14;
    t18 += v3 * b15;
    v3 = a3[4];
    t4 += v3 * b0;
    t5 += v3 * b1;
    t6 += v3 * b22;
    t7 += v3 * b3;
    t8 += v3 * b4;
    t9 += v3 * b5;
    t10 += v3 * b6;
    t11 += v3 * b7;
    t12 += v3 * b8;
    t13 += v3 * b9;
    t14 += v3 * b10;
    t15 += v3 * b11;
    t16 += v3 * b12;
    t17 += v3 * b13;
    t18 += v3 * b14;
    t19 += v3 * b15;
    v3 = a3[5];
    t5 += v3 * b0;
    t6 += v3 * b1;
    t7 += v3 * b22;
    t8 += v3 * b3;
    t9 += v3 * b4;
    t10 += v3 * b5;
    t11 += v3 * b6;
    t12 += v3 * b7;
    t13 += v3 * b8;
    t14 += v3 * b9;
    t15 += v3 * b10;
    t16 += v3 * b11;
    t17 += v3 * b12;
    t18 += v3 * b13;
    t19 += v3 * b14;
    t20 += v3 * b15;
    v3 = a3[6];
    t6 += v3 * b0;
    t7 += v3 * b1;
    t8 += v3 * b22;
    t9 += v3 * b3;
    t10 += v3 * b4;
    t11 += v3 * b5;
    t12 += v3 * b6;
    t13 += v3 * b7;
    t14 += v3 * b8;
    t15 += v3 * b9;
    t16 += v3 * b10;
    t17 += v3 * b11;
    t18 += v3 * b12;
    t19 += v3 * b13;
    t20 += v3 * b14;
    t21 += v3 * b15;
    v3 = a3[7];
    t7 += v3 * b0;
    t8 += v3 * b1;
    t9 += v3 * b22;
    t10 += v3 * b3;
    t11 += v3 * b4;
    t12 += v3 * b5;
    t13 += v3 * b6;
    t14 += v3 * b7;
    t15 += v3 * b8;
    t16 += v3 * b9;
    t17 += v3 * b10;
    t18 += v3 * b11;
    t19 += v3 * b12;
    t20 += v3 * b13;
    t21 += v3 * b14;
    t22 += v3 * b15;
    v3 = a3[8];
    t8 += v3 * b0;
    t9 += v3 * b1;
    t10 += v3 * b22;
    t11 += v3 * b3;
    t12 += v3 * b4;
    t13 += v3 * b5;
    t14 += v3 * b6;
    t15 += v3 * b7;
    t16 += v3 * b8;
    t17 += v3 * b9;
    t18 += v3 * b10;
    t19 += v3 * b11;
    t20 += v3 * b12;
    t21 += v3 * b13;
    t22 += v3 * b14;
    t23 += v3 * b15;
    v3 = a3[9];
    t9 += v3 * b0;
    t10 += v3 * b1;
    t11 += v3 * b22;
    t12 += v3 * b3;
    t13 += v3 * b4;
    t14 += v3 * b5;
    t15 += v3 * b6;
    t16 += v3 * b7;
    t17 += v3 * b8;
    t18 += v3 * b9;
    t19 += v3 * b10;
    t20 += v3 * b11;
    t21 += v3 * b12;
    t22 += v3 * b13;
    t23 += v3 * b14;
    t24 += v3 * b15;
    v3 = a3[10];
    t10 += v3 * b0;
    t11 += v3 * b1;
    t12 += v3 * b22;
    t13 += v3 * b3;
    t14 += v3 * b4;
    t15 += v3 * b5;
    t16 += v3 * b6;
    t17 += v3 * b7;
    t18 += v3 * b8;
    t19 += v3 * b9;
    t20 += v3 * b10;
    t21 += v3 * b11;
    t22 += v3 * b12;
    t23 += v3 * b13;
    t24 += v3 * b14;
    t25 += v3 * b15;
    v3 = a3[11];
    t11 += v3 * b0;
    t12 += v3 * b1;
    t13 += v3 * b22;
    t14 += v3 * b3;
    t15 += v3 * b4;
    t16 += v3 * b5;
    t17 += v3 * b6;
    t18 += v3 * b7;
    t19 += v3 * b8;
    t20 += v3 * b9;
    t21 += v3 * b10;
    t22 += v3 * b11;
    t23 += v3 * b12;
    t24 += v3 * b13;
    t25 += v3 * b14;
    t26 += v3 * b15;
    v3 = a3[12];
    t12 += v3 * b0;
    t13 += v3 * b1;
    t14 += v3 * b22;
    t15 += v3 * b3;
    t16 += v3 * b4;
    t17 += v3 * b5;
    t18 += v3 * b6;
    t19 += v3 * b7;
    t20 += v3 * b8;
    t21 += v3 * b9;
    t22 += v3 * b10;
    t23 += v3 * b11;
    t24 += v3 * b12;
    t25 += v3 * b13;
    t26 += v3 * b14;
    t27 += v3 * b15;
    v3 = a3[13];
    t13 += v3 * b0;
    t14 += v3 * b1;
    t15 += v3 * b22;
    t16 += v3 * b3;
    t17 += v3 * b4;
    t18 += v3 * b5;
    t19 += v3 * b6;
    t20 += v3 * b7;
    t21 += v3 * b8;
    t22 += v3 * b9;
    t23 += v3 * b10;
    t24 += v3 * b11;
    t25 += v3 * b12;
    t26 += v3 * b13;
    t27 += v3 * b14;
    t28 += v3 * b15;
    v3 = a3[14];
    t14 += v3 * b0;
    t15 += v3 * b1;
    t16 += v3 * b22;
    t17 += v3 * b3;
    t18 += v3 * b4;
    t19 += v3 * b5;
    t20 += v3 * b6;
    t21 += v3 * b7;
    t22 += v3 * b8;
    t23 += v3 * b9;
    t24 += v3 * b10;
    t25 += v3 * b11;
    t26 += v3 * b12;
    t27 += v3 * b13;
    t28 += v3 * b14;
    t29 += v3 * b15;
    v3 = a3[15];
    t15 += v3 * b0;
    t16 += v3 * b1;
    t17 += v3 * b22;
    t18 += v3 * b3;
    t19 += v3 * b4;
    t20 += v3 * b5;
    t21 += v3 * b6;
    t22 += v3 * b7;
    t23 += v3 * b8;
    t24 += v3 * b9;
    t25 += v3 * b10;
    t26 += v3 * b11;
    t27 += v3 * b12;
    t28 += v3 * b13;
    t29 += v3 * b14;
    t30 += v3 * b15;
    t0 += 38 * t16;
    t1 += 38 * t17;
    t2 += 38 * t18;
    t3 += 38 * t19;
    t4 += 38 * t20;
    t5 += 38 * t21;
    t6 += 38 * t22;
    t7 += 38 * t23;
    t8 += 38 * t24;
    t9 += 38 * t25;
    t10 += 38 * t26;
    t11 += 38 * t27;
    t12 += 38 * t28;
    t13 += 38 * t29;
    t14 += 38 * t30;
    c2 = 1;
    v3 = t0 + c2 + 65535;
    c2 = Math.floor(v3 / 65536);
    t0 = v3 - c2 * 65536;
    v3 = t1 + c2 + 65535;
    c2 = Math.floor(v3 / 65536);
    t1 = v3 - c2 * 65536;
    v3 = t2 + c2 + 65535;
    c2 = Math.floor(v3 / 65536);
    t2 = v3 - c2 * 65536;
    v3 = t3 + c2 + 65535;
    c2 = Math.floor(v3 / 65536);
    t3 = v3 - c2 * 65536;
    v3 = t4 + c2 + 65535;
    c2 = Math.floor(v3 / 65536);
    t4 = v3 - c2 * 65536;
    v3 = t5 + c2 + 65535;
    c2 = Math.floor(v3 / 65536);
    t5 = v3 - c2 * 65536;
    v3 = t6 + c2 + 65535;
    c2 = Math.floor(v3 / 65536);
    t6 = v3 - c2 * 65536;
    v3 = t7 + c2 + 65535;
    c2 = Math.floor(v3 / 65536);
    t7 = v3 - c2 * 65536;
    v3 = t8 + c2 + 65535;
    c2 = Math.floor(v3 / 65536);
    t8 = v3 - c2 * 65536;
    v3 = t9 + c2 + 65535;
    c2 = Math.floor(v3 / 65536);
    t9 = v3 - c2 * 65536;
    v3 = t10 + c2 + 65535;
    c2 = Math.floor(v3 / 65536);
    t10 = v3 - c2 * 65536;
    v3 = t11 + c2 + 65535;
    c2 = Math.floor(v3 / 65536);
    t11 = v3 - c2 * 65536;
    v3 = t12 + c2 + 65535;
    c2 = Math.floor(v3 / 65536);
    t12 = v3 - c2 * 65536;
    v3 = t13 + c2 + 65535;
    c2 = Math.floor(v3 / 65536);
    t13 = v3 - c2 * 65536;
    v3 = t14 + c2 + 65535;
    c2 = Math.floor(v3 / 65536);
    t14 = v3 - c2 * 65536;
    v3 = t15 + c2 + 65535;
    c2 = Math.floor(v3 / 65536);
    t15 = v3 - c2 * 65536;
    t0 += c2 - 1 + 37 * (c2 - 1);
    c2 = 1;
    v3 = t0 + c2 + 65535;
    c2 = Math.floor(v3 / 65536);
    t0 = v3 - c2 * 65536;
    v3 = t1 + c2 + 65535;
    c2 = Math.floor(v3 / 65536);
    t1 = v3 - c2 * 65536;
    v3 = t2 + c2 + 65535;
    c2 = Math.floor(v3 / 65536);
    t2 = v3 - c2 * 65536;
    v3 = t3 + c2 + 65535;
    c2 = Math.floor(v3 / 65536);
    t3 = v3 - c2 * 65536;
    v3 = t4 + c2 + 65535;
    c2 = Math.floor(v3 / 65536);
    t4 = v3 - c2 * 65536;
    v3 = t5 + c2 + 65535;
    c2 = Math.floor(v3 / 65536);
    t5 = v3 - c2 * 65536;
    v3 = t6 + c2 + 65535;
    c2 = Math.floor(v3 / 65536);
    t6 = v3 - c2 * 65536;
    v3 = t7 + c2 + 65535;
    c2 = Math.floor(v3 / 65536);
    t7 = v3 - c2 * 65536;
    v3 = t8 + c2 + 65535;
    c2 = Math.floor(v3 / 65536);
    t8 = v3 - c2 * 65536;
    v3 = t9 + c2 + 65535;
    c2 = Math.floor(v3 / 65536);
    t9 = v3 - c2 * 65536;
    v3 = t10 + c2 + 65535;
    c2 = Math.floor(v3 / 65536);
    t10 = v3 - c2 * 65536;
    v3 = t11 + c2 + 65535;
    c2 = Math.floor(v3 / 65536);
    t11 = v3 - c2 * 65536;
    v3 = t12 + c2 + 65535;
    c2 = Math.floor(v3 / 65536);
    t12 = v3 - c2 * 65536;
    v3 = t13 + c2 + 65535;
    c2 = Math.floor(v3 / 65536);
    t13 = v3 - c2 * 65536;
    v3 = t14 + c2 + 65535;
    c2 = Math.floor(v3 / 65536);
    t14 = v3 - c2 * 65536;
    v3 = t15 + c2 + 65535;
    c2 = Math.floor(v3 / 65536);
    t15 = v3 - c2 * 65536;
    t0 += c2 - 1 + 37 * (c2 - 1);
    o3[0] = t0;
    o3[1] = t1;
    o3[2] = t2;
    o3[3] = t3;
    o3[4] = t4;
    o3[5] = t5;
    o3[6] = t6;
    o3[7] = t7;
    o3[8] = t8;
    o3[9] = t9;
    o3[10] = t10;
    o3[11] = t11;
    o3[12] = t12;
    o3[13] = t13;
    o3[14] = t14;
    o3[15] = t15;
  }
  function square(o3, a3) {
    mul7(o3, a3, a3);
  }
  function inv25519(o3, i3) {
    const c2 = gf();
    let a3;
    for (a3 = 0; a3 < 16; a3++) {
      c2[a3] = i3[a3];
    }
    for (a3 = 253; a3 >= 0; a3--) {
      square(c2, c2);
      if (a3 !== 2 && a3 !== 4) {
        mul7(c2, c2, i3);
      }
    }
    for (a3 = 0; a3 < 16; a3++) {
      o3[a3] = c2[a3];
    }
  }
  function pow2523(o3, i3) {
    const c2 = gf();
    let a3;
    for (a3 = 0; a3 < 16; a3++) {
      c2[a3] = i3[a3];
    }
    for (a3 = 250; a3 >= 0; a3--) {
      square(c2, c2);
      if (a3 !== 1) {
        mul7(c2, c2, i3);
      }
    }
    for (a3 = 0; a3 < 16; a3++) {
      o3[a3] = c2[a3];
    }
  }
  function edadd(p3, q2) {
    const a3 = gf(), b2 = gf(), c2 = gf(), d4 = gf(), e2 = gf(), f3 = gf(), g3 = gf(), h4 = gf(), t = gf();
    sub(a3, p3[1], p3[0]);
    sub(t, q2[1], q2[0]);
    mul7(a3, a3, t);
    add7(b2, p3[0], p3[1]);
    add7(t, q2[0], q2[1]);
    mul7(b2, b2, t);
    mul7(c2, p3[3], q2[3]);
    mul7(c2, c2, D22);
    mul7(d4, p3[2], q2[2]);
    add7(d4, d4, d4);
    sub(e2, b2, a3);
    sub(f3, d4, c2);
    add7(g3, d4, c2);
    add7(h4, b2, a3);
    mul7(p3[0], e2, f3);
    mul7(p3[1], h4, g3);
    mul7(p3[2], g3, f3);
    mul7(p3[3], e2, h4);
  }
  function cswap(p3, q2, b2) {
    for (let i3 = 0; i3 < 4; i3++) {
      sel25519(p3[i3], q2[i3], b2);
    }
  }
  function pack(r2, p3) {
    const tx = gf(), ty = gf(), zi = gf();
    inv25519(zi, p3[2]);
    mul7(tx, p3[0], zi);
    mul7(ty, p3[1], zi);
    pack25519(r2, ty);
    r2[31] ^= par25519(tx) << 7;
  }
  function scalarmult(p3, q2, s2) {
    set25519(p3[0], gf0);
    set25519(p3[1], gf1);
    set25519(p3[2], gf1);
    set25519(p3[3], gf0);
    for (let i3 = 255; i3 >= 0; --i3) {
      const b2 = s2[i3 / 8 | 0] >> (i3 & 7) & 1;
      cswap(p3, q2, b2);
      edadd(q2, p3);
      edadd(p3, p3);
      cswap(p3, q2, b2);
    }
  }
  function scalarbase(p3, s2) {
    const q2 = [gf(), gf(), gf(), gf()];
    set25519(q2[0], X2);
    set25519(q2[1], Y2);
    set25519(q2[2], gf1);
    mul7(q2[3], X2, Y2);
    scalarmult(p3, q2, s2);
  }
  function generateKeyPairFromSeed(seed) {
    if (seed.length !== exports.SEED_LENGTH) {
      throw new Error(`ed25519: seed must be ${exports.SEED_LENGTH} bytes`);
    }
    const d4 = (0, sha512_1.hash)(seed);
    d4[0] &= 248;
    d4[31] &= 127;
    d4[31] |= 64;
    const publicKey = new Uint8Array(32);
    const p3 = [gf(), gf(), gf(), gf()];
    scalarbase(p3, d4);
    pack(publicKey, p3);
    const secretKey = new Uint8Array(64);
    secretKey.set(seed);
    secretKey.set(publicKey, 32);
    return {
      publicKey,
      secretKey
    };
  }
  exports.generateKeyPairFromSeed = generateKeyPairFromSeed;
  function generateKeyPair2(prng) {
    const seed = (0, random_1.randomBytes)(32, prng);
    const result = generateKeyPairFromSeed(seed);
    (0, wipe_12.wipe)(seed);
    return result;
  }
  exports.generateKeyPair = generateKeyPair2;
  function extractPublicKeyFromSecretKey(secretKey) {
    if (secretKey.length !== exports.SECRET_KEY_LENGTH) {
      throw new Error(`ed25519: secret key must be ${exports.SECRET_KEY_LENGTH} bytes`);
    }
    return new Uint8Array(secretKey.subarray(32));
  }
  exports.extractPublicKeyFromSecretKey = extractPublicKeyFromSecretKey;
  const L3 = new Float64Array([
    237,
    211,
    245,
    92,
    26,
    99,
    18,
    88,
    214,
    156,
    247,
    162,
    222,
    249,
    222,
    20,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    16
  ]);
  function modL(r2, x3) {
    let carry;
    let i3;
    let j2;
    let k2;
    for (i3 = 63; i3 >= 32; --i3) {
      carry = 0;
      for (j2 = i3 - 32, k2 = i3 - 12; j2 < k2; ++j2) {
        x3[j2] += carry - 16 * x3[i3] * L3[j2 - (i3 - 32)];
        carry = Math.floor((x3[j2] + 128) / 256);
        x3[j2] -= carry * 256;
      }
      x3[j2] += carry;
      x3[i3] = 0;
    }
    carry = 0;
    for (j2 = 0; j2 < 32; j2++) {
      x3[j2] += carry - (x3[31] >> 4) * L3[j2];
      carry = x3[j2] >> 8;
      x3[j2] &= 255;
    }
    for (j2 = 0; j2 < 32; j2++) {
      x3[j2] -= carry * L3[j2];
    }
    for (i3 = 0; i3 < 32; i3++) {
      x3[i3 + 1] += x3[i3] >> 8;
      r2[i3] = x3[i3] & 255;
    }
  }
  function reduce(r2) {
    const x3 = new Float64Array(64);
    for (let i3 = 0; i3 < 64; i3++) {
      x3[i3] = r2[i3];
    }
    for (let i3 = 0; i3 < 64; i3++) {
      r2[i3] = 0;
    }
    modL(r2, x3);
  }
  function sign7(secretKey, message) {
    const x3 = new Float64Array(64);
    const p3 = [gf(), gf(), gf(), gf()];
    const d4 = (0, sha512_1.hash)(secretKey.subarray(0, 32));
    d4[0] &= 248;
    d4[31] &= 127;
    d4[31] |= 64;
    const signature2 = new Uint8Array(64);
    signature2.set(d4.subarray(32), 32);
    const hs = new sha512_1.SHA512();
    hs.update(signature2.subarray(32));
    hs.update(message);
    const r2 = hs.digest();
    hs.clean();
    reduce(r2);
    scalarbase(p3, r2);
    pack(signature2, p3);
    hs.reset();
    hs.update(signature2.subarray(0, 32));
    hs.update(secretKey.subarray(32));
    hs.update(message);
    const h4 = hs.digest();
    reduce(h4);
    for (let i3 = 0; i3 < 32; i3++) {
      x3[i3] = r2[i3];
    }
    for (let i3 = 0; i3 < 32; i3++) {
      for (let j2 = 0; j2 < 32; j2++) {
        x3[i3 + j2] += h4[i3] * d4[j2];
      }
    }
    modL(signature2.subarray(32), x3);
    return signature2;
  }
  exports.sign = sign7;
  function unpackneg(r2, p3) {
    const t = gf(), chk = gf(), num = gf(), den = gf(), den2 = gf(), den4 = gf(), den6 = gf();
    set25519(r2[2], gf1);
    unpack25519(r2[1], p3);
    square(num, r2[1]);
    mul7(den, num, D2);
    sub(num, num, r2[2]);
    add7(den, r2[2], den);
    square(den2, den);
    square(den4, den2);
    mul7(den6, den4, den2);
    mul7(t, den6, num);
    mul7(t, t, den);
    pow2523(t, t);
    mul7(t, t, num);
    mul7(t, t, den);
    mul7(t, t, den);
    mul7(r2[0], t, den);
    square(chk, r2[0]);
    mul7(chk, chk, den);
    if (neq25519(chk, num)) {
      mul7(r2[0], r2[0], I2);
    }
    square(chk, r2[0]);
    mul7(chk, chk, den);
    if (neq25519(chk, num)) {
      return -1;
    }
    if (par25519(r2[0]) === p3[31] >> 7) {
      sub(r2[0], gf0, r2[0]);
    }
    mul7(r2[3], r2[0], r2[1]);
    return 0;
  }
  function verify7(publicKey, message, signature2) {
    const t = new Uint8Array(32);
    const p3 = [gf(), gf(), gf(), gf()];
    const q2 = [gf(), gf(), gf(), gf()];
    if (signature2.length !== exports.SIGNATURE_LENGTH) {
      throw new Error(`ed25519: signature must be ${exports.SIGNATURE_LENGTH} bytes`);
    }
    if (unpackneg(q2, publicKey)) {
      return false;
    }
    const hs = new sha512_1.SHA512();
    hs.update(signature2.subarray(0, 32));
    hs.update(publicKey);
    hs.update(message);
    const h4 = hs.digest();
    reduce(h4);
    scalarmult(p3, q2, h4);
    scalarbase(q2, signature2.subarray(32));
    edadd(p3, q2);
    pack(t, p3);
    if (verify32(signature2, t)) {
      return false;
    }
    return true;
  }
  exports.verify = verify7;
  function convertPublicKeyToX25519(publicKey) {
    let q2 = [gf(), gf(), gf(), gf()];
    if (unpackneg(q2, publicKey)) {
      throw new Error("Ed25519: invalid public key");
    }
    let a3 = gf();
    let b2 = gf();
    let y3 = q2[1];
    add7(a3, gf1, y3);
    sub(b2, gf1, y3);
    inv25519(b2, b2);
    mul7(a3, a3, b2);
    let z2 = new Uint8Array(32);
    pack25519(z2, a3);
    return z2;
  }
  exports.convertPublicKeyToX25519 = convertPublicKeyToX25519;
  function convertSecretKeyToX25519(secretKey) {
    const d4 = (0, sha512_1.hash)(secretKey.subarray(0, 32));
    d4[0] &= 248;
    d4[31] &= 127;
    d4[31] |= 64;
    const o3 = new Uint8Array(d4.subarray(0, 32));
    (0, wipe_12.wipe)(d4);
    return o3;
  }
  exports.convertSecretKeyToX25519 = convertSecretKeyToX25519;
})(ed25519);
const JWT_IRIDIUM_ALG = "EdDSA";
const JWT_IRIDIUM_TYP = "JWT";
const JWT_DELIMITER = ".";
const JWT_ENCODING = "base64url";
const JSON_ENCODING = "utf8";
const DATA_ENCODING = "utf8";
const DID_DELIMITER = ":";
const DID_PREFIX = "did";
const DID_METHOD = "key";
const MULTICODEC_ED25519_ENCODING = "base58btc";
const MULTICODEC_ED25519_BASE = "z";
const MULTICODEC_ED25519_HEADER = "K36";
const KEY_PAIR_SEED_LENGTH = 32;
function allocUnsafe(size = 0) {
  if (globalThis.Buffer != null && globalThis.Buffer.allocUnsafe != null) {
    return globalThis.Buffer.allocUnsafe(size);
  }
  return new Uint8Array(size);
}
function concat$1(arrays, length) {
  if (!length) {
    length = arrays.reduce((acc, curr) => acc + curr.length, 0);
  }
  const output = allocUnsafe(length);
  let offset = 0;
  for (const arr of arrays) {
    output.set(arr, offset);
    offset += arr.length;
  }
  return output;
}
function base$2(ALPHABET, name2) {
  if (ALPHABET.length >= 255) {
    throw new TypeError("Alphabet too long");
  }
  var BASE_MAP = new Uint8Array(256);
  for (var j2 = 0; j2 < BASE_MAP.length; j2++) {
    BASE_MAP[j2] = 255;
  }
  for (var i3 = 0; i3 < ALPHABET.length; i3++) {
    var x3 = ALPHABET.charAt(i3);
    var xc = x3.charCodeAt(0);
    if (BASE_MAP[xc] !== 255) {
      throw new TypeError(x3 + " is ambiguous");
    }
    BASE_MAP[xc] = i3;
  }
  var BASE = ALPHABET.length;
  var LEADER = ALPHABET.charAt(0);
  var FACTOR = Math.log(BASE) / Math.log(256);
  var iFACTOR = Math.log(256) / Math.log(BASE);
  function encode4(source) {
    if (source instanceof Uint8Array) ;
    else if (ArrayBuffer.isView(source)) {
      source = new Uint8Array(source.buffer, source.byteOffset, source.byteLength);
    } else if (Array.isArray(source)) {
      source = Uint8Array.from(source);
    }
    if (!(source instanceof Uint8Array)) {
      throw new TypeError("Expected Uint8Array");
    }
    if (source.length === 0) {
      return "";
    }
    var zeroes = 0;
    var length = 0;
    var pbegin = 0;
    var pend = source.length;
    while (pbegin !== pend && source[pbegin] === 0) {
      pbegin++;
      zeroes++;
    }
    var size = (pend - pbegin) * iFACTOR + 1 >>> 0;
    var b58 = new Uint8Array(size);
    while (pbegin !== pend) {
      var carry = source[pbegin];
      var i4 = 0;
      for (var it1 = size - 1; (carry !== 0 || i4 < length) && it1 !== -1; it1--, i4++) {
        carry += 256 * b58[it1] >>> 0;
        b58[it1] = carry % BASE >>> 0;
        carry = carry / BASE >>> 0;
      }
      if (carry !== 0) {
        throw new Error("Non-zero carry");
      }
      length = i4;
      pbegin++;
    }
    var it2 = size - length;
    while (it2 !== size && b58[it2] === 0) {
      it2++;
    }
    var str = LEADER.repeat(zeroes);
    for (; it2 < size; ++it2) {
      str += ALPHABET.charAt(b58[it2]);
    }
    return str;
  }
  function decodeUnsafe(source) {
    if (typeof source !== "string") {
      throw new TypeError("Expected String");
    }
    if (source.length === 0) {
      return new Uint8Array();
    }
    var psz = 0;
    if (source[psz] === " ") {
      return;
    }
    var zeroes = 0;
    var length = 0;
    while (source[psz] === LEADER) {
      zeroes++;
      psz++;
    }
    var size = (source.length - psz) * FACTOR + 1 >>> 0;
    var b256 = new Uint8Array(size);
    while (source[psz]) {
      var carry = BASE_MAP[source.charCodeAt(psz)];
      if (carry === 255) {
        return;
      }
      var i4 = 0;
      for (var it3 = size - 1; (carry !== 0 || i4 < length) && it3 !== -1; it3--, i4++) {
        carry += BASE * b256[it3] >>> 0;
        b256[it3] = carry % 256 >>> 0;
        carry = carry / 256 >>> 0;
      }
      if (carry !== 0) {
        throw new Error("Non-zero carry");
      }
      length = i4;
      psz++;
    }
    if (source[psz] === " ") {
      return;
    }
    var it4 = size - length;
    while (it4 !== size && b256[it4] === 0) {
      it4++;
    }
    var vch = new Uint8Array(zeroes + (size - it4));
    var j3 = zeroes;
    while (it4 !== size) {
      vch[j3++] = b256[it4++];
    }
    return vch;
  }
  function decode2(string2) {
    var buffer = decodeUnsafe(string2);
    if (buffer) {
      return buffer;
    }
    throw new Error(`Non-${name2} character`);
  }
  return {
    encode: encode4,
    decodeUnsafe,
    decode: decode2
  };
}
var src = base$2;
var _brrp__multiformats_scope_baseX = src;
const coerce = (o3) => {
  if (o3 instanceof Uint8Array && o3.constructor.name === "Uint8Array")
    return o3;
  if (o3 instanceof ArrayBuffer)
    return new Uint8Array(o3);
  if (ArrayBuffer.isView(o3)) {
    return new Uint8Array(o3.buffer, o3.byteOffset, o3.byteLength);
  }
  throw new Error("Unknown type, must be binary type");
};
const fromString$1 = (str) => new TextEncoder().encode(str);
const toString$1 = (b2) => new TextDecoder().decode(b2);
class Encoder {
  constructor(name2, prefix, baseEncode) {
    this.name = name2;
    this.prefix = prefix;
    this.baseEncode = baseEncode;
  }
  encode(bytes) {
    if (bytes instanceof Uint8Array) {
      return `${this.prefix}${this.baseEncode(bytes)}`;
    } else {
      throw Error("Unknown type, must be binary type");
    }
  }
}
class Decoder {
  constructor(name2, prefix, baseDecode) {
    this.name = name2;
    this.prefix = prefix;
    if (prefix.codePointAt(0) === void 0) {
      throw new Error("Invalid prefix character");
    }
    this.prefixCodePoint = prefix.codePointAt(0);
    this.baseDecode = baseDecode;
  }
  decode(text) {
    if (typeof text === "string") {
      if (text.codePointAt(0) !== this.prefixCodePoint) {
        throw Error(`Unable to decode multibase string ${JSON.stringify(text)}, ${this.name} decoder only supports inputs prefixed with ${this.prefix}`);
      }
      return this.baseDecode(text.slice(this.prefix.length));
    } else {
      throw Error("Can only multibase decode strings");
    }
  }
  or(decoder) {
    return or$2(this, decoder);
  }
}
class ComposedDecoder {
  constructor(decoders) {
    this.decoders = decoders;
  }
  or(decoder) {
    return or$2(this, decoder);
  }
  decode(input) {
    const prefix = input[0];
    const decoder = this.decoders[prefix];
    if (decoder) {
      return decoder.decode(input);
    } else {
      throw RangeError(`Unable to decode multibase string ${JSON.stringify(input)}, only inputs prefixed with ${Object.keys(this.decoders)} are supported`);
    }
  }
}
const or$2 = (left, right) => new ComposedDecoder({
  ...left.decoders || { [left.prefix]: left },
  ...right.decoders || { [right.prefix]: right }
});
class Codec {
  constructor(name2, prefix, baseEncode, baseDecode) {
    this.name = name2;
    this.prefix = prefix;
    this.baseEncode = baseEncode;
    this.baseDecode = baseDecode;
    this.encoder = new Encoder(name2, prefix, baseEncode);
    this.decoder = new Decoder(name2, prefix, baseDecode);
  }
  encode(input) {
    return this.encoder.encode(input);
  }
  decode(input) {
    return this.decoder.decode(input);
  }
}
const from = ({ name: name2, prefix, encode: encode4, decode: decode2 }) => new Codec(name2, prefix, encode4, decode2);
const baseX = ({ prefix, name: name2, alphabet: alphabet2 }) => {
  const { encode: encode4, decode: decode2 } = _brrp__multiformats_scope_baseX(alphabet2, name2);
  return from({
    prefix,
    name: name2,
    encode: encode4,
    decode: (text) => coerce(decode2(text))
  });
};
const decode$2 = (string2, alphabet2, bitsPerChar, name2) => {
  const codes = {};
  for (let i3 = 0; i3 < alphabet2.length; ++i3) {
    codes[alphabet2[i3]] = i3;
  }
  let end = string2.length;
  while (string2[end - 1] === "=") {
    --end;
  }
  const out = new Uint8Array(end * bitsPerChar / 8 | 0);
  let bits = 0;
  let buffer = 0;
  let written = 0;
  for (let i3 = 0; i3 < end; ++i3) {
    const value = codes[string2[i3]];
    if (value === void 0) {
      throw new SyntaxError(`Non-${name2} character`);
    }
    buffer = buffer << bitsPerChar | value;
    bits += bitsPerChar;
    if (bits >= 8) {
      bits -= 8;
      out[written++] = 255 & buffer >> bits;
    }
  }
  if (bits >= bitsPerChar || 255 & buffer << 8 - bits) {
    throw new SyntaxError("Unexpected end of data");
  }
  return out;
};
const encode$1 = (data, alphabet2, bitsPerChar) => {
  const pad = alphabet2[alphabet2.length - 1] === "=";
  const mask = (1 << bitsPerChar) - 1;
  let out = "";
  let bits = 0;
  let buffer = 0;
  for (let i3 = 0; i3 < data.length; ++i3) {
    buffer = buffer << 8 | data[i3];
    bits += 8;
    while (bits > bitsPerChar) {
      bits -= bitsPerChar;
      out += alphabet2[mask & buffer >> bits];
    }
  }
  if (bits) {
    out += alphabet2[mask & buffer << bitsPerChar - bits];
  }
  if (pad) {
    while (out.length * bitsPerChar & 7) {
      out += "=";
    }
  }
  return out;
};
const rfc4648 = ({ name: name2, prefix, bitsPerChar, alphabet: alphabet2 }) => {
  return from({
    prefix,
    name: name2,
    encode(input) {
      return encode$1(input, alphabet2, bitsPerChar);
    },
    decode(input) {
      return decode$2(input, alphabet2, bitsPerChar, name2);
    }
  });
};
const identity = from({
  prefix: "\0",
  name: "identity",
  encode: (buf) => toString$1(buf),
  decode: (str) => fromString$1(str)
});
const identityBase = /* @__PURE__ */ Object.freeze(/* @__PURE__ */ Object.defineProperty({
  __proto__: null,
  identity
}, Symbol.toStringTag, { value: "Module" }));
const base2 = rfc4648({
  prefix: "0",
  name: "base2",
  alphabet: "01",
  bitsPerChar: 1
});
const base2$1 = /* @__PURE__ */ Object.freeze(/* @__PURE__ */ Object.defineProperty({
  __proto__: null,
  base2
}, Symbol.toStringTag, { value: "Module" }));
const base8 = rfc4648({
  prefix: "7",
  name: "base8",
  alphabet: "01234567",
  bitsPerChar: 3
});
const base8$1 = /* @__PURE__ */ Object.freeze(/* @__PURE__ */ Object.defineProperty({
  __proto__: null,
  base8
}, Symbol.toStringTag, { value: "Module" }));
const base10 = baseX({
  prefix: "9",
  name: "base10",
  alphabet: "0123456789"
});
const base10$1 = /* @__PURE__ */ Object.freeze(/* @__PURE__ */ Object.defineProperty({
  __proto__: null,
  base10
}, Symbol.toStringTag, { value: "Module" }));
const base16 = rfc4648({
  prefix: "f",
  name: "base16",
  alphabet: "0123456789abcdef",
  bitsPerChar: 4
});
const base16upper = rfc4648({
  prefix: "F",
  name: "base16upper",
  alphabet: "0123456789ABCDEF",
  bitsPerChar: 4
});
const base16$1 = /* @__PURE__ */ Object.freeze(/* @__PURE__ */ Object.defineProperty({
  __proto__: null,
  base16,
  base16upper
}, Symbol.toStringTag, { value: "Module" }));
const base32 = rfc4648({
  prefix: "b",
  name: "base32",
  alphabet: "abcdefghijklmnopqrstuvwxyz234567",
  bitsPerChar: 5
});
const base32upper = rfc4648({
  prefix: "B",
  name: "base32upper",
  alphabet: "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567",
  bitsPerChar: 5
});
const base32pad = rfc4648({
  prefix: "c",
  name: "base32pad",
  alphabet: "abcdefghijklmnopqrstuvwxyz234567=",
  bitsPerChar: 5
});
const base32padupper = rfc4648({
  prefix: "C",
  name: "base32padupper",
  alphabet: "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567=",
  bitsPerChar: 5
});
const base32hex = rfc4648({
  prefix: "v",
  name: "base32hex",
  alphabet: "0123456789abcdefghijklmnopqrstuv",
  bitsPerChar: 5
});
const base32hexupper = rfc4648({
  prefix: "V",
  name: "base32hexupper",
  alphabet: "0123456789ABCDEFGHIJKLMNOPQRSTUV",
  bitsPerChar: 5
});
const base32hexpad = rfc4648({
  prefix: "t",
  name: "base32hexpad",
  alphabet: "0123456789abcdefghijklmnopqrstuv=",
  bitsPerChar: 5
});
const base32hexpadupper = rfc4648({
  prefix: "T",
  name: "base32hexpadupper",
  alphabet: "0123456789ABCDEFGHIJKLMNOPQRSTUV=",
  bitsPerChar: 5
});
const base32z = rfc4648({
  prefix: "h",
  name: "base32z",
  alphabet: "ybndrfg8ejkmcpqxot1uwisza345h769",
  bitsPerChar: 5
});
const base32$1 = /* @__PURE__ */ Object.freeze(/* @__PURE__ */ Object.defineProperty({
  __proto__: null,
  base32,
  base32hex,
  base32hexpad,
  base32hexpadupper,
  base32hexupper,
  base32pad,
  base32padupper,
  base32upper,
  base32z
}, Symbol.toStringTag, { value: "Module" }));
const base36 = baseX({
  prefix: "k",
  name: "base36",
  alphabet: "0123456789abcdefghijklmnopqrstuvwxyz"
});
const base36upper = baseX({
  prefix: "K",
  name: "base36upper",
  alphabet: "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
});
const base36$1 = /* @__PURE__ */ Object.freeze(/* @__PURE__ */ Object.defineProperty({
  __proto__: null,
  base36,
  base36upper
}, Symbol.toStringTag, { value: "Module" }));
const base58btc = baseX({
  name: "base58btc",
  prefix: "z",
  alphabet: "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"
});
const base58flickr = baseX({
  name: "base58flickr",
  prefix: "Z",
  alphabet: "123456789abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ"
});
const base58 = /* @__PURE__ */ Object.freeze(/* @__PURE__ */ Object.defineProperty({
  __proto__: null,
  base58btc,
  base58flickr
}, Symbol.toStringTag, { value: "Module" }));
const base64 = rfc4648({
  prefix: "m",
  name: "base64",
  alphabet: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/",
  bitsPerChar: 6
});
const base64pad = rfc4648({
  prefix: "M",
  name: "base64pad",
  alphabet: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=",
  bitsPerChar: 6
});
const base64url = rfc4648({
  prefix: "u",
  name: "base64url",
  alphabet: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_",
  bitsPerChar: 6
});
const base64urlpad = rfc4648({
  prefix: "U",
  name: "base64urlpad",
  alphabet: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_=",
  bitsPerChar: 6
});
const base64$1 = /* @__PURE__ */ Object.freeze(/* @__PURE__ */ Object.defineProperty({
  __proto__: null,
  base64,
  base64pad,
  base64url,
  base64urlpad
}, Symbol.toStringTag, { value: "Module" }));
const alphabet = Array.from("🚀🪐☄🛰🌌🌑🌒🌓🌔🌕🌖🌗🌘🌍🌏🌎🐉☀💻🖥💾💿😂❤😍🤣😊🙏💕😭😘👍😅👏😁🔥🥰💔💖💙😢🤔😆🙄💪😉☺👌🤗💜😔😎😇🌹🤦🎉💞✌✨🤷😱😌🌸🙌😋💗💚😏💛🙂💓🤩😄😀🖤😃💯🙈👇🎶😒🤭❣😜💋👀😪😑💥🙋😞😩😡🤪👊🥳😥🤤👉💃😳✋😚😝😴🌟😬🙃🍀🌷😻😓⭐✅🥺🌈😈🤘💦✔😣🏃💐☹🎊💘😠☝😕🌺🎂🌻😐🖕💝🙊😹🗣💫💀👑🎵🤞😛🔴😤🌼😫⚽🤙☕🏆🤫👈😮🙆🍻🍃🐶💁😲🌿🧡🎁⚡🌞🎈❌✊👋😰🤨😶🤝🚶💰🍓💢🤟🙁🚨💨🤬✈🎀🍺🤓😙💟🌱😖👶🥴▶➡❓💎💸⬇😨🌚🦋😷🕺⚠🙅😟😵👎🤲🤠🤧📌🔵💅🧐🐾🍒😗🤑🌊🤯🐷☎💧😯💆👆🎤🙇🍑❄🌴💣🐸💌📍🥀🤢👅💡💩👐📸👻🤐🤮🎼🥵🚩🍎🍊👼💍📣🥂");
const alphabetBytesToChars = alphabet.reduce((p3, c2, i3) => {
  p3[i3] = c2;
  return p3;
}, []);
const alphabetCharsToBytes = alphabet.reduce((p3, c2, i3) => {
  p3[c2.codePointAt(0)] = i3;
  return p3;
}, []);
function encode(data) {
  return data.reduce((p3, c2) => {
    p3 += alphabetBytesToChars[c2];
    return p3;
  }, "");
}
function decode$1(str) {
  const byts = [];
  for (const char of str) {
    const byt = alphabetCharsToBytes[char.codePointAt(0)];
    if (byt === void 0) {
      throw new Error(`Non-base256emoji character: ${char}`);
    }
    byts.push(byt);
  }
  return new Uint8Array(byts);
}
const base256emoji = from({
  prefix: "🚀",
  name: "base256emoji",
  encode,
  decode: decode$1
});
const base256emoji$1 = /* @__PURE__ */ Object.freeze(/* @__PURE__ */ Object.defineProperty({
  __proto__: null,
  base256emoji
}, Symbol.toStringTag, { value: "Module" }));
new TextEncoder();
new TextDecoder();
const bases = {
  ...identityBase,
  ...base2$1,
  ...base8$1,
  ...base10$1,
  ...base16$1,
  ...base32$1,
  ...base36$1,
  ...base58,
  ...base64$1,
  ...base256emoji$1
};
function createCodec(name2, prefix, encode4, decode2) {
  return {
    name: name2,
    prefix,
    encoder: {
      name: name2,
      prefix,
      encode: encode4
    },
    decoder: { decode: decode2 }
  };
}
const string = createCodec("utf8", "u", (buf) => {
  const decoder = new TextDecoder("utf8");
  return "u" + decoder.decode(buf);
}, (str) => {
  const encoder = new TextEncoder();
  return encoder.encode(str.substring(1));
});
const ascii = createCodec("ascii", "a", (buf) => {
  let string2 = "a";
  for (let i3 = 0; i3 < buf.length; i3++) {
    string2 += String.fromCharCode(buf[i3]);
  }
  return string2;
}, (str) => {
  str = str.substring(1);
  const buf = allocUnsafe(str.length);
  for (let i3 = 0; i3 < str.length; i3++) {
    buf[i3] = str.charCodeAt(i3);
  }
  return buf;
});
const BASES = {
  utf8: string,
  "utf-8": string,
  hex: bases.base16,
  latin1: ascii,
  ascii,
  binary: ascii,
  ...bases
};
function toString(array, encoding = "utf8") {
  const base3 = BASES[encoding];
  if (!base3) {
    throw new Error(`Unsupported encoding "${encoding}"`);
  }
  if ((encoding === "utf8" || encoding === "utf-8") && globalThis.Buffer != null && globalThis.Buffer.from != null) {
    return globalThis.Buffer.from(array.buffer, array.byteOffset, array.byteLength).toString("utf8");
  }
  return base3.encoder.encode(array).substring(1);
}
function fromString(string2, encoding = "utf8") {
  const base3 = BASES[encoding];
  if (!base3) {
    throw new Error(`Unsupported encoding "${encoding}"`);
  }
  if ((encoding === "utf8" || encoding === "utf-8") && globalThis.Buffer != null && globalThis.Buffer.from != null) {
    return globalThis.Buffer.from(string2, "utf8");
  }
  return base3.decoder.decode(`${base3.prefix}${string2}`);
}
function decodeJSON(str) {
  return safeJsonParse(toString(fromString(str, JWT_ENCODING), JSON_ENCODING));
}
function encodeJSON(val) {
  return toString(fromString(safeJsonStringify(val), JSON_ENCODING), JWT_ENCODING);
}
function encodeIss(publicKey) {
  const header = fromString(MULTICODEC_ED25519_HEADER, MULTICODEC_ED25519_ENCODING);
  const multicodec = MULTICODEC_ED25519_BASE + toString(concat$1([header, publicKey]), MULTICODEC_ED25519_ENCODING);
  return [DID_PREFIX, DID_METHOD, multicodec].join(DID_DELIMITER);
}
function encodeSig(bytes) {
  return toString(bytes, JWT_ENCODING);
}
function decodeSig(encoded) {
  return fromString(encoded, JWT_ENCODING);
}
function encodeData(params) {
  return fromString([encodeJSON(params.header), encodeJSON(params.payload)].join(JWT_DELIMITER), DATA_ENCODING);
}
function encodeJWT(params) {
  return [
    encodeJSON(params.header),
    encodeJSON(params.payload),
    encodeSig(params.signature)
  ].join(JWT_DELIMITER);
}
function decodeJWT(jwt) {
  const params = jwt.split(JWT_DELIMITER);
  const header = decodeJSON(params[0]);
  const payload = decodeJSON(params[1]);
  const signature2 = decodeSig(params[2]);
  const data = fromString(params.slice(0, 2).join(JWT_DELIMITER), DATA_ENCODING);
  return { header, payload, signature: signature2, data };
}
function generateKeyPair(seed = random.randomBytes(KEY_PAIR_SEED_LENGTH)) {
  return ed25519.generateKeyPairFromSeed(seed);
}
async function signJWT(sub, aud, ttl, keyPair3, iat = cjs$3.fromMiliseconds(Date.now())) {
  const header = { alg: JWT_IRIDIUM_ALG, typ: JWT_IRIDIUM_TYP };
  const iss = encodeIss(keyPair3.publicKey);
  const exp = iat + ttl;
  const payload = { iss, sub, aud, iat, exp };
  const data = encodeData({ header, payload });
  const signature2 = ed25519.sign(keyPair3.secretKey, data);
  return encodeJWT({ header, payload, signature: signature2 });
}
var __spreadArray = function(to2, from2, pack) {
  if (pack || arguments.length === 2) for (var i3 = 0, l2 = from2.length, ar2; i3 < l2; i3++) {
    if (ar2 || !(i3 in from2)) {
      if (!ar2) ar2 = Array.prototype.slice.call(from2, 0, i3);
      ar2[i3] = from2[i3];
    }
  }
  return to2.concat(ar2 || Array.prototype.slice.call(from2));
};
var BrowserInfo = (
  /** @class */
  /* @__PURE__ */ function() {
    function BrowserInfo2(name2, version2, os) {
      this.name = name2;
      this.version = version2;
      this.os = os;
      this.type = "browser";
    }
    return BrowserInfo2;
  }()
);
var NodeInfo = (
  /** @class */
  /* @__PURE__ */ function() {
    function NodeInfo2(version2) {
      this.version = version2;
      this.type = "node";
      this.name = "node";
      this.os = process$1.platform;
    }
    return NodeInfo2;
  }()
);
var SearchBotDeviceInfo = (
  /** @class */
  /* @__PURE__ */ function() {
    function SearchBotDeviceInfo2(name2, version2, os, bot) {
      this.name = name2;
      this.version = version2;
      this.os = os;
      this.bot = bot;
      this.type = "bot-device";
    }
    return SearchBotDeviceInfo2;
  }()
);
var BotInfo = (
  /** @class */
  /* @__PURE__ */ function() {
    function BotInfo2() {
      this.type = "bot";
      this.bot = true;
      this.name = "bot";
      this.version = null;
      this.os = null;
    }
    return BotInfo2;
  }()
);
var ReactNativeInfo = (
  /** @class */
  /* @__PURE__ */ function() {
    function ReactNativeInfo2() {
      this.type = "react-native";
      this.name = "react-native";
      this.version = null;
      this.os = null;
    }
    return ReactNativeInfo2;
  }()
);
var SEARCHBOX_UA_REGEX = /alexa|bot|crawl(er|ing)|facebookexternalhit|feedburner|google web preview|nagios|postrank|pingdom|slurp|spider|yahoo!|yandex/;
var SEARCHBOT_OS_REGEX = /(nuhk|curl|Googlebot|Yammybot|Openbot|Slurp|MSNBot|Ask\ Jeeves\/Teoma|ia_archiver)/;
var REQUIRED_VERSION_PARTS = 3;
var userAgentRules = [
  ["aol", /AOLShield\/([0-9\._]+)/],
  ["edge", /Edge\/([0-9\._]+)/],
  ["edge-ios", /EdgiOS\/([0-9\._]+)/],
  ["yandexbrowser", /YaBrowser\/([0-9\._]+)/],
  ["kakaotalk", /KAKAOTALK\s([0-9\.]+)/],
  ["samsung", /SamsungBrowser\/([0-9\.]+)/],
  ["silk", /\bSilk\/([0-9._-]+)\b/],
  ["miui", /MiuiBrowser\/([0-9\.]+)$/],
  ["beaker", /BeakerBrowser\/([0-9\.]+)/],
  ["edge-chromium", /EdgA?\/([0-9\.]+)/],
  [
    "chromium-webview",
    /(?!Chrom.*OPR)wv\).*Chrom(?:e|ium)\/([0-9\.]+)(:?\s|$)/
  ],
  ["chrome", /(?!Chrom.*OPR)Chrom(?:e|ium)\/([0-9\.]+)(:?\s|$)/],
  ["phantomjs", /PhantomJS\/([0-9\.]+)(:?\s|$)/],
  ["crios", /CriOS\/([0-9\.]+)(:?\s|$)/],
  ["firefox", /Firefox\/([0-9\.]+)(?:\s|$)/],
  ["fxios", /FxiOS\/([0-9\.]+)/],
  ["opera-mini", /Opera Mini.*Version\/([0-9\.]+)/],
  ["opera", /Opera\/([0-9\.]+)(?:\s|$)/],
  ["opera", /OPR\/([0-9\.]+)(:?\s|$)/],
  ["pie", /^Microsoft Pocket Internet Explorer\/(\d+\.\d+)$/],
  ["pie", /^Mozilla\/\d\.\d+\s\(compatible;\s(?:MSP?IE|MSInternet Explorer) (\d+\.\d+);.*Windows CE.*\)$/],
  ["netfront", /^Mozilla\/\d\.\d+.*NetFront\/(\d.\d)/],
  ["ie", /Trident\/7\.0.*rv\:([0-9\.]+).*\).*Gecko$/],
  ["ie", /MSIE\s([0-9\.]+);.*Trident\/[4-7].0/],
  ["ie", /MSIE\s(7\.0)/],
  ["bb10", /BB10;\sTouch.*Version\/([0-9\.]+)/],
  ["android", /Android\s([0-9\.]+)/],
  ["ios", /Version\/([0-9\._]+).*Mobile.*Safari.*/],
  ["safari", /Version\/([0-9\._]+).*Safari/],
  ["facebook", /FB[AS]V\/([0-9\.]+)/],
  ["instagram", /Instagram\s([0-9\.]+)/],
  ["ios-webview", /AppleWebKit\/([0-9\.]+).*Mobile/],
  ["ios-webview", /AppleWebKit\/([0-9\.]+).*Gecko\)$/],
  ["curl", /^curl\/([0-9\.]+)$/],
  ["searchbot", SEARCHBOX_UA_REGEX]
];
var operatingSystemRules = [
  ["iOS", /iP(hone|od|ad)/],
  ["Android OS", /Android/],
  ["BlackBerry OS", /BlackBerry|BB10/],
  ["Windows Mobile", /IEMobile/],
  ["Amazon OS", /Kindle/],
  ["Windows 3.11", /Win16/],
  ["Windows 95", /(Windows 95)|(Win95)|(Windows_95)/],
  ["Windows 98", /(Windows 98)|(Win98)/],
  ["Windows 2000", /(Windows NT 5.0)|(Windows 2000)/],
  ["Windows XP", /(Windows NT 5.1)|(Windows XP)/],
  ["Windows Server 2003", /(Windows NT 5.2)/],
  ["Windows Vista", /(Windows NT 6.0)/],
  ["Windows 7", /(Windows NT 6.1)/],
  ["Windows 8", /(Windows NT 6.2)/],
  ["Windows 8.1", /(Windows NT 6.3)/],
  ["Windows 10", /(Windows NT 10.0)/],
  ["Windows ME", /Windows ME/],
  ["Windows CE", /Windows CE|WinCE|Microsoft Pocket Internet Explorer/],
  ["Open BSD", /OpenBSD/],
  ["Sun OS", /SunOS/],
  ["Chrome OS", /CrOS/],
  ["Linux", /(Linux)|(X11)/],
  ["Mac OS", /(Mac_PowerPC)|(Macintosh)/],
  ["QNX", /QNX/],
  ["BeOS", /BeOS/],
  ["OS/2", /OS\/2/]
];
function detect(userAgent) {
  if (typeof document === "undefined" && typeof navigator !== "undefined" && navigator.product === "ReactNative") {
    return new ReactNativeInfo();
  }
  if (typeof navigator !== "undefined") {
    return parseUserAgent(navigator.userAgent);
  }
  return getNodeVersion();
}
function matchUserAgent(ua) {
  return ua !== "" && userAgentRules.reduce(function(matched, _a) {
    var browser2 = _a[0], regex = _a[1];
    if (matched) {
      return matched;
    }
    var uaMatch = regex.exec(ua);
    return !!uaMatch && [browser2, uaMatch];
  }, false);
}
function parseUserAgent(ua) {
  var matchedRule = matchUserAgent(ua);
  if (!matchedRule) {
    return null;
  }
  var name2 = matchedRule[0], match = matchedRule[1];
  if (name2 === "searchbot") {
    return new BotInfo();
  }
  var versionParts = match[1] && match[1].split(".").join("_").split("_").slice(0, 3);
  if (versionParts) {
    if (versionParts.length < REQUIRED_VERSION_PARTS) {
      versionParts = __spreadArray(__spreadArray([], versionParts, true), createVersionParts(REQUIRED_VERSION_PARTS - versionParts.length), true);
    }
  } else {
    versionParts = [];
  }
  var version2 = versionParts.join(".");
  var os = detectOS(ua);
  var searchBotMatch = SEARCHBOT_OS_REGEX.exec(ua);
  if (searchBotMatch && searchBotMatch[1]) {
    return new SearchBotDeviceInfo(name2, version2, os, searchBotMatch[1]);
  }
  return new BrowserInfo(name2, version2, os);
}
function detectOS(ua) {
  for (var ii2 = 0, count = operatingSystemRules.length; ii2 < count; ii2++) {
    var _a = operatingSystemRules[ii2], os = _a[0], regex = _a[1];
    var match = regex.exec(ua);
    if (match) {
      return os;
    }
  }
  return null;
}
function getNodeVersion() {
  var isNode = typeof process$1 !== "undefined" && process$1.version;
  return isNode ? new NodeInfo(process$1.version.slice(1)) : null;
}
function createVersionParts(count) {
  var output = [];
  for (var ii2 = 0; ii2 < count; ii2++) {
    output.push("0");
  }
  return output;
}
var cjs$2 = {};
Object.defineProperty(cjs$2, "__esModule", { value: true });
cjs$2.getLocalStorage = cjs$2.getLocalStorageOrThrow = cjs$2.getCrypto = cjs$2.getCryptoOrThrow = getLocation_1 = cjs$2.getLocation = cjs$2.getLocationOrThrow = getNavigator_1 = cjs$2.getNavigator = cjs$2.getNavigatorOrThrow = getDocument_1 = cjs$2.getDocument = cjs$2.getDocumentOrThrow = cjs$2.getFromWindowOrThrow = cjs$2.getFromWindow = void 0;
function getFromWindow(name2) {
  let res = void 0;
  if (typeof window !== "undefined" && typeof window[name2] !== "undefined") {
    res = window[name2];
  }
  return res;
}
cjs$2.getFromWindow = getFromWindow;
function getFromWindowOrThrow(name2) {
  const res = getFromWindow(name2);
  if (!res) {
    throw new Error(`${name2} is not defined in Window`);
  }
  return res;
}
cjs$2.getFromWindowOrThrow = getFromWindowOrThrow;
function getDocumentOrThrow() {
  return getFromWindowOrThrow("document");
}
cjs$2.getDocumentOrThrow = getDocumentOrThrow;
function getDocument() {
  return getFromWindow("document");
}
var getDocument_1 = cjs$2.getDocument = getDocument;
function getNavigatorOrThrow() {
  return getFromWindowOrThrow("navigator");
}
cjs$2.getNavigatorOrThrow = getNavigatorOrThrow;
function getNavigator() {
  return getFromWindow("navigator");
}
var getNavigator_1 = cjs$2.getNavigator = getNavigator;
function getLocationOrThrow() {
  return getFromWindowOrThrow("location");
}
cjs$2.getLocationOrThrow = getLocationOrThrow;
function getLocation() {
  return getFromWindow("location");
}
var getLocation_1 = cjs$2.getLocation = getLocation;
function getCryptoOrThrow() {
  return getFromWindowOrThrow("crypto");
}
cjs$2.getCryptoOrThrow = getCryptoOrThrow;
function getCrypto() {
  return getFromWindow("crypto");
}
cjs$2.getCrypto = getCrypto;
function getLocalStorageOrThrow() {
  return getFromWindowOrThrow("localStorage");
}
cjs$2.getLocalStorageOrThrow = getLocalStorageOrThrow;
function getLocalStorage() {
  return getFromWindow("localStorage");
}
cjs$2.getLocalStorage = getLocalStorage;
var cjs$1 = {};
Object.defineProperty(cjs$1, "__esModule", { value: true });
var getWindowMetadata_1 = cjs$1.getWindowMetadata = void 0;
const window_getters_1 = cjs$2;
function getWindowMetadata() {
  let doc;
  let loc;
  try {
    doc = window_getters_1.getDocumentOrThrow();
    loc = window_getters_1.getLocationOrThrow();
  } catch (e2) {
    return null;
  }
  function getIcons() {
    const links = doc.getElementsByTagName("link");
    const icons2 = [];
    for (let i3 = 0; i3 < links.length; i3++) {
      const link = links[i3];
      const rel = link.getAttribute("rel");
      if (rel) {
        if (rel.toLowerCase().indexOf("icon") > -1) {
          const href = link.getAttribute("href");
          if (href) {
            if (href.toLowerCase().indexOf("https:") === -1 && href.toLowerCase().indexOf("http:") === -1 && href.indexOf("//") !== 0) {
              let absoluteHref = loc.protocol + "//" + loc.host;
              if (href.indexOf("/") === 0) {
                absoluteHref += href;
              } else {
                const path = loc.pathname.split("/");
                path.pop();
                const finalPath = path.join("/");
                absoluteHref += finalPath + "/" + href;
              }
              icons2.push(absoluteHref);
            } else if (href.indexOf("//") === 0) {
              const absoluteUrl = loc.protocol + href;
              icons2.push(absoluteUrl);
            } else {
              icons2.push(href);
            }
          }
        }
      }
    }
    return icons2;
  }
  function getWindowMetadataOfAny(...args) {
    const metaTags = doc.getElementsByTagName("meta");
    for (let i3 = 0; i3 < metaTags.length; i3++) {
      const tag = metaTags[i3];
      const attributes = ["itemprop", "property", "name"].map((target) => tag.getAttribute(target)).filter((attr) => {
        if (attr) {
          return args.includes(attr);
        }
        return false;
      });
      if (attributes.length && attributes) {
        const content = tag.getAttribute("content");
        if (content) {
          return content;
        }
      }
    }
    return "";
  }
  function getName() {
    let name3 = getWindowMetadataOfAny("name", "og:site_name", "og:title", "twitter:title");
    if (!name3) {
      name3 = doc.title;
    }
    return name3;
  }
  function getDescription() {
    const description3 = getWindowMetadataOfAny("description", "og:description", "twitter:description", "keywords");
    return description3;
  }
  const name2 = getName();
  const description2 = getDescription();
  const url = loc.origin;
  const icons = getIcons();
  const meta = {
    description: description2,
    url,
    icons,
    name: name2
  };
  return meta;
}
getWindowMetadata_1 = cjs$1.getWindowMetadata = getWindowMetadata;
var queryString = {};
var strictUriEncode = (str) => encodeURIComponent(str).replace(/[!'()*]/g, (x3) => `%${x3.charCodeAt(0).toString(16).toUpperCase()}`);
var token = "%[a-f0-9]{2}";
var singleMatcher = new RegExp("(" + token + ")|([^%]+?)", "gi");
var multiMatcher = new RegExp("(" + token + ")+", "gi");
function decodeComponents(components, split) {
  try {
    return [decodeURIComponent(components.join(""))];
  } catch (err) {
  }
  if (components.length === 1) {
    return components;
  }
  split = split || 1;
  var left = components.slice(0, split);
  var right = components.slice(split);
  return Array.prototype.concat.call([], decodeComponents(left), decodeComponents(right));
}
function decode(input) {
  try {
    return decodeURIComponent(input);
  } catch (err) {
    var tokens = input.match(singleMatcher) || [];
    for (var i3 = 1; i3 < tokens.length; i3++) {
      input = decodeComponents(tokens, i3).join("");
      tokens = input.match(singleMatcher) || [];
    }
    return input;
  }
}
function customDecodeURIComponent(input) {
  var replaceMap = {
    "%FE%FF": "��",
    "%FF%FE": "��"
  };
  var match = multiMatcher.exec(input);
  while (match) {
    try {
      replaceMap[match[0]] = decodeURIComponent(match[0]);
    } catch (err) {
      var result = decode(match[0]);
      if (result !== match[0]) {
        replaceMap[match[0]] = result;
      }
    }
    match = multiMatcher.exec(input);
  }
  replaceMap["%C2"] = "�";
  var entries = Object.keys(replaceMap);
  for (var i3 = 0; i3 < entries.length; i3++) {
    var key2 = entries[i3];
    input = input.replace(new RegExp(key2, "g"), replaceMap[key2]);
  }
  return input;
}
var decodeUriComponent = function(encodedURI) {
  if (typeof encodedURI !== "string") {
    throw new TypeError("Expected `encodedURI` to be of type `string`, got `" + typeof encodedURI + "`");
  }
  try {
    encodedURI = encodedURI.replace(/\+/g, " ");
    return decodeURIComponent(encodedURI);
  } catch (err) {
    return customDecodeURIComponent(encodedURI);
  }
};
var splitOnFirst = (string2, separator) => {
  if (!(typeof string2 === "string" && typeof separator === "string")) {
    throw new TypeError("Expected the arguments to be of type `string`");
  }
  if (separator === "") {
    return [string2];
  }
  const separatorIndex = string2.indexOf(separator);
  if (separatorIndex === -1) {
    return [string2];
  }
  return [
    string2.slice(0, separatorIndex),
    string2.slice(separatorIndex + separator.length)
  ];
};
var filterObj = function(obj, predicate) {
  var ret = {};
  var keys2 = Object.keys(obj);
  var isArr = Array.isArray(predicate);
  for (var i3 = 0; i3 < keys2.length; i3++) {
    var key2 = keys2[i3];
    var val = obj[key2];
    if (isArr ? predicate.indexOf(key2) !== -1 : predicate(key2, val, obj)) {
      ret[key2] = val;
    }
  }
  return ret;
};
(function(exports) {
  const strictUriEncode$1 = strictUriEncode;
  const decodeComponent = decodeUriComponent;
  const splitOnFirst$1 = splitOnFirst;
  const filterObject = filterObj;
  const isNullOrUndefined = (value) => value === null || value === void 0;
  const encodeFragmentIdentifier = Symbol("encodeFragmentIdentifier");
  function encoderForArrayFormat(options) {
    switch (options.arrayFormat) {
      case "index":
        return (key2) => (result, value) => {
          const index = result.length;
          if (value === void 0 || options.skipNull && value === null || options.skipEmptyString && value === "") {
            return result;
          }
          if (value === null) {
            return [...result, [encode4(key2, options), "[", index, "]"].join("")];
          }
          return [
            ...result,
            [encode4(key2, options), "[", encode4(index, options), "]=", encode4(value, options)].join("")
          ];
        };
      case "bracket":
        return (key2) => (result, value) => {
          if (value === void 0 || options.skipNull && value === null || options.skipEmptyString && value === "") {
            return result;
          }
          if (value === null) {
            return [...result, [encode4(key2, options), "[]"].join("")];
          }
          return [...result, [encode4(key2, options), "[]=", encode4(value, options)].join("")];
        };
      case "colon-list-separator":
        return (key2) => (result, value) => {
          if (value === void 0 || options.skipNull && value === null || options.skipEmptyString && value === "") {
            return result;
          }
          if (value === null) {
            return [...result, [encode4(key2, options), ":list="].join("")];
          }
          return [...result, [encode4(key2, options), ":list=", encode4(value, options)].join("")];
        };
      case "comma":
      case "separator":
      case "bracket-separator": {
        const keyValueSep = options.arrayFormat === "bracket-separator" ? "[]=" : "=";
        return (key2) => (result, value) => {
          if (value === void 0 || options.skipNull && value === null || options.skipEmptyString && value === "") {
            return result;
          }
          value = value === null ? "" : value;
          if (result.length === 0) {
            return [[encode4(key2, options), keyValueSep, encode4(value, options)].join("")];
          }
          return [[result, encode4(value, options)].join(options.arrayFormatSeparator)];
        };
      }
      default:
        return (key2) => (result, value) => {
          if (value === void 0 || options.skipNull && value === null || options.skipEmptyString && value === "") {
            return result;
          }
          if (value === null) {
            return [...result, encode4(key2, options)];
          }
          return [...result, [encode4(key2, options), "=", encode4(value, options)].join("")];
        };
    }
  }
  function parserForArrayFormat(options) {
    let result;
    switch (options.arrayFormat) {
      case "index":
        return (key2, value, accumulator) => {
          result = /\[(\d*)\]$/.exec(key2);
          key2 = key2.replace(/\[\d*\]$/, "");
          if (!result) {
            accumulator[key2] = value;
            return;
          }
          if (accumulator[key2] === void 0) {
            accumulator[key2] = {};
          }
          accumulator[key2][result[1]] = value;
        };
      case "bracket":
        return (key2, value, accumulator) => {
          result = /(\[\])$/.exec(key2);
          key2 = key2.replace(/\[\]$/, "");
          if (!result) {
            accumulator[key2] = value;
            return;
          }
          if (accumulator[key2] === void 0) {
            accumulator[key2] = [value];
            return;
          }
          accumulator[key2] = [].concat(accumulator[key2], value);
        };
      case "colon-list-separator":
        return (key2, value, accumulator) => {
          result = /(:list)$/.exec(key2);
          key2 = key2.replace(/:list$/, "");
          if (!result) {
            accumulator[key2] = value;
            return;
          }
          if (accumulator[key2] === void 0) {
            accumulator[key2] = [value];
            return;
          }
          accumulator[key2] = [].concat(accumulator[key2], value);
        };
      case "comma":
      case "separator":
        return (key2, value, accumulator) => {
          const isArray = typeof value === "string" && value.includes(options.arrayFormatSeparator);
          const isEncodedArray = typeof value === "string" && !isArray && decode2(value, options).includes(options.arrayFormatSeparator);
          value = isEncodedArray ? decode2(value, options) : value;
          const newValue = isArray || isEncodedArray ? value.split(options.arrayFormatSeparator).map((item) => decode2(item, options)) : value === null ? value : decode2(value, options);
          accumulator[key2] = newValue;
        };
      case "bracket-separator":
        return (key2, value, accumulator) => {
          const isArray = /(\[\])$/.test(key2);
          key2 = key2.replace(/\[\]$/, "");
          if (!isArray) {
            accumulator[key2] = value ? decode2(value, options) : value;
            return;
          }
          const arrayValue = value === null ? [] : value.split(options.arrayFormatSeparator).map((item) => decode2(item, options));
          if (accumulator[key2] === void 0) {
            accumulator[key2] = arrayValue;
            return;
          }
          accumulator[key2] = [].concat(accumulator[key2], arrayValue);
        };
      default:
        return (key2, value, accumulator) => {
          if (accumulator[key2] === void 0) {
            accumulator[key2] = value;
            return;
          }
          accumulator[key2] = [].concat(accumulator[key2], value);
        };
    }
  }
  function validateArrayFormatSeparator(value) {
    if (typeof value !== "string" || value.length !== 1) {
      throw new TypeError("arrayFormatSeparator must be single character string");
    }
  }
  function encode4(value, options) {
    if (options.encode) {
      return options.strict ? strictUriEncode$1(value) : encodeURIComponent(value);
    }
    return value;
  }
  function decode2(value, options) {
    if (options.decode) {
      return decodeComponent(value);
    }
    return value;
  }
  function keysSorter(input) {
    if (Array.isArray(input)) {
      return input.sort();
    }
    if (typeof input === "object") {
      return keysSorter(Object.keys(input)).sort((a3, b2) => Number(a3) - Number(b2)).map((key2) => input[key2]);
    }
    return input;
  }
  function removeHash(input) {
    const hashStart = input.indexOf("#");
    if (hashStart !== -1) {
      input = input.slice(0, hashStart);
    }
    return input;
  }
  function getHash(url) {
    let hash3 = "";
    const hashStart = url.indexOf("#");
    if (hashStart !== -1) {
      hash3 = url.slice(hashStart);
    }
    return hash3;
  }
  function extract(input) {
    input = removeHash(input);
    const queryStart = input.indexOf("?");
    if (queryStart === -1) {
      return "";
    }
    return input.slice(queryStart + 1);
  }
  function parseValue(value, options) {
    if (options.parseNumbers && !Number.isNaN(Number(value)) && (typeof value === "string" && value.trim() !== "")) {
      value = Number(value);
    } else if (options.parseBooleans && value !== null && (value.toLowerCase() === "true" || value.toLowerCase() === "false")) {
      value = value.toLowerCase() === "true";
    }
    return value;
  }
  function parse(query, options) {
    options = Object.assign({
      decode: true,
      sort: true,
      arrayFormat: "none",
      arrayFormatSeparator: ",",
      parseNumbers: false,
      parseBooleans: false
    }, options);
    validateArrayFormatSeparator(options.arrayFormatSeparator);
    const formatter = parserForArrayFormat(options);
    const ret = /* @__PURE__ */ Object.create(null);
    if (typeof query !== "string") {
      return ret;
    }
    query = query.trim().replace(/^[?#&]/, "");
    if (!query) {
      return ret;
    }
    for (const param of query.split("&")) {
      if (param === "") {
        continue;
      }
      let [key2, value] = splitOnFirst$1(options.decode ? param.replace(/\+/g, " ") : param, "=");
      value = value === void 0 ? null : ["comma", "separator", "bracket-separator"].includes(options.arrayFormat) ? value : decode2(value, options);
      formatter(decode2(key2, options), value, ret);
    }
    for (const key2 of Object.keys(ret)) {
      const value = ret[key2];
      if (typeof value === "object" && value !== null) {
        for (const k2 of Object.keys(value)) {
          value[k2] = parseValue(value[k2], options);
        }
      } else {
        ret[key2] = parseValue(value, options);
      }
    }
    if (options.sort === false) {
      return ret;
    }
    return (options.sort === true ? Object.keys(ret).sort() : Object.keys(ret).sort(options.sort)).reduce((result, key2) => {
      const value = ret[key2];
      if (Boolean(value) && typeof value === "object" && !Array.isArray(value)) {
        result[key2] = keysSorter(value);
      } else {
        result[key2] = value;
      }
      return result;
    }, /* @__PURE__ */ Object.create(null));
  }
  exports.extract = extract;
  exports.parse = parse;
  exports.stringify = (object, options) => {
    if (!object) {
      return "";
    }
    options = Object.assign({
      encode: true,
      strict: true,
      arrayFormat: "none",
      arrayFormatSeparator: ","
    }, options);
    validateArrayFormatSeparator(options.arrayFormatSeparator);
    const shouldFilter = (key2) => options.skipNull && isNullOrUndefined(object[key2]) || options.skipEmptyString && object[key2] === "";
    const formatter = encoderForArrayFormat(options);
    const objectCopy = {};
    for (const key2 of Object.keys(object)) {
      if (!shouldFilter(key2)) {
        objectCopy[key2] = object[key2];
      }
    }
    const keys2 = Object.keys(objectCopy);
    if (options.sort !== false) {
      keys2.sort(options.sort);
    }
    return keys2.map((key2) => {
      const value = object[key2];
      if (value === void 0) {
        return "";
      }
      if (value === null) {
        return encode4(key2, options);
      }
      if (Array.isArray(value)) {
        if (value.length === 0 && options.arrayFormat === "bracket-separator") {
          return encode4(key2, options) + "[]";
        }
        return value.reduce(formatter(key2), []).join("&");
      }
      return encode4(key2, options) + "=" + encode4(value, options);
    }).filter((x3) => x3.length > 0).join("&");
  };
  exports.parseUrl = (url, options) => {
    options = Object.assign({
      decode: true
    }, options);
    const [url_, hash3] = splitOnFirst$1(url, "#");
    return Object.assign(
      {
        url: url_.split("?")[0] || "",
        query: parse(extract(url), options)
      },
      options && options.parseFragmentIdentifier && hash3 ? { fragmentIdentifier: decode2(hash3, options) } : {}
    );
  };
  exports.stringifyUrl = (object, options) => {
    options = Object.assign({
      encode: true,
      strict: true,
      [encodeFragmentIdentifier]: true
    }, options);
    const url = removeHash(object.url).split("?")[0] || "";
    const queryFromUrl = exports.extract(object.url);
    const parsedQueryFromUrl = exports.parse(queryFromUrl, { sort: false });
    const query = Object.assign(parsedQueryFromUrl, object.query);
    let queryString2 = exports.stringify(query, options);
    if (queryString2) {
      queryString2 = `?${queryString2}`;
    }
    let hash3 = getHash(object.url);
    if (object.fragmentIdentifier) {
      hash3 = `#${options[encodeFragmentIdentifier] ? encode4(object.fragmentIdentifier, options) : object.fragmentIdentifier}`;
    }
    return `${url}${queryString2}${hash3}`;
  };
  exports.pick = (input, filter, options) => {
    options = Object.assign({
      parseFragmentIdentifier: true,
      [encodeFragmentIdentifier]: false
    }, options);
    const { url, query, fragmentIdentifier } = exports.parseUrl(input, options);
    return exports.stringifyUrl({
      url,
      query: filterObject(query, filter),
      fragmentIdentifier
    }, options);
  };
  exports.exclude = (input, filter, options) => {
    const exclusionFilter = Array.isArray(filter) ? (key2) => !filter.includes(key2) : (key2, value) => !filter(key2, value);
    return exports.pick(input, exclusionFilter, options);
  };
})(queryString);
var sha3$1 = { exports: {} };
(function(module) {
  (function() {
    var INPUT_ERROR = "input is invalid type";
    var FINALIZE_ERROR = "finalize already called";
    var WINDOW = typeof window === "object";
    var root = WINDOW ? window : {};
    if (root.JS_SHA3_NO_WINDOW) {
      WINDOW = false;
    }
    var WEB_WORKER = !WINDOW && typeof self === "object";
    var NODE_JS = !root.JS_SHA3_NO_NODE_JS && typeof process$1 === "object" && process$1.versions && process$1.versions.node;
    if (NODE_JS) {
      root = commonjsGlobal;
    } else if (WEB_WORKER) {
      root = self;
    }
    var COMMON_JS = !root.JS_SHA3_NO_COMMON_JS && true && module.exports;
    var ARRAY_BUFFER = !root.JS_SHA3_NO_ARRAY_BUFFER && typeof ArrayBuffer !== "undefined";
    var HEX_CHARS = "0123456789abcdef".split("");
    var SHAKE_PADDING = [31, 7936, 2031616, 520093696];
    var CSHAKE_PADDING = [4, 1024, 262144, 67108864];
    var KECCAK_PADDING = [1, 256, 65536, 16777216];
    var PADDING = [6, 1536, 393216, 100663296];
    var SHIFT = [0, 8, 16, 24];
    var RC = [
      1,
      0,
      32898,
      0,
      32906,
      2147483648,
      2147516416,
      2147483648,
      32907,
      0,
      2147483649,
      0,
      2147516545,
      2147483648,
      32777,
      2147483648,
      138,
      0,
      136,
      0,
      2147516425,
      0,
      2147483658,
      0,
      2147516555,
      0,
      139,
      2147483648,
      32905,
      2147483648,
      32771,
      2147483648,
      32770,
      2147483648,
      128,
      2147483648,
      32778,
      0,
      2147483658,
      2147483648,
      2147516545,
      2147483648,
      32896,
      2147483648,
      2147483649,
      0,
      2147516424,
      2147483648
    ];
    var BITS = [224, 256, 384, 512];
    var SHAKE_BITS = [128, 256];
    var OUTPUT_TYPES = ["hex", "buffer", "arrayBuffer", "array", "digest"];
    var CSHAKE_BYTEPAD = {
      "128": 168,
      "256": 136
    };
    if (root.JS_SHA3_NO_NODE_JS || !Array.isArray) {
      Array.isArray = function(obj) {
        return Object.prototype.toString.call(obj) === "[object Array]";
      };
    }
    if (ARRAY_BUFFER && (root.JS_SHA3_NO_ARRAY_BUFFER_IS_VIEW || !ArrayBuffer.isView)) {
      ArrayBuffer.isView = function(obj) {
        return typeof obj === "object" && obj.buffer && obj.buffer.constructor === ArrayBuffer;
      };
    }
    var createOutputMethod = function(bits2, padding, outputType) {
      return function(message) {
        return new Keccak(bits2, padding, bits2).update(message)[outputType]();
      };
    };
    var createShakeOutputMethod = function(bits2, padding, outputType) {
      return function(message, outputBits) {
        return new Keccak(bits2, padding, outputBits).update(message)[outputType]();
      };
    };
    var createCshakeOutputMethod = function(bits2, padding, outputType) {
      return function(message, outputBits, n4, s2) {
        return methods["cshake" + bits2].update(message, outputBits, n4, s2)[outputType]();
      };
    };
    var createKmacOutputMethod = function(bits2, padding, outputType) {
      return function(key2, message, outputBits, s2) {
        return methods["kmac" + bits2].update(key2, message, outputBits, s2)[outputType]();
      };
    };
    var createOutputMethods = function(method, createMethod2, bits2, padding) {
      for (var i4 = 0; i4 < OUTPUT_TYPES.length; ++i4) {
        var type = OUTPUT_TYPES[i4];
        method[type] = createMethod2(bits2, padding, type);
      }
      return method;
    };
    var createMethod = function(bits2, padding) {
      var method = createOutputMethod(bits2, padding, "hex");
      method.create = function() {
        return new Keccak(bits2, padding, bits2);
      };
      method.update = function(message) {
        return method.create().update(message);
      };
      return createOutputMethods(method, createOutputMethod, bits2, padding);
    };
    var createShakeMethod = function(bits2, padding) {
      var method = createShakeOutputMethod(bits2, padding, "hex");
      method.create = function(outputBits) {
        return new Keccak(bits2, padding, outputBits);
      };
      method.update = function(message, outputBits) {
        return method.create(outputBits).update(message);
      };
      return createOutputMethods(method, createShakeOutputMethod, bits2, padding);
    };
    var createCshakeMethod = function(bits2, padding) {
      var w2 = CSHAKE_BYTEPAD[bits2];
      var method = createCshakeOutputMethod(bits2, padding, "hex");
      method.create = function(outputBits, n4, s2) {
        if (!n4 && !s2) {
          return methods["shake" + bits2].create(outputBits);
        } else {
          return new Keccak(bits2, padding, outputBits).bytepad([n4, s2], w2);
        }
      };
      method.update = function(message, outputBits, n4, s2) {
        return method.create(outputBits, n4, s2).update(message);
      };
      return createOutputMethods(method, createCshakeOutputMethod, bits2, padding);
    };
    var createKmacMethod = function(bits2, padding) {
      var w2 = CSHAKE_BYTEPAD[bits2];
      var method = createKmacOutputMethod(bits2, padding, "hex");
      method.create = function(key2, outputBits, s2) {
        return new Kmac(bits2, padding, outputBits).bytepad(["KMAC", s2], w2).bytepad([key2], w2);
      };
      method.update = function(key2, message, outputBits, s2) {
        return method.create(key2, outputBits, s2).update(message);
      };
      return createOutputMethods(method, createKmacOutputMethod, bits2, padding);
    };
    var algorithms = [
      { name: "keccak", padding: KECCAK_PADDING, bits: BITS, createMethod },
      { name: "sha3", padding: PADDING, bits: BITS, createMethod },
      { name: "shake", padding: SHAKE_PADDING, bits: SHAKE_BITS, createMethod: createShakeMethod },
      { name: "cshake", padding: CSHAKE_PADDING, bits: SHAKE_BITS, createMethod: createCshakeMethod },
      { name: "kmac", padding: CSHAKE_PADDING, bits: SHAKE_BITS, createMethod: createKmacMethod }
    ];
    var methods = {}, methodNames = [];
    for (var i3 = 0; i3 < algorithms.length; ++i3) {
      var algorithm = algorithms[i3];
      var bits = algorithm.bits;
      for (var j2 = 0; j2 < bits.length; ++j2) {
        var methodName = algorithm.name + "_" + bits[j2];
        methodNames.push(methodName);
        methods[methodName] = algorithm.createMethod(bits[j2], algorithm.padding);
        if (algorithm.name !== "sha3") {
          var newMethodName = algorithm.name + bits[j2];
          methodNames.push(newMethodName);
          methods[newMethodName] = methods[methodName];
        }
      }
    }
    function Keccak(bits2, padding, outputBits) {
      this.blocks = [];
      this.s = [];
      this.padding = padding;
      this.outputBits = outputBits;
      this.reset = true;
      this.finalized = false;
      this.block = 0;
      this.start = 0;
      this.blockCount = 1600 - (bits2 << 1) >> 5;
      this.byteCount = this.blockCount << 2;
      this.outputBlocks = outputBits >> 5;
      this.extraBytes = (outputBits & 31) >> 3;
      for (var i4 = 0; i4 < 50; ++i4) {
        this.s[i4] = 0;
      }
    }
    Keccak.prototype.update = function(message) {
      if (this.finalized) {
        throw new Error(FINALIZE_ERROR);
      }
      var notString, type = typeof message;
      if (type !== "string") {
        if (type === "object") {
          if (message === null) {
            throw new Error(INPUT_ERROR);
          } else if (ARRAY_BUFFER && message.constructor === ArrayBuffer) {
            message = new Uint8Array(message);
          } else if (!Array.isArray(message)) {
            if (!ARRAY_BUFFER || !ArrayBuffer.isView(message)) {
              throw new Error(INPUT_ERROR);
            }
          }
        } else {
          throw new Error(INPUT_ERROR);
        }
        notString = true;
      }
      var blocks = this.blocks, byteCount = this.byteCount, length = message.length, blockCount = this.blockCount, index = 0, s2 = this.s, i4, code;
      while (index < length) {
        if (this.reset) {
          this.reset = false;
          blocks[0] = this.block;
          for (i4 = 1; i4 < blockCount + 1; ++i4) {
            blocks[i4] = 0;
          }
        }
        if (notString) {
          for (i4 = this.start; index < length && i4 < byteCount; ++index) {
            blocks[i4 >> 2] |= message[index] << SHIFT[i4++ & 3];
          }
        } else {
          for (i4 = this.start; index < length && i4 < byteCount; ++index) {
            code = message.charCodeAt(index);
            if (code < 128) {
              blocks[i4 >> 2] |= code << SHIFT[i4++ & 3];
            } else if (code < 2048) {
              blocks[i4 >> 2] |= (192 | code >> 6) << SHIFT[i4++ & 3];
              blocks[i4 >> 2] |= (128 | code & 63) << SHIFT[i4++ & 3];
            } else if (code < 55296 || code >= 57344) {
              blocks[i4 >> 2] |= (224 | code >> 12) << SHIFT[i4++ & 3];
              blocks[i4 >> 2] |= (128 | code >> 6 & 63) << SHIFT[i4++ & 3];
              blocks[i4 >> 2] |= (128 | code & 63) << SHIFT[i4++ & 3];
            } else {
              code = 65536 + ((code & 1023) << 10 | message.charCodeAt(++index) & 1023);
              blocks[i4 >> 2] |= (240 | code >> 18) << SHIFT[i4++ & 3];
              blocks[i4 >> 2] |= (128 | code >> 12 & 63) << SHIFT[i4++ & 3];
              blocks[i4 >> 2] |= (128 | code >> 6 & 63) << SHIFT[i4++ & 3];
              blocks[i4 >> 2] |= (128 | code & 63) << SHIFT[i4++ & 3];
            }
          }
        }
        this.lastByteIndex = i4;
        if (i4 >= byteCount) {
          this.start = i4 - byteCount;
          this.block = blocks[blockCount];
          for (i4 = 0; i4 < blockCount; ++i4) {
            s2[i4] ^= blocks[i4];
          }
          f3(s2);
          this.reset = true;
        } else {
          this.start = i4;
        }
      }
      return this;
    };
    Keccak.prototype.encode = function(x3, right) {
      var o3 = x3 & 255, n4 = 1;
      var bytes = [o3];
      x3 = x3 >> 8;
      o3 = x3 & 255;
      while (o3 > 0) {
        bytes.unshift(o3);
        x3 = x3 >> 8;
        o3 = x3 & 255;
        ++n4;
      }
      if (right) {
        bytes.push(n4);
      } else {
        bytes.unshift(n4);
      }
      this.update(bytes);
      return bytes.length;
    };
    Keccak.prototype.encodeString = function(str) {
      var notString, type = typeof str;
      if (type !== "string") {
        if (type === "object") {
          if (str === null) {
            throw new Error(INPUT_ERROR);
          } else if (ARRAY_BUFFER && str.constructor === ArrayBuffer) {
            str = new Uint8Array(str);
          } else if (!Array.isArray(str)) {
            if (!ARRAY_BUFFER || !ArrayBuffer.isView(str)) {
              throw new Error(INPUT_ERROR);
            }
          }
        } else {
          throw new Error(INPUT_ERROR);
        }
        notString = true;
      }
      var bytes = 0, length = str.length;
      if (notString) {
        bytes = length;
      } else {
        for (var i4 = 0; i4 < str.length; ++i4) {
          var code = str.charCodeAt(i4);
          if (code < 128) {
            bytes += 1;
          } else if (code < 2048) {
            bytes += 2;
          } else if (code < 55296 || code >= 57344) {
            bytes += 3;
          } else {
            code = 65536 + ((code & 1023) << 10 | str.charCodeAt(++i4) & 1023);
            bytes += 4;
          }
        }
      }
      bytes += this.encode(bytes * 8);
      this.update(str);
      return bytes;
    };
    Keccak.prototype.bytepad = function(strs, w2) {
      var bytes = this.encode(w2);
      for (var i4 = 0; i4 < strs.length; ++i4) {
        bytes += this.encodeString(strs[i4]);
      }
      var paddingBytes = w2 - bytes % w2;
      var zeros = [];
      zeros.length = paddingBytes;
      this.update(zeros);
      return this;
    };
    Keccak.prototype.finalize = function() {
      if (this.finalized) {
        return;
      }
      this.finalized = true;
      var blocks = this.blocks, i4 = this.lastByteIndex, blockCount = this.blockCount, s2 = this.s;
      blocks[i4 >> 2] |= this.padding[i4 & 3];
      if (this.lastByteIndex === this.byteCount) {
        blocks[0] = blocks[blockCount];
        for (i4 = 1; i4 < blockCount + 1; ++i4) {
          blocks[i4] = 0;
        }
      }
      blocks[blockCount - 1] |= 2147483648;
      for (i4 = 0; i4 < blockCount; ++i4) {
        s2[i4] ^= blocks[i4];
      }
      f3(s2);
    };
    Keccak.prototype.toString = Keccak.prototype.hex = function() {
      this.finalize();
      var blockCount = this.blockCount, s2 = this.s, outputBlocks = this.outputBlocks, extraBytes = this.extraBytes, i4 = 0, j3 = 0;
      var hex = "", block;
      while (j3 < outputBlocks) {
        for (i4 = 0; i4 < blockCount && j3 < outputBlocks; ++i4, ++j3) {
          block = s2[i4];
          hex += HEX_CHARS[block >> 4 & 15] + HEX_CHARS[block & 15] + HEX_CHARS[block >> 12 & 15] + HEX_CHARS[block >> 8 & 15] + HEX_CHARS[block >> 20 & 15] + HEX_CHARS[block >> 16 & 15] + HEX_CHARS[block >> 28 & 15] + HEX_CHARS[block >> 24 & 15];
        }
        if (j3 % blockCount === 0) {
          f3(s2);
          i4 = 0;
        }
      }
      if (extraBytes) {
        block = s2[i4];
        hex += HEX_CHARS[block >> 4 & 15] + HEX_CHARS[block & 15];
        if (extraBytes > 1) {
          hex += HEX_CHARS[block >> 12 & 15] + HEX_CHARS[block >> 8 & 15];
        }
        if (extraBytes > 2) {
          hex += HEX_CHARS[block >> 20 & 15] + HEX_CHARS[block >> 16 & 15];
        }
      }
      return hex;
    };
    Keccak.prototype.arrayBuffer = function() {
      this.finalize();
      var blockCount = this.blockCount, s2 = this.s, outputBlocks = this.outputBlocks, extraBytes = this.extraBytes, i4 = 0, j3 = 0;
      var bytes = this.outputBits >> 3;
      var buffer;
      if (extraBytes) {
        buffer = new ArrayBuffer(outputBlocks + 1 << 2);
      } else {
        buffer = new ArrayBuffer(bytes);
      }
      var array = new Uint32Array(buffer);
      while (j3 < outputBlocks) {
        for (i4 = 0; i4 < blockCount && j3 < outputBlocks; ++i4, ++j3) {
          array[j3] = s2[i4];
        }
        if (j3 % blockCount === 0) {
          f3(s2);
        }
      }
      if (extraBytes) {
        array[i4] = s2[i4];
        buffer = buffer.slice(0, bytes);
      }
      return buffer;
    };
    Keccak.prototype.buffer = Keccak.prototype.arrayBuffer;
    Keccak.prototype.digest = Keccak.prototype.array = function() {
      this.finalize();
      var blockCount = this.blockCount, s2 = this.s, outputBlocks = this.outputBlocks, extraBytes = this.extraBytes, i4 = 0, j3 = 0;
      var array = [], offset, block;
      while (j3 < outputBlocks) {
        for (i4 = 0; i4 < blockCount && j3 < outputBlocks; ++i4, ++j3) {
          offset = j3 << 2;
          block = s2[i4];
          array[offset] = block & 255;
          array[offset + 1] = block >> 8 & 255;
          array[offset + 2] = block >> 16 & 255;
          array[offset + 3] = block >> 24 & 255;
        }
        if (j3 % blockCount === 0) {
          f3(s2);
        }
      }
      if (extraBytes) {
        offset = j3 << 2;
        block = s2[i4];
        array[offset] = block & 255;
        if (extraBytes > 1) {
          array[offset + 1] = block >> 8 & 255;
        }
        if (extraBytes > 2) {
          array[offset + 2] = block >> 16 & 255;
        }
      }
      return array;
    };
    function Kmac(bits2, padding, outputBits) {
      Keccak.call(this, bits2, padding, outputBits);
    }
    Kmac.prototype = new Keccak();
    Kmac.prototype.finalize = function() {
      this.encode(this.outputBits, true);
      return Keccak.prototype.finalize.call(this);
    };
    var f3 = function(s2) {
      var h4, l2, n4, c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b13, b14, b15, b16, b17, b18, b19, b20, b21, b22, b23, b24, b25, b26, b27, b28, b29, b30, b31, b32, b33, b34, b35, b36, b37, b38, b39, b40, b41, b42, b43, b44, b45, b46, b47, b48, b49;
      for (n4 = 0; n4 < 48; n4 += 2) {
        c0 = s2[0] ^ s2[10] ^ s2[20] ^ s2[30] ^ s2[40];
        c1 = s2[1] ^ s2[11] ^ s2[21] ^ s2[31] ^ s2[41];
        c2 = s2[2] ^ s2[12] ^ s2[22] ^ s2[32] ^ s2[42];
        c3 = s2[3] ^ s2[13] ^ s2[23] ^ s2[33] ^ s2[43];
        c4 = s2[4] ^ s2[14] ^ s2[24] ^ s2[34] ^ s2[44];
        c5 = s2[5] ^ s2[15] ^ s2[25] ^ s2[35] ^ s2[45];
        c6 = s2[6] ^ s2[16] ^ s2[26] ^ s2[36] ^ s2[46];
        c7 = s2[7] ^ s2[17] ^ s2[27] ^ s2[37] ^ s2[47];
        c8 = s2[8] ^ s2[18] ^ s2[28] ^ s2[38] ^ s2[48];
        c9 = s2[9] ^ s2[19] ^ s2[29] ^ s2[39] ^ s2[49];
        h4 = c8 ^ (c2 << 1 | c3 >>> 31);
        l2 = c9 ^ (c3 << 1 | c2 >>> 31);
        s2[0] ^= h4;
        s2[1] ^= l2;
        s2[10] ^= h4;
        s2[11] ^= l2;
        s2[20] ^= h4;
        s2[21] ^= l2;
        s2[30] ^= h4;
        s2[31] ^= l2;
        s2[40] ^= h4;
        s2[41] ^= l2;
        h4 = c0 ^ (c4 << 1 | c5 >>> 31);
        l2 = c1 ^ (c5 << 1 | c4 >>> 31);
        s2[2] ^= h4;
        s2[3] ^= l2;
        s2[12] ^= h4;
        s2[13] ^= l2;
        s2[22] ^= h4;
        s2[23] ^= l2;
        s2[32] ^= h4;
        s2[33] ^= l2;
        s2[42] ^= h4;
        s2[43] ^= l2;
        h4 = c2 ^ (c6 << 1 | c7 >>> 31);
        l2 = c3 ^ (c7 << 1 | c6 >>> 31);
        s2[4] ^= h4;
        s2[5] ^= l2;
        s2[14] ^= h4;
        s2[15] ^= l2;
        s2[24] ^= h4;
        s2[25] ^= l2;
        s2[34] ^= h4;
        s2[35] ^= l2;
        s2[44] ^= h4;
        s2[45] ^= l2;
        h4 = c4 ^ (c8 << 1 | c9 >>> 31);
        l2 = c5 ^ (c9 << 1 | c8 >>> 31);
        s2[6] ^= h4;
        s2[7] ^= l2;
        s2[16] ^= h4;
        s2[17] ^= l2;
        s2[26] ^= h4;
        s2[27] ^= l2;
        s2[36] ^= h4;
        s2[37] ^= l2;
        s2[46] ^= h4;
        s2[47] ^= l2;
        h4 = c6 ^ (c0 << 1 | c1 >>> 31);
        l2 = c7 ^ (c1 << 1 | c0 >>> 31);
        s2[8] ^= h4;
        s2[9] ^= l2;
        s2[18] ^= h4;
        s2[19] ^= l2;
        s2[28] ^= h4;
        s2[29] ^= l2;
        s2[38] ^= h4;
        s2[39] ^= l2;
        s2[48] ^= h4;
        s2[49] ^= l2;
        b0 = s2[0];
        b1 = s2[1];
        b32 = s2[11] << 4 | s2[10] >>> 28;
        b33 = s2[10] << 4 | s2[11] >>> 28;
        b14 = s2[20] << 3 | s2[21] >>> 29;
        b15 = s2[21] << 3 | s2[20] >>> 29;
        b46 = s2[31] << 9 | s2[30] >>> 23;
        b47 = s2[30] << 9 | s2[31] >>> 23;
        b28 = s2[40] << 18 | s2[41] >>> 14;
        b29 = s2[41] << 18 | s2[40] >>> 14;
        b20 = s2[2] << 1 | s2[3] >>> 31;
        b21 = s2[3] << 1 | s2[2] >>> 31;
        b2 = s2[13] << 12 | s2[12] >>> 20;
        b3 = s2[12] << 12 | s2[13] >>> 20;
        b34 = s2[22] << 10 | s2[23] >>> 22;
        b35 = s2[23] << 10 | s2[22] >>> 22;
        b16 = s2[33] << 13 | s2[32] >>> 19;
        b17 = s2[32] << 13 | s2[33] >>> 19;
        b48 = s2[42] << 2 | s2[43] >>> 30;
        b49 = s2[43] << 2 | s2[42] >>> 30;
        b40 = s2[5] << 30 | s2[4] >>> 2;
        b41 = s2[4] << 30 | s2[5] >>> 2;
        b22 = s2[14] << 6 | s2[15] >>> 26;
        b23 = s2[15] << 6 | s2[14] >>> 26;
        b4 = s2[25] << 11 | s2[24] >>> 21;
        b5 = s2[24] << 11 | s2[25] >>> 21;
        b36 = s2[34] << 15 | s2[35] >>> 17;
        b37 = s2[35] << 15 | s2[34] >>> 17;
        b18 = s2[45] << 29 | s2[44] >>> 3;
        b19 = s2[44] << 29 | s2[45] >>> 3;
        b10 = s2[6] << 28 | s2[7] >>> 4;
        b11 = s2[7] << 28 | s2[6] >>> 4;
        b42 = s2[17] << 23 | s2[16] >>> 9;
        b43 = s2[16] << 23 | s2[17] >>> 9;
        b24 = s2[26] << 25 | s2[27] >>> 7;
        b25 = s2[27] << 25 | s2[26] >>> 7;
        b6 = s2[36] << 21 | s2[37] >>> 11;
        b7 = s2[37] << 21 | s2[36] >>> 11;
        b38 = s2[47] << 24 | s2[46] >>> 8;
        b39 = s2[46] << 24 | s2[47] >>> 8;
        b30 = s2[8] << 27 | s2[9] >>> 5;
        b31 = s2[9] << 27 | s2[8] >>> 5;
        b12 = s2[18] << 20 | s2[19] >>> 12;
        b13 = s2[19] << 20 | s2[18] >>> 12;
        b44 = s2[29] << 7 | s2[28] >>> 25;
        b45 = s2[28] << 7 | s2[29] >>> 25;
        b26 = s2[38] << 8 | s2[39] >>> 24;
        b27 = s2[39] << 8 | s2[38] >>> 24;
        b8 = s2[48] << 14 | s2[49] >>> 18;
        b9 = s2[49] << 14 | s2[48] >>> 18;
        s2[0] = b0 ^ ~b2 & b4;
        s2[1] = b1 ^ ~b3 & b5;
        s2[10] = b10 ^ ~b12 & b14;
        s2[11] = b11 ^ ~b13 & b15;
        s2[20] = b20 ^ ~b22 & b24;
        s2[21] = b21 ^ ~b23 & b25;
        s2[30] = b30 ^ ~b32 & b34;
        s2[31] = b31 ^ ~b33 & b35;
        s2[40] = b40 ^ ~b42 & b44;
        s2[41] = b41 ^ ~b43 & b45;
        s2[2] = b2 ^ ~b4 & b6;
        s2[3] = b3 ^ ~b5 & b7;
        s2[12] = b12 ^ ~b14 & b16;
        s2[13] = b13 ^ ~b15 & b17;
        s2[22] = b22 ^ ~b24 & b26;
        s2[23] = b23 ^ ~b25 & b27;
        s2[32] = b32 ^ ~b34 & b36;
        s2[33] = b33 ^ ~b35 & b37;
        s2[42] = b42 ^ ~b44 & b46;
        s2[43] = b43 ^ ~b45 & b47;
        s2[4] = b4 ^ ~b6 & b8;
        s2[5] = b5 ^ ~b7 & b9;
        s2[14] = b14 ^ ~b16 & b18;
        s2[15] = b15 ^ ~b17 & b19;
        s2[24] = b24 ^ ~b26 & b28;
        s2[25] = b25 ^ ~b27 & b29;
        s2[34] = b34 ^ ~b36 & b38;
        s2[35] = b35 ^ ~b37 & b39;
        s2[44] = b44 ^ ~b46 & b48;
        s2[45] = b45 ^ ~b47 & b49;
        s2[6] = b6 ^ ~b8 & b0;
        s2[7] = b7 ^ ~b9 & b1;
        s2[16] = b16 ^ ~b18 & b10;
        s2[17] = b17 ^ ~b19 & b11;
        s2[26] = b26 ^ ~b28 & b20;
        s2[27] = b27 ^ ~b29 & b21;
        s2[36] = b36 ^ ~b38 & b30;
        s2[37] = b37 ^ ~b39 & b31;
        s2[46] = b46 ^ ~b48 & b40;
        s2[47] = b47 ^ ~b49 & b41;
        s2[8] = b8 ^ ~b0 & b2;
        s2[9] = b9 ^ ~b1 & b3;
        s2[18] = b18 ^ ~b10 & b12;
        s2[19] = b19 ^ ~b11 & b13;
        s2[28] = b28 ^ ~b20 & b22;
        s2[29] = b29 ^ ~b21 & b23;
        s2[38] = b38 ^ ~b30 & b32;
        s2[39] = b39 ^ ~b31 & b33;
        s2[48] = b48 ^ ~b40 & b42;
        s2[49] = b49 ^ ~b41 & b43;
        s2[0] ^= RC[n4];
        s2[1] ^= RC[n4 + 1];
      }
    };
    if (COMMON_JS) {
      module.exports = methods;
    } else {
      for (i3 = 0; i3 < methodNames.length; ++i3) {
        root[methodNames[i3]] = methods[methodNames[i3]];
      }
    }
  })();
})(sha3$1);
var sha3Exports = sha3$1.exports;
const sha3 = /* @__PURE__ */ getDefaultExportFromCjs(sha3Exports);
const version$5 = "logger/5.7.0";
let _permanentCensorErrors = false;
let _censorErrors = false;
const LogLevels = { debug: 1, "default": 2, info: 2, warning: 3, error: 4, off: 5 };
let _logLevel = LogLevels["default"];
let _globalLogger = null;
function _checkNormalize() {
  try {
    const missing = [];
    ["NFD", "NFC", "NFKD", "NFKC"].forEach((form) => {
      try {
        if ("test".normalize(form) !== "test") {
          throw new Error("bad normalize");
        }
        ;
      } catch (error2) {
        missing.push(form);
      }
    });
    if (missing.length) {
      throw new Error("missing " + missing.join(", "));
    }
    if (String.fromCharCode(233).normalize("NFD") !== String.fromCharCode(101, 769)) {
      throw new Error("broken implementation");
    }
  } catch (error2) {
    return error2.message;
  }
  return null;
}
const _normalizeError = _checkNormalize();
var LogLevel;
(function(LogLevel2) {
  LogLevel2["DEBUG"] = "DEBUG";
  LogLevel2["INFO"] = "INFO";
  LogLevel2["WARNING"] = "WARNING";
  LogLevel2["ERROR"] = "ERROR";
  LogLevel2["OFF"] = "OFF";
})(LogLevel || (LogLevel = {}));
var ErrorCode;
(function(ErrorCode2) {
  ErrorCode2["UNKNOWN_ERROR"] = "UNKNOWN_ERROR";
  ErrorCode2["NOT_IMPLEMENTED"] = "NOT_IMPLEMENTED";
  ErrorCode2["UNSUPPORTED_OPERATION"] = "UNSUPPORTED_OPERATION";
  ErrorCode2["NETWORK_ERROR"] = "NETWORK_ERROR";
  ErrorCode2["SERVER_ERROR"] = "SERVER_ERROR";
  ErrorCode2["TIMEOUT"] = "TIMEOUT";
  ErrorCode2["BUFFER_OVERRUN"] = "BUFFER_OVERRUN";
  ErrorCode2["NUMERIC_FAULT"] = "NUMERIC_FAULT";
  ErrorCode2["MISSING_NEW"] = "MISSING_NEW";
  ErrorCode2["INVALID_ARGUMENT"] = "INVALID_ARGUMENT";
  ErrorCode2["MISSING_ARGUMENT"] = "MISSING_ARGUMENT";
  ErrorCode2["UNEXPECTED_ARGUMENT"] = "UNEXPECTED_ARGUMENT";
  ErrorCode2["CALL_EXCEPTION"] = "CALL_EXCEPTION";
  ErrorCode2["INSUFFICIENT_FUNDS"] = "INSUFFICIENT_FUNDS";
  ErrorCode2["NONCE_EXPIRED"] = "NONCE_EXPIRED";
  ErrorCode2["REPLACEMENT_UNDERPRICED"] = "REPLACEMENT_UNDERPRICED";
  ErrorCode2["UNPREDICTABLE_GAS_LIMIT"] = "UNPREDICTABLE_GAS_LIMIT";
  ErrorCode2["TRANSACTION_REPLACED"] = "TRANSACTION_REPLACED";
  ErrorCode2["ACTION_REJECTED"] = "ACTION_REJECTED";
})(ErrorCode || (ErrorCode = {}));
const HEX = "0123456789abcdef";
class Logger {
  constructor(version2) {
    Object.defineProperty(this, "version", {
      enumerable: true,
      value: version2,
      writable: false
    });
  }
  _log(logLevel, args) {
    const level = logLevel.toLowerCase();
    if (LogLevels[level] == null) {
      this.throwArgumentError("invalid log level name", "logLevel", logLevel);
    }
    if (_logLevel > LogLevels[level]) {
      return;
    }
    console.log.apply(console, args);
  }
  debug(...args) {
    this._log(Logger.levels.DEBUG, args);
  }
  info(...args) {
    this._log(Logger.levels.INFO, args);
  }
  warn(...args) {
    this._log(Logger.levels.WARNING, args);
  }
  makeError(message, code, params) {
    if (_censorErrors) {
      return this.makeError("censored error", code, {});
    }
    if (!code) {
      code = Logger.errors.UNKNOWN_ERROR;
    }
    if (!params) {
      params = {};
    }
    const messageDetails = [];
    Object.keys(params).forEach((key2) => {
      const value = params[key2];
      try {
        if (value instanceof Uint8Array) {
          let hex = "";
          for (let i3 = 0; i3 < value.length; i3++) {
            hex += HEX[value[i3] >> 4];
            hex += HEX[value[i3] & 15];
          }
          messageDetails.push(key2 + "=Uint8Array(0x" + hex + ")");
        } else {
          messageDetails.push(key2 + "=" + JSON.stringify(value));
        }
      } catch (error3) {
        messageDetails.push(key2 + "=" + JSON.stringify(params[key2].toString()));
      }
    });
    messageDetails.push(`code=${code}`);
    messageDetails.push(`version=${this.version}`);
    const reason = message;
    let url = "";
    switch (code) {
      case ErrorCode.NUMERIC_FAULT: {
        url = "NUMERIC_FAULT";
        const fault = message;
        switch (fault) {
          case "overflow":
          case "underflow":
          case "division-by-zero":
            url += "-" + fault;
            break;
          case "negative-power":
          case "negative-width":
            url += "-unsupported";
            break;
          case "unbound-bitwise-result":
            url += "-unbound-result";
            break;
        }
        break;
      }
      case ErrorCode.CALL_EXCEPTION:
      case ErrorCode.INSUFFICIENT_FUNDS:
      case ErrorCode.MISSING_NEW:
      case ErrorCode.NONCE_EXPIRED:
      case ErrorCode.REPLACEMENT_UNDERPRICED:
      case ErrorCode.TRANSACTION_REPLACED:
      case ErrorCode.UNPREDICTABLE_GAS_LIMIT:
        url = code;
        break;
    }
    if (url) {
      message += " [ See: https://links.ethers.org/v5-errors-" + url + " ]";
    }
    if (messageDetails.length) {
      message += " (" + messageDetails.join(", ") + ")";
    }
    const error2 = new Error(message);
    error2.reason = reason;
    error2.code = code;
    Object.keys(params).forEach(function(key2) {
      error2[key2] = params[key2];
    });
    return error2;
  }
  throwError(message, code, params) {
    throw this.makeError(message, code, params);
  }
  throwArgumentError(message, name2, value) {
    return this.throwError(message, Logger.errors.INVALID_ARGUMENT, {
      argument: name2,
      value
    });
  }
  assert(condition, message, code, params) {
    if (!!condition) {
      return;
    }
    this.throwError(message, code, params);
  }
  assertArgument(condition, message, name2, value) {
    if (!!condition) {
      return;
    }
    this.throwArgumentError(message, name2, value);
  }
  checkNormalize(message) {
    if (_normalizeError) {
      this.throwError("platform missing String.prototype.normalize", Logger.errors.UNSUPPORTED_OPERATION, {
        operation: "String.prototype.normalize",
        form: _normalizeError
      });
    }
  }
  checkSafeUint53(value, message) {
    if (typeof value !== "number") {
      return;
    }
    if (message == null) {
      message = "value not safe";
    }
    if (value < 0 || value >= 9007199254740991) {
      this.throwError(message, Logger.errors.NUMERIC_FAULT, {
        operation: "checkSafeInteger",
        fault: "out-of-safe-range",
        value
      });
    }
    if (value % 1) {
      this.throwError(message, Logger.errors.NUMERIC_FAULT, {
        operation: "checkSafeInteger",
        fault: "non-integer",
        value
      });
    }
  }
  checkArgumentCount(count, expectedCount, message) {
    if (message) {
      message = ": " + message;
    } else {
      message = "";
    }
    if (count < expectedCount) {
      this.throwError("missing argument" + message, Logger.errors.MISSING_ARGUMENT, {
        count,
        expectedCount
      });
    }
    if (count > expectedCount) {
      this.throwError("too many arguments" + message, Logger.errors.UNEXPECTED_ARGUMENT, {
        count,
        expectedCount
      });
    }
  }
  checkNew(target, kind) {
    if (target === Object || target == null) {
      this.throwError("missing new", Logger.errors.MISSING_NEW, { name: kind.name });
    }
  }
  checkAbstract(target, kind) {
    if (target === kind) {
      this.throwError("cannot instantiate abstract class " + JSON.stringify(kind.name) + " directly; use a sub-class", Logger.errors.UNSUPPORTED_OPERATION, { name: target.name, operation: "new" });
    } else if (target === Object || target == null) {
      this.throwError("missing new", Logger.errors.MISSING_NEW, { name: kind.name });
    }
  }
  static globalLogger() {
    if (!_globalLogger) {
      _globalLogger = new Logger(version$5);
    }
    return _globalLogger;
  }
  static setCensorship(censorship, permanent) {
    if (!censorship && permanent) {
      this.globalLogger().throwError("cannot permanently disable censorship", Logger.errors.UNSUPPORTED_OPERATION, {
        operation: "setCensorship"
      });
    }
    if (_permanentCensorErrors) {
      if (!censorship) {
        return;
      }
      this.globalLogger().throwError("error censorship permanent", Logger.errors.UNSUPPORTED_OPERATION, {
        operation: "setCensorship"
      });
    }
    _censorErrors = !!censorship;
    _permanentCensorErrors = !!permanent;
  }
  static setLogLevel(logLevel) {
    const level = LogLevels[logLevel.toLowerCase()];
    if (level == null) {
      Logger.globalLogger().warn("invalid log level - " + logLevel);
      return;
    }
    _logLevel = level;
  }
  static from(version2) {
    return new Logger(version2);
  }
}
Logger.errors = ErrorCode;
Logger.levels = LogLevel;
const version$4 = "bytes/5.7.0";
const logger$3 = new Logger(version$4);
function isHexable(value) {
  return !!value.toHexString;
}
function addSlice(array) {
  if (array.slice) {
    return array;
  }
  array.slice = function() {
    const args = Array.prototype.slice.call(arguments);
    return addSlice(new Uint8Array(Array.prototype.slice.apply(array, args)));
  };
  return array;
}
function isBytesLike(value) {
  return isHexString(value) && !(value.length % 2) || isBytes(value);
}
function isInteger(value) {
  return typeof value === "number" && value == value && value % 1 === 0;
}
function isBytes(value) {
  if (value == null) {
    return false;
  }
  if (value.constructor === Uint8Array) {
    return true;
  }
  if (typeof value === "string") {
    return false;
  }
  if (!isInteger(value.length) || value.length < 0) {
    return false;
  }
  for (let i3 = 0; i3 < value.length; i3++) {
    const v3 = value[i3];
    if (!isInteger(v3) || v3 < 0 || v3 >= 256) {
      return false;
    }
  }
  return true;
}
function arrayify(value, options) {
  if (!options) {
    options = {};
  }
  if (typeof value === "number") {
    logger$3.checkSafeUint53(value, "invalid arrayify value");
    const result = [];
    while (value) {
      result.unshift(value & 255);
      value = parseInt(String(value / 256));
    }
    if (result.length === 0) {
      result.push(0);
    }
    return addSlice(new Uint8Array(result));
  }
  if (options.allowMissingPrefix && typeof value === "string" && value.substring(0, 2) !== "0x") {
    value = "0x" + value;
  }
  if (isHexable(value)) {
    value = value.toHexString();
  }
  if (isHexString(value)) {
    let hex = value.substring(2);
    if (hex.length % 2) {
      if (options.hexPad === "left") {
        hex = "0" + hex;
      } else if (options.hexPad === "right") {
        hex += "0";
      } else {
        logger$3.throwArgumentError("hex data is odd-length", "value", value);
      }
    }
    const result = [];
    for (let i3 = 0; i3 < hex.length; i3 += 2) {
      result.push(parseInt(hex.substring(i3, i3 + 2), 16));
    }
    return addSlice(new Uint8Array(result));
  }
  if (isBytes(value)) {
    return addSlice(new Uint8Array(value));
  }
  return logger$3.throwArgumentError("invalid arrayify value", "value", value);
}
function concat(items) {
  const objects = items.map((item) => arrayify(item));
  const length = objects.reduce((accum, item) => accum + item.length, 0);
  const result = new Uint8Array(length);
  objects.reduce((offset, object) => {
    result.set(object, offset);
    return offset + object.length;
  }, 0);
  return addSlice(result);
}
function zeroPad(value, length) {
  value = arrayify(value);
  if (value.length > length) {
    logger$3.throwArgumentError("value out of range", "value", arguments[0]);
  }
  const result = new Uint8Array(length);
  result.set(value, length - value.length);
  return addSlice(result);
}
function isHexString(value, length) {
  if (typeof value !== "string" || !value.match(/^0x[0-9A-Fa-f]*$/)) {
    return false;
  }
  if (length && value.length !== 2 + 2 * length) {
    return false;
  }
  return true;
}
const HexCharacters = "0123456789abcdef";
function hexlify(value, options) {
  if (!options) {
    options = {};
  }
  if (typeof value === "number") {
    logger$3.checkSafeUint53(value, "invalid hexlify value");
    let hex = "";
    while (value) {
      hex = HexCharacters[value & 15] + hex;
      value = Math.floor(value / 16);
    }
    if (hex.length) {
      if (hex.length % 2) {
        hex = "0" + hex;
      }
      return "0x" + hex;
    }
    return "0x00";
  }
  if (typeof value === "bigint") {
    value = value.toString(16);
    if (value.length % 2) {
      return "0x0" + value;
    }
    return "0x" + value;
  }
  if (options.allowMissingPrefix && typeof value === "string" && value.substring(0, 2) !== "0x") {
    value = "0x" + value;
  }
  if (isHexable(value)) {
    return value.toHexString();
  }
  if (isHexString(value)) {
    if (value.length % 2) {
      if (options.hexPad === "left") {
        value = "0x0" + value.substring(2);
      } else if (options.hexPad === "right") {
        value += "0";
      } else {
        logger$3.throwArgumentError("hex data is odd-length", "value", value);
      }
    }
    return value.toLowerCase();
  }
  if (isBytes(value)) {
    let result = "0x";
    for (let i3 = 0; i3 < value.length; i3++) {
      let v3 = value[i3];
      result += HexCharacters[(v3 & 240) >> 4] + HexCharacters[v3 & 15];
    }
    return result;
  }
  return logger$3.throwArgumentError("invalid hexlify value", "value", value);
}
function hexDataLength(data) {
  if (typeof data !== "string") {
    data = hexlify(data);
  } else if (!isHexString(data) || data.length % 2) {
    return null;
  }
  return (data.length - 2) / 2;
}
function hexDataSlice(data, offset, endOffset) {
  if (typeof data !== "string") {
    data = hexlify(data);
  } else if (!isHexString(data) || data.length % 2) {
    logger$3.throwArgumentError("invalid hexData", "value", data);
  }
  offset = 2 + 2 * offset;
  return "0x" + data.substring(offset);
}
function hexZeroPad(value, length) {
  if (typeof value !== "string") {
    value = hexlify(value);
  } else if (!isHexString(value)) {
    logger$3.throwArgumentError("invalid hex string", "value", value);
  }
  if (value.length > 2 * length + 2) {
    logger$3.throwArgumentError("value out of range", "value", arguments[1]);
  }
  while (value.length < 2 * length + 2) {
    value = "0x0" + value.substring(2);
  }
  return value;
}
function splitSignature(signature2) {
  const result = {
    r: "0x",
    s: "0x",
    _vs: "0x",
    recoveryParam: 0,
    v: 0,
    yParityAndS: "0x",
    compact: "0x"
  };
  if (isBytesLike(signature2)) {
    let bytes = arrayify(signature2);
    if (bytes.length === 64) {
      result.v = 27 + (bytes[32] >> 7);
      bytes[32] &= 127;
      result.r = hexlify(bytes.slice(0, 32));
      result.s = hexlify(bytes.slice(32, 64));
    } else if (bytes.length === 65) {
      result.r = hexlify(bytes.slice(0, 32));
      result.s = hexlify(bytes.slice(32, 64));
      result.v = bytes[64];
    } else {
      logger$3.throwArgumentError("invalid signature string", "signature", signature2);
    }
    if (result.v < 27) {
      if (result.v === 0 || result.v === 1) {
        result.v += 27;
      } else {
        logger$3.throwArgumentError("signature invalid v byte", "signature", signature2);
      }
    }
    result.recoveryParam = 1 - result.v % 2;
    if (result.recoveryParam) {
      bytes[32] |= 128;
    }
    result._vs = hexlify(bytes.slice(32, 64));
  } else {
    result.r = signature2.r;
    result.s = signature2.s;
    result.v = signature2.v;
    result.recoveryParam = signature2.recoveryParam;
    result._vs = signature2._vs;
    if (result._vs != null) {
      const vs3 = zeroPad(arrayify(result._vs), 32);
      result._vs = hexlify(vs3);
      const recoveryParam = vs3[0] >= 128 ? 1 : 0;
      if (result.recoveryParam == null) {
        result.recoveryParam = recoveryParam;
      } else if (result.recoveryParam !== recoveryParam) {
        logger$3.throwArgumentError("signature recoveryParam mismatch _vs", "signature", signature2);
      }
      vs3[0] &= 127;
      const s2 = hexlify(vs3);
      if (result.s == null) {
        result.s = s2;
      } else if (result.s !== s2) {
        logger$3.throwArgumentError("signature v mismatch _vs", "signature", signature2);
      }
    }
    if (result.recoveryParam == null) {
      if (result.v == null) {
        logger$3.throwArgumentError("signature missing v and recoveryParam", "signature", signature2);
      } else if (result.v === 0 || result.v === 1) {
        result.recoveryParam = result.v;
      } else {
        result.recoveryParam = 1 - result.v % 2;
      }
    } else {
      if (result.v == null) {
        result.v = 27 + result.recoveryParam;
      } else {
        const recId = result.v === 0 || result.v === 1 ? result.v : 1 - result.v % 2;
        if (result.recoveryParam !== recId) {
          logger$3.throwArgumentError("signature recoveryParam mismatch v", "signature", signature2);
        }
      }
    }
    if (result.r == null || !isHexString(result.r)) {
      logger$3.throwArgumentError("signature missing or invalid r", "signature", signature2);
    } else {
      result.r = hexZeroPad(result.r, 32);
    }
    if (result.s == null || !isHexString(result.s)) {
      logger$3.throwArgumentError("signature missing or invalid s", "signature", signature2);
    } else {
      result.s = hexZeroPad(result.s, 32);
    }
    const vs2 = arrayify(result.s);
    if (vs2[0] >= 128) {
      logger$3.throwArgumentError("signature s out of range", "signature", signature2);
    }
    if (result.recoveryParam) {
      vs2[0] |= 128;
    }
    const _vs = hexlify(vs2);
    if (result._vs) {
      if (!isHexString(result._vs)) {
        logger$3.throwArgumentError("signature invalid _vs", "signature", signature2);
      }
      result._vs = hexZeroPad(result._vs, 32);
    }
    if (result._vs == null) {
      result._vs = _vs;
    } else if (result._vs !== _vs) {
      logger$3.throwArgumentError("signature _vs mismatch v and s", "signature", signature2);
    }
  }
  result.yParityAndS = result._vs;
  result.compact = result.r + result.yParityAndS.substring(2);
  return result;
}
function keccak256(data) {
  return "0x" + sha3.keccak_256(arrayify(data));
}
var BN$8 = BN$9.BN;
function _base36To16(value) {
  return new BN$8(value, 36).toString(16);
}
const version$3 = "strings/5.7.0";
const logger$2 = new Logger(version$3);
var UnicodeNormalizationForm;
(function(UnicodeNormalizationForm2) {
  UnicodeNormalizationForm2["current"] = "";
  UnicodeNormalizationForm2["NFC"] = "NFC";
  UnicodeNormalizationForm2["NFD"] = "NFD";
  UnicodeNormalizationForm2["NFKC"] = "NFKC";
  UnicodeNormalizationForm2["NFKD"] = "NFKD";
})(UnicodeNormalizationForm || (UnicodeNormalizationForm = {}));
var Utf8ErrorReason;
(function(Utf8ErrorReason2) {
  Utf8ErrorReason2["UNEXPECTED_CONTINUE"] = "unexpected continuation byte";
  Utf8ErrorReason2["BAD_PREFIX"] = "bad codepoint prefix";
  Utf8ErrorReason2["OVERRUN"] = "string overrun";
  Utf8ErrorReason2["MISSING_CONTINUE"] = "missing continuation byte";
  Utf8ErrorReason2["OUT_OF_RANGE"] = "out of UTF-8 range";
  Utf8ErrorReason2["UTF16_SURROGATE"] = "UTF-16 surrogate";
  Utf8ErrorReason2["OVERLONG"] = "overlong representation";
})(Utf8ErrorReason || (Utf8ErrorReason = {}));
function toUtf8Bytes(str, form = UnicodeNormalizationForm.current) {
  if (form != UnicodeNormalizationForm.current) {
    logger$2.checkNormalize();
    str = str.normalize(form);
  }
  let result = [];
  for (let i3 = 0; i3 < str.length; i3++) {
    const c2 = str.charCodeAt(i3);
    if (c2 < 128) {
      result.push(c2);
    } else if (c2 < 2048) {
      result.push(c2 >> 6 | 192);
      result.push(c2 & 63 | 128);
    } else if ((c2 & 64512) == 55296) {
      i3++;
      const c22 = str.charCodeAt(i3);
      if (i3 >= str.length || (c22 & 64512) !== 56320) {
        throw new Error("invalid utf-8 string");
      }
      const pair = 65536 + ((c2 & 1023) << 10) + (c22 & 1023);
      result.push(pair >> 18 | 240);
      result.push(pair >> 12 & 63 | 128);
      result.push(pair >> 6 & 63 | 128);
      result.push(pair & 63 | 128);
    } else {
      result.push(c2 >> 12 | 224);
      result.push(c2 >> 6 & 63 | 128);
      result.push(c2 & 63 | 128);
    }
  }
  return arrayify(result);
}
const messagePrefix = "Ethereum Signed Message:\n";
function hashMessage(message) {
  if (typeof message === "string") {
    message = toUtf8Bytes(message);
  }
  return keccak256(concat([
    toUtf8Bytes(messagePrefix),
    toUtf8Bytes(String(message.length)),
    message
  ]));
}
const version$2 = "address/5.7.0";
const logger$1 = new Logger(version$2);
function getChecksumAddress(address) {
  if (!isHexString(address, 20)) {
    logger$1.throwArgumentError("invalid address", "address", address);
  }
  address = address.toLowerCase();
  const chars = address.substring(2).split("");
  const expanded = new Uint8Array(40);
  for (let i3 = 0; i3 < 40; i3++) {
    expanded[i3] = chars[i3].charCodeAt(0);
  }
  const hashed = arrayify(keccak256(expanded));
  for (let i3 = 0; i3 < 40; i3 += 2) {
    if (hashed[i3 >> 1] >> 4 >= 8) {
      chars[i3] = chars[i3].toUpperCase();
    }
    if ((hashed[i3 >> 1] & 15) >= 8) {
      chars[i3 + 1] = chars[i3 + 1].toUpperCase();
    }
  }
  return "0x" + chars.join("");
}
const MAX_SAFE_INTEGER = 9007199254740991;
function log10(x3) {
  if (Math.log10) {
    return Math.log10(x3);
  }
  return Math.log(x3) / Math.LN10;
}
const ibanLookup = {};
for (let i3 = 0; i3 < 10; i3++) {
  ibanLookup[String(i3)] = String(i3);
}
for (let i3 = 0; i3 < 26; i3++) {
  ibanLookup[String.fromCharCode(65 + i3)] = String(10 + i3);
}
const safeDigits = Math.floor(log10(MAX_SAFE_INTEGER));
function ibanChecksum(address) {
  address = address.toUpperCase();
  address = address.substring(4) + address.substring(0, 2) + "00";
  let expanded = address.split("").map((c2) => {
    return ibanLookup[c2];
  }).join("");
  while (expanded.length >= safeDigits) {
    let block = expanded.substring(0, safeDigits);
    expanded = parseInt(block, 10) % 97 + expanded.substring(block.length);
  }
  let checksum = String(98 - parseInt(expanded, 10) % 97);
  while (checksum.length < 2) {
    checksum = "0" + checksum;
  }
  return checksum;
}
function getAddress(address) {
  let result = null;
  if (typeof address !== "string") {
    logger$1.throwArgumentError("invalid address", "address", address);
  }
  if (address.match(/^(0x)?[0-9a-fA-F]{40}$/)) {
    if (address.substring(0, 2) !== "0x") {
      address = "0x" + address;
    }
    result = getChecksumAddress(address);
    if (address.match(/([A-F].*[a-f])|([a-f].*[A-F])/) && result !== address) {
      logger$1.throwArgumentError("bad address checksum", "address", address);
    }
  } else if (address.match(/^XE[0-9]{2}[0-9A-Za-z]{30,31}$/)) {
    if (address.substring(2, 4) !== ibanChecksum(address)) {
      logger$1.throwArgumentError("bad icap checksum", "address", address);
    }
    result = _base36To16(address.substring(4));
    while (result.length < 40) {
      result = "0" + result;
    }
    result = getChecksumAddress("0x" + result);
  } else {
    logger$1.throwArgumentError("invalid address", "address", address);
  }
  return result;
}
(function(thisArg, _arguments, P2, generator) {
  function adopt(value) {
    return value instanceof P2 ? value : new P2(function(resolve) {
      resolve(value);
    });
  }
  return new (P2 || (P2 = Promise))(function(resolve, reject) {
    function fulfilled(value) {
      try {
        step(generator.next(value));
      } catch (e2) {
        reject(e2);
      }
    }
    function rejected(value) {
      try {
        step(generator["throw"](value));
      } catch (e2) {
        reject(e2);
      }
    }
    function step(result) {
      result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected);
    }
    step((generator = generator.apply(thisArg, _arguments || [])).next());
  });
});
function defineReadOnly(object, name2, value) {
  Object.defineProperty(object, name2, {
    enumerable: true,
    value,
    writable: false
  });
}
function createCommonjsModule(fn, basedir, module) {
  return module = {
    path: basedir,
    exports: {},
    require: function(path, base3) {
      return commonjsRequire(path, base3 === void 0 || base3 === null ? module.path : base3);
    }
  }, fn(module, module.exports), module.exports;
}
function commonjsRequire() {
  throw new Error("Dynamic requires are not currently supported by @rollup/plugin-commonjs");
}
var minimalisticAssert = assert$9;
function assert$9(val, msg) {
  if (!val)
    throw new Error(msg || "Assertion failed");
}
assert$9.equal = function assertEqual(l2, r2, msg) {
  if (l2 != r2)
    throw new Error(msg || "Assertion failed: " + l2 + " != " + r2);
};
var utils_1 = createCommonjsModule(function(module, exports) {
  var utils2 = exports;
  function toArray(msg, enc) {
    if (Array.isArray(msg))
      return msg.slice();
    if (!msg)
      return [];
    var res = [];
    if (typeof msg !== "string") {
      for (var i3 = 0; i3 < msg.length; i3++)
        res[i3] = msg[i3] | 0;
      return res;
    }
    if (enc === "hex") {
      msg = msg.replace(/[^a-z0-9]+/ig, "");
      if (msg.length % 2 !== 0)
        msg = "0" + msg;
      for (var i3 = 0; i3 < msg.length; i3 += 2)
        res.push(parseInt(msg[i3] + msg[i3 + 1], 16));
    } else {
      for (var i3 = 0; i3 < msg.length; i3++) {
        var c2 = msg.charCodeAt(i3);
        var hi2 = c2 >> 8;
        var lo2 = c2 & 255;
        if (hi2)
          res.push(hi2, lo2);
        else
          res.push(lo2);
      }
    }
    return res;
  }
  utils2.toArray = toArray;
  function zero2(word) {
    if (word.length === 1)
      return "0" + word;
    else
      return word;
  }
  utils2.zero2 = zero2;
  function toHex2(msg) {
    var res = "";
    for (var i3 = 0; i3 < msg.length; i3++)
      res += zero2(msg[i3].toString(16));
    return res;
  }
  utils2.toHex = toHex2;
  utils2.encode = function encode4(arr, enc) {
    if (enc === "hex")
      return toHex2(arr);
    else
      return arr;
  };
});
var utils_1$1 = createCommonjsModule(function(module, exports) {
  var utils2 = exports;
  utils2.assert = minimalisticAssert;
  utils2.toArray = utils_1.toArray;
  utils2.zero2 = utils_1.zero2;
  utils2.toHex = utils_1.toHex;
  utils2.encode = utils_1.encode;
  function getNAF2(num, w2, bits) {
    var naf = new Array(Math.max(num.bitLength(), bits) + 1);
    naf.fill(0);
    var ws2 = 1 << w2 + 1;
    var k2 = num.clone();
    for (var i3 = 0; i3 < naf.length; i3++) {
      var z2;
      var mod = k2.andln(ws2 - 1);
      if (k2.isOdd()) {
        if (mod > (ws2 >> 1) - 1)
          z2 = (ws2 >> 1) - mod;
        else
          z2 = mod;
        k2.isubn(z2);
      } else {
        z2 = 0;
      }
      naf[i3] = z2;
      k2.iushrn(1);
    }
    return naf;
  }
  utils2.getNAF = getNAF2;
  function getJSF2(k1, k2) {
    var jsf = [
      [],
      []
    ];
    k1 = k1.clone();
    k2 = k2.clone();
    var d1 = 0;
    var d22 = 0;
    var m8;
    while (k1.cmpn(-d1) > 0 || k2.cmpn(-d22) > 0) {
      var m14 = k1.andln(3) + d1 & 3;
      var m24 = k2.andln(3) + d22 & 3;
      if (m14 === 3)
        m14 = -1;
      if (m24 === 3)
        m24 = -1;
      var u1;
      if ((m14 & 1) === 0) {
        u1 = 0;
      } else {
        m8 = k1.andln(7) + d1 & 7;
        if ((m8 === 3 || m8 === 5) && m24 === 2)
          u1 = -m14;
        else
          u1 = m14;
      }
      jsf[0].push(u1);
      var u2;
      if ((m24 & 1) === 0) {
        u2 = 0;
      } else {
        m8 = k2.andln(7) + d22 & 7;
        if ((m8 === 3 || m8 === 5) && m14 === 2)
          u2 = -m24;
        else
          u2 = m24;
      }
      jsf[1].push(u2);
      if (2 * d1 === u1 + 1)
        d1 = 1 - d1;
      if (2 * d22 === u2 + 1)
        d22 = 1 - d22;
      k1.iushrn(1);
      k2.iushrn(1);
    }
    return jsf;
  }
  utils2.getJSF = getJSF2;
  function cachedProperty2(obj, name2, computer) {
    var key2 = "_" + name2;
    obj.prototype[name2] = function cachedProperty3() {
      return this[key2] !== void 0 ? this[key2] : this[key2] = computer.call(this);
    };
  }
  utils2.cachedProperty = cachedProperty2;
  function parseBytes2(bytes) {
    return typeof bytes === "string" ? utils2.toArray(bytes, "hex") : bytes;
  }
  utils2.parseBytes = parseBytes2;
  function intFromLE(bytes) {
    return new BN$9(bytes, "hex", "le");
  }
  utils2.intFromLE = intFromLE;
});
var getNAF$1 = utils_1$1.getNAF;
var getJSF$1 = utils_1$1.getJSF;
var assert$1$1 = utils_1$1.assert;
function BaseCurve$1(type, conf) {
  this.type = type;
  this.p = new BN$9(conf.p, 16);
  this.red = conf.prime ? BN$9.red(conf.prime) : BN$9.mont(this.p);
  this.zero = new BN$9(0).toRed(this.red);
  this.one = new BN$9(1).toRed(this.red);
  this.two = new BN$9(2).toRed(this.red);
  this.n = conf.n && new BN$9(conf.n, 16);
  this.g = conf.g && this.pointFromJSON(conf.g, conf.gRed);
  this._wnafT1 = new Array(4);
  this._wnafT2 = new Array(4);
  this._wnafT3 = new Array(4);
  this._wnafT4 = new Array(4);
  this._bitLength = this.n ? this.n.bitLength() : 0;
  var adjustCount = this.n && this.p.div(this.n);
  if (!adjustCount || adjustCount.cmpn(100) > 0) {
    this.redN = null;
  } else {
    this._maxwellTrick = true;
    this.redN = this.n.toRed(this.red);
  }
}
var base$1 = BaseCurve$1;
BaseCurve$1.prototype.point = function point() {
  throw new Error("Not implemented");
};
BaseCurve$1.prototype.validate = function validate() {
  throw new Error("Not implemented");
};
BaseCurve$1.prototype._fixedNafMul = function _fixedNafMul(p3, k2) {
  assert$1$1(p3.precomputed);
  var doubles = p3._getDoubles();
  var naf = getNAF$1(k2, 1, this._bitLength);
  var I2 = (1 << doubles.step + 1) - (doubles.step % 2 === 0 ? 2 : 1);
  I2 /= 3;
  var repr = [];
  var j2;
  var nafW;
  for (j2 = 0; j2 < naf.length; j2 += doubles.step) {
    nafW = 0;
    for (var l2 = j2 + doubles.step - 1; l2 >= j2; l2--)
      nafW = (nafW << 1) + naf[l2];
    repr.push(nafW);
  }
  var a3 = this.jpoint(null, null, null);
  var b2 = this.jpoint(null, null, null);
  for (var i3 = I2; i3 > 0; i3--) {
    for (j2 = 0; j2 < repr.length; j2++) {
      nafW = repr[j2];
      if (nafW === i3)
        b2 = b2.mixedAdd(doubles.points[j2]);
      else if (nafW === -i3)
        b2 = b2.mixedAdd(doubles.points[j2].neg());
    }
    a3 = a3.add(b2);
  }
  return a3.toP();
};
BaseCurve$1.prototype._wnafMul = function _wnafMul(p3, k2) {
  var w2 = 4;
  var nafPoints = p3._getNAFPoints(w2);
  w2 = nafPoints.wnd;
  var wnd = nafPoints.points;
  var naf = getNAF$1(k2, w2, this._bitLength);
  var acc = this.jpoint(null, null, null);
  for (var i3 = naf.length - 1; i3 >= 0; i3--) {
    for (var l2 = 0; i3 >= 0 && naf[i3] === 0; i3--)
      l2++;
    if (i3 >= 0)
      l2++;
    acc = acc.dblp(l2);
    if (i3 < 0)
      break;
    var z2 = naf[i3];
    assert$1$1(z2 !== 0);
    if (p3.type === "affine") {
      if (z2 > 0)
        acc = acc.mixedAdd(wnd[z2 - 1 >> 1]);
      else
        acc = acc.mixedAdd(wnd[-z2 - 1 >> 1].neg());
    } else {
      if (z2 > 0)
        acc = acc.add(wnd[z2 - 1 >> 1]);
      else
        acc = acc.add(wnd[-z2 - 1 >> 1].neg());
    }
  }
  return p3.type === "affine" ? acc.toP() : acc;
};
BaseCurve$1.prototype._wnafMulAdd = function _wnafMulAdd(defW, points, coeffs, len, jacobianResult) {
  var wndWidth = this._wnafT1;
  var wnd = this._wnafT2;
  var naf = this._wnafT3;
  var max = 0;
  var i3;
  var j2;
  var p3;
  for (i3 = 0; i3 < len; i3++) {
    p3 = points[i3];
    var nafPoints = p3._getNAFPoints(defW);
    wndWidth[i3] = nafPoints.wnd;
    wnd[i3] = nafPoints.points;
  }
  for (i3 = len - 1; i3 >= 1; i3 -= 2) {
    var a3 = i3 - 1;
    var b2 = i3;
    if (wndWidth[a3] !== 1 || wndWidth[b2] !== 1) {
      naf[a3] = getNAF$1(coeffs[a3], wndWidth[a3], this._bitLength);
      naf[b2] = getNAF$1(coeffs[b2], wndWidth[b2], this._bitLength);
      max = Math.max(naf[a3].length, max);
      max = Math.max(naf[b2].length, max);
      continue;
    }
    var comb = [
      points[a3],
      /* 1 */
      null,
      /* 3 */
      null,
      /* 5 */
      points[b2]
      /* 7 */
    ];
    if (points[a3].y.cmp(points[b2].y) === 0) {
      comb[1] = points[a3].add(points[b2]);
      comb[2] = points[a3].toJ().mixedAdd(points[b2].neg());
    } else if (points[a3].y.cmp(points[b2].y.redNeg()) === 0) {
      comb[1] = points[a3].toJ().mixedAdd(points[b2]);
      comb[2] = points[a3].add(points[b2].neg());
    } else {
      comb[1] = points[a3].toJ().mixedAdd(points[b2]);
      comb[2] = points[a3].toJ().mixedAdd(points[b2].neg());
    }
    var index = [
      -3,
      /* -1 -1 */
      -1,
      /* -1 0 */
      -5,
      /* -1 1 */
      -7,
      /* 0 -1 */
      0,
      /* 0 0 */
      7,
      /* 0 1 */
      5,
      /* 1 -1 */
      1,
      /* 1 0 */
      3
      /* 1 1 */
    ];
    var jsf = getJSF$1(coeffs[a3], coeffs[b2]);
    max = Math.max(jsf[0].length, max);
    naf[a3] = new Array(max);
    naf[b2] = new Array(max);
    for (j2 = 0; j2 < max; j2++) {
      var ja = jsf[0][j2] | 0;
      var jb = jsf[1][j2] | 0;
      naf[a3][j2] = index[(ja + 1) * 3 + (jb + 1)];
      naf[b2][j2] = 0;
      wnd[a3] = comb;
    }
  }
  var acc = this.jpoint(null, null, null);
  var tmp = this._wnafT4;
  for (i3 = max; i3 >= 0; i3--) {
    var k2 = 0;
    while (i3 >= 0) {
      var zero = true;
      for (j2 = 0; j2 < len; j2++) {
        tmp[j2] = naf[j2][i3] | 0;
        if (tmp[j2] !== 0)
          zero = false;
      }
      if (!zero)
        break;
      k2++;
      i3--;
    }
    if (i3 >= 0)
      k2++;
    acc = acc.dblp(k2);
    if (i3 < 0)
      break;
    for (j2 = 0; j2 < len; j2++) {
      var z2 = tmp[j2];
      if (z2 === 0)
        continue;
      else if (z2 > 0)
        p3 = wnd[j2][z2 - 1 >> 1];
      else if (z2 < 0)
        p3 = wnd[j2][-z2 - 1 >> 1].neg();
      if (p3.type === "affine")
        acc = acc.mixedAdd(p3);
      else
        acc = acc.add(p3);
    }
  }
  for (i3 = 0; i3 < len; i3++)
    wnd[i3] = null;
  if (jacobianResult)
    return acc;
  else
    return acc.toP();
};
function BasePoint$1(curve2, type) {
  this.curve = curve2;
  this.type = type;
  this.precomputed = null;
}
BaseCurve$1.BasePoint = BasePoint$1;
BasePoint$1.prototype.eq = function eq() {
  throw new Error("Not implemented");
};
BasePoint$1.prototype.validate = function validate2() {
  return this.curve.validate(this);
};
BaseCurve$1.prototype.decodePoint = function decodePoint(bytes, enc) {
  bytes = utils_1$1.toArray(bytes, enc);
  var len = this.p.byteLength();
  if ((bytes[0] === 4 || bytes[0] === 6 || bytes[0] === 7) && bytes.length - 1 === 2 * len) {
    if (bytes[0] === 6)
      assert$1$1(bytes[bytes.length - 1] % 2 === 0);
    else if (bytes[0] === 7)
      assert$1$1(bytes[bytes.length - 1] % 2 === 1);
    var res = this.point(
      bytes.slice(1, 1 + len),
      bytes.slice(1 + len, 1 + 2 * len)
    );
    return res;
  } else if ((bytes[0] === 2 || bytes[0] === 3) && bytes.length - 1 === len) {
    return this.pointFromX(bytes.slice(1, 1 + len), bytes[0] === 3);
  }
  throw new Error("Unknown point format");
};
BasePoint$1.prototype.encodeCompressed = function encodeCompressed(enc) {
  return this.encode(enc, true);
};
BasePoint$1.prototype._encode = function _encode(compact) {
  var len = this.curve.p.byteLength();
  var x3 = this.getX().toArray("be", len);
  if (compact)
    return [this.getY().isEven() ? 2 : 3].concat(x3);
  return [4].concat(x3, this.getY().toArray("be", len));
};
BasePoint$1.prototype.encode = function encode2(enc, compact) {
  return utils_1$1.encode(this._encode(compact), enc);
};
BasePoint$1.prototype.precompute = function precompute(power) {
  if (this.precomputed)
    return this;
  var precomputed = {
    doubles: null,
    naf: null,
    beta: null
  };
  precomputed.naf = this._getNAFPoints(8);
  precomputed.doubles = this._getDoubles(4, power);
  precomputed.beta = this._getBeta();
  this.precomputed = precomputed;
  return this;
};
BasePoint$1.prototype._hasDoubles = function _hasDoubles(k2) {
  if (!this.precomputed)
    return false;
  var doubles = this.precomputed.doubles;
  if (!doubles)
    return false;
  return doubles.points.length >= Math.ceil((k2.bitLength() + 1) / doubles.step);
};
BasePoint$1.prototype._getDoubles = function _getDoubles(step, power) {
  if (this.precomputed && this.precomputed.doubles)
    return this.precomputed.doubles;
  var doubles = [this];
  var acc = this;
  for (var i3 = 0; i3 < power; i3 += step) {
    for (var j2 = 0; j2 < step; j2++)
      acc = acc.dbl();
    doubles.push(acc);
  }
  return {
    step,
    points: doubles
  };
};
BasePoint$1.prototype._getNAFPoints = function _getNAFPoints(wnd) {
  if (this.precomputed && this.precomputed.naf)
    return this.precomputed.naf;
  var res = [this];
  var max = (1 << wnd) - 1;
  var dbl7 = max === 1 ? null : this.dbl();
  for (var i3 = 1; i3 < max; i3++)
    res[i3] = res[i3 - 1].add(dbl7);
  return {
    wnd,
    points: res
  };
};
BasePoint$1.prototype._getBeta = function _getBeta() {
  return null;
};
BasePoint$1.prototype.dblp = function dblp(k2) {
  var r2 = this;
  for (var i3 = 0; i3 < k2; i3++)
    r2 = r2.dbl();
  return r2;
};
var inherits_browser = createCommonjsModule(function(module) {
  if (typeof Object.create === "function") {
    module.exports = function inherits2(ctor, superCtor) {
      if (superCtor) {
        ctor.super_ = superCtor;
        ctor.prototype = Object.create(superCtor.prototype, {
          constructor: {
            value: ctor,
            enumerable: false,
            writable: true,
            configurable: true
          }
        });
      }
    };
  } else {
    module.exports = function inherits2(ctor, superCtor) {
      if (superCtor) {
        ctor.super_ = superCtor;
        var TempCtor = function() {
        };
        TempCtor.prototype = superCtor.prototype;
        ctor.prototype = new TempCtor();
        ctor.prototype.constructor = ctor;
      }
    };
  }
});
var assert$2$1 = utils_1$1.assert;
function ShortCurve$1(conf) {
  base$1.call(this, "short", conf);
  this.a = new BN$9(conf.a, 16).toRed(this.red);
  this.b = new BN$9(conf.b, 16).toRed(this.red);
  this.tinv = this.two.redInvm();
  this.zeroA = this.a.fromRed().cmpn(0) === 0;
  this.threeA = this.a.fromRed().sub(this.p).cmpn(-3) === 0;
  this.endo = this._getEndomorphism(conf);
  this._endoWnafT1 = new Array(4);
  this._endoWnafT2 = new Array(4);
}
inherits_browser(ShortCurve$1, base$1);
var short_1 = ShortCurve$1;
ShortCurve$1.prototype._getEndomorphism = function _getEndomorphism(conf) {
  if (!this.zeroA || !this.g || !this.n || this.p.modn(3) !== 1)
    return;
  var beta;
  var lambda;
  if (conf.beta) {
    beta = new BN$9(conf.beta, 16).toRed(this.red);
  } else {
    var betas = this._getEndoRoots(this.p);
    beta = betas[0].cmp(betas[1]) < 0 ? betas[0] : betas[1];
    beta = beta.toRed(this.red);
  }
  if (conf.lambda) {
    lambda = new BN$9(conf.lambda, 16);
  } else {
    var lambdas = this._getEndoRoots(this.n);
    if (this.g.mul(lambdas[0]).x.cmp(this.g.x.redMul(beta)) === 0) {
      lambda = lambdas[0];
    } else {
      lambda = lambdas[1];
      assert$2$1(this.g.mul(lambda).x.cmp(this.g.x.redMul(beta)) === 0);
    }
  }
  var basis;
  if (conf.basis) {
    basis = conf.basis.map(function(vec) {
      return {
        a: new BN$9(vec.a, 16),
        b: new BN$9(vec.b, 16)
      };
    });
  } else {
    basis = this._getEndoBasis(lambda);
  }
  return {
    beta,
    lambda,
    basis
  };
};
ShortCurve$1.prototype._getEndoRoots = function _getEndoRoots(num) {
  var red = num === this.p ? this.red : BN$9.mont(num);
  var tinv = new BN$9(2).toRed(red).redInvm();
  var ntinv = tinv.redNeg();
  var s2 = new BN$9(3).toRed(red).redNeg().redSqrt().redMul(tinv);
  var l1 = ntinv.redAdd(s2).fromRed();
  var l2 = ntinv.redSub(s2).fromRed();
  return [l1, l2];
};
ShortCurve$1.prototype._getEndoBasis = function _getEndoBasis(lambda) {
  var aprxSqrt = this.n.ushrn(Math.floor(this.n.bitLength() / 2));
  var u2 = lambda;
  var v3 = this.n.clone();
  var x1 = new BN$9(1);
  var y1 = new BN$9(0);
  var x22 = new BN$9(0);
  var y22 = new BN$9(1);
  var a0;
  var b0;
  var a1;
  var b1;
  var a22;
  var b2;
  var prevR;
  var i3 = 0;
  var r2;
  var x3;
  while (u2.cmpn(0) !== 0) {
    var q2 = v3.div(u2);
    r2 = v3.sub(q2.mul(u2));
    x3 = x22.sub(q2.mul(x1));
    var y3 = y22.sub(q2.mul(y1));
    if (!a1 && r2.cmp(aprxSqrt) < 0) {
      a0 = prevR.neg();
      b0 = x1;
      a1 = r2.neg();
      b1 = x3;
    } else if (a1 && ++i3 === 2) {
      break;
    }
    prevR = r2;
    v3 = u2;
    u2 = r2;
    x22 = x1;
    x1 = x3;
    y22 = y1;
    y1 = y3;
  }
  a22 = r2.neg();
  b2 = x3;
  var len1 = a1.sqr().add(b1.sqr());
  var len2 = a22.sqr().add(b2.sqr());
  if (len2.cmp(len1) >= 0) {
    a22 = a0;
    b2 = b0;
  }
  if (a1.negative) {
    a1 = a1.neg();
    b1 = b1.neg();
  }
  if (a22.negative) {
    a22 = a22.neg();
    b2 = b2.neg();
  }
  return [
    { a: a1, b: b1 },
    { a: a22, b: b2 }
  ];
};
ShortCurve$1.prototype._endoSplit = function _endoSplit(k2) {
  var basis = this.endo.basis;
  var v1 = basis[0];
  var v22 = basis[1];
  var c1 = v22.b.mul(k2).divRound(this.n);
  var c2 = v1.b.neg().mul(k2).divRound(this.n);
  var p1 = c1.mul(v1.a);
  var p22 = c2.mul(v22.a);
  var q1 = c1.mul(v1.b);
  var q2 = c2.mul(v22.b);
  var k1 = k2.sub(p1).sub(p22);
  var k22 = q1.add(q2).neg();
  return { k1, k2: k22 };
};
ShortCurve$1.prototype.pointFromX = function pointFromX(x3, odd) {
  x3 = new BN$9(x3, 16);
  if (!x3.red)
    x3 = x3.toRed(this.red);
  var y22 = x3.redSqr().redMul(x3).redIAdd(x3.redMul(this.a)).redIAdd(this.b);
  var y3 = y22.redSqrt();
  if (y3.redSqr().redSub(y22).cmp(this.zero) !== 0)
    throw new Error("invalid point");
  var isOdd = y3.fromRed().isOdd();
  if (odd && !isOdd || !odd && isOdd)
    y3 = y3.redNeg();
  return this.point(x3, y3);
};
ShortCurve$1.prototype.validate = function validate3(point7) {
  if (point7.inf)
    return true;
  var x3 = point7.x;
  var y3 = point7.y;
  var ax = this.a.redMul(x3);
  var rhs = x3.redSqr().redMul(x3).redIAdd(ax).redIAdd(this.b);
  return y3.redSqr().redISub(rhs).cmpn(0) === 0;
};
ShortCurve$1.prototype._endoWnafMulAdd = function _endoWnafMulAdd(points, coeffs, jacobianResult) {
  var npoints = this._endoWnafT1;
  var ncoeffs = this._endoWnafT2;
  for (var i3 = 0; i3 < points.length; i3++) {
    var split = this._endoSplit(coeffs[i3]);
    var p3 = points[i3];
    var beta = p3._getBeta();
    if (split.k1.negative) {
      split.k1.ineg();
      p3 = p3.neg(true);
    }
    if (split.k2.negative) {
      split.k2.ineg();
      beta = beta.neg(true);
    }
    npoints[i3 * 2] = p3;
    npoints[i3 * 2 + 1] = beta;
    ncoeffs[i3 * 2] = split.k1;
    ncoeffs[i3 * 2 + 1] = split.k2;
  }
  var res = this._wnafMulAdd(1, npoints, ncoeffs, i3 * 2, jacobianResult);
  for (var j2 = 0; j2 < i3 * 2; j2++) {
    npoints[j2] = null;
    ncoeffs[j2] = null;
  }
  return res;
};
function Point$3(curve2, x3, y3, isRed) {
  base$1.BasePoint.call(this, curve2, "affine");
  if (x3 === null && y3 === null) {
    this.x = null;
    this.y = null;
    this.inf = true;
  } else {
    this.x = new BN$9(x3, 16);
    this.y = new BN$9(y3, 16);
    if (isRed) {
      this.x.forceRed(this.curve.red);
      this.y.forceRed(this.curve.red);
    }
    if (!this.x.red)
      this.x = this.x.toRed(this.curve.red);
    if (!this.y.red)
      this.y = this.y.toRed(this.curve.red);
    this.inf = false;
  }
}
inherits_browser(Point$3, base$1.BasePoint);
ShortCurve$1.prototype.point = function point2(x3, y3, isRed) {
  return new Point$3(this, x3, y3, isRed);
};
ShortCurve$1.prototype.pointFromJSON = function pointFromJSON(obj, red) {
  return Point$3.fromJSON(this, obj, red);
};
Point$3.prototype._getBeta = function _getBeta2() {
  if (!this.curve.endo)
    return;
  var pre = this.precomputed;
  if (pre && pre.beta)
    return pre.beta;
  var beta = this.curve.point(this.x.redMul(this.curve.endo.beta), this.y);
  if (pre) {
    var curve2 = this.curve;
    var endoMul = function(p3) {
      return curve2.point(p3.x.redMul(curve2.endo.beta), p3.y);
    };
    pre.beta = beta;
    beta.precomputed = {
      beta: null,
      naf: pre.naf && {
        wnd: pre.naf.wnd,
        points: pre.naf.points.map(endoMul)
      },
      doubles: pre.doubles && {
        step: pre.doubles.step,
        points: pre.doubles.points.map(endoMul)
      }
    };
  }
  return beta;
};
Point$3.prototype.toJSON = function toJSON() {
  if (!this.precomputed)
    return [this.x, this.y];
  return [this.x, this.y, this.precomputed && {
    doubles: this.precomputed.doubles && {
      step: this.precomputed.doubles.step,
      points: this.precomputed.doubles.points.slice(1)
    },
    naf: this.precomputed.naf && {
      wnd: this.precomputed.naf.wnd,
      points: this.precomputed.naf.points.slice(1)
    }
  }];
};
Point$3.fromJSON = function fromJSON(curve2, obj, red) {
  if (typeof obj === "string")
    obj = JSON.parse(obj);
  var res = curve2.point(obj[0], obj[1], red);
  if (!obj[2])
    return res;
  function obj2point(obj2) {
    return curve2.point(obj2[0], obj2[1], red);
  }
  var pre = obj[2];
  res.precomputed = {
    beta: null,
    doubles: pre.doubles && {
      step: pre.doubles.step,
      points: [res].concat(pre.doubles.points.map(obj2point))
    },
    naf: pre.naf && {
      wnd: pre.naf.wnd,
      points: [res].concat(pre.naf.points.map(obj2point))
    }
  };
  return res;
};
Point$3.prototype.inspect = function inspect() {
  if (this.isInfinity())
    return "<EC Point Infinity>";
  return "<EC Point x: " + this.x.fromRed().toString(16, 2) + " y: " + this.y.fromRed().toString(16, 2) + ">";
};
Point$3.prototype.isInfinity = function isInfinity() {
  return this.inf;
};
Point$3.prototype.add = function add(p3) {
  if (this.inf)
    return p3;
  if (p3.inf)
    return this;
  if (this.eq(p3))
    return this.dbl();
  if (this.neg().eq(p3))
    return this.curve.point(null, null);
  if (this.x.cmp(p3.x) === 0)
    return this.curve.point(null, null);
  var c2 = this.y.redSub(p3.y);
  if (c2.cmpn(0) !== 0)
    c2 = c2.redMul(this.x.redSub(p3.x).redInvm());
  var nx = c2.redSqr().redISub(this.x).redISub(p3.x);
  var ny = c2.redMul(this.x.redSub(nx)).redISub(this.y);
  return this.curve.point(nx, ny);
};
Point$3.prototype.dbl = function dbl() {
  if (this.inf)
    return this;
  var ys1 = this.y.redAdd(this.y);
  if (ys1.cmpn(0) === 0)
    return this.curve.point(null, null);
  var a3 = this.curve.a;
  var x22 = this.x.redSqr();
  var dyinv = ys1.redInvm();
  var c2 = x22.redAdd(x22).redIAdd(x22).redIAdd(a3).redMul(dyinv);
  var nx = c2.redSqr().redISub(this.x.redAdd(this.x));
  var ny = c2.redMul(this.x.redSub(nx)).redISub(this.y);
  return this.curve.point(nx, ny);
};
Point$3.prototype.getX = function getX() {
  return this.x.fromRed();
};
Point$3.prototype.getY = function getY() {
  return this.y.fromRed();
};
Point$3.prototype.mul = function mul(k2) {
  k2 = new BN$9(k2, 16);
  if (this.isInfinity())
    return this;
  else if (this._hasDoubles(k2))
    return this.curve._fixedNafMul(this, k2);
  else if (this.curve.endo)
    return this.curve._endoWnafMulAdd([this], [k2]);
  else
    return this.curve._wnafMul(this, k2);
};
Point$3.prototype.mulAdd = function mulAdd(k1, p22, k2) {
  var points = [this, p22];
  var coeffs = [k1, k2];
  if (this.curve.endo)
    return this.curve._endoWnafMulAdd(points, coeffs);
  else
    return this.curve._wnafMulAdd(1, points, coeffs, 2);
};
Point$3.prototype.jmulAdd = function jmulAdd(k1, p22, k2) {
  var points = [this, p22];
  var coeffs = [k1, k2];
  if (this.curve.endo)
    return this.curve._endoWnafMulAdd(points, coeffs, true);
  else
    return this.curve._wnafMulAdd(1, points, coeffs, 2, true);
};
Point$3.prototype.eq = function eq2(p3) {
  return this === p3 || this.inf === p3.inf && (this.inf || this.x.cmp(p3.x) === 0 && this.y.cmp(p3.y) === 0);
};
Point$3.prototype.neg = function neg(_precompute) {
  if (this.inf)
    return this;
  var res = this.curve.point(this.x, this.y.redNeg());
  if (_precompute && this.precomputed) {
    var pre = this.precomputed;
    var negate = function(p3) {
      return p3.neg();
    };
    res.precomputed = {
      naf: pre.naf && {
        wnd: pre.naf.wnd,
        points: pre.naf.points.map(negate)
      },
      doubles: pre.doubles && {
        step: pre.doubles.step,
        points: pre.doubles.points.map(negate)
      }
    };
  }
  return res;
};
Point$3.prototype.toJ = function toJ() {
  if (this.inf)
    return this.curve.jpoint(null, null, null);
  var res = this.curve.jpoint(this.x, this.y, this.curve.one);
  return res;
};
function JPoint$1(curve2, x3, y3, z2) {
  base$1.BasePoint.call(this, curve2, "jacobian");
  if (x3 === null && y3 === null && z2 === null) {
    this.x = this.curve.one;
    this.y = this.curve.one;
    this.z = new BN$9(0);
  } else {
    this.x = new BN$9(x3, 16);
    this.y = new BN$9(y3, 16);
    this.z = new BN$9(z2, 16);
  }
  if (!this.x.red)
    this.x = this.x.toRed(this.curve.red);
  if (!this.y.red)
    this.y = this.y.toRed(this.curve.red);
  if (!this.z.red)
    this.z = this.z.toRed(this.curve.red);
  this.zOne = this.z === this.curve.one;
}
inherits_browser(JPoint$1, base$1.BasePoint);
ShortCurve$1.prototype.jpoint = function jpoint(x3, y3, z2) {
  return new JPoint$1(this, x3, y3, z2);
};
JPoint$1.prototype.toP = function toP() {
  if (this.isInfinity())
    return this.curve.point(null, null);
  var zinv = this.z.redInvm();
  var zinv2 = zinv.redSqr();
  var ax = this.x.redMul(zinv2);
  var ay = this.y.redMul(zinv2).redMul(zinv);
  return this.curve.point(ax, ay);
};
JPoint$1.prototype.neg = function neg2() {
  return this.curve.jpoint(this.x, this.y.redNeg(), this.z);
};
JPoint$1.prototype.add = function add2(p3) {
  if (this.isInfinity())
    return p3;
  if (p3.isInfinity())
    return this;
  var pz2 = p3.z.redSqr();
  var z2 = this.z.redSqr();
  var u1 = this.x.redMul(pz2);
  var u2 = p3.x.redMul(z2);
  var s1 = this.y.redMul(pz2.redMul(p3.z));
  var s2 = p3.y.redMul(z2.redMul(this.z));
  var h4 = u1.redSub(u2);
  var r2 = s1.redSub(s2);
  if (h4.cmpn(0) === 0) {
    if (r2.cmpn(0) !== 0)
      return this.curve.jpoint(null, null, null);
    else
      return this.dbl();
  }
  var h22 = h4.redSqr();
  var h32 = h22.redMul(h4);
  var v3 = u1.redMul(h22);
  var nx = r2.redSqr().redIAdd(h32).redISub(v3).redISub(v3);
  var ny = r2.redMul(v3.redISub(nx)).redISub(s1.redMul(h32));
  var nz = this.z.redMul(p3.z).redMul(h4);
  return this.curve.jpoint(nx, ny, nz);
};
JPoint$1.prototype.mixedAdd = function mixedAdd(p3) {
  if (this.isInfinity())
    return p3.toJ();
  if (p3.isInfinity())
    return this;
  var z2 = this.z.redSqr();
  var u1 = this.x;
  var u2 = p3.x.redMul(z2);
  var s1 = this.y;
  var s2 = p3.y.redMul(z2).redMul(this.z);
  var h4 = u1.redSub(u2);
  var r2 = s1.redSub(s2);
  if (h4.cmpn(0) === 0) {
    if (r2.cmpn(0) !== 0)
      return this.curve.jpoint(null, null, null);
    else
      return this.dbl();
  }
  var h22 = h4.redSqr();
  var h32 = h22.redMul(h4);
  var v3 = u1.redMul(h22);
  var nx = r2.redSqr().redIAdd(h32).redISub(v3).redISub(v3);
  var ny = r2.redMul(v3.redISub(nx)).redISub(s1.redMul(h32));
  var nz = this.z.redMul(h4);
  return this.curve.jpoint(nx, ny, nz);
};
JPoint$1.prototype.dblp = function dblp2(pow) {
  if (pow === 0)
    return this;
  if (this.isInfinity())
    return this;
  if (!pow)
    return this.dbl();
  var i3;
  if (this.curve.zeroA || this.curve.threeA) {
    var r2 = this;
    for (i3 = 0; i3 < pow; i3++)
      r2 = r2.dbl();
    return r2;
  }
  var a3 = this.curve.a;
  var tinv = this.curve.tinv;
  var jx = this.x;
  var jy = this.y;
  var jz = this.z;
  var jz4 = jz.redSqr().redSqr();
  var jyd = jy.redAdd(jy);
  for (i3 = 0; i3 < pow; i3++) {
    var jx2 = jx.redSqr();
    var jyd2 = jyd.redSqr();
    var jyd4 = jyd2.redSqr();
    var c2 = jx2.redAdd(jx2).redIAdd(jx2).redIAdd(a3.redMul(jz4));
    var t1 = jx.redMul(jyd2);
    var nx = c2.redSqr().redISub(t1.redAdd(t1));
    var t2 = t1.redISub(nx);
    var dny = c2.redMul(t2);
    dny = dny.redIAdd(dny).redISub(jyd4);
    var nz = jyd.redMul(jz);
    if (i3 + 1 < pow)
      jz4 = jz4.redMul(jyd4);
    jx = nx;
    jz = nz;
    jyd = dny;
  }
  return this.curve.jpoint(jx, jyd.redMul(tinv), jz);
};
JPoint$1.prototype.dbl = function dbl2() {
  if (this.isInfinity())
    return this;
  if (this.curve.zeroA)
    return this._zeroDbl();
  else if (this.curve.threeA)
    return this._threeDbl();
  else
    return this._dbl();
};
JPoint$1.prototype._zeroDbl = function _zeroDbl() {
  var nx;
  var ny;
  var nz;
  if (this.zOne) {
    var xx = this.x.redSqr();
    var yy = this.y.redSqr();
    var yyyy = yy.redSqr();
    var s2 = this.x.redAdd(yy).redSqr().redISub(xx).redISub(yyyy);
    s2 = s2.redIAdd(s2);
    var m2 = xx.redAdd(xx).redIAdd(xx);
    var t = m2.redSqr().redISub(s2).redISub(s2);
    var yyyy8 = yyyy.redIAdd(yyyy);
    yyyy8 = yyyy8.redIAdd(yyyy8);
    yyyy8 = yyyy8.redIAdd(yyyy8);
    nx = t;
    ny = m2.redMul(s2.redISub(t)).redISub(yyyy8);
    nz = this.y.redAdd(this.y);
  } else {
    var a3 = this.x.redSqr();
    var b2 = this.y.redSqr();
    var c2 = b2.redSqr();
    var d4 = this.x.redAdd(b2).redSqr().redISub(a3).redISub(c2);
    d4 = d4.redIAdd(d4);
    var e2 = a3.redAdd(a3).redIAdd(a3);
    var f3 = e2.redSqr();
    var c8 = c2.redIAdd(c2);
    c8 = c8.redIAdd(c8);
    c8 = c8.redIAdd(c8);
    nx = f3.redISub(d4).redISub(d4);
    ny = e2.redMul(d4.redISub(nx)).redISub(c8);
    nz = this.y.redMul(this.z);
    nz = nz.redIAdd(nz);
  }
  return this.curve.jpoint(nx, ny, nz);
};
JPoint$1.prototype._threeDbl = function _threeDbl() {
  var nx;
  var ny;
  var nz;
  if (this.zOne) {
    var xx = this.x.redSqr();
    var yy = this.y.redSqr();
    var yyyy = yy.redSqr();
    var s2 = this.x.redAdd(yy).redSqr().redISub(xx).redISub(yyyy);
    s2 = s2.redIAdd(s2);
    var m2 = xx.redAdd(xx).redIAdd(xx).redIAdd(this.curve.a);
    var t = m2.redSqr().redISub(s2).redISub(s2);
    nx = t;
    var yyyy8 = yyyy.redIAdd(yyyy);
    yyyy8 = yyyy8.redIAdd(yyyy8);
    yyyy8 = yyyy8.redIAdd(yyyy8);
    ny = m2.redMul(s2.redISub(t)).redISub(yyyy8);
    nz = this.y.redAdd(this.y);
  } else {
    var delta = this.z.redSqr();
    var gamma = this.y.redSqr();
    var beta = this.x.redMul(gamma);
    var alpha = this.x.redSub(delta).redMul(this.x.redAdd(delta));
    alpha = alpha.redAdd(alpha).redIAdd(alpha);
    var beta4 = beta.redIAdd(beta);
    beta4 = beta4.redIAdd(beta4);
    var beta8 = beta4.redAdd(beta4);
    nx = alpha.redSqr().redISub(beta8);
    nz = this.y.redAdd(this.z).redSqr().redISub(gamma).redISub(delta);
    var ggamma8 = gamma.redSqr();
    ggamma8 = ggamma8.redIAdd(ggamma8);
    ggamma8 = ggamma8.redIAdd(ggamma8);
    ggamma8 = ggamma8.redIAdd(ggamma8);
    ny = alpha.redMul(beta4.redISub(nx)).redISub(ggamma8);
  }
  return this.curve.jpoint(nx, ny, nz);
};
JPoint$1.prototype._dbl = function _dbl() {
  var a3 = this.curve.a;
  var jx = this.x;
  var jy = this.y;
  var jz = this.z;
  var jz4 = jz.redSqr().redSqr();
  var jx2 = jx.redSqr();
  var jy2 = jy.redSqr();
  var c2 = jx2.redAdd(jx2).redIAdd(jx2).redIAdd(a3.redMul(jz4));
  var jxd4 = jx.redAdd(jx);
  jxd4 = jxd4.redIAdd(jxd4);
  var t1 = jxd4.redMul(jy2);
  var nx = c2.redSqr().redISub(t1.redAdd(t1));
  var t2 = t1.redISub(nx);
  var jyd8 = jy2.redSqr();
  jyd8 = jyd8.redIAdd(jyd8);
  jyd8 = jyd8.redIAdd(jyd8);
  jyd8 = jyd8.redIAdd(jyd8);
  var ny = c2.redMul(t2).redISub(jyd8);
  var nz = jy.redAdd(jy).redMul(jz);
  return this.curve.jpoint(nx, ny, nz);
};
JPoint$1.prototype.trpl = function trpl() {
  if (!this.curve.zeroA)
    return this.dbl().add(this);
  var xx = this.x.redSqr();
  var yy = this.y.redSqr();
  var zz = this.z.redSqr();
  var yyyy = yy.redSqr();
  var m2 = xx.redAdd(xx).redIAdd(xx);
  var mm = m2.redSqr();
  var e2 = this.x.redAdd(yy).redSqr().redISub(xx).redISub(yyyy);
  e2 = e2.redIAdd(e2);
  e2 = e2.redAdd(e2).redIAdd(e2);
  e2 = e2.redISub(mm);
  var ee2 = e2.redSqr();
  var t = yyyy.redIAdd(yyyy);
  t = t.redIAdd(t);
  t = t.redIAdd(t);
  t = t.redIAdd(t);
  var u2 = m2.redIAdd(e2).redSqr().redISub(mm).redISub(ee2).redISub(t);
  var yyu4 = yy.redMul(u2);
  yyu4 = yyu4.redIAdd(yyu4);
  yyu4 = yyu4.redIAdd(yyu4);
  var nx = this.x.redMul(ee2).redISub(yyu4);
  nx = nx.redIAdd(nx);
  nx = nx.redIAdd(nx);
  var ny = this.y.redMul(u2.redMul(t.redISub(u2)).redISub(e2.redMul(ee2)));
  ny = ny.redIAdd(ny);
  ny = ny.redIAdd(ny);
  ny = ny.redIAdd(ny);
  var nz = this.z.redAdd(e2).redSqr().redISub(zz).redISub(ee2);
  return this.curve.jpoint(nx, ny, nz);
};
JPoint$1.prototype.mul = function mul2(k2, kbase) {
  k2 = new BN$9(k2, kbase);
  return this.curve._wnafMul(this, k2);
};
JPoint$1.prototype.eq = function eq3(p3) {
  if (p3.type === "affine")
    return this.eq(p3.toJ());
  if (this === p3)
    return true;
  var z2 = this.z.redSqr();
  var pz2 = p3.z.redSqr();
  if (this.x.redMul(pz2).redISub(p3.x.redMul(z2)).cmpn(0) !== 0)
    return false;
  var z3 = z2.redMul(this.z);
  var pz3 = pz2.redMul(p3.z);
  return this.y.redMul(pz3).redISub(p3.y.redMul(z3)).cmpn(0) === 0;
};
JPoint$1.prototype.eqXToP = function eqXToP(x3) {
  var zs2 = this.z.redSqr();
  var rx = x3.toRed(this.curve.red).redMul(zs2);
  if (this.x.cmp(rx) === 0)
    return true;
  var xc = x3.clone();
  var t = this.curve.redN.redMul(zs2);
  for (; ; ) {
    xc.iadd(this.curve.n);
    if (xc.cmp(this.curve.p) >= 0)
      return false;
    rx.redIAdd(t);
    if (this.x.cmp(rx) === 0)
      return true;
  }
};
JPoint$1.prototype.inspect = function inspect2() {
  if (this.isInfinity())
    return "<EC JPoint Infinity>";
  return "<EC JPoint x: " + this.x.toString(16, 2) + " y: " + this.y.toString(16, 2) + " z: " + this.z.toString(16, 2) + ">";
};
JPoint$1.prototype.isInfinity = function isInfinity2() {
  return this.z.cmpn(0) === 0;
};
var curve_1 = createCommonjsModule(function(module, exports) {
  var curve2 = exports;
  curve2.base = base$1;
  curve2.short = short_1;
  curve2.mont = /*RicMoo:ethers:require(./mont)*/
  null;
  curve2.edwards = /*RicMoo:ethers:require(./edwards)*/
  null;
});
var curves_1 = createCommonjsModule(function(module, exports) {
  var curves2 = exports;
  var assert2 = utils_1$1.assert;
  function PresetCurve(options) {
    if (options.type === "short")
      this.curve = new curve_1.short(options);
    else if (options.type === "edwards")
      this.curve = new curve_1.edwards(options);
    else
      this.curve = new curve_1.mont(options);
    this.g = this.curve.g;
    this.n = this.curve.n;
    this.hash = options.hash;
    assert2(this.g.validate(), "Invalid curve");
    assert2(this.g.mul(this.n).isInfinity(), "Invalid curve, G*N != O");
  }
  curves2.PresetCurve = PresetCurve;
  function defineCurve(name2, options) {
    Object.defineProperty(curves2, name2, {
      configurable: true,
      enumerable: true,
      get: function() {
        var curve2 = new PresetCurve(options);
        Object.defineProperty(curves2, name2, {
          configurable: true,
          enumerable: true,
          value: curve2
        });
        return curve2;
      }
    });
  }
  defineCurve("p192", {
    type: "short",
    prime: "p192",
    p: "ffffffff ffffffff ffffffff fffffffe ffffffff ffffffff",
    a: "ffffffff ffffffff ffffffff fffffffe ffffffff fffffffc",
    b: "64210519 e59c80e7 0fa7e9ab 72243049 feb8deec c146b9b1",
    n: "ffffffff ffffffff ffffffff 99def836 146bc9b1 b4d22831",
    hash: hash$2.sha256,
    gRed: false,
    g: [
      "188da80e b03090f6 7cbf20eb 43a18800 f4ff0afd 82ff1012",
      "07192b95 ffc8da78 631011ed 6b24cdd5 73f977a1 1e794811"
    ]
  });
  defineCurve("p224", {
    type: "short",
    prime: "p224",
    p: "ffffffff ffffffff ffffffff ffffffff 00000000 00000000 00000001",
    a: "ffffffff ffffffff ffffffff fffffffe ffffffff ffffffff fffffffe",
    b: "b4050a85 0c04b3ab f5413256 5044b0b7 d7bfd8ba 270b3943 2355ffb4",
    n: "ffffffff ffffffff ffffffff ffff16a2 e0b8f03e 13dd2945 5c5c2a3d",
    hash: hash$2.sha256,
    gRed: false,
    g: [
      "b70e0cbd 6bb4bf7f 321390b9 4a03c1d3 56c21122 343280d6 115c1d21",
      "bd376388 b5f723fb 4c22dfe6 cd4375a0 5a074764 44d58199 85007e34"
    ]
  });
  defineCurve("p256", {
    type: "short",
    prime: null,
    p: "ffffffff 00000001 00000000 00000000 00000000 ffffffff ffffffff ffffffff",
    a: "ffffffff 00000001 00000000 00000000 00000000 ffffffff ffffffff fffffffc",
    b: "5ac635d8 aa3a93e7 b3ebbd55 769886bc 651d06b0 cc53b0f6 3bce3c3e 27d2604b",
    n: "ffffffff 00000000 ffffffff ffffffff bce6faad a7179e84 f3b9cac2 fc632551",
    hash: hash$2.sha256,
    gRed: false,
    g: [
      "6b17d1f2 e12c4247 f8bce6e5 63a440f2 77037d81 2deb33a0 f4a13945 d898c296",
      "4fe342e2 fe1a7f9b 8ee7eb4a 7c0f9e16 2bce3357 6b315ece cbb64068 37bf51f5"
    ]
  });
  defineCurve("p384", {
    type: "short",
    prime: null,
    p: "ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff fffffffe ffffffff 00000000 00000000 ffffffff",
    a: "ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff fffffffe ffffffff 00000000 00000000 fffffffc",
    b: "b3312fa7 e23ee7e4 988e056b e3f82d19 181d9c6e fe814112 0314088f 5013875a c656398d 8a2ed19d 2a85c8ed d3ec2aef",
    n: "ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff c7634d81 f4372ddf 581a0db2 48b0a77a ecec196a ccc52973",
    hash: hash$2.sha384,
    gRed: false,
    g: [
      "aa87ca22 be8b0537 8eb1c71e f320ad74 6e1d3b62 8ba79b98 59f741e0 82542a38 5502f25d bf55296c 3a545e38 72760ab7",
      "3617de4a 96262c6f 5d9e98bf 9292dc29 f8f41dbd 289a147c e9da3113 b5f0b8c0 0a60b1ce 1d7e819d 7a431d7c 90ea0e5f"
    ]
  });
  defineCurve("p521", {
    type: "short",
    prime: null,
    p: "000001ff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff",
    a: "000001ff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff fffffffc",
    b: "00000051 953eb961 8e1c9a1f 929a21a0 b68540ee a2da725b 99b315f3 b8b48991 8ef109e1 56193951 ec7e937b 1652c0bd 3bb1bf07 3573df88 3d2c34f1 ef451fd4 6b503f00",
    n: "000001ff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff fffffffa 51868783 bf2f966b 7fcc0148 f709a5d0 3bb5c9b8 899c47ae bb6fb71e 91386409",
    hash: hash$2.sha512,
    gRed: false,
    g: [
      "000000c6 858e06b7 0404e9cd 9e3ecb66 2395b442 9c648139 053fb521 f828af60 6b4d3dba a14b5e77 efe75928 fe1dc127 a2ffa8de 3348b3c1 856a429b f97e7e31 c2e5bd66",
      "00000118 39296a78 9a3bc004 5c8a5fb4 2c7d1bd9 98f54449 579b4468 17afbd17 273e662c 97ee7299 5ef42640 c550b901 3fad0761 353c7086 a272c240 88be9476 9fd16650"
    ]
  });
  defineCurve("curve25519", {
    type: "mont",
    prime: "p25519",
    p: "7fffffffffffffff ffffffffffffffff ffffffffffffffff ffffffffffffffed",
    a: "76d06",
    b: "1",
    n: "1000000000000000 0000000000000000 14def9dea2f79cd6 5812631a5cf5d3ed",
    hash: hash$2.sha256,
    gRed: false,
    g: [
      "9"
    ]
  });
  defineCurve("ed25519", {
    type: "edwards",
    prime: "p25519",
    p: "7fffffffffffffff ffffffffffffffff ffffffffffffffff ffffffffffffffed",
    a: "-1",
    c: "1",
    // -121665 * (121666^(-1)) (mod P)
    d: "52036cee2b6ffe73 8cc740797779e898 00700a4d4141d8ab 75eb4dca135978a3",
    n: "1000000000000000 0000000000000000 14def9dea2f79cd6 5812631a5cf5d3ed",
    hash: hash$2.sha256,
    gRed: false,
    g: [
      "216936d3cd6e53fec0a4e231fdd6dc5c692cc7609525a7b2c9562d608f25d51a",
      // 4/5
      "6666666666666666666666666666666666666666666666666666666666666658"
    ]
  });
  var pre;
  try {
    pre = /*RicMoo:ethers:require(./precomputed/secp256k1)*/
    null.crash();
  } catch (e2) {
    pre = void 0;
  }
  defineCurve("secp256k1", {
    type: "short",
    prime: "k256",
    p: "ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff fffffffe fffffc2f",
    a: "0",
    b: "7",
    n: "ffffffff ffffffff ffffffff fffffffe baaedce6 af48a03b bfd25e8c d0364141",
    h: "1",
    hash: hash$2.sha256,
    // Precomputed endomorphism
    beta: "7ae96a2b657c07106e64479eac3434e99cf0497512f58995c1396c28719501ee",
    lambda: "5363ad4cc05c30e0a5261c028812645a122e22ea20816678df02967c1b23bd72",
    basis: [
      {
        a: "3086d221a7d46bcde86c90e49284eb15",
        b: "-e4437ed6010e88286f547fa90abfe4c3"
      },
      {
        a: "114ca50f7a8e2f3f657c1108d9d44cfd8",
        b: "3086d221a7d46bcde86c90e49284eb15"
      }
    ],
    gRed: false,
    g: [
      "79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798",
      "483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8",
      pre
    ]
  });
});
function HmacDRBG$1(options) {
  if (!(this instanceof HmacDRBG$1))
    return new HmacDRBG$1(options);
  this.hash = options.hash;
  this.predResist = !!options.predResist;
  this.outLen = this.hash.outSize;
  this.minEntropy = options.minEntropy || this.hash.hmacStrength;
  this._reseed = null;
  this.reseedInterval = null;
  this.K = null;
  this.V = null;
  var entropy = utils_1.toArray(options.entropy, options.entropyEnc || "hex");
  var nonce = utils_1.toArray(options.nonce, options.nonceEnc || "hex");
  var pers = utils_1.toArray(options.pers, options.persEnc || "hex");
  minimalisticAssert(
    entropy.length >= this.minEntropy / 8,
    "Not enough entropy. Minimum is: " + this.minEntropy + " bits"
  );
  this._init(entropy, nonce, pers);
}
var hmacDrbg = HmacDRBG$1;
HmacDRBG$1.prototype._init = function init(entropy, nonce, pers) {
  var seed = entropy.concat(nonce).concat(pers);
  this.K = new Array(this.outLen / 8);
  this.V = new Array(this.outLen / 8);
  for (var i3 = 0; i3 < this.V.length; i3++) {
    this.K[i3] = 0;
    this.V[i3] = 1;
  }
  this._update(seed);
  this._reseed = 1;
  this.reseedInterval = 281474976710656;
};
HmacDRBG$1.prototype._hmac = function hmac() {
  return new hash$2.hmac(this.hash, this.K);
};
HmacDRBG$1.prototype._update = function update(seed) {
  var kmac = this._hmac().update(this.V).update([0]);
  if (seed)
    kmac = kmac.update(seed);
  this.K = kmac.digest();
  this.V = this._hmac().update(this.V).digest();
  if (!seed)
    return;
  this.K = this._hmac().update(this.V).update([1]).update(seed).digest();
  this.V = this._hmac().update(this.V).digest();
};
HmacDRBG$1.prototype.reseed = function reseed(entropy, entropyEnc, add7, addEnc) {
  if (typeof entropyEnc !== "string") {
    addEnc = add7;
    add7 = entropyEnc;
    entropyEnc = null;
  }
  entropy = utils_1.toArray(entropy, entropyEnc);
  add7 = utils_1.toArray(add7, addEnc);
  minimalisticAssert(
    entropy.length >= this.minEntropy / 8,
    "Not enough entropy. Minimum is: " + this.minEntropy + " bits"
  );
  this._update(entropy.concat(add7 || []));
  this._reseed = 1;
};
HmacDRBG$1.prototype.generate = function generate(len, enc, add7, addEnc) {
  if (this._reseed > this.reseedInterval)
    throw new Error("Reseed is required");
  if (typeof enc !== "string") {
    addEnc = add7;
    add7 = enc;
    enc = null;
  }
  if (add7) {
    add7 = utils_1.toArray(add7, addEnc || "hex");
    this._update(add7);
  }
  var temp = [];
  while (temp.length < len) {
    this.V = this._hmac().update(this.V).digest();
    temp = temp.concat(this.V);
  }
  var res = temp.slice(0, len);
  this._update(add7);
  this._reseed++;
  return utils_1.encode(res, enc);
};
var assert$3$1 = utils_1$1.assert;
function KeyPair$4(ec2, options) {
  this.ec = ec2;
  this.priv = null;
  this.pub = null;
  if (options.priv)
    this._importPrivate(options.priv, options.privEnc);
  if (options.pub)
    this._importPublic(options.pub, options.pubEnc);
}
var key$2 = KeyPair$4;
KeyPair$4.fromPublic = function fromPublic(ec2, pub2, enc) {
  if (pub2 instanceof KeyPair$4)
    return pub2;
  return new KeyPair$4(ec2, {
    pub: pub2,
    pubEnc: enc
  });
};
KeyPair$4.fromPrivate = function fromPrivate(ec2, priv2, enc) {
  if (priv2 instanceof KeyPair$4)
    return priv2;
  return new KeyPair$4(ec2, {
    priv: priv2,
    privEnc: enc
  });
};
KeyPair$4.prototype.validate = function validate4() {
  var pub2 = this.getPublic();
  if (pub2.isInfinity())
    return { result: false, reason: "Invalid public key" };
  if (!pub2.validate())
    return { result: false, reason: "Public key is not a point" };
  if (!pub2.mul(this.ec.curve.n).isInfinity())
    return { result: false, reason: "Public key * N != O" };
  return { result: true, reason: null };
};
KeyPair$4.prototype.getPublic = function getPublic(compact, enc) {
  if (typeof compact === "string") {
    enc = compact;
    compact = null;
  }
  if (!this.pub)
    this.pub = this.ec.g.mul(this.priv);
  if (!enc)
    return this.pub;
  return this.pub.encode(enc, compact);
};
KeyPair$4.prototype.getPrivate = function getPrivate(enc) {
  if (enc === "hex")
    return this.priv.toString(16, 2);
  else
    return this.priv;
};
KeyPair$4.prototype._importPrivate = function _importPrivate(key2, enc) {
  this.priv = new BN$9(key2, enc || 16);
  this.priv = this.priv.umod(this.ec.curve.n);
};
KeyPair$4.prototype._importPublic = function _importPublic(key2, enc) {
  if (key2.x || key2.y) {
    if (this.ec.curve.type === "mont") {
      assert$3$1(key2.x, "Need x coordinate");
    } else if (this.ec.curve.type === "short" || this.ec.curve.type === "edwards") {
      assert$3$1(key2.x && key2.y, "Need both x and y coordinate");
    }
    this.pub = this.ec.curve.point(key2.x, key2.y);
    return;
  }
  this.pub = this.ec.curve.decodePoint(key2, enc);
};
KeyPair$4.prototype.derive = function derive(pub2) {
  if (!pub2.validate()) {
    assert$3$1(pub2.validate(), "public point not validated");
  }
  return pub2.mul(this.priv).getX();
};
KeyPair$4.prototype.sign = function sign(msg, enc, options) {
  return this.ec.sign(msg, this, enc, options);
};
KeyPair$4.prototype.verify = function verify(msg, signature2) {
  return this.ec.verify(msg, signature2, this);
};
KeyPair$4.prototype.inspect = function inspect3() {
  return "<Key priv: " + (this.priv && this.priv.toString(16, 2)) + " pub: " + (this.pub && this.pub.inspect()) + " >";
};
var assert$4$1 = utils_1$1.assert;
function Signature$4(options, enc) {
  if (options instanceof Signature$4)
    return options;
  if (this._importDER(options, enc))
    return;
  assert$4$1(options.r && options.s, "Signature without r or s");
  this.r = new BN$9(options.r, 16);
  this.s = new BN$9(options.s, 16);
  if (options.recoveryParam === void 0)
    this.recoveryParam = null;
  else
    this.recoveryParam = options.recoveryParam;
}
var signature$2 = Signature$4;
function Position$1() {
  this.place = 0;
}
function getLength$1(buf, p3) {
  var initial = buf[p3.place++];
  if (!(initial & 128)) {
    return initial;
  }
  var octetLen = initial & 15;
  if (octetLen === 0 || octetLen > 4) {
    return false;
  }
  var val = 0;
  for (var i3 = 0, off = p3.place; i3 < octetLen; i3++, off++) {
    val <<= 8;
    val |= buf[off];
    val >>>= 0;
  }
  if (val <= 127) {
    return false;
  }
  p3.place = off;
  return val;
}
function rmPadding$1(buf) {
  var i3 = 0;
  var len = buf.length - 1;
  while (!buf[i3] && !(buf[i3 + 1] & 128) && i3 < len) {
    i3++;
  }
  if (i3 === 0) {
    return buf;
  }
  return buf.slice(i3);
}
Signature$4.prototype._importDER = function _importDER(data, enc) {
  data = utils_1$1.toArray(data, enc);
  var p3 = new Position$1();
  if (data[p3.place++] !== 48) {
    return false;
  }
  var len = getLength$1(data, p3);
  if (len === false) {
    return false;
  }
  if (len + p3.place !== data.length) {
    return false;
  }
  if (data[p3.place++] !== 2) {
    return false;
  }
  var rlen = getLength$1(data, p3);
  if (rlen === false) {
    return false;
  }
  var r2 = data.slice(p3.place, rlen + p3.place);
  p3.place += rlen;
  if (data[p3.place++] !== 2) {
    return false;
  }
  var slen = getLength$1(data, p3);
  if (slen === false) {
    return false;
  }
  if (data.length !== slen + p3.place) {
    return false;
  }
  var s2 = data.slice(p3.place, slen + p3.place);
  if (r2[0] === 0) {
    if (r2[1] & 128) {
      r2 = r2.slice(1);
    } else {
      return false;
    }
  }
  if (s2[0] === 0) {
    if (s2[1] & 128) {
      s2 = s2.slice(1);
    } else {
      return false;
    }
  }
  this.r = new BN$9(r2);
  this.s = new BN$9(s2);
  this.recoveryParam = null;
  return true;
};
function constructLength$1(arr, len) {
  if (len < 128) {
    arr.push(len);
    return;
  }
  var octets = 1 + (Math.log(len) / Math.LN2 >>> 3);
  arr.push(octets | 128);
  while (--octets) {
    arr.push(len >>> (octets << 3) & 255);
  }
  arr.push(len);
}
Signature$4.prototype.toDER = function toDER(enc) {
  var r2 = this.r.toArray();
  var s2 = this.s.toArray();
  if (r2[0] & 128)
    r2 = [0].concat(r2);
  if (s2[0] & 128)
    s2 = [0].concat(s2);
  r2 = rmPadding$1(r2);
  s2 = rmPadding$1(s2);
  while (!s2[0] && !(s2[1] & 128)) {
    s2 = s2.slice(1);
  }
  var arr = [2];
  constructLength$1(arr, r2.length);
  arr = arr.concat(r2);
  arr.push(2);
  constructLength$1(arr, s2.length);
  var backHalf = arr.concat(s2);
  var res = [48];
  constructLength$1(res, backHalf.length);
  res = res.concat(backHalf);
  return utils_1$1.encode(res, enc);
};
var rand$1 = (
  /*RicMoo:ethers:require(brorand)*/
  function() {
    throw new Error("unsupported");
  }
);
var assert$5$1 = utils_1$1.assert;
function EC$1(options) {
  if (!(this instanceof EC$1))
    return new EC$1(options);
  if (typeof options === "string") {
    assert$5$1(
      Object.prototype.hasOwnProperty.call(curves_1, options),
      "Unknown curve " + options
    );
    options = curves_1[options];
  }
  if (options instanceof curves_1.PresetCurve)
    options = { curve: options };
  this.curve = options.curve.curve;
  this.n = this.curve.n;
  this.nh = this.n.ushrn(1);
  this.g = this.curve.g;
  this.g = options.curve.g;
  this.g.precompute(options.curve.n.bitLength() + 1);
  this.hash = options.hash || options.curve.hash;
}
var ec$1 = EC$1;
EC$1.prototype.keyPair = function keyPair(options) {
  return new key$2(this, options);
};
EC$1.prototype.keyFromPrivate = function keyFromPrivate(priv2, enc) {
  return key$2.fromPrivate(this, priv2, enc);
};
EC$1.prototype.keyFromPublic = function keyFromPublic(pub2, enc) {
  return key$2.fromPublic(this, pub2, enc);
};
EC$1.prototype.genKeyPair = function genKeyPair(options) {
  if (!options)
    options = {};
  var drbg = new hmacDrbg({
    hash: this.hash,
    pers: options.pers,
    persEnc: options.persEnc || "utf8",
    entropy: options.entropy || rand$1(this.hash.hmacStrength),
    entropyEnc: options.entropy && options.entropyEnc || "utf8",
    nonce: this.n.toArray()
  });
  var bytes = this.n.byteLength();
  var ns2 = this.n.sub(new BN$9(2));
  for (; ; ) {
    var priv2 = new BN$9(drbg.generate(bytes));
    if (priv2.cmp(ns2) > 0)
      continue;
    priv2.iaddn(1);
    return this.keyFromPrivate(priv2);
  }
};
EC$1.prototype._truncateToN = function _truncateToN(msg, truncOnly) {
  var delta = msg.byteLength() * 8 - this.n.bitLength();
  if (delta > 0)
    msg = msg.ushrn(delta);
  if (!truncOnly && msg.cmp(this.n) >= 0)
    return msg.sub(this.n);
  else
    return msg;
};
EC$1.prototype.sign = function sign2(msg, key2, enc, options) {
  if (typeof enc === "object") {
    options = enc;
    enc = null;
  }
  if (!options)
    options = {};
  key2 = this.keyFromPrivate(key2, enc);
  msg = this._truncateToN(new BN$9(msg, 16));
  var bytes = this.n.byteLength();
  var bkey = key2.getPrivate().toArray("be", bytes);
  var nonce = msg.toArray("be", bytes);
  var drbg = new hmacDrbg({
    hash: this.hash,
    entropy: bkey,
    nonce,
    pers: options.pers,
    persEnc: options.persEnc || "utf8"
  });
  var ns1 = this.n.sub(new BN$9(1));
  for (var iter = 0; ; iter++) {
    var k2 = options.k ? options.k(iter) : new BN$9(drbg.generate(this.n.byteLength()));
    k2 = this._truncateToN(k2, true);
    if (k2.cmpn(1) <= 0 || k2.cmp(ns1) >= 0)
      continue;
    var kp = this.g.mul(k2);
    if (kp.isInfinity())
      continue;
    var kpX = kp.getX();
    var r2 = kpX.umod(this.n);
    if (r2.cmpn(0) === 0)
      continue;
    var s2 = k2.invm(this.n).mul(r2.mul(key2.getPrivate()).iadd(msg));
    s2 = s2.umod(this.n);
    if (s2.cmpn(0) === 0)
      continue;
    var recoveryParam = (kp.getY().isOdd() ? 1 : 0) | (kpX.cmp(r2) !== 0 ? 2 : 0);
    if (options.canonical && s2.cmp(this.nh) > 0) {
      s2 = this.n.sub(s2);
      recoveryParam ^= 1;
    }
    return new signature$2({ r: r2, s: s2, recoveryParam });
  }
};
EC$1.prototype.verify = function verify2(msg, signature$12, key2, enc) {
  msg = this._truncateToN(new BN$9(msg, 16));
  key2 = this.keyFromPublic(key2, enc);
  signature$12 = new signature$2(signature$12, "hex");
  var r2 = signature$12.r;
  var s2 = signature$12.s;
  if (r2.cmpn(1) < 0 || r2.cmp(this.n) >= 0)
    return false;
  if (s2.cmpn(1) < 0 || s2.cmp(this.n) >= 0)
    return false;
  var sinv = s2.invm(this.n);
  var u1 = sinv.mul(msg).umod(this.n);
  var u2 = sinv.mul(r2).umod(this.n);
  var p3;
  if (!this.curve._maxwellTrick) {
    p3 = this.g.mulAdd(u1, key2.getPublic(), u2);
    if (p3.isInfinity())
      return false;
    return p3.getX().umod(this.n).cmp(r2) === 0;
  }
  p3 = this.g.jmulAdd(u1, key2.getPublic(), u2);
  if (p3.isInfinity())
    return false;
  return p3.eqXToP(r2);
};
EC$1.prototype.recoverPubKey = function(msg, signature$12, j2, enc) {
  assert$5$1((3 & j2) === j2, "The recovery param is more than two bits");
  signature$12 = new signature$2(signature$12, enc);
  var n4 = this.n;
  var e2 = new BN$9(msg);
  var r2 = signature$12.r;
  var s2 = signature$12.s;
  var isYOdd = j2 & 1;
  var isSecondKey = j2 >> 1;
  if (r2.cmp(this.curve.p.umod(this.curve.n)) >= 0 && isSecondKey)
    throw new Error("Unable to find sencond key candinate");
  if (isSecondKey)
    r2 = this.curve.pointFromX(r2.add(this.curve.n), isYOdd);
  else
    r2 = this.curve.pointFromX(r2, isYOdd);
  var rInv = signature$12.r.invm(n4);
  var s1 = n4.sub(e2).mul(rInv).umod(n4);
  var s22 = s2.mul(rInv).umod(n4);
  return this.g.mulAdd(s1, r2, s22);
};
EC$1.prototype.getKeyRecoveryParam = function(e2, signature$12, Q2, enc) {
  signature$12 = new signature$2(signature$12, enc);
  if (signature$12.recoveryParam !== null)
    return signature$12.recoveryParam;
  for (var i3 = 0; i3 < 4; i3++) {
    var Qprime;
    try {
      Qprime = this.recoverPubKey(e2, signature$12, i3);
    } catch (e3) {
      continue;
    }
    if (Qprime.eq(Q2))
      return i3;
  }
  throw new Error("Unable to find valid recovery factor");
};
var elliptic_1 = createCommonjsModule(function(module, exports) {
  var elliptic2 = exports;
  elliptic2.version = /*RicMoo:ethers*/
  { version: "6.5.4" }.version;
  elliptic2.utils = utils_1$1;
  elliptic2.rand = /*RicMoo:ethers:require(brorand)*/
  function() {
    throw new Error("unsupported");
  };
  elliptic2.curve = curve_1;
  elliptic2.curves = curves_1;
  elliptic2.ec = ec$1;
  elliptic2.eddsa = /*RicMoo:ethers:require(./elliptic/eddsa)*/
  null;
});
var EC$1$1 = elliptic_1.ec;
const version$1 = "signing-key/5.7.0";
const logger = new Logger(version$1);
let _curve = null;
function getCurve() {
  if (!_curve) {
    _curve = new EC$1$1("secp256k1");
  }
  return _curve;
}
class SigningKey {
  constructor(privateKey) {
    defineReadOnly(this, "curve", "secp256k1");
    defineReadOnly(this, "privateKey", hexlify(privateKey));
    if (hexDataLength(this.privateKey) !== 32) {
      logger.throwArgumentError("invalid private key", "privateKey", "[[ REDACTED ]]");
    }
    const keyPair3 = getCurve().keyFromPrivate(arrayify(this.privateKey));
    defineReadOnly(this, "publicKey", "0x" + keyPair3.getPublic(false, "hex"));
    defineReadOnly(this, "compressedPublicKey", "0x" + keyPair3.getPublic(true, "hex"));
    defineReadOnly(this, "_isSigningKey", true);
  }
  _addPoint(other) {
    const p0 = getCurve().keyFromPublic(arrayify(this.publicKey));
    const p1 = getCurve().keyFromPublic(arrayify(other));
    return "0x" + p0.pub.add(p1.pub).encodeCompressed("hex");
  }
  signDigest(digest) {
    const keyPair3 = getCurve().keyFromPrivate(arrayify(this.privateKey));
    const digestBytes = arrayify(digest);
    if (digestBytes.length !== 32) {
      logger.throwArgumentError("bad digest length", "digest", digest);
    }
    const signature2 = keyPair3.sign(digestBytes, { canonical: true });
    return splitSignature({
      recoveryParam: signature2.recoveryParam,
      r: hexZeroPad("0x" + signature2.r.toString(16), 32),
      s: hexZeroPad("0x" + signature2.s.toString(16), 32)
    });
  }
  computeSharedSecret(otherKey) {
    const keyPair3 = getCurve().keyFromPrivate(arrayify(this.privateKey));
    const otherKeyPair = getCurve().keyFromPublic(arrayify(computePublicKey(otherKey)));
    return hexZeroPad("0x" + keyPair3.derive(otherKeyPair.getPublic()).toString(16), 32);
  }
  static isSigningKey(value) {
    return !!(value && value._isSigningKey);
  }
}
function recoverPublicKey(digest, signature2) {
  const sig = splitSignature(signature2);
  const rs = { r: arrayify(sig.r), s: arrayify(sig.s) };
  return "0x" + getCurve().recoverPubKey(arrayify(digest), rs, sig.recoveryParam).encode("hex", false);
}
function computePublicKey(key2, compressed) {
  const bytes = arrayify(key2);
  if (bytes.length === 32) {
    const signingKey = new SigningKey(bytes);
    return signingKey.publicKey;
  } else if (bytes.length === 33) {
    return "0x" + getCurve().keyFromPublic(bytes).getPublic(false, "hex");
  } else if (bytes.length === 65) {
    {
      return hexlify(bytes);
    }
  }
  return logger.throwArgumentError("invalid public or private key", "key", "[REDACTED]");
}
var TransactionTypes;
(function(TransactionTypes2) {
  TransactionTypes2[TransactionTypes2["legacy"] = 0] = "legacy";
  TransactionTypes2[TransactionTypes2["eip2930"] = 1] = "eip2930";
  TransactionTypes2[TransactionTypes2["eip1559"] = 2] = "eip1559";
})(TransactionTypes || (TransactionTypes = {}));
function computeAddress(key2) {
  const publicKey = computePublicKey(key2);
  return getAddress(hexDataSlice(keccak256(hexDataSlice(publicKey, 1)), 12));
}
function recoverAddress(digest, signature2) {
  return computeAddress(recoverPublicKey(arrayify(digest), signature2));
}
var chacha20poly1305 = {};
var chacha = {};
var binary$1 = {};
var int$1 = {};
(function(exports) {
  Object.defineProperty(exports, "__esModule", { value: true });
  function imulShim(a3, b2) {
    var ah = a3 >>> 16 & 65535, al = a3 & 65535;
    var bh = b2 >>> 16 & 65535, bl = b2 & 65535;
    return al * bl + (ah * bl + al * bh << 16 >>> 0) | 0;
  }
  exports.mul = Math.imul || imulShim;
  function add7(a3, b2) {
    return a3 + b2 | 0;
  }
  exports.add = add7;
  function sub(a3, b2) {
    return a3 - b2 | 0;
  }
  exports.sub = sub;
  function rotl(x3, n4) {
    return x3 << n4 | x3 >>> 32 - n4;
  }
  exports.rotl = rotl;
  function rotr(x3, n4) {
    return x3 << 32 - n4 | x3 >>> n4;
  }
  exports.rotr = rotr;
  function isIntegerShim(n4) {
    return typeof n4 === "number" && isFinite(n4) && Math.floor(n4) === n4;
  }
  exports.isInteger = Number.isInteger || isIntegerShim;
  exports.MAX_SAFE_INTEGER = 9007199254740991;
  exports.isSafeInteger = function(n4) {
    return exports.isInteger(n4) && (n4 >= -exports.MAX_SAFE_INTEGER && n4 <= exports.MAX_SAFE_INTEGER);
  };
})(int$1);
Object.defineProperty(binary$1, "__esModule", { value: true });
var int_1$1 = int$1;
function readInt16BE$1(array, offset) {
  if (offset === void 0) {
    offset = 0;
  }
  return (array[offset + 0] << 8 | array[offset + 1]) << 16 >> 16;
}
binary$1.readInt16BE = readInt16BE$1;
function readUint16BE$1(array, offset) {
  if (offset === void 0) {
    offset = 0;
  }
  return (array[offset + 0] << 8 | array[offset + 1]) >>> 0;
}
binary$1.readUint16BE = readUint16BE$1;
function readInt16LE$1(array, offset) {
  if (offset === void 0) {
    offset = 0;
  }
  return (array[offset + 1] << 8 | array[offset]) << 16 >> 16;
}
binary$1.readInt16LE = readInt16LE$1;
function readUint16LE$1(array, offset) {
  if (offset === void 0) {
    offset = 0;
  }
  return (array[offset + 1] << 8 | array[offset]) >>> 0;
}
binary$1.readUint16LE = readUint16LE$1;
function writeUint16BE$1(value, out, offset) {
  if (out === void 0) {
    out = new Uint8Array(2);
  }
  if (offset === void 0) {
    offset = 0;
  }
  out[offset + 0] = value >>> 8;
  out[offset + 1] = value >>> 0;
  return out;
}
binary$1.writeUint16BE = writeUint16BE$1;
binary$1.writeInt16BE = writeUint16BE$1;
function writeUint16LE$1(value, out, offset) {
  if (out === void 0) {
    out = new Uint8Array(2);
  }
  if (offset === void 0) {
    offset = 0;
  }
  out[offset + 0] = value >>> 0;
  out[offset + 1] = value >>> 8;
  return out;
}
binary$1.writeUint16LE = writeUint16LE$1;
binary$1.writeInt16LE = writeUint16LE$1;
function readInt32BE$1(array, offset) {
  if (offset === void 0) {
    offset = 0;
  }
  return array[offset] << 24 | array[offset + 1] << 16 | array[offset + 2] << 8 | array[offset + 3];
}
binary$1.readInt32BE = readInt32BE$1;
function readUint32BE$1(array, offset) {
  if (offset === void 0) {
    offset = 0;
  }
  return (array[offset] << 24 | array[offset + 1] << 16 | array[offset + 2] << 8 | array[offset + 3]) >>> 0;
}
binary$1.readUint32BE = readUint32BE$1;
function readInt32LE$1(array, offset) {
  if (offset === void 0) {
    offset = 0;
  }
  return array[offset + 3] << 24 | array[offset + 2] << 16 | array[offset + 1] << 8 | array[offset];
}
binary$1.readInt32LE = readInt32LE$1;
function readUint32LE$1(array, offset) {
  if (offset === void 0) {
    offset = 0;
  }
  return (array[offset + 3] << 24 | array[offset + 2] << 16 | array[offset + 1] << 8 | array[offset]) >>> 0;
}
binary$1.readUint32LE = readUint32LE$1;
function writeUint32BE$1(value, out, offset) {
  if (out === void 0) {
    out = new Uint8Array(4);
  }
  if (offset === void 0) {
    offset = 0;
  }
  out[offset + 0] = value >>> 24;
  out[offset + 1] = value >>> 16;
  out[offset + 2] = value >>> 8;
  out[offset + 3] = value >>> 0;
  return out;
}
binary$1.writeUint32BE = writeUint32BE$1;
binary$1.writeInt32BE = writeUint32BE$1;
function writeUint32LE$1(value, out, offset) {
  if (out === void 0) {
    out = new Uint8Array(4);
  }
  if (offset === void 0) {
    offset = 0;
  }
  out[offset + 0] = value >>> 0;
  out[offset + 1] = value >>> 8;
  out[offset + 2] = value >>> 16;
  out[offset + 3] = value >>> 24;
  return out;
}
binary$1.writeUint32LE = writeUint32LE$1;
binary$1.writeInt32LE = writeUint32LE$1;
function readInt64BE$1(array, offset) {
  if (offset === void 0) {
    offset = 0;
  }
  var hi2 = readInt32BE$1(array, offset);
  var lo2 = readInt32BE$1(array, offset + 4);
  return hi2 * 4294967296 + lo2 - (lo2 >> 31) * 4294967296;
}
binary$1.readInt64BE = readInt64BE$1;
function readUint64BE$1(array, offset) {
  if (offset === void 0) {
    offset = 0;
  }
  var hi2 = readUint32BE$1(array, offset);
  var lo2 = readUint32BE$1(array, offset + 4);
  return hi2 * 4294967296 + lo2;
}
binary$1.readUint64BE = readUint64BE$1;
function readInt64LE$1(array, offset) {
  if (offset === void 0) {
    offset = 0;
  }
  var lo2 = readInt32LE$1(array, offset);
  var hi2 = readInt32LE$1(array, offset + 4);
  return hi2 * 4294967296 + lo2 - (lo2 >> 31) * 4294967296;
}
binary$1.readInt64LE = readInt64LE$1;
function readUint64LE$1(array, offset) {
  if (offset === void 0) {
    offset = 0;
  }
  var lo2 = readUint32LE$1(array, offset);
  var hi2 = readUint32LE$1(array, offset + 4);
  return hi2 * 4294967296 + lo2;
}
binary$1.readUint64LE = readUint64LE$1;
function writeUint64BE$1(value, out, offset) {
  if (out === void 0) {
    out = new Uint8Array(8);
  }
  if (offset === void 0) {
    offset = 0;
  }
  writeUint32BE$1(value / 4294967296 >>> 0, out, offset);
  writeUint32BE$1(value >>> 0, out, offset + 4);
  return out;
}
binary$1.writeUint64BE = writeUint64BE$1;
binary$1.writeInt64BE = writeUint64BE$1;
function writeUint64LE$1(value, out, offset) {
  if (out === void 0) {
    out = new Uint8Array(8);
  }
  if (offset === void 0) {
    offset = 0;
  }
  writeUint32LE$1(value >>> 0, out, offset);
  writeUint32LE$1(value / 4294967296 >>> 0, out, offset + 4);
  return out;
}
binary$1.writeUint64LE = writeUint64LE$1;
binary$1.writeInt64LE = writeUint64LE$1;
function readUintBE$1(bitLength, array, offset) {
  if (offset === void 0) {
    offset = 0;
  }
  if (bitLength % 8 !== 0) {
    throw new Error("readUintBE supports only bitLengths divisible by 8");
  }
  if (bitLength / 8 > array.length - offset) {
    throw new Error("readUintBE: array is too short for the given bitLength");
  }
  var result = 0;
  var mul7 = 1;
  for (var i3 = bitLength / 8 + offset - 1; i3 >= offset; i3--) {
    result += array[i3] * mul7;
    mul7 *= 256;
  }
  return result;
}
binary$1.readUintBE = readUintBE$1;
function readUintLE$1(bitLength, array, offset) {
  if (offset === void 0) {
    offset = 0;
  }
  if (bitLength % 8 !== 0) {
    throw new Error("readUintLE supports only bitLengths divisible by 8");
  }
  if (bitLength / 8 > array.length - offset) {
    throw new Error("readUintLE: array is too short for the given bitLength");
  }
  var result = 0;
  var mul7 = 1;
  for (var i3 = offset; i3 < offset + bitLength / 8; i3++) {
    result += array[i3] * mul7;
    mul7 *= 256;
  }
  return result;
}
binary$1.readUintLE = readUintLE$1;
function writeUintBE$1(bitLength, value, out, offset) {
  if (out === void 0) {
    out = new Uint8Array(bitLength / 8);
  }
  if (offset === void 0) {
    offset = 0;
  }
  if (bitLength % 8 !== 0) {
    throw new Error("writeUintBE supports only bitLengths divisible by 8");
  }
  if (!int_1$1.isSafeInteger(value)) {
    throw new Error("writeUintBE value must be an integer");
  }
  var div = 1;
  for (var i3 = bitLength / 8 + offset - 1; i3 >= offset; i3--) {
    out[i3] = value / div & 255;
    div *= 256;
  }
  return out;
}
binary$1.writeUintBE = writeUintBE$1;
function writeUintLE$1(bitLength, value, out, offset) {
  if (out === void 0) {
    out = new Uint8Array(bitLength / 8);
  }
  if (offset === void 0) {
    offset = 0;
  }
  if (bitLength % 8 !== 0) {
    throw new Error("writeUintLE supports only bitLengths divisible by 8");
  }
  if (!int_1$1.isSafeInteger(value)) {
    throw new Error("writeUintLE value must be an integer");
  }
  var div = 1;
  for (var i3 = offset; i3 < offset + bitLength / 8; i3++) {
    out[i3] = value / div & 255;
    div *= 256;
  }
  return out;
}
binary$1.writeUintLE = writeUintLE$1;
function readFloat32BE$1(array, offset) {
  if (offset === void 0) {
    offset = 0;
  }
  var view = new DataView(array.buffer, array.byteOffset, array.byteLength);
  return view.getFloat32(offset);
}
binary$1.readFloat32BE = readFloat32BE$1;
function readFloat32LE$1(array, offset) {
  if (offset === void 0) {
    offset = 0;
  }
  var view = new DataView(array.buffer, array.byteOffset, array.byteLength);
  return view.getFloat32(offset, true);
}
binary$1.readFloat32LE = readFloat32LE$1;
function readFloat64BE$1(array, offset) {
  if (offset === void 0) {
    offset = 0;
  }
  var view = new DataView(array.buffer, array.byteOffset, array.byteLength);
  return view.getFloat64(offset);
}
binary$1.readFloat64BE = readFloat64BE$1;
function readFloat64LE$1(array, offset) {
  if (offset === void 0) {
    offset = 0;
  }
  var view = new DataView(array.buffer, array.byteOffset, array.byteLength);
  return view.getFloat64(offset, true);
}
binary$1.readFloat64LE = readFloat64LE$1;
function writeFloat32BE$1(value, out, offset) {
  if (out === void 0) {
    out = new Uint8Array(4);
  }
  if (offset === void 0) {
    offset = 0;
  }
  var view = new DataView(out.buffer, out.byteOffset, out.byteLength);
  view.setFloat32(offset, value);
  return out;
}
binary$1.writeFloat32BE = writeFloat32BE$1;
function writeFloat32LE$1(value, out, offset) {
  if (out === void 0) {
    out = new Uint8Array(4);
  }
  if (offset === void 0) {
    offset = 0;
  }
  var view = new DataView(out.buffer, out.byteOffset, out.byteLength);
  view.setFloat32(offset, value, true);
  return out;
}
binary$1.writeFloat32LE = writeFloat32LE$1;
function writeFloat64BE$1(value, out, offset) {
  if (out === void 0) {
    out = new Uint8Array(8);
  }
  if (offset === void 0) {
    offset = 0;
  }
  var view = new DataView(out.buffer, out.byteOffset, out.byteLength);
  view.setFloat64(offset, value);
  return out;
}
binary$1.writeFloat64BE = writeFloat64BE$1;
function writeFloat64LE$1(value, out, offset) {
  if (out === void 0) {
    out = new Uint8Array(8);
  }
  if (offset === void 0) {
    offset = 0;
  }
  var view = new DataView(out.buffer, out.byteOffset, out.byteLength);
  view.setFloat64(offset, value, true);
  return out;
}
binary$1.writeFloat64LE = writeFloat64LE$1;
var wipe$7 = {};
Object.defineProperty(wipe$7, "__esModule", { value: true });
function wipe$6(array) {
  for (var i3 = 0; i3 < array.length; i3++) {
    array[i3] = 0;
  }
  return array;
}
wipe$7.wipe = wipe$6;
Object.defineProperty(chacha, "__esModule", { value: true });
var binary_1 = binary$1;
var wipe_1$2 = wipe$7;
var ROUNDS = 20;
function core(out, input, key2) {
  var j0 = 1634760805;
  var j1 = 857760878;
  var j2 = 2036477234;
  var j3 = 1797285236;
  var j4 = key2[3] << 24 | key2[2] << 16 | key2[1] << 8 | key2[0];
  var j5 = key2[7] << 24 | key2[6] << 16 | key2[5] << 8 | key2[4];
  var j6 = key2[11] << 24 | key2[10] << 16 | key2[9] << 8 | key2[8];
  var j7 = key2[15] << 24 | key2[14] << 16 | key2[13] << 8 | key2[12];
  var j8 = key2[19] << 24 | key2[18] << 16 | key2[17] << 8 | key2[16];
  var j9 = key2[23] << 24 | key2[22] << 16 | key2[21] << 8 | key2[20];
  var j10 = key2[27] << 24 | key2[26] << 16 | key2[25] << 8 | key2[24];
  var j11 = key2[31] << 24 | key2[30] << 16 | key2[29] << 8 | key2[28];
  var j12 = input[3] << 24 | input[2] << 16 | input[1] << 8 | input[0];
  var j13 = input[7] << 24 | input[6] << 16 | input[5] << 8 | input[4];
  var j14 = input[11] << 24 | input[10] << 16 | input[9] << 8 | input[8];
  var j15 = input[15] << 24 | input[14] << 16 | input[13] << 8 | input[12];
  var x0 = j0;
  var x1 = j1;
  var x22 = j2;
  var x3 = j3;
  var x4 = j4;
  var x5 = j5;
  var x6 = j6;
  var x7 = j7;
  var x8 = j8;
  var x9 = j9;
  var x10 = j10;
  var x11 = j11;
  var x12 = j12;
  var x13 = j13;
  var x14 = j14;
  var x15 = j15;
  for (var i3 = 0; i3 < ROUNDS; i3 += 2) {
    x0 = x0 + x4 | 0;
    x12 ^= x0;
    x12 = x12 >>> 32 - 16 | x12 << 16;
    x8 = x8 + x12 | 0;
    x4 ^= x8;
    x4 = x4 >>> 32 - 12 | x4 << 12;
    x1 = x1 + x5 | 0;
    x13 ^= x1;
    x13 = x13 >>> 32 - 16 | x13 << 16;
    x9 = x9 + x13 | 0;
    x5 ^= x9;
    x5 = x5 >>> 32 - 12 | x5 << 12;
    x22 = x22 + x6 | 0;
    x14 ^= x22;
    x14 = x14 >>> 32 - 16 | x14 << 16;
    x10 = x10 + x14 | 0;
    x6 ^= x10;
    x6 = x6 >>> 32 - 12 | x6 << 12;
    x3 = x3 + x7 | 0;
    x15 ^= x3;
    x15 = x15 >>> 32 - 16 | x15 << 16;
    x11 = x11 + x15 | 0;
    x7 ^= x11;
    x7 = x7 >>> 32 - 12 | x7 << 12;
    x22 = x22 + x6 | 0;
    x14 ^= x22;
    x14 = x14 >>> 32 - 8 | x14 << 8;
    x10 = x10 + x14 | 0;
    x6 ^= x10;
    x6 = x6 >>> 32 - 7 | x6 << 7;
    x3 = x3 + x7 | 0;
    x15 ^= x3;
    x15 = x15 >>> 32 - 8 | x15 << 8;
    x11 = x11 + x15 | 0;
    x7 ^= x11;
    x7 = x7 >>> 32 - 7 | x7 << 7;
    x1 = x1 + x5 | 0;
    x13 ^= x1;
    x13 = x13 >>> 32 - 8 | x13 << 8;
    x9 = x9 + x13 | 0;
    x5 ^= x9;
    x5 = x5 >>> 32 - 7 | x5 << 7;
    x0 = x0 + x4 | 0;
    x12 ^= x0;
    x12 = x12 >>> 32 - 8 | x12 << 8;
    x8 = x8 + x12 | 0;
    x4 ^= x8;
    x4 = x4 >>> 32 - 7 | x4 << 7;
    x0 = x0 + x5 | 0;
    x15 ^= x0;
    x15 = x15 >>> 32 - 16 | x15 << 16;
    x10 = x10 + x15 | 0;
    x5 ^= x10;
    x5 = x5 >>> 32 - 12 | x5 << 12;
    x1 = x1 + x6 | 0;
    x12 ^= x1;
    x12 = x12 >>> 32 - 16 | x12 << 16;
    x11 = x11 + x12 | 0;
    x6 ^= x11;
    x6 = x6 >>> 32 - 12 | x6 << 12;
    x22 = x22 + x7 | 0;
    x13 ^= x22;
    x13 = x13 >>> 32 - 16 | x13 << 16;
    x8 = x8 + x13 | 0;
    x7 ^= x8;
    x7 = x7 >>> 32 - 12 | x7 << 12;
    x3 = x3 + x4 | 0;
    x14 ^= x3;
    x14 = x14 >>> 32 - 16 | x14 << 16;
    x9 = x9 + x14 | 0;
    x4 ^= x9;
    x4 = x4 >>> 32 - 12 | x4 << 12;
    x22 = x22 + x7 | 0;
    x13 ^= x22;
    x13 = x13 >>> 32 - 8 | x13 << 8;
    x8 = x8 + x13 | 0;
    x7 ^= x8;
    x7 = x7 >>> 32 - 7 | x7 << 7;
    x3 = x3 + x4 | 0;
    x14 ^= x3;
    x14 = x14 >>> 32 - 8 | x14 << 8;
    x9 = x9 + x14 | 0;
    x4 ^= x9;
    x4 = x4 >>> 32 - 7 | x4 << 7;
    x1 = x1 + x6 | 0;
    x12 ^= x1;
    x12 = x12 >>> 32 - 8 | x12 << 8;
    x11 = x11 + x12 | 0;
    x6 ^= x11;
    x6 = x6 >>> 32 - 7 | x6 << 7;
    x0 = x0 + x5 | 0;
    x15 ^= x0;
    x15 = x15 >>> 32 - 8 | x15 << 8;
    x10 = x10 + x15 | 0;
    x5 ^= x10;
    x5 = x5 >>> 32 - 7 | x5 << 7;
  }
  binary_1.writeUint32LE(x0 + j0 | 0, out, 0);
  binary_1.writeUint32LE(x1 + j1 | 0, out, 4);
  binary_1.writeUint32LE(x22 + j2 | 0, out, 8);
  binary_1.writeUint32LE(x3 + j3 | 0, out, 12);
  binary_1.writeUint32LE(x4 + j4 | 0, out, 16);
  binary_1.writeUint32LE(x5 + j5 | 0, out, 20);
  binary_1.writeUint32LE(x6 + j6 | 0, out, 24);
  binary_1.writeUint32LE(x7 + j7 | 0, out, 28);
  binary_1.writeUint32LE(x8 + j8 | 0, out, 32);
  binary_1.writeUint32LE(x9 + j9 | 0, out, 36);
  binary_1.writeUint32LE(x10 + j10 | 0, out, 40);
  binary_1.writeUint32LE(x11 + j11 | 0, out, 44);
  binary_1.writeUint32LE(x12 + j12 | 0, out, 48);
  binary_1.writeUint32LE(x13 + j13 | 0, out, 52);
  binary_1.writeUint32LE(x14 + j14 | 0, out, 56);
  binary_1.writeUint32LE(x15 + j15 | 0, out, 60);
}
function streamXOR(key2, nonce, src2, dst, nonceInplaceCounterLength) {
  if (nonceInplaceCounterLength === void 0) {
    nonceInplaceCounterLength = 0;
  }
  if (key2.length !== 32) {
    throw new Error("ChaCha: key size must be 32 bytes");
  }
  if (dst.length < src2.length) {
    throw new Error("ChaCha: destination is shorter than source");
  }
  var nc;
  var counterLength;
  if (nonceInplaceCounterLength === 0) {
    if (nonce.length !== 8 && nonce.length !== 12) {
      throw new Error("ChaCha nonce must be 8 or 12 bytes");
    }
    nc = new Uint8Array(16);
    counterLength = nc.length - nonce.length;
    nc.set(nonce, counterLength);
  } else {
    if (nonce.length !== 16) {
      throw new Error("ChaCha nonce with counter must be 16 bytes");
    }
    nc = nonce;
    counterLength = nonceInplaceCounterLength;
  }
  var block = new Uint8Array(64);
  for (var i3 = 0; i3 < src2.length; i3 += 64) {
    core(block, nc, key2);
    for (var j2 = i3; j2 < i3 + 64 && j2 < src2.length; j2++) {
      dst[j2] = src2[j2] ^ block[j2 - i3];
    }
    incrementCounter(nc, 0, counterLength);
  }
  wipe_1$2.wipe(block);
  if (nonceInplaceCounterLength === 0) {
    wipe_1$2.wipe(nc);
  }
  return dst;
}
chacha.streamXOR = streamXOR;
function stream(key2, nonce, dst, nonceInplaceCounterLength) {
  if (nonceInplaceCounterLength === void 0) {
    nonceInplaceCounterLength = 0;
  }
  wipe_1$2.wipe(dst);
  return streamXOR(key2, nonce, dst, dst, nonceInplaceCounterLength);
}
chacha.stream = stream;
function incrementCounter(counter, pos, len) {
  var carry = 1;
  while (len--) {
    carry = carry + (counter[pos] & 255) | 0;
    counter[pos] = carry & 255;
    carry >>>= 8;
    pos++;
  }
  if (carry > 0) {
    throw new Error("ChaCha: counter overflow");
  }
}
var poly1305 = {};
var constantTime$1 = {};
Object.defineProperty(constantTime$1, "__esModule", { value: true });
function select$1(subject, resultIfOne, resultIfZero) {
  return ~(subject - 1) & resultIfOne | subject - 1 & resultIfZero;
}
constantTime$1.select = select$1;
function lessOrEqual$1(a3, b2) {
  return (a3 | 0) - (b2 | 0) - 1 >>> 31 & 1;
}
constantTime$1.lessOrEqual = lessOrEqual$1;
function compare$1(a3, b2) {
  if (a3.length !== b2.length) {
    return 0;
  }
  var result = 0;
  for (var i3 = 0; i3 < a3.length; i3++) {
    result |= a3[i3] ^ b2[i3];
  }
  return 1 & result - 1 >>> 8;
}
constantTime$1.compare = compare$1;
function equal$1(a3, b2) {
  if (a3.length === 0 || b2.length === 0) {
    return false;
  }
  return compare$1(a3, b2) !== 0;
}
constantTime$1.equal = equal$1;
(function(exports) {
  Object.defineProperty(exports, "__esModule", { value: true });
  var constant_time_12 = constantTime$1;
  var wipe_12 = wipe$7;
  exports.DIGEST_LENGTH = 16;
  var Poly1305 = (
    /** @class */
    function() {
      function Poly13052(key2) {
        this.digestLength = exports.DIGEST_LENGTH;
        this._buffer = new Uint8Array(16);
        this._r = new Uint16Array(10);
        this._h = new Uint16Array(10);
        this._pad = new Uint16Array(8);
        this._leftover = 0;
        this._fin = 0;
        this._finished = false;
        var t0 = key2[0] | key2[1] << 8;
        this._r[0] = t0 & 8191;
        var t1 = key2[2] | key2[3] << 8;
        this._r[1] = (t0 >>> 13 | t1 << 3) & 8191;
        var t2 = key2[4] | key2[5] << 8;
        this._r[2] = (t1 >>> 10 | t2 << 6) & 7939;
        var t3 = key2[6] | key2[7] << 8;
        this._r[3] = (t2 >>> 7 | t3 << 9) & 8191;
        var t4 = key2[8] | key2[9] << 8;
        this._r[4] = (t3 >>> 4 | t4 << 12) & 255;
        this._r[5] = t4 >>> 1 & 8190;
        var t5 = key2[10] | key2[11] << 8;
        this._r[6] = (t4 >>> 14 | t5 << 2) & 8191;
        var t6 = key2[12] | key2[13] << 8;
        this._r[7] = (t5 >>> 11 | t6 << 5) & 8065;
        var t7 = key2[14] | key2[15] << 8;
        this._r[8] = (t6 >>> 8 | t7 << 8) & 8191;
        this._r[9] = t7 >>> 5 & 127;
        this._pad[0] = key2[16] | key2[17] << 8;
        this._pad[1] = key2[18] | key2[19] << 8;
        this._pad[2] = key2[20] | key2[21] << 8;
        this._pad[3] = key2[22] | key2[23] << 8;
        this._pad[4] = key2[24] | key2[25] << 8;
        this._pad[5] = key2[26] | key2[27] << 8;
        this._pad[6] = key2[28] | key2[29] << 8;
        this._pad[7] = key2[30] | key2[31] << 8;
      }
      Poly13052.prototype._blocks = function(m2, mpos, bytes) {
        var hibit = this._fin ? 0 : 1 << 11;
        var h0 = this._h[0], h1 = this._h[1], h22 = this._h[2], h32 = this._h[3], h4 = this._h[4], h5 = this._h[5], h6 = this._h[6], h7 = this._h[7], h8 = this._h[8], h9 = this._h[9];
        var r0 = this._r[0], r1 = this._r[1], r2 = this._r[2], r3 = this._r[3], r4 = this._r[4], r5 = this._r[5], r6 = this._r[6], r7 = this._r[7], r8 = this._r[8], r9 = this._r[9];
        while (bytes >= 16) {
          var t0 = m2[mpos + 0] | m2[mpos + 1] << 8;
          h0 += t0 & 8191;
          var t1 = m2[mpos + 2] | m2[mpos + 3] << 8;
          h1 += (t0 >>> 13 | t1 << 3) & 8191;
          var t2 = m2[mpos + 4] | m2[mpos + 5] << 8;
          h22 += (t1 >>> 10 | t2 << 6) & 8191;
          var t3 = m2[mpos + 6] | m2[mpos + 7] << 8;
          h32 += (t2 >>> 7 | t3 << 9) & 8191;
          var t4 = m2[mpos + 8] | m2[mpos + 9] << 8;
          h4 += (t3 >>> 4 | t4 << 12) & 8191;
          h5 += t4 >>> 1 & 8191;
          var t5 = m2[mpos + 10] | m2[mpos + 11] << 8;
          h6 += (t4 >>> 14 | t5 << 2) & 8191;
          var t6 = m2[mpos + 12] | m2[mpos + 13] << 8;
          h7 += (t5 >>> 11 | t6 << 5) & 8191;
          var t7 = m2[mpos + 14] | m2[mpos + 15] << 8;
          h8 += (t6 >>> 8 | t7 << 8) & 8191;
          h9 += t7 >>> 5 | hibit;
          var c2 = 0;
          var d0 = c2;
          d0 += h0 * r0;
          d0 += h1 * (5 * r9);
          d0 += h22 * (5 * r8);
          d0 += h32 * (5 * r7);
          d0 += h4 * (5 * r6);
          c2 = d0 >>> 13;
          d0 &= 8191;
          d0 += h5 * (5 * r5);
          d0 += h6 * (5 * r4);
          d0 += h7 * (5 * r3);
          d0 += h8 * (5 * r2);
          d0 += h9 * (5 * r1);
          c2 += d0 >>> 13;
          d0 &= 8191;
          var d1 = c2;
          d1 += h0 * r1;
          d1 += h1 * r0;
          d1 += h22 * (5 * r9);
          d1 += h32 * (5 * r8);
          d1 += h4 * (5 * r7);
          c2 = d1 >>> 13;
          d1 &= 8191;
          d1 += h5 * (5 * r6);
          d1 += h6 * (5 * r5);
          d1 += h7 * (5 * r4);
          d1 += h8 * (5 * r3);
          d1 += h9 * (5 * r2);
          c2 += d1 >>> 13;
          d1 &= 8191;
          var d22 = c2;
          d22 += h0 * r2;
          d22 += h1 * r1;
          d22 += h22 * r0;
          d22 += h32 * (5 * r9);
          d22 += h4 * (5 * r8);
          c2 = d22 >>> 13;
          d22 &= 8191;
          d22 += h5 * (5 * r7);
          d22 += h6 * (5 * r6);
          d22 += h7 * (5 * r5);
          d22 += h8 * (5 * r4);
          d22 += h9 * (5 * r3);
          c2 += d22 >>> 13;
          d22 &= 8191;
          var d32 = c2;
          d32 += h0 * r3;
          d32 += h1 * r2;
          d32 += h22 * r1;
          d32 += h32 * r0;
          d32 += h4 * (5 * r9);
          c2 = d32 >>> 13;
          d32 &= 8191;
          d32 += h5 * (5 * r8);
          d32 += h6 * (5 * r7);
          d32 += h7 * (5 * r6);
          d32 += h8 * (5 * r5);
          d32 += h9 * (5 * r4);
          c2 += d32 >>> 13;
          d32 &= 8191;
          var d4 = c2;
          d4 += h0 * r4;
          d4 += h1 * r3;
          d4 += h22 * r2;
          d4 += h32 * r1;
          d4 += h4 * r0;
          c2 = d4 >>> 13;
          d4 &= 8191;
          d4 += h5 * (5 * r9);
          d4 += h6 * (5 * r8);
          d4 += h7 * (5 * r7);
          d4 += h8 * (5 * r6);
          d4 += h9 * (5 * r5);
          c2 += d4 >>> 13;
          d4 &= 8191;
          var d5 = c2;
          d5 += h0 * r5;
          d5 += h1 * r4;
          d5 += h22 * r3;
          d5 += h32 * r2;
          d5 += h4 * r1;
          c2 = d5 >>> 13;
          d5 &= 8191;
          d5 += h5 * r0;
          d5 += h6 * (5 * r9);
          d5 += h7 * (5 * r8);
          d5 += h8 * (5 * r7);
          d5 += h9 * (5 * r6);
          c2 += d5 >>> 13;
          d5 &= 8191;
          var d6 = c2;
          d6 += h0 * r6;
          d6 += h1 * r5;
          d6 += h22 * r4;
          d6 += h32 * r3;
          d6 += h4 * r2;
          c2 = d6 >>> 13;
          d6 &= 8191;
          d6 += h5 * r1;
          d6 += h6 * r0;
          d6 += h7 * (5 * r9);
          d6 += h8 * (5 * r8);
          d6 += h9 * (5 * r7);
          c2 += d6 >>> 13;
          d6 &= 8191;
          var d7 = c2;
          d7 += h0 * r7;
          d7 += h1 * r6;
          d7 += h22 * r5;
          d7 += h32 * r4;
          d7 += h4 * r3;
          c2 = d7 >>> 13;
          d7 &= 8191;
          d7 += h5 * r2;
          d7 += h6 * r1;
          d7 += h7 * r0;
          d7 += h8 * (5 * r9);
          d7 += h9 * (5 * r8);
          c2 += d7 >>> 13;
          d7 &= 8191;
          var d8 = c2;
          d8 += h0 * r8;
          d8 += h1 * r7;
          d8 += h22 * r6;
          d8 += h32 * r5;
          d8 += h4 * r4;
          c2 = d8 >>> 13;
          d8 &= 8191;
          d8 += h5 * r3;
          d8 += h6 * r2;
          d8 += h7 * r1;
          d8 += h8 * r0;
          d8 += h9 * (5 * r9);
          c2 += d8 >>> 13;
          d8 &= 8191;
          var d9 = c2;
          d9 += h0 * r9;
          d9 += h1 * r8;
          d9 += h22 * r7;
          d9 += h32 * r6;
          d9 += h4 * r5;
          c2 = d9 >>> 13;
          d9 &= 8191;
          d9 += h5 * r4;
          d9 += h6 * r3;
          d9 += h7 * r2;
          d9 += h8 * r1;
          d9 += h9 * r0;
          c2 += d9 >>> 13;
          d9 &= 8191;
          c2 = (c2 << 2) + c2 | 0;
          c2 = c2 + d0 | 0;
          d0 = c2 & 8191;
          c2 = c2 >>> 13;
          d1 += c2;
          h0 = d0;
          h1 = d1;
          h22 = d22;
          h32 = d32;
          h4 = d4;
          h5 = d5;
          h6 = d6;
          h7 = d7;
          h8 = d8;
          h9 = d9;
          mpos += 16;
          bytes -= 16;
        }
        this._h[0] = h0;
        this._h[1] = h1;
        this._h[2] = h22;
        this._h[3] = h32;
        this._h[4] = h4;
        this._h[5] = h5;
        this._h[6] = h6;
        this._h[7] = h7;
        this._h[8] = h8;
        this._h[9] = h9;
      };
      Poly13052.prototype.finish = function(mac, macpos) {
        if (macpos === void 0) {
          macpos = 0;
        }
        var g3 = new Uint16Array(10);
        var c2;
        var mask;
        var f3;
        var i3;
        if (this._leftover) {
          i3 = this._leftover;
          this._buffer[i3++] = 1;
          for (; i3 < 16; i3++) {
            this._buffer[i3] = 0;
          }
          this._fin = 1;
          this._blocks(this._buffer, 0, 16);
        }
        c2 = this._h[1] >>> 13;
        this._h[1] &= 8191;
        for (i3 = 2; i3 < 10; i3++) {
          this._h[i3] += c2;
          c2 = this._h[i3] >>> 13;
          this._h[i3] &= 8191;
        }
        this._h[0] += c2 * 5;
        c2 = this._h[0] >>> 13;
        this._h[0] &= 8191;
        this._h[1] += c2;
        c2 = this._h[1] >>> 13;
        this._h[1] &= 8191;
        this._h[2] += c2;
        g3[0] = this._h[0] + 5;
        c2 = g3[0] >>> 13;
        g3[0] &= 8191;
        for (i3 = 1; i3 < 10; i3++) {
          g3[i3] = this._h[i3] + c2;
          c2 = g3[i3] >>> 13;
          g3[i3] &= 8191;
        }
        g3[9] -= 1 << 13;
        mask = (c2 ^ 1) - 1;
        for (i3 = 0; i3 < 10; i3++) {
          g3[i3] &= mask;
        }
        mask = ~mask;
        for (i3 = 0; i3 < 10; i3++) {
          this._h[i3] = this._h[i3] & mask | g3[i3];
        }
        this._h[0] = (this._h[0] | this._h[1] << 13) & 65535;
        this._h[1] = (this._h[1] >>> 3 | this._h[2] << 10) & 65535;
        this._h[2] = (this._h[2] >>> 6 | this._h[3] << 7) & 65535;
        this._h[3] = (this._h[3] >>> 9 | this._h[4] << 4) & 65535;
        this._h[4] = (this._h[4] >>> 12 | this._h[5] << 1 | this._h[6] << 14) & 65535;
        this._h[5] = (this._h[6] >>> 2 | this._h[7] << 11) & 65535;
        this._h[6] = (this._h[7] >>> 5 | this._h[8] << 8) & 65535;
        this._h[7] = (this._h[8] >>> 8 | this._h[9] << 5) & 65535;
        f3 = this._h[0] + this._pad[0];
        this._h[0] = f3 & 65535;
        for (i3 = 1; i3 < 8; i3++) {
          f3 = (this._h[i3] + this._pad[i3] | 0) + (f3 >>> 16) | 0;
          this._h[i3] = f3 & 65535;
        }
        mac[macpos + 0] = this._h[0] >>> 0;
        mac[macpos + 1] = this._h[0] >>> 8;
        mac[macpos + 2] = this._h[1] >>> 0;
        mac[macpos + 3] = this._h[1] >>> 8;
        mac[macpos + 4] = this._h[2] >>> 0;
        mac[macpos + 5] = this._h[2] >>> 8;
        mac[macpos + 6] = this._h[3] >>> 0;
        mac[macpos + 7] = this._h[3] >>> 8;
        mac[macpos + 8] = this._h[4] >>> 0;
        mac[macpos + 9] = this._h[4] >>> 8;
        mac[macpos + 10] = this._h[5] >>> 0;
        mac[macpos + 11] = this._h[5] >>> 8;
        mac[macpos + 12] = this._h[6] >>> 0;
        mac[macpos + 13] = this._h[6] >>> 8;
        mac[macpos + 14] = this._h[7] >>> 0;
        mac[macpos + 15] = this._h[7] >>> 8;
        this._finished = true;
        return this;
      };
      Poly13052.prototype.update = function(m2) {
        var mpos = 0;
        var bytes = m2.length;
        var want;
        if (this._leftover) {
          want = 16 - this._leftover;
          if (want > bytes) {
            want = bytes;
          }
          for (var i3 = 0; i3 < want; i3++) {
            this._buffer[this._leftover + i3] = m2[mpos + i3];
          }
          bytes -= want;
          mpos += want;
          this._leftover += want;
          if (this._leftover < 16) {
            return this;
          }
          this._blocks(this._buffer, 0, 16);
          this._leftover = 0;
        }
        if (bytes >= 16) {
          want = bytes - bytes % 16;
          this._blocks(m2, mpos, want);
          mpos += want;
          bytes -= want;
        }
        if (bytes) {
          for (var i3 = 0; i3 < bytes; i3++) {
            this._buffer[this._leftover + i3] = m2[mpos + i3];
          }
          this._leftover += bytes;
        }
        return this;
      };
      Poly13052.prototype.digest = function() {
        if (this._finished) {
          throw new Error("Poly1305 was finished");
        }
        var mac = new Uint8Array(16);
        this.finish(mac);
        return mac;
      };
      Poly13052.prototype.clean = function() {
        wipe_12.wipe(this._buffer);
        wipe_12.wipe(this._r);
        wipe_12.wipe(this._h);
        wipe_12.wipe(this._pad);
        this._leftover = 0;
        this._fin = 0;
        this._finished = true;
        return this;
      };
      return Poly13052;
    }()
  );
  exports.Poly1305 = Poly1305;
  function oneTimeAuth(key2, data) {
    var h4 = new Poly1305(key2);
    h4.update(data);
    var digest = h4.digest();
    h4.clean();
    return digest;
  }
  exports.oneTimeAuth = oneTimeAuth;
  function equal2(a3, b2) {
    if (a3.length !== exports.DIGEST_LENGTH || b2.length !== exports.DIGEST_LENGTH) {
      return false;
    }
    return constant_time_12.equal(a3, b2);
  }
  exports.equal = equal2;
})(poly1305);
(function(exports) {
  Object.defineProperty(exports, "__esModule", { value: true });
  var chacha_1 = chacha;
  var poly1305_1 = poly1305;
  var wipe_12 = wipe$7;
  var binary_12 = binary$1;
  var constant_time_12 = constantTime$1;
  exports.KEY_LENGTH = 32;
  exports.NONCE_LENGTH = 12;
  exports.TAG_LENGTH = 16;
  var ZEROS = new Uint8Array(16);
  var ChaCha20Poly1305 = (
    /** @class */
    function() {
      function ChaCha20Poly13052(key2) {
        this.nonceLength = exports.NONCE_LENGTH;
        this.tagLength = exports.TAG_LENGTH;
        if (key2.length !== exports.KEY_LENGTH) {
          throw new Error("ChaCha20Poly1305 needs 32-byte key");
        }
        this._key = new Uint8Array(key2);
      }
      ChaCha20Poly13052.prototype.seal = function(nonce, plaintext, associatedData, dst) {
        if (nonce.length > 16) {
          throw new Error("ChaCha20Poly1305: incorrect nonce length");
        }
        var counter = new Uint8Array(16);
        counter.set(nonce, counter.length - nonce.length);
        var authKey = new Uint8Array(32);
        chacha_1.stream(this._key, counter, authKey, 4);
        var resultLength = plaintext.length + this.tagLength;
        var result;
        if (dst) {
          if (dst.length !== resultLength) {
            throw new Error("ChaCha20Poly1305: incorrect destination length");
          }
          result = dst;
        } else {
          result = new Uint8Array(resultLength);
        }
        chacha_1.streamXOR(this._key, counter, plaintext, result, 4);
        this._authenticate(result.subarray(result.length - this.tagLength, result.length), authKey, result.subarray(0, result.length - this.tagLength), associatedData);
        wipe_12.wipe(counter);
        return result;
      };
      ChaCha20Poly13052.prototype.open = function(nonce, sealed, associatedData, dst) {
        if (nonce.length > 16) {
          throw new Error("ChaCha20Poly1305: incorrect nonce length");
        }
        if (sealed.length < this.tagLength) {
          return null;
        }
        var counter = new Uint8Array(16);
        counter.set(nonce, counter.length - nonce.length);
        var authKey = new Uint8Array(32);
        chacha_1.stream(this._key, counter, authKey, 4);
        var calculatedTag = new Uint8Array(this.tagLength);
        this._authenticate(calculatedTag, authKey, sealed.subarray(0, sealed.length - this.tagLength), associatedData);
        if (!constant_time_12.equal(calculatedTag, sealed.subarray(sealed.length - this.tagLength, sealed.length))) {
          return null;
        }
        var resultLength = sealed.length - this.tagLength;
        var result;
        if (dst) {
          if (dst.length !== resultLength) {
            throw new Error("ChaCha20Poly1305: incorrect destination length");
          }
          result = dst;
        } else {
          result = new Uint8Array(resultLength);
        }
        chacha_1.streamXOR(this._key, counter, sealed.subarray(0, sealed.length - this.tagLength), result, 4);
        wipe_12.wipe(counter);
        return result;
      };
      ChaCha20Poly13052.prototype.clean = function() {
        wipe_12.wipe(this._key);
        return this;
      };
      ChaCha20Poly13052.prototype._authenticate = function(tagOut, authKey, ciphertext, associatedData) {
        var h4 = new poly1305_1.Poly1305(authKey);
        if (associatedData) {
          h4.update(associatedData);
          if (associatedData.length % 16 > 0) {
            h4.update(ZEROS.subarray(associatedData.length % 16));
          }
        }
        h4.update(ciphertext);
        if (ciphertext.length % 16 > 0) {
          h4.update(ZEROS.subarray(ciphertext.length % 16));
        }
        var length = new Uint8Array(8);
        if (associatedData) {
          binary_12.writeUint64LE(associatedData.length, length);
        }
        h4.update(length);
        binary_12.writeUint64LE(ciphertext.length, length);
        h4.update(length);
        var tag = h4.digest();
        for (var i3 = 0; i3 < tag.length; i3++) {
          tagOut[i3] = tag[i3];
        }
        h4.clean();
        wipe_12.wipe(tag);
        wipe_12.wipe(length);
      };
      return ChaCha20Poly13052;
    }()
  );
  exports.ChaCha20Poly1305 = ChaCha20Poly1305;
})(chacha20poly1305);
var hkdf = {};
var hmac$1 = {};
var hash$1 = {};
Object.defineProperty(hash$1, "__esModule", { value: true });
function isSerializableHash(h4) {
  return typeof h4.saveState !== "undefined" && typeof h4.restoreState !== "undefined" && typeof h4.cleanSavedState !== "undefined";
}
hash$1.isSerializableHash = isSerializableHash;
var constantTime = {};
Object.defineProperty(constantTime, "__esModule", { value: true });
function select(subject, resultIfOne, resultIfZero) {
  return ~(subject - 1) & resultIfOne | subject - 1 & resultIfZero;
}
constantTime.select = select;
function lessOrEqual(a3, b2) {
  return (a3 | 0) - (b2 | 0) - 1 >>> 31 & 1;
}
constantTime.lessOrEqual = lessOrEqual;
function compare(a3, b2) {
  if (a3.length !== b2.length) {
    return 0;
  }
  var result = 0;
  for (var i3 = 0; i3 < a3.length; i3++) {
    result |= a3[i3] ^ b2[i3];
  }
  return 1 & result - 1 >>> 8;
}
constantTime.compare = compare;
function equal(a3, b2) {
  if (a3.length === 0 || b2.length === 0) {
    return false;
  }
  return compare(a3, b2) !== 0;
}
constantTime.equal = equal;
var wipe$5 = {};
Object.defineProperty(wipe$5, "__esModule", { value: true });
function wipe$4(array) {
  for (var i3 = 0; i3 < array.length; i3++) {
    array[i3] = 0;
  }
  return array;
}
wipe$5.wipe = wipe$4;
Object.defineProperty(hmac$1, "__esModule", { value: true });
var hash_1 = hash$1;
var constant_time_1 = constantTime;
var wipe_1$1 = wipe$5;
var HMAC = (
  /** @class */
  function() {
    function HMAC2(hash3, key2) {
      this._finished = false;
      this._inner = new hash3();
      this._outer = new hash3();
      this.blockSize = this._outer.blockSize;
      this.digestLength = this._outer.digestLength;
      var pad = new Uint8Array(this.blockSize);
      if (key2.length > this.blockSize) {
        this._inner.update(key2).finish(pad).clean();
      } else {
        pad.set(key2);
      }
      for (var i3 = 0; i3 < pad.length; i3++) {
        pad[i3] ^= 54;
      }
      this._inner.update(pad);
      for (var i3 = 0; i3 < pad.length; i3++) {
        pad[i3] ^= 54 ^ 92;
      }
      this._outer.update(pad);
      if (hash_1.isSerializableHash(this._inner) && hash_1.isSerializableHash(this._outer)) {
        this._innerKeyedState = this._inner.saveState();
        this._outerKeyedState = this._outer.saveState();
      }
      wipe_1$1.wipe(pad);
    }
    HMAC2.prototype.reset = function() {
      if (!hash_1.isSerializableHash(this._inner) || !hash_1.isSerializableHash(this._outer)) {
        throw new Error("hmac: can't reset() because hash doesn't implement restoreState()");
      }
      this._inner.restoreState(this._innerKeyedState);
      this._outer.restoreState(this._outerKeyedState);
      this._finished = false;
      return this;
    };
    HMAC2.prototype.clean = function() {
      if (hash_1.isSerializableHash(this._inner)) {
        this._inner.cleanSavedState(this._innerKeyedState);
      }
      if (hash_1.isSerializableHash(this._outer)) {
        this._outer.cleanSavedState(this._outerKeyedState);
      }
      this._inner.clean();
      this._outer.clean();
    };
    HMAC2.prototype.update = function(data) {
      this._inner.update(data);
      return this;
    };
    HMAC2.prototype.finish = function(out) {
      if (this._finished) {
        this._outer.finish(out);
        return this;
      }
      this._inner.finish(out);
      this._outer.update(out.subarray(0, this.digestLength)).finish(out);
      this._finished = true;
      return this;
    };
    HMAC2.prototype.digest = function() {
      var out = new Uint8Array(this.digestLength);
      this.finish(out);
      return out;
    };
    HMAC2.prototype.saveState = function() {
      if (!hash_1.isSerializableHash(this._inner)) {
        throw new Error("hmac: can't saveState() because hash doesn't implement it");
      }
      return this._inner.saveState();
    };
    HMAC2.prototype.restoreState = function(savedState) {
      if (!hash_1.isSerializableHash(this._inner) || !hash_1.isSerializableHash(this._outer)) {
        throw new Error("hmac: can't restoreState() because hash doesn't implement it");
      }
      this._inner.restoreState(savedState);
      this._outer.restoreState(this._outerKeyedState);
      this._finished = false;
      return this;
    };
    HMAC2.prototype.cleanSavedState = function(savedState) {
      if (!hash_1.isSerializableHash(this._inner)) {
        throw new Error("hmac: can't cleanSavedState() because hash doesn't implement it");
      }
      this._inner.cleanSavedState(savedState);
    };
    return HMAC2;
  }()
);
hmac$1.HMAC = HMAC;
function hmac2(hash3, key2, data) {
  var h4 = new HMAC(hash3, key2);
  h4.update(data);
  var digest = h4.digest();
  h4.clean();
  return digest;
}
hmac$1.hmac = hmac2;
hmac$1.equal = constant_time_1.equal;
Object.defineProperty(hkdf, "__esModule", { value: true });
var hmac_1 = hmac$1;
var wipe_1 = wipe$5;
var HKDF = (
  /** @class */
  function() {
    function HKDF2(hash3, key2, salt, info) {
      if (salt === void 0) {
        salt = new Uint8Array(0);
      }
      this._counter = new Uint8Array(1);
      this._hash = hash3;
      this._info = info;
      var okm = hmac_1.hmac(this._hash, salt, key2);
      this._hmac = new hmac_1.HMAC(hash3, okm);
      this._buffer = new Uint8Array(this._hmac.digestLength);
      this._bufpos = this._buffer.length;
    }
    HKDF2.prototype._fillBuffer = function() {
      this._counter[0]++;
      var ctr = this._counter[0];
      if (ctr === 0) {
        throw new Error("hkdf: cannot expand more");
      }
      this._hmac.reset();
      if (ctr > 1) {
        this._hmac.update(this._buffer);
      }
      if (this._info) {
        this._hmac.update(this._info);
      }
      this._hmac.update(this._counter);
      this._hmac.finish(this._buffer);
      this._bufpos = 0;
    };
    HKDF2.prototype.expand = function(length) {
      var out = new Uint8Array(length);
      for (var i3 = 0; i3 < out.length; i3++) {
        if (this._bufpos === this._buffer.length) {
          this._fillBuffer();
        }
        out[i3] = this._buffer[this._bufpos++];
      }
      return out;
    };
    HKDF2.prototype.clean = function() {
      this._hmac.clean();
      wipe_1.wipe(this._buffer);
      wipe_1.wipe(this._counter);
      this._bufpos = 0;
    };
    return HKDF2;
  }()
);
var HKDF_1 = hkdf.HKDF = HKDF;
var sha256 = {};
var binary = {};
var int = {};
(function(exports) {
  Object.defineProperty(exports, "__esModule", { value: true });
  function imulShim(a3, b2) {
    var ah = a3 >>> 16 & 65535, al = a3 & 65535;
    var bh = b2 >>> 16 & 65535, bl = b2 & 65535;
    return al * bl + (ah * bl + al * bh << 16 >>> 0) | 0;
  }
  exports.mul = Math.imul || imulShim;
  function add7(a3, b2) {
    return a3 + b2 | 0;
  }
  exports.add = add7;
  function sub(a3, b2) {
    return a3 - b2 | 0;
  }
  exports.sub = sub;
  function rotl(x3, n4) {
    return x3 << n4 | x3 >>> 32 - n4;
  }
  exports.rotl = rotl;
  function rotr(x3, n4) {
    return x3 << 32 - n4 | x3 >>> n4;
  }
  exports.rotr = rotr;
  function isIntegerShim(n4) {
    return typeof n4 === "number" && isFinite(n4) && Math.floor(n4) === n4;
  }
  exports.isInteger = Number.isInteger || isIntegerShim;
  exports.MAX_SAFE_INTEGER = 9007199254740991;
  exports.isSafeInteger = function(n4) {
    return exports.isInteger(n4) && (n4 >= -exports.MAX_SAFE_INTEGER && n4 <= exports.MAX_SAFE_INTEGER);
  };
})(int);
Object.defineProperty(binary, "__esModule", { value: true });
var int_1 = int;
function readInt16BE(array, offset) {
  if (offset === void 0) {
    offset = 0;
  }
  return (array[offset + 0] << 8 | array[offset + 1]) << 16 >> 16;
}
binary.readInt16BE = readInt16BE;
function readUint16BE(array, offset) {
  if (offset === void 0) {
    offset = 0;
  }
  return (array[offset + 0] << 8 | array[offset + 1]) >>> 0;
}
binary.readUint16BE = readUint16BE;
function readInt16LE(array, offset) {
  if (offset === void 0) {
    offset = 0;
  }
  return (array[offset + 1] << 8 | array[offset]) << 16 >> 16;
}
binary.readInt16LE = readInt16LE;
function readUint16LE(array, offset) {
  if (offset === void 0) {
    offset = 0;
  }
  return (array[offset + 1] << 8 | array[offset]) >>> 0;
}
binary.readUint16LE = readUint16LE;
function writeUint16BE(value, out, offset) {
  if (out === void 0) {
    out = new Uint8Array(2);
  }
  if (offset === void 0) {
    offset = 0;
  }
  out[offset + 0] = value >>> 8;
  out[offset + 1] = value >>> 0;
  return out;
}
binary.writeUint16BE = writeUint16BE;
binary.writeInt16BE = writeUint16BE;
function writeUint16LE(value, out, offset) {
  if (out === void 0) {
    out = new Uint8Array(2);
  }
  if (offset === void 0) {
    offset = 0;
  }
  out[offset + 0] = value >>> 0;
  out[offset + 1] = value >>> 8;
  return out;
}
binary.writeUint16LE = writeUint16LE;
binary.writeInt16LE = writeUint16LE;
function readInt32BE(array, offset) {
  if (offset === void 0) {
    offset = 0;
  }
  return array[offset] << 24 | array[offset + 1] << 16 | array[offset + 2] << 8 | array[offset + 3];
}
binary.readInt32BE = readInt32BE;
function readUint32BE(array, offset) {
  if (offset === void 0) {
    offset = 0;
  }
  return (array[offset] << 24 | array[offset + 1] << 16 | array[offset + 2] << 8 | array[offset + 3]) >>> 0;
}
binary.readUint32BE = readUint32BE;
function readInt32LE(array, offset) {
  if (offset === void 0) {
    offset = 0;
  }
  return array[offset + 3] << 24 | array[offset + 2] << 16 | array[offset + 1] << 8 | array[offset];
}
binary.readInt32LE = readInt32LE;
function readUint32LE(array, offset) {
  if (offset === void 0) {
    offset = 0;
  }
  return (array[offset + 3] << 24 | array[offset + 2] << 16 | array[offset + 1] << 8 | array[offset]) >>> 0;
}
binary.readUint32LE = readUint32LE;
function writeUint32BE(value, out, offset) {
  if (out === void 0) {
    out = new Uint8Array(4);
  }
  if (offset === void 0) {
    offset = 0;
  }
  out[offset + 0] = value >>> 24;
  out[offset + 1] = value >>> 16;
  out[offset + 2] = value >>> 8;
  out[offset + 3] = value >>> 0;
  return out;
}
binary.writeUint32BE = writeUint32BE;
binary.writeInt32BE = writeUint32BE;
function writeUint32LE(value, out, offset) {
  if (out === void 0) {
    out = new Uint8Array(4);
  }
  if (offset === void 0) {
    offset = 0;
  }
  out[offset + 0] = value >>> 0;
  out[offset + 1] = value >>> 8;
  out[offset + 2] = value >>> 16;
  out[offset + 3] = value >>> 24;
  return out;
}
binary.writeUint32LE = writeUint32LE;
binary.writeInt32LE = writeUint32LE;
function readInt64BE(array, offset) {
  if (offset === void 0) {
    offset = 0;
  }
  var hi2 = readInt32BE(array, offset);
  var lo2 = readInt32BE(array, offset + 4);
  return hi2 * 4294967296 + lo2 - (lo2 >> 31) * 4294967296;
}
binary.readInt64BE = readInt64BE;
function readUint64BE(array, offset) {
  if (offset === void 0) {
    offset = 0;
  }
  var hi2 = readUint32BE(array, offset);
  var lo2 = readUint32BE(array, offset + 4);
  return hi2 * 4294967296 + lo2;
}
binary.readUint64BE = readUint64BE;
function readInt64LE(array, offset) {
  if (offset === void 0) {
    offset = 0;
  }
  var lo2 = readInt32LE(array, offset);
  var hi2 = readInt32LE(array, offset + 4);
  return hi2 * 4294967296 + lo2 - (lo2 >> 31) * 4294967296;
}
binary.readInt64LE = readInt64LE;
function readUint64LE(array, offset) {
  if (offset === void 0) {
    offset = 0;
  }
  var lo2 = readUint32LE(array, offset);
  var hi2 = readUint32LE(array, offset + 4);
  return hi2 * 4294967296 + lo2;
}
binary.readUint64LE = readUint64LE;
function writeUint64BE(value, out, offset) {
  if (out === void 0) {
    out = new Uint8Array(8);
  }
  if (offset === void 0) {
    offset = 0;
  }
  writeUint32BE(value / 4294967296 >>> 0, out, offset);
  writeUint32BE(value >>> 0, out, offset + 4);
  return out;
}
binary.writeUint64BE = writeUint64BE;
binary.writeInt64BE = writeUint64BE;
function writeUint64LE(value, out, offset) {
  if (out === void 0) {
    out = new Uint8Array(8);
  }
  if (offset === void 0) {
    offset = 0;
  }
  writeUint32LE(value >>> 0, out, offset);
  writeUint32LE(value / 4294967296 >>> 0, out, offset + 4);
  return out;
}
binary.writeUint64LE = writeUint64LE;
binary.writeInt64LE = writeUint64LE;
function readUintBE(bitLength, array, offset) {
  if (offset === void 0) {
    offset = 0;
  }
  if (bitLength % 8 !== 0) {
    throw new Error("readUintBE supports only bitLengths divisible by 8");
  }
  if (bitLength / 8 > array.length - offset) {
    throw new Error("readUintBE: array is too short for the given bitLength");
  }
  var result = 0;
  var mul7 = 1;
  for (var i3 = bitLength / 8 + offset - 1; i3 >= offset; i3--) {
    result += array[i3] * mul7;
    mul7 *= 256;
  }
  return result;
}
binary.readUintBE = readUintBE;
function readUintLE(bitLength, array, offset) {
  if (offset === void 0) {
    offset = 0;
  }
  if (bitLength % 8 !== 0) {
    throw new Error("readUintLE supports only bitLengths divisible by 8");
  }
  if (bitLength / 8 > array.length - offset) {
    throw new Error("readUintLE: array is too short for the given bitLength");
  }
  var result = 0;
  var mul7 = 1;
  for (var i3 = offset; i3 < offset + bitLength / 8; i3++) {
    result += array[i3] * mul7;
    mul7 *= 256;
  }
  return result;
}
binary.readUintLE = readUintLE;
function writeUintBE(bitLength, value, out, offset) {
  if (out === void 0) {
    out = new Uint8Array(bitLength / 8);
  }
  if (offset === void 0) {
    offset = 0;
  }
  if (bitLength % 8 !== 0) {
    throw new Error("writeUintBE supports only bitLengths divisible by 8");
  }
  if (!int_1.isSafeInteger(value)) {
    throw new Error("writeUintBE value must be an integer");
  }
  var div = 1;
  for (var i3 = bitLength / 8 + offset - 1; i3 >= offset; i3--) {
    out[i3] = value / div & 255;
    div *= 256;
  }
  return out;
}
binary.writeUintBE = writeUintBE;
function writeUintLE(bitLength, value, out, offset) {
  if (out === void 0) {
    out = new Uint8Array(bitLength / 8);
  }
  if (offset === void 0) {
    offset = 0;
  }
  if (bitLength % 8 !== 0) {
    throw new Error("writeUintLE supports only bitLengths divisible by 8");
  }
  if (!int_1.isSafeInteger(value)) {
    throw new Error("writeUintLE value must be an integer");
  }
  var div = 1;
  for (var i3 = offset; i3 < offset + bitLength / 8; i3++) {
    out[i3] = value / div & 255;
    div *= 256;
  }
  return out;
}
binary.writeUintLE = writeUintLE;
function readFloat32BE(array, offset) {
  if (offset === void 0) {
    offset = 0;
  }
  var view = new DataView(array.buffer, array.byteOffset, array.byteLength);
  return view.getFloat32(offset);
}
binary.readFloat32BE = readFloat32BE;
function readFloat32LE(array, offset) {
  if (offset === void 0) {
    offset = 0;
  }
  var view = new DataView(array.buffer, array.byteOffset, array.byteLength);
  return view.getFloat32(offset, true);
}
binary.readFloat32LE = readFloat32LE;
function readFloat64BE(array, offset) {
  if (offset === void 0) {
    offset = 0;
  }
  var view = new DataView(array.buffer, array.byteOffset, array.byteLength);
  return view.getFloat64(offset);
}
binary.readFloat64BE = readFloat64BE;
function readFloat64LE(array, offset) {
  if (offset === void 0) {
    offset = 0;
  }
  var view = new DataView(array.buffer, array.byteOffset, array.byteLength);
  return view.getFloat64(offset, true);
}
binary.readFloat64LE = readFloat64LE;
function writeFloat32BE(value, out, offset) {
  if (out === void 0) {
    out = new Uint8Array(4);
  }
  if (offset === void 0) {
    offset = 0;
  }
  var view = new DataView(out.buffer, out.byteOffset, out.byteLength);
  view.setFloat32(offset, value);
  return out;
}
binary.writeFloat32BE = writeFloat32BE;
function writeFloat32LE(value, out, offset) {
  if (out === void 0) {
    out = new Uint8Array(4);
  }
  if (offset === void 0) {
    offset = 0;
  }
  var view = new DataView(out.buffer, out.byteOffset, out.byteLength);
  view.setFloat32(offset, value, true);
  return out;
}
binary.writeFloat32LE = writeFloat32LE;
function writeFloat64BE(value, out, offset) {
  if (out === void 0) {
    out = new Uint8Array(8);
  }
  if (offset === void 0) {
    offset = 0;
  }
  var view = new DataView(out.buffer, out.byteOffset, out.byteLength);
  view.setFloat64(offset, value);
  return out;
}
binary.writeFloat64BE = writeFloat64BE;
function writeFloat64LE(value, out, offset) {
  if (out === void 0) {
    out = new Uint8Array(8);
  }
  if (offset === void 0) {
    offset = 0;
  }
  var view = new DataView(out.buffer, out.byteOffset, out.byteLength);
  view.setFloat64(offset, value, true);
  return out;
}
binary.writeFloat64LE = writeFloat64LE;
var wipe$3 = {};
Object.defineProperty(wipe$3, "__esModule", { value: true });
function wipe$2(array) {
  for (var i3 = 0; i3 < array.length; i3++) {
    array[i3] = 0;
  }
  return array;
}
wipe$3.wipe = wipe$2;
(function(exports) {
  Object.defineProperty(exports, "__esModule", { value: true });
  var binary_12 = binary;
  var wipe_12 = wipe$3;
  exports.DIGEST_LENGTH = 32;
  exports.BLOCK_SIZE = 64;
  var SHA256 = (
    /** @class */
    function() {
      function SHA2562() {
        this.digestLength = exports.DIGEST_LENGTH;
        this.blockSize = exports.BLOCK_SIZE;
        this._state = new Int32Array(8);
        this._temp = new Int32Array(64);
        this._buffer = new Uint8Array(128);
        this._bufferLength = 0;
        this._bytesHashed = 0;
        this._finished = false;
        this.reset();
      }
      SHA2562.prototype._initState = function() {
        this._state[0] = 1779033703;
        this._state[1] = 3144134277;
        this._state[2] = 1013904242;
        this._state[3] = 2773480762;
        this._state[4] = 1359893119;
        this._state[5] = 2600822924;
        this._state[6] = 528734635;
        this._state[7] = 1541459225;
      };
      SHA2562.prototype.reset = function() {
        this._initState();
        this._bufferLength = 0;
        this._bytesHashed = 0;
        this._finished = false;
        return this;
      };
      SHA2562.prototype.clean = function() {
        wipe_12.wipe(this._buffer);
        wipe_12.wipe(this._temp);
        this.reset();
      };
      SHA2562.prototype.update = function(data, dataLength) {
        if (dataLength === void 0) {
          dataLength = data.length;
        }
        if (this._finished) {
          throw new Error("SHA256: can't update because hash was finished.");
        }
        var dataPos = 0;
        this._bytesHashed += dataLength;
        if (this._bufferLength > 0) {
          while (this._bufferLength < this.blockSize && dataLength > 0) {
            this._buffer[this._bufferLength++] = data[dataPos++];
            dataLength--;
          }
          if (this._bufferLength === this.blockSize) {
            hashBlocks(this._temp, this._state, this._buffer, 0, this.blockSize);
            this._bufferLength = 0;
          }
        }
        if (dataLength >= this.blockSize) {
          dataPos = hashBlocks(this._temp, this._state, data, dataPos, dataLength);
          dataLength %= this.blockSize;
        }
        while (dataLength > 0) {
          this._buffer[this._bufferLength++] = data[dataPos++];
          dataLength--;
        }
        return this;
      };
      SHA2562.prototype.finish = function(out) {
        if (!this._finished) {
          var bytesHashed = this._bytesHashed;
          var left = this._bufferLength;
          var bitLenHi = bytesHashed / 536870912 | 0;
          var bitLenLo = bytesHashed << 3;
          var padLength = bytesHashed % 64 < 56 ? 64 : 128;
          this._buffer[left] = 128;
          for (var i3 = left + 1; i3 < padLength - 8; i3++) {
            this._buffer[i3] = 0;
          }
          binary_12.writeUint32BE(bitLenHi, this._buffer, padLength - 8);
          binary_12.writeUint32BE(bitLenLo, this._buffer, padLength - 4);
          hashBlocks(this._temp, this._state, this._buffer, 0, padLength);
          this._finished = true;
        }
        for (var i3 = 0; i3 < this.digestLength / 4; i3++) {
          binary_12.writeUint32BE(this._state[i3], out, i3 * 4);
        }
        return this;
      };
      SHA2562.prototype.digest = function() {
        var out = new Uint8Array(this.digestLength);
        this.finish(out);
        return out;
      };
      SHA2562.prototype.saveState = function() {
        if (this._finished) {
          throw new Error("SHA256: cannot save finished state");
        }
        return {
          state: new Int32Array(this._state),
          buffer: this._bufferLength > 0 ? new Uint8Array(this._buffer) : void 0,
          bufferLength: this._bufferLength,
          bytesHashed: this._bytesHashed
        };
      };
      SHA2562.prototype.restoreState = function(savedState) {
        this._state.set(savedState.state);
        this._bufferLength = savedState.bufferLength;
        if (savedState.buffer) {
          this._buffer.set(savedState.buffer);
        }
        this._bytesHashed = savedState.bytesHashed;
        this._finished = false;
        return this;
      };
      SHA2562.prototype.cleanSavedState = function(savedState) {
        wipe_12.wipe(savedState.state);
        if (savedState.buffer) {
          wipe_12.wipe(savedState.buffer);
        }
        savedState.bufferLength = 0;
        savedState.bytesHashed = 0;
      };
      return SHA2562;
    }()
  );
  exports.SHA256 = SHA256;
  var K3 = new Int32Array([
    1116352408,
    1899447441,
    3049323471,
    3921009573,
    961987163,
    1508970993,
    2453635748,
    2870763221,
    3624381080,
    310598401,
    607225278,
    1426881987,
    1925078388,
    2162078206,
    2614888103,
    3248222580,
    3835390401,
    4022224774,
    264347078,
    604807628,
    770255983,
    1249150122,
    1555081692,
    1996064986,
    2554220882,
    2821834349,
    2952996808,
    3210313671,
    3336571891,
    3584528711,
    113926993,
    338241895,
    666307205,
    773529912,
    1294757372,
    1396182291,
    1695183700,
    1986661051,
    2177026350,
    2456956037,
    2730485921,
    2820302411,
    3259730800,
    3345764771,
    3516065817,
    3600352804,
    4094571909,
    275423344,
    430227734,
    506948616,
    659060556,
    883997877,
    958139571,
    1322822218,
    1537002063,
    1747873779,
    1955562222,
    2024104815,
    2227730452,
    2361852424,
    2428436474,
    2756734187,
    3204031479,
    3329325298
  ]);
  function hashBlocks(w2, v3, p3, pos, len) {
    while (len >= 64) {
      var a3 = v3[0];
      var b2 = v3[1];
      var c2 = v3[2];
      var d4 = v3[3];
      var e2 = v3[4];
      var f3 = v3[5];
      var g3 = v3[6];
      var h4 = v3[7];
      for (var i3 = 0; i3 < 16; i3++) {
        var j2 = pos + i3 * 4;
        w2[i3] = binary_12.readUint32BE(p3, j2);
      }
      for (var i3 = 16; i3 < 64; i3++) {
        var u2 = w2[i3 - 2];
        var t1 = (u2 >>> 17 | u2 << 32 - 17) ^ (u2 >>> 19 | u2 << 32 - 19) ^ u2 >>> 10;
        u2 = w2[i3 - 15];
        var t2 = (u2 >>> 7 | u2 << 32 - 7) ^ (u2 >>> 18 | u2 << 32 - 18) ^ u2 >>> 3;
        w2[i3] = (t1 + w2[i3 - 7] | 0) + (t2 + w2[i3 - 16] | 0);
      }
      for (var i3 = 0; i3 < 64; i3++) {
        var t1 = (((e2 >>> 6 | e2 << 32 - 6) ^ (e2 >>> 11 | e2 << 32 - 11) ^ (e2 >>> 25 | e2 << 32 - 25)) + (e2 & f3 ^ ~e2 & g3) | 0) + (h4 + (K3[i3] + w2[i3] | 0) | 0) | 0;
        var t2 = ((a3 >>> 2 | a3 << 32 - 2) ^ (a3 >>> 13 | a3 << 32 - 13) ^ (a3 >>> 22 | a3 << 32 - 22)) + (a3 & b2 ^ a3 & c2 ^ b2 & c2) | 0;
        h4 = g3;
        g3 = f3;
        f3 = e2;
        e2 = d4 + t1 | 0;
        d4 = c2;
        c2 = b2;
        b2 = a3;
        a3 = t1 + t2 | 0;
      }
      v3[0] += a3;
      v3[1] += b2;
      v3[2] += c2;
      v3[3] += d4;
      v3[4] += e2;
      v3[5] += f3;
      v3[6] += g3;
      v3[7] += h4;
      pos += 64;
      len -= 64;
    }
    return pos;
  }
  function hash3(data) {
    var h4 = new SHA256();
    h4.update(data);
    var digest = h4.digest();
    h4.clean();
    return digest;
  }
  exports.hash = hash3;
})(sha256);
var x25519 = {};
var wipe$1 = {};
Object.defineProperty(wipe$1, "__esModule", { value: true });
function wipe(array) {
  for (var i3 = 0; i3 < array.length; i3++) {
    array[i3] = 0;
  }
  return array;
}
wipe$1.wipe = wipe;
(function(exports) {
  Object.defineProperty(exports, "__esModule", { value: true });
  exports.sharedKey = exports.generateKeyPair = exports.generateKeyPairFromSeed = exports.scalarMultBase = exports.scalarMult = exports.SHARED_KEY_LENGTH = exports.SECRET_KEY_LENGTH = exports.PUBLIC_KEY_LENGTH = void 0;
  const random_1 = random;
  const wipe_12 = wipe$1;
  exports.PUBLIC_KEY_LENGTH = 32;
  exports.SECRET_KEY_LENGTH = 32;
  exports.SHARED_KEY_LENGTH = 32;
  function gf(init2) {
    const r2 = new Float64Array(16);
    if (init2) {
      for (let i3 = 0; i3 < init2.length; i3++) {
        r2[i3] = init2[i3];
      }
    }
    return r2;
  }
  const _9 = new Uint8Array(32);
  _9[0] = 9;
  const _121665 = gf([56129, 1]);
  function car25519(o3) {
    let c2 = 1;
    for (let i3 = 0; i3 < 16; i3++) {
      let v3 = o3[i3] + c2 + 65535;
      c2 = Math.floor(v3 / 65536);
      o3[i3] = v3 - c2 * 65536;
    }
    o3[0] += c2 - 1 + 37 * (c2 - 1);
  }
  function sel25519(p3, q2, b2) {
    const c2 = ~(b2 - 1);
    for (let i3 = 0; i3 < 16; i3++) {
      const t = c2 & (p3[i3] ^ q2[i3]);
      p3[i3] ^= t;
      q2[i3] ^= t;
    }
  }
  function pack25519(o3, n4) {
    const m2 = gf();
    const t = gf();
    for (let i3 = 0; i3 < 16; i3++) {
      t[i3] = n4[i3];
    }
    car25519(t);
    car25519(t);
    car25519(t);
    for (let j2 = 0; j2 < 2; j2++) {
      m2[0] = t[0] - 65517;
      for (let i3 = 1; i3 < 15; i3++) {
        m2[i3] = t[i3] - 65535 - (m2[i3 - 1] >> 16 & 1);
        m2[i3 - 1] &= 65535;
      }
      m2[15] = t[15] - 32767 - (m2[14] >> 16 & 1);
      const b2 = m2[15] >> 16 & 1;
      m2[14] &= 65535;
      sel25519(t, m2, 1 - b2);
    }
    for (let i3 = 0; i3 < 16; i3++) {
      o3[2 * i3] = t[i3] & 255;
      o3[2 * i3 + 1] = t[i3] >> 8;
    }
  }
  function unpack25519(o3, n4) {
    for (let i3 = 0; i3 < 16; i3++) {
      o3[i3] = n4[2 * i3] + (n4[2 * i3 + 1] << 8);
    }
    o3[15] &= 32767;
  }
  function add7(o3, a3, b2) {
    for (let i3 = 0; i3 < 16; i3++) {
      o3[i3] = a3[i3] + b2[i3];
    }
  }
  function sub(o3, a3, b2) {
    for (let i3 = 0; i3 < 16; i3++) {
      o3[i3] = a3[i3] - b2[i3];
    }
  }
  function mul7(o3, a3, b2) {
    let v3, c2, t0 = 0, t1 = 0, t2 = 0, t3 = 0, t4 = 0, t5 = 0, t6 = 0, t7 = 0, t8 = 0, t9 = 0, t10 = 0, t11 = 0, t12 = 0, t13 = 0, t14 = 0, t15 = 0, t16 = 0, t17 = 0, t18 = 0, t19 = 0, t20 = 0, t21 = 0, t22 = 0, t23 = 0, t24 = 0, t25 = 0, t26 = 0, t27 = 0, t28 = 0, t29 = 0, t30 = 0, b0 = b2[0], b1 = b2[1], b22 = b2[2], b3 = b2[3], b4 = b2[4], b5 = b2[5], b6 = b2[6], b7 = b2[7], b8 = b2[8], b9 = b2[9], b10 = b2[10], b11 = b2[11], b12 = b2[12], b13 = b2[13], b14 = b2[14], b15 = b2[15];
    v3 = a3[0];
    t0 += v3 * b0;
    t1 += v3 * b1;
    t2 += v3 * b22;
    t3 += v3 * b3;
    t4 += v3 * b4;
    t5 += v3 * b5;
    t6 += v3 * b6;
    t7 += v3 * b7;
    t8 += v3 * b8;
    t9 += v3 * b9;
    t10 += v3 * b10;
    t11 += v3 * b11;
    t12 += v3 * b12;
    t13 += v3 * b13;
    t14 += v3 * b14;
    t15 += v3 * b15;
    v3 = a3[1];
    t1 += v3 * b0;
    t2 += v3 * b1;
    t3 += v3 * b22;
    t4 += v3 * b3;
    t5 += v3 * b4;
    t6 += v3 * b5;
    t7 += v3 * b6;
    t8 += v3 * b7;
    t9 += v3 * b8;
    t10 += v3 * b9;
    t11 += v3 * b10;
    t12 += v3 * b11;
    t13 += v3 * b12;
    t14 += v3 * b13;
    t15 += v3 * b14;
    t16 += v3 * b15;
    v3 = a3[2];
    t2 += v3 * b0;
    t3 += v3 * b1;
    t4 += v3 * b22;
    t5 += v3 * b3;
    t6 += v3 * b4;
    t7 += v3 * b5;
    t8 += v3 * b6;
    t9 += v3 * b7;
    t10 += v3 * b8;
    t11 += v3 * b9;
    t12 += v3 * b10;
    t13 += v3 * b11;
    t14 += v3 * b12;
    t15 += v3 * b13;
    t16 += v3 * b14;
    t17 += v3 * b15;
    v3 = a3[3];
    t3 += v3 * b0;
    t4 += v3 * b1;
    t5 += v3 * b22;
    t6 += v3 * b3;
    t7 += v3 * b4;
    t8 += v3 * b5;
    t9 += v3 * b6;
    t10 += v3 * b7;
    t11 += v3 * b8;
    t12 += v3 * b9;
    t13 += v3 * b10;
    t14 += v3 * b11;
    t15 += v3 * b12;
    t16 += v3 * b13;
    t17 += v3 * b14;
    t18 += v3 * b15;
    v3 = a3[4];
    t4 += v3 * b0;
    t5 += v3 * b1;
    t6 += v3 * b22;
    t7 += v3 * b3;
    t8 += v3 * b4;
    t9 += v3 * b5;
    t10 += v3 * b6;
    t11 += v3 * b7;
    t12 += v3 * b8;
    t13 += v3 * b9;
    t14 += v3 * b10;
    t15 += v3 * b11;
    t16 += v3 * b12;
    t17 += v3 * b13;
    t18 += v3 * b14;
    t19 += v3 * b15;
    v3 = a3[5];
    t5 += v3 * b0;
    t6 += v3 * b1;
    t7 += v3 * b22;
    t8 += v3 * b3;
    t9 += v3 * b4;
    t10 += v3 * b5;
    t11 += v3 * b6;
    t12 += v3 * b7;
    t13 += v3 * b8;
    t14 += v3 * b9;
    t15 += v3 * b10;
    t16 += v3 * b11;
    t17 += v3 * b12;
    t18 += v3 * b13;
    t19 += v3 * b14;
    t20 += v3 * b15;
    v3 = a3[6];
    t6 += v3 * b0;
    t7 += v3 * b1;
    t8 += v3 * b22;
    t9 += v3 * b3;
    t10 += v3 * b4;
    t11 += v3 * b5;
    t12 += v3 * b6;
    t13 += v3 * b7;
    t14 += v3 * b8;
    t15 += v3 * b9;
    t16 += v3 * b10;
    t17 += v3 * b11;
    t18 += v3 * b12;
    t19 += v3 * b13;
    t20 += v3 * b14;
    t21 += v3 * b15;
    v3 = a3[7];
    t7 += v3 * b0;
    t8 += v3 * b1;
    t9 += v3 * b22;
    t10 += v3 * b3;
    t11 += v3 * b4;
    t12 += v3 * b5;
    t13 += v3 * b6;
    t14 += v3 * b7;
    t15 += v3 * b8;
    t16 += v3 * b9;
    t17 += v3 * b10;
    t18 += v3 * b11;
    t19 += v3 * b12;
    t20 += v3 * b13;
    t21 += v3 * b14;
    t22 += v3 * b15;
    v3 = a3[8];
    t8 += v3 * b0;
    t9 += v3 * b1;
    t10 += v3 * b22;
    t11 += v3 * b3;
    t12 += v3 * b4;
    t13 += v3 * b5;
    t14 += v3 * b6;
    t15 += v3 * b7;
    t16 += v3 * b8;
    t17 += v3 * b9;
    t18 += v3 * b10;
    t19 += v3 * b11;
    t20 += v3 * b12;
    t21 += v3 * b13;
    t22 += v3 * b14;
    t23 += v3 * b15;
    v3 = a3[9];
    t9 += v3 * b0;
    t10 += v3 * b1;
    t11 += v3 * b22;
    t12 += v3 * b3;
    t13 += v3 * b4;
    t14 += v3 * b5;
    t15 += v3 * b6;
    t16 += v3 * b7;
    t17 += v3 * b8;
    t18 += v3 * b9;
    t19 += v3 * b10;
    t20 += v3 * b11;
    t21 += v3 * b12;
    t22 += v3 * b13;
    t23 += v3 * b14;
    t24 += v3 * b15;
    v3 = a3[10];
    t10 += v3 * b0;
    t11 += v3 * b1;
    t12 += v3 * b22;
    t13 += v3 * b3;
    t14 += v3 * b4;
    t15 += v3 * b5;
    t16 += v3 * b6;
    t17 += v3 * b7;
    t18 += v3 * b8;
    t19 += v3 * b9;
    t20 += v3 * b10;
    t21 += v3 * b11;
    t22 += v3 * b12;
    t23 += v3 * b13;
    t24 += v3 * b14;
    t25 += v3 * b15;
    v3 = a3[11];
    t11 += v3 * b0;
    t12 += v3 * b1;
    t13 += v3 * b22;
    t14 += v3 * b3;
    t15 += v3 * b4;
    t16 += v3 * b5;
    t17 += v3 * b6;
    t18 += v3 * b7;
    t19 += v3 * b8;
    t20 += v3 * b9;
    t21 += v3 * b10;
    t22 += v3 * b11;
    t23 += v3 * b12;
    t24 += v3 * b13;
    t25 += v3 * b14;
    t26 += v3 * b15;
    v3 = a3[12];
    t12 += v3 * b0;
    t13 += v3 * b1;
    t14 += v3 * b22;
    t15 += v3 * b3;
    t16 += v3 * b4;
    t17 += v3 * b5;
    t18 += v3 * b6;
    t19 += v3 * b7;
    t20 += v3 * b8;
    t21 += v3 * b9;
    t22 += v3 * b10;
    t23 += v3 * b11;
    t24 += v3 * b12;
    t25 += v3 * b13;
    t26 += v3 * b14;
    t27 += v3 * b15;
    v3 = a3[13];
    t13 += v3 * b0;
    t14 += v3 * b1;
    t15 += v3 * b22;
    t16 += v3 * b3;
    t17 += v3 * b4;
    t18 += v3 * b5;
    t19 += v3 * b6;
    t20 += v3 * b7;
    t21 += v3 * b8;
    t22 += v3 * b9;
    t23 += v3 * b10;
    t24 += v3 * b11;
    t25 += v3 * b12;
    t26 += v3 * b13;
    t27 += v3 * b14;
    t28 += v3 * b15;
    v3 = a3[14];
    t14 += v3 * b0;
    t15 += v3 * b1;
    t16 += v3 * b22;
    t17 += v3 * b3;
    t18 += v3 * b4;
    t19 += v3 * b5;
    t20 += v3 * b6;
    t21 += v3 * b7;
    t22 += v3 * b8;
    t23 += v3 * b9;
    t24 += v3 * b10;
    t25 += v3 * b11;
    t26 += v3 * b12;
    t27 += v3 * b13;
    t28 += v3 * b14;
    t29 += v3 * b15;
    v3 = a3[15];
    t15 += v3 * b0;
    t16 += v3 * b1;
    t17 += v3 * b22;
    t18 += v3 * b3;
    t19 += v3 * b4;
    t20 += v3 * b5;
    t21 += v3 * b6;
    t22 += v3 * b7;
    t23 += v3 * b8;
    t24 += v3 * b9;
    t25 += v3 * b10;
    t26 += v3 * b11;
    t27 += v3 * b12;
    t28 += v3 * b13;
    t29 += v3 * b14;
    t30 += v3 * b15;
    t0 += 38 * t16;
    t1 += 38 * t17;
    t2 += 38 * t18;
    t3 += 38 * t19;
    t4 += 38 * t20;
    t5 += 38 * t21;
    t6 += 38 * t22;
    t7 += 38 * t23;
    t8 += 38 * t24;
    t9 += 38 * t25;
    t10 += 38 * t26;
    t11 += 38 * t27;
    t12 += 38 * t28;
    t13 += 38 * t29;
    t14 += 38 * t30;
    c2 = 1;
    v3 = t0 + c2 + 65535;
    c2 = Math.floor(v3 / 65536);
    t0 = v3 - c2 * 65536;
    v3 = t1 + c2 + 65535;
    c2 = Math.floor(v3 / 65536);
    t1 = v3 - c2 * 65536;
    v3 = t2 + c2 + 65535;
    c2 = Math.floor(v3 / 65536);
    t2 = v3 - c2 * 65536;
    v3 = t3 + c2 + 65535;
    c2 = Math.floor(v3 / 65536);
    t3 = v3 - c2 * 65536;
    v3 = t4 + c2 + 65535;
    c2 = Math.floor(v3 / 65536);
    t4 = v3 - c2 * 65536;
    v3 = t5 + c2 + 65535;
    c2 = Math.floor(v3 / 65536);
    t5 = v3 - c2 * 65536;
    v3 = t6 + c2 + 65535;
    c2 = Math.floor(v3 / 65536);
    t6 = v3 - c2 * 65536;
    v3 = t7 + c2 + 65535;
    c2 = Math.floor(v3 / 65536);
    t7 = v3 - c2 * 65536;
    v3 = t8 + c2 + 65535;
    c2 = Math.floor(v3 / 65536);
    t8 = v3 - c2 * 65536;
    v3 = t9 + c2 + 65535;
    c2 = Math.floor(v3 / 65536);
    t9 = v3 - c2 * 65536;
    v3 = t10 + c2 + 65535;
    c2 = Math.floor(v3 / 65536);
    t10 = v3 - c2 * 65536;
    v3 = t11 + c2 + 65535;
    c2 = Math.floor(v3 / 65536);
    t11 = v3 - c2 * 65536;
    v3 = t12 + c2 + 65535;
    c2 = Math.floor(v3 / 65536);
    t12 = v3 - c2 * 65536;
    v3 = t13 + c2 + 65535;
    c2 = Math.floor(v3 / 65536);
    t13 = v3 - c2 * 65536;
    v3 = t14 + c2 + 65535;
    c2 = Math.floor(v3 / 65536);
    t14 = v3 - c2 * 65536;
    v3 = t15 + c2 + 65535;
    c2 = Math.floor(v3 / 65536);
    t15 = v3 - c2 * 65536;
    t0 += c2 - 1 + 37 * (c2 - 1);
    c2 = 1;
    v3 = t0 + c2 + 65535;
    c2 = Math.floor(v3 / 65536);
    t0 = v3 - c2 * 65536;
    v3 = t1 + c2 + 65535;
    c2 = Math.floor(v3 / 65536);
    t1 = v3 - c2 * 65536;
    v3 = t2 + c2 + 65535;
    c2 = Math.floor(v3 / 65536);
    t2 = v3 - c2 * 65536;
    v3 = t3 + c2 + 65535;
    c2 = Math.floor(v3 / 65536);
    t3 = v3 - c2 * 65536;
    v3 = t4 + c2 + 65535;
    c2 = Math.floor(v3 / 65536);
    t4 = v3 - c2 * 65536;
    v3 = t5 + c2 + 65535;
    c2 = Math.floor(v3 / 65536);
    t5 = v3 - c2 * 65536;
    v3 = t6 + c2 + 65535;
    c2 = Math.floor(v3 / 65536);
    t6 = v3 - c2 * 65536;
    v3 = t7 + c2 + 65535;
    c2 = Math.floor(v3 / 65536);
    t7 = v3 - c2 * 65536;
    v3 = t8 + c2 + 65535;
    c2 = Math.floor(v3 / 65536);
    t8 = v3 - c2 * 65536;
    v3 = t9 + c2 + 65535;
    c2 = Math.floor(v3 / 65536);
    t9 = v3 - c2 * 65536;
    v3 = t10 + c2 + 65535;
    c2 = Math.floor(v3 / 65536);
    t10 = v3 - c2 * 65536;
    v3 = t11 + c2 + 65535;
    c2 = Math.floor(v3 / 65536);
    t11 = v3 - c2 * 65536;
    v3 = t12 + c2 + 65535;
    c2 = Math.floor(v3 / 65536);
    t12 = v3 - c2 * 65536;
    v3 = t13 + c2 + 65535;
    c2 = Math.floor(v3 / 65536);
    t13 = v3 - c2 * 65536;
    v3 = t14 + c2 + 65535;
    c2 = Math.floor(v3 / 65536);
    t14 = v3 - c2 * 65536;
    v3 = t15 + c2 + 65535;
    c2 = Math.floor(v3 / 65536);
    t15 = v3 - c2 * 65536;
    t0 += c2 - 1 + 37 * (c2 - 1);
    o3[0] = t0;
    o3[1] = t1;
    o3[2] = t2;
    o3[3] = t3;
    o3[4] = t4;
    o3[5] = t5;
    o3[6] = t6;
    o3[7] = t7;
    o3[8] = t8;
    o3[9] = t9;
    o3[10] = t10;
    o3[11] = t11;
    o3[12] = t12;
    o3[13] = t13;
    o3[14] = t14;
    o3[15] = t15;
  }
  function square(o3, a3) {
    mul7(o3, a3, a3);
  }
  function inv25519(o3, inp) {
    const c2 = gf();
    for (let i3 = 0; i3 < 16; i3++) {
      c2[i3] = inp[i3];
    }
    for (let i3 = 253; i3 >= 0; i3--) {
      square(c2, c2);
      if (i3 !== 2 && i3 !== 4) {
        mul7(c2, c2, inp);
      }
    }
    for (let i3 = 0; i3 < 16; i3++) {
      o3[i3] = c2[i3];
    }
  }
  function scalarMult(n4, p3) {
    const z2 = new Uint8Array(32);
    const x3 = new Float64Array(80);
    const a3 = gf(), b2 = gf(), c2 = gf(), d4 = gf(), e2 = gf(), f3 = gf();
    for (let i3 = 0; i3 < 31; i3++) {
      z2[i3] = n4[i3];
    }
    z2[31] = n4[31] & 127 | 64;
    z2[0] &= 248;
    unpack25519(x3, p3);
    for (let i3 = 0; i3 < 16; i3++) {
      b2[i3] = x3[i3];
    }
    a3[0] = d4[0] = 1;
    for (let i3 = 254; i3 >= 0; --i3) {
      const r2 = z2[i3 >>> 3] >>> (i3 & 7) & 1;
      sel25519(a3, b2, r2);
      sel25519(c2, d4, r2);
      add7(e2, a3, c2);
      sub(a3, a3, c2);
      add7(c2, b2, d4);
      sub(b2, b2, d4);
      square(d4, e2);
      square(f3, a3);
      mul7(a3, c2, a3);
      mul7(c2, b2, e2);
      add7(e2, a3, c2);
      sub(a3, a3, c2);
      square(b2, a3);
      sub(c2, d4, f3);
      mul7(a3, c2, _121665);
      add7(a3, a3, d4);
      mul7(c2, c2, a3);
      mul7(a3, d4, f3);
      mul7(d4, b2, x3);
      square(b2, e2);
      sel25519(a3, b2, r2);
      sel25519(c2, d4, r2);
    }
    for (let i3 = 0; i3 < 16; i3++) {
      x3[i3 + 16] = a3[i3];
      x3[i3 + 32] = c2[i3];
      x3[i3 + 48] = b2[i3];
      x3[i3 + 64] = d4[i3];
    }
    const x32 = x3.subarray(32);
    const x16 = x3.subarray(16);
    inv25519(x32, x32);
    mul7(x16, x16, x32);
    const q2 = new Uint8Array(32);
    pack25519(q2, x16);
    return q2;
  }
  exports.scalarMult = scalarMult;
  function scalarMultBase(n4) {
    return scalarMult(n4, _9);
  }
  exports.scalarMultBase = scalarMultBase;
  function generateKeyPairFromSeed(seed) {
    if (seed.length !== exports.SECRET_KEY_LENGTH) {
      throw new Error(`x25519: seed must be ${exports.SECRET_KEY_LENGTH} bytes`);
    }
    const secretKey = new Uint8Array(seed);
    const publicKey = scalarMultBase(secretKey);
    return {
      publicKey,
      secretKey
    };
  }
  exports.generateKeyPairFromSeed = generateKeyPairFromSeed;
  function generateKeyPair2(prng) {
    const seed = (0, random_1.randomBytes)(32, prng);
    const result = generateKeyPairFromSeed(seed);
    (0, wipe_12.wipe)(seed);
    return result;
  }
  exports.generateKeyPair = generateKeyPair2;
  function sharedKey(mySecretKey, theirPublicKey, rejectZero = false) {
    if (mySecretKey.length !== exports.PUBLIC_KEY_LENGTH) {
      throw new Error("X25519: incorrect secret key length");
    }
    if (theirPublicKey.length !== exports.PUBLIC_KEY_LENGTH) {
      throw new Error("X25519: incorrect public key length");
    }
    const result = scalarMult(mySecretKey, theirPublicKey);
    if (rejectZero) {
      let zeros = 0;
      for (let i3 = 0; i3 < result.length; i3++) {
        zeros |= result[i3];
      }
      if (zeros === 0) {
        throw new Error("X25519: invalid shared key");
      }
    }
    return result;
  }
  exports.sharedKey = sharedKey;
})(x25519);
var elliptic = {};
const name = "elliptic";
const version = "6.5.7";
const description = "EC cryptography";
const main = "lib/elliptic.js";
const files = [
  "lib"
];
const scripts = {
  lint: "eslint lib test",
  "lint:fix": "npm run lint -- --fix",
  unit: "istanbul test _mocha --reporter=spec test/index.js",
  test: "npm run lint && npm run unit",
  version: "grunt dist && git add dist/"
};
const repository = {
  type: "git",
  url: "git@github.com:indutny/elliptic"
};
const keywords = [
  "EC",
  "Elliptic",
  "curve",
  "Cryptography"
];
const author = "Fedor Indutny <fedor@indutny.com>";
const license = "MIT";
const bugs = {
  url: "https://github.com/indutny/elliptic/issues"
};
const homepage = "https://github.com/indutny/elliptic";
const devDependencies = {
  brfs: "^2.0.2",
  coveralls: "^3.1.0",
  eslint: "^7.6.0",
  grunt: "^1.2.1",
  "grunt-browserify": "^5.3.0",
  "grunt-cli": "^1.3.2",
  "grunt-contrib-connect": "^3.0.0",
  "grunt-contrib-copy": "^1.0.0",
  "grunt-contrib-uglify": "^5.0.0",
  "grunt-mocha-istanbul": "^5.0.2",
  "grunt-saucelabs": "^9.0.1",
  istanbul: "^0.4.5",
  mocha: "^8.0.1"
};
const dependencies = {
  "bn.js": "^4.11.9",
  brorand: "^1.1.0",
  "hash.js": "^1.0.0",
  "hmac-drbg": "^1.0.1",
  inherits: "^2.0.4",
  "minimalistic-assert": "^1.0.1",
  "minimalistic-crypto-utils": "^1.0.1"
};
const require$$0$2 = {
  name,
  version,
  description,
  main,
  files,
  scripts,
  repository,
  keywords,
  author,
  license,
  bugs,
  homepage,
  devDependencies,
  dependencies
};
var utils$a = {};
var bn$2 = { exports: {} };
bn$2.exports;
(function(module) {
  (function(module2, exports) {
    function assert2(val, msg) {
      if (!val) throw new Error(msg || "Assertion failed");
    }
    function inherits2(ctor, superCtor) {
      ctor.super_ = superCtor;
      var TempCtor = function() {
      };
      TempCtor.prototype = superCtor.prototype;
      ctor.prototype = new TempCtor();
      ctor.prototype.constructor = ctor;
    }
    function BN2(number, base3, endian) {
      if (BN2.isBN(number)) {
        return number;
      }
      this.negative = 0;
      this.words = null;
      this.length = 0;
      this.red = null;
      if (number !== null) {
        if (base3 === "le" || base3 === "be") {
          endian = base3;
          base3 = 10;
        }
        this._init(number || 0, base3 || 10, endian || "be");
      }
    }
    if (typeof module2 === "object") {
      module2.exports = BN2;
    } else {
      exports.BN = BN2;
    }
    BN2.BN = BN2;
    BN2.wordSize = 26;
    var Buffer2;
    try {
      if (typeof window !== "undefined" && typeof window.Buffer !== "undefined") {
        Buffer2 = window.Buffer;
      } else {
        Buffer2 = require$$0$4.Buffer;
      }
    } catch (e2) {
    }
    BN2.isBN = function isBN(num) {
      if (num instanceof BN2) {
        return true;
      }
      return num !== null && typeof num === "object" && num.constructor.wordSize === BN2.wordSize && Array.isArray(num.words);
    };
    BN2.max = function max(left, right) {
      if (left.cmp(right) > 0) return left;
      return right;
    };
    BN2.min = function min(left, right) {
      if (left.cmp(right) < 0) return left;
      return right;
    };
    BN2.prototype._init = function init2(number, base3, endian) {
      if (typeof number === "number") {
        return this._initNumber(number, base3, endian);
      }
      if (typeof number === "object") {
        return this._initArray(number, base3, endian);
      }
      if (base3 === "hex") {
        base3 = 16;
      }
      assert2(base3 === (base3 | 0) && base3 >= 2 && base3 <= 36);
      number = number.toString().replace(/\s+/g, "");
      var start = 0;
      if (number[0] === "-") {
        start++;
        this.negative = 1;
      }
      if (start < number.length) {
        if (base3 === 16) {
          this._parseHex(number, start, endian);
        } else {
          this._parseBase(number, base3, start);
          if (endian === "le") {
            this._initArray(this.toArray(), base3, endian);
          }
        }
      }
    };
    BN2.prototype._initNumber = function _initNumber(number, base3, endian) {
      if (number < 0) {
        this.negative = 1;
        number = -number;
      }
      if (number < 67108864) {
        this.words = [number & 67108863];
        this.length = 1;
      } else if (number < 4503599627370496) {
        this.words = [
          number & 67108863,
          number / 67108864 & 67108863
        ];
        this.length = 2;
      } else {
        assert2(number < 9007199254740992);
        this.words = [
          number & 67108863,
          number / 67108864 & 67108863,
          1
        ];
        this.length = 3;
      }
      if (endian !== "le") return;
      this._initArray(this.toArray(), base3, endian);
    };
    BN2.prototype._initArray = function _initArray(number, base3, endian) {
      assert2(typeof number.length === "number");
      if (number.length <= 0) {
        this.words = [0];
        this.length = 1;
        return this;
      }
      this.length = Math.ceil(number.length / 3);
      this.words = new Array(this.length);
      for (var i3 = 0; i3 < this.length; i3++) {
        this.words[i3] = 0;
      }
      var j2, w2;
      var off = 0;
      if (endian === "be") {
        for (i3 = number.length - 1, j2 = 0; i3 >= 0; i3 -= 3) {
          w2 = number[i3] | number[i3 - 1] << 8 | number[i3 - 2] << 16;
          this.words[j2] |= w2 << off & 67108863;
          this.words[j2 + 1] = w2 >>> 26 - off & 67108863;
          off += 24;
          if (off >= 26) {
            off -= 26;
            j2++;
          }
        }
      } else if (endian === "le") {
        for (i3 = 0, j2 = 0; i3 < number.length; i3 += 3) {
          w2 = number[i3] | number[i3 + 1] << 8 | number[i3 + 2] << 16;
          this.words[j2] |= w2 << off & 67108863;
          this.words[j2 + 1] = w2 >>> 26 - off & 67108863;
          off += 24;
          if (off >= 26) {
            off -= 26;
            j2++;
          }
        }
      }
      return this.strip();
    };
    function parseHex4Bits(string2, index) {
      var c2 = string2.charCodeAt(index);
      if (c2 >= 65 && c2 <= 70) {
        return c2 - 55;
      } else if (c2 >= 97 && c2 <= 102) {
        return c2 - 87;
      } else {
        return c2 - 48 & 15;
      }
    }
    function parseHexByte(string2, lowerBound, index) {
      var r2 = parseHex4Bits(string2, index);
      if (index - 1 >= lowerBound) {
        r2 |= parseHex4Bits(string2, index - 1) << 4;
      }
      return r2;
    }
    BN2.prototype._parseHex = function _parseHex(number, start, endian) {
      this.length = Math.ceil((number.length - start) / 6);
      this.words = new Array(this.length);
      for (var i3 = 0; i3 < this.length; i3++) {
        this.words[i3] = 0;
      }
      var off = 0;
      var j2 = 0;
      var w2;
      if (endian === "be") {
        for (i3 = number.length - 1; i3 >= start; i3 -= 2) {
          w2 = parseHexByte(number, start, i3) << off;
          this.words[j2] |= w2 & 67108863;
          if (off >= 18) {
            off -= 18;
            j2 += 1;
            this.words[j2] |= w2 >>> 26;
          } else {
            off += 8;
          }
        }
      } else {
        var parseLength = number.length - start;
        for (i3 = parseLength % 2 === 0 ? start + 1 : start; i3 < number.length; i3 += 2) {
          w2 = parseHexByte(number, start, i3) << off;
          this.words[j2] |= w2 & 67108863;
          if (off >= 18) {
            off -= 18;
            j2 += 1;
            this.words[j2] |= w2 >>> 26;
          } else {
            off += 8;
          }
        }
      }
      this.strip();
    };
    function parseBase(str, start, end, mul7) {
      var r2 = 0;
      var len = Math.min(str.length, end);
      for (var i3 = start; i3 < len; i3++) {
        var c2 = str.charCodeAt(i3) - 48;
        r2 *= mul7;
        if (c2 >= 49) {
          r2 += c2 - 49 + 10;
        } else if (c2 >= 17) {
          r2 += c2 - 17 + 10;
        } else {
          r2 += c2;
        }
      }
      return r2;
    }
    BN2.prototype._parseBase = function _parseBase(number, base3, start) {
      this.words = [0];
      this.length = 1;
      for (var limbLen = 0, limbPow = 1; limbPow <= 67108863; limbPow *= base3) {
        limbLen++;
      }
      limbLen--;
      limbPow = limbPow / base3 | 0;
      var total = number.length - start;
      var mod = total % limbLen;
      var end = Math.min(total, total - mod) + start;
      var word = 0;
      for (var i3 = start; i3 < end; i3 += limbLen) {
        word = parseBase(number, i3, i3 + limbLen, base3);
        this.imuln(limbPow);
        if (this.words[0] + word < 67108864) {
          this.words[0] += word;
        } else {
          this._iaddn(word);
        }
      }
      if (mod !== 0) {
        var pow = 1;
        word = parseBase(number, i3, number.length, base3);
        for (i3 = 0; i3 < mod; i3++) {
          pow *= base3;
        }
        this.imuln(pow);
        if (this.words[0] + word < 67108864) {
          this.words[0] += word;
        } else {
          this._iaddn(word);
        }
      }
      this.strip();
    };
    BN2.prototype.copy = function copy(dest) {
      dest.words = new Array(this.length);
      for (var i3 = 0; i3 < this.length; i3++) {
        dest.words[i3] = this.words[i3];
      }
      dest.length = this.length;
      dest.negative = this.negative;
      dest.red = this.red;
    };
    BN2.prototype.clone = function clone() {
      var r2 = new BN2(null);
      this.copy(r2);
      return r2;
    };
    BN2.prototype._expand = function _expand(size) {
      while (this.length < size) {
        this.words[this.length++] = 0;
      }
      return this;
    };
    BN2.prototype.strip = function strip() {
      while (this.length > 1 && this.words[this.length - 1] === 0) {
        this.length--;
      }
      return this._normSign();
    };
    BN2.prototype._normSign = function _normSign() {
      if (this.length === 1 && this.words[0] === 0) {
        this.negative = 0;
      }
      return this;
    };
    BN2.prototype.inspect = function inspect9() {
      return (this.red ? "<BN-R: " : "<BN: ") + this.toString(16) + ">";
    };
    var zeros = [
      "",
      "0",
      "00",
      "000",
      "0000",
      "00000",
      "000000",
      "0000000",
      "00000000",
      "000000000",
      "0000000000",
      "00000000000",
      "000000000000",
      "0000000000000",
      "00000000000000",
      "000000000000000",
      "0000000000000000",
      "00000000000000000",
      "000000000000000000",
      "0000000000000000000",
      "00000000000000000000",
      "000000000000000000000",
      "0000000000000000000000",
      "00000000000000000000000",
      "000000000000000000000000",
      "0000000000000000000000000"
    ];
    var groupSizes = [
      0,
      0,
      25,
      16,
      12,
      11,
      10,
      9,
      8,
      8,
      7,
      7,
      7,
      7,
      6,
      6,
      6,
      6,
      6,
      6,
      6,
      5,
      5,
      5,
      5,
      5,
      5,
      5,
      5,
      5,
      5,
      5,
      5,
      5,
      5,
      5,
      5
    ];
    var groupBases = [
      0,
      0,
      33554432,
      43046721,
      16777216,
      48828125,
      60466176,
      40353607,
      16777216,
      43046721,
      1e7,
      19487171,
      35831808,
      62748517,
      7529536,
      11390625,
      16777216,
      24137569,
      34012224,
      47045881,
      64e6,
      4084101,
      5153632,
      6436343,
      7962624,
      9765625,
      11881376,
      14348907,
      17210368,
      20511149,
      243e5,
      28629151,
      33554432,
      39135393,
      45435424,
      52521875,
      60466176
    ];
    BN2.prototype.toString = function toString2(base3, padding) {
      base3 = base3 || 10;
      padding = padding | 0 || 1;
      var out;
      if (base3 === 16 || base3 === "hex") {
        out = "";
        var off = 0;
        var carry = 0;
        for (var i3 = 0; i3 < this.length; i3++) {
          var w2 = this.words[i3];
          var word = ((w2 << off | carry) & 16777215).toString(16);
          carry = w2 >>> 24 - off & 16777215;
          if (carry !== 0 || i3 !== this.length - 1) {
            out = zeros[6 - word.length] + word + out;
          } else {
            out = word + out;
          }
          off += 2;
          if (off >= 26) {
            off -= 26;
            i3--;
          }
        }
        if (carry !== 0) {
          out = carry.toString(16) + out;
        }
        while (out.length % padding !== 0) {
          out = "0" + out;
        }
        if (this.negative !== 0) {
          out = "-" + out;
        }
        return out;
      }
      if (base3 === (base3 | 0) && base3 >= 2 && base3 <= 36) {
        var groupSize = groupSizes[base3];
        var groupBase = groupBases[base3];
        out = "";
        var c2 = this.clone();
        c2.negative = 0;
        while (!c2.isZero()) {
          var r2 = c2.modn(groupBase).toString(base3);
          c2 = c2.idivn(groupBase);
          if (!c2.isZero()) {
            out = zeros[groupSize - r2.length] + r2 + out;
          } else {
            out = r2 + out;
          }
        }
        if (this.isZero()) {
          out = "0" + out;
        }
        while (out.length % padding !== 0) {
          out = "0" + out;
        }
        if (this.negative !== 0) {
          out = "-" + out;
        }
        return out;
      }
      assert2(false, "Base should be between 2 and 36");
    };
    BN2.prototype.toNumber = function toNumber() {
      var ret = this.words[0];
      if (this.length === 2) {
        ret += this.words[1] * 67108864;
      } else if (this.length === 3 && this.words[2] === 1) {
        ret += 4503599627370496 + this.words[1] * 67108864;
      } else if (this.length > 2) {
        assert2(false, "Number can only safely store up to 53 bits");
      }
      return this.negative !== 0 ? -ret : ret;
    };
    BN2.prototype.toJSON = function toJSON3() {
      return this.toString(16);
    };
    BN2.prototype.toBuffer = function toBuffer(endian, length) {
      assert2(typeof Buffer2 !== "undefined");
      return this.toArrayLike(Buffer2, endian, length);
    };
    BN2.prototype.toArray = function toArray(endian, length) {
      return this.toArrayLike(Array, endian, length);
    };
    BN2.prototype.toArrayLike = function toArrayLike(ArrayType, endian, length) {
      var byteLength = this.byteLength();
      var reqLength = length || Math.max(1, byteLength);
      assert2(byteLength <= reqLength, "byte array longer than desired length");
      assert2(reqLength > 0, "Requested array length <= 0");
      this.strip();
      var littleEndian = endian === "le";
      var res = new ArrayType(reqLength);
      var b2, i3;
      var q2 = this.clone();
      if (!littleEndian) {
        for (i3 = 0; i3 < reqLength - byteLength; i3++) {
          res[i3] = 0;
        }
        for (i3 = 0; !q2.isZero(); i3++) {
          b2 = q2.andln(255);
          q2.iushrn(8);
          res[reqLength - i3 - 1] = b2;
        }
      } else {
        for (i3 = 0; !q2.isZero(); i3++) {
          b2 = q2.andln(255);
          q2.iushrn(8);
          res[i3] = b2;
        }
        for (; i3 < reqLength; i3++) {
          res[i3] = 0;
        }
      }
      return res;
    };
    if (Math.clz32) {
      BN2.prototype._countBits = function _countBits(w2) {
        return 32 - Math.clz32(w2);
      };
    } else {
      BN2.prototype._countBits = function _countBits(w2) {
        var t = w2;
        var r2 = 0;
        if (t >= 4096) {
          r2 += 13;
          t >>>= 13;
        }
        if (t >= 64) {
          r2 += 7;
          t >>>= 7;
        }
        if (t >= 8) {
          r2 += 4;
          t >>>= 4;
        }
        if (t >= 2) {
          r2 += 2;
          t >>>= 2;
        }
        return r2 + t;
      };
    }
    BN2.prototype._zeroBits = function _zeroBits(w2) {
      if (w2 === 0) return 26;
      var t = w2;
      var r2 = 0;
      if ((t & 8191) === 0) {
        r2 += 13;
        t >>>= 13;
      }
      if ((t & 127) === 0) {
        r2 += 7;
        t >>>= 7;
      }
      if ((t & 15) === 0) {
        r2 += 4;
        t >>>= 4;
      }
      if ((t & 3) === 0) {
        r2 += 2;
        t >>>= 2;
      }
      if ((t & 1) === 0) {
        r2++;
      }
      return r2;
    };
    BN2.prototype.bitLength = function bitLength() {
      var w2 = this.words[this.length - 1];
      var hi2 = this._countBits(w2);
      return (this.length - 1) * 26 + hi2;
    };
    function toBitArray(num) {
      var w2 = new Array(num.bitLength());
      for (var bit = 0; bit < w2.length; bit++) {
        var off = bit / 26 | 0;
        var wbit = bit % 26;
        w2[bit] = (num.words[off] & 1 << wbit) >>> wbit;
      }
      return w2;
    }
    BN2.prototype.zeroBits = function zeroBits() {
      if (this.isZero()) return 0;
      var r2 = 0;
      for (var i3 = 0; i3 < this.length; i3++) {
        var b2 = this._zeroBits(this.words[i3]);
        r2 += b2;
        if (b2 !== 26) break;
      }
      return r2;
    };
    BN2.prototype.byteLength = function byteLength() {
      return Math.ceil(this.bitLength() / 8);
    };
    BN2.prototype.toTwos = function toTwos(width) {
      if (this.negative !== 0) {
        return this.abs().inotn(width).iaddn(1);
      }
      return this.clone();
    };
    BN2.prototype.fromTwos = function fromTwos(width) {
      if (this.testn(width - 1)) {
        return this.notn(width).iaddn(1).ineg();
      }
      return this.clone();
    };
    BN2.prototype.isNeg = function isNeg() {
      return this.negative !== 0;
    };
    BN2.prototype.neg = function neg6() {
      return this.clone().ineg();
    };
    BN2.prototype.ineg = function ineg() {
      if (!this.isZero()) {
        this.negative ^= 1;
      }
      return this;
    };
    BN2.prototype.iuor = function iuor(num) {
      while (this.length < num.length) {
        this.words[this.length++] = 0;
      }
      for (var i3 = 0; i3 < num.length; i3++) {
        this.words[i3] = this.words[i3] | num.words[i3];
      }
      return this.strip();
    };
    BN2.prototype.ior = function ior(num) {
      assert2((this.negative | num.negative) === 0);
      return this.iuor(num);
    };
    BN2.prototype.or = function or2(num) {
      if (this.length > num.length) return this.clone().ior(num);
      return num.clone().ior(this);
    };
    BN2.prototype.uor = function uor(num) {
      if (this.length > num.length) return this.clone().iuor(num);
      return num.clone().iuor(this);
    };
    BN2.prototype.iuand = function iuand(num) {
      var b2;
      if (this.length > num.length) {
        b2 = num;
      } else {
        b2 = this;
      }
      for (var i3 = 0; i3 < b2.length; i3++) {
        this.words[i3] = this.words[i3] & num.words[i3];
      }
      this.length = b2.length;
      return this.strip();
    };
    BN2.prototype.iand = function iand(num) {
      assert2((this.negative | num.negative) === 0);
      return this.iuand(num);
    };
    BN2.prototype.and = function and(num) {
      if (this.length > num.length) return this.clone().iand(num);
      return num.clone().iand(this);
    };
    BN2.prototype.uand = function uand(num) {
      if (this.length > num.length) return this.clone().iuand(num);
      return num.clone().iuand(this);
    };
    BN2.prototype.iuxor = function iuxor(num) {
      var a3;
      var b2;
      if (this.length > num.length) {
        a3 = this;
        b2 = num;
      } else {
        a3 = num;
        b2 = this;
      }
      for (var i3 = 0; i3 < b2.length; i3++) {
        this.words[i3] = a3.words[i3] ^ b2.words[i3];
      }
      if (this !== a3) {
        for (; i3 < a3.length; i3++) {
          this.words[i3] = a3.words[i3];
        }
      }
      this.length = a3.length;
      return this.strip();
    };
    BN2.prototype.ixor = function ixor(num) {
      assert2((this.negative | num.negative) === 0);
      return this.iuxor(num);
    };
    BN2.prototype.xor = function xor(num) {
      if (this.length > num.length) return this.clone().ixor(num);
      return num.clone().ixor(this);
    };
    BN2.prototype.uxor = function uxor(num) {
      if (this.length > num.length) return this.clone().iuxor(num);
      return num.clone().iuxor(this);
    };
    BN2.prototype.inotn = function inotn(width) {
      assert2(typeof width === "number" && width >= 0);
      var bytesNeeded = Math.ceil(width / 26) | 0;
      var bitsLeft = width % 26;
      this._expand(bytesNeeded);
      if (bitsLeft > 0) {
        bytesNeeded--;
      }
      for (var i3 = 0; i3 < bytesNeeded; i3++) {
        this.words[i3] = ~this.words[i3] & 67108863;
      }
      if (bitsLeft > 0) {
        this.words[i3] = ~this.words[i3] & 67108863 >> 26 - bitsLeft;
      }
      return this.strip();
    };
    BN2.prototype.notn = function notn(width) {
      return this.clone().inotn(width);
    };
    BN2.prototype.setn = function setn(bit, val) {
      assert2(typeof bit === "number" && bit >= 0);
      var off = bit / 26 | 0;
      var wbit = bit % 26;
      this._expand(off + 1);
      if (val) {
        this.words[off] = this.words[off] | 1 << wbit;
      } else {
        this.words[off] = this.words[off] & ~(1 << wbit);
      }
      return this.strip();
    };
    BN2.prototype.iadd = function iadd(num) {
      var r2;
      if (this.negative !== 0 && num.negative === 0) {
        this.negative = 0;
        r2 = this.isub(num);
        this.negative ^= 1;
        return this._normSign();
      } else if (this.negative === 0 && num.negative !== 0) {
        num.negative = 0;
        r2 = this.isub(num);
        num.negative = 1;
        return r2._normSign();
      }
      var a3, b2;
      if (this.length > num.length) {
        a3 = this;
        b2 = num;
      } else {
        a3 = num;
        b2 = this;
      }
      var carry = 0;
      for (var i3 = 0; i3 < b2.length; i3++) {
        r2 = (a3.words[i3] | 0) + (b2.words[i3] | 0) + carry;
        this.words[i3] = r2 & 67108863;
        carry = r2 >>> 26;
      }
      for (; carry !== 0 && i3 < a3.length; i3++) {
        r2 = (a3.words[i3] | 0) + carry;
        this.words[i3] = r2 & 67108863;
        carry = r2 >>> 26;
      }
      this.length = a3.length;
      if (carry !== 0) {
        this.words[this.length] = carry;
        this.length++;
      } else if (a3 !== this) {
        for (; i3 < a3.length; i3++) {
          this.words[i3] = a3.words[i3];
        }
      }
      return this;
    };
    BN2.prototype.add = function add7(num) {
      var res;
      if (num.negative !== 0 && this.negative === 0) {
        num.negative = 0;
        res = this.sub(num);
        num.negative ^= 1;
        return res;
      } else if (num.negative === 0 && this.negative !== 0) {
        this.negative = 0;
        res = num.sub(this);
        this.negative = 1;
        return res;
      }
      if (this.length > num.length) return this.clone().iadd(num);
      return num.clone().iadd(this);
    };
    BN2.prototype.isub = function isub(num) {
      if (num.negative !== 0) {
        num.negative = 0;
        var r2 = this.iadd(num);
        num.negative = 1;
        return r2._normSign();
      } else if (this.negative !== 0) {
        this.negative = 0;
        this.iadd(num);
        this.negative = 1;
        return this._normSign();
      }
      var cmp = this.cmp(num);
      if (cmp === 0) {
        this.negative = 0;
        this.length = 1;
        this.words[0] = 0;
        return this;
      }
      var a3, b2;
      if (cmp > 0) {
        a3 = this;
        b2 = num;
      } else {
        a3 = num;
        b2 = this;
      }
      var carry = 0;
      for (var i3 = 0; i3 < b2.length; i3++) {
        r2 = (a3.words[i3] | 0) - (b2.words[i3] | 0) + carry;
        carry = r2 >> 26;
        this.words[i3] = r2 & 67108863;
      }
      for (; carry !== 0 && i3 < a3.length; i3++) {
        r2 = (a3.words[i3] | 0) + carry;
        carry = r2 >> 26;
        this.words[i3] = r2 & 67108863;
      }
      if (carry === 0 && i3 < a3.length && a3 !== this) {
        for (; i3 < a3.length; i3++) {
          this.words[i3] = a3.words[i3];
        }
      }
      this.length = Math.max(this.length, i3);
      if (a3 !== this) {
        this.negative = 1;
      }
      return this.strip();
    };
    BN2.prototype.sub = function sub(num) {
      return this.clone().isub(num);
    };
    function smallMulTo(self2, num, out) {
      out.negative = num.negative ^ self2.negative;
      var len = self2.length + num.length | 0;
      out.length = len;
      len = len - 1 | 0;
      var a3 = self2.words[0] | 0;
      var b2 = num.words[0] | 0;
      var r2 = a3 * b2;
      var lo2 = r2 & 67108863;
      var carry = r2 / 67108864 | 0;
      out.words[0] = lo2;
      for (var k2 = 1; k2 < len; k2++) {
        var ncarry = carry >>> 26;
        var rword = carry & 67108863;
        var maxJ = Math.min(k2, num.length - 1);
        for (var j2 = Math.max(0, k2 - self2.length + 1); j2 <= maxJ; j2++) {
          var i3 = k2 - j2 | 0;
          a3 = self2.words[i3] | 0;
          b2 = num.words[j2] | 0;
          r2 = a3 * b2 + rword;
          ncarry += r2 / 67108864 | 0;
          rword = r2 & 67108863;
        }
        out.words[k2] = rword | 0;
        carry = ncarry | 0;
      }
      if (carry !== 0) {
        out.words[k2] = carry | 0;
      } else {
        out.length--;
      }
      return out.strip();
    }
    var comb10MulTo = function comb10MulTo2(self2, num, out) {
      var a3 = self2.words;
      var b2 = num.words;
      var o3 = out.words;
      var c2 = 0;
      var lo2;
      var mid;
      var hi2;
      var a0 = a3[0] | 0;
      var al0 = a0 & 8191;
      var ah0 = a0 >>> 13;
      var a1 = a3[1] | 0;
      var al1 = a1 & 8191;
      var ah1 = a1 >>> 13;
      var a22 = a3[2] | 0;
      var al2 = a22 & 8191;
      var ah2 = a22 >>> 13;
      var a32 = a3[3] | 0;
      var al3 = a32 & 8191;
      var ah3 = a32 >>> 13;
      var a4 = a3[4] | 0;
      var al4 = a4 & 8191;
      var ah4 = a4 >>> 13;
      var a5 = a3[5] | 0;
      var al5 = a5 & 8191;
      var ah5 = a5 >>> 13;
      var a6 = a3[6] | 0;
      var al6 = a6 & 8191;
      var ah6 = a6 >>> 13;
      var a7 = a3[7] | 0;
      var al7 = a7 & 8191;
      var ah7 = a7 >>> 13;
      var a8 = a3[8] | 0;
      var al8 = a8 & 8191;
      var ah8 = a8 >>> 13;
      var a9 = a3[9] | 0;
      var al9 = a9 & 8191;
      var ah9 = a9 >>> 13;
      var b0 = b2[0] | 0;
      var bl0 = b0 & 8191;
      var bh0 = b0 >>> 13;
      var b1 = b2[1] | 0;
      var bl1 = b1 & 8191;
      var bh1 = b1 >>> 13;
      var b22 = b2[2] | 0;
      var bl2 = b22 & 8191;
      var bh2 = b22 >>> 13;
      var b3 = b2[3] | 0;
      var bl3 = b3 & 8191;
      var bh3 = b3 >>> 13;
      var b4 = b2[4] | 0;
      var bl4 = b4 & 8191;
      var bh4 = b4 >>> 13;
      var b5 = b2[5] | 0;
      var bl5 = b5 & 8191;
      var bh5 = b5 >>> 13;
      var b6 = b2[6] | 0;
      var bl6 = b6 & 8191;
      var bh6 = b6 >>> 13;
      var b7 = b2[7] | 0;
      var bl7 = b7 & 8191;
      var bh7 = b7 >>> 13;
      var b8 = b2[8] | 0;
      var bl8 = b8 & 8191;
      var bh8 = b8 >>> 13;
      var b9 = b2[9] | 0;
      var bl9 = b9 & 8191;
      var bh9 = b9 >>> 13;
      out.negative = self2.negative ^ num.negative;
      out.length = 19;
      lo2 = Math.imul(al0, bl0);
      mid = Math.imul(al0, bh0);
      mid = mid + Math.imul(ah0, bl0) | 0;
      hi2 = Math.imul(ah0, bh0);
      var w0 = (c2 + lo2 | 0) + ((mid & 8191) << 13) | 0;
      c2 = (hi2 + (mid >>> 13) | 0) + (w0 >>> 26) | 0;
      w0 &= 67108863;
      lo2 = Math.imul(al1, bl0);
      mid = Math.imul(al1, bh0);
      mid = mid + Math.imul(ah1, bl0) | 0;
      hi2 = Math.imul(ah1, bh0);
      lo2 = lo2 + Math.imul(al0, bl1) | 0;
      mid = mid + Math.imul(al0, bh1) | 0;
      mid = mid + Math.imul(ah0, bl1) | 0;
      hi2 = hi2 + Math.imul(ah0, bh1) | 0;
      var w1 = (c2 + lo2 | 0) + ((mid & 8191) << 13) | 0;
      c2 = (hi2 + (mid >>> 13) | 0) + (w1 >>> 26) | 0;
      w1 &= 67108863;
      lo2 = Math.imul(al2, bl0);
      mid = Math.imul(al2, bh0);
      mid = mid + Math.imul(ah2, bl0) | 0;
      hi2 = Math.imul(ah2, bh0);
      lo2 = lo2 + Math.imul(al1, bl1) | 0;
      mid = mid + Math.imul(al1, bh1) | 0;
      mid = mid + Math.imul(ah1, bl1) | 0;
      hi2 = hi2 + Math.imul(ah1, bh1) | 0;
      lo2 = lo2 + Math.imul(al0, bl2) | 0;
      mid = mid + Math.imul(al0, bh2) | 0;
      mid = mid + Math.imul(ah0, bl2) | 0;
      hi2 = hi2 + Math.imul(ah0, bh2) | 0;
      var w2 = (c2 + lo2 | 0) + ((mid & 8191) << 13) | 0;
      c2 = (hi2 + (mid >>> 13) | 0) + (w2 >>> 26) | 0;
      w2 &= 67108863;
      lo2 = Math.imul(al3, bl0);
      mid = Math.imul(al3, bh0);
      mid = mid + Math.imul(ah3, bl0) | 0;
      hi2 = Math.imul(ah3, bh0);
      lo2 = lo2 + Math.imul(al2, bl1) | 0;
      mid = mid + Math.imul(al2, bh1) | 0;
      mid = mid + Math.imul(ah2, bl1) | 0;
      hi2 = hi2 + Math.imul(ah2, bh1) | 0;
      lo2 = lo2 + Math.imul(al1, bl2) | 0;
      mid = mid + Math.imul(al1, bh2) | 0;
      mid = mid + Math.imul(ah1, bl2) | 0;
      hi2 = hi2 + Math.imul(ah1, bh2) | 0;
      lo2 = lo2 + Math.imul(al0, bl3) | 0;
      mid = mid + Math.imul(al0, bh3) | 0;
      mid = mid + Math.imul(ah0, bl3) | 0;
      hi2 = hi2 + Math.imul(ah0, bh3) | 0;
      var w3 = (c2 + lo2 | 0) + ((mid & 8191) << 13) | 0;
      c2 = (hi2 + (mid >>> 13) | 0) + (w3 >>> 26) | 0;
      w3 &= 67108863;
      lo2 = Math.imul(al4, bl0);
      mid = Math.imul(al4, bh0);
      mid = mid + Math.imul(ah4, bl0) | 0;
      hi2 = Math.imul(ah4, bh0);
      lo2 = lo2 + Math.imul(al3, bl1) | 0;
      mid = mid + Math.imul(al3, bh1) | 0;
      mid = mid + Math.imul(ah3, bl1) | 0;
      hi2 = hi2 + Math.imul(ah3, bh1) | 0;
      lo2 = lo2 + Math.imul(al2, bl2) | 0;
      mid = mid + Math.imul(al2, bh2) | 0;
      mid = mid + Math.imul(ah2, bl2) | 0;
      hi2 = hi2 + Math.imul(ah2, bh2) | 0;
      lo2 = lo2 + Math.imul(al1, bl3) | 0;
      mid = mid + Math.imul(al1, bh3) | 0;
      mid = mid + Math.imul(ah1, bl3) | 0;
      hi2 = hi2 + Math.imul(ah1, bh3) | 0;
      lo2 = lo2 + Math.imul(al0, bl4) | 0;
      mid = mid + Math.imul(al0, bh4) | 0;
      mid = mid + Math.imul(ah0, bl4) | 0;
      hi2 = hi2 + Math.imul(ah0, bh4) | 0;
      var w4 = (c2 + lo2 | 0) + ((mid & 8191) << 13) | 0;
      c2 = (hi2 + (mid >>> 13) | 0) + (w4 >>> 26) | 0;
      w4 &= 67108863;
      lo2 = Math.imul(al5, bl0);
      mid = Math.imul(al5, bh0);
      mid = mid + Math.imul(ah5, bl0) | 0;
      hi2 = Math.imul(ah5, bh0);
      lo2 = lo2 + Math.imul(al4, bl1) | 0;
      mid = mid + Math.imul(al4, bh1) | 0;
      mid = mid + Math.imul(ah4, bl1) | 0;
      hi2 = hi2 + Math.imul(ah4, bh1) | 0;
      lo2 = lo2 + Math.imul(al3, bl2) | 0;
      mid = mid + Math.imul(al3, bh2) | 0;
      mid = mid + Math.imul(ah3, bl2) | 0;
      hi2 = hi2 + Math.imul(ah3, bh2) | 0;
      lo2 = lo2 + Math.imul(al2, bl3) | 0;
      mid = mid + Math.imul(al2, bh3) | 0;
      mid = mid + Math.imul(ah2, bl3) | 0;
      hi2 = hi2 + Math.imul(ah2, bh3) | 0;
      lo2 = lo2 + Math.imul(al1, bl4) | 0;
      mid = mid + Math.imul(al1, bh4) | 0;
      mid = mid + Math.imul(ah1, bl4) | 0;
      hi2 = hi2 + Math.imul(ah1, bh4) | 0;
      lo2 = lo2 + Math.imul(al0, bl5) | 0;
      mid = mid + Math.imul(al0, bh5) | 0;
      mid = mid + Math.imul(ah0, bl5) | 0;
      hi2 = hi2 + Math.imul(ah0, bh5) | 0;
      var w5 = (c2 + lo2 | 0) + ((mid & 8191) << 13) | 0;
      c2 = (hi2 + (mid >>> 13) | 0) + (w5 >>> 26) | 0;
      w5 &= 67108863;
      lo2 = Math.imul(al6, bl0);
      mid = Math.imul(al6, bh0);
      mid = mid + Math.imul(ah6, bl0) | 0;
      hi2 = Math.imul(ah6, bh0);
      lo2 = lo2 + Math.imul(al5, bl1) | 0;
      mid = mid + Math.imul(al5, bh1) | 0;
      mid = mid + Math.imul(ah5, bl1) | 0;
      hi2 = hi2 + Math.imul(ah5, bh1) | 0;
      lo2 = lo2 + Math.imul(al4, bl2) | 0;
      mid = mid + Math.imul(al4, bh2) | 0;
      mid = mid + Math.imul(ah4, bl2) | 0;
      hi2 = hi2 + Math.imul(ah4, bh2) | 0;
      lo2 = lo2 + Math.imul(al3, bl3) | 0;
      mid = mid + Math.imul(al3, bh3) | 0;
      mid = mid + Math.imul(ah3, bl3) | 0;
      hi2 = hi2 + Math.imul(ah3, bh3) | 0;
      lo2 = lo2 + Math.imul(al2, bl4) | 0;
      mid = mid + Math.imul(al2, bh4) | 0;
      mid = mid + Math.imul(ah2, bl4) | 0;
      hi2 = hi2 + Math.imul(ah2, bh4) | 0;
      lo2 = lo2 + Math.imul(al1, bl5) | 0;
      mid = mid + Math.imul(al1, bh5) | 0;
      mid = mid + Math.imul(ah1, bl5) | 0;
      hi2 = hi2 + Math.imul(ah1, bh5) | 0;
      lo2 = lo2 + Math.imul(al0, bl6) | 0;
      mid = mid + Math.imul(al0, bh6) | 0;
      mid = mid + Math.imul(ah0, bl6) | 0;
      hi2 = hi2 + Math.imul(ah0, bh6) | 0;
      var w6 = (c2 + lo2 | 0) + ((mid & 8191) << 13) | 0;
      c2 = (hi2 + (mid >>> 13) | 0) + (w6 >>> 26) | 0;
      w6 &= 67108863;
      lo2 = Math.imul(al7, bl0);
      mid = Math.imul(al7, bh0);
      mid = mid + Math.imul(ah7, bl0) | 0;
      hi2 = Math.imul(ah7, bh0);
      lo2 = lo2 + Math.imul(al6, bl1) | 0;
      mid = mid + Math.imul(al6, bh1) | 0;
      mid = mid + Math.imul(ah6, bl1) | 0;
      hi2 = hi2 + Math.imul(ah6, bh1) | 0;
      lo2 = lo2 + Math.imul(al5, bl2) | 0;
      mid = mid + Math.imul(al5, bh2) | 0;
      mid = mid + Math.imul(ah5, bl2) | 0;
      hi2 = hi2 + Math.imul(ah5, bh2) | 0;
      lo2 = lo2 + Math.imul(al4, bl3) | 0;
      mid = mid + Math.imul(al4, bh3) | 0;
      mid = mid + Math.imul(ah4, bl3) | 0;
      hi2 = hi2 + Math.imul(ah4, bh3) | 0;
      lo2 = lo2 + Math.imul(al3, bl4) | 0;
      mid = mid + Math.imul(al3, bh4) | 0;
      mid = mid + Math.imul(ah3, bl4) | 0;
      hi2 = hi2 + Math.imul(ah3, bh4) | 0;
      lo2 = lo2 + Math.imul(al2, bl5) | 0;
      mid = mid + Math.imul(al2, bh5) | 0;
      mid = mid + Math.imul(ah2, bl5) | 0;
      hi2 = hi2 + Math.imul(ah2, bh5) | 0;
      lo2 = lo2 + Math.imul(al1, bl6) | 0;
      mid = mid + Math.imul(al1, bh6) | 0;
      mid = mid + Math.imul(ah1, bl6) | 0;
      hi2 = hi2 + Math.imul(ah1, bh6) | 0;
      lo2 = lo2 + Math.imul(al0, bl7) | 0;
      mid = mid + Math.imul(al0, bh7) | 0;
      mid = mid + Math.imul(ah0, bl7) | 0;
      hi2 = hi2 + Math.imul(ah0, bh7) | 0;
      var w7 = (c2 + lo2 | 0) + ((mid & 8191) << 13) | 0;
      c2 = (hi2 + (mid >>> 13) | 0) + (w7 >>> 26) | 0;
      w7 &= 67108863;
      lo2 = Math.imul(al8, bl0);
      mid = Math.imul(al8, bh0);
      mid = mid + Math.imul(ah8, bl0) | 0;
      hi2 = Math.imul(ah8, bh0);
      lo2 = lo2 + Math.imul(al7, bl1) | 0;
      mid = mid + Math.imul(al7, bh1) | 0;
      mid = mid + Math.imul(ah7, bl1) | 0;
      hi2 = hi2 + Math.imul(ah7, bh1) | 0;
      lo2 = lo2 + Math.imul(al6, bl2) | 0;
      mid = mid + Math.imul(al6, bh2) | 0;
      mid = mid + Math.imul(ah6, bl2) | 0;
      hi2 = hi2 + Math.imul(ah6, bh2) | 0;
      lo2 = lo2 + Math.imul(al5, bl3) | 0;
      mid = mid + Math.imul(al5, bh3) | 0;
      mid = mid + Math.imul(ah5, bl3) | 0;
      hi2 = hi2 + Math.imul(ah5, bh3) | 0;
      lo2 = lo2 + Math.imul(al4, bl4) | 0;
      mid = mid + Math.imul(al4, bh4) | 0;
      mid = mid + Math.imul(ah4, bl4) | 0;
      hi2 = hi2 + Math.imul(ah4, bh4) | 0;
      lo2 = lo2 + Math.imul(al3, bl5) | 0;
      mid = mid + Math.imul(al3, bh5) | 0;
      mid = mid + Math.imul(ah3, bl5) | 0;
      hi2 = hi2 + Math.imul(ah3, bh5) | 0;
      lo2 = lo2 + Math.imul(al2, bl6) | 0;
      mid = mid + Math.imul(al2, bh6) | 0;
      mid = mid + Math.imul(ah2, bl6) | 0;
      hi2 = hi2 + Math.imul(ah2, bh6) | 0;
      lo2 = lo2 + Math.imul(al1, bl7) | 0;
      mid = mid + Math.imul(al1, bh7) | 0;
      mid = mid + Math.imul(ah1, bl7) | 0;
      hi2 = hi2 + Math.imul(ah1, bh7) | 0;
      lo2 = lo2 + Math.imul(al0, bl8) | 0;
      mid = mid + Math.imul(al0, bh8) | 0;
      mid = mid + Math.imul(ah0, bl8) | 0;
      hi2 = hi2 + Math.imul(ah0, bh8) | 0;
      var w8 = (c2 + lo2 | 0) + ((mid & 8191) << 13) | 0;
      c2 = (hi2 + (mid >>> 13) | 0) + (w8 >>> 26) | 0;
      w8 &= 67108863;
      lo2 = Math.imul(al9, bl0);
      mid = Math.imul(al9, bh0);
      mid = mid + Math.imul(ah9, bl0) | 0;
      hi2 = Math.imul(ah9, bh0);
      lo2 = lo2 + Math.imul(al8, bl1) | 0;
      mid = mid + Math.imul(al8, bh1) | 0;
      mid = mid + Math.imul(ah8, bl1) | 0;
      hi2 = hi2 + Math.imul(ah8, bh1) | 0;
      lo2 = lo2 + Math.imul(al7, bl2) | 0;
      mid = mid + Math.imul(al7, bh2) | 0;
      mid = mid + Math.imul(ah7, bl2) | 0;
      hi2 = hi2 + Math.imul(ah7, bh2) | 0;
      lo2 = lo2 + Math.imul(al6, bl3) | 0;
      mid = mid + Math.imul(al6, bh3) | 0;
      mid = mid + Math.imul(ah6, bl3) | 0;
      hi2 = hi2 + Math.imul(ah6, bh3) | 0;
      lo2 = lo2 + Math.imul(al5, bl4) | 0;
      mid = mid + Math.imul(al5, bh4) | 0;
      mid = mid + Math.imul(ah5, bl4) | 0;
      hi2 = hi2 + Math.imul(ah5, bh4) | 0;
      lo2 = lo2 + Math.imul(al4, bl5) | 0;
      mid = mid + Math.imul(al4, bh5) | 0;
      mid = mid + Math.imul(ah4, bl5) | 0;
      hi2 = hi2 + Math.imul(ah4, bh5) | 0;
      lo2 = lo2 + Math.imul(al3, bl6) | 0;
      mid = mid + Math.imul(al3, bh6) | 0;
      mid = mid + Math.imul(ah3, bl6) | 0;
      hi2 = hi2 + Math.imul(ah3, bh6) | 0;
      lo2 = lo2 + Math.imul(al2, bl7) | 0;
      mid = mid + Math.imul(al2, bh7) | 0;
      mid = mid + Math.imul(ah2, bl7) | 0;
      hi2 = hi2 + Math.imul(ah2, bh7) | 0;
      lo2 = lo2 + Math.imul(al1, bl8) | 0;
      mid = mid + Math.imul(al1, bh8) | 0;
      mid = mid + Math.imul(ah1, bl8) | 0;
      hi2 = hi2 + Math.imul(ah1, bh8) | 0;
      lo2 = lo2 + Math.imul(al0, bl9) | 0;
      mid = mid + Math.imul(al0, bh9) | 0;
      mid = mid + Math.imul(ah0, bl9) | 0;
      hi2 = hi2 + Math.imul(ah0, bh9) | 0;
      var w9 = (c2 + lo2 | 0) + ((mid & 8191) << 13) | 0;
      c2 = (hi2 + (mid >>> 13) | 0) + (w9 >>> 26) | 0;
      w9 &= 67108863;
      lo2 = Math.imul(al9, bl1);
      mid = Math.imul(al9, bh1);
      mid = mid + Math.imul(ah9, bl1) | 0;
      hi2 = Math.imul(ah9, bh1);
      lo2 = lo2 + Math.imul(al8, bl2) | 0;
      mid = mid + Math.imul(al8, bh2) | 0;
      mid = mid + Math.imul(ah8, bl2) | 0;
      hi2 = hi2 + Math.imul(ah8, bh2) | 0;
      lo2 = lo2 + Math.imul(al7, bl3) | 0;
      mid = mid + Math.imul(al7, bh3) | 0;
      mid = mid + Math.imul(ah7, bl3) | 0;
      hi2 = hi2 + Math.imul(ah7, bh3) | 0;
      lo2 = lo2 + Math.imul(al6, bl4) | 0;
      mid = mid + Math.imul(al6, bh4) | 0;
      mid = mid + Math.imul(ah6, bl4) | 0;
      hi2 = hi2 + Math.imul(ah6, bh4) | 0;
      lo2 = lo2 + Math.imul(al5, bl5) | 0;
      mid = mid + Math.imul(al5, bh5) | 0;
      mid = mid + Math.imul(ah5, bl5) | 0;
      hi2 = hi2 + Math.imul(ah5, bh5) | 0;
      lo2 = lo2 + Math.imul(al4, bl6) | 0;
      mid = mid + Math.imul(al4, bh6) | 0;
      mid = mid + Math.imul(ah4, bl6) | 0;
      hi2 = hi2 + Math.imul(ah4, bh6) | 0;
      lo2 = lo2 + Math.imul(al3, bl7) | 0;
      mid = mid + Math.imul(al3, bh7) | 0;
      mid = mid + Math.imul(ah3, bl7) | 0;
      hi2 = hi2 + Math.imul(ah3, bh7) | 0;
      lo2 = lo2 + Math.imul(al2, bl8) | 0;
      mid = mid + Math.imul(al2, bh8) | 0;
      mid = mid + Math.imul(ah2, bl8) | 0;
      hi2 = hi2 + Math.imul(ah2, bh8) | 0;
      lo2 = lo2 + Math.imul(al1, bl9) | 0;
      mid = mid + Math.imul(al1, bh9) | 0;
      mid = mid + Math.imul(ah1, bl9) | 0;
      hi2 = hi2 + Math.imul(ah1, bh9) | 0;
      var w10 = (c2 + lo2 | 0) + ((mid & 8191) << 13) | 0;
      c2 = (hi2 + (mid >>> 13) | 0) + (w10 >>> 26) | 0;
      w10 &= 67108863;
      lo2 = Math.imul(al9, bl2);
      mid = Math.imul(al9, bh2);
      mid = mid + Math.imul(ah9, bl2) | 0;
      hi2 = Math.imul(ah9, bh2);
      lo2 = lo2 + Math.imul(al8, bl3) | 0;
      mid = mid + Math.imul(al8, bh3) | 0;
      mid = mid + Math.imul(ah8, bl3) | 0;
      hi2 = hi2 + Math.imul(ah8, bh3) | 0;
      lo2 = lo2 + Math.imul(al7, bl4) | 0;
      mid = mid + Math.imul(al7, bh4) | 0;
      mid = mid + Math.imul(ah7, bl4) | 0;
      hi2 = hi2 + Math.imul(ah7, bh4) | 0;
      lo2 = lo2 + Math.imul(al6, bl5) | 0;
      mid = mid + Math.imul(al6, bh5) | 0;
      mid = mid + Math.imul(ah6, bl5) | 0;
      hi2 = hi2 + Math.imul(ah6, bh5) | 0;
      lo2 = lo2 + Math.imul(al5, bl6) | 0;
      mid = mid + Math.imul(al5, bh6) | 0;
      mid = mid + Math.imul(ah5, bl6) | 0;
      hi2 = hi2 + Math.imul(ah5, bh6) | 0;
      lo2 = lo2 + Math.imul(al4, bl7) | 0;
      mid = mid + Math.imul(al4, bh7) | 0;
      mid = mid + Math.imul(ah4, bl7) | 0;
      hi2 = hi2 + Math.imul(ah4, bh7) | 0;
      lo2 = lo2 + Math.imul(al3, bl8) | 0;
      mid = mid + Math.imul(al3, bh8) | 0;
      mid = mid + Math.imul(ah3, bl8) | 0;
      hi2 = hi2 + Math.imul(ah3, bh8) | 0;
      lo2 = lo2 + Math.imul(al2, bl9) | 0;
      mid = mid + Math.imul(al2, bh9) | 0;
      mid = mid + Math.imul(ah2, bl9) | 0;
      hi2 = hi2 + Math.imul(ah2, bh9) | 0;
      var w11 = (c2 + lo2 | 0) + ((mid & 8191) << 13) | 0;
      c2 = (hi2 + (mid >>> 13) | 0) + (w11 >>> 26) | 0;
      w11 &= 67108863;
      lo2 = Math.imul(al9, bl3);
      mid = Math.imul(al9, bh3);
      mid = mid + Math.imul(ah9, bl3) | 0;
      hi2 = Math.imul(ah9, bh3);
      lo2 = lo2 + Math.imul(al8, bl4) | 0;
      mid = mid + Math.imul(al8, bh4) | 0;
      mid = mid + Math.imul(ah8, bl4) | 0;
      hi2 = hi2 + Math.imul(ah8, bh4) | 0;
      lo2 = lo2 + Math.imul(al7, bl5) | 0;
      mid = mid + Math.imul(al7, bh5) | 0;
      mid = mid + Math.imul(ah7, bl5) | 0;
      hi2 = hi2 + Math.imul(ah7, bh5) | 0;
      lo2 = lo2 + Math.imul(al6, bl6) | 0;
      mid = mid + Math.imul(al6, bh6) | 0;
      mid = mid + Math.imul(ah6, bl6) | 0;
      hi2 = hi2 + Math.imul(ah6, bh6) | 0;
      lo2 = lo2 + Math.imul(al5, bl7) | 0;
      mid = mid + Math.imul(al5, bh7) | 0;
      mid = mid + Math.imul(ah5, bl7) | 0;
      hi2 = hi2 + Math.imul(ah5, bh7) | 0;
      lo2 = lo2 + Math.imul(al4, bl8) | 0;
      mid = mid + Math.imul(al4, bh8) | 0;
      mid = mid + Math.imul(ah4, bl8) | 0;
      hi2 = hi2 + Math.imul(ah4, bh8) | 0;
      lo2 = lo2 + Math.imul(al3, bl9) | 0;
      mid = mid + Math.imul(al3, bh9) | 0;
      mid = mid + Math.imul(ah3, bl9) | 0;
      hi2 = hi2 + Math.imul(ah3, bh9) | 0;
      var w12 = (c2 + lo2 | 0) + ((mid & 8191) << 13) | 0;
      c2 = (hi2 + (mid >>> 13) | 0) + (w12 >>> 26) | 0;
      w12 &= 67108863;
      lo2 = Math.imul(al9, bl4);
      mid = Math.imul(al9, bh4);
      mid = mid + Math.imul(ah9, bl4) | 0;
      hi2 = Math.imul(ah9, bh4);
      lo2 = lo2 + Math.imul(al8, bl5) | 0;
      mid = mid + Math.imul(al8, bh5) | 0;
      mid = mid + Math.imul(ah8, bl5) | 0;
      hi2 = hi2 + Math.imul(ah8, bh5) | 0;
      lo2 = lo2 + Math.imul(al7, bl6) | 0;
      mid = mid + Math.imul(al7, bh6) | 0;
      mid = mid + Math.imul(ah7, bl6) | 0;
      hi2 = hi2 + Math.imul(ah7, bh6) | 0;
      lo2 = lo2 + Math.imul(al6, bl7) | 0;
      mid = mid + Math.imul(al6, bh7) | 0;
      mid = mid + Math.imul(ah6, bl7) | 0;
      hi2 = hi2 + Math.imul(ah6, bh7) | 0;
      lo2 = lo2 + Math.imul(al5, bl8) | 0;
      mid = mid + Math.imul(al5, bh8) | 0;
      mid = mid + Math.imul(ah5, bl8) | 0;
      hi2 = hi2 + Math.imul(ah5, bh8) | 0;
      lo2 = lo2 + Math.imul(al4, bl9) | 0;
      mid = mid + Math.imul(al4, bh9) | 0;
      mid = mid + Math.imul(ah4, bl9) | 0;
      hi2 = hi2 + Math.imul(ah4, bh9) | 0;
      var w13 = (c2 + lo2 | 0) + ((mid & 8191) << 13) | 0;
      c2 = (hi2 + (mid >>> 13) | 0) + (w13 >>> 26) | 0;
      w13 &= 67108863;
      lo2 = Math.imul(al9, bl5);
      mid = Math.imul(al9, bh5);
      mid = mid + Math.imul(ah9, bl5) | 0;
      hi2 = Math.imul(ah9, bh5);
      lo2 = lo2 + Math.imul(al8, bl6) | 0;
      mid = mid + Math.imul(al8, bh6) | 0;
      mid = mid + Math.imul(ah8, bl6) | 0;
      hi2 = hi2 + Math.imul(ah8, bh6) | 0;
      lo2 = lo2 + Math.imul(al7, bl7) | 0;
      mid = mid + Math.imul(al7, bh7) | 0;
      mid = mid + Math.imul(ah7, bl7) | 0;
      hi2 = hi2 + Math.imul(ah7, bh7) | 0;
      lo2 = lo2 + Math.imul(al6, bl8) | 0;
      mid = mid + Math.imul(al6, bh8) | 0;
      mid = mid + Math.imul(ah6, bl8) | 0;
      hi2 = hi2 + Math.imul(ah6, bh8) | 0;
      lo2 = lo2 + Math.imul(al5, bl9) | 0;
      mid = mid + Math.imul(al5, bh9) | 0;
      mid = mid + Math.imul(ah5, bl9) | 0;
      hi2 = hi2 + Math.imul(ah5, bh9) | 0;
      var w14 = (c2 + lo2 | 0) + ((mid & 8191) << 13) | 0;
      c2 = (hi2 + (mid >>> 13) | 0) + (w14 >>> 26) | 0;
      w14 &= 67108863;
      lo2 = Math.imul(al9, bl6);
      mid = Math.imul(al9, bh6);
      mid = mid + Math.imul(ah9, bl6) | 0;
      hi2 = Math.imul(ah9, bh6);
      lo2 = lo2 + Math.imul(al8, bl7) | 0;
      mid = mid + Math.imul(al8, bh7) | 0;
      mid = mid + Math.imul(ah8, bl7) | 0;
      hi2 = hi2 + Math.imul(ah8, bh7) | 0;
      lo2 = lo2 + Math.imul(al7, bl8) | 0;
      mid = mid + Math.imul(al7, bh8) | 0;
      mid = mid + Math.imul(ah7, bl8) | 0;
      hi2 = hi2 + Math.imul(ah7, bh8) | 0;
      lo2 = lo2 + Math.imul(al6, bl9) | 0;
      mid = mid + Math.imul(al6, bh9) | 0;
      mid = mid + Math.imul(ah6, bl9) | 0;
      hi2 = hi2 + Math.imul(ah6, bh9) | 0;
      var w15 = (c2 + lo2 | 0) + ((mid & 8191) << 13) | 0;
      c2 = (hi2 + (mid >>> 13) | 0) + (w15 >>> 26) | 0;
      w15 &= 67108863;
      lo2 = Math.imul(al9, bl7);
      mid = Math.imul(al9, bh7);
      mid = mid + Math.imul(ah9, bl7) | 0;
      hi2 = Math.imul(ah9, bh7);
      lo2 = lo2 + Math.imul(al8, bl8) | 0;
      mid = mid + Math.imul(al8, bh8) | 0;
      mid = mid + Math.imul(ah8, bl8) | 0;
      hi2 = hi2 + Math.imul(ah8, bh8) | 0;
      lo2 = lo2 + Math.imul(al7, bl9) | 0;
      mid = mid + Math.imul(al7, bh9) | 0;
      mid = mid + Math.imul(ah7, bl9) | 0;
      hi2 = hi2 + Math.imul(ah7, bh9) | 0;
      var w16 = (c2 + lo2 | 0) + ((mid & 8191) << 13) | 0;
      c2 = (hi2 + (mid >>> 13) | 0) + (w16 >>> 26) | 0;
      w16 &= 67108863;
      lo2 = Math.imul(al9, bl8);
      mid = Math.imul(al9, bh8);
      mid = mid + Math.imul(ah9, bl8) | 0;
      hi2 = Math.imul(ah9, bh8);
      lo2 = lo2 + Math.imul(al8, bl9) | 0;
      mid = mid + Math.imul(al8, bh9) | 0;
      mid = mid + Math.imul(ah8, bl9) | 0;
      hi2 = hi2 + Math.imul(ah8, bh9) | 0;
      var w17 = (c2 + lo2 | 0) + ((mid & 8191) << 13) | 0;
      c2 = (hi2 + (mid >>> 13) | 0) + (w17 >>> 26) | 0;
      w17 &= 67108863;
      lo2 = Math.imul(al9, bl9);
      mid = Math.imul(al9, bh9);
      mid = mid + Math.imul(ah9, bl9) | 0;
      hi2 = Math.imul(ah9, bh9);
      var w18 = (c2 + lo2 | 0) + ((mid & 8191) << 13) | 0;
      c2 = (hi2 + (mid >>> 13) | 0) + (w18 >>> 26) | 0;
      w18 &= 67108863;
      o3[0] = w0;
      o3[1] = w1;
      o3[2] = w2;
      o3[3] = w3;
      o3[4] = w4;
      o3[5] = w5;
      o3[6] = w6;
      o3[7] = w7;
      o3[8] = w8;
      o3[9] = w9;
      o3[10] = w10;
      o3[11] = w11;
      o3[12] = w12;
      o3[13] = w13;
      o3[14] = w14;
      o3[15] = w15;
      o3[16] = w16;
      o3[17] = w17;
      o3[18] = w18;
      if (c2 !== 0) {
        o3[19] = c2;
        out.length++;
      }
      return out;
    };
    if (!Math.imul) {
      comb10MulTo = smallMulTo;
    }
    function bigMulTo(self2, num, out) {
      out.negative = num.negative ^ self2.negative;
      out.length = self2.length + num.length;
      var carry = 0;
      var hncarry = 0;
      for (var k2 = 0; k2 < out.length - 1; k2++) {
        var ncarry = hncarry;
        hncarry = 0;
        var rword = carry & 67108863;
        var maxJ = Math.min(k2, num.length - 1);
        for (var j2 = Math.max(0, k2 - self2.length + 1); j2 <= maxJ; j2++) {
          var i3 = k2 - j2;
          var a3 = self2.words[i3] | 0;
          var b2 = num.words[j2] | 0;
          var r2 = a3 * b2;
          var lo2 = r2 & 67108863;
          ncarry = ncarry + (r2 / 67108864 | 0) | 0;
          lo2 = lo2 + rword | 0;
          rword = lo2 & 67108863;
          ncarry = ncarry + (lo2 >>> 26) | 0;
          hncarry += ncarry >>> 26;
          ncarry &= 67108863;
        }
        out.words[k2] = rword;
        carry = ncarry;
        ncarry = hncarry;
      }
      if (carry !== 0) {
        out.words[k2] = carry;
      } else {
        out.length--;
      }
      return out.strip();
    }
    function jumboMulTo(self2, num, out) {
      var fftm = new FFTM();
      return fftm.mulp(self2, num, out);
    }
    BN2.prototype.mulTo = function mulTo(num, out) {
      var res;
      var len = this.length + num.length;
      if (this.length === 10 && num.length === 10) {
        res = comb10MulTo(this, num, out);
      } else if (len < 63) {
        res = smallMulTo(this, num, out);
      } else if (len < 1024) {
        res = bigMulTo(this, num, out);
      } else {
        res = jumboMulTo(this, num, out);
      }
      return res;
    };
    function FFTM(x3, y3) {
      this.x = x3;
      this.y = y3;
    }
    FFTM.prototype.makeRBT = function makeRBT(N2) {
      var t = new Array(N2);
      var l2 = BN2.prototype._countBits(N2) - 1;
      for (var i3 = 0; i3 < N2; i3++) {
        t[i3] = this.revBin(i3, l2, N2);
      }
      return t;
    };
    FFTM.prototype.revBin = function revBin(x3, l2, N2) {
      if (x3 === 0 || x3 === N2 - 1) return x3;
      var rb = 0;
      for (var i3 = 0; i3 < l2; i3++) {
        rb |= (x3 & 1) << l2 - i3 - 1;
        x3 >>= 1;
      }
      return rb;
    };
    FFTM.prototype.permute = function permute(rbt, rws, iws, rtws, itws, N2) {
      for (var i3 = 0; i3 < N2; i3++) {
        rtws[i3] = rws[rbt[i3]];
        itws[i3] = iws[rbt[i3]];
      }
    };
    FFTM.prototype.transform = function transform(rws, iws, rtws, itws, N2, rbt) {
      this.permute(rbt, rws, iws, rtws, itws, N2);
      for (var s2 = 1; s2 < N2; s2 <<= 1) {
        var l2 = s2 << 1;
        var rtwdf = Math.cos(2 * Math.PI / l2);
        var itwdf = Math.sin(2 * Math.PI / l2);
        for (var p3 = 0; p3 < N2; p3 += l2) {
          var rtwdf_ = rtwdf;
          var itwdf_ = itwdf;
          for (var j2 = 0; j2 < s2; j2++) {
            var re2 = rtws[p3 + j2];
            var ie2 = itws[p3 + j2];
            var ro2 = rtws[p3 + j2 + s2];
            var io2 = itws[p3 + j2 + s2];
            var rx = rtwdf_ * ro2 - itwdf_ * io2;
            io2 = rtwdf_ * io2 + itwdf_ * ro2;
            ro2 = rx;
            rtws[p3 + j2] = re2 + ro2;
            itws[p3 + j2] = ie2 + io2;
            rtws[p3 + j2 + s2] = re2 - ro2;
            itws[p3 + j2 + s2] = ie2 - io2;
            if (j2 !== l2) {
              rx = rtwdf * rtwdf_ - itwdf * itwdf_;
              itwdf_ = rtwdf * itwdf_ + itwdf * rtwdf_;
              rtwdf_ = rx;
            }
          }
        }
      }
    };
    FFTM.prototype.guessLen13b = function guessLen13b(n4, m2) {
      var N2 = Math.max(m2, n4) | 1;
      var odd = N2 & 1;
      var i3 = 0;
      for (N2 = N2 / 2 | 0; N2; N2 = N2 >>> 1) {
        i3++;
      }
      return 1 << i3 + 1 + odd;
    };
    FFTM.prototype.conjugate = function conjugate(rws, iws, N2) {
      if (N2 <= 1) return;
      for (var i3 = 0; i3 < N2 / 2; i3++) {
        var t = rws[i3];
        rws[i3] = rws[N2 - i3 - 1];
        rws[N2 - i3 - 1] = t;
        t = iws[i3];
        iws[i3] = -iws[N2 - i3 - 1];
        iws[N2 - i3 - 1] = -t;
      }
    };
    FFTM.prototype.normalize13b = function normalize13b(ws2, N2) {
      var carry = 0;
      for (var i3 = 0; i3 < N2 / 2; i3++) {
        var w2 = Math.round(ws2[2 * i3 + 1] / N2) * 8192 + Math.round(ws2[2 * i3] / N2) + carry;
        ws2[i3] = w2 & 67108863;
        if (w2 < 67108864) {
          carry = 0;
        } else {
          carry = w2 / 67108864 | 0;
        }
      }
      return ws2;
    };
    FFTM.prototype.convert13b = function convert13b(ws2, len, rws, N2) {
      var carry = 0;
      for (var i3 = 0; i3 < len; i3++) {
        carry = carry + (ws2[i3] | 0);
        rws[2 * i3] = carry & 8191;
        carry = carry >>> 13;
        rws[2 * i3 + 1] = carry & 8191;
        carry = carry >>> 13;
      }
      for (i3 = 2 * len; i3 < N2; ++i3) {
        rws[i3] = 0;
      }
      assert2(carry === 0);
      assert2((carry & ~8191) === 0);
    };
    FFTM.prototype.stub = function stub(N2) {
      var ph = new Array(N2);
      for (var i3 = 0; i3 < N2; i3++) {
        ph[i3] = 0;
      }
      return ph;
    };
    FFTM.prototype.mulp = function mulp(x3, y3, out) {
      var N2 = 2 * this.guessLen13b(x3.length, y3.length);
      var rbt = this.makeRBT(N2);
      var _3 = this.stub(N2);
      var rws = new Array(N2);
      var rwst = new Array(N2);
      var iwst = new Array(N2);
      var nrws = new Array(N2);
      var nrwst = new Array(N2);
      var niwst = new Array(N2);
      var rmws = out.words;
      rmws.length = N2;
      this.convert13b(x3.words, x3.length, rws, N2);
      this.convert13b(y3.words, y3.length, nrws, N2);
      this.transform(rws, _3, rwst, iwst, N2, rbt);
      this.transform(nrws, _3, nrwst, niwst, N2, rbt);
      for (var i3 = 0; i3 < N2; i3++) {
        var rx = rwst[i3] * nrwst[i3] - iwst[i3] * niwst[i3];
        iwst[i3] = rwst[i3] * niwst[i3] + iwst[i3] * nrwst[i3];
        rwst[i3] = rx;
      }
      this.conjugate(rwst, iwst, N2);
      this.transform(rwst, iwst, rmws, _3, N2, rbt);
      this.conjugate(rmws, _3, N2);
      this.normalize13b(rmws, N2);
      out.negative = x3.negative ^ y3.negative;
      out.length = x3.length + y3.length;
      return out.strip();
    };
    BN2.prototype.mul = function mul7(num) {
      var out = new BN2(null);
      out.words = new Array(this.length + num.length);
      return this.mulTo(num, out);
    };
    BN2.prototype.mulf = function mulf(num) {
      var out = new BN2(null);
      out.words = new Array(this.length + num.length);
      return jumboMulTo(this, num, out);
    };
    BN2.prototype.imul = function imul(num) {
      return this.clone().mulTo(num, this);
    };
    BN2.prototype.imuln = function imuln(num) {
      assert2(typeof num === "number");
      assert2(num < 67108864);
      var carry = 0;
      for (var i3 = 0; i3 < this.length; i3++) {
        var w2 = (this.words[i3] | 0) * num;
        var lo2 = (w2 & 67108863) + (carry & 67108863);
        carry >>= 26;
        carry += w2 / 67108864 | 0;
        carry += lo2 >>> 26;
        this.words[i3] = lo2 & 67108863;
      }
      if (carry !== 0) {
        this.words[i3] = carry;
        this.length++;
      }
      return this;
    };
    BN2.prototype.muln = function muln(num) {
      return this.clone().imuln(num);
    };
    BN2.prototype.sqr = function sqr() {
      return this.mul(this);
    };
    BN2.prototype.isqr = function isqr() {
      return this.imul(this.clone());
    };
    BN2.prototype.pow = function pow(num) {
      var w2 = toBitArray(num);
      if (w2.length === 0) return new BN2(1);
      var res = this;
      for (var i3 = 0; i3 < w2.length; i3++, res = res.sqr()) {
        if (w2[i3] !== 0) break;
      }
      if (++i3 < w2.length) {
        for (var q2 = res.sqr(); i3 < w2.length; i3++, q2 = q2.sqr()) {
          if (w2[i3] === 0) continue;
          res = res.mul(q2);
        }
      }
      return res;
    };
    BN2.prototype.iushln = function iushln(bits) {
      assert2(typeof bits === "number" && bits >= 0);
      var r2 = bits % 26;
      var s2 = (bits - r2) / 26;
      var carryMask = 67108863 >>> 26 - r2 << 26 - r2;
      var i3;
      if (r2 !== 0) {
        var carry = 0;
        for (i3 = 0; i3 < this.length; i3++) {
          var newCarry = this.words[i3] & carryMask;
          var c2 = (this.words[i3] | 0) - newCarry << r2;
          this.words[i3] = c2 | carry;
          carry = newCarry >>> 26 - r2;
        }
        if (carry) {
          this.words[i3] = carry;
          this.length++;
        }
      }
      if (s2 !== 0) {
        for (i3 = this.length - 1; i3 >= 0; i3--) {
          this.words[i3 + s2] = this.words[i3];
        }
        for (i3 = 0; i3 < s2; i3++) {
          this.words[i3] = 0;
        }
        this.length += s2;
      }
      return this.strip();
    };
    BN2.prototype.ishln = function ishln(bits) {
      assert2(this.negative === 0);
      return this.iushln(bits);
    };
    BN2.prototype.iushrn = function iushrn(bits, hint, extended) {
      assert2(typeof bits === "number" && bits >= 0);
      var h4;
      if (hint) {
        h4 = (hint - hint % 26) / 26;
      } else {
        h4 = 0;
      }
      var r2 = bits % 26;
      var s2 = Math.min((bits - r2) / 26, this.length);
      var mask = 67108863 ^ 67108863 >>> r2 << r2;
      var maskedWords = extended;
      h4 -= s2;
      h4 = Math.max(0, h4);
      if (maskedWords) {
        for (var i3 = 0; i3 < s2; i3++) {
          maskedWords.words[i3] = this.words[i3];
        }
        maskedWords.length = s2;
      }
      if (s2 === 0) ;
      else if (this.length > s2) {
        this.length -= s2;
        for (i3 = 0; i3 < this.length; i3++) {
          this.words[i3] = this.words[i3 + s2];
        }
      } else {
        this.words[0] = 0;
        this.length = 1;
      }
      var carry = 0;
      for (i3 = this.length - 1; i3 >= 0 && (carry !== 0 || i3 >= h4); i3--) {
        var word = this.words[i3] | 0;
        this.words[i3] = carry << 26 - r2 | word >>> r2;
        carry = word & mask;
      }
      if (maskedWords && carry !== 0) {
        maskedWords.words[maskedWords.length++] = carry;
      }
      if (this.length === 0) {
        this.words[0] = 0;
        this.length = 1;
      }
      return this.strip();
    };
    BN2.prototype.ishrn = function ishrn(bits, hint, extended) {
      assert2(this.negative === 0);
      return this.iushrn(bits, hint, extended);
    };
    BN2.prototype.shln = function shln(bits) {
      return this.clone().ishln(bits);
    };
    BN2.prototype.ushln = function ushln(bits) {
      return this.clone().iushln(bits);
    };
    BN2.prototype.shrn = function shrn(bits) {
      return this.clone().ishrn(bits);
    };
    BN2.prototype.ushrn = function ushrn(bits) {
      return this.clone().iushrn(bits);
    };
    BN2.prototype.testn = function testn(bit) {
      assert2(typeof bit === "number" && bit >= 0);
      var r2 = bit % 26;
      var s2 = (bit - r2) / 26;
      var q2 = 1 << r2;
      if (this.length <= s2) return false;
      var w2 = this.words[s2];
      return !!(w2 & q2);
    };
    BN2.prototype.imaskn = function imaskn(bits) {
      assert2(typeof bits === "number" && bits >= 0);
      var r2 = bits % 26;
      var s2 = (bits - r2) / 26;
      assert2(this.negative === 0, "imaskn works only with positive numbers");
      if (this.length <= s2) {
        return this;
      }
      if (r2 !== 0) {
        s2++;
      }
      this.length = Math.min(s2, this.length);
      if (r2 !== 0) {
        var mask = 67108863 ^ 67108863 >>> r2 << r2;
        this.words[this.length - 1] &= mask;
      }
      return this.strip();
    };
    BN2.prototype.maskn = function maskn(bits) {
      return this.clone().imaskn(bits);
    };
    BN2.prototype.iaddn = function iaddn(num) {
      assert2(typeof num === "number");
      assert2(num < 67108864);
      if (num < 0) return this.isubn(-num);
      if (this.negative !== 0) {
        if (this.length === 1 && (this.words[0] | 0) < num) {
          this.words[0] = num - (this.words[0] | 0);
          this.negative = 0;
          return this;
        }
        this.negative = 0;
        this.isubn(num);
        this.negative = 1;
        return this;
      }
      return this._iaddn(num);
    };
    BN2.prototype._iaddn = function _iaddn(num) {
      this.words[0] += num;
      for (var i3 = 0; i3 < this.length && this.words[i3] >= 67108864; i3++) {
        this.words[i3] -= 67108864;
        if (i3 === this.length - 1) {
          this.words[i3 + 1] = 1;
        } else {
          this.words[i3 + 1]++;
        }
      }
      this.length = Math.max(this.length, i3 + 1);
      return this;
    };
    BN2.prototype.isubn = function isubn(num) {
      assert2(typeof num === "number");
      assert2(num < 67108864);
      if (num < 0) return this.iaddn(-num);
      if (this.negative !== 0) {
        this.negative = 0;
        this.iaddn(num);
        this.negative = 1;
        return this;
      }
      this.words[0] -= num;
      if (this.length === 1 && this.words[0] < 0) {
        this.words[0] = -this.words[0];
        this.negative = 1;
      } else {
        for (var i3 = 0; i3 < this.length && this.words[i3] < 0; i3++) {
          this.words[i3] += 67108864;
          this.words[i3 + 1] -= 1;
        }
      }
      return this.strip();
    };
    BN2.prototype.addn = function addn(num) {
      return this.clone().iaddn(num);
    };
    BN2.prototype.subn = function subn(num) {
      return this.clone().isubn(num);
    };
    BN2.prototype.iabs = function iabs() {
      this.negative = 0;
      return this;
    };
    BN2.prototype.abs = function abs() {
      return this.clone().iabs();
    };
    BN2.prototype._ishlnsubmul = function _ishlnsubmul(num, mul7, shift) {
      var len = num.length + shift;
      var i3;
      this._expand(len);
      var w2;
      var carry = 0;
      for (i3 = 0; i3 < num.length; i3++) {
        w2 = (this.words[i3 + shift] | 0) + carry;
        var right = (num.words[i3] | 0) * mul7;
        w2 -= right & 67108863;
        carry = (w2 >> 26) - (right / 67108864 | 0);
        this.words[i3 + shift] = w2 & 67108863;
      }
      for (; i3 < this.length - shift; i3++) {
        w2 = (this.words[i3 + shift] | 0) + carry;
        carry = w2 >> 26;
        this.words[i3 + shift] = w2 & 67108863;
      }
      if (carry === 0) return this.strip();
      assert2(carry === -1);
      carry = 0;
      for (i3 = 0; i3 < this.length; i3++) {
        w2 = -(this.words[i3] | 0) + carry;
        carry = w2 >> 26;
        this.words[i3] = w2 & 67108863;
      }
      this.negative = 1;
      return this.strip();
    };
    BN2.prototype._wordDiv = function _wordDiv(num, mode) {
      var shift = this.length - num.length;
      var a3 = this.clone();
      var b2 = num;
      var bhi = b2.words[b2.length - 1] | 0;
      var bhiBits = this._countBits(bhi);
      shift = 26 - bhiBits;
      if (shift !== 0) {
        b2 = b2.ushln(shift);
        a3.iushln(shift);
        bhi = b2.words[b2.length - 1] | 0;
      }
      var m2 = a3.length - b2.length;
      var q2;
      if (mode !== "mod") {
        q2 = new BN2(null);
        q2.length = m2 + 1;
        q2.words = new Array(q2.length);
        for (var i3 = 0; i3 < q2.length; i3++) {
          q2.words[i3] = 0;
        }
      }
      var diff = a3.clone()._ishlnsubmul(b2, 1, m2);
      if (diff.negative === 0) {
        a3 = diff;
        if (q2) {
          q2.words[m2] = 1;
        }
      }
      for (var j2 = m2 - 1; j2 >= 0; j2--) {
        var qj = (a3.words[b2.length + j2] | 0) * 67108864 + (a3.words[b2.length + j2 - 1] | 0);
        qj = Math.min(qj / bhi | 0, 67108863);
        a3._ishlnsubmul(b2, qj, j2);
        while (a3.negative !== 0) {
          qj--;
          a3.negative = 0;
          a3._ishlnsubmul(b2, 1, j2);
          if (!a3.isZero()) {
            a3.negative ^= 1;
          }
        }
        if (q2) {
          q2.words[j2] = qj;
        }
      }
      if (q2) {
        q2.strip();
      }
      a3.strip();
      if (mode !== "div" && shift !== 0) {
        a3.iushrn(shift);
      }
      return {
        div: q2 || null,
        mod: a3
      };
    };
    BN2.prototype.divmod = function divmod(num, mode, positive) {
      assert2(!num.isZero());
      if (this.isZero()) {
        return {
          div: new BN2(0),
          mod: new BN2(0)
        };
      }
      var div, mod, res;
      if (this.negative !== 0 && num.negative === 0) {
        res = this.neg().divmod(num, mode);
        if (mode !== "mod") {
          div = res.div.neg();
        }
        if (mode !== "div") {
          mod = res.mod.neg();
          if (positive && mod.negative !== 0) {
            mod.iadd(num);
          }
        }
        return {
          div,
          mod
        };
      }
      if (this.negative === 0 && num.negative !== 0) {
        res = this.divmod(num.neg(), mode);
        if (mode !== "mod") {
          div = res.div.neg();
        }
        return {
          div,
          mod: res.mod
        };
      }
      if ((this.negative & num.negative) !== 0) {
        res = this.neg().divmod(num.neg(), mode);
        if (mode !== "div") {
          mod = res.mod.neg();
          if (positive && mod.negative !== 0) {
            mod.isub(num);
          }
        }
        return {
          div: res.div,
          mod
        };
      }
      if (num.length > this.length || this.cmp(num) < 0) {
        return {
          div: new BN2(0),
          mod: this
        };
      }
      if (num.length === 1) {
        if (mode === "div") {
          return {
            div: this.divn(num.words[0]),
            mod: null
          };
        }
        if (mode === "mod") {
          return {
            div: null,
            mod: new BN2(this.modn(num.words[0]))
          };
        }
        return {
          div: this.divn(num.words[0]),
          mod: new BN2(this.modn(num.words[0]))
        };
      }
      return this._wordDiv(num, mode);
    };
    BN2.prototype.div = function div(num) {
      return this.divmod(num, "div", false).div;
    };
    BN2.prototype.mod = function mod(num) {
      return this.divmod(num, "mod", false).mod;
    };
    BN2.prototype.umod = function umod(num) {
      return this.divmod(num, "mod", true).mod;
    };
    BN2.prototype.divRound = function divRound(num) {
      var dm = this.divmod(num);
      if (dm.mod.isZero()) return dm.div;
      var mod = dm.div.negative !== 0 ? dm.mod.isub(num) : dm.mod;
      var half = num.ushrn(1);
      var r2 = num.andln(1);
      var cmp = mod.cmp(half);
      if (cmp < 0 || r2 === 1 && cmp === 0) return dm.div;
      return dm.div.negative !== 0 ? dm.div.isubn(1) : dm.div.iaddn(1);
    };
    BN2.prototype.modn = function modn(num) {
      assert2(num <= 67108863);
      var p3 = (1 << 26) % num;
      var acc = 0;
      for (var i3 = this.length - 1; i3 >= 0; i3--) {
        acc = (p3 * acc + (this.words[i3] | 0)) % num;
      }
      return acc;
    };
    BN2.prototype.idivn = function idivn(num) {
      assert2(num <= 67108863);
      var carry = 0;
      for (var i3 = this.length - 1; i3 >= 0; i3--) {
        var w2 = (this.words[i3] | 0) + carry * 67108864;
        this.words[i3] = w2 / num | 0;
        carry = w2 % num;
      }
      return this.strip();
    };
    BN2.prototype.divn = function divn(num) {
      return this.clone().idivn(num);
    };
    BN2.prototype.egcd = function egcd(p3) {
      assert2(p3.negative === 0);
      assert2(!p3.isZero());
      var x3 = this;
      var y3 = p3.clone();
      if (x3.negative !== 0) {
        x3 = x3.umod(p3);
      } else {
        x3 = x3.clone();
      }
      var A2 = new BN2(1);
      var B3 = new BN2(0);
      var C3 = new BN2(0);
      var D2 = new BN2(1);
      var g3 = 0;
      while (x3.isEven() && y3.isEven()) {
        x3.iushrn(1);
        y3.iushrn(1);
        ++g3;
      }
      var yp = y3.clone();
      var xp = x3.clone();
      while (!x3.isZero()) {
        for (var i3 = 0, im = 1; (x3.words[0] & im) === 0 && i3 < 26; ++i3, im <<= 1) ;
        if (i3 > 0) {
          x3.iushrn(i3);
          while (i3-- > 0) {
            if (A2.isOdd() || B3.isOdd()) {
              A2.iadd(yp);
              B3.isub(xp);
            }
            A2.iushrn(1);
            B3.iushrn(1);
          }
        }
        for (var j2 = 0, jm = 1; (y3.words[0] & jm) === 0 && j2 < 26; ++j2, jm <<= 1) ;
        if (j2 > 0) {
          y3.iushrn(j2);
          while (j2-- > 0) {
            if (C3.isOdd() || D2.isOdd()) {
              C3.iadd(yp);
              D2.isub(xp);
            }
            C3.iushrn(1);
            D2.iushrn(1);
          }
        }
        if (x3.cmp(y3) >= 0) {
          x3.isub(y3);
          A2.isub(C3);
          B3.isub(D2);
        } else {
          y3.isub(x3);
          C3.isub(A2);
          D2.isub(B3);
        }
      }
      return {
        a: C3,
        b: D2,
        gcd: y3.iushln(g3)
      };
    };
    BN2.prototype._invmp = function _invmp(p3) {
      assert2(p3.negative === 0);
      assert2(!p3.isZero());
      var a3 = this;
      var b2 = p3.clone();
      if (a3.negative !== 0) {
        a3 = a3.umod(p3);
      } else {
        a3 = a3.clone();
      }
      var x1 = new BN2(1);
      var x22 = new BN2(0);
      var delta = b2.clone();
      while (a3.cmpn(1) > 0 && b2.cmpn(1) > 0) {
        for (var i3 = 0, im = 1; (a3.words[0] & im) === 0 && i3 < 26; ++i3, im <<= 1) ;
        if (i3 > 0) {
          a3.iushrn(i3);
          while (i3-- > 0) {
            if (x1.isOdd()) {
              x1.iadd(delta);
            }
            x1.iushrn(1);
          }
        }
        for (var j2 = 0, jm = 1; (b2.words[0] & jm) === 0 && j2 < 26; ++j2, jm <<= 1) ;
        if (j2 > 0) {
          b2.iushrn(j2);
          while (j2-- > 0) {
            if (x22.isOdd()) {
              x22.iadd(delta);
            }
            x22.iushrn(1);
          }
        }
        if (a3.cmp(b2) >= 0) {
          a3.isub(b2);
          x1.isub(x22);
        } else {
          b2.isub(a3);
          x22.isub(x1);
        }
      }
      var res;
      if (a3.cmpn(1) === 0) {
        res = x1;
      } else {
        res = x22;
      }
      if (res.cmpn(0) < 0) {
        res.iadd(p3);
      }
      return res;
    };
    BN2.prototype.gcd = function gcd(num) {
      if (this.isZero()) return num.abs();
      if (num.isZero()) return this.abs();
      var a3 = this.clone();
      var b2 = num.clone();
      a3.negative = 0;
      b2.negative = 0;
      for (var shift = 0; a3.isEven() && b2.isEven(); shift++) {
        a3.iushrn(1);
        b2.iushrn(1);
      }
      do {
        while (a3.isEven()) {
          a3.iushrn(1);
        }
        while (b2.isEven()) {
          b2.iushrn(1);
        }
        var r2 = a3.cmp(b2);
        if (r2 < 0) {
          var t = a3;
          a3 = b2;
          b2 = t;
        } else if (r2 === 0 || b2.cmpn(1) === 0) {
          break;
        }
        a3.isub(b2);
      } while (true);
      return b2.iushln(shift);
    };
    BN2.prototype.invm = function invm(num) {
      return this.egcd(num).a.umod(num);
    };
    BN2.prototype.isEven = function isEven() {
      return (this.words[0] & 1) === 0;
    };
    BN2.prototype.isOdd = function isOdd() {
      return (this.words[0] & 1) === 1;
    };
    BN2.prototype.andln = function andln(num) {
      return this.words[0] & num;
    };
    BN2.prototype.bincn = function bincn(bit) {
      assert2(typeof bit === "number");
      var r2 = bit % 26;
      var s2 = (bit - r2) / 26;
      var q2 = 1 << r2;
      if (this.length <= s2) {
        this._expand(s2 + 1);
        this.words[s2] |= q2;
        return this;
      }
      var carry = q2;
      for (var i3 = s2; carry !== 0 && i3 < this.length; i3++) {
        var w2 = this.words[i3] | 0;
        w2 += carry;
        carry = w2 >>> 26;
        w2 &= 67108863;
        this.words[i3] = w2;
      }
      if (carry !== 0) {
        this.words[i3] = carry;
        this.length++;
      }
      return this;
    };
    BN2.prototype.isZero = function isZero() {
      return this.length === 1 && this.words[0] === 0;
    };
    BN2.prototype.cmpn = function cmpn(num) {
      var negative = num < 0;
      if (this.negative !== 0 && !negative) return -1;
      if (this.negative === 0 && negative) return 1;
      this.strip();
      var res;
      if (this.length > 1) {
        res = 1;
      } else {
        if (negative) {
          num = -num;
        }
        assert2(num <= 67108863, "Number is too big");
        var w2 = this.words[0] | 0;
        res = w2 === num ? 0 : w2 < num ? -1 : 1;
      }
      if (this.negative !== 0) return -res | 0;
      return res;
    };
    BN2.prototype.cmp = function cmp(num) {
      if (this.negative !== 0 && num.negative === 0) return -1;
      if (this.negative === 0 && num.negative !== 0) return 1;
      var res = this.ucmp(num);
      if (this.negative !== 0) return -res | 0;
      return res;
    };
    BN2.prototype.ucmp = function ucmp(num) {
      if (this.length > num.length) return 1;
      if (this.length < num.length) return -1;
      var res = 0;
      for (var i3 = this.length - 1; i3 >= 0; i3--) {
        var a3 = this.words[i3] | 0;
        var b2 = num.words[i3] | 0;
        if (a3 === b2) continue;
        if (a3 < b2) {
          res = -1;
        } else if (a3 > b2) {
          res = 1;
        }
        break;
      }
      return res;
    };
    BN2.prototype.gtn = function gtn(num) {
      return this.cmpn(num) === 1;
    };
    BN2.prototype.gt = function gt2(num) {
      return this.cmp(num) === 1;
    };
    BN2.prototype.gten = function gten(num) {
      return this.cmpn(num) >= 0;
    };
    BN2.prototype.gte = function gte(num) {
      return this.cmp(num) >= 0;
    };
    BN2.prototype.ltn = function ltn(num) {
      return this.cmpn(num) === -1;
    };
    BN2.prototype.lt = function lt3(num) {
      return this.cmp(num) === -1;
    };
    BN2.prototype.lten = function lten(num) {
      return this.cmpn(num) <= 0;
    };
    BN2.prototype.lte = function lte(num) {
      return this.cmp(num) <= 0;
    };
    BN2.prototype.eqn = function eqn(num) {
      return this.cmpn(num) === 0;
    };
    BN2.prototype.eq = function eq9(num) {
      return this.cmp(num) === 0;
    };
    BN2.red = function red(num) {
      return new Red(num);
    };
    BN2.prototype.toRed = function toRed(ctx) {
      assert2(!this.red, "Already a number in reduction context");
      assert2(this.negative === 0, "red works only with positives");
      return ctx.convertTo(this)._forceRed(ctx);
    };
    BN2.prototype.fromRed = function fromRed() {
      assert2(this.red, "fromRed works only with numbers in reduction context");
      return this.red.convertFrom(this);
    };
    BN2.prototype._forceRed = function _forceRed(ctx) {
      this.red = ctx;
      return this;
    };
    BN2.prototype.forceRed = function forceRed(ctx) {
      assert2(!this.red, "Already a number in reduction context");
      return this._forceRed(ctx);
    };
    BN2.prototype.redAdd = function redAdd(num) {
      assert2(this.red, "redAdd works only with red numbers");
      return this.red.add(this, num);
    };
    BN2.prototype.redIAdd = function redIAdd(num) {
      assert2(this.red, "redIAdd works only with red numbers");
      return this.red.iadd(this, num);
    };
    BN2.prototype.redSub = function redSub(num) {
      assert2(this.red, "redSub works only with red numbers");
      return this.red.sub(this, num);
    };
    BN2.prototype.redISub = function redISub(num) {
      assert2(this.red, "redISub works only with red numbers");
      return this.red.isub(this, num);
    };
    BN2.prototype.redShl = function redShl(num) {
      assert2(this.red, "redShl works only with red numbers");
      return this.red.shl(this, num);
    };
    BN2.prototype.redMul = function redMul(num) {
      assert2(this.red, "redMul works only with red numbers");
      this.red._verify2(this, num);
      return this.red.mul(this, num);
    };
    BN2.prototype.redIMul = function redIMul(num) {
      assert2(this.red, "redMul works only with red numbers");
      this.red._verify2(this, num);
      return this.red.imul(this, num);
    };
    BN2.prototype.redSqr = function redSqr() {
      assert2(this.red, "redSqr works only with red numbers");
      this.red._verify1(this);
      return this.red.sqr(this);
    };
    BN2.prototype.redISqr = function redISqr() {
      assert2(this.red, "redISqr works only with red numbers");
      this.red._verify1(this);
      return this.red.isqr(this);
    };
    BN2.prototype.redSqrt = function redSqrt() {
      assert2(this.red, "redSqrt works only with red numbers");
      this.red._verify1(this);
      return this.red.sqrt(this);
    };
    BN2.prototype.redInvm = function redInvm() {
      assert2(this.red, "redInvm works only with red numbers");
      this.red._verify1(this);
      return this.red.invm(this);
    };
    BN2.prototype.redNeg = function redNeg() {
      assert2(this.red, "redNeg works only with red numbers");
      this.red._verify1(this);
      return this.red.neg(this);
    };
    BN2.prototype.redPow = function redPow(num) {
      assert2(this.red && !num.red, "redPow(normalNum)");
      this.red._verify1(this);
      return this.red.pow(this, num);
    };
    var primes = {
      k256: null,
      p224: null,
      p192: null,
      p25519: null
    };
    function MPrime(name2, p3) {
      this.name = name2;
      this.p = new BN2(p3, 16);
      this.n = this.p.bitLength();
      this.k = new BN2(1).iushln(this.n).isub(this.p);
      this.tmp = this._tmp();
    }
    MPrime.prototype._tmp = function _tmp() {
      var tmp = new BN2(null);
      tmp.words = new Array(Math.ceil(this.n / 13));
      return tmp;
    };
    MPrime.prototype.ireduce = function ireduce(num) {
      var r2 = num;
      var rlen;
      do {
        this.split(r2, this.tmp);
        r2 = this.imulK(r2);
        r2 = r2.iadd(this.tmp);
        rlen = r2.bitLength();
      } while (rlen > this.n);
      var cmp = rlen < this.n ? -1 : r2.ucmp(this.p);
      if (cmp === 0) {
        r2.words[0] = 0;
        r2.length = 1;
      } else if (cmp > 0) {
        r2.isub(this.p);
      } else {
        if (r2.strip !== void 0) {
          r2.strip();
        } else {
          r2._strip();
        }
      }
      return r2;
    };
    MPrime.prototype.split = function split(input, out) {
      input.iushrn(this.n, 0, out);
    };
    MPrime.prototype.imulK = function imulK(num) {
      return num.imul(this.k);
    };
    function K256() {
      MPrime.call(
        this,
        "k256",
        "ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff fffffffe fffffc2f"
      );
    }
    inherits2(K256, MPrime);
    K256.prototype.split = function split(input, output) {
      var mask = 4194303;
      var outLen = Math.min(input.length, 9);
      for (var i3 = 0; i3 < outLen; i3++) {
        output.words[i3] = input.words[i3];
      }
      output.length = outLen;
      if (input.length <= 9) {
        input.words[0] = 0;
        input.length = 1;
        return;
      }
      var prev = input.words[9];
      output.words[output.length++] = prev & mask;
      for (i3 = 10; i3 < input.length; i3++) {
        var next = input.words[i3] | 0;
        input.words[i3 - 10] = (next & mask) << 4 | prev >>> 22;
        prev = next;
      }
      prev >>>= 22;
      input.words[i3 - 10] = prev;
      if (prev === 0 && input.length > 10) {
        input.length -= 10;
      } else {
        input.length -= 9;
      }
    };
    K256.prototype.imulK = function imulK(num) {
      num.words[num.length] = 0;
      num.words[num.length + 1] = 0;
      num.length += 2;
      var lo2 = 0;
      for (var i3 = 0; i3 < num.length; i3++) {
        var w2 = num.words[i3] | 0;
        lo2 += w2 * 977;
        num.words[i3] = lo2 & 67108863;
        lo2 = w2 * 64 + (lo2 / 67108864 | 0);
      }
      if (num.words[num.length - 1] === 0) {
        num.length--;
        if (num.words[num.length - 1] === 0) {
          num.length--;
        }
      }
      return num;
    };
    function P224() {
      MPrime.call(
        this,
        "p224",
        "ffffffff ffffffff ffffffff ffffffff 00000000 00000000 00000001"
      );
    }
    inherits2(P224, MPrime);
    function P192() {
      MPrime.call(
        this,
        "p192",
        "ffffffff ffffffff ffffffff fffffffe ffffffff ffffffff"
      );
    }
    inherits2(P192, MPrime);
    function P25519() {
      MPrime.call(
        this,
        "25519",
        "7fffffffffffffff ffffffffffffffff ffffffffffffffff ffffffffffffffed"
      );
    }
    inherits2(P25519, MPrime);
    P25519.prototype.imulK = function imulK(num) {
      var carry = 0;
      for (var i3 = 0; i3 < num.length; i3++) {
        var hi2 = (num.words[i3] | 0) * 19 + carry;
        var lo2 = hi2 & 67108863;
        hi2 >>>= 26;
        num.words[i3] = lo2;
        carry = hi2;
      }
      if (carry !== 0) {
        num.words[num.length++] = carry;
      }
      return num;
    };
    BN2._prime = function prime(name2) {
      if (primes[name2]) return primes[name2];
      var prime2;
      if (name2 === "k256") {
        prime2 = new K256();
      } else if (name2 === "p224") {
        prime2 = new P224();
      } else if (name2 === "p192") {
        prime2 = new P192();
      } else if (name2 === "p25519") {
        prime2 = new P25519();
      } else {
        throw new Error("Unknown prime " + name2);
      }
      primes[name2] = prime2;
      return prime2;
    };
    function Red(m2) {
      if (typeof m2 === "string") {
        var prime = BN2._prime(m2);
        this.m = prime.p;
        this.prime = prime;
      } else {
        assert2(m2.gtn(1), "modulus must be greater than 1");
        this.m = m2;
        this.prime = null;
      }
    }
    Red.prototype._verify1 = function _verify1(a3) {
      assert2(a3.negative === 0, "red works only with positives");
      assert2(a3.red, "red works only with red numbers");
    };
    Red.prototype._verify2 = function _verify2(a3, b2) {
      assert2((a3.negative | b2.negative) === 0, "red works only with positives");
      assert2(
        a3.red && a3.red === b2.red,
        "red works only with red numbers"
      );
    };
    Red.prototype.imod = function imod(a3) {
      if (this.prime) return this.prime.ireduce(a3)._forceRed(this);
      return a3.umod(this.m)._forceRed(this);
    };
    Red.prototype.neg = function neg6(a3) {
      if (a3.isZero()) {
        return a3.clone();
      }
      return this.m.sub(a3)._forceRed(this);
    };
    Red.prototype.add = function add7(a3, b2) {
      this._verify2(a3, b2);
      var res = a3.add(b2);
      if (res.cmp(this.m) >= 0) {
        res.isub(this.m);
      }
      return res._forceRed(this);
    };
    Red.prototype.iadd = function iadd(a3, b2) {
      this._verify2(a3, b2);
      var res = a3.iadd(b2);
      if (res.cmp(this.m) >= 0) {
        res.isub(this.m);
      }
      return res;
    };
    Red.prototype.sub = function sub(a3, b2) {
      this._verify2(a3, b2);
      var res = a3.sub(b2);
      if (res.cmpn(0) < 0) {
        res.iadd(this.m);
      }
      return res._forceRed(this);
    };
    Red.prototype.isub = function isub(a3, b2) {
      this._verify2(a3, b2);
      var res = a3.isub(b2);
      if (res.cmpn(0) < 0) {
        res.iadd(this.m);
      }
      return res;
    };
    Red.prototype.shl = function shl(a3, num) {
      this._verify1(a3);
      return this.imod(a3.ushln(num));
    };
    Red.prototype.imul = function imul(a3, b2) {
      this._verify2(a3, b2);
      return this.imod(a3.imul(b2));
    };
    Red.prototype.mul = function mul7(a3, b2) {
      this._verify2(a3, b2);
      return this.imod(a3.mul(b2));
    };
    Red.prototype.isqr = function isqr(a3) {
      return this.imul(a3, a3.clone());
    };
    Red.prototype.sqr = function sqr(a3) {
      return this.mul(a3, a3);
    };
    Red.prototype.sqrt = function sqrt(a3) {
      if (a3.isZero()) return a3.clone();
      var mod3 = this.m.andln(3);
      assert2(mod3 % 2 === 1);
      if (mod3 === 3) {
        var pow = this.m.add(new BN2(1)).iushrn(2);
        return this.pow(a3, pow);
      }
      var q2 = this.m.subn(1);
      var s2 = 0;
      while (!q2.isZero() && q2.andln(1) === 0) {
        s2++;
        q2.iushrn(1);
      }
      assert2(!q2.isZero());
      var one = new BN2(1).toRed(this);
      var nOne = one.redNeg();
      var lpow = this.m.subn(1).iushrn(1);
      var z2 = this.m.bitLength();
      z2 = new BN2(2 * z2 * z2).toRed(this);
      while (this.pow(z2, lpow).cmp(nOne) !== 0) {
        z2.redIAdd(nOne);
      }
      var c2 = this.pow(z2, q2);
      var r2 = this.pow(a3, q2.addn(1).iushrn(1));
      var t = this.pow(a3, q2);
      var m2 = s2;
      while (t.cmp(one) !== 0) {
        var tmp = t;
        for (var i3 = 0; tmp.cmp(one) !== 0; i3++) {
          tmp = tmp.redSqr();
        }
        assert2(i3 < m2);
        var b2 = this.pow(c2, new BN2(1).iushln(m2 - i3 - 1));
        r2 = r2.redMul(b2);
        c2 = b2.redSqr();
        t = t.redMul(c2);
        m2 = i3;
      }
      return r2;
    };
    Red.prototype.invm = function invm(a3) {
      var inv = a3._invmp(this.m);
      if (inv.negative !== 0) {
        inv.negative = 0;
        return this.imod(inv).redNeg();
      } else {
        return this.imod(inv);
      }
    };
    Red.prototype.pow = function pow(a3, num) {
      if (num.isZero()) return new BN2(1).toRed(this);
      if (num.cmpn(1) === 0) return a3.clone();
      var windowSize = 4;
      var wnd = new Array(1 << windowSize);
      wnd[0] = new BN2(1).toRed(this);
      wnd[1] = a3;
      for (var i3 = 2; i3 < wnd.length; i3++) {
        wnd[i3] = this.mul(wnd[i3 - 1], a3);
      }
      var res = wnd[0];
      var current = 0;
      var currentLen = 0;
      var start = num.bitLength() % 26;
      if (start === 0) {
        start = 26;
      }
      for (i3 = num.length - 1; i3 >= 0; i3--) {
        var word = num.words[i3];
        for (var j2 = start - 1; j2 >= 0; j2--) {
          var bit = word >> j2 & 1;
          if (res !== wnd[0]) {
            res = this.sqr(res);
          }
          if (bit === 0 && current === 0) {
            currentLen = 0;
            continue;
          }
          current <<= 1;
          current |= bit;
          currentLen++;
          if (currentLen !== windowSize && (i3 !== 0 || j2 !== 0)) continue;
          res = this.mul(res, wnd[current]);
          currentLen = 0;
          current = 0;
        }
        start = 26;
      }
      return res;
    };
    Red.prototype.convertTo = function convertTo(num) {
      var r2 = num.umod(this.m);
      return r2 === num ? r2.clone() : r2;
    };
    Red.prototype.convertFrom = function convertFrom(num) {
      var res = num.clone();
      res.red = null;
      return res;
    };
    BN2.mont = function mont2(num) {
      return new Mont(num);
    };
    function Mont(m2) {
      Red.call(this, m2);
      this.shift = this.m.bitLength();
      if (this.shift % 26 !== 0) {
        this.shift += 26 - this.shift % 26;
      }
      this.r = new BN2(1).iushln(this.shift);
      this.r2 = this.imod(this.r.sqr());
      this.rinv = this.r._invmp(this.m);
      this.minv = this.rinv.mul(this.r).isubn(1).div(this.m);
      this.minv = this.minv.umod(this.r);
      this.minv = this.r.sub(this.minv);
    }
    inherits2(Mont, Red);
    Mont.prototype.convertTo = function convertTo(num) {
      return this.imod(num.ushln(this.shift));
    };
    Mont.prototype.convertFrom = function convertFrom(num) {
      var r2 = this.imod(num.mul(this.rinv));
      r2.red = null;
      return r2;
    };
    Mont.prototype.imul = function imul(a3, b2) {
      if (a3.isZero() || b2.isZero()) {
        a3.words[0] = 0;
        a3.length = 1;
        return a3;
      }
      var t = a3.imul(b2);
      var c2 = t.maskn(this.shift).mul(this.minv).imaskn(this.shift).mul(this.m);
      var u2 = t.isub(c2).iushrn(this.shift);
      var res = u2;
      if (u2.cmp(this.m) >= 0) {
        res = u2.isub(this.m);
      } else if (u2.cmpn(0) < 0) {
        res = u2.iadd(this.m);
      }
      return res._forceRed(this);
    };
    Mont.prototype.mul = function mul7(a3, b2) {
      if (a3.isZero() || b2.isZero()) return new BN2(0)._forceRed(this);
      var t = a3.mul(b2);
      var c2 = t.maskn(this.shift).mul(this.minv).imaskn(this.shift).mul(this.m);
      var u2 = t.isub(c2).iushrn(this.shift);
      var res = u2;
      if (u2.cmp(this.m) >= 0) {
        res = u2.isub(this.m);
      } else if (u2.cmpn(0) < 0) {
        res = u2.iadd(this.m);
      }
      return res._forceRed(this);
    };
    Mont.prototype.invm = function invm(a3) {
      var res = this.imod(a3._invmp(this.m).mul(this.r2));
      return res._forceRed(this);
    };
  })(module, commonjsGlobal);
})(bn$2);
var bnExports = bn$2.exports;
(function(exports) {
  var utils2 = exports;
  var BN2 = bnExports;
  var minAssert = minimalisticAssert$1;
  var minUtils = utils$c;
  utils2.assert = minAssert;
  utils2.toArray = minUtils.toArray;
  utils2.zero2 = minUtils.zero2;
  utils2.toHex = minUtils.toHex;
  utils2.encode = minUtils.encode;
  function getNAF2(num, w2, bits) {
    var naf = new Array(Math.max(num.bitLength(), bits) + 1);
    var i3;
    for (i3 = 0; i3 < naf.length; i3 += 1) {
      naf[i3] = 0;
    }
    var ws2 = 1 << w2 + 1;
    var k2 = num.clone();
    for (i3 = 0; i3 < naf.length; i3++) {
      var z2;
      var mod = k2.andln(ws2 - 1);
      if (k2.isOdd()) {
        if (mod > (ws2 >> 1) - 1)
          z2 = (ws2 >> 1) - mod;
        else
          z2 = mod;
        k2.isubn(z2);
      } else {
        z2 = 0;
      }
      naf[i3] = z2;
      k2.iushrn(1);
    }
    return naf;
  }
  utils2.getNAF = getNAF2;
  function getJSF2(k1, k2) {
    var jsf = [
      [],
      []
    ];
    k1 = k1.clone();
    k2 = k2.clone();
    var d1 = 0;
    var d22 = 0;
    var m8;
    while (k1.cmpn(-d1) > 0 || k2.cmpn(-d22) > 0) {
      var m14 = k1.andln(3) + d1 & 3;
      var m24 = k2.andln(3) + d22 & 3;
      if (m14 === 3)
        m14 = -1;
      if (m24 === 3)
        m24 = -1;
      var u1;
      if ((m14 & 1) === 0) {
        u1 = 0;
      } else {
        m8 = k1.andln(7) + d1 & 7;
        if ((m8 === 3 || m8 === 5) && m24 === 2)
          u1 = -m14;
        else
          u1 = m14;
      }
      jsf[0].push(u1);
      var u2;
      if ((m24 & 1) === 0) {
        u2 = 0;
      } else {
        m8 = k2.andln(7) + d22 & 7;
        if ((m8 === 3 || m8 === 5) && m14 === 2)
          u2 = -m24;
        else
          u2 = m24;
      }
      jsf[1].push(u2);
      if (2 * d1 === u1 + 1)
        d1 = 1 - d1;
      if (2 * d22 === u2 + 1)
        d22 = 1 - d22;
      k1.iushrn(1);
      k2.iushrn(1);
    }
    return jsf;
  }
  utils2.getJSF = getJSF2;
  function cachedProperty2(obj, name2, computer) {
    var key2 = "_" + name2;
    obj.prototype[name2] = function cachedProperty3() {
      return this[key2] !== void 0 ? this[key2] : this[key2] = computer.call(this);
    };
  }
  utils2.cachedProperty = cachedProperty2;
  function parseBytes2(bytes) {
    return typeof bytes === "string" ? utils2.toArray(bytes, "hex") : bytes;
  }
  utils2.parseBytes = parseBytes2;
  function intFromLE(bytes) {
    return new BN2(bytes, "hex", "le");
  }
  utils2.intFromLE = intFromLE;
})(utils$a);
var curve = {};
var BN$7 = bnExports;
var utils$9 = utils$a;
var getNAF = utils$9.getNAF;
var getJSF = utils$9.getJSF;
var assert$8 = utils$9.assert;
function BaseCurve(type, conf) {
  this.type = type;
  this.p = new BN$7(conf.p, 16);
  this.red = conf.prime ? BN$7.red(conf.prime) : BN$7.mont(this.p);
  this.zero = new BN$7(0).toRed(this.red);
  this.one = new BN$7(1).toRed(this.red);
  this.two = new BN$7(2).toRed(this.red);
  this.n = conf.n && new BN$7(conf.n, 16);
  this.g = conf.g && this.pointFromJSON(conf.g, conf.gRed);
  this._wnafT1 = new Array(4);
  this._wnafT2 = new Array(4);
  this._wnafT3 = new Array(4);
  this._wnafT4 = new Array(4);
  this._bitLength = this.n ? this.n.bitLength() : 0;
  var adjustCount = this.n && this.p.div(this.n);
  if (!adjustCount || adjustCount.cmpn(100) > 0) {
    this.redN = null;
  } else {
    this._maxwellTrick = true;
    this.redN = this.n.toRed(this.red);
  }
}
var base = BaseCurve;
BaseCurve.prototype.point = function point3() {
  throw new Error("Not implemented");
};
BaseCurve.prototype.validate = function validate5() {
  throw new Error("Not implemented");
};
BaseCurve.prototype._fixedNafMul = function _fixedNafMul2(p3, k2) {
  assert$8(p3.precomputed);
  var doubles = p3._getDoubles();
  var naf = getNAF(k2, 1, this._bitLength);
  var I2 = (1 << doubles.step + 1) - (doubles.step % 2 === 0 ? 2 : 1);
  I2 /= 3;
  var repr = [];
  var j2;
  var nafW;
  for (j2 = 0; j2 < naf.length; j2 += doubles.step) {
    nafW = 0;
    for (var l2 = j2 + doubles.step - 1; l2 >= j2; l2--)
      nafW = (nafW << 1) + naf[l2];
    repr.push(nafW);
  }
  var a3 = this.jpoint(null, null, null);
  var b2 = this.jpoint(null, null, null);
  for (var i3 = I2; i3 > 0; i3--) {
    for (j2 = 0; j2 < repr.length; j2++) {
      nafW = repr[j2];
      if (nafW === i3)
        b2 = b2.mixedAdd(doubles.points[j2]);
      else if (nafW === -i3)
        b2 = b2.mixedAdd(doubles.points[j2].neg());
    }
    a3 = a3.add(b2);
  }
  return a3.toP();
};
BaseCurve.prototype._wnafMul = function _wnafMul2(p3, k2) {
  var w2 = 4;
  var nafPoints = p3._getNAFPoints(w2);
  w2 = nafPoints.wnd;
  var wnd = nafPoints.points;
  var naf = getNAF(k2, w2, this._bitLength);
  var acc = this.jpoint(null, null, null);
  for (var i3 = naf.length - 1; i3 >= 0; i3--) {
    for (var l2 = 0; i3 >= 0 && naf[i3] === 0; i3--)
      l2++;
    if (i3 >= 0)
      l2++;
    acc = acc.dblp(l2);
    if (i3 < 0)
      break;
    var z2 = naf[i3];
    assert$8(z2 !== 0);
    if (p3.type === "affine") {
      if (z2 > 0)
        acc = acc.mixedAdd(wnd[z2 - 1 >> 1]);
      else
        acc = acc.mixedAdd(wnd[-z2 - 1 >> 1].neg());
    } else {
      if (z2 > 0)
        acc = acc.add(wnd[z2 - 1 >> 1]);
      else
        acc = acc.add(wnd[-z2 - 1 >> 1].neg());
    }
  }
  return p3.type === "affine" ? acc.toP() : acc;
};
BaseCurve.prototype._wnafMulAdd = function _wnafMulAdd2(defW, points, coeffs, len, jacobianResult) {
  var wndWidth = this._wnafT1;
  var wnd = this._wnafT2;
  var naf = this._wnafT3;
  var max = 0;
  var i3;
  var j2;
  var p3;
  for (i3 = 0; i3 < len; i3++) {
    p3 = points[i3];
    var nafPoints = p3._getNAFPoints(defW);
    wndWidth[i3] = nafPoints.wnd;
    wnd[i3] = nafPoints.points;
  }
  for (i3 = len - 1; i3 >= 1; i3 -= 2) {
    var a3 = i3 - 1;
    var b2 = i3;
    if (wndWidth[a3] !== 1 || wndWidth[b2] !== 1) {
      naf[a3] = getNAF(coeffs[a3], wndWidth[a3], this._bitLength);
      naf[b2] = getNAF(coeffs[b2], wndWidth[b2], this._bitLength);
      max = Math.max(naf[a3].length, max);
      max = Math.max(naf[b2].length, max);
      continue;
    }
    var comb = [
      points[a3],
      /* 1 */
      null,
      /* 3 */
      null,
      /* 5 */
      points[b2]
      /* 7 */
    ];
    if (points[a3].y.cmp(points[b2].y) === 0) {
      comb[1] = points[a3].add(points[b2]);
      comb[2] = points[a3].toJ().mixedAdd(points[b2].neg());
    } else if (points[a3].y.cmp(points[b2].y.redNeg()) === 0) {
      comb[1] = points[a3].toJ().mixedAdd(points[b2]);
      comb[2] = points[a3].add(points[b2].neg());
    } else {
      comb[1] = points[a3].toJ().mixedAdd(points[b2]);
      comb[2] = points[a3].toJ().mixedAdd(points[b2].neg());
    }
    var index = [
      -3,
      /* -1 -1 */
      -1,
      /* -1 0 */
      -5,
      /* -1 1 */
      -7,
      /* 0 -1 */
      0,
      /* 0 0 */
      7,
      /* 0 1 */
      5,
      /* 1 -1 */
      1,
      /* 1 0 */
      3
      /* 1 1 */
    ];
    var jsf = getJSF(coeffs[a3], coeffs[b2]);
    max = Math.max(jsf[0].length, max);
    naf[a3] = new Array(max);
    naf[b2] = new Array(max);
    for (j2 = 0; j2 < max; j2++) {
      var ja = jsf[0][j2] | 0;
      var jb = jsf[1][j2] | 0;
      naf[a3][j2] = index[(ja + 1) * 3 + (jb + 1)];
      naf[b2][j2] = 0;
      wnd[a3] = comb;
    }
  }
  var acc = this.jpoint(null, null, null);
  var tmp = this._wnafT4;
  for (i3 = max; i3 >= 0; i3--) {
    var k2 = 0;
    while (i3 >= 0) {
      var zero = true;
      for (j2 = 0; j2 < len; j2++) {
        tmp[j2] = naf[j2][i3] | 0;
        if (tmp[j2] !== 0)
          zero = false;
      }
      if (!zero)
        break;
      k2++;
      i3--;
    }
    if (i3 >= 0)
      k2++;
    acc = acc.dblp(k2);
    if (i3 < 0)
      break;
    for (j2 = 0; j2 < len; j2++) {
      var z2 = tmp[j2];
      if (z2 === 0)
        continue;
      else if (z2 > 0)
        p3 = wnd[j2][z2 - 1 >> 1];
      else if (z2 < 0)
        p3 = wnd[j2][-z2 - 1 >> 1].neg();
      if (p3.type === "affine")
        acc = acc.mixedAdd(p3);
      else
        acc = acc.add(p3);
    }
  }
  for (i3 = 0; i3 < len; i3++)
    wnd[i3] = null;
  if (jacobianResult)
    return acc;
  else
    return acc.toP();
};
function BasePoint(curve2, type) {
  this.curve = curve2;
  this.type = type;
  this.precomputed = null;
}
BaseCurve.BasePoint = BasePoint;
BasePoint.prototype.eq = function eq4() {
  throw new Error("Not implemented");
};
BasePoint.prototype.validate = function validate6() {
  return this.curve.validate(this);
};
BaseCurve.prototype.decodePoint = function decodePoint2(bytes, enc) {
  bytes = utils$9.toArray(bytes, enc);
  var len = this.p.byteLength();
  if ((bytes[0] === 4 || bytes[0] === 6 || bytes[0] === 7) && bytes.length - 1 === 2 * len) {
    if (bytes[0] === 6)
      assert$8(bytes[bytes.length - 1] % 2 === 0);
    else if (bytes[0] === 7)
      assert$8(bytes[bytes.length - 1] % 2 === 1);
    var res = this.point(
      bytes.slice(1, 1 + len),
      bytes.slice(1 + len, 1 + 2 * len)
    );
    return res;
  } else if ((bytes[0] === 2 || bytes[0] === 3) && bytes.length - 1 === len) {
    return this.pointFromX(bytes.slice(1, 1 + len), bytes[0] === 3);
  }
  throw new Error("Unknown point format");
};
BasePoint.prototype.encodeCompressed = function encodeCompressed2(enc) {
  return this.encode(enc, true);
};
BasePoint.prototype._encode = function _encode2(compact) {
  var len = this.curve.p.byteLength();
  var x3 = this.getX().toArray("be", len);
  if (compact)
    return [this.getY().isEven() ? 2 : 3].concat(x3);
  return [4].concat(x3, this.getY().toArray("be", len));
};
BasePoint.prototype.encode = function encode3(enc, compact) {
  return utils$9.encode(this._encode(compact), enc);
};
BasePoint.prototype.precompute = function precompute2(power) {
  if (this.precomputed)
    return this;
  var precomputed = {
    doubles: null,
    naf: null,
    beta: null
  };
  precomputed.naf = this._getNAFPoints(8);
  precomputed.doubles = this._getDoubles(4, power);
  precomputed.beta = this._getBeta();
  this.precomputed = precomputed;
  return this;
};
BasePoint.prototype._hasDoubles = function _hasDoubles2(k2) {
  if (!this.precomputed)
    return false;
  var doubles = this.precomputed.doubles;
  if (!doubles)
    return false;
  return doubles.points.length >= Math.ceil((k2.bitLength() + 1) / doubles.step);
};
BasePoint.prototype._getDoubles = function _getDoubles2(step, power) {
  if (this.precomputed && this.precomputed.doubles)
    return this.precomputed.doubles;
  var doubles = [this];
  var acc = this;
  for (var i3 = 0; i3 < power; i3 += step) {
    for (var j2 = 0; j2 < step; j2++)
      acc = acc.dbl();
    doubles.push(acc);
  }
  return {
    step,
    points: doubles
  };
};
BasePoint.prototype._getNAFPoints = function _getNAFPoints2(wnd) {
  if (this.precomputed && this.precomputed.naf)
    return this.precomputed.naf;
  var res = [this];
  var max = (1 << wnd) - 1;
  var dbl7 = max === 1 ? null : this.dbl();
  for (var i3 = 1; i3 < max; i3++)
    res[i3] = res[i3 - 1].add(dbl7);
  return {
    wnd,
    points: res
  };
};
BasePoint.prototype._getBeta = function _getBeta3() {
  return null;
};
BasePoint.prototype.dblp = function dblp3(k2) {
  var r2 = this;
  for (var i3 = 0; i3 < k2; i3++)
    r2 = r2.dbl();
  return r2;
};
var utils$8 = utils$a;
var BN$6 = bnExports;
var inherits$2 = inherits_browserExports;
var Base$2 = base;
var assert$7 = utils$8.assert;
function ShortCurve(conf) {
  Base$2.call(this, "short", conf);
  this.a = new BN$6(conf.a, 16).toRed(this.red);
  this.b = new BN$6(conf.b, 16).toRed(this.red);
  this.tinv = this.two.redInvm();
  this.zeroA = this.a.fromRed().cmpn(0) === 0;
  this.threeA = this.a.fromRed().sub(this.p).cmpn(-3) === 0;
  this.endo = this._getEndomorphism(conf);
  this._endoWnafT1 = new Array(4);
  this._endoWnafT2 = new Array(4);
}
inherits$2(ShortCurve, Base$2);
var short = ShortCurve;
ShortCurve.prototype._getEndomorphism = function _getEndomorphism2(conf) {
  if (!this.zeroA || !this.g || !this.n || this.p.modn(3) !== 1)
    return;
  var beta;
  var lambda;
  if (conf.beta) {
    beta = new BN$6(conf.beta, 16).toRed(this.red);
  } else {
    var betas = this._getEndoRoots(this.p);
    beta = betas[0].cmp(betas[1]) < 0 ? betas[0] : betas[1];
    beta = beta.toRed(this.red);
  }
  if (conf.lambda) {
    lambda = new BN$6(conf.lambda, 16);
  } else {
    var lambdas = this._getEndoRoots(this.n);
    if (this.g.mul(lambdas[0]).x.cmp(this.g.x.redMul(beta)) === 0) {
      lambda = lambdas[0];
    } else {
      lambda = lambdas[1];
      assert$7(this.g.mul(lambda).x.cmp(this.g.x.redMul(beta)) === 0);
    }
  }
  var basis;
  if (conf.basis) {
    basis = conf.basis.map(function(vec) {
      return {
        a: new BN$6(vec.a, 16),
        b: new BN$6(vec.b, 16)
      };
    });
  } else {
    basis = this._getEndoBasis(lambda);
  }
  return {
    beta,
    lambda,
    basis
  };
};
ShortCurve.prototype._getEndoRoots = function _getEndoRoots2(num) {
  var red = num === this.p ? this.red : BN$6.mont(num);
  var tinv = new BN$6(2).toRed(red).redInvm();
  var ntinv = tinv.redNeg();
  var s2 = new BN$6(3).toRed(red).redNeg().redSqrt().redMul(tinv);
  var l1 = ntinv.redAdd(s2).fromRed();
  var l2 = ntinv.redSub(s2).fromRed();
  return [l1, l2];
};
ShortCurve.prototype._getEndoBasis = function _getEndoBasis2(lambda) {
  var aprxSqrt = this.n.ushrn(Math.floor(this.n.bitLength() / 2));
  var u2 = lambda;
  var v3 = this.n.clone();
  var x1 = new BN$6(1);
  var y1 = new BN$6(0);
  var x22 = new BN$6(0);
  var y22 = new BN$6(1);
  var a0;
  var b0;
  var a1;
  var b1;
  var a22;
  var b2;
  var prevR;
  var i3 = 0;
  var r2;
  var x3;
  while (u2.cmpn(0) !== 0) {
    var q2 = v3.div(u2);
    r2 = v3.sub(q2.mul(u2));
    x3 = x22.sub(q2.mul(x1));
    var y3 = y22.sub(q2.mul(y1));
    if (!a1 && r2.cmp(aprxSqrt) < 0) {
      a0 = prevR.neg();
      b0 = x1;
      a1 = r2.neg();
      b1 = x3;
    } else if (a1 && ++i3 === 2) {
      break;
    }
    prevR = r2;
    v3 = u2;
    u2 = r2;
    x22 = x1;
    x1 = x3;
    y22 = y1;
    y1 = y3;
  }
  a22 = r2.neg();
  b2 = x3;
  var len1 = a1.sqr().add(b1.sqr());
  var len2 = a22.sqr().add(b2.sqr());
  if (len2.cmp(len1) >= 0) {
    a22 = a0;
    b2 = b0;
  }
  if (a1.negative) {
    a1 = a1.neg();
    b1 = b1.neg();
  }
  if (a22.negative) {
    a22 = a22.neg();
    b2 = b2.neg();
  }
  return [
    { a: a1, b: b1 },
    { a: a22, b: b2 }
  ];
};
ShortCurve.prototype._endoSplit = function _endoSplit2(k2) {
  var basis = this.endo.basis;
  var v1 = basis[0];
  var v22 = basis[1];
  var c1 = v22.b.mul(k2).divRound(this.n);
  var c2 = v1.b.neg().mul(k2).divRound(this.n);
  var p1 = c1.mul(v1.a);
  var p22 = c2.mul(v22.a);
  var q1 = c1.mul(v1.b);
  var q2 = c2.mul(v22.b);
  var k1 = k2.sub(p1).sub(p22);
  var k22 = q1.add(q2).neg();
  return { k1, k2: k22 };
};
ShortCurve.prototype.pointFromX = function pointFromX2(x3, odd) {
  x3 = new BN$6(x3, 16);
  if (!x3.red)
    x3 = x3.toRed(this.red);
  var y22 = x3.redSqr().redMul(x3).redIAdd(x3.redMul(this.a)).redIAdd(this.b);
  var y3 = y22.redSqrt();
  if (y3.redSqr().redSub(y22).cmp(this.zero) !== 0)
    throw new Error("invalid point");
  var isOdd = y3.fromRed().isOdd();
  if (odd && !isOdd || !odd && isOdd)
    y3 = y3.redNeg();
  return this.point(x3, y3);
};
ShortCurve.prototype.validate = function validate7(point7) {
  if (point7.inf)
    return true;
  var x3 = point7.x;
  var y3 = point7.y;
  var ax = this.a.redMul(x3);
  var rhs = x3.redSqr().redMul(x3).redIAdd(ax).redIAdd(this.b);
  return y3.redSqr().redISub(rhs).cmpn(0) === 0;
};
ShortCurve.prototype._endoWnafMulAdd = function _endoWnafMulAdd2(points, coeffs, jacobianResult) {
  var npoints = this._endoWnafT1;
  var ncoeffs = this._endoWnafT2;
  for (var i3 = 0; i3 < points.length; i3++) {
    var split = this._endoSplit(coeffs[i3]);
    var p3 = points[i3];
    var beta = p3._getBeta();
    if (split.k1.negative) {
      split.k1.ineg();
      p3 = p3.neg(true);
    }
    if (split.k2.negative) {
      split.k2.ineg();
      beta = beta.neg(true);
    }
    npoints[i3 * 2] = p3;
    npoints[i3 * 2 + 1] = beta;
    ncoeffs[i3 * 2] = split.k1;
    ncoeffs[i3 * 2 + 1] = split.k2;
  }
  var res = this._wnafMulAdd(1, npoints, ncoeffs, i3 * 2, jacobianResult);
  for (var j2 = 0; j2 < i3 * 2; j2++) {
    npoints[j2] = null;
    ncoeffs[j2] = null;
  }
  return res;
};
function Point$2(curve2, x3, y3, isRed) {
  Base$2.BasePoint.call(this, curve2, "affine");
  if (x3 === null && y3 === null) {
    this.x = null;
    this.y = null;
    this.inf = true;
  } else {
    this.x = new BN$6(x3, 16);
    this.y = new BN$6(y3, 16);
    if (isRed) {
      this.x.forceRed(this.curve.red);
      this.y.forceRed(this.curve.red);
    }
    if (!this.x.red)
      this.x = this.x.toRed(this.curve.red);
    if (!this.y.red)
      this.y = this.y.toRed(this.curve.red);
    this.inf = false;
  }
}
inherits$2(Point$2, Base$2.BasePoint);
ShortCurve.prototype.point = function point4(x3, y3, isRed) {
  return new Point$2(this, x3, y3, isRed);
};
ShortCurve.prototype.pointFromJSON = function pointFromJSON2(obj, red) {
  return Point$2.fromJSON(this, obj, red);
};
Point$2.prototype._getBeta = function _getBeta4() {
  if (!this.curve.endo)
    return;
  var pre = this.precomputed;
  if (pre && pre.beta)
    return pre.beta;
  var beta = this.curve.point(this.x.redMul(this.curve.endo.beta), this.y);
  if (pre) {
    var curve2 = this.curve;
    var endoMul = function(p3) {
      return curve2.point(p3.x.redMul(curve2.endo.beta), p3.y);
    };
    pre.beta = beta;
    beta.precomputed = {
      beta: null,
      naf: pre.naf && {
        wnd: pre.naf.wnd,
        points: pre.naf.points.map(endoMul)
      },
      doubles: pre.doubles && {
        step: pre.doubles.step,
        points: pre.doubles.points.map(endoMul)
      }
    };
  }
  return beta;
};
Point$2.prototype.toJSON = function toJSON2() {
  if (!this.precomputed)
    return [this.x, this.y];
  return [this.x, this.y, this.precomputed && {
    doubles: this.precomputed.doubles && {
      step: this.precomputed.doubles.step,
      points: this.precomputed.doubles.points.slice(1)
    },
    naf: this.precomputed.naf && {
      wnd: this.precomputed.naf.wnd,
      points: this.precomputed.naf.points.slice(1)
    }
  }];
};
Point$2.fromJSON = function fromJSON2(curve2, obj, red) {
  if (typeof obj === "string")
    obj = JSON.parse(obj);
  var res = curve2.point(obj[0], obj[1], red);
  if (!obj[2])
    return res;
  function obj2point(obj2) {
    return curve2.point(obj2[0], obj2[1], red);
  }
  var pre = obj[2];
  res.precomputed = {
    beta: null,
    doubles: pre.doubles && {
      step: pre.doubles.step,
      points: [res].concat(pre.doubles.points.map(obj2point))
    },
    naf: pre.naf && {
      wnd: pre.naf.wnd,
      points: [res].concat(pre.naf.points.map(obj2point))
    }
  };
  return res;
};
Point$2.prototype.inspect = function inspect4() {
  if (this.isInfinity())
    return "<EC Point Infinity>";
  return "<EC Point x: " + this.x.fromRed().toString(16, 2) + " y: " + this.y.fromRed().toString(16, 2) + ">";
};
Point$2.prototype.isInfinity = function isInfinity3() {
  return this.inf;
};
Point$2.prototype.add = function add3(p3) {
  if (this.inf)
    return p3;
  if (p3.inf)
    return this;
  if (this.eq(p3))
    return this.dbl();
  if (this.neg().eq(p3))
    return this.curve.point(null, null);
  if (this.x.cmp(p3.x) === 0)
    return this.curve.point(null, null);
  var c2 = this.y.redSub(p3.y);
  if (c2.cmpn(0) !== 0)
    c2 = c2.redMul(this.x.redSub(p3.x).redInvm());
  var nx = c2.redSqr().redISub(this.x).redISub(p3.x);
  var ny = c2.redMul(this.x.redSub(nx)).redISub(this.y);
  return this.curve.point(nx, ny);
};
Point$2.prototype.dbl = function dbl3() {
  if (this.inf)
    return this;
  var ys1 = this.y.redAdd(this.y);
  if (ys1.cmpn(0) === 0)
    return this.curve.point(null, null);
  var a3 = this.curve.a;
  var x22 = this.x.redSqr();
  var dyinv = ys1.redInvm();
  var c2 = x22.redAdd(x22).redIAdd(x22).redIAdd(a3).redMul(dyinv);
  var nx = c2.redSqr().redISub(this.x.redAdd(this.x));
  var ny = c2.redMul(this.x.redSub(nx)).redISub(this.y);
  return this.curve.point(nx, ny);
};
Point$2.prototype.getX = function getX2() {
  return this.x.fromRed();
};
Point$2.prototype.getY = function getY2() {
  return this.y.fromRed();
};
Point$2.prototype.mul = function mul3(k2) {
  k2 = new BN$6(k2, 16);
  if (this.isInfinity())
    return this;
  else if (this._hasDoubles(k2))
    return this.curve._fixedNafMul(this, k2);
  else if (this.curve.endo)
    return this.curve._endoWnafMulAdd([this], [k2]);
  else
    return this.curve._wnafMul(this, k2);
};
Point$2.prototype.mulAdd = function mulAdd2(k1, p22, k2) {
  var points = [this, p22];
  var coeffs = [k1, k2];
  if (this.curve.endo)
    return this.curve._endoWnafMulAdd(points, coeffs);
  else
    return this.curve._wnafMulAdd(1, points, coeffs, 2);
};
Point$2.prototype.jmulAdd = function jmulAdd2(k1, p22, k2) {
  var points = [this, p22];
  var coeffs = [k1, k2];
  if (this.curve.endo)
    return this.curve._endoWnafMulAdd(points, coeffs, true);
  else
    return this.curve._wnafMulAdd(1, points, coeffs, 2, true);
};
Point$2.prototype.eq = function eq5(p3) {
  return this === p3 || this.inf === p3.inf && (this.inf || this.x.cmp(p3.x) === 0 && this.y.cmp(p3.y) === 0);
};
Point$2.prototype.neg = function neg3(_precompute) {
  if (this.inf)
    return this;
  var res = this.curve.point(this.x, this.y.redNeg());
  if (_precompute && this.precomputed) {
    var pre = this.precomputed;
    var negate = function(p3) {
      return p3.neg();
    };
    res.precomputed = {
      naf: pre.naf && {
        wnd: pre.naf.wnd,
        points: pre.naf.points.map(negate)
      },
      doubles: pre.doubles && {
        step: pre.doubles.step,
        points: pre.doubles.points.map(negate)
      }
    };
  }
  return res;
};
Point$2.prototype.toJ = function toJ2() {
  if (this.inf)
    return this.curve.jpoint(null, null, null);
  var res = this.curve.jpoint(this.x, this.y, this.curve.one);
  return res;
};
function JPoint(curve2, x3, y3, z2) {
  Base$2.BasePoint.call(this, curve2, "jacobian");
  if (x3 === null && y3 === null && z2 === null) {
    this.x = this.curve.one;
    this.y = this.curve.one;
    this.z = new BN$6(0);
  } else {
    this.x = new BN$6(x3, 16);
    this.y = new BN$6(y3, 16);
    this.z = new BN$6(z2, 16);
  }
  if (!this.x.red)
    this.x = this.x.toRed(this.curve.red);
  if (!this.y.red)
    this.y = this.y.toRed(this.curve.red);
  if (!this.z.red)
    this.z = this.z.toRed(this.curve.red);
  this.zOne = this.z === this.curve.one;
}
inherits$2(JPoint, Base$2.BasePoint);
ShortCurve.prototype.jpoint = function jpoint2(x3, y3, z2) {
  return new JPoint(this, x3, y3, z2);
};
JPoint.prototype.toP = function toP2() {
  if (this.isInfinity())
    return this.curve.point(null, null);
  var zinv = this.z.redInvm();
  var zinv2 = zinv.redSqr();
  var ax = this.x.redMul(zinv2);
  var ay = this.y.redMul(zinv2).redMul(zinv);
  return this.curve.point(ax, ay);
};
JPoint.prototype.neg = function neg4() {
  return this.curve.jpoint(this.x, this.y.redNeg(), this.z);
};
JPoint.prototype.add = function add4(p3) {
  if (this.isInfinity())
    return p3;
  if (p3.isInfinity())
    return this;
  var pz2 = p3.z.redSqr();
  var z2 = this.z.redSqr();
  var u1 = this.x.redMul(pz2);
  var u2 = p3.x.redMul(z2);
  var s1 = this.y.redMul(pz2.redMul(p3.z));
  var s2 = p3.y.redMul(z2.redMul(this.z));
  var h4 = u1.redSub(u2);
  var r2 = s1.redSub(s2);
  if (h4.cmpn(0) === 0) {
    if (r2.cmpn(0) !== 0)
      return this.curve.jpoint(null, null, null);
    else
      return this.dbl();
  }
  var h22 = h4.redSqr();
  var h32 = h22.redMul(h4);
  var v3 = u1.redMul(h22);
  var nx = r2.redSqr().redIAdd(h32).redISub(v3).redISub(v3);
  var ny = r2.redMul(v3.redISub(nx)).redISub(s1.redMul(h32));
  var nz = this.z.redMul(p3.z).redMul(h4);
  return this.curve.jpoint(nx, ny, nz);
};
JPoint.prototype.mixedAdd = function mixedAdd2(p3) {
  if (this.isInfinity())
    return p3.toJ();
  if (p3.isInfinity())
    return this;
  var z2 = this.z.redSqr();
  var u1 = this.x;
  var u2 = p3.x.redMul(z2);
  var s1 = this.y;
  var s2 = p3.y.redMul(z2).redMul(this.z);
  var h4 = u1.redSub(u2);
  var r2 = s1.redSub(s2);
  if (h4.cmpn(0) === 0) {
    if (r2.cmpn(0) !== 0)
      return this.curve.jpoint(null, null, null);
    else
      return this.dbl();
  }
  var h22 = h4.redSqr();
  var h32 = h22.redMul(h4);
  var v3 = u1.redMul(h22);
  var nx = r2.redSqr().redIAdd(h32).redISub(v3).redISub(v3);
  var ny = r2.redMul(v3.redISub(nx)).redISub(s1.redMul(h32));
  var nz = this.z.redMul(h4);
  return this.curve.jpoint(nx, ny, nz);
};
JPoint.prototype.dblp = function dblp4(pow) {
  if (pow === 0)
    return this;
  if (this.isInfinity())
    return this;
  if (!pow)
    return this.dbl();
  var i3;
  if (this.curve.zeroA || this.curve.threeA) {
    var r2 = this;
    for (i3 = 0; i3 < pow; i3++)
      r2 = r2.dbl();
    return r2;
  }
  var a3 = this.curve.a;
  var tinv = this.curve.tinv;
  var jx = this.x;
  var jy = this.y;
  var jz = this.z;
  var jz4 = jz.redSqr().redSqr();
  var jyd = jy.redAdd(jy);
  for (i3 = 0; i3 < pow; i3++) {
    var jx2 = jx.redSqr();
    var jyd2 = jyd.redSqr();
    var jyd4 = jyd2.redSqr();
    var c2 = jx2.redAdd(jx2).redIAdd(jx2).redIAdd(a3.redMul(jz4));
    var t1 = jx.redMul(jyd2);
    var nx = c2.redSqr().redISub(t1.redAdd(t1));
    var t2 = t1.redISub(nx);
    var dny = c2.redMul(t2);
    dny = dny.redIAdd(dny).redISub(jyd4);
    var nz = jyd.redMul(jz);
    if (i3 + 1 < pow)
      jz4 = jz4.redMul(jyd4);
    jx = nx;
    jz = nz;
    jyd = dny;
  }
  return this.curve.jpoint(jx, jyd.redMul(tinv), jz);
};
JPoint.prototype.dbl = function dbl4() {
  if (this.isInfinity())
    return this;
  if (this.curve.zeroA)
    return this._zeroDbl();
  else if (this.curve.threeA)
    return this._threeDbl();
  else
    return this._dbl();
};
JPoint.prototype._zeroDbl = function _zeroDbl2() {
  var nx;
  var ny;
  var nz;
  if (this.zOne) {
    var xx = this.x.redSqr();
    var yy = this.y.redSqr();
    var yyyy = yy.redSqr();
    var s2 = this.x.redAdd(yy).redSqr().redISub(xx).redISub(yyyy);
    s2 = s2.redIAdd(s2);
    var m2 = xx.redAdd(xx).redIAdd(xx);
    var t = m2.redSqr().redISub(s2).redISub(s2);
    var yyyy8 = yyyy.redIAdd(yyyy);
    yyyy8 = yyyy8.redIAdd(yyyy8);
    yyyy8 = yyyy8.redIAdd(yyyy8);
    nx = t;
    ny = m2.redMul(s2.redISub(t)).redISub(yyyy8);
    nz = this.y.redAdd(this.y);
  } else {
    var a3 = this.x.redSqr();
    var b2 = this.y.redSqr();
    var c2 = b2.redSqr();
    var d4 = this.x.redAdd(b2).redSqr().redISub(a3).redISub(c2);
    d4 = d4.redIAdd(d4);
    var e2 = a3.redAdd(a3).redIAdd(a3);
    var f3 = e2.redSqr();
    var c8 = c2.redIAdd(c2);
    c8 = c8.redIAdd(c8);
    c8 = c8.redIAdd(c8);
    nx = f3.redISub(d4).redISub(d4);
    ny = e2.redMul(d4.redISub(nx)).redISub(c8);
    nz = this.y.redMul(this.z);
    nz = nz.redIAdd(nz);
  }
  return this.curve.jpoint(nx, ny, nz);
};
JPoint.prototype._threeDbl = function _threeDbl2() {
  var nx;
  var ny;
  var nz;
  if (this.zOne) {
    var xx = this.x.redSqr();
    var yy = this.y.redSqr();
    var yyyy = yy.redSqr();
    var s2 = this.x.redAdd(yy).redSqr().redISub(xx).redISub(yyyy);
    s2 = s2.redIAdd(s2);
    var m2 = xx.redAdd(xx).redIAdd(xx).redIAdd(this.curve.a);
    var t = m2.redSqr().redISub(s2).redISub(s2);
    nx = t;
    var yyyy8 = yyyy.redIAdd(yyyy);
    yyyy8 = yyyy8.redIAdd(yyyy8);
    yyyy8 = yyyy8.redIAdd(yyyy8);
    ny = m2.redMul(s2.redISub(t)).redISub(yyyy8);
    nz = this.y.redAdd(this.y);
  } else {
    var delta = this.z.redSqr();
    var gamma = this.y.redSqr();
    var beta = this.x.redMul(gamma);
    var alpha = this.x.redSub(delta).redMul(this.x.redAdd(delta));
    alpha = alpha.redAdd(alpha).redIAdd(alpha);
    var beta4 = beta.redIAdd(beta);
    beta4 = beta4.redIAdd(beta4);
    var beta8 = beta4.redAdd(beta4);
    nx = alpha.redSqr().redISub(beta8);
    nz = this.y.redAdd(this.z).redSqr().redISub(gamma).redISub(delta);
    var ggamma8 = gamma.redSqr();
    ggamma8 = ggamma8.redIAdd(ggamma8);
    ggamma8 = ggamma8.redIAdd(ggamma8);
    ggamma8 = ggamma8.redIAdd(ggamma8);
    ny = alpha.redMul(beta4.redISub(nx)).redISub(ggamma8);
  }
  return this.curve.jpoint(nx, ny, nz);
};
JPoint.prototype._dbl = function _dbl2() {
  var a3 = this.curve.a;
  var jx = this.x;
  var jy = this.y;
  var jz = this.z;
  var jz4 = jz.redSqr().redSqr();
  var jx2 = jx.redSqr();
  var jy2 = jy.redSqr();
  var c2 = jx2.redAdd(jx2).redIAdd(jx2).redIAdd(a3.redMul(jz4));
  var jxd4 = jx.redAdd(jx);
  jxd4 = jxd4.redIAdd(jxd4);
  var t1 = jxd4.redMul(jy2);
  var nx = c2.redSqr().redISub(t1.redAdd(t1));
  var t2 = t1.redISub(nx);
  var jyd8 = jy2.redSqr();
  jyd8 = jyd8.redIAdd(jyd8);
  jyd8 = jyd8.redIAdd(jyd8);
  jyd8 = jyd8.redIAdd(jyd8);
  var ny = c2.redMul(t2).redISub(jyd8);
  var nz = jy.redAdd(jy).redMul(jz);
  return this.curve.jpoint(nx, ny, nz);
};
JPoint.prototype.trpl = function trpl2() {
  if (!this.curve.zeroA)
    return this.dbl().add(this);
  var xx = this.x.redSqr();
  var yy = this.y.redSqr();
  var zz = this.z.redSqr();
  var yyyy = yy.redSqr();
  var m2 = xx.redAdd(xx).redIAdd(xx);
  var mm = m2.redSqr();
  var e2 = this.x.redAdd(yy).redSqr().redISub(xx).redISub(yyyy);
  e2 = e2.redIAdd(e2);
  e2 = e2.redAdd(e2).redIAdd(e2);
  e2 = e2.redISub(mm);
  var ee2 = e2.redSqr();
  var t = yyyy.redIAdd(yyyy);
  t = t.redIAdd(t);
  t = t.redIAdd(t);
  t = t.redIAdd(t);
  var u2 = m2.redIAdd(e2).redSqr().redISub(mm).redISub(ee2).redISub(t);
  var yyu4 = yy.redMul(u2);
  yyu4 = yyu4.redIAdd(yyu4);
  yyu4 = yyu4.redIAdd(yyu4);
  var nx = this.x.redMul(ee2).redISub(yyu4);
  nx = nx.redIAdd(nx);
  nx = nx.redIAdd(nx);
  var ny = this.y.redMul(u2.redMul(t.redISub(u2)).redISub(e2.redMul(ee2)));
  ny = ny.redIAdd(ny);
  ny = ny.redIAdd(ny);
  ny = ny.redIAdd(ny);
  var nz = this.z.redAdd(e2).redSqr().redISub(zz).redISub(ee2);
  return this.curve.jpoint(nx, ny, nz);
};
JPoint.prototype.mul = function mul4(k2, kbase) {
  k2 = new BN$6(k2, kbase);
  return this.curve._wnafMul(this, k2);
};
JPoint.prototype.eq = function eq6(p3) {
  if (p3.type === "affine")
    return this.eq(p3.toJ());
  if (this === p3)
    return true;
  var z2 = this.z.redSqr();
  var pz2 = p3.z.redSqr();
  if (this.x.redMul(pz2).redISub(p3.x.redMul(z2)).cmpn(0) !== 0)
    return false;
  var z3 = z2.redMul(this.z);
  var pz3 = pz2.redMul(p3.z);
  return this.y.redMul(pz3).redISub(p3.y.redMul(z3)).cmpn(0) === 0;
};
JPoint.prototype.eqXToP = function eqXToP2(x3) {
  var zs2 = this.z.redSqr();
  var rx = x3.toRed(this.curve.red).redMul(zs2);
  if (this.x.cmp(rx) === 0)
    return true;
  var xc = x3.clone();
  var t = this.curve.redN.redMul(zs2);
  for (; ; ) {
    xc.iadd(this.curve.n);
    if (xc.cmp(this.curve.p) >= 0)
      return false;
    rx.redIAdd(t);
    if (this.x.cmp(rx) === 0)
      return true;
  }
};
JPoint.prototype.inspect = function inspect5() {
  if (this.isInfinity())
    return "<EC JPoint Infinity>";
  return "<EC JPoint x: " + this.x.toString(16, 2) + " y: " + this.y.toString(16, 2) + " z: " + this.z.toString(16, 2) + ">";
};
JPoint.prototype.isInfinity = function isInfinity4() {
  return this.z.cmpn(0) === 0;
};
var BN$5 = bnExports;
var inherits$1 = inherits_browserExports;
var Base$1 = base;
var utils$7 = utils$a;
function MontCurve(conf) {
  Base$1.call(this, "mont", conf);
  this.a = new BN$5(conf.a, 16).toRed(this.red);
  this.b = new BN$5(conf.b, 16).toRed(this.red);
  this.i4 = new BN$5(4).toRed(this.red).redInvm();
  this.two = new BN$5(2).toRed(this.red);
  this.a24 = this.i4.redMul(this.a.redAdd(this.two));
}
inherits$1(MontCurve, Base$1);
var mont = MontCurve;
MontCurve.prototype.validate = function validate8(point7) {
  var x3 = point7.normalize().x;
  var x22 = x3.redSqr();
  var rhs = x22.redMul(x3).redAdd(x22.redMul(this.a)).redAdd(x3);
  var y3 = rhs.redSqrt();
  return y3.redSqr().cmp(rhs) === 0;
};
function Point$1(curve2, x3, z2) {
  Base$1.BasePoint.call(this, curve2, "projective");
  if (x3 === null && z2 === null) {
    this.x = this.curve.one;
    this.z = this.curve.zero;
  } else {
    this.x = new BN$5(x3, 16);
    this.z = new BN$5(z2, 16);
    if (!this.x.red)
      this.x = this.x.toRed(this.curve.red);
    if (!this.z.red)
      this.z = this.z.toRed(this.curve.red);
  }
}
inherits$1(Point$1, Base$1.BasePoint);
MontCurve.prototype.decodePoint = function decodePoint3(bytes, enc) {
  return this.point(utils$7.toArray(bytes, enc), 1);
};
MontCurve.prototype.point = function point5(x3, z2) {
  return new Point$1(this, x3, z2);
};
MontCurve.prototype.pointFromJSON = function pointFromJSON3(obj) {
  return Point$1.fromJSON(this, obj);
};
Point$1.prototype.precompute = function precompute3() {
};
Point$1.prototype._encode = function _encode3() {
  return this.getX().toArray("be", this.curve.p.byteLength());
};
Point$1.fromJSON = function fromJSON3(curve2, obj) {
  return new Point$1(curve2, obj[0], obj[1] || curve2.one);
};
Point$1.prototype.inspect = function inspect6() {
  if (this.isInfinity())
    return "<EC Point Infinity>";
  return "<EC Point x: " + this.x.fromRed().toString(16, 2) + " z: " + this.z.fromRed().toString(16, 2) + ">";
};
Point$1.prototype.isInfinity = function isInfinity5() {
  return this.z.cmpn(0) === 0;
};
Point$1.prototype.dbl = function dbl5() {
  var a3 = this.x.redAdd(this.z);
  var aa = a3.redSqr();
  var b2 = this.x.redSub(this.z);
  var bb = b2.redSqr();
  var c2 = aa.redSub(bb);
  var nx = aa.redMul(bb);
  var nz = c2.redMul(bb.redAdd(this.curve.a24.redMul(c2)));
  return this.curve.point(nx, nz);
};
Point$1.prototype.add = function add5() {
  throw new Error("Not supported on Montgomery curve");
};
Point$1.prototype.diffAdd = function diffAdd(p3, diff) {
  var a3 = this.x.redAdd(this.z);
  var b2 = this.x.redSub(this.z);
  var c2 = p3.x.redAdd(p3.z);
  var d4 = p3.x.redSub(p3.z);
  var da = d4.redMul(a3);
  var cb = c2.redMul(b2);
  var nx = diff.z.redMul(da.redAdd(cb).redSqr());
  var nz = diff.x.redMul(da.redISub(cb).redSqr());
  return this.curve.point(nx, nz);
};
Point$1.prototype.mul = function mul5(k2) {
  var t = k2.clone();
  var a3 = this;
  var b2 = this.curve.point(null, null);
  var c2 = this;
  for (var bits = []; t.cmpn(0) !== 0; t.iushrn(1))
    bits.push(t.andln(1));
  for (var i3 = bits.length - 1; i3 >= 0; i3--) {
    if (bits[i3] === 0) {
      a3 = a3.diffAdd(b2, c2);
      b2 = b2.dbl();
    } else {
      b2 = a3.diffAdd(b2, c2);
      a3 = a3.dbl();
    }
  }
  return b2;
};
Point$1.prototype.mulAdd = function mulAdd3() {
  throw new Error("Not supported on Montgomery curve");
};
Point$1.prototype.jumlAdd = function jumlAdd() {
  throw new Error("Not supported on Montgomery curve");
};
Point$1.prototype.eq = function eq7(other) {
  return this.getX().cmp(other.getX()) === 0;
};
Point$1.prototype.normalize = function normalize() {
  this.x = this.x.redMul(this.z.redInvm());
  this.z = this.curve.one;
  return this;
};
Point$1.prototype.getX = function getX3() {
  this.normalize();
  return this.x.fromRed();
};
var utils$6 = utils$a;
var BN$4 = bnExports;
var inherits = inherits_browserExports;
var Base = base;
var assert$6 = utils$6.assert;
function EdwardsCurve(conf) {
  this.twisted = (conf.a | 0) !== 1;
  this.mOneA = this.twisted && (conf.a | 0) === -1;
  this.extended = this.mOneA;
  Base.call(this, "edwards", conf);
  this.a = new BN$4(conf.a, 16).umod(this.red.m);
  this.a = this.a.toRed(this.red);
  this.c = new BN$4(conf.c, 16).toRed(this.red);
  this.c2 = this.c.redSqr();
  this.d = new BN$4(conf.d, 16).toRed(this.red);
  this.dd = this.d.redAdd(this.d);
  assert$6(!this.twisted || this.c.fromRed().cmpn(1) === 0);
  this.oneC = (conf.c | 0) === 1;
}
inherits(EdwardsCurve, Base);
var edwards = EdwardsCurve;
EdwardsCurve.prototype._mulA = function _mulA(num) {
  if (this.mOneA)
    return num.redNeg();
  else
    return this.a.redMul(num);
};
EdwardsCurve.prototype._mulC = function _mulC(num) {
  if (this.oneC)
    return num;
  else
    return this.c.redMul(num);
};
EdwardsCurve.prototype.jpoint = function jpoint3(x3, y3, z2, t) {
  return this.point(x3, y3, z2, t);
};
EdwardsCurve.prototype.pointFromX = function pointFromX3(x3, odd) {
  x3 = new BN$4(x3, 16);
  if (!x3.red)
    x3 = x3.toRed(this.red);
  var x22 = x3.redSqr();
  var rhs = this.c2.redSub(this.a.redMul(x22));
  var lhs = this.one.redSub(this.c2.redMul(this.d).redMul(x22));
  var y22 = rhs.redMul(lhs.redInvm());
  var y3 = y22.redSqrt();
  if (y3.redSqr().redSub(y22).cmp(this.zero) !== 0)
    throw new Error("invalid point");
  var isOdd = y3.fromRed().isOdd();
  if (odd && !isOdd || !odd && isOdd)
    y3 = y3.redNeg();
  return this.point(x3, y3);
};
EdwardsCurve.prototype.pointFromY = function pointFromY(y3, odd) {
  y3 = new BN$4(y3, 16);
  if (!y3.red)
    y3 = y3.toRed(this.red);
  var y22 = y3.redSqr();
  var lhs = y22.redSub(this.c2);
  var rhs = y22.redMul(this.d).redMul(this.c2).redSub(this.a);
  var x22 = lhs.redMul(rhs.redInvm());
  if (x22.cmp(this.zero) === 0) {
    if (odd)
      throw new Error("invalid point");
    else
      return this.point(this.zero, y3);
  }
  var x3 = x22.redSqrt();
  if (x3.redSqr().redSub(x22).cmp(this.zero) !== 0)
    throw new Error("invalid point");
  if (x3.fromRed().isOdd() !== odd)
    x3 = x3.redNeg();
  return this.point(x3, y3);
};
EdwardsCurve.prototype.validate = function validate9(point7) {
  if (point7.isInfinity())
    return true;
  point7.normalize();
  var x22 = point7.x.redSqr();
  var y22 = point7.y.redSqr();
  var lhs = x22.redMul(this.a).redAdd(y22);
  var rhs = this.c2.redMul(this.one.redAdd(this.d.redMul(x22).redMul(y22)));
  return lhs.cmp(rhs) === 0;
};
function Point(curve2, x3, y3, z2, t) {
  Base.BasePoint.call(this, curve2, "projective");
  if (x3 === null && y3 === null && z2 === null) {
    this.x = this.curve.zero;
    this.y = this.curve.one;
    this.z = this.curve.one;
    this.t = this.curve.zero;
    this.zOne = true;
  } else {
    this.x = new BN$4(x3, 16);
    this.y = new BN$4(y3, 16);
    this.z = z2 ? new BN$4(z2, 16) : this.curve.one;
    this.t = t && new BN$4(t, 16);
    if (!this.x.red)
      this.x = this.x.toRed(this.curve.red);
    if (!this.y.red)
      this.y = this.y.toRed(this.curve.red);
    if (!this.z.red)
      this.z = this.z.toRed(this.curve.red);
    if (this.t && !this.t.red)
      this.t = this.t.toRed(this.curve.red);
    this.zOne = this.z === this.curve.one;
    if (this.curve.extended && !this.t) {
      this.t = this.x.redMul(this.y);
      if (!this.zOne)
        this.t = this.t.redMul(this.z.redInvm());
    }
  }
}
inherits(Point, Base.BasePoint);
EdwardsCurve.prototype.pointFromJSON = function pointFromJSON4(obj) {
  return Point.fromJSON(this, obj);
};
EdwardsCurve.prototype.point = function point6(x3, y3, z2, t) {
  return new Point(this, x3, y3, z2, t);
};
Point.fromJSON = function fromJSON4(curve2, obj) {
  return new Point(curve2, obj[0], obj[1], obj[2]);
};
Point.prototype.inspect = function inspect7() {
  if (this.isInfinity())
    return "<EC Point Infinity>";
  return "<EC Point x: " + this.x.fromRed().toString(16, 2) + " y: " + this.y.fromRed().toString(16, 2) + " z: " + this.z.fromRed().toString(16, 2) + ">";
};
Point.prototype.isInfinity = function isInfinity6() {
  return this.x.cmpn(0) === 0 && (this.y.cmp(this.z) === 0 || this.zOne && this.y.cmp(this.curve.c) === 0);
};
Point.prototype._extDbl = function _extDbl() {
  var a3 = this.x.redSqr();
  var b2 = this.y.redSqr();
  var c2 = this.z.redSqr();
  c2 = c2.redIAdd(c2);
  var d4 = this.curve._mulA(a3);
  var e2 = this.x.redAdd(this.y).redSqr().redISub(a3).redISub(b2);
  var g3 = d4.redAdd(b2);
  var f3 = g3.redSub(c2);
  var h4 = d4.redSub(b2);
  var nx = e2.redMul(f3);
  var ny = g3.redMul(h4);
  var nt2 = e2.redMul(h4);
  var nz = f3.redMul(g3);
  return this.curve.point(nx, ny, nz, nt2);
};
Point.prototype._projDbl = function _projDbl() {
  var b2 = this.x.redAdd(this.y).redSqr();
  var c2 = this.x.redSqr();
  var d4 = this.y.redSqr();
  var nx;
  var ny;
  var nz;
  var e2;
  var h4;
  var j2;
  if (this.curve.twisted) {
    e2 = this.curve._mulA(c2);
    var f3 = e2.redAdd(d4);
    if (this.zOne) {
      nx = b2.redSub(c2).redSub(d4).redMul(f3.redSub(this.curve.two));
      ny = f3.redMul(e2.redSub(d4));
      nz = f3.redSqr().redSub(f3).redSub(f3);
    } else {
      h4 = this.z.redSqr();
      j2 = f3.redSub(h4).redISub(h4);
      nx = b2.redSub(c2).redISub(d4).redMul(j2);
      ny = f3.redMul(e2.redSub(d4));
      nz = f3.redMul(j2);
    }
  } else {
    e2 = c2.redAdd(d4);
    h4 = this.curve._mulC(this.z).redSqr();
    j2 = e2.redSub(h4).redSub(h4);
    nx = this.curve._mulC(b2.redISub(e2)).redMul(j2);
    ny = this.curve._mulC(e2).redMul(c2.redISub(d4));
    nz = e2.redMul(j2);
  }
  return this.curve.point(nx, ny, nz);
};
Point.prototype.dbl = function dbl6() {
  if (this.isInfinity())
    return this;
  if (this.curve.extended)
    return this._extDbl();
  else
    return this._projDbl();
};
Point.prototype._extAdd = function _extAdd(p3) {
  var a3 = this.y.redSub(this.x).redMul(p3.y.redSub(p3.x));
  var b2 = this.y.redAdd(this.x).redMul(p3.y.redAdd(p3.x));
  var c2 = this.t.redMul(this.curve.dd).redMul(p3.t);
  var d4 = this.z.redMul(p3.z.redAdd(p3.z));
  var e2 = b2.redSub(a3);
  var f3 = d4.redSub(c2);
  var g3 = d4.redAdd(c2);
  var h4 = b2.redAdd(a3);
  var nx = e2.redMul(f3);
  var ny = g3.redMul(h4);
  var nt2 = e2.redMul(h4);
  var nz = f3.redMul(g3);
  return this.curve.point(nx, ny, nz, nt2);
};
Point.prototype._projAdd = function _projAdd(p3) {
  var a3 = this.z.redMul(p3.z);
  var b2 = a3.redSqr();
  var c2 = this.x.redMul(p3.x);
  var d4 = this.y.redMul(p3.y);
  var e2 = this.curve.d.redMul(c2).redMul(d4);
  var f3 = b2.redSub(e2);
  var g3 = b2.redAdd(e2);
  var tmp = this.x.redAdd(this.y).redMul(p3.x.redAdd(p3.y)).redISub(c2).redISub(d4);
  var nx = a3.redMul(f3).redMul(tmp);
  var ny;
  var nz;
  if (this.curve.twisted) {
    ny = a3.redMul(g3).redMul(d4.redSub(this.curve._mulA(c2)));
    nz = f3.redMul(g3);
  } else {
    ny = a3.redMul(g3).redMul(d4.redSub(c2));
    nz = this.curve._mulC(f3).redMul(g3);
  }
  return this.curve.point(nx, ny, nz);
};
Point.prototype.add = function add6(p3) {
  if (this.isInfinity())
    return p3;
  if (p3.isInfinity())
    return this;
  if (this.curve.extended)
    return this._extAdd(p3);
  else
    return this._projAdd(p3);
};
Point.prototype.mul = function mul6(k2) {
  if (this._hasDoubles(k2))
    return this.curve._fixedNafMul(this, k2);
  else
    return this.curve._wnafMul(this, k2);
};
Point.prototype.mulAdd = function mulAdd4(k1, p3, k2) {
  return this.curve._wnafMulAdd(1, [this, p3], [k1, k2], 2, false);
};
Point.prototype.jmulAdd = function jmulAdd3(k1, p3, k2) {
  return this.curve._wnafMulAdd(1, [this, p3], [k1, k2], 2, true);
};
Point.prototype.normalize = function normalize2() {
  if (this.zOne)
    return this;
  var zi = this.z.redInvm();
  this.x = this.x.redMul(zi);
  this.y = this.y.redMul(zi);
  if (this.t)
    this.t = this.t.redMul(zi);
  this.z = this.curve.one;
  this.zOne = true;
  return this;
};
Point.prototype.neg = function neg5() {
  return this.curve.point(
    this.x.redNeg(),
    this.y,
    this.z,
    this.t && this.t.redNeg()
  );
};
Point.prototype.getX = function getX4() {
  this.normalize();
  return this.x.fromRed();
};
Point.prototype.getY = function getY3() {
  this.normalize();
  return this.y.fromRed();
};
Point.prototype.eq = function eq8(other) {
  return this === other || this.getX().cmp(other.getX()) === 0 && this.getY().cmp(other.getY()) === 0;
};
Point.prototype.eqXToP = function eqXToP3(x3) {
  var rx = x3.toRed(this.curve.red).redMul(this.z);
  if (this.x.cmp(rx) === 0)
    return true;
  var xc = x3.clone();
  var t = this.curve.redN.redMul(this.z);
  for (; ; ) {
    xc.iadd(this.curve.n);
    if (xc.cmp(this.curve.p) >= 0)
      return false;
    rx.redIAdd(t);
    if (this.x.cmp(rx) === 0)
      return true;
  }
};
Point.prototype.toP = Point.prototype.normalize;
Point.prototype.mixedAdd = Point.prototype.add;
(function(exports) {
  var curve2 = exports;
  curve2.base = base;
  curve2.short = short;
  curve2.mont = mont;
  curve2.edwards = edwards;
})(curve);
var curves$2 = {};
var secp256k1;
var hasRequiredSecp256k1;
function requireSecp256k1() {
  if (hasRequiredSecp256k1) return secp256k1;
  hasRequiredSecp256k1 = 1;
  secp256k1 = {
    doubles: {
      step: 4,
      points: [
        [
          "e60fce93b59e9ec53011aabc21c23e97b2a31369b87a5ae9c44ee89e2a6dec0a",
          "f7e3507399e595929db99f34f57937101296891e44d23f0be1f32cce69616821"
        ],
        [
          "8282263212c609d9ea2a6e3e172de238d8c39cabd5ac1ca10646e23fd5f51508",
          "11f8a8098557dfe45e8256e830b60ace62d613ac2f7b17bed31b6eaff6e26caf"
        ],
        [
          "175e159f728b865a72f99cc6c6fc846de0b93833fd2222ed73fce5b551e5b739",
          "d3506e0d9e3c79eba4ef97a51ff71f5eacb5955add24345c6efa6ffee9fed695"
        ],
        [
          "363d90d447b00c9c99ceac05b6262ee053441c7e55552ffe526bad8f83ff4640",
          "4e273adfc732221953b445397f3363145b9a89008199ecb62003c7f3bee9de9"
        ],
        [
          "8b4b5f165df3c2be8c6244b5b745638843e4a781a15bcd1b69f79a55dffdf80c",
          "4aad0a6f68d308b4b3fbd7813ab0da04f9e336546162ee56b3eff0c65fd4fd36"
        ],
        [
          "723cbaa6e5db996d6bf771c00bd548c7b700dbffa6c0e77bcb6115925232fcda",
          "96e867b5595cc498a921137488824d6e2660a0653779494801dc069d9eb39f5f"
        ],
        [
          "eebfa4d493bebf98ba5feec812c2d3b50947961237a919839a533eca0e7dd7fa",
          "5d9a8ca3970ef0f269ee7edaf178089d9ae4cdc3a711f712ddfd4fdae1de8999"
        ],
        [
          "100f44da696e71672791d0a09b7bde459f1215a29b3c03bfefd7835b39a48db0",
          "cdd9e13192a00b772ec8f3300c090666b7ff4a18ff5195ac0fbd5cd62bc65a09"
        ],
        [
          "e1031be262c7ed1b1dc9227a4a04c017a77f8d4464f3b3852c8acde6e534fd2d",
          "9d7061928940405e6bb6a4176597535af292dd419e1ced79a44f18f29456a00d"
        ],
        [
          "feea6cae46d55b530ac2839f143bd7ec5cf8b266a41d6af52d5e688d9094696d",
          "e57c6b6c97dce1bab06e4e12bf3ecd5c981c8957cc41442d3155debf18090088"
        ],
        [
          "da67a91d91049cdcb367be4be6ffca3cfeed657d808583de33fa978bc1ec6cb1",
          "9bacaa35481642bc41f463f7ec9780e5dec7adc508f740a17e9ea8e27a68be1d"
        ],
        [
          "53904faa0b334cdda6e000935ef22151ec08d0f7bb11069f57545ccc1a37b7c0",
          "5bc087d0bc80106d88c9eccac20d3c1c13999981e14434699dcb096b022771c8"
        ],
        [
          "8e7bcd0bd35983a7719cca7764ca906779b53a043a9b8bcaeff959f43ad86047",
          "10b7770b2a3da4b3940310420ca9514579e88e2e47fd68b3ea10047e8460372a"
        ],
        [
          "385eed34c1cdff21e6d0818689b81bde71a7f4f18397e6690a841e1599c43862",
          "283bebc3e8ea23f56701de19e9ebf4576b304eec2086dc8cc0458fe5542e5453"
        ],
        [
          "6f9d9b803ecf191637c73a4413dfa180fddf84a5947fbc9c606ed86c3fac3a7",
          "7c80c68e603059ba69b8e2a30e45c4d47ea4dd2f5c281002d86890603a842160"
        ],
        [
          "3322d401243c4e2582a2147c104d6ecbf774d163db0f5e5313b7e0e742d0e6bd",
          "56e70797e9664ef5bfb019bc4ddaf9b72805f63ea2873af624f3a2e96c28b2a0"
        ],
        [
          "85672c7d2de0b7da2bd1770d89665868741b3f9af7643397721d74d28134ab83",
          "7c481b9b5b43b2eb6374049bfa62c2e5e77f17fcc5298f44c8e3094f790313a6"
        ],
        [
          "948bf809b1988a46b06c9f1919413b10f9226c60f668832ffd959af60c82a0a",
          "53a562856dcb6646dc6b74c5d1c3418c6d4dff08c97cd2bed4cb7f88d8c8e589"
        ],
        [
          "6260ce7f461801c34f067ce0f02873a8f1b0e44dfc69752accecd819f38fd8e8",
          "bc2da82b6fa5b571a7f09049776a1ef7ecd292238051c198c1a84e95b2b4ae17"
        ],
        [
          "e5037de0afc1d8d43d8348414bbf4103043ec8f575bfdc432953cc8d2037fa2d",
          "4571534baa94d3b5f9f98d09fb990bddbd5f5b03ec481f10e0e5dc841d755bda"
        ],
        [
          "e06372b0f4a207adf5ea905e8f1771b4e7e8dbd1c6a6c5b725866a0ae4fce725",
          "7a908974bce18cfe12a27bb2ad5a488cd7484a7787104870b27034f94eee31dd"
        ],
        [
          "213c7a715cd5d45358d0bbf9dc0ce02204b10bdde2a3f58540ad6908d0559754",
          "4b6dad0b5ae462507013ad06245ba190bb4850f5f36a7eeddff2c27534b458f2"
        ],
        [
          "4e7c272a7af4b34e8dbb9352a5419a87e2838c70adc62cddf0cc3a3b08fbd53c",
          "17749c766c9d0b18e16fd09f6def681b530b9614bff7dd33e0b3941817dcaae6"
        ],
        [
          "fea74e3dbe778b1b10f238ad61686aa5c76e3db2be43057632427e2840fb27b6",
          "6e0568db9b0b13297cf674deccb6af93126b596b973f7b77701d3db7f23cb96f"
        ],
        [
          "76e64113f677cf0e10a2570d599968d31544e179b760432952c02a4417bdde39",
          "c90ddf8dee4e95cf577066d70681f0d35e2a33d2b56d2032b4b1752d1901ac01"
        ],
        [
          "c738c56b03b2abe1e8281baa743f8f9a8f7cc643df26cbee3ab150242bcbb891",
          "893fb578951ad2537f718f2eacbfbbbb82314eef7880cfe917e735d9699a84c3"
        ],
        [
          "d895626548b65b81e264c7637c972877d1d72e5f3a925014372e9f6588f6c14b",
          "febfaa38f2bc7eae728ec60818c340eb03428d632bb067e179363ed75d7d991f"
        ],
        [
          "b8da94032a957518eb0f6433571e8761ceffc73693e84edd49150a564f676e03",
          "2804dfa44805a1e4d7c99cc9762808b092cc584d95ff3b511488e4e74efdf6e7"
        ],
        [
          "e80fea14441fb33a7d8adab9475d7fab2019effb5156a792f1a11778e3c0df5d",
          "eed1de7f638e00771e89768ca3ca94472d155e80af322ea9fcb4291b6ac9ec78"
        ],
        [
          "a301697bdfcd704313ba48e51d567543f2a182031efd6915ddc07bbcc4e16070",
          "7370f91cfb67e4f5081809fa25d40f9b1735dbf7c0a11a130c0d1a041e177ea1"
        ],
        [
          "90ad85b389d6b936463f9d0512678de208cc330b11307fffab7ac63e3fb04ed4",
          "e507a3620a38261affdcbd9427222b839aefabe1582894d991d4d48cb6ef150"
        ],
        [
          "8f68b9d2f63b5f339239c1ad981f162ee88c5678723ea3351b7b444c9ec4c0da",
          "662a9f2dba063986de1d90c2b6be215dbbea2cfe95510bfdf23cbf79501fff82"
        ],
        [
          "e4f3fb0176af85d65ff99ff9198c36091f48e86503681e3e6686fd5053231e11",
          "1e63633ad0ef4f1c1661a6d0ea02b7286cc7e74ec951d1c9822c38576feb73bc"
        ],
        [
          "8c00fa9b18ebf331eb961537a45a4266c7034f2f0d4e1d0716fb6eae20eae29e",
          "efa47267fea521a1a9dc343a3736c974c2fadafa81e36c54e7d2a4c66702414b"
        ],
        [
          "e7a26ce69dd4829f3e10cec0a9e98ed3143d084f308b92c0997fddfc60cb3e41",
          "2a758e300fa7984b471b006a1aafbb18d0a6b2c0420e83e20e8a9421cf2cfd51"
        ],
        [
          "b6459e0ee3662ec8d23540c223bcbdc571cbcb967d79424f3cf29eb3de6b80ef",
          "67c876d06f3e06de1dadf16e5661db3c4b3ae6d48e35b2ff30bf0b61a71ba45"
        ],
        [
          "d68a80c8280bb840793234aa118f06231d6f1fc67e73c5a5deda0f5b496943e8",
          "db8ba9fff4b586d00c4b1f9177b0e28b5b0e7b8f7845295a294c84266b133120"
        ],
        [
          "324aed7df65c804252dc0270907a30b09612aeb973449cea4095980fc28d3d5d",
          "648a365774b61f2ff130c0c35aec1f4f19213b0c7e332843967224af96ab7c84"
        ],
        [
          "4df9c14919cde61f6d51dfdbe5fee5dceec4143ba8d1ca888e8bd373fd054c96",
          "35ec51092d8728050974c23a1d85d4b5d506cdc288490192ebac06cad10d5d"
        ],
        [
          "9c3919a84a474870faed8a9c1cc66021523489054d7f0308cbfc99c8ac1f98cd",
          "ddb84f0f4a4ddd57584f044bf260e641905326f76c64c8e6be7e5e03d4fc599d"
        ],
        [
          "6057170b1dd12fdf8de05f281d8e06bb91e1493a8b91d4cc5a21382120a959e5",
          "9a1af0b26a6a4807add9a2daf71df262465152bc3ee24c65e899be932385a2a8"
        ],
        [
          "a576df8e23a08411421439a4518da31880cef0fba7d4df12b1a6973eecb94266",
          "40a6bf20e76640b2c92b97afe58cd82c432e10a7f514d9f3ee8be11ae1b28ec8"
        ],
        [
          "7778a78c28dec3e30a05fe9629de8c38bb30d1f5cf9a3a208f763889be58ad71",
          "34626d9ab5a5b22ff7098e12f2ff580087b38411ff24ac563b513fc1fd9f43ac"
        ],
        [
          "928955ee637a84463729fd30e7afd2ed5f96274e5ad7e5cb09eda9c06d903ac",
          "c25621003d3f42a827b78a13093a95eeac3d26efa8a8d83fc5180e935bcd091f"
        ],
        [
          "85d0fef3ec6db109399064f3a0e3b2855645b4a907ad354527aae75163d82751",
          "1f03648413a38c0be29d496e582cf5663e8751e96877331582c237a24eb1f962"
        ],
        [
          "ff2b0dce97eece97c1c9b6041798b85dfdfb6d8882da20308f5404824526087e",
          "493d13fef524ba188af4c4dc54d07936c7b7ed6fb90e2ceb2c951e01f0c29907"
        ],
        [
          "827fbbe4b1e880ea9ed2b2e6301b212b57f1ee148cd6dd28780e5e2cf856e241",
          "c60f9c923c727b0b71bef2c67d1d12687ff7a63186903166d605b68baec293ec"
        ],
        [
          "eaa649f21f51bdbae7be4ae34ce6e5217a58fdce7f47f9aa7f3b58fa2120e2b3",
          "be3279ed5bbbb03ac69a80f89879aa5a01a6b965f13f7e59d47a5305ba5ad93d"
        ],
        [
          "e4a42d43c5cf169d9391df6decf42ee541b6d8f0c9a137401e23632dda34d24f",
          "4d9f92e716d1c73526fc99ccfb8ad34ce886eedfa8d8e4f13a7f7131deba9414"
        ],
        [
          "1ec80fef360cbdd954160fadab352b6b92b53576a88fea4947173b9d4300bf19",
          "aeefe93756b5340d2f3a4958a7abbf5e0146e77f6295a07b671cdc1cc107cefd"
        ],
        [
          "146a778c04670c2f91b00af4680dfa8bce3490717d58ba889ddb5928366642be",
          "b318e0ec3354028add669827f9d4b2870aaa971d2f7e5ed1d0b297483d83efd0"
        ],
        [
          "fa50c0f61d22e5f07e3acebb1aa07b128d0012209a28b9776d76a8793180eef9",
          "6b84c6922397eba9b72cd2872281a68a5e683293a57a213b38cd8d7d3f4f2811"
        ],
        [
          "da1d61d0ca721a11b1a5bf6b7d88e8421a288ab5d5bba5220e53d32b5f067ec2",
          "8157f55a7c99306c79c0766161c91e2966a73899d279b48a655fba0f1ad836f1"
        ],
        [
          "a8e282ff0c9706907215ff98e8fd416615311de0446f1e062a73b0610d064e13",
          "7f97355b8db81c09abfb7f3c5b2515888b679a3e50dd6bd6cef7c73111f4cc0c"
        ],
        [
          "174a53b9c9a285872d39e56e6913cab15d59b1fa512508c022f382de8319497c",
          "ccc9dc37abfc9c1657b4155f2c47f9e6646b3a1d8cb9854383da13ac079afa73"
        ],
        [
          "959396981943785c3d3e57edf5018cdbe039e730e4918b3d884fdff09475b7ba",
          "2e7e552888c331dd8ba0386a4b9cd6849c653f64c8709385e9b8abf87524f2fd"
        ],
        [
          "d2a63a50ae401e56d645a1153b109a8fcca0a43d561fba2dbb51340c9d82b151",
          "e82d86fb6443fcb7565aee58b2948220a70f750af484ca52d4142174dcf89405"
        ],
        [
          "64587e2335471eb890ee7896d7cfdc866bacbdbd3839317b3436f9b45617e073",
          "d99fcdd5bf6902e2ae96dd6447c299a185b90a39133aeab358299e5e9faf6589"
        ],
        [
          "8481bde0e4e4d885b3a546d3e549de042f0aa6cea250e7fd358d6c86dd45e458",
          "38ee7b8cba5404dd84a25bf39cecb2ca900a79c42b262e556d64b1b59779057e"
        ],
        [
          "13464a57a78102aa62b6979ae817f4637ffcfed3c4b1ce30bcd6303f6caf666b",
          "69be159004614580ef7e433453ccb0ca48f300a81d0942e13f495a907f6ecc27"
        ],
        [
          "bc4a9df5b713fe2e9aef430bcc1dc97a0cd9ccede2f28588cada3a0d2d83f366",
          "d3a81ca6e785c06383937adf4b798caa6e8a9fbfa547b16d758d666581f33c1"
        ],
        [
          "8c28a97bf8298bc0d23d8c749452a32e694b65e30a9472a3954ab30fe5324caa",
          "40a30463a3305193378fedf31f7cc0eb7ae784f0451cb9459e71dc73cbef9482"
        ],
        [
          "8ea9666139527a8c1dd94ce4f071fd23c8b350c5a4bb33748c4ba111faccae0",
          "620efabbc8ee2782e24e7c0cfb95c5d735b783be9cf0f8e955af34a30e62b945"
        ],
        [
          "dd3625faef5ba06074669716bbd3788d89bdde815959968092f76cc4eb9a9787",
          "7a188fa3520e30d461da2501045731ca941461982883395937f68d00c644a573"
        ],
        [
          "f710d79d9eb962297e4f6232b40e8f7feb2bc63814614d692c12de752408221e",
          "ea98e67232d3b3295d3b535532115ccac8612c721851617526ae47a9c77bfc82"
        ]
      ]
    },
    naf: {
      wnd: 7,
      points: [
        [
          "f9308a019258c31049344f85f89d5229b531c845836f99b08601f113bce036f9",
          "388f7b0f632de8140fe337e62a37f3566500a99934c2231b6cb9fd7584b8e672"
        ],
        [
          "2f8bde4d1a07209355b4a7250a5c5128e88b84bddc619ab7cba8d569b240efe4",
          "d8ac222636e5e3d6d4dba9dda6c9c426f788271bab0d6840dca87d3aa6ac62d6"
        ],
        [
          "5cbdf0646e5db4eaa398f365f2ea7a0e3d419b7e0330e39ce92bddedcac4f9bc",
          "6aebca40ba255960a3178d6d861a54dba813d0b813fde7b5a5082628087264da"
        ],
        [
          "acd484e2f0c7f65309ad178a9f559abde09796974c57e714c35f110dfc27ccbe",
          "cc338921b0a7d9fd64380971763b61e9add888a4375f8e0f05cc262ac64f9c37"
        ],
        [
          "774ae7f858a9411e5ef4246b70c65aac5649980be5c17891bbec17895da008cb",
          "d984a032eb6b5e190243dd56d7b7b365372db1e2dff9d6a8301d74c9c953c61b"
        ],
        [
          "f28773c2d975288bc7d1d205c3748651b075fbc6610e58cddeeddf8f19405aa8",
          "ab0902e8d880a89758212eb65cdaf473a1a06da521fa91f29b5cb52db03ed81"
        ],
        [
          "d7924d4f7d43ea965a465ae3095ff41131e5946f3c85f79e44adbcf8e27e080e",
          "581e2872a86c72a683842ec228cc6defea40af2bd896d3a5c504dc9ff6a26b58"
        ],
        [
          "defdea4cdb677750a420fee807eacf21eb9898ae79b9768766e4faa04a2d4a34",
          "4211ab0694635168e997b0ead2a93daeced1f4a04a95c0f6cfb199f69e56eb77"
        ],
        [
          "2b4ea0a797a443d293ef5cff444f4979f06acfebd7e86d277475656138385b6c",
          "85e89bc037945d93b343083b5a1c86131a01f60c50269763b570c854e5c09b7a"
        ],
        [
          "352bbf4a4cdd12564f93fa332ce333301d9ad40271f8107181340aef25be59d5",
          "321eb4075348f534d59c18259dda3e1f4a1b3b2e71b1039c67bd3d8bcf81998c"
        ],
        [
          "2fa2104d6b38d11b0230010559879124e42ab8dfeff5ff29dc9cdadd4ecacc3f",
          "2de1068295dd865b64569335bd5dd80181d70ecfc882648423ba76b532b7d67"
        ],
        [
          "9248279b09b4d68dab21a9b066edda83263c3d84e09572e269ca0cd7f5453714",
          "73016f7bf234aade5d1aa71bdea2b1ff3fc0de2a887912ffe54a32ce97cb3402"
        ],
        [
          "daed4f2be3a8bf278e70132fb0beb7522f570e144bf615c07e996d443dee8729",
          "a69dce4a7d6c98e8d4a1aca87ef8d7003f83c230f3afa726ab40e52290be1c55"
        ],
        [
          "c44d12c7065d812e8acf28d7cbb19f9011ecd9e9fdf281b0e6a3b5e87d22e7db",
          "2119a460ce326cdc76c45926c982fdac0e106e861edf61c5a039063f0e0e6482"
        ],
        [
          "6a245bf6dc698504c89a20cfded60853152b695336c28063b61c65cbd269e6b4",
          "e022cf42c2bd4a708b3f5126f16a24ad8b33ba48d0423b6efd5e6348100d8a82"
        ],
        [
          "1697ffa6fd9de627c077e3d2fe541084ce13300b0bec1146f95ae57f0d0bd6a5",
          "b9c398f186806f5d27561506e4557433a2cf15009e498ae7adee9d63d01b2396"
        ],
        [
          "605bdb019981718b986d0f07e834cb0d9deb8360ffb7f61df982345ef27a7479",
          "2972d2de4f8d20681a78d93ec96fe23c26bfae84fb14db43b01e1e9056b8c49"
        ],
        [
          "62d14dab4150bf497402fdc45a215e10dcb01c354959b10cfe31c7e9d87ff33d",
          "80fc06bd8cc5b01098088a1950eed0db01aa132967ab472235f5642483b25eaf"
        ],
        [
          "80c60ad0040f27dade5b4b06c408e56b2c50e9f56b9b8b425e555c2f86308b6f",
          "1c38303f1cc5c30f26e66bad7fe72f70a65eed4cbe7024eb1aa01f56430bd57a"
        ],
        [
          "7a9375ad6167ad54aa74c6348cc54d344cc5dc9487d847049d5eabb0fa03c8fb",
          "d0e3fa9eca8726909559e0d79269046bdc59ea10c70ce2b02d499ec224dc7f7"
        ],
        [
          "d528ecd9b696b54c907a9ed045447a79bb408ec39b68df504bb51f459bc3ffc9",
          "eecf41253136e5f99966f21881fd656ebc4345405c520dbc063465b521409933"
        ],
        [
          "49370a4b5f43412ea25f514e8ecdad05266115e4a7ecb1387231808f8b45963",
          "758f3f41afd6ed428b3081b0512fd62a54c3f3afbb5b6764b653052a12949c9a"
        ],
        [
          "77f230936ee88cbbd73df930d64702ef881d811e0e1498e2f1c13eb1fc345d74",
          "958ef42a7886b6400a08266e9ba1b37896c95330d97077cbbe8eb3c7671c60d6"
        ],
        [
          "f2dac991cc4ce4b9ea44887e5c7c0bce58c80074ab9d4dbaeb28531b7739f530",
          "e0dedc9b3b2f8dad4da1f32dec2531df9eb5fbeb0598e4fd1a117dba703a3c37"
        ],
        [
          "463b3d9f662621fb1b4be8fbbe2520125a216cdfc9dae3debcba4850c690d45b",
          "5ed430d78c296c3543114306dd8622d7c622e27c970a1de31cb377b01af7307e"
        ],
        [
          "f16f804244e46e2a09232d4aff3b59976b98fac14328a2d1a32496b49998f247",
          "cedabd9b82203f7e13d206fcdf4e33d92a6c53c26e5cce26d6579962c4e31df6"
        ],
        [
          "caf754272dc84563b0352b7a14311af55d245315ace27c65369e15f7151d41d1",
          "cb474660ef35f5f2a41b643fa5e460575f4fa9b7962232a5c32f908318a04476"
        ],
        [
          "2600ca4b282cb986f85d0f1709979d8b44a09c07cb86d7c124497bc86f082120",
          "4119b88753c15bd6a693b03fcddbb45d5ac6be74ab5f0ef44b0be9475a7e4b40"
        ],
        [
          "7635ca72d7e8432c338ec53cd12220bc01c48685e24f7dc8c602a7746998e435",
          "91b649609489d613d1d5e590f78e6d74ecfc061d57048bad9e76f302c5b9c61"
        ],
        [
          "754e3239f325570cdbbf4a87deee8a66b7f2b33479d468fbc1a50743bf56cc18",
          "673fb86e5bda30fb3cd0ed304ea49a023ee33d0197a695d0c5d98093c536683"
        ],
        [
          "e3e6bd1071a1e96aff57859c82d570f0330800661d1c952f9fe2694691d9b9e8",
          "59c9e0bba394e76f40c0aa58379a3cb6a5a2283993e90c4167002af4920e37f5"
        ],
        [
          "186b483d056a033826ae73d88f732985c4ccb1f32ba35f4b4cc47fdcf04aa6eb",
          "3b952d32c67cf77e2e17446e204180ab21fb8090895138b4a4a797f86e80888b"
        ],
        [
          "df9d70a6b9876ce544c98561f4be4f725442e6d2b737d9c91a8321724ce0963f",
          "55eb2dafd84d6ccd5f862b785dc39d4ab157222720ef9da217b8c45cf2ba2417"
        ],
        [
          "5edd5cc23c51e87a497ca815d5dce0f8ab52554f849ed8995de64c5f34ce7143",
          "efae9c8dbc14130661e8cec030c89ad0c13c66c0d17a2905cdc706ab7399a868"
        ],
        [
          "290798c2b6476830da12fe02287e9e777aa3fba1c355b17a722d362f84614fba",
          "e38da76dcd440621988d00bcf79af25d5b29c094db2a23146d003afd41943e7a"
        ],
        [
          "af3c423a95d9f5b3054754efa150ac39cd29552fe360257362dfdecef4053b45",
          "f98a3fd831eb2b749a93b0e6f35cfb40c8cd5aa667a15581bc2feded498fd9c6"
        ],
        [
          "766dbb24d134e745cccaa28c99bf274906bb66b26dcf98df8d2fed50d884249a",
          "744b1152eacbe5e38dcc887980da38b897584a65fa06cedd2c924f97cbac5996"
        ],
        [
          "59dbf46f8c94759ba21277c33784f41645f7b44f6c596a58ce92e666191abe3e",
          "c534ad44175fbc300f4ea6ce648309a042ce739a7919798cd85e216c4a307f6e"
        ],
        [
          "f13ada95103c4537305e691e74e9a4a8dd647e711a95e73cb62dc6018cfd87b8",
          "e13817b44ee14de663bf4bc808341f326949e21a6a75c2570778419bdaf5733d"
        ],
        [
          "7754b4fa0e8aced06d4167a2c59cca4cda1869c06ebadfb6488550015a88522c",
          "30e93e864e669d82224b967c3020b8fa8d1e4e350b6cbcc537a48b57841163a2"
        ],
        [
          "948dcadf5990e048aa3874d46abef9d701858f95de8041d2a6828c99e2262519",
          "e491a42537f6e597d5d28a3224b1bc25df9154efbd2ef1d2cbba2cae5347d57e"
        ],
        [
          "7962414450c76c1689c7b48f8202ec37fb224cf5ac0bfa1570328a8a3d7c77ab",
          "100b610ec4ffb4760d5c1fc133ef6f6b12507a051f04ac5760afa5b29db83437"
        ],
        [
          "3514087834964b54b15b160644d915485a16977225b8847bb0dd085137ec47ca",
          "ef0afbb2056205448e1652c48e8127fc6039e77c15c2378b7e7d15a0de293311"
        ],
        [
          "d3cc30ad6b483e4bc79ce2c9dd8bc54993e947eb8df787b442943d3f7b527eaf",
          "8b378a22d827278d89c5e9be8f9508ae3c2ad46290358630afb34db04eede0a4"
        ],
        [
          "1624d84780732860ce1c78fcbfefe08b2b29823db913f6493975ba0ff4847610",
          "68651cf9b6da903e0914448c6cd9d4ca896878f5282be4c8cc06e2a404078575"
        ],
        [
          "733ce80da955a8a26902c95633e62a985192474b5af207da6df7b4fd5fc61cd4",
          "f5435a2bd2badf7d485a4d8b8db9fcce3e1ef8e0201e4578c54673bc1dc5ea1d"
        ],
        [
          "15d9441254945064cf1a1c33bbd3b49f8966c5092171e699ef258dfab81c045c",
          "d56eb30b69463e7234f5137b73b84177434800bacebfc685fc37bbe9efe4070d"
        ],
        [
          "a1d0fcf2ec9de675b612136e5ce70d271c21417c9d2b8aaaac138599d0717940",
          "edd77f50bcb5a3cab2e90737309667f2641462a54070f3d519212d39c197a629"
        ],
        [
          "e22fbe15c0af8ccc5780c0735f84dbe9a790badee8245c06c7ca37331cb36980",
          "a855babad5cd60c88b430a69f53a1a7a38289154964799be43d06d77d31da06"
        ],
        [
          "311091dd9860e8e20ee13473c1155f5f69635e394704eaa74009452246cfa9b3",
          "66db656f87d1f04fffd1f04788c06830871ec5a64feee685bd80f0b1286d8374"
        ],
        [
          "34c1fd04d301be89b31c0442d3e6ac24883928b45a9340781867d4232ec2dbdf",
          "9414685e97b1b5954bd46f730174136d57f1ceeb487443dc5321857ba73abee"
        ],
        [
          "f219ea5d6b54701c1c14de5b557eb42a8d13f3abbcd08affcc2a5e6b049b8d63",
          "4cb95957e83d40b0f73af4544cccf6b1f4b08d3c07b27fb8d8c2962a400766d1"
        ],
        [
          "d7b8740f74a8fbaab1f683db8f45de26543a5490bca627087236912469a0b448",
          "fa77968128d9c92ee1010f337ad4717eff15db5ed3c049b3411e0315eaa4593b"
        ],
        [
          "32d31c222f8f6f0ef86f7c98d3a3335ead5bcd32abdd94289fe4d3091aa824bf",
          "5f3032f5892156e39ccd3d7915b9e1da2e6dac9e6f26e961118d14b8462e1661"
        ],
        [
          "7461f371914ab32671045a155d9831ea8793d77cd59592c4340f86cbc18347b5",
          "8ec0ba238b96bec0cbdddcae0aa442542eee1ff50c986ea6b39847b3cc092ff6"
        ],
        [
          "ee079adb1df1860074356a25aa38206a6d716b2c3e67453d287698bad7b2b2d6",
          "8dc2412aafe3be5c4c5f37e0ecc5f9f6a446989af04c4e25ebaac479ec1c8c1e"
        ],
        [
          "16ec93e447ec83f0467b18302ee620f7e65de331874c9dc72bfd8616ba9da6b5",
          "5e4631150e62fb40d0e8c2a7ca5804a39d58186a50e497139626778e25b0674d"
        ],
        [
          "eaa5f980c245f6f038978290afa70b6bd8855897f98b6aa485b96065d537bd99",
          "f65f5d3e292c2e0819a528391c994624d784869d7e6ea67fb18041024edc07dc"
        ],
        [
          "78c9407544ac132692ee1910a02439958ae04877151342ea96c4b6b35a49f51",
          "f3e0319169eb9b85d5404795539a5e68fa1fbd583c064d2462b675f194a3ddb4"
        ],
        [
          "494f4be219a1a77016dcd838431aea0001cdc8ae7a6fc688726578d9702857a5",
          "42242a969283a5f339ba7f075e36ba2af925ce30d767ed6e55f4b031880d562c"
        ],
        [
          "a598a8030da6d86c6bc7f2f5144ea549d28211ea58faa70ebf4c1e665c1fe9b5",
          "204b5d6f84822c307e4b4a7140737aec23fc63b65b35f86a10026dbd2d864e6b"
        ],
        [
          "c41916365abb2b5d09192f5f2dbeafec208f020f12570a184dbadc3e58595997",
          "4f14351d0087efa49d245b328984989d5caf9450f34bfc0ed16e96b58fa9913"
        ],
        [
          "841d6063a586fa475a724604da03bc5b92a2e0d2e0a36acfe4c73a5514742881",
          "73867f59c0659e81904f9a1c7543698e62562d6744c169ce7a36de01a8d6154"
        ],
        [
          "5e95bb399a6971d376026947f89bde2f282b33810928be4ded112ac4d70e20d5",
          "39f23f366809085beebfc71181313775a99c9aed7d8ba38b161384c746012865"
        ],
        [
          "36e4641a53948fd476c39f8a99fd974e5ec07564b5315d8bf99471bca0ef2f66",
          "d2424b1b1abe4eb8164227b085c9aa9456ea13493fd563e06fd51cf5694c78fc"
        ],
        [
          "336581ea7bfbbb290c191a2f507a41cf5643842170e914faeab27c2c579f726",
          "ead12168595fe1be99252129b6e56b3391f7ab1410cd1e0ef3dcdcabd2fda224"
        ],
        [
          "8ab89816dadfd6b6a1f2634fcf00ec8403781025ed6890c4849742706bd43ede",
          "6fdcef09f2f6d0a044e654aef624136f503d459c3e89845858a47a9129cdd24e"
        ],
        [
          "1e33f1a746c9c5778133344d9299fcaa20b0938e8acff2544bb40284b8c5fb94",
          "60660257dd11b3aa9c8ed618d24edff2306d320f1d03010e33a7d2057f3b3b6"
        ],
        [
          "85b7c1dcb3cec1b7ee7f30ded79dd20a0ed1f4cc18cbcfcfa410361fd8f08f31",
          "3d98a9cdd026dd43f39048f25a8847f4fcafad1895d7a633c6fed3c35e999511"
        ],
        [
          "29df9fbd8d9e46509275f4b125d6d45d7fbe9a3b878a7af872a2800661ac5f51",
          "b4c4fe99c775a606e2d8862179139ffda61dc861c019e55cd2876eb2a27d84b"
        ],
        [
          "a0b1cae06b0a847a3fea6e671aaf8adfdfe58ca2f768105c8082b2e449fce252",
          "ae434102edde0958ec4b19d917a6a28e6b72da1834aff0e650f049503a296cf2"
        ],
        [
          "4e8ceafb9b3e9a136dc7ff67e840295b499dfb3b2133e4ba113f2e4c0e121e5",
          "cf2174118c8b6d7a4b48f6d534ce5c79422c086a63460502b827ce62a326683c"
        ],
        [
          "d24a44e047e19b6f5afb81c7ca2f69080a5076689a010919f42725c2b789a33b",
          "6fb8d5591b466f8fc63db50f1c0f1c69013f996887b8244d2cdec417afea8fa3"
        ],
        [
          "ea01606a7a6c9cdd249fdfcfacb99584001edd28abbab77b5104e98e8e3b35d4",
          "322af4908c7312b0cfbfe369f7a7b3cdb7d4494bc2823700cfd652188a3ea98d"
        ],
        [
          "af8addbf2b661c8a6c6328655eb96651252007d8c5ea31be4ad196de8ce2131f",
          "6749e67c029b85f52a034eafd096836b2520818680e26ac8f3dfbcdb71749700"
        ],
        [
          "e3ae1974566ca06cc516d47e0fb165a674a3dabcfca15e722f0e3450f45889",
          "2aeabe7e4531510116217f07bf4d07300de97e4874f81f533420a72eeb0bd6a4"
        ],
        [
          "591ee355313d99721cf6993ffed1e3e301993ff3ed258802075ea8ced397e246",
          "b0ea558a113c30bea60fc4775460c7901ff0b053d25ca2bdeee98f1a4be5d196"
        ],
        [
          "11396d55fda54c49f19aa97318d8da61fa8584e47b084945077cf03255b52984",
          "998c74a8cd45ac01289d5833a7beb4744ff536b01b257be4c5767bea93ea57a4"
        ],
        [
          "3c5d2a1ba39c5a1790000738c9e0c40b8dcdfd5468754b6405540157e017aa7a",
          "b2284279995a34e2f9d4de7396fc18b80f9b8b9fdd270f6661f79ca4c81bd257"
        ],
        [
          "cc8704b8a60a0defa3a99a7299f2e9c3fbc395afb04ac078425ef8a1793cc030",
          "bdd46039feed17881d1e0862db347f8cf395b74fc4bcdc4e940b74e3ac1f1b13"
        ],
        [
          "c533e4f7ea8555aacd9777ac5cad29b97dd4defccc53ee7ea204119b2889b197",
          "6f0a256bc5efdf429a2fb6242f1a43a2d9b925bb4a4b3a26bb8e0f45eb596096"
        ],
        [
          "c14f8f2ccb27d6f109f6d08d03cc96a69ba8c34eec07bbcf566d48e33da6593",
          "c359d6923bb398f7fd4473e16fe1c28475b740dd098075e6c0e8649113dc3a38"
        ],
        [
          "a6cbc3046bc6a450bac24789fa17115a4c9739ed75f8f21ce441f72e0b90e6ef",
          "21ae7f4680e889bb130619e2c0f95a360ceb573c70603139862afd617fa9b9f"
        ],
        [
          "347d6d9a02c48927ebfb86c1359b1caf130a3c0267d11ce6344b39f99d43cc38",
          "60ea7f61a353524d1c987f6ecec92f086d565ab687870cb12689ff1e31c74448"
        ],
        [
          "da6545d2181db8d983f7dcb375ef5866d47c67b1bf31c8cf855ef7437b72656a",
          "49b96715ab6878a79e78f07ce5680c5d6673051b4935bd897fea824b77dc208a"
        ],
        [
          "c40747cc9d012cb1a13b8148309c6de7ec25d6945d657146b9d5994b8feb1111",
          "5ca560753be2a12fc6de6caf2cb489565db936156b9514e1bb5e83037e0fa2d4"
        ],
        [
          "4e42c8ec82c99798ccf3a610be870e78338c7f713348bd34c8203ef4037f3502",
          "7571d74ee5e0fb92a7a8b33a07783341a5492144cc54bcc40a94473693606437"
        ],
        [
          "3775ab7089bc6af823aba2e1af70b236d251cadb0c86743287522a1b3b0dedea",
          "be52d107bcfa09d8bcb9736a828cfa7fac8db17bf7a76a2c42ad961409018cf7"
        ],
        [
          "cee31cbf7e34ec379d94fb814d3d775ad954595d1314ba8846959e3e82f74e26",
          "8fd64a14c06b589c26b947ae2bcf6bfa0149ef0be14ed4d80f448a01c43b1c6d"
        ],
        [
          "b4f9eaea09b6917619f6ea6a4eb5464efddb58fd45b1ebefcdc1a01d08b47986",
          "39e5c9925b5a54b07433a4f18c61726f8bb131c012ca542eb24a8ac07200682a"
        ],
        [
          "d4263dfc3d2df923a0179a48966d30ce84e2515afc3dccc1b77907792ebcc60e",
          "62dfaf07a0f78feb30e30d6295853ce189e127760ad6cf7fae164e122a208d54"
        ],
        [
          "48457524820fa65a4f8d35eb6930857c0032acc0a4a2de422233eeda897612c4",
          "25a748ab367979d98733c38a1fa1c2e7dc6cc07db2d60a9ae7a76aaa49bd0f77"
        ],
        [
          "dfeeef1881101f2cb11644f3a2afdfc2045e19919152923f367a1767c11cceda",
          "ecfb7056cf1de042f9420bab396793c0c390bde74b4bbdff16a83ae09a9a7517"
        ],
        [
          "6d7ef6b17543f8373c573f44e1f389835d89bcbc6062ced36c82df83b8fae859",
          "cd450ec335438986dfefa10c57fea9bcc521a0959b2d80bbf74b190dca712d10"
        ],
        [
          "e75605d59102a5a2684500d3b991f2e3f3c88b93225547035af25af66e04541f",
          "f5c54754a8f71ee540b9b48728473e314f729ac5308b06938360990e2bfad125"
        ],
        [
          "eb98660f4c4dfaa06a2be453d5020bc99a0c2e60abe388457dd43fefb1ed620c",
          "6cb9a8876d9cb8520609af3add26cd20a0a7cd8a9411131ce85f44100099223e"
        ],
        [
          "13e87b027d8514d35939f2e6892b19922154596941888336dc3563e3b8dba942",
          "fef5a3c68059a6dec5d624114bf1e91aac2b9da568d6abeb2570d55646b8adf1"
        ],
        [
          "ee163026e9fd6fe017c38f06a5be6fc125424b371ce2708e7bf4491691e5764a",
          "1acb250f255dd61c43d94ccc670d0f58f49ae3fa15b96623e5430da0ad6c62b2"
        ],
        [
          "b268f5ef9ad51e4d78de3a750c2dc89b1e626d43505867999932e5db33af3d80",
          "5f310d4b3c99b9ebb19f77d41c1dee018cf0d34fd4191614003e945a1216e423"
        ],
        [
          "ff07f3118a9df035e9fad85eb6c7bfe42b02f01ca99ceea3bf7ffdba93c4750d",
          "438136d603e858a3a5c440c38eccbaddc1d2942114e2eddd4740d098ced1f0d8"
        ],
        [
          "8d8b9855c7c052a34146fd20ffb658bea4b9f69e0d825ebec16e8c3ce2b526a1",
          "cdb559eedc2d79f926baf44fb84ea4d44bcf50fee51d7ceb30e2e7f463036758"
        ],
        [
          "52db0b5384dfbf05bfa9d472d7ae26dfe4b851ceca91b1eba54263180da32b63",
          "c3b997d050ee5d423ebaf66a6db9f57b3180c902875679de924b69d84a7b375"
        ],
        [
          "e62f9490d3d51da6395efd24e80919cc7d0f29c3f3fa48c6fff543becbd43352",
          "6d89ad7ba4876b0b22c2ca280c682862f342c8591f1daf5170e07bfd9ccafa7d"
        ],
        [
          "7f30ea2476b399b4957509c88f77d0191afa2ff5cb7b14fd6d8e7d65aaab1193",
          "ca5ef7d4b231c94c3b15389a5f6311e9daff7bb67b103e9880ef4bff637acaec"
        ],
        [
          "5098ff1e1d9f14fb46a210fada6c903fef0fb7b4a1dd1d9ac60a0361800b7a00",
          "9731141d81fc8f8084d37c6e7542006b3ee1b40d60dfe5362a5b132fd17ddc0"
        ],
        [
          "32b78c7de9ee512a72895be6b9cbefa6e2f3c4ccce445c96b9f2c81e2778ad58",
          "ee1849f513df71e32efc3896ee28260c73bb80547ae2275ba497237794c8753c"
        ],
        [
          "e2cb74fddc8e9fbcd076eef2a7c72b0ce37d50f08269dfc074b581550547a4f7",
          "d3aa2ed71c9dd2247a62df062736eb0baddea9e36122d2be8641abcb005cc4a4"
        ],
        [
          "8438447566d4d7bedadc299496ab357426009a35f235cb141be0d99cd10ae3a8",
          "c4e1020916980a4da5d01ac5e6ad330734ef0d7906631c4f2390426b2edd791f"
        ],
        [
          "4162d488b89402039b584c6fc6c308870587d9c46f660b878ab65c82c711d67e",
          "67163e903236289f776f22c25fb8a3afc1732f2b84b4e95dbda47ae5a0852649"
        ],
        [
          "3fad3fa84caf0f34f0f89bfd2dcf54fc175d767aec3e50684f3ba4a4bf5f683d",
          "cd1bc7cb6cc407bb2f0ca647c718a730cf71872e7d0d2a53fa20efcdfe61826"
        ],
        [
          "674f2600a3007a00568c1a7ce05d0816c1fb84bf1370798f1c69532faeb1a86b",
          "299d21f9413f33b3edf43b257004580b70db57da0b182259e09eecc69e0d38a5"
        ],
        [
          "d32f4da54ade74abb81b815ad1fb3b263d82d6c692714bcff87d29bd5ee9f08f",
          "f9429e738b8e53b968e99016c059707782e14f4535359d582fc416910b3eea87"
        ],
        [
          "30e4e670435385556e593657135845d36fbb6931f72b08cb1ed954f1e3ce3ff6",
          "462f9bce619898638499350113bbc9b10a878d35da70740dc695a559eb88db7b"
        ],
        [
          "be2062003c51cc3004682904330e4dee7f3dcd10b01e580bf1971b04d4cad297",
          "62188bc49d61e5428573d48a74e1c655b1c61090905682a0d5558ed72dccb9bc"
        ],
        [
          "93144423ace3451ed29e0fb9ac2af211cb6e84a601df5993c419859fff5df04a",
          "7c10dfb164c3425f5c71a3f9d7992038f1065224f72bb9d1d902a6d13037b47c"
        ],
        [
          "b015f8044f5fcbdcf21ca26d6c34fb8197829205c7b7d2a7cb66418c157b112c",
          "ab8c1e086d04e813744a655b2df8d5f83b3cdc6faa3088c1d3aea1454e3a1d5f"
        ],
        [
          "d5e9e1da649d97d89e4868117a465a3a4f8a18de57a140d36b3f2af341a21b52",
          "4cb04437f391ed73111a13cc1d4dd0db1693465c2240480d8955e8592f27447a"
        ],
        [
          "d3ae41047dd7ca065dbf8ed77b992439983005cd72e16d6f996a5316d36966bb",
          "bd1aeb21ad22ebb22a10f0303417c6d964f8cdd7df0aca614b10dc14d125ac46"
        ],
        [
          "463e2763d885f958fc66cdd22800f0a487197d0a82e377b49f80af87c897b065",
          "bfefacdb0e5d0fd7df3a311a94de062b26b80c61fbc97508b79992671ef7ca7f"
        ],
        [
          "7985fdfd127c0567c6f53ec1bb63ec3158e597c40bfe747c83cddfc910641917",
          "603c12daf3d9862ef2b25fe1de289aed24ed291e0ec6708703a5bd567f32ed03"
        ],
        [
          "74a1ad6b5f76e39db2dd249410eac7f99e74c59cb83d2d0ed5ff1543da7703e9",
          "cc6157ef18c9c63cd6193d83631bbea0093e0968942e8c33d5737fd790e0db08"
        ],
        [
          "30682a50703375f602d416664ba19b7fc9bab42c72747463a71d0896b22f6da3",
          "553e04f6b018b4fa6c8f39e7f311d3176290d0e0f19ca73f17714d9977a22ff8"
        ],
        [
          "9e2158f0d7c0d5f26c3791efefa79597654e7a2b2464f52b1ee6c1347769ef57",
          "712fcdd1b9053f09003a3481fa7762e9ffd7c8ef35a38509e2fbf2629008373"
        ],
        [
          "176e26989a43c9cfeba4029c202538c28172e566e3c4fce7322857f3be327d66",
          "ed8cc9d04b29eb877d270b4878dc43c19aefd31f4eee09ee7b47834c1fa4b1c3"
        ],
        [
          "75d46efea3771e6e68abb89a13ad747ecf1892393dfc4f1b7004788c50374da8",
          "9852390a99507679fd0b86fd2b39a868d7efc22151346e1a3ca4726586a6bed8"
        ],
        [
          "809a20c67d64900ffb698c4c825f6d5f2310fb0451c869345b7319f645605721",
          "9e994980d9917e22b76b061927fa04143d096ccc54963e6a5ebfa5f3f8e286c1"
        ],
        [
          "1b38903a43f7f114ed4500b4eac7083fdefece1cf29c63528d563446f972c180",
          "4036edc931a60ae889353f77fd53de4a2708b26b6f5da72ad3394119daf408f9"
        ]
      ]
    }
  };
  return secp256k1;
}
(function(exports) {
  var curves2 = exports;
  var hash3 = hash$3;
  var curve$1 = curve;
  var utils2 = utils$a;
  var assert2 = utils2.assert;
  function PresetCurve(options) {
    if (options.type === "short")
      this.curve = new curve$1.short(options);
    else if (options.type === "edwards")
      this.curve = new curve$1.edwards(options);
    else
      this.curve = new curve$1.mont(options);
    this.g = this.curve.g;
    this.n = this.curve.n;
    this.hash = options.hash;
    assert2(this.g.validate(), "Invalid curve");
    assert2(this.g.mul(this.n).isInfinity(), "Invalid curve, G*N != O");
  }
  curves2.PresetCurve = PresetCurve;
  function defineCurve(name2, options) {
    Object.defineProperty(curves2, name2, {
      configurable: true,
      enumerable: true,
      get: function() {
        var curve2 = new PresetCurve(options);
        Object.defineProperty(curves2, name2, {
          configurable: true,
          enumerable: true,
          value: curve2
        });
        return curve2;
      }
    });
  }
  defineCurve("p192", {
    type: "short",
    prime: "p192",
    p: "ffffffff ffffffff ffffffff fffffffe ffffffff ffffffff",
    a: "ffffffff ffffffff ffffffff fffffffe ffffffff fffffffc",
    b: "64210519 e59c80e7 0fa7e9ab 72243049 feb8deec c146b9b1",
    n: "ffffffff ffffffff ffffffff 99def836 146bc9b1 b4d22831",
    hash: hash3.sha256,
    gRed: false,
    g: [
      "188da80e b03090f6 7cbf20eb 43a18800 f4ff0afd 82ff1012",
      "07192b95 ffc8da78 631011ed 6b24cdd5 73f977a1 1e794811"
    ]
  });
  defineCurve("p224", {
    type: "short",
    prime: "p224",
    p: "ffffffff ffffffff ffffffff ffffffff 00000000 00000000 00000001",
    a: "ffffffff ffffffff ffffffff fffffffe ffffffff ffffffff fffffffe",
    b: "b4050a85 0c04b3ab f5413256 5044b0b7 d7bfd8ba 270b3943 2355ffb4",
    n: "ffffffff ffffffff ffffffff ffff16a2 e0b8f03e 13dd2945 5c5c2a3d",
    hash: hash3.sha256,
    gRed: false,
    g: [
      "b70e0cbd 6bb4bf7f 321390b9 4a03c1d3 56c21122 343280d6 115c1d21",
      "bd376388 b5f723fb 4c22dfe6 cd4375a0 5a074764 44d58199 85007e34"
    ]
  });
  defineCurve("p256", {
    type: "short",
    prime: null,
    p: "ffffffff 00000001 00000000 00000000 00000000 ffffffff ffffffff ffffffff",
    a: "ffffffff 00000001 00000000 00000000 00000000 ffffffff ffffffff fffffffc",
    b: "5ac635d8 aa3a93e7 b3ebbd55 769886bc 651d06b0 cc53b0f6 3bce3c3e 27d2604b",
    n: "ffffffff 00000000 ffffffff ffffffff bce6faad a7179e84 f3b9cac2 fc632551",
    hash: hash3.sha256,
    gRed: false,
    g: [
      "6b17d1f2 e12c4247 f8bce6e5 63a440f2 77037d81 2deb33a0 f4a13945 d898c296",
      "4fe342e2 fe1a7f9b 8ee7eb4a 7c0f9e16 2bce3357 6b315ece cbb64068 37bf51f5"
    ]
  });
  defineCurve("p384", {
    type: "short",
    prime: null,
    p: "ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff fffffffe ffffffff 00000000 00000000 ffffffff",
    a: "ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff fffffffe ffffffff 00000000 00000000 fffffffc",
    b: "b3312fa7 e23ee7e4 988e056b e3f82d19 181d9c6e fe814112 0314088f 5013875a c656398d 8a2ed19d 2a85c8ed d3ec2aef",
    n: "ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff c7634d81 f4372ddf 581a0db2 48b0a77a ecec196a ccc52973",
    hash: hash3.sha384,
    gRed: false,
    g: [
      "aa87ca22 be8b0537 8eb1c71e f320ad74 6e1d3b62 8ba79b98 59f741e0 82542a38 5502f25d bf55296c 3a545e38 72760ab7",
      "3617de4a 96262c6f 5d9e98bf 9292dc29 f8f41dbd 289a147c e9da3113 b5f0b8c0 0a60b1ce 1d7e819d 7a431d7c 90ea0e5f"
    ]
  });
  defineCurve("p521", {
    type: "short",
    prime: null,
    p: "000001ff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff",
    a: "000001ff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff fffffffc",
    b: "00000051 953eb961 8e1c9a1f 929a21a0 b68540ee a2da725b 99b315f3 b8b48991 8ef109e1 56193951 ec7e937b 1652c0bd 3bb1bf07 3573df88 3d2c34f1 ef451fd4 6b503f00",
    n: "000001ff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff fffffffa 51868783 bf2f966b 7fcc0148 f709a5d0 3bb5c9b8 899c47ae bb6fb71e 91386409",
    hash: hash3.sha512,
    gRed: false,
    g: [
      "000000c6 858e06b7 0404e9cd 9e3ecb66 2395b442 9c648139 053fb521 f828af60 6b4d3dba a14b5e77 efe75928 fe1dc127 a2ffa8de 3348b3c1 856a429b f97e7e31 c2e5bd66",
      "00000118 39296a78 9a3bc004 5c8a5fb4 2c7d1bd9 98f54449 579b4468 17afbd17 273e662c 97ee7299 5ef42640 c550b901 3fad0761 353c7086 a272c240 88be9476 9fd16650"
    ]
  });
  defineCurve("curve25519", {
    type: "mont",
    prime: "p25519",
    p: "7fffffffffffffff ffffffffffffffff ffffffffffffffff ffffffffffffffed",
    a: "76d06",
    b: "1",
    n: "1000000000000000 0000000000000000 14def9dea2f79cd6 5812631a5cf5d3ed",
    hash: hash3.sha256,
    gRed: false,
    g: [
      "9"
    ]
  });
  defineCurve("ed25519", {
    type: "edwards",
    prime: "p25519",
    p: "7fffffffffffffff ffffffffffffffff ffffffffffffffff ffffffffffffffed",
    a: "-1",
    c: "1",
    // -121665 * (121666^(-1)) (mod P)
    d: "52036cee2b6ffe73 8cc740797779e898 00700a4d4141d8ab 75eb4dca135978a3",
    n: "1000000000000000 0000000000000000 14def9dea2f79cd6 5812631a5cf5d3ed",
    hash: hash3.sha256,
    gRed: false,
    g: [
      "216936d3cd6e53fec0a4e231fdd6dc5c692cc7609525a7b2c9562d608f25d51a",
      // 4/5
      "6666666666666666666666666666666666666666666666666666666666666658"
    ]
  });
  var pre;
  try {
    pre = requireSecp256k1();
  } catch (e2) {
    pre = void 0;
  }
  defineCurve("secp256k1", {
    type: "short",
    prime: "k256",
    p: "ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff fffffffe fffffc2f",
    a: "0",
    b: "7",
    n: "ffffffff ffffffff ffffffff fffffffe baaedce6 af48a03b bfd25e8c d0364141",
    h: "1",
    hash: hash3.sha256,
    // Precomputed endomorphism
    beta: "7ae96a2b657c07106e64479eac3434e99cf0497512f58995c1396c28719501ee",
    lambda: "5363ad4cc05c30e0a5261c028812645a122e22ea20816678df02967c1b23bd72",
    basis: [
      {
        a: "3086d221a7d46bcde86c90e49284eb15",
        b: "-e4437ed6010e88286f547fa90abfe4c3"
      },
      {
        a: "114ca50f7a8e2f3f657c1108d9d44cfd8",
        b: "3086d221a7d46bcde86c90e49284eb15"
      }
    ],
    gRed: false,
    g: [
      "79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798",
      "483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8",
      pre
    ]
  });
})(curves$2);
var BN$3 = bnExports;
var utils$5 = utils$a;
var assert$5 = utils$5.assert;
function KeyPair$3(ec2, options) {
  this.ec = ec2;
  this.priv = null;
  this.pub = null;
  if (options.priv)
    this._importPrivate(options.priv, options.privEnc);
  if (options.pub)
    this._importPublic(options.pub, options.pubEnc);
}
var key$1 = KeyPair$3;
KeyPair$3.fromPublic = function fromPublic2(ec2, pub2, enc) {
  if (pub2 instanceof KeyPair$3)
    return pub2;
  return new KeyPair$3(ec2, {
    pub: pub2,
    pubEnc: enc
  });
};
KeyPair$3.fromPrivate = function fromPrivate2(ec2, priv2, enc) {
  if (priv2 instanceof KeyPair$3)
    return priv2;
  return new KeyPair$3(ec2, {
    priv: priv2,
    privEnc: enc
  });
};
KeyPair$3.prototype.validate = function validate10() {
  var pub2 = this.getPublic();
  if (pub2.isInfinity())
    return { result: false, reason: "Invalid public key" };
  if (!pub2.validate())
    return { result: false, reason: "Public key is not a point" };
  if (!pub2.mul(this.ec.curve.n).isInfinity())
    return { result: false, reason: "Public key * N != O" };
  return { result: true, reason: null };
};
KeyPair$3.prototype.getPublic = function getPublic2(compact, enc) {
  if (typeof compact === "string") {
    enc = compact;
    compact = null;
  }
  if (!this.pub)
    this.pub = this.ec.g.mul(this.priv);
  if (!enc)
    return this.pub;
  return this.pub.encode(enc, compact);
};
KeyPair$3.prototype.getPrivate = function getPrivate2(enc) {
  if (enc === "hex")
    return this.priv.toString(16, 2);
  else
    return this.priv;
};
KeyPair$3.prototype._importPrivate = function _importPrivate2(key2, enc) {
  this.priv = new BN$3(key2, enc || 16);
  this.priv = this.priv.umod(this.ec.curve.n);
};
KeyPair$3.prototype._importPublic = function _importPublic2(key2, enc) {
  if (key2.x || key2.y) {
    if (this.ec.curve.type === "mont") {
      assert$5(key2.x, "Need x coordinate");
    } else if (this.ec.curve.type === "short" || this.ec.curve.type === "edwards") {
      assert$5(key2.x && key2.y, "Need both x and y coordinate");
    }
    this.pub = this.ec.curve.point(key2.x, key2.y);
    return;
  }
  this.pub = this.ec.curve.decodePoint(key2, enc);
};
KeyPair$3.prototype.derive = function derive2(pub2) {
  if (!pub2.validate()) {
    assert$5(pub2.validate(), "public point not validated");
  }
  return pub2.mul(this.priv).getX();
};
KeyPair$3.prototype.sign = function sign3(msg, enc, options) {
  return this.ec.sign(msg, this, enc, options);
};
KeyPair$3.prototype.verify = function verify3(msg, signature2) {
  return this.ec.verify(msg, signature2, this);
};
KeyPair$3.prototype.inspect = function inspect8() {
  return "<Key priv: " + (this.priv && this.priv.toString(16, 2)) + " pub: " + (this.pub && this.pub.inspect()) + " >";
};
var BN$2 = bnExports;
var utils$4 = utils$a;
var assert$4 = utils$4.assert;
function Signature$3(options, enc) {
  if (options instanceof Signature$3)
    return options;
  if (this._importDER(options, enc))
    return;
  assert$4(options.r && options.s, "Signature without r or s");
  this.r = new BN$2(options.r, 16);
  this.s = new BN$2(options.s, 16);
  if (options.recoveryParam === void 0)
    this.recoveryParam = null;
  else
    this.recoveryParam = options.recoveryParam;
}
var signature$1 = Signature$3;
function Position() {
  this.place = 0;
}
function getLength(buf, p3) {
  var initial = buf[p3.place++];
  if (!(initial & 128)) {
    return initial;
  }
  var octetLen = initial & 15;
  if (octetLen === 0 || octetLen > 4) {
    return false;
  }
  if (buf[p3.place] === 0) {
    return false;
  }
  var val = 0;
  for (var i3 = 0, off = p3.place; i3 < octetLen; i3++, off++) {
    val <<= 8;
    val |= buf[off];
    val >>>= 0;
  }
  if (val <= 127) {
    return false;
  }
  p3.place = off;
  return val;
}
function rmPadding(buf) {
  var i3 = 0;
  var len = buf.length - 1;
  while (!buf[i3] && !(buf[i3 + 1] & 128) && i3 < len) {
    i3++;
  }
  if (i3 === 0) {
    return buf;
  }
  return buf.slice(i3);
}
Signature$3.prototype._importDER = function _importDER2(data, enc) {
  data = utils$4.toArray(data, enc);
  var p3 = new Position();
  if (data[p3.place++] !== 48) {
    return false;
  }
  var len = getLength(data, p3);
  if (len === false) {
    return false;
  }
  if (len + p3.place !== data.length) {
    return false;
  }
  if (data[p3.place++] !== 2) {
    return false;
  }
  var rlen = getLength(data, p3);
  if (rlen === false) {
    return false;
  }
  if ((data[p3.place] & 128) !== 0) {
    return false;
  }
  var r2 = data.slice(p3.place, rlen + p3.place);
  p3.place += rlen;
  if (data[p3.place++] !== 2) {
    return false;
  }
  var slen = getLength(data, p3);
  if (slen === false) {
    return false;
  }
  if (data.length !== slen + p3.place) {
    return false;
  }
  if ((data[p3.place] & 128) !== 0) {
    return false;
  }
  var s2 = data.slice(p3.place, slen + p3.place);
  if (r2[0] === 0) {
    if (r2[1] & 128) {
      r2 = r2.slice(1);
    } else {
      return false;
    }
  }
  if (s2[0] === 0) {
    if (s2[1] & 128) {
      s2 = s2.slice(1);
    } else {
      return false;
    }
  }
  this.r = new BN$2(r2);
  this.s = new BN$2(s2);
  this.recoveryParam = null;
  return true;
};
function constructLength(arr, len) {
  if (len < 128) {
    arr.push(len);
    return;
  }
  var octets = 1 + (Math.log(len) / Math.LN2 >>> 3);
  arr.push(octets | 128);
  while (--octets) {
    arr.push(len >>> (octets << 3) & 255);
  }
  arr.push(len);
}
Signature$3.prototype.toDER = function toDER2(enc) {
  var r2 = this.r.toArray();
  var s2 = this.s.toArray();
  if (r2[0] & 128)
    r2 = [0].concat(r2);
  if (s2[0] & 128)
    s2 = [0].concat(s2);
  r2 = rmPadding(r2);
  s2 = rmPadding(s2);
  while (!s2[0] && !(s2[1] & 128)) {
    s2 = s2.slice(1);
  }
  var arr = [2];
  constructLength(arr, r2.length);
  arr = arr.concat(r2);
  arr.push(2);
  constructLength(arr, s2.length);
  var backHalf = arr.concat(s2);
  var res = [48];
  constructLength(res, backHalf.length);
  res = res.concat(backHalf);
  return utils$4.encode(res, enc);
};
var BN$1 = bnExports;
var HmacDRBG = hmacDrbg$1;
var utils$3 = utils$a;
var curves$1 = curves$2;
var rand = requireBrorand();
var assert$3 = utils$3.assert;
var KeyPair$2 = key$1;
var Signature$2 = signature$1;
function EC(options) {
  if (!(this instanceof EC))
    return new EC(options);
  if (typeof options === "string") {
    assert$3(
      Object.prototype.hasOwnProperty.call(curves$1, options),
      "Unknown curve " + options
    );
    options = curves$1[options];
  }
  if (options instanceof curves$1.PresetCurve)
    options = { curve: options };
  this.curve = options.curve.curve;
  this.n = this.curve.n;
  this.nh = this.n.ushrn(1);
  this.g = this.curve.g;
  this.g = options.curve.g;
  this.g.precompute(options.curve.n.bitLength() + 1);
  this.hash = options.hash || options.curve.hash;
}
var ec = EC;
EC.prototype.keyPair = function keyPair2(options) {
  return new KeyPair$2(this, options);
};
EC.prototype.keyFromPrivate = function keyFromPrivate2(priv2, enc) {
  return KeyPair$2.fromPrivate(this, priv2, enc);
};
EC.prototype.keyFromPublic = function keyFromPublic2(pub2, enc) {
  return KeyPair$2.fromPublic(this, pub2, enc);
};
EC.prototype.genKeyPair = function genKeyPair2(options) {
  if (!options)
    options = {};
  var drbg = new HmacDRBG({
    hash: this.hash,
    pers: options.pers,
    persEnc: options.persEnc || "utf8",
    entropy: options.entropy || rand(this.hash.hmacStrength),
    entropyEnc: options.entropy && options.entropyEnc || "utf8",
    nonce: this.n.toArray()
  });
  var bytes = this.n.byteLength();
  var ns2 = this.n.sub(new BN$1(2));
  for (; ; ) {
    var priv2 = new BN$1(drbg.generate(bytes));
    if (priv2.cmp(ns2) > 0)
      continue;
    priv2.iaddn(1);
    return this.keyFromPrivate(priv2);
  }
};
EC.prototype._truncateToN = function _truncateToN2(msg, truncOnly) {
  var delta = msg.byteLength() * 8 - this.n.bitLength();
  if (delta > 0)
    msg = msg.ushrn(delta);
  if (!truncOnly && msg.cmp(this.n) >= 0)
    return msg.sub(this.n);
  else
    return msg;
};
EC.prototype.sign = function sign4(msg, key2, enc, options) {
  if (typeof enc === "object") {
    options = enc;
    enc = null;
  }
  if (!options)
    options = {};
  key2 = this.keyFromPrivate(key2, enc);
  msg = this._truncateToN(new BN$1(msg, 16));
  var bytes = this.n.byteLength();
  var bkey = key2.getPrivate().toArray("be", bytes);
  var nonce = msg.toArray("be", bytes);
  var drbg = new HmacDRBG({
    hash: this.hash,
    entropy: bkey,
    nonce,
    pers: options.pers,
    persEnc: options.persEnc || "utf8"
  });
  var ns1 = this.n.sub(new BN$1(1));
  for (var iter = 0; ; iter++) {
    var k2 = options.k ? options.k(iter) : new BN$1(drbg.generate(this.n.byteLength()));
    k2 = this._truncateToN(k2, true);
    if (k2.cmpn(1) <= 0 || k2.cmp(ns1) >= 0)
      continue;
    var kp = this.g.mul(k2);
    if (kp.isInfinity())
      continue;
    var kpX = kp.getX();
    var r2 = kpX.umod(this.n);
    if (r2.cmpn(0) === 0)
      continue;
    var s2 = k2.invm(this.n).mul(r2.mul(key2.getPrivate()).iadd(msg));
    s2 = s2.umod(this.n);
    if (s2.cmpn(0) === 0)
      continue;
    var recoveryParam = (kp.getY().isOdd() ? 1 : 0) | (kpX.cmp(r2) !== 0 ? 2 : 0);
    if (options.canonical && s2.cmp(this.nh) > 0) {
      s2 = this.n.sub(s2);
      recoveryParam ^= 1;
    }
    return new Signature$2({ r: r2, s: s2, recoveryParam });
  }
};
EC.prototype.verify = function verify4(msg, signature2, key2, enc) {
  msg = this._truncateToN(new BN$1(msg, 16));
  key2 = this.keyFromPublic(key2, enc);
  signature2 = new Signature$2(signature2, "hex");
  var r2 = signature2.r;
  var s2 = signature2.s;
  if (r2.cmpn(1) < 0 || r2.cmp(this.n) >= 0)
    return false;
  if (s2.cmpn(1) < 0 || s2.cmp(this.n) >= 0)
    return false;
  var sinv = s2.invm(this.n);
  var u1 = sinv.mul(msg).umod(this.n);
  var u2 = sinv.mul(r2).umod(this.n);
  var p3;
  if (!this.curve._maxwellTrick) {
    p3 = this.g.mulAdd(u1, key2.getPublic(), u2);
    if (p3.isInfinity())
      return false;
    return p3.getX().umod(this.n).cmp(r2) === 0;
  }
  p3 = this.g.jmulAdd(u1, key2.getPublic(), u2);
  if (p3.isInfinity())
    return false;
  return p3.eqXToP(r2);
};
EC.prototype.recoverPubKey = function(msg, signature2, j2, enc) {
  assert$3((3 & j2) === j2, "The recovery param is more than two bits");
  signature2 = new Signature$2(signature2, enc);
  var n4 = this.n;
  var e2 = new BN$1(msg);
  var r2 = signature2.r;
  var s2 = signature2.s;
  var isYOdd = j2 & 1;
  var isSecondKey = j2 >> 1;
  if (r2.cmp(this.curve.p.umod(this.curve.n)) >= 0 && isSecondKey)
    throw new Error("Unable to find sencond key candinate");
  if (isSecondKey)
    r2 = this.curve.pointFromX(r2.add(this.curve.n), isYOdd);
  else
    r2 = this.curve.pointFromX(r2, isYOdd);
  var rInv = signature2.r.invm(n4);
  var s1 = n4.sub(e2).mul(rInv).umod(n4);
  var s22 = s2.mul(rInv).umod(n4);
  return this.g.mulAdd(s1, r2, s22);
};
EC.prototype.getKeyRecoveryParam = function(e2, signature2, Q2, enc) {
  signature2 = new Signature$2(signature2, enc);
  if (signature2.recoveryParam !== null)
    return signature2.recoveryParam;
  for (var i3 = 0; i3 < 4; i3++) {
    var Qprime;
    try {
      Qprime = this.recoverPubKey(e2, signature2, i3);
    } catch (e3) {
      continue;
    }
    if (Qprime.eq(Q2))
      return i3;
  }
  throw new Error("Unable to find valid recovery factor");
};
var utils$2 = utils$a;
var assert$2 = utils$2.assert;
var parseBytes$2 = utils$2.parseBytes;
var cachedProperty$1 = utils$2.cachedProperty;
function KeyPair$1(eddsa2, params) {
  this.eddsa = eddsa2;
  this._secret = parseBytes$2(params.secret);
  if (eddsa2.isPoint(params.pub))
    this._pub = params.pub;
  else
    this._pubBytes = parseBytes$2(params.pub);
}
KeyPair$1.fromPublic = function fromPublic3(eddsa2, pub2) {
  if (pub2 instanceof KeyPair$1)
    return pub2;
  return new KeyPair$1(eddsa2, { pub: pub2 });
};
KeyPair$1.fromSecret = function fromSecret(eddsa2, secret2) {
  if (secret2 instanceof KeyPair$1)
    return secret2;
  return new KeyPair$1(eddsa2, { secret: secret2 });
};
KeyPair$1.prototype.secret = function secret() {
  return this._secret;
};
cachedProperty$1(KeyPair$1, "pubBytes", function pubBytes() {
  return this.eddsa.encodePoint(this.pub());
});
cachedProperty$1(KeyPair$1, "pub", function pub() {
  if (this._pubBytes)
    return this.eddsa.decodePoint(this._pubBytes);
  return this.eddsa.g.mul(this.priv());
});
cachedProperty$1(KeyPair$1, "privBytes", function privBytes() {
  var eddsa2 = this.eddsa;
  var hash3 = this.hash();
  var lastIx = eddsa2.encodingLength - 1;
  var a3 = hash3.slice(0, eddsa2.encodingLength);
  a3[0] &= 248;
  a3[lastIx] &= 127;
  a3[lastIx] |= 64;
  return a3;
});
cachedProperty$1(KeyPair$1, "priv", function priv() {
  return this.eddsa.decodeInt(this.privBytes());
});
cachedProperty$1(KeyPair$1, "hash", function hash() {
  return this.eddsa.hash().update(this.secret()).digest();
});
cachedProperty$1(KeyPair$1, "messagePrefix", function messagePrefix2() {
  return this.hash().slice(this.eddsa.encodingLength);
});
KeyPair$1.prototype.sign = function sign5(message) {
  assert$2(this._secret, "KeyPair can only verify");
  return this.eddsa.sign(message, this);
};
KeyPair$1.prototype.verify = function verify5(message, sig) {
  return this.eddsa.verify(message, sig, this);
};
KeyPair$1.prototype.getSecret = function getSecret(enc) {
  assert$2(this._secret, "KeyPair is public only");
  return utils$2.encode(this.secret(), enc);
};
KeyPair$1.prototype.getPublic = function getPublic3(enc) {
  return utils$2.encode(this.pubBytes(), enc);
};
var key = KeyPair$1;
var BN = bnExports;
var utils$1 = utils$a;
var assert$1 = utils$1.assert;
var cachedProperty = utils$1.cachedProperty;
var parseBytes$1 = utils$1.parseBytes;
function Signature$1(eddsa2, sig) {
  this.eddsa = eddsa2;
  if (typeof sig !== "object")
    sig = parseBytes$1(sig);
  if (Array.isArray(sig)) {
    assert$1(sig.length === eddsa2.encodingLength * 2, "Signature has invalid size");
    sig = {
      R: sig.slice(0, eddsa2.encodingLength),
      S: sig.slice(eddsa2.encodingLength)
    };
  }
  assert$1(sig.R && sig.S, "Signature without R or S");
  if (eddsa2.isPoint(sig.R))
    this._R = sig.R;
  if (sig.S instanceof BN)
    this._S = sig.S;
  this._Rencoded = Array.isArray(sig.R) ? sig.R : sig.Rencoded;
  this._Sencoded = Array.isArray(sig.S) ? sig.S : sig.Sencoded;
}
cachedProperty(Signature$1, "S", function S() {
  return this.eddsa.decodeInt(this.Sencoded());
});
cachedProperty(Signature$1, "R", function R() {
  return this.eddsa.decodePoint(this.Rencoded());
});
cachedProperty(Signature$1, "Rencoded", function Rencoded() {
  return this.eddsa.encodePoint(this.R());
});
cachedProperty(Signature$1, "Sencoded", function Sencoded() {
  return this.eddsa.encodeInt(this.S());
});
Signature$1.prototype.toBytes = function toBytes() {
  return this.Rencoded().concat(this.Sencoded());
};
Signature$1.prototype.toHex = function toHex() {
  return utils$1.encode(this.toBytes(), "hex").toUpperCase();
};
var signature = Signature$1;
var hash2 = hash$3;
var curves = curves$2;
var utils = utils$a;
var assert = utils.assert;
var parseBytes = utils.parseBytes;
var KeyPair = key;
var Signature = signature;
function EDDSA(curve2) {
  assert(curve2 === "ed25519", "only tested with ed25519 so far");
  if (!(this instanceof EDDSA))
    return new EDDSA(curve2);
  curve2 = curves[curve2].curve;
  this.curve = curve2;
  this.g = curve2.g;
  this.g.precompute(curve2.n.bitLength() + 1);
  this.pointClass = curve2.point().constructor;
  this.encodingLength = Math.ceil(curve2.n.bitLength() / 8);
  this.hash = hash2.sha512;
}
var eddsa = EDDSA;
EDDSA.prototype.sign = function sign6(message, secret2) {
  message = parseBytes(message);
  var key2 = this.keyFromSecret(secret2);
  var r2 = this.hashInt(key2.messagePrefix(), message);
  var R3 = this.g.mul(r2);
  var Rencoded2 = this.encodePoint(R3);
  var s_ = this.hashInt(Rencoded2, key2.pubBytes(), message).mul(key2.priv());
  var S5 = r2.add(s_).umod(this.curve.n);
  return this.makeSignature({ R: R3, S: S5, Rencoded: Rencoded2 });
};
EDDSA.prototype.verify = function verify6(message, sig, pub2) {
  message = parseBytes(message);
  sig = this.makeSignature(sig);
  if (sig.S().gte(sig.eddsa.curve.n) || sig.S().isNeg()) {
    return false;
  }
  var key2 = this.keyFromPublic(pub2);
  var h4 = this.hashInt(sig.Rencoded(), key2.pubBytes(), message);
  var SG = this.g.mul(sig.S());
  var RplusAh = sig.R().add(key2.pub().mul(h4));
  return RplusAh.eq(SG);
};
EDDSA.prototype.hashInt = function hashInt() {
  var hash3 = this.hash();
  for (var i3 = 0; i3 < arguments.length; i3++)
    hash3.update(arguments[i3]);
  return utils.intFromLE(hash3.digest()).umod(this.curve.n);
};
EDDSA.prototype.keyFromPublic = function keyFromPublic3(pub2) {
  return KeyPair.fromPublic(this, pub2);
};
EDDSA.prototype.keyFromSecret = function keyFromSecret(secret2) {
  return KeyPair.fromSecret(this, secret2);
};
EDDSA.prototype.makeSignature = function makeSignature(sig) {
  if (sig instanceof Signature)
    return sig;
  return new Signature(this, sig);
};
EDDSA.prototype.encodePoint = function encodePoint(point7) {
  var enc = point7.getY().toArray("le", this.encodingLength);
  enc[this.encodingLength - 1] |= point7.getX().isOdd() ? 128 : 0;
  return enc;
};
EDDSA.prototype.decodePoint = function decodePoint4(bytes) {
  bytes = utils.parseBytes(bytes);
  var lastIx = bytes.length - 1;
  var normed = bytes.slice(0, lastIx).concat(bytes[lastIx] & ~128);
  var xIsOdd = (bytes[lastIx] & 128) !== 0;
  var y3 = utils.intFromLE(normed);
  return this.curve.pointFromY(y3, xIsOdd);
};
EDDSA.prototype.encodeInt = function encodeInt(num) {
  return num.toArray("le", this.encodingLength);
};
EDDSA.prototype.decodeInt = function decodeInt(bytes) {
  return utils.intFromLE(bytes);
};
EDDSA.prototype.isPoint = function isPoint(val) {
  return val instanceof this.pointClass;
};
(function(exports) {
  var elliptic2 = exports;
  elliptic2.version = require$$0$2.version;
  elliptic2.utils = utils$a;
  elliptic2.rand = requireBrorand();
  elliptic2.curve = curve;
  elliptic2.curves = curves$2;
  elliptic2.ec = ec;
  elliptic2.eddsa = eddsa;
})(elliptic);
const C$2 = { waku: { publish: "waku_publish", batchPublish: "waku_batchPublish", subscribe: "waku_subscribe", batchSubscribe: "waku_batchSubscribe", subscription: "waku_subscription", unsubscribe: "waku_unsubscribe", batchUnsubscribe: "waku_batchUnsubscribe", batchFetchMessages: "waku_batchFetchMessages" }, irn: { publish: "irn_publish", batchPublish: "irn_batchPublish", subscribe: "irn_subscribe", batchSubscribe: "irn_batchSubscribe", subscription: "irn_subscription", unsubscribe: "irn_unsubscribe", batchUnsubscribe: "irn_batchUnsubscribe", batchFetchMessages: "irn_batchFetchMessages" }, iridium: { publish: "iridium_publish", batchPublish: "iridium_batchPublish", subscribe: "iridium_subscribe", batchSubscribe: "iridium_batchSubscribe", subscription: "iridium_subscription", unsubscribe: "iridium_unsubscribe", batchUnsubscribe: "iridium_batchUnsubscribe", batchFetchMessages: "iridium_batchFetchMessages" } };
var define_process_env_default = {};
const H$1 = ":";
function re$2(e2) {
  const [n4, t] = e2.split(H$1);
  return { namespace: n4, reference: t };
}
function W$2(e2, n4) {
  return e2.includes(":") ? [e2] : n4.chains || [];
}
var gt$3 = Object.defineProperty, Ke = Object.getOwnPropertySymbols, vt$2 = Object.prototype.hasOwnProperty, bt$2 = Object.prototype.propertyIsEnumerable, Le$1 = (e2, n4, t) => n4 in e2 ? gt$3(e2, n4, { enumerable: true, configurable: true, writable: true, value: t }) : e2[n4] = t, Fe = (e2, n4) => {
  for (var t in n4 || (n4 = {})) vt$2.call(n4, t) && Le$1(e2, t, n4[t]);
  if (Ke) for (var t of Ke(n4)) bt$2.call(n4, t) && Le$1(e2, t, n4[t]);
  return e2;
};
const qe = "ReactNative", y$1 = { reactNative: "react-native", node: "node", browser: "browser", unknown: "unknown" }, He = "js";
function ce$1() {
  return typeof process$1 < "u" && typeof process$1.versions < "u" && typeof process$1.versions.node < "u";
}
function _$1() {
  return !getDocument_1() && !!getNavigator_1() && navigator.product === qe;
}
function V$3() {
  return !ce$1() && !!getNavigator_1() && !!getDocument_1();
}
function P$2() {
  return _$1() ? y$1.reactNative : ce$1() ? y$1.node : V$3() ? y$1.browser : y$1.unknown;
}
function Ot$2() {
  var e2;
  try {
    return _$1() && typeof global < "u" && typeof (global == null ? void 0 : global.Application) < "u" ? (e2 = global.Application) == null ? void 0 : e2.applicationId : void 0;
  } catch {
    return;
  }
}
function We$2(e2, n4) {
  let t = queryString.parse(e2);
  return t = Fe(Fe({}, t), n4), e2 = queryString.stringify(t), e2;
}
function Nt$2() {
  return getWindowMetadata_1() || { name: "", description: "", url: "", icons: [""] };
}
function Je$1() {
  if (P$2() === y$1.reactNative && typeof global < "u" && typeof (global == null ? void 0 : global.Platform) < "u") {
    const { OS: t, Version: r2 } = global.Platform;
    return [t, r2].join("-");
  }
  const e2 = detect();
  if (e2 === null) return "unknown";
  const n4 = e2.os ? e2.os.replace(" ", "").toLowerCase() : "unknown";
  return e2.type === "browser" ? [n4, e2.name, e2.version].join("-") : [n4, e2.version].join("-");
}
function ze() {
  var e2;
  const n4 = P$2();
  return n4 === y$1.browser ? [n4, ((e2 = getLocation_1()) == null ? void 0 : e2.host) || "unknown"].join(":") : n4;
}
function Ge(e2, n4, t) {
  const r2 = Je$1(), o3 = ze();
  return [[e2, n4].join("-"), [He, t].join("-"), r2, o3].join("/");
}
function $t$2({ protocol: e2, version: n4, relayUrl: t, sdkVersion: r2, auth: o3, projectId: s2, useOnCloseEvent: i3, bundleId: u2 }) {
  const l2 = t.split("?"), c2 = Ge(e2, n4, r2), d4 = { auth: o3, ua: c2, projectId: s2, useOnCloseEvent: i3 || void 0, origin: u2 || void 0 }, a3 = We$2(l2[1] || "", d4);
  return l2[0] + "?" + a3;
}
function $$2(e2, n4) {
  return e2.filter((t) => n4.includes(t)).length === e2.length;
}
function Tt$2(e2) {
  return Object.fromEntries(e2.entries());
}
function Pt$2(e2) {
  return new Map(Object.entries(e2));
}
function _t$2(e2 = cjs$3.FIVE_MINUTES, n4) {
  const t = cjs$3.toMiliseconds(e2 || cjs$3.FIVE_MINUTES);
  let r2, o3, s2;
  return { resolve: (i3) => {
    s2 && r2 && (clearTimeout(s2), r2(i3));
  }, reject: (i3) => {
    s2 && o3 && (clearTimeout(s2), o3(i3));
  }, done: () => new Promise((i3, u2) => {
    s2 = setTimeout(() => {
      u2(new Error(n4));
    }, t), r2 = i3, o3 = u2;
  }) };
}
function kt$2(e2, n4, t) {
  return new Promise(async (r2, o3) => {
    const s2 = setTimeout(() => o3(new Error(t)), n4);
    try {
      const i3 = await e2;
      r2(i3);
    } catch (i3) {
      o3(i3);
    }
    clearTimeout(s2);
  });
}
function ae$2(e2, n4) {
  if (typeof n4 == "string" && n4.startsWith(`${e2}:`)) return n4;
  if (e2.toLowerCase() === "topic") {
    if (typeof n4 != "string") throw new Error('Value must be "string" for expirer target type: topic');
    return `topic:${n4}`;
  } else if (e2.toLowerCase() === "id") {
    if (typeof n4 != "number") throw new Error('Value must be "number" for expirer target type: id');
    return `id:${n4}`;
  }
  throw new Error(`Unknown expirer target type: ${e2}`);
}
function Dt$2(e2) {
  return ae$2("topic", e2);
}
function xt$2(e2) {
  return ae$2("id", e2);
}
function Vt$2(e2) {
  const [n4, t] = e2.split(":"), r2 = { id: void 0, topic: void 0 };
  if (n4 === "topic" && typeof t == "string") r2.topic = t;
  else if (n4 === "id" && Number.isInteger(Number(t))) r2.id = Number(t);
  else throw new Error(`Invalid target, expected id:number or topic:string, got ${n4}:${t}`);
  return r2;
}
function Mt$2(e2, n4) {
  return cjs$3.fromMiliseconds(Date.now() + cjs$3.toMiliseconds(e2));
}
function Kt$2(e2) {
  return Date.now() >= cjs$3.toMiliseconds(e2);
}
function Lt$2(e2, n4) {
  return `${e2}${n4 ? `:${n4}` : ""}`;
}
function N(e2 = [], n4 = []) {
  return [.../* @__PURE__ */ new Set([...e2, ...n4])];
}
async function Ft$2({ id: e2, topic: n4, wcDeepLink: t }) {
  var r2;
  try {
    if (!t) return;
    const o3 = typeof t == "string" ? JSON.parse(t) : t, s2 = o3 == null ? void 0 : o3.href;
    if (typeof s2 != "string") return;
    const i3 = Xe$1(s2, e2, n4), u2 = P$2();
    if (u2 === y$1.browser) {
      if (!((r2 = getDocument_1()) != null && r2.hasFocus())) {
        console.warn("Document does not have focus, skipping deeplink.");
        return;
      }
      i3.startsWith("https://") || i3.startsWith("http://") ? window.open(i3, "_blank", "noreferrer noopener") : window.open(i3, en$1() ? "_blank" : "_self", "noreferrer noopener");
    } else u2 === y$1.reactNative && typeof (global == null ? void 0 : global.Linking) < "u" && await global.Linking.openURL(i3);
  } catch (o3) {
    console.error(o3);
  }
}
function Xe$1(e2, n4, t) {
  const r2 = `requestId=${n4}&sessionTopic=${t}`;
  e2.endsWith("/") && (e2 = e2.slice(0, -1));
  let o3 = `${e2}`;
  if (e2.startsWith("https://t.me")) {
    const s2 = e2.includes("?") ? "&startapp=" : "?startapp=";
    o3 = `${o3}${s2}${nn$1(r2, true)}`;
  } else o3 = `${o3}/wc?${r2}`;
  return o3;
}
async function qt$2(e2, n4) {
  let t = "";
  try {
    if (V$3() && (t = localStorage.getItem(n4), t)) return t;
    t = await e2.getItem(n4);
  } catch (r2) {
    console.error(r2);
  }
  return t;
}
function Bt$2(e2, n4) {
  if (!e2.includes(n4)) return null;
  const t = e2.split(/([&,?,=])/), r2 = t.indexOf(n4);
  return t[r2 + 2];
}
function Ht$2() {
  return typeof crypto < "u" && crypto != null && crypto.randomUUID ? crypto.randomUUID() : "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx".replace(/[xy]/gu, (e2) => {
    const n4 = Math.random() * 16 | 0;
    return (e2 === "x" ? n4 : n4 & 3 | 8).toString(16);
  });
}
function Wt$2() {
  return typeof process$1 < "u" && define_process_env_default.IS_VITEST === "true";
}
function en$1() {
  return typeof window < "u" && (!!window.TelegramWebviewProxy || !!window.Telegram || !!window.TelegramWebviewProxyProto);
}
function nn$1(e2, n4 = false) {
  const t = Buffer$1.from(e2).toString("base64");
  return n4 ? t.replace(/[=]/g, "") : t;
}
function le$1(e2) {
  return Buffer$1.from(e2, "base64").toString("utf-8");
}
const Jt$2 = "https://rpc.walletconnect.org/v1";
async function tn$1(e2, n4, t, r2, o3, s2) {
  switch (t.t) {
    case "eip191":
      return rn$1(e2, n4, t.s);
    case "eip1271":
      return await on$1(e2, n4, t.s, r2, o3, s2);
    default:
      throw new Error(`verifySignature failed: Attempted to verify CacaoSignature with unknown type: ${t.t}`);
  }
}
function rn$1(e2, n4, t) {
  return recoverAddress(hashMessage(n4), t).toLowerCase() === e2.toLowerCase();
}
async function on$1(e2, n4, t, r2, o3, s2) {
  const i3 = re$2(r2);
  if (!i3.namespace || !i3.reference) throw new Error(`isValidEip1271Signature failed: chainId must be in CAIP-2 format, received: ${r2}`);
  try {
    const u2 = "0x1626ba7e", l2 = "0000000000000000000000000000000000000000000000000000000000000040", c2 = "0000000000000000000000000000000000000000000000000000000000000041", d4 = t.substring(2), a3 = hashMessage(n4).substring(2), f3 = u2 + a3 + l2 + c2 + d4, h4 = await fetch(`${s2 || Jt$2}/?chainId=${r2}&projectId=${o3}`, { method: "POST", body: JSON.stringify({ id: zt$2(), jsonrpc: "2.0", method: "eth_call", params: [{ to: e2, data: f3 }, "latest"] }) }), { result: p3 } = await h4.json();
    return p3 ? p3.slice(0, u2.length).toLowerCase() === u2.toLowerCase() : false;
  } catch (u2) {
    return console.error("isValidEip1271Signature: ", u2), false;
  }
}
function zt$2() {
  return Date.now() + Math.floor(Math.random() * 1e3);
}
var Gt$2 = Object.defineProperty, Yt$2 = Object.defineProperties, Qt$2 = Object.getOwnPropertyDescriptors, sn$1 = Object.getOwnPropertySymbols, Zt$2 = Object.prototype.hasOwnProperty, Xt$2 = Object.prototype.propertyIsEnumerable, cn$1 = (e2, n4, t) => n4 in e2 ? Gt$2(e2, n4, { enumerable: true, configurable: true, writable: true, value: t }) : e2[n4] = t, de$1 = (e2, n4) => {
  for (var t in n4 || (n4 = {})) Zt$2.call(n4, t) && cn$1(e2, t, n4[t]);
  if (sn$1) for (var t of sn$1(n4)) Xt$2.call(n4, t) && cn$1(e2, t, n4[t]);
  return e2;
}, an$1 = (e2, n4) => Yt$2(e2, Qt$2(n4));
const er$2 = "did:pkh:", z$4 = (e2) => e2 == null ? void 0 : e2.split(":"), un$1 = (e2) => {
  const n4 = e2 && z$4(e2);
  if (n4) return e2.includes(er$2) ? n4[3] : n4[1];
}, ln$1 = (e2) => {
  const n4 = e2 && z$4(e2);
  if (n4) return n4[2] + ":" + n4[3];
}, fe$2 = (e2) => {
  const n4 = e2 && z$4(e2);
  if (n4) return n4.pop();
};
async function nr$2(e2) {
  const { cacao: n4, projectId: t } = e2, { s: r2, p: o3 } = n4, s2 = dn$1(o3, o3.iss), i3 = fe$2(o3.iss);
  return await tn$1(i3, s2, r2, ln$1(o3.iss), t);
}
const dn$1 = (e2, n4) => {
  const t = `${e2.domain} wants you to sign in with your Ethereum account:`, r2 = fe$2(n4);
  if (!e2.aud && !e2.uri) throw new Error("Either `aud` or `uri` is required to construct the message");
  let o3 = e2.statement || void 0;
  const s2 = `URI: ${e2.aud || e2.uri}`, i3 = `Version: ${e2.version}`, u2 = `Chain ID: ${un$1(n4)}`, l2 = `Nonce: ${e2.nonce}`, c2 = `Issued At: ${e2.iat}`, d4 = e2.exp ? `Expiration Time: ${e2.exp}` : void 0, a3 = e2.nbf ? `Not Before: ${e2.nbf}` : void 0, f3 = e2.requestId ? `Request ID: ${e2.requestId}` : void 0, h4 = e2.resources ? `Resources:${e2.resources.map((m2) => `
- ${m2}`).join("")}` : void 0, p3 = Y$2(e2.resources);
  if (p3) {
    const m2 = R$2(p3);
    o3 = he$1(o3, m2);
  }
  return [t, r2, "", o3, "", s2, i3, u2, l2, c2, d4, a3, f3, h4].filter((m2) => m2 != null).join(`
`);
};
function hn$1(e2) {
  return Buffer$1.from(JSON.stringify(e2)).toString("base64");
}
function yn$1(e2) {
  return JSON.parse(Buffer$1.from(e2, "base64").toString("utf-8"));
}
function O$3(e2) {
  if (!e2) throw new Error("No recap provided, value is undefined");
  if (!e2.att) throw new Error("No `att` property found");
  const n4 = Object.keys(e2.att);
  if (!(n4 != null && n4.length)) throw new Error("No resources found in `att` property");
  n4.forEach((t) => {
    const r2 = e2.att[t];
    if (Array.isArray(r2)) throw new Error(`Resource must be an object: ${t}`);
    if (typeof r2 != "object") throw new Error(`Resource must be an object: ${t}`);
    if (!Object.keys(r2).length) throw new Error(`Resource object is empty: ${t}`);
    Object.keys(r2).forEach((o3) => {
      const s2 = r2[o3];
      if (!Array.isArray(s2)) throw new Error(`Ability limits ${o3} must be an array of objects, found: ${s2}`);
      if (!s2.length) throw new Error(`Value of ${o3} is empty array, must be an array with objects`);
      s2.forEach((i3) => {
        if (typeof i3 != "object") throw new Error(`Ability limits (${o3}) must be an array of objects, found: ${i3}`);
      });
    });
  });
}
function gn$1(e2, n4, t, r2 = {}) {
  return t == null ? void 0 : t.sort((o3, s2) => o3.localeCompare(s2)), { att: { [e2]: pe$1(n4, t, r2) } };
}
function pe$1(e2, n4, t = {}) {
  n4 = n4 == null ? void 0 : n4.sort((o3, s2) => o3.localeCompare(s2));
  const r2 = n4.map((o3) => ({ [`${e2}/${o3}`]: [t] }));
  return Object.assign({}, ...r2);
}
function G$1(e2) {
  return O$3(e2), `urn:recap:${hn$1(e2).replace(/=/g, "")}`;
}
function R$2(e2) {
  const n4 = yn$1(e2.replace("urn:recap:", ""));
  return O$3(n4), n4;
}
function ir$2(e2, n4, t) {
  const r2 = gn$1(e2, n4, t);
  return G$1(r2);
}
function me$3(e2) {
  return e2 && e2.includes("urn:recap:");
}
function cr$2(e2, n4) {
  const t = R$2(e2), r2 = R$2(n4), o3 = bn$1(t, r2);
  return G$1(o3);
}
function bn$1(e2, n4) {
  O$3(e2), O$3(n4);
  const t = Object.keys(e2.att).concat(Object.keys(n4.att)).sort((o3, s2) => o3.localeCompare(s2)), r2 = { att: {} };
  return t.forEach((o3) => {
    var s2, i3;
    Object.keys(((s2 = e2.att) == null ? void 0 : s2[o3]) || {}).concat(Object.keys(((i3 = n4.att) == null ? void 0 : i3[o3]) || {})).sort((u2, l2) => u2.localeCompare(l2)).forEach((u2) => {
      var l2, c2;
      r2.att[o3] = an$1(de$1({}, r2.att[o3]), { [u2]: ((l2 = e2.att[o3]) == null ? void 0 : l2[u2]) || ((c2 = n4.att[o3]) == null ? void 0 : c2[u2]) });
    });
  }), r2;
}
function he$1(e2 = "", n4) {
  O$3(n4);
  const t = "I further authorize the stated URI to perform the following actions on my behalf: ";
  if (e2.includes(t)) return e2;
  const r2 = [];
  let o3 = 0;
  Object.keys(n4.att).forEach((u2) => {
    const l2 = Object.keys(n4.att[u2]).map((a3) => ({ ability: a3.split("/")[0], action: a3.split("/")[1] }));
    l2.sort((a3, f3) => a3.action.localeCompare(f3.action));
    const c2 = {};
    l2.forEach((a3) => {
      c2[a3.ability] || (c2[a3.ability] = []), c2[a3.ability].push(a3.action);
    });
    const d4 = Object.keys(c2).map((a3) => (o3++, `(${o3}) '${a3}': '${c2[a3].join("', '")}' for '${u2}'.`));
    r2.push(d4.join(", ").replace(".,", "."));
  });
  const s2 = r2.join(" "), i3 = `${t}${s2}`;
  return `${e2 ? e2 + " " : ""}${i3}`;
}
function ar$2(e2) {
  var n4;
  const t = R$2(e2);
  O$3(t);
  const r2 = (n4 = t.att) == null ? void 0 : n4.eip155;
  return r2 ? Object.keys(r2).map((o3) => o3.split("/")[1]) : [];
}
function ur$2(e2) {
  const n4 = R$2(e2);
  O$3(n4);
  const t = [];
  return Object.values(n4.att).forEach((r2) => {
    Object.values(r2).forEach((o3) => {
      var s2;
      (s2 = o3 == null ? void 0 : o3[0]) != null && s2.chains && t.push(o3[0].chains);
    });
  }), [...new Set(t.flat())];
}
function Y$2(e2) {
  if (!e2) return;
  const n4 = e2 == null ? void 0 : e2[e2.length - 1];
  return me$3(n4) ? n4 : void 0;
}
const ye$3 = "base10", g$1 = "base16", ge$1 = "base64pad", lr$2 = "base64url", k$1 = "utf8", ve$1 = 0, D$2 = 1, M$3 = 2, dr$2 = 0, wn = 1, K$2 = 12, be$3 = 32;
function fr$2() {
  const e2 = x25519.generateKeyPair();
  return { privateKey: toString(e2.secretKey, g$1), publicKey: toString(e2.publicKey, g$1) };
}
function pr$2() {
  const e2 = random.randomBytes(be$3);
  return toString(e2, g$1);
}
function mr$2(e2, n4) {
  const t = x25519.sharedKey(fromString(e2, g$1), fromString(n4, g$1), true), r2 = new HKDF_1(sha256.SHA256, t).expand(be$3);
  return toString(r2, g$1);
}
function hr$2(e2) {
  const n4 = sha256.hash(fromString(e2, g$1));
  return toString(n4, g$1);
}
function yr$2(e2) {
  const n4 = sha256.hash(fromString(e2, k$1));
  return toString(n4, g$1);
}
function Ee$2(e2) {
  return fromString(`${e2}`, ye$3);
}
function A(e2) {
  return Number(toString(e2, ye$3));
}
function gr$2(e2) {
  const n4 = Ee$2(typeof e2.type < "u" ? e2.type : ve$1);
  if (A(n4) === D$2 && typeof e2.senderPublicKey > "u") throw new Error("Missing sender public key for type 1 envelope");
  const t = typeof e2.senderPublicKey < "u" ? fromString(e2.senderPublicKey, g$1) : void 0, r2 = typeof e2.iv < "u" ? fromString(e2.iv, g$1) : random.randomBytes(K$2), o3 = new chacha20poly1305.ChaCha20Poly1305(fromString(e2.symKey, g$1)).seal(r2, fromString(e2.message, k$1));
  return we$3({ type: n4, sealed: o3, iv: r2, senderPublicKey: t, encoding: e2.encoding });
}
function vr$2(e2, n4) {
  const t = Ee$2(M$3), r2 = random.randomBytes(K$2), o3 = fromString(e2, k$1);
  return we$3({ type: t, sealed: o3, iv: r2, encoding: n4 });
}
function br$2(e2) {
  const n4 = new chacha20poly1305.ChaCha20Poly1305(fromString(e2.symKey, g$1)), { sealed: t, iv: r2 } = Q$1({ encoded: e2.encoded, encoding: e2 == null ? void 0 : e2.encoding }), o3 = n4.open(r2, t);
  if (o3 === null) throw new Error("Failed to decrypt");
  return toString(o3, k$1);
}
function Er$2(e2, n4) {
  const { sealed: t } = Q$1({ encoded: e2, encoding: n4 });
  return toString(t, k$1);
}
function we$3(e2) {
  const { encoding: n4 = ge$1 } = e2;
  if (A(e2.type) === M$3) return toString(concat$1([e2.type, e2.sealed]), n4);
  if (A(e2.type) === D$2) {
    if (typeof e2.senderPublicKey > "u") throw new Error("Missing sender public key for type 1 envelope");
    return toString(concat$1([e2.type, e2.senderPublicKey, e2.iv, e2.sealed]), n4);
  }
  return toString(concat$1([e2.type, e2.iv, e2.sealed]), n4);
}
function Q$1(e2) {
  const { encoded: n4, encoding: t = ge$1 } = e2, r2 = fromString(n4, t), o3 = r2.slice(dr$2, wn), s2 = wn;
  if (A(o3) === D$2) {
    const c2 = s2 + be$3, d4 = c2 + K$2, a3 = r2.slice(s2, c2), f3 = r2.slice(c2, d4), h4 = r2.slice(d4);
    return { type: o3, sealed: h4, iv: f3, senderPublicKey: a3 };
  }
  if (A(o3) === M$3) {
    const c2 = r2.slice(s2), d4 = random.randomBytes(K$2);
    return { type: o3, sealed: c2, iv: d4 };
  }
  const i3 = s2 + K$2, u2 = r2.slice(s2, i3), l2 = r2.slice(i3);
  return { type: o3, sealed: l2, iv: u2 };
}
function wr$2(e2, n4) {
  const t = Q$1({ encoded: e2, encoding: n4 == null ? void 0 : n4.encoding });
  return On({ type: A(t.type), senderPublicKey: typeof t.senderPublicKey < "u" ? toString(t.senderPublicKey, g$1) : void 0, receiverPublicKey: n4 == null ? void 0 : n4.receiverPublicKey });
}
function On(e2) {
  const n4 = (e2 == null ? void 0 : e2.type) || ve$1;
  if (n4 === D$2) {
    if (typeof (e2 == null ? void 0 : e2.senderPublicKey) > "u") throw new Error("missing sender public key");
    if (typeof (e2 == null ? void 0 : e2.receiverPublicKey) > "u") throw new Error("missing receiver public key");
  }
  return { type: n4, senderPublicKey: e2 == null ? void 0 : e2.senderPublicKey, receiverPublicKey: e2 == null ? void 0 : e2.receiverPublicKey };
}
function Or$2(e2) {
  return e2.type === D$2 && typeof e2.senderPublicKey == "string" && typeof e2.receiverPublicKey == "string";
}
function Nr$2(e2) {
  return e2.type === M$3;
}
function Nn(e2) {
  return new elliptic.ec("p256").keyFromPublic({ x: Buffer$1.from(e2.x, "base64").toString("hex"), y: Buffer$1.from(e2.y, "base64").toString("hex") }, "hex");
}
function Sr$2(e2) {
  let n4 = e2.replace(/-/g, "+").replace(/_/g, "/");
  const t = n4.length % 4;
  return t > 0 && (n4 += "=".repeat(4 - t)), n4;
}
function $r$2(e2) {
  return Buffer$1.from(Sr$2(e2), "base64");
}
function Rr$2(e2, n4) {
  const [t, r2, o3] = e2.split("."), s2 = $r$2(o3);
  if (s2.length !== 64) throw new Error("Invalid signature length");
  const i3 = s2.slice(0, 32).toString("hex"), u2 = s2.slice(32, 64).toString("hex"), l2 = `${t}.${r2}`, c2 = new sha256.SHA256().update(Buffer$1.from(l2)).digest(), d4 = Nn(n4), a3 = Buffer$1.from(c2).toString("hex");
  if (!d4.verify(a3, { r: i3, s: u2 })) throw new Error("Invalid signature");
  return decodeJWT(e2).payload;
}
const Sn = "irn";
function Ir$1(e2) {
  return (e2 == null ? void 0 : e2.relay) || { protocol: Sn };
}
function jr$1(e2) {
  const n4 = C$2[e2];
  if (typeof n4 > "u") throw new Error(`Relay Protocol not supported: ${e2}`);
  return n4;
}
var Tr$2 = Object.defineProperty, Pr$2 = Object.defineProperties, Ar$2 = Object.getOwnPropertyDescriptors, $n = Object.getOwnPropertySymbols, Cr$2 = Object.prototype.hasOwnProperty, Ur$1 = Object.prototype.propertyIsEnumerable, Rn = (e2, n4, t) => n4 in e2 ? Tr$2(e2, n4, { enumerable: true, configurable: true, writable: true, value: t }) : e2[n4] = t, In = (e2, n4) => {
  for (var t in n4 || (n4 = {})) Cr$2.call(n4, t) && Rn(e2, t, n4[t]);
  if ($n) for (var t of $n(n4)) Ur$1.call(n4, t) && Rn(e2, t, n4[t]);
  return e2;
}, _r$2 = (e2, n4) => Pr$2(e2, Ar$2(n4));
function jn(e2, n4 = "-") {
  const t = {}, r2 = "relay" + n4;
  return Object.keys(e2).forEach((o3) => {
    if (o3.startsWith(r2)) {
      const s2 = o3.replace(r2, ""), i3 = e2[o3];
      t[s2] = i3;
    }
  }), t;
}
function kr$1(e2) {
  if (!e2.includes("wc:")) {
    const l2 = le$1(e2);
    l2 != null && l2.includes("wc:") && (e2 = l2);
  }
  e2 = e2.includes("wc://") ? e2.replace("wc://", "") : e2, e2 = e2.includes("wc:") ? e2.replace("wc:", "") : e2;
  const n4 = e2.indexOf(":"), t = e2.indexOf("?") !== -1 ? e2.indexOf("?") : void 0, r2 = e2.substring(0, n4), o3 = e2.substring(n4 + 1, t).split("@"), s2 = typeof t < "u" ? e2.substring(t) : "", i3 = queryString.parse(s2), u2 = typeof i3.methods == "string" ? i3.methods.split(",") : void 0;
  return { protocol: r2, topic: Tn(o3[0]), version: parseInt(o3[1], 10), symKey: i3.symKey, relay: jn(i3), methods: u2, expiryTimestamp: i3.expiryTimestamp ? parseInt(i3.expiryTimestamp, 10) : void 0 };
}
function Tn(e2) {
  return e2.startsWith("//") ? e2.substring(2) : e2;
}
function Pn(e2, n4 = "-") {
  const t = "relay", r2 = {};
  return Object.keys(e2).forEach((o3) => {
    const s2 = t + n4 + o3;
    e2[o3] && (r2[s2] = e2[o3]);
  }), r2;
}
function Dr$2(e2) {
  return `${e2.protocol}:${e2.topic}@${e2.version}?` + queryString.stringify(In(_r$2(In({ symKey: e2.symKey }, Pn(e2.relay)), { expiryTimestamp: e2.expiryTimestamp }), e2.methods ? { methods: e2.methods.join(",") } : {}));
}
function xr$2(e2, n4, t) {
  return `${e2}?wc_ev=${t}&topic=${n4}`;
}
var Vr$1 = Object.defineProperty, Mr$1 = Object.defineProperties, Kr$1 = Object.getOwnPropertyDescriptors, An = Object.getOwnPropertySymbols, Lr$1 = Object.prototype.hasOwnProperty, Fr$2 = Object.prototype.propertyIsEnumerable, Cn = (e2, n4, t) => n4 in e2 ? Vr$1(e2, n4, { enumerable: true, configurable: true, writable: true, value: t }) : e2[n4] = t, qr$1 = (e2, n4) => {
  for (var t in n4 || (n4 = {})) Lr$1.call(n4, t) && Cn(e2, t, n4[t]);
  if (An) for (var t of An(n4)) Fr$2.call(n4, t) && Cn(e2, t, n4[t]);
  return e2;
}, Br$2 = (e2, n4) => Mr$1(e2, Kr$1(n4));
function C$1(e2) {
  const n4 = [];
  return e2.forEach((t) => {
    const [r2, o3] = t.split(":");
    n4.push(`${r2}:${o3}`);
  }), n4;
}
function Un(e2) {
  const n4 = [];
  return Object.values(e2).forEach((t) => {
    n4.push(...C$1(t.accounts));
  }), n4;
}
function _n(e2, n4) {
  const t = [];
  return Object.values(e2).forEach((r2) => {
    C$1(r2.accounts).includes(n4) && t.push(...r2.methods);
  }), t;
}
function kn(e2, n4) {
  const t = [];
  return Object.values(e2).forEach((r2) => {
    C$1(r2.accounts).includes(n4) && t.push(...r2.events);
  }), t;
}
function Wr$1(e2) {
  const { proposal: { requiredNamespaces: n4, optionalNamespaces: t = {} }, supportedNamespaces: r2 } = e2, o3 = Ne(n4), s2 = Ne(t), i3 = {};
  Object.keys(r2).forEach((c2) => {
    const d4 = r2[c2].chains, a3 = r2[c2].methods, f3 = r2[c2].events, h4 = r2[c2].accounts;
    d4.forEach((p3) => {
      if (!h4.some((m2) => m2.includes(p3))) throw new Error(`No accounts provided for chain ${p3} in namespace ${c2}`);
    }), i3[c2] = { chains: d4, methods: a3, events: f3, accounts: h4 };
  });
  const u2 = zn(n4, i3, "approve()");
  if (u2) throw new Error(u2.message);
  const l2 = {};
  return !Object.keys(n4).length && !Object.keys(t).length ? i3 : (Object.keys(o3).forEach((c2) => {
    const d4 = r2[c2].chains.filter((p3) => {
      var m2, E2;
      return (E2 = (m2 = o3[c2]) == null ? void 0 : m2.chains) == null ? void 0 : E2.includes(p3);
    }), a3 = r2[c2].methods.filter((p3) => {
      var m2, E2;
      return (E2 = (m2 = o3[c2]) == null ? void 0 : m2.methods) == null ? void 0 : E2.includes(p3);
    }), f3 = r2[c2].events.filter((p3) => {
      var m2, E2;
      return (E2 = (m2 = o3[c2]) == null ? void 0 : m2.events) == null ? void 0 : E2.includes(p3);
    }), h4 = d4.map((p3) => r2[c2].accounts.filter((m2) => m2.includes(`${p3}:`))).flat();
    l2[c2] = { chains: d4, methods: a3, events: f3, accounts: h4 };
  }), Object.keys(s2).forEach((c2) => {
    var d4, a3, f3, h4, p3, m2;
    if (!r2[c2]) return;
    const E2 = (a3 = (d4 = s2[c2]) == null ? void 0 : d4.chains) == null ? void 0 : a3.filter((j2) => r2[c2].chains.includes(j2)), nt2 = r2[c2].methods.filter((j2) => {
      var T2, x3;
      return (x3 = (T2 = s2[c2]) == null ? void 0 : T2.methods) == null ? void 0 : x3.includes(j2);
    }), tt2 = r2[c2].events.filter((j2) => {
      var T2, x3;
      return (x3 = (T2 = s2[c2]) == null ? void 0 : T2.events) == null ? void 0 : x3.includes(j2);
    }), rt2 = E2 == null ? void 0 : E2.map((j2) => r2[c2].accounts.filter((T2) => T2.includes(`${j2}:`))).flat();
    l2[c2] = { chains: N((f3 = l2[c2]) == null ? void 0 : f3.chains, E2), methods: N((h4 = l2[c2]) == null ? void 0 : h4.methods, nt2), events: N((p3 = l2[c2]) == null ? void 0 : p3.events, tt2), accounts: N((m2 = l2[c2]) == null ? void 0 : m2.accounts, rt2) };
  }), l2);
}
function Oe(e2) {
  return e2.includes(":");
}
function Dn$1(e2) {
  return Oe(e2) ? e2.split(":")[0] : e2;
}
function Ne(e2) {
  var n4, t, r2;
  const o3 = {};
  if (!Z$3(e2)) return o3;
  for (const [s2, i3] of Object.entries(e2)) {
    const u2 = Oe(s2) ? [s2] : i3.chains, l2 = i3.methods || [], c2 = i3.events || [], d4 = Dn$1(s2);
    o3[d4] = Br$2(qr$1({}, o3[d4]), { chains: N(u2, (n4 = o3[d4]) == null ? void 0 : n4.chains), methods: N(l2, (t = o3[d4]) == null ? void 0 : t.methods), events: N(c2, (r2 = o3[d4]) == null ? void 0 : r2.events) });
  }
  return o3;
}
function xn(e2) {
  const n4 = {};
  return e2 == null ? void 0 : e2.forEach((t) => {
    const [r2, o3] = t.split(":");
    n4[r2] || (n4[r2] = { accounts: [], chains: [], events: [] }), n4[r2].accounts.push(t), n4[r2].chains.push(`${r2}:${o3}`);
  }), n4;
}
function Jr$1(e2, n4) {
  n4 = n4.map((r2) => r2.replace("did:pkh:", ""));
  const t = xn(n4);
  for (const [r2, o3] of Object.entries(t)) o3.methods ? o3.methods = N(o3.methods, e2) : o3.methods = e2, o3.events = ["chainChanged", "accountsChanged"];
  return t;
}
const Vn = { INVALID_METHOD: { message: "Invalid method.", code: 1001 }, INVALID_EVENT: { message: "Invalid event.", code: 1002 }, INVALID_UPDATE_REQUEST: { message: "Invalid update request.", code: 1003 }, INVALID_EXTEND_REQUEST: { message: "Invalid extend request.", code: 1004 }, INVALID_SESSION_SETTLE_REQUEST: { message: "Invalid session settle request.", code: 1005 }, UNAUTHORIZED_METHOD: { message: "Unauthorized method.", code: 3001 }, UNAUTHORIZED_EVENT: { message: "Unauthorized event.", code: 3002 }, UNAUTHORIZED_UPDATE_REQUEST: { message: "Unauthorized update request.", code: 3003 }, UNAUTHORIZED_EXTEND_REQUEST: { message: "Unauthorized extend request.", code: 3004 }, USER_REJECTED: { message: "User rejected.", code: 5e3 }, USER_REJECTED_CHAINS: { message: "User rejected chains.", code: 5001 }, USER_REJECTED_METHODS: { message: "User rejected methods.", code: 5002 }, USER_REJECTED_EVENTS: { message: "User rejected events.", code: 5003 }, UNSUPPORTED_CHAINS: { message: "Unsupported chains.", code: 5100 }, UNSUPPORTED_METHODS: { message: "Unsupported methods.", code: 5101 }, UNSUPPORTED_EVENTS: { message: "Unsupported events.", code: 5102 }, UNSUPPORTED_ACCOUNTS: { message: "Unsupported accounts.", code: 5103 }, UNSUPPORTED_NAMESPACE_KEY: { message: "Unsupported namespace key.", code: 5104 }, USER_DISCONNECTED: { message: "User disconnected.", code: 6e3 }, SESSION_SETTLEMENT_FAILED: { message: "Session settlement failed.", code: 7e3 }, WC_METHOD_UNSUPPORTED: { message: "Unsupported wc_ method.", code: 10001 } }, Mn = { NOT_INITIALIZED: { message: "Not initialized.", code: 1 }, NO_MATCHING_KEY: { message: "No matching key.", code: 2 }, RESTORE_WILL_OVERRIDE: { message: "Restore will override.", code: 3 }, RESUBSCRIBED: { message: "Resubscribed.", code: 4 }, MISSING_OR_INVALID: { message: "Missing or invalid.", code: 5 }, EXPIRED: { message: "Expired.", code: 6 }, UNKNOWN_TYPE: { message: "Unknown type.", code: 7 }, MISMATCHED_TOPIC: { message: "Mismatched topic.", code: 8 }, NON_CONFORMING_NAMESPACES: { message: "Non conforming namespaces.", code: 9 } };
function S$5(e2, n4) {
  const { message: t, code: r2 } = Mn[e2];
  return { message: n4 ? `${t} ${n4}` : t, code: r2 };
}
function U$2(e2, n4) {
  const { message: t, code: r2 } = Vn[e2];
  return { message: n4 ? `${t} ${n4}` : t, code: r2 };
}
function L$2(e2, n4) {
  return Array.isArray(e2) ? true : false;
}
function Z$3(e2) {
  return Object.getPrototypeOf(e2) === Object.prototype && Object.keys(e2).length;
}
function I$3(e2) {
  return typeof e2 > "u";
}
function b$2(e2, n4) {
  return n4 && I$3(e2) ? true : typeof e2 == "string" && !!e2.trim().length;
}
function X$1(e2, n4) {
  return typeof e2 == "number" && !isNaN(e2);
}
function zr$2(e2, n4) {
  const { requiredNamespaces: t } = n4, r2 = Object.keys(e2.namespaces), o3 = Object.keys(t);
  let s2 = true;
  return $$2(o3, r2) ? (r2.forEach((i3) => {
    const { accounts: u2, methods: l2, events: c2 } = e2.namespaces[i3], d4 = C$1(u2), a3 = t[i3];
    (!$$2(W$2(i3, a3), d4) || !$$2(a3.methods, l2) || !$$2(a3.events, c2)) && (s2 = false);
  }), s2) : false;
}
function F$2(e2) {
  return b$2(e2, false) && e2.includes(":") ? e2.split(":").length === 2 : false;
}
function Kn(e2) {
  if (b$2(e2, false) && e2.includes(":")) {
    const n4 = e2.split(":");
    if (n4.length === 3) {
      const t = n4[0] + ":" + n4[1];
      return !!n4[2] && F$2(t);
    }
  }
  return false;
}
function Gr$1(e2) {
  function n4(t) {
    try {
      return typeof new URL(t) < "u";
    } catch {
      return false;
    }
  }
  try {
    if (b$2(e2, false)) {
      if (n4(e2)) return true;
      const t = le$1(e2);
      return n4(t);
    }
  } catch {
  }
  return false;
}
function Yr$1(e2) {
  var n4;
  return (n4 = e2 == null ? void 0 : e2.proposer) == null ? void 0 : n4.publicKey;
}
function Qr$1(e2) {
  return e2 == null ? void 0 : e2.topic;
}
function Zr$1(e2, n4) {
  let t = null;
  return b$2(e2 == null ? void 0 : e2.publicKey, false) || (t = S$5("MISSING_OR_INVALID", `${n4} controller public key should be a string`)), t;
}
function Se(e2) {
  let n4 = true;
  return L$2(e2) ? e2.length && (n4 = e2.every((t) => b$2(t, false))) : n4 = false, n4;
}
function Ln(e2, n4, t) {
  let r2 = null;
  return L$2(n4) && n4.length ? n4.forEach((o3) => {
    r2 || F$2(o3) || (r2 = U$2("UNSUPPORTED_CHAINS", `${t}, chain ${o3} should be a string and conform to "namespace:chainId" format`));
  }) : F$2(e2) || (r2 = U$2("UNSUPPORTED_CHAINS", `${t}, chains must be defined as "namespace:chainId" e.g. "eip155:1": {...} in the namespace key OR as an array of CAIP-2 chainIds e.g. eip155: { chains: ["eip155:1", "eip155:5"] }`)), r2;
}
function Fn(e2, n4, t) {
  let r2 = null;
  return Object.entries(e2).forEach(([o3, s2]) => {
    if (r2) return;
    const i3 = Ln(o3, W$2(o3, s2), `${n4} ${t}`);
    i3 && (r2 = i3);
  }), r2;
}
function qn(e2, n4) {
  let t = null;
  return L$2(e2) ? e2.forEach((r2) => {
    t || Kn(r2) || (t = U$2("UNSUPPORTED_ACCOUNTS", `${n4}, account ${r2} should be a string and conform to "namespace:chainId:address" format`));
  }) : t = U$2("UNSUPPORTED_ACCOUNTS", `${n4}, accounts should be an array of strings conforming to "namespace:chainId:address" format`), t;
}
function Bn(e2, n4) {
  let t = null;
  return Object.values(e2).forEach((r2) => {
    if (t) return;
    const o3 = qn(r2 == null ? void 0 : r2.accounts, `${n4} namespace`);
    o3 && (t = o3);
  }), t;
}
function Hn(e2, n4) {
  let t = null;
  return Se(e2 == null ? void 0 : e2.methods) ? Se(e2 == null ? void 0 : e2.events) || (t = U$2("UNSUPPORTED_EVENTS", `${n4}, events should be an array of strings or empty array for no events`)) : t = U$2("UNSUPPORTED_METHODS", `${n4}, methods should be an array of strings or empty array for no methods`), t;
}
function $e(e2, n4) {
  let t = null;
  return Object.values(e2).forEach((r2) => {
    if (t) return;
    const o3 = Hn(r2, `${n4}, namespace`);
    o3 && (t = o3);
  }), t;
}
function Xr$1(e2, n4, t) {
  let r2 = null;
  if (e2 && Z$3(e2)) {
    const o3 = $e(e2, n4);
    o3 && (r2 = o3);
    const s2 = Fn(e2, n4, t);
    s2 && (r2 = s2);
  } else r2 = S$5("MISSING_OR_INVALID", `${n4}, ${t} should be an object with data`);
  return r2;
}
function Wn(e2, n4) {
  let t = null;
  if (e2 && Z$3(e2)) {
    const r2 = $e(e2, n4);
    r2 && (t = r2);
    const o3 = Bn(e2, n4);
    o3 && (t = o3);
  } else t = S$5("MISSING_OR_INVALID", `${n4}, namespaces should be an object with data`);
  return t;
}
function Jn(e2) {
  return b$2(e2.protocol, true);
}
function eo(e2, n4) {
  let t = false;
  return !e2 ? t = true : e2 && L$2(e2) && e2.length && e2.forEach((r2) => {
    t = Jn(r2);
  }), t;
}
function no(e2) {
  return typeof e2 == "number";
}
function to(e2) {
  return typeof e2 < "u" && typeof e2 !== null;
}
function ro(e2) {
  return !(!e2 || typeof e2 != "object" || !e2.code || !X$1(e2.code) || !e2.message || !b$2(e2.message, false));
}
function oo(e2) {
  return !(I$3(e2) || !b$2(e2.method, false));
}
function so(e2) {
  return !(I$3(e2) || I$3(e2.result) && I$3(e2.error) || !X$1(e2.id) || !b$2(e2.jsonrpc, false));
}
function io(e2) {
  return !(I$3(e2) || !b$2(e2.name, false));
}
function co(e2, n4) {
  return !(!F$2(n4) || !Un(e2).includes(n4));
}
function ao(e2, n4, t) {
  return b$2(t, false) ? _n(e2, n4).includes(t) : false;
}
function uo(e2, n4, t) {
  return b$2(t, false) ? kn(e2, n4).includes(t) : false;
}
function zn(e2, n4, t) {
  let r2 = null;
  const o3 = lo(e2), s2 = fo(n4), i3 = Object.keys(o3), u2 = Object.keys(s2), l2 = Gn(Object.keys(e2)), c2 = Gn(Object.keys(n4)), d4 = l2.filter((a3) => !c2.includes(a3));
  return d4.length && (r2 = S$5("NON_CONFORMING_NAMESPACES", `${t} namespaces keys don't satisfy requiredNamespaces.
      Required: ${d4.toString()}
      Received: ${Object.keys(n4).toString()}`)), $$2(i3, u2) || (r2 = S$5("NON_CONFORMING_NAMESPACES", `${t} namespaces chains don't satisfy required namespaces.
      Required: ${i3.toString()}
      Approved: ${u2.toString()}`)), Object.keys(n4).forEach((a3) => {
    if (!a3.includes(":") || r2) return;
    const f3 = C$1(n4[a3].accounts);
    f3.includes(a3) || (r2 = S$5("NON_CONFORMING_NAMESPACES", `${t} namespaces accounts don't satisfy namespace accounts for ${a3}
        Required: ${a3}
        Approved: ${f3.toString()}`));
  }), i3.forEach((a3) => {
    r2 || ($$2(o3[a3].methods, s2[a3].methods) ? $$2(o3[a3].events, s2[a3].events) || (r2 = S$5("NON_CONFORMING_NAMESPACES", `${t} namespaces events don't satisfy namespace events for ${a3}`)) : r2 = S$5("NON_CONFORMING_NAMESPACES", `${t} namespaces methods don't satisfy namespace methods for ${a3}`));
  }), r2;
}
function lo(e2) {
  const n4 = {};
  return Object.keys(e2).forEach((t) => {
    var r2;
    t.includes(":") ? n4[t] = e2[t] : (r2 = e2[t].chains) == null || r2.forEach((o3) => {
      n4[o3] = { methods: e2[t].methods, events: e2[t].events };
    });
  }), n4;
}
function Gn(e2) {
  return [...new Set(e2.map((n4) => n4.includes(":") ? n4.split(":")[0] : n4))];
}
function fo(e2) {
  const n4 = {};
  return Object.keys(e2).forEach((t) => {
    if (t.includes(":")) n4[t] = e2[t];
    else {
      const r2 = C$1(e2[t].accounts);
      r2 == null ? void 0 : r2.forEach((o3) => {
        n4[o3] = { accounts: e2[t].accounts.filter((s2) => s2.includes(`${o3}:`)), methods: e2[t].methods, events: e2[t].events };
      });
    }
  }), n4;
}
function po(e2, n4) {
  return X$1(e2) && e2 <= n4.max && e2 >= n4.min;
}
function mo() {
  const e2 = P$2();
  return new Promise((n4) => {
    switch (e2) {
      case y$1.browser:
        n4(Yn());
        break;
      case y$1.reactNative:
        n4(Qn());
        break;
      case y$1.node:
        n4(Zn());
        break;
      default:
        n4(true);
    }
  });
}
function Yn() {
  return V$3() && (navigator == null ? void 0 : navigator.onLine);
}
async function Qn() {
  if (_$1() && typeof global < "u" && global != null && global.NetInfo) {
    const e2 = await (global == null ? void 0 : global.NetInfo.fetch());
    return e2 == null ? void 0 : e2.isConnected;
  }
  return true;
}
function Zn() {
  return true;
}
function ho(e2) {
  switch (P$2()) {
    case y$1.browser:
      Xn(e2);
      break;
    case y$1.reactNative:
      et$2(e2);
      break;
  }
}
function Xn(e2) {
  !_$1() && V$3() && (window.addEventListener("online", () => e2(true)), window.addEventListener("offline", () => e2(false)));
}
function et$2(e2) {
  var _a;
  _$1() && typeof global < "u" && global != null && global.NetInfo && ((_a = global) == null ? void 0 : _a.NetInfo.addEventListener((n4) => e2(n4 == null ? void 0 : n4.isConnected)));
}
const Re = {};
class yo {
  static get(n4) {
    return Re[n4];
  }
  static set(n4, t) {
    Re[n4] = t;
  }
  static delete(n4) {
    delete Re[n4];
  }
}
const PARSE_ERROR = "PARSE_ERROR";
const INVALID_REQUEST = "INVALID_REQUEST";
const METHOD_NOT_FOUND = "METHOD_NOT_FOUND";
const INVALID_PARAMS = "INVALID_PARAMS";
const INTERNAL_ERROR = "INTERNAL_ERROR";
const SERVER_ERROR = "SERVER_ERROR";
const RESERVED_ERROR_CODES = [-32700, -32600, -32601, -32602, -32603];
const STANDARD_ERROR_MAP = {
  [PARSE_ERROR]: { code: -32700, message: "Parse error" },
  [INVALID_REQUEST]: { code: -32600, message: "Invalid Request" },
  [METHOD_NOT_FOUND]: { code: -32601, message: "Method not found" },
  [INVALID_PARAMS]: { code: -32602, message: "Invalid params" },
  [INTERNAL_ERROR]: { code: -32603, message: "Internal error" },
  [SERVER_ERROR]: { code: -32e3, message: "Server error" }
};
const DEFAULT_ERROR = SERVER_ERROR;
function isReservedErrorCode(code) {
  return RESERVED_ERROR_CODES.includes(code);
}
function getError(type) {
  if (!Object.keys(STANDARD_ERROR_MAP).includes(type)) {
    return STANDARD_ERROR_MAP[DEFAULT_ERROR];
  }
  return STANDARD_ERROR_MAP[type];
}
function getErrorByCode(code) {
  const match = Object.values(STANDARD_ERROR_MAP).find((e2) => e2.code === code);
  if (!match) {
    return STANDARD_ERROR_MAP[DEFAULT_ERROR];
  }
  return match;
}
function parseConnectionError(e2, url, type) {
  return e2.message.includes("getaddrinfo ENOTFOUND") || e2.message.includes("connect ECONNREFUSED") ? new Error(`Unavailable ${type} RPC url at ${url}`) : e2;
}
var cjs = {};
/*! *****************************************************************************
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
var extendStatics = function(d4, b2) {
  extendStatics = Object.setPrototypeOf || { __proto__: [] } instanceof Array && function(d5, b3) {
    d5.__proto__ = b3;
  } || function(d5, b3) {
    for (var p3 in b3) if (b3.hasOwnProperty(p3)) d5[p3] = b3[p3];
  };
  return extendStatics(d4, b2);
};
function __extends(d4, b2) {
  extendStatics(d4, b2);
  function __() {
    this.constructor = d4;
  }
  d4.prototype = b2 === null ? Object.create(b2) : (__.prototype = b2.prototype, new __());
}
var __assign = function() {
  __assign = Object.assign || function __assign2(t) {
    for (var s2, i3 = 1, n4 = arguments.length; i3 < n4; i3++) {
      s2 = arguments[i3];
      for (var p3 in s2) if (Object.prototype.hasOwnProperty.call(s2, p3)) t[p3] = s2[p3];
    }
    return t;
  };
  return __assign.apply(this, arguments);
};
function __rest(s2, e2) {
  var t = {};
  for (var p3 in s2) if (Object.prototype.hasOwnProperty.call(s2, p3) && e2.indexOf(p3) < 0)
    t[p3] = s2[p3];
  if (s2 != null && typeof Object.getOwnPropertySymbols === "function")
    for (var i3 = 0, p3 = Object.getOwnPropertySymbols(s2); i3 < p3.length; i3++) {
      if (e2.indexOf(p3[i3]) < 0 && Object.prototype.propertyIsEnumerable.call(s2, p3[i3]))
        t[p3[i3]] = s2[p3[i3]];
    }
  return t;
}
function __decorate(decorators, target, key2, desc) {
  var c2 = arguments.length, r2 = c2 < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key2) : desc, d4;
  if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r2 = Reflect.decorate(decorators, target, key2, desc);
  else for (var i3 = decorators.length - 1; i3 >= 0; i3--) if (d4 = decorators[i3]) r2 = (c2 < 3 ? d4(r2) : c2 > 3 ? d4(target, key2, r2) : d4(target, key2)) || r2;
  return c2 > 3 && r2 && Object.defineProperty(target, key2, r2), r2;
}
function __param(paramIndex, decorator) {
  return function(target, key2) {
    decorator(target, key2, paramIndex);
  };
}
function __metadata(metadataKey, metadataValue) {
  if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(metadataKey, metadataValue);
}
function __awaiter(thisArg, _arguments, P2, generator) {
  function adopt(value) {
    return value instanceof P2 ? value : new P2(function(resolve) {
      resolve(value);
    });
  }
  return new (P2 || (P2 = Promise))(function(resolve, reject) {
    function fulfilled(value) {
      try {
        step(generator.next(value));
      } catch (e2) {
        reject(e2);
      }
    }
    function rejected(value) {
      try {
        step(generator["throw"](value));
      } catch (e2) {
        reject(e2);
      }
    }
    function step(result) {
      result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected);
    }
    step((generator = generator.apply(thisArg, _arguments || [])).next());
  });
}
function __generator(thisArg, body) {
  var _3 = { label: 0, sent: function() {
    if (t[0] & 1) throw t[1];
    return t[1];
  }, trys: [], ops: [] }, f3, y3, t, g3;
  return g3 = { next: verb(0), "throw": verb(1), "return": verb(2) }, typeof Symbol === "function" && (g3[Symbol.iterator] = function() {
    return this;
  }), g3;
  function verb(n4) {
    return function(v3) {
      return step([n4, v3]);
    };
  }
  function step(op) {
    if (f3) throw new TypeError("Generator is already executing.");
    while (_3) try {
      if (f3 = 1, y3 && (t = op[0] & 2 ? y3["return"] : op[0] ? y3["throw"] || ((t = y3["return"]) && t.call(y3), 0) : y3.next) && !(t = t.call(y3, op[1])).done) return t;
      if (y3 = 0, t) op = [op[0] & 2, t.value];
      switch (op[0]) {
        case 0:
        case 1:
          t = op;
          break;
        case 4:
          _3.label++;
          return { value: op[1], done: false };
        case 5:
          _3.label++;
          y3 = op[1];
          op = [0];
          continue;
        case 7:
          op = _3.ops.pop();
          _3.trys.pop();
          continue;
        default:
          if (!(t = _3.trys, t = t.length > 0 && t[t.length - 1]) && (op[0] === 6 || op[0] === 2)) {
            _3 = 0;
            continue;
          }
          if (op[0] === 3 && (!t || op[1] > t[0] && op[1] < t[3])) {
            _3.label = op[1];
            break;
          }
          if (op[0] === 6 && _3.label < t[1]) {
            _3.label = t[1];
            t = op;
            break;
          }
          if (t && _3.label < t[2]) {
            _3.label = t[2];
            _3.ops.push(op);
            break;
          }
          if (t[2]) _3.ops.pop();
          _3.trys.pop();
          continue;
      }
      op = body.call(thisArg, _3);
    } catch (e2) {
      op = [6, e2];
      y3 = 0;
    } finally {
      f3 = t = 0;
    }
    if (op[0] & 5) throw op[1];
    return { value: op[0] ? op[1] : void 0, done: true };
  }
}
function __createBinding(o3, m2, k2, k22) {
  if (k22 === void 0) k22 = k2;
  o3[k22] = m2[k2];
}
function __exportStar(m2, exports) {
  for (var p3 in m2) if (p3 !== "default" && !exports.hasOwnProperty(p3)) exports[p3] = m2[p3];
}
function __values(o3) {
  var s2 = typeof Symbol === "function" && Symbol.iterator, m2 = s2 && o3[s2], i3 = 0;
  if (m2) return m2.call(o3);
  if (o3 && typeof o3.length === "number") return {
    next: function() {
      if (o3 && i3 >= o3.length) o3 = void 0;
      return { value: o3 && o3[i3++], done: !o3 };
    }
  };
  throw new TypeError(s2 ? "Object is not iterable." : "Symbol.iterator is not defined.");
}
function __read(o3, n4) {
  var m2 = typeof Symbol === "function" && o3[Symbol.iterator];
  if (!m2) return o3;
  var i3 = m2.call(o3), r2, ar2 = [], e2;
  try {
    while ((n4 === void 0 || n4-- > 0) && !(r2 = i3.next()).done) ar2.push(r2.value);
  } catch (error2) {
    e2 = { error: error2 };
  } finally {
    try {
      if (r2 && !r2.done && (m2 = i3["return"])) m2.call(i3);
    } finally {
      if (e2) throw e2.error;
    }
  }
  return ar2;
}
function __spread() {
  for (var ar2 = [], i3 = 0; i3 < arguments.length; i3++)
    ar2 = ar2.concat(__read(arguments[i3]));
  return ar2;
}
function __spreadArrays() {
  for (var s2 = 0, i3 = 0, il = arguments.length; i3 < il; i3++) s2 += arguments[i3].length;
  for (var r2 = Array(s2), k2 = 0, i3 = 0; i3 < il; i3++)
    for (var a3 = arguments[i3], j2 = 0, jl = a3.length; j2 < jl; j2++, k2++)
      r2[k2] = a3[j2];
  return r2;
}
function __await(v3) {
  return this instanceof __await ? (this.v = v3, this) : new __await(v3);
}
function __asyncGenerator(thisArg, _arguments, generator) {
  if (!Symbol.asyncIterator) throw new TypeError("Symbol.asyncIterator is not defined.");
  var g3 = generator.apply(thisArg, _arguments || []), i3, q2 = [];
  return i3 = {}, verb("next"), verb("throw"), verb("return"), i3[Symbol.asyncIterator] = function() {
    return this;
  }, i3;
  function verb(n4) {
    if (g3[n4]) i3[n4] = function(v3) {
      return new Promise(function(a3, b2) {
        q2.push([n4, v3, a3, b2]) > 1 || resume(n4, v3);
      });
    };
  }
  function resume(n4, v3) {
    try {
      step(g3[n4](v3));
    } catch (e2) {
      settle(q2[0][3], e2);
    }
  }
  function step(r2) {
    r2.value instanceof __await ? Promise.resolve(r2.value.v).then(fulfill, reject) : settle(q2[0][2], r2);
  }
  function fulfill(value) {
    resume("next", value);
  }
  function reject(value) {
    resume("throw", value);
  }
  function settle(f3, v3) {
    if (f3(v3), q2.shift(), q2.length) resume(q2[0][0], q2[0][1]);
  }
}
function __asyncDelegator(o3) {
  var i3, p3;
  return i3 = {}, verb("next"), verb("throw", function(e2) {
    throw e2;
  }), verb("return"), i3[Symbol.iterator] = function() {
    return this;
  }, i3;
  function verb(n4, f3) {
    i3[n4] = o3[n4] ? function(v3) {
      return (p3 = !p3) ? { value: __await(o3[n4](v3)), done: n4 === "return" } : f3 ? f3(v3) : v3;
    } : f3;
  }
}
function __asyncValues(o3) {
  if (!Symbol.asyncIterator) throw new TypeError("Symbol.asyncIterator is not defined.");
  var m2 = o3[Symbol.asyncIterator], i3;
  return m2 ? m2.call(o3) : (o3 = typeof __values === "function" ? __values(o3) : o3[Symbol.iterator](), i3 = {}, verb("next"), verb("throw"), verb("return"), i3[Symbol.asyncIterator] = function() {
    return this;
  }, i3);
  function verb(n4) {
    i3[n4] = o3[n4] && function(v3) {
      return new Promise(function(resolve, reject) {
        v3 = o3[n4](v3), settle(resolve, reject, v3.done, v3.value);
      });
    };
  }
  function settle(resolve, reject, d4, v3) {
    Promise.resolve(v3).then(function(v4) {
      resolve({ value: v4, done: d4 });
    }, reject);
  }
}
function __makeTemplateObject(cooked, raw) {
  if (Object.defineProperty) {
    Object.defineProperty(cooked, "raw", { value: raw });
  } else {
    cooked.raw = raw;
  }
  return cooked;
}
function __importStar(mod) {
  if (mod && mod.__esModule) return mod;
  var result = {};
  if (mod != null) {
    for (var k2 in mod) if (Object.hasOwnProperty.call(mod, k2)) result[k2] = mod[k2];
  }
  result.default = mod;
  return result;
}
function __importDefault(mod) {
  return mod && mod.__esModule ? mod : { default: mod };
}
function __classPrivateFieldGet(receiver, privateMap) {
  if (!privateMap.has(receiver)) {
    throw new TypeError("attempted to get private field on non-instance");
  }
  return privateMap.get(receiver);
}
function __classPrivateFieldSet(receiver, privateMap, value) {
  if (!privateMap.has(receiver)) {
    throw new TypeError("attempted to set private field on non-instance");
  }
  privateMap.set(receiver, value);
  return value;
}
const tslib_es6 = /* @__PURE__ */ Object.freeze(/* @__PURE__ */ Object.defineProperty({
  __proto__: null,
  get __assign() {
    return __assign;
  },
  __asyncDelegator,
  __asyncGenerator,
  __asyncValues,
  __await,
  __awaiter,
  __classPrivateFieldGet,
  __classPrivateFieldSet,
  __createBinding,
  __decorate,
  __exportStar,
  __extends,
  __generator,
  __importDefault,
  __importStar,
  __makeTemplateObject,
  __metadata,
  __param,
  __read,
  __rest,
  __spread,
  __spreadArrays,
  __values
}, Symbol.toStringTag, { value: "Module" }));
const require$$0$1 = /* @__PURE__ */ getAugmentedNamespace(tslib_es6);
var crypto$1 = {};
var hasRequiredCrypto;
function requireCrypto() {
  if (hasRequiredCrypto) return crypto$1;
  hasRequiredCrypto = 1;
  Object.defineProperty(crypto$1, "__esModule", { value: true });
  crypto$1.isBrowserCryptoAvailable = crypto$1.getSubtleCrypto = crypto$1.getBrowerCrypto = void 0;
  function getBrowerCrypto() {
    return (commonjsGlobal === null || commonjsGlobal === void 0 ? void 0 : commonjsGlobal.crypto) || (commonjsGlobal === null || commonjsGlobal === void 0 ? void 0 : commonjsGlobal.msCrypto) || {};
  }
  crypto$1.getBrowerCrypto = getBrowerCrypto;
  function getSubtleCrypto() {
    const browserCrypto = getBrowerCrypto();
    return browserCrypto.subtle || browserCrypto.webkitSubtle;
  }
  crypto$1.getSubtleCrypto = getSubtleCrypto;
  function isBrowserCryptoAvailable() {
    return !!getBrowerCrypto() && !!getSubtleCrypto();
  }
  crypto$1.isBrowserCryptoAvailable = isBrowserCryptoAvailable;
  return crypto$1;
}
var env = {};
var hasRequiredEnv;
function requireEnv() {
  if (hasRequiredEnv) return env;
  hasRequiredEnv = 1;
  Object.defineProperty(env, "__esModule", { value: true });
  env.isBrowser = env.isNode = env.isReactNative = void 0;
  function isReactNative() {
    return typeof document === "undefined" && typeof navigator !== "undefined" && navigator.product === "ReactNative";
  }
  env.isReactNative = isReactNative;
  function isNode() {
    return typeof process$1 !== "undefined" && typeof process$1.versions !== "undefined" && typeof process$1.versions.node !== "undefined";
  }
  env.isNode = isNode;
  function isBrowser() {
    return !isReactNative() && !isNode();
  }
  env.isBrowser = isBrowser;
  return env;
}
(function(exports) {
  Object.defineProperty(exports, "__esModule", { value: true });
  const tslib_1 = require$$0$1;
  tslib_1.__exportStar(requireCrypto(), exports);
  tslib_1.__exportStar(requireEnv(), exports);
})(cjs);
function payloadId(entropy = 3) {
  const date = Date.now() * Math.pow(10, entropy);
  const extra = Math.floor(Math.random() * Math.pow(10, entropy));
  return date + extra;
}
function getBigIntRpcId(entropy = 6) {
  return BigInt(payloadId(entropy));
}
function formatJsonRpcRequest(method, params, id) {
  return {
    id: id || payloadId(),
    jsonrpc: "2.0",
    method,
    params
  };
}
function formatJsonRpcResult(id, result) {
  return {
    id,
    jsonrpc: "2.0",
    result
  };
}
function formatJsonRpcError(id, error2, data) {
  return {
    id,
    jsonrpc: "2.0",
    error: formatErrorMessage(error2)
  };
}
function formatErrorMessage(error2, data) {
  if (typeof error2 === "undefined") {
    return getError(INTERNAL_ERROR);
  }
  if (typeof error2 === "string") {
    error2 = Object.assign(Object.assign({}, getError(SERVER_ERROR)), { message: error2 });
  }
  if (isReservedErrorCode(error2.code)) {
    error2 = getErrorByCode(error2.code);
  }
  return error2;
}
class e {
}
class n3 extends e {
  constructor() {
    super();
  }
}
class r extends n3 {
  constructor(c2) {
    super();
  }
}
const WS_REGEX = "^wss?:";
function getUrlProtocol(url) {
  const matches = url.match(new RegExp(/^\w+:/, "gi"));
  if (!matches || !matches.length)
    return;
  return matches[0];
}
function matchRegexProtocol(url, regex) {
  const protocol = getUrlProtocol(url);
  if (typeof protocol === "undefined")
    return false;
  return new RegExp(regex).test(protocol);
}
function isWsUrl(url) {
  return matchRegexProtocol(url, WS_REGEX);
}
function isLocalhostUrl(url) {
  return new RegExp("wss?://localhost(:d{2,5})?").test(url);
}
function isJsonRpcPayload(payload) {
  return typeof payload === "object" && "id" in payload && "jsonrpc" in payload && payload.jsonrpc === "2.0";
}
function isJsonRpcRequest(payload) {
  return isJsonRpcPayload(payload) && "method" in payload;
}
function isJsonRpcResponse(payload) {
  return isJsonRpcPayload(payload) && (isJsonRpcResult(payload) || isJsonRpcError(payload));
}
function isJsonRpcResult(payload) {
  return "result" in payload;
}
function isJsonRpcError(payload) {
  return "error" in payload;
}
let o$1 = class o extends r {
  constructor(t) {
    super(t), this.events = new eventsExports.EventEmitter(), this.hasRegisteredEventListeners = false, this.connection = this.setConnection(t), this.connection.connected && this.registerEventListeners();
  }
  async connect(t = this.connection) {
    await this.open(t);
  }
  async disconnect() {
    await this.close();
  }
  on(t, e2) {
    this.events.on(t, e2);
  }
  once(t, e2) {
    this.events.once(t, e2);
  }
  off(t, e2) {
    this.events.off(t, e2);
  }
  removeListener(t, e2) {
    this.events.removeListener(t, e2);
  }
  async request(t, e2) {
    return this.requestStrict(formatJsonRpcRequest(t.method, t.params || [], t.id || getBigIntRpcId().toString()), e2);
  }
  async requestStrict(t, e2) {
    return new Promise(async (i3, s2) => {
      if (!this.connection.connected) try {
        await this.open();
      } catch (n4) {
        s2(n4);
      }
      this.events.on(`${t.id}`, (n4) => {
        isJsonRpcError(n4) ? s2(n4.error) : i3(n4.result);
      });
      try {
        await this.connection.send(t, e2);
      } catch (n4) {
        s2(n4);
      }
    });
  }
  setConnection(t = this.connection) {
    return t;
  }
  onPayload(t) {
    this.events.emit("payload", t), isJsonRpcResponse(t) ? this.events.emit(`${t.id}`, t) : this.events.emit("message", { type: t.method, data: t.params });
  }
  onClose(t) {
    t && t.code === 3e3 && this.events.emit("error", new Error(`WebSocket connection closed abnormally with code: ${t.code} ${t.reason ? `(${t.reason})` : ""}`)), this.events.emit("disconnect");
  }
  async open(t = this.connection) {
    this.connection === t && this.connection.connected || (this.connection.connected && this.close(), typeof t == "string" && (await this.connection.open(t), t = this.connection), this.connection = this.setConnection(t), await this.connection.open(), this.registerEventListeners(), this.events.emit("connect"));
  }
  async close() {
    await this.connection.close();
  }
  registerEventListeners() {
    this.hasRegisteredEventListeners || (this.connection.on("payload", (t) => this.onPayload(t)), this.connection.on("close", (t) => this.onClose(t)), this.connection.on("error", (t) => this.events.emit("error", t)), this.connection.on("register_error", (t) => this.onClose()), this.hasRegisteredEventListeners = true);
  }
};
const w$1 = () => typeof WebSocket < "u" ? WebSocket : typeof global < "u" && typeof global.WebSocket < "u" ? global.WebSocket : typeof window < "u" && typeof window.WebSocket < "u" ? window.WebSocket : typeof self < "u" && typeof self.WebSocket < "u" ? self.WebSocket : require("ws"), b$1 = () => typeof WebSocket < "u" || typeof global < "u" && typeof global.WebSocket < "u" || typeof window < "u" && typeof window.WebSocket < "u" || typeof self < "u" && typeof self.WebSocket < "u", a2 = (c2) => c2.split("?")[0], h3 = 10, S$4 = w$1();
let f$2 = class f {
  constructor(e2) {
    if (this.url = e2, this.events = new eventsExports.EventEmitter(), this.registering = false, !isWsUrl(e2)) throw new Error(`Provided URL is not compatible with WebSocket connection: ${e2}`);
    this.url = e2;
  }
  get connected() {
    return typeof this.socket < "u";
  }
  get connecting() {
    return this.registering;
  }
  on(e2, t) {
    this.events.on(e2, t);
  }
  once(e2, t) {
    this.events.once(e2, t);
  }
  off(e2, t) {
    this.events.off(e2, t);
  }
  removeListener(e2, t) {
    this.events.removeListener(e2, t);
  }
  async open(e2 = this.url) {
    await this.register(e2);
  }
  async close() {
    return new Promise((e2, t) => {
      if (typeof this.socket > "u") {
        t(new Error("Connection already closed"));
        return;
      }
      this.socket.onclose = (n4) => {
        this.onClose(n4), e2();
      }, this.socket.close();
    });
  }
  async send(e2) {
    typeof this.socket > "u" && (this.socket = await this.register());
    try {
      this.socket.send(safeJsonStringify(e2));
    } catch (t) {
      this.onError(e2.id, t);
    }
  }
  register(e2 = this.url) {
    if (!isWsUrl(e2)) throw new Error(`Provided URL is not compatible with WebSocket connection: ${e2}`);
    if (this.registering) {
      const t = this.events.getMaxListeners();
      return (this.events.listenerCount("register_error") >= t || this.events.listenerCount("open") >= t) && this.events.setMaxListeners(t + 1), new Promise((n4, o3) => {
        this.events.once("register_error", (s2) => {
          this.resetMaxListeners(), o3(s2);
        }), this.events.once("open", () => {
          if (this.resetMaxListeners(), typeof this.socket > "u") return o3(new Error("WebSocket connection is missing or invalid"));
          n4(this.socket);
        });
      });
    }
    return this.url = e2, this.registering = true, new Promise((t, n4) => {
      const o3 = new URLSearchParams(e2).get("origin"), s2 = cjs.isReactNative() ? { headers: { origin: o3 } } : { rejectUnauthorized: !isLocalhostUrl(e2) }, i3 = new S$4(e2, [], s2);
      b$1() ? i3.onerror = (r2) => {
        const l2 = r2;
        n4(this.emitError(l2.error));
      } : i3.on("error", (r2) => {
        n4(this.emitError(r2));
      }), i3.onopen = () => {
        this.onOpen(i3), t(i3);
      };
    });
  }
  onOpen(e2) {
    e2.onmessage = (t) => this.onPayload(t), e2.onclose = (t) => this.onClose(t), this.socket = e2, this.registering = false, this.events.emit("open");
  }
  onClose(e2) {
    this.socket = void 0, this.registering = false, this.events.emit("close", e2);
  }
  onPayload(e2) {
    if (typeof e2.data > "u") return;
    const t = typeof e2.data == "string" ? safeJsonParse(e2.data) : e2.data;
    this.events.emit("payload", t);
  }
  onError(e2, t) {
    const n4 = this.parseError(t), o3 = n4.message || n4.toString(), s2 = formatJsonRpcError(e2, o3);
    this.events.emit("payload", s2);
  }
  parseError(e2, t = this.url) {
    return parseConnectionError(e2, a2(t), "WS");
  }
  resetMaxListeners() {
    this.events.getMaxListeners() > h3 && this.events.setMaxListeners(h3);
  }
  emitError(e2) {
    const t = this.parseError(new Error((e2 == null ? void 0 : e2.message) || `WebSocket connection failed for host: ${a2(this.url)}`));
    return this.events.emit("register_error", t), t;
  }
};
var lodash_isequal = { exports: {} };
lodash_isequal.exports;
(function(module, exports) {
  var LARGE_ARRAY_SIZE = 200;
  var HASH_UNDEFINED = "__lodash_hash_undefined__";
  var COMPARE_PARTIAL_FLAG = 1, COMPARE_UNORDERED_FLAG = 2;
  var MAX_SAFE_INTEGER2 = 9007199254740991;
  var argsTag = "[object Arguments]", arrayTag = "[object Array]", asyncTag = "[object AsyncFunction]", boolTag = "[object Boolean]", dateTag = "[object Date]", errorTag = "[object Error]", funcTag = "[object Function]", genTag = "[object GeneratorFunction]", mapTag = "[object Map]", numberTag = "[object Number]", nullTag = "[object Null]", objectTag = "[object Object]", promiseTag = "[object Promise]", proxyTag = "[object Proxy]", regexpTag = "[object RegExp]", setTag = "[object Set]", stringTag = "[object String]", symbolTag = "[object Symbol]", undefinedTag = "[object Undefined]", weakMapTag = "[object WeakMap]";
  var arrayBufferTag = "[object ArrayBuffer]", dataViewTag = "[object DataView]", float32Tag = "[object Float32Array]", float64Tag = "[object Float64Array]", int8Tag = "[object Int8Array]", int16Tag = "[object Int16Array]", int32Tag = "[object Int32Array]", uint8Tag = "[object Uint8Array]", uint8ClampedTag = "[object Uint8ClampedArray]", uint16Tag = "[object Uint16Array]", uint32Tag = "[object Uint32Array]";
  var reRegExpChar = /[\\^$.*+?()[\]{}|]/g;
  var reIsHostCtor = /^\[object .+?Constructor\]$/;
  var reIsUint = /^(?:0|[1-9]\d*)$/;
  var typedArrayTags = {};
  typedArrayTags[float32Tag] = typedArrayTags[float64Tag] = typedArrayTags[int8Tag] = typedArrayTags[int16Tag] = typedArrayTags[int32Tag] = typedArrayTags[uint8Tag] = typedArrayTags[uint8ClampedTag] = typedArrayTags[uint16Tag] = typedArrayTags[uint32Tag] = true;
  typedArrayTags[argsTag] = typedArrayTags[arrayTag] = typedArrayTags[arrayBufferTag] = typedArrayTags[boolTag] = typedArrayTags[dataViewTag] = typedArrayTags[dateTag] = typedArrayTags[errorTag] = typedArrayTags[funcTag] = typedArrayTags[mapTag] = typedArrayTags[numberTag] = typedArrayTags[objectTag] = typedArrayTags[regexpTag] = typedArrayTags[setTag] = typedArrayTags[stringTag] = typedArrayTags[weakMapTag] = false;
  var freeGlobal = typeof commonjsGlobal == "object" && commonjsGlobal && commonjsGlobal.Object === Object && commonjsGlobal;
  var freeSelf = typeof self == "object" && self && self.Object === Object && self;
  var root = freeGlobal || freeSelf || Function("return this")();
  var freeExports = exports && !exports.nodeType && exports;
  var freeModule = freeExports && true && module && !module.nodeType && module;
  var moduleExports = freeModule && freeModule.exports === freeExports;
  var freeProcess = moduleExports && freeGlobal.process;
  var nodeUtil = function() {
    try {
      return freeProcess && freeProcess.binding && freeProcess.binding("util");
    } catch (e2) {
    }
  }();
  var nodeIsTypedArray = nodeUtil && nodeUtil.isTypedArray;
  function arrayFilter(array, predicate) {
    var index = -1, length = array == null ? 0 : array.length, resIndex = 0, result = [];
    while (++index < length) {
      var value = array[index];
      if (predicate(value, index, array)) {
        result[resIndex++] = value;
      }
    }
    return result;
  }
  function arrayPush(array, values) {
    var index = -1, length = values.length, offset = array.length;
    while (++index < length) {
      array[offset + index] = values[index];
    }
    return array;
  }
  function arraySome(array, predicate) {
    var index = -1, length = array == null ? 0 : array.length;
    while (++index < length) {
      if (predicate(array[index], index, array)) {
        return true;
      }
    }
    return false;
  }
  function baseTimes(n4, iteratee) {
    var index = -1, result = Array(n4);
    while (++index < n4) {
      result[index] = iteratee(index);
    }
    return result;
  }
  function baseUnary(func) {
    return function(value) {
      return func(value);
    };
  }
  function cacheHas(cache, key2) {
    return cache.has(key2);
  }
  function getValue(object, key2) {
    return object == null ? void 0 : object[key2];
  }
  function mapToArray(map) {
    var index = -1, result = Array(map.size);
    map.forEach(function(value, key2) {
      result[++index] = [key2, value];
    });
    return result;
  }
  function overArg(func, transform) {
    return function(arg) {
      return func(transform(arg));
    };
  }
  function setToArray(set2) {
    var index = -1, result = Array(set2.size);
    set2.forEach(function(value) {
      result[++index] = value;
    });
    return result;
  }
  var arrayProto = Array.prototype, funcProto = Function.prototype, objectProto = Object.prototype;
  var coreJsData = root["__core-js_shared__"];
  var funcToString = funcProto.toString;
  var hasOwnProperty = objectProto.hasOwnProperty;
  var maskSrcKey = function() {
    var uid = /[^.]+$/.exec(coreJsData && coreJsData.keys && coreJsData.keys.IE_PROTO || "");
    return uid ? "Symbol(src)_1." + uid : "";
  }();
  var nativeObjectToString = objectProto.toString;
  var reIsNative = RegExp(
    "^" + funcToString.call(hasOwnProperty).replace(reRegExpChar, "\\$&").replace(/hasOwnProperty|(function).*?(?=\\\()| for .+?(?=\\\])/g, "$1.*?") + "$"
  );
  var Buffer2 = moduleExports ? root.Buffer : void 0, Symbol2 = root.Symbol, Uint8Array2 = root.Uint8Array, propertyIsEnumerable = objectProto.propertyIsEnumerable, splice = arrayProto.splice, symToStringTag = Symbol2 ? Symbol2.toStringTag : void 0;
  var nativeGetSymbols = Object.getOwnPropertySymbols, nativeIsBuffer = Buffer2 ? Buffer2.isBuffer : void 0, nativeKeys = overArg(Object.keys, Object);
  var DataView2 = getNative(root, "DataView"), Map2 = getNative(root, "Map"), Promise2 = getNative(root, "Promise"), Set2 = getNative(root, "Set"), WeakMap = getNative(root, "WeakMap"), nativeCreate = getNative(Object, "create");
  var dataViewCtorString = toSource(DataView2), mapCtorString = toSource(Map2), promiseCtorString = toSource(Promise2), setCtorString = toSource(Set2), weakMapCtorString = toSource(WeakMap);
  var symbolProto = Symbol2 ? Symbol2.prototype : void 0, symbolValueOf = symbolProto ? symbolProto.valueOf : void 0;
  function Hash(entries) {
    var index = -1, length = entries == null ? 0 : entries.length;
    this.clear();
    while (++index < length) {
      var entry = entries[index];
      this.set(entry[0], entry[1]);
    }
  }
  function hashClear() {
    this.__data__ = nativeCreate ? nativeCreate(null) : {};
    this.size = 0;
  }
  function hashDelete(key2) {
    var result = this.has(key2) && delete this.__data__[key2];
    this.size -= result ? 1 : 0;
    return result;
  }
  function hashGet(key2) {
    var data = this.__data__;
    if (nativeCreate) {
      var result = data[key2];
      return result === HASH_UNDEFINED ? void 0 : result;
    }
    return hasOwnProperty.call(data, key2) ? data[key2] : void 0;
  }
  function hashHas(key2) {
    var data = this.__data__;
    return nativeCreate ? data[key2] !== void 0 : hasOwnProperty.call(data, key2);
  }
  function hashSet(key2, value) {
    var data = this.__data__;
    this.size += this.has(key2) ? 0 : 1;
    data[key2] = nativeCreate && value === void 0 ? HASH_UNDEFINED : value;
    return this;
  }
  Hash.prototype.clear = hashClear;
  Hash.prototype["delete"] = hashDelete;
  Hash.prototype.get = hashGet;
  Hash.prototype.has = hashHas;
  Hash.prototype.set = hashSet;
  function ListCache(entries) {
    var index = -1, length = entries == null ? 0 : entries.length;
    this.clear();
    while (++index < length) {
      var entry = entries[index];
      this.set(entry[0], entry[1]);
    }
  }
  function listCacheClear() {
    this.__data__ = [];
    this.size = 0;
  }
  function listCacheDelete(key2) {
    var data = this.__data__, index = assocIndexOf(data, key2);
    if (index < 0) {
      return false;
    }
    var lastIndex = data.length - 1;
    if (index == lastIndex) {
      data.pop();
    } else {
      splice.call(data, index, 1);
    }
    --this.size;
    return true;
  }
  function listCacheGet(key2) {
    var data = this.__data__, index = assocIndexOf(data, key2);
    return index < 0 ? void 0 : data[index][1];
  }
  function listCacheHas(key2) {
    return assocIndexOf(this.__data__, key2) > -1;
  }
  function listCacheSet(key2, value) {
    var data = this.__data__, index = assocIndexOf(data, key2);
    if (index < 0) {
      ++this.size;
      data.push([key2, value]);
    } else {
      data[index][1] = value;
    }
    return this;
  }
  ListCache.prototype.clear = listCacheClear;
  ListCache.prototype["delete"] = listCacheDelete;
  ListCache.prototype.get = listCacheGet;
  ListCache.prototype.has = listCacheHas;
  ListCache.prototype.set = listCacheSet;
  function MapCache(entries) {
    var index = -1, length = entries == null ? 0 : entries.length;
    this.clear();
    while (++index < length) {
      var entry = entries[index];
      this.set(entry[0], entry[1]);
    }
  }
  function mapCacheClear() {
    this.size = 0;
    this.__data__ = {
      "hash": new Hash(),
      "map": new (Map2 || ListCache)(),
      "string": new Hash()
    };
  }
  function mapCacheDelete(key2) {
    var result = getMapData(this, key2)["delete"](key2);
    this.size -= result ? 1 : 0;
    return result;
  }
  function mapCacheGet(key2) {
    return getMapData(this, key2).get(key2);
  }
  function mapCacheHas(key2) {
    return getMapData(this, key2).has(key2);
  }
  function mapCacheSet(key2, value) {
    var data = getMapData(this, key2), size = data.size;
    data.set(key2, value);
    this.size += data.size == size ? 0 : 1;
    return this;
  }
  MapCache.prototype.clear = mapCacheClear;
  MapCache.prototype["delete"] = mapCacheDelete;
  MapCache.prototype.get = mapCacheGet;
  MapCache.prototype.has = mapCacheHas;
  MapCache.prototype.set = mapCacheSet;
  function SetCache(values) {
    var index = -1, length = values == null ? 0 : values.length;
    this.__data__ = new MapCache();
    while (++index < length) {
      this.add(values[index]);
    }
  }
  function setCacheAdd(value) {
    this.__data__.set(value, HASH_UNDEFINED);
    return this;
  }
  function setCacheHas(value) {
    return this.__data__.has(value);
  }
  SetCache.prototype.add = SetCache.prototype.push = setCacheAdd;
  SetCache.prototype.has = setCacheHas;
  function Stack(entries) {
    var data = this.__data__ = new ListCache(entries);
    this.size = data.size;
  }
  function stackClear() {
    this.__data__ = new ListCache();
    this.size = 0;
  }
  function stackDelete(key2) {
    var data = this.__data__, result = data["delete"](key2);
    this.size = data.size;
    return result;
  }
  function stackGet(key2) {
    return this.__data__.get(key2);
  }
  function stackHas(key2) {
    return this.__data__.has(key2);
  }
  function stackSet(key2, value) {
    var data = this.__data__;
    if (data instanceof ListCache) {
      var pairs = data.__data__;
      if (!Map2 || pairs.length < LARGE_ARRAY_SIZE - 1) {
        pairs.push([key2, value]);
        this.size = ++data.size;
        return this;
      }
      data = this.__data__ = new MapCache(pairs);
    }
    data.set(key2, value);
    this.size = data.size;
    return this;
  }
  Stack.prototype.clear = stackClear;
  Stack.prototype["delete"] = stackDelete;
  Stack.prototype.get = stackGet;
  Stack.prototype.has = stackHas;
  Stack.prototype.set = stackSet;
  function arrayLikeKeys(value, inherited) {
    var isArr = isArray(value), isArg = !isArr && isArguments(value), isBuff = !isArr && !isArg && isBuffer(value), isType = !isArr && !isArg && !isBuff && isTypedArray(value), skipIndexes = isArr || isArg || isBuff || isType, result = skipIndexes ? baseTimes(value.length, String) : [], length = result.length;
    for (var key2 in value) {
      if (hasOwnProperty.call(value, key2) && !(skipIndexes && // Safari 9 has enumerable `arguments.length` in strict mode.
      (key2 == "length" || // Node.js 0.10 has enumerable non-index properties on buffers.
      isBuff && (key2 == "offset" || key2 == "parent") || // PhantomJS 2 has enumerable non-index properties on typed arrays.
      isType && (key2 == "buffer" || key2 == "byteLength" || key2 == "byteOffset") || // Skip index properties.
      isIndex(key2, length)))) {
        result.push(key2);
      }
    }
    return result;
  }
  function assocIndexOf(array, key2) {
    var length = array.length;
    while (length--) {
      if (eq9(array[length][0], key2)) {
        return length;
      }
    }
    return -1;
  }
  function baseGetAllKeys(object, keysFunc, symbolsFunc) {
    var result = keysFunc(object);
    return isArray(object) ? result : arrayPush(result, symbolsFunc(object));
  }
  function baseGetTag(value) {
    if (value == null) {
      return value === void 0 ? undefinedTag : nullTag;
    }
    return symToStringTag && symToStringTag in Object(value) ? getRawTag(value) : objectToString(value);
  }
  function baseIsArguments(value) {
    return isObjectLike(value) && baseGetTag(value) == argsTag;
  }
  function baseIsEqual(value, other, bitmask, customizer, stack) {
    if (value === other) {
      return true;
    }
    if (value == null || other == null || !isObjectLike(value) && !isObjectLike(other)) {
      return value !== value && other !== other;
    }
    return baseIsEqualDeep(value, other, bitmask, customizer, baseIsEqual, stack);
  }
  function baseIsEqualDeep(object, other, bitmask, customizer, equalFunc, stack) {
    var objIsArr = isArray(object), othIsArr = isArray(other), objTag = objIsArr ? arrayTag : getTag(object), othTag = othIsArr ? arrayTag : getTag(other);
    objTag = objTag == argsTag ? objectTag : objTag;
    othTag = othTag == argsTag ? objectTag : othTag;
    var objIsObj = objTag == objectTag, othIsObj = othTag == objectTag, isSameTag = objTag == othTag;
    if (isSameTag && isBuffer(object)) {
      if (!isBuffer(other)) {
        return false;
      }
      objIsArr = true;
      objIsObj = false;
    }
    if (isSameTag && !objIsObj) {
      stack || (stack = new Stack());
      return objIsArr || isTypedArray(object) ? equalArrays(object, other, bitmask, customizer, equalFunc, stack) : equalByTag(object, other, objTag, bitmask, customizer, equalFunc, stack);
    }
    if (!(bitmask & COMPARE_PARTIAL_FLAG)) {
      var objIsWrapped = objIsObj && hasOwnProperty.call(object, "__wrapped__"), othIsWrapped = othIsObj && hasOwnProperty.call(other, "__wrapped__");
      if (objIsWrapped || othIsWrapped) {
        var objUnwrapped = objIsWrapped ? object.value() : object, othUnwrapped = othIsWrapped ? other.value() : other;
        stack || (stack = new Stack());
        return equalFunc(objUnwrapped, othUnwrapped, bitmask, customizer, stack);
      }
    }
    if (!isSameTag) {
      return false;
    }
    stack || (stack = new Stack());
    return equalObjects(object, other, bitmask, customizer, equalFunc, stack);
  }
  function baseIsNative(value) {
    if (!isObject(value) || isMasked(value)) {
      return false;
    }
    var pattern = isFunction(value) ? reIsNative : reIsHostCtor;
    return pattern.test(toSource(value));
  }
  function baseIsTypedArray(value) {
    return isObjectLike(value) && isLength(value.length) && !!typedArrayTags[baseGetTag(value)];
  }
  function baseKeys(object) {
    if (!isPrototype(object)) {
      return nativeKeys(object);
    }
    var result = [];
    for (var key2 in Object(object)) {
      if (hasOwnProperty.call(object, key2) && key2 != "constructor") {
        result.push(key2);
      }
    }
    return result;
  }
  function equalArrays(array, other, bitmask, customizer, equalFunc, stack) {
    var isPartial = bitmask & COMPARE_PARTIAL_FLAG, arrLength = array.length, othLength = other.length;
    if (arrLength != othLength && !(isPartial && othLength > arrLength)) {
      return false;
    }
    var stacked = stack.get(array);
    if (stacked && stack.get(other)) {
      return stacked == other;
    }
    var index = -1, result = true, seen = bitmask & COMPARE_UNORDERED_FLAG ? new SetCache() : void 0;
    stack.set(array, other);
    stack.set(other, array);
    while (++index < arrLength) {
      var arrValue = array[index], othValue = other[index];
      if (customizer) {
        var compared = isPartial ? customizer(othValue, arrValue, index, other, array, stack) : customizer(arrValue, othValue, index, array, other, stack);
      }
      if (compared !== void 0) {
        if (compared) {
          continue;
        }
        result = false;
        break;
      }
      if (seen) {
        if (!arraySome(other, function(othValue2, othIndex) {
          if (!cacheHas(seen, othIndex) && (arrValue === othValue2 || equalFunc(arrValue, othValue2, bitmask, customizer, stack))) {
            return seen.push(othIndex);
          }
        })) {
          result = false;
          break;
        }
      } else if (!(arrValue === othValue || equalFunc(arrValue, othValue, bitmask, customizer, stack))) {
        result = false;
        break;
      }
    }
    stack["delete"](array);
    stack["delete"](other);
    return result;
  }
  function equalByTag(object, other, tag, bitmask, customizer, equalFunc, stack) {
    switch (tag) {
      case dataViewTag:
        if (object.byteLength != other.byteLength || object.byteOffset != other.byteOffset) {
          return false;
        }
        object = object.buffer;
        other = other.buffer;
      case arrayBufferTag:
        if (object.byteLength != other.byteLength || !equalFunc(new Uint8Array2(object), new Uint8Array2(other))) {
          return false;
        }
        return true;
      case boolTag:
      case dateTag:
      case numberTag:
        return eq9(+object, +other);
      case errorTag:
        return object.name == other.name && object.message == other.message;
      case regexpTag:
      case stringTag:
        return object == other + "";
      case mapTag:
        var convert2 = mapToArray;
      case setTag:
        var isPartial = bitmask & COMPARE_PARTIAL_FLAG;
        convert2 || (convert2 = setToArray);
        if (object.size != other.size && !isPartial) {
          return false;
        }
        var stacked = stack.get(object);
        if (stacked) {
          return stacked == other;
        }
        bitmask |= COMPARE_UNORDERED_FLAG;
        stack.set(object, other);
        var result = equalArrays(convert2(object), convert2(other), bitmask, customizer, equalFunc, stack);
        stack["delete"](object);
        return result;
      case symbolTag:
        if (symbolValueOf) {
          return symbolValueOf.call(object) == symbolValueOf.call(other);
        }
    }
    return false;
  }
  function equalObjects(object, other, bitmask, customizer, equalFunc, stack) {
    var isPartial = bitmask & COMPARE_PARTIAL_FLAG, objProps = getAllKeys(object), objLength = objProps.length, othProps = getAllKeys(other), othLength = othProps.length;
    if (objLength != othLength && !isPartial) {
      return false;
    }
    var index = objLength;
    while (index--) {
      var key2 = objProps[index];
      if (!(isPartial ? key2 in other : hasOwnProperty.call(other, key2))) {
        return false;
      }
    }
    var stacked = stack.get(object);
    if (stacked && stack.get(other)) {
      return stacked == other;
    }
    var result = true;
    stack.set(object, other);
    stack.set(other, object);
    var skipCtor = isPartial;
    while (++index < objLength) {
      key2 = objProps[index];
      var objValue = object[key2], othValue = other[key2];
      if (customizer) {
        var compared = isPartial ? customizer(othValue, objValue, key2, other, object, stack) : customizer(objValue, othValue, key2, object, other, stack);
      }
      if (!(compared === void 0 ? objValue === othValue || equalFunc(objValue, othValue, bitmask, customizer, stack) : compared)) {
        result = false;
        break;
      }
      skipCtor || (skipCtor = key2 == "constructor");
    }
    if (result && !skipCtor) {
      var objCtor = object.constructor, othCtor = other.constructor;
      if (objCtor != othCtor && ("constructor" in object && "constructor" in other) && !(typeof objCtor == "function" && objCtor instanceof objCtor && typeof othCtor == "function" && othCtor instanceof othCtor)) {
        result = false;
      }
    }
    stack["delete"](object);
    stack["delete"](other);
    return result;
  }
  function getAllKeys(object) {
    return baseGetAllKeys(object, keys2, getSymbols);
  }
  function getMapData(map, key2) {
    var data = map.__data__;
    return isKeyable(key2) ? data[typeof key2 == "string" ? "string" : "hash"] : data.map;
  }
  function getNative(object, key2) {
    var value = getValue(object, key2);
    return baseIsNative(value) ? value : void 0;
  }
  function getRawTag(value) {
    var isOwn = hasOwnProperty.call(value, symToStringTag), tag = value[symToStringTag];
    try {
      value[symToStringTag] = void 0;
      var unmasked = true;
    } catch (e2) {
    }
    var result = nativeObjectToString.call(value);
    if (unmasked) {
      if (isOwn) {
        value[symToStringTag] = tag;
      } else {
        delete value[symToStringTag];
      }
    }
    return result;
  }
  var getSymbols = !nativeGetSymbols ? stubArray : function(object) {
    if (object == null) {
      return [];
    }
    object = Object(object);
    return arrayFilter(nativeGetSymbols(object), function(symbol) {
      return propertyIsEnumerable.call(object, symbol);
    });
  };
  var getTag = baseGetTag;
  if (DataView2 && getTag(new DataView2(new ArrayBuffer(1))) != dataViewTag || Map2 && getTag(new Map2()) != mapTag || Promise2 && getTag(Promise2.resolve()) != promiseTag || Set2 && getTag(new Set2()) != setTag || WeakMap && getTag(new WeakMap()) != weakMapTag) {
    getTag = function(value) {
      var result = baseGetTag(value), Ctor = result == objectTag ? value.constructor : void 0, ctorString = Ctor ? toSource(Ctor) : "";
      if (ctorString) {
        switch (ctorString) {
          case dataViewCtorString:
            return dataViewTag;
          case mapCtorString:
            return mapTag;
          case promiseCtorString:
            return promiseTag;
          case setCtorString:
            return setTag;
          case weakMapCtorString:
            return weakMapTag;
        }
      }
      return result;
    };
  }
  function isIndex(value, length) {
    length = length == null ? MAX_SAFE_INTEGER2 : length;
    return !!length && (typeof value == "number" || reIsUint.test(value)) && (value > -1 && value % 1 == 0 && value < length);
  }
  function isKeyable(value) {
    var type = typeof value;
    return type == "string" || type == "number" || type == "symbol" || type == "boolean" ? value !== "__proto__" : value === null;
  }
  function isMasked(func) {
    return !!maskSrcKey && maskSrcKey in func;
  }
  function isPrototype(value) {
    var Ctor = value && value.constructor, proto = typeof Ctor == "function" && Ctor.prototype || objectProto;
    return value === proto;
  }
  function objectToString(value) {
    return nativeObjectToString.call(value);
  }
  function toSource(func) {
    if (func != null) {
      try {
        return funcToString.call(func);
      } catch (e2) {
      }
      try {
        return func + "";
      } catch (e2) {
      }
    }
    return "";
  }
  function eq9(value, other) {
    return value === other || value !== value && other !== other;
  }
  var isArguments = baseIsArguments(/* @__PURE__ */ function() {
    return arguments;
  }()) ? baseIsArguments : function(value) {
    return isObjectLike(value) && hasOwnProperty.call(value, "callee") && !propertyIsEnumerable.call(value, "callee");
  };
  var isArray = Array.isArray;
  function isArrayLike(value) {
    return value != null && isLength(value.length) && !isFunction(value);
  }
  var isBuffer = nativeIsBuffer || stubFalse;
  function isEqual(value, other) {
    return baseIsEqual(value, other);
  }
  function isFunction(value) {
    if (!isObject(value)) {
      return false;
    }
    var tag = baseGetTag(value);
    return tag == funcTag || tag == genTag || tag == asyncTag || tag == proxyTag;
  }
  function isLength(value) {
    return typeof value == "number" && value > -1 && value % 1 == 0 && value <= MAX_SAFE_INTEGER2;
  }
  function isObject(value) {
    var type = typeof value;
    return value != null && (type == "object" || type == "function");
  }
  function isObjectLike(value) {
    return value != null && typeof value == "object";
  }
  var isTypedArray = nodeIsTypedArray ? baseUnary(nodeIsTypedArray) : baseIsTypedArray;
  function keys2(object) {
    return isArrayLike(object) ? arrayLikeKeys(object) : baseKeys(object);
  }
  function stubArray() {
    return [];
  }
  function stubFalse() {
    return false;
  }
  module.exports = isEqual;
})(lodash_isequal, lodash_isequal.exports);
var lodash_isequalExports = lodash_isequal.exports;
const ys$1 = /* @__PURE__ */ getDefaultExportFromCjs(lodash_isequalExports);
const ye$2 = "wc", De$1 = 2, ie$2 = "core", x$3 = `${ye$2}@2:${ie$2}:`, Ye = { name: ie$2, logger: "error" }, Je = { database: ":memory:" }, Xe = "crypto", me$2 = "client_ed25519_seed", We$1 = cjs$3.ONE_DAY, Ze$1 = "keychain", Qe = "0.3", et$1 = "messages", tt$1 = "0.3", it$2 = cjs$3.SIX_HOURS, st$2 = "publisher", rt$2 = "irn", nt$2 = "error", be$2 = "wss://relay.walletconnect.org", ot$2 = "relayer", v$2 = { message: "relayer_message", message_ack: "relayer_message_ack", connect: "relayer_connect", disconnect: "relayer_disconnect", error: "relayer_error", connection_stalled: "relayer_connection_stalled", transport_closed: "relayer_transport_closed", publish: "relayer_publish" }, at$2 = "_subscription", I$2 = { payload: "payload", connect: "connect", disconnect: "disconnect", error: "error" }, ht$2 = 0.1, se$2 = "2.17.1", M$2 = { link_mode: "link_mode", relay: "relay" }, ct$2 = "0.3", lt$2 = "WALLETCONNECT_CLIENT_ID", fe$1 = "WALLETCONNECT_LINK_MODE_APPS", O$2 = { created: "subscription_created", deleted: "subscription_deleted", expired: "subscription_expired", disabled: "subscription_disabled", sync: "subscription_sync", resubscribed: "subscription_resubscribed" }, ut$2 = "subscription", dt$2 = "0.3", pt$2 = cjs$3.FIVE_SECONDS * 1e3, gt$2 = "pairing", yt$2 = "0.3", B$2 = { wc_pairingDelete: { req: { ttl: cjs$3.ONE_DAY, prompt: false, tag: 1e3 }, res: { ttl: cjs$3.ONE_DAY, prompt: false, tag: 1001 } }, wc_pairingPing: { req: { ttl: cjs$3.THIRTY_SECONDS, prompt: false, tag: 1002 }, res: { ttl: cjs$3.THIRTY_SECONDS, prompt: false, tag: 1003 } }, unregistered_method: { req: { ttl: cjs$3.ONE_DAY, prompt: false, tag: 0 }, res: { ttl: cjs$3.ONE_DAY, prompt: false, tag: 0 } } }, V$2 = { create: "pairing_create", expire: "pairing_expire", delete: "pairing_delete", ping: "pairing_ping" }, P$1 = { created: "history_created", updated: "history_updated", deleted: "history_deleted", sync: "history_sync" }, Dt$1 = "history", mt$1 = "0.3", bt$1 = "expirer", S$3 = { created: "expirer_created", deleted: "expirer_deleted", expired: "expirer_expired", sync: "expirer_sync" }, ft$1 = "0.3", _t$1 = "verify-api", vs$1 = "https://verify.walletconnect.com", Et$1 = "https://verify.walletconnect.org", J$1 = Et$1, vt$1 = `${J$1}/v3`, wt$1 = [vs$1, Et$1], It$1 = "echo", Tt$1 = "https://echo.walletconnect.com", z$3 = { pairing_started: "pairing_started", pairing_uri_validation_success: "pairing_uri_validation_success", pairing_uri_not_expired: "pairing_uri_not_expired", store_new_pairing: "store_new_pairing", subscribing_pairing_topic: "subscribing_pairing_topic", subscribe_pairing_topic_success: "subscribe_pairing_topic_success", existing_pairing: "existing_pairing", pairing_not_expired: "pairing_not_expired", emit_inactive_pairing: "emit_inactive_pairing", emit_session_proposal: "emit_session_proposal", subscribing_to_pairing_topic: "subscribing_to_pairing_topic" }, $$1 = { no_wss_connection: "no_wss_connection", no_internet_connection: "no_internet_connection", malformed_pairing_uri: "malformed_pairing_uri", active_pairing_already_exists: "active_pairing_already_exists", subscribe_pairing_topic_failure: "subscribe_pairing_topic_failure", pairing_expired: "pairing_expired", proposal_expired: "proposal_expired", proposal_listener_not_found: "proposal_listener_not_found" }, Is$1 = { session_approve_started: "session_approve_started", proposal_not_expired: "proposal_not_expired", session_namespaces_validation_success: "session_namespaces_validation_success", create_session_topic: "create_session_topic", subscribing_session_topic: "subscribing_session_topic", subscribe_session_topic_success: "subscribe_session_topic_success", publishing_session_approve: "publishing_session_approve", session_approve_publish_success: "session_approve_publish_success", store_session: "store_session", publishing_session_settle: "publishing_session_settle", session_settle_publish_success: "session_settle_publish_success" }, Ts$1 = { no_internet_connection: "no_internet_connection", no_wss_connection: "no_wss_connection", proposal_expired: "proposal_expired", subscribe_session_topic_failure: "subscribe_session_topic_failure", session_approve_publish_failure: "session_approve_publish_failure", session_settle_publish_failure: "session_settle_publish_failure", session_approve_namespace_validation_failure: "session_approve_namespace_validation_failure", proposal_not_found: "proposal_not_found" }, Cs = { authenticated_session_approve_started: "authenticated_session_approve_started", authenticated_session_not_expired: "authenticated_session_not_expired", chains_caip2_compliant: "chains_caip2_compliant", chains_evm_compliant: "chains_evm_compliant", create_authenticated_session_topic: "create_authenticated_session_topic", cacaos_verified: "cacaos_verified", store_authenticated_session: "store_authenticated_session", subscribing_authenticated_session_topic: "subscribing_authenticated_session_topic", subscribe_authenticated_session_topic_success: "subscribe_authenticated_session_topic_success", publishing_authenticated_session_approve: "publishing_authenticated_session_approve", authenticated_session_approve_publish_success: "authenticated_session_approve_publish_success" }, Ps$1 = { no_internet_connection: "no_internet_connection", no_wss_connection: "no_wss_connection", missing_session_authenticate_request: "missing_session_authenticate_request", session_authenticate_request_expired: "session_authenticate_request_expired", chains_caip2_compliant_failure: "chains_caip2_compliant_failure", chains_evm_compliant_failure: "chains_evm_compliant_failure", invalid_cacao: "invalid_cacao", subscribe_authenticated_session_topic_failure: "subscribe_authenticated_session_topic_failure", authenticated_session_approve_publish_failure: "authenticated_session_approve_publish_failure", authenticated_session_pending_request_not_found: "authenticated_session_pending_request_not_found" }, Ct$1 = 0.1, Pt$1 = "event-client", St$1 = 86400, Rt$1 = "https://pulse.walletconnect.org/batch";
function Ss$1(o3, e2) {
  if (o3.length >= 255) throw new TypeError("Alphabet too long");
  for (var t = new Uint8Array(256), s2 = 0; s2 < t.length; s2++) t[s2] = 255;
  for (var i3 = 0; i3 < o3.length; i3++) {
    var r2 = o3.charAt(i3), n4 = r2.charCodeAt(0);
    if (t[n4] !== 255) throw new TypeError(r2 + " is ambiguous");
    t[n4] = i3;
  }
  var a3 = o3.length, h4 = o3.charAt(0), c2 = Math.log(a3) / Math.log(256), l2 = Math.log(256) / Math.log(a3);
  function p3(u2) {
    if (u2 instanceof Uint8Array || (ArrayBuffer.isView(u2) ? u2 = new Uint8Array(u2.buffer, u2.byteOffset, u2.byteLength) : Array.isArray(u2) && (u2 = Uint8Array.from(u2))), !(u2 instanceof Uint8Array)) throw new TypeError("Expected Uint8Array");
    if (u2.length === 0) return "";
    for (var g3 = 0, _3 = 0, y3 = 0, b2 = u2.length; y3 !== b2 && u2[y3] === 0; ) y3++, g3++;
    for (var A2 = (b2 - y3) * l2 + 1 >>> 0, T2 = new Uint8Array(A2); y3 !== b2; ) {
      for (var N2 = u2[y3], k2 = 0, R3 = A2 - 1; (N2 !== 0 || k2 < _3) && R3 !== -1; R3--, k2++) N2 += 256 * T2[R3] >>> 0, T2[R3] = N2 % a3 >>> 0, N2 = N2 / a3 >>> 0;
      if (N2 !== 0) throw new Error("Non-zero carry");
      _3 = k2, y3++;
    }
    for (var L3 = A2 - _3; L3 !== A2 && T2[L3] === 0; ) L3++;
    for (var Q2 = h4.repeat(g3); L3 < A2; ++L3) Q2 += o3.charAt(T2[L3]);
    return Q2;
  }
  function D2(u2) {
    if (typeof u2 != "string") throw new TypeError("Expected String");
    if (u2.length === 0) return new Uint8Array();
    var g3 = 0;
    if (u2[g3] !== " ") {
      for (var _3 = 0, y3 = 0; u2[g3] === h4; ) _3++, g3++;
      for (var b2 = (u2.length - g3) * c2 + 1 >>> 0, A2 = new Uint8Array(b2); u2[g3]; ) {
        var T2 = t[u2.charCodeAt(g3)];
        if (T2 === 255) return;
        for (var N2 = 0, k2 = b2 - 1; (T2 !== 0 || N2 < y3) && k2 !== -1; k2--, N2++) T2 += a3 * A2[k2] >>> 0, A2[k2] = T2 % 256 >>> 0, T2 = T2 / 256 >>> 0;
        if (T2 !== 0) throw new Error("Non-zero carry");
        y3 = N2, g3++;
      }
      if (u2[g3] !== " ") {
        for (var R3 = b2 - y3; R3 !== b2 && A2[R3] === 0; ) R3++;
        for (var L3 = new Uint8Array(_3 + (b2 - R3)), Q2 = _3; R3 !== b2; ) L3[Q2++] = A2[R3++];
        return L3;
      }
    }
  }
  function m2(u2) {
    var g3 = D2(u2);
    if (g3) return g3;
    throw new Error(`Non-${e2} character`);
  }
  return { encode: p3, decodeUnsafe: D2, decode: m2 };
}
var Rs$1 = Ss$1, xs = Rs$1;
const xt$1 = (o3) => {
  if (o3 instanceof Uint8Array && o3.constructor.name === "Uint8Array") return o3;
  if (o3 instanceof ArrayBuffer) return new Uint8Array(o3);
  if (ArrayBuffer.isView(o3)) return new Uint8Array(o3.buffer, o3.byteOffset, o3.byteLength);
  throw new Error("Unknown type, must be binary type");
}, Os = (o3) => new TextEncoder().encode(o3), As = (o3) => new TextDecoder().decode(o3);
let Ns$1 = class Ns {
  constructor(e2, t, s2) {
    this.name = e2, this.prefix = t, this.baseEncode = s2;
  }
  encode(e2) {
    if (e2 instanceof Uint8Array) return `${this.prefix}${this.baseEncode(e2)}`;
    throw Error("Unknown type, must be binary type");
  }
};
class zs {
  constructor(e2, t, s2) {
    if (this.name = e2, this.prefix = t, t.codePointAt(0) === void 0) throw new Error("Invalid prefix character");
    this.prefixCodePoint = t.codePointAt(0), this.baseDecode = s2;
  }
  decode(e2) {
    if (typeof e2 == "string") {
      if (e2.codePointAt(0) !== this.prefixCodePoint) throw Error(`Unable to decode multibase string ${JSON.stringify(e2)}, ${this.name} decoder only supports inputs prefixed with ${this.prefix}`);
      return this.baseDecode(e2.slice(this.prefix.length));
    } else throw Error("Can only multibase decode strings");
  }
  or(e2) {
    return Ot$1(this, e2);
  }
}
class Ls {
  constructor(e2) {
    this.decoders = e2;
  }
  or(e2) {
    return Ot$1(this, e2);
  }
  decode(e2) {
    const t = e2[0], s2 = this.decoders[t];
    if (s2) return s2.decode(e2);
    throw RangeError(`Unable to decode multibase string ${JSON.stringify(e2)}, only inputs prefixed with ${Object.keys(this.decoders)} are supported`);
  }
}
const Ot$1 = (o3, e2) => new Ls({ ...o3.decoders || { [o3.prefix]: o3 }, ...e2.decoders || { [e2.prefix]: e2 } });
class $s {
  constructor(e2, t, s2, i3) {
    this.name = e2, this.prefix = t, this.baseEncode = s2, this.baseDecode = i3, this.encoder = new Ns$1(e2, t, s2), this.decoder = new zs(e2, t, i3);
  }
  encode(e2) {
    return this.encoder.encode(e2);
  }
  decode(e2) {
    return this.decoder.decode(e2);
  }
}
const re$1 = ({ name: o3, prefix: e2, encode: t, decode: s2 }) => new $s(o3, e2, t, s2), X = ({ prefix: o3, name: e2, alphabet: t }) => {
  const { encode: s2, decode: i3 } = xs(t, e2);
  return re$1({ prefix: o3, name: e2, encode: s2, decode: (r2) => xt$1(i3(r2)) });
}, ks = (o3, e2, t, s2) => {
  const i3 = {};
  for (let l2 = 0; l2 < e2.length; ++l2) i3[e2[l2]] = l2;
  let r2 = o3.length;
  for (; o3[r2 - 1] === "="; ) --r2;
  const n4 = new Uint8Array(r2 * t / 8 | 0);
  let a3 = 0, h4 = 0, c2 = 0;
  for (let l2 = 0; l2 < r2; ++l2) {
    const p3 = i3[o3[l2]];
    if (p3 === void 0) throw new SyntaxError(`Non-${s2} character`);
    h4 = h4 << t | p3, a3 += t, a3 >= 8 && (a3 -= 8, n4[c2++] = 255 & h4 >> a3);
  }
  if (a3 >= t || 255 & h4 << 8 - a3) throw new SyntaxError("Unexpected end of data");
  return n4;
}, Ms = (o3, e2, t) => {
  const s2 = e2[e2.length - 1] === "=", i3 = (1 << t) - 1;
  let r2 = "", n4 = 0, a3 = 0;
  for (let h4 = 0; h4 < o3.length; ++h4) for (a3 = a3 << 8 | o3[h4], n4 += 8; n4 > t; ) n4 -= t, r2 += e2[i3 & a3 >> n4];
  if (n4 && (r2 += e2[i3 & a3 << t - n4]), s2) for (; r2.length * t & 7; ) r2 += "=";
  return r2;
}, f$1 = ({ name: o3, prefix: e2, bitsPerChar: t, alphabet: s2 }) => re$1({ prefix: e2, name: o3, encode(i3) {
  return Ms(i3, s2, t);
}, decode(i3) {
  return ks(i3, s2, t, o3);
} }), Us = re$1({ prefix: "\0", name: "identity", encode: (o3) => As(o3), decode: (o3) => Os(o3) });
var Fs = Object.freeze({ __proto__: null, identity: Us });
const Ks = f$1({ prefix: "0", name: "base2", alphabet: "01", bitsPerChar: 1 });
var Bs = Object.freeze({ __proto__: null, base2: Ks });
const Vs = f$1({ prefix: "7", name: "base8", alphabet: "01234567", bitsPerChar: 3 });
var js = Object.freeze({ __proto__: null, base8: Vs });
const qs$1 = X({ prefix: "9", name: "base10", alphabet: "0123456789" });
var Gs = Object.freeze({ __proto__: null, base10: qs$1 });
const Hs = f$1({ prefix: "f", name: "base16", alphabet: "0123456789abcdef", bitsPerChar: 4 }), Ys = f$1({ prefix: "F", name: "base16upper", alphabet: "0123456789ABCDEF", bitsPerChar: 4 });
var Js = Object.freeze({ __proto__: null, base16: Hs, base16upper: Ys });
const Xs = f$1({ prefix: "b", name: "base32", alphabet: "abcdefghijklmnopqrstuvwxyz234567", bitsPerChar: 5 }), Ws = f$1({ prefix: "B", name: "base32upper", alphabet: "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567", bitsPerChar: 5 }), Zs = f$1({ prefix: "c", name: "base32pad", alphabet: "abcdefghijklmnopqrstuvwxyz234567=", bitsPerChar: 5 }), Qs = f$1({ prefix: "C", name: "base32padupper", alphabet: "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567=", bitsPerChar: 5 }), er$1 = f$1({ prefix: "v", name: "base32hex", alphabet: "0123456789abcdefghijklmnopqrstuv", bitsPerChar: 5 }), tr$1 = f$1({ prefix: "V", name: "base32hexupper", alphabet: "0123456789ABCDEFGHIJKLMNOPQRSTUV", bitsPerChar: 5 }), ir$1 = f$1({ prefix: "t", name: "base32hexpad", alphabet: "0123456789abcdefghijklmnopqrstuv=", bitsPerChar: 5 }), sr$1 = f$1({ prefix: "T", name: "base32hexpadupper", alphabet: "0123456789ABCDEFGHIJKLMNOPQRSTUV=", bitsPerChar: 5 }), rr$1 = f$1({ prefix: "h", name: "base32z", alphabet: "ybndrfg8ejkmcpqxot1uwisza345h769", bitsPerChar: 5 });
var nr$1 = Object.freeze({ __proto__: null, base32: Xs, base32upper: Ws, base32pad: Zs, base32padupper: Qs, base32hex: er$1, base32hexupper: tr$1, base32hexpad: ir$1, base32hexpadupper: sr$1, base32z: rr$1 });
const or$1 = X({ prefix: "k", name: "base36", alphabet: "0123456789abcdefghijklmnopqrstuvwxyz" }), ar$1 = X({ prefix: "K", name: "base36upper", alphabet: "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ" });
var hr$1 = Object.freeze({ __proto__: null, base36: or$1, base36upper: ar$1 });
const cr$1 = X({ name: "base58btc", prefix: "z", alphabet: "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz" }), lr$1 = X({ name: "base58flickr", prefix: "Z", alphabet: "123456789abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ" });
var ur$1 = Object.freeze({ __proto__: null, base58btc: cr$1, base58flickr: lr$1 });
const dr$1 = f$1({ prefix: "m", name: "base64", alphabet: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/", bitsPerChar: 6 }), pr$1 = f$1({ prefix: "M", name: "base64pad", alphabet: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=", bitsPerChar: 6 }), gr$1 = f$1({ prefix: "u", name: "base64url", alphabet: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_", bitsPerChar: 6 }), yr$1 = f$1({ prefix: "U", name: "base64urlpad", alphabet: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_=", bitsPerChar: 6 });
var Dr$1 = Object.freeze({ __proto__: null, base64: dr$1, base64pad: pr$1, base64url: gr$1, base64urlpad: yr$1 });
const At$1 = Array.from("🚀🪐☄🛰🌌🌑🌒🌓🌔🌕🌖🌗🌘🌍🌏🌎🐉☀💻🖥💾💿😂❤😍🤣😊🙏💕😭😘👍😅👏😁🔥🥰💔💖💙😢🤔😆🙄💪😉☺👌🤗💜😔😎😇🌹🤦🎉💞✌✨🤷😱😌🌸🙌😋💗💚😏💛🙂💓🤩😄😀🖤😃💯🙈👇🎶😒🤭❣😜💋👀😪😑💥🙋😞😩😡🤪👊🥳😥🤤👉💃😳✋😚😝😴🌟😬🙃🍀🌷😻😓⭐✅🥺🌈😈🤘💦✔😣🏃💐☹🎊💘😠☝😕🌺🎂🌻😐🖕💝🙊😹🗣💫💀👑🎵🤞😛🔴😤🌼😫⚽🤙☕🏆🤫👈😮🙆🍻🍃🐶💁😲🌿🧡🎁⚡🌞🎈❌✊👋😰🤨😶🤝🚶💰🍓💢🤟🙁🚨💨🤬✈🎀🍺🤓😙💟🌱😖👶🥴▶➡❓💎💸⬇😨🌚🦋😷🕺⚠🙅😟😵👎🤲🤠🤧📌🔵💅🧐🐾🍒😗🤑🌊🤯🐷☎💧😯💆👆🎤🙇🍑❄🌴💣🐸💌📍🥀🤢👅💡💩👐📸👻🤐🤮🎼🥵🚩🍎🍊👼💍📣🥂"), mr$1 = At$1.reduce((o3, e2, t) => (o3[t] = e2, o3), []), br$1 = At$1.reduce((o3, e2, t) => (o3[e2.codePointAt(0)] = t, o3), []);
function fr$1(o3) {
  return o3.reduce((e2, t) => (e2 += mr$1[t], e2), "");
}
function _r$1(o3) {
  const e2 = [];
  for (const t of o3) {
    const s2 = br$1[t.codePointAt(0)];
    if (s2 === void 0) throw new Error(`Non-base256emoji character: ${t}`);
    e2.push(s2);
  }
  return new Uint8Array(e2);
}
const Er$1 = re$1({ prefix: "🚀", name: "base256emoji", encode: fr$1, decode: _r$1 });
var vr$1 = Object.freeze({ __proto__: null, base256emoji: Er$1 }), wr$1 = zt$1, Nt$1 = 128, Ir = 127, Tr$1 = ~Ir, Cr$1 = Math.pow(2, 31);
function zt$1(o3, e2, t) {
  e2 = e2 || [], t = t || 0;
  for (var s2 = t; o3 >= Cr$1; ) e2[t++] = o3 & 255 | Nt$1, o3 /= 128;
  for (; o3 & Tr$1; ) e2[t++] = o3 & 255 | Nt$1, o3 >>>= 7;
  return e2[t] = o3 | 0, zt$1.bytes = t - s2 + 1, e2;
}
var Pr$1 = _e$1, Sr$1 = 128, Lt$1 = 127;
function _e$1(o3, s2) {
  var t = 0, s2 = s2 || 0, i3 = 0, r2 = s2, n4, a3 = o3.length;
  do {
    if (r2 >= a3) throw _e$1.bytes = 0, new RangeError("Could not decode varint");
    n4 = o3[r2++], t += i3 < 28 ? (n4 & Lt$1) << i3 : (n4 & Lt$1) * Math.pow(2, i3), i3 += 7;
  } while (n4 >= Sr$1);
  return _e$1.bytes = r2 - s2, t;
}
var Rr$1 = Math.pow(2, 7), xr$1 = Math.pow(2, 14), Or$1 = Math.pow(2, 21), Ar$1 = Math.pow(2, 28), Nr$1 = Math.pow(2, 35), zr$1 = Math.pow(2, 42), Lr = Math.pow(2, 49), $r$1 = Math.pow(2, 56), kr = Math.pow(2, 63), Mr = function(o3) {
  return o3 < Rr$1 ? 1 : o3 < xr$1 ? 2 : o3 < Or$1 ? 3 : o3 < Ar$1 ? 4 : o3 < Nr$1 ? 5 : o3 < zr$1 ? 6 : o3 < Lr ? 7 : o3 < $r$1 ? 8 : o3 < kr ? 9 : 10;
}, Ur = { encode: wr$1, decode: Pr$1, encodingLength: Mr }, $t$1 = Ur;
const kt$1 = (o3, e2, t = 0) => ($t$1.encode(o3, e2, t), e2), Mt$1 = (o3) => $t$1.encodingLength(o3), Ee$1 = (o3, e2) => {
  const t = e2.byteLength, s2 = Mt$1(o3), i3 = s2 + Mt$1(t), r2 = new Uint8Array(i3 + t);
  return kt$1(o3, r2, 0), kt$1(t, r2, s2), r2.set(e2, i3), new Fr$1(o3, t, e2, r2);
};
let Fr$1 = class Fr {
  constructor(e2, t, s2, i3) {
    this.code = e2, this.size = t, this.digest = s2, this.bytes = i3;
  }
};
const Ut$1 = ({ name: o3, code: e2, encode: t }) => new Kr(o3, e2, t);
class Kr {
  constructor(e2, t, s2) {
    this.name = e2, this.code = t, this.encode = s2;
  }
  digest(e2) {
    if (e2 instanceof Uint8Array) {
      const t = this.encode(e2);
      return t instanceof Uint8Array ? Ee$1(this.code, t) : t.then((s2) => Ee$1(this.code, s2));
    } else throw Error("Unknown type, must be binary type");
  }
}
const Ft$1 = (o3) => async (e2) => new Uint8Array(await crypto.subtle.digest(o3, e2)), Br$1 = Ut$1({ name: "sha2-256", code: 18, encode: Ft$1("SHA-256") }), Vr = Ut$1({ name: "sha2-512", code: 19, encode: Ft$1("SHA-512") });
var jr = Object.freeze({ __proto__: null, sha256: Br$1, sha512: Vr });
const Kt$1 = 0, qr = "identity", Bt$1 = xt$1, Gr = (o3) => Ee$1(Kt$1, Bt$1(o3)), Hr = { code: Kt$1, name: qr, encode: Bt$1, digest: Gr };
var Yr = Object.freeze({ __proto__: null, identity: Hr });
new TextEncoder(), new TextDecoder();
const Vt$1 = { ...Fs, ...Bs, ...js, ...Gs, ...Js, ...nr$1, ...hr$1, ...ur$1, ...Dr$1, ...vr$1 };
({ ...jr, ...Yr });
function Jr(o3 = 0) {
  return globalThis.Buffer != null && globalThis.Buffer.allocUnsafe != null ? globalThis.Buffer.allocUnsafe(o3) : new Uint8Array(o3);
}
function jt$1(o3, e2, t, s2) {
  return { name: o3, prefix: e2, encoder: { name: o3, prefix: e2, encode: t }, decoder: { decode: s2 } };
}
const qt$1 = jt$1("utf8", "u", (o3) => "u" + new TextDecoder("utf8").decode(o3), (o3) => new TextEncoder().encode(o3.substring(1))), ve = jt$1("ascii", "a", (o3) => {
  let e2 = "a";
  for (let t = 0; t < o3.length; t++) e2 += String.fromCharCode(o3[t]);
  return e2;
}, (o3) => {
  o3 = o3.substring(1);
  const e2 = Jr(o3.length);
  for (let t = 0; t < o3.length; t++) e2[t] = o3.charCodeAt(t);
  return e2;
}), Xr = { utf8: qt$1, "utf-8": qt$1, hex: Vt$1.base16, latin1: ve, ascii: ve, binary: ve, ...Vt$1 };
function Wr(o3, e2 = "utf8") {
  const t = Xr[e2];
  if (!t) throw new Error(`Unsupported encoding "${e2}"`);
  return (e2 === "utf8" || e2 === "utf-8") && globalThis.Buffer != null && globalThis.Buffer.from != null ? globalThis.Buffer.from(o3, "utf8") : t.decoder.decode(`${t.prefix}${o3}`);
}
let Gt$1 = class Gt {
  constructor(e2, t) {
    this.core = e2, this.logger = t, this.keychain = /* @__PURE__ */ new Map(), this.name = Ze$1, this.version = Qe, this.initialized = false, this.storagePrefix = x$3, this.init = async () => {
      if (!this.initialized) {
        const s2 = await this.getKeyChain();
        typeof s2 < "u" && (this.keychain = s2), this.initialized = true;
      }
    }, this.has = (s2) => (this.isInitialized(), this.keychain.has(s2)), this.set = async (s2, i3) => {
      this.isInitialized(), this.keychain.set(s2, i3), await this.persist();
    }, this.get = (s2) => {
      this.isInitialized();
      const i3 = this.keychain.get(s2);
      if (typeof i3 > "u") {
        const { message: r2 } = S$5("NO_MATCHING_KEY", `${this.name}: ${s2}`);
        throw new Error(r2);
      }
      return i3;
    }, this.del = async (s2) => {
      this.isInitialized(), this.keychain.delete(s2), await this.persist();
    }, this.core = e2, this.logger = E$1(t, this.name);
  }
  get context() {
    return y$3(this.logger);
  }
  get storageKey() {
    return this.storagePrefix + this.version + this.core.customStoragePrefix + "//" + this.name;
  }
  async setKeyChain(e2) {
    await this.core.storage.setItem(this.storageKey, Tt$2(e2));
  }
  async getKeyChain() {
    const e2 = await this.core.storage.getItem(this.storageKey);
    return typeof e2 < "u" ? Pt$2(e2) : void 0;
  }
  async persist() {
    await this.setKeyChain(this.keychain);
  }
  isInitialized() {
    if (!this.initialized) {
      const { message: e2 } = S$5("NOT_INITIALIZED", this.name);
      throw new Error(e2);
    }
  }
};
let Ht$1 = class Ht {
  constructor(e2, t, s2) {
    this.core = e2, this.logger = t, this.name = Xe, this.randomSessionIdentifier = pr$2(), this.initialized = false, this.init = async () => {
      this.initialized || (await this.keychain.init(), this.initialized = true);
    }, this.hasKeys = (i3) => (this.isInitialized(), this.keychain.has(i3)), this.getClientId = async () => {
      this.isInitialized();
      const i3 = await this.getClientSeed(), r2 = generateKeyPair(i3);
      return encodeIss(r2.publicKey);
    }, this.generateKeyPair = () => {
      this.isInitialized();
      const i3 = fr$2();
      return this.setPrivateKey(i3.publicKey, i3.privateKey);
    }, this.signJWT = async (i3) => {
      this.isInitialized();
      const r2 = await this.getClientSeed(), n4 = generateKeyPair(r2), a3 = this.randomSessionIdentifier, h4 = We$1;
      return await signJWT(a3, i3, h4, n4);
    }, this.generateSharedKey = (i3, r2, n4) => {
      this.isInitialized();
      const a3 = this.getPrivateKey(i3), h4 = mr$2(a3, r2);
      return this.setSymKey(h4, n4);
    }, this.setSymKey = async (i3, r2) => {
      this.isInitialized();
      const n4 = r2 || hr$2(i3);
      return await this.keychain.set(n4, i3), n4;
    }, this.deleteKeyPair = async (i3) => {
      this.isInitialized(), await this.keychain.del(i3);
    }, this.deleteSymKey = async (i3) => {
      this.isInitialized(), await this.keychain.del(i3);
    }, this.encode = async (i3, r2, n4) => {
      this.isInitialized();
      const a3 = On(n4), h4 = safeJsonStringify(r2);
      if (Nr$2(a3)) return vr$2(h4, n4 == null ? void 0 : n4.encoding);
      if (Or$2(a3)) {
        const D2 = a3.senderPublicKey, m2 = a3.receiverPublicKey;
        i3 = await this.generateSharedKey(D2, m2);
      }
      const c2 = this.getSymKey(i3), { type: l2, senderPublicKey: p3 } = a3;
      return gr$2({ type: l2, symKey: c2, message: h4, senderPublicKey: p3, encoding: n4 == null ? void 0 : n4.encoding });
    }, this.decode = async (i3, r2, n4) => {
      this.isInitialized();
      const a3 = wr$2(r2, n4);
      if (Nr$2(a3)) {
        const h4 = Er$2(r2, n4 == null ? void 0 : n4.encoding);
        return safeJsonParse(h4);
      }
      if (Or$2(a3)) {
        const h4 = a3.receiverPublicKey, c2 = a3.senderPublicKey;
        i3 = await this.generateSharedKey(h4, c2);
      }
      try {
        const h4 = this.getSymKey(i3), c2 = br$2({ symKey: h4, encoded: r2, encoding: n4 == null ? void 0 : n4.encoding });
        return safeJsonParse(c2);
      } catch (h4) {
        this.logger.error(`Failed to decode message from topic: '${i3}', clientId: '${await this.getClientId()}'`), this.logger.error(h4);
      }
    }, this.getPayloadType = (i3, r2 = ge$1) => {
      const n4 = Q$1({ encoded: i3, encoding: r2 });
      return A(n4.type);
    }, this.getPayloadSenderPublicKey = (i3, r2 = ge$1) => {
      const n4 = Q$1({ encoded: i3, encoding: r2 });
      return n4.senderPublicKey ? toString(n4.senderPublicKey, g$1) : void 0;
    }, this.core = e2, this.logger = E$1(t, this.name), this.keychain = s2 || new Gt$1(this.core, this.logger);
  }
  get context() {
    return y$3(this.logger);
  }
  async setPrivateKey(e2, t) {
    return await this.keychain.set(e2, t), e2;
  }
  getPrivateKey(e2) {
    return this.keychain.get(e2);
  }
  async getClientSeed() {
    let e2 = "";
    try {
      e2 = this.keychain.get(me$2);
    } catch {
      e2 = pr$2(), await this.keychain.set(me$2, e2);
    }
    return Wr(e2, "base16");
  }
  getSymKey(e2) {
    return this.keychain.get(e2);
  }
  isInitialized() {
    if (!this.initialized) {
      const { message: e2 } = S$5("NOT_INITIALIZED", this.name);
      throw new Error(e2);
    }
  }
};
let Yt$1 = class Yt extends a$1 {
  constructor(e2, t) {
    super(e2, t), this.logger = e2, this.core = t, this.messages = /* @__PURE__ */ new Map(), this.name = et$1, this.version = tt$1, this.initialized = false, this.storagePrefix = x$3, this.init = async () => {
      if (!this.initialized) {
        this.logger.trace("Initialized");
        try {
          const s2 = await this.getRelayerMessages();
          typeof s2 < "u" && (this.messages = s2), this.logger.debug(`Successfully Restored records for ${this.name}`), this.logger.trace({ type: "method", method: "restore", size: this.messages.size });
        } catch (s2) {
          this.logger.debug(`Failed to Restore records for ${this.name}`), this.logger.error(s2);
        } finally {
          this.initialized = true;
        }
      }
    }, this.set = async (s2, i3) => {
      this.isInitialized();
      const r2 = yr$2(i3);
      let n4 = this.messages.get(s2);
      return typeof n4 > "u" && (n4 = {}), typeof n4[r2] < "u" || (n4[r2] = i3, this.messages.set(s2, n4), await this.persist()), r2;
    }, this.get = (s2) => {
      this.isInitialized();
      let i3 = this.messages.get(s2);
      return typeof i3 > "u" && (i3 = {}), i3;
    }, this.has = (s2, i3) => {
      this.isInitialized();
      const r2 = this.get(s2), n4 = yr$2(i3);
      return typeof r2[n4] < "u";
    }, this.del = async (s2) => {
      this.isInitialized(), this.messages.delete(s2), await this.persist();
    }, this.logger = E$1(e2, this.name), this.core = t;
  }
  get context() {
    return y$3(this.logger);
  }
  get storageKey() {
    return this.storagePrefix + this.version + this.core.customStoragePrefix + "//" + this.name;
  }
  async setRelayerMessages(e2) {
    await this.core.storage.setItem(this.storageKey, Tt$2(e2));
  }
  async getRelayerMessages() {
    const e2 = await this.core.storage.getItem(this.storageKey);
    return typeof e2 < "u" ? Pt$2(e2) : void 0;
  }
  async persist() {
    await this.setRelayerMessages(this.messages);
  }
  isInitialized() {
    if (!this.initialized) {
      const { message: e2 } = S$5("NOT_INITIALIZED", this.name);
      throw new Error(e2);
    }
  }
};
class Zr extends g$2 {
  constructor(e2, t) {
    super(e2, t), this.relayer = e2, this.logger = t, this.events = new eventsExports.EventEmitter(), this.name = st$2, this.queue = /* @__PURE__ */ new Map(), this.publishTimeout = cjs$3.toMiliseconds(cjs$3.ONE_MINUTE), this.failedPublishTimeout = cjs$3.toMiliseconds(cjs$3.ONE_SECOND), this.needsTransportRestart = false, this.publish = async (s2, i3, r2) => {
      var n4;
      this.logger.debug("Publishing Payload"), this.logger.trace({ type: "method", method: "publish", params: { topic: s2, message: i3, opts: r2 } });
      const a3 = (r2 == null ? void 0 : r2.ttl) || it$2, h4 = Ir$1(r2), c2 = (r2 == null ? void 0 : r2.prompt) || false, l2 = (r2 == null ? void 0 : r2.tag) || 0, p3 = (r2 == null ? void 0 : r2.id) || getBigIntRpcId().toString(), D2 = { topic: s2, message: i3, opts: { ttl: a3, relay: h4, prompt: c2, tag: l2, id: p3, attestation: r2 == null ? void 0 : r2.attestation } }, m2 = `Failed to publish payload, please try again. id:${p3} tag:${l2}`, u2 = Date.now();
      let g3, _3 = 1;
      try {
        for (; g3 === void 0; ) {
          if (Date.now() - u2 > this.publishTimeout) throw new Error(m2);
          this.logger.trace({ id: p3, attempts: _3 }, `publisher.publish - attempt ${_3}`), g3 = await await kt$2(this.rpcPublish(s2, i3, a3, h4, c2, l2, p3, r2 == null ? void 0 : r2.attestation).catch((y3) => this.logger.warn(y3)), this.publishTimeout, m2), _3++, g3 || await new Promise((y3) => setTimeout(y3, this.failedPublishTimeout));
        }
        this.relayer.events.emit(v$2.publish, D2), this.logger.debug("Successfully Published Payload"), this.logger.trace({ type: "method", method: "publish", params: { id: p3, topic: s2, message: i3, opts: r2 } });
      } catch (y3) {
        if (this.logger.debug("Failed to Publish Payload"), this.logger.error(y3), (n4 = r2 == null ? void 0 : r2.internal) != null && n4.throwOnFailedPublish) throw y3;
        this.queue.set(p3, D2);
      }
    }, this.on = (s2, i3) => {
      this.events.on(s2, i3);
    }, this.once = (s2, i3) => {
      this.events.once(s2, i3);
    }, this.off = (s2, i3) => {
      this.events.off(s2, i3);
    }, this.removeListener = (s2, i3) => {
      this.events.removeListener(s2, i3);
    }, this.relayer = e2, this.logger = E$1(t, this.name), this.registerEventListeners();
  }
  get context() {
    return y$3(this.logger);
  }
  rpcPublish(e2, t, s2, i3, r2, n4, a3, h4) {
    var c2, l2, p3, D2;
    const m2 = { method: jr$1(i3.protocol).publish, params: { topic: e2, message: t, ttl: s2, prompt: r2, tag: n4, attestation: h4 }, id: a3 };
    return I$3((c2 = m2.params) == null ? void 0 : c2.prompt) && ((l2 = m2.params) == null || delete l2.prompt), I$3((p3 = m2.params) == null ? void 0 : p3.tag) && ((D2 = m2.params) == null || delete D2.tag), this.logger.debug("Outgoing Relay Payload"), this.logger.trace({ type: "message", direction: "outgoing", request: m2 }), this.relayer.request(m2);
  }
  removeRequestFromQueue(e2) {
    this.queue.delete(e2);
  }
  checkQueue() {
    this.queue.forEach(async (e2) => {
      const { topic: t, message: s2, opts: i3 } = e2;
      await this.publish(t, s2, i3);
    });
  }
  registerEventListeners() {
    this.relayer.core.heartbeat.on(r$1.pulse, () => {
      if (this.needsTransportRestart) {
        this.needsTransportRestart = false, this.relayer.events.emit(v$2.connection_stalled);
        return;
      }
      this.checkQueue();
    }), this.relayer.on(v$2.message_ack, (e2) => {
      this.removeRequestFromQueue(e2.id.toString());
    });
  }
}
class Qr {
  constructor() {
    this.map = /* @__PURE__ */ new Map(), this.set = (e2, t) => {
      const s2 = this.get(e2);
      this.exists(e2, t) || this.map.set(e2, [...s2, t]);
    }, this.get = (e2) => this.map.get(e2) || [], this.exists = (e2, t) => this.get(e2).includes(t), this.delete = (e2, t) => {
      if (typeof t > "u") {
        this.map.delete(e2);
        return;
      }
      if (!this.map.has(e2)) return;
      const s2 = this.get(e2);
      if (!this.exists(e2, t)) return;
      const i3 = s2.filter((r2) => r2 !== t);
      if (!i3.length) {
        this.map.delete(e2);
        return;
      }
      this.map.set(e2, i3);
    }, this.clear = () => {
      this.map.clear();
    };
  }
  get topics() {
    return Array.from(this.map.keys());
  }
}
var en = Object.defineProperty, tn = Object.defineProperties, sn = Object.getOwnPropertyDescriptors, Jt$1 = Object.getOwnPropertySymbols, rn = Object.prototype.hasOwnProperty, nn = Object.prototype.propertyIsEnumerable, Xt$1 = (o3, e2, t) => e2 in o3 ? en(o3, e2, { enumerable: true, configurable: true, writable: true, value: t }) : o3[e2] = t, W$1 = (o3, e2) => {
  for (var t in e2 || (e2 = {})) rn.call(e2, t) && Xt$1(o3, t, e2[t]);
  if (Jt$1) for (var t of Jt$1(e2)) nn.call(e2, t) && Xt$1(o3, t, e2[t]);
  return o3;
}, we$2 = (o3, e2) => tn(o3, sn(e2));
let Wt$1 = class Wt extends d$1 {
  constructor(e2, t) {
    super(e2, t), this.relayer = e2, this.logger = t, this.subscriptions = /* @__PURE__ */ new Map(), this.topicMap = new Qr(), this.events = new eventsExports.EventEmitter(), this.name = ut$2, this.version = dt$2, this.pending = /* @__PURE__ */ new Map(), this.cached = [], this.initialized = false, this.pendingSubscriptionWatchLabel = "pending_sub_watch_label", this.pollingInterval = 20, this.storagePrefix = x$3, this.subscribeTimeout = cjs$3.toMiliseconds(cjs$3.ONE_MINUTE), this.restartInProgress = false, this.batchSubscribeTopicsLimit = 500, this.pendingBatchMessages = [], this.init = async () => {
      this.initialized || (this.logger.trace("Initialized"), this.registerEventListeners(), this.clientId = await this.relayer.core.crypto.getClientId(), await this.restore()), this.initialized = true;
    }, this.subscribe = async (s2, i3) => {
      this.isInitialized(), this.logger.debug("Subscribing Topic"), this.logger.trace({ type: "method", method: "subscribe", params: { topic: s2, opts: i3 } });
      try {
        const r2 = Ir$1(i3), n4 = { topic: s2, relay: r2, transportType: i3 == null ? void 0 : i3.transportType };
        this.pending.set(s2, n4);
        const a3 = await this.rpcSubscribe(s2, r2, i3);
        return typeof a3 == "string" && (this.onSubscribe(a3, n4), this.logger.debug("Successfully Subscribed Topic"), this.logger.trace({ type: "method", method: "subscribe", params: { topic: s2, opts: i3 } })), a3;
      } catch (r2) {
        throw this.logger.debug("Failed to Subscribe Topic"), this.logger.error(r2), r2;
      }
    }, this.unsubscribe = async (s2, i3) => {
      await this.restartToComplete(), this.isInitialized(), typeof (i3 == null ? void 0 : i3.id) < "u" ? await this.unsubscribeById(s2, i3.id, i3) : await this.unsubscribeByTopic(s2, i3);
    }, this.isSubscribed = async (s2) => {
      if (this.topics.includes(s2)) return true;
      const i3 = `${this.pendingSubscriptionWatchLabel}_${s2}`;
      return await new Promise((r2, n4) => {
        const a3 = new cjs$3.Watch();
        a3.start(i3);
        const h4 = setInterval(() => {
          !this.pending.has(s2) && this.topics.includes(s2) && (clearInterval(h4), a3.stop(i3), r2(true)), a3.elapsed(i3) >= pt$2 && (clearInterval(h4), a3.stop(i3), n4(new Error("Subscription resolution timeout")));
        }, this.pollingInterval);
      }).catch(() => false);
    }, this.on = (s2, i3) => {
      this.events.on(s2, i3);
    }, this.once = (s2, i3) => {
      this.events.once(s2, i3);
    }, this.off = (s2, i3) => {
      this.events.off(s2, i3);
    }, this.removeListener = (s2, i3) => {
      this.events.removeListener(s2, i3);
    }, this.start = async () => {
      await this.onConnect();
    }, this.stop = async () => {
      await this.onDisconnect();
    }, this.restart = async () => {
      this.restartInProgress = true, await this.restore(), await this.reset(), this.restartInProgress = false;
    }, this.relayer = e2, this.logger = E$1(t, this.name), this.clientId = "";
  }
  get context() {
    return y$3(this.logger);
  }
  get storageKey() {
    return this.storagePrefix + this.version + this.relayer.core.customStoragePrefix + "//" + this.name;
  }
  get length() {
    return this.subscriptions.size;
  }
  get ids() {
    return Array.from(this.subscriptions.keys());
  }
  get values() {
    return Array.from(this.subscriptions.values());
  }
  get topics() {
    return this.topicMap.topics;
  }
  hasSubscription(e2, t) {
    let s2 = false;
    try {
      s2 = this.getSubscription(e2).topic === t;
    } catch {
    }
    return s2;
  }
  onEnable() {
    this.cached = [], this.initialized = true;
  }
  onDisable() {
    this.cached = this.values, this.subscriptions.clear(), this.topicMap.clear();
  }
  async unsubscribeByTopic(e2, t) {
    const s2 = this.topicMap.get(e2);
    await Promise.all(s2.map(async (i3) => await this.unsubscribeById(e2, i3, t)));
  }
  async unsubscribeById(e2, t, s2) {
    this.logger.debug("Unsubscribing Topic"), this.logger.trace({ type: "method", method: "unsubscribe", params: { topic: e2, id: t, opts: s2 } });
    try {
      const i3 = Ir$1(s2);
      await this.rpcUnsubscribe(e2, t, i3);
      const r2 = U$2("USER_DISCONNECTED", `${this.name}, ${e2}`);
      await this.onUnsubscribe(e2, t, r2), this.logger.debug("Successfully Unsubscribed Topic"), this.logger.trace({ type: "method", method: "unsubscribe", params: { topic: e2, id: t, opts: s2 } });
    } catch (i3) {
      throw this.logger.debug("Failed to Unsubscribe Topic"), this.logger.error(i3), i3;
    }
  }
  async rpcSubscribe(e2, t, s2) {
    var i3;
    (s2 == null ? void 0 : s2.transportType) === M$2.relay && await this.restartToComplete();
    const r2 = { method: jr$1(t.protocol).subscribe, params: { topic: e2 } };
    this.logger.debug("Outgoing Relay Payload"), this.logger.trace({ type: "payload", direction: "outgoing", request: r2 });
    const n4 = (i3 = s2 == null ? void 0 : s2.internal) == null ? void 0 : i3.throwOnFailedPublish;
    try {
      const a3 = yr$2(e2 + this.clientId);
      if ((s2 == null ? void 0 : s2.transportType) === M$2.link_mode) return setTimeout(() => {
        (this.relayer.connected || this.relayer.connecting) && this.relayer.request(r2).catch((c2) => this.logger.warn(c2));
      }, cjs$3.toMiliseconds(cjs$3.ONE_SECOND)), a3;
      const h4 = await kt$2(this.relayer.request(r2).catch((c2) => this.logger.warn(c2)), this.subscribeTimeout, `Subscribing to ${e2} failed, please try again`);
      if (!h4 && n4) throw new Error(`Subscribing to ${e2} failed, please try again`);
      return h4 ? a3 : null;
    } catch (a3) {
      if (this.logger.debug("Outgoing Relay Subscribe Payload stalled"), this.relayer.events.emit(v$2.connection_stalled), n4) throw a3;
    }
    return null;
  }
  async rpcBatchSubscribe(e2) {
    if (!e2.length) return;
    const t = e2[0].relay, s2 = { method: jr$1(t.protocol).batchSubscribe, params: { topics: e2.map((i3) => i3.topic) } };
    this.logger.debug("Outgoing Relay Payload"), this.logger.trace({ type: "payload", direction: "outgoing", request: s2 });
    try {
      return await await kt$2(this.relayer.request(s2).catch((i3) => this.logger.warn(i3)), this.subscribeTimeout);
    } catch {
      this.relayer.events.emit(v$2.connection_stalled);
    }
  }
  async rpcBatchFetchMessages(e2) {
    if (!e2.length) return;
    const t = e2[0].relay, s2 = { method: jr$1(t.protocol).batchFetchMessages, params: { topics: e2.map((r2) => r2.topic) } };
    this.logger.debug("Outgoing Relay Payload"), this.logger.trace({ type: "payload", direction: "outgoing", request: s2 });
    let i3;
    try {
      i3 = await await kt$2(this.relayer.request(s2).catch((r2) => this.logger.warn(r2)), this.subscribeTimeout);
    } catch {
      this.relayer.events.emit(v$2.connection_stalled);
    }
    return i3;
  }
  rpcUnsubscribe(e2, t, s2) {
    const i3 = { method: jr$1(s2.protocol).unsubscribe, params: { topic: e2, id: t } };
    return this.logger.debug("Outgoing Relay Payload"), this.logger.trace({ type: "payload", direction: "outgoing", request: i3 }), this.relayer.request(i3);
  }
  onSubscribe(e2, t) {
    this.setSubscription(e2, we$2(W$1({}, t), { id: e2 })), this.pending.delete(t.topic);
  }
  onBatchSubscribe(e2) {
    e2.length && e2.forEach((t) => {
      this.setSubscription(t.id, W$1({}, t)), this.pending.delete(t.topic);
    });
  }
  async onUnsubscribe(e2, t, s2) {
    this.events.removeAllListeners(t), this.hasSubscription(t, e2) && this.deleteSubscription(t, s2), await this.relayer.messages.del(e2);
  }
  async setRelayerSubscriptions(e2) {
    await this.relayer.core.storage.setItem(this.storageKey, e2);
  }
  async getRelayerSubscriptions() {
    return await this.relayer.core.storage.getItem(this.storageKey);
  }
  setSubscription(e2, t) {
    this.logger.debug("Setting subscription"), this.logger.trace({ type: "method", method: "setSubscription", id: e2, subscription: t }), this.addSubscription(e2, t);
  }
  addSubscription(e2, t) {
    this.subscriptions.set(e2, W$1({}, t)), this.topicMap.set(t.topic, e2), this.events.emit(O$2.created, t);
  }
  getSubscription(e2) {
    this.logger.debug("Getting subscription"), this.logger.trace({ type: "method", method: "getSubscription", id: e2 });
    const t = this.subscriptions.get(e2);
    if (!t) {
      const { message: s2 } = S$5("NO_MATCHING_KEY", `${this.name}: ${e2}`);
      throw new Error(s2);
    }
    return t;
  }
  deleteSubscription(e2, t) {
    this.logger.debug("Deleting subscription"), this.logger.trace({ type: "method", method: "deleteSubscription", id: e2, reason: t });
    const s2 = this.getSubscription(e2);
    this.subscriptions.delete(e2), this.topicMap.delete(s2.topic, e2), this.events.emit(O$2.deleted, we$2(W$1({}, s2), { reason: t }));
  }
  async persist() {
    await this.setRelayerSubscriptions(this.values), this.events.emit(O$2.sync);
  }
  async reset() {
    if (this.cached.length) {
      const e2 = Math.ceil(this.cached.length / this.batchSubscribeTopicsLimit);
      for (let t = 0; t < e2; t++) {
        const s2 = this.cached.splice(0, this.batchSubscribeTopicsLimit);
        await this.batchFetchMessages(s2), await this.batchSubscribe(s2);
      }
    }
    this.events.emit(O$2.resubscribed);
  }
  async restore() {
    try {
      const e2 = await this.getRelayerSubscriptions();
      if (typeof e2 > "u" || !e2.length) return;
      if (this.subscriptions.size) {
        const { message: t } = S$5("RESTORE_WILL_OVERRIDE", this.name);
        throw this.logger.error(t), this.logger.error(`${this.name}: ${JSON.stringify(this.values)}`), new Error(t);
      }
      this.cached = e2, this.logger.debug(`Successfully Restored subscriptions for ${this.name}`), this.logger.trace({ type: "method", method: "restore", subscriptions: this.values });
    } catch (e2) {
      this.logger.debug(`Failed to Restore subscriptions for ${this.name}`), this.logger.error(e2);
    }
  }
  async batchSubscribe(e2) {
    if (!e2.length) return;
    const t = await this.rpcBatchSubscribe(e2);
    L$2(t) && this.onBatchSubscribe(t.map((s2, i3) => we$2(W$1({}, e2[i3]), { id: s2 })));
  }
  async batchFetchMessages(e2) {
    if (!e2.length) return;
    this.logger.trace(`Fetching batch messages for ${e2.length} subscriptions`);
    const t = await this.rpcBatchFetchMessages(e2);
    t && t.messages && (this.pendingBatchMessages = this.pendingBatchMessages.concat(t.messages));
  }
  async onConnect() {
    await this.restart(), this.onEnable();
  }
  onDisconnect() {
    this.onDisable();
  }
  async checkPending() {
    if (!this.initialized || !this.relayer.connected) return;
    const e2 = [];
    this.pending.forEach((t) => {
      e2.push(t);
    }), await this.batchSubscribe(e2), this.pendingBatchMessages.length && (await this.relayer.handleBatchMessageEvents(this.pendingBatchMessages), this.pendingBatchMessages = []);
  }
  registerEventListeners() {
    this.relayer.core.heartbeat.on(r$1.pulse, async () => {
      await this.checkPending();
    }), this.events.on(O$2.created, async (e2) => {
      const t = O$2.created;
      this.logger.info(`Emitting ${t}`), this.logger.debug({ type: "event", event: t, data: e2 }), await this.persist();
    }), this.events.on(O$2.deleted, async (e2) => {
      const t = O$2.deleted;
      this.logger.info(`Emitting ${t}`), this.logger.debug({ type: "event", event: t, data: e2 }), await this.persist();
    });
  }
  isInitialized() {
    if (!this.initialized) {
      const { message: e2 } = S$5("NOT_INITIALIZED", this.name);
      throw new Error(e2);
    }
  }
  async restartToComplete() {
    !this.relayer.connected && !this.relayer.connecting && await this.relayer.transportOpen(), this.restartInProgress && await new Promise((e2) => {
      const t = setInterval(() => {
        this.restartInProgress || (clearInterval(t), e2());
      }, this.pollingInterval);
    });
  }
};
var on = Object.defineProperty, Zt$1 = Object.getOwnPropertySymbols, an = Object.prototype.hasOwnProperty, hn = Object.prototype.propertyIsEnumerable, Qt$1 = (o3, e2, t) => e2 in o3 ? on(o3, e2, { enumerable: true, configurable: true, writable: true, value: t }) : o3[e2] = t, ei = (o3, e2) => {
  for (var t in e2 || (e2 = {})) an.call(e2, t) && Qt$1(o3, t, e2[t]);
  if (Zt$1) for (var t of Zt$1(e2)) hn.call(e2, t) && Qt$1(o3, t, e2[t]);
  return o3;
};
class ti extends u {
  constructor(e2) {
    super(e2), this.protocol = "wc", this.version = 2, this.events = new eventsExports.EventEmitter(), this.name = ot$2, this.transportExplicitlyClosed = false, this.initialized = false, this.connectionAttemptInProgress = false, this.connectionStatusPollingInterval = 20, this.staleConnectionErrors = ["socket hang up", "stalled", "interrupted"], this.hasExperiencedNetworkDisruption = false, this.requestsInFlight = /* @__PURE__ */ new Map(), this.heartBeatTimeout = cjs$3.toMiliseconds(cjs$3.THIRTY_SECONDS + cjs$3.ONE_SECOND), this.request = async (t) => {
      var s2, i3;
      this.logger.debug("Publishing Request Payload");
      const r2 = t.id || getBigIntRpcId().toString();
      await this.toEstablishConnection();
      try {
        const n4 = this.provider.request(t);
        this.requestsInFlight.set(r2, { promise: n4, request: t }), this.logger.trace({ id: r2, method: t.method, topic: (s2 = t.params) == null ? void 0 : s2.topic }, "relayer.request - attempt to publish...");
        const a3 = await new Promise(async (h4, c2) => {
          const l2 = () => {
            c2(new Error(`relayer.request - publish interrupted, id: ${r2}`));
          };
          this.provider.on(I$2.disconnect, l2);
          const p3 = await n4;
          this.provider.off(I$2.disconnect, l2), h4(p3);
        });
        return this.logger.trace({ id: r2, method: t.method, topic: (i3 = t.params) == null ? void 0 : i3.topic }, "relayer.request - published"), a3;
      } catch (n4) {
        throw this.logger.debug(`Failed to Publish Request: ${r2}`), n4;
      } finally {
        this.requestsInFlight.delete(r2);
      }
    }, this.resetPingTimeout = () => {
      if (ce$1()) try {
        clearTimeout(this.pingTimeout), this.pingTimeout = setTimeout(() => {
          var t, s2, i3;
          (i3 = (s2 = (t = this.provider) == null ? void 0 : t.connection) == null ? void 0 : s2.socket) == null || i3.terminate();
        }, this.heartBeatTimeout);
      } catch (t) {
        this.logger.warn(t);
      }
    }, this.onPayloadHandler = (t) => {
      this.onProviderPayload(t), this.resetPingTimeout();
    }, this.onConnectHandler = () => {
      this.logger.trace("relayer connected"), this.startPingTimeout(), this.events.emit(v$2.connect);
    }, this.onDisconnectHandler = () => {
      this.logger.trace("relayer disconnected"), this.onProviderDisconnect();
    }, this.onProviderErrorHandler = (t) => {
      this.logger.error(t), this.events.emit(v$2.error, t), this.logger.info("Fatal socket error received, closing transport"), this.transportClose();
    }, this.registerProviderListeners = () => {
      this.provider.on(I$2.payload, this.onPayloadHandler), this.provider.on(I$2.connect, this.onConnectHandler), this.provider.on(I$2.disconnect, this.onDisconnectHandler), this.provider.on(I$2.error, this.onProviderErrorHandler);
    }, this.core = e2.core, this.logger = typeof e2.logger < "u" && typeof e2.logger != "string" ? E$1(e2.logger, this.name) : qt$3(k$2({ level: e2.logger || nt$2 })), this.messages = new Yt$1(this.logger, e2.core), this.subscriber = new Wt$1(this, this.logger), this.publisher = new Zr(this, this.logger), this.relayUrl = (e2 == null ? void 0 : e2.relayUrl) || be$2, this.projectId = e2.projectId, this.bundleId = Ot$2(), this.provider = {};
  }
  async init() {
    if (this.logger.trace("Initialized"), this.registerEventListeners(), await Promise.all([this.messages.init(), this.subscriber.init()]), this.initialized = true, this.subscriber.cached.length > 0) try {
      await this.transportOpen();
    } catch (e2) {
      this.logger.warn(e2);
    }
  }
  get context() {
    return y$3(this.logger);
  }
  get connected() {
    var e2, t, s2;
    return ((s2 = (t = (e2 = this.provider) == null ? void 0 : e2.connection) == null ? void 0 : t.socket) == null ? void 0 : s2.readyState) === 1;
  }
  get connecting() {
    var e2, t, s2;
    return ((s2 = (t = (e2 = this.provider) == null ? void 0 : e2.connection) == null ? void 0 : t.socket) == null ? void 0 : s2.readyState) === 0;
  }
  async publish(e2, t, s2) {
    this.isInitialized(), await this.publisher.publish(e2, t, s2), await this.recordMessageEvent({ topic: e2, message: t, publishedAt: Date.now(), transportType: M$2.relay });
  }
  async subscribe(e2, t) {
    var s2, i3, r2;
    this.isInitialized(), (t == null ? void 0 : t.transportType) === "relay" && await this.toEstablishConnection();
    const n4 = typeof ((s2 = t == null ? void 0 : t.internal) == null ? void 0 : s2.throwOnFailedPublish) > "u" ? true : (i3 = t == null ? void 0 : t.internal) == null ? void 0 : i3.throwOnFailedPublish;
    let a3 = ((r2 = this.subscriber.topicMap.get(e2)) == null ? void 0 : r2[0]) || "", h4;
    const c2 = (l2) => {
      l2.topic === e2 && (this.subscriber.off(O$2.created, c2), h4());
    };
    return await Promise.all([new Promise((l2) => {
      h4 = l2, this.subscriber.on(O$2.created, c2);
    }), new Promise(async (l2, p3) => {
      a3 = await this.subscriber.subscribe(e2, ei({ internal: { throwOnFailedPublish: n4 } }, t)).catch((D2) => {
        n4 && p3(D2);
      }) || a3, l2();
    })]), a3;
  }
  async unsubscribe(e2, t) {
    this.isInitialized(), await this.subscriber.unsubscribe(e2, t);
  }
  on(e2, t) {
    this.events.on(e2, t);
  }
  once(e2, t) {
    this.events.once(e2, t);
  }
  off(e2, t) {
    this.events.off(e2, t);
  }
  removeListener(e2, t) {
    this.events.removeListener(e2, t);
  }
  async transportDisconnect() {
    if (!this.hasExperiencedNetworkDisruption && this.connected && this.requestsInFlight.size > 0) try {
      await Promise.all(Array.from(this.requestsInFlight.values()).map((e2) => e2.promise));
    } catch (e2) {
      this.logger.warn(e2);
    }
    this.hasExperiencedNetworkDisruption || this.connected ? await kt$2(this.provider.disconnect(), 2e3, "provider.disconnect()").catch(() => this.onProviderDisconnect()) : this.onProviderDisconnect();
  }
  async transportClose() {
    this.transportExplicitlyClosed = true, await this.transportDisconnect();
  }
  async transportOpen(e2) {
    await this.confirmOnlineStateOrThrow(), e2 && e2 !== this.relayUrl && (this.relayUrl = e2, await this.transportDisconnect()), await this.createProvider(), this.connectionAttemptInProgress = true, this.transportExplicitlyClosed = false;
    try {
      await new Promise(async (t, s2) => {
        const i3 = () => {
          this.provider.off(I$2.disconnect, i3), s2(new Error("Connection interrupted while trying to subscribe"));
        };
        this.provider.on(I$2.disconnect, i3), await kt$2(this.provider.connect(), cjs$3.toMiliseconds(cjs$3.ONE_MINUTE), `Socket stalled when trying to connect to ${this.relayUrl}`).catch((r2) => {
          s2(r2);
        }).finally(() => {
          clearTimeout(this.reconnectTimeout), this.reconnectTimeout = void 0;
        }), this.subscriber.start().catch((r2) => {
          this.logger.error(r2), this.onDisconnectHandler();
        }), this.hasExperiencedNetworkDisruption = false, t();
      });
    } catch (t) {
      this.logger.error(t);
      const s2 = t;
      if (this.hasExperiencedNetworkDisruption = true, !this.isConnectionStalled(s2.message)) throw t;
    } finally {
      this.connectionAttemptInProgress = false;
    }
  }
  async restartTransport(e2) {
    this.connectionAttemptInProgress || (this.relayUrl = e2 || this.relayUrl, await this.confirmOnlineStateOrThrow(), await this.transportClose(), await this.transportOpen());
  }
  async confirmOnlineStateOrThrow() {
    if (!await mo()) throw new Error("No internet connection detected. Please restart your network and try again.");
  }
  async handleBatchMessageEvents(e2) {
    if ((e2 == null ? void 0 : e2.length) === 0) {
      this.logger.trace("Batch message events is empty. Ignoring...");
      return;
    }
    const t = e2.sort((s2, i3) => s2.publishedAt - i3.publishedAt);
    this.logger.trace(`Batch of ${t.length} message events sorted`);
    for (const s2 of t) try {
      await this.onMessageEvent(s2);
    } catch (i3) {
      this.logger.warn(i3);
    }
    this.logger.trace(`Batch of ${t.length} message events processed`);
  }
  async onLinkMessageEvent(e2, t) {
    const { topic: s2 } = e2;
    if (!t.sessionExists) {
      const i3 = Mt$2(cjs$3.FIVE_MINUTES), r2 = { topic: s2, expiry: i3, relay: { protocol: "irn" }, active: false };
      await this.core.pairing.pairings.set(s2, r2);
    }
    this.events.emit(v$2.message, e2), await this.recordMessageEvent(e2);
  }
  startPingTimeout() {
    var e2, t, s2, i3, r2;
    if (ce$1()) try {
      (t = (e2 = this.provider) == null ? void 0 : e2.connection) != null && t.socket && ((r2 = (i3 = (s2 = this.provider) == null ? void 0 : s2.connection) == null ? void 0 : i3.socket) == null || r2.once("ping", () => {
        this.resetPingTimeout();
      })), this.resetPingTimeout();
    } catch (n4) {
      this.logger.warn(n4);
    }
  }
  isConnectionStalled(e2) {
    return this.staleConnectionErrors.some((t) => e2.includes(t));
  }
  async createProvider() {
    this.provider.connection && this.unregisterProviderListeners();
    const e2 = await this.core.crypto.signJWT(this.relayUrl);
    this.provider = new o$1(new f$2($t$2({ sdkVersion: se$2, protocol: this.protocol, version: this.version, relayUrl: this.relayUrl, projectId: this.projectId, auth: e2, useOnCloseEvent: true, bundleId: this.bundleId }))), this.registerProviderListeners();
  }
  async recordMessageEvent(e2) {
    const { topic: t, message: s2 } = e2;
    await this.messages.set(t, s2);
  }
  async shouldIgnoreMessageEvent(e2) {
    const { topic: t, message: s2 } = e2;
    if (!s2 || s2.length === 0) return this.logger.debug(`Ignoring invalid/empty message: ${s2}`), true;
    if (!await this.subscriber.isSubscribed(t)) return this.logger.debug(`Ignoring message for non-subscribed topic ${t}`), true;
    const i3 = this.messages.has(t, s2);
    return i3 && this.logger.debug(`Ignoring duplicate message: ${s2}`), i3;
  }
  async onProviderPayload(e2) {
    if (this.logger.debug("Incoming Relay Payload"), this.logger.trace({ type: "payload", direction: "incoming", payload: e2 }), isJsonRpcRequest(e2)) {
      if (!e2.method.endsWith(at$2)) return;
      const t = e2.params, { topic: s2, message: i3, publishedAt: r2, attestation: n4 } = t.data, a3 = { topic: s2, message: i3, publishedAt: r2, transportType: M$2.relay, attestation: n4 };
      this.logger.debug("Emitting Relayer Payload"), this.logger.trace(ei({ type: "event", event: t.id }, a3)), this.events.emit(t.id, a3), await this.acknowledgePayload(e2), await this.onMessageEvent(a3);
    } else isJsonRpcResponse(e2) && this.events.emit(v$2.message_ack, e2);
  }
  async onMessageEvent(e2) {
    await this.shouldIgnoreMessageEvent(e2) || (this.events.emit(v$2.message, e2), await this.recordMessageEvent(e2));
  }
  async acknowledgePayload(e2) {
    const t = formatJsonRpcResult(e2.id, true);
    await this.provider.connection.send(t);
  }
  unregisterProviderListeners() {
    this.provider.off(I$2.payload, this.onPayloadHandler), this.provider.off(I$2.connect, this.onConnectHandler), this.provider.off(I$2.disconnect, this.onDisconnectHandler), this.provider.off(I$2.error, this.onProviderErrorHandler), clearTimeout(this.pingTimeout);
  }
  async registerEventListeners() {
    let e2 = await mo();
    ho(async (t) => {
      e2 !== t && (e2 = t, t ? await this.restartTransport().catch((s2) => this.logger.error(s2)) : (this.hasExperiencedNetworkDisruption = true, await this.transportDisconnect(), this.transportExplicitlyClosed = false));
    });
  }
  async onProviderDisconnect() {
    await this.subscriber.stop(), this.requestsInFlight.clear(), clearTimeout(this.pingTimeout), this.events.emit(v$2.disconnect), this.connectionAttemptInProgress = false, !this.transportExplicitlyClosed && (this.reconnectTimeout || (this.reconnectTimeout = setTimeout(async () => {
      await this.transportOpen().catch((e2) => this.logger.error(e2));
    }, cjs$3.toMiliseconds(ht$2))));
  }
  isInitialized() {
    if (!this.initialized) {
      const { message: e2 } = S$5("NOT_INITIALIZED", this.name);
      throw new Error(e2);
    }
  }
  async toEstablishConnection() {
    await this.confirmOnlineStateOrThrow(), !this.connected && (this.connectionAttemptInProgress && await new Promise((e2) => {
      const t = setInterval(() => {
        this.connected && (clearInterval(t), e2());
      }, this.connectionStatusPollingInterval);
    }), await this.transportOpen());
  }
}
var cn = Object.defineProperty, ii = Object.getOwnPropertySymbols, ln = Object.prototype.hasOwnProperty, un = Object.prototype.propertyIsEnumerable, si = (o3, e2, t) => e2 in o3 ? cn(o3, e2, { enumerable: true, configurable: true, writable: true, value: t }) : o3[e2] = t, ri = (o3, e2) => {
  for (var t in e2 || (e2 = {})) ln.call(e2, t) && si(o3, t, e2[t]);
  if (ii) for (var t of ii(e2)) un.call(e2, t) && si(o3, t, e2[t]);
  return o3;
};
class ni extends p$1 {
  constructor(e2, t, s2, i3 = x$3, r2 = void 0) {
    super(e2, t, s2, i3), this.core = e2, this.logger = t, this.name = s2, this.map = /* @__PURE__ */ new Map(), this.version = ct$2, this.cached = [], this.initialized = false, this.storagePrefix = x$3, this.recentlyDeleted = [], this.recentlyDeletedLimit = 200, this.init = async () => {
      this.initialized || (this.logger.trace("Initialized"), await this.restore(), this.cached.forEach((n4) => {
        this.getKey && n4 !== null && !I$3(n4) ? this.map.set(this.getKey(n4), n4) : Yr$1(n4) ? this.map.set(n4.id, n4) : Qr$1(n4) && this.map.set(n4.topic, n4);
      }), this.cached = [], this.initialized = true);
    }, this.set = async (n4, a3) => {
      this.isInitialized(), this.map.has(n4) ? await this.update(n4, a3) : (this.logger.debug("Setting value"), this.logger.trace({ type: "method", method: "set", key: n4, value: a3 }), this.map.set(n4, a3), await this.persist());
    }, this.get = (n4) => (this.isInitialized(), this.logger.debug("Getting value"), this.logger.trace({ type: "method", method: "get", key: n4 }), this.getData(n4)), this.getAll = (n4) => (this.isInitialized(), n4 ? this.values.filter((a3) => Object.keys(n4).every((h4) => ys$1(a3[h4], n4[h4]))) : this.values), this.update = async (n4, a3) => {
      this.isInitialized(), this.logger.debug("Updating value"), this.logger.trace({ type: "method", method: "update", key: n4, update: a3 });
      const h4 = ri(ri({}, this.getData(n4)), a3);
      this.map.set(n4, h4), await this.persist();
    }, this.delete = async (n4, a3) => {
      this.isInitialized(), this.map.has(n4) && (this.logger.debug("Deleting value"), this.logger.trace({ type: "method", method: "delete", key: n4, reason: a3 }), this.map.delete(n4), this.addToRecentlyDeleted(n4), await this.persist());
    }, this.logger = E$1(t, this.name), this.storagePrefix = i3, this.getKey = r2;
  }
  get context() {
    return y$3(this.logger);
  }
  get storageKey() {
    return this.storagePrefix + this.version + this.core.customStoragePrefix + "//" + this.name;
  }
  get length() {
    return this.map.size;
  }
  get keys() {
    return Array.from(this.map.keys());
  }
  get values() {
    return Array.from(this.map.values());
  }
  addToRecentlyDeleted(e2) {
    this.recentlyDeleted.push(e2), this.recentlyDeleted.length >= this.recentlyDeletedLimit && this.recentlyDeleted.splice(0, this.recentlyDeletedLimit / 2);
  }
  async setDataStore(e2) {
    await this.core.storage.setItem(this.storageKey, e2);
  }
  async getDataStore() {
    return await this.core.storage.getItem(this.storageKey);
  }
  getData(e2) {
    const t = this.map.get(e2);
    if (!t) {
      if (this.recentlyDeleted.includes(e2)) {
        const { message: i3 } = S$5("MISSING_OR_INVALID", `Record was recently deleted - ${this.name}: ${e2}`);
        throw this.logger.error(i3), new Error(i3);
      }
      const { message: s2 } = S$5("NO_MATCHING_KEY", `${this.name}: ${e2}`);
      throw this.logger.error(s2), new Error(s2);
    }
    return t;
  }
  async persist() {
    await this.setDataStore(this.values);
  }
  async restore() {
    try {
      const e2 = await this.getDataStore();
      if (typeof e2 > "u" || !e2.length) return;
      if (this.map.size) {
        const { message: t } = S$5("RESTORE_WILL_OVERRIDE", this.name);
        throw this.logger.error(t), new Error(t);
      }
      this.cached = e2, this.logger.debug(`Successfully Restored value for ${this.name}`), this.logger.trace({ type: "method", method: "restore", value: this.values });
    } catch (e2) {
      this.logger.debug(`Failed to Restore value for ${this.name}`), this.logger.error(e2);
    }
  }
  isInitialized() {
    if (!this.initialized) {
      const { message: e2 } = S$5("NOT_INITIALIZED", this.name);
      throw new Error(e2);
    }
  }
}
class oi {
  constructor(e2, t) {
    this.core = e2, this.logger = t, this.name = gt$2, this.version = yt$2, this.events = new es(), this.initialized = false, this.storagePrefix = x$3, this.ignoredPayloadTypes = [D$2], this.registeredMethods = [], this.init = async () => {
      this.initialized || (await this.pairings.init(), await this.cleanup(), this.registerRelayerEvents(), this.registerExpirerEvents(), this.initialized = true, this.logger.trace("Initialized"));
    }, this.register = ({ methods: s2 }) => {
      this.isInitialized(), this.registeredMethods = [.../* @__PURE__ */ new Set([...this.registeredMethods, ...s2])];
    }, this.create = async (s2) => {
      this.isInitialized();
      const i3 = pr$2(), r2 = await this.core.crypto.setSymKey(i3), n4 = Mt$2(cjs$3.FIVE_MINUTES), a3 = { protocol: rt$2 }, h4 = { topic: r2, expiry: n4, relay: a3, active: false, methods: s2 == null ? void 0 : s2.methods }, c2 = Dr$2({ protocol: this.core.protocol, version: this.core.version, topic: r2, symKey: i3, relay: a3, expiryTimestamp: n4, methods: s2 == null ? void 0 : s2.methods });
      return this.events.emit(V$2.create, h4), this.core.expirer.set(r2, n4), await this.pairings.set(r2, h4), await this.core.relayer.subscribe(r2, { transportType: s2 == null ? void 0 : s2.transportType }), { topic: r2, uri: c2 };
    }, this.pair = async (s2) => {
      this.isInitialized();
      const i3 = this.core.eventClient.createEvent({ properties: { topic: s2 == null ? void 0 : s2.uri, trace: [z$3.pairing_started] } });
      this.isValidPair(s2, i3);
      const { topic: r2, symKey: n4, relay: a3, expiryTimestamp: h4, methods: c2 } = kr$1(s2.uri);
      i3.props.properties.topic = r2, i3.addTrace(z$3.pairing_uri_validation_success), i3.addTrace(z$3.pairing_uri_not_expired);
      let l2;
      if (this.pairings.keys.includes(r2)) {
        if (l2 = this.pairings.get(r2), i3.addTrace(z$3.existing_pairing), l2.active) throw i3.setError($$1.active_pairing_already_exists), new Error(`Pairing already exists: ${r2}. Please try again with a new connection URI.`);
        i3.addTrace(z$3.pairing_not_expired);
      }
      const p3 = h4 || Mt$2(cjs$3.FIVE_MINUTES), D2 = { topic: r2, relay: a3, expiry: p3, active: false, methods: c2 };
      this.core.expirer.set(r2, p3), await this.pairings.set(r2, D2), i3.addTrace(z$3.store_new_pairing), s2.activatePairing && await this.activate({ topic: r2 }), this.events.emit(V$2.create, D2), i3.addTrace(z$3.emit_inactive_pairing), this.core.crypto.keychain.has(r2) || await this.core.crypto.setSymKey(n4, r2), i3.addTrace(z$3.subscribing_pairing_topic);
      try {
        await this.core.relayer.confirmOnlineStateOrThrow();
      } catch {
        i3.setError($$1.no_internet_connection);
      }
      try {
        await this.core.relayer.subscribe(r2, { relay: a3 });
      } catch (m2) {
        throw i3.setError($$1.subscribe_pairing_topic_failure), m2;
      }
      return i3.addTrace(z$3.subscribe_pairing_topic_success), D2;
    }, this.activate = async ({ topic: s2 }) => {
      this.isInitialized();
      const i3 = Mt$2(cjs$3.THIRTY_DAYS);
      this.core.expirer.set(s2, i3), await this.pairings.update(s2, { active: true, expiry: i3 });
    }, this.ping = async (s2) => {
      this.isInitialized(), await this.isValidPing(s2);
      const { topic: i3 } = s2;
      if (this.pairings.keys.includes(i3)) {
        const r2 = await this.sendRequest(i3, "wc_pairingPing", {}), { done: n4, resolve: a3, reject: h4 } = _t$2();
        this.events.once(Lt$2("pairing_ping", r2), ({ error: c2 }) => {
          c2 ? h4(c2) : a3();
        }), await n4();
      }
    }, this.updateExpiry = async ({ topic: s2, expiry: i3 }) => {
      this.isInitialized(), await this.pairings.update(s2, { expiry: i3 });
    }, this.updateMetadata = async ({ topic: s2, metadata: i3 }) => {
      this.isInitialized(), await this.pairings.update(s2, { peerMetadata: i3 });
    }, this.getPairings = () => (this.isInitialized(), this.pairings.values), this.disconnect = async (s2) => {
      this.isInitialized(), await this.isValidDisconnect(s2);
      const { topic: i3 } = s2;
      this.pairings.keys.includes(i3) && (await this.sendRequest(i3, "wc_pairingDelete", U$2("USER_DISCONNECTED")), await this.deletePairing(i3));
    }, this.formatUriFromPairing = (s2) => {
      this.isInitialized();
      const { topic: i3, relay: r2, expiry: n4, methods: a3 } = s2, h4 = this.core.crypto.keychain.get(i3);
      return Dr$2({ protocol: this.core.protocol, version: this.core.version, topic: i3, symKey: h4, relay: r2, expiryTimestamp: n4, methods: a3 });
    }, this.sendRequest = async (s2, i3, r2) => {
      const n4 = formatJsonRpcRequest(i3, r2), a3 = await this.core.crypto.encode(s2, n4), h4 = B$2[i3].req;
      return this.core.history.set(s2, n4), this.core.relayer.publish(s2, a3, h4), n4.id;
    }, this.sendResult = async (s2, i3, r2) => {
      const n4 = formatJsonRpcResult(s2, r2), a3 = await this.core.crypto.encode(i3, n4), h4 = await this.core.history.get(i3, s2), c2 = B$2[h4.request.method].res;
      await this.core.relayer.publish(i3, a3, c2), await this.core.history.resolve(n4);
    }, this.sendError = async (s2, i3, r2) => {
      const n4 = formatJsonRpcError(s2, r2), a3 = await this.core.crypto.encode(i3, n4), h4 = await this.core.history.get(i3, s2), c2 = B$2[h4.request.method] ? B$2[h4.request.method].res : B$2.unregistered_method.res;
      await this.core.relayer.publish(i3, a3, c2), await this.core.history.resolve(n4);
    }, this.deletePairing = async (s2, i3) => {
      await this.core.relayer.unsubscribe(s2), await Promise.all([this.pairings.delete(s2, U$2("USER_DISCONNECTED")), this.core.crypto.deleteSymKey(s2), i3 ? Promise.resolve() : this.core.expirer.del(s2)]);
    }, this.cleanup = async () => {
      const s2 = this.pairings.getAll().filter((i3) => Kt$2(i3.expiry));
      await Promise.all(s2.map((i3) => this.deletePairing(i3.topic)));
    }, this.onRelayEventRequest = (s2) => {
      const { topic: i3, payload: r2 } = s2;
      switch (r2.method) {
        case "wc_pairingPing":
          return this.onPairingPingRequest(i3, r2);
        case "wc_pairingDelete":
          return this.onPairingDeleteRequest(i3, r2);
        default:
          return this.onUnknownRpcMethodRequest(i3, r2);
      }
    }, this.onRelayEventResponse = async (s2) => {
      const { topic: i3, payload: r2 } = s2, n4 = (await this.core.history.get(i3, r2.id)).request.method;
      switch (n4) {
        case "wc_pairingPing":
          return this.onPairingPingResponse(i3, r2);
        default:
          return this.onUnknownRpcMethodResponse(n4);
      }
    }, this.onPairingPingRequest = async (s2, i3) => {
      const { id: r2 } = i3;
      try {
        this.isValidPing({ topic: s2 }), await this.sendResult(r2, s2, true), this.events.emit(V$2.ping, { id: r2, topic: s2 });
      } catch (n4) {
        await this.sendError(r2, s2, n4), this.logger.error(n4);
      }
    }, this.onPairingPingResponse = (s2, i3) => {
      const { id: r2 } = i3;
      setTimeout(() => {
        isJsonRpcResult(i3) ? this.events.emit(Lt$2("pairing_ping", r2), {}) : isJsonRpcError(i3) && this.events.emit(Lt$2("pairing_ping", r2), { error: i3.error });
      }, 500);
    }, this.onPairingDeleteRequest = async (s2, i3) => {
      const { id: r2 } = i3;
      try {
        this.isValidDisconnect({ topic: s2 }), await this.deletePairing(s2), this.events.emit(V$2.delete, { id: r2, topic: s2 });
      } catch (n4) {
        await this.sendError(r2, s2, n4), this.logger.error(n4);
      }
    }, this.onUnknownRpcMethodRequest = async (s2, i3) => {
      const { id: r2, method: n4 } = i3;
      try {
        if (this.registeredMethods.includes(n4)) return;
        const a3 = U$2("WC_METHOD_UNSUPPORTED", n4);
        await this.sendError(r2, s2, a3), this.logger.error(a3);
      } catch (a3) {
        await this.sendError(r2, s2, a3), this.logger.error(a3);
      }
    }, this.onUnknownRpcMethodResponse = (s2) => {
      this.registeredMethods.includes(s2) || this.logger.error(U$2("WC_METHOD_UNSUPPORTED", s2));
    }, this.isValidPair = (s2, i3) => {
      var r2;
      if (!to(s2)) {
        const { message: a3 } = S$5("MISSING_OR_INVALID", `pair() params: ${s2}`);
        throw i3.setError($$1.malformed_pairing_uri), new Error(a3);
      }
      if (!Gr$1(s2.uri)) {
        const { message: a3 } = S$5("MISSING_OR_INVALID", `pair() uri: ${s2.uri}`);
        throw i3.setError($$1.malformed_pairing_uri), new Error(a3);
      }
      const n4 = kr$1(s2 == null ? void 0 : s2.uri);
      if (!((r2 = n4 == null ? void 0 : n4.relay) != null && r2.protocol)) {
        const { message: a3 } = S$5("MISSING_OR_INVALID", "pair() uri#relay-protocol");
        throw i3.setError($$1.malformed_pairing_uri), new Error(a3);
      }
      if (!(n4 != null && n4.symKey)) {
        const { message: a3 } = S$5("MISSING_OR_INVALID", "pair() uri#symKey");
        throw i3.setError($$1.malformed_pairing_uri), new Error(a3);
      }
      if (n4 != null && n4.expiryTimestamp && cjs$3.toMiliseconds(n4 == null ? void 0 : n4.expiryTimestamp) < Date.now()) {
        i3.setError($$1.pairing_expired);
        const { message: a3 } = S$5("EXPIRED", "pair() URI has expired. Please try again with a new connection URI.");
        throw new Error(a3);
      }
    }, this.isValidPing = async (s2) => {
      if (!to(s2)) {
        const { message: r2 } = S$5("MISSING_OR_INVALID", `ping() params: ${s2}`);
        throw new Error(r2);
      }
      const { topic: i3 } = s2;
      await this.isValidPairingTopic(i3);
    }, this.isValidDisconnect = async (s2) => {
      if (!to(s2)) {
        const { message: r2 } = S$5("MISSING_OR_INVALID", `disconnect() params: ${s2}`);
        throw new Error(r2);
      }
      const { topic: i3 } = s2;
      await this.isValidPairingTopic(i3);
    }, this.isValidPairingTopic = async (s2) => {
      if (!b$2(s2, false)) {
        const { message: i3 } = S$5("MISSING_OR_INVALID", `pairing topic should be a string: ${s2}`);
        throw new Error(i3);
      }
      if (!this.pairings.keys.includes(s2)) {
        const { message: i3 } = S$5("NO_MATCHING_KEY", `pairing topic doesn't exist: ${s2}`);
        throw new Error(i3);
      }
      if (Kt$2(this.pairings.get(s2).expiry)) {
        await this.deletePairing(s2);
        const { message: i3 } = S$5("EXPIRED", `pairing topic: ${s2}`);
        throw new Error(i3);
      }
    }, this.core = e2, this.logger = E$1(t, this.name), this.pairings = new ni(this.core, this.logger, this.name, this.storagePrefix);
  }
  get context() {
    return y$3(this.logger);
  }
  isInitialized() {
    if (!this.initialized) {
      const { message: e2 } = S$5("NOT_INITIALIZED", this.name);
      throw new Error(e2);
    }
  }
  registerRelayerEvents() {
    this.core.relayer.on(v$2.message, async (e2) => {
      const { topic: t, message: s2, transportType: i3 } = e2;
      if (!this.pairings.keys.includes(t) || i3 === M$2.link_mode || this.ignoredPayloadTypes.includes(this.core.crypto.getPayloadType(s2))) return;
      const r2 = await this.core.crypto.decode(t, s2);
      try {
        isJsonRpcRequest(r2) ? (this.core.history.set(t, r2), this.onRelayEventRequest({ topic: t, payload: r2 })) : isJsonRpcResponse(r2) && (await this.core.history.resolve(r2), await this.onRelayEventResponse({ topic: t, payload: r2 }), this.core.history.delete(t, r2.id));
      } catch (n4) {
        this.logger.error(n4);
      }
    });
  }
  registerExpirerEvents() {
    this.core.expirer.on(S$3.expired, async (e2) => {
      const { topic: t } = Vt$2(e2.target);
      t && this.pairings.keys.includes(t) && (await this.deletePairing(t, true), this.events.emit(V$2.expire, { topic: t }));
    });
  }
}
class ai extends h$1 {
  constructor(e2, t) {
    super(e2, t), this.core = e2, this.logger = t, this.records = /* @__PURE__ */ new Map(), this.events = new eventsExports.EventEmitter(), this.name = Dt$1, this.version = mt$1, this.cached = [], this.initialized = false, this.storagePrefix = x$3, this.init = async () => {
      this.initialized || (this.logger.trace("Initialized"), await this.restore(), this.cached.forEach((s2) => this.records.set(s2.id, s2)), this.cached = [], this.registerEventListeners(), this.initialized = true);
    }, this.set = (s2, i3, r2) => {
      if (this.isInitialized(), this.logger.debug("Setting JSON-RPC request history record"), this.logger.trace({ type: "method", method: "set", topic: s2, request: i3, chainId: r2 }), this.records.has(i3.id)) return;
      const n4 = { id: i3.id, topic: s2, request: { method: i3.method, params: i3.params || null }, chainId: r2, expiry: Mt$2(cjs$3.THIRTY_DAYS) };
      this.records.set(n4.id, n4), this.persist(), this.events.emit(P$1.created, n4);
    }, this.resolve = async (s2) => {
      if (this.isInitialized(), this.logger.debug("Updating JSON-RPC response history record"), this.logger.trace({ type: "method", method: "update", response: s2 }), !this.records.has(s2.id)) return;
      const i3 = await this.getRecord(s2.id);
      typeof i3.response > "u" && (i3.response = isJsonRpcError(s2) ? { error: s2.error } : { result: s2.result }, this.records.set(i3.id, i3), this.persist(), this.events.emit(P$1.updated, i3));
    }, this.get = async (s2, i3) => (this.isInitialized(), this.logger.debug("Getting record"), this.logger.trace({ type: "method", method: "get", topic: s2, id: i3 }), await this.getRecord(i3)), this.delete = (s2, i3) => {
      this.isInitialized(), this.logger.debug("Deleting record"), this.logger.trace({ type: "method", method: "delete", id: i3 }), this.values.forEach((r2) => {
        if (r2.topic === s2) {
          if (typeof i3 < "u" && r2.id !== i3) return;
          this.records.delete(r2.id), this.events.emit(P$1.deleted, r2);
        }
      }), this.persist();
    }, this.exists = async (s2, i3) => (this.isInitialized(), this.records.has(i3) ? (await this.getRecord(i3)).topic === s2 : false), this.on = (s2, i3) => {
      this.events.on(s2, i3);
    }, this.once = (s2, i3) => {
      this.events.once(s2, i3);
    }, this.off = (s2, i3) => {
      this.events.off(s2, i3);
    }, this.removeListener = (s2, i3) => {
      this.events.removeListener(s2, i3);
    }, this.logger = E$1(t, this.name);
  }
  get context() {
    return y$3(this.logger);
  }
  get storageKey() {
    return this.storagePrefix + this.version + this.core.customStoragePrefix + "//" + this.name;
  }
  get size() {
    return this.records.size;
  }
  get keys() {
    return Array.from(this.records.keys());
  }
  get values() {
    return Array.from(this.records.values());
  }
  get pending() {
    const e2 = [];
    return this.values.forEach((t) => {
      if (typeof t.response < "u") return;
      const s2 = { topic: t.topic, request: formatJsonRpcRequest(t.request.method, t.request.params, t.id), chainId: t.chainId };
      return e2.push(s2);
    }), e2;
  }
  async setJsonRpcRecords(e2) {
    await this.core.storage.setItem(this.storageKey, e2);
  }
  async getJsonRpcRecords() {
    return await this.core.storage.getItem(this.storageKey);
  }
  getRecord(e2) {
    this.isInitialized();
    const t = this.records.get(e2);
    if (!t) {
      const { message: s2 } = S$5("NO_MATCHING_KEY", `${this.name}: ${e2}`);
      throw new Error(s2);
    }
    return t;
  }
  async persist() {
    await this.setJsonRpcRecords(this.values), this.events.emit(P$1.sync);
  }
  async restore() {
    try {
      const e2 = await this.getJsonRpcRecords();
      if (typeof e2 > "u" || !e2.length) return;
      if (this.records.size) {
        const { message: t } = S$5("RESTORE_WILL_OVERRIDE", this.name);
        throw this.logger.error(t), new Error(t);
      }
      this.cached = e2, this.logger.debug(`Successfully Restored records for ${this.name}`), this.logger.trace({ type: "method", method: "restore", records: this.values });
    } catch (e2) {
      this.logger.debug(`Failed to Restore records for ${this.name}`), this.logger.error(e2);
    }
  }
  registerEventListeners() {
    this.events.on(P$1.created, (e2) => {
      const t = P$1.created;
      this.logger.info(`Emitting ${t}`), this.logger.debug({ type: "event", event: t, record: e2 });
    }), this.events.on(P$1.updated, (e2) => {
      const t = P$1.updated;
      this.logger.info(`Emitting ${t}`), this.logger.debug({ type: "event", event: t, record: e2 });
    }), this.events.on(P$1.deleted, (e2) => {
      const t = P$1.deleted;
      this.logger.info(`Emitting ${t}`), this.logger.debug({ type: "event", event: t, record: e2 });
    }), this.core.heartbeat.on(r$1.pulse, () => {
      this.cleanup();
    });
  }
  cleanup() {
    try {
      this.isInitialized();
      let e2 = false;
      this.records.forEach((t) => {
        cjs$3.toMiliseconds(t.expiry || 0) - Date.now() <= 0 && (this.logger.info(`Deleting expired history log: ${t.id}`), this.records.delete(t.id), this.events.emit(P$1.deleted, t, false), e2 = true);
      }), e2 && this.persist();
    } catch (e2) {
      this.logger.warn(e2);
    }
  }
  isInitialized() {
    if (!this.initialized) {
      const { message: e2 } = S$5("NOT_INITIALIZED", this.name);
      throw new Error(e2);
    }
  }
}
class hi extends x$4 {
  constructor(e2, t) {
    super(e2, t), this.core = e2, this.logger = t, this.expirations = /* @__PURE__ */ new Map(), this.events = new eventsExports.EventEmitter(), this.name = bt$1, this.version = ft$1, this.cached = [], this.initialized = false, this.storagePrefix = x$3, this.init = async () => {
      this.initialized || (this.logger.trace("Initialized"), await this.restore(), this.cached.forEach((s2) => this.expirations.set(s2.target, s2)), this.cached = [], this.registerEventListeners(), this.initialized = true);
    }, this.has = (s2) => {
      try {
        const i3 = this.formatTarget(s2);
        return typeof this.getExpiration(i3) < "u";
      } catch {
        return false;
      }
    }, this.set = (s2, i3) => {
      this.isInitialized();
      const r2 = this.formatTarget(s2), n4 = { target: r2, expiry: i3 };
      this.expirations.set(r2, n4), this.checkExpiry(r2, n4), this.events.emit(S$3.created, { target: r2, expiration: n4 });
    }, this.get = (s2) => {
      this.isInitialized();
      const i3 = this.formatTarget(s2);
      return this.getExpiration(i3);
    }, this.del = (s2) => {
      if (this.isInitialized(), this.has(s2)) {
        const i3 = this.formatTarget(s2), r2 = this.getExpiration(i3);
        this.expirations.delete(i3), this.events.emit(S$3.deleted, { target: i3, expiration: r2 });
      }
    }, this.on = (s2, i3) => {
      this.events.on(s2, i3);
    }, this.once = (s2, i3) => {
      this.events.once(s2, i3);
    }, this.off = (s2, i3) => {
      this.events.off(s2, i3);
    }, this.removeListener = (s2, i3) => {
      this.events.removeListener(s2, i3);
    }, this.logger = E$1(t, this.name);
  }
  get context() {
    return y$3(this.logger);
  }
  get storageKey() {
    return this.storagePrefix + this.version + this.core.customStoragePrefix + "//" + this.name;
  }
  get length() {
    return this.expirations.size;
  }
  get keys() {
    return Array.from(this.expirations.keys());
  }
  get values() {
    return Array.from(this.expirations.values());
  }
  formatTarget(e2) {
    if (typeof e2 == "string") return Dt$2(e2);
    if (typeof e2 == "number") return xt$2(e2);
    const { message: t } = S$5("UNKNOWN_TYPE", `Target type: ${typeof e2}`);
    throw new Error(t);
  }
  async setExpirations(e2) {
    await this.core.storage.setItem(this.storageKey, e2);
  }
  async getExpirations() {
    return await this.core.storage.getItem(this.storageKey);
  }
  async persist() {
    await this.setExpirations(this.values), this.events.emit(S$3.sync);
  }
  async restore() {
    try {
      const e2 = await this.getExpirations();
      if (typeof e2 > "u" || !e2.length) return;
      if (this.expirations.size) {
        const { message: t } = S$5("RESTORE_WILL_OVERRIDE", this.name);
        throw this.logger.error(t), new Error(t);
      }
      this.cached = e2, this.logger.debug(`Successfully Restored expirations for ${this.name}`), this.logger.trace({ type: "method", method: "restore", expirations: this.values });
    } catch (e2) {
      this.logger.debug(`Failed to Restore expirations for ${this.name}`), this.logger.error(e2);
    }
  }
  getExpiration(e2) {
    const t = this.expirations.get(e2);
    if (!t) {
      const { message: s2 } = S$5("NO_MATCHING_KEY", `${this.name}: ${e2}`);
      throw this.logger.warn(s2), new Error(s2);
    }
    return t;
  }
  checkExpiry(e2, t) {
    const { expiry: s2 } = t;
    cjs$3.toMiliseconds(s2) - Date.now() <= 0 && this.expire(e2, t);
  }
  expire(e2, t) {
    this.expirations.delete(e2), this.events.emit(S$3.expired, { target: e2, expiration: t });
  }
  checkExpirations() {
    this.core.relayer.connected && this.expirations.forEach((e2, t) => this.checkExpiry(t, e2));
  }
  registerEventListeners() {
    this.core.heartbeat.on(r$1.pulse, () => this.checkExpirations()), this.events.on(S$3.created, (e2) => {
      const t = S$3.created;
      this.logger.info(`Emitting ${t}`), this.logger.debug({ type: "event", event: t, data: e2 }), this.persist();
    }), this.events.on(S$3.expired, (e2) => {
      const t = S$3.expired;
      this.logger.info(`Emitting ${t}`), this.logger.debug({ type: "event", event: t, data: e2 }), this.persist();
    }), this.events.on(S$3.deleted, (e2) => {
      const t = S$3.deleted;
      this.logger.info(`Emitting ${t}`), this.logger.debug({ type: "event", event: t, data: e2 }), this.persist();
    });
  }
  isInitialized() {
    if (!this.initialized) {
      const { message: e2 } = S$5("NOT_INITIALIZED", this.name);
      throw new Error(e2);
    }
  }
}
class ci extends y$2 {
  constructor(e2, t, s2) {
    super(e2, t, s2), this.core = e2, this.logger = t, this.store = s2, this.name = _t$1, this.verifyUrlV3 = vt$1, this.storagePrefix = x$3, this.version = De$1, this.init = async () => {
      var i3;
      this.isDevEnv || (this.publicKey = await this.store.getItem(this.storeKey), this.publicKey && cjs$3.toMiliseconds((i3 = this.publicKey) == null ? void 0 : i3.expiresAt) < Date.now() && (this.logger.debug("verify v2 public key expired"), await this.removePublicKey()));
    }, this.register = async (i3) => {
      if (!V$3() || this.isDevEnv) return;
      const r2 = window.location.origin, { id: n4, decryptedId: a3 } = i3, h4 = `${this.verifyUrlV3}/attestation?projectId=${this.core.projectId}&origin=${r2}&id=${n4}&decryptedId=${a3}`;
      try {
        const c2 = getDocument_1(), l2 = this.startAbortTimer(cjs$3.ONE_SECOND * 5), p3 = await new Promise((D2, m2) => {
          const u2 = () => {
            window.removeEventListener("message", _3), c2.body.removeChild(g3), m2("attestation aborted");
          };
          this.abortController.signal.addEventListener("abort", u2);
          const g3 = c2.createElement("iframe");
          g3.src = h4, g3.style.display = "none", g3.addEventListener("error", u2, { signal: this.abortController.signal });
          const _3 = (y3) => {
            if (y3.data && typeof y3.data == "string") try {
              const b2 = JSON.parse(y3.data);
              if (b2.type === "verify_attestation") {
                if (decodeJWT(b2.attestation).payload.id !== n4) return;
                clearInterval(l2), c2.body.removeChild(g3), this.abortController.signal.removeEventListener("abort", u2), window.removeEventListener("message", _3), D2(b2.attestation === null ? "" : b2.attestation);
              }
            } catch (b2) {
              this.logger.warn(b2);
            }
          };
          c2.body.appendChild(g3), window.addEventListener("message", _3, { signal: this.abortController.signal });
        });
        return this.logger.debug("jwt attestation", p3), p3;
      } catch (c2) {
        this.logger.warn(c2);
      }
      return "";
    }, this.resolve = async (i3) => {
      if (this.isDevEnv) return "";
      const { attestationId: r2, hash: n4, encryptedId: a3 } = i3;
      if (r2 === "") {
        this.logger.debug("resolve: attestationId is empty, skipping");
        return;
      }
      if (r2) {
        if (decodeJWT(r2).payload.id !== a3) return;
        const c2 = await this.isValidJwtAttestation(r2);
        if (c2) {
          if (!c2.isVerified) {
            this.logger.warn("resolve: jwt attestation: origin url not verified");
            return;
          }
          return c2;
        }
      }
      if (!n4) return;
      const h4 = this.getVerifyUrl(i3 == null ? void 0 : i3.verifyUrl);
      return this.fetchAttestation(n4, h4);
    }, this.fetchAttestation = async (i3, r2) => {
      this.logger.debug(`resolving attestation: ${i3} from url: ${r2}`);
      const n4 = this.startAbortTimer(cjs$3.ONE_SECOND * 5), a3 = await fetch(`${r2}/attestation/${i3}?v2Supported=true`, { signal: this.abortController.signal });
      return clearTimeout(n4), a3.status === 200 ? await a3.json() : void 0;
    }, this.getVerifyUrl = (i3) => {
      let r2 = i3 || J$1;
      return wt$1.includes(r2) || (this.logger.info(`verify url: ${r2}, not included in trusted list, assigning default: ${J$1}`), r2 = J$1), r2;
    }, this.fetchPublicKey = async () => {
      try {
        this.logger.debug(`fetching public key from: ${this.verifyUrlV3}`);
        const i3 = this.startAbortTimer(cjs$3.FIVE_SECONDS), r2 = await fetch(`${this.verifyUrlV3}/public-key`, { signal: this.abortController.signal });
        return clearTimeout(i3), await r2.json();
      } catch (i3) {
        this.logger.warn(i3);
      }
    }, this.persistPublicKey = async (i3) => {
      this.logger.debug("persisting public key to local storage", i3), await this.store.setItem(this.storeKey, i3), this.publicKey = i3;
    }, this.removePublicKey = async () => {
      this.logger.debug("removing verify v2 public key from storage"), await this.store.removeItem(this.storeKey), this.publicKey = void 0;
    }, this.isValidJwtAttestation = async (i3) => {
      const r2 = await this.getPublicKey();
      try {
        if (r2) return this.validateAttestation(i3, r2);
      } catch (a3) {
        this.logger.error(a3), this.logger.warn("error validating attestation");
      }
      const n4 = await this.fetchAndPersistPublicKey();
      try {
        if (n4) return this.validateAttestation(i3, n4);
      } catch (a3) {
        this.logger.error(a3), this.logger.warn("error validating attestation");
      }
    }, this.getPublicKey = async () => this.publicKey ? this.publicKey : await this.fetchAndPersistPublicKey(), this.fetchAndPersistPublicKey = async () => {
      if (this.fetchPromise) return await this.fetchPromise, this.publicKey;
      this.fetchPromise = new Promise(async (r2) => {
        const n4 = await this.fetchPublicKey();
        n4 && (await this.persistPublicKey(n4), r2(n4));
      });
      const i3 = await this.fetchPromise;
      return this.fetchPromise = void 0, i3;
    }, this.validateAttestation = (i3, r2) => {
      const n4 = Rr$2(i3, r2.publicKey), a3 = { hasExpired: cjs$3.toMiliseconds(n4.exp) < Date.now(), payload: n4 };
      if (a3.hasExpired) throw this.logger.warn("resolve: jwt attestation expired"), new Error("JWT attestation expired");
      return { origin: a3.payload.origin, isScam: a3.payload.isScam, isVerified: a3.payload.isVerified };
    }, this.logger = E$1(t, this.name), this.abortController = new AbortController(), this.isDevEnv = Wt$2(), this.init();
  }
  get storeKey() {
    return this.storagePrefix + this.version + this.core.customStoragePrefix + "//verify:public:key";
  }
  get context() {
    return y$3(this.logger);
  }
  startAbortTimer(e2) {
    return this.abortController = new AbortController(), setTimeout(() => this.abortController.abort(), cjs$3.toMiliseconds(e2));
  }
}
class li extends v$3 {
  constructor(e2, t) {
    super(e2, t), this.projectId = e2, this.logger = t, this.context = It$1, this.registerDeviceToken = async (s2) => {
      const { clientId: i3, token: r2, notificationType: n4, enableEncrypted: a3 = false } = s2, h4 = `${Tt$1}/${this.projectId}/clients`;
      await fetch(h4, { method: "POST", headers: { "Content-Type": "application/json" }, body: JSON.stringify({ client_id: i3, type: n4, token: r2, always_raw: a3 }) });
    }, this.logger = E$1(t, this.context);
  }
}
var dn = Object.defineProperty, ui = Object.getOwnPropertySymbols, pn = Object.prototype.hasOwnProperty, gn = Object.prototype.propertyIsEnumerable, di = (o3, e2, t) => e2 in o3 ? dn(o3, e2, { enumerable: true, configurable: true, writable: true, value: t }) : o3[e2] = t, Z$2 = (o3, e2) => {
  for (var t in e2 || (e2 = {})) pn.call(e2, t) && di(o3, t, e2[t]);
  if (ui) for (var t of ui(e2)) gn.call(e2, t) && di(o3, t, e2[t]);
  return o3;
};
class pi extends C$3 {
  constructor(e2, t, s2 = true) {
    super(e2, t, s2), this.core = e2, this.logger = t, this.context = Pt$1, this.storagePrefix = x$3, this.storageVersion = Ct$1, this.events = /* @__PURE__ */ new Map(), this.shouldPersist = false, this.init = async () => {
      if (!Wt$2()) try {
        const i3 = { eventId: Ht$2(), timestamp: Date.now(), domain: this.getAppDomain(), props: { event: "INIT", type: "", properties: { client_id: await this.core.crypto.getClientId(), user_agent: Ge(this.core.relayer.protocol, this.core.relayer.version, se$2) } } };
        await this.sendEvent([i3]);
      } catch (i3) {
        this.logger.warn(i3);
      }
    }, this.createEvent = (i3) => {
      const { event: r2 = "ERROR", type: n4 = "", properties: { topic: a3, trace: h4 } } = i3, c2 = Ht$2(), l2 = this.core.projectId || "", p3 = Date.now(), D2 = Z$2({ eventId: c2, timestamp: p3, props: { event: r2, type: n4, properties: { topic: a3, trace: h4 } }, bundleId: l2, domain: this.getAppDomain() }, this.setMethods(c2));
      return this.telemetryEnabled && (this.events.set(c2, D2), this.shouldPersist = true), D2;
    }, this.getEvent = (i3) => {
      const { eventId: r2, topic: n4 } = i3;
      if (r2) return this.events.get(r2);
      const a3 = Array.from(this.events.values()).find((h4) => h4.props.properties.topic === n4);
      if (a3) return Z$2(Z$2({}, a3), this.setMethods(a3.eventId));
    }, this.deleteEvent = (i3) => {
      const { eventId: r2 } = i3;
      this.events.delete(r2), this.shouldPersist = true;
    }, this.setEventListeners = () => {
      this.core.heartbeat.on(r$1.pulse, async () => {
        this.shouldPersist && await this.persist(), this.events.forEach((i3) => {
          cjs$3.fromMiliseconds(Date.now()) - cjs$3.fromMiliseconds(i3.timestamp) > St$1 && (this.events.delete(i3.eventId), this.shouldPersist = true);
        });
      });
    }, this.setMethods = (i3) => ({ addTrace: (r2) => this.addTrace(i3, r2), setError: (r2) => this.setError(i3, r2) }), this.addTrace = (i3, r2) => {
      const n4 = this.events.get(i3);
      n4 && (n4.props.properties.trace.push(r2), this.events.set(i3, n4), this.shouldPersist = true);
    }, this.setError = (i3, r2) => {
      const n4 = this.events.get(i3);
      n4 && (n4.props.type = r2, n4.timestamp = Date.now(), this.events.set(i3, n4), this.shouldPersist = true);
    }, this.persist = async () => {
      await this.core.storage.setItem(this.storageKey, Array.from(this.events.values())), this.shouldPersist = false;
    }, this.restore = async () => {
      try {
        const i3 = await this.core.storage.getItem(this.storageKey) || [];
        if (!i3.length) return;
        i3.forEach((r2) => {
          this.events.set(r2.eventId, Z$2(Z$2({}, r2), this.setMethods(r2.eventId)));
        });
      } catch (i3) {
        this.logger.warn(i3);
      }
    }, this.submit = async () => {
      if (!this.telemetryEnabled || this.events.size === 0) return;
      const i3 = [];
      for (const [r2, n4] of this.events) n4.props.type && i3.push(n4);
      if (i3.length !== 0) try {
        if ((await this.sendEvent(i3)).ok) for (const r2 of i3) this.events.delete(r2.eventId), this.shouldPersist = true;
      } catch (r2) {
        this.logger.warn(r2);
      }
    }, this.sendEvent = async (i3) => {
      const r2 = this.getAppDomain() ? "" : "&sp=desktop";
      return await fetch(`${Rt$1}?projectId=${this.core.projectId}&st=events_sdk&sv=js-${se$2}${r2}`, { method: "POST", body: JSON.stringify(i3) });
    }, this.getAppDomain = () => Nt$2().url, this.logger = E$1(t, this.context), this.telemetryEnabled = s2, s2 ? this.restore().then(async () => {
      await this.submit(), this.setEventListeners();
    }) : this.persist();
  }
  get storageKey() {
    return this.storagePrefix + this.storageVersion + this.core.customStoragePrefix + "//" + this.context;
  }
}
var yn = Object.defineProperty, gi = Object.getOwnPropertySymbols, Dn = Object.prototype.hasOwnProperty, mn = Object.prototype.propertyIsEnumerable, yi = (o3, e2, t) => e2 in o3 ? yn(o3, e2, { enumerable: true, configurable: true, writable: true, value: t }) : o3[e2] = t, Di = (o3, e2) => {
  for (var t in e2 || (e2 = {})) Dn.call(e2, t) && yi(o3, t, e2[t]);
  if (gi) for (var t of gi(e2)) mn.call(e2, t) && yi(o3, t, e2[t]);
  return o3;
};
let ne$2 = class ne extends n$1 {
  constructor(e2) {
    var t;
    super(e2), this.protocol = ye$2, this.version = De$1, this.name = ie$2, this.events = new eventsExports.EventEmitter(), this.initialized = false, this.on = (n4, a3) => this.events.on(n4, a3), this.once = (n4, a3) => this.events.once(n4, a3), this.off = (n4, a3) => this.events.off(n4, a3), this.removeListener = (n4, a3) => this.events.removeListener(n4, a3), this.dispatchEnvelope = ({ topic: n4, message: a3, sessionExists: h4 }) => {
      if (!n4 || !a3) return;
      const c2 = { topic: n4, message: a3, publishedAt: Date.now(), transportType: M$2.link_mode };
      this.relayer.onLinkMessageEvent(c2, { sessionExists: h4 });
    }, this.projectId = e2 == null ? void 0 : e2.projectId, this.relayUrl = (e2 == null ? void 0 : e2.relayUrl) || be$2, this.customStoragePrefix = e2 != null && e2.customStoragePrefix ? `:${e2.customStoragePrefix}` : "";
    const s2 = k$2({ level: typeof (e2 == null ? void 0 : e2.logger) == "string" && e2.logger ? e2.logger : Ye.logger }), { logger: i3, chunkLoggerController: r2 } = A$1({ opts: s2, maxSizeInBytes: e2 == null ? void 0 : e2.maxLogBlobSizeInBytes, loggerOverride: e2 == null ? void 0 : e2.logger });
    this.logChunkController = r2, (t = this.logChunkController) != null && t.downloadLogsBlobInBrowser && (window.downloadLogsBlobInBrowser = async () => {
      var n4, a3;
      (n4 = this.logChunkController) != null && n4.downloadLogsBlobInBrowser && ((a3 = this.logChunkController) == null || a3.downloadLogsBlobInBrowser({ clientId: await this.crypto.getClientId() }));
    }), this.logger = E$1(i3, this.name), this.heartbeat = new i$1(), this.crypto = new Ht$1(this, this.logger, e2 == null ? void 0 : e2.keychain), this.history = new ai(this, this.logger), this.expirer = new hi(this, this.logger), this.storage = e2 != null && e2.storage ? e2.storage : new h$2(Di(Di({}, Je), e2 == null ? void 0 : e2.storageOptions)), this.relayer = new ti({ core: this, logger: this.logger, relayUrl: this.relayUrl, projectId: this.projectId }), this.pairing = new oi(this, this.logger), this.verify = new ci(this, this.logger, this.storage), this.echoClient = new li(this.projectId || "", this.logger), this.linkModeSupportedApps = [], this.eventClient = new pi(this, this.logger, e2 == null ? void 0 : e2.telemetryEnabled);
  }
  static async init(e2) {
    const t = new ne(e2);
    await t.initialize();
    const s2 = await t.crypto.getClientId();
    return await t.storage.setItem(lt$2, s2), t;
  }
  get context() {
    return y$3(this.logger);
  }
  async start() {
    this.initialized || await this.initialize();
  }
  async getLogsBlob() {
    var e2;
    return (e2 = this.logChunkController) == null ? void 0 : e2.logsToBlob({ clientId: await this.crypto.getClientId() });
  }
  async addLinkModeSupportedApp(e2) {
    this.linkModeSupportedApps.includes(e2) || (this.linkModeSupportedApps.push(e2), await this.storage.setItem(fe$1, this.linkModeSupportedApps));
  }
  async initialize() {
    this.logger.trace("Initialized");
    try {
      await this.crypto.init(), await this.history.init(), await this.expirer.init(), await this.relayer.init(), await this.heartbeat.init(), await this.pairing.init(), this.eventClient.init(), this.linkModeSupportedApps = await this.storage.getItem(fe$1) || [], this.initialized = true, this.logger.info("Core Initialization Success");
    } catch (e2) {
      throw this.logger.warn(`Core Initialization Failure at epoch ${Date.now()}`, e2), this.logger.error(e2.message), e2;
    }
  }
};
const bn = ne$2;
function unfetch_module(e2, n4) {
  return n4 = n4 || {}, new Promise(function(t, r2) {
    var s2 = new XMLHttpRequest(), o3 = [], u2 = [], i3 = {}, a3 = function() {
      return { ok: 2 == (s2.status / 100 | 0), statusText: s2.statusText, status: s2.status, url: s2.responseURL, text: function() {
        return Promise.resolve(s2.responseText);
      }, json: function() {
        return Promise.resolve(s2.responseText).then(JSON.parse);
      }, blob: function() {
        return Promise.resolve(new Blob([s2.response]));
      }, clone: a3, headers: { keys: function() {
        return o3;
      }, entries: function() {
        return u2;
      }, get: function(e3) {
        return i3[e3.toLowerCase()];
      }, has: function(e3) {
        return e3.toLowerCase() in i3;
      } } };
    };
    for (var l2 in s2.open(n4.method || "get", e2, true), s2.onload = function() {
      s2.getAllResponseHeaders().replace(/^(.*?):[^\S\n]*([\s\S]*?)$/gm, function(e3, n5, t2) {
        o3.push(n5 = n5.toLowerCase()), u2.push([n5, t2]), i3[n5] = i3[n5] ? i3[n5] + "," + t2 : t2;
      }), t(a3());
    }, s2.onerror = r2, s2.withCredentials = "include" == n4.credentials, n4.headers) s2.setRequestHeader(l2, n4.headers[l2]);
    s2.send(n4.body || null);
  });
}
const unfetch_module$1 = /* @__PURE__ */ Object.freeze(/* @__PURE__ */ Object.defineProperty({
  __proto__: null,
  default: unfetch_module
}, Symbol.toStringTag, { value: "Module" }));
const require$$0 = /* @__PURE__ */ getAugmentedNamespace(unfetch_module$1);
var browser = self.fetch || (self.fetch = require$$0.default || require$$0);
const ke = /* @__PURE__ */ getDefaultExportFromCjs(browser);
class G {
  constructor(t) {
    this.client = t;
  }
}
class H {
  constructor(t) {
    this.opts = t;
  }
}
const Y$1 = "https://rpc.walletconnect.com/v1", R$1 = { wc_authRequest: { req: { ttl: cjs$3.ONE_DAY, prompt: true, tag: 3e3 }, res: { ttl: cjs$3.ONE_DAY, prompt: false, tag: 3001 } } }, U$1 = { min: cjs$3.FIVE_MINUTES, max: cjs$3.SEVEN_DAYS }, $ = "wc", Q = 1, Z$1 = "auth", B$1 = "authClient", F$1 = `${$}@${1}:${Z$1}:`, x$2 = `${F$1}:PUB_KEY`;
function z$2(r2) {
  return r2 == null ? void 0 : r2.split(":");
}
function Ze(r2) {
  const t = r2 && z$2(r2);
  if (t) return t[3];
}
function We(r2) {
  const t = r2 && z$2(r2);
  if (t) return t[2] + ":" + t[3];
}
function W(r2) {
  const t = r2 && z$2(r2);
  if (t) return t.pop();
}
async function et(r2, t, e2, i3, n4) {
  switch (e2.t) {
    case "eip191":
      return tt(r2, t, e2.s);
    case "eip1271":
      return await rt$1(r2, t, e2.s, i3, n4);
    default:
      throw new Error(`verifySignature failed: Attempted to verify CacaoSignature with unknown type: ${e2.t}`);
  }
}
function tt(r2, t, e2) {
  return recoverAddress(hashMessage(t), e2).toLowerCase() === r2.toLowerCase();
}
async function rt$1(r2, t, e2, i3, n4) {
  try {
    const s2 = "0x1626ba7e", o3 = "0000000000000000000000000000000000000000000000000000000000000040", u2 = "0000000000000000000000000000000000000000000000000000000000000041", a3 = e2.substring(2), c2 = hashMessage(t).substring(2), h4 = s2 + c2 + o3 + u2 + a3, f3 = await ke(`${Y$1}/?chainId=${i3}&projectId=${n4}`, { method: "POST", body: JSON.stringify({ id: it$1(), jsonrpc: "2.0", method: "eth_call", params: [{ to: r2, data: h4 }, "latest"] }) }), { result: p3 } = await f3.json();
    return p3 ? p3.slice(0, s2.length).toLowerCase() === s2.toLowerCase() : false;
  } catch (s2) {
    return console.error("isValidEip1271Signature: ", s2), false;
  }
}
function it$1() {
  return Date.now() + Math.floor(Math.random() * 1e3);
}
function ee$1(r2) {
  return r2.getAll().filter((t) => "requester" in t);
}
function te$1(r2, t) {
  return ee$1(r2).find((e2) => e2.id === t);
}
function nt$1(r2) {
  const t = Gr$1(r2.aud), e2 = new RegExp(`${r2.domain}`).test(r2.aud), i3 = !!r2.nonce, n4 = r2.type ? r2.type === "eip4361" : true, s2 = r2.expiry;
  if (s2 && !po(s2, U$1)) {
    const { message: o3 } = S$5("MISSING_OR_INVALID", `request() expiry: ${s2}. Expiry must be a number (in seconds) between ${U$1.min} and ${U$1.max}`);
    throw new Error(o3);
  }
  return !!(t && e2 && i3 && n4);
}
function st$1(r2, t) {
  return !!te$1(t, r2.id);
}
function ot$1(r2 = 0) {
  return globalThis.Buffer != null && globalThis.Buffer.allocUnsafe != null ? globalThis.Buffer.allocUnsafe(r2) : new Uint8Array(r2);
}
function ut$1(r2, t) {
  if (r2.length >= 255) throw new TypeError("Alphabet too long");
  for (var e2 = new Uint8Array(256), i3 = 0; i3 < e2.length; i3++) e2[i3] = 255;
  for (var n4 = 0; n4 < r2.length; n4++) {
    var s2 = r2.charAt(n4), o3 = s2.charCodeAt(0);
    if (e2[o3] !== 255) throw new TypeError(s2 + " is ambiguous");
    e2[o3] = n4;
  }
  var u2 = r2.length, a3 = r2.charAt(0), c2 = Math.log(u2) / Math.log(256), h4 = Math.log(256) / Math.log(u2);
  function f3(D2) {
    if (D2 instanceof Uint8Array || (ArrayBuffer.isView(D2) ? D2 = new Uint8Array(D2.buffer, D2.byteOffset, D2.byteLength) : Array.isArray(D2) && (D2 = Uint8Array.from(D2))), !(D2 instanceof Uint8Array)) throw new TypeError("Expected Uint8Array");
    if (D2.length === 0) return "";
    for (var l2 = 0, m2 = 0, E2 = 0, y3 = D2.length; E2 !== y3 && D2[E2] === 0; ) E2++, l2++;
    for (var w2 = (y3 - E2) * h4 + 1 >>> 0, g3 = new Uint8Array(w2); E2 !== y3; ) {
      for (var C3 = D2[E2], _3 = 0, b2 = w2 - 1; (C3 !== 0 || _3 < m2) && b2 !== -1; b2--, _3++) C3 += 256 * g3[b2] >>> 0, g3[b2] = C3 % u2 >>> 0, C3 = C3 / u2 >>> 0;
      if (C3 !== 0) throw new Error("Non-zero carry");
      m2 = _3, E2++;
    }
    for (var v3 = w2 - m2; v3 !== w2 && g3[v3] === 0; ) v3++;
    for (var q2 = a3.repeat(l2); v3 < w2; ++v3) q2 += r2.charAt(g3[v3]);
    return q2;
  }
  function p3(D2) {
    if (typeof D2 != "string") throw new TypeError("Expected String");
    if (D2.length === 0) return new Uint8Array();
    var l2 = 0;
    if (D2[l2] !== " ") {
      for (var m2 = 0, E2 = 0; D2[l2] === a3; ) m2++, l2++;
      for (var y3 = (D2.length - l2) * c2 + 1 >>> 0, w2 = new Uint8Array(y3); D2[l2]; ) {
        var g3 = e2[D2.charCodeAt(l2)];
        if (g3 === 255) return;
        for (var C3 = 0, _3 = y3 - 1; (g3 !== 0 || C3 < E2) && _3 !== -1; _3--, C3++) g3 += u2 * w2[_3] >>> 0, w2[_3] = g3 % 256 >>> 0, g3 = g3 / 256 >>> 0;
        if (g3 !== 0) throw new Error("Non-zero carry");
        E2 = C3, l2++;
      }
      if (D2[l2] !== " ") {
        for (var b2 = y3 - E2; b2 !== y3 && w2[b2] === 0; ) b2++;
        for (var v3 = new Uint8Array(m2 + (y3 - b2)), q2 = m2; b2 !== y3; ) v3[q2++] = w2[b2++];
        return v3;
      }
    }
  }
  function A2(D2) {
    var l2 = p3(D2);
    if (l2) return l2;
    throw new Error(`Non-${t} character`);
  }
  return { encode: f3, decodeUnsafe: p3, decode: A2 };
}
var at$1 = ut$1, Dt = at$1;
const re = (r2) => {
  if (r2 instanceof Uint8Array && r2.constructor.name === "Uint8Array") return r2;
  if (r2 instanceof ArrayBuffer) return new Uint8Array(r2);
  if (ArrayBuffer.isView(r2)) return new Uint8Array(r2.buffer, r2.byteOffset, r2.byteLength);
  throw new Error("Unknown type, must be binary type");
}, ct$1 = (r2) => new TextEncoder().encode(r2), ht$1 = (r2) => new TextDecoder().decode(r2);
let lt$1 = class lt {
  constructor(t, e2, i3) {
    this.name = t, this.prefix = e2, this.baseEncode = i3;
  }
  encode(t) {
    if (t instanceof Uint8Array) return `${this.prefix}${this.baseEncode(t)}`;
    throw Error("Unknown type, must be binary type");
  }
};
let dt$1 = class dt {
  constructor(t, e2, i3) {
    if (this.name = t, this.prefix = e2, e2.codePointAt(0) === void 0) throw new Error("Invalid prefix character");
    this.prefixCodePoint = e2.codePointAt(0), this.baseDecode = i3;
  }
  decode(t) {
    if (typeof t == "string") {
      if (t.codePointAt(0) !== this.prefixCodePoint) throw Error(`Unable to decode multibase string ${JSON.stringify(t)}, ${this.name} decoder only supports inputs prefixed with ${this.prefix}`);
      return this.baseDecode(t.slice(this.prefix.length));
    } else throw Error("Can only multibase decode strings");
  }
  or(t) {
    return ie$1(this, t);
  }
};
let pt$1 = class pt {
  constructor(t) {
    this.decoders = t;
  }
  or(t) {
    return ie$1(this, t);
  }
  decode(t) {
    const e2 = t[0], i3 = this.decoders[e2];
    if (i3) return i3.decode(t);
    throw RangeError(`Unable to decode multibase string ${JSON.stringify(t)}, only inputs prefixed with ${Object.keys(this.decoders)} are supported`);
  }
};
const ie$1 = (r2, t) => new pt$1({ ...r2.decoders || { [r2.prefix]: r2 }, ...t.decoders || { [t.prefix]: t } });
class ft {
  constructor(t, e2, i3, n4) {
    this.name = t, this.prefix = e2, this.baseEncode = i3, this.baseDecode = n4, this.encoder = new lt$1(t, e2, i3), this.decoder = new dt$1(t, e2, n4);
  }
  encode(t) {
    return this.encoder.encode(t);
  }
  decode(t) {
    return this.decoder.decode(t);
  }
}
const O$1 = ({ name: r2, prefix: t, encode: e2, decode: i3 }) => new ft(r2, t, e2, i3), T$1 = ({ prefix: r2, name: t, alphabet: e2 }) => {
  const { encode: i3, decode: n4 } = Dt(e2, t);
  return O$1({ prefix: r2, name: t, encode: i3, decode: (s2) => re(n4(s2)) });
}, gt$1 = (r2, t, e2, i3) => {
  const n4 = {};
  for (let h4 = 0; h4 < t.length; ++h4) n4[t[h4]] = h4;
  let s2 = r2.length;
  for (; r2[s2 - 1] === "="; ) --s2;
  const o3 = new Uint8Array(s2 * e2 / 8 | 0);
  let u2 = 0, a3 = 0, c2 = 0;
  for (let h4 = 0; h4 < s2; ++h4) {
    const f3 = n4[r2[h4]];
    if (f3 === void 0) throw new SyntaxError(`Non-${i3} character`);
    a3 = a3 << e2 | f3, u2 += e2, u2 >= 8 && (u2 -= 8, o3[c2++] = 255 & a3 >> u2);
  }
  if (u2 >= e2 || 255 & a3 << 8 - u2) throw new SyntaxError("Unexpected end of data");
  return o3;
}, Et = (r2, t, e2) => {
  const i3 = t[t.length - 1] === "=", n4 = (1 << e2) - 1;
  let s2 = "", o3 = 0, u2 = 0;
  for (let a3 = 0; a3 < r2.length; ++a3) for (u2 = u2 << 8 | r2[a3], o3 += 8; o3 > e2; ) o3 -= e2, s2 += t[n4 & u2 >> o3];
  if (o3 && (s2 += t[n4 & u2 << e2 - o3]), i3) for (; s2.length * e2 & 7; ) s2 += "=";
  return s2;
}, d3 = ({ name: r2, prefix: t, bitsPerChar: e2, alphabet: i3 }) => O$1({ prefix: t, name: r2, encode(n4) {
  return Et(n4, i3, e2);
}, decode(n4) {
  return gt$1(n4, i3, e2, r2);
} }), bt = O$1({ prefix: "\0", name: "identity", encode: (r2) => ht$1(r2), decode: (r2) => ct$1(r2) });
var yt$1 = Object.freeze({ __proto__: null, identity: bt });
const wt = d3({ prefix: "0", name: "base2", alphabet: "01", bitsPerChar: 1 });
var Ct = Object.freeze({ __proto__: null, base2: wt });
const mt = d3({ prefix: "7", name: "base8", alphabet: "01234567", bitsPerChar: 3 });
var vt = Object.freeze({ __proto__: null, base8: mt });
const At = T$1({ prefix: "9", name: "base10", alphabet: "0123456789" });
var _t = Object.freeze({ __proto__: null, base10: At });
const xt = d3({ prefix: "f", name: "base16", alphabet: "0123456789abcdef", bitsPerChar: 4 }), Rt = d3({ prefix: "F", name: "base16upper", alphabet: "0123456789ABCDEF", bitsPerChar: 4 });
var Ft = Object.freeze({ __proto__: null, base16: xt, base16upper: Rt });
const Tt = d3({ prefix: "b", name: "base32", alphabet: "abcdefghijklmnopqrstuvwxyz234567", bitsPerChar: 5 }), It = d3({ prefix: "B", name: "base32upper", alphabet: "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567", bitsPerChar: 5 }), qt = d3({ prefix: "c", name: "base32pad", alphabet: "abcdefghijklmnopqrstuvwxyz234567=", bitsPerChar: 5 }), Ut = d3({ prefix: "C", name: "base32padupper", alphabet: "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567=", bitsPerChar: 5 }), Ot = d3({ prefix: "v", name: "base32hex", alphabet: "0123456789abcdefghijklmnopqrstuv", bitsPerChar: 5 }), St = d3({ prefix: "V", name: "base32hexupper", alphabet: "0123456789ABCDEFGHIJKLMNOPQRSTUV", bitsPerChar: 5 }), Pt = d3({ prefix: "t", name: "base32hexpad", alphabet: "0123456789abcdefghijklmnopqrstuv=", bitsPerChar: 5 }), Nt = d3({ prefix: "T", name: "base32hexpadupper", alphabet: "0123456789ABCDEFGHIJKLMNOPQRSTUV=", bitsPerChar: 5 }), $t = d3({ prefix: "h", name: "base32z", alphabet: "ybndrfg8ejkmcpqxot1uwisza345h769", bitsPerChar: 5 });
var Bt = Object.freeze({ __proto__: null, base32: Tt, base32upper: It, base32pad: qt, base32padupper: Ut, base32hex: Ot, base32hexupper: St, base32hexpad: Pt, base32hexpadupper: Nt, base32z: $t });
const zt = T$1({ prefix: "k", name: "base36", alphabet: "0123456789abcdefghijklmnopqrstuvwxyz" }), jt = T$1({ prefix: "K", name: "base36upper", alphabet: "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ" });
var Mt = Object.freeze({ __proto__: null, base36: zt, base36upper: jt });
const Lt = T$1({ name: "base58btc", prefix: "z", alphabet: "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz" }), Kt = T$1({ name: "base58flickr", prefix: "Z", alphabet: "123456789abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ" });
var Vt = Object.freeze({ __proto__: null, base58btc: Lt, base58flickr: Kt });
const kt = d3({ prefix: "m", name: "base64", alphabet: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/", bitsPerChar: 6 }), Jt = d3({ prefix: "M", name: "base64pad", alphabet: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=", bitsPerChar: 6 }), Xt = d3({ prefix: "u", name: "base64url", alphabet: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_", bitsPerChar: 6 }), Gt2 = d3({ prefix: "U", name: "base64urlpad", alphabet: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_=", bitsPerChar: 6 });
var Ht2 = Object.freeze({ __proto__: null, base64: kt, base64pad: Jt, base64url: Xt, base64urlpad: Gt2 });
const ne$1 = Array.from("🚀🪐☄🛰🌌🌑🌒🌓🌔🌕🌖🌗🌘🌍🌏🌎🐉☀💻🖥💾💿😂❤😍🤣😊🙏💕😭😘👍😅👏😁🔥🥰💔💖💙😢🤔😆🙄💪😉☺👌🤗💜😔😎😇🌹🤦🎉💞✌✨🤷😱😌🌸🙌😋💗💚😏💛🙂💓🤩😄😀🖤😃💯🙈👇🎶😒🤭❣😜💋👀😪😑💥🙋😞😩😡🤪👊🥳😥🤤👉💃😳✋😚😝😴🌟😬🙃🍀🌷😻😓⭐✅🥺🌈😈🤘💦✔😣🏃💐☹🎊💘😠☝😕🌺🎂🌻😐🖕💝🙊😹🗣💫💀👑🎵🤞😛🔴😤🌼😫⚽🤙☕🏆🤫👈😮🙆🍻🍃🐶💁😲🌿🧡🎁⚡🌞🎈❌✊👋😰🤨😶🤝🚶💰🍓💢🤟🙁🚨💨🤬✈🎀🍺🤓😙💟🌱😖👶🥴▶➡❓💎💸⬇😨🌚🦋😷🕺⚠🙅😟😵👎🤲🤠🤧📌🔵💅🧐🐾🍒😗🤑🌊🤯🐷☎💧😯💆👆🎤🙇🍑❄🌴💣🐸💌📍🥀🤢👅💡💩👐📸👻🤐🤮🎼🥵🚩🍎🍊👼💍📣🥂"), Yt2 = ne$1.reduce((r2, t, e2) => (r2[e2] = t, r2), []), Qt = ne$1.reduce((r2, t, e2) => (r2[t.codePointAt(0)] = e2, r2), []);
function Zt(r2) {
  return r2.reduce((t, e2) => (t += Yt2[e2], t), "");
}
function Wt2(r2) {
  const t = [];
  for (const e2 of r2) {
    const i3 = Qt[e2.codePointAt(0)];
    if (i3 === void 0) throw new Error(`Non-base256emoji character: ${e2}`);
    t.push(i3);
  }
  return new Uint8Array(t);
}
const er = O$1({ prefix: "🚀", name: "base256emoji", encode: Zt, decode: Wt2 });
var tr = Object.freeze({ __proto__: null, base256emoji: er }), rr = oe$1, se$1 = 128, ir = 127, nr = ~ir, sr = Math.pow(2, 31);
function oe$1(r2, t, e2) {
  t = t || [], e2 = e2 || 0;
  for (var i3 = e2; r2 >= sr; ) t[e2++] = r2 & 255 | se$1, r2 /= 128;
  for (; r2 & nr; ) t[e2++] = r2 & 255 | se$1, r2 >>>= 7;
  return t[e2] = r2 | 0, oe$1.bytes = e2 - i3 + 1, t;
}
var or = j$1, ur = 128, ue = 127;
function j$1(r2, i3) {
  var e2 = 0, i3 = i3 || 0, n4 = 0, s2 = i3, o3, u2 = r2.length;
  do {
    if (s2 >= u2) throw j$1.bytes = 0, new RangeError("Could not decode varint");
    o3 = r2[s2++], e2 += n4 < 28 ? (o3 & ue) << n4 : (o3 & ue) * Math.pow(2, n4), n4 += 7;
  } while (o3 >= ur);
  return j$1.bytes = s2 - i3, e2;
}
var ar = Math.pow(2, 7), Dr = Math.pow(2, 14), cr = Math.pow(2, 21), hr = Math.pow(2, 28), lr = Math.pow(2, 35), dr = Math.pow(2, 42), pr = Math.pow(2, 49), fr = Math.pow(2, 56), gr = Math.pow(2, 63), Er = function(r2) {
  return r2 < ar ? 1 : r2 < Dr ? 2 : r2 < cr ? 3 : r2 < hr ? 4 : r2 < lr ? 5 : r2 < dr ? 6 : r2 < pr ? 7 : r2 < fr ? 8 : r2 < gr ? 9 : 10;
}, br = { encode: rr, decode: or, encodingLength: Er }, ae$1 = br;
const De = (r2, t, e2 = 0) => (ae$1.encode(r2, t, e2), t), ce = (r2) => ae$1.encodingLength(r2), M$1 = (r2, t) => {
  const e2 = t.byteLength, i3 = ce(r2), n4 = i3 + ce(e2), s2 = new Uint8Array(n4 + e2);
  return De(r2, s2, 0), De(e2, s2, i3), s2.set(t, n4), new yr(r2, e2, t, s2);
};
class yr {
  constructor(t, e2, i3, n4) {
    this.code = t, this.size = e2, this.digest = i3, this.bytes = n4;
  }
}
const he = ({ name: r2, code: t, encode: e2 }) => new wr(r2, t, e2);
class wr {
  constructor(t, e2, i3) {
    this.name = t, this.code = e2, this.encode = i3;
  }
  digest(t) {
    if (t instanceof Uint8Array) {
      const e2 = this.encode(t);
      return e2 instanceof Uint8Array ? M$1(this.code, e2) : e2.then((i3) => M$1(this.code, i3));
    } else throw Error("Unknown type, must be binary type");
  }
}
const le = (r2) => async (t) => new Uint8Array(await crypto.subtle.digest(r2, t)), Cr = he({ name: "sha2-256", code: 18, encode: le("SHA-256") }), mr = he({ name: "sha2-512", code: 19, encode: le("SHA-512") });
var vr = Object.freeze({ __proto__: null, sha256: Cr, sha512: mr });
const de = 0, Ar = "identity", pe = re, _r = (r2) => M$1(de, pe(r2)), xr = { code: de, name: Ar, encode: pe, digest: _r };
var Rr = Object.freeze({ __proto__: null, identity: xr });
new TextEncoder(), new TextDecoder();
const fe = { ...yt$1, ...Ct, ...vt, ..._t, ...Ft, ...Bt, ...Mt, ...Vt, ...Ht2, ...tr };
({ ...vr, ...Rr });
function ge(r2, t, e2, i3) {
  return { name: r2, prefix: t, encoder: { name: r2, prefix: t, encode: e2 }, decoder: { decode: i3 } };
}
const Ee = ge("utf8", "u", (r2) => "u" + new TextDecoder("utf8").decode(r2), (r2) => new TextEncoder().encode(r2.substring(1))), L$1 = ge("ascii", "a", (r2) => {
  let t = "a";
  for (let e2 = 0; e2 < r2.length; e2++) t += String.fromCharCode(r2[e2]);
  return t;
}, (r2) => {
  r2 = r2.substring(1);
  const t = ot$1(r2.length);
  for (let e2 = 0; e2 < r2.length; e2++) t[e2] = r2.charCodeAt(e2);
  return t;
}), be$1 = { utf8: Ee, "utf-8": Ee, hex: fe.base16, latin1: L$1, ascii: L$1, binary: L$1, ...fe };
function Fr2(r2, t = "utf8") {
  const e2 = be$1[t];
  if (!e2) throw new Error(`Unsupported encoding "${t}"`);
  return (t === "utf8" || t === "utf-8") && globalThis.Buffer != null && globalThis.Buffer.from != null ? globalThis.Buffer.from(r2, "utf8") : e2.decoder.decode(`${e2.prefix}${r2}`);
}
function Tr(r2, t = "utf8") {
  const e2 = be$1[t];
  if (!e2) throw new Error(`Unsupported encoding "${t}"`);
  return (t === "utf8" || t === "utf-8") && globalThis.Buffer != null && globalThis.Buffer.from != null ? globalThis.Buffer.from(r2.buffer, r2.byteOffset, r2.byteLength).toString("utf8") : e2.encoder.encode(r2).substring(1);
}
const ye$1 = "base16", we$1 = "utf8";
function K$1(r2) {
  const t = sha256.hash(Fr2(r2, we$1));
  return Tr(t, ye$1);
}
var Or = Object.defineProperty, Sr = Object.defineProperties, Pr = Object.getOwnPropertyDescriptors, Ce$1 = Object.getOwnPropertySymbols, Nr = Object.prototype.hasOwnProperty, $r = Object.prototype.propertyIsEnumerable, me$1 = (r2, t, e2) => t in r2 ? Or(r2, t, { enumerable: true, configurable: true, writable: true, value: e2 }) : r2[t] = e2, I$1 = (r2, t) => {
  for (var e2 in t || (t = {})) Nr.call(t, e2) && me$1(r2, e2, t[e2]);
  if (Ce$1) for (var e2 of Ce$1(t)) $r.call(t, e2) && me$1(r2, e2, t[e2]);
  return r2;
}, V$1 = (r2, t) => Sr(r2, Pr(t));
class Br extends G {
  constructor(t) {
    super(t), this.initialized = false, this.name = "authEngine", this.init = () => {
      this.initialized || (this.registerRelayerEvents(), this.registerPairingEvents(), this.client.core.pairing.register({ methods: Object.keys(R$1) }), this.initialized = true);
    }, this.request = async (e2, i3) => {
      if (this.isInitialized(), !nt$1(e2)) throw new Error("Invalid request");
      if (i3 != null && i3.topic) return await this.requestOnKnownPairing(i3.topic, e2);
      const { chainId: n4, statement: s2, aud: o3, domain: u2, nonce: a3, type: c2, exp: h4, nbf: f3 } = e2, { topic: p3, uri: A2 } = await this.client.core.pairing.create();
      this.client.logger.info({ message: "Generated new pairing", pairing: { topic: p3, uri: A2 } });
      const D2 = await this.client.core.crypto.generateKeyPair(), l2 = hr$2(D2);
      await this.client.authKeys.set(x$2, { responseTopic: l2, publicKey: D2 }), await this.client.pairingTopics.set(l2, { topic: l2, pairingTopic: p3 }), await this.client.core.relayer.subscribe(l2), this.client.logger.info(`sending request to new pairing topic: ${p3}`);
      const m2 = await this.sendRequest(p3, "wc_authRequest", { payloadParams: { type: c2 ?? "eip4361", chainId: n4, statement: s2, aud: o3, domain: u2, version: "1", nonce: a3, iat: (/* @__PURE__ */ new Date()).toISOString(), exp: h4, nbf: f3 }, requester: { publicKey: D2, metadata: this.client.metadata } }, {}, e2.expiry);
      return this.client.logger.info(`sent request to new pairing topic: ${p3}`), { uri: A2, id: m2 };
    }, this.respond = async (e2, i3) => {
      if (this.isInitialized(), !st$1(e2, this.client.requests)) throw new Error("Invalid response");
      const n4 = te$1(this.client.requests, e2.id);
      if (!n4) throw new Error(`Could not find pending auth request with id ${e2.id}`);
      const s2 = n4.requester.publicKey, o3 = await this.client.core.crypto.generateKeyPair(), u2 = hr$2(s2), a3 = { type: D$2, receiverPublicKey: s2, senderPublicKey: o3 };
      if ("error" in e2) {
        await this.sendError(n4.id, u2, e2, a3);
        return;
      }
      const c2 = { h: { t: "eip4361" }, p: V$1(I$1({}, n4.cacaoPayload), { iss: i3 }), s: e2.signature };
      await this.sendResult(n4.id, u2, c2, a3), await this.client.core.pairing.activate({ topic: n4.pairingTopic }), await this.client.requests.update(n4.id, I$1({}, c2));
    }, this.getPendingRequests = () => ee$1(this.client.requests), this.formatMessage = (e2, i3) => {
      this.client.logger.debug(`formatMessage, cacao is: ${JSON.stringify(e2)}`);
      const n4 = `${e2.domain} wants you to sign in with your Ethereum account:`, s2 = W(i3), o3 = e2.statement, u2 = `URI: ${e2.aud}`, a3 = `Version: ${e2.version}`, c2 = `Chain ID: ${Ze(i3)}`, h4 = `Nonce: ${e2.nonce}`, f3 = `Issued At: ${e2.iat}`, p3 = e2.exp ? `Expiry: ${e2.exp}` : void 0, A2 = e2.resources && e2.resources.length > 0 ? `Resources:
${e2.resources.map((D2) => `- ${D2}`).join(`
`)}` : void 0;
      return [n4, s2, "", o3, "", u2, a3, c2, h4, f3, p3, A2].filter((D2) => D2 != null).join(`
`);
    }, this.setExpiry = async (e2, i3) => {
      this.client.core.pairing.pairings.keys.includes(e2) && await this.client.core.pairing.updateExpiry({ topic: e2, expiry: i3 }), this.client.core.expirer.set(e2, i3);
    }, this.sendRequest = async (e2, i3, n4, s2, o3) => {
      const u2 = formatJsonRpcRequest(i3, n4), a3 = await this.client.core.crypto.encode(e2, u2, s2), c2 = R$1[i3].req;
      if (o3 && (c2.ttl = o3), this.client.core.history.set(e2, u2), V$3()) {
        const h4 = K$1(JSON.stringify(u2));
        this.client.core.verify.register({ attestationId: h4 });
      }
      return await this.client.core.relayer.publish(e2, a3, V$1(I$1({}, c2), { internal: { throwOnFailedPublish: true } })), u2.id;
    }, this.sendResult = async (e2, i3, n4, s2) => {
      const o3 = formatJsonRpcResult(e2, n4), u2 = await this.client.core.crypto.encode(i3, o3, s2), a3 = await this.client.core.history.get(i3, e2), c2 = R$1[a3.request.method].res;
      return await this.client.core.relayer.publish(i3, u2, V$1(I$1({}, c2), { internal: { throwOnFailedPublish: true } })), await this.client.core.history.resolve(o3), o3.id;
    }, this.sendError = async (e2, i3, n4, s2) => {
      const o3 = formatJsonRpcError(e2, n4.error), u2 = await this.client.core.crypto.encode(i3, o3, s2), a3 = await this.client.core.history.get(i3, e2), c2 = R$1[a3.request.method].res;
      return await this.client.core.relayer.publish(i3, u2, c2), await this.client.core.history.resolve(o3), o3.id;
    }, this.requestOnKnownPairing = async (e2, i3) => {
      const n4 = this.client.core.pairing.pairings.getAll({ active: true }).find((A2) => A2.topic === e2);
      if (!n4) throw new Error(`Could not find pairing for provided topic ${e2}`);
      const { publicKey: s2 } = this.client.authKeys.get(x$2), { chainId: o3, statement: u2, aud: a3, domain: c2, nonce: h4, type: f3 } = i3, p3 = await this.sendRequest(n4.topic, "wc_authRequest", { payloadParams: { type: f3 ?? "eip4361", chainId: o3, statement: u2, aud: a3, domain: c2, version: "1", nonce: h4, iat: (/* @__PURE__ */ new Date()).toISOString() }, requester: { publicKey: s2, metadata: this.client.metadata } }, {}, i3.expiry);
      return this.client.logger.info(`sent request to known pairing topic: ${n4.topic}`), { id: p3 };
    }, this.onPairingCreated = (e2) => {
      const i3 = this.getPendingRequests();
      if (i3) {
        const n4 = Object.values(i3).find((s2) => s2.pairingTopic === e2.topic);
        n4 && this.handleAuthRequest(n4);
      }
    }, this.onRelayEventRequest = (e2) => {
      const { topic: i3, payload: n4 } = e2, s2 = n4.method;
      switch (s2) {
        case "wc_authRequest":
          return this.onAuthRequest(i3, n4);
        default:
          return this.client.logger.info(`Unsupported request method ${s2}`);
      }
    }, this.onRelayEventResponse = async (e2) => {
      const { topic: i3, payload: n4 } = e2, s2 = (await this.client.core.history.get(i3, n4.id)).request.method;
      switch (s2) {
        case "wc_authRequest":
          return this.onAuthResponse(i3, n4);
        default:
          return this.client.logger.info(`Unsupported response method ${s2}`);
      }
    }, this.onAuthRequest = async (e2, i3) => {
      const { requester: n4, payloadParams: s2 } = i3.params;
      this.client.logger.info({ type: "onAuthRequest", topic: e2, payload: i3 });
      const o3 = K$1(JSON.stringify(i3)), u2 = await this.getVerifyContext(o3, this.client.metadata), a3 = { requester: n4, pairingTopic: e2, id: i3.id, cacaoPayload: s2, verifyContext: u2 };
      await this.client.requests.set(i3.id, a3), this.handleAuthRequest(a3);
    }, this.handleAuthRequest = async (e2) => {
      const { id: i3, pairingTopic: n4, requester: s2, cacaoPayload: o3, verifyContext: u2 } = e2;
      try {
        this.client.emit("auth_request", { id: i3, topic: n4, params: { requester: s2, cacaoPayload: o3 }, verifyContext: u2 });
      } catch (a3) {
        await this.sendError(e2.id, e2.pairingTopic, a3), this.client.logger.error(a3);
      }
    }, this.onAuthResponse = async (e2, i3) => {
      const { id: n4 } = i3;
      if (this.client.logger.info({ type: "onAuthResponse", topic: e2, response: i3 }), isJsonRpcResult(i3)) {
        const { pairingTopic: s2 } = this.client.pairingTopics.get(e2);
        await this.client.core.pairing.activate({ topic: s2 });
        const { s: o3, p: u2 } = i3.result;
        await this.client.requests.set(n4, I$1({ id: n4, pairingTopic: s2 }, i3.result));
        const a3 = this.formatMessage(u2, u2.iss);
        this.client.logger.debug(`reconstructed message:
`, JSON.stringify(a3)), this.client.logger.debug("payload.iss:", u2.iss), this.client.logger.debug("signature:", o3);
        const c2 = W(u2.iss), h4 = We(u2.iss);
        if (!c2) throw new Error("Could not derive address from `payload.iss`");
        if (!h4) throw new Error("Could not derive chainId from `payload.iss`");
        this.client.logger.debug("walletAddress extracted from `payload.iss`:", c2), await et(c2, a3, o3, h4, this.client.projectId) ? this.client.emit("auth_response", { id: n4, topic: e2, params: i3 }) : this.client.emit("auth_response", { id: n4, topic: e2, params: { message: "Invalid signature", code: -1 } });
      } else isJsonRpcError(i3) && this.client.emit("auth_response", { id: n4, topic: e2, params: i3 });
    }, this.getVerifyContext = async (e2, i3) => {
      const n4 = { verified: { verifyUrl: i3.verifyUrl || "", validation: "UNKNOWN", origin: i3.url || "" } };
      try {
        const s2 = await this.client.core.verify.resolve({ attestationId: e2, verifyUrl: i3.verifyUrl });
        s2 && (n4.verified.origin = s2.origin, n4.verified.isScam = s2.isScam, n4.verified.validation = origin === new URL(i3.url).origin ? "VALID" : "INVALID");
      } catch (s2) {
        this.client.logger.error(s2);
      }
      return this.client.logger.info(`Verify context: ${JSON.stringify(n4)}`), n4;
    };
  }
  isInitialized() {
    if (!this.initialized) {
      const { message: t } = S$5("NOT_INITIALIZED", this.name);
      throw new Error(t);
    }
  }
  registerRelayerEvents() {
    this.client.core.relayer.on(v$2.message, async (t) => {
      const { topic: e2, message: i3 } = t, { responseTopic: n4, publicKey: s2 } = this.client.authKeys.keys.includes(x$2) ? this.client.authKeys.get(x$2) : { responseTopic: void 0, publicKey: void 0 };
      if (n4 && e2 !== n4) {
        this.client.logger.debug("[Auth] Ignoring message from unknown topic", e2);
        return;
      }
      const o3 = await this.client.core.crypto.decode(e2, i3, { receiverPublicKey: s2 });
      isJsonRpcRequest(o3) ? (this.client.core.history.set(e2, o3), this.onRelayEventRequest({ topic: e2, payload: o3 })) : isJsonRpcResponse(o3) && (await this.client.core.history.resolve(o3), this.onRelayEventResponse({ topic: e2, payload: o3 }));
    });
  }
  registerPairingEvents() {
    this.client.core.pairing.events.on(V$2.create, (t) => this.onPairingCreated(t));
  }
}
let S$2 = class S2 extends H {
  constructor(t) {
    super(t), this.protocol = $, this.version = Q, this.name = B$1, this.events = new eventsExports.EventEmitter(), this.emit = (i3, n4) => this.events.emit(i3, n4), this.on = (i3, n4) => this.events.on(i3, n4), this.once = (i3, n4) => this.events.once(i3, n4), this.off = (i3, n4) => this.events.off(i3, n4), this.removeListener = (i3, n4) => this.events.removeListener(i3, n4), this.request = async (i3, n4) => {
      try {
        return await this.engine.request(i3, n4);
      } catch (s2) {
        throw this.logger.error(s2.message), s2;
      }
    }, this.respond = async (i3, n4) => {
      try {
        return await this.engine.respond(i3, n4);
      } catch (s2) {
        throw this.logger.error(s2.message), s2;
      }
    }, this.getPendingRequests = () => {
      try {
        return this.engine.getPendingRequests();
      } catch (i3) {
        throw this.logger.error(i3.message), i3;
      }
    }, this.formatMessage = (i3, n4) => {
      try {
        return this.engine.formatMessage(i3, n4);
      } catch (s2) {
        throw this.logger.error(s2.message), s2;
      }
    };
    const e2 = typeof t.logger < "u" && typeof t.logger != "string" ? t.logger : qt$3(k$2({ level: t.logger || "error" }));
    this.name = (t == null ? void 0 : t.name) || B$1, this.metadata = t.metadata, this.projectId = t.projectId, this.core = t.core || new bn(t), this.logger = E$1(e2, this.name), this.authKeys = new ni(this.core, this.logger, "authKeys", F$1, () => x$2), this.pairingTopics = new ni(this.core, this.logger, "pairingTopics", F$1), this.requests = new ni(this.core, this.logger, "requests", F$1, (i3) => i3.id), this.engine = new Br(this);
  }
  static async init(t) {
    const e2 = new S2(t);
    return await e2.initialize(), e2;
  }
  get context() {
    return y$3(this.logger);
  }
  async initialize() {
    this.logger.trace("Initialized");
    try {
      await this.core.start(), await this.authKeys.init(), await this.requests.init(), await this.pairingTopics.init(), await this.engine.init(), this.logger.info("AuthClient Initialization Success"), this.logger.info({ authClient: this });
    } catch (t) {
      throw this.logger.info("AuthClient Initialization Failure"), this.logger.error(t.message), t;
    }
  }
};
const zr = S$2;
let S$1 = class S3 {
  constructor(s2) {
    this.opts = s2, this.protocol = "wc", this.version = 2;
  }
};
class M {
  constructor(s2) {
    this.client = s2;
  }
}
const be = "wc", Ce = 2, Le = "client", ye = `${be}@${Ce}:${Le}:`, we = { name: Le, logger: "error", controller: false, relayUrl: "wss://relay.walletconnect.org" }, xe = "WALLETCONNECT_DEEPLINK_CHOICE", st = "proposal", it = "Proposal expired", rt = "session", z$1 = cjs$3.SEVEN_DAYS, nt = "engine", v$1 = { wc_sessionPropose: { req: { ttl: cjs$3.FIVE_MINUTES, prompt: true, tag: 1100 }, res: { ttl: cjs$3.FIVE_MINUTES, prompt: false, tag: 1101 }, reject: { ttl: cjs$3.FIVE_MINUTES, prompt: false, tag: 1120 }, autoReject: { ttl: cjs$3.FIVE_MINUTES, prompt: false, tag: 1121 } }, wc_sessionSettle: { req: { ttl: cjs$3.FIVE_MINUTES, prompt: false, tag: 1102 }, res: { ttl: cjs$3.FIVE_MINUTES, prompt: false, tag: 1103 } }, wc_sessionUpdate: { req: { ttl: cjs$3.ONE_DAY, prompt: false, tag: 1104 }, res: { ttl: cjs$3.ONE_DAY, prompt: false, tag: 1105 } }, wc_sessionExtend: { req: { ttl: cjs$3.ONE_DAY, prompt: false, tag: 1106 }, res: { ttl: cjs$3.ONE_DAY, prompt: false, tag: 1107 } }, wc_sessionRequest: { req: { ttl: cjs$3.FIVE_MINUTES, prompt: true, tag: 1108 }, res: { ttl: cjs$3.FIVE_MINUTES, prompt: false, tag: 1109 } }, wc_sessionEvent: { req: { ttl: cjs$3.FIVE_MINUTES, prompt: true, tag: 1110 }, res: { ttl: cjs$3.FIVE_MINUTES, prompt: false, tag: 1111 } }, wc_sessionDelete: { req: { ttl: cjs$3.ONE_DAY, prompt: false, tag: 1112 }, res: { ttl: cjs$3.ONE_DAY, prompt: false, tag: 1113 } }, wc_sessionPing: { req: { ttl: cjs$3.ONE_DAY, prompt: false, tag: 1114 }, res: { ttl: cjs$3.ONE_DAY, prompt: false, tag: 1115 } }, wc_sessionAuthenticate: { req: { ttl: cjs$3.ONE_HOUR, prompt: true, tag: 1116 }, res: { ttl: cjs$3.ONE_HOUR, prompt: false, tag: 1117 }, reject: { ttl: cjs$3.FIVE_MINUTES, prompt: false, tag: 1118 }, autoReject: { ttl: cjs$3.FIVE_MINUTES, prompt: false, tag: 1119 } } }, me = { min: cjs$3.FIVE_MINUTES, max: cjs$3.SEVEN_DAYS }, x$1 = { idle: "IDLE", active: "ACTIVE" }, ot = "request", at = ["wc_sessionPropose", "wc_sessionRequest", "wc_authRequest", "wc_sessionAuthenticate"], ct = "wc", lt2 = "auth", pt2 = "authKeys", ht = "pairingTopics", dt2 = "requests", oe = `${ct}@${1.5}:${lt2}:`, ae = `${oe}:PUB_KEY`;
var ys = Object.defineProperty, ws = Object.defineProperties, ms = Object.getOwnPropertyDescriptors, ut = Object.getOwnPropertySymbols, _s = Object.prototype.hasOwnProperty, Es = Object.prototype.propertyIsEnumerable, gt = (q2, o3, e2) => o3 in q2 ? ys(q2, o3, { enumerable: true, configurable: true, writable: true, value: e2 }) : q2[o3] = e2, I = (q2, o3) => {
  for (var e2 in o3 || (o3 = {})) _s.call(o3, e2) && gt(q2, e2, o3[e2]);
  if (ut) for (var e2 of ut(o3)) Es.call(o3, e2) && gt(q2, e2, o3[e2]);
  return q2;
}, D$1 = (q2, o3) => ws(q2, ms(o3));
class Rs extends M {
  constructor(o3) {
    super(o3), this.name = nt, this.events = new es(), this.initialized = false, this.requestQueue = { state: x$1.idle, queue: [] }, this.sessionRequestQueue = { state: x$1.idle, queue: [] }, this.requestQueueDelay = cjs$3.ONE_SECOND, this.expectedPairingMethodMap = /* @__PURE__ */ new Map(), this.recentlyDeletedMap = /* @__PURE__ */ new Map(), this.recentlyDeletedLimit = 200, this.relayMessageCache = [], this.init = async () => {
      this.initialized || (await this.cleanup(), this.registerRelayerEvents(), this.registerExpirerEvents(), this.registerPairingEvents(), await this.registerLinkModeListeners(), this.client.core.pairing.register({ methods: Object.keys(v$1) }), this.initialized = true, setTimeout(() => {
        this.sessionRequestQueue.queue = this.getPendingSessionRequests(), this.processSessionRequestQueue();
      }, cjs$3.toMiliseconds(this.requestQueueDelay)));
    }, this.connect = async (e2) => {
      this.isInitialized(), await this.confirmOnlineStateOrThrow();
      const t = D$1(I({}, e2), { requiredNamespaces: e2.requiredNamespaces || {}, optionalNamespaces: e2.optionalNamespaces || {} });
      await this.isValidConnect(t);
      const { pairingTopic: s2, requiredNamespaces: i3, optionalNamespaces: r2, sessionProperties: n4, relays: a3 } = t;
      let c2 = s2, h4, p3 = false;
      try {
        c2 && (p3 = this.client.core.pairing.pairings.get(c2).active);
      } catch (E2) {
        throw this.client.logger.error(`connect() -> pairing.get(${c2}) failed`), E2;
      }
      if (!c2 || !p3) {
        const { topic: E2, uri: S5 } = await this.client.core.pairing.create();
        c2 = E2, h4 = S5;
      }
      if (!c2) {
        const { message: E2 } = S$5("NO_MATCHING_KEY", `connect() pairing topic: ${c2}`);
        throw new Error(E2);
      }
      const d4 = await this.client.core.crypto.generateKeyPair(), l2 = v$1.wc_sessionPropose.req.ttl || cjs$3.FIVE_MINUTES, w2 = Mt$2(l2), m2 = I({ requiredNamespaces: i3, optionalNamespaces: r2, relays: a3 ?? [{ protocol: rt$2 }], proposer: { publicKey: d4, metadata: this.client.metadata }, expiryTimestamp: w2, pairingTopic: c2 }, n4 && { sessionProperties: n4 }), { reject: y3, resolve: _3, done: R3 } = _t$2(l2, it);
      this.events.once(Lt$2("session_connect"), async ({ error: E2, session: S5 }) => {
        if (E2) y3(E2);
        else if (S5) {
          S5.self.publicKey = d4;
          const M2 = D$1(I({}, S5), { pairingTopic: m2.pairingTopic, requiredNamespaces: m2.requiredNamespaces, optionalNamespaces: m2.optionalNamespaces, transportType: M$2.relay });
          await this.client.session.set(S5.topic, M2), await this.setExpiry(S5.topic, S5.expiry), c2 && await this.client.core.pairing.updateMetadata({ topic: c2, metadata: S5.peer.metadata }), this.cleanupDuplicatePairings(M2), _3(M2);
        }
      });
      const V2 = await this.sendRequest({ topic: c2, method: "wc_sessionPropose", params: m2, throwOnFailedPublish: true });
      return await this.setProposal(V2, I({ id: V2 }, m2)), { uri: h4, approval: R3 };
    }, this.pair = async (e2) => {
      this.isInitialized(), await this.confirmOnlineStateOrThrow();
      try {
        return await this.client.core.pairing.pair(e2);
      } catch (t) {
        throw this.client.logger.error("pair() failed"), t;
      }
    }, this.approve = async (e2) => {
      var t, s2, i3;
      const r2 = this.client.core.eventClient.createEvent({ properties: { topic: (t = e2 == null ? void 0 : e2.id) == null ? void 0 : t.toString(), trace: [Is$1.session_approve_started] } });
      try {
        this.isInitialized(), await this.confirmOnlineStateOrThrow();
      } catch (N2) {
        throw r2.setError(Ts$1.no_internet_connection), N2;
      }
      try {
        await this.isValidProposalId(e2 == null ? void 0 : e2.id);
      } catch (N2) {
        throw this.client.logger.error(`approve() -> proposal.get(${e2 == null ? void 0 : e2.id}) failed`), r2.setError(Ts$1.proposal_not_found), N2;
      }
      try {
        await this.isValidApprove(e2);
      } catch (N2) {
        throw this.client.logger.error("approve() -> isValidApprove() failed"), r2.setError(Ts$1.session_approve_namespace_validation_failure), N2;
      }
      const { id: n4, relayProtocol: a3, namespaces: c2, sessionProperties: h4, sessionConfig: p3 } = e2, d4 = this.client.proposal.get(n4);
      this.client.core.eventClient.deleteEvent({ eventId: r2.eventId });
      const { pairingTopic: l2, proposer: w2, requiredNamespaces: m2, optionalNamespaces: y3 } = d4;
      let _3 = (s2 = this.client.core.eventClient) == null ? void 0 : s2.getEvent({ topic: l2 });
      _3 || (_3 = (i3 = this.client.core.eventClient) == null ? void 0 : i3.createEvent({ type: Is$1.session_approve_started, properties: { topic: l2, trace: [Is$1.session_approve_started, Is$1.session_namespaces_validation_success] } }));
      const R3 = await this.client.core.crypto.generateKeyPair(), V2 = w2.publicKey, E2 = await this.client.core.crypto.generateSharedKey(R3, V2), S5 = I(I({ relay: { protocol: a3 ?? "irn" }, namespaces: c2, controller: { publicKey: R3, metadata: this.client.metadata }, expiry: Mt$2(z$1) }, h4 && { sessionProperties: h4 }), p3 && { sessionConfig: p3 }), M2 = M$2.relay;
      _3.addTrace(Is$1.subscribing_session_topic);
      try {
        await this.client.core.relayer.subscribe(E2, { transportType: M2 });
      } catch (N2) {
        throw _3.setError(Ts$1.subscribe_session_topic_failure), N2;
      }
      _3.addTrace(Is$1.subscribe_session_topic_success);
      const W2 = D$1(I({}, S5), { topic: E2, requiredNamespaces: m2, optionalNamespaces: y3, pairingTopic: l2, acknowledged: false, self: S5.controller, peer: { publicKey: w2.publicKey, metadata: w2.metadata }, controller: R3, transportType: M$2.relay });
      await this.client.session.set(E2, W2), _3.addTrace(Is$1.store_session);
      try {
        _3.addTrace(Is$1.publishing_session_settle), await this.sendRequest({ topic: E2, method: "wc_sessionSettle", params: S5, throwOnFailedPublish: true }).catch((N2) => {
          throw _3 == null ? void 0 : _3.setError(Ts$1.session_settle_publish_failure), N2;
        }), _3.addTrace(Is$1.session_settle_publish_success), _3.addTrace(Is$1.publishing_session_approve), await this.sendResult({ id: n4, topic: l2, result: { relay: { protocol: a3 ?? "irn" }, responderPublicKey: R3 }, throwOnFailedPublish: true }).catch((N2) => {
          throw _3 == null ? void 0 : _3.setError(Ts$1.session_approve_publish_failure), N2;
        }), _3.addTrace(Is$1.session_approve_publish_success);
      } catch (N2) {
        throw this.client.logger.error(N2), this.client.session.delete(E2, U$2("USER_DISCONNECTED")), await this.client.core.relayer.unsubscribe(E2), N2;
      }
      return this.client.core.eventClient.deleteEvent({ eventId: _3.eventId }), await this.client.core.pairing.updateMetadata({ topic: l2, metadata: w2.metadata }), await this.client.proposal.delete(n4, U$2("USER_DISCONNECTED")), await this.client.core.pairing.activate({ topic: l2 }), await this.setExpiry(E2, Mt$2(z$1)), { topic: E2, acknowledged: () => Promise.resolve(this.client.session.get(E2)) };
    }, this.reject = async (e2) => {
      this.isInitialized(), await this.confirmOnlineStateOrThrow();
      try {
        await this.isValidReject(e2);
      } catch (r2) {
        throw this.client.logger.error("reject() -> isValidReject() failed"), r2;
      }
      const { id: t, reason: s2 } = e2;
      let i3;
      try {
        i3 = this.client.proposal.get(t).pairingTopic;
      } catch (r2) {
        throw this.client.logger.error(`reject() -> proposal.get(${t}) failed`), r2;
      }
      i3 && (await this.sendError({ id: t, topic: i3, error: s2, rpcOpts: v$1.wc_sessionPropose.reject }), await this.client.proposal.delete(t, U$2("USER_DISCONNECTED")));
    }, this.update = async (e2) => {
      this.isInitialized(), await this.confirmOnlineStateOrThrow();
      try {
        await this.isValidUpdate(e2);
      } catch (p3) {
        throw this.client.logger.error("update() -> isValidUpdate() failed"), p3;
      }
      const { topic: t, namespaces: s2 } = e2, { done: i3, resolve: r2, reject: n4 } = _t$2(), a3 = payloadId(), c2 = getBigIntRpcId().toString(), h4 = this.client.session.get(t).namespaces;
      return this.events.once(Lt$2("session_update", a3), ({ error: p3 }) => {
        p3 ? n4(p3) : r2();
      }), await this.client.session.update(t, { namespaces: s2 }), await this.sendRequest({ topic: t, method: "wc_sessionUpdate", params: { namespaces: s2 }, throwOnFailedPublish: true, clientRpcId: a3, relayRpcId: c2 }).catch((p3) => {
        this.client.logger.error(p3), this.client.session.update(t, { namespaces: h4 }), n4(p3);
      }), { acknowledged: i3 };
    }, this.extend = async (e2) => {
      this.isInitialized(), await this.confirmOnlineStateOrThrow();
      try {
        await this.isValidExtend(e2);
      } catch (a3) {
        throw this.client.logger.error("extend() -> isValidExtend() failed"), a3;
      }
      const { topic: t } = e2, s2 = payloadId(), { done: i3, resolve: r2, reject: n4 } = _t$2();
      return this.events.once(Lt$2("session_extend", s2), ({ error: a3 }) => {
        a3 ? n4(a3) : r2();
      }), await this.setExpiry(t, Mt$2(z$1)), this.sendRequest({ topic: t, method: "wc_sessionExtend", params: {}, clientRpcId: s2, throwOnFailedPublish: true }).catch((a3) => {
        n4(a3);
      }), { acknowledged: i3 };
    }, this.request = async (e2) => {
      this.isInitialized();
      try {
        await this.isValidRequest(e2);
      } catch (w2) {
        throw this.client.logger.error("request() -> isValidRequest() failed"), w2;
      }
      const { chainId: t, request: s2, topic: i3, expiry: r2 = v$1.wc_sessionRequest.req.ttl } = e2, n4 = this.client.session.get(i3);
      (n4 == null ? void 0 : n4.transportType) === M$2.relay && await this.confirmOnlineStateOrThrow();
      const a3 = payloadId(), c2 = getBigIntRpcId().toString(), { done: h4, resolve: p3, reject: d4 } = _t$2(r2, "Request expired. Please try again.");
      this.events.once(Lt$2("session_request", a3), ({ error: w2, result: m2 }) => {
        w2 ? d4(w2) : p3(m2);
      });
      const l2 = this.getAppLinkIfEnabled(n4.peer.metadata, n4.transportType);
      return l2 ? (await this.sendRequest({ clientRpcId: a3, relayRpcId: c2, topic: i3, method: "wc_sessionRequest", params: { request: D$1(I({}, s2), { expiryTimestamp: Mt$2(r2) }), chainId: t }, expiry: r2, throwOnFailedPublish: true, appLink: l2 }).catch((w2) => d4(w2)), this.client.events.emit("session_request_sent", { topic: i3, request: s2, chainId: t, id: a3 }), await h4()) : await Promise.all([new Promise(async (w2) => {
        await this.sendRequest({ clientRpcId: a3, relayRpcId: c2, topic: i3, method: "wc_sessionRequest", params: { request: D$1(I({}, s2), { expiryTimestamp: Mt$2(r2) }), chainId: t }, expiry: r2, throwOnFailedPublish: true }).catch((m2) => d4(m2)), this.client.events.emit("session_request_sent", { topic: i3, request: s2, chainId: t, id: a3 }), w2();
      }), new Promise(async (w2) => {
        var m2;
        if (!((m2 = n4.sessionConfig) != null && m2.disableDeepLink)) {
          const y3 = await qt$2(this.client.core.storage, xe);
          await Ft$2({ id: a3, topic: i3, wcDeepLink: y3 });
        }
        w2();
      }), h4()]).then((w2) => w2[2]);
    }, this.respond = async (e2) => {
      this.isInitialized(), await this.isValidRespond(e2);
      const { topic: t, response: s2 } = e2, { id: i3 } = s2, r2 = this.client.session.get(t);
      r2.transportType === M$2.relay && await this.confirmOnlineStateOrThrow();
      const n4 = this.getAppLinkIfEnabled(r2.peer.metadata, r2.transportType);
      isJsonRpcResult(s2) ? await this.sendResult({ id: i3, topic: t, result: s2.result, throwOnFailedPublish: true, appLink: n4 }) : isJsonRpcError(s2) && await this.sendError({ id: i3, topic: t, error: s2.error, appLink: n4 }), this.cleanupAfterResponse(e2);
    }, this.ping = async (e2) => {
      this.isInitialized(), await this.confirmOnlineStateOrThrow();
      try {
        await this.isValidPing(e2);
      } catch (s2) {
        throw this.client.logger.error("ping() -> isValidPing() failed"), s2;
      }
      const { topic: t } = e2;
      if (this.client.session.keys.includes(t)) {
        const s2 = payloadId(), i3 = getBigIntRpcId().toString(), { done: r2, resolve: n4, reject: a3 } = _t$2();
        this.events.once(Lt$2("session_ping", s2), ({ error: c2 }) => {
          c2 ? a3(c2) : n4();
        }), await Promise.all([this.sendRequest({ topic: t, method: "wc_sessionPing", params: {}, throwOnFailedPublish: true, clientRpcId: s2, relayRpcId: i3 }), r2()]);
      } else this.client.core.pairing.pairings.keys.includes(t) && await this.client.core.pairing.ping({ topic: t });
    }, this.emit = async (e2) => {
      this.isInitialized(), await this.confirmOnlineStateOrThrow(), await this.isValidEmit(e2);
      const { topic: t, event: s2, chainId: i3 } = e2, r2 = getBigIntRpcId().toString();
      await this.sendRequest({ topic: t, method: "wc_sessionEvent", params: { event: s2, chainId: i3 }, throwOnFailedPublish: true, relayRpcId: r2 });
    }, this.disconnect = async (e2) => {
      this.isInitialized(), await this.confirmOnlineStateOrThrow(), await this.isValidDisconnect(e2);
      const { topic: t } = e2;
      if (this.client.session.keys.includes(t)) await this.sendRequest({ topic: t, method: "wc_sessionDelete", params: U$2("USER_DISCONNECTED"), throwOnFailedPublish: true }), await this.deleteSession({ topic: t, emitEvent: false });
      else if (this.client.core.pairing.pairings.keys.includes(t)) await this.client.core.pairing.disconnect({ topic: t });
      else {
        const { message: s2 } = S$5("MISMATCHED_TOPIC", `Session or pairing topic not found: ${t}`);
        throw new Error(s2);
      }
    }, this.find = (e2) => (this.isInitialized(), this.client.session.getAll().filter((t) => zr$2(t, e2))), this.getPendingSessionRequests = () => this.client.pendingRequest.getAll(), this.authenticate = async (e2, t) => {
      var s2;
      this.isInitialized(), this.isValidAuthenticate(e2);
      const i3 = t && this.client.core.linkModeSupportedApps.includes(t) && ((s2 = this.client.metadata.redirect) == null ? void 0 : s2.linkMode), r2 = i3 ? M$2.link_mode : M$2.relay;
      r2 === M$2.relay && await this.confirmOnlineStateOrThrow();
      const { chains: n4, statement: a3 = "", uri: c2, domain: h4, nonce: p3, type: d4, exp: l2, nbf: w2, methods: m2 = [], expiry: y3 } = e2, _3 = [...e2.resources || []], { topic: R3, uri: V2 } = await this.client.core.pairing.create({ methods: ["wc_sessionAuthenticate"], transportType: r2 });
      this.client.logger.info({ message: "Generated new pairing", pairing: { topic: R3, uri: V2 } });
      const E2 = await this.client.core.crypto.generateKeyPair(), S5 = hr$2(E2);
      if (await Promise.all([this.client.auth.authKeys.set(ae, { responseTopic: S5, publicKey: E2 }), this.client.auth.pairingTopics.set(S5, { topic: S5, pairingTopic: R3 })]), await this.client.core.relayer.subscribe(S5, { transportType: r2 }), this.client.logger.info(`sending request to new pairing topic: ${R3}`), m2.length > 0) {
        const { namespace: O3 } = re$2(n4[0]);
        let T2 = ir$2(O3, "request", m2);
        Y$2(_3) && (T2 = cr$2(T2, _3.pop())), _3.push(T2);
      }
      const M2 = y3 && y3 > v$1.wc_sessionAuthenticate.req.ttl ? y3 : v$1.wc_sessionAuthenticate.req.ttl, W2 = { authPayload: { type: d4 ?? "caip122", chains: n4, statement: a3, aud: c2, domain: h4, version: "1", nonce: p3, iat: (/* @__PURE__ */ new Date()).toISOString(), exp: l2, nbf: w2, resources: _3 }, requester: { publicKey: E2, metadata: this.client.metadata }, expiryTimestamp: Mt$2(M2) }, N2 = { eip155: { chains: n4, methods: [.../* @__PURE__ */ new Set(["personal_sign", ...m2])], events: ["chainChanged", "accountsChanged"] } }, De2 = { requiredNamespaces: {}, optionalNamespaces: N2, relays: [{ protocol: "irn" }], pairingTopic: R3, proposer: { publicKey: E2, metadata: this.client.metadata }, expiryTimestamp: Mt$2(v$1.wc_sessionPropose.req.ttl) }, { done: wt2, resolve: Ve, reject: Ee2 } = _t$2(M2, "Request expired"), ce2 = async ({ error: O3, session: T2 }) => {
        if (this.events.off(Lt$2("session_request", G2), Re2), O3) Ee2(O3);
        else if (T2) {
          T2.self.publicKey = E2, await this.client.session.set(T2.topic, T2), await this.setExpiry(T2.topic, T2.expiry), R3 && await this.client.core.pairing.updateMetadata({ topic: R3, metadata: T2.peer.metadata });
          const le2 = this.client.session.get(T2.topic);
          await this.deleteProposal(Z2), Ve({ session: le2 });
        }
      }, Re2 = async (O3) => {
        var T2, le2, Me;
        if (await this.deletePendingAuthRequest(G2, { message: "fulfilled", code: 0 }), O3.error) {
          const te2 = U$2("WC_METHOD_UNSUPPORTED", "wc_sessionAuthenticate");
          return O3.error.code === te2.code ? void 0 : (this.events.off(Lt$2("session_connect"), ce2), Ee2(O3.error.message));
        }
        await this.deleteProposal(Z2), this.events.off(Lt$2("session_connect"), ce2);
        const { cacaos: ke2, responder: j2 } = O3.result, Ie = [], $e2 = [];
        for (const te2 of ke2) {
          await nr$2({ cacao: te2, projectId: this.client.core.projectId }) || (this.client.logger.error(te2, "Signature verification failed"), Ee2(U$2("SESSION_SETTLEMENT_FAILED", "Signature verification failed")));
          const { p: fe2 } = te2, ve2 = Y$2(fe2.resources), Ke2 = [ln$1(fe2.iss)], mt2 = fe$2(fe2.iss);
          if (ve2) {
            const qe2 = ar$2(ve2), _t2 = ur$2(ve2);
            Ie.push(...qe2), Ke2.push(..._t2);
          }
          for (const qe2 of Ke2) $e2.push(`${qe2}:${mt2}`);
        }
        const ee2 = await this.client.core.crypto.generateSharedKey(E2, j2.publicKey);
        let pe2;
        Ie.length > 0 && (pe2 = { topic: ee2, acknowledged: true, self: { publicKey: E2, metadata: this.client.metadata }, peer: j2, controller: j2.publicKey, expiry: Mt$2(z$1), requiredNamespaces: {}, optionalNamespaces: {}, relay: { protocol: "irn" }, pairingTopic: R3, namespaces: Jr$1([...new Set(Ie)], [...new Set($e2)]), transportType: r2 }, await this.client.core.relayer.subscribe(ee2, { transportType: r2 }), await this.client.session.set(ee2, pe2), R3 && await this.client.core.pairing.updateMetadata({ topic: R3, metadata: j2.metadata }), pe2 = this.client.session.get(ee2)), (T2 = this.client.metadata.redirect) != null && T2.linkMode && (le2 = j2.metadata.redirect) != null && le2.linkMode && (Me = j2.metadata.redirect) != null && Me.universal && t && (this.client.core.addLinkModeSupportedApp(j2.metadata.redirect.universal), this.client.session.update(ee2, { transportType: M$2.link_mode })), Ve({ auths: ke2, session: pe2 });
      }, G2 = payloadId(), Z2 = payloadId();
      this.events.once(Lt$2("session_connect"), ce2), this.events.once(Lt$2("session_request", G2), Re2);
      let Se2;
      try {
        if (i3) {
          const O3 = formatJsonRpcRequest("wc_sessionAuthenticate", W2, G2);
          this.client.core.history.set(R3, O3);
          const T2 = await this.client.core.crypto.encode("", O3, { type: M$3, encoding: lr$2 });
          Se2 = xr$2(t, R3, T2);
        } else await Promise.all([this.sendRequest({ topic: R3, method: "wc_sessionAuthenticate", params: W2, expiry: e2.expiry, throwOnFailedPublish: true, clientRpcId: G2 }), this.sendRequest({ topic: R3, method: "wc_sessionPropose", params: De2, expiry: v$1.wc_sessionPropose.req.ttl, throwOnFailedPublish: true, clientRpcId: Z2 })]);
      } catch (O3) {
        throw this.events.off(Lt$2("session_connect"), ce2), this.events.off(Lt$2("session_request", G2), Re2), O3;
      }
      return await this.setProposal(Z2, I({ id: Z2 }, De2)), await this.setAuthRequest(G2, { request: D$1(I({}, W2), { verifyContext: {} }), pairingTopic: R3, transportType: r2 }), { uri: Se2 ?? V2, response: wt2 };
    }, this.approveSessionAuthenticate = async (e2) => {
      const { id: t, auths: s2 } = e2, i3 = this.client.core.eventClient.createEvent({ properties: { topic: t.toString(), trace: [Cs.authenticated_session_approve_started] } });
      try {
        this.isInitialized();
      } catch (y3) {
        throw i3.setError(Ps$1.no_internet_connection), y3;
      }
      const r2 = this.getPendingAuthRequest(t);
      if (!r2) throw i3.setError(Ps$1.authenticated_session_pending_request_not_found), new Error(`Could not find pending auth request with id ${t}`);
      const n4 = r2.transportType || M$2.relay;
      n4 === M$2.relay && await this.confirmOnlineStateOrThrow();
      const a3 = r2.requester.publicKey, c2 = await this.client.core.crypto.generateKeyPair(), h4 = hr$2(a3), p3 = { type: D$2, receiverPublicKey: a3, senderPublicKey: c2 }, d4 = [], l2 = [];
      for (const y3 of s2) {
        if (!await nr$2({ cacao: y3, projectId: this.client.core.projectId })) {
          i3.setError(Ps$1.invalid_cacao);
          const S5 = U$2("SESSION_SETTLEMENT_FAILED", "Signature verification failed");
          throw await this.sendError({ id: t, topic: h4, error: S5, encodeOpts: p3 }), new Error(S5.message);
        }
        i3.addTrace(Cs.cacaos_verified);
        const { p: _3 } = y3, R3 = Y$2(_3.resources), V2 = [ln$1(_3.iss)], E2 = fe$2(_3.iss);
        if (R3) {
          const S5 = ar$2(R3), M2 = ur$2(R3);
          d4.push(...S5), V2.push(...M2);
        }
        for (const S5 of V2) l2.push(`${S5}:${E2}`);
      }
      const w2 = await this.client.core.crypto.generateSharedKey(c2, a3);
      i3.addTrace(Cs.create_authenticated_session_topic);
      let m2;
      if ((d4 == null ? void 0 : d4.length) > 0) {
        m2 = { topic: w2, acknowledged: true, self: { publicKey: c2, metadata: this.client.metadata }, peer: { publicKey: a3, metadata: r2.requester.metadata }, controller: a3, expiry: Mt$2(z$1), authentication: s2, requiredNamespaces: {}, optionalNamespaces: {}, relay: { protocol: "irn" }, pairingTopic: r2.pairingTopic, namespaces: Jr$1([...new Set(d4)], [...new Set(l2)]), transportType: n4 }, i3.addTrace(Cs.subscribing_authenticated_session_topic);
        try {
          await this.client.core.relayer.subscribe(w2, { transportType: n4 });
        } catch (y3) {
          throw i3.setError(Ps$1.subscribe_authenticated_session_topic_failure), y3;
        }
        i3.addTrace(Cs.subscribe_authenticated_session_topic_success), await this.client.session.set(w2, m2), i3.addTrace(Cs.store_authenticated_session), await this.client.core.pairing.updateMetadata({ topic: r2.pairingTopic, metadata: r2.requester.metadata });
      }
      i3.addTrace(Cs.publishing_authenticated_session_approve);
      try {
        await this.sendResult({ topic: h4, id: t, result: { cacaos: s2, responder: { publicKey: c2, metadata: this.client.metadata } }, encodeOpts: p3, throwOnFailedPublish: true, appLink: this.getAppLinkIfEnabled(r2.requester.metadata, n4) });
      } catch (y3) {
        throw i3.setError(Ps$1.authenticated_session_approve_publish_failure), y3;
      }
      return await this.client.auth.requests.delete(t, { message: "fulfilled", code: 0 }), await this.client.core.pairing.activate({ topic: r2.pairingTopic }), this.client.core.eventClient.deleteEvent({ eventId: i3.eventId }), { session: m2 };
    }, this.rejectSessionAuthenticate = async (e2) => {
      this.isInitialized();
      const { id: t, reason: s2 } = e2, i3 = this.getPendingAuthRequest(t);
      if (!i3) throw new Error(`Could not find pending auth request with id ${t}`);
      i3.transportType === M$2.relay && await this.confirmOnlineStateOrThrow();
      const r2 = i3.requester.publicKey, n4 = await this.client.core.crypto.generateKeyPair(), a3 = hr$2(r2), c2 = { type: D$2, receiverPublicKey: r2, senderPublicKey: n4 };
      await this.sendError({ id: t, topic: a3, error: s2, encodeOpts: c2, rpcOpts: v$1.wc_sessionAuthenticate.reject, appLink: this.getAppLinkIfEnabled(i3.requester.metadata, i3.transportType) }), await this.client.auth.requests.delete(t, { message: "rejected", code: 0 }), await this.client.proposal.delete(t, U$2("USER_DISCONNECTED"));
    }, this.formatAuthMessage = (e2) => {
      this.isInitialized();
      const { request: t, iss: s2 } = e2;
      return dn$1(t, s2);
    }, this.processRelayMessageCache = () => {
      setTimeout(async () => {
        if (this.relayMessageCache.length !== 0) for (; this.relayMessageCache.length > 0; ) try {
          const e2 = this.relayMessageCache.shift();
          e2 && await this.onRelayMessage(e2);
        } catch (e2) {
          this.client.logger.error(e2);
        }
      }, 50);
    }, this.cleanupDuplicatePairings = async (e2) => {
      if (e2.pairingTopic) try {
        const t = this.client.core.pairing.pairings.get(e2.pairingTopic), s2 = this.client.core.pairing.pairings.getAll().filter((i3) => {
          var r2, n4;
          return ((r2 = i3.peerMetadata) == null ? void 0 : r2.url) && ((n4 = i3.peerMetadata) == null ? void 0 : n4.url) === e2.peer.metadata.url && i3.topic && i3.topic !== t.topic;
        });
        if (s2.length === 0) return;
        this.client.logger.info(`Cleaning up ${s2.length} duplicate pairing(s)`), await Promise.all(s2.map((i3) => this.client.core.pairing.disconnect({ topic: i3.topic }))), this.client.logger.info("Duplicate pairings clean up finished");
      } catch (t) {
        this.client.logger.error(t);
      }
    }, this.deleteSession = async (e2) => {
      var t;
      const { topic: s2, expirerHasDeleted: i3 = false, emitEvent: r2 = true, id: n4 = 0 } = e2, { self: a3 } = this.client.session.get(s2);
      await this.client.core.relayer.unsubscribe(s2), await this.client.session.delete(s2, U$2("USER_DISCONNECTED")), this.addToRecentlyDeleted(s2, "session"), this.client.core.crypto.keychain.has(a3.publicKey) && await this.client.core.crypto.deleteKeyPair(a3.publicKey), this.client.core.crypto.keychain.has(s2) && await this.client.core.crypto.deleteSymKey(s2), i3 || this.client.core.expirer.del(s2), this.client.core.storage.removeItem(xe).catch((c2) => this.client.logger.warn(c2)), this.getPendingSessionRequests().forEach((c2) => {
        c2.topic === s2 && this.deletePendingSessionRequest(c2.id, U$2("USER_DISCONNECTED"));
      }), s2 === ((t = this.sessionRequestQueue.queue[0]) == null ? void 0 : t.topic) && (this.sessionRequestQueue.state = x$1.idle), r2 && this.client.events.emit("session_delete", { id: n4, topic: s2 });
    }, this.deleteProposal = async (e2, t) => {
      if (t) try {
        const s2 = this.client.proposal.get(e2), i3 = this.client.core.eventClient.getEvent({ topic: s2.pairingTopic });
        i3 == null ? void 0 : i3.setError(Ts$1.proposal_expired);
      } catch {
      }
      await Promise.all([this.client.proposal.delete(e2, U$2("USER_DISCONNECTED")), t ? Promise.resolve() : this.client.core.expirer.del(e2)]), this.addToRecentlyDeleted(e2, "proposal");
    }, this.deletePendingSessionRequest = async (e2, t, s2 = false) => {
      await Promise.all([this.client.pendingRequest.delete(e2, t), s2 ? Promise.resolve() : this.client.core.expirer.del(e2)]), this.addToRecentlyDeleted(e2, "request"), this.sessionRequestQueue.queue = this.sessionRequestQueue.queue.filter((i3) => i3.id !== e2), s2 && (this.sessionRequestQueue.state = x$1.idle, this.client.events.emit("session_request_expire", { id: e2 }));
    }, this.deletePendingAuthRequest = async (e2, t, s2 = false) => {
      await Promise.all([this.client.auth.requests.delete(e2, t), s2 ? Promise.resolve() : this.client.core.expirer.del(e2)]);
    }, this.setExpiry = async (e2, t) => {
      this.client.session.keys.includes(e2) && (this.client.core.expirer.set(e2, t), await this.client.session.update(e2, { expiry: t }));
    }, this.setProposal = async (e2, t) => {
      this.client.core.expirer.set(e2, Mt$2(v$1.wc_sessionPropose.req.ttl)), await this.client.proposal.set(e2, t);
    }, this.setAuthRequest = async (e2, t) => {
      const { request: s2, pairingTopic: i3, transportType: r2 = M$2.relay } = t;
      this.client.core.expirer.set(e2, s2.expiryTimestamp), await this.client.auth.requests.set(e2, { authPayload: s2.authPayload, requester: s2.requester, expiryTimestamp: s2.expiryTimestamp, id: e2, pairingTopic: i3, verifyContext: s2.verifyContext, transportType: r2 });
    }, this.setPendingSessionRequest = async (e2) => {
      const { id: t, topic: s2, params: i3, verifyContext: r2 } = e2, n4 = i3.request.expiryTimestamp || Mt$2(v$1.wc_sessionRequest.req.ttl);
      this.client.core.expirer.set(t, n4), await this.client.pendingRequest.set(t, { id: t, topic: s2, params: i3, verifyContext: r2 });
    }, this.sendRequest = async (e2) => {
      const { topic: t, method: s2, params: i3, expiry: r2, relayRpcId: n4, clientRpcId: a3, throwOnFailedPublish: c2, appLink: h4 } = e2, p3 = formatJsonRpcRequest(s2, i3, a3);
      let d4;
      const l2 = !!h4;
      try {
        const y3 = l2 ? lr$2 : ge$1;
        d4 = await this.client.core.crypto.encode(t, p3, { encoding: y3 });
      } catch (y3) {
        throw await this.cleanup(), this.client.logger.error(`sendRequest() -> core.crypto.encode() for topic ${t} failed`), y3;
      }
      let w2;
      if (at.includes(s2)) {
        const y3 = yr$2(JSON.stringify(p3)), _3 = yr$2(d4);
        w2 = await this.client.core.verify.register({ id: _3, decryptedId: y3 });
      }
      const m2 = v$1[s2].req;
      if (m2.attestation = w2, r2 && (m2.ttl = r2), n4 && (m2.id = n4), this.client.core.history.set(t, p3), l2) {
        const y3 = xr$2(h4, t, d4);
        await global.Linking.openURL(y3, this.client.name);
      } else {
        const y3 = v$1[s2].req;
        r2 && (y3.ttl = r2), n4 && (y3.id = n4), c2 ? (y3.internal = D$1(I({}, y3.internal), { throwOnFailedPublish: true }), await this.client.core.relayer.publish(t, d4, y3)) : this.client.core.relayer.publish(t, d4, y3).catch((_3) => this.client.logger.error(_3));
      }
      return p3.id;
    }, this.sendResult = async (e2) => {
      const { id: t, topic: s2, result: i3, throwOnFailedPublish: r2, encodeOpts: n4, appLink: a3 } = e2, c2 = formatJsonRpcResult(t, i3);
      let h4;
      const p3 = a3 && typeof (global == null ? void 0 : global.Linking) < "u";
      try {
        const l2 = p3 ? lr$2 : ge$1;
        h4 = await this.client.core.crypto.encode(s2, c2, D$1(I({}, n4 || {}), { encoding: l2 }));
      } catch (l2) {
        throw await this.cleanup(), this.client.logger.error(`sendResult() -> core.crypto.encode() for topic ${s2} failed`), l2;
      }
      let d4;
      try {
        d4 = await this.client.core.history.get(s2, t);
      } catch (l2) {
        throw this.client.logger.error(`sendResult() -> history.get(${s2}, ${t}) failed`), l2;
      }
      if (p3) {
        const l2 = xr$2(a3, s2, h4);
        await global.Linking.openURL(l2, this.client.name);
      } else {
        const l2 = v$1[d4.request.method].res;
        r2 ? (l2.internal = D$1(I({}, l2.internal), { throwOnFailedPublish: true }), await this.client.core.relayer.publish(s2, h4, l2)) : this.client.core.relayer.publish(s2, h4, l2).catch((w2) => this.client.logger.error(w2));
      }
      await this.client.core.history.resolve(c2);
    }, this.sendError = async (e2) => {
      const { id: t, topic: s2, error: i3, encodeOpts: r2, rpcOpts: n4, appLink: a3 } = e2, c2 = formatJsonRpcError(t, i3);
      let h4;
      const p3 = a3 && typeof (global == null ? void 0 : global.Linking) < "u";
      try {
        const l2 = p3 ? lr$2 : ge$1;
        h4 = await this.client.core.crypto.encode(s2, c2, D$1(I({}, r2 || {}), { encoding: l2 }));
      } catch (l2) {
        throw await this.cleanup(), this.client.logger.error(`sendError() -> core.crypto.encode() for topic ${s2} failed`), l2;
      }
      let d4;
      try {
        d4 = await this.client.core.history.get(s2, t);
      } catch (l2) {
        throw this.client.logger.error(`sendError() -> history.get(${s2}, ${t}) failed`), l2;
      }
      if (p3) {
        const l2 = xr$2(a3, s2, h4);
        await global.Linking.openURL(l2, this.client.name);
      } else {
        const l2 = n4 || v$1[d4.request.method].res;
        this.client.core.relayer.publish(s2, h4, l2);
      }
      await this.client.core.history.resolve(c2);
    }, this.cleanup = async () => {
      const e2 = [], t = [];
      this.client.session.getAll().forEach((s2) => {
        let i3 = false;
        Kt$2(s2.expiry) && (i3 = true), this.client.core.crypto.keychain.has(s2.topic) || (i3 = true), i3 && e2.push(s2.topic);
      }), this.client.proposal.getAll().forEach((s2) => {
        Kt$2(s2.expiryTimestamp) && t.push(s2.id);
      }), await Promise.all([...e2.map((s2) => this.deleteSession({ topic: s2 })), ...t.map((s2) => this.deleteProposal(s2))]);
    }, this.onRelayEventRequest = async (e2) => {
      this.requestQueue.queue.push(e2), await this.processRequestsQueue();
    }, this.processRequestsQueue = async () => {
      if (this.requestQueue.state === x$1.active) {
        this.client.logger.info("Request queue already active, skipping...");
        return;
      }
      for (this.client.logger.info(`Request queue starting with ${this.requestQueue.queue.length} requests`); this.requestQueue.queue.length > 0; ) {
        this.requestQueue.state = x$1.active;
        const e2 = this.requestQueue.queue.shift();
        if (e2) try {
          await this.processRequest(e2);
        } catch (t) {
          this.client.logger.warn(t);
        }
      }
      this.requestQueue.state = x$1.idle;
    }, this.processRequest = async (e2) => {
      const { topic: t, payload: s2, attestation: i3, transportType: r2, encryptedId: n4 } = e2, a3 = s2.method;
      if (!this.shouldIgnorePairingRequest({ topic: t, requestMethod: a3 })) switch (a3) {
        case "wc_sessionPropose":
          return await this.onSessionProposeRequest({ topic: t, payload: s2, attestation: i3, encryptedId: n4 });
        case "wc_sessionSettle":
          return await this.onSessionSettleRequest(t, s2);
        case "wc_sessionUpdate":
          return await this.onSessionUpdateRequest(t, s2);
        case "wc_sessionExtend":
          return await this.onSessionExtendRequest(t, s2);
        case "wc_sessionPing":
          return await this.onSessionPingRequest(t, s2);
        case "wc_sessionDelete":
          return await this.onSessionDeleteRequest(t, s2);
        case "wc_sessionRequest":
          return await this.onSessionRequest({ topic: t, payload: s2, attestation: i3, encryptedId: n4, transportType: r2 });
        case "wc_sessionEvent":
          return await this.onSessionEventRequest(t, s2);
        case "wc_sessionAuthenticate":
          return await this.onSessionAuthenticateRequest({ topic: t, payload: s2, attestation: i3, encryptedId: n4, transportType: r2 });
        default:
          return this.client.logger.info(`Unsupported request method ${a3}`);
      }
    }, this.onRelayEventResponse = async (e2) => {
      const { topic: t, payload: s2, transportType: i3 } = e2, r2 = (await this.client.core.history.get(t, s2.id)).request.method;
      switch (r2) {
        case "wc_sessionPropose":
          return this.onSessionProposeResponse(t, s2, i3);
        case "wc_sessionSettle":
          return this.onSessionSettleResponse(t, s2);
        case "wc_sessionUpdate":
          return this.onSessionUpdateResponse(t, s2);
        case "wc_sessionExtend":
          return this.onSessionExtendResponse(t, s2);
        case "wc_sessionPing":
          return this.onSessionPingResponse(t, s2);
        case "wc_sessionRequest":
          return this.onSessionRequestResponse(t, s2);
        case "wc_sessionAuthenticate":
          return this.onSessionAuthenticateResponse(t, s2);
        default:
          return this.client.logger.info(`Unsupported response method ${r2}`);
      }
    }, this.onRelayEventUnknownPayload = (e2) => {
      const { topic: t } = e2, { message: s2 } = S$5("MISSING_OR_INVALID", `Decoded payload on topic ${t} is not identifiable as a JSON-RPC request or a response.`);
      throw new Error(s2);
    }, this.shouldIgnorePairingRequest = (e2) => {
      const { topic: t, requestMethod: s2 } = e2, i3 = this.expectedPairingMethodMap.get(t);
      return !i3 || i3.includes(s2) ? false : !!(i3.includes("wc_sessionAuthenticate") && this.client.events.listenerCount("session_authenticate") > 0);
    }, this.onSessionProposeRequest = async (e2) => {
      const { topic: t, payload: s2, attestation: i3, encryptedId: r2 } = e2, { params: n4, id: a3 } = s2;
      try {
        const c2 = this.client.core.eventClient.getEvent({ topic: t });
        this.isValidConnect(I({}, s2.params));
        const h4 = n4.expiryTimestamp || Mt$2(v$1.wc_sessionPropose.req.ttl), p3 = I({ id: a3, pairingTopic: t, expiryTimestamp: h4 }, n4);
        await this.setProposal(a3, p3);
        const d4 = await this.getVerifyContext({ attestationId: i3, hash: yr$2(JSON.stringify(s2)), encryptedId: r2, metadata: p3.proposer.metadata });
        this.client.events.listenerCount("session_proposal") === 0 && (console.warn("No listener for session_proposal event"), c2 == null ? void 0 : c2.setError($$1.proposal_listener_not_found)), c2 == null ? void 0 : c2.addTrace(z$3.emit_session_proposal), this.client.events.emit("session_proposal", { id: a3, params: p3, verifyContext: d4 });
      } catch (c2) {
        await this.sendError({ id: a3, topic: t, error: c2, rpcOpts: v$1.wc_sessionPropose.autoReject }), this.client.logger.error(c2);
      }
    }, this.onSessionProposeResponse = async (e2, t, s2) => {
      const { id: i3 } = t;
      if (isJsonRpcResult(t)) {
        const { result: r2 } = t;
        this.client.logger.trace({ type: "method", method: "onSessionProposeResponse", result: r2 });
        const n4 = this.client.proposal.get(i3);
        this.client.logger.trace({ type: "method", method: "onSessionProposeResponse", proposal: n4 });
        const a3 = n4.proposer.publicKey;
        this.client.logger.trace({ type: "method", method: "onSessionProposeResponse", selfPublicKey: a3 });
        const c2 = r2.responderPublicKey;
        this.client.logger.trace({ type: "method", method: "onSessionProposeResponse", peerPublicKey: c2 });
        const h4 = await this.client.core.crypto.generateSharedKey(a3, c2);
        this.client.logger.trace({ type: "method", method: "onSessionProposeResponse", sessionTopic: h4 });
        const p3 = await this.client.core.relayer.subscribe(h4, { transportType: s2 });
        this.client.logger.trace({ type: "method", method: "onSessionProposeResponse", subscriptionId: p3 }), await this.client.core.pairing.activate({ topic: e2 });
      } else if (isJsonRpcError(t)) {
        await this.client.proposal.delete(i3, U$2("USER_DISCONNECTED"));
        const r2 = Lt$2("session_connect");
        if (this.events.listenerCount(r2) === 0) throw new Error(`emitting ${r2} without any listeners, 954`);
        this.events.emit(Lt$2("session_connect"), { error: t.error });
      }
    }, this.onSessionSettleRequest = async (e2, t) => {
      const { id: s2, params: i3 } = t;
      try {
        this.isValidSessionSettleRequest(i3);
        const { relay: r2, controller: n4, expiry: a3, namespaces: c2, sessionProperties: h4, sessionConfig: p3 } = t.params, d4 = D$1(I(I({ topic: e2, relay: r2, expiry: a3, namespaces: c2, acknowledged: true, pairingTopic: "", requiredNamespaces: {}, optionalNamespaces: {}, controller: n4.publicKey, self: { publicKey: "", metadata: this.client.metadata }, peer: { publicKey: n4.publicKey, metadata: n4.metadata } }, h4 && { sessionProperties: h4 }), p3 && { sessionConfig: p3 }), { transportType: M$2.relay }), l2 = Lt$2("session_connect");
        if (this.events.listenerCount(l2) === 0) throw new Error(`emitting ${l2} without any listeners 997`);
        this.events.emit(Lt$2("session_connect"), { session: d4 }), await this.sendResult({ id: t.id, topic: e2, result: true, throwOnFailedPublish: true });
      } catch (r2) {
        await this.sendError({ id: s2, topic: e2, error: r2 }), this.client.logger.error(r2);
      }
    }, this.onSessionSettleResponse = async (e2, t) => {
      const { id: s2 } = t;
      isJsonRpcResult(t) ? (await this.client.session.update(e2, { acknowledged: true }), this.events.emit(Lt$2("session_approve", s2), {})) : isJsonRpcError(t) && (await this.client.session.delete(e2, U$2("USER_DISCONNECTED")), this.events.emit(Lt$2("session_approve", s2), { error: t.error }));
    }, this.onSessionUpdateRequest = async (e2, t) => {
      const { params: s2, id: i3 } = t;
      try {
        const r2 = `${e2}_session_update`, n4 = yo.get(r2);
        if (n4 && this.isRequestOutOfSync(n4, i3)) {
          this.client.logger.info(`Discarding out of sync request - ${i3}`), this.sendError({ id: i3, topic: e2, error: U$2("INVALID_UPDATE_REQUEST") });
          return;
        }
        this.isValidUpdate(I({ topic: e2 }, s2));
        try {
          yo.set(r2, i3), await this.client.session.update(e2, { namespaces: s2.namespaces }), await this.sendResult({ id: i3, topic: e2, result: true, throwOnFailedPublish: true });
        } catch (a3) {
          throw yo.delete(r2), a3;
        }
        this.client.events.emit("session_update", { id: i3, topic: e2, params: s2 });
      } catch (r2) {
        await this.sendError({ id: i3, topic: e2, error: r2 }), this.client.logger.error(r2);
      }
    }, this.isRequestOutOfSync = (e2, t) => parseInt(t.toString().slice(0, -3)) <= parseInt(e2.toString().slice(0, -3)), this.onSessionUpdateResponse = (e2, t) => {
      const { id: s2 } = t, i3 = Lt$2("session_update", s2);
      if (this.events.listenerCount(i3) === 0) throw new Error(`emitting ${i3} without any listeners`);
      isJsonRpcResult(t) ? this.events.emit(Lt$2("session_update", s2), {}) : isJsonRpcError(t) && this.events.emit(Lt$2("session_update", s2), { error: t.error });
    }, this.onSessionExtendRequest = async (e2, t) => {
      const { id: s2 } = t;
      try {
        this.isValidExtend({ topic: e2 }), await this.setExpiry(e2, Mt$2(z$1)), await this.sendResult({ id: s2, topic: e2, result: true, throwOnFailedPublish: true }), this.client.events.emit("session_extend", { id: s2, topic: e2 });
      } catch (i3) {
        await this.sendError({ id: s2, topic: e2, error: i3 }), this.client.logger.error(i3);
      }
    }, this.onSessionExtendResponse = (e2, t) => {
      const { id: s2 } = t, i3 = Lt$2("session_extend", s2);
      if (this.events.listenerCount(i3) === 0) throw new Error(`emitting ${i3} without any listeners`);
      isJsonRpcResult(t) ? this.events.emit(Lt$2("session_extend", s2), {}) : isJsonRpcError(t) && this.events.emit(Lt$2("session_extend", s2), { error: t.error });
    }, this.onSessionPingRequest = async (e2, t) => {
      const { id: s2 } = t;
      try {
        this.isValidPing({ topic: e2 }), await this.sendResult({ id: s2, topic: e2, result: true, throwOnFailedPublish: true }), this.client.events.emit("session_ping", { id: s2, topic: e2 });
      } catch (i3) {
        await this.sendError({ id: s2, topic: e2, error: i3 }), this.client.logger.error(i3);
      }
    }, this.onSessionPingResponse = (e2, t) => {
      const { id: s2 } = t, i3 = Lt$2("session_ping", s2);
      if (this.events.listenerCount(i3) === 0) throw new Error(`emitting ${i3} without any listeners`);
      setTimeout(() => {
        isJsonRpcResult(t) ? this.events.emit(Lt$2("session_ping", s2), {}) : isJsonRpcError(t) && this.events.emit(Lt$2("session_ping", s2), { error: t.error });
      }, 500);
    }, this.onSessionDeleteRequest = async (e2, t) => {
      const { id: s2 } = t;
      try {
        this.isValidDisconnect({ topic: e2, reason: t.params }), Promise.all([new Promise((i3) => {
          this.client.core.relayer.once(v$2.publish, async () => {
            i3(await this.deleteSession({ topic: e2, id: s2 }));
          });
        }), this.sendResult({ id: s2, topic: e2, result: true, throwOnFailedPublish: true }), this.cleanupPendingSentRequestsForTopic({ topic: e2, error: U$2("USER_DISCONNECTED") })]).catch((i3) => this.client.logger.error(i3));
      } catch (i3) {
        this.client.logger.error(i3);
      }
    }, this.onSessionRequest = async (e2) => {
      var t, s2, i3;
      const { topic: r2, payload: n4, attestation: a3, encryptedId: c2, transportType: h4 } = e2, { id: p3, params: d4 } = n4;
      try {
        await this.isValidRequest(I({ topic: r2 }, d4));
        const l2 = this.client.session.get(r2), w2 = await this.getVerifyContext({ attestationId: a3, hash: yr$2(JSON.stringify(formatJsonRpcRequest("wc_sessionRequest", d4, p3))), encryptedId: c2, metadata: l2.peer.metadata, transportType: h4 }), m2 = { id: p3, topic: r2, params: d4, verifyContext: w2 };
        await this.setPendingSessionRequest(m2), h4 === M$2.link_mode && (t = l2.peer.metadata.redirect) != null && t.universal && this.client.core.addLinkModeSupportedApp((s2 = l2.peer.metadata.redirect) == null ? void 0 : s2.universal), (i3 = this.client.signConfig) != null && i3.disableRequestQueue ? this.emitSessionRequest(m2) : (this.addSessionRequestToSessionRequestQueue(m2), this.processSessionRequestQueue());
      } catch (l2) {
        await this.sendError({ id: p3, topic: r2, error: l2 }), this.client.logger.error(l2);
      }
    }, this.onSessionRequestResponse = (e2, t) => {
      const { id: s2 } = t, i3 = Lt$2("session_request", s2);
      if (this.events.listenerCount(i3) === 0) throw new Error(`emitting ${i3} without any listeners`);
      isJsonRpcResult(t) ? this.events.emit(Lt$2("session_request", s2), { result: t.result }) : isJsonRpcError(t) && this.events.emit(Lt$2("session_request", s2), { error: t.error });
    }, this.onSessionEventRequest = async (e2, t) => {
      const { id: s2, params: i3 } = t;
      try {
        const r2 = `${e2}_session_event_${i3.event.name}`, n4 = yo.get(r2);
        if (n4 && this.isRequestOutOfSync(n4, s2)) {
          this.client.logger.info(`Discarding out of sync request - ${s2}`);
          return;
        }
        this.isValidEmit(I({ topic: e2 }, i3)), this.client.events.emit("session_event", { id: s2, topic: e2, params: i3 }), yo.set(r2, s2);
      } catch (r2) {
        await this.sendError({ id: s2, topic: e2, error: r2 }), this.client.logger.error(r2);
      }
    }, this.onSessionAuthenticateResponse = (e2, t) => {
      const { id: s2 } = t;
      this.client.logger.trace({ type: "method", method: "onSessionAuthenticateResponse", topic: e2, payload: t }), isJsonRpcResult(t) ? this.events.emit(Lt$2("session_request", s2), { result: t.result }) : isJsonRpcError(t) && this.events.emit(Lt$2("session_request", s2), { error: t.error });
    }, this.onSessionAuthenticateRequest = async (e2) => {
      var t;
      const { topic: s2, payload: i3, attestation: r2, encryptedId: n4, transportType: a3 } = e2;
      try {
        const { requester: c2, authPayload: h4, expiryTimestamp: p3 } = i3.params, d4 = await this.getVerifyContext({ attestationId: r2, hash: yr$2(JSON.stringify(i3)), encryptedId: n4, metadata: c2.metadata, transportType: a3 }), l2 = { requester: c2, pairingTopic: s2, id: i3.id, authPayload: h4, verifyContext: d4, expiryTimestamp: p3 };
        await this.setAuthRequest(i3.id, { request: l2, pairingTopic: s2, transportType: a3 }), a3 === M$2.link_mode && (t = c2.metadata.redirect) != null && t.universal && this.client.core.addLinkModeSupportedApp(c2.metadata.redirect.universal), this.client.events.emit("session_authenticate", { topic: s2, params: i3.params, id: i3.id, verifyContext: d4 });
      } catch (c2) {
        this.client.logger.error(c2);
        const h4 = i3.params.requester.publicKey, p3 = await this.client.core.crypto.generateKeyPair(), d4 = this.getAppLinkIfEnabled(i3.params.requester.metadata, a3), l2 = { type: D$2, receiverPublicKey: h4, senderPublicKey: p3 };
        await this.sendError({ id: i3.id, topic: s2, error: c2, encodeOpts: l2, rpcOpts: v$1.wc_sessionAuthenticate.autoReject, appLink: d4 });
      }
    }, this.addSessionRequestToSessionRequestQueue = (e2) => {
      this.sessionRequestQueue.queue.push(e2);
    }, this.cleanupAfterResponse = (e2) => {
      this.deletePendingSessionRequest(e2.response.id, { message: "fulfilled", code: 0 }), setTimeout(() => {
        this.sessionRequestQueue.state = x$1.idle, this.processSessionRequestQueue();
      }, cjs$3.toMiliseconds(this.requestQueueDelay));
    }, this.cleanupPendingSentRequestsForTopic = ({ topic: e2, error: t }) => {
      const s2 = this.client.core.history.pending;
      s2.length > 0 && s2.filter((i3) => i3.topic === e2 && i3.request.method === "wc_sessionRequest").forEach((i3) => {
        const r2 = i3.request.id, n4 = Lt$2("session_request", r2);
        if (this.events.listenerCount(n4) === 0) throw new Error(`emitting ${n4} without any listeners`);
        this.events.emit(Lt$2("session_request", i3.request.id), { error: t });
      });
    }, this.processSessionRequestQueue = () => {
      if (this.sessionRequestQueue.state === x$1.active) {
        this.client.logger.info("session request queue is already active.");
        return;
      }
      const e2 = this.sessionRequestQueue.queue[0];
      if (!e2) {
        this.client.logger.info("session request queue is empty.");
        return;
      }
      try {
        this.sessionRequestQueue.state = x$1.active, this.emitSessionRequest(e2);
      } catch (t) {
        this.client.logger.error(t);
      }
    }, this.emitSessionRequest = (e2) => {
      this.client.events.emit("session_request", e2);
    }, this.onPairingCreated = (e2) => {
      if (e2.methods && this.expectedPairingMethodMap.set(e2.topic, e2.methods), e2.active) return;
      const t = this.client.proposal.getAll().find((s2) => s2.pairingTopic === e2.topic);
      t && this.onSessionProposeRequest({ topic: e2.topic, payload: formatJsonRpcRequest("wc_sessionPropose", { requiredNamespaces: t.requiredNamespaces, optionalNamespaces: t.optionalNamespaces, relays: t.relays, proposer: t.proposer, sessionProperties: t.sessionProperties }, t.id) });
    }, this.isValidConnect = async (e2) => {
      if (!to(e2)) {
        const { message: a3 } = S$5("MISSING_OR_INVALID", `connect() params: ${JSON.stringify(e2)}`);
        throw new Error(a3);
      }
      const { pairingTopic: t, requiredNamespaces: s2, optionalNamespaces: i3, sessionProperties: r2, relays: n4 } = e2;
      if (I$3(t) || await this.isValidPairingTopic(t), !eo(n4)) {
        const { message: a3 } = S$5("MISSING_OR_INVALID", `connect() relays: ${n4}`);
        throw new Error(a3);
      }
      !I$3(s2) && Z$3(s2) !== 0 && this.validateNamespaces(s2, "requiredNamespaces"), !I$3(i3) && Z$3(i3) !== 0 && this.validateNamespaces(i3, "optionalNamespaces"), I$3(r2) || this.validateSessionProps(r2, "sessionProperties");
    }, this.validateNamespaces = (e2, t) => {
      const s2 = Xr$1(e2, "connect()", t);
      if (s2) throw new Error(s2.message);
    }, this.isValidApprove = async (e2) => {
      if (!to(e2)) throw new Error(S$5("MISSING_OR_INVALID", `approve() params: ${e2}`).message);
      const { id: t, namespaces: s2, relayProtocol: i3, sessionProperties: r2 } = e2;
      this.checkRecentlyDeleted(t), await this.isValidProposalId(t);
      const n4 = this.client.proposal.get(t), a3 = Wn(s2, "approve()");
      if (a3) throw new Error(a3.message);
      const c2 = zn(n4.requiredNamespaces, s2, "approve()");
      if (c2) throw new Error(c2.message);
      if (!b$2(i3, true)) {
        const { message: h4 } = S$5("MISSING_OR_INVALID", `approve() relayProtocol: ${i3}`);
        throw new Error(h4);
      }
      I$3(r2) || this.validateSessionProps(r2, "sessionProperties");
    }, this.isValidReject = async (e2) => {
      if (!to(e2)) {
        const { message: i3 } = S$5("MISSING_OR_INVALID", `reject() params: ${e2}`);
        throw new Error(i3);
      }
      const { id: t, reason: s2 } = e2;
      if (this.checkRecentlyDeleted(t), await this.isValidProposalId(t), !ro(s2)) {
        const { message: i3 } = S$5("MISSING_OR_INVALID", `reject() reason: ${JSON.stringify(s2)}`);
        throw new Error(i3);
      }
    }, this.isValidSessionSettleRequest = (e2) => {
      if (!to(e2)) {
        const { message: c2 } = S$5("MISSING_OR_INVALID", `onSessionSettleRequest() params: ${e2}`);
        throw new Error(c2);
      }
      const { relay: t, controller: s2, namespaces: i3, expiry: r2 } = e2;
      if (!Jn(t)) {
        const { message: c2 } = S$5("MISSING_OR_INVALID", "onSessionSettleRequest() relay protocol should be a string");
        throw new Error(c2);
      }
      const n4 = Zr$1(s2, "onSessionSettleRequest()");
      if (n4) throw new Error(n4.message);
      const a3 = Wn(i3, "onSessionSettleRequest()");
      if (a3) throw new Error(a3.message);
      if (Kt$2(r2)) {
        const { message: c2 } = S$5("EXPIRED", "onSessionSettleRequest()");
        throw new Error(c2);
      }
    }, this.isValidUpdate = async (e2) => {
      if (!to(e2)) {
        const { message: a3 } = S$5("MISSING_OR_INVALID", `update() params: ${e2}`);
        throw new Error(a3);
      }
      const { topic: t, namespaces: s2 } = e2;
      this.checkRecentlyDeleted(t), await this.isValidSessionTopic(t);
      const i3 = this.client.session.get(t), r2 = Wn(s2, "update()");
      if (r2) throw new Error(r2.message);
      const n4 = zn(i3.requiredNamespaces, s2, "update()");
      if (n4) throw new Error(n4.message);
    }, this.isValidExtend = async (e2) => {
      if (!to(e2)) {
        const { message: s2 } = S$5("MISSING_OR_INVALID", `extend() params: ${e2}`);
        throw new Error(s2);
      }
      const { topic: t } = e2;
      this.checkRecentlyDeleted(t), await this.isValidSessionTopic(t);
    }, this.isValidRequest = async (e2) => {
      if (!to(e2)) {
        const { message: a3 } = S$5("MISSING_OR_INVALID", `request() params: ${e2}`);
        throw new Error(a3);
      }
      const { topic: t, request: s2, chainId: i3, expiry: r2 } = e2;
      this.checkRecentlyDeleted(t), await this.isValidSessionTopic(t);
      const { namespaces: n4 } = this.client.session.get(t);
      if (!co(n4, i3)) {
        const { message: a3 } = S$5("MISSING_OR_INVALID", `request() chainId: ${i3}`);
        throw new Error(a3);
      }
      if (!oo(s2)) {
        const { message: a3 } = S$5("MISSING_OR_INVALID", `request() ${JSON.stringify(s2)}`);
        throw new Error(a3);
      }
      if (!ao(n4, i3, s2.method)) {
        const { message: a3 } = S$5("MISSING_OR_INVALID", `request() method: ${s2.method}`);
        throw new Error(a3);
      }
      if (r2 && !po(r2, me)) {
        const { message: a3 } = S$5("MISSING_OR_INVALID", `request() expiry: ${r2}. Expiry must be a number (in seconds) between ${me.min} and ${me.max}`);
        throw new Error(a3);
      }
    }, this.isValidRespond = async (e2) => {
      var t;
      if (!to(e2)) {
        const { message: r2 } = S$5("MISSING_OR_INVALID", `respond() params: ${e2}`);
        throw new Error(r2);
      }
      const { topic: s2, response: i3 } = e2;
      try {
        await this.isValidSessionTopic(s2);
      } catch (r2) {
        throw (t = e2 == null ? void 0 : e2.response) != null && t.id && this.cleanupAfterResponse(e2), r2;
      }
      if (!so(i3)) {
        const { message: r2 } = S$5("MISSING_OR_INVALID", `respond() response: ${JSON.stringify(i3)}`);
        throw new Error(r2);
      }
    }, this.isValidPing = async (e2) => {
      if (!to(e2)) {
        const { message: s2 } = S$5("MISSING_OR_INVALID", `ping() params: ${e2}`);
        throw new Error(s2);
      }
      const { topic: t } = e2;
      await this.isValidSessionOrPairingTopic(t);
    }, this.isValidEmit = async (e2) => {
      if (!to(e2)) {
        const { message: n4 } = S$5("MISSING_OR_INVALID", `emit() params: ${e2}`);
        throw new Error(n4);
      }
      const { topic: t, event: s2, chainId: i3 } = e2;
      await this.isValidSessionTopic(t);
      const { namespaces: r2 } = this.client.session.get(t);
      if (!co(r2, i3)) {
        const { message: n4 } = S$5("MISSING_OR_INVALID", `emit() chainId: ${i3}`);
        throw new Error(n4);
      }
      if (!io(s2)) {
        const { message: n4 } = S$5("MISSING_OR_INVALID", `emit() event: ${JSON.stringify(s2)}`);
        throw new Error(n4);
      }
      if (!uo(r2, i3, s2.name)) {
        const { message: n4 } = S$5("MISSING_OR_INVALID", `emit() event: ${JSON.stringify(s2)}`);
        throw new Error(n4);
      }
    }, this.isValidDisconnect = async (e2) => {
      if (!to(e2)) {
        const { message: s2 } = S$5("MISSING_OR_INVALID", `disconnect() params: ${e2}`);
        throw new Error(s2);
      }
      const { topic: t } = e2;
      await this.isValidSessionOrPairingTopic(t);
    }, this.isValidAuthenticate = (e2) => {
      const { chains: t, uri: s2, domain: i3, nonce: r2 } = e2;
      if (!Array.isArray(t) || t.length === 0) throw new Error("chains is required and must be a non-empty array");
      if (!b$2(s2, false)) throw new Error("uri is required parameter");
      if (!b$2(i3, false)) throw new Error("domain is required parameter");
      if (!b$2(r2, false)) throw new Error("nonce is required parameter");
      if ([...new Set(t.map((a3) => re$2(a3).namespace))].length > 1) throw new Error("Multi-namespace requests are not supported. Please request single namespace only.");
      const { namespace: n4 } = re$2(t[0]);
      if (n4 !== "eip155") throw new Error("Only eip155 namespace is supported for authenticated sessions. Please use .connect() for non-eip155 chains.");
    }, this.getVerifyContext = async (e2) => {
      const { attestationId: t, hash: s2, encryptedId: i3, metadata: r2, transportType: n4 } = e2, a3 = { verified: { verifyUrl: r2.verifyUrl || J$1, validation: "UNKNOWN", origin: r2.url || "" } };
      try {
        if (n4 === M$2.link_mode) {
          const h4 = this.getAppLinkIfEnabled(r2, n4);
          return a3.verified.validation = h4 && new URL(h4).origin === new URL(r2.url).origin ? "VALID" : "INVALID", a3;
        }
        const c2 = await this.client.core.verify.resolve({ attestationId: t, hash: s2, encryptedId: i3, verifyUrl: r2.verifyUrl });
        c2 && (a3.verified.origin = c2.origin, a3.verified.isScam = c2.isScam, a3.verified.validation = c2.origin === new URL(r2.url).origin ? "VALID" : "INVALID");
      } catch (c2) {
        this.client.logger.warn(c2);
      }
      return this.client.logger.debug(`Verify context: ${JSON.stringify(a3)}`), a3;
    }, this.validateSessionProps = (e2, t) => {
      Object.values(e2).forEach((s2) => {
        if (!b$2(s2, false)) {
          const { message: i3 } = S$5("MISSING_OR_INVALID", `${t} must be in Record<string, string> format. Received: ${JSON.stringify(s2)}`);
          throw new Error(i3);
        }
      });
    }, this.getPendingAuthRequest = (e2) => {
      const t = this.client.auth.requests.get(e2);
      return typeof t == "object" ? t : void 0;
    }, this.addToRecentlyDeleted = (e2, t) => {
      if (this.recentlyDeletedMap.set(e2, t), this.recentlyDeletedMap.size >= this.recentlyDeletedLimit) {
        let s2 = 0;
        const i3 = this.recentlyDeletedLimit / 2;
        for (const r2 of this.recentlyDeletedMap.keys()) {
          if (s2++ >= i3) break;
          this.recentlyDeletedMap.delete(r2);
        }
      }
    }, this.checkRecentlyDeleted = (e2) => {
      const t = this.recentlyDeletedMap.get(e2);
      if (t) {
        const { message: s2 } = S$5("MISSING_OR_INVALID", `Record was recently deleted - ${t}: ${e2}`);
        throw new Error(s2);
      }
    }, this.isLinkModeEnabled = (e2, t) => {
      var s2, i3, r2, n4, a3, c2, h4, p3, d4;
      return !e2 || t !== M$2.link_mode ? false : ((i3 = (s2 = this.client.metadata) == null ? void 0 : s2.redirect) == null ? void 0 : i3.linkMode) === true && ((n4 = (r2 = this.client.metadata) == null ? void 0 : r2.redirect) == null ? void 0 : n4.universal) !== void 0 && ((c2 = (a3 = this.client.metadata) == null ? void 0 : a3.redirect) == null ? void 0 : c2.universal) !== "" && ((h4 = e2 == null ? void 0 : e2.redirect) == null ? void 0 : h4.universal) !== void 0 && ((p3 = e2 == null ? void 0 : e2.redirect) == null ? void 0 : p3.universal) !== "" && ((d4 = e2 == null ? void 0 : e2.redirect) == null ? void 0 : d4.linkMode) === true && this.client.core.linkModeSupportedApps.includes(e2.redirect.universal) && typeof (global == null ? void 0 : global.Linking) < "u";
    }, this.getAppLinkIfEnabled = (e2, t) => {
      var s2;
      return this.isLinkModeEnabled(e2, t) ? (s2 = e2 == null ? void 0 : e2.redirect) == null ? void 0 : s2.universal : void 0;
    }, this.handleLinkModeMessage = ({ url: e2 }) => {
      if (!e2 || !e2.includes("wc_ev") || !e2.includes("topic")) return;
      const t = Bt$2(e2, "topic") || "", s2 = decodeURIComponent(Bt$2(e2, "wc_ev") || ""), i3 = this.client.session.keys.includes(t);
      i3 && this.client.session.update(t, { transportType: M$2.link_mode }), this.client.core.dispatchEnvelope({ topic: t, message: s2, sessionExists: i3 });
    }, this.registerLinkModeListeners = async () => {
      var e2;
      if (Wt$2() || _$1() && (e2 = this.client.metadata.redirect) != null && e2.linkMode) {
        const t = global == null ? void 0 : global.Linking;
        if (typeof t < "u") {
          t.addEventListener("url", this.handleLinkModeMessage, this.client.name);
          const s2 = await t.getInitialURL();
          s2 && setTimeout(() => {
            this.handleLinkModeMessage({ url: s2 });
          }, 50);
        }
      }
    };
  }
  isInitialized() {
    if (!this.initialized) {
      const { message: o3 } = S$5("NOT_INITIALIZED", this.name);
      throw new Error(o3);
    }
  }
  async confirmOnlineStateOrThrow() {
    await this.client.core.relayer.confirmOnlineStateOrThrow();
  }
  registerRelayerEvents() {
    this.client.core.relayer.on(v$2.message, (o3) => {
      !this.initialized || this.relayMessageCache.length > 0 ? this.relayMessageCache.push(o3) : this.onRelayMessage(o3);
    });
  }
  async onRelayMessage(o3) {
    const { topic: e2, message: t, attestation: s2, transportType: i3 } = o3, { publicKey: r2 } = this.client.auth.authKeys.keys.includes(ae) ? this.client.auth.authKeys.get(ae) : { responseTopic: void 0, publicKey: void 0 }, n4 = await this.client.core.crypto.decode(e2, t, { receiverPublicKey: r2, encoding: i3 === M$2.link_mode ? lr$2 : ge$1 });
    try {
      isJsonRpcRequest(n4) ? (this.client.core.history.set(e2, n4), this.onRelayEventRequest({ topic: e2, payload: n4, attestation: s2, transportType: i3, encryptedId: yr$2(t) })) : isJsonRpcResponse(n4) ? (await this.client.core.history.resolve(n4), await this.onRelayEventResponse({ topic: e2, payload: n4, transportType: i3 }), this.client.core.history.delete(e2, n4.id)) : this.onRelayEventUnknownPayload({ topic: e2, payload: n4, transportType: i3 });
    } catch (a3) {
      this.client.logger.error(a3);
    }
  }
  registerExpirerEvents() {
    this.client.core.expirer.on(S$3.expired, async (o3) => {
      const { topic: e2, id: t } = Vt$2(o3.target);
      if (t && this.client.pendingRequest.keys.includes(t)) return await this.deletePendingSessionRequest(t, S$5("EXPIRED"), true);
      if (t && this.client.auth.requests.keys.includes(t)) return await this.deletePendingAuthRequest(t, S$5("EXPIRED"), true);
      e2 ? this.client.session.keys.includes(e2) && (await this.deleteSession({ topic: e2, expirerHasDeleted: true }), this.client.events.emit("session_expire", { topic: e2 })) : t && (await this.deleteProposal(t, true), this.client.events.emit("proposal_expire", { id: t }));
    });
  }
  registerPairingEvents() {
    this.client.core.pairing.events.on(V$2.create, (o3) => this.onPairingCreated(o3)), this.client.core.pairing.events.on(V$2.delete, (o3) => {
      this.addToRecentlyDeleted(o3.topic, "pairing");
    });
  }
  isValidPairingTopic(o3) {
    if (!b$2(o3, false)) {
      const { message: e2 } = S$5("MISSING_OR_INVALID", `pairing topic should be a string: ${o3}`);
      throw new Error(e2);
    }
    if (!this.client.core.pairing.pairings.keys.includes(o3)) {
      const { message: e2 } = S$5("NO_MATCHING_KEY", `pairing topic doesn't exist: ${o3}`);
      throw new Error(e2);
    }
    if (Kt$2(this.client.core.pairing.pairings.get(o3).expiry)) {
      const { message: e2 } = S$5("EXPIRED", `pairing topic: ${o3}`);
      throw new Error(e2);
    }
  }
  async isValidSessionTopic(o3) {
    if (!b$2(o3, false)) {
      const { message: e2 } = S$5("MISSING_OR_INVALID", `session topic should be a string: ${o3}`);
      throw new Error(e2);
    }
    if (this.checkRecentlyDeleted(o3), !this.client.session.keys.includes(o3)) {
      const { message: e2 } = S$5("NO_MATCHING_KEY", `session topic doesn't exist: ${o3}`);
      throw new Error(e2);
    }
    if (Kt$2(this.client.session.get(o3).expiry)) {
      await this.deleteSession({ topic: o3 });
      const { message: e2 } = S$5("EXPIRED", `session topic: ${o3}`);
      throw new Error(e2);
    }
    if (!this.client.core.crypto.keychain.has(o3)) {
      const { message: e2 } = S$5("MISSING_OR_INVALID", `session topic does not exist in keychain: ${o3}`);
      throw await this.deleteSession({ topic: o3 }), new Error(e2);
    }
  }
  async isValidSessionOrPairingTopic(o3) {
    if (this.checkRecentlyDeleted(o3), this.client.session.keys.includes(o3)) await this.isValidSessionTopic(o3);
    else if (this.client.core.pairing.pairings.keys.includes(o3)) this.isValidPairingTopic(o3);
    else if (b$2(o3, false)) {
      const { message: e2 } = S$5("NO_MATCHING_KEY", `session or pairing topic doesn't exist: ${o3}`);
      throw new Error(e2);
    } else {
      const { message: e2 } = S$5("MISSING_OR_INVALID", `session or pairing topic should be a string: ${o3}`);
      throw new Error(e2);
    }
  }
  async isValidProposalId(o3) {
    if (!no(o3)) {
      const { message: e2 } = S$5("MISSING_OR_INVALID", `proposal id should be a number: ${o3}`);
      throw new Error(e2);
    }
    if (!this.client.proposal.keys.includes(o3)) {
      const { message: e2 } = S$5("NO_MATCHING_KEY", `proposal id doesn't exist: ${o3}`);
      throw new Error(e2);
    }
    if (Kt$2(this.client.proposal.get(o3).expiryTimestamp)) {
      await this.deleteProposal(o3);
      const { message: e2 } = S$5("EXPIRED", `proposal id: ${o3}`);
      throw new Error(e2);
    }
  }
}
class Ss extends ni {
  constructor(o3, e2) {
    super(o3, e2, st, ye), this.core = o3, this.logger = e2;
  }
}
class yt extends ni {
  constructor(o3, e2) {
    super(o3, e2, rt, ye), this.core = o3, this.logger = e2;
  }
}
class Is extends ni {
  constructor(o3, e2) {
    super(o3, e2, ot, ye, (t) => t.id), this.core = o3, this.logger = e2;
  }
}
class fs extends ni {
  constructor(o3, e2) {
    super(o3, e2, pt2, oe, () => ae), this.core = o3, this.logger = e2;
  }
}
class vs extends ni {
  constructor(o3, e2) {
    super(o3, e2, ht, oe), this.core = o3, this.logger = e2;
  }
}
class qs extends ni {
  constructor(o3, e2) {
    super(o3, e2, dt2, oe, (t) => t.id), this.core = o3, this.logger = e2;
  }
}
class Ts {
  constructor(o3, e2) {
    this.core = o3, this.logger = e2, this.authKeys = new fs(this.core, this.logger), this.pairingTopics = new vs(this.core, this.logger), this.requests = new qs(this.core, this.logger);
  }
  async init() {
    await this.authKeys.init(), await this.pairingTopics.init(), await this.requests.init();
  }
}
class _e extends S$1 {
  constructor(o3) {
    super(o3), this.protocol = be, this.version = Ce, this.name = we.name, this.events = new eventsExports.EventEmitter(), this.on = (t, s2) => this.events.on(t, s2), this.once = (t, s2) => this.events.once(t, s2), this.off = (t, s2) => this.events.off(t, s2), this.removeListener = (t, s2) => this.events.removeListener(t, s2), this.removeAllListeners = (t) => this.events.removeAllListeners(t), this.connect = async (t) => {
      try {
        return await this.engine.connect(t);
      } catch (s2) {
        throw this.logger.error(s2.message), s2;
      }
    }, this.pair = async (t) => {
      try {
        return await this.engine.pair(t);
      } catch (s2) {
        throw this.logger.error(s2.message), s2;
      }
    }, this.approve = async (t) => {
      try {
        return await this.engine.approve(t);
      } catch (s2) {
        throw this.logger.error(s2.message), s2;
      }
    }, this.reject = async (t) => {
      try {
        return await this.engine.reject(t);
      } catch (s2) {
        throw this.logger.error(s2.message), s2;
      }
    }, this.update = async (t) => {
      try {
        return await this.engine.update(t);
      } catch (s2) {
        throw this.logger.error(s2.message), s2;
      }
    }, this.extend = async (t) => {
      try {
        return await this.engine.extend(t);
      } catch (s2) {
        throw this.logger.error(s2.message), s2;
      }
    }, this.request = async (t) => {
      try {
        return await this.engine.request(t);
      } catch (s2) {
        throw this.logger.error(s2.message), s2;
      }
    }, this.respond = async (t) => {
      try {
        return await this.engine.respond(t);
      } catch (s2) {
        throw this.logger.error(s2.message), s2;
      }
    }, this.ping = async (t) => {
      try {
        return await this.engine.ping(t);
      } catch (s2) {
        throw this.logger.error(s2.message), s2;
      }
    }, this.emit = async (t) => {
      try {
        return await this.engine.emit(t);
      } catch (s2) {
        throw this.logger.error(s2.message), s2;
      }
    }, this.disconnect = async (t) => {
      try {
        return await this.engine.disconnect(t);
      } catch (s2) {
        throw this.logger.error(s2.message), s2;
      }
    }, this.find = (t) => {
      try {
        return this.engine.find(t);
      } catch (s2) {
        throw this.logger.error(s2.message), s2;
      }
    }, this.getPendingSessionRequests = () => {
      try {
        return this.engine.getPendingSessionRequests();
      } catch (t) {
        throw this.logger.error(t.message), t;
      }
    }, this.authenticate = async (t, s2) => {
      try {
        return await this.engine.authenticate(t, s2);
      } catch (i3) {
        throw this.logger.error(i3.message), i3;
      }
    }, this.formatAuthMessage = (t) => {
      try {
        return this.engine.formatAuthMessage(t);
      } catch (s2) {
        throw this.logger.error(s2.message), s2;
      }
    }, this.approveSessionAuthenticate = async (t) => {
      try {
        return await this.engine.approveSessionAuthenticate(t);
      } catch (s2) {
        throw this.logger.error(s2.message), s2;
      }
    }, this.rejectSessionAuthenticate = async (t) => {
      try {
        return await this.engine.rejectSessionAuthenticate(t);
      } catch (s2) {
        throw this.logger.error(s2.message), s2;
      }
    }, this.name = (o3 == null ? void 0 : o3.name) || we.name, this.metadata = (o3 == null ? void 0 : o3.metadata) || Nt$2(), this.signConfig = o3 == null ? void 0 : o3.signConfig;
    const e2 = typeof (o3 == null ? void 0 : o3.logger) < "u" && typeof (o3 == null ? void 0 : o3.logger) != "string" ? o3.logger : qt$3(k$2({ level: (o3 == null ? void 0 : o3.logger) || we.logger }));
    this.core = (o3 == null ? void 0 : o3.core) || new bn(o3), this.logger = E$1(e2, this.name), this.session = new yt(this.core, this.logger), this.proposal = new Ss(this.core, this.logger), this.pendingRequest = new Is(this.core, this.logger), this.engine = new Rs(this), this.auth = new Ts(this.core, this.logger);
  }
  static async init(o3) {
    const e2 = new _e(o3);
    return await e2.initialize(), e2;
  }
  get context() {
    return y$3(this.logger);
  }
  get pairing() {
    return this.core.pairing.pairings;
  }
  async initialize() {
    this.logger.trace("Initialized");
    try {
      await this.core.start(), await this.session.init(), await this.proposal.init(), await this.pendingRequest.init(), await this.auth.init(), await this.engine.init(), this.logger.info("SignClient Initialization Success"), this.engine.processRelayMessageCache();
    } catch (o3) {
      throw this.logger.info("SignClient Initialization Failure"), this.logger.error(o3.message), o3;
    }
  }
}
const Ns2 = yt, Ps = _e;
var l = { exports: {} }, c = typeof Reflect == "object" ? Reflect : null, y2 = c && typeof c.apply == "function" ? c.apply : function(t, e2, n4) {
  return Function.prototype.apply.call(t, e2, n4);
}, f2;
c && typeof c.ownKeys == "function" ? f2 = c.ownKeys : Object.getOwnPropertySymbols ? f2 = function(t) {
  return Object.getOwnPropertyNames(t).concat(Object.getOwnPropertySymbols(t));
} : f2 = function(t) {
  return Object.getOwnPropertyNames(t);
};
function k(s2) {
  console && console.warn && console.warn(s2);
}
var w = Number.isNaN || function(t) {
  return t !== t;
};
function o2() {
  o2.init.call(this);
}
l.exports = o2, l.exports.once = K2, o2.EventEmitter = o2, o2.prototype._events = void 0, o2.prototype._eventsCount = 0, o2.prototype._maxListeners = void 0;
var L2 = 10;
function g2(s2) {
  if (typeof s2 != "function") throw new TypeError('The "listener" argument must be of type Function. Received type ' + typeof s2);
}
Object.defineProperty(o2, "defaultMaxListeners", { enumerable: true, get: function() {
  return L2;
}, set: function(s2) {
  if (typeof s2 != "number" || s2 < 0 || w(s2)) throw new RangeError('The value of "defaultMaxListeners" is out of range. It must be a non-negative number. Received ' + s2 + ".");
  L2 = s2;
} }), o2.init = function() {
  (this._events === void 0 || this._events === Object.getPrototypeOf(this)._events) && (this._events = /* @__PURE__ */ Object.create(null), this._eventsCount = 0), this._maxListeners = this._maxListeners || void 0;
}, o2.prototype.setMaxListeners = function(t) {
  if (typeof t != "number" || t < 0 || w(t)) throw new RangeError('The value of "n" is out of range. It must be a non-negative number. Received ' + t + ".");
  return this._maxListeners = t, this;
};
function _2(s2) {
  return s2._maxListeners === void 0 ? o2.defaultMaxListeners : s2._maxListeners;
}
o2.prototype.getMaxListeners = function() {
  return _2(this);
}, o2.prototype.emit = function(t) {
  for (var e2 = [], n4 = 1; n4 < arguments.length; n4++) e2.push(arguments[n4]);
  var i3 = t === "error", a3 = this._events;
  if (a3 !== void 0) i3 = i3 && a3.error === void 0;
  else if (!i3) return false;
  if (i3) {
    var r2;
    if (e2.length > 0 && (r2 = e2[0]), r2 instanceof Error) throw r2;
    var h4 = new Error("Unhandled error." + (r2 ? " (" + r2.message + ")" : ""));
    throw h4.context = r2, h4;
  }
  var u2 = a3[t];
  if (u2 === void 0) return false;
  if (typeof u2 == "function") y2(u2, this, e2);
  else for (var d4 = u2.length, M2 = O2(u2, d4), n4 = 0; n4 < d4; ++n4) y2(M2[n4], this, e2);
  return true;
};
function S4(s2, t, e2, n4) {
  var i3, a3, r2;
  if (g2(e2), a3 = s2._events, a3 === void 0 ? (a3 = s2._events = /* @__PURE__ */ Object.create(null), s2._eventsCount = 0) : (a3.newListener !== void 0 && (s2.emit("newListener", t, e2.listener ? e2.listener : e2), a3 = s2._events), r2 = a3[t]), r2 === void 0) r2 = a3[t] = e2, ++s2._eventsCount;
  else if (typeof r2 == "function" ? r2 = a3[t] = n4 ? [e2, r2] : [r2, e2] : n4 ? r2.unshift(e2) : r2.push(e2), i3 = _2(s2), i3 > 0 && r2.length > i3 && !r2.warned) {
    r2.warned = true;
    var h4 = new Error("Possible EventEmitter memory leak detected. " + r2.length + " " + String(t) + " listeners added. Use emitter.setMaxListeners() to increase limit");
    h4.name = "MaxListenersExceededWarning", h4.emitter = s2, h4.type = t, h4.count = r2.length, k(h4);
  }
  return s2;
}
o2.prototype.addListener = function(t, e2) {
  return S4(this, t, e2, false);
}, o2.prototype.on = o2.prototype.addListener, o2.prototype.prependListener = function(t, e2) {
  return S4(this, t, e2, true);
};
function D() {
  if (!this.fired) return this.target.removeListener(this.type, this.wrapFn), this.fired = true, arguments.length === 0 ? this.listener.call(this.target) : this.listener.apply(this.target, arguments);
}
function C2(s2, t, e2) {
  var n4 = { fired: false, wrapFn: void 0, target: s2, type: t, listener: e2 }, i3 = D.bind(n4);
  return i3.listener = e2, n4.wrapFn = i3, i3;
}
o2.prototype.once = function(t, e2) {
  return g2(e2), this.on(t, C2(this, t, e2)), this;
}, o2.prototype.prependOnceListener = function(t, e2) {
  return g2(e2), this.prependListener(t, C2(this, t, e2)), this;
}, o2.prototype.removeListener = function(t, e2) {
  var n4, i3, a3, r2, h4;
  if (g2(e2), i3 = this._events, i3 === void 0) return this;
  if (n4 = i3[t], n4 === void 0) return this;
  if (n4 === e2 || n4.listener === e2) --this._eventsCount === 0 ? this._events = /* @__PURE__ */ Object.create(null) : (delete i3[t], i3.removeListener && this.emit("removeListener", t, n4.listener || e2));
  else if (typeof n4 != "function") {
    for (a3 = -1, r2 = n4.length - 1; r2 >= 0; r2--) if (n4[r2] === e2 || n4[r2].listener === e2) {
      h4 = n4[r2].listener, a3 = r2;
      break;
    }
    if (a3 < 0) return this;
    a3 === 0 ? n4.shift() : F(n4, a3), n4.length === 1 && (i3[t] = n4[0]), i3.removeListener !== void 0 && this.emit("removeListener", t, h4 || e2);
  }
  return this;
}, o2.prototype.off = o2.prototype.removeListener, o2.prototype.removeAllListeners = function(t) {
  var e2, n4, i3;
  if (n4 = this._events, n4 === void 0) return this;
  if (n4.removeListener === void 0) return arguments.length === 0 ? (this._events = /* @__PURE__ */ Object.create(null), this._eventsCount = 0) : n4[t] !== void 0 && (--this._eventsCount === 0 ? this._events = /* @__PURE__ */ Object.create(null) : delete n4[t]), this;
  if (arguments.length === 0) {
    var a3 = Object.keys(n4), r2;
    for (i3 = 0; i3 < a3.length; ++i3) r2 = a3[i3], r2 !== "removeListener" && this.removeAllListeners(r2);
    return this.removeAllListeners("removeListener"), this._events = /* @__PURE__ */ Object.create(null), this._eventsCount = 0, this;
  }
  if (e2 = n4[t], typeof e2 == "function") this.removeListener(t, e2);
  else if (e2 !== void 0) for (i3 = e2.length - 1; i3 >= 0; i3--) this.removeListener(t, e2[i3]);
  return this;
};
function b(s2, t, e2) {
  var n4 = s2._events;
  if (n4 === void 0) return [];
  var i3 = n4[t];
  return i3 === void 0 ? [] : typeof i3 == "function" ? e2 ? [i3.listener || i3] : [i3] : e2 ? z(i3) : O2(i3, i3.length);
}
o2.prototype.listeners = function(t) {
  return b(this, t, true);
}, o2.prototype.rawListeners = function(t) {
  return b(this, t, false);
}, o2.listenerCount = function(s2, t) {
  return typeof s2.listenerCount == "function" ? s2.listenerCount(t) : E.call(s2, t);
}, o2.prototype.listenerCount = E;
function E(s2) {
  var t = this._events;
  if (t !== void 0) {
    var e2 = t[s2];
    if (typeof e2 == "function") return 1;
    if (e2 !== void 0) return e2.length;
  }
  return 0;
}
o2.prototype.eventNames = function() {
  return this._eventsCount > 0 ? f2(this._events) : [];
};
function O2(s2, t) {
  for (var e2 = new Array(t), n4 = 0; n4 < t; ++n4) e2[n4] = s2[n4];
  return e2;
}
function F(s2, t) {
  for (; t + 1 < s2.length; t++) s2[t] = s2[t + 1];
  s2.pop();
}
function z(s2) {
  for (var t = new Array(s2.length), e2 = 0; e2 < t.length; ++e2) t[e2] = s2[e2].listener || s2[e2];
  return t;
}
function K2(s2, t) {
  return new Promise(function(e2, n4) {
    function i3(r2) {
      s2.removeListener(t, a3), n4(r2);
    }
    function a3() {
      typeof s2.removeListener == "function" && s2.removeListener("error", i3), e2([].slice.call(arguments));
    }
    R2(s2, t, a3, { once: true }), t !== "error" && U(s2, i3, { once: true });
  });
}
function U(s2, t, e2) {
  typeof s2.on == "function" && R2(s2, "error", t, e2);
}
function R2(s2, t, e2, n4) {
  if (typeof s2.on == "function") n4.once ? s2.once(t, e2) : s2.on(t, e2);
  else if (typeof s2.addEventListener == "function") s2.addEventListener(t, function i3(a3) {
    n4.once && s2.removeEventListener(t, i3), e2(a3);
  });
  else throw new TypeError('The "emitter" argument must be of type EventEmitter. Received type ' + typeof s2);
}
const p2 = "Web3Wallet";
class x2 {
  constructor(t) {
    this.opts = t;
  }
}
class P {
  constructor(t) {
    this.client = t;
  }
}
var V = Object.defineProperty, B2 = Object.defineProperties, J = Object.getOwnPropertyDescriptors, q = Object.getOwnPropertySymbols, Y = Object.prototype.hasOwnProperty, Z = Object.prototype.propertyIsEnumerable, j = (s2, t, e2) => t in s2 ? V(s2, t, { enumerable: true, configurable: true, writable: true, value: e2 }) : s2[t] = e2, ee = (s2, t) => {
  for (var e2 in t || (t = {})) Y.call(t, e2) && j(s2, e2, t[e2]);
  if (q) for (var e2 of q(t)) Z.call(t, e2) && j(s2, e2, t[e2]);
  return s2;
}, te = (s2, t) => B2(s2, J(t));
class se extends P {
  constructor(t) {
    super(t), this.init = async () => {
      this.signClient = await Ps.init({ core: this.client.core, metadata: this.client.metadata, signConfig: this.client.signConfig }), this.authClient = await zr.init({ core: this.client.core, projectId: "", metadata: this.client.metadata });
    }, this.pair = async (e2) => {
      await this.client.core.pairing.pair(e2);
    }, this.approveSession = async (e2) => {
      const { topic: n4, acknowledged: i3 } = await this.signClient.approve(te(ee({}, e2), { id: e2.id, namespaces: e2.namespaces, sessionProperties: e2.sessionProperties, sessionConfig: e2.sessionConfig }));
      return await i3(), this.signClient.session.get(n4);
    }, this.rejectSession = async (e2) => await this.signClient.reject(e2), this.updateSession = async (e2) => await this.signClient.update(e2), this.extendSession = async (e2) => await this.signClient.extend(e2), this.respondSessionRequest = async (e2) => await this.signClient.respond(e2), this.disconnectSession = async (e2) => await this.signClient.disconnect(e2), this.emitSessionEvent = async (e2) => await this.signClient.emit(e2), this.getActiveSessions = () => this.signClient.session.getAll().reduce((e2, n4) => (e2[n4.topic] = n4, e2), {}), this.getPendingSessionProposals = () => this.signClient.proposal.getAll(), this.getPendingSessionRequests = () => this.signClient.getPendingSessionRequests(), this.respondAuthRequest = async (e2, n4) => await this.authClient.respond(e2, n4), this.getPendingAuthRequests = () => this.authClient.requests.getAll().filter((e2) => "requester" in e2), this.formatMessage = (e2, n4) => this.authClient.formatMessage(e2, n4), this.approveSessionAuthenticate = async (e2) => await this.signClient.approveSessionAuthenticate(e2), this.rejectSessionAuthenticate = async (e2) => await this.signClient.rejectSessionAuthenticate(e2), this.formatAuthMessage = (e2) => this.signClient.formatAuthMessage(e2), this.registerDeviceToken = (e2) => this.client.core.echoClient.registerDeviceToken(e2), this.on = (e2, n4) => (this.setEvent(e2, "off"), this.setEvent(e2, "on"), this.client.events.on(e2, n4)), this.once = (e2, n4) => (this.setEvent(e2, "off"), this.setEvent(e2, "once"), this.client.events.once(e2, n4)), this.off = (e2, n4) => (this.setEvent(e2, "off"), this.client.events.off(e2, n4)), this.removeListener = (e2, n4) => (this.setEvent(e2, "removeListener"), this.client.events.removeListener(e2, n4)), this.onSessionRequest = (e2) => {
      this.client.events.emit("session_request", e2);
    }, this.onSessionProposal = (e2) => {
      this.client.events.emit("session_proposal", e2);
    }, this.onSessionDelete = (e2) => {
      this.client.events.emit("session_delete", e2);
    }, this.onAuthRequest = (e2) => {
      this.client.events.emit("auth_request", e2);
    }, this.onProposalExpire = (e2) => {
      this.client.events.emit("proposal_expire", e2);
    }, this.onSessionRequestExpire = (e2) => {
      this.client.events.emit("session_request_expire", e2);
    }, this.onSessionRequestAuthenticate = (e2) => {
      this.client.events.emit("session_authenticate", e2);
    }, this.setEvent = (e2, n4) => {
      switch (e2) {
        case "session_request":
          this.signClient.events[n4]("session_request", this.onSessionRequest);
          break;
        case "session_proposal":
          this.signClient.events[n4]("session_proposal", this.onSessionProposal);
          break;
        case "session_delete":
          this.signClient.events[n4]("session_delete", this.onSessionDelete);
          break;
        case "auth_request":
          this.authClient[n4]("auth_request", this.onAuthRequest);
          break;
        case "proposal_expire":
          this.signClient.events[n4]("proposal_expire", this.onProposalExpire);
          break;
        case "session_request_expire":
          this.signClient.events[n4]("session_request_expire", this.onSessionRequestExpire);
          break;
        case "session_authenticate":
          this.signClient.events[n4]("session_authenticate", this.onSessionRequestAuthenticate);
          break;
      }
    }, this.signClient = {}, this.authClient = {};
  }
}
const ne2 = { decryptMessage: async (s2) => {
  const t = { core: new bn({ storageOptions: s2.storageOptions, storage: s2.storage }) };
  await t.core.crypto.init();
  const e2 = t.core.crypto.decode(s2.topic, s2.encryptedMessage);
  return t.core = null, e2;
}, getMetadata: async (s2) => {
  const t = { core: new bn({ storageOptions: s2.storageOptions, storage: s2.storage }), sessionStore: null };
  t.sessionStore = new Ns2(t.core, t.core.logger), await t.sessionStore.init();
  const e2 = t.sessionStore.get(s2.topic), n4 = e2 == null ? void 0 : e2.peer.metadata;
  return t.core = null, t.sessionStore = null, n4;
} }, T = class extends x2 {
  constructor(s2) {
    super(s2), this.events = new l.exports(), this.on = (t, e2) => this.engine.on(t, e2), this.once = (t, e2) => this.engine.once(t, e2), this.off = (t, e2) => this.engine.off(t, e2), this.removeListener = (t, e2) => this.engine.removeListener(t, e2), this.pair = async (t) => {
      try {
        return await this.engine.pair(t);
      } catch (e2) {
        throw this.logger.error(e2.message), e2;
      }
    }, this.approveSession = async (t) => {
      try {
        return await this.engine.approveSession(t);
      } catch (e2) {
        throw this.logger.error(e2.message), e2;
      }
    }, this.rejectSession = async (t) => {
      try {
        return await this.engine.rejectSession(t);
      } catch (e2) {
        throw this.logger.error(e2.message), e2;
      }
    }, this.updateSession = async (t) => {
      try {
        return await this.engine.updateSession(t);
      } catch (e2) {
        throw this.logger.error(e2.message), e2;
      }
    }, this.extendSession = async (t) => {
      try {
        return await this.engine.extendSession(t);
      } catch (e2) {
        throw this.logger.error(e2.message), e2;
      }
    }, this.respondSessionRequest = async (t) => {
      try {
        return await this.engine.respondSessionRequest(t);
      } catch (e2) {
        throw this.logger.error(e2.message), e2;
      }
    }, this.disconnectSession = async (t) => {
      try {
        return await this.engine.disconnectSession(t);
      } catch (e2) {
        throw this.logger.error(e2.message), e2;
      }
    }, this.emitSessionEvent = async (t) => {
      try {
        return await this.engine.emitSessionEvent(t);
      } catch (e2) {
        throw this.logger.error(e2.message), e2;
      }
    }, this.getActiveSessions = () => {
      try {
        return this.engine.getActiveSessions();
      } catch (t) {
        throw this.logger.error(t.message), t;
      }
    }, this.getPendingSessionProposals = () => {
      try {
        return this.engine.getPendingSessionProposals();
      } catch (t) {
        throw this.logger.error(t.message), t;
      }
    }, this.getPendingSessionRequests = () => {
      try {
        return this.engine.getPendingSessionRequests();
      } catch (t) {
        throw this.logger.error(t.message), t;
      }
    }, this.respondAuthRequest = async (t, e2) => {
      try {
        return await this.engine.respondAuthRequest(t, e2);
      } catch (n4) {
        throw this.logger.error(n4.message), n4;
      }
    }, this.getPendingAuthRequests = () => {
      try {
        return this.engine.getPendingAuthRequests();
      } catch (t) {
        throw this.logger.error(t.message), t;
      }
    }, this.formatMessage = (t, e2) => {
      try {
        return this.engine.formatMessage(t, e2);
      } catch (n4) {
        throw this.logger.error(n4.message), n4;
      }
    }, this.registerDeviceToken = (t) => {
      try {
        return this.engine.registerDeviceToken(t);
      } catch (e2) {
        throw this.logger.error(e2.message), e2;
      }
    }, this.approveSessionAuthenticate = (t) => {
      try {
        return this.engine.approveSessionAuthenticate(t);
      } catch (e2) {
        throw this.logger.error(e2.message), e2;
      }
    }, this.rejectSessionAuthenticate = (t) => {
      try {
        return this.engine.rejectSessionAuthenticate(t);
      } catch (e2) {
        throw this.logger.error(e2.message), e2;
      }
    }, this.formatAuthMessage = (t) => {
      try {
        return this.engine.formatAuthMessage(t);
      } catch (e2) {
        throw this.logger.error(e2.message), e2;
      }
    }, this.metadata = s2.metadata, this.name = s2.name || p2, this.signConfig = s2.signConfig, this.core = s2.core, this.logger = this.core.logger, this.engine = new se(this);
  }
  static async init(s2) {
    const t = new T(s2);
    return await t.initialize(), t;
  }
  async initialize() {
    this.logger.trace("Initialized");
    try {
      await this.engine.init(), this.logger.info("Web3Wallet Initialization Success");
    } catch (s2) {
      throw this.logger.info("Web3Wallet Initialization Failure"), this.logger.error(s2.message), s2;
    }
  }
};
let v2 = T;
v2.notifications = ne2;
const ie = v2;
const chainType = "cip34";
const ProtocolMagic = {
  MAINNET: 764824073,
  PREVIEW: 2,
  PREPROD: 1
};
const mainnet = {
  chainType,
  // required
  name: "mainnet",
  networkId: "1",
  networkMagic: `${ProtocolMagic.MAINNET}`,
  // required
  endpoint: ""
};
const preprod = {
  chainType,
  name: "testnet",
  networkId: "0",
  networkMagic: `${ProtocolMagic.PREPROD}`,
  endpoint: ""
};
const preview = {
  chainType,
  name: "preview",
  networkId: "0",
  networkMagic: `${ProtocolMagic.PREVIEW}`,
  endpoint: ""
};
const getWCChain = (networkId2) => {
  if (networkId2 === "mainnet") {
    return mainnet;
  } else if (networkId2 === "preprod") {
    return preprod;
  } else if (networkId2 === "preview") {
    return preview;
  }
  throw new Error("Unsupported network!");
};
const updateIWalletConnectInfoIfNeeded = (memoryObject, dbObject) => {
  var _a, _b, _c, _d, _e2, _f;
  if (memoryObject.wcId !== dbObject.wcId || ((_a = memoryObject.session) == null ? void 0 : _a.topic) !== ((_b = dbObject.session) == null ? void 0 : _b.topic)) {
    throw DataError.updateIWalletConnecIfNeeded;
  }
  let changedWalletConnectList = false;
  if (dbObject.active !== memoryObject.active) {
    memoryObject.active = dbObject.active;
    changedWalletConnectList = true;
  }
  if (dbObject.walletId !== memoryObject.walletId) {
    memoryObject.walletId = dbObject.walletId;
    changedWalletConnectList = true;
  }
  if (dbObject.accountId !== memoryObject.accountId) {
    memoryObject.accountId = dbObject.accountId;
    changedWalletConnectList = true;
  }
  if (dbObject.lastActive !== memoryObject.lastActive) {
    memoryObject.lastActive = dbObject.lastActive;
    changedWalletConnectList = true;
  }
  if (((_c = dbObject.session) == null ? void 0 : _c.expiry) !== ((_d = memoryObject.session) == null ? void 0 : _d.expiry)) {
    if (memoryObject.session && ((_e2 = dbObject.session) == null ? void 0 : _e2.expiry)) {
      memoryObject.session.expiry = (_f = dbObject.session) == null ? void 0 : _f.expiry;
      changedWalletConnectList = true;
    }
  }
  if (dbObject.dAppInfo !== memoryObject.dAppInfo) {
    memoryObject.dAppInfo = dbObject.dAppInfo;
    changedWalletConnectList = true;
  }
  if (dbObject.approved !== memoryObject.approved) {
    memoryObject.approved = dbObject.approved;
    changedWalletConnectList = true;
  }
  return changedWalletConnectList;
};
const wcPairingKey = "wc@2:core:0.3//pairing";
const wcSubscriptionKey = "wc@2:core:0.3//subscription";
const wcExpirerKey = "wc@2:core:0.3//expirer";
const wcSessionKey = "wc@2:client:0.3//session";
class WalletConnectDB extends Dexie {
  constructor(networkId2) {
    super("eternl-" + networkId2 + "-wallet-connect");
    __publicField(this, "walletConnectInfos");
    this.version(1).stores({
      walletConnectInfos: "wcId"
    });
  }
}
const dbMap = networkIdList.reduce((o3, n4) => {
  o3[n4] = null;
  return o3;
}, {});
const getDB = async (networkId2) => {
  let db = dbMap[networkId2];
  if (!db) {
    db = new WalletConnectDB(networkId2);
    dbMap[networkId2] = db;
  }
  if (!db.isOpen()) {
    await db.open();
  }
  return db;
};
const getIWalletConnectList = (networkId2) => getDB(networkId2).then((db) => db.walletConnectInfos.toArray());
const disconnectAllConnections$1 = (networkId2, wcIds) => {
  return getDB(networkId2).then((db) => {
    return db.transaction("rw", [db.walletConnectInfos], async (tx) => {
      const peerList = await db.walletConnectInfos.toArray();
      const calls = [];
      console.log("peerlist in disconnect all", peerList);
      for (const peer of peerList) {
        console.log("setting", peer, "to inactive");
        peer.active = false;
        calls.push(db.walletConnectInfos.put(peer));
      }
      await Promise.all(calls);
      return true;
    }).catch((reason) => {
      console.error(reason);
      return false;
    });
  });
};
async function loadWalletConnectConnection(networkId2, address) {
  return await getDB(networkId2).then((db) => db.walletConnectInfos.get(address));
}
const putWalletConnectInfo = (networkId2, wcInfo) => {
  return getDB(networkId2).then((db) => {
    db.walletConnectInfos.put(wcInfo, wcInfo.wcId);
    return true;
  }).catch((error2) => {
    return false;
  });
};
const saveWalletConnectInfo = (networkId2, wcInfo) => {
  return getDB(networkId2).then((db) => {
    return db.transaction("rw", [db.walletConnectInfos], async (tx) => {
      let dbPeerInfo = await db.walletConnectInfos.get(wcInfo.wcId);
      if (!dbPeerInfo) {
        dbPeerInfo = wcInfo;
        const calls = [];
        calls.push(db.walletConnectInfos.add(json(dbPeerInfo)));
        await Promise.all(calls);
      }
      return dbPeerInfo;
    });
  });
};
const deleteWalleConnectInfo = async (networkId2, wcId) => {
  console.log("delete-from-db", wcId);
  await getDB(networkId2).then((db) => db.walletConnectInfos.delete(wcId));
};
const WalletConnectDB$1 = {
  getIWalletConnectList,
  disconnectAllConnections: disconnectAllConnections$1,
  loadWalletConnectConnection,
  saveWalletConnectInfo,
  deleteWalleConnectInfo,
  putWalletConnectInfo
};
const getWCPairings = () => getObjRef(wcPairingKey, []);
const getWCSubscriptions = () => getObjRef(wcSubscriptionKey, []);
const getWCExpirerList = () => getObjRef(wcExpirerKey, []);
const getWCSessions = () => getObjRef(wcSessionKey, []);
const storeId = "walletConnectStore";
const _lastLoadedId = ref("");
const walletConnectDBList = reactive([]);
computed(() => walletConnectDBList.length);
computed(() => walletConnectDBList.filter((peer) => peer.active).length);
const updateWalletConnectList = async (_networkId, force = false) => {
  const networkId$1 = _networkId ?? networkId.value;
  if (networkId$1 === _lastLoadedId.value) {
    if (!force) {
      return false;
    }
  }
  _lastLoadedId.value = networkId$1;
  let dbEntryList = await WalletConnectDB$1.getIWalletConnectList(networkId$1);
  let numRemoved = 0;
  let changed = false;
  for (let i3 = walletConnectDBList.length - 1; i3 >= 0; i3--) {
    const data = walletConnectDBList[i3];
    if (!dbEntryList.some((item) => item.wcId === data.wcId)) {
      walletConnectDBList.splice(i3, 1);
      numRemoved++;
    }
  }
  if (numRemoved > 0) {
    changed = true;
  }
  const newDbEntryList = dbEntryList.filter((wcEntry) => !walletConnectDBList.some((item) => item.wcId === wcEntry.wcId));
  if (newDbEntryList.length > 0) {
    changed = true;
    walletConnectDBList.push(...newDbEntryList);
  }
  let didChangeInfos = false;
  for (const dbWCEntry of dbEntryList) {
    const currentWCInfo = walletConnectDBList.find((data) => data.wcId === dbWCEntry.wcId);
    if (currentWCInfo) {
      didChangeInfos = updateIWalletConnectInfoIfNeeded(currentWCInfo, dbWCEntry) || didChangeInfos;
    }
  }
  return changed || didChangeInfos;
};
const removeWalletConnectInfo = async (walletConnect) => {
  const networkId$1 = networkId.value;
  const walletConnectList = await WalletConnectDB$1.getIWalletConnectList(networkId$1);
  for (const wcInfo of walletConnectList) {
    if (wcInfo.wcId === walletConnect.wcId) {
      await WalletConnectDB$1.deleteWalleConnectInfo(networkId$1, wcInfo.wcId).catch((err) => error(ErrorDB.WalletConnectDB, err));
    }
  }
  await updateWalletConnectList(networkId$1, true);
  await dispatchSignal(doSendUpdateWalletConnectList);
};
const getWalletConnectConnection = (wcId) => {
  return walletConnectDBList.find((wc) => wc.wcId === wcId) ?? null;
};
const getWalletConnectByTopic = (topic) => {
  return walletConnectDBList.find((wc) => {
    var _a;
    return ((_a = wc.session) == null ? void 0 : _a.topic) === topic;
  }) ?? null;
};
const getWalletConnectByPubKey = (pubKey) => {
  return walletConnectDBList.find((wc) => {
    var _a;
    return ((_a = wc.proposal) == null ? void 0 : _a.params.proposer.publicKey) === pubKey;
  }) ?? null;
};
const getWalletConnectBySession = (session) => {
  return walletConnectDBList.find((wc) => {
    var _a;
    return (_a = wc.oldSessions) == null ? void 0 : _a.find((dbSession) => dbSession.session === session);
  }) ?? null;
};
const saveWalletConnect = async (walletConnect) => {
  const networkId$1 = networkId.value;
  const success = await WalletConnectDB$1.putWalletConnectInfo(networkId$1, json(walletConnect));
  await updateWalletConnectList(networkId.value, true);
  await dispatchSignal(doSendUpdateWalletConnectList);
  return success;
};
const disconnectAllConnections = async (networkId$1, wcIds) => {
  console.log("calling disconnect all wallet connect connections", wcIds);
  await WalletConnectDB$1.disconnectAllConnections(networkId$1 ?? networkId.value, wcIds);
  await dispatchSignal(doSendUpdateWalletConnectList);
};
addSignalListener(BroadcastMsgType.updateWalletConnectList, storeId, async () => {
  await updateWalletConnectList(networkId.value, true);
});
const eternlProjectId = "875a716db62d3ce67fdb5effb7347901";
class EternlWalletConnect {
  constructor(networkId2, projectId = eternlProjectId) {
    __publicField(this, "core");
    __publicField(this, "web3wallet", null);
    __publicField(this, "networkId", "mainnet");
    __publicField(this, "doLog", false);
    __publicField(this, "metadata", {
      name: "Eternl Wallet",
      description: "Eternl Wallet Connect client",
      url: "www.eternl.io",
      icons: ["https://eternl.io/icons/favicon-128x128.png"]
    });
    __publicField(this, "proposalMap", []);
    /**
     * Callback to be called when a new session proposal is received.
     *
     * @param _proposal
     * @param _confirmCallback
     */
    __publicField(this, "proposalCallback", (_proposal, _confirmCallback) => {
    });
    __publicField(this, "initWallet", async (reinit = false) => {
      if (!this.web3wallet || reinit) {
        if (reinit) {
          this.core = new bn({
            projectId: eternlProjectId,
            logger: "info"
          });
        }
        this.web3wallet = await ie.init({
          core: this.core,
          metadata: this.metadata
        });
        this.web3wallet.core.pairing.events.on("pairing_delete", ({ _id, _topic }) => {
          if (this.doLog) console.log("EVENT pairing_delete");
        });
        this.web3wallet.core.pairing.events.on("pairing_expire", ({ _id, _topic }) => {
          if (this.doLog) console.log("EVENT pairing_expire");
        });
        this.web3wallet.core.pairing.events.on("pairing_ping", ({ _id, _topic }) => {
          if (this.doLog) console.log("EVENT pairing_ping");
        });
        this.web3wallet.core.pairing.events.on("pairing_delete", ({ _id, _topic }) => {
          if (this.doLog) console.log("EVENT pairing_delete");
        });
        setInterval(async () => {
          var _a, _b, _c, _d, _e2, _f, _g, _h, _i;
          const authRQ = (_a = this.web3wallet) == null ? void 0 : _a.getPendingAuthRequests();
          const authSR = (_b = this.web3wallet) == null ? void 0 : _b.getPendingSessionRequests();
          const authSP = (_c = this.web3wallet) == null ? void 0 : _c.getPendingSessionProposals();
          if (authSP && Object.keys(authSP).length > 0) {
            if (this.doLog) console.log("pending session proposal requests:", authSP);
            for (const propsalName in authSP) {
              const proposal = authSP[propsalName];
              if (!proposal) {
                if (this.doLog) console.log("no proposal found", propsalName);
                continue;
              }
              if (this.doLog) console.log("pubkey for session request proposer:", authSP[propsalName].proposer.publicKey);
              let wcInfo = getWalletConnectConnection(proposal.pairingTopic);
              if (!wcInfo) {
                wcInfo = getWalletConnectByPubKey(proposal.proposer.publicKey);
              }
              if (proposal.pairingTopic && !wcInfo) {
                wcInfo = getWalletConnectBySession(proposal.pairingTopic);
                if (wcInfo) {
                  if (this.doLog) console.log("found by old session topic!");
                }
              }
              if (!wcInfo) {
                await ((_d = this.web3wallet) == null ? void 0 : _d.rejectSession({
                  id: proposal.id,
                  reason: U$2("UNSUPPORTED_ACCOUNTS")
                }));
                throw new Error("authSP: No wallet connect instance found for proposal " + proposal.pairingTopic + "/pub: " + proposal.proposer.publicKey + " session:" + proposal.sessionProperties);
              }
              if (!wcInfo.approved) {
                if (this.doLog) console.log("got auth request from non approved connection. Wait for allowance", proposal);
                continue;
              }
              if (proposal.requiredNamespaces["cip34"].chains) {
                const chain = proposal.requiredNamespaces["cip34"].chains[0];
                const magic = chain.split("-")[1];
                if (magic === "1" && networkId.value !== "preprod" || magic === "2" && networkId.value !== "preview" || magic === "764824073" && networkId.value !== "mainnet") {
                  await ((_e2 = this.web3wallet) == null ? void 0 : _e2.rejectSession({
                    id: proposal.id,
                    reason: U$2("UNSUPPORTED_CHAINS")
                  }));
                  if (wcInfo) {
                    await removeWalletConnectInfo(wcInfo);
                  }
                  return;
                }
              }
              const { accountData } = useWalletAccount(ref(wcInfo.walletId), ref(wcInfo.accountId));
              const stakeKey = (_f = accountData.value) == null ? void 0 : _f.keys.stake[0].cred;
              const stakeInfoKey = getRewardAddressFromCred(stakeKey, networkId.value);
              const namespace = this.buildApprovedNamespace(proposal, stakeInfoKey);
              if (this.doLog) console.log("try to approve auth request with:", proposal.id, namespace);
              try {
                let session = await this.web3wallet.approveSession({
                  id: proposal.id,
                  namespaces: namespace
                });
                if (this.doLog) console.log("created session", session);
                if (this.doLog) console.log("active sessions:", (_g = this.web3wallet) == null ? void 0 : _g.getActiveSessions());
                if (session) {
                  if (this.doLog) console.log("session session.pairingTopic", session.pairingTopic);
                  const dbInfo = getWalletConnectConnection(session.pairingTopic);
                  if (!dbInfo) {
                    if (this.doLog) console.log("no db info found for created pairing", session.pairingTopic);
                    continue;
                  }
                  dbInfo.active = true;
                  if (this.doLog) console.log("OLD topic:", (_h = dbInfo.session) == null ? void 0 : _h.topic);
                  if (this.doLog) console.log("NEW topic:", session.topic);
                  if ((_i = dbInfo.session) == null ? void 0 : _i.topic) {
                    if (!dbInfo.oldSessions) {
                      dbInfo.oldSessions = [];
                    }
                    dbInfo.oldSessions.push({
                      session: dbInfo.session.topic,
                      expiry: dbInfo.session.expiry
                    });
                  }
                  if (dbInfo.oldSessions && dbInfo.oldSessions.length > 0) {
                    dbInfo.oldSessions = dbInfo.oldSessions.filter((entry) => {
                      let b2 = entry.expiry * 1e3 >= now();
                      if (!b2) {
                        if (this.doLog) console.log("REMOVE OLD SESSION", entry);
                      }
                      return b2;
                    });
                  }
                  if (!dbInfo.session) {
                    if (this.doLog) console.log("NO OLD session info found!", session);
                  }
                  dbInfo.session.topic = session.topic;
                  await saveWalletConnect(dbInfo);
                } else {
                  console.log("NO SESSION WAS FOUND");
                }
                delete authSP[propsalName];
                if (this.doLog) console.log("deleted", authSP);
              } catch (error2) {
                if (this.doLog) console.log("error in delete", error2, authSP);
              }
            }
          }
          if (authSR && Object.keys(authSR).length > 0) {
            if (this.doLog) console.log("pending session requests:", authSR);
            for (const sessionProposalName in authSR) {
              const proposal = authSR[sessionProposalName];
              if (this.proposalMap.includes(proposal.id)) {
                continue;
              }
              this.proposalMap.push(proposal.id);
              let dbInfo = getWalletConnectByTopic(proposal.topic);
              if (!dbInfo) {
                dbInfo = getWalletConnectBySession(proposal.topic);
              }
              if (!dbInfo) {
                if (this.doLog) console.log("cannot respond to", proposal, "as no db info found");
                continue;
              }
              if (this.doLog) console.log("checking session proposal!", proposal, dbInfo);
              const {
                accountData,
                walletData,
                appAccount,
                appWallet
              } = useWalletAccount(ref(dbInfo.walletId), ref(dbInfo.accountId));
              if (!accountData || !accountData.value || !walletData || !walletData.value) {
                if (this.doLog) console.log("no account or wallet found");
                continue;
              }
              if (this.doLog) console.log("RQ proposal is:", proposal);
              const response = await this.getRequestResponse(proposal.params.request, appAccount.value, appWallet.value);
              if (this.doLog) console.log("response is", response);
              try {
                await this.web3wallet.respondSessionRequest({
                  topic: proposal.topic,
                  response: {
                    id: proposal.id,
                    jsonrpc: proposal.params.request.method,
                    result: response
                  }
                });
              } catch (e2) {
                if (this.doLog) console.log("Error in responding to session request from:", proposal, e2);
              }
            }
          }
          if (authRQ && Object.keys(authRQ).length > 0) {
            if (this.doLog) console.log("pending auth request:", authRQ);
            for (const sessionProposalName in authRQ) {
              const proposal = authRQ[sessionProposalName];
              if (this.doLog) console.log("checking pending auth request!", proposal);
            }
          }
        }, 1e3);
      }
      if (this.doLog) console.log("active connections ", this.web3wallet.getActiveSessions());
    });
    __publicField(this, "setProposalCallback", (func) => {
      this.proposalCallback = func;
    });
    /**
     * Build up a network id string for wallet connect to use.
     * Format: cip34:{NETWORK_ID}-{NETWORK_MAGIC}
     *
     * @param network
     */
    __publicField(this, "getCip34NetworkId", (network) => {
      const tmp = getWCChain(network);
      return "cip34:" + tmp.networkId + "-" + tmp.networkMagic;
    });
    /**
     * Build account key string
     * Format: {CIP_NETWORK}:{STAKE_KEY}
     * @param network
     * @param stakeKey
     */
    __publicField(this, "getCip34AccountId", (network, stakeKey) => {
      return this.getCip34NetworkId(network) + ":" + stakeKey;
    });
    __publicField(this, "buildApprovedNamespace", (params, stakeKey) => {
      const namespace = params.requiredNamespaces;
      const newNamespace = {};
      const accountId = this.getCip34AccountId(this.networkId, stakeKey);
      const allowedChains = [this.getCip34NetworkId(networkId.value)];
      for (const name2 in namespace) {
        newNamespace[name2] = {
          chains: allowedChains,
          //namespace[name].chains ?? [],
          methods: namespace[name2].methods,
          events: namespace[name2].events,
          accounts: [accountId]
        };
      }
      let params1 = {
        proposal: params,
        supportedNamespaces: newNamespace
      };
      if (this.doLog) console.log("approve namespace for build approve", params1);
      return Wr$1(params1);
    });
    __publicField(this, "extendSession", async (topic) => {
      var _a;
      if (!this.web3wallet) {
        await this.initWallet();
      }
      const wcInfo = getWalletConnectByTopic(topic);
      if (!wcInfo) {
        throw new Error(`No WalletConnect db instance found. (topic: ${topic} )`);
      }
      if (this.doLog) console.log("active pairings in extendSession", (_a = this.web3wallet) == null ? void 0 : _a.core.pairing.getPairings());
      return await this.web3wallet.extendSession({ topic }).catch(async (e2) => {
        if (this.doLog) console.log("--- Error extending session", e2);
        if (e2.message && e2.message.includes("No matching key. session topic doesn't exist: ")) {
          if (this.doLog) console.log("It seems the DApp is closed ?", topic);
          wcInfo.active = false;
          wcInfo.connectError = "Could not connect to DApp. Is the DApp still open ?";
          await saveWalletConnect(wcInfo);
        }
      });
    });
    /**
     * Update the connection, notify of an account (stake key) change
     * @param info
     * @param stakeKey
     */
    __publicField(this, "emitSessionAccountChangeEvent", async (info, stakeKey) => {
      var _a;
      if (!this.web3wallet) {
        await this.initWallet();
      }
      const sessionNamespace = this.buildApprovedNamespace(info.proposal.params, stakeKey);
      await this.web3wallet.updateSession({ topic: (_a = info == null ? void 0 : info.session) == null ? void 0 : _a.topic, namespaces: sessionNamespace });
    });
    /**
     * Activate a previously created pairing.
     * @param topic
     */
    __publicField(this, "activate", async (topic) => {
      if (!this.web3wallet) {
        await this.initWallet();
      }
      this.addEventListeners();
      await this.web3wallet.core.pairing.activate({ topic });
    });
    __publicField(this, "ping", async (topic) => {
      if (!this.web3wallet) {
        await this.initWallet();
      }
      try {
        let success = true;
        await this.web3wallet.engine.signClient.ping({ topic }).catch((_error) => {
          success = false;
        });
        return success;
      } catch (e2) {
        return false;
      }
    });
    /**
     * Update the connection, notify of an account (stake key) change
     * @param topic
     * @param sessionProposal
     * @param stakeKey
     */
    __publicField(this, "updateSession", async (topic, sessionProposal, stakeKey) => {
      if (this.doLog) {
        console.log("update session topic", topic);
        console.log("update session proposal", sessionProposal);
        console.log("update session stake key", stakeKey);
      }
      if (!this.web3wallet) {
        await this.initWallet();
      }
      if (this.doLog) {
        console.log("try to update session with topic", topic);
        console.log("proposal is", sessionProposal);
      }
      const info = getWalletConnectConnection(topic);
      if (this.doLog) console.log("info from db is", info);
      if (this.doLog) console.log("activate session with", info == null ? void 0 : info.wcId);
      const aR = await this.web3wallet.core.pairing.activate({ topic: info == null ? void 0 : info.wcId });
      if (this.doLog) console.log("aR", aR);
    });
    __publicField(this, "eventsAdded", false);
    __publicField(this, "addEventListeners", () => {
      if (!this.web3wallet) {
        if (this.doLog) console.log("no web3 wallet found");
        return;
      }
      if (this.eventsAdded) return;
      this.web3wallet.on("session_delete", async (state) => {
        if (this.doLog) console.log("Session session_delete: ", state);
        const info = getWalletConnectByTopic(state.topic);
        if (info) {
          if (this.doLog) console.log("session delete closes", info);
          info.active = false;
          await saveWalletConnect(info);
        } else {
          if (this.doLog) console.log("no session found to close");
        }
      });
      this.web3wallet.on("auth_request", (state) => {
        if (this.doLog) console.log("Session auth_request: ", state);
      });
      this.web3wallet.on("session_proposal", async (proposal) => {
        if (this.doLog) console.log("on session_proposal", proposal);
        const confirmCallback = async (confirmed) => {
          var _a, _b;
          if (this.doLog) console.log("confirm callback was called", confirmed);
          const wcInfo = getWalletConnectConnection(proposal.params.pairingTopic);
          if (!wcInfo) {
            throw new Error("session_proposal: No wallet connect instance found for proposal " + proposal.params.pairingTopic);
          }
          const { accountData } = useWalletAccount(ref(wcInfo.walletId), ref(wcInfo.accountId));
          const stakeKey = (_a = accountData.value) == null ? void 0 : _a.keys.stake[0].cred;
          const stakeInfoKey = getRewardAddressFromCred(stakeKey, networkId.value);
          let sessionNamespace = null;
          try {
            sessionNamespace = this.buildApprovedNamespace(proposal.params, stakeInfoKey);
          } catch (error2) {
            if (error2.message && error2.message.includes("approve() namespaces chains don't satisfy required namespaces")) {
              wcInfo.connectError = "Wrong network, you are trying to connect to the wrong chain.";
              await removeWalletConnectInfo(wcInfo);
            } else {
              wcInfo.connectError = error2.message;
            }
            await saveWalletConnect(wcInfo);
            return;
          }
          wcInfo.session = {
            id: proposal.id,
            topic: proposal.params.pairingTopic,
            expiry: proposal.params.expiry ?? 0
          };
          wcInfo.dAppInfo = {
            description: proposal.params.proposer.metadata.description,
            icons: proposal.params.proposer.metadata.icons,
            name: proposal.params.proposer.metadata.name,
            url: proposal.params.proposer.metadata.url,
            pubKey: proposal.params.proposer.publicKey
          };
          wcInfo.proposal = proposal;
          if (confirmed) {
            if (this.doLog) console.log("in ExtWalletConnect connection was accepted");
            if (this.web3wallet) {
              if (this.doLog) console.log("approve proposal information", wcInfo);
              if (!sessionNamespace) {
                if (this.doLog) console.log("No session namespace found!");
                return;
              }
              setTimeout(async () => {
                var _a2, _b2;
                let session = null;
                try {
                  if (this.doLog) console.log("before namespace", {
                    id: proposal.id,
                    namespaces: sessionNamespace
                  });
                  if (this.doLog) console.log("before approve session, list:", (_a2 = this.web3wallet) == null ? void 0 : _a2.core.pairing.getPairings());
                  session = await this.web3wallet.approveSession({
                    id: proposal.id,
                    namespaces: sessionNamespace
                  });
                  wcInfo.lastActive = Date.now();
                  await saveWalletConnect(wcInfo);
                  console.log("SESSION APPROVE", session, now());
                  console.log("session after approveSession", session);
                  if (session) {
                    wcInfo.session.topic = session.topic;
                    wcInfo.session.expiry = session.expiry;
                    wcInfo.connectError = "";
                    wcInfo.active = true;
                    wcInfo.approved = true;
                    await saveWalletConnect(wcInfo);
                  }
                } catch (e2) {
                  if (this.doLog) console.log("e15 error", e2);
                }
                if (this.doLog) console.log("2 after approve session, list:", (_b2 = this.web3wallet) == null ? void 0 : _b2.core.pairing.getPairings());
                if (this.doLog) console.log("BBBB");
                await saveWalletConnect(wcInfo);
                if (this.doLog) {
                  console.log("approve result, session:", session);
                  console.log("approve result, wcInfo:", wcInfo);
                }
              }, 500);
            } else {
              if (this.doLog) console.log("web 3 wallet is null");
            }
          } else {
            if (this.doLog) console.log("user declined the connect");
            wcInfo.approved = false;
            wcInfo.connectError = "Session approval was rejected.";
            await ((_b = this.web3wallet) == null ? void 0 : _b.rejectSession({
              id: proposal.id,
              reason: U$2("USER_REJECTED")
            }));
            await saveWalletConnect(wcInfo);
            await removeWalletConnectInfo(wcInfo);
          }
        };
        this.proposalCallback(proposal, confirmCallback);
      });
      this.eventsAdded = true;
    });
    __publicField(this, "getRequestResponse", async (request, account, wallet) => {
      let result = null;
      switch (request.method) {
        case "cardano_signTx":
          if (this.doLog) console.log("cardano_signTx request is", request);
          const tx = request.params[0];
          const partial = request.params[1];
          setApiRequest({
            reqId: getRandomId(),
            api: METHOD.signTx,
            payload: {
              origin: window.origin,
              txList: [{ cbor: tx, partialSign: partial }]
            }
          });
          try {
            const witnessSetList = await prepareTx(account, wallet.data.wallet.id);
            if (!Array.isArray(witnessSetList) || witnessSetList.length === 0) {
              throw ErrorSignTx.failedToSign;
            }
            result = witnessSetList[0];
          } catch (e2) {
            console.error(e2);
            result = {
              success: false,
              error: e2
            };
          }
          break;
        case "cardano_signData":
          if (this.doLog) console.log("cardano_signData request is", request);
          const dataAddr = request.params[0];
          const payload = request.params[1];
          setApiRequest({
            reqId: getRandomId(),
            api: METHOD.signData,
            payload: {
              origin: window.origin,
              addr: dataAddr ?? null,
              sigStructure: payload ?? null
            }
          });
          try {
            result = await prepareData(account);
          } catch (e2) {
            result = {
              success: false,
              error: e2
            };
          }
          break;
        case "cardano_submitTx":
          if (this.doLog) console.log("cardano_submitTx request is", request);
          result = await cip30_submitTx(networkId.value, request.params[0]);
          break;
        case "cardano_getBalance":
          result = await cip30_getBalance(account);
          break;
        case "cardano_getCollateral":
          result = await cip30_getCollateral(account);
          break;
        case "cardano_getUtxos":
          result = cip30_getUtxos(
            account,
            cip30_getAmount([request.params[0] ?? null]),
            cip30_getPaginate([request.params[1] ?? null])
          );
          if (this.doLog) console.log("utxos are", result);
          break;
        case "cardano_getNetworkId":
          result = cip30_getNetworkId(this.networkId) ?? 1;
          break;
        case "cardano_getUsedAddresses":
          if (this.doLog) console.log("");
          result = cip30_getUsedAddresses(account, {
            page: 0,
            limit: 10
          });
          break;
        case "cardano_getUnusedAddresses":
          result = cip30_getUnusedAddresses(account);
          break;
        case "cardano_getForcedUnusedAddresses":
          result = cip30_getForcedUnusedAddresses(account);
          break;
        case "cardano_getChangeAddress":
          result = cip30_getChangeAddress(account);
          break;
        case "cardano_getRewardAddress":
          const rewardAddresses = cip30_getRewardAddresses(account);
          result = rewardAddresses[0];
          break;
        case "cardano_getRewardAddresses":
          result = cip30_getRewardAddresses(account);
          break;
      }
      if (this.doLog) console.log("RESULT:", result);
      return result;
    });
    __publicField(this, "connect", async (dAppIdentifier) => {
      if (this.doLog) console.log("in WalletConnect connect", dAppIdentifier);
      if (!this.web3wallet) {
        await this.initWallet();
      }
      this.addEventListeners();
      const res = await this.web3wallet.core.pairing.pair({ uri: dAppIdentifier, activatePairing: true });
      if (this.doLog) console.log("pairing response is", res);
      if (!res.active) {
        if (this.doLog) console.log("Try activating old pairing!");
        await this.activate(res.topic);
      }
    });
    __publicField(this, "disconnect", async (wcInfo, terminatePairing = false) => {
      var _a, _b;
      if (!this.web3wallet) {
        if (this.doLog) console.log("No wallet connect instance found, can not disconnect.");
        return;
      }
      if ((_a = wcInfo == null ? void 0 : wcInfo.session) == null ? void 0 : _a.topic) {
        if (this.doLog) console.log("calling disconnect with", wcInfo == null ? void 0 : wcInfo.session);
        try {
          const res = await this.web3wallet.disconnectSession({
            topic: wcInfo.session.topic,
            reason: U$2("USER_DISCONNECTED")
          });
          if (terminatePairing) {
            (_b = this.web3wallet) == null ? void 0 : _b.core.pairing.disconnect({ topic: wcInfo.wcId });
          }
          if (this.doLog) console.log("response of disconnect", res);
        } catch (e2) {
          if (this.doLog) console.log("Error in disconnect", e2);
        }
      } else {
        if (this.doLog) console.log("No session info found, can not disconnect.", wcInfo.wcId);
      }
    });
    this.core = new bn({ projectId });
    this.networkId = networkId2;
  }
}
const buildWalletConnectParams = (connectionId) => {
  if (connectionId.includes(":")) {
    const tmp = connectionId.split(":");
    if (tmp.length !== 2 || tmp[0] !== "wc") {
      return null;
    }
    const idAndParam = tmp[1].split("?");
    const idAndVersion = idAndParam[0].split("@");
    if (idAndVersion.length >= 2 && idAndParam.length >= 2) {
      const id = idAndVersion[0];
      const version2 = Number(idAndVersion[1]);
      const params = new URLSearchParams(idAndParam[1]);
      let obj = {};
      for (let [key2, value] of params.entries()) {
        obj[key2] = value;
      }
      return {
        id,
        version: version2,
        params: obj
      };
    }
    return null;
  }
  return null;
};
const buildWalletConnectUrl = (params) => {
  let string2 = "wc:";
  let param = "";
  for (const paramKey in params.params) {
    param += paramKey + "=" + params.params[paramKey] + "&";
  }
  string2 += params.id + "@" + params.version + "?" + param;
  return string2;
};
const useWalletConnect = (walletConnectId) => {
  var _a, _b, _c, _d, _e2;
  const storeId2 = "useWalletConnect" + getRandomId();
  if (!walletConnectId.value) return;
  const walletConnectInfo = ref(getWalletConnectConnection(walletConnectId.value));
  const walletId = computed(() => {
    var _a2;
    return ((_a2 = walletConnectInfo.value) == null ? void 0 : _a2.walletId) ?? null;
  });
  const accountId = computed(() => {
    var _a2;
    return ((_a2 = walletConnectInfo.value) == null ? void 0 : _a2.accountId) ?? null;
  });
  let walletName = "";
  let accountName = "";
  if (walletConnectInfo.value && walletConnectInfo.value) {
    const {
      walletData,
      accountData
    } = useWalletAccount(walletId, accountId);
    walletName = ((_a = walletData.value) == null ? void 0 : _a.settings.name) ?? ((_c = (_b = walletData.value) == null ? void 0 : _b.wallet.legacySettings) == null ? void 0 : _c.name) ?? "unknown wallet";
    accountName = ((_d = accountData.value) == null ? void 0 : _d.settings.name) ?? "Account #" + String((_e2 = accountData.value) == null ? void 0 : _e2.keys.path[2]) ?? "unknown account";
  }
  const update2 = (id) => {
    walletConnectInfo.value = getWalletConnectConnection(id);
  };
  const saveConnectionStatus = async (connected) => {
    var _a2;
    console.log("setting connection status", (_a2 = walletConnectInfo.value) == null ? void 0 : _a2.wcId, connected);
    if (!walletConnectInfo.value) {
      throw new Error("No wallet connect information!");
    }
    walletConnectInfo.value.active = connected;
    await saveWalletConnect(walletConnectInfo.value);
  };
  watch$3(walletConnectId, (value) => {
    update2(value);
  }, { immediate: true });
  addSignalListener(onAllConnectionsDisconnected, storeId2, () => {
    update2(walletConnectId.value);
  });
  addSignalListener(onWalletConnectSaved, storeId2, () => {
    update2(walletConnectId.value);
  });
  addSignalListener(onWalletConnectAdded, storeId2, (payload) => {
    if (payload.added.find((peer) => peer.peerDappInfo.address === walletConnectId.value)) {
      update2(walletConnectId.value);
    }
  });
  return {
    walletConnectInfo,
    saveConnectionStatus,
    accountName,
    walletName
  };
};
const _WalletConnectManager = class _WalletConnectManager {
  constructor() {
    __publicField(this, "walletConnect", null);
    __publicField(this, "managerInitializing", ref(true));
    __publicField(this, "quasar");
    // stores the current displayed notification for a dapp
    __publicField(this, "notifyIds", /* @__PURE__ */ new Map());
    // stores the timeouts that are used to clear the notifications for a dapp
    __publicField(this, "notifyIdsTimeouts", /* @__PURE__ */ new Map());
    // The UUID of the current tab
    __publicField(this, "instanceUUID");
    __publicField(this, "debug", false);
    __publicField(this, "proposalCallback", (proposal, confirmCallback) => {
    });
    __publicField(this, "setProposalCallback", async (networkId2, func) => {
      this.proposalCallback = func;
      if (!this.walletConnect) {
        await this.initWalletConnect(networkId2);
      }
      this.walletConnect.setProposalCallback(func);
    });
    __publicField(this, "log", (...list) => {
      if (this.debug) {
        console.log(list);
      }
    });
    __publicField(this, "setQuasar", (q2) => {
      this.quasar = q2;
    });
    __publicField(this, "getWalletConnectConnection", (dAppAddress) => {
      return this.walletConnect;
    });
    /**
     * Injects the wallet/account into the wallet connect instance from wcInfo.
     *
     * @param wcInfo
     * @param wallet
     * @param accountData
     */
    __publicField(this, "injectNewApi", async (wcInfo, wallet, accountData) => {
      var _a;
      this.log("inject new api for", wcInfo);
      const stakeKey = accountData.keys.stake[0] ?? null;
      if (!stakeKey) {
        return;
      }
      const stakeInfoKey = getRewardAddressFromCred(stakeKey.cred, networkId.value);
      await ((_a = this.walletConnect) == null ? void 0 : _a.emitSessionAccountChangeEvent(wcInfo, stakeInfoKey));
    });
    /**
     * Calls disconnect on the wallet connect instance
     * @param wcIdentifier
     * @param terminatePairing
     */
    __publicField(this, "disconnect", async (wcIdentifier, terminatePairing = false) => {
      var _a, _b, _c, _d;
      const info = (_a = useWalletConnect(ref(wcIdentifier))) == null ? void 0 : _a.walletConnectInfo;
      if (!info || !info.value) {
        this.log("No info found to disconnect", wcIdentifier);
        return;
      }
      if (!((_b = info.value.session) == null ? void 0 : _b.topic)) {
        this.log("No session topic found for wallet connect target", (_c = info == null ? void 0 : info.value) == null ? void 0 : _c.wcId);
        return;
      }
      try {
        await ((_d = this.walletConnect) == null ? void 0 : _d.disconnect(info.value, terminatePairing));
      } catch (e2) {
        this.log("error in wallet connect disconnect", e2);
      } finally {
        info.value.active = false;
        await saveWalletConnect(info.value);
      }
    });
    __publicField(this, "deleteConnection", async (peerInfo) => {
      try {
        await this.disconnect(peerInfo.wcId, true);
      } catch (e2) {
      } finally {
        await removeWalletConnectInfo(peerInfo);
      }
    });
    __publicField(this, "notify", (dappId, name2 = null, message, type = "positive", extraTimeout = 0) => {
      const timeoutDelay = 2e3 + (type === "negative" ? 1e3 : 0) + extraTimeout;
      if (this.notifyIds.has(dappId)) {
        const oldTimeout = this.notifyIdsTimeouts.get(dappId);
        if (oldTimeout) {
          clearTimeout(oldTimeout);
        }
        const oldNotify = this.notifyIds.get(dappId);
        if (oldNotify.toString().includes("forbidden")) {
          this.notifyIds.delete(dappId);
          this.notifyIdsTimeouts.delete(dappId);
          if (!this.quasar) {
            if (this.debug) console.log("No frontend connection found.");
            return;
          }
          const newNotify = this.quasar.notify({
            progress: type === "ongoing",
            type,
            message: name2 ?? "",
            caption: message,
            position: "top-left",
            timeout: timeoutDelay
          });
          this.notifyIds.set(dappId, newNotify);
        } else {
          oldNotify({
            progress: type === "ongoing",
            type,
            message: name2 ?? "",
            caption: message,
            timeout: timeoutDelay
          });
        }
        this.notifyIdsTimeouts.set(dappId, setTimeout(() => {
          this.notifyIds.delete(dappId);
          this.notifyIdsTimeouts.delete(dappId);
        }, timeoutDelay - 10));
      } else {
        if (!this.quasar) {
          if (this.debug) console.log("No frontend connection found.");
          return;
        }
        const newNotify = this.quasar.notify({
          progress: type === "ongoing",
          type,
          message: name2 ?? "",
          caption: message,
          position: "top-left",
          timeout: timeoutDelay
        });
        this.notifyIds.set(dappId, newNotify);
        this.notifyIdsTimeouts.set(dappId, setTimeout(() => {
          this.notifyIds.delete(dappId);
          this.notifyIdsTimeouts.delete(dappId);
        }, timeoutDelay - 10));
      }
    });
    /**
     * @param networkId
     * @param wallet
     * @param account
     * @param connectionParams
     */
    __publicField(this, "initConnection", async (networkId2, wallet, account, connectionParams) => {
      var _a, _b, _c, _d;
      this.log("calling initConnection", networkId2, wallet, account, connectionParams);
      let wcInfo = (_a = useWalletConnect(ref(connectionParams.id))) == null ? void 0 : _a.walletConnectInfo.value;
      if (!wcInfo) {
        this.log("Wallet connect instance not found!");
        wcInfo = {
          wcId: connectionParams.id,
          version: connectionParams.version,
          connectionParams: connectionParams.params,
          walletId: wallet.wallet.id,
          accountId: account.account.id,
          active: false,
          created: now()
        };
        await saveWalletConnect(wcInfo);
      }
      this.initWalletConnect(networkId2);
      this.log("did create new connection", this.walletConnect);
      if (!this.walletConnect) {
        throw new Error("No wallet connect instance created.");
      }
      const fullConnectUrl = buildWalletConnectUrl(connectionParams);
      this.log("try to connect to", fullConnectUrl);
      try {
        await this.walletConnect.connect(fullConnectUrl);
      } catch (error2) {
        this.log("error when connection ", error2);
        if ((_b = error2.message) == null ? void 0 : _b.includes("Pairing already exists")) {
          wcInfo.connectError = "Please reload the DApp and try again.";
          this.notify(wcInfo.wcId, "Reload DApp", "Please reload the DApp and try again.", "warning");
          await saveWalletConnect(wcInfo);
          await removeWalletConnectInfo(wcInfo);
        } else {
          try {
            this.log("2 try activation with main id", wcInfo.wcId);
            const res = await this.walletConnect.activate(wcInfo.wcId);
            this.log("res of activate ", res);
          } catch (e2) {
            this.log("2 error in activate", e2);
            try {
              this.log("try activation with last pairing topic", (_c = wcInfo.session) == null ? void 0 : _c.topic);
              const res2 = await this.walletConnect.activate((_d = wcInfo.session) == null ? void 0 : _d.topic);
              this.log("2 res of activate ", res2);
            } catch (e22) {
              this.log("3 error in activate", e22);
            }
          }
        }
      }
      return wcInfo;
    });
    __publicField(this, "extendSession", async (networkId2, wallet, account, topic) => {
      if (!this.walletConnect) {
        this.initWalletConnect(networkId2);
      }
      try {
        this.log("try to extend the session", topic);
        const res2 = await this.walletConnect.extendSession(topic);
        this.log("2 res of activate ", res2);
      } catch (e2) {
        this.log("3 error in activate", e2);
      }
    });
    __publicField(this, "updateSession", async (networkId2, wallet, account, connectionInfo, stakeKey) => {
      var _a, _b;
      this.log("update session", networkId2, wallet, account, connectionInfo, stakeKey);
      if (!this.walletConnect) {
        this.initWalletConnect(networkId2);
      }
      try {
        this.log("try to update session topic", connectionInfo);
        const res2 = await this.walletConnect.updateSession(((_a = connectionInfo.proposal) == null ? void 0 : _a.params.pairingTopic) ?? ((_b = connectionInfo.session) == null ? void 0 : _b.topic), connectionInfo.proposal, stakeKey);
        this.log("res of update session ", res2);
      } catch (e2) {
        this.log("error in update session", e2);
      }
    });
    __publicField(this, "changeWallet", async (networkId2, wallet, account, connectionInfo, stakeKey) => {
      var _a, _b;
      this.log("update session", networkId2, wallet, account, connectionInfo, stakeKey);
      if (!this.walletConnect) {
        this.initWalletConnect(networkId2);
      }
      try {
        this.log("try to update session topic", connectionInfo);
        const res2 = await this.walletConnect.updateSession(((_a = connectionInfo.proposal) == null ? void 0 : _a.params.pairingTopic) ?? ((_b = connectionInfo.session) == null ? void 0 : _b.topic), connectionInfo.proposal, stakeKey);
        this.log("res of update session ", res2);
      } catch (e2) {
        console.error("error in update session", e2);
      }
    });
    __publicField(this, "ping", async (networkId2, connectionInfo, stakeKey) => {
      var _a, _b, _c;
      this.log("update session", networkId2, connectionInfo, stakeKey);
      if (!this.walletConnect) {
        this.initWalletConnect(networkId2);
      }
      try {
        this.log("try to ping: topic", connectionInfo);
        const res2 = await this.walletConnect.ping((_a = connectionInfo.session) == null ? void 0 : _a.topic);
        this.log("res of ping: ", res2);
        if (res2) {
          (_c = this.walletConnect) == null ? void 0 : _c.extendSession((_b = connectionInfo.session) == null ? void 0 : _b.topic);
        } else {
          this.log("res is:", res2);
        }
      } catch (e2) {
        console.error("error in ping session", e2);
      }
    });
    __publicField(this, "connect", async (peerConnect, dAppIdentifier, broadcast = true) => {
      return null;
    });
    __publicField(this, "timeout");
    __publicField(this, "networkId", "mainnet");
    __publicField(this, "pingIntervals", {});
    __publicField(this, "pingAttempts", {});
    this.quasar = useQuasarInternal().getQuasar();
    this.instanceUUID = getRandomUUID();
    this.log("constructing wallet connect manager!");
    addSignalListener(BroadcastMsgType.forceWCDisconnect, "walletConnectManager", async (data) => {
      this.log("Got disconnect broadcast message for", data);
      await this.disconnect(data, false);
    });
    addSignalListener(BroadcastMsgType.forceWCConnect, "walletConnectManager", async (data) => {
      this.log("Got connect broadcast message for", data);
      this.getWalletConnectConnection(data);
    });
    if (this.debug) {
      const pairs = getWCPairings();
      console.log("pairs are", pairs.value);
      const subscriptions = getWCSubscriptions();
      console.log("subscriptions", subscriptions.value);
      const expirerList = getWCExpirerList();
      console.log("expirerList", expirerList.value);
      const getWCSessionKey = getWCSessions();
      console.log("getWCSessionKey", getWCSessionKey.value);
    }
  }
  initWalletConnect(networkId2, reinit = false) {
    if (this.walletConnect === null || reinit) {
      this.walletConnect = new EternlWalletConnect(networkId2);
    }
  }
  async init(networkId2) {
    await updateWalletConnectList(networkId2, true);
    this.networkId = networkId2;
    this.managerInitializing.value = true;
    this.log("___________START UP WALLET CONNECT CONNECTIONS___________");
    if (!this.walletConnect) {
      await this.initWalletConnect(networkId2);
    }
    const peers = walletConnectDBList;
    for (let key2 of peers.keys()) {
      this.log("wallet connect init start peer:", peers[key2]);
      this.pingIntervals[key2] = setInterval(async () => {
        var _a, _b, _c, _d, _e2;
        if (!this.pingAttempts[key2]) {
          this.pingAttempts[key2] = 1;
        } else {
          this.pingAttempts[key2] = this.pingAttempts[key2] + 1;
        }
        if (this.managerInitializing.value) {
          this.log("wait for manager to initialize");
          return;
        }
        this.log("try to ping", peers[key2].wcId, (_a = peers[key2].session) == null ? void 0 : _a.topic);
        if (!this.walletConnect) {
          this.log("no wallet connect instance to do ping!");
        }
        try {
          const res = await ((_c = this.walletConnect) == null ? void 0 : _c.ping((_b = peers[key2].session) == null ? void 0 : _b.topic));
          if (res) {
            this.log("clear the ping interval", peers[key2].wcId);
            (_e2 = this.walletConnect) == null ? void 0 : _e2.extendSession((_d = peers[key2].session) == null ? void 0 : _d.topic);
            clearInterval(this.pingIntervals[key2]);
          } else {
            if (this.pingAttempts[key2] >= 5) {
              clearInterval(this.pingIntervals[key2]);
            }
          }
        } catch (e2) {
          if (this.pingAttempts[key2] >= 5) {
            clearInterval(this.pingIntervals[key2]);
          }
        }
      }, 1e3);
    }
    this.managerInitializing.value = false;
    return void 0;
  }
  /**
   * This function must be fast, as the browser could kill it early.
   * Therefore we first call service worker to release the connections handled by.
   * Then we mark the managed connections as disconnected.
   * Then we call the disconnect on the instances itself.
   */
  async disconnectAll() {
    var _a;
    let value = walletConnectDBList;
    if (value && value.length === 0) return;
    this.log("disconnectAll current peer connections", value);
    await disconnectAllConnections(this.networkId, value.reduce((ids, peer) => {
      ids.push(peer.wcId);
      return ids;
    }, []));
    for (const valueKey in value) {
      this.log("disconnect key:", value[valueKey]);
      (_a = this.walletConnect) == null ? void 0 : _a.disconnect(value[valueKey]);
      this.deleteConnection(value[valueKey]);
    }
  }
};
__publicField(_WalletConnectManager, "instance", null);
__publicField(_WalletConnectManager, "debug", true);
__publicField(_WalletConnectManager, "log", (...list) => {
  if (_WalletConnectManager.debug) {
    console.log(list);
  }
});
__publicField(_WalletConnectManager, "getManager", () => {
  if (_WalletConnectManager.instance === null) {
    _WalletConnectManager.instance = new _WalletConnectManager();
  }
  _WalletConnectManager.log("use wallet connect manager with uuid", _WalletConnectManager.instance.instanceUUID);
  return _WalletConnectManager.instance;
});
let WalletConnectManager = _WalletConnectManager;
export {
  WalletConnectManager as W,
  updateWalletConnectList as a,
  buildWalletConnectParams as b,
  saveWalletConnect as s,
  useWalletConnect as u,
  walletConnectDBList as w
};
