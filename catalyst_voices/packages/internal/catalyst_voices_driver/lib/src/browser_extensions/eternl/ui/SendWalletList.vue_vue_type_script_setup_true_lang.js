import { d as defineComponent, o as openBlock, c as createElementBlock, q as createVNode, u as unref, a5 as toRefs, be as useWalletAccount, z as ref, f as computed, dd as isHDAccount, H as Fragment, I as renderList, j as createCommentVNode, a as createBlock, ae as useSelectedAccount, S as reactive, e as createBaseVNode, d9 as getWalletNameList, t as toDisplayString } from "./index.js";
import { u as useTranslation } from "./useTranslation.js";
import { _ as _sfc_main$4 } from "./GridHeadline.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$3 } from "./AccountItemBalance.vue_vue_type_script_setup_true_lang.js";
import { G as GridButtonSecondary } from "./GridButtonSecondary.js";
import { G as GridSpace } from "./GridSpace.js";
const _hoisted_1$2 = { class: "col-span-12 sm:col-span-6 xl:col-span-4 grid grid-cols-12 cc-gap" };
const _sfc_main$2 = /* @__PURE__ */ defineComponent({
  __name: "SendAccountItem",
  props: {
    textId: { type: String, required: false, default: "wallet.send" },
    accountId: { type: String, required: true },
    walletId: { type: String, required: true },
    isSelectedInUi: { type: Boolean, required: true }
    // This is NOT the globally selectedAccount, but it can be.
  },
  emits: ["onSendToAccount"],
  setup(__props, { emit: __emit }) {
    const props = __props;
    const emit = __emit;
    const { it } = useTranslation();
    function onSendToAccount() {
      emit("onSendToAccount", {
        accountId: props.accountId,
        walletId: props.walletId
      });
    }
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", _hoisted_1$2, [
        createVNode(_sfc_main$3, {
          "account-id": __props.accountId,
          "wallet-id": __props.walletId,
          "is-selected-in-ui": __props.isSelectedInUi,
          "show-only-total": true,
          "allow-editing-name": false,
          "overwrite-show-stake": false
        }, null, 8, ["account-id", "wallet-id", "is-selected-in-ui"]),
        createVNode(GridButtonSecondary, {
          label: unref(it)(__props.textId + ".button.account"),
          icon: "mdi mdi-cube-send text-xl",
          link: onSendToAccount,
          class: "col-span-12 mt-1"
        }, null, 8, ["label"]),
        createVNode(GridSpace, {
          hr: "",
          class: "mt-1.5 col-span-12"
        })
      ]);
    };
  }
});
const _hoisted_1$1 = {
  key: 0,
  class: "col-span-12 grid grid-cols-12 cc-gap cc-text-sz"
};
const _sfc_main$1 = /* @__PURE__ */ defineComponent({
  __name: "SendAccountList",
  props: {
    walletId: { type: String, required: true },
    textId: { type: String, required: false, default: "wallet.send" }
  },
  emits: ["onSendToAccount"],
  setup(__props, { emit: __emit }) {
    const props = __props;
    const emit = __emit;
    const { walletId } = toRefs(props);
    const { selectedAccountId } = useSelectedAccount();
    const {
      walletData
    } = useWalletAccount(walletId, ref(""));
    const accountList = computed(() => {
      var _a;
      return ((_a = walletData.value) == null ? void 0 : _a.wallet.accountList.filter((account) => isHDAccount(account.path))) ?? [];
    });
    function onSendToAccount(info) {
      if (info.accountId) {
        emit("onSendToAccount", info);
      }
    }
    return (_ctx, _cache) => {
      return unref(walletData) ? (openBlock(), createElementBlock("div", _hoisted_1$1, [
        (openBlock(true), createElementBlock(Fragment, null, renderList(accountList.value, (account) => {
          return openBlock(), createBlock(_sfc_main$2, {
            key: "item_" + account.id,
            "text-id": __props.textId,
            "account-id": account.id,
            "wallet-id": unref(walletData).wallet.id,
            "is-selected-in-ui": account.id === (unref(selectedAccountId) ?? ""),
            onOnSendToAccount: onSendToAccount
          }, null, 8, ["text-id", "account-id", "wallet-id", "is-selected-in-ui"]);
        }), 128))
      ])) : createCommentVNode("", true);
    };
  }
});
const _hoisted_1 = {
  key: 0,
  class: "col-span-12 grid grid-cols-12 cc-gap cc-text-sz"
};
const _hoisted_2 = { class: "col-span-12 grid grid-cols-12 cc-gap mb-2" };
const _hoisted_3 = ["selected", "value"];
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "SendWalletList",
  props: {
    textId: { type: String, required: false, default: "wallet.send" }
  },
  emits: ["onSendToAccount"],
  setup(__props, { emit: __emit }) {
    const props = __props;
    const emit = __emit;
    const { it } = useTranslation();
    const { selectedWalletId } = useSelectedAccount();
    const walletId = ref(selectedWalletId.value);
    const {
      walletData,
      walletSettings
    } = useWalletAccount(walletId, ref(""));
    const selectedWalletName = walletSettings.name;
    const walletName = walletSettings.name;
    const walletNameList = reactive([]);
    const handleWalletList = () => {
      walletNameList.splice(0, walletNameList.length, ...getWalletNameList());
      walletNameList.sort((a, b) => a.name.localeCompare(b.name, "en-US"));
    };
    handleWalletList();
    const headline = computed(() => {
      let headline2 = "";
      if (walletData.value && selectedWalletName.value === walletName.value) {
        headline2 = it(props.textId + ".accounts.headline");
      } else {
        headline2 = it(props.textId + ".wallets.headline");
      }
      return headline2 + " - " + walletName.value;
    });
    const onSendToAccount = (info) => {
      if (info.accountId) {
        walletId.value = info.walletId;
        emit("onSendToAccount", info);
      }
    };
    const setActiveWallet = (event) => {
      const selectedWalletId2 = event.target.options[event.target.options.selectedIndex].value.toLowerCase();
      if (!selectedWalletId2) {
        return;
      }
      walletId.value = selectedWalletId2;
    };
    return (_ctx, _cache) => {
      return walletNameList.length > 0 ? (openBlock(), createElementBlock("div", _hoisted_1, [
        createBaseVNode("div", _hoisted_2, [
          createVNode(_sfc_main$4, {
            class: "col-span-12",
            label: headline.value
          }, null, 8, ["label"]),
          createBaseVNode("select", {
            class: "col-span-12 sm:col-span-6 xl:col-span-4 cc-rounded-la cc-dropdown cc-text-sm",
            required: true,
            onChange: _cache[0] || (_cache[0] = ($event) => setActiveWallet($event))
          }, [
            (openBlock(true), createElementBlock(Fragment, null, renderList(walletNameList, (data) => {
              return openBlock(), createElementBlock("option", {
                key: data.id,
                selected: data.id === walletId.value,
                value: data.id
              }, toDisplayString(data.name + (data.id === unref(selectedWalletId) ? " (" + unref(it)(__props.textId + ".wallets.current") + ")" : "")), 9, _hoisted_3);
            }), 128))
          ], 32)
        ]),
        unref(walletData) ? (openBlock(), createBlock(_sfc_main$1, {
          key: 0,
          "text-id": __props.textId,
          "wallet-id": unref(walletData).wallet.id,
          onOnSendToAccount: onSendToAccount
        }, null, 8, ["text-id", "wallet-id"])) : createCommentVNode("", true)
      ])) : createCommentVNode("", true);
    };
  }
});
export {
  _sfc_main as _
};
