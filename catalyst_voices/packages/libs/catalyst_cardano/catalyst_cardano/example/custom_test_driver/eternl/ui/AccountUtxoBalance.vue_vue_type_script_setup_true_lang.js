import { d as defineComponent, a5 as toRefs, z as ref, u as unref, o as openBlock, a as createBlock, T as createSlots, h as withCtx, e as createBaseVNode, q as createVNode, j as createCommentVNode, f as computed, cG as subtract, D as watch, k0 as setRewardsLocked, fM as dispatchSignalSyncTo, fN as doUpdateAccountBalances, c3 as isZero, c as createElementBlock, Q as QSpinnerDots_default, t as toDisplayString, n as normalizeClass, cK as isGreaterThanZero, i as createTextVNode, b as withModifiers, cH as neg, ae as useSelectedAccount } from "./index.js";
import { u as useTranslation } from "./useTranslation.js";
import { u as useNavigation } from "./useNavigation.js";
import { _ as _sfc_main$7 } from "./Tooltip.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$6 } from "./FormattedAmount.vue_vue_type_script_setup_true_lang.js";
import { M as Modal } from "./Modal.js";
import { _ as _sfc_main$5 } from "./ExternalLink.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$2 } from "./GridButtonPrimary.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$3, a as _sfc_main$4 } from "./GridHeadline.vue_vue_type_script_setup_true_lang.js";
import { G as GridSpace } from "./GridSpace.js";
const _hoisted_1$1 = { class: "grow-0 shrink-0 w-full flex flex-row flex-nowrap items-start justify-between cc-bg-white-0 border-b cc-p" };
const _hoisted_2$1 = { class: "flex flex-col cc-text-sz" };
const _hoisted_3$1 = { class: "grid grid-cols-12 cc-gap w-full p-4" };
const _hoisted_4$1 = { class: "grid grid-cols-12 cc-gap w-full p-2 border-t" };
const _sfc_main$1 = /* @__PURE__ */ defineComponent({
  __name: "InfoModal",
  props: {
    showModal: { type: Object, required: true },
    title: { type: String, required: false, default: void 0 },
    caption: { type: String, required: false, default: void 0 },
    persistent: { type: Boolean, required: false, default: false },
    confirmLabel: { type: String, required: false, default: void 0 },
    hideConfirm: { type: Boolean, required: false, default: false },
    extLinkUrl: { type: String, required: false, default: "" },
    extLinkLabel: { type: String, required: false, default: "" }
  },
  emits: ["close", "confirm"],
  setup(__props, { emit: __emit }) {
    const props = __props;
    const emit = __emit;
    const { it } = useTranslation();
    const { showModal } = toRefs(props);
    const confirmLabel = ref(props.confirmLabel);
    if (props.confirmLabel === void 0) {
      confirmLabel.value = it("common.label.confirm");
    }
    const onConfirm = () => {
      showModal.value.display = false;
      emit("confirm");
    };
    const onClose = () => {
      showModal.value.display = false;
      emit("close");
    };
    return (_ctx, _cache) => {
      var _a;
      return ((_a = unref(showModal)) == null ? void 0 : _a.display) ? (openBlock(), createBlock(Modal, {
        key: 0,
        persistent: false,
        narrow: "",
        onClose
      }, createSlots({
        header: withCtx(() => [
          createBaseVNode("div", _hoisted_1$1, [
            createBaseVNode("div", _hoisted_2$1, [
              createVNode(_sfc_main$3, {
                label: __props.title,
                "do-capitalize": ""
              }, null, 8, ["label"])
            ])
          ])
        ]),
        content: withCtx(() => [
          createBaseVNode("div", _hoisted_3$1, [
            __props.caption ? (openBlock(), createBlock(_sfc_main$4, {
              key: 0,
              text: __props.caption
            }, null, 8, ["text"])) : createCommentVNode("", true),
            __props.extLinkUrl.length > 0 ? (openBlock(), createBlock(_sfc_main$5, {
              key: 1,
              url: __props.extLinkUrl,
              label: __props.extLinkLabel,
              "label-c-s-s": "cc-text-semi-bold cc-text-color cc-text-highlight-hover",
              class: "mt-2 whitespace-nowrap"
            }, null, 8, ["url", "label"])) : createCommentVNode("", true)
          ])
        ]),
        _: 2
      }, [
        !__props.hideConfirm ? {
          name: "footer",
          fn: withCtx(() => [
            createBaseVNode("div", _hoisted_4$1, [
              createVNode(_sfc_main$2, {
                label: confirmLabel.value,
                link: onConfirm,
                class: "col-start-7 col-span-6 lg:col-start-10 lg:col-span-3"
              }, null, 8, ["label"])
            ])
          ]),
          key: "0"
        } : void 0
      ]), 1024)) : createCommentVNode("", true);
    };
  }
});
const _hoisted_1 = {
  key: 0,
  class: "col-span-12 md:col-span-5 2xl:col-span-5 cc-text-sz min-w-64 min-h-20 flex justify-center items-center"
};
const _hoisted_2 = {
  key: 1,
  class: "col-span-12 md:col-span-5 2xl:col-span-5 cc-text-sz min-w-64 mt-3"
};
const _hoisted_3 = {
  key: 1,
  class: "cc-area-light grid grid-cols-12 justify-start items-start cc-card mb-2"
};
const _hoisted_4 = { class: "cc-text-bold" };
const _hoisted_5 = { class: "col-span-12 flex flex-row w-full justify-between cc-text-yellow" };
const _hoisted_6 = { class: "cc-text-bold" };
const _hoisted_7 = {
  key: 1,
  class: "col-span-12 flex flex-row w-full justify-between"
};
const _hoisted_8 = { class: "flex flex-row flex-nowrap" };
const _hoisted_9 = {
  key: 2,
  class: "col-span-12 flex flex-row w-full justify-between"
};
const _hoisted_10 = { class: "flex flex-row flex-nowrap" };
const _hoisted_11 = { class: "cc-text-inactive" };
const _hoisted_12 = {
  key: 3,
  class: "col-span-12 flex flex-row w-full justify-between"
};
const _hoisted_13 = { class: "flex flex-row flex-nowrap" };
const _hoisted_14 = {
  key: 4,
  class: "col-span-12 flex flex-row w-full justify-between"
};
const _hoisted_15 = { class: "flex flex-row flex-nowrap" };
const _hoisted_16 = { class: "cc-text-inactive" };
const _hoisted_17 = {
  key: 5,
  class: "col-span-12 flex flex-row w-full justify-between"
};
const _hoisted_18 = { class: "flex flex-row flex-nowrap" };
const _hoisted_19 = { class: "cc-text-inactive" };
const _hoisted_20 = {
  key: 6,
  class: "col-span-12 flex flex-row w-full justify-between"
};
const _hoisted_21 = { class: "flex flex-row flex-nowrap" };
const _hoisted_22 = { class: "cc-text-inactive" };
const _hoisted_23 = {
  key: 8,
  class: "col-span-12 flex flex-row w-full justify-between"
};
const _hoisted_24 = { class: "flex flex-row flex-nowrap" };
const _hoisted_25 = { class: "cc-text-inactive" };
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "AccountUtxoBalance",
  props: {
    alwaysShowHeader: { type: Boolean, required: false, default: false },
    canSpendRewards: { type: Boolean, required: false, default: true },
    // static!
    showFees: { type: Boolean, required: false, default: false }
  },
  setup(__props) {
    const props = __props;
    const { it } = useTranslation();
    const { gotoWalletPage } = useNavigation();
    const {
      selectedAccountId,
      appAccount,
      accountData,
      accountSettings,
      accountBalances
    } = useSelectedAccount();
    const isAwEnabled = accountSettings.isAwEnabled;
    const isTfEnabled = accountSettings.isTfEnabled;
    const showInfoModal = ref({ display: false });
    const showDetails = ref(true);
    const infoTitle = ref("");
    const infoCaption = ref("");
    const infoLinkUrl = ref("");
    const infoLinkLabel = ref("");
    const _lockedAvailable = computed(() => {
      var _a, _b, _c, _d, _e, _f;
      if (isTfEnabled.value) {
        let total = subtract(
          ((_a = accountBalances.value) == null ? void 0 : _a.lockedAvailableTF.total) ?? "0",
          ((_b = accountBalances.value) == null ? void 0 : _b.txFees.total) ?? "0"
        );
        total = subtract(total, ((_c = accountBalances.value) == null ? void 0 : _c.locked.total) ?? "0");
        return total;
      } else {
        let total = subtract(
          ((_d = accountBalances.value) == null ? void 0 : _d.lockedAvailable.total) ?? "0",
          ((_e = accountBalances.value) == null ? void 0 : _e.txFees.total) ?? "0"
        );
        total = subtract(total, ((_f = accountBalances.value) == null ? void 0 : _f.locked.total) ?? "0");
        return total;
      }
    });
    const _lockedTotalTF = computed(() => {
      var _a, _b;
      if (isTfEnabled.value) {
        return ((_a = accountBalances.value) == null ? void 0 : _a.lockedTotalTF.total) ?? "0";
      } else {
        return ((_b = accountBalances.value) == null ? void 0 : _b.lockedTotal.total) ?? "0";
      }
    });
    function gotoPendingTransactions() {
      gotoWalletPage("Transactions", "pending");
    }
    function gotoUtxoList() {
      gotoWalletPage("Summary", "utxos");
    }
    function onShowInfoModal(type) {
      infoTitle.value = it("common.balance.info." + type + ".title");
      infoCaption.value = it("common.balance.info." + type + ".caption");
      switch (type) {
        case "lockedByTokens":
          infoLinkUrl.value = "https://docs.cardano.org/native-tokens/minimum-ada-value-requirement";
          infoLinkLabel.value = it("common.balance.info.lockedByTokens.linklabel");
          break;
        case "lockedInPendingCollateral":
        case "lockedByCollateral":
          infoLinkUrl.value = "https://docs.cardano.org/plutus/collateral-mechanism";
          infoLinkLabel.value = it("common.balance.info.lockedByCollateral.linklabel");
          break;
      }
      showInfoModal.value.display = true;
    }
    function onHideInfoModal() {
      infoTitle.value = "";
      infoCaption.value = "";
      infoLinkUrl.value = "";
      infoLinkLabel.value = "";
      showInfoModal.value.display = false;
    }
    watch(isAwEnabled, (value) => {
      if (!appAccount.value) {
        return;
      }
      setRewardsLocked(appAccount.value.id, !props.canSpendRewards && !value);
      dispatchSignalSyncTo(appAccount.value.id, doUpdateAccountBalances);
    }, { immediate: true });
    return (_ctx, _cache) => {
      return !(unref(accountBalances) && (__props.alwaysShowHeader || !isZero(unref(accountBalances).lockedTotal.total))) ? (openBlock(), createElementBlock("div", _hoisted_1, [
        createVNode(QSpinnerDots_default, {
          color: "grey",
          size: "2rem"
        })
      ])) : unref(accountBalances) ? (openBlock(), createElementBlock("div", _hoisted_2, [
        unref(accountData) ? (openBlock(), createElementBlock("div", {
          key: 0,
          class: "relative mb-1 cc-text-semi-bold flex items-center cursor-pointer",
          onClick: _cache[0] || (_cache[0] = ($event) => showDetails.value = !showDetails.value)
        }, [
          createBaseVNode("span", null, toDisplayString(unref(it)("common.balance.lockedFunds")), 1),
          createBaseVNode("i", {
            class: normalizeClass(["relative text-xl", showDetails.value ? "mdi mdi-chevron-down" : "mdi mdi-chevron-right"])
          }, null, 2)
        ])) : createCommentVNode("", true),
        showDetails.value && unref(accountBalances) ? (openBlock(), createElementBlock("div", _hoisted_3, [
          createBaseVNode("div", {
            class: normalizeClass(["col-span-12 flex w-full justify-between", [isGreaterThanZero(_lockedAvailable.value) ? "cc-text-green" : isZero(_lockedAvailable.value) ? "cc-text-gray" : "cc-text-red"]])
          }, [
            createBaseVNode("div", _hoisted_4, toDisplayString(unref(it)("common.balance.lockedAvailable")), 1),
            createVNode(_sfc_main$6, {
              amount: _lockedAvailable.value,
              "text-c-s-s": "justify-end"
            }, null, 8, ["amount"])
          ], 2),
          createBaseVNode("div", _hoisted_5, [
            createBaseVNode("div", _hoisted_6, toDisplayString(unref(it)("common.balance.lockedTotal")), 1),
            createVNode(_sfc_main$6, {
              amount: _lockedTotalTF.value,
              "text-c-s-s": "justify-end"
            }, null, 8, ["amount"])
          ]),
          !isZero(_lockedTotalTF.value) || !isZero(unref(accountBalances).lockedWithCollateral.total) || !isZero(unref(accountBalances).collateral.total) || !isZero(unref(accountBalances).locked.total) ? (openBlock(), createBlock(GridSpace, {
            key: 0,
            hr: "",
            class: "my-1"
          })) : createCommentVNode("", true),
          !isZero(unref(accountBalances).pending.total) ? (openBlock(), createElementBlock("div", _hoisted_7, [
            createBaseVNode("div", _hoisted_8, [
              createBaseVNode("i", {
                class: "pr-1.5 mt-px mdi mdi-information-outline cursor-pointer",
                onClick: _cache[1] || (_cache[1] = ($event) => onShowInfoModal("lockedInPendingInputs"))
              }, [
                createVNode(_sfc_main$7, {
                  "transition-show": "scale",
                  "transition-hide": "scale",
                  anchor: "top middle",
                  offset: [14, 24]
                }, {
                  default: withCtx(() => [
                    createTextVNode(toDisplayString(unref(it)("common.balance.info.lockedInPendingInputs.caption")), 1)
                  ]),
                  _: 1
                })
              ]),
              createBaseVNode("div", {
                class: "cc-text-inactive cursor-pointer",
                onClick: withModifiers(gotoPendingTransactions, ["stop"])
              }, [
                createTextVNode(toDisplayString(unref(it)("common.balance.lockedInPendingInputs")) + " ", 1),
                _cache[8] || (_cache[8] = createBaseVNode("i", { class: "mdi mdi-arrow-right-circle-outline" }, null, -1))
              ])
            ]),
            createVNode(_sfc_main$6, {
              amount: unref(accountBalances).pending.total,
              "text-c-s-s": isGreaterThanZero(unref(accountBalances).pending.total) ? "cc-text-green" : isZero(unref(accountBalances).pending.total) ? "cc-text-gray" : "cc-text-red"
            }, null, 8, ["amount", "text-c-s-s"])
          ])) : createCommentVNode("", true),
          !isZero(unref(accountBalances).collateral.total) ? (openBlock(), createElementBlock("div", _hoisted_9, [
            createBaseVNode("div", _hoisted_10, [
              createBaseVNode("i", {
                class: "pr-1.5 mt-px mdi mdi-information-outline cursor-pointer",
                onClick: _cache[2] || (_cache[2] = ($event) => onShowInfoModal("lockedByCollateral"))
              }, [
                createVNode(_sfc_main$7, {
                  "transition-show": "scale",
                  "transition-hide": "scale",
                  anchor: "top middle",
                  offset: [14, 24]
                }, {
                  default: withCtx(() => [
                    createTextVNode(toDisplayString(unref(it)("common.balance.info.lockedByCollateral.caption")), 1)
                  ]),
                  _: 1
                })
              ]),
              createBaseVNode("div", _hoisted_11, toDisplayString(unref(it)("common.balance.lockedByCollateral")), 1)
            ]),
            createVNode(_sfc_main$6, {
              amount: unref(accountBalances).collateral.total,
              "text-c-s-s": "justify-end"
            }, null, 8, ["amount"])
          ])) : createCommentVNode("", true),
          !isZero(unref(accountBalances).locked.total) ? (openBlock(), createElementBlock("div", _hoisted_12, [
            createBaseVNode("div", _hoisted_13, [
              createBaseVNode("i", {
                class: "pr-1.5 mt-px mdi mdi-information-outline cursor-pointer",
                onClick: _cache[3] || (_cache[3] = ($event) => onShowInfoModal("lockedUtxos"))
              }, [
                createVNode(_sfc_main$7, {
                  "transition-show": "scale",
                  "transition-hide": "scale",
                  anchor: "top middle",
                  offset: [14, 24]
                }, {
                  default: withCtx(() => [
                    createTextVNode(toDisplayString(unref(it)("common.balance.info.lockedUtxos.caption")), 1)
                  ]),
                  _: 1
                })
              ]),
              createBaseVNode("div", {
                class: "cc-text-inactive cursor-pointer",
                onClick: withModifiers(gotoUtxoList, ["stop"])
              }, [
                createTextVNode(toDisplayString(unref(it)("common.balance.lockedUtxos")) + " ", 1),
                _cache[9] || (_cache[9] = createBaseVNode("i", { class: "mdi mdi-arrow-right-circle-outline" }, null, -1))
              ])
            ]),
            createVNode(_sfc_main$6, {
              amount: unref(accountBalances).locked.total,
              "text-c-s-s": "justify-end"
            }, null, 8, ["amount"])
          ])) : createCommentVNode("", true),
          !isZero(unref(accountBalances).lockedByTokens.total) ? (openBlock(), createElementBlock("div", _hoisted_14, [
            createBaseVNode("div", _hoisted_15, [
              createBaseVNode("i", {
                class: "pr-1.5 mt-px mdi mdi-information-outline cursor-pointer",
                onClick: _cache[4] || (_cache[4] = ($event) => onShowInfoModal("lockedByTokens"))
              }, [
                createVNode(_sfc_main$7, {
                  "transition-show": "scale",
                  "transition-hide": "scale",
                  anchor: "top middle",
                  offset: [14, 24]
                }, {
                  default: withCtx(() => [
                    createTextVNode(toDisplayString(unref(it)("common.balance.info.lockedByTokens.caption")), 1)
                  ]),
                  _: 1
                })
              ]),
              createBaseVNode("div", _hoisted_16, toDisplayString(unref(it)("common.balance.lockedByTokens")), 1)
            ]),
            createVNode(_sfc_main$6, {
              amount: unref(accountBalances).lockedByTokens.total,
              "text-c-s-s": "justify-end"
            }, null, 8, ["amount"])
          ])) : createCommentVNode("", true),
          !isZero(subtract(unref(accountBalances).lockedByTokens.total, unref(accountBalances).lockedByTokensTF.total)) ? (openBlock(), createElementBlock("div", _hoisted_17, [
            createBaseVNode("div", _hoisted_18, [
              createBaseVNode("i", {
                class: "pr-1.5 mt-px mdi mdi-information-outline cursor-pointer",
                onClick: _cache[5] || (_cache[5] = ($event) => onShowInfoModal("lockedByTokensTF"))
              }, [
                createVNode(_sfc_main$7, {
                  "transition-show": "scale",
                  "transition-hide": "scale",
                  anchor: "top middle",
                  offset: [14, 24]
                }, {
                  default: withCtx(() => [
                    createTextVNode(toDisplayString(unref(it)("common.balance.info.lockedByTokensTF.caption")), 1)
                  ]),
                  _: 1
                })
              ]),
              createBaseVNode("div", _hoisted_19, toDisplayString(unref(it)("common.balance.lockedByTokensTF")), 1)
            ]),
            createVNode(_sfc_main$6, {
              amount: unref(accountBalances).lockedByTokensTF.total,
              "text-c-s-s": "justify-end"
            }, null, 8, ["amount"])
          ])) : createCommentVNode("", true),
          !isZero(unref(accountBalances).lockedByRewards.total) ? (openBlock(), createElementBlock("div", _hoisted_20, [
            createBaseVNode("div", _hoisted_21, [
              createBaseVNode("i", {
                class: "pr-1.5 mt-px mdi mdi-information-outline cursor-pointer",
                onClick: _cache[6] || (_cache[6] = ($event) => onShowInfoModal("lockedAsRewards"))
              }, [
                createVNode(_sfc_main$7, {
                  "transition-show": "scale",
                  "transition-hide": "scale",
                  anchor: "top middle",
                  offset: [14, 24]
                }, {
                  default: withCtx(() => [
                    createTextVNode(toDisplayString(unref(it)("common.balance.info.lockedAsRewards.caption")), 1)
                  ]),
                  _: 1
                })
              ]),
              createBaseVNode("div", _hoisted_22, toDisplayString(unref(it)("common.balance.lockedAsRewards")), 1)
            ]),
            createVNode(_sfc_main$6, {
              amount: unref(accountBalances).lockedByRewards.total,
              "text-c-s-s": "justify-end"
            }, null, 8, ["amount"])
          ])) : createCommentVNode("", true),
          __props.showFees ? (openBlock(), createBlock(GridSpace, {
            key: 7,
            hr: "",
            class: "my-1"
          })) : createCommentVNode("", true),
          __props.showFees ? (openBlock(), createElementBlock("div", _hoisted_23, [
            createBaseVNode("div", _hoisted_24, [
              createBaseVNode("i", {
                class: "pr-1.5 mt-px mdi mdi-information-outline cursor-pointer",
                onClick: _cache[7] || (_cache[7] = ($event) => onShowInfoModal("lockedFees"))
              }, [
                createVNode(_sfc_main$7, {
                  "transition-show": "scale",
                  "transition-hide": "scale",
                  anchor: "top middle",
                  offset: [14, 24]
                }, {
                  default: withCtx(() => [
                    createTextVNode(toDisplayString(unref(it)("common.balance.info.lockedFees.caption")), 1)
                  ]),
                  _: 1
                })
              ]),
              createBaseVNode("div", _hoisted_25, toDisplayString(unref(it)("common.balance.lockedFees")), 1)
            ]),
            createVNode(_sfc_main$6, {
              amount: neg(unref(accountBalances).txFees.total),
              "text-c-s-s": "justify-end",
              class: normalizeClass([isZero(unref(accountBalances).txFees.total) ? "cc-text-gray" : "cc-text-red"])
            }, null, 8, ["amount", "class"])
          ])) : createCommentVNode("", true)
        ])) : createCommentVNode("", true),
        showInfoModal.value.display ? (openBlock(), createBlock(_sfc_main$1, {
          key: 2,
          "show-modal": showInfoModal.value,
          caption: infoCaption.value,
          title: infoTitle.value,
          "ext-link-url": infoLinkUrl.value,
          "ext-link-label": infoLinkLabel.value,
          "hide-confirm": "",
          onClose: onHideInfoModal,
          onConfirm: onHideInfoModal
        }, null, 8, ["show-modal", "caption", "title", "ext-link-url", "ext-link-label"])) : createCommentVNode("", true)
      ])) : createCommentVNode("", true);
    };
  }
});
export {
  _sfc_main as _
};
