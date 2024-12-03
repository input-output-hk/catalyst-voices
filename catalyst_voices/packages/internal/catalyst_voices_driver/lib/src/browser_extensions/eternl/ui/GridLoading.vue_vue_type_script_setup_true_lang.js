import { d as defineComponent, o as openBlock, c as createElementBlock, a as createBlock, bk as QSpinner_default, Q as QSpinnerDots_default, jO as QSpinnerTail_default, j as createCommentVNode, e as createBaseVNode, t as toDisplayString, u as unref, q as createVNode, h as withCtx, i as createTextVNode } from "./index.js";
import { u as useTranslation } from "./useTranslation.js";
import { _ as _sfc_main$1 } from "./Tooltip.vue_vue_type_script_setup_true_lang.js";
const _hoisted_1 = {
  key: 0,
  class: "relative cc-area-light col-span-12 cc-p flex flex-row flex-nowrap justify-center items-center"
};
const _hoisted_2 = { class: "ml-4 animate-pulse" };
const _hoisted_3 = {
  key: 3,
  class: "absolute top-0 left-0 w-full h-full"
};
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "GridLoading",
  props: {
    active: { type: Boolean, required: true },
    label: { type: String, required: false },
    css: { type: String, required: false, default: "" },
    color: { type: String, required: false, default: "grey" },
    size: { type: String, required: false, default: "3em" },
    spinnerType: { type: String, required: false, default: "default" },
    // default | dots | tail
    thickness: { type: Number, required: false, default: 2 },
    tooltip: { type: String, required: false }
  },
  setup(__props) {
    const { t } = useTranslation();
    return (_ctx, _cache) => {
      return __props.active ? (openBlock(), createElementBlock("div", _hoisted_1, [
        __props.spinnerType === "default" ? (openBlock(), createBlock(QSpinner_default, {
          key: 0,
          color: __props.color,
          size: __props.size,
          thickness: __props.thickness
        }, null, 8, ["color", "size", "thickness"])) : __props.spinnerType === "dots" ? (openBlock(), createBlock(QSpinnerDots_default, {
          key: 1,
          color: __props.color,
          size: __props.size,
          thickness: __props.thickness
        }, null, 8, ["color", "size", "thickness"])) : __props.spinnerType === "tail" ? (openBlock(), createBlock(QSpinnerTail_default, {
          key: 2,
          color: __props.color,
          size: __props.size,
          thickness: __props.thickness
        }, null, 8, ["color", "size", "thickness"])) : createCommentVNode("", true),
        createBaseVNode("span", _hoisted_2, toDisplayString(__props.label && __props.label.length > 0 ? __props.label : unref(t)("common.status.loading") + "..."), 1),
        __props.tooltip && __props.tooltip.length > 0 ? (openBlock(), createElementBlock("div", _hoisted_3, [
          createVNode(_sfc_main$1, {
            "transition-show": "scale",
            "transition-hide": "scale"
          }, {
            default: withCtx(() => [
              createTextVNode(toDisplayString(__props.tooltip), 1)
            ]),
            _: 1
          })
        ])) : createCommentVNode("", true)
      ])) : createCommentVNode("", true);
    };
  }
});
export {
  _sfc_main as _
};
