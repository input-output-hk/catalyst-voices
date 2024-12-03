import { d as defineComponent, z as ref, D as watch, C as onMounted, o as openBlock, a as createBlock, h as withCtx, q as createVNode, u as unref, hf as hasWalletName } from "./index.js";
import { u as useTranslation } from "./useTranslation.js";
import { I as IconPencil } from "./IconPencil.js";
import { G as GridInput } from "./GridInput.js";
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "GFEWalletName",
  props: {
    prefilledWalletName: { type: String, required: false, default: "" },
    inputCSS: { type: String, default: "cc-input" },
    alwaysShowInfo: { type: Boolean, default: false },
    autofocus: { type: Boolean, required: false, default: false },
    resetCounter: { type: Number, required: true, default: 0 },
    autocomplete: { type: String, default: "name" },
    update: { type: Boolean, required: false, default: false }
  },
  emits: ["onSubmittable"],
  setup(__props, { emit: __emit }) {
    const props = __props;
    const emit = __emit;
    const { it } = useTranslation();
    const walletName = ref(props.prefilledWalletName);
    const walletNameError = ref("");
    function validateWalletName(external) {
      let walletNameInput = walletName.value.trim();
      const isValid = walletNameInput.length >= 3 && walletNameInput.length < 41 || !external && walletNameInput.length === 0;
      const isDuplicate = walletNameInput !== props.prefilledWalletName && hasWalletName(walletNameInput);
      if (!isValid) {
        walletNameError.value = it("form.walletname.error");
      } else if (isDuplicate) {
        walletNameError.value = it("form.walletname.duplicate");
      } else {
        walletNameError.value = "";
      }
      emit("onSubmittable", {
        walletName: walletNameInput,
        submittable: walletNameInput.length > 0 && isValid && !isDuplicate
      });
      return walletNameError.value;
    }
    let town = -1;
    watch(walletName, () => {
      clearTimeout(town);
      town = setTimeout(() => validateWalletName(false), 350);
    });
    watch(() => props.prefilledWalletName, (name) => {
      walletName.value = name;
    });
    watch(() => props.resetCounter, () => {
      onResetWalletName();
    });
    function onResetWalletName() {
      walletName.value = props.prefilledWalletName;
      walletNameError.value = "";
      setTimeout(() => {
        walletName.value = props.prefilledWalletName;
      }, 10);
    }
    onMounted(() => {
      validateWalletName(false);
    });
    return (_ctx, _cache) => {
      return openBlock(), createBlock(GridInput, {
        "input-text": walletName.value,
        "onUpdate:inputText": _cache[0] || (_cache[0] = ($event) => walletName.value = $event),
        "input-error": walletNameError.value,
        "onUpdate:inputError": _cache[1] || (_cache[1] = ($event) => walletNameError.value = $event),
        onLostFocus: validateWalletName,
        onEnter: validateWalletName,
        onReset: onResetWalletName,
        label: unref(it)("form.walletname.label"),
        "input-hint": unref(it)("form.walletname.hint"),
        "input-info": unref(it)("form.walletname.info"),
        "input-c-s-s": __props.inputCSS,
        autofocus: __props.autofocus,
        autocomplete: __props.autocomplete,
        alwaysShowInfo: __props.alwaysShowInfo,
        showReset: true,
        "input-id": "inputWalletName",
        "input-type": "text"
      }, {
        "icon-prepend": withCtx(() => [
          createVNode(IconPencil, { class: "h-5 w-5" })
        ]),
        _: 1
      }, 8, ["input-text", "input-error", "label", "input-hint", "input-info", "input-c-s-s", "autofocus", "autocomplete", "alwaysShowInfo"]);
    };
  }
});
export {
  _sfc_main as _
};
