import { d7 as getApiURL, d as defineComponent, f as computed, d8 as getIDAppConnectEntry, u as unref, o as openBlock, c as createElementBlock, b as withModifiers, j as createCommentVNode, t as toDisplayString, n as normalizeClass, e as createBaseVNode, z as ref, D as watch, r as resolveComponent, q as createVNode, h as withCtx, H as Fragment, S as reactive, C as onMounted, w as watchEffect, V as nextTick, a as createBlock, _ as isStagingApp, I as renderList, be as useWalletAccount, d9 as getWalletNameList, k as dispatchSignalSync, da as doToggleDappAccountId, a7 as useQuasar, ct as onErrorCaptured, aG as onUnmounted, i as createTextVNode, Q as QSpinnerDots_default, bk as QSpinner_default, a9 as timestampLocal, K as networkId } from "./index.js";
import { u as useDappAccount } from "./useDappAccount.js";
import { f as favorites, d as delDappBrowserFavorite, a as addDappBrowserFavorite, e as entryList, D as DAppEntryEvent, u as useDAppBrowserEvents, _ as _sfc_main$b } from "./DAppIframe.vue_vue_type_script_setup_true_lang.js";
import { u as useTranslation } from "./useTranslation.js";
import { _ as _sfc_main$h } from "./Page.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$e, a as _sfc_main$f } from "./WalletIcon.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$g } from "./GridTabs.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$a, a as _sfc_main$c } from "./GridHeadline.vue_vue_type_script_setup_true_lang.js";
import { G as GridSpace } from "./GridSpace.js";
import { _ as _sfc_main$9 } from "./GridTextArea.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$7 } from "./Tooltip.vue_vue_type_script_setup_true_lang.js";
import { _ as _export_sfc } from "./_plugin-vue_export-helper.js";
import { G as GridInputAutocomplete } from "./GridInputAutocomplete.js";
import { _ as _sfc_main$6 } from "./ScanQrCode.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$8 } from "./QrcodeStream.js";
import { p as processFile } from "./scanner.js";
import { u as useUiSelectedAccount } from "./uiSelectedAccount.js";
import { _ as _sfc_main$d } from "./DAppsAccountItem.vue_vue_type_script_setup_true_lang.js";
import { r as removeBackground, s as setWalletBackground } from "./ExtBackground.js";
import "./NetworkId.js";
import "./GridButtonCountdown.vue_vue_type_script_setup_true_lang.js";
import "./GridButtonPrimary.vue_vue_type_script_setup_true_lang.js";
import "./GridButton.vue_vue_type_script_setup_true_lang.js";
import "./useBalanceVisible.js";
import "./FormattedAmount.vue_vue_type_script_setup_true_lang.js";
import "./Clipboard.js";
import "./lz-string.js";
import "./useTabId.js";
import "./IconError.js";
import "./GridButtonSecondary.js";
import "./Modal.js";
import "./AccountItemBalance.vue_vue_type_script_setup_true_lang.js";
import "./GridButtonWarning.vue_vue_type_script_setup_true_lang.js";
const getImageURL = (image) => {
  return getApiURL() + image;
};
const _hoisted_1$4 = ["src"];
const _hoisted_2$3 = {
  key: 3,
  class: "grow h-auto text-left pl-4"
};
const _hoisted_3$3 = {
  key: 0,
  class: "relative w-5 h-5 border-2 cc-border-green shadow rounded-md"
};
const _hoisted_4$2 = {
  key: 1,
  class: "relative w-5 h-5 border-2 border-gray-400 shadow rounded-md bg-blue-500/5"
};
const _sfc_main$5 = /* @__PURE__ */ defineComponent({
  __name: "DAppBrowserFavoriteEntry",
  props: {
    dappConnect: { type: Object, required: true },
    isStaging: { type: Boolean, required: true },
    isFeatured: { type: Boolean, required: true },
    onlyFavs: { type: Boolean, required: false },
    htmlId: { type: String, required: true }
  },
  emits: ["connect", "disconnect", "maximize", "favChanged"],
  setup(__props, { emit: __emit }) {
    const props = __props;
    const emit = __emit;
    const isFav = computed(() => favorites.value.includes(props.htmlId));
    function handleMaximize() {
      emit("maximize", props.dappConnect);
    }
    function handleConnect() {
      emit("connect", props.dappConnect);
    }
    function handleDelete() {
      emit("disconnect", props.dappConnect);
    }
    const entry = getIDAppConnectEntry(props.dappConnect, props.isStaging);
    const imageURL = () => {
      var _a;
      if (!entry || !entry.image[entry.type]) {
        return void 0;
      }
      return ((_a = entry.image[entry.type]) == null ? void 0 : _a.startsWith("http")) ? entry.image[entry.type] : getImageURL(entry.image[entry.type]);
    };
    function toggleFavorite(id) {
      console.log("toggleFavorite", id, JSON.stringify(isFav.value));
      if (isFav.value) {
        delDappBrowserFavorite(id);
      } else {
        addDappBrowserFavorite(id);
      }
      emit("favChanged", props.dappConnect);
    }
    return (_ctx, _cache) => {
      var _a;
      return unref(entry) && (__props.onlyFavs ? isFav.value : true) ? (openBlock(), createElementBlock("div", {
        key: 0,
        class: normalizeClass(["relative cc-area-light text-center cursor-pointer overflow-hidden flex flex-row flex-nowrap justify-start items-center", __props.isFeatured ? "" : "space-x-2 px-2 py-2"])
      }, [
        !isFav.value ? (openBlock(), createElementBlock("i", {
          key: 0,
          onClick: _cache[0] || (_cache[0] = ($event) => toggleFavorite(__props.htmlId)),
          class: "mdi mdi-star-outline absolute left-1 top-1 text-2xl text-gray-400"
        })) : (openBlock(), createElementBlock("i", {
          key: 1,
          onClick: _cache[1] || (_cache[1] = ($event) => toggleFavorite(__props.htmlId)),
          class: "mdi mdi-star absolute left-1 top-1 text-2xl cc-text-green"
        })),
        __props.isFeatured && unref(entry).image[unref(entry).type] ? (openBlock(), createElementBlock("img", {
          key: 2,
          onClick: withModifiers(handleMaximize, ["prevent", "stop"]),
          src: imageURL(),
          class: "w-full h-full object-cover",
          alt: ""
        }, null, 8, _hoisted_1$4)) : createCommentVNode("", true),
        !__props.isFeatured || !imageURL() ? (openBlock(), createElementBlock("div", _hoisted_2$3, toDisplayString((_a = unref(entry)) == null ? void 0 : _a.label), 1)) : createCommentVNode("", true),
        !__props.isFeatured ? (openBlock(), createElementBlock("button", {
          key: 4,
          class: normalizeClass(["absolute right-8 sm:right-9 w-6 h-8 cc-rounded cc-text-lg flex justify-center items-center", __props.isFeatured ? "top-0 sm:top-1" : "top-1"]),
          onClick: withModifiers(handleDelete, ["stop", "prevent"])
        }, _cache[2] || (_cache[2] = [
          createBaseVNode("i", { class: "mdi mdi-trash-can-outline text-gray-400 drop-shadow text-xl" }, null, -1)
        ]), 2)) : createCommentVNode("", true),
        createBaseVNode("button", {
          class: normalizeClass(["absolute right-1 sm:right-2 top-0 sm:top-1 w-6 h-8 cc-rounded cc-text-lg flex justify-center items-center", __props.isFeatured ? "top-0 sm:top-1" : "top-1 sm:top-1"]),
          onClick: withModifiers(handleConnect, ["stop", "prevent"])
        }, [
          __props.dappConnect.isConnected ? (openBlock(), createElementBlock("div", _hoisted_3$3, _cache[3] || (_cache[3] = [
            createBaseVNode("div", { class: "relative mt-0.5 ml-0.5 w-3 h-3 cc-bg-green drop-shadow rounded-sm" }, null, -1)
          ]))) : (openBlock(), createElementBlock("div", _hoisted_4$2, _cache[4] || (_cache[4] = [
            createBaseVNode("div", { class: "relative mt-1 ml-1 w-2 h-2 bg-gray-400 drop-shadow rounded-sm" }, null, -1)
          ])))
        ], 2)
      ], 2)) : createCommentVNode("", true);
    };
  }
});
const _sfc_main$4 = {};
const _hoisted_1$3 = {
  xmlns: "http://www.w3.org/2000/svg",
  class: "h-6 w-6",
  fill: "none",
  viewBox: "0 0 24 24",
  stroke: "currentColor",
  "stroke-width": "2"
};
function _sfc_render$1(_ctx, _cache) {
  return openBlock(), createElementBlock("svg", _hoisted_1$3, _cache[0] || (_cache[0] = [
    createBaseVNode("path", {
      "stroke-linecap": "round",
      "stroke-linejoin": "round",
      d: "M3.055 11H5a2 2 0 012 2v1a2 2 0 002 2 2 2 0 012 2v2.945M8 3.935V5.5A2.5 2.5 0 0010.5 8h.5a2 2 0 012 2 2 2 0 104 0 2 2 0 012-2h1.064M15 20.488V18a2 2 0 012-2h3.064M21 12a9 9 0 11-18 0 9 9 0 0118 0z"
    }, null, -1)
  ]));
}
const IconGlobe = /* @__PURE__ */ _export_sfc(_sfc_main$4, [["render", _sfc_render$1]]);
const _sfc_main$3 = defineComponent({
  name: "DAppBrowserURLInput",
  components: {
    IconGlobe,
    GridInputAutocomplete,
    ScanQrCode: _sfc_main$6,
    Tooltip: _sfc_main$7
  },
  props: {
    textId: { type: String, required: true, default: "dapps.browser.urlInput" },
    disabled: { type: Boolean, required: false, default: false }
  },
  emits: ["submit"],
  mixins: [_sfc_main$8],
  setup(props, { emit }) {
    const { it } = useTranslation();
    const urlInput = ref("");
    const urlInputError = ref("");
    function validateUrlInput() {
      urlInputError.value = "";
      if (!urlInput.value || urlInput.value.length === 0) {
        return;
      }
      const url = urlInput.value;
      return !!url;
    }
    let timeoutId = -1;
    watch(urlInput, () => {
      clearTimeout(timeoutId);
      timeoutId = setTimeout(async () => {
        validateUrlInput();
      }, 350);
    });
    function onReset() {
      urlInput.value = "";
      urlInputError.value = "";
    }
    function onSubmit(force = false) {
      if (validateUrlInput()) {
        let url = urlInput.value;
        if (!url.startsWith("http")) {
          url = "https://" + url;
        }
        emit("submit", url);
        onReset();
      }
    }
    function onQrCode(payload) {
      var _a;
      urlInput.value = payload.content;
      (_a = document.getElementById("urlInput")) == null ? void 0 : _a.focus();
    }
    const onPaste = async (e) => {
      var _a, _b;
      e.stopPropagation();
      e.preventDefault();
      let clipboardData = ((_a = e.clipboardData) == null ? void 0 : _a.getData("Text")) ?? "";
      const items = (_b = e.clipboardData) == null ? void 0 : _b.items;
      if (items) {
        let clipboardData1 = await getQrCodeData(items);
        if (clipboardData1) {
          clipboardData = clipboardData1;
        }
      }
      urlInput.value = clipboardData.trim().split(/(\s+)/).sort((a, b) => a.length - b.length).pop() ?? "";
    };
    const getQrCodeData = async (items) => {
      for (let i = 0; i < items.length; i++) {
        if (items[i] && items[i].type.indexOf("image") == -1) continue;
        if (items[i].kind === "file") {
          const blob = items[i].getAsFile();
          if (blob) {
            const scannedCode = await processFile(blob);
            if (scannedCode.content) {
              return scannedCode.content;
            }
          }
        }
      }
      return null;
    };
    const autocompleteList = [];
    const favoriteList = [];
    return {
      it,
      urlInput,
      urlInputError,
      onReset,
      onSubmit,
      onPaste,
      onQrCode,
      favoriteList,
      autocompleteList
    };
  }
});
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  const _component_IconGlobe = resolveComponent("IconGlobe");
  const _component_GridInputAutocomplete = resolveComponent("GridInputAutocomplete");
  const _component_ScanQrCode = resolveComponent("ScanQrCode");
  return openBlock(), createElementBlock(Fragment, null, [
    createVNode(_component_GridInputAutocomplete, {
      "input-text": _ctx.urlInput,
      "onUpdate:inputText": _cache[0] || (_cache[0] = ($event) => _ctx.urlInput = $event),
      "input-error": _ctx.urlInputError,
      "onUpdate:inputError": _cache[1] || (_cache[1] = ($event) => _ctx.urlInputError = $event),
      onEnter: _ctx.onSubmit,
      onReset: _ctx.onReset,
      onPaste: _ctx.onPaste,
      "input-id": "urlInput",
      "input-hint": _ctx.it(_ctx.textId + ".hint"),
      autocomplete: "off",
      "input-disabled": _ctx.disabled,
      alwaysShowInfo: false,
      showReset: _ctx.urlInput.length > 0,
      "input-type": "text",
      "auto-complete-items": _ctx.autocompleteList,
      class: "col-span-10 md:col-span-11"
    }, {
      "icon-prepend": withCtx(() => [
        createVNode(_component_IconGlobe, { class: "h-5 w-5" })
      ]),
      _: 1
    }, 8, ["input-text", "input-error", "onEnter", "onReset", "onPaste", "input-hint", "input-disabled", "showReset", "auto-complete-items"]),
    createVNode(_component_ScanQrCode, {
      onDecode: _ctx.onQrCode,
      disabled: _ctx.disabled,
      "button-css": "col-span-2 md:col-span-1 h-10 sm:h-11"
    }, null, 8, ["onDecode", "disabled"])
  ], 64);
}
const DAppBrowserURLInput = /* @__PURE__ */ _export_sfc(_sfc_main$3, [["render", _sfc_render]]);
const _hoisted_1$2 = { class: "col-span-12 grid grid-cols-12 cc-gap cc-text-sz" };
const _hoisted_2$2 = {
  key: 0,
  class: "cc-grid"
};
const _hoisted_3$2 = {
  key: 6,
  class: "absolute top-0 left-0 w-0 h-0 overflow-hidden"
};
const _sfc_main$2 = /* @__PURE__ */ defineComponent({
  __name: "DAppBrowser",
  props: {
    title: { type: String, required: true, default: "Supported DApps" },
    filterArray: { type: Array, required: false, default: [] },
    filterMatching: { type: Boolean, required: false, default: true },
    onlyFavs: { type: Boolean, required: false },
    showPromoted: { type: Boolean, required: false, default: true },
    showCategory: { type: Boolean, required: false, default: true }
  },
  emits: ["noFavs", "allCategories"],
  setup(__props, { emit: __emit }) {
    const props = __props;
    const emit = __emit;
    const { it } = useTranslation();
    const {
      dappAccountId,
      dappWalletId,
      accountData,
      walletData
    } = useDappAccount();
    const { emitEvent } = useDAppBrowserEvents();
    const iframeList = reactive([]);
    const promotedList = reactive([]);
    const featuredList = reactive([]);
    const normalList = reactive([]);
    const categories = reactive([]);
    const allCategories = reactive([]);
    function handleMaximize(item) {
      emitEvent(DAppEntryEvent.maximize, item.id);
    }
    function handleConnect(item) {
      emitEvent(DAppEntryEvent.connect, item.id);
    }
    function handleDisconnect(item) {
      emitEvent(DAppEntryEvent.disconnect, item.id);
      for (let i = iframeList.length - 1; i >= 0; i--) {
        if (iframeList[i].id === item.id) {
          iframeList.splice(i, 1);
        }
      }
      updateLists();
    }
    function handleFavChanged(item) {
      updateLists();
    }
    let toUpdateLists = -1;
    let updatingLists = false;
    function updateLists() {
      clearTimeout(toUpdateLists);
      toUpdateLists = setTimeout(() => {
        actuallyUpdateList();
      }, 10);
    }
    function ifEntryInArray(targetArray, filterList) {
      for (const targetEntry of targetArray) {
        for (const filterEntry of filterList) {
          if (targetEntry == filterEntry) {
            return true;
          }
        }
      }
      return false;
    }
    function actuallyUpdateList() {
      if (updatingLists) return;
      updatingLists = true;
      promotedList.splice(0);
      featuredList.splice(0);
      normalList.splice(0);
      for (const entry of iframeList) {
        if (entry.staging.isPromoted) {
          promotedList.push(entry);
        } else if (entry.keywords.length > 0) {
          featuredList.push(entry);
        } else if (entry.keywords.length === 0) {
          normalList.push(entry);
        }
      }
      categories.splice(0);
      allCategories.splice(0);
      const filterArray = props.filterArray;
      const filterMatching = props.filterMatching;
      for (const entry of featuredList) {
        for (const cat of entry.categories) {
          allCategories.push(cat);
          if (props.onlyFavs && !favorites.value.includes(entry.id)) continue;
          if (filterArray.length === 0 || ifEntryInArray(entry.categories, filterArray) == filterMatching) {
            let category = categories.find((item) => item.label === cat);
            if (!category) {
              category = { label: cat, list: [] };
              categories.push(category);
            }
            category.list.push(entry);
          }
        }
      }
      if (props.onlyFavs) {
        if (categories.length === 0) {
          emit("noFavs");
        }
      }
      emit("allCategories", allCategories);
      categories.sort((a, b) => a.label.localeCompare(b.label, "en-US"));
      updatingLists = false;
    }
    onMounted(() => {
    });
    function onURL(url, tmpLabel) {
      const tmp = new URL(url);
      const origin = tmp.protocol + "//" + tmp.host + "/";
      const label = tmpLabel ?? tmp.host;
      const id = "db_" + label;
      let browserEntry = null;
      for (const entry of entryList.value) {
        if (entry.keywords.some((word) => word === tmp.host)) {
          browserEntry = entry;
          break;
        }
      }
      if (!browserEntry) {
        browserEntry = reactive({
          id,
          keywords: [],
          autoConnect: true,
          isConnected: false,
          categories: [],
          staging: {
            type: "free",
            label,
            caption: "",
            description: "",
            isPromoted: false,
            promotion: "",
            url,
            origin,
            image: {
              promoted: "",
              platinum: "",
              gold: "",
              silver: "",
              free: ""
            }
          },
          production: {
            type: "free",
            label,
            caption: "",
            description: "",
            isPromoted: false,
            promotion: "",
            url,
            origin,
            image: {
              promoted: "",
              platinum: "",
              gold: "",
              silver: "",
              free: ""
            }
          }
        });
      }
      const iframe = iframeList.find((item) => item.id === browserEntry.id);
      if (iframe) {
        emitEvent(DAppEntryEvent.maximize, iframe.id);
      } else {
        if (!iframeList.some((item) => item.id === browserEntry.id)) {
          iframeList.push(browserEntry);
          addDappBrowserFavorite(browserEntry.id);
          updateLists();
          if (!browserEntry.autoConnect) {
            emitEvent(DAppEntryEvent.maximize, browserEntry.id);
          }
        }
      }
    }
    function onIframeReady(item) {
      if (item && item.autoConnect) {
        item.autoConnect = false;
        updateLists();
        emitEvent(DAppEntryEvent.maximize, item.id);
      }
    }
    function syncEntryList(entryList2) {
      for (const entry of entryList2) {
        const index = iframeList.findIndex((item) => item.id === entry.id);
        if (index < 0) {
          //!isIosApp() &&
          iframeList.push(entry);
        } else if (entry !== iframeList[index]) {
          iframeList.splice(index, 1, entry);
        }
      }
      for (const entry of iframeList) {
        if (!entryList2.some((item) => item.id === entry.id)) {
          entry.isConnected = false;
        }
      }
      updateLists();
    }
    watchEffect(() => {
      syncEntryList(entryList.value);
    });
    const allowInit = ref(false);
    onMounted(() => {
      nextTick(() => {
        allowInit.value = true;
        updateLists();
      });
    });
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", _hoisted_1$2, [
        !(unref(walletData) && unref(accountData)) ? (openBlock(), createBlock(_sfc_main$9, {
          key: 0,
          label: unref(it)("dapps.browser.account.label"),
          text: unref(it)("dapps.browser.account.text"),
          icon: unref(it)("dapps.browser.account.icon"),
          html: "",
          class: "col-span-12",
          "text-c-s-s": "cc-text-normal text-justify flex flex-col justify-center",
          css: "cc-rounded cc-banner-warning"
        }, null, 8, ["label", "text", "icon"])) : unref(isStagingApp)() ? (openBlock(), createBlock(_sfc_main$9, {
          key: 1,
          label: unref(it)("dapps.browser.urlInput.label"),
          text: unref(it)("dapps.browser.urlInput.text"),
          icon: unref(it)("dapps.browser.urlInput.icon"),
          html: "",
          class: "col-span-12",
          "text-c-s-s": "cc-text-normal text-justify flex flex-col justify-center",
          css: "cc-rounded cc-banner-blue"
        }, null, 8, ["label", "text", "icon"])) : createCommentVNode("", true),
        unref(isStagingApp)() ? (openBlock(), createBlock(DAppBrowserURLInput, {
          key: 2,
          onSubmit: onURL,
          "text-id": "dapps.browser.urlInput",
          disabled: !(unref(walletData) && unref(accountData))
        }, null, 8, ["disabled"])) : createCommentVNode("", true),
        unref(isStagingApp)() ? (openBlock(), createBlock(GridSpace, {
          key: 3,
          hr: "",
          class: "col-span-12 my-0.5 sm:my-2"
        })) : createCommentVNode("", true),
        createVNode(_sfc_main$a, { label: __props.title }, null, 8, ["label"]),
        __props.showPromoted ? (openBlock(true), createElementBlock(Fragment, { key: 4 }, renderList(promotedList, (item) => {
          return openBlock(), createBlock(_sfc_main$5, {
            key: item.id + "_pl",
            "dapp-connect": item,
            "is-staging": unref(isStagingApp)(),
            "is-featured": true,
            "html-id": item.id,
            onConnect: handleConnect,
            onDisconnect: handleDisconnect,
            onMaximize: handleMaximize,
            class: "col-span-12 h-24 sm:h-40 xl:h-40"
          }, null, 8, ["dapp-connect", "is-staging", "html-id"]);
        }), 128)) : createCommentVNode("", true),
        (openBlock(true), createElementBlock(Fragment, null, renderList(categories, (category) => {
          return openBlock(), createElementBlock("div", {
            class: "cc-grid",
            key: category.label + "_cat"
          }, [
            category.list.length > 0 ? (openBlock(), createElementBlock("div", _hoisted_2$2, [
              category.list.length > 0 ? (openBlock(), createBlock(GridSpace, {
                key: 0,
                hr: "",
                class: "col-span-12 my-0.5 sm:my-2"
              })) : createCommentVNode("", true),
              __props.showCategory ? (openBlock(), createBlock(_sfc_main$a, {
                key: 1,
                label: category.label,
                class: "col-span-12"
              }, null, 8, ["label"])) : createCommentVNode("", true),
              (openBlock(true), createElementBlock(Fragment, null, renderList(category.list, (item) => {
                return openBlock(), createBlock(_sfc_main$5, {
                  key: item.id + "_fl_" + category.label,
                  "dapp-connect": item,
                  "is-staging": unref(isStagingApp)(),
                  "is-featured": true,
                  "html-id": item.id,
                  "only-favs": __props.onlyFavs,
                  onConnect: handleConnect,
                  onDisconnect: handleDisconnect,
                  onMaximize: handleMaximize,
                  onFavChanged: handleFavChanged,
                  class: "col-span-6 xl:col-span-4 h-16 xs:h-20 sm:h-24 xl:h-32"
                }, null, 8, ["dapp-connect", "is-staging", "html-id", "only-favs"]);
              }), 128))
            ])) : createCommentVNode("", true)
          ]);
        }), 128)),
        normalList.length > 0 ? (openBlock(), createBlock(GridSpace, {
          key: 5,
          hr: "",
          class: "col-span-12 my-0.5 sm:my-2"
        })) : createCommentVNode("", true),
        (openBlock(true), createElementBlock(Fragment, null, renderList(normalList, (item) => {
          return openBlock(), createBlock(_sfc_main$5, {
            key: item.id + "_nl",
            "dapp-connect": item,
            "is-staging": unref(isStagingApp)(),
            "is-featured": false,
            "html-id": item.id,
            onConnect: handleConnect,
            onDisconnect: handleDisconnect,
            onMaximize: handleMaximize,
            onFavChanged: handleFavChanged,
            class: "col-span-6 xl:col-span-4 h-10"
          }, null, 8, ["dapp-connect", "is-staging", "html-id"]);
        }), 128)),
        allowInit.value && unref(walletData) && unref(accountData) ? (openBlock(), createElementBlock("div", _hoisted_3$2, [
          (openBlock(true), createElementBlock(Fragment, null, renderList(normalList, (item) => {
            return openBlock(), createBlock(_sfc_main$b, {
              key: item.id + "_iframe_modal",
              walletId: unref(dappWalletId),
              accountId: unref(dappAccountId),
              "dapp-connect": item,
              "is-staging": unref(isStagingApp)(),
              "html-id": item.id,
              onReady: ($event) => onIframeReady(item)
            }, null, 8, ["walletId", "accountId", "dapp-connect", "is-staging", "html-id", "onReady"]);
          }), 128))
        ])) : createCommentVNode("", true)
      ]);
    };
  }
});
const _hoisted_1$1 = { class: "cc-grid cc-text-sz" };
const _hoisted_2$1 = {
  key: 0,
  class: "cc-grid"
};
const _hoisted_3$1 = { class: "col-span-12 grid grid-cols-12 cc-gap mb-2" };
const _hoisted_4$1 = ["selected", "value"];
const _sfc_main$1 = /* @__PURE__ */ defineComponent({
  __name: "DAppsAccountList",
  emits: ["onActivateAccount"],
  setup(__props, { expose: __expose, emit: __emit }) {
    const { it } = useTranslation();
    const {
      dappWalletId,
      dappAccountId
    } = useDappAccount();
    const {
      uiSelectedAccountId,
      uiSelectedWalletId,
      setUiSelectedAccountId,
      setUiSelectedWalletId
    } = useUiSelectedAccount();
    const {
      appWallet,
      accountList
    } = useWalletAccount(uiSelectedWalletId, uiSelectedAccountId);
    const walletNameList = reactive([]);
    const handleWalletList = () => {
      var _a;
      walletNameList.splice(0, walletNameList.length, ...getWalletNameList());
      walletNameList.sort((a, b) => a.name.localeCompare(b.name, "en-US"));
      if (dappWalletId.value) {
        setUiSelectedWalletId(dappWalletId.value, false);
        setUiSelectedAccountId(dappAccountId.value, false);
      } else if (walletNameList.length > 0) {
        setUiSelectedWalletId((_a = walletNameList[0]) == null ? void 0 : _a.id, false);
      }
    };
    handleWalletList();
    const onActivateAccount = (payload) => {
      if (payload.walletId && payload.accountId) {
        dispatchSignalSync(doToggleDappAccountId, payload.walletId, payload.accountId);
        setUiSelectedWalletId(payload.walletId, false);
        setUiSelectedAccountId(payload.accountId, false);
      }
    };
    __expose({ onActivateAccount });
    const onSelectWalletInUi = (event) => {
      const walletId = event.target.options[event.target.options.selectedIndex].value.toLowerCase();
      if (!walletId) {
        return;
      }
      setUiSelectedWalletId(walletId, true);
    };
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", _hoisted_1$1, [
        createVNode(_sfc_main$a, {
          label: unref(it)("dapps.accountSelection.headline")
        }, null, 8, ["label"]),
        createVNode(_sfc_main$c, {
          text: unref(it)("dapps.accountSelection.caption")
        }, null, 8, ["text"]),
        createVNode(GridSpace, {
          hr: "",
          class: "col-span-12"
        }),
        walletNameList.length > 0 ? (openBlock(), createElementBlock("div", _hoisted_2$1, [
          createBaseVNode("div", _hoisted_3$1, [
            createVNode(_sfc_main$a, {
              class: "col-span-12",
              label: unref(it)("directconnect.connect.select.headline")
            }, null, 8, ["label"]),
            createBaseVNode("select", {
              class: "col-span-12 sm:col-span-6 xl:col-span-4 cc-rounded-la cc-dropdown cc-text-sm",
              required: true,
              onChange: _cache[0] || (_cache[0] = ($event) => onSelectWalletInUi($event))
            }, [
              (openBlock(true), createElementBlock(Fragment, null, renderList(walletNameList, (data) => {
                return openBlock(), createElementBlock("option", {
                  key: data.id,
                  selected: data.id === unref(uiSelectedWalletId),
                  value: data.id
                }, toDisplayString(data.name + (data.id === unref(dappWalletId) ? " (" + unref(it)("dapps.accountSelection.selectedWallet") + ")" : "")), 9, _hoisted_4$1);
              }), 128))
            ], 32)
          ])
        ])) : createCommentVNode("", true),
        unref(appWallet) && unref(appWallet).isReadOnly ? (openBlock(), createBlock(_sfc_main$9, {
          key: 1,
          icon: unref(it)("wallet.summary.setDAppAccount.warning.readOnly.icon"),
          text: unref(it)("wallet.summary.setDAppAccount.warning.readOnly.text"),
          class: "col-span-12",
          "text-c-s-s": "text-justify flex justify-start items-center",
          css: "cc-rounded cc-banner-warning"
        }, null, 8, ["icon", "text"])) : createCommentVNode("", true),
        createVNode(GridSpace, { hr: "" }),
        (openBlock(true), createElementBlock(Fragment, null, renderList(unref(accountList), (account) => {
          return openBlock(), createBlock(_sfc_main$d, {
            key: "item_" + account.id,
            "account-id": account.id,
            "wallet-id": unref(uiSelectedWalletId),
            "is-selected-in-ui": account.id === unref(dappAccountId),
            "overwrite-show-stake": true,
            "preselect-dapp-account": false,
            onOnActivateAccount: onActivateAccount
          }, null, 8, ["account-id", "wallet-id", "is-selected-in-ui"]);
        }), 128))
      ]);
    };
  }
});
const _hoisted_1 = { class: "relative w-full h-full cc-rounded flex flex-row-reverse flex-nowrap dark:text-cc-gray-dark" };
const _hoisted_2 = { class: "relative h-full flex-1 overflow-hidden focus:outline-none flex flex-col flex-nowrap" };
const _hoisted_3 = { class: "h-16 sm:h-20 w-full max-w-full flex flex-row flex-nowrap justify-center items-center border-t border-b mb-px cc-text-sx-dense cc-bg-white-0" };
const _hoisted_4 = {
  key: 0,
  class: "relative w-full h-full flex flex-row flex-nowrap justify-center xs:justify-between items-center max-w-6xl px-3 lg:px-6 xl:px-6 space-x-2"
};
const _hoisted_5 = { class: "relative mr-2 block h-8 sm:h-10 w-8 sm:w-10" };
const _hoisted_6 = {
  key: 0,
  class: "relative h-full flex-1 flex flex-col flex-nowrap justify-center items-start cc-text-semi-bold"
};
const _hoisted_7 = { class: "mb-0.5 flex flex-row" };
const _hoisted_8 = {
  key: 0,
  class: "mdi mdi-circle text-xs-dense ml-1 mt-1.5 cc-text-green",
  style: { "line-height": "0.0rem" }
};
const _hoisted_9 = {
  key: 2,
  class: "h-0 ml-1"
};
const _hoisted_10 = {
  key: 1,
  class: "cc-text-color-caption cc-text-xxs-dense cc-text-medium"
};
const _hoisted_11 = { key: 1 };
const _hoisted_12 = { key: 0 };
const _hoisted_13 = { key: 1 };
const _hoisted_14 = { key: 2 };
const _hoisted_15 = { key: 3 };
const _hoisted_16 = { key: 2 };
const _hoisted_17 = { key: 3 };
const _hoisted_18 = { key: 4 };
const _hoisted_19 = { key: 5 };
const _hoisted_20 = {
  key: 6,
  class: "font-mono"
};
const _hoisted_21 = { key: 7 };
const _hoisted_22 = {
  key: 8,
  class: "font-mono"
};
const _hoisted_23 = { key: 9 };
const _hoisted_24 = {
  key: 0,
  class: "relative h-full flex-1 flex flex-col flex-nowrap justify-center items-end cc-text-semi-bold"
};
const _hoisted_25 = { class: "mb-0.5 flex flex-row" };
const _hoisted_26 = {
  key: 0,
  class: "h-0 mr-1"
};
const _hoisted_27 = {
  key: 1,
  class: "mdi mdi-circle text-xs-dense mr-1 mt-2 cc-text-green",
  style: { "line-height": "0.0rem" }
};
const _hoisted_28 = {
  key: 1,
  class: "relative w-full h-full flex flex-row flex-nowrap justify-center xs:justify-between items-center max-w-6xl px-3 lg:px-6 xl:px-6 space-x-2"
};
const _hoisted_29 = { class: "relative h-full flex-1 flex flex-col flex-nowrap justify-center items-center cc-text-semi-bold" };
const _hoisted_30 = { class: "mb-0.5" };
const _hoisted_31 = {
  key: 2,
  class: "relative w-full h-full flex flex-row flex-nowrap justify-center xs:justify-between items-center max-w-6xl px-3 lg:px-6 xl:px-6 space-x-2"
};
const _hoisted_32 = { class: "relative h-full flex-1 flex flex-col flex-nowrap justify-center items-center cc-text-semi-bold" };
const _hoisted_33 = { class: "mb-0.5" };
const _hoisted_34 = { class: "cc-page-wallet cc-text-sz dark:text-cc-gray mb-12" };
const _hoisted_35 = { class: "flex cc-bg-light-1 bottom-8 w-full align-middle justify-center text-center sm:hidden" };
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "DApps",
  setup(__props) {
    const $q = useQuasar();
    const { it } = useTranslation();
    const {
      dappAccountId,
      dappWalletId,
      dappAccount,
      dappWallet,
      walletData,
      accountData,
      accountSettings,
      walletSettings
    } = useDappAccount();
    const walletName = walletSettings.name;
    const walletBalance = walletSettings.balance;
    const isWalletSyncing = walletSettings.isSyncing;
    const plate = walletSettings.plate;
    const background = walletSettings.background;
    const accountName = accountSettings.name;
    const accountBalance = accountSettings.balance;
    const isAccountSyncing = accountSettings.isSyncing;
    const isManualSyncEnabled = accountSettings.isManualSyncEnabled;
    const {
      addObserver,
      removeObserver
    } = useDAppBrowserEvents();
    onErrorCaptured((e) => {
      console.error("DApps: onErrorCaptured", e);
      return true;
    });
    const lastSync1 = ref("");
    const lastSync2 = ref("");
    const lastWalledId = ref(null);
    watchEffect(() => {
      var _a;
      const _ts = timestampLocal.value;
      const syncInfo = ((_a = dappAccount.value) == null ? void 0 : _a.syncInfo) ?? null;
      if (!syncInfo || syncInfo.info === "default") {
        lastSync1.value = "";
        lastSync2.value = "";
      } else {
        let ls = syncInfo.stateTimestamp;
        if (ls <= 0 && isManualSyncEnabled.value) {
          lastSync1.value = "";
          lastSync2.value = "";
          return;
        }
        ls = Math.floor(ls > 0 ? ls : _ts);
        let totalSeconds = Math.max(Math.floor((_ts - ls) / 1e3), -1) + 1;
        let _seconds = totalSeconds % 60;
        let _minutes = Math.floor(totalSeconds / 60) % 60;
        let _hours = Math.floor(totalSeconds / 3600) % 24;
        let _days = Math.floor(totalSeconds / 86400);
        if (totalSeconds < 60) {
          lastSync1.value = "";
          lastSync2.value = _seconds + "s";
        } else if (totalSeconds < 3600) {
          lastSync1.value = _minutes + "m";
          lastSync2.value = _seconds + "s";
        } else if (totalSeconds < 86400) {
          lastSync1.value = _hours + "h";
          lastSync2.value = _minutes + "m";
        } else {
          lastSync1.value = _days + "d";
          lastSync2.value = _hours + "h";
        }
        if (networkId.value && lastWalledId.value !== dappWalletId.value) {
          removeBackground();
          if (background.value.policy) {
            setWalletBackground(networkId.value, background.value);
          }
        }
        lastWalledId.value = dappWalletId.value ?? "";
      }
    });
    const tabIndex = ref(0);
    const isLoading = ref(true);
    const optionsTabs = reactive([
      { id: "favs", label: it("dapps.menu.favorites"), index: 0, hidden: false },
      { id: "browser", label: it("dapps.menu.browser"), index: 1, hidden: false },
      { id: "mint", label: it("dapps.menu.mint"), index: 2, hidden: false },
      { id: "nmkr", label: it("dapps.menu.nmkr"), index: 3, hidden: true },
      { id: "connect", label: it("dapps.menu.connect"), index: 4, hidden: false }
    ]);
    function handleAllCategories(allCategories) {
      optionsTabs[3].hidden = !allCategories.includes("nmkr");
    }
    function gotoAccountList() {
      tabIndex.value = 4;
    }
    let hintShown = false;
    function handleNoFavs() {
      tabIndex.value = 1;
      if (!hintShown) {
        hintShown = true;
        $q.notify({
          type: "warning",
          message: it("dapps.browser.favs.nofavs"),
          position: "top-left"
        });
      }
    }
    function onTabChanged(index) {
      if (tabIndex.value !== index) {
        tabIndex.value = index;
      }
    }
    const onDAppEntryEvent = async (event, dappId) => {
      if (!dappAccount.value) {
        gotoAccountList();
      }
    };
    onMounted(() => {
      nextTick(() => {
        setTimeout(() => {
          isLoading.value = false;
        }, 3e3);
      });
    });
    onMounted(() => {
      nextTick(() => {
        addObserver({ callback: onDAppEntryEvent, event: DAppEntryEvent.maximize });
      });
    });
    onUnmounted(() => {
      removeObserver({ callback: onDAppEntryEvent, event: DAppEntryEvent.maximize });
    });
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", _hoisted_1, [
        createBaseVNode("main", _hoisted_2, [
          createVNode(_sfc_main$h, {
            containerCSS: "",
            "align-top": "",
            "add-scroll": true
          }, {
            header: withCtx(() => [
              createBaseVNode("div", _hoisted_3, [
                unref(walletName) ? (openBlock(), createElementBlock("div", _hoisted_4, [
                  createBaseVNode("div", {
                    class: "flex-none flex w-auto min-w-48 sm:min-w-60 h-12 sm:h-14 flex-row flex-nowrap justify-start items-start cc-area-light-1 px-2 py-2 cursor-pointer cc-btn-tertiary-light",
                    onClick: withModifiers(gotoAccountList, ["stop", "prevent"])
                  }, [
                    createBaseVNode("div", _hoisted_5, [
                      createVNode(_sfc_main$e, {
                        "icon-seed": unref(plate).image ?? void 0,
                        "icon-data": unref(plate).data ?? void 0
                      }, null, 8, ["icon-seed", "icon-data"])
                    ]),
                    unref(dappWallet) ? (openBlock(), createElementBlock("div", _hoisted_6, [
                      createBaseVNode("div", _hoisted_7, [
                        createTextVNode(toDisplayString(unref(walletName)) + " ", 1),
                        unref(dappWallet).isDappWallet ? (openBlock(), createElementBlock("i", _hoisted_8)) : createCommentVNode("", true),
                        unref(dappWallet).isReadOnly ? (openBlock(), createElementBlock("i", {
                          key: 1,
                          class: normalizeClass(["mdi mdi-cash-lock text-md ml-1 mt-1.5 cc-text-highlight", unref(dappWallet).isDappWallet ? "ml-1" : ""]),
                          style: { "line-height": "0.1rem" }
                        }, null, 2)) : createCommentVNode("", true),
                        unref(isWalletSyncing) ? (openBlock(), createElementBlock("div", _hoisted_9, [
                          createVNode(QSpinnerDots_default, {
                            color: "gray",
                            size: "1rem"
                          })
                        ])) : createCommentVNode("", true)
                      ]),
                      unref(walletBalance) ? (openBlock(), createBlock(_sfc_main$f, {
                        key: 0,
                        balance: unref(walletBalance),
                        syncInfo: unref(dappWallet).syncInfo,
                        syncing: unref(isWalletSyncing),
                        field: "total",
                        "hide-sync-button": "",
                        "hide-currency": ""
                      }, null, 8, ["balance", "syncInfo", "syncing"])) : createCommentVNode("", true),
                      unref(dappAccount) ? (openBlock(), createElementBlock("span", _hoisted_10, [
                        unref(isManualSyncEnabled) ? (openBlock(), createBlock(_sfc_main$7, {
                          key: 0,
                          anchor: "bottom middle",
                          "transition-show": "scale",
                          "transition-hide": "scale"
                        }, {
                          default: withCtx(() => [
                            createTextVNode(toDisplayString(unref(it)("wallet.manualsync.info")) + " ", 1),
                            _cache[4] || (_cache[4] = createBaseVNode("i", { class: "mdi mdi-sync" }, null, -1)),
                            _cache[5] || (_cache[5] = createTextVNode(". "))
                          ]),
                          _: 1
                        })) : createCommentVNode("", true),
                        unref(isManualSyncEnabled) ? (openBlock(), createElementBlock("span", _hoisted_11, [
                          _cache[6] || (_cache[6] = createTextVNode("Manual, ")),
                          unref(dappAccount).syncInfo.isInitializing && unref(isAccountSyncing) ? (openBlock(), createElementBlock("span", _hoisted_12, " preparing for")) : unref(isAccountSyncing) ? (openBlock(), createElementBlock("span", _hoisted_13, " syncing for")) : !(lastSync1.value || lastSync2.value) && unref(isManualSyncEnabled) ? (openBlock(), createElementBlock("span", _hoisted_14, " not synced yet")) : (openBlock(), createElementBlock("span", _hoisted_15, " synced"))
                        ])) : unref(dappAccount).syncInfo.isInitializing ? (openBlock(), createElementBlock("span", _hoisted_16, "Initializing")) : unref(isAccountSyncing) ? (openBlock(), createElementBlock("span", _hoisted_17, "Syncing for")) : (openBlock(), createElementBlock("span", _hoisted_18, "Synced")),
                        lastSync1.value ? (openBlock(), createElementBlock("span", _hoisted_19, " ")) : createCommentVNode("", true),
                        lastSync1.value ? (openBlock(), createElementBlock("span", _hoisted_20, toDisplayString(lastSync1.value), 1)) : createCommentVNode("", true),
                        lastSync2.value ? (openBlock(), createElementBlock("span", _hoisted_21, " ")) : createCommentVNode("", true),
                        lastSync2.value ? (openBlock(), createElementBlock("span", _hoisted_22, toDisplayString(lastSync2.value), 1)) : createCommentVNode("", true),
                        (lastSync1.value || lastSync2.value) && !unref(isAccountSyncing) ? (openBlock(), createElementBlock("span", _hoisted_23, " ago")) : createCommentVNode("", true)
                      ])) : createCommentVNode("", true)
                    ])) : createCommentVNode("", true)
                  ]),
                  _cache[7] || (_cache[7] = createBaseVNode("div", { class: "cc-none xxxs:block grow w-px" }, null, -1)),
                  createBaseVNode("div", {
                    class: "flex-none cc-none xs:flex w-auto min-w-[6rem] h-12 sm:h-14 flex-row flex-nowrap justify-start items-start cc-area-light-1 px-2 py-2 cursor-pointer cc-btn-tertiary-light",
                    onClick: withModifiers(gotoAccountList, ["stop", "prevent"])
                  }, [
                    unref(dappAccount) ? (openBlock(), createElementBlock("div", _hoisted_24, [
                      createBaseVNode("div", _hoisted_25, [
                        unref(isAccountSyncing) ? (openBlock(), createElementBlock("div", _hoisted_26, [
                          createVNode(QSpinnerDots_default, {
                            color: "gray",
                            size: "1rem"
                          })
                        ])) : createCommentVNode("", true),
                        unref(dappAccount).isDappAccount ? (openBlock(), createElementBlock("i", _hoisted_27)) : createCommentVNode("", true),
                        createTextVNode(" " + toDisplayString(unref(accountName)), 1)
                      ]),
                      unref(accountBalance) ? (openBlock(), createBlock(_sfc_main$f, {
                        key: 0,
                        balance: unref(accountBalance),
                        syncInfo: unref(dappAccount).syncInfo,
                        field: "total",
                        syncing: unref(isAccountSyncing),
                        "hide-sync-button": "",
                        "icons-left": ""
                      }, null, 8, ["balance", "syncInfo", "syncing"])) : createCommentVNode("", true)
                    ])) : createCommentVNode("", true)
                  ])
                ])) : isLoading.value ? (openBlock(), createElementBlock("div", _hoisted_28, [
                  createBaseVNode("div", {
                    class: "flex-none flex w-48 h-12 sm:h-14 flex-row flex-nowrap justify-start items-start cc-area-light-1 px-2 py-2 cursor-pointer cc-btn-tertiary-light",
                    onClick: withModifiers(gotoAccountList, ["stop", "prevent"])
                  }, [
                    _cache[8] || (_cache[8] = createBaseVNode("div", { class: "relative mr-2 block h-8 sm:h-10 w-8 sm:w-10 border-gray-300 dark:border-gray-600 border cc-rounded" }, null, -1)),
                    createBaseVNode("div", _hoisted_29, [
                      createBaseVNode("span", _hoisted_30, [
                        createVNode(QSpinner_default)
                      ])
                    ])
                  ])
                ])) : (openBlock(), createElementBlock("div", _hoisted_31, [
                  createBaseVNode("div", {
                    class: "flex-none flex w-48 h-12 sm:h-14 flex-row flex-nowrap justify-start items-start cc-area-light-1 px-2 py-2 cursor-pointer cc-btn-tertiary-light",
                    onClick: withModifiers(gotoAccountList, ["stop", "prevent"])
                  }, [
                    _cache[9] || (_cache[9] = createBaseVNode("div", { class: "relative mr-2 block h-8 sm:h-10 w-8 sm:w-10 border-gray-300 dark:border-gray-600 border cc-rounded" }, null, -1)),
                    createBaseVNode("div", _hoisted_32, [
                      createBaseVNode("span", _hoisted_33, [
                        createBaseVNode("span", null, toDisplayString(unref(it)("common.label.clickToSelect")), 1)
                      ])
                    ])
                  ])
                ]))
              ])
            ]),
            default: withCtx(() => [
              createBaseVNode("div", _hoisted_34, [
                createVNode(_sfc_main$g, {
                  tabs: optionsTabs,
                  index: tabIndex.value,
                  hideTabsOnMobile: "",
                  onSelection: onTabChanged
                }, {
                  tab0: withCtx(() => [
                    createVNode(_sfc_main$2, {
                      title: "Favs",
                      "filter-matching": "",
                      "only-favs": "",
                      onNoFavs: handleNoFavs,
                      onAllCategories: handleAllCategories
                    })
                  ]),
                  tab1: withCtx(() => [
                    createVNode(_sfc_main$2, {
                      title: "Supported DApps",
                      filterArray: ["mint", "anvil", "aidev", "nmkr"],
                      filterMatching: false,
                      onAllCategories: handleAllCategories
                    })
                  ]),
                  tab2: withCtx(() => [
                    createVNode(_sfc_main$2, {
                      title: "Supported Mints",
                      filterArray: ["mint", "anvil", "aidev", "nmkr"],
                      onAllCategories: handleAllCategories
                    })
                  ]),
                  tab3: withCtx(() => [
                    createVNode(_sfc_main$2, {
                      title: "NMKR Projects",
                      filterArray: ["nmkr"],
                      "show-category": false,
                      "show-promoted": false,
                      onAllCategories: handleAllCategories
                    })
                  ]),
                  tab4: withCtx(() => [
                    createVNode(_sfc_main$1)
                  ]),
                  _: 1
                }, 8, ["tabs", "index"])
              ])
            ]),
            bottomNavigation: withCtx(() => [
              createBaseVNode("div", _hoisted_35, [
                createBaseVNode("div", {
                  class: normalizeClass(["flex-auto basis-0 py-1", { "cc-bg-light-0": tabIndex.value === 0 }]),
                  onClick: _cache[0] || (_cache[0] = ($event) => onTabChanged(0))
                }, _cache[10] || (_cache[10] = [
                  createBaseVNode("i", { class: "mdi mdi-star text-2xl" }, null, -1),
                  createBaseVNode("p", null, "Favorites", -1)
                ]), 2),
                createBaseVNode("div", {
                  class: normalizeClass(["flex-auto basis-0 py-1", { "cc-bg-light-0": tabIndex.value === 1 }]),
                  onClick: _cache[1] || (_cache[1] = ($event) => onTabChanged(1))
                }, _cache[11] || (_cache[11] = [
                  createBaseVNode("i", { class: "mdi mdi-application text-2xl" }, null, -1),
                  createBaseVNode("p", null, "DApps", -1)
                ]), 2),
                createBaseVNode("div", {
                  class: normalizeClass(["flex-auto basis-0 py-1", { "cc-bg-light-0": tabIndex.value === 2 }]),
                  onClick: _cache[2] || (_cache[2] = ($event) => onTabChanged(2))
                }, _cache[12] || (_cache[12] = [
                  createBaseVNode("i", { class: "mdi mdi-cloud-print text-2xl" }, null, -1),
                  createBaseVNode("p", null, "Mint", -1)
                ]), 2),
                createBaseVNode("div", {
                  class: normalizeClass(["flex-auto basis-0 py-1", { "cc-bg-light-0": tabIndex.value === 3 }]),
                  onClick: _cache[3] || (_cache[3] = ($event) => gotoAccountList())
                }, _cache[13] || (_cache[13] = [
                  createBaseVNode("i", { class: "mdi mdi-connection text-2xl" }, null, -1),
                  createBaseVNode("p", null, "Account", -1)
                ]), 2)
              ])
            ]),
            _: 1
          })
        ])
      ]);
    };
  }
});
export {
  _sfc_main as default
};
