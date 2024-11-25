import { d as defineComponent, ez as useSlots, z as ref, D as watch, f as computed, C as onMounted, V as nextTick, o as openBlock, c as createElementBlock, e as createBaseVNode, n as normalizeClass, b as withModifiers, i as createTextVNode, t as toDisplayString, j as createCommentVNode, aA as renderSlot, ab as withKeys, q as createVNode } from "./index.js";
import { I as IconError, a as IconX } from "./IconError.js";
import { _ as _export_sfc } from "./_plugin-vue_export-helper.js";
const _hoisted_1 = { class: "w-full grid grid-cols-12 content-start cc-gap" };
const _hoisted_2 = {
  key: 0,
  class: "col-span-12 flex flex-col flex-nowrap space-y-2 justify-between items-start"
};
const _hoisted_3 = { class: "w-full flex flex-row flex-nowrap justify-between items-start" };
const _hoisted_4 = ["for", "id"];
const _hoisted_5 = {
  key: 0,
  class: "mdi mdi-information-outline cursor-pointer pointer-events-auto"
};
const _hoisted_6 = {
  key: 0,
  class: "flex flex-row flex-nowrap justify-start items-center"
};
const _hoisted_7 = ["id"];
const _hoisted_8 = ["value", "disabled", "name", "id", "rows", "autocomplete", "placeholder", "aria-invalid", "aria-describedby"];
const _hoisted_9 = ["value", "disabled", "name", "id", "autocomplete", "type", "pattern", "min", "max", "placeholder", "aria-invalid", "aria-describedby", "data-lpignore"];
const _hoisted_10 = ["id"];
const _hoisted_11 = ["id"];
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "GridInput",
  props: {
    inputText: { type: String, default: "", required: true },
    inputError: { type: String, default: "" },
    multilineInput: { type: Boolean, default: false },
    rows: { type: Number, default: 2 },
    label: { type: String, default: "" },
    capitalizeLabel: { type: Boolean, default: true },
    inputId: { type: String, default: "text" },
    inputType: { type: String, default: "text" },
    inputPattern: { type: String, default: null },
    inputInfo: { type: String, default: null },
    inputInfoAppend: { type: String, default: null },
    inputHint: { type: String, default: null },
    inputCSS: { type: String, default: "cc-input" },
    inputTextCSS: { type: String, default: "" },
    inputDisabled: { type: Boolean, default: false },
    autocomplete: { type: String, default: "off" },
    autofocus: { type: Boolean, default: false },
    autoIncreaseRows: { type: Boolean, default: false },
    alwaysShowInfo: { type: Boolean, default: false },
    showReset: { type: Boolean, default: false },
    currency: { type: Boolean, default: false },
    decimalSeparator: { type: String, default: "" },
    groupSeparator: { type: String, default: "" },
    manualUpdate: { type: Number, default: 0 },
    manualUpdateAutoSelect: { type: Boolean, default: true },
    preventEnter: { type: Boolean, required: false, default: false },
    minValue: { type: Number, required: false, default: void 0 },
    maxValue: { type: Number, required: false, default: void 0 }
  },
  emits: [
    "update:inputText",
    "update:inputError",
    "lostFocus",
    "enter",
    "reset",
    "esc"
  ],
  setup(__props, { expose: __expose, emit: __emit }) {
    const props = __props;
    const emit = __emit;
    const slots = useSlots();
    const hasFocus = ref(false);
    const showInfo = ref(props.alwaysShowInfo);
    const inputField = ref(null);
    const textAreaField = ref(null);
    const showInputError = ref(false);
    let toid = -1;
    watch(() => props.inputError, (value) => {
      clearTimeout(toid);
      if (value.length === 0) {
        showInputError.value = false;
      }
      toid = setTimeout(() => showInputError.value = props.inputError.length > 0, 500);
    });
    const hasSlotPrepend = computed(() => typeof slots["icon-prepend"] !== "undefined");
    const hasSlotAppend = computed(() => typeof slots["icon-append"] !== "undefined");
    const hasSlotLabelRight = computed(() => typeof slots["label-right"] !== "undefined");
    const internalInputText = ref("" + props.inputText);
    const _rows = computed(() => {
      if (props.autoIncreaseRows) {
        const numLines = internalInputText.value.split(/\r\n|\r|\n/).length;
        if (numLines > props.rows) {
          return numLines;
        }
      }
      return props.rows;
    });
    let cursorPosition = 0;
    let valueLength = 0;
    onMounted(() => {
      if (props.autofocus) {
        nextTick(() => {
          var _a, _b;
          props.multilineInput ? (_a = textAreaField.value) == null ? void 0 : _a.focus() : (_b = inputField.value) == null ? void 0 : _b.focus();
        });
      }
    });
    function onInput(event) {
      var _a;
      let value = event.target.value;
      cursorPosition = event.target.selectionStart;
      const oldValue = internalInputText.value;
      const decimalOldValue = ((_a = oldValue == null ? void 0 : oldValue.replace) == null ? void 0 : _a.call(oldValue, new RegExp(props.decimalSeparator, "gi"), "")) ?? "";
      if (props.decimalSeparator && value === decimalOldValue) {
        valueLength = oldValue.length;
        emit("update:inputText", oldValue, oldValue);
        return;
      }
      const groupOldValue = (oldValue == null ? void 0 : oldValue.replace(new RegExp(props.groupSeparator, "gi"), "")) ?? "";
      if (props.groupSeparator && value === groupOldValue) {
        valueLength = oldValue.length;
        emit("update:inputText", oldValue, oldValue);
        return;
      }
      valueLength = value.length;
      emit("update:inputText", value, oldValue);
    }
    watch(() => props.manualUpdate, () => {
      if ((hasFocus.value || props.manualUpdateAutoSelect) && props.inputType === "text") {
        nextTick(() => {
          var _a;
          (_a = inputField.value) == null ? void 0 : _a.setSelectionRange(cursorPosition, cursorPosition);
        });
      }
    });
    watch(() => props.inputText, (value, oldValue) => {
      const cursorOffset = valueLength > 1 && value.length !== oldValue.length ? value.length - valueLength : 0;
      const position = Math.abs(cursorPosition + cursorOffset);
      internalInputText.value = value;
      nextTick(() => {
        var _a;
        if ((hasFocus.value || props.manualUpdateAutoSelect) && props.inputType === "text") {
          (_a = inputField.value) == null ? void 0 : _a.setSelectionRange(position, position);
        }
      });
    });
    function onClickShowInfo() {
      if (props.alwaysShowInfo) {
        showInfo.value = true;
      } else {
        showInfo.value = !showInfo.value && !!props.inputInfo;
      }
    }
    const onESC = (event) => {
      emit("esc", event);
    };
    const onEnter = (event) => {
      if (props.preventEnter) {
        event.preventDefault();
        event.stopPropagation();
      }
      emit("enter", event);
    };
    const setFocus = () => {
      var _a;
      return (_a = inputField.value) == null ? void 0 : _a.focus();
    };
    __expose({ setFocus });
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", _hoisted_1, [
        __props.label ? (openBlock(), createElementBlock("div", _hoisted_2, [
          createBaseVNode("div", _hoisted_3, [
            createBaseVNode("label", {
              class: normalizeClass(["cc-text-bold", __props.capitalizeLabel ? "capitalize " : ""]),
              for: __props.inputId,
              id: __props.inputId + "-label",
              onClick: withModifiers(onClickShowInfo, ["stop"])
            }, [
              createTextVNode(toDisplayString(__props.label) + " ", 1),
              __props.inputInfo && !__props.alwaysShowInfo && !__props.inputDisabled ? (openBlock(), createElementBlock("i", _hoisted_5)) : createCommentVNode("", true)
            ], 10, _hoisted_4),
            hasSlotLabelRight.value ? (openBlock(), createElementBlock("div", _hoisted_6, [
              renderSlot(_ctx.$slots, "label-right", {}, void 0, true)
            ])) : createCommentVNode("", true)
          ]),
          (showInfo.value || __props.alwaysShowInfo) && !__props.inputDisabled ? (openBlock(), createElementBlock("div", {
            key: 0,
            class: "w-full flex flex-row flex-nowrap justify-start items-center whitespace-pre-wrap cc-p cc-area-highlight cc-text-medium",
            id: __props.inputId + "-description"
          }, toDisplayString(__props.inputInfo) + "  ", 9, _hoisted_7)) : createCommentVNode("", true)
        ])) : createCommentVNode("", true),
        createBaseVNode("div", {
          class: normalizeClass(["overflow-hidden pl-1 pr-1.5 sm:pl-1.5 sm:pr-2 space-x-1 sm:space-x-1.5 col-span-12 cc-area-light flex flex-row flex-nowrap justify-between", (showInputError.value ? "cc-input-error" : " ") + " " + __props.inputCSS + " " + (__props.multilineInput && __props.rows > 1 ? " items-start" : "")])
        }, [
          hasSlotPrepend.value ? (openBlock(), createElementBlock("div", {
            key: 0,
            class: normalizeClass(["cc-flex-fixed flex flex-nowrap items-center whitespace-nowrap", __props.multilineInput && __props.rows > 1 ? "mt-3" : ""]),
            style: { "max-width": "50%" }
          }, [
            renderSlot(_ctx.$slots, "icon-prepend", {}, void 0, true)
          ], 2)) : createCommentVNode("", true),
          __props.multilineInput ? (openBlock(), createElementBlock("textarea", {
            key: 1,
            class: normalizeClass(["flex-1 w-full cc-py px-1 bg-transparent outline-none focus:outline-none focus:ring-0 ring-0 border-0 hover:ring-0", (showInputError.value ? "cc-input-placeholder-error" : "cc-input-placeholder ") + " " + __props.inputTextCSS]),
            ref_key: "textAreaField",
            ref: textAreaField,
            value: internalInputText.value,
            disabled: __props.inputDisabled,
            name: __props.inputId,
            id: __props.inputId,
            rows: _rows.value,
            autocomplete: __props.autocomplete,
            placeholder: __props.inputHint,
            "aria-invalid": showInputError.value ? "true" : "false",
            "aria-describedby": showInputError.value ? __props.inputId + "-error" : __props.inputId + "-description",
            onInput: _cache[0] || (_cache[0] = ($event) => onInput($event)),
            onFocusin: _cache[1] || (_cache[1] = ($event) => hasFocus.value = true),
            onFocusout: _cache[2] || (_cache[2] = ($event) => {
              hasFocus.value = false;
              _ctx.$emit("lostFocus");
            }),
            onKeydown: _cache[3] || (_cache[3] = withKeys(($event) => onEnter($event), ["enter"])),
            onPaste: _cache[4] || (_cache[4] = ($event) => onInput($event))
          }, null, 42, _hoisted_8)) : (openBlock(), createElementBlock("input", {
            key: 2,
            class: normalizeClass(["flex-1 w-full cc-py px-1 bg-transparent outline-none focus:outline-none focus:ring-0 ring-0 border-0 hover:ring-0", (showInputError.value ? "cc-input-placeholder-error" : "cc-input-placeholder ") + " " + __props.inputTextCSS]),
            ref_key: "inputField",
            ref: inputField,
            value: internalInputText.value,
            disabled: __props.inputDisabled,
            name: __props.inputId,
            id: __props.inputId,
            autocomplete: __props.autocomplete,
            type: __props.inputType,
            pattern: __props.inputPattern,
            min: __props.minValue,
            max: __props.maxValue,
            placeholder: __props.inputHint,
            "aria-invalid": showInputError.value ? "true" : "false",
            "aria-describedby": showInputError.value ? __props.inputId + "-error" : __props.inputId + "-description",
            "data-lpignore": __props.autocomplete === "off" ? "true" : "false",
            onInput: _cache[5] || (_cache[5] = ($event) => onInput($event)),
            onFocusin: _cache[6] || (_cache[6] = ($event) => hasFocus.value = true),
            onFocusout: _cache[7] || (_cache[7] = ($event) => {
              hasFocus.value = false;
              _ctx.$emit("lostFocus");
            }),
            onKeydown: [
              _cache[8] || (_cache[8] = withKeys(($event) => onEnter($event), ["enter"])),
              withKeys(onESC, ["esc"])
            ],
            onPaste: _cache[9] || (_cache[9] = ($event) => onInput($event))
          }, null, 42, _hoisted_9)),
          showInputError.value ? (openBlock(), createElementBlock("div", {
            key: 3,
            class: normalizeClass(["cc-flex-fixed flex items-center pointer-events-none", __props.multilineInput && __props.rows > 1 ? "mt-3" : ""])
          }, [
            createVNode(IconError, { class: "w-5 h-5" })
          ], 2)) : createCommentVNode("", true),
          __props.showReset && internalInputText.value.length > 0 ? (openBlock(), createElementBlock("div", {
            key: 4,
            class: normalizeClass(["cc-flex-fixed flex items-center pointer-events-auto cursor-pointer", __props.multilineInput && __props.rows > 1 ? "mt-3" : ""]),
            onClick: _cache[10] || (_cache[10] = withModifiers(($event) => _ctx.$emit("reset"), ["stop"]))
          }, [
            createVNode(IconX, { class: "h-5 w-5" })
          ], 2)) : createCommentVNode("", true),
          hasSlotAppend.value ? (openBlock(), createElementBlock("div", {
            key: 5,
            class: normalizeClass(["cc-flex-fixed flex items-center", __props.multilineInput && __props.rows > 1 ? "mt-3" : ""])
          }, [
            renderSlot(_ctx.$slots, "icon-append", {}, void 0, true)
          ], 2)) : createCommentVNode("", true)
        ], 2),
        showInputError.value ? (openBlock(), createElementBlock("div", {
          key: 1,
          class: "col-span-12 flex justify-start items-center cc-text-normal cc-text-color-error cc-px break-normal",
          id: __props.inputId + "-error"
        }, toDisplayString(__props.inputError), 9, _hoisted_10)) : __props.inputInfoAppend ? (openBlock(), createElementBlock("div", {
          key: 2,
          class: "col-span-12 my-0 sm:my-0 flex justify-start items-center cc-text-normal cc-px break-normal",
          id: __props.inputId + "-info-append"
        }, toDisplayString(__props.inputInfoAppend), 9, _hoisted_11)) : createCommentVNode("", true)
      ]);
    };
  }
});
const GridInput = /* @__PURE__ */ _export_sfc(_sfc_main, [["__scopeId", "data-v-6f245c8b"]]);
export {
  GridInput as G
};
