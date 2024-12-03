import { d as defineComponent, aV as useRoute, ez as useSlots, f as computed, S as reactive, z as ref, D as watch, w as watchEffect, C as onMounted, o as openBlock, c as createElementBlock, aA as renderSlot, j as createCommentVNode, e as createBaseVNode, H as Fragment, I as renderList, n as normalizeClass, a as createBlock, i as createTextVNode, t as toDisplayString, h as withCtx } from "./index.js";
import { u as useTabId } from "./useTabId.js";
import { G as GridSpace } from "./GridSpace.js";
import { _ as _sfc_main$1 } from "./Tooltip.vue_vue_type_script_setup_true_lang.js";
const _hoisted_1 = { class: "gridtabs col-span-12 grid grid-cols-12 cc-gap cc-text-sz" };
const _hoisted_2 = { class: "flex flex-row flex-nowrap cc-space-x-small" };
const _hoisted_3 = ["onClick"];
const _hoisted_4 = {
  key: 2,
  class: "tab0 relative col-span-12 grid grid-cols-12 cc-gap"
};
const _hoisted_5 = {
  key: 3,
  class: "tab1 relative col-span-12 grid grid-cols-12 cc-gap"
};
const _hoisted_6 = {
  key: 4,
  class: "tab2 relative col-span-12 grid grid-cols-12 cc-gap"
};
const _hoisted_7 = {
  key: 5,
  class: "tab3 relative col-span-12 grid grid-cols-12 cc-gap"
};
const _hoisted_8 = {
  key: 6,
  class: "tab4 relative col-span-12 grid grid-cols-12 cc-gap"
};
const _hoisted_9 = {
  key: 7,
  class: "tab5 relative col-span-12 grid grid-cols-12 cc-gap"
};
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "GridTabs",
  props: {
    tabs: { type: Array, required: true },
    absHeaderTabs: { type: Array, required: false, default: [] },
    index: { type: Number, required: false, default: 0 },
    divider: { type: Boolean, required: false, default: true },
    hideTabsOnMobile: { type: Boolean, required: false, default: false },
    resetOnMount: { type: Boolean, required: false, default: false },
    buttonCss: { type: String, required: false, default: "py-1.5 sm:py-2 sm:text-sm" },
    navCss: { type: String, required: false, default: "-mt-1 sm:-mt-2 lg:-mt-3" }
  },
  emits: ["selection"],
  setup(__props, { emit: __emit }) {
    const props = __props;
    const emit = __emit;
    const route = useRoute();
    const slots = useSlots();
    const { tabId, updateTabId } = useTabId();
    const hasSlotTab0 = computed(() => typeof slots["tab0"] !== "undefined");
    const hasSlotTab1 = computed(() => typeof slots["tab1"] !== "undefined");
    const hasSlotTab2 = computed(() => typeof slots["tab2"] !== "undefined");
    const hasSlotTab3 = computed(() => typeof slots["tab3"] !== "undefined");
    const hasSlotTab4 = computed(() => typeof slots["tab4"] !== "undefined");
    const hasSlotTab5 = computed(() => typeof slots["tab5"] !== "undefined");
    const internalTabs = reactive([]);
    const startTabIndex = props.index ? props.index : props.tabs.findIndex((t) => t.id === tabId.value);
    const tabIndex = ref(startTabIndex < 0 ? 0 : startTabIndex);
    const hideTabsOnMobile = ref(props.hideTabsOnMobile);
    function onClickedTabButton(index) {
      if (index !== tabIndex.value) {
        tabIndex.value = index;
        emit("selection", index);
        if (index < props.tabs.length) {
          updateTabId(props.tabs[index].id, route.name);
        }
      }
    }
    watch(() => props.index, (newIndex) => {
      tabIndex.value = props.index;
    });
    const addTabs = () => {
      internalTabs.splice(0);
      for (const tab of props.tabs) {
        if (tab.index === 0 && !tab.hidden && hasSlotTab0.value) {
          internalTabs.push(tab);
        } else if (tab.index === 1 && !tab.hidden && hasSlotTab1.value) {
          internalTabs.push(tab);
        } else if (tab.index === 2 && !tab.hidden && hasSlotTab2.value) {
          internalTabs.push(tab);
        } else if (tab.index === 3 && !tab.hidden && hasSlotTab3.value) {
          internalTabs.push(tab);
        } else if (tab.index === 4 && !tab.hidden && hasSlotTab4.value) {
          internalTabs.push(tab);
        } else if (tab.index === 5 && !tab.hidden && hasSlotTab5.value) {
          internalTabs.push(tab);
        }
      }
    };
    addTabs();
    watch(() => props.tabs, () => {
      addTabs();
    }, { deep: true });
    watchEffect(() => {
      if (tabId.value && !props.resetOnMount) {
        const tmpIndex = props.tabs.findIndex((t) => t.id === tabId.value);
        if (tmpIndex >= 0) {
          tabIndex.value = tmpIndex;
        }
      }
    });
    onMounted(() => {
      if (props.resetOnMount) {
        tabIndex.value = 0;
      }
    });
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", _hoisted_1, [
        __props.absHeaderTabs.includes(tabIndex.value) ? renderSlot(_ctx.$slots, "absHeader", { key: 0 }) : createCommentVNode("", true),
        createBaseVNode("nav", {
          "aria-label": "Progress",
          class: normalizeClass(["col-span-12 justify-center", [hideTabsOnMobile.value ? "cc-none sm:inline-flex test" : "inline-flex", __props.navCss]])
        }, [
          createBaseVNode("div", _hoisted_2, [
            (openBlock(true), createElementBlock(Fragment, null, renderList(internalTabs, (tab) => {
              return openBlock(), createElementBlock("button", {
                type: "button",
                class: normalizeClass(["relative cc-rounded items-center px-2 sm:px-3 sm:px-4 focus:z-10 text-xs", (tab.index === tabIndex.value ? "cc-tabs-button-active" : "cc-tabs-button") + " " + __props.buttonCss]),
                key: "tab" + tab.index,
                onClick: ($event) => onClickedTabButton(tab.index)
              }, [
                createTextVNode(toDisplayString(tab.label) + " ", 1),
                tab.hover ? (openBlock(), createBlock(_sfc_main$1, {
                  key: 0,
                  "tooltip-c-s-s": "whitespace-nowrap",
                  anchor: "bottom middle",
                  "transition-show": "scale",
                  "transition-hide": "scale"
                }, {
                  default: withCtx(() => [
                    createTextVNode(toDisplayString(tab.hover), 1)
                  ]),
                  _: 2
                }, 1024)) : createCommentVNode("", true)
              ], 10, _hoisted_3);
            }), 128))
          ])
        ], 2),
        __props.divider ? (openBlock(), createBlock(GridSpace, {
          key: 1,
          hr: ""
        })) : createCommentVNode("", true),
        hasSlotTab0.value && tabIndex.value === 0 ? (openBlock(), createElementBlock("div", _hoisted_4, [
          renderSlot(_ctx.$slots, "tab0", { tabIndex: tabIndex.value })
        ])) : createCommentVNode("", true),
        hasSlotTab1.value && tabIndex.value === 1 ? (openBlock(), createElementBlock("div", _hoisted_5, [
          renderSlot(_ctx.$slots, "tab1", { tabIndex: tabIndex.value })
        ])) : createCommentVNode("", true),
        hasSlotTab2.value && tabIndex.value === 2 ? (openBlock(), createElementBlock("div", _hoisted_6, [
          renderSlot(_ctx.$slots, "tab2", { tabIndex: tabIndex.value })
        ])) : createCommentVNode("", true),
        hasSlotTab3.value && tabIndex.value === 3 ? (openBlock(), createElementBlock("div", _hoisted_7, [
          renderSlot(_ctx.$slots, "tab3", { tabIndex: tabIndex.value })
        ])) : createCommentVNode("", true),
        hasSlotTab4.value && tabIndex.value === 4 ? (openBlock(), createElementBlock("div", _hoisted_8, [
          renderSlot(_ctx.$slots, "tab4", { tabIndex: tabIndex.value })
        ])) : createCommentVNode("", true),
        hasSlotTab5.value && tabIndex.value === 5 ? (openBlock(), createElementBlock("div", _hoisted_9, [
          renderSlot(_ctx.$slots, "tab5", { tabIndex: tabIndex.value })
        ])) : createCommentVNode("", true)
      ]);
    };
  }
});
export {
  _sfc_main as _
};
