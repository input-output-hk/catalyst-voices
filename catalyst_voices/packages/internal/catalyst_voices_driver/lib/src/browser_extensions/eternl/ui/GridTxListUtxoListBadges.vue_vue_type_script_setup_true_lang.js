import { z as ref, d as defineComponent, a5 as toRefs, f as computed, fF as addressBook, b_ as reportLabelList, gU as getIAppAccountById, fy as getIAppAccountByCred, db as getIAppWallet, fz as getAccountName, iF as getContractProperty, fh as getDonationAddress, K as networkId, iG as getBurnAddress, iH as getFeeAddress, iI as getSwapFeeAddressMS, iJ as getSwapFeeAddressDH, o as openBlock, c as createElementBlock, e as createBaseVNode, i as createTextVNode, t as toDisplayString, q as createVNode, h as withCtx, u as unref, b as withModifiers, P as normalizeStyle, fD as isScriptAddress, j as createCommentVNode, a as createBlock, b$ as addReportLabel, iK as useSelectedAccount } from "./index.js";
import { u as useTranslation } from "./useTranslation.js";
import { u as useNavigation } from "./useNavigation.js";
import { _ as _sfc_main$1 } from "./Tooltip.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$2 } from "./ReportLabelNewModal.vue_vue_type_script_setup_true_lang.js";
const showReportDetails = ref(false);
const useReportDetails = () => {
  return { showReportDetails };
};
const _hoisted_1 = {
  key: 0,
  class: "relative flex flex-row-reverse items-start gap-1"
};
const _hoisted_2 = { key: 0 };
const _hoisted_3 = { key: 1 };
const _hoisted_4 = { class: "cc-badge-gray whitespace-nowrap inline-block mr-1" };
const _hoisted_5 = { key: 2 };
const _hoisted_6 = { class: "cc-badge-green whitespace-nowrap inline-block" };
const _hoisted_7 = { key: 3 };
const _hoisted_8 = { class: "cc-badge-green whitespace-nowrap inline-block" };
const _hoisted_9 = {
  key: 4,
  class: "flex flex-row flex-nowrap space-x-1 h-5"
};
const _hoisted_10 = { class: "cc-badge-gray whitespace-nowrap inline-block" };
const _hoisted_11 = {
  key: 5,
  class: "flex flex-row flex-nowrap space-x-1 h-5"
};
const _hoisted_12 = { class: "cc-badge-gray whitespace-nowrap inline-block" };
const _hoisted_13 = { key: 6 };
const _hoisted_14 = { key: 7 };
const _hoisted_15 = { class: "cc-badge-yellow whitespace-nowrap inline-block" };
const _hoisted_16 = { key: 8 };
const _hoisted_17 = {
  key: 0,
  class: "cc-badge-dark inline-block"
};
const _hoisted_18 = { key: 9 };
const _hoisted_19 = { class: "cc-badge-gray inline-block" };
const _hoisted_20 = { key: 10 };
const _hoisted_21 = { class: "cc-badge-dark inline-block" };
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "GridTxListUtxoListBadges",
  props: {
    utxo: { type: Object, required: true },
    accountId: { type: String, required: false, default: "" },
    txHash: { type: String, required: false, default: "" },
    txViewer: { type: Boolean, required: false, default: false },
    credType: { type: String, required: false, default: void 0 },
    navigationPage: { type: String, required: false, default: "Transactions" }
  },
  setup(__props) {
    const props = __props;
    const { utxo } = toRefs(props);
    const { showReportDetails: showReportDetails2 } = useReportDetails();
    const {
      setSelectedAccountId
    } = useSelectedAccount();
    const { it } = useTranslation();
    const {
      openWallet,
      gotoWalletPage
    } = useNavigation();
    const address = computed(() => {
      var _a;
      return ((_a = utxo == null ? void 0 : utxo.value) == null ? void 0 : _a.output.address) ?? "";
    });
    const addressBookEntry = computed(() => addressBook.value.entryList.find((a) => a.address === address.value) ?? null);
    const reportLabelEntry = computed(() => {
      const entity = reportLabelList.value.find((a) => address.value && a.address === address.value) ?? null;
      if (!entity) {
        return "";
      }
      return entity.entityId + ":" + entity.label;
    });
    const appAccountWanted = computed(() => getIAppAccountById(props.accountId, true));
    const appAccountUtxo = computed(() => {
      var _a, _b;
      const pc = (((_a = utxo == null ? void 0 : utxo.value) == null ? void 0 : _a.pc) ?? "") + "";
      const sc = (((_b = utxo == null ? void 0 : utxo.value) == null ? void 0 : _b.sc) ?? "") + "";
      let cred = pc.length > 0 ? pc : sc;
      return cred.length > 0 ? getIAppAccountByCred(cred, false, props.credType) : null;
    });
    const appWalletUtxo = computed(() => {
      var _a;
      return getIAppWallet((_a = appAccountUtxo.value) == null ? void 0 : _a.walletId);
    });
    const walletName = computed(() => {
      var _a;
      return ((_a = appWalletUtxo.value) == null ? void 0 : _a.data.settings.name) ?? "";
    });
    const isSameWallet = computed(() => {
      var _a, _b, _c;
      return ((_a = appWalletUtxo.value) == null ? void 0 : _a.id) && ((_b = appWalletUtxo.value) == null ? void 0 : _b.id) === ((_c = appAccountWanted.value) == null ? void 0 : _c.walletId);
    });
    const appAccountName = computed(() => {
      var _a;
      return getAccountName((_a = appAccountUtxo.value) == null ? void 0 : _a.data).value;
    });
    const property = computed(() => getContractProperty(address.value));
    const donationAddr = getDonationAddress(networkId.value);
    const burnAddr = getBurnAddress(networkId.value);
    const feeAddr = getFeeAddress(networkId.value);
    const swapFeeAddrMS = getSwapFeeAddressMS(networkId.value);
    const swapFeeAddrDH = getSwapFeeAddressDH(networkId.value);
    const showReportLabelNewModal = ref({ display: false });
    const onReportLabel = () => {
      showReportLabelNewModal.value.display = true;
    };
    const onNew = (address2, label, entityId) => {
      addReportLabel(address2, label, entityId);
    };
    const onSwitchToAccount = () => {
      var _a, _b;
      if ((_a = appAccountUtxo.value) == null ? void 0 : _a.id) {
        setSelectedAccountId((_b = appAccountUtxo.value) == null ? void 0 : _b.id);
        gotoWalletPage(props.navigationPage, props.txHash);
      }
    };
    const onSwitchToWalletAccount = () => {
      var _a, _b;
      if ((_a = appWalletUtxo.value) == null ? void 0 : _a.id) {
        openWallet((_b = appWalletUtxo.value) == null ? void 0 : _b.id, props.navigationPage, props.txHash);
      }
    };
    return (_ctx, _cache) => {
      return address.value ? (openBlock(), createElementBlock("div", _hoisted_1, [
        isSameWallet.value && appAccountName.value ? (openBlock(), createElementBlock("div", _hoisted_2, [
          createBaseVNode("div", {
            class: "cc-badge-blue whitespace-nowrap inline-block cursor-pointer",
            onClick: withModifiers(onSwitchToAccount, ["stop", "prevent"])
          }, [
            createTextVNode(toDisplayString(appAccountName.value) + " ", 1),
            createVNode(_sfc_main$1, {
              anchor: "bottom middle",
              "transition-show": "scale",
              "transition-hide": "scale"
            }, {
              default: withCtx(() => [
                createTextVNode(toDisplayString(unref(it)("wallet.transactions.badge.utxo.own.hover")), 1)
              ]),
              _: 1
            })
          ])
        ])) : walletName.value ? (openBlock(), createElementBlock("div", _hoisted_3, [
          createBaseVNode("div", _hoisted_4, toDisplayString(walletName.value), 1),
          createBaseVNode("div", {
            class: "cc-badge-gray whitespace-nowrap inline-block cursor-pointer",
            onClick: withModifiers(onSwitchToWalletAccount, ["stop", "prevent"])
          }, toDisplayString(appAccountName.value), 1)
        ])) : address.value === unref(donationAddr) ? (openBlock(), createElementBlock("div", _hoisted_5, [
          createBaseVNode("div", _hoisted_6, [
            _cache[0] || (_cache[0] = createBaseVNode("i", { class: "mdi mdi-heart text-[0.60rem] text-red-500 -mx-0.5" }, null, -1)),
            createTextVNode(" " + toDisplayString(unref(it)("wallet.transactions.badge.utxo.donation.label") + " to Eternl") + " ", 1),
            createVNode(_sfc_main$1, {
              anchor: "bottom middle",
              "transition-show": "scale",
              "transition-hide": "scale"
            }, {
              default: withCtx(() => [
                createTextVNode(toDisplayString(unref(it)("wallet.transactions.badge.utxo.donation.hover")), 1)
              ]),
              _: 1
            })
          ])
        ])) : address.value === unref(burnAddr) ? (openBlock(), createElementBlock("div", _hoisted_7, [
          createBaseVNode("div", _hoisted_8, [
            createTextVNode(toDisplayString(unref(it)("wallet.transactions.badge.utxo.burnit.label")) + " ", 1),
            createVNode(_sfc_main$1, {
              anchor: "bottom middle",
              "transition-show": "scale",
              "transition-hide": "scale"
            }, {
              default: withCtx(() => [
                createTextVNode(toDisplayString(unref(it)("wallet.transactions.badge.utxo.burnit.hover")), 1)
              ]),
              _: 1
            })
          ])
        ])) : address.value === unref(swapFeeAddrMS) || unref(swapFeeAddrDH).includes(address.value) ? (openBlock(), createElementBlock("div", _hoisted_9, [
          createBaseVNode("div", _hoisted_10, [
            createTextVNode(toDisplayString(unref(it)("wallet.transactions.badge.utxo.swapfee.label")) + " ", 1),
            createVNode(_sfc_main$1, {
              anchor: "bottom middle",
              "transition-show": "scale",
              "transition-hide": "scale"
            }, {
              default: withCtx(() => [
                createTextVNode(toDisplayString(unref(it)("wallet.transactions.badge.utxo.swapfee.hover")), 1)
              ]),
              _: 1
            })
          ])
        ])) : address.value === unref(feeAddr) ? (openBlock(), createElementBlock("div", _hoisted_11, [
          createBaseVNode("div", _hoisted_12, [
            createTextVNode(toDisplayString(unref(it)("wallet.transactions.badge.utxo.eternl.label")) + " ", 1),
            createVNode(_sfc_main$1, {
              anchor: "bottom middle",
              "transition-show": "scale",
              "transition-hide": "scale"
            }, {
              default: withCtx(() => [
                createTextVNode(toDisplayString(unref(it)("wallet.transactions.badge.utxo.eternl.hover")), 1)
              ]),
              _: 1
            })
          ])
        ])) : property.value ? (openBlock(), createElementBlock("div", _hoisted_13, [
          createBaseVNode("div", {
            class: "cc-badge whitespace-nowrap inline-block",
            style: normalizeStyle("color:" + property.value.color + " ; background-color: " + property.value.bgColor)
          }, [
            createTextVNode(toDisplayString(property.value.label) + " ", 1),
            createVNode(_sfc_main$1, {
              anchor: "bottom middle",
              "transition-show": "scale",
              "transition-hide": "scale"
            }, {
              default: withCtx(() => [
                createTextVNode(toDisplayString(property.value.label), 1)
              ]),
              _: 1
            })
          ], 4)
        ])) : unref(isScriptAddress)(address.value) ? (openBlock(), createElementBlock("div", _hoisted_14, [
          createBaseVNode("div", _hoisted_15, [
            createTextVNode(toDisplayString(unref(it)("wallet.transactions.badge.script.label")) + " ", 1),
            createVNode(_sfc_main$1, {
              anchor: "bottom middle",
              "transition-show": "scale",
              "transition-hide": "scale"
            }, {
              default: withCtx(() => [
                createTextVNode(toDisplayString(unref(it)("wallet.transactions.badge.script.hover")), 1)
              ]),
              _: 1
            })
          ])
        ])) : !__props.txViewer ? (openBlock(), createElementBlock("div", _hoisted_16, [
          !reportLabelEntry.value ? (openBlock(), createElementBlock("div", _hoisted_17, [
            createTextVNode(toDisplayString(unref(it)("wallet.transactions.badge.utxo.ext.label")) + " ", 1),
            createVNode(_sfc_main$1, {
              anchor: "bottom middle",
              "transition-show": "scale",
              "transition-hide": "scale"
            }, {
              default: withCtx(() => [
                createTextVNode(toDisplayString(unref(it)("wallet.transactions.badge.utxo.ext.hover")), 1)
              ]),
              _: 1
            })
          ])) : createCommentVNode("", true),
          unref(showReportDetails2) && !reportLabelEntry.value ? (openBlock(), createElementBlock("div", {
            key: 1,
            class: "cc-badge-purple inline-block ml-1 cursor-pointer",
            onClick: onReportLabel
          }, [
            createTextVNode(toDisplayString(unref(it)("wallet.transactions.badge.utxo.add.label")) + " ", 1),
            createVNode(_sfc_main$1, {
              anchor: "bottom middle",
              "transition-show": "scale",
              "transition-hide": "scale"
            }, {
              default: withCtx(() => [
                createTextVNode(toDisplayString(unref(it)("wallet.transactions.badge.utxo.add.hover")), 1)
              ]),
              _: 1
            })
          ])) : createCommentVNode("", true)
        ])) : createCommentVNode("", true),
        addressBookEntry.value ? (openBlock(), createElementBlock("div", _hoisted_18, [
          createBaseVNode("span", _hoisted_19, [
            _cache[1] || (_cache[1] = createBaseVNode("i", { class: "mdi mdi-book-outline mr-1" }, null, -1)),
            createTextVNode(toDisplayString(addressBookEntry.value.name), 1)
          ])
        ])) : createCommentVNode("", true),
        reportLabelEntry.value ? (openBlock(), createElementBlock("div", _hoisted_20, [
          createBaseVNode("span", _hoisted_21, [
            _cache[2] || (_cache[2] = createBaseVNode("i", { class: "mdi mdi-list-box-outline mr-1" }, null, -1)),
            createTextVNode(toDisplayString(reportLabelEntry.value), 1)
          ])
        ])) : createCommentVNode("", true),
        address.value && showReportLabelNewModal.value.display ? (openBlock(), createBlock(_sfc_main$2, {
          key: 11,
          "show-modal": showReportLabelNewModal.value,
          id: "",
          value: address.value,
          onSubmit: onNew
        }, null, 8, ["show-modal", "value"])) : createCommentVNode("", true)
      ])) : createCommentVNode("", true);
    };
  }
});
export {
  _sfc_main as _,
  useReportDetails as u
};
