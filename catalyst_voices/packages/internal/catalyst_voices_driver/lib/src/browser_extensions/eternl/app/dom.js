var __defProp = Object.defineProperty;
var __defNormalProp = (obj, key, value) => key in obj ? __defProp(obj, key, { enumerable: true, configurable: true, writable: true, value }) : obj[key] = value;
var __publicField = (obj, key, value) => __defNormalProp(obj, typeof key !== "symbol" ? key + "" : key, value);
(function() {
  "use strict";
  const ensureLength = (str, length, char = " ", right = true) => {
    let i = 0;
    while (str.length < length && i++ < 100) {
      if (right) {
        str = char + str;
      } else {
        str = str + char;
      }
    }
    return str;
  };
  const el = (msg, length = 30, space = " ") => ensureLength(msg, length, space);
  const sl = (msg, length = 30, space = " ") => el(msg, length, space);
  var ApiChannel = /* @__PURE__ */ ((ApiChannel2) => {
    ApiChannel2["domToCS"] = "eternl-dom-to-cs";
    ApiChannel2["csToDom"] = "eternl-cs-to-dom";
    ApiChannel2["csToBg"] = "eternl-cs-to-bg";
    ApiChannel2["bgToCs"] = "eternl-bg-to-cs";
    ApiChannel2["bgToEnable"] = "eternl-bg-to-enable";
    ApiChannel2["enableToBg"] = "eternl-enable-to-bg";
    ApiChannel2["bgToSignTx"] = "eternl-bg-to-sign-tx";
    ApiChannel2["signTxToBg"] = "eternl-sign-tx-to-bg";
    ApiChannel2["bgToSignData"] = "eternl-bg-to-sign-data";
    ApiChannel2["signDataToBg"] = "eternl-sign-data-to-bg";
    ApiChannel2["bgToSync"] = "eternl-bg-to-sync";
    ApiChannel2["syncToBg"] = "eternl-sync-to-bg";
    return ApiChannel2;
  })(ApiChannel || {});
  const appVersion = {
    major: 1,
    minor: 12,
    patch: 18,
    build: 1
  };
  "v" + appVersion.major + "." + appVersion.minor + "." + appVersion.patch;
  "v" + appVersion.major + "." + appVersion.minor + "." + appVersion.patch + "." + appVersion.build;
  const getRandomId = () => Math.floor(Math.random() * 999999) + "-" + Math.floor(Math.random() * 999999) + "-" + Math.floor(Math.random() * 999999);
  const extCip30 = { cip: 30 };
  const extCip95 = { cip: 95 };
  const extCip103 = { cip: 103 };
  const extCip104 = { cip: 104 };
  const supportedExtensions = [
    extCip30,
    extCip95,
    extCip103,
    extCip104
  ];
  const METHOD = {
    enable: "enable",
    isEnabled: "isEnabled",
    getExtensions: "getExtensions",
    getNetworkId: "getNetworkId",
    getBalance: "getBalance",
    getChangeAddress: "getChangeAddress",
    getRewardAddresses: "getRewardAddresses",
    getRewardAddress: "getRewardAddress",
    getUnusedAddresses: "getUnusedAddresses",
    getForcedUnusedAddresses: "getForcedUnusedAddresses",
    getUsedAddresses: "getUsedAddresses",
    getUtxos: "getUtxos",
    getCollateral: "getCollateral",
    getLockedUtxos: "getLockedUtxos",
    signData: "signData",
    signTx: "signTx",
    submitTx: "submitTx",
    syncAccount: "syncAccount",
    enableLogs: "enableLogs",
    // CIP-95
    getPubDRepKey: "getPubDRepKey",
    getRegisteredPubStakeKeys: "getRegisteredPubStakeKeys",
    getUnregisteredPubStakeKeys: "getUnregisteredPubStakeKeys",
    // CIP-103
    signTxs: "signTxs",
    // CIP-104
    getAccountPub: "getAccountPub"
  };
  const DEFAULT_PAGINATE = { page: 0, limit: Number.MAX_SAFE_INTEGER };
  var ApiErrorCode = /* @__PURE__ */ ((ApiErrorCode2) => {
    ApiErrorCode2[ApiErrorCode2["InvalidRequest"] = -1] = "InvalidRequest";
    ApiErrorCode2[ApiErrorCode2["InternalError"] = -2] = "InternalError";
    ApiErrorCode2[ApiErrorCode2["Refused"] = -3] = "Refused";
    ApiErrorCode2[ApiErrorCode2["AccountChange"] = -4] = "AccountChange";
    return ApiErrorCode2;
  })(ApiErrorCode || {});
  var DataSignErrorCode = /* @__PURE__ */ ((DataSignErrorCode2) => {
    DataSignErrorCode2[DataSignErrorCode2["ProofGeneration"] = 1] = "ProofGeneration";
    DataSignErrorCode2[DataSignErrorCode2["AddressNotPK"] = 2] = "AddressNotPK";
    DataSignErrorCode2[DataSignErrorCode2["UserDeclined"] = 3] = "UserDeclined";
    DataSignErrorCode2[DataSignErrorCode2["InvalidFormat"] = 4] = "InvalidFormat";
    return DataSignErrorCode2;
  })(DataSignErrorCode || {});
  var TxSendErrorCode = /* @__PURE__ */ ((TxSendErrorCode2) => {
    TxSendErrorCode2[TxSendErrorCode2["Refused"] = 1] = "Refused";
    TxSendErrorCode2[TxSendErrorCode2["Failure"] = 2] = "Failure";
    return TxSendErrorCode2;
  })(TxSendErrorCode || {});
  var TxSignErrorCode = /* @__PURE__ */ ((TxSignErrorCode2) => {
    TxSignErrorCode2[TxSignErrorCode2["ProofGeneration"] = 1] = "ProofGeneration";
    TxSignErrorCode2[TxSignErrorCode2["UserDeclined"] = 2] = "UserDeclined";
    TxSignErrorCode2[TxSignErrorCode2["DeprecatedCertificate"] = 3] = "DeprecatedCertificate";
    return TxSignErrorCode2;
  })(TxSignErrorCode || {});
  class ApiError extends Error {
    constructor(code, info) {
      super(info);
      __publicField(this, "code");
      __publicField(this, "info");
      this.code = code;
      this.info = info;
    }
  }
  class TxSignError extends Error {
    constructor(code, info) {
      super(info);
      __publicField(this, "code");
      __publicField(this, "info");
      this.code = code;
      this.info = info;
    }
  }
  class TxSendError extends Error {
    constructor(code, info) {
      super(info);
      __publicField(this, "code");
      __publicField(this, "info");
      this.code = code;
      this.info = info;
    }
  }
  class DataSignError extends Error {
    constructor(code, info) {
      super(info);
      __publicField(this, "code");
      __publicField(this, "info");
      this.code = code;
      this.info = info;
    }
  }
  class PaginateError extends Error {
    constructor(maxSize, info) {
      super(info);
      __publicField(this, "maxSize");
      __publicField(this, "info");
      this.maxSize = maxSize;
      this.info = info;
    }
  }
  let doLogAll = false;
  const enableLogs = (enable2) => {
    doLogAll = enable2;
  };
  var AppType = /* @__PURE__ */ ((AppType2) => {
    AppType2["unknown"] = "0";
    AppType2["spa"] = "1";
    AppType2["pwa"] = "2";
    AppType2["bex"] = "3";
    AppType2["capacitor"] = "4";
    AppType2["electron"] = "5";
    return AppType2;
  })(AppType || {});
  var AppMode = /* @__PURE__ */ ((AppMode2) => {
    AppMode2["normal"] = "normal";
    AppMode2["bg"] = "bg";
    AppMode2["offscreen"] = "offscreen";
    AppMode2["enable"] = "enable";
    AppMode2["signTx"] = "signTx";
    AppMode2["signData"] = "signData";
    return AppMode2;
  })(AppMode || {});
  var Platform = /* @__PURE__ */ ((Platform2) => {
    Platform2["unknown"] = "0";
    Platform2["web"] = "1";
    Platform2["ios"] = "2";
    Platform2["android"] = "3";
    Platform2["windows"] = "4";
    Platform2["mac"] = "5";
    Platform2["linux"] = "6";
    return Platform2;
  })(Platform || {});
  var Environment = /* @__PURE__ */ ((Environment2) => {
    Environment2["unknown"] = "unknown";
    Environment2["production"] = "production";
    Environment2["development"] = "development";
    return Environment2;
  })(Environment || {});
  /**
  * @vue/shared v3.5.13
  * (c) 2018-present Yuxi (Evan) You and Vue contributors
  * @license MIT
  **/
  /*! #__NO_SIDE_EFFECTS__ */
  // @__NO_SIDE_EFFECTS__
  function makeMap(str) {
    const map = /* @__PURE__ */ Object.create(null);
    for (const key of str.split(",")) map[key] = 1;
    return (val) => val in map;
  }
  const EMPTY_OBJ = {};
  const NOOP = () => {
  };
  const extend = Object.assign;
  const hasOwnProperty$1 = Object.prototype.hasOwnProperty;
  const hasOwn = (val, key) => hasOwnProperty$1.call(val, key);
  const isArray = Array.isArray;
  const isMap = (val) => toTypeString(val) === "[object Map]";
  const isSet = (val) => toTypeString(val) === "[object Set]";
  const isFunction = (val) => typeof val === "function";
  const isString = (val) => typeof val === "string";
  const isSymbol = (val) => typeof val === "symbol";
  const isObject$1 = (val) => val !== null && typeof val === "object";
  const isPromise = (val) => {
    return (isObject$1(val) || isFunction(val)) && isFunction(val.then) && isFunction(val.catch);
  };
  const objectToString = Object.prototype.toString;
  const toTypeString = (value) => objectToString.call(value);
  const toRawType = (value) => {
    return toTypeString(value).slice(8, -1);
  };
  const isPlainObject = (val) => toTypeString(val) === "[object Object]";
  const isIntegerKey = (key) => isString(key) && key !== "NaN" && key[0] !== "-" && "" + parseInt(key, 10) === key;
  const hasChanged = (value, oldValue) => !Object.is(value, oldValue);
  let _globalThis;
  const getGlobalThis = () => {
    return _globalThis || (_globalThis = typeof globalThis !== "undefined" ? globalThis : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : typeof global !== "undefined" ? global : {});
  };
  /**
  * @vue/reactivity v3.5.13
  * (c) 2018-present Yuxi (Evan) You and Vue contributors
  * @license MIT
  **/
  let activeSub;
  const pausedQueueEffects = /* @__PURE__ */ new WeakSet();
  class ReactiveEffect {
    constructor(fn) {
      this.fn = fn;
      this.deps = void 0;
      this.depsTail = void 0;
      this.flags = 1 | 4;
      this.next = void 0;
      this.cleanup = void 0;
      this.scheduler = void 0;
    }
    pause() {
      this.flags |= 64;
    }
    resume() {
      if (this.flags & 64) {
        this.flags &= ~64;
        if (pausedQueueEffects.has(this)) {
          pausedQueueEffects.delete(this);
          this.trigger();
        }
      }
    }
    /**
     * @internal
     */
    notify() {
      if (this.flags & 2 && !(this.flags & 32)) {
        return;
      }
      if (!(this.flags & 8)) {
        batch(this);
      }
    }
    run() {
      if (!(this.flags & 1)) {
        return this.fn();
      }
      this.flags |= 2;
      cleanupEffect(this);
      prepareDeps(this);
      const prevEffect = activeSub;
      const prevShouldTrack = shouldTrack;
      activeSub = this;
      shouldTrack = true;
      try {
        return this.fn();
      } finally {
        cleanupDeps(this);
        activeSub = prevEffect;
        shouldTrack = prevShouldTrack;
        this.flags &= ~2;
      }
    }
    stop() {
      if (this.flags & 1) {
        for (let link = this.deps; link; link = link.nextDep) {
          removeSub(link);
        }
        this.deps = this.depsTail = void 0;
        cleanupEffect(this);
        this.onStop && this.onStop();
        this.flags &= ~1;
      }
    }
    trigger() {
      if (this.flags & 64) {
        pausedQueueEffects.add(this);
      } else if (this.scheduler) {
        this.scheduler();
      } else {
        this.runIfDirty();
      }
    }
    /**
     * @internal
     */
    runIfDirty() {
      if (isDirty(this)) {
        this.run();
      }
    }
    get dirty() {
      return isDirty(this);
    }
  }
  let batchDepth = 0;
  let batchedSub;
  let batchedComputed;
  function batch(sub, isComputed = false) {
    sub.flags |= 8;
    if (isComputed) {
      sub.next = batchedComputed;
      batchedComputed = sub;
      return;
    }
    sub.next = batchedSub;
    batchedSub = sub;
  }
  function startBatch() {
    batchDepth++;
  }
  function endBatch() {
    if (--batchDepth > 0) {
      return;
    }
    if (batchedComputed) {
      let e = batchedComputed;
      batchedComputed = void 0;
      while (e) {
        const next = e.next;
        e.next = void 0;
        e.flags &= ~8;
        e = next;
      }
    }
    let error;
    while (batchedSub) {
      let e = batchedSub;
      batchedSub = void 0;
      while (e) {
        const next = e.next;
        e.next = void 0;
        e.flags &= ~8;
        if (e.flags & 1) {
          try {
            ;
            e.trigger();
          } catch (err) {
            if (!error) error = err;
          }
        }
        e = next;
      }
    }
    if (error) throw error;
  }
  function prepareDeps(sub) {
    for (let link = sub.deps; link; link = link.nextDep) {
      link.version = -1;
      link.prevActiveLink = link.dep.activeLink;
      link.dep.activeLink = link;
    }
  }
  function cleanupDeps(sub) {
    let head;
    let tail = sub.depsTail;
    let link = tail;
    while (link) {
      const prev = link.prevDep;
      if (link.version === -1) {
        if (link === tail) tail = prev;
        removeSub(link);
        removeDep(link);
      } else {
        head = link;
      }
      link.dep.activeLink = link.prevActiveLink;
      link.prevActiveLink = void 0;
      link = prev;
    }
    sub.deps = head;
    sub.depsTail = tail;
  }
  function isDirty(sub) {
    for (let link = sub.deps; link; link = link.nextDep) {
      if (link.dep.version !== link.version || link.dep.computed && (refreshComputed(link.dep.computed) || link.dep.version !== link.version)) {
        return true;
      }
    }
    if (sub._dirty) {
      return true;
    }
    return false;
  }
  function refreshComputed(computed2) {
    if (computed2.flags & 4 && !(computed2.flags & 16)) {
      return;
    }
    computed2.flags &= ~16;
    if (computed2.globalVersion === globalVersion) {
      return;
    }
    computed2.globalVersion = globalVersion;
    const dep = computed2.dep;
    computed2.flags |= 2;
    if (dep.version > 0 && !computed2.isSSR && computed2.deps && !isDirty(computed2)) {
      computed2.flags &= ~2;
      return;
    }
    const prevSub = activeSub;
    const prevShouldTrack = shouldTrack;
    activeSub = computed2;
    shouldTrack = true;
    try {
      prepareDeps(computed2);
      const value = computed2.fn(computed2._value);
      if (dep.version === 0 || hasChanged(value, computed2._value)) {
        computed2._value = value;
        dep.version++;
      }
    } catch (err) {
      dep.version++;
      throw err;
    } finally {
      activeSub = prevSub;
      shouldTrack = prevShouldTrack;
      cleanupDeps(computed2);
      computed2.flags &= ~2;
    }
  }
  function removeSub(link, soft = false) {
    const { dep, prevSub, nextSub } = link;
    if (prevSub) {
      prevSub.nextSub = nextSub;
      link.prevSub = void 0;
    }
    if (nextSub) {
      nextSub.prevSub = prevSub;
      link.nextSub = void 0;
    }
    if (dep.subs === link) {
      dep.subs = prevSub;
      if (!prevSub && dep.computed) {
        dep.computed.flags &= ~4;
        for (let l = dep.computed.deps; l; l = l.nextDep) {
          removeSub(l, true);
        }
      }
    }
    if (!soft && !--dep.sc && dep.map) {
      dep.map.delete(dep.key);
    }
  }
  function removeDep(link) {
    const { prevDep, nextDep } = link;
    if (prevDep) {
      prevDep.nextDep = nextDep;
      link.prevDep = void 0;
    }
    if (nextDep) {
      nextDep.prevDep = prevDep;
      link.nextDep = void 0;
    }
  }
  let shouldTrack = true;
  const trackStack = [];
  function pauseTracking() {
    trackStack.push(shouldTrack);
    shouldTrack = false;
  }
  function resetTracking() {
    const last = trackStack.pop();
    shouldTrack = last === void 0 ? true : last;
  }
  function cleanupEffect(e) {
    const { cleanup } = e;
    e.cleanup = void 0;
    if (cleanup) {
      const prevSub = activeSub;
      activeSub = void 0;
      try {
        cleanup();
      } finally {
        activeSub = prevSub;
      }
    }
  }
  let globalVersion = 0;
  class Link {
    constructor(sub, dep) {
      this.sub = sub;
      this.dep = dep;
      this.version = dep.version;
      this.nextDep = this.prevDep = this.nextSub = this.prevSub = this.prevActiveLink = void 0;
    }
  }
  class Dep {
    constructor(computed2) {
      this.computed = computed2;
      this.version = 0;
      this.activeLink = void 0;
      this.subs = void 0;
      this.map = void 0;
      this.key = void 0;
      this.sc = 0;
    }
    track(debugInfo) {
      if (!activeSub || !shouldTrack || activeSub === this.computed) {
        return;
      }
      let link = this.activeLink;
      if (link === void 0 || link.sub !== activeSub) {
        link = this.activeLink = new Link(activeSub, this);
        if (!activeSub.deps) {
          activeSub.deps = activeSub.depsTail = link;
        } else {
          link.prevDep = activeSub.depsTail;
          activeSub.depsTail.nextDep = link;
          activeSub.depsTail = link;
        }
        addSub(link);
      } else if (link.version === -1) {
        link.version = this.version;
        if (link.nextDep) {
          const next = link.nextDep;
          next.prevDep = link.prevDep;
          if (link.prevDep) {
            link.prevDep.nextDep = next;
          }
          link.prevDep = activeSub.depsTail;
          link.nextDep = void 0;
          activeSub.depsTail.nextDep = link;
          activeSub.depsTail = link;
          if (activeSub.deps === link) {
            activeSub.deps = next;
          }
        }
      }
      return link;
    }
    trigger(debugInfo) {
      this.version++;
      globalVersion++;
      this.notify(debugInfo);
    }
    notify(debugInfo) {
      startBatch();
      try {
        if (false) ;
        for (let link = this.subs; link; link = link.prevSub) {
          if (link.sub.notify()) {
            ;
            link.sub.dep.notify();
          }
        }
      } finally {
        endBatch();
      }
    }
  }
  function addSub(link) {
    link.dep.sc++;
    if (link.sub.flags & 4) {
      const computed2 = link.dep.computed;
      if (computed2 && !link.dep.subs) {
        computed2.flags |= 4 | 16;
        for (let l = computed2.deps; l; l = l.nextDep) {
          addSub(l);
        }
      }
      const currentTail = link.dep.subs;
      if (currentTail !== link) {
        link.prevSub = currentTail;
        if (currentTail) currentTail.nextSub = link;
      }
      link.dep.subs = link;
    }
  }
  const targetMap = /* @__PURE__ */ new WeakMap();
  const ITERATE_KEY = Symbol(
    ""
  );
  const MAP_KEY_ITERATE_KEY = Symbol(
    ""
  );
  const ARRAY_ITERATE_KEY = Symbol(
    ""
  );
  function track(target, type, key) {
    if (shouldTrack && activeSub) {
      let depsMap = targetMap.get(target);
      if (!depsMap) {
        targetMap.set(target, depsMap = /* @__PURE__ */ new Map());
      }
      let dep = depsMap.get(key);
      if (!dep) {
        depsMap.set(key, dep = new Dep());
        dep.map = depsMap;
        dep.key = key;
      }
      {
        dep.track();
      }
    }
  }
  function trigger(target, type, key, newValue, oldValue, oldTarget) {
    const depsMap = targetMap.get(target);
    if (!depsMap) {
      globalVersion++;
      return;
    }
    const run = (dep) => {
      if (dep) {
        {
          dep.trigger();
        }
      }
    };
    startBatch();
    if (type === "clear") {
      depsMap.forEach(run);
    } else {
      const targetIsArray = isArray(target);
      const isArrayIndex = targetIsArray && isIntegerKey(key);
      if (targetIsArray && key === "length") {
        const newLength = Number(newValue);
        depsMap.forEach((dep, key2) => {
          if (key2 === "length" || key2 === ARRAY_ITERATE_KEY || !isSymbol(key2) && key2 >= newLength) {
            run(dep);
          }
        });
      } else {
        if (key !== void 0 || depsMap.has(void 0)) {
          run(depsMap.get(key));
        }
        if (isArrayIndex) {
          run(depsMap.get(ARRAY_ITERATE_KEY));
        }
        switch (type) {
          case "add":
            if (!targetIsArray) {
              run(depsMap.get(ITERATE_KEY));
              if (isMap(target)) {
                run(depsMap.get(MAP_KEY_ITERATE_KEY));
              }
            } else if (isArrayIndex) {
              run(depsMap.get("length"));
            }
            break;
          case "delete":
            if (!targetIsArray) {
              run(depsMap.get(ITERATE_KEY));
              if (isMap(target)) {
                run(depsMap.get(MAP_KEY_ITERATE_KEY));
              }
            }
            break;
          case "set":
            if (isMap(target)) {
              run(depsMap.get(ITERATE_KEY));
            }
            break;
        }
      }
    }
    endBatch();
  }
  function reactiveReadArray(array) {
    const raw = toRaw(array);
    if (raw === array) return raw;
    track(raw, "iterate", ARRAY_ITERATE_KEY);
    return isShallow(array) ? raw : raw.map(toReactive);
  }
  function shallowReadArray(arr) {
    track(arr = toRaw(arr), "iterate", ARRAY_ITERATE_KEY);
    return arr;
  }
  const arrayInstrumentations = {
    __proto__: null,
    [Symbol.iterator]() {
      return iterator(this, Symbol.iterator, toReactive);
    },
    concat(...args) {
      return reactiveReadArray(this).concat(
        ...args.map((x) => isArray(x) ? reactiveReadArray(x) : x)
      );
    },
    entries() {
      return iterator(this, "entries", (value) => {
        value[1] = toReactive(value[1]);
        return value;
      });
    },
    every(fn, thisArg) {
      return apply(this, "every", fn, thisArg, void 0, arguments);
    },
    filter(fn, thisArg) {
      return apply(this, "filter", fn, thisArg, (v) => v.map(toReactive), arguments);
    },
    find(fn, thisArg) {
      return apply(this, "find", fn, thisArg, toReactive, arguments);
    },
    findIndex(fn, thisArg) {
      return apply(this, "findIndex", fn, thisArg, void 0, arguments);
    },
    findLast(fn, thisArg) {
      return apply(this, "findLast", fn, thisArg, toReactive, arguments);
    },
    findLastIndex(fn, thisArg) {
      return apply(this, "findLastIndex", fn, thisArg, void 0, arguments);
    },
    // flat, flatMap could benefit from ARRAY_ITERATE but are not straight-forward to implement
    forEach(fn, thisArg) {
      return apply(this, "forEach", fn, thisArg, void 0, arguments);
    },
    includes(...args) {
      return searchProxy(this, "includes", args);
    },
    indexOf(...args) {
      return searchProxy(this, "indexOf", args);
    },
    join(separator) {
      return reactiveReadArray(this).join(separator);
    },
    // keys() iterator only reads `length`, no optimisation required
    lastIndexOf(...args) {
      return searchProxy(this, "lastIndexOf", args);
    },
    map(fn, thisArg) {
      return apply(this, "map", fn, thisArg, void 0, arguments);
    },
    pop() {
      return noTracking(this, "pop");
    },
    push(...args) {
      return noTracking(this, "push", args);
    },
    reduce(fn, ...args) {
      return reduce(this, "reduce", fn, args);
    },
    reduceRight(fn, ...args) {
      return reduce(this, "reduceRight", fn, args);
    },
    shift() {
      return noTracking(this, "shift");
    },
    // slice could use ARRAY_ITERATE but also seems to beg for range tracking
    some(fn, thisArg) {
      return apply(this, "some", fn, thisArg, void 0, arguments);
    },
    splice(...args) {
      return noTracking(this, "splice", args);
    },
    toReversed() {
      return reactiveReadArray(this).toReversed();
    },
    toSorted(comparer) {
      return reactiveReadArray(this).toSorted(comparer);
    },
    toSpliced(...args) {
      return reactiveReadArray(this).toSpliced(...args);
    },
    unshift(...args) {
      return noTracking(this, "unshift", args);
    },
    values() {
      return iterator(this, "values", toReactive);
    }
  };
  function iterator(self2, method, wrapValue) {
    const arr = shallowReadArray(self2);
    const iter = arr[method]();
    if (arr !== self2 && !isShallow(self2)) {
      iter._next = iter.next;
      iter.next = () => {
        const result = iter._next();
        if (result.value) {
          result.value = wrapValue(result.value);
        }
        return result;
      };
    }
    return iter;
  }
  const arrayProto = Array.prototype;
  function apply(self2, method, fn, thisArg, wrappedRetFn, args) {
    const arr = shallowReadArray(self2);
    const needsWrap = arr !== self2 && !isShallow(self2);
    const methodFn = arr[method];
    if (methodFn !== arrayProto[method]) {
      const result2 = methodFn.apply(self2, args);
      return needsWrap ? toReactive(result2) : result2;
    }
    let wrappedFn = fn;
    if (arr !== self2) {
      if (needsWrap) {
        wrappedFn = function(item, index) {
          return fn.call(this, toReactive(item), index, self2);
        };
      } else if (fn.length > 2) {
        wrappedFn = function(item, index) {
          return fn.call(this, item, index, self2);
        };
      }
    }
    const result = methodFn.call(arr, wrappedFn, thisArg);
    return needsWrap && wrappedRetFn ? wrappedRetFn(result) : result;
  }
  function reduce(self2, method, fn, args) {
    const arr = shallowReadArray(self2);
    let wrappedFn = fn;
    if (arr !== self2) {
      if (!isShallow(self2)) {
        wrappedFn = function(acc, item, index) {
          return fn.call(this, acc, toReactive(item), index, self2);
        };
      } else if (fn.length > 3) {
        wrappedFn = function(acc, item, index) {
          return fn.call(this, acc, item, index, self2);
        };
      }
    }
    return arr[method](wrappedFn, ...args);
  }
  function searchProxy(self2, method, args) {
    const arr = toRaw(self2);
    track(arr, "iterate", ARRAY_ITERATE_KEY);
    const res = arr[method](...args);
    if ((res === -1 || res === false) && isProxy(args[0])) {
      args[0] = toRaw(args[0]);
      return arr[method](...args);
    }
    return res;
  }
  function noTracking(self2, method, args = []) {
    pauseTracking();
    startBatch();
    const res = toRaw(self2)[method].apply(self2, args);
    endBatch();
    resetTracking();
    return res;
  }
  const isNonTrackableKeys = /* @__PURE__ */ makeMap(`__proto__,__v_isRef,__isVue`);
  const builtInSymbols = new Set(
    /* @__PURE__ */ Object.getOwnPropertyNames(Symbol).filter((key) => key !== "arguments" && key !== "caller").map((key) => Symbol[key]).filter(isSymbol)
  );
  function hasOwnProperty(key) {
    if (!isSymbol(key)) key = String(key);
    const obj = toRaw(this);
    track(obj, "has", key);
    return obj.hasOwnProperty(key);
  }
  class BaseReactiveHandler {
    constructor(_isReadonly = false, _isShallow = false) {
      this._isReadonly = _isReadonly;
      this._isShallow = _isShallow;
    }
    get(target, key, receiver) {
      if (key === "__v_skip") return target["__v_skip"];
      const isReadonly2 = this._isReadonly, isShallow2 = this._isShallow;
      if (key === "__v_isReactive") {
        return !isReadonly2;
      } else if (key === "__v_isReadonly") {
        return isReadonly2;
      } else if (key === "__v_isShallow") {
        return isShallow2;
      } else if (key === "__v_raw") {
        if (receiver === (isReadonly2 ? isShallow2 ? shallowReadonlyMap : readonlyMap : isShallow2 ? shallowReactiveMap : reactiveMap).get(target) || // receiver is not the reactive proxy, but has the same prototype
        // this means the receiver is a user proxy of the reactive proxy
        Object.getPrototypeOf(target) === Object.getPrototypeOf(receiver)) {
          return target;
        }
        return;
      }
      const targetIsArray = isArray(target);
      if (!isReadonly2) {
        let fn;
        if (targetIsArray && (fn = arrayInstrumentations[key])) {
          return fn;
        }
        if (key === "hasOwnProperty") {
          return hasOwnProperty;
        }
      }
      const res = Reflect.get(
        target,
        key,
        // if this is a proxy wrapping a ref, return methods using the raw ref
        // as receiver so that we don't have to call `toRaw` on the ref in all
        // its class methods
        isRef(target) ? target : receiver
      );
      if (isSymbol(key) ? builtInSymbols.has(key) : isNonTrackableKeys(key)) {
        return res;
      }
      if (!isReadonly2) {
        track(target, "get", key);
      }
      if (isShallow2) {
        return res;
      }
      if (isRef(res)) {
        return targetIsArray && isIntegerKey(key) ? res : res.value;
      }
      if (isObject$1(res)) {
        return isReadonly2 ? readonly(res) : reactive(res);
      }
      return res;
    }
  }
  class MutableReactiveHandler extends BaseReactiveHandler {
    constructor(isShallow2 = false) {
      super(false, isShallow2);
    }
    set(target, key, value, receiver) {
      let oldValue = target[key];
      if (!this._isShallow) {
        const isOldValueReadonly = isReadonly(oldValue);
        if (!isShallow(value) && !isReadonly(value)) {
          oldValue = toRaw(oldValue);
          value = toRaw(value);
        }
        if (!isArray(target) && isRef(oldValue) && !isRef(value)) {
          if (isOldValueReadonly) {
            return false;
          } else {
            oldValue.value = value;
            return true;
          }
        }
      }
      const hadKey = isArray(target) && isIntegerKey(key) ? Number(key) < target.length : hasOwn(target, key);
      const result = Reflect.set(
        target,
        key,
        value,
        isRef(target) ? target : receiver
      );
      if (target === toRaw(receiver)) {
        if (!hadKey) {
          trigger(target, "add", key, value);
        } else if (hasChanged(value, oldValue)) {
          trigger(target, "set", key, value);
        }
      }
      return result;
    }
    deleteProperty(target, key) {
      const hadKey = hasOwn(target, key);
      target[key];
      const result = Reflect.deleteProperty(target, key);
      if (result && hadKey) {
        trigger(target, "delete", key, void 0);
      }
      return result;
    }
    has(target, key) {
      const result = Reflect.has(target, key);
      if (!isSymbol(key) || !builtInSymbols.has(key)) {
        track(target, "has", key);
      }
      return result;
    }
    ownKeys(target) {
      track(
        target,
        "iterate",
        isArray(target) ? "length" : ITERATE_KEY
      );
      return Reflect.ownKeys(target);
    }
  }
  class ReadonlyReactiveHandler extends BaseReactiveHandler {
    constructor(isShallow2 = false) {
      super(true, isShallow2);
    }
    set(target, key) {
      return true;
    }
    deleteProperty(target, key) {
      return true;
    }
  }
  const mutableHandlers = /* @__PURE__ */ new MutableReactiveHandler();
  const readonlyHandlers = /* @__PURE__ */ new ReadonlyReactiveHandler();
  const toShallow = (value) => value;
  const getProto = (v) => Reflect.getPrototypeOf(v);
  function createIterableMethod(method, isReadonly2, isShallow2) {
    return function(...args) {
      const target = this["__v_raw"];
      const rawTarget = toRaw(target);
      const targetIsMap = isMap(rawTarget);
      const isPair = method === "entries" || method === Symbol.iterator && targetIsMap;
      const isKeyOnly = method === "keys" && targetIsMap;
      const innerIterator = target[method](...args);
      const wrap = isShallow2 ? toShallow : isReadonly2 ? toReadonly : toReactive;
      !isReadonly2 && track(
        rawTarget,
        "iterate",
        isKeyOnly ? MAP_KEY_ITERATE_KEY : ITERATE_KEY
      );
      return {
        // iterator protocol
        next() {
          const { value, done } = innerIterator.next();
          return done ? { value, done } : {
            value: isPair ? [wrap(value[0]), wrap(value[1])] : wrap(value),
            done
          };
        },
        // iterable protocol
        [Symbol.iterator]() {
          return this;
        }
      };
    };
  }
  function createReadonlyMethod(type) {
    return function(...args) {
      return type === "delete" ? false : type === "clear" ? void 0 : this;
    };
  }
  function createInstrumentations(readonly2, shallow) {
    const instrumentations = {
      get(key) {
        const target = this["__v_raw"];
        const rawTarget = toRaw(target);
        const rawKey = toRaw(key);
        if (!readonly2) {
          if (hasChanged(key, rawKey)) {
            track(rawTarget, "get", key);
          }
          track(rawTarget, "get", rawKey);
        }
        const { has } = getProto(rawTarget);
        const wrap = shallow ? toShallow : readonly2 ? toReadonly : toReactive;
        if (has.call(rawTarget, key)) {
          return wrap(target.get(key));
        } else if (has.call(rawTarget, rawKey)) {
          return wrap(target.get(rawKey));
        } else if (target !== rawTarget) {
          target.get(key);
        }
      },
      get size() {
        const target = this["__v_raw"];
        !readonly2 && track(toRaw(target), "iterate", ITERATE_KEY);
        return Reflect.get(target, "size", target);
      },
      has(key) {
        const target = this["__v_raw"];
        const rawTarget = toRaw(target);
        const rawKey = toRaw(key);
        if (!readonly2) {
          if (hasChanged(key, rawKey)) {
            track(rawTarget, "has", key);
          }
          track(rawTarget, "has", rawKey);
        }
        return key === rawKey ? target.has(key) : target.has(key) || target.has(rawKey);
      },
      forEach(callback, thisArg) {
        const observed = this;
        const target = observed["__v_raw"];
        const rawTarget = toRaw(target);
        const wrap = shallow ? toShallow : readonly2 ? toReadonly : toReactive;
        !readonly2 && track(rawTarget, "iterate", ITERATE_KEY);
        return target.forEach((value, key) => {
          return callback.call(thisArg, wrap(value), wrap(key), observed);
        });
      }
    };
    extend(
      instrumentations,
      readonly2 ? {
        add: createReadonlyMethod("add"),
        set: createReadonlyMethod("set"),
        delete: createReadonlyMethod("delete"),
        clear: createReadonlyMethod("clear")
      } : {
        add(value) {
          if (!shallow && !isShallow(value) && !isReadonly(value)) {
            value = toRaw(value);
          }
          const target = toRaw(this);
          const proto = getProto(target);
          const hadKey = proto.has.call(target, value);
          if (!hadKey) {
            target.add(value);
            trigger(target, "add", value, value);
          }
          return this;
        },
        set(key, value) {
          if (!shallow && !isShallow(value) && !isReadonly(value)) {
            value = toRaw(value);
          }
          const target = toRaw(this);
          const { has, get } = getProto(target);
          let hadKey = has.call(target, key);
          if (!hadKey) {
            key = toRaw(key);
            hadKey = has.call(target, key);
          }
          const oldValue = get.call(target, key);
          target.set(key, value);
          if (!hadKey) {
            trigger(target, "add", key, value);
          } else if (hasChanged(value, oldValue)) {
            trigger(target, "set", key, value);
          }
          return this;
        },
        delete(key) {
          const target = toRaw(this);
          const { has, get } = getProto(target);
          let hadKey = has.call(target, key);
          if (!hadKey) {
            key = toRaw(key);
            hadKey = has.call(target, key);
          }
          get ? get.call(target, key) : void 0;
          const result = target.delete(key);
          if (hadKey) {
            trigger(target, "delete", key, void 0);
          }
          return result;
        },
        clear() {
          const target = toRaw(this);
          const hadItems = target.size !== 0;
          const result = target.clear();
          if (hadItems) {
            trigger(
              target,
              "clear",
              void 0,
              void 0
            );
          }
          return result;
        }
      }
    );
    const iteratorMethods = [
      "keys",
      "values",
      "entries",
      Symbol.iterator
    ];
    iteratorMethods.forEach((method) => {
      instrumentations[method] = createIterableMethod(method, readonly2, shallow);
    });
    return instrumentations;
  }
  function createInstrumentationGetter(isReadonly2, shallow) {
    const instrumentations = createInstrumentations(isReadonly2, shallow);
    return (target, key, receiver) => {
      if (key === "__v_isReactive") {
        return !isReadonly2;
      } else if (key === "__v_isReadonly") {
        return isReadonly2;
      } else if (key === "__v_raw") {
        return target;
      }
      return Reflect.get(
        hasOwn(instrumentations, key) && key in target ? instrumentations : target,
        key,
        receiver
      );
    };
  }
  const mutableCollectionHandlers = {
    get: /* @__PURE__ */ createInstrumentationGetter(false, false)
  };
  const readonlyCollectionHandlers = {
    get: /* @__PURE__ */ createInstrumentationGetter(true, false)
  };
  const reactiveMap = /* @__PURE__ */ new WeakMap();
  const shallowReactiveMap = /* @__PURE__ */ new WeakMap();
  const readonlyMap = /* @__PURE__ */ new WeakMap();
  const shallowReadonlyMap = /* @__PURE__ */ new WeakMap();
  function targetTypeMap(rawType) {
    switch (rawType) {
      case "Object":
      case "Array":
        return 1;
      case "Map":
      case "Set":
      case "WeakMap":
      case "WeakSet":
        return 2;
      default:
        return 0;
    }
  }
  function getTargetType(value) {
    return value["__v_skip"] || !Object.isExtensible(value) ? 0 : targetTypeMap(toRawType(value));
  }
  function reactive(target) {
    if (isReadonly(target)) {
      return target;
    }
    return createReactiveObject(
      target,
      false,
      mutableHandlers,
      mutableCollectionHandlers,
      reactiveMap
    );
  }
  function readonly(target) {
    return createReactiveObject(
      target,
      true,
      readonlyHandlers,
      readonlyCollectionHandlers,
      readonlyMap
    );
  }
  function createReactiveObject(target, isReadonly2, baseHandlers, collectionHandlers, proxyMap) {
    if (!isObject$1(target)) {
      return target;
    }
    if (target["__v_raw"] && !(isReadonly2 && target["__v_isReactive"])) {
      return target;
    }
    const existingProxy = proxyMap.get(target);
    if (existingProxy) {
      return existingProxy;
    }
    const targetType = getTargetType(target);
    if (targetType === 0) {
      return target;
    }
    const proxy = new Proxy(
      target,
      targetType === 2 ? collectionHandlers : baseHandlers
    );
    proxyMap.set(target, proxy);
    return proxy;
  }
  function isReactive(value) {
    if (isReadonly(value)) {
      return isReactive(value["__v_raw"]);
    }
    return !!(value && value["__v_isReactive"]);
  }
  function isReadonly(value) {
    return !!(value && value["__v_isReadonly"]);
  }
  function isShallow(value) {
    return !!(value && value["__v_isShallow"]);
  }
  function isProxy(value) {
    return value ? !!value["__v_raw"] : false;
  }
  function toRaw(observed) {
    const raw = observed && observed["__v_raw"];
    return raw ? toRaw(raw) : observed;
  }
  const toReactive = (value) => isObject$1(value) ? reactive(value) : value;
  const toReadonly = (value) => isObject$1(value) ? readonly(value) : value;
  function isRef(r) {
    return r ? r["__v_isRef"] === true : false;
  }
  function ref(value) {
    return createRef(value, false);
  }
  function shallowRef(value) {
    return createRef(value, true);
  }
  function createRef(rawValue, shallow) {
    if (isRef(rawValue)) {
      return rawValue;
    }
    return new RefImpl(rawValue, shallow);
  }
  class RefImpl {
    constructor(value, isShallow2) {
      this.dep = new Dep();
      this["__v_isRef"] = true;
      this["__v_isShallow"] = false;
      this._rawValue = isShallow2 ? value : toRaw(value);
      this._value = isShallow2 ? value : toReactive(value);
      this["__v_isShallow"] = isShallow2;
    }
    get value() {
      {
        this.dep.track();
      }
      return this._value;
    }
    set value(newValue) {
      const oldValue = this._rawValue;
      const useDirectValue = this["__v_isShallow"] || isShallow(newValue) || isReadonly(newValue);
      newValue = useDirectValue ? newValue : toRaw(newValue);
      if (hasChanged(newValue, oldValue)) {
        this._rawValue = newValue;
        this._value = useDirectValue ? newValue : toReactive(newValue);
        {
          this.dep.trigger();
        }
      }
    }
  }
  function unref(ref2) {
    return isRef(ref2) ? ref2.value : ref2;
  }
  class ComputedRefImpl {
    constructor(fn, setter, isSSR) {
      this.fn = fn;
      this.setter = setter;
      this._value = void 0;
      this.dep = new Dep(this);
      this.__v_isRef = true;
      this.deps = void 0;
      this.depsTail = void 0;
      this.flags = 16;
      this.globalVersion = globalVersion - 1;
      this.next = void 0;
      this.effect = this;
      this["__v_isReadonly"] = !setter;
      this.isSSR = isSSR;
    }
    /**
     * @internal
     */
    notify() {
      this.flags |= 16;
      if (!(this.flags & 8) && // avoid infinite self recursion
      activeSub !== this) {
        batch(this, true);
        return true;
      }
    }
    get value() {
      const link = this.dep.track();
      refreshComputed(this);
      if (link) {
        link.version = this.dep.version;
      }
      return this._value;
    }
    set value(newValue) {
      if (this.setter) {
        this.setter(newValue);
      }
    }
  }
  function computed$1(getterOrOptions, debugOptions, isSSR = false) {
    let getter;
    let setter;
    if (isFunction(getterOrOptions)) {
      getter = getterOrOptions;
    } else {
      getter = getterOrOptions.get;
      setter = getterOrOptions.set;
    }
    const cRef = new ComputedRefImpl(getter, setter, isSSR);
    return cRef;
  }
  const INITIAL_WATCHER_VALUE = {};
  const cleanupMap = /* @__PURE__ */ new WeakMap();
  let activeWatcher = void 0;
  function onWatcherCleanup(cleanupFn, failSilently = false, owner = activeWatcher) {
    if (owner) {
      let cleanups = cleanupMap.get(owner);
      if (!cleanups) cleanupMap.set(owner, cleanups = []);
      cleanups.push(cleanupFn);
    }
  }
  function watch$1(source, cb, options = EMPTY_OBJ) {
    const { immediate, deep, once, scheduler, augmentJob, call } = options;
    const reactiveGetter = (source2) => {
      if (deep) return source2;
      if (isShallow(source2) || deep === false || deep === 0)
        return traverse(source2, 1);
      return traverse(source2);
    };
    let effect2;
    let getter;
    let cleanup;
    let boundCleanup;
    let forceTrigger = false;
    let isMultiSource = false;
    if (isRef(source)) {
      getter = () => source.value;
      forceTrigger = isShallow(source);
    } else if (isReactive(source)) {
      getter = () => reactiveGetter(source);
      forceTrigger = true;
    } else if (isArray(source)) {
      isMultiSource = true;
      forceTrigger = source.some((s) => isReactive(s) || isShallow(s));
      getter = () => source.map((s) => {
        if (isRef(s)) {
          return s.value;
        } else if (isReactive(s)) {
          return reactiveGetter(s);
        } else if (isFunction(s)) {
          return call ? call(s, 2) : s();
        } else ;
      });
    } else if (isFunction(source)) {
      if (cb) {
        getter = call ? () => call(source, 2) : source;
      } else {
        getter = () => {
          if (cleanup) {
            pauseTracking();
            try {
              cleanup();
            } finally {
              resetTracking();
            }
          }
          const currentEffect = activeWatcher;
          activeWatcher = effect2;
          try {
            return call ? call(source, 3, [boundCleanup]) : source(boundCleanup);
          } finally {
            activeWatcher = currentEffect;
          }
        };
      }
    } else {
      getter = NOOP;
    }
    if (cb && deep) {
      const baseGetter = getter;
      const depth = deep === true ? Infinity : deep;
      getter = () => traverse(baseGetter(), depth);
    }
    const watchHandle = () => {
      effect2.stop();
    };
    if (once && cb) {
      const _cb = cb;
      cb = (...args) => {
        _cb(...args);
        watchHandle();
      };
    }
    let oldValue = isMultiSource ? new Array(source.length).fill(INITIAL_WATCHER_VALUE) : INITIAL_WATCHER_VALUE;
    const job = (immediateFirstRun) => {
      if (!(effect2.flags & 1) || !effect2.dirty && !immediateFirstRun) {
        return;
      }
      if (cb) {
        const newValue = effect2.run();
        if (deep || forceTrigger || (isMultiSource ? newValue.some((v, i) => hasChanged(v, oldValue[i])) : hasChanged(newValue, oldValue))) {
          if (cleanup) {
            cleanup();
          }
          const currentWatcher = activeWatcher;
          activeWatcher = effect2;
          try {
            const args = [
              newValue,
              // pass undefined as the old value when it's changed for the first time
              oldValue === INITIAL_WATCHER_VALUE ? void 0 : isMultiSource && oldValue[0] === INITIAL_WATCHER_VALUE ? [] : oldValue,
              boundCleanup
            ];
            call ? call(cb, 3, args) : (
              // @ts-expect-error
              cb(...args)
            );
            oldValue = newValue;
          } finally {
            activeWatcher = currentWatcher;
          }
        }
      } else {
        effect2.run();
      }
    };
    if (augmentJob) {
      augmentJob(job);
    }
    effect2 = new ReactiveEffect(getter);
    effect2.scheduler = scheduler ? () => scheduler(job, false) : job;
    boundCleanup = (fn) => onWatcherCleanup(fn, false, effect2);
    cleanup = effect2.onStop = () => {
      const cleanups = cleanupMap.get(effect2);
      if (cleanups) {
        if (call) {
          call(cleanups, 4);
        } else {
          for (const cleanup2 of cleanups) cleanup2();
        }
        cleanupMap.delete(effect2);
      }
    };
    if (cb) {
      if (immediate) {
        job(true);
      } else {
        oldValue = effect2.run();
      }
    } else if (scheduler) {
      scheduler(job.bind(null, true), true);
    } else {
      effect2.run();
    }
    watchHandle.pause = effect2.pause.bind(effect2);
    watchHandle.resume = effect2.resume.bind(effect2);
    watchHandle.stop = watchHandle;
    return watchHandle;
  }
  function traverse(value, depth = Infinity, seen) {
    if (depth <= 0 || !isObject$1(value) || value["__v_skip"]) {
      return value;
    }
    seen = seen || /* @__PURE__ */ new Set();
    if (seen.has(value)) {
      return value;
    }
    seen.add(value);
    depth--;
    if (isRef(value)) {
      traverse(value.value, depth, seen);
    } else if (isArray(value)) {
      for (let i = 0; i < value.length; i++) {
        traverse(value[i], depth, seen);
      }
    } else if (isSet(value) || isMap(value)) {
      value.forEach((v) => {
        traverse(v, depth, seen);
      });
    } else if (isPlainObject(value)) {
      for (const key in value) {
        traverse(value[key], depth, seen);
      }
      for (const key of Object.getOwnPropertySymbols(value)) {
        if (Object.prototype.propertyIsEnumerable.call(value, key)) {
          traverse(value[key], depth, seen);
        }
      }
    }
    return value;
  }
  /**
  * @vue/runtime-core v3.5.13
  * (c) 2018-present Yuxi (Evan) You and Vue contributors
  * @license MIT
  **/
  function callWithErrorHandling(fn, instance, type, args) {
    try {
      return args ? fn(...args) : fn();
    } catch (err) {
      handleError(err, instance, type);
    }
  }
  function callWithAsyncErrorHandling(fn, instance, type, args) {
    if (isFunction(fn)) {
      const res = callWithErrorHandling(fn, instance, type, args);
      if (res && isPromise(res)) {
        res.catch((err) => {
          handleError(err, instance, type);
        });
      }
      return res;
    }
    if (isArray(fn)) {
      const values = [];
      for (let i = 0; i < fn.length; i++) {
        values.push(callWithAsyncErrorHandling(fn[i], instance, type, args));
      }
      return values;
    }
  }
  function handleError(err, instance, type, throwInDev = true) {
    const contextVNode = instance ? instance.vnode : null;
    const { errorHandler, throwUnhandledErrorInProduction } = instance && instance.appContext.config || EMPTY_OBJ;
    if (instance) {
      let cur = instance.parent;
      const exposedInstance = instance.proxy;
      const errorInfo = `https://vuejs.org/error-reference/#runtime-${type}`;
      while (cur) {
        const errorCapturedHooks = cur.ec;
        if (errorCapturedHooks) {
          for (let i = 0; i < errorCapturedHooks.length; i++) {
            if (errorCapturedHooks[i](err, exposedInstance, errorInfo) === false) {
              return;
            }
          }
        }
        cur = cur.parent;
      }
      if (errorHandler) {
        pauseTracking();
        callWithErrorHandling(errorHandler, null, 10, [
          err,
          exposedInstance,
          errorInfo
        ]);
        resetTracking();
        return;
      }
    }
    logError(err, type, contextVNode, throwInDev, throwUnhandledErrorInProduction);
  }
  function logError(err, type, contextVNode, throwInDev = true, throwInProd = false) {
    if (throwInProd) {
      throw err;
    } else {
      console.error(err);
    }
  }
  const queue = [];
  let flushIndex = -1;
  const pendingPostFlushCbs = [];
  let activePostFlushCbs = null;
  let postFlushIndex = 0;
  const resolvedPromise = /* @__PURE__ */ Promise.resolve();
  let currentFlushPromise = null;
  function nextTick(fn) {
    const p = currentFlushPromise || resolvedPromise;
    return fn ? p.then(this ? fn.bind(this) : fn) : p;
  }
  function findInsertionIndex(id) {
    let start = flushIndex + 1;
    let end = queue.length;
    while (start < end) {
      const middle = start + end >>> 1;
      const middleJob = queue[middle];
      const middleJobId = getId(middleJob);
      if (middleJobId < id || middleJobId === id && middleJob.flags & 2) {
        start = middle + 1;
      } else {
        end = middle;
      }
    }
    return start;
  }
  function queueJob(job) {
    if (!(job.flags & 1)) {
      const jobId = getId(job);
      const lastJob = queue[queue.length - 1];
      if (!lastJob || // fast path when the job id is larger than the tail
      !(job.flags & 2) && jobId >= getId(lastJob)) {
        queue.push(job);
      } else {
        queue.splice(findInsertionIndex(jobId), 0, job);
      }
      job.flags |= 1;
      queueFlush();
    }
  }
  function queueFlush() {
    if (!currentFlushPromise) {
      currentFlushPromise = resolvedPromise.then(flushJobs);
    }
  }
  function queuePostFlushCb(cb) {
    if (!isArray(cb)) {
      if (activePostFlushCbs && cb.id === -1) {
        activePostFlushCbs.splice(postFlushIndex + 1, 0, cb);
      } else if (!(cb.flags & 1)) {
        pendingPostFlushCbs.push(cb);
        cb.flags |= 1;
      }
    } else {
      pendingPostFlushCbs.push(...cb);
    }
    queueFlush();
  }
  function flushPostFlushCbs(seen) {
    if (pendingPostFlushCbs.length) {
      const deduped = [...new Set(pendingPostFlushCbs)].sort(
        (a, b) => getId(a) - getId(b)
      );
      pendingPostFlushCbs.length = 0;
      if (activePostFlushCbs) {
        activePostFlushCbs.push(...deduped);
        return;
      }
      activePostFlushCbs = deduped;
      for (postFlushIndex = 0; postFlushIndex < activePostFlushCbs.length; postFlushIndex++) {
        const cb = activePostFlushCbs[postFlushIndex];
        if (cb.flags & 4) {
          cb.flags &= ~1;
        }
        if (!(cb.flags & 8)) cb();
        cb.flags &= ~1;
      }
      activePostFlushCbs = null;
      postFlushIndex = 0;
    }
  }
  const getId = (job) => job.id == null ? job.flags & 2 ? -1 : Infinity : job.id;
  function flushJobs(seen) {
    try {
      for (flushIndex = 0; flushIndex < queue.length; flushIndex++) {
        const job = queue[flushIndex];
        if (job && !(job.flags & 8)) {
          if (false) ;
          if (job.flags & 4) {
            job.flags &= ~1;
          }
          callWithErrorHandling(
            job,
            job.i,
            job.i ? 15 : 14
          );
          if (!(job.flags & 4)) {
            job.flags &= ~1;
          }
        }
      }
    } finally {
      for (; flushIndex < queue.length; flushIndex++) {
        const job = queue[flushIndex];
        if (job) {
          job.flags &= ~1;
        }
      }
      flushIndex = -1;
      queue.length = 0;
      flushPostFlushCbs();
      currentFlushPromise = null;
      if (queue.length || pendingPostFlushCbs.length) {
        flushJobs();
      }
    }
  }
  let currentRenderingInstance = null;
  getGlobalThis().requestIdleCallback || ((cb) => setTimeout(cb, 1));
  getGlobalThis().cancelIdleCallback || ((id) => clearTimeout(id));
  function injectHook(type, hook, target = currentInstance, prepend = false) {
    if (target) {
      const hooks = target[type] || (target[type] = []);
      const wrappedHook = hook.__weh || (hook.__weh = (...args) => {
        pauseTracking();
        const reset = setCurrentInstance(target);
        const res = callWithAsyncErrorHandling(hook, target, type, args);
        reset();
        resetTracking();
        return res;
      });
      if (prepend) {
        hooks.unshift(wrappedHook);
      } else {
        hooks.push(wrappedHook);
      }
      return wrappedHook;
    }
  }
  const createHook = (lifecycle) => (hook, target = currentInstance) => {
    if (!isInSSRComponentSetup || lifecycle === "sp") {
      injectHook(lifecycle, (...args) => hook(...args), target);
    }
  };
  const onMounted = createHook("m");
  let currentApp = null;
  function inject(key, defaultValue, treatDefaultAsFactory = false) {
    const instance = currentInstance || currentRenderingInstance;
    if (instance || currentApp) {
      const provides = instance ? instance.parent == null ? instance.vnode.appContext && instance.vnode.appContext.provides : instance.parent.provides : void 0;
      if (provides && key in provides) {
        return provides[key];
      } else if (arguments.length > 1) {
        return treatDefaultAsFactory && isFunction(defaultValue) ? defaultValue.call(instance && instance.proxy) : defaultValue;
      } else ;
    }
  }
  const queuePostRenderEffect = queueEffectWithSuspense;
  const ssrContextKey = Symbol.for("v-scx");
  const useSSRContext = () => {
    {
      const ctx = inject(ssrContextKey);
      return ctx;
    }
  };
  function watch(source, cb, options) {
    return doWatch(source, cb, options);
  }
  function doWatch(source, cb, options = EMPTY_OBJ) {
    const { immediate, deep, flush, once } = options;
    const baseWatchOptions = extend({}, options);
    const runsImmediately = cb && immediate || !cb && flush !== "post";
    let ssrCleanup;
    if (isInSSRComponentSetup) {
      if (flush === "sync") {
        const ctx = useSSRContext();
        ssrCleanup = ctx.__watcherHandles || (ctx.__watcherHandles = []);
      } else if (!runsImmediately) {
        const watchStopHandle = () => {
        };
        watchStopHandle.stop = NOOP;
        watchStopHandle.resume = NOOP;
        watchStopHandle.pause = NOOP;
        return watchStopHandle;
      }
    }
    const instance = currentInstance;
    baseWatchOptions.call = (fn, type, args) => callWithAsyncErrorHandling(fn, instance, type, args);
    let isPre = false;
    if (flush === "post") {
      baseWatchOptions.scheduler = (job) => {
        queuePostRenderEffect(job, instance && instance.suspense);
      };
    } else if (flush !== "sync") {
      isPre = true;
      baseWatchOptions.scheduler = (job, isFirstRun) => {
        if (isFirstRun) {
          job();
        } else {
          queueJob(job);
        }
      };
    }
    baseWatchOptions.augmentJob = (job) => {
      if (cb) {
        job.flags |= 4;
      }
      if (isPre) {
        job.flags |= 2;
        if (instance) {
          job.id = instance.uid;
          job.i = instance;
        }
      }
    };
    const watchHandle = watch$1(source, cb, baseWatchOptions);
    if (isInSSRComponentSetup) {
      if (ssrCleanup) {
        ssrCleanup.push(watchHandle);
      } else if (runsImmediately) {
        watchHandle();
      }
    }
    return watchHandle;
  }
  function queueEffectWithSuspense(fn, suspense) {
    if (suspense && suspense.pendingBranch) {
      if (isArray(fn)) {
        suspense.effects.push(...fn);
      } else {
        suspense.effects.push(fn);
      }
    } else {
      queuePostFlushCb(fn);
    }
  }
  let currentInstance = null;
  const getCurrentInstance = () => currentInstance || currentRenderingInstance;
  let internalSetCurrentInstance;
  {
    const g = getGlobalThis();
    const registerGlobalSetter = (key, setter) => {
      let setters;
      if (!(setters = g[key])) setters = g[key] = [];
      setters.push(setter);
      return (v) => {
        if (setters.length > 1) setters.forEach((set) => set(v));
        else setters[0](v);
      };
    };
    internalSetCurrentInstance = registerGlobalSetter(
      `__VUE_INSTANCE_SETTERS__`,
      (v) => currentInstance = v
    );
    registerGlobalSetter(
      `__VUE_SSR_SETTERS__`,
      (v) => isInSSRComponentSetup = v
    );
  }
  const setCurrentInstance = (instance) => {
    const prev = currentInstance;
    internalSetCurrentInstance(instance);
    instance.scope.on();
    return () => {
      instance.scope.off();
      internalSetCurrentInstance(prev);
    };
  };
  let isInSSRComponentSetup = false;
  const computed = (getterOrOptions, debugOptions) => {
    const c = computed$1(getterOrOptions, debugOptions, isInSSRComponentSetup);
    return c;
  };
  var INetworkFeature = /* @__PURE__ */ ((INetworkFeature2) => {
    INetworkFeature2[INetworkFeature2["NONE"] = 0] = "NONE";
    INetworkFeature2[INetworkFeature2["STAKING"] = 1] = "STAKING";
    INetworkFeature2[INetworkFeature2["SWAP"] = 2] = "SWAP";
    INetworkFeature2[INetworkFeature2["CATALYST"] = 4] = "CATALYST";
    INetworkFeature2[INetworkFeature2["GOVERNANCE"] = 8] = "GOVERNANCE";
    INetworkFeature2[INetworkFeature2["DAPP_BROWSER"] = 16] = "DAPP_BROWSER";
    INetworkFeature2[INetworkFeature2["REPORTING"] = 32] = "REPORTING";
    INetworkFeature2[INetworkFeature2["CREATE_SWAP"] = 64] = "CREATE_SWAP";
    INetworkFeature2[INetworkFeature2["ALL"] = 127] = "ALL";
    return INetworkFeature2;
  })(INetworkFeature || {});
  const networkIdList = ["mainnet", "preprod", "preview", "guild", "sancho", "afvt", "afpt", "afvm", "afpm"];
  const networkFeaturesMap = networkIdList.reduce((o, n) => {
    o[n] = INetworkFeature.NONE;
    return o;
  }, {});
  networkFeaturesMap["mainnet"] = INetworkFeature.ALL;
  networkFeaturesMap["guild"] = INetworkFeature.STAKING;
  networkFeaturesMap["sancho"] = INetworkFeature.STAKING | INetworkFeature.DAPP_BROWSER | INetworkFeature.GOVERNANCE;
  networkFeaturesMap["preprod"] = INetworkFeature.STAKING | INetworkFeature.DAPP_BROWSER | INetworkFeature.GOVERNANCE | INetworkFeature.SWAP | INetworkFeature.CREATE_SWAP | INetworkFeature.CATALYST;
  networkFeaturesMap["preview"] = INetworkFeature.STAKING | INetworkFeature.DAPP_BROWSER | INetworkFeature.GOVERNANCE;
  networkFeaturesMap["afpt"] = INetworkFeature.STAKING;
  networkFeaturesMap["afpm"] = INetworkFeature.STAKING;
  networkFeaturesMap["afvt"] = INetworkFeature.DAPP_BROWSER;
  networkFeaturesMap["afvm"] = INetworkFeature.DAPP_BROWSER;
  const getNetworkId$2 = (id) => {
    switch (id) {
      case "mainnet":
        return 1;
      case "guild":
        return 0;
      case "sancho":
        return 0;
      case "preprod":
        return 0;
      case "preview":
        return 0;
      case "afvt":
        return 2;
      case "afvm":
        return 3;
      case "afpt":
        return 0;
      case "afpm":
        return 1;
    }
    throw new Error("Error: INetwork.getNetworkId: unknown network: " + id);
  };
  const isTestnetNetwork = (networkId2) => getNetworkId$2(networkId2) === 0 || getNetworkId$2(networkId2) === 2;
  const isCustomNetwork = (networkId2) => !isTestnetNetwork(networkId2) && networkId2 !== "mainnet";
  function toValue(r) {
    return typeof r === "function" ? r() : unref(r);
  }
  const isClient = typeof window !== "undefined" && typeof document !== "undefined";
  const toString = Object.prototype.toString;
  const isObject = (val) => toString.call(val) === "[object Object]";
  const noop = () => {
  };
  function createFilterWrapper(filter, fn) {
    function wrapper(...args) {
      return new Promise((resolve, reject) => {
        Promise.resolve(filter(() => fn.apply(this, args), { fn, thisArg: this, args })).then(resolve).catch(reject);
      });
    }
    return wrapper;
  }
  const bypassFilter = (invoke2) => {
    return invoke2();
  };
  function pausableFilter(extendFilter = bypassFilter) {
    const isActive = ref(true);
    function pause() {
      isActive.value = false;
    }
    function resume() {
      isActive.value = true;
    }
    const eventFilter = (...args) => {
      if (isActive.value)
        extendFilter(...args);
    };
    return { isActive: readonly(isActive), pause, resume, eventFilter };
  }
  function getLifeCycleTarget(target) {
    return getCurrentInstance();
  }
  function watchWithFilter(source, cb, options = {}) {
    const {
      eventFilter = bypassFilter,
      ...watchOptions
    } = options;
    return watch(
      source,
      createFilterWrapper(
        eventFilter,
        cb
      ),
      watchOptions
    );
  }
  function watchPausable(source, cb, options = {}) {
    const {
      eventFilter: filter,
      ...watchOptions
    } = options;
    const { eventFilter, pause, resume, isActive } = pausableFilter(filter);
    const stop = watchWithFilter(
      source,
      cb,
      {
        ...watchOptions,
        eventFilter
      }
    );
    return { stop, pause, resume, isActive };
  }
  function tryOnMounted(fn, sync = true, target) {
    const instance = getLifeCycleTarget();
    if (instance)
      onMounted(fn, target);
    else if (sync)
      fn();
    else
      nextTick(fn);
  }
  const defaultWindow = isClient ? window : void 0;
  function unrefElement(elRef) {
    var _a;
    const plain = toValue(elRef);
    return (_a = plain == null ? void 0 : plain.$el) != null ? _a : plain;
  }
  function useEventListener(...args) {
    let target;
    let events2;
    let listeners;
    let options;
    if (typeof args[0] === "string" || Array.isArray(args[0])) {
      [events2, listeners, options] = args;
      target = defaultWindow;
    } else {
      [target, events2, listeners, options] = args;
    }
    if (!target)
      return noop;
    if (!Array.isArray(events2))
      events2 = [events2];
    if (!Array.isArray(listeners))
      listeners = [listeners];
    const cleanups = [];
    const cleanup = () => {
      cleanups.forEach((fn) => fn());
      cleanups.length = 0;
    };
    const register = (el2, event, listener, options2) => {
      el2.addEventListener(event, listener, options2);
      return () => el2.removeEventListener(event, listener, options2);
    };
    const stopWatch = watch(
      () => [unrefElement(target), toValue(options)],
      ([el2, options2]) => {
        cleanup();
        if (!el2)
          return;
        const optionsClone = isObject(options2) ? { ...options2 } : options2;
        cleanups.push(
          ...events2.flatMap((event) => {
            return listeners.map((listener) => register(el2, event, listener, optionsClone));
          })
        );
      },
      { immediate: true, flush: "post" }
    );
    const stop = () => {
      stopWatch();
      cleanup();
    };
    return stop;
  }
  const _global = typeof globalThis !== "undefined" ? globalThis : typeof window !== "undefined" ? window : typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : {};
  const globalKey = "__vueuse_ssr_handlers__";
  const handlers = /* @__PURE__ */ getHandlers();
  function getHandlers() {
    if (!(globalKey in _global))
      _global[globalKey] = _global[globalKey] || {};
    return _global[globalKey];
  }
  function getSSRHandler(key, fallback) {
    return handlers[key] || fallback;
  }
  function guessSerializerType(rawInit) {
    return rawInit == null ? "any" : rawInit instanceof Set ? "set" : rawInit instanceof Map ? "map" : rawInit instanceof Date ? "date" : typeof rawInit === "boolean" ? "boolean" : typeof rawInit === "string" ? "string" : typeof rawInit === "object" ? "object" : !Number.isNaN(rawInit) ? "number" : "any";
  }
  const StorageSerializers = {
    boolean: {
      read: (v) => v === "true",
      write: (v) => String(v)
    },
    object: {
      read: (v) => JSON.parse(v),
      write: (v) => JSON.stringify(v)
    },
    number: {
      read: (v) => Number.parseFloat(v),
      write: (v) => String(v)
    },
    any: {
      read: (v) => v,
      write: (v) => String(v)
    },
    string: {
      read: (v) => v,
      write: (v) => String(v)
    },
    map: {
      read: (v) => new Map(JSON.parse(v)),
      write: (v) => JSON.stringify(Array.from(v.entries()))
    },
    set: {
      read: (v) => new Set(JSON.parse(v)),
      write: (v) => JSON.stringify(Array.from(v))
    },
    date: {
      read: (v) => new Date(v),
      write: (v) => v.toISOString()
    }
  };
  const customStorageEventName = "vueuse-storage";
  function useStorage(key, defaults2, storage, options = {}) {
    var _a;
    const {
      flush = "pre",
      deep = true,
      listenToStorageChanges = true,
      writeDefaults = true,
      mergeDefaults = false,
      shallow,
      window: window2 = defaultWindow,
      eventFilter,
      onError = (e) => {
        console.error(e);
      },
      initOnMounted
    } = options;
    const data = (shallow ? shallowRef : ref)(defaults2);
    if (!storage) {
      try {
        storage = getSSRHandler("getDefaultStorage", () => {
          var _a2;
          return (_a2 = defaultWindow) == null ? void 0 : _a2.localStorage;
        })();
      } catch (e) {
        onError(e);
      }
    }
    if (!storage)
      return data;
    const rawInit = toValue(defaults2);
    const type = guessSerializerType(rawInit);
    const serializer = (_a = options.serializer) != null ? _a : StorageSerializers[type];
    const { pause: pauseWatch, resume: resumeWatch } = watchPausable(
      data,
      () => write(data.value),
      { flush, deep, eventFilter }
    );
    if (window2 && listenToStorageChanges) {
      tryOnMounted(() => {
        if (storage instanceof Storage)
          useEventListener(window2, "storage", update);
        else
          useEventListener(window2, customStorageEventName, updateFromCustomEvent);
        if (initOnMounted)
          update();
      });
    }
    if (!initOnMounted)
      update();
    function dispatchWriteEvent(oldValue, newValue) {
      if (window2) {
        const payload = {
          key,
          oldValue,
          newValue,
          storageArea: storage
        };
        window2.dispatchEvent(storage instanceof Storage ? new StorageEvent("storage", payload) : new CustomEvent(customStorageEventName, {
          detail: payload
        }));
      }
    }
    function write(v) {
      try {
        const oldValue = storage.getItem(key);
        if (v == null) {
          dispatchWriteEvent(oldValue, null);
          storage.removeItem(key);
        } else {
          const serialized = serializer.write(v);
          if (oldValue !== serialized) {
            storage.setItem(key, serialized);
            dispatchWriteEvent(oldValue, serialized);
          }
        }
      } catch (e) {
        onError(e);
      }
    }
    function read(event) {
      const rawValue = event ? event.newValue : storage.getItem(key);
      if (rawValue == null) {
        if (writeDefaults && rawInit != null)
          storage.setItem(key, serializer.write(rawInit));
        return rawInit;
      } else if (!event && mergeDefaults) {
        const value = serializer.read(rawValue);
        if (typeof mergeDefaults === "function")
          return mergeDefaults(value, rawInit);
        else if (type === "object" && !Array.isArray(value))
          return { ...rawInit, ...value };
        return value;
      } else if (typeof rawValue !== "string") {
        return rawValue;
      } else {
        return serializer.read(rawValue);
      }
    }
    function update(event) {
      if (event && event.storageArea !== storage)
        return;
      if (event && event.key == null) {
        data.value = rawInit;
        return;
      }
      if (event && event.key !== key)
        return;
      pauseWatch();
      try {
        if ((event == null ? void 0 : event.newValue) !== serializer.write(data.value))
          data.value = read(event);
      } catch (e) {
        onError(e);
      } finally {
        if (event)
          nextTick(resumeWatch);
        else
          resumeWatch();
      }
    }
    function updateFromCustomEvent(event) {
      update(event.detail);
    }
    return data;
  }
  function useLocalStorage(key, initialValue, options = {}) {
    const { window: window2 = defaultWindow } = options;
    return useStorage(key, initialValue, window2 == null ? void 0 : window2.localStorage, options);
  }
  const refMap = {};
  const getRef = (key, value) => {
    let ref2 = refMap[key];
    if (!ref2) {
      ref2 = useLocalStorage(key, value, {
        deep: false,
        listenToStorageChanges: true,
        writeDefaults: true,
        mergeDefaults: false,
        shallow: false,
        onError: (error) => {
          console.error("useLocalStorage: getRef:", error);
        }
      });
      refMap[key] = ref2;
    }
    return ref2;
  };
  const getNetworkId$1 = () => getRef("networkId", "mainnet");
  const signalKeyMap = {};
  const dispatchSignalSync = (signal, ...args) => {
    performance.now();
    const signalKey = getSignalKeyMap(signal);
    const keyList = Object.keys(signalKey);
    let lastResult = null;
    for (const key of keyList) {
      performance.now();
      const cb = signalKey[key];
      if (!!cb) {
        lastResult = cb(...args);
      }
    }
    return lastResult;
  };
  const getSignalKeyMap = (signal) => {
    let signalKey = signalKeyMap[signal];
    if (!signalKey) {
      signalKey = {};
      signalKeyMap[signal] = signalKey;
    }
    return signalKey;
  };
  const onNetworkIdUpdated = "onNetworkIdUpdated";
  const _networkId = getNetworkId$1();
  watch(_networkId, (newValue, oldValue) => {
    if (oldValue !== newValue) {
      dispatchSignalSync(onNetworkIdUpdated);
    }
  });
  const networkId = computed(() => _networkId.value);
  computed(() => isTestnetNetwork(networkId.value));
  computed(() => isCustomNetwork(networkId.value));
  ({
    appType: AppType.unknown,
    appMode: AppMode.normal,
    platform: Platform.unknown,
    environment: Environment.unknown,
    token: "",
    pen: "",
    dappOrigin: "",
    isWorker: false,
    isStaging: false,
    isBeta: false,
    addApex: false,
    isMobileApp: false,
    isIosApp: false,
    isAndroidApp: false,
    hasWebUSB: false,
    useCoolify: false,
    doRestrictFeatures: true
  });
  const apiVersion = "0.1.0";
  const name = "eternl";
  const icon = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAQAAAAEACAYAAABccqhmAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA4ZpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDcuMS1jMDAwIDc5LmVkYTJiM2ZhYywgMjAyMS8xMS8xNy0xNzoyMzoxOSAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDo4ZmU4ODM0My1iMjExLTQ2YWEtYmE3MS0xZWFiZmZkNWZjMzEiIHhtcE1NOkRvY3VtZW50SUQ9InhtcC5kaWQ6NURCQTYwMDhBMTI1MTFFQzhBMjdGRTQzMjI4NjJBRDIiIHhtcE1NOkluc3RhbmNlSUQ9InhtcC5paWQ6NURCQTYwMDdBMTI1MTFFQzhBMjdGRTQzMjI4NjJBRDIiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIDIzLjEgKE1hY2ludG9zaCkiPiA8eG1wTU06RGVyaXZlZEZyb20gc3RSZWY6aW5zdGFuY2VJRD0ieG1wLmlpZDo1YzY1MGU0NC04MzE3LTQxMjMtOGFlNy03ZWQyZTVlYmVhMTciIHN0UmVmOmRvY3VtZW50SUQ9ImFkb2JlOmRvY2lkOnBob3Rvc2hvcDo0N2NhMTg2Yy04YThlLThkNDYtYWE3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";
  const createInternalError = (info) => ({ success: false, error: { code: ApiErrorCode.InternalError, info } });
  const errorInternal = (e) => createInternalError("Error: " + e);
  const errorComsMalformed = () => createInternalError("Error: coms malformed");
  const storeId$1 = "api";
  const callApi = async (req) => {
    if (doLogAll) {
      console.warn(el(storeId$1), sl("callApi"), req);
    }
    try {
      if (_requestList.length + 1 > 20) {
        throw "too many requests";
      }
      _requestList.push(req);
      const res = await _bridge.send(req);
      if (doLogAll) {
        console.warn(el(storeId$1), sl("callApi:receive"), res);
      }
      for (let i = _requestList.length - 1; i >= 0; i--) {
        if (_requestList[i].reqId === res.reqId) {
          _requestList.splice(i, 1);
          break;
        }
      }
      if (!(res == null ? void 0 : res.response)) {
        res.response = errorComsMalformed();
      }
      return res;
    } catch (err) {
      if (doLogAll) {
        console.warn(el(storeId$1), sl("callApi:err"), err);
      }
      req.response = errorInternal(err);
    }
    return req;
  };
  let _bridge = null;
  let _callApi = callApi;
  let _origin = window.origin;
  const _requestList = [];
  const enable = async (options) => {
    const extList = (options == null ? void 0 : options.extensions) ?? [];
    if (!extList.some((ext) => ext.cip === extCip30.cip)) {
      extList.unshift(extCip30);
    }
    const req = await _callApi({
      reqId: getRandomId(),
      api: METHOD.enable,
      payload: {
        origin: _origin,
        extensions: extList
      }
    });
    const res = req.response;
    if (!res.success && res.error) {
      throw getApiError(res.error);
    }
    if (res.success) {
      const api = {};
      for (const extension of extList) {
        const _api = apiMap[extension.cip];
        if (!_api) {
          throw getApiError({ code: ApiErrorCode.InternalError, info: "extension missing: " + JSON.stringify(extension) });
        }
        for (const entry of Object.entries(_api)) {
          api[entry[0]] = entry[1];
        }
      }
      return api;
    }
    throw getApiError({ code: ApiErrorCode.Refused, info: "unknown error in enable" });
  };
  const isEnabled = async () => {
    const req = await _callApi({
      reqId: getRandomId(),
      api: METHOD.isEnabled,
      payload: {
        origin: _origin
      }
    });
    const res = req.response;
    if (!res.success) {
      if (res.error) {
        throw getApiError(res.error);
      }
      return false;
    }
    return res.isEnabled ?? false;
  };
  const getExtensions = async () => {
    const req = await _callApi({
      reqId: getRandomId(),
      api: METHOD.getExtensions,
      payload: {
        origin: _origin
      }
    });
    const res = req.response;
    if (res.success) {
      return res.extensions;
    }
    throw getApiError(res.error, "getExtensions");
  };
  const getNetworkId = async () => {
    const req = await _callApi({
      reqId: getRandomId(),
      api: METHOD.getNetworkId,
      payload: {
        origin: _origin
      }
    });
    const res = req.response;
    if (res.success) {
      return res.networkId;
    }
    throw getApiError(res.error, "getNetworkId");
  };
  const getUsedAddresses = async (paginate) => {
    const req = await _callApi({
      reqId: getRandomId(),
      api: METHOD.getUsedAddresses,
      payload: {
        origin: _origin,
        paginate: paginate ?? DEFAULT_PAGINATE
      }
    });
    const res = req.response;
    if (!res.success && res.error) {
      if (res.error.code > 0) {
        throw getPaginateError(res.error);
      }
      throw getApiError(res.error);
    }
    if (res.success) {
      if (res.usedAddrList) {
        return res.usedAddrList;
      }
      throw getApiError({ code: ApiErrorCode.InternalError, info: "usedAddrList missing" });
    }
    throw getApiError(null, "getUsedAddresses");
  };
  const getUnusedAddresses = async () => {
    const req = await _callApi({
      reqId: getRandomId(),
      api: METHOD.getUnusedAddresses,
      payload: {
        origin: _origin
      }
    });
    const res = req.response;
    if (!res.success && res.error) {
      throw getApiError(res.error);
    }
    if (res.success) {
      if (res.unusedAddrList) {
        return res.unusedAddrList;
      }
      throw getApiError({ code: ApiErrorCode.InternalError, info: "unusedAddrList missing" });
    }
    throw getApiError(null, "getUnusedAddresses");
  };
  const getForcedUnusedAddresses = async () => {
    const req = await _callApi({
      reqId: getRandomId(),
      api: METHOD.getForcedUnusedAddresses,
      payload: {
        origin: _origin
      }
    });
    const res = req.response;
    if (!res.success && res.error) {
      throw getApiError(res.error);
    }
    if (res.success) {
      if (res.unusedAddrList) {
        return res.unusedAddrList;
      }
      throw getApiError({ code: ApiErrorCode.InternalError, info: "unusedAddrList missing" });
    }
    throw getApiError(null, "getForcedUnusedAddresses");
  };
  const getRewardAddresses = async () => {
    const req = await _callApi({
      reqId: getRandomId(),
      api: METHOD.getRewardAddresses,
      payload: {
        origin: _origin
      }
    });
    const res = req.response;
    if (!res.success && res.error) {
      throw getApiError(res.error);
    }
    if (res.success) {
      if (res.rewardAddrList) {
        return res.rewardAddrList;
      }
      throw getApiError({ code: ApiErrorCode.InternalError, info: "rewardAddrList missing" });
    }
    throw getApiError(null, "getRewardAddresses");
  };
  const getChangeAddress = async () => {
    const req = await _callApi({
      reqId: getRandomId(),
      api: METHOD.getChangeAddress,
      payload: {
        origin: _origin
      }
    });
    const res = req.response;
    if (!res.success && res.error) {
      throw getApiError(res.error);
    }
    if (res.success) {
      if (res.changeAddr) {
        return res.changeAddr;
      }
      throw getApiError({ code: ApiErrorCode.InternalError, info: "changeAddr missing" });
    }
    throw getApiError(null, "getChangeAddress");
  };
  const getBalance = async () => {
    const req = await _callApi({
      reqId: getRandomId(),
      api: METHOD.getBalance,
      payload: {
        origin: _origin
      }
    });
    const res = req.response;
    if (!res.success && res.error) {
      throw getApiError(res.error);
    }
    if (res.success) {
      if (res.balanceCbor) {
        return res.balanceCbor;
      }
      throw getApiError({ code: ApiErrorCode.InternalError, info: "balanceCbor missing" });
    }
    throw getApiError(null, "getBalance");
  };
  const getUtxos = async (amount, paginate) => {
    const req = await _callApi({
      reqId: getRandomId(),
      api: METHOD.getUtxos,
      payload: {
        origin: _origin,
        amount: amount ?? null,
        paginate: paginate ?? DEFAULT_PAGINATE
      }
    });
    const res = req.response;
    if (!res.success && res.error) {
      if (amount && res.error.info.startsWith("invalid amount")) {
        return void 0;
      }
      if (res.error.code > 0) {
        throw getPaginateError(res.error);
      }
      throw getApiError(res.error);
    }
    if (res.success) {
      if (res.utxoList) {
        return res.utxoList;
      }
      throw getApiError({ code: ApiErrorCode.InternalError, info: "utxoList missing" });
    }
    throw getApiError(null, "getUtxos");
  };
  const getCollateral = async () => {
    const req = await _callApi({
      reqId: getRandomId(),
      api: METHOD.getCollateral,
      payload: {
        origin: _origin
      }
    });
    const res = req.response;
    if (!res.success && res.error) {
      throw getApiError(res.error);
    }
    if (res.success) {
      if (res.collateralList) {
        return res.collateralList;
      }
      throw getApiError({ code: ApiErrorCode.InternalError, info: "collateralList missing" });
    }
    throw getApiError(null, "getCollateral");
  };
  const getLockedUtxos = async () => {
    const req = await _callApi({
      reqId: getRandomId(),
      api: METHOD.getLockedUtxos,
      payload: {
        origin: _origin
      }
    });
    const res = req.response;
    if (!res.success && res.error) {
      throw getApiError(res.error);
    }
    if (res.success) {
      if (res.lockedUtxoList) {
        return res.lockedUtxoList;
      }
      throw getApiError({ code: ApiErrorCode.InternalError, info: "lockedUtxoList missing" });
    }
    throw getApiError(null, "getLockedUtxos");
  };
  const signTx = async (tx, partialSign = false) => {
    return (await signTxs(tx ? [{ cbor: tx, partialSign }] : []))[0];
  };
  const signTxs = async (txList) => {
    if (!txList || txList.length === 0) {
      throw getApiError({ code: ApiErrorCode.InvalidRequest, info: "txList missing" });
    }
    const req = await _callApi({
      reqId: getRandomId(),
      api: METHOD.signTx,
      payload: {
        origin: _origin,
        txList: txList ?? []
      }
    });
    const res = req.response;
    if (!res.success && res.error) {
      throw getTxSignError(res.error);
    }
    if (res.success) {
      if (res.witnessSetList) {
        return res.witnessSetList;
      }
      throw getApiError({ code: ApiErrorCode.InternalError, info: "witnessSetList missing" });
    }
    throw getApiError(null, "signTx");
  };
  const signData = async (addr, sigStructure) => {
    const req = await _callApi({
      reqId: getRandomId(),
      api: METHOD.signData,
      payload: {
        origin: _origin,
        addr: addr ?? null,
        sigStructure: sigStructure ?? null
      }
    });
    const res = req.response;
    if (!res.success && res.error) {
      throw getDataSignError(res.error);
    }
    if (res.success) {
      if (res.signedData) {
        return res.signedData;
      }
      throw getApiError({ code: ApiErrorCode.InternalError, info: "signedData missing" });
    }
    throw getApiError(null, "signData");
  };
  const submitTx = async (tx) => {
    const req = await _callApi({
      reqId: getRandomId(),
      api: METHOD.submitTx,
      payload: {
        origin: _origin,
        tx: tx ?? null
      }
    });
    const res = req.response;
    if (!res.success && res.error) {
      throw getTxSendError(res.error);
    }
    if (res.success) {
      if (res.txHash) {
        return res.txHash;
      }
      throw getApiError({ code: ApiErrorCode.InternalError, info: "txHash missing" });
    }
    throw getApiError(null, "submitTx");
  };
  const syncAccount = async () => {
    const req = await _callApi({
      reqId: getRandomId(),
      api: METHOD.syncAccount,
      payload: {
        origin: _origin
      }
    });
    const res = req.response;
    if (!res.success && res.error) {
      throw getApiError(res.error);
    }
    if (res.success) {
      return true;
    }
    throw getApiError(null, "syncAccount");
  };
  const getAccountPub = async () => {
    const req = await _callApi({
      reqId: getRandomId(),
      api: METHOD.getAccountPub,
      payload: {
        origin: _origin
      }
    });
    const res = req.response;
    if (!res.success && res.error) {
      throw getApiError(res.error);
    }
    if (res.success) {
      if (res.accountPub) {
        return res.accountPub;
      }
      throw getApiError({ code: ApiErrorCode.InternalError, info: "accountPub missing" });
    }
    throw getApiError(null, "getAccountPub");
  };
  const getPubDRepKey = async () => {
    const req = await _callApi({
      reqId: getRandomId(),
      api: METHOD.getPubDRepKey,
      payload: {
        origin: _origin
      }
    });
    const res = req.response;
    if (!res.success && res.error) {
      throw getApiError(res.error);
    }
    if (res.success) {
      if (res.drepPubKey) {
        return res.drepPubKey;
      }
      throw getApiError({ code: ApiErrorCode.InternalError, info: "drepPubKey missing" });
    }
    throw getApiError(null, "getPubDRepKey");
  };
  const getRegisteredPubStakeKeys = async () => {
    const req = await _callApi({
      reqId: getRandomId(),
      api: METHOD.getRegisteredPubStakeKeys,
      payload: {
        origin: _origin
      }
    });
    const res = req.response;
    if (!res.success && res.error) {
      throw getApiError(res.error);
    }
    if (res.success) {
      if (res.pubStakeKeyList && Array.isArray(res.pubStakeKeyList)) {
        return res.pubStakeKeyList;
      }
      throw getApiError({ code: ApiErrorCode.InternalError, info: "pubStakeKeyList missing" });
    }
    throw getApiError(null, "getRegisteredPubStakeKeys");
  };
  const getUnregisteredPubStakeKeys = async () => {
    const req = await _callApi({
      reqId: getRandomId(),
      api: METHOD.getUnregisteredPubStakeKeys,
      payload: {
        origin: _origin
      }
    });
    const res = req.response;
    if (!res.success && res.error) {
      throw getApiError(res.error);
    }
    if (res.success) {
      if (res.pubStakeKeyList && Array.isArray(res.pubStakeKeyList)) {
        return res.pubStakeKeyList;
      }
      throw getApiError({ code: ApiErrorCode.InternalError, info: "pubStakeKeyList missing" });
    }
    throw getApiError(null, "getRegisteredPubStakeKeys");
  };
  const doEnableLogs = async (enable2) => {
    enableLogs(enable2);
    const req = await _callApi({
      reqId: getRandomId(),
      api: METHOD.enableLogs,
      payload: {
        origin: _origin,
        enable: enable2
      }
    });
    const res = req.response;
    if (!res.success) {
      throw getApiError(res.error, "enableLogs");
    }
    return enable2;
  };
  const experimentalInitial = {
    appVersion,
    enableLogs: doEnableLogs
  };
  const experimentalFull = {
    appVersion,
    getCollateral,
    getLockedUtxos,
    signTxs,
    // TODO: remove at a later stage when jpg has moved to new namespaced endpoint
    syncAccount,
    getForcedUnusedAddresses
  };
  const initialApi = {
    isEnabled,
    enable,
    supportedExtensions,
    experimental: experimentalInitial,
    apiVersion,
    name,
    icon
  };
  const cip30Api = {
    getExtensions,
    // whitelisted extensions for origin
    getNetworkId,
    getUsedAddresses,
    getUnusedAddresses,
    getRewardAddresses,
    getChangeAddress,
    getBalance,
    getUtxos,
    signTx,
    signData,
    submitTx,
    getCollateral,
    experimental: experimentalFull
  };
  const cip95Api = {
    cip95: {
      getPubDRepKey,
      getRegisteredPubStakeKeys,
      getUnregisteredPubStakeKeys,
      signTx,
      signData
    }
  };
  const cip103Api = { cip103: { signTxs } };
  const cip104Api = { cip104: { getAccountPub } };
  const apiMap = {
    [extCip30.cip]: cip30Api,
    [extCip95.cip]: cip95Api,
    [extCip103.cip]: cip103Api,
    [extCip104.cip]: cip104Api
  };
  function apiDom(bridge) {
    _bridge = bridge ?? null;
    if (typeof window === "undefined") {
      return;
    }
    cardano.eternl = initialApi;
  }
  const getApiError = (error, label) => {
    return new ApiError(
      (error == null ? void 0 : error.code) ?? ApiErrorCode.InternalError,
      (error == null ? void 0 : error.info) ?? "unknown error " + (label ?? "api")
    );
  };
  const getTxSignError = (error, label) => {
    return new TxSignError(
      (error == null ? void 0 : error.code) ?? TxSignErrorCode.UserDeclined,
      (error == null ? void 0 : error.info) ?? "unknown error api"
    );
  };
  const getDataSignError = (error, label) => {
    return new DataSignError(
      (error == null ? void 0 : error.code) ?? DataSignErrorCode.UserDeclined,
      (error == null ? void 0 : error.info) ?? "unknown error api"
    );
  };
  const getTxSendError = (error, label) => {
    return new TxSendError(
      (error == null ? void 0 : error.code) ?? TxSendErrorCode.Failure,
      (error == null ? void 0 : error.info) ?? "unknown error api"
    );
  };
  const getPaginateError = (error, label) => {
    return new PaginateError(
      (error == null ? void 0 : error.maxPages) ?? -1,
      (error == null ? void 0 : error.info) ?? "unknown error api"
    );
  };
  const storeId = "dom";
  const _reqIdMap = /* @__PURE__ */ new Map();
  const _reqResolveMap = /* @__PURE__ */ new Map();
  const _reqRejectMap = /* @__PURE__ */ new Map();
  const _sendList = [];
  const sender = {
    send: (data) => {
      data.channel = ApiChannel.domToCS;
      const req = new Promise((resolve, reject) => {
        _reqResolveMap.set(data.reqId, resolve);
        _reqRejectMap.set(data.reqId, reject);
        _sendList.push(data);
      });
      _reqIdMap.set(data.reqId, req);
      return req;
    }
  };
  const initEternlDomAPI = () => {
    if (typeof window === "undefined") {
      return;
    }
    if (!window.hasOwnProperty("cardano")) {
      window.cardano = {};
    }
    setInterval(() => {
      if (_sendList.length === 0) {
        return;
      }
      window.postMessage(_sendList.shift(), "*");
    }, 16);
    window.addEventListener("message", (msg) => {
      const data = msg.data;
      if (msg.source != window) {
        return;
      }
      if (((data == null ? void 0 : data.channel) ?? "") !== ApiChannel.csToDom) {
        return;
      }
      const reqId = data.reqId ?? null;
      if (!reqId) {
        {
          console.error(el(storeId), sl("receive:pm"), "no reqId", data);
        }
        return;
      }
      const resolve = _reqResolveMap.get(reqId) ?? null;
      const reject = _reqRejectMap.get(reqId) ?? null;
      _reqResolveMap.delete(reqId);
      _reqRejectMap.delete(reqId);
      _reqRejectMap.delete(reqId);
      if (!resolve || !reject) {
        {
          console.error(el(storeId), sl("receive:pm"), "req already handled", data);
        }
        return;
      }
      resolve(data);
    });
    apiDom(sender);
  };
  initEternlDomAPI();
})();
