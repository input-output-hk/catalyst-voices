import { _ as _export_sfc } from "./_plugin-vue_export-helper.js";
import { o as openBlock, c as createElementBlock, e as createBaseVNode, aA as renderSlot, d as defineComponent, C as onMounted, z as ref, ex as useScroll, n as normalizeClass, ey as useResetScroll, a as createBlock, h as withCtx, q as createVNode, ez as useSlots, f as computed, j as createCommentVNode, H as Fragment } from "./index.js";
import { G as GridSpace } from "./GridSpace.js";
const _sfc_main$4 = {};
const _hoisted_1$1 = { class: "relative overflow-x-auto overflow-y-hidden bg-cc-white dark:bg-cc-dark-500" };
const _hoisted_2 = { class: "relative sm:min-w-content cc-flex-fixed flex flex-col flex-nowrap justify-center items-center" };
function _sfc_render(_ctx, _cache) {
  return openBlock(), createElementBlock("div", _hoisted_1$1, [
    createBaseVNode("div", _hoisted_2, [
      renderSlot(_ctx.$slots, "default")
    ])
  ]);
}
const PageHeader = /* @__PURE__ */ _export_sfc(_sfc_main$4, [["render", _sfc_render]]);
const _sfc_main$3 = /* @__PURE__ */ defineComponent({
  __name: "ScrollPage",
  props: {
    addScroll: { type: Boolean, required: false, default: true }
  },
  setup(__props) {
    const { resetScroll } = useResetScroll();
    onMounted(() => {
      resetScroll();
    });
    const scrollElement = ref(null);
    useScroll(scrollElement);
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", {
        class: normalizeClass(["scrollpage absolute w-full h-full cc-rounded-xl-r scroll-anchor", __props.addScroll ? " overflow-y-scroll overflow-x-hidden " : "overflow-hidden "]),
        ref_key: "scrollElement",
        ref: scrollElement
      }, [
        renderSlot(_ctx.$slots, "default")
      ], 2);
    };
  }
});
const _sfc_main$2 = /* @__PURE__ */ defineComponent({
  __name: "GridScrollPage",
  props: {
    alignTop: { type: Boolean, required: false, default: false },
    fullWidth: { type: Boolean, required: false, default: false },
    containerCSS: { type: String, required: false, default: "" },
    addScroll: { type: Boolean, required: false, default: true }
  },
  setup(__props) {
    return (_ctx, _cache) => {
      return openBlock(), createBlock(_sfc_main$3, { "add-scroll": __props.addScroll }, {
        default: withCtx(() => [
          createBaseVNode("div", {
            class: normalizeClass(["relative w-full h-full sm:min-w-content flex justify-center items-start", __props.containerCSS + " " + (__props.alignTop ? "" : "sm:items-center")])
          }, [
            createBaseVNode("div", {
              class: normalizeClass(["relative w-full grid grid-cols-12 cc-page-gap", __props.fullWidth ? "" : "max-w-6xl"])
            }, [
              renderSlot(_ctx.$slots, "default"),
              createVNode(GridSpace, { dense: "" })
            ], 2)
          ], 2)
        ]),
        _: 3
      }, 8, ["add-scroll"]);
    };
  }
});
const _sfc_main$1 = /* @__PURE__ */ defineComponent({
  __name: "FlexScrollPage",
  props: {
    alignTop: { type: Boolean, required: false, default: false },
    fullWidth: { type: Boolean, required: false, default: false },
    containerCSS: { type: String, required: false, default: "" }
  },
  setup(__props) {
    return (_ctx, _cache) => {
      return openBlock(), createBlock(_sfc_main$3, null, {
        default: withCtx(() => [
          createBaseVNode("div", {
            class: normalizeClass(["relative w-full h-full sm:min-w-content flex justify-center items-start", __props.containerCSS + " " + (__props.alignTop ? "" : "sm:items-center")])
          }, [
            createBaseVNode("div", {
              class: normalizeClass(["relative w-full flex flex-col flex-nowrap cc-page-gap", __props.fullWidth ? "" : "max-w-6xl"])
            }, [
              renderSlot(_ctx.$slots, "default"),
              createVNode(GridSpace, { dense: "" })
            ], 2)
          ], 2)
        ]),
        _: 3
      });
    };
  }
});
const _hoisted_1 = { class: "relative flex-1" };
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "Page",
  props: {
    alignTop: { type: Boolean, required: false, default: false },
    fullWidth: { type: Boolean, required: false, default: false },
    flexPage: { type: Boolean, required: false, default: false },
    containerCSS: { type: String, required: false, default: "cc-page-p" },
    addScroll: { type: Boolean, required: false, default: true }
  },
  setup(__props) {
    const slots = useSlots();
    const hasSlotHeader = computed(() => typeof slots.header !== "undefined");
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock(Fragment, null, [
        hasSlotHeader.value ? (openBlock(), createBlock(PageHeader, { key: 0 }, {
          default: withCtx(() => [
            renderSlot(_ctx.$slots, "header")
          ]),
          _: 3
        })) : createCommentVNode("", true),
        createBaseVNode("div", _hoisted_1, [
          _cache[0] || (_cache[0] = createBaseVNode("div", { class: "absolute inset-0" }, null, -1)),
          !__props.flexPage ? (openBlock(), createBlock(_sfc_main$2, {
            key: 0,
            containerCSS: __props.containerCSS,
            "align-top": __props.alignTop,
            "full-width": __props.fullWidth,
            "add-scroll": __props.addScroll
          }, {
            default: withCtx(() => [
              renderSlot(_ctx.$slots, "default")
            ]),
            _: 3
          }, 8, ["containerCSS", "align-top", "full-width", "add-scroll"])) : (openBlock(), createBlock(_sfc_main$1, {
            key: 1,
            containerCSS: __props.containerCSS,
            "align-top": __props.alignTop,
            "full-width": __props.fullWidth
          }, {
            default: withCtx(() => [
              renderSlot(_ctx.$slots, "default")
            ]),
            _: 3
          }, 8, ["containerCSS", "align-top", "full-width"]))
        ]),
        renderSlot(_ctx.$slots, "bottomNavigation")
      ], 64);
    };
  }
});
export {
  _sfc_main as _
};
