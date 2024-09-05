import { _ as _sfc_main$1 } from "./GridButton.vue_vue_type_script_setup_true_lang.js";
import { d as defineComponent, o as openBlock, a as createBlock, n as normalizeClass } from "./index.js";
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "GridButtonWarning",
  props: {
    label: { type: String },
    caption: { type: String },
    icon: { type: String },
    btnStyle: { type: String, required: false, default: "cc-btn-warning cc-shadow" },
    type: { type: String, required: false, default: "button" },
    form: { type: String, required: false, default: "" },
    link: { type: Function, default: null },
    disabled: { type: Boolean, default: false }
  },
  setup(__props) {
    return (_ctx, _cache) => {
      return openBlock(), createBlock(_sfc_main$1, {
        label: __props.label,
        caption: __props.caption,
        icon: __props.icon,
        link: __props.link,
        type: __props.type,
        form: __props.form,
        disabled: __props.disabled,
        class: normalizeClass([__props.btnStyle, "text-center cc-text-sz py-2"])
      }, null, 8, ["label", "caption", "icon", "link", "type", "form", "disabled", "class"]);
    };
  }
});
export {
  _sfc_main as _
};
