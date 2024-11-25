import { d as defineComponent, o as openBlock, a as createBlock, b as withModifiers } from "./index.js";
import { _ as _sfc_main$1 } from "./GridTextArea.vue_vue_type_script_setup_true_lang.js";
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "GridToggle",
  props: {
    toggled: { type: Boolean, default: false, required: true },
    toggleError: { type: Boolean, default: false, required: false },
    label: { type: String, default: "" },
    text: { type: String, default: "" },
    icon: { type: String, default: null },
    css: { type: String, default: "cc-rounded cc-banner-blue justify-center items-center" },
    html: { type: Boolean, default: false }
  },
  emits: [
    "update:toggled",
    "update:toggleError"
  ],
  setup(__props, { emit: __emit }) {
    return (_ctx, _cache) => {
      return openBlock(), createBlock(_sfc_main$1, {
        label: __props.label,
        text: __props.text,
        error: __props.toggleError,
        icon: __props.toggled ? "mdi mdi-checkbox-marked-outline -mt-0.5 " + (__props.toggleError ? "cc-text-color-error" : "") : "mdi mdi-checkbox-blank-outline  -mt-0.5 " + (__props.toggleError ? "cc-text-color-error" : ""),
        class: "group cursor-pointer",
        "text-c-s-s": "text-justify",
        html: __props.html,
        css: __props.css + " " + (__props.toggleError ? "border-red-600 border " : " "),
        onClick: _cache[0] || (_cache[0] = withModifiers(($event) => {
          _ctx.$emit("update:toggled", !__props.toggled);
          _ctx.$emit("update:toggleError", false);
        }, ["stop"]))
      }, null, 8, ["label", "text", "error", "icon", "html", "css"]);
    };
  }
});
export {
  _sfc_main as _
};
