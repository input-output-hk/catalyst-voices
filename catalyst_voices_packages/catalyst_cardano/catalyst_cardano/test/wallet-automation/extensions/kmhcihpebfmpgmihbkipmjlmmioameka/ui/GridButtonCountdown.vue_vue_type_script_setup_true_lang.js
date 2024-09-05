import { _ as _sfc_main$1 } from "./GridButtonPrimary.vue_vue_type_script_setup_true_lang.js";
import { d as defineComponent, z as ref, o as openBlock, a as createBlock, u as unref } from "./index.js";
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "GridButtonCountdown",
  props: {
    duration: { type: Number, default: 1 },
    label: { type: String },
    caption: { type: String },
    icon: { type: String },
    type: { type: String, required: false, default: "button" },
    form: { type: String, required: false, default: "" },
    link: { type: Function, default: null },
    capitalize: { type: Boolean, default: true },
    disabled: { type: Boolean, default: false }
  },
  setup(__props) {
    const props = __props;
    const countDownFinished = ref(false);
    let secondsLeft = ref(10);
    secondsLeft.value = props.duration;
    const id = setInterval(() => {
      secondsLeft.value -= 1;
      if (secondsLeft.value < 1) {
        secondsLeft.value = 0;
        countDownFinished.value = true;
        clearInterval(id);
      }
    }, 1e3);
    return (_ctx, _cache) => {
      return openBlock(), createBlock(_sfc_main$1, {
        label: __props.label + (unref(secondsLeft) > 0 ? " (" + unref(secondsLeft) + ")" : ""),
        caption: __props.caption,
        icon: __props.icon,
        link: __props.link,
        type: __props.type,
        form: __props.form,
        capitalize: __props.capitalize,
        disabled: __props.disabled || !countDownFinished.value
      }, null, 8, ["label", "caption", "icon", "link", "type", "form", "capitalize", "disabled"]);
    };
  }
});
export {
  _sfc_main as _
};
