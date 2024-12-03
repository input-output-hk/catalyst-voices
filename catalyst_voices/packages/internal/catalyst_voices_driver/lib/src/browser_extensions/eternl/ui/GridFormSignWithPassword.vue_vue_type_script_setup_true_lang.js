import { u as useTranslation } from "./useTranslation.js";
import { G as GridSpace } from "./GridSpace.js";
import { _ as _sfc_main$2 } from "./GridForm.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$1 } from "./GFEPassword.vue_vue_type_script_setup_true_lang.js";
import { d as defineComponent, z as ref, S as reactive, f as computed, o as openBlock, a as createBlock, h as withCtx, q as createVNode, aA as renderSlot, u as unref } from "./index.js";
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "GridFormSignWithPassword",
  props: {
    skipValidation: { type: Boolean, default: false },
    submitLabel: { type: String, reqired: false, default: "common.label.sign" },
    submitEnable: { type: Boolean, default: true },
    autofocus: { type: Boolean, default: false }
  },
  emits: ["submit", "reset"],
  setup(__props, { emit: __emit }) {
    const props = __props;
    const emit = __emit;
    const { it } = useTranslation();
    const resetCounter = ref(0);
    const spendingPassword = ref("");
    const submittable = reactive({
      spendingPassword: false
    });
    const errors = reactive({
      spendingPassword: false
    });
    function onSetSpendingPassword(payload) {
      if (submittable.spendingPassword) {
        spendingPassword.value = payload.password;
      }
      submittable.spendingPassword = payload.submittable;
      errors.spendingPassword = payload.error;
    }
    async function onSubmit() {
      if (!submitEnabled.value || !spendingPassword.value) return;
      emit("submit", {
        password: spendingPassword.value
      });
      spendingPassword.value = "";
      resetCounter.value = resetCounter.value + 1;
    }
    function onReset() {
      resetCounter.value = resetCounter.value + 1;
      emit("reset");
    }
    const submitEnabled = computed(() => !errors.spendingPassword && submittable.spendingPassword && props.submitEnable);
    return (_ctx, _cache) => {
      return openBlock(), createBlock(_sfc_main$2, {
        onDoFormReset: onReset,
        onDoFormSubmit: onSubmit,
        "form-id": "GridFormSignWithPassword",
        "reset-button-label": unref(it)("common.label.reset"),
        "submit-button-label": unref(it)(__props.submitLabel),
        "submit-disabled": !submitEnabled.value
      }, {
        content: withCtx(() => [
          createVNode(_sfc_main$1, {
            class: "col-span-12",
            onOnSubmittable: onSetSpendingPassword,
            "reset-counter": resetCounter.value,
            "skip-validation": __props.skipValidation,
            autofocus: __props.autofocus,
            autocomplete: "current-password",
            "text-id": "form.password.spending.sign"
          }, null, 8, ["reset-counter", "skip-validation", "autofocus"]),
          createVNode(GridSpace, {
            hr: "",
            class: "my-0.5 sm:my-2"
          })
        ]),
        btnBack: withCtx(() => [
          renderSlot(_ctx.$slots, "btnBack")
        ]),
        _: 3
      }, 8, ["reset-button-label", "submit-button-label", "submit-disabled"]);
    };
  }
});
export {
  _sfc_main as _
};
