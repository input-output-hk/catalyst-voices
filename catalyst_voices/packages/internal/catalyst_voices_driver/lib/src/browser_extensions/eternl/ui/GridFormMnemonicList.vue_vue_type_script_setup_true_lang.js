import { d as defineComponent, f as computed, o as openBlock, c as createElementBlock, e as createBaseVNode, t as toDisplayString, H as Fragment, I as renderList, n as normalizeClass, b as withModifiers } from "./index.js";
const _hoisted_1 = { class: "w-full grid grid-cols-12 cc-gap cc-text-sz" };
const _hoisted_2 = { class: "col-span-12 flex flex-col flex-nowrap justify-start items-start cc-px" };
const _hoisted_3 = { class: "capitalize cc-text-bold" };
const _hoisted_4 = { class: "col-span-12 flex flex-row flex-nowrap whitespace-pre-wrap" };
const _hoisted_5 = { class: "w-full py-0 grid grid-cols-2 xs:grid-cols-3 lg:grid-cols-4 xl:grid-cols-5 gap-1.5 xs:gap-2" };
const _hoisted_6 = { class: "w-6 cc-flex-fixed flex items-center justify-end" };
const _hoisted_7 = {
  key: 0,
  class: "group cc-flex-fixed flex items-center justify-start"
};
const _hoisted_8 = ["onClick"];
const _hoisted_9 = {
  key: 1,
  class: "group cc-flex-fixed flex items-center justify-start"
};
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "GridFormMnemonicList",
  props: {
    label: { type: String, default: "" },
    editable: { type: Boolean, default: false },
    mnemonic: { type: Array, required: true }
  },
  emits: ["removeWord"],
  setup(__props, { emit: __emit }) {
    const props = __props;
    const emit = __emit;
    const editIndex = computed(() => {
      return props.mnemonic.indexOf("");
    });
    const removeWord = (index) => {
      props.mnemonic[index] = "";
      emit("removeWord", { index });
    };
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", _hoisted_1, [
        createBaseVNode("div", _hoisted_2, [
          createBaseVNode("label", _hoisted_3, toDisplayString(__props.label), 1)
        ]),
        createBaseVNode("div", _hoisted_4, [
          createBaseVNode("div", _hoisted_5, [
            (openBlock(true), createElementBlock(Fragment, null, renderList(__props.mnemonic, (item, index) => {
              return openBlock(), createElementBlock("div", {
                key: index,
                class: normalizeClass([
                  "flex flex-row flex-nowrap noselect cc-rounded cc-text-bold cc-shadow pl-1 sm:pl-2 py-1 pr-1.5 sm:pr-2 cc-text-sz",
                  (editIndex.value === index ? "cc-list-secondary-edit " : "") + " " + (item.length > 0 || editIndex.value === index ? "cc-list-secondary " : "cc-list-secondary-edit-inactive ")
                ])
              }, [
                createBaseVNode("div", _hoisted_6, toDisplayString(index + 1) + ".", 1),
                createBaseVNode("div", {
                  class: normalizeClass([
                    "ml-1 flex-1 flex items-center justify-start",
                    editIndex.value === index ? "border-b-2 cc-border-highlight" : ""
                  ])
                }, toDisplayString(item), 3),
                __props.editable && item.length > 0 ? (openBlock(), createElementBlock("div", _hoisted_7, [
                  createBaseVNode("i", {
                    class: "text-xl xs:text-2xl mdi mdi-close-circle-outline cursor-pointer",
                    onClick: withModifiers(($event) => removeWord(index), ["stop"])
                  }, null, 8, _hoisted_8)
                ])) : (openBlock(), createElementBlock("div", _hoisted_9, _cache[0] || (_cache[0] = [
                  createBaseVNode("i", { class: "text-xl xs:text-2xl mdi mdi-close-circle-outline opacity-0" }, null, -1)
                ])))
              ], 2);
            }), 128))
          ])
        ])
      ]);
    };
  }
});
export {
  _sfc_main as _
};
