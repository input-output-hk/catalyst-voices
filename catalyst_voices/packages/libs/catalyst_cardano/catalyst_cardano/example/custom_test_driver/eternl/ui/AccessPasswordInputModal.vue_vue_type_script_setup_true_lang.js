import { M as Modal } from "./Modal.js";
import { _ as _sfc_main$4, a as _sfc_main$5 } from "./GridHeadline.vue_vue_type_script_setup_true_lang.js";
import { u as useTranslation } from "./useTranslation.js";
import { _ as _sfc_main$3 } from "./GridForm.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$2 } from "./GFEPassword.vue_vue_type_script_setup_true_lang.js";
import { d as defineComponent, z as ref, S as reactive, f as computed, o as openBlock, a as createBlock, h as withCtx, q as createVNode, aA as renderSlot, u as unref, e as createBaseVNode, j as createCommentVNode } from "./index.js";
const _sfc_main$1 = /* @__PURE__ */ defineComponent({
  __name: "GridFormAccessPasswordInput",
  props: {
    textId: { type: String, default: "" },
    submitButtonLabel: { type: String, required: true },
    autocomplete: { type: String, required: false, default: "off" },
    autofocus: { type: Boolean, required: false, default: false },
    showInfo: { type: Boolean, required: false, default: true }
  },
  emits: ["submit"],
  setup(__props, { emit: __emit }) {
    const emit = __emit;
    const { it } = useTranslation();
    const resetCounter = ref(0);
    const submittable = reactive({
      password: false
    });
    const errors = reactive({
      password: false
    });
    let password = "";
    async function onInputPassword(payload) {
      if (submittable.password) {
        password = payload.password;
      }
      submittable.password = payload.submittable;
      errors.password = payload.error;
    }
    async function onSubmit() {
      if (!submitEnabled.value || !password) return;
      emit("submit", { password });
    }
    function onReset() {
      password = "";
      resetCounter.value = resetCounter.value + 1;
    }
    const submitEnabled = computed(() => !errors.password && submittable.password);
    return (_ctx, _cache) => {
      return openBlock(), createBlock(_sfc_main$3, {
        onDoFormReset: onReset,
        onDoFormSubmit: onSubmit,
        "form-id": "AccessPasswordInputForm",
        "reset-button-label": unref(it)("common.label.reset"),
        "submit-button-label": __props.submitButtonLabel,
        "submit-disabled": !submitEnabled.value
      }, {
        content: withCtx(() => [
          createVNode(_sfc_main$2, {
            class: "col-span-12",
            onOnSubmittable: onInputPassword,
            "reset-counter": resetCounter.value,
            "input-id": "AccessPasswordInput",
            "skip-validation": true,
            "text-id": __props.textId + ".current",
            autocomplete: __props.autocomplete,
            "show-info": __props.showInfo,
            autofocus: __props.autofocus
          }, null, 8, ["reset-counter", "text-id", "autocomplete", "show-info", "autofocus"])
        ]),
        btnBack: withCtx(() => [
          renderSlot(_ctx.$slots, "btnBack")
        ]),
        _: 3
      }, 8, ["reset-button-label", "submit-button-label", "submit-disabled"]);
    };
  }
});
const _hoisted_1 = { class: "grow-0 shrink-0 w-full flex flex-row flex-nowrap items-start justify-between cc-bg-white-0 border-b cc-p" };
const _hoisted_2 = { class: "flex flex-col cc-text-sz" };
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "AccessPasswordInputModal",
  props: {
    showModal: { type: Boolean, required: true },
    textId: { type: String, required: false, default: "form.password.access" },
    title: { type: String, required: false, default: void 0 },
    caption: { type: String, required: false, default: void 0 },
    modalCSS: { type: String, required: false, default: void 0 },
    scrollable: { type: Boolean, required: false, default: false },
    persistent: { type: Boolean, required: false, default: false },
    repeatPassword: { type: Boolean, required: false, default: false },
    validatePassword: { type: Boolean, required: false, default: false },
    autofocus: { type: Boolean, required: false, default: false },
    submitButtonLabel: { type: String, required: true },
    showInfo: { type: Boolean, required: false, default: true }
  },
  emits: ["close", "submit"],
  setup(__props, { emit: __emit }) {
    const emit = __emit;
    async function onSubmit(payload) {
      emit("submit", {
        password: payload.password
      });
    }
    const onClose = () => emit("close");
    return (_ctx, _cache) => {
      return __props.showModal ? (openBlock(), createBlock(Modal, {
        key: 0,
        "modal-container": "#eternl-password",
        persistent: __props.persistent,
        narrow: "",
        onClose
      }, {
        header: withCtx(() => [
          createBaseVNode("div", _hoisted_1, [
            createBaseVNode("div", _hoisted_2, [
              createVNode(_sfc_main$4, {
                label: __props.title,
                "do-capitalize": ""
              }, null, 8, ["label"]),
              createVNode(_sfc_main$5, { text: __props.caption }, null, 8, ["text"])
            ])
          ])
        ]),
        content: withCtx(() => [
          createVNode(_sfc_main$1, {
            class: "col-span-12 w-full p-4",
            "text-id": __props.textId,
            "submit-button-label": __props.submitButtonLabel,
            autocomplete: "off",
            "skip-validation": "",
            autofocus: __props.autofocus,
            "show-info": __props.showInfo,
            onSubmit
          }, null, 8, ["text-id", "submit-button-label", "autofocus", "show-info"])
        ]),
        _: 1
      }, 8, ["persistent"])) : createCommentVNode("", true);
    };
  }
});
export {
  _sfc_main as _
};
