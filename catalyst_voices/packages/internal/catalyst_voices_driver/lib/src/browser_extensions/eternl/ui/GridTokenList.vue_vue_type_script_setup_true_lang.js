import { d as defineComponent, o as openBlock, a as createBlock, eM as decodeHex, L as api, eE as el, bT as json, z as ref, a2 as now, K as networkId, q as createVNode, h as withCtx, c as createElementBlock, ab as withKeys, e as createBaseVNode, b as withModifiers, n as normalizeClass, j as createCommentVNode, aA as renderSlot, eA as Transition, iO as Teleport, k5 as MediaType, C as onMounted, t as toDisplayString, jY as parseMetaSrcFile, f as computed, u as unref, i as createTextVNode, H as Fragment, I as renderList, jO as QSpinnerTail_default, a7 as useQuasar, aW as addSignalListener, aX as removeSignalListener, k6 as onBuiltTxCleanUpScam, g3 as getTxBuiltErrorMsg, f_ as ErrorBuildTx, bm as dispatchSignal, k7 as doBuildTxCleanUpScam, cf as getRandomId, S as reactive, A as useCurrencyAPI, $ as isBexApp, D as watch, Q as QSpinnerDots_default, ae as useSelectedAccount, aI as useGuard, B as useFormatter, cI as divide, cZ as multiply, k8 as fetchAssetCDNImage, k9 as MediaSize, fw as getImageB64, ka as fetchIPFS, jV as fetchAssetMetadata, jW as get721MetadataDetails, jX as get1155Metadata, ar as appLanguageTag, kb as getAssetStatus, hv as formatAssetName, c6 as getAssetIdBech32, eW as compare, V as nextTick, hA as getAssetInfo, hB as getSwapAssetInfo, kc as updateSwapAssetInfoMap, kd as updateSwapAssetInfoMap$1, fv as getAssetCDN, aH as QPagination_default, ke as accAssetInfoCnt, kf as getAdvancedTokenView, kg as setAdvancedTokenView, kh as getSortedAssetList, cb as QToggle_default, cG as subtract, c4 as isLessThanZero, cK as isGreaterThanZero, c7 as accAssetInfoMap, ki as swapAssetInfoMap, kj as isScamAsset } from "./index.js";
import { S, g as getMilkomedaData, f as getMinTxAmount, h as isMilkomedaToken } from "./vue-json-pretty.js";
import { u as useTranslation } from "./useTranslation.js";
import { _ as _sfc_main$e } from "./Tooltip.vue_vue_type_script_setup_true_lang.js";
import { I as IconPencil } from "./IconPencil.js";
import { G as GridInput } from "./GridInput.js";
import { G as GridSpace } from "./GridSpace.js";
import { _ as _sfc_main$b, a as _sfc_main$c } from "./GridHeadline.vue_vue_type_script_setup_true_lang.js";
import { G as GridButtonSecondary } from "./GridButtonSecondary.js";
import { _ as _sfc_main$a } from "./GridButton.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$f } from "./GridTabs.vue_vue_type_script_setup_true_lang.js";
import { u as useTabId } from "./useTabId.js";
import { _ as _sfc_main$g } from "./CopyToClipboard.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$h } from "./ExplorerLink.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$d } from "./FormattedAmount.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$j } from "./InlineButton.vue_vue_type_script_setup_true_lang.js";
import { L as LZString } from "./lz-string.js";
import { a as resizeImage } from "./image.js";
import { s as setWalletBackground } from "./ExtBackground.js";
import { M as Modal } from "./Modal.js";
import { _ as _sfc_main$i } from "./GridButtonPrimary.vue_vue_type_script_setup_true_lang.js";
import { _ as _export_sfc } from "./_plugin-vue_export-helper.js";
import { n as noLogo, c as cardanoLogo } from "./defaultLogo.js";
import { u as useAdaSymbol } from "./useAdaSymbol.js";
const _sfc_main$9 = /* @__PURE__ */ defineComponent({
  __name: "GridButtonAbort",
  props: {
    label: { type: String },
    caption: { type: String },
    icon: { type: String },
    link: { type: Function, default: null },
    disabled: { type: Boolean, default: false }
  },
  setup(__props) {
    return (_ctx, _cache) => {
      return openBlock(), createBlock(_sfc_main$a, {
        label: __props.label,
        caption: __props.caption,
        icon: __props.icon,
        link: __props.link,
        disabled: __props.disabled,
        class: "py-2 text-center cc-text-md cc-text-semi-bold cc-btn-warning"
      }, null, 8, ["label", "caption", "icon", "link", "disabled"]);
    };
  }
});
const ASSET_PRICE_AGE = 1e3 * 60 * 30;
const MarketplacePolicyPlaceholder = "<policyId>";
const MarketplaceNamePlaceholder = "<name>";
const MarketplaceNameHexPlaceholder = "<nameHex>";
const MarketplaceUrls = {
  cnft: "https://cnft.io/",
  jpgstore: "https://www.jpg.store/",
  muesliswap: "https://muesliswap.com/",
  sundaeswap: "https://www.sundaeswap.finance/",
  minswap: "https://minswap.org/",
  cnftjungle: "https://www.cnftjungle.io/",
  wingriders_muesli: "https://www.wingriders.com/"
};
const MarketplaceTokenSwapTarget = {
  cnft: ["https://cnft.io/explore?search=", MarketplacePolicyPlaceholder],
  jpgstore: ["https://www.jpg.store/collection/", MarketplacePolicyPlaceholder],
  muesliswap: ["https://ada.muesliswap.com/markets/token/", MarketplacePolicyPlaceholder, ".", MarketplaceNamePlaceholder],
  sundaeswap: ["https://exchange.sundaeswap.finance/#/swap?swap_from=cardano.ada&swap_to=", MarketplacePolicyPlaceholder, ".", MarketplaceNameHexPlaceholder],
  minswap: ["https://app.minswap.org/swap?currencySymbolA=&tokenNameA=&currencySymbolB=", MarketplacePolicyPlaceholder, "&tokenNameB=", MarketplaceNameHexPlaceholder],
  cnftjungle: ["https://www.cnftjungle.io/collections/", MarketplacePolicyPlaceholder],
  wingriders_muesli: ["https://app.wingriders.com/swap/ada/", MarketplacePolicyPlaceholder, MarketplaceNameHexPlaceholder]
};
const replaceAllPlaceholders = (asset, url) => {
  return url.map((part) => {
    if (part === MarketplacePolicyPlaceholder) {
      return asset.p;
    } else if (part === MarketplaceNamePlaceholder) {
      return decodeHex(asset.t.a ?? "");
    } else if (part === MarketplaceNameHexPlaceholder) {
      return asset.t.a;
    } else {
      return part;
    }
  });
};
const buildAssetUrl = (asset, type) => {
  return replaceAllPlaceholders(asset, MarketplaceTokenSwapTarget[type]).join("");
};
const buildMarketplaceUrls = (asset) => {
  if (!asset) {
    return null;
  }
  const urls = { ...MarketplaceUrls };
  for (const type of Object.keys(MarketplaceTokenSwapTarget)) {
    urls[type] = buildAssetUrl(asset, type);
  }
  return urls;
};
const getMarketplaceUrl = (type) => {
  return MarketplaceUrls[type];
};
const getMarketTranslationString = (type) => {
  return "common.marketplace." + type + ".short";
};
const fetchAssetPrice = async (networkId2, policy, name, assetType, decimals) => {
  const res = await api.post(`/${networkId2}/v2/asset/price`, {
    networkId: networkId2,
    policyId: policy,
    assetName: name,
    assetType,
    decimals
  }).catch((err) => {
    console.error(el("fetchAssetPrice"), json(err));
  });
  if (res == null ? void 0 : res.data) {
    return res.data;
  }
  return null;
};
const assetPriceList = ref([]);
const getAssetPrice = async (fingerprint, policy, name, assetInfo) => {
  var _a;
  let price = assetPriceList.value.find((ap) => ap.fingerprint === fingerprint);
  if (price && price.priceInfo.lastUpdate + ASSET_PRICE_AGE > now()) {
    return price;
  }
  const assetType = assetInfo.ts === "1" ? "nft" : "ft";
  const priceInfo = await fetchAssetPrice(networkId.value, policy, name, assetType, ((_a = assetInfo.tr) == null ? void 0 : _a.d) ?? null) ?? void 0;
  if (priceInfo) {
    price = { fingerprint, priceInfo, assetType };
    assetPriceList.value.push(price);
    return price;
  }
  return null;
};
const _hoisted_1$8 = { class: "fixed inset-0 transition-opacity" };
const _hoisted_2$8 = { class: "flex flex-col cc-text-sz" };
const _hoisted_3$8 = {
  key: 0,
  class: "cc-bg-white-0 border-t px-4 py-2"
};
const _sfc_main$8 = /* @__PURE__ */ defineComponent({
  __name: "BaseModal",
  props: {
    showModal: { type: Boolean, required: true },
    title: { type: String, required: false, default: "" },
    titleCapitalize: { type: Boolean, required: false, default: true },
    caption: { type: String, required: false, default: "" },
    modalCSS: { type: String, required: false, default: "m-1 sm:max-w-xl h-5/6 max-h-5/6 cc-bg-light-1" },
    headerCSS: { type: String, required: false, default: "grow-0 shrink-0 flex flex-row flex-nowrap items-start justify-between cc-bg-white-0 border-b cc-p" },
    contentCSS: { type: String, required: false, default: "cc-p" },
    backgroundCSS: { type: String, required: false, default: "cc-bg-overlay" },
    scrollable: { type: Boolean, required: false, default: true },
    persistent: { type: Boolean, required: false, default: false },
    closeIconStyle: { type: String, required: false, default: "mdi mdi-close" },
    overflow: { type: String, required: false, default: "overflow-hidden" }
  },
  emits: ["close"],
  setup(__props, { emit: __emit }) {
    const props = __props;
    const emit = __emit;
    useTranslation();
    const handleClose = () => emit("close");
    const handleClick = () => props.persistent || handleClose();
    return (_ctx, _cache) => {
      return openBlock(), createBlock(Teleport, { to: "#ccvaultio-modal" }, [
        createVNode(Transition, { name: "fade" }, {
          default: withCtx(() => [
            __props.showModal ? (openBlock(), createElementBlock("div", {
              key: 0,
              onKeydown: _cache[0] || (_cache[0] = withKeys(($event) => !__props.persistent && _ctx.$emit("close"), ["esc"])),
              class: "fixed bottom-0 inset-0 flex items-center justify-center z-100"
            }, [
              createBaseVNode("div", _hoisted_1$8, [
                createBaseVNode("div", {
                  onClick: withModifiers(handleClick, ["self", "stop", "prevent"]),
                  class: normalizeClass(["absolute inset-0", __props.backgroundCSS])
                }, null, 2)
              ]),
              createBaseVNode("div", {
                class: normalizeClass(["relative z-10 overflow-hidden transform transition-all w-full max-h-full cc-rounded cc-shadow flex flex-col flex-nowrap", __props.modalCSS]),
                role: "dialog",
                "aria-modal": "true",
                "aria-labelledby": "modal-headline"
              }, [
                createBaseVNode("div", {
                  class: normalizeClass(__props.headerCSS)
                }, [
                  createBaseVNode("div", _hoisted_2$8, [
                    __props.title ? (openBlock(), createBlock(_sfc_main$b, {
                      key: 0,
                      label: __props.title,
                      "do-capitalize": __props.titleCapitalize
                    }, null, 8, ["label", "do-capitalize"])) : createCommentVNode("", true),
                    __props.caption ? (openBlock(), createBlock(_sfc_main$c, {
                      key: 1,
                      text: __props.caption
                    }, null, 8, ["text"])) : createCommentVNode("", true)
                  ]),
                  renderSlot(_ctx.$slots, "header", {}, void 0, true),
                  createBaseVNode("button", {
                    onClick: withModifiers(handleClose, ["prevent"]),
                    class: "absolute right-2 top-2 z-max"
                  }, [
                    createBaseVNode("i", {
                      class: normalizeClass(__props.closeIconStyle)
                    }, null, 2)
                  ])
                ], 2),
                createBaseVNode("div", {
                  class: normalizeClass(__props.contentCSS)
                }, [
                  renderSlot(_ctx.$slots, "content", {}, void 0, true)
                ], 2),
                _ctx.$slots.footer ? (openBlock(), createElementBlock("div", _hoisted_3$8, [
                  renderSlot(_ctx.$slots, "footer", {}, void 0, true)
                ])) : createCommentVNode("", true)
              ], 2)
            ], 32)) : createCommentVNode("", true)
          ]),
          _: 3
        })
      ]);
    };
  }
});
const BaseModal = /* @__PURE__ */ _export_sfc(_sfc_main$8, [["__scopeId", "data-v-294b3774"]]);
const _hoisted_1$7 = {
  key: 0,
  class: "flex w-full h-full justify-center items-center"
};
const _hoisted_2$7 = {
  key: 1,
  class: "flex w-full h-full justify-center items-center"
};
const _hoisted_3$7 = {
  key: 0,
  class: "flex w-full h-full justify-center items-center"
};
const _hoisted_4$7 = { class: "container items-center justify-center" };
const _hoisted_5$7 = { class: "fixed inline-flex items-center justify-center overflow-hidden rounded-full" };
const _hoisted_6$6 = { class: "w-20 h-20" };
const _hoisted_7$6 = ["stroke-dasharray", "stroke-dashoffset"];
const _hoisted_8$4 = { class: "absolute opacity-90" };
const _hoisted_9$4 = ["src"];
const _hoisted_10$4 = ["src"];
const _hoisted_11$4 = {
  key: 4,
  controls: "",
  autoplay: "",
  loop: "",
  class: "w-full h-full object-contain"
};
const _hoisted_12$3 = ["src", "type"];
const _hoisted_13$2 = {
  key: 5,
  class: "w-full h-full object-contain",
  controls: ""
};
const _hoisted_14$2 = ["src", "type"];
const _hoisted_15$2 = {
  key: 6,
  class: "w-full h-full object-contain"
};
const _hoisted_16$2 = ["src"];
const _sfc_main$7 = /* @__PURE__ */ defineComponent({
  __name: "GridTokenOnChainFileModal",
  props: {
    onChainFile: { type: Object, required: true },
    onChainType: { type: String, required: true }
  },
  setup(__props) {
    const props = __props;
    const { t } = useTranslation();
    const isIframe = props.onChainType === MediaType.IFRAME;
    const isImage = props.onChainType === MediaType.IMAGE;
    const isVideo = props.onChainType === MediaType.VIDEO;
    const isAudio = props.onChainType === MediaType.AUDIO;
    const isPDF = props.onChainType === MediaType.PDF;
    const isLoaded = ref(false);
    const isLoading = ref(false);
    const loadingError = ref("");
    const loadingMessage = ref("");
    const mediaSrc = ref("");
    const circumference = ref(30 * 2 * Math.PI);
    const percent = ref(0);
    const dashoffset = ref(circumference.value - percent.value / 100 * circumference.value);
    const loadingCallbacks = [
      { eventName: "progress", eventHandler: updateLoadingStatus },
      { eventName: "loadstart", eventHandler: startLoading },
      { eventName: "loadend", eventHandler: finishLoading },
      { eventName: "error", eventHandler: errorLoading },
      { eventName: "timeout", eventHandler: timeoutLoading }
    ];
    function updateLoadingStatus(progress) {
      if (progress.lengthComputable) {
        const loadingProgress = progress.loaded / progress.total * 100;
        percent.value = Math.round(loadingProgress * 10) / 10;
        dashoffset.value = circumference.value - percent.value / 100 * circumference.value;
      } else {
        loadingMessage.value = t("wallet.summary.token.dialog.ipfs.loading");
      }
    }
    function startLoading(progress) {
      percent.value = 0;
      isLoading.value = true;
    }
    function finishLoading(progress) {
      percent.value = 100;
      isLoading.value = false;
    }
    function errorLoading(progress) {
      isLoading.value = false;
      loadingError.value = t("wallet.summary.token.dialog.ipfs.error");
    }
    function timeoutLoading(progress) {
      isLoading.value = false;
      loadingError.value = t("wallet.summary.token.dialog.ipfs.timeout");
    }
    async function processOnChainFile() {
      const item = props.onChainFile;
      if (item && item.src) {
        await parseMetaSrcFile(item, mediaSrc, loadingCallbacks);
        isLoaded.value = true;
      }
    }
    onMounted(async () => processOnChainFile());
    return (_ctx, _cache) => {
      return openBlock(), createBlock(BaseModal, {
        "show-modal": true,
        scrollable: false,
        persistent: false,
        modalCSS: isAudio ? "w-full my-2 h-26 py-4 h-5/6 max-h-5/6" : "h-full w-full my-2 h-5/6 max-h-5/6",
        headerCSS: "",
        contentCSS: "w-full h-full px-4",
        backgroundCSS: isIframe ? "   " : void 0,
        "close-icon-style": "mdi mdi-close border rounded-lg p-1",
        onClose: _cache[0] || (_cache[0] = ($event) => _ctx.$emit("close"))
      }, {
        content: withCtx(() => {
          var _a, _b;
          return [
            loadingError.value !== "" ? (openBlock(), createElementBlock("div", _hoisted_1$7, toDisplayString(loadingError.value), 1)) : createCommentVNode("", true),
            isLoading.value ? (openBlock(), createElementBlock("div", _hoisted_2$7, [
              loadingMessage.value !== "" ? (openBlock(), createElementBlock("div", _hoisted_3$7, toDisplayString(loadingMessage.value), 1)) : createCommentVNode("", true),
              createBaseVNode("div", null, [
                createBaseVNode("div", _hoisted_4$7, [
                  createBaseVNode("div", _hoisted_5$7, [
                    (openBlock(), createElementBlock("svg", _hoisted_6$6, [
                      _cache[1] || (_cache[1] = createBaseVNode("circle", {
                        class: "",
                        "stroke-width": "4",
                        stroke: "currentColor",
                        fill: "transparent",
                        r: "30",
                        cx: "40",
                        cy: "40"
                      }, null, -1)),
                      createBaseVNode("circle", {
                        class: "cc-text-highlight",
                        "stroke-width": "4",
                        "stroke-dasharray": circumference.value,
                        "stroke-dashoffset": dashoffset.value,
                        "stroke-linecap": "round",
                        stroke: "currentColor",
                        fill: "transparent",
                        r: "30",
                        cx: "40",
                        cy: "40"
                      }, null, 8, _hoisted_7$6)
                    ])),
                    createBaseVNode("span", _hoisted_8$4, toDisplayString(percent.value) + "%", 1)
                  ])
                ])
              ])
            ])) : createCommentVNode("", true),
            isIframe && isLoaded.value ? (openBlock(), createElementBlock("iframe", {
              key: 2,
              sandbox: "allow-forms allow-downloads allow-scripts allow-same-origin",
              src: mediaSrc.value,
              class: "w-full h-full"
            }, null, 8, _hoisted_9$4)) : createCommentVNode("", true),
            isImage && isLoaded.value ? (openBlock(), createElementBlock("img", {
              key: 3,
              src: mediaSrc.value,
              class: "w-full h-full object-contain",
              alt: "token"
            }, null, 8, _hoisted_10$4)) : createCommentVNode("", true),
            isVideo && isLoaded.value ? (openBlock(), createElementBlock("video", _hoisted_11$4, [
              createBaseVNode("source", {
                src: mediaSrc.value,
                type: (_a = __props.onChainFile) == null ? void 0 : _a.mediaType
              }, null, 8, _hoisted_12$3)
            ])) : createCommentVNode("", true),
            isAudio && isLoaded.value ? (openBlock(), createElementBlock("audio", _hoisted_13$2, [
              createBaseVNode("source", {
                src: mediaSrc.value,
                type: (_b = __props.onChainFile) == null ? void 0 : _b.mediaType
              }, null, 8, _hoisted_14$2)
            ])) : createCommentVNode("", true),
            isPDF && isLoaded.value ? (openBlock(), createElementBlock("object", _hoisted_15$2, [
              createBaseVNode("embed", {
                type: "application/pdf",
                src: mediaSrc.value,
                class: "w-full h-full object-contain"
              }, null, 8, _hoisted_16$2)
            ])) : createCommentVNode("", true)
          ];
        }),
        _: 1
      }, 8, ["modalCSS", "backgroundCSS"]);
    };
  }
});
const _hoisted_1$6 = { class: "mb-1" };
const _hoisted_2$6 = { class: "px-3 py-1 bg-neutral-150 dark:bg-highlightdarkarea rounded flex flex-row" };
const _hoisted_3$6 = {
  key: 0,
  class: "flex flex-col"
};
const _hoisted_4$6 = { class: "flex row" };
const _hoisted_5$6 = { key: 1 };
const _hoisted_6$5 = { class: "flex flex-col" };
const _hoisted_7$5 = { class: "flex row" };
const _hoisted_8$3 = {
  key: 0,
  class: "flex row"
};
const _hoisted_9$3 = {
  key: 1,
  class: "flex row"
};
const _hoisted_10$3 = { key: 0 };
const _hoisted_11$3 = { class: "flex row" };
const _hoisted_12$2 = {
  key: 1,
  class: "self-center justify-self-center xs:self-end xs:justify-self-end mb-5 xs:mb-0 ml-5"
};
const _sfc_main$6 = /* @__PURE__ */ defineComponent({
  __name: "GridFloorPriceDetail",
  props: {
    floorPrice: { type: Object, required: true }
  },
  emits: ["togglePriceView"],
  setup(__props, { emit: __emit }) {
    const props = __props;
    const emit = __emit;
    const { t } = useTranslation();
    const _floorPrice = computed(() => {
      if (props.floorPrice && "status" in props.floorPrice) {
        return null;
      }
      return props.floorPrice;
    });
    const expandList = ref(false);
    const isLoading = computed(() => props.floorPrice && "status" in props.floorPrice && props.floorPrice.status === "loading");
    const hasFloorPriceInfo = computed(() => props.floorPrice && "avgFloorPrice" in props.floorPrice && props.floorPrice.avgFloorPrice);
    const togglePriceView = () => {
      expandList.value = !expandList.value;
      emit("togglePriceView", expandList.value);
    };
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock(Fragment, null, [
        hasFloorPriceInfo.value && _floorPrice.value ? (openBlock(), createElementBlock("div", {
          key: 0,
          class: "cursor-pointer self-center justify-self-center xs:self-end xs:justify-self-end",
          onClick: withModifiers(togglePriceView, ["stop"])
        }, [
          createBaseVNode("p", _hoisted_1$6, toDisplayString(unref(t)("wallet.summary.token.modal.averagePrice")), 1),
          createBaseVNode("div", _hoisted_2$6, [
            createVNode(_sfc_main$d, {
              "symbol-c-s-s": "cc-text-normal",
              "balance-always-visible": "",
              amount: String(_floorPrice.value.avgFloorPrice),
              "hide-fraction-if-zero": true
            }, null, 8, ["amount"])
          ]),
          createVNode(_sfc_main$e, {
            "tooltip-c-s-s": "whitespace-nowrap",
            "transition-show": "scale",
            "transition-hide": "scale"
          }, {
            default: withCtx(() => {
              var _a, _b;
              return [
                createBaseVNode("div", null, [
                  _floorPrice.value.marketplaceCount === 1 && _floorPrice.value.minFloorPrice ? (openBlock(), createElementBlock("div", _hoisted_3$6, [
                    createBaseVNode("span", _hoisted_4$6, [
                      createTextVNode(toDisplayString(unref(t)("common.marketplace.prices.price")) + ": ", 1),
                      createVNode(_sfc_main$d, {
                        "balance-always-visible": "",
                        amount: String(_floorPrice.value.avgFloorPrice),
                        "fraction-c-s-s": "cc-text-bold",
                        "hide-fraction-if-zero": true
                      }, null, 8, ["amount"]),
                      createTextVNode(" @ " + toDisplayString(unref(t)(unref(getMarketTranslationString)(_floorPrice.value.minFloorPrice.type))), 1)
                    ])
                  ])) : createCommentVNode("", true),
                  _floorPrice.value.marketplaceCount > 1 ? (openBlock(), createElementBlock("div", _hoisted_5$6, [
                    createTextVNode(toDisplayString(unref(t)("common.marketplace.prices.description")) + " ", 1),
                    _cache[0] || (_cache[0] = createBaseVNode("hr", null, null, -1)),
                    createBaseVNode("div", _hoisted_6$5, [
                      createBaseVNode("span", _hoisted_7$5, [
                        createTextVNode(toDisplayString(unref(t)("common.marketplace.prices.avg")) + ": ", 1),
                        createVNode(_sfc_main$d, {
                          "balance-always-visible": "",
                          amount: String(_floorPrice.value.avgFloorPrice),
                          "fraction-c-s-s": "cc-text-bold",
                          "hide-fraction-if-zero": true
                        }, null, 8, ["amount"])
                      ]),
                      ((_a = _floorPrice.value.minFloorPrice) == null ? void 0 : _a.lovelacePrice) ? (openBlock(), createElementBlock("span", _hoisted_8$3, [
                        createTextVNode(toDisplayString(unref(t)("common.marketplace.prices.min")) + ": ", 1),
                        createVNode(_sfc_main$d, {
                          "balance-always-visible": "",
                          amount: String(_floorPrice.value.minFloorPrice.lovelacePrice),
                          "fraction-c-s-s": "cc-text-bold",
                          "hide-fraction-if-zero": true
                        }, null, 8, ["amount"]),
                        createTextVNode(" @ " + toDisplayString(unref(t)(unref(getMarketTranslationString)(_floorPrice.value.minFloorPrice.type))), 1)
                      ])) : createCommentVNode("", true),
                      ((_b = _floorPrice.value.maxFloorPrice) == null ? void 0 : _b.lovelacePrice) ? (openBlock(), createElementBlock("span", _hoisted_9$3, [
                        createTextVNode(toDisplayString(unref(t)("common.marketplace.prices.max")) + ": ", 1),
                        createVNode(_sfc_main$d, {
                          "balance-always-visible": "",
                          amount: String(_floorPrice.value.maxFloorPrice.lovelacePrice),
                          "fraction-c-s-s": "cc-text-bold",
                          "hide-fraction-if-zero": true
                        }, null, 8, ["amount"]),
                        createTextVNode(" @ " + toDisplayString(unref(t)(unref(getMarketTranslationString)(_floorPrice.value.maxFloorPrice.type))), 1)
                      ])) : createCommentVNode("", true)
                    ]),
                    _floorPrice.value.marketplaceCount > 2 ? (openBlock(), createElementBlock("hr", _hoisted_10$3)) : createCommentVNode("", true),
                    _floorPrice.value.marketplaceCount > 2 ? (openBlock(true), createElementBlock(Fragment, { key: 1 }, renderList(_floorPrice.value.responses.filter((info) => info.lovelacePrice !== null), (response) => {
                      return openBlock(), createElementBlock("div", null, [
                        createBaseVNode("span", _hoisted_11$3, [
                          createTextVNode(toDisplayString(unref(t)("common.marketplace.prices.price")) + ": ", 1),
                          createVNode(_sfc_main$d, {
                            "balance-always-visible": "",
                            amount: String(response.lovelacePrice),
                            "fraction-c-s-s": "cc-text-bold",
                            "hide-fraction-if-zero": true
                          }, null, 8, ["amount"]),
                          createTextVNode(" @ " + toDisplayString(unref(t)(unref(getMarketTranslationString)(response.type))), 1)
                        ])
                      ]);
                    }), 256)) : createCommentVNode("", true)
                  ])) : createCommentVNode("", true),
                  _cache[1] || (_cache[1] = createBaseVNode("hr", null, null, -1)),
                  createBaseVNode("span", null, toDisplayString(unref(t)("common.marketplace.prices.updated")) + ": " + toDisplayString(new Date(_floorPrice.value.lastUpdate).toLocaleString()), 1)
                ])
              ];
            }),
            _: 1
          })
        ])) : createCommentVNode("", true),
        isLoading.value ? (openBlock(), createElementBlock("div", _hoisted_12$2, [
          createVNode(QSpinnerTail_default, {
            color: "gray",
            size: "1.5rem"
          })
        ])) : createCommentVNode("", true)
      ], 64);
    };
  }
});
const _hoisted_1$5 = {
  key: 0,
  class: "w-full max-w-full mb-4 text-left"
};
const _hoisted_2$5 = { class: "cc-table-cell whitespace-nowrap" };
const _hoisted_3$5 = { class: "cc-table-cell cc-text-semi-bold" };
const _hoisted_4$5 = { class: "cc-table-cell-left whitespace-nowrap" };
const _hoisted_5$5 = ["href"];
const _hoisted_6$4 = { class: "cc-table-cell cc-text-semi-bold" };
const _hoisted_7$4 = ["href"];
const _sfc_main$5 = /* @__PURE__ */ defineComponent({
  __name: "GridFloorPriceTable",
  props: {
    floorPrice: { type: Object, required: true },
    token: { type: Object, required: false, default: null }
  },
  emits: ["togglePriceView"],
  setup(__props, { emit: __emit }) {
    const props = __props;
    const { t } = useTranslation();
    ref(false);
    const finalUrls = buildMarketplaceUrls(props.token);
    const getTargetUrl = (type) => {
      if (!props.token || !finalUrls) {
        return void 0;
      }
      return finalUrls[type];
    };
    return (_ctx, _cache) => {
      return __props.floorPrice && "responses" in __props.floorPrice && __props.floorPrice.responses.length > 0 ? (openBlock(), createElementBlock("table", _hoisted_1$5, [
        createBaseVNode("tr", null, [
          createBaseVNode("th", _hoisted_2$5, toDisplayString(unref(t)("wallet.summary.token.modal.priceTable.marketplace")), 1),
          createBaseVNode("th", _hoisted_3$5, toDisplayString(unref(t)("wallet.summary.token.modal.priceTable.price")), 1)
        ]),
        (openBlock(true), createElementBlock(Fragment, null, renderList(__props.floorPrice.responses.filter((price) => price.lovelacePrice), (price) => {
          return openBlock(), createElementBlock("tr", null, [
            createBaseVNode("th", _hoisted_4$5, [
              createBaseVNode("a", {
                href: unref(getMarketplaceUrl)(price.type),
                target: "_blank"
              }, [
                createTextVNode(toDisplayString(unref(t)("common.marketplace." + price.type + ".short")) + " ", 1),
                _cache[0] || (_cache[0] = createBaseVNode("i", { class: "mdi mdi-open-in-new mx-1" }, null, -1))
              ], 8, _hoisted_5$5)
            ]),
            createBaseVNode("th", _hoisted_6$4, [
              createBaseVNode("div", null, [
                createBaseVNode("a", {
                  class: "flex flex-row",
                  href: getTargetUrl(price.type),
                  target: "_blank"
                }, [
                  createVNode(_sfc_main$d, {
                    "symbol-c-s-s": "cc-text-normal",
                    amount: String(price.lovelacePrice),
                    "hide-fraction-if-zero": true
                  }, null, 8, ["amount"]),
                  _cache[1] || (_cache[1] = createBaseVNode("i", { class: "mdi mdi-open-in-new mx-1" }, null, -1))
                ], 8, _hoisted_7$4)
              ])
            ])
          ]);
        }), 256))
      ])) : createCommentVNode("", true);
    };
  }
});
const GridFloorPriceTable = /* @__PURE__ */ _export_sfc(_sfc_main$5, [["__scopeId", "data-v-c6a160a0"]]);
const _imports_0 = "/images/eternl-guard-512.png";
const _hoisted_1$4 = {
  key: 0,
  class: "col-span-full cc-rounded cc-ring-red mx-5 mt-4 p-4 flex flex-col md:flex-row flex-nowrap justify-center items-center space-x-0 md:space-x-4 space-y-4 md:space-y-0"
};
const _hoisted_2$4 = { class: "grow-0 shrink-0 w-64 flex flex-col flex-nowrap justify-center items-center" };
const _hoisted_3$4 = { class: "text-center whitespace-pre-wrap cc-text-extra-bold cc-text-red-light" };
const _hoisted_4$4 = ["innerHTML"];
const _hoisted_5$4 = { class: "grow-0 shrink-0 w-64 flex flex-col flex-nowrap justify-center items-center" };
const _sfc_main$4 = /* @__PURE__ */ defineComponent({
  __name: "TokenScamWarning",
  props: {
    isScam: { type: Boolean, required: false, default: false }
  },
  setup(__props) {
    const $q = useQuasar();
    const { it } = useTranslation();
    const { adaSymbol } = useAdaSymbol();
    const storeId = "TokenScamWarning" + getRandomId();
    async function createScamCleanupTx() {
      addSignalListener(onBuiltTxCleanUpScam, storeId, (res, error) => {
        removeSignalListener(onBuiltTxCleanUpScam, storeId);
        if (res == null ? void 0 : res.error) {
          const { msg, isWarning } = getTxBuiltErrorMsg(res ? res.error : ErrorBuildTx.missingAccountData, 0, { value: 0 }, adaSymbol);
          if (msg.length > 0) {
            $q.notify({
              type: isWarning ? "warning" : "negative",
              message: msg,
              position: "top-left",
              timeout: 8e3
            });
          }
        } else if (error) {
          $q.notify({
            type: "negative",
            message: error,
            position: "top-left",
            timeout: 8e3
          });
        }
      });
      await dispatchSignal(doBuildTxCleanUpScam);
      removeSignalListener(onBuiltTxCleanUpScam, storeId);
    }
    return (_ctx, _cache) => {
      return __props.isScam ? (openBlock(), createElementBlock("div", _hoisted_1$4, [
        createBaseVNode("div", _hoisted_2$4, [
          _cache[1] || (_cache[1] = createBaseVNode("img", {
            alt: "Eternl logo",
            width: "128",
            height: "128",
            src: _imports_0
          }, null, -1)),
          createBaseVNode("div", _hoisted_3$4, toDisplayString(unref(it)("common.scam.guard.warning")), 1)
        ]),
        createBaseVNode("div", {
          class: "grow flex flex-col flex-nowrap justify-center items-center leading-8 text-lg w-2/3 h-full",
          innerHTML: unref(it)("common.scam.token.description")
        }, null, 8, _hoisted_4$4),
        createBaseVNode("div", _hoisted_5$4, [
          createVNode(GridButtonSecondary, {
            class: "w-full max-w-[240px]",
            type: "button",
            label: "Clean up wallet",
            onClick: _cache[0] || (_cache[0] = withModifiers(($event) => createScamCleanupTx(), ["stop"]))
          })
        ])
      ])) : createCommentVNode("", true);
    };
  }
});
const _hoisted_1$3 = { class: "grow-0 shrink-0 w-full flex flex-row flex-nowrap items-start justify-between border-b cc-p" };
const _hoisted_2$3 = { class: "flex flex-row cc-text-sz" };
const _hoisted_3$3 = { class: "relative flex flex-col lg:flex-row p-4 gap-2" };
const _hoisted_4$3 = { class: "grow shrink" };
const _hoisted_5$3 = {
  key: 0,
  class: "relative flex flex-col flex-nowrap justify-center items-center h-full"
};
const _hoisted_6$3 = ["src"];
const _hoisted_7$3 = {
  key: 1,
  class: "absolute left-0 right-0 top-0 bottom-0 flex flex-col justify-center items-center"
};
const _hoisted_8$2 = { class: "font-extrabold drop-shadow-black cc-text cc-badge-bg-red rounded-borders text-center w-2/3 p-2" };
const _hoisted_9$2 = { class: "absolute h-8 left-0 top-1 sm:left-1 sm:top-1.5" };
const _hoisted_10$2 = {
  key: 1,
  class: "relative flex flex-col flex-nowrap justify-center items-center h-full"
};
const _hoisted_11$2 = ["src"];
const _hoisted_12$1 = {
  key: 0,
  class: "grid cols-3 xs:flex xs:justify-start xs:items-center"
};
const _hoisted_13$1 = {
  key: 0,
  class: "relative min-w-0 flex flex-col flex-wrap justify-center items-center text-center cc-text-bold p-1 py-2 xs:pl-0 xs:m-2 xs:ml-0 initial"
};
const _hoisted_14$1 = { class: "self-center justify-self-center xs:self-start xs:justify-self-start" };
const _hoisted_15$1 = { class: "mb-1" };
const _hoisted_16$1 = {
  key: 1,
  class: "relative min-w-0 flex flex-col flex-wrap justify-center items-center text-center cc-text-bold p-1 py-2 xs:pl-0 xs:m-2 xs:ml-0 initial"
};
const _hoisted_17$1 = { class: "self-center justify-self-center xs:self-start xs:justify-self-start" };
const _hoisted_18$1 = { class: "mb-1" };
const _hoisted_19$1 = { class: "px-3 py-1 bg-neutral-150 dark:bg-highlightdarkarea rounded" };
const _hoisted_20$1 = {
  key: 2,
  class: "relative min-w-0 flex flex-col flex-wrap justify-center items-center text-center cc-text-bold p-1 py-2 xs:m-2 initial"
};
const _hoisted_21$1 = {
  key: 0,
  class: ""
};
const _hoisted_22$1 = { class: "mb-1" };
const _hoisted_23$1 = {
  key: 3,
  class: "relative min-w-0 flex flex-col flex-wrap justify-end items-center text-center cc-text-bold p-1 py-2 xs:pr-0 xs:m-2 initial"
};
const _hoisted_24$1 = {
  key: 1,
  class: "grid cols-1 xs:flex xs:justify-start xs:items-start"
};
const _hoisted_25$1 = {
  key: 0,
  class: "relative min-w-0 flex flex-col flex-wrap justify-center items-center text-center cc-text-bold p-1 py-2 xs:pl-0 xs:m-2 xs:ml-0 initial"
};
const _hoisted_26$1 = {
  class: "col-span-full mt-2 w-full max-w-full mb-4 text-left",
  style: { "max-height": "55vh" }
};
const _hoisted_27$1 = { class: "col-span-full" };
const _hoisted_28$1 = {
  key: 0,
  class: "col-span-12 my-1"
};
const _hoisted_29$1 = { class: "w-full max-w-full mb-4 text-left" };
const _hoisted_30$1 = { key: 0 };
const _hoisted_31$1 = { class: "cc-table-cell-left whitespace-nowrap" };
const _hoisted_32$1 = { class: "cc-table-cell cc-text-semi-bold" };
const _hoisted_33 = { key: 1 };
const _hoisted_34 = { class: "cc-table-cell whitespace-nowrap" };
const _hoisted_35 = { class: "cc-table-cell cc-text-semi-bold" };
const _hoisted_36 = ["href"];
const _hoisted_37 = { class: "cc-table-cell whitespace-nowrap" };
const _hoisted_38 = { class: "cc-table-cell cc-text-semi-bold" };
const _hoisted_39 = { class: "flex flex-row flex-nowrap mt-0.5 items-center pt-0.5 cc-text-semi-bold" };
const _hoisted_40 = { class: "cc-table-cell whitespace-nowrap" };
const _hoisted_41 = { class: "cc-table-cell cc-text-semi-bold" };
const _hoisted_42 = { class: "cc-table-cell whitespace-nowrap" };
const _hoisted_43 = { class: "cc-table-cell cc-text-semi-bold" };
const _hoisted_44 = {
  key: 1,
  class: "col-span-12 my-1"
};
const _hoisted_45 = { class: "w-full mb-4 text-left" };
const _hoisted_46 = { key: 0 };
const _hoisted_47 = {
  colspan: "2",
  class: "text-left cc-table-cell text-italic p-3 break-all"
};
const _hoisted_48 = { key: 1 };
const _hoisted_49 = { class: "cc-table-cell" };
const _hoisted_50 = { class: "cc-table-cell break-all max-h-24 overflow-y-auto block cc-text-semi-bold" };
const _hoisted_51 = {
  key: 3,
  class: "col-span-12 my-1"
};
const _hoisted_52 = { class: "w-full px-2 whitespace-pre-wrap overflow-auto" };
const _hoisted_53 = { class: "flex" };
const _hoisted_54 = {
  key: 0,
  class: "flex"
};
const _sfc_main$3 = /* @__PURE__ */ defineComponent({
  __name: "GridTokenDetailsModal",
  props: {
    token: { type: Object, required: true },
    assetInfo: { type: Object, required: true },
    assetCDN: { type: null, required: false, default: null },
    fingerprint: { type: String, required: true },
    tokenName: { type: String, required: true },
    isNFT: { type: Boolean, default: false }
  },
  emits: ["reloadAssetInfo", "close"],
  setup(__props, { emit: __emit }) {
    const props = __props;
    const emit = __emit;
    const { t } = useTranslation();
    const $q = useQuasar();
    const {
      walletSettings
    } = useSelectedAccount();
    const walletPlate = walletSettings.plate;
    const walletBackground = walletSettings.background;
    const updatePlate = walletSettings.updatePlate;
    const updateBackground = walletSettings.updateBackground;
    const imageSource = ref("");
    const showOnChainFileModal = ref(false);
    const onChainFile = ref(null);
    const onChainType = ref(MediaType.UNDEFINED);
    const loading = ref(true);
    const showTypeToggle = ref(false);
    const imageTypes = reactive([
      { id: "cdn", label: "CDN", index: 0 },
      { id: "src", label: "SOURCE", index: 1 }
    ]);
    const imageType = ref(0);
    const { isAssetOnBlockList } = useGuard();
    const isScam = ref(false);
    const {
      useCompactFormat,
      getDisplayDecimals
    } = useFormatter();
    const tokenCurrencyValue = ref(null);
    const { activeCurrency } = useCurrencyAPI();
    reactive([
      { id: "details", label: t("wallet.summary.token.modal.blockchainData"), index: 0 },
      { id: "price", label: t("wallet.summary.token.modal.priceData"), index: 1 }
    ]);
    const meta68 = ref(null);
    const meta721 = ref(null);
    const meta1155 = ref(null);
    const multipleFiles = computed(() => {
      var _a;
      return (((_a = meta721.value) == null ? void 0 : _a.files) ?? []).length > 1;
    });
    const metaEntries = ref([]);
    const showMetaEntries = computed(() => metaEntries.value.length > 0);
    ref(false);
    ref(false);
    const showPriceInfoTable = ref(true);
    ref(null);
    const floorPrice = ref(null);
    function close() {
      imageType.value = 0;
      emit("close");
    }
    function togglePriceTableInfo(event) {
      showPriceInfoTable.value = event;
    }
    function toggleImageType(index) {
      if (imageType.value === index) {
        return;
      }
      imageType.value = index;
      getImage();
    }
    function prepareTableEntries(obj) {
      metaEntries.value = flattenTableEntries("root_metadata", obj, 0);
    }
    function flattenTableEntries(key, value, level) {
      const ar = [];
      if (level > 4) {
        return [];
      }
      if (typeof value === "object") {
        const entries = Object.entries(value).sort((a, b) => a[0].localeCompare(b[0], "en-US"));
        if (key !== "root_metadata" && Number.isNaN(parseInt(key))) {
          ar.push({ key: key.toString(), value: "", isHeader: true });
        }
        for (const entry of entries) {
          ar.push(...flattenTableEntries(entry[0], entry[1], level + 1));
        }
      } else if (Array.isArray(value)) {
        const entries = value;
        if (key !== "root_metadata" && Number.isNaN(parseInt(key))) {
          ar.push({ key, value: "", isHeader: true });
        }
        for (let i = 0; i < entries.length; i++) {
          const entry = entries[i];
          ar.push(...flattenTableEntries(i.toString(), entry, level + 1));
        }
      } else {
        ar.push({ key, value: value.toString(), isHeader: false });
      }
      return ar;
    }
    function getMediaButtonLabel(file, index = 0) {
      var _a, _b, _c, _d;
      const selectText = t("wallet.summary.token.dialog.files.select");
      let labelType = t("wallet.summary.token.dialog.files.types.file");
      if ((_a = file.mediaType) == null ? void 0 : _a.includes("gif")) {
        labelType = t("wallet.summary.token.dialog.files.types.gif");
      } else if ((_b = file.mediaType) == null ? void 0 : _b.includes("image")) {
        labelType = t("wallet.summary.token.dialog.files.types.image");
      } else if ((_c = file.mediaType) == null ? void 0 : _c.includes("video")) {
        labelType = t("wallet.summary.token.dialog.files.types.video");
      } else if ((_d = file.mediaType) == null ? void 0 : _d.includes("audio")) {
        labelType = t("wallet.summary.token.dialog.files.types.audio");
      }
      return selectText.replace("###FORMAT###", labelType).replace("###INDEX###", (index + 1).toString());
    }
    async function onClickOpenOnChainFile(fileIndex = 0) {
      var _a;
      let files = ((_a = meta721.value) == null ? void 0 : _a.files) ?? [];
      if (files.length > 0) {
        const item = files[fileIndex];
        if (item && item.src && item.mediaType) {
          onChainFile.value = item;
          if (item.mediaType === "text/html") {
            onChainType.value = MediaType.IFRAME;
            showOnChainFileModal.value = true;
          } else if (item.mediaType === "application/pdf") {
            onChainType.value = MediaType.PDF;
            showOnChainFileModal.value = true;
          } else if (item.mediaType === "image/png" || item.mediaType === "image/jpg" || item.mediaType === "image/jpeg" || item.mediaType === "image/webp" || item.mediaType === "image/gif") {
            onChainType.value = MediaType.IMAGE;
            showOnChainFileModal.value = true;
          } else if (item.mediaType.startsWith("video/")) {
            onChainType.value = MediaType.VIDEO;
            showOnChainFileModal.value = true;
          } else if (item.mediaType.startsWith("audio/")) {
            onChainType.value = MediaType.AUDIO;
            showOnChainFileModal.value = true;
          }
        }
      }
    }
    const showOpenOnChainFile = computed(() => {
      var _a;
      if ((_a = meta721.value) == null ? void 0 : _a.files) {
        if (meta721.value.files.length > 0) {
          const item = meta721.value.files[0];
          if (item && item.src && item.mediaType) {
            if (item.mediaType === "text/html") {
              return !isBexApp();
            } else if (item.mediaType === "application/pdf") {
              return !isBexApp();
            } else if (item.mediaType === "image/png" || item.mediaType === "image/jpg" || item.mediaType === "image/jpeg" || item.mediaType === "image/webp" || item.mediaType === "image/gif") {
              return true;
            } else if (item.mediaType.startsWith("video/")) {
              return true;
            } else if (item.mediaType.startsWith("audio/")) {
              return true;
            }
          }
        } else if (meta721.value.image.length > 0) {
          return true;
        }
      }
      return false;
    });
    const showSetAsBackgroundButton = computed(() => {
      var _a;
      if ((_a = meta721.value) == null ? void 0 : _a.files) {
        if (meta721.value.files.length > 0) {
          const item = meta721.value.files[0];
          if (item && item.src && item.mediaType) {
            if (item.mediaType === "text/html") {
              return !isBexApp();
            } else if (item.mediaType === "application/pdf") {
              return false;
            } else if (item.mediaType === "image/png" || item.mediaType === "image/jpg" || item.mediaType === "image/jpeg" || item.mediaType === "image/webp" || item.mediaType === "image/gif") {
              return true;
            } else if (item.mediaType.startsWith("video/")) {
              return true;
            } else if (item.mediaType.startsWith("audio/")) {
              return false;
            }
          }
        } else if (meta721.value.image.length > 0) {
          return true;
        }
      }
      return false;
    });
    function notifyUpdate(success, message) {
      $q.notify({
        type: success ? "positive" : "negative",
        message: t("wallet.settings.message." + (success ? "success" : "failed")),
        position: "top-left"
      });
    }
    async function onClickSetWalletIcon() {
      var _a;
      if ((_a = props.assetCDN) == null ? void 0 : _a.i) {
        const resizedImage = await resizeImage(imageSource.value, 60);
        let data = LZString.compress(resizedImage);
        const success = await updatePlate({
          image: walletPlate.value.image,
          data: data ?? walletPlate.value.data,
          checksum: walletPlate.value.checksum
        });
        notifyUpdate(success);
      }
    }
    async function onClickSetWalletBackground() {
      var _a, _b;
      let bg = {
        policy: ((_a = props.token) == null ? void 0 : _a.p) ?? walletBackground.value.policy,
        name: ((_b = props.token) == null ? void 0 : _b.t.a) ?? walletBackground.value.name,
        opacity: 95
      };
      const success = await updateBackground(bg);
      await setWalletBackground(networkId.value, bg);
      notifyUpdate(success);
    }
    async function getFloorPrice() {
      var _a, _b;
      floorPrice.value = { status: "loading" };
      const price = await getAssetPrice(props.fingerprint, props.token.p, props.token.t.a, props.assetInfo);
      if (price) {
        floorPrice.value = price.priceInfo;
        if (activeCurrency.value && price.priceInfo.avgFloorPrice) {
          let amount = props.token.t.q;
          if ((((_b = (_a = props.assetInfo) == null ? void 0 : _a.tr) == null ? void 0 : _b.d) ?? 0) > 0) {
            amount = divide(amount, 10 ** props.assetInfo.tr.d);
          }
          tokenCurrencyValue.value = multiply(multiply(divide(price.priceInfo.avgFloorPrice, 1e6), activeCurrency.value.value), amount);
        }
      }
    }
    async function getImage(init = true) {
      var _a, _b, _c, _d, _e, _f, _g, _h, _i, _j, _k, _l;
      loading.value = true;
      if (imageType.value === 0) {
        if (!props.assetCDN) {
          return;
        }
        const image = await fetchAssetCDNImage(networkId.value, props.assetCDN, MediaSize.HIGH);
        if (image) {
          imageSource.value = getImageB64(image);
          showTypeToggle.value = true;
        } else if (init) {
          imageType.value = 1;
          await getImage();
        }
      } else {
        if (!meta721.value && !meta1155.value) {
          return;
        }
        let imageURL = "";
        if (((_a = meta721.value) == null ? void 0 : _a.image) && meta721.value.image.length > 0) {
          imageURL = Array.isArray(meta721.value.image) ? meta721.value.image.join("") : typeof meta721.value.image === "object" ? Object.values(meta721.value.image).join("") : meta721.value.image;
          if (imageURL.startsWith("ar://")) {
            imageURL = "https://arweave.net/" + imageURL.slice(5);
          } else if (imageURL.includes(";base64,")) {
            const imageB64start = imageURL.indexOf(";base64,") + 8;
            imageURL = imageURL.substring(0, imageB64start) + (((_b = imageURL.substring(imageB64start)) == null ? void 0 : _b.replace(/,/g, "")) ?? imageURL.substring(imageB64start));
          }
        } else if (((_d = (_c = meta1155.value) == null ? void 0 : _c.asset) == null ? void 0 : _d.ipfs) && ((_f = (_e = meta1155.value) == null ? void 0 : _e.asset) == null ? void 0 : _f.ipfs.length) > 0) {
          imageURL = meta1155.value.asset.ipfs;
        } else if (((_i = (_h = (_g = props.assetInfo) == null ? void 0 : _g.tr) == null ? void 0 : _h.u) == null ? void 0 : _i.includes("ipfs")) || ((_l = (_k = (_j = props.assetInfo) == null ? void 0 : _j.tr) == null ? void 0 : _k.u) == null ? void 0 : _l.endsWith(".png"))) {
          imageURL = props.assetInfo.tr.u;
        }
        if (imageURL.length === 0) {
          return;
        }
        if (!imageURL.includes("ipfs/") && (imageURL.match("^https?:.+") || imageURL.match("^data:image.+;base64,.+"))) {
          imageSource.value = imageURL;
        } else {
          const ipfsBase64 = await fetchIPFS(imageURL);
          if (ipfsBase64) {
            imageSource.value = "data:image/png;base64," + ipfsBase64;
          } else {
            console.warn(`Error downloading token image: [${props.tokenName}] ${imageURL}`);
          }
        }
      }
      loading.value = false;
    }
    async function fetchMetadata() {
      const metadata = await fetchAssetMetadata(networkId.value, props.token.p, props.token.t.a);
      if (Array.isArray(metadata)) {
        meta721.value = get721MetadataDetails(props.token.p, props.token.t.a, metadata);
        if (!meta721.value) {
          meta1155.value = get1155Metadata(metadata);
        }
        if (meta721.value) {
          prepareTableEntries(meta721.value);
        } else if (meta1155.value) {
          prepareTableEntries(meta1155.value);
        }
      } else {
        meta68.value = metadata.json;
        prepareTableEntries(meta68.value);
      }
    }
    watch(() => props.assetCDN, () => {
      if (props.assetCDN && imageType.value === 0) {
        getImage();
      }
    });
    onMounted(async () => {
      emit("reloadAssetInfo");
      const calls = [fetchMetadata(), getImage(true), getFloorPrice()];
      await Promise.all(calls);
      isScam.value = isAssetOnBlockList(props.fingerprint);
    });
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock(Fragment, null, [
        createVNode(Modal, {
          onClose: close,
          "full-width-on-mobile": ""
        }, {
          header: withCtx(() => [
            createBaseVNode("div", _hoisted_1$3, [
              createBaseVNode("div", _hoisted_2$3, [
                createVNode(_sfc_main$b, {
                  label: __props.tokenName,
                  "do-capitalize": false
                }, null, 8, ["label"])
              ])
            ])
          ]),
          content: withCtx(() => {
            var _a, _b, _c, _d, _e, _f, _g, _h, _i, _j;
            return [
              createVNode(_sfc_main$4, { "is-scam": isScam.value }, null, 8, ["is-scam"]),
              createBaseVNode("div", _hoisted_3$3, [
                createBaseVNode("div", _hoisted_4$3, [
                  imageSource.value || loading.value ? (openBlock(), createElementBlock("div", _hoisted_5$3, [
                    imageSource.value ? (openBlock(), createElementBlock("img", {
                      key: 0,
                      loading: "lazy",
                      src: imageSource.value,
                      alt: "asset image",
                      class: normalizeClass(["mt-12 lg:mt-0 h-auto max-w-sm", (loading.value ? "opacity-20" : "") + (isScam.value ? " grayscale" : "")])
                    }, null, 10, _hoisted_6$3)) : createCommentVNode("", true),
                    isScam.value ? (openBlock(), createElementBlock("div", _hoisted_7$3, [
                      createBaseVNode("div", _hoisted_8$2, toDisplayString(unref(t)("common.scam.token.image")), 1)
                    ])) : createCommentVNode("", true),
                    loading.value ? (openBlock(), createBlock(QSpinnerDots_default, {
                      key: 2,
                      class: "absolute h-12",
                      size: "48",
                      color: "grey"
                    })) : createCommentVNode("", true),
                    createBaseVNode("div", _hoisted_9$2, [
                      showTypeToggle.value ? (openBlock(), createBlock(_sfc_main$f, {
                        key: 0,
                        "button-css": "text-xs py-1 h-8",
                        "nav-css": "",
                        tabs: imageTypes,
                        divider: false,
                        index: imageType.value,
                        onSelection: toggleImageType
                      }, {
                        tab0: withCtx(() => _cache[2] || (_cache[2] = [])),
                        tab1: withCtx(() => _cache[3] || (_cache[3] = [])),
                        _: 1
                      }, 8, ["tabs", "index"])) : createCommentVNode("", true)
                    ])
                  ])) : (openBlock(), createElementBlock("div", _hoisted_10$2, [
                    createBaseVNode("img", {
                      loading: "lazy",
                      src: unref(noLogo),
                      alt: "asset image",
                      class: "w-full h-48 sm:h-80 dark:fill-white"
                    }, null, 8, _hoisted_11$2)
                  ]))
                ]),
                createBaseVNode("div", {
                  class: normalizeClass(["grow shrink", isScam.value ? "opacity-15" : ""])
                }, [
                  !__props.isNFT ? (openBlock(), createElementBlock("div", _hoisted_12$1, [
                    __props.assetInfo && __props.token.t.q !== "0" ? (openBlock(), createElementBlock("div", _hoisted_13$1, [
                      createBaseVNode("div", _hoisted_14$1, [
                        createBaseVNode("p", _hoisted_15$1, toDisplayString(unref(t)("wallet.summary.token.modal.amountOwned")), 1),
                        createVNode(_sfc_main$d, {
                          "text-c-s-s": "px-3 py-1 bg-neutral-150 dark:bg-highlightdarkarea rounded",
                          amount: __props.token.t.q,
                          decimals: ((_a = __props.assetInfo.tr) == null ? void 0 : _a.d) ?? 0,
                          currency: ""
                        }, null, 8, ["amount", "decimals"])
                      ])
                    ])) : createCommentVNode("", true),
                    tokenCurrencyValue.value && tokenCurrencyValue.value !== "0" ? (openBlock(), createElementBlock("div", _hoisted_16$1, [
                      createBaseVNode("div", _hoisted_17$1, [
                        createBaseVNode("p", _hoisted_18$1, toDisplayString(unref(t)("wallet.summary.token.modal.amountValue")), 1),
                        createBaseVNode("div", _hoisted_19$1, [
                          createVNode(_sfc_main$d, {
                            "whole-c-s-s": "cc-text-semi-bold",
                            "symbol-c-s-s": "cc-text-normal",
                            amount: tokenCurrencyValue.value,
                            currency: unref(activeCurrency).id,
                            decimals: unref(getDisplayDecimals)(tokenCurrencyValue.value),
                            compact: unref(useCompactFormat)(tokenCurrencyValue.value),
                            "is-whole-number": ""
                          }, null, 8, ["amount", "currency", "decimals", "compact"])
                        ])
                      ])
                    ])) : createCommentVNode("", true),
                    !__props.isNFT ? (openBlock(), createElementBlock("div", _hoisted_20$1, [
                      __props.assetInfo ? (openBlock(), createElementBlock("div", _hoisted_21$1, [
                        createBaseVNode("p", _hoisted_22$1, toDisplayString(unref(t)("wallet.summary.token.modal.totalCirculation")), 1),
                        createVNode(_sfc_main$d, {
                          "balance-always-visible": "",
                          "text-c-s-s": "px-3 py-1 bg-neutral-150 dark:bg-highlightdarkarea rounded",
                          amount: __props.assetInfo.ts,
                          decimals: ((_b = __props.assetInfo.tr) == null ? void 0 : _b.d) ?? 0,
                          currency: ""
                        }, null, 8, ["amount", "decimals"])
                      ])) : createCommentVNode("", true)
                    ])) : createCommentVNode("", true),
                    floorPrice.value ? (openBlock(), createElementBlock("div", _hoisted_23$1, [
                      createVNode(_sfc_main$6, {
                        "floor-price": floorPrice.value,
                        onTogglePriceView: togglePriceTableInfo
                      }, null, 8, ["floor-price"])
                    ])) : createCommentVNode("", true)
                  ])) : (openBlock(), createElementBlock("div", _hoisted_24$1, [
                    floorPrice.value ? (openBlock(), createElementBlock("div", _hoisted_25$1, [
                      createVNode(_sfc_main$6, {
                        "floor-price": floorPrice.value,
                        onTogglePriceView: togglePriceTableInfo
                      }, null, 8, ["floor-price"])
                    ])) : createCommentVNode("", true)
                  ])),
                  createBaseVNode("div", _hoisted_26$1, [
                    createBaseVNode("div", _hoisted_27$1, [
                      floorPrice.value && showPriceInfoTable.value ? (openBlock(), createBlock(GridFloorPriceTable, {
                        key: 0,
                        "floor-price": floorPrice.value,
                        token: props.token
                      }, null, 8, ["floor-price", "token"])) : createCommentVNode("", true)
                    ]),
                    !__props.isNFT ? (openBlock(), createElementBlock("div", _hoisted_28$1, _cache[4] || (_cache[4] = [
                      createBaseVNode("div", { class: "w-full border-b" }, null, -1)
                    ]))) : createCommentVNode("", true),
                    createVNode(_sfc_main$b, {
                      label: unref(t)("wallet.summary.token.modal.blockchainData"),
                      class: "cc-table-cell"
                    }, null, 8, ["label"]),
                    createBaseVNode("table", _hoisted_29$1, [
                      ((_c = __props.assetInfo.tr) == null ? void 0 : _c.ds) ? (openBlock(), createElementBlock("tr", _hoisted_30$1, [
                        createBaseVNode("th", _hoisted_31$1, toDisplayString(unref(t)("wallet.summary.token.modal.description")), 1),
                        createBaseVNode("th", _hoisted_32$1, toDisplayString((_d = __props.assetInfo.tr) == null ? void 0 : _d.ds), 1)
                      ])) : createCommentVNode("", true),
                      ((_f = (_e = __props.assetInfo) == null ? void 0 : _e.tr) == null ? void 0 : _f.u) && !((_g = __props.assetInfo.tr) == null ? void 0 : _g.u.includes("ipfs")) ? (openBlock(), createElementBlock("tr", _hoisted_33, [
                        createBaseVNode("th", _hoisted_34, toDisplayString(unref(t)("wallet.summary.token.modal.website")), 1),
                        createBaseVNode("th", _hoisted_35, [
                          createBaseVNode("a", {
                            href: (_i = (_h = __props.assetInfo) == null ? void 0 : _h.tr) == null ? void 0 : _i.u,
                            target: "_blank",
                            rel: "noopener noreferrer"
                          }, toDisplayString((_j = __props.assetInfo.tr) == null ? void 0 : _j.u), 9, _hoisted_36)
                        ])
                      ])) : createCommentVNode("", true),
                      createBaseVNode("tr", null, [
                        createBaseVNode("th", _hoisted_37, toDisplayString(unref(t)("wallet.summary.token.fingerprint")), 1),
                        createBaseVNode("th", _hoisted_38, [
                          createBaseVNode("div", _hoisted_39, [
                            createVNode(_sfc_main$g, {
                              "label-hover": unref(t)("wallet.summary.button.copy.token.fingerprint.hover"),
                              "label-c-s-s": "w-full break-all",
                              "notification-text": unref(t)("wallet.summary.button.copy.token.fingerprint.notify"),
                              "copy-text": __props.fingerprint,
                              class: "mr-1"
                            }, null, 8, ["label-hover", "notification-text", "copy-text"]),
                            createVNode(_sfc_main$h, {
                              subject: { p: __props.token.p, t: __props.token.t, f: __props.fingerprint },
                              type: "token",
                              label: __props.fingerprint,
                              "label-c-s-s": "break-all",
                              class: "max-w-full"
                            }, null, 8, ["subject", "label"])
                          ])
                        ])
                      ]),
                      createBaseVNode("tr", null, [
                        createBaseVNode("th", _hoisted_40, toDisplayString(unref(t)("wallet.summary.token.policyId")), 1),
                        createBaseVNode("th", _hoisted_41, [
                          createVNode(_sfc_main$g, {
                            label: __props.token.p,
                            "label-c-s-s": "w-full break-all",
                            "label-hover": unref(t)("wallet.summary.button.copy.token.policyid.hover") + "<br/>" + __props.token.p,
                            "notification-text": unref(t)("wallet.summary.button.copy.token.policyid.notify"),
                            "copy-text": __props.token.p,
                            class: "mr-1"
                          }, null, 8, ["label", "label-hover", "notification-text", "copy-text"])
                        ])
                      ]),
                      createBaseVNode("tr", null, [
                        createBaseVNode("th", _hoisted_42, toDisplayString(unref(t)("wallet.summary.token.assetName")), 1),
                        createBaseVNode("th", _hoisted_43, [
                          createVNode(_sfc_main$g, {
                            label: __props.token.t.a,
                            "label-c-s-s": "w-full break-all",
                            "label-hover": unref(t)("wallet.summary.button.copy.token.assetname.hover") + "<br/>" + __props.token.t.a,
                            "notification-text": unref(t)("wallet.summary.button.copy.token.assetname.notify"),
                            "copy-text": __props.token.t.a,
                            class: "mr-1 break-all"
                          }, null, 8, ["label", "label-hover", "notification-text", "copy-text"])
                        ])
                      ])
                    ]),
                    showMetaEntries.value ? (openBlock(), createElementBlock("div", _hoisted_44, _cache[5] || (_cache[5] = [
                      createBaseVNode("div", { class: "w-full border-b" }, null, -1)
                    ]))) : createCommentVNode("", true),
                    showMetaEntries.value ? (openBlock(), createBlock(_sfc_main$b, {
                      key: 2,
                      label: unref(t)("wallet.summary.token.sectionlabel.metadata"),
                      class: "cc-table-cell"
                    }, null, 8, ["label"])) : createCommentVNode("", true),
                    createBaseVNode("table", _hoisted_45, [
                      (openBlock(true), createElementBlock(Fragment, null, renderList(metaEntries.value, (entry, index) => {
                        return openBlock(), createElementBlock(Fragment, { key: index }, [
                          entry.isHeader ? (openBlock(), createElementBlock("tr", _hoisted_46, [
                            createBaseVNode("th", _hoisted_47, [
                              createBaseVNode("u", null, toDisplayString(entry.key), 1)
                            ])
                          ])) : (openBlock(), createElementBlock("tr", _hoisted_48, [
                            createBaseVNode("th", _hoisted_49, toDisplayString(entry.key), 1),
                            createBaseVNode("th", _hoisted_50, toDisplayString(entry.value), 1)
                          ]))
                        ], 64);
                      }), 128))
                    ]),
                    showMetaEntries.value ? (openBlock(), createElementBlock("div", _hoisted_51, _cache[6] || (_cache[6] = [
                      createBaseVNode("div", { class: "w-full border-b" }, null, -1)
                    ]))) : createCommentVNode("", true),
                    showMetaEntries.value ? (openBlock(), createBlock(_sfc_main$b, {
                      key: 4,
                      label: unref(t)("wallet.summary.token.modal.rawJSON"),
                      class: "cc-table-cell"
                    }, null, 8, ["label"])) : createCommentVNode("", true),
                    createBaseVNode("div", _hoisted_52, [
                      showMetaEntries.value ? (openBlock(), createBlock(unref(S), {
                        key: 0,
                        class: "font-mono",
                        style: { "font-size": "0.7rem", "line-height": "1.1rem" },
                        showLength: "",
                        showDoubleQuotes: false,
                        deep: 0,
                        data: meta721.value ?? meta1155.value ?? meta68.value
                      }, null, 8, ["data"])) : createCommentVNode("", true)
                    ]),
                    createVNode(GridSpace, { class: "my-2" })
                  ])
                ], 2)
              ])
            ];
          }),
          footer: withCtx(() => {
            var _a, _b, _c, _d, _e;
            return [
              createBaseVNode("div", _hoisted_53, [
                showOpenOnChainFile.value && !multipleFiles.value && (((_b = (_a = meta721.value) == null ? void 0 : _a.files) == null ? void 0 : _b.length) ?? 0) > 0 ? (openBlock(), createBlock(_sfc_main$i, {
                  key: 0,
                  class: "p-1 m-2 initial flex-1 w-1/4",
                  label: unref(t)("wallet.summary.token.dialog.onchainfile"),
                  onClick: _cache[0] || (_cache[0] = withModifiers(($event) => onClickOpenOnChainFile(), ["stop"]))
                }, null, 8, ["label"])) : createCommentVNode("", true),
                showSetAsBackgroundButton.value ? (openBlock(), createBlock(_sfc_main$i, {
                  key: 1,
                  class: "p-1 m-2 flex-1 w-1/4",
                  label: unref(t)("wallet.background.setAs"),
                  link: onClickSetWalletBackground
                }, null, 8, ["label"])) : createCommentVNode("", true),
                (((_d = (_c = meta721.value) == null ? void 0 : _c.files) == null ? void 0 : _d.length) ?? 0) > 0 || imageSource.value.length > 0 ? (openBlock(), createBlock(_sfc_main$i, {
                  key: 2,
                  class: "p-1 m-2 flex-1 w-1/4",
                  label: unref(t)("wallet.icon.setAs"),
                  capitalize: false,
                  link: onClickSetWalletIcon
                }, null, 8, ["label"])) : createCommentVNode("", true)
              ]),
              showOpenOnChainFile.value && multipleFiles.value ? (openBlock(), createElementBlock("div", _hoisted_54, [
                createVNode(GridSpace, {
                  hr: "",
                  class: "w-full"
                }),
                ((_e = meta721.value) == null ? void 0 : _e.files) ? (openBlock(true), createElementBlock(Fragment, { key: 0 }, renderList(meta721.value.files, (file, index) => {
                  return openBlock(), createBlock(_sfc_main$i, {
                    key: index,
                    class: "p-1 m-2 initial flex-1 w-1/4",
                    label: getMediaButtonLabel(file, index),
                    onClick: withModifiers(($event) => onClickOpenOnChainFile(index), ["stop"])
                  }, null, 8, ["label", "onClick"]);
                }), 128)) : createCommentVNode("", true)
              ])) : createCommentVNode("", true)
            ];
          }),
          _: 1
        }),
        showOnChainFileModal.value && onChainFile.value ? (openBlock(), createBlock(_sfc_main$7, {
          key: 0,
          "on-chain-type": onChainType.value,
          "on-chain-file": onChainFile.value,
          onClose: _cache[1] || (_cache[1] = ($event) => showOnChainFileModal.value = false)
        }, null, 8, ["on-chain-type", "on-chain-file"])) : createCommentVNode("", true)
      ], 64);
    };
  }
});
const GridTokenDetailsModal = /* @__PURE__ */ _export_sfc(_sfc_main$3, [["__scopeId", "data-v-2e6cd399"]]);
const _hoisted_1$2 = { class: "relative w-full flex flex-row flex-nowrap space-x-2" };
const _hoisted_2$2 = { class: "relative flex flex-col flex-nowrap justify-start items-center h-full m-1" };
const _hoisted_3$2 = ["src"];
const _hoisted_4$2 = {
  key: 0,
  class: "absolute left-0 right-0 top-0 bottom-0 flex flex-col justify-center items-center"
};
const _hoisted_5$2 = { class: "cc-text cc-badge-bg-red cc-bg-warning rounded-borders w-full text-center py-0.5 font-extrabold drop-shadow-black" };
const _hoisted_6$2 = { class: "relative w-full overflow-hidden flex-1 flex flex-col flex-nowrap justify-center items-start space-y-0.5 sm:space-y-1.5" };
const _hoisted_7$2 = { class: "relative w-full flex flex-col flex-nowrap justify-between gap-0.5" };
const _hoisted_8$1 = { class: "relative w-full flex-shrink item-text flex flex-row flex-nowrap overflow-hidden max-w-full" };
const _hoisted_9$1 = { class: "relative w-full flex-shrink item-text flex flex-row flex-nowrap items-start max-w-full" };
const _hoisted_10$1 = { class: "w-full whitespace-nowrap grow-0 text-md truncate" };
const _hoisted_11$1 = { key: 0 };
const _hoisted_12 = {
  key: 1,
  class: "cc-text-slate-0"
};
const _hoisted_13 = { class: "relative w-1 h-0" };
const _hoisted_14 = {
  key: 0,
  class: "absolute -top-1 ml-1.5 mdi mdi-check-decagram-outline text-lg cc-text-blue"
};
const _hoisted_15 = {
  key: 0,
  class: "item-text break-words flex flew-row justify-start whitespace-nowrap"
};
const _hoisted_16 = {
  key: 0,
  class: "flex flex-row flex-nowrap"
};
const _hoisted_17 = { class: "flex flex-row flex-nowrap" };
const _hoisted_18 = {
  key: 1,
  class: "item-text break-words flex flex-row flex-nowrap justify-start whitespace-nowrap"
};
const _hoisted_19 = {
  key: 0,
  class: "w-full flex flex-row flex-nowrap items-center text-xs cc-text-light cc-text-slate-0 break-words"
};
const _hoisted_20 = {
  key: 0,
  class: "w-full"
};
const _hoisted_21 = { class: "relative overflow-hidden flex-1 flex flex-col flex-nowrap justify-center items-start" };
const _hoisted_22 = { class: "w-full flex flex-row flex-nowrap items-center text-xs cc-text-semi-bold truncate" };
const _hoisted_23 = {
  key: 0,
  class: "w-full flex flex-row flex-nowrap mt-0.5 items-center pt-0.5 text-xs"
};
const _hoisted_24 = { class: "cc-text-semi-bold text-right whitespace-nowrap mr-2" };
const _hoisted_25 = { class: "w-full whitespace-pre-wrap overflow-auto cc-text-xs" };
const _hoisted_26 = { class: "w-full flex flex-row flex-nowrap mt-0.5 items-center pt-0.5 text-xs truncate" };
const _hoisted_27 = { class: "cc-text-semi-bold text-right whitespace-nowrap mr-2" };
const _hoisted_28 = {
  key: 0,
  class: "w-full flex flex-row flex-nowrap mt-0.5 items-center pt-0.5 text-xs truncate"
};
const _hoisted_29 = { class: "cc-text-semi-bold text-right whitespace-nowrap mr-2" };
const _hoisted_30 = {
  key: 0,
  class: "w-full flex flex-col flex-nowrap pt-1"
};
const _hoisted_31 = {
  key: 0,
  class: "relative flex flex-row flex-nowrap items-center cursor-help"
};
const _hoisted_32 = {
  key: 1,
  class: "w-full xs:w-1/2"
};
const _sfc_main$2 = /* @__PURE__ */ defineComponent({
  __name: "GridTokenCard",
  props: {
    token: { type: Object, required: true },
    assetinfo: { type: null, required: false, default: null },
    fingerprint: { type: String, required: true },
    prefilledInput: { type: String, required: false },
    sendEnabled: { type: Boolean, default: false },
    sendReadOnly: { type: Boolean, required: false, default: false },
    disableAmountCheck: { type: Boolean, required: false, default: false },
    autoSubmit: { type: Boolean, required: false, default: false },
    advancedViewEnabled: { type: Boolean, default: false },
    checkMilkomedaMinAmount: { type: Boolean, required: false, default: false },
    disableDetailsModal: { type: Boolean, required: false, default: false },
    simpleSelect: { type: Boolean, required: false, default: false },
    showVerified: { type: Boolean, required: false, default: false },
    manualUpdateAutoSelect: { type: Boolean, default: true },
    maxCols: { type: Number, required: false, default: 3 },
    isOwnAsset: { type: Boolean, required: false, default: true },
    disabled: { type: Boolean, required: false, default: false }
  },
  emits: ["addAsset", "delAsset", "inputError", "assetInfoUpd"],
  setup(__props, { emit: __emit }) {
    const props = __props;
    const emit = __emit;
    const { t } = useTranslation();
    const { updateTabId } = useTabId();
    const $q = useQuasar();
    const {
      truncateString,
      formatAmountString,
      getDecimalNumber,
      getNumberFormatSeparators,
      valueFromFormattedString
    } = useFormatter();
    let formatSeparators = getNumberFormatSeparators();
    const { isAssetOnBlockList } = useGuard();
    const isScam = ref(false);
    const decimalSeparator = ref(formatSeparators.decimal);
    const groupSeparator = ref(formatSeparators.group);
    watch(appLanguageTag, () => {
      formatSeparators = getNumberFormatSeparators();
      decimalSeparator.value = formatSeparators.decimal;
      groupSeparator.value = formatSeparators.group;
      onTokenInputReset();
    }, { deep: true });
    const showDetailsModal = ref(false);
    const assetInfo = ref(props.assetinfo ?? void 0);
    const assetCDN = ref(null);
    const isVerified = getAssetStatus(props.token.p, props.token.t.a) === "verified";
    watch(() => props.assetinfo, (newAssetInfo) => assetInfo.value = newAssetInfo);
    watch(() => props.token, () => {
      loadAssetInfo();
      loadCDNImage();
    });
    const selected = computed(() => "a" in props.token);
    const isADA = computed(() => props.token.p.length === 0 || props.token.p === ".");
    const tokenName = computed(() => {
      var _a, _b, _c;
      return isADA.value ? "ADA" : ((_a = assetInfo.value) == null ? void 0 : _a.n) ?? ((_c = (_b = assetInfo.value) == null ? void 0 : _b.tr) == null ? void 0 : _c.n) ?? formatAssetName(props.token.t.a);
    });
    const fingerprint = computed(() => props.fingerprint ?? getAssetIdBech32(props.token.p, props.token.t.a));
    const imgSrc = ref(noLogo);
    const tokenInput = ref(props.prefilledInput ? props.prefilledInput : compare(props.token.t.q, "==", "1") ? "1" : "");
    const tokenInputError = ref("");
    const manualUpdate = ref(0);
    const milkomedaData = ref(null);
    const milkomedaMinAmount = ref("0");
    const decimals = computed(() => {
      var _a, _b;
      return ((_b = (_a = assetInfo.value) == null ? void 0 : _a.tr) == null ? void 0 : _b.d) ?? 0;
    });
    const isNFT = computed(() => {
      var _a;
      return (((_a = assetInfo.value) == null ? void 0 : _a.ts) ?? 1) === "1";
    });
    const validTokenValue = computed(() => !tokenInputError.value && tokenInput.value && compare(valueFromFormattedString(tokenInput.value, decimals.value, true).number, ">", 0));
    const tokenInputHint = computed(() => isADA.value ? formatAmountString("0", true, true, 6, 6) : decimals.value > 0 ? formatAmountString("0", true, true, decimals.value, decimals.value) : "0");
    watch(() => props.prefilledInput, (input) => {
      tokenInput.value = !input || input.length === 0 || input === "0" ? "" : formatAmountString(input, false, true, decimals.value, decimals.value);
      if (!props.disableAmountCheck && tokenInput.value.length > 0) {
        nextTick(() => {
          const amount = valueFromFormattedString(tokenInput.value, decimals.value);
          if (compare(amount.whole + amount.fraction, ">", props.token.t.q)) {
            tokenInputError.value = t("wallet.send.step.assets.error.fundsLow");
          } else {
            tokenInputError.value = "";
          }
        });
      }
    });
    watch(() => tokenInputError.value, (error) => emit("inputError", error));
    watch(() => decimals.value, (newValue) => {
      if (tokenInput.value.length === 0) {
        return;
      }
      tokenInput.value = formatAmountString(tokenInput.value.replace(/\D/g, ""), false, true, newValue, newValue);
    });
    function onRemoveToken(e) {
      emit("delAsset", props.token);
    }
    function onAddToken() {
      const value = valueFromFormattedString(tokenInput.value, decimals.value);
      let amount = value.whole;
      if (decimals.value > 0 && tokenInput.value !== "1") {
        amount = multiply(value.number, getDecimalNumber(decimals.value));
      }
      emit("addAsset", { p: props.token.p, t: props.token.t, a: amount });
    }
    function onTokenInputReset() {
      tokenInputError.value = "";
      tokenInput.value = compare(props.token.t.q, "==", "1") ? "1" : "";
      if (props.autoSubmit) {
        onAddToken();
      }
    }
    function onAddAllTokens() {
      tokenInputError.value = "";
      tokenInput.value = formatAmountString(props.token.t.q, false, true, decimals.value, decimals.value);
      if (props.autoSubmit) {
        onAddToken();
      }
    }
    function validateTokenInput(value) {
      if (value) {
        tokenInputError.value = "";
        manualUpdate.value += 1;
        const amount = valueFromFormattedString(value, decimals.value, true);
        if (!props.disableAmountCheck) {
          if (compare(multiply(amount.number, getDecimalNumber(decimals.value)), ">", props.token.t.q)) {
            tokenInputError.value = t("wallet.send.step.assets.error.fundsLow");
          }
          if (props.checkMilkomedaMinAmount && milkomedaData.value && compare(amount.number, "<", milkomedaMinAmount.value)) {
            tokenInputError.value = t("wallet.send.step.assets.error.milkomeda.minimum").replace("###AMOUNT###", milkomedaMinAmount.value);
          }
        }
        nextTick(() => {
          if (decimals.value > 0) {
            tokenInput.value = formatAmountString(multiply(amount.number, getDecimalNumber(decimals.value)), false, true, decimals.value, decimals.value);
          } else {
            tokenInput.value = formatAmountString(amount.number, true, true);
          }
          if (props.autoSubmit) {
            onAddToken();
          }
        });
      } else {
        manualUpdate.value += 1;
        nextTick(() => {
          tokenInput.value = "";
          if (props.autoSubmit) {
            onAddToken();
          }
        });
      }
    }
    const initMilkomedaMinAmount = async () => {
      if (!milkomedaData.value) {
        return;
      }
      milkomedaMinAmount.value = String(await getMinTxAmount(props.token, milkomedaData.value));
      return;
    };
    function onShowDetailsModal() {
      if (isADA.value || props.disableDetailsModal) {
        return;
      }
      if (assetInfo.value) {
        updateTabId("cdn");
        showDetailsModal.value = true;
        return;
      }
      $q.notify({
        type: "warning",
        message: t("wallet.summary.token.nometadata"),
        position: "top-left"
      });
    }
    async function reloadAssetInfo() {
      const calls = [];
      calls.push(loadAssetInfo(true));
      calls.push(loadCDNImage(true));
      await Promise.all(calls);
    }
    async function loadAssetInfo(force = false) {
      if (props.assetinfo && !force) {
        assetInfo.value = props.assetinfo;
      } else {
        assetInfo.value = await getAssetInfo(props.token.p, props.token.t.a, false, force, props.isOwnAsset) ?? getSwapAssetInfo(props.token.p, props.token.t.a);
        if (!assetInfo.value) {
          assetInfo.value = await getAssetInfo(props.token.p, props.token.t.a, true, true, props.isOwnAsset);
          if (!assetInfo.value) {
            assetInfo.value = null;
          }
        } else if (force) {
          updateSwapAssetInfoMap(props.token.p, assetInfo.value, props.isOwnAsset);
          updateSwapAssetInfoMap$1(props.token.p, assetInfo.value, props.isOwnAsset);
          emit("assetInfoUpd", assetInfo.value);
        }
      }
    }
    async function loadCDNImage(force = false) {
      var _a;
      if (isADA.value) {
        imgSrc.value = cardanoLogo;
        return;
      }
      if (!["mainnet", "preview", "preprod"].includes(networkId.value)) {
        return;
      }
      assetCDN.value = await getAssetCDN(props.fingerprint, force);
      if ((_a = assetCDN.value) == null ? void 0 : _a.i) {
        imgSrc.value = getImageB64(assetCDN.value.i);
      }
    }
    onMounted(async () => {
      if (props.checkMilkomedaMinAmount) {
        const config = await getMilkomedaData(networkId.value);
        if (config) {
          milkomedaData.value = config.config;
          await initMilkomedaMinAmount();
        }
      }
      if (!assetInfo.value) {
        loadAssetInfo();
      }
      loadCDNImage();
      isScam.value = isAssetOnBlockList(props.fingerprint);
    });
    return (_ctx, _cache) => {
      var _a, _b, _c, _d, _e, _f, _g, _h, _i;
      return openBlock(), createElementBlock("div", {
        class: normalizeClass(["relative cc-text-sz w-full col-span-12 max-w-full overflow-hidden flex flex-col flex-nowrap justify-start items-end pl-2 pr-3 py-2 space-y-0.5 h-full cc-rounded", [
          selected.value && !__props.disabled ? "cc-selected" : "cc-area-light ring-2 ring-transparent " + (__props.simpleSelect ? "cc-area-light md:min-h-28" : "ring-transparent md:min-h-20"),
          __props.maxCols === 4 ? "sm:col-span-3" : "sm:col-span-4"
        ]])
      }, [
        createBaseVNode("div", {
          class: normalizeClass(["relative w-full flex-1 overflow-hidden flex justify-start items-start space-y-2", isADA.value || __props.disableDetailsModal || !assetInfo.value ? "" : "cursor-pointer"]),
          onClick: onShowDetailsModal
        }, [
          createBaseVNode("div", _hoisted_1$2, [
            createBaseVNode("div", _hoisted_2$2, [
              createBaseVNode("div", {
                class: normalizeClass(["", imgSrc.value.length > 0 ? "   " : ""])
              }, [
                createBaseVNode("img", {
                  class: normalizeClass(["cc-icon-round-lg", imgSrc.value.length > 0 && imgSrc.value !== unref(cardanoLogo) ? "cursor-pointer " + (isScam.value ? "grayscale" : "") : ""]),
                  loading: "lazy",
                  src: imgSrc.value,
                  alt: "asset image",
                  onError: _cache[0] || (_cache[0] = ($event) => imgSrc.value = "")
                }, null, 42, _hoisted_3$2),
                isScam.value ? (openBlock(), createElementBlock("div", _hoisted_4$2, [
                  createBaseVNode("div", _hoisted_5$2, toDisplayString(unref(t)("common.scam.token.label")), 1)
                ])) : createCommentVNode("", true),
                showDetailsModal.value && assetInfo.value ? (openBlock(), createBlock(GridTokenDetailsModal, {
                  key: 1,
                  token: props.token,
                  fingerprint: props.fingerprint,
                  "asset-info": assetInfo.value,
                  "asset-c-d-n": assetCDN.value,
                  "token-name": tokenName.value,
                  "is-n-f-t": isNFT.value,
                  onReloadAssetInfo: _cache[1] || (_cache[1] = ($event) => reloadAssetInfo()),
                  onClose: _cache[2] || (_cache[2] = ($event) => showDetailsModal.value = false)
                }, null, 8, ["token", "fingerprint", "asset-info", "asset-c-d-n", "token-name", "is-n-f-t"])) : createCommentVNode("", true)
              ], 2)
            ]),
            createBaseVNode("div", _hoisted_6$2, [
              createBaseVNode("div", _hoisted_7$2, [
                createBaseVNode("div", _hoisted_8$1, [
                  createBaseVNode("div", _hoisted_9$1, [
                    createBaseVNode("div", _hoisted_10$1, [
                      createTextVNode(toDisplayString(((_b = (_a = assetInfo.value) == null ? void 0 : _a.tr) == null ? void 0 : _b.t) ? "[" + ((_d = (_c = assetInfo.value) == null ? void 0 : _c.tr) == null ? void 0 : _d.t) + "] " : "") + " ", 1),
                      tokenName.value ? (openBlock(), createElementBlock("span", _hoisted_11$1, toDisplayString(tokenName.value), 1)) : (openBlock(), createElementBlock("span", _hoisted_12, toDisplayString(unref(t)("common.label.noname")), 1))
                    ]),
                    createBaseVNode("div", _hoisted_13, [
                      __props.showVerified && isVerified && !isADA.value ? (openBlock(), createElementBlock("i", _hoisted_14, [
                        createVNode(_sfc_main$e, {
                          offset: [0, 26],
                          anchor: "top middle",
                          "transition-show": "scale",
                          "transition-hide": "scale"
                        }, {
                          default: withCtx(() => [
                            createTextVNode(toDisplayString(unref(t)("wallet.summary.token.hover.verified")), 1)
                          ]),
                          _: 1
                        })
                      ])) : createCommentVNode("", true)
                    ])
                  ])
                ]),
                !isNFT.value && __props.token.t.q !== "0" ? (openBlock(), createElementBlock("div", _hoisted_15, [
                  selected.value && "a" in __props.token ? (openBlock(), createElementBlock("span", _hoisted_16, [
                    createVNode(_sfc_main$d, {
                      "text-c-s-s": "flex-nowrap justify-end",
                      amount: __props.token.a,
                      decimals: decimals.value,
                      currency: ""
                    }, null, 8, ["amount", "decimals"]),
                    createVNode(_sfc_main$e, {
                      "tooltip-c-s-s": "whitespace-nowrap",
                      anchor: "bottom middle",
                      "transition-show": "scale",
                      "transition-hide": "scale"
                    }, {
                      default: withCtx(() => [
                        createTextVNode(toDisplayString(unref(t)("wallet.summary.token.hover.sendAmount")), 1)
                      ]),
                      _: 1
                    }),
                    _cache[6] || (_cache[6] = createTextVNode("  /  "))
                  ])) : createCommentVNode("", true),
                  createBaseVNode("span", _hoisted_17, [
                    createVNode(_sfc_main$d, {
                      "text-c-s-s": "flex-nowrap justify-end",
                      amount: __props.token.t.q,
                      decimals: decimals.value,
                      currency: ""
                    }, null, 8, ["amount", "decimals"]),
                    createVNode(_sfc_main$e, {
                      "tooltip-c-s-s": "whitespace-nowrap",
                      anchor: "bottom middle",
                      "transition-show": "scale",
                      "transition-hide": "scale"
                    }, {
                      default: withCtx(() => [
                        createTextVNode(toDisplayString(unref(t)("wallet.summary.token.hover.ownedAmount")), 1)
                      ]),
                      _: 1
                    })
                  ])
                ])) : (openBlock(), createElementBlock("div", _hoisted_18, "  "))
              ]),
              ((_f = (_e = assetInfo.value) == null ? void 0 : _e.tr) == null ? void 0 : _f.ds) ? (openBlock(), createElementBlock("div", _hoisted_19, toDisplayString(unref(truncateString)(((_h = (_g = assetInfo.value) == null ? void 0 : _g.tr) == null ? void 0 : _h.ds) ?? "", 65)), 1)) : createCommentVNode("", true)
            ])
          ]),
          __props.advancedViewEnabled && !isADA.value ? (openBlock(), createElementBlock("div", _hoisted_20, [
            createBaseVNode("div", _hoisted_21, [
              createVNode(GridSpace, {
                hr: "",
                class: "w-full mb-2"
              }),
              createBaseVNode("div", _hoisted_22, [
                createVNode(_sfc_main$g, {
                  "label-hover": unref(t)("wallet.summary.button.copy.token.fingerprint.hover"),
                  "notification-text": unref(t)("wallet.summary.button.copy.token.fingerprint.notify"),
                  "copy-text": fingerprint.value,
                  class: "mr-1"
                }, null, 8, ["label-hover", "notification-text", "copy-text"]),
                createVNode(_sfc_main$h, {
                  subject: { policy: __props.token.p, name: __props.token.t.a, fingerprint: fingerprint.value },
                  type: "token",
                  label: fingerprint.value,
                  "label-c-s-s": "w-full",
                  truncate: ""
                }, null, 8, ["subject", "label"])
              ]),
              ((_i = assetInfo.value) == null ? void 0 : _i.ts) ? (openBlock(), createElementBlock("div", _hoisted_23, [
                createBaseVNode("div", _hoisted_24, toDisplayString(unref(t)("wallet.summary.token.totalSupply")) + ":", 1),
                createVNode(_sfc_main$d, {
                  "text-c-s-s": "w-full",
                  amount: assetInfo.value.ts,
                  decimals: decimals.value,
                  currency: ""
                }, null, 8, ["amount", "decimals"])
              ])) : createCommentVNode("", true)
            ]),
            createBaseVNode("div", _hoisted_25, [
              createVNode(GridSpace, {
                hr: "",
                label: unref(t)("wallet.summary.token.sectionlabel.policyname"),
                "align-label": "left",
                class: "my-2"
              }, null, 8, ["label"]),
              createBaseVNode("div", _hoisted_26, [
                createBaseVNode("div", _hoisted_27, toDisplayString(unref(t)("wallet.summary.token.policyId")) + ":", 1),
                createVNode(_sfc_main$g, {
                  label: __props.token.p,
                  "label-c-s-s": " w-full truncate",
                  "label-hover": unref(t)("wallet.summary.button.copy.token.policyid.hover") + "<br/>" + __props.token.p,
                  "notification-text": unref(t)("wallet.summary.button.copy.token.policyid.notify"),
                  "copy-text": __props.token.p,
                  class: "mr-1"
                }, null, 8, ["label", "label-hover", "notification-text", "copy-text"])
              ]),
              __props.token.t.a.length > 0 ? (openBlock(), createElementBlock("div", _hoisted_28, [
                createBaseVNode("div", _hoisted_29, toDisplayString(unref(t)("wallet.summary.token.assetName")) + ":", 1),
                createVNode(_sfc_main$g, {
                  label: __props.token.t.a,
                  "label-c-s-s": "w-full truncate",
                  "label-hover": unref(t)("wallet.summary.button.copy.token.assetname.hover") + "<br/>" + __props.token.t.a,
                  "notification-text": unref(t)("wallet.summary.button.copy.token.assetname.notify"),
                  "copy-text": __props.token.t.a,
                  class: "mr-1"
                }, null, 8, ["label", "label-hover", "notification-text", "copy-text"])
              ])) : createCommentVNode("", true)
            ])
          ])) : createCommentVNode("", true)
        ], 2),
        __props.sendEnabled ? (openBlock(), createElementBlock("div", _hoisted_30, [
          __props.sendEnabled && __props.advancedViewEnabled ? (openBlock(), createBlock(GridSpace, {
            key: 0,
            hr: "",
            class: "mb-1"
          })) : createCommentVNode("", true),
          createBaseVNode("div", {
            class: "flex flex-row flex-nowrap items-start justify-end",
            onClick: _cache[4] || (_cache[4] = withModifiers(() => {
            }, ["stop"]))
          }, [
            __props.sendEnabled && !selected.value && (__props.disableAmountCheck || compare(__props.token.t.q, ">", "1")) ? (openBlock(), createBlock(GridInput, {
              key: 0,
              "input-text": tokenInput.value,
              "onUpdate:inputText": validateTokenInput,
              "input-error": tokenInputError.value,
              "onUpdate:inputError": _cache[3] || (_cache[3] = ($event) => tokenInputError.value = $event),
              onEnter: onAddToken,
              onReset: onTokenInputReset,
              "input-hint": tokenInputHint.value,
              alwaysShowInfo: false,
              showReset: !__props.sendReadOnly && !!assetInfo.value,
              "input-id": fingerprint.value,
              autocomplete: "off",
              currency: "",
              "decimal-separator": decimalSeparator.value,
              "group-separator": groupSeparator.value,
              "input-disabled": __props.sendReadOnly || !assetInfo.value,
              "manual-update": manualUpdate.value,
              "manual-update-auto-select": __props.manualUpdateAutoSelect,
              class: "mt-1"
            }, {
              "icon-append": withCtx(() => [
                assetInfo.value === void 0 ? (openBlock(), createElementBlock("div", _hoisted_31, [
                  createVNode(QSpinnerTail_default, {
                    color: "gray",
                    size: "26px",
                    class: "absolute -right-1 z-10"
                  }),
                  _cache[7] || (_cache[7] = createBaseVNode("i", { class: "text-lg cc-text-yellow mdi mdi-alert-circle-outline" }, null, -1)),
                  createVNode(_sfc_main$e, {
                    anchor: "bottom middle",
                    "transition-show": "scale",
                    "transition-hide": "scale"
                  }, {
                    default: withCtx(() => [
                      createTextVNode(toDisplayString(unref(t)("wallet.summary.token.hover.nometa")), 1)
                    ]),
                    _: 1
                  })
                ])) : !__props.disableAmountCheck && !__props.sendReadOnly ? (openBlock(), createElementBlock("button", {
                  key: 1,
                  onClick: withModifiers(onAddAllTokens, ["stop"]),
                  class: "cc-text-semi-bold ml-1 cc-btn-secondary-inline py-1 px-3 focus:outline-none"
                }, toDisplayString(unref(t)("wallet.send.step.assets.token.all")), 1)) : createCommentVNode("", true)
              ]),
              _: 1
            }, 8, ["input-text", "input-error", "input-hint", "showReset", "input-id", "decimal-separator", "group-separator", "input-disabled", "manual-update", "manual-update-auto-select"])) : createCommentVNode("", true),
            __props.sendEnabled && !__props.sendReadOnly && !__props.autoSubmit && !selected.value ? (openBlock(), createBlock(_sfc_main$j, {
              key: 1,
              label: unref(t)("wallet.send.step.assets.button.token.add"),
              "label-c-s-s": "h-11 mt-1 ml-2 px-4 py-2",
              link: onAddToken,
              disabled: !validTokenValue.value
            }, null, 8, ["label", "disabled"])) : createCommentVNode("", true),
            !__props.disabled && __props.sendEnabled && !__props.sendReadOnly && !__props.autoSubmit && selected.value ? (openBlock(), createBlock(_sfc_main$j, {
              key: 2,
              color: "red",
              "label-c-s-s": "h-11 mt-1 ml-2 px-4 py-2",
              label: unref(t)("wallet.send.step.assets.button.token.remove"),
              link: onRemoveToken
            }, null, 8, ["label"])) : createCommentVNode("", true)
          ])
        ])) : __props.simpleSelect ? (openBlock(), createElementBlock("div", _hoisted_32, [
          createBaseVNode("div", {
            class: "w-full cursor-pointer p-1 text-center rounded cc-tabs-button",
            onClick: _cache[5] || (_cache[5] = withModifiers(($event) => _ctx.$emit("addAsset", { p: props.token.p, t: props.token.t, a: "" }), ["stop"]))
          }, toDisplayString(unref(t)("wallet.send.step.assets.button.token.select")), 1)
        ])) : createCommentVNode("", true)
      ], 2);
    };
  }
});
const _hoisted_1$1 = { class: "w-full flex flex-col flex-nowrap truncate" };
const _hoisted_2$1 = { class: "cc-text-md cc-text-semi-bold" };
const _hoisted_3$1 = { class: "w-full flex flex-row flex-nowrap truncate cc-text-xs" };
const _hoisted_4$1 = {
  class: /* @__PURE__ */ normalizeClass(["cc-grid"])
};
const _hoisted_5$1 = {
  key: 0,
  class: "col-span-12 flex justify-center py-1"
};
const _hoisted_6$1 = { class: "relative cc-shadow cc-rounded py-2 px-4" };
const _hoisted_7$1 = {
  key: 1,
  class: "col-span-12 flex flex-row flex-nowrap justify-center cc-text-sz"
};
const itemsOnPage$1 = 12;
const _sfc_main$1 = /* @__PURE__ */ defineComponent({
  __name: "GridTokenCollection",
  props: {
    textId: { type: String, required: false, default: "wallet.summary.token" },
    tokenCollection: { type: Object, required: true },
    tokenSelectedList: { type: Array, required: false, default: [] },
    sendEnabled: { type: Boolean, required: true, default: false },
    simpleSelect: { type: Boolean, required: false, default: false },
    expanded: { type: Boolean, default: false },
    advancedView: { type: Boolean, default: false },
    milkomedaView: { type: Boolean, required: false, default: false },
    showVerified: { type: Boolean, required: false, default: false },
    maxCols: { type: Number, required: false, default: 3 },
    disabled: { type: Boolean, required: false, default: false }
  },
  emits: ["addAsset", "delAsset", "assetInfoUpd"],
  setup(__props, { emit: __emit }) {
    const props = __props;
    const emit = __emit;
    const { t } = useTranslation();
    const showFullCollection = ref(props.expanded);
    const onAddAsset = (e) => emit("addAsset", e);
    const onDelAsset = (e) => emit("delAsset", e);
    const currentPage = ref(1);
    const showPagination = computed(() => props.tokenCollection.l.length > itemsOnPage$1);
    const currentPageStart = computed(() => (currentPage.value - 1) * itemsOnPage$1);
    const maxPages = computed(() => Math.ceil(props.tokenCollection.l.length / itemsOnPage$1));
    const tokenCollectionPaged = computed(() => {
      return {
        p: props.tokenCollection.p,
        c: true,
        l: showFullCollection.value ? props.tokenCollection.l.slice(currentPageStart.value, currentPageStart.value + itemsOnPage$1) : props.tokenCollection.l.slice(0, 3)
      };
    });
    function onAssetInfoUpd(_assetInfo) {
      emit("assetInfoUpd", _assetInfo);
    }
    watch(() => props.expanded, (newValue) => showFullCollection.value = newValue);
    return (_ctx, _cache) => {
      var _a;
      return openBlock(), createElementBlock(Fragment, null, [
        createBaseVNode("div", {
          class: normalizeClass(["col-span-12 w-full relative overflow-hidden flex-1 flex flex-row flex-nowrap justify-center items-start", __props.tokenCollection.l.length > 3 ? "cursor-pointer" : ""]),
          onClick: _cache[0] || (_cache[0] = withModifiers(($event) => {
            showFullCollection.value = !showFullCollection.value;
            currentPage.value = 1;
          }, ["stop"]))
        }, [
          __props.tokenCollection.l.length > 2 ? (openBlock(), createBlock(_sfc_main$e, {
            key: 0,
            anchor: "top middle",
            offset: [0, 0],
            "transition-show": "scale",
            "transition-hide": "scale"
          }, {
            default: withCtx(() => [
              createTextVNode(toDisplayString(unref(t)("wallet.summary.button.token." + (showFullCollection.value ? "collapse" : "expand"))), 1)
            ]),
            _: 1
          })) : createCommentVNode("", true),
          createBaseVNode("i", {
            class: normalizeClass(["row-span-2 text-xl text-gray-400", __props.tokenCollection.l.length <= 3 ? "" : showFullCollection.value ? "pr-2 lg:pr-4 mdi mdi-chevron-down" : "pr-2 lg:pr-4 mdi mdi-chevron-right"])
          }, null, 2),
          createBaseVNode("div", _hoisted_1$1, [
            createBaseVNode("div", _hoisted_2$1, toDisplayString(unref(t)("wallet.summary.token.sectionlabel.tokenCollection")) + " (" + toDisplayString(__props.tokenCollection.l.length) + ")", 1),
            createBaseVNode("div", _hoisted_3$1, [
              _cache[3] || (_cache[3] = createBaseVNode("div", { class: "cc-text-semi-bold pr-2" }, "Policy:", -1)),
              createVNode(_sfc_main$g, {
                label: __props.tokenCollection.p,
                "label-c-s-s": "cc-addr truncate",
                "label-hover": unref(t)("wallet.summary.button.copy.token.policyid.hover") + "<br/>" + __props.tokenCollection.p,
                "notification-text": unref(t)("wallet.summary.button.copy.token.policyid.notify"),
                "copy-text": __props.tokenCollection.p,
                class: "mr-1"
              }, null, 8, ["label", "label-hover", "notification-text", "copy-text"])
            ])
          ])
        ], 2),
        createBaseVNode("div", _hoisted_4$1, [
          (openBlock(true), createElementBlock(Fragment, null, renderList(((_a = tokenCollectionPaged.value) == null ? void 0 : _a.l) ?? [], (token) => {
            return openBlock(), createBlock(_sfc_main$2, {
              key: token.f,
              token: __props.tokenSelectedList.find((ts) => ts.p === __props.tokenCollection.p && ts.t.a === token.t.a) ?? { p: __props.tokenCollection.p, t: token.t },
              fingerprint: token.f,
              "send-enabled": __props.sendEnabled,
              "simple-select": __props.simpleSelect,
              advancedViewEnabled: __props.advancedView,
              "check-milkomeda-min-amount": __props.milkomedaView,
              "show-verified": __props.showVerified,
              "max-cols": __props.maxCols,
              disabled: __props.disabled,
              onAssetInfoUpd,
              onAddAsset,
              onDelAsset
            }, null, 8, ["token", "fingerprint", "send-enabled", "simple-select", "advancedViewEnabled", "check-milkomeda-min-amount", "show-verified", "max-cols", "disabled"]);
          }), 128))
        ]),
        showPagination.value && showFullCollection.value ? (openBlock(), createElementBlock("div", _hoisted_5$1, [
          createBaseVNode("div", _hoisted_6$1, [
            createVNode(QPagination_default, {
              modelValue: currentPage.value,
              "onUpdate:modelValue": _cache[1] || (_cache[1] = ($event) => currentPage.value = $event),
              max: maxPages.value,
              "max-pages": 6,
              "boundary-numbers": "",
              flat: "",
              color: "teal-90",
              "text-color": "teal-90",
              "active-color": "teal-90",
              "active-text-color": "teal-90",
              "active-design": "unelevated"
            }, null, 8, ["modelValue", "max"])
          ])
        ])) : createCommentVNode("", true),
        __props.tokenCollection.l.length > 3 ? (openBlock(), createElementBlock("div", _hoisted_7$1, [
          createBaseVNode("span", {
            class: "block text-center cc-area-highlight cc-text-medium px-3 py-1 rounded cursor-pointer w-36",
            onClick: _cache[2] || (_cache[2] = withModifiers(($event) => {
              showFullCollection.value = !showFullCollection.value;
              currentPage.value = 1;
            }, ["stop"]))
          }, toDisplayString(showFullCollection.value ? "Show less" : "Show all"), 1)
        ])) : createCommentVNode("", true)
      ], 64);
    };
  }
});
const _hoisted_1 = {
  key: 0,
  class: "col-span-12 grid cc-gap grid-cols-12"
};
const _hoisted_2 = { class: "col-span-12 flex flex-col space-y-2 lg:space-y-0 lg:flex-row flex-nowrap justify-between" };
const _hoisted_3 = { class: "flex flex-col sm:flex-row flex-nowrap" };
const _hoisted_4 = {
  key: 0,
  class: "flex flex-row justify-between"
};
const _hoisted_5 = { class: "flex flex-row justify-between" };
const _hoisted_6 = { class: "col-span-12 flex flex-col xs:flex-row flex-nowrap items-end" };
const _hoisted_7 = { class: "text-xs opacity-50" };
const _hoisted_8 = { class: "col-span-12 mb-2 flex justify-center" };
const _hoisted_9 = {
  key: 3,
  class: "cc-grid cc-text-sz"
};
const _hoisted_10 = { class: "col-span-12 mt-2 flex justify-center" };
const _hoisted_11 = {
  key: 1,
  class: "col-span-12"
};
const itemsOnPage = 12;
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "GridTokenList",
  props: {
    textId: { type: String, required: false, default: "wallet.summary.token" },
    multiAsset: { type: Object, required: true },
    tokenSelectedList: { type: Array, required: false, default: [] },
    filterBySelected: { type: Boolean, required: false, default: false },
    sendEnabled: { type: Boolean, required: true, default: false },
    simpleSelect: { type: Boolean, required: false, default: false },
    singleEntry: { type: Boolean, required: false, default: false },
    milkomedaView: { type: Boolean, required: false, default: false },
    verifiedOnly: { type: Boolean, required: false, default: false },
    isModal: { type: Boolean, required: false, default: false },
    isExternal: { type: Boolean, required: false, default: false },
    maxCols: { type: Number, required: false, default: 3 },
    disabled: { type: Boolean, required: false, default: false }
  },
  emits: ["addAsset", "delAsset", "assetReset", "assetInfoUpd"],
  setup(__props, { emit: __emit }) {
    const props = __props;
    const emit = __emit;
    const { t } = useTranslation();
    const assetCnt = computed(() => !props.isExternal ? accAssetInfoCnt.value : Object.values(props.multiAsset).reduce((p, n) => p + Object.keys(n).length, 0));
    const optionsType = reactive([
      { id: "all", label: t("common.label.all"), index: 0 },
      { id: "ft", label: t("common.label.ft"), hover: t("common.label.ftlong"), index: 1 },
      { id: "nft", label: t("common.label.nft"), hover: t("common.label.nftlong"), index: 2 }
    ]);
    const filterType = ref(0);
    function onTypeFilter(index) {
      filterType.value = index;
      filterAssetsOnSearch();
    }
    function onVerifiedFilter() {
      filterAssetsOnSearch();
    }
    const verified = ref(props.verifiedOnly);
    const toggleAdvance = ref(getAdvancedTokenView());
    const searchInput = ref("");
    const ignoreUpdate = ref(false);
    const searchInputError = ref("");
    const filteredResult = ref(false);
    const searchRunning = ref(false);
    const _sortedAssetList = ref([]);
    const filteredAssetList = ref([]);
    const _collectionCount = ref(0);
    const _assetCount = ref(0);
    let searchValues = [];
    watch(toggleAdvance, (newStatus) => setAdvancedTokenView(newStatus));
    const currentPage = ref(1);
    const showPagination = computed(() => filteredAssetList.value.length > itemsOnPage);
    const currentPageStart = computed(() => {
      return (currentPage.value - 1) * itemsOnPage;
    });
    const maxPages = computed(() => Math.ceil(filteredAssetList.value.length / itemsOnPage));
    watch(filteredAssetList, () => {
      if (currentPage > maxPages) currentPage.value = 1;
    });
    const assetListPaged = computed(() => filteredAssetList.value.slice(currentPageStart.value, currentPageStart.value + itemsOnPage));
    const countStr = computed(() => t(props.textId + ".count.label").replace("###count###", _assetCount.value.toString()).replace(
      "###collections###",
      _collectionCount.value > 0 ? t(props.textId + ".count.collections").replace("###count###", _collectionCount.value.toString()) : ""
    ));
    const milkomedaData = ref(null);
    const onAddAsset = (e) => {
      emit("addAsset", e);
    };
    const onDelAsset = (e) => {
      emit("delAsset", e);
    };
    function onClearAllSelectedAssets() {
      emit("delAsset");
      resetFilter();
      filterAssetsOnSearch();
    }
    function onAddAllFilteredAssets() {
      update(filteredAssetList.value);
    }
    function onAddAllAssetsOnPage() {
      update(assetListPaged.value);
    }
    function update(list) {
      const assetAddList = [];
      const assetRemoveList = [];
      const tokenSelectedList = props.tokenSelectedList ?? [];
      for (const entry of list) {
        for (const item of entry.l) {
          const selected = tokenSelectedList.find((_item) => _item.p === entry.p && _item.t.a === item.t.a);
          if (selected) {
            const rest = subtract(selected.t.q, item.t.q);
            if (isLessThanZero(rest)) {
              assetRemoveList.push({
                p: entry.p,
                t: item.t,
                a: rest
              });
            } else if (isGreaterThanZero(rest)) {
              assetAddList.push({
                p: entry.p,
                t: item.t,
                a: rest
              });
            }
          } else {
            assetAddList.push({
              p: entry.p,
              t: item.t,
              a: item.t.q
            });
          }
        }
      }
      if (assetAddList.length > 0) {
        emit("addAsset", assetAddList);
      }
      if (assetRemoveList.length > 0) {
        emit("delAsset", assetRemoveList);
      }
    }
    function validateSearchInput() {
      searchInputError.value = "";
      if (searchInput.value.length > 0 && searchInput.value.length < 3) {
        searchInputError.value = t(props.textId + ".search.error.length");
      }
    }
    function assetSearchFilter(item) {
      return searchValues.some((s) => item.t.a === s || item.f === s || item.n.toLowerCase().includes(s));
    }
    function assetInfoSearchFilter(i) {
      return searchValues.some((s) => {
        var _a, _b, _c, _d, _e;
        return ((_a = i.n) == null ? void 0 : _a.toLowerCase().includes(s)) || ((_c = (_b = i.tr) == null ? void 0 : _b.ds) == null ? void 0 : _c.toLowerCase().includes(s)) || ((_e = (_d = i.tr) == null ? void 0 : _d.t) == null ? void 0 : _e.toLowerCase().includes(s)) || i.mt.some((mt) => mt.includes(s));
      });
    }
    function assetInfoTypeFilter(i, isNFT) {
      return isNFT ? i.ts === "1" : i.ts !== "1";
    }
    function doAssetInfoSearch() {
      const matches = [];
      const list = !props.isExternal ? accAssetInfoMap.value : swapAssetInfoMap.value;
      for (const item of Object.entries(list)) {
        for (const asset of item[1]) {
          try {
            if (assetInfoSearchFilter(asset)) {
              matches.push(`${item[0]}${asset.h}`);
            }
          } catch (err) {
            console.error(err, asset);
          }
        }
      }
      return matches;
    }
    function doAssetInfoType(isNFT) {
      const matches = [];
      const list = !props.isExternal ? accAssetInfoMap.value : swapAssetInfoMap.value;
      for (const item of Object.entries(list)) {
        for (const asset of item[1]) {
          if (assetInfoTypeFilter(asset, isNFT)) {
            matches.push(`${item[0]}${asset.h}`);
          }
        }
      }
      return matches;
    }
    watch(() => props.filterBySelected, () => filterAssetsOnSearch());
    function filterSortedAssetListOnSelected() {
      if (!props.filterBySelected) {
        return _sortedAssetList.value;
      }
      const tmpList = [];
      props.tokenSelectedList.sort((a, b) => a.p.localeCompare(b.p, "en-US"));
      let currentItem = {
        p: "",
        c: false,
        l: []
      };
      for (const selectedAsset of props.tokenSelectedList) {
        const policy = _sortedAssetList.value.find((item) => item.p === selectedAsset.p);
        if (policy) {
          const asset = policy.l.find((a) => a.t.a === selectedAsset.t.a);
          if (asset) {
            if (policy.p === currentItem.p) {
              currentItem.l.push(asset);
            } else {
              if (currentItem.p) {
                tmpList.push(currentItem);
              }
              currentItem = {
                p: policy.p,
                c: false,
                l: [asset]
              };
            }
          }
        }
      }
      if (currentItem.p) {
        tmpList.push(currentItem);
      }
      return tmpList;
    }
    function filterSortedAssetListOnType(list) {
      if (filterType.value === 0) {
        return list;
      }
      const tmpList = [];
      const assetsFiltered = doAssetInfoType(filterType.value === 2);
      for (const item of list) {
        const tmpList2 = item.l.filter((i) => assetsFiltered.includes(`${item.p}${i.t.a}`));
        if (tmpList2.length > 0) {
          tmpList.push({
            p: item.p,
            c: item.c,
            l: tmpList2
          });
        }
      }
      return tmpList;
    }
    function filterAssetListOnVerified(list) {
      if (!verified.value) {
        return list;
      }
      const tmpList = [];
      for (const item of list) {
        if (item.p.length === 0 || item.p === ".") {
          tmpList.push(item);
        }
        const tmpList2 = item.l.filter((d) => !isScamAsset(item.p, d.t.a) && getAssetStatus(item.p, d.t.a) === "verified");
        if (tmpList2.length > 0) {
          tmpList.push({
            p: item.p,
            c: item.c,
            l: tmpList2
          });
        }
      }
      return tmpList;
    }
    function filterAssetsOnSearch() {
      validateSearchInput();
      if (searchInput.value.length !== 0 && searchInputError.value.length === 0) {
        filteredResult.value = true;
        updateFilteredAssetsOnSearch(searchInput.value);
      } else {
        filteredResult.value = false;
        filteredAssetList.value = filterAssetListOnVerified(
          filterSortedAssetListOnType(
            filterSortedAssetListOnSelected()
          )
        );
      }
      searchRunning.value = false;
    }
    async function filterMilkomeda() {
      if (!milkomedaData.value) {
        return;
      }
      const spliceElements = [];
      for (let i = 0; i < filteredAssetList.value.length; i++) {
        const token = filteredAssetList.value[i];
        if (!await isMilkomedaToken(token, milkomedaData.value)) {
          spliceElements.push(i);
        }
      }
      for (let removeIndex = spliceElements.length - 1; removeIndex >= 0; removeIndex--) {
        filteredAssetList.value.splice(spliceElements[removeIndex], 1);
      }
    }
    function updateFilteredAssetsOnSearch(searchStr) {
      if (searchStr.trim().length === 0) {
        filteredAssetList.value = [..._sortedAssetList.value];
        return;
      }
      searchValues = searchStr.toLowerCase().split(";").map((item) => item.trim()).filter(Boolean);
      const _filteredAssetList = [];
      const baseAssetList = filterAssetListOnVerified(
        filterSortedAssetListOnType(
          filterSortedAssetListOnSelected()
        )
      );
      const assetsFiltered = doAssetInfoSearch();
      for (const item of baseAssetList) {
        if (searchValues.includes(item.p)) {
          _filteredAssetList.push(item);
          break;
        }
        const tmpList = item.l.filter((d) => assetSearchFilter(d) || assetsFiltered.includes(`${item.p}${d.t.a}`));
        if (tmpList.length > 0) {
          _filteredAssetList.push({
            p: item.p,
            c: item.c,
            l: tmpList
          });
        }
      }
      filteredAssetList.value = _filteredAssetList;
    }
    function resetFilter() {
      searchInput.value = "";
      emit("assetReset");
    }
    function onAssetInfoUpd(_assetInfo) {
      emit("assetInfoUpd", _assetInfo);
    }
    let tuft = -1;
    watch(searchInput, () => {
      if (ignoreUpdate.value) {
        ignoreUpdate.value = false;
        return;
      }
      clearTimeout(tuft);
      searchRunning.value = true;
      tuft = setTimeout(() => {
        filterAssetsOnSearch();
        emit("assetReset");
      }, searchInput.value.length === 0 ? 0 : 300);
    });
    function getCardToken(item) {
      var _a;
      return ((_a = props.tokenSelectedList) == null ? void 0 : _a.find((ts) => ts.p === item.p && ts.t.a === item.l[0].t.a)) ?? { p: item.p, t: item.l[0].t };
    }
    onMounted(async () => {
      watch(() => props.multiAsset, (newValue, oldValue) => {
        if (JSON.stringify(newValue) === JSON.stringify(oldValue)) {
          return;
        }
        const listIsFiltered = _sortedAssetList.value !== filteredAssetList.value;
        const {
          assetList,
          assetCount,
          collectionCount
        } = getSortedAssetList(props.multiAsset);
        _assetCount.value = assetCount;
        _collectionCount.value = collectionCount;
        _sortedAssetList.value = assetList;
        if (!listIsFiltered || currentPage.value === 1) {
          filteredAssetList.value = filterAssetListOnVerified(_sortedAssetList.value);
        }
      }, { immediate: true });
      if (props.milkomedaView) {
        const config = await getMilkomedaData(networkId.value);
        if (config) {
          milkomedaData.value = config.config;
          await filterMilkomeda();
        }
      }
    });
    return (_ctx, _cache) => {
      return _sortedAssetList.value.length > 0 ? (openBlock(), createElementBlock("div", _hoisted_1, [
        createBaseVNode("div", _hoisted_2, [
          createVNode(_sfc_main$c, {
            text: countStr.value,
            class: "truncate"
          }, null, 8, ["text"]),
          createBaseVNode("div", _hoisted_3, [
            !__props.disabled ? (openBlock(), createElementBlock("div", _hoisted_4, [
              __props.tokenSelectedList && __props.tokenSelectedList.length > 0 && !__props.singleEntry ? (openBlock(), createBlock(_sfc_main$9, {
                key: 0,
                class: "grow px-4 sm:ml-2 h-10",
                label: unref(t)("wallet.send.step.assets.button.token.reset"),
                link: onClearAllSelectedAssets
              }, null, 8, ["label"])) : createCommentVNode("", true),
              __props.sendEnabled && assetListPaged.value.length > 0 && !__props.singleEntry ? (openBlock(), createBlock(GridButtonSecondary, {
                key: 1,
                class: normalizeClass(["grow px-4 h-10", __props.tokenSelectedList && __props.tokenSelectedList.length > 0 && !__props.singleEntry ? "ml-2" : ""]),
                label: unref(t)("wallet.send.step.assets.button.token.addpage"),
                link: onAddAllAssetsOnPage
              }, null, 8, ["class", "label"])) : createCommentVNode("", true),
              __props.sendEnabled && assetListPaged.value.length > 0 && !__props.singleEntry ? (openBlock(), createBlock(GridButtonSecondary, {
                key: 2,
                class: "grow px-4 ml-2 h-10",
                label: unref(t)("wallet.send.step.assets.button.token." + (filteredResult.value ? "addsearch" : "addall")),
                link: onAddAllFilteredAssets
              }, null, 8, ["label"])) : createCommentVNode("", true)
            ])) : createCommentVNode("", true),
            createBaseVNode("div", _hoisted_5, [
              createVNode(QToggle_default, {
                class: "grow sm:ml-4",
                modelValue: toggleAdvance.value,
                "onUpdate:modelValue": _cache[0] || (_cache[0] = ($event) => toggleAdvance.value = $event),
                "left-label": "",
                label: toggleAdvance.value ? unref(t)("common.label.detailedmode") : unref(t)("common.label.simplemode"),
                value: unref(getAdvancedTokenView)
              }, null, 8, ["modelValue", "label", "value"]),
              __props.verifiedOnly ? (openBlock(), createBlock(QToggle_default, {
                key: 0,
                class: "grow",
                modelValue: verified.value,
                "onUpdate:modelValue": [
                  _cache[1] || (_cache[1] = ($event) => verified.value = $event),
                  onVerifiedFilter
                ],
                "left-label": "",
                label: unref(t)("common.label.verifiedmode")
              }, null, 8, ["modelValue", "label"])) : createCommentVNode("", true)
            ])
          ])
        ]),
        __props.milkomedaView ? (openBlock(), createBlock(GridSpace, {
          key: 0,
          hr: "",
          class: "col-span-12 my-0.5 sm:my-2"
        })) : createCommentVNode("", true),
        __props.milkomedaView ? (openBlock(), createBlock(_sfc_main$c, {
          key: 1,
          class: "break-words",
          text: _sortedAssetList.value.length === 0 ? unref(t)(__props.textId + ".milkomeda.noAssetsOnMainnet") : unref(t)(__props.textId + ".milkomeda.filtered")
        }, null, 8, ["text"])) : createCommentVNode("", true),
        __props.milkomedaView ? (openBlock(), createBlock(GridSpace, {
          key: 2,
          hr: "",
          class: "col-span-12 my-0.5 sm:my-2"
        })) : createCommentVNode("", true),
        createBaseVNode("div", _hoisted_6, [
          createVNode(GridInput, {
            class: "col-span-12 mb-2",
            "input-text": searchInput.value,
            "onUpdate:inputText": _cache[2] || (_cache[2] = ($event) => searchInput.value = $event),
            "input-error": searchInputError.value,
            "onUpdate:inputError": _cache[3] || (_cache[3] = ($event) => searchInputError.value = $event),
            onLostFocus: validateSearchInput,
            onReset: resetFilter,
            label: unref(t)(__props.textId + ".search.label"),
            "input-info": unref(t)(__props.textId + ".search.info"),
            "input-hint": unref(t)(__props.textId + ".search.hint"),
            showReset: "",
            autocomplete: "off",
            "input-id": "searchToken",
            "input-type": "text"
          }, {
            "icon-prepend": withCtx(() => [
              createVNode(IconPencil, { class: "h-5 w-5 dark:text-cc-dark-gra" })
            ]),
            "icon-append": withCtx(() => [
              searchRunning.value ? (openBlock(), createBlock(QSpinnerDots_default, {
                key: 0,
                color: "grey"
              })) : createCommentVNode("", true),
              assetCnt.value < _assetCount.value ? (openBlock(), createElementBlock("div", {
                key: 1,
                class: normalizeClass(["flex flex-row flex-nowrap items-center gap-2", searchRunning.value ? "ml-2" : ""])
              }, [
                createBaseVNode("span", _hoisted_7, "[ " + toDisplayString(assetCnt.value) + " / " + toDisplayString(_assetCount.value) + " ]", 1),
                createVNode(QSpinnerTail_default, { color: "gray" }),
                createVNode(_sfc_main$e, {
                  anchor: "center right",
                  self: "center left",
                  "transition-show": "scale",
                  "transition-hide": "scale"
                }, {
                  default: withCtx(() => [
                    createTextVNode(toDisplayString(unref(t)(__props.textId + ".fetch")), 1)
                  ]),
                  _: 1
                })
              ], 2)) : createCommentVNode("", true)
            ]),
            _: 1
          }, 8, ["input-text", "input-error", "label", "input-info", "input-hint"]),
          createBaseVNode("div", {
            class: normalizeClass(["ml-8 mb-0.5 mt-2 xs:mt-0 xs:pr-3", searchInputError.value ? "pb-7" : ""])
          }, [
            createVNode(_sfc_main$f, {
              tabs: optionsType,
              divider: false,
              onSelection: onTypeFilter,
              index: filterType.value,
              "reset-on-mount": ""
            }, {
              tab0: withCtx(() => _cache[6] || (_cache[6] = [])),
              tab1: withCtx(() => _cache[7] || (_cache[7] = [])),
              tab2: withCtx(() => _cache[8] || (_cache[8] = [])),
              _: 1
            }, 8, ["tabs", "index"])
          ], 2)
        ]),
        createBaseVNode("div", _hoisted_8, [
          showPagination.value ? (openBlock(), createBlock(QPagination_default, {
            key: 0,
            modelValue: currentPage.value,
            "onUpdate:modelValue": _cache[4] || (_cache[4] = ($event) => currentPage.value = $event),
            max: maxPages.value,
            "max-pages": 6,
            "boundary-numbers": "",
            flat: "",
            color: "teal-90",
            "text-color": "teal-90",
            "active-color": "teal-90",
            "active-text-color": "teal-90",
            "active-design": "unelevated"
          }, null, 8, ["modelValue", "max"])) : createCommentVNode("", true)
        ]),
        __props.tokenSelectedList ? (openBlock(), createElementBlock("div", _hoisted_9, [
          assetListPaged.value.length > 0 ? (openBlock(true), createElementBlock(Fragment, { key: 0 }, renderList(assetListPaged.value, (item, index) => {
            return openBlock(), createElementBlock("div", {
              key: item.p,
              class: normalizeClass(["", ["collection-container grid gap-2 col-span-12", item.c ? "" : __props.maxCols === 4 ? "sm:col-span-6 lg:col-span-4 xl:col-span-3" : "sm:col-span-4"]])
            }, [
              item.c && index !== 0 ? (openBlock(), createBlock(GridSpace, {
                key: 0,
                hr: "",
                class: "mt-1"
              })) : createCommentVNode("", true),
              item.c ? (openBlock(), createBlock(_sfc_main$1, {
                key: 1,
                "token-collection": item,
                "token-selected-list": __props.tokenSelectedList,
                "send-enabled": __props.sendEnabled,
                "simple-select": __props.simpleSelect,
                expanded: filteredResult.value,
                advancedView: toggleAdvance.value,
                "milkomeda-view": __props.milkomedaView,
                "show-verified": verified.value,
                "max-cols": __props.maxCols,
                disabled: __props.disabled,
                onAssetInfoUpd,
                onAddAsset,
                onDelAsset
              }, null, 8, ["token-collection", "token-selected-list", "send-enabled", "simple-select", "expanded", "advancedView", "milkomeda-view", "show-verified", "max-cols", "disabled"])) : (openBlock(), createBlock(_sfc_main$2, {
                key: 2,
                token: getCardToken(item),
                fingerprint: item.l[0].f,
                "send-enabled": __props.sendEnabled,
                "simple-select": __props.simpleSelect,
                advancedViewEnabled: toggleAdvance.value,
                "check-milkomeda-min-amount": __props.milkomedaView,
                "show-verified": verified.value,
                "max-cols": __props.maxCols,
                disabled: __props.disabled,
                onAssetInfoUpd,
                onAddAsset,
                onDelAsset
              }, null, 8, ["token", "fingerprint", "send-enabled", "simple-select", "advancedViewEnabled", "check-milkomeda-min-amount", "show-verified", "max-cols", "disabled"]))
            ], 2);
          }), 128)) : createCommentVNode("", true)
        ])) : createCommentVNode("", true),
        createBaseVNode("div", _hoisted_10, [
          showPagination.value ? (openBlock(), createBlock(QPagination_default, {
            key: 0,
            modelValue: currentPage.value,
            "onUpdate:modelValue": _cache[5] || (_cache[5] = ($event) => currentPage.value = $event),
            max: maxPages.value,
            "max-pages": 6,
            "boundary-numbers": "",
            flat: "",
            color: "teal-90",
            "text-color": "teal-90",
            "active-color": "teal-90",
            "active-text-color": "teal-90",
            "active-design": "unelevated"
          }, null, 8, ["modelValue", "max"])) : createCommentVNode("", true)
        ])
      ])) : (openBlock(), createElementBlock("div", _hoisted_11, toDisplayString(unref(t)(__props.textId + (filteredResult.value ? ".filterEmpty" : ".notokens"))), 1));
    };
  }
});
export {
  _sfc_main as _,
  _sfc_main$2 as a,
  _sfc_main$9 as b
};
