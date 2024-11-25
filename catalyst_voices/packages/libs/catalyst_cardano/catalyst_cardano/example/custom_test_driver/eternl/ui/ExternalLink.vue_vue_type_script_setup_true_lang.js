import { d as defineComponent, z as ref, o as openBlock, c as createElementBlock, u as unref, n as normalizeClass, b as withModifiers, e as createBaseVNode, t as toDisplayString, j as createCommentVNode, a as createBlock, h as withCtx, i as createTextVNode } from "./index.js";
import { u as useTranslation } from "./useTranslation.js";
import { _ as _sfc_main$1 } from "./Tooltip.vue_vue_type_script_setup_true_lang.js";
const _hoisted_1 = ["href"];
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "ExternalLink",
  props: {
    url: { type: [String, Number], required: true },
    label: { type: String, required: true },
    type: { type: String, required: false },
    labelHover: { type: String, required: false, default: "" },
    labelCSS: { type: String, required: false, default: "" },
    icon: { type: String, required: false, default: "mdi mdi-open-in-new mx-1" },
    iconAlignLeft: { type: Boolean, required: false, default: false },
    truncate: { type: Boolean, required: false, default: false }
  },
  setup(__props) {
    const props = __props;
    useTranslation();
    let absURL = ref(props.url);
    let hover = ref(props.labelHover ?? "");
    return (_ctx, _cache) => {
      var _a;
      return openBlock(), createElementBlock("div", {
        class: normalizeClass(["cursor-pointer flex flex-nowrap items-start", __props.truncate ? "truncate" : ""])
      }, [
        __props.label && unref(absURL) ? (openBlock(), createElementBlock("a", {
          key: 0,
          href: (_a = unref(absURL)) == null ? void 0 : _a.toString(),
          target: "_blank",
          rel: "noopener noreferrer",
          class: normalizeClass(["flex flex-nowrap items-start", (__props.truncate ? "truncate" : "") + " " + (__props.iconAlignLeft ? "flex-row-reverse" : "flex-row")]),
          onClick: _cache[0] || (_cache[0] = withModifiers(() => {
          }, ["stop"]))
        }, [
          createBaseVNode("div", {
            class: normalizeClass([(__props.truncate ? "truncate" : "") + " " + __props.labelCSS, "self-center"])
          }, toDisplayString(__props.label), 3),
          __props.icon ? (openBlock(), createElementBlock("i", {
            key: 0,
            class: normalizeClass(__props.icon)
          }, null, 2)) : createCommentVNode("", true),
          unref(hover) ? (openBlock(), createBlock(_sfc_main$1, {
            key: 1,
            "tooltip-c-s-s": "whitespace-nowrap",
            anchor: "bottom middle",
            "transition-show": "scale",
            "transition-hide": "scale"
          }, {
            default: withCtx(() => [
              createTextVNode(toDisplayString(unref(hover)), 1)
            ]),
            _: 1
          })) : createCommentVNode("", true)
        ], 10, _hoisted_1)) : (openBlock(), createElementBlock("div", {
          key: 1,
          class: normalizeClass(["flex flex-nowrap items-start cursor-default", (__props.truncate ? "truncate" : "") + " " + (__props.iconAlignLeft ? "flex-row-reverse" : "flex-row")])
        }, [
          createBaseVNode("div", {
            class: normalizeClass([(__props.truncate ? "truncate" : "") + " " + __props.labelCSS, "self-center"])
          }, toDisplayString(__props.label), 3)
        ], 2))
      ], 2);
    };
  }
});
export {
  _sfc_main as _
};
