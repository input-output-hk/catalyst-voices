import { d as defineComponent, z as ref, o as openBlock, c as createElementBlock, F as withDirectives, J as vShow, j as createCommentVNode, a as createBlock, h as withCtx, i as createTextVNode, t as toDisplayString, u as unref, e as createBaseVNode, n as normalizeClass, P as normalizeStyle, q as createVNode, B as useFormatter, eW as compare, a7 as useQuasar, b as withModifiers, aW as addSignalListener, aX as removeSignalListener, kk as onBuiltTxDelegation, g3 as getTxBuiltErrorMsg, f_ as ErrorBuildTx, bm as dispatchSignal, kl as doBuildTxDelegation, H as Fragment, I as renderList, km as onBeforeUpdate, D as watch, f as computed, aH as QPagination_default } from "./index.js";
import { G as GridSpace } from "./GridSpace.js";
import { u as useTranslation } from "./useTranslation.js";
import { _ as _sfc_main$9 } from "./CopyToClipboard.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$a } from "./ExplorerLink.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$6 } from "./Tooltip.vue_vue_type_script_setup_true_lang.js";
import { u as useAdaSymbol } from "./useAdaSymbol.js";
import { _ as _sfc_main$7 } from "./FormattedAmount.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$8 } from "./InlineButton.vue_vue_type_script_setup_true_lang.js";
import { _ as _export_sfc } from "./_plugin-vue_export-helper.js";
const _hoisted_1$5 = { class: "cc-flex-fixed h-10 w-10 cc-icon-round" };
const _hoisted_2$4 = ["src"];
const _sfc_main$5 = /* @__PURE__ */ defineComponent({
  __name: "GridPoolLogo",
  props: {
    pool: { type: Object, required: true, default: null }
  },
  setup(__props) {
    const imgError = ref(false);
    const { t } = useTranslation();
    function isValidImg(pool) {
      var _a, _b, _c, _d;
      const src = ((_b = (_a = pool.mde) == null ? void 0 : _a.info) == null ? void 0 : _b.url_png_icon_64x64) || ((_d = (_c = pool.mde) == null ? void 0 : _c.adapools) == null ? void 0 : _d.url_png_icon_64x64);
      return src && src.startsWith("https://");
    }
    return (_ctx, _cache) => {
      var _a, _b, _c, _d, _e, _f, _g, _h;
      return openBlock(), createElementBlock("div", _hoisted_1$5, [
        __props.pool && !imgError.value && isValidImg(__props.pool) ? withDirectives((openBlock(), createElementBlock("img", {
          key: 0,
          class: "h-10 w-10",
          loading: "lazy",
          src: ((_b = (_a = __props.pool.mde) == null ? void 0 : _a.info) == null ? void 0 : _b.url_png_icon_64x64) || ((_d = (_c = __props.pool.mde) == null ? void 0 : _c.adapools) == null ? void 0 : _d.url_png_icon_64x64),
          alt: "pool logo",
          onError: _cache[0] || (_cache[0] = ($event) => imgError.value = true)
        }, null, 40, _hoisted_2$4)), [
          [vShow, ((_f = (_e = __props.pool.mde) == null ? void 0 : _e.info) == null ? void 0 : _f.url_png_icon_64x64) || ((_h = (_g = __props.pool.mde) == null ? void 0 : _g.adapools) == null ? void 0 : _h.url_png_icon_64x64)]
        ]) : createCommentVNode("", true),
        __props.pool.support ? (openBlock(), createBlock(_sfc_main$6, {
          key: 1,
          offset: [0, -50],
          "transition-show": "scale",
          "transition-hide": "scale"
        }, {
          default: withCtx(() => [
            createTextVNode(toDisplayString(unref(t)("wallet.staking.support.icon.hover")), 1)
          ]),
          _: 1
        })) : createCommentVNode("", true)
      ]);
    };
  }
});
const _hoisted_1$4 = { class: "relative w-full cc-flex-fixed inline-block" };
const _hoisted_2$3 = { class: "relative w-full px-1 py-0.5 cc-site-max-width mx-auto cc-rounded cc-shadow cc-online cc-text-bold cc-text-xs text-center" };
const _hoisted_3$3 = { class: "relative whitespace-nowrap" };
const _hoisted_4$3 = ["innerHTML"];
const _sfc_main$4 = /* @__PURE__ */ defineComponent({
  __name: "SaturationLevel",
  props: {
    stake: { type: String, required: true, default: "0" },
    saturationLevel: { type: Number, required: true, default: 1 },
    addedSaturationLevel: { type: Number, default: -1 }
  },
  setup(__props) {
    const { c, t } = useTranslation();
    const { useCompactFormat } = useFormatter();
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", _hoisted_1$4, [
        createBaseVNode("div", _hoisted_2$3, [
          __props.addedSaturationLevel > 0 ? (openBlock(), createElementBlock("div", {
            key: 0,
            class: normalizeClass(["absolute cc-rounded cc-shadow top-0 left-0 h-full", __props.addedSaturationLevel > 95 ? "cc-added-red" : __props.addedSaturationLevel > 90 ? "cc-added-yellow" : "cc-added-green"]),
            style: normalizeStyle("width: " + __props.addedSaturationLevel + "%")
          }, null, 6)) : createCommentVNode("", true),
          createBaseVNode("div", {
            class: normalizeClass(["absolute cc-rounded top-0 left-0 h-full", __props.saturationLevel > 95 ? "cc-saturation-red" : __props.saturationLevel > 90 ? "cc-saturation-yellow" : "cc-saturation-green"]),
            style: normalizeStyle("width: " + __props.saturationLevel + "%")
          }, null, 6),
          createBaseVNode("div", _hoisted_3$3, [
            createVNode(_sfc_main$7, {
              amount: __props.stake,
              compact: unref(useCompactFormat)(__props.stake, false),
              "text-c-s-s": "flex-nowrap inline",
              "balance-always-visible": ""
            }, null, 8, ["amount", "compact"]),
            createBaseVNode("span", null, toDisplayString(" (" + __props.saturationLevel + "%)"), 1)
          ]),
          createVNode(_sfc_main$6, {
            offset: [0, 8],
            "transition-show": "scale",
            "transition-hide": "scale"
          }, {
            default: withCtx(() => [
              createBaseVNode("div", {
                innerHTML: unref(t)("wallet.staking.saturation.hover")
              }, null, 8, _hoisted_4$3)
            ]),
            _: 1
          })
        ])
      ]);
    };
  }
});
const _hoisted_1$3 = { class: "relative w-full cc-flex-fixed inline-block" };
const _hoisted_2$2 = { class: "relative w-full px-3 py-0.5 cc-site-max-width mx-auto cc-rounded cc-shadow cc-online cc-text-bold cc-text-xs cc-text-color-light text-center" };
const _hoisted_3$2 = { class: "relative whitespace-nowrap" };
const _hoisted_4$2 = {
  key: 0,
  class: "mdi mdi-alert-outline mr-2"
};
const _hoisted_5$2 = {
  key: 1,
  class: "mdi mdi-check-decagram-outline mr-2"
};
const _hoisted_6$2 = {
  key: 2,
  class: "mdi mdi-alert-outline ml-2"
};
const _hoisted_7$2 = ["innerHTML"];
const _hoisted_8$2 = ["innerHTML"];
const _sfc_main$3 = /* @__PURE__ */ defineComponent({
  __name: "PledgeBadge",
  props: {
    pledge: { type: String, required: true, default: "0" },
    actualPledge: { type: String, required: true, default: "0" }
  },
  setup(__props) {
    const props = __props;
    const { c, t } = useTranslation();
    const { useCompactFormat } = useFormatter();
    const pl = props.pledge;
    const pla = props.actualPledge;
    const isPledgeMet = compare(pl, "<=", pla);
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", _hoisted_1$3, [
        createBaseVNode("div", _hoisted_2$2, [
          createBaseVNode("div", {
            class: normalizeClass([
              "absolute cc-rounded top-0 left-0 h-full",
              unref(isPledgeMet) ? "cc-pledge-blue" : "cc-added-red"
            ]),
            style: "width: 100%"
          }, null, 2),
          createBaseVNode("div", _hoisted_3$2, [
            !unref(isPledgeMet) ? (openBlock(), createElementBlock("i", _hoisted_4$2)) : (openBlock(), createElementBlock("i", _hoisted_5$2)),
            createVNode(_sfc_main$7, {
              amount: __props.pledge,
              compact: unref(useCompactFormat)(__props.pledge, false),
              "text-c-s-s": "flex-nowrap inline",
              "hide-fraction-if-zero": "",
              "balance-always-visible": ""
            }, null, 8, ["amount", "compact"]),
            !unref(isPledgeMet) ? (openBlock(), createElementBlock("i", _hoisted_6$2)) : createCommentVNode("", true)
          ]),
          createVNode(_sfc_main$6, {
            "tooltip-c-s-s": "whitespace-nowrap",
            offset: [0, 8],
            "transition-show": "scale",
            "transition-hide": "scale"
          }, {
            default: withCtx(() => [
              unref(isPledgeMet) ? (openBlock(), createElementBlock("div", {
                key: 0,
                innerHTML: unref(t)("wallet.staking.pledge.hover")
              }, null, 8, _hoisted_7$2)) : (openBlock(), createElementBlock("div", {
                key: 1,
                innerHTML: unref(t)("wallet.staking.pledge.notmet")
              }, null, 8, _hoisted_8$2))
            ]),
            _: 1
          })
        ])
      ]);
    };
  }
});
const _hoisted_1$2 = { class: "flex-1 w-full flex flex-col flex-nowrap space-y-2 pt-3 pb-2 pl-1 pr-3" };
const _hoisted_2$1 = { class: "w-full flex flex-row flex-nowrap items-center space-x-2" };
const _hoisted_3$1 = { class: "w-20 item-text text-right" };
const _hoisted_4$1 = { class: "flex-1 flex items-center" };
const _hoisted_5$1 = { class: "w-full flex flex-row flex-nowrap items-center space-x-2" };
const _hoisted_6$1 = { class: "w-20 item-text text-right" };
const _hoisted_7$1 = { class: "flex-1 item-text flex items-center justify-center" };
const _hoisted_8$1 = { class: "relative w-full flex flex-row flex-nowrap items-center space-x-2" };
const _hoisted_9$1 = { class: "relative flex-grow flex-shrink flex flex-col flex-nowrap items-center space-y-2" };
const _hoisted_10$1 = { class: "w-full flex flex-row flex-nowrap items-center space-x-2" };
const _hoisted_11$1 = { class: "w-20 item-text text-right" };
const _hoisted_12$1 = { class: "flex-1 item-text flex items-center justify-center h-5" };
const _hoisted_13$1 = { class: "w-full flex flex-row flex-nowrap items-center space-x-2" };
const _hoisted_14$1 = { class: "w-20 item-text text-right" };
const _hoisted_15$1 = { class: "flex-1 item-text flex items-center justify-center h-5" };
const _hoisted_16$1 = { class: "h-full flex flex-col flex-nowrap items-end justify-end" };
const _sfc_main$2 = /* @__PURE__ */ defineComponent({
  __name: "GridStakePoolInfo",
  props: {
    pool: { type: Object, required: true },
    delegatedPoolList: { type: Array, required: false, default: () => [] },
    addedSaturationLevel: { type: Number, default: -1 }
  },
  setup(__props) {
    const props = __props;
    const $q = useQuasar();
    const { t } = useTranslation();
    const { adaSymbol } = useAdaSymbol();
    async function delegate(poolId) {
      addSignalListener(onBuiltTxDelegation, "GridStakePoolInfo", (res, error) => {
        removeSignalListener(onBuiltTxDelegation, "GridStakePoolInfo");
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
      await dispatchSignal(doBuildTxDelegation, poolId);
      removeSignalListener(onBuiltTxDelegation, "GridStakePoolInfo");
    }
    const isPledgeMet = compare(props.pool.pl, "<=", props.pool.pla);
    const delegatedPool = props.delegatedPoolList.some((item) => item.pb === props.pool.pb);
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", _hoisted_1$2, [
        createBaseVNode("div", _hoisted_2$1, [
          createBaseVNode("div", _hoisted_3$1, toDisplayString(unref(t)("wallet.staking.saturation.label")) + ":", 1),
          createBaseVNode("div", _hoisted_4$1, [
            createVNode(_sfc_main$4, {
              stake: __props.pool.st ?? "0",
              saturationLevel: Math.min(Math.round((__props.pool.stl ?? 1) * 1e4) / 100, 100),
              addedSaturationLevel: __props.addedSaturationLevel * 100
            }, null, 8, ["stake", "saturationLevel", "addedSaturationLevel"])
          ])
        ]),
        createBaseVNode("div", _hoisted_5$1, [
          createBaseVNode("div", _hoisted_6$1, toDisplayString(unref(t)("wallet.staking.pledge.label")) + ":", 1),
          createBaseVNode("div", _hoisted_7$1, [
            createVNode(_sfc_main$3, {
              pledge: __props.pool.pl ?? "0",
              actualPledge: __props.pool.pla ?? "0"
            }, null, 8, ["pledge", "actualPledge"])
          ])
        ]),
        createBaseVNode("div", _hoisted_8$1, [
          createBaseVNode("div", _hoisted_9$1, [
            createBaseVNode("div", _hoisted_10$1, [
              createBaseVNode("div", _hoisted_11$1, toDisplayString(unref(t)("wallet.staking.fees.label")) + ":", 1),
              createBaseVNode("div", _hoisted_12$1, [
                createVNode(_sfc_main$7, {
                  amount: (__props.pool.ma * 100).toString(),
                  percent: true,
                  "whole-c-s-s": "",
                  "fraction-c-s-s": "",
                  decimals: 2,
                  "text-c-s-s": "mr-1"
                }, null, 8, ["amount"]),
                _cache[1] || (_cache[1] = createTextVNode("(")),
                createVNode(_sfc_main$7, {
                  "show-fraction": false,
                  amount: __props.pool.fc,
                  "balance-always-visible": ""
                }, null, 8, ["amount"]),
                _cache[2] || (_cache[2] = createTextVNode(") ")),
                createVNode(_sfc_main$6, {
                  "tooltip-c-s-s": "whitespace-nowrap",
                  offset: [0, 8],
                  "transition-show": "scale",
                  "transition-hide": "scale"
                }, {
                  default: withCtx(() => [
                    createTextVNode(toDisplayString(unref(t)("wallet.staking.fees.hover")), 1)
                  ]),
                  _: 1
                })
              ])
            ]),
            createBaseVNode("div", _hoisted_13$1, [
              createBaseVNode("div", _hoisted_14$1, toDisplayString(unref(t)("wallet.staking.ros.label")) + ":", 1),
              createBaseVNode("div", _hoisted_15$1, [
                createVNode(_sfc_main$7, {
                  amount: __props.pool.mr12.toString(),
                  percent: true,
                  "whole-c-s-s": "",
                  "fraction-c-s-s": "",
                  decimals: 2
                }, null, 8, ["amount"])
              ])
            ])
          ]),
          createBaseVNode("div", _hoisted_16$1, [
            !unref(delegatedPool) && unref(isPledgeMet) ? (openBlock(), createBlock(_sfc_main$8, {
              key: 0,
              class: "min-w-24 h-12",
              label: unref(t)("wallet.staking.button.delegate"),
              onClick: _cache[0] || (_cache[0] = withModifiers(($event) => delegate(__props.pool.pb), ["stop"]))
            }, null, 8, ["label"])) : createCommentVNode("", true)
          ])
        ])
      ]);
    };
  }
});
const GridStakePoolInfo = /* @__PURE__ */ _export_sfc(_sfc_main$2, [["__scopeId", "data-v-85473b4d"]]);
const _hoisted_1$1 = {
  key: 0,
  class: "relative w-full flex-1 overflow-hidden flex justify-start items-start"
};
const _hoisted_2 = { class: "relative w-full flex flex-row flex-nowrap" };
const _hoisted_3 = { class: "relative flex flex-nowrap justify-center items-center space-x-2 px-3 py-2" };
const _hoisted_4 = {
  key: 0,
  class: "flex flex-col flex-nowrap justify-center items-center"
};
const _hoisted_5 = { class: "item-text" };
const _hoisted_6 = {
  class: "text-xs font-medium",
  style: { "font-size": "0.66rem" }
};
const _hoisted_7 = { key: 0 };
const _hoisted_8 = {
  key: 1,
  class: "cc-text-color-caption"
};
const _hoisted_9 = { class: "w-full flex flex-row flex-nowrap justify-between space-x-2" };
const _hoisted_10 = { class: "flex-shrink item-text whitespace-nowrap truncate mt-1 flex flex-row flex-nowrap" };
const _hoisted_11 = { class: "flex-shrink item-text whitespace-nowrap truncate mr-1" };
const _hoisted_12 = { key: 0 };
const _hoisted_13 = { class: "cc-flex-fixed item-text whitespace-nowrap truncate mt-1 flex flex-row flex-nowrap space-x-1" };
const _hoisted_14 = { key: 0 };
const _hoisted_15 = { class: "text-xs" };
const _hoisted_16 = {
  key: 1,
  class: "cc-badge-social cc-flex-fixed"
};
const _hoisted_17 = { class: "fa fa-check-circle cc-text-green" };
const _hoisted_18 = {
  key: 2,
  class: "cc-badge-social cc-flex-fixed"
};
const _hoisted_19 = ["href"];
const _hoisted_20 = {
  key: 3,
  class: "cc-badge-social cc-flex-fixed"
};
const _hoisted_21 = ["href"];
const _hoisted_22 = {
  key: 4,
  class: "cc-badge-social cc-flex-fixed"
};
const _hoisted_23 = ["href"];
const _hoisted_24 = {
  key: 5,
  class: "cc-badge-social cc-flex-fixed"
};
const _hoisted_25 = ["href"];
const _hoisted_26 = {
  key: 6,
  class: "cc-badge-red cc-none inline-flex"
};
const _hoisted_27 = { class: "w-full flex flex-row flex-nowrap mt-0.5 items-center pt-0.5 text-xs cc-text-semi-bold" };
const _sfc_main$1 = /* @__PURE__ */ defineComponent({
  __name: "GridStakePool",
  props: {
    pool: { type: Object, required: true },
    poolList: { type: Object, required: true },
    delegatedPoolList: { type: Array, required: false, default: () => [] },
    addedSaturationLevel: { type: Number, default: -1 },
    noRank: { type: Boolean, default: false },
    infoOnly: { type: Boolean, default: false }
  },
  emits: ["poolSelected", "amountSet", "cloneInput"],
  setup(__props, { emit: __emit }) {
    const props = __props;
    useQuasar();
    const { t } = useTranslation();
    const isPledgeMet = compare(props.pool.pl, "<=", props.pool.pla);
    const getPoolListTickers = (item) => {
      return props.poolList.filter(
        (poolItem) => poolItem.gn === item.gn && poolItem !== item && poolItem.md !== null && poolItem.md.ticker !== null && poolItem.md.name !== null
      ).sort((a, b) => a.md.ticker < b.md.ticker ? -1 : 1).filter((poolItem, index) => index < 10).map((poolItem) => "[" + poolItem.md.ticker + "] " + poolItem.md.name);
    };
    return (_ctx, _cache) => {
      var _a, _b, _c, _d, _e, _f, _g, _h, _i, _j, _k, _l, _m, _n, _o, _p, _q, _r, _s, _t, _u, _v, _w, _x;
      return openBlock(), createElementBlock("div", {
        class: normalizeClass([
          "relative cc-area-light cc-text-sz flex-1 w-full inline-flex flex-col flex-nowrap justify-start items-start",
          (__props.infoOnly ? "min-h-16" : "") + " " + (!unref(isPledgeMet) ? "border-2 " : "")
        ])
      }, [
        __props.pool ? (openBlock(), createElementBlock("div", _hoisted_1$1, [
          createBaseVNode("div", _hoisted_2, [
            createBaseVNode("div", _hoisted_3, [
              !__props.noRank ? (openBlock(), createElementBlock("div", _hoisted_4, [
                createBaseVNode("div", _hoisted_5, [
                  createTextVNode(toDisplayString(__props.pool.ra) + ". ", 1),
                  createVNode(_sfc_main$6, {
                    "tooltip-c-s-s": "whitespace-nowrap",
                    offset: [0, -44],
                    "transition-show": "scale",
                    "transition-hide": "scale"
                  }, {
                    default: withCtx(() => [
                      createTextVNode(toDisplayString(__props.pool.support ? unref(t)("wallet.staking.support.rank.hover") : unref(t)("wallet.staking.rank.hover")), 1)
                    ]),
                    _: 1
                  })
                ]),
                createBaseVNode("div", _hoisted_6, [
                  __props.pool.support && __props.pool.ra === 1 ? (openBlock(), createElementBlock("span", _hoisted_7, _cache[0] || (_cache[0] = [
                    createBaseVNode("svg", {
                      xmlns: "http://www.w3.org/2000/svg",
                      class: "h-5 w-5",
                      viewBox: "0 0 20 20",
                      fill: "currentColor"
                    }, [
                      createBaseVNode("path", { d: "M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z" })
                    ], -1)
                  ]))) : (openBlock(), createElementBlock("span", _hoisted_8, toDisplayString(Math.max(__props.pool.sc, 0)), 1)),
                  createVNode(_sfc_main$6, {
                    "tooltip-c-s-s": "whitespace-nowrap",
                    offset: [0, 8],
                    "transition-show": "scale",
                    "transition-hide": "scale"
                  }, {
                    default: withCtx(() => [
                      createTextVNode(toDisplayString(__props.pool.support ? unref(t)("wallet.staking.support.score.hover") : unref(t)("wallet.staking.score.hover")), 1)
                    ]),
                    _: 1
                  })
                ])
              ])) : createCommentVNode("", true),
              createBaseVNode("div", {
                class: normalizeClass(["flex flex-col flex-nowrap justify-center items-center", __props.noRank ? "ml-4" : ""])
              }, [
                createVNode(_sfc_main$5, { pool: __props.pool }, null, 8, ["pool"])
              ], 2)
            ]),
            createBaseVNode("div", {
              class: normalizeClass(["relative pr-3 py-2 overflow-hidden flex-1 flex flex-col flex-nowrap justify-center items-start", __props.noRank ? "ml-4" : ""])
            }, [
              createBaseVNode("div", _hoisted_9, [
                createBaseVNode("div", _hoisted_10, [
                  createBaseVNode("div", _hoisted_11, [
                    createTextVNode(toDisplayString(((_a = __props.pool.md) == null ? void 0 : _a.ticker) ? "[" + ((_b = __props.pool.md) == null ? void 0 : _b.ticker) + "]" : unref(t)("common.label.noname")) + " " + toDisplayString(((_c = __props.pool.md) == null ? void 0 : _c.name) ?? "") + " ", 1),
                    ((_d = __props.pool.md) == null ? void 0 : _d.name) ? (openBlock(), createBlock(_sfc_main$6, {
                      key: 0,
                      "tooltip-c-s-s": "whitespace-pre-wrap w-2/3 md:w-1/4",
                      offset: [0, -4],
                      "transition-show": "scale",
                      "transition-hide": "scale"
                    }, {
                      default: withCtx(() => {
                        var _a2, _b2, _c2;
                        return [
                          createBaseVNode("div", null, [
                            createTextVNode(toDisplayString(unref(t)("wallet.staking.poollist.item.name") + ": " + ((_a2 = __props.pool.md) == null ? void 0 : _a2.name)) + " ", 1),
                            ((_b2 = __props.pool.md) == null ? void 0 : _b2.description) ? (openBlock(), createElementBlock("span", _hoisted_12, [
                              _cache[1] || (_cache[1] = createBaseVNode("br", null, null, -1)),
                              createTextVNode(toDisplayString(unref(t)("wallet.staking.poollist.item.description") + ": " + ((_c2 = __props.pool.md) == null ? void 0 : _c2.description)), 1)
                            ])) : createCommentVNode("", true)
                          ])
                        ];
                      }),
                      _: 1
                    })) : createCommentVNode("", true)
                  ])
                ]),
                createBaseVNode("div", _hoisted_13, [
                  __props.pool.gp > 1 ? (openBlock(), createElementBlock("div", _hoisted_14, [
                    createBaseVNode("span", _hoisted_15, "(" + toDisplayString(__props.pool.gpn + "/" + __props.pool.gp) + ")", 1),
                    createVNode(_sfc_main$6, {
                      "tooltip-c-s-s": "whitespace-nowrap",
                      offset: [0, -44],
                      "transition-show": "scale",
                      "transition-hide": "scale"
                    }, {
                      default: withCtx(() => [
                        createBaseVNode("div", null, [
                          createBaseVNode("span", null, toDisplayString(unref(t)("wallet.staking.badge.multipool.hover").split("###gpn###").join(__props.pool.gp.toString())), 1)
                        ]),
                        (openBlock(true), createElementBlock(Fragment, null, renderList(getPoolListTickers(__props.pool), (ticker) => {
                          return openBlock(), createElementBlock("div", null, " - " + toDisplayString(ticker), 1);
                        }), 256))
                      ]),
                      _: 1
                    })
                  ])) : (openBlock(), createElementBlock("div", _hoisted_16, [
                    createBaseVNode("i", _hoisted_17, [
                      createVNode(_sfc_main$6, {
                        "tooltip-c-s-s": "whitespace-nowrap",
                        offset: [0, -44],
                        "transition-show": "scale",
                        "transition-hide": "scale"
                      }, {
                        default: withCtx(() => [
                          createTextVNode(toDisplayString(unref(t)("wallet.staking.badge.singlepool.hover")), 1)
                        ]),
                        _: 1
                      })
                    ])
                  ])),
                  ((_e = __props.pool.md) == null ? void 0 : _e.homepage) ? (openBlock(), createElementBlock("div", _hoisted_18, [
                    createVNode(_sfc_main$6, {
                      "tooltip-c-s-s": "whitespace-nowrap",
                      offset: [0, -44],
                      "transition-show": "scale",
                      "transition-hide": "scale"
                    }, {
                      default: withCtx(() => [
                        createTextVNode(toDisplayString(unref(t)("wallet.staking.badge.homepage.hover")), 1)
                      ]),
                      _: 1
                    }),
                    createBaseVNode("a", {
                      href: (_f = __props.pool.md) == null ? void 0 : _f.homepage,
                      target: "_blank",
                      rel: "noopener noreferrer"
                    }, _cache[2] || (_cache[2] = [
                      createBaseVNode("i", { class: "fa fa-globe" }, null, -1)
                    ]), 8, _hoisted_19)
                  ])) : createCommentVNode("", true),
                  ((_i = (_h = (_g = __props.pool.mde) == null ? void 0 : _g.info) == null ? void 0 : _h.social) == null ? void 0 : _i.twitter_handle) ? (openBlock(), createElementBlock("div", _hoisted_20, [
                    createVNode(_sfc_main$6, {
                      "tooltip-c-s-s": "whitespace-nowrap",
                      offset: [0, -44],
                      "transition-show": "scale",
                      "transition-hide": "scale"
                    }, {
                      default: withCtx(() => [
                        createTextVNode(toDisplayString(unref(t)("wallet.staking.badge.twitter.hover")), 1)
                      ]),
                      _: 1
                    }),
                    createBaseVNode("a", {
                      href: "https://twitter.com/" + ((_l = (_k = (_j = __props.pool.mde) == null ? void 0 : _j.info) == null ? void 0 : _k.social) == null ? void 0 : _l.twitter_handle),
                      target: "_blank",
                      rel: "noopener noreferrer"
                    }, _cache[3] || (_cache[3] = [
                      createBaseVNode("i", { class: "fa-brands fa-twitter" }, null, -1)
                    ]), 8, _hoisted_21)
                  ])) : createCommentVNode("", true),
                  ((_o = (_n = (_m = __props.pool.mde) == null ? void 0 : _m.info) == null ? void 0 : _n.social) == null ? void 0 : _o.telegram_handle) ? (openBlock(), createElementBlock("div", _hoisted_22, [
                    createVNode(_sfc_main$6, {
                      "tooltip-c-s-s": "whitespace-nowrap",
                      offset: [0, -44],
                      "transition-show": "scale",
                      "transition-hide": "scale"
                    }, {
                      default: withCtx(() => [
                        createTextVNode(toDisplayString(unref(t)("wallet.staking.badge.telegram.hover")), 1)
                      ]),
                      _: 1
                    }),
                    createBaseVNode("a", {
                      href: "https://t.me/" + ((_r = (_q = (_p = __props.pool.mde) == null ? void 0 : _p.info) == null ? void 0 : _q.social) == null ? void 0 : _r.telegram_handle),
                      target: "_blank",
                      rel: "noopener noreferrer"
                    }, _cache[4] || (_cache[4] = [
                      createBaseVNode("i", { class: "fa-brands fa-telegram -ml-0.5" }, null, -1)
                    ]), 8, _hoisted_23)
                  ])) : createCommentVNode("", true),
                  ((_u = (_t = (_s = __props.pool.mde) == null ? void 0 : _s.info) == null ? void 0 : _t.social) == null ? void 0 : _u.youtube_handle) ? (openBlock(), createElementBlock("div", _hoisted_24, [
                    createVNode(_sfc_main$6, {
                      "tooltip-c-s-s": "whitespace-nowrap",
                      offset: [0, -44],
                      "transition-show": "scale",
                      "transition-hide": "scale"
                    }, {
                      default: withCtx(() => [
                        createTextVNode(toDisplayString(unref(t)("wallet.staking.badge.youtube.hover")), 1)
                      ]),
                      _: 1
                    }),
                    createBaseVNode("a", {
                      href: "https://youtube.com/" + ((_x = (_w = (_v = __props.pool.mde) == null ? void 0 : _v.info) == null ? void 0 : _w.social) == null ? void 0 : _x.youtube_handle),
                      target: "_blank",
                      rel: "noopener noreferrer"
                    }, _cache[5] || (_cache[5] = [
                      createBaseVNode("i", { class: "fa-brands fa-youtube" }, null, -1)
                    ]), 8, _hoisted_25)
                  ])) : createCommentVNode("", true),
                  __props.pool.rep > 0 && __props.pool.rep > __props.pool.aep ? (openBlock(), createElementBlock("div", _hoisted_26, [
                    _cache[6] || (_cache[6] = createBaseVNode("i", { class: "mdi mdi-alert-outline mt-px -mr-2" }, null, -1)),
                    createTextVNode("  " + toDisplayString(unref(t)("wallet.staking.badge.retired.label")) + " ", 1),
                    createVNode(_sfc_main$6, {
                      "tooltip-c-s-s": "whitespace-nowrap",
                      offset: [0, -44],
                      "transition-show": "scale",
                      "transition-hide": "scale"
                    }, {
                      default: withCtx(() => [
                        createTextVNode(toDisplayString(unref(t)("wallet.staking.badge.retired.label") + " in epoch " + __props.pool.rep), 1)
                      ]),
                      _: 1
                    })
                  ])) : createCommentVNode("", true)
                ])
              ]),
              createBaseVNode("div", _hoisted_27, [
                createVNode(_sfc_main$9, {
                  "label-hover": unref(t)("wallet.staking.poollist.poolid.hover"),
                  "notification-text": unref(t)("wallet.staking.poollist.poolid.notify"),
                  "copy-text": __props.pool.pb
                }, null, 8, ["label-hover", "notification-text", "copy-text"]),
                createVNode(_sfc_main$a, {
                  subject: __props.pool,
                  type: "pool",
                  label: __props.pool.pb,
                  "label-c-s-s": "cc-addr cc-text-color-caption",
                  truncate: ""
                }, null, 8, ["subject", "label"])
              ])
            ], 2)
          ]),
          !__props.infoOnly ? (openBlock(), createBlock(GridSpace, {
            key: 0,
            hr: "",
            dense: "",
            class: "w-full"
          })) : createCommentVNode("", true),
          !__props.infoOnly ? (openBlock(), createBlock(GridStakePoolInfo, {
            key: 1,
            pool: __props.pool,
            "delegated-pool-list": __props.delegatedPoolList,
            "added-saturation-level": __props.addedSaturationLevel
          }, null, 8, ["pool", "delegated-pool-list", "added-saturation-level"])) : createCommentVNode("", true)
        ])) : createCommentVNode("", true)
      ], 2);
    };
  }
});
const GridStakePool = /* @__PURE__ */ _export_sfc(_sfc_main$1, [["__scopeId", "data-v-e69a52e5"]]);
const _hoisted_1 = { class: "col-span-12 flex justify-center" };
const itemsOnPage = 24;
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "GridStakePoolList",
  props: {
    poolList: { type: Array, required: true },
    delegatedPoolList: { type: Array, required: false, default: () => [] },
    dense: { type: Boolean, default: false },
    disabled: { type: Boolean, default: false },
    selected: { type: Boolean, default: false },
    noRank: { type: Boolean, default: false },
    infoOnly: { type: Boolean, default: false },
    poolSaturationLevel: { type: Number, default: -1 }
  },
  emits: ["poolSelected", "amountSet", "cloneInput"],
  setup(__props, { emit: __emit }) {
    const props = __props;
    const emit = __emit;
    const stakePoolRefs = ref([]);
    onBeforeUpdate(() => {
      stakePoolRefs.value = [];
    });
    const currentPage = ref(1);
    watch(() => props.poolList.length, () => {
      currentPage.value = 1;
    });
    const showPagination = computed(() => props.poolList.length > itemsOnPage);
    const currentPageStart = computed(() => {
      return (currentPage.value - 1) * itemsOnPage;
    });
    const maxPages = computed(() => Math.ceil(props.poolList.length / itemsOnPage));
    const poolListFiltered = computed(() => props.poolList.slice(currentPageStart.value, currentPageStart.value + itemsOnPage));
    const propagatePoolSelected = (e) => emit("poolSelected", e);
    const propagateAmountSet = (e) => emit("amountSet", e);
    const propagateCloneInput = (e) => emit("cloneInput", e);
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock(Fragment, null, [
        (openBlock(true), createElementBlock(Fragment, null, renderList(poolListFiltered.value, (pool, index) => {
          return openBlock(), createBlock(GridStakePool, {
            ref_for: true,
            ref: (el) => {
              if (el) stakePoolRefs.value[index] = el;
            },
            class: normalizeClass(
              (__props.dense ? "col-span-12 sm:col-span-6 2xl:col-span-4" : "col-span-12") + " " + (__props.disabled ? "cc-pool-disabled " : "") + " " + (__props.selected ? "cc-selected " : "") + " "
            ),
            onPoolSelected: propagatePoolSelected,
            onAmountSet: propagateAmountSet,
            onCloneInput: propagateCloneInput,
            key: (pool == null ? void 0 : pool.pb) ?? Math.random() * 999999,
            pool,
            "pool-list": __props.poolList,
            addedSaturationLevel: __props.poolSaturationLevel,
            "no-rank": __props.noRank,
            "info-only": __props.infoOnly,
            delegatedPoolList: __props.delegatedPoolList
          }, null, 8, ["class", "pool", "pool-list", "addedSaturationLevel", "no-rank", "info-only", "delegatedPoolList"]);
        }), 128)),
        showPagination.value ? (openBlock(), createBlock(GridSpace, {
          key: 0,
          hr: "",
          class: "mt-0.5"
        })) : createCommentVNode("", true),
        createBaseVNode("div", _hoisted_1, [
          showPagination.value ? (openBlock(), createBlock(QPagination_default, {
            key: 0,
            modelValue: currentPage.value,
            "onUpdate:modelValue": _cache[0] || (_cache[0] = ($event) => currentPage.value = $event),
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
      ], 64);
    };
  }
});
export {
  _sfc_main as _
};
