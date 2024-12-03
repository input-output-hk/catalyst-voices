import { _ as _sfc_main$5 } from "./HeaderLogoAnimation.vue_vue_type_script_setup_true_lang.js";
import { d as defineComponent, o as openBlock, c as createElementBlock, e as createBaseVNode, q as createVNode, u as unref, K as networkId, n as normalizeClass, j as createCommentVNode, t as toDisplayString, aA as renderSlot } from "./index.js";
import { u as useTranslation } from "./useTranslation.js";
const _hoisted_1$4 = { class: "relative w-full h-12 px-1.5 cc-flex-fixed cc-site-max-width mx-auto flex flex-row flex-nowrap justify-start items-center" };
const _hoisted_2$3 = { class: "group shrink flex flex-row flex-nowrap items-start justify-start cc-rounded cc-btn-focus h-3/4 cc-border-reset cc-btn-focus cc-text-semi-bold cc-text-xl text-center whitespace-nowrap" };
const _sfc_main$4 = /* @__PURE__ */ defineComponent({
  __name: "HeaderShallow",
  setup(__props) {
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("header", _hoisted_1$4, [
        createBaseVNode("div", _hoisted_2$3, [
          createVNode(_sfc_main$5)
        ]),
        _cache[0] || (_cache[0] = createBaseVNode("div", { class: "grow shrink" }, null, -1)),
        _cache[1] || (_cache[1] = createBaseVNode("div", { class: "w-10 h-10 flex flex-row flex-nowrap justify-center items-center" }, null, -1))
      ]);
    };
  }
});
const _hoisted_1$3 = {
  class: "relative w-full cc-flex-fixed mb-1.5 cc-site-max-width mx-auto inline-block",
  id: "cc-epoch-container"
};
const _hoisted_2$2 = { class: "relative w-full px-1 py-0.5 overflow-hidden cc-site-max-width mx-auto cc-rounded-la cc-shadow cc-text-medium cc-text-xs cc-text-color-light text-center cc-online" };
const _sfc_main$3 = /* @__PURE__ */ defineComponent({
  __name: "EpochProgressShallow",
  setup(__props) {
    const { c, it } = useTranslation();
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", _hoisted_1$3, [
        createBaseVNode("div", _hoisted_2$2, [
          !unref(networkId) ? (openBlock(), createElementBlock("div", {
            key: 0,
            class: normalizeClass(["absolute cc-rounded-la top-0 left-0 h-full cc-shadow", unref(c)("gradient")]),
            style: "width: 100%"
          }, null, 2)) : createCommentVNode("", true),
          createBaseVNode("div", {
            class: normalizeClass(["absolute cc-rounded-la top-0 left-0 h-full opacity-100 cc-shadow", unref(c)("gradient")]),
            style: "width: 100%"
          }, null, 2),
          _cache[0] || (_cache[0] = createBaseVNode("div", { class: "relative whitespace-nowrap capitalize cc-text-semi-bold mt-px -mb-px" }, [
            createBaseVNode("span", null, " ")
          ], -1))
        ])
      ]);
    };
  }
});
const _hoisted_1$2 = {
  key: 0,
  class: "absolute top-0 right-0 pl-2 pr-1.5 py-0.5 whitespace-nowrap cc-rounded-la-r cc-text-medium cc-text-xs cc-online bg-purple-700 dark:bg-purple-900"
};
const _hoisted_2$1 = { class: "capitalize mr-1" };
const _sfc_main$2 = /* @__PURE__ */ defineComponent({
  __name: "NetworkBadgeShallow",
  setup(__props) {
    const { it } = useTranslation();
    return (_ctx, _cache) => {
      return unref(networkId) ? (openBlock(), createElementBlock("div", _hoisted_1$2, [
        createBaseVNode("span", _hoisted_2$1, toDisplayString(unref(it)("common.network." + unref(networkId) + ".badge")), 1),
        _cache[0] || (_cache[0] = createBaseVNode("i", { class: "text-xs -mt-0.5 mdi mdi-check-circle text-purple-400 dark:text-purple-600" }, null, -1))
      ])) : createCommentVNode("", true);
    };
  }
});
const _hoisted_1$1 = {
  class: "relative w-full cc-flex-fixed cc-layout-mt cc-site-max-width mx-auto mb-1 sm:mb-2",
  id: "cc-footer-container"
};
const _sfc_main$1 = /* @__PURE__ */ defineComponent({
  __name: "FooterShallow",
  setup(__props) {
    const { c } = useTranslation();
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("footer", _hoisted_1$1, [
        createBaseVNode("div", {
          class: normalizeClass(["relative w-full py-0.5 px-1.5 overflow-hidden cc-rounded-la cc-shadow cc-online cc-text-medium cc-text-xs flex sm:justify-center items-center", unref(c)("gradient")])
        }, [
          _cache[0] || (_cache[0] = createBaseVNode("div", { class: "whitespace-nowrap text-center flex flex-row flex-nowrap space-x-1.5" }, " ", -1)),
          createVNode(_sfc_main$2)
        ], 2)
      ]);
    };
  }
});
const _hoisted_1 = {
  class: "shallow-layout relative w-full h-full cc-layout-px cc-layout-py cc-text-color flex flex-col flex-nowrap",
  id: "cc-layout-container"
};
const _hoisted_2 = {
  class: "relative flex-grow w-full flex-1 cc-site-max-width mx-auto flex flex-col flex-nowrap",
  id: "cc-main-container"
};
const _hoisted_3 = {
  class: "relative flex-1 flex-grow-1 h-full overflow-hidden cc-rounded-la cc-shadow flex flex-row flex-nowrap",
  style: { "min-height": "222px" }
};
const _hoisted_4 = { class: "relative flex-1 w-full h-full" };
const _hoisted_5 = { class: "relative w-full h-full cc-rounded-la flex flex-row flex-nowrap cc-bg-light-1" };
const _hoisted_6 = { class: "shallow-layout-main relative h-full flex-1 overflow-hidden focus:outline-none flex flex-col flex-nowrap" };
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "ShallowLayout",
  setup(__props) {
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", _hoisted_1, [
        _cache[0] || (_cache[0] = createBaseVNode("div", {
          class: "fixed inset-0 bg-gradient-to-r from-slate-200 to-stone-200 dark:from-slate-900 dark:to-stone-900",
          id: "cc-background-iframe-container"
        }, null, -1)),
        createVNode(_sfc_main$4),
        createVNode(_sfc_main$3),
        createBaseVNode("div", _hoisted_2, [
          createBaseVNode("div", _hoisted_3, [
            createBaseVNode("div", _hoisted_4, [
              createBaseVNode("div", _hoisted_5, [
                createBaseVNode("main", _hoisted_6, [
                  renderSlot(_ctx.$slots, "default")
                ])
              ])
            ])
          ])
        ]),
        createVNode(_sfc_main$1)
      ]);
    };
  }
});
export {
  _sfc_main as _
};
