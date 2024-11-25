import { iP as getDappFavorites, z as ref, f as computed, V as nextTick, iQ as addDappBrowserFavorite$1, K as networkId, _ as isStagingApp, L as api, eE as el, iR as delDappBrowserFavorite$1, d as defineComponent, ez as useSlots, o as openBlock, a as createBlock, e as createBaseVNode, n as normalizeClass, b as withModifiers, ab as withKeys, c as createElementBlock, aA as renderSlot, j as createCommentVNode, F as withDirectives, J as vShow, iO as Teleport, a5 as toRefs, be as useWalletAccount, d8 as getIDAppConnectEntry, D as watch, aW as addSignalListener, bw as onTxSignSubmit, bx as onTxSignCancel, bG as onDataSignSubmit, bH as onDataSignCancel, aX as removeSignalListener, aG as onUnmounted, C as onMounted, u as unref, h as withCtx, q as createVNode, t as toDisplayString, i as createTextVNode, cf as getRandomId, iS as getIDAppConnectProperty, iT as TxSignErrorCode, iU as DataSignErrorCode, iV as useDAppBrowser, aI as useGuard, iW as getTxSignParseError, aZ as ErrorSignTx, iX as parseTxList, iY as parseData, iZ as getDataSignParseError } from "./index.js";
import { u as useTranslation } from "./useTranslation.js";
import { _ as _sfc_main$2 } from "./GridHeadline.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$3 } from "./GridButtonCountdown.vue_vue_type_script_setup_true_lang.js";
const _favorites = getDappFavorites([]);
const entryList = ref([]);
const favorites = computed(() => _favorites.value);
let _timeoutId = -1;
const updateEntryList = async () => {
  clearTimeout(_timeoutId);
  const newList = await fetchDappBrowserEntries(networkId.value);
  const filteredList = isStagingApp() ? newList.filter((item) => item.hasOwnProperty("staging")) : newList.filter((item) => item.hasOwnProperty("production"));
  entryList.value.splice(0);
  entryList.value.push(...filteredList);
  _timeoutId = setTimeout(() => {
    updateEntryList();
  }, 15 * 60 * 1e3);
};
const addDappBrowserFavorite = (id) => {
  if (_favorites.value.includes(id)) {
    return;
  }
  addDappBrowserFavorite$1(id);
};
const delDappBrowserFavorite = (id) => {
  const index = _favorites.value.findIndex((f) => f === id);
  if (index >= 0) {
    delDappBrowserFavorite$1(index);
  }
};
const fetchDappBrowserEntries = async (networdId) => {
  var _a;
  const url = `/${networdId}/v1/dapps/entries`;
  const res = await api.get(url).catch((err) => {
    console.error(el("fetchDappBrowserEntries"), el(`url=${url}`), (err == null ? void 0 : err.message) ?? err);
  });
  if ((_a = res == null ? void 0 : res.data) == null ? void 0 : _a.list) {
    return res.data.list;
  }
  return [];
};
const init = () => {
  entryList.value.splice(0);
  return updateEntryList();
};
nextTick(() => {
  init();
});
var DAppEntryEvent = /* @__PURE__ */ ((DAppEntryEvent2) => {
  DAppEntryEvent2["maximize"] = "maximize";
  DAppEntryEvent2["connect"] = "connect";
  DAppEntryEvent2["disconnect"] = "disconnect";
  return DAppEntryEvent2;
})(DAppEntryEvent || {});
const observerList = [];
const addObserver = (observer) => {
  observerList.push(observer);
};
const removeObserver = (observer) => {
  for (let i = observerList.length - 1; i >= 0; i--) {
    if (observerList[i].event === observer.event && observerList[i].callback === observer.callback) {
      observerList.splice(i, 1);
    }
  }
};
const emitEvent = (event, dappId) => {
  for (const observer of observerList) {
    if (observer.event === event) {
      observer.callback(event, dappId);
    }
  }
};
function useDAppBrowserEvents() {
  return {
    addObserver,
    removeObserver,
    emitEvent
  };
}
const _hoisted_1$1 = { class: "relative w-full h-full cc-layout-py" };
const _hoisted_2$1 = {
  key: 0,
  class: "basis-8 min-h-8 shrink-0 w-full flex flex-col flex-nowrap justify-start items-start text-neutral-200"
};
const _hoisted_3$1 = {
  key: 1,
  class: "relative grow w-full h-full cc-bg-light-0"
};
const _hoisted_4$1 = {
  key: 2,
  class: "basis-8 min-h-8 shrink-0 w-full cc-bg-white-0"
};
const _sfc_main$1 = /* @__PURE__ */ defineComponent({
  __name: "DAppBrowserModal",
  props: {
    wide: { type: Boolean, required: false, default: false },
    narrow: { type: Boolean, required: false, default: false },
    fullWidthOnMobile: { type: Boolean, required: false, default: false },
    htmlId: { type: String, required: true },
    maxHeight: { type: Boolean, required: false, default: false },
    persistent: { type: Boolean, required: false, default: false },
    startMinimized: { type: Boolean, required: false, default: false }
  },
  emits: ["close"],
  setup(__props, { expose: __expose, emit: __emit }) {
    const props = __props;
    const emit = __emit;
    const slots = useSlots();
    useTranslation();
    const hasSlotHeader = computed(() => typeof slots.header !== "undefined");
    const hasSlotContent = computed(() => typeof slots.content !== "undefined");
    const hasSlotFooter = computed(() => typeof slots.footer !== "undefined");
    const initLoad = ref(false);
    const isMinimized = ref(props.startMinimized);
    const handleESC = () => !props.persistent && handleClose();
    const handleClose = () => {
      setTimeout(() => {
        emit("close");
      }, 200);
    };
    const handleMinimize = () => {
      isMinimized.value = true;
    };
    const handleMaximize = () => {
      if (!initLoad.value) {
        initLoad.value = true;
      }
      isMinimized.value = false;
    };
    const disconnect = () => {
      initLoad.value = false;
      isMinimized.value = true;
    };
    __expose({
      handleMaximize,
      disconnect
    });
    return (_ctx, _cache) => {
      return openBlock(), createBlock(Teleport, { to: "#eternl-dapp-store-iframe" }, [
        createBaseVNode("div", {
          class: normalizeClass([__props.htmlId + " " + (isMinimized.value ? "top-0 left-0 w-full h-full" : "inset-0 w-screen h-screen"), "dapp-browser-iframe absolute block"]),
          onKeydown: withKeys(handleESC, ["esc"])
        }, [
          createBaseVNode("div", _hoisted_1$1, [
            createBaseVNode("div", {
              class: normalizeClass(["relative w-full h-full flex flex-col flex-nowrap justify-center items-center", (__props.fullWidthOnMobile ? "" : "px-0") + " " + (isMinimized.value ? "" : "pt-modal cc-layout-px pb-8")])
            }, [
              createBaseVNode("div", {
                class: "absolute inset-0 w-full h-full cursor-pointer bg-black/50",
                onClick: withModifiers(handleClose, ["stop", "prevent"])
              }),
              createBaseVNode("div", {
                class: normalizeClass(["relative w-full flex flex-col flex-nowrap justify-start items-start overflow-hidden cc-bg-white-0", (__props.wide ? "max-w-full" : __props.narrow ? "max-w-xl" : "cc-site-max-width") + " " + (__props.maxHeight ? "h-full" : "") + " " + (__props.fullWidthOnMobile ? "md:cc-rounded" : "cc-rounded")]),
                onKeydown: withKeys(handleESC, ["esc"])
              }, [
                hasSlotHeader.value && !isMinimized.value ? (openBlock(), createElementBlock("div", _hoisted_2$1, [
                  renderSlot(_ctx.$slots, "header")
                ])) : createCommentVNode("", true),
                initLoad.value ? withDirectives((openBlock(), createElementBlock("div", _hoisted_3$1, [
                  renderSlot(_ctx.$slots, "content")
                ], 512)), [
                  [vShow, hasSlotContent.value && !isMinimized.value]
                ]) : createCommentVNode("", true),
                hasSlotFooter.value && !isMinimized.value ? (openBlock(), createElementBlock("div", _hoisted_4$1, [
                  renderSlot(_ctx.$slots, "footer")
                ])) : createCommentVNode("", true),
                !isMinimized.value ? (openBlock(), createElementBlock("button", {
                  key: 3,
                  class: "absolute right-0 top-0 w-8 h-8 cc-rounded z-max hover:bg-neutral-600 cc-text-lg text-neutral-200",
                  onClick: withModifiers(handleMinimize, ["stop", "prevent"])
                }, _cache[0] || (_cache[0] = [
                  createBaseVNode("i", { class: "mdi mdi-window-minimize" }, null, -1)
                ]))) : createCommentVNode("", true)
              ], 34)
            ], 2)
          ])
        ], 34)
      ]);
    };
  }
});
const _hoisted_1 = { class: "h-16 flex justify-center items-center" };
const _hoisted_2 = { class: "absolute left-1 top-0 w-6 h-8 cc-rounded cc-text-lg flex justify-center items-center" };
const _hoisted_3 = {
  key: 0,
  class: "relative w-5 h-5 border-2 border-gray-400 shadow rounded-md bg-blue-500/5"
};
const _hoisted_4 = { class: "absolute top-0 left-6 text-xs whitespace-nowrap" };
const _hoisted_5 = { class: "col-span-12 grid grid-cols-12 cc-bg-white-0 rounded-borders m-3 p-10 h-5/6" };
const _hoisted_6 = { class: "col-span-12 cc-text-extra-bold cc-text-red-light text-3xl" };
const _hoisted_7 = { class: "col-span-12 mt-6 w-full max-w-full text-xl" };
const _hoisted_8 = ["innerHTML"];
const _hoisted_9 = { class: "w-full h-full py-0 flex flex-col flex-nowrap justify-center items-center" };
const _hoisted_10 = ["allow", "src"];
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "DAppIframe",
  props: {
    accountId: { type: String, required: true },
    walletId: { type: String, required: true },
    dappConnect: { type: Object, required: true },
    htmlId: { type: String, required: true },
    isStaging: { type: Boolean, required: true }
  },
  emits: ["connected", "close", "ready"],
  setup(__props, { emit: __emit }) {
    const props = __props;
    const emit = __emit;
    const storeId = "DAppIframe" + getRandomId();
    const {
      accountId,
      walletId
    } = toRefs(props);
    const { it, c, t } = useTranslation();
    const { appAccount } = useWalletAccount(walletId, accountId);
    const {
      addObserver: addObserver2,
      removeObserver: removeObserver2
    } = useDAppBrowserEvents();
    const dappIframe = ref(null);
    const modal = ref(null);
    const {
      initConnection,
      resetConnection,
      setSignDataCallback,
      setSignTxCallback
    } = useDAppBrowser(appAccount);
    const { isDomainOnBlockList } = useGuard();
    const isConnected = ref(false);
    const iframeUrl = ref("");
    const attempts = ref(0);
    const isScam = ref(false);
    const ackScam = ref(false);
    const updateURL = async () => {
      var _a, _b, _c, _d;
      const url = getIDAppConnectProperty(props.dappConnect, "url", props.isStaging);
      const hasParams = (url == null ? void 0 : url.includes("?")) ?? false;
      iframeUrl.value = url + (!hasParams ? "?" : "&") + "r=" + Math.floor(Math.random() * 9999999);
      if ((_b = (_a = props.dappConnect) == null ? void 0 : _a.production) == null ? void 0 : _b.url) {
        if (await isDomainOnBlockList((_d = (_c = props.dappConnect) == null ? void 0 : _c.production) == null ? void 0 : _d.url)) {
          isScam.value = true;
        } else {
          isScam.value = false;
        }
      }
    };
    const entry = getIDAppConnectEntry(props.dappConnect, props.isStaging);
    updateURL();
    const onTryConnect = async () => {
      if (!dappIframe.value) {
        retryConnect(500);
        return;
      }
      const _appAccount = appAccount.value;
      if (!_appAccount) {
        retryConnect(500);
        return;
      }
      if (isConnected.value) return;
      try {
        setSignTxCallback(prepareTx);
        setSignDataCallback(prepareData);
        resetConnection();
        const connected = await initConnection(props.dappConnect, dappIframe.value);
        if (connected) {
          isConnected.value = connected;
          props.dappConnect.isConnected = connected;
          emit("connected");
        } else {
          if (attempts.value < 20) {
            attempts.value = attempts.value + 1;
            retryConnect(1e3);
          }
        }
      } catch (e) {
        if (attempts.value < 20) {
          attempts.value = attempts.value + 1;
          retryConnect(1e3);
        }
      }
    };
    let currentSignDataResolve = null;
    let currentSignDataReject = null;
    let currentSignTxResolve = null;
    let currentSignTxReject = null;
    const prepareTx = async () => {
      return new Promise(async (resolve, reject) => {
        currentSignTxResolve = resolve;
        currentSignTxReject = reject;
        try {
          if (!appAccount.value) {
            getTxSignParseError(ErrorSignTx.missingAccountData, onErrorTx, " - not set - db");
            return;
          }
          if (await parseTxList(appAccount.value, "dapp")) {
          }
        } catch (err) {
          getTxSignParseError(err, onErrorTx);
        }
      });
    };
    const onErrorTx = (errorCode, info = "") => {
      console.warn("onErrorTx", errorCode, info, currentSignTxReject);
      if (currentSignTxReject) currentSignTxReject({
        code: errorCode,
        info
      });
      _resetSignTx();
    };
    const onCancelTx = () => onErrorTx(TxSignErrorCode.UserDeclined, "user declined to sign transaction");
    const onSubmitTx = (witnessSetList) => {
      console.warn("onSubmitTx", witnessSetList);
      if (currentSignTxResolve) currentSignTxResolve(witnessSetList);
      _resetSignTx();
    };
    const _resetSignTx = () => {
      currentSignTxResolve = null;
      currentSignTxReject = null;
    };
    const onErrorData = (errorCode, info = "") => {
      console.warn("onErrorData", errorCode, info, currentSignDataReject);
      if (currentSignDataReject) currentSignDataReject({
        code: errorCode,
        info
      });
      _resetSignData();
    };
    const prepareData = async () => {
      return new Promise(async (resolve, reject) => {
        currentSignDataResolve = resolve;
        currentSignDataReject = reject;
        try {
          if (await parseData(appAccount.value, "dapp")) {
          }
        } catch (err) {
          getDataSignParseError(err, onErrorData);
        }
      });
    };
    const onCancelData = () => onErrorData(DataSignErrorCode.UserDeclined, "user declined to sign data");
    const onSubmitData = (payload) => {
      console.warn("onSubmitData", payload, currentSignDataResolve);
      if (currentSignDataResolve) currentSignDataResolve(payload.signedData);
      _resetSignData();
    };
    const _resetSignData = () => {
      currentSignDataResolve = null;
      currentSignDataReject = null;
    };
    watch(isConnected, (value, oldValue) => {
      if (value) {
        addSignalListener(onTxSignSubmit, storeId, onSubmitTx);
        addSignalListener(onTxSignCancel, storeId, onCancelTx);
        addSignalListener(onDataSignSubmit, storeId, onSubmitData);
        addSignalListener(onDataSignCancel, storeId, onCancelData);
      } else {
        removeSignalListener(onTxSignSubmit, storeId);
        removeSignalListener(onTxSignCancel, storeId);
        removeSignalListener(onDataSignSubmit, storeId);
        removeSignalListener(onDataSignCancel, storeId);
      }
    });
    onUnmounted(() => {
      removeSignalListener(onTxSignSubmit, storeId);
      removeSignalListener(onTxSignCancel, storeId);
      removeSignalListener(onDataSignSubmit, storeId);
      removeSignalListener(onDataSignCancel, storeId);
    });
    function onClose() {
      _resetSignTx();
      _resetSignData();
      handleDisconnect();
      ackScam.value = false;
      emit("close");
    }
    function handleMaximize() {
      retryConnect();
      if (modal.value) modal.value.handleMaximize();
    }
    function handleConnect() {
      if (modal.value) {
        if (isConnected.value) {
          modal.value.disconnect();
          isConnected.value = false;
          props.dappConnect.isConnected = false;
          updateURL();
        } else {
          handleMaximize();
        }
      }
    }
    function handleDisconnect() {
      resetConnection();
      if (modal.value) {
        if (isConnected.value) {
          modal.value.disconnect();
          isConnected.value = false;
          props.dappConnect.isConnected = false;
          updateURL();
        }
      }
    }
    const onDAppEntryEvent = async (event, dappId) => {
      if (dappId === props.dappConnect.id) {
        switch (event) {
          case DAppEntryEvent.connect:
            handleConnect();
            break;
          case DAppEntryEvent.disconnect:
            handleDisconnect();
            break;
          case DAppEntryEvent.maximize:
            handleMaximize();
            break;
        }
      }
    };
    function resetOnDisconnectedDAppAccount() {
      props.dappConnect.isConnected = false;
      isConnected.value = false;
      if (modal.value) {
        modal.value.disconnect();
      }
      onClose();
    }
    let toid = -1;
    const retryConnect = (ms = 500) => {
      clearTimeout(toid);
      toid = setTimeout(() => {
        onTryConnect();
      }, ms);
    };
    onMounted(() => {
      nextTick(() => {
        nextTick(() => {
          addObserver2({ callback: onDAppEntryEvent, event: DAppEntryEvent.connect });
          addObserver2({ callback: onDAppEntryEvent, event: DAppEntryEvent.disconnect });
          addObserver2({ callback: onDAppEntryEvent, event: DAppEntryEvent.maximize });
          emit("ready");
          retryConnect();
        });
      });
    });
    onUnmounted(() => {
      removeObserver2({ callback: onDAppEntryEvent, event: DAppEntryEvent.connect });
      removeObserver2({ callback: onDAppEntryEvent, event: DAppEntryEvent.disconnect });
      removeObserver2({ callback: onDAppEntryEvent, event: DAppEntryEvent.maximize });
      resetOnDisconnectedDAppAccount();
    });
    watch(() => props.accountId, (accountIdNew, accountIdOld) => {
      if (accountIdNew !== accountIdOld) {
        resetOnDisconnectedDAppAccount();
      }
    });
    return (_ctx, _cache) => {
      return unref(entry) ? (openBlock(), createBlock(_sfc_main$1, {
        key: 0,
        ref_key: "modal",
        ref: modal,
        "html-id": __props.htmlId,
        onClose,
        "max-height": "",
        "full-width-on-mobile": "",
        "start-minimized": ""
      }, {
        header: withCtx(() => [
          createBaseVNode("div", {
            class: normalizeClass(["w-full h-full px-2 py-1 flex flex-col flex-nowrap justify-center items-center", isConnected.value ? unref(c)("gradient") : ""])
          }, [
            createBaseVNode("div", _hoisted_1, [
              createVNode(_sfc_main$2, {
                label: unref(entry).label,
                "do-capitalize": false
              }, null, 8, ["label"])
            ]),
            createBaseVNode("div", _hoisted_2, [
              !isConnected.value ? (openBlock(), createElementBlock("div", _hoisted_3, [
                _cache[0] || (_cache[0] = createBaseVNode("div", { class: "relative mt-1 ml-1 w-2 h-2 bg-gray-400 drop-shadow rounded-sm" }, null, -1)),
                createBaseVNode("div", _hoisted_4, "connecting (" + toDisplayString(attempts.value) + ")...", 1)
              ])) : createCommentVNode("", true)
            ])
          ], 2)
        ]),
        content: withCtx(() => [
          isScam.value ? (openBlock(), createElementBlock("div", {
            key: 0,
            class: normalizeClass([!ackScam.value ? "absolute h-full" : "h-1/3", "z-10 w-full py-0 justify-center items-center hazard-border grid grid-cols-12"])
          }, [
            createBaseVNode("div", _hoisted_5, [
              createBaseVNode("div", _hoisted_6, toDisplayString(unref(it)("common.scam.guard.warning")), 1),
              createBaseVNode("div", _hoisted_7, [
                createTextVNode(toDisplayString(unref(t)("common.scam.app.description")) + " ", 1),
                _cache[1] || (_cache[1] = createBaseVNode("br", null, null, -1)),
                _cache[2] || (_cache[2] = createBaseVNode("br", null, null, -1)),
                createBaseVNode("span", {
                  innerHTML: unref(it)("common.scam.app.description2")
                }, null, 8, _hoisted_8)
              ]),
              !ackScam.value ? (openBlock(), createBlock(_sfc_main$3, {
                key: 0,
                class: "col-start-8 col-span-4 w-full mt-6 p-2 h-12 justify-end",
                label: "Confirm risk!",
                link: () => ackScam.value = true,
                duration: 10
              }, null, 8, ["link"])) : createCommentVNode("", true)
            ])
          ], 2)) : createCommentVNode("", true),
          createBaseVNode("div", _hoisted_9, [
            createBaseVNode("iframe", {
              ref_key: "dappIframe",
              ref: dappIframe,
              allow: "camera; microphone; geolocation; clipboard-read self " + unref(entry).origin + "; clipboard-write self " + unref(entry).origin + "; ",
              src: iframeUrl.value,
              class: "w-full h-full"
            }, null, 8, _hoisted_10)
          ])
        ]),
        _: 1
      }, 8, ["html-id"])) : createCommentVNode("", true);
    };
  }
});
export {
  DAppEntryEvent as D,
  _sfc_main as _,
  addDappBrowserFavorite as a,
  delDappBrowserFavorite as d,
  entryList as e,
  favorites as f,
  useDAppBrowserEvents as u
};
