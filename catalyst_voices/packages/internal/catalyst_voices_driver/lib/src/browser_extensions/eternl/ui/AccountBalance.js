import { d as defineComponent, z as ref, f as computed, c_ as add, u as unref, o as openBlock, c as createElementBlock, e as createBaseVNode, t as toDisplayString, j as createCommentVNode, q as createVNode, Q as QSpinnerDots_default, a as createBlock, b as withModifiers, i as createTextVNode, n as normalizeClass, h as withCtx, ae as useSelectedAccount } from "./index.js";
import { u as useTranslation } from "./useTranslation.js";
import { _ as _sfc_main$1 } from "./FormattedAmount.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$2 } from "./Tooltip.vue_vue_type_script_setup_true_lang.js";
import { G as GridSpace } from "./GridSpace.js";
import { _ as _sfc_main$3 } from "./AccountUtxoBalance.vue_vue_type_script_setup_true_lang.js";
import "./NetworkId.js";
import "./useBalanceVisible.js";
import "./Clipboard.js";
import "./_plugin-vue_export-helper.js";
import "./useNavigation.js";
import "./useTabId.js";
import "./Modal.js";
import "./ExternalLink.vue_vue_type_script_setup_true_lang.js";
import "./GridButtonPrimary.vue_vue_type_script_setup_true_lang.js";
import "./GridButton.vue_vue_type_script_setup_true_lang.js";
import "./GridHeadline.vue_vue_type_script_setup_true_lang.js";
const _hoisted_1 = {
  key: 0,
  class: "col-span-12 md:col-span-6 cc-text-sz"
};
const _hoisted_2 = { class: "relative col-span-4 mb-1 cc-text-semi-bold flex flex-row justify-between items-center" };
const _hoisted_3 = { class: "flex flex-row" };
const _hoisted_4 = { class: "mr-1" };
const _hoisted_5 = {
  key: 0,
  class: "mdi mdi-circle text-xs mt-0.5 mr-1.5 cc-text-green"
};
const _hoisted_6 = {
  key: 1,
  class: "mt-0.5 h-0"
};
const _hoisted_7 = { class: "cc-text-xs cc-text-normal" };
const _hoisted_8 = { class: "cc-area-light flex flex-col flex-nowrap cc-card" };
const _hoisted_9 = { class: "w-full flex flex-row flex-nowrap justify-between" };
const _hoisted_10 = { class: "flex-1 cc-text-bold" };
const _hoisted_11 = { class: "w-full flex flex-row flex-nowrap justify-between" };
const _hoisted_12 = { class: "flex-1 cc-text-inactive" };
const _hoisted_13 = { class: "w-full flex flex-row flex-nowrap justify-between" };
const _hoisted_14 = { class: "flex-1 cc-text-inactive" };
const _hoisted_15 = {
  key: 1,
  class: "w-full flex flex-row flex-nowrap justify-between"
};
const _hoisted_16 = {
  key: 2,
  class: "w-full flex flex-row flex-nowrap justify-between"
};
const _hoisted_17 = { class: "cc-text-inactive" };
const _hoisted_18 = { class: "mdi mdi-information-outline" };
const _hoisted_19 = {
  key: 3,
  class: "w-full flex flex-row flex-nowrap justify-between"
};
const _hoisted_20 = { class: "cc-text-inactive" };
const _hoisted_21 = { class: "mdi mdi-information-outline" };
const _hoisted_22 = {
  key: 4,
  class: "w-full flex flex-row flex-nowrap justify-between"
};
const _hoisted_23 = { class: "cc-text-inactive" };
const _hoisted_24 = { class: "mdi mdi-information-outline" };
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "AccountBalance",
  setup(__props) {
    const { it } = useTranslation();
    const {
      appAccount,
      accountSettings
    } = useSelectedAccount();
    const accountName = accountSettings.name;
    const accountPath = accountSettings.path;
    const isAccountSyncing = accountSettings.isSyncing;
    const accountBalance = accountSettings.balance;
    const accountTotal = accountSettings.total;
    const accountLovelace = accountSettings.lovelace;
    const accountRewards = accountSettings.rewards;
    const showStakingBreakdown = ref(true);
    const controlledStake = computed(() => {
      const balance = accountBalance.value;
      if (!balance) {
        return "0";
      }
      return add(balance.stakeOpkOsk, balance.stakeEpkOsk);
    });
    const notStaked = computed(() => {
      const balance = accountBalance.value;
      if (!balance) {
        return "0";
      }
      return balance.coinOpk;
    });
    const externalStake = computed(() => {
      const balance = accountBalance.value;
      if (!balance) {
        return "0";
      }
      return balance.stakeOpkEsk;
    });
    const showControlledStake = computed(() => accountTotal.value !== controlledStake.value);
    return (_ctx, _cache) => {
      return unref(appAccount) ? (openBlock(), createElementBlock("div", _hoisted_1, [
        createBaseVNode("div", null, [
          createBaseVNode("div", _hoisted_2, [
            createBaseVNode("div", _hoisted_3, [
              createBaseVNode("span", _hoisted_4, toDisplayString(unref(accountName)), 1),
              unref(appAccount).isDappAccount ? (openBlock(), createElementBlock("i", _hoisted_5)) : createCommentVNode("", true),
              unref(isAccountSyncing) ? (openBlock(), createElementBlock("div", _hoisted_6, [
                createVNode(QSpinnerDots_default, {
                  color: "gray",
                  size: "1rem"
                })
              ])) : createCommentVNode("", true)
            ]),
            createBaseVNode("span", _hoisted_7, "(" + toDisplayString(unref(accountPath)) + ")", 1)
          ]),
          createBaseVNode("div", _hoisted_8, [
            createBaseVNode("div", _hoisted_9, [
              createBaseVNode("span", _hoisted_10, toDisplayString(unref(it)("common.balance.total")), 1),
              createVNode(_sfc_main$1, {
                amount: unref(accountTotal),
                "text-c-s-s": "w-full justify-end",
                class: "flex-1"
              }, null, 8, ["amount"])
            ]),
            createBaseVNode("div", _hoisted_11, [
              createBaseVNode("span", _hoisted_12, toDisplayString(unref(it)("common.balance.balance")), 1),
              createVNode(_sfc_main$1, {
                amount: unref(accountLovelace),
                "text-c-s-s": "w-full justify-end cc-text-inactive",
                class: "flex-1"
              }, null, 8, ["amount"])
            ]),
            createBaseVNode("div", _hoisted_13, [
              createBaseVNode("span", _hoisted_14, toDisplayString(unref(it)("common.balance.rewards")), 1),
              createVNode(_sfc_main$1, {
                amount: unref(accountRewards),
                "text-c-s-s": "w-full justify-end cc-text-inactive",
                class: "flex-1"
              }, null, 8, ["amount"])
            ]),
            showControlledStake.value ? (openBlock(), createBlock(GridSpace, {
              key: 0,
              hr: "",
              class: "my-2"
            })) : createCommentVNode("", true),
            showControlledStake.value ? (openBlock(), createElementBlock("div", _hoisted_15, [
              createBaseVNode("span", {
                class: "cc-text-inactive cursor-pointer",
                onClick: _cache[0] || (_cache[0] = withModifiers(($event) => showStakingBreakdown.value = !showStakingBreakdown.value, ["stop"]))
              }, [
                createTextVNode(toDisplayString(unref(it)("common.balance.stake.total.label")) + " ", 1),
                createBaseVNode("i", {
                  class: normalizeClass(["relative text-sm -ml-0.5", showStakingBreakdown.value ? "mdi mdi-chevron-down" : "mdi mdi-chevron-right"])
                }, [
                  createVNode(_sfc_main$2, {
                    "transition-show": "scale",
                    "transition-hide": "scale"
                  }, {
                    default: withCtx(() => [
                      createTextVNode(toDisplayString(unref(it)("common.balance.stake.total.hover")), 1)
                    ]),
                    _: 1
                  })
                ], 2)
              ]),
              showStakingBreakdown.value ? (openBlock(), createBlock(_sfc_main$1, {
                key: 0,
                amount: controlledStake.value,
                "text-c-s-s": "w-full justify-end cc-text-inactive",
                class: "flex-1"
              }, null, 8, ["amount"])) : createCommentVNode("", true)
            ])) : createCommentVNode("", true),
            showStakingBreakdown.value && showControlledStake.value ? (openBlock(), createElementBlock("div", _hoisted_16, [
              createBaseVNode("span", _hoisted_17, [
                createTextVNode(toDisplayString(unref(it)("common.balance.stake.controlled.label")) + " ", 1),
                createBaseVNode("i", _hoisted_18, [
                  createVNode(_sfc_main$2, {
                    "transition-show": "scale",
                    "transition-hide": "scale"
                  }, {
                    default: withCtx(() => [
                      createTextVNode(toDisplayString(unref(it)("common.balance.stake.controlled.hover")), 1)
                    ]),
                    _: 1
                  })
                ])
              ]),
              createVNode(_sfc_main$1, {
                amount: controlledStake.value,
                "text-c-s-s": "w-full justify-end cc-text-inactive",
                class: "flex-1"
              }, null, 8, ["amount"])
            ])) : createCommentVNode("", true),
            showStakingBreakdown.value && showControlledStake.value ? (openBlock(), createElementBlock("div", _hoisted_19, [
              createBaseVNode("span", _hoisted_20, [
                createTextVNode(toDisplayString(unref(it)("common.balance.stake.notstaked.label")) + " ", 1),
                createBaseVNode("i", _hoisted_21, [
                  createVNode(_sfc_main$2, {
                    "transition-show": "scale",
                    "transition-hide": "scale"
                  }, {
                    default: withCtx(() => [
                      createTextVNode(toDisplayString(unref(it)("common.balance.stake.notstaked.hover")), 1)
                    ]),
                    _: 1
                  })
                ])
              ]),
              createVNode(_sfc_main$1, {
                amount: notStaked.value,
                "text-c-s-s": "w-full justify-end cc-text-inactive",
                class: "flex-1"
              }, null, 8, ["amount"])
            ])) : createCommentVNode("", true),
            showStakingBreakdown.value && showControlledStake.value ? (openBlock(), createElementBlock("div", _hoisted_22, [
              createBaseVNode("span", _hoisted_23, [
                createTextVNode(toDisplayString(unref(it)("common.balance.stake.external.label")) + " ", 1),
                createBaseVNode("i", _hoisted_24, [
                  createVNode(_sfc_main$2, {
                    "transition-show": "scale",
                    "transition-hide": "scale"
                  }, {
                    default: withCtx(() => [
                      createTextVNode(toDisplayString(unref(it)("common.balance.stake.external.hover")), 1)
                    ]),
                    _: 1
                  })
                ])
              ]),
              createVNode(_sfc_main$1, {
                amount: externalStake.value,
                "text-c-s-s": "w-full justify-end cc-text-inactive",
                class: "flex-1"
              }, null, 8, ["amount"])
            ])) : createCommentVNode("", true)
          ])
        ]),
        createVNode(_sfc_main$3, {
          "always-show-header": "",
          "can-spend-rewards": false
        })
      ])) : createCommentVNode("", true);
    };
  }
});
export {
  _sfc_main as default
};
