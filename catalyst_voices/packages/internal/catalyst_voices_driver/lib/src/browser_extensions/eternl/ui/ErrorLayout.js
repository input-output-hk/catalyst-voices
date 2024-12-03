import { d as defineComponent, a7 as useQuasar, ct as onErrorCaptured, o as openBlock, a as createBlock, h as withCtx, e as createBaseVNode, t as toDisplayString, u as unref, b as withModifiers, W as usePreloader } from "./index.js";
import { u as useTranslation } from "./useTranslation.js";
import { u as useNavigation } from "./useNavigation.js";
import { _ as _sfc_main$1 } from "./ShallowLayout.vue_vue_type_script_setup_true_lang.js";
import "./NetworkId.js";
import "./useTabId.js";
import "./HeaderLogoAnimation.vue_vue_type_script_setup_true_lang.js";
const _hoisted_1 = { class: "absolute w-full h-full cc-bg-light-1 overflow-y-auto flex flex-col flex-nowrap justify-center items-center" };
const _hoisted_2 = { class: "relative flex-1 py-4 flex justify-center items-center" };
const _hoisted_3 = { class: "mx-auto max-w-7xl px-4 sm:px-8 flex flex-col flex-nowrap space-y-3 sm:space-y-6 justify-center text-center" };
const _hoisted_4 = { class: "cc-text-extra-bold" };
const _hoisted_5 = { class: "block xl:inline leading-8 text-2xl sm:text-4xl md:text-5xl dark:text-cc-gray-light" };
const _hoisted_6 = { class: "block xl:inline leading-7 mt-1 sm:mt-2 text-lg sm:text-3xl md:text-4xl text-green-600 px-4" };
const _hoisted_7 = { class: "max-w-md md:max-w-3xl mx-auto cc-text-sz text-gray-500 sm:text-lg md:text-xl whitespace-pre-wrap" };
const _hoisted_8 = { class: "max-w-md mx-auto sm:flex sm:justify-center md:mt-8" };
const _hoisted_9 = { class: "cc-rounded cc-shadow" };
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "ErrorLayout",
  setup(__props) {
    const { it } = useTranslation();
    const { gotoPage } = useNavigation();
    const { hidePreloader } = usePreloader();
    const $q = useQuasar();
    onErrorCaptured((e, instance, info) => {
      $q.notify({
        type: "negative",
        message: "error: " + ((e == null ? void 0 : e.message) ?? "no error message") + " info: " + info,
        position: "top-left",
        timeout: 2e4
      });
      console.error("Layout: onErrorCaptured", e);
      return true;
    });
    setTimeout(hidePreloader, 500);
    return (_ctx, _cache) => {
      return openBlock(), createBlock(_sfc_main$1, null, {
        default: withCtx(() => [
          createBaseVNode("div", _hoisted_1, [
            createBaseVNode("div", _hoisted_2, [
              createBaseVNode("div", _hoisted_3, [
                createBaseVNode("h1", _hoisted_4, [
                  createBaseVNode("span", _hoisted_5, toDisplayString(unref(it)("error404.headline")), 1),
                  createBaseVNode("span", _hoisted_6, toDisplayString(unref(it)("error404.caption")), 1)
                ]),
                createBaseVNode("p", _hoisted_7, toDisplayString(unref(it)("error404.text")), 1),
                createBaseVNode("div", _hoisted_8, [
                  createBaseVNode("div", _hoisted_9, [
                    createBaseVNode("button", {
                      class: "w-full flex items-center justify-center px-8 py-3 border border-transparent text-base font-medium cc-rounded text-white bg-blue-700 hover:bg-blue-800 md:py-4 md:text-lg md:px-10 dark:bg-cc-dark-800",
                      onClick: _cache[0] || (_cache[0] = withModifiers(($event) => unref(gotoPage)(unref(it)("error404.button.home.link")), ["stop"]))
                    }, toDisplayString(unref(it)("error404.button.home.label")), 1)
                  ])
                ])
              ])
            ])
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
