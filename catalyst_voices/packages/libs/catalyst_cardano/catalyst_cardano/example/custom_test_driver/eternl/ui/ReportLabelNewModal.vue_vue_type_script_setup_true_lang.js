import { u as useTranslation } from "./useTranslation.js";
import { I as IconPencil } from "./IconPencil.js";
import { G as GridInput } from "./GridInput.js";
import { _ as _sfc_main$3 } from "./GridButtonPrimary.vue_vue_type_script_setup_true_lang.js";
import { G as GridButtonSecondary } from "./GridButtonSecondary.js";
import { _ as _sfc_main$1, a as _sfc_main$2 } from "./GridHeadline.vue_vue_type_script_setup_true_lang.js";
import { M as Modal } from "./Modal.js";
import { d as defineComponent, a5 as toRefs, f as computed, z as ref, u as unref, o as openBlock, a as createBlock, h as withCtx, e as createBaseVNode, q as createVNode, c as createElementBlock, j as createCommentVNode } from "./index.js";
const _hoisted_1 = { class: "grow-0 shrink-0 w-full flex flex-row flex-nowrap items-start justify-between border-b cc-p" };
const _hoisted_2 = { class: "flex flex-col cc-text-sz" };
const _hoisted_3 = {
  key: 0,
  class: "grid grid-cols-12 cc-gap p-4 w-full"
};
const _hoisted_4 = { class: "px-4 pb-4" };
const _hoisted_5 = { class: "grid grid-cols-12 cc-gap" };
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "ReportLabelNewModal",
  props: {
    showModal: { type: Object, required: true },
    isNew: { type: Boolean, required: false, default: false },
    isEdit: { type: Boolean, required: false, default: false },
    id: { type: String, required: false, default: "notset" },
    value: { type: String, required: false, default: "" }
  },
  emits: ["close", "submit"],
  setup(__props, { emit: __emit }) {
    const props = __props;
    const emit = __emit;
    const { it } = useTranslation();
    const { showModal } = toRefs(props);
    const mode = computed(() => "reportLabels");
    const input = ref(props.value ?? "");
    const inputError = ref("");
    const idInput = ref(mode.value === "add" ? "" : props.id ?? "");
    const idInputError = ref("");
    const entityIdInput = ref("");
    const entityIdInputError = ref("");
    const title = ref(`setting.reportEntity.${mode.value}.label`);
    const caption = ref(`setting.reportEntity.${mode.value}.caption`);
    const validateIdInput = () => {
      idInputError.value = idInput.value.length > 0 ? "" : it(`setting.reportEntity.${mode.value}.add.error`);
    };
    const onSubmit = () => {
      props.id === "new" ? idInput.value : props.id;
      emit("submit", input.value, idInput.value, entityIdInput.value);
      onClose();
    };
    const onReset = () => {
      input.value = "";
      inputError.value = "";
      idInput.value = "";
      idInputError.value = "";
      entityIdInput.value = "";
      entityIdInputError.value = "";
    };
    const onClose = () => {
      showModal.value.display = false;
      onReset();
      emit("close");
    };
    return (_ctx, _cache) => {
      var _a;
      return ((_a = unref(showModal)) == null ? void 0 : _a.display) ? (openBlock(), createBlock(Modal, {
        key: 0,
        "modal-container": "#eternl-modal",
        narrow: "",
        "full-width-on-mobile": "",
        onClose
      }, {
        header: withCtx(() => [
          createBaseVNode("div", _hoisted_1, [
            createBaseVNode("div", _hoisted_2, [
              createVNode(_sfc_main$1, {
                label: unref(it)(title.value)
              }, null, 8, ["label"])
            ])
          ])
        ]),
        content: withCtx(() => [
          caption.value ? (openBlock(), createElementBlock("div", _hoisted_3, [
            createVNode(_sfc_main$2, {
              text: unref(it)(caption.value)
            }, null, 8, ["text"])
          ])) : createCommentVNode("", true),
          createBaseVNode("div", _hoisted_4, [
            createVNode(GridInput, {
              "input-text": idInput.value,
              "onUpdate:inputText": _cache[0] || (_cache[0] = ($event) => idInput.value = $event),
              "input-error": idInputError.value,
              "onUpdate:inputError": _cache[1] || (_cache[1] = ($event) => idInputError.value = $event),
              class: "col-span-12 lg:col-span-4 pb-2",
              onLostFocus: validateIdInput,
              onEnter: onSubmit,
              onReset,
              label: unref(it)("setting.reportEntity.reportLabels.add.label.label"),
              "input-hint": unref(it)("setting.reportEntity.reportLabels.add.label.hint"),
              autofocus: true,
              alwaysShowInfo: false,
              showReset: true,
              "input-id": "inputLabel",
              "input-type": "text"
            }, {
              "icon-prepend": withCtx(() => [
                createVNode(IconPencil, { class: "h-5 w-5" })
              ]),
              _: 1
            }, 8, ["input-text", "input-error", "label", "input-hint"]),
            createVNode(GridInput, {
              "input-text": input.value,
              "onUpdate:inputText": _cache[2] || (_cache[2] = ($event) => input.value = $event),
              "input-error": inputError.value,
              "onUpdate:inputError": _cache[3] || (_cache[3] = ($event) => inputError.value = $event),
              class: "col-span-12 lg:col-span-8 pb-2",
              onEnter: onSubmit,
              onReset,
              label: unref(it)("setting.reportEntity.reportLabels.add.address.label"),
              "input-hint": unref(it)("setting.reportEntity.reportLabels.add.address.hint"),
              alwaysShowInfo: false,
              showReset: false,
              "input-disabled": !__props.isNew,
              "input-id": "inputAddress",
              "input-type": "text"
            }, {
              "icon-prepend": withCtx(() => [
                __props.isNew ? (openBlock(), createBlock(IconPencil, {
                  key: 0,
                  class: "h-5 w-5"
                })) : createCommentVNode("", true)
              ]),
              _: 1
            }, 8, ["input-text", "input-error", "label", "input-hint", "input-disabled"]),
            createVNode(GridInput, {
              "input-text": entityIdInput.value,
              "onUpdate:inputText": _cache[4] || (_cache[4] = ($event) => entityIdInput.value = $event),
              "input-error": entityIdInputError.value,
              "onUpdate:inputError": _cache[5] || (_cache[5] = ($event) => entityIdInputError.value = $event),
              class: "col-span-12 lg:col-span-8 pb-2",
              onEnter: onSubmit,
              onReset,
              label: unref(it)("setting.reportEntity.reportLabels.add.entity.label"),
              "input-hint": unref(it)("setting.reportEntity.reportLabels.add.entity.hint"),
              alwaysShowInfo: false,
              showReset: false,
              "input-id": "inputEntity",
              "input-type": "text"
            }, {
              "icon-prepend": withCtx(() => [
                __props.isNew ? (openBlock(), createBlock(IconPencil, {
                  key: 0,
                  class: "h-5 w-5"
                })) : createCommentVNode("", true)
              ]),
              _: 1
            }, 8, ["input-text", "input-error", "label", "input-hint"]),
            createBaseVNode("div", _hoisted_5, [
              createVNode(GridButtonSecondary, {
                label: unref(it)("setting.reportEntity.button.cancel"),
                link: onClose,
                class: "col-start-0 col-span-6 lg:col-start-7 lg:col-span-3"
              }, null, 8, ["label"]),
              createVNode(_sfc_main$3, {
                label: __props.isEdit ? unref(it)("setting.reportEntity.button.save") : unref(it)("setting.reportEntity.button.add"),
                link: onSubmit,
                disabled: __props.isEdit && input.value === __props.value || inputError.value.length > 0 || idInputError.value.length > 0 || idInput.value.length === 0 || input.value.length === 0,
                class: "col-span-6 lg:col-span-3"
              }, null, 8, ["label", "disabled"])
            ])
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
