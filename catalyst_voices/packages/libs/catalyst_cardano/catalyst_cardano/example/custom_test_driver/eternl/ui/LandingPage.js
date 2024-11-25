import { d as defineComponent, o as openBlock, c as createElementBlock, e as createBaseVNode, t as toDisplayString, u as unref, b as withModifiers, bN as isIosApp, i as createTextVNode, j as createCommentVNode, n as normalizeClass } from "./index.js";
import { u as useNavigation } from "./useNavigation.js";
import { u as useTranslation } from "./useTranslation.js";
import { u as useMainMenuOpen } from "./useMainMenuOpen.js";
import "./NetworkId.js";
import "./useTabId.js";
const _hoisted_1 = { class: "relative py-4 flex" };
const _hoisted_2 = { class: "mx-auto max-w-7xl px-4 sm:px-8 flex flex-col flex-nowrap space-y-3 sm:space-y-6 justify-center text-center" };
const _hoisted_3 = { class: "cc-text-extra-bold" };
const _hoisted_4 = { class: "block xl:inline leading-8 text-2xl sm:text-4xl md:text-5xl" };
const _hoisted_5 = { class: "block xl:inline leading-7 mt-1 sm:mt-2 text-lg sm:text-3xl md:text-4xl px-4 cc-text-green" };
const _hoisted_6 = { class: "max-w-md md:max-w-3xl mx-auto cc-text-sz sm:text-lg md:text-xl whitespace-pre-wrap" };
const _hoisted_7 = { class: "max-w-md mx-auto sm:flex sm:justify-center md:mt-8" };
const _hoisted_8 = { class: "rounded-md cc-shadow" };
const _hoisted_9 = { class: "mt-3 cc-rounded cc-shadow sm:mt-0 sm:ml-3" };
const _hoisted_10 = {
  key: 0,
  class: "mx-auto flex flex-col flex-nowrap sm:justify-center md:mt-8"
};
const _hoisted_11 = { class: "cc-text-extra-bold cc-text-green" };
const _hoisted_12 = { class: "block xl:inline leading-7 mt-1 sm:mt-2 text-md sm:text-xl md:text-2xl px-4" };
const _hoisted_13 = { class: "cc-text-sz md:text-xl" };
const _hoisted_14 = {
  key: 1,
  class: "mx-auto flex flex-col flex-nowrap sm:justify-center md:mt-8"
};
const _hoisted_15 = { class: "cc-text-extra-bold cc-text-green" };
const _hoisted_16 = { class: "block xl:inline leading-7 mt-1 sm:mt-2 text-md sm:text-xl md:text-2xl px-4" };
const _hoisted_17 = { class: "cc-text-sz md:text-xl" };
const _hoisted_18 = {
  key: 2,
  class: "mx-auto flex flex-col flex-nowrap sm:justify-center md:mt-8"
};
const _hoisted_19 = { class: "cc-text-extra-bold cc-text-green" };
const _hoisted_20 = { class: "block xl:inline leading-7 mt-1 sm:mt-2 text-md sm:text-xl md:text-2xl px-4" };
const _hoisted_21 = { class: "cc-text-sz md:text-xl" };
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "LandingPage",
  setup(__props) {
    const { it } = useTranslation();
    const { gotoPage } = useNavigation();
    const { openMainMenu } = useMainMenuOpen();
    function openPage(page) {
      openMainMenu();
      gotoPage(page);
    }
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", {
        class: normalizeClass(["absolute w-full h-full bg-img overflow-y-auto flex flex-col flex-nowrap items-center", unref(isIosApp)() ? "justify-center " : "justify-start md:justify-center "])
      }, [
        createBaseVNode("div", _hoisted_1, [
          createBaseVNode("div", _hoisted_2, [
            createBaseVNode("h1", _hoisted_3, [
              createBaseVNode("span", _hoisted_4, toDisplayString(unref(it)("landingpage.headline")), 1),
              createBaseVNode("span", _hoisted_5, toDisplayString(unref(it)("landingpage.caption")), 1)
            ]),
            createBaseVNode("p", _hoisted_6, toDisplayString(unref(it)("landingpage.text")), 1),
            createBaseVNode("div", _hoisted_7, [
              createBaseVNode("div", _hoisted_8, [
                createBaseVNode("button", {
                  class: "w-full flex items-center justify-center px-8 py-3 cc-btn-primary text-base font-medium cc-rounded md:py-4 md:text-lg md:px-10",
                  onClick: _cache[0] || (_cache[0] = withModifiers(($event) => openPage("Wallets"), ["stop"]))
                }, toDisplayString(unref(it)("landingpage.button.wallets.label")), 1)
              ]),
              createBaseVNode("div", _hoisted_9, [
                createBaseVNode("button", {
                  class: "w-full flex items-center justify-center px-8 py-3 cc-btn-secondary border border-transparent text-base font-medium cc-rounded md:py-4 md:text-lg md:px-10",
                  onClick: _cache[1] || (_cache[1] = withModifiers(($event) => unref(gotoPage)("FAQ"), ["stop"]))
                }, toDisplayString(unref(it)("landingpage.button.learnmore.label")), 1)
              ])
            ]),
            !unref(isIosApp)() ? (openBlock(), createElementBlock("div", _hoisted_10, [
              createBaseVNode("h1", _hoisted_11, [
                createBaseVNode("span", _hoisted_12, toDisplayString(unref(it)("landingpage.extensions.headline")), 1)
              ]),
              createBaseVNode("span", _hoisted_13, [
                createTextVNode(toDisplayString(unref(it)("landingpage.extensions.visit")), 1),
                _cache[2] || (_cache[2] = createBaseVNode("br", null, null, -1)),
                _cache[3] || (_cache[3] = createBaseVNode("a", {
                  href: "https://chrome.google.com/webstore/detail/kmhcihpebfmpgmihbkipmjlmmioameka",
                  target: "_blank",
                  rel: "noopener noreferrer",
                  class: "cc-text-highlight"
                }, [
                  createBaseVNode("strong", null, "Chrome Web Store")
                ], -1))
              ])
            ])) : createCommentVNode("", true),
            unref(isIosApp)() ? (openBlock(), createElementBlock("div", _hoisted_14, [
              createBaseVNode("h1", _hoisted_15, [
                createBaseVNode("span", _hoisted_16, toDisplayString(unref(it)("landingpage.ios.headline")), 1)
              ]),
              createBaseVNode("span", _hoisted_17, [
                createTextVNode(toDisplayString(unref(it)("landingpage.ios.visit")), 1),
                _cache[4] || (_cache[4] = createBaseVNode("br", null, null, -1)),
                _cache[5] || (_cache[5] = createBaseVNode("a", {
                  href: "https://eternl.io",
                  target: "_blank",
                  rel: "noopener noreferrer",
                  class: "cc-text-highlight"
                }, [
                  createBaseVNode("strong", null, "eternl.io")
                ], -1))
              ])
            ])) : createCommentVNode("", true),
            !unref(isIosApp)() ? (openBlock(), createElementBlock("div", _hoisted_18, [
              createBaseVNode("h1", _hoisted_19, [
                createBaseVNode("span", _hoisted_20, toDisplayString(unref(it)("landingpage.mobile.headline")), 1)
              ]),
              createBaseVNode("span", _hoisted_21, [
                createTextVNode(toDisplayString(unref(it)("landingpage.mobile.visit")), 1),
                _cache[6] || (_cache[6] = createBaseVNode("br", null, null, -1)),
                _cache[7] || (_cache[7] = createBaseVNode("a", {
                  href: "https://apps.apple.com/de/app/ccvault-io/id1603854385",
                  target: "_blank",
                  rel: "noopener noreferrer",
                  class: "cc-text-highlight"
                }, [
                  createBaseVNode("strong", null, "App Store (iOS)")
                ], -1)),
                _cache[8] || (_cache[8] = createTextVNode("  ")),
                _cache[9] || (_cache[9] = createBaseVNode("a", {
                  href: "https://play.google.com/store/apps/details?id=io.ccvault.v1.main",
                  target: "_blank",
                  rel: "noopener noreferrer",
                  class: "cc-text-highlight"
                }, [
                  createBaseVNode("strong", null, "Play Store (Android)")
                ], -1))
              ])
            ])) : createCommentVNode("", true)
          ])
        ])
      ], 2);
    };
  }
});
export {
  _sfc_main as default
};
