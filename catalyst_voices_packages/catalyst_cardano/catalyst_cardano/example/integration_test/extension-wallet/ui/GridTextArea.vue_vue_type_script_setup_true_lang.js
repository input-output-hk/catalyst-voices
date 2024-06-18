import { d as defineComponent, z as ref, o as openBlock, c as createElementBlock, e as createBaseVNode, a as createBlock, n as normalizeClass, j as createCommentVNode, h as withCtx, i as createTextVNode, t as toDisplayString, b as withModifiers } from "./index.js";
import { _ as _sfc_main$2 } from "./Tooltip.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$1 } from "./GridHeadline.vue_vue_type_script_setup_true_lang.js";
const _hoisted_1 = { class: "w-full grid grid-cols-12 gap-1.5 cc-text-sz" };
const _hoisted_2 = {
  key: 0,
  class: "col-span-12 flex flex-row flex-nowrap justify-start items-start space-x-1"
};
const _hoisted_3 = ["innerHTML"];
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "GridTextArea",
  props: {
    label: { type: String, default: "" },
    text: { type: String, default: "" },
    isInfo: { type: Boolean, default: false },
    startCollapsed: { type: Boolean, default: false },
    infoHover: { type: String, default: "" },
    css: { type: String, default: "cc-bg-txdetails" },
    textCSS: { type: String, default: "flex-1 pr-1 flex items-center text-justify" },
    labelCss: { type: String, default: "" },
    icon: { type: String, default: null },
    animation: { type: String, default: null },
    error: { type: Boolean, default: false },
    dense: { type: Boolean, default: false },
    html: { type: Boolean, default: false },
    nopadding: { type: Boolean, default: false }
  },
  setup(__props) {
    const props = __props;
    const showInfo = ref(true);
    if (props.isInfo && props.startCollapsed) {
      showInfo.value = false;
    }
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", _hoisted_1, [
        __props.isInfo ? (openBlock(), createElementBlock("div", _hoisted_2, [
          createBaseVNode("button", {
            type: "button",
            onClick: _cache[0] || (_cache[0] = withModifiers(($event) => showInfo.value = !showInfo.value, ["prevent", "stop"])),
            class: "flex flex-row"
          }, [
            __props.label ? (openBlock(), createBlock(_sfc_main$1, {
              key: 0,
              class: normalizeClass(__props.labelCss),
              label: __props.label,
              dense: ""
            }, null, 8, ["class", "label"])) : createCommentVNode("", true),
            createBaseVNode("i", {
              class: normalizeClass(["mt-px", showInfo.value ? "mdi mdi-chevron-down" : "mdi mdi-chevron-right"])
            }, [
              __props.infoHover ? (openBlock(), createBlock(_sfc_main$2, {
                key: 0,
                "transition-show": "scale",
                "transition-hide": "scale"
              }, {
                default: withCtx(() => [
                  createTextVNode(toDisplayString(__props.infoHover), 1)
                ]),
                _: 1
              })) : createCommentVNode("", true)
            ], 2)
          ])
        ])) : createCommentVNode("", true),
        showInfo.value ? (openBlock(), createElementBlock("div", {
          key: 1,
          class: normalizeClass(["overflow-auto col-span-12 space-x-2.5 flex flex-row flex-nowrap whitespace-pre-wrap", __props.css + " " + (__props.nopadding ? "" : !__props.dense ? " px-2.5 py-2 sm:py-3 " : " px-2.5 py-1.5 ")])
        }, [
          __props.icon ? (openBlock(), createElementBlock("div", {
            key: 0,
            class: normalizeClass(["cc-flex-fixed", __props.animation])
          }, [
            __props.icon ? (openBlock(), createElementBlock("i", {
              key: 0,
              class: normalizeClass(["text-xl sm:text-2xl", __props.icon])
            }, null, 2)) : createCommentVNode("", true)
          ], 2)) : createCommentVNode("", true),
          __props.html ? (openBlock(), createElementBlock("div", {
            key: 1,
            innerHTML: __props.text,
            class: normalizeClass(["w-full", __props.textCSS])
          }, null, 10, _hoisted_3)) : (openBlock(), createElementBlock("div", {
            key: 2,
            class: normalizeClass(["w-full", __props.textCSS])
          }, toDisplayString(__props.text), 3))
        ], 2)) : createCommentVNode("", true)
      ]);
    };
  }
});
export {
  _sfc_main as _
};
