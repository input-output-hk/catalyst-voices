import { a_ as decryptText, d as defineComponent, z as ref, o as openBlock, c as createElementBlock, e as createBaseVNode, n as normalizeClass, b as withModifiers, D as watch, a as createBlock, h as withCtx, q as createVNode, u as unref } from "./index.js";
import { u as useTranslation } from "./useTranslation.js";
import { _ as _export_sfc } from "./_plugin-vue_export-helper.js";
import { G as GridInput } from "./GridInput.js";
var PasswordValidationResult = /* @__PURE__ */ ((PasswordValidationResult2) => {
  PasswordValidationResult2[PasswordValidationResult2["NO_ERROR"] = 0] = "NO_ERROR";
  PasswordValidationResult2[PasswordValidationResult2["ERROR"] = 1] = "ERROR";
  PasswordValidationResult2[PasswordValidationResult2["WEAK"] = 2] = "WEAK";
  PasswordValidationResult2[PasswordValidationResult2["MODERATE"] = 3] = "MODERATE";
  PasswordValidationResult2[PasswordValidationResult2["STRONG"] = 4] = "STRONG";
  return PasswordValidationResult2;
})(PasswordValidationResult || {});
const validatePassword = (val, external) => {
  const res = {
    result: 1,
    hasValidLength: val.length >= 12 || val === "asdf"
  };
  if (val.length === 0 && !external) {
    res.result = 0;
    return res;
  } else if (val.length < 4) {
    return res;
  } else {
    if (val.length >= 16) {
      res.result = 4;
    } else if (val.length >= 14) {
      res.result = 3;
    } else if (val.length >= 12 || val === "asdf") {
      res.result = 2;
    }
    return res;
  }
};
const checkPasswordCorrect = (password, encrypted, pwVersion) => {
  const content = decryptText(encrypted, password, pwVersion);
  return content !== null && content.length > 0;
};
const usePasswordValidation = () => {
  return {
    validatePassword,
    checkPasswordCorrect
  };
};
const _hoisted_1$1 = ["aria-label"];
const _sfc_main$2 = /* @__PURE__ */ defineComponent({
  __name: "VisibilityButton",
  props: {
    hint: { type: String, required: true }
  },
  emits: ["onVisibilityToggled"],
  setup(__props, { emit: __emit }) {
    const emit = __emit;
    const isVisible = ref(false);
    const toggleVisibility = () => {
      isVisible.value = !isVisible.value;
      emit("onVisibilityToggled", { visible: isVisible.value });
    };
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", {
        class: "pointer-events-auto z-50 w-5 text-lg cc-border-reset cc-text-highlight",
        "aria-label": (isVisible.value ? "hide " : "show ") + __props.hint,
        onClick: _cache[0] || (_cache[0] = withModifiers(($event) => toggleVisibility(), ["stop"]))
      }, [
        createBaseVNode("i", {
          class: normalizeClass(isVisible.value ? "mdi mdi-eye" : "mdi mdi-eye-off")
        }, null, 2)
      ], 8, _hoisted_1$1);
    };
  }
});
const _sfc_main$1 = {};
const _hoisted_1 = {
  xmlns: "http://www.w3.org/2000/svg",
  fill: "none",
  viewBox: "0 0 24 24",
  stroke: "currentColor"
};
function _sfc_render(_ctx, _cache) {
  return openBlock(), createElementBlock("svg", _hoisted_1, _cache[0] || (_cache[0] = [
    createBaseVNode("path", {
      "stroke-linecap": "round",
      "stroke-linejoin": "round",
      "stroke-width": "2",
      d: "M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"
    }, null, -1)
  ]));
}
const IconLockClosed = /* @__PURE__ */ _export_sfc(_sfc_main$1, [["render", _sfc_render]]);
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "GFEPassword",
  props: {
    textId: { type: String, default: "" },
    skipValidation: { type: Boolean, default: false },
    alwaysShowInfo: { type: Boolean, default: false },
    resetCounter: { type: Number, required: true, default: 0 },
    preFilledPassword: { type: String, required: false, default: "" },
    autofocus: { type: Boolean, required: false, default: false },
    autocomplete: { type: String, required: false, default: "new-password" },
    showInfo: { type: Boolean, required: false, default: true }
  },
  emits: ["onSubmittable", "enter"],
  setup(__props, { emit: __emit }) {
    const props = __props;
    const emit = __emit;
    const { it } = useTranslation();
    const { validatePassword: validatePassword2 } = usePasswordValidation();
    const inputType = ref("password");
    const password = ref(props.preFilledPassword);
    const passwordError = ref("");
    const passwordInfoAppend = ref("");
    const passwordCSS = ref("cc-input");
    function validatePasswordText(external) {
      if (props.skipValidation) {
        passwordError.value = "";
        emit("onSubmittable", {
          password: password.value,
          submittable: password.value !== null && password.value.length > 0,
          error: false
        });
        return passwordError.value;
      }
      const res = validatePassword2(password.value, external);
      passwordInfoAppend.value = "";
      switch (res.result) {
        case PasswordValidationResult.ERROR:
          let errorStr = "";
          if (!res.hasValidLength) {
            errorStr += (errorStr.length > 0 ? "\n" : "") + it(props.textId + ".error");
          }
          passwordError.value = errorStr;
          emit("onSubmittable", {
            password: password.value,
            submittable: false,
            error: true
          });
          return passwordError.value;
        case PasswordValidationResult.WEAK:
          passwordCSS.value = "cc-input-password-weak";
          passwordInfoAppend.value = it(props.textId + ".weak");
          break;
        case PasswordValidationResult.MODERATE:
          passwordCSS.value = "cc-input-password-ok";
          passwordInfoAppend.value = it(props.textId + ".moderate");
          break;
        case PasswordValidationResult.STRONG:
          passwordCSS.value = "cc-input-password-strong";
          passwordInfoAppend.value = it(props.textId + ".strong");
          break;
        case PasswordValidationResult.NO_ERROR:
          passwordCSS.value = "cc-input";
          break;
      }
      passwordError.value = "";
      emit("onSubmittable", {
        password: password.value,
        submittable: password.value !== null && password.value.length > 0,
        error: false
      });
      return passwordError.value;
    }
    watch(password, () => {
      validatePasswordText(false);
    });
    watch(() => props.resetCounter, () => {
      onResetPassword();
    });
    function onResetPassword() {
      password.value = "";
      passwordError.value = "";
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
        onEnter: _cache[2] || (_cache[2] = ($event) => _ctx.$emit("enter")),
        label: unref(it)(__props.textId + ".label"),
        "input-hint": unref(it)(__props.textId + ".hint"),
        "input-info": __props.showInfo ? unref(it)(__props.textId + ".info") : void 0,
        "input-info-append": passwordInfoAppend.value,
        autofocus: __props.autofocus,
        alwaysShowInfo: __props.alwaysShowInfo,
        inputCSS: passwordCSS.value,
        showReset: true,
        "input-id": "password",
        "input-type": inputType.value,
        autocomplete: __props.autocomplete
      }, {
        "icon-prepend": withCtx(() => [
          createVNode(IconLockClosed, { class: "w-5 h-5" })
        ]),
        "icon-append": withCtx(() => [
          createVNode(_sfc_main$2, {
            hint: unref(it)("common.label.password"),
            onOnVisibilityToggled: onVisibilityToggled
          }, null, 8, ["hint"])
        ]),
        _: 1
      }, 8, ["input-text", "input-error", "label", "input-hint", "input-info", "input-info-append", "autofocus", "alwaysShowInfo", "inputCSS", "input-type", "autocomplete"]);
    };
  }
});
export {
  IconLockClosed as I,
  _sfc_main as _,
  _sfc_main$2 as a,
  usePasswordValidation as u
};
