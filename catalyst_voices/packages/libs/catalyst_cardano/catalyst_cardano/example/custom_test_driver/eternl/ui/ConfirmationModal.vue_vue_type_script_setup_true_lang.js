import { u as useTranslation } from "./useTranslation.js";
import { M as Modal } from "./Modal.js";
import { _ as _sfc_main$3 } from "./GridButtonPrimary.vue_vue_type_script_setup_true_lang.js";
import { G as GridButtonSecondary } from "./GridButtonSecondary.js";
import { _ as _sfc_main$1, a as _sfc_main$2 } from "./GridHeadline.vue_vue_type_script_setup_true_lang.js";
import { d as defineComponent, a5 as toRefs, z as ref, u as unref, o as openBlock, a as createBlock, h as withCtx, e as createBaseVNode, q as createVNode, j as createCommentVNode } from "./index.js";
const _hoisted_1 = { class: "grow-0 shrink-0 w-full flex flex-row flex-nowrap items-start justify-between border-b cc-p" };
const _hoisted_2 = { class: "flex flex-col cc-text-sz" };
const _hoisted_3 = { class: "grid grid-cols-12 cc-gap p-4 w-full" };
const _hoisted_4 = { class: "grid grid-cols-12 cc-gap p-2 w-full border-t" };
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "ConfirmationModal",
  props: {
    showModal: { type: Object, required: true },
    textId: { type: String, required: false, default: void 0 },
    title: { type: String, required: false, default: void 0 },
    caption: { type: String, required: false, default: void 0 },
    modalCSS: { type: String, required: false, default: void 0 },
    scrollable: { type: Boolean, required: false, default: false },
    persistent: { type: Boolean, required: false, default: false },
    repeatPassword: { type: Boolean, required: false, default: false },
    validatePassword: { type: Boolean, required: false, default: false },
    cancelLabel: { type: String, required: false, default: void 0 },
    confirmLabel: { type: String, required: false, default: void 0 }
  },
  emits: ["close", "confirm", "cancel"],
  setup(__props, { emit: __emit }) {
    const props = __props;
    const emit = __emit;
    const { it } = useTranslation();
    const { showModal } = toRefs(props);
    const cancelLabel = ref(props.cancelLabel);
    const confirmLabel = ref(props.confirmLabel);
    if (props.cancelLabel === void 0) {
      cancelLabel.value = it("common.label.cancel");
    }
    if (props.confirmLabel === void 0) {
      confirmLabel.value = it("common.label.confirm");
    }
    const onConfirm = () => {
      showModal.value.display = false;
      emit("confirm");
    };
    const onCancel = () => {
      showModal.value.display = false;
      emit("cancel");
    };
    const onClose = () => {
      showModal.value.display = false;
      emit("close");
    };
    return (_ctx, _cache) => {
      var _a;
      return ((_a = unref(showModal)) == null ? void 0 : _a.display) ? (openBlock(), createBlock(Modal, {
        key: 0,
        narrow: "",
        "full-width-on-mobile": "",
        onClose
      }, {
        header: withCtx(() => [
          createBaseVNode("div", _hoisted_1, [
            createBaseVNode("div", _hoisted_2, [
              createVNode(_sfc_main$1, { label: __props.title }, null, 8, ["label"])
            ])
          ])
        ]),
        content: withCtx(() => [
          createBaseVNode("div", _hoisted_3, [
            __props.caption ? (openBlock(), createBlock(_sfc_main$2, {
              key: 0,
              text: __props.caption
            }, null, 8, ["text"])) : createCommentVNode("", true)
          ])
        ]),
        footer: withCtx(() => [
          createBaseVNode("div", _hoisted_4, [
            createVNode(GridButtonSecondary, {
              label: cancelLabel.value,
              link: onCancel,
              class: "col-start-0 col-span-6 lg:col-start-0 lg:col-span-4"
            }, null, 8, ["label"]),
            createVNode(_sfc_main$3, {
              label: confirmLabel.value,
              link: onConfirm,
              class: "col-span-6 lg:col-start-9 lg:col-span-4"
            }, null, 8, ["label"])
          ])
        ]),
        _: 1
      })) : createCommentVNode("", true);
    };
  }
});
export {
  _sfc_main as _
};
