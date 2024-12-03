import { u as useMainMenuOpen } from "./useMainMenuOpen.js";
import { u as useTranslation } from "./useTranslation.js";
import { d as defineComponent, o as openBlock, c as createElementBlock, e as createBaseVNode, t as toDisplayString, u as unref } from "./index.js";
import "./NetworkId.js";
const _hoisted_1 = { class: "relative flex-1 flex justify-center items-center" };
const _hoisted_2 = { class: "flex flex-col flex-nowrap justify-center items-center cc-text-color-caption" };
const _hoisted_3 = { class: "text-2xl text-center" };
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "List",
  setup(__props) {
    const { t } = useTranslation();
    const {
      toggleMainMenu,
      isMainMenuOpen
    } = useMainMenuOpen();
    if (!isMainMenuOpen.value) {
      toggleMainMenu();
    }
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", _hoisted_1, [
        createBaseVNode("div", _hoisted_2, [
          _cache[0] || (_cache[0] = createBaseVNode("i", { class: "mdi mdi-wallet text-8xl sm:text-9xl" }, null, -1)),
          createBaseVNode("span", _hoisted_3, toDisplayString(unref(t)("wallet.list.choose")), 1)
        ])
      ]);
    };
  }
});
export {
  _sfc_main as default
};
