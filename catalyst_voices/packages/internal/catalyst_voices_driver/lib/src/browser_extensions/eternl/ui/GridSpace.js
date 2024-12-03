import { d as defineComponent, o as openBlock, c as createElementBlock, n as normalizeClass, j as createCommentVNode, e as createBaseVNode, t as toDisplayString } from "./index.js";
import { _ as _export_sfc } from "./_plugin-vue_export-helper.js";
const _hoisted_1 = {
  key: 1,
  class: "col-span-12"
};
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "GridSpace",
  props: {
    dense: { type: Boolean, default: false },
    hr: { type: Boolean, default: false },
    label: { type: String, default: "" },
    alignLabel: { type: String, default: "center" },
    labelCSS: { type: String, default: "cc-text-xs" },
    lineCSS: { type: String, default: "" }
  },
  setup(__props) {
    return (_ctx, _cache) => {
      return !__props.hr ? (openBlock(), createElementBlock("div", {
        key: 0,
        class: normalizeClass(["col-span-12", __props.dense ? " h-0" : " h-1"])
      }, null, 2)) : (openBlock(), createElementBlock("div", _hoisted_1, [
        __props.label.length === 0 ? (openBlock(), createElementBlock("div", {
          key: 0,
          class: normalizeClass(["w-full border-b", __props.lineCSS])
        }, null, 2)) : createCommentVNode("", true),
        __props.label.length > 0 ? (openBlock(), createElementBlock("div", {
          key: 1,
          class: normalizeClass(["flex items-center text-center separator", __props.lineCSS + (" separator-" + __props.alignLabel)])
        }, [
          createBaseVNode("span", {
            class: normalizeClass(__props.labelCSS)
          }, toDisplayString(__props.label), 3)
        ], 2)) : createCommentVNode("", true)
      ]));
    };
  }
});
const GridSpace = /* @__PURE__ */ _export_sfc(_sfc_main, [["__scopeId", "data-v-cf1a29a6"]]);
export {
  GridSpace as G
};
