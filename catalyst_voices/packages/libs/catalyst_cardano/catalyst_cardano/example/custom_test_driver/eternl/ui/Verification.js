import { d as defineComponent, eb as wordlists, z as ref, f as computed, D as watch, o as openBlock, c as createElementBlock, q as createVNode, u as unref, a as createBlock, j as createCommentVNode, h as withCtx, H as Fragment, I as renderList, aA as renderSlot, a7 as useQuasar, e as createBaseVNode, t as toDisplayString, ae as useSelectedAccount, K as networkId } from "./index.js";
import { u as useWalletCreation } from "./useWalletCreation.js";
import { u as useTranslation } from "./useTranslation.js";
import { u as useNavigation } from "./useNavigation.js";
import { _ as _sfc_main$6 } from "./GridSteps.vue_vue_type_script_setup_true_lang.js";
import { G as GridButtonSecondary } from "./GridButtonSecondary.js";
import { _ as _sfc_main$2 } from "./GridTextArea.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$5 } from "./GridFormPasswordReset.vue_vue_type_script_setup_true_lang.js";
import { I as IconPencil } from "./IconPencil.js";
import { _ as _sfc_main$4 } from "./GridButtonPrimary.vue_vue_type_script_setup_true_lang.js";
import { G as GridSpace } from "./GridSpace.js";
import { G as GridInput } from "./GridInput.js";
import { _ as _sfc_main$3 } from "./GridFormMnemonicList.vue_vue_type_script_setup_true_lang.js";
import "./NetworkId.js";
import "./useTabId.js";
import "./IconCheck.js";
import "./_plugin-vue_export-helper.js";
import "./GridButton.vue_vue_type_script_setup_true_lang.js";
import "./Tooltip.vue_vue_type_script_setup_true_lang.js";
import "./GridHeadline.vue_vue_type_script_setup_true_lang.js";
import "./GridForm.vue_vue_type_script_setup_true_lang.js";
import "./GFEPassword.vue_vue_type_script_setup_true_lang.js";
import "./GFERepeatPassword.vue_vue_type_script_setup_true_lang.js";
import "./IconError.js";
const _hoisted_1$1 = { class: "w-full grid grid-cols-12 cc-gap" };
const _hoisted_2$1 = {
  key: 2,
  class: "w-full col-span-12 grid grid-cols-12 cc-gap"
};
const _sfc_main$1 = /* @__PURE__ */ defineComponent({
  __name: "GridFormMnemonicVerify",
  props: {
    mnemonic: { type: Array, required: false, default: () => [] },
    textId: { type: String, default: "" }
  },
  emits: ["submit", "inputChange"],
  setup(__props, { emit: __emit }) {
    const emit = __emit;
    const { it } = useTranslation();
    const wordlist = wordlists.english.concat();
    const inputMnemonic = ref([]);
    const info = it("form.mnemonicinput.input.info");
    const wordInput = ref("");
    const wordInputError = ref("");
    const wordInputInfo = ref(info);
    const filterOptions = ref([]);
    const disableSubmit = computed(() => {
      return inputMnemonic.value.length !== 24 && inputMnemonic.value.length !== 15 && inputMnemonic.value.length !== 12;
    });
    function onEnter() {
      wordInput.value = wordInput.value + " ";
    }
    const showWordLimitError = () => {
      wordInputError.value = it("wallet.settings.verification.wordLimit");
    };
    watch(wordInput, (newValue, oldValue) => {
      if (inputMnemonic.value.length > 24) {
        showWordLimitError();
        return;
      }
      emit("inputChange");
      if (newValue.length === 0) {
        wordInputInfo.value = info;
        wordInputError.value = "";
      } else {
        const input = newValue.toLowerCase();
        const needle = input.trim();
        if (needle.includes(" ")) {
          const words = needle.split(" ");
          const filteredWords = [];
          for (const word of words) {
            if (word && word.length > 0) {
              const filtered = wordlist.filter((v) => v.toLowerCase().startsWith(word));
              if (filtered.some((e) => e === word)) {
                filteredWords.push(word);
              } else {
                filteredWords.length = 0;
              }
            }
          }
          wordInput.value = "";
          for (let i = 0; i < filteredWords.length; i++) {
            if (filteredWords[i] && filteredWords[i].length && inputMnemonic.value.length < 24) {
              inputMnemonic.value[inputMnemonic.value.length] = filteredWords[i];
            }
          }
          validateWordInput();
          return;
        }
        filterOptions.value = wordlist.filter((v) => v.toLowerCase().startsWith(needle));
        if (input.length > needle.length && filterOptions.value.some((e) => e === needle)) {
          filterOptions.value = [needle];
        }
        let info2 = filterOptions.value.join(", ");
        if (info2.length > 64) {
          info2 = info2.substr(0, 64) + " ...";
        }
        wordInputInfo.value = info2;
        if (input.endsWith(" ")) {
          validateWordInput();
        }
      }
    });
    function validateWordInput() {
      let index = inputMnemonic.value.length;
      if (filterOptions.value.length === 0) {
        wordInputError.value = it("form.mnemonicinput.input.error");
      } else {
        if (filterOptions.value[0]) {
          if (inputMnemonic.value.length < 24) {
            inputMnemonic.value.push("");
            inputMnemonic.value[index] = filterOptions.value[0];
            wordInput.value = "";
          }
        }
      }
      return wordInputError.value;
    }
    function onSubmit() {
      try {
        emit("submit", { mnemonic: inputMnemonic.value.filter((element) => element.length > 0).join(" ") });
      } catch (e) {
        wordInputError.value = it("form.mnemonicinput.input.error");
      }
    }
    function onClickedWord(word) {
      var _a;
      if (inputMnemonic.value.length === 24) {
        showWordLimitError();
        return;
      }
      wordInput.value = word + " ";
      (_a = document.getElementById("wordInput")) == null ? void 0 : _a.focus();
    }
    const removeWord = (payload) => {
      emit("inputChange");
      inputMnemonic.value.splice(payload.index, 1);
      wordInputError.value = "";
    };
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", _hoisted_1$1, [
        createVNode(_sfc_main$2, {
          label: unref(it)("form.mnemonicinput.instructions.label"),
          text: unref(it)("form.mnemonicinput.instructions.text"),
          icon: unref(it)("form.mnemonicinput.instructions.icon"),
          class: "col-span-12",
          css: "cc-area-highlight",
          "text-c-s-s": "cc-text-normal text-justify"
        }, null, 8, ["label", "text", "icon"]),
        inputMnemonic.value.length ? (openBlock(), createBlock(_sfc_main$3, {
          key: 0,
          label: unref(it)("form.mnemonicinput.label"),
          mnemonic: inputMnemonic.value,
          "onUpdate:mnemonic": _cache[0] || (_cache[0] = ($event) => inputMnemonic.value = $event),
          editable: true,
          onRemoveWord: removeWord,
          class: "col-span-12"
        }, null, 8, ["label", "mnemonic"])) : createCommentVNode("", true),
        inputMnemonic.value.length < 24 ? (openBlock(), createBlock(GridInput, {
          key: 1,
          "input-text": wordInput.value,
          "onUpdate:inputText": _cache[1] || (_cache[1] = ($event) => wordInput.value = $event),
          "input-error": wordInputError.value,
          "onUpdate:inputError": _cache[2] || (_cache[2] = ($event) => wordInputError.value = $event),
          onEnter,
          label: unref(it)("form.mnemonicinput.input.label"),
          "input-hint": unref(it)("form.mnemonicinput.input.hint"),
          "input-info": wordInputInfo.value,
          alwaysShowInfo: true,
          "input-id": "wordInput",
          "input-type": "text",
          autofocus: "",
          class: "col-span-12"
        }, {
          "icon-prepend": withCtx(() => [
            createVNode(IconPencil, { class: "h-5 w-5" })
          ]),
          _: 1
        }, 8, ["input-text", "input-error", "label", "input-hint", "input-info"])) : createCommentVNode("", true),
        createVNode(GridSpace, { hr: "" }),
        (openBlock(), createElementBlock("div", _hoisted_2$1, [
          wordInput.value.length > 1 ? (openBlock(true), createElementBlock(Fragment, { key: 0 }, renderList(filterOptions.value, (item) => {
            return openBlock(), createBlock(GridButtonSecondary, {
              key: item + "filter",
              label: item,
              capitalize: false,
              link: () => onClickedWord(item),
              class: "col-span-6 sm:col-span-4 lg:col-span-2 lowercase"
            }, null, 8, ["label", "link"]);
          }), 128)) : createCommentVNode("", true)
        ])),
        renderSlot(_ctx.$slots, "btnBack"),
        createVNode(_sfc_main$4, {
          label: unref(it)("wallet.settings.verification.start"),
          disabled: disableSubmit.value,
          link: onSubmit,
          class: "col-start-7 col-span-6 lg:col-start-10 lg:col-span-3"
        }, null, 8, ["label", "disabled"])
      ]);
    };
  }
});
const _hoisted_1 = { class: "cc-page-wallet cc-text-sz" };
const _hoisted_2 = { class: "cc-grid" };
const _hoisted_3 = { class: "cc-grid" };
const _hoisted_4 = { class: "col-span-12 grid grid-cols-12 cc-gap" };
const _hoisted_5 = { class: "cc-grid" };
const _hoisted_6 = { class: "col-span-12" };
const _hoisted_7 = { class: "cc-text-semi-bold" };
const _hoisted_8 = { class: "cc-grid" };
const _hoisted_9 = { class: "col-span-12 grid grid-cols-12" };
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "Verification",
  setup(__props) {
    const {
      selectedWalletId,
      appWallet,
      walletData,
      walletSettings
    } = useSelectedAccount();
    const updateRootKey = walletSettings.updateRootKey;
    const { it } = useTranslation();
    const {
      openWalletPage,
      gotoPage
    } = useNavigation();
    const optionsSteps = computed(() => {
      return [
        { id: "phrase", label: it("wallet.settings.verification.spendingRecovery.step0") },
        { id: "password", label: it("wallet.settings.verification.spendingRecovery.step1") }
      ];
    });
    const currentStep = ref(0);
    const mnemonic = ref();
    const showIsValid = ref(false);
    const showIsInvalid = ref(false);
    const saving = ref(false);
    const {
      setMnemonic,
      resetWalletCreation,
      generateWalletIdFromMnemonic
    } = useWalletCreation();
    const resetValidity = () => {
      showIsValid.value = false;
      showIsInvalid.value = false;
    };
    const $q = useQuasar();
    resetWalletCreation();
    const gotoLastStep = () => {
      currentStep.value = currentStep.value > 0 ? currentStep.value - 1 : 0;
    };
    const goToPasswordRestore = () => {
      currentStep.value = 1;
    };
    const goBack = () => {
      openWalletPage("Summary");
    };
    const verifyMnemonic = (payload) => {
      resetValidity();
      if (payload.mnemonic) {
        setMnemonic(payload.mnemonic ?? "");
        mnemonic.value = payload.mnemonic;
        try {
          const walletId = generateWalletIdFromMnemonic(mnemonic.value, networkId.value, "mnemonic");
          if (selectedWalletId.value === walletId) {
            showIsValid.value = true;
          } else {
            showIsInvalid.value = true;
          }
        } catch (error) {
          showIsInvalid.value = true;
        }
      }
    };
    const onSubmitPasswordReset = async (payload) => {
      if (selectedWalletId.value && mnemonic.value) {
        saving.value = true;
        const success = await updateRootKey(mnemonic.value, payload.password);
        saving.value = false;
        if (success) {
          $q.notify({
            type: "positive",
            position: "top-left",
            message: it("wallet.settings.message.success")
          });
        } else {
          $q.notify({
            type: "negative",
            position: "top-left",
            message: it("wallet.settings.message.failed")
          });
        }
      }
    };
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", _hoisted_1, [
        createBaseVNode("div", _hoisted_2, [
          createVNode(_sfc_main$6, {
            onBack: goBack,
            steps: optionsSteps.value,
            currentStep: currentStep.value,
            "small-c-s-s": "pr-20 xs:pr-20 lg:pr-24"
          }, {
            step0: withCtx(() => [
              createBaseVNode("div", _hoisted_3, [
                createVNode(_sfc_main$1, {
                  onSubmit: verifyMnemonic,
                  onInputChange: resetValidity,
                  class: "col-span-12"
                }, {
                  btnBack: withCtx(() => [
                    createVNode(GridButtonSecondary, {
                      label: unref(it)("common.label.back"),
                      link: goBack,
                      class: "col-start-0 col-span-6 lg:col-start-7 lg:col-span-3"
                    }, null, 8, ["label"])
                  ]),
                  _: 1
                }),
                showIsValid.value ? (openBlock(), createBlock(_sfc_main$2, {
                  key: 0,
                  text: unref(it)("wallet.settings.verification.match.label"),
                  icon: unref(it)("wallet.settings.verification.match.icon"),
                  class: "col-span-12 mt-2 sm:mt-4",
                  "text-c-s-s": "cc-text-normal text-justify flex justify-start items-center",
                  css: "cc-rounded cc-banner-green"
                }, null, 8, ["text", "icon"])) : createCommentVNode("", true),
                showIsInvalid.value ? (openBlock(), createBlock(_sfc_main$2, {
                  key: 1,
                  text: unref(it)("wallet.settings.verification.invalid.label"),
                  icon: unref(it)("wallet.settings.verification.invalid.icon"),
                  class: "col-span-12 mt-2 sm:mt-4",
                  "text-c-s-s": "cc-text-normal text-justify flex justify-start items-center",
                  css: "cc-rounded cc-banner-warning"
                }, null, 8, ["text", "icon"])) : createCommentVNode("", true),
                createBaseVNode("div", _hoisted_4, [
                  showIsValid.value ? (openBlock(), createBlock(GridButtonSecondary, {
                    key: 0,
                    label: unref(it)("wallet.settings.verification.match.spending"),
                    link: goToPasswordRestore,
                    class: "col-start-7 col-span-6 lg:col-start-10 lg:col-span-3"
                  }, null, 8, ["label"])) : createCommentVNode("", true)
                ])
              ])
            ]),
            step1: withCtx(() => [
              createBaseVNode("div", _hoisted_5, [
                createBaseVNode("div", _hoisted_6, [
                  createBaseVNode("span", _hoisted_7, toDisplayString(unref(it)("wallet.settings.verification.spendingRecovery.label")), 1),
                  createVNode(_sfc_main$2, {
                    text: unref(it)("wallet.settings.verification.spendingRecovery.caption"),
                    icon: unref(it)("wallet.settings.verification.spendingRecovery.icon"),
                    class: "col-span-12 mt-2 sm:mt-4",
                    "text-c-s-s": "cc-text-normal text-justify flex justify-start items-center",
                    css: "cc-rounded cc-banner-blue"
                  }, null, 8, ["text", "icon"])
                ]),
                createBaseVNode("div", _hoisted_8, [
                  unref(appWallet) && unref(appWallet).isMnemonic ? (openBlock(), createBlock(_sfc_main$5, {
                    key: 0,
                    "text-id": "form.password.spending",
                    class: "col-span-12",
                    saving: saving.value,
                    "require-old-password": false,
                    onSubmit: onSubmitPasswordReset
                  }, null, 8, ["saving"])) : createCommentVNode("", true)
                ]),
                createBaseVNode("div", _hoisted_9, [
                  createVNode(GridButtonSecondary, {
                    label: unref(it)("common.label.back"),
                    link: gotoLastStep,
                    class: "ml-1.5 col-start-7 col-span-6 lg:col-start-10 lg:col-span-3"
                  }, null, 8, ["label"])
                ])
              ])
            ]),
            _: 1
          }, 8, ["steps", "currentStep"])
        ])
      ]);
    };
  }
});
export {
  _sfc_main as default
};
