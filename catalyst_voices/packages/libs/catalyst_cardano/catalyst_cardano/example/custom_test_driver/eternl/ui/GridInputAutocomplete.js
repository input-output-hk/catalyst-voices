import { d as defineComponent, ez as useSlots, a7 as useQuasar, z as ref, f as computed, C as onMounted, V as nextTick, aG as onUnmounted, D as watch, o as openBlock, c as createElementBlock, e as createBaseVNode, b as withModifiers, i as createTextVNode, t as toDisplayString, j as createCommentVNode, aA as renderSlot, ab as withKeys, n as normalizeClass, F as withDirectives, J as vShow, H as Fragment, I as renderList, q as createVNode } from "./index.js";
import { a as IconX, I as IconError } from "./IconError.js";
import { _ as _export_sfc } from "./_plugin-vue_export-helper.js";
const _hoisted_1 = {
  key: 0,
  class: "col-span-12 flex flex-col flex-nowrap space-y-2 justify-between items-start"
};
const _hoisted_2 = { class: "w-full flex flex-row flex-nowrap justify-between items-start" };
const _hoisted_3 = ["for", "id"];
const _hoisted_4 = {
  key: 0,
  class: "mdi mdi-information-outline cursor-pointer pointer-events-auto"
};
const _hoisted_5 = {
  key: 0,
  class: "flex flex-row flex-nowrap justify-start items-center"
};
const _hoisted_6 = ["id"];
const _hoisted_7 = ["name", "id", "type", "autocomplete", "data-lpignore", "pattern", "placeholder", "aria-invalid", "aria-describedby", "disabled"];
const _hoisted_8 = { class: "absolute top-14 z-max cc-bg-light-0 cc-ring-highlight w-full rounded-borders cc-py border-l-solid border-r-solid border-b-solid" };
const _hoisted_9 = ["onMouseover", "onClick"];
const _hoisted_10 = {
  key: 1,
  class: "cc-flex-fixed pr-2.5 flex items-center"
};
const _hoisted_11 = {
  key: 3,
  class: "cc-flex-fixed pr-2.5 flex items-center pointer-events-auto cursor-pointer"
};
const _hoisted_12 = {
  key: 4,
  class: "cc-flex-fixed pr-2.5 flex items-center pointer-events-none"
};
const _hoisted_13 = ["id"];
const _hoisted_14 = ["id", "innerHTML"];
const _hoisted_15 = {
  key: 3,
  class: "col-span-12 my-0 sm:my-0 flex flex-col justify-start items-start cc-text-normal cc-px whitespace-pre-wrap break-all"
};
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "GridInputAutocomplete",
  props: {
    inputText: { type: String, default: "", required: true },
    inputError: { type: String, default: "" },
    label: { type: String, default: "" },
    inputId: { type: String, default: "text" },
    inputType: { type: String, default: "text" },
    inputPattern: { type: String, default: null },
    inputInfo: { type: String, default: null },
    inputInfoAppend: { type: String, default: null },
    inputHint: { type: String, default: null },
    inputCSS: { type: String, default: "cc-input" },
    inputTextCSS: { type: String, default: "cc-text-color" },
    inputDisabled: { type: Boolean, default: false },
    autocomplete: { type: String, default: "on" },
    autofocus: { type: Boolean, default: false },
    alwaysShowInfo: { type: Boolean, default: false },
    showReset: { type: Boolean, default: false },
    autoCompleteItems: { type: Array, default: [] }
  },
  emits: [
    "update:inputText",
    "update:inputError",
    "lostFocus",
    "enter",
    "reset"
  ],
  setup(__props, { emit: __emit }) {
    const props = __props;
    const emit = __emit;
    const slots = useSlots();
    const $q = useQuasar();
    const hasFocus = ref(false);
    const showInfo = ref(props.alwaysShowInfo);
    const inputField = ref(null);
    const hasSlotPrepend = computed(() => typeof slots["icon-prepend"] !== "undefined");
    const hasSlotAppend = computed(() => typeof slots["icon-append"] !== "undefined");
    const hasSlotLabelRight = computed(() => typeof slots["label-right"] !== "undefined");
    const hasSlotBottomAppend = computed(() => typeof slots["bottom-append"] !== "undefined");
    const results = ref([]);
    const isOpen = ref(false);
    const arrowCounter = ref(-1);
    const initialProp = ref();
    const mouseOverElement = ref(null);
    const component = ref();
    onMounted(() => {
      addEventListener("click", handleClickOutside);
      inputField.value.value = props.inputText;
      initialProp.value = props.inputText;
      if (props.autofocus) {
        nextTick(() => {
          var _a;
          (_a = inputField.value) == null ? void 0 : _a.focus();
        });
      }
    });
    onUnmounted(() => {
      removeEventListener("click", handleClickOutside);
    });
    watch(() => props.inputText, (value) => {
      if (inputField.value.value !== value) {
        setInputValue(value);
      }
    });
    const filterResults = () => {
      let value = props.autoCompleteItems.filter((item) => item.toLowerCase().indexOf(inputField.value.value.toLowerCase()) > -1);
      const maxItems = $q.platform.is.mobile ? 10 : 20;
      results.value = value.length > maxItems ? value.splice(0, maxItems) : value;
    };
    const resetArrowCounter = () => {
      arrowCounter.value = -1;
    };
    const handleClickOutside = (event) => {
      if (component.value && !component.value.contains(event.target)) {
        closeAutocomplete();
        resetArrowCounter();
      }
    };
    const setInputValue = (input) => {
      inputField.value.value = input;
      emit("update:inputText", input);
    };
    const getSelectedValue = () => {
      return results.value[arrowCounter.value] ?? "";
    };
    const onInput = (event) => {
      if (inputField.value.value.length === 0) {
        emit("update:inputText", "");
        isOpen.value = false;
        return;
      }
      filterResults();
      if (results.value && results.value.length === 0) {
        isOpen.value = false;
        emit("update:inputText", inputField.value.value);
      } else if (inputField.value.value.length > 0 && results.value.length > 0) {
        if (event.inputType === "insertFromPaste" && results.value.length === 1) {
          if (results.value[0].toLowerCase() === inputField.value.value.toLowerCase()) {
            closeAutocomplete();
            emit("update:inputText", results.value[0]);
          } else {
            isOpen.value = true;
          }
        } else {
          isOpen.value = true;
          emit("update:inputText", inputField.value.value);
        }
      }
    };
    const onEnter = async (event) => {
      const selectedValue = getSelectedValue();
      if (selectedValue.length > 0) {
        setInputValue(selectedValue);
        initialProp.value = selectedValue;
        emit("update:inputText", selectedValue);
        closeAutocomplete();
        resetArrowCounter();
      } else if (results.value.length === 1) {
        inputField.value.value = results.value[0];
        inputField.value.focus();
        emit("update:inputText", results.value[0]);
        closeAutocomplete();
      }
      emit("enter");
    };
    const onClickShowInfo = () => {
      if (props.alwaysShowInfo) {
        showInfo.value = true;
      } else {
        showInfo.value = !showInfo.value && !!props.inputInfo;
      }
    };
    const handleClick = (item) => {
      setInputValue(item);
      closeAutocomplete();
      inputField.value.focus();
      emit("update:inputText", item);
    };
    const closeAutocomplete = () => {
      isOpen.value = false;
      results.value.splice(0);
      resetArrowCounter();
    };
    const onArrowUp = (event) => {
      event.preventDefault();
      if (arrowCounter.value > 0) {
        arrowCounter.value = arrowCounter.value - 1;
      } else if (arrowCounter.value <= 0) {
        arrowCounter.value = results.value.length - 1;
      }
    };
    const onArrowDown = (event) => {
      event.preventDefault();
      if (results.value && arrowCounter.value < results.value.length - 1) {
        arrowCounter.value = arrowCounter.value + 1;
      } else if (arrowCounter.value === results.value.length - 1) {
        arrowCounter.value = 0;
      }
    };
    const lostFocus = () => {
      var _a, _b;
      hasFocus.value = false;
      if ((((_b = (_a = inputField.value) == null ? void 0 : _a.value) == null ? void 0 : _b.length) ?? 0) > 0) {
        emit("update:inputText", inputField.value.value);
        emit("lostFocus");
      }
    };
    const handleMouseover = (event) => {
      mouseOverElement.value = event;
    };
    const handleEsc = () => {
      if (isOpen.value) {
        closeAutocomplete();
        emit("update:inputText", inputField.value.value);
      } else {
        lostFocus();
        nextTick(() => {
          reset();
        });
      }
    };
    const reset = () => {
      emit("reset");
      closeAutocomplete();
    };
    const clear = () => {
      setInputValue("");
    };
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", {
        class: "w-full grid grid-cols-12 content-start cc-gap",
        ref_key: "component",
        ref: component
      }, [
        __props.label ? (openBlock(), createElementBlock("div", _hoisted_1, [
          createBaseVNode("div", _hoisted_2, [
            createBaseVNode("label", {
              class: "capitalize cc-text-bold",
              for: __props.inputId,
              id: __props.inputId + "-label",
              onClick: withModifiers(onClickShowInfo, ["stop"])
            }, [
              createTextVNode(toDisplayString(__props.label) + " ", 1),
              __props.inputInfo && !__props.alwaysShowInfo && !__props.inputDisabled ? (openBlock(), createElementBlock("i", _hoisted_4)) : createCommentVNode("", true)
            ], 8, _hoisted_3),
            hasSlotLabelRight.value ? (openBlock(), createElementBlock("div", _hoisted_5, [
              renderSlot(_ctx.$slots, "label-right", {}, void 0, true)
            ])) : createCommentVNode("", true)
          ]),
          (showInfo.value || __props.alwaysShowInfo) && !__props.inputDisabled ? (openBlock(), createElementBlock("div", {
            key: 0,
            class: "w-full flex flex-row flex-nowrap justify-start items-center whitespace-pre-wrap cc-p cc-area-highlight cc-text-medium",
            id: __props.inputId + "-description"
          }, toDisplayString(__props.inputInfo) + "  ", 9, _hoisted_6)) : createCommentVNode("", true)
        ])) : createCommentVNode("", true),
        createBaseVNode("div", {
          class: normalizeClass(["relative col-span-12 cc-area-light sm:pl-3 flex flex-row flex-nowrap justify-between", (__props.inputError && !isOpen.value ? "cc-input-error " : __props.inputDisabled ? " " : __props.inputCSS) + " "])
        }, [
          hasSlotPrepend.value ? (openBlock(), createElementBlock("div", {
            key: 0,
            class: "cc-flex-fixed flex flex-nowrap items-center whitespace-nowrap",
            style: { "max-width": "50%" },
            onClick: closeAutocomplete
          }, [
            renderSlot(_ctx.$slots, "icon-prepend", {}, void 0, true)
          ])) : createCommentVNode("", true),
          createBaseVNode("input", {
            name: __props.inputId,
            id: __props.inputId,
            type: __props.inputType,
            rows: 2,
            autocomplete: __props.autocomplete,
            "data-lpignore": __props.autocomplete === "off" ? "true" : "false",
            onKeyup: withKeys(handleEsc, ["esc"]),
            onKeydown: [
              withKeys(onArrowDown, ["down"]),
              withKeys(onArrowUp, ["up"]),
              withKeys(onEnter, ["enter"])
            ],
            onPaste: _cache[0] || (_cache[0] = ($event) => onInput($event)),
            onInput: _cache[1] || (_cache[1] = ($event) => onInput($event)),
            onFocusin: _cache[2] || (_cache[2] = ($event) => hasFocus.value = true),
            onFocusout: lostFocus,
            ref_key: "inputField",
            ref: inputField,
            class: normalizeClass(["flex-1 w-full cc-py bg-transparent max-h-24 outline-none focus:outline-none focus:ring-0 ring-0 border-0 hover:ring-0", (__props.inputError && !isOpen.value ? "cc-input-placeholder-error" : "cc-input-placeholder " + __props.inputTextCSS) + " "]),
            pattern: __props.inputPattern,
            placeholder: __props.inputHint,
            "aria-invalid": __props.inputError && !isOpen.value && __props.inputError.length > 0 ? "true" : "false",
            "aria-describedby": __props.inputError && !isOpen.value && __props.inputError.length > 0 ? __props.inputId + "-error" : __props.inputId + "-description",
            disabled: __props.inputDisabled
          }, null, 42, _hoisted_7),
          withDirectives(createBaseVNode("div", _hoisted_8, [
            createBaseVNode("ul", {
              class: "p-0 m-0 b-2 h-auto overflow-auto",
              onMouseleave: _cache[3] || (_cache[3] = ($event) => handleMouseover(null))
            }, [
              (openBlock(true), createElementBlock(Fragment, null, renderList(results.value, (result, i) => {
                return openBlock(), createElementBlock("li", {
                  key: i,
                  onMouseover: ($event) => handleMouseover(i),
                  onClick: ($event) => handleClick(result),
                  class: normalizeClass(["list-none left-auto pl-4 pr-2 py-1 cursor-pointer autocomplete-item", i === arrowCounter.value && mouseOverElement.value === null ? " font-semibold cc-bg-highlight cc-text-white" : "hover:font-semibold hover:cc-bg-highlight hover:cc-text-white"])
                }, toDisplayString(result), 43, _hoisted_9);
              }), 128))
            ], 32)
          ], 512), [
            [vShow, isOpen.value]
          ]),
          hasSlotAppend.value ? (openBlock(), createElementBlock("div", _hoisted_10, [
            renderSlot(_ctx.$slots, "icon-append", {}, void 0, true)
          ])) : createCommentVNode("", true),
          __props.showReset ? (openBlock(), createElementBlock("div", {
            key: 2,
            class: "cc-flex-fixed pr-2.5 flex items-center pointer-events-auto cursor-pointer",
            onClick: clear
          }, [
            createVNode(IconX, { class: "h-5 w-5" })
          ])) : (openBlock(), createElementBlock("div", _hoisted_11, _cache[4] || (_cache[4] = [
            createBaseVNode("span", null, " ", -1)
          ]))),
          __props.inputError && !isOpen.value ? (openBlock(), createElementBlock("div", _hoisted_12, [
            createVNode(IconError, { class: "w-5 h-5" })
          ])) : createCommentVNode("", true)
        ], 2),
        __props.inputError && !isOpen.value ? (openBlock(), createElementBlock("div", {
          key: 1,
          class: "col-span-12 flex justify-start items-center cc-text-medium cc-text-color-error cc-px whitespace-pre-wrap",
          id: __props.inputId + "-error"
        }, toDisplayString(__props.inputError), 9, _hoisted_13)) : __props.inputInfoAppend ? (openBlock(), createElementBlock("div", {
          key: 2,
          class: "col-span-12 my-0 sm:my-0 flex flex-col justify-start items-start cc-text-normal cc-px whitespace-pre-wrap break-all",
          id: __props.inputId + "-info-append",
          innerHTML: __props.inputInfoAppend
        }, null, 8, _hoisted_14)) : createCommentVNode("", true),
        hasSlotBottomAppend.value ? (openBlock(), createElementBlock("div", _hoisted_15, [
          renderSlot(_ctx.$slots, "bottom-append", {}, void 0, true)
        ])) : createCommentVNode("", true)
      ], 512);
    };
  }
});
const GridInputAutocomplete = /* @__PURE__ */ _export_sfc(_sfc_main, [["__scopeId", "data-v-a2c9df21"]]);
export {
  GridInputAutocomplete as G
};
