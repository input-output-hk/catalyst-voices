import { d as defineComponent, a7 as useQuasar, ct as onErrorCaptured, z as ref, D as watch, V as nextTick, K as networkId, ga as getTransactionFromCbor, i3 as ITransactionState, i4 as freeCSLObjects, i5 as calcNeutralTxBalance, o as openBlock, a as createBlock, h as withCtx, e as createBaseVNode, q as createVNode, F as withDirectives, ge as vModelText, j as createCommentVNode, i6 as submitTx } from "./index.js";
import { l as loadTxCborList, _ as _sfc_main$4 } from "./GridTxListBalance.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$1, a as _sfc_main$2 } from "./GridHeadline.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$5 } from "./GridButtonPrimary.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$3 } from "./GridLoading.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$6 } from "./ShallowLayout.vue_vue_type_script_setup_true_lang.js";
import "./NetworkId.js";
import "./vue-json-pretty.js";
import "./useTranslation.js";
import "./Tooltip.vue_vue_type_script_setup_true_lang.js";
import "./GridSpace.js";
import "./_plugin-vue_export-helper.js";
import "./GridTxListEntryBalance.vue_vue_type_script_setup_true_lang.js";
import "./FormattedAmount.vue_vue_type_script_setup_true_lang.js";
import "./useBalanceVisible.js";
import "./Clipboard.js";
import "./GridTxListUtxoListBadges.vue_vue_type_script_setup_true_lang.js";
import "./useNavigation.js";
import "./useTabId.js";
import "./ReportLabelNewModal.vue_vue_type_script_setup_true_lang.js";
import "./IconPencil.js";
import "./GridInput.js";
import "./IconError.js";
import "./GridButtonSecondary.js";
import "./GridButton.vue_vue_type_script_setup_true_lang.js";
import "./Modal.js";
import "./GridTxListUtxoTokenList.vue_vue_type_script_setup_true_lang.js";
import "./GridTxListTokenDetails.vue_vue_type_script_setup_true_lang.js";
import "./ExplorerLink.vue_vue_type_script_setup_true_lang.js";
import "./CopyToClipboard.vue_vue_type_script_setup_true_lang.js";
import "./ConfirmationModal.vue_vue_type_script_setup_true_lang.js";
import "./AccessPasswordInputModal.vue_vue_type_script_setup_true_lang.js";
import "./GridForm.vue_vue_type_script_setup_true_lang.js";
import "./GFEPassword.vue_vue_type_script_setup_true_lang.js";
import "./HeaderLogoAnimation.vue_vue_type_script_setup_true_lang.js";
const _hoisted_1 = { class: "cc-p" };
const _hoisted_2 = { class: "relative w-full flex flex-col space-y-2" };
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "TxViewer",
  setup(__props) {
    const $q = useQuasar();
    onErrorCaptured((e, instance, info) => {
      $q.notify({
        type: "negative",
        message: "error: " + ((e == null ? void 0 : e.message) ?? "no error message") + " info: " + info,
        position: "top-left",
        timeout: 2e4
      });
      console.error("Layout: onErrorCaptured", e, info);
      return true;
    });
    const editor = ref("");
    const isLoading = ref(false);
    const isStaging = ref(false);
    const tx = ref(null);
    const txBalance = ref(null);
    const parsedTx = ref("");
    watch(editor, () => {
      isLoading.value = true;
      nextTick(async () => {
        let input = editor.value;
        if (input.length === 0) {
          tx.value = null;
          txBalance.value = null;
          parsedTx.value = "";
          isLoading.value = false;
          return;
        }
        isStaging.value = true;
        if (input.length === 64) {
          const list = await loadTxCborList(networkId.value, null, [input]);
          isStaging.value = false;
          if (list && list.length > 0) {
            input = list[0].cbor;
          }
        }
        const parsed = input.replace(/<[^>]*>/g, "");
        try {
          console.log(parsed);
          const free = [];
          const resBuiltTx = getTransactionFromCbor(networkId.value, parsed, 0, free);
          const _tx = {
            ...resBuiltTx.builtTx,
            hash: resBuiltTx.txHash,
            size: resBuiltTx.builtTx.size,
            time: 0,
            state: ITransactionState.None,
            inputUtxoList: []
          };
          freeCSLObjects(free);
          const _txBalance = await calcNeutralTxBalance(networkId.value, _tx);
          tx.value = _tx;
          txBalance.value = _txBalance;
          $q.notify({
            type: "positive",
            message: "tx cbor parsed",
            position: "top-left",
            timeout: 4e3
          });
        } catch (e) {
          $q.notify({
            type: "negative",
            message: (e == null ? void 0 : e.message) ?? JSON.stringify(e),
            position: "top-left",
            timeout: 8e3
          });
          console.error((e == null ? void 0 : e.message) ?? e);
          tx.value = null;
          txBalance.value = null;
        }
        isLoading.value = false;
      });
    });
    const submitTransaction = async () => {
      if (!parsedTx.value || !tx.value) {
        return;
      }
      const res = await submitTx(networkId.value, parsedTx.value, tx.value);
      if (res.status === 200) {
        $q.notify({
          type: "positive",
          message: "tx successfully submitted",
          position: "top-left",
          timeout: 4e3
        });
      } else {
        $q.notify({
          type: "negative",
          message: res.error ?? "Unknown submit error: " + res.status,
          position: "top-left",
          timeout: 8e3
        });
      }
      console.warn(">>> submit: res", res);
    };
    return (_ctx, _cache) => {
      return openBlock(), createBlock(_sfc_main$6, null, {
        default: withCtx(() => [
          createBaseVNode("div", _hoisted_1, [
            createBaseVNode("div", _hoisted_2, [
              createVNode(_sfc_main$1, {
                label: "Tx Cbor / Tx Hash:",
                class: "text-sm"
              }),
              withDirectives(createBaseVNode("textarea", {
                "onUpdate:modelValue": _cache[0] || (_cache[0] = ($event) => editor.value = $event),
                class: "w-full cc-bg-light-0 text-xs h-32"
              }, null, 512), [
                [vModelText, editor.value]
              ]),
              createVNode(_sfc_main$1, {
                label: "Transaction:",
                class: "text-sm"
              }),
              isLoading.value ? (openBlock(), createBlock(_sfc_main$2, {
                key: 0,
                text: "(parsing might take a while)",
                class: "text-sm"
              })) : createCommentVNode("", true),
              createVNode(_sfc_main$3, { active: isLoading.value }, null, 8, ["active"]),
              !isLoading.value && tx.value && txBalance.value ? (openBlock(), createBlock(_sfc_main$4, {
                key: 1,
                "tx-balance": txBalance.value,
                tx: tx.value,
                "staging-tx": isStaging.value,
                "tx-viewer": "",
                "always-open": "",
                "witness-check": ""
              }, null, 8, ["tx-balance", "tx", "staging-tx"])) : createCommentVNode("", true)
            ]),
            tx.value && parsedTx.value ? (openBlock(), createBlock(_sfc_main$5, {
              key: 0,
              class: "px-4 mt-4",
              link: submitTransaction,
              label: "Send",
              icon: "mdi mdi-import"
            })) : createCommentVNode("", true)
          ])
        ]),
        _: 1
      });
    };
  }
});
export {
  _sfc_main as default
};
