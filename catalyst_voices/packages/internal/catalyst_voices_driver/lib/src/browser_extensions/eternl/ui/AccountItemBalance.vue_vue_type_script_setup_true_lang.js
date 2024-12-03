import { d as defineComponent, a7 as useQuasar, a5 as toRefs, be as useWalletAccount, z as ref, f as computed, c_ as add, D as watch, o as openBlock, c as createElementBlock, e as createBaseVNode, t as toDisplayString, u as unref, j as createCommentVNode, F as withDirectives, ge as vModelText, ab as withKeys, b as withModifiers, q as createVNode, Q as QSpinnerDots_default, _ as isStagingApp, h as withCtx, i as createTextVNode, a as createBlock, n as normalizeClass } from "./index.js";
import { u as useTranslation } from "./useTranslation.js";
import { _ as _sfc_main$1 } from "./Tooltip.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$2 } from "./FormattedAmount.vue_vue_type_script_setup_true_lang.js";
import { G as GridSpace } from "./GridSpace.js";
const _hoisted_1 = { class: "col-span-12 cc-text-sz flex flex-col flex-nowrap gap-0" };
const _hoisted_2 = { class: "cc-text-semi-bold flex justify-between items-center" };
const _hoisted_3 = { class: "flex flex-row space-x-1" };
const _hoisted_4 = {
  key: 0,
  class: "tracking-normal"
};
const _hoisted_5 = {
  key: 5,
  class: "mdi mdi-circle text-xs mt-0.5 w-[12px] cc-text-green"
};
const _hoisted_6 = {
  key: 7,
  class: "mt-0.5 h-0"
};
const _hoisted_7 = {
  key: 8,
  class: "h-0"
};
const _hoisted_8 = { class: "cc-text-xs cc-text-normal" };
const _hoisted_9 = { class: "w-full flex flex-row flex-nowrap justify-between" };
const _hoisted_10 = { class: "flex-1 cc-text-bold" };
const _hoisted_11 = {
  key: 0,
  class: "w-full flex flex-row flex-nowrap justify-between"
};
const _hoisted_12 = { class: "flex-1 cc-text-inactive" };
const _hoisted_13 = {
  key: 1,
  class: "w-full flex flex-row flex-nowrap justify-between"
};
const _hoisted_14 = { class: "flex-1 cc-text-inactive" };
const _hoisted_15 = {
  key: 3,
  class: "w-full flex flex-row flex-nowrap justify-between"
};
const _hoisted_16 = { class: "mdi mdi-information-outline" };
const _hoisted_17 = {
  key: 4,
  class: "w-full flex flex-row flex-nowrap justify-between"
};
const _hoisted_18 = { class: "mdi mdi-information-outline" };
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "AccountItemBalance",
  props: {
    accountId: { type: String, required: true },
    walletId: { type: String, required: true },
    showOnlyTotal: { type: Boolean, required: false, default: false },
    allowEditingName: { type: Boolean, required: false, default: false },
    isSelectedInUi: { type: Boolean, required: true },
    // This is NOT the globally selectedAccount, but it can be.
    hideStake: { type: Boolean, required: false, default: false },
    overwriteShowStake: { type: Boolean, required: true }
  },
  emits: [
    "onSetDappAccount",
    "showControlledStake"
  ],
  setup(__props, { emit: __emit }) {
    const props = __props;
    const emit = __emit;
    const $q = useQuasar();
    const { it } = useTranslation();
    const { accountId, walletId } = toRefs(props);
    const {
      appAccount,
      accountSettings,
      accountData
    } = useWalletAccount(walletId, accountId);
    const accountName = accountSettings.name;
    const accountPath = accountSettings.path;
    const isAccountSyncing = accountSettings.isSyncing;
    const accountBalance = accountSettings.balance;
    const accountTotal = accountSettings.total;
    const accountLovelace = accountSettings.lovelace;
    const accountRewards = accountSettings.rewards;
    const isEditingName = ref(false);
    const controlledStake = computed(() => {
      var _a;
      const balance = (_a = accountData.value) == null ? void 0 : _a.balance;
      if (!balance) {
        return "0";
      }
      return add(balance.stakeOpkOsk, balance.stakeEpkOsk);
    });
    const externalStake = computed(() => {
      var _a;
      return ((_a = accountBalance.value) == null ? void 0 : _a.stakeOpkEsk) ?? "0";
    });
    const hideControlledStake = computed(() => controlledStake.value === accountTotal.value);
    const hideExternalStake = computed(() => externalStake.value === "0");
    const showControlledStake = computed(() => accountTotal.value !== controlledStake.value && !props.showOnlyTotal);
    const localControlledStake = computed(() => !props.hideStake && (showControlledStake.value || props.overwriteShowStake));
    watch(showControlledStake, () => emit("showControlledStake", showControlledStake.value), { immediate: true });
    const _accountName = ref(accountName.value);
    const saveAccountName = async () => {
      if (await accountSettings.updateAccountName(_accountName.value)) {
        $q.notify({
          type: "positive",
          message: "Account name saved.",
          position: "top-left",
          timeout: 4e3
        });
      } else {
        $q.notify({
          type: "negative",
          message: "Could not save account name.",
          position: "top-left",
          timeout: 1e4
        });
      }
      isEditingName.value = false;
    };
    const onEditStart = () => {
      isEditingName.value = true;
    };
    const onEditCancel = () => {
      isEditingName.value = false;
      _accountName.value = accountName.value;
    };
    function onSetDappAccount() {
      emit("onSetDappAccount", { walletId: walletId.value, accountId: accountId.value });
    }
    return (_ctx, _cache) => {
      var _a;
      return openBlock(), createElementBlock("div", _hoisted_1, [
        createBaseVNode("div", _hoisted_2, [
          createBaseVNode("div", _hoisted_3, [
            !isEditingName.value ? (openBlock(), createElementBlock("span", _hoisted_4, toDisplayString(unref(accountName)), 1)) : createCommentVNode("", true),
            isEditingName.value && __props.allowEditingName ? withDirectives((openBlock(), createElementBlock("input", {
              key: 1,
              onKeyup: withKeys(saveAccountName, ["enter"]),
              "onUpdate:modelValue": _cache[0] || (_cache[0] = ($event) => _accountName.value = $event),
              maxlength: "40",
              class: "bg-cc-white cc-bg-light-1 border-2 box-border rounded-borders cc-text-color pointer-cursor"
            }, null, 544)), [
              [vModelText, _accountName.value]
            ]) : createCommentVNode("", true),
            isEditingName.value && __props.allowEditingName ? (openBlock(), createElementBlock("i", {
              key: 2,
              class: "mdi mdi-check cursor-pointer",
              onClick: saveAccountName
            })) : createCommentVNode("", true),
            isEditingName.value && __props.allowEditingName ? (openBlock(), createElementBlock("i", {
              key: 3,
              class: "mdi mdi-close cursor-pointer",
              onClick: onEditCancel
            })) : createCommentVNode("", true),
            !isEditingName.value && __props.allowEditingName ? (openBlock(), createElementBlock("i", {
              key: 4,
              class: "mdi mdi-pencil cursor-pointer",
              onClick: onEditStart
            })) : createCommentVNode("", true),
            ((_a = unref(appAccount)) == null ? void 0 : _a.isDappAccount) ? (openBlock(), createElementBlock("i", _hoisted_5)) : (openBlock(), createElementBlock("svg", {
              key: 6,
              xmlns: "http://www.w3.org/2000/svg",
              viewBox: "0 0 24 24",
              class: "cc-fill w-3 h-3 mt-1 cursor-pointer",
              onClick: withModifiers(onSetDappAccount, ["stop", "prevent"])
            }, _cache[1] || (_cache[1] = [
              createBaseVNode("path", { d: "M 14.8125 2 C 14.3125 2 13.80625 2.19375 13.40625 2.59375 L 11.90625 4.09375 L 10.90625 3.09375 L 9.5 4.5\nL 11.8125 6.8125 L 9.1875 9.40625 L 10.59375 10.8125 L 13.1875 8.1875 L 15.8125 10.8125 L 13.1875 13.40625\nL 14.59375 14.8125 L 17.1875 12.1875 L 19.5 14.5 L 20.90625 13.09375 L 19.90625 12.09375 L 21.40625 10.59375\nC 22.20625 9.79375 22.20625 8.6125 21.40625 7.8125 L 19.5 5.90625 L 22 3.40625 L 20.59375 2 L 18.09375 4.5\nL 16.1875 2.59375 C 15.7875 2.19375 15.3125 2 14.8125 2 z M 4.40625 9.59375 L 3 11 L 4 12 L 2.59375 13.40625\nC 1.79375 14.20625 1.79375 15.3875 2.59375 16.1875 L 4.5 18.09375 L 2 20.59375 L 3.40625 22 L 5.90625 19.5\nL 7.8125 21.40625 C 8.6125 22.20625 9.79375 22.20625 10.59375 21.40625 L 12 20 L 13 21 L 14.40625 19.59375 L 4.40625 9.59375 z" }, null, -1)
            ]))),
            unref(isAccountSyncing) ? (openBlock(), createElementBlock("div", _hoisted_6, [
              createVNode(QSpinnerDots_default, {
                color: "gray",
                size: "1rem"
              })
            ])) : createCommentVNode("", true),
            unref(isStagingApp)() ? (openBlock(), createElementBlock("div", _hoisted_7, [
              _cache[2] || (_cache[2] = createBaseVNode("i", { class: "mdi mdi-information" }, null, -1)),
              createVNode(_sfc_main$1, {
                anchor: "top middle",
                "transition-show": "scale",
                "transition-hide": "scale"
              }, {
                default: withCtx(() => [
                  createTextVNode(toDisplayString(unref(accountId)), 1)
                ]),
                _: 1
              })
            ])) : createCommentVNode("", true)
          ]),
          createBaseVNode("span", _hoisted_8, "(" + toDisplayString(unref(accountPath)) + ")", 1)
        ]),
        createBaseVNode("div", {
          class: normalizeClass([
            "cc-area-light flex flex-col flex-nowrap p-3 mt-1",
            (__props.isSelectedInUi ? "cc-selected" : "cc-not-selected") + " " + (!__props.showOnlyTotal ? "min-h-20" : "") + " "
          ])
        }, [
          createBaseVNode("div", _hoisted_9, [
            createBaseVNode("span", _hoisted_10, toDisplayString(unref(it)("common.balance.total")), 1),
            createVNode(_sfc_main$2, {
              amount: unref(accountTotal),
              "text-c-s-s": "w-full justify-end",
              class: "flex-1"
            }, null, 8, ["amount"])
          ]),
          !__props.showOnlyTotal ? (openBlock(), createElementBlock("div", _hoisted_11, [
            createBaseVNode("span", _hoisted_12, toDisplayString(unref(it)("common.balance.balance")), 1),
            createVNode(_sfc_main$2, {
              amount: unref(accountLovelace),
              "text-c-s-s": "w-full justify-end cc-text-inactive",
              class: "flex-1"
            }, null, 8, ["amount"])
          ])) : createCommentVNode("", true),
          !__props.showOnlyTotal ? (openBlock(), createElementBlock("div", _hoisted_13, [
            createBaseVNode("span", _hoisted_14, toDisplayString(unref(it)("common.balance.rewards")), 1),
            createVNode(_sfc_main$2, {
              amount: unref(accountRewards),
              "text-c-s-s": "w-full justify-end cc-text-inactive",
              class: "flex-1"
            }, null, 8, ["amount"])
          ])) : createCommentVNode("", true),
          localControlledStake.value && !__props.showOnlyTotal ? (openBlock(), createBlock(GridSpace, {
            key: 2,
            hr: "",
            class: "my-2"
          })) : createCommentVNode("", true),
          localControlledStake.value && !__props.showOnlyTotal ? (openBlock(), createElementBlock("div", _hoisted_15, [
            createBaseVNode("span", {
              class: normalizeClass(["cursor-pointer", hideControlledStake.value ? "cc-text-light-4" : "cc-text-inactive"])
            }, [
              createTextVNode(toDisplayString(unref(it)("common.balance.stake.controlled.label")) + " ", 1),
              createBaseVNode("i", _hoisted_16, [
                createVNode(_sfc_main$1, {
                  "transition-show": "scale",
                  "transition-hide": "scale"
                }, {
                  default: withCtx(() => [
                    createTextVNode(toDisplayString(unref(it)("common.balance.stake.controlled.hover")), 1)
                  ]),
                  _: 1
                })
              ])
            ], 2),
            createVNode(_sfc_main$2, {
              amount: controlledStake.value,
              "text-c-s-s": "w-full justify-end  " + (hideControlledStake.value ? "cc-text-light-4" : "cc-text-inactive"),
              class: "flex-1"
            }, null, 8, ["amount", "text-c-s-s"])
          ])) : createCommentVNode("", true),
          localControlledStake.value && !__props.showOnlyTotal ? (openBlock(), createElementBlock("div", _hoisted_17, [
            createBaseVNode("span", {
              class: normalizeClass(["cursor-pointer", hideExternalStake.value ? "cc-text-light-4" : "cc-text-inactive"])
            }, [
              createTextVNode(toDisplayString(unref(it)("common.balance.stake.external.label")) + " ", 1),
              createBaseVNode("i", _hoisted_18, [
                createVNode(_sfc_main$1, {
                  "transition-show": "scale",
                  "transition-hide": "scale"
                }, {
                  default: withCtx(() => [
                    createTextVNode(toDisplayString(unref(it)("common.balance.stake.external.hover")), 1)
                  ]),
                  _: 1
                })
              ])
            ], 2),
            createVNode(_sfc_main$2, {
              amount: externalStake.value,
              "text-c-s-s": "w-full justify-end  " + (hideExternalStake.value ? "cc-text-light-4" : "cc-text-inactive"),
              class: "flex-1"
            }, null, 8, ["amount", "text-c-s-s"])
          ])) : createCommentVNode("", true)
        ], 2)
      ]);
    };
  }
});
export {
  _sfc_main as _
};
