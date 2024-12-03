import { d as defineComponent, z as ref, D as watch, C as onMounted, o as openBlock, a as createBlock, h as withCtx, q as createVNode, u as unref, S as reactive, f as computed, n as normalizeClass, ag as walletGroupNameList, j as createCommentVNode, aA as renderSlot } from "./index.js";
import { u as useTranslation } from "./useTranslation.js";
import { G as GridSpace } from "./GridSpace.js";
import { _ as _sfc_main$3 } from "./GridForm.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$2 } from "./GFEWalletName.vue_vue_type_script_setup_true_lang.js";
import { I as IconPencil } from "./IconPencil.js";
import { G as GridInputAutocomplete } from "./GridInputAutocomplete.js";
const _sfc_main$1 = /* @__PURE__ */ defineComponent({
  __name: "GFEGroupName",
  props: {
    prefilledGroupName: { type: String, required: false, default: "" },
    prefilledSelection: { type: Array, required: false, default: [] },
    label: { type: String, required: false, default: null },
    hint: { type: String, required: false, default: null },
    info: { type: String, required: false, default: null },
    error: { type: String, required: false, default: null },
    inputCSS: { type: String, default: "cc-input" },
    alwaysShowInfo: { type: Boolean, default: false },
    resetCounter: { type: Number, required: true, default: 0 },
    autocomplete: { type: String, default: "name" },
    update: { type: Boolean, required: false, default: false }
  },
  emits: ["onSubmittable"],
  setup(__props, { emit: __emit }) {
    const emit = __emit;
    const props = __props;
    const { t } = useTranslation();
    const groupName = ref(props.prefilledGroupName ?? "");
    const groupNameError = ref("");
    function validateGroupName(external) {
      let groupNameInput = groupName.value.trim();
      const isValid = groupNameInput.length > 0 && groupNameInput.length < 41 || !external && groupNameInput.length === 0;
      if (!isValid) {
        groupNameError.value = props.error || t("common.wallet.group.error");
      } else {
        groupNameError.value = "";
      }
      emit("onSubmittable", {
        groupName: groupNameInput,
        submittable: groupNameInput.length > 0 && isValid
      });
      return groupNameError.value;
    }
    let town = -1;
    watch(groupName, () => {
      clearTimeout(town);
      town = setTimeout(() => validateGroupName(false), 350);
    });
    watch(() => props.prefilledGroupName, (name) => {
      groupName.value = name;
    });
    watch(() => props.resetCounter, () => {
      onResetGroupName();
    });
    function onResetGroupName() {
      groupName.value = props.prefilledGroupName;
      groupNameError.value = "";
      setTimeout(() => {
        groupName.value = props.prefilledGroupName;
      }, 10);
    }
    onMounted(() => {
      validateGroupName(false);
    });
    return (_ctx, _cache) => {
      return openBlock(), createBlock(GridInputAutocomplete, {
        "input-text": groupName.value,
        "onUpdate:inputText": _cache[0] || (_cache[0] = ($event) => groupName.value = $event),
        "input-error": groupNameError.value,
        "onUpdate:inputError": _cache[1] || (_cache[1] = ($event) => groupNameError.value = $event),
        onLostFocus: validateGroupName,
        onEnter: validateGroupName,
        onReset: onResetGroupName,
        label: __props.label || unref(t)("common.wallet.group.label"),
        "input-hint": __props.hint || unref(t)("common.wallet.group.hint"),
        "input-info": __props.info || unref(t)("common.wallet.group.info"),
        "input-c-s-s": __props.inputCSS,
        autocomplete: __props.autocomplete,
        alwaysShowInfo: __props.alwaysShowInfo,
        showReset: true,
        "input-id": "inputGroupName",
        "input-type": "text",
        "auto-complete-items": __props.prefilledSelection
      }, {
        "icon-prepend": withCtx(() => [
          createVNode(IconPencil, { class: "h-5 w-5" })
        ]),
        _: 1
      }, 8, ["input-text", "input-error", "label", "input-hint", "input-info", "input-c-s-s", "autocomplete", "alwaysShowInfo", "auto-complete-items"]);
    };
  }
});
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "GridFormWalletName",
  props: {
    prefilledWalletName: { type: String, required: false, default: "" },
    prefilledGroupName: { type: String, required: false, default: "" },
    isUpdate: { type: Boolean, required: false, default: false },
    saving: { type: Boolean, required: false, default: false },
    inputCSS: { type: String, default: "cc-input" }
  },
  emits: ["submit"],
  setup(__props, { emit: __emit }) {
    const props = __props;
    const emit = __emit;
    const { it } = useTranslation();
    const resetCounter = ref(0);
    const submittable = reactive({
      walletName: false,
      groupName: !props.isUpdate
    });
    const errors = reactive({
      walletName: false,
      groupName: false
    });
    const walletName = ref("");
    const groupName = ref("");
    const isSubmitting = ref(false);
    function onSetWalletName(payload) {
      isSubmitting.value = false;
      submittable.walletName = payload.submittable;
      errors.walletName = payload.error;
      if (submittable.walletName) {
        walletName.value = payload.walletName;
      }
    }
    function onSetGroupName(payload) {
      isSubmitting.value = false;
      submittable.groupName = payload.submittable;
      errors.groupName = payload.error;
      if (submittable.groupName) {
        groupName.value = payload.groupName;
      }
    }
    async function onSubmit() {
      isSubmitting.value = true;
      emit("submit", {
        walletName: walletName.value,
        groupName: groupName.value
      });
    }
    function onReset() {
      resetCounter.value = resetCounter.value + 1;
    }
    const submitEnabled = computed(
      () => !errors.walletName && !errors.groupName && (submittable.walletName && submittable.groupName) && (!props.isUpdate || !(walletName.value.trim() === props.prefilledWalletName && groupName.value.trim() === props.prefilledGroupName))
    );
    const isChanged = computed(() => walletName.value !== props.prefilledWalletName || groupName.value !== props.prefilledGroupName);
    return (_ctx, _cache) => {
      return openBlock(), createBlock(_sfc_main$3, {
        onDoFormReset: onReset,
        onDoFormSubmit: onSubmit,
        "form-id": "walletname",
        "reset-button-label": unref(it)("common.label.reset"),
        "submit-button-label": unref(it)("common.label.save"),
        "submit-disabled": !submitEnabled.value || __props.saving || isSubmitting.value,
        "reset-disabled": __props.saving || !isChanged.value || isSubmitting.value
      }, {
        content: withCtx(() => [
          createVNode(_sfc_main$2, {
            class: normalizeClass(["col-span-12", __props.isUpdate ? "lg:col-span-6" : ""]),
            onOnSubmittable: onSetWalletName,
            "prefilled-wallet-name": __props.prefilledWalletName,
            "reset-counter": resetCounter.value,
            update: __props.isUpdate,
            "input-c-s-s": __props.inputCSS
          }, null, 8, ["class", "prefilled-wallet-name", "reset-counter", "update", "input-c-s-s"]),
          __props.isUpdate ? (openBlock(), createBlock(_sfc_main$1, {
            key: 0,
            class: "col-span-12 lg:col-span-6",
            onOnSubmittable: onSetGroupName,
            "prefilled-group-name": __props.prefilledGroupName,
            "prefilled-selection": unref(walletGroupNameList),
            "reset-counter": resetCounter.value,
            update: __props.isUpdate,
            "input-c-s-s": __props.inputCSS,
            label: unref(it)("form.groupname.label"),
            hint: unref(it)("form.groupname.hint"),
            info: unref(it)("form.groupname.info"),
            error: unref(it)("form.groupname.error")
          }, null, 8, ["prefilled-group-name", "prefilled-selection", "reset-counter", "update", "input-c-s-s", "label", "hint", "info", "error"])) : createCommentVNode("", true),
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
