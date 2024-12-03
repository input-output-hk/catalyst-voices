import { d as defineComponent, S as reactive, bN as isIosApp, r as resolveComponent, o as openBlock, c as createElementBlock, e as createBaseVNode, q as createVNode, h as withCtx, H as Fragment, I as renderList } from "./index.js";
import { u as useTranslation } from "./useTranslation.js";
import { _ as _sfc_main$4 } from "./Page.vue_vue_type_script_setup_true_lang.js";
import { a as _sfc_main$2, _ as _sfc_main$3 } from "./GridHeadline.vue_vue_type_script_setup_true_lang.js";
import { G as GridSpace } from "./GridSpace.js";
import { _ as _sfc_main$1 } from "./GridButtonPrimary.vue_vue_type_script_setup_true_lang.js";
import { _ as _export_sfc } from "./_plugin-vue_export-helper.js";
import "./NetworkId.js";
import "./GridButton.vue_vue_type_script_setup_true_lang.js";
import "./Tooltip.vue_vue_type_script_setup_true_lang.js";
const _sfc_main = defineComponent({
  name: "FAQ",
  components: { GridButtonPrimary: _sfc_main$1, GridText: _sfc_main$2, GridSpace, GridHeadline: _sfc_main$3, Page: _sfc_main$4 },
  setup() {
    const { t, itd } = useTranslation();
    const postList = reactive([]);
    for (let i = 0; i < 100; i++) {
      if (isIosApp() && i === 4) continue;
      const q = itd("faq.post.faq" + i + ".question");
      if (q && !q.startsWith("faq")) {
        postList.push({
          question: q,
          answer: itd("faq.post.faq" + i + ".answer")
        });
      } else {
        break;
      }
    }
    return {
      t,
      itd,
      postList
    };
  }
});
const _hoisted_1 = { class: "relative w-full h-full cc-rounded flex flex-row-reverse flex-nowrap dark:text-cc-gray-dark" };
const _hoisted_2 = { class: "relative h-full flex-1 overflow-hidden focus:outline-none flex flex-col flex-nowrap" };
const _hoisted_3 = { class: "cc-page-wallet cc-text-sz pt-4 sm:pt-6 md:pt-14 px-4 sm:px-8" };
const _hoisted_4 = { class: "col-span-12 grid gap-2 lg:grid-cols-2 lg:gap-x-5 lg:gap-y-2" };
const _hoisted_5 = { class: "mt-1 sm:mt-2 block" };
const _hoisted_6 = ["innerHTML"];
const _hoisted_7 = ["innerHTML"];
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  const _component_GridHeadline = resolveComponent("GridHeadline");
  const _component_GridSpace = resolveComponent("GridSpace");
  const _component_Page = resolveComponent("Page");
  return openBlock(), createElementBlock("div", _hoisted_1, [
    createBaseVNode("main", _hoisted_2, [
      createVNode(_component_Page, {
        containerCSS: "",
        "align-top": ""
      }, {
        default: withCtx(() => [
          createBaseVNode("div", _hoisted_3, [
            createVNode(_component_GridHeadline, {
              label: _ctx.itd("faq.headline"),
              class: "cc-text-2xl sm:mt-4"
            }, null, 8, ["label"]),
            createVNode(_component_GridSpace, { hr: "" }),
            createBaseVNode("div", _hoisted_4, [
              (openBlock(true), createElementBlock(Fragment, null, renderList(_ctx.postList, (post, index) => {
                return openBlock(), createElementBlock("div", {
                  key: "faq." + index,
                  class: "flex flex-col flex-nowrap justify-between"
                }, [
                  createBaseVNode("div", _hoisted_5, [
                    createBaseVNode("p", {
                      class: "cc-text-md font-semibold",
                      innerHTML: post.question
                    }, null, 8, _hoisted_6),
                    createBaseVNode("p", {
                      class: "mt-2 sm:mt-3 cc-text-md",
                      innerHTML: post.answer
                    }, null, 8, _hoisted_7)
                  ]),
                  createVNode(_component_GridSpace, {
                    hr: "",
                    class: "my-1 sm:my-4"
                  })
                ]);
              }), 128))
            ])
          ])
        ]),
        _: 1
      })
    ])
  ]);
}
const FAQ = /* @__PURE__ */ _export_sfc(_sfc_main, [["render", _sfc_render], ["__scopeId", "data-v-65a6d7a3"]]);
export {
  FAQ as default
};
