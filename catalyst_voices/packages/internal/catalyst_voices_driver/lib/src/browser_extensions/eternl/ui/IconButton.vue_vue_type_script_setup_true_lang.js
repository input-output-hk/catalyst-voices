import { d as defineComponent, z as ref, o as openBlock, c as createElementBlock, n as normalizeClass, j as createCommentVNode, b as withModifiers } from "./index.js";
const _hoisted_1 = ["disabled", "aria-label"];
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "IconButton",
  props: {
    icon: { type: String, default: null },
    ariaLabel: { type: String, default: "notset" },
    disabled: { type: Boolean, default: false },
    animate: { type: Boolean, default: false }
  },
  setup(__props) {
    const button = ref(null);
    function removeFocus() {
      var _a;
      (_a = button.value) == null ? void 0 : _a.blur();
    }
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("button", {
        class: "group flex justify-center items-center cc-rounded",
        ref_key: "button",
        ref: button,
        onClick: withModifiers(removeFocus, ["stop"]),
        disabled: __props.disabled,
        "aria-label": __props.ariaLabel
      }, [
        __props.icon ? (openBlock(), createElementBlock("i", {
          key: 0,
          class: normalizeClass(__props.icon + (__props.animate ? " animate-spin" : ""))
        }, null, 2)) : createCommentVNode("", true)
      ], 8, _hoisted_1);
    };
  }
});
export {
  _sfc_main as _
};
