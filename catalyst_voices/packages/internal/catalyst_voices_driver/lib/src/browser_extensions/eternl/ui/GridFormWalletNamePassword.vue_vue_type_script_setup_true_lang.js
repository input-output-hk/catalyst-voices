import { u as useTranslation } from "./useTranslation.js";
import { G as GridSpace } from "./GridSpace.js";
import { _ as _sfc_main$4 } from "./GridForm.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$1 } from "./GFEWalletName.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$2 } from "./GFEPassword.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$3 } from "./GFERepeatPassword.vue_vue_type_script_setup_true_lang.js";
import { d as defineComponent, z as ref, S as reactive, f as computed, o as openBlock, a as createBlock, h as withCtx, q as createVNode, aA as renderSlot, u as unref } from "./index.js";
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "GridFormWalletNamePassword",
  props: {
    prefilledWalletName: { type: String, required: false, default: "" }
  },
  emits: ["submit"],
  setup(__props, { emit: __emit }) {
    const emit = __emit;
    const { it } = useTranslation();
    const resetCounter = ref(0);
    const submittable = reactive({
      walletName: false,
      spendingPassword: false,
      repeatPassword: false
    });
    const errors = reactive({
      walletName: false,
      spendingPassword: false,
      repeatPassword: false
    });
    const walletName = ref("");
    const spendingPassword = ref("");
    function onSetWalletName(payload) {
      submittable.walletName = payload.submittable;
      errors.walletName = payload.error;
      if (submittable.walletName) {
        walletName.value = payload.walletName;
      }
    }
    function onSetRepeatPassword(payload) {
      submittable.repeatPassword = payload.submittable;
      errors.repeatPassword = payload.error;
    }
    function onSetSpendingPassword(payload) {
      submittable.spendingPassword = payload.submittable;
      errors.spendingPassword = payload.error;
      if (submittable.spendingPassword) {
        spendingPassword.value = payload.password;
      }
    }
    async function onSubmit() {
      emit("submit", {
        walletName: walletName.value,
        password: spendingPassword.value
      });
      spendingPassword.value = "";
      onReset();
    }
    function onReset() {
      resetCounter.value = resetCounter.value + 1;
    }
    const submitEnabled = computed(() => !errors.walletName && !errors.spendingPassword && !errors.repeatPassword && (submittable.walletName && submittable.spendingPassword && submittable.repeatPassword));
    return (_ctx, _cache) => {
      return openBlock(), createBlock(_sfc_main$4, {
        onDoFormReset: onReset,
        onDoFormSubmit: onSubmit,
        "form-id": "GridFormWalletNamePassword",
        "reset-button-label": unref(it)("common.label.reset"),
        "submit-button-label": unref(it)("common.label.save"),
        "submit-disabled": !submitEnabled.value
      }, {
        content: withCtx(() => [
          createVNode(_sfc_main$1, {
            class: "col-span-12",
            onOnSubmittable: onSetWalletName,
            "prefilled-wallet-name": __props.prefilledWalletName,
            autofocus: "",
            resetCounter: resetCounter.value
          }, null, 8, ["prefilled-wallet-name", "resetCounter"]),
          createVNode(GridSpace, { dense: "" }),
          createVNode(_sfc_main$2, {
            class: "col-span-12 lg:col-span-6",
            onOnSubmittable: onSetSpendingPassword,
            "reset-counter": resetCounter.value,
            "text-id": "form.password.spending.enter"
          }, null, 8, ["reset-counter"]),
          createVNode(_sfc_main$3, {
            class: "col-span-12 lg:col-span-6",
            onOnSubmittable: onSetRepeatPassword,
            "compare-password": spendingPassword.value,
            resetCounter: resetCounter.value,
            "text-id": "form.password.spending.repeat"
          }, null, 8, ["compare-password", "resetCounter"]),
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
