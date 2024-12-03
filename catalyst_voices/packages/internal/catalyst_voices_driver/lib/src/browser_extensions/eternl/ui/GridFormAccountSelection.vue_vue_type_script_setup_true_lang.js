import { d as defineComponent, z as ref, f as computed, o as openBlock, a as createBlock, h as withCtx, e as createBaseVNode, t as toDisplayString, u as unref, er as MAX_ACCOUNTS, q as createVNode, aA as renderSlot } from "./index.js";
import { u as useTranslation } from "./useTranslation.js";
import { G as GridInput } from "./GridInput.js";
import { I as IconPencil } from "./IconPencil.js";
import { _ as _sfc_main$1 } from "./GridForm.vue_vue_type_script_setup_true_lang.js";
const _hoisted_1 = { class: "col-span-full grid grid-cols-12" };
const _hoisted_2 = { class: "col-span-12 grid grid-cols-12" };
const _hoisted_3 = { class: "col-span-full pt-2" };
const _hoisted_4 = { class: "col-span-12 p-2 grid grid-cols-12 cc-gap ring-2 ring-yellow-500 cc-rounded mb-4 mt-3" };
const _hoisted_5 = { class: "col-span-12 flex flex-row flex-nowrap whitespace-pre-wrap text-yellow-500 cc-text-bold" };
const _hoisted_6 = { class: "col-span-full" };
const _hoisted_7 = { class: "col-span-12" };
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "GridFormAccountSelection",
  props: {
    saving: { type: Boolean, required: false, default: false },
    inputCSS: { type: String, default: "cc-input" }
  },
  emits: ["submit"],
  setup(__props, { emit: __emit }) {
    const emit = __emit;
    const { it } = useTranslation();
    const numberOfAccounts = ref("1");
    const numberOfAccountsError = ref("");
    const validateNumberOfAccounts = () => {
      let number = Number(numberOfAccounts.value);
      if (!Number.isInteger(number)) {
        numberOfAccountsError.value = it("wallet.accountSelection.error.validNumber");
        return false;
      }
      if (number < 1) {
        numberOfAccountsError.value = it("wallet.accountSelection.error.minNumber");
        return false;
      }
      if (number > MAX_ACCOUNTS) {
        numberOfAccountsError.value = it("wallet.accountSelection.error.maxNumber").replace("####LIMIT####", String(MAX_ACCOUNTS));
        return false;
      }
      numberOfAccountsError.value = "";
      return true;
    };
    const onResetNumberOfAccounts = () => {
      numberOfAccounts.value = "1";
      numberOfAccountsError.value = "";
    };
    async function onSubmit() {
      emit("submit", {
        accountNumber: Number(numberOfAccounts.value)
      });
    }
    function onReset() {
      numberOfAccountsError.value = "";
      numberOfAccounts.value = "1";
    }
    const submitEnabled = computed(() => validateNumberOfAccounts());
    const isChanged = computed(() => numberOfAccounts.value !== "1");
    return (_ctx, _cache) => {
      return openBlock(), createBlock(_sfc_main$1, {
        onDoFormReset: onReset,
        onDoFormSubmit: onSubmit,
        "form-id": "accountSelection",
        "reset-button-label": unref(it)("common.label.reset"),
        "submit-button-label": unref(it)("common.label.save"),
        "submit-disabled": !submitEnabled.value || __props.saving,
        "reset-disabled": __props.saving || !isChanged.value
      }, {
        content: withCtx(() => [
          createBaseVNode("div", _hoisted_1, [
            createBaseVNode("div", _hoisted_2, [
              createBaseVNode("div", _hoisted_3, toDisplayString(unref(it)("wallet.create.account.description.line1").replace("####accountLimit####", unref(MAX_ACCOUNTS) + "")), 1),
              createBaseVNode("div", _hoisted_4, [
                createBaseVNode("div", _hoisted_5, toDisplayString(unref(it)("common.label.notice")), 1),
                createBaseVNode("div", _hoisted_6, toDisplayString(unref(it)("wallet.create.account.description.line2")), 1)
              ])
            ]),
            createBaseVNode("div", _hoisted_7, [
              createVNode(GridInput, {
                "input-text": numberOfAccounts.value,
                "onUpdate:inputText": _cache[0] || (_cache[0] = ($event) => numberOfAccounts.value = $event),
                "input-error": numberOfAccountsError.value,
                "onUpdate:inputError": _cache[1] || (_cache[1] = ($event) => numberOfAccountsError.value = $event),
                onLostFocus: validateNumberOfAccounts,
                onEnter: validateNumberOfAccounts,
                onReset: onResetNumberOfAccounts,
                label: unref(it)("wallet.create.account.amount"),
                "input-hint": unref(it)("wallet.create.account.hint"),
                "input-info": unref(it)("wallet.create.account.info"),
                "input-c-s-s": "",
                showReset: true,
                "input-id": "inputNumberOfAccounts",
                "input-type": "text",
                autocomplete: "name"
              }, {
                "icon-prepend": withCtx(() => [
                  createVNode(IconPencil, { class: "h-5 w-5" })
                ]),
                _: 1
              }, 8, ["input-text", "input-error", "label", "input-hint", "input-info"])
            ])
          ])
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
