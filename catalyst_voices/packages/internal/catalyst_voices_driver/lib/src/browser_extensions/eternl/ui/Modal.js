import { d as defineComponent, ez as useSlots, z as ref, f as computed, C as onMounted, o as openBlock, a as createBlock, e as createBaseVNode, q as createVNode, h as withCtx, c as createElementBlock, n as normalizeClass, b as withModifiers, ab as withKeys, aA as renderSlot, j as createCommentVNode, eA as Transition, iO as Teleport, V as nextTick } from "./index.js";
import { u as useTranslation } from "./useTranslation.js";
import { _ as _export_sfc } from "./_plugin-vue_export-helper.js";
const _hoisted_1 = {
  key: 0,
  class: "relative w-full h-full bg-black/50 cc-layout-py"
};
const _hoisted_2 = {
  key: 0,
  class: "base-10 shrink-0 w-full cc-bg-white-0 flex flex-col flex-nowrap justify-start items-start"
};
const _hoisted_3 = {
  key: 1,
  class: "relative grow w-full cc-bg-light-1 overflow-auto"
};
const _hoisted_4 = {
  key: 2,
  class: "base-10 shrink-0 w-full cc-bg-white-0"
};
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "Modal",
  props: {
    modalContainer: { type: String, required: false, default: "#ccvaultio-modal" },
    wide: { type: Boolean, required: false, default: false },
    halfWide: { type: Boolean, required: false, default: false },
    narrow: { type: Boolean, required: false, default: false },
    fullWidthOnMobile: { type: Boolean, required: false, default: false },
    maxHeight: { type: Boolean, required: false, default: false },
    persistent: { type: Boolean, required: false, default: false }
  },
  emits: ["preclose", "close"],
  setup(__props, { emit: __emit }) {
    const props = __props;
    const emit = __emit;
    const slots = useSlots();
    useTranslation();
    const isModalVisible = ref(false);
    const hasSlotHeader = computed(() => typeof slots["header"] !== "undefined");
    const hasSlotContent = computed(() => typeof slots["content"] !== "undefined");
    const hasSlotFooter = computed(() => typeof slots["footer"] !== "undefined");
    onMounted(() => {
      isModalVisible.value = true;
    });
    const handleESC = () => !props.persistent && handleClose();
    const handleClose = () => {
      emit("preclose");
      nextTick(() => {
        isModalVisible.value = false;
      });
      setTimeout(() => {
        emit("close");
      }, 200);
    };
    return (_ctx, _cache) => {
      return openBlock(), createBlock(Teleport, { to: __props.modalContainer }, [
        createBaseVNode("div", {
          class: "et-modal absolute block inset-0 w-screen h-screen",
          onKeydown: withKeys(handleESC, ["esc"])
        }, [
          createVNode(Transition, { name: "fade" }, {
            default: withCtx(() => [
              isModalVisible.value ? (openBlock(), createElementBlock("div", _hoisted_1, [
                createBaseVNode("div", {
                  class: normalizeClass(["relative w-full h-full flex flex-col flex-nowrap justify-center items-center pt-20 sm:px-4 sm:pt-20 pb-10", __props.fullWidthOnMobile ? "" : "px-2"])
                }, [
                  createBaseVNode("div", {
                    class: "absolute inset-0 w-full h-full cursor-pointer",
                    onClick: withModifiers(handleClose, ["stop", "prevent"])
                  }),
                  createBaseVNode("div", {
                    class: normalizeClass(["relative bg-amber-200 w-full flex flex-col flex-nowrap justify-center items-center overflow-hidden cc-shadow cc-bg-white-0", (__props.wide ? "max-w-full" : __props.narrow ? "max-w-xl" : __props.halfWide ? "max-w-4xl" : "max-w-7xl") + " " + (__props.maxHeight ? "h-full" : "") + " " + (__props.fullWidthOnMobile ? "sm:cc-rounded" : "cc-rounded")]),
                    onKeydown: withKeys(handleESC, ["esc"])
                  }, [
                    hasSlotHeader.value ? (openBlock(), createElementBlock("div", _hoisted_2, [
                      renderSlot(_ctx.$slots, "header", {}, void 0, true)
                    ])) : createCommentVNode("", true),
                    hasSlotContent.value ? (openBlock(), createElementBlock("div", _hoisted_3, [
                      renderSlot(_ctx.$slots, "content", {}, void 0, true)
                    ])) : createCommentVNode("", true),
                    hasSlotFooter.value ? (openBlock(), createElementBlock("div", _hoisted_4, [
                      renderSlot(_ctx.$slots, "footer", {}, void 0, true)
                    ])) : createCommentVNode("", true),
                    createBaseVNode("button", {
                      class: "absolute right-0 top-0 w-10 h-10 cc-rounded cc-bg-white-0-hover cc-text-lg",
                      onClick: withModifiers(handleClose, ["stop", "prevent"])
                    }, _cache[0] || (_cache[0] = [
                      createBaseVNode("i", { class: "mdi mdi-close font-extrabold" }, null, -1)
                    ]))
                  ], 34)
                ], 2)
              ])) : createCommentVNode("", true)
            ]),
            _: 3
          })
        ], 32)
      ], 8, ["to"]);
    };
  }
});
const Modal = /* @__PURE__ */ _export_sfc(_sfc_main, [["__scopeId", "data-v-28f14991"]]);
export {
  Modal as M
};
