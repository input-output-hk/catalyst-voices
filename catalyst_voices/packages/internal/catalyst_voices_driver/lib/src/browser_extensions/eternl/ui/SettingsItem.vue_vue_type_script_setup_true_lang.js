import { d as defineComponent, z as ref, D as watch, o as openBlock, c as createElementBlock, e as createBaseVNode, n as normalizeClass, b as withModifiers, a as createBlock, h as withCtx, i as createTextVNode, t as toDisplayString, u as unref, j as createCommentVNode, q as createVNode, cb as QToggle_default, aA as renderSlot, H as Fragment } from "./index.js";
import { u as useTranslation } from "./useTranslation.js";
import { _ as _sfc_main$1 } from "./Tooltip.vue_vue_type_script_setup_true_lang.js";
import { G as GridSpace } from "./GridSpace.js";
const _hoisted_1 = { class: "grow min-w-0 flex flex-row flex-nowrap items-start h-5 cc-text-bold" };
const _hoisted_2 = {
  key: 0,
  class: "relative cc-flex-fixed flex flex-col flex-nowrap items-start w-6 h-6 -ml-1 -mt-1"
};
const _hoisted_3 = { class: "px-1 py-0.5 bg-slate-200 dark:bg-neutral-700 cc-rounded" };
const _hoisted_4 = { class: "relative flex-grow-0 flex-shrink-0 cursor-pointer cc-text-spacing cc-text-xs hover:cc-text-highlight-hover" };
const _hoisted_5 = {
  key: 0,
  class: "ml-5 mr-16 mt-1 break-normal whitespace-pre-wrap"
};
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "SettingsItem",
  props: {
    label: { type: String, required: true, default: "" },
    caption: { type: String, required: false, default: "" },
    canToggle: { type: Boolean, required: false, default: false },
    canExpand: { type: Boolean, required: false, default: true },
    enabled: { type: Boolean, required: false, default: false },
    separator: { type: Boolean, required: false, default: true },
    saving: { type: Boolean, required: false, default: false },
    openExpanded: { type: Boolean, required: false, default: false },
    dense: { type: Boolean, required: false, default: false },
    showApplyAll: { type: Boolean, required: false, default: false }
  },
  emits: ["toggle", "applyAll"],
  setup(__props, { emit: __emit }) {
    const props = __props;
    const emit = __emit;
    const { it } = useTranslation();
    const open = ref(props.openExpanded);
    const emitToggle = () => {
      open.value = props.canExpand;
      emit("toggle");
    };
    watch(() => props.openExpanded, (isOpen, isOpenOld) => {
      if (isOpen) open.value = true;
    });
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock(Fragment, null, [
        createBaseVNode("div", {
          class: normalizeClass(["col-span-12 cc-text-sz flex flex-col flex-nowrap", open.value ? "" : ""])
        }, [
          createBaseVNode("div", {
            class: normalizeClass(["relative flex flex-row flex-nowrap justify-between items-center space-x-2", __props.canExpand ? "cursor-pointer" : ""]),
            onClick: _cache[1] || (_cache[1] = withModifiers(($event) => open.value = __props.canExpand ? !open.value : false, ["stop"]))
          }, [
            __props.canExpand ? (openBlock(), createBlock(_sfc_main$1, {
              key: 0,
              anchor: "top middle",
              offset: [0, 0],
              "transition-show": "scale",
              "transition-hide": "scale"
            }, {
              default: withCtx(() => [
                createTextVNode(toDisplayString(unref(it)("wallet.settings.button.item." + (open.value ? "collapse" : "expand"))), 1)
              ]),
              _: 1
            })) : createCommentVNode("", true),
            createBaseVNode("div", _hoisted_1, [
              __props.canExpand ? (openBlock(), createElementBlock("div", _hoisted_2, [
                createBaseVNode("i", {
                  class: normalizeClass(["relative text-xl", open.value ? "mdi mdi-chevron-down" : "mdi mdi-chevron-right"])
                }, null, 2)
              ])) : createCommentVNode("", true),
              createBaseVNode("span", {
                class: normalizeClass(["w-full truncate", !__props.canExpand ? "ml-5" : ""])
              }, toDisplayString(__props.label), 3)
            ]),
            __props.showApplyAll ? (openBlock(), createElementBlock("div", {
              key: 1,
              onClick: _cache[0] || (_cache[0] = withModifiers(($event) => _ctx.$emit("applyAll"), ["prevent", "stop"])),
              class: "relative flex-grow-0 flex-shrink-0 cursor-pointer cc-text-spacing cc-text-xs hover:cc-text-highlight-hover"
            }, [
              createBaseVNode("div", _hoisted_3, toDisplayString(unref(it)("wallet.settings.applyToAll")), 1)
            ])) : createCommentVNode("", true),
            createBaseVNode("div", _hoisted_4, [
              __props.canToggle ? (openBlock(), createBlock(QToggle_default, {
                key: 0,
                onClick: withModifiers(emitToggle, ["prevent", "stop"]),
                "model-value": props.enabled,
                class: "relative h-5 -mr-2.5 -ml-2.5",
                disable: __props.saving
              }, {
                default: withCtx(() => [
                  createVNode(_sfc_main$1, {
                    anchor: "top middle",
                    offset: [0, 30],
                    "transition-show": "scale",
                    "transition-hide": "scale"
                  }, {
                    default: withCtx(() => [
                      createTextVNode(toDisplayString(__props.canToggle ? "Disable" : "Enable"), 1)
                    ]),
                    _: 1
                  })
                ]),
                _: 1
              }, 8, ["model-value", "disable"])) : createCommentVNode("", true)
            ])
          ], 2),
          open.value ? (openBlock(), createElementBlock("div", _hoisted_5, toDisplayString(__props.caption), 1)) : createCommentVNode("", true),
          open.value ? (openBlock(), createElementBlock("div", {
            key: 1,
            class: normalizeClass(["relative w-full grid grid-cols-12", __props.dense ? "cc-gap" : "cc-gap"])
          }, [
            createVNode(GridSpace, { class: "w-full" }),
            renderSlot(_ctx.$slots, "setting")
          ], 2)) : createCommentVNode("", true)
        ], 2),
        createVNode(GridSpace, { hr: "" })
      ], 64);
    };
  }
});
export {
  _sfc_main as _
};
