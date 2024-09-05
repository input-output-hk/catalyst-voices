import { u as useTranslation } from "./useTranslation.js";
import { I as IconLockClosed, a as _sfc_main$1 } from "./GFEPassword.vue_vue_type_script_setup_true_lang.js";
import { G as GridInput } from "./GridInput.js";
import { d as defineComponent, z as ref, D as watch, o as openBlock, a as createBlock, h as withCtx, q as createVNode, u as unref } from "./index.js";
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "GFERepeatPassword",
  props: {
    textId: { type: String, default: "" },
    comparePassword: { type: String, required: true, default: null },
    alwaysShowInfo: { type: Boolean, default: false },
    resetCounter: { type: Number, required: true, default: 0 }
  },
  emits: ["onSubmittable"],
  setup(__props, { emit: __emit }) {
    const props = __props;
    const emit = __emit;
    const { it } = useTranslation();
    const inputType = ref("password");
    const password = ref("");
    const passwordError = ref("");
    function validatePasswordText() {
      if (!password.value) {
        passwordError.value = "";
        emit("onSubmittable", { submittable: false, error: false });
      } else {
        if (props.comparePassword && props.comparePassword === password.value) {
          passwordError.value = "";
          emit("onSubmittable", { submittable: true, error: false });
        } else {
          passwordError.value = it(props.textId + ".error");
          emit("onSubmittable", { submittable: false, error: true });
        }
      }
      return passwordError.value;
    }
    watch(password, () => {
      validatePasswordText();
    });
    watch(() => props.resetCounter, () => {
      onResetPassword();
    });
    watch(() => props.comparePassword, () => {
      onResetPassword();
    });
    function onResetPassword() {
      password.value = "";
      passwordError.value = "";
      validatePasswordText();
    }
    function onVisibilityToggled(payload) {
      inputType.value = payload.visible ? "text" : "password";
    }
    return (_ctx, _cache) => {
      return openBlock(), createBlock(GridInput, {
        "input-text": password.value,
        "onUpdate:inputText": _cache[0] || (_cache[0] = ($event) => password.value = $event),
        "input-error": passwordError.value,
        "onUpdate:inputError": _cache[1] || (_cache[1] = ($event) => passwordError.value = $event),
        onLostFocus: validatePasswordText,
        onReset: onResetPassword,
        label: unref(it)(__props.textId + ".label"),
        "input-hint": unref(it)(__props.textId + ".hint"),
        "input-info": unref(it)(__props.textId + ".info"),
        showReset: true,
        "input-id": "repeatPassword",
        "input-type": inputType.value,
        autocomplete: "new-password"
      }, {
        "icon-prepend": withCtx(() => [
          createVNode(IconLockClosed, { class: "w-5 h-5" })
        ]),
        "icon-append": withCtx(() => [
          createVNode(_sfc_main$1, {
            hint: unref(it)("common.label.password"),
            onOnVisibilityToggled: onVisibilityToggled
          }, null, 8, ["hint"])
        ]),
        _: 1
      }, 8, ["input-text", "input-error", "label", "input-hint", "input-info", "input-type"]);
    };
  }
});
export {
  _sfc_main as _
};
