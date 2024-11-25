import { d as defineComponent, z as ref, D as watch, C as onMounted, o as openBlock, c as createElementBlock, q as createVNode, h as withCtx, u as unref, H as Fragment, S as reactive, f as computed, a as createBlock, e as createBaseVNode, aA as renderSlot, a7 as useQuasar, t as toDisplayString, K as networkId, ed as hasWallet } from "./index.js";
import { u as useWalletCreation } from "./useWalletCreation.js";
import { u as useTranslation } from "./useTranslation.js";
import { u as useNavigation } from "./useNavigation.js";
import { _ as _sfc_main$7 } from "./Page.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$5 } from "./GridSteps.vue_vue_type_script_setup_true_lang.js";
import { G as GridButtonSecondary } from "./GridButtonSecondary.js";
import { G as GridSpace } from "./GridSpace.js";
import { _ as _sfc_main$4 } from "./GridForm.vue_vue_type_script_setup_true_lang.js";
import { I as IconPencil } from "./IconPencil.js";
import { G as GridInput } from "./GridInput.js";
import { _ as _sfc_main$3 } from "./ScanQrCode.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$6 } from "./GridFormWalletName.vue_vue_type_script_setup_true_lang.js";
import "./NetworkId.js";
import "./useTabId.js";
import "./_plugin-vue_export-helper.js";
import "./IconCheck.js";
import "./GridButton.vue_vue_type_script_setup_true_lang.js";
import "./Tooltip.vue_vue_type_script_setup_true_lang.js";
import "./GridButtonPrimary.vue_vue_type_script_setup_true_lang.js";
import "./IconError.js";
import "./GridHeadline.vue_vue_type_script_setup_true_lang.js";
import "./Modal.js";
import "./QrcodeStream.js";
import "./scanner.js";
import "./GFEWalletName.vue_vue_type_script_setup_true_lang.js";
import "./GridInputAutocomplete.js";
const _sfc_main$2 = /* @__PURE__ */ defineComponent({
  __name: "GFEAccountKey",
  props: {
    label: { type: String, required: false, default: null },
    hint: { type: String, required: false, default: null },
    info: { type: String, required: false, default: null },
    error: { type: String, required: false, default: null },
    alwaysShowInfo: { type: Boolean, default: false },
    resetCounter: { type: Number, required: true, default: 0 },
    autocomplete: { type: String, default: "name" }
  },
  emits: ["onSubmittable"],
  setup(__props, { emit: __emit }) {
    const emit = __emit;
    const props = __props;
    const { t } = useTranslation();
    const accountKey = ref("");
    const accountKeyError = ref("");
    function validateAccountKey() {
      let isValid = false;
      if (accountKey.value) {
        const key = accountKey.value;
        if (key.startsWith("acct_xvk") && key.length === 118 || key.startsWith("xpub") && key.length === 114 || key.length === 128) {
          isValid = true;
        }
      }
      if (accountKey.value.length > 0 && !isValid) {
        accountKeyError.value = props.error || t("common.accountkey.name.error");
      } else {
        accountKeyError.value = "";
      }
      emit("onSubmittable", {
        accountKey: accountKey.value,
        submittable: accountKey.value.length > 0 && isValid
      });
      return accountKeyError.value;
    }
    let town = -1;
    watch(accountKey, () => {
      clearTimeout(town);
      town = setTimeout(() => validateAccountKey(), 500);
    });
    watch(() => props.resetCounter, () => {
      onResetAccountKey();
    });
    function onResetAccountKey() {
      accountKey.value = "";
      accountKeyError.value = "";
    }
    onMounted(() => {
      validateAccountKey();
    });
    function onQrCode(payload) {
      accountKey.value = payload.content;
    }
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock(Fragment, null, [
        createVNode(GridInput, {
          "input-text": accountKey.value,
          "onUpdate:inputText": _cache[0] || (_cache[0] = ($event) => accountKey.value = $event),
          "input-error": accountKeyError.value,
          "onUpdate:inputError": _cache[1] || (_cache[1] = ($event) => accountKeyError.value = $event),
          class: "col-span-12 md:col-span-11",
          onLostFocus: validateAccountKey,
          onEnter: validateAccountKey,
          onReset: onResetAccountKey,
          label: __props.label || unref(t)("common.accountkey.name.label"),
          "input-hint": __props.hint || unref(t)("common.accountkey.name.hint"),
          "input-info": __props.info || unref(t)("common.accountkey.name.info"),
          autocomplete: __props.autocomplete,
          alwaysShowInfo: __props.alwaysShowInfo,
          showReset: true,
          "input-id": "inputAccountKey",
          "input-type": "text"
        }, {
          "icon-prepend": withCtx(() => [
            createVNode(IconPencil, { class: "h-5 w-5" })
          ]),
          _: 1
        }, 8, ["input-text", "input-error", "label", "input-hint", "input-info", "autocomplete", "alwaysShowInfo"]),
        createVNode(_sfc_main$3, {
          onDecode: onQrCode,
          "button-css": "col-start-0 col-span-6 md:col-start-12 md:col-span-1 h-9 sm:h-11"
        })
      ], 64);
    };
  }
});
const _hoisted_1$1 = { class: "col-span-12 grid grid-cols-12 cc-gap items-end" };
const _sfc_main$1 = /* @__PURE__ */ defineComponent({
  __name: "GridFormAccountKey",
  props: {
    textId: { type: String, required: false, default: "" }
  },
  emits: ["submit"],
  setup(__props, { emit: __emit }) {
    const emit = __emit;
    const { it } = useTranslation();
    const resetCounter = ref(0);
    const submittable = reactive({
      accountKey: false
    });
    const errors = reactive({
      accountKey: false
    });
    const accountKey = ref("");
    function onSetAccountKey(payload) {
      submittable.accountKey = payload.submittable;
      errors.accountKey = payload.error;
      if (submittable.accountKey) {
        accountKey.value = payload.accountKey;
      }
    }
    async function onSubmit() {
      emit("submit", {
        accountKey: accountKey.value
      });
      onReset();
    }
    function onReset() {
      resetCounter.value = resetCounter.value + 1;
    }
    const submitEnabled = computed(() => !errors.accountKey && submittable.accountKey);
    return (_ctx, _cache) => {
      return openBlock(), createBlock(_sfc_main$4, {
        onDoFormReset: onReset,
        onDoFormSubmit: onSubmit,
        "form-id": "accountkey",
        "reset-button-label": unref(it)("common.label.reset"),
        "submit-button-label": unref(it)("common.label.save"),
        "submit-disabled": !submitEnabled.value
      }, {
        content: withCtx(() => [
          createBaseVNode("div", _hoisted_1$1, [
            createVNode(_sfc_main$2, {
              "always-show-info": "",
              onOnSubmittable: onSetAccountKey,
              "reset-counter": resetCounter.value,
              label: unref(it)("common.accountkey.headline"),
              hint: unref(it)("common.accountkey.hint"),
              info: unref(it)("common.accountkey.info"),
              error: unref(it)("common.accountkey.error")
            }, null, 8, ["reset-counter", "label", "hint", "info", "error"]),
            createVNode(GridSpace, {
              hr: "",
              class: "my-0.5 sm:my-2"
            })
          ])
        ]),
        btnBack: withCtx(() => [
          renderSlot(_ctx.$slots, "btnBack")
        ]),
        _: 3
      }, 8, ["reset-button-label", "submit-button-label", "submit-disabled"]);
    };
  }
});
const _hoisted_1 = { class: "min-h-16 sm:min-h-20 w-full max-w-full p-3 text-center flex flex-col flex-nowrap justify-center items-center border-t border-b mb-px cc-bg-white-0" };
const _hoisted_2 = { class: "cc-text-semi-bold" };
const _hoisted_3 = { class: "" };
const _hoisted_4 = { class: "cc-page-wallet cc-text-sz" };
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "ImportKey",
  setup(__props) {
    const {
      setWalletName,
      setAccountPubBech32List,
      generateWalletIdFromPubBech32,
      createWallet
    } = useWalletCreation();
    const {
      openWallet,
      gotoWalletList
    } = useNavigation();
    const { it } = useTranslation();
    const $q = useQuasar();
    const currentStep = ref(0);
    function resetInputs() {
      setWalletName("");
      setAccountPubBech32List([""]);
    }
    resetInputs();
    function goBack() {
      if (currentStep.value === 1) {
        currentStep.value = 0;
        resetInputs();
      }
    }
    async function gotoNextStepWalletName(payload) {
      if (payload.accountKey) {
        setWalletName(payload.accountKey);
        setAccountPubBech32List([payload.accountKey]);
      }
      try {
        const walletId = generateWalletIdFromPubBech32(networkId.value, "readonly");
        if (hasWallet(walletId)) {
          $q.notify({
            type: "warning",
            message: it("wallet.importkey.message.duplicate"),
            position: "top-left"
          });
          openWallet(walletId);
        } else {
          currentStep.value = 1;
        }
      } catch (err) {
      }
    }
    async function gotoNextStepWalletCreation(payload) {
      setWalletName(payload.walletName);
      try {
        const walletId = await createWallet(networkId.value, "readonly");
        $q.notify({
          type: "positive",
          message: it("wallet.importkey.message.success"),
          position: "top-left"
        });
        openWallet(walletId);
      } catch (err) {
        let errorMessage = it("wallet.create.message.faildb");
        $q.notify({
          type: "negative",
          message: errorMessage,
          position: "top-left",
          timeout: 8e3
        });
        gotoWalletList();
        console.error("CreateWallet: Error:", err.errorMessage);
      }
    }
    const optionsSteps = reactive([
      { id: "key", label: it("wallet.importkey.step.key") },
      { id: "name", label: it("wallet.importkey.step.name") }
    ]);
    return (_ctx, _cache) => {
      return openBlock(), createBlock(_sfc_main$7, {
        containerCSS: "",
        "align-top": ""
      }, {
        header: withCtx(() => [
          createBaseVNode("div", _hoisted_1, [
            createBaseVNode("span", _hoisted_2, toDisplayString(unref(it)("wallet.importkey.headline")), 1),
            createBaseVNode("span", _hoisted_3, toDisplayString(unref(it)("wallet.importkey.caption")), 1)
          ])
        ]),
        default: withCtx(() => [
          createBaseVNode("div", _hoisted_4, [
            createVNode(_sfc_main$5, {
              onBack: goBack,
              steps: optionsSteps,
              currentStep: currentStep.value,
              "small-c-s-s": "pr-20 xs:pr-20 lg:pr-24"
            }, {
              step0: withCtx(() => [
                createVNode(_sfc_main$1, {
                  class: "col-span-12",
                  onSubmit: gotoNextStepWalletName
                })
              ]),
              step1: withCtx(() => [
                createVNode(_sfc_main$6, {
                  class: "col-span-12",
                  "is-update": false,
                  onSubmit: gotoNextStepWalletCreation
                }, {
                  btnBack: withCtx(() => [
                    createVNode(GridButtonSecondary, {
                      class: "col-start-0 col-span-12 lg:col-start-0 lg:col-span-3",
                      label: unref(it)("common.label.back"),
                      link: goBack
                    }, null, 8, ["label"])
                  ]),
                  _: 1
                })
              ]),
              _: 1
            }, 8, ["steps", "currentStep"])
          ])
        ]),
        _: 1
      });
    };
  }
});
export {
  _sfc_main as default
};
