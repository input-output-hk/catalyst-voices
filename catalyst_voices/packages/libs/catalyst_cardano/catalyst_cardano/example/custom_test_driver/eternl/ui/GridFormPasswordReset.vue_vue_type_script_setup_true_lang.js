import { d as defineComponent, z as ref, D as watch, o as openBlock, a as createBlock, h as withCtx, q as createVNode, u as unref, S as reactive, f as computed, j as createCommentVNode, aA as renderSlot, ae as useSelectedAccount } from "./index.js";
import { u as useTranslation } from "./useTranslation.js";
import { G as GridSpace } from "./GridSpace.js";
import { _ as _sfc_main$4 } from "./GridForm.vue_vue_type_script_setup_true_lang.js";
import { I as IconLockClosed, u as usePasswordValidation, _ as _sfc_main$2 } from "./GFEPassword.vue_vue_type_script_setup_true_lang.js";
import { G as GridInput } from "./GridInput.js";
import { _ as _sfc_main$3 } from "./GFERepeatPassword.vue_vue_type_script_setup_true_lang.js";
const _sfc_main$1 = /* @__PURE__ */ defineComponent({
  __name: "GFEOldPassword",
  props: {
    textId: { type: String, default: "" },
    encrypted: { type: String, required: true, default: null },
    version: { type: String, required: false, default: "" },
    alwaysShowInfo: { type: Boolean, default: false },
    resetCounter: { type: Number, required: true, default: 0 }
  },
  emits: ["onSubmittable"],
  setup(__props, { emit: __emit }) {
    const props = __props;
    const emit = __emit;
    const { t } = useTranslation();
    const { checkPasswordCorrect } = usePasswordValidation();
    const password = ref("");
    const passwordError = ref("");
    function validatePasswordText() {
      if (password.value) {
        const res = checkPasswordCorrect(password.value, props.encrypted, props.version);
        if (res) {
          passwordError.value = "";
          emit("onSubmittable", { submittable: true, error: false, password: password.value });
        } else {
          passwordError.value = t(props.textId + ".error");
          emit("onSubmittable", { submittable: false, error: true });
        }
      } else {
        passwordError.value = "";
        emit("onSubmittable", { submittable: false, error: false });
      }
      return passwordError.value;
    }
    let tiod = -1;
    watch(password, () => {
      clearTimeout(tiod);
      tiod = setTimeout(() => {
        validatePasswordText();
      }, 500);
    });
    watch(() => props.resetCounter, () => {
      onResetPassword();
    });
    function onResetPassword() {
      password.value = "";
      passwordError.value = "";
    }
    return (_ctx, _cache) => {
      return openBlock(), createBlock(GridInput, {
        "input-text": password.value,
        "onUpdate:inputText": _cache[0] || (_cache[0] = ($event) => password.value = $event),
        "input-error": passwordError.value,
        "onUpdate:inputError": _cache[1] || (_cache[1] = ($event) => passwordError.value = $event),
        onLostFocus: validatePasswordText,
        onReset: onResetPassword,
        label: unref(t)(__props.textId + ".label"),
        "input-hint": unref(t)(__props.textId + ".hint"),
        "input-info": unref(t)(__props.textId + ".info"),
        alwaysShowInfo: __props.alwaysShowInfo,
        showReset: true,
        "input-id": "inputCurrentPassword",
        "input-type": "password",
        autocomplete: "new-password"
      }, {
        "icon-prepend": withCtx(() => [
          createVNode(IconLockClosed, { class: "w-5 h-5" })
        ]),
        _: 1
      }, 8, ["input-text", "input-error", "label", "input-hint", "input-info", "alwaysShowInfo"]);
    };
  }
});
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "GridFormPasswordReset",
  props: {
    textId: { type: String, default: "" },
    saving: { type: Boolean, required: false, default: false },
    requireOldPassword: { type: Boolean, required: false, default: true }
  },
  emits: ["submit"],
  setup(__props, { emit: __emit }) {
    const props = __props;
    const emit = __emit;
    const { it } = useTranslation();
    const {
      selectedWalletId,
      walletData
    } = useSelectedAccount();
    const resetCounter = ref(0);
    const submittable = reactive({
      oldPassword: !props.requireOldPassword,
      spendingPassword: false,
      repeatPassword: false
    });
    const errors = reactive({
      oldPassword: false,
      spendingPassword: false,
      repeatPassword: false
    });
    const prvKey = computed(() => {
      var _a, _b;
      return ((_b = (_a = walletData.value) == null ? void 0 : _a.wallet.rootKey) == null ? void 0 : _b.prv) ?? null;
    });
    const prvKeyVersion = computed(() => {
      var _a, _b;
      return ((_b = (_a = walletData.value) == null ? void 0 : _a.wallet.rootKey) == null ? void 0 : _b.v) ?? "";
    });
    const oldSpendingPassword = ref("");
    const spendingPassword = ref("");
    function onSetOldPassword(payload) {
      submittable.oldPassword = payload.submittable;
      errors.oldPassword = payload.error;
      if (submittable.oldPassword) {
        oldSpendingPassword.value = payload.password;
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
        oldPassword: oldSpendingPassword.value,
        password: spendingPassword.value
      });
      oldSpendingPassword.value = "";
      spendingPassword.value = "";
      onReset();
    }
    function onReset() {
      resetCounter.value = resetCounter.value + 1;
    }
    const submitEnabled = computed(() => {
      return !errors.spendingPassword && !errors.repeatPassword && (!errors.oldPassword || !props.requireOldPassword) && ((!props.requireOldPassword || submittable.oldPassword) && submittable.spendingPassword && submittable.repeatPassword);
    });
    return (_ctx, _cache) => {
      return openBlock(), createBlock(_sfc_main$4, {
        onDoFormReset: onReset,
        onDoFormSubmit: onSubmit,
        "form-id": "GridFormPasswordReset",
        "reset-button-label": unref(it)("common.label.reset"),
        "submit-button-label": unref(it)("common.label.save"),
        "submit-disabled": !submitEnabled.value || __props.saving,
        "reset-disabled": __props.saving
      }, {
        content: withCtx(() => [
          prvKey.value && __props.requireOldPassword ? (openBlock(), createBlock(_sfc_main$1, {
            key: 0,
            class: "col-span-12",
            onOnSubmittable: onSetOldPassword,
            encrypted: prvKey.value,
            version: prvKeyVersion.value,
            "reset-counter": resetCounter.value,
            "text-id": __props.textId + ".current"
          }, null, 8, ["encrypted", "version", "reset-counter", "text-id"])) : createCommentVNode("", true),
          createVNode(_sfc_main$2, {
            class: "col-span-12 lg:col-span-6",
            onOnSubmittable: onSetSpendingPassword,
            "reset-counter": resetCounter.value,
            "text-id": __props.textId + ".enter"
          }, null, 8, ["reset-counter", "text-id"]),
          createVNode(_sfc_main$3, {
            class: "col-span-12 lg:col-span-6",
            onOnSubmittable: onSetRepeatPassword,
            "compare-password": spendingPassword.value,
            "reset-counter": resetCounter.value,
            "text-id": __props.textId + ".repeat"
          }, null, 8, ["compare-password", "reset-counter", "text-id"]),
          createVNode(GridSpace, { dense: "" })
        ]),
        btnBack: withCtx(() => [
          renderSlot(_ctx.$slots, "btnBack")
        ]),
        _: 3
      }, 8, ["reset-button-label", "submit-button-label", "submit-disabled", "reset-disabled"]);
    };
  }
});
export {
  _sfc_main as _
};
