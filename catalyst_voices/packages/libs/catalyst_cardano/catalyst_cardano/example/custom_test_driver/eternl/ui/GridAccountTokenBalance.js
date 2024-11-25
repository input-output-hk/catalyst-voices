import { d as defineComponent, o as openBlock, c as createElementBlock, q as createVNode, u as unref, a as createBlock, j as createCommentVNode, t as toDisplayString, ae as useSelectedAccount } from "./index.js";
import { u as useTranslation } from "./useTranslation.js";
import { _ as _sfc_main$1, a as _sfc_main$2 } from "./GridHeadline.vue_vue_type_script_setup_true_lang.js";
import { G as GridSpace } from "./GridSpace.js";
import { _ as _sfc_main$3 } from "./GridTokenList.vue_vue_type_script_setup_true_lang.js";
import "./NetworkId.js";
import "./_plugin-vue_export-helper.js";
import "./vue-json-pretty.js";
import "./Tooltip.vue_vue_type_script_setup_true_lang.js";
import "./IconPencil.js";
import "./GridInput.js";
import "./IconError.js";
import "./GridButtonSecondary.js";
import "./GridButton.vue_vue_type_script_setup_true_lang.js";
import "./GridTabs.vue_vue_type_script_setup_true_lang.js";
import "./useTabId.js";
import "./CopyToClipboard.vue_vue_type_script_setup_true_lang.js";
import "./Clipboard.js";
import "./ExplorerLink.vue_vue_type_script_setup_true_lang.js";
import "./FormattedAmount.vue_vue_type_script_setup_true_lang.js";
import "./useBalanceVisible.js";
import "./InlineButton.vue_vue_type_script_setup_true_lang.js";
import "./lz-string.js";
import "./image.js";
import "./ExtBackground.js";
import "./Modal.js";
import "./GridButtonPrimary.vue_vue_type_script_setup_true_lang.js";
import "./defaultLogo.js";
import "./useAdaSymbol.js";
const _hoisted_1 = { class: "col-span-12 grid grid-cols-12 gap-2" };
const _hoisted_2 = {
  key: 1,
  class: "col-span-12"
};
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "GridAccountTokenBalance",
  setup(__props) {
    const { it } = useTranslation();
    const { accountSettings } = useSelectedAccount();
    const accountAssets = accountSettings.assets;
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", _hoisted_1, [
        createVNode(_sfc_main$1, {
          label: unref(it)("wallet.summary.token.headline")
        }, null, 8, ["label"]),
        createVNode(_sfc_main$2, {
          text: unref(it)("wallet.summary.token.caption")
        }, null, 8, ["text"]),
        createVNode(GridSpace, {
          hr: "",
          class: "mb-2"
        }),
        unref(accountAssets) ? (openBlock(), createBlock(_sfc_main$3, {
          key: 0,
          multiAsset: unref(accountAssets),
          "send-enabled": false
        }, null, 8, ["multiAsset"])) : createCommentVNode("", true),
        !unref(accountAssets) ? (openBlock(), createElementBlock("div", _hoisted_2, toDisplayString(unref(it)("wallet.summary.token.notokens")), 1)) : createCommentVNode("", true)
      ]);
    };
  }
});
export {
  _sfc_main as default
};
