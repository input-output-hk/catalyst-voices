import { d as defineComponent, a7 as useQuasar, z as ref, f as computed, jQ as inject, S as reactive, D as watch, ct as onErrorCaptured, o as openBlock, c as createElementBlock, n as normalizeClass, j as createCommentVNode, t as toDisplayString, a as createBlock, b as withModifiers } from "./index.js";
import { _ as _sfc_main$1 } from "./Tooltip.vue_vue_type_script_setup_true_lang.js";
import { c as copyToClipboard } from "./Clipboard.js";
const _hoisted_1 = ["innerHTML"];
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "CopyToClipboard",
  props: {
    label: { type: String, required: false, default: "" },
    labelHover: { type: String, required: false, default: "" },
    labelCSS: { type: String, required: false, default: "" },
    copyText: { type: String, required: false, default: "" },
    copyIcon: { type: String, required: false, default: "mdi mdi-checkbox-multiple-blank-outline" },
    copyIconCheck: { type: String, required: false, default: "mdi mdi-checkbox-multiple-marked-outline" },
    notificationText: { type: String, required: false, default: "Copied: " },
    showCopiedContent: { type: Boolean, required: false, default: true },
    iconRight: { type: Boolean, required: false, default: false },
    highlight: { type: Boolean, required: false, default: false }
  },
  setup(__props) {
    const props = __props;
    const $q = useQuasar();
    const icon = ref(props.copyIcon);
    const htmlLabel = ref(props.label);
    const hasLabel = computed(() => props.label && !props.highlight || props.highlight && htmlLabel.value);
    let searchTerm = ref("");
    if (inject("searchTerm", null) !== null) {
      searchTerm = reactive(inject("searchTerm"));
    }
    const highlightText = (label) => {
      if (searchTerm.value === "") {
        return label;
      }
      return (label == null ? void 0 : label.replace(new RegExp(searchTerm.value.toString(), "gi"), (match) => {
        return '<span class="bg-yellow">' + match + "</span>";
      })) ?? label;
    };
    const doHighlight = () => {
      if (props.highlight && searchTerm.value.length > 0) {
        htmlLabel.value = highlightText(props.label);
      } else {
        htmlLabel.value = props.label;
      }
    };
    watch(searchTerm, () => {
      doHighlight();
    });
    doHighlight();
    onErrorCaptured((e, instance, info) => {
      $q.notify({
        type: "negative",
        message: "error: " + ((e == null ? void 0 : e.message) ?? "no error message") + " info: " + info,
        position: "top-left",
        timeout: 1e4
      });
      console.error("CopyToClipboard: onErrorCaptured", e);
      return true;
    });
    function onCopyToClipboard() {
      icon.value = props.copyIconCheck;
      setTimeout(() => {
        icon.value = props.copyIcon;
      }, 5e3);
      copyToClipboard(props.copyText, props.notificationText, props.showCopiedContent);
    }
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", {
        class: "cursor-pointer flex flex-row flex-nowrap cc-text-color-caption cc-text-highlight-hover",
        onClick: withModifiers(onCopyToClipboard, ["stop"])
      }, [
        !__props.iconRight ? (openBlock(), createElementBlock("i", {
          key: 0,
          class: normalizeClass(icon.value + " " + (hasLabel.value ? "mr-1" : ""))
        }, null, 2)) : createCommentVNode("", true),
        __props.label && !__props.highlight ? (openBlock(), createElementBlock("div", {
          key: 1,
          class: normalizeClass(__props.labelCSS)
        }, toDisplayString(__props.label), 3)) : createCommentVNode("", true),
        __props.highlight && htmlLabel.value ? (openBlock(), createElementBlock("div", {
          key: 2,
          class: normalizeClass(__props.labelCSS),
          innerHTML: htmlLabel.value
        }, null, 10, _hoisted_1)) : createCommentVNode("", true),
        __props.iconRight ? (openBlock(), createElementBlock("i", {
          key: 3,
          class: normalizeClass(icon.value + " " + (hasLabel.value ? "ml-1" : ""))
        }, null, 2)) : createCommentVNode("", true),
        __props.labelHover ? (openBlock(), createBlock(_sfc_main$1, {
          key: 4,
          "tooltip-c-s-s": "whitespace-nowrap",
          "transition-show": "scale",
          "transition-hide": "scale",
          innerHTML: __props.labelHover
        }, null, 8, ["innerHTML"])) : createCommentVNode("", true)
      ]);
    };
  }
});
export {
  _sfc_main as _
};
