import { d as defineComponent, z as ref, o as openBlock, c as createElementBlock, H as Fragment, I as renderList, b as withModifiers, e as createBaseVNode, j as createCommentVNode, n as normalizeClass, i as createTextVNode, t as toDisplayString } from "./index.js";
const _hoisted_1 = { class: "relative col-span-12 cc-text-sz" };
const _hoisted_2 = ["onClick"];
const _hoisted_3 = ["aria-labelledby", "aria-describedby"];
const _hoisted_4 = ["src"];
const _hoisted_5 = {
  key: 1,
  class: "cc-icon-round-xxs shadow-0 border-2 cc-border-highlight flex justify-center items-center"
};
const _hoisted_6 = { class: "ml-3 flex flex-col justify-start items-start text-left" };
const _hoisted_7 = ["id"];
const _hoisted_8 = {
  key: 0,
  class: "float ml-1.5"
};
const _hoisted_9 = ["id"];
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "GridRadioGroup",
  props: {
    options: { type: Array, required: true, default: [] },
    id: { type: String, required: true },
    name: { type: String, required: true },
    deselectable: { type: Boolean, required: false, default: false },
    defaultId: { type: String, required: false, default: "" }
    // id of default selection
  },
  emits: ["selected"],
  setup(__props, { emit: __emit }) {
    const props = __props;
    const selected = ref(null);
    const emit = __emit;
    const openLink = (target) => {
      window.open(target, void 0, "noopener,noreferrer");
    };
    const onSelect = (option) => {
      var _a;
      selected.value = props.deselectable && option.id === ((_a = selected.value) == null ? void 0 : _a.id) ? null : option;
      emit("selected", selected.value);
    };
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", _hoisted_1, [
        (openBlock(true), createElementBlock(Fragment, null, renderList(__props.options, (option, index) => {
          return openBlock(), createElementBlock("button", {
            tabindex: "0",
            onClick: withModifiers(($event) => onSelect(option), ["stop", "prevent"]),
            class: "relative mb-2 pl-2 flex flex-row flex-nowrap cursor-pointer",
            key: option.id
          }, [
            createBaseVNode("div", {
              class: normalizeClass(["shrink-0 mt-1 cursor-pointer cc-text-highlight border-0 cc-selected flex justify-center items-center", option.icon ? (option.id === __props.defaultId ? "ring-4 cc-bg-select" : "cc-bg-white-dimmed") + " cc-icon-round-sm" : "cc-icon-round-xxs cc-bg-white-dimmed"]),
              "aria-labelledby": "privacy-setting-" + index + "-label",
              "aria-describedby": "privacy-setting-" + index + "-description"
            }, [
              option.icon ? (openBlock(), createElementBlock("img", {
                key: 0,
                class: "w-5 h-5",
                src: option.icon,
                alt: "device logo"
              }, null, 8, _hoisted_4)) : option.id === __props.defaultId ? (openBlock(), createElementBlock("div", _hoisted_5, _cache[1] || (_cache[1] = [
                createBaseVNode("div", { class: "shrink-0 cc-icon-round-xxxs shadow-0 cc-bg-highlight" }, null, -1)
              ]))) : createCommentVNode("", true)
            ], 10, _hoisted_3),
            createBaseVNode("div", _hoisted_6, [
              createBaseVNode("div", {
                id: "privacy-setting-" + index + "-label",
                class: "cc-text-semi-bold flex float-left"
              }, [
                createTextVNode(toDisplayString(option.label) + " ", 1),
                option.id === "keystone" ? (openBlock(), createElementBlock("div", _hoisted_8, _cache[2] || (_cache[2] = [
                  createBaseVNode("div", { class: "cc-badge-yellow" }, [
                    createBaseVNode("span", null, "Shamir not supported")
                  ], -1)
                ]))) : createCommentVNode("", true)
              ], 8, _hoisted_7),
              createBaseVNode("div", {
                id: "privacy-setting-" + index + "-description",
                class: "block"
              }, toDisplayString(option.caption), 9, _hoisted_9),
              createBaseVNode("div", null, [
                option.id === "keystone" ? (openBlock(), createElementBlock("button", {
                  key: 0,
                  onClick: _cache[0] || (_cache[0] = withModifiers(($event) => openLink("https://keyst.one/?rfsn=7717950.1c87691&utm_source=refersion&utm_medium=affiliate&utm_campaign=7717950.1c87691"), ["stop", "prevent"])),
                  class: "flex flex-row flex-nowrap justify-start items-center gap-2 px-4 py-2 mt-2 mb-1 cc-buy-button text-bold cc-rounded"
                }, _cache[3] || (_cache[3] = [
                  createBaseVNode("i", { class: "mdi mdi-cart text-2xl" }, null, -1),
                  createTextVNode(" Buy your Keystone 3 Pro device here! ")
                ]))) : createCommentVNode("", true)
              ])
            ])
          ], 8, _hoisted_2);
        }), 128))
      ]);
    };
  }
});
export {
  _sfc_main as _
};
