import { d as defineComponent, z as ref, K as networkId, D as watch, f as computed, c3 as isZero, eW as compare, o as openBlock, c as createElementBlock, H as Fragment, I as renderList, n as normalizeClass, b as withModifiers, B as useFormatter, t as toDisplayString, j as createCommentVNode } from "./index.js";
import { u as useTranslation } from "./useTranslation.js";
import { u as useBalanceVisible } from "./useBalanceVisible.js";
import { c as copyToClipboard } from "./Clipboard.js";
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "FormattedAmount",
  props: {
    amount: { type: String, required: true, default: "0" },
    isWholeNumber: { type: Boolean, required: false, default: false },
    // true = value in ADA vs false = value in lovelace
    decimals: { type: Number, required: false, default: -1 },
    displayDecimals: { type: Number, required: false, default: -1 },
    currency: { type: String, required: false, default: "ADA" },
    percent: { type: Boolean, required: false, default: false },
    textCSS: { type: String, required: false, default: "" },
    wholeCSS: { type: String, required: false, default: "cc-text-bold" },
    groupCSS: { type: String, required: false, default: "" },
    decimalCSS: { type: String, required: false, default: "" },
    fractionCSS: { type: String, required: false, default: "cc-text-light" },
    literalCSS: { type: String, required: false, default: "" },
    symbolCSS: { type: String, required: false, default: "" },
    signCSS: { type: String, required: false, default: "mr-0.5" },
    balanceAlwaysVisible: { type: Boolean, required: false, default: false },
    withSign: { type: Boolean, required: false, default: false },
    showFraction: { type: Boolean, required: false, default: true },
    hideFractionIfZero: { type: Boolean, required: false, default: true },
    trimFraction: { type: Boolean, required: false, default: true },
    compact: { type: Boolean, required: false, default: false },
    colored: { type: Boolean, required: false, default: false },
    clipboardEnabled: { type: Boolean, required: false, default: true }
  },
  emits: ["clicked"],
  setup(__props, { emit: __emit }) {
    const props = __props;
    const emit = __emit;
    const { isBalanceVisible } = useBalanceVisible();
    const { it } = useTranslation();
    const {
      formatAmount,
      formatPercent,
      getNetworkDecimals
    } = useFormatter();
    const decimalPlaces = ref(props.decimals >= 0 ? props.decimals : getNetworkDecimals(networkId.value));
    watch(() => props.decimals, () => {
      decimalPlaces.value = props.decimals >= 0 ? props.decimals : getNetworkDecimals(networkId.value);
    });
    const isVisible = computed(() => props.balanceAlwaysVisible || isBalanceVisible.value || props.percent);
    const formattedAmount = computed(() => props.percent ? formatPercent(parseFloat(props.amount), props.decimals) : formatAmount(
      props.amount,
      props.isWholeNumber,
      isVisible.value,
      props.displayDecimals,
      decimalPlaces.value,
      props.currency,
      props.withSign,
      props.compact
    ));
    const hideDust = computed(() => {
      if (props.hideFractionIfZero) {
        return !formattedAmount.value.some((s) => s.type === "fraction" && !isZero(s.value));
      } else {
        return false;
      }
    });
    const colorCSS = computed(() => props.colored ? compare(props.amount, "<", 0) ? "cc-text-red " : compare(props.amount, ">", 0) ? "cc-text-green " : "" : "");
    function onCopyToClipboard() {
      if (!props.clipboardEnabled) {
        emit("clicked");
        return;
      }
      const filtered = formattedAmount.value.filter((item) => item.type !== "literal" && item.type !== "currency").map((item) => item.value);
      copyToClipboard(filtered.join("").replace("+", ""), it("common.label.copied"), true);
      emit("clicked");
    }
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", {
        class: normalizeClass(["flex", colorCSS.value + __props.textCSS]),
        onClick: withModifiers(onCopyToClipboard, ["stop"])
      }, [
        (openBlock(true), createElementBlock(Fragment, null, renderList(formattedAmount.value, (s, index) => {
          return openBlock(), createElementBlock("div", { key: index }, [
            s.type === "integer" ? (openBlock(), createElementBlock("span", {
              key: 0,
              class: normalizeClass(__props.wholeCSS)
            }, toDisplayString(s.value), 3)) : s.type === "group" ? (openBlock(), createElementBlock("span", {
              key: 1,
              class: normalizeClass(__props.groupCSS)
            }, toDisplayString(s.value), 3)) : s.type === "decimal" && __props.showFraction && !hideDust.value && isVisible.value ? (openBlock(), createElementBlock("span", {
              key: 2,
              class: normalizeClass(__props.decimalCSS)
            }, toDisplayString(s.value), 3)) : s.type === "fraction" && __props.showFraction && !hideDust.value && isVisible.value ? (openBlock(), createElementBlock("span", {
              key: 3,
              class: normalizeClass(__props.fractionCSS)
            }, toDisplayString(__props.hideFractionIfZero && __props.trimFraction ? s.value.replace(/0+$/, "") : s.value), 3)) : s.type === "literal" ? (openBlock(), createElementBlock("span", {
              key: 4,
              class: normalizeClass(__props.literalCSS)
            }, toDisplayString(s.value), 3)) : s.type === "currency" ? (openBlock(), createElementBlock("span", {
              key: 5,
              class: normalizeClass(__props.symbolCSS)
            }, toDisplayString(s.value), 3)) : s.type.endsWith("Sign") ? (openBlock(), createElementBlock("span", {
              key: 6,
              class: normalizeClass(__props.signCSS)
            }, toDisplayString(s.value), 3)) : s.type === "compact" ? (openBlock(), createElementBlock("span", {
              key: 7,
              class: normalizeClass(__props.symbolCSS)
            }, toDisplayString(s.value), 3)) : createCommentVNode("", true)
          ]);
        }), 128))
      ], 2);
    };
  }
});
export {
  _sfc_main as _
};
