import { d as defineComponent, z as ref, o as openBlock, c as createElementBlock, n as normalizeClass, e as createBaseVNode, t as toDisplayString, u as unref, a as createBlock, c6 as getAssetIdBech32, j as createCommentVNode, h as withCtx, q as createVNode, ho as swapAssetInfoCnt, K as networkId, H as Fragment, D as watch, i as createTextVNode, cb as QToggle_default, ar as appLanguageTag, f as computed, c3 as isZero, eW as compare, b as withModifiers, Q as QSpinnerDots_default, B as useFormatter, cZ as multiply, hp as defaultSlippage, cI as divide, hq as getProvider, I as renderList, hr as round, P as normalizeStyle, a7 as useQuasar, C as onMounted, F as withDirectives, J as vShow, V as nextTick, ct as onErrorCaptured, hs as syncStartAI, ht as syncStartAI$1, hu as getSwapSettings, hv as formatAssetName, hw as getEternlFee, bm as dispatchSignal, hx as doInitSwap, aG as onUnmounted, aX as removeSignalListener, hy as onAccountDataUpdated, cf as getRandomId, ae as useSelectedAccount, hz as isEqualAssetList, hA as getAssetInfo, hB as getSwapAssetInfo, hC as getSwapAssetInfo$1, hD as selectBestPool, cG as subtract, hE as fetchSwapPools, hF as swapProviderList, c_ as add, bT as json, aW as addSignalListener, hG as onBuiltTxSwap, g3 as getTxBuiltErrorMsg, f_ as ErrorBuildTx, hH as doBuildTxSwap, hI as fetchSwapEstimate, hJ as getRootAddress, hK as createSwapOrder, gr as parseTxSignRequest, hL as getErrorMsg, hM as fetchSwapDatum, hN as setSwapSettings, hO as swapRouteList, hP as verifiedAssetMap, hQ as createISwapSettings, aP as sleep, hR as fetchAvgPrice, c5 as getAssetName, hS as onBuiltTxSwapCancel, hT as doBuildTxSwapCancel, hU as fetchLpInfo, hV as updateForBestPool, aH as QPagination_default, hW as onAccountListUpdated, hX as lastOrderUpdate, hY as openOrderList, hZ as isFetchingOrders, h_ as orderUpdateDelay, a2 as now, h$ as fetchOpenOrders, i0 as fetchOpenOrders$1, i1 as fetchEnabledAggList, i2 as fetchProviderList } from "./index.js";
import { u as useTranslation } from "./useTranslation.js";
import { q as isCreateSwapEnabled } from "./NetworkId.js";
import { u as useAdaSymbol } from "./useAdaSymbol.js";
import { _ as _sfc_main$b, a as _sfc_main$c } from "./GridHeadline.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$i } from "./GridTextArea.vue_vue_type_script_setup_true_lang.js";
import { G as GridSpace } from "./GridSpace.js";
import { _ as _sfc_main$g } from "./GridButtonPrimary.vue_vue_type_script_setup_true_lang.js";
import { a as _sfc_main$a, _ as _sfc_main$d, b as _sfc_main$h } from "./GridTokenList.vue_vue_type_script_setup_true_lang.js";
import { I as IconWarning } from "./IconWarning.js";
import { M as Modal } from "./Modal.js";
import { _ as _sfc_main$e } from "./Tooltip.vue_vue_type_script_setup_true_lang.js";
import { G as GridInput } from "./GridInput.js";
import { _ as _sfc_main$f } from "./FormattedAmount.vue_vue_type_script_setup_true_lang.js";
import { G as GridButtonSecondary } from "./GridButtonSecondary.js";
import { _ as _export_sfc } from "./_plugin-vue_export-helper.js";
import { _ as _sfc_main$l } from "./ExplorerLink.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$k } from "./CopyToClipboard.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$m } from "./GridButtonWarning.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$j } from "./GridTxListTokenDetails.vue_vue_type_script_setup_true_lang.js";
import "./GridButton.vue_vue_type_script_setup_true_lang.js";
import "./vue-json-pretty.js";
import "./IconPencil.js";
import "./GridTabs.vue_vue_type_script_setup_true_lang.js";
import "./useTabId.js";
import "./InlineButton.vue_vue_type_script_setup_true_lang.js";
import "./lz-string.js";
import "./image.js";
import "./ExtBackground.js";
import "./defaultLogo.js";
import "./IconError.js";
import "./useBalanceVisible.js";
import "./Clipboard.js";
const _hoisted_1$9 = { class: "w-full h-full flex justify-center items-center cc-text-lg cc-text-slate-0" };
const _hoisted_2$7 = { class: "grow-0 shrink-0 w-full flex flex-row flex-nowrap items-start justify-between border-b cc-p" };
const _hoisted_3$6 = { class: "flex flex-col cc-text-sz" };
const _hoisted_4$6 = { class: "flex flex-col flex-nowrap p-4 w-full" };
const _sfc_main$9 = /* @__PURE__ */ defineComponent({
  __name: "SwapInput",
  props: {
    textId: { type: String, required: true },
    availableAssets: { type: Object, required: true },
    selectedAsset: { type: Object, required: false },
    assetinfo: { type: null, required: false, default: null },
    isSource: { type: Boolean, required: true },
    disabled: { type: Boolean, required: false, default: false },
    showInput: { type: Boolean, required: false, default: true }
  },
  emits: ["select", "update", "inputError", "assetInfoUpd"],
  setup(__props, { emit: __emit }) {
    const emit = __emit;
    const { t } = useTranslation();
    const showAssetModal = ref(false);
    function onTokenSelect(token) {
      emit("select", token);
      showAssetModal.value = false;
    }
    function onTokenUpdate(token) {
      emit("update", token);
    }
    function onInputError(error) {
      emit("inputError", error);
    }
    function onAssetInfoUpd(_assetInfo) {
      emit("assetInfoUpd", _assetInfo);
    }
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock(Fragment, null, [
        !__props.selectedAsset ? (openBlock(), createElementBlock("div", {
          key: 0,
          class: normalizeClass(["cc-rounded cc-bg-light-0 px-3 pt-3 pb-3 min-h-20 h-full", __props.disabled ? "cc-tabs-button-static" : "cursor-pointer cc-tabs-button"]),
          onClick: _cache[0] || (_cache[0] = ($event) => __props.disabled ? false : showAssetModal.value = true)
        }, [
          createBaseVNode("span", _hoisted_1$9, toDisplayString(__props.disabled ? "" : unref(t)(__props.textId + ".clickselect")), 1)
        ], 2)) : (openBlock(), createElementBlock("div", {
          key: 1,
          class: normalizeClass(__props.disabled ? "" : "cursor-pointer"),
          onClick: _cache[1] || (_cache[1] = ($event) => __props.disabled ? false : showAssetModal.value = true)
        }, [
          __props.selectedAsset ? (openBlock(), createBlock(_sfc_main$a, {
            key: 0,
            class: "w-full pt-2 pb-1",
            token: { p: __props.selectedAsset.p, t: __props.selectedAsset.t },
            assetinfo: __props.assetinfo,
            fingerprint: unref(getAssetIdBech32)(__props.selectedAsset.p, __props.selectedAsset.t.a),
            "disable-details-modal": true,
            "send-enabled": __props.showInput,
            "auto-submit": true,
            "prefilled-input": __props.selectedAsset.a,
            advancedViewEnabled: false,
            "disable-amount-check": !__props.isSource,
            "manual-update-auto-select": false,
            "is-own-asset": __props.isSource,
            onAddAsset: onTokenUpdate,
            onInputError
          }, null, 8, ["token", "assetinfo", "fingerprint", "send-enabled", "prefilled-input", "disable-amount-check", "is-own-asset"])) : createCommentVNode("", true)
        ], 2)),
        showAssetModal.value ? (openBlock(), createBlock(Modal, {
          key: 2,
          "full-width-on-mobile": "",
          onClose: _cache[2] || (_cache[2] = ($event) => showAssetModal.value = false)
        }, {
          header: withCtx(() => [
            createBaseVNode("div", _hoisted_2$7, [
              createBaseVNode("div", _hoisted_3$6, [
                createVNode(_sfc_main$b, {
                  label: unref(t)(__props.textId + (__props.isSource ? ".from" : ".to") + ".title")
                }, null, 8, ["label"]),
                createVNode(_sfc_main$c, {
                  text: unref(t)(__props.textId + (__props.isSource ? ".from" : ".to") + ".caption")
                }, null, 8, ["text"])
              ])
            ])
          ]),
          content: withCtx(() => [
            createBaseVNode("div", _hoisted_4$6, [
              createVNode(_sfc_main$d, {
                "text-id": __props.textId + ".token",
                "multi-asset": __props.availableAssets,
                "single-entry": true,
                "send-enabled": false,
                "simple-select": true,
                "is-external": !__props.isSource,
                "verified-only": !__props.isSource && unref(swapAssetInfoCnt) !== 0 && unref(networkId) === "mainnet",
                "is-modal": "",
                onAssetInfoUpd,
                onAddAsset: onTokenSelect
              }, null, 8, ["text-id", "multi-asset", "is-external", "verified-only"])
            ])
          ]),
          _: 1
        })) : createCommentVNode("", true)
      ], 64);
    };
  }
});
const _hoisted_1$8 = { class: "col-span-12 flex flex-row flex-nowrap items-center" };
const _sfc_main$8 = /* @__PURE__ */ defineComponent({
  __name: "SwapSelection",
  props: {
    enabled: { type: Boolean, required: false, default: false }
  },
  emits: ["instant", "limit"],
  setup(__props, { emit: __emit }) {
    const props = __props;
    const emit = __emit;
    const { it } = useTranslation();
    const limitEnabled = ref(props.enabled);
    const setInstantOrder = () => {
      limitEnabled.value = false;
      emit("instant");
    };
    const setLimitOrder = () => {
      limitEnabled.value = true;
      emit("limit");
    };
    watch(limitEnabled, (isLimit) => isLimit ? setLimitOrder() : setInstantOrder());
    watch(() => props.enabled, (isLimit) => {
      if (isLimit && limitEnabled.value) {
        return;
      }
      isLimit ? setLimitOrder() : setInstantOrder();
    });
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", _hoisted_1$8, [
        createBaseVNode("div", {
          class: "flex flex-row flex-nowrap items-center cursor-pointer",
          onClick: _cache[0] || (_cache[0] = ($event) => {
            limitEnabled.value = false;
            _ctx.$emit("instant");
          })
        }, [
          createTextVNode(toDisplayString(unref(it)("wallet.swap.create.instant.label")) + " ", 1),
          createBaseVNode("i", {
            class: normalizeClass(["mdi mdi-flash-outline drop-shadow text-xl ml-1", limitEnabled.value ? "text-gray-700" : "text-green-700"])
          }, null, 2)
        ]),
        createVNode(QToggle_default, {
          modelValue: limitEnabled.value,
          "onUpdate:modelValue": _cache[1] || (_cache[1] = ($event) => limitEnabled.value = $event),
          color: "blue",
          "keep-color": ""
        }, null, 8, ["modelValue"]),
        createBaseVNode("div", {
          class: "flex flex-row flex-nowrap items-center cursor-pointer",
          onClick: _cache[2] || (_cache[2] = ($event) => {
            limitEnabled.value = true;
            _ctx.$emit("limit");
          })
        }, [
          createBaseVNode("i", {
            class: normalizeClass(["mdi mdi-chart-bell-curve text-xl mx-1", limitEnabled.value ? "text-green-700" : "text-gray-700"])
          }, null, 2),
          createTextVNode(" " + toDisplayString(unref(it)("wallet.swap.create.limit.label")), 1)
        ]),
        createVNode(_sfc_main$e, {
          anchor: "top middle",
          offset: [0, 30],
          "transition-show": "scale",
          "transition-hide": "scale"
        }, {
          default: withCtx(() => [
            createTextVNode(toDisplayString(!limitEnabled.value ? unref(it)("wallet.swap.create.instant.hover") : unref(it)("wallet.swap.create.limit.hover")), 1)
          ]),
          _: 1
        })
      ]);
    };
  }
});
const _hoisted_1$7 = { class: "w-full flex flex-col sm:flex-row flex-nowrap items-center cc-tabs-button-static cc-rounded px-2 py-1 space-y-2 sm:space-y-0 sm:space-x-4" };
const _hoisted_2$6 = { class: "w-full sm:w-auto flex-grow" };
const _hoisted_3$5 = { class: "flex flex-row cc-text-xs cc-text-light mr-1" };
const _hoisted_4$5 = { class: "ml-1" };
const _hoisted_5$4 = {
  key: 0,
  class: "mdi mdi-sync text-lg"
};
const _sfc_main$7 = /* @__PURE__ */ defineComponent({
  __name: "LimitOrder",
  props: {
    limitPrice: { type: String, required: true },
    marketPrice: { type: String, required: true },
    sourceMetadata: { type: Object, required: true },
    targetMetadata: { type: Object, required: true },
    sourceName: { type: String, required: true, default: "" },
    targetName: { type: String, required: true, default: "" },
    updatingPrice: { type: Boolean, required: true, default: false }
  },
  emits: ["priceUpdate", "priceReset"],
  setup(__props, { emit: __emit }) {
    const props = __props;
    const emit = __emit;
    useTranslation();
    const {
      formatAmountString,
      getNumberFormatSeparators,
      valueFromFormattedString,
      getDecimalNumber,
      getDisplayDecimals
    } = useFormatter();
    let formatSeparators = getNumberFormatSeparators();
    const decimalSeparator = ref(formatSeparators.decimal);
    const groupSeparator = ref(formatSeparators.group);
    watch(() => appLanguageTag, () => {
      formatSeparators = getNumberFormatSeparators();
      decimalSeparator.value = formatSeparators.decimal;
      groupSeparator.value = formatSeparators.group;
      onPriceInputReset();
    }, { deep: true });
    const priceInput = ref("");
    const priceInputError = ref("");
    const manualUpdate = ref(0);
    const decimalPrecision = computed(() => getDisplayDecimals(props.marketPrice));
    function updatePriceInput(amount) {
      if (isZero(amount)) {
        priceInputError.value = "Price can't be 0.";
      } else {
        priceInputError.value = "";
      }
      if (decimalPrecision.value > 0) {
        priceInput.value = formatAmountString(multiply(amount, getDecimalNumber(decimalPrecision.value)), decimalPrecision.value === 0, true, decimalPrecision.value, decimalPrecision.value);
      } else {
        priceInput.value = formatAmountString(multiply(amount, getDecimalNumber(decimalPrecision.value)), decimalPrecision.value === 0, true);
      }
      emit("priceUpdate", !isZero(amount) ? amount : null);
    }
    function validatePriceInput(value) {
      if (value) {
        const amount = valueFromFormattedString(value, decimalPrecision.value, true);
        updatePriceInput(amount.number);
      } else {
        priceInput.value = "";
        priceInputError.value = "";
        emit("priceUpdate", null);
      }
      manualUpdate.value += 1;
    }
    function onPriceInputReset() {
      if (!props.updatingPrice) {
        emit("priceReset");
      }
    }
    watch(() => props.limitPrice, (newPrice, oldPrice) => {
      const _oldPrice = valueFromFormattedString(oldPrice ?? "0", decimalPrecision.value, true).number;
      const _newPrice = valueFromFormattedString(newPrice ?? "0", decimalPrecision.value, true).number;
      if (isZero(_newPrice) || compare(_newPrice, "==", _oldPrice)) {
        return;
      }
      updatePriceInput(newPrice);
    });
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", _hoisted_1$7, [
        createBaseVNode("div", _hoisted_2$6, [
          createVNode(GridInput, {
            "input-text": priceInput.value,
            "onUpdate:inputText": validatePriceInput,
            "input-error": priceInputError.value,
            "onUpdate:inputError": _cache[0] || (_cache[0] = ($event) => priceInputError.value = $event),
            "input-hint": "0",
            alwaysShowInfo: false,
            showReset: false,
            "input-id": "limitprice",
            autocomplete: "off",
            currency: "",
            "decimal-separator": decimalSeparator.value,
            "group-separator": groupSeparator.value,
            "manual-update": manualUpdate.value,
            class: "my-1"
          }, {
            "icon-prepend": withCtx(() => _cache[1] || (_cache[1] = [
              createTextVNode(" Price: ")
            ])),
            "icon-append": withCtx(() => [
              createBaseVNode("div", _hoisted_3$5, [
                createBaseVNode("span", _hoisted_4$5, toDisplayString(__props.sourceName), 1),
                _cache[2] || (_cache[2] = createBaseVNode("span", { class: "mx-1" }, "/", -1)),
                createBaseVNode("span", null, toDisplayString(__props.targetName), 1)
              ]),
              createBaseVNode("button", {
                onClick: withModifiers(onPriceInputReset, ["stop"]),
                class: normalizeClass(["h-8 w-8 flex justify-center items-center cc-text-semi-bold ml-1 cc-btn-secondary-inline focus:outline-none", __props.updatingPrice ? "cursor-default" : ""])
              }, [
                !__props.updatingPrice ? (openBlock(), createElementBlock("i", _hoisted_5$4)) : (openBlock(), createBlock(QSpinnerDots_default, {
                  key: 1,
                  color: "gray",
                  size: "1em"
                }))
              ], 2)
            ]),
            _: 1
          }, 8, ["input-text", "input-error", "decimal-separator", "group-separator", "manual-update"])
        ])
      ]);
    };
  }
});
const _hoisted_1$6 = { class: "ml-1 cc-text-normal" };
const _hoisted_2$5 = { class: "ml-1 cc-text-normal" };
const _hoisted_3$4 = {
  key: 0,
  class: "flex flex-row"
};
const _hoisted_4$4 = { class: "ml-1" };
const _hoisted_5$3 = ["src", "alt"];
const _hoisted_6$3 = {
  key: 1,
  class: "capitalize ml-1"
};
const _hoisted_7$3 = {
  key: 1,
  class: "w-full cc-tabs-button cc-rounded px-2 py-1 flex flex-col cursor-zoom-out"
};
const _hoisted_8$3 = {
  key: 0,
  class: "mb-2 max-h-8 w-full flex flex-row flex-nowrap justify-center items-center cc-tabs-button-static cc-rounded px-2 cc-gap-lg"
};
const _hoisted_9$3 = { class: "w-full p-2 flex flex-col" };
const _hoisted_10$3 = { class: "relative w-full cc-flex-fixed inline-block mb-1" };
const _hoisted_11$3 = { class: "relative w-full px-1 py-0.5 cc-site-max-width mx-auto cc-rounded cc-shadow cc-online cc-text-bold text-center" };
const _hoisted_12$3 = { class: "relative flex flex-row justify-center items-center" };
const _hoisted_13$3 = {
  key: 0,
  class: "flex flex-row justify-center items-center"
};
const _hoisted_14$2 = { class: "ml-0.5 cc-text-normal" };
const _hoisted_15$2 = ["src", "alt"];
const _hoisted_16$2 = { class: "capitalize ml-2" };
const _hoisted_17$2 = {
  key: 0,
  class: "flex flex-row justify-between cc-text-color"
};
const _hoisted_18$2 = { class: "cc-text-slate-0" };
const _hoisted_19$2 = { class: "flex flex-row flex-nowrap" };
const _hoisted_20$2 = { class: "ml-1 cc-text-normal" };
const _hoisted_21$1 = { class: "flex flex-row justify-between cc-text-color" };
const _hoisted_22$1 = { class: "inline cc-text-slate-0" };
const _hoisted_23$1 = { class: "relative flex flex-row flex-nowrap" };
const _hoisted_24$1 = { class: "ml-1 cc-text-normal" };
const _hoisted_25 = { class: "ml-1 cc-text-normal" };
const _hoisted_26 = {
  key: 1,
  class: "flex flex-row justify-between cc-text-color"
};
const _hoisted_27 = { class: "cc-text-slate-0" };
const _hoisted_28 = { class: "flex flex-row flex-nowrap" };
const _hoisted_29 = {
  key: 2,
  class: "flex flex-row justify-between cc-text-color"
};
const _hoisted_30 = { class: "cc-text-slate-0" };
const _hoisted_31 = { class: "flex flex-row flex-nowrap" };
const _hoisted_32 = { class: "w-full cc-tabs-button-static cc-rounded p-2" };
const _hoisted_33 = { class: "flex flex-row justify-between cc-text-color" };
const _hoisted_34 = { class: "cc-text-slate-0" };
const _hoisted_35 = { class: "ml-1 cc-text-normal" };
const _hoisted_36 = { class: "flex flex-row justify-between cc-text-color" };
const _hoisted_37 = { class: "cc-text-slate-0" };
const _hoisted_38 = { class: "flex flex-row flex-nowrap" };
const _hoisted_39 = { class: "ml-1 cc-text-normal" };
const _hoisted_40 = {
  key: 0,
  class: "flex flex-row justify-between cc-text-color"
};
const _hoisted_41 = { class: "inline cc-text-slate-0" };
const _hoisted_42 = { class: "ml-1" };
const _hoisted_43 = { class: "flex flex-row flex-nowrap" };
const _hoisted_44 = { class: "ml-1 cc-text-normal" };
const _hoisted_45 = {
  key: 1,
  class: "flex flex-row justify-between cc-text-color"
};
const _hoisted_46 = { class: "inline cc-text-slate-0" };
const _hoisted_47 = { class: "relative flex flex-row flex-nowrap" };
const _hoisted_48 = { class: "ml-1 cc-text-normal" };
const _hoisted_49 = { class: "ml-1 cc-text-normal" };
const _hoisted_50 = {
  key: 2,
  class: "flex flex-row justify-between cc-text-color"
};
const _hoisted_51 = { class: "cc-text-slate-0" };
const _hoisted_52 = { class: "flex flex-row flex-nowrap" };
const _hoisted_53 = { class: "ml-1 cc-text-normal" };
const _hoisted_54 = { class: "flex flex-row justify-between cc-text-color" };
const _hoisted_55 = { class: "cc-text-slate-0" };
const _hoisted_56 = { class: "flex flex-row flex-nowrap" };
const _hoisted_57 = { class: "ml-1 cc-text-normal" };
const _hoisted_58 = { class: "flex flex-row justify-between cc-text-color" };
const _hoisted_59 = { class: "cc-text-slate-0" };
const _hoisted_60 = { class: "flex flex-row flex-nowrap" };
const _hoisted_61 = {
  key: 3,
  class: "flex flex-row justify-between cc-text-color"
};
const _hoisted_62 = { class: "cc-text-slate-0" };
const _hoisted_63 = { class: "flex flex-row flex-nowrap" };
const _hoisted_64 = { class: "flex flex-row justify-between cc-text-color" };
const _hoisted_65 = { class: "cc-text-slate-0" };
const _sfc_main$6 = /* @__PURE__ */ defineComponent({
  __name: "SwapEstimate",
  props: {
    swapInfo: { type: Object, required: true },
    selectedSource: { type: Object, required: true },
    selectedTarget: { type: Object, required: true },
    sourceMetadata: { type: Object, required: true },
    targetMetadata: { type: Object, required: true },
    providerList: { type: Array, required: true },
    sourceName: { type: String, required: true, default: "" },
    targetName: { type: String, required: true, default: "" },
    isLimitOrder: { type: Boolean, required: true, default: false },
    slippage: { type: Number, required: true, default: defaultSlippage },
    eternlFee: { type: String, required: true, default: "" },
    calculating: { type: Boolean, required: true, default: false }
  },
  setup(__props) {
    const props = __props;
    const { t } = useTranslation();
    const {
      getPercentDecimals,
      getDisplayDecimals,
      getDecimalNumber
    } = useFormatter();
    const swapInfoDetails = ref(false);
    const swapPrice = ref(true);
    const sourceIsAda = computed(() => !!props.selectedSource && (props.selectedSource.p.length === 0 || props.selectedSource.p === "."));
    const targetIsAda = computed(() => !!props.selectedTarget && (props.selectedTarget.p.length === 0 || props.selectedTarget.p === "."));
    const flipPrice = computed(() => targetIsAda.value && !swapPrice.value || sourceIsAda.value && swapPrice.value);
    const sourceDecimals = computed(() => {
      var _a, _b;
      return ((_b = (_a = props.sourceMetadata) == null ? void 0 : _a.tr) == null ? void 0 : _b.d) ?? 0;
    });
    const targetDecimals = computed(() => {
      var _a, _b;
      return ((_b = (_a = props.targetMetadata) == null ? void 0 : _a.tr) == null ? void 0 : _b.d) ?? 0;
    });
    const pairDecimalNbr = computed(() => {
      const sourceNbr = sourceDecimals.value > 0 ? getDecimalNumber(sourceDecimals.value) : 1;
      const targetNbr = targetDecimals.value > 0 ? getDecimalNumber(targetDecimals.value) : 1;
      return divide(targetNbr, sourceNbr);
    });
    const price = computed(() => {
      if (!props.swapInfo || !props.selectedSource) {
        return 0;
      }
      if (props.swapInfo._dex_ === "MuesliSwap") {
        return parseFloat(divide(divide(props.swapInfo.estReceive, props.selectedSource.a), pairDecimalNbr.value));
      } else if (props.swapInfo._dex_ === "DexHunter") {
        const info = props.swapInfo;
        let total = 0;
        for (const split of info.splits) {
          let price2 = split.expected_output_without_slippage / split.amount_in;
          total += price2;
        }
        return total / info.splits.length;
      } else {
        return 0;
      }
    });
    const priceDiff = computed(() => {
      if (!props.swapInfo || props.isLimitOrder) {
        return 0;
      }
      if (props.swapInfo._dex_ === "MuesliSwap") {
        return parseFloat(props.swapInfo.priceDiff) * 100;
      }
      if (props.swapInfo._dex_ === "DexHunter") {
        return props.swapInfo.splits.reduce((total, next) => total + (next.price_distortion ?? 0), 0) / props.swapInfo.splits.length;
      } else {
        return 0;
      }
    });
    const getPriceDiffBarColor = (_priceDiff) => {
      if (_priceDiff === 0) {
        return "cc-dimmed-blue";
      }
      if (_priceDiff < 5) {
        return "cc-dimmed-green";
      }
      if (_priceDiff < 15) {
        return "cc-dimmed-yellow";
      } else {
        return "cc-dimmed-red";
      }
    };
    const providerList = computed(() => {
      if (!props.swapInfo) {
        return [getProvider("", props.providerList)];
      }
      if (props.swapInfo._dex_ === "MuesliSwap") {
        return [getProvider(props.swapInfo.pool.provider, props.providerList)];
      }
      if (props.swapInfo._dex_ === "DexHunter") {
        return props.swapInfo.splits.map((split) => getProvider(split.dex, props.providerList));
      } else {
        return [getProvider("", props.providerList)];
      }
    });
    const swapSplits = computed(() => {
      if (!props.swapInfo) {
        return [];
      }
      if (props.swapInfo._dex_ === "MuesliSwap") {
        return [props.swapInfo];
      }
      if (props.swapInfo._dex_ === "DexHunter") {
        return props.swapInfo.splits ?? [];
      } else {
        return [];
      }
    });
    const estReceive = computed(() => {
      var _a;
      if (!props.swapInfo) {
        return "0";
      }
      if (props.swapInfo._dex_ === "MuesliSwap") {
        return targetDecimals.value === 0 ? props.swapInfo.estReceive : divide(props.swapInfo.estReceive, getDecimalNumber(targetDecimals.value));
      }
      if (props.swapInfo._dex_ === "DexHunter") {
        return ((_a = props.swapInfo.total_output_without_slippage) == null ? void 0 : _a.toString()) ?? minReceive.value;
      } else {
        return "0";
      }
    });
    const minReceive = computed(() => {
      var _a;
      if (!props.swapInfo) {
        return "0";
      }
      if (props.swapInfo._dex_ === "MuesliSwap") {
        return targetDecimals.value === 0 ? props.swapInfo.minReceive : divide(props.swapInfo.minReceive, getDecimalNumber(targetDecimals.value));
      }
      if (props.swapInfo._dex_ === "DexHunter") {
        return ((_a = props.swapInfo.total_output) == null ? void 0 : _a.toString()) ?? "0";
      } else {
        return "0";
      }
    });
    const aggBonus = computed(() => {
      var _a;
      if (!props.swapInfo || swapSplits.value.length === 1) {
        return "0";
      }
      if (props.swapInfo._dex_ === "MuesliSwap") {
        return "0";
      }
      if (props.swapInfo._dex_ === "DexHunter") {
        return ((_a = props.swapInfo.possible_routes.BONUS) == null ? void 0 : _a.toString()) ?? "0";
      } else {
        return "0";
      }
    });
    const batcherFee = computed(() => {
      var _a;
      if (!props.swapInfo) {
        return "0";
      }
      if (props.swapInfo._dex_ === "MuesliSwap") {
        return divide(props.swapInfo.pool.batcherFee.amount, getDecimalNumber(6));
      }
      if (props.swapInfo._dex_ === "DexHunter") {
        return ((_a = props.swapInfo.batcher_fee) == null ? void 0 : _a.toString()) ?? "0";
      } else {
        return "0";
      }
    });
    const deposit = computed(() => {
      if (!props.swapInfo) {
        return "0";
      }
      if (props.swapInfo._dex_ === "MuesliSwap") {
        return divide(props.swapInfo.pool.deposit, getDecimalNumber(6));
      }
      if (props.swapInfo._dex_ === "DexHunter") {
        return props.swapInfo.deposits.toString() ?? "0";
      } else {
        return "0";
      }
    });
    const getSplitPercentage = (_info, dex) => {
      if (!_info || !dex || isZero(estReceive.value)) {
        return 0;
      }
      if (dex === "MuesliSwap") {
        return 100;
      }
      if (dex === "DexHunter") {
        return parseFloat(multiply(divide(_info.expected_output_without_slippage ?? "0", estReceive.value), 100));
      } else {
        return 0;
      }
    };
    const getSplitEstReceive = (_info, dex) => {
      var _a;
      if (!_info || !dex) {
        return "0";
      }
      if (dex === "MuesliSwap") {
        return estReceive.value;
      }
      if (dex === "DexHunter") {
        return ((_a = _info.expected_output_without_slippage) == null ? void 0 : _a.toString()) ?? "0";
      } else {
        return "0";
      }
    };
    const getSplitPrice = (_info, dex) => {
      if (!_info || !dex) {
        return 0;
      }
      if (dex === "MuesliSwap") {
        return price.value;
      }
      if (dex === "DexHunter") {
        return parseFloat(divide(_info.expected_output_without_slippage ?? 0, _info.amount_in || 1));
      } else {
        return 0;
      }
    };
    const getSplitPriceDiff = (_info, dex) => {
      if (!_info || !dex) {
        return 0;
      }
      if (dex === "MuesliSwap") {
        return priceDiff.value;
      }
      if (dex === "DexHunter") {
        return _info.price_distortion ?? 0;
      } else {
        return 0;
      }
    };
    const getSplitBatcherFee = (_info, dex) => {
      var _a;
      if (!_info || !dex) {
        return "0";
      }
      if (dex === "MuesliSwap") {
        return batcherFee.value;
      }
      if (dex === "DexHunter") {
        return ((_a = _info.batcher_fee) == null ? void 0 : _a.toString()) ?? "0";
      } else {
        return "0";
      }
    };
    const getSplitDeposit = (_info, dex) => {
      var _a;
      if (!_info || !dex) {
        return "0";
      }
      if (dex === "MuesliSwap") {
        return deposit.value;
      }
      if (dex === "DexHunter") {
        return ((_a = _info.deposits) == null ? void 0 : _a.toString()) ?? "0";
      } else {
        return "0";
      }
    };
    return (_ctx, _cache) => {
      var _a;
      return __props.swapInfo ? (openBlock(), createElementBlock("div", {
        key: 0,
        onClick: _cache[4] || (_cache[4] = withModifiers(($event) => swapInfoDetails.value = !swapInfoDetails.value, ["stop"])),
        class: "relative w-full max-w-md mt-2 flex flex-row flex-nowrap justify-center"
      }, [
        !swapInfoDetails.value ? (openBlock(), createElementBlock("div", {
          key: 0,
          class: normalizeClass(["relative min-h-8 w-full flex flex-row flex-nowrap justify-center items-center cc-tabs-button cc-rounded px-2 cursor-zoom-in", getPriceDiffBarColor(priceDiff.value)])
        }, [
          _cache[7] || (_cache[7] = createBaseVNode("i", { class: "mdi mdi-chevron-right mr-1" }, null, -1)),
          _cache[8] || (_cache[8] = createBaseVNode("span", { class: "cc-text-normal" }, "1", -1)),
          createBaseVNode("span", _hoisted_1$6, toDisplayString(flipPrice.value ? __props.targetName : __props.sourceName), 1),
          _cache[9] || (_cache[9] = createBaseVNode("span", { class: "mx-1 cc-text-normal" }, "=", -1)),
          createVNode(_sfc_main$f, {
            "is-whole-number": "",
            "hide-fraction-if-zero": "",
            amount: flipPrice.value ? divide(1, price.value || 1) : price.value.toString(),
            currency: "",
            decimals: unref(getDisplayDecimals)(flipPrice.value ? divide(1, price.value || 1) : price.value.toString()),
            "clipboard-enabled": false,
            onClicked: _cache[0] || (_cache[0] = ($event) => swapInfoDetails.value = !swapInfoDetails.value)
          }, null, 8, ["amount", "decimals"]),
          createBaseVNode("span", _hoisted_2$5, toDisplayString(flipPrice.value ? __props.sourceName : __props.targetName), 1),
          !isZero(aggBonus.value) ? (openBlock(), createElementBlock("div", _hoisted_3$4, [
            _cache[5] || (_cache[5] = createBaseVNode("span", { class: "ml-1 mr-0.5" }, "(", -1)),
            createVNode(_sfc_main$f, {
              "is-whole-number": "",
              "hide-fraction-if-zero": "",
              withSign: "",
              amount: aggBonus.value,
              currency: "",
              decimals: unref(getDisplayDecimals)(aggBonus.value),
              "text-c-s-s": "cc-text-green",
              "clipboard-enabled": false,
              onClicked: _cache[1] || (_cache[1] = ($event) => swapInfoDetails.value = !swapInfoDetails.value)
            }, null, 8, ["amount", "decimals"]),
            createBaseVNode("span", _hoisted_4$4, toDisplayString(__props.targetName), 1),
            _cache[6] || (_cache[6] = createBaseVNode("span", { class: "ml-0.5" }, ")", -1))
          ])) : createCommentVNode("", true),
          _cache[10] || (_cache[10] = createBaseVNode("span", { class: "mx-2 cc-text-bold cc-text-lg" }, "@", -1)),
          (openBlock(true), createElementBlock(Fragment, null, renderList(providerList.value, (provider, index) => {
            return openBlock(), createElementBlock("div", {
              key: provider.name,
              class: normalizeClass(index > 0 ? "ml-2" : "")
            }, [
              provider.image.length > 0 ? (openBlock(), createElementBlock("img", {
                key: 0,
                class: "w-4 h-4",
                loading: "lazy",
                src: provider.image,
                alt: `${provider.name} logo`
              }, null, 8, _hoisted_5$3)) : createCommentVNode("", true)
            ], 2);
          }), 128)),
          swapSplits.value.length === 1 ? (openBlock(), createElementBlock("span", _hoisted_6$3, toDisplayString(providerList.value[0].name), 1)) : createCommentVNode("", true),
          __props.calculating ? (openBlock(), createBlock(QSpinnerDots_default, {
            key: 2,
            class: "absolute right-2",
            color: "gray",
            size: "1.5em"
          })) : createCommentVNode("", true)
        ], 2)) : (openBlock(), createElementBlock("div", _hoisted_7$3, [
          __props.calculating ? (openBlock(), createElementBlock("div", _hoisted_8$3, [
            createVNode(_sfc_main$c, {
              text: unref(t)("wallet.swap.create.estimate")
            }, null, 8, ["text"]),
            createVNode(QSpinnerDots_default, {
              color: "gray",
              size: "2em"
            })
          ])) : createCommentVNode("", true),
          swapSplits.value.length > 1 ? (openBlock(), createBlock(_sfc_main$b, {
            key: 1,
            "do-capitalize": false,
            label: `Split over ${swapSplits.value.length} providers`,
            class: "mb-1 ml-1"
          }, null, 8, ["label"])) : createCommentVNode("", true),
          (openBlock(true), createElementBlock(Fragment, null, renderList(swapSplits.value, (split, index) => {
            return openBlock(), createElementBlock("div", {
              key: index,
              class: normalizeClass(["w-full cc-tabs-button-static cc-rounded", index > 0 ? "mt-2" : ""])
            }, [
              createBaseVNode("div", _hoisted_9$3, [
                createBaseVNode("div", _hoisted_10$3, [
                  createBaseVNode("div", _hoisted_11$3, [
                    createBaseVNode("div", {
                      class: normalizeClass(["absolute cc-rounded top-0 left-0 h-full", getPriceDiffBarColor(getSplitPriceDiff(split, __props.swapInfo._dex_))]),
                      style: normalizeStyle("width: " + getSplitPercentage(split, __props.swapInfo._dex_) + "%")
                    }, null, 6),
                    createBaseVNode("div", _hoisted_12$3, [
                      createVNode(_sfc_main$f, {
                        percent: "",
                        "hide-fraction-if-zero": "",
                        amount: getSplitPercentage(split, __props.swapInfo._dex_).toString(),
                        decimals: unref(getPercentDecimals)(getSplitPercentage(split, __props.swapInfo._dex_)),
                        class: "cursor-pointer"
                      }, null, 8, ["amount", "decimals"]),
                      !isZero(getSplitPriceDiff(split, __props.swapInfo._dex_)) ? (openBlock(), createElementBlock("div", _hoisted_13$3, [
                        _cache[11] || (_cache[11] = createBaseVNode("span", { class: "ml-1 mr-0.5" }, "(", -1)),
                        createVNode(_sfc_main$f, {
                          percent: "",
                          "hide-fraction-if-zero": "",
                          amount: getSplitPriceDiff(split, __props.swapInfo._dex_).toString(),
                          decimals: unref(getPercentDecimals)(getSplitPriceDiff(split, __props.swapInfo._dex_)),
                          class: "cursor-pointer"
                        }, null, 8, ["amount", "decimals"]),
                        createBaseVNode("span", _hoisted_14$2, toDisplayString(unref(t)("wallet.swap.create.info.pricediff")), 1),
                        _cache[12] || (_cache[12] = createBaseVNode("span", { class: "ml-0.5" }, ")", -1))
                      ])) : createCommentVNode("", true),
                      _cache[13] || (_cache[13] = createBaseVNode("span", { class: "mx-2 cc-text-bold cc-text-lg" }, "@", -1)),
                      providerList.value[index].image.length > 0 ? (openBlock(), createElementBlock("img", {
                        key: 1,
                        class: "w-4 h-4",
                        loading: "lazy",
                        src: providerList.value[index].image,
                        alt: `${providerList.value[index].name} logo`
                      }, null, 8, _hoisted_15$2)) : createCommentVNode("", true),
                      createBaseVNode("span", _hoisted_16$2, toDisplayString(providerList.value[index].name), 1)
                    ])
                  ])
                ]),
                swapSplits.value.length > 1 ? (openBlock(), createElementBlock("div", _hoisted_17$2, [
                  createBaseVNode("span", _hoisted_18$2, toDisplayString(unref(t)("wallet.swap.create.info.estreceive")), 1),
                  createBaseVNode("div", _hoisted_19$2, [
                    createVNode(_sfc_main$f, {
                      "hide-fraction-if-zero": "",
                      "is-whole-number": "",
                      amount: getSplitEstReceive(split, __props.swapInfo._dex_),
                      currency: "",
                      decimals: targetDecimals.value,
                      class: "cursor-pointer"
                    }, null, 8, ["amount", "decimals"]),
                    createBaseVNode("span", _hoisted_20$2, toDisplayString(__props.targetName), 1)
                  ])
                ])) : createCommentVNode("", true),
                createBaseVNode("div", _hoisted_21$1, [
                  createBaseVNode("div", _hoisted_22$1, [
                    createBaseVNode("span", null, toDisplayString(unref(t)("wallet.swap.create.info.price")), 1)
                  ]),
                  createBaseVNode("div", _hoisted_23$1, [
                    createBaseVNode("i", {
                      class: "absolute -left-7 -top-1 cc-text-xl mdi mdi-swap-horizontal cursor-pointer",
                      onClick: _cache[2] || (_cache[2] = withModifiers(($event) => swapPrice.value = !swapPrice.value, ["stop", "prevent"]))
                    }),
                    _cache[14] || (_cache[14] = createBaseVNode("span", { class: "cc-text-normal" }, "1", -1)),
                    createBaseVNode("span", _hoisted_24$1, toDisplayString(flipPrice.value ? __props.targetName : __props.sourceName), 1),
                    _cache[15] || (_cache[15] = createBaseVNode("span", { class: "mx-1 cc-text-normal" }, "=", -1)),
                    createVNode(_sfc_main$f, {
                      "is-whole-number": "",
                      "hide-fraction-if-zero": "",
                      "fraction-c-s-s": "cc-text-light",
                      amount: flipPrice.value ? divide(1, getSplitPrice(split, __props.swapInfo._dex_) || 1) : getSplitPrice(split, __props.swapInfo._dex_).toString(),
                      currency: "",
                      decimals: flipPrice.value ? unref(getDisplayDecimals)(divide(1, getSplitPrice(split, __props.swapInfo._dex_) || 1)) : unref(getDisplayDecimals)(getSplitPrice(split, __props.swapInfo._dex_).toString()),
                      class: "cursor-pointer"
                    }, null, 8, ["amount", "decimals"]),
                    createBaseVNode("span", _hoisted_25, toDisplayString(flipPrice.value ? __props.sourceName : __props.targetName), 1)
                  ])
                ]),
                swapSplits.value.length > 1 ? (openBlock(), createElementBlock("div", _hoisted_26, [
                  createBaseVNode("span", _hoisted_27, toDisplayString(unref(t)("wallet.swap.create.info.batcherfee")), 1),
                  createBaseVNode("div", _hoisted_28, [
                    createVNode(_sfc_main$f, {
                      "hide-fraction-if-zero": "",
                      "is-whole-number": "",
                      amount: getSplitBatcherFee(split, __props.swapInfo._dex_).toString(),
                      class: "cursor-pointer"
                    }, null, 8, ["amount"])
                  ])
                ])) : createCommentVNode("", true),
                swapSplits.value.length > 1 ? (openBlock(), createElementBlock("div", _hoisted_29, [
                  createBaseVNode("span", _hoisted_30, toDisplayString(unref(t)("wallet.swap.create.info.deposit")), 1),
                  createBaseVNode("div", _hoisted_31, [
                    createVNode(_sfc_main$f, {
                      "hide-fraction-if-zero": "",
                      "is-whole-number": "",
                      amount: getSplitDeposit(split, __props.swapInfo._dex_).toString(),
                      class: "cursor-pointer"
                    }, null, 8, ["amount"])
                  ])
                ])) : createCommentVNode("", true)
              ])
            ], 2);
          }), 128)),
          createVNode(_sfc_main$b, {
            class: "mt-2 mb-1 ml-1",
            label: unref(t)("wallet.swap.create.info.summary")
          }, null, 8, ["label"]),
          createBaseVNode("div", _hoisted_32, [
            createBaseVNode("div", _hoisted_33, [
              createBaseVNode("span", _hoisted_34, toDisplayString(unref(t)("wallet.swap.create.info.aggregator")), 1),
              createBaseVNode("span", _hoisted_35, toDisplayString(__props.swapInfo._dex_), 1)
            ]),
            createBaseVNode("div", _hoisted_36, [
              createBaseVNode("span", _hoisted_37, toDisplayString(unref(t)("wallet.swap.create.info.estreceive")), 1),
              createBaseVNode("div", _hoisted_38, [
                createVNode(_sfc_main$f, {
                  "hide-fraction-if-zero": "",
                  "is-whole-number": "",
                  amount: estReceive.value,
                  currency: "",
                  decimals: targetDecimals.value,
                  class: "cursor-pointer"
                }, null, 8, ["amount", "decimals"]),
                createBaseVNode("span", _hoisted_39, toDisplayString(__props.targetName), 1)
              ])
            ]),
            !__props.isLimitOrder ? (openBlock(), createElementBlock("div", _hoisted_40, [
              createBaseVNode("div", _hoisted_41, [
                createBaseVNode("span", null, toDisplayString(unref(t)("wallet.swap.create.info.minreceive")), 1),
                _cache[16] || (_cache[16] = createBaseVNode("span", { class: "ml-1 mr-0.5" }, "(", -1)),
                createBaseVNode("span", null, toDisplayString(round(__props.slippage * 100, 1)), 1),
                _cache[17] || (_cache[17] = createBaseVNode("span", { class: "ml-1" }, "%", -1)),
                createBaseVNode("span", _hoisted_42, toDisplayString(unref(t)("wallet.swap.create.info.slippage")), 1),
                _cache[18] || (_cache[18] = createBaseVNode("span", { class: "ml-0.5" }, ")", -1))
              ]),
              createBaseVNode("div", _hoisted_43, [
                createVNode(_sfc_main$f, {
                  "hide-fraction-if-zero": "",
                  "is-whole-number": "",
                  amount: minReceive.value,
                  currency: "",
                  decimals: targetDecimals.value,
                  class: "cursor-pointer"
                }, null, 8, ["amount", "decimals"]),
                createBaseVNode("span", _hoisted_44, toDisplayString(__props.targetName), 1)
              ])
            ])) : createCommentVNode("", true),
            swapSplits.value.length > 1 ? (openBlock(), createElementBlock("div", _hoisted_45, [
              createBaseVNode("div", _hoisted_46, [
                createBaseVNode("span", null, toDisplayString(unref(t)("wallet.swap.create.info.avgprice")), 1)
              ]),
              createBaseVNode("div", _hoisted_47, [
                createBaseVNode("i", {
                  class: "absolute -left-7 -top-1 cc-text-xl mdi mdi-swap-horizontal cursor-pointer",
                  onClick: _cache[3] || (_cache[3] = withModifiers(($event) => swapPrice.value = !swapPrice.value, ["stop", "prevent"]))
                }),
                _cache[19] || (_cache[19] = createBaseVNode("span", { class: "cc-text-normal" }, "1", -1)),
                createBaseVNode("span", _hoisted_48, toDisplayString(flipPrice.value ? __props.targetName : __props.sourceName), 1),
                _cache[20] || (_cache[20] = createBaseVNode("span", { class: "mx-1 cc-text-normal" }, "=", -1)),
                createVNode(_sfc_main$f, {
                  "is-whole-number": "",
                  "hide-fraction-if-zero": "",
                  amount: flipPrice.value ? divide(1, price.value || 1) : price.value.toString(),
                  currency: "",
                  decimals: unref(getDisplayDecimals)(flipPrice.value ? divide(1, price.value || 1) : price.value.toString()),
                  class: "cursor-pointer"
                }, null, 8, ["amount", "decimals"]),
                createBaseVNode("span", _hoisted_49, toDisplayString(flipPrice.value ? __props.sourceName : __props.targetName), 1)
              ])
            ])) : createCommentVNode("", true),
            !isZero(aggBonus.value) ? (openBlock(), createElementBlock("div", _hoisted_50, [
              createBaseVNode("span", _hoisted_51, toDisplayString(unref(t)("wallet.swap.create.info.aggbonus")), 1),
              createBaseVNode("div", _hoisted_52, [
                createVNode(_sfc_main$f, {
                  "hide-fraction-if-zero": "",
                  "is-whole-number": "",
                  "with-sign": "",
                  amount: aggBonus.value,
                  currency: "",
                  decimals: targetDecimals.value,
                  class: "cursor-pointer cc-text-green"
                }, null, 8, ["amount", "decimals"]),
                createBaseVNode("span", _hoisted_53, toDisplayString(__props.targetName), 1)
              ])
            ])) : createCommentVNode("", true),
            createVNode(GridSpace, {
              hr: "",
              label: unref(t)("wallet.swap.create.info.topay"),
              "align-label": "left",
              "line-c-s-s": "cc-text-slate-0",
              "label-c-s-s": "cc-text-sz cc-text-slate-0"
            }, null, 8, ["label"]),
            createBaseVNode("div", _hoisted_54, [
              createBaseVNode("span", _hoisted_55, toDisplayString(unref(t)("wallet.swap.create.input.from.title")), 1),
              createBaseVNode("div", _hoisted_56, [
                createVNode(_sfc_main$f, {
                  "hide-fraction-if-zero": "",
                  amount: ((_a = __props.selectedSource) == null ? void 0 : _a.a) ?? "0",
                  currency: "",
                  decimals: sourceDecimals.value,
                  class: "cursor-pointer"
                }, null, 8, ["amount", "decimals"]),
                createBaseVNode("span", _hoisted_57, toDisplayString(__props.sourceName), 1)
              ])
            ]),
            createBaseVNode("div", _hoisted_58, [
              createBaseVNode("span", _hoisted_59, "+ " + toDisplayString(unref(t)("wallet.swap.create.info.batcherfee")), 1),
              createBaseVNode("div", _hoisted_60, [
                createVNode(_sfc_main$f, {
                  "hide-fraction-if-zero": "",
                  "is-whole-number": "",
                  amount: batcherFee.value,
                  class: "cursor-pointer"
                }, null, 8, ["amount"])
              ])
            ]),
            !isZero(__props.eternlFee) ? (openBlock(), createElementBlock("div", _hoisted_61, [
              createBaseVNode("span", _hoisted_62, "+ " + toDisplayString(unref(t)("wallet.swap.create.info.frontend")), 1),
              createBaseVNode("div", _hoisted_63, [
                createVNode(_sfc_main$f, {
                  "hide-fraction-if-zero": "",
                  amount: __props.eternlFee,
                  class: "cursor-pointer"
                }, null, 8, ["amount"])
              ])
            ])) : createCommentVNode("", true),
            createBaseVNode("div", _hoisted_64, [
              createBaseVNode("span", _hoisted_65, "+ " + toDisplayString(unref(t)("wallet.swap.create.info.deposit")), 1),
              createVNode(_sfc_main$f, {
                "hide-fraction-if-zero": "",
                "is-whole-number": "",
                amount: deposit.value,
                class: "cursor-pointer"
              }, null, 8, ["amount"])
            ])
          ])
        ]))
      ])) : createCommentVNode("", true);
    };
  }
});
const _hoisted_1$5 = { class: "grow-0 shrink-0 w-full flex flex-row flex-nowrap items-start justify-between cc-bg-white-0 border-b cc-p" };
const _hoisted_2$4 = { class: "flex flex-col cc-text-sz" };
const _hoisted_3$3 = { class: "min-h-40 flex flex-col flex-nowrap cc-p w-full overflow-auto cc-gap-lg" };
const _hoisted_4$3 = { class: "cc-grid cc-text-sz" };
const _hoisted_5$2 = { class: "col-span-12 flex flex-col" };
const _hoisted_6$2 = { class: "flex flex-row flex-nowrap" };
const _hoisted_7$2 = {
  key: 0,
  class: "mt-2 col-span-12 cc-flex cc-area-highlight align-middle cc-p cc-text-medium"
};
const _hoisted_8$2 = { class: "col-span-12 grid grid-cols-4 cc-gap" };
const _hoisted_9$2 = {
  key: 0,
  class: "col-span-12 mt-0.5 flex flex-row flex-nowrap items-center cc-ring-yellow cc-area-highlight cc-p"
};
const _hoisted_10$2 = {
  key: 1,
  class: "col-span-12 mt-0.5 flex flex-row flex-nowrap items-center cc-ring-yellow cc-area-highlight cc-p"
};
const _hoisted_11$2 = { class: "flex flex-row flex-nowrap gap-4" };
const _hoisted_12$2 = { class: "xs:w-2/5 flex flex-col flex-nowrap cc-gap" };
const _hoisted_13$2 = ["selected", "value"];
const _hoisted_14$1 = { class: "xs:w-3/5 flex flex-col flex-nowrap gap-1" };
const _hoisted_15$1 = { class: "flex flex-row flex-nowrap" };
const _hoisted_16$1 = {
  key: 0,
  class: "my-2 col-span-12 cc-flex cc-area-highlight align-middle cc-p cc-text-medium"
};
const _hoisted_17$1 = { class: "flex flex-row cc-gap" };
const _hoisted_18$1 = ["onClick"];
const _hoisted_19$1 = { class: "cc-text-sz" };
const _hoisted_20$1 = { class: "grid grid-cols-12 cc-gap w-full p-2" };
const slippageInputDefault = "";
const _sfc_main$5 = /* @__PURE__ */ defineComponent({
  __name: "SwapSettings",
  props: {
    settings: { type: Object },
    aggList: { type: Array, required: true },
    providerList: { type: Array, required: true },
    limitOrder: { type: Boolean, required: true, default: false }
  },
  emits: ["save"],
  setup(__props, { emit: __emit }) {
    const props = __props;
    const emit = __emit;
    const $q = useQuasar();
    const { t } = useTranslation();
    const {
      getPercentDecimals,
      formatAmountString,
      valueFromFormattedString,
      getNumberFormatSeparators
    } = useFormatter();
    const showSettingsModal = ref(false);
    const showSlippageInput = ref(false);
    const showSlippageInfo = ref(false);
    const showProviderInfo = ref(false);
    const slippageInput = ref(slippageInputDefault);
    const slippageInputNum = ref(0);
    const slippageInputError = ref("");
    const slippageManualUpdate = ref(0);
    const slippageShowWarning = ref(false);
    const _blacklist = ref([]);
    const _aggregator = ref();
    const aggregatorList = [void 0, ...props.aggList];
    let formatSeparators = getNumberFormatSeparators();
    const decimalSeparator = ref(formatSeparators.decimal);
    const onCancel = () => {
      if (props.settings) {
        validateSlippageInput((props.settings.slippage * 100).toString());
        _blacklist.value = props.settings.blacklist;
        _aggregator.value = props.settings.aggregator;
        showSlippageInput.value = ![0.5, 1, 3].includes(props.settings.slippage * 100);
      } else {
        onSettingsReset();
      }
      showSettingsModal.value = false;
      slippageInputError.value = "";
    };
    const onSettings = () => showSettingsModal.value = !showSettingsModal.value;
    const onSettingsReset = () => {
      validateSlippageInput("3");
      _blacklist.value = [];
      _aggregator.value = void 0;
      showSlippageInput.value = false;
    };
    const onSave = () => {
      if (slippageInputError.value.length === 0) {
        const _slippage = valueFromFormattedString(slippageInput.value);
        const _settings = {
          slippage: Number(parseFloat(_slippage.number) / 100),
          blacklist: _blacklist.value
        };
        if (_aggregator.value) {
          _settings.aggregator = _aggregator.value;
        }
        emit("save", _settings);
        showSlippageInput.value = ![0.5, 1, 3].includes(parseFloat(_slippage.number));
        showSettingsModal.value = false;
      }
    };
    const formatValue = (amount) => {
      const _slippage = valueFromFormattedString(amount);
      const decimals = getPercentDecimals(_slippage.number);
      return formatAmountString(amount, true, true, decimals, decimals, "", false, false);
    };
    const onSlippage_0_5 = () => {
      showSlippageInput.value = false;
      validateSlippageInput(formatValue("0.5"));
    };
    const onSlippage_1_0 = () => {
      showSlippageInput.value = false;
      validateSlippageInput("1");
    };
    const onSlippage_3_0 = () => {
      showSlippageInput.value = false;
      validateSlippageInput("3");
    };
    const onSlippage_custom = () => showSlippageInput.value = true;
    const toggleSlippageInfo = () => showSlippageInfo.value = !showSlippageInfo.value;
    const toggleProviderInfo = () => showProviderInfo.value = !showProviderInfo.value;
    function validateSlippageInput(value) {
      if (value) {
        slippageInputError.value = "";
        const _slippage = valueFromFormattedString(value);
        const _slippageNum = parseFloat(_slippage.number);
        slippageManualUpdate.value = slippageManualUpdate.value + 1;
        const decimals = getPercentDecimals(_slippage.number);
        if (_slippageNum < 0) {
          slippageInputError.value = t("wallet.swap.create.settings.error.slippage.low");
        } else if (_slippageNum > 100) {
          slippageInputError.value = t("wallet.swap.create.settings.error.slippage.high");
        }
        if (_slippageNum > 50) {
          slippageShowWarning.value = true;
        } else {
          slippageShowWarning.value = false;
        }
        nextTick(() => {
          slippageInput.value = formatAmountString(_slippage.number, true, true, decimals, decimals, "", false, false);
          slippageInputNum.value = parseFloat(valueFromFormattedString(slippageInput.value).number);
        });
      } else {
        slippageInput.value = slippageInputDefault;
        slippageManualUpdate.value = slippageManualUpdate.value + 1;
      }
    }
    function onToggleProvider(providerId) {
      const index = _blacklist.value.indexOf(providerId);
      if (index === -1) {
        if (_blacklist.value.length === props.providerList.length - 1) {
          $q.notify({
            message: t("wallet.swap.create.settings.modal.provider.empty"),
            type: "warning",
            position: "top-left",
            timeout: 4e3
          });
        } else {
          _blacklist.value.push(providerId);
        }
      } else {
        _blacklist.value.splice(index, 1);
      }
    }
    function onAggregatorChange(event) {
      const value = event.target.options[event.target.options.selectedIndex].value;
      _aggregator.value = value.length === 0 ? void 0 : value;
    }
    watch(() => props.settings, (_settings) => {
      if (!_settings) {
        onSettingsReset();
        return;
      }
      const slippagePercent = _settings.slippage * 100;
      if (slippagePercent === parseFloat(valueFromFormattedString(slippageInput.value).number)) {
        return;
      }
      validateSlippageInput(slippagePercent.toString());
      _blacklist.value = _settings.blacklist;
      _aggregator.value = _settings.aggregator;
    }, { deep: true });
    onMounted(() => {
      if (props.settings) {
        validateSlippageInput((props.settings.slippage * 100).toString());
        _blacklist.value = props.settings.blacklist;
        _aggregator.value = props.settings.aggregator;
        showSlippageInput.value = ![5e-3, 0.01, 0.03].includes(props.settings.slippage);
      } else {
        onSettingsReset();
      }
    });
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock(Fragment, null, [
        showSettingsModal.value ? (openBlock(), createBlock(Modal, {
          key: 0,
          narrow: "",
          onClose: onCancel
        }, {
          header: withCtx(() => [
            createBaseVNode("div", _hoisted_1$5, [
              createBaseVNode("div", _hoisted_2$4, [
                createVNode(_sfc_main$b, {
                  label: unref(t)("wallet.swap.create.settings.modal.label"),
                  "do-capitalize": false
                }, null, 8, ["label"])
              ])
            ])
          ]),
          content: withCtx(() => [
            createBaseVNode("div", _hoisted_3$3, [
              createBaseVNode("div", _hoisted_4$3, [
                createBaseVNode("div", _hoisted_5$2, [
                  createBaseVNode("div", _hoisted_6$2, [
                    createVNode(_sfc_main$c, {
                      class: "cc-text-bold inline-block",
                      text: unref(t)("wallet.swap.create.settings.modal.slippage.label")
                    }, null, 8, ["text"]),
                    createBaseVNode("i", {
                      class: "mdi mdi-information-outline cursor-pointer pointer-events-auto ml-1",
                      onClick: _cache[0] || (_cache[0] = ($event) => toggleSlippageInfo())
                    })
                  ]),
                  showSlippageInfo.value ? (openBlock(), createElementBlock("div", _hoisted_7$2, [
                    createVNode(_sfc_main$c, {
                      text: unref(t)("wallet.swap.create.settings.modal.slippage.info")
                    }, null, 8, ["text"])
                  ])) : createCommentVNode("", true)
                ]),
                createBaseVNode("div", _hoisted_8$2, [
                  slippageInputNum.value === 0.5 && !showSlippageInput.value ? (openBlock(), createBlock(_sfc_main$g, {
                    key: 0,
                    label: "0.5 %",
                    link: onSlippage_0_5,
                    type: "button"
                  })) : (openBlock(), createBlock(GridButtonSecondary, {
                    key: 1,
                    label: "0.5 %",
                    link: onSlippage_0_5,
                    type: "button"
                  })),
                  slippageInputNum.value === 1 && !showSlippageInput.value ? (openBlock(), createBlock(_sfc_main$g, {
                    key: 2,
                    label: "1 %",
                    link: onSlippage_1_0,
                    type: "button"
                  })) : (openBlock(), createBlock(GridButtonSecondary, {
                    key: 3,
                    label: "1 %",
                    link: onSlippage_1_0,
                    type: "button"
                  })),
                  slippageInputNum.value === 3 && !showSlippageInput.value ? (openBlock(), createBlock(_sfc_main$g, {
                    key: 4,
                    label: "3 %",
                    link: onSlippage_3_0,
                    type: "button"
                  })) : (openBlock(), createBlock(GridButtonSecondary, {
                    key: 5,
                    label: "3 %",
                    link: onSlippage_3_0,
                    type: "button"
                  })),
                  showSlippageInput.value ? (openBlock(), createBlock(_sfc_main$g, {
                    key: 6,
                    label: unref(t)("wallet.swap.create.settings.modal.slippage.custom"),
                    link: onSlippage_custom,
                    type: "button"
                  }, null, 8, ["label"])) : (openBlock(), createBlock(GridButtonSecondary, {
                    key: 7,
                    label: unref(t)("wallet.swap.create.settings.modal.slippage.custom"),
                    link: onSlippage_custom,
                    type: "button"
                  }, null, 8, ["label"]))
                ]),
                withDirectives(createVNode(GridInput, {
                  class: "col-span-12",
                  autofocus: "",
                  autocomplete: "off",
                  "input-id": "inputSlippage",
                  "input-type": "text",
                  "input-text": slippageInput.value,
                  "input-error": slippageInputError.value,
                  "onUpdate:inputError": _cache[1] || (_cache[1] = ($event) => slippageInputError.value = $event),
                  label: unref(t)("wallet.swap.create.settings.modal.slippage.input"),
                  "input-hint": slippageInputDefault,
                  "input-info": unref(t)("wallet.swap.create.settings.modal.slippage.inputinfo"),
                  alwaysShowInfo: false,
                  showReset: false,
                  "decimal-separator": decimalSeparator.value,
                  "manual-update": slippageManualUpdate.value,
                  "onUpdate:inputText": validateSlippageInput,
                  onEnter: onCancel
                }, {
                  "icon-prepend": withCtx(() => _cache[5] || (_cache[5] = [
                    createBaseVNode("span", { class: "cc-text-md cc-text-semi-bold" }, "%", -1)
                  ])),
                  _: 1
                }, 8, ["input-text", "input-error", "label", "input-info", "decimal-separator", "manual-update"]), [
                  [vShow, showSlippageInput.value]
                ]),
                slippageShowWarning.value ? (openBlock(), createElementBlock("div", _hoisted_9$2, [
                  createVNode(IconWarning, { class: "w-7 flex-none mr-2" }),
                  createVNode(_sfc_main$c, {
                    text: unref(t)("wallet.swap.create.settings.modal.slippage.warning"),
                    class: "cc-text-sz cc-text-semi-bold"
                  }, null, 8, ["text"])
                ])) : createCommentVNode("", true),
                __props.limitOrder ? (openBlock(), createElementBlock("div", _hoisted_10$2, [
                  createVNode(IconWarning, { class: "w-7 flex-none mr-2" }),
                  createVNode(_sfc_main$c, {
                    text: unref(t)("wallet.swap.create.settings.modal.slippage.limit"),
                    class: "cc-text-sz cc-text-semi-bold"
                  }, null, 8, ["text"])
                ])) : createCommentVNode("", true)
              ]),
              createBaseVNode("div", _hoisted_11$2, [
                createBaseVNode("div", _hoisted_12$2, [
                  createVNode(_sfc_main$c, {
                    class: "cc-text-bold inline-block",
                    text: unref(t)("wallet.swap.create.settings.modal.aggregator.label")
                  }, null, 8, ["text"]),
                  createBaseVNode("select", {
                    class: "cc-rounded-la cc-dropdown cc-text-sm",
                    required: true,
                    onChange: _cache[2] || (_cache[2] = ($event) => onAggregatorChange($event))
                  }, [
                    (openBlock(), createElementBlock(Fragment, null, renderList(aggregatorList, (aggregator, index) => {
                      return createBaseVNode("option", {
                        key: index,
                        selected: _aggregator.value === aggregator,
                        value: aggregator ?? "",
                        class: "cc-text-semi-bold"
                      }, toDisplayString(!aggregator ? "Automatic Selection" : aggregator), 9, _hoisted_13$2);
                    }), 64))
                  ], 32)
                ]),
                createBaseVNode("div", _hoisted_14$1, [
                  createBaseVNode("div", null, [
                    createBaseVNode("div", _hoisted_15$1, [
                      createVNode(_sfc_main$c, {
                        class: "cc-text-bold inline-block",
                        text: unref(t)("wallet.swap.create.settings.modal.provider.label")
                      }, null, 8, ["text"]),
                      createBaseVNode("i", {
                        class: "mdi mdi-information-outline cursor-pointer pointer-events-auto ml-1",
                        onClick: _cache[3] || (_cache[3] = ($event) => toggleProviderInfo())
                      })
                    ]),
                    showProviderInfo.value ? (openBlock(), createElementBlock("div", _hoisted_16$1, [
                      createVNode(_sfc_main$c, {
                        text: unref(t)("wallet.swap.create.settings.modal.provider.info")
                      }, null, 8, ["text"])
                    ])) : createCommentVNode("", true)
                  ]),
                  createBaseVNode("div", _hoisted_17$1, [
                    (openBlock(true), createElementBlock(Fragment, null, renderList(__props.providerList, (provider) => {
                      return openBlock(), createElementBlock("div", {
                        key: provider.id
                      }, [
                        createBaseVNode("div", {
                          class: normalizeClass(["cursor-pointer", _blacklist.value.includes(provider.id) ? "cc-badge-gray" : "cc-badge-blue"]),
                          onClick: ($event) => onToggleProvider(provider.id)
                        }, [
                          createBaseVNode("span", _hoisted_19$1, toDisplayString(provider.name), 1)
                        ], 10, _hoisted_18$1)
                      ]);
                    }), 128))
                  ])
                ])
              ])
            ])
          ]),
          footer: withCtx(() => [
            createBaseVNode("div", _hoisted_20$1, [
              createVNode(_sfc_main$h, {
                label: unref(t)("common.label.reset"),
                link: onSettingsReset,
                class: "col-start-0 col-span-6 lg:col-span-4 cc-btn-abort"
              }, null, 8, ["label"]),
              createVNode(_sfc_main$g, {
                label: unref(t)("common.label.save"),
                link: onSave,
                disabled: slippageInputError.value.length > 0,
                class: "lg:col-start-9 col-span-6 lg:col-span-4"
              }, null, 8, ["label", "disabled"])
            ])
          ]),
          _: 1
        })) : createCommentVNode("", true),
        createBaseVNode("div", {
          class: "cursor-pointer",
          onClick: _cache[4] || (_cache[4] = ($event) => onSettings())
        }, [
          _cache[6] || (_cache[6] = createBaseVNode("i", { class: "text-xl hover:cc-text-blue-light mdi mdi-tune" }, null, -1)),
          createVNode(_sfc_main$e, {
            anchor: "bottom middle",
            "transition-show": "scale",
            "transition-hide": "scale"
          }, {
            default: withCtx(() => [
              createTextVNode(toDisplayString(unref(t)("wallet.swap.create.settings.hover")), 1)
            ]),
            _: 1
          })
        ])
      ], 64);
    };
  }
});
const _hoisted_1$4 = {
  key: 1,
  class: "col-span-12 flex flex-col flex-nowrap justify-center items-center"
};
const _hoisted_2$3 = {
  key: 2,
  class: "relative col-span-12 w-full flex flex-col items-center"
};
const _hoisted_3$2 = { class: "relative w-full max-w-md flex flex-col flex-nowrap" };
const _hoisted_4$2 = { class: "flex flex-nowrap justify-end items-center gap-4" };
const _hoisted_5$1 = {
  key: 0,
  class: "relative flex flex-nowrap flex-col gap-4"
};
const _hoisted_6$1 = { class: "relative -mb-6" };
const _hoisted_7$1 = { class: "relative z-50 flex justify-center items-center h-2" };
const _hoisted_8$1 = { class: "relative" };
const _hoisted_9$1 = {
  key: 1,
  class: "relative w-full max-w-md mt-2 flex flex-row flex-nowrap justify-center"
};
const _hoisted_10$1 = {
  key: 3,
  class: "mt-2 max-h-8 w-full flex flex-row flex-nowrap justify-center items-center cc-tabs-button-static cc-rounded px-2 cc-gap-lg"
};
const _hoisted_11$1 = {
  key: 0,
  class: "relative w-full max-w-md mt-2.5 mb-0.5 flex flex-row flex-nowrap cc-ring-yellow cc-text-sz cc-text-semi-bold cc-area-highlight p-2"
};
const _hoisted_12$1 = { class: "relative w-full max-w-md grid mt-2 grid-cols-12 cc-gap" };
const _hoisted_13$1 = { class: "relative my-2 cc-text-xs opacity-60" };
const _sfc_main$4 = /* @__PURE__ */ defineComponent({
  __name: "CreateSwap",
  props: {
    aggList: { type: Array, required: true },
    providerList: { type: Array, required: true }
  },
  setup(__props) {
    var _a;
    const props = __props;
    const storeId = "CreateSwap" + getRandomId();
    const { t } = useTranslation();
    const $q = useQuasar();
    const { adaSymbol } = useAdaSymbol();
    const {
      appAccount,
      accountData
    } = useSelectedAccount();
    const {
      getDecimalNumber,
      mapCryptoSymbol
    } = useFormatter();
    onErrorCaptured((e) => {
      console.error("Wallet: Swap: onErrorCaptured", e);
      return true;
    });
    const isLoaded = computed(() => syncStartAI.value === 0 && syncStartAI$1.value === 0);
    const updatingLimitPrice = ref(false);
    const calculating = ref(false);
    let timeoutCalc = -1;
    let estCounter = 0;
    const muesliPools = ref([]);
    const limitPool = ref(null);
    const swapEstimatePayload = ref(null);
    const swapInfo = ref(null);
    const swapRouteList$1 = ref({});
    const sourceAssets = ref({});
    const targetAssets = ref({});
    const targetAssetCount = ref(0);
    const isSelectionSource = ref(true);
    const selectedSource = ref(accountData.value ? createAdaAsset() : null);
    const selectedTarget = ref(null);
    const sourceIsAda = computed(() => !!selectedSource.value && (selectedSource.value.p.length === 0 || selectedSource.value.p === "."));
    const targetIsAda = computed(() => !!selectedTarget.value && (selectedTarget.value.p.length === 0 || selectedTarget.value.p === "."));
    const sourceMetadata = ref(null);
    const targetMetadata = ref(null);
    const sourceInputError = ref("");
    const targetInputError = ref("");
    const limitEnabled = ref(false);
    const limitPrice = ref("0");
    const marketPrice = ref("0");
    const settings = getSwapSettings(createISwapSettings());
    if (settings.value.aggregator && !((_a = props.aggList) == null ? void 0 : _a.includes(settings.value.aggregator))) {
      delete settings.value.aggregator;
    }
    const isMS = computed(() => {
      var _a2;
      return ((_a2 = swapInfo.value) == null ? void 0 : _a2._dex_) === "MuesliSwap";
    });
    const isDH = computed(() => {
      var _a2;
      return ((_a2 = swapInfo.value) == null ? void 0 : _a2._dex_) === "DexHunter";
    });
    const MSEnabled = computed(() => {
      var _a2;
      return ((_a2 = props.aggList) == null ? void 0 : _a2.includes("MuesliSwap")) && (!settings.value.aggregator || settings.value.aggregator === "MuesliSwap");
    });
    const DHEnabled = computed(() => {
      var _a2;
      return ((_a2 = props.aggList) == null ? void 0 : _a2.includes("DexHunter")) && (!settings.value.aggregator || settings.value.aggregator === "DexHunter");
    });
    const sourceDecimals = computed(() => {
      var _a2, _b;
      return ((_b = (_a2 = sourceMetadata.value) == null ? void 0 : _a2.tr) == null ? void 0 : _b.d) ?? 0;
    });
    const targetDecimals = computed(() => {
      var _a2, _b;
      return ((_b = (_a2 = targetMetadata.value) == null ? void 0 : _a2.tr) == null ? void 0 : _b.d) ?? 0;
    });
    const pairDecimalNbr = computed(() => {
      const sourceNbr = sourceDecimals.value > 0 ? getDecimalNumber(sourceDecimals.value) : 1;
      const targetNbr = targetDecimals.value > 0 ? getDecimalNumber(targetDecimals.value) : 1;
      return divide(sourceNbr, targetNbr);
    });
    const priceInverted = () => {
      if (muesliPools.value.length === 0) {
        return false;
      }
      const sourceTokenId = selectedSource.value.p + "." + selectedSource.value.t.a;
      return muesliPools.value[0].tokenA.token !== sourceTokenId;
    };
    const sourceName = computed(() => {
      var _a2, _b, _c;
      if (!selectedSource.value) {
        return "";
      }
      return mapCryptoSymbol(sourceIsAda.value ? "ADA" : ((_b = (_a2 = sourceMetadata.value) == null ? void 0 : _a2.tr) == null ? void 0 : _b.t) ?? ((_c = sourceMetadata.value) == null ? void 0 : _c.n) ?? formatAssetName(selectedSource.value.t.a));
    });
    const targetName = computed(() => {
      var _a2, _b, _c;
      if (!selectedTarget.value) {
        return "";
      }
      return mapCryptoSymbol(targetIsAda.value ? "ADA" : ((_b = (_a2 = targetMetadata.value) == null ? void 0 : _a2.tr) == null ? void 0 : _b.t) ?? ((_c = targetMetadata.value) == null ? void 0 : _c.n) ?? formatAssetName(selectedTarget.value.t.a));
    });
    const hasInputError = computed(() => sourceInputError.value.length > 0 || targetInputError.value.length > 0);
    const eternlFee = computed(() => {
      if (!selectedSource.value || !selectedTarget.value || !swapInfo.value) {
        return "0";
      }
      if (sourceIsAda.value) {
        return getEternlFee(selectedSource.value.a, swapInfo.value._dex_);
      } else if (targetIsAda.value) {
        return getEternlFee(selectedTarget.value.a, swapInfo.value._dex_);
      }
      return "0";
    });
    function createAdaAsset(isTarget = false) {
      return {
        p: "",
        t: {
          a: "",
          q: isTarget ? "0" : accountData.value ? accountData.value.balance.total : "0"
        },
        a: ""
      };
    }
    function onSourceInputError(error) {
      sourceInputError.value = error;
    }
    function onSourceAssetInfoUpd(_assetInfo) {
      if (selectedSource.value) {
        sourceMetadata.value = _assetInfo;
        onSourceAssetUpdate(selectedSource.value);
      }
    }
    function onTargetAssetInfoUpd(_assetInfo) {
      targetMetadata.value = _assetInfo;
      if (selectedSource.value) {
        onSourceAssetUpdate(selectedSource.value);
      }
    }
    function onTargetInputError(error) {
      targetInputError.value = error;
    }
    function updateTargetAssets() {
      if (!selectedSource.value) {
        return;
      }
      if (selectedSource.value.p.length === 0) {
        targetAssets.value = swapRouteList$1.value;
        targetAssetCount.value = _targetAssetCount;
      } else {
        targetAssets.value = { "": { "": "0" } };
        targetAssetCount.value = 1;
      }
    }
    async function getBestLimitPrice() {
      var _a2, _b;
      let bestPrice = "0";
      if (!selectedSource.value || !selectedTarget.value) {
        return bestPrice;
      }
      while (updatingLimitPrice.value) {
        await sleep(100);
        if (!updatingLimitPrice.value) {
          return null;
        }
      }
      updatingLimitPrice.value = true;
      if (MSEnabled.value) {
        bestPrice = ((_a2 = getBestPoolSimple()) == null ? void 0 : _a2.price.toString()) ?? "0";
        if (!isZero(bestPrice)) {
          bestPrice = sourceIsAda.value ? divide(bestPrice, pairDecimalNbr.value) : multiply(bestPrice, pairDecimalNbr.value);
        }
      }
      if (DHEnabled.value && accountData.value) {
        const sourceToken = sourceIsAda.value ? "ADA" : selectedSource.value.p + selectedSource.value.t.a;
        const targetToken = targetIsAda.value ? "ADA" : selectedTarget.value.p + selectedTarget.value.t.a;
        const dhPrice = ((_b = await fetchAvgPrice(networkId.value, accountData.value.account.id, sourceToken, targetToken)) == null ? void 0 : _b.toString()) ?? "0";
        if (isZero(bestPrice) || compare(dhPrice, "<", bestPrice)) {
          bestPrice = dhPrice;
        }
      }
      updatingLimitPrice.value = false;
      return sourceIsAda.value || isZero(bestPrice) ? bestPrice : divide(1, bestPrice);
    }
    async function onSourceAssetSelect(token) {
      var _a2;
      if (selectedSource.value && isEqualAssetList([selectedSource.value], [token])) {
        return;
      }
      selectedSource.value = token;
      sourceMetadata.value = await getAssetInfo(token.p, token.t.a);
      updateTargetAssets();
      if (targetAssetCount.value === 1) {
        const entry = Object.entries(targetAssets.value)[0];
        const asset = Object.entries(entry[1])[0];
        selectedTarget.value = {
          p: entry[0],
          t: { a: asset[0], q: asset[1] },
          a: ""
        };
        targetMetadata.value = getSwapAssetInfo(entry[0], asset[0]) ?? getSwapAssetInfo$1(entry[0], asset[0]);
      }
      if (selectedTarget.value) {
        if (!((_a2 = targetAssets.value[selectedTarget.value.p]) == null ? void 0 : _a2[selectedTarget.value.t.a])) {
          selectedTarget.value = null;
        } else {
          selectedTarget.value.a = "";
        }
      }
      if (selectedSource.value && selectedTarget.value) {
        await onPairSelected();
      }
    }
    async function onSourceAssetUpdate(token) {
      isSelectionSource.value = true;
      if (!selectedSource.value) {
        return;
      }
      selectedSource.value.a = token.a;
      if (limitEnabled.value && isZero(limitPrice.value ?? "0")) {
        marketPrice.value = await getBestLimitPrice() ?? marketPrice.value;
        limitPrice.value = marketPrice.value;
      }
      if (token.a.length === 0 || isZero(token.a)) {
        swapInfo.value = null;
        selectedTarget.value ? selectedTarget.value.a = "" : false;
        return;
      }
      if (!selectedTarget.value) {
        return;
      }
      calculating.value = true;
      clearTimeout(timeoutCalc);
      const _estCounter = ++estCounter;
      timeoutCalc = setTimeout(async () => {
        var _a2, _b;
        if (!selectedSource.value || !selectedTarget.value) {
          calculating.value = false;
          return;
        }
        let _swapInfo = null;
        let _bestEst = "0";
        let _bestPrice = "0";
        if (limitEnabled.value) {
          const sourceAmount = divide(selectedSource.value.a, pairDecimalNbr.value);
          selectedTarget.value.a = limitPrice.value ? divideByLimitPrice(sourceAmount) : "";
          if (MSEnabled.value) {
            _swapInfo = selectBestPool(
              selectedSource.value,
              selectedSource.value.a,
              muesliPools.value,
              ((_a2 = settings.value) == null ? void 0 : _a2.slippage) ?? defaultSlippage,
              sourceDecimals.value,
              targetDecimals.value,
              limitPrice.value,
              priceInverted(),
              pairDecimalNbr.value,
              selectedSource.value,
              selectedTarget.value,
              isSelectionSource.value,
              limitEnabled.value
            ).info;
            _bestPrice = _swapInfo ? getEffPriceMS(_swapInfo.estReceive, _swapInfo.pool.batcherFee.amount) : "0";
            limitPool.value = _swapInfo ? _swapInfo.pool : null;
            onPoolCheckLiquidity(limitPool.value);
          }
          if (DHEnabled.value) {
            const swapInfoDH = isZero(limitPrice.value ?? "0") ? null : await getDHEstimate();
            if ((swapInfoDH == null ? void 0 : swapInfoDH.total_input) && (swapInfoDH == null ? void 0 : swapInfoDH.total_output) && (swapInfoDH == null ? void 0 : swapInfoDH.batcher_fee)) {
              const effPriceDH = getEffPriceDH(swapInfoDH.total_input, swapInfoDH.total_output, swapInfoDH.batcher_fee);
              if (isZero(_bestPrice) || compare(effPriceDH, "<", _bestPrice)) {
                _swapInfo = swapInfoDH;
              }
            }
          }
        } else {
          if (MSEnabled.value) {
            const bestPool = selectBestPool(
              selectedSource.value,
              selectedSource.value.a,
              muesliPools.value,
              ((_b = settings.value) == null ? void 0 : _b.slippage) ?? defaultSlippage,
              sourceDecimals.value,
              targetDecimals.value,
              limitPrice.value,
              priceInverted(),
              pairDecimalNbr.value,
              selectedSource.value,
              selectedTarget.value,
              isSelectionSource.value,
              limitEnabled.value
            );
            _swapInfo = bestPool.info;
            _bestEst = (_swapInfo == null ? void 0 : _swapInfo.estReceive) ?? "0";
            _bestPrice = _swapInfo ? getEffPriceMS(_swapInfo.estReceive, _swapInfo.pool.batcherFee.amount) : "0";
          }
          if (DHEnabled.value) {
            const swapInfoDH = await getDHEstimate();
            if ((swapInfoDH == null ? void 0 : swapInfoDH.total_input) && (swapInfoDH == null ? void 0 : swapInfoDH.total_output_without_slippage) && (swapInfoDH == null ? void 0 : swapInfoDH.batcher_fee)) {
              const effPriceDH = getEffPriceDH(swapInfoDH.total_input, swapInfoDH.total_output_without_slippage, swapInfoDH.batcher_fee);
              if (isZero(_bestPrice) || compare(effPriceDH, "<", _bestPrice)) {
                _bestEst = multiply(swapInfoDH.total_output_without_slippage, getDecimalNumber(targetDecimals.value));
                _swapInfo = swapInfoDH;
              }
            }
          }
          if (_estCounter !== estCounter) {
            return;
          }
          selectedTarget.value.a = round(_bestEst, 0, "down");
        }
        if (_estCounter !== estCounter) {
          return;
        }
        swapInfo.value = _swapInfo;
        if (!swapInfo.value) {
          $q.notify({
            type: "warning",
            message: t("wallet.swap.error.noPoolMatch"),
            position: "top-left",
            timeout: 4e3
          });
        }
        calculating.value = false;
      }, 500);
    }
    async function onTargetAssetSelect(token) {
      if (selectedTarget.value && isEqualAssetList([selectedTarget.value], [token])) {
        return;
      }
      swapInfo.value = null;
      selectedTarget.value = token;
      targetMetadata.value = getSwapAssetInfo(token.p, token.t.a) ?? getSwapAssetInfo$1(token.p, token.t.a);
      if (selectedSource.value && selectedTarget.value) {
        await onPairSelected();
        if (selectedSource.value.a.length > 0 && !isZero(selectedSource.value.a)) {
          onSourceAssetUpdate(selectedSource.value);
        }
      }
    }
    async function onTargetAssetUpdate(token) {
      isSelectionSource.value = false;
      if (!selectedTarget.value) {
        return;
      }
      if (limitEnabled.value && isZero(limitPrice.value ?? "0")) {
        marketPrice.value = await getBestLimitPrice() ?? marketPrice.value;
        limitPrice.value = marketPrice.value;
      }
      selectedTarget.value.a = token.a;
      if (token.a.length === 0 || isZero(token.a)) {
        swapInfo.value = null;
        selectedSource.value ? selectedSource.value.a = "" : false;
        return;
      }
      calculating.value = true;
      clearTimeout(timeoutCalc);
      const _estCounter = ++estCounter;
      timeoutCalc = setTimeout(async () => {
        var _a2, _b, _c;
        if (!selectedSource.value || !selectedTarget.value) {
          calculating.value = false;
          return;
        }
        let _swapInfo = null;
        let _bestEst = "0";
        let _bestPrice = "0";
        if (limitEnabled.value) {
          const targetAmount = multiply(selectedTarget.value.a, pairDecimalNbr.value);
          selectedSource.value.a = limitPrice.value ? multiplyByLimitPrice(targetAmount) : "";
          if (MSEnabled.value) {
            _swapInfo = selectBestPool(
              selectedTarget.value,
              selectedTarget.value.a,
              muesliPools.value,
              ((_a2 = settings.value) == null ? void 0 : _a2.slippage) ?? defaultSlippage,
              sourceDecimals.value,
              targetDecimals.value,
              limitPrice.value,
              priceInverted(),
              pairDecimalNbr.value,
              selectedSource.value,
              selectedTarget.value,
              isSelectionSource.value,
              limitEnabled.value
            ).info;
            _bestPrice = _swapInfo ? getEffPriceMS(_swapInfo.estReceive, _swapInfo.pool.batcherFee.amount) : "0";
            limitPool.value = (_swapInfo == null ? void 0 : _swapInfo.pool) ?? null;
            onPoolCheckLiquidity(limitPool.value);
          }
          if (DHEnabled.value) {
            const swapInfoDH = isZero(limitPrice.value ?? "0") ? null : await getDHEstimate(true);
            if ((swapInfoDH == null ? void 0 : swapInfoDH.total_input) && (swapInfoDH == null ? void 0 : swapInfoDH.total_output) && (swapInfoDH == null ? void 0 : swapInfoDH.batcher_fee)) {
              const effPriceDH = getEffPriceDH(swapInfoDH.total_input, swapInfoDH.total_output, swapInfoDH.batcher_fee);
              if (isZero(_bestPrice) || compare(effPriceDH, ">", _bestPrice)) {
                _swapInfo = swapInfoDH;
              }
            }
          }
        } else {
          if (MSEnabled.value) {
            const bestPool = selectBestPool(
              selectedTarget.value,
              selectedTarget.value.a,
              muesliPools.value,
              ((_b = settings.value) == null ? void 0 : _b.slippage) ?? defaultSlippage,
              sourceDecimals.value,
              targetDecimals.value,
              limitPrice.value,
              priceInverted(),
              pairDecimalNbr.value,
              selectedSource.value,
              selectedTarget.value,
              isSelectionSource.value,
              limitEnabled.value
            );
            _swapInfo = bestPool.info;
            _bestEst = bestPool.amount;
            _bestPrice = _swapInfo ? getEffPriceMS(bestPool.amount, _swapInfo.pool.batcherFee.amount) : "0";
          }
          if (DHEnabled.value) {
            const swapInfoDH = await getDHEstimate(true);
            if ((swapInfoDH == null ? void 0 : swapInfoDH.total_input_without_slippage) && swapInfoDH.total_output && (swapInfoDH == null ? void 0 : swapInfoDH.batcher_fee)) {
              const effPriceDH = getEffPriceDH(swapInfoDH.total_input_without_slippage, swapInfoDH.total_output, swapInfoDH.batcher_fee);
              if (isZero(_bestPrice) || compare(effPriceDH, ">", _bestPrice)) {
                const min_receive = subtract(swapInfoDH.total_output, multiply(swapInfoDH.total_output, ((_c = settings.value) == null ? void 0 : _c.slippage) ?? defaultSlippage));
                swapInfoDH.total_output_without_slippage = swapInfoDH.total_output;
                swapInfoDH.total_output = parseFloat(min_receive);
                _bestEst = multiply(swapInfoDH.total_input_without_slippage, getDecimalNumber(sourceDecimals.value));
                _swapInfo = swapInfoDH;
              }
            }
          }
          if (_estCounter !== estCounter) {
            return;
          }
          selectedSource.value.a = round(_bestEst, 0, "up");
        }
        if (_estCounter !== estCounter) {
          return;
        }
        swapInfo.value = _swapInfo;
        if (!swapInfo.value) {
          $q.notify({
            type: "warning",
            message: t("wallet.swap.error.noPoolMatch"),
            position: "top-left",
            timeout: 4e3
          });
        }
        calculating.value = false;
      }, 500);
    }
    function onLimitEnabled(enabled) {
      limitEnabled.value = enabled;
      swapInfo.value = null;
      limitPrice.value = "0";
      if (selectedSource.value && selectedTarget.value) {
        isSelectionSource.value ? onSourceAssetUpdate(selectedSource.value) : onTargetAssetUpdate(selectedTarget.value);
      }
    }
    const divideByLimitPrice = (sourceAmount) => {
      if (isZero(limitPrice.value)) {
        return "";
      } else {
        return round(divide(sourceAmount, limitPrice.value), 0, "down");
      }
    };
    const multiplyByLimitPrice = (targetAmount) => {
      if (isZero(limitPrice.value)) {
        return "";
      } else {
        return round(multiply(targetAmount, limitPrice.value), 0, "up");
      }
    };
    function onLimitPriceUpdate(price) {
      if (!selectedSource.value || !selectedTarget.value) {
        return;
      }
      limitPrice.value = isZero(price ?? "0") ? "0" : price;
      if (limitPrice.value === "0") {
        swapInfo.value = null;
        return;
      }
      if (selectedSource.value && selectedTarget.value) {
        isSelectionSource.value ? onSourceAssetUpdate(selectedSource.value) : onTargetAssetUpdate(selectedTarget.value);
      }
    }
    function onLimitPriceReset() {
      limitPrice.value = "0";
      if (selectedSource.value && selectedTarget.value) {
        isSelectionSource.value ? onSourceAssetUpdate(selectedSource.value) : onTargetAssetUpdate(selectedTarget.value);
      }
    }
    function onPoolCheckLiquidity(pool) {
      if (!pool || !selectedSource.value || !selectedTarget.value) {
        return false;
      }
      let poolValid = true;
      if (isSelectionSource.value) {
        const tokenId = selectedSource.value.p + "." + selectedSource.value.t.a;
        if (pool.tokenA.token === tokenId && compare(pool.tokenA.amount, "<", selectedSource.value.a) || pool.tokenB.token === tokenId && compare(pool.tokenB.amount, "<", selectedSource.value.a)) {
          poolValid = false;
        }
      } else {
        const tokenId = selectedTarget.value.p + "." + selectedTarget.value.t.a;
        if (pool.tokenA.token === tokenId && compare(pool.tokenA.amount, "<", selectedTarget.value.a) || pool.tokenB.token === tokenId && compare(pool.tokenB.amount, "<", selectedTarget.value.a)) {
          poolValid = false;
        }
      }
      if (!poolValid) {
        $q.notify({
          type: "warning",
          message: t("wallet.swap.error.lowLiqudityInPool"),
          position: "top-left",
          timeout: 4e3
        });
        return false;
      }
      return true;
    }
    async function onClearSwapSelection() {
      selectedSource.value = accountData.value ? createAdaAsset() : null;
      sourceMetadata.value = await getAssetInfo("", "");
      selectedTarget.value = null;
      targetMetadata.value = null;
      swapInfo.value = null;
      limitEnabled.value = false;
      limitPrice.value = "0";
      muesliPools.value.splice(0);
      updateTargetAssets();
    }
    async function onPairSelected() {
      var _a2, _b;
      limitPrice.value = "0";
      if (!selectedSource.value || !selectedTarget.value) {
        return;
      }
      if (!settings.value.aggregator || settings.value.aggregator === "MuesliSwap") {
        muesliPools.value = (await fetchSwapPools(networkId.value, selectedSource.value, selectedTarget.value)).filter((p) => {
          var _a3;
          return ((_a3 = swapProviderList.value) == null ? void 0 : _a3.includes(p.provider)) && !settings.value.blacklist.includes(getProvider(p.provider, props.providerList).id);
        });
        if (limitEnabled.value) {
          swapInfo.value = selectBestPool(
            selectedSource.value,
            selectedSource.value.a,
            muesliPools.value,
            ((_a2 = settings.value) == null ? void 0 : _a2.slippage) ?? defaultSlippage,
            sourceDecimals.value,
            targetDecimals.value,
            limitPrice.value,
            priceInverted(),
            pairDecimalNbr.value,
            selectedSource.value,
            selectedTarget.value,
            isSelectionSource.value,
            limitEnabled.value
          ).info;
          limitPool.value = ((_b = swapInfo.value) == null ? void 0 : _b.pool) ?? getBestPoolSimple();
        }
      }
      if (limitEnabled.value) {
        marketPrice.value = await getBestLimitPrice() ?? marketPrice.value;
      }
    }
    function getBestPoolSimple() {
      if (muesliPools.value.length > 0) {
        let bestPool = muesliPools.value[0];
        for (let i = 1; i < muesliPools.value.length; i++) {
          if (compare(muesliPools.value[i].price, "<", bestPool.price)) {
            bestPool = muesliPools.value[i];
          }
        }
        return bestPool;
      }
      return null;
    }
    function getEffPriceMS(totalOutput, batcherFee) {
      if (!selectedSource.value || !selectedTarget.value) {
        return "0";
      }
      const sourceAmount = isSelectionSource.value ? selectedSource.value.a : totalOutput;
      const targetAmount = isSelectionSource.value ? totalOutput : selectedTarget.value.a;
      if (sourceIsAda.value) {
        const eternlFee2 = getEternlFee(sourceAmount);
        const lovelace = add(add(sourceAmount, eternlFee2), batcherFee);
        return divide(lovelace, targetAmount);
      } else {
        const eternlFee2 = getEternlFee(targetAmount);
        const lovelace = add(add(targetAmount, eternlFee2), batcherFee);
        return divide(lovelace, sourceAmount);
      }
    }
    function getEffPriceDH(totalInput, totalOutput, batcherFee) {
      if (!selectedSource.value) {
        return "0";
      }
      const inputDH = multiply(totalInput, getDecimalNumber(sourceDecimals.value));
      const outputDH = multiply(totalOutput, getDecimalNumber(targetDecimals.value));
      if (sourceIsAda.value) {
        const eternlFee2 = getEternlFee(inputDH);
        const lovelace = add(add(inputDH, eternlFee2), multiply(batcherFee, getDecimalNumber(6)));
        return divide(lovelace, outputDH);
      } else {
        const eternlFee2 = getEternlFee(outputDH);
        const lovelace = add(add(outputDH, eternlFee2), multiply(batcherFee, getDecimalNumber(6)));
        return divide(lovelace, inputDH);
      }
    }
    async function onSwapDirection() {
      var _a2, _b;
      if (!accountData.value || !selectedSource.value || !selectedTarget.value) {
        return;
      }
      let newSource = null;
      let newTarget = null;
      if (targetIsAda.value) {
        newSource = createAdaAsset();
        newTarget = json(selectedSource.value);
        newTarget.a = "";
        newTarget.t.q = "0";
      } else {
        const ownAsset = ((_b = (_a2 = accountData.value.balance.multiasset) == null ? void 0 : _a2[selectedTarget.value.p]) == null ? void 0 : _b[selectedTarget.value.t.a]) ?? null;
        if (ownAsset) {
          newSource = {
            p: selectedTarget.value.p,
            t: {
              a: selectedTarget.value.t.a,
              q: ownAsset
            },
            a: ""
          };
          newTarget = createAdaAsset(true);
        } else {
          $q.notify({
            type: "warning",
            message: t("wallet.swap.error.tokenNotFound"),
            position: "top-left",
            timeout: 4e3
          });
        }
      }
      if (!newSource) {
        return;
      }
      sourceMetadata.value = await getAssetInfo(newSource.p, newSource.t.a);
      targetMetadata.value = newTarget ? getSwapAssetInfo(newTarget.p, newTarget.t.a) ?? getSwapAssetInfo$1(newTarget.p, newTarget.t.a) : null;
      selectedSource.value = newSource;
      selectedTarget.value = newTarget;
      updateTargetAssets();
      if (limitEnabled.value) {
        await nextTick(async () => {
          limitPrice.value = "0";
          marketPrice.value = await getBestLimitPrice() ?? marketPrice.value;
        });
      }
    }
    async function onSwap() {
      if (isMS.value) {
        await onSwapMS();
      } else if (isDH.value) {
        await onSwapDH();
      }
    }
    async function onSwapMS() {
      $q.loading.show({
        boxClass: "cc-bg-overlay",
        message: t("wallet.swap.create.building")
      });
      const swapDatum = await constructSwapDatum();
      $q.loading.hide();
      if (!swapDatum) {
        return;
      }
      const pool = limitEnabled.value ? limitPool.value : swapInfo.value.pool ?? null;
      const swapTx = {
        sellAsset: selectedSource.value,
        buyAsset: selectedTarget.value,
        swapDatum,
        swapPool: pool
      };
      if (!isZero(eternlFee.value)) {
        swapTx.fee = eternlFee.value;
      }
      if (limitEnabled.value) {
        swapTx.isLimitOrder = true;
      }
      addSignalListener(onBuiltTxSwap, "CreateSwap", (res, error) => {
        removeSignalListener(onBuiltTxSwap, "CreateSwap");
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
      await dispatchSignal(doBuildTxSwap, swapTx);
      removeSignalListener(onBuiltTxSwap, "CreateSwap");
    }
    async function getDHEstimate(reverse = false) {
      var _a2;
      if (!accountData.value || !selectedSource.value || !selectedTarget.value) {
        return;
      }
      try {
        swapEstimatePayload.value = {
          blacklisted_dexes: settings.value.blacklist.map((dex) => dex.toUpperCase()),
          slippage: (((_a2 = settings.value) == null ? void 0 : _a2.slippage) ?? defaultSlippage) * 100,
          token_in: selectedSource.value.p + selectedSource.value.t.a,
          token_out: selectedTarget.value.p + selectedTarget.value.t.a
        };
        if (reverse && !limitEnabled.value) {
          swapEstimatePayload.value.amount_out = parseFloat(divide(selectedTarget.value.a, getDecimalNumber(targetDecimals.value)));
        } else {
          swapEstimatePayload.value.amount_in = parseFloat(divide(selectedSource.value.a, getDecimalNumber(sourceDecimals.value)));
        }
        if (limitEnabled.value) {
          swapEstimatePayload.value.wanted_price = parseFloat(targetIsAda.value ? divide(1, limitPrice.value) : limitPrice.value);
          swapEstimatePayload.value.to_split = true;
          swapEstimatePayload.value.multiples = 1;
        }
        return await fetchSwapEstimate(networkId.value, accountData.value.account.id, swapEstimatePayload.value, reverse, limitEnabled.value);
      } catch (err) {
        console.error("Catched: onDHEstimate <<<err>>>");
        console.error(err);
        swapEstimatePayload.value = null;
      }
    }
    async function onSwapDH() {
      if (!swapInfo.value || !swapEstimatePayload.value || !accountData.value || !appAccount.value) {
        return;
      }
      $q.loading.show({
        boxClass: "cc-bg-overlay",
        message: t("wallet.swap.create.building")
      });
      try {
        swapEstimatePayload.value.buyer_address = getRootAddress(accountData.value).bech32;
        swapEstimatePayload.value.amount_in = parseFloat(divide(selectedSource.value.a, getDecimalNumber(sourceDecimals.value)));
        const swapCbor = await createSwapOrder(networkId.value, accountData.value.account.id, swapEstimatePayload.value, limitEnabled.value);
        if (!swapCbor) {
          throw "DexHunter API failed to build tx, please try again or contact support if recurring.";
        }
        await parseTxSignRequest(appAccount.value, "cc", [
          {
            cbor: swapCbor,
            partialSign: false
          }
        ], null);
      } catch (err) {
        console.error("Catched: onSwapDH <<<err>>>");
        console.error(err);
        $q.notify({
          type: "negative",
          message: getErrorMsg(err),
          position: "top-left",
          timeout: 8e3
        });
      } finally {
        $q.loading.hide();
      }
    }
    async function constructSwapDatum() {
      let error = "";
      if (accountData.value && swapInfo.value) {
        const _swapInfo = swapInfo.value;
        try {
          const addrBech32 = getRootAddress(accountData.value).bech32;
          const buyTokenPolicyID = targetIsAda.value ? '""' : selectedTarget.value.p;
          const buyTokenNameHex = selectedTarget.value.t.a.length === 0 ? '""' : selectedTarget.value.t.a;
          const sellTokenPolicyID = sourceIsAda.value ? '""' : selectedSource.value.p;
          const sellTokenNameHex = selectedSource.value.t.a.length === 0 ? '""' : selectedSource.value.t.a;
          const buyAmount = _swapInfo.minReceive;
          const sellAmount = round(selectedSource.value.a, 0, "up");
          const protocol = limitEnabled.value ? limitPool.value.provider : _swapInfo.pool.provider;
          const poolId = limitEnabled.value ? limitPool.value.poolId : _swapInfo.pool.poolId;
          const swapDatum = await fetchSwapDatum(
            networkId.value,
            addrBech32,
            buyTokenPolicyID,
            buyTokenNameHex,
            sellTokenPolicyID,
            sellTokenNameHex,
            buyAmount,
            sellAmount,
            protocol,
            poolId
          );
          if (swapDatum) {
            return swapDatum;
          } else {
            error = t("wallet.swap.error.network");
            console.error("constructSwapDatum:", error);
          }
        } catch (err) {
          error = (err == null ? void 0 : err.message) ?? err;
          console.error("constructSwapDatum:", networkId.value, (err == null ? void 0 : err.message) ?? err);
        }
      }
      $q.notify({
        type: "negative",
        message: t("wallet.swap.error.constructSwapDatum") + (error.length > 0 ? `<br>Error: ${error}` : ""),
        position: "top-left",
        timeout: 5e3,
        html: true
      });
      return null;
    }
    function onSaveSettings(_settings) {
      setSwapSettings(_settings);
      onPairSelected();
      if (selectedSource.value && isSelectionSource.value) {
        onSourceAssetUpdate(selectedSource.value);
      } else if (selectedTarget.value && !isSelectionSource.value) {
        onTargetAssetUpdate(selectedTarget.value);
      }
    }
    let _targetAssetCount = 0;
    const initializeData = async (silent = false) => {
      var _a2, _b, _c, _d, _e, _f;
      removeSignalListener(onAccountDataUpdated, storeId);
      if (!accountData.value) {
        return;
      }
      const adaAsset = createAdaAsset();
      selectedSource.value = adaAsset;
      sourceMetadata.value = await getAssetInfo("", "");
      sourceAssets.value[""] = { "": adaAsset.t.q };
      const _swapRouteList = {};
      if ((!swapRouteList.value || swapRouteList.value.length === 0) && Object.keys(verifiedAssetMap.value).length === 0) {
        if (!silent) {
          $q.notify({
            type: "negative",
            message: t("wallet.swap.error.routesNotFound"),
            position: "top-left",
            timeout: 5e3
          });
        }
        swapRouteList$1.value = _swapRouteList;
        return;
      }
      if (swapRouteList.value) {
        for (const route of swapRouteList.value) {
          if (route.p.length === 0) {
            for (const asset of route.l) {
              const quantity = ((_b = (_a2 = accountData.value.balance.multiasset) == null ? void 0 : _a2[asset.p]) == null ? void 0 : _b[asset.h]) ?? null;
              if (quantity) {
                if (!sourceAssets.value[asset.p]) {
                  sourceAssets.value[asset.p] = {};
                }
                sourceAssets.value[asset.p][asset.h] = quantity;
              }
              if (!_swapRouteList[asset.p]) {
                _swapRouteList[asset.p] = { [asset.h]: "0" };
              } else {
                _swapRouteList[asset.p][asset.h] = "0";
              }
              _targetAssetCount++;
            }
            break;
          }
        }
      }
      for (const entry of Object.entries(verifiedAssetMap.value)) {
        const policy = entry[0];
        for (const asset of entry[1]) {
          const quantity = ((_d = (_c = accountData.value.balance.multiasset) == null ? void 0 : _c[policy]) == null ? void 0 : _d[asset]) ?? null;
          if (quantity && !((_e = sourceAssets.value[policy]) == null ? void 0 : _e[asset])) {
            if (!sourceAssets.value[policy]) {
              sourceAssets.value[policy] = {};
            }
            sourceAssets.value[policy][asset] = quantity;
          }
          const alreadyAdded = !!((_f = _swapRouteList[policy]) == null ? void 0 : _f[asset]);
          if (!alreadyAdded) {
            if (!_swapRouteList[policy]) {
              _swapRouteList[policy] = { [asset]: "0" };
            } else {
              _swapRouteList[policy][asset] = "0";
            }
            _targetAssetCount++;
          }
        }
      }
      swapRouteList$1.value = _swapRouteList;
      targetAssetCount.value = _targetAssetCount;
      updateTargetAssets();
      addSignalListener(onAccountDataUpdated, storeId, updateAdaToken);
    };
    function updateAdaToken(_appAccount) {
      if (!appAccount.value || !accountData.value) {
        return;
      }
      if ((_appAccount == null ? void 0 : _appAccount.id) && appAccount.value.id !== (_appAccount == null ? void 0 : _appAccount.id)) {
        return;
      }
      if (selectedSource.value && selectedSource.value.p.length === 0 && !compare(selectedSource.value.t.q, "==", accountData.value.balance.coin)) {
        selectedSource.value.t.q = accountData.value.balance.coin;
      }
    }
    watch(isLoaded, () => {
      if (isLoaded.value) {
        initializeData();
      }
    });
    watch(marketPrice, (_marketPrice) => {
      if (isZero(limitPrice.value)) {
        limitPrice.value = _marketPrice;
      }
    });
    onMounted(() => {
      if (isLoaded.value) {
        initializeData();
      } else {
        dispatchSignal(doInitSwap);
      }
    });
    onUnmounted(() => {
      removeSignalListener(onAccountDataUpdated, storeId);
    });
    return (_ctx, _cache) => {
      var _a2;
      return openBlock(), createElementBlock(Fragment, null, [
        createVNode(_sfc_main$b, {
          label: unref(t)("wallet.swap.create.headline"),
          class: "col-span-12"
        }, null, 8, ["label"]),
        createVNode(_sfc_main$c, {
          text: unref(t)("wallet.swap.create.caption"),
          class: "col-span-12 cc-text-sz"
        }, null, 8, ["text"]),
        createVNode(GridSpace, { hr: "" }),
        !unref(isCreateSwapEnabled)(unref(networkId)) ? (openBlock(), createBlock(_sfc_main$i, {
          key: 0,
          class: "col-span-12 w-full",
          css: "cc-text-semi-bold cc-rounded cc-banner-warning",
          text: unref(t)("wallet.swap.aggregator.unavailable"),
          icon: "mdi mdi-wrench-clock"
        }, null, 8, ["text"])) : !isLoaded.value ? (openBlock(), createElementBlock("div", _hoisted_1$4, [
          createVNode(QSpinnerDots_default, {
            color: "gray",
            size: "3em"
          })
        ])) : isLoaded.value ? (openBlock(), createElementBlock("div", _hoisted_2$3, [
          createBaseVNode("div", _hoisted_3$2, [
            createBaseVNode("div", _hoisted_4$2, [
              createVNode(_sfc_main$8, {
                enabled: limitEnabled.value,
                onInstant: _cache[0] || (_cache[0] = ($event) => onLimitEnabled(false)),
                onLimit: _cache[1] || (_cache[1] = ($event) => onLimitEnabled(true))
              }, null, 8, ["enabled"]),
              createVNode(_sfc_main$5, {
                "agg-list": __props.aggList,
                "provider-list": __props.providerList,
                "limit-order": limitEnabled.value,
                settings: unref(settings) ?? void 0,
                onSave: onSaveSettings
              }, null, 8, ["agg-list", "provider-list", "limit-order", "settings"])
            ]),
            isLoaded.value && unref(accountData) ? (openBlock(), createElementBlock("div", _hoisted_5$1, [
              createBaseVNode("div", _hoisted_6$1, [
                createVNode(_sfc_main$c, {
                  text: unref(t)("wallet.swap.create.input.from.title"),
                  class: "absolute -top-3 left-6 z-50 cc-tabs-button-static cc-rounded px-2"
                }, null, 8, ["text"]),
                createVNode(_sfc_main$9, {
                  onSelect: onSourceAssetSelect,
                  onUpdate: onSourceAssetUpdate,
                  onInputError: onSourceInputError,
                  onAssetInfoUpd: onSourceAssetInfoUpd,
                  "text-id": "wallet.swap.create.input",
                  "available-assets": sourceAssets.value,
                  "selected-asset": selectedSource.value,
                  assetinfo: sourceMetadata.value,
                  "is-source": true
                }, null, 8, ["available-assets", "selected-asset", "assetinfo"])
              ]),
              createBaseVNode("div", _hoisted_7$1, [
                createBaseVNode("i", {
                  class: normalizeClass(["mdi mdi-arrow-down-thick text-2xl px-1 cc-rounded", selectedSource.value && selectedTarget.value ? "cc-tabs-button cursor-pointer rotate180" : "cc-tabs-button-static"]),
                  onClick: onSwapDirection
                }, null, 2)
              ]),
              createBaseVNode("div", _hoisted_8$1, [
                createVNode(_sfc_main$c, {
                  text: unref(t)("wallet.swap.create.input.to.title"),
                  class: "absolute -top-3 left-6 z-50 cc-tabs-button-static cc-rounded px-2"
                }, null, 8, ["text"]),
                createVNode(_sfc_main$9, {
                  onSelect: onTargetAssetSelect,
                  onUpdate: onTargetAssetUpdate,
                  onInputError: onTargetInputError,
                  onAssetInfoUpd: onTargetAssetInfoUpd,
                  "text-id": "wallet.swap.create.input",
                  "available-assets": targetAssets.value,
                  "selected-asset": selectedTarget.value,
                  assetinfo: targetMetadata.value,
                  "is-source": false,
                  disabled: !selectedSource.value || targetAssetCount.value === 1
                }, null, 8, ["available-assets", "selected-asset", "assetinfo", "disabled"])
              ])
            ])) : createCommentVNode("", true),
            limitEnabled.value && selectedSource.value && selectedTarget.value ? (openBlock(), createElementBlock("div", _hoisted_9$1, [
              createVNode(_sfc_main$7, {
                "limit-price": limitPrice.value,
                "market-price": marketPrice.value,
                "source-metadata": sourceMetadata.value,
                "target-metadata": targetMetadata.value,
                "source-name": sourceName.value,
                "target-name": targetName.value,
                "updating-price": updatingLimitPrice.value,
                onPriceUpdate: onLimitPriceUpdate,
                onPriceReset: onLimitPriceReset
              }, null, 8, ["limit-price", "market-price", "source-metadata", "target-metadata", "source-name", "target-name", "updating-price"])
            ])) : createCommentVNode("", true),
            swapInfo.value && selectedSource.value && selectedSource.value.a.length > 0 && !isZero(selectedSource.value.a) && selectedTarget.value && selectedTarget.value.a.length > 0 && !isZero(selectedTarget.value.a) ? (openBlock(), createBlock(_sfc_main$6, {
              key: 2,
              "provider-list": __props.providerList,
              "selected-source": selectedSource.value,
              "selected-target": selectedTarget.value,
              "source-metadata": sourceMetadata.value,
              "target-metadata": targetMetadata.value,
              "source-name": sourceName.value,
              "target-name": targetName.value,
              "eternl-fee": eternlFee.value,
              slippage: ((_a2 = unref(settings)) == null ? void 0 : _a2.slippage) ?? unref(defaultSlippage),
              "is-limit-order": limitEnabled.value,
              "swap-info": swapInfo.value,
              calculating: calculating.value
            }, null, 8, ["provider-list", "selected-source", "selected-target", "source-metadata", "target-metadata", "source-name", "target-name", "eternl-fee", "slippage", "is-limit-order", "swap-info", "calculating"])) : calculating.value ? (openBlock(), createElementBlock("div", _hoisted_10$1, [
              createVNode(_sfc_main$c, {
                text: unref(t)("wallet.swap.create.estimate")
              }, null, 8, ["text"]),
              createVNode(QSpinnerDots_default, {
                color: "gray",
                size: "2em"
              })
            ])) : createCommentVNode("", true)
          ]),
          unref(settings) && unref(settings).slippage >= 0.5 && !limitEnabled.value ? (openBlock(), createElementBlock("div", _hoisted_11$1, [
            createVNode(IconWarning, { class: "w-7 flex-none mr-2" }),
            createBaseVNode("div", null, toDisplayString(unref(t)("wallet.swap.create.settings.modal.slippage.warning")), 1)
          ])) : createCommentVNode("", true),
          createBaseVNode("div", _hoisted_12$1, [
            selectedSource.value || selectedTarget.value ? (openBlock(), createBlock(_sfc_main$h, {
              key: 0,
              label: unref(t)("common.label.reset"),
              link: onClearSwapSelection,
              class: "col-span-6"
            }, null, 8, ["label"])) : createCommentVNode("", true),
            createVNode(_sfc_main$g, {
              label: unref(t)("wallet.swap.button.swap"),
              link: onSwap,
              disabled: !selectedSource.value || !selectedTarget.value || !swapInfo.value || calculating.value || limitEnabled.value && isZero(limitPrice.value) || hasInputError.value || selectedSource.value.a.length === 0 || selectedTarget.value.a.length === 0 || compare(selectedSource.value.a, "<", "1"),
              class: "col-span-6"
            }, null, 8, ["label", "disabled"])
          ]),
          createBaseVNode("span", _hoisted_13$1, toDisplayString(unref(t)("wallet.swap.create.credit").replace("###AGG###", unref(t)("wallet.swap.aggregator.ms"))), 1)
        ])) : createCommentVNode("", true)
      ], 64);
    };
  }
});
const CreateSwap = /* @__PURE__ */ _export_sfc(_sfc_main$4, [["__scopeId", "data-v-7cbc4af0"]]);
const _hoisted_1$3 = {
  key: 0,
  class: "col-span-12 flex flex-row flex-nowrap items-center"
};
const _hoisted_2$2 = { class: "col-span-12 flex flex-row flex-nowrap justify-between space-x-4" };
const _hoisted_3$1 = { class: "flex flex-row flex-nowrap items-center" };
const _hoisted_4$1 = ["src"];
const _hoisted_5 = { class: "col-span-12 flex flex-row flex-nowrap justify-between space-x-4" };
const _hoisted_6 = { class: "whitespace-nowrap" };
const _hoisted_7 = { class: "col-span-12 flex flex-row flex-nowrap justify-between space-x-4" };
const _hoisted_8 = { class: "whitespace-nowrap" };
const _hoisted_9 = { class: "col-span-12 flex flex-row flex-nowrap justify-between space-x-4" };
const _hoisted_10 = { class: "whitespace-nowrap" };
const _hoisted_11 = {
  key: 0,
  class: "relative flex flex-row flex-nowrap items-start"
};
const _hoisted_12 = { class: "ml-1" };
const _hoisted_13 = { class: "" };
const _hoisted_14 = {
  key: 1,
  class: "col-span-12 flex flex-col flex-nowrap"
};
const _hoisted_15 = { class: "flex flex-row flex-nowrap justify-between space-x-4" };
const _hoisted_16 = { class: "whitespace-nowrap" };
const _hoisted_17 = {
  key: 0,
  class: "relative flex flex-row flex-nowrap items-start"
};
const _hoisted_18 = { class: "ml-1" };
const _hoisted_19 = { class: "" };
const _hoisted_20 = { class: "whitespace-nowrap cc-text-xs-dense cc-text-color-caption" };
const _hoisted_21 = { class: "col-span-12 flex flex-row flex-nowrap justify-between space-x-4" };
const _hoisted_22 = { class: "whitespace-nowrap" };
const _hoisted_23 = { class: "w-1/2 flex flex-row flex-nowrap" };
const _hoisted_24 = { class: "col-span-12 flex justify-end" };
const _sfc_main$3 = /* @__PURE__ */ defineComponent({
  __name: "OrderItem",
  props: {
    order: { type: Object, required: true },
    aggList: { type: Array, required: true },
    providerList: { type: Array, required: true }
  },
  setup(__props) {
    const props = __props;
    const $q = useQuasar();
    const { t } = useTranslation();
    const {
      getDisplayDecimals,
      getDecimalNumber,
      mapCryptoSymbol
    } = useFormatter();
    const { adaSymbol } = useAdaSymbol();
    const { selectedAccountId } = useSelectedAccount();
    const sourceMetadata = ref(null);
    const targetMetadata = ref(null);
    const outOfRange = ref(false);
    const swapPrice = ref(false);
    const marketPrice = ref(null);
    const isWhole = ref(false);
    const provider = computed(() => {
      return getProvider(props.order.provider ?? props.order.dex, props.providerList);
    });
    const sourceToken = computed(() => {
      if ("from" in props.order) {
        return getToken(props.order.from.token, props.order.from.amount);
      } else if ("token_id_in" in props.order) {
        isWhole.value = true;
        return getToken(props.order.token_id_in, props.order.amount_in.toString());
      } else {
        return null;
      }
    });
    const targetToken = computed(() => {
      if ("to" in props.order) {
        return getToken(props.order.to.token, props.order.to.amount);
      } else if ("token_id_out" in props.order) {
        isWhole.value = true;
        return getToken(props.order.token_id_out, props.order.expected_out_amount.toString());
      } else {
        return null;
      }
    });
    const sourceName = computed(() => {
      var _a, _b;
      if (sourceToken.value == null) {
        return "";
      }
      return mapCryptoSymbol(sourceToken.value.p.length === 0 ? "ADA" : ((_b = (_a = sourceMetadata.value) == null ? void 0 : _a.tr) == null ? void 0 : _b.t) ?? formatAssetName(sourceToken.value.t.a));
    });
    const targetName = computed(() => {
      var _a, _b;
      if (targetToken.value == null) {
        return "";
      }
      return mapCryptoSymbol(targetToken.value.p.length === 0 ? "ADA" : ((_b = (_a = targetMetadata.value) == null ? void 0 : _a.tr) == null ? void 0 : _b.t) ?? formatAssetName(targetToken.value.t.a));
    });
    const sourceAssetListItem = computed(() => {
      var _a, _b;
      if (!sourceToken.value) {
        return null;
      }
      const assetListItem = {
        ...sourceToken.value,
        n: getAssetName(sourceToken.value.t.a, sourceMetadata.value, true),
        f: getAssetIdBech32(sourceToken.value.p, sourceToken.value.t.a)
      };
      if (isWhole.value && !isZero(((_b = (_a = sourceMetadata.value) == null ? void 0 : _a.tr) == null ? void 0 : _b.d) ?? "0")) {
        assetListItem.t.q = multiply(assetListItem.t.q, getDecimalNumber(sourceMetadata.value.tr.d));
      }
      return assetListItem;
    });
    const targetAssetListItem = computed(() => {
      var _a, _b;
      if (!targetToken.value) {
        return null;
      }
      const assetListItem = {
        ...targetToken.value,
        n: getAssetName(targetToken.value.t.a, targetMetadata.value, true),
        f: getAssetIdBech32(targetToken.value.p, targetToken.value.t.a)
      };
      if (isWhole.value && !isZero(((_b = (_a = targetMetadata.value) == null ? void 0 : _a.tr) == null ? void 0 : _b.d) ?? "0")) {
        assetListItem.t.q = multiply(assetListItem.t.q, getDecimalNumber(targetMetadata.value.tr.d));
      }
      return assetListItem;
    });
    const sourceDecimals = computed(() => {
      var _a, _b;
      return ((_b = (_a = sourceMetadata.value) == null ? void 0 : _a.tr) == null ? void 0 : _b.d) ?? 0;
    });
    const targetDecimals = computed(() => {
      var _a, _b;
      return ((_b = (_a = targetMetadata.value) == null ? void 0 : _a.tr) == null ? void 0 : _b.d) ?? 0;
    });
    const sourceIsAda = computed(() => sourceToken.value && (sourceToken.value.p.length === 0 || sourceToken.value.p === "."));
    const targetIsAda = computed(() => targetToken.value && (targetToken.value.p.length === 0 || targetToken.value.p === "."));
    const flipPrice = computed(() => targetIsAda.value && !swapPrice.value || sourceIsAda.value && swapPrice.value);
    const orderPrice = computed(() => {
      if (!sourceMetadata.value || !targetMetadata.value || !sourceToken.value || !targetToken.value) {
        return "0";
      }
      const price = divide(
        divide(sourceToken.value.t.q, getDecimalNumber(sourceDecimals.value)),
        divide(targetToken.value.t.q, getDecimalNumber(targetDecimals.value))
      );
      return flipPrice.value ? divide(1, price) : price;
    });
    const utxo = computed(() => {
      var _a;
      let txHash = "";
      let txIndex = "";
      if (props.order.hasOwnProperty("utxo")) {
        txHash = props.order.utxo.slice(0, 64);
        txIndex = props.order.utxo.slice(65);
      } else if (props.order.hasOwnProperty("tx_hash")) {
        txHash = props.order.tx_hash;
        txIndex = ((_a = props.order.tx_output_index) == null ? void 0 : _a.toString()) ?? "0";
      }
      return { txHash, txIndex, utxo: `${txHash}#${txIndex}` };
    });
    async function onCancelOrder(order) {
      $q.loading.show({
        boxClass: "cc-bg-overlay",
        message: t("wallet.swap.orders.cancel.building")
      });
      addSignalListener(onBuiltTxSwapCancel, "OrderItem", (res, error) => {
        removeSignalListener(onBuiltTxSwapCancel, "OrderItem");
        $q.loading.hide();
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
      await dispatchSignal(doBuildTxSwapCancel, order);
      removeSignalListener(onBuiltTxSwapCancel, "OrderItem");
      $q.loading.hide();
    }
    function getToken(token, amount) {
      if (token === "." || token.length === 0 || token === "000000000000000000000000000000000000000000000000000000006c6f76656c616365") {
        return {
          p: "",
          t: {
            a: "",
            q: amount
          }
        };
      } else {
        token = token.replace(".", "");
        return {
          p: token.slice(0, 56),
          t: {
            a: token.slice(56),
            q: amount
          }
        };
      }
    }
    function getOrderPoolId(order) {
      if ("poolId" in order) {
        return order.poolId;
      } else if ("pool_id" in order) {
        return order.pool_id;
      } else {
        return null;
      }
    }
    function getpairDecimalNbr(sourceDecimals2, targetDecimals2) {
      const sourceNbr = sourceDecimals2 > 0 ? getDecimalNumber(sourceDecimals2) : 1;
      const targetNbr = targetDecimals2 > 0 ? getDecimalNumber(targetDecimals2) : 1;
      return divide(sourceNbr, targetNbr);
    }
    async function checkOrderPriceInRange() {
      var _a, _b;
      if (!sourceToken.value || !targetToken.value) {
        return;
      }
      const pools = [];
      if ((_a = props.aggList) == null ? void 0 : _a.includes("MuesliSwap")) {
        pools.push(...(await fetchSwapPools(networkId.value, sourceToken.value, targetToken.value)).filter((pool) => pool.provider.toLowerCase().includes(provider.value.id)));
      }
      if (pools.length === 0 && ((_b = props.aggList) == null ? void 0 : _b.includes("DexHunter"))) {
        const source = sourceIsAda.value ? "ADA" : sourceToken.value.p + sourceToken.value.t.a;
        const target = targetIsAda.value ? "ADA" : targetToken.value.p + targetToken.value.t.a;
        const lpInfo = await fetchLpInfo(networkId.value, selectedAccountId.value, source, target);
        if (lpInfo) {
          for (const pool of lpInfo.pools) {
            if (getProvider(pool.dexName, props.providerList) !== provider.value) {
              continue;
            }
            if (pool.token1Amount === 0 || pool.token2Amount === 0) {
              continue;
            }
            const sourceAmount = multiply(pool.token1Amount, getDecimalNumber(sourceDecimals.value));
            const targetAmount = multiply(pool.token2Amount, getDecimalNumber(targetDecimals.value));
            const DHPoolasMSPool = {
              // Partial IPoolEntryMS needed for best pool selection
              provider: pool.dexName,
              fee: 0,
              tokenA: {
                amount: sourceAmount,
                token: `${sourceToken.value.p}.${sourceToken.value.t.a}`
              },
              tokenB: {
                amount: targetAmount,
                token: `${targetToken.value.p}.${targetToken.value.t.a}`
              },
              price: sourceIsAda.value ? parseFloat(divide(sourceAmount, targetAmount)) : parseFloat(divide(targetAmount, sourceAmount)),
              batcherFee: {
                amount: "2000000",
                token: "."
              },
              depositFee: {
                amount: "2000000",
                token: "."
              },
              deposit: 2e6,
              utxo: "",
              poolId: "",
              timestamp: "",
              lpToken: {
                amount: "0",
                token: ""
              }
            };
            pools.push(DHPoolasMSPool);
          }
        }
      }
      if (pools.length > 0) {
        const priceInverted = sourceToken.value.p + sourceToken.value.t.a !== pools[0].tokenA.token;
        let index = -1;
        if (!provider.value.anyPool && pools.length > 1) {
          for (let i = 0; i < pools.length; i++) {
            const poolId = pools[i].poolId.slice(61);
            if (poolId === getOrderPoolId(props.order)) {
              index = i;
              break;
            }
          }
        }
        const selectedSource = { p: sourceToken.value.p, a: sourceToken.value.t.q, t: { a: sourceToken.value.t.a, q: sourceToken.value.t.q } };
        const selectedTarget = { p: targetToken.value.p, a: targetToken.value.t.q, t: { a: targetToken.value.t.a, q: targetToken.value.t.q } };
        const pairDecimalNbr = getpairDecimalNbr(sourceDecimals.value, targetDecimals.value);
        let swapInfo;
        if (index === -1 && provider.value.anyPool && pools.length > 1) {
          swapInfo = selectBestPool(
            selectedSource,
            selectedSource.a,
            pools,
            0,
            sourceDecimals.value,
            targetDecimals.value,
            "0",
            priceInverted,
            pairDecimalNbr,
            selectedSource,
            selectedTarget,
            true,
            false
          ).info;
        } else {
          const pool = index >= 0 ? pools[index] : pools[0];
          swapInfo = updateForBestPool(
            pool,
            selectedSource,
            selectedSource.a,
            0,
            sourceDecimals.value,
            targetDecimals.value,
            "0",
            priceInverted,
            pairDecimalNbr,
            selectedSource,
            selectedTarget,
            true,
            false
          ).info;
        }
        if (!swapInfo) {
          return true;
        }
        outOfRange.value = compare(targetToken.value.t.q, ">", swapInfo.estReceive);
        marketPrice.value = swapInfo.price;
      }
    }
    async function updateSourceMetadata() {
      if (!sourceToken.value) {
        return null;
      }
      sourceMetadata.value = await getAssetInfo(sourceToken.value.p, sourceToken.value.t.a) ?? getSwapAssetInfo(sourceToken.value.p, sourceToken.value.t.a) ?? getSwapAssetInfo$1(sourceToken.value.p, sourceToken.value.t.a);
    }
    async function updateTargetMetadata() {
      if (!targetToken.value) {
        return null;
      }
      targetMetadata.value = await getAssetInfo(targetToken.value.p, targetToken.value.t.a) ?? getSwapAssetInfo(targetToken.value.p, targetToken.value.t.a) ?? getSwapAssetInfo$1(targetToken.value.p, targetToken.value.t.a);
    }
    watch(sourceToken, () => updateSourceMetadata());
    watch(targetToken, () => updateTargetMetadata());
    watch([sourceToken, targetToken, sourceMetadata, targetMetadata], ([_sourceToken, _targetToken, _sourceMetadata, _targetMetadata]) => {
      if (!_sourceToken || !_targetToken || !_sourceMetadata || !_targetMetadata) {
        return;
      }
      nextTick(() => checkOrderPriceInRange());
    });
    onMounted(async () => {
      await updateSourceMetadata();
      await updateTargetMetadata();
    });
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", {
        class: normalizeClass(["col-span-12 lg:col-span-6 grid grid-cols-12 cc-gap cc-area-light cc-p", outOfRange.value ? "cc-ring-yellow" : ""])
      }, [
        outOfRange.value ? (openBlock(), createElementBlock("div", _hoisted_1$3, [
          createVNode(IconWarning, { class: "w-7 flex-none mr-2" }),
          createVNode(_sfc_main$c, {
            text: unref(t)("wallet.swap.orders.outOfRange"),
            class: "cc-text-sz"
          }, null, 8, ["text"])
        ])) : createCommentVNode("", true),
        createBaseVNode("div", _hoisted_2$2, [
          createBaseVNode("span", null, toDisplayString(unref(t)("wallet.swap.orders.label.provider")), 1),
          createBaseVNode("div", _hoisted_3$1, [
            provider.value.image.length > 0 ? (openBlock(), createElementBlock("img", {
              key: 0,
              class: "w-5 h-5 mr-2",
              loading: "lazy",
              src: provider.value.image,
              alt: "provider logo"
            }, null, 8, _hoisted_4$1)) : createCommentVNode("", true),
            createBaseVNode("span", null, toDisplayString(provider.value.name), 1)
          ])
        ]),
        createBaseVNode("div", _hoisted_5, [
          createBaseVNode("span", _hoisted_6, toDisplayString(unref(t)("wallet.swap.orders.label.from")), 1),
          sourceAssetListItem.value ? (openBlock(), createBlock(_sfc_main$j, {
            key: 0,
            asset: sourceAssetListItem.value,
            rightAlign: true
          }, null, 8, ["asset"])) : createCommentVNode("", true)
        ]),
        createBaseVNode("div", _hoisted_7, [
          createBaseVNode("span", _hoisted_8, toDisplayString(unref(t)("wallet.swap.orders.label.to")), 1),
          targetAssetListItem.value ? (openBlock(), createBlock(_sfc_main$j, {
            key: 0,
            asset: targetAssetListItem.value,
            rightAlign: true
          }, null, 8, ["asset"])) : createCommentVNode("", true)
        ]),
        createBaseVNode("div", _hoisted_9, [
          createBaseVNode("div", _hoisted_10, toDisplayString(unref(t)("wallet.swap.orders.label.orderprice")), 1),
          !isZero(orderPrice.value) ? (openBlock(), createElementBlock("div", _hoisted_11, [
            createBaseVNode("i", {
              class: "absolute -left-7 -top-1 cc-text-xl mdi mdi-swap-horizontal cursor-pointer",
              onClick: _cache[0] || (_cache[0] = withModifiers(($event) => swapPrice.value = !swapPrice.value, ["stop", "prevent"]))
            }),
            createVNode(_sfc_main$f, {
              isWholeNumber: "",
              hideFractionIfZero: "",
              amount: orderPrice.value,
              currency: "",
              decimals: unref(getDisplayDecimals)(orderPrice.value),
              class: "cursor-pointer"
            }, null, 8, ["amount", "decimals"]),
            createBaseVNode("span", _hoisted_12, toDisplayString(flipPrice.value ? targetName.value : sourceName.value), 1),
            _cache[2] || (_cache[2] = createBaseVNode("span", { class: "mx-1" }, "/", -1)),
            createBaseVNode("span", _hoisted_13, toDisplayString(flipPrice.value ? sourceName.value : targetName.value), 1)
          ])) : (openBlock(), createBlock(QSpinnerDots_default, {
            key: 1,
            color: "gray"
          }))
        ]),
        marketPrice.value ? (openBlock(), createElementBlock("div", _hoisted_14, [
          createBaseVNode("div", _hoisted_15, [
            createBaseVNode("div", _hoisted_16, toDisplayString(unref(t)("wallet.swap.orders.label.marketprice")), 1),
            marketPrice.value ? (openBlock(), createElementBlock("div", _hoisted_17, [
              createVNode(_sfc_main$f, {
                isWholeNumber: "",
                hideFractionIfZero: "",
                amount: flipPrice.value ? divide(1, marketPrice.value) : marketPrice.value,
                currency: "",
                decimals: unref(getDisplayDecimals)(flipPrice.value ? divide(1, marketPrice.value) : marketPrice.value),
                class: "cursor-pointer"
              }, null, 8, ["amount", "decimals"]),
              createBaseVNode("span", _hoisted_18, toDisplayString(flipPrice.value ? targetName.value : sourceName.value), 1),
              _cache[3] || (_cache[3] = createBaseVNode("span", { class: "mx-1" }, "/", -1)),
              createBaseVNode("span", _hoisted_19, toDisplayString(flipPrice.value ? sourceName.value : targetName.value), 1)
            ])) : createCommentVNode("", true)
          ]),
          createBaseVNode("div", _hoisted_20, toDisplayString(unref(t)("wallet.swap.orders.label.marketpriceinfo")), 1)
        ])) : createCommentVNode("", true),
        createBaseVNode("div", _hoisted_21, [
          createBaseVNode("span", _hoisted_22, toDisplayString(unref(t)("wallet.swap.orders.label.transaction")), 1),
          createBaseVNode("div", _hoisted_23, [
            createVNode(_sfc_main$k, {
              "label-hover": unref(t)("wallet.swap.orders.tx.hover"),
              "notification-text": unref(t)("wallet.swap.orders.tx.hover"),
              "label-c-s-s": "cc-addr",
              "copy-text": utxo.value.txHash
            }, null, 8, ["label-hover", "notification-text", "copy-text"]),
            createVNode(_sfc_main$l, {
              truncate: "",
              subject: utxo.value,
              type: "transaction",
              label: utxo.value.txHash,
              "label-c-s-s": "cc-addr cc-text-white ",
              class: normalizeClass("cc-text-white ")
            }, null, 8, ["subject", "label"])
          ])
        ]),
        createVNode(GridSpace, { hr: "" }),
        createBaseVNode("div", _hoisted_24, [
          createVNode(_sfc_main$m, {
            label: unref(t)("wallet.swap.button.cancelOrder"),
            class: "px-2",
            "btn-style": "cc-text-md cc-btn-warning-yellow",
            onClick: _cache[1] || (_cache[1] = ($event) => onCancelOrder(__props.order))
          }, null, 8, ["label"])
        ])
      ], 2);
    };
  }
});
const _hoisted_1$2 = {
  key: 1,
  class: "cc-grid"
};
const _hoisted_2$1 = {
  key: 1,
  class: "col-span-12 flex justify-center"
};
const itemsOnPage = 10;
const _sfc_main$2 = /* @__PURE__ */ defineComponent({
  __name: "OrderList",
  props: {
    openOrderList: { type: Array, required: true },
    aggList: { type: Array, required: true },
    providerList: { type: Array, required: true }
  },
  setup(__props) {
    const props = __props;
    const { t } = useTranslation();
    const currentPageNo = ref(1);
    const maxPages = computed(() => Math.ceil(props.openOrderList.length / itemsOnPage));
    const showPagination = computed(() => props.openOrderList.length > itemsOnPage);
    const currentPageStart = computed(() => (currentPageNo.value - 1) * itemsOnPage);
    const currentPage = computed(() => props.openOrderList.slice(currentPageStart.value, currentPageStart.value + itemsOnPage));
    return (_ctx, _cache) => {
      return __props.openOrderList.length === 0 ? (openBlock(), createBlock(_sfc_main$i, {
        key: 0,
        html: "",
        label: unref(t)("wallet.swap.orders.empty.label"),
        text: unref(t)("wallet.swap.orders.empty.text"),
        icon: unref(t)("wallet.swap.orders.empty.icon"),
        class: "col-span-12",
        "text-c-s-s": "cc-text-normal text-justify",
        css: "cc-rounded cc-shadow cc-bg-light-0 items-center"
      }, null, 8, ["label", "text", "icon"])) : (openBlock(), createElementBlock("div", _hoisted_1$2, [
        currentPage.value.length > 0 ? (openBlock(true), createElementBlock(Fragment, { key: 0 }, renderList(currentPage.value, (order, index) => {
          return openBlock(), createBlock(_sfc_main$3, {
            key: index,
            "agg-list": __props.aggList,
            "provider-list": __props.providerList,
            order
          }, null, 8, ["agg-list", "provider-list", "order"]);
        }), 128)) : createCommentVNode("", true),
        showPagination.value ? (openBlock(), createElementBlock("div", _hoisted_2$1, [
          showPagination.value ? (openBlock(), createBlock(QPagination_default, {
            key: 0,
            "boundary-numbers": "",
            unelevated: "",
            modelValue: currentPageNo.value,
            "onUpdate:modelValue": _cache[0] || (_cache[0] = ($event) => currentPageNo.value = $event),
            max: maxPages.value,
            "max-pages": 6,
            color: "teal-90",
            "text-color": "teal-90"
          }, null, 8, ["modelValue", "max"])) : createCommentVNode("", true)
        ])) : createCommentVNode("", true)
      ]));
    };
  }
});
const _hoisted_1$1 = { class: "cc-grid" };
const _sfc_main$1 = /* @__PURE__ */ defineComponent({
  __name: "OpenOrders",
  props: {
    aggList: { type: Array, required: true },
    providerList: { type: Array, required: true }
  },
  setup(__props) {
    const storeId = "OpenOrders" + getRandomId();
    const props = __props;
    const $q = useQuasar();
    const { t } = useTranslation();
    const { accountData } = useSelectedAccount();
    const ordersHiddenMobile = ref(true);
    async function checkOpenOrders(silent = false) {
      var _a, _b;
      let error = "";
      if (accountData.value && accountData.value.keys && accountData.value.keys.payment.length > 0) {
        try {
          const addrBech32 = getRootAddress(accountData.value).bech32;
          const calls = [];
          if ((_a = props.aggList) == null ? void 0 : _a.includes("MuesliSwap")) {
            calls.push(fetchOpenOrders(networkId.value, addrBech32));
          }
          if ((_b = props.aggList) == null ? void 0 : _b.includes("DexHunter")) {
            calls.push(fetchOpenOrders$1(networkId.value, accountData.value.account.id, addrBech32));
          }
          const res = await Promise.all(calls);
          const openOrdersMS = res[0];
          const openOrdersDH = res[1];
          const openOrders = [];
          if (!openOrdersMS && !openOrdersDH) {
            error = t("wallet.swap.error.network");
            console.error("checkOpenOrders:", error);
          } else {
            if (openOrdersDH) {
              for (const order of openOrdersDH) {
                openOrders.push(order);
              }
            }
            if (openOrdersMS) {
              for (const order of openOrdersMS) {
                if (!openOrders.some((o) => "tx_hash" in o && order.utxo.startsWith(o.tx_hash) && order.utxo.endsWith(o.tx_output_index.toString()))) {
                  openOrders.push(order);
                }
              }
            }
            return openOrders;
          }
        } catch (err) {
          error = (err == null ? void 0 : err.message) ?? err;
          console.error("checkOpenOrders:", networkId.value, (err == null ? void 0 : err.message) ?? err);
        }
      }
      if (!silent) {
        $q.notify({
          type: "negative",
          message: t("wallet.swap.error.checkOpenOrders") + (error.length > 0 ? `<br>Error: ${error}` : ""),
          position: "top-left",
          timeout: 5e3
        });
      }
      return null;
    }
    async function onRefreshOrders(silent = false) {
      if (isFetchingOrders.value) {
        return;
      }
      const timeDiff = lastOrderUpdate.value + orderUpdateDelay - now();
      if (timeDiff > 0) {
        if (!silent) {
          $q.notify({
            type: "warning",
            message: t("wallet.swap.error.fetchDelay").replace("###time###", Math.floor(timeDiff / 1e3).toString()),
            position: "top-left",
            timeout: 3e3
          });
        }
        return;
      }
      isFetchingOrders.value = true;
      openOrderList.value = await checkOpenOrders(silent) ?? [];
      lastOrderUpdate.value = now();
      if (!silent) {
        $q.notify({
          type: "positive",
          message: t("wallet.swap.orders.refresh"),
          position: "top-left",
          timeout: 3e3
        });
      }
      isFetchingOrders.value = false;
    }
    onMounted(() => {
      setTimeout(() => initializeOpenOrders(), 500);
      addSignalListener(onAccountListUpdated, storeId, initializeOpenOrders);
    });
    onUnmounted(() => {
      removeSignalListener(onAccountListUpdated, storeId);
    });
    const initializeOpenOrders = async () => {
      removeSignalListener(onAccountListUpdated, storeId);
      if (lastOrderUpdate.value === 0) {
        await onRefreshOrders(true);
      }
    };
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock(Fragment, null, [
        ordersHiddenMobile.value ? (openBlock(), createElementBlock("div", {
          key: 0,
          onClick: _cache[0] || (_cache[0] = ($event) => ordersHiddenMobile.value = false),
          class: "col-span-12 cc-rounded cc-bg-highlight p-2 text-center cursor-pointer md:hidden"
        }, " Click to show open orders (" + toDisplayString(unref(openOrderList).length) + ") ", 1)) : createCommentVNode("", true),
        createBaseVNode("div", {
          class: normalizeClass(["col-span-12 flex flex-row flex-nowrap justify-between items-end space-x-4", ordersHiddenMobile.value ? "hidden md:!flex" : "flex"])
        }, [
          createBaseVNode("div", _hoisted_1$1, [
            createVNode(_sfc_main$b, {
              label: unref(t)("wallet.swap.orders.headline"),
              class: "col-span-12"
            }, null, 8, ["label"]),
            createVNode(_sfc_main$c, {
              text: unref(t)("wallet.swap.orders.caption"),
              class: "col-span-12 cc-text-sz"
            }, null, 8, ["text"])
          ]),
          createBaseVNode("div", {
            class: "cc-tabs-button cc-rounded cursor-pointer p-2 capitalize",
            onClick: _cache[1] || (_cache[1] = ($event) => onRefreshOrders(false))
          }, toDisplayString(unref(t)("common.label.refresh")), 1)
        ], 2),
        createVNode(GridSpace, {
          hr: "",
          class: normalizeClass(["mb-2", ordersHiddenMobile.value ? "hidden md:!flex" : "flex"])
        }, null, 8, ["class"]),
        unref(isFetchingOrders) ? (openBlock(), createElementBlock("div", {
          key: 1,
          class: normalizeClass(["col-span-12 flex flex-col flex-nowrap justify-center items-center", ordersHiddenMobile.value ? "hidden md:!flex" : "flex"])
        }, [
          createVNode(QSpinnerDots_default, {
            color: "gray",
            size: "3em"
          })
        ], 2)) : (openBlock(), createBlock(_sfc_main$2, {
          key: 2,
          "agg-list": __props.aggList,
          "provider-list": __props.providerList,
          "open-order-list": unref(openOrderList),
          class: normalizeClass(ordersHiddenMobile.value ? "hidden md:!grid" : "grid")
        }, null, 8, ["agg-list", "provider-list", "open-order-list", "class"]))
      ], 64);
    };
  }
});
const _hoisted_1 = { class: "cc-page-wallet cc-text-sz dark:text-cc-gray" };
const _hoisted_2 = {
  key: 1,
  class: "col-span-12 flex flex-col xl:flex-row xl:cc-gap items-start flex-nowrap"
};
const _hoisted_3 = { class: "w-full grid grid-cols-12 cc-gap order-2 md:order-1" };
const _hoisted_4 = { class: "w-full grid grid-cols-12 cc-gap order-1 md:order-2" };
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "Swap",
  setup(__props) {
    const { t } = useTranslation();
    const { selectedAccountId } = useSelectedAccount();
    const aggList = ref([]);
    const aggListOpenOrders = ref([]);
    const providerList = ref([]);
    onMounted(async () => {
      const calls = [];
      calls.push(fetchEnabledAggList(networkId.value, selectedAccountId.value));
      calls.push(fetchProviderList(networkId.value, selectedAccountId.value));
      const res = await Promise.all(calls);
      aggList.value = res[0];
      aggListOpenOrders.value = ["MuesliSwap", "DexHunter"];
      providerList.value = res[1];
    });
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", _hoisted_1, [
        aggList.value && aggList.value.length === 0 ? (openBlock(), createBlock(_sfc_main$i, {
          key: 0,
          class: "col-span-12 w-full",
          css: "cc-text-semi-bold cc-rounded cc-banner-warning",
          text: unref(t)("wallet.swap.aggregator.unavailable"),
          icon: "mdi mdi-wrench-clock"
        }, null, 8, ["text"])) : aggList.value ? (openBlock(), createElementBlock("div", _hoisted_2, [
          createBaseVNode("div", _hoisted_3, [
            createVNode(CreateSwap, {
              "agg-list": aggList.value,
              "provider-list": providerList.value
            }, null, 8, ["agg-list", "provider-list"])
          ]),
          createBaseVNode("div", _hoisted_4, [
            createVNode(_sfc_main$1, {
              "agg-list": aggListOpenOrders.value,
              "provider-list": providerList.value
            }, null, 8, ["agg-list", "provider-list"])
          ])
        ])) : createCommentVNode("", true)
      ]);
    };
  }
});
export {
  _sfc_main as default
};
