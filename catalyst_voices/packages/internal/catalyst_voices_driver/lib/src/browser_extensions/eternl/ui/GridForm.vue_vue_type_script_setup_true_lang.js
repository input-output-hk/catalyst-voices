import { d as defineComponent, z as ref, D as watch, o as openBlock, c as createElementBlock, aA as renderSlot, q as createVNode, u as unref, e as createBaseVNode, ab as withKeys, b as withModifiers } from "./index.js";
import { u as useTranslation } from "./useTranslation.js";
import { _ as _sfc_main$1 } from "./GridButtonPrimary.vue_vue_type_script_setup_true_lang.js";
import { G as GridButtonSecondary } from "./GridButtonSecondary.js";
const _hoisted_1 = ["id"];
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "GridForm",
  props: {
    formId: { type: String, required: true },
    resetButtonLabel: { type: String, required: false, default: null },
    submitButtonLabel: { type: String, required: false, default: null },
    submitDisabled: { type: Boolean, required: false, default: false },
    resetDisabled: { type: Boolean, required: false, default: false }
  },
  emits: ["doFormReset", "doFormSubmit"],
  setup(__props, { emit: __emit }) {
    const props = __props;
    const emit = __emit;
    const { it } = useTranslation();
    function doFormReset() {
      emit("doFormReset");
    }
    function doFormSubmit() {
      emit("doFormSubmit");
    }
    const isSubmitDisabled = ref(props.submitDisabled);
    const isResetDisabled = ref(props.resetDisabled);
    watch(() => props.submitDisabled, (disabled) => {
      isSubmitDisabled.value = disabled;
    });
    watch(() => props.resetDisabled, (disabled) => {
      isResetDisabled.value = disabled;
    });
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("form", {
        rel: "noopener noreferrer",
        class: "cc-grid",
        id: __props.formId,
        onSubmit: _cache[0] || (_cache[0] = withModifiers(() => {
        }, ["prevent"]))
      }, [
        renderSlot(_ctx.$slots, "content"),
        renderSlot(_ctx.$slots, "btnBack"),
        createVNode(GridButtonSecondary, {
          class: "col-start-0 col-span-6 sm:col-start-7 sm:col-span-3",
          label: __props.resetButtonLabel || unref(it)("common.label.reset"),
          link: doFormReset,
          form: __props.formId,
          type: "button",
          disabled: isResetDisabled.value
        }, null, 8, ["label", "form", "disabled"]),
        createVNode(_sfc_main$1, {
          class: "col-start-7 col-span-6 sm:col-start-10 sm:col-span-3",
          label: __props.submitButtonLabel || unref(it)("common.label.save"),
          link: doFormSubmit,
          form: __props.formId,
          type: "submit",
          disabled: isSubmitDisabled.value
        }, null, 8, ["label", "form", "disabled"]),
        createBaseVNode("input", {
          type: "submit",
          hidden: "",
          onKeyup: withKeys(doFormSubmit, ["enter"])
        }, null, 32)
      ], 40, _hoisted_1);
    };
  }
});
export {
  _sfc_main as _
};
