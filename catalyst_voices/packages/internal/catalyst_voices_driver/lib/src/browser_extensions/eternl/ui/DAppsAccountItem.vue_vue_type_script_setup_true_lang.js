import { u as useTranslation } from "./useTranslation.js";
import { _ as _sfc_main$1 } from "./AccountItemBalance.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$2 } from "./GridButtonPrimary.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$3 } from "./GridButtonWarning.vue_vue_type_script_setup_true_lang.js";
import { G as GridSpace } from "./GridSpace.js";
import { d as defineComponent, a5 as toRefs, o as openBlock, c as createElementBlock, q as createVNode, u as unref, a as createBlock } from "./index.js";
const _hoisted_1 = { class: "col-span-12 sm:col-span-6 xl:col-span-4 grid grid-cols-12 cc-gap" };
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "DAppsAccountItem",
  props: {
    accountId: { type: String, required: true },
    walletId: { type: String, required: true },
    isSelectedInUi: { type: Boolean, required: true },
    // This is NOT the globally selectedAccount, but it can be.
    overwriteShowStake: { type: Boolean, required: true },
    preselectDappAccount: { type: Boolean, required: false, default: true }
  },
  emits: ["onActivateAccount"],
  setup(__props, { emit: __emit }) {
    const props = __props;
    const emit = __emit;
    const { accountId, walletId } = toRefs(props);
    const { it } = useTranslation();
    function onActivateAccount() {
      emit("onActivateAccount", { walletId: walletId.value, accountId: accountId.value });
    }
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", _hoisted_1, [
        createVNode(_sfc_main$1, {
          "account-id": unref(accountId),
          "wallet-id": unref(walletId),
          "is-selected-in-ui": __props.isSelectedInUi,
          "allow-editing-name": false,
          "hide-stake": true,
          "overwrite-show-stake": __props.overwriteShowStake,
          onOnSetDappAccount: onActivateAccount
        }, null, 8, ["account-id", "wallet-id", "is-selected-in-ui", "overwrite-show-stake"]),
        !__props.isSelectedInUi && unref(accountId) !== "" ? (openBlock(), createBlock(_sfc_main$2, {
          key: 0,
          label: unref(it)("wallet.summary.setDAppAccount.button.enable.label"),
          link: onActivateAccount,
          class: "col-span-12"
        }, null, 8, ["label"])) : (openBlock(), createBlock(_sfc_main$3, {
          key: 1,
          label: unref(it)("wallet.summary.setDAppAccount.button.disable.label"),
          link: onActivateAccount,
          class: "col-span-12",
          "btn-style": "cc-text-md cc-btn-warning-yellow"
        }, null, 8, ["label"])),
        createVNode(GridSpace, {
          hr: "",
          class: "mt-1.5 col-span-12"
        })
      ]);
    };
  }
});
export {
  _sfc_main as _
};
