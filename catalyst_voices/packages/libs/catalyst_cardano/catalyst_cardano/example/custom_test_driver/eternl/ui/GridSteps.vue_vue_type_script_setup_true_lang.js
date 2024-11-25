import { I as IconCheck } from "./IconCheck.js";
import { d as defineComponent, o as openBlock, c as createElementBlock, e as createBaseVNode, n as normalizeClass, q as createVNode, a as createBlock, t as toDisplayString, H as Fragment, ez as useSlots, f as computed, S as reactive, z as ref, D as watch, I as renderList, j as createCommentVNode, aA as renderSlot } from "./index.js";
const _hoisted_1$2 = {
  class: "absolute inset-0 flex items-center",
  "aria-hidden": "true"
};
const _sfc_main$2 = /* @__PURE__ */ defineComponent({
  __name: "StepsLine",
  props: {
    active: { type: Boolean, default: false }
  },
  setup(__props) {
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", _hoisted_1$2, [
        createBaseVNode("div", {
          class: normalizeClass(["h-0.5 w-full", __props.active ? "cc-bg-highlight" : "cc-bg-inactive"])
        }, null, 2)
      ]);
    };
  }
});
const _hoisted_1$1 = { class: "mt-3 whitespace-nowrap text-xs md:text-sm capitalize" };
const _sfc_main$1 = /* @__PURE__ */ defineComponent({
  __name: "StepsButton",
  props: {
    status: { type: String, default: "upcoming" },
    label: { type: String, default: "" }
  },
  emits: ["back"],
  setup(__props, { emit: __emit }) {
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock(Fragment, null, [
        createVNode(_sfc_main$2, {
          active: __props.status === "complete"
        }, null, 8, ["active"]),
        createBaseVNode("div", {
          class: normalizeClass(["relative w-5 h-5 rounded-full flex items-center justify-center cc-text-medium cc-text-sz", __props.status === "complete" ? "cc-bg-highlight " : "bg-white border-2 " + (__props.status === "current" ? "cc-border-active " : "cc-border-inactive ")])
        }, [
          __props.status === "complete" ? (openBlock(), createBlock(IconCheck, {
            key: 0,
            class: "-mb-1.5 w-5 h-5 text-white",
            "aria-hidden": "true"
          })) : (openBlock(), createElementBlock("span", {
            key: 1,
            class: normalizeClass(["mt-1 h-2 w-2 rounded-full", __props.status === "current" ? "cc-bg-highlight" : "bg-transparent"]),
            "aria-hidden": "true"
          }, null, 2)),
          createBaseVNode("span", _hoisted_1$1, toDisplayString(__props.label), 1)
        ], 2)
      ], 64);
    };
  }
});
const _hoisted_1 = {
  key: 0,
  "aria-label": "Progress",
  class: "col-span-12 inline-flex justify-center mb-3 md:mb-4"
};
const _hoisted_2 = { class: "flex items-center justify-center" };
const _hoisted_3 = {
  key: 1,
  class: "relative col-span-12 grid grid-cols-12 cc-gap"
};
const _hoisted_4 = {
  key: 2,
  class: "relative col-span-12 grid grid-cols-12 cc-gap"
};
const _hoisted_5 = {
  key: 3,
  class: "relative col-span-12 grid grid-cols-12 cc-gap"
};
const _hoisted_6 = {
  key: 4,
  class: "relative col-span-12 grid grid-cols-12 cc-gap"
};
const _hoisted_7 = {
  key: 5,
  class: "relative col-span-12 grid grid-cols-12 cc-gap"
};
const _hoisted_8 = {
  key: 6,
  class: "relative col-span-12 grid grid-cols-12 cc-gap"
};
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "GridSteps",
  props: {
    steps: { type: Array, required: true },
    currentStep: { type: Number, required: true, default: 0 },
    smallCSS: { type: String, required: false, default: "pr-9" },
    showStepper: { type: Boolean, required: false, default: true }
  },
  emits: ["back"],
  setup(__props, { emit: __emit }) {
    const props = __props;
    const slots = useSlots();
    const hasSlotStep0 = computed(() => typeof slots.step0 !== "undefined");
    const hasSlotStep1 = computed(() => typeof slots.step1 !== "undefined");
    const hasSlotStep2 = computed(() => typeof slots.step2 !== "undefined");
    const hasSlotStep3 = computed(() => typeof slots.step3 !== "undefined");
    const hasSlotStep4 = computed(() => typeof slots.step4 !== "undefined");
    const hasSlotStep5 = computed(() => typeof slots.step5 !== "undefined");
    const internalSteps = reactive([]);
    const stepIndex = ref(0);
    let index = 0;
    for (const step of props.steps) {
      if (index === 0 && hasSlotStep0.value) {
        internalSteps.push({ option: step, status: "current" });
      } else if (index === 1 && hasSlotStep1.value) {
        internalSteps.push({ option: step, status: "upcoming" });
      } else if (index === 2 && hasSlotStep2.value) {
        internalSteps.push({ option: step, status: "upcoming" });
      } else if (index === 3 && hasSlotStep3.value) {
        internalSteps.push({ option: step, status: "upcoming" });
      } else if (index === 4 && hasSlotStep4.value) {
        internalSteps.push({ option: step, status: "upcoming" });
      } else if (index === 5 && hasSlotStep5.value) {
        internalSteps.push({ option: step, status: "upcoming" });
      }
      index++;
    }
    watch(() => props.currentStep, () => {
      stepIndex.value = props.currentStep;
      index = 0;
      for (const step of internalSteps) {
        if (index < stepIndex.value) {
          step.status = "complete";
        } else if (index === stepIndex.value) {
          step.status = "current";
        } else {
          step.status = "upcoming";
        }
        index++;
      }
    });
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", {
        class: normalizeClass(["relative col-span-12 grid grid-cols-12 cc-gap cc-text-sz", __props.showStepper ? "mt-3 md:mt-4" : "mt-2"])
      }, [
        __props.showStepper ? (openBlock(), createElementBlock("nav", _hoisted_1, [
          createBaseVNode("ol", _hoisted_2, [
            (openBlock(true), createElementBlock(Fragment, null, renderList(internalSteps, (step, stepIdx) => {
              return openBlock(), createElementBlock("li", {
                key: step.option.id,
                class: normalizeClass(["h-6 flex mb-6 flex-row items-center", [stepIdx !== __props.steps.length - 1 ? __props.smallCSS + " " : "", "relative"]])
              }, [
                createVNode(_sfc_main$1, {
                  status: step.status,
                  label: step.option.label,
                  onBack: _cache[0] || (_cache[0] = ($event) => _ctx.$emit("back"))
                }, null, 8, ["status", "label"])
              ], 2);
            }), 128))
          ])
        ])) : createCommentVNode("", true),
        hasSlotStep0.value && stepIndex.value === 0 ? (openBlock(), createElementBlock("div", _hoisted_3, [
          renderSlot(_ctx.$slots, "step0")
        ])) : createCommentVNode("", true),
        hasSlotStep1.value && stepIndex.value === 1 ? (openBlock(), createElementBlock("div", _hoisted_4, [
          renderSlot(_ctx.$slots, "step1")
        ])) : createCommentVNode("", true),
        hasSlotStep2.value && stepIndex.value === 2 ? (openBlock(), createElementBlock("div", _hoisted_5, [
          renderSlot(_ctx.$slots, "step2")
        ])) : createCommentVNode("", true),
        hasSlotStep3.value && stepIndex.value === 3 ? (openBlock(), createElementBlock("div", _hoisted_6, [
          renderSlot(_ctx.$slots, "step3")
        ])) : createCommentVNode("", true),
        hasSlotStep4.value && stepIndex.value === 4 ? (openBlock(), createElementBlock("div", _hoisted_7, [
          renderSlot(_ctx.$slots, "step4")
        ])) : createCommentVNode("", true),
        hasSlotStep5.value && stepIndex.value === 5 ? (openBlock(), createElementBlock("div", _hoisted_8, [
          renderSlot(_ctx.$slots, "step5")
        ])) : createCommentVNode("", true)
      ], 2);
    };
  }
});
export {
  _sfc_main as _
};
