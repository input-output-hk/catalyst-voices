import { d as defineComponent, o as openBlock, c as createElementBlock, n as normalizeClass, b as withModifiers, j as createCommentVNode, e as createBaseVNode, t as toDisplayString, q as createVNode, h as withCtx, i as createTextVNode } from "./index.js";
import { u as useTranslation } from "./useTranslation.js";
import { _ as _sfc_main$1 } from "./Tooltip.vue_vue_type_script_setup_true_lang.js";
const _hoisted_1 = ["type", "form", "disabled"];
const _hoisted_2 = {
  key: 2,
  class: "flex flex-col flex-nowrap"
};
const _hoisted_3 = {
  key: 0,
  class: "text-xs sm:text-sm cc-text-normal cc-text-color-caption mt-0.5 sm:mt-1"
};
const _hoisted_4 = {
  key: 3,
  class: "mdi mdi-information-outline"
};
const _hoisted_5 = {
  key: 4,
  class: "absolute top-0 left-0 w-full h-full"
};
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "GridButton",
  props: {
    label: { type: String },
    caption: { type: String },
    icon: { type: String },
    iconClickable: { type: Boolean, default: false },
    type: { type: String, required: false, default: "button" },
    form: { type: String, required: false, default: "" },
    link: { type: Function, default: null },
    capitalize: { type: Boolean, default: true },
    disabled: { type: Boolean, default: false },
    disableTooltip: { type: String, required: false }
  },
  emits: ["iconClick"],
  setup(__props, { emit: __emit }) {
    const props = __props;
    const emit = __emit;
    useTranslation();
    const onIconClick = () => {
      if (props.iconClickable) {
        emit("iconClick");
      }
    };
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("button", {
        class: normalizeClass(["relative cc-flex-fixed cursor-pointer min-w-0 focus:outline-none flex flex-row flex-nowrap justify-center items-center space-x-2", __props.disabled ? __props.disableTooltip ? "" : "cc-btn-disabled" : ""]),
        onClick: _cache[0] || (_cache[0] = withModifiers(($event) => {
          var _a;
          return (_a = __props.link) == null ? void 0 : _a.call(__props);
        }, ["stop"])),
        type: __props.type,
        form: __props.form,
        disabled: __props.disabled
      }, [
        __props.icon && __props.iconClickable ? (openBlock(), createElementBlock("i", {
          key: 0,
          class: normalizeClass(["", __props.icon + (__props.iconClickable ? " hover:cc-text-color" : "")]),
          onClick: withModifiers(onIconClick, ["stop", "prevent"])
        }, null, 2)) : __props.icon ? (openBlock(), createElementBlock("i", {
          key: 1,
          class: normalizeClass(["", __props.icon])
        }, null, 2)) : createCommentVNode("", true),
        __props.label ? (openBlock(), createElementBlock("span", _hoisted_2, [
          createBaseVNode("span", {
            class: normalizeClass(__props.capitalize ? "capitalize" : "")
          }, toDisplayString(__props.label), 3),
          __props.caption ? (openBlock(), createElementBlock("span", _hoisted_3, toDisplayString(__props.caption), 1)) : createCommentVNode("", true)
        ])) : createCommentVNode("", true),
        __props.disableTooltip ? (openBlock(), createElementBlock("i", _hoisted_4)) : createCommentVNode("", true),
        __props.disableTooltip ? (openBlock(), createElementBlock("div", _hoisted_5, [
          createVNode(_sfc_main$1, {
            "transition-show": "scale",
            "transition-hide": "scale"
          }, {
            default: withCtx(() => [
              createTextVNode(toDisplayString(__props.disableTooltip), 1)
            ]),
            _: 1
          })
        ])) : createCommentVNode("", true)
      ], 10, _hoisted_1);
    };
  }
});
export {
  _sfc_main as _
};
