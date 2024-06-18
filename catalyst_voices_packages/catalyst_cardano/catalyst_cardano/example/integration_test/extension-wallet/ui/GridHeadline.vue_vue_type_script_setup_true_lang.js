import { d as defineComponent, o as openBlock, c as createElementBlock, t as toDisplayString, a as createBlock, n as normalizeClass } from "./index.js";
const _hoisted_1 = ["innerHTML"];
const _hoisted_2 = {
  key: 1,
  class: "col-span-12 flex flex-row flex-nowrap justify-start whitespace-pre-wrap"
};
const _sfc_main$1 = /* @__PURE__ */ defineComponent({
  __name: "GridText",
  props: {
    text: { type: String },
    html: { type: Boolean, required: false }
  },
  setup(__props) {
    return (_ctx, _cache) => {
      return __props.html ? (openBlock(), createElementBlock("div", {
        key: 0,
        class: "col-span-12 flex flex-row flex-nowrap justify-start whitespace-pre-wrap",
        innerHTML: __props.text
      }, null, 8, _hoisted_1)) : (openBlock(), createElementBlock("div", _hoisted_2, toDisplayString(__props.text), 1));
    };
  }
});
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "GridHeadline",
  props: {
    label: { type: String },
    dense: { type: Boolean, default: false },
    doCapitalize: { type: Boolean, default: true }
  },
  setup(__props) {
    return (_ctx, _cache) => {
      return openBlock(), createBlock(_sfc_main$1, {
        text: __props.label,
        class: normalizeClass(["cc-text-bold", __props.doCapitalize ? "capitalize" : ""])
      }, null, 8, ["text", "class"]);
    };
  }
});
export {
  _sfc_main as _,
  _sfc_main$1 as a
};
