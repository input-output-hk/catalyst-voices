var __defProp = Object.defineProperty;
var __defNormalProp = (obj, key2, value) => key2 in obj ? __defProp(obj, key2, { enumerable: true, configurable: true, writable: true, value }) : obj[key2] = value;
var __publicField = (obj, key2, value) => {
  __defNormalProp(obj, typeof key2 !== "symbol" ? key2 + "" : key2, value);
  return value;
};
import { dy as Buffer$1, dz as global, dA as getAugmentedNamespace, dB as eventsExports, dC as getDefaultExportFromCjs, dD as commonjsRequire$1, dE as requireCryptoBrowserify, dF as wipe, dG as binary, dH as sha512, dI as process$1, dJ as hmac, dK as chacha20poly1305, dL as commonjsGlobal, dM as At$2, dN as BN$1, dO as hash, dP as DataError, c8 as json, c3 as Dexie, aH as getObjRef, z as ref, U as reactive, f as computed, K as networkId, bn as dispatchSignal, dQ as doSendUpdateWalletConnectList, aY as addSignalListener, dR as BroadcastMsgType, dS as error, dT as ErrorDB, bf as useWalletAccount, bT as getRewardAddressFromCred, a4 as now, dU as cip30_getRewardAddresses, dV as cip30_getChangeAddress, dW as cip30_getUnusedAddresses, dX as cip30_getUsedAddresses, dY as cip30_getNetworkId, dZ as cip30_getUtxos, d_ as cip30_getPaginate, d$ as cip30_getAmount, e0 as cip30_getCollateral, e1 as cip30_getBalance, e2 as cip30_submitTx, e3 as prepareData, e4 as prepareTx, a$ as ErrorSignTx, e5 as setApiRequest, cw as getRandomId, e6 as METHOD, D as watch$3, e7 as onAllConnectionsDisconnected, e8 as onWalletConnectSaved, e9 as onWalletConnectAdded, ea as useQuasarInternal, eb as getRandomUUID } from "./index.js";
import { n as networkIdList } from "./NetworkId.js";
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
  if (typeof Buffer$1 === void 0) {
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
    options: {},
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
      return Array.from(data.keys());
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
      context.unwatch[mountpoint] = await watch$2(
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
      (r) => r.flat()
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
            (r) => r.map((item) => ({
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
        const keys2 = rawKeys.map((key2) => mount.mountpoint + normalizeKey(key2)).filter((key2) => !maskedMounts.some((p3) => key2.startsWith(p3)));
        allKeys.push(...keys2);
        maskedMounts = [
          mount.mountpoint,
          ...maskedMounts.filter((p3) => !p3.startsWith(mount.mountpoint))
        ];
      }
      return base3 ? allKeys.filter((key2) => key2.startsWith(base3) && !key2.endsWith("$")) : allKeys.filter((key2) => !key2.endsWith("$"));
    },
    // Utils
    async clear(base3, opts = {}) {
      base3 = normalizeBaseKey(base3);
      await Promise.all(
        getMounts(base3, false).map(async (m3) => {
          if (m3.driver.clear) {
            return asyncCall(m3.driver.clear, m3.relativeBase, opts);
          }
          if (m3.driver.removeItem) {
            const keys2 = await m3.driver.getKeys(m3.relativeBase || "", opts);
            return Promise.all(
              keys2.map((key2) => m3.driver.removeItem(key2, opts))
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
        context.mountpoints.sort((a3, b3) => b3.length - a3.length);
      }
      context.mounts[base3] = driver;
      if (context.watching) {
        Promise.resolve(watch$2(driver, onChange, base3)).then((unwatcher) => {
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
      const m3 = getMount(key2);
      return {
        driver: m3.driver,
        base: m3.base
      };
    },
    getMounts(base3 = "", opts = {}) {
      base3 = normalizeKey(base3);
      const mounts = getMounts(base3, opts.parents);
      return mounts.map((m3) => ({
        driver: m3.driver,
        base: m3.mountpoint
      }));
    }
  };
  return storage;
}
function watch$2(driver, onChange, base3) {
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
  } catch (_a2) {
    return value;
  }
}
function safeJsonStringify(value) {
  return typeof value === "string" ? value : JSONStringify(value) || "";
}
const x$3 = "idb-keyval";
var z$4 = (i2 = {}) => {
  const t = i2.base && i2.base.length > 0 ? `${i2.base}:` : "", e = (s) => t + s;
  let n2;
  return i2.dbName && i2.storeName && (n2 = createStore(i2.dbName, i2.storeName)), { name: x$3, options: i2, async hasItem(s) {
    return !(typeof await get(e(s), n2) > "u");
  }, async getItem(s) {
    return await get(e(s), n2) ?? null;
  }, setItem(s, a3) {
    return set$1(e(s), a3, n2);
  }, removeItem(s) {
    return del(e(s), n2);
  }, getKeys() {
    return keys(n2);
  }, clear() {
    return clear(n2);
  } };
};
const D$1 = "WALLET_CONNECT_V2_INDEXED_DB", E$3 = "keyvaluestorage";
let _$2 = class _ {
  constructor() {
    this.indexedDb = createStorage({ driver: z$4({ dbName: D$1, storeName: E$3 }) });
  }
  async getKeys() {
    return this.indexedDb.getKeys();
  }
  async getEntries() {
    return (await this.indexedDb.getItems(await this.indexedDb.getKeys())).map((t) => [t.key, t.value]);
  }
  async getItem(t) {
    const e = await this.indexedDb.getItem(t);
    if (e !== null)
      return e;
  }
  async setItem(t, e) {
    await this.indexedDb.setItem(t, safeJsonStringify(e));
  }
  async removeItem(t) {
    await this.indexedDb.removeItem(t);
  }
};
var l$2 = typeof globalThis < "u" ? globalThis : typeof window < "u" ? window : typeof global < "u" ? global : typeof self < "u" ? self : {}, c$2 = { exports: {} };
(function() {
  let i2;
  function t() {
  }
  i2 = t, i2.prototype.getItem = function(e) {
    return this.hasOwnProperty(e) ? String(this[e]) : null;
  }, i2.prototype.setItem = function(e, n2) {
    this[e] = String(n2);
  }, i2.prototype.removeItem = function(e) {
    delete this[e];
  }, i2.prototype.clear = function() {
    const e = this;
    Object.keys(e).forEach(function(n2) {
      e[n2] = void 0, delete e[n2];
    });
  }, i2.prototype.key = function(e) {
    return e = e || 0, Object.keys(this)[e];
  }, i2.prototype.__defineGetter__("length", function() {
    return Object.keys(this).length;
  }), typeof l$2 < "u" && l$2.localStorage ? c$2.exports = l$2.localStorage : typeof window < "u" && window.localStorage ? c$2.exports = window.localStorage : c$2.exports = new t();
})();
function k$3(i2) {
  var t;
  return [i2[0], safeJsonParse((t = i2[1]) != null ? t : "")];
}
let K$4 = class K {
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
    const e = this.localStorage.getItem(t);
    if (e !== null)
      return safeJsonParse(e);
  }
  async setItem(t, e) {
    this.localStorage.setItem(t, safeJsonStringify(e));
  }
  async removeItem(t) {
    this.localStorage.removeItem(t);
  }
};
const N = "wc_storage_version", y$4 = 1, O$3 = async (i2, t, e) => {
  const n2 = N, s = await t.getItem(n2);
  if (s && s >= y$4) {
    e(t);
    return;
  }
  const a3 = await i2.getKeys();
  if (!a3.length) {
    e(t);
    return;
  }
  const m3 = [];
  for (; a3.length; ) {
    const r = a3.shift();
    if (!r)
      continue;
    const o2 = r.toLowerCase();
    if (o2.includes("wc@") || o2.includes("walletconnect") || o2.includes("wc_") || o2.includes("wallet_connect")) {
      const f3 = await i2.getItem(r);
      await t.setItem(r, f3), m3.push(r);
    }
  }
  await t.setItem(n2, y$4), e(t), j$3(i2, m3);
}, j$3 = async (i2, t) => {
  t.length && t.forEach(async (e) => {
    await i2.removeItem(e);
  });
};
let h$2 = class h {
  constructor() {
    this.initialized = false, this.setInitialized = (e) => {
      this.storage = e, this.initialized = true;
    };
    const t = new K$4();
    this.storage = t;
    try {
      const e = new _$2();
      O$3(t, e, this.setInitialized);
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
  async setItem(t, e) {
    return await this.initialize(), this.storage.setItem(t, e);
  }
  async removeItem(t) {
    return await this.initialize(), this.storage.removeItem(t);
  }
  async initialize() {
    this.initialized || await new Promise((t) => {
      const e = setInterval(() => {
        this.initialized && (clearInterval(e), t());
      }, 20);
    });
  }
};
var cjs$4 = {};
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
var extendStatics$2 = function(d4, b3) {
  extendStatics$2 = Object.setPrototypeOf || { __proto__: [] } instanceof Array && function(d5, b4) {
    d5.__proto__ = b4;
  } || function(d5, b4) {
    for (var p3 in b4)
      if (b4.hasOwnProperty(p3))
        d5[p3] = b4[p3];
  };
  return extendStatics$2(d4, b3);
};
function __extends$2(d4, b3) {
  extendStatics$2(d4, b3);
  function __() {
    this.constructor = d4;
  }
  d4.prototype = b3 === null ? Object.create(b3) : (__.prototype = b3.prototype, new __());
}
var __assign$2 = function() {
  __assign$2 = Object.assign || function __assign2(t) {
    for (var s, i2 = 1, n2 = arguments.length; i2 < n2; i2++) {
      s = arguments[i2];
      for (var p3 in s)
        if (Object.prototype.hasOwnProperty.call(s, p3))
          t[p3] = s[p3];
    }
    return t;
  };
  return __assign$2.apply(this, arguments);
};
function __rest$2(s, e) {
  var t = {};
  for (var p3 in s)
    if (Object.prototype.hasOwnProperty.call(s, p3) && e.indexOf(p3) < 0)
      t[p3] = s[p3];
  if (s != null && typeof Object.getOwnPropertySymbols === "function")
    for (var i2 = 0, p3 = Object.getOwnPropertySymbols(s); i2 < p3.length; i2++) {
      if (e.indexOf(p3[i2]) < 0 && Object.prototype.propertyIsEnumerable.call(s, p3[i2]))
        t[p3[i2]] = s[p3[i2]];
    }
  return t;
}
function __decorate$2(decorators, target, key2, desc) {
  var c2 = arguments.length, r = c2 < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key2) : desc, d4;
  if (typeof Reflect === "object" && typeof Reflect.decorate === "function")
    r = Reflect.decorate(decorators, target, key2, desc);
  else
    for (var i2 = decorators.length - 1; i2 >= 0; i2--)
      if (d4 = decorators[i2])
        r = (c2 < 3 ? d4(r) : c2 > 3 ? d4(target, key2, r) : d4(target, key2)) || r;
  return c2 > 3 && r && Object.defineProperty(target, key2, r), r;
}
function __param$2(paramIndex, decorator) {
  return function(target, key2) {
    decorator(target, key2, paramIndex);
  };
}
function __metadata$2(metadataKey, metadataValue) {
  if (typeof Reflect === "object" && typeof Reflect.metadata === "function")
    return Reflect.metadata(metadataKey, metadataValue);
}
function __awaiter$2(thisArg, _arguments, P2, generator) {
  function adopt(value) {
    return value instanceof P2 ? value : new P2(function(resolve) {
      resolve(value);
    });
  }
  return new (P2 || (P2 = Promise))(function(resolve, reject) {
    function fulfilled(value) {
      try {
        step(generator.next(value));
      } catch (e) {
        reject(e);
      }
    }
    function rejected(value) {
      try {
        step(generator["throw"](value));
      } catch (e) {
        reject(e);
      }
    }
    function step(result) {
      result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected);
    }
    step((generator = generator.apply(thisArg, _arguments || [])).next());
  });
}
function __generator$2(thisArg, body) {
  var _3 = { label: 0, sent: function() {
    if (t[0] & 1)
      throw t[1];
    return t[1];
  }, trys: [], ops: [] }, f3, y3, t, g3;
  return g3 = { next: verb(0), "throw": verb(1), "return": verb(2) }, typeof Symbol === "function" && (g3[Symbol.iterator] = function() {
    return this;
  }), g3;
  function verb(n2) {
    return function(v3) {
      return step([n2, v3]);
    };
  }
  function step(op) {
    if (f3)
      throw new TypeError("Generator is already executing.");
    while (_3)
      try {
        if (f3 = 1, y3 && (t = op[0] & 2 ? y3["return"] : op[0] ? y3["throw"] || ((t = y3["return"]) && t.call(y3), 0) : y3.next) && !(t = t.call(y3, op[1])).done)
          return t;
        if (y3 = 0, t)
          op = [op[0] & 2, t.value];
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
            if (t[2])
              _3.ops.pop();
            _3.trys.pop();
            continue;
        }
        op = body.call(thisArg, _3);
      } catch (e) {
        op = [6, e];
        y3 = 0;
      } finally {
        f3 = t = 0;
      }
    if (op[0] & 5)
      throw op[1];
    return { value: op[0] ? op[1] : void 0, done: true };
  }
}
function __createBinding$2(o2, m3, k2, k22) {
  if (k22 === void 0)
    k22 = k2;
  o2[k22] = m3[k2];
}
function __exportStar$2(m3, exports) {
  for (var p3 in m3)
    if (p3 !== "default" && !exports.hasOwnProperty(p3))
      exports[p3] = m3[p3];
}
function __values$2(o2) {
  var s = typeof Symbol === "function" && Symbol.iterator, m3 = s && o2[s], i2 = 0;
  if (m3)
    return m3.call(o2);
  if (o2 && typeof o2.length === "number")
    return {
      next: function() {
        if (o2 && i2 >= o2.length)
          o2 = void 0;
        return { value: o2 && o2[i2++], done: !o2 };
      }
    };
  throw new TypeError(s ? "Object is not iterable." : "Symbol.iterator is not defined.");
}
function __read$2(o2, n2) {
  var m3 = typeof Symbol === "function" && o2[Symbol.iterator];
  if (!m3)
    return o2;
  var i2 = m3.call(o2), r, ar3 = [], e;
  try {
    while ((n2 === void 0 || n2-- > 0) && !(r = i2.next()).done)
      ar3.push(r.value);
  } catch (error2) {
    e = { error: error2 };
  } finally {
    try {
      if (r && !r.done && (m3 = i2["return"]))
        m3.call(i2);
    } finally {
      if (e)
        throw e.error;
    }
  }
  return ar3;
}
function __spread$2() {
  for (var ar3 = [], i2 = 0; i2 < arguments.length; i2++)
    ar3 = ar3.concat(__read$2(arguments[i2]));
  return ar3;
}
function __spreadArrays$2() {
  for (var s = 0, i2 = 0, il = arguments.length; i2 < il; i2++)
    s += arguments[i2].length;
  for (var r = Array(s), k2 = 0, i2 = 0; i2 < il; i2++)
    for (var a3 = arguments[i2], j2 = 0, jl = a3.length; j2 < jl; j2++, k2++)
      r[k2] = a3[j2];
  return r;
}
function __await$2(v3) {
  return this instanceof __await$2 ? (this.v = v3, this) : new __await$2(v3);
}
function __asyncGenerator$2(thisArg, _arguments, generator) {
  if (!Symbol.asyncIterator)
    throw new TypeError("Symbol.asyncIterator is not defined.");
  var g3 = generator.apply(thisArg, _arguments || []), i2, q2 = [];
  return i2 = {}, verb("next"), verb("throw"), verb("return"), i2[Symbol.asyncIterator] = function() {
    return this;
  }, i2;
  function verb(n2) {
    if (g3[n2])
      i2[n2] = function(v3) {
        return new Promise(function(a3, b3) {
          q2.push([n2, v3, a3, b3]) > 1 || resume(n2, v3);
        });
      };
  }
  function resume(n2, v3) {
    try {
      step(g3[n2](v3));
    } catch (e) {
      settle(q2[0][3], e);
    }
  }
  function step(r) {
    r.value instanceof __await$2 ? Promise.resolve(r.value.v).then(fulfill, reject) : settle(q2[0][2], r);
  }
  function fulfill(value) {
    resume("next", value);
  }
  function reject(value) {
    resume("throw", value);
  }
  function settle(f3, v3) {
    if (f3(v3), q2.shift(), q2.length)
      resume(q2[0][0], q2[0][1]);
  }
}
function __asyncDelegator$2(o2) {
  var i2, p3;
  return i2 = {}, verb("next"), verb("throw", function(e) {
    throw e;
  }), verb("return"), i2[Symbol.iterator] = function() {
    return this;
  }, i2;
  function verb(n2, f3) {
    i2[n2] = o2[n2] ? function(v3) {
      return (p3 = !p3) ? { value: __await$2(o2[n2](v3)), done: n2 === "return" } : f3 ? f3(v3) : v3;
    } : f3;
  }
}
function __asyncValues$2(o2) {
  if (!Symbol.asyncIterator)
    throw new TypeError("Symbol.asyncIterator is not defined.");
  var m3 = o2[Symbol.asyncIterator], i2;
  return m3 ? m3.call(o2) : (o2 = typeof __values$2 === "function" ? __values$2(o2) : o2[Symbol.iterator](), i2 = {}, verb("next"), verb("throw"), verb("return"), i2[Symbol.asyncIterator] = function() {
    return this;
  }, i2);
  function verb(n2) {
    i2[n2] = o2[n2] && function(v3) {
      return new Promise(function(resolve, reject) {
        v3 = o2[n2](v3), settle(resolve, reject, v3.done, v3.value);
      });
    };
  }
  function settle(resolve, reject, d4, v3) {
    Promise.resolve(v3).then(function(v4) {
      resolve({ value: v4, done: d4 });
    }, reject);
  }
}
function __makeTemplateObject$2(cooked, raw) {
  if (Object.defineProperty) {
    Object.defineProperty(cooked, "raw", { value: raw });
  } else {
    cooked.raw = raw;
  }
  return cooked;
}
function __importStar$2(mod) {
  if (mod && mod.__esModule)
    return mod;
  var result = {};
  if (mod != null) {
    for (var k2 in mod)
      if (Object.hasOwnProperty.call(mod, k2))
        result[k2] = mod[k2];
  }
  result.default = mod;
  return result;
}
function __importDefault$2(mod) {
  return mod && mod.__esModule ? mod : { default: mod };
}
function __classPrivateFieldGet$2(receiver, privateMap) {
  if (!privateMap.has(receiver)) {
    throw new TypeError("attempted to get private field on non-instance");
  }
  return privateMap.get(receiver);
}
function __classPrivateFieldSet$2(receiver, privateMap, value) {
  if (!privateMap.has(receiver)) {
    throw new TypeError("attempted to set private field on non-instance");
  }
  privateMap.set(receiver, value);
  return value;
}
const tslib_es6$2 = /* @__PURE__ */ Object.freeze(/* @__PURE__ */ Object.defineProperty({
  __proto__: null,
  get __assign() {
    return __assign$2;
  },
  __asyncDelegator: __asyncDelegator$2,
  __asyncGenerator: __asyncGenerator$2,
  __asyncValues: __asyncValues$2,
  __await: __await$2,
  __awaiter: __awaiter$2,
  __classPrivateFieldGet: __classPrivateFieldGet$2,
  __classPrivateFieldSet: __classPrivateFieldSet$2,
  __createBinding: __createBinding$2,
  __decorate: __decorate$2,
  __exportStar: __exportStar$2,
  __extends: __extends$2,
  __generator: __generator$2,
  __importDefault: __importDefault$2,
  __importStar: __importStar$2,
  __makeTemplateObject: __makeTemplateObject$2,
  __metadata: __metadata$2,
  __param: __param$2,
  __read: __read$2,
  __rest: __rest$2,
  __spread: __spread$2,
  __spreadArrays: __spreadArrays$2,
  __values: __values$2
}, Symbol.toStringTag, { value: "Module" }));
const require$$0$4 = /* @__PURE__ */ getAugmentedNamespace(tslib_es6$2);
var heartbeat$2 = {};
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
var extendStatics$1 = function(d4, b3) {
  extendStatics$1 = Object.setPrototypeOf || { __proto__: [] } instanceof Array && function(d5, b4) {
    d5.__proto__ = b4;
  } || function(d5, b4) {
    for (var p3 in b4)
      if (b4.hasOwnProperty(p3))
        d5[p3] = b4[p3];
  };
  return extendStatics$1(d4, b3);
};
function __extends$1(d4, b3) {
  extendStatics$1(d4, b3);
  function __() {
    this.constructor = d4;
  }
  d4.prototype = b3 === null ? Object.create(b3) : (__.prototype = b3.prototype, new __());
}
var __assign$1 = function() {
  __assign$1 = Object.assign || function __assign2(t) {
    for (var s, i2 = 1, n2 = arguments.length; i2 < n2; i2++) {
      s = arguments[i2];
      for (var p3 in s)
        if (Object.prototype.hasOwnProperty.call(s, p3))
          t[p3] = s[p3];
    }
    return t;
  };
  return __assign$1.apply(this, arguments);
};
function __rest$1(s, e) {
  var t = {};
  for (var p3 in s)
    if (Object.prototype.hasOwnProperty.call(s, p3) && e.indexOf(p3) < 0)
      t[p3] = s[p3];
  if (s != null && typeof Object.getOwnPropertySymbols === "function")
    for (var i2 = 0, p3 = Object.getOwnPropertySymbols(s); i2 < p3.length; i2++) {
      if (e.indexOf(p3[i2]) < 0 && Object.prototype.propertyIsEnumerable.call(s, p3[i2]))
        t[p3[i2]] = s[p3[i2]];
    }
  return t;
}
function __decorate$1(decorators, target, key2, desc) {
  var c2 = arguments.length, r = c2 < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key2) : desc, d4;
  if (typeof Reflect === "object" && typeof Reflect.decorate === "function")
    r = Reflect.decorate(decorators, target, key2, desc);
  else
    for (var i2 = decorators.length - 1; i2 >= 0; i2--)
      if (d4 = decorators[i2])
        r = (c2 < 3 ? d4(r) : c2 > 3 ? d4(target, key2, r) : d4(target, key2)) || r;
  return c2 > 3 && r && Object.defineProperty(target, key2, r), r;
}
function __param$1(paramIndex, decorator) {
  return function(target, key2) {
    decorator(target, key2, paramIndex);
  };
}
function __metadata$1(metadataKey, metadataValue) {
  if (typeof Reflect === "object" && typeof Reflect.metadata === "function")
    return Reflect.metadata(metadataKey, metadataValue);
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
      } catch (e) {
        reject(e);
      }
    }
    function rejected(value) {
      try {
        step(generator["throw"](value));
      } catch (e) {
        reject(e);
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
    if (t[0] & 1)
      throw t[1];
    return t[1];
  }, trys: [], ops: [] }, f3, y3, t, g3;
  return g3 = { next: verb(0), "throw": verb(1), "return": verb(2) }, typeof Symbol === "function" && (g3[Symbol.iterator] = function() {
    return this;
  }), g3;
  function verb(n2) {
    return function(v3) {
      return step([n2, v3]);
    };
  }
  function step(op) {
    if (f3)
      throw new TypeError("Generator is already executing.");
    while (_3)
      try {
        if (f3 = 1, y3 && (t = op[0] & 2 ? y3["return"] : op[0] ? y3["throw"] || ((t = y3["return"]) && t.call(y3), 0) : y3.next) && !(t = t.call(y3, op[1])).done)
          return t;
        if (y3 = 0, t)
          op = [op[0] & 2, t.value];
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
            if (t[2])
              _3.ops.pop();
            _3.trys.pop();
            continue;
        }
        op = body.call(thisArg, _3);
      } catch (e) {
        op = [6, e];
        y3 = 0;
      } finally {
        f3 = t = 0;
      }
    if (op[0] & 5)
      throw op[1];
    return { value: op[0] ? op[1] : void 0, done: true };
  }
}
function __createBinding$1(o2, m3, k2, k22) {
  if (k22 === void 0)
    k22 = k2;
  o2[k22] = m3[k2];
}
function __exportStar$1(m3, exports) {
  for (var p3 in m3)
    if (p3 !== "default" && !exports.hasOwnProperty(p3))
      exports[p3] = m3[p3];
}
function __values$1(o2) {
  var s = typeof Symbol === "function" && Symbol.iterator, m3 = s && o2[s], i2 = 0;
  if (m3)
    return m3.call(o2);
  if (o2 && typeof o2.length === "number")
    return {
      next: function() {
        if (o2 && i2 >= o2.length)
          o2 = void 0;
        return { value: o2 && o2[i2++], done: !o2 };
      }
    };
  throw new TypeError(s ? "Object is not iterable." : "Symbol.iterator is not defined.");
}
function __read$1(o2, n2) {
  var m3 = typeof Symbol === "function" && o2[Symbol.iterator];
  if (!m3)
    return o2;
  var i2 = m3.call(o2), r, ar3 = [], e;
  try {
    while ((n2 === void 0 || n2-- > 0) && !(r = i2.next()).done)
      ar3.push(r.value);
  } catch (error2) {
    e = { error: error2 };
  } finally {
    try {
      if (r && !r.done && (m3 = i2["return"]))
        m3.call(i2);
    } finally {
      if (e)
        throw e.error;
    }
  }
  return ar3;
}
function __spread$1() {
  for (var ar3 = [], i2 = 0; i2 < arguments.length; i2++)
    ar3 = ar3.concat(__read$1(arguments[i2]));
  return ar3;
}
function __spreadArrays$1() {
  for (var s = 0, i2 = 0, il = arguments.length; i2 < il; i2++)
    s += arguments[i2].length;
  for (var r = Array(s), k2 = 0, i2 = 0; i2 < il; i2++)
    for (var a3 = arguments[i2], j2 = 0, jl = a3.length; j2 < jl; j2++, k2++)
      r[k2] = a3[j2];
  return r;
}
function __await$1(v3) {
  return this instanceof __await$1 ? (this.v = v3, this) : new __await$1(v3);
}
function __asyncGenerator$1(thisArg, _arguments, generator) {
  if (!Symbol.asyncIterator)
    throw new TypeError("Symbol.asyncIterator is not defined.");
  var g3 = generator.apply(thisArg, _arguments || []), i2, q2 = [];
  return i2 = {}, verb("next"), verb("throw"), verb("return"), i2[Symbol.asyncIterator] = function() {
    return this;
  }, i2;
  function verb(n2) {
    if (g3[n2])
      i2[n2] = function(v3) {
        return new Promise(function(a3, b3) {
          q2.push([n2, v3, a3, b3]) > 1 || resume(n2, v3);
        });
      };
  }
  function resume(n2, v3) {
    try {
      step(g3[n2](v3));
    } catch (e) {
      settle(q2[0][3], e);
    }
  }
  function step(r) {
    r.value instanceof __await$1 ? Promise.resolve(r.value.v).then(fulfill, reject) : settle(q2[0][2], r);
  }
  function fulfill(value) {
    resume("next", value);
  }
  function reject(value) {
    resume("throw", value);
  }
  function settle(f3, v3) {
    if (f3(v3), q2.shift(), q2.length)
      resume(q2[0][0], q2[0][1]);
  }
}
function __asyncDelegator$1(o2) {
  var i2, p3;
  return i2 = {}, verb("next"), verb("throw", function(e) {
    throw e;
  }), verb("return"), i2[Symbol.iterator] = function() {
    return this;
  }, i2;
  function verb(n2, f3) {
    i2[n2] = o2[n2] ? function(v3) {
      return (p3 = !p3) ? { value: __await$1(o2[n2](v3)), done: n2 === "return" } : f3 ? f3(v3) : v3;
    } : f3;
  }
}
function __asyncValues$1(o2) {
  if (!Symbol.asyncIterator)
    throw new TypeError("Symbol.asyncIterator is not defined.");
  var m3 = o2[Symbol.asyncIterator], i2;
  return m3 ? m3.call(o2) : (o2 = typeof __values$1 === "function" ? __values$1(o2) : o2[Symbol.iterator](), i2 = {}, verb("next"), verb("throw"), verb("return"), i2[Symbol.asyncIterator] = function() {
    return this;
  }, i2);
  function verb(n2) {
    i2[n2] = o2[n2] && function(v3) {
      return new Promise(function(resolve, reject) {
        v3 = o2[n2](v3), settle(resolve, reject, v3.done, v3.value);
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
  if (mod && mod.__esModule)
    return mod;
  var result = {};
  if (mod != null) {
    for (var k2 in mod)
      if (Object.hasOwnProperty.call(mod, k2))
        result[k2] = mod[k2];
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
var utils = {};
var delay = {};
var hasRequiredDelay;
function requireDelay() {
  if (hasRequiredDelay)
    return delay;
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
var constants$1 = {};
var misc = {};
var hasRequiredMisc;
function requireMisc() {
  if (hasRequiredMisc)
    return misc;
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
  if (hasRequiredTime)
    return time;
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
var hasRequiredConstants$1;
function requireConstants$1() {
  if (hasRequiredConstants$1)
    return constants$1;
  hasRequiredConstants$1 = 1;
  (function(exports) {
    Object.defineProperty(exports, "__esModule", { value: true });
    const tslib_1 = require$$0$3;
    tslib_1.__exportStar(requireMisc(), exports);
    tslib_1.__exportStar(requireTime(), exports);
  })(constants$1);
  return constants$1;
}
var hasRequiredConvert;
function requireConvert() {
  if (hasRequiredConvert)
    return convert;
  hasRequiredConvert = 1;
  Object.defineProperty(convert, "__esModule", { value: true });
  convert.fromMiliseconds = convert.toMiliseconds = void 0;
  const constants_1 = requireConstants$1();
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
  if (hasRequiredUtils)
    return utils;
  hasRequiredUtils = 1;
  (function(exports) {
    Object.defineProperty(exports, "__esModule", { value: true });
    const tslib_1 = require$$0$3;
    tslib_1.__exportStar(requireDelay(), exports);
    tslib_1.__exportStar(requireConvert(), exports);
  })(utils);
  return utils;
}
var watch$1 = {};
var hasRequiredWatch$1;
function requireWatch$1() {
  if (hasRequiredWatch$1)
    return watch$1;
  hasRequiredWatch$1 = 1;
  Object.defineProperty(watch$1, "__esModule", { value: true });
  watch$1.Watch = void 0;
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
  watch$1.Watch = Watch;
  watch$1.default = Watch;
  return watch$1;
}
var types$1 = {};
var watch = {};
var hasRequiredWatch;
function requireWatch() {
  if (hasRequiredWatch)
    return watch;
  hasRequiredWatch = 1;
  Object.defineProperty(watch, "__esModule", { value: true });
  watch.IWatch = void 0;
  class IWatch {
  }
  watch.IWatch = IWatch;
  return watch;
}
var hasRequiredTypes$1;
function requireTypes$1() {
  if (hasRequiredTypes$1)
    return types$1;
  hasRequiredTypes$1 = 1;
  (function(exports) {
    Object.defineProperty(exports, "__esModule", { value: true });
    const tslib_1 = require$$0$3;
    tslib_1.__exportStar(requireWatch(), exports);
  })(types$1);
  return types$1;
}
(function(exports) {
  Object.defineProperty(exports, "__esModule", { value: true });
  const tslib_1 = require$$0$3;
  tslib_1.__exportStar(requireUtils(), exports);
  tslib_1.__exportStar(requireWatch$1(), exports);
  tslib_1.__exportStar(requireTypes$1(), exports);
  tslib_1.__exportStar(requireConstants$1(), exports);
})(cjs$3);
var types = {};
var heartbeat$1 = {};
let IEvents$1 = class IEvents {
};
const esm = /* @__PURE__ */ Object.freeze(/* @__PURE__ */ Object.defineProperty({
  __proto__: null,
  IEvents: IEvents$1
}, Symbol.toStringTag, { value: "Module" }));
const require$$0$2 = /* @__PURE__ */ getAugmentedNamespace(esm);
var hasRequiredHeartbeat$2;
function requireHeartbeat$2() {
  if (hasRequiredHeartbeat$2)
    return heartbeat$1;
  hasRequiredHeartbeat$2 = 1;
  Object.defineProperty(heartbeat$1, "__esModule", { value: true });
  heartbeat$1.IHeartBeat = void 0;
  const events_1 = require$$0$2;
  class IHeartBeat extends events_1.IEvents {
    constructor(opts) {
      super();
    }
  }
  heartbeat$1.IHeartBeat = IHeartBeat;
  return heartbeat$1;
}
var hasRequiredTypes;
function requireTypes() {
  if (hasRequiredTypes)
    return types;
  hasRequiredTypes = 1;
  (function(exports) {
    Object.defineProperty(exports, "__esModule", { value: true });
    const tslib_1 = require$$0$4;
    tslib_1.__exportStar(requireHeartbeat$2(), exports);
  })(types);
  return types;
}
var constants = {};
var heartbeat = {};
var hasRequiredHeartbeat$1;
function requireHeartbeat$1() {
  if (hasRequiredHeartbeat$1)
    return heartbeat;
  hasRequiredHeartbeat$1 = 1;
  Object.defineProperty(heartbeat, "__esModule", { value: true });
  heartbeat.HEARTBEAT_EVENTS = heartbeat.HEARTBEAT_INTERVAL = void 0;
  const time_1 = cjs$3;
  heartbeat.HEARTBEAT_INTERVAL = time_1.FIVE_SECONDS;
  heartbeat.HEARTBEAT_EVENTS = {
    pulse: "heartbeat_pulse"
  };
  return heartbeat;
}
var hasRequiredConstants;
function requireConstants() {
  if (hasRequiredConstants)
    return constants;
  hasRequiredConstants = 1;
  (function(exports) {
    Object.defineProperty(exports, "__esModule", { value: true });
    const tslib_1 = require$$0$4;
    tslib_1.__exportStar(requireHeartbeat$1(), exports);
  })(constants);
  return constants;
}
var hasRequiredHeartbeat;
function requireHeartbeat() {
  if (hasRequiredHeartbeat)
    return heartbeat$2;
  hasRequiredHeartbeat = 1;
  Object.defineProperty(heartbeat$2, "__esModule", { value: true });
  heartbeat$2.HeartBeat = void 0;
  const tslib_1 = require$$0$4;
  const events_1 = eventsExports;
  const time_1 = cjs$3;
  const types_1 = requireTypes();
  const constants_1 = requireConstants();
  class HeartBeat extends types_1.IHeartBeat {
    constructor(opts) {
      super(opts);
      this.events = new events_1.EventEmitter();
      this.interval = constants_1.HEARTBEAT_INTERVAL;
      this.interval = (opts === null || opts === void 0 ? void 0 : opts.interval) || constants_1.HEARTBEAT_INTERVAL;
    }
    static init(opts) {
      return tslib_1.__awaiter(this, void 0, void 0, function* () {
        const heartbeat2 = new HeartBeat(opts);
        yield heartbeat2.init();
        return heartbeat2;
      });
    }
    init() {
      return tslib_1.__awaiter(this, void 0, void 0, function* () {
        yield this.initialize();
      });
    }
    stop() {
      clearInterval(this.intervalRef);
    }
    on(event, listener) {
      this.events.on(event, listener);
    }
    once(event, listener) {
      this.events.once(event, listener);
    }
    off(event, listener) {
      this.events.off(event, listener);
    }
    removeListener(event, listener) {
      this.events.removeListener(event, listener);
    }
    initialize() {
      return tslib_1.__awaiter(this, void 0, void 0, function* () {
        this.intervalRef = setInterval(() => this.pulse(), time_1.toMiliseconds(this.interval));
      });
    }
    pulse() {
      this.events.emit(constants_1.HEARTBEAT_EVENTS.pulse);
    }
  }
  heartbeat$2.HeartBeat = HeartBeat;
  return heartbeat$2;
}
(function(exports) {
  Object.defineProperty(exports, "__esModule", { value: true });
  const tslib_1 = require$$0$4;
  tslib_1.__exportStar(requireHeartbeat(), exports);
  tslib_1.__exportStar(requireTypes(), exports);
  tslib_1.__exportStar(requireConstants(), exports);
})(cjs$4);
function tryStringify(o2) {
  try {
    return JSON.stringify(o2);
  } catch (e) {
    return '"[Circular]"';
  }
}
var quickFormatUnescaped = format$1;
function format$1(f3, args, opts) {
  var ss3 = opts && opts.stringify || tryStringify;
  var offset = 1;
  if (typeof f3 === "object" && f3 !== null) {
    var len = args.length + offset;
    if (len === 1)
      return f3;
    var objects = new Array(len);
    objects[0] = ss3(f3);
    for (var index = 1; index < len; index++) {
      objects[index] = ss3(args[index]);
    }
    return objects.join(" ");
  }
  if (typeof f3 !== "string") {
    return f3;
  }
  var argLen = args.length;
  if (argLen === 0)
    return f3;
  var str = "";
  var a3 = 1 - offset;
  var lastPos = -1;
  var flen = f3 && f3.length || 0;
  for (var i2 = 0; i2 < flen; ) {
    if (f3.charCodeAt(i2) === 37 && i2 + 1 < flen) {
      lastPos = lastPos > -1 ? lastPos : 0;
      switch (f3.charCodeAt(i2 + 1)) {
        case 100:
        case 102:
          if (a3 >= argLen)
            break;
          if (args[a3] == null)
            break;
          if (lastPos < i2)
            str += f3.slice(lastPos, i2);
          str += Number(args[a3]);
          lastPos = i2 + 2;
          i2++;
          break;
        case 105:
          if (a3 >= argLen)
            break;
          if (args[a3] == null)
            break;
          if (lastPos < i2)
            str += f3.slice(lastPos, i2);
          str += Math.floor(Number(args[a3]));
          lastPos = i2 + 2;
          i2++;
          break;
        case 79:
        case 111:
        case 106:
          if (a3 >= argLen)
            break;
          if (args[a3] === void 0)
            break;
          if (lastPos < i2)
            str += f3.slice(lastPos, i2);
          var type = typeof args[a3];
          if (type === "string") {
            str += "'" + args[a3] + "'";
            lastPos = i2 + 2;
            i2++;
            break;
          }
          if (type === "function") {
            str += args[a3].name || "<anonymous>";
            lastPos = i2 + 2;
            i2++;
            break;
          }
          str += ss3(args[a3]);
          lastPos = i2 + 2;
          i2++;
          break;
        case 115:
          if (a3 >= argLen)
            break;
          if (lastPos < i2)
            str += f3.slice(lastPos, i2);
          str += String(args[a3]);
          lastPos = i2 + 2;
          i2++;
          break;
        case 37:
          if (lastPos < i2)
            str += f3.slice(lastPos, i2);
          str += "%";
          lastPos = i2 + 2;
          i2++;
          a3--;
          break;
      }
      ++a3;
    }
    ++i2;
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
  if (opts.browser.write)
    opts.browser.asObject = true;
  const serializers = opts.serializers || {};
  const serialize = shouldSerialize(opts.browser.serialize, serializers);
  let stdErrSerialize = opts.browser.serialize;
  if (Array.isArray(opts.browser.serialize) && opts.browser.serialize.indexOf("!stdSerializers.err") > -1)
    stdErrSerialize = false;
  const levels = ["error", "fatal", "warn", "info", "debug", "trace"];
  if (typeof proto === "function") {
    proto.error = proto.fatal = proto.warn = proto.info = proto.debug = proto.trace = proto;
  }
  if (opts.enabled === false)
    opts.level = "silent";
  const level = opts.level || "info";
  const logger2 = Object.create(proto);
  if (!logger2.log)
    logger2.log = noop;
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
  if (transmit2)
    logger2._logEvent = createLogEventShape();
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
  if (!opts.transmit && logger2[level] === noop)
    return;
  logger2[level] = /* @__PURE__ */ function(write) {
    return function LOG() {
      const ts3 = opts.timestamp();
      const args = new Array(arguments.length);
      const proto = Object.getPrototypeOf && Object.getPrototypeOf(this) === _console ? _console : this;
      for (var i2 = 0; i2 < args.length; i2++)
        args[i2] = arguments[i2];
      if (opts.serialize && !opts.asObject) {
        applySerializers(args, this._serialize, this.serializers, this._stdErrSerialize);
      }
      if (opts.asObject)
        write.call(proto, asObject(this, level, args, ts3));
      else
        write.apply(proto, args);
      if (opts.transmit) {
        const transmitLevel = opts.transmit.level || logger2.level;
        const transmitValue = pino.levels.values[transmitLevel];
        const methodValue = pino.levels.values[level];
        if (methodValue < transmitValue)
          return;
        transmit(this, {
          ts: ts3,
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
function asObject(logger2, level, args, ts3) {
  if (logger2._serialize)
    applySerializers(args, logger2._serialize, logger2.serializers, logger2._stdErrSerialize);
  const argsCloned = args.slice();
  let msg = argsCloned[0];
  const o2 = {};
  if (ts3) {
    o2.time = ts3;
  }
  o2.level = pino.levels.values[level];
  let lvl = (logger2._childLevel | 0) + 1;
  if (lvl < 1)
    lvl = 1;
  if (msg !== null && typeof msg === "object") {
    while (lvl-- && typeof argsCloned[0] === "object") {
      Object.assign(o2, argsCloned.shift());
    }
    msg = argsCloned.length ? format(argsCloned.shift(), argsCloned) : void 0;
  } else if (typeof msg === "string")
    msg = format(argsCloned.shift(), argsCloned);
  if (msg !== void 0)
    o2.msg = msg;
  return o2;
}
function applySerializers(args, serialize, serializers, stdErrSerialize) {
  for (const i2 in args) {
    if (stdErrSerialize && args[i2] instanceof Error) {
      args[i2] = pino.stdSerializers.err(args[i2]);
    } else if (typeof args[i2] === "object" && !Array.isArray(args[i2])) {
      for (const k2 in args[i2]) {
        if (serialize && serialize.indexOf(k2) > -1 && k2 in serializers) {
          args[i2][k2] = serializers[k2](args[i2][k2]);
        }
      }
    }
  }
}
function bind(parent, bindings, level) {
  return function() {
    const args = new Array(1 + arguments.length);
    args[0] = bindings;
    for (var i2 = 1; i2 < args.length; i2++) {
      args[i2] = arguments[i2 - 1];
    }
    return parent[level].apply(this, args);
  };
}
function transmit(logger2, opts, args) {
  const send = opts.send;
  const ts3 = opts.ts;
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
  logger2._logEvent.ts = ts3;
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
  function defd(o2) {
    return typeof o2 !== "undefined" && o2;
  }
  try {
    if (typeof globalThis !== "undefined")
      return globalThis;
    Object.defineProperty(Object.prototype, "globalThis", {
      get: function() {
        delete Object.prototype.globalThis;
        return this.globalThis = this;
      },
      configurable: true
    });
    return globalThis;
  } catch (e) {
    return defd(self) || defd(window) || defd(this) || {};
  }
}
const nt$2 = /* @__PURE__ */ getDefaultExportFromCjs(browser$2);
const c$1 = { level: "info" }, n$1 = "custom_context", l$1 = 1e3 * 1024;
let O$2 = class O {
  constructor(e) {
    this.nodeValue = e, this.sizeInBytes = new TextEncoder().encode(this.nodeValue).length, this.next = null;
  }
  get value() {
    return this.nodeValue;
  }
  get size() {
    return this.sizeInBytes;
  }
};
let d$2 = class d {
  constructor(e) {
    this.head = null, this.tail = null, this.lengthInNodes = 0, this.maxSizeInBytes = e, this.sizeInBytes = 0;
  }
  append(e) {
    const t = new O$2(e);
    if (t.size > this.maxSizeInBytes)
      throw new Error(`[LinkedList] Value too big to insert into list: ${e} with size ${t.size}`);
    for (; this.size + t.size > this.maxSizeInBytes; )
      this.shift();
    this.head ? (this.tail && (this.tail.next = t), this.tail = t) : (this.head = t, this.tail = t), this.lengthInNodes++, this.sizeInBytes += t.size;
  }
  shift() {
    if (!this.head)
      return;
    const e = this.head;
    this.head = this.head.next, this.head || (this.tail = null), this.lengthInNodes--, this.sizeInBytes -= e.size;
  }
  toArray() {
    const e = [];
    let t = this.head;
    for (; t !== null; )
      e.push(t.value), t = t.next;
    return e;
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
    let e = this.head;
    return { next: () => {
      if (!e)
        return { done: true, value: null };
      const t = e.value;
      return e = e.next, { done: false, value: t };
    } };
  }
};
let L$4 = class L {
  constructor(e, t = l$1) {
    this.level = e ?? "error", this.levelValue = browser$2.levels.values[this.level], this.MAX_LOG_SIZE_IN_BYTES = t, this.logs = new d$2(this.MAX_LOG_SIZE_IN_BYTES);
  }
  forwardToConsole(e, t) {
    t === browser$2.levels.values.error ? console.error(e) : t === browser$2.levels.values.warn ? console.warn(e) : t === browser$2.levels.values.debug ? console.debug(e) : t === browser$2.levels.values.trace ? console.trace(e) : console.log(e);
  }
  appendToLogs(e) {
    this.logs.append(safeJsonStringify({ timestamp: (/* @__PURE__ */ new Date()).toISOString(), log: e }));
    const t = typeof e == "string" ? JSON.parse(e).level : e.level;
    t >= this.levelValue && this.forwardToConsole(e, t);
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
  logsToBlob(e) {
    const t = this.getLogArray();
    return t.push(safeJsonStringify({ extraMetadata: e })), new Blob(t, { type: "application/json" });
  }
};
let m$1 = class m {
  constructor(e, t = l$1) {
    this.baseChunkLogger = new L$4(e, t);
  }
  write(e) {
    this.baseChunkLogger.appendToLogs(e);
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
  logsToBlob(e) {
    return this.baseChunkLogger.logsToBlob(e);
  }
  downloadLogsBlobInBrowser(e) {
    const t = URL.createObjectURL(this.logsToBlob(e)), o2 = document.createElement("a");
    o2.href = t, o2.download = `walletconnect-logs-${(/* @__PURE__ */ new Date()).toISOString()}.txt`, document.body.appendChild(o2), o2.click(), document.body.removeChild(o2), URL.revokeObjectURL(t);
  }
};
let B$2 = class B {
  constructor(e, t = l$1) {
    this.baseChunkLogger = new L$4(e, t);
  }
  write(e) {
    this.baseChunkLogger.appendToLogs(e);
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
  logsToBlob(e) {
    return this.baseChunkLogger.logsToBlob(e);
  }
};
var x$2 = Object.defineProperty, S$4 = Object.defineProperties, _$1 = Object.getOwnPropertyDescriptors, p$2 = Object.getOwnPropertySymbols, T$2 = Object.prototype.hasOwnProperty, z$3 = Object.prototype.propertyIsEnumerable, f$3 = (r, e, t) => e in r ? x$2(r, e, { enumerable: true, configurable: true, writable: true, value: t }) : r[e] = t, i = (r, e) => {
  for (var t in e || (e = {}))
    T$2.call(e, t) && f$3(r, t, e[t]);
  if (p$2)
    for (var t of p$2(e))
      z$3.call(e, t) && f$3(r, t, e[t]);
  return r;
}, g$2 = (r, e) => S$4(r, _$1(e));
function k$2(r) {
  return g$2(i({}, r), { level: (r == null ? void 0 : r.level) || c$1.level });
}
function v$3(r, e = n$1) {
  return r[e] || "";
}
function b$3(r, e, t = n$1) {
  return r[t] = e, r;
}
function y$3(r, e = n$1) {
  let t = "";
  return typeof r.bindings > "u" ? t = v$3(r, e) : t = r.bindings().context || "", t;
}
function w$3(r, e, t = n$1) {
  const o2 = y$3(r, t);
  return o2.trim() ? `${o2}/${e}` : e;
}
function E$2(r, e, t = n$1) {
  const o2 = w$3(r, e, t), a3 = r.child({ context: o2 });
  return b$3(a3, o2, t);
}
function C$2(r) {
  var e, t;
  const o2 = new m$1((e = r.opts) == null ? void 0 : e.level, r.maxSizeInBytes);
  return { logger: nt$2(g$2(i({}, r.opts), { level: "trace", browser: g$2(i({}, (t = r.opts) == null ? void 0 : t.browser), { write: (a3) => o2.write(a3) }) })), chunkLoggerController: o2 };
}
function I$2(r) {
  var e;
  const t = new B$2((e = r.opts) == null ? void 0 : e.level, r.maxSizeInBytes);
  return { logger: nt$2(g$2(i({}, r.opts), { level: "trace" }), t), chunkLoggerController: t };
}
function A$1(r) {
  return typeof r.loggerOverride < "u" && typeof r.loggerOverride != "string" ? { logger: r.loggerOverride, chunkLoggerController: null } : typeof window < "u" ? C$2(r) : I$2(r);
}
class n extends IEvents$1 {
  constructor(s) {
    super(), this.opts = s, this.protocol = "wc", this.version = 2;
  }
}
let h$1 = class h2 extends IEvents$1 {
  constructor(s, t) {
    super(), this.core = s, this.logger = t, this.records = /* @__PURE__ */ new Map();
  }
};
let a$1 = class a {
  constructor(s, t) {
    this.logger = s, this.core = t;
  }
};
class u extends IEvents$1 {
  constructor(s, t) {
    super(), this.relayer = s, this.logger = t;
  }
}
let g$1 = class g extends IEvents$1 {
  constructor(s) {
    super();
  }
};
let p$1 = class p {
  constructor(s, t, o2, M2) {
    this.core = s, this.logger = t, this.name = o2;
  }
};
let d$1 = class d2 extends IEvents$1 {
  constructor(s, t) {
    super(), this.relayer = s, this.logger = t;
  }
};
let E$1 = class E extends IEvents$1 {
  constructor(s, t) {
    super(), this.core = s, this.logger = t;
  }
};
let y$2 = class y {
  constructor(s, t) {
    this.projectId = s, this.logger = t;
  }
};
let v$2 = class v {
  constructor(s, t) {
    this.projectId = s, this.logger = t;
  }
};
let b$2 = class b {
  constructor(s) {
    this.opts = s, this.protocol = "wc", this.version = 2;
  }
};
let w$2 = class w {
  constructor(s) {
    this.client = s;
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
    for (let i2 = 0; i2 < out.length; i2 += QUOTA) {
      this._crypto.getRandomValues(out.subarray(i2, i2 + Math.min(out.length - i2, QUOTA)));
    }
    return out;
  }
}
browser$1.BrowserRandomSource = BrowserRandomSource;
var node = {};
Object.defineProperty(node, "__esModule", { value: true });
node.NodeRandomSource = void 0;
const wipe_1$1 = wipe;
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
    for (let i2 = 0; i2 < out.length; i2++) {
      out[i2] = buffer[i2];
    }
    (0, wipe_1$1.wipe)(buffer);
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
(function(exports) {
  Object.defineProperty(exports, "__esModule", { value: true });
  exports.randomStringForEntropy = exports.randomString = exports.randomUint32 = exports.randomBytes = exports.defaultRandomSource = void 0;
  const system_1 = system;
  const binary_1 = binary;
  const wipe_12 = wipe;
  exports.defaultRandomSource = new system_1.SystemRandomSource();
  function randomBytes(length, prng = exports.defaultRandomSource) {
    return prng.randomBytes(length);
  }
  exports.randomBytes = randomBytes;
  function randomUint32(prng = exports.defaultRandomSource) {
    const buf = randomBytes(4, prng);
    const result = (0, binary_1.readUint32LE)(buf);
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
      for (let i2 = 0; i2 < buf.length && length > 0; i2++) {
        const randomByte = buf[i2];
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
(function(exports) {
  Object.defineProperty(exports, "__esModule", { value: true });
  exports.convertSecretKeyToX25519 = exports.convertPublicKeyToX25519 = exports.verify = exports.sign = exports.extractPublicKeyFromSecretKey = exports.generateKeyPair = exports.generateKeyPairFromSeed = exports.SEED_LENGTH = exports.SECRET_KEY_LENGTH = exports.PUBLIC_KEY_LENGTH = exports.SIGNATURE_LENGTH = void 0;
  const random_1 = random;
  const sha512_1 = sha512;
  const wipe_12 = wipe;
  exports.SIGNATURE_LENGTH = 64;
  exports.PUBLIC_KEY_LENGTH = 32;
  exports.SECRET_KEY_LENGTH = 64;
  exports.SEED_LENGTH = 32;
  function gf2(init2) {
    const r = new Float64Array(16);
    if (init2) {
      for (let i2 = 0; i2 < init2.length; i2++) {
        r[i2] = init2[i2];
      }
    }
    return r;
  }
  const _9 = new Uint8Array(32);
  _9[0] = 9;
  const gf0 = gf2();
  const gf1 = gf2([1]);
  const D2 = gf2([
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
  const D22 = gf2([
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
  const X2 = gf2([
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
  const Y2 = gf2([
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
  const I2 = gf2([
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
  function set25519(r, a3) {
    for (let i2 = 0; i2 < 16; i2++) {
      r[i2] = a3[i2] | 0;
    }
  }
  function car25519(o2) {
    let c2 = 1;
    for (let i2 = 0; i2 < 16; i2++) {
      let v3 = o2[i2] + c2 + 65535;
      c2 = Math.floor(v3 / 65536);
      o2[i2] = v3 - c2 * 65536;
    }
    o2[0] += c2 - 1 + 37 * (c2 - 1);
  }
  function sel25519(p3, q2, b3) {
    const c2 = ~(b3 - 1);
    for (let i2 = 0; i2 < 16; i2++) {
      const t = c2 & (p3[i2] ^ q2[i2]);
      p3[i2] ^= t;
      q2[i2] ^= t;
    }
  }
  function pack25519(o2, n2) {
    const m3 = gf2();
    const t = gf2();
    for (let i2 = 0; i2 < 16; i2++) {
      t[i2] = n2[i2];
    }
    car25519(t);
    car25519(t);
    car25519(t);
    for (let j2 = 0; j2 < 2; j2++) {
      m3[0] = t[0] - 65517;
      for (let i2 = 1; i2 < 15; i2++) {
        m3[i2] = t[i2] - 65535 - (m3[i2 - 1] >> 16 & 1);
        m3[i2 - 1] &= 65535;
      }
      m3[15] = t[15] - 32767 - (m3[14] >> 16 & 1);
      const b3 = m3[15] >> 16 & 1;
      m3[14] &= 65535;
      sel25519(t, m3, 1 - b3);
    }
    for (let i2 = 0; i2 < 16; i2++) {
      o2[2 * i2] = t[i2] & 255;
      o2[2 * i2 + 1] = t[i2] >> 8;
    }
  }
  function verify32(x2, y3) {
    let d4 = 0;
    for (let i2 = 0; i2 < 32; i2++) {
      d4 |= x2[i2] ^ y3[i2];
    }
    return (1 & d4 - 1 >>> 8) - 1;
  }
  function neq25519(a3, b3) {
    const c2 = new Uint8Array(32);
    const d4 = new Uint8Array(32);
    pack25519(c2, a3);
    pack25519(d4, b3);
    return verify32(c2, d4);
  }
  function par25519(a3) {
    const d4 = new Uint8Array(32);
    pack25519(d4, a3);
    return d4[0] & 1;
  }
  function unpack25519(o2, n2) {
    for (let i2 = 0; i2 < 16; i2++) {
      o2[i2] = n2[2 * i2] + (n2[2 * i2 + 1] << 8);
    }
    o2[15] &= 32767;
  }
  function add3(o2, a3, b3) {
    for (let i2 = 0; i2 < 16; i2++) {
      o2[i2] = a3[i2] + b3[i2];
    }
  }
  function sub(o2, a3, b3) {
    for (let i2 = 0; i2 < 16; i2++) {
      o2[i2] = a3[i2] - b3[i2];
    }
  }
  function mul3(o2, a3, b3) {
    let v3, c2, t0 = 0, t1 = 0, t2 = 0, t3 = 0, t4 = 0, t5 = 0, t6 = 0, t7 = 0, t8 = 0, t9 = 0, t10 = 0, t11 = 0, t12 = 0, t13 = 0, t14 = 0, t15 = 0, t16 = 0, t17 = 0, t18 = 0, t19 = 0, t20 = 0, t21 = 0, t22 = 0, t23 = 0, t24 = 0, t25 = 0, t26 = 0, t27 = 0, t28 = 0, t29 = 0, t30 = 0, b02 = b3[0], b1 = b3[1], b22 = b3[2], b32 = b3[3], b4 = b3[4], b5 = b3[5], b6 = b3[6], b7 = b3[7], b8 = b3[8], b9 = b3[9], b10 = b3[10], b11 = b3[11], b12 = b3[12], b13 = b3[13], b14 = b3[14], b15 = b3[15];
    v3 = a3[0];
    t0 += v3 * b02;
    t1 += v3 * b1;
    t2 += v3 * b22;
    t3 += v3 * b32;
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
    t1 += v3 * b02;
    t2 += v3 * b1;
    t3 += v3 * b22;
    t4 += v3 * b32;
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
    t2 += v3 * b02;
    t3 += v3 * b1;
    t4 += v3 * b22;
    t5 += v3 * b32;
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
    t3 += v3 * b02;
    t4 += v3 * b1;
    t5 += v3 * b22;
    t6 += v3 * b32;
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
    t4 += v3 * b02;
    t5 += v3 * b1;
    t6 += v3 * b22;
    t7 += v3 * b32;
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
    t5 += v3 * b02;
    t6 += v3 * b1;
    t7 += v3 * b22;
    t8 += v3 * b32;
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
    t6 += v3 * b02;
    t7 += v3 * b1;
    t8 += v3 * b22;
    t9 += v3 * b32;
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
    t7 += v3 * b02;
    t8 += v3 * b1;
    t9 += v3 * b22;
    t10 += v3 * b32;
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
    t8 += v3 * b02;
    t9 += v3 * b1;
    t10 += v3 * b22;
    t11 += v3 * b32;
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
    t9 += v3 * b02;
    t10 += v3 * b1;
    t11 += v3 * b22;
    t12 += v3 * b32;
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
    t10 += v3 * b02;
    t11 += v3 * b1;
    t12 += v3 * b22;
    t13 += v3 * b32;
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
    t11 += v3 * b02;
    t12 += v3 * b1;
    t13 += v3 * b22;
    t14 += v3 * b32;
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
    t12 += v3 * b02;
    t13 += v3 * b1;
    t14 += v3 * b22;
    t15 += v3 * b32;
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
    t13 += v3 * b02;
    t14 += v3 * b1;
    t15 += v3 * b22;
    t16 += v3 * b32;
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
    t14 += v3 * b02;
    t15 += v3 * b1;
    t16 += v3 * b22;
    t17 += v3 * b32;
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
    t15 += v3 * b02;
    t16 += v3 * b1;
    t17 += v3 * b22;
    t18 += v3 * b32;
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
    o2[0] = t0;
    o2[1] = t1;
    o2[2] = t2;
    o2[3] = t3;
    o2[4] = t4;
    o2[5] = t5;
    o2[6] = t6;
    o2[7] = t7;
    o2[8] = t8;
    o2[9] = t9;
    o2[10] = t10;
    o2[11] = t11;
    o2[12] = t12;
    o2[13] = t13;
    o2[14] = t14;
    o2[15] = t15;
  }
  function square(o2, a3) {
    mul3(o2, a3, a3);
  }
  function inv25519(o2, i2) {
    const c2 = gf2();
    let a3;
    for (a3 = 0; a3 < 16; a3++) {
      c2[a3] = i2[a3];
    }
    for (a3 = 253; a3 >= 0; a3--) {
      square(c2, c2);
      if (a3 !== 2 && a3 !== 4) {
        mul3(c2, c2, i2);
      }
    }
    for (a3 = 0; a3 < 16; a3++) {
      o2[a3] = c2[a3];
    }
  }
  function pow2523(o2, i2) {
    const c2 = gf2();
    let a3;
    for (a3 = 0; a3 < 16; a3++) {
      c2[a3] = i2[a3];
    }
    for (a3 = 250; a3 >= 0; a3--) {
      square(c2, c2);
      if (a3 !== 1) {
        mul3(c2, c2, i2);
      }
    }
    for (a3 = 0; a3 < 16; a3++) {
      o2[a3] = c2[a3];
    }
  }
  function edadd(p3, q2) {
    const a3 = gf2(), b3 = gf2(), c2 = gf2(), d4 = gf2(), e = gf2(), f3 = gf2(), g3 = gf2(), h4 = gf2(), t = gf2();
    sub(a3, p3[1], p3[0]);
    sub(t, q2[1], q2[0]);
    mul3(a3, a3, t);
    add3(b3, p3[0], p3[1]);
    add3(t, q2[0], q2[1]);
    mul3(b3, b3, t);
    mul3(c2, p3[3], q2[3]);
    mul3(c2, c2, D22);
    mul3(d4, p3[2], q2[2]);
    add3(d4, d4, d4);
    sub(e, b3, a3);
    sub(f3, d4, c2);
    add3(g3, d4, c2);
    add3(h4, b3, a3);
    mul3(p3[0], e, f3);
    mul3(p3[1], h4, g3);
    mul3(p3[2], g3, f3);
    mul3(p3[3], e, h4);
  }
  function cswap(p3, q2, b3) {
    for (let i2 = 0; i2 < 4; i2++) {
      sel25519(p3[i2], q2[i2], b3);
    }
  }
  function pack(r, p3) {
    const tx = gf2(), ty = gf2(), zi2 = gf2();
    inv25519(zi2, p3[2]);
    mul3(tx, p3[0], zi2);
    mul3(ty, p3[1], zi2);
    pack25519(r, ty);
    r[31] ^= par25519(tx) << 7;
  }
  function scalarmult(p3, q2, s) {
    set25519(p3[0], gf0);
    set25519(p3[1], gf1);
    set25519(p3[2], gf1);
    set25519(p3[3], gf0);
    for (let i2 = 255; i2 >= 0; --i2) {
      const b3 = s[i2 / 8 | 0] >> (i2 & 7) & 1;
      cswap(p3, q2, b3);
      edadd(q2, p3);
      edadd(p3, p3);
      cswap(p3, q2, b3);
    }
  }
  function scalarbase(p3, s) {
    const q2 = [gf2(), gf2(), gf2(), gf2()];
    set25519(q2[0], X2);
    set25519(q2[1], Y2);
    set25519(q2[2], gf1);
    mul3(q2[3], X2, Y2);
    scalarmult(p3, q2, s);
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
    const p3 = [gf2(), gf2(), gf2(), gf2()];
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
  const L4 = new Float64Array([
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
  function modL(r, x2) {
    let carry;
    let i2;
    let j2;
    let k2;
    for (i2 = 63; i2 >= 32; --i2) {
      carry = 0;
      for (j2 = i2 - 32, k2 = i2 - 12; j2 < k2; ++j2) {
        x2[j2] += carry - 16 * x2[i2] * L4[j2 - (i2 - 32)];
        carry = Math.floor((x2[j2] + 128) / 256);
        x2[j2] -= carry * 256;
      }
      x2[j2] += carry;
      x2[i2] = 0;
    }
    carry = 0;
    for (j2 = 0; j2 < 32; j2++) {
      x2[j2] += carry - (x2[31] >> 4) * L4[j2];
      carry = x2[j2] >> 8;
      x2[j2] &= 255;
    }
    for (j2 = 0; j2 < 32; j2++) {
      x2[j2] -= carry * L4[j2];
    }
    for (i2 = 0; i2 < 32; i2++) {
      x2[i2 + 1] += x2[i2] >> 8;
      r[i2] = x2[i2] & 255;
    }
  }
  function reduce(r) {
    const x2 = new Float64Array(64);
    for (let i2 = 0; i2 < 64; i2++) {
      x2[i2] = r[i2];
    }
    for (let i2 = 0; i2 < 64; i2++) {
      r[i2] = 0;
    }
    modL(r, x2);
  }
  function sign3(secretKey, message) {
    const x2 = new Float64Array(64);
    const p3 = [gf2(), gf2(), gf2(), gf2()];
    const d4 = (0, sha512_1.hash)(secretKey.subarray(0, 32));
    d4[0] &= 248;
    d4[31] &= 127;
    d4[31] |= 64;
    const signature2 = new Uint8Array(64);
    signature2.set(d4.subarray(32), 32);
    const hs2 = new sha512_1.SHA512();
    hs2.update(signature2.subarray(32));
    hs2.update(message);
    const r = hs2.digest();
    hs2.clean();
    reduce(r);
    scalarbase(p3, r);
    pack(signature2, p3);
    hs2.reset();
    hs2.update(signature2.subarray(0, 32));
    hs2.update(secretKey.subarray(32));
    hs2.update(message);
    const h4 = hs2.digest();
    reduce(h4);
    for (let i2 = 0; i2 < 32; i2++) {
      x2[i2] = r[i2];
    }
    for (let i2 = 0; i2 < 32; i2++) {
      for (let j2 = 0; j2 < 32; j2++) {
        x2[i2 + j2] += h4[i2] * d4[j2];
      }
    }
    modL(signature2.subarray(32), x2);
    return signature2;
  }
  exports.sign = sign3;
  function unpackneg(r, p3) {
    const t = gf2(), chk = gf2(), num = gf2(), den = gf2(), den2 = gf2(), den4 = gf2(), den6 = gf2();
    set25519(r[2], gf1);
    unpack25519(r[1], p3);
    square(num, r[1]);
    mul3(den, num, D2);
    sub(num, num, r[2]);
    add3(den, r[2], den);
    square(den2, den);
    square(den4, den2);
    mul3(den6, den4, den2);
    mul3(t, den6, num);
    mul3(t, t, den);
    pow2523(t, t);
    mul3(t, t, num);
    mul3(t, t, den);
    mul3(t, t, den);
    mul3(r[0], t, den);
    square(chk, r[0]);
    mul3(chk, chk, den);
    if (neq25519(chk, num)) {
      mul3(r[0], r[0], I2);
    }
    square(chk, r[0]);
    mul3(chk, chk, den);
    if (neq25519(chk, num)) {
      return -1;
    }
    if (par25519(r[0]) === p3[31] >> 7) {
      sub(r[0], gf0, r[0]);
    }
    mul3(r[3], r[0], r[1]);
    return 0;
  }
  function verify3(publicKey, message, signature2) {
    const t = new Uint8Array(32);
    const p3 = [gf2(), gf2(), gf2(), gf2()];
    const q2 = [gf2(), gf2(), gf2(), gf2()];
    if (signature2.length !== exports.SIGNATURE_LENGTH) {
      throw new Error(`ed25519: signature must be ${exports.SIGNATURE_LENGTH} bytes`);
    }
    if (unpackneg(q2, publicKey)) {
      return false;
    }
    const hs2 = new sha512_1.SHA512();
    hs2.update(signature2.subarray(0, 32));
    hs2.update(publicKey);
    hs2.update(message);
    const h4 = hs2.digest();
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
  exports.verify = verify3;
  function convertPublicKeyToX25519(publicKey) {
    let q2 = [gf2(), gf2(), gf2(), gf2()];
    if (unpackneg(q2, publicKey)) {
      throw new Error("Ed25519: invalid public key");
    }
    let a3 = gf2();
    let b3 = gf2();
    let y3 = q2[1];
    add3(a3, gf1, y3);
    sub(b3, gf1, y3);
    inv25519(b3, b3);
    mul3(a3, a3, b3);
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
    const o2 = new Uint8Array(d4.subarray(0, 32));
    (0, wipe_12.wipe)(d4);
    return o2;
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
function asUint8Array(buf) {
  if (globalThis.Buffer != null) {
    return new Uint8Array(buf.buffer, buf.byteOffset, buf.byteLength);
  }
  return buf;
}
function allocUnsafe(size = 0) {
  if (globalThis.Buffer != null && globalThis.Buffer.allocUnsafe != null) {
    return asUint8Array(globalThis.Buffer.allocUnsafe(size));
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
  return asUint8Array(output);
}
function base$1(ALPHABET, name) {
  if (ALPHABET.length >= 255) {
    throw new TypeError("Alphabet too long");
  }
  var BASE_MAP = new Uint8Array(256);
  for (var j2 = 0; j2 < BASE_MAP.length; j2++) {
    BASE_MAP[j2] = 255;
  }
  for (var i2 = 0; i2 < ALPHABET.length; i2++) {
    var x2 = ALPHABET.charAt(i2);
    var xc = x2.charCodeAt(0);
    if (BASE_MAP[xc] !== 255) {
      throw new TypeError(x2 + " is ambiguous");
    }
    BASE_MAP[xc] = i2;
  }
  var BASE = ALPHABET.length;
  var LEADER = ALPHABET.charAt(0);
  var FACTOR = Math.log(BASE) / Math.log(256);
  var iFACTOR = Math.log(256) / Math.log(BASE);
  function encode3(source) {
    if (source instanceof Uint8Array)
      ;
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
      var i3 = 0;
      for (var it1 = size - 1; (carry !== 0 || i3 < length) && it1 !== -1; it1--, i3++) {
        carry += 256 * b58[it1] >>> 0;
        b58[it1] = carry % BASE >>> 0;
        carry = carry / BASE >>> 0;
      }
      if (carry !== 0) {
        throw new Error("Non-zero carry");
      }
      length = i3;
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
      var i3 = 0;
      for (var it3 = size - 1; (carry !== 0 || i3 < length) && it3 !== -1; it3--, i3++) {
        carry += BASE * b256[it3] >>> 0;
        b256[it3] = carry % 256 >>> 0;
        carry = carry / 256 >>> 0;
      }
      if (carry !== 0) {
        throw new Error("Non-zero carry");
      }
      length = i3;
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
    throw new Error(`Non-${name} character`);
  }
  return {
    encode: encode3,
    decodeUnsafe,
    decode: decode2
  };
}
var src = base$1;
var _brrp__multiformats_scope_baseX = src;
const coerce = (o2) => {
  if (o2 instanceof Uint8Array && o2.constructor.name === "Uint8Array")
    return o2;
  if (o2 instanceof ArrayBuffer)
    return new Uint8Array(o2);
  if (ArrayBuffer.isView(o2)) {
    return new Uint8Array(o2.buffer, o2.byteOffset, o2.byteLength);
  }
  throw new Error("Unknown type, must be binary type");
};
const fromString$1 = (str) => new TextEncoder().encode(str);
const toString$1 = (b3) => new TextDecoder().decode(b3);
class Encoder {
  constructor(name, prefix, baseEncode) {
    this.name = name;
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
  constructor(name, prefix, baseDecode) {
    this.name = name;
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
    return or$3(this, decoder);
  }
}
class ComposedDecoder {
  constructor(decoders) {
    this.decoders = decoders;
  }
  or(decoder) {
    return or$3(this, decoder);
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
const or$3 = (left, right) => new ComposedDecoder({
  ...left.decoders || { [left.prefix]: left },
  ...right.decoders || { [right.prefix]: right }
});
class Codec {
  constructor(name, prefix, baseEncode, baseDecode) {
    this.name = name;
    this.prefix = prefix;
    this.baseEncode = baseEncode;
    this.baseDecode = baseDecode;
    this.encoder = new Encoder(name, prefix, baseEncode);
    this.decoder = new Decoder(name, prefix, baseDecode);
  }
  encode(input) {
    return this.encoder.encode(input);
  }
  decode(input) {
    return this.decoder.decode(input);
  }
}
const from = ({ name, prefix, encode: encode3, decode: decode2 }) => new Codec(name, prefix, encode3, decode2);
const baseX = ({ prefix, name, alphabet: alphabet2 }) => {
  const { encode: encode3, decode: decode2 } = _brrp__multiformats_scope_baseX(alphabet2, name);
  return from({
    prefix,
    name,
    encode: encode3,
    decode: (text) => coerce(decode2(text))
  });
};
const decode$2 = (string2, alphabet2, bitsPerChar, name) => {
  const codes = {};
  for (let i2 = 0; i2 < alphabet2.length; ++i2) {
    codes[alphabet2[i2]] = i2;
  }
  let end = string2.length;
  while (string2[end - 1] === "=") {
    --end;
  }
  const out = new Uint8Array(end * bitsPerChar / 8 | 0);
  let bits = 0;
  let buffer = 0;
  let written = 0;
  for (let i2 = 0; i2 < end; ++i2) {
    const value = codes[string2[i2]];
    if (value === void 0) {
      throw new SyntaxError(`Non-${name} character`);
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
  for (let i2 = 0; i2 < data.length; ++i2) {
    buffer = buffer << 8 | data[i2];
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
const rfc4648 = ({ name, prefix, bitsPerChar, alphabet: alphabet2 }) => {
  return from({
    prefix,
    name,
    encode(input) {
      return encode$1(input, alphabet2, bitsPerChar);
    },
    decode(input) {
      return decode$2(input, alphabet2, bitsPerChar, name);
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
const alphabetBytesToChars = alphabet.reduce((p3, c2, i2) => {
  p3[i2] = c2;
  return p3;
}, []);
const alphabetCharsToBytes = alphabet.reduce((p3, c2, i2) => {
  p3[c2.codePointAt(0)] = i2;
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
function createCodec(name, prefix, encode3, decode2) {
  return {
    name,
    prefix,
    encoder: {
      name,
      prefix,
      encode: encode3
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
  for (let i2 = 0; i2 < buf.length; i2++) {
    string2 += String.fromCharCode(buf[i2]);
  }
  return string2;
}, (str) => {
  str = str.substring(1);
  const buf = allocUnsafe(str.length);
  for (let i2 = 0; i2 < str.length; i2++) {
    buf[i2] = str.charCodeAt(i2);
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
    return asUint8Array(globalThis.Buffer.from(string2, "utf-8"));
  }
  return base3.decoder.decode(`${base3.prefix}${string2}`);
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
function generateKeyPair(seed = random.randomBytes(KEY_PAIR_SEED_LENGTH)) {
  return ed25519.generateKeyPairFromSeed(seed);
}
async function signJWT(sub, aud, ttl, keyPair2, iat = cjs$3.fromMiliseconds(Date.now())) {
  const header = { alg: JWT_IRIDIUM_ALG, typ: JWT_IRIDIUM_TYP };
  const iss = encodeIss(keyPair2.publicKey);
  const exp = iat + ttl;
  const payload = { iss, sub, aud, iat, exp };
  const data = encodeData({ header, payload });
  const signature2 = ed25519.sign(keyPair2.secretKey, data);
  return encodeJWT({ header, payload, signature: signature2 });
}
var __spreadArray = function(to2, from2, pack) {
  if (pack || arguments.length === 2)
    for (var i2 = 0, l2 = from2.length, ar3; i2 < l2; i2++) {
      if (ar3 || !(i2 in from2)) {
        if (!ar3)
          ar3 = Array.prototype.slice.call(from2, 0, i2);
        ar3[i2] = from2[i2];
      }
    }
  return to2.concat(ar3 || Array.prototype.slice.call(from2));
};
var BrowserInfo = (
  /** @class */
  /* @__PURE__ */ function() {
    function BrowserInfo2(name, version2, os2) {
      this.name = name;
      this.version = version2;
      this.os = os2;
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
    function SearchBotDeviceInfo2(name, version2, os2, bot) {
      this.name = name;
      this.version = version2;
      this.os = os2;
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
  if (!!userAgent) {
    return parseUserAgent(userAgent);
  }
  if (typeof document === "undefined" && typeof navigator !== "undefined" && navigator.product === "ReactNative") {
    return new ReactNativeInfo();
  }
  if (typeof navigator !== "undefined") {
    return parseUserAgent(navigator.userAgent);
  }
  return getNodeVersion();
}
function matchUserAgent(ua2) {
  return ua2 !== "" && userAgentRules.reduce(function(matched, _a2) {
    var browser2 = _a2[0], regex = _a2[1];
    if (matched) {
      return matched;
    }
    var uaMatch = regex.exec(ua2);
    return !!uaMatch && [browser2, uaMatch];
  }, false);
}
function parseUserAgent(ua2) {
  var matchedRule = matchUserAgent(ua2);
  if (!matchedRule) {
    return null;
  }
  var name = matchedRule[0], match = matchedRule[1];
  if (name === "searchbot") {
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
  var os2 = detectOS(ua2);
  var searchBotMatch = SEARCHBOT_OS_REGEX.exec(ua2);
  if (searchBotMatch && searchBotMatch[1]) {
    return new SearchBotDeviceInfo(name, version2, os2, searchBotMatch[1]);
  }
  return new BrowserInfo(name, version2, os2);
}
function detectOS(ua2) {
  for (var ii = 0, count = operatingSystemRules.length; ii < count; ii++) {
    var _a2 = operatingSystemRules[ii], os2 = _a2[0], regex = _a2[1];
    var match = regex.exec(ua2);
    if (match) {
      return os2;
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
  for (var ii = 0; ii < count; ii++) {
    output.push("0");
  }
  return output;
}
var cjs$2 = {};
Object.defineProperty(cjs$2, "__esModule", { value: true });
cjs$2.getLocalStorage = cjs$2.getLocalStorageOrThrow = cjs$2.getCrypto = cjs$2.getCryptoOrThrow = getLocation_1 = cjs$2.getLocation = cjs$2.getLocationOrThrow = getNavigator_1 = cjs$2.getNavigator = cjs$2.getNavigatorOrThrow = getDocument_1 = cjs$2.getDocument = cjs$2.getDocumentOrThrow = cjs$2.getFromWindowOrThrow = cjs$2.getFromWindow = void 0;
function getFromWindow(name) {
  let res = void 0;
  if (typeof window !== "undefined" && typeof window[name] !== "undefined") {
    res = window[name];
  }
  return res;
}
cjs$2.getFromWindow = getFromWindow;
function getFromWindowOrThrow(name) {
  const res = getFromWindow(name);
  if (!res) {
    throw new Error(`${name} is not defined in Window`);
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
  } catch (e) {
    return null;
  }
  function getIcons() {
    const links = doc.getElementsByTagName("link");
    const icons2 = [];
    for (let i2 = 0; i2 < links.length; i2++) {
      const link = links[i2];
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
    for (let i2 = 0; i2 < metaTags.length; i2++) {
      const tag = metaTags[i2];
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
    let name2 = getWindowMetadataOfAny("name", "og:site_name", "og:title", "twitter:title");
    if (!name2) {
      name2 = doc.title;
    }
    return name2;
  }
  function getDescription() {
    const description2 = getWindowMetadataOfAny("description", "og:description", "twitter:description", "keywords");
    return description2;
  }
  const name = getName();
  const description = getDescription();
  const url = loc.origin;
  const icons = getIcons();
  const meta = {
    description,
    url,
    icons,
    name
  };
  return meta;
}
getWindowMetadata_1 = cjs$1.getWindowMetadata = getWindowMetadata;
var queryString = {};
var strictUriEncode = (str) => encodeURIComponent(str).replace(/[!'()*]/g, (x2) => `%${x2.charCodeAt(0).toString(16).toUpperCase()}`);
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
    for (var i2 = 1; i2 < tokens.length; i2++) {
      input = decodeComponents(tokens, i2).join("");
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
  for (var i2 = 0; i2 < entries.length; i2++) {
    var key2 = entries[i2];
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
  for (var i2 = 0; i2 < keys2.length; i2++) {
    var key2 = keys2[i2];
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
            return [...result, [encode3(key2, options), "[", index, "]"].join("")];
          }
          return [
            ...result,
            [encode3(key2, options), "[", encode3(index, options), "]=", encode3(value, options)].join("")
          ];
        };
      case "bracket":
        return (key2) => (result, value) => {
          if (value === void 0 || options.skipNull && value === null || options.skipEmptyString && value === "") {
            return result;
          }
          if (value === null) {
            return [...result, [encode3(key2, options), "[]"].join("")];
          }
          return [...result, [encode3(key2, options), "[]=", encode3(value, options)].join("")];
        };
      case "colon-list-separator":
        return (key2) => (result, value) => {
          if (value === void 0 || options.skipNull && value === null || options.skipEmptyString && value === "") {
            return result;
          }
          if (value === null) {
            return [...result, [encode3(key2, options), ":list="].join("")];
          }
          return [...result, [encode3(key2, options), ":list=", encode3(value, options)].join("")];
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
            return [[encode3(key2, options), keyValueSep, encode3(value, options)].join("")];
          }
          return [[result, encode3(value, options)].join(options.arrayFormatSeparator)];
        };
      }
      default:
        return (key2) => (result, value) => {
          if (value === void 0 || options.skipNull && value === null || options.skipEmptyString && value === "") {
            return result;
          }
          if (value === null) {
            return [...result, encode3(key2, options)];
          }
          return [...result, [encode3(key2, options), "=", encode3(value, options)].join("")];
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
  function encode3(value, options) {
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
      return keysSorter(Object.keys(input)).sort((a3, b3) => Number(a3) - Number(b3)).map((key2) => input[key2]);
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
    let hash2 = "";
    const hashStart = url.indexOf("#");
    if (hashStart !== -1) {
      hash2 = url.slice(hashStart);
    }
    return hash2;
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
        return encode3(key2, options);
      }
      if (Array.isArray(value)) {
        if (value.length === 0 && options.arrayFormat === "bracket-separator") {
          return encode3(key2, options) + "[]";
        }
        return value.reduce(formatter(key2), []).join("&");
      }
      return encode3(key2, options) + "=" + encode3(value, options);
    }).filter((x2) => x2.length > 0).join("&");
  };
  exports.parseUrl = (url, options) => {
    options = Object.assign({
      decode: true
    }, options);
    const [url_, hash2] = splitOnFirst$1(url, "#");
    return Object.assign(
      {
        url: url_.split("?")[0] || "",
        query: parse(extract(url), options)
      },
      options && options.parseFragmentIdentifier && hash2 ? { fragmentIdentifier: decode2(hash2, options) } : {}
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
    let hash2 = getHash(object.url);
    if (object.fragmentIdentifier) {
      hash2 = `#${options[encodeFragmentIdentifier] ? encode3(object.fragmentIdentifier, options) : object.fragmentIdentifier}`;
    }
    return `${url}${queryString2}${hash2}`;
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
var hkdf = {};
Object.defineProperty(hkdf, "__esModule", { value: true });
var hmac_1 = hmac;
var wipe_1 = wipe;
var HKDF = (
  /** @class */
  function() {
    function HKDF2(hash2, key2, salt, info) {
      if (salt === void 0) {
        salt = new Uint8Array(0);
      }
      this._counter = new Uint8Array(1);
      this._hash = hash2;
      this._info = info;
      var okm = hmac_1.hmac(this._hash, salt, key2);
      this._hmac = new hmac_1.HMAC(hash2, okm);
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
      for (var i2 = 0; i2 < out.length; i2++) {
        if (this._bufpos === this._buffer.length) {
          this._fillBuffer();
        }
        out[i2] = this._buffer[this._bufpos++];
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
(function(exports) {
  Object.defineProperty(exports, "__esModule", { value: true });
  var binary_1 = binary;
  var wipe_12 = wipe;
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
          for (var i2 = left + 1; i2 < padLength - 8; i2++) {
            this._buffer[i2] = 0;
          }
          binary_1.writeUint32BE(bitLenHi, this._buffer, padLength - 8);
          binary_1.writeUint32BE(bitLenLo, this._buffer, padLength - 4);
          hashBlocks(this._temp, this._state, this._buffer, 0, padLength);
          this._finished = true;
        }
        for (var i2 = 0; i2 < this.digestLength / 4; i2++) {
          binary_1.writeUint32BE(this._state[i2], out, i2 * 4);
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
  function hashBlocks(w3, v3, p3, pos, len) {
    while (len >= 64) {
      var a3 = v3[0];
      var b3 = v3[1];
      var c2 = v3[2];
      var d4 = v3[3];
      var e = v3[4];
      var f3 = v3[5];
      var g3 = v3[6];
      var h4 = v3[7];
      for (var i2 = 0; i2 < 16; i2++) {
        var j2 = pos + i2 * 4;
        w3[i2] = binary_1.readUint32BE(p3, j2);
      }
      for (var i2 = 16; i2 < 64; i2++) {
        var u2 = w3[i2 - 2];
        var t1 = (u2 >>> 17 | u2 << 32 - 17) ^ (u2 >>> 19 | u2 << 32 - 19) ^ u2 >>> 10;
        u2 = w3[i2 - 15];
        var t2 = (u2 >>> 7 | u2 << 32 - 7) ^ (u2 >>> 18 | u2 << 32 - 18) ^ u2 >>> 3;
        w3[i2] = (t1 + w3[i2 - 7] | 0) + (t2 + w3[i2 - 16] | 0);
      }
      for (var i2 = 0; i2 < 64; i2++) {
        var t1 = (((e >>> 6 | e << 32 - 6) ^ (e >>> 11 | e << 32 - 11) ^ (e >>> 25 | e << 32 - 25)) + (e & f3 ^ ~e & g3) | 0) + (h4 + (K3[i2] + w3[i2] | 0) | 0) | 0;
        var t2 = ((a3 >>> 2 | a3 << 32 - 2) ^ (a3 >>> 13 | a3 << 32 - 13) ^ (a3 >>> 22 | a3 << 32 - 22)) + (a3 & b3 ^ a3 & c2 ^ b3 & c2) | 0;
        h4 = g3;
        g3 = f3;
        f3 = e;
        e = d4 + t1 | 0;
        d4 = c2;
        c2 = b3;
        b3 = a3;
        a3 = t1 + t2 | 0;
      }
      v3[0] += a3;
      v3[1] += b3;
      v3[2] += c2;
      v3[3] += d4;
      v3[4] += e;
      v3[5] += f3;
      v3[6] += g3;
      v3[7] += h4;
      pos += 64;
      len -= 64;
    }
    return pos;
  }
  function hash2(data) {
    var h4 = new SHA256();
    h4.update(data);
    var digest = h4.digest();
    h4.clean();
    return digest;
  }
  exports.hash = hash2;
})(sha256);
var x25519 = {};
(function(exports) {
  Object.defineProperty(exports, "__esModule", { value: true });
  exports.sharedKey = exports.generateKeyPair = exports.generateKeyPairFromSeed = exports.scalarMultBase = exports.scalarMult = exports.SHARED_KEY_LENGTH = exports.SECRET_KEY_LENGTH = exports.PUBLIC_KEY_LENGTH = void 0;
  const random_1 = random;
  const wipe_12 = wipe;
  exports.PUBLIC_KEY_LENGTH = 32;
  exports.SECRET_KEY_LENGTH = 32;
  exports.SHARED_KEY_LENGTH = 32;
  function gf2(init2) {
    const r = new Float64Array(16);
    if (init2) {
      for (let i2 = 0; i2 < init2.length; i2++) {
        r[i2] = init2[i2];
      }
    }
    return r;
  }
  const _9 = new Uint8Array(32);
  _9[0] = 9;
  const _121665 = gf2([56129, 1]);
  function car25519(o2) {
    let c2 = 1;
    for (let i2 = 0; i2 < 16; i2++) {
      let v3 = o2[i2] + c2 + 65535;
      c2 = Math.floor(v3 / 65536);
      o2[i2] = v3 - c2 * 65536;
    }
    o2[0] += c2 - 1 + 37 * (c2 - 1);
  }
  function sel25519(p3, q2, b3) {
    const c2 = ~(b3 - 1);
    for (let i2 = 0; i2 < 16; i2++) {
      const t = c2 & (p3[i2] ^ q2[i2]);
      p3[i2] ^= t;
      q2[i2] ^= t;
    }
  }
  function pack25519(o2, n2) {
    const m3 = gf2();
    const t = gf2();
    for (let i2 = 0; i2 < 16; i2++) {
      t[i2] = n2[i2];
    }
    car25519(t);
    car25519(t);
    car25519(t);
    for (let j2 = 0; j2 < 2; j2++) {
      m3[0] = t[0] - 65517;
      for (let i2 = 1; i2 < 15; i2++) {
        m3[i2] = t[i2] - 65535 - (m3[i2 - 1] >> 16 & 1);
        m3[i2 - 1] &= 65535;
      }
      m3[15] = t[15] - 32767 - (m3[14] >> 16 & 1);
      const b3 = m3[15] >> 16 & 1;
      m3[14] &= 65535;
      sel25519(t, m3, 1 - b3);
    }
    for (let i2 = 0; i2 < 16; i2++) {
      o2[2 * i2] = t[i2] & 255;
      o2[2 * i2 + 1] = t[i2] >> 8;
    }
  }
  function unpack25519(o2, n2) {
    for (let i2 = 0; i2 < 16; i2++) {
      o2[i2] = n2[2 * i2] + (n2[2 * i2 + 1] << 8);
    }
    o2[15] &= 32767;
  }
  function add3(o2, a3, b3) {
    for (let i2 = 0; i2 < 16; i2++) {
      o2[i2] = a3[i2] + b3[i2];
    }
  }
  function sub(o2, a3, b3) {
    for (let i2 = 0; i2 < 16; i2++) {
      o2[i2] = a3[i2] - b3[i2];
    }
  }
  function mul3(o2, a3, b3) {
    let v3, c2, t0 = 0, t1 = 0, t2 = 0, t3 = 0, t4 = 0, t5 = 0, t6 = 0, t7 = 0, t8 = 0, t9 = 0, t10 = 0, t11 = 0, t12 = 0, t13 = 0, t14 = 0, t15 = 0, t16 = 0, t17 = 0, t18 = 0, t19 = 0, t20 = 0, t21 = 0, t22 = 0, t23 = 0, t24 = 0, t25 = 0, t26 = 0, t27 = 0, t28 = 0, t29 = 0, t30 = 0, b02 = b3[0], b1 = b3[1], b22 = b3[2], b32 = b3[3], b4 = b3[4], b5 = b3[5], b6 = b3[6], b7 = b3[7], b8 = b3[8], b9 = b3[9], b10 = b3[10], b11 = b3[11], b12 = b3[12], b13 = b3[13], b14 = b3[14], b15 = b3[15];
    v3 = a3[0];
    t0 += v3 * b02;
    t1 += v3 * b1;
    t2 += v3 * b22;
    t3 += v3 * b32;
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
    t1 += v3 * b02;
    t2 += v3 * b1;
    t3 += v3 * b22;
    t4 += v3 * b32;
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
    t2 += v3 * b02;
    t3 += v3 * b1;
    t4 += v3 * b22;
    t5 += v3 * b32;
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
    t3 += v3 * b02;
    t4 += v3 * b1;
    t5 += v3 * b22;
    t6 += v3 * b32;
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
    t4 += v3 * b02;
    t5 += v3 * b1;
    t6 += v3 * b22;
    t7 += v3 * b32;
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
    t5 += v3 * b02;
    t6 += v3 * b1;
    t7 += v3 * b22;
    t8 += v3 * b32;
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
    t6 += v3 * b02;
    t7 += v3 * b1;
    t8 += v3 * b22;
    t9 += v3 * b32;
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
    t7 += v3 * b02;
    t8 += v3 * b1;
    t9 += v3 * b22;
    t10 += v3 * b32;
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
    t8 += v3 * b02;
    t9 += v3 * b1;
    t10 += v3 * b22;
    t11 += v3 * b32;
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
    t9 += v3 * b02;
    t10 += v3 * b1;
    t11 += v3 * b22;
    t12 += v3 * b32;
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
    t10 += v3 * b02;
    t11 += v3 * b1;
    t12 += v3 * b22;
    t13 += v3 * b32;
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
    t11 += v3 * b02;
    t12 += v3 * b1;
    t13 += v3 * b22;
    t14 += v3 * b32;
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
    t12 += v3 * b02;
    t13 += v3 * b1;
    t14 += v3 * b22;
    t15 += v3 * b32;
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
    t13 += v3 * b02;
    t14 += v3 * b1;
    t15 += v3 * b22;
    t16 += v3 * b32;
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
    t14 += v3 * b02;
    t15 += v3 * b1;
    t16 += v3 * b22;
    t17 += v3 * b32;
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
    t15 += v3 * b02;
    t16 += v3 * b1;
    t17 += v3 * b22;
    t18 += v3 * b32;
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
    o2[0] = t0;
    o2[1] = t1;
    o2[2] = t2;
    o2[3] = t3;
    o2[4] = t4;
    o2[5] = t5;
    o2[6] = t6;
    o2[7] = t7;
    o2[8] = t8;
    o2[9] = t9;
    o2[10] = t10;
    o2[11] = t11;
    o2[12] = t12;
    o2[13] = t13;
    o2[14] = t14;
    o2[15] = t15;
  }
  function square(o2, a3) {
    mul3(o2, a3, a3);
  }
  function inv25519(o2, inp) {
    const c2 = gf2();
    for (let i2 = 0; i2 < 16; i2++) {
      c2[i2] = inp[i2];
    }
    for (let i2 = 253; i2 >= 0; i2--) {
      square(c2, c2);
      if (i2 !== 2 && i2 !== 4) {
        mul3(c2, c2, inp);
      }
    }
    for (let i2 = 0; i2 < 16; i2++) {
      o2[i2] = c2[i2];
    }
  }
  function scalarMult(n2, p3) {
    const z2 = new Uint8Array(32);
    const x2 = new Float64Array(80);
    const a3 = gf2(), b3 = gf2(), c2 = gf2(), d4 = gf2(), e = gf2(), f3 = gf2();
    for (let i2 = 0; i2 < 31; i2++) {
      z2[i2] = n2[i2];
    }
    z2[31] = n2[31] & 127 | 64;
    z2[0] &= 248;
    unpack25519(x2, p3);
    for (let i2 = 0; i2 < 16; i2++) {
      b3[i2] = x2[i2];
    }
    a3[0] = d4[0] = 1;
    for (let i2 = 254; i2 >= 0; --i2) {
      const r = z2[i2 >>> 3] >>> (i2 & 7) & 1;
      sel25519(a3, b3, r);
      sel25519(c2, d4, r);
      add3(e, a3, c2);
      sub(a3, a3, c2);
      add3(c2, b3, d4);
      sub(b3, b3, d4);
      square(d4, e);
      square(f3, a3);
      mul3(a3, c2, a3);
      mul3(c2, b3, e);
      add3(e, a3, c2);
      sub(a3, a3, c2);
      square(b3, a3);
      sub(c2, d4, f3);
      mul3(a3, c2, _121665);
      add3(a3, a3, d4);
      mul3(c2, c2, a3);
      mul3(a3, d4, f3);
      mul3(d4, b3, x2);
      square(b3, e);
      sel25519(a3, b3, r);
      sel25519(c2, d4, r);
    }
    for (let i2 = 0; i2 < 16; i2++) {
      x2[i2 + 16] = a3[i2];
      x2[i2 + 32] = c2[i2];
      x2[i2 + 48] = b3[i2];
      x2[i2 + 64] = d4[i2];
    }
    const x32 = x2.subarray(32);
    const x16 = x2.subarray(16);
    inv25519(x32, x32);
    mul3(x16, x16, x32);
    const q2 = new Uint8Array(32);
    pack25519(q2, x16);
    return q2;
  }
  exports.scalarMult = scalarMult;
  function scalarMultBase(n2) {
    return scalarMult(n2, _9);
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
      for (let i2 = 0; i2 < result.length; i2++) {
        zeros |= result[i2];
      }
      if (zeros === 0) {
        throw new Error("X25519: invalid shared key");
      }
    }
    return result;
  }
  exports.sharedKey = sharedKey;
})(x25519);
const RELAY_JSONRPC = {
  waku: {
    publish: "waku_publish",
    batchPublish: "waku_batchPublish",
    subscribe: "waku_subscribe",
    batchSubscribe: "waku_batchSubscribe",
    subscription: "waku_subscription",
    unsubscribe: "waku_unsubscribe",
    batchUnsubscribe: "waku_batchUnsubscribe"
  },
  irn: {
    publish: "irn_publish",
    batchPublish: "irn_batchPublish",
    subscribe: "irn_subscribe",
    batchSubscribe: "irn_batchSubscribe",
    subscription: "irn_subscription",
    unsubscribe: "irn_unsubscribe",
    batchUnsubscribe: "irn_batchUnsubscribe"
  },
  iridium: {
    publish: "iridium_publish",
    batchPublish: "iridium_batchPublish",
    subscribe: "iridium_subscribe",
    batchSubscribe: "iridium_batchSubscribe",
    subscription: "iridium_subscription",
    unsubscribe: "iridium_unsubscribe",
    batchUnsubscribe: "iridium_batchUnsubscribe"
  }
};
const Ir$1 = ":";
function dn(e) {
  const [t, r] = e.split(Ir$1);
  return { namespace: t, reference: r };
}
function _r$2(e, t) {
  return e.includes(":") ? [e] : t.chains || [];
}
var Qo = Object.defineProperty, bn = Object.getOwnPropertySymbols, Jo = Object.prototype.hasOwnProperty, Go = Object.prototype.propertyIsEnumerable, yn = (e, t, r) => t in e ? Qo(e, t, { enumerable: true, configurable: true, writable: true, value: r }) : e[t] = r, wn = (e, t) => {
  for (var r in t || (t = {}))
    Jo.call(t, r) && yn(e, r, t[r]);
  if (bn)
    for (var r of bn(t))
      Go.call(t, r) && yn(e, r, t[r]);
  return e;
};
const xn = "ReactNative", qt$2 = { reactNative: "react-native", node: "node", browser: "browser", unknown: "unknown" }, En = "js";
function pi() {
  return typeof process$1 < "u" && typeof process$1.versions < "u" && typeof process$1.versions.node < "u";
}
function er$2() {
  return !getDocument_1() && !!getNavigator_1() && navigator.product === xn;
}
function pr$2() {
  return !pi() && !!getNavigator_1() && !!getDocument_1();
}
function We$3() {
  return er$2() ? qt$2.reactNative : pi() ? qt$2.node : pr$2() ? qt$2.browser : qt$2.unknown;
}
function Wo() {
  var e;
  try {
    return er$2() && typeof global < "u" && typeof (global == null ? void 0 : global.Application) < "u" ? (e = global.Application) == null ? void 0 : e.applicationId : void 0;
  } catch {
    return;
  }
}
function Sn(e, t) {
  let r = queryString.parse(e);
  return r = wn(wn({}, r), t), e = queryString.stringify(r), e;
}
function Xo() {
  return getWindowMetadata_1() || { name: "", description: "", url: "", icons: [""] };
}
function Nn() {
  if (We$3() === qt$2.reactNative && typeof global < "u" && typeof (global == null ? void 0 : global.Platform) < "u") {
    const { OS: r, Version: i2 } = global.Platform;
    return [r, i2].join("-");
  }
  const e = detect();
  if (e === null)
    return "unknown";
  const t = e.os ? e.os.replace(" ", "").toLowerCase() : "unknown";
  return e.type === "browser" ? [t, e.name, e.version].join("-") : [t, e.version].join("-");
}
function In() {
  var e;
  const t = We$3();
  return t === qt$2.browser ? [t, ((e = getLocation_1()) == null ? void 0 : e.host) || "unknown"].join(":") : t;
}
function _n(e, t, r) {
  const i2 = Nn(), n2 = In();
  return [[e, t].join("-"), [En, r].join("-"), i2, n2].join("/");
}
function $o({ protocol: e, version: t, relayUrl: r, sdkVersion: i2, auth: n2, projectId: o2, useOnCloseEvent: h4, bundleId: p3 }) {
  const b3 = r.split("?"), m3 = _n(e, t, i2), w3 = { auth: n2, ua: m3, projectId: o2, useOnCloseEvent: h4 || void 0, origin: p3 || void 0 }, y3 = Sn(b3[1] || "", w3);
  return b3[0] + "?" + y3;
}
function _e$1(e, t) {
  return e.filter((r) => t.includes(r)).length === e.length;
}
function i0(e) {
  return Object.fromEntries(e.entries());
}
function n0(e) {
  return new Map(Object.entries(e));
}
function a0(e = cjs$3.FIVE_MINUTES, t) {
  const r = cjs$3.toMiliseconds(e || cjs$3.FIVE_MINUTES);
  let i2, n2, o2;
  return { resolve: (h4) => {
    o2 && i2 && (clearTimeout(o2), i2(h4));
  }, reject: (h4) => {
    o2 && n2 && (clearTimeout(o2), n2(h4));
  }, done: () => new Promise((h4, p3) => {
    o2 = setTimeout(() => {
      p3(new Error(t));
    }, r), i2 = h4, n2 = p3;
  }) };
}
function u0(e, t, r) {
  return new Promise(async (i2, n2) => {
    const o2 = setTimeout(() => n2(new Error(r)), t);
    try {
      const h4 = await e;
      i2(h4);
    } catch (h4) {
      n2(h4);
    }
    clearTimeout(o2);
  });
}
function vi(e, t) {
  if (typeof t == "string" && t.startsWith(`${e}:`))
    return t;
  if (e.toLowerCase() === "topic") {
    if (typeof t != "string")
      throw new Error('Value must be "string" for expirer target type: topic');
    return `topic:${t}`;
  } else if (e.toLowerCase() === "id") {
    if (typeof t != "number")
      throw new Error('Value must be "number" for expirer target type: id');
    return `id:${t}`;
  }
  throw new Error(`Unknown expirer target type: ${e}`);
}
function h0(e) {
  return vi("topic", e);
}
function c0(e) {
  return vi("id", e);
}
function l0(e) {
  const [t, r] = e.split(":"), i2 = { id: void 0, topic: void 0 };
  if (t === "topic" && typeof r == "string")
    i2.topic = r;
  else if (t === "id" && Number.isInteger(Number(r)))
    i2.id = Number(r);
  else
    throw new Error(`Invalid target, expected id:number or topic:string, got ${t}:${r}`);
  return i2;
}
function d0(e, t) {
  return cjs$3.fromMiliseconds((t || Date.now()) + cjs$3.toMiliseconds(e));
}
function p0(e) {
  return Date.now() >= cjs$3.toMiliseconds(e);
}
function v0(e, t) {
  return `${e}${t ? `:${t}` : ""}`;
}
function ge$2(e = [], t = []) {
  return [.../* @__PURE__ */ new Set([...e, ...t])];
}
async function m0({ id: e, topic: t, wcDeepLink: r }) {
  try {
    if (!r)
      return;
    const i2 = typeof r == "string" ? JSON.parse(r) : r;
    let n2 = i2 == null ? void 0 : i2.href;
    if (typeof n2 != "string")
      return;
    n2.endsWith("/") && (n2 = n2.slice(0, -1));
    const o2 = `${n2}/wc?requestId=${e}&sessionTopic=${t}`, h4 = We$3();
    h4 === qt$2.browser ? o2.startsWith("https://") || o2.startsWith("http://") ? window.open(o2, "_blank", "noreferrer noopener") : window.open(o2, "_self", "noreferrer noopener") : h4 === qt$2.reactNative && typeof (global == null ? void 0 : global.Linking) < "u" && await global.Linking.openURL(o2);
  } catch (i2) {
    console.error(i2);
  }
}
async function g0(e, t) {
  try {
    return await e.getItem(t) || (pr$2() ? localStorage.getItem(t) : void 0);
  } catch (r) {
    console.error(r);
  }
}
var On = typeof globalThis < "u" ? globalThis : typeof window < "u" ? window : typeof global < "u" ? global : typeof self < "u" ? self : {};
function A0(e) {
  var t = e.default;
  if (typeof t == "function") {
    var r = function() {
      return t.apply(this, arguments);
    };
    r.prototype = t.prototype;
  } else
    r = {};
  return Object.defineProperty(r, "__esModule", { value: true }), Object.keys(e).forEach(function(i2) {
    var n2 = Object.getOwnPropertyDescriptor(e, i2);
    Object.defineProperty(r, i2, n2.get ? n2 : { enumerable: true, get: function() {
      return e[i2];
    } });
  }), r;
}
var Pn = { exports: {} };
/**
* [js-sha3]{@link https://github.com/emn178/js-sha3}
*
* @version 0.8.0
* @author Chen, Yi-Cyuan [emn178@gmail.com]
* @copyright Chen, Yi-Cyuan 2015-2018
* @license MIT
*/
(function(e) {
  (function() {
    var t = "input is invalid type", r = "finalize already called", i2 = typeof window == "object", n2 = i2 ? window : {};
    n2.JS_SHA3_NO_WINDOW && (i2 = false);
    var o2 = !i2 && typeof self == "object", h4 = !n2.JS_SHA3_NO_NODE_JS && typeof process$1 == "object" && process$1.versions && process$1.versions.node;
    h4 ? n2 = On : o2 && (n2 = self);
    var p3 = !n2.JS_SHA3_NO_COMMON_JS && true && e.exports, b3 = !n2.JS_SHA3_NO_ARRAY_BUFFER && typeof ArrayBuffer < "u", m3 = "0123456789abcdef".split(""), w3 = [31, 7936, 2031616, 520093696], y3 = [4, 1024, 262144, 67108864], S3 = [1, 256, 65536, 16777216], I2 = [6, 1536, 393216, 100663296], N2 = [0, 8, 16, 24], C2 = [1, 0, 32898, 0, 32906, 2147483648, 2147516416, 2147483648, 32907, 0, 2147483649, 0, 2147516545, 2147483648, 32777, 2147483648, 138, 0, 136, 0, 2147516425, 0, 2147483658, 0, 2147516555, 0, 139, 2147483648, 32905, 2147483648, 32771, 2147483648, 32770, 2147483648, 128, 2147483648, 32778, 0, 2147483658, 2147483648, 2147516545, 2147483648, 32896, 2147483648, 2147483649, 0, 2147516424, 2147483648], F2 = [224, 256, 384, 512], U2 = [128, 256], J2 = ["hex", "buffer", "arrayBuffer", "array", "digest"], Bt2 = { 128: 168, 256: 136 };
    (n2.JS_SHA3_NO_NODE_JS || !Array.isArray) && (Array.isArray = function(u2) {
      return Object.prototype.toString.call(u2) === "[object Array]";
    }), b3 && (n2.JS_SHA3_NO_ARRAY_BUFFER_IS_VIEW || !ArrayBuffer.isView) && (ArrayBuffer.isView = function(u2) {
      return typeof u2 == "object" && u2.buffer && u2.buffer.constructor === ArrayBuffer;
    });
    for (var G2 = function(u2, E3, _3) {
      return function(B3) {
        return new s(u2, E3, u2).update(B3)[_3]();
      };
    }, H2 = function(u2, E3, _3) {
      return function(B3, R2) {
        return new s(u2, E3, R2).update(B3)[_3]();
      };
    }, z2 = function(u2, E3, _3) {
      return function(B3, R2, T2, P2) {
        return f3["cshake" + u2].update(B3, R2, T2, P2)[_3]();
      };
    }, Pt2 = function(u2, E3, _3) {
      return function(B3, R2, T2, P2) {
        return f3["kmac" + u2].update(B3, R2, T2, P2)[_3]();
      };
    }, W2 = function(u2, E3, _3, B3) {
      for (var R2 = 0; R2 < J2.length; ++R2) {
        var T2 = J2[R2];
        u2[T2] = E3(_3, B3, T2);
      }
      return u2;
    }, Rt2 = function(u2, E3) {
      var _3 = G2(u2, E3, "hex");
      return _3.create = function() {
        return new s(u2, E3, u2);
      }, _3.update = function(B3) {
        return _3.create().update(B3);
      }, W2(_3, G2, u2, E3);
    }, Yt3 = function(u2, E3) {
      var _3 = H2(u2, E3, "hex");
      return _3.create = function(B3) {
        return new s(u2, E3, B3);
      }, _3.update = function(B3, R2) {
        return _3.create(R2).update(B3);
      }, W2(_3, H2, u2, E3);
    }, Y2 = function(u2, E3) {
      var _3 = Bt2[u2], B3 = z2(u2, E3, "hex");
      return B3.create = function(R2, T2, P2) {
        return !T2 && !P2 ? f3["shake" + u2].create(R2) : new s(u2, E3, R2).bytepad([T2, P2], _3);
      }, B3.update = function(R2, T2, P2, O3) {
        return B3.create(T2, P2, O3).update(R2);
      }, W2(B3, z2, u2, E3);
    }, Vt3 = function(u2, E3) {
      var _3 = Bt2[u2], B3 = Pt2(u2, E3, "hex");
      return B3.create = function(R2, T2, P2) {
        return new v3(u2, E3, T2).bytepad(["KMAC", P2], _3).bytepad([R2], _3);
      }, B3.update = function(R2, T2, P2, O3) {
        return B3.create(R2, P2, O3).update(T2);
      }, W2(B3, Pt2, u2, E3);
    }, A2 = [{ name: "keccak", padding: S3, bits: F2, createMethod: Rt2 }, { name: "sha3", padding: I2, bits: F2, createMethod: Rt2 }, { name: "shake", padding: w3, bits: U2, createMethod: Yt3 }, { name: "cshake", padding: y3, bits: U2, createMethod: Y2 }, { name: "kmac", padding: y3, bits: U2, createMethod: Vt3 }], f3 = {}, a3 = [], c2 = 0; c2 < A2.length; ++c2)
      for (var d4 = A2[c2], g3 = d4.bits, x2 = 0; x2 < g3.length; ++x2) {
        var M2 = d4.name + "_" + g3[x2];
        if (a3.push(M2), f3[M2] = d4.createMethod(g3[x2], d4.padding), d4.name !== "sha3") {
          var l2 = d4.name + g3[x2];
          a3.push(l2), f3[l2] = f3[M2];
        }
      }
    function s(u2, E3, _3) {
      this.blocks = [], this.s = [], this.padding = E3, this.outputBits = _3, this.reset = true, this.finalized = false, this.block = 0, this.start = 0, this.blockCount = 1600 - (u2 << 1) >> 5, this.byteCount = this.blockCount << 2, this.outputBlocks = _3 >> 5, this.extraBytes = (_3 & 31) >> 3;
      for (var B3 = 0; B3 < 50; ++B3)
        this.s[B3] = 0;
    }
    s.prototype.update = function(u2) {
      if (this.finalized)
        throw new Error(r);
      var E3, _3 = typeof u2;
      if (_3 !== "string") {
        if (_3 === "object") {
          if (u2 === null)
            throw new Error(t);
          if (b3 && u2.constructor === ArrayBuffer)
            u2 = new Uint8Array(u2);
          else if (!Array.isArray(u2) && (!b3 || !ArrayBuffer.isView(u2)))
            throw new Error(t);
        } else
          throw new Error(t);
        E3 = true;
      }
      for (var B3 = this.blocks, R2 = this.byteCount, T2 = u2.length, P2 = this.blockCount, O3 = 0, Ct2 = this.s, D2, q2; O3 < T2; ) {
        if (this.reset)
          for (this.reset = false, B3[0] = this.block, D2 = 1; D2 < P2 + 1; ++D2)
            B3[D2] = 0;
        if (E3)
          for (D2 = this.start; O3 < T2 && D2 < R2; ++O3)
            B3[D2 >> 2] |= u2[O3] << N2[D2++ & 3];
        else
          for (D2 = this.start; O3 < T2 && D2 < R2; ++O3)
            q2 = u2.charCodeAt(O3), q2 < 128 ? B3[D2 >> 2] |= q2 << N2[D2++ & 3] : q2 < 2048 ? (B3[D2 >> 2] |= (192 | q2 >> 6) << N2[D2++ & 3], B3[D2 >> 2] |= (128 | q2 & 63) << N2[D2++ & 3]) : q2 < 55296 || q2 >= 57344 ? (B3[D2 >> 2] |= (224 | q2 >> 12) << N2[D2++ & 3], B3[D2 >> 2] |= (128 | q2 >> 6 & 63) << N2[D2++ & 3], B3[D2 >> 2] |= (128 | q2 & 63) << N2[D2++ & 3]) : (q2 = 65536 + ((q2 & 1023) << 10 | u2.charCodeAt(++O3) & 1023), B3[D2 >> 2] |= (240 | q2 >> 18) << N2[D2++ & 3], B3[D2 >> 2] |= (128 | q2 >> 12 & 63) << N2[D2++ & 3], B3[D2 >> 2] |= (128 | q2 >> 6 & 63) << N2[D2++ & 3], B3[D2 >> 2] |= (128 | q2 & 63) << N2[D2++ & 3]);
        if (this.lastByteIndex = D2, D2 >= R2) {
          for (this.start = D2 - R2, this.block = B3[P2], D2 = 0; D2 < P2; ++D2)
            Ct2[D2] ^= B3[D2];
          k2(Ct2), this.reset = true;
        } else
          this.start = D2;
      }
      return this;
    }, s.prototype.encode = function(u2, E3) {
      var _3 = u2 & 255, B3 = 1, R2 = [_3];
      for (u2 = u2 >> 8, _3 = u2 & 255; _3 > 0; )
        R2.unshift(_3), u2 = u2 >> 8, _3 = u2 & 255, ++B3;
      return E3 ? R2.push(B3) : R2.unshift(B3), this.update(R2), R2.length;
    }, s.prototype.encodeString = function(u2) {
      var E3, _3 = typeof u2;
      if (_3 !== "string") {
        if (_3 === "object") {
          if (u2 === null)
            throw new Error(t);
          if (b3 && u2.constructor === ArrayBuffer)
            u2 = new Uint8Array(u2);
          else if (!Array.isArray(u2) && (!b3 || !ArrayBuffer.isView(u2)))
            throw new Error(t);
        } else
          throw new Error(t);
        E3 = true;
      }
      var B3 = 0, R2 = u2.length;
      if (E3)
        B3 = R2;
      else
        for (var T2 = 0; T2 < u2.length; ++T2) {
          var P2 = u2.charCodeAt(T2);
          P2 < 128 ? B3 += 1 : P2 < 2048 ? B3 += 2 : P2 < 55296 || P2 >= 57344 ? B3 += 3 : (P2 = 65536 + ((P2 & 1023) << 10 | u2.charCodeAt(++T2) & 1023), B3 += 4);
        }
      return B3 += this.encode(B3 * 8), this.update(u2), B3;
    }, s.prototype.bytepad = function(u2, E3) {
      for (var _3 = this.encode(E3), B3 = 0; B3 < u2.length; ++B3)
        _3 += this.encodeString(u2[B3]);
      var R2 = E3 - _3 % E3, T2 = [];
      return T2.length = R2, this.update(T2), this;
    }, s.prototype.finalize = function() {
      if (!this.finalized) {
        this.finalized = true;
        var u2 = this.blocks, E3 = this.lastByteIndex, _3 = this.blockCount, B3 = this.s;
        if (u2[E3 >> 2] |= this.padding[E3 & 3], this.lastByteIndex === this.byteCount)
          for (u2[0] = u2[_3], E3 = 1; E3 < _3 + 1; ++E3)
            u2[E3] = 0;
        for (u2[_3 - 1] |= 2147483648, E3 = 0; E3 < _3; ++E3)
          B3[E3] ^= u2[E3];
        k2(B3);
      }
    }, s.prototype.toString = s.prototype.hex = function() {
      this.finalize();
      for (var u2 = this.blockCount, E3 = this.s, _3 = this.outputBlocks, B3 = this.extraBytes, R2 = 0, T2 = 0, P2 = "", O3; T2 < _3; ) {
        for (R2 = 0; R2 < u2 && T2 < _3; ++R2, ++T2)
          O3 = E3[R2], P2 += m3[O3 >> 4 & 15] + m3[O3 & 15] + m3[O3 >> 12 & 15] + m3[O3 >> 8 & 15] + m3[O3 >> 20 & 15] + m3[O3 >> 16 & 15] + m3[O3 >> 28 & 15] + m3[O3 >> 24 & 15];
        T2 % u2 === 0 && (k2(E3), R2 = 0);
      }
      return B3 && (O3 = E3[R2], P2 += m3[O3 >> 4 & 15] + m3[O3 & 15], B3 > 1 && (P2 += m3[O3 >> 12 & 15] + m3[O3 >> 8 & 15]), B3 > 2 && (P2 += m3[O3 >> 20 & 15] + m3[O3 >> 16 & 15])), P2;
    }, s.prototype.arrayBuffer = function() {
      this.finalize();
      var u2 = this.blockCount, E3 = this.s, _3 = this.outputBlocks, B3 = this.extraBytes, R2 = 0, T2 = 0, P2 = this.outputBits >> 3, O3;
      B3 ? O3 = new ArrayBuffer(_3 + 1 << 2) : O3 = new ArrayBuffer(P2);
      for (var Ct2 = new Uint32Array(O3); T2 < _3; ) {
        for (R2 = 0; R2 < u2 && T2 < _3; ++R2, ++T2)
          Ct2[T2] = E3[R2];
        T2 % u2 === 0 && k2(E3);
      }
      return B3 && (Ct2[R2] = E3[R2], O3 = O3.slice(0, P2)), O3;
    }, s.prototype.buffer = s.prototype.arrayBuffer, s.prototype.digest = s.prototype.array = function() {
      this.finalize();
      for (var u2 = this.blockCount, E3 = this.s, _3 = this.outputBlocks, B3 = this.extraBytes, R2 = 0, T2 = 0, P2 = [], O3, Ct2; T2 < _3; ) {
        for (R2 = 0; R2 < u2 && T2 < _3; ++R2, ++T2)
          O3 = T2 << 2, Ct2 = E3[R2], P2[O3] = Ct2 & 255, P2[O3 + 1] = Ct2 >> 8 & 255, P2[O3 + 2] = Ct2 >> 16 & 255, P2[O3 + 3] = Ct2 >> 24 & 255;
        T2 % u2 === 0 && k2(E3);
      }
      return B3 && (O3 = T2 << 2, Ct2 = E3[R2], P2[O3] = Ct2 & 255, B3 > 1 && (P2[O3 + 1] = Ct2 >> 8 & 255), B3 > 2 && (P2[O3 + 2] = Ct2 >> 16 & 255)), P2;
    };
    function v3(u2, E3, _3) {
      s.call(this, u2, E3, _3);
    }
    v3.prototype = new s(), v3.prototype.finalize = function() {
      return this.encode(this.outputBits, true), s.prototype.finalize.call(this);
    };
    var k2 = function(u2) {
      var E3, _3, B3, R2, T2, P2, O3, Ct2, D2, q2, De2, X2, Z2, Fe2, $2, tt2, Te, et2, rt2, Ue2, it2, nt2, ke2, ft2, ot2, qe2, st2, at2, Ke2, ut2, ht2, He2, ct2, lt2, ze2, dt2, pt2, Le, vt2, mt2, je2, gt2, At3, Qe2, bt2, yt2, Je2, wt2, xt2, Ge2, Mt2, Et2, Ye2, St2, Nt2, Ve2, It2, _t2, Me2, Ee2, Se2, Ne, Ie;
      for (B3 = 0; B3 < 48; B3 += 2)
        R2 = u2[0] ^ u2[10] ^ u2[20] ^ u2[30] ^ u2[40], T2 = u2[1] ^ u2[11] ^ u2[21] ^ u2[31] ^ u2[41], P2 = u2[2] ^ u2[12] ^ u2[22] ^ u2[32] ^ u2[42], O3 = u2[3] ^ u2[13] ^ u2[23] ^ u2[33] ^ u2[43], Ct2 = u2[4] ^ u2[14] ^ u2[24] ^ u2[34] ^ u2[44], D2 = u2[5] ^ u2[15] ^ u2[25] ^ u2[35] ^ u2[45], q2 = u2[6] ^ u2[16] ^ u2[26] ^ u2[36] ^ u2[46], De2 = u2[7] ^ u2[17] ^ u2[27] ^ u2[37] ^ u2[47], X2 = u2[8] ^ u2[18] ^ u2[28] ^ u2[38] ^ u2[48], Z2 = u2[9] ^ u2[19] ^ u2[29] ^ u2[39] ^ u2[49], E3 = X2 ^ (P2 << 1 | O3 >>> 31), _3 = Z2 ^ (O3 << 1 | P2 >>> 31), u2[0] ^= E3, u2[1] ^= _3, u2[10] ^= E3, u2[11] ^= _3, u2[20] ^= E3, u2[21] ^= _3, u2[30] ^= E3, u2[31] ^= _3, u2[40] ^= E3, u2[41] ^= _3, E3 = R2 ^ (Ct2 << 1 | D2 >>> 31), _3 = T2 ^ (D2 << 1 | Ct2 >>> 31), u2[2] ^= E3, u2[3] ^= _3, u2[12] ^= E3, u2[13] ^= _3, u2[22] ^= E3, u2[23] ^= _3, u2[32] ^= E3, u2[33] ^= _3, u2[42] ^= E3, u2[43] ^= _3, E3 = P2 ^ (q2 << 1 | De2 >>> 31), _3 = O3 ^ (De2 << 1 | q2 >>> 31), u2[4] ^= E3, u2[5] ^= _3, u2[14] ^= E3, u2[15] ^= _3, u2[24] ^= E3, u2[25] ^= _3, u2[34] ^= E3, u2[35] ^= _3, u2[44] ^= E3, u2[45] ^= _3, E3 = Ct2 ^ (X2 << 1 | Z2 >>> 31), _3 = D2 ^ (Z2 << 1 | X2 >>> 31), u2[6] ^= E3, u2[7] ^= _3, u2[16] ^= E3, u2[17] ^= _3, u2[26] ^= E3, u2[27] ^= _3, u2[36] ^= E3, u2[37] ^= _3, u2[46] ^= E3, u2[47] ^= _3, E3 = q2 ^ (R2 << 1 | T2 >>> 31), _3 = De2 ^ (T2 << 1 | R2 >>> 31), u2[8] ^= E3, u2[9] ^= _3, u2[18] ^= E3, u2[19] ^= _3, u2[28] ^= E3, u2[29] ^= _3, u2[38] ^= E3, u2[39] ^= _3, u2[48] ^= E3, u2[49] ^= _3, Fe2 = u2[0], $2 = u2[1], yt2 = u2[11] << 4 | u2[10] >>> 28, Je2 = u2[10] << 4 | u2[11] >>> 28, at2 = u2[20] << 3 | u2[21] >>> 29, Ke2 = u2[21] << 3 | u2[20] >>> 29, Ee2 = u2[31] << 9 | u2[30] >>> 23, Se2 = u2[30] << 9 | u2[31] >>> 23, gt2 = u2[40] << 18 | u2[41] >>> 14, At3 = u2[41] << 18 | u2[40] >>> 14, lt2 = u2[2] << 1 | u2[3] >>> 31, ze2 = u2[3] << 1 | u2[2] >>> 31, tt2 = u2[13] << 12 | u2[12] >>> 20, Te = u2[12] << 12 | u2[13] >>> 20, wt2 = u2[22] << 10 | u2[23] >>> 22, xt2 = u2[23] << 10 | u2[22] >>> 22, ut2 = u2[33] << 13 | u2[32] >>> 19, ht2 = u2[32] << 13 | u2[33] >>> 19, Ne = u2[42] << 2 | u2[43] >>> 30, Ie = u2[43] << 2 | u2[42] >>> 30, St2 = u2[5] << 30 | u2[4] >>> 2, Nt2 = u2[4] << 30 | u2[5] >>> 2, dt2 = u2[14] << 6 | u2[15] >>> 26, pt2 = u2[15] << 6 | u2[14] >>> 26, et2 = u2[25] << 11 | u2[24] >>> 21, rt2 = u2[24] << 11 | u2[25] >>> 21, Ge2 = u2[34] << 15 | u2[35] >>> 17, Mt2 = u2[35] << 15 | u2[34] >>> 17, He2 = u2[45] << 29 | u2[44] >>> 3, ct2 = u2[44] << 29 | u2[45] >>> 3, ft2 = u2[6] << 28 | u2[7] >>> 4, ot2 = u2[7] << 28 | u2[6] >>> 4, Ve2 = u2[17] << 23 | u2[16] >>> 9, It2 = u2[16] << 23 | u2[17] >>> 9, Le = u2[26] << 25 | u2[27] >>> 7, vt2 = u2[27] << 25 | u2[26] >>> 7, Ue2 = u2[36] << 21 | u2[37] >>> 11, it2 = u2[37] << 21 | u2[36] >>> 11, Et2 = u2[47] << 24 | u2[46] >>> 8, Ye2 = u2[46] << 24 | u2[47] >>> 8, Qe2 = u2[8] << 27 | u2[9] >>> 5, bt2 = u2[9] << 27 | u2[8] >>> 5, qe2 = u2[18] << 20 | u2[19] >>> 12, st2 = u2[19] << 20 | u2[18] >>> 12, _t2 = u2[29] << 7 | u2[28] >>> 25, Me2 = u2[28] << 7 | u2[29] >>> 25, mt2 = u2[38] << 8 | u2[39] >>> 24, je2 = u2[39] << 8 | u2[38] >>> 24, nt2 = u2[48] << 14 | u2[49] >>> 18, ke2 = u2[49] << 14 | u2[48] >>> 18, u2[0] = Fe2 ^ ~tt2 & et2, u2[1] = $2 ^ ~Te & rt2, u2[10] = ft2 ^ ~qe2 & at2, u2[11] = ot2 ^ ~st2 & Ke2, u2[20] = lt2 ^ ~dt2 & Le, u2[21] = ze2 ^ ~pt2 & vt2, u2[30] = Qe2 ^ ~yt2 & wt2, u2[31] = bt2 ^ ~Je2 & xt2, u2[40] = St2 ^ ~Ve2 & _t2, u2[41] = Nt2 ^ ~It2 & Me2, u2[2] = tt2 ^ ~et2 & Ue2, u2[3] = Te ^ ~rt2 & it2, u2[12] = qe2 ^ ~at2 & ut2, u2[13] = st2 ^ ~Ke2 & ht2, u2[22] = dt2 ^ ~Le & mt2, u2[23] = pt2 ^ ~vt2 & je2, u2[32] = yt2 ^ ~wt2 & Ge2, u2[33] = Je2 ^ ~xt2 & Mt2, u2[42] = Ve2 ^ ~_t2 & Ee2, u2[43] = It2 ^ ~Me2 & Se2, u2[4] = et2 ^ ~Ue2 & nt2, u2[5] = rt2 ^ ~it2 & ke2, u2[14] = at2 ^ ~ut2 & He2, u2[15] = Ke2 ^ ~ht2 & ct2, u2[24] = Le ^ ~mt2 & gt2, u2[25] = vt2 ^ ~je2 & At3, u2[34] = wt2 ^ ~Ge2 & Et2, u2[35] = xt2 ^ ~Mt2 & Ye2, u2[44] = _t2 ^ ~Ee2 & Ne, u2[45] = Me2 ^ ~Se2 & Ie, u2[6] = Ue2 ^ ~nt2 & Fe2, u2[7] = it2 ^ ~ke2 & $2, u2[16] = ut2 ^ ~He2 & ft2, u2[17] = ht2 ^ ~ct2 & ot2, u2[26] = mt2 ^ ~gt2 & lt2, u2[27] = je2 ^ ~At3 & ze2, u2[36] = Ge2 ^ ~Et2 & Qe2, u2[37] = Mt2 ^ ~Ye2 & bt2, u2[46] = Ee2 ^ ~Ne & St2, u2[47] = Se2 ^ ~Ie & Nt2, u2[8] = nt2 ^ ~Fe2 & tt2, u2[9] = ke2 ^ ~$2 & Te, u2[18] = He2 ^ ~ft2 & qe2, u2[19] = ct2 ^ ~ot2 & st2, u2[28] = gt2 ^ ~lt2 & dt2, u2[29] = At3 ^ ~ze2 & pt2, u2[38] = Et2 ^ ~Qe2 & yt2, u2[39] = Ye2 ^ ~bt2 & Je2, u2[48] = Ne ^ ~St2 & Ve2, u2[49] = Ie ^ ~Nt2 & It2, u2[0] ^= C2[B3], u2[1] ^= C2[B3 + 1];
    };
    if (p3)
      e.exports = f3;
    else
      for (c2 = 0; c2 < a3.length; ++c2)
        n2[a3[c2]] = f3[a3[c2]];
  })();
})(Pn);
var b0 = Pn.exports;
const y0 = "logger/5.7.0";
let Dn = false, Fn = false;
const Cr$2 = { debug: 1, default: 2, info: 2, warning: 3, error: 4, off: 5 };
let Tn = Cr$2.default, gi = null;
function w0() {
  try {
    const e = [];
    if (["NFD", "NFC", "NFKD", "NFKC"].forEach((t) => {
      try {
        if ("test".normalize(t) !== "test")
          throw new Error("bad normalize");
      } catch {
        e.push(t);
      }
    }), e.length)
      throw new Error("missing " + e.join(", "));
    if (String.fromCharCode(233).normalize("NFD") !== String.fromCharCode(101, 769))
      throw new Error("broken implementation");
  } catch (e) {
    return e.message;
  }
  return null;
}
const Un = w0();
var Ai;
(function(e) {
  e.DEBUG = "DEBUG", e.INFO = "INFO", e.WARNING = "WARNING", e.ERROR = "ERROR", e.OFF = "OFF";
})(Ai || (Ai = {}));
var re$2;
(function(e) {
  e.UNKNOWN_ERROR = "UNKNOWN_ERROR", e.NOT_IMPLEMENTED = "NOT_IMPLEMENTED", e.UNSUPPORTED_OPERATION = "UNSUPPORTED_OPERATION", e.NETWORK_ERROR = "NETWORK_ERROR", e.SERVER_ERROR = "SERVER_ERROR", e.TIMEOUT = "TIMEOUT", e.BUFFER_OVERRUN = "BUFFER_OVERRUN", e.NUMERIC_FAULT = "NUMERIC_FAULT", e.MISSING_NEW = "MISSING_NEW", e.INVALID_ARGUMENT = "INVALID_ARGUMENT", e.MISSING_ARGUMENT = "MISSING_ARGUMENT", e.UNEXPECTED_ARGUMENT = "UNEXPECTED_ARGUMENT", e.CALL_EXCEPTION = "CALL_EXCEPTION", e.INSUFFICIENT_FUNDS = "INSUFFICIENT_FUNDS", e.NONCE_EXPIRED = "NONCE_EXPIRED", e.REPLACEMENT_UNDERPRICED = "REPLACEMENT_UNDERPRICED", e.UNPREDICTABLE_GAS_LIMIT = "UNPREDICTABLE_GAS_LIMIT", e.TRANSACTION_REPLACED = "TRANSACTION_REPLACED", e.ACTION_REJECTED = "ACTION_REJECTED";
})(re$2 || (re$2 = {}));
const kn = "0123456789abcdef";
let L$3 = class L2 {
  constructor(t) {
    Object.defineProperty(this, "version", { enumerable: true, value: t, writable: false });
  }
  _log(t, r) {
    const i2 = t.toLowerCase();
    Cr$2[i2] == null && this.throwArgumentError("invalid log level name", "logLevel", t), !(Tn > Cr$2[i2]) && console.log.apply(console, r);
  }
  debug(...t) {
    this._log(L2.levels.DEBUG, t);
  }
  info(...t) {
    this._log(L2.levels.INFO, t);
  }
  warn(...t) {
    this._log(L2.levels.WARNING, t);
  }
  makeError(t, r, i2) {
    if (Fn)
      return this.makeError("censored error", r, {});
    r || (r = L2.errors.UNKNOWN_ERROR), i2 || (i2 = {});
    const n2 = [];
    Object.keys(i2).forEach((b3) => {
      const m3 = i2[b3];
      try {
        if (m3 instanceof Uint8Array) {
          let w3 = "";
          for (let y3 = 0; y3 < m3.length; y3++)
            w3 += kn[m3[y3] >> 4], w3 += kn[m3[y3] & 15];
          n2.push(b3 + "=Uint8Array(0x" + w3 + ")");
        } else
          n2.push(b3 + "=" + JSON.stringify(m3));
      } catch {
        n2.push(b3 + "=" + JSON.stringify(i2[b3].toString()));
      }
    }), n2.push(`code=${r}`), n2.push(`version=${this.version}`);
    const o2 = t;
    let h4 = "";
    switch (r) {
      case re$2.NUMERIC_FAULT: {
        h4 = "NUMERIC_FAULT";
        const b3 = t;
        switch (b3) {
          case "overflow":
          case "underflow":
          case "division-by-zero":
            h4 += "-" + b3;
            break;
          case "negative-power":
          case "negative-width":
            h4 += "-unsupported";
            break;
          case "unbound-bitwise-result":
            h4 += "-unbound-result";
            break;
        }
        break;
      }
      case re$2.CALL_EXCEPTION:
      case re$2.INSUFFICIENT_FUNDS:
      case re$2.MISSING_NEW:
      case re$2.NONCE_EXPIRED:
      case re$2.REPLACEMENT_UNDERPRICED:
      case re$2.TRANSACTION_REPLACED:
      case re$2.UNPREDICTABLE_GAS_LIMIT:
        h4 = r;
        break;
    }
    h4 && (t += " [ See: https://links.ethers.org/v5-errors-" + h4 + " ]"), n2.length && (t += " (" + n2.join(", ") + ")");
    const p3 = new Error(t);
    return p3.reason = o2, p3.code = r, Object.keys(i2).forEach(function(b3) {
      p3[b3] = i2[b3];
    }), p3;
  }
  throwError(t, r, i2) {
    throw this.makeError(t, r, i2);
  }
  throwArgumentError(t, r, i2) {
    return this.throwError(t, L2.errors.INVALID_ARGUMENT, { argument: r, value: i2 });
  }
  assert(t, r, i2, n2) {
    t || this.throwError(r, i2, n2);
  }
  assertArgument(t, r, i2, n2) {
    t || this.throwArgumentError(r, i2, n2);
  }
  checkNormalize(t) {
    Un && this.throwError("platform missing String.prototype.normalize", L2.errors.UNSUPPORTED_OPERATION, { operation: "String.prototype.normalize", form: Un });
  }
  checkSafeUint53(t, r) {
    typeof t == "number" && (r == null && (r = "value not safe"), (t < 0 || t >= 9007199254740991) && this.throwError(r, L2.errors.NUMERIC_FAULT, { operation: "checkSafeInteger", fault: "out-of-safe-range", value: t }), t % 1 && this.throwError(r, L2.errors.NUMERIC_FAULT, { operation: "checkSafeInteger", fault: "non-integer", value: t }));
  }
  checkArgumentCount(t, r, i2) {
    i2 ? i2 = ": " + i2 : i2 = "", t < r && this.throwError("missing argument" + i2, L2.errors.MISSING_ARGUMENT, { count: t, expectedCount: r }), t > r && this.throwError("too many arguments" + i2, L2.errors.UNEXPECTED_ARGUMENT, { count: t, expectedCount: r });
  }
  checkNew(t, r) {
    (t === Object || t == null) && this.throwError("missing new", L2.errors.MISSING_NEW, { name: r.name });
  }
  checkAbstract(t, r) {
    t === r ? this.throwError("cannot instantiate abstract class " + JSON.stringify(r.name) + " directly; use a sub-class", L2.errors.UNSUPPORTED_OPERATION, { name: t.name, operation: "new" }) : (t === Object || t == null) && this.throwError("missing new", L2.errors.MISSING_NEW, { name: r.name });
  }
  static globalLogger() {
    return gi || (gi = new L2(y0)), gi;
  }
  static setCensorship(t, r) {
    if (!t && r && this.globalLogger().throwError("cannot permanently disable censorship", L2.errors.UNSUPPORTED_OPERATION, { operation: "setCensorship" }), Dn) {
      if (!t)
        return;
      this.globalLogger().throwError("error censorship permanent", L2.errors.UNSUPPORTED_OPERATION, { operation: "setCensorship" });
    }
    Fn = !!t, Dn = !!r;
  }
  static setLogLevel(t) {
    const r = Cr$2[t.toLowerCase()];
    if (r == null) {
      L2.globalLogger().warn("invalid log level - " + t);
      return;
    }
    Tn = r;
  }
  static from(t) {
    return new L2(t);
  }
};
L$3.errors = re$2, L$3.levels = Ai;
const x0 = "bytes/5.7.0", Dt$2 = new L$3(x0);
function qn(e) {
  return !!e.toHexString;
}
function rr$2(e) {
  return e.slice || (e.slice = function() {
    const t = Array.prototype.slice.call(arguments);
    return rr$2(new Uint8Array(Array.prototype.slice.apply(e, t)));
  }), e;
}
function M0(e) {
  return Qt$1(e) && !(e.length % 2) || ir$2(e);
}
function Kn(e) {
  return typeof e == "number" && e == e && e % 1 === 0;
}
function ir$2(e) {
  if (e == null)
    return false;
  if (e.constructor === Uint8Array)
    return true;
  if (typeof e == "string" || !Kn(e.length) || e.length < 0)
    return false;
  for (let t = 0; t < e.length; t++) {
    const r = e[t];
    if (!Kn(r) || r < 0 || r >= 256)
      return false;
  }
  return true;
}
function Ot$2(e, t) {
  if (t || (t = {}), typeof e == "number") {
    Dt$2.checkSafeUint53(e, "invalid arrayify value");
    const r = [];
    for (; e; )
      r.unshift(e & 255), e = parseInt(String(e / 256));
    return r.length === 0 && r.push(0), rr$2(new Uint8Array(r));
  }
  if (t.allowMissingPrefix && typeof e == "string" && e.substring(0, 2) !== "0x" && (e = "0x" + e), qn(e) && (e = e.toHexString()), Qt$1(e)) {
    let r = e.substring(2);
    r.length % 2 && (t.hexPad === "left" ? r = "0" + r : t.hexPad === "right" ? r += "0" : Dt$2.throwArgumentError("hex data is odd-length", "value", e));
    const i2 = [];
    for (let n2 = 0; n2 < r.length; n2 += 2)
      i2.push(parseInt(r.substring(n2, n2 + 2), 16));
    return rr$2(new Uint8Array(i2));
  }
  return ir$2(e) ? rr$2(new Uint8Array(e)) : Dt$2.throwArgumentError("invalid arrayify value", "value", e);
}
function E0(e) {
  const t = e.map((n2) => Ot$2(n2)), r = t.reduce((n2, o2) => n2 + o2.length, 0), i2 = new Uint8Array(r);
  return t.reduce((n2, o2) => (i2.set(o2, n2), n2 + o2.length), 0), rr$2(i2);
}
function S0(e, t) {
  e = Ot$2(e), e.length > t && Dt$2.throwArgumentError("value out of range", "value", arguments[0]);
  const r = new Uint8Array(t);
  return r.set(e, t - e.length), rr$2(r);
}
function Qt$1(e, t) {
  return !(typeof e != "string" || !e.match(/^0x[0-9A-Fa-f]*$/) || t && e.length !== 2 + 2 * t);
}
const bi = "0123456789abcdef";
function Kt$2(e, t) {
  if (t || (t = {}), typeof e == "number") {
    Dt$2.checkSafeUint53(e, "invalid hexlify value");
    let r = "";
    for (; e; )
      r = bi[e & 15] + r, e = Math.floor(e / 16);
    return r.length ? (r.length % 2 && (r = "0" + r), "0x" + r) : "0x00";
  }
  if (typeof e == "bigint")
    return e = e.toString(16), e.length % 2 ? "0x0" + e : "0x" + e;
  if (t.allowMissingPrefix && typeof e == "string" && e.substring(0, 2) !== "0x" && (e = "0x" + e), qn(e))
    return e.toHexString();
  if (Qt$1(e))
    return e.length % 2 && (t.hexPad === "left" ? e = "0x0" + e.substring(2) : t.hexPad === "right" ? e += "0" : Dt$2.throwArgumentError("hex data is odd-length", "value", e)), e.toLowerCase();
  if (ir$2(e)) {
    let r = "0x";
    for (let i2 = 0; i2 < e.length; i2++) {
      let n2 = e[i2];
      r += bi[(n2 & 240) >> 4] + bi[n2 & 15];
    }
    return r;
  }
  return Dt$2.throwArgumentError("invalid hexlify value", "value", e);
}
function N0(e) {
  if (typeof e != "string")
    e = Kt$2(e);
  else if (!Qt$1(e) || e.length % 2)
    return null;
  return (e.length - 2) / 2;
}
function Hn(e, t, r) {
  return typeof e != "string" ? e = Kt$2(e) : (!Qt$1(e) || e.length % 2) && Dt$2.throwArgumentError("invalid hexData", "value", e), t = 2 + 2 * t, r != null ? "0x" + e.substring(t, 2 + 2 * r) : "0x" + e.substring(t);
}
function oe$1(e, t) {
  for (typeof e != "string" ? e = Kt$2(e) : Qt$1(e) || Dt$2.throwArgumentError("invalid hex string", "value", e), e.length > 2 * t + 2 && Dt$2.throwArgumentError("value out of range", "value", arguments[1]); e.length < 2 * t + 2; )
    e = "0x0" + e.substring(2);
  return e;
}
function zn(e) {
  const t = { r: "0x", s: "0x", _vs: "0x", recoveryParam: 0, v: 0, yParityAndS: "0x", compact: "0x" };
  if (M0(e)) {
    let r = Ot$2(e);
    r.length === 64 ? (t.v = 27 + (r[32] >> 7), r[32] &= 127, t.r = Kt$2(r.slice(0, 32)), t.s = Kt$2(r.slice(32, 64))) : r.length === 65 ? (t.r = Kt$2(r.slice(0, 32)), t.s = Kt$2(r.slice(32, 64)), t.v = r[64]) : Dt$2.throwArgumentError("invalid signature string", "signature", e), t.v < 27 && (t.v === 0 || t.v === 1 ? t.v += 27 : Dt$2.throwArgumentError("signature invalid v byte", "signature", e)), t.recoveryParam = 1 - t.v % 2, t.recoveryParam && (r[32] |= 128), t._vs = Kt$2(r.slice(32, 64));
  } else {
    if (t.r = e.r, t.s = e.s, t.v = e.v, t.recoveryParam = e.recoveryParam, t._vs = e._vs, t._vs != null) {
      const n2 = S0(Ot$2(t._vs), 32);
      t._vs = Kt$2(n2);
      const o2 = n2[0] >= 128 ? 1 : 0;
      t.recoveryParam == null ? t.recoveryParam = o2 : t.recoveryParam !== o2 && Dt$2.throwArgumentError("signature recoveryParam mismatch _vs", "signature", e), n2[0] &= 127;
      const h4 = Kt$2(n2);
      t.s == null ? t.s = h4 : t.s !== h4 && Dt$2.throwArgumentError("signature v mismatch _vs", "signature", e);
    }
    if (t.recoveryParam == null)
      t.v == null ? Dt$2.throwArgumentError("signature missing v and recoveryParam", "signature", e) : t.v === 0 || t.v === 1 ? t.recoveryParam = t.v : t.recoveryParam = 1 - t.v % 2;
    else if (t.v == null)
      t.v = 27 + t.recoveryParam;
    else {
      const n2 = t.v === 0 || t.v === 1 ? t.v : 1 - t.v % 2;
      t.recoveryParam !== n2 && Dt$2.throwArgumentError("signature recoveryParam mismatch v", "signature", e);
    }
    t.r == null || !Qt$1(t.r) ? Dt$2.throwArgumentError("signature missing or invalid r", "signature", e) : t.r = oe$1(t.r, 32), t.s == null || !Qt$1(t.s) ? Dt$2.throwArgumentError("signature missing or invalid s", "signature", e) : t.s = oe$1(t.s, 32);
    const r = Ot$2(t.s);
    r[0] >= 128 && Dt$2.throwArgumentError("signature s out of range", "signature", e), t.recoveryParam && (r[0] |= 128);
    const i2 = Kt$2(r);
    t._vs && (Qt$1(t._vs) || Dt$2.throwArgumentError("signature invalid _vs", "signature", e), t._vs = oe$1(t._vs, 32)), t._vs == null ? t._vs = i2 : t._vs !== i2 && Dt$2.throwArgumentError("signature _vs mismatch v and s", "signature", e);
  }
  return t.yParityAndS = t._vs, t.compact = t.r + t.yParityAndS.substring(2), t;
}
function yi(e) {
  return "0x" + b0.keccak_256(Ot$2(e));
}
var Ln = { exports: {} }, I0 = {}, _0 = Object.freeze({ __proto__: null, default: I0 }), B0 = A0(_0);
(function(e) {
  (function(t, r) {
    function i2(A2, f3) {
      if (!A2)
        throw new Error(f3 || "Assertion failed");
    }
    function n2(A2, f3) {
      A2.super_ = f3;
      var a3 = function() {
      };
      a3.prototype = f3.prototype, A2.prototype = new a3(), A2.prototype.constructor = A2;
    }
    function o2(A2, f3, a3) {
      if (o2.isBN(A2))
        return A2;
      this.negative = 0, this.words = null, this.length = 0, this.red = null, A2 !== null && ((f3 === "le" || f3 === "be") && (a3 = f3, f3 = 10), this._init(A2 || 0, f3 || 10, a3 || "be"));
    }
    typeof t == "object" ? t.exports = o2 : r.BN = o2, o2.BN = o2, o2.wordSize = 26;
    var h4;
    try {
      typeof window < "u" && typeof window.Buffer < "u" ? h4 = window.Buffer : h4 = B0.Buffer;
    } catch {
    }
    o2.isBN = function(f3) {
      return f3 instanceof o2 ? true : f3 !== null && typeof f3 == "object" && f3.constructor.wordSize === o2.wordSize && Array.isArray(f3.words);
    }, o2.max = function(f3, a3) {
      return f3.cmp(a3) > 0 ? f3 : a3;
    }, o2.min = function(f3, a3) {
      return f3.cmp(a3) < 0 ? f3 : a3;
    }, o2.prototype._init = function(f3, a3, c2) {
      if (typeof f3 == "number")
        return this._initNumber(f3, a3, c2);
      if (typeof f3 == "object")
        return this._initArray(f3, a3, c2);
      a3 === "hex" && (a3 = 16), i2(a3 === (a3 | 0) && a3 >= 2 && a3 <= 36), f3 = f3.toString().replace(/\s+/g, "");
      var d4 = 0;
      f3[0] === "-" && (d4++, this.negative = 1), d4 < f3.length && (a3 === 16 ? this._parseHex(f3, d4, c2) : (this._parseBase(f3, a3, d4), c2 === "le" && this._initArray(this.toArray(), a3, c2)));
    }, o2.prototype._initNumber = function(f3, a3, c2) {
      f3 < 0 && (this.negative = 1, f3 = -f3), f3 < 67108864 ? (this.words = [f3 & 67108863], this.length = 1) : f3 < 4503599627370496 ? (this.words = [f3 & 67108863, f3 / 67108864 & 67108863], this.length = 2) : (i2(f3 < 9007199254740992), this.words = [f3 & 67108863, f3 / 67108864 & 67108863, 1], this.length = 3), c2 === "le" && this._initArray(this.toArray(), a3, c2);
    }, o2.prototype._initArray = function(f3, a3, c2) {
      if (i2(typeof f3.length == "number"), f3.length <= 0)
        return this.words = [0], this.length = 1, this;
      this.length = Math.ceil(f3.length / 3), this.words = new Array(this.length);
      for (var d4 = 0; d4 < this.length; d4++)
        this.words[d4] = 0;
      var g3, x2, M2 = 0;
      if (c2 === "be")
        for (d4 = f3.length - 1, g3 = 0; d4 >= 0; d4 -= 3)
          x2 = f3[d4] | f3[d4 - 1] << 8 | f3[d4 - 2] << 16, this.words[g3] |= x2 << M2 & 67108863, this.words[g3 + 1] = x2 >>> 26 - M2 & 67108863, M2 += 24, M2 >= 26 && (M2 -= 26, g3++);
      else if (c2 === "le")
        for (d4 = 0, g3 = 0; d4 < f3.length; d4 += 3)
          x2 = f3[d4] | f3[d4 + 1] << 8 | f3[d4 + 2] << 16, this.words[g3] |= x2 << M2 & 67108863, this.words[g3 + 1] = x2 >>> 26 - M2 & 67108863, M2 += 24, M2 >= 26 && (M2 -= 26, g3++);
      return this._strip();
    };
    function p3(A2, f3) {
      var a3 = A2.charCodeAt(f3);
      if (a3 >= 48 && a3 <= 57)
        return a3 - 48;
      if (a3 >= 65 && a3 <= 70)
        return a3 - 55;
      if (a3 >= 97 && a3 <= 102)
        return a3 - 87;
      i2(false, "Invalid character in " + A2);
    }
    function b3(A2, f3, a3) {
      var c2 = p3(A2, a3);
      return a3 - 1 >= f3 && (c2 |= p3(A2, a3 - 1) << 4), c2;
    }
    o2.prototype._parseHex = function(f3, a3, c2) {
      this.length = Math.ceil((f3.length - a3) / 6), this.words = new Array(this.length);
      for (var d4 = 0; d4 < this.length; d4++)
        this.words[d4] = 0;
      var g3 = 0, x2 = 0, M2;
      if (c2 === "be")
        for (d4 = f3.length - 1; d4 >= a3; d4 -= 2)
          M2 = b3(f3, a3, d4) << g3, this.words[x2] |= M2 & 67108863, g3 >= 18 ? (g3 -= 18, x2 += 1, this.words[x2] |= M2 >>> 26) : g3 += 8;
      else {
        var l2 = f3.length - a3;
        for (d4 = l2 % 2 === 0 ? a3 + 1 : a3; d4 < f3.length; d4 += 2)
          M2 = b3(f3, a3, d4) << g3, this.words[x2] |= M2 & 67108863, g3 >= 18 ? (g3 -= 18, x2 += 1, this.words[x2] |= M2 >>> 26) : g3 += 8;
      }
      this._strip();
    };
    function m3(A2, f3, a3, c2) {
      for (var d4 = 0, g3 = 0, x2 = Math.min(A2.length, a3), M2 = f3; M2 < x2; M2++) {
        var l2 = A2.charCodeAt(M2) - 48;
        d4 *= c2, l2 >= 49 ? g3 = l2 - 49 + 10 : l2 >= 17 ? g3 = l2 - 17 + 10 : g3 = l2, i2(l2 >= 0 && g3 < c2, "Invalid character"), d4 += g3;
      }
      return d4;
    }
    o2.prototype._parseBase = function(f3, a3, c2) {
      this.words = [0], this.length = 1;
      for (var d4 = 0, g3 = 1; g3 <= 67108863; g3 *= a3)
        d4++;
      d4--, g3 = g3 / a3 | 0;
      for (var x2 = f3.length - c2, M2 = x2 % d4, l2 = Math.min(x2, x2 - M2) + c2, s = 0, v3 = c2; v3 < l2; v3 += d4)
        s = m3(f3, v3, v3 + d4, a3), this.imuln(g3), this.words[0] + s < 67108864 ? this.words[0] += s : this._iaddn(s);
      if (M2 !== 0) {
        var k2 = 1;
        for (s = m3(f3, v3, f3.length, a3), v3 = 0; v3 < M2; v3++)
          k2 *= a3;
        this.imuln(k2), this.words[0] + s < 67108864 ? this.words[0] += s : this._iaddn(s);
      }
      this._strip();
    }, o2.prototype.copy = function(f3) {
      f3.words = new Array(this.length);
      for (var a3 = 0; a3 < this.length; a3++)
        f3.words[a3] = this.words[a3];
      f3.length = this.length, f3.negative = this.negative, f3.red = this.red;
    };
    function w3(A2, f3) {
      A2.words = f3.words, A2.length = f3.length, A2.negative = f3.negative, A2.red = f3.red;
    }
    if (o2.prototype._move = function(f3) {
      w3(f3, this);
    }, o2.prototype.clone = function() {
      var f3 = new o2(null);
      return this.copy(f3), f3;
    }, o2.prototype._expand = function(f3) {
      for (; this.length < f3; )
        this.words[this.length++] = 0;
      return this;
    }, o2.prototype._strip = function() {
      for (; this.length > 1 && this.words[this.length - 1] === 0; )
        this.length--;
      return this._normSign();
    }, o2.prototype._normSign = function() {
      return this.length === 1 && this.words[0] === 0 && (this.negative = 0), this;
    }, typeof Symbol < "u" && typeof Symbol.for == "function")
      try {
        o2.prototype[Symbol.for("nodejs.util.inspect.custom")] = y3;
      } catch {
        o2.prototype.inspect = y3;
      }
    else
      o2.prototype.inspect = y3;
    function y3() {
      return (this.red ? "<BN-R: " : "<BN: ") + this.toString(16) + ">";
    }
    var S3 = ["", "0", "00", "000", "0000", "00000", "000000", "0000000", "00000000", "000000000", "0000000000", "00000000000", "000000000000", "0000000000000", "00000000000000", "000000000000000", "0000000000000000", "00000000000000000", "000000000000000000", "0000000000000000000", "00000000000000000000", "000000000000000000000", "0000000000000000000000", "00000000000000000000000", "000000000000000000000000", "0000000000000000000000000"], I2 = [0, 0, 25, 16, 12, 11, 10, 9, 8, 8, 7, 7, 7, 7, 6, 6, 6, 6, 6, 6, 6, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5], N2 = [0, 0, 33554432, 43046721, 16777216, 48828125, 60466176, 40353607, 16777216, 43046721, 1e7, 19487171, 35831808, 62748517, 7529536, 11390625, 16777216, 24137569, 34012224, 47045881, 64e6, 4084101, 5153632, 6436343, 7962624, 9765625, 11881376, 14348907, 17210368, 20511149, 243e5, 28629151, 33554432, 39135393, 45435424, 52521875, 60466176];
    o2.prototype.toString = function(f3, a3) {
      f3 = f3 || 10, a3 = a3 | 0 || 1;
      var c2;
      if (f3 === 16 || f3 === "hex") {
        c2 = "";
        for (var d4 = 0, g3 = 0, x2 = 0; x2 < this.length; x2++) {
          var M2 = this.words[x2], l2 = ((M2 << d4 | g3) & 16777215).toString(16);
          g3 = M2 >>> 24 - d4 & 16777215, d4 += 2, d4 >= 26 && (d4 -= 26, x2--), g3 !== 0 || x2 !== this.length - 1 ? c2 = S3[6 - l2.length] + l2 + c2 : c2 = l2 + c2;
        }
        for (g3 !== 0 && (c2 = g3.toString(16) + c2); c2.length % a3 !== 0; )
          c2 = "0" + c2;
        return this.negative !== 0 && (c2 = "-" + c2), c2;
      }
      if (f3 === (f3 | 0) && f3 >= 2 && f3 <= 36) {
        var s = I2[f3], v3 = N2[f3];
        c2 = "";
        var k2 = this.clone();
        for (k2.negative = 0; !k2.isZero(); ) {
          var u2 = k2.modrn(v3).toString(f3);
          k2 = k2.idivn(v3), k2.isZero() ? c2 = u2 + c2 : c2 = S3[s - u2.length] + u2 + c2;
        }
        for (this.isZero() && (c2 = "0" + c2); c2.length % a3 !== 0; )
          c2 = "0" + c2;
        return this.negative !== 0 && (c2 = "-" + c2), c2;
      }
      i2(false, "Base should be between 2 and 36");
    }, o2.prototype.toNumber = function() {
      var f3 = this.words[0];
      return this.length === 2 ? f3 += this.words[1] * 67108864 : this.length === 3 && this.words[2] === 1 ? f3 += 4503599627370496 + this.words[1] * 67108864 : this.length > 2 && i2(false, "Number can only safely store up to 53 bits"), this.negative !== 0 ? -f3 : f3;
    }, o2.prototype.toJSON = function() {
      return this.toString(16, 2);
    }, h4 && (o2.prototype.toBuffer = function(f3, a3) {
      return this.toArrayLike(h4, f3, a3);
    }), o2.prototype.toArray = function(f3, a3) {
      return this.toArrayLike(Array, f3, a3);
    };
    var C2 = function(f3, a3) {
      return f3.allocUnsafe ? f3.allocUnsafe(a3) : new f3(a3);
    };
    o2.prototype.toArrayLike = function(f3, a3, c2) {
      this._strip();
      var d4 = this.byteLength(), g3 = c2 || Math.max(1, d4);
      i2(d4 <= g3, "byte array longer than desired length"), i2(g3 > 0, "Requested array length <= 0");
      var x2 = C2(f3, g3), M2 = a3 === "le" ? "LE" : "BE";
      return this["_toArrayLike" + M2](x2, d4), x2;
    }, o2.prototype._toArrayLikeLE = function(f3, a3) {
      for (var c2 = 0, d4 = 0, g3 = 0, x2 = 0; g3 < this.length; g3++) {
        var M2 = this.words[g3] << x2 | d4;
        f3[c2++] = M2 & 255, c2 < f3.length && (f3[c2++] = M2 >> 8 & 255), c2 < f3.length && (f3[c2++] = M2 >> 16 & 255), x2 === 6 ? (c2 < f3.length && (f3[c2++] = M2 >> 24 & 255), d4 = 0, x2 = 0) : (d4 = M2 >>> 24, x2 += 2);
      }
      if (c2 < f3.length)
        for (f3[c2++] = d4; c2 < f3.length; )
          f3[c2++] = 0;
    }, o2.prototype._toArrayLikeBE = function(f3, a3) {
      for (var c2 = f3.length - 1, d4 = 0, g3 = 0, x2 = 0; g3 < this.length; g3++) {
        var M2 = this.words[g3] << x2 | d4;
        f3[c2--] = M2 & 255, c2 >= 0 && (f3[c2--] = M2 >> 8 & 255), c2 >= 0 && (f3[c2--] = M2 >> 16 & 255), x2 === 6 ? (c2 >= 0 && (f3[c2--] = M2 >> 24 & 255), d4 = 0, x2 = 0) : (d4 = M2 >>> 24, x2 += 2);
      }
      if (c2 >= 0)
        for (f3[c2--] = d4; c2 >= 0; )
          f3[c2--] = 0;
    }, Math.clz32 ? o2.prototype._countBits = function(f3) {
      return 32 - Math.clz32(f3);
    } : o2.prototype._countBits = function(f3) {
      var a3 = f3, c2 = 0;
      return a3 >= 4096 && (c2 += 13, a3 >>>= 13), a3 >= 64 && (c2 += 7, a3 >>>= 7), a3 >= 8 && (c2 += 4, a3 >>>= 4), a3 >= 2 && (c2 += 2, a3 >>>= 2), c2 + a3;
    }, o2.prototype._zeroBits = function(f3) {
      if (f3 === 0)
        return 26;
      var a3 = f3, c2 = 0;
      return a3 & 8191 || (c2 += 13, a3 >>>= 13), a3 & 127 || (c2 += 7, a3 >>>= 7), a3 & 15 || (c2 += 4, a3 >>>= 4), a3 & 3 || (c2 += 2, a3 >>>= 2), a3 & 1 || c2++, c2;
    }, o2.prototype.bitLength = function() {
      var f3 = this.words[this.length - 1], a3 = this._countBits(f3);
      return (this.length - 1) * 26 + a3;
    };
    function F2(A2) {
      for (var f3 = new Array(A2.bitLength()), a3 = 0; a3 < f3.length; a3++) {
        var c2 = a3 / 26 | 0, d4 = a3 % 26;
        f3[a3] = A2.words[c2] >>> d4 & 1;
      }
      return f3;
    }
    o2.prototype.zeroBits = function() {
      if (this.isZero())
        return 0;
      for (var f3 = 0, a3 = 0; a3 < this.length; a3++) {
        var c2 = this._zeroBits(this.words[a3]);
        if (f3 += c2, c2 !== 26)
          break;
      }
      return f3;
    }, o2.prototype.byteLength = function() {
      return Math.ceil(this.bitLength() / 8);
    }, o2.prototype.toTwos = function(f3) {
      return this.negative !== 0 ? this.abs().inotn(f3).iaddn(1) : this.clone();
    }, o2.prototype.fromTwos = function(f3) {
      return this.testn(f3 - 1) ? this.notn(f3).iaddn(1).ineg() : this.clone();
    }, o2.prototype.isNeg = function() {
      return this.negative !== 0;
    }, o2.prototype.neg = function() {
      return this.clone().ineg();
    }, o2.prototype.ineg = function() {
      return this.isZero() || (this.negative ^= 1), this;
    }, o2.prototype.iuor = function(f3) {
      for (; this.length < f3.length; )
        this.words[this.length++] = 0;
      for (var a3 = 0; a3 < f3.length; a3++)
        this.words[a3] = this.words[a3] | f3.words[a3];
      return this._strip();
    }, o2.prototype.ior = function(f3) {
      return i2((this.negative | f3.negative) === 0), this.iuor(f3);
    }, o2.prototype.or = function(f3) {
      return this.length > f3.length ? this.clone().ior(f3) : f3.clone().ior(this);
    }, o2.prototype.uor = function(f3) {
      return this.length > f3.length ? this.clone().iuor(f3) : f3.clone().iuor(this);
    }, o2.prototype.iuand = function(f3) {
      var a3;
      this.length > f3.length ? a3 = f3 : a3 = this;
      for (var c2 = 0; c2 < a3.length; c2++)
        this.words[c2] = this.words[c2] & f3.words[c2];
      return this.length = a3.length, this._strip();
    }, o2.prototype.iand = function(f3) {
      return i2((this.negative | f3.negative) === 0), this.iuand(f3);
    }, o2.prototype.and = function(f3) {
      return this.length > f3.length ? this.clone().iand(f3) : f3.clone().iand(this);
    }, o2.prototype.uand = function(f3) {
      return this.length > f3.length ? this.clone().iuand(f3) : f3.clone().iuand(this);
    }, o2.prototype.iuxor = function(f3) {
      var a3, c2;
      this.length > f3.length ? (a3 = this, c2 = f3) : (a3 = f3, c2 = this);
      for (var d4 = 0; d4 < c2.length; d4++)
        this.words[d4] = a3.words[d4] ^ c2.words[d4];
      if (this !== a3)
        for (; d4 < a3.length; d4++)
          this.words[d4] = a3.words[d4];
      return this.length = a3.length, this._strip();
    }, o2.prototype.ixor = function(f3) {
      return i2((this.negative | f3.negative) === 0), this.iuxor(f3);
    }, o2.prototype.xor = function(f3) {
      return this.length > f3.length ? this.clone().ixor(f3) : f3.clone().ixor(this);
    }, o2.prototype.uxor = function(f3) {
      return this.length > f3.length ? this.clone().iuxor(f3) : f3.clone().iuxor(this);
    }, o2.prototype.inotn = function(f3) {
      i2(typeof f3 == "number" && f3 >= 0);
      var a3 = Math.ceil(f3 / 26) | 0, c2 = f3 % 26;
      this._expand(a3), c2 > 0 && a3--;
      for (var d4 = 0; d4 < a3; d4++)
        this.words[d4] = ~this.words[d4] & 67108863;
      return c2 > 0 && (this.words[d4] = ~this.words[d4] & 67108863 >> 26 - c2), this._strip();
    }, o2.prototype.notn = function(f3) {
      return this.clone().inotn(f3);
    }, o2.prototype.setn = function(f3, a3) {
      i2(typeof f3 == "number" && f3 >= 0);
      var c2 = f3 / 26 | 0, d4 = f3 % 26;
      return this._expand(c2 + 1), a3 ? this.words[c2] = this.words[c2] | 1 << d4 : this.words[c2] = this.words[c2] & ~(1 << d4), this._strip();
    }, o2.prototype.iadd = function(f3) {
      var a3;
      if (this.negative !== 0 && f3.negative === 0)
        return this.negative = 0, a3 = this.isub(f3), this.negative ^= 1, this._normSign();
      if (this.negative === 0 && f3.negative !== 0)
        return f3.negative = 0, a3 = this.isub(f3), f3.negative = 1, a3._normSign();
      var c2, d4;
      this.length > f3.length ? (c2 = this, d4 = f3) : (c2 = f3, d4 = this);
      for (var g3 = 0, x2 = 0; x2 < d4.length; x2++)
        a3 = (c2.words[x2] | 0) + (d4.words[x2] | 0) + g3, this.words[x2] = a3 & 67108863, g3 = a3 >>> 26;
      for (; g3 !== 0 && x2 < c2.length; x2++)
        a3 = (c2.words[x2] | 0) + g3, this.words[x2] = a3 & 67108863, g3 = a3 >>> 26;
      if (this.length = c2.length, g3 !== 0)
        this.words[this.length] = g3, this.length++;
      else if (c2 !== this)
        for (; x2 < c2.length; x2++)
          this.words[x2] = c2.words[x2];
      return this;
    }, o2.prototype.add = function(f3) {
      var a3;
      return f3.negative !== 0 && this.negative === 0 ? (f3.negative = 0, a3 = this.sub(f3), f3.negative ^= 1, a3) : f3.negative === 0 && this.negative !== 0 ? (this.negative = 0, a3 = f3.sub(this), this.negative = 1, a3) : this.length > f3.length ? this.clone().iadd(f3) : f3.clone().iadd(this);
    }, o2.prototype.isub = function(f3) {
      if (f3.negative !== 0) {
        f3.negative = 0;
        var a3 = this.iadd(f3);
        return f3.negative = 1, a3._normSign();
      } else if (this.negative !== 0)
        return this.negative = 0, this.iadd(f3), this.negative = 1, this._normSign();
      var c2 = this.cmp(f3);
      if (c2 === 0)
        return this.negative = 0, this.length = 1, this.words[0] = 0, this;
      var d4, g3;
      c2 > 0 ? (d4 = this, g3 = f3) : (d4 = f3, g3 = this);
      for (var x2 = 0, M2 = 0; M2 < g3.length; M2++)
        a3 = (d4.words[M2] | 0) - (g3.words[M2] | 0) + x2, x2 = a3 >> 26, this.words[M2] = a3 & 67108863;
      for (; x2 !== 0 && M2 < d4.length; M2++)
        a3 = (d4.words[M2] | 0) + x2, x2 = a3 >> 26, this.words[M2] = a3 & 67108863;
      if (x2 === 0 && M2 < d4.length && d4 !== this)
        for (; M2 < d4.length; M2++)
          this.words[M2] = d4.words[M2];
      return this.length = Math.max(this.length, M2), d4 !== this && (this.negative = 1), this._strip();
    }, o2.prototype.sub = function(f3) {
      return this.clone().isub(f3);
    };
    function U2(A2, f3, a3) {
      a3.negative = f3.negative ^ A2.negative;
      var c2 = A2.length + f3.length | 0;
      a3.length = c2, c2 = c2 - 1 | 0;
      var d4 = A2.words[0] | 0, g3 = f3.words[0] | 0, x2 = d4 * g3, M2 = x2 & 67108863, l2 = x2 / 67108864 | 0;
      a3.words[0] = M2;
      for (var s = 1; s < c2; s++) {
        for (var v3 = l2 >>> 26, k2 = l2 & 67108863, u2 = Math.min(s, f3.length - 1), E3 = Math.max(0, s - A2.length + 1); E3 <= u2; E3++) {
          var _3 = s - E3 | 0;
          d4 = A2.words[_3] | 0, g3 = f3.words[E3] | 0, x2 = d4 * g3 + k2, v3 += x2 / 67108864 | 0, k2 = x2 & 67108863;
        }
        a3.words[s] = k2 | 0, l2 = v3 | 0;
      }
      return l2 !== 0 ? a3.words[s] = l2 | 0 : a3.length--, a3._strip();
    }
    var J2 = function(f3, a3, c2) {
      var d4 = f3.words, g3 = a3.words, x2 = c2.words, M2 = 0, l2, s, v3, k2 = d4[0] | 0, u2 = k2 & 8191, E3 = k2 >>> 13, _3 = d4[1] | 0, B3 = _3 & 8191, R2 = _3 >>> 13, T2 = d4[2] | 0, P2 = T2 & 8191, O3 = T2 >>> 13, Ct2 = d4[3] | 0, D2 = Ct2 & 8191, q2 = Ct2 >>> 13, De2 = d4[4] | 0, X2 = De2 & 8191, Z2 = De2 >>> 13, Fe2 = d4[5] | 0, $2 = Fe2 & 8191, tt2 = Fe2 >>> 13, Te = d4[6] | 0, et2 = Te & 8191, rt2 = Te >>> 13, Ue2 = d4[7] | 0, it2 = Ue2 & 8191, nt2 = Ue2 >>> 13, ke2 = d4[8] | 0, ft2 = ke2 & 8191, ot2 = ke2 >>> 13, qe2 = d4[9] | 0, st2 = qe2 & 8191, at2 = qe2 >>> 13, Ke2 = g3[0] | 0, ut2 = Ke2 & 8191, ht2 = Ke2 >>> 13, He2 = g3[1] | 0, ct2 = He2 & 8191, lt2 = He2 >>> 13, ze2 = g3[2] | 0, dt2 = ze2 & 8191, pt2 = ze2 >>> 13, Le = g3[3] | 0, vt2 = Le & 8191, mt2 = Le >>> 13, je2 = g3[4] | 0, gt2 = je2 & 8191, At3 = je2 >>> 13, Qe2 = g3[5] | 0, bt2 = Qe2 & 8191, yt2 = Qe2 >>> 13, Je2 = g3[6] | 0, wt2 = Je2 & 8191, xt2 = Je2 >>> 13, Ge2 = g3[7] | 0, Mt2 = Ge2 & 8191, Et2 = Ge2 >>> 13, Ye2 = g3[8] | 0, St2 = Ye2 & 8191, Nt2 = Ye2 >>> 13, Ve2 = g3[9] | 0, It2 = Ve2 & 8191, _t2 = Ve2 >>> 13;
      c2.negative = f3.negative ^ a3.negative, c2.length = 19, l2 = Math.imul(u2, ut2), s = Math.imul(u2, ht2), s = s + Math.imul(E3, ut2) | 0, v3 = Math.imul(E3, ht2);
      var Me2 = (M2 + l2 | 0) + ((s & 8191) << 13) | 0;
      M2 = (v3 + (s >>> 13) | 0) + (Me2 >>> 26) | 0, Me2 &= 67108863, l2 = Math.imul(B3, ut2), s = Math.imul(B3, ht2), s = s + Math.imul(R2, ut2) | 0, v3 = Math.imul(R2, ht2), l2 = l2 + Math.imul(u2, ct2) | 0, s = s + Math.imul(u2, lt2) | 0, s = s + Math.imul(E3, ct2) | 0, v3 = v3 + Math.imul(E3, lt2) | 0;
      var Ee2 = (M2 + l2 | 0) + ((s & 8191) << 13) | 0;
      M2 = (v3 + (s >>> 13) | 0) + (Ee2 >>> 26) | 0, Ee2 &= 67108863, l2 = Math.imul(P2, ut2), s = Math.imul(P2, ht2), s = s + Math.imul(O3, ut2) | 0, v3 = Math.imul(O3, ht2), l2 = l2 + Math.imul(B3, ct2) | 0, s = s + Math.imul(B3, lt2) | 0, s = s + Math.imul(R2, ct2) | 0, v3 = v3 + Math.imul(R2, lt2) | 0, l2 = l2 + Math.imul(u2, dt2) | 0, s = s + Math.imul(u2, pt2) | 0, s = s + Math.imul(E3, dt2) | 0, v3 = v3 + Math.imul(E3, pt2) | 0;
      var Se2 = (M2 + l2 | 0) + ((s & 8191) << 13) | 0;
      M2 = (v3 + (s >>> 13) | 0) + (Se2 >>> 26) | 0, Se2 &= 67108863, l2 = Math.imul(D2, ut2), s = Math.imul(D2, ht2), s = s + Math.imul(q2, ut2) | 0, v3 = Math.imul(q2, ht2), l2 = l2 + Math.imul(P2, ct2) | 0, s = s + Math.imul(P2, lt2) | 0, s = s + Math.imul(O3, ct2) | 0, v3 = v3 + Math.imul(O3, lt2) | 0, l2 = l2 + Math.imul(B3, dt2) | 0, s = s + Math.imul(B3, pt2) | 0, s = s + Math.imul(R2, dt2) | 0, v3 = v3 + Math.imul(R2, pt2) | 0, l2 = l2 + Math.imul(u2, vt2) | 0, s = s + Math.imul(u2, mt2) | 0, s = s + Math.imul(E3, vt2) | 0, v3 = v3 + Math.imul(E3, mt2) | 0;
      var Ne = (M2 + l2 | 0) + ((s & 8191) << 13) | 0;
      M2 = (v3 + (s >>> 13) | 0) + (Ne >>> 26) | 0, Ne &= 67108863, l2 = Math.imul(X2, ut2), s = Math.imul(X2, ht2), s = s + Math.imul(Z2, ut2) | 0, v3 = Math.imul(Z2, ht2), l2 = l2 + Math.imul(D2, ct2) | 0, s = s + Math.imul(D2, lt2) | 0, s = s + Math.imul(q2, ct2) | 0, v3 = v3 + Math.imul(q2, lt2) | 0, l2 = l2 + Math.imul(P2, dt2) | 0, s = s + Math.imul(P2, pt2) | 0, s = s + Math.imul(O3, dt2) | 0, v3 = v3 + Math.imul(O3, pt2) | 0, l2 = l2 + Math.imul(B3, vt2) | 0, s = s + Math.imul(B3, mt2) | 0, s = s + Math.imul(R2, vt2) | 0, v3 = v3 + Math.imul(R2, mt2) | 0, l2 = l2 + Math.imul(u2, gt2) | 0, s = s + Math.imul(u2, At3) | 0, s = s + Math.imul(E3, gt2) | 0, v3 = v3 + Math.imul(E3, At3) | 0;
      var Ie = (M2 + l2 | 0) + ((s & 8191) << 13) | 0;
      M2 = (v3 + (s >>> 13) | 0) + (Ie >>> 26) | 0, Ie &= 67108863, l2 = Math.imul($2, ut2), s = Math.imul($2, ht2), s = s + Math.imul(tt2, ut2) | 0, v3 = Math.imul(tt2, ht2), l2 = l2 + Math.imul(X2, ct2) | 0, s = s + Math.imul(X2, lt2) | 0, s = s + Math.imul(Z2, ct2) | 0, v3 = v3 + Math.imul(Z2, lt2) | 0, l2 = l2 + Math.imul(D2, dt2) | 0, s = s + Math.imul(D2, pt2) | 0, s = s + Math.imul(q2, dt2) | 0, v3 = v3 + Math.imul(q2, pt2) | 0, l2 = l2 + Math.imul(P2, vt2) | 0, s = s + Math.imul(P2, mt2) | 0, s = s + Math.imul(O3, vt2) | 0, v3 = v3 + Math.imul(O3, mt2) | 0, l2 = l2 + Math.imul(B3, gt2) | 0, s = s + Math.imul(B3, At3) | 0, s = s + Math.imul(R2, gt2) | 0, v3 = v3 + Math.imul(R2, At3) | 0, l2 = l2 + Math.imul(u2, bt2) | 0, s = s + Math.imul(u2, yt2) | 0, s = s + Math.imul(E3, bt2) | 0, v3 = v3 + Math.imul(E3, yt2) | 0;
      var Wr = (M2 + l2 | 0) + ((s & 8191) << 13) | 0;
      M2 = (v3 + (s >>> 13) | 0) + (Wr >>> 26) | 0, Wr &= 67108863, l2 = Math.imul(et2, ut2), s = Math.imul(et2, ht2), s = s + Math.imul(rt2, ut2) | 0, v3 = Math.imul(rt2, ht2), l2 = l2 + Math.imul($2, ct2) | 0, s = s + Math.imul($2, lt2) | 0, s = s + Math.imul(tt2, ct2) | 0, v3 = v3 + Math.imul(tt2, lt2) | 0, l2 = l2 + Math.imul(X2, dt2) | 0, s = s + Math.imul(X2, pt2) | 0, s = s + Math.imul(Z2, dt2) | 0, v3 = v3 + Math.imul(Z2, pt2) | 0, l2 = l2 + Math.imul(D2, vt2) | 0, s = s + Math.imul(D2, mt2) | 0, s = s + Math.imul(q2, vt2) | 0, v3 = v3 + Math.imul(q2, mt2) | 0, l2 = l2 + Math.imul(P2, gt2) | 0, s = s + Math.imul(P2, At3) | 0, s = s + Math.imul(O3, gt2) | 0, v3 = v3 + Math.imul(O3, At3) | 0, l2 = l2 + Math.imul(B3, bt2) | 0, s = s + Math.imul(B3, yt2) | 0, s = s + Math.imul(R2, bt2) | 0, v3 = v3 + Math.imul(R2, yt2) | 0, l2 = l2 + Math.imul(u2, wt2) | 0, s = s + Math.imul(u2, xt2) | 0, s = s + Math.imul(E3, wt2) | 0, v3 = v3 + Math.imul(E3, xt2) | 0;
      var Xr = (M2 + l2 | 0) + ((s & 8191) << 13) | 0;
      M2 = (v3 + (s >>> 13) | 0) + (Xr >>> 26) | 0, Xr &= 67108863, l2 = Math.imul(it2, ut2), s = Math.imul(it2, ht2), s = s + Math.imul(nt2, ut2) | 0, v3 = Math.imul(nt2, ht2), l2 = l2 + Math.imul(et2, ct2) | 0, s = s + Math.imul(et2, lt2) | 0, s = s + Math.imul(rt2, ct2) | 0, v3 = v3 + Math.imul(rt2, lt2) | 0, l2 = l2 + Math.imul($2, dt2) | 0, s = s + Math.imul($2, pt2) | 0, s = s + Math.imul(tt2, dt2) | 0, v3 = v3 + Math.imul(tt2, pt2) | 0, l2 = l2 + Math.imul(X2, vt2) | 0, s = s + Math.imul(X2, mt2) | 0, s = s + Math.imul(Z2, vt2) | 0, v3 = v3 + Math.imul(Z2, mt2) | 0, l2 = l2 + Math.imul(D2, gt2) | 0, s = s + Math.imul(D2, At3) | 0, s = s + Math.imul(q2, gt2) | 0, v3 = v3 + Math.imul(q2, At3) | 0, l2 = l2 + Math.imul(P2, bt2) | 0, s = s + Math.imul(P2, yt2) | 0, s = s + Math.imul(O3, bt2) | 0, v3 = v3 + Math.imul(O3, yt2) | 0, l2 = l2 + Math.imul(B3, wt2) | 0, s = s + Math.imul(B3, xt2) | 0, s = s + Math.imul(R2, wt2) | 0, v3 = v3 + Math.imul(R2, xt2) | 0, l2 = l2 + Math.imul(u2, Mt2) | 0, s = s + Math.imul(u2, Et2) | 0, s = s + Math.imul(E3, Mt2) | 0, v3 = v3 + Math.imul(E3, Et2) | 0;
      var Zr = (M2 + l2 | 0) + ((s & 8191) << 13) | 0;
      M2 = (v3 + (s >>> 13) | 0) + (Zr >>> 26) | 0, Zr &= 67108863, l2 = Math.imul(ft2, ut2), s = Math.imul(ft2, ht2), s = s + Math.imul(ot2, ut2) | 0, v3 = Math.imul(ot2, ht2), l2 = l2 + Math.imul(it2, ct2) | 0, s = s + Math.imul(it2, lt2) | 0, s = s + Math.imul(nt2, ct2) | 0, v3 = v3 + Math.imul(nt2, lt2) | 0, l2 = l2 + Math.imul(et2, dt2) | 0, s = s + Math.imul(et2, pt2) | 0, s = s + Math.imul(rt2, dt2) | 0, v3 = v3 + Math.imul(rt2, pt2) | 0, l2 = l2 + Math.imul($2, vt2) | 0, s = s + Math.imul($2, mt2) | 0, s = s + Math.imul(tt2, vt2) | 0, v3 = v3 + Math.imul(tt2, mt2) | 0, l2 = l2 + Math.imul(X2, gt2) | 0, s = s + Math.imul(X2, At3) | 0, s = s + Math.imul(Z2, gt2) | 0, v3 = v3 + Math.imul(Z2, At3) | 0, l2 = l2 + Math.imul(D2, bt2) | 0, s = s + Math.imul(D2, yt2) | 0, s = s + Math.imul(q2, bt2) | 0, v3 = v3 + Math.imul(q2, yt2) | 0, l2 = l2 + Math.imul(P2, wt2) | 0, s = s + Math.imul(P2, xt2) | 0, s = s + Math.imul(O3, wt2) | 0, v3 = v3 + Math.imul(O3, xt2) | 0, l2 = l2 + Math.imul(B3, Mt2) | 0, s = s + Math.imul(B3, Et2) | 0, s = s + Math.imul(R2, Mt2) | 0, v3 = v3 + Math.imul(R2, Et2) | 0, l2 = l2 + Math.imul(u2, St2) | 0, s = s + Math.imul(u2, Nt2) | 0, s = s + Math.imul(E3, St2) | 0, v3 = v3 + Math.imul(E3, Nt2) | 0;
      var $r2 = (M2 + l2 | 0) + ((s & 8191) << 13) | 0;
      M2 = (v3 + (s >>> 13) | 0) + ($r2 >>> 26) | 0, $r2 &= 67108863, l2 = Math.imul(st2, ut2), s = Math.imul(st2, ht2), s = s + Math.imul(at2, ut2) | 0, v3 = Math.imul(at2, ht2), l2 = l2 + Math.imul(ft2, ct2) | 0, s = s + Math.imul(ft2, lt2) | 0, s = s + Math.imul(ot2, ct2) | 0, v3 = v3 + Math.imul(ot2, lt2) | 0, l2 = l2 + Math.imul(it2, dt2) | 0, s = s + Math.imul(it2, pt2) | 0, s = s + Math.imul(nt2, dt2) | 0, v3 = v3 + Math.imul(nt2, pt2) | 0, l2 = l2 + Math.imul(et2, vt2) | 0, s = s + Math.imul(et2, mt2) | 0, s = s + Math.imul(rt2, vt2) | 0, v3 = v3 + Math.imul(rt2, mt2) | 0, l2 = l2 + Math.imul($2, gt2) | 0, s = s + Math.imul($2, At3) | 0, s = s + Math.imul(tt2, gt2) | 0, v3 = v3 + Math.imul(tt2, At3) | 0, l2 = l2 + Math.imul(X2, bt2) | 0, s = s + Math.imul(X2, yt2) | 0, s = s + Math.imul(Z2, bt2) | 0, v3 = v3 + Math.imul(Z2, yt2) | 0, l2 = l2 + Math.imul(D2, wt2) | 0, s = s + Math.imul(D2, xt2) | 0, s = s + Math.imul(q2, wt2) | 0, v3 = v3 + Math.imul(q2, xt2) | 0, l2 = l2 + Math.imul(P2, Mt2) | 0, s = s + Math.imul(P2, Et2) | 0, s = s + Math.imul(O3, Mt2) | 0, v3 = v3 + Math.imul(O3, Et2) | 0, l2 = l2 + Math.imul(B3, St2) | 0, s = s + Math.imul(B3, Nt2) | 0, s = s + Math.imul(R2, St2) | 0, v3 = v3 + Math.imul(R2, Nt2) | 0, l2 = l2 + Math.imul(u2, It2) | 0, s = s + Math.imul(u2, _t2) | 0, s = s + Math.imul(E3, It2) | 0, v3 = v3 + Math.imul(E3, _t2) | 0;
      var ti = (M2 + l2 | 0) + ((s & 8191) << 13) | 0;
      M2 = (v3 + (s >>> 13) | 0) + (ti >>> 26) | 0, ti &= 67108863, l2 = Math.imul(st2, ct2), s = Math.imul(st2, lt2), s = s + Math.imul(at2, ct2) | 0, v3 = Math.imul(at2, lt2), l2 = l2 + Math.imul(ft2, dt2) | 0, s = s + Math.imul(ft2, pt2) | 0, s = s + Math.imul(ot2, dt2) | 0, v3 = v3 + Math.imul(ot2, pt2) | 0, l2 = l2 + Math.imul(it2, vt2) | 0, s = s + Math.imul(it2, mt2) | 0, s = s + Math.imul(nt2, vt2) | 0, v3 = v3 + Math.imul(nt2, mt2) | 0, l2 = l2 + Math.imul(et2, gt2) | 0, s = s + Math.imul(et2, At3) | 0, s = s + Math.imul(rt2, gt2) | 0, v3 = v3 + Math.imul(rt2, At3) | 0, l2 = l2 + Math.imul($2, bt2) | 0, s = s + Math.imul($2, yt2) | 0, s = s + Math.imul(tt2, bt2) | 0, v3 = v3 + Math.imul(tt2, yt2) | 0, l2 = l2 + Math.imul(X2, wt2) | 0, s = s + Math.imul(X2, xt2) | 0, s = s + Math.imul(Z2, wt2) | 0, v3 = v3 + Math.imul(Z2, xt2) | 0, l2 = l2 + Math.imul(D2, Mt2) | 0, s = s + Math.imul(D2, Et2) | 0, s = s + Math.imul(q2, Mt2) | 0, v3 = v3 + Math.imul(q2, Et2) | 0, l2 = l2 + Math.imul(P2, St2) | 0, s = s + Math.imul(P2, Nt2) | 0, s = s + Math.imul(O3, St2) | 0, v3 = v3 + Math.imul(O3, Nt2) | 0, l2 = l2 + Math.imul(B3, It2) | 0, s = s + Math.imul(B3, _t2) | 0, s = s + Math.imul(R2, It2) | 0, v3 = v3 + Math.imul(R2, _t2) | 0;
      var ei = (M2 + l2 | 0) + ((s & 8191) << 13) | 0;
      M2 = (v3 + (s >>> 13) | 0) + (ei >>> 26) | 0, ei &= 67108863, l2 = Math.imul(st2, dt2), s = Math.imul(st2, pt2), s = s + Math.imul(at2, dt2) | 0, v3 = Math.imul(at2, pt2), l2 = l2 + Math.imul(ft2, vt2) | 0, s = s + Math.imul(ft2, mt2) | 0, s = s + Math.imul(ot2, vt2) | 0, v3 = v3 + Math.imul(ot2, mt2) | 0, l2 = l2 + Math.imul(it2, gt2) | 0, s = s + Math.imul(it2, At3) | 0, s = s + Math.imul(nt2, gt2) | 0, v3 = v3 + Math.imul(nt2, At3) | 0, l2 = l2 + Math.imul(et2, bt2) | 0, s = s + Math.imul(et2, yt2) | 0, s = s + Math.imul(rt2, bt2) | 0, v3 = v3 + Math.imul(rt2, yt2) | 0, l2 = l2 + Math.imul($2, wt2) | 0, s = s + Math.imul($2, xt2) | 0, s = s + Math.imul(tt2, wt2) | 0, v3 = v3 + Math.imul(tt2, xt2) | 0, l2 = l2 + Math.imul(X2, Mt2) | 0, s = s + Math.imul(X2, Et2) | 0, s = s + Math.imul(Z2, Mt2) | 0, v3 = v3 + Math.imul(Z2, Et2) | 0, l2 = l2 + Math.imul(D2, St2) | 0, s = s + Math.imul(D2, Nt2) | 0, s = s + Math.imul(q2, St2) | 0, v3 = v3 + Math.imul(q2, Nt2) | 0, l2 = l2 + Math.imul(P2, It2) | 0, s = s + Math.imul(P2, _t2) | 0, s = s + Math.imul(O3, It2) | 0, v3 = v3 + Math.imul(O3, _t2) | 0;
      var ri = (M2 + l2 | 0) + ((s & 8191) << 13) | 0;
      M2 = (v3 + (s >>> 13) | 0) + (ri >>> 26) | 0, ri &= 67108863, l2 = Math.imul(st2, vt2), s = Math.imul(st2, mt2), s = s + Math.imul(at2, vt2) | 0, v3 = Math.imul(at2, mt2), l2 = l2 + Math.imul(ft2, gt2) | 0, s = s + Math.imul(ft2, At3) | 0, s = s + Math.imul(ot2, gt2) | 0, v3 = v3 + Math.imul(ot2, At3) | 0, l2 = l2 + Math.imul(it2, bt2) | 0, s = s + Math.imul(it2, yt2) | 0, s = s + Math.imul(nt2, bt2) | 0, v3 = v3 + Math.imul(nt2, yt2) | 0, l2 = l2 + Math.imul(et2, wt2) | 0, s = s + Math.imul(et2, xt2) | 0, s = s + Math.imul(rt2, wt2) | 0, v3 = v3 + Math.imul(rt2, xt2) | 0, l2 = l2 + Math.imul($2, Mt2) | 0, s = s + Math.imul($2, Et2) | 0, s = s + Math.imul(tt2, Mt2) | 0, v3 = v3 + Math.imul(tt2, Et2) | 0, l2 = l2 + Math.imul(X2, St2) | 0, s = s + Math.imul(X2, Nt2) | 0, s = s + Math.imul(Z2, St2) | 0, v3 = v3 + Math.imul(Z2, Nt2) | 0, l2 = l2 + Math.imul(D2, It2) | 0, s = s + Math.imul(D2, _t2) | 0, s = s + Math.imul(q2, It2) | 0, v3 = v3 + Math.imul(q2, _t2) | 0;
      var ii = (M2 + l2 | 0) + ((s & 8191) << 13) | 0;
      M2 = (v3 + (s >>> 13) | 0) + (ii >>> 26) | 0, ii &= 67108863, l2 = Math.imul(st2, gt2), s = Math.imul(st2, At3), s = s + Math.imul(at2, gt2) | 0, v3 = Math.imul(at2, At3), l2 = l2 + Math.imul(ft2, bt2) | 0, s = s + Math.imul(ft2, yt2) | 0, s = s + Math.imul(ot2, bt2) | 0, v3 = v3 + Math.imul(ot2, yt2) | 0, l2 = l2 + Math.imul(it2, wt2) | 0, s = s + Math.imul(it2, xt2) | 0, s = s + Math.imul(nt2, wt2) | 0, v3 = v3 + Math.imul(nt2, xt2) | 0, l2 = l2 + Math.imul(et2, Mt2) | 0, s = s + Math.imul(et2, Et2) | 0, s = s + Math.imul(rt2, Mt2) | 0, v3 = v3 + Math.imul(rt2, Et2) | 0, l2 = l2 + Math.imul($2, St2) | 0, s = s + Math.imul($2, Nt2) | 0, s = s + Math.imul(tt2, St2) | 0, v3 = v3 + Math.imul(tt2, Nt2) | 0, l2 = l2 + Math.imul(X2, It2) | 0, s = s + Math.imul(X2, _t2) | 0, s = s + Math.imul(Z2, It2) | 0, v3 = v3 + Math.imul(Z2, _t2) | 0;
      var ni = (M2 + l2 | 0) + ((s & 8191) << 13) | 0;
      M2 = (v3 + (s >>> 13) | 0) + (ni >>> 26) | 0, ni &= 67108863, l2 = Math.imul(st2, bt2), s = Math.imul(st2, yt2), s = s + Math.imul(at2, bt2) | 0, v3 = Math.imul(at2, yt2), l2 = l2 + Math.imul(ft2, wt2) | 0, s = s + Math.imul(ft2, xt2) | 0, s = s + Math.imul(ot2, wt2) | 0, v3 = v3 + Math.imul(ot2, xt2) | 0, l2 = l2 + Math.imul(it2, Mt2) | 0, s = s + Math.imul(it2, Et2) | 0, s = s + Math.imul(nt2, Mt2) | 0, v3 = v3 + Math.imul(nt2, Et2) | 0, l2 = l2 + Math.imul(et2, St2) | 0, s = s + Math.imul(et2, Nt2) | 0, s = s + Math.imul(rt2, St2) | 0, v3 = v3 + Math.imul(rt2, Nt2) | 0, l2 = l2 + Math.imul($2, It2) | 0, s = s + Math.imul($2, _t2) | 0, s = s + Math.imul(tt2, It2) | 0, v3 = v3 + Math.imul(tt2, _t2) | 0;
      var fi = (M2 + l2 | 0) + ((s & 8191) << 13) | 0;
      M2 = (v3 + (s >>> 13) | 0) + (fi >>> 26) | 0, fi &= 67108863, l2 = Math.imul(st2, wt2), s = Math.imul(st2, xt2), s = s + Math.imul(at2, wt2) | 0, v3 = Math.imul(at2, xt2), l2 = l2 + Math.imul(ft2, Mt2) | 0, s = s + Math.imul(ft2, Et2) | 0, s = s + Math.imul(ot2, Mt2) | 0, v3 = v3 + Math.imul(ot2, Et2) | 0, l2 = l2 + Math.imul(it2, St2) | 0, s = s + Math.imul(it2, Nt2) | 0, s = s + Math.imul(nt2, St2) | 0, v3 = v3 + Math.imul(nt2, Nt2) | 0, l2 = l2 + Math.imul(et2, It2) | 0, s = s + Math.imul(et2, _t2) | 0, s = s + Math.imul(rt2, It2) | 0, v3 = v3 + Math.imul(rt2, _t2) | 0;
      var oi = (M2 + l2 | 0) + ((s & 8191) << 13) | 0;
      M2 = (v3 + (s >>> 13) | 0) + (oi >>> 26) | 0, oi &= 67108863, l2 = Math.imul(st2, Mt2), s = Math.imul(st2, Et2), s = s + Math.imul(at2, Mt2) | 0, v3 = Math.imul(at2, Et2), l2 = l2 + Math.imul(ft2, St2) | 0, s = s + Math.imul(ft2, Nt2) | 0, s = s + Math.imul(ot2, St2) | 0, v3 = v3 + Math.imul(ot2, Nt2) | 0, l2 = l2 + Math.imul(it2, It2) | 0, s = s + Math.imul(it2, _t2) | 0, s = s + Math.imul(nt2, It2) | 0, v3 = v3 + Math.imul(nt2, _t2) | 0;
      var si = (M2 + l2 | 0) + ((s & 8191) << 13) | 0;
      M2 = (v3 + (s >>> 13) | 0) + (si >>> 26) | 0, si &= 67108863, l2 = Math.imul(st2, St2), s = Math.imul(st2, Nt2), s = s + Math.imul(at2, St2) | 0, v3 = Math.imul(at2, Nt2), l2 = l2 + Math.imul(ft2, It2) | 0, s = s + Math.imul(ft2, _t2) | 0, s = s + Math.imul(ot2, It2) | 0, v3 = v3 + Math.imul(ot2, _t2) | 0;
      var ai = (M2 + l2 | 0) + ((s & 8191) << 13) | 0;
      M2 = (v3 + (s >>> 13) | 0) + (ai >>> 26) | 0, ai &= 67108863, l2 = Math.imul(st2, It2), s = Math.imul(st2, _t2), s = s + Math.imul(at2, It2) | 0, v3 = Math.imul(at2, _t2);
      var ui = (M2 + l2 | 0) + ((s & 8191) << 13) | 0;
      return M2 = (v3 + (s >>> 13) | 0) + (ui >>> 26) | 0, ui &= 67108863, x2[0] = Me2, x2[1] = Ee2, x2[2] = Se2, x2[3] = Ne, x2[4] = Ie, x2[5] = Wr, x2[6] = Xr, x2[7] = Zr, x2[8] = $r2, x2[9] = ti, x2[10] = ei, x2[11] = ri, x2[12] = ii, x2[13] = ni, x2[14] = fi, x2[15] = oi, x2[16] = si, x2[17] = ai, x2[18] = ui, M2 !== 0 && (x2[19] = M2, c2.length++), c2;
    };
    Math.imul || (J2 = U2);
    function Bt2(A2, f3, a3) {
      a3.negative = f3.negative ^ A2.negative, a3.length = A2.length + f3.length;
      for (var c2 = 0, d4 = 0, g3 = 0; g3 < a3.length - 1; g3++) {
        var x2 = d4;
        d4 = 0;
        for (var M2 = c2 & 67108863, l2 = Math.min(g3, f3.length - 1), s = Math.max(0, g3 - A2.length + 1); s <= l2; s++) {
          var v3 = g3 - s, k2 = A2.words[v3] | 0, u2 = f3.words[s] | 0, E3 = k2 * u2, _3 = E3 & 67108863;
          x2 = x2 + (E3 / 67108864 | 0) | 0, _3 = _3 + M2 | 0, M2 = _3 & 67108863, x2 = x2 + (_3 >>> 26) | 0, d4 += x2 >>> 26, x2 &= 67108863;
        }
        a3.words[g3] = M2, c2 = x2, x2 = d4;
      }
      return c2 !== 0 ? a3.words[g3] = c2 : a3.length--, a3._strip();
    }
    function G2(A2, f3, a3) {
      return Bt2(A2, f3, a3);
    }
    o2.prototype.mulTo = function(f3, a3) {
      var c2, d4 = this.length + f3.length;
      return this.length === 10 && f3.length === 10 ? c2 = J2(this, f3, a3) : d4 < 63 ? c2 = U2(this, f3, a3) : d4 < 1024 ? c2 = Bt2(this, f3, a3) : c2 = G2(this, f3, a3), c2;
    }, o2.prototype.mul = function(f3) {
      var a3 = new o2(null);
      return a3.words = new Array(this.length + f3.length), this.mulTo(f3, a3);
    }, o2.prototype.mulf = function(f3) {
      var a3 = new o2(null);
      return a3.words = new Array(this.length + f3.length), G2(this, f3, a3);
    }, o2.prototype.imul = function(f3) {
      return this.clone().mulTo(f3, this);
    }, o2.prototype.imuln = function(f3) {
      var a3 = f3 < 0;
      a3 && (f3 = -f3), i2(typeof f3 == "number"), i2(f3 < 67108864);
      for (var c2 = 0, d4 = 0; d4 < this.length; d4++) {
        var g3 = (this.words[d4] | 0) * f3, x2 = (g3 & 67108863) + (c2 & 67108863);
        c2 >>= 26, c2 += g3 / 67108864 | 0, c2 += x2 >>> 26, this.words[d4] = x2 & 67108863;
      }
      return c2 !== 0 && (this.words[d4] = c2, this.length++), a3 ? this.ineg() : this;
    }, o2.prototype.muln = function(f3) {
      return this.clone().imuln(f3);
    }, o2.prototype.sqr = function() {
      return this.mul(this);
    }, o2.prototype.isqr = function() {
      return this.imul(this.clone());
    }, o2.prototype.pow = function(f3) {
      var a3 = F2(f3);
      if (a3.length === 0)
        return new o2(1);
      for (var c2 = this, d4 = 0; d4 < a3.length && a3[d4] === 0; d4++, c2 = c2.sqr())
        ;
      if (++d4 < a3.length)
        for (var g3 = c2.sqr(); d4 < a3.length; d4++, g3 = g3.sqr())
          a3[d4] !== 0 && (c2 = c2.mul(g3));
      return c2;
    }, o2.prototype.iushln = function(f3) {
      i2(typeof f3 == "number" && f3 >= 0);
      var a3 = f3 % 26, c2 = (f3 - a3) / 26, d4 = 67108863 >>> 26 - a3 << 26 - a3, g3;
      if (a3 !== 0) {
        var x2 = 0;
        for (g3 = 0; g3 < this.length; g3++) {
          var M2 = this.words[g3] & d4, l2 = (this.words[g3] | 0) - M2 << a3;
          this.words[g3] = l2 | x2, x2 = M2 >>> 26 - a3;
        }
        x2 && (this.words[g3] = x2, this.length++);
      }
      if (c2 !== 0) {
        for (g3 = this.length - 1; g3 >= 0; g3--)
          this.words[g3 + c2] = this.words[g3];
        for (g3 = 0; g3 < c2; g3++)
          this.words[g3] = 0;
        this.length += c2;
      }
      return this._strip();
    }, o2.prototype.ishln = function(f3) {
      return i2(this.negative === 0), this.iushln(f3);
    }, o2.prototype.iushrn = function(f3, a3, c2) {
      i2(typeof f3 == "number" && f3 >= 0);
      var d4;
      a3 ? d4 = (a3 - a3 % 26) / 26 : d4 = 0;
      var g3 = f3 % 26, x2 = Math.min((f3 - g3) / 26, this.length), M2 = 67108863 ^ 67108863 >>> g3 << g3, l2 = c2;
      if (d4 -= x2, d4 = Math.max(0, d4), l2) {
        for (var s = 0; s < x2; s++)
          l2.words[s] = this.words[s];
        l2.length = x2;
      }
      if (x2 !== 0)
        if (this.length > x2)
          for (this.length -= x2, s = 0; s < this.length; s++)
            this.words[s] = this.words[s + x2];
        else
          this.words[0] = 0, this.length = 1;
      var v3 = 0;
      for (s = this.length - 1; s >= 0 && (v3 !== 0 || s >= d4); s--) {
        var k2 = this.words[s] | 0;
        this.words[s] = v3 << 26 - g3 | k2 >>> g3, v3 = k2 & M2;
      }
      return l2 && v3 !== 0 && (l2.words[l2.length++] = v3), this.length === 0 && (this.words[0] = 0, this.length = 1), this._strip();
    }, o2.prototype.ishrn = function(f3, a3, c2) {
      return i2(this.negative === 0), this.iushrn(f3, a3, c2);
    }, o2.prototype.shln = function(f3) {
      return this.clone().ishln(f3);
    }, o2.prototype.ushln = function(f3) {
      return this.clone().iushln(f3);
    }, o2.prototype.shrn = function(f3) {
      return this.clone().ishrn(f3);
    }, o2.prototype.ushrn = function(f3) {
      return this.clone().iushrn(f3);
    }, o2.prototype.testn = function(f3) {
      i2(typeof f3 == "number" && f3 >= 0);
      var a3 = f3 % 26, c2 = (f3 - a3) / 26, d4 = 1 << a3;
      if (this.length <= c2)
        return false;
      var g3 = this.words[c2];
      return !!(g3 & d4);
    }, o2.prototype.imaskn = function(f3) {
      i2(typeof f3 == "number" && f3 >= 0);
      var a3 = f3 % 26, c2 = (f3 - a3) / 26;
      if (i2(this.negative === 0, "imaskn works only with positive numbers"), this.length <= c2)
        return this;
      if (a3 !== 0 && c2++, this.length = Math.min(c2, this.length), a3 !== 0) {
        var d4 = 67108863 ^ 67108863 >>> a3 << a3;
        this.words[this.length - 1] &= d4;
      }
      return this._strip();
    }, o2.prototype.maskn = function(f3) {
      return this.clone().imaskn(f3);
    }, o2.prototype.iaddn = function(f3) {
      return i2(typeof f3 == "number"), i2(f3 < 67108864), f3 < 0 ? this.isubn(-f3) : this.negative !== 0 ? this.length === 1 && (this.words[0] | 0) <= f3 ? (this.words[0] = f3 - (this.words[0] | 0), this.negative = 0, this) : (this.negative = 0, this.isubn(f3), this.negative = 1, this) : this._iaddn(f3);
    }, o2.prototype._iaddn = function(f3) {
      this.words[0] += f3;
      for (var a3 = 0; a3 < this.length && this.words[a3] >= 67108864; a3++)
        this.words[a3] -= 67108864, a3 === this.length - 1 ? this.words[a3 + 1] = 1 : this.words[a3 + 1]++;
      return this.length = Math.max(this.length, a3 + 1), this;
    }, o2.prototype.isubn = function(f3) {
      if (i2(typeof f3 == "number"), i2(f3 < 67108864), f3 < 0)
        return this.iaddn(-f3);
      if (this.negative !== 0)
        return this.negative = 0, this.iaddn(f3), this.negative = 1, this;
      if (this.words[0] -= f3, this.length === 1 && this.words[0] < 0)
        this.words[0] = -this.words[0], this.negative = 1;
      else
        for (var a3 = 0; a3 < this.length && this.words[a3] < 0; a3++)
          this.words[a3] += 67108864, this.words[a3 + 1] -= 1;
      return this._strip();
    }, o2.prototype.addn = function(f3) {
      return this.clone().iaddn(f3);
    }, o2.prototype.subn = function(f3) {
      return this.clone().isubn(f3);
    }, o2.prototype.iabs = function() {
      return this.negative = 0, this;
    }, o2.prototype.abs = function() {
      return this.clone().iabs();
    }, o2.prototype._ishlnsubmul = function(f3, a3, c2) {
      var d4 = f3.length + c2, g3;
      this._expand(d4);
      var x2, M2 = 0;
      for (g3 = 0; g3 < f3.length; g3++) {
        x2 = (this.words[g3 + c2] | 0) + M2;
        var l2 = (f3.words[g3] | 0) * a3;
        x2 -= l2 & 67108863, M2 = (x2 >> 26) - (l2 / 67108864 | 0), this.words[g3 + c2] = x2 & 67108863;
      }
      for (; g3 < this.length - c2; g3++)
        x2 = (this.words[g3 + c2] | 0) + M2, M2 = x2 >> 26, this.words[g3 + c2] = x2 & 67108863;
      if (M2 === 0)
        return this._strip();
      for (i2(M2 === -1), M2 = 0, g3 = 0; g3 < this.length; g3++)
        x2 = -(this.words[g3] | 0) + M2, M2 = x2 >> 26, this.words[g3] = x2 & 67108863;
      return this.negative = 1, this._strip();
    }, o2.prototype._wordDiv = function(f3, a3) {
      var c2 = this.length - f3.length, d4 = this.clone(), g3 = f3, x2 = g3.words[g3.length - 1] | 0, M2 = this._countBits(x2);
      c2 = 26 - M2, c2 !== 0 && (g3 = g3.ushln(c2), d4.iushln(c2), x2 = g3.words[g3.length - 1] | 0);
      var l2 = d4.length - g3.length, s;
      if (a3 !== "mod") {
        s = new o2(null), s.length = l2 + 1, s.words = new Array(s.length);
        for (var v3 = 0; v3 < s.length; v3++)
          s.words[v3] = 0;
      }
      var k2 = d4.clone()._ishlnsubmul(g3, 1, l2);
      k2.negative === 0 && (d4 = k2, s && (s.words[l2] = 1));
      for (var u2 = l2 - 1; u2 >= 0; u2--) {
        var E3 = (d4.words[g3.length + u2] | 0) * 67108864 + (d4.words[g3.length + u2 - 1] | 0);
        for (E3 = Math.min(E3 / x2 | 0, 67108863), d4._ishlnsubmul(g3, E3, u2); d4.negative !== 0; )
          E3--, d4.negative = 0, d4._ishlnsubmul(g3, 1, u2), d4.isZero() || (d4.negative ^= 1);
        s && (s.words[u2] = E3);
      }
      return s && s._strip(), d4._strip(), a3 !== "div" && c2 !== 0 && d4.iushrn(c2), { div: s || null, mod: d4 };
    }, o2.prototype.divmod = function(f3, a3, c2) {
      if (i2(!f3.isZero()), this.isZero())
        return { div: new o2(0), mod: new o2(0) };
      var d4, g3, x2;
      return this.negative !== 0 && f3.negative === 0 ? (x2 = this.neg().divmod(f3, a3), a3 !== "mod" && (d4 = x2.div.neg()), a3 !== "div" && (g3 = x2.mod.neg(), c2 && g3.negative !== 0 && g3.iadd(f3)), { div: d4, mod: g3 }) : this.negative === 0 && f3.negative !== 0 ? (x2 = this.divmod(f3.neg(), a3), a3 !== "mod" && (d4 = x2.div.neg()), { div: d4, mod: x2.mod }) : this.negative & f3.negative ? (x2 = this.neg().divmod(f3.neg(), a3), a3 !== "div" && (g3 = x2.mod.neg(), c2 && g3.negative !== 0 && g3.isub(f3)), { div: x2.div, mod: g3 }) : f3.length > this.length || this.cmp(f3) < 0 ? { div: new o2(0), mod: this } : f3.length === 1 ? a3 === "div" ? { div: this.divn(f3.words[0]), mod: null } : a3 === "mod" ? { div: null, mod: new o2(this.modrn(f3.words[0])) } : { div: this.divn(f3.words[0]), mod: new o2(this.modrn(f3.words[0])) } : this._wordDiv(f3, a3);
    }, o2.prototype.div = function(f3) {
      return this.divmod(f3, "div", false).div;
    }, o2.prototype.mod = function(f3) {
      return this.divmod(f3, "mod", false).mod;
    }, o2.prototype.umod = function(f3) {
      return this.divmod(f3, "mod", true).mod;
    }, o2.prototype.divRound = function(f3) {
      var a3 = this.divmod(f3);
      if (a3.mod.isZero())
        return a3.div;
      var c2 = a3.div.negative !== 0 ? a3.mod.isub(f3) : a3.mod, d4 = f3.ushrn(1), g3 = f3.andln(1), x2 = c2.cmp(d4);
      return x2 < 0 || g3 === 1 && x2 === 0 ? a3.div : a3.div.negative !== 0 ? a3.div.isubn(1) : a3.div.iaddn(1);
    }, o2.prototype.modrn = function(f3) {
      var a3 = f3 < 0;
      a3 && (f3 = -f3), i2(f3 <= 67108863);
      for (var c2 = (1 << 26) % f3, d4 = 0, g3 = this.length - 1; g3 >= 0; g3--)
        d4 = (c2 * d4 + (this.words[g3] | 0)) % f3;
      return a3 ? -d4 : d4;
    }, o2.prototype.modn = function(f3) {
      return this.modrn(f3);
    }, o2.prototype.idivn = function(f3) {
      var a3 = f3 < 0;
      a3 && (f3 = -f3), i2(f3 <= 67108863);
      for (var c2 = 0, d4 = this.length - 1; d4 >= 0; d4--) {
        var g3 = (this.words[d4] | 0) + c2 * 67108864;
        this.words[d4] = g3 / f3 | 0, c2 = g3 % f3;
      }
      return this._strip(), a3 ? this.ineg() : this;
    }, o2.prototype.divn = function(f3) {
      return this.clone().idivn(f3);
    }, o2.prototype.egcd = function(f3) {
      i2(f3.negative === 0), i2(!f3.isZero());
      var a3 = this, c2 = f3.clone();
      a3.negative !== 0 ? a3 = a3.umod(f3) : a3 = a3.clone();
      for (var d4 = new o2(1), g3 = new o2(0), x2 = new o2(0), M2 = new o2(1), l2 = 0; a3.isEven() && c2.isEven(); )
        a3.iushrn(1), c2.iushrn(1), ++l2;
      for (var s = c2.clone(), v3 = a3.clone(); !a3.isZero(); ) {
        for (var k2 = 0, u2 = 1; !(a3.words[0] & u2) && k2 < 26; ++k2, u2 <<= 1)
          ;
        if (k2 > 0)
          for (a3.iushrn(k2); k2-- > 0; )
            (d4.isOdd() || g3.isOdd()) && (d4.iadd(s), g3.isub(v3)), d4.iushrn(1), g3.iushrn(1);
        for (var E3 = 0, _3 = 1; !(c2.words[0] & _3) && E3 < 26; ++E3, _3 <<= 1)
          ;
        if (E3 > 0)
          for (c2.iushrn(E3); E3-- > 0; )
            (x2.isOdd() || M2.isOdd()) && (x2.iadd(s), M2.isub(v3)), x2.iushrn(1), M2.iushrn(1);
        a3.cmp(c2) >= 0 ? (a3.isub(c2), d4.isub(x2), g3.isub(M2)) : (c2.isub(a3), x2.isub(d4), M2.isub(g3));
      }
      return { a: x2, b: M2, gcd: c2.iushln(l2) };
    }, o2.prototype._invmp = function(f3) {
      i2(f3.negative === 0), i2(!f3.isZero());
      var a3 = this, c2 = f3.clone();
      a3.negative !== 0 ? a3 = a3.umod(f3) : a3 = a3.clone();
      for (var d4 = new o2(1), g3 = new o2(0), x2 = c2.clone(); a3.cmpn(1) > 0 && c2.cmpn(1) > 0; ) {
        for (var M2 = 0, l2 = 1; !(a3.words[0] & l2) && M2 < 26; ++M2, l2 <<= 1)
          ;
        if (M2 > 0)
          for (a3.iushrn(M2); M2-- > 0; )
            d4.isOdd() && d4.iadd(x2), d4.iushrn(1);
        for (var s = 0, v3 = 1; !(c2.words[0] & v3) && s < 26; ++s, v3 <<= 1)
          ;
        if (s > 0)
          for (c2.iushrn(s); s-- > 0; )
            g3.isOdd() && g3.iadd(x2), g3.iushrn(1);
        a3.cmp(c2) >= 0 ? (a3.isub(c2), d4.isub(g3)) : (c2.isub(a3), g3.isub(d4));
      }
      var k2;
      return a3.cmpn(1) === 0 ? k2 = d4 : k2 = g3, k2.cmpn(0) < 0 && k2.iadd(f3), k2;
    }, o2.prototype.gcd = function(f3) {
      if (this.isZero())
        return f3.abs();
      if (f3.isZero())
        return this.abs();
      var a3 = this.clone(), c2 = f3.clone();
      a3.negative = 0, c2.negative = 0;
      for (var d4 = 0; a3.isEven() && c2.isEven(); d4++)
        a3.iushrn(1), c2.iushrn(1);
      do {
        for (; a3.isEven(); )
          a3.iushrn(1);
        for (; c2.isEven(); )
          c2.iushrn(1);
        var g3 = a3.cmp(c2);
        if (g3 < 0) {
          var x2 = a3;
          a3 = c2, c2 = x2;
        } else if (g3 === 0 || c2.cmpn(1) === 0)
          break;
        a3.isub(c2);
      } while (true);
      return c2.iushln(d4);
    }, o2.prototype.invm = function(f3) {
      return this.egcd(f3).a.umod(f3);
    }, o2.prototype.isEven = function() {
      return (this.words[0] & 1) === 0;
    }, o2.prototype.isOdd = function() {
      return (this.words[0] & 1) === 1;
    }, o2.prototype.andln = function(f3) {
      return this.words[0] & f3;
    }, o2.prototype.bincn = function(f3) {
      i2(typeof f3 == "number");
      var a3 = f3 % 26, c2 = (f3 - a3) / 26, d4 = 1 << a3;
      if (this.length <= c2)
        return this._expand(c2 + 1), this.words[c2] |= d4, this;
      for (var g3 = d4, x2 = c2; g3 !== 0 && x2 < this.length; x2++) {
        var M2 = this.words[x2] | 0;
        M2 += g3, g3 = M2 >>> 26, M2 &= 67108863, this.words[x2] = M2;
      }
      return g3 !== 0 && (this.words[x2] = g3, this.length++), this;
    }, o2.prototype.isZero = function() {
      return this.length === 1 && this.words[0] === 0;
    }, o2.prototype.cmpn = function(f3) {
      var a3 = f3 < 0;
      if (this.negative !== 0 && !a3)
        return -1;
      if (this.negative === 0 && a3)
        return 1;
      this._strip();
      var c2;
      if (this.length > 1)
        c2 = 1;
      else {
        a3 && (f3 = -f3), i2(f3 <= 67108863, "Number is too big");
        var d4 = this.words[0] | 0;
        c2 = d4 === f3 ? 0 : d4 < f3 ? -1 : 1;
      }
      return this.negative !== 0 ? -c2 | 0 : c2;
    }, o2.prototype.cmp = function(f3) {
      if (this.negative !== 0 && f3.negative === 0)
        return -1;
      if (this.negative === 0 && f3.negative !== 0)
        return 1;
      var a3 = this.ucmp(f3);
      return this.negative !== 0 ? -a3 | 0 : a3;
    }, o2.prototype.ucmp = function(f3) {
      if (this.length > f3.length)
        return 1;
      if (this.length < f3.length)
        return -1;
      for (var a3 = 0, c2 = this.length - 1; c2 >= 0; c2--) {
        var d4 = this.words[c2] | 0, g3 = f3.words[c2] | 0;
        if (d4 !== g3) {
          d4 < g3 ? a3 = -1 : d4 > g3 && (a3 = 1);
          break;
        }
      }
      return a3;
    }, o2.prototype.gtn = function(f3) {
      return this.cmpn(f3) === 1;
    }, o2.prototype.gt = function(f3) {
      return this.cmp(f3) === 1;
    }, o2.prototype.gten = function(f3) {
      return this.cmpn(f3) >= 0;
    }, o2.prototype.gte = function(f3) {
      return this.cmp(f3) >= 0;
    }, o2.prototype.ltn = function(f3) {
      return this.cmpn(f3) === -1;
    }, o2.prototype.lt = function(f3) {
      return this.cmp(f3) === -1;
    }, o2.prototype.lten = function(f3) {
      return this.cmpn(f3) <= 0;
    }, o2.prototype.lte = function(f3) {
      return this.cmp(f3) <= 0;
    }, o2.prototype.eqn = function(f3) {
      return this.cmpn(f3) === 0;
    }, o2.prototype.eq = function(f3) {
      return this.cmp(f3) === 0;
    }, o2.red = function(f3) {
      return new Y2(f3);
    }, o2.prototype.toRed = function(f3) {
      return i2(!this.red, "Already a number in reduction context"), i2(this.negative === 0, "red works only with positives"), f3.convertTo(this)._forceRed(f3);
    }, o2.prototype.fromRed = function() {
      return i2(this.red, "fromRed works only with numbers in reduction context"), this.red.convertFrom(this);
    }, o2.prototype._forceRed = function(f3) {
      return this.red = f3, this;
    }, o2.prototype.forceRed = function(f3) {
      return i2(!this.red, "Already a number in reduction context"), this._forceRed(f3);
    }, o2.prototype.redAdd = function(f3) {
      return i2(this.red, "redAdd works only with red numbers"), this.red.add(this, f3);
    }, o2.prototype.redIAdd = function(f3) {
      return i2(this.red, "redIAdd works only with red numbers"), this.red.iadd(this, f3);
    }, o2.prototype.redSub = function(f3) {
      return i2(this.red, "redSub works only with red numbers"), this.red.sub(this, f3);
    }, o2.prototype.redISub = function(f3) {
      return i2(this.red, "redISub works only with red numbers"), this.red.isub(this, f3);
    }, o2.prototype.redShl = function(f3) {
      return i2(this.red, "redShl works only with red numbers"), this.red.shl(this, f3);
    }, o2.prototype.redMul = function(f3) {
      return i2(this.red, "redMul works only with red numbers"), this.red._verify2(this, f3), this.red.mul(this, f3);
    }, o2.prototype.redIMul = function(f3) {
      return i2(this.red, "redMul works only with red numbers"), this.red._verify2(this, f3), this.red.imul(this, f3);
    }, o2.prototype.redSqr = function() {
      return i2(this.red, "redSqr works only with red numbers"), this.red._verify1(this), this.red.sqr(this);
    }, o2.prototype.redISqr = function() {
      return i2(this.red, "redISqr works only with red numbers"), this.red._verify1(this), this.red.isqr(this);
    }, o2.prototype.redSqrt = function() {
      return i2(this.red, "redSqrt works only with red numbers"), this.red._verify1(this), this.red.sqrt(this);
    }, o2.prototype.redInvm = function() {
      return i2(this.red, "redInvm works only with red numbers"), this.red._verify1(this), this.red.invm(this);
    }, o2.prototype.redNeg = function() {
      return i2(this.red, "redNeg works only with red numbers"), this.red._verify1(this), this.red.neg(this);
    }, o2.prototype.redPow = function(f3) {
      return i2(this.red && !f3.red, "redPow(normalNum)"), this.red._verify1(this), this.red.pow(this, f3);
    };
    var H2 = { k256: null, p224: null, p192: null, p25519: null };
    function z2(A2, f3) {
      this.name = A2, this.p = new o2(f3, 16), this.n = this.p.bitLength(), this.k = new o2(1).iushln(this.n).isub(this.p), this.tmp = this._tmp();
    }
    z2.prototype._tmp = function() {
      var f3 = new o2(null);
      return f3.words = new Array(Math.ceil(this.n / 13)), f3;
    }, z2.prototype.ireduce = function(f3) {
      var a3 = f3, c2;
      do
        this.split(a3, this.tmp), a3 = this.imulK(a3), a3 = a3.iadd(this.tmp), c2 = a3.bitLength();
      while (c2 > this.n);
      var d4 = c2 < this.n ? -1 : a3.ucmp(this.p);
      return d4 === 0 ? (a3.words[0] = 0, a3.length = 1) : d4 > 0 ? a3.isub(this.p) : a3.strip !== void 0 ? a3.strip() : a3._strip(), a3;
    }, z2.prototype.split = function(f3, a3) {
      f3.iushrn(this.n, 0, a3);
    }, z2.prototype.imulK = function(f3) {
      return f3.imul(this.k);
    };
    function Pt2() {
      z2.call(this, "k256", "ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff fffffffe fffffc2f");
    }
    n2(Pt2, z2), Pt2.prototype.split = function(f3, a3) {
      for (var c2 = 4194303, d4 = Math.min(f3.length, 9), g3 = 0; g3 < d4; g3++)
        a3.words[g3] = f3.words[g3];
      if (a3.length = d4, f3.length <= 9) {
        f3.words[0] = 0, f3.length = 1;
        return;
      }
      var x2 = f3.words[9];
      for (a3.words[a3.length++] = x2 & c2, g3 = 10; g3 < f3.length; g3++) {
        var M2 = f3.words[g3] | 0;
        f3.words[g3 - 10] = (M2 & c2) << 4 | x2 >>> 22, x2 = M2;
      }
      x2 >>>= 22, f3.words[g3 - 10] = x2, x2 === 0 && f3.length > 10 ? f3.length -= 10 : f3.length -= 9;
    }, Pt2.prototype.imulK = function(f3) {
      f3.words[f3.length] = 0, f3.words[f3.length + 1] = 0, f3.length += 2;
      for (var a3 = 0, c2 = 0; c2 < f3.length; c2++) {
        var d4 = f3.words[c2] | 0;
        a3 += d4 * 977, f3.words[c2] = a3 & 67108863, a3 = d4 * 64 + (a3 / 67108864 | 0);
      }
      return f3.words[f3.length - 1] === 0 && (f3.length--, f3.words[f3.length - 1] === 0 && f3.length--), f3;
    };
    function W2() {
      z2.call(this, "p224", "ffffffff ffffffff ffffffff ffffffff 00000000 00000000 00000001");
    }
    n2(W2, z2);
    function Rt2() {
      z2.call(this, "p192", "ffffffff ffffffff ffffffff fffffffe ffffffff ffffffff");
    }
    n2(Rt2, z2);
    function Yt3() {
      z2.call(this, "25519", "7fffffffffffffff ffffffffffffffff ffffffffffffffff ffffffffffffffed");
    }
    n2(Yt3, z2), Yt3.prototype.imulK = function(f3) {
      for (var a3 = 0, c2 = 0; c2 < f3.length; c2++) {
        var d4 = (f3.words[c2] | 0) * 19 + a3, g3 = d4 & 67108863;
        d4 >>>= 26, f3.words[c2] = g3, a3 = d4;
      }
      return a3 !== 0 && (f3.words[f3.length++] = a3), f3;
    }, o2._prime = function(f3) {
      if (H2[f3])
        return H2[f3];
      var a3;
      if (f3 === "k256")
        a3 = new Pt2();
      else if (f3 === "p224")
        a3 = new W2();
      else if (f3 === "p192")
        a3 = new Rt2();
      else if (f3 === "p25519")
        a3 = new Yt3();
      else
        throw new Error("Unknown prime " + f3);
      return H2[f3] = a3, a3;
    };
    function Y2(A2) {
      if (typeof A2 == "string") {
        var f3 = o2._prime(A2);
        this.m = f3.p, this.prime = f3;
      } else
        i2(A2.gtn(1), "modulus must be greater than 1"), this.m = A2, this.prime = null;
    }
    Y2.prototype._verify1 = function(f3) {
      i2(f3.negative === 0, "red works only with positives"), i2(f3.red, "red works only with red numbers");
    }, Y2.prototype._verify2 = function(f3, a3) {
      i2((f3.negative | a3.negative) === 0, "red works only with positives"), i2(f3.red && f3.red === a3.red, "red works only with red numbers");
    }, Y2.prototype.imod = function(f3) {
      return this.prime ? this.prime.ireduce(f3)._forceRed(this) : (w3(f3, f3.umod(this.m)._forceRed(this)), f3);
    }, Y2.prototype.neg = function(f3) {
      return f3.isZero() ? f3.clone() : this.m.sub(f3)._forceRed(this);
    }, Y2.prototype.add = function(f3, a3) {
      this._verify2(f3, a3);
      var c2 = f3.add(a3);
      return c2.cmp(this.m) >= 0 && c2.isub(this.m), c2._forceRed(this);
    }, Y2.prototype.iadd = function(f3, a3) {
      this._verify2(f3, a3);
      var c2 = f3.iadd(a3);
      return c2.cmp(this.m) >= 0 && c2.isub(this.m), c2;
    }, Y2.prototype.sub = function(f3, a3) {
      this._verify2(f3, a3);
      var c2 = f3.sub(a3);
      return c2.cmpn(0) < 0 && c2.iadd(this.m), c2._forceRed(this);
    }, Y2.prototype.isub = function(f3, a3) {
      this._verify2(f3, a3);
      var c2 = f3.isub(a3);
      return c2.cmpn(0) < 0 && c2.iadd(this.m), c2;
    }, Y2.prototype.shl = function(f3, a3) {
      return this._verify1(f3), this.imod(f3.ushln(a3));
    }, Y2.prototype.imul = function(f3, a3) {
      return this._verify2(f3, a3), this.imod(f3.imul(a3));
    }, Y2.prototype.mul = function(f3, a3) {
      return this._verify2(f3, a3), this.imod(f3.mul(a3));
    }, Y2.prototype.isqr = function(f3) {
      return this.imul(f3, f3.clone());
    }, Y2.prototype.sqr = function(f3) {
      return this.mul(f3, f3);
    }, Y2.prototype.sqrt = function(f3) {
      if (f3.isZero())
        return f3.clone();
      var a3 = this.m.andln(3);
      if (i2(a3 % 2 === 1), a3 === 3) {
        var c2 = this.m.add(new o2(1)).iushrn(2);
        return this.pow(f3, c2);
      }
      for (var d4 = this.m.subn(1), g3 = 0; !d4.isZero() && d4.andln(1) === 0; )
        g3++, d4.iushrn(1);
      i2(!d4.isZero());
      var x2 = new o2(1).toRed(this), M2 = x2.redNeg(), l2 = this.m.subn(1).iushrn(1), s = this.m.bitLength();
      for (s = new o2(2 * s * s).toRed(this); this.pow(s, l2).cmp(M2) !== 0; )
        s.redIAdd(M2);
      for (var v3 = this.pow(s, d4), k2 = this.pow(f3, d4.addn(1).iushrn(1)), u2 = this.pow(f3, d4), E3 = g3; u2.cmp(x2) !== 0; ) {
        for (var _3 = u2, B3 = 0; _3.cmp(x2) !== 0; B3++)
          _3 = _3.redSqr();
        i2(B3 < E3);
        var R2 = this.pow(v3, new o2(1).iushln(E3 - B3 - 1));
        k2 = k2.redMul(R2), v3 = R2.redSqr(), u2 = u2.redMul(v3), E3 = B3;
      }
      return k2;
    }, Y2.prototype.invm = function(f3) {
      var a3 = f3._invmp(this.m);
      return a3.negative !== 0 ? (a3.negative = 0, this.imod(a3).redNeg()) : this.imod(a3);
    }, Y2.prototype.pow = function(f3, a3) {
      if (a3.isZero())
        return new o2(1).toRed(this);
      if (a3.cmpn(1) === 0)
        return f3.clone();
      var c2 = 4, d4 = new Array(1 << c2);
      d4[0] = new o2(1).toRed(this), d4[1] = f3;
      for (var g3 = 2; g3 < d4.length; g3++)
        d4[g3] = this.mul(d4[g3 - 1], f3);
      var x2 = d4[0], M2 = 0, l2 = 0, s = a3.bitLength() % 26;
      for (s === 0 && (s = 26), g3 = a3.length - 1; g3 >= 0; g3--) {
        for (var v3 = a3.words[g3], k2 = s - 1; k2 >= 0; k2--) {
          var u2 = v3 >> k2 & 1;
          if (x2 !== d4[0] && (x2 = this.sqr(x2)), u2 === 0 && M2 === 0) {
            l2 = 0;
            continue;
          }
          M2 <<= 1, M2 |= u2, l2++, !(l2 !== c2 && (g3 !== 0 || k2 !== 0)) && (x2 = this.mul(x2, d4[M2]), l2 = 0, M2 = 0);
        }
        s = 26;
      }
      return x2;
    }, Y2.prototype.convertTo = function(f3) {
      var a3 = f3.umod(this.m);
      return a3 === f3 ? a3.clone() : a3;
    }, Y2.prototype.convertFrom = function(f3) {
      var a3 = f3.clone();
      return a3.red = null, a3;
    }, o2.mont = function(f3) {
      return new Vt3(f3);
    };
    function Vt3(A2) {
      Y2.call(this, A2), this.shift = this.m.bitLength(), this.shift % 26 !== 0 && (this.shift += 26 - this.shift % 26), this.r = new o2(1).iushln(this.shift), this.r2 = this.imod(this.r.sqr()), this.rinv = this.r._invmp(this.m), this.minv = this.rinv.mul(this.r).isubn(1).div(this.m), this.minv = this.minv.umod(this.r), this.minv = this.r.sub(this.minv);
    }
    n2(Vt3, Y2), Vt3.prototype.convertTo = function(f3) {
      return this.imod(f3.ushln(this.shift));
    }, Vt3.prototype.convertFrom = function(f3) {
      var a3 = this.imod(f3.mul(this.rinv));
      return a3.red = null, a3;
    }, Vt3.prototype.imul = function(f3, a3) {
      if (f3.isZero() || a3.isZero())
        return f3.words[0] = 0, f3.length = 1, f3;
      var c2 = f3.imul(a3), d4 = c2.maskn(this.shift).mul(this.minv).imaskn(this.shift).mul(this.m), g3 = c2.isub(d4).iushrn(this.shift), x2 = g3;
      return g3.cmp(this.m) >= 0 ? x2 = g3.isub(this.m) : g3.cmpn(0) < 0 && (x2 = g3.iadd(this.m)), x2._forceRed(this);
    }, Vt3.prototype.mul = function(f3, a3) {
      if (f3.isZero() || a3.isZero())
        return new o2(0)._forceRed(this);
      var c2 = f3.mul(a3), d4 = c2.maskn(this.shift).mul(this.minv).imaskn(this.shift).mul(this.m), g3 = c2.isub(d4).iushrn(this.shift), x2 = g3;
      return g3.cmp(this.m) >= 0 ? x2 = g3.isub(this.m) : g3.cmpn(0) < 0 && (x2 = g3.iadd(this.m)), x2._forceRed(this);
    }, Vt3.prototype.invm = function(f3) {
      var a3 = this.imod(f3._invmp(this.m).mul(this.r2));
      return a3._forceRed(this);
    };
  })(e, On);
})(Ln);
var K$3 = Ln.exports;
const jn = "bignumber/5.7.0";
var Rr$2 = K$3.BN;
const Ae = new L$3(jn), wi = {}, Qn = 9007199254740991;
function C0(e) {
  return e != null && (V$3.isBigNumber(e) || typeof e == "number" && e % 1 === 0 || typeof e == "string" && !!e.match(/^-?[0-9]+$/) || Qt$1(e) || typeof e == "bigint" || ir$2(e));
}
let Jn = false;
let V$3 = class V {
  constructor(t, r) {
    t !== wi && Ae.throwError("cannot call constructor directly; use BigNumber.from", L$3.errors.UNSUPPORTED_OPERATION, { operation: "new (BigNumber)" }), this._hex = r, this._isBigNumber = true, Object.freeze(this);
  }
  fromTwos(t) {
    return Lt$2(j$2(this).fromTwos(t));
  }
  toTwos(t) {
    return Lt$2(j$2(this).toTwos(t));
  }
  abs() {
    return this._hex[0] === "-" ? V.from(this._hex.substring(1)) : this;
  }
  add(t) {
    return Lt$2(j$2(this).add(j$2(t)));
  }
  sub(t) {
    return Lt$2(j$2(this).sub(j$2(t)));
  }
  div(t) {
    return V.from(t).isZero() && Wt$3("division-by-zero", "div"), Lt$2(j$2(this).div(j$2(t)));
  }
  mul(t) {
    return Lt$2(j$2(this).mul(j$2(t)));
  }
  mod(t) {
    const r = j$2(t);
    return r.isNeg() && Wt$3("division-by-zero", "mod"), Lt$2(j$2(this).umod(r));
  }
  pow(t) {
    const r = j$2(t);
    return r.isNeg() && Wt$3("negative-power", "pow"), Lt$2(j$2(this).pow(r));
  }
  and(t) {
    const r = j$2(t);
    return (this.isNegative() || r.isNeg()) && Wt$3("unbound-bitwise-result", "and"), Lt$2(j$2(this).and(r));
  }
  or(t) {
    const r = j$2(t);
    return (this.isNegative() || r.isNeg()) && Wt$3("unbound-bitwise-result", "or"), Lt$2(j$2(this).or(r));
  }
  xor(t) {
    const r = j$2(t);
    return (this.isNegative() || r.isNeg()) && Wt$3("unbound-bitwise-result", "xor"), Lt$2(j$2(this).xor(r));
  }
  mask(t) {
    return (this.isNegative() || t < 0) && Wt$3("negative-width", "mask"), Lt$2(j$2(this).maskn(t));
  }
  shl(t) {
    return (this.isNegative() || t < 0) && Wt$3("negative-width", "shl"), Lt$2(j$2(this).shln(t));
  }
  shr(t) {
    return (this.isNegative() || t < 0) && Wt$3("negative-width", "shr"), Lt$2(j$2(this).shrn(t));
  }
  eq(t) {
    return j$2(this).eq(j$2(t));
  }
  lt(t) {
    return j$2(this).lt(j$2(t));
  }
  lte(t) {
    return j$2(this).lte(j$2(t));
  }
  gt(t) {
    return j$2(this).gt(j$2(t));
  }
  gte(t) {
    return j$2(this).gte(j$2(t));
  }
  isNegative() {
    return this._hex[0] === "-";
  }
  isZero() {
    return j$2(this).isZero();
  }
  toNumber() {
    try {
      return j$2(this).toNumber();
    } catch {
      Wt$3("overflow", "toNumber", this.toString());
    }
    return null;
  }
  toBigInt() {
    try {
      return BigInt(this.toString());
    } catch {
    }
    return Ae.throwError("this platform does not support BigInt", L$3.errors.UNSUPPORTED_OPERATION, { value: this.toString() });
  }
  toString() {
    return arguments.length > 0 && (arguments[0] === 10 ? Jn || (Jn = true, Ae.warn("BigNumber.toString does not accept any parameters; base-10 is assumed")) : arguments[0] === 16 ? Ae.throwError("BigNumber.toString does not accept any parameters; use bigNumber.toHexString()", L$3.errors.UNEXPECTED_ARGUMENT, {}) : Ae.throwError("BigNumber.toString does not accept parameters", L$3.errors.UNEXPECTED_ARGUMENT, {})), j$2(this).toString(10);
  }
  toHexString() {
    return this._hex;
  }
  toJSON(t) {
    return { type: "BigNumber", hex: this.toHexString() };
  }
  static from(t) {
    if (t instanceof V)
      return t;
    if (typeof t == "string")
      return t.match(/^-?0x[0-9a-f]+$/i) ? new V(wi, vr$1(t)) : t.match(/^-?[0-9]+$/) ? new V(wi, vr$1(new Rr$2(t))) : Ae.throwArgumentError("invalid BigNumber string", "value", t);
    if (typeof t == "number")
      return t % 1 && Wt$3("underflow", "BigNumber.from", t), (t >= Qn || t <= -Qn) && Wt$3("overflow", "BigNumber.from", t), V.from(String(t));
    const r = t;
    if (typeof r == "bigint")
      return V.from(r.toString());
    if (ir$2(r))
      return V.from(Kt$2(r));
    if (r)
      if (r.toHexString) {
        const i2 = r.toHexString();
        if (typeof i2 == "string")
          return V.from(i2);
      } else {
        let i2 = r._hex;
        if (i2 == null && r.type === "BigNumber" && (i2 = r.hex), typeof i2 == "string" && (Qt$1(i2) || i2[0] === "-" && Qt$1(i2.substring(1))))
          return V.from(i2);
      }
    return Ae.throwArgumentError("invalid BigNumber value", "value", t);
  }
  static isBigNumber(t) {
    return !!(t && t._isBigNumber);
  }
};
function vr$1(e) {
  if (typeof e != "string")
    return vr$1(e.toString(16));
  if (e[0] === "-")
    return e = e.substring(1), e[0] === "-" && Ae.throwArgumentError("invalid hex", "value", e), e = vr$1(e), e === "0x00" ? e : "-" + e;
  if (e.substring(0, 2) !== "0x" && (e = "0x" + e), e === "0x")
    return "0x00";
  for (e.length % 2 && (e = "0x0" + e.substring(2)); e.length > 4 && e.substring(0, 4) === "0x00"; )
    e = "0x" + e.substring(4);
  return e;
}
function Lt$2(e) {
  return V$3.from(vr$1(e));
}
function j$2(e) {
  const t = V$3.from(e).toHexString();
  return t[0] === "-" ? new Rr$2("-" + t.substring(3), 16) : new Rr$2(t.substring(2), 16);
}
function Wt$3(e, t, r) {
  const i2 = { fault: e, operation: t };
  return r != null && (i2.value = r), Ae.throwError(e, L$3.errors.NUMERIC_FAULT, i2);
}
function R0(e) {
  return new Rr$2(e, 36).toString(16);
}
const Ht$3 = new L$3(jn), mr$2 = {}, Gn = V$3.from(0), Yn = V$3.from(-1);
function Vn(e, t, r, i2) {
  const n2 = { fault: t, operation: r };
  return i2 !== void 0 && (n2.value = i2), Ht$3.throwError(e, L$3.errors.NUMERIC_FAULT, n2);
}
let gr$2 = "0";
for (; gr$2.length < 256; )
  gr$2 += gr$2;
function xi(e) {
  if (typeof e != "number")
    try {
      e = V$3.from(e).toNumber();
    } catch {
    }
  return typeof e == "number" && e >= 0 && e <= 256 && !(e % 1) ? "1" + gr$2.substring(0, e) : Ht$3.throwArgumentError("invalid decimal size", "decimals", e);
}
function Mi(e, t) {
  t == null && (t = 0);
  const r = xi(t);
  e = V$3.from(e);
  const i2 = e.lt(Gn);
  i2 && (e = e.mul(Yn));
  let n2 = e.mod(r).toString();
  for (; n2.length < r.length - 1; )
    n2 = "0" + n2;
  n2 = n2.match(/^([0-9]*[1-9]|0)(0*)/)[1];
  const o2 = e.div(r).toString();
  return r.length === 1 ? e = o2 : e = o2 + "." + n2, i2 && (e = "-" + e), e;
}
function be$2(e, t) {
  t == null && (t = 0);
  const r = xi(t);
  (typeof e != "string" || !e.match(/^-?[0-9.]+$/)) && Ht$3.throwArgumentError("invalid decimal value", "value", e);
  const i2 = e.substring(0, 1) === "-";
  i2 && (e = e.substring(1)), e === "." && Ht$3.throwArgumentError("missing value", "value", e);
  const n2 = e.split(".");
  n2.length > 2 && Ht$3.throwArgumentError("too many decimal points", "value", e);
  let o2 = n2[0], h4 = n2[1];
  for (o2 || (o2 = "0"), h4 || (h4 = "0"); h4[h4.length - 1] === "0"; )
    h4 = h4.substring(0, h4.length - 1);
  for (h4.length > r.length - 1 && Vn("fractional component exceeds decimals", "underflow", "parseFixed"), h4 === "" && (h4 = "0"); h4.length < r.length - 1; )
    h4 += "0";
  const p3 = V$3.from(o2), b3 = V$3.from(h4);
  let m3 = p3.mul(r).add(b3);
  return i2 && (m3 = m3.mul(Yn)), m3;
}
let dr$2 = class dr {
  constructor(t, r, i2, n2) {
    t !== mr$2 && Ht$3.throwError("cannot use FixedFormat constructor; use FixedFormat.from", L$3.errors.UNSUPPORTED_OPERATION, { operation: "new FixedFormat" }), this.signed = r, this.width = i2, this.decimals = n2, this.name = (r ? "" : "u") + "fixed" + String(i2) + "x" + String(n2), this._multiplier = xi(n2), Object.freeze(this);
  }
  static from(t) {
    if (t instanceof dr)
      return t;
    typeof t == "number" && (t = `fixed128x${t}`);
    let r = true, i2 = 128, n2 = 18;
    if (typeof t == "string") {
      if (t !== "fixed")
        if (t === "ufixed")
          r = false;
        else {
          const o2 = t.match(/^(u?)fixed([0-9]+)x([0-9]+)$/);
          o2 || Ht$3.throwArgumentError("invalid fixed format", "format", t), r = o2[1] !== "u", i2 = parseInt(o2[2]), n2 = parseInt(o2[3]);
        }
    } else if (t) {
      const o2 = (h4, p3, b3) => t[h4] == null ? b3 : (typeof t[h4] !== p3 && Ht$3.throwArgumentError("invalid fixed format (" + h4 + " not " + p3 + ")", "format." + h4, t[h4]), t[h4]);
      r = o2("signed", "boolean", r), i2 = o2("width", "number", i2), n2 = o2("decimals", "number", n2);
    }
    return i2 % 8 && Ht$3.throwArgumentError("invalid fixed format width (not byte aligned)", "format.width", i2), n2 > 80 && Ht$3.throwArgumentError("invalid fixed format (decimals too large)", "format.decimals", n2), new dr(mr$2, r, i2, n2);
  }
};
let Ut$2 = class Ut {
  constructor(t, r, i2, n2) {
    t !== mr$2 && Ht$3.throwError("cannot use FixedNumber constructor; use FixedNumber.from", L$3.errors.UNSUPPORTED_OPERATION, { operation: "new FixedFormat" }), this.format = n2, this._hex = r, this._value = i2, this._isFixedNumber = true, Object.freeze(this);
  }
  _checkFormat(t) {
    this.format.name !== t.format.name && Ht$3.throwArgumentError("incompatible format; use fixedNumber.toFormat", "other", t);
  }
  addUnsafe(t) {
    this._checkFormat(t);
    const r = be$2(this._value, this.format.decimals), i2 = be$2(t._value, t.format.decimals);
    return Ut.fromValue(r.add(i2), this.format.decimals, this.format);
  }
  subUnsafe(t) {
    this._checkFormat(t);
    const r = be$2(this._value, this.format.decimals), i2 = be$2(t._value, t.format.decimals);
    return Ut.fromValue(r.sub(i2), this.format.decimals, this.format);
  }
  mulUnsafe(t) {
    this._checkFormat(t);
    const r = be$2(this._value, this.format.decimals), i2 = be$2(t._value, t.format.decimals);
    return Ut.fromValue(r.mul(i2).div(this.format._multiplier), this.format.decimals, this.format);
  }
  divUnsafe(t) {
    this._checkFormat(t);
    const r = be$2(this._value, this.format.decimals), i2 = be$2(t._value, t.format.decimals);
    return Ut.fromValue(r.mul(this.format._multiplier).div(i2), this.format.decimals, this.format);
  }
  floor() {
    const t = this.toString().split(".");
    t.length === 1 && t.push("0");
    let r = Ut.from(t[0], this.format);
    const i2 = !t[1].match(/^(0*)$/);
    return this.isNegative() && i2 && (r = r.subUnsafe(Wn.toFormat(r.format))), r;
  }
  ceiling() {
    const t = this.toString().split(".");
    t.length === 1 && t.push("0");
    let r = Ut.from(t[0], this.format);
    const i2 = !t[1].match(/^(0*)$/);
    return !this.isNegative() && i2 && (r = r.addUnsafe(Wn.toFormat(r.format))), r;
  }
  round(t) {
    t == null && (t = 0);
    const r = this.toString().split(".");
    if (r.length === 1 && r.push("0"), (t < 0 || t > 80 || t % 1) && Ht$3.throwArgumentError("invalid decimal count", "decimals", t), r[1].length <= t)
      return this;
    const i2 = Ut.from("1" + gr$2.substring(0, t), this.format), n2 = O0.toFormat(this.format);
    return this.mulUnsafe(i2).addUnsafe(n2).floor().divUnsafe(i2);
  }
  isZero() {
    return this._value === "0.0" || this._value === "0";
  }
  isNegative() {
    return this._value[0] === "-";
  }
  toString() {
    return this._value;
  }
  toHexString(t) {
    if (t == null)
      return this._hex;
    t % 8 && Ht$3.throwArgumentError("invalid byte width", "width", t);
    const r = V$3.from(this._hex).fromTwos(this.format.width).toTwos(t).toHexString();
    return oe$1(r, t / 8);
  }
  toUnsafeFloat() {
    return parseFloat(this.toString());
  }
  toFormat(t) {
    return Ut.fromString(this._value, t);
  }
  static fromValue(t, r, i2) {
    return i2 == null && r != null && !C0(r) && (i2 = r, r = null), r == null && (r = 0), i2 == null && (i2 = "fixed"), Ut.fromString(Mi(t, r), dr$2.from(i2));
  }
  static fromString(t, r) {
    r == null && (r = "fixed");
    const i2 = dr$2.from(r), n2 = be$2(t, i2.decimals);
    !i2.signed && n2.lt(Gn) && Vn("unsigned value cannot be negative", "overflow", "value", t);
    let o2 = null;
    i2.signed ? o2 = n2.toTwos(i2.width).toHexString() : (o2 = n2.toHexString(), o2 = oe$1(o2, i2.width / 8));
    const h4 = Mi(n2, i2.decimals);
    return new Ut(mr$2, o2, h4, i2);
  }
  static fromBytes(t, r) {
    r == null && (r = "fixed");
    const i2 = dr$2.from(r);
    if (Ot$2(t).length > i2.width / 8)
      throw new Error("overflow");
    let n2 = V$3.from(t);
    i2.signed && (n2 = n2.fromTwos(i2.width));
    const o2 = n2.toTwos((i2.signed ? 0 : 1) + i2.width).toHexString(), h4 = Mi(n2, i2.decimals);
    return new Ut(mr$2, o2, h4, i2);
  }
  static from(t, r) {
    if (typeof t == "string")
      return Ut.fromString(t, r);
    if (ir$2(t))
      return Ut.fromBytes(t, r);
    try {
      return Ut.fromValue(t, 0, r);
    } catch (i2) {
      if (i2.code !== L$3.errors.INVALID_ARGUMENT)
        throw i2;
    }
    return Ht$3.throwArgumentError("invalid FixedNumber value", "value", t);
  }
  static isFixedNumber(t) {
    return !!(t && t._isFixedNumber);
  }
};
const Wn = Ut$2.from(1), O0 = Ut$2.from("0.5"), P0 = "strings/5.7.0", Xn = new L$3(P0);
var Or$2;
(function(e) {
  e.current = "", e.NFC = "NFC", e.NFD = "NFD", e.NFKC = "NFKC", e.NFKD = "NFKD";
})(Or$2 || (Or$2 = {}));
var nr$2;
(function(e) {
  e.UNEXPECTED_CONTINUE = "unexpected continuation byte", e.BAD_PREFIX = "bad codepoint prefix", e.OVERRUN = "string overrun", e.MISSING_CONTINUE = "missing continuation byte", e.OUT_OF_RANGE = "out of UTF-8 range", e.UTF16_SURROGATE = "UTF-16 surrogate", e.OVERLONG = "overlong representation";
})(nr$2 || (nr$2 = {}));
function Ei(e, t = Or$2.current) {
  t != Or$2.current && (Xn.checkNormalize(), e = e.normalize(t));
  let r = [];
  for (let i2 = 0; i2 < e.length; i2++) {
    const n2 = e.charCodeAt(i2);
    if (n2 < 128)
      r.push(n2);
    else if (n2 < 2048)
      r.push(n2 >> 6 | 192), r.push(n2 & 63 | 128);
    else if ((n2 & 64512) == 55296) {
      i2++;
      const o2 = e.charCodeAt(i2);
      if (i2 >= e.length || (o2 & 64512) !== 56320)
        throw new Error("invalid utf-8 string");
      const h4 = 65536 + ((n2 & 1023) << 10) + (o2 & 1023);
      r.push(h4 >> 18 | 240), r.push(h4 >> 12 & 63 | 128), r.push(h4 >> 6 & 63 | 128), r.push(h4 & 63 | 128);
    } else
      r.push(n2 >> 12 | 224), r.push(n2 >> 6 & 63 | 128), r.push(n2 & 63 | 128);
  }
  return Ot$2(r);
}
function T0(e) {
  if (e.length % 4 !== 0)
    throw new Error("bad data");
  let t = [];
  for (let r = 0; r < e.length; r += 4)
    t.push(parseInt(e.substring(r, r + 4), 16));
  return t;
}
function Si(e, t) {
  t || (t = function(n2) {
    return [parseInt(n2, 16)];
  });
  let r = 0, i2 = {};
  return e.split(",").forEach((n2) => {
    let o2 = n2.split(":");
    r += parseInt(o2[0], 16), i2[r] = t(o2[1]);
  }), i2;
}
function $n(e) {
  let t = 0;
  return e.split(",").map((r) => {
    let i2 = r.split("-");
    i2.length === 1 ? i2[1] = "0" : i2[1] === "" && (i2[1] = "1");
    let n2 = t + parseInt(i2[0], 16);
    return t = parseInt(i2[1], 16), { l: n2, h: t };
  });
}
$n("221,13-1b,5f-,40-10,51-f,11-3,3-3,2-2,2-4,8,2,15,2d,28-8,88,48,27-,3-5,11-20,27-,8,28,3-5,12,18,b-a,1c-4,6-16,2-d,2-2,2,1b-4,17-9,8f-,10,f,1f-2,1c-34,33-14e,4,36-,13-,6-2,1a-f,4,9-,3-,17,8,2-2,5-,2,8-,3-,4-8,2-3,3,6-,16-6,2-,7-3,3-,17,8,3,3,3-,2,6-3,3-,4-a,5,2-6,10-b,4,8,2,4,17,8,3,6-,b,4,4-,2-e,2-4,b-10,4,9-,3-,17,8,3-,5-,9-2,3-,4-7,3-3,3,4-3,c-10,3,7-2,4,5-2,3,2,3-2,3-2,4-2,9,4-3,6-2,4,5-8,2-e,d-d,4,9,4,18,b,6-3,8,4,5-6,3-8,3-3,b-11,3,9,4,18,b,6-3,8,4,5-6,3-6,2,3-3,b-11,3,9,4,18,11-3,7-,4,5-8,2-7,3-3,b-11,3,13-2,19,a,2-,8-2,2-3,7,2,9-11,4-b,3b-3,1e-24,3,2-,3,2-,2-5,5,8,4,2,2-,3,e,4-,6,2,7-,b-,3-21,49,23-5,1c-3,9,25,10-,2-2f,23,6,3,8-2,5-5,1b-45,27-9,2a-,2-3,5b-4,45-4,53-5,8,40,2,5-,8,2,5-,28,2,5-,20,2,5-,8,2,5-,8,8,18,20,2,5-,8,28,14-5,1d-22,56-b,277-8,1e-2,52-e,e,8-a,18-8,15-b,e,4,3-b,5e-2,b-15,10,b-5,59-7,2b-555,9d-3,5b-5,17-,7-,27-,7-,9,2,2,2,20-,36,10,f-,7,14-,4,a,54-3,2-6,6-5,9-,1c-10,13-1d,1c-14,3c-,10-6,32-b,240-30,28-18,c-14,a0,115-,3,66-,b-76,5,5-,1d,24,2,5-2,2,8-,35-2,19,f-10,1d-3,311-37f,1b,5a-b,d7-19,d-3,41,57-,68-4,29-3,5f,29-37,2e-2,25-c,2c-2,4e-3,30,78-3,64-,20,19b7-49,51a7-59,48e-2,38-738,2ba5-5b,222f-,3c-94,8-b,6-4,1b,6,2,3,3,6d-20,16e-f,41-,37-7,2e-2,11-f,5-b,18-,b,14,5-3,6,88-,2,bf-2,7-,7-,7-,4-2,8,8-9,8-2ff,20,5-b,1c-b4,27-,27-cbb1,f7-9,28-2,b5-221,56,48,3-,2-,3-,5,d,2,5,3,42,5-,9,8,1d,5,6,2-2,8,153-3,123-3,33-27fd,a6da-5128,21f-5df,3-fffd,3-fffd,3-fffd,3-fffd,3-fffd,3-fffd,3-fffd,3-fffd,3-fffd,3-fffd,3-fffd,3,2-1d,61-ff7d"), "ad,34f,1806,180b,180c,180d,200b,200c,200d,2060,feff".split(",").map((e) => parseInt(e, 16)), Si("b5:3bc,c3:ff,7:73,2:253,5:254,3:256,1:257,5:259,1:25b,3:260,1:263,2:269,1:268,5:26f,1:272,2:275,7:280,3:283,5:288,3:28a,1:28b,5:292,3f:195,1:1bf,29:19e,125:3b9,8b:3b2,1:3b8,1:3c5,3:3c6,1:3c0,1a:3ba,1:3c1,1:3c3,2:3b8,1:3b5,1bc9:3b9,1c:1f76,1:1f77,f:1f7a,1:1f7b,d:1f78,1:1f79,1:1f7c,1:1f7d,107:63,5:25b,4:68,1:68,1:68,3:69,1:69,1:6c,3:6e,4:70,1:71,1:72,1:72,1:72,7:7a,2:3c9,2:7a,2:6b,1:e5,1:62,1:63,3:65,1:66,2:6d,b:3b3,1:3c0,6:64,1b574:3b8,1a:3c3,20:3b8,1a:3c3,20:3b8,1a:3c3,20:3b8,1a:3c3,20:3b8,1a:3c3"), Si("179:1,2:1,2:1,5:1,2:1,a:4f,a:1,8:1,2:1,2:1,3:1,5:1,3:1,4:1,2:1,3:1,4:1,8:2,1:1,2:2,1:1,2:2,27:2,195:26,2:25,1:25,1:25,2:40,2:3f,1:3f,33:1,11:-6,1:-9,1ac7:-3a,6d:-8,1:-8,1:-8,1:-8,1:-8,1:-8,1:-8,1:-8,9:-8,1:-8,1:-8,1:-8,1:-8,1:-8,b:-8,1:-8,1:-8,1:-8,1:-8,1:-8,1:-8,1:-8,9:-8,1:-8,1:-8,1:-8,1:-8,1:-8,1:-8,1:-8,9:-8,1:-8,1:-8,1:-8,1:-8,1:-8,c:-8,2:-8,2:-8,2:-8,9:-8,1:-8,1:-8,1:-8,1:-8,1:-8,1:-8,1:-8,49:-8,1:-8,1:-4a,1:-4a,d:-56,1:-56,1:-56,1:-56,d:-8,1:-8,f:-8,1:-8,3:-7"), Si("df:00730073,51:00690307,19:02BC006E,a7:006A030C,18a:002003B9,16:03B903080301,20:03C503080301,1d7:05650582,190f:00680331,1:00740308,1:0077030A,1:0079030A,1:006102BE,b6:03C50313,2:03C503130300,2:03C503130301,2:03C503130342,2a:1F0003B9,1:1F0103B9,1:1F0203B9,1:1F0303B9,1:1F0403B9,1:1F0503B9,1:1F0603B9,1:1F0703B9,1:1F0003B9,1:1F0103B9,1:1F0203B9,1:1F0303B9,1:1F0403B9,1:1F0503B9,1:1F0603B9,1:1F0703B9,1:1F2003B9,1:1F2103B9,1:1F2203B9,1:1F2303B9,1:1F2403B9,1:1F2503B9,1:1F2603B9,1:1F2703B9,1:1F2003B9,1:1F2103B9,1:1F2203B9,1:1F2303B9,1:1F2403B9,1:1F2503B9,1:1F2603B9,1:1F2703B9,1:1F6003B9,1:1F6103B9,1:1F6203B9,1:1F6303B9,1:1F6403B9,1:1F6503B9,1:1F6603B9,1:1F6703B9,1:1F6003B9,1:1F6103B9,1:1F6203B9,1:1F6303B9,1:1F6403B9,1:1F6503B9,1:1F6603B9,1:1F6703B9,3:1F7003B9,1:03B103B9,1:03AC03B9,2:03B10342,1:03B1034203B9,5:03B103B9,6:1F7403B9,1:03B703B9,1:03AE03B9,2:03B70342,1:03B7034203B9,5:03B703B9,6:03B903080300,1:03B903080301,3:03B90342,1:03B903080342,b:03C503080300,1:03C503080301,1:03C10313,2:03C50342,1:03C503080342,b:1F7C03B9,1:03C903B9,1:03CE03B9,2:03C90342,1:03C9034203B9,5:03C903B9,ac:00720073,5b:00B00063,6:00B00066,d:006E006F,a:0073006D,1:00740065006C,1:0074006D,124f:006800700061,2:00610075,2:006F0076,b:00700061,1:006E0061,1:03BC0061,1:006D0061,1:006B0061,1:006B0062,1:006D0062,1:00670062,3:00700066,1:006E0066,1:03BC0066,4:0068007A,1:006B0068007A,1:006D0068007A,1:00670068007A,1:00740068007A,15:00700061,1:006B00700061,1:006D00700061,1:006700700061,8:00700076,1:006E0076,1:03BC0076,1:006D0076,1:006B0076,1:006D0076,1:00700077,1:006E0077,1:03BC0077,1:006D0077,1:006B0077,1:006D0077,1:006B03C9,1:006D03C9,2:00620071,3:00632215006B0067,1:0063006F002E,1:00640062,1:00670079,2:00680070,2:006B006B,1:006B006D,9:00700068,2:00700070006D,1:00700072,2:00730076,1:00770062,c723:00660066,1:00660069,1:0066006C,1:006600660069,1:00660066006C,1:00730074,1:00730074,d:05740576,1:05740565,1:0574056B,1:057E0576,1:0574056D", T0), $n("80-20,2a0-,39c,32,f71,18e,7f2-f,19-7,30-4,7-5,f81-b,5,a800-20ff,4d1-1f,110,fa-6,d174-7,2e84-,ffff-,ffff-,ffff-,ffff-,ffff-,ffff-,ffff-,ffff-,ffff-,ffff-,ffff-,ffff-,2,1f-5f,ff7f-20001");
function U0(e) {
  e = atob(e);
  const t = [];
  for (let r = 0; r < e.length; r++)
    t.push(e.charCodeAt(r));
  return Ot$2(t);
}
function ef(e, t) {
  t == null && (t = 1);
  const r = [], i2 = r.forEach, n2 = function(o2, h4) {
    i2.call(o2, function(p3) {
      h4 > 0 && Array.isArray(p3) ? n2(p3, h4 - 1) : r.push(p3);
    });
  };
  return n2(e, t), r;
}
function k0(e) {
  const t = {};
  for (let r = 0; r < e.length; r++) {
    const i2 = e[r];
    t[i2[0]] = i2[1];
  }
  return t;
}
function q0(e) {
  let t = 0;
  function r() {
    return e[t++] << 8 | e[t++];
  }
  let i2 = r(), n2 = 1, o2 = [0, 1];
  for (let H2 = 1; H2 < i2; H2++)
    o2.push(n2 += r());
  let h4 = r(), p3 = t;
  t += h4;
  let b3 = 0, m3 = 0;
  function w3() {
    return b3 == 0 && (m3 = m3 << 8 | e[t++], b3 = 8), m3 >> --b3 & 1;
  }
  const y3 = 31, S3 = Math.pow(2, y3), I2 = S3 >>> 1, N2 = I2 >> 1, C2 = S3 - 1;
  let F2 = 0;
  for (let H2 = 0; H2 < y3; H2++)
    F2 = F2 << 1 | w3();
  let U2 = [], J2 = 0, Bt2 = S3;
  for (; ; ) {
    let H2 = Math.floor(((F2 - J2 + 1) * n2 - 1) / Bt2), z2 = 0, Pt2 = i2;
    for (; Pt2 - z2 > 1; ) {
      let Yt3 = z2 + Pt2 >>> 1;
      H2 < o2[Yt3] ? Pt2 = Yt3 : z2 = Yt3;
    }
    if (z2 == 0)
      break;
    U2.push(z2);
    let W2 = J2 + Math.floor(Bt2 * o2[z2] / n2), Rt2 = J2 + Math.floor(Bt2 * o2[z2 + 1] / n2) - 1;
    for (; !((W2 ^ Rt2) & I2); )
      F2 = F2 << 1 & C2 | w3(), W2 = W2 << 1 & C2, Rt2 = Rt2 << 1 & C2 | 1;
    for (; W2 & ~Rt2 & N2; )
      F2 = F2 & I2 | F2 << 1 & C2 >>> 1 | w3(), W2 = W2 << 1 ^ I2, Rt2 = (Rt2 ^ I2) << 1 | I2 | 1;
    J2 = W2, Bt2 = 1 + Rt2 - W2;
  }
  let G2 = i2 - 4;
  return U2.map((H2) => {
    switch (H2 - G2) {
      case 3:
        return G2 + 65792 + (e[p3++] << 16 | e[p3++] << 8 | e[p3++]);
      case 2:
        return G2 + 256 + (e[p3++] << 8 | e[p3++]);
      case 1:
        return G2 + e[p3++];
      default:
        return H2 - 1;
    }
  });
}
function K0(e) {
  let t = 0;
  return () => e[t++];
}
function H0(e) {
  return K0(q0(e));
}
function z0(e) {
  return e & 1 ? ~e >> 1 : e >> 1;
}
function L0(e, t) {
  let r = Array(e);
  for (let i2 = 0; i2 < e; i2++)
    r[i2] = 1 + t();
  return r;
}
function rf(e, t) {
  let r = Array(e);
  for (let i2 = 0, n2 = -1; i2 < e; i2++)
    r[i2] = n2 += 1 + t();
  return r;
}
function j0(e, t) {
  let r = Array(e);
  for (let i2 = 0, n2 = 0; i2 < e; i2++)
    r[i2] = n2 += z0(t());
  return r;
}
function Pr$2(e, t) {
  let r = rf(e(), e), i2 = e(), n2 = rf(i2, e), o2 = L0(i2, e);
  for (let h4 = 0; h4 < i2; h4++)
    for (let p3 = 0; p3 < o2[h4]; p3++)
      r.push(n2[h4] + p3);
  return t ? r.map((h4) => t[h4]) : r;
}
function Q0(e) {
  let t = [];
  for (; ; ) {
    let r = e();
    if (r == 0)
      break;
    t.push(G0(r, e));
  }
  for (; ; ) {
    let r = e() - 1;
    if (r < 0)
      break;
    t.push(Y0(r, e));
  }
  return k0(ef(t));
}
function J0(e) {
  let t = [];
  for (; ; ) {
    let r = e();
    if (r == 0)
      break;
    t.push(r);
  }
  return t;
}
function nf(e, t, r) {
  let i2 = Array(e).fill(void 0).map(() => []);
  for (let n2 = 0; n2 < t; n2++)
    j0(e, r).forEach((o2, h4) => i2[h4].push(o2));
  return i2;
}
function G0(e, t) {
  let r = 1 + t(), i2 = t(), n2 = J0(t), o2 = nf(n2.length, 1 + e, t);
  return ef(o2.map((h4, p3) => {
    const b3 = h4[0], m3 = h4.slice(1);
    return Array(n2[p3]).fill(void 0).map((w3, y3) => {
      let S3 = y3 * i2;
      return [b3 + y3 * r, m3.map((I2) => I2 + S3)];
    });
  }));
}
function Y0(e, t) {
  let r = 1 + t();
  return nf(r, 1 + e, t).map((n2) => [n2[0], n2.slice(1)]);
}
function V0(e) {
  let t = Pr$2(e).sort((i2, n2) => i2 - n2);
  return r();
  function r() {
    let i2 = [];
    for (; ; ) {
      let m3 = Pr$2(e, t);
      if (m3.length == 0)
        break;
      i2.push({ set: new Set(m3), node: r() });
    }
    i2.sort((m3, w3) => w3.set.size - m3.set.size);
    let n2 = e(), o2 = n2 % 3;
    n2 = n2 / 3 | 0;
    let h4 = !!(n2 & 1);
    n2 >>= 1;
    let p3 = n2 == 1, b3 = n2 == 2;
    return { branches: i2, valid: o2, fe0f: h4, save: p3, check: b3 };
  }
}
function W0() {
  return H0(U0("AEQF2AO2DEsA2wIrAGsBRABxAN8AZwCcAEwAqgA0AGwAUgByADcATAAVAFYAIQAyACEAKAAYAFgAGwAjABQAMAAmADIAFAAfABQAKwATACoADgAbAA8AHQAYABoAGQAxADgALAAoADwAEwA9ABMAGgARAA4ADwAWABMAFgAIAA8AHgQXBYMA5BHJAS8JtAYoAe4AExozi0UAH21tAaMnBT8CrnIyhrMDhRgDygIBUAEHcoFHUPe8AXBjAewCjgDQR8IICIcEcQLwATXCDgzvHwBmBoHNAqsBdBcUAykgDhAMShskMgo8AY8jqAQfAUAfHw8BDw87MioGlCIPBwZCa4ELatMAAMspJVgsDl8AIhckSg8XAHdvTwBcIQEiDT4OPhUqbyECAEoAS34Aej8Ybx83JgT/Xw8gHxZ/7w8RICxPHA9vBw+Pfw8PHwAPFv+fAsAvCc8vEr8ivwD/EQ8Bol8OEBa/A78hrwAPCU8vESNvvwWfHwNfAVoDHr+ZAAED34YaAdJPAK7PLwSEgDLHAGo1Pz8Pvx9fUwMrpb8O/58VTzAPIBoXIyQJNF8hpwIVAT8YGAUADDNBaX3RAMomJCg9EhUeA29MABsZBTMNJipjOhc19gcIDR8bBwQHEggCWi6DIgLuAQYA+BAFCha3A5XiAEsqM7UFFgFLhAMjFTMYE1Klnw74nRVBG/ASCm0BYRN/BrsU3VoWy+S0vV8LQx+vN8gF2AC2AK5EAWwApgYDKmAAroQ0NDQ0AT+OCg7wAAIHRAbpNgVcBV0APTA5BfbPFgMLzcYL/QqqA82eBALKCjQCjqYCht0/k2+OAsXQAoP3ASTKDgDw6ACKAUYCMpIKJpRaAE4A5womABzZvs0REEKiACIQAd5QdAECAj4Ywg/wGqY2AVgAYADYvAoCGAEubA0gvAY2ALAAbpbvqpyEAGAEpgQAJgAG7gAgAEACmghUFwCqAMpAINQIwC4DthRAAPcycKgApoIdABwBfCisABoATwBqASIAvhnSBP8aH/ECeAKXAq40NjgDBTwFYQU6AXs3oABgAD4XNgmcCY1eCl5tIFZeUqGgyoNHABgAEQAaABNwWQAmABMATPMa3T34ADldyprmM1M2XociUQgLzvwAXT3xABgAEQAaABNwIGFAnADD8AAgAD4BBJWzaCcIAIEBFMAWwKoAAdq9BWAF5wLQpALEtQAKUSGkahR4GnJM+gsAwCgeFAiUAECQ0BQuL8AAIAAAADKeIheclvFqQAAETr4iAMxIARMgAMIoHhQIAn0E0pDQFC4HhznoAAAAIAI2C0/4lvFqQAAETgBJJwYCAy4ABgYAFAA8MBKYEH4eRhTkAjYeFcgACAYAeABsOqyQ5gRwDayqugEgaIIAtgoACgDmEABmBAWGme5OBJJA2m4cDeoAmITWAXwrMgOgAGwBCh6CBXYF1Tzg1wKAAFdiuABRAFwAXQBsAG8AdgBrAHYAbwCEAHEwfxQBVE5TEQADVFhTBwBDANILAqcCzgLTApQCrQL6vAAMAL8APLhNBKkE6glGKTAU4Dr4N2EYEwBCkABKk8rHAbYBmwIoAiU4Ajf/Aq4CowCAANIChzgaNBsCsTgeODcFXrgClQKdAqQBiQGYAqsCsjTsNHsfNPA0ixsAWTWiOAMFPDQSNCk2BDZHNow2TTZUNhk28Jk9VzI3QkEoAoICoQKwAqcAQAAxBV4FXbS9BW47YkIXP1ciUqs05DS/FwABUwJW11e6nHuYZmSh/RAYA8oMKvZ8KASoUAJYWAJ6ILAsAZSoqjpgA0ocBIhmDgDWAAawRDQoAAcuAj5iAHABZiR2AIgiHgCaAU68ACxuHAG0ygM8MiZIAlgBdF4GagJqAPZOHAMuBgoATkYAsABiAHgAMLoGDPj0HpKEBAAOJgAuALggTAHWAeAMEDbd20Uege0ADwAWADkAQgA9OHd+2MUQZBBhBgNNDkxxPxUQArEPqwvqERoM1irQ090ANK4H8ANYB/ADWANYB/AH8ANYB/ADWANYA1gDWBwP8B/YxRBkD00EcgWTBZAE2wiIJk4RhgctCNdUEnQjHEwDSgEBIypJITuYMxAlR0wRTQgIATZHbKx9PQNMMbBU+pCnA9AyVDlxBgMedhKlAC8PeCE1uk6DekxxpQpQT7NX9wBFBgASqwAS5gBJDSgAUCwGPQBI4zTYABNGAE2bAE3KAExdGABKaAbgAFBXAFCOAFBJABI2SWdObALDOq0//QomCZhvwHdTBkIQHCemEPgMNAG2ATwN7kvZBPIGPATKH34ZGg/OlZ0Ipi3eDO4m5C6igFsj9iqEBe5L9TzeC05RaQ9aC2YJ5DpkgU8DIgEOIowK3g06CG4Q9ArKbA3mEUYHOgPWSZsApgcCCxIdNhW2JhFirQsKOXgG/Br3C5AmsBMqev0F1BoiBk4BKhsAANAu6IWxWjJcHU9gBgQLJiPIFKlQIQ0mQLh4SRocBxYlqgKSQ3FKiFE3HpQh9zw+DWcuFFF9B/Y8BhlQC4I8n0asRQ8R0z6OPUkiSkwtBDaALDAnjAnQD4YMunxzAVoJIgmyDHITMhEYN8YIOgcaLpclJxYIIkaWYJsE+KAD9BPSAwwFQAlCBxQDthwuEy8VKgUOgSXYAvQ21i60ApBWgQEYBcwPJh/gEFFH4Q7qCJwCZgOEJewALhUiABginAhEZABgj9lTBi7MCMhqbSN1A2gU6GIRdAeSDlgHqBw0FcAc4nDJXgyGCSiksAlcAXYJmgFgBOQICjVcjKEgQmdUi1kYnCBiQUBd/QIyDGYVoES+h3kCjA9sEhwBNgF0BzoNAgJ4Ee4RbBCWCOyGBTW2M/k6JgRQIYQgEgooA1BszwsoJvoM+WoBpBJjAw00PnfvZ6xgtyUX/gcaMsZBYSHyC5NPzgydGsIYQ1QvGeUHwAP0GvQn60FYBgADpAQUOk4z7wS+C2oIjAlAAEoOpBgH2BhrCnKM0QEyjAG4mgNYkoQCcJAGOAcMAGgMiAV65gAeAqgIpAAGANADWAA6Aq4HngAaAIZCAT4DKDABIuYCkAOUCDLMAZYwAfQqBBzEDBYA+DhuSwLDsgKAa2ajBd5ZAo8CSjYBTiYEBk9IUgOwcuIA3ABMBhTgSAEWrEvMG+REAeBwLADIAPwABjYHBkIBzgH0bgC4AWALMgmjtLYBTuoqAIQAFmwB2AKKAN4ANgCA8gFUAE4FWvoF1AJQSgESMhksWGIBvAMgATQBDgB6BsyOpsoIIARuB9QCEBwV4gLvLwe2AgMi4BPOQsYCvd9WADIXUu5eZwqoCqdeaAC0YTQHMnM9UQAPH6k+yAdy/BZIiQImSwBQ5gBQQzSaNTFWSTYBpwGqKQK38AFtqwBI/wK37gK3rQK3sAK6280C0gK33AK3zxAAUEIAUD9SklKDArekArw5AEQAzAHCO147WTteO1k7XjtZO147WTteO1kDmChYI03AVU0oJqkKbV9GYewMpw3VRMk6ShPcYFJgMxPJLbgUwhXPJVcZPhq9JwYl5VUKDwUt1GYxCC00dhe9AEApaYNCY4ceMQpMHOhTklT5LRwAskujM7ANrRsWREEFSHXuYisWDwojAmSCAmJDXE6wXDchAqH4AmiZAmYKAp+FOBwMAmY8AmYnBG8EgAN/FAN+kzkHOXgYOYM6JCQCbB4CMjc4CwJtyAJtr/CLADRoRiwBaADfAOIASwYHmQyOAP8MwwAOtgJ3MAJ2o0ACeUxEAni7Hl3cRa9G9AJ8QAJ6yQJ9CgJ88UgBSH5kJQAsFklZSlwWGErNAtECAtDNSygDiFADh+dExpEzAvKiXQQDA69Lz0wuJgTQTU1NsAKLQAKK2cIcCB5EaAa4Ao44Ao5dQZiCAo7aAo5deVG1UzYLUtVUhgKT/AKTDQDqAB1VH1WwVdEHLBwplocy4nhnRTw6ApegAu+zWCKpAFomApaQApZ9nQCqWa1aCoJOADwClrYClk9cRVzSApnMApllXMtdCBoCnJw5wzqeApwXAp+cAp65iwAeEDIrEAKd8gKekwC2PmE1YfACntQCoG8BqgKeoCACnk+mY8lkKCYsAiewAiZ/AqD8AqBN2AKmMAKlzwKoAAB+AqfzaH1osgAESmodatICrOQCrK8CrWgCrQMCVx4CVd0CseLYAx9PbJgCsr4OArLpGGzhbWRtSWADJc4Ctl08QG6RAylGArhfArlIFgK5K3hwN3DiAr0aAy2zAzISAr6JcgMDM3ICvhtzI3NQAsPMAsMFc4N0TDZGdOEDPKgDPJsDPcACxX0CxkgCxhGKAshqUgLIRQLJUALJLwJkngLd03h6YniveSZL0QMYpGcDAmH1GfSVJXsMXpNevBICz2wCz20wTFTT9BSgAMeuAs90ASrrA04TfkwGAtwoAtuLAtJQA1JdA1NgAQIDVY2AikABzBfuYUZ2AILPg44C2sgC2d+EEYRKpz0DhqYAMANkD4ZyWvoAVgLfZgLeuXR4AuIw7RUB8zEoAfScAfLTiALr9ALpcXoAAur6AurlAPpIAboC7ooC652Wq5cEAu5AA4XhmHpw4XGiAvMEAGoDjheZlAL3FAORbwOSiAL3mQL52gL4Z5odmqy8OJsfA52EAv77ARwAOp8dn7QDBY4DpmsDptoA0sYDBmuhiaIGCgMMSgFgASACtgNGAJwEgLpoBgC8BGzAEowcggCEDC6kdjoAJAM0C5IKRoABZCgiAIzw3AYBLACkfng9ogigkgNmWAN6AEQCvrkEVqTGAwCsBRbAA+4iQkMCHR072jI2PTbUNsk2RjY5NvA23TZKNiU3EDcZN5I+RTxDRTBCJkK5VBYKFhZfwQCWygU3AJBRHpu+OytgNxa61A40GMsYjsn7BVwFXQVcBV0FaAVdBVwFXQVcBV0FXAVdBVwFXUsaCNyKAK4AAQUHBwKU7oICoW1e7jAEzgPxA+YDwgCkBFDAwADABKzAAOxFLhitA1UFTDeyPkM+bj51QkRCuwTQWWQ8X+0AWBYzsACNA8xwzAGm7EZ/QisoCTAbLDs6fnLfb8H2GccsbgFw13M1HAVkBW/Jxsm9CNRO8E8FDD0FBQw9FkcClOYCoMFegpDfADgcMiA2AJQACB8AsigKAIzIEAJKeBIApY5yPZQIAKQiHb4fvj5BKSRPQrZCOz0oXyxgOywfKAnGbgMClQaCAkILXgdeCD9IIGUgQj5fPoY+dT52Ao5CM0dAX9BTVG9SDzFwWTQAbxBzJF/lOEIQQglCCkKJIAls5AcClQICoKPMODEFxhi6KSAbiyfIRrMjtCgdWCAkPlFBIitCsEJRzAbMAV/OEyQzDg0OAQQEJ36i328/Mk9AybDJsQlq3tDRApUKAkFzXf1d/j9uALYP6hCoFgCTGD8kPsFKQiobrm0+zj0KSD8kPnVCRBwMDyJRTHFgMTJa5rwXQiQ2YfI/JD7BMEJEHGINTw4TOFlIRzwJO0icMQpyPyQ+wzJCRBv6DVgnKB01NgUKj2bwYzMqCoBkznBgEF+zYDIocwRIX+NgHj4HICNfh2C4CwdwFWpTG/lgUhYGAwRfv2Ts8mAaXzVgml/XYIJfuWC4HI1gUF9pYJZgMR6ilQHMAOwLAlDRefC0in4AXAEJA6PjCwc0IamOANMMCAECRQDFNRTZBgd+CwQlRA+r6+gLBDEFBnwUBXgKATIArwAGRAAHA3cDdAN2A3kDdwN9A3oDdQN7A30DfAN4A3oDfQAYEAAlAtYASwMAUAFsAHcKAHcAmgB3AHUAdQB2AHVu8UgAygDAAHcAdQB1AHYAdQALCgB3AAsAmgB3AAsCOwB3AAtu8UgAygDAAHgKAJoAdwB3AHUAdQB2AHUAeAB1AHUAdgB1bvFIAMoAwAALCgCaAHcACwB3AAsCOwB3AAtu8UgAygDAAH4ACwGgALcBpwC6AahdAu0COwLtbvFIAMoAwAALCgCaAu0ACwLtAAsCOwLtAAtu8UgAygDAA24ACwNvAAu0VsQAAzsAABCkjUIpAAsAUIusOggWcgMeBxVsGwL67U/2HlzmWOEeOgALASvuAAseAfpKUpnpGgYJDCIZM6YyARUE9ThqAD5iXQgnAJYJPnOzw0ZAEZxEKsIAkA4DhAHnTAIDxxUDK0lxCQlPYgIvIQVYJQBVqE1GakUAKGYiDToSBA1EtAYAXQJYAIF8GgMHRyAAIAjOe9YncekRAA0KACUrjwE7Ayc6AAYWAqaiKG4McEcqANoN3+Mg9TwCBhIkuCny+JwUQ29L008JluRxu3K+oAdqiHOqFH0AG5SUIfUJ5SxCGfxdipRzqTmT4V5Zb+r1Uo4Vm+NqSSEl2mNvR2JhIa8SpYO6ntdwFXHCWTCK8f2+Hxo7uiG3drDycAuKIMP5bhi06ACnqArH1rz4Rqg//lm6SgJGEVbF9xJHISaR6HxqxSnkw6shDnelHKNEfGUXSJRJ1GcsmtJw25xrZMDK9gXSm1/YMkdX4/6NKYOdtk/NQ3/NnDASjTc3fPjIjW/5sVfVObX2oTDWkr1dF9f3kxBsD3/3aQO8hPfRz+e0uEiJqt1161griu7gz8hDDwtpy+F+BWtefnKHZPAxcZoWbnznhJpy0e842j36bcNzGnIEusgGX0a8ZxsnjcSsPDZ09yZ36fCQbriHeQ72JRMILNl6ePPf2HWoVwgWAm1fb3V2sAY0+B6rAXqSwPBgseVmoqsBTSrm91+XasMYYySI8eeRxH3ZvHkMz3BQ5aJ3iUVbYPNM3/7emRtjlsMgv/9VyTsyt/mK+8fgWeT6SoFaclXqn42dAIsvAarF5vNNWHzKSkKQ/8Hfk5ZWK7r9yliOsooyBjRhfkHP4Q2DkWXQi6FG/9r/IwbmkV5T7JSopHKn1pJwm9tb5Ot0oyN1Z2mPpKXHTxx2nlK08fKk1hEYA8WgVVWL5lgx0iTv+KdojJeU23ZDjmiubXOxVXJKKi2Wjuh2HLZOFLiSC7Tls5SMh4f+Pj6xUSrNjFqLGehRNB8lC0QSLNmkJJx/wSG3MnjE9T1CkPwJI0wH2lfzwETIiVqUxg0dfu5q39Gt+hwdcxkhhNvQ4TyrBceof3Mhs/IxFci1HmHr4FMZgXEEczPiGCx0HRwzAqDq2j9AVm1kwN0mRVLWLylgtoPNapF5cY4Y1wJh/e0BBwZj44YgZrDNqvD/9Hv7GFYdUQeDJuQ3EWI4HaKqavU1XjC/n41kT4L79kqGq0kLhdTZvgP3TA3fS0ozVz+5piZsoOtIvBUFoMKbNcmBL6YxxaUAusHB38XrS8dQMnQwJfUUkpRoGr5AUeWicvBTzyK9g77+yCkf5PAysL7r/JjcZgrbvRpMW9iyaxZvKO6ceZN2EwIxKwVFPuvFuiEPGCoagbMo+SpydLrXqBzNCDGFCrO/rkcwa2xhokQZ5CdZ0AsU3JfSqJ6n5I14YA+P/uAgfhPU84Tlw7cEFfp7AEE8ey4sP12PTt4Cods1GRgDOB5xvyiR5m+Bx8O5nBCNctU8BevfV5A08x6RHd5jcwPTMDSZJOedIZ1cGQ704lxbAzqZOP05ZxaOghzSdvFBHYqomATARyAADK4elP8Ly3IrUZKfWh23Xy20uBUmLS4Pfagu9+oyVa2iPgqRP3F2CTUsvJ7+RYnN8fFZbU/HVvxvcFFDKkiTqV5UBZ3Gz54JAKByi9hkKMZJvuGgcSYXFmw08UyoQyVdfTD1/dMkCHXcTGAKeROgArsvmRrQTLUOXioOHGK2QkjHuoYFgXciZoTJd6Fs5q1QX1G+p/e26hYsEf7QZD1nnIyl/SFkNtYYmmBhpBrxl9WbY0YpHWRuw2Ll/tj9mD8P4snVzJl4F9J+1arVeTb9E5r2ILH04qStjxQNwn3m4YNqxmaNbLAqW2TN6LidwuJRqS+NXbtqxoeDXpxeGWmxzSkWxjkyCkX4NQRme6q5SAcC+M7+9ETfA/EwrzQajKakCwYyeunP6ZFlxU2oMEn1Pz31zeStW74G406ZJFCl1wAXIoUKkWotYEpOuXB1uVNxJ63dpJEqfxBeptwIHNrPz8BllZoIcBoXwgfJ+8VAUnVPvRvexnw0Ma/WiGYuJO5y8QTvEYBigFmhUxY5RqzE8OcywN/8m4UYrlaniJO75XQ6KSo9+tWHlu+hMi0UVdiKQp7NelnoZUzNaIyBPVeOwK6GNp+FfHuPOoyhaWuNvTYFkvxscMQWDh+zeFCFkgwbXftiV23ywJ4+uwRqmg9k3KzwIQpzppt8DBBOMbrqwQM5Gb05sEwdKzMiAqOloaA/lr0KA+1pr0/+HiWoiIjHA/wir2nIuS3PeU/ji3O6ZwoxcR1SZ9FhtLC5S0FIzFhbBWcGVP/KpxOPSiUoAdWUpqKH++6Scz507iCcxYI6rdMBICPJZea7OcmeFw5mObJSiqpjg2UoWNIs+cFhyDSt6geV5qgi3FunmwwDoGSMgerFOZGX1m0dMCYo5XOruxO063dwENK9DbnVM9wYFREzh4vyU1WYYJ/LRRp6oxgjqP/X5a8/4Af6p6NWkQferzBmXme0zY/4nwMJm/wd1tIqSwGz+E3xPEAOoZlJit3XddD7/BT1pllzOx+8bmQtANQ/S6fZexc6qi3W+Q2xcmXTUhuS5mpHQRvcxZUN0S5+PL9lXWUAaRZhEH8hTdAcuNMMCuVNKTEGtSUKNi3O6KhSaTzck8csZ2vWRZ+d7mW8c4IKwXIYd25S/zIftPkwPzufjEvOHWVD1m+FjpDVUTV0DGDuHj6QnaEwLu/dEgdLQOg9E1Sro9XHJ8ykLAwtPu+pxqKDuFexqON1sKQm7rwbE1E68UCfA/erovrTCG+DBSNg0l4goDQvZN6uNlbyLpcZAwj2UclycvLpIZMgv4yRlpb3YuMftozorbcGVHt/VeDV3+Fdf1TP0iuaCsPi2G4XeGhsyF1ubVDxkoJhmniQ0/jSg/eYML9KLfnCFgISWkp91eauR3IQvED0nAPXK+6hPCYs+n3+hCZbiskmVMG2da+0EsZPonUeIY8EbfusQXjsK/eFDaosbPjEfQS0RKG7yj5GG69M7MeO1HmiUYocgygJHL6M1qzUDDwUSmr99V7Sdr2F3JjQAJY+F0yH33Iv3+C9M38eML7gTgmNu/r2bUMiPvpYbZ6v1/IaESirBHNa7mPKn4dEmYg7v/+HQgPN1G79jBQ1+soydfDC2r+h2Bl/KIc5KjMK7OH6nb1jLsNf0EHVe2KBiE51ox636uyG6Lho0t3J34L5QY/ilE3mikaF4HKXG1mG1rCevT1Vv6GavltxoQe/bMrpZvRggnBxSEPEeEzkEdOxTnPXHVjUYdw8JYvjB/o7Eegc3Ma+NUxLLnsK0kJlinPmUHzHGtrk5+CAbVzFOBqpyy3QVUnzTDfC/0XD94/okH+OB+i7g9lolhWIjSnfIb+Eq43ZXOWmwvjyV/qqD+t0e+7mTEM74qP/Ozt8nmC7mRpyu63OB4KnUzFc074SqoyPUAgM+/TJGFo6T44EHnQU4X4z6qannVqgw/U7zCpwcmXV1AubIrvOmkKHazJAR55ePjp5tLBsN8vAqs3NAHdcEHOR2xQ0lsNAFzSUuxFQCFYvXLZJdOj9p4fNq6p0HBGUik2YzaI4xySy91KzhQ0+q1hjxvImRwPRf76tChlRkhRCi74NXZ9qUNeIwP+s5p+3m5nwPdNOHgSLD79n7O9m1n1uDHiMntq4nkYwV5OZ1ENbXxFd4PgrlvavZsyUO4MqYlqqn1O8W/I1dEZq5dXhrbETLaZIbC2Kj/Aa/QM+fqUOHdf0tXAQ1huZ3cmWECWSXy/43j35+Mvq9xws7JKseriZ1pEWKc8qlzNrGPUGcVgOa9cPJYIJsGnJTAUsEcDOEVULO5x0rXBijc1lgXEzQQKhROf8zIV82w8eswc78YX11KYLWQRcgHNJElBxfXr72lS2RBSl07qTKorO2uUDZr3sFhYsvnhLZn0A94KRzJ/7DEGIAhW5ZWFpL8gEwu1aLA9MuWZzNwl8Oze9Y+bX+v9gywRVnoB5I/8kXTXU3141yRLYrIOOz6SOnyHNy4SieqzkBXharjfjqq1q6tklaEbA8Qfm2DaIPs7OTq/nvJBjKfO2H9bH2cCMh1+5gspfycu8f/cuuRmtDjyqZ7uCIMyjdV3a+p3fqmXsRx4C8lujezIFHnQiVTXLXuI1XrwN3+siYYj2HHTvESUx8DlOTXpak9qFRK+L3mgJ1WsD7F4cu1aJoFoYQnu+wGDMOjJM3kiBQWHCcvhJ/HRdxodOQp45YZaOTA22Nb4XKCVxqkbwMYFhzYQYIAnCW8FW14uf98jhUG2zrKhQQ0q0CEq0t5nXyvUyvR8DvD69LU+g3i+HFWQMQ8PqZuHD+sNKAV0+M6EJC0szq7rEr7B5bQ8BcNHzvDMc9eqB5ZCQdTf80Obn4uzjwpYU7SISdtV0QGa9D3Wrh2BDQtpBKxaNFV+/Cy2P/Sv+8s7Ud0Fd74X4+o/TNztWgETUapy+majNQ68Lq3ee0ZO48VEbTZYiH1Co4OlfWef82RWeyUXo7woM03PyapGfikTnQinoNq5z5veLpeMV3HCAMTaZmA1oGLAn7XS3XYsz+XK7VMQsc4XKrmDXOLU/pSXVNUq8dIqTba///3x6LiLS6xs1xuCAYSfcQ3+rQgmu7uvf3THKt5Ooo97TqcbRqxx7EASizaQCBQllG/rYxVapMLgtLbZS64w1MDBMXX+PQpBKNwqUKOf2DDRDUXQf9EhOS0Qj4nTmlA8dzSLz/G1d+Ud8MTy/6ghhdiLpeerGY/UlDOfiuqFsMUU5/UYlP+BAmgRLuNpvrUaLlVkrqDievNVEAwF+4CoM1MZTmjxjJMsKJq+u8Zd7tNCUFy6LiyYXRJQ4VyvEQFFaCGKsxIwQkk7EzZ6LTJq2hUuPhvAW+gQnSG6J+MszC+7QCRHcnqDdyNRJ6T9xyS87A6MDutbzKGvGktpbXqtzWtXb9HsfK2cBMomjN9a4y+TaJLnXxAeX/HWzmf4cR4vALt/P4w4qgKY04ml4ZdLOinFYS6cup3G/1ie4+t1eOnpBNlqGqs75ilzkT4+DsZQxNvaSKJ//6zIbbk/M7LOhFmRc/1R+kBtz7JFGdZm/COotIdvQoXpTqP/1uqEUmCb/QWoGLMwO5ANcHzxdY48IGP5+J+zKOTBFZ4Pid+GTM+Wq12MV/H86xEJptBa6T+p3kgpwLedManBHC2GgNrFpoN2xnrMz9WFWX/8/ygSBkavq2Uv7FdCsLEYLu9LLIvAU0bNRDtzYl+/vXmjpIvuJFYjmI0im6QEYqnIeMsNjXG4vIutIGHijeAG/9EDBozKV5cldkHbLxHh25vT+ZEzbhXlqvpzKJwcEgfNwLAKFeo0/pvEE10XDB+EXRTXtSzJozQKFFAJhMxYkVaCW+E9AL7tMeU8acxidHqzb6lX4691UsDpy/LLRmT+epgW56+5Cw8tB4kMUv6s9lh3eRKbyGs+H/4mQMaYzPTf2OOdokEn+zzgvoD3FqNKk8QqGAXVsqcGdXrT62fSPkR2vROFi68A6se86UxRUk4cajfPyCC4G5wDhD+zNq4jodQ4u4n/m37Lr36n4LIAAsVr02dFi9AiwA81MYs2rm4eDlDNmdMRvEKRHfBwW5DdMNp0jPFZMeARqF/wL4XBfd+EMLBfMzpH5GH6NaW+1vrvMdg+VxDzatk3MXgO3ro3P/DpcC6+Mo4MySJhKJhSR01SGGGp5hPWmrrUgrv3lDnP+HhcI3nt3YqBoVAVTBAQT5iuhTg8nvPtd8ZeYj6w1x6RqGUBrSku7+N1+BaasZvjTk64RoIDlL8brpEcJx3OmY7jLoZsswdtmhfC/G21llXhITOwmvRDDeTTPbyASOa16cF5/A1fZAidJpqju3wYAy9avPR1ya6eNp9K8XYrrtuxlqi+bDKwlfrYdR0RRiKRVTLOH85+ZY7XSmzRpfZBJjaTa81VDcJHpZnZnSQLASGYW9l51ZV/h7eVzTi3Hv6hUsgc/51AqJRTkpbFVLXXszoBL8nBX0u/0jBLT8nH+fJePbrwURT58OY+UieRjd1vs04w0VG5VN2U6MoGZkQzKN/ptz0Q366dxoTGmj7i1NQGHi9GgnquXFYdrCfZBmeb7s0T6yrdlZH5cZuwHFyIJ/kAtGsTg0xH5taAAq44BAk1CPk9KVVbqQzrCUiFdF/6gtlPQ8bHHc1G1W92MXGZ5HEHftyLYs8mbD/9xYRUWkHmlM0zC2ilJlnNgV4bfALpQghxOUoZL7VTqtCHIaQSXm+YUMnpkXybnV+A6xlm2CVy8fn0Xlm2XRa0+zzOa21JWWmixfiPMSCZ7qA4rS93VN3pkpF1s5TonQjisHf7iU9ZGvUPOAKZcR1pbeVf/Ul7OhepGCaId9wOtqo7pJ7yLcBZ0pFkOF28y4zEI/kcUNmutBHaQpBdNM8vjCS6HZRokkeo88TBAjGyG7SR+6vUgTcyK9Imalj0kuxz0wmK+byQU11AiJFk/ya5dNduRClcnU64yGu/ieWSeOos1t3ep+RPIWQ2pyTYVbZltTbsb7NiwSi3AV+8KLWk7LxCnfZUetEM8ThnsSoGH38/nyAwFguJp8FjvlHtcWZuU4hPva0rHfr0UhOOJ/F6vS62FW7KzkmRll2HEc7oUq4fyi5T70Vl7YVIfsPHUCdHesf9Lk7WNVWO75JDkYbMI8TOW8JKVtLY9d6UJRITO8oKo0xS+o99Yy04iniGHAaGj88kEWgwv0OrHdY/nr76DOGNS59hXCGXzTKUvDl9iKpLSWYN1lxIeyywdNpTkhay74w2jFT6NS8qkjo5CxA1yfSYwp6AJIZNKIeEK5PJAW7ORgWgwp0VgzYpqovMrWxbu+DGZ6Lhie1RAqpzm8VUzKJOH3mCzWuTOLsN3VT/dv2eeYe9UjbR8YTBsLz7q60VN1sU51k+um1f8JxD5pPhbhSC8rRaB454tmh6YUWrJI3+GWY0qeWioj/tbkYITOkJaeuGt4JrJvHA+l0Gu7kY7XOaa05alMnRWVCXqFgLIwSY4uF59Ue5SU4QKuc/HamDxbr0x6csCetXGoP7Qn1Bk/J9DsynO/UD6iZ1Hyrz+jit0hDCwi/E9OjgKTbB3ZQKQ/0ZOvevfNHG0NK4Aj3Cp7NpRk07RT1i/S0EL93Ag8GRgKI9CfpajKyK6+Jj/PI1KO5/85VAwz2AwzP8FTBb075IxCXv6T9RVvWT2tUaqxDS92zrGUbWzUYk9mSs82pECH+fkqsDt93VW++4YsR/dHCYcQSYTO/KaBMDj9LSD/J/+z20Kq8XvZUAIHtm9hRPP3ItbuAu2Hm5lkPs92pd7kCxgRs0xOVBnZ13ccdA0aunrwv9SdqElJRC3g+oCu+nXyCgmXUs9yMjTMAIHfxZV+aPKcZeUBWt057Xo85Ks1Ir5gzEHCWqZEhrLZMuF11ziGtFQUds/EESajhagzcKsxamcSZxGth4UII+adPhQkUnx2WyN+4YWR+r3f8MnkyGFuR4zjzxJS8WsQYR5PTyRaD9ixa6Mh741nBHbzfjXHskGDq179xaRNrCIB1z1xRfWfjqw2pHc1zk9xlPpL8sQWAIuETZZhbnmL54rceXVNRvUiKrrqIkeogsl0XXb17ylNb0f4GA9Wd44vffEG8FSZGHEL2fbaTGRcSiCeA8PmA/f6Hz8HCS76fXUHwgwkzSwlI71ekZ7Fapmlk/KC+Hs8hUcw3N2LN5LhkVYyizYFl/uPeVP5lsoJHhhfWvvSWruCUW1ZcJOeuTbrDgywJ/qG07gZJplnTvLcYdNaH0KMYOYMGX+rB4NGPFmQsNaIwlWrfCezxre8zXBrsMT+edVLbLqN1BqB76JH4BvZTqUIMfGwPGEn+EnmTV86fPBaYbFL3DFEhjB45CewkXEAtJxk4/Ms2pPXnaRqdky0HOYdcUcE2zcXq4vaIvW2/v0nHFJH2XXe22ueDmq/18XGtELSq85j9X8q0tcNSSKJIX8FTuJF/Pf8j5PhqG2u+osvsLxYrvvfeVJL+4tkcXcr9JV7v0ERmj/X6fM3NC4j6dS1+9Umr2oPavqiAydTZPLMNRGY23LO9zAVDly7jD+70G5TPPLdhRIl4WxcYjLnM+SNcJ26FOrkrISUtPObIz5Zb3AG612krnpy15RMW+1cQjlnWFI6538qky9axd2oJmHIHP08KyP0ubGO+TQNOYuv2uh17yCIvR8VcStw7o1g0NM60sk+8Tq7YfIBJrtp53GkvzXH7OA0p8/n/u1satf/VJhtR1l8Wa6Gmaug7haSpaCaYQax6ta0mkutlb+eAOSG1aobM81D9A4iS1RRlzBBoVX6tU1S6WE2N9ORY6DfeLRC4l9Rvr5h95XDWB2mR1d4WFudpsgVYwiTwT31ljskD8ZyDOlm5DkGh9N/UB/0AI5Xvb8ZBmai2hQ4BWMqFwYnzxwB26YHSOv9WgY3JXnvoN+2R4rqGVh/LLDMtpFP+SpMGJNWvbIl5SOodbCczW2RKleksPoUeGEzrjtKHVdtZA+kfqO+rVx/iclCqwoopepvJpSTDjT+b9GWylGRF8EDbGlw6eUzmJM95Ovoz+kwLX3c2fTjFeYEsE7vUZm3mqdGJuKh2w9/QGSaqRHs99aScGOdDqkFcACoqdbBoQqqjamhH6Q9ng39JCg3lrGJwd50Qk9ovnqBTr8MME7Ps2wiVfygUmPoUBJJfJWX5Nda0nuncbFkA=="));
}
const Dr$2 = W0();
new Set(Pr$2(Dr$2)), new Set(Pr$2(Dr$2)), Q0(Dr$2), V0(Dr$2);
const X0 = new Uint8Array(32);
X0.fill(0);
const Z0 = `Ethereum Signed Message:
`;
function ff(e) {
  return typeof e == "string" && (e = Ei(e)), yi(E0([Ei(Z0), Ei(String(e.length)), e]));
}
const ts$2 = "address/5.7.0", Ar$2 = new L$3(ts$2);
function of(e) {
  Qt$1(e, 20) || Ar$2.throwArgumentError("invalid address", "address", e), e = e.toLowerCase();
  const t = e.substring(2).split(""), r = new Uint8Array(40);
  for (let n2 = 0; n2 < 40; n2++)
    r[n2] = t[n2].charCodeAt(0);
  const i2 = Ot$2(yi(r));
  for (let n2 = 0; n2 < 40; n2 += 2)
    i2[n2 >> 1] >> 4 >= 8 && (t[n2] = t[n2].toUpperCase()), (i2[n2 >> 1] & 15) >= 8 && (t[n2 + 1] = t[n2 + 1].toUpperCase());
  return "0x" + t.join("");
}
const es$2 = 9007199254740991;
function rs$2(e) {
  return Math.log10 ? Math.log10(e) : Math.log(e) / Math.LN10;
}
const Ni = {};
for (let e = 0; e < 10; e++)
  Ni[String(e)] = String(e);
for (let e = 0; e < 26; e++)
  Ni[String.fromCharCode(65 + e)] = String(10 + e);
const sf = Math.floor(rs$2(es$2));
function is$2(e) {
  e = e.toUpperCase(), e = e.substring(4) + e.substring(0, 2) + "00";
  let t = e.split("").map((i2) => Ni[i2]).join("");
  for (; t.length >= sf; ) {
    let i2 = t.substring(0, sf);
    t = parseInt(i2, 10) % 97 + t.substring(i2.length);
  }
  let r = String(98 - parseInt(t, 10) % 97);
  for (; r.length < 2; )
    r = "0" + r;
  return r;
}
function ns$2(e) {
  let t = null;
  if (typeof e != "string" && Ar$2.throwArgumentError("invalid address", "address", e), e.match(/^(0x)?[0-9a-fA-F]{40}$/))
    e.substring(0, 2) !== "0x" && (e = "0x" + e), t = of(e), e.match(/([A-F].*[a-f])|([a-f].*[A-F])/) && t !== e && Ar$2.throwArgumentError("bad address checksum", "address", e);
  else if (e.match(/^XE[0-9]{2}[0-9A-Za-z]{30,31}$/)) {
    for (e.substring(2, 4) !== is$2(e) && Ar$2.throwArgumentError("bad icap checksum", "address", e), t = R0(e.substring(4)); t.length < 40; )
      t = "0" + t;
    t = of("0x" + t);
  } else
    Ar$2.throwArgumentError("invalid address", "address", e);
  return t;
}
function br$2(e, t, r) {
  Object.defineProperty(e, t, { enumerable: true, value: r, writable: false });
}
const os$2 = new Uint8Array(32);
os$2.fill(0), V$3.from(-1);
const ss$2 = V$3.from(0), as$1 = V$3.from(1);
V$3.from("0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff"), oe$1(as$1.toHexString(), 32), oe$1(ss$2.toHexString(), 32);
var se$3 = {}, Q$2 = {}, yr$2 = af;
function af(e, t) {
  if (!e)
    throw new Error(t || "Assertion failed");
}
af.equal = function(t, r, i2) {
  if (t != r)
    throw new Error(i2 || "Assertion failed: " + t + " != " + r);
};
var Ii = { exports: {} };
typeof Object.create == "function" ? Ii.exports = function(t, r) {
  r && (t.super_ = r, t.prototype = Object.create(r.prototype, { constructor: { value: t, enumerable: false, writable: true, configurable: true } }));
} : Ii.exports = function(t, r) {
  if (r) {
    t.super_ = r;
    var i2 = function() {
    };
    i2.prototype = r.prototype, t.prototype = new i2(), t.prototype.constructor = t;
  }
};
var us$1 = yr$2, hs$1 = Ii.exports;
Q$2.inherits = hs$1;
function cs$1(e, t) {
  return (e.charCodeAt(t) & 64512) !== 55296 || t < 0 || t + 1 >= e.length ? false : (e.charCodeAt(t + 1) & 64512) === 56320;
}
function ls$1(e, t) {
  if (Array.isArray(e))
    return e.slice();
  if (!e)
    return [];
  var r = [];
  if (typeof e == "string")
    if (t) {
      if (t === "hex")
        for (e = e.replace(/[^a-z0-9]+/ig, ""), e.length % 2 !== 0 && (e = "0" + e), n2 = 0; n2 < e.length; n2 += 2)
          r.push(parseInt(e[n2] + e[n2 + 1], 16));
    } else
      for (var i2 = 0, n2 = 0; n2 < e.length; n2++) {
        var o2 = e.charCodeAt(n2);
        o2 < 128 ? r[i2++] = o2 : o2 < 2048 ? (r[i2++] = o2 >> 6 | 192, r[i2++] = o2 & 63 | 128) : cs$1(e, n2) ? (o2 = 65536 + ((o2 & 1023) << 10) + (e.charCodeAt(++n2) & 1023), r[i2++] = o2 >> 18 | 240, r[i2++] = o2 >> 12 & 63 | 128, r[i2++] = o2 >> 6 & 63 | 128, r[i2++] = o2 & 63 | 128) : (r[i2++] = o2 >> 12 | 224, r[i2++] = o2 >> 6 & 63 | 128, r[i2++] = o2 & 63 | 128);
      }
  else
    for (n2 = 0; n2 < e.length; n2++)
      r[n2] = e[n2] | 0;
  return r;
}
Q$2.toArray = ls$1;
function ds$1(e) {
  for (var t = "", r = 0; r < e.length; r++)
    t += hf(e[r].toString(16));
  return t;
}
Q$2.toHex = ds$1;
function uf(e) {
  var t = e >>> 24 | e >>> 8 & 65280 | e << 8 & 16711680 | (e & 255) << 24;
  return t >>> 0;
}
Q$2.htonl = uf;
function ps$1(e, t) {
  for (var r = "", i2 = 0; i2 < e.length; i2++) {
    var n2 = e[i2];
    t === "little" && (n2 = uf(n2)), r += cf(n2.toString(16));
  }
  return r;
}
Q$2.toHex32 = ps$1;
function hf(e) {
  return e.length === 1 ? "0" + e : e;
}
Q$2.zero2 = hf;
function cf(e) {
  return e.length === 7 ? "0" + e : e.length === 6 ? "00" + e : e.length === 5 ? "000" + e : e.length === 4 ? "0000" + e : e.length === 3 ? "00000" + e : e.length === 2 ? "000000" + e : e.length === 1 ? "0000000" + e : e;
}
Q$2.zero8 = cf;
function vs$1(e, t, r, i2) {
  var n2 = r - t;
  us$1(n2 % 4 === 0);
  for (var o2 = new Array(n2 / 4), h4 = 0, p3 = t; h4 < o2.length; h4++, p3 += 4) {
    var b3;
    i2 === "big" ? b3 = e[p3] << 24 | e[p3 + 1] << 16 | e[p3 + 2] << 8 | e[p3 + 3] : b3 = e[p3 + 3] << 24 | e[p3 + 2] << 16 | e[p3 + 1] << 8 | e[p3], o2[h4] = b3 >>> 0;
  }
  return o2;
}
Q$2.join32 = vs$1;
function ms$1(e, t) {
  for (var r = new Array(e.length * 4), i2 = 0, n2 = 0; i2 < e.length; i2++, n2 += 4) {
    var o2 = e[i2];
    t === "big" ? (r[n2] = o2 >>> 24, r[n2 + 1] = o2 >>> 16 & 255, r[n2 + 2] = o2 >>> 8 & 255, r[n2 + 3] = o2 & 255) : (r[n2 + 3] = o2 >>> 24, r[n2 + 2] = o2 >>> 16 & 255, r[n2 + 1] = o2 >>> 8 & 255, r[n2] = o2 & 255);
  }
  return r;
}
Q$2.split32 = ms$1;
function gs$1(e, t) {
  return e >>> t | e << 32 - t;
}
Q$2.rotr32 = gs$1;
function As$1(e, t) {
  return e << t | e >>> 32 - t;
}
Q$2.rotl32 = As$1;
function bs$1(e, t) {
  return e + t >>> 0;
}
Q$2.sum32 = bs$1;
function ys$1(e, t, r) {
  return e + t + r >>> 0;
}
Q$2.sum32_3 = ys$1;
function ws$1(e, t, r, i2) {
  return e + t + r + i2 >>> 0;
}
Q$2.sum32_4 = ws$1;
function xs$1(e, t, r, i2, n2) {
  return e + t + r + i2 + n2 >>> 0;
}
Q$2.sum32_5 = xs$1;
function Ms$1(e, t, r, i2) {
  var n2 = e[t], o2 = e[t + 1], h4 = i2 + o2 >>> 0, p3 = (h4 < i2 ? 1 : 0) + r + n2;
  e[t] = p3 >>> 0, e[t + 1] = h4;
}
Q$2.sum64 = Ms$1;
function Es$1(e, t, r, i2) {
  var n2 = t + i2 >>> 0, o2 = (n2 < t ? 1 : 0) + e + r;
  return o2 >>> 0;
}
Q$2.sum64_hi = Es$1;
function Ss$1(e, t, r, i2) {
  var n2 = t + i2;
  return n2 >>> 0;
}
Q$2.sum64_lo = Ss$1;
function Ns$1(e, t, r, i2, n2, o2, h4, p3) {
  var b3 = 0, m3 = t;
  m3 = m3 + i2 >>> 0, b3 += m3 < t ? 1 : 0, m3 = m3 + o2 >>> 0, b3 += m3 < o2 ? 1 : 0, m3 = m3 + p3 >>> 0, b3 += m3 < p3 ? 1 : 0;
  var w3 = e + r + n2 + h4 + b3;
  return w3 >>> 0;
}
Q$2.sum64_4_hi = Ns$1;
function Is$1(e, t, r, i2, n2, o2, h4, p3) {
  var b3 = t + i2 + o2 + p3;
  return b3 >>> 0;
}
Q$2.sum64_4_lo = Is$1;
function _s$1(e, t, r, i2, n2, o2, h4, p3, b3, m3) {
  var w3 = 0, y3 = t;
  y3 = y3 + i2 >>> 0, w3 += y3 < t ? 1 : 0, y3 = y3 + o2 >>> 0, w3 += y3 < o2 ? 1 : 0, y3 = y3 + p3 >>> 0, w3 += y3 < p3 ? 1 : 0, y3 = y3 + m3 >>> 0, w3 += y3 < m3 ? 1 : 0;
  var S3 = e + r + n2 + h4 + b3 + w3;
  return S3 >>> 0;
}
Q$2.sum64_5_hi = _s$1;
function Bs$1(e, t, r, i2, n2, o2, h4, p3, b3, m3) {
  var w3 = t + i2 + o2 + p3 + m3;
  return w3 >>> 0;
}
Q$2.sum64_5_lo = Bs$1;
function Cs$1(e, t, r) {
  var i2 = t << 32 - r | e >>> r;
  return i2 >>> 0;
}
Q$2.rotr64_hi = Cs$1;
function Rs$1(e, t, r) {
  var i2 = e << 32 - r | t >>> r;
  return i2 >>> 0;
}
Q$2.rotr64_lo = Rs$1;
function Os$1(e, t, r) {
  return e >>> r;
}
Q$2.shr64_hi = Os$1;
function Ps$1(e, t, r) {
  var i2 = e << 32 - r | t >>> r;
  return i2 >>> 0;
}
Q$2.shr64_lo = Ps$1;
var fr$1 = {}, lf = Q$2, Ds$1 = yr$2;
function Fr$2() {
  this.pending = null, this.pendingTotal = 0, this.blockSize = this.constructor.blockSize, this.outSize = this.constructor.outSize, this.hmacStrength = this.constructor.hmacStrength, this.padLength = this.constructor.padLength / 8, this.endian = "big", this._delta8 = this.blockSize / 8, this._delta32 = this.blockSize / 32;
}
fr$1.BlockHash = Fr$2, Fr$2.prototype.update = function(t, r) {
  if (t = lf.toArray(t, r), this.pending ? this.pending = this.pending.concat(t) : this.pending = t, this.pendingTotal += t.length, this.pending.length >= this._delta8) {
    t = this.pending;
    var i2 = t.length % this._delta8;
    this.pending = t.slice(t.length - i2, t.length), this.pending.length === 0 && (this.pending = null), t = lf.join32(t, 0, t.length - i2, this.endian);
    for (var n2 = 0; n2 < t.length; n2 += this._delta32)
      this._update(t, n2, n2 + this._delta32);
  }
  return this;
}, Fr$2.prototype.digest = function(t) {
  return this.update(this._pad()), Ds$1(this.pending === null), this._digest(t);
}, Fr$2.prototype._pad = function() {
  var t = this.pendingTotal, r = this._delta8, i2 = r - (t + this.padLength) % r, n2 = new Array(i2 + this.padLength);
  n2[0] = 128;
  for (var o2 = 1; o2 < i2; o2++)
    n2[o2] = 0;
  if (t <<= 3, this.endian === "big") {
    for (var h4 = 8; h4 < this.padLength; h4++)
      n2[o2++] = 0;
    n2[o2++] = 0, n2[o2++] = 0, n2[o2++] = 0, n2[o2++] = 0, n2[o2++] = t >>> 24 & 255, n2[o2++] = t >>> 16 & 255, n2[o2++] = t >>> 8 & 255, n2[o2++] = t & 255;
  } else
    for (n2[o2++] = t & 255, n2[o2++] = t >>> 8 & 255, n2[o2++] = t >>> 16 & 255, n2[o2++] = t >>> 24 & 255, n2[o2++] = 0, n2[o2++] = 0, n2[o2++] = 0, n2[o2++] = 0, h4 = 8; h4 < this.padLength; h4++)
      n2[o2++] = 0;
  return n2;
};
var or$2 = {}, ae$1 = {}, Fs$1 = Q$2, ue$1 = Fs$1.rotr32;
function Ts$1(e, t, r, i2) {
  if (e === 0)
    return df(t, r, i2);
  if (e === 1 || e === 3)
    return vf(t, r, i2);
  if (e === 2)
    return pf(t, r, i2);
}
ae$1.ft_1 = Ts$1;
function df(e, t, r) {
  return e & t ^ ~e & r;
}
ae$1.ch32 = df;
function pf(e, t, r) {
  return e & t ^ e & r ^ t & r;
}
ae$1.maj32 = pf;
function vf(e, t, r) {
  return e ^ t ^ r;
}
ae$1.p32 = vf;
function Us$1(e) {
  return ue$1(e, 2) ^ ue$1(e, 13) ^ ue$1(e, 22);
}
ae$1.s0_256 = Us$1;
function ks$1(e) {
  return ue$1(e, 6) ^ ue$1(e, 11) ^ ue$1(e, 25);
}
ae$1.s1_256 = ks$1;
function qs$1(e) {
  return ue$1(e, 7) ^ ue$1(e, 18) ^ e >>> 3;
}
ae$1.g0_256 = qs$1;
function Ks$1(e) {
  return ue$1(e, 17) ^ ue$1(e, 19) ^ e >>> 10;
}
ae$1.g1_256 = Ks$1;
var sr$2 = Q$2, Hs$1 = fr$1, zs$1 = ae$1, _i = sr$2.rotl32, wr$1 = sr$2.sum32, Ls$1 = sr$2.sum32_5, js$1 = zs$1.ft_1, mf = Hs$1.BlockHash, Qs$1 = [1518500249, 1859775393, 2400959708, 3395469782];
function he$1() {
  if (!(this instanceof he$1))
    return new he$1();
  mf.call(this), this.h = [1732584193, 4023233417, 2562383102, 271733878, 3285377520], this.W = new Array(80);
}
sr$2.inherits(he$1, mf);
var Js$1 = he$1;
he$1.blockSize = 512, he$1.outSize = 160, he$1.hmacStrength = 80, he$1.padLength = 64, he$1.prototype._update = function(t, r) {
  for (var i2 = this.W, n2 = 0; n2 < 16; n2++)
    i2[n2] = t[r + n2];
  for (; n2 < i2.length; n2++)
    i2[n2] = _i(i2[n2 - 3] ^ i2[n2 - 8] ^ i2[n2 - 14] ^ i2[n2 - 16], 1);
  var o2 = this.h[0], h4 = this.h[1], p3 = this.h[2], b3 = this.h[3], m3 = this.h[4];
  for (n2 = 0; n2 < i2.length; n2++) {
    var w3 = ~~(n2 / 20), y3 = Ls$1(_i(o2, 5), js$1(w3, h4, p3, b3), m3, i2[n2], Qs$1[w3]);
    m3 = b3, b3 = p3, p3 = _i(h4, 30), h4 = o2, o2 = y3;
  }
  this.h[0] = wr$1(this.h[0], o2), this.h[1] = wr$1(this.h[1], h4), this.h[2] = wr$1(this.h[2], p3), this.h[3] = wr$1(this.h[3], b3), this.h[4] = wr$1(this.h[4], m3);
}, he$1.prototype._digest = function(t) {
  return t === "hex" ? sr$2.toHex32(this.h, "big") : sr$2.split32(this.h, "big");
};
var ar$2 = Q$2, Gs$1 = fr$1, ur$2 = ae$1, Ys$1 = yr$2, ie$4 = ar$2.sum32, Vs$1 = ar$2.sum32_4, Ws$1 = ar$2.sum32_5, Xs$1 = ur$2.ch32, Zs$1 = ur$2.maj32, $s$1 = ur$2.s0_256, ta = ur$2.s1_256, ea = ur$2.g0_256, ra = ur$2.g1_256, gf = Gs$1.BlockHash, ia = [1116352408, 1899447441, 3049323471, 3921009573, 961987163, 1508970993, 2453635748, 2870763221, 3624381080, 310598401, 607225278, 1426881987, 1925078388, 2162078206, 2614888103, 3248222580, 3835390401, 4022224774, 264347078, 604807628, 770255983, 1249150122, 1555081692, 1996064986, 2554220882, 2821834349, 2952996808, 3210313671, 3336571891, 3584528711, 113926993, 338241895, 666307205, 773529912, 1294757372, 1396182291, 1695183700, 1986661051, 2177026350, 2456956037, 2730485921, 2820302411, 3259730800, 3345764771, 3516065817, 3600352804, 4094571909, 275423344, 430227734, 506948616, 659060556, 883997877, 958139571, 1322822218, 1537002063, 1747873779, 1955562222, 2024104815, 2227730452, 2361852424, 2428436474, 2756734187, 3204031479, 3329325298];
function ce$1() {
  if (!(this instanceof ce$1))
    return new ce$1();
  gf.call(this), this.h = [1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225], this.k = ia, this.W = new Array(64);
}
ar$2.inherits(ce$1, gf);
var Af = ce$1;
ce$1.blockSize = 512, ce$1.outSize = 256, ce$1.hmacStrength = 192, ce$1.padLength = 64, ce$1.prototype._update = function(t, r) {
  for (var i2 = this.W, n2 = 0; n2 < 16; n2++)
    i2[n2] = t[r + n2];
  for (; n2 < i2.length; n2++)
    i2[n2] = Vs$1(ra(i2[n2 - 2]), i2[n2 - 7], ea(i2[n2 - 15]), i2[n2 - 16]);
  var o2 = this.h[0], h4 = this.h[1], p3 = this.h[2], b3 = this.h[3], m3 = this.h[4], w3 = this.h[5], y3 = this.h[6], S3 = this.h[7];
  for (Ys$1(this.k.length === i2.length), n2 = 0; n2 < i2.length; n2++) {
    var I2 = Ws$1(S3, ta(m3), Xs$1(m3, w3, y3), this.k[n2], i2[n2]), N2 = ie$4($s$1(o2), Zs$1(o2, h4, p3));
    S3 = y3, y3 = w3, w3 = m3, m3 = ie$4(b3, I2), b3 = p3, p3 = h4, h4 = o2, o2 = ie$4(I2, N2);
  }
  this.h[0] = ie$4(this.h[0], o2), this.h[1] = ie$4(this.h[1], h4), this.h[2] = ie$4(this.h[2], p3), this.h[3] = ie$4(this.h[3], b3), this.h[4] = ie$4(this.h[4], m3), this.h[5] = ie$4(this.h[5], w3), this.h[6] = ie$4(this.h[6], y3), this.h[7] = ie$4(this.h[7], S3);
}, ce$1.prototype._digest = function(t) {
  return t === "hex" ? ar$2.toHex32(this.h, "big") : ar$2.split32(this.h, "big");
};
var Bi = Q$2, bf = Af;
function ye$2() {
  if (!(this instanceof ye$2))
    return new ye$2();
  bf.call(this), this.h = [3238371032, 914150663, 812702999, 4144912697, 4290775857, 1750603025, 1694076839, 3204075428];
}
Bi.inherits(ye$2, bf);
var na = ye$2;
ye$2.blockSize = 512, ye$2.outSize = 224, ye$2.hmacStrength = 192, ye$2.padLength = 64, ye$2.prototype._digest = function(t) {
  return t === "hex" ? Bi.toHex32(this.h.slice(0, 7), "big") : Bi.split32(this.h.slice(0, 7), "big");
};
var jt$2 = Q$2, fa = fr$1, oa = yr$2, le$1 = jt$2.rotr64_hi, de$2 = jt$2.rotr64_lo, yf = jt$2.shr64_hi, wf = jt$2.shr64_lo, Be$2 = jt$2.sum64, Ci = jt$2.sum64_hi, Ri = jt$2.sum64_lo, sa = jt$2.sum64_4_hi, aa = jt$2.sum64_4_lo, ua = jt$2.sum64_5_hi, ha = jt$2.sum64_5_lo, xf = fa.BlockHash, ca = [1116352408, 3609767458, 1899447441, 602891725, 3049323471, 3964484399, 3921009573, 2173295548, 961987163, 4081628472, 1508970993, 3053834265, 2453635748, 2937671579, 2870763221, 3664609560, 3624381080, 2734883394, 310598401, 1164996542, 607225278, 1323610764, 1426881987, 3590304994, 1925078388, 4068182383, 2162078206, 991336113, 2614888103, 633803317, 3248222580, 3479774868, 3835390401, 2666613458, 4022224774, 944711139, 264347078, 2341262773, 604807628, 2007800933, 770255983, 1495990901, 1249150122, 1856431235, 1555081692, 3175218132, 1996064986, 2198950837, 2554220882, 3999719339, 2821834349, 766784016, 2952996808, 2566594879, 3210313671, 3203337956, 3336571891, 1034457026, 3584528711, 2466948901, 113926993, 3758326383, 338241895, 168717936, 666307205, 1188179964, 773529912, 1546045734, 1294757372, 1522805485, 1396182291, 2643833823, 1695183700, 2343527390, 1986661051, 1014477480, 2177026350, 1206759142, 2456956037, 344077627, 2730485921, 1290863460, 2820302411, 3158454273, 3259730800, 3505952657, 3345764771, 106217008, 3516065817, 3606008344, 3600352804, 1432725776, 4094571909, 1467031594, 275423344, 851169720, 430227734, 3100823752, 506948616, 1363258195, 659060556, 3750685593, 883997877, 3785050280, 958139571, 3318307427, 1322822218, 3812723403, 1537002063, 2003034995, 1747873779, 3602036899, 1955562222, 1575990012, 2024104815, 1125592928, 2227730452, 2716904306, 2361852424, 442776044, 2428436474, 593698344, 2756734187, 3733110249, 3204031479, 2999351573, 3329325298, 3815920427, 3391569614, 3928383900, 3515267271, 566280711, 3940187606, 3454069534, 4118630271, 4000239992, 116418474, 1914138554, 174292421, 2731055270, 289380356, 3203993006, 460393269, 320620315, 685471733, 587496836, 852142971, 1086792851, 1017036298, 365543100, 1126000580, 2618297676, 1288033470, 3409855158, 1501505948, 4234509866, 1607167915, 987167468, 1816402316, 1246189591];
function ne$3() {
  if (!(this instanceof ne$3))
    return new ne$3();
  xf.call(this), this.h = [1779033703, 4089235720, 3144134277, 2227873595, 1013904242, 4271175723, 2773480762, 1595750129, 1359893119, 2917565137, 2600822924, 725511199, 528734635, 4215389547, 1541459225, 327033209], this.k = ca, this.W = new Array(160);
}
jt$2.inherits(ne$3, xf);
var Mf = ne$3;
ne$3.blockSize = 1024, ne$3.outSize = 512, ne$3.hmacStrength = 192, ne$3.padLength = 128, ne$3.prototype._prepareBlock = function(t, r) {
  for (var i2 = this.W, n2 = 0; n2 < 32; n2++)
    i2[n2] = t[r + n2];
  for (; n2 < i2.length; n2 += 2) {
    var o2 = xa(i2[n2 - 4], i2[n2 - 3]), h4 = Ma(i2[n2 - 4], i2[n2 - 3]), p3 = i2[n2 - 14], b3 = i2[n2 - 13], m3 = ya(i2[n2 - 30], i2[n2 - 29]), w3 = wa(i2[n2 - 30], i2[n2 - 29]), y3 = i2[n2 - 32], S3 = i2[n2 - 31];
    i2[n2] = sa(o2, h4, p3, b3, m3, w3, y3, S3), i2[n2 + 1] = aa(o2, h4, p3, b3, m3, w3, y3, S3);
  }
}, ne$3.prototype._update = function(t, r) {
  this._prepareBlock(t, r);
  var i2 = this.W, n2 = this.h[0], o2 = this.h[1], h4 = this.h[2], p3 = this.h[3], b3 = this.h[4], m3 = this.h[5], w3 = this.h[6], y3 = this.h[7], S3 = this.h[8], I2 = this.h[9], N2 = this.h[10], C2 = this.h[11], F2 = this.h[12], U2 = this.h[13], J2 = this.h[14], Bt2 = this.h[15];
  oa(this.k.length === i2.length);
  for (var G2 = 0; G2 < i2.length; G2 += 2) {
    var H2 = J2, z2 = Bt2, Pt2 = Aa(S3, I2), W2 = ba(S3, I2), Rt2 = la(S3, I2, N2, C2, F2), Yt3 = da(S3, I2, N2, C2, F2, U2), Y2 = this.k[G2], Vt3 = this.k[G2 + 1], A2 = i2[G2], f3 = i2[G2 + 1], a3 = ua(H2, z2, Pt2, W2, Rt2, Yt3, Y2, Vt3, A2, f3), c2 = ha(H2, z2, Pt2, W2, Rt2, Yt3, Y2, Vt3, A2, f3);
    H2 = ma(n2, o2), z2 = ga(n2, o2), Pt2 = pa(n2, o2, h4, p3, b3), W2 = va(n2, o2, h4, p3, b3, m3);
    var d4 = Ci(H2, z2, Pt2, W2), g3 = Ri(H2, z2, Pt2, W2);
    J2 = F2, Bt2 = U2, F2 = N2, U2 = C2, N2 = S3, C2 = I2, S3 = Ci(w3, y3, a3, c2), I2 = Ri(y3, y3, a3, c2), w3 = b3, y3 = m3, b3 = h4, m3 = p3, h4 = n2, p3 = o2, n2 = Ci(a3, c2, d4, g3), o2 = Ri(a3, c2, d4, g3);
  }
  Be$2(this.h, 0, n2, o2), Be$2(this.h, 2, h4, p3), Be$2(this.h, 4, b3, m3), Be$2(this.h, 6, w3, y3), Be$2(this.h, 8, S3, I2), Be$2(this.h, 10, N2, C2), Be$2(this.h, 12, F2, U2), Be$2(this.h, 14, J2, Bt2);
}, ne$3.prototype._digest = function(t) {
  return t === "hex" ? jt$2.toHex32(this.h, "big") : jt$2.split32(this.h, "big");
};
function la(e, t, r, i2, n2) {
  var o2 = e & r ^ ~e & n2;
  return o2 < 0 && (o2 += 4294967296), o2;
}
function da(e, t, r, i2, n2, o2) {
  var h4 = t & i2 ^ ~t & o2;
  return h4 < 0 && (h4 += 4294967296), h4;
}
function pa(e, t, r, i2, n2) {
  var o2 = e & r ^ e & n2 ^ r & n2;
  return o2 < 0 && (o2 += 4294967296), o2;
}
function va(e, t, r, i2, n2, o2) {
  var h4 = t & i2 ^ t & o2 ^ i2 & o2;
  return h4 < 0 && (h4 += 4294967296), h4;
}
function ma(e, t) {
  var r = le$1(e, t, 28), i2 = le$1(t, e, 2), n2 = le$1(t, e, 7), o2 = r ^ i2 ^ n2;
  return o2 < 0 && (o2 += 4294967296), o2;
}
function ga(e, t) {
  var r = de$2(e, t, 28), i2 = de$2(t, e, 2), n2 = de$2(t, e, 7), o2 = r ^ i2 ^ n2;
  return o2 < 0 && (o2 += 4294967296), o2;
}
function Aa(e, t) {
  var r = le$1(e, t, 14), i2 = le$1(e, t, 18), n2 = le$1(t, e, 9), o2 = r ^ i2 ^ n2;
  return o2 < 0 && (o2 += 4294967296), o2;
}
function ba(e, t) {
  var r = de$2(e, t, 14), i2 = de$2(e, t, 18), n2 = de$2(t, e, 9), o2 = r ^ i2 ^ n2;
  return o2 < 0 && (o2 += 4294967296), o2;
}
function ya(e, t) {
  var r = le$1(e, t, 1), i2 = le$1(e, t, 8), n2 = yf(e, t, 7), o2 = r ^ i2 ^ n2;
  return o2 < 0 && (o2 += 4294967296), o2;
}
function wa(e, t) {
  var r = de$2(e, t, 1), i2 = de$2(e, t, 8), n2 = wf(e, t, 7), o2 = r ^ i2 ^ n2;
  return o2 < 0 && (o2 += 4294967296), o2;
}
function xa(e, t) {
  var r = le$1(e, t, 19), i2 = le$1(t, e, 29), n2 = yf(e, t, 6), o2 = r ^ i2 ^ n2;
  return o2 < 0 && (o2 += 4294967296), o2;
}
function Ma(e, t) {
  var r = de$2(e, t, 19), i2 = de$2(t, e, 29), n2 = wf(e, t, 6), o2 = r ^ i2 ^ n2;
  return o2 < 0 && (o2 += 4294967296), o2;
}
var Oi = Q$2, Ef = Mf;
function we$1() {
  if (!(this instanceof we$1))
    return new we$1();
  Ef.call(this), this.h = [3418070365, 3238371032, 1654270250, 914150663, 2438529370, 812702999, 355462360, 4144912697, 1731405415, 4290775857, 2394180231, 1750603025, 3675008525, 1694076839, 1203062813, 3204075428];
}
Oi.inherits(we$1, Ef);
var Ea = we$1;
we$1.blockSize = 1024, we$1.outSize = 384, we$1.hmacStrength = 192, we$1.padLength = 128, we$1.prototype._digest = function(t) {
  return t === "hex" ? Oi.toHex32(this.h.slice(0, 12), "big") : Oi.split32(this.h.slice(0, 12), "big");
}, or$2.sha1 = Js$1, or$2.sha224 = na, or$2.sha256 = Af, or$2.sha384 = Ea, or$2.sha512 = Mf;
var Sf = {}, Xe$2 = Q$2, Sa = fr$1, Tr$2 = Xe$2.rotl32, Nf = Xe$2.sum32, xr$2 = Xe$2.sum32_3, If = Xe$2.sum32_4, _f = Sa.BlockHash;
function pe$2() {
  if (!(this instanceof pe$2))
    return new pe$2();
  _f.call(this), this.h = [1732584193, 4023233417, 2562383102, 271733878, 3285377520], this.endian = "little";
}
Xe$2.inherits(pe$2, _f), Sf.ripemd160 = pe$2, pe$2.blockSize = 512, pe$2.outSize = 160, pe$2.hmacStrength = 192, pe$2.padLength = 64, pe$2.prototype._update = function(t, r) {
  for (var i2 = this.h[0], n2 = this.h[1], o2 = this.h[2], h4 = this.h[3], p3 = this.h[4], b3 = i2, m3 = n2, w3 = o2, y3 = h4, S3 = p3, I2 = 0; I2 < 80; I2++) {
    var N2 = Nf(Tr$2(If(i2, Bf(I2, n2, o2, h4), t[_a[I2] + r], Na(I2)), Ca[I2]), p3);
    i2 = p3, p3 = h4, h4 = Tr$2(o2, 10), o2 = n2, n2 = N2, N2 = Nf(Tr$2(If(b3, Bf(79 - I2, m3, w3, y3), t[Ba[I2] + r], Ia(I2)), Ra[I2]), S3), b3 = S3, S3 = y3, y3 = Tr$2(w3, 10), w3 = m3, m3 = N2;
  }
  N2 = xr$2(this.h[1], o2, y3), this.h[1] = xr$2(this.h[2], h4, S3), this.h[2] = xr$2(this.h[3], p3, b3), this.h[3] = xr$2(this.h[4], i2, m3), this.h[4] = xr$2(this.h[0], n2, w3), this.h[0] = N2;
}, pe$2.prototype._digest = function(t) {
  return t === "hex" ? Xe$2.toHex32(this.h, "little") : Xe$2.split32(this.h, "little");
};
function Bf(e, t, r, i2) {
  return e <= 15 ? t ^ r ^ i2 : e <= 31 ? t & r | ~t & i2 : e <= 47 ? (t | ~r) ^ i2 : e <= 63 ? t & i2 | r & ~i2 : t ^ (r | ~i2);
}
function Na(e) {
  return e <= 15 ? 0 : e <= 31 ? 1518500249 : e <= 47 ? 1859775393 : e <= 63 ? 2400959708 : 2840853838;
}
function Ia(e) {
  return e <= 15 ? 1352829926 : e <= 31 ? 1548603684 : e <= 47 ? 1836072691 : e <= 63 ? 2053994217 : 0;
}
var _a = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 7, 4, 13, 1, 10, 6, 15, 3, 12, 0, 9, 5, 2, 14, 11, 8, 3, 10, 14, 4, 9, 15, 8, 1, 2, 7, 0, 6, 13, 11, 5, 12, 1, 9, 11, 10, 0, 8, 12, 4, 13, 3, 7, 15, 14, 5, 6, 2, 4, 0, 5, 9, 7, 12, 2, 10, 14, 1, 3, 8, 11, 6, 15, 13], Ba = [5, 14, 7, 0, 9, 2, 11, 4, 13, 6, 15, 8, 1, 10, 3, 12, 6, 11, 3, 7, 0, 13, 5, 10, 14, 15, 8, 12, 4, 9, 1, 2, 15, 5, 1, 3, 7, 14, 6, 9, 11, 8, 12, 2, 10, 0, 4, 13, 8, 6, 4, 1, 3, 11, 15, 0, 5, 12, 2, 13, 9, 7, 10, 14, 12, 15, 10, 4, 1, 5, 8, 7, 6, 2, 13, 14, 0, 3, 9, 11], Ca = [11, 14, 15, 12, 5, 8, 7, 9, 11, 13, 14, 15, 6, 7, 9, 8, 7, 6, 8, 13, 11, 9, 7, 15, 7, 12, 15, 9, 11, 7, 13, 12, 11, 13, 6, 7, 14, 9, 13, 15, 14, 8, 13, 6, 5, 12, 7, 5, 11, 12, 14, 15, 14, 15, 9, 8, 9, 14, 5, 6, 8, 6, 5, 12, 9, 15, 5, 11, 6, 8, 13, 12, 5, 12, 13, 14, 11, 8, 5, 6], Ra = [8, 9, 9, 11, 13, 15, 15, 5, 7, 7, 8, 11, 14, 14, 12, 6, 9, 13, 15, 7, 12, 8, 9, 11, 7, 7, 12, 7, 6, 15, 13, 11, 9, 7, 15, 11, 8, 6, 6, 14, 12, 13, 5, 14, 13, 13, 7, 5, 15, 5, 8, 11, 14, 14, 6, 14, 6, 9, 12, 9, 12, 5, 15, 8, 8, 5, 12, 9, 12, 5, 14, 6, 8, 13, 6, 5, 15, 13, 11, 11], Oa = Q$2, Pa = yr$2;
function hr$2(e, t, r) {
  if (!(this instanceof hr$2))
    return new hr$2(e, t, r);
  this.Hash = e, this.blockSize = e.blockSize / 8, this.outSize = e.outSize / 8, this.inner = null, this.outer = null, this._init(Oa.toArray(t, r));
}
var Da = hr$2;
hr$2.prototype._init = function(t) {
  t.length > this.blockSize && (t = new this.Hash().update(t).digest()), Pa(t.length <= this.blockSize);
  for (var r = t.length; r < this.blockSize; r++)
    t.push(0);
  for (r = 0; r < t.length; r++)
    t[r] ^= 54;
  for (this.inner = new this.Hash().update(t), r = 0; r < t.length; r++)
    t[r] ^= 106;
  this.outer = new this.Hash().update(t);
}, hr$2.prototype.update = function(t, r) {
  return this.inner.update(t, r), this;
}, hr$2.prototype.digest = function(t) {
  return this.outer.update(this.inner.digest()), this.outer.digest(t);
}, function(e) {
  var t = e;
  t.utils = Q$2, t.common = fr$1, t.sha = or$2, t.ripemd = Sf, t.hmac = Da, t.sha1 = t.sha.sha1, t.sha256 = t.sha.sha256, t.sha224 = t.sha.sha224, t.sha384 = t.sha.sha384, t.sha512 = t.sha.sha512, t.ripemd160 = t.ripemd.ripemd160;
}(se$3);
function cr$2(e, t, r) {
  return r = { path: t, exports: {}, require: function(i2, n2) {
    return Fa(i2, n2 ?? r.path);
  } }, e(r, r.exports), r.exports;
}
function Fa() {
  throw new Error("Dynamic requires are not currently supported by @rollup/plugin-commonjs");
}
var Pi = Cf;
function Cf(e, t) {
  if (!e)
    throw new Error(t || "Assertion failed");
}
Cf.equal = function(t, r, i2) {
  if (t != r)
    throw new Error(i2 || "Assertion failed: " + t + " != " + r);
};
var fe$2 = cr$2(function(e, t) {
  var r = t;
  function i2(h4, p3) {
    if (Array.isArray(h4))
      return h4.slice();
    if (!h4)
      return [];
    var b3 = [];
    if (typeof h4 != "string") {
      for (var m3 = 0; m3 < h4.length; m3++)
        b3[m3] = h4[m3] | 0;
      return b3;
    }
    if (p3 === "hex") {
      h4 = h4.replace(/[^a-z0-9]+/ig, ""), h4.length % 2 !== 0 && (h4 = "0" + h4);
      for (var m3 = 0; m3 < h4.length; m3 += 2)
        b3.push(parseInt(h4[m3] + h4[m3 + 1], 16));
    } else
      for (var m3 = 0; m3 < h4.length; m3++) {
        var w3 = h4.charCodeAt(m3), y3 = w3 >> 8, S3 = w3 & 255;
        y3 ? b3.push(y3, S3) : b3.push(S3);
      }
    return b3;
  }
  r.toArray = i2;
  function n2(h4) {
    return h4.length === 1 ? "0" + h4 : h4;
  }
  r.zero2 = n2;
  function o2(h4) {
    for (var p3 = "", b3 = 0; b3 < h4.length; b3++)
      p3 += n2(h4[b3].toString(16));
    return p3;
  }
  r.toHex = o2, r.encode = function(p3, b3) {
    return b3 === "hex" ? o2(p3) : p3;
  };
}), Jt$3 = cr$2(function(e, t) {
  var r = t;
  r.assert = Pi, r.toArray = fe$2.toArray, r.zero2 = fe$2.zero2, r.toHex = fe$2.toHex, r.encode = fe$2.encode;
  function i2(b3, m3, w3) {
    var y3 = new Array(Math.max(b3.bitLength(), w3) + 1);
    y3.fill(0);
    for (var S3 = 1 << m3 + 1, I2 = b3.clone(), N2 = 0; N2 < y3.length; N2++) {
      var C2, F2 = I2.andln(S3 - 1);
      I2.isOdd() ? (F2 > (S3 >> 1) - 1 ? C2 = (S3 >> 1) - F2 : C2 = F2, I2.isubn(C2)) : C2 = 0, y3[N2] = C2, I2.iushrn(1);
    }
    return y3;
  }
  r.getNAF = i2;
  function n2(b3, m3) {
    var w3 = [[], []];
    b3 = b3.clone(), m3 = m3.clone();
    for (var y3 = 0, S3 = 0, I2; b3.cmpn(-y3) > 0 || m3.cmpn(-S3) > 0; ) {
      var N2 = b3.andln(3) + y3 & 3, C2 = m3.andln(3) + S3 & 3;
      N2 === 3 && (N2 = -1), C2 === 3 && (C2 = -1);
      var F2;
      N2 & 1 ? (I2 = b3.andln(7) + y3 & 7, (I2 === 3 || I2 === 5) && C2 === 2 ? F2 = -N2 : F2 = N2) : F2 = 0, w3[0].push(F2);
      var U2;
      C2 & 1 ? (I2 = m3.andln(7) + S3 & 7, (I2 === 3 || I2 === 5) && N2 === 2 ? U2 = -C2 : U2 = C2) : U2 = 0, w3[1].push(U2), 2 * y3 === F2 + 1 && (y3 = 1 - y3), 2 * S3 === U2 + 1 && (S3 = 1 - S3), b3.iushrn(1), m3.iushrn(1);
    }
    return w3;
  }
  r.getJSF = n2;
  function o2(b3, m3, w3) {
    var y3 = "_" + m3;
    b3.prototype[m3] = function() {
      return this[y3] !== void 0 ? this[y3] : this[y3] = w3.call(this);
    };
  }
  r.cachedProperty = o2;
  function h4(b3) {
    return typeof b3 == "string" ? r.toArray(b3, "hex") : b3;
  }
  r.parseBytes = h4;
  function p3(b3) {
    return new K$3(b3, "hex", "le");
  }
  r.intFromLE = p3;
}), Ur$1 = Jt$3.getNAF, Ta = Jt$3.getJSF, kr$1 = Jt$3.assert;
function Ce$1(e, t) {
  this.type = e, this.p = new K$3(t.p, 16), this.red = t.prime ? K$3.red(t.prime) : K$3.mont(this.p), this.zero = new K$3(0).toRed(this.red), this.one = new K$3(1).toRed(this.red), this.two = new K$3(2).toRed(this.red), this.n = t.n && new K$3(t.n, 16), this.g = t.g && this.pointFromJSON(t.g, t.gRed), this._wnafT1 = new Array(4), this._wnafT2 = new Array(4), this._wnafT3 = new Array(4), this._wnafT4 = new Array(4), this._bitLength = this.n ? this.n.bitLength() : 0;
  var r = this.n && this.p.div(this.n);
  !r || r.cmpn(100) > 0 ? this.redN = null : (this._maxwellTrick = true, this.redN = this.n.toRed(this.red));
}
var Ze$2 = Ce$1;
Ce$1.prototype.point = function() {
  throw new Error("Not implemented");
}, Ce$1.prototype.validate = function() {
  throw new Error("Not implemented");
}, Ce$1.prototype._fixedNafMul = function(t, r) {
  kr$1(t.precomputed);
  var i2 = t._getDoubles(), n2 = Ur$1(r, 1, this._bitLength), o2 = (1 << i2.step + 1) - (i2.step % 2 === 0 ? 2 : 1);
  o2 /= 3;
  var h4 = [], p3, b3;
  for (p3 = 0; p3 < n2.length; p3 += i2.step) {
    b3 = 0;
    for (var m3 = p3 + i2.step - 1; m3 >= p3; m3--)
      b3 = (b3 << 1) + n2[m3];
    h4.push(b3);
  }
  for (var w3 = this.jpoint(null, null, null), y3 = this.jpoint(null, null, null), S3 = o2; S3 > 0; S3--) {
    for (p3 = 0; p3 < h4.length; p3++)
      b3 = h4[p3], b3 === S3 ? y3 = y3.mixedAdd(i2.points[p3]) : b3 === -S3 && (y3 = y3.mixedAdd(i2.points[p3].neg()));
    w3 = w3.add(y3);
  }
  return w3.toP();
}, Ce$1.prototype._wnafMul = function(t, r) {
  var i2 = 4, n2 = t._getNAFPoints(i2);
  i2 = n2.wnd;
  for (var o2 = n2.points, h4 = Ur$1(r, i2, this._bitLength), p3 = this.jpoint(null, null, null), b3 = h4.length - 1; b3 >= 0; b3--) {
    for (var m3 = 0; b3 >= 0 && h4[b3] === 0; b3--)
      m3++;
    if (b3 >= 0 && m3++, p3 = p3.dblp(m3), b3 < 0)
      break;
    var w3 = h4[b3];
    kr$1(w3 !== 0), t.type === "affine" ? w3 > 0 ? p3 = p3.mixedAdd(o2[w3 - 1 >> 1]) : p3 = p3.mixedAdd(o2[-w3 - 1 >> 1].neg()) : w3 > 0 ? p3 = p3.add(o2[w3 - 1 >> 1]) : p3 = p3.add(o2[-w3 - 1 >> 1].neg());
  }
  return t.type === "affine" ? p3.toP() : p3;
}, Ce$1.prototype._wnafMulAdd = function(t, r, i2, n2, o2) {
  var h4 = this._wnafT1, p3 = this._wnafT2, b3 = this._wnafT3, m3 = 0, w3, y3, S3;
  for (w3 = 0; w3 < n2; w3++) {
    S3 = r[w3];
    var I2 = S3._getNAFPoints(t);
    h4[w3] = I2.wnd, p3[w3] = I2.points;
  }
  for (w3 = n2 - 1; w3 >= 1; w3 -= 2) {
    var N2 = w3 - 1, C2 = w3;
    if (h4[N2] !== 1 || h4[C2] !== 1) {
      b3[N2] = Ur$1(i2[N2], h4[N2], this._bitLength), b3[C2] = Ur$1(i2[C2], h4[C2], this._bitLength), m3 = Math.max(b3[N2].length, m3), m3 = Math.max(b3[C2].length, m3);
      continue;
    }
    var F2 = [r[N2], null, null, r[C2]];
    r[N2].y.cmp(r[C2].y) === 0 ? (F2[1] = r[N2].add(r[C2]), F2[2] = r[N2].toJ().mixedAdd(r[C2].neg())) : r[N2].y.cmp(r[C2].y.redNeg()) === 0 ? (F2[1] = r[N2].toJ().mixedAdd(r[C2]), F2[2] = r[N2].add(r[C2].neg())) : (F2[1] = r[N2].toJ().mixedAdd(r[C2]), F2[2] = r[N2].toJ().mixedAdd(r[C2].neg()));
    var U2 = [-3, -1, -5, -7, 0, 7, 5, 1, 3], J2 = Ta(i2[N2], i2[C2]);
    for (m3 = Math.max(J2[0].length, m3), b3[N2] = new Array(m3), b3[C2] = new Array(m3), y3 = 0; y3 < m3; y3++) {
      var Bt2 = J2[0][y3] | 0, G2 = J2[1][y3] | 0;
      b3[N2][y3] = U2[(Bt2 + 1) * 3 + (G2 + 1)], b3[C2][y3] = 0, p3[N2] = F2;
    }
  }
  var H2 = this.jpoint(null, null, null), z2 = this._wnafT4;
  for (w3 = m3; w3 >= 0; w3--) {
    for (var Pt2 = 0; w3 >= 0; ) {
      var W2 = true;
      for (y3 = 0; y3 < n2; y3++)
        z2[y3] = b3[y3][w3] | 0, z2[y3] !== 0 && (W2 = false);
      if (!W2)
        break;
      Pt2++, w3--;
    }
    if (w3 >= 0 && Pt2++, H2 = H2.dblp(Pt2), w3 < 0)
      break;
    for (y3 = 0; y3 < n2; y3++) {
      var Rt2 = z2[y3];
      Rt2 !== 0 && (Rt2 > 0 ? S3 = p3[y3][Rt2 - 1 >> 1] : Rt2 < 0 && (S3 = p3[y3][-Rt2 - 1 >> 1].neg()), S3.type === "affine" ? H2 = H2.mixedAdd(S3) : H2 = H2.add(S3));
    }
  }
  for (w3 = 0; w3 < n2; w3++)
    p3[w3] = null;
  return o2 ? H2 : H2.toP();
};
function Xt$3(e, t) {
  this.curve = e, this.type = t, this.precomputed = null;
}
Ce$1.BasePoint = Xt$3, Xt$3.prototype.eq = function() {
  throw new Error("Not implemented");
}, Xt$3.prototype.validate = function() {
  return this.curve.validate(this);
}, Ce$1.prototype.decodePoint = function(t, r) {
  t = Jt$3.toArray(t, r);
  var i2 = this.p.byteLength();
  if ((t[0] === 4 || t[0] === 6 || t[0] === 7) && t.length - 1 === 2 * i2) {
    t[0] === 6 ? kr$1(t[t.length - 1] % 2 === 0) : t[0] === 7 && kr$1(t[t.length - 1] % 2 === 1);
    var n2 = this.point(t.slice(1, 1 + i2), t.slice(1 + i2, 1 + 2 * i2));
    return n2;
  } else if ((t[0] === 2 || t[0] === 3) && t.length - 1 === i2)
    return this.pointFromX(t.slice(1, 1 + i2), t[0] === 3);
  throw new Error("Unknown point format");
}, Xt$3.prototype.encodeCompressed = function(t) {
  return this.encode(t, true);
}, Xt$3.prototype._encode = function(t) {
  var r = this.curve.p.byteLength(), i2 = this.getX().toArray("be", r);
  return t ? [this.getY().isEven() ? 2 : 3].concat(i2) : [4].concat(i2, this.getY().toArray("be", r));
}, Xt$3.prototype.encode = function(t, r) {
  return Jt$3.encode(this._encode(r), t);
}, Xt$3.prototype.precompute = function(t) {
  if (this.precomputed)
    return this;
  var r = { doubles: null, naf: null, beta: null };
  return r.naf = this._getNAFPoints(8), r.doubles = this._getDoubles(4, t), r.beta = this._getBeta(), this.precomputed = r, this;
}, Xt$3.prototype._hasDoubles = function(t) {
  if (!this.precomputed)
    return false;
  var r = this.precomputed.doubles;
  return r ? r.points.length >= Math.ceil((t.bitLength() + 1) / r.step) : false;
}, Xt$3.prototype._getDoubles = function(t, r) {
  if (this.precomputed && this.precomputed.doubles)
    return this.precomputed.doubles;
  for (var i2 = [this], n2 = this, o2 = 0; o2 < r; o2 += t) {
    for (var h4 = 0; h4 < t; h4++)
      n2 = n2.dbl();
    i2.push(n2);
  }
  return { step: t, points: i2 };
}, Xt$3.prototype._getNAFPoints = function(t) {
  if (this.precomputed && this.precomputed.naf)
    return this.precomputed.naf;
  for (var r = [this], i2 = (1 << t) - 1, n2 = i2 === 1 ? null : this.dbl(), o2 = 1; o2 < i2; o2++)
    r[o2] = r[o2 - 1].add(n2);
  return { wnd: t, points: r };
}, Xt$3.prototype._getBeta = function() {
  return null;
}, Xt$3.prototype.dblp = function(t) {
  for (var r = this, i2 = 0; i2 < t; i2++)
    r = r.dbl();
  return r;
};
var Di = cr$2(function(e) {
  typeof Object.create == "function" ? e.exports = function(r, i2) {
    i2 && (r.super_ = i2, r.prototype = Object.create(i2.prototype, { constructor: { value: r, enumerable: false, writable: true, configurable: true } }));
  } : e.exports = function(r, i2) {
    if (i2) {
      r.super_ = i2;
      var n2 = function() {
      };
      n2.prototype = i2.prototype, r.prototype = new n2(), r.prototype.constructor = r;
    }
  };
}), Ua = Jt$3.assert;
function Zt$2(e) {
  Ze$2.call(this, "short", e), this.a = new K$3(e.a, 16).toRed(this.red), this.b = new K$3(e.b, 16).toRed(this.red), this.tinv = this.two.redInvm(), this.zeroA = this.a.fromRed().cmpn(0) === 0, this.threeA = this.a.fromRed().sub(this.p).cmpn(-3) === 0, this.endo = this._getEndomorphism(e), this._endoWnafT1 = new Array(4), this._endoWnafT2 = new Array(4);
}
Di(Zt$2, Ze$2);
var ka = Zt$2;
Zt$2.prototype._getEndomorphism = function(t) {
  if (!(!this.zeroA || !this.g || !this.n || this.p.modn(3) !== 1)) {
    var r, i2;
    if (t.beta)
      r = new K$3(t.beta, 16).toRed(this.red);
    else {
      var n2 = this._getEndoRoots(this.p);
      r = n2[0].cmp(n2[1]) < 0 ? n2[0] : n2[1], r = r.toRed(this.red);
    }
    if (t.lambda)
      i2 = new K$3(t.lambda, 16);
    else {
      var o2 = this._getEndoRoots(this.n);
      this.g.mul(o2[0]).x.cmp(this.g.x.redMul(r)) === 0 ? i2 = o2[0] : (i2 = o2[1], Ua(this.g.mul(i2).x.cmp(this.g.x.redMul(r)) === 0));
    }
    var h4;
    return t.basis ? h4 = t.basis.map(function(p3) {
      return { a: new K$3(p3.a, 16), b: new K$3(p3.b, 16) };
    }) : h4 = this._getEndoBasis(i2), { beta: r, lambda: i2, basis: h4 };
  }
}, Zt$2.prototype._getEndoRoots = function(t) {
  var r = t === this.p ? this.red : K$3.mont(t), i2 = new K$3(2).toRed(r).redInvm(), n2 = i2.redNeg(), o2 = new K$3(3).toRed(r).redNeg().redSqrt().redMul(i2), h4 = n2.redAdd(o2).fromRed(), p3 = n2.redSub(o2).fromRed();
  return [h4, p3];
}, Zt$2.prototype._getEndoBasis = function(t) {
  for (var r = this.n.ushrn(Math.floor(this.n.bitLength() / 2)), i2 = t, n2 = this.n.clone(), o2 = new K$3(1), h4 = new K$3(0), p3 = new K$3(0), b3 = new K$3(1), m3, w3, y3, S3, I2, N2, C2, F2 = 0, U2, J2; i2.cmpn(0) !== 0; ) {
    var Bt2 = n2.div(i2);
    U2 = n2.sub(Bt2.mul(i2)), J2 = p3.sub(Bt2.mul(o2));
    var G2 = b3.sub(Bt2.mul(h4));
    if (!y3 && U2.cmp(r) < 0)
      m3 = C2.neg(), w3 = o2, y3 = U2.neg(), S3 = J2;
    else if (y3 && ++F2 === 2)
      break;
    C2 = U2, n2 = i2, i2 = U2, p3 = o2, o2 = J2, b3 = h4, h4 = G2;
  }
  I2 = U2.neg(), N2 = J2;
  var H2 = y3.sqr().add(S3.sqr()), z2 = I2.sqr().add(N2.sqr());
  return z2.cmp(H2) >= 0 && (I2 = m3, N2 = w3), y3.negative && (y3 = y3.neg(), S3 = S3.neg()), I2.negative && (I2 = I2.neg(), N2 = N2.neg()), [{ a: y3, b: S3 }, { a: I2, b: N2 }];
}, Zt$2.prototype._endoSplit = function(t) {
  var r = this.endo.basis, i2 = r[0], n2 = r[1], o2 = n2.b.mul(t).divRound(this.n), h4 = i2.b.neg().mul(t).divRound(this.n), p3 = o2.mul(i2.a), b3 = h4.mul(n2.a), m3 = o2.mul(i2.b), w3 = h4.mul(n2.b), y3 = t.sub(p3).sub(b3), S3 = m3.add(w3).neg();
  return { k1: y3, k2: S3 };
}, Zt$2.prototype.pointFromX = function(t, r) {
  t = new K$3(t, 16), t.red || (t = t.toRed(this.red));
  var i2 = t.redSqr().redMul(t).redIAdd(t.redMul(this.a)).redIAdd(this.b), n2 = i2.redSqrt();
  if (n2.redSqr().redSub(i2).cmp(this.zero) !== 0)
    throw new Error("invalid point");
  var o2 = n2.fromRed().isOdd();
  return (r && !o2 || !r && o2) && (n2 = n2.redNeg()), this.point(t, n2);
}, Zt$2.prototype.validate = function(t) {
  if (t.inf)
    return true;
  var r = t.x, i2 = t.y, n2 = this.a.redMul(r), o2 = r.redSqr().redMul(r).redIAdd(n2).redIAdd(this.b);
  return i2.redSqr().redISub(o2).cmpn(0) === 0;
}, Zt$2.prototype._endoWnafMulAdd = function(t, r, i2) {
  for (var n2 = this._endoWnafT1, o2 = this._endoWnafT2, h4 = 0; h4 < t.length; h4++) {
    var p3 = this._endoSplit(r[h4]), b3 = t[h4], m3 = b3._getBeta();
    p3.k1.negative && (p3.k1.ineg(), b3 = b3.neg(true)), p3.k2.negative && (p3.k2.ineg(), m3 = m3.neg(true)), n2[h4 * 2] = b3, n2[h4 * 2 + 1] = m3, o2[h4 * 2] = p3.k1, o2[h4 * 2 + 1] = p3.k2;
  }
  for (var w3 = this._wnafMulAdd(1, n2, o2, h4 * 2, i2), y3 = 0; y3 < h4 * 2; y3++)
    n2[y3] = null, o2[y3] = null;
  return w3;
};
function Ft$2(e, t, r, i2) {
  Ze$2.BasePoint.call(this, e, "affine"), t === null && r === null ? (this.x = null, this.y = null, this.inf = true) : (this.x = new K$3(t, 16), this.y = new K$3(r, 16), i2 && (this.x.forceRed(this.curve.red), this.y.forceRed(this.curve.red)), this.x.red || (this.x = this.x.toRed(this.curve.red)), this.y.red || (this.y = this.y.toRed(this.curve.red)), this.inf = false);
}
Di(Ft$2, Ze$2.BasePoint), Zt$2.prototype.point = function(t, r, i2) {
  return new Ft$2(this, t, r, i2);
}, Zt$2.prototype.pointFromJSON = function(t, r) {
  return Ft$2.fromJSON(this, t, r);
}, Ft$2.prototype._getBeta = function() {
  if (this.curve.endo) {
    var t = this.precomputed;
    if (t && t.beta)
      return t.beta;
    var r = this.curve.point(this.x.redMul(this.curve.endo.beta), this.y);
    if (t) {
      var i2 = this.curve, n2 = function(o2) {
        return i2.point(o2.x.redMul(i2.endo.beta), o2.y);
      };
      t.beta = r, r.precomputed = { beta: null, naf: t.naf && { wnd: t.naf.wnd, points: t.naf.points.map(n2) }, doubles: t.doubles && { step: t.doubles.step, points: t.doubles.points.map(n2) } };
    }
    return r;
  }
}, Ft$2.prototype.toJSON = function() {
  return this.precomputed ? [this.x, this.y, this.precomputed && { doubles: this.precomputed.doubles && { step: this.precomputed.doubles.step, points: this.precomputed.doubles.points.slice(1) }, naf: this.precomputed.naf && { wnd: this.precomputed.naf.wnd, points: this.precomputed.naf.points.slice(1) } }] : [this.x, this.y];
}, Ft$2.fromJSON = function(t, r, i2) {
  typeof r == "string" && (r = JSON.parse(r));
  var n2 = t.point(r[0], r[1], i2);
  if (!r[2])
    return n2;
  function o2(p3) {
    return t.point(p3[0], p3[1], i2);
  }
  var h4 = r[2];
  return n2.precomputed = { beta: null, doubles: h4.doubles && { step: h4.doubles.step, points: [n2].concat(h4.doubles.points.map(o2)) }, naf: h4.naf && { wnd: h4.naf.wnd, points: [n2].concat(h4.naf.points.map(o2)) } }, n2;
}, Ft$2.prototype.inspect = function() {
  return this.isInfinity() ? "<EC Point Infinity>" : "<EC Point x: " + this.x.fromRed().toString(16, 2) + " y: " + this.y.fromRed().toString(16, 2) + ">";
}, Ft$2.prototype.isInfinity = function() {
  return this.inf;
}, Ft$2.prototype.add = function(t) {
  if (this.inf)
    return t;
  if (t.inf)
    return this;
  if (this.eq(t))
    return this.dbl();
  if (this.neg().eq(t))
    return this.curve.point(null, null);
  if (this.x.cmp(t.x) === 0)
    return this.curve.point(null, null);
  var r = this.y.redSub(t.y);
  r.cmpn(0) !== 0 && (r = r.redMul(this.x.redSub(t.x).redInvm()));
  var i2 = r.redSqr().redISub(this.x).redISub(t.x), n2 = r.redMul(this.x.redSub(i2)).redISub(this.y);
  return this.curve.point(i2, n2);
}, Ft$2.prototype.dbl = function() {
  if (this.inf)
    return this;
  var t = this.y.redAdd(this.y);
  if (t.cmpn(0) === 0)
    return this.curve.point(null, null);
  var r = this.curve.a, i2 = this.x.redSqr(), n2 = t.redInvm(), o2 = i2.redAdd(i2).redIAdd(i2).redIAdd(r).redMul(n2), h4 = o2.redSqr().redISub(this.x.redAdd(this.x)), p3 = o2.redMul(this.x.redSub(h4)).redISub(this.y);
  return this.curve.point(h4, p3);
}, Ft$2.prototype.getX = function() {
  return this.x.fromRed();
}, Ft$2.prototype.getY = function() {
  return this.y.fromRed();
}, Ft$2.prototype.mul = function(t) {
  return t = new K$3(t, 16), this.isInfinity() ? this : this._hasDoubles(t) ? this.curve._fixedNafMul(this, t) : this.curve.endo ? this.curve._endoWnafMulAdd([this], [t]) : this.curve._wnafMul(this, t);
}, Ft$2.prototype.mulAdd = function(t, r, i2) {
  var n2 = [this, r], o2 = [t, i2];
  return this.curve.endo ? this.curve._endoWnafMulAdd(n2, o2) : this.curve._wnafMulAdd(1, n2, o2, 2);
}, Ft$2.prototype.jmulAdd = function(t, r, i2) {
  var n2 = [this, r], o2 = [t, i2];
  return this.curve.endo ? this.curve._endoWnafMulAdd(n2, o2, true) : this.curve._wnafMulAdd(1, n2, o2, 2, true);
}, Ft$2.prototype.eq = function(t) {
  return this === t || this.inf === t.inf && (this.inf || this.x.cmp(t.x) === 0 && this.y.cmp(t.y) === 0);
}, Ft$2.prototype.neg = function(t) {
  if (this.inf)
    return this;
  var r = this.curve.point(this.x, this.y.redNeg());
  if (t && this.precomputed) {
    var i2 = this.precomputed, n2 = function(o2) {
      return o2.neg();
    };
    r.precomputed = { naf: i2.naf && { wnd: i2.naf.wnd, points: i2.naf.points.map(n2) }, doubles: i2.doubles && { step: i2.doubles.step, points: i2.doubles.points.map(n2) } };
  }
  return r;
}, Ft$2.prototype.toJ = function() {
  if (this.inf)
    return this.curve.jpoint(null, null, null);
  var t = this.curve.jpoint(this.x, this.y, this.curve.one);
  return t;
};
function Tt$2(e, t, r, i2) {
  Ze$2.BasePoint.call(this, e, "jacobian"), t === null && r === null && i2 === null ? (this.x = this.curve.one, this.y = this.curve.one, this.z = new K$3(0)) : (this.x = new K$3(t, 16), this.y = new K$3(r, 16), this.z = new K$3(i2, 16)), this.x.red || (this.x = this.x.toRed(this.curve.red)), this.y.red || (this.y = this.y.toRed(this.curve.red)), this.z.red || (this.z = this.z.toRed(this.curve.red)), this.zOne = this.z === this.curve.one;
}
Di(Tt$2, Ze$2.BasePoint), Zt$2.prototype.jpoint = function(t, r, i2) {
  return new Tt$2(this, t, r, i2);
}, Tt$2.prototype.toP = function() {
  if (this.isInfinity())
    return this.curve.point(null, null);
  var t = this.z.redInvm(), r = t.redSqr(), i2 = this.x.redMul(r), n2 = this.y.redMul(r).redMul(t);
  return this.curve.point(i2, n2);
}, Tt$2.prototype.neg = function() {
  return this.curve.jpoint(this.x, this.y.redNeg(), this.z);
}, Tt$2.prototype.add = function(t) {
  if (this.isInfinity())
    return t;
  if (t.isInfinity())
    return this;
  var r = t.z.redSqr(), i2 = this.z.redSqr(), n2 = this.x.redMul(r), o2 = t.x.redMul(i2), h4 = this.y.redMul(r.redMul(t.z)), p3 = t.y.redMul(i2.redMul(this.z)), b3 = n2.redSub(o2), m3 = h4.redSub(p3);
  if (b3.cmpn(0) === 0)
    return m3.cmpn(0) !== 0 ? this.curve.jpoint(null, null, null) : this.dbl();
  var w3 = b3.redSqr(), y3 = w3.redMul(b3), S3 = n2.redMul(w3), I2 = m3.redSqr().redIAdd(y3).redISub(S3).redISub(S3), N2 = m3.redMul(S3.redISub(I2)).redISub(h4.redMul(y3)), C2 = this.z.redMul(t.z).redMul(b3);
  return this.curve.jpoint(I2, N2, C2);
}, Tt$2.prototype.mixedAdd = function(t) {
  if (this.isInfinity())
    return t.toJ();
  if (t.isInfinity())
    return this;
  var r = this.z.redSqr(), i2 = this.x, n2 = t.x.redMul(r), o2 = this.y, h4 = t.y.redMul(r).redMul(this.z), p3 = i2.redSub(n2), b3 = o2.redSub(h4);
  if (p3.cmpn(0) === 0)
    return b3.cmpn(0) !== 0 ? this.curve.jpoint(null, null, null) : this.dbl();
  var m3 = p3.redSqr(), w3 = m3.redMul(p3), y3 = i2.redMul(m3), S3 = b3.redSqr().redIAdd(w3).redISub(y3).redISub(y3), I2 = b3.redMul(y3.redISub(S3)).redISub(o2.redMul(w3)), N2 = this.z.redMul(p3);
  return this.curve.jpoint(S3, I2, N2);
}, Tt$2.prototype.dblp = function(t) {
  if (t === 0)
    return this;
  if (this.isInfinity())
    return this;
  if (!t)
    return this.dbl();
  var r;
  if (this.curve.zeroA || this.curve.threeA) {
    var i2 = this;
    for (r = 0; r < t; r++)
      i2 = i2.dbl();
    return i2;
  }
  var n2 = this.curve.a, o2 = this.curve.tinv, h4 = this.x, p3 = this.y, b3 = this.z, m3 = b3.redSqr().redSqr(), w3 = p3.redAdd(p3);
  for (r = 0; r < t; r++) {
    var y3 = h4.redSqr(), S3 = w3.redSqr(), I2 = S3.redSqr(), N2 = y3.redAdd(y3).redIAdd(y3).redIAdd(n2.redMul(m3)), C2 = h4.redMul(S3), F2 = N2.redSqr().redISub(C2.redAdd(C2)), U2 = C2.redISub(F2), J2 = N2.redMul(U2);
    J2 = J2.redIAdd(J2).redISub(I2);
    var Bt2 = w3.redMul(b3);
    r + 1 < t && (m3 = m3.redMul(I2)), h4 = F2, b3 = Bt2, w3 = J2;
  }
  return this.curve.jpoint(h4, w3.redMul(o2), b3);
}, Tt$2.prototype.dbl = function() {
  return this.isInfinity() ? this : this.curve.zeroA ? this._zeroDbl() : this.curve.threeA ? this._threeDbl() : this._dbl();
}, Tt$2.prototype._zeroDbl = function() {
  var t, r, i2;
  if (this.zOne) {
    var n2 = this.x.redSqr(), o2 = this.y.redSqr(), h4 = o2.redSqr(), p3 = this.x.redAdd(o2).redSqr().redISub(n2).redISub(h4);
    p3 = p3.redIAdd(p3);
    var b3 = n2.redAdd(n2).redIAdd(n2), m3 = b3.redSqr().redISub(p3).redISub(p3), w3 = h4.redIAdd(h4);
    w3 = w3.redIAdd(w3), w3 = w3.redIAdd(w3), t = m3, r = b3.redMul(p3.redISub(m3)).redISub(w3), i2 = this.y.redAdd(this.y);
  } else {
    var y3 = this.x.redSqr(), S3 = this.y.redSqr(), I2 = S3.redSqr(), N2 = this.x.redAdd(S3).redSqr().redISub(y3).redISub(I2);
    N2 = N2.redIAdd(N2);
    var C2 = y3.redAdd(y3).redIAdd(y3), F2 = C2.redSqr(), U2 = I2.redIAdd(I2);
    U2 = U2.redIAdd(U2), U2 = U2.redIAdd(U2), t = F2.redISub(N2).redISub(N2), r = C2.redMul(N2.redISub(t)).redISub(U2), i2 = this.y.redMul(this.z), i2 = i2.redIAdd(i2);
  }
  return this.curve.jpoint(t, r, i2);
}, Tt$2.prototype._threeDbl = function() {
  var t, r, i2;
  if (this.zOne) {
    var n2 = this.x.redSqr(), o2 = this.y.redSqr(), h4 = o2.redSqr(), p3 = this.x.redAdd(o2).redSqr().redISub(n2).redISub(h4);
    p3 = p3.redIAdd(p3);
    var b3 = n2.redAdd(n2).redIAdd(n2).redIAdd(this.curve.a), m3 = b3.redSqr().redISub(p3).redISub(p3);
    t = m3;
    var w3 = h4.redIAdd(h4);
    w3 = w3.redIAdd(w3), w3 = w3.redIAdd(w3), r = b3.redMul(p3.redISub(m3)).redISub(w3), i2 = this.y.redAdd(this.y);
  } else {
    var y3 = this.z.redSqr(), S3 = this.y.redSqr(), I2 = this.x.redMul(S3), N2 = this.x.redSub(y3).redMul(this.x.redAdd(y3));
    N2 = N2.redAdd(N2).redIAdd(N2);
    var C2 = I2.redIAdd(I2);
    C2 = C2.redIAdd(C2);
    var F2 = C2.redAdd(C2);
    t = N2.redSqr().redISub(F2), i2 = this.y.redAdd(this.z).redSqr().redISub(S3).redISub(y3);
    var U2 = S3.redSqr();
    U2 = U2.redIAdd(U2), U2 = U2.redIAdd(U2), U2 = U2.redIAdd(U2), r = N2.redMul(C2.redISub(t)).redISub(U2);
  }
  return this.curve.jpoint(t, r, i2);
}, Tt$2.prototype._dbl = function() {
  var t = this.curve.a, r = this.x, i2 = this.y, n2 = this.z, o2 = n2.redSqr().redSqr(), h4 = r.redSqr(), p3 = i2.redSqr(), b3 = h4.redAdd(h4).redIAdd(h4).redIAdd(t.redMul(o2)), m3 = r.redAdd(r);
  m3 = m3.redIAdd(m3);
  var w3 = m3.redMul(p3), y3 = b3.redSqr().redISub(w3.redAdd(w3)), S3 = w3.redISub(y3), I2 = p3.redSqr();
  I2 = I2.redIAdd(I2), I2 = I2.redIAdd(I2), I2 = I2.redIAdd(I2);
  var N2 = b3.redMul(S3).redISub(I2), C2 = i2.redAdd(i2).redMul(n2);
  return this.curve.jpoint(y3, N2, C2);
}, Tt$2.prototype.trpl = function() {
  if (!this.curve.zeroA)
    return this.dbl().add(this);
  var t = this.x.redSqr(), r = this.y.redSqr(), i2 = this.z.redSqr(), n2 = r.redSqr(), o2 = t.redAdd(t).redIAdd(t), h4 = o2.redSqr(), p3 = this.x.redAdd(r).redSqr().redISub(t).redISub(n2);
  p3 = p3.redIAdd(p3), p3 = p3.redAdd(p3).redIAdd(p3), p3 = p3.redISub(h4);
  var b3 = p3.redSqr(), m3 = n2.redIAdd(n2);
  m3 = m3.redIAdd(m3), m3 = m3.redIAdd(m3), m3 = m3.redIAdd(m3);
  var w3 = o2.redIAdd(p3).redSqr().redISub(h4).redISub(b3).redISub(m3), y3 = r.redMul(w3);
  y3 = y3.redIAdd(y3), y3 = y3.redIAdd(y3);
  var S3 = this.x.redMul(b3).redISub(y3);
  S3 = S3.redIAdd(S3), S3 = S3.redIAdd(S3);
  var I2 = this.y.redMul(w3.redMul(m3.redISub(w3)).redISub(p3.redMul(b3)));
  I2 = I2.redIAdd(I2), I2 = I2.redIAdd(I2), I2 = I2.redIAdd(I2);
  var N2 = this.z.redAdd(p3).redSqr().redISub(i2).redISub(b3);
  return this.curve.jpoint(S3, I2, N2);
}, Tt$2.prototype.mul = function(t, r) {
  return t = new K$3(t, r), this.curve._wnafMul(this, t);
}, Tt$2.prototype.eq = function(t) {
  if (t.type === "affine")
    return this.eq(t.toJ());
  if (this === t)
    return true;
  var r = this.z.redSqr(), i2 = t.z.redSqr();
  if (this.x.redMul(i2).redISub(t.x.redMul(r)).cmpn(0) !== 0)
    return false;
  var n2 = r.redMul(this.z), o2 = i2.redMul(t.z);
  return this.y.redMul(o2).redISub(t.y.redMul(n2)).cmpn(0) === 0;
}, Tt$2.prototype.eqXToP = function(t) {
  var r = this.z.redSqr(), i2 = t.toRed(this.curve.red).redMul(r);
  if (this.x.cmp(i2) === 0)
    return true;
  for (var n2 = t.clone(), o2 = this.curve.redN.redMul(r); ; ) {
    if (n2.iadd(this.curve.n), n2.cmp(this.curve.p) >= 0)
      return false;
    if (i2.redIAdd(o2), this.x.cmp(i2) === 0)
      return true;
  }
}, Tt$2.prototype.inspect = function() {
  return this.isInfinity() ? "<EC JPoint Infinity>" : "<EC JPoint x: " + this.x.toString(16, 2) + " y: " + this.y.toString(16, 2) + " z: " + this.z.toString(16, 2) + ">";
}, Tt$2.prototype.isInfinity = function() {
  return this.z.cmpn(0) === 0;
};
var qr = cr$2(function(e, t) {
  var r = t;
  r.base = Ze$2, r.short = ka, r.mont = null, r.edwards = null;
}), Kr = cr$2(function(e, t) {
  var r = t, i2 = Jt$3.assert;
  function n2(p3) {
    p3.type === "short" ? this.curve = new qr.short(p3) : p3.type === "edwards" ? this.curve = new qr.edwards(p3) : this.curve = new qr.mont(p3), this.g = this.curve.g, this.n = this.curve.n, this.hash = p3.hash, i2(this.g.validate(), "Invalid curve"), i2(this.g.mul(this.n).isInfinity(), "Invalid curve, G*N != O");
  }
  r.PresetCurve = n2;
  function o2(p3, b3) {
    Object.defineProperty(r, p3, { configurable: true, enumerable: true, get: function() {
      var m3 = new n2(b3);
      return Object.defineProperty(r, p3, { configurable: true, enumerable: true, value: m3 }), m3;
    } });
  }
  o2("p192", { type: "short", prime: "p192", p: "ffffffff ffffffff ffffffff fffffffe ffffffff ffffffff", a: "ffffffff ffffffff ffffffff fffffffe ffffffff fffffffc", b: "64210519 e59c80e7 0fa7e9ab 72243049 feb8deec c146b9b1", n: "ffffffff ffffffff ffffffff 99def836 146bc9b1 b4d22831", hash: se$3.sha256, gRed: false, g: ["188da80e b03090f6 7cbf20eb 43a18800 f4ff0afd 82ff1012", "07192b95 ffc8da78 631011ed 6b24cdd5 73f977a1 1e794811"] }), o2("p224", { type: "short", prime: "p224", p: "ffffffff ffffffff ffffffff ffffffff 00000000 00000000 00000001", a: "ffffffff ffffffff ffffffff fffffffe ffffffff ffffffff fffffffe", b: "b4050a85 0c04b3ab f5413256 5044b0b7 d7bfd8ba 270b3943 2355ffb4", n: "ffffffff ffffffff ffffffff ffff16a2 e0b8f03e 13dd2945 5c5c2a3d", hash: se$3.sha256, gRed: false, g: ["b70e0cbd 6bb4bf7f 321390b9 4a03c1d3 56c21122 343280d6 115c1d21", "bd376388 b5f723fb 4c22dfe6 cd4375a0 5a074764 44d58199 85007e34"] }), o2("p256", { type: "short", prime: null, p: "ffffffff 00000001 00000000 00000000 00000000 ffffffff ffffffff ffffffff", a: "ffffffff 00000001 00000000 00000000 00000000 ffffffff ffffffff fffffffc", b: "5ac635d8 aa3a93e7 b3ebbd55 769886bc 651d06b0 cc53b0f6 3bce3c3e 27d2604b", n: "ffffffff 00000000 ffffffff ffffffff bce6faad a7179e84 f3b9cac2 fc632551", hash: se$3.sha256, gRed: false, g: ["6b17d1f2 e12c4247 f8bce6e5 63a440f2 77037d81 2deb33a0 f4a13945 d898c296", "4fe342e2 fe1a7f9b 8ee7eb4a 7c0f9e16 2bce3357 6b315ece cbb64068 37bf51f5"] }), o2("p384", { type: "short", prime: null, p: "ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff fffffffe ffffffff 00000000 00000000 ffffffff", a: "ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff fffffffe ffffffff 00000000 00000000 fffffffc", b: "b3312fa7 e23ee7e4 988e056b e3f82d19 181d9c6e fe814112 0314088f 5013875a c656398d 8a2ed19d 2a85c8ed d3ec2aef", n: "ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff c7634d81 f4372ddf 581a0db2 48b0a77a ecec196a ccc52973", hash: se$3.sha384, gRed: false, g: ["aa87ca22 be8b0537 8eb1c71e f320ad74 6e1d3b62 8ba79b98 59f741e0 82542a38 5502f25d bf55296c 3a545e38 72760ab7", "3617de4a 96262c6f 5d9e98bf 9292dc29 f8f41dbd 289a147c e9da3113 b5f0b8c0 0a60b1ce 1d7e819d 7a431d7c 90ea0e5f"] }), o2("p521", { type: "short", prime: null, p: "000001ff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff", a: "000001ff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff fffffffc", b: "00000051 953eb961 8e1c9a1f 929a21a0 b68540ee a2da725b 99b315f3 b8b48991 8ef109e1 56193951 ec7e937b 1652c0bd 3bb1bf07 3573df88 3d2c34f1 ef451fd4 6b503f00", n: "000001ff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff fffffffa 51868783 bf2f966b 7fcc0148 f709a5d0 3bb5c9b8 899c47ae bb6fb71e 91386409", hash: se$3.sha512, gRed: false, g: ["000000c6 858e06b7 0404e9cd 9e3ecb66 2395b442 9c648139 053fb521 f828af60 6b4d3dba a14b5e77 efe75928 fe1dc127 a2ffa8de 3348b3c1 856a429b f97e7e31 c2e5bd66", "00000118 39296a78 9a3bc004 5c8a5fb4 2c7d1bd9 98f54449 579b4468 17afbd17 273e662c 97ee7299 5ef42640 c550b901 3fad0761 353c7086 a272c240 88be9476 9fd16650"] }), o2("curve25519", { type: "mont", prime: "p25519", p: "7fffffffffffffff ffffffffffffffff ffffffffffffffff ffffffffffffffed", a: "76d06", b: "1", n: "1000000000000000 0000000000000000 14def9dea2f79cd6 5812631a5cf5d3ed", hash: se$3.sha256, gRed: false, g: ["9"] }), o2("ed25519", { type: "edwards", prime: "p25519", p: "7fffffffffffffff ffffffffffffffff ffffffffffffffff ffffffffffffffed", a: "-1", c: "1", d: "52036cee2b6ffe73 8cc740797779e898 00700a4d4141d8ab 75eb4dca135978a3", n: "1000000000000000 0000000000000000 14def9dea2f79cd6 5812631a5cf5d3ed", hash: se$3.sha256, gRed: false, g: ["216936d3cd6e53fec0a4e231fdd6dc5c692cc7609525a7b2c9562d608f25d51a", "6666666666666666666666666666666666666666666666666666666666666658"] });
  var h4;
  try {
    h4 = null.crash();
  } catch {
    h4 = void 0;
  }
  o2("secp256k1", { type: "short", prime: "k256", p: "ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff fffffffe fffffc2f", a: "0", b: "7", n: "ffffffff ffffffff ffffffff fffffffe baaedce6 af48a03b bfd25e8c d0364141", h: "1", hash: se$3.sha256, beta: "7ae96a2b657c07106e64479eac3434e99cf0497512f58995c1396c28719501ee", lambda: "5363ad4cc05c30e0a5261c028812645a122e22ea20816678df02967c1b23bd72", basis: [{ a: "3086d221a7d46bcde86c90e49284eb15", b: "-e4437ed6010e88286f547fa90abfe4c3" }, { a: "114ca50f7a8e2f3f657c1108d9d44cfd8", b: "3086d221a7d46bcde86c90e49284eb15" }], gRed: false, g: ["79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798", "483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8", h4] });
});
function Re$1(e) {
  if (!(this instanceof Re$1))
    return new Re$1(e);
  this.hash = e.hash, this.predResist = !!e.predResist, this.outLen = this.hash.outSize, this.minEntropy = e.minEntropy || this.hash.hmacStrength, this._reseed = null, this.reseedInterval = null, this.K = null, this.V = null;
  var t = fe$2.toArray(e.entropy, e.entropyEnc || "hex"), r = fe$2.toArray(e.nonce, e.nonceEnc || "hex"), i2 = fe$2.toArray(e.pers, e.persEnc || "hex");
  Pi(t.length >= this.minEntropy / 8, "Not enough entropy. Minimum is: " + this.minEntropy + " bits"), this._init(t, r, i2);
}
var Rf = Re$1;
Re$1.prototype._init = function(t, r, i2) {
  var n2 = t.concat(r).concat(i2);
  this.K = new Array(this.outLen / 8), this.V = new Array(this.outLen / 8);
  for (var o2 = 0; o2 < this.V.length; o2++)
    this.K[o2] = 0, this.V[o2] = 1;
  this._update(n2), this._reseed = 1, this.reseedInterval = 281474976710656;
}, Re$1.prototype._hmac = function() {
  return new se$3.hmac(this.hash, this.K);
}, Re$1.prototype._update = function(t) {
  var r = this._hmac().update(this.V).update([0]);
  t && (r = r.update(t)), this.K = r.digest(), this.V = this._hmac().update(this.V).digest(), t && (this.K = this._hmac().update(this.V).update([1]).update(t).digest(), this.V = this._hmac().update(this.V).digest());
}, Re$1.prototype.reseed = function(t, r, i2, n2) {
  typeof r != "string" && (n2 = i2, i2 = r, r = null), t = fe$2.toArray(t, r), i2 = fe$2.toArray(i2, n2), Pi(t.length >= this.minEntropy / 8, "Not enough entropy. Minimum is: " + this.minEntropy + " bits"), this._update(t.concat(i2 || [])), this._reseed = 1;
}, Re$1.prototype.generate = function(t, r, i2, n2) {
  if (this._reseed > this.reseedInterval)
    throw new Error("Reseed is required");
  typeof r != "string" && (n2 = i2, i2 = r, r = null), i2 && (i2 = fe$2.toArray(i2, n2 || "hex"), this._update(i2));
  for (var o2 = []; o2.length < t; )
    this.V = this._hmac().update(this.V).digest(), o2 = o2.concat(this.V);
  var h4 = o2.slice(0, t);
  return this._update(i2), this._reseed++, fe$2.encode(h4, r);
};
var Fi = Jt$3.assert;
function kt$2(e, t) {
  this.ec = e, this.priv = null, this.pub = null, t.priv && this._importPrivate(t.priv, t.privEnc), t.pub && this._importPublic(t.pub, t.pubEnc);
}
var Ti = kt$2;
kt$2.fromPublic = function(t, r, i2) {
  return r instanceof kt$2 ? r : new kt$2(t, { pub: r, pubEnc: i2 });
}, kt$2.fromPrivate = function(t, r, i2) {
  return r instanceof kt$2 ? r : new kt$2(t, { priv: r, privEnc: i2 });
}, kt$2.prototype.validate = function() {
  var t = this.getPublic();
  return t.isInfinity() ? { result: false, reason: "Invalid public key" } : t.validate() ? t.mul(this.ec.curve.n).isInfinity() ? { result: true, reason: null } : { result: false, reason: "Public key * N != O" } : { result: false, reason: "Public key is not a point" };
}, kt$2.prototype.getPublic = function(t, r) {
  return typeof t == "string" && (r = t, t = null), this.pub || (this.pub = this.ec.g.mul(this.priv)), r ? this.pub.encode(r, t) : this.pub;
}, kt$2.prototype.getPrivate = function(t) {
  return t === "hex" ? this.priv.toString(16, 2) : this.priv;
}, kt$2.prototype._importPrivate = function(t, r) {
  this.priv = new K$3(t, r || 16), this.priv = this.priv.umod(this.ec.curve.n);
}, kt$2.prototype._importPublic = function(t, r) {
  if (t.x || t.y) {
    this.ec.curve.type === "mont" ? Fi(t.x, "Need x coordinate") : (this.ec.curve.type === "short" || this.ec.curve.type === "edwards") && Fi(t.x && t.y, "Need both x and y coordinate"), this.pub = this.ec.curve.point(t.x, t.y);
    return;
  }
  this.pub = this.ec.curve.decodePoint(t, r);
}, kt$2.prototype.derive = function(t) {
  return t.validate() || Fi(t.validate(), "public point not validated"), t.mul(this.priv).getX();
}, kt$2.prototype.sign = function(t, r, i2) {
  return this.ec.sign(t, this, r, i2);
}, kt$2.prototype.verify = function(t, r) {
  return this.ec.verify(t, r, this);
}, kt$2.prototype.inspect = function() {
  return "<Key priv: " + (this.priv && this.priv.toString(16, 2)) + " pub: " + (this.pub && this.pub.inspect()) + " >";
};
var qa = Jt$3.assert;
function Hr(e, t) {
  if (e instanceof Hr)
    return e;
  this._importDER(e, t) || (qa(e.r && e.s, "Signature without r or s"), this.r = new K$3(e.r, 16), this.s = new K$3(e.s, 16), e.recoveryParam === void 0 ? this.recoveryParam = null : this.recoveryParam = e.recoveryParam);
}
var zr$2 = Hr;
function Ka() {
  this.place = 0;
}
function Ui(e, t) {
  var r = e[t.place++];
  if (!(r & 128))
    return r;
  var i2 = r & 15;
  if (i2 === 0 || i2 > 4)
    return false;
  for (var n2 = 0, o2 = 0, h4 = t.place; o2 < i2; o2++, h4++)
    n2 <<= 8, n2 |= e[h4], n2 >>>= 0;
  return n2 <= 127 ? false : (t.place = h4, n2);
}
function Of(e) {
  for (var t = 0, r = e.length - 1; !e[t] && !(e[t + 1] & 128) && t < r; )
    t++;
  return t === 0 ? e : e.slice(t);
}
Hr.prototype._importDER = function(t, r) {
  t = Jt$3.toArray(t, r);
  var i2 = new Ka();
  if (t[i2.place++] !== 48)
    return false;
  var n2 = Ui(t, i2);
  if (n2 === false || n2 + i2.place !== t.length || t[i2.place++] !== 2)
    return false;
  var o2 = Ui(t, i2);
  if (o2 === false)
    return false;
  var h4 = t.slice(i2.place, o2 + i2.place);
  if (i2.place += o2, t[i2.place++] !== 2)
    return false;
  var p3 = Ui(t, i2);
  if (p3 === false || t.length !== p3 + i2.place)
    return false;
  var b3 = t.slice(i2.place, p3 + i2.place);
  if (h4[0] === 0)
    if (h4[1] & 128)
      h4 = h4.slice(1);
    else
      return false;
  if (b3[0] === 0)
    if (b3[1] & 128)
      b3 = b3.slice(1);
    else
      return false;
  return this.r = new K$3(h4), this.s = new K$3(b3), this.recoveryParam = null, true;
};
function ki(e, t) {
  if (t < 128) {
    e.push(t);
    return;
  }
  var r = 1 + (Math.log(t) / Math.LN2 >>> 3);
  for (e.push(r | 128); --r; )
    e.push(t >>> (r << 3) & 255);
  e.push(t);
}
Hr.prototype.toDER = function(t) {
  var r = this.r.toArray(), i2 = this.s.toArray();
  for (r[0] & 128 && (r = [0].concat(r)), i2[0] & 128 && (i2 = [0].concat(i2)), r = Of(r), i2 = Of(i2); !i2[0] && !(i2[1] & 128); )
    i2 = i2.slice(1);
  var n2 = [2];
  ki(n2, r.length), n2 = n2.concat(r), n2.push(2), ki(n2, i2.length);
  var o2 = n2.concat(i2), h4 = [48];
  return ki(h4, o2.length), h4 = h4.concat(o2), Jt$3.encode(h4, t);
};
var Ha = function() {
  throw new Error("unsupported");
}, Pf = Jt$3.assert;
function $t$2(e) {
  if (!(this instanceof $t$2))
    return new $t$2(e);
  typeof e == "string" && (Pf(Object.prototype.hasOwnProperty.call(Kr, e), "Unknown curve " + e), e = Kr[e]), e instanceof Kr.PresetCurve && (e = { curve: e }), this.curve = e.curve.curve, this.n = this.curve.n, this.nh = this.n.ushrn(1), this.g = this.curve.g, this.g = e.curve.g, this.g.precompute(e.curve.n.bitLength() + 1), this.hash = e.hash || e.curve.hash;
}
var za = $t$2;
$t$2.prototype.keyPair = function(t) {
  return new Ti(this, t);
}, $t$2.prototype.keyFromPrivate = function(t, r) {
  return Ti.fromPrivate(this, t, r);
}, $t$2.prototype.keyFromPublic = function(t, r) {
  return Ti.fromPublic(this, t, r);
}, $t$2.prototype.genKeyPair = function(t) {
  t || (t = {});
  for (var r = new Rf({ hash: this.hash, pers: t.pers, persEnc: t.persEnc || "utf8", entropy: t.entropy || Ha(this.hash.hmacStrength), entropyEnc: t.entropy && t.entropyEnc || "utf8", nonce: this.n.toArray() }), i2 = this.n.byteLength(), n2 = this.n.sub(new K$3(2)); ; ) {
    var o2 = new K$3(r.generate(i2));
    if (!(o2.cmp(n2) > 0))
      return o2.iaddn(1), this.keyFromPrivate(o2);
  }
}, $t$2.prototype._truncateToN = function(t, r) {
  var i2 = t.byteLength() * 8 - this.n.bitLength();
  return i2 > 0 && (t = t.ushrn(i2)), !r && t.cmp(this.n) >= 0 ? t.sub(this.n) : t;
}, $t$2.prototype.sign = function(t, r, i2, n2) {
  typeof i2 == "object" && (n2 = i2, i2 = null), n2 || (n2 = {}), r = this.keyFromPrivate(r, i2), t = this._truncateToN(new K$3(t, 16));
  for (var o2 = this.n.byteLength(), h4 = r.getPrivate().toArray("be", o2), p3 = t.toArray("be", o2), b3 = new Rf({ hash: this.hash, entropy: h4, nonce: p3, pers: n2.pers, persEnc: n2.persEnc || "utf8" }), m3 = this.n.sub(new K$3(1)), w3 = 0; ; w3++) {
    var y3 = n2.k ? n2.k(w3) : new K$3(b3.generate(this.n.byteLength()));
    if (y3 = this._truncateToN(y3, true), !(y3.cmpn(1) <= 0 || y3.cmp(m3) >= 0)) {
      var S3 = this.g.mul(y3);
      if (!S3.isInfinity()) {
        var I2 = S3.getX(), N2 = I2.umod(this.n);
        if (N2.cmpn(0) !== 0) {
          var C2 = y3.invm(this.n).mul(N2.mul(r.getPrivate()).iadd(t));
          if (C2 = C2.umod(this.n), C2.cmpn(0) !== 0) {
            var F2 = (S3.getY().isOdd() ? 1 : 0) | (I2.cmp(N2) !== 0 ? 2 : 0);
            return n2.canonical && C2.cmp(this.nh) > 0 && (C2 = this.n.sub(C2), F2 ^= 1), new zr$2({ r: N2, s: C2, recoveryParam: F2 });
          }
        }
      }
    }
  }
}, $t$2.prototype.verify = function(t, r, i2, n2) {
  t = this._truncateToN(new K$3(t, 16)), i2 = this.keyFromPublic(i2, n2), r = new zr$2(r, "hex");
  var o2 = r.r, h4 = r.s;
  if (o2.cmpn(1) < 0 || o2.cmp(this.n) >= 0 || h4.cmpn(1) < 0 || h4.cmp(this.n) >= 0)
    return false;
  var p3 = h4.invm(this.n), b3 = p3.mul(t).umod(this.n), m3 = p3.mul(o2).umod(this.n), w3;
  return this.curve._maxwellTrick ? (w3 = this.g.jmulAdd(b3, i2.getPublic(), m3), w3.isInfinity() ? false : w3.eqXToP(o2)) : (w3 = this.g.mulAdd(b3, i2.getPublic(), m3), w3.isInfinity() ? false : w3.getX().umod(this.n).cmp(o2) === 0);
}, $t$2.prototype.recoverPubKey = function(e, t, r, i2) {
  Pf((3 & r) === r, "The recovery param is more than two bits"), t = new zr$2(t, i2);
  var n2 = this.n, o2 = new K$3(e), h4 = t.r, p3 = t.s, b3 = r & 1, m3 = r >> 1;
  if (h4.cmp(this.curve.p.umod(this.curve.n)) >= 0 && m3)
    throw new Error("Unable to find sencond key candinate");
  m3 ? h4 = this.curve.pointFromX(h4.add(this.curve.n), b3) : h4 = this.curve.pointFromX(h4, b3);
  var w3 = t.r.invm(n2), y3 = n2.sub(o2).mul(w3).umod(n2), S3 = p3.mul(w3).umod(n2);
  return this.g.mulAdd(y3, h4, S3);
}, $t$2.prototype.getKeyRecoveryParam = function(e, t, r, i2) {
  if (t = new zr$2(t, i2), t.recoveryParam !== null)
    return t.recoveryParam;
  for (var n2 = 0; n2 < 4; n2++) {
    var o2;
    try {
      o2 = this.recoverPubKey(e, t, n2);
    } catch {
      continue;
    }
    if (o2.eq(r))
      return n2;
  }
  throw new Error("Unable to find valid recovery factor");
};
var La = cr$2(function(e, t) {
  var r = t;
  r.version = "6.5.4", r.utils = Jt$3, r.rand = function() {
    throw new Error("unsupported");
  }, r.curve = qr, r.curves = Kr, r.ec = za, r.eddsa = null;
}), ja = La.ec;
const Qa = "signing-key/5.7.0", qi = new L$3(Qa);
let Ki = null;
function ve() {
  return Ki || (Ki = new ja("secp256k1")), Ki;
}
class Ja {
  constructor(t) {
    br$2(this, "curve", "secp256k1"), br$2(this, "privateKey", Kt$2(t)), N0(this.privateKey) !== 32 && qi.throwArgumentError("invalid private key", "privateKey", "[[ REDACTED ]]");
    const r = ve().keyFromPrivate(Ot$2(this.privateKey));
    br$2(this, "publicKey", "0x" + r.getPublic(false, "hex")), br$2(this, "compressedPublicKey", "0x" + r.getPublic(true, "hex")), br$2(this, "_isSigningKey", true);
  }
  _addPoint(t) {
    const r = ve().keyFromPublic(Ot$2(this.publicKey)), i2 = ve().keyFromPublic(Ot$2(t));
    return "0x" + r.pub.add(i2.pub).encodeCompressed("hex");
  }
  signDigest(t) {
    const r = ve().keyFromPrivate(Ot$2(this.privateKey)), i2 = Ot$2(t);
    i2.length !== 32 && qi.throwArgumentError("bad digest length", "digest", t);
    const n2 = r.sign(i2, { canonical: true });
    return zn({ recoveryParam: n2.recoveryParam, r: oe$1("0x" + n2.r.toString(16), 32), s: oe$1("0x" + n2.s.toString(16), 32) });
  }
  computeSharedSecret(t) {
    const r = ve().keyFromPrivate(Ot$2(this.privateKey)), i2 = ve().keyFromPublic(Ot$2(Df(t)));
    return oe$1("0x" + r.derive(i2.getPublic()).toString(16), 32);
  }
  static isSigningKey(t) {
    return !!(t && t._isSigningKey);
  }
}
function Ga(e, t) {
  const r = zn(t), i2 = { r: Ot$2(r.r), s: Ot$2(r.s) };
  return "0x" + ve().recoverPubKey(Ot$2(e), i2, r.recoveryParam).encode("hex", false);
}
function Df(e, t) {
  const r = Ot$2(e);
  if (r.length === 32) {
    const i2 = new Ja(r);
    return t ? "0x" + ve().keyFromPrivate(r).getPublic(true, "hex") : i2.publicKey;
  } else {
    if (r.length === 33)
      return t ? Kt$2(r) : "0x" + ve().keyFromPublic(r).getPublic(false, "hex");
    if (r.length === 65)
      return t ? "0x" + ve().keyFromPublic(r).getPublic(true, "hex") : Kt$2(r);
  }
  return qi.throwArgumentError("invalid public or private key", "key", "[REDACTED]");
}
var Ff;
(function(e) {
  e[e.legacy = 0] = "legacy", e[e.eip2930 = 1] = "eip2930", e[e.eip1559 = 2] = "eip1559";
})(Ff || (Ff = {}));
function Va(e) {
  const t = Df(e);
  return ns$2(Hn(yi(Hn(t, 1)), 12));
}
function Wa(e, t) {
  return Va(Ga(Ot$2(e), t));
}
const Xa = "https://rpc.walletconnect.com/v1";
async function Tf(e, t, r, i2, n2, o2) {
  switch (r.t) {
    case "eip191":
      return Uf(e, t, r.s);
    case "eip1271":
      return await kf(e, t, r.s, i2, n2, o2);
    default:
      throw new Error(`verifySignature failed: Attempted to verify CacaoSignature with unknown type: ${r.t}`);
  }
}
function Uf(e, t, r) {
  return Wa(ff(t), r).toLowerCase() === e.toLowerCase();
}
async function kf(e, t, r, i2, n2, o2) {
  try {
    const h4 = "0x1626ba7e", p3 = "0000000000000000000000000000000000000000000000000000000000000040", b3 = "0000000000000000000000000000000000000000000000000000000000000041", m3 = r.substring(2), w3 = ff(t).substring(2), y3 = h4 + w3 + p3 + b3 + m3, S3 = await fetch(`${o2 || Xa}/?chainId=${i2}&projectId=${n2}`, { method: "POST", body: JSON.stringify({ id: Za(), jsonrpc: "2.0", method: "eth_call", params: [{ to: e, data: y3 }, "latest"] }) }), { result: I2 } = await S3.json();
    return I2 ? I2.slice(0, h4.length).toLowerCase() === h4.toLowerCase() : false;
  } catch (h4) {
    return console.error("isValidEip1271Signature: ", h4), false;
  }
}
function Za() {
  return Date.now() + Math.floor(Math.random() * 1e3);
}
var $a = Object.defineProperty, tu = Object.defineProperties, eu = Object.getOwnPropertyDescriptors, qf = Object.getOwnPropertySymbols, ru = Object.prototype.hasOwnProperty, iu = Object.prototype.propertyIsEnumerable, Kf = (e, t, r) => t in e ? $a(e, t, { enumerable: true, configurable: true, writable: true, value: r }) : e[t] = r, Hi = (e, t) => {
  for (var r in t || (t = {}))
    ru.call(t, r) && Kf(e, r, t[r]);
  if (qf)
    for (var r of qf(t))
      iu.call(t, r) && Kf(e, r, t[r]);
  return e;
}, Hf = (e, t) => tu(e, eu(t));
const nu = "did:pkh:", Lr$1 = (e) => e == null ? void 0 : e.split(":"), zi = (e) => {
  const t = e && Lr$1(e);
  if (t)
    return e.includes(nu) ? t[3] : t[1];
}, fu = (e) => {
  const t = e && Lr$1(e);
  if (t)
    return t[2] + ":" + t[3];
}, Li = (e) => {
  const t = e && Lr$1(e);
  if (t)
    return t.pop();
};
async function ou(e) {
  const { cacao: t, projectId: r } = e, { s: i2, p: n2 } = t, o2 = zf(n2, n2.iss), h4 = Li(n2.iss);
  return await Tf(h4, o2, i2, zi(n2.iss), r);
}
const zf = (e, t) => {
  const r = `${e.domain} wants you to sign in with your Ethereum account:`, i2 = Li(t);
  if (!e.aud && !e.uri)
    throw new Error("Either `aud` or `uri` is required to construct the message");
  let n2 = e.statement || void 0;
  const o2 = `URI: ${e.aud || e.uri}`, h4 = `Version: ${e.version}`, p3 = `Chain ID: ${zi(t)}`, b3 = `Nonce: ${e.nonce}`, m3 = `Issued At: ${e.iat}`, w3 = e.resources ? `Resources:${e.resources.map((S3) => `
- ${S3}`).join("")}` : void 0, y3 = Qr(e.resources);
  if (y3) {
    const S3 = Oe(y3);
    n2 = Ji$1(n2, S3);
  }
  return [r, i2, "", n2, "", o2, h4, p3, b3, m3, w3].filter((S3) => S3 != null).join(`
`);
};
function Jf(e) {
  return Buffer$1.from(JSON.stringify(e)).toString("base64");
}
function Gf(e) {
  return JSON.parse(Buffer$1.from(e, "base64").toString("utf-8"));
}
function me$2(e) {
  if (!e)
    throw new Error("No recap provided, value is undefined");
  if (!e.att)
    throw new Error("No `att` property found");
  const t = Object.keys(e.att);
  if (!(t != null && t.length))
    throw new Error("No resources found in `att` property");
  t.forEach((r) => {
    const i2 = e.att[r];
    if (Array.isArray(i2))
      throw new Error(`Resource must be an object: ${r}`);
    if (typeof i2 != "object")
      throw new Error(`Resource must be an object: ${r}`);
    if (!Object.keys(i2).length)
      throw new Error(`Resource object is empty: ${r}`);
    Object.keys(i2).forEach((n2) => {
      const o2 = i2[n2];
      if (!Array.isArray(o2))
        throw new Error(`Ability limits ${n2} must be an array of objects, found: ${o2}`);
      if (!o2.length)
        throw new Error(`Value of ${n2} is empty array, must be an array with objects`);
      o2.forEach((h4) => {
        if (typeof h4 != "object")
          throw new Error(`Ability limits (${n2}) must be an array of objects, found: ${h4}`);
      });
    });
  });
}
function Yf(e, t, r, i2 = {}) {
  return r == null ? void 0 : r.sort((n2, o2) => n2.localeCompare(o2)), { att: { [e]: ji(t, r, i2) } };
}
function ji(e, t, r = {}) {
  t = t == null ? void 0 : t.sort((n2, o2) => n2.localeCompare(o2));
  const i2 = t.map((n2) => ({ [`${e}/${n2}`]: [r] }));
  return Object.assign({}, ...i2);
}
function jr(e) {
  return me$2(e), `urn:recap:${Jf(e).replace(/=/g, "")}`;
}
function Oe(e) {
  const t = Gf(e.replace("urn:recap:", ""));
  return me$2(t), t;
}
function cu(e, t, r) {
  const i2 = Yf(e, t, r);
  return jr(i2);
}
function Qi$1(e) {
  return e && e.includes("urn:recap:");
}
function lu(e, t) {
  const r = Oe(e), i2 = Oe(t), n2 = Wf(r, i2);
  return jr(n2);
}
function Wf(e, t) {
  me$2(e), me$2(t);
  const r = Object.keys(e.att).concat(Object.keys(t.att)).sort((n2, o2) => n2.localeCompare(o2)), i2 = { att: {} };
  return r.forEach((n2) => {
    var o2, h4;
    Object.keys(((o2 = e.att) == null ? void 0 : o2[n2]) || {}).concat(Object.keys(((h4 = t.att) == null ? void 0 : h4[n2]) || {})).sort((p3, b3) => p3.localeCompare(b3)).forEach((p3) => {
      var b3, m3;
      i2.att[n2] = Hf(Hi({}, i2.att[n2]), { [p3]: ((b3 = e.att[n2]) == null ? void 0 : b3[p3]) || ((m3 = t.att[n2]) == null ? void 0 : m3[p3]) });
    });
  }), i2;
}
function Ji$1(e = "", t) {
  me$2(t);
  const r = "I further authorize the stated URI to perform the following actions on my behalf: ";
  if (e.includes(r))
    return e;
  const i2 = [];
  let n2 = 0;
  Object.keys(t.att).forEach((p3) => {
    const b3 = Object.keys(t.att[p3]).map((y3) => ({ ability: y3.split("/")[0], action: y3.split("/")[1] }));
    b3.sort((y3, S3) => y3.action.localeCompare(S3.action));
    const m3 = {};
    b3.forEach((y3) => {
      m3[y3.ability] || (m3[y3.ability] = []), m3[y3.ability].push(y3.action);
    });
    const w3 = Object.keys(m3).map((y3) => (n2++, `(${n2}) '${y3}': '${m3[y3].join("', '")}' for '${p3}'.`));
    i2.push(w3.join(", ").replace(".,", "."));
  });
  const o2 = i2.join(" "), h4 = `${r}${o2}`;
  return `${e ? e + " " : ""}${h4}`;
}
function du(e) {
  var t;
  const r = Oe(e);
  me$2(r);
  const i2 = (t = r.att) == null ? void 0 : t.eip155;
  return i2 ? Object.keys(i2).map((n2) => n2.split("/")[1]) : [];
}
function pu(e) {
  const t = Oe(e);
  me$2(t);
  const r = [];
  return Object.values(t.att).forEach((i2) => {
    Object.values(i2).forEach((n2) => {
      var o2;
      (o2 = n2 == null ? void 0 : n2[0]) != null && o2.chains && r.push(n2[0].chains);
    });
  }), [...new Set(r.flat())];
}
function Qr(e) {
  if (!e)
    return;
  const t = e == null ? void 0 : e[e.length - 1];
  return Qi$1(t) ? t : void 0;
}
const Gi = "base10", zt$2 = "base16", Jr = "base64pad", Gr = "utf8", Yi$1 = 0, lr$2 = 1, vu = 0, Zf = 1, Vi = 12, Wi$1 = 32;
function mu() {
  const e = x25519.generateKeyPair();
  return { privateKey: toString(e.secretKey, zt$2), publicKey: toString(e.publicKey, zt$2) };
}
function gu() {
  const e = random.randomBytes(Wi$1);
  return toString(e, zt$2);
}
function Au(e, t) {
  const r = x25519.sharedKey(fromString(e, zt$2), fromString(t, zt$2), true), i2 = new HKDF_1(sha256.SHA256, r).expand(Wi$1);
  return toString(i2, zt$2);
}
function bu(e) {
  const t = sha256.hash(fromString(e, zt$2));
  return toString(t, zt$2);
}
function yu(e) {
  const t = sha256.hash(fromString(e, Gr));
  return toString(t, zt$2);
}
function $f(e) {
  return fromString(`${e}`, Gi);
}
function Mr(e) {
  return Number(toString(e, Gi));
}
function wu(e) {
  const t = $f(typeof e.type < "u" ? e.type : Yi$1);
  if (Mr(t) === lr$2 && typeof e.senderPublicKey > "u")
    throw new Error("Missing sender public key for type 1 envelope");
  const r = typeof e.senderPublicKey < "u" ? fromString(e.senderPublicKey, zt$2) : void 0, i2 = typeof e.iv < "u" ? fromString(e.iv, zt$2) : random.randomBytes(Vi), n2 = new chacha20poly1305.ChaCha20Poly1305(fromString(e.symKey, zt$2)).seal(i2, fromString(e.message, Gr));
  return to({ type: t, sealed: n2, iv: i2, senderPublicKey: r });
}
function xu(e) {
  const t = new chacha20poly1305.ChaCha20Poly1305(fromString(e.symKey, zt$2)), { sealed: r, iv: i2 } = Xi$1(e.encoded), n2 = t.open(i2, r);
  if (n2 === null)
    throw new Error("Failed to decrypt");
  return toString(n2, Gr);
}
function to(e) {
  if (Mr(e.type) === lr$2) {
    if (typeof e.senderPublicKey > "u")
      throw new Error("Missing sender public key for type 1 envelope");
    return toString(concat$1([e.type, e.senderPublicKey, e.iv, e.sealed]), Jr);
  }
  return toString(concat$1([e.type, e.iv, e.sealed]), Jr);
}
function Xi$1(e) {
  const t = fromString(e, Jr), r = t.slice(vu, Zf), i2 = Zf;
  if (Mr(r) === lr$2) {
    const p3 = i2 + Wi$1, b3 = p3 + Vi, m3 = t.slice(i2, p3), w3 = t.slice(p3, b3), y3 = t.slice(b3);
    return { type: r, sealed: y3, iv: w3, senderPublicKey: m3 };
  }
  const n2 = i2 + Vi, o2 = t.slice(i2, n2), h4 = t.slice(n2);
  return { type: r, sealed: h4, iv: o2 };
}
function Mu(e, t) {
  const r = Xi$1(e);
  return eo({ type: Mr(r.type), senderPublicKey: typeof r.senderPublicKey < "u" ? toString(r.senderPublicKey, zt$2) : void 0, receiverPublicKey: t == null ? void 0 : t.receiverPublicKey });
}
function eo(e) {
  const t = (e == null ? void 0 : e.type) || Yi$1;
  if (t === lr$2) {
    if (typeof (e == null ? void 0 : e.senderPublicKey) > "u")
      throw new Error("missing sender public key");
    if (typeof (e == null ? void 0 : e.receiverPublicKey) > "u")
      throw new Error("missing receiver public key");
  }
  return { type: t, senderPublicKey: e == null ? void 0 : e.senderPublicKey, receiverPublicKey: e == null ? void 0 : e.receiverPublicKey };
}
function Eu(e) {
  return e.type === lr$2 && typeof e.senderPublicKey == "string" && typeof e.receiverPublicKey == "string";
}
const ro = "irn";
function Su(e) {
  return (e == null ? void 0 : e.relay) || { protocol: ro };
}
function Nu(e) {
  const t = RELAY_JSONRPC[e];
  if (typeof t > "u")
    throw new Error(`Relay Protocol not supported: ${e}`);
  return t;
}
var Iu = Object.defineProperty, _u = Object.defineProperties, Bu = Object.getOwnPropertyDescriptors, io = Object.getOwnPropertySymbols, Cu = Object.prototype.hasOwnProperty, Ru = Object.prototype.propertyIsEnumerable, no = (e, t, r) => t in e ? Iu(e, t, { enumerable: true, configurable: true, writable: true, value: r }) : e[t] = r, fo = (e, t) => {
  for (var r in t || (t = {}))
    Cu.call(t, r) && no(e, r, t[r]);
  if (io)
    for (var r of io(t))
      Ru.call(t, r) && no(e, r, t[r]);
  return e;
}, Ou = (e, t) => _u(e, Bu(t));
function oo(e, t = "-") {
  const r = {}, i2 = "relay" + t;
  return Object.keys(e).forEach((n2) => {
    if (n2.startsWith(i2)) {
      const o2 = n2.replace(i2, ""), h4 = e[n2];
      r[o2] = h4;
    }
  }), r;
}
function Pu(e) {
  e = e.includes("wc://") ? e.replace("wc://", "") : e, e = e.includes("wc:") ? e.replace("wc:", "") : e;
  const t = e.indexOf(":"), r = e.indexOf("?") !== -1 ? e.indexOf("?") : void 0, i2 = e.substring(0, t), n2 = e.substring(t + 1, r).split("@"), o2 = typeof r < "u" ? e.substring(r) : "", h4 = queryString.parse(o2), p3 = typeof h4.methods == "string" ? h4.methods.split(",") : void 0;
  return { protocol: i2, topic: so(n2[0]), version: parseInt(n2[1], 10), symKey: h4.symKey, relay: oo(h4), methods: p3, expiryTimestamp: h4.expiryTimestamp ? parseInt(h4.expiryTimestamp, 10) : void 0 };
}
function so(e) {
  return e.startsWith("//") ? e.substring(2) : e;
}
function ao(e, t = "-") {
  const r = "relay", i2 = {};
  return Object.keys(e).forEach((n2) => {
    const o2 = r + t + n2;
    e[n2] && (i2[o2] = e[n2]);
  }), i2;
}
function Du(e) {
  return `${e.protocol}:${e.topic}@${e.version}?` + queryString.stringify(fo(Ou(fo({ symKey: e.symKey }, ao(e.relay)), { expiryTimestamp: e.expiryTimestamp }), e.methods ? { methods: e.methods.join(",") } : {}));
}
var Fu = Object.defineProperty, Tu = Object.defineProperties, Uu = Object.getOwnPropertyDescriptors, uo = Object.getOwnPropertySymbols, ku = Object.prototype.hasOwnProperty, qu = Object.prototype.propertyIsEnumerable, ho = (e, t, r) => t in e ? Fu(e, t, { enumerable: true, configurable: true, writable: true, value: r }) : e[t] = r, Ku = (e, t) => {
  for (var r in t || (t = {}))
    ku.call(t, r) && ho(e, r, t[r]);
  if (uo)
    for (var r of uo(t))
      qu.call(t, r) && ho(e, r, t[r]);
  return e;
}, Hu = (e, t) => Tu(e, Uu(t));
function $e$1(e) {
  const t = [];
  return e.forEach((r) => {
    const [i2, n2] = r.split(":");
    t.push(`${i2}:${n2}`);
  }), t;
}
function co(e) {
  const t = [];
  return Object.values(e).forEach((r) => {
    t.push(...$e$1(r.accounts));
  }), t;
}
function lo(e, t) {
  const r = [];
  return Object.values(e).forEach((i2) => {
    $e$1(i2.accounts).includes(t) && r.push(...i2.methods);
  }), r;
}
function po(e, t) {
  const r = [];
  return Object.values(e).forEach((i2) => {
    $e$1(i2.accounts).includes(t) && r.push(...i2.events);
  }), r;
}
function Lu(e) {
  const { proposal: { requiredNamespaces: t, optionalNamespaces: r = {} }, supportedNamespaces: i2 } = e, n2 = $i(t), o2 = $i(r), h4 = {};
  Object.keys(i2).forEach((m3) => {
    const w3 = i2[m3].chains, y3 = i2[m3].methods, S3 = i2[m3].events, I2 = i2[m3].accounts;
    w3.forEach((N2) => {
      if (!I2.some((C2) => C2.includes(N2)))
        throw new Error(`No accounts provided for chain ${N2} in namespace ${m3}`);
    }), h4[m3] = { chains: w3, methods: y3, events: S3, accounts: I2 };
  });
  const p3 = Io(t, h4, "approve()");
  if (p3)
    throw new Error(p3.message);
  const b3 = {};
  return !Object.keys(t).length && !Object.keys(r).length ? h4 : (Object.keys(n2).forEach((m3) => {
    const w3 = i2[m3].chains.filter((N2) => {
      var C2, F2;
      return (F2 = (C2 = n2[m3]) == null ? void 0 : C2.chains) == null ? void 0 : F2.includes(N2);
    }), y3 = i2[m3].methods.filter((N2) => {
      var C2, F2;
      return (F2 = (C2 = n2[m3]) == null ? void 0 : C2.methods) == null ? void 0 : F2.includes(N2);
    }), S3 = i2[m3].events.filter((N2) => {
      var C2, F2;
      return (F2 = (C2 = n2[m3]) == null ? void 0 : C2.events) == null ? void 0 : F2.includes(N2);
    }), I2 = w3.map((N2) => i2[m3].accounts.filter((C2) => C2.includes(`${N2}:`))).flat();
    b3[m3] = { chains: w3, methods: y3, events: S3, accounts: I2 };
  }), Object.keys(o2).forEach((m3) => {
    var w3, y3, S3, I2, N2, C2;
    if (!i2[m3])
      return;
    const F2 = (y3 = (w3 = o2[m3]) == null ? void 0 : w3.chains) == null ? void 0 : y3.filter((G2) => i2[m3].chains.includes(G2)), U2 = i2[m3].methods.filter((G2) => {
      var H2, z2;
      return (z2 = (H2 = o2[m3]) == null ? void 0 : H2.methods) == null ? void 0 : z2.includes(G2);
    }), J2 = i2[m3].events.filter((G2) => {
      var H2, z2;
      return (z2 = (H2 = o2[m3]) == null ? void 0 : H2.events) == null ? void 0 : z2.includes(G2);
    }), Bt2 = F2 == null ? void 0 : F2.map((G2) => i2[m3].accounts.filter((H2) => H2.includes(`${G2}:`))).flat();
    b3[m3] = { chains: ge$2((S3 = b3[m3]) == null ? void 0 : S3.chains, F2), methods: ge$2((I2 = b3[m3]) == null ? void 0 : I2.methods, U2), events: ge$2((N2 = b3[m3]) == null ? void 0 : N2.events, J2), accounts: ge$2((C2 = b3[m3]) == null ? void 0 : C2.accounts, Bt2) };
  }), b3);
}
function Zi$1(e) {
  return e.includes(":");
}
function vo(e) {
  return Zi$1(e) ? e.split(":")[0] : e;
}
function $i(e) {
  var t, r, i2;
  const n2 = {};
  if (!Yr(e))
    return n2;
  for (const [o2, h4] of Object.entries(e)) {
    const p3 = Zi$1(o2) ? [o2] : h4.chains, b3 = h4.methods || [], m3 = h4.events || [], w3 = vo(o2);
    n2[w3] = Hu(Ku({}, n2[w3]), { chains: ge$2(p3, (t = n2[w3]) == null ? void 0 : t.chains), methods: ge$2(b3, (r = n2[w3]) == null ? void 0 : r.methods), events: ge$2(m3, (i2 = n2[w3]) == null ? void 0 : i2.events) });
  }
  return n2;
}
function mo(e) {
  const t = {};
  return e == null ? void 0 : e.forEach((r) => {
    const [i2, n2] = r.split(":");
    t[i2] || (t[i2] = { accounts: [], chains: [], events: [] }), t[i2].accounts.push(r), t[i2].chains.push(`${i2}:${n2}`);
  }), t;
}
function ju(e, t) {
  t = t.map((i2) => i2.replace("did:pkh:", ""));
  const r = mo(t);
  for (const [i2, n2] of Object.entries(r))
    n2.methods ? n2.methods = ge$2(n2.methods, e) : n2.methods = e, n2.events = ["chainChanged", "accountsChanged"];
  return r;
}
const go = { INVALID_METHOD: { message: "Invalid method.", code: 1001 }, INVALID_EVENT: { message: "Invalid event.", code: 1002 }, INVALID_UPDATE_REQUEST: { message: "Invalid update request.", code: 1003 }, INVALID_EXTEND_REQUEST: { message: "Invalid extend request.", code: 1004 }, INVALID_SESSION_SETTLE_REQUEST: { message: "Invalid session settle request.", code: 1005 }, UNAUTHORIZED_METHOD: { message: "Unauthorized method.", code: 3001 }, UNAUTHORIZED_EVENT: { message: "Unauthorized event.", code: 3002 }, UNAUTHORIZED_UPDATE_REQUEST: { message: "Unauthorized update request.", code: 3003 }, UNAUTHORIZED_EXTEND_REQUEST: { message: "Unauthorized extend request.", code: 3004 }, USER_REJECTED: { message: "User rejected.", code: 5e3 }, USER_REJECTED_CHAINS: { message: "User rejected chains.", code: 5001 }, USER_REJECTED_METHODS: { message: "User rejected methods.", code: 5002 }, USER_REJECTED_EVENTS: { message: "User rejected events.", code: 5003 }, UNSUPPORTED_CHAINS: { message: "Unsupported chains.", code: 5100 }, UNSUPPORTED_METHODS: { message: "Unsupported methods.", code: 5101 }, UNSUPPORTED_EVENTS: { message: "Unsupported events.", code: 5102 }, UNSUPPORTED_ACCOUNTS: { message: "Unsupported accounts.", code: 5103 }, UNSUPPORTED_NAMESPACE_KEY: { message: "Unsupported namespace key.", code: 5104 }, USER_DISCONNECTED: { message: "User disconnected.", code: 6e3 }, SESSION_SETTLEMENT_FAILED: { message: "Session settlement failed.", code: 7e3 }, WC_METHOD_UNSUPPORTED: { message: "Unsupported wc_ method.", code: 10001 } }, Ao = { NOT_INITIALIZED: { message: "Not initialized.", code: 1 }, NO_MATCHING_KEY: { message: "No matching key.", code: 2 }, RESTORE_WILL_OVERRIDE: { message: "Restore will override.", code: 3 }, RESUBSCRIBED: { message: "Resubscribed.", code: 4 }, MISSING_OR_INVALID: { message: "Missing or invalid.", code: 5 }, EXPIRED: { message: "Expired.", code: 6 }, UNKNOWN_TYPE: { message: "Unknown type.", code: 7 }, MISMATCHED_TOPIC: { message: "Mismatched topic.", code: 8 }, NON_CONFORMING_NAMESPACES: { message: "Non conforming namespaces.", code: 9 } };
function xe(e, t) {
  const { message: r, code: i2 } = Ao[e];
  return { message: t ? `${r} ${t}` : r, code: i2 };
}
function tr$2(e, t) {
  const { message: r, code: i2 } = go[e];
  return { message: t ? `${r} ${t}` : r, code: i2 };
}
function Er$1(e, t) {
  return Array.isArray(e) ? typeof t < "u" && e.length ? e.every(t) : true : false;
}
function Yr(e) {
  return Object.getPrototypeOf(e) === Object.prototype && Object.keys(e).length;
}
function Pe(e) {
  return typeof e > "u";
}
function Gt$2(e, t) {
  return t && Pe(e) ? true : typeof e == "string" && !!e.trim().length;
}
function Vr(e, t) {
  return t && Pe(e) ? true : typeof e == "number" && !isNaN(e);
}
function Qu(e, t) {
  const { requiredNamespaces: r } = t, i2 = Object.keys(e.namespaces), n2 = Object.keys(r);
  let o2 = true;
  return _e$1(n2, i2) ? (i2.forEach((h4) => {
    const { accounts: p3, methods: b3, events: m3 } = e.namespaces[h4], w3 = $e$1(p3), y3 = r[h4];
    (!_e$1(_r$2(h4, y3), w3) || !_e$1(y3.methods, b3) || !_e$1(y3.events, m3)) && (o2 = false);
  }), o2) : false;
}
function Sr$2(e) {
  return Gt$2(e, false) && e.includes(":") ? e.split(":").length === 2 : false;
}
function bo(e) {
  if (Gt$2(e, false) && e.includes(":")) {
    const t = e.split(":");
    if (t.length === 3) {
      const r = t[0] + ":" + t[1];
      return !!t[2] && Sr$2(r);
    }
  }
  return false;
}
function Ju(e) {
  if (Gt$2(e, false))
    try {
      return typeof new URL(e) < "u";
    } catch {
      return false;
    }
  return false;
}
function Gu(e) {
  var t;
  return (t = e == null ? void 0 : e.proposer) == null ? void 0 : t.publicKey;
}
function Yu(e) {
  return e == null ? void 0 : e.topic;
}
function Vu(e, t) {
  let r = null;
  return Gt$2(e == null ? void 0 : e.publicKey, false) || (r = xe("MISSING_OR_INVALID", `${t} controller public key should be a string`)), r;
}
function tn(e) {
  let t = true;
  return Er$1(e) ? e.length && (t = e.every((r) => Gt$2(r, false))) : t = false, t;
}
function yo(e, t, r) {
  let i2 = null;
  return Er$1(t) && t.length ? t.forEach((n2) => {
    i2 || Sr$2(n2) || (i2 = tr$2("UNSUPPORTED_CHAINS", `${r}, chain ${n2} should be a string and conform to "namespace:chainId" format`));
  }) : Sr$2(e) || (i2 = tr$2("UNSUPPORTED_CHAINS", `${r}, chains must be defined as "namespace:chainId" e.g. "eip155:1": {...} in the namespace key OR as an array of CAIP-2 chainIds e.g. eip155: { chains: ["eip155:1", "eip155:5"] }`)), i2;
}
function wo(e, t, r) {
  let i2 = null;
  return Object.entries(e).forEach(([n2, o2]) => {
    if (i2)
      return;
    const h4 = yo(n2, _r$2(n2, o2), `${t} ${r}`);
    h4 && (i2 = h4);
  }), i2;
}
function xo(e, t) {
  let r = null;
  return Er$1(e) ? e.forEach((i2) => {
    r || bo(i2) || (r = tr$2("UNSUPPORTED_ACCOUNTS", `${t}, account ${i2} should be a string and conform to "namespace:chainId:address" format`));
  }) : r = tr$2("UNSUPPORTED_ACCOUNTS", `${t}, accounts should be an array of strings conforming to "namespace:chainId:address" format`), r;
}
function Mo(e, t) {
  let r = null;
  return Object.values(e).forEach((i2) => {
    if (r)
      return;
    const n2 = xo(i2 == null ? void 0 : i2.accounts, `${t} namespace`);
    n2 && (r = n2);
  }), r;
}
function Eo(e, t) {
  let r = null;
  return tn(e == null ? void 0 : e.methods) ? tn(e == null ? void 0 : e.events) || (r = tr$2("UNSUPPORTED_EVENTS", `${t}, events should be an array of strings or empty array for no events`)) : r = tr$2("UNSUPPORTED_METHODS", `${t}, methods should be an array of strings or empty array for no methods`), r;
}
function en(e, t) {
  let r = null;
  return Object.values(e).forEach((i2) => {
    if (r)
      return;
    const n2 = Eo(i2, `${t}, namespace`);
    n2 && (r = n2);
  }), r;
}
function Wu(e, t, r) {
  let i2 = null;
  if (e && Yr(e)) {
    const n2 = en(e, t);
    n2 && (i2 = n2);
    const o2 = wo(e, t, r);
    o2 && (i2 = o2);
  } else
    i2 = xe("MISSING_OR_INVALID", `${t}, ${r} should be an object with data`);
  return i2;
}
function So(e, t) {
  let r = null;
  if (e && Yr(e)) {
    const i2 = en(e, t);
    i2 && (r = i2);
    const n2 = Mo(e, t);
    n2 && (r = n2);
  } else
    r = xe("MISSING_OR_INVALID", `${t}, namespaces should be an object with data`);
  return r;
}
function No(e) {
  return Gt$2(e.protocol, true);
}
function Xu(e, t) {
  let r = false;
  return t && !e ? r = true : e && Er$1(e) && e.length && e.forEach((i2) => {
    r = No(i2);
  }), r;
}
function Zu(e) {
  return typeof e == "number";
}
function $u(e) {
  return typeof e < "u" && typeof e !== null;
}
function th(e) {
  return !(!e || typeof e != "object" || !e.code || !Vr(e.code, false) || !e.message || !Gt$2(e.message, false));
}
function eh(e) {
  return !(Pe(e) || !Gt$2(e.method, false));
}
function rh(e) {
  return !(Pe(e) || Pe(e.result) && Pe(e.error) || !Vr(e.id, false) || !Gt$2(e.jsonrpc, false));
}
function ih(e) {
  return !(Pe(e) || !Gt$2(e.name, false));
}
function nh(e, t) {
  return !(!Sr$2(t) || !co(e).includes(t));
}
function fh(e, t, r) {
  return Gt$2(r, false) ? lo(e, t).includes(r) : false;
}
function oh(e, t, r) {
  return Gt$2(r, false) ? po(e, t).includes(r) : false;
}
function Io(e, t, r) {
  let i2 = null;
  const n2 = sh(e), o2 = ah(t), h4 = Object.keys(n2), p3 = Object.keys(o2), b3 = _o(Object.keys(e)), m3 = _o(Object.keys(t)), w3 = b3.filter((y3) => !m3.includes(y3));
  return w3.length && (i2 = xe("NON_CONFORMING_NAMESPACES", `${r} namespaces keys don't satisfy requiredNamespaces.
      Required: ${w3.toString()}
      Received: ${Object.keys(t).toString()}`)), _e$1(h4, p3) || (i2 = xe("NON_CONFORMING_NAMESPACES", `${r} namespaces chains don't satisfy required namespaces.
      Required: ${h4.toString()}
      Approved: ${p3.toString()}`)), Object.keys(t).forEach((y3) => {
    if (!y3.includes(":") || i2)
      return;
    const S3 = $e$1(t[y3].accounts);
    S3.includes(y3) || (i2 = xe("NON_CONFORMING_NAMESPACES", `${r} namespaces accounts don't satisfy namespace accounts for ${y3}
        Required: ${y3}
        Approved: ${S3.toString()}`));
  }), h4.forEach((y3) => {
    i2 || (_e$1(n2[y3].methods, o2[y3].methods) ? _e$1(n2[y3].events, o2[y3].events) || (i2 = xe("NON_CONFORMING_NAMESPACES", `${r} namespaces events don't satisfy namespace events for ${y3}`)) : i2 = xe("NON_CONFORMING_NAMESPACES", `${r} namespaces methods don't satisfy namespace methods for ${y3}`));
  }), i2;
}
function sh(e) {
  const t = {};
  return Object.keys(e).forEach((r) => {
    var i2;
    r.includes(":") ? t[r] = e[r] : (i2 = e[r].chains) == null || i2.forEach((n2) => {
      t[n2] = { methods: e[r].methods, events: e[r].events };
    });
  }), t;
}
function _o(e) {
  return [...new Set(e.map((t) => t.includes(":") ? t.split(":")[0] : t))];
}
function ah(e) {
  const t = {};
  return Object.keys(e).forEach((r) => {
    if (r.includes(":"))
      t[r] = e[r];
    else {
      const i2 = $e$1(e[r].accounts);
      i2 == null ? void 0 : i2.forEach((n2) => {
        t[n2] = { accounts: e[r].accounts.filter((o2) => o2.includes(`${n2}:`)), methods: e[r].methods, events: e[r].events };
      });
    }
  }), t;
}
function uh(e, t) {
  return Vr(e, false) && e <= t.max && e >= t.min;
}
function hh() {
  const e = We$3();
  return new Promise((t) => {
    switch (e) {
      case qt$2.browser:
        t(Bo());
        break;
      case qt$2.reactNative:
        t(Co());
        break;
      case qt$2.node:
        t(Ro());
        break;
      default:
        t(true);
    }
  });
}
function Bo() {
  return pr$2() && (navigator == null ? void 0 : navigator.onLine);
}
async function Co() {
  if (er$2() && typeof global < "u" && global != null && global.NetInfo) {
    const e = await (global == null ? void 0 : global.NetInfo.fetch());
    return e == null ? void 0 : e.isConnected;
  }
  return true;
}
function Ro() {
  return true;
}
function ch(e) {
  switch (We$3()) {
    case qt$2.browser:
      Oo(e);
      break;
    case qt$2.reactNative:
      Po(e);
      break;
  }
}
function Oo(e) {
  !er$2() && pr$2() && (window.addEventListener("online", () => e(true)), window.addEventListener("offline", () => e(false)));
}
function Po(e) {
  var _a2;
  er$2() && typeof global < "u" && global != null && global.NetInfo && ((_a2 = global) == null ? void 0 : _a2.NetInfo.addEventListener((t) => e(t == null ? void 0 : t.isConnected)));
}
const rn = {};
class lh {
  static get(t) {
    return rn[t];
  }
  static set(t, r) {
    rn[t] = r;
  }
  static delete(t) {
    delete rn[t];
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
  const match = Object.values(STANDARD_ERROR_MAP).find((e) => e.code === code);
  if (!match) {
    return STANDARD_ERROR_MAP[DEFAULT_ERROR];
  }
  return match;
}
function parseConnectionError(e, url, type) {
  return e.message.includes("getaddrinfo ENOTFOUND") || e.message.includes("connect ECONNREFUSED") ? new Error(`Unavailable ${type} RPC url at ${url}`) : e;
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
var extendStatics = function(d4, b3) {
  extendStatics = Object.setPrototypeOf || { __proto__: [] } instanceof Array && function(d5, b4) {
    d5.__proto__ = b4;
  } || function(d5, b4) {
    for (var p3 in b4)
      if (b4.hasOwnProperty(p3))
        d5[p3] = b4[p3];
  };
  return extendStatics(d4, b3);
};
function __extends(d4, b3) {
  extendStatics(d4, b3);
  function __() {
    this.constructor = d4;
  }
  d4.prototype = b3 === null ? Object.create(b3) : (__.prototype = b3.prototype, new __());
}
var __assign = function() {
  __assign = Object.assign || function __assign2(t) {
    for (var s, i2 = 1, n2 = arguments.length; i2 < n2; i2++) {
      s = arguments[i2];
      for (var p3 in s)
        if (Object.prototype.hasOwnProperty.call(s, p3))
          t[p3] = s[p3];
    }
    return t;
  };
  return __assign.apply(this, arguments);
};
function __rest(s, e) {
  var t = {};
  for (var p3 in s)
    if (Object.prototype.hasOwnProperty.call(s, p3) && e.indexOf(p3) < 0)
      t[p3] = s[p3];
  if (s != null && typeof Object.getOwnPropertySymbols === "function")
    for (var i2 = 0, p3 = Object.getOwnPropertySymbols(s); i2 < p3.length; i2++) {
      if (e.indexOf(p3[i2]) < 0 && Object.prototype.propertyIsEnumerable.call(s, p3[i2]))
        t[p3[i2]] = s[p3[i2]];
    }
  return t;
}
function __decorate(decorators, target, key2, desc) {
  var c2 = arguments.length, r = c2 < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key2) : desc, d4;
  if (typeof Reflect === "object" && typeof Reflect.decorate === "function")
    r = Reflect.decorate(decorators, target, key2, desc);
  else
    for (var i2 = decorators.length - 1; i2 >= 0; i2--)
      if (d4 = decorators[i2])
        r = (c2 < 3 ? d4(r) : c2 > 3 ? d4(target, key2, r) : d4(target, key2)) || r;
  return c2 > 3 && r && Object.defineProperty(target, key2, r), r;
}
function __param(paramIndex, decorator) {
  return function(target, key2) {
    decorator(target, key2, paramIndex);
  };
}
function __metadata(metadataKey, metadataValue) {
  if (typeof Reflect === "object" && typeof Reflect.metadata === "function")
    return Reflect.metadata(metadataKey, metadataValue);
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
      } catch (e) {
        reject(e);
      }
    }
    function rejected(value) {
      try {
        step(generator["throw"](value));
      } catch (e) {
        reject(e);
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
    if (t[0] & 1)
      throw t[1];
    return t[1];
  }, trys: [], ops: [] }, f3, y3, t, g3;
  return g3 = { next: verb(0), "throw": verb(1), "return": verb(2) }, typeof Symbol === "function" && (g3[Symbol.iterator] = function() {
    return this;
  }), g3;
  function verb(n2) {
    return function(v3) {
      return step([n2, v3]);
    };
  }
  function step(op) {
    if (f3)
      throw new TypeError("Generator is already executing.");
    while (_3)
      try {
        if (f3 = 1, y3 && (t = op[0] & 2 ? y3["return"] : op[0] ? y3["throw"] || ((t = y3["return"]) && t.call(y3), 0) : y3.next) && !(t = t.call(y3, op[1])).done)
          return t;
        if (y3 = 0, t)
          op = [op[0] & 2, t.value];
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
            if (t[2])
              _3.ops.pop();
            _3.trys.pop();
            continue;
        }
        op = body.call(thisArg, _3);
      } catch (e) {
        op = [6, e];
        y3 = 0;
      } finally {
        f3 = t = 0;
      }
    if (op[0] & 5)
      throw op[1];
    return { value: op[0] ? op[1] : void 0, done: true };
  }
}
function __createBinding(o2, m3, k2, k22) {
  if (k22 === void 0)
    k22 = k2;
  o2[k22] = m3[k2];
}
function __exportStar(m3, exports) {
  for (var p3 in m3)
    if (p3 !== "default" && !exports.hasOwnProperty(p3))
      exports[p3] = m3[p3];
}
function __values(o2) {
  var s = typeof Symbol === "function" && Symbol.iterator, m3 = s && o2[s], i2 = 0;
  if (m3)
    return m3.call(o2);
  if (o2 && typeof o2.length === "number")
    return {
      next: function() {
        if (o2 && i2 >= o2.length)
          o2 = void 0;
        return { value: o2 && o2[i2++], done: !o2 };
      }
    };
  throw new TypeError(s ? "Object is not iterable." : "Symbol.iterator is not defined.");
}
function __read(o2, n2) {
  var m3 = typeof Symbol === "function" && o2[Symbol.iterator];
  if (!m3)
    return o2;
  var i2 = m3.call(o2), r, ar3 = [], e;
  try {
    while ((n2 === void 0 || n2-- > 0) && !(r = i2.next()).done)
      ar3.push(r.value);
  } catch (error2) {
    e = { error: error2 };
  } finally {
    try {
      if (r && !r.done && (m3 = i2["return"]))
        m3.call(i2);
    } finally {
      if (e)
        throw e.error;
    }
  }
  return ar3;
}
function __spread() {
  for (var ar3 = [], i2 = 0; i2 < arguments.length; i2++)
    ar3 = ar3.concat(__read(arguments[i2]));
  return ar3;
}
function __spreadArrays() {
  for (var s = 0, i2 = 0, il = arguments.length; i2 < il; i2++)
    s += arguments[i2].length;
  for (var r = Array(s), k2 = 0, i2 = 0; i2 < il; i2++)
    for (var a3 = arguments[i2], j2 = 0, jl = a3.length; j2 < jl; j2++, k2++)
      r[k2] = a3[j2];
  return r;
}
function __await(v3) {
  return this instanceof __await ? (this.v = v3, this) : new __await(v3);
}
function __asyncGenerator(thisArg, _arguments, generator) {
  if (!Symbol.asyncIterator)
    throw new TypeError("Symbol.asyncIterator is not defined.");
  var g3 = generator.apply(thisArg, _arguments || []), i2, q2 = [];
  return i2 = {}, verb("next"), verb("throw"), verb("return"), i2[Symbol.asyncIterator] = function() {
    return this;
  }, i2;
  function verb(n2) {
    if (g3[n2])
      i2[n2] = function(v3) {
        return new Promise(function(a3, b3) {
          q2.push([n2, v3, a3, b3]) > 1 || resume(n2, v3);
        });
      };
  }
  function resume(n2, v3) {
    try {
      step(g3[n2](v3));
    } catch (e) {
      settle(q2[0][3], e);
    }
  }
  function step(r) {
    r.value instanceof __await ? Promise.resolve(r.value.v).then(fulfill, reject) : settle(q2[0][2], r);
  }
  function fulfill(value) {
    resume("next", value);
  }
  function reject(value) {
    resume("throw", value);
  }
  function settle(f3, v3) {
    if (f3(v3), q2.shift(), q2.length)
      resume(q2[0][0], q2[0][1]);
  }
}
function __asyncDelegator(o2) {
  var i2, p3;
  return i2 = {}, verb("next"), verb("throw", function(e) {
    throw e;
  }), verb("return"), i2[Symbol.iterator] = function() {
    return this;
  }, i2;
  function verb(n2, f3) {
    i2[n2] = o2[n2] ? function(v3) {
      return (p3 = !p3) ? { value: __await(o2[n2](v3)), done: n2 === "return" } : f3 ? f3(v3) : v3;
    } : f3;
  }
}
function __asyncValues(o2) {
  if (!Symbol.asyncIterator)
    throw new TypeError("Symbol.asyncIterator is not defined.");
  var m3 = o2[Symbol.asyncIterator], i2;
  return m3 ? m3.call(o2) : (o2 = typeof __values === "function" ? __values(o2) : o2[Symbol.iterator](), i2 = {}, verb("next"), verb("throw"), verb("return"), i2[Symbol.asyncIterator] = function() {
    return this;
  }, i2);
  function verb(n2) {
    i2[n2] = o2[n2] && function(v3) {
      return new Promise(function(resolve, reject) {
        v3 = o2[n2](v3), settle(resolve, reject, v3.done, v3.value);
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
  if (mod && mod.__esModule)
    return mod;
  var result = {};
  if (mod != null) {
    for (var k2 in mod)
      if (Object.hasOwnProperty.call(mod, k2))
        result[k2] = mod[k2];
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
  if (hasRequiredCrypto)
    return crypto$1;
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
  if (hasRequiredEnv)
    return env;
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
    error: formatErrorMessage(error2, data)
  };
}
function formatErrorMessage(error2, data) {
  if (typeof error2 === "undefined") {
    return getError(INTERNAL_ERROR);
  }
  if (typeof error2 === "string") {
    error2 = Object.assign(Object.assign({}, getError(SERVER_ERROR)), { message: error2 });
  }
  if (typeof data !== "undefined") {
    error2.data = data;
  }
  if (isReservedErrorCode(error2.code)) {
    error2 = getErrorByCode(error2.code);
  }
  return error2;
}
class IEvents2 {
}
class IBaseJsonRpcProvider extends IEvents2 {
  constructor() {
    super();
  }
}
class IJsonRpcProvider extends IBaseJsonRpcProvider {
  constructor(connection) {
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
class JsonRpcProvider extends IJsonRpcProvider {
  constructor(connection) {
    super(connection);
    this.events = new eventsExports.EventEmitter();
    this.hasRegisteredEventListeners = false;
    this.connection = this.setConnection(connection);
    if (this.connection.connected) {
      this.registerEventListeners();
    }
  }
  async connect(connection = this.connection) {
    await this.open(connection);
  }
  async disconnect() {
    await this.close();
  }
  on(event, listener) {
    this.events.on(event, listener);
  }
  once(event, listener) {
    this.events.once(event, listener);
  }
  off(event, listener) {
    this.events.off(event, listener);
  }
  removeListener(event, listener) {
    this.events.removeListener(event, listener);
  }
  async request(request, context) {
    return this.requestStrict(formatJsonRpcRequest(request.method, request.params || [], request.id || getBigIntRpcId().toString()), context);
  }
  async requestStrict(request, context) {
    return new Promise(async (resolve, reject) => {
      if (!this.connection.connected) {
        try {
          await this.open();
        } catch (e) {
          reject(e);
        }
      }
      this.events.on(`${request.id}`, (response) => {
        if (isJsonRpcError(response)) {
          reject(response.error);
        } else {
          resolve(response.result);
        }
      });
      try {
        await this.connection.send(request, context);
      } catch (e) {
        reject(e);
      }
    });
  }
  setConnection(connection = this.connection) {
    return connection;
  }
  onPayload(payload) {
    this.events.emit("payload", payload);
    if (isJsonRpcResponse(payload)) {
      this.events.emit(`${payload.id}`, payload);
    } else {
      this.events.emit("message", {
        type: payload.method,
        data: payload.params
      });
    }
  }
  onClose(event) {
    if (event && event.code === 3e3) {
      this.events.emit("error", new Error(`WebSocket connection closed abnormally with code: ${event.code} ${event.reason ? `(${event.reason})` : ""}`));
    }
    this.events.emit("disconnect");
  }
  async open(connection = this.connection) {
    if (this.connection === connection && this.connection.connected)
      return;
    if (this.connection.connected)
      this.close();
    if (typeof connection === "string") {
      await this.connection.open(connection);
      connection = this.connection;
    }
    this.connection = this.setConnection(connection);
    await this.connection.open();
    this.registerEventListeners();
    this.events.emit("connect");
  }
  async close() {
    await this.connection.close();
  }
  registerEventListeners() {
    if (this.hasRegisteredEventListeners)
      return;
    this.connection.on("payload", (payload) => this.onPayload(payload));
    this.connection.on("close", (event) => this.onClose(event));
    this.connection.on("error", (error2) => this.events.emit("error", error2));
    this.connection.on("register_error", (error2) => this.onClose());
    this.hasRegisteredEventListeners = true;
  }
}
const w$1 = () => typeof WebSocket < "u" ? WebSocket : typeof global < "u" && typeof global.WebSocket < "u" ? global.WebSocket : typeof window < "u" && typeof window.WebSocket < "u" ? window.WebSocket : typeof self < "u" && typeof self.WebSocket < "u" ? self.WebSocket : require("ws"), b$1 = () => typeof WebSocket < "u" || typeof global < "u" && typeof global.WebSocket < "u" || typeof window < "u" && typeof window.WebSocket < "u" || typeof self < "u" && typeof self.WebSocket < "u", a2 = (c2) => c2.split("?")[0], h3 = 10, S$3 = w$1();
let f$2 = class f {
  constructor(e) {
    if (this.url = e, this.events = new eventsExports.EventEmitter(), this.registering = false, !isWsUrl(e))
      throw new Error(`Provided URL is not compatible with WebSocket connection: ${e}`);
    this.url = e;
  }
  get connected() {
    return typeof this.socket < "u";
  }
  get connecting() {
    return this.registering;
  }
  on(e, t) {
    this.events.on(e, t);
  }
  once(e, t) {
    this.events.once(e, t);
  }
  off(e, t) {
    this.events.off(e, t);
  }
  removeListener(e, t) {
    this.events.removeListener(e, t);
  }
  async open(e = this.url) {
    await this.register(e);
  }
  async close() {
    return new Promise((e, t) => {
      if (typeof this.socket > "u") {
        t(new Error("Connection already closed"));
        return;
      }
      this.socket.onclose = (n2) => {
        this.onClose(n2), e();
      }, this.socket.close();
    });
  }
  async send(e) {
    typeof this.socket > "u" && (this.socket = await this.register());
    try {
      this.socket.send(safeJsonStringify(e));
    } catch (t) {
      this.onError(e.id, t);
    }
  }
  register(e = this.url) {
    if (!isWsUrl(e))
      throw new Error(`Provided URL is not compatible with WebSocket connection: ${e}`);
    if (this.registering) {
      const t = this.events.getMaxListeners();
      return (this.events.listenerCount("register_error") >= t || this.events.listenerCount("open") >= t) && this.events.setMaxListeners(t + 1), new Promise((n2, o2) => {
        this.events.once("register_error", (s) => {
          this.resetMaxListeners(), o2(s);
        }), this.events.once("open", () => {
          if (this.resetMaxListeners(), typeof this.socket > "u")
            return o2(new Error("WebSocket connection is missing or invalid"));
          n2(this.socket);
        });
      });
    }
    return this.url = e, this.registering = true, new Promise((t, n2) => {
      const o2 = new URLSearchParams(e).get("origin"), s = cjs.isReactNative() ? { headers: { origin: o2 } } : { rejectUnauthorized: !isLocalhostUrl(e) }, i2 = new S$3(e, [], s);
      b$1() ? i2.onerror = (r) => {
        const l2 = r;
        n2(this.emitError(l2.error));
      } : i2.on("error", (r) => {
        n2(this.emitError(r));
      }), i2.onopen = () => {
        this.onOpen(i2), t(i2);
      };
    });
  }
  onOpen(e) {
    e.onmessage = (t) => this.onPayload(t), e.onclose = (t) => this.onClose(t), this.socket = e, this.registering = false, this.events.emit("open");
  }
  onClose(e) {
    this.socket = void 0, this.registering = false, this.events.emit("close", e);
  }
  onPayload(e) {
    if (typeof e.data > "u")
      return;
    const t = typeof e.data == "string" ? safeJsonParse(e.data) : e.data;
    this.events.emit("payload", t);
  }
  onError(e, t) {
    const n2 = this.parseError(t), o2 = n2.message || n2.toString(), s = formatJsonRpcError(e, o2);
    this.events.emit("payload", s);
  }
  parseError(e, t = this.url) {
    return parseConnectionError(e, a2(t), "WS");
  }
  resetMaxListeners() {
    this.events.getMaxListeners() > h3 && this.events.setMaxListeners(h3);
  }
  emitError(e) {
    const t = this.parseError(new Error((e == null ? void 0 : e.message) || `WebSocket connection failed for host: ${a2(this.url)}`));
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
    } catch (e) {
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
  function baseTimes(n2, iteratee) {
    var index = -1, result = Array(n2);
    while (++index < n2) {
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
  var DataView = getNative(root, "DataView"), Map2 = getNative(root, "Map"), Promise2 = getNative(root, "Promise"), Set2 = getNative(root, "Set"), WeakMap = getNative(root, "WeakMap"), nativeCreate = getNative(Object, "create");
  var dataViewCtorString = toSource(DataView), mapCtorString = toSource(Map2), promiseCtorString = toSource(Promise2), setCtorString = toSource(Set2), weakMapCtorString = toSource(WeakMap);
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
      if ((inherited || hasOwnProperty.call(value, key2)) && !(skipIndexes && // Safari 9 has enumerable `arguments.length` in strict mode.
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
      if (eq4(array[length][0], key2)) {
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
        return eq4(+object, +other);
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
    } catch (e) {
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
  if (DataView && getTag(new DataView(new ArrayBuffer(1))) != dataViewTag || Map2 && getTag(new Map2()) != mapTag || Promise2 && getTag(Promise2.resolve()) != promiseTag || Set2 && getTag(new Set2()) != setTag || WeakMap && getTag(new WeakMap()) != weakMapTag) {
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
      } catch (e) {
      }
      try {
        return func + "";
      } catch (e) {
      }
    }
    return "";
  }
  function eq4(value, other) {
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
const Yi = /* @__PURE__ */ getDefaultExportFromCjs(lodash_isequalExports);
function unfetch_module(e, n2) {
  return n2 = n2 || {}, new Promise(function(t, r) {
    var s = new XMLHttpRequest(), o2 = [], u2 = [], i2 = {}, a3 = function() {
      return { ok: 2 == (s.status / 100 | 0), statusText: s.statusText, status: s.status, url: s.responseURL, text: function() {
        return Promise.resolve(s.responseText);
      }, json: function() {
        return Promise.resolve(s.responseText).then(JSON.parse);
      }, blob: function() {
        return Promise.resolve(new Blob([s.response]));
      }, clone: a3, headers: { keys: function() {
        return o2;
      }, entries: function() {
        return u2;
      }, get: function(e2) {
        return i2[e2.toLowerCase()];
      }, has: function(e2) {
        return e2.toLowerCase() in i2;
      } } };
    };
    for (var l2 in s.open(n2.method || "get", e, true), s.onload = function() {
      s.getAllResponseHeaders().replace(/^(.*?):[^\S\n]*([\s\S]*?)$/gm, function(e2, n3, t2) {
        o2.push(n3 = n3.toLowerCase()), u2.push([n3, t2]), i2[n3] = i2[n3] ? i2[n3] + "," + t2 : t2;
      }), t(a3());
    }, s.onerror = r, s.withCredentials = "include" == n2.credentials, n2.headers)
      s.setRequestHeader(l2, n2.headers[l2]);
    s.send(n2.body || null);
  });
}
const unfetch_module$1 = /* @__PURE__ */ Object.freeze(/* @__PURE__ */ Object.defineProperty({
  __proto__: null,
  default: unfetch_module
}, Symbol.toStringTag, { value: "Module" }));
const require$$0 = /* @__PURE__ */ getAugmentedNamespace(unfetch_module$1);
var browser = self.fetch || (self.fetch = require$$0.default || require$$0);
const ke$2 = /* @__PURE__ */ getDefaultExportFromCjs(browser);
var define_process_env_default = {};
function Ji(n2, e) {
  if (n2.length >= 255)
    throw new TypeError("Alphabet too long");
  for (var t = new Uint8Array(256), i2 = 0; i2 < t.length; i2++)
    t[i2] = 255;
  for (var s = 0; s < n2.length; s++) {
    var r = n2.charAt(s), o2 = r.charCodeAt(0);
    if (t[o2] !== 255)
      throw new TypeError(r + " is ambiguous");
    t[o2] = s;
  }
  var a3 = n2.length, h4 = n2.charAt(0), l2 = Math.log(a3) / Math.log(256), d4 = Math.log(256) / Math.log(a3);
  function g3(u2) {
    if (u2 instanceof Uint8Array || (ArrayBuffer.isView(u2) ? u2 = new Uint8Array(u2.buffer, u2.byteOffset, u2.byteLength) : Array.isArray(u2) && (u2 = Uint8Array.from(u2))), !(u2 instanceof Uint8Array))
      throw new TypeError("Expected Uint8Array");
    if (u2.length === 0)
      return "";
    for (var p3 = 0, _3 = 0, D2 = 0, P2 = u2.length; D2 !== P2 && u2[D2] === 0; )
      D2++, p3++;
    for (var x2 = (P2 - D2) * d4 + 1 >>> 0, E3 = new Uint8Array(x2); D2 !== P2; ) {
      for (var O3 = u2[D2], N2 = 0, R2 = x2 - 1; (O3 !== 0 || N2 < _3) && R2 !== -1; R2--, N2++)
        O3 += 256 * E3[R2] >>> 0, E3[R2] = O3 % a3 >>> 0, O3 = O3 / a3 >>> 0;
      if (O3 !== 0)
        throw new Error("Non-zero carry");
      _3 = N2, D2++;
    }
    for (var A2 = x2 - _3; A2 !== x2 && E3[A2] === 0; )
      A2++;
    for (var j2 = h4.repeat(p3); A2 < x2; ++A2)
      j2 += n2.charAt(E3[A2]);
    return j2;
  }
  function m3(u2) {
    if (typeof u2 != "string")
      throw new TypeError("Expected String");
    if (u2.length === 0)
      return new Uint8Array();
    var p3 = 0;
    if (u2[p3] !== " ") {
      for (var _3 = 0, D2 = 0; u2[p3] === h4; )
        _3++, p3++;
      for (var P2 = (u2.length - p3) * l2 + 1 >>> 0, x2 = new Uint8Array(P2); u2[p3]; ) {
        var E3 = t[u2.charCodeAt(p3)];
        if (E3 === 255)
          return;
        for (var O3 = 0, N2 = P2 - 1; (E3 !== 0 || O3 < D2) && N2 !== -1; N2--, O3++)
          E3 += a3 * x2[N2] >>> 0, x2[N2] = E3 % 256 >>> 0, E3 = E3 / 256 >>> 0;
        if (E3 !== 0)
          throw new Error("Non-zero carry");
        D2 = O3, p3++;
      }
      if (u2[p3] !== " ") {
        for (var R2 = P2 - D2; R2 !== P2 && x2[R2] === 0; )
          R2++;
        for (var A2 = new Uint8Array(_3 + (P2 - R2)), j2 = _3; R2 !== P2; )
          A2[j2++] = x2[R2++];
        return A2;
      }
    }
  }
  function L4(u2) {
    var p3 = m3(u2);
    if (p3)
      return p3;
    throw new Error(`Non-${e} character`);
  }
  return { encode: g3, decodeUnsafe: m3, decode: L4 };
}
var Xi = Ji, Wi = Xi;
const Ue$1 = (n2) => {
  if (n2 instanceof Uint8Array && n2.constructor.name === "Uint8Array")
    return n2;
  if (n2 instanceof ArrayBuffer)
    return new Uint8Array(n2);
  if (ArrayBuffer.isView(n2))
    return new Uint8Array(n2.buffer, n2.byteOffset, n2.byteLength);
  throw new Error("Unknown type, must be binary type");
}, Qi = (n2) => new TextEncoder().encode(n2), Zi = (n2) => new TextDecoder().decode(n2);
let es$1 = class es {
  constructor(e, t, i2) {
    this.name = e, this.prefix = t, this.baseEncode = i2;
  }
  encode(e) {
    if (e instanceof Uint8Array)
      return `${this.prefix}${this.baseEncode(e)}`;
    throw Error("Unknown type, must be binary type");
  }
};
let ts$1 = class ts {
  constructor(e, t, i2) {
    if (this.name = e, this.prefix = t, t.codePointAt(0) === void 0)
      throw new Error("Invalid prefix character");
    this.prefixCodePoint = t.codePointAt(0), this.baseDecode = i2;
  }
  decode(e) {
    if (typeof e == "string") {
      if (e.codePointAt(0) !== this.prefixCodePoint)
        throw Error(`Unable to decode multibase string ${JSON.stringify(e)}, ${this.name} decoder only supports inputs prefixed with ${this.prefix}`);
      return this.baseDecode(e.slice(this.prefix.length));
    } else
      throw Error("Can only multibase decode strings");
  }
  or(e) {
    return $e(this, e);
  }
};
let is$1 = class is {
  constructor(e) {
    this.decoders = e;
  }
  or(e) {
    return $e(this, e);
  }
  decode(e) {
    const t = e[0], i2 = this.decoders[t];
    if (i2)
      return i2.decode(e);
    throw RangeError(`Unable to decode multibase string ${JSON.stringify(e)}, only inputs prefixed with ${Object.keys(this.decoders)} are supported`);
  }
};
const $e = (n2, e) => new is$1({ ...n2.decoders || { [n2.prefix]: n2 }, ...e.decoders || { [e.prefix]: e } });
let ss$1 = class ss {
  constructor(e, t, i2, s) {
    this.name = e, this.prefix = t, this.baseEncode = i2, this.baseDecode = s, this.encoder = new es$1(e, t, i2), this.decoder = new ts$1(e, t, s);
  }
  encode(e) {
    return this.encoder.encode(e);
  }
  decode(e) {
    return this.decoder.decode(e);
  }
};
const Q$1 = ({ name: n2, prefix: e, encode: t, decode: i2 }) => new ss$1(n2, e, t, i2), K$2 = ({ prefix: n2, name: e, alphabet: t }) => {
  const { encode: i2, decode: s } = Wi(t, e);
  return Q$1({ prefix: n2, name: e, encode: i2, decode: (r) => Ue$1(s(r)) });
}, rs$1 = (n2, e, t, i2) => {
  const s = {};
  for (let d4 = 0; d4 < e.length; ++d4)
    s[e[d4]] = d4;
  let r = n2.length;
  for (; n2[r - 1] === "="; )
    --r;
  const o2 = new Uint8Array(r * t / 8 | 0);
  let a3 = 0, h4 = 0, l2 = 0;
  for (let d4 = 0; d4 < r; ++d4) {
    const g3 = s[n2[d4]];
    if (g3 === void 0)
      throw new SyntaxError(`Non-${i2} character`);
    h4 = h4 << t | g3, a3 += t, a3 >= 8 && (a3 -= 8, o2[l2++] = 255 & h4 >> a3);
  }
  if (a3 >= t || 255 & h4 << 8 - a3)
    throw new SyntaxError("Unexpected end of data");
  return o2;
}, ns$1 = (n2, e, t) => {
  const i2 = e[e.length - 1] === "=", s = (1 << t) - 1;
  let r = "", o2 = 0, a3 = 0;
  for (let h4 = 0; h4 < n2.length; ++h4)
    for (a3 = a3 << 8 | n2[h4], o2 += 8; o2 > t; )
      o2 -= t, r += e[s & a3 >> o2];
  if (o2 && (r += e[s & a3 << t - o2]), i2)
    for (; r.length * t & 7; )
      r += "=";
  return r;
}, y$1 = ({ name: n2, prefix: e, bitsPerChar: t, alphabet: i2 }) => Q$1({ prefix: e, name: n2, encode(s) {
  return ns$1(s, i2, t);
}, decode(s) {
  return rs$1(s, i2, t, n2);
} }), os$1 = Q$1({ prefix: "\0", name: "identity", encode: (n2) => Zi(n2), decode: (n2) => Qi(n2) });
var as = Object.freeze({ __proto__: null, identity: os$1 });
const hs = y$1({ prefix: "0", name: "base2", alphabet: "01", bitsPerChar: 1 });
var cs = Object.freeze({ __proto__: null, base2: hs });
const ls = y$1({ prefix: "7", name: "base8", alphabet: "01234567", bitsPerChar: 3 });
var us = Object.freeze({ __proto__: null, base8: ls });
const ds = K$2({ prefix: "9", name: "base10", alphabet: "0123456789" });
var gs = Object.freeze({ __proto__: null, base10: ds });
const ps = y$1({ prefix: "f", name: "base16", alphabet: "0123456789abcdef", bitsPerChar: 4 }), Ds = y$1({ prefix: "F", name: "base16upper", alphabet: "0123456789ABCDEF", bitsPerChar: 4 });
var ys = Object.freeze({ __proto__: null, base16: ps, base16upper: Ds });
const ms = y$1({ prefix: "b", name: "base32", alphabet: "abcdefghijklmnopqrstuvwxyz234567", bitsPerChar: 5 }), bs = y$1({ prefix: "B", name: "base32upper", alphabet: "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567", bitsPerChar: 5 }), fs = y$1({ prefix: "c", name: "base32pad", alphabet: "abcdefghijklmnopqrstuvwxyz234567=", bitsPerChar: 5 }), Es = y$1({ prefix: "C", name: "base32padupper", alphabet: "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567=", bitsPerChar: 5 }), ws = y$1({ prefix: "v", name: "base32hex", alphabet: "0123456789abcdefghijklmnopqrstuv", bitsPerChar: 5 }), vs = y$1({ prefix: "V", name: "base32hexupper", alphabet: "0123456789ABCDEFGHIJKLMNOPQRSTUV", bitsPerChar: 5 }), Is = y$1({ prefix: "t", name: "base32hexpad", alphabet: "0123456789abcdefghijklmnopqrstuv=", bitsPerChar: 5 }), Cs = y$1({ prefix: "T", name: "base32hexpadupper", alphabet: "0123456789ABCDEFGHIJKLMNOPQRSTUV=", bitsPerChar: 5 }), _s = y$1({ prefix: "h", name: "base32z", alphabet: "ybndrfg8ejkmcpqxot1uwisza345h769", bitsPerChar: 5 });
var Rs = Object.freeze({ __proto__: null, base32: ms, base32upper: bs, base32pad: fs, base32padupper: Es, base32hex: ws, base32hexupper: vs, base32hexpad: Is, base32hexpadupper: Cs, base32z: _s });
const Ts = K$2({ prefix: "k", name: "base36", alphabet: "0123456789abcdefghijklmnopqrstuvwxyz" }), Ss = K$2({ prefix: "K", name: "base36upper", alphabet: "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ" });
var Ps = Object.freeze({ __proto__: null, base36: Ts, base36upper: Ss });
const xs = K$2({ name: "base58btc", prefix: "z", alphabet: "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz" }), Os = K$2({ name: "base58flickr", prefix: "Z", alphabet: "123456789abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ" });
var As = Object.freeze({ __proto__: null, base58btc: xs, base58flickr: Os });
const zs = y$1({ prefix: "m", name: "base64", alphabet: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/", bitsPerChar: 6 }), Ns = y$1({ prefix: "M", name: "base64pad", alphabet: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=", bitsPerChar: 6 }), Ls = y$1({ prefix: "u", name: "base64url", alphabet: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_", bitsPerChar: 6 }), Us = y$1({ prefix: "U", name: "base64urlpad", alphabet: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_=", bitsPerChar: 6 });
var $s = Object.freeze({ __proto__: null, base64: zs, base64pad: Ns, base64url: Ls, base64urlpad: Us });
const Fe$1 = Array.from("🚀🪐☄🛰🌌🌑🌒🌓🌔🌕🌖🌗🌘🌍🌏🌎🐉☀💻🖥💾💿😂❤😍🤣😊🙏💕😭😘👍😅👏😁🔥🥰💔💖💙😢🤔😆🙄💪😉☺👌🤗💜😔😎😇🌹🤦🎉💞✌✨🤷😱😌🌸🙌😋💗💚😏💛🙂💓🤩😄😀🖤😃💯🙈👇🎶😒🤭❣😜💋👀😪😑💥🙋😞😩😡🤪👊🥳😥🤤👉💃😳✋😚😝😴🌟😬🙃🍀🌷😻😓⭐✅🥺🌈😈🤘💦✔😣🏃💐☹🎊💘😠☝😕🌺🎂🌻😐🖕💝🙊😹🗣💫💀👑🎵🤞😛🔴😤🌼😫⚽🤙☕🏆🤫👈😮🙆🍻🍃🐶💁😲🌿🧡🎁⚡🌞🎈❌✊👋😰🤨😶🤝🚶💰🍓💢🤟🙁🚨💨🤬✈🎀🍺🤓😙💟🌱😖👶🥴▶➡❓💎💸⬇😨🌚🦋😷🕺⚠🙅😟😵👎🤲🤠🤧📌🔵💅🧐🐾🍒😗🤑🌊🤯🐷☎💧😯💆👆🎤🙇🍑❄🌴💣🐸💌📍🥀🤢👅💡💩👐📸👻🤐🤮🎼🥵🚩🍎🍊👼💍📣🥂"), Fs = Fe$1.reduce((n2, e, t) => (n2[t] = e, n2), []), ks = Fe$1.reduce((n2, e, t) => (n2[e.codePointAt(0)] = t, n2), []);
function Bs(n2) {
  return n2.reduce((e, t) => (e += Fs[t], e), "");
}
function Ms(n2) {
  const e = [];
  for (const t of n2) {
    const i2 = ks[t.codePointAt(0)];
    if (i2 === void 0)
      throw new Error(`Non-base256emoji character: ${t}`);
    e.push(i2);
  }
  return new Uint8Array(e);
}
const Ks = Q$1({ prefix: "🚀", name: "base256emoji", encode: Bs, decode: Ms });
var Vs = Object.freeze({ __proto__: null, base256emoji: Ks }), qs = Be$1, ke$1 = 128, js = 127, Gs = ~js, Ys = Math.pow(2, 31);
function Be$1(n2, e, t) {
  e = e || [], t = t || 0;
  for (var i2 = t; n2 >= Ys; )
    e[t++] = n2 & 255 | ke$1, n2 /= 128;
  for (; n2 & Gs; )
    e[t++] = n2 & 255 | ke$1, n2 >>>= 7;
  return e[t] = n2 | 0, Be$1.bytes = t - i2 + 1, e;
}
var Hs = de$1, Js = 128, Me = 127;
function de$1(n2, i2) {
  var t = 0, i2 = i2 || 0, s = 0, r = i2, o2, a3 = n2.length;
  do {
    if (r >= a3)
      throw de$1.bytes = 0, new RangeError("Could not decode varint");
    o2 = n2[r++], t += s < 28 ? (o2 & Me) << s : (o2 & Me) * Math.pow(2, s), s += 7;
  } while (o2 >= Js);
  return de$1.bytes = r - i2, t;
}
var Xs = Math.pow(2, 7), Ws = Math.pow(2, 14), Qs = Math.pow(2, 21), Zs = Math.pow(2, 28), er$1 = Math.pow(2, 35), tr$1 = Math.pow(2, 42), ir$1 = Math.pow(2, 49), sr$1 = Math.pow(2, 56), rr$1 = Math.pow(2, 63), nr$1 = function(n2) {
  return n2 < Xs ? 1 : n2 < Ws ? 2 : n2 < Qs ? 3 : n2 < Zs ? 4 : n2 < er$1 ? 5 : n2 < tr$1 ? 6 : n2 < ir$1 ? 7 : n2 < sr$1 ? 8 : n2 < rr$1 ? 9 : 10;
}, or$1 = { encode: qs, decode: Hs, encodingLength: nr$1 }, Ke$1 = or$1;
const Ve = (n2, e, t = 0) => (Ke$1.encode(n2, e, t), e), qe = (n2) => Ke$1.encodingLength(n2), ge$1 = (n2, e) => {
  const t = e.byteLength, i2 = qe(n2), s = i2 + qe(t), r = new Uint8Array(s + t);
  return Ve(n2, r, 0), Ve(t, r, i2), r.set(e, s), new ar$1(n2, t, e, r);
};
let ar$1 = class ar {
  constructor(e, t, i2, s) {
    this.code = e, this.size = t, this.digest = i2, this.bytes = s;
  }
};
const je$1 = ({ name: n2, code: e, encode: t }) => new hr$1(n2, e, t);
let hr$1 = class hr {
  constructor(e, t, i2) {
    this.name = e, this.code = t, this.encode = i2;
  }
  digest(e) {
    if (e instanceof Uint8Array) {
      const t = this.encode(e);
      return t instanceof Uint8Array ? ge$1(this.code, t) : t.then((i2) => ge$1(this.code, i2));
    } else
      throw Error("Unknown type, must be binary type");
  }
};
const Ge$1 = (n2) => async (e) => new Uint8Array(await crypto.subtle.digest(n2, e)), cr$1 = je$1({ name: "sha2-256", code: 18, encode: Ge$1("SHA-256") }), lr$1 = je$1({ name: "sha2-512", code: 19, encode: Ge$1("SHA-512") });
var ur$1 = Object.freeze({ __proto__: null, sha256: cr$1, sha512: lr$1 });
const Ye$1 = 0, dr$1 = "identity", He$1 = Ue$1, gr$1 = (n2) => ge$1(Ye$1, He$1(n2)), pr$1 = { code: Ye$1, name: dr$1, encode: He$1, digest: gr$1 };
var Dr$1 = Object.freeze({ __proto__: null, identity: pr$1 });
new TextEncoder(), new TextDecoder();
const Je$1 = { ...as, ...cs, ...us, ...gs, ...ys, ...Rs, ...Ps, ...As, ...$s, ...Vs };
({ ...ur$1, ...Dr$1 });
function Xe$1(n2) {
  return globalThis.Buffer != null ? new Uint8Array(n2.buffer, n2.byteOffset, n2.byteLength) : n2;
}
function yr$1(n2 = 0) {
  return globalThis.Buffer != null && globalThis.Buffer.allocUnsafe != null ? Xe$1(globalThis.Buffer.allocUnsafe(n2)) : new Uint8Array(n2);
}
function We$2(n2, e, t, i2) {
  return { name: n2, prefix: e, encoder: { name: n2, prefix: e, encode: t }, decoder: { decode: i2 } };
}
const Qe$1 = We$2("utf8", "u", (n2) => "u" + new TextDecoder("utf8").decode(n2), (n2) => new TextEncoder().encode(n2.substring(1))), pe$1 = We$2("ascii", "a", (n2) => {
  let e = "a";
  for (let t = 0; t < n2.length; t++)
    e += String.fromCharCode(n2[t]);
  return e;
}, (n2) => {
  n2 = n2.substring(1);
  const e = yr$1(n2.length);
  for (let t = 0; t < n2.length; t++)
    e[t] = n2.charCodeAt(t);
  return e;
}), mr$1 = { utf8: Qe$1, "utf-8": Qe$1, hex: Je$1.base16, latin1: pe$1, ascii: pe$1, binary: pe$1, ...Je$1 };
function br$1(n2, e = "utf8") {
  const t = mr$1[e];
  if (!t)
    throw new Error(`Unsupported encoding "${e}"`);
  return (e === "utf8" || e === "utf-8") && globalThis.Buffer != null && globalThis.Buffer.from != null ? Xe$1(globalThis.Buffer.from(n2, "utf-8")) : t.decoder.decode(`${t.prefix}${n2}`);
}
const De$1 = "wc", Ze$1 = 2, Z$2 = "core", z$2 = `${De$1}@2:${Z$2}:`, et$1 = { name: Z$2, logger: "error" }, tt$1 = { database: ":memory:" }, it$1 = "crypto", ye$1 = "client_ed25519_seed", st$1 = cjs$3.ONE_DAY, rt$1 = "keychain", nt$1 = "0.3", ot$1 = "messages", at$1 = "0.3", ht$1 = cjs$3.SIX_HOURS, ct$1 = "publisher", lt$1 = "irn", ut$1 = "error", me$1 = "wss://relay.walletconnect.com", be$1 = "wss://relay.walletconnect.org", dt$1 = "relayer", v$1 = { message: "relayer_message", message_ack: "relayer_message_ack", connect: "relayer_connect", disconnect: "relayer_disconnect", error: "relayer_error", connection_stalled: "relayer_connection_stalled", transport_closed: "relayer_transport_closed", publish: "relayer_publish" }, gt$1 = "_subscription", f$1 = { payload: "payload", connect: "connect", disconnect: "disconnect", error: "error" }, pt$1 = cjs$3.ONE_SECOND, Dt$1 = "2.12.2", yt$1 = 1e4, mt$1 = "0.3", bt$1 = "WALLETCONNECT_CLIENT_ID", S$2 = { created: "subscription_created", deleted: "subscription_deleted", expired: "subscription_expired", disabled: "subscription_disabled", sync: "subscription_sync", resubscribed: "subscription_resubscribed" }, ft$1 = "subscription", Et$1 = "0.3", wt$1 = cjs$3.FIVE_SECONDS * 1e3, vt$1 = "pairing", It$1 = "0.3", F$3 = { wc_pairingDelete: { req: { ttl: cjs$3.ONE_DAY, prompt: false, tag: 1e3 }, res: { ttl: cjs$3.ONE_DAY, prompt: false, tag: 1001 } }, wc_pairingPing: { req: { ttl: cjs$3.THIRTY_SECONDS, prompt: false, tag: 1002 }, res: { ttl: cjs$3.THIRTY_SECONDS, prompt: false, tag: 1003 } }, unregistered_method: { req: { ttl: cjs$3.ONE_DAY, prompt: false, tag: 0 }, res: { ttl: cjs$3.ONE_DAY, prompt: false, tag: 0 } } }, V$2 = { create: "pairing_create", expire: "pairing_expire", delete: "pairing_delete", ping: "pairing_ping" }, I$1 = { created: "history_created", updated: "history_updated", deleted: "history_deleted", sync: "history_sync" }, Ct$1 = "history", _t$1 = "0.3", Rt$1 = "expirer", C$1 = { created: "expirer_created", deleted: "expirer_deleted", expired: "expirer_expired", sync: "expirer_sync" }, Tt$1 = "0.3", ee$2 = "verify-api", k$1 = "https://verify.walletconnect.com", te$2 = "https://verify.walletconnect.org", St$1 = [k$1, te$2], Pt$1 = "echo", xt$1 = "https://echo.walletconnect.com";
let Ot$1 = class Ot {
  constructor(e, t) {
    this.core = e, this.logger = t, this.keychain = /* @__PURE__ */ new Map(), this.name = rt$1, this.version = nt$1, this.initialized = false, this.storagePrefix = z$2, this.init = async () => {
      if (!this.initialized) {
        const i2 = await this.getKeyChain();
        typeof i2 < "u" && (this.keychain = i2), this.initialized = true;
      }
    }, this.has = (i2) => (this.isInitialized(), this.keychain.has(i2)), this.set = async (i2, s) => {
      this.isInitialized(), this.keychain.set(i2, s), await this.persist();
    }, this.get = (i2) => {
      this.isInitialized();
      const s = this.keychain.get(i2);
      if (typeof s > "u") {
        const { message: r } = xe("NO_MATCHING_KEY", `${this.name}: ${i2}`);
        throw new Error(r);
      }
      return s;
    }, this.del = async (i2) => {
      this.isInitialized(), this.keychain.delete(i2), await this.persist();
    }, this.core = e, this.logger = E$2(t, this.name);
  }
  get context() {
    return y$3(this.logger);
  }
  get storageKey() {
    return this.storagePrefix + this.version + this.core.customStoragePrefix + "//" + this.name;
  }
  async setKeyChain(e) {
    await this.core.storage.setItem(this.storageKey, i0(e));
  }
  async getKeyChain() {
    const e = await this.core.storage.getItem(this.storageKey);
    return typeof e < "u" ? n0(e) : void 0;
  }
  async persist() {
    await this.setKeyChain(this.keychain);
  }
  isInitialized() {
    if (!this.initialized) {
      const { message: e } = xe("NOT_INITIALIZED", this.name);
      throw new Error(e);
    }
  }
};
let At$1 = class At {
  constructor(e, t, i2) {
    this.core = e, this.logger = t, this.name = it$1, this.initialized = false, this.init = async () => {
      this.initialized || (await this.keychain.init(), this.initialized = true);
    }, this.hasKeys = (s) => (this.isInitialized(), this.keychain.has(s)), this.getClientId = async () => {
      this.isInitialized();
      const s = await this.getClientSeed(), r = generateKeyPair(s);
      return encodeIss(r.publicKey);
    }, this.generateKeyPair = () => {
      this.isInitialized();
      const s = mu();
      return this.setPrivateKey(s.publicKey, s.privateKey);
    }, this.signJWT = async (s) => {
      this.isInitialized();
      const r = await this.getClientSeed(), o2 = generateKeyPair(r), a3 = gu(), h4 = st$1;
      return await signJWT(a3, s, h4, o2);
    }, this.generateSharedKey = (s, r, o2) => {
      this.isInitialized();
      const a3 = this.getPrivateKey(s), h4 = Au(a3, r);
      return this.setSymKey(h4, o2);
    }, this.setSymKey = async (s, r) => {
      this.isInitialized();
      const o2 = r || bu(s);
      return await this.keychain.set(o2, s), o2;
    }, this.deleteKeyPair = async (s) => {
      this.isInitialized(), await this.keychain.del(s);
    }, this.deleteSymKey = async (s) => {
      this.isInitialized(), await this.keychain.del(s);
    }, this.encode = async (s, r, o2) => {
      this.isInitialized();
      const a3 = eo(o2), h4 = safeJsonStringify(r);
      if (Eu(a3)) {
        const m3 = a3.senderPublicKey, L4 = a3.receiverPublicKey;
        s = await this.generateSharedKey(m3, L4);
      }
      const l2 = this.getSymKey(s), { type: d4, senderPublicKey: g3 } = a3;
      return wu({ type: d4, symKey: l2, message: h4, senderPublicKey: g3 });
    }, this.decode = async (s, r, o2) => {
      this.isInitialized();
      const a3 = Mu(r, o2);
      if (Eu(a3)) {
        const h4 = a3.receiverPublicKey, l2 = a3.senderPublicKey;
        s = await this.generateSharedKey(h4, l2);
      }
      try {
        const h4 = this.getSymKey(s), l2 = xu({ symKey: h4, encoded: r });
        return safeJsonParse(l2);
      } catch (h4) {
        this.logger.error(`Failed to decode message from topic: '${s}', clientId: '${await this.getClientId()}'`), this.logger.error(h4);
      }
    }, this.getPayloadType = (s) => {
      const r = Xi$1(s);
      return Mr(r.type);
    }, this.getPayloadSenderPublicKey = (s) => {
      const r = Xi$1(s);
      return r.senderPublicKey ? toString(r.senderPublicKey, zt$2) : void 0;
    }, this.core = e, this.logger = E$2(t, this.name), this.keychain = i2 || new Ot$1(this.core, this.logger);
  }
  get context() {
    return y$3(this.logger);
  }
  async setPrivateKey(e, t) {
    return await this.keychain.set(e, t), e;
  }
  getPrivateKey(e) {
    return this.keychain.get(e);
  }
  async getClientSeed() {
    let e = "";
    try {
      e = this.keychain.get(ye$1);
    } catch {
      e = gu(), await this.keychain.set(ye$1, e);
    }
    return br$1(e, "base16");
  }
  getSymKey(e) {
    return this.keychain.get(e);
  }
  isInitialized() {
    if (!this.initialized) {
      const { message: e } = xe("NOT_INITIALIZED", this.name);
      throw new Error(e);
    }
  }
};
let zt$1 = class zt extends a$1 {
  constructor(e, t) {
    super(e, t), this.logger = e, this.core = t, this.messages = /* @__PURE__ */ new Map(), this.name = ot$1, this.version = at$1, this.initialized = false, this.storagePrefix = z$2, this.init = async () => {
      if (!this.initialized) {
        this.logger.trace("Initialized");
        try {
          const i2 = await this.getRelayerMessages();
          typeof i2 < "u" && (this.messages = i2), this.logger.debug(`Successfully Restored records for ${this.name}`), this.logger.trace({ type: "method", method: "restore", size: this.messages.size });
        } catch (i2) {
          this.logger.debug(`Failed to Restore records for ${this.name}`), this.logger.error(i2);
        } finally {
          this.initialized = true;
        }
      }
    }, this.set = async (i2, s) => {
      this.isInitialized();
      const r = yu(s);
      let o2 = this.messages.get(i2);
      return typeof o2 > "u" && (o2 = {}), typeof o2[r] < "u" || (o2[r] = s, this.messages.set(i2, o2), await this.persist()), r;
    }, this.get = (i2) => {
      this.isInitialized();
      let s = this.messages.get(i2);
      return typeof s > "u" && (s = {}), s;
    }, this.has = (i2, s) => {
      this.isInitialized();
      const r = this.get(i2), o2 = yu(s);
      return typeof r[o2] < "u";
    }, this.del = async (i2) => {
      this.isInitialized(), this.messages.delete(i2), await this.persist();
    }, this.logger = E$2(e, this.name), this.core = t;
  }
  get context() {
    return y$3(this.logger);
  }
  get storageKey() {
    return this.storagePrefix + this.version + this.core.customStoragePrefix + "//" + this.name;
  }
  async setRelayerMessages(e) {
    await this.core.storage.setItem(this.storageKey, i0(e));
  }
  async getRelayerMessages() {
    const e = await this.core.storage.getItem(this.storageKey);
    return typeof e < "u" ? n0(e) : void 0;
  }
  async persist() {
    await this.setRelayerMessages(this.messages);
  }
  isInitialized() {
    if (!this.initialized) {
      const { message: e } = xe("NOT_INITIALIZED", this.name);
      throw new Error(e);
    }
  }
};
class Ir extends u {
  constructor(e, t) {
    super(e, t), this.relayer = e, this.logger = t, this.events = new eventsExports.EventEmitter(), this.name = ct$1, this.queue = /* @__PURE__ */ new Map(), this.publishTimeout = cjs$3.toMiliseconds(cjs$3.ONE_MINUTE), this.failedPublishTimeout = cjs$3.toMiliseconds(cjs$3.ONE_SECOND), this.needsTransportRestart = false, this.publish = async (i2, s, r) => {
      var o2;
      this.logger.debug("Publishing Payload"), this.logger.trace({ type: "method", method: "publish", params: { topic: i2, message: s, opts: r } });
      const a3 = (r == null ? void 0 : r.ttl) || ht$1, h4 = Su(r), l2 = (r == null ? void 0 : r.prompt) || false, d4 = (r == null ? void 0 : r.tag) || 0, g3 = (r == null ? void 0 : r.id) || getBigIntRpcId().toString(), m3 = { topic: i2, message: s, opts: { ttl: a3, relay: h4, prompt: l2, tag: d4, id: g3 } }, L4 = `Failed to publish payload, please try again. id:${g3} tag:${d4}`, u2 = Date.now();
      let p3, _3 = 1;
      try {
        for (; p3 === void 0; ) {
          if (Date.now() - u2 > this.publishTimeout)
            throw new Error(L4);
          this.logger.trace({ id: g3, attempts: _3 }, `publisher.publish - attempt ${_3}`), p3 = await await u0(this.rpcPublish(i2, s, a3, h4, l2, d4, g3).catch((D2) => this.logger.warn(D2)), this.publishTimeout, L4), _3++, p3 || await new Promise((D2) => setTimeout(D2, this.failedPublishTimeout));
        }
        this.relayer.events.emit(v$1.publish, m3), this.logger.debug("Successfully Published Payload"), this.logger.trace({ type: "method", method: "publish", params: { id: g3, topic: i2, message: s, opts: r } });
      } catch (D2) {
        if (this.logger.debug("Failed to Publish Payload"), this.logger.error(D2), (o2 = r == null ? void 0 : r.internal) != null && o2.throwOnFailedPublish)
          throw D2;
        this.queue.set(g3, m3);
      }
    }, this.on = (i2, s) => {
      this.events.on(i2, s);
    }, this.once = (i2, s) => {
      this.events.once(i2, s);
    }, this.off = (i2, s) => {
      this.events.off(i2, s);
    }, this.removeListener = (i2, s) => {
      this.events.removeListener(i2, s);
    }, this.relayer = e, this.logger = E$2(t, this.name), this.registerEventListeners();
  }
  get context() {
    return y$3(this.logger);
  }
  rpcPublish(e, t, i2, s, r, o2, a3) {
    var h4, l2, d4, g3;
    const m3 = { method: Nu(s.protocol).publish, params: { topic: e, message: t, ttl: i2, prompt: r, tag: o2 }, id: a3 };
    return Pe((h4 = m3.params) == null ? void 0 : h4.prompt) && ((l2 = m3.params) == null || delete l2.prompt), Pe((d4 = m3.params) == null ? void 0 : d4.tag) && ((g3 = m3.params) == null || delete g3.tag), this.logger.debug("Outgoing Relay Payload"), this.logger.trace({ type: "message", direction: "outgoing", request: m3 }), this.relayer.request(m3);
  }
  removeRequestFromQueue(e) {
    this.queue.delete(e);
  }
  checkQueue() {
    this.queue.forEach(async (e) => {
      const { topic: t, message: i2, opts: s } = e;
      await this.publish(t, i2, s);
    });
  }
  registerEventListeners() {
    this.relayer.core.heartbeat.on(cjs$4.HEARTBEAT_EVENTS.pulse, () => {
      if (this.needsTransportRestart) {
        this.needsTransportRestart = false, this.relayer.events.emit(v$1.connection_stalled);
        return;
      }
      this.checkQueue();
    }), this.relayer.on(v$1.message_ack, (e) => {
      this.removeRequestFromQueue(e.id.toString());
    });
  }
}
let Cr$1 = class Cr {
  constructor() {
    this.map = /* @__PURE__ */ new Map(), this.set = (e, t) => {
      const i2 = this.get(e);
      this.exists(e, t) || this.map.set(e, [...i2, t]);
    }, this.get = (e) => this.map.get(e) || [], this.exists = (e, t) => this.get(e).includes(t), this.delete = (e, t) => {
      if (typeof t > "u") {
        this.map.delete(e);
        return;
      }
      if (!this.map.has(e))
        return;
      const i2 = this.get(e);
      if (!this.exists(e, t))
        return;
      const s = i2.filter((r) => r !== t);
      if (!s.length) {
        this.map.delete(e);
        return;
      }
      this.map.set(e, s);
    }, this.clear = () => {
      this.map.clear();
    };
  }
  get topics() {
    return Array.from(this.map.keys());
  }
};
var _r$1 = Object.defineProperty, Rr$1 = Object.defineProperties, Tr$1 = Object.getOwnPropertyDescriptors, Nt$1 = Object.getOwnPropertySymbols, Sr$1 = Object.prototype.hasOwnProperty, Pr$1 = Object.prototype.propertyIsEnumerable, Lt$1 = (n2, e, t) => e in n2 ? _r$1(n2, e, { enumerable: true, configurable: true, writable: true, value: t }) : n2[e] = t, q$2 = (n2, e) => {
  for (var t in e || (e = {}))
    Sr$1.call(e, t) && Lt$1(n2, t, e[t]);
  if (Nt$1)
    for (var t of Nt$1(e))
      Pr$1.call(e, t) && Lt$1(n2, t, e[t]);
  return n2;
}, fe$1 = (n2, e) => Rr$1(n2, Tr$1(e));
let Ut$1 = class Ut2 extends d$1 {
  constructor(e, t) {
    super(e, t), this.relayer = e, this.logger = t, this.subscriptions = /* @__PURE__ */ new Map(), this.topicMap = new Cr$1(), this.events = new eventsExports.EventEmitter(), this.name = ft$1, this.version = Et$1, this.pending = /* @__PURE__ */ new Map(), this.cached = [], this.initialized = false, this.pendingSubscriptionWatchLabel = "pending_sub_watch_label", this.pollingInterval = 20, this.storagePrefix = z$2, this.subscribeTimeout = cjs$3.toMiliseconds(cjs$3.ONE_MINUTE), this.restartInProgress = false, this.batchSubscribeTopicsLimit = 500, this.init = async () => {
      this.initialized || (this.logger.trace("Initialized"), this.registerEventListeners(), this.clientId = await this.relayer.core.crypto.getClientId());
    }, this.subscribe = async (i2, s) => {
      await this.restartToComplete(), this.isInitialized(), this.logger.debug("Subscribing Topic"), this.logger.trace({ type: "method", method: "subscribe", params: { topic: i2, opts: s } });
      try {
        const r = Su(s), o2 = { topic: i2, relay: r };
        this.pending.set(i2, o2);
        const a3 = await this.rpcSubscribe(i2, r);
        return typeof a3 == "string" && (this.onSubscribe(a3, o2), this.logger.debug("Successfully Subscribed Topic"), this.logger.trace({ type: "method", method: "subscribe", params: { topic: i2, opts: s } })), a3;
      } catch (r) {
        throw this.logger.debug("Failed to Subscribe Topic"), this.logger.error(r), r;
      }
    }, this.unsubscribe = async (i2, s) => {
      await this.restartToComplete(), this.isInitialized(), typeof (s == null ? void 0 : s.id) < "u" ? await this.unsubscribeById(i2, s.id, s) : await this.unsubscribeByTopic(i2, s);
    }, this.isSubscribed = async (i2) => {
      if (this.topics.includes(i2))
        return true;
      const s = `${this.pendingSubscriptionWatchLabel}_${i2}`;
      return await new Promise((r, o2) => {
        const a3 = new cjs$3.Watch();
        a3.start(s);
        const h4 = setInterval(() => {
          !this.pending.has(i2) && this.topics.includes(i2) && (clearInterval(h4), a3.stop(s), r(true)), a3.elapsed(s) >= wt$1 && (clearInterval(h4), a3.stop(s), o2(new Error("Subscription resolution timeout")));
        }, this.pollingInterval);
      }).catch(() => false);
    }, this.on = (i2, s) => {
      this.events.on(i2, s);
    }, this.once = (i2, s) => {
      this.events.once(i2, s);
    }, this.off = (i2, s) => {
      this.events.off(i2, s);
    }, this.removeListener = (i2, s) => {
      this.events.removeListener(i2, s);
    }, this.start = async () => {
      await this.onConnect();
    }, this.stop = async () => {
      await this.onDisconnect();
    }, this.restart = async () => {
      this.restartInProgress = true, await this.restore(), await this.reset(), this.restartInProgress = false;
    }, this.relayer = e, this.logger = E$2(t, this.name), this.clientId = "";
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
  hasSubscription(e, t) {
    let i2 = false;
    try {
      i2 = this.getSubscription(e).topic === t;
    } catch {
    }
    return i2;
  }
  onEnable() {
    this.cached = [], this.initialized = true;
  }
  onDisable() {
    this.cached = this.values, this.subscriptions.clear(), this.topicMap.clear();
  }
  async unsubscribeByTopic(e, t) {
    const i2 = this.topicMap.get(e);
    await Promise.all(i2.map(async (s) => await this.unsubscribeById(e, s, t)));
  }
  async unsubscribeById(e, t, i2) {
    this.logger.debug("Unsubscribing Topic"), this.logger.trace({ type: "method", method: "unsubscribe", params: { topic: e, id: t, opts: i2 } });
    try {
      const s = Su(i2);
      await this.rpcUnsubscribe(e, t, s);
      const r = tr$2("USER_DISCONNECTED", `${this.name}, ${e}`);
      await this.onUnsubscribe(e, t, r), this.logger.debug("Successfully Unsubscribed Topic"), this.logger.trace({ type: "method", method: "unsubscribe", params: { topic: e, id: t, opts: i2 } });
    } catch (s) {
      throw this.logger.debug("Failed to Unsubscribe Topic"), this.logger.error(s), s;
    }
  }
  async rpcSubscribe(e, t) {
    const i2 = { method: Nu(t.protocol).subscribe, params: { topic: e } };
    this.logger.debug("Outgoing Relay Payload"), this.logger.trace({ type: "payload", direction: "outgoing", request: i2 });
    try {
      return await await u0(this.relayer.request(i2).catch((s) => this.logger.warn(s)), this.subscribeTimeout) ? yu(e + this.clientId) : null;
    } catch {
      this.logger.debug("Outgoing Relay Subscribe Payload stalled"), this.relayer.events.emit(v$1.connection_stalled);
    }
    return null;
  }
  async rpcBatchSubscribe(e) {
    if (!e.length)
      return;
    const t = e[0].relay, i2 = { method: Nu(t.protocol).batchSubscribe, params: { topics: e.map((s) => s.topic) } };
    this.logger.debug("Outgoing Relay Payload"), this.logger.trace({ type: "payload", direction: "outgoing", request: i2 });
    try {
      return await await u0(this.relayer.request(i2).catch((s) => this.logger.warn(s)), this.subscribeTimeout);
    } catch {
      this.relayer.events.emit(v$1.connection_stalled);
    }
  }
  rpcUnsubscribe(e, t, i2) {
    const s = { method: Nu(i2.protocol).unsubscribe, params: { topic: e, id: t } };
    return this.logger.debug("Outgoing Relay Payload"), this.logger.trace({ type: "payload", direction: "outgoing", request: s }), this.relayer.request(s);
  }
  onSubscribe(e, t) {
    this.setSubscription(e, fe$1(q$2({}, t), { id: e })), this.pending.delete(t.topic);
  }
  onBatchSubscribe(e) {
    e.length && e.forEach((t) => {
      this.setSubscription(t.id, q$2({}, t)), this.pending.delete(t.topic);
    });
  }
  async onUnsubscribe(e, t, i2) {
    this.events.removeAllListeners(t), this.hasSubscription(t, e) && this.deleteSubscription(t, i2), await this.relayer.messages.del(e);
  }
  async setRelayerSubscriptions(e) {
    await this.relayer.core.storage.setItem(this.storageKey, e);
  }
  async getRelayerSubscriptions() {
    return await this.relayer.core.storage.getItem(this.storageKey);
  }
  setSubscription(e, t) {
    this.logger.debug("Setting subscription"), this.logger.trace({ type: "method", method: "setSubscription", id: e, subscription: t }), this.addSubscription(e, t);
  }
  addSubscription(e, t) {
    this.subscriptions.set(e, q$2({}, t)), this.topicMap.set(t.topic, e), this.events.emit(S$2.created, t);
  }
  getSubscription(e) {
    this.logger.debug("Getting subscription"), this.logger.trace({ type: "method", method: "getSubscription", id: e });
    const t = this.subscriptions.get(e);
    if (!t) {
      const { message: i2 } = xe("NO_MATCHING_KEY", `${this.name}: ${e}`);
      throw new Error(i2);
    }
    return t;
  }
  deleteSubscription(e, t) {
    this.logger.debug("Deleting subscription"), this.logger.trace({ type: "method", method: "deleteSubscription", id: e, reason: t });
    const i2 = this.getSubscription(e);
    this.subscriptions.delete(e), this.topicMap.delete(i2.topic, e), this.events.emit(S$2.deleted, fe$1(q$2({}, i2), { reason: t }));
  }
  async persist() {
    await this.setRelayerSubscriptions(this.values), this.events.emit(S$2.sync);
  }
  async reset() {
    if (this.cached.length) {
      const e = Math.ceil(this.cached.length / this.batchSubscribeTopicsLimit);
      for (let t = 0; t < e; t++) {
        const i2 = this.cached.splice(0, this.batchSubscribeTopicsLimit);
        await this.batchSubscribe(i2);
      }
    }
    this.events.emit(S$2.resubscribed);
  }
  async restore() {
    try {
      const e = await this.getRelayerSubscriptions();
      if (typeof e > "u" || !e.length)
        return;
      if (this.subscriptions.size) {
        const { message: t } = xe("RESTORE_WILL_OVERRIDE", this.name);
        throw this.logger.error(t), this.logger.error(`${this.name}: ${JSON.stringify(this.values)}`), new Error(t);
      }
      this.cached = e, this.logger.debug(`Successfully Restored subscriptions for ${this.name}`), this.logger.trace({ type: "method", method: "restore", subscriptions: this.values });
    } catch (e) {
      this.logger.debug(`Failed to Restore subscriptions for ${this.name}`), this.logger.error(e);
    }
  }
  async batchSubscribe(e) {
    if (!e.length)
      return;
    const t = await this.rpcBatchSubscribe(e);
    Er$1(t) && this.onBatchSubscribe(t.map((i2, s) => fe$1(q$2({}, e[s]), { id: i2 })));
  }
  async onConnect() {
    await this.restart(), this.onEnable();
  }
  onDisconnect() {
    this.onDisable();
  }
  async checkPending() {
    if (!this.initialized || !this.relayer.connected)
      return;
    const e = [];
    this.pending.forEach((t) => {
      e.push(t);
    }), await this.batchSubscribe(e);
  }
  registerEventListeners() {
    this.relayer.core.heartbeat.on(cjs$4.HEARTBEAT_EVENTS.pulse, async () => {
      await this.checkPending();
    }), this.events.on(S$2.created, async (e) => {
      const t = S$2.created;
      this.logger.info(`Emitting ${t}`), this.logger.debug({ type: "event", event: t, data: e }), await this.persist();
    }), this.events.on(S$2.deleted, async (e) => {
      const t = S$2.deleted;
      this.logger.info(`Emitting ${t}`), this.logger.debug({ type: "event", event: t, data: e }), await this.persist();
    });
  }
  isInitialized() {
    if (!this.initialized) {
      const { message: e } = xe("NOT_INITIALIZED", this.name);
      throw new Error(e);
    }
  }
  async restartToComplete() {
    this.restartInProgress && await new Promise((e) => {
      const t = setInterval(() => {
        this.restartInProgress || (clearInterval(t), e());
      }, this.pollingInterval);
    });
  }
};
var xr$1 = Object.defineProperty, $t$1 = Object.getOwnPropertySymbols, Or$1 = Object.prototype.hasOwnProperty, Ar$1 = Object.prototype.propertyIsEnumerable, Ft$1 = (n2, e, t) => e in n2 ? xr$1(n2, e, { enumerable: true, configurable: true, writable: true, value: t }) : n2[e] = t, zr$1 = (n2, e) => {
  for (var t in e || (e = {}))
    Or$1.call(e, t) && Ft$1(n2, t, e[t]);
  if ($t$1)
    for (var t of $t$1(e))
      Ar$1.call(e, t) && Ft$1(n2, t, e[t]);
  return n2;
};
let kt$1 = class kt extends g$1 {
  constructor(e) {
    super(e), this.protocol = "wc", this.version = 2, this.events = new eventsExports.EventEmitter(), this.name = dt$1, this.transportExplicitlyClosed = false, this.initialized = false, this.connectionAttemptInProgress = false, this.connectionStatusPollingInterval = 20, this.staleConnectionErrors = ["socket hang up", "socket stalled", "interrupted"], this.hasExperiencedNetworkDisruption = false, this.requestsInFlight = /* @__PURE__ */ new Map(), this.heartBeatTimeout = cjs$3.toMiliseconds(cjs$3.THIRTY_SECONDS + cjs$3.ONE_SECOND), this.request = async (t) => {
      var i2, s;
      this.logger.debug("Publishing Request Payload");
      const r = t.id || getBigIntRpcId().toString();
      await this.toEstablishConnection();
      try {
        const o2 = this.provider.request(t);
        this.requestsInFlight.set(r, { promise: o2, request: t }), this.logger.trace({ id: r, method: t.method, topic: (i2 = t.params) == null ? void 0 : i2.topic }, "relayer.request - attempt to publish...");
        const a3 = await new Promise(async (h4, l2) => {
          const d4 = () => {
            l2(new Error(`relayer.request - publish interrupted, id: ${r}`));
          };
          this.provider.on(f$1.disconnect, d4);
          const g3 = await o2;
          this.provider.off(f$1.disconnect, d4), h4(g3);
        });
        return this.logger.trace({ id: r, method: t.method, topic: (s = t.params) == null ? void 0 : s.topic }, "relayer.request - published"), a3;
      } catch (o2) {
        throw this.logger.debug(`Failed to Publish Request: ${r}`), o2;
      } finally {
        this.requestsInFlight.delete(r);
      }
    }, this.resetPingTimeout = () => {
      if (pi())
        try {
          clearTimeout(this.pingTimeout), this.pingTimeout = setTimeout(() => {
            var t, i2, s;
            (s = (i2 = (t = this.provider) == null ? void 0 : t.connection) == null ? void 0 : i2.socket) == null || s.terminate();
          }, this.heartBeatTimeout);
        } catch (t) {
          this.logger.warn(t);
        }
    }, this.onPayloadHandler = (t) => {
      this.onProviderPayload(t), this.resetPingTimeout();
    }, this.onConnectHandler = () => {
      this.startPingTimeout(), this.events.emit(v$1.connect);
    }, this.onDisconnectHandler = () => {
      this.onProviderDisconnect();
    }, this.onProviderErrorHandler = (t) => {
      this.logger.error(t), this.events.emit(v$1.error, t), this.logger.info("Fatal socket error received, closing transport"), this.transportClose();
    }, this.registerProviderListeners = () => {
      this.provider.on(f$1.payload, this.onPayloadHandler), this.provider.on(f$1.connect, this.onConnectHandler), this.provider.on(f$1.disconnect, this.onDisconnectHandler), this.provider.on(f$1.error, this.onProviderErrorHandler);
    }, this.core = e.core, this.logger = typeof e.logger < "u" && typeof e.logger != "string" ? E$2(e.logger, this.name) : nt$2(k$2({ level: e.logger || ut$1 })), this.messages = new zt$1(this.logger, e.core), this.subscriber = new Ut$1(this, this.logger), this.publisher = new Ir(this, this.logger), this.relayUrl = (e == null ? void 0 : e.relayUrl) || me$1, this.projectId = e.projectId, this.bundleId = Wo(), this.provider = {};
  }
  async init() {
    this.logger.trace("Initialized"), this.registerEventListeners(), await this.createProvider(), await Promise.all([this.messages.init(), this.subscriber.init()]);
    try {
      await this.transportOpen();
    } catch {
      this.logger.warn(`Connection via ${this.relayUrl} failed, attempting to connect via failover domain ${be$1}...`), await this.restartTransport(be$1);
    }
    this.initialized = true, setTimeout(async () => {
      this.subscriber.topics.length === 0 && this.subscriber.pending.size === 0 && (this.logger.info("No topics subscribed to after init, closing transport"), await this.transportClose(), this.transportExplicitlyClosed = false);
    }, yt$1);
  }
  get context() {
    return y$3(this.logger);
  }
  get connected() {
    var e, t, i2;
    return ((i2 = (t = (e = this.provider) == null ? void 0 : e.connection) == null ? void 0 : t.socket) == null ? void 0 : i2.readyState) === 1;
  }
  get connecting() {
    var e, t, i2;
    return ((i2 = (t = (e = this.provider) == null ? void 0 : e.connection) == null ? void 0 : t.socket) == null ? void 0 : i2.readyState) === 0;
  }
  async publish(e, t, i2) {
    this.isInitialized(), await this.publisher.publish(e, t, i2), await this.recordMessageEvent({ topic: e, message: t, publishedAt: Date.now() });
  }
  async subscribe(e, t) {
    var i2;
    this.isInitialized();
    let s = ((i2 = this.subscriber.topicMap.get(e)) == null ? void 0 : i2[0]) || "", r;
    const o2 = (a3) => {
      a3.topic === e && (this.subscriber.off(S$2.created, o2), r());
    };
    return await Promise.all([new Promise((a3) => {
      r = a3, this.subscriber.on(S$2.created, o2);
    }), new Promise(async (a3) => {
      s = await this.subscriber.subscribe(e, t) || s, a3();
    })]), s;
  }
  async unsubscribe(e, t) {
    this.isInitialized(), await this.subscriber.unsubscribe(e, t);
  }
  on(e, t) {
    this.events.on(e, t);
  }
  once(e, t) {
    this.events.once(e, t);
  }
  off(e, t) {
    this.events.off(e, t);
  }
  removeListener(e, t) {
    this.events.removeListener(e, t);
  }
  async transportDisconnect() {
    if (!this.hasExperiencedNetworkDisruption && this.connected && this.requestsInFlight.size > 0)
      try {
        await Promise.all(Array.from(this.requestsInFlight.values()).map((e) => e.promise));
      } catch (e) {
        this.logger.warn(e);
      }
    this.hasExperiencedNetworkDisruption || this.connected ? await u0(this.provider.disconnect(), 2e3, "provider.disconnect()").catch(() => this.onProviderDisconnect()) : this.onProviderDisconnect();
  }
  async transportClose() {
    this.transportExplicitlyClosed = true, await this.transportDisconnect();
  }
  async transportOpen(e) {
    await this.confirmOnlineStateOrThrow(), e && e !== this.relayUrl && (this.relayUrl = e, await this.transportDisconnect(), await this.createProvider()), this.connectionAttemptInProgress = true, this.transportExplicitlyClosed = false;
    try {
      await new Promise(async (t, i2) => {
        const s = () => {
          this.provider.off(f$1.disconnect, s), i2(new Error("Connection interrupted while trying to subscribe"));
        };
        this.provider.on(f$1.disconnect, s), await u0(this.provider.connect(), cjs$3.toMiliseconds(cjs$3.ONE_MINUTE), `Socket stalled when trying to connect to ${this.relayUrl}`).catch((r) => {
          i2(r);
        }), await this.subscriber.start(), this.hasExperiencedNetworkDisruption = false, t();
      });
    } catch (t) {
      this.logger.error(t);
      const i2 = t;
      if (!this.isConnectionStalled(i2.message))
        throw t;
    } finally {
      this.connectionAttemptInProgress = false;
    }
  }
  async restartTransport(e) {
    this.connectionAttemptInProgress || (this.relayUrl = e || this.relayUrl, await this.confirmOnlineStateOrThrow(), await this.transportClose(), await this.createProvider(), await this.transportOpen());
  }
  async confirmOnlineStateOrThrow() {
    if (!await hh())
      throw new Error("No internet connection detected. Please restart your network and try again.");
  }
  startPingTimeout() {
    var e, t, i2, s, r;
    if (pi())
      try {
        (t = (e = this.provider) == null ? void 0 : e.connection) != null && t.socket && ((r = (s = (i2 = this.provider) == null ? void 0 : i2.connection) == null ? void 0 : s.socket) == null || r.once("ping", () => {
          this.resetPingTimeout();
        })), this.resetPingTimeout();
      } catch (o2) {
        this.logger.warn(o2);
      }
  }
  isConnectionStalled(e) {
    return this.staleConnectionErrors.some((t) => e.includes(t));
  }
  async createProvider() {
    this.provider.connection && this.unregisterProviderListeners();
    const e = await this.core.crypto.signJWT(this.relayUrl);
    this.provider = new JsonRpcProvider(new f$2($o({ sdkVersion: Dt$1, protocol: this.protocol, version: this.version, relayUrl: this.relayUrl, projectId: this.projectId, auth: e, useOnCloseEvent: true, bundleId: this.bundleId }))), this.registerProviderListeners();
  }
  async recordMessageEvent(e) {
    const { topic: t, message: i2 } = e;
    await this.messages.set(t, i2);
  }
  async shouldIgnoreMessageEvent(e) {
    const { topic: t, message: i2 } = e;
    if (!i2 || i2.length === 0)
      return this.logger.debug(`Ignoring invalid/empty message: ${i2}`), true;
    if (!await this.subscriber.isSubscribed(t))
      return this.logger.debug(`Ignoring message for non-subscribed topic ${t}`), true;
    const s = this.messages.has(t, i2);
    return s && this.logger.debug(`Ignoring duplicate message: ${i2}`), s;
  }
  async onProviderPayload(e) {
    if (this.logger.debug("Incoming Relay Payload"), this.logger.trace({ type: "payload", direction: "incoming", payload: e }), isJsonRpcRequest(e)) {
      if (!e.method.endsWith(gt$1))
        return;
      const t = e.params, { topic: i2, message: s, publishedAt: r } = t.data, o2 = { topic: i2, message: s, publishedAt: r };
      this.logger.debug("Emitting Relayer Payload"), this.logger.trace(zr$1({ type: "event", event: t.id }, o2)), this.events.emit(t.id, o2), await this.acknowledgePayload(e), await this.onMessageEvent(o2);
    } else
      isJsonRpcResponse(e) && this.events.emit(v$1.message_ack, e);
  }
  async onMessageEvent(e) {
    await this.shouldIgnoreMessageEvent(e) || (this.events.emit(v$1.message, e), await this.recordMessageEvent(e));
  }
  async acknowledgePayload(e) {
    const t = formatJsonRpcResult(e.id, true);
    await this.provider.connection.send(t);
  }
  unregisterProviderListeners() {
    this.provider.off(f$1.payload, this.onPayloadHandler), this.provider.off(f$1.connect, this.onConnectHandler), this.provider.off(f$1.disconnect, this.onDisconnectHandler), this.provider.off(f$1.error, this.onProviderErrorHandler);
  }
  async registerEventListeners() {
    let e = await hh();
    ch(async (t) => {
      e !== t && (e = t, t ? await this.restartTransport().catch((i2) => this.logger.error(i2)) : (this.hasExperiencedNetworkDisruption = true, await this.transportDisconnect(), this.transportExplicitlyClosed = false));
    });
  }
  async onProviderDisconnect() {
    await this.subscriber.stop(), this.events.emit(v$1.disconnect), this.connectionAttemptInProgress = false, !this.transportExplicitlyClosed && setTimeout(async () => {
      await this.transportOpen().catch((e) => this.logger.error(e));
    }, cjs$3.toMiliseconds(pt$1));
  }
  isInitialized() {
    if (!this.initialized) {
      const { message: e } = xe("NOT_INITIALIZED", this.name);
      throw new Error(e);
    }
  }
  async toEstablishConnection() {
    await this.confirmOnlineStateOrThrow(), !this.connected && (this.connectionAttemptInProgress && await new Promise((e) => {
      const t = setInterval(() => {
        this.connected && (clearInterval(t), e());
      }, this.connectionStatusPollingInterval);
    }), await this.transportOpen());
  }
};
var Nr$1 = Object.defineProperty, Bt$2 = Object.getOwnPropertySymbols, Lr = Object.prototype.hasOwnProperty, Ur = Object.prototype.propertyIsEnumerable, Mt$1 = (n2, e, t) => e in n2 ? Nr$1(n2, e, { enumerable: true, configurable: true, writable: true, value: t }) : n2[e] = t, Kt$1 = (n2, e) => {
  for (var t in e || (e = {}))
    Lr.call(e, t) && Mt$1(n2, t, e[t]);
  if (Bt$2)
    for (var t of Bt$2(e))
      Ur.call(e, t) && Mt$1(n2, t, e[t]);
  return n2;
};
let Vt$1 = class Vt extends p$1 {
  constructor(e, t, i2, s = z$2, r = void 0) {
    super(e, t, i2, s), this.core = e, this.logger = t, this.name = i2, this.map = /* @__PURE__ */ new Map(), this.version = mt$1, this.cached = [], this.initialized = false, this.storagePrefix = z$2, this.recentlyDeleted = [], this.recentlyDeletedLimit = 200, this.init = async () => {
      this.initialized || (this.logger.trace("Initialized"), await this.restore(), this.cached.forEach((o2) => {
        this.getKey && o2 !== null && !Pe(o2) ? this.map.set(this.getKey(o2), o2) : Gu(o2) ? this.map.set(o2.id, o2) : Yu(o2) && this.map.set(o2.topic, o2);
      }), this.cached = [], this.initialized = true);
    }, this.set = async (o2, a3) => {
      this.isInitialized(), this.map.has(o2) ? await this.update(o2, a3) : (this.logger.debug("Setting value"), this.logger.trace({ type: "method", method: "set", key: o2, value: a3 }), this.map.set(o2, a3), await this.persist());
    }, this.get = (o2) => (this.isInitialized(), this.logger.debug("Getting value"), this.logger.trace({ type: "method", method: "get", key: o2 }), this.getData(o2)), this.getAll = (o2) => (this.isInitialized(), o2 ? this.values.filter((a3) => Object.keys(o2).every((h4) => Yi(a3[h4], o2[h4]))) : this.values), this.update = async (o2, a3) => {
      this.isInitialized(), this.logger.debug("Updating value"), this.logger.trace({ type: "method", method: "update", key: o2, update: a3 });
      const h4 = Kt$1(Kt$1({}, this.getData(o2)), a3);
      this.map.set(o2, h4), await this.persist();
    }, this.delete = async (o2, a3) => {
      this.isInitialized(), this.map.has(o2) && (this.logger.debug("Deleting value"), this.logger.trace({ type: "method", method: "delete", key: o2, reason: a3 }), this.map.delete(o2), this.addToRecentlyDeleted(o2), await this.persist());
    }, this.logger = E$2(t, this.name), this.storagePrefix = s, this.getKey = r;
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
  addToRecentlyDeleted(e) {
    this.recentlyDeleted.push(e), this.recentlyDeleted.length >= this.recentlyDeletedLimit && this.recentlyDeleted.splice(0, this.recentlyDeletedLimit / 2);
  }
  async setDataStore(e) {
    await this.core.storage.setItem(this.storageKey, e);
  }
  async getDataStore() {
    return await this.core.storage.getItem(this.storageKey);
  }
  getData(e) {
    const t = this.map.get(e);
    if (!t) {
      if (this.recentlyDeleted.includes(e)) {
        const { message: s } = xe("MISSING_OR_INVALID", `Record was recently deleted - ${this.name}: ${e}`);
        throw this.logger.error(s), new Error(s);
      }
      const { message: i2 } = xe("NO_MATCHING_KEY", `${this.name}: ${e}`);
      throw this.logger.error(i2), new Error(i2);
    }
    return t;
  }
  async persist() {
    await this.setDataStore(this.values);
  }
  async restore() {
    try {
      const e = await this.getDataStore();
      if (typeof e > "u" || !e.length)
        return;
      if (this.map.size) {
        const { message: t } = xe("RESTORE_WILL_OVERRIDE", this.name);
        throw this.logger.error(t), new Error(t);
      }
      this.cached = e, this.logger.debug(`Successfully Restored value for ${this.name}`), this.logger.trace({ type: "method", method: "restore", value: this.values });
    } catch (e) {
      this.logger.debug(`Failed to Restore value for ${this.name}`), this.logger.error(e);
    }
  }
  isInitialized() {
    if (!this.initialized) {
      const { message: e } = xe("NOT_INITIALIZED", this.name);
      throw new Error(e);
    }
  }
};
let qt$1 = class qt {
  constructor(e, t) {
    this.core = e, this.logger = t, this.name = vt$1, this.version = It$1, this.events = new At$2(), this.initialized = false, this.storagePrefix = z$2, this.ignoredPayloadTypes = [lr$2], this.registeredMethods = [], this.init = async () => {
      this.initialized || (await this.pairings.init(), await this.cleanup(), this.registerRelayerEvents(), this.registerExpirerEvents(), this.initialized = true, this.logger.trace("Initialized"));
    }, this.register = ({ methods: i2 }) => {
      this.isInitialized(), this.registeredMethods = [.../* @__PURE__ */ new Set([...this.registeredMethods, ...i2])];
    }, this.create = async (i2) => {
      this.isInitialized();
      const s = gu(), r = await this.core.crypto.setSymKey(s), o2 = d0(cjs$3.FIVE_MINUTES), a3 = { protocol: lt$1 }, h4 = { topic: r, expiry: o2, relay: a3, active: false }, l2 = Du({ protocol: this.core.protocol, version: this.core.version, topic: r, symKey: s, relay: a3, expiryTimestamp: o2, methods: i2 == null ? void 0 : i2.methods });
      return await this.pairings.set(r, h4), await this.core.relayer.subscribe(r), this.core.expirer.set(r, o2), { topic: r, uri: l2 };
    }, this.pair = async (i2) => {
      this.isInitialized(), this.isValidPair(i2);
      const { topic: s, symKey: r, relay: o2, expiryTimestamp: a3, methods: h4 } = Pu(i2.uri);
      let l2;
      if (this.pairings.keys.includes(s) && (l2 = this.pairings.get(s), l2.active))
        throw new Error(`Pairing already exists: ${s}. Please try again with a new connection URI.`);
      const d4 = a3 || d0(cjs$3.FIVE_MINUTES), g3 = { topic: s, relay: o2, expiry: d4, active: false, methods: h4 };
      return await this.pairings.set(s, g3), this.core.expirer.set(s, d4), i2.activatePairing && await this.activate({ topic: s }), this.events.emit(V$2.create, g3), this.core.crypto.keychain.has(s) || await this.core.crypto.setSymKey(r, s), await this.core.relayer.subscribe(s, { relay: o2 }), g3;
    }, this.activate = async ({ topic: i2 }) => {
      this.isInitialized();
      const s = d0(cjs$3.THIRTY_DAYS);
      await this.pairings.update(i2, { active: true, expiry: s }), this.core.expirer.set(i2, s);
    }, this.ping = async (i2) => {
      this.isInitialized(), await this.isValidPing(i2);
      const { topic: s } = i2;
      if (this.pairings.keys.includes(s)) {
        const r = await this.sendRequest(s, "wc_pairingPing", {}), { done: o2, resolve: a3, reject: h4 } = a0();
        this.events.once(v0("pairing_ping", r), ({ error: l2 }) => {
          l2 ? h4(l2) : a3();
        }), await o2();
      }
    }, this.updateExpiry = async ({ topic: i2, expiry: s }) => {
      this.isInitialized(), await this.pairings.update(i2, { expiry: s });
    }, this.updateMetadata = async ({ topic: i2, metadata: s }) => {
      this.isInitialized(), await this.pairings.update(i2, { peerMetadata: s });
    }, this.getPairings = () => (this.isInitialized(), this.pairings.values), this.disconnect = async (i2) => {
      this.isInitialized(), await this.isValidDisconnect(i2);
      const { topic: s } = i2;
      this.pairings.keys.includes(s) && (await this.sendRequest(s, "wc_pairingDelete", tr$2("USER_DISCONNECTED")), await this.deletePairing(s));
    }, this.sendRequest = async (i2, s, r) => {
      const o2 = formatJsonRpcRequest(s, r), a3 = await this.core.crypto.encode(i2, o2), h4 = F$3[s].req;
      return this.core.history.set(i2, o2), this.core.relayer.publish(i2, a3, h4), o2.id;
    }, this.sendResult = async (i2, s, r) => {
      const o2 = formatJsonRpcResult(i2, r), a3 = await this.core.crypto.encode(s, o2), h4 = await this.core.history.get(s, i2), l2 = F$3[h4.request.method].res;
      await this.core.relayer.publish(s, a3, l2), await this.core.history.resolve(o2);
    }, this.sendError = async (i2, s, r) => {
      const o2 = formatJsonRpcError(i2, r), a3 = await this.core.crypto.encode(s, o2), h4 = await this.core.history.get(s, i2), l2 = F$3[h4.request.method] ? F$3[h4.request.method].res : F$3.unregistered_method.res;
      await this.core.relayer.publish(s, a3, l2), await this.core.history.resolve(o2);
    }, this.deletePairing = async (i2, s) => {
      await this.core.relayer.unsubscribe(i2), await Promise.all([this.pairings.delete(i2, tr$2("USER_DISCONNECTED")), this.core.crypto.deleteSymKey(i2), s ? Promise.resolve() : this.core.expirer.del(i2)]);
    }, this.cleanup = async () => {
      const i2 = this.pairings.getAll().filter((s) => p0(s.expiry));
      await Promise.all(i2.map((s) => this.deletePairing(s.topic)));
    }, this.onRelayEventRequest = (i2) => {
      const { topic: s, payload: r } = i2;
      switch (r.method) {
        case "wc_pairingPing":
          return this.onPairingPingRequest(s, r);
        case "wc_pairingDelete":
          return this.onPairingDeleteRequest(s, r);
        default:
          return this.onUnknownRpcMethodRequest(s, r);
      }
    }, this.onRelayEventResponse = async (i2) => {
      const { topic: s, payload: r } = i2, o2 = (await this.core.history.get(s, r.id)).request.method;
      switch (o2) {
        case "wc_pairingPing":
          return this.onPairingPingResponse(s, r);
        default:
          return this.onUnknownRpcMethodResponse(o2);
      }
    }, this.onPairingPingRequest = async (i2, s) => {
      const { id: r } = s;
      try {
        this.isValidPing({ topic: i2 }), await this.sendResult(r, i2, true), this.events.emit(V$2.ping, { id: r, topic: i2 });
      } catch (o2) {
        await this.sendError(r, i2, o2), this.logger.error(o2);
      }
    }, this.onPairingPingResponse = (i2, s) => {
      const { id: r } = s;
      setTimeout(() => {
        isJsonRpcResult(s) ? this.events.emit(v0("pairing_ping", r), {}) : isJsonRpcError(s) && this.events.emit(v0("pairing_ping", r), { error: s.error });
      }, 500);
    }, this.onPairingDeleteRequest = async (i2, s) => {
      const { id: r } = s;
      try {
        this.isValidDisconnect({ topic: i2 }), await this.deletePairing(i2), this.events.emit(V$2.delete, { id: r, topic: i2 });
      } catch (o2) {
        await this.sendError(r, i2, o2), this.logger.error(o2);
      }
    }, this.onUnknownRpcMethodRequest = async (i2, s) => {
      const { id: r, method: o2 } = s;
      try {
        if (this.registeredMethods.includes(o2))
          return;
        const a3 = tr$2("WC_METHOD_UNSUPPORTED", o2);
        await this.sendError(r, i2, a3), this.logger.error(a3);
      } catch (a3) {
        await this.sendError(r, i2, a3), this.logger.error(a3);
      }
    }, this.onUnknownRpcMethodResponse = (i2) => {
      this.registeredMethods.includes(i2) || this.logger.error(tr$2("WC_METHOD_UNSUPPORTED", i2));
    }, this.isValidPair = (i2) => {
      var s;
      if (!$u(i2)) {
        const { message: o2 } = xe("MISSING_OR_INVALID", `pair() params: ${i2}`);
        throw new Error(o2);
      }
      if (!Ju(i2.uri)) {
        const { message: o2 } = xe("MISSING_OR_INVALID", `pair() uri: ${i2.uri}`);
        throw new Error(o2);
      }
      const r = Pu(i2.uri);
      if (!((s = r == null ? void 0 : r.relay) != null && s.protocol)) {
        const { message: o2 } = xe("MISSING_OR_INVALID", "pair() uri#relay-protocol");
        throw new Error(o2);
      }
      if (!(r != null && r.symKey)) {
        const { message: o2 } = xe("MISSING_OR_INVALID", "pair() uri#symKey");
        throw new Error(o2);
      }
      if (r != null && r.expiryTimestamp && cjs$3.toMiliseconds(r == null ? void 0 : r.expiryTimestamp) < Date.now()) {
        const { message: o2 } = xe("EXPIRED", "pair() URI has expired. Please try again with a new connection URI.");
        throw new Error(o2);
      }
    }, this.isValidPing = async (i2) => {
      if (!$u(i2)) {
        const { message: r } = xe("MISSING_OR_INVALID", `ping() params: ${i2}`);
        throw new Error(r);
      }
      const { topic: s } = i2;
      await this.isValidPairingTopic(s);
    }, this.isValidDisconnect = async (i2) => {
      if (!$u(i2)) {
        const { message: r } = xe("MISSING_OR_INVALID", `disconnect() params: ${i2}`);
        throw new Error(r);
      }
      const { topic: s } = i2;
      await this.isValidPairingTopic(s);
    }, this.isValidPairingTopic = async (i2) => {
      if (!Gt$2(i2, false)) {
        const { message: s } = xe("MISSING_OR_INVALID", `pairing topic should be a string: ${i2}`);
        throw new Error(s);
      }
      if (!this.pairings.keys.includes(i2)) {
        const { message: s } = xe("NO_MATCHING_KEY", `pairing topic doesn't exist: ${i2}`);
        throw new Error(s);
      }
      if (p0(this.pairings.get(i2).expiry)) {
        await this.deletePairing(i2);
        const { message: s } = xe("EXPIRED", `pairing topic: ${i2}`);
        throw new Error(s);
      }
    }, this.core = e, this.logger = E$2(t, this.name), this.pairings = new Vt$1(this.core, this.logger, this.name, this.storagePrefix);
  }
  get context() {
    return y$3(this.logger);
  }
  isInitialized() {
    if (!this.initialized) {
      const { message: e } = xe("NOT_INITIALIZED", this.name);
      throw new Error(e);
    }
  }
  registerRelayerEvents() {
    this.core.relayer.on(v$1.message, async (e) => {
      const { topic: t, message: i2 } = e;
      if (!this.pairings.keys.includes(t) || this.ignoredPayloadTypes.includes(this.core.crypto.getPayloadType(i2)))
        return;
      const s = await this.core.crypto.decode(t, i2);
      try {
        isJsonRpcRequest(s) ? (this.core.history.set(t, s), this.onRelayEventRequest({ topic: t, payload: s })) : isJsonRpcResponse(s) && (await this.core.history.resolve(s), await this.onRelayEventResponse({ topic: t, payload: s }), this.core.history.delete(t, s.id));
      } catch (r) {
        this.logger.error(r);
      }
    });
  }
  registerExpirerEvents() {
    this.core.expirer.on(C$1.expired, async (e) => {
      const { topic: t } = l0(e.target);
      t && this.pairings.keys.includes(t) && (await this.deletePairing(t, true), this.events.emit(V$2.expire, { topic: t }));
    });
  }
};
let jt$1 = class jt extends h$1 {
  constructor(e, t) {
    super(e, t), this.core = e, this.logger = t, this.records = /* @__PURE__ */ new Map(), this.events = new eventsExports.EventEmitter(), this.name = Ct$1, this.version = _t$1, this.cached = [], this.initialized = false, this.storagePrefix = z$2, this.init = async () => {
      this.initialized || (this.logger.trace("Initialized"), await this.restore(), this.cached.forEach((i2) => this.records.set(i2.id, i2)), this.cached = [], this.registerEventListeners(), this.initialized = true);
    }, this.set = (i2, s, r) => {
      if (this.isInitialized(), this.logger.debug("Setting JSON-RPC request history record"), this.logger.trace({ type: "method", method: "set", topic: i2, request: s, chainId: r }), this.records.has(s.id))
        return;
      const o2 = { id: s.id, topic: i2, request: { method: s.method, params: s.params || null }, chainId: r, expiry: d0(cjs$3.THIRTY_DAYS) };
      this.records.set(o2.id, o2), this.persist(), this.events.emit(I$1.created, o2);
    }, this.resolve = async (i2) => {
      if (this.isInitialized(), this.logger.debug("Updating JSON-RPC response history record"), this.logger.trace({ type: "method", method: "update", response: i2 }), !this.records.has(i2.id))
        return;
      const s = await this.getRecord(i2.id);
      typeof s.response > "u" && (s.response = isJsonRpcError(i2) ? { error: i2.error } : { result: i2.result }, this.records.set(s.id, s), this.persist(), this.events.emit(I$1.updated, s));
    }, this.get = async (i2, s) => (this.isInitialized(), this.logger.debug("Getting record"), this.logger.trace({ type: "method", method: "get", topic: i2, id: s }), await this.getRecord(s)), this.delete = (i2, s) => {
      this.isInitialized(), this.logger.debug("Deleting record"), this.logger.trace({ type: "method", method: "delete", id: s }), this.values.forEach((r) => {
        if (r.topic === i2) {
          if (typeof s < "u" && r.id !== s)
            return;
          this.records.delete(r.id), this.events.emit(I$1.deleted, r);
        }
      }), this.persist();
    }, this.exists = async (i2, s) => (this.isInitialized(), this.records.has(s) ? (await this.getRecord(s)).topic === i2 : false), this.on = (i2, s) => {
      this.events.on(i2, s);
    }, this.once = (i2, s) => {
      this.events.once(i2, s);
    }, this.off = (i2, s) => {
      this.events.off(i2, s);
    }, this.removeListener = (i2, s) => {
      this.events.removeListener(i2, s);
    }, this.logger = E$2(t, this.name);
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
    const e = [];
    return this.values.forEach((t) => {
      if (typeof t.response < "u")
        return;
      const i2 = { topic: t.topic, request: formatJsonRpcRequest(t.request.method, t.request.params, t.id), chainId: t.chainId };
      return e.push(i2);
    }), e;
  }
  async setJsonRpcRecords(e) {
    await this.core.storage.setItem(this.storageKey, e);
  }
  async getJsonRpcRecords() {
    return await this.core.storage.getItem(this.storageKey);
  }
  getRecord(e) {
    this.isInitialized();
    const t = this.records.get(e);
    if (!t) {
      const { message: i2 } = xe("NO_MATCHING_KEY", `${this.name}: ${e}`);
      throw new Error(i2);
    }
    return t;
  }
  async persist() {
    await this.setJsonRpcRecords(this.values), this.events.emit(I$1.sync);
  }
  async restore() {
    try {
      const e = await this.getJsonRpcRecords();
      if (typeof e > "u" || !e.length)
        return;
      if (this.records.size) {
        const { message: t } = xe("RESTORE_WILL_OVERRIDE", this.name);
        throw this.logger.error(t), new Error(t);
      }
      this.cached = e, this.logger.debug(`Successfully Restored records for ${this.name}`), this.logger.trace({ type: "method", method: "restore", records: this.values });
    } catch (e) {
      this.logger.debug(`Failed to Restore records for ${this.name}`), this.logger.error(e);
    }
  }
  registerEventListeners() {
    this.events.on(I$1.created, (e) => {
      const t = I$1.created;
      this.logger.info(`Emitting ${t}`), this.logger.debug({ type: "event", event: t, record: e });
    }), this.events.on(I$1.updated, (e) => {
      const t = I$1.updated;
      this.logger.info(`Emitting ${t}`), this.logger.debug({ type: "event", event: t, record: e });
    }), this.events.on(I$1.deleted, (e) => {
      const t = I$1.deleted;
      this.logger.info(`Emitting ${t}`), this.logger.debug({ type: "event", event: t, record: e });
    }), this.core.heartbeat.on(cjs$4.HEARTBEAT_EVENTS.pulse, () => {
      this.cleanup();
    });
  }
  cleanup() {
    try {
      this.isInitialized();
      let e = false;
      this.records.forEach((t) => {
        cjs$3.toMiliseconds(t.expiry || 0) - Date.now() <= 0 && (this.logger.info(`Deleting expired history log: ${t.id}`), this.records.delete(t.id), this.events.emit(I$1.deleted, t, false), e = true);
      }), e && this.persist();
    } catch (e) {
      this.logger.warn(e);
    }
  }
  isInitialized() {
    if (!this.initialized) {
      const { message: e } = xe("NOT_INITIALIZED", this.name);
      throw new Error(e);
    }
  }
};
let Gt$1 = class Gt extends E$1 {
  constructor(e, t) {
    super(e, t), this.core = e, this.logger = t, this.expirations = /* @__PURE__ */ new Map(), this.events = new eventsExports.EventEmitter(), this.name = Rt$1, this.version = Tt$1, this.cached = [], this.initialized = false, this.storagePrefix = z$2, this.init = async () => {
      this.initialized || (this.logger.trace("Initialized"), await this.restore(), this.cached.forEach((i2) => this.expirations.set(i2.target, i2)), this.cached = [], this.registerEventListeners(), this.initialized = true);
    }, this.has = (i2) => {
      try {
        const s = this.formatTarget(i2);
        return typeof this.getExpiration(s) < "u";
      } catch {
        return false;
      }
    }, this.set = (i2, s) => {
      this.isInitialized();
      const r = this.formatTarget(i2), o2 = { target: r, expiry: s };
      this.expirations.set(r, o2), this.checkExpiry(r, o2), this.events.emit(C$1.created, { target: r, expiration: o2 });
    }, this.get = (i2) => {
      this.isInitialized();
      const s = this.formatTarget(i2);
      return this.getExpiration(s);
    }, this.del = (i2) => {
      if (this.isInitialized(), this.has(i2)) {
        const s = this.formatTarget(i2), r = this.getExpiration(s);
        this.expirations.delete(s), this.events.emit(C$1.deleted, { target: s, expiration: r });
      }
    }, this.on = (i2, s) => {
      this.events.on(i2, s);
    }, this.once = (i2, s) => {
      this.events.once(i2, s);
    }, this.off = (i2, s) => {
      this.events.off(i2, s);
    }, this.removeListener = (i2, s) => {
      this.events.removeListener(i2, s);
    }, this.logger = E$2(t, this.name);
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
  formatTarget(e) {
    if (typeof e == "string")
      return h0(e);
    if (typeof e == "number")
      return c0(e);
    const { message: t } = xe("UNKNOWN_TYPE", `Target type: ${typeof e}`);
    throw new Error(t);
  }
  async setExpirations(e) {
    await this.core.storage.setItem(this.storageKey, e);
  }
  async getExpirations() {
    return await this.core.storage.getItem(this.storageKey);
  }
  async persist() {
    await this.setExpirations(this.values), this.events.emit(C$1.sync);
  }
  async restore() {
    try {
      const e = await this.getExpirations();
      if (typeof e > "u" || !e.length)
        return;
      if (this.expirations.size) {
        const { message: t } = xe("RESTORE_WILL_OVERRIDE", this.name);
        throw this.logger.error(t), new Error(t);
      }
      this.cached = e, this.logger.debug(`Successfully Restored expirations for ${this.name}`), this.logger.trace({ type: "method", method: "restore", expirations: this.values });
    } catch (e) {
      this.logger.debug(`Failed to Restore expirations for ${this.name}`), this.logger.error(e);
    }
  }
  getExpiration(e) {
    const t = this.expirations.get(e);
    if (!t) {
      const { message: i2 } = xe("NO_MATCHING_KEY", `${this.name}: ${e}`);
      throw this.logger.warn(i2), new Error(i2);
    }
    return t;
  }
  checkExpiry(e, t) {
    const { expiry: i2 } = t;
    cjs$3.toMiliseconds(i2) - Date.now() <= 0 && this.expire(e, t);
  }
  expire(e, t) {
    this.expirations.delete(e), this.events.emit(C$1.expired, { target: e, expiration: t });
  }
  checkExpirations() {
    this.core.relayer.connected && this.expirations.forEach((e, t) => this.checkExpiry(t, e));
  }
  registerEventListeners() {
    this.core.heartbeat.on(cjs$4.HEARTBEAT_EVENTS.pulse, () => this.checkExpirations()), this.events.on(C$1.created, (e) => {
      const t = C$1.created;
      this.logger.info(`Emitting ${t}`), this.logger.debug({ type: "event", event: t, data: e }), this.persist();
    }), this.events.on(C$1.expired, (e) => {
      const t = C$1.expired;
      this.logger.info(`Emitting ${t}`), this.logger.debug({ type: "event", event: t, data: e }), this.persist();
    }), this.events.on(C$1.deleted, (e) => {
      const t = C$1.deleted;
      this.logger.info(`Emitting ${t}`), this.logger.debug({ type: "event", event: t, data: e }), this.persist();
    });
  }
  isInitialized() {
    if (!this.initialized) {
      const { message: e } = xe("NOT_INITIALIZED", this.name);
      throw new Error(e);
    }
  }
};
let Yt$2 = class Yt extends y$2 {
  constructor(e, t) {
    super(e, t), this.projectId = e, this.logger = t, this.name = ee$2, this.initialized = false, this.queue = [], this.verifyDisabled = false, this.init = async (i2) => {
      if (this.verifyDisabled || er$2() || !pr$2())
        return;
      const s = this.getVerifyUrl(i2 == null ? void 0 : i2.verifyUrl);
      this.verifyUrl !== s && this.removeIframe(), this.verifyUrl = s;
      try {
        await this.createIframe();
      } catch (r) {
        this.logger.info(`Verify iframe failed to load: ${this.verifyUrl}`), this.logger.info(r);
      }
      if (!this.initialized) {
        this.removeIframe(), this.verifyUrl = te$2;
        try {
          await this.createIframe();
        } catch (r) {
          this.logger.info(`Verify iframe failed to load: ${this.verifyUrl}`), this.logger.info(r), this.verifyDisabled = true;
        }
      }
    }, this.register = async (i2) => {
      this.initialized ? this.sendPost(i2.attestationId) : (this.addToQueue(i2.attestationId), await this.init());
    }, this.resolve = async (i2) => {
      if (this.isDevEnv)
        return "";
      const s = this.getVerifyUrl(i2 == null ? void 0 : i2.verifyUrl);
      let r;
      try {
        r = await this.fetchAttestation(i2.attestationId, s);
      } catch (o2) {
        this.logger.info(`failed to resolve attestation: ${i2.attestationId} from url: ${s}`), this.logger.info(o2), r = await this.fetchAttestation(i2.attestationId, te$2);
      }
      return r;
    }, this.fetchAttestation = async (i2, s) => {
      this.logger.info(`resolving attestation: ${i2} from url: ${s}`);
      const r = this.startAbortTimer(cjs$3.ONE_SECOND * 2), o2 = await fetch(`${s}/attestation/${i2}`, { signal: this.abortController.signal });
      return clearTimeout(r), o2.status === 200 ? await o2.json() : void 0;
    }, this.addToQueue = (i2) => {
      this.queue.push(i2);
    }, this.processQueue = () => {
      this.queue.length !== 0 && (this.queue.forEach((i2) => this.sendPost(i2)), this.queue = []);
    }, this.sendPost = (i2) => {
      var s;
      try {
        if (!this.iframe)
          return;
        (s = this.iframe.contentWindow) == null || s.postMessage(i2, "*"), this.logger.info(`postMessage sent: ${i2} ${this.verifyUrl}`);
      } catch {
      }
    }, this.createIframe = async () => {
      let i2;
      const s = (r) => {
        r.data === "verify_ready" && (this.onInit(), window.removeEventListener("message", s), i2());
      };
      await Promise.race([new Promise((r) => {
        const o2 = document.getElementById(ee$2);
        if (o2)
          return this.iframe = o2, this.onInit(), r();
        window.addEventListener("message", s);
        const a3 = document.createElement("iframe");
        a3.id = ee$2, a3.src = `${this.verifyUrl}/${this.projectId}`, a3.style.display = "none", document.body.append(a3), this.iframe = a3, i2 = r;
      }), new Promise((r, o2) => setTimeout(() => {
        window.removeEventListener("message", s), o2("verify iframe load timeout");
      }, cjs$3.toMiliseconds(cjs$3.FIVE_SECONDS)))]);
    }, this.onInit = () => {
      this.initialized = true, this.processQueue();
    }, this.removeIframe = () => {
      this.iframe && (this.iframe.remove(), this.iframe = void 0, this.initialized = false);
    }, this.getVerifyUrl = (i2) => {
      let s = i2 || k$1;
      return St$1.includes(s) || (this.logger.info(`verify url: ${s}, not included in trusted list, assigning default: ${k$1}`), s = k$1), s;
    }, this.logger = E$2(t, this.name), this.verifyUrl = k$1, this.abortController = new AbortController(), this.isDevEnv = pi() && define_process_env_default.IS_VITEST;
  }
  get context() {
    return y$3(this.logger);
  }
  startAbortTimer(e) {
    return this.abortController = new AbortController(), setTimeout(() => this.abortController.abort(), cjs$3.toMiliseconds(e));
  }
};
let Ht$2 = class Ht extends v$2 {
  constructor(e, t) {
    super(e, t), this.projectId = e, this.logger = t, this.context = Pt$1, this.registerDeviceToken = async (i2) => {
      const { clientId: s, token: r, notificationType: o2, enableEncrypted: a3 = false } = i2, h4 = `${xt$1}/${this.projectId}/clients`;
      await ke$2(h4, { method: "POST", headers: { "Content-Type": "application/json" }, body: JSON.stringify({ client_id: s, type: o2, token: r, always_raw: a3 }) });
    }, this.logger = E$2(t, this.context);
  }
};
var $r$1 = Object.defineProperty, Jt$2 = Object.getOwnPropertySymbols, Fr$1 = Object.prototype.hasOwnProperty, kr = Object.prototype.propertyIsEnumerable, Xt$2 = (n2, e, t) => e in n2 ? $r$1(n2, e, { enumerable: true, configurable: true, writable: true, value: t }) : n2[e] = t, Wt$2 = (n2, e) => {
  for (var t in e || (e = {}))
    Fr$1.call(e, t) && Xt$2(n2, t, e[t]);
  if (Jt$2)
    for (var t of Jt$2(e))
      kr.call(e, t) && Xt$2(n2, t, e[t]);
  return n2;
};
let ie$3 = class ie extends n {
  constructor(e) {
    var t;
    super(e), this.protocol = De$1, this.version = Ze$1, this.name = Z$2, this.events = new eventsExports.EventEmitter(), this.initialized = false, this.on = (o2, a3) => this.events.on(o2, a3), this.once = (o2, a3) => this.events.once(o2, a3), this.off = (o2, a3) => this.events.off(o2, a3), this.removeListener = (o2, a3) => this.events.removeListener(o2, a3), this.projectId = e == null ? void 0 : e.projectId, this.relayUrl = (e == null ? void 0 : e.relayUrl) || me$1, this.customStoragePrefix = e != null && e.customStoragePrefix ? `:${e.customStoragePrefix}` : "";
    const i2 = k$2({ level: typeof (e == null ? void 0 : e.logger) == "string" && e.logger ? e.logger : et$1.logger }), { logger: s, chunkLoggerController: r } = A$1({ opts: i2, maxSizeInBytes: e == null ? void 0 : e.maxLogBlobSizeInBytes, loggerOverride: e == null ? void 0 : e.logger });
    this.logChunkController = r, (t = this.logChunkController) != null && t.downloadLogsBlobInBrowser && (window.downloadLogsBlobInBrowser = async () => {
      var o2, a3;
      (o2 = this.logChunkController) != null && o2.downloadLogsBlobInBrowser && ((a3 = this.logChunkController) == null || a3.downloadLogsBlobInBrowser({ clientId: await this.crypto.getClientId() }));
    }), this.logger = E$2(s, this.name), this.heartbeat = new cjs$4.HeartBeat(), this.crypto = new At$1(this, this.logger, e == null ? void 0 : e.keychain), this.history = new jt$1(this, this.logger), this.expirer = new Gt$1(this, this.logger), this.storage = e != null && e.storage ? e.storage : new h$2(Wt$2(Wt$2({}, tt$1), e == null ? void 0 : e.storageOptions)), this.relayer = new kt$1({ core: this, logger: this.logger, relayUrl: this.relayUrl, projectId: this.projectId }), this.pairing = new qt$1(this, this.logger), this.verify = new Yt$2(this.projectId || "", this.logger), this.echoClient = new Ht$2(this.projectId || "", this.logger);
  }
  static async init(e) {
    const t = new ie(e);
    await t.initialize();
    const i2 = await t.crypto.getClientId();
    return await t.storage.setItem(bt$1, i2), t;
  }
  get context() {
    return y$3(this.logger);
  }
  async start() {
    this.initialized || await this.initialize();
  }
  async getLogsBlob() {
    var e;
    return (e = this.logChunkController) == null ? void 0 : e.logsToBlob({ clientId: await this.crypto.getClientId() });
  }
  async initialize() {
    this.logger.trace("Initialized");
    try {
      await this.crypto.init(), await this.history.init(), await this.expirer.init(), await this.relayer.init(), await this.heartbeat.init(), await this.pairing.init(), this.initialized = true, this.logger.info("Core Initialization Success");
    } catch (e) {
      throw this.logger.warn(`Core Initialization Failure at epoch ${Date.now()}`, e), this.logger.error(e.message), e;
    }
  }
};
const Br$1 = ie$3;
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
      return function(message, outputBits, n2, s) {
        return methods["cshake" + bits2].update(message, outputBits, n2, s)[outputType]();
      };
    };
    var createKmacOutputMethod = function(bits2, padding, outputType) {
      return function(key2, message, outputBits, s) {
        return methods["kmac" + bits2].update(key2, message, outputBits, s)[outputType]();
      };
    };
    var createOutputMethods = function(method, createMethod2, bits2, padding) {
      for (var i3 = 0; i3 < OUTPUT_TYPES.length; ++i3) {
        var type = OUTPUT_TYPES[i3];
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
      var w3 = CSHAKE_BYTEPAD[bits2];
      var method = createCshakeOutputMethod(bits2, padding, "hex");
      method.create = function(outputBits, n2, s) {
        if (!n2 && !s) {
          return methods["shake" + bits2].create(outputBits);
        } else {
          return new Keccak(bits2, padding, outputBits).bytepad([n2, s], w3);
        }
      };
      method.update = function(message, outputBits, n2, s) {
        return method.create(outputBits, n2, s).update(message);
      };
      return createOutputMethods(method, createCshakeOutputMethod, bits2, padding);
    };
    var createKmacMethod = function(bits2, padding) {
      var w3 = CSHAKE_BYTEPAD[bits2];
      var method = createKmacOutputMethod(bits2, padding, "hex");
      method.create = function(key2, outputBits, s) {
        return new Kmac(bits2, padding, outputBits).bytepad(["KMAC", s], w3).bytepad([key2], w3);
      };
      method.update = function(key2, message, outputBits, s) {
        return method.create(key2, outputBits, s).update(message);
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
    for (var i2 = 0; i2 < algorithms.length; ++i2) {
      var algorithm = algorithms[i2];
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
      for (var i3 = 0; i3 < 50; ++i3) {
        this.s[i3] = 0;
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
      var blocks = this.blocks, byteCount = this.byteCount, length = message.length, blockCount = this.blockCount, index = 0, s = this.s, i3, code;
      while (index < length) {
        if (this.reset) {
          this.reset = false;
          blocks[0] = this.block;
          for (i3 = 1; i3 < blockCount + 1; ++i3) {
            blocks[i3] = 0;
          }
        }
        if (notString) {
          for (i3 = this.start; index < length && i3 < byteCount; ++index) {
            blocks[i3 >> 2] |= message[index] << SHIFT[i3++ & 3];
          }
        } else {
          for (i3 = this.start; index < length && i3 < byteCount; ++index) {
            code = message.charCodeAt(index);
            if (code < 128) {
              blocks[i3 >> 2] |= code << SHIFT[i3++ & 3];
            } else if (code < 2048) {
              blocks[i3 >> 2] |= (192 | code >> 6) << SHIFT[i3++ & 3];
              blocks[i3 >> 2] |= (128 | code & 63) << SHIFT[i3++ & 3];
            } else if (code < 55296 || code >= 57344) {
              blocks[i3 >> 2] |= (224 | code >> 12) << SHIFT[i3++ & 3];
              blocks[i3 >> 2] |= (128 | code >> 6 & 63) << SHIFT[i3++ & 3];
              blocks[i3 >> 2] |= (128 | code & 63) << SHIFT[i3++ & 3];
            } else {
              code = 65536 + ((code & 1023) << 10 | message.charCodeAt(++index) & 1023);
              blocks[i3 >> 2] |= (240 | code >> 18) << SHIFT[i3++ & 3];
              blocks[i3 >> 2] |= (128 | code >> 12 & 63) << SHIFT[i3++ & 3];
              blocks[i3 >> 2] |= (128 | code >> 6 & 63) << SHIFT[i3++ & 3];
              blocks[i3 >> 2] |= (128 | code & 63) << SHIFT[i3++ & 3];
            }
          }
        }
        this.lastByteIndex = i3;
        if (i3 >= byteCount) {
          this.start = i3 - byteCount;
          this.block = blocks[blockCount];
          for (i3 = 0; i3 < blockCount; ++i3) {
            s[i3] ^= blocks[i3];
          }
          f3(s);
          this.reset = true;
        } else {
          this.start = i3;
        }
      }
      return this;
    };
    Keccak.prototype.encode = function(x2, right) {
      var o2 = x2 & 255, n2 = 1;
      var bytes = [o2];
      x2 = x2 >> 8;
      o2 = x2 & 255;
      while (o2 > 0) {
        bytes.unshift(o2);
        x2 = x2 >> 8;
        o2 = x2 & 255;
        ++n2;
      }
      if (right) {
        bytes.push(n2);
      } else {
        bytes.unshift(n2);
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
        for (var i3 = 0; i3 < str.length; ++i3) {
          var code = str.charCodeAt(i3);
          if (code < 128) {
            bytes += 1;
          } else if (code < 2048) {
            bytes += 2;
          } else if (code < 55296 || code >= 57344) {
            bytes += 3;
          } else {
            code = 65536 + ((code & 1023) << 10 | str.charCodeAt(++i3) & 1023);
            bytes += 4;
          }
        }
      }
      bytes += this.encode(bytes * 8);
      this.update(str);
      return bytes;
    };
    Keccak.prototype.bytepad = function(strs, w3) {
      var bytes = this.encode(w3);
      for (var i3 = 0; i3 < strs.length; ++i3) {
        bytes += this.encodeString(strs[i3]);
      }
      var paddingBytes = w3 - bytes % w3;
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
      var blocks = this.blocks, i3 = this.lastByteIndex, blockCount = this.blockCount, s = this.s;
      blocks[i3 >> 2] |= this.padding[i3 & 3];
      if (this.lastByteIndex === this.byteCount) {
        blocks[0] = blocks[blockCount];
        for (i3 = 1; i3 < blockCount + 1; ++i3) {
          blocks[i3] = 0;
        }
      }
      blocks[blockCount - 1] |= 2147483648;
      for (i3 = 0; i3 < blockCount; ++i3) {
        s[i3] ^= blocks[i3];
      }
      f3(s);
    };
    Keccak.prototype.toString = Keccak.prototype.hex = function() {
      this.finalize();
      var blockCount = this.blockCount, s = this.s, outputBlocks = this.outputBlocks, extraBytes = this.extraBytes, i3 = 0, j3 = 0;
      var hex = "", block;
      while (j3 < outputBlocks) {
        for (i3 = 0; i3 < blockCount && j3 < outputBlocks; ++i3, ++j3) {
          block = s[i3];
          hex += HEX_CHARS[block >> 4 & 15] + HEX_CHARS[block & 15] + HEX_CHARS[block >> 12 & 15] + HEX_CHARS[block >> 8 & 15] + HEX_CHARS[block >> 20 & 15] + HEX_CHARS[block >> 16 & 15] + HEX_CHARS[block >> 28 & 15] + HEX_CHARS[block >> 24 & 15];
        }
        if (j3 % blockCount === 0) {
          f3(s);
          i3 = 0;
        }
      }
      if (extraBytes) {
        block = s[i3];
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
      var blockCount = this.blockCount, s = this.s, outputBlocks = this.outputBlocks, extraBytes = this.extraBytes, i3 = 0, j3 = 0;
      var bytes = this.outputBits >> 3;
      var buffer;
      if (extraBytes) {
        buffer = new ArrayBuffer(outputBlocks + 1 << 2);
      } else {
        buffer = new ArrayBuffer(bytes);
      }
      var array = new Uint32Array(buffer);
      while (j3 < outputBlocks) {
        for (i3 = 0; i3 < blockCount && j3 < outputBlocks; ++i3, ++j3) {
          array[j3] = s[i3];
        }
        if (j3 % blockCount === 0) {
          f3(s);
        }
      }
      if (extraBytes) {
        array[i3] = s[i3];
        buffer = buffer.slice(0, bytes);
      }
      return buffer;
    };
    Keccak.prototype.buffer = Keccak.prototype.arrayBuffer;
    Keccak.prototype.digest = Keccak.prototype.array = function() {
      this.finalize();
      var blockCount = this.blockCount, s = this.s, outputBlocks = this.outputBlocks, extraBytes = this.extraBytes, i3 = 0, j3 = 0;
      var array = [], offset, block;
      while (j3 < outputBlocks) {
        for (i3 = 0; i3 < blockCount && j3 < outputBlocks; ++i3, ++j3) {
          offset = j3 << 2;
          block = s[i3];
          array[offset] = block & 255;
          array[offset + 1] = block >> 8 & 255;
          array[offset + 2] = block >> 16 & 255;
          array[offset + 3] = block >> 24 & 255;
        }
        if (j3 % blockCount === 0) {
          f3(s);
        }
      }
      if (extraBytes) {
        offset = j3 << 2;
        block = s[i3];
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
    var f3 = function(s) {
      var h4, l2, n2, c02, c1, c2, c3, c4, c5, c6, c7, c8, c9, b02, b1, b22, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b13, b14, b15, b16, b17, b18, b19, b20, b21, b222, b23, b24, b25, b26, b27, b28, b29, b30, b31, b32, b33, b34, b35, b36, b37, b38, b39, b40, b41, b42, b43, b44, b45, b46, b47, b48, b49;
      for (n2 = 0; n2 < 48; n2 += 2) {
        c02 = s[0] ^ s[10] ^ s[20] ^ s[30] ^ s[40];
        c1 = s[1] ^ s[11] ^ s[21] ^ s[31] ^ s[41];
        c2 = s[2] ^ s[12] ^ s[22] ^ s[32] ^ s[42];
        c3 = s[3] ^ s[13] ^ s[23] ^ s[33] ^ s[43];
        c4 = s[4] ^ s[14] ^ s[24] ^ s[34] ^ s[44];
        c5 = s[5] ^ s[15] ^ s[25] ^ s[35] ^ s[45];
        c6 = s[6] ^ s[16] ^ s[26] ^ s[36] ^ s[46];
        c7 = s[7] ^ s[17] ^ s[27] ^ s[37] ^ s[47];
        c8 = s[8] ^ s[18] ^ s[28] ^ s[38] ^ s[48];
        c9 = s[9] ^ s[19] ^ s[29] ^ s[39] ^ s[49];
        h4 = c8 ^ (c2 << 1 | c3 >>> 31);
        l2 = c9 ^ (c3 << 1 | c2 >>> 31);
        s[0] ^= h4;
        s[1] ^= l2;
        s[10] ^= h4;
        s[11] ^= l2;
        s[20] ^= h4;
        s[21] ^= l2;
        s[30] ^= h4;
        s[31] ^= l2;
        s[40] ^= h4;
        s[41] ^= l2;
        h4 = c02 ^ (c4 << 1 | c5 >>> 31);
        l2 = c1 ^ (c5 << 1 | c4 >>> 31);
        s[2] ^= h4;
        s[3] ^= l2;
        s[12] ^= h4;
        s[13] ^= l2;
        s[22] ^= h4;
        s[23] ^= l2;
        s[32] ^= h4;
        s[33] ^= l2;
        s[42] ^= h4;
        s[43] ^= l2;
        h4 = c2 ^ (c6 << 1 | c7 >>> 31);
        l2 = c3 ^ (c7 << 1 | c6 >>> 31);
        s[4] ^= h4;
        s[5] ^= l2;
        s[14] ^= h4;
        s[15] ^= l2;
        s[24] ^= h4;
        s[25] ^= l2;
        s[34] ^= h4;
        s[35] ^= l2;
        s[44] ^= h4;
        s[45] ^= l2;
        h4 = c4 ^ (c8 << 1 | c9 >>> 31);
        l2 = c5 ^ (c9 << 1 | c8 >>> 31);
        s[6] ^= h4;
        s[7] ^= l2;
        s[16] ^= h4;
        s[17] ^= l2;
        s[26] ^= h4;
        s[27] ^= l2;
        s[36] ^= h4;
        s[37] ^= l2;
        s[46] ^= h4;
        s[47] ^= l2;
        h4 = c6 ^ (c02 << 1 | c1 >>> 31);
        l2 = c7 ^ (c1 << 1 | c02 >>> 31);
        s[8] ^= h4;
        s[9] ^= l2;
        s[18] ^= h4;
        s[19] ^= l2;
        s[28] ^= h4;
        s[29] ^= l2;
        s[38] ^= h4;
        s[39] ^= l2;
        s[48] ^= h4;
        s[49] ^= l2;
        b02 = s[0];
        b1 = s[1];
        b32 = s[11] << 4 | s[10] >>> 28;
        b33 = s[10] << 4 | s[11] >>> 28;
        b14 = s[20] << 3 | s[21] >>> 29;
        b15 = s[21] << 3 | s[20] >>> 29;
        b46 = s[31] << 9 | s[30] >>> 23;
        b47 = s[30] << 9 | s[31] >>> 23;
        b28 = s[40] << 18 | s[41] >>> 14;
        b29 = s[41] << 18 | s[40] >>> 14;
        b20 = s[2] << 1 | s[3] >>> 31;
        b21 = s[3] << 1 | s[2] >>> 31;
        b22 = s[13] << 12 | s[12] >>> 20;
        b3 = s[12] << 12 | s[13] >>> 20;
        b34 = s[22] << 10 | s[23] >>> 22;
        b35 = s[23] << 10 | s[22] >>> 22;
        b16 = s[33] << 13 | s[32] >>> 19;
        b17 = s[32] << 13 | s[33] >>> 19;
        b48 = s[42] << 2 | s[43] >>> 30;
        b49 = s[43] << 2 | s[42] >>> 30;
        b40 = s[5] << 30 | s[4] >>> 2;
        b41 = s[4] << 30 | s[5] >>> 2;
        b222 = s[14] << 6 | s[15] >>> 26;
        b23 = s[15] << 6 | s[14] >>> 26;
        b4 = s[25] << 11 | s[24] >>> 21;
        b5 = s[24] << 11 | s[25] >>> 21;
        b36 = s[34] << 15 | s[35] >>> 17;
        b37 = s[35] << 15 | s[34] >>> 17;
        b18 = s[45] << 29 | s[44] >>> 3;
        b19 = s[44] << 29 | s[45] >>> 3;
        b10 = s[6] << 28 | s[7] >>> 4;
        b11 = s[7] << 28 | s[6] >>> 4;
        b42 = s[17] << 23 | s[16] >>> 9;
        b43 = s[16] << 23 | s[17] >>> 9;
        b24 = s[26] << 25 | s[27] >>> 7;
        b25 = s[27] << 25 | s[26] >>> 7;
        b6 = s[36] << 21 | s[37] >>> 11;
        b7 = s[37] << 21 | s[36] >>> 11;
        b38 = s[47] << 24 | s[46] >>> 8;
        b39 = s[46] << 24 | s[47] >>> 8;
        b30 = s[8] << 27 | s[9] >>> 5;
        b31 = s[9] << 27 | s[8] >>> 5;
        b12 = s[18] << 20 | s[19] >>> 12;
        b13 = s[19] << 20 | s[18] >>> 12;
        b44 = s[29] << 7 | s[28] >>> 25;
        b45 = s[28] << 7 | s[29] >>> 25;
        b26 = s[38] << 8 | s[39] >>> 24;
        b27 = s[39] << 8 | s[38] >>> 24;
        b8 = s[48] << 14 | s[49] >>> 18;
        b9 = s[49] << 14 | s[48] >>> 18;
        s[0] = b02 ^ ~b22 & b4;
        s[1] = b1 ^ ~b3 & b5;
        s[10] = b10 ^ ~b12 & b14;
        s[11] = b11 ^ ~b13 & b15;
        s[20] = b20 ^ ~b222 & b24;
        s[21] = b21 ^ ~b23 & b25;
        s[30] = b30 ^ ~b32 & b34;
        s[31] = b31 ^ ~b33 & b35;
        s[40] = b40 ^ ~b42 & b44;
        s[41] = b41 ^ ~b43 & b45;
        s[2] = b22 ^ ~b4 & b6;
        s[3] = b3 ^ ~b5 & b7;
        s[12] = b12 ^ ~b14 & b16;
        s[13] = b13 ^ ~b15 & b17;
        s[22] = b222 ^ ~b24 & b26;
        s[23] = b23 ^ ~b25 & b27;
        s[32] = b32 ^ ~b34 & b36;
        s[33] = b33 ^ ~b35 & b37;
        s[42] = b42 ^ ~b44 & b46;
        s[43] = b43 ^ ~b45 & b47;
        s[4] = b4 ^ ~b6 & b8;
        s[5] = b5 ^ ~b7 & b9;
        s[14] = b14 ^ ~b16 & b18;
        s[15] = b15 ^ ~b17 & b19;
        s[24] = b24 ^ ~b26 & b28;
        s[25] = b25 ^ ~b27 & b29;
        s[34] = b34 ^ ~b36 & b38;
        s[35] = b35 ^ ~b37 & b39;
        s[44] = b44 ^ ~b46 & b48;
        s[45] = b45 ^ ~b47 & b49;
        s[6] = b6 ^ ~b8 & b02;
        s[7] = b7 ^ ~b9 & b1;
        s[16] = b16 ^ ~b18 & b10;
        s[17] = b17 ^ ~b19 & b11;
        s[26] = b26 ^ ~b28 & b20;
        s[27] = b27 ^ ~b29 & b21;
        s[36] = b36 ^ ~b38 & b30;
        s[37] = b37 ^ ~b39 & b31;
        s[46] = b46 ^ ~b48 & b40;
        s[47] = b47 ^ ~b49 & b41;
        s[8] = b8 ^ ~b02 & b22;
        s[9] = b9 ^ ~b1 & b3;
        s[18] = b18 ^ ~b10 & b12;
        s[19] = b19 ^ ~b11 & b13;
        s[28] = b28 ^ ~b20 & b222;
        s[29] = b29 ^ ~b21 & b23;
        s[38] = b38 ^ ~b30 & b32;
        s[39] = b39 ^ ~b31 & b33;
        s[48] = b48 ^ ~b40 & b42;
        s[49] = b49 ^ ~b41 & b43;
        s[0] ^= RC[n2];
        s[1] ^= RC[n2 + 1];
      }
    };
    if (COMMON_JS) {
      module.exports = methods;
    } else {
      for (i2 = 0; i2 < methodNames.length; ++i2) {
        root[methodNames[i2]] = methods[methodNames[i2]];
      }
    }
  })();
})(sha3$1);
var sha3Exports = sha3$1.exports;
const sha3 = /* @__PURE__ */ getDefaultExportFromCjs(sha3Exports);
const version$4 = "logger/5.7.0";
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
          for (let i2 = 0; i2 < value.length; i2++) {
            hex += HEX[value[i2] >> 4];
            hex += HEX[value[i2] & 15];
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
  throwArgumentError(message, name, value) {
    return this.throwError(message, Logger.errors.INVALID_ARGUMENT, {
      argument: name,
      value
    });
  }
  assert(condition, message, code, params) {
    if (!!condition) {
      return;
    }
    this.throwError(message, code, params);
  }
  assertArgument(condition, message, name, value) {
    if (!!condition) {
      return;
    }
    this.throwArgumentError(message, name, value);
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
      _globalLogger = new Logger(version$4);
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
const version$3 = "bytes/5.7.0";
const logger$3 = new Logger(version$3);
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
  for (let i2 = 0; i2 < value.length; i2++) {
    const v3 = value[i2];
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
    for (let i2 = 0; i2 < hex.length; i2 += 2) {
      result.push(parseInt(hex.substring(i2, i2 + 2), 16));
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
    for (let i2 = 0; i2 < value.length; i2++) {
      let v3 = value[i2];
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
  if (endOffset != null) {
    return "0x" + data.substring(offset, 2 + 2 * endOffset);
  }
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
      const s = hexlify(vs3);
      if (result.s == null) {
        result.s = s;
      } else if (result.s !== s) {
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
var BN = BN$1.BN;
function _base36To16(value) {
  return new BN(value, 36).toString(16);
}
const version$2 = "strings/5.7.0";
const logger$2 = new Logger(version$2);
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
  for (let i2 = 0; i2 < str.length; i2++) {
    const c2 = str.charCodeAt(i2);
    if (c2 < 128) {
      result.push(c2);
    } else if (c2 < 2048) {
      result.push(c2 >> 6 | 192);
      result.push(c2 & 63 | 128);
    } else if ((c2 & 64512) == 55296) {
      i2++;
      const c22 = str.charCodeAt(i2);
      if (i2 >= str.length || (c22 & 64512) !== 56320) {
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
const version$1 = "address/5.7.0";
const logger$1 = new Logger(version$1);
function getChecksumAddress(address) {
  if (!isHexString(address, 20)) {
    logger$1.throwArgumentError("invalid address", "address", address);
  }
  address = address.toLowerCase();
  const chars = address.substring(2).split("");
  const expanded = new Uint8Array(40);
  for (let i2 = 0; i2 < 40; i2++) {
    expanded[i2] = chars[i2].charCodeAt(0);
  }
  const hashed = arrayify(keccak256(expanded));
  for (let i2 = 0; i2 < 40; i2 += 2) {
    if (hashed[i2 >> 1] >> 4 >= 8) {
      chars[i2] = chars[i2].toUpperCase();
    }
    if ((hashed[i2 >> 1] & 15) >= 8) {
      chars[i2 + 1] = chars[i2 + 1].toUpperCase();
    }
  }
  return "0x" + chars.join("");
}
const MAX_SAFE_INTEGER = 9007199254740991;
function log10(x2) {
  if (Math.log10) {
    return Math.log10(x2);
  }
  return Math.log(x2) / Math.LN10;
}
const ibanLookup = {};
for (let i2 = 0; i2 < 10; i2++) {
  ibanLookup[String(i2)] = String(i2);
}
for (let i2 = 0; i2 < 26; i2++) {
  ibanLookup[String.fromCharCode(65 + i2)] = String(10 + i2);
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
      } catch (e) {
        reject(e);
      }
    }
    function rejected(value) {
      try {
        step(generator["throw"](value));
      } catch (e) {
        reject(e);
      }
    }
    function step(result) {
      result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected);
    }
    step((generator = generator.apply(thisArg, _arguments || [])).next());
  });
});
function defineReadOnly(object, name, value) {
  Object.defineProperty(object, name, {
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
var minimalisticAssert = assert;
function assert(val, msg) {
  if (!val)
    throw new Error(msg || "Assertion failed");
}
assert.equal = function assertEqual(l2, r, msg) {
  if (l2 != r)
    throw new Error(msg || "Assertion failed: " + l2 + " != " + r);
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
      for (var i2 = 0; i2 < msg.length; i2++)
        res[i2] = msg[i2] | 0;
      return res;
    }
    if (enc === "hex") {
      msg = msg.replace(/[^a-z0-9]+/ig, "");
      if (msg.length % 2 !== 0)
        msg = "0" + msg;
      for (var i2 = 0; i2 < msg.length; i2 += 2)
        res.push(parseInt(msg[i2] + msg[i2 + 1], 16));
    } else {
      for (var i2 = 0; i2 < msg.length; i2++) {
        var c2 = msg.charCodeAt(i2);
        var hi = c2 >> 8;
        var lo2 = c2 & 255;
        if (hi)
          res.push(hi, lo2);
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
  function toHex(msg) {
    var res = "";
    for (var i2 = 0; i2 < msg.length; i2++)
      res += zero2(msg[i2].toString(16));
    return res;
  }
  utils2.toHex = toHex;
  utils2.encode = function encode3(arr, enc) {
    if (enc === "hex")
      return toHex(arr);
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
  function getNAF2(num, w3, bits) {
    var naf = new Array(Math.max(num.bitLength(), bits) + 1);
    naf.fill(0);
    var ws2 = 1 << w3 + 1;
    var k2 = num.clone();
    for (var i2 = 0; i2 < naf.length; i2++) {
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
      naf[i2] = z2;
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
  function cachedProperty(obj, name, computer) {
    var key2 = "_" + name;
    obj.prototype[name] = function cachedProperty2() {
      return this[key2] !== void 0 ? this[key2] : this[key2] = computer.call(this);
    };
  }
  utils2.cachedProperty = cachedProperty;
  function parseBytes(bytes) {
    return typeof bytes === "string" ? utils2.toArray(bytes, "hex") : bytes;
  }
  utils2.parseBytes = parseBytes;
  function intFromLE(bytes) {
    return new BN$1(bytes, "hex", "le");
  }
  utils2.intFromLE = intFromLE;
});
var getNAF = utils_1$1.getNAF;
var getJSF = utils_1$1.getJSF;
var assert$1 = utils_1$1.assert;
function BaseCurve(type, conf) {
  this.type = type;
  this.p = new BN$1(conf.p, 16);
  this.red = conf.prime ? BN$1.red(conf.prime) : BN$1.mont(this.p);
  this.zero = new BN$1(0).toRed(this.red);
  this.one = new BN$1(1).toRed(this.red);
  this.two = new BN$1(2).toRed(this.red);
  this.n = conf.n && new BN$1(conf.n, 16);
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
BaseCurve.prototype.point = function point() {
  throw new Error("Not implemented");
};
BaseCurve.prototype.validate = function validate() {
  throw new Error("Not implemented");
};
BaseCurve.prototype._fixedNafMul = function _fixedNafMul(p3, k2) {
  assert$1(p3.precomputed);
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
  var b3 = this.jpoint(null, null, null);
  for (var i2 = I2; i2 > 0; i2--) {
    for (j2 = 0; j2 < repr.length; j2++) {
      nafW = repr[j2];
      if (nafW === i2)
        b3 = b3.mixedAdd(doubles.points[j2]);
      else if (nafW === -i2)
        b3 = b3.mixedAdd(doubles.points[j2].neg());
    }
    a3 = a3.add(b3);
  }
  return a3.toP();
};
BaseCurve.prototype._wnafMul = function _wnafMul(p3, k2) {
  var w3 = 4;
  var nafPoints = p3._getNAFPoints(w3);
  w3 = nafPoints.wnd;
  var wnd = nafPoints.points;
  var naf = getNAF(k2, w3, this._bitLength);
  var acc = this.jpoint(null, null, null);
  for (var i2 = naf.length - 1; i2 >= 0; i2--) {
    for (var l2 = 0; i2 >= 0 && naf[i2] === 0; i2--)
      l2++;
    if (i2 >= 0)
      l2++;
    acc = acc.dblp(l2);
    if (i2 < 0)
      break;
    var z2 = naf[i2];
    assert$1(z2 !== 0);
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
BaseCurve.prototype._wnafMulAdd = function _wnafMulAdd(defW, points, coeffs, len, jacobianResult) {
  var wndWidth = this._wnafT1;
  var wnd = this._wnafT2;
  var naf = this._wnafT3;
  var max = 0;
  var i2;
  var j2;
  var p3;
  for (i2 = 0; i2 < len; i2++) {
    p3 = points[i2];
    var nafPoints = p3._getNAFPoints(defW);
    wndWidth[i2] = nafPoints.wnd;
    wnd[i2] = nafPoints.points;
  }
  for (i2 = len - 1; i2 >= 1; i2 -= 2) {
    var a3 = i2 - 1;
    var b3 = i2;
    if (wndWidth[a3] !== 1 || wndWidth[b3] !== 1) {
      naf[a3] = getNAF(coeffs[a3], wndWidth[a3], this._bitLength);
      naf[b3] = getNAF(coeffs[b3], wndWidth[b3], this._bitLength);
      max = Math.max(naf[a3].length, max);
      max = Math.max(naf[b3].length, max);
      continue;
    }
    var comb = [
      points[a3],
      /* 1 */
      null,
      /* 3 */
      null,
      /* 5 */
      points[b3]
      /* 7 */
    ];
    if (points[a3].y.cmp(points[b3].y) === 0) {
      comb[1] = points[a3].add(points[b3]);
      comb[2] = points[a3].toJ().mixedAdd(points[b3].neg());
    } else if (points[a3].y.cmp(points[b3].y.redNeg()) === 0) {
      comb[1] = points[a3].toJ().mixedAdd(points[b3]);
      comb[2] = points[a3].add(points[b3].neg());
    } else {
      comb[1] = points[a3].toJ().mixedAdd(points[b3]);
      comb[2] = points[a3].toJ().mixedAdd(points[b3].neg());
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
    var jsf = getJSF(coeffs[a3], coeffs[b3]);
    max = Math.max(jsf[0].length, max);
    naf[a3] = new Array(max);
    naf[b3] = new Array(max);
    for (j2 = 0; j2 < max; j2++) {
      var ja2 = jsf[0][j2] | 0;
      var jb = jsf[1][j2] | 0;
      naf[a3][j2] = index[(ja2 + 1) * 3 + (jb + 1)];
      naf[b3][j2] = 0;
      wnd[a3] = comb;
    }
  }
  var acc = this.jpoint(null, null, null);
  var tmp = this._wnafT4;
  for (i2 = max; i2 >= 0; i2--) {
    var k2 = 0;
    while (i2 >= 0) {
      var zero = true;
      for (j2 = 0; j2 < len; j2++) {
        tmp[j2] = naf[j2][i2] | 0;
        if (tmp[j2] !== 0)
          zero = false;
      }
      if (!zero)
        break;
      k2++;
      i2--;
    }
    if (i2 >= 0)
      k2++;
    acc = acc.dblp(k2);
    if (i2 < 0)
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
  for (i2 = 0; i2 < len; i2++)
    wnd[i2] = null;
  if (jacobianResult)
    return acc;
  else
    return acc.toP();
};
function BasePoint(curve, type) {
  this.curve = curve;
  this.type = type;
  this.precomputed = null;
}
BaseCurve.BasePoint = BasePoint;
BasePoint.prototype.eq = function eq() {
  throw new Error("Not implemented");
};
BasePoint.prototype.validate = function validate2() {
  return this.curve.validate(this);
};
BaseCurve.prototype.decodePoint = function decodePoint(bytes, enc) {
  bytes = utils_1$1.toArray(bytes, enc);
  var len = this.p.byteLength();
  if ((bytes[0] === 4 || bytes[0] === 6 || bytes[0] === 7) && bytes.length - 1 === 2 * len) {
    if (bytes[0] === 6)
      assert$1(bytes[bytes.length - 1] % 2 === 0);
    else if (bytes[0] === 7)
      assert$1(bytes[bytes.length - 1] % 2 === 1);
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
BasePoint.prototype.encodeCompressed = function encodeCompressed(enc) {
  return this.encode(enc, true);
};
BasePoint.prototype._encode = function _encode(compact) {
  var len = this.curve.p.byteLength();
  var x2 = this.getX().toArray("be", len);
  if (compact)
    return [this.getY().isEven() ? 2 : 3].concat(x2);
  return [4].concat(x2, this.getY().toArray("be", len));
};
BasePoint.prototype.encode = function encode2(enc, compact) {
  return utils_1$1.encode(this._encode(compact), enc);
};
BasePoint.prototype.precompute = function precompute(power) {
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
BasePoint.prototype._hasDoubles = function _hasDoubles(k2) {
  if (!this.precomputed)
    return false;
  var doubles = this.precomputed.doubles;
  if (!doubles)
    return false;
  return doubles.points.length >= Math.ceil((k2.bitLength() + 1) / doubles.step);
};
BasePoint.prototype._getDoubles = function _getDoubles(step, power) {
  if (this.precomputed && this.precomputed.doubles)
    return this.precomputed.doubles;
  var doubles = [this];
  var acc = this;
  for (var i2 = 0; i2 < power; i2 += step) {
    for (var j2 = 0; j2 < step; j2++)
      acc = acc.dbl();
    doubles.push(acc);
  }
  return {
    step,
    points: doubles
  };
};
BasePoint.prototype._getNAFPoints = function _getNAFPoints(wnd) {
  if (this.precomputed && this.precomputed.naf)
    return this.precomputed.naf;
  var res = [this];
  var max = (1 << wnd) - 1;
  var dbl3 = max === 1 ? null : this.dbl();
  for (var i2 = 1; i2 < max; i2++)
    res[i2] = res[i2 - 1].add(dbl3);
  return {
    wnd,
    points: res
  };
};
BasePoint.prototype._getBeta = function _getBeta() {
  return null;
};
BasePoint.prototype.dblp = function dblp(k2) {
  var r = this;
  for (var i2 = 0; i2 < k2; i2++)
    r = r.dbl();
  return r;
};
var inherits_browser = createCommonjsModule(function(module) {
  if (typeof Object.create === "function") {
    module.exports = function inherits(ctor, superCtor) {
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
    module.exports = function inherits(ctor, superCtor) {
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
var assert$2 = utils_1$1.assert;
function ShortCurve(conf) {
  base.call(this, "short", conf);
  this.a = new BN$1(conf.a, 16).toRed(this.red);
  this.b = new BN$1(conf.b, 16).toRed(this.red);
  this.tinv = this.two.redInvm();
  this.zeroA = this.a.fromRed().cmpn(0) === 0;
  this.threeA = this.a.fromRed().sub(this.p).cmpn(-3) === 0;
  this.endo = this._getEndomorphism(conf);
  this._endoWnafT1 = new Array(4);
  this._endoWnafT2 = new Array(4);
}
inherits_browser(ShortCurve, base);
var short_1 = ShortCurve;
ShortCurve.prototype._getEndomorphism = function _getEndomorphism(conf) {
  if (!this.zeroA || !this.g || !this.n || this.p.modn(3) !== 1)
    return;
  var beta;
  var lambda;
  if (conf.beta) {
    beta = new BN$1(conf.beta, 16).toRed(this.red);
  } else {
    var betas = this._getEndoRoots(this.p);
    beta = betas[0].cmp(betas[1]) < 0 ? betas[0] : betas[1];
    beta = beta.toRed(this.red);
  }
  if (conf.lambda) {
    lambda = new BN$1(conf.lambda, 16);
  } else {
    var lambdas = this._getEndoRoots(this.n);
    if (this.g.mul(lambdas[0]).x.cmp(this.g.x.redMul(beta)) === 0) {
      lambda = lambdas[0];
    } else {
      lambda = lambdas[1];
      assert$2(this.g.mul(lambda).x.cmp(this.g.x.redMul(beta)) === 0);
    }
  }
  var basis;
  if (conf.basis) {
    basis = conf.basis.map(function(vec) {
      return {
        a: new BN$1(vec.a, 16),
        b: new BN$1(vec.b, 16)
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
ShortCurve.prototype._getEndoRoots = function _getEndoRoots(num) {
  var red = num === this.p ? this.red : BN$1.mont(num);
  var tinv = new BN$1(2).toRed(red).redInvm();
  var ntinv = tinv.redNeg();
  var s = new BN$1(3).toRed(red).redNeg().redSqrt().redMul(tinv);
  var l1 = ntinv.redAdd(s).fromRed();
  var l2 = ntinv.redSub(s).fromRed();
  return [l1, l2];
};
ShortCurve.prototype._getEndoBasis = function _getEndoBasis(lambda) {
  var aprxSqrt = this.n.ushrn(Math.floor(this.n.bitLength() / 2));
  var u2 = lambda;
  var v3 = this.n.clone();
  var x1 = new BN$1(1);
  var y1 = new BN$1(0);
  var x2 = new BN$1(0);
  var y22 = new BN$1(1);
  var a02;
  var b02;
  var a1;
  var b1;
  var a22;
  var b22;
  var prevR;
  var i2 = 0;
  var r;
  var x3;
  while (u2.cmpn(0) !== 0) {
    var q2 = v3.div(u2);
    r = v3.sub(q2.mul(u2));
    x3 = x2.sub(q2.mul(x1));
    var y3 = y22.sub(q2.mul(y1));
    if (!a1 && r.cmp(aprxSqrt) < 0) {
      a02 = prevR.neg();
      b02 = x1;
      a1 = r.neg();
      b1 = x3;
    } else if (a1 && ++i2 === 2) {
      break;
    }
    prevR = r;
    v3 = u2;
    u2 = r;
    x2 = x1;
    x1 = x3;
    y22 = y1;
    y1 = y3;
  }
  a22 = r.neg();
  b22 = x3;
  var len1 = a1.sqr().add(b1.sqr());
  var len2 = a22.sqr().add(b22.sqr());
  if (len2.cmp(len1) >= 0) {
    a22 = a02;
    b22 = b02;
  }
  if (a1.negative) {
    a1 = a1.neg();
    b1 = b1.neg();
  }
  if (a22.negative) {
    a22 = a22.neg();
    b22 = b22.neg();
  }
  return [
    { a: a1, b: b1 },
    { a: a22, b: b22 }
  ];
};
ShortCurve.prototype._endoSplit = function _endoSplit(k2) {
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
ShortCurve.prototype.pointFromX = function pointFromX(x2, odd) {
  x2 = new BN$1(x2, 16);
  if (!x2.red)
    x2 = x2.toRed(this.red);
  var y22 = x2.redSqr().redMul(x2).redIAdd(x2.redMul(this.a)).redIAdd(this.b);
  var y3 = y22.redSqrt();
  if (y3.redSqr().redSub(y22).cmp(this.zero) !== 0)
    throw new Error("invalid point");
  var isOdd = y3.fromRed().isOdd();
  if (odd && !isOdd || !odd && isOdd)
    y3 = y3.redNeg();
  return this.point(x2, y3);
};
ShortCurve.prototype.validate = function validate3(point3) {
  if (point3.inf)
    return true;
  var x2 = point3.x;
  var y3 = point3.y;
  var ax = this.a.redMul(x2);
  var rhs = x2.redSqr().redMul(x2).redIAdd(ax).redIAdd(this.b);
  return y3.redSqr().redISub(rhs).cmpn(0) === 0;
};
ShortCurve.prototype._endoWnafMulAdd = function _endoWnafMulAdd(points, coeffs, jacobianResult) {
  var npoints = this._endoWnafT1;
  var ncoeffs = this._endoWnafT2;
  for (var i2 = 0; i2 < points.length; i2++) {
    var split = this._endoSplit(coeffs[i2]);
    var p3 = points[i2];
    var beta = p3._getBeta();
    if (split.k1.negative) {
      split.k1.ineg();
      p3 = p3.neg(true);
    }
    if (split.k2.negative) {
      split.k2.ineg();
      beta = beta.neg(true);
    }
    npoints[i2 * 2] = p3;
    npoints[i2 * 2 + 1] = beta;
    ncoeffs[i2 * 2] = split.k1;
    ncoeffs[i2 * 2 + 1] = split.k2;
  }
  var res = this._wnafMulAdd(1, npoints, ncoeffs, i2 * 2, jacobianResult);
  for (var j2 = 0; j2 < i2 * 2; j2++) {
    npoints[j2] = null;
    ncoeffs[j2] = null;
  }
  return res;
};
function Point(curve, x2, y3, isRed) {
  base.BasePoint.call(this, curve, "affine");
  if (x2 === null && y3 === null) {
    this.x = null;
    this.y = null;
    this.inf = true;
  } else {
    this.x = new BN$1(x2, 16);
    this.y = new BN$1(y3, 16);
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
inherits_browser(Point, base.BasePoint);
ShortCurve.prototype.point = function point2(x2, y3, isRed) {
  return new Point(this, x2, y3, isRed);
};
ShortCurve.prototype.pointFromJSON = function pointFromJSON(obj, red) {
  return Point.fromJSON(this, obj, red);
};
Point.prototype._getBeta = function _getBeta2() {
  if (!this.curve.endo)
    return;
  var pre = this.precomputed;
  if (pre && pre.beta)
    return pre.beta;
  var beta = this.curve.point(this.x.redMul(this.curve.endo.beta), this.y);
  if (pre) {
    var curve = this.curve;
    var endoMul = function(p3) {
      return curve.point(p3.x.redMul(curve.endo.beta), p3.y);
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
Point.prototype.toJSON = function toJSON() {
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
Point.fromJSON = function fromJSON(curve, obj, red) {
  if (typeof obj === "string")
    obj = JSON.parse(obj);
  var res = curve.point(obj[0], obj[1], red);
  if (!obj[2])
    return res;
  function obj2point(obj2) {
    return curve.point(obj2[0], obj2[1], red);
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
Point.prototype.inspect = function inspect() {
  if (this.isInfinity())
    return "<EC Point Infinity>";
  return "<EC Point x: " + this.x.fromRed().toString(16, 2) + " y: " + this.y.fromRed().toString(16, 2) + ">";
};
Point.prototype.isInfinity = function isInfinity() {
  return this.inf;
};
Point.prototype.add = function add(p3) {
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
Point.prototype.dbl = function dbl() {
  if (this.inf)
    return this;
  var ys1 = this.y.redAdd(this.y);
  if (ys1.cmpn(0) === 0)
    return this.curve.point(null, null);
  var a3 = this.curve.a;
  var x2 = this.x.redSqr();
  var dyinv = ys1.redInvm();
  var c2 = x2.redAdd(x2).redIAdd(x2).redIAdd(a3).redMul(dyinv);
  var nx = c2.redSqr().redISub(this.x.redAdd(this.x));
  var ny = c2.redMul(this.x.redSub(nx)).redISub(this.y);
  return this.curve.point(nx, ny);
};
Point.prototype.getX = function getX() {
  return this.x.fromRed();
};
Point.prototype.getY = function getY() {
  return this.y.fromRed();
};
Point.prototype.mul = function mul(k2) {
  k2 = new BN$1(k2, 16);
  if (this.isInfinity())
    return this;
  else if (this._hasDoubles(k2))
    return this.curve._fixedNafMul(this, k2);
  else if (this.curve.endo)
    return this.curve._endoWnafMulAdd([this], [k2]);
  else
    return this.curve._wnafMul(this, k2);
};
Point.prototype.mulAdd = function mulAdd(k1, p22, k2) {
  var points = [this, p22];
  var coeffs = [k1, k2];
  if (this.curve.endo)
    return this.curve._endoWnafMulAdd(points, coeffs);
  else
    return this.curve._wnafMulAdd(1, points, coeffs, 2);
};
Point.prototype.jmulAdd = function jmulAdd(k1, p22, k2) {
  var points = [this, p22];
  var coeffs = [k1, k2];
  if (this.curve.endo)
    return this.curve._endoWnafMulAdd(points, coeffs, true);
  else
    return this.curve._wnafMulAdd(1, points, coeffs, 2, true);
};
Point.prototype.eq = function eq2(p3) {
  return this === p3 || this.inf === p3.inf && (this.inf || this.x.cmp(p3.x) === 0 && this.y.cmp(p3.y) === 0);
};
Point.prototype.neg = function neg(_precompute) {
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
Point.prototype.toJ = function toJ() {
  if (this.inf)
    return this.curve.jpoint(null, null, null);
  var res = this.curve.jpoint(this.x, this.y, this.curve.one);
  return res;
};
function JPoint(curve, x2, y3, z2) {
  base.BasePoint.call(this, curve, "jacobian");
  if (x2 === null && y3 === null && z2 === null) {
    this.x = this.curve.one;
    this.y = this.curve.one;
    this.z = new BN$1(0);
  } else {
    this.x = new BN$1(x2, 16);
    this.y = new BN$1(y3, 16);
    this.z = new BN$1(z2, 16);
  }
  if (!this.x.red)
    this.x = this.x.toRed(this.curve.red);
  if (!this.y.red)
    this.y = this.y.toRed(this.curve.red);
  if (!this.z.red)
    this.z = this.z.toRed(this.curve.red);
  this.zOne = this.z === this.curve.one;
}
inherits_browser(JPoint, base.BasePoint);
ShortCurve.prototype.jpoint = function jpoint(x2, y3, z2) {
  return new JPoint(this, x2, y3, z2);
};
JPoint.prototype.toP = function toP() {
  if (this.isInfinity())
    return this.curve.point(null, null);
  var zinv = this.z.redInvm();
  var zinv2 = zinv.redSqr();
  var ax = this.x.redMul(zinv2);
  var ay = this.y.redMul(zinv2).redMul(zinv);
  return this.curve.point(ax, ay);
};
JPoint.prototype.neg = function neg2() {
  return this.curve.jpoint(this.x, this.y.redNeg(), this.z);
};
JPoint.prototype.add = function add2(p3) {
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
  var r = s1.redSub(s2);
  if (h4.cmpn(0) === 0) {
    if (r.cmpn(0) !== 0)
      return this.curve.jpoint(null, null, null);
    else
      return this.dbl();
  }
  var h22 = h4.redSqr();
  var h32 = h22.redMul(h4);
  var v3 = u1.redMul(h22);
  var nx = r.redSqr().redIAdd(h32).redISub(v3).redISub(v3);
  var ny = r.redMul(v3.redISub(nx)).redISub(s1.redMul(h32));
  var nz = this.z.redMul(p3.z).redMul(h4);
  return this.curve.jpoint(nx, ny, nz);
};
JPoint.prototype.mixedAdd = function mixedAdd(p3) {
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
  var r = s1.redSub(s2);
  if (h4.cmpn(0) === 0) {
    if (r.cmpn(0) !== 0)
      return this.curve.jpoint(null, null, null);
    else
      return this.dbl();
  }
  var h22 = h4.redSqr();
  var h32 = h22.redMul(h4);
  var v3 = u1.redMul(h22);
  var nx = r.redSqr().redIAdd(h32).redISub(v3).redISub(v3);
  var ny = r.redMul(v3.redISub(nx)).redISub(s1.redMul(h32));
  var nz = this.z.redMul(h4);
  return this.curve.jpoint(nx, ny, nz);
};
JPoint.prototype.dblp = function dblp2(pow) {
  if (pow === 0)
    return this;
  if (this.isInfinity())
    return this;
  if (!pow)
    return this.dbl();
  var i2;
  if (this.curve.zeroA || this.curve.threeA) {
    var r = this;
    for (i2 = 0; i2 < pow; i2++)
      r = r.dbl();
    return r;
  }
  var a3 = this.curve.a;
  var tinv = this.curve.tinv;
  var jx = this.x;
  var jy = this.y;
  var jz = this.z;
  var jz4 = jz.redSqr().redSqr();
  var jyd = jy.redAdd(jy);
  for (i2 = 0; i2 < pow; i2++) {
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
    if (i2 + 1 < pow)
      jz4 = jz4.redMul(jyd4);
    jx = nx;
    jz = nz;
    jyd = dny;
  }
  return this.curve.jpoint(jx, jyd.redMul(tinv), jz);
};
JPoint.prototype.dbl = function dbl2() {
  if (this.isInfinity())
    return this;
  if (this.curve.zeroA)
    return this._zeroDbl();
  else if (this.curve.threeA)
    return this._threeDbl();
  else
    return this._dbl();
};
JPoint.prototype._zeroDbl = function _zeroDbl() {
  var nx;
  var ny;
  var nz;
  if (this.zOne) {
    var xx = this.x.redSqr();
    var yy = this.y.redSqr();
    var yyyy = yy.redSqr();
    var s = this.x.redAdd(yy).redSqr().redISub(xx).redISub(yyyy);
    s = s.redIAdd(s);
    var m3 = xx.redAdd(xx).redIAdd(xx);
    var t = m3.redSqr().redISub(s).redISub(s);
    var yyyy8 = yyyy.redIAdd(yyyy);
    yyyy8 = yyyy8.redIAdd(yyyy8);
    yyyy8 = yyyy8.redIAdd(yyyy8);
    nx = t;
    ny = m3.redMul(s.redISub(t)).redISub(yyyy8);
    nz = this.y.redAdd(this.y);
  } else {
    var a3 = this.x.redSqr();
    var b3 = this.y.redSqr();
    var c2 = b3.redSqr();
    var d4 = this.x.redAdd(b3).redSqr().redISub(a3).redISub(c2);
    d4 = d4.redIAdd(d4);
    var e = a3.redAdd(a3).redIAdd(a3);
    var f3 = e.redSqr();
    var c8 = c2.redIAdd(c2);
    c8 = c8.redIAdd(c8);
    c8 = c8.redIAdd(c8);
    nx = f3.redISub(d4).redISub(d4);
    ny = e.redMul(d4.redISub(nx)).redISub(c8);
    nz = this.y.redMul(this.z);
    nz = nz.redIAdd(nz);
  }
  return this.curve.jpoint(nx, ny, nz);
};
JPoint.prototype._threeDbl = function _threeDbl() {
  var nx;
  var ny;
  var nz;
  if (this.zOne) {
    var xx = this.x.redSqr();
    var yy = this.y.redSqr();
    var yyyy = yy.redSqr();
    var s = this.x.redAdd(yy).redSqr().redISub(xx).redISub(yyyy);
    s = s.redIAdd(s);
    var m3 = xx.redAdd(xx).redIAdd(xx).redIAdd(this.curve.a);
    var t = m3.redSqr().redISub(s).redISub(s);
    nx = t;
    var yyyy8 = yyyy.redIAdd(yyyy);
    yyyy8 = yyyy8.redIAdd(yyyy8);
    yyyy8 = yyyy8.redIAdd(yyyy8);
    ny = m3.redMul(s.redISub(t)).redISub(yyyy8);
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
JPoint.prototype._dbl = function _dbl() {
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
JPoint.prototype.trpl = function trpl() {
  if (!this.curve.zeroA)
    return this.dbl().add(this);
  var xx = this.x.redSqr();
  var yy = this.y.redSqr();
  var zz = this.z.redSqr();
  var yyyy = yy.redSqr();
  var m3 = xx.redAdd(xx).redIAdd(xx);
  var mm = m3.redSqr();
  var e = this.x.redAdd(yy).redSqr().redISub(xx).redISub(yyyy);
  e = e.redIAdd(e);
  e = e.redAdd(e).redIAdd(e);
  e = e.redISub(mm);
  var ee2 = e.redSqr();
  var t = yyyy.redIAdd(yyyy);
  t = t.redIAdd(t);
  t = t.redIAdd(t);
  t = t.redIAdd(t);
  var u2 = m3.redIAdd(e).redSqr().redISub(mm).redISub(ee2).redISub(t);
  var yyu4 = yy.redMul(u2);
  yyu4 = yyu4.redIAdd(yyu4);
  yyu4 = yyu4.redIAdd(yyu4);
  var nx = this.x.redMul(ee2).redISub(yyu4);
  nx = nx.redIAdd(nx);
  nx = nx.redIAdd(nx);
  var ny = this.y.redMul(u2.redMul(t.redISub(u2)).redISub(e.redMul(ee2)));
  ny = ny.redIAdd(ny);
  ny = ny.redIAdd(ny);
  ny = ny.redIAdd(ny);
  var nz = this.z.redAdd(e).redSqr().redISub(zz).redISub(ee2);
  return this.curve.jpoint(nx, ny, nz);
};
JPoint.prototype.mul = function mul2(k2, kbase) {
  k2 = new BN$1(k2, kbase);
  return this.curve._wnafMul(this, k2);
};
JPoint.prototype.eq = function eq3(p3) {
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
JPoint.prototype.eqXToP = function eqXToP(x2) {
  var zs2 = this.z.redSqr();
  var rx = x2.toRed(this.curve.red).redMul(zs2);
  if (this.x.cmp(rx) === 0)
    return true;
  var xc = x2.clone();
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
JPoint.prototype.inspect = function inspect2() {
  if (this.isInfinity())
    return "<EC JPoint Infinity>";
  return "<EC JPoint x: " + this.x.toString(16, 2) + " y: " + this.y.toString(16, 2) + " z: " + this.z.toString(16, 2) + ">";
};
JPoint.prototype.isInfinity = function isInfinity2() {
  return this.z.cmpn(0) === 0;
};
var curve_1 = createCommonjsModule(function(module, exports) {
  var curve = exports;
  curve.base = base;
  curve.short = short_1;
  curve.mont = /*RicMoo:ethers:require(./mont)*/
  null;
  curve.edwards = /*RicMoo:ethers:require(./edwards)*/
  null;
});
var curves_1 = createCommonjsModule(function(module, exports) {
  var curves = exports;
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
  curves.PresetCurve = PresetCurve;
  function defineCurve(name, options) {
    Object.defineProperty(curves, name, {
      configurable: true,
      enumerable: true,
      get: function() {
        var curve = new PresetCurve(options);
        Object.defineProperty(curves, name, {
          configurable: true,
          enumerable: true,
          value: curve
        });
        return curve;
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
    hash: hash.sha256,
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
    hash: hash.sha256,
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
    hash: hash.sha256,
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
    hash: hash.sha384,
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
    hash: hash.sha512,
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
    hash: hash.sha256,
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
    hash: hash.sha256,
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
  } catch (e) {
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
    hash: hash.sha256,
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
function HmacDRBG(options) {
  if (!(this instanceof HmacDRBG))
    return new HmacDRBG(options);
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
var hmacDrbg = HmacDRBG;
HmacDRBG.prototype._init = function init(entropy, nonce, pers) {
  var seed = entropy.concat(nonce).concat(pers);
  this.K = new Array(this.outLen / 8);
  this.V = new Array(this.outLen / 8);
  for (var i2 = 0; i2 < this.V.length; i2++) {
    this.K[i2] = 0;
    this.V[i2] = 1;
  }
  this._update(seed);
  this._reseed = 1;
  this.reseedInterval = 281474976710656;
};
HmacDRBG.prototype._hmac = function hmac2() {
  return new hash.hmac(this.hash, this.K);
};
HmacDRBG.prototype._update = function update(seed) {
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
HmacDRBG.prototype.reseed = function reseed(entropy, entropyEnc, add3, addEnc) {
  if (typeof entropyEnc !== "string") {
    addEnc = add3;
    add3 = entropyEnc;
    entropyEnc = null;
  }
  entropy = utils_1.toArray(entropy, entropyEnc);
  add3 = utils_1.toArray(add3, addEnc);
  minimalisticAssert(
    entropy.length >= this.minEntropy / 8,
    "Not enough entropy. Minimum is: " + this.minEntropy + " bits"
  );
  this._update(entropy.concat(add3 || []));
  this._reseed = 1;
};
HmacDRBG.prototype.generate = function generate(len, enc, add3, addEnc) {
  if (this._reseed > this.reseedInterval)
    throw new Error("Reseed is required");
  if (typeof enc !== "string") {
    addEnc = add3;
    add3 = enc;
    enc = null;
  }
  if (add3) {
    add3 = utils_1.toArray(add3, addEnc || "hex");
    this._update(add3);
  }
  var temp = [];
  while (temp.length < len) {
    this.V = this._hmac().update(this.V).digest();
    temp = temp.concat(this.V);
  }
  var res = temp.slice(0, len);
  this._update(add3);
  this._reseed++;
  return utils_1.encode(res, enc);
};
var assert$3 = utils_1$1.assert;
function KeyPair(ec2, options) {
  this.ec = ec2;
  this.priv = null;
  this.pub = null;
  if (options.priv)
    this._importPrivate(options.priv, options.privEnc);
  if (options.pub)
    this._importPublic(options.pub, options.pubEnc);
}
var key = KeyPair;
KeyPair.fromPublic = function fromPublic(ec2, pub, enc) {
  if (pub instanceof KeyPair)
    return pub;
  return new KeyPair(ec2, {
    pub,
    pubEnc: enc
  });
};
KeyPair.fromPrivate = function fromPrivate(ec2, priv, enc) {
  if (priv instanceof KeyPair)
    return priv;
  return new KeyPair(ec2, {
    priv,
    privEnc: enc
  });
};
KeyPair.prototype.validate = function validate4() {
  var pub = this.getPublic();
  if (pub.isInfinity())
    return { result: false, reason: "Invalid public key" };
  if (!pub.validate())
    return { result: false, reason: "Public key is not a point" };
  if (!pub.mul(this.ec.curve.n).isInfinity())
    return { result: false, reason: "Public key * N != O" };
  return { result: true, reason: null };
};
KeyPair.prototype.getPublic = function getPublic(compact, enc) {
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
KeyPair.prototype.getPrivate = function getPrivate(enc) {
  if (enc === "hex")
    return this.priv.toString(16, 2);
  else
    return this.priv;
};
KeyPair.prototype._importPrivate = function _importPrivate(key2, enc) {
  this.priv = new BN$1(key2, enc || 16);
  this.priv = this.priv.umod(this.ec.curve.n);
};
KeyPair.prototype._importPublic = function _importPublic(key2, enc) {
  if (key2.x || key2.y) {
    if (this.ec.curve.type === "mont") {
      assert$3(key2.x, "Need x coordinate");
    } else if (this.ec.curve.type === "short" || this.ec.curve.type === "edwards") {
      assert$3(key2.x && key2.y, "Need both x and y coordinate");
    }
    this.pub = this.ec.curve.point(key2.x, key2.y);
    return;
  }
  this.pub = this.ec.curve.decodePoint(key2, enc);
};
KeyPair.prototype.derive = function derive(pub) {
  if (!pub.validate()) {
    assert$3(pub.validate(), "public point not validated");
  }
  return pub.mul(this.priv).getX();
};
KeyPair.prototype.sign = function sign(msg, enc, options) {
  return this.ec.sign(msg, this, enc, options);
};
KeyPair.prototype.verify = function verify(msg, signature2) {
  return this.ec.verify(msg, signature2, this);
};
KeyPair.prototype.inspect = function inspect3() {
  return "<Key priv: " + (this.priv && this.priv.toString(16, 2)) + " pub: " + (this.pub && this.pub.inspect()) + " >";
};
var assert$4 = utils_1$1.assert;
function Signature(options, enc) {
  if (options instanceof Signature)
    return options;
  if (this._importDER(options, enc))
    return;
  assert$4(options.r && options.s, "Signature without r or s");
  this.r = new BN$1(options.r, 16);
  this.s = new BN$1(options.s, 16);
  if (options.recoveryParam === void 0)
    this.recoveryParam = null;
  else
    this.recoveryParam = options.recoveryParam;
}
var signature = Signature;
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
  var val = 0;
  for (var i2 = 0, off = p3.place; i2 < octetLen; i2++, off++) {
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
  var i2 = 0;
  var len = buf.length - 1;
  while (!buf[i2] && !(buf[i2 + 1] & 128) && i2 < len) {
    i2++;
  }
  if (i2 === 0) {
    return buf;
  }
  return buf.slice(i2);
}
Signature.prototype._importDER = function _importDER(data, enc) {
  data = utils_1$1.toArray(data, enc);
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
  var r = data.slice(p3.place, rlen + p3.place);
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
  var s = data.slice(p3.place, slen + p3.place);
  if (r[0] === 0) {
    if (r[1] & 128) {
      r = r.slice(1);
    } else {
      return false;
    }
  }
  if (s[0] === 0) {
    if (s[1] & 128) {
      s = s.slice(1);
    } else {
      return false;
    }
  }
  this.r = new BN$1(r);
  this.s = new BN$1(s);
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
Signature.prototype.toDER = function toDER(enc) {
  var r = this.r.toArray();
  var s = this.s.toArray();
  if (r[0] & 128)
    r = [0].concat(r);
  if (s[0] & 128)
    s = [0].concat(s);
  r = rmPadding(r);
  s = rmPadding(s);
  while (!s[0] && !(s[1] & 128)) {
    s = s.slice(1);
  }
  var arr = [2];
  constructLength(arr, r.length);
  arr = arr.concat(r);
  arr.push(2);
  constructLength(arr, s.length);
  var backHalf = arr.concat(s);
  var res = [48];
  constructLength(res, backHalf.length);
  res = res.concat(backHalf);
  return utils_1$1.encode(res, enc);
};
var rand = (
  /*RicMoo:ethers:require(brorand)*/
  function() {
    throw new Error("unsupported");
  }
);
var assert$5 = utils_1$1.assert;
function EC(options) {
  if (!(this instanceof EC))
    return new EC(options);
  if (typeof options === "string") {
    assert$5(
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
var ec = EC;
EC.prototype.keyPair = function keyPair(options) {
  return new key(this, options);
};
EC.prototype.keyFromPrivate = function keyFromPrivate(priv, enc) {
  return key.fromPrivate(this, priv, enc);
};
EC.prototype.keyFromPublic = function keyFromPublic(pub, enc) {
  return key.fromPublic(this, pub, enc);
};
EC.prototype.genKeyPair = function genKeyPair(options) {
  if (!options)
    options = {};
  var drbg = new hmacDrbg({
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
    var priv = new BN$1(drbg.generate(bytes));
    if (priv.cmp(ns2) > 0)
      continue;
    priv.iaddn(1);
    return this.keyFromPrivate(priv);
  }
};
EC.prototype._truncateToN = function _truncateToN(msg, truncOnly) {
  var delta = msg.byteLength() * 8 - this.n.bitLength();
  if (delta > 0)
    msg = msg.ushrn(delta);
  if (!truncOnly && msg.cmp(this.n) >= 0)
    return msg.sub(this.n);
  else
    return msg;
};
EC.prototype.sign = function sign2(msg, key2, enc, options) {
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
  var drbg = new hmacDrbg({
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
    var r = kpX.umod(this.n);
    if (r.cmpn(0) === 0)
      continue;
    var s = k2.invm(this.n).mul(r.mul(key2.getPrivate()).iadd(msg));
    s = s.umod(this.n);
    if (s.cmpn(0) === 0)
      continue;
    var recoveryParam = (kp.getY().isOdd() ? 1 : 0) | (kpX.cmp(r) !== 0 ? 2 : 0);
    if (options.canonical && s.cmp(this.nh) > 0) {
      s = this.n.sub(s);
      recoveryParam ^= 1;
    }
    return new signature({ r, s, recoveryParam });
  }
};
EC.prototype.verify = function verify2(msg, signature$1, key2, enc) {
  msg = this._truncateToN(new BN$1(msg, 16));
  key2 = this.keyFromPublic(key2, enc);
  signature$1 = new signature(signature$1, "hex");
  var r = signature$1.r;
  var s = signature$1.s;
  if (r.cmpn(1) < 0 || r.cmp(this.n) >= 0)
    return false;
  if (s.cmpn(1) < 0 || s.cmp(this.n) >= 0)
    return false;
  var sinv = s.invm(this.n);
  var u1 = sinv.mul(msg).umod(this.n);
  var u2 = sinv.mul(r).umod(this.n);
  var p3;
  if (!this.curve._maxwellTrick) {
    p3 = this.g.mulAdd(u1, key2.getPublic(), u2);
    if (p3.isInfinity())
      return false;
    return p3.getX().umod(this.n).cmp(r) === 0;
  }
  p3 = this.g.jmulAdd(u1, key2.getPublic(), u2);
  if (p3.isInfinity())
    return false;
  return p3.eqXToP(r);
};
EC.prototype.recoverPubKey = function(msg, signature$1, j2, enc) {
  assert$5((3 & j2) === j2, "The recovery param is more than two bits");
  signature$1 = new signature(signature$1, enc);
  var n2 = this.n;
  var e = new BN$1(msg);
  var r = signature$1.r;
  var s = signature$1.s;
  var isYOdd = j2 & 1;
  var isSecondKey = j2 >> 1;
  if (r.cmp(this.curve.p.umod(this.curve.n)) >= 0 && isSecondKey)
    throw new Error("Unable to find sencond key candinate");
  if (isSecondKey)
    r = this.curve.pointFromX(r.add(this.curve.n), isYOdd);
  else
    r = this.curve.pointFromX(r, isYOdd);
  var rInv = signature$1.r.invm(n2);
  var s1 = n2.sub(e).mul(rInv).umod(n2);
  var s2 = s.mul(rInv).umod(n2);
  return this.g.mulAdd(s1, r, s2);
};
EC.prototype.getKeyRecoveryParam = function(e, signature$1, Q2, enc) {
  signature$1 = new signature(signature$1, enc);
  if (signature$1.recoveryParam !== null)
    return signature$1.recoveryParam;
  for (var i2 = 0; i2 < 4; i2++) {
    var Qprime;
    try {
      Qprime = this.recoverPubKey(e, signature$1, i2);
    } catch (e2) {
      continue;
    }
    if (Qprime.eq(Q2))
      return i2;
  }
  throw new Error("Unable to find valid recovery factor");
};
var elliptic_1 = createCommonjsModule(function(module, exports) {
  var elliptic = exports;
  elliptic.version = /*RicMoo:ethers*/
  { version: "6.5.4" }.version;
  elliptic.utils = utils_1$1;
  elliptic.rand = /*RicMoo:ethers:require(brorand)*/
  function() {
    throw new Error("unsupported");
  };
  elliptic.curve = curve_1;
  elliptic.curves = curves_1;
  elliptic.ec = ec;
  elliptic.eddsa = /*RicMoo:ethers:require(./elliptic/eddsa)*/
  null;
});
var EC$1 = elliptic_1.ec;
const version = "signing-key/5.7.0";
const logger = new Logger(version);
let _curve = null;
function getCurve() {
  if (!_curve) {
    _curve = new EC$1("secp256k1");
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
    const keyPair2 = getCurve().keyFromPrivate(arrayify(this.privateKey));
    defineReadOnly(this, "publicKey", "0x" + keyPair2.getPublic(false, "hex"));
    defineReadOnly(this, "compressedPublicKey", "0x" + keyPair2.getPublic(true, "hex"));
    defineReadOnly(this, "_isSigningKey", true);
  }
  _addPoint(other) {
    const p02 = getCurve().keyFromPublic(arrayify(this.publicKey));
    const p1 = getCurve().keyFromPublic(arrayify(other));
    return "0x" + p02.pub.add(p1.pub).encodeCompressed("hex");
  }
  signDigest(digest) {
    const keyPair2 = getCurve().keyFromPrivate(arrayify(this.privateKey));
    const digestBytes = arrayify(digest);
    if (digestBytes.length !== 32) {
      logger.throwArgumentError("bad digest length", "digest", digest);
    }
    const signature2 = keyPair2.sign(digestBytes, { canonical: true });
    return splitSignature({
      recoveryParam: signature2.recoveryParam,
      r: hexZeroPad("0x" + signature2.r.toString(16), 32),
      s: hexZeroPad("0x" + signature2.s.toString(16), 32)
    });
  }
  computeSharedSecret(otherKey) {
    const keyPair2 = getCurve().keyFromPrivate(arrayify(this.privateKey));
    const otherKeyPair = getCurve().keyFromPublic(arrayify(computePublicKey(otherKey)));
    return hexZeroPad("0x" + keyPair2.derive(otherKeyPair.getPublic()).toString(16), 32);
  }
  static isSigningKey(value) {
    return !!(value && value._isSigningKey);
  }
}
function recoverPublicKey(digest, signature2) {
  const sig = splitSignature(signature2);
  const rs2 = { r: arrayify(sig.r), s: arrayify(sig.s) };
  return "0x" + getCurve().recoverPubKey(arrayify(digest), rs2, sig.recoveryParam).encode("hex", false);
}
function computePublicKey(key2, compressed) {
  const bytes = arrayify(key2);
  if (bytes.length === 32) {
    const signingKey = new SigningKey(bytes);
    if (compressed) {
      return "0x" + getCurve().keyFromPrivate(bytes).getPublic(true, "hex");
    }
    return signingKey.publicKey;
  } else if (bytes.length === 33) {
    if (compressed) {
      return hexlify(bytes);
    }
    return "0x" + getCurve().keyFromPublic(bytes).getPublic(false, "hex");
  } else if (bytes.length === 65) {
    if (!compressed) {
      return hexlify(bytes);
    }
    return "0x" + getCurve().keyFromPublic(bytes).getPublic(true, "hex");
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
const Y$1 = "https://rpc.walletconnect.com/v1", R$1 = { wc_authRequest: { req: { ttl: cjs$3.ONE_DAY, prompt: true, tag: 3e3 }, res: { ttl: cjs$3.ONE_DAY, prompt: false, tag: 3001 } } }, U$1 = { min: cjs$3.FIVE_MINUTES, max: cjs$3.SEVEN_DAYS }, $ = "wc", Q = 1, Z$1 = "auth", B$1 = "authClient", F$2 = `${$}@${1}:${Z$1}:`, x$1 = `${F$2}:PUB_KEY`;
function z$1(r) {
  return r == null ? void 0 : r.split(":");
}
function Ze(r) {
  const t = r && z$1(r);
  if (t)
    return t[3];
}
function We$1(r) {
  const t = r && z$1(r);
  if (t)
    return t[2] + ":" + t[3];
}
function W(r) {
  const t = r && z$1(r);
  if (t)
    return t.pop();
}
async function et(r, t, e, i2, n2) {
  switch (e.t) {
    case "eip191":
      return tt(r, t, e.s);
    case "eip1271":
      return await rt(r, t, e.s, i2, n2);
    default:
      throw new Error(`verifySignature failed: Attempted to verify CacaoSignature with unknown type: ${e.t}`);
  }
}
function tt(r, t, e) {
  return recoverAddress(hashMessage(t), e).toLowerCase() === r.toLowerCase();
}
async function rt(r, t, e, i2, n2) {
  try {
    const s = "0x1626ba7e", o2 = "0000000000000000000000000000000000000000000000000000000000000040", u2 = "0000000000000000000000000000000000000000000000000000000000000041", a3 = e.substring(2), c2 = hashMessage(t).substring(2), h4 = s + c2 + o2 + u2 + a3, f3 = await ke$2(`${Y$1}/?chainId=${i2}&projectId=${n2}`, { method: "POST", body: JSON.stringify({ id: it(), jsonrpc: "2.0", method: "eth_call", params: [{ to: r, data: h4 }, "latest"] }) }), { result: p3 } = await f3.json();
    return p3 ? p3.slice(0, s.length).toLowerCase() === s.toLowerCase() : false;
  } catch (s) {
    return console.error("isValidEip1271Signature: ", s), false;
  }
}
function it() {
  return Date.now() + Math.floor(Math.random() * 1e3);
}
function ee$1(r) {
  return r.getAll().filter((t) => "requester" in t);
}
function te$1(r, t) {
  return ee$1(r).find((e) => e.id === t);
}
function nt(r) {
  const t = Ju(r.aud), e = new RegExp(`${r.domain}`).test(r.aud), i2 = !!r.nonce, n2 = r.type ? r.type === "eip4361" : true, s = r.expiry;
  if (s && !uh(s, U$1)) {
    const { message: o2 } = xe("MISSING_OR_INVALID", `request() expiry: ${s}. Expiry must be a number (in seconds) between ${U$1.min} and ${U$1.max}`);
    throw new Error(o2);
  }
  return !!(t && e && i2 && n2);
}
function st(r, t) {
  return !!te$1(t, r.id);
}
function ot(r = 0) {
  return globalThis.Buffer != null && globalThis.Buffer.allocUnsafe != null ? globalThis.Buffer.allocUnsafe(r) : new Uint8Array(r);
}
function ut(r, t) {
  if (r.length >= 255)
    throw new TypeError("Alphabet too long");
  for (var e = new Uint8Array(256), i2 = 0; i2 < e.length; i2++)
    e[i2] = 255;
  for (var n2 = 0; n2 < r.length; n2++) {
    var s = r.charAt(n2), o2 = s.charCodeAt(0);
    if (e[o2] !== 255)
      throw new TypeError(s + " is ambiguous");
    e[o2] = n2;
  }
  var u2 = r.length, a3 = r.charAt(0), c2 = Math.log(u2) / Math.log(256), h4 = Math.log(256) / Math.log(u2);
  function f3(D2) {
    if (D2 instanceof Uint8Array || (ArrayBuffer.isView(D2) ? D2 = new Uint8Array(D2.buffer, D2.byteOffset, D2.byteLength) : Array.isArray(D2) && (D2 = Uint8Array.from(D2))), !(D2 instanceof Uint8Array))
      throw new TypeError("Expected Uint8Array");
    if (D2.length === 0)
      return "";
    for (var l2 = 0, m3 = 0, E3 = 0, y3 = D2.length; E3 !== y3 && D2[E3] === 0; )
      E3++, l2++;
    for (var w3 = (y3 - E3) * h4 + 1 >>> 0, g3 = new Uint8Array(w3); E3 !== y3; ) {
      for (var C2 = D2[E3], _3 = 0, b3 = w3 - 1; (C2 !== 0 || _3 < m3) && b3 !== -1; b3--, _3++)
        C2 += 256 * g3[b3] >>> 0, g3[b3] = C2 % u2 >>> 0, C2 = C2 / u2 >>> 0;
      if (C2 !== 0)
        throw new Error("Non-zero carry");
      m3 = _3, E3++;
    }
    for (var v3 = w3 - m3; v3 !== w3 && g3[v3] === 0; )
      v3++;
    for (var q2 = a3.repeat(l2); v3 < w3; ++v3)
      q2 += r.charAt(g3[v3]);
    return q2;
  }
  function p3(D2) {
    if (typeof D2 != "string")
      throw new TypeError("Expected String");
    if (D2.length === 0)
      return new Uint8Array();
    var l2 = 0;
    if (D2[l2] !== " ") {
      for (var m3 = 0, E3 = 0; D2[l2] === a3; )
        m3++, l2++;
      for (var y3 = (D2.length - l2) * c2 + 1 >>> 0, w3 = new Uint8Array(y3); D2[l2]; ) {
        var g3 = e[D2.charCodeAt(l2)];
        if (g3 === 255)
          return;
        for (var C2 = 0, _3 = y3 - 1; (g3 !== 0 || C2 < E3) && _3 !== -1; _3--, C2++)
          g3 += u2 * w3[_3] >>> 0, w3[_3] = g3 % 256 >>> 0, g3 = g3 / 256 >>> 0;
        if (g3 !== 0)
          throw new Error("Non-zero carry");
        E3 = C2, l2++;
      }
      if (D2[l2] !== " ") {
        for (var b3 = y3 - E3; b3 !== y3 && w3[b3] === 0; )
          b3++;
        for (var v3 = new Uint8Array(m3 + (y3 - b3)), q2 = m3; b3 !== y3; )
          v3[q2++] = w3[b3++];
        return v3;
      }
    }
  }
  function A2(D2) {
    var l2 = p3(D2);
    if (l2)
      return l2;
    throw new Error(`Non-${t} character`);
  }
  return { encode: f3, decodeUnsafe: p3, decode: A2 };
}
var at = ut, Dt = at;
const re$1 = (r) => {
  if (r instanceof Uint8Array && r.constructor.name === "Uint8Array")
    return r;
  if (r instanceof ArrayBuffer)
    return new Uint8Array(r);
  if (ArrayBuffer.isView(r))
    return new Uint8Array(r.buffer, r.byteOffset, r.byteLength);
  throw new Error("Unknown type, must be binary type");
}, ct = (r) => new TextEncoder().encode(r), ht = (r) => new TextDecoder().decode(r);
class lt {
  constructor(t, e, i2) {
    this.name = t, this.prefix = e, this.baseEncode = i2;
  }
  encode(t) {
    if (t instanceof Uint8Array)
      return `${this.prefix}${this.baseEncode(t)}`;
    throw Error("Unknown type, must be binary type");
  }
}
class dt {
  constructor(t, e, i2) {
    if (this.name = t, this.prefix = e, e.codePointAt(0) === void 0)
      throw new Error("Invalid prefix character");
    this.prefixCodePoint = e.codePointAt(0), this.baseDecode = i2;
  }
  decode(t) {
    if (typeof t == "string") {
      if (t.codePointAt(0) !== this.prefixCodePoint)
        throw Error(`Unable to decode multibase string ${JSON.stringify(t)}, ${this.name} decoder only supports inputs prefixed with ${this.prefix}`);
      return this.baseDecode(t.slice(this.prefix.length));
    } else
      throw Error("Can only multibase decode strings");
  }
  or(t) {
    return ie$2(this, t);
  }
}
class pt {
  constructor(t) {
    this.decoders = t;
  }
  or(t) {
    return ie$2(this, t);
  }
  decode(t) {
    const e = t[0], i2 = this.decoders[e];
    if (i2)
      return i2.decode(t);
    throw RangeError(`Unable to decode multibase string ${JSON.stringify(t)}, only inputs prefixed with ${Object.keys(this.decoders)} are supported`);
  }
}
const ie$2 = (r, t) => new pt({ ...r.decoders || { [r.prefix]: r }, ...t.decoders || { [t.prefix]: t } });
class ft {
  constructor(t, e, i2, n2) {
    this.name = t, this.prefix = e, this.baseEncode = i2, this.baseDecode = n2, this.encoder = new lt(t, e, i2), this.decoder = new dt(t, e, n2);
  }
  encode(t) {
    return this.encoder.encode(t);
  }
  decode(t) {
    return this.decoder.decode(t);
  }
}
const O$1 = ({ name: r, prefix: t, encode: e, decode: i2 }) => new ft(r, t, e, i2), T$1 = ({ prefix: r, name: t, alphabet: e }) => {
  const { encode: i2, decode: n2 } = Dt(e, t);
  return O$1({ prefix: r, name: t, encode: i2, decode: (s) => re$1(n2(s)) });
}, gt = (r, t, e, i2) => {
  const n2 = {};
  for (let h4 = 0; h4 < t.length; ++h4)
    n2[t[h4]] = h4;
  let s = r.length;
  for (; r[s - 1] === "="; )
    --s;
  const o2 = new Uint8Array(s * e / 8 | 0);
  let u2 = 0, a3 = 0, c2 = 0;
  for (let h4 = 0; h4 < s; ++h4) {
    const f3 = n2[r[h4]];
    if (f3 === void 0)
      throw new SyntaxError(`Non-${i2} character`);
    a3 = a3 << e | f3, u2 += e, u2 >= 8 && (u2 -= 8, o2[c2++] = 255 & a3 >> u2);
  }
  if (u2 >= e || 255 & a3 << 8 - u2)
    throw new SyntaxError("Unexpected end of data");
  return o2;
}, Et = (r, t, e) => {
  const i2 = t[t.length - 1] === "=", n2 = (1 << e) - 1;
  let s = "", o2 = 0, u2 = 0;
  for (let a3 = 0; a3 < r.length; ++a3)
    for (u2 = u2 << 8 | r[a3], o2 += 8; o2 > e; )
      o2 -= e, s += t[n2 & u2 >> o2];
  if (o2 && (s += t[n2 & u2 << e - o2]), i2)
    for (; s.length * e & 7; )
      s += "=";
  return s;
}, d3 = ({ name: r, prefix: t, bitsPerChar: e, alphabet: i2 }) => O$1({ prefix: t, name: r, encode(n2) {
  return Et(n2, i2, e);
}, decode(n2) {
  return gt(n2, i2, e, r);
} }), bt = O$1({ prefix: "\0", name: "identity", encode: (r) => ht(r), decode: (r) => ct(r) });
var yt = Object.freeze({ __proto__: null, identity: bt });
const wt = d3({ prefix: "0", name: "base2", alphabet: "01", bitsPerChar: 1 });
var Ct = Object.freeze({ __proto__: null, base2: wt });
const mt = d3({ prefix: "7", name: "base8", alphabet: "01234567", bitsPerChar: 3 });
var vt = Object.freeze({ __proto__: null, base8: mt });
const At2 = T$1({ prefix: "9", name: "base10", alphabet: "0123456789" });
var _t = Object.freeze({ __proto__: null, base10: At2 });
const xt = d3({ prefix: "f", name: "base16", alphabet: "0123456789abcdef", bitsPerChar: 4 }), Rt = d3({ prefix: "F", name: "base16upper", alphabet: "0123456789ABCDEF", bitsPerChar: 4 });
var Ft = Object.freeze({ __proto__: null, base16: xt, base16upper: Rt });
const Tt = d3({ prefix: "b", name: "base32", alphabet: "abcdefghijklmnopqrstuvwxyz234567", bitsPerChar: 5 }), It = d3({ prefix: "B", name: "base32upper", alphabet: "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567", bitsPerChar: 5 }), qt2 = d3({ prefix: "c", name: "base32pad", alphabet: "abcdefghijklmnopqrstuvwxyz234567=", bitsPerChar: 5 }), Ut3 = d3({ prefix: "C", name: "base32padupper", alphabet: "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567=", bitsPerChar: 5 }), Ot2 = d3({ prefix: "v", name: "base32hex", alphabet: "0123456789abcdefghijklmnopqrstuv", bitsPerChar: 5 }), St = d3({ prefix: "V", name: "base32hexupper", alphabet: "0123456789ABCDEFGHIJKLMNOPQRSTUV", bitsPerChar: 5 }), Pt = d3({ prefix: "t", name: "base32hexpad", alphabet: "0123456789abcdefghijklmnopqrstuv=", bitsPerChar: 5 }), Nt = d3({ prefix: "T", name: "base32hexpadupper", alphabet: "0123456789ABCDEFGHIJKLMNOPQRSTUV=", bitsPerChar: 5 }), $t = d3({ prefix: "h", name: "base32z", alphabet: "ybndrfg8ejkmcpqxot1uwisza345h769", bitsPerChar: 5 });
var Bt$1 = Object.freeze({ __proto__: null, base32: Tt, base32upper: It, base32pad: qt2, base32padupper: Ut3, base32hex: Ot2, base32hexupper: St, base32hexpad: Pt, base32hexpadupper: Nt, base32z: $t });
const zt2 = T$1({ prefix: "k", name: "base36", alphabet: "0123456789abcdefghijklmnopqrstuvwxyz" }), jt2 = T$1({ prefix: "K", name: "base36upper", alphabet: "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ" });
var Mt = Object.freeze({ __proto__: null, base36: zt2, base36upper: jt2 });
const Lt = T$1({ name: "base58btc", prefix: "z", alphabet: "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz" }), Kt = T$1({ name: "base58flickr", prefix: "Z", alphabet: "123456789abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ" });
var Vt2 = Object.freeze({ __proto__: null, base58btc: Lt, base58flickr: Kt });
const kt2 = d3({ prefix: "m", name: "base64", alphabet: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/", bitsPerChar: 6 }), Jt$1 = d3({ prefix: "M", name: "base64pad", alphabet: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=", bitsPerChar: 6 }), Xt$1 = d3({ prefix: "u", name: "base64url", alphabet: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_", bitsPerChar: 6 }), Gt2 = d3({ prefix: "U", name: "base64urlpad", alphabet: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_=", bitsPerChar: 6 });
var Ht$1 = Object.freeze({ __proto__: null, base64: kt2, base64pad: Jt$1, base64url: Xt$1, base64urlpad: Gt2 });
const ne$2 = Array.from("🚀🪐☄🛰🌌🌑🌒🌓🌔🌕🌖🌗🌘🌍🌏🌎🐉☀💻🖥💾💿😂❤😍🤣😊🙏💕😭😘👍😅👏😁🔥🥰💔💖💙😢🤔😆🙄💪😉☺👌🤗💜😔😎😇🌹🤦🎉💞✌✨🤷😱😌🌸🙌😋💗💚😏💛🙂💓🤩😄😀🖤😃💯🙈👇🎶😒🤭❣😜💋👀😪😑💥🙋😞😩😡🤪👊🥳😥🤤👉💃😳✋😚😝😴🌟😬🙃🍀🌷😻😓⭐✅🥺🌈😈🤘💦✔😣🏃💐☹🎊💘😠☝😕🌺🎂🌻😐🖕💝🙊😹🗣💫💀👑🎵🤞😛🔴😤🌼😫⚽🤙☕🏆🤫👈😮🙆🍻🍃🐶💁😲🌿🧡🎁⚡🌞🎈❌✊👋😰🤨😶🤝🚶💰🍓💢🤟🙁🚨💨🤬✈🎀🍺🤓😙💟🌱😖👶🥴▶➡❓💎💸⬇😨🌚🦋😷🕺⚠🙅😟😵👎🤲🤠🤧📌🔵💅🧐🐾🍒😗🤑🌊🤯🐷☎💧😯💆👆🎤🙇🍑❄🌴💣🐸💌📍🥀🤢👅💡💩👐📸👻🤐🤮🎼🥵🚩🍎🍊👼💍📣🥂"), Yt$1 = ne$2.reduce((r, t, e) => (r[e] = t, r), []), Qt = ne$2.reduce((r, t, e) => (r[t.codePointAt(0)] = e, r), []);
function Zt$1(r) {
  return r.reduce((t, e) => (t += Yt$1[e], t), "");
}
function Wt$1(r) {
  const t = [];
  for (const e of r) {
    const i2 = Qt[e.codePointAt(0)];
    if (i2 === void 0)
      throw new Error(`Non-base256emoji character: ${e}`);
    t.push(i2);
  }
  return new Uint8Array(t);
}
const er = O$1({ prefix: "🚀", name: "base256emoji", encode: Zt$1, decode: Wt$1 });
var tr = Object.freeze({ __proto__: null, base256emoji: er }), rr = oe, se$2 = 128, ir = 127, nr = ~ir, sr = Math.pow(2, 31);
function oe(r, t, e) {
  t = t || [], e = e || 0;
  for (var i2 = e; r >= sr; )
    t[e++] = r & 255 | se$2, r /= 128;
  for (; r & nr; )
    t[e++] = r & 255 | se$2, r >>>= 7;
  return t[e] = r | 0, oe.bytes = e - i2 + 1, t;
}
var or = j$1, ur = 128, ue = 127;
function j$1(r, i2) {
  var e = 0, i2 = i2 || 0, n2 = 0, s = i2, o2, u2 = r.length;
  do {
    if (s >= u2)
      throw j$1.bytes = 0, new RangeError("Could not decode varint");
    o2 = r[s++], e += n2 < 28 ? (o2 & ue) << n2 : (o2 & ue) * Math.pow(2, n2), n2 += 7;
  } while (o2 >= ur);
  return j$1.bytes = s - i2, e;
}
var ar2 = Math.pow(2, 7), Dr = Math.pow(2, 14), cr = Math.pow(2, 21), hr2 = Math.pow(2, 28), lr = Math.pow(2, 35), dr2 = Math.pow(2, 42), pr = Math.pow(2, 49), fr = Math.pow(2, 56), gr = Math.pow(2, 63), Er = function(r) {
  return r < ar2 ? 1 : r < Dr ? 2 : r < cr ? 3 : r < hr2 ? 4 : r < lr ? 5 : r < dr2 ? 6 : r < pr ? 7 : r < fr ? 8 : r < gr ? 9 : 10;
}, br = { encode: rr, decode: or, encodingLength: Er }, ae = br;
const De = (r, t, e = 0) => (ae.encode(r, t, e), t), ce = (r) => ae.encodingLength(r), M = (r, t) => {
  const e = t.byteLength, i2 = ce(r), n2 = i2 + ce(e), s = new Uint8Array(n2 + e);
  return De(r, s, 0), De(e, s, i2), s.set(t, n2), new yr(r, e, t, s);
};
class yr {
  constructor(t, e, i2, n2) {
    this.code = t, this.size = e, this.digest = i2, this.bytes = n2;
  }
}
const he = ({ name: r, code: t, encode: e }) => new wr(r, t, e);
class wr {
  constructor(t, e, i2) {
    this.name = t, this.code = e, this.encode = i2;
  }
  digest(t) {
    if (t instanceof Uint8Array) {
      const e = this.encode(t);
      return e instanceof Uint8Array ? M(this.code, e) : e.then((i2) => M(this.code, i2));
    } else
      throw Error("Unknown type, must be binary type");
  }
}
const le = (r) => async (t) => new Uint8Array(await crypto.subtle.digest(r, t)), Cr2 = he({ name: "sha2-256", code: 18, encode: le("SHA-256") }), mr = he({ name: "sha2-512", code: 19, encode: le("SHA-512") });
var vr = Object.freeze({ __proto__: null, sha256: Cr2, sha512: mr });
const de = 0, Ar = "identity", pe = re$1, _r = (r) => M(de, pe(r)), xr = { code: de, name: Ar, encode: pe, digest: _r };
var Rr = Object.freeze({ __proto__: null, identity: xr });
new TextEncoder(), new TextDecoder();
const fe = { ...yt, ...Ct, ...vt, ..._t, ...Ft, ...Bt$1, ...Mt, ...Vt2, ...Ht$1, ...tr };
({ ...vr, ...Rr });
function ge(r, t, e, i2) {
  return { name: r, prefix: t, encoder: { name: r, prefix: t, encode: e }, decoder: { decode: i2 } };
}
const Ee$1 = ge("utf8", "u", (r) => "u" + new TextDecoder("utf8").decode(r), (r) => new TextEncoder().encode(r.substring(1))), L$2 = ge("ascii", "a", (r) => {
  let t = "a";
  for (let e = 0; e < r.length; e++)
    t += String.fromCharCode(r[e]);
  return t;
}, (r) => {
  r = r.substring(1);
  const t = ot(r.length);
  for (let e = 0; e < r.length; e++)
    t[e] = r.charCodeAt(e);
  return t;
}), be = { utf8: Ee$1, "utf-8": Ee$1, hex: fe.base16, latin1: L$2, ascii: L$2, binary: L$2, ...fe };
function Fr(r, t = "utf8") {
  const e = be[t];
  if (!e)
    throw new Error(`Unsupported encoding "${t}"`);
  return (t === "utf8" || t === "utf-8") && globalThis.Buffer != null && globalThis.Buffer.from != null ? globalThis.Buffer.from(r, "utf8") : e.decoder.decode(`${e.prefix}${r}`);
}
function Tr(r, t = "utf8") {
  const e = be[t];
  if (!e)
    throw new Error(`Unsupported encoding "${t}"`);
  return (t === "utf8" || t === "utf-8") && globalThis.Buffer != null && globalThis.Buffer.from != null ? globalThis.Buffer.from(r.buffer, r.byteOffset, r.byteLength).toString("utf8") : e.encoder.encode(r).substring(1);
}
const ye = "base16", we = "utf8";
function K$1(r) {
  const t = sha256.hash(Fr(r, we));
  return Tr(t, ye);
}
var Or = Object.defineProperty, Sr = Object.defineProperties, Pr = Object.getOwnPropertyDescriptors, Ce = Object.getOwnPropertySymbols, Nr = Object.prototype.hasOwnProperty, $r = Object.prototype.propertyIsEnumerable, me = (r, t, e) => t in r ? Or(r, t, { enumerable: true, configurable: true, writable: true, value: e }) : r[t] = e, I = (r, t) => {
  for (var e in t || (t = {}))
    Nr.call(t, e) && me(r, e, t[e]);
  if (Ce)
    for (var e of Ce(t))
      $r.call(t, e) && me(r, e, t[e]);
  return r;
}, V$1 = (r, t) => Sr(r, Pr(t));
class Br extends G {
  constructor(t) {
    super(t), this.initialized = false, this.name = "authEngine", this.init = () => {
      this.initialized || (this.registerRelayerEvents(), this.registerPairingEvents(), this.client.core.pairing.register({ methods: Object.keys(R$1) }), this.initialized = true);
    }, this.request = async (e, i2) => {
      if (this.isInitialized(), !nt(e))
        throw new Error("Invalid request");
      if (i2 != null && i2.topic)
        return await this.requestOnKnownPairing(i2.topic, e);
      const { chainId: n2, statement: s, aud: o2, domain: u2, nonce: a3, type: c2, exp: h4, nbf: f3 } = e, { topic: p3, uri: A2 } = await this.client.core.pairing.create();
      this.client.logger.info({ message: "Generated new pairing", pairing: { topic: p3, uri: A2 } });
      const D2 = await this.client.core.crypto.generateKeyPair(), l2 = bu(D2);
      await this.client.authKeys.set(x$1, { responseTopic: l2, publicKey: D2 }), await this.client.pairingTopics.set(l2, { topic: l2, pairingTopic: p3 }), await this.client.core.relayer.subscribe(l2), this.client.logger.info(`sending request to new pairing topic: ${p3}`);
      const m3 = await this.sendRequest(p3, "wc_authRequest", { payloadParams: { type: c2 ?? "eip4361", chainId: n2, statement: s, aud: o2, domain: u2, version: "1", nonce: a3, iat: (/* @__PURE__ */ new Date()).toISOString(), exp: h4, nbf: f3 }, requester: { publicKey: D2, metadata: this.client.metadata } }, {}, e.expiry);
      return this.client.logger.info(`sent request to new pairing topic: ${p3}`), { uri: A2, id: m3 };
    }, this.respond = async (e, i2) => {
      if (this.isInitialized(), !st(e, this.client.requests))
        throw new Error("Invalid response");
      const n2 = te$1(this.client.requests, e.id);
      if (!n2)
        throw new Error(`Could not find pending auth request with id ${e.id}`);
      const s = n2.requester.publicKey, o2 = await this.client.core.crypto.generateKeyPair(), u2 = bu(s), a3 = { type: lr$2, receiverPublicKey: s, senderPublicKey: o2 };
      if ("error" in e) {
        await this.sendError(n2.id, u2, e, a3);
        return;
      }
      const c2 = { h: { t: "eip4361" }, p: V$1(I({}, n2.cacaoPayload), { iss: i2 }), s: e.signature };
      await this.sendResult(n2.id, u2, c2, a3), await this.client.core.pairing.activate({ topic: n2.pairingTopic }), await this.client.requests.update(n2.id, I({}, c2));
    }, this.getPendingRequests = () => ee$1(this.client.requests), this.formatMessage = (e, i2) => {
      this.client.logger.debug(`formatMessage, cacao is: ${JSON.stringify(e)}`);
      const n2 = `${e.domain} wants you to sign in with your Ethereum account:`, s = W(i2), o2 = e.statement, u2 = `URI: ${e.aud}`, a3 = `Version: ${e.version}`, c2 = `Chain ID: ${Ze(i2)}`, h4 = `Nonce: ${e.nonce}`, f3 = `Issued At: ${e.iat}`, p3 = e.exp ? `Expiry: ${e.exp}` : void 0, A2 = e.resources && e.resources.length > 0 ? `Resources:
${e.resources.map((D2) => `- ${D2}`).join(`
`)}` : void 0;
      return [n2, s, "", o2, "", u2, a3, c2, h4, f3, p3, A2].filter((D2) => D2 != null).join(`
`);
    }, this.setExpiry = async (e, i2) => {
      this.client.core.pairing.pairings.keys.includes(e) && await this.client.core.pairing.updateExpiry({ topic: e, expiry: i2 }), this.client.core.expirer.set(e, i2);
    }, this.sendRequest = async (e, i2, n2, s, o2) => {
      const u2 = formatJsonRpcRequest(i2, n2), a3 = await this.client.core.crypto.encode(e, u2, s), c2 = R$1[i2].req;
      if (o2 && (c2.ttl = o2), this.client.core.history.set(e, u2), pr$2()) {
        const h4 = K$1(JSON.stringify(u2));
        this.client.core.verify.register({ attestationId: h4 });
      }
      return await this.client.core.relayer.publish(e, a3, V$1(I({}, c2), { internal: { throwOnFailedPublish: true } })), u2.id;
    }, this.sendResult = async (e, i2, n2, s) => {
      const o2 = formatJsonRpcResult(e, n2), u2 = await this.client.core.crypto.encode(i2, o2, s), a3 = await this.client.core.history.get(i2, e), c2 = R$1[a3.request.method].res;
      return await this.client.core.relayer.publish(i2, u2, V$1(I({}, c2), { internal: { throwOnFailedPublish: true } })), await this.client.core.history.resolve(o2), o2.id;
    }, this.sendError = async (e, i2, n2, s) => {
      const o2 = formatJsonRpcError(e, n2.error), u2 = await this.client.core.crypto.encode(i2, o2, s), a3 = await this.client.core.history.get(i2, e), c2 = R$1[a3.request.method].res;
      return await this.client.core.relayer.publish(i2, u2, c2), await this.client.core.history.resolve(o2), o2.id;
    }, this.requestOnKnownPairing = async (e, i2) => {
      const n2 = this.client.core.pairing.pairings.getAll({ active: true }).find((A2) => A2.topic === e);
      if (!n2)
        throw new Error(`Could not find pairing for provided topic ${e}`);
      const { publicKey: s } = this.client.authKeys.get(x$1), { chainId: o2, statement: u2, aud: a3, domain: c2, nonce: h4, type: f3 } = i2, p3 = await this.sendRequest(n2.topic, "wc_authRequest", { payloadParams: { type: f3 ?? "eip4361", chainId: o2, statement: u2, aud: a3, domain: c2, version: "1", nonce: h4, iat: (/* @__PURE__ */ new Date()).toISOString() }, requester: { publicKey: s, metadata: this.client.metadata } }, {}, i2.expiry);
      return this.client.logger.info(`sent request to known pairing topic: ${n2.topic}`), { id: p3 };
    }, this.onPairingCreated = (e) => {
      const i2 = this.getPendingRequests();
      if (i2) {
        const n2 = Object.values(i2).find((s) => s.pairingTopic === e.topic);
        n2 && this.handleAuthRequest(n2);
      }
    }, this.onRelayEventRequest = (e) => {
      const { topic: i2, payload: n2 } = e, s = n2.method;
      switch (s) {
        case "wc_authRequest":
          return this.onAuthRequest(i2, n2);
        default:
          return this.client.logger.info(`Unsupported request method ${s}`);
      }
    }, this.onRelayEventResponse = async (e) => {
      const { topic: i2, payload: n2 } = e, s = (await this.client.core.history.get(i2, n2.id)).request.method;
      switch (s) {
        case "wc_authRequest":
          return this.onAuthResponse(i2, n2);
        default:
          return this.client.logger.info(`Unsupported response method ${s}`);
      }
    }, this.onAuthRequest = async (e, i2) => {
      const { requester: n2, payloadParams: s } = i2.params;
      this.client.logger.info({ type: "onAuthRequest", topic: e, payload: i2 });
      const o2 = K$1(JSON.stringify(i2)), u2 = await this.getVerifyContext(o2, this.client.metadata), a3 = { requester: n2, pairingTopic: e, id: i2.id, cacaoPayload: s, verifyContext: u2 };
      await this.client.requests.set(i2.id, a3), this.handleAuthRequest(a3);
    }, this.handleAuthRequest = async (e) => {
      const { id: i2, pairingTopic: n2, requester: s, cacaoPayload: o2, verifyContext: u2 } = e;
      try {
        this.client.emit("auth_request", { id: i2, topic: n2, params: { requester: s, cacaoPayload: o2 }, verifyContext: u2 });
      } catch (a3) {
        await this.sendError(e.id, e.pairingTopic, a3), this.client.logger.error(a3);
      }
    }, this.onAuthResponse = async (e, i2) => {
      const { id: n2 } = i2;
      if (this.client.logger.info({ type: "onAuthResponse", topic: e, response: i2 }), isJsonRpcResult(i2)) {
        const { pairingTopic: s } = this.client.pairingTopics.get(e);
        await this.client.core.pairing.activate({ topic: s });
        const { s: o2, p: u2 } = i2.result;
        await this.client.requests.set(n2, I({ id: n2, pairingTopic: s }, i2.result));
        const a3 = this.formatMessage(u2, u2.iss);
        this.client.logger.debug(`reconstructed message:
`, JSON.stringify(a3)), this.client.logger.debug("payload.iss:", u2.iss), this.client.logger.debug("signature:", o2);
        const c2 = W(u2.iss), h4 = We$1(u2.iss);
        if (!c2)
          throw new Error("Could not derive address from `payload.iss`");
        if (!h4)
          throw new Error("Could not derive chainId from `payload.iss`");
        this.client.logger.debug("walletAddress extracted from `payload.iss`:", c2), await et(c2, a3, o2, h4, this.client.projectId) ? this.client.emit("auth_response", { id: n2, topic: e, params: i2 }) : this.client.emit("auth_response", { id: n2, topic: e, params: { message: "Invalid signature", code: -1 } });
      } else
        isJsonRpcError(i2) && this.client.emit("auth_response", { id: n2, topic: e, params: i2 });
    }, this.getVerifyContext = async (e, i2) => {
      const n2 = { verified: { verifyUrl: i2.verifyUrl || "", validation: "UNKNOWN", origin: i2.url || "" } };
      try {
        const s = await this.client.core.verify.resolve({ attestationId: e, verifyUrl: i2.verifyUrl });
        s && (n2.verified.origin = s.origin, n2.verified.isScam = s.isScam, n2.verified.validation = origin === new URL(i2.url).origin ? "VALID" : "INVALID");
      } catch (s) {
        this.client.logger.error(s);
      }
      return this.client.logger.info(`Verify context: ${JSON.stringify(n2)}`), n2;
    };
  }
  isInitialized() {
    if (!this.initialized) {
      const { message: t } = xe("NOT_INITIALIZED", this.name);
      throw new Error(t);
    }
  }
  registerRelayerEvents() {
    this.client.core.relayer.on(v$1.message, async (t) => {
      const { topic: e, message: i2 } = t, { responseTopic: n2, publicKey: s } = this.client.authKeys.keys.includes(x$1) ? this.client.authKeys.get(x$1) : { responseTopic: void 0, publicKey: void 0 };
      if (n2 && e !== n2) {
        this.client.logger.debug("[Auth] Ignoring message from unknown topic", e);
        return;
      }
      const o2 = await this.client.core.crypto.decode(e, i2, { receiverPublicKey: s });
      isJsonRpcRequest(o2) ? (this.client.core.history.set(e, o2), this.onRelayEventRequest({ topic: e, payload: o2 })) : isJsonRpcResponse(o2) && (await this.client.core.history.resolve(o2), this.onRelayEventResponse({ topic: e, payload: o2 }));
    });
  }
  registerPairingEvents() {
    this.client.core.pairing.events.on(V$2.create, (t) => this.onPairingCreated(t));
  }
}
let S$1 = class S extends H {
  constructor(t) {
    super(t), this.protocol = $, this.version = Q, this.name = B$1, this.events = new eventsExports.EventEmitter(), this.emit = (i2, n2) => this.events.emit(i2, n2), this.on = (i2, n2) => this.events.on(i2, n2), this.once = (i2, n2) => this.events.once(i2, n2), this.off = (i2, n2) => this.events.off(i2, n2), this.removeListener = (i2, n2) => this.events.removeListener(i2, n2), this.request = async (i2, n2) => {
      try {
        return await this.engine.request(i2, n2);
      } catch (s) {
        throw this.logger.error(s.message), s;
      }
    }, this.respond = async (i2, n2) => {
      try {
        return await this.engine.respond(i2, n2);
      } catch (s) {
        throw this.logger.error(s.message), s;
      }
    }, this.getPendingRequests = () => {
      try {
        return this.engine.getPendingRequests();
      } catch (i2) {
        throw this.logger.error(i2.message), i2;
      }
    }, this.formatMessage = (i2, n2) => {
      try {
        return this.engine.formatMessage(i2, n2);
      } catch (s) {
        throw this.logger.error(s.message), s;
      }
    };
    const e = typeof t.logger < "u" && typeof t.logger != "string" ? t.logger : nt$2(k$2({ level: t.logger || "error" }));
    this.name = (t == null ? void 0 : t.name) || B$1, this.metadata = t.metadata, this.projectId = t.projectId, this.core = t.core || new Br$1(t), this.logger = E$2(e, this.name), this.authKeys = new Vt$1(this.core, this.logger, "authKeys", F$2, () => x$1), this.pairingTopics = new Vt$1(this.core, this.logger, "pairingTopics", F$2), this.requests = new Vt$1(this.core, this.logger, "requests", F$2, (i2) => i2.id), this.engine = new Br(this);
  }
  static async init(t) {
    const e = new S(t);
    return await e.initialize(), e;
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
const zr = S$1;
const Se = "wc", Ee = 2, _e = "client", se$1 = `${Se}@${Ee}:${_e}:`, ie$1 = { name: _e, logger: "error", controller: false, relayUrl: "wss://relay.walletconnect.com" }, Re = "WALLETCONNECT_DEEPLINK_CHOICE", Ke = "proposal", Ue = "Proposal expired", Ge = "session", L$1 = cjs$3.SEVEN_DAYS, ke = "engine", q$1 = { wc_sessionPropose: { req: { ttl: cjs$3.FIVE_MINUTES, prompt: true, tag: 1100 }, res: { ttl: cjs$3.FIVE_MINUTES, prompt: false, tag: 1101 } }, wc_sessionSettle: { req: { ttl: cjs$3.FIVE_MINUTES, prompt: false, tag: 1102 }, res: { ttl: cjs$3.FIVE_MINUTES, prompt: false, tag: 1103 } }, wc_sessionUpdate: { req: { ttl: cjs$3.ONE_DAY, prompt: false, tag: 1104 }, res: { ttl: cjs$3.ONE_DAY, prompt: false, tag: 1105 } }, wc_sessionExtend: { req: { ttl: cjs$3.ONE_DAY, prompt: false, tag: 1106 }, res: { ttl: cjs$3.ONE_DAY, prompt: false, tag: 1107 } }, wc_sessionRequest: { req: { ttl: cjs$3.FIVE_MINUTES, prompt: true, tag: 1108 }, res: { ttl: cjs$3.FIVE_MINUTES, prompt: false, tag: 1109 } }, wc_sessionEvent: { req: { ttl: cjs$3.FIVE_MINUTES, prompt: true, tag: 1110 }, res: { ttl: cjs$3.FIVE_MINUTES, prompt: false, tag: 1111 } }, wc_sessionDelete: { req: { ttl: cjs$3.ONE_DAY, prompt: false, tag: 1112 }, res: { ttl: cjs$3.ONE_DAY, prompt: false, tag: 1113 } }, wc_sessionPing: { req: { ttl: cjs$3.ONE_DAY, prompt: false, tag: 1114 }, res: { ttl: cjs$3.ONE_DAY, prompt: false, tag: 1115 } }, wc_sessionAuthenticate: { req: { ttl: cjs$3.ONE_HOUR, prompt: true, tag: 1116 }, res: { ttl: cjs$3.ONE_HOUR, prompt: false, tag: 1117 } } }, re = { min: cjs$3.FIVE_MINUTES, max: cjs$3.SEVEN_DAYS }, A = { idle: "IDLE", active: "ACTIVE" }, Fe = "request", je = ["wc_sessionPropose", "wc_sessionRequest", "wc_authRequest"], Qe = "wc", ze = "auth", He = "authKeys", Ye = "pairingTopics", Xe = "requests", X = `${Qe}@${1.5}:${ze}:`, J$1 = `${X}:PUB_KEY`;
var Ht2 = Object.defineProperty, Yt2 = Object.defineProperties, Xt = Object.getOwnPropertyDescriptors, Je = Object.getOwnPropertySymbols, Jt = Object.prototype.hasOwnProperty, Bt = Object.prototype.propertyIsEnumerable, Be = (S3, n2, t) => n2 in S3 ? Ht2(S3, n2, { enumerable: true, configurable: true, writable: true, value: t }) : S3[n2] = t, m2 = (S3, n2) => {
  for (var t in n2 || (n2 = {}))
    Jt.call(n2, t) && Be(S3, t, n2[t]);
  if (Je)
    for (var t of Je(n2))
      Bt.call(n2, t) && Be(S3, t, n2[t]);
  return S3;
}, F$1 = (S3, n2) => Yt2(S3, Xt(n2));
class Wt extends w$2 {
  constructor(n2) {
    super(n2), this.name = ke, this.events = new At$2(), this.initialized = false, this.requestQueue = { state: A.idle, queue: [] }, this.sessionRequestQueue = { state: A.idle, queue: [] }, this.requestQueueDelay = cjs$3.ONE_SECOND, this.expectedPairingMethodMap = /* @__PURE__ */ new Map(), this.recentlyDeletedMap = /* @__PURE__ */ new Map(), this.recentlyDeletedLimit = 200, this.init = async () => {
      this.initialized || (await this.cleanup(), this.registerRelayerEvents(), this.registerExpirerEvents(), this.registerPairingEvents(), this.client.core.pairing.register({ methods: Object.keys(q$1) }), this.initialized = true, setTimeout(() => {
        this.sessionRequestQueue.queue = this.getPendingSessionRequests(), this.processSessionRequestQueue();
      }, cjs$3.toMiliseconds(this.requestQueueDelay)));
    }, this.connect = async (t) => {
      await this.isInitialized();
      const e = F$1(m2({}, t), { requiredNamespaces: t.requiredNamespaces || {}, optionalNamespaces: t.optionalNamespaces || {} });
      await this.isValidConnect(e);
      const { pairingTopic: s, requiredNamespaces: i2, optionalNamespaces: r, sessionProperties: o2, relays: a3 } = e;
      let c2 = s, d4, p3 = false;
      try {
        c2 && (p3 = this.client.core.pairing.pairings.get(c2).active);
      } catch (f3) {
        throw this.client.logger.error(`connect() -> pairing.get(${c2}) failed`), f3;
      }
      if (!c2 || !p3) {
        const { topic: f3, uri: v3 } = await this.client.core.pairing.create();
        c2 = f3, d4 = v3;
      }
      if (!c2) {
        const { message: f3 } = xe("NO_MATCHING_KEY", `connect() pairing topic: ${c2}`);
        throw new Error(f3);
      }
      const g3 = await this.client.core.crypto.generateKeyPair(), h4 = q$1.wc_sessionPropose.req.ttl || cjs$3.FIVE_MINUTES, y3 = d0(h4), w3 = m2({ requiredNamespaces: i2, optionalNamespaces: r, relays: a3 ?? [{ protocol: lt$1 }], proposer: { publicKey: g3, metadata: this.client.metadata }, expiryTimestamp: y3 }, o2 && { sessionProperties: o2 }), { reject: I2, resolve: D2, done: E3 } = a0(h4, Ue);
      this.events.once(v0("session_connect"), async ({ error: f3, session: v3 }) => {
        if (f3)
          I2(f3);
        else if (v3) {
          v3.self.publicKey = g3;
          const j2 = F$1(m2({}, v3), { requiredNamespaces: w3.requiredNamespaces, optionalNamespaces: w3.optionalNamespaces });
          await this.client.session.set(v3.topic, j2), await this.setExpiry(v3.topic, v3.expiry), c2 && await this.client.core.pairing.updateMetadata({ topic: c2, metadata: v3.peer.metadata }), D2(j2);
        }
      });
      const P2 = await this.sendRequest({ topic: c2, method: "wc_sessionPropose", params: w3, throwOnFailedPublish: true });
      return await this.setProposal(P2, m2({ id: P2 }, w3)), { uri: d4, approval: E3 };
    }, this.pair = async (t) => {
      await this.isInitialized();
      try {
        return await this.client.core.pairing.pair(t);
      } catch (e) {
        throw this.client.logger.error("pair() failed"), e;
      }
    }, this.approve = async (t) => {
      await this.isInitialized();
      try {
        await this.isValidApprove(t);
      } catch (E3) {
        throw this.client.logger.error("approve() -> isValidApprove() failed"), E3;
      }
      const { id: e, relayProtocol: s, namespaces: i2, sessionProperties: r, sessionConfig: o2 } = t;
      let a3;
      try {
        a3 = this.client.proposal.get(e);
      } catch (E3) {
        throw this.client.logger.error(`approve() -> proposal.get(${e}) failed`), E3;
      }
      let { pairingTopic: c2, proposer: d4, requiredNamespaces: p3, optionalNamespaces: g3 } = a3;
      c2 = c2 || "";
      const h4 = await this.client.core.crypto.generateKeyPair(), y3 = d4.publicKey, w3 = await this.client.core.crypto.generateSharedKey(h4, y3), I2 = m2(m2({ relay: { protocol: s ?? "irn" }, namespaces: i2, pairingTopic: c2, controller: { publicKey: h4, metadata: this.client.metadata }, expiry: d0(L$1) }, r && { sessionProperties: r }), o2 && { sessionConfig: o2 });
      await this.client.core.relayer.subscribe(w3);
      const D2 = F$1(m2({}, I2), { topic: w3, requiredNamespaces: p3, optionalNamespaces: g3, pairingTopic: c2, acknowledged: false, self: I2.controller, peer: { publicKey: d4.publicKey, metadata: d4.metadata }, controller: h4 });
      await this.client.session.set(w3, D2);
      try {
        await this.sendResult({ id: e, topic: c2, result: { relay: { protocol: s ?? "irn" }, responderPublicKey: h4 }, throwOnFailedPublish: true }), await this.sendRequest({ topic: w3, method: "wc_sessionSettle", params: I2, throwOnFailedPublish: true });
      } catch (E3) {
        throw this.client.logger.error(E3), this.client.session.delete(w3, tr$2("USER_DISCONNECTED")), await this.client.core.relayer.unsubscribe(w3), E3;
      }
      return await this.client.core.pairing.updateMetadata({ topic: c2, metadata: d4.metadata }), await this.client.proposal.delete(e, tr$2("USER_DISCONNECTED")), await this.client.core.pairing.activate({ topic: c2 }), await this.setExpiry(w3, d0(L$1)), { topic: w3, acknowledged: () => new Promise((E3) => setTimeout(() => E3(this.client.session.get(w3)), 500)) };
    }, this.reject = async (t) => {
      await this.isInitialized();
      try {
        await this.isValidReject(t);
      } catch (r) {
        throw this.client.logger.error("reject() -> isValidReject() failed"), r;
      }
      const { id: e, reason: s } = t;
      let i2;
      try {
        i2 = this.client.proposal.get(e).pairingTopic;
      } catch (r) {
        throw this.client.logger.error(`reject() -> proposal.get(${e}) failed`), r;
      }
      i2 && (await this.sendError({ id: e, topic: i2, error: s }), await this.client.proposal.delete(e, tr$2("USER_DISCONNECTED")));
    }, this.update = async (t) => {
      await this.isInitialized();
      try {
        await this.isValidUpdate(t);
      } catch (p3) {
        throw this.client.logger.error("update() -> isValidUpdate() failed"), p3;
      }
      const { topic: e, namespaces: s } = t, { done: i2, resolve: r, reject: o2 } = a0(), a3 = payloadId(), c2 = getBigIntRpcId().toString(), d4 = this.client.session.get(e).namespaces;
      return this.events.once(v0("session_update", a3), ({ error: p3 }) => {
        p3 ? o2(p3) : r();
      }), await this.client.session.update(e, { namespaces: s }), this.sendRequest({ topic: e, method: "wc_sessionUpdate", params: { namespaces: s }, throwOnFailedPublish: true, clientRpcId: a3, relayRpcId: c2 }).catch((p3) => {
        this.client.logger.error(p3), this.client.session.update(e, { namespaces: d4 }), o2(p3);
      }), { acknowledged: i2 };
    }, this.extend = async (t) => {
      await this.isInitialized();
      try {
        await this.isValidExtend(t);
      } catch (a3) {
        throw this.client.logger.error("extend() -> isValidExtend() failed"), a3;
      }
      const { topic: e } = t, s = payloadId(), { done: i2, resolve: r, reject: o2 } = a0();
      return this.events.once(v0("session_extend", s), ({ error: a3 }) => {
        a3 ? o2(a3) : r();
      }), await this.setExpiry(e, d0(L$1)), this.sendRequest({ topic: e, method: "wc_sessionExtend", params: {}, clientRpcId: s, throwOnFailedPublish: true }).catch((a3) => {
        o2(a3);
      }), { acknowledged: i2 };
    }, this.request = async (t) => {
      await this.isInitialized();
      try {
        await this.isValidRequest(t);
      } catch (h4) {
        throw this.client.logger.error("request() -> isValidRequest() failed"), h4;
      }
      const { chainId: e, request: s, topic: i2, expiry: r = q$1.wc_sessionRequest.req.ttl } = t, o2 = this.client.session.get(i2), a3 = payloadId(), c2 = getBigIntRpcId().toString(), { done: d4, resolve: p3, reject: g3 } = a0(r, "Request expired. Please try again.");
      return this.events.once(v0("session_request", a3), ({ error: h4, result: y3 }) => {
        h4 ? g3(h4) : p3(y3);
      }), await Promise.all([new Promise(async (h4) => {
        await this.sendRequest({ clientRpcId: a3, relayRpcId: c2, topic: i2, method: "wc_sessionRequest", params: { request: F$1(m2({}, s), { expiryTimestamp: d0(r) }), chainId: e }, expiry: r, throwOnFailedPublish: true }).catch((y3) => g3(y3)), this.client.events.emit("session_request_sent", { topic: i2, request: s, chainId: e, id: a3 }), h4();
      }), new Promise(async (h4) => {
        var y3;
        if (!((y3 = o2.sessionConfig) != null && y3.disableDeepLink)) {
          const w3 = await g0(this.client.core.storage, Re);
          m0({ id: a3, topic: i2, wcDeepLink: w3 });
        }
        h4();
      }), d4()]).then((h4) => h4[2]);
    }, this.respond = async (t) => {
      await this.isInitialized(), await this.isValidRespond(t);
      const { topic: e, response: s } = t, { id: i2 } = s;
      isJsonRpcResult(s) ? await this.sendResult({ id: i2, topic: e, result: s.result, throwOnFailedPublish: true }) : isJsonRpcError(s) && await this.sendError({ id: i2, topic: e, error: s.error }), this.cleanupAfterResponse(t);
    }, this.ping = async (t) => {
      await this.isInitialized();
      try {
        await this.isValidPing(t);
      } catch (s) {
        throw this.client.logger.error("ping() -> isValidPing() failed"), s;
      }
      const { topic: e } = t;
      if (this.client.session.keys.includes(e)) {
        const s = payloadId(), i2 = getBigIntRpcId().toString(), { done: r, resolve: o2, reject: a3 } = a0();
        this.events.once(v0("session_ping", s), ({ error: c2 }) => {
          c2 ? a3(c2) : o2();
        }), await Promise.all([this.sendRequest({ topic: e, method: "wc_sessionPing", params: {}, throwOnFailedPublish: true, clientRpcId: s, relayRpcId: i2 }), r()]);
      } else
        this.client.core.pairing.pairings.keys.includes(e) && await this.client.core.pairing.ping({ topic: e });
    }, this.emit = async (t) => {
      await this.isInitialized(), await this.isValidEmit(t);
      const { topic: e, event: s, chainId: i2 } = t, r = getBigIntRpcId().toString();
      await this.sendRequest({ topic: e, method: "wc_sessionEvent", params: { event: s, chainId: i2 }, throwOnFailedPublish: true, relayRpcId: r });
    }, this.disconnect = async (t) => {
      await this.isInitialized(), await this.isValidDisconnect(t);
      const { topic: e } = t;
      if (this.client.session.keys.includes(e))
        await this.sendRequest({ topic: e, method: "wc_sessionDelete", params: tr$2("USER_DISCONNECTED"), throwOnFailedPublish: true }), await this.deleteSession({ topic: e, emitEvent: false });
      else if (this.client.core.pairing.pairings.keys.includes(e))
        await this.client.core.pairing.disconnect({ topic: e });
      else {
        const { message: s } = xe("MISMATCHED_TOPIC", `Session or pairing topic not found: ${e}`);
        throw new Error(s);
      }
    }, this.find = (t) => (this.isInitialized(), this.client.session.getAll().filter((e) => Qu(e, t))), this.getPendingSessionRequests = () => this.client.pendingRequest.getAll(), this.authenticate = async (t) => {
      this.isInitialized(), this.isValidAuthenticate(t);
      const { chains: e, statement: s = "", uri: i2, domain: r, nonce: o2, type: a3, exp: c2, nbf: d4, methods: p3 = [] } = t, g3 = [...t.resources || []], { topic: h4, uri: y3 } = await this.client.core.pairing.create({ methods: ["wc_sessionAuthenticate"] });
      this.client.logger.info({ message: "Generated new pairing", pairing: { topic: h4, uri: y3 } });
      const w3 = await this.client.core.crypto.generateKeyPair(), I2 = bu(w3);
      if (await Promise.all([this.client.auth.authKeys.set(J$1, { responseTopic: I2, publicKey: w3 }), this.client.auth.pairingTopics.set(I2, { topic: I2, pairingTopic: h4 })]), await this.client.core.relayer.subscribe(I2), this.client.logger.info(`sending request to new pairing topic: ${h4}`), p3.length > 0) {
        const { namespace: O3 } = dn(e[0]);
        let _3 = cu(O3, "request", p3);
        Qr(g3) && (_3 = lu(_3, g3.pop())), g3.push(_3);
      }
      const D2 = d0(q$1.wc_sessionPropose.req.ttl), E3 = { authPayload: { type: a3 ?? "caip122", chains: e, statement: s, aud: i2, domain: r, version: "1", nonce: o2, iat: (/* @__PURE__ */ new Date()).toISOString(), exp: c2, nbf: d4, resources: g3 }, requester: { publicKey: w3, metadata: this.client.metadata }, expiryTimestamp: D2 }, P2 = { eip155: { chains: e, methods: [.../* @__PURE__ */ new Set(["personal_sign", ...p3])], events: ["chainChanged", "accountsChanged"] } }, f3 = { requiredNamespaces: {}, optionalNamespaces: P2, relays: [{ protocol: "irn" }], proposer: { publicKey: w3, metadata: this.client.metadata }, expiryTimestamp: D2 }, { done: v3, resolve: j2, reject: oe2 } = a0(q$1.wc_sessionAuthenticate.req.ttl, "Request expired"), B3 = async ({ error: O3, session: _3 }) => {
        if (this.events.off(v0("session_request", M2), ae2), O3)
          oe2(O3);
        else if (_3) {
          _3.self.publicKey = w3, await this.client.session.set(_3.topic, _3), await this.setExpiry(_3.topic, _3.expiry), h4 && await this.client.core.pairing.updateMetadata({ topic: h4, metadata: _3.peer.metadata });
          const Q2 = this.client.session.get(_3.topic);
          j2({ session: Q2 });
        }
      }, ae2 = async (O3) => {
        if (O3.error) {
          const z2 = tr$2("WC_METHOD_UNSUPPORTED", "wc_sessionAuthenticate");
          return O3.error.code === z2.code ? void 0 : (this.events.off(v0("session_connect"), B3), oe2(O3.error.message));
        }
        this.events.off(v0("session_connect"), B3);
        const { cacaos: _3, responder: Q2 } = O3.result, le2 = [], Ie = [];
        for (const z2 of _3) {
          await ou({ cacao: z2, projectId: this.client.core.projectId }) || (this.client.logger.error(z2, "Signature verification failed"), oe2(tr$2("SESSION_SETTLEMENT_FAILED", "Signature verification failed")));
          const { p: he2 } = z2, pe2 = Qr(he2.resources), fe2 = [fu(he2.iss)], Ze2 = Li(he2.iss);
          if (pe2) {
            const de2 = du(pe2), et2 = pu(pe2);
            le2.push(...de2), fe2.push(...et2);
          }
          for (const de2 of fe2)
            Ie.push(`${de2}:${Ze2}`);
        }
        const W2 = await this.client.core.crypto.generateSharedKey(w3, Q2.publicKey);
        let Z2;
        le2.length > 0 && (Z2 = { topic: W2, acknowledged: true, self: { publicKey: w3, metadata: this.client.metadata }, peer: Q2, controller: Q2.publicKey, expiry: d0(L$1), requiredNamespaces: {}, optionalNamespaces: {}, relay: { protocol: "irn" }, pairingTopic: h4, namespaces: ju([...new Set(le2)], [...new Set(Ie)]) }, await this.client.core.relayer.subscribe(W2), await this.client.session.set(W2, Z2), Z2 = this.client.session.get(W2)), j2({ auths: _3, session: Z2 });
      }, M2 = payloadId(), ce2 = payloadId();
      this.events.once(v0("session_connect"), B3), this.events.once(v0("session_request", M2), ae2);
      try {
        await Promise.all([this.sendRequest({ topic: h4, method: "wc_sessionAuthenticate", params: E3, expiry: t.expiry, throwOnFailedPublish: true, clientRpcId: M2 }), this.sendRequest({ topic: h4, method: "wc_sessionPropose", params: f3, expiry: q$1.wc_sessionPropose.req.ttl, throwOnFailedPublish: true, clientRpcId: ce2 })]);
      } catch (O3) {
        throw this.events.off(v0("session_connect"), B3), this.events.off(v0("session_request", M2), ae2), O3;
      }
      return await this.setProposal(ce2, m2({ id: ce2 }, f3)), await this.client.auth.requests.set(M2, { authPayload: E3.authPayload, requester: E3.requester, expiryTimestamp: D2, id: M2, pairingTopic: h4, verifyContext: {} }), { uri: y3, response: v3 };
    }, this.approveSessionAuthenticate = async (t) => {
      this.isInitialized();
      const { id: e, auths: s } = t, i2 = this.getPendingAuthRequest(e);
      if (!i2)
        throw new Error(`Could not find pending auth request with id ${e}`);
      const r = i2.requester.publicKey, o2 = await this.client.core.crypto.generateKeyPair(), a3 = bu(r), c2 = { type: lr$2, receiverPublicKey: r, senderPublicKey: o2 }, d4 = [], p3 = [];
      for (const y3 of s) {
        if (!await ou({ cacao: y3, projectId: this.client.core.projectId })) {
          const P2 = tr$2("SESSION_SETTLEMENT_FAILED", "Signature verification failed");
          throw await this.sendError({ id: e, topic: a3, error: P2, encodeOpts: c2 }), new Error(P2.message);
        }
        const { p: w3 } = y3, I2 = Qr(w3.resources), D2 = [fu(w3.iss)], E3 = Li(w3.iss);
        if (I2) {
          const P2 = du(I2), f3 = pu(I2);
          d4.push(...P2), D2.push(...f3);
        }
        for (const P2 of D2)
          p3.push(`${P2}:${E3}`);
      }
      const g3 = await this.client.core.crypto.generateSharedKey(o2, r);
      let h4;
      return (d4 == null ? void 0 : d4.length) > 0 && (h4 = { topic: g3, acknowledged: true, self: { publicKey: o2, metadata: this.client.metadata }, peer: { publicKey: r, metadata: i2.requester.metadata }, controller: r, expiry: d0(L$1), authentication: s, requiredNamespaces: {}, optionalNamespaces: {}, relay: { protocol: "irn" }, pairingTopic: "", namespaces: ju([...new Set(d4)], [...new Set(p3)]) }, await this.client.core.relayer.subscribe(g3), await this.client.session.set(g3, h4)), await this.sendResult({ topic: a3, id: e, result: { cacaos: s, responder: { publicKey: o2, metadata: this.client.metadata } }, encodeOpts: c2, throwOnFailedPublish: true }), await this.client.auth.requests.delete(e, { message: "fullfilled", code: 0 }), await this.client.core.pairing.activate({ topic: i2.pairingTopic }), { session: h4 };
    }, this.rejectSessionAuthenticate = async (t) => {
      await this.isInitialized();
      const { id: e, reason: s } = t, i2 = this.getPendingAuthRequest(e);
      if (!i2)
        throw new Error(`Could not find pending auth request with id ${e}`);
      const r = i2.requester.publicKey, o2 = await this.client.core.crypto.generateKeyPair(), a3 = bu(r), c2 = { type: lr$2, receiverPublicKey: r, senderPublicKey: o2 };
      await this.sendError({ id: e, topic: a3, error: s, encodeOpts: c2 }), await this.client.auth.requests.delete(e, { message: "rejected", code: 0 }), await this.client.proposal.delete(e, tr$2("USER_DISCONNECTED"));
    }, this.formatAuthMessage = (t) => {
      this.isInitialized();
      const { request: e, iss: s } = t;
      return zf(e, s);
    }, this.cleanupDuplicatePairings = async (t) => {
      if (t.pairingTopic)
        try {
          const e = this.client.core.pairing.pairings.get(t.pairingTopic), s = this.client.core.pairing.pairings.getAll().filter((i2) => {
            var r, o2;
            return ((r = i2.peerMetadata) == null ? void 0 : r.url) && ((o2 = i2.peerMetadata) == null ? void 0 : o2.url) === t.peer.metadata.url && i2.topic && i2.topic !== e.topic;
          });
          if (s.length === 0)
            return;
          this.client.logger.info(`Cleaning up ${s.length} duplicate pairing(s)`), await Promise.all(s.map((i2) => this.client.core.pairing.disconnect({ topic: i2.topic }))), this.client.logger.info("Duplicate pairings clean up finished");
        } catch (e) {
          this.client.logger.error(e);
        }
    }, this.deleteSession = async (t) => {
      const { topic: e, expirerHasDeleted: s = false, emitEvent: i2 = true, id: r = 0 } = t, { self: o2 } = this.client.session.get(e);
      await this.client.core.relayer.unsubscribe(e), await this.client.session.delete(e, tr$2("USER_DISCONNECTED")), this.addToRecentlyDeleted(e, "session"), this.client.core.crypto.keychain.has(o2.publicKey) && await this.client.core.crypto.deleteKeyPair(o2.publicKey), this.client.core.crypto.keychain.has(e) && await this.client.core.crypto.deleteSymKey(e), s || this.client.core.expirer.del(e), this.client.core.storage.removeItem(Re).catch((a3) => this.client.logger.warn(a3)), this.getPendingSessionRequests().forEach((a3) => {
        a3.topic === e && this.deletePendingSessionRequest(a3.id, tr$2("USER_DISCONNECTED"));
      }), i2 && this.client.events.emit("session_delete", { id: r, topic: e });
    }, this.deleteProposal = async (t, e) => {
      await Promise.all([this.client.proposal.delete(t, tr$2("USER_DISCONNECTED")), e ? Promise.resolve() : this.client.core.expirer.del(t)]), this.addToRecentlyDeleted(t, "proposal");
    }, this.deletePendingSessionRequest = async (t, e, s = false) => {
      await Promise.all([this.client.pendingRequest.delete(t, e), s ? Promise.resolve() : this.client.core.expirer.del(t)]), this.addToRecentlyDeleted(t, "request"), this.sessionRequestQueue.queue = this.sessionRequestQueue.queue.filter((i2) => i2.id !== t), s && (this.sessionRequestQueue.state = A.idle, this.client.events.emit("session_request_expire", { id: t }));
    }, this.setExpiry = async (t, e) => {
      this.client.session.keys.includes(t) && await this.client.session.update(t, { expiry: e }), this.client.core.expirer.set(t, e);
    }, this.setProposal = async (t, e) => {
      await this.client.proposal.set(t, e), this.client.core.expirer.set(t, d0(q$1.wc_sessionPropose.req.ttl));
    }, this.setPendingSessionRequest = async (t) => {
      const { id: e, topic: s, params: i2, verifyContext: r } = t, o2 = i2.request.expiryTimestamp || d0(q$1.wc_sessionRequest.req.ttl);
      await this.client.pendingRequest.set(e, { id: e, topic: s, params: i2, verifyContext: r }), o2 && this.client.core.expirer.set(e, o2);
    }, this.sendRequest = async (t) => {
      const { topic: e, method: s, params: i2, expiry: r, relayRpcId: o2, clientRpcId: a3, throwOnFailedPublish: c2 } = t, d4 = formatJsonRpcRequest(s, i2, a3);
      if (pr$2() && je.includes(s)) {
        const h4 = yu(JSON.stringify(d4));
        this.client.core.verify.register({ attestationId: h4 });
      }
      let p3;
      try {
        p3 = await this.client.core.crypto.encode(e, d4);
      } catch (h4) {
        throw await this.cleanup(), this.client.logger.error(`sendRequest() -> core.crypto.encode() for topic ${e} failed`), h4;
      }
      const g3 = q$1[s].req;
      return r && (g3.ttl = r), o2 && (g3.id = o2), this.client.core.history.set(e, d4), c2 ? (g3.internal = F$1(m2({}, g3.internal), { throwOnFailedPublish: true }), await this.client.core.relayer.publish(e, p3, g3)) : this.client.core.relayer.publish(e, p3, g3).catch((h4) => this.client.logger.error(h4)), d4.id;
    }, this.sendResult = async (t) => {
      const { id: e, topic: s, result: i2, throwOnFailedPublish: r, encodeOpts: o2 } = t, a3 = formatJsonRpcResult(e, i2);
      let c2;
      try {
        c2 = await this.client.core.crypto.encode(s, a3, o2);
      } catch (g3) {
        throw await this.cleanup(), this.client.logger.error(`sendResult() -> core.crypto.encode() for topic ${s} failed`), g3;
      }
      let d4;
      try {
        d4 = await this.client.core.history.get(s, e);
      } catch (g3) {
        throw this.client.logger.error(`sendResult() -> history.get(${s}, ${e}) failed`), g3;
      }
      const p3 = q$1[d4.request.method].res;
      r ? (p3.internal = F$1(m2({}, p3.internal), { throwOnFailedPublish: true }), await this.client.core.relayer.publish(s, c2, p3)) : this.client.core.relayer.publish(s, c2, p3).catch((g3) => this.client.logger.error(g3)), await this.client.core.history.resolve(a3);
    }, this.sendError = async (t) => {
      const { id: e, topic: s, error: i2, encodeOpts: r } = t, o2 = formatJsonRpcError(e, i2);
      let a3;
      try {
        a3 = await this.client.core.crypto.encode(s, o2, r);
      } catch (p3) {
        throw await this.cleanup(), this.client.logger.error(`sendError() -> core.crypto.encode() for topic ${s} failed`), p3;
      }
      let c2;
      try {
        c2 = await this.client.core.history.get(s, e);
      } catch (p3) {
        throw this.client.logger.error(`sendError() -> history.get(${s}, ${e}) failed`), p3;
      }
      const d4 = q$1[c2.request.method].res;
      this.client.core.relayer.publish(s, a3, d4), await this.client.core.history.resolve(o2);
    }, this.cleanup = async () => {
      const t = [], e = [];
      this.client.session.getAll().forEach((s) => {
        let i2 = false;
        p0(s.expiry) && (i2 = true), this.client.core.crypto.keychain.has(s.topic) || (i2 = true), i2 && t.push(s.topic);
      }), this.client.proposal.getAll().forEach((s) => {
        p0(s.expiryTimestamp) && e.push(s.id);
      }), await Promise.all([...t.map((s) => this.deleteSession({ topic: s })), ...e.map((s) => this.deleteProposal(s))]);
    }, this.onRelayEventRequest = async (t) => {
      this.requestQueue.queue.push(t), await this.processRequestsQueue();
    }, this.processRequestsQueue = async () => {
      if (this.requestQueue.state === A.active) {
        this.client.logger.info("Request queue already active, skipping...");
        return;
      }
      for (this.client.logger.info(`Request queue starting with ${this.requestQueue.queue.length} requests`); this.requestQueue.queue.length > 0; ) {
        this.requestQueue.state = A.active;
        const t = this.requestQueue.queue.shift();
        if (t)
          try {
            this.processRequest(t), await new Promise((e) => setTimeout(e, 300));
          } catch (e) {
            this.client.logger.warn(e);
          }
      }
      this.requestQueue.state = A.idle;
    }, this.processRequest = (t) => {
      const { topic: e, payload: s } = t, i2 = s.method;
      if (!this.shouldIgnorePairingRequest({ topic: e, requestMethod: i2 }))
        switch (i2) {
          case "wc_sessionPropose":
            return this.onSessionProposeRequest(e, s);
          case "wc_sessionSettle":
            return this.onSessionSettleRequest(e, s);
          case "wc_sessionUpdate":
            return this.onSessionUpdateRequest(e, s);
          case "wc_sessionExtend":
            return this.onSessionExtendRequest(e, s);
          case "wc_sessionPing":
            return this.onSessionPingRequest(e, s);
          case "wc_sessionDelete":
            return this.onSessionDeleteRequest(e, s);
          case "wc_sessionRequest":
            return this.onSessionRequest(e, s);
          case "wc_sessionEvent":
            return this.onSessionEventRequest(e, s);
          case "wc_sessionAuthenticate":
            return this.onSessionAuthenticateRequest(e, s);
          default:
            return this.client.logger.info(`Unsupported request method ${i2}`);
        }
    }, this.onRelayEventResponse = async (t) => {
      const { topic: e, payload: s } = t, i2 = (await this.client.core.history.get(e, s.id)).request.method;
      switch (i2) {
        case "wc_sessionPropose":
          return this.onSessionProposeResponse(e, s);
        case "wc_sessionSettle":
          return this.onSessionSettleResponse(e, s);
        case "wc_sessionUpdate":
          return this.onSessionUpdateResponse(e, s);
        case "wc_sessionExtend":
          return this.onSessionExtendResponse(e, s);
        case "wc_sessionPing":
          return this.onSessionPingResponse(e, s);
        case "wc_sessionRequest":
          return this.onSessionRequestResponse(e, s);
        case "wc_sessionAuthenticate":
          return this.onSessionAuthenticateResponse(e, s);
        default:
          return this.client.logger.info(`Unsupported response method ${i2}`);
      }
    }, this.onRelayEventUnknownPayload = (t) => {
      const { topic: e } = t, { message: s } = xe("MISSING_OR_INVALID", `Decoded payload on topic ${e} is not identifiable as a JSON-RPC request or a response.`);
      throw new Error(s);
    }, this.shouldIgnorePairingRequest = (t) => {
      const { topic: e, requestMethod: s } = t, i2 = this.expectedPairingMethodMap.get(e);
      return !i2 || i2.includes(s) ? false : !!(i2.includes("wc_sessionAuthenticate") && this.client.events.listenerCount("session_authenticate") > 0);
    }, this.onSessionProposeRequest = async (t, e) => {
      const { params: s, id: i2 } = e;
      try {
        this.isValidConnect(m2({}, e.params));
        const r = s.expiryTimestamp || d0(q$1.wc_sessionPropose.req.ttl), o2 = m2({ id: i2, pairingTopic: t, expiryTimestamp: r }, s);
        await this.setProposal(i2, o2);
        const a3 = yu(JSON.stringify(e)), c2 = await this.getVerifyContext(a3, o2.proposer.metadata);
        this.client.events.emit("session_proposal", { id: i2, params: o2, verifyContext: c2 });
      } catch (r) {
        await this.sendError({ id: i2, topic: t, error: r }), this.client.logger.error(r);
      }
    }, this.onSessionProposeResponse = async (t, e) => {
      const { id: s } = e;
      if (isJsonRpcResult(e)) {
        const { result: i2 } = e;
        this.client.logger.trace({ type: "method", method: "onSessionProposeResponse", result: i2 });
        const r = this.client.proposal.get(s);
        this.client.logger.trace({ type: "method", method: "onSessionProposeResponse", proposal: r });
        const o2 = r.proposer.publicKey;
        this.client.logger.trace({ type: "method", method: "onSessionProposeResponse", selfPublicKey: o2 });
        const a3 = i2.responderPublicKey;
        this.client.logger.trace({ type: "method", method: "onSessionProposeResponse", peerPublicKey: a3 });
        const c2 = await this.client.core.crypto.generateSharedKey(o2, a3);
        this.client.logger.trace({ type: "method", method: "onSessionProposeResponse", sessionTopic: c2 });
        const d4 = await this.client.core.relayer.subscribe(c2);
        this.client.logger.trace({ type: "method", method: "onSessionProposeResponse", subscriptionId: d4 }), await this.client.core.pairing.activate({ topic: t });
      } else if (isJsonRpcError(e)) {
        await this.client.proposal.delete(s, tr$2("USER_DISCONNECTED"));
        const i2 = v0("session_connect");
        if (this.events.listenerCount(i2) === 0)
          throw new Error(`emitting ${i2} without any listeners, 954`);
        this.events.emit(v0("session_connect"), { error: e.error });
      }
    }, this.onSessionSettleRequest = async (t, e) => {
      const { id: s, params: i2 } = e;
      try {
        this.isValidSessionSettleRequest(i2);
        const { relay: r, controller: o2, expiry: a3, namespaces: c2, sessionProperties: d4, pairingTopic: p3, sessionConfig: g3 } = e.params, h4 = m2(m2({ topic: t, relay: r, expiry: a3, namespaces: c2, acknowledged: true, pairingTopic: p3, requiredNamespaces: {}, optionalNamespaces: {}, controller: o2.publicKey, self: { publicKey: "", metadata: this.client.metadata }, peer: { publicKey: o2.publicKey, metadata: o2.metadata } }, d4 && { sessionProperties: d4 }), g3 && { sessionConfig: g3 });
        await this.sendResult({ id: e.id, topic: t, result: true, throwOnFailedPublish: true });
        const y3 = v0("session_connect");
        if (this.events.listenerCount(y3) === 0)
          throw new Error(`emitting ${y3} without any listeners 997`);
        this.events.emit(v0("session_connect"), { session: h4 }), this.cleanupDuplicatePairings(h4);
      } catch (r) {
        await this.sendError({ id: s, topic: t, error: r }), this.client.logger.error(r);
      }
    }, this.onSessionSettleResponse = async (t, e) => {
      const { id: s } = e;
      isJsonRpcResult(e) ? (await this.client.session.update(t, { acknowledged: true }), this.events.emit(v0("session_approve", s), {})) : isJsonRpcError(e) && (await this.client.session.delete(t, tr$2("USER_DISCONNECTED")), this.events.emit(v0("session_approve", s), { error: e.error }));
    }, this.onSessionUpdateRequest = async (t, e) => {
      const { params: s, id: i2 } = e;
      try {
        const r = `${t}_session_update`, o2 = lh.get(r);
        if (o2 && this.isRequestOutOfSync(o2, i2)) {
          this.client.logger.info(`Discarding out of sync request - ${i2}`), this.sendError({ id: i2, topic: t, error: tr$2("INVALID_UPDATE_REQUEST") });
          return;
        }
        this.isValidUpdate(m2({ topic: t }, s));
        try {
          lh.set(r, i2), await this.client.session.update(t, { namespaces: s.namespaces }), await this.sendResult({ id: i2, topic: t, result: true, throwOnFailedPublish: true });
        } catch (a3) {
          throw lh.delete(r), a3;
        }
        this.client.events.emit("session_update", { id: i2, topic: t, params: s });
      } catch (r) {
        await this.sendError({ id: i2, topic: t, error: r }), this.client.logger.error(r);
      }
    }, this.isRequestOutOfSync = (t, e) => parseInt(e.toString().slice(0, -3)) <= parseInt(t.toString().slice(0, -3)), this.onSessionUpdateResponse = (t, e) => {
      const { id: s } = e, i2 = v0("session_update", s);
      if (this.events.listenerCount(i2) === 0)
        throw new Error(`emitting ${i2} without any listeners`);
      isJsonRpcResult(e) ? this.events.emit(v0("session_update", s), {}) : isJsonRpcError(e) && this.events.emit(v0("session_update", s), { error: e.error });
    }, this.onSessionExtendRequest = async (t, e) => {
      const { id: s } = e;
      try {
        this.isValidExtend({ topic: t }), await this.setExpiry(t, d0(L$1)), await this.sendResult({ id: s, topic: t, result: true, throwOnFailedPublish: true }), this.client.events.emit("session_extend", { id: s, topic: t });
      } catch (i2) {
        await this.sendError({ id: s, topic: t, error: i2 }), this.client.logger.error(i2);
      }
    }, this.onSessionExtendResponse = (t, e) => {
      const { id: s } = e, i2 = v0("session_extend", s);
      if (this.events.listenerCount(i2) === 0)
        throw new Error(`emitting ${i2} without any listeners`);
      isJsonRpcResult(e) ? this.events.emit(v0("session_extend", s), {}) : isJsonRpcError(e) && this.events.emit(v0("session_extend", s), { error: e.error });
    }, this.onSessionPingRequest = async (t, e) => {
      const { id: s } = e;
      try {
        this.isValidPing({ topic: t }), await this.sendResult({ id: s, topic: t, result: true, throwOnFailedPublish: true }), this.client.events.emit("session_ping", { id: s, topic: t });
      } catch (i2) {
        await this.sendError({ id: s, topic: t, error: i2 }), this.client.logger.error(i2);
      }
    }, this.onSessionPingResponse = (t, e) => {
      const { id: s } = e, i2 = v0("session_ping", s);
      if (this.events.listenerCount(i2) === 0)
        throw new Error(`emitting ${i2} without any listeners`);
      setTimeout(() => {
        isJsonRpcResult(e) ? this.events.emit(v0("session_ping", s), {}) : isJsonRpcError(e) && this.events.emit(v0("session_ping", s), { error: e.error });
      }, 500);
    }, this.onSessionDeleteRequest = async (t, e) => {
      const { id: s } = e;
      try {
        this.isValidDisconnect({ topic: t, reason: e.params }), await Promise.all([new Promise((i2) => {
          this.client.core.relayer.once(v$1.publish, async () => {
            i2(await this.deleteSession({ topic: t, id: s }));
          });
        }), this.sendResult({ id: s, topic: t, result: true, throwOnFailedPublish: true }), this.cleanupPendingSentRequestsForTopic({ topic: t, error: tr$2("USER_DISCONNECTED") })]);
      } catch (i2) {
        this.client.logger.error(i2);
      }
    }, this.onSessionRequest = async (t, e) => {
      const { id: s, params: i2 } = e;
      try {
        await this.isValidRequest(m2({ topic: t }, i2));
        const r = yu(JSON.stringify(formatJsonRpcRequest("wc_sessionRequest", i2, s))), o2 = this.client.session.get(t), a3 = await this.getVerifyContext(r, o2.peer.metadata), c2 = { id: s, topic: t, params: i2, verifyContext: a3 };
        await this.setPendingSessionRequest(c2), this.addSessionRequestToSessionRequestQueue(c2), this.processSessionRequestQueue();
      } catch (r) {
        await this.sendError({ id: s, topic: t, error: r }), this.client.logger.error(r);
      }
    }, this.onSessionRequestResponse = (t, e) => {
      const { id: s } = e, i2 = v0("session_request", s);
      if (this.events.listenerCount(i2) === 0)
        throw new Error(`emitting ${i2} without any listeners`);
      isJsonRpcResult(e) ? this.events.emit(v0("session_request", s), { result: e.result }) : isJsonRpcError(e) && this.events.emit(v0("session_request", s), { error: e.error });
    }, this.onSessionEventRequest = async (t, e) => {
      const { id: s, params: i2 } = e;
      try {
        const r = `${t}_session_event_${i2.event.name}`, o2 = lh.get(r);
        if (o2 && this.isRequestOutOfSync(o2, s)) {
          this.client.logger.info(`Discarding out of sync request - ${s}`);
          return;
        }
        this.isValidEmit(m2({ topic: t }, i2)), this.client.events.emit("session_event", { id: s, topic: t, params: i2 }), lh.set(r, s);
      } catch (r) {
        await this.sendError({ id: s, topic: t, error: r }), this.client.logger.error(r);
      }
    }, this.onSessionAuthenticateResponse = (t, e) => {
      const { id: s } = e;
      this.client.logger.trace({ type: "method", method: "onSessionAuthenticateResponse", topic: t, payload: e }), isJsonRpcResult(e) ? this.events.emit(v0("session_request", s), { result: e.result }) : isJsonRpcError(e) && this.events.emit(v0("session_request", s), { error: e.error });
    }, this.onSessionAuthenticateRequest = async (t, e) => {
      const { requester: s, authPayload: i2, expiryTimestamp: r } = e.params, o2 = yu(JSON.stringify(e)), a3 = await this.getVerifyContext(o2, this.client.metadata), c2 = { requester: s, pairingTopic: t, id: e.id, authPayload: i2, verifyContext: a3, expiryTimestamp: r };
      await this.client.auth.requests.set(e.id, c2), this.client.events.emit("session_authenticate", { topic: t, params: e.params, id: e.id });
    }, this.addSessionRequestToSessionRequestQueue = (t) => {
      this.sessionRequestQueue.queue.push(t);
    }, this.cleanupAfterResponse = (t) => {
      this.deletePendingSessionRequest(t.response.id, { message: "fulfilled", code: 0 }), setTimeout(() => {
        this.sessionRequestQueue.state = A.idle, this.processSessionRequestQueue();
      }, cjs$3.toMiliseconds(this.requestQueueDelay));
    }, this.cleanupPendingSentRequestsForTopic = ({ topic: t, error: e }) => {
      const s = this.client.core.history.pending;
      s.length > 0 && s.filter((i2) => i2.topic === t && i2.request.method === "wc_sessionRequest").forEach((i2) => {
        const r = i2.request.id, o2 = v0("session_request", r);
        if (this.events.listenerCount(o2) === 0)
          throw new Error(`emitting ${o2} without any listeners`);
        this.events.emit(v0("session_request", i2.request.id), { error: e });
      });
    }, this.processSessionRequestQueue = () => {
      if (this.sessionRequestQueue.state === A.active) {
        this.client.logger.info("session request queue is already active.");
        return;
      }
      const t = this.sessionRequestQueue.queue[0];
      if (!t) {
        this.client.logger.info("session request queue is empty.");
        return;
      }
      try {
        this.sessionRequestQueue.state = A.active, this.client.events.emit("session_request", t);
      } catch (e) {
        this.client.logger.error(e);
      }
    }, this.onPairingCreated = (t) => {
      if (t.methods && this.expectedPairingMethodMap.set(t.topic, t.methods), t.active)
        return;
      const e = this.client.proposal.getAll().find((s) => s.pairingTopic === t.topic);
      e && this.onSessionProposeRequest(t.topic, formatJsonRpcRequest("wc_sessionPropose", { requiredNamespaces: e.requiredNamespaces, optionalNamespaces: e.optionalNamespaces, relays: e.relays, proposer: e.proposer, sessionProperties: e.sessionProperties }, e.id));
    }, this.isValidConnect = async (t) => {
      if (!$u(t)) {
        const { message: a3 } = xe("MISSING_OR_INVALID", `connect() params: ${JSON.stringify(t)}`);
        throw new Error(a3);
      }
      const { pairingTopic: e, requiredNamespaces: s, optionalNamespaces: i2, sessionProperties: r, relays: o2 } = t;
      if (Pe(e) || await this.isValidPairingTopic(e), !Xu(o2, true)) {
        const { message: a3 } = xe("MISSING_OR_INVALID", `connect() relays: ${o2}`);
        throw new Error(a3);
      }
      !Pe(s) && Yr(s) !== 0 && this.validateNamespaces(s, "requiredNamespaces"), !Pe(i2) && Yr(i2) !== 0 && this.validateNamespaces(i2, "optionalNamespaces"), Pe(r) || this.validateSessionProps(r, "sessionProperties");
    }, this.validateNamespaces = (t, e) => {
      const s = Wu(t, "connect()", e);
      if (s)
        throw new Error(s.message);
    }, this.isValidApprove = async (t) => {
      if (!$u(t))
        throw new Error(xe("MISSING_OR_INVALID", `approve() params: ${t}`).message);
      const { id: e, namespaces: s, relayProtocol: i2, sessionProperties: r } = t;
      this.checkRecentlyDeleted(e), await this.isValidProposalId(e);
      const o2 = this.client.proposal.get(e), a3 = So(s, "approve()");
      if (a3)
        throw new Error(a3.message);
      const c2 = Io(o2.requiredNamespaces, s, "approve()");
      if (c2)
        throw new Error(c2.message);
      if (!Gt$2(i2, true)) {
        const { message: d4 } = xe("MISSING_OR_INVALID", `approve() relayProtocol: ${i2}`);
        throw new Error(d4);
      }
      Pe(r) || this.validateSessionProps(r, "sessionProperties");
    }, this.isValidReject = async (t) => {
      if (!$u(t)) {
        const { message: i2 } = xe("MISSING_OR_INVALID", `reject() params: ${t}`);
        throw new Error(i2);
      }
      const { id: e, reason: s } = t;
      if (this.checkRecentlyDeleted(e), await this.isValidProposalId(e), !th(s)) {
        const { message: i2 } = xe("MISSING_OR_INVALID", `reject() reason: ${JSON.stringify(s)}`);
        throw new Error(i2);
      }
    }, this.isValidSessionSettleRequest = (t) => {
      if (!$u(t)) {
        const { message: c2 } = xe("MISSING_OR_INVALID", `onSessionSettleRequest() params: ${t}`);
        throw new Error(c2);
      }
      const { relay: e, controller: s, namespaces: i2, expiry: r } = t;
      if (!No(e)) {
        const { message: c2 } = xe("MISSING_OR_INVALID", "onSessionSettleRequest() relay protocol should be a string");
        throw new Error(c2);
      }
      const o2 = Vu(s, "onSessionSettleRequest()");
      if (o2)
        throw new Error(o2.message);
      const a3 = So(i2, "onSessionSettleRequest()");
      if (a3)
        throw new Error(a3.message);
      if (p0(r)) {
        const { message: c2 } = xe("EXPIRED", "onSessionSettleRequest()");
        throw new Error(c2);
      }
    }, this.isValidUpdate = async (t) => {
      if (!$u(t)) {
        const { message: a3 } = xe("MISSING_OR_INVALID", `update() params: ${t}`);
        throw new Error(a3);
      }
      const { topic: e, namespaces: s } = t;
      this.checkRecentlyDeleted(e), await this.isValidSessionTopic(e);
      const i2 = this.client.session.get(e), r = So(s, "update()");
      if (r)
        throw new Error(r.message);
      const o2 = Io(i2.requiredNamespaces, s, "update()");
      if (o2)
        throw new Error(o2.message);
    }, this.isValidExtend = async (t) => {
      if (!$u(t)) {
        const { message: s } = xe("MISSING_OR_INVALID", `extend() params: ${t}`);
        throw new Error(s);
      }
      const { topic: e } = t;
      this.checkRecentlyDeleted(e), await this.isValidSessionTopic(e);
    }, this.isValidRequest = async (t) => {
      if (!$u(t)) {
        const { message: a3 } = xe("MISSING_OR_INVALID", `request() params: ${t}`);
        throw new Error(a3);
      }
      const { topic: e, request: s, chainId: i2, expiry: r } = t;
      this.checkRecentlyDeleted(e), await this.isValidSessionTopic(e);
      const { namespaces: o2 } = this.client.session.get(e);
      if (!nh(o2, i2)) {
        const { message: a3 } = xe("MISSING_OR_INVALID", `request() chainId: ${i2}`);
        throw new Error(a3);
      }
      if (!eh(s)) {
        const { message: a3 } = xe("MISSING_OR_INVALID", `request() ${JSON.stringify(s)}`);
        throw new Error(a3);
      }
      if (!fh(o2, i2, s.method)) {
        const { message: a3 } = xe("MISSING_OR_INVALID", `request() method: ${s.method}`);
        throw new Error(a3);
      }
      if (r && !uh(r, re)) {
        const { message: a3 } = xe("MISSING_OR_INVALID", `request() expiry: ${r}. Expiry must be a number (in seconds) between ${re.min} and ${re.max}`);
        throw new Error(a3);
      }
    }, this.isValidRespond = async (t) => {
      var e;
      if (!$u(t)) {
        const { message: r } = xe("MISSING_OR_INVALID", `respond() params: ${t}`);
        throw new Error(r);
      }
      const { topic: s, response: i2 } = t;
      try {
        await this.isValidSessionTopic(s);
      } catch (r) {
        throw (e = t == null ? void 0 : t.response) != null && e.id && this.cleanupAfterResponse(t), r;
      }
      if (!rh(i2)) {
        const { message: r } = xe("MISSING_OR_INVALID", `respond() response: ${JSON.stringify(i2)}`);
        throw new Error(r);
      }
    }, this.isValidPing = async (t) => {
      if (!$u(t)) {
        const { message: s } = xe("MISSING_OR_INVALID", `ping() params: ${t}`);
        throw new Error(s);
      }
      const { topic: e } = t;
      await this.isValidSessionOrPairingTopic(e);
    }, this.isValidEmit = async (t) => {
      if (!$u(t)) {
        const { message: o2 } = xe("MISSING_OR_INVALID", `emit() params: ${t}`);
        throw new Error(o2);
      }
      const { topic: e, event: s, chainId: i2 } = t;
      await this.isValidSessionTopic(e);
      const { namespaces: r } = this.client.session.get(e);
      if (!nh(r, i2)) {
        const { message: o2 } = xe("MISSING_OR_INVALID", `emit() chainId: ${i2}`);
        throw new Error(o2);
      }
      if (!ih(s)) {
        const { message: o2 } = xe("MISSING_OR_INVALID", `emit() event: ${JSON.stringify(s)}`);
        throw new Error(o2);
      }
      if (!oh(r, i2, s.name)) {
        const { message: o2 } = xe("MISSING_OR_INVALID", `emit() event: ${JSON.stringify(s)}`);
        throw new Error(o2);
      }
    }, this.isValidDisconnect = async (t) => {
      if (!$u(t)) {
        const { message: s } = xe("MISSING_OR_INVALID", `disconnect() params: ${t}`);
        throw new Error(s);
      }
      const { topic: e } = t;
      await this.isValidSessionOrPairingTopic(e);
    }, this.isValidAuthenticate = (t) => {
      const { chains: e, uri: s, domain: i2, nonce: r } = t;
      if (!Array.isArray(e) || e.length === 0)
        throw new Error("chains is required and must be a non-empty array");
      if (!Gt$2(s, false))
        throw new Error("uri is required parameter");
      if (!Gt$2(i2, false))
        throw new Error("domain is required parameter");
      if (!Gt$2(r, false))
        throw new Error("nonce is required parameter");
      if ([...new Set(e.map((a3) => dn(a3).namespace))].length > 1)
        throw new Error("Multi-namespace requests are not supported. Please request single namespace only.");
      const { namespace: o2 } = dn(e[0]);
      if (o2 !== "eip155")
        throw new Error("Only eip155 namespace is supported for authenticated sessions. Please use .connect() for non-eip155 chains.");
    }, this.getVerifyContext = async (t, e) => {
      const s = { verified: { verifyUrl: e.verifyUrl || k$1, validation: "UNKNOWN", origin: e.url || "" } };
      try {
        const i2 = await this.client.core.verify.resolve({ attestationId: t, verifyUrl: e.verifyUrl });
        i2 && (s.verified.origin = i2.origin, s.verified.isScam = i2.isScam, s.verified.validation = i2.origin === new URL(e.url).origin ? "VALID" : "INVALID");
      } catch (i2) {
        this.client.logger.info(i2);
      }
      return this.client.logger.info(`Verify context: ${JSON.stringify(s)}`), s;
    }, this.validateSessionProps = (t, e) => {
      Object.values(t).forEach((s) => {
        if (!Gt$2(s, false)) {
          const { message: i2 } = xe("MISSING_OR_INVALID", `${e} must be in Record<string, string> format. Received: ${JSON.stringify(s)}`);
          throw new Error(i2);
        }
      });
    }, this.getPendingAuthRequest = (t) => {
      const e = this.client.auth.requests.get(t);
      return typeof e == "object" ? e : void 0;
    }, this.addToRecentlyDeleted = (t, e) => {
      if (this.recentlyDeletedMap.set(t, e), this.recentlyDeletedMap.size >= this.recentlyDeletedLimit) {
        let s = 0;
        const i2 = this.recentlyDeletedLimit / 2;
        for (const r of this.recentlyDeletedMap.keys()) {
          if (s++ >= i2)
            break;
          this.recentlyDeletedMap.delete(r);
        }
      }
    }, this.checkRecentlyDeleted = (t) => {
      const e = this.recentlyDeletedMap.get(t);
      if (e) {
        const { message: s } = xe("MISSING_OR_INVALID", `Record was recently deleted - ${e}: ${t}`);
        throw new Error(s);
      }
    };
  }
  async isInitialized() {
    if (!this.initialized) {
      const { message: n2 } = xe("NOT_INITIALIZED", this.name);
      throw new Error(n2);
    }
    await this.client.core.relayer.confirmOnlineStateOrThrow();
  }
  registerRelayerEvents() {
    this.client.core.relayer.on(v$1.message, async (n2) => {
      const { topic: t, message: e } = n2, { publicKey: s } = this.client.auth.authKeys.keys.includes(J$1) ? this.client.auth.authKeys.get(J$1) : { responseTopic: void 0, publicKey: void 0 }, i2 = await this.client.core.crypto.decode(t, e, { receiverPublicKey: s });
      try {
        isJsonRpcRequest(i2) ? (this.client.core.history.set(t, i2), this.onRelayEventRequest({ topic: t, payload: i2 })) : isJsonRpcResponse(i2) ? (await this.client.core.history.resolve(i2), await this.onRelayEventResponse({ topic: t, payload: i2 }), this.client.core.history.delete(t, i2.id)) : this.onRelayEventUnknownPayload({ topic: t, payload: i2 });
      } catch (r) {
        this.client.logger.error(r);
      }
    });
  }
  registerExpirerEvents() {
    this.client.core.expirer.on(C$1.expired, async (n2) => {
      const { topic: t, id: e } = l0(n2.target);
      if (e && this.client.pendingRequest.keys.includes(e))
        return await this.deletePendingSessionRequest(e, xe("EXPIRED"), true);
      t ? this.client.session.keys.includes(t) && (await this.deleteSession({ topic: t, expirerHasDeleted: true }), this.client.events.emit("session_expire", { topic: t })) : e && (await this.deleteProposal(e, true), this.client.events.emit("proposal_expire", { id: e }));
    });
  }
  registerPairingEvents() {
    this.client.core.pairing.events.on(V$2.create, (n2) => this.onPairingCreated(n2)), this.client.core.pairing.events.on(V$2.delete, (n2) => {
      this.addToRecentlyDeleted(n2.topic, "pairing");
    });
  }
  isValidPairingTopic(n2) {
    if (!Gt$2(n2, false)) {
      const { message: t } = xe("MISSING_OR_INVALID", `pairing topic should be a string: ${n2}`);
      throw new Error(t);
    }
    if (!this.client.core.pairing.pairings.keys.includes(n2)) {
      const { message: t } = xe("NO_MATCHING_KEY", `pairing topic doesn't exist: ${n2}`);
      throw new Error(t);
    }
    if (p0(this.client.core.pairing.pairings.get(n2).expiry)) {
      const { message: t } = xe("EXPIRED", `pairing topic: ${n2}`);
      throw new Error(t);
    }
  }
  async isValidSessionTopic(n2) {
    if (!Gt$2(n2, false)) {
      const { message: t } = xe("MISSING_OR_INVALID", `session topic should be a string: ${n2}`);
      throw new Error(t);
    }
    if (this.checkRecentlyDeleted(n2), !this.client.session.keys.includes(n2)) {
      const { message: t } = xe("NO_MATCHING_KEY", `session topic doesn't exist: ${n2}`);
      throw new Error(t);
    }
    if (p0(this.client.session.get(n2).expiry)) {
      await this.deleteSession({ topic: n2 });
      const { message: t } = xe("EXPIRED", `session topic: ${n2}`);
      throw new Error(t);
    }
    if (!this.client.core.crypto.keychain.has(n2)) {
      const { message: t } = xe("MISSING_OR_INVALID", `session topic does not exist in keychain: ${n2}`);
      throw await this.deleteSession({ topic: n2 }), new Error(t);
    }
  }
  async isValidSessionOrPairingTopic(n2) {
    if (this.checkRecentlyDeleted(n2), this.client.session.keys.includes(n2))
      await this.isValidSessionTopic(n2);
    else if (this.client.core.pairing.pairings.keys.includes(n2))
      this.isValidPairingTopic(n2);
    else if (Gt$2(n2, false)) {
      const { message: t } = xe("NO_MATCHING_KEY", `session or pairing topic doesn't exist: ${n2}`);
      throw new Error(t);
    } else {
      const { message: t } = xe("MISSING_OR_INVALID", `session or pairing topic should be a string: ${n2}`);
      throw new Error(t);
    }
  }
  async isValidProposalId(n2) {
    if (!Zu(n2)) {
      const { message: t } = xe("MISSING_OR_INVALID", `proposal id should be a number: ${n2}`);
      throw new Error(t);
    }
    if (!this.client.proposal.keys.includes(n2)) {
      const { message: t } = xe("NO_MATCHING_KEY", `proposal id doesn't exist: ${n2}`);
      throw new Error(t);
    }
    if (p0(this.client.proposal.get(n2).expiryTimestamp)) {
      await this.deleteProposal(n2);
      const { message: t } = xe("EXPIRED", `proposal id: ${n2}`);
      throw new Error(t);
    }
  }
}
class Zt extends Vt$1 {
  constructor(n2, t) {
    super(n2, t, Ke, se$1), this.core = n2, this.logger = t;
  }
}
class We extends Vt$1 {
  constructor(n2, t) {
    super(n2, t, Ge, se$1), this.core = n2, this.logger = t;
  }
}
class es2 extends Vt$1 {
  constructor(n2, t) {
    super(n2, t, Fe, se$1, (e) => e.id), this.core = n2, this.logger = t;
  }
}
class ts2 extends Vt$1 {
  constructor(n2, t) {
    super(n2, t, He, X, () => J$1), this.core = n2, this.logger = t;
  }
}
class ss2 extends Vt$1 {
  constructor(n2, t) {
    super(n2, t, Ye, X), this.core = n2, this.logger = t;
  }
}
class is2 extends Vt$1 {
  constructor(n2, t) {
    super(n2, t, Xe, X, (e) => e.id), this.core = n2, this.logger = t;
  }
}
class rs {
  constructor(n2, t) {
    this.core = n2, this.logger = t, this.authKeys = new ts2(this.core, this.logger), this.pairingTopics = new ss2(this.core, this.logger), this.requests = new is2(this.core, this.logger);
  }
  async init() {
    await this.authKeys.init(), await this.pairingTopics.init(), await this.requests.init();
  }
}
let ne$1 = class ne extends b$2 {
  constructor(n2) {
    super(n2), this.protocol = Se, this.version = Ee, this.name = ie$1.name, this.events = new eventsExports.EventEmitter(), this.on = (e, s) => this.events.on(e, s), this.once = (e, s) => this.events.once(e, s), this.off = (e, s) => this.events.off(e, s), this.removeListener = (e, s) => this.events.removeListener(e, s), this.removeAllListeners = (e) => this.events.removeAllListeners(e), this.connect = async (e) => {
      try {
        return await this.engine.connect(e);
      } catch (s) {
        throw this.logger.error(s.message), s;
      }
    }, this.pair = async (e) => {
      try {
        return await this.engine.pair(e);
      } catch (s) {
        throw this.logger.error(s.message), s;
      }
    }, this.approve = async (e) => {
      try {
        return await this.engine.approve(e);
      } catch (s) {
        throw this.logger.error(s.message), s;
      }
    }, this.reject = async (e) => {
      try {
        return await this.engine.reject(e);
      } catch (s) {
        throw this.logger.error(s.message), s;
      }
    }, this.update = async (e) => {
      try {
        return await this.engine.update(e);
      } catch (s) {
        throw this.logger.error(s.message), s;
      }
    }, this.extend = async (e) => {
      try {
        return await this.engine.extend(e);
      } catch (s) {
        throw this.logger.error(s.message), s;
      }
    }, this.request = async (e) => {
      try {
        return await this.engine.request(e);
      } catch (s) {
        throw this.logger.error(s.message), s;
      }
    }, this.respond = async (e) => {
      try {
        return await this.engine.respond(e);
      } catch (s) {
        throw this.logger.error(s.message), s;
      }
    }, this.ping = async (e) => {
      try {
        return await this.engine.ping(e);
      } catch (s) {
        throw this.logger.error(s.message), s;
      }
    }, this.emit = async (e) => {
      try {
        return await this.engine.emit(e);
      } catch (s) {
        throw this.logger.error(s.message), s;
      }
    }, this.disconnect = async (e) => {
      try {
        return await this.engine.disconnect(e);
      } catch (s) {
        throw this.logger.error(s.message), s;
      }
    }, this.find = (e) => {
      try {
        return this.engine.find(e);
      } catch (s) {
        throw this.logger.error(s.message), s;
      }
    }, this.getPendingSessionRequests = () => {
      try {
        return this.engine.getPendingSessionRequests();
      } catch (e) {
        throw this.logger.error(e.message), e;
      }
    }, this.authenticate = async (e) => {
      try {
        return await this.engine.authenticate(e);
      } catch (s) {
        throw this.logger.error(s.message), s;
      }
    }, this.formatAuthMessage = (e) => {
      try {
        return this.engine.formatAuthMessage(e);
      } catch (s) {
        throw this.logger.error(s.message), s;
      }
    }, this.approveSessionAuthenticate = async (e) => {
      try {
        return await this.engine.approveSessionAuthenticate(e);
      } catch (s) {
        throw this.logger.error(s.message), s;
      }
    }, this.rejectSessionAuthenticate = async (e) => {
      try {
        return await this.engine.rejectSessionAuthenticate(e);
      } catch (s) {
        throw this.logger.error(s.message), s;
      }
    }, this.name = (n2 == null ? void 0 : n2.name) || ie$1.name, this.metadata = (n2 == null ? void 0 : n2.metadata) || Xo();
    const t = typeof (n2 == null ? void 0 : n2.logger) < "u" && typeof (n2 == null ? void 0 : n2.logger) != "string" ? n2.logger : nt$2(k$2({ level: (n2 == null ? void 0 : n2.logger) || ie$1.logger }));
    this.core = (n2 == null ? void 0 : n2.core) || new Br$1(n2), this.logger = E$2(t, this.name), this.session = new We(this.core, this.logger), this.proposal = new Zt(this.core, this.logger), this.pendingRequest = new es2(this.core, this.logger), this.engine = new Wt(this), this.auth = new rs(this.core, this.logger);
  }
  static async init(n2) {
    const t = new ne(n2);
    return await t.initialize(), t;
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
      await this.core.start(), await this.session.init(), await this.proposal.init(), await this.pendingRequest.init(), await this.engine.init(), await this.auth.init(), this.core.verify.init({ verifyUrl: this.metadata.verifyUrl }), this.logger.info("SignClient Initialization Success");
    } catch (n2) {
      throw this.logger.info("SignClient Initialization Failure"), this.logger.error(n2.message), n2;
    }
  }
};
const ns = We, os = ne$1;
var l = { exports: {} }, c = typeof Reflect == "object" ? Reflect : null, y2 = c && typeof c.apply == "function" ? c.apply : function(t, e, n2) {
  return Function.prototype.apply.call(t, e, n2);
}, f2;
c && typeof c.ownKeys == "function" ? f2 = c.ownKeys : Object.getOwnPropertySymbols ? f2 = function(t) {
  return Object.getOwnPropertyNames(t).concat(Object.getOwnPropertySymbols(t));
} : f2 = function(t) {
  return Object.getOwnPropertyNames(t);
};
function k(s) {
  console && console.warn && console.warn(s);
}
var w2 = Number.isNaN || function(t) {
  return t !== t;
};
function o() {
  o.init.call(this);
}
l.exports = o, l.exports.once = K2, o.EventEmitter = o, o.prototype._events = void 0, o.prototype._eventsCount = 0, o.prototype._maxListeners = void 0;
var L3 = 10;
function g2(s) {
  if (typeof s != "function")
    throw new TypeError('The "listener" argument must be of type Function. Received type ' + typeof s);
}
Object.defineProperty(o, "defaultMaxListeners", { enumerable: true, get: function() {
  return L3;
}, set: function(s) {
  if (typeof s != "number" || s < 0 || w2(s))
    throw new RangeError('The value of "defaultMaxListeners" is out of range. It must be a non-negative number. Received ' + s + ".");
  L3 = s;
} }), o.init = function() {
  (this._events === void 0 || this._events === Object.getPrototypeOf(this)._events) && (this._events = /* @__PURE__ */ Object.create(null), this._eventsCount = 0), this._maxListeners = this._maxListeners || void 0;
}, o.prototype.setMaxListeners = function(t) {
  if (typeof t != "number" || t < 0 || w2(t))
    throw new RangeError('The value of "n" is out of range. It must be a non-negative number. Received ' + t + ".");
  return this._maxListeners = t, this;
};
function _2(s) {
  return s._maxListeners === void 0 ? o.defaultMaxListeners : s._maxListeners;
}
o.prototype.getMaxListeners = function() {
  return _2(this);
}, o.prototype.emit = function(t) {
  for (var e = [], n2 = 1; n2 < arguments.length; n2++)
    e.push(arguments[n2]);
  var i2 = t === "error", a3 = this._events;
  if (a3 !== void 0)
    i2 = i2 && a3.error === void 0;
  else if (!i2)
    return false;
  if (i2) {
    var r;
    if (e.length > 0 && (r = e[0]), r instanceof Error)
      throw r;
    var h4 = new Error("Unhandled error." + (r ? " (" + r.message + ")" : ""));
    throw h4.context = r, h4;
  }
  var u2 = a3[t];
  if (u2 === void 0)
    return false;
  if (typeof u2 == "function")
    y2(u2, this, e);
  else
    for (var d4 = u2.length, M2 = O2(u2, d4), n2 = 0; n2 < d4; ++n2)
      y2(M2[n2], this, e);
  return true;
};
function S2(s, t, e, n2) {
  var i2, a3, r;
  if (g2(e), a3 = s._events, a3 === void 0 ? (a3 = s._events = /* @__PURE__ */ Object.create(null), s._eventsCount = 0) : (a3.newListener !== void 0 && (s.emit("newListener", t, e.listener ? e.listener : e), a3 = s._events), r = a3[t]), r === void 0)
    r = a3[t] = e, ++s._eventsCount;
  else if (typeof r == "function" ? r = a3[t] = n2 ? [e, r] : [r, e] : n2 ? r.unshift(e) : r.push(e), i2 = _2(s), i2 > 0 && r.length > i2 && !r.warned) {
    r.warned = true;
    var h4 = new Error("Possible EventEmitter memory leak detected. " + r.length + " " + String(t) + " listeners added. Use emitter.setMaxListeners() to increase limit");
    h4.name = "MaxListenersExceededWarning", h4.emitter = s, h4.type = t, h4.count = r.length, k(h4);
  }
  return s;
}
o.prototype.addListener = function(t, e) {
  return S2(this, t, e, false);
}, o.prototype.on = o.prototype.addListener, o.prototype.prependListener = function(t, e) {
  return S2(this, t, e, true);
};
function D() {
  if (!this.fired)
    return this.target.removeListener(this.type, this.wrapFn), this.fired = true, arguments.length === 0 ? this.listener.call(this.target) : this.listener.apply(this.target, arguments);
}
function b2(s, t, e) {
  var n2 = { fired: false, wrapFn: void 0, target: s, type: t, listener: e }, i2 = D.bind(n2);
  return i2.listener = e, n2.wrapFn = i2, i2;
}
o.prototype.once = function(t, e) {
  return g2(e), this.on(t, b2(this, t, e)), this;
}, o.prototype.prependOnceListener = function(t, e) {
  return g2(e), this.prependListener(t, b2(this, t, e)), this;
}, o.prototype.removeListener = function(t, e) {
  var n2, i2, a3, r, h4;
  if (g2(e), i2 = this._events, i2 === void 0)
    return this;
  if (n2 = i2[t], n2 === void 0)
    return this;
  if (n2 === e || n2.listener === e)
    --this._eventsCount === 0 ? this._events = /* @__PURE__ */ Object.create(null) : (delete i2[t], i2.removeListener && this.emit("removeListener", t, n2.listener || e));
  else if (typeof n2 != "function") {
    for (a3 = -1, r = n2.length - 1; r >= 0; r--)
      if (n2[r] === e || n2[r].listener === e) {
        h4 = n2[r].listener, a3 = r;
        break;
      }
    if (a3 < 0)
      return this;
    a3 === 0 ? n2.shift() : F(n2, a3), n2.length === 1 && (i2[t] = n2[0]), i2.removeListener !== void 0 && this.emit("removeListener", t, h4 || e);
  }
  return this;
}, o.prototype.off = o.prototype.removeListener, o.prototype.removeAllListeners = function(t) {
  var e, n2, i2;
  if (n2 = this._events, n2 === void 0)
    return this;
  if (n2.removeListener === void 0)
    return arguments.length === 0 ? (this._events = /* @__PURE__ */ Object.create(null), this._eventsCount = 0) : n2[t] !== void 0 && (--this._eventsCount === 0 ? this._events = /* @__PURE__ */ Object.create(null) : delete n2[t]), this;
  if (arguments.length === 0) {
    var a3 = Object.keys(n2), r;
    for (i2 = 0; i2 < a3.length; ++i2)
      r = a3[i2], r !== "removeListener" && this.removeAllListeners(r);
    return this.removeAllListeners("removeListener"), this._events = /* @__PURE__ */ Object.create(null), this._eventsCount = 0, this;
  }
  if (e = n2[t], typeof e == "function")
    this.removeListener(t, e);
  else if (e !== void 0)
    for (i2 = e.length - 1; i2 >= 0; i2--)
      this.removeListener(t, e[i2]);
  return this;
};
function C(s, t, e) {
  var n2 = s._events;
  if (n2 === void 0)
    return [];
  var i2 = n2[t];
  return i2 === void 0 ? [] : typeof i2 == "function" ? e ? [i2.listener || i2] : [i2] : e ? z(i2) : O2(i2, i2.length);
}
o.prototype.listeners = function(t) {
  return C(this, t, true);
}, o.prototype.rawListeners = function(t) {
  return C(this, t, false);
}, o.listenerCount = function(s, t) {
  return typeof s.listenerCount == "function" ? s.listenerCount(t) : E2.call(s, t);
}, o.prototype.listenerCount = E2;
function E2(s) {
  var t = this._events;
  if (t !== void 0) {
    var e = t[s];
    if (typeof e == "function")
      return 1;
    if (e !== void 0)
      return e.length;
  }
  return 0;
}
o.prototype.eventNames = function() {
  return this._eventsCount > 0 ? f2(this._events) : [];
};
function O2(s, t) {
  for (var e = new Array(t), n2 = 0; n2 < t; ++n2)
    e[n2] = s[n2];
  return e;
}
function F(s, t) {
  for (; t + 1 < s.length; t++)
    s[t] = s[t + 1];
  s.pop();
}
function z(s) {
  for (var t = new Array(s.length), e = 0; e < t.length; ++e)
    t[e] = s[e].listener || s[e];
  return t;
}
function K2(s, t) {
  return new Promise(function(e, n2) {
    function i2(r) {
      s.removeListener(t, a3), n2(r);
    }
    function a3() {
      typeof s.removeListener == "function" && s.removeListener("error", i2), e([].slice.call(arguments));
    }
    R(s, t, a3, { once: true }), t !== "error" && U(s, i2, { once: true });
  });
}
function U(s, t, e) {
  typeof s.on == "function" && R(s, "error", t, e);
}
function R(s, t, e, n2) {
  if (typeof s.on == "function")
    n2.once ? s.once(t, e) : s.on(t, e);
  else if (typeof s.addEventListener == "function")
    s.addEventListener(t, function i2(a3) {
      n2.once && s.removeEventListener(t, i2), e(a3);
    });
  else
    throw new TypeError('The "emitter" argument must be of type EventEmitter. Received type ' + typeof s);
}
const p2 = "Web3Wallet";
class x {
  constructor(t) {
    this.opts = t;
  }
}
class P {
  constructor(t) {
    this.client = t;
  }
}
var V2 = Object.defineProperty, B2 = Object.defineProperties, J = Object.getOwnPropertyDescriptors, q = Object.getOwnPropertySymbols, Y = Object.prototype.hasOwnProperty, Z = Object.prototype.propertyIsEnumerable, j = (s, t, e) => t in s ? V2(s, t, { enumerable: true, configurable: true, writable: true, value: e }) : s[t] = e, ee = (s, t) => {
  for (var e in t || (t = {}))
    Y.call(t, e) && j(s, e, t[e]);
  if (q)
    for (var e of q(t))
      Z.call(t, e) && j(s, e, t[e]);
  return s;
}, te = (s, t) => B2(s, J(t));
class se extends P {
  constructor(t) {
    super(t), this.init = async () => {
      this.signClient = await os.init({ core: this.client.core, metadata: this.client.metadata }), this.authClient = await zr.init({ core: this.client.core, projectId: "", metadata: this.client.metadata });
    }, this.pair = async (e) => {
      await this.client.core.pairing.pair(e);
    }, this.approveSession = async (e) => {
      const { topic: n2, acknowledged: i2 } = await this.signClient.approve(te(ee({}, e), { id: e.id, namespaces: e.namespaces, sessionProperties: e.sessionProperties, sessionConfig: e.sessionConfig }));
      return await i2(), this.signClient.session.get(n2);
    }, this.rejectSession = async (e) => await this.signClient.reject(e), this.updateSession = async (e) => await this.signClient.update(e), this.extendSession = async (e) => await this.signClient.extend(e), this.respondSessionRequest = async (e) => await this.signClient.respond(e), this.disconnectSession = async (e) => await this.signClient.disconnect(e), this.emitSessionEvent = async (e) => await this.signClient.emit(e), this.getActiveSessions = () => this.signClient.session.getAll().reduce((e, n2) => (e[n2.topic] = n2, e), {}), this.getPendingSessionProposals = () => this.signClient.proposal.getAll(), this.getPendingSessionRequests = () => this.signClient.getPendingSessionRequests(), this.respondAuthRequest = async (e, n2) => await this.authClient.respond(e, n2), this.getPendingAuthRequests = () => this.authClient.requests.getAll().filter((e) => "requester" in e), this.formatMessage = (e, n2) => this.authClient.formatMessage(e, n2), this.approveSessionAuthenticate = async (e) => await this.signClient.approveSessionAuthenticate(e), this.rejectSessionAuthenticate = async (e) => await this.signClient.rejectSessionAuthenticate(e), this.formatAuthMessage = (e) => this.signClient.formatAuthMessage(e), this.registerDeviceToken = (e) => this.client.core.echoClient.registerDeviceToken(e), this.on = (e, n2) => (this.setEvent(e, "on"), this.client.events.on(e, n2)), this.once = (e, n2) => (this.setEvent(e, "once"), this.client.events.once(e, n2)), this.off = (e, n2) => (this.setEvent(e, "off"), this.client.events.off(e, n2)), this.removeListener = (e, n2) => (this.setEvent(e, "removeListener"), this.client.events.removeListener(e, n2)), this.onSessionRequest = (e) => {
      this.client.events.emit("session_request", e);
    }, this.onSessionProposal = (e) => {
      this.client.events.emit("session_proposal", e);
    }, this.onSessionDelete = (e) => {
      this.client.events.emit("session_delete", e);
    }, this.onAuthRequest = (e) => {
      this.client.events.emit("auth_request", e);
    }, this.onProposalExpire = (e) => {
      this.client.events.emit("proposal_expire", e);
    }, this.onSessionRequestExpire = (e) => {
      this.client.events.emit("session_request_expire", e);
    }, this.onSessionRequestAuthenticate = (e) => {
      this.client.events.emit("session_authenticate", e);
    }, this.setEvent = (e, n2) => {
      switch (e) {
        case "session_request":
          this.signClient.events[n2]("session_request", this.onSessionRequest);
          break;
        case "session_proposal":
          this.signClient.events[n2]("session_proposal", this.onSessionProposal);
          break;
        case "session_delete":
          this.signClient.events[n2]("session_delete", this.onSessionDelete);
          break;
        case "auth_request":
          this.authClient[n2]("auth_request", this.onAuthRequest);
          break;
        case "proposal_expire":
          this.signClient.events[n2]("proposal_expire", this.onProposalExpire);
          break;
        case "session_request_expire":
          this.signClient.events[n2]("session_request_expire", this.onSessionRequestExpire);
          break;
        case "session_authenticate":
          this.signClient.events[n2]("session_authenticate", this.onSessionRequestAuthenticate);
          break;
      }
    }, this.signClient = {}, this.authClient = {};
  }
}
const ne2 = { decryptMessage: async (s) => {
  const t = { core: new Br$1({ storageOptions: s.storageOptions, storage: s.storage }) };
  await t.core.crypto.init();
  const e = t.core.crypto.decode(s.topic, s.encryptedMessage);
  return t.core = null, e;
}, getMetadata: async (s) => {
  const t = { core: new Br$1({ storageOptions: s.storageOptions, storage: s.storage }), sessionStore: null };
  t.sessionStore = new ns(t.core, t.core.logger), await t.sessionStore.init();
  const e = t.sessionStore.get(s.topic), n2 = e == null ? void 0 : e.peer.metadata;
  return t.core = null, t.sessionStore = null, n2;
} }, T = class extends x {
  constructor(s) {
    super(s), this.events = new l.exports(), this.on = (t, e) => this.engine.on(t, e), this.once = (t, e) => this.engine.once(t, e), this.off = (t, e) => this.engine.off(t, e), this.removeListener = (t, e) => this.engine.removeListener(t, e), this.pair = async (t) => {
      try {
        return await this.engine.pair(t);
      } catch (e) {
        throw this.logger.error(e.message), e;
      }
    }, this.approveSession = async (t) => {
      try {
        return await this.engine.approveSession(t);
      } catch (e) {
        throw this.logger.error(e.message), e;
      }
    }, this.rejectSession = async (t) => {
      try {
        return await this.engine.rejectSession(t);
      } catch (e) {
        throw this.logger.error(e.message), e;
      }
    }, this.updateSession = async (t) => {
      try {
        return await this.engine.updateSession(t);
      } catch (e) {
        throw this.logger.error(e.message), e;
      }
    }, this.extendSession = async (t) => {
      try {
        return await this.engine.extendSession(t);
      } catch (e) {
        throw this.logger.error(e.message), e;
      }
    }, this.respondSessionRequest = async (t) => {
      try {
        return await this.engine.respondSessionRequest(t);
      } catch (e) {
        throw this.logger.error(e.message), e;
      }
    }, this.disconnectSession = async (t) => {
      try {
        return await this.engine.disconnectSession(t);
      } catch (e) {
        throw this.logger.error(e.message), e;
      }
    }, this.emitSessionEvent = async (t) => {
      try {
        return await this.engine.emitSessionEvent(t);
      } catch (e) {
        throw this.logger.error(e.message), e;
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
    }, this.respondAuthRequest = async (t, e) => {
      try {
        return await this.engine.respondAuthRequest(t, e);
      } catch (n2) {
        throw this.logger.error(n2.message), n2;
      }
    }, this.getPendingAuthRequests = () => {
      try {
        return this.engine.getPendingAuthRequests();
      } catch (t) {
        throw this.logger.error(t.message), t;
      }
    }, this.formatMessage = (t, e) => {
      try {
        return this.engine.formatMessage(t, e);
      } catch (n2) {
        throw this.logger.error(n2.message), n2;
      }
    }, this.registerDeviceToken = (t) => {
      try {
        return this.engine.registerDeviceToken(t);
      } catch (e) {
        throw this.logger.error(e.message), e;
      }
    }, this.approveSessionAuthenticate = (t) => {
      try {
        return this.engine.approveSessionAuthenticate(t);
      } catch (e) {
        throw this.logger.error(e.message), e;
      }
    }, this.rejectSessionAuthenticate = (t) => {
      try {
        return this.engine.rejectSessionAuthenticate(t);
      } catch (e) {
        throw this.logger.error(e.message), e;
      }
    }, this.formatAuthMessage = (t) => {
      try {
        return this.engine.formatAuthMessage(t);
      } catch (e) {
        throw this.logger.error(e.message), e;
      }
    }, this.metadata = s.metadata, this.name = s.name || p2, this.core = s.core, this.logger = this.core.logger, this.engine = new se(this);
  }
  static async init(s) {
    const t = new T(s);
    return await t.initialize(), t;
  }
  async initialize() {
    this.logger.trace("Initialized");
    try {
      await this.engine.init(), this.logger.info("Web3Wallet Initialization Success");
    } catch (s) {
      throw this.logger.info("Web3Wallet Initialization Failure"), this.logger.error(s.message), s;
    }
  }
};
let v2 = T;
v2.notifications = ne2;
const ie2 = v2;
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
  var _a2, _b, _c, _d, _e2, _f2;
  if (memoryObject.wcId !== dbObject.wcId || ((_a2 = memoryObject.session) == null ? void 0 : _a2.topic) !== ((_b = dbObject.session) == null ? void 0 : _b.topic)) {
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
      memoryObject.session.expiry = (_f2 = dbObject.session) == null ? void 0 : _f2.expiry;
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
const dbMap = networkIdList.reduce((o2, n2) => {
  o2[n2] = null;
  return o2;
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
  for (let i2 = walletConnectDBList.length - 1; i2 >= 0; i2--) {
    const data = walletConnectDBList[i2];
    if (!dbEntryList.some((item) => item.wcId === data.wcId)) {
      walletConnectDBList.splice(i2, 1);
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
    var _a2;
    return ((_a2 = wc.session) == null ? void 0 : _a2.topic) === topic;
  }) ?? null;
};
const getWalletConnectByPubKey = (pubKey) => {
  return walletConnectDBList.find((wc) => {
    var _a2;
    return ((_a2 = wc.proposal) == null ? void 0 : _a2.params.proposer.publicKey) === pubKey;
  }) ?? null;
};
const getWalletConnectBySession = (session) => {
  return walletConnectDBList.find((wc) => {
    var _a2;
    return (_a2 = wc.oldSessions) == null ? void 0 : _a2.find((dbSession) => dbSession.session === session);
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
          this.core = new Br$1({
            projectId: eternlProjectId,
            logger: "info"
          });
        }
        this.web3wallet = await ie2.init({
          core: this.core,
          metadata: this.metadata
        });
        this.web3wallet.core.pairing.events.on("pairing_delete", ({ _id, _topic }) => {
          if (this.doLog)
            console.log("EVENT pairing_delete");
        });
        this.web3wallet.core.pairing.events.on("pairing_expire", ({ _id, _topic }) => {
          if (this.doLog)
            console.log("EVENT pairing_expire");
        });
        this.web3wallet.core.pairing.events.on("pairing_ping", ({ _id, _topic }) => {
          if (this.doLog)
            console.log("EVENT pairing_ping");
        });
        this.web3wallet.core.pairing.events.on("pairing_delete", ({ _id, _topic }) => {
          if (this.doLog)
            console.log("EVENT pairing_delete");
        });
        setInterval(async () => {
          var _a2, _b, _c, _d, _e2, _f2, _g, _h, _i2;
          const authRQ = (_a2 = this.web3wallet) == null ? void 0 : _a2.getPendingAuthRequests();
          const authSR = (_b = this.web3wallet) == null ? void 0 : _b.getPendingSessionRequests();
          const authSP = (_c = this.web3wallet) == null ? void 0 : _c.getPendingSessionProposals();
          if (authSP && Object.keys(authSP).length > 0) {
            if (this.doLog)
              console.log("pending session proposal requests:", authSP);
            for (const propsalName in authSP) {
              const proposal = authSP[propsalName];
              if (!proposal) {
                if (this.doLog)
                  console.log("no proposal found", propsalName);
                continue;
              }
              if (this.doLog)
                console.log("pubkey for session request proposer:", authSP[propsalName].proposer.publicKey);
              let wcInfo = getWalletConnectConnection(proposal.pairingTopic);
              if (!wcInfo) {
                wcInfo = getWalletConnectByPubKey(proposal.proposer.publicKey);
              }
              if (proposal.pairingTopic && !wcInfo) {
                wcInfo = getWalletConnectBySession(proposal.pairingTopic);
                if (wcInfo) {
                  if (this.doLog)
                    console.log("found by old session topic!");
                }
              }
              if (!wcInfo) {
                await ((_d = this.web3wallet) == null ? void 0 : _d.rejectSession({
                  id: proposal.id,
                  reason: tr$2("UNSUPPORTED_ACCOUNTS")
                }));
                throw new Error("authSP: No wallet connect instance found for proposal " + proposal.pairingTopic + "/pub: " + proposal.proposer.publicKey + " session:" + proposal.sessionProperties);
              }
              if (!wcInfo.approved) {
                if (this.doLog)
                  console.log("got auth request from non approved connection. Wait for allowance", proposal);
                continue;
              }
              if (proposal.requiredNamespaces["cip34"].chains) {
                const chain = proposal.requiredNamespaces["cip34"].chains[0];
                const magic = chain.split("-")[1];
                if (magic === "1" && networkId.value !== "preprod" || magic === "2" && networkId.value !== "preview" || magic === "764824073" && networkId.value !== "mainnet") {
                  await ((_e2 = this.web3wallet) == null ? void 0 : _e2.rejectSession({
                    id: proposal.id,
                    reason: tr$2("UNSUPPORTED_CHAINS")
                  }));
                  if (wcInfo) {
                    await removeWalletConnectInfo(wcInfo);
                  }
                  return;
                }
              }
              const { accountData } = useWalletAccount(ref(wcInfo.walletId), ref(wcInfo.accountId));
              const stakeKey = (_f2 = accountData.value) == null ? void 0 : _f2.keys.stake[0].cred;
              const stakeInfoKey = getRewardAddressFromCred(stakeKey, networkId.value);
              const namespace = this.buildApprovedNamespace(proposal, stakeInfoKey);
              if (this.doLog)
                console.log("try to approve auth request with:", proposal.id, namespace);
              try {
                let session = await this.web3wallet.approveSession({
                  id: proposal.id,
                  namespaces: namespace
                });
                if (this.doLog)
                  console.log("created session", session);
                if (this.doLog)
                  console.log("active sessions:", (_g = this.web3wallet) == null ? void 0 : _g.getActiveSessions());
                if (session) {
                  if (this.doLog)
                    console.log("session session.pairingTopic", session.pairingTopic);
                  const dbInfo = getWalletConnectConnection(session.pairingTopic);
                  if (!dbInfo) {
                    if (this.doLog)
                      console.log("no db info found for created pairing", session.pairingTopic);
                    continue;
                  }
                  dbInfo.active = true;
                  if (this.doLog)
                    console.log("OLD topic:", (_h = dbInfo.session) == null ? void 0 : _h.topic);
                  if (this.doLog)
                    console.log("NEW topic:", session.topic);
                  if ((_i2 = dbInfo.session) == null ? void 0 : _i2.topic) {
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
                      let b3 = entry.expiry * 1e3 >= now();
                      if (!b3) {
                        if (this.doLog)
                          console.log("REMOVE OLD SESSION", entry);
                      }
                      return b3;
                    });
                  }
                  if (!dbInfo.session) {
                    if (this.doLog)
                      console.log("NO OLD session info found!", session);
                  }
                  dbInfo.session.topic = session.topic;
                  await saveWalletConnect(dbInfo);
                } else {
                  console.log("NO SESSION WAS FOUND");
                }
                delete authSP[propsalName];
                if (this.doLog)
                  console.log("deleted", authSP);
              } catch (error2) {
                if (this.doLog)
                  console.log("error in delete", error2, authSP);
              }
            }
          }
          if (authSR && Object.keys(authSR).length > 0) {
            if (this.doLog)
              console.log("pending session requests:", authSR);
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
                if (this.doLog)
                  console.log("cannot respond to", proposal, "as no db info found");
                continue;
              }
              if (this.doLog)
                console.log("checking session proposal!", proposal, dbInfo);
              const {
                accountData,
                walletData,
                appAccount,
                appWallet
              } = useWalletAccount(ref(dbInfo.walletId), ref(dbInfo.accountId));
              if (!accountData || !accountData.value || !walletData || !walletData.value) {
                if (this.doLog)
                  console.log("no account or wallet found");
                continue;
              }
              if (this.doLog)
                console.log("RQ proposal is:", proposal);
              const response = await this.getRequestResponse(proposal.params.request, appAccount.value, appWallet.value);
              if (this.doLog)
                console.log("response is", response);
              try {
                await this.web3wallet.respondSessionRequest({
                  topic: proposal.topic,
                  response: {
                    id: proposal.id,
                    jsonrpc: proposal.params.request.method,
                    result: response
                  }
                });
              } catch (e) {
                if (this.doLog)
                  console.log("Error in responding to session request from:", proposal, e);
              }
            }
          }
          if (authRQ && Object.keys(authRQ).length > 0) {
            if (this.doLog)
              console.log("pending auth request:", authRQ);
            for (const sessionProposalName in authRQ) {
              const proposal = authRQ[sessionProposalName];
              if (this.doLog)
                console.log("checking pending auth request!", proposal);
            }
          }
        }, 1e3);
      }
      if (this.doLog)
        console.log("active connections ", this.web3wallet.getActiveSessions());
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
      for (const name in namespace) {
        newNamespace[name] = {
          chains: allowedChains,
          //namespace[name].chains ?? [],
          methods: namespace[name].methods,
          events: namespace[name].events,
          accounts: [accountId]
        };
      }
      let params1 = {
        proposal: params,
        supportedNamespaces: newNamespace
      };
      if (this.doLog)
        console.log("approve namespace for build approve", params1);
      return Lu(params1);
    });
    __publicField(this, "extendSession", async (topic) => {
      var _a2;
      if (!this.web3wallet) {
        await this.initWallet();
      }
      const wcInfo = getWalletConnectByTopic(topic);
      if (!wcInfo) {
        throw new Error(`No WalletConnect db instance found. (topic: ${topic} )`);
      }
      if (this.doLog)
        console.log("active pairings in extendSession", (_a2 = this.web3wallet) == null ? void 0 : _a2.core.pairing.getPairings());
      return await this.web3wallet.extendSession({ topic }).catch(async (e) => {
        if (this.doLog)
          console.log("--- Error extending session", e);
        if (e.message && e.message.includes("No matching key. session topic doesn't exist: ")) {
          if (this.doLog)
            console.log("It seems the DApp is closed ?", topic);
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
      var _a2;
      if (!this.web3wallet) {
        await this.initWallet();
      }
      const sessionNamespace = this.buildApprovedNamespace(info.proposal.params, stakeKey);
      await this.web3wallet.updateSession({ topic: (_a2 = info == null ? void 0 : info.session) == null ? void 0 : _a2.topic, namespaces: sessionNamespace });
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
      } catch (e) {
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
      if (this.doLog)
        console.log("info from db is", info);
      if (this.doLog)
        console.log("activate session with", info == null ? void 0 : info.wcId);
      const aR = await this.web3wallet.core.pairing.activate({ topic: info == null ? void 0 : info.wcId });
      if (this.doLog)
        console.log("aR", aR);
    });
    __publicField(this, "eventsAdded", false);
    __publicField(this, "addEventListeners", () => {
      if (!this.web3wallet) {
        if (this.doLog)
          console.log("no web3 wallet found");
        return;
      }
      if (this.eventsAdded)
        return;
      this.web3wallet.on("session_delete", async (state) => {
        if (this.doLog)
          console.log("Session session_delete: ", state);
        const info = getWalletConnectByTopic(state.topic);
        if (info) {
          if (this.doLog)
            console.log("session delete closes", info);
          info.active = false;
          await saveWalletConnect(info);
        } else {
          if (this.doLog)
            console.log("no session found to close");
        }
      });
      this.web3wallet.on("auth_request", (state) => {
        if (this.doLog)
          console.log("Session auth_request: ", state);
      });
      this.web3wallet.on("session_proposal", async (proposal) => {
        if (this.doLog)
          console.log("on session_proposal", proposal);
        const confirmCallback = async (confirmed) => {
          var _a2, _b;
          if (this.doLog)
            console.log("confirm callback was called", confirmed);
          const wcInfo = getWalletConnectConnection(proposal.params.pairingTopic);
          if (!wcInfo) {
            throw new Error("session_proposal: No wallet connect instance found for proposal " + proposal.params.pairingTopic);
          }
          const { accountData } = useWalletAccount(ref(wcInfo.walletId), ref(wcInfo.accountId));
          const stakeKey = (_a2 = accountData.value) == null ? void 0 : _a2.keys.stake[0].cred;
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
            if (this.doLog)
              console.log("in ExtWalletConnect connection was accepted");
            if (this.web3wallet) {
              if (this.doLog)
                console.log("approve proposal information", wcInfo);
              if (!sessionNamespace) {
                if (this.doLog)
                  console.log("No session namespace found!");
                return;
              }
              setTimeout(async () => {
                var _a3, _b2;
                let session = null;
                try {
                  if (this.doLog)
                    console.log("before namespace", {
                      id: proposal.id,
                      namespaces: sessionNamespace
                    });
                  if (this.doLog)
                    console.log("before approve session, list:", (_a3 = this.web3wallet) == null ? void 0 : _a3.core.pairing.getPairings());
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
                } catch (e) {
                  if (this.doLog)
                    console.log("e15 error", e);
                }
                if (this.doLog)
                  console.log("2 after approve session, list:", (_b2 = this.web3wallet) == null ? void 0 : _b2.core.pairing.getPairings());
                if (this.doLog)
                  console.log("BBBB");
                await saveWalletConnect(wcInfo);
                if (this.doLog) {
                  console.log("approve result, session:", session);
                  console.log("approve result, wcInfo:", wcInfo);
                }
              }, 500);
            } else {
              if (this.doLog)
                console.log("web 3 wallet is null");
            }
          } else {
            if (this.doLog)
              console.log("user declined the connect");
            wcInfo.approved = false;
            wcInfo.connectError = "Session approval was rejected.";
            await ((_b = this.web3wallet) == null ? void 0 : _b.rejectSession({
              id: proposal.id,
              reason: tr$2("USER_REJECTED")
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
          if (this.doLog)
            console.log("cardano_signTx request is", request);
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
          } catch (e) {
            console.error(e);
            result = {
              success: false,
              error: e
            };
          }
          break;
        case "cardano_signData":
          if (this.doLog)
            console.log("cardano_signData request is", request);
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
          } catch (e) {
            result = {
              success: false,
              error: e
            };
          }
          break;
        case "cardano_submitTx":
          if (this.doLog)
            console.log("cardano_submitTx request is", request);
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
          if (this.doLog)
            console.log("utxos are", result);
          break;
        case "cardano_getNetworkId":
          result = cip30_getNetworkId(this.networkId) ?? 1;
          break;
        case "cardano_getUsedAddresses":
          if (this.doLog)
            console.log("");
          result = cip30_getUsedAddresses(account, {
            page: 0,
            limit: 10
          });
          break;
        case "cardano_getUnusedAddresses":
          result = cip30_getUnusedAddresses(account);
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
      if (this.doLog)
        console.log("RESULT:", result);
      return result;
    });
    __publicField(this, "connect", async (dAppIdentifier) => {
      if (this.doLog)
        console.log("in WalletConnect connect", dAppIdentifier);
      if (!this.web3wallet) {
        await this.initWallet();
      }
      this.addEventListeners();
      const res = await this.web3wallet.core.pairing.pair({ uri: dAppIdentifier, activatePairing: true });
      if (this.doLog)
        console.log("pairing response is", res);
      if (!res.active) {
        if (this.doLog)
          console.log("Try activating old pairing!");
        await this.activate(res.topic);
      }
    });
    __publicField(this, "disconnect", async (wcInfo, terminatePairing = false) => {
      var _a2, _b;
      if (!this.web3wallet) {
        if (this.doLog)
          console.log("No wallet connect instance found, can not disconnect.");
        return;
      }
      if ((_a2 = wcInfo == null ? void 0 : wcInfo.session) == null ? void 0 : _a2.topic) {
        if (this.doLog)
          console.log("calling disconnect with", wcInfo == null ? void 0 : wcInfo.session);
        try {
          const res = await this.web3wallet.disconnectSession({
            topic: wcInfo.session.topic,
            reason: tr$2("USER_DISCONNECTED")
          });
          if (terminatePairing) {
            (_b = this.web3wallet) == null ? void 0 : _b.core.pairing.disconnect({ topic: wcInfo.wcId });
          }
          if (this.doLog)
            console.log("response of disconnect", res);
        } catch (e) {
          if (this.doLog)
            console.log("Error in disconnect", e);
        }
      } else {
        if (this.doLog)
          console.log("No session info found, can not disconnect.", wcInfo.wcId);
      }
    });
    this.core = new Br$1({ projectId });
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
  var _a2, _b, _c, _d, _e2;
  const storeId2 = "useWalletConnect" + getRandomId();
  if (!walletConnectId.value)
    return;
  const walletConnectInfo = ref(getWalletConnectConnection(walletConnectId.value));
  const walletId = computed(() => {
    var _a3;
    return ((_a3 = walletConnectInfo.value) == null ? void 0 : _a3.walletId) ?? null;
  });
  const accountId = computed(() => {
    var _a3;
    return ((_a3 = walletConnectInfo.value) == null ? void 0 : _a3.accountId) ?? null;
  });
  let walletName = "";
  let accountName = "";
  if (walletConnectInfo.value && walletConnectInfo.value) {
    const {
      walletData,
      accountData
    } = useWalletAccount(walletId, accountId);
    walletName = ((_a2 = walletData.value) == null ? void 0 : _a2.settings.name) ?? ((_c = (_b = walletData.value) == null ? void 0 : _b.wallet.legacySettings) == null ? void 0 : _c.name) ?? "unknown wallet";
    accountName = ((_d = accountData.value) == null ? void 0 : _d.settings.name) ?? "Account #" + String((_e2 = accountData.value) == null ? void 0 : _e2.keys.path[2]) ?? "unknown account";
  }
  const update2 = (id) => {
    walletConnectInfo.value = getWalletConnectConnection(id);
  };
  const saveConnectionStatus = async (connected) => {
    var _a3;
    console.log("setting connection status", (_a3 = walletConnectInfo.value) == null ? void 0 : _a3.wcId, connected);
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
      var _a2;
      this.log("inject new api for", wcInfo);
      const stakeKey = accountData.keys.stake[0] ?? null;
      if (!stakeKey) {
        return;
      }
      const stakeInfoKey = getRewardAddressFromCred(stakeKey.cred, networkId.value);
      await ((_a2 = this.walletConnect) == null ? void 0 : _a2.emitSessionAccountChangeEvent(wcInfo, stakeInfoKey));
    });
    /**
     * Calls disconnect on the wallet connect instance
     * @param wcIdentifier
     * @param terminatePairing
     */
    __publicField(this, "disconnect", async (wcIdentifier, terminatePairing = false) => {
      var _a2, _b, _c, _d;
      const info = (_a2 = useWalletConnect(ref(wcIdentifier))) == null ? void 0 : _a2.walletConnectInfo;
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
      } catch (e) {
        this.log("error in wallet connect disconnect", e);
      } finally {
        info.value.active = false;
        await saveWalletConnect(info.value);
      }
    });
    __publicField(this, "deleteConnection", async (peerInfo) => {
      try {
        await this.disconnect(peerInfo.wcId, true);
      } catch (e) {
      } finally {
        await removeWalletConnectInfo(peerInfo);
      }
    });
    __publicField(this, "notify", (dappId, name = null, message, type = "positive", extraTimeout = 0) => {
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
            if (this.debug)
              console.log("No frontend connection found.");
            return;
          }
          const newNotify = this.quasar.notify({
            progress: type === "ongoing",
            type,
            message: name ?? "",
            caption: message,
            position: "top-left",
            timeout: timeoutDelay
          });
          this.notifyIds.set(dappId, newNotify);
        } else {
          oldNotify({
            progress: type === "ongoing",
            type,
            message: name ?? "",
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
          if (this.debug)
            console.log("No frontend connection found.");
          return;
        }
        const newNotify = this.quasar.notify({
          progress: type === "ongoing",
          type,
          message: name ?? "",
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
      var _a2, _b, _c, _d;
      this.log("calling initConnection", networkId2, wallet, account, connectionParams);
      let wcInfo = (_a2 = useWalletConnect(ref(connectionParams.id))) == null ? void 0 : _a2.walletConnectInfo.value;
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
      var _a2, _b;
      this.log("update session", networkId2, wallet, account, connectionInfo, stakeKey);
      if (!this.walletConnect) {
        this.initWalletConnect(networkId2);
      }
      try {
        this.log("try to update session topic", connectionInfo);
        const res2 = await this.walletConnect.updateSession(((_a2 = connectionInfo.proposal) == null ? void 0 : _a2.params.pairingTopic) ?? ((_b = connectionInfo.session) == null ? void 0 : _b.topic), connectionInfo.proposal, stakeKey);
        this.log("res of update session ", res2);
      } catch (e2) {
        this.log("error in update session", e2);
      }
    });
    __publicField(this, "changeWallet", async (networkId2, wallet, account, connectionInfo, stakeKey) => {
      var _a2, _b;
      this.log("update session", networkId2, wallet, account, connectionInfo, stakeKey);
      if (!this.walletConnect) {
        this.initWalletConnect(networkId2);
      }
      try {
        this.log("try to update session topic", connectionInfo);
        const res2 = await this.walletConnect.updateSession(((_a2 = connectionInfo.proposal) == null ? void 0 : _a2.params.pairingTopic) ?? ((_b = connectionInfo.session) == null ? void 0 : _b.topic), connectionInfo.proposal, stakeKey);
        this.log("res of update session ", res2);
      } catch (e2) {
        console.error("error in update session", e2);
      }
    });
    __publicField(this, "ping", async (networkId2, connectionInfo, stakeKey) => {
      var _a2, _b, _c;
      this.log("update session", networkId2, connectionInfo, stakeKey);
      if (!this.walletConnect) {
        this.initWalletConnect(networkId2);
      }
      try {
        this.log("try to ping: topic", connectionInfo);
        const res2 = await this.walletConnect.ping((_a2 = connectionInfo.session) == null ? void 0 : _a2.topic);
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
        var _a2, _b, _c, _d, _e2;
        if (!this.pingAttempts[key2]) {
          this.pingAttempts[key2] = 1;
        } else {
          this.pingAttempts[key2] = this.pingAttempts[key2] + 1;
        }
        if (this.managerInitializing.value) {
          this.log("wait for manager to initialize");
          return;
        }
        this.log("try to ping", peers[key2].wcId, (_a2 = peers[key2].session) == null ? void 0 : _a2.topic);
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
        } catch (e) {
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
    var _a2;
    let value = walletConnectDBList;
    if (value && value.length === 0)
      return;
    this.log("disconnectAll current peer connections", value);
    await disconnectAllConnections(this.networkId, value.reduce((ids, peer) => {
      ids.push(peer.wcId);
      return ids;
    }, []));
    for (const valueKey in value) {
      this.log("disconnect key:", value[valueKey]);
      (_a2 = this.walletConnect) == null ? void 0 : _a2.disconnect(value[valueKey]);
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
