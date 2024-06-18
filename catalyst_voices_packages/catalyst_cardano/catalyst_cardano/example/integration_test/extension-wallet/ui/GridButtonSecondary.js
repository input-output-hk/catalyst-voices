import { _ as _sfc_main$1 } from "./GridButton.vue_vue_type_script_setup_true_lang.js";
import { d as defineComponent, o as openBlock, a as createBlock, n as normalizeClass } from "./index.js";
import { _ as _export_sfc } from "./_plugin-vue_export-helper.js";
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "GridButtonSecondary",
  props: {
    label: { type: String },
    caption: { type: String },
    icon: { type: String },
    iconClickable: { type: Boolean, default: false },
    type: { type: String, required: false, default: "button" },
    form: { type: String, required: false, default: "" },
    link: { type: Function, default: null },
    capitalize: { type: Boolean, default: true },
    disabled: { type: Boolean, default: false },
    disableTooltip: { type: String, required: false },
    active: { type: Boolean, required: false, default: false }
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
        disableTooltip: __props.disableTooltip,
        "icon-clickable": __props.iconClickable,
        class: normalizeClass(["py-2 text-center cc-text-md cc-text-semi-bold", __props.active ? "cc-btn-secondary-active" : "cc-btn-secondary"]),
        onIconClick: _cache[0] || (_cache[0] = ($event) => _ctx.$emit("iconClick"))
      }, null, 8, ["label", "caption", "icon", "link", "type", "form", "disabled", "capitalize", "disableTooltip", "icon-clickable", "class"]);
    };
  }
});
const GridButtonSecondary = /* @__PURE__ */ _export_sfc(_sfc_main, [["__scopeId", "data-v-86e7ef96"]]);
export {
  GridButtonSecondary as G
};
