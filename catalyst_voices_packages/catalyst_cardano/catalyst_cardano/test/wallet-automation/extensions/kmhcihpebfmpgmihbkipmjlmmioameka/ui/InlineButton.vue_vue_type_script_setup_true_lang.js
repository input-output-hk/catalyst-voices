import { d as defineComponent, o as openBlock, c as createElementBlock, e as createBaseVNode, t as toDisplayString, n as normalizeClass } from "./index.js";
const _hoisted_1 = ["disabled"];
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "InlineButton",
  props: {
    label: { type: String },
    labelCSS: { type: String, default: "ml-2 px-2 py-2" },
    link: { type: Function, default: null },
    capitalize: { type: Boolean, default: true },
    disabled: { type: Boolean, default: false },
    color: { type: String, default: "blue" }
  },
  setup(__props) {
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("button", {
        type: "button",
        disabled: __props.disabled,
        onClick: _cache[0] || (_cache[0] = ($event) => {
          var _a;
          return (_a = __props.link) == null ? void 0 : _a.call(__props);
        }),
        class: normalizeClass(["inline-flex justify-center items-center text-sm cc-text-bold", (__props.color === "blue" ? "cc-btn-secondary-inline " : "cc-btn-warning-inline ") + __props.labelCSS])
      }, [
        createBaseVNode("span", {
          class: normalizeClass(__props.capitalize ? "capitalize" : "")
        }, toDisplayString(__props.label), 3)
      ], 10, _hoisted_1);
    };
  }
});
export {
  _sfc_main as _
};
