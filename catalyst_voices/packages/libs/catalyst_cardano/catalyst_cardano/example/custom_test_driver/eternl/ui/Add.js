import { u as useTranslation } from "./useTranslation.js";
import { u as useNavigation } from "./useNavigation.js";
import { _ as _sfc_main$2 } from "./Page.vue_vue_type_script_setup_true_lang.js";
import { d as defineComponent, o as openBlock, c as createElementBlock, e as createBaseVNode, n as normalizeClass, j as createCommentVNode, t as toDisplayString, b as withModifiers, u as unref, a as createBlock, h as withCtx, q as createVNode } from "./index.js";
import "./useTabId.js";
import "./_plugin-vue_export-helper.js";
import "./GridSpace.js";
import "./NetworkId.js";
const _hoisted_1$1 = ["type", "form", "disabled"];
const _hoisted_2$1 = {
  key: 1,
  class: "flex-1 flex flex-col flex-nowrap",
  style: { "text-align": "inherit" }
};
const _hoisted_3$1 = {
  key: 0,
  class: "cc-text-sm cc-text-normal mt-0.5 sm:mt-1"
};
const _sfc_main$1 = /* @__PURE__ */ defineComponent({
  __name: "GridButtonLarge",
  props: {
    label: { type: String },
    caption: { type: String },
    icon: { type: String },
    type: { type: String, required: false, default: "button" },
    form: { type: String, required: false, default: "" },
    link: { type: Function, default: null },
    disabled: { type: Boolean, default: false }
  },
  setup(__props) {
    const { c } = useTranslation();
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", {
        class: normalizeClass(["relative group col-span-12 min-h-20 lg:min-h-32 lg:col-span-6 cc-rounded cc-shadow cc-text-semi-bold cc-text-semi-bold flex w-full h-full cc-text-sz border-l-4 border-t border-b cc-bg-white-0", unref(c)("hover-large") + " " + (__props.disabled ? "cc-btn-disabled" : "cursor-pointer")])
      }, [
        createBaseVNode("button", {
          onClick: _cache[0] || (_cache[0] = withModifiers(($event) => {
            var _a;
            return (_a = __props.link) == null ? void 0 : _a.call(__props);
          }, ["stop"])),
          class: "focus:outline-none flex-1 flex flex-row flex-nowrap items-center space-x-2 cc-p",
          type: __props.type,
          form: __props.form,
          disabled: __props.disabled,
          style: { "text-align": "inherit" }
        }, [
          __props.icon ? (openBlock(), createElementBlock("i", {
            key: 0,
            class: normalizeClass(["text-3xl w-12 sm:w-16 text-center", __props.icon])
          }, null, 2)) : createCommentVNode("", true),
          __props.label ? (openBlock(), createElementBlock("span", _hoisted_2$1, [
            createBaseVNode("span", null, toDisplayString(__props.label), 1),
            __props.caption ? (openBlock(), createElementBlock("span", _hoisted_3$1, toDisplayString(__props.caption), 1)) : createCommentVNode("", true)
          ])) : createCommentVNode("", true)
        ], 8, _hoisted_1$1)
      ], 2);
    };
  }
});
const _hoisted_1 = { class: "min-h-16 sm:min-h-20 w-full max-w-full p-3 text-center flex flex-col flex-nowrap justify-center items-center border-t border-b mb-px cc-text-sz cc-bg-white-0" };
const _hoisted_2 = { class: "cc-text-semi-bold" };
const _hoisted_3 = { class: "" };
const _hoisted_4 = { class: "col-span-12 grid grid-cols-12 gap-2 lg:px-16 xl:px-24" };
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "Add",
  setup(__props) {
    const { it } = useTranslation();
    const { gotoPage } = useNavigation();
    return (_ctx, _cache) => {
      return openBlock(), createBlock(_sfc_main$2, null, {
        header: withCtx(() => [
          createBaseVNode("div", _hoisted_1, [
            createBaseVNode("span", _hoisted_2, toDisplayString(unref(it)("wallet.add.headline")), 1),
            createBaseVNode("span", _hoisted_3, toDisplayString(unref(it)("wallet.add.caption")), 1)
          ])
        ]),
        default: withCtx(() => [
          createBaseVNode("div", _hoisted_4, [
            createVNode(_sfc_main$1, {
              label: unref(it)("wallet.add.button.create.label"),
              caption: unref(it)("wallet.add.button.create.caption"),
              icon: unref(it)("wallet.add.button.create.icon"),
              link: () => {
                unref(gotoPage)("WalletCreate");
              }
            }, null, 8, ["label", "caption", "icon", "link"]),
            createVNode(_sfc_main$1, {
              label: unref(it)("wallet.add.button.restore.label"),
              caption: unref(it)("wallet.add.button.restore.caption"),
              icon: unref(it)("wallet.add.button.restore.icon"),
              link: () => {
                unref(gotoPage)("WalletRestore");
              }
            }, null, 8, ["label", "caption", "icon", "link"]),
            createVNode(_sfc_main$1, {
              label: unref(it)("wallet.add.button.pair.label"),
              caption: unref(it)("wallet.add.button.pair.caption"),
              icon: unref(it)("wallet.add.button.pair.icon"),
              link: () => {
                unref(gotoPage)("WalletPair");
              }
            }, null, 8, ["label", "caption", "icon", "link"]),
            createVNode(_sfc_main$1, {
              label: unref(it)("wallet.add.button.import.label"),
              caption: unref(it)("wallet.add.button.import.caption"),
              icon: unref(it)("wallet.add.button.import.icon"),
              link: () => {
                unref(gotoPage)("WalletImport");
              }
            }, null, 8, ["label", "caption", "icon", "link"])
          ])
        ]),
        _: 1
      });
    };
  }
});
export {
  _sfc_main as default
};
