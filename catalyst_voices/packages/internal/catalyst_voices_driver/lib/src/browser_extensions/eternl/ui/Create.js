import { d as defineComponent, z as ref, o as openBlock, c as createElementBlock, q as createVNode, u as unref, aA as renderSlot, ea as getMnemonic, eb as wordlists, D as watch, a as createBlock, j as createCommentVNode, h as withCtx, e as createBaseVNode, H as Fragment, I as renderList, a7 as useQuasar, S as reactive, t as toDisplayString, K as networkId } from "./index.js";
import { u as useWalletCreation } from "./useWalletCreation.js";
import { u as useTranslation } from "./useTranslation.js";
import { u as useNavigation } from "./useNavigation.js";
import { _ as _sfc_main$d } from "./Page.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$a } from "./GridSteps.vue_vue_type_script_setup_true_lang.js";
import { G as GridButtonSecondary } from "./GridButtonSecondary.js";
import { _ as _sfc_main$b } from "./GridFormWalletNamePassword.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$c } from "./GridFormAccountSelection.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$4, a as _sfc_main$5 } from "./GridHeadline.vue_vue_type_script_setup_true_lang.js";
import { G as GridSpace } from "./GridSpace.js";
import { _ as _sfc_main$6 } from "./GridTextArea.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$7 } from "./GridToggle.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$8 } from "./GridButtonCountdown.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$9 } from "./GridFormMnemonicList.vue_vue_type_script_setup_true_lang.js";
import { I as IconPencil } from "./IconPencil.js";
import { G as GridInput } from "./GridInput.js";
import "./NetworkId.js";
import "./useTabId.js";
import "./_plugin-vue_export-helper.js";
import "./IconCheck.js";
import "./GridButton.vue_vue_type_script_setup_true_lang.js";
import "./Tooltip.vue_vue_type_script_setup_true_lang.js";
import "./GridForm.vue_vue_type_script_setup_true_lang.js";
import "./GridButtonPrimary.vue_vue_type_script_setup_true_lang.js";
import "./GFEWalletName.vue_vue_type_script_setup_true_lang.js";
import "./GFEPassword.vue_vue_type_script_setup_true_lang.js";
import "./GFERepeatPassword.vue_vue_type_script_setup_true_lang.js";
import "./IconError.js";
const _hoisted_1$3 = { class: "w-full grid grid-cols-12 cc-gap col-span-12 cc-text-sz" };
const _sfc_main$3 = /* @__PURE__ */ defineComponent({
  __name: "GridFormMnemonicHint",
  emits: ["submit"],
  setup(__props, { emit: __emit }) {
    const emit = __emit;
    const { it } = useTranslation();
    const toggled = ref(false);
    function onSubmit() {
      emit("submit");
    }
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", _hoisted_1$3, [
        createVNode(_sfc_main$4, {
          label: unref(it)("form.mnemonichint.label")
        }, null, 8, ["label"]),
        createVNode(_sfc_main$5, {
          text: unref(it)("form.mnemonichint.text"),
          class: "cc-text-sz"
        }, null, 8, ["text"]),
        createVNode(GridSpace, {
          hr: "",
          class: "my-0.5 sm:my-2"
        }),
        createVNode(_sfc_main$6, {
          label: void 0,
          text: unref(it)("form.mnemonichint.hint"),
          icon: unref(it)("form.mnemonichint.icon"),
          class: "col-span-12",
          "text-c-s-s": "cc-text-normal text-justify",
          css: "cc-rounded cc-banner-warning"
        }, null, 8, ["text", "icon"]),
        createVNode(GridSpace, {
          hr: "",
          class: "my-0.5 sm:my-2"
        }),
        createVNode(_sfc_main$7, {
          label: unref(it)("form.mnemonichint.toggle.acknowledged.label"),
          text: unref(it)("form.mnemonichint.toggle.acknowledged.text"),
          icon: unref(it)("form.mnemonichint.toggle.acknowledged.icon"),
          toggled: toggled.value,
          "onUpdate:toggled": _cache[0] || (_cache[0] = ($event) => toggled.value = $event),
          class: "col-span-12"
        }, null, 8, ["label", "text", "icon", "toggled"]),
        renderSlot(_ctx.$slots, "btnBack"),
        createVNode(_sfc_main$8, {
          label: unref(it)("common.label.continue"),
          link: onSubmit,
          disabled: !toggled.value,
          duration: 1,
          class: "col-start-7 col-span-6 lg:col-start-10 lg:col-span-3"
        }, null, 8, ["label", "disabled"])
      ]);
    };
  }
});
const _hoisted_1$2 = { class: "w-full grid grid-cols-12 cc-gap col-span-12 cc-text-sz" };
const _sfc_main$2 = /* @__PURE__ */ defineComponent({
  __name: "GridFormMnemonic",
  props: {
    mnemonic: { type: String, required: false, default: "" },
    textId: { type: String, default: "" }
  },
  emits: ["submit"],
  setup(__props, { emit: __emit }) {
    const emit = __emit;
    const props = __props;
    const { it } = useTranslation();
    const toggled = ref(false);
    const toggleError = ref(false);
    const tmp = props.mnemonic.length === 0 ? getMnemonic(256).split(" ") : props.mnemonic.split(" ");
    const mnemonic = ref(tmp);
    function onSubmit() {
      if (toggled.value) {
        emit("submit", { mnemonic: mnemonic.value.join(" ") });
      } else {
        toggleError.value = true;
      }
    }
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", _hoisted_1$2, [
        createVNode(_sfc_main$9, {
          label: unref(it)("form.mnemonic.label"),
          mnemonic: mnemonic.value,
          class: "col-span-12"
        }, null, 8, ["label", "mnemonic"]),
        createVNode(_sfc_main$6, {
          label: unref(it)("form.mnemonic.hint.label"),
          text: unref(it)("form.mnemonic.hint.text"),
          icon: unref(it)("form.mnemonic.hint.icon"),
          class: "col-span-12",
          "text-c-s-s": "cc-text-normal text-justify",
          css: "cc-rounded cc-banner-warning"
        }, null, 8, ["label", "text", "icon"]),
        createVNode(_sfc_main$7, {
          label: unref(it)("form.mnemonic.toggle.acknowledged.label"),
          text: unref(it)("form.mnemonic.toggle.acknowledged.text"),
          icon: unref(it)("form.mnemonic.toggle.acknowledged.icon"),
          toggled: toggled.value,
          toggleError: toggleError.value,
          "onUpdate:toggled": _cache[0] || (_cache[0] = ($event) => toggled.value = $event),
          "onUpdate:toggleError": _cache[1] || (_cache[1] = ($event) => toggleError.value = $event),
          class: "col-span-12"
        }, null, 8, ["label", "text", "icon", "toggled", "toggleError"]),
        renderSlot(_ctx.$slots, "btnBack"),
        createVNode(_sfc_main$8, {
          label: unref(it)("common.label.continue"),
          link: onSubmit,
          disabled: !toggled.value,
          class: "col-start-7 col-span-6 lg:col-start-10 lg:col-span-3"
        }, null, 8, ["label", "disabled"])
      ]);
    };
  }
});
const _hoisted_1$1 = { class: "w-full grid grid-cols-12 cc-gap cc-text-sz" };
const _hoisted_2$1 = { class: "w-full col-span-12 grid grid-cols-12 cc-gap" };
const _sfc_main$1 = /* @__PURE__ */ defineComponent({
  __name: "GridFormMnemonicInputConfirm",
  props: {
    mnemonic: { type: Array, required: true },
    textId: { type: String, default: "" }
  },
  emits: ["submit"],
  setup(__props, { emit: __emit }) {
    const emit = __emit;
    const props = __props;
    const { it } = useTranslation();
    const wordlist = wordlists.english.concat();
    const arr = [];
    for (let i = 0; i < props.mnemonic.length; i++) {
      arr.push("");
    }
    const inputCorrect = ref(false);
    const compareMnemonic = ref(arr);
    const info = it("form.mnemonicconfirm.input.info");
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
      let index = compareMnemonic.value.indexOf("");
      if (index < 0) {
        console.log("validateWordInput: Error: 1: index:", index);
        wordInputError.value = "";
      } else if (index >= props.mnemonic.length) {
        console.log("validateWordInput: Error: 2: index:", index, props.mnemonic.length);
        wordInputError.value = "";
      } else {
        const compareWord = props.mnemonic[index];
        if (filterOptions.value.length === 1 && filterOptions.value[0] === compareWord) {
          wordInput.value = compareWord;
        }
        if (wordInput.value === compareWord) {
          wordInputError.value = "";
          compareMnemonic.value[index] = wordInput.value;
          wordInput.value = "";
          if (compareMnemonic.value.join(",") === props.mnemonic.join(",")) {
            inputCorrect.value = true;
          }
        } else {
          wordInputError.value = it("form.mnemonicconfirm.input.error");
        }
      }
      return wordInputError.value;
    }
    const toggled = ref(false);
    const toggleError = ref(false);
    function onSubmit() {
      if (toggled.value) {
        emit("submit");
      } else {
        toggleError.value = true;
      }
    }
    function onClickedWord(word) {
      var _a;
      console.log(word);
      wordInput.value = word + " ";
      (_a = document.getElementById("wordInput")) == null ? void 0 : _a.focus();
    }
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", _hoisted_1$1, [
        !inputCorrect.value ? (openBlock(), createBlock(_sfc_main$6, {
          key: 0,
          label: unref(it)("form.mnemonicconfirm.instructions.label"),
          text: unref(it)("form.mnemonicconfirm.instructions.text"),
          icon: unref(it)("form.mnemonicconfirm.instructions.icon"),
          class: "col-span-12",
          css: "cc-area-highlight",
          "text-c-s-s": "cc-text-normal text-justify"
        }, null, 8, ["label", "text", "icon"])) : createCommentVNode("", true),
        createVNode(_sfc_main$9, {
          label: unref(it)("form.mnemonicconfirm.label"),
          mnemonic: compareMnemonic.value,
          "onUpdate:mnemonic": _cache[0] || (_cache[0] = ($event) => compareMnemonic.value = $event),
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
          label: unref(it)("form.mnemonicconfirm.input.label"),
          "input-hint": unref(it)("form.mnemonicconfirm.input.hint"),
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
        createBaseVNode("div", _hoisted_2$1, [
          wordInput.value.length > 1 ? (openBlock(true), createElementBlock(Fragment, { key: 0 }, renderList(filterOptions.value, (item) => {
            return openBlock(), createBlock(GridButtonSecondary, {
              key: item + "filter",
              label: item,
              capitalize: false,
              link: () => onClickedWord(item),
              class: "col-span-6 sm:col-span-4 lg:col-span-2 lowercase"
            }, null, 8, ["label", "link"]);
          }), 128)) : createCommentVNode("", true)
        ]),
        inputCorrect.value ? (openBlock(), createBlock(_sfc_main$6, {
          key: 2,
          label: unref(it)("form.mnemonicconfirm.input.correct.label"),
          text: unref(it)("form.mnemonicconfirm.input.correct.text"),
          icon: unref(it)("form.mnemonicconfirm.input.correct.icon"),
          class: "col-span-12",
          "text-c-s-s": "cc-text-normal text-justify",
          css: "cc-rounded cc-banner-warning"
        }, null, 8, ["label", "text", "icon"])) : createCommentVNode("", true),
        inputCorrect.value ? (openBlock(), createBlock(_sfc_main$7, {
          key: 3,
          label: unref(it)("form.mnemonicconfirm.toggle.label"),
          text: unref(it)("form.mnemonicconfirm.toggle.text"),
          icon: unref(it)("form.mnemonicconfirm.toggle.icon"),
          toggled: toggled.value,
          toggleError: toggleError.value,
          "onUpdate:toggled": _cache[3] || (_cache[3] = ($event) => toggled.value = $event),
          "onUpdate:toggleError": _cache[4] || (_cache[4] = ($event) => toggleError.value = $event),
          class: "col-span-12"
        }, null, 8, ["label", "text", "icon", "toggled", "toggleError"])) : createCommentVNode("", true),
        renderSlot(_ctx.$slots, "btnBack"),
        createVNode(_sfc_main$8, {
          label: unref(it)("common.label.continue"),
          link: onSubmit,
          disabled: !toggled.value,
          duration: 1,
          class: "col-start-7 col-span-6 lg:col-start-10 lg:col-span-3"
        }, null, 8, ["label", "disabled"])
      ]);
    };
  }
});
const _hoisted_1 = { class: "min-h-16 sm:min-h-20 w-full max-w-full p-3 text-center flex flex-col flex-nowrap justify-center items-center border-t border-b mb-px cc-bg-white-0" };
const _hoisted_2 = { class: "cc-text-semi-bold" };
const _hoisted_3 = { class: "" };
const _hoisted_4 = { class: "cc-page-wallet cc-text-sz" };
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "Create",
  setup(__props) {
    const { it } = useTranslation();
    const {
      setWalletName,
      setSpendingPassword,
      setMnemonic,
      resetWalletCreation,
      createWallet
    } = useWalletCreation();
    const {
      openWallet,
      gotoWalletList
    } = useNavigation();
    const $q = useQuasar();
    const currentStep = ref(0);
    const tmpMnemonic = ref("");
    const accountAmount = ref(1);
    function resetInputs() {
      resetWalletCreation();
    }
    resetInputs();
    function gotoNextStepAccountSelection(payload = null) {
      if (payload !== null) {
        setWalletName(payload.walletName);
        setSpendingPassword(payload.password);
      }
      currentStep.value = 1;
    }
    function gotoNextStepMnemonicHint(payload = null) {
      if (payload !== null) {
        accountAmount.value = payload.accountNumber;
      }
      currentStep.value = 2;
    }
    function gotoNextStepMnemonic() {
      currentStep.value = 3;
    }
    function gotoNextStepMnemonicCompare(payload) {
      setMnemonic(payload.mnemonic);
      tmpMnemonic.value = payload.mnemonic;
      currentStep.value = 4;
    }
    async function gotoNextStepWalletCreation() {
      try {
        const walletId = await createWallet(networkId.value, "mnemonic", accountAmount.value);
        if (walletId) {
          $q.notify({
            type: "positive",
            message: it("wallet.create.message.success"),
            position: "top-left"
          });
          openWallet(walletId);
        } else {
          throw "";
        }
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
    function goBackToWalletName() {
      currentStep.value = 0;
      resetInputs();
    }
    function goBackToMnemonic() {
      currentStep.value = 3;
    }
    function goBack() {
      if (currentStep.value === 1) {
        goBackToWalletName();
      }
      if (currentStep.value === 2) {
        gotoNextStepAccountSelection();
      }
      if (currentStep.value === 3) {
        gotoNextStepMnemonicHint();
      }
      if (currentStep.value === 4) {
        goBackToMnemonic();
      }
    }
    const optionsSteps = reactive([
      { id: "password", label: it("wallet.create.step.password") },
      { id: "account", label: it("wallet.create.step.account") },
      { id: "hint", label: it("wallet.create.step.hint") },
      { id: "phrase", label: it("wallet.create.step.recoveryphrase") },
      { id: "confirm", label: it("wallet.create.step.confirm") }
    ]);
    return (_ctx, _cache) => {
      return openBlock(), createBlock(_sfc_main$d, {
        containerCSS: "",
        "align-top": ""
      }, {
        header: withCtx(() => [
          createBaseVNode("div", _hoisted_1, [
            createBaseVNode("span", _hoisted_2, toDisplayString(unref(it)("wallet.create.headline")), 1),
            createBaseVNode("span", _hoisted_3, toDisplayString(unref(it)("wallet.create.caption")), 1)
          ])
        ]),
        default: withCtx(() => [
          createBaseVNode("div", _hoisted_4, [
            createVNode(_sfc_main$a, {
              onBack: goBack,
              steps: optionsSteps,
              currentStep: currentStep.value,
              "small-c-s-s": "pr-11 xs:pr-20 lg:pr-24"
            }, {
              step0: withCtx(() => [
                createVNode(_sfc_main$b, {
                  onSubmit: gotoNextStepAccountSelection,
                  class: "col-span-12"
                })
              ]),
              step1: withCtx(() => [
                createVNode(_sfc_main$c, {
                  "disable-discover": true,
                  onSubmit: gotoNextStepMnemonicHint,
                  class: "col-span-12",
                  "text-id": "wallet.restore.step.password"
                }, {
                  btnBack: withCtx(() => [
                    createVNode(GridButtonSecondary, {
                      label: "Back",
                      link: goBack,
                      class: "col-start-0 col-span-12 lg:col-start-0 lg:col-span-3"
                    })
                  ]),
                  _: 1
                })
              ]),
              step2: withCtx(() => [
                createVNode(_sfc_main$3, {
                  onSubmit: gotoNextStepMnemonic,
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
                })
              ]),
              step3: withCtx(() => [
                createVNode(_sfc_main$2, {
                  onSubmit: gotoNextStepMnemonicCompare,
                  mnemonic: tmpMnemonic.value,
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
                }, 8, ["mnemonic"])
              ]),
              step4: withCtx(() => [
                createVNode(_sfc_main$1, {
                  onSubmit: gotoNextStepWalletCreation,
                  mnemonic: tmpMnemonic.value.split(" "),
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
                }, 8, ["mnemonic"])
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
