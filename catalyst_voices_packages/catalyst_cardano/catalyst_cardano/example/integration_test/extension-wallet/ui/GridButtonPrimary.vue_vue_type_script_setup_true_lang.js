import { _ as _sfc_main$1 } from "./GridButton.vue_vue_type_script_setup_true_lang.js";
import { d as defineComponent, o as openBlock, a as createBlock } from "./index.js";
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "GridButtonPrimary",
  props: {
    label: { type: String },
    caption: { type: String },
    icon: { type: String },
    iconClickable: { type: Boolean, default: false },
    type: { type: String, required: false, default: "button" },
    form: { type: String, required: false, default: "" },
    link: { type: Function, default: null },
    capitalize: { type: Boolean, default: true },
    disabled: { type: Boolean, default: false }
  },
  emits: ["iconClick"],
  setup(__props, { emit: __emit }) {
    return (_ctx, _cache) => {
      return openBlock(), createBlock(_sfc_main$1, {
        label: __props.label,
        caption: __props.caption,
        icon: __props.icon,
        link: __props.link,
        type: __props.type,
        form: __props.form,
        disabled: __props.disabled,
        capitalize: __props.capitalize,
        "icon-clickable": __props.iconClickable,
        class: "py-2 text-center cc-text-md cc-text-bold cc-btn-primary",
        onIconClick: _cache[0] || (_cache[0] = ($event) => _ctx.$emit("iconClick"))
      }, null, 8, ["label", "caption", "icon", "link", "type", "form", "disabled", "capitalize", "icon-clickable"]);
    };
  }
});
export {
  _sfc_main as _
};
