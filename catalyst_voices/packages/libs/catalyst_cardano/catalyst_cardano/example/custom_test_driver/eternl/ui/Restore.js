import { d as defineComponent, a7 as useQuasar, eb as wordlists, z as ref, D as watch, o as openBlock, c as createElementBlock, a as createBlock, u as unref, j as createCommentVNode, q as createVNode, h as withCtx, H as Fragment, I as renderList, aA as renderSlot, ep as createPrvKeyRoot, S as reactive, e as createBaseVNode, t as toDisplayString, K as networkId } from "./index.js";
import { u as useWalletCreation } from "./useWalletCreation.js";
import { u as useTranslation } from "./useTranslation.js";
import { u as useNavigation } from "./useNavigation.js";
import { _ as _sfc_main$b } from "./Page.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$6, a as _sfc_main$7 } from "./GridHeadline.vue_vue_type_script_setup_true_lang.js";
import { G as GridSpace } from "./GridSpace.js";
import { _ as _sfc_main$5 } from "./GridSteps.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$8 } from "./GridRadioGroup.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$4 } from "./GridButtonPrimary.vue_vue_type_script_setup_true_lang.js";
import { G as GridButtonSecondary } from "./GridButtonSecondary.js";
import { _ as _sfc_main$9 } from "./GridFormWalletNamePassword.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$a } from "./GridFormAccountSelection.vue_vue_type_script_setup_true_lang.js";
import { I as IconPencil } from "./IconPencil.js";
import { G as GridInput } from "./GridInput.js";
import { _ as _sfc_main$2 } from "./GridTextArea.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$3 } from "./GridFormMnemonicList.vue_vue_type_script_setup_true_lang.js";
import "./NetworkId.js";
import "./useTabId.js";
import "./_plugin-vue_export-helper.js";
import "./IconCheck.js";
import "./GridButton.vue_vue_type_script_setup_true_lang.js";
import "./Tooltip.vue_vue_type_script_setup_true_lang.js";
import "./GridForm.vue_vue_type_script_setup_true_lang.js";
import "./GFEWalletName.vue_vue_type_script_setup_true_lang.js";
import "./GFEPassword.vue_vue_type_script_setup_true_lang.js";
import "./GFERepeatPassword.vue_vue_type_script_setup_true_lang.js";
import "./IconError.js";
const _hoisted_1$1 = { class: "w-full grid grid-cols-12 cc-gap cc-text-sz" };
const _hoisted_2$1 = {
  key: 2,
  class: "w-full col-span-12 grid grid-cols-12 cc-gap"
};
const _sfc_main$1 = /* @__PURE__ */ defineComponent({
  __name: "GridFormMnemonicInput",
  props: {
    mnemonicLength: { type: Number, required: true },
    mnemonic: { type: Array, required: false, default: () => [] },
    textId: { type: String, default: "" }
  },
  emits: ["submit"],
  setup(__props, { emit: __emit }) {
    const emit = __emit;
    const props = __props;
    const { it } = useTranslation();
    const $q = useQuasar();
    const wordlist = wordlists.english.concat();
    const arr = [];
    let i = 0;
    for (; i < props.mnemonic.length; i++) {
      if (i < props.mnemonic.length - 2) {
        arr.push(props.mnemonic[i]);
      } else {
        arr.push("");
      }
    }
    for (; i < props.mnemonicLength; i++) {
      arr.push("");
    }
    const inputCorrect = ref(false);
    const inputMnemonic = ref(arr);
    const info = it("form.mnemonicinput.input.info");
    const wordInput = ref("");
    const wordInputError = ref("");
    const wordInputInfo = ref(info);
    const filterOptions = ref([]);
    function onEnter() {
      wordInput.value = wordInput.value + " ";
    }
    watch(wordInput, (newValue, oldValue) => {
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
          if (filteredWords.length === props.mnemonicLength) {
            for (let i2 = 0; i2 < filteredWords.length; i2++) {
              inputMnemonic.value[i2] = filteredWords[i2];
            }
            validateWordInput();
            return;
          }
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
    function testMnemonic() {
      let index = inputMnemonic.value.indexOf("");
      if (index < 0) {
        try {
          createPrvKeyRoot(inputMnemonic.value.join(" "));
          wordInputError.value = "";
          inputCorrect.value = true;
        } catch (e) {
          inputCorrect.value = false;
          wordInputError.value = it("form.mnemonicinput.input.errorKey");
          $q.notify({
            type: "negative",
            message: it("form.mnemonicinput.input.errorKey"),
            position: "top-left"
          });
        }
      }
    }
    function validateWordInput() {
      let index = inputMnemonic.value.indexOf("");
      if (index < 0) {
        testMnemonic();
      } else if (index >= props.mnemonicLength) ;
      else {
        if (filterOptions.value.length === 1) {
          inputMnemonic.value[index] = filterOptions.value[0];
          wordInput.value = "";
          inputMnemonic.value.indexOf("");
          testMnemonic();
        } else {
          wordInputError.value = it("form.mnemonicinput.input.error");
        }
      }
      return wordInputError.value;
    }
    function onSubmit() {
      try {
        createPrvKeyRoot(inputMnemonic.value.join(" "));
        emit("submit", { mnemonic: inputMnemonic.value.join(" ") });
      } catch (e) {
        inputCorrect.value = false;
        wordInputError.value = it("form.mnemonicinput.input.error");
      }
    }
    function onClickedWord(word) {
      var _a;
      wordInput.value = word + " ";
      (_a = document.getElementById("wordInput")) == null ? void 0 : _a.focus();
    }
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", _hoisted_1$1, [
        !inputCorrect.value ? (openBlock(), createBlock(_sfc_main$2, {
          key: 0,
          label: unref(it)("form.mnemonicinput.instructions.label"),
          text: unref(it)("form.mnemonicinput.instructions.text"),
          icon: unref(it)("form.mnemonicinput.instructions.icon"),
          class: "col-span-12",
          css: "cc-area-highlight",
          "text-c-s-s": "cc-text-normal text-justify"
        }, null, 8, ["label", "text", "icon"])) : createCommentVNode("", true),
        createVNode(_sfc_main$3, {
          label: unref(it)("form.mnemonicinput.label"),
          mnemonic: inputMnemonic.value,
          "onUpdate:mnemonic": _cache[0] || (_cache[0] = ($event) => inputMnemonic.value = $event),
          editable: !inputCorrect.value,
          class: "col-span-12"
        }, null, 8, ["label", "mnemonic", "editable"]),
        !inputCorrect.value ? (openBlock(), createBlock(GridInput, {
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
          autocomplete: "name",
          class: "col-span-12"
        }, {
          "icon-prepend": withCtx(() => [
            createVNode(IconPencil, { class: "h-5 w-5" })
          ]),
          _: 1
        }, 8, ["input-text", "input-error", "label", "input-hint", "input-info"])) : createCommentVNode("", true),
        createVNode(GridSpace, { hr: "" }),
        !inputCorrect.value ? (openBlock(), createElementBlock("div", _hoisted_2$1, [
          wordInput.value.length > 1 ? (openBlock(true), createElementBlock(Fragment, { key: 0 }, renderList(filterOptions.value, (item) => {
            return openBlock(), createBlock(GridButtonSecondary, {
              key: item + "filter",
              label: item,
              capitalize: false,
              link: () => onClickedWord(item),
              class: "col-span-6 sm:col-span-4 lg:col-span-2 lowercase"
            }, null, 8, ["label", "link"]);
          }), 128)) : createCommentVNode("", true)
        ])) : createCommentVNode("", true),
        inputCorrect.value ? (openBlock(), createBlock(_sfc_main$2, {
          key: 3,
          label: unref(it)("form.mnemonicinput.input.correct.label"),
          text: unref(it)("form.mnemonicinput.input.correct.text"),
          icon: unref(it)("form.mnemonicinput.input.correct.icon"),
          class: "col-span-12",
          css: "cc-rounded cc-banner-warning ",
          "text-c-s-s": "text-justify"
        }, null, 8, ["label", "text", "icon"])) : createCommentVNode("", true),
        renderSlot(_ctx.$slots, "btnBack"),
        createVNode(_sfc_main$4, {
          label: unref(it)("common.label.continue"),
          link: onSubmit,
          disabled: !inputCorrect.value,
          class: "col-start-7 col-span-6 lg:col-start-10 lg:col-span-3"
        }, null, 8, ["label", "disabled"])
      ]);
    };
  }
});
const _hoisted_1 = { class: "min-h-16 sm:min-h-20 w-full max-w-full p-3 text-center flex flex-col flex-nowrap justify-center items-center border-t border-b mb-px cc-text-sz cc-bg-white-0" };
const _hoisted_2 = { class: "cc-text-semi-bold" };
const _hoisted_3 = { class: "" };
const _hoisted_4 = { class: "cc-page-wallet cc-text-sz" };
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "Restore",
  setup(__props) {
    const {
      hasWallet,
      setWalletName,
      setSpendingPassword,
      setMnemonic,
      resetWalletCreation,
      generateWalletIdFromMnemonic,
      createWallet
    } = useWalletCreation();
    const {
      gotoWalletList,
      openWallet
    } = useNavigation();
    const { it } = useTranslation();
    const $q = useQuasar();
    const currentStep = ref(0);
    const selectedOptionNumberOfWords = ref(null);
    const oldWalletName = ref("");
    const _mnemonic = ref("");
    function resetInputs() {
      selectedOptionNumberOfWords.value = null;
      resetWalletCreation();
    }
    resetInputs();
    function goBackToNumberOfWords() {
      currentStep.value = 0;
      resetInputs();
    }
    function goBackToRecoveryPhrase() {
      goBackToNumberOfWords();
    }
    function goBack() {
      if (currentStep.value === 1) {
        goBackToNumberOfWords();
      }
      if (currentStep.value === 2) {
        goBackToRecoveryPhrase();
      }
    }
    function gotoNextStepRecoveryPhrase() {
      if (selectedOptionNumberOfWords.value !== null) {
        currentStep.value = 1;
      }
    }
    function gotoNextStepAccountSelection(payload) {
      setWalletName(payload.walletName);
      setSpendingPassword(payload.password);
      oldWalletName.value = payload.walletName;
      currentStep.value = 3;
    }
    function gotoNextStepWalletName(payload) {
      if (payload.mnemonic) {
        setWalletName("");
        setSpendingPassword("");
        setMnemonic(payload.mnemonic);
        _mnemonic.value = payload.mnemonic;
        const walletId = generateWalletIdFromMnemonic(payload.mnemonic, networkId.value, "mnemonic");
        if (hasWallet(walletId)) {
          $q.notify({
            type: "warning",
            message: it("wallet.restore.message.duplicate"),
            position: "top-left"
          });
          openWallet(walletId);
        } else {
          currentStep.value = 2;
        }
      }
    }
    async function gotoNextStepWalletCreation(payload) {
      try {
        const walletId = await createWallet(networkId.value, "mnemonic", payload.accountNumber);
        $q.notify({
          type: "positive",
          message: it("wallet.restore.message.success"),
          position: "top-left"
        });
        openWallet(walletId ?? void 0);
      } catch (err) {
        let errorMessage = it("wallet.create.message.faildb");
        if (err.message && err.message.toLowerCase().includes("invalid mnemonic checksum")) {
          errorMessage = it("wallet.create.message.failmnemonic");
        }
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
    function onSelectedNumberOfWords(option) {
      selectedOptionNumberOfWords.value = option;
    }
    const optionsSteps = reactive([
      { id: "type", label: it("wallet.restore.step.type.label") },
      { id: "phrase", label: it("wallet.restore.step.recoveryphrase.label") },
      { id: "password", label: it("wallet.restore.step.password.label") },
      { id: "account", label: it("wallet.restore.step.account.label") }
    ]);
    const optionsNumberOfWords = reactive([
      { no: 24, id: "24words", label: it("wallet.restore.step.type.options.length24.label"), caption: it("wallet.restore.step.type.options.length24.caption") },
      { no: 15, id: "15words", label: it("wallet.restore.step.type.options.length15.label"), caption: it("wallet.restore.step.type.options.length15.caption") },
      { no: 12, id: "12words", label: it("wallet.restore.step.type.options.length12.label"), caption: it("wallet.restore.step.type.options.length12.caption") }
    ]);
    return (_ctx, _cache) => {
      return openBlock(), createBlock(_sfc_main$b, {
        containerCSS: "",
        "align-top": ""
      }, {
        header: withCtx(() => [
          createBaseVNode("div", _hoisted_1, [
            createBaseVNode("span", _hoisted_2, toDisplayString(unref(it)("wallet.restore.headline")), 1),
            createBaseVNode("span", _hoisted_3, toDisplayString(unref(it)("wallet.restore.caption")), 1)
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
              step0: withCtx(() => {
                var _a;
                return [
                  createVNode(_sfc_main$6, {
                    label: unref(it)("wallet.restore.step.type.headline"),
                    doCapitalize: false
                  }, null, 8, ["label"]),
                  createVNode(_sfc_main$7, {
                    text: unref(it)("wallet.restore.step.type.caption"),
                    class: "cc-text-sz"
                  }, null, 8, ["text"]),
                  createVNode(GridSpace, {
                    hr: "",
                    class: "my-0.5 sm:my-2"
                  }),
                  createVNode(_sfc_main$8, {
                    id: "number_of_words",
                    name: "number_of_words",
                    options: optionsNumberOfWords,
                    "default-id": (_a = selectedOptionNumberOfWords.value) == null ? void 0 : _a.id,
                    onSelected: onSelectedNumberOfWords
                  }, null, 8, ["options", "default-id"]),
                  createVNode(_sfc_main$4, {
                    class: "col-start-7 col-span-6 lg:col-start-10 lg:col-span-3",
                    label: unref(it)("common.label.next"),
                    link: gotoNextStepRecoveryPhrase,
                    disabled: selectedOptionNumberOfWords.value === null
                  }, null, 8, ["label", "disabled"])
                ];
              }),
              step1: withCtx(() => {
                var _a;
                return [
                  createVNode(_sfc_main$1, {
                    onSubmit: gotoNextStepWalletName,
                    "mnemonic-length": ((_a = selectedOptionNumberOfWords.value) == null ? void 0 : _a.no) ?? 0,
                    class: "col-span-12"
                  }, {
                    btnBack: withCtx(() => [
                      createVNode(GridButtonSecondary, {
                        label: unref(it)("common.label.back"),
                        link: goBackToNumberOfWords,
                        class: "col-start-0 col-span-6 lg:col-start-7 lg:col-span-3"
                      }, null, 8, ["label"])
                    ]),
                    _: 1
                  }, 8, ["mnemonic-length"])
                ];
              }),
              step2: withCtx(() => [
                createVNode(_sfc_main$9, {
                  onSubmit: gotoNextStepAccountSelection,
                  class: "col-span-12",
                  "prefilled-wallet-name": oldWalletName.value,
                  "text-id": "wallet.restore.step.password"
                }, {
                  btnBack: withCtx(() => [
                    createVNode(GridButtonSecondary, {
                      label: "Back",
                      link: goBackToNumberOfWords,
                      class: "col-start-0 col-span-12 lg:col-start-0 lg:col-span-3"
                    })
                  ]),
                  _: 1
                }, 8, ["prefilled-wallet-name"])
              ]),
              step3: withCtx(() => [
                createVNode(_sfc_main$a, {
                  onSubmit: gotoNextStepWalletCreation,
                  class: "col-span-12",
                  "text-id": "wallet.restore.step.password"
                }, {
                  btnBack: withCtx(() => [
                    createVNode(GridButtonSecondary, {
                      label: "Back",
                      link: goBackToNumberOfWords,
                      class: "col-start-0 col-span-12 lg:col-start-0 lg:col-span-3"
                    })
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
