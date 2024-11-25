import { d as defineComponent, z as ref, o as openBlock, a as createBlock, h as withCtx, aA as renderSlot, n as normalizeClass, iL as QTooltip_default } from "./index.js";
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "Tooltip",
  props: {
    tooltipCSS: { type: String, required: false, default: "" },
    anchor: { type: String, required: false },
    self: { type: String, required: false },
    transitionShow: { type: String, required: false },
    transitionHide: { type: String, required: false },
    offset: { type: Array, required: false },
    target: { type: Object, required: false, default: void 0 },
    autoHide: { type: Boolean, required: false, default: false }
  },
  setup(__props) {
    const props = __props;
    const tt = ref(null);
    const onShow = () => {
      if (props.autoHide) {
        setTimeout(() => {
          var _a;
          (_a = tt.value) == null ? void 0 : _a.hide();
        }, 4e3);
      }
    };
    return (_ctx, _cache) => {
      return openBlock(), createBlock(QTooltip_default, {
        class: normalizeClass("py-0.5 px-2 text-xs " + __props.tooltipCSS),
        anchor: __props.anchor,
        self: __props.self,
        "transition-show": __props.transitionShow,
        "transition-hide": __props.transitionHide,
        offset: __props.offset,
        delay: 550,
        target: __props.target,
        ref_key: "tt",
        ref: tt,
        onShow
      }, {
        default: withCtx(() => [
          renderSlot(_ctx.$slots, "default")
        ]),
        _: 3
      }, 8, ["class", "anchor", "self", "transition-show", "transition-hide", "offset", "target"]);
    };
  }
});
export {
  _sfc_main as _
};
