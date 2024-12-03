import { b as browser } from "./browser.js";
import { u as useTranslation } from "./useTranslation.js";
import { _ as _sfc_main$1 } from "./CopyToClipboard.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$3 } from "./Tooltip.vue_vue_type_script_setup_true_lang.js";
import { G as GridSpace } from "./GridSpace.js";
import { _ as _sfc_main$2 } from "./GridHeadline.vue_vue_type_script_setup_true_lang.js";
import { M as Modal } from "./Modal.js";
import { d as defineComponent, z as ref, o as openBlock, c as createElementBlock, e as createBaseVNode, q as createVNode, u as unref, a as createBlock, h as withCtx, j as createCommentVNode, n as normalizeClass, t as toDisplayString, i as createTextVNode, H as Fragment, V as nextTick } from "./index.js";
const _hoisted_1 = { class: "flex-1 pr-1 cc-addr break-all whitespace-pre-wrap sm:text-sm" };
const _hoisted_2 = { class: "grow-0 shrink-0 w-full flex flex-row flex-nowrap items-start justify-between border-b cc-p" };
const _hoisted_3 = { class: "flex flex-col cc-text-sz" };
const _hoisted_4 = { class: "flex flex-col content-center items-center justify-center p-4" };
const _hoisted_5 = { class: "ml-1" };
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "GridReceiveAddr",
  props: {
    text: { type: String, default: "" },
    info: { type: String, default: "" },
    css: { type: String, default: "" },
    used: { type: Boolean, default: false },
    highlight: { type: Boolean, default: false, required: false },
    showDivider: { type: Boolean, default: true, required: false }
  },
  setup(__props) {
    const props = __props;
    const { it } = useTranslation();
    const open = ref(false);
    const canvasRef = ref(null);
    const openModal = () => {
      open.value = true;
      nextTick(() => generateMarker());
    };
    const onClose = () => open.value = false;
    const generateMarker = () => {
      browser.toCanvas(canvasRef.value, props.text, function(error) {
        if (error) console.error(error);
      });
    };
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock(Fragment, null, [
        createBaseVNode("div", {
          class: normalizeClass(["overflow-hidden cc-text-sz cc-text-semi-bold col-span-12 space-x-2 pr-1 flex flex-row flex-nowrap items-start", __props.css + " " + (__props.used ? " " : "")])
        }, [
          createBaseVNode("div", _hoisted_1, [
            createVNode(_sfc_main$1, {
              label: __props.text + "\n" + __props.info,
              "label-hover": unref(it)("wallet.receive.button.copy.hover"),
              "notification-text": unref(it)("wallet.receive.button.copy.notify"),
              "copy-text": __props.text,
              highlight: __props.highlight,
              "icon-right": "",
              class: "cc-flex-fixed inline flex flex-nowrap items-start justify-end mb-2 mr-2"
            }, null, 8, ["label", "label-hover", "notification-text", "copy-text", "highlight"]),
            open.value ? (openBlock(), createBlock(Modal, {
              key: 0,
              narrow: "",
              "full-width-on-mobile": "",
              onClose
            }, {
              header: withCtx(() => [
                createBaseVNode("div", _hoisted_2, [
                  createBaseVNode("div", _hoisted_3, [
                    createVNode(_sfc_main$2, {
                      label: unref(it)("wallet.receive.button.share.hover")
                    }, null, 8, ["label"])
                  ])
                ])
              ]),
              content: withCtx(() => [
                createBaseVNode("div", _hoisted_4, [
                  createBaseVNode("canvas", {
                    ref_key: "canvasRef",
                    ref: canvasRef,
                    width: "212",
                    height: "212",
                    class: "shadow cc-rounded mb-4"
                  }, null, 512),
                  createVNode(_sfc_main$1, {
                    label: __props.text,
                    "label-hover": unref(it)("wallet.receive.button.copy.hover"),
                    "notification-text": unref(it)("wallet.receive.button.copy.notify"),
                    "copy-text": __props.text,
                    class: "break-all text-center mt-1"
                  }, null, 8, ["label", "label-hover", "notification-text", "copy-text"])
                ])
              ]),
              _: 1
            })) : createCommentVNode("", true)
          ]),
          createBaseVNode("div", {
            class: "cc-flex-fixed inline flex items-center justify-center cursor-pointer",
            onClick: openModal
          }, [
            createBaseVNode("i", {
              class: normalizeClass(unref(it)("wallet.receive.button.share.icon"))
            }, null, 2),
            createBaseVNode("span", _hoisted_5, toDisplayString(unref(it)("wallet.receive.button.share.label")), 1),
            !open.value ? (openBlock(), createBlock(_sfc_main$3, {
              key: 0,
              "transition-show": "scale",
              "transition-hide": "scale"
            }, {
              default: withCtx(() => [
                createTextVNode(toDisplayString(unref(it)("wallet.receive.button.share.hover")), 1)
              ]),
              _: 1
            })) : createCommentVNode("", true)
          ])
        ], 2),
        __props.showDivider ? (openBlock(), createBlock(GridSpace, {
          key: 0,
          hr: ""
        })) : createCommentVNode("", true)
      ], 64);
    };
  }
});
export {
  _sfc_main as _
};
