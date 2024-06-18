import { u as useTranslation } from "./useTranslation.js";
import { _ as _sfc_main$3 } from "./GridAccountUtxoList.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$1, a as _sfc_main$2 } from "./GridHeadline.vue_vue_type_script_setup_true_lang.js";
import { G as GridSpace } from "./GridSpace.js";
import { d as defineComponent, o as openBlock, c as createElementBlock, q as createVNode, u as unref } from "./index.js";
import "./Tooltip.vue_vue_type_script_setup_true_lang.js";
import "./GridAccountUtxoItem.vue_vue_type_script_setup_true_lang.js";
import "./IconButton.vue_vue_type_script_setup_true_lang.js";
import "./CopyToClipboard.vue_vue_type_script_setup_true_lang.js";
import "./Clipboard.js";
import "./FormattedAmount.vue_vue_type_script_setup_true_lang.js";
import "./useBalanceVisible.js";
import "./ExplorerLink.vue_vue_type_script_setup_true_lang.js";
import "./GridTxListUtxoTokenList.vue_vue_type_script_setup_true_lang.js";
import "./GridTxListTokenDetails.vue_vue_type_script_setup_true_lang.js";
import "./_plugin-vue_export-helper.js";
import "./NetworkId.js";
const _hoisted_1 = { class: "cc-grid cc-text-sz" };
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "AccountUtxoList",
  setup(__props) {
    const { it } = useTranslation();
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", _hoisted_1, [
        createVNode(_sfc_main$1, {
          label: unref(it)("wallet.summary.utxo.headline")
        }, null, 8, ["label"]),
        createVNode(_sfc_main$2, {
          text: unref(it)("wallet.summary.utxo.caption")
        }, null, 8, ["text"]),
        createVNode(GridSpace, {
          hr: "",
          class: "col-span-12"
        }),
        createVNode(_sfc_main$3)
      ]);
    };
  }
});
export {
  _sfc_main as default
};
