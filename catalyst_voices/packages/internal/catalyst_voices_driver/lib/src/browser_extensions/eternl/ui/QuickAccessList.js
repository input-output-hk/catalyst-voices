import { o as openBlock, c as createElementBlock, e as createBaseVNode, d as defineComponent, f as computed, kh as getSortedAssetList, D as watch, z as ref, b as withModifiers, H as Fragment, I as renderList, t as toDisplayString, j as createCommentVNode, q as createVNode, u as unref, a as createBlock, _ as isStagingApp, ae as useSelectedAccount, V as nextTick, K as networkId } from "./index.js";
import { u as useTranslation } from "./useTranslation.js";
import { _ as _sfc_main$6, D as DAppEntryEvent, u as useDAppBrowserEvents, e as entryList } from "./DAppIframe.vue_vue_type_script_setup_true_lang.js";
import { _ as _export_sfc } from "./_plugin-vue_export-helper.js";
import "./NetworkId.js";
import "./GridHeadline.vue_vue_type_script_setup_true_lang.js";
import "./GridButtonCountdown.vue_vue_type_script_setup_true_lang.js";
import "./GridButtonPrimary.vue_vue_type_script_setup_true_lang.js";
import "./GridButton.vue_vue_type_script_setup_true_lang.js";
import "./Tooltip.vue_vue_type_script_setup_true_lang.js";
const _sfc_main$5 = {};
const _hoisted_1$5 = {
  class: "max-h-6 shrink",
  xmlns: "http://www.w3.org/2000/svg",
  "xmlns:xlink": "http://www.w3.org/1999/xlink",
  x: "0px",
  y: "0px",
  viewBox: "0 0 1334 297",
  style: { "enable-background": "new 0 0 1334 297" },
  "xml:space": "preserve"
};
function _sfc_render$1(_ctx, _cache) {
  return openBlock(), createElementBlock("svg", _hoisted_1$5, _cache[0] || (_cache[0] = [
    createBaseVNode("path", {
      class: "st0",
      d: "M398.5,244.1l40.5-154h50.6l40.5,154h-29.9l-8.4-33.9h-55l-8.4,33.9H398.5z M443.6,183.4h41.4l-18.7-75h-4  L443.6,183.4z M555,244.1v-25.5h20.2v-103H555V90.1h63.4c20.7,0,36.4,5.3,47.1,15.8c10.9,10.4,16.3,26,16.3,46.6v29  c0,20.7-5.4,36.3-16.3,46.9c-10.7,10.4-26.4,15.6-47.1,15.6H555z M604.3,217.7h14.5c11.7,0,20.3-3.1,25.7-9.2  c5.4-6.2,8.1-14.8,8.1-26v-30.8c0-11.3-2.7-19.9-8.1-26c-5.4-6.2-14-9.2-25.7-9.2h-14.5V217.7z M705.1,244.1l40.5-154h50.6l40.5,154  h-29.9l-8.4-33.9h-55l-8.4,33.9H705.1z M750.2,183.4h41.4l-18.7-75h-4L750.2,183.4z M867,244.1V135h27.3v11.9h4  c1.9-3.7,5.1-6.8,9.5-9.5c4.4-2.8,10.2-4.2,17.4-4.2c7.8,0,14,1.5,18.7,4.6c4.7,2.9,8.3,6.8,10.8,11.7h4c2.5-4.7,6-8.6,10.6-11.7  c4.5-3.1,11-4.6,19.4-4.6c6.7,0,12.8,1.5,18.3,4.4c5.6,2.8,10,7.1,13.2,13c3.4,5.7,5.1,13,5.1,21.8v71.7h-27.7v-69.7  c0-6-1.5-10.5-4.6-13.4c-3.1-3.1-7.4-4.6-13-4.6c-6.3,0-11.2,2.1-14.7,6.2c-3.4,4-5.1,9.7-5.1,17.2v64.5h-27.7v-69.7  c0-6-1.5-10.5-4.6-13.4c-3.1-3.1-7.4-4.6-13-4.6c-6.3,0-11.2,2.1-14.7,6.2c-3.4,4-5.1,9.7-5.1,17.2v64.5H867z M1099.7,247.2  c-7.8,0-14.7-1.3-20.9-4c-6.2-2.8-11.1-6.7-14.7-11.9c-3.5-5.3-5.3-11.7-5.3-19.1s1.8-13.7,5.3-18.7c3.7-5.1,8.7-8.9,15-11.4  c6.5-2.6,13.8-4,22-4h29.9v-6.2c0-5.1-1.6-9.3-4.8-12.5c-3.2-3.4-8.4-5.1-15.4-5.1c-6.9,0-12,1.6-15.4,4.8  c-3.4,3.1-5.6,7.1-6.6,12.1l-25.5-8.6c1.8-5.6,4.6-10.6,8.4-15.2c4-4.7,9.2-8.4,15.6-11.2c6.6-2.9,14.6-4.4,24-4.4  c14.4,0,25.7,3.6,34.1,10.8c8.4,7.2,12.5,17.6,12.5,31.2v40.7c0,4.4,2.1,6.6,6.2,6.6h8.8v22.9h-18.5c-5.4,0-9.9-1.3-13.4-4  s-5.3-6.2-5.3-10.6v-0.2h-4.2c-0.6,1.8-1.9,4.1-4,7c-2.1,2.8-5.3,5.3-9.7,7.5C1113.3,246.1,1107.3,247.2,1099.7,247.2z   M1104.5,224.7c7.8,0,14.1-2.1,18.9-6.4c5-4.4,7.5-10.2,7.5-17.4v-2.2h-27.9c-5.1,0-9.2,1.1-12.1,3.3c-2.9,2.2-4.4,5.3-4.4,9.2  c0,4,1.5,7.2,4.6,9.7C1094.2,223.5,1098.6,224.7,1104.5,224.7z M1204,244.1V135h27.7v109.1H1204z M1217.8,122.2  c-5,0-9.2-1.6-12.8-4.8c-3.4-3.2-5.1-7.5-5.1-12.8c0-5.3,1.7-9.5,5.1-12.8c3.5-3.2,7.8-4.8,12.8-4.8c5.1,0,9.4,1.6,12.8,4.8  s5.1,7.5,5.1,12.8c0,5.3-1.7,9.5-5.1,12.8C1227.2,120.6,1222.9,122.2,1217.8,122.2z M1273.4,244.1v-154h27.7v154H1273.4z"
    }, null, -1),
    createBaseVNode("g", null, [
      createBaseVNode("path", {
        class: "st1",
        d: "M240,296.4c-4.1,0-8.1-1.2-11.5-3.7L155.2,241v35.3c0,11-9,20-20,20s-20-9-20-20v-73.9   c0-7.5,4.2-14.3,10.8-17.8c6.6-3.4,14.6-2.9,20.7,1.4l81.2,57.3l49.6-190l-249.9,98c-10.3,4-21.9-1-25.9-11.3s1-21.9,11.3-25.9   L299.4,1.8c7-2.7,15-1.3,20.6,3.7c5.6,5,8,12.7,6.1,20l-66.8,255.9c-1.7,6.3-6.3,11.5-12.5,13.7C244.6,296,242.3,296.4,240,296.4z"
      })
    ], -1)
  ]));
}
const AdaMail = /* @__PURE__ */ _export_sfc(_sfc_main$5, [["render", _sfc_render$1]]);
const _hoisted_1$4 = { class: "col-span-12 flex flex-row flex-nowrap justify-between gap-2" };
const _hoisted_2$3 = { class: "flex flex-col flex-nowrap" };
const _hoisted_3$2 = { key: 0 };
const _hoisted_4$1 = { class: "grow flex flex-col flex-nowrap justify-center items-end" };
const _hoisted_5 = {
  key: 1,
  class: "absolute top-0 left-0 w-0 h-0 overflow-hidden"
};
const _sfc_main$4 = /* @__PURE__ */ defineComponent({
  __name: "QuickAccessAdaMail",
  emits: ["showRegisterAdamail"],
  setup(__props, { emit: __emit }) {
    const { emitEvent } = useDAppBrowserEvents();
    useTranslation();
    const {
      selectedWalletId,
      selectedAccountId,
      walletData,
      accountData,
      accountSettings
    } = useSelectedAccount();
    const accountAssets = accountSettings.assets;
    const emit = __emit;
    const dappBrowserEntry = {
      id: "adamail_access.adamail.me",
      keywords: ["app.adamail.me", "https://app.adamail.me"],
      autoConnect: true,
      isConnected: false,
      categories: ["dapp"],
      staging: {
        type: "platinum",
        label: "ADAmail.me",
        caption: "Your wallet is your inbox",
        description: "Every Cardano wallet address is an Email address. Send & Receive emails directly from your wallet.",
        isPromoted: false,
        promotion: "",
        url: "https://app.adamail.me",
        origin: "https://app.adamail.me",
        image: {
          promoted: "",
          platinum: "",
          gold: "",
          silver: "",
          free: ""
        }
      },
      production: {
        type: "platinum",
        label: "ADAmail.me",
        caption: "Your wallet is your inbox",
        description: "Every Cardano wallet address is an Email address. Send & Receive emails directly from your wallet.",
        isPromoted: false,
        promotion: "",
        url: "https://app.adamail.me",
        origin: "https://app.adamail.me",
        image: {
          promoted: "",
          platinum: "",
          gold: "",
          silver: "",
          free: ""
        }
      }
    };
    const adaMailPassList = computed(() => {
      if (!accountAssets.value) {
        return [];
      }
      const { assetList } = getSortedAssetList(accountAssets.value);
      const goldList = assetList.filter((item) => item.p === "5d6c6940c0407b172436b71e2c0655af7dbed9559a96803a8562e58a");
      const baseList = assetList.filter((item) => item.p === "ce7070f78d458ba67c737f13ec188bfc44ae7eeb1d9741419a9cdddf");
      const freeList = assetList.filter((item) => item.p === "de5837d0ec2eecdbaf335436a72d0c838cf0346a371a311e6875e7e2");
      const filteredList = goldList.concat(baseList, freeList).map((asset) => asset.l).flat();
      if (filteredList.length === 0) {
        return [];
      }
      dappBrowserEntry.staging.url = "https://app.adamail.me?mail=" + filteredList[0].n + "@adamail.me";
      dappBrowserEntry.production.url = "https://app.adamail.me?mail=" + filteredList[0].n + "@adamail.me";
      return filteredList;
    });
    const adaMailPassShortList = computed(() => {
      const list = adaMailPassList.value.concat();
      if (list.length > 3) {
        list.length = 3;
      }
      return list;
    });
    watch(() => adaMailPassShortList.value.length, (length) => {
      emit("showRegisterAdamail", length === 0);
    }, { immediate: true });
    const showDappBrowserEntry = ref(false);
    const iframeReady = ref(false);
    function doOpenADAmail() {
      showDappBrowserEntry.value = false;
      iframeReady.value = false;
      nextTick(() => {
        showDappBrowserEntry.value = true;
        if (iframeReady.value) {
          emitEvent(DAppEntryEvent.maximize, dappBrowserEntry.id);
        }
      });
    }
    function onIframeReady(item) {
      iframeReady.value = true;
      if (item && item.autoConnect) {
        emitEvent(DAppEntryEvent.maximize, item.id);
      }
    }
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock(Fragment, null, [
        adaMailPassList.value.length > 0 ? (openBlock(), createElementBlock("div", {
          key: 0,
          class: "cc-btn-secondary text-neutral-800 dark:text-neutral-200 col-span-12 grid grid-cols-12 justify-start items-start cc-card cursor-pointer",
          onClick: _cache[0] || (_cache[0] = withModifiers(($event) => doOpenADAmail(), ["prevent", "stop"]))
        }, [
          createBaseVNode("div", _hoisted_1$4, [
            createBaseVNode("div", _hoisted_2$3, [
              _cache[2] || (_cache[2] = createBaseVNode("div", { class: "font-bold text-sm" }, "Open ADAmail", -1)),
              (openBlock(true), createElementBlock(Fragment, null, renderList(adaMailPassShortList.value, (item) => {
                return openBlock(), createElementBlock("div", {
                  key: (item == null ? void 0 : item.n) + "_quick_access_entry"
                }, toDisplayString(item == null ? void 0 : item.n) + "@adamail.me", 1);
              }), 128)),
              adaMailPassShortList.value.length < adaMailPassList.value.length ? (openBlock(), createElementBlock("div", _hoisted_3$2, "...")) : createCommentVNode("", true)
            ]),
            createBaseVNode("div", _hoisted_4$1, [
              createVNode(AdaMail)
            ])
          ])
        ])) : createCommentVNode("", true),
        showDappBrowserEntry.value && dappBrowserEntry && unref(walletData) && unref(accountData) ? (openBlock(), createElementBlock("div", _hoisted_5, [
          (openBlock(), createBlock(_sfc_main$6, {
            key: dappBrowserEntry.id + "_iframe_modal_quick_access",
            walletId: unref(selectedWalletId),
            accountId: unref(selectedAccountId),
            "dapp-connect": dappBrowserEntry,
            "is-staging": unref(isStagingApp)(),
            "html-id": dappBrowserEntry.id,
            onReady: _cache[1] || (_cache[1] = ($event) => onIframeReady(dappBrowserEntry))
          }, null, 8, ["walletId", "accountId", "is-staging", "html-id"]))
        ])) : createCommentVNode("", true)
      ], 64);
    };
  }
});
const _hoisted_1$3 = { class: "col-span-12 flex flex-row flex-nowrap justify-between gap-2" };
const _hoisted_2$2 = { class: "grow flex flex-col flex-nowrap justify-center items-end" };
const _sfc_main$3 = /* @__PURE__ */ defineComponent({
  __name: "QuickAccessAdaMailMint",
  setup(__props) {
    useTranslation();
    const openLink = (target) => {
      window.open(target, void 0, "noopener,noreferrer");
    };
    function doOpenADAmailMint() {
      openLink("https://app.adamail.me/eternl");
    }
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", {
        class: "cc-btn-secondary text-neutral-800 dark:text-neutral-200 col-span-12 grid grid-cols-12 justify-start items-start cc-card cursor-pointer",
        onClick: _cache[0] || (_cache[0] = withModifiers(($event) => doOpenADAmailMint(), ["prevent", "stop"]))
      }, [
        createBaseVNode("div", _hoisted_1$3, [
          _cache[1] || (_cache[1] = createBaseVNode("div", { class: "flex flex-col flex-nowrap" }, [
            createBaseVNode("div", { class: "font-bold text-sm" }, "Register your ADAmail"),
            createBaseVNode("div", null, "yournamehere@adamail.me")
          ], -1)),
          createBaseVNode("div", _hoisted_2$2, [
            createVNode(AdaMail)
          ])
        ])
      ]);
    };
  }
});
const _sfc_main$2 = {};
const _hoisted_1$2 = {
  class: "max-h-4.5 shrink",
  viewBox: "0 0 1189 245",
  fill: "none",
  xmlns: "http://www.w3.org/2000/svg"
};
function _sfc_render(_ctx, _cache) {
  return openBlock(), createElementBlock("svg", _hoisted_1$2, _cache[0] || (_cache[0] = [
    createBaseVNode("path", {
      d: "M59.04 18.432c0-4.416 3.648-8.544 10.944-12.384C77.28 2.016 86.88 0 98.784 0 108 0 113.952 1.92 116.64 5.76c1.92 2.688 2.88 5.184 2.88 7.488v8.64c21.696 2.304 36.768 6.336 45.216 12.096 3.456 2.304 5.184 4.512 5.184 6.624 0 9.984-2.4 20.736-7.2 32.256-4.608 11.52-9.12 17.28-13.536 17.28-.768 0-3.264-.864-7.488-2.592-12.672-5.568-23.232-8.352-31.68-8.352-8.256 0-13.92.768-16.992 2.304-2.88 1.536-4.32 3.936-4.32 7.2 0 3.072 2.112 5.472 6.336 7.2 4.224 1.728 9.408 3.264 15.552 4.608 6.336 1.152 13.152 3.168 20.448 6.048 7.488 2.88 14.4 6.336 20.736 10.368s11.616 10.08 15.84 18.144c4.224 7.872 6.336 15.936 6.336 24.192s-.768 15.072-2.304 20.448c-1.536 5.376-4.224 10.944-8.064 16.704-3.648 5.76-9.312 10.944-16.992 15.552-7.488 4.416-16.512 7.68-27.072 9.792v4.608c0 4.416-3.648 8.544-10.944 12.384-7.296 4.032-16.896 6.048-28.8 6.048-9.216 0-15.168-1.92-17.856-5.76-1.92-2.688-2.88-5.184-2.88-7.488v-8.64c-12.48-1.152-23.328-2.976-32.544-5.472C8.832 212.64 0 207.456 0 201.888 0 191.136 1.536 180 4.608 168.48c3.072-11.712 6.72-17.568 10.944-17.568.768 0 8.736 2.592 23.904 7.776 15.168 5.184 26.592 7.776 34.272 7.776s12.672-.768 14.976-2.304c2.304-1.728 3.456-4.128 3.456-7.2s-2.112-5.664-6.336-7.776c-4.224-2.304-9.504-4.128-15.84-5.472-6.336-1.344-13.248-3.456-20.736-6.336-7.296-2.88-14.112-6.24-20.448-10.08s-11.616-9.504-15.84-16.992c-4.224-7.488-6.336-16.224-6.336-26.208 0-35.328 17.472-55.968 52.416-61.92v-3.744z",
      fill: "#0CD15B"
    }, null, -1),
    createBaseVNode("path", {
      d: "M273.912 55.64c0 7.68-.288 15.072-.864 22.176-.384 7.104-.768 12.096-1.152 14.976h2.304c4.992-8.064 11.424-13.92 19.296-17.568 7.872-3.648 16.608-5.472 26.208-5.472 17.088 0 30.72 4.608 40.896 13.824 10.368 9.024 15.552 23.616 15.552 43.776V229.88H333.24v-91.872c0-22.656-8.448-33.984-25.344-33.984-12.864 0-21.792 4.512-26.784 13.536-4.8 8.832-7.2 21.6-7.2 38.304v74.016H231V11h42.912v44.64zM484.793 69.464c21.12 0 37.248 4.608 48.384 13.824 11.328 9.024 16.992 22.944 16.992 41.76V229.88h-29.952l-8.352-21.312h-1.152c-6.72 8.448-13.824 14.592-21.312 18.432-7.488 3.84-17.76 5.76-30.816 5.76-14.016 0-25.632-4.032-34.848-12.096-9.216-8.256-13.824-20.832-13.824-37.728 0-16.704 5.856-28.992 17.568-36.864 11.712-8.064 29.28-12.48 52.704-13.248l27.36-.864v-6.912c0-8.256-2.208-14.304-6.624-18.144-4.224-3.84-10.176-5.76-17.856-5.76a74.163 74.163 0 00-22.464 3.456c-7.296 2.112-14.592 4.8-21.888 8.064l-14.112-29.088c8.448-4.416 17.76-7.872 27.936-10.368 10.368-2.496 21.12-3.744 32.256-3.744zm6.048 88.128c-13.824.384-23.424 2.88-28.8 7.488-5.376 4.608-8.064 10.656-8.064 18.144 0 6.528 1.92 11.232 5.76 14.112 3.84 2.688 8.832 4.032 14.976 4.032 9.216 0 16.992-2.688 23.328-8.064 6.336-5.568 9.504-13.344 9.504-23.328v-12.96l-16.704.576zM683.374 69.752c16.896 0 30.432 4.608 40.608 13.824 10.176 9.024 15.264 23.616 15.264 43.776V229.88h-42.912v-91.872c0-11.328-2.016-19.776-6.048-25.344-4.032-5.76-10.464-8.64-19.296-8.64-13.056 0-21.984 4.512-26.784 13.536-4.8 8.832-7.2 21.6-7.2 38.304v74.016h-42.912V72.632h32.832l5.76 20.16h2.304c4.992-8.064 11.808-13.92 20.448-17.568 8.832-3.648 18.144-5.472 27.936-5.472zM833.199 232.76c-17.472 0-31.776-6.816-42.912-20.448-10.944-13.824-16.416-34.08-16.416-60.768 0-26.88 5.568-47.232 16.704-61.056 11.136-13.824 25.728-20.736 43.776-20.736 11.328 0 20.64 2.208 27.936 6.624 7.296 4.416 13.056 9.888 17.28 16.416h1.44c-.576-3.072-1.248-7.488-2.016-13.248-.768-5.952-1.152-12-1.152-18.144V11h42.912v218.88h-32.832l-8.352-20.448h-1.728c-4.224 6.528-9.888 12.096-16.992 16.704-7.104 4.416-16.32 6.624-27.648 6.624zm14.976-34.272c11.904 0 20.256-3.456 25.056-10.368 4.8-7.104 7.296-17.664 7.488-31.68v-4.608c0-15.36-2.4-27.072-7.2-35.136-4.608-8.064-13.248-12.096-25.92-12.096-9.408 0-16.8 4.128-22.176 12.384-5.376 8.064-8.064 19.776-8.064 35.136 0 15.36 2.688 26.976 8.064 34.848 5.376 7.68 12.96 11.52 22.752 11.52zM1008.54 229.88h-42.915V11h42.915v218.88zM1118.17 69.752c21.7 0 38.88 6.24 51.56 18.72 12.67 12.288 19.01 29.856 19.01 52.704v20.736h-101.38c.38 12.096 3.94 21.6 10.66 28.512 6.91 6.912 16.41 10.368 28.51 10.368 10.17 0 19.39-.96 27.65-2.88 8.25-2.112 16.79-5.28 25.63-9.504v33.12c-7.68 3.84-15.84 6.624-24.48 8.352-8.45 1.92-18.72 2.88-30.82 2.88-15.74 0-29.66-2.88-41.76-8.64-12.09-5.952-21.6-14.88-28.51-26.784-6.91-11.904-10.37-26.88-10.37-44.928 0-18.432 3.07-33.696 9.22-45.792 6.33-12.288 15.07-21.504 26.21-27.648 11.13-6.144 24.09-9.216 38.87-9.216zm.29 30.528c-8.25 0-15.17 2.688-20.73 8.064-5.38 5.376-8.55 13.728-9.51 25.056h60.2c-.2-9.6-2.69-17.472-7.49-23.616-4.8-6.336-12.29-9.504-22.47-9.504z",
      fill: "#fff"
    }, null, -1)
  ]));
}
const AdaHandle = /* @__PURE__ */ _export_sfc(_sfc_main$2, [["render", _sfc_render]]);
const _hoisted_1$1 = { class: "col-span-12 flex flex-row flex-nowrap justify-between gap-2" };
const _hoisted_2$1 = { class: "grow flex flex-col flex-nowrap justify-center items-end" };
const _hoisted_3$1 = {
  key: 0,
  class: "absolute top-0 left-0 w-0 h-0 overflow-hidden"
};
const _sfc_main$1 = /* @__PURE__ */ defineComponent({
  __name: "QuickAccessAdaHandleMint",
  setup(__props) {
    const { emitEvent } = useDAppBrowserEvents();
    const {
      selectedWalletId,
      selectedAccountId,
      walletData,
      accountData
    } = useSelectedAccount();
    let entry = null;
    const dappBrowserEntry = computed(() => {
      var _a;
      if (entry) {
        return entry;
      }
      if ((((_a = entryList.value) == null ? void 0 : _a.length) ?? 0) === 0) {
        return null;
      }
      const list = entryList.value.filter((item) => item.id.includes("mint.handle.me") || item.id.includes("adahandle.com"));
      if (list.length === 0) {
        return null;
      }
      entry = JSON.parse(JSON.stringify(list[0]));
      entry.id = "quick_access.mint.handle.me";
      entry.autoConnect = true;
      return entry;
    });
    const showDappBrowserEntry = ref(false);
    const iframeReady = ref(false);
    function doOpenADAHandle() {
      showDappBrowserEntry.value = false;
      iframeReady.value = false;
      nextTick(() => {
        var _a;
        showDappBrowserEntry.value = true;
        if (iframeReady.value && ((_a = dappBrowserEntry.value) == null ? void 0 : _a.id)) {
          emitEvent(DAppEntryEvent.maximize, dappBrowserEntry.value.id);
        }
      });
    }
    function onIframeReady(item) {
      iframeReady.value = true;
      if (item && item.autoConnect) {
        emitEvent(DAppEntryEvent.maximize, item.id);
      }
    }
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock(Fragment, null, [
        createBaseVNode("div", {
          class: "cc-btn-secondary text-neutral-800 dark:text-neutral-200 col-span-12 grid grid-cols-12 justify-start items-start cc-card cursor-pointer",
          onClick: _cache[0] || (_cache[0] = withModifiers(($event) => doOpenADAHandle(), ["prevent", "stop"]))
        }, [
          createBaseVNode("div", _hoisted_1$1, [
            _cache[2] || (_cache[2] = createBaseVNode("div", { class: "flex flex-col flex-nowrap" }, [
              createBaseVNode("div", { class: "font-bold text-sm" }, "Mint your ADA Handle"),
              createBaseVNode("div", null, "$youradahandle")
            ], -1)),
            createBaseVNode("div", _hoisted_2$1, [
              createVNode(AdaHandle)
            ])
          ])
        ]),
        showDappBrowserEntry.value && dappBrowserEntry.value && unref(walletData) && unref(accountData) ? (openBlock(), createElementBlock("div", _hoisted_3$1, [
          (openBlock(), createBlock(_sfc_main$6, {
            key: dappBrowserEntry.value.id + "_iframe_modal_quick_access",
            walletId: unref(selectedWalletId),
            accountId: unref(selectedAccountId),
            "dapp-connect": dappBrowserEntry.value,
            "is-staging": unref(isStagingApp)(),
            "html-id": dappBrowserEntry.value.id + "_" + unref(selectedAccountId),
            onReady: _cache[1] || (_cache[1] = ($event) => onIframeReady(dappBrowserEntry.value))
          }, null, 8, ["walletId", "accountId", "dapp-connect", "is-staging", "html-id"]))
        ])) : createCommentVNode("", true)
      ], 64);
    };
  }
});
const _hoisted_1 = { class: "col-span-12 md:col-span-6 2xl:col-span-6 cc-text-sz min-w-64" };
const _hoisted_2 = { class: "relative mb-1 cc-text-semi-bold flex justify-between items-center" };
const _hoisted_3 = {
  key: 0,
  class: "cc-grid"
};
const _hoisted_4 = {
  key: 1,
  class: "cc-grid"
};
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "QuickAccessList",
  setup(__props) {
    const { it } = useTranslation();
    const showList = computed(() => {
      return networkId.value === "mainnet";
    });
    const showRegisterAdaMail = ref(false);
    const onShowRegisterAdaMail = (show) => {
      showRegisterAdaMail.value = show;
    };
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", _hoisted_1, [
        createBaseVNode("div", _hoisted_2, [
          createBaseVNode("span", null, toDisplayString(unref(it)("common.label.quickaccess")), 1)
        ]),
        showList.value ? (openBlock(), createElementBlock("div", _hoisted_3, [
          createVNode(_sfc_main$1),
          createVNode(_sfc_main$4, { onShowRegisterAdamail: onShowRegisterAdaMail }),
          showRegisterAdaMail.value ? (openBlock(), createBlock(_sfc_main$3, { key: 0 })) : createCommentVNode("", true)
        ])) : (openBlock(), createElementBlock("div", _hoisted_4, _cache[0] || (_cache[0] = [
          createBaseVNode("span", { class: "col-span-12" }, "No entries", -1)
        ])))
      ]);
    };
  }
});
export {
  _sfc_main as default
};
