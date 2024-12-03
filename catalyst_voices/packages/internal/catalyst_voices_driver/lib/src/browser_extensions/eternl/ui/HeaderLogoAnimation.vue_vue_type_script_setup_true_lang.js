import { d as defineComponent, o as openBlock, c as createElementBlock, u as unref, X as isBetaApp } from "./index.js";
const _imports_0 = "/images/img-logo-small.png";
const _imports_1 = "/images/img-logo-small-beta.png";
const _hoisted_1 = {
  class: "relative",
  style: { "width": "106px", "height": "36px" }
};
const _hoisted_2 = {
  key: 0,
  src: _imports_0,
  alt: "",
  class: "absolute top-0 left-0 origin-top-left scale-100",
  style: { "height": "36px" }
};
const _hoisted_3 = {
  key: 1,
  src: _imports_1,
  alt: "",
  class: "absolute top-0 left-0 origin-top-left scale-100",
  style: { "height": "36px" }
};
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "HeaderLogoAnimation",
  setup(__props) {
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", _hoisted_1, [
        !unref(isBetaApp)() ? (openBlock(), createElementBlock("img", _hoisted_2)) : (openBlock(), createElementBlock("img", _hoisted_3))
      ]);
    };
  }
});
export {
  _sfc_main as _
};
