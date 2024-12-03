import { d as defineComponent, z as ref, cL as getAssetInfoLight, C as onMounted, hA as getAssetInfo, c6 as getAssetIdBech32, o as openBlock, c as createElementBlock, e as createBaseVNode, n as normalizeClass, j as createCommentVNode, q as createVNode, t as toDisplayString, u as unref, c5 as getAssetName, i as createTextVNode, h as withCtx, b as withModifiers, F as withDirectives, J as vShow, aI as useGuard } from "./index.js";
import { u as useTranslation } from "./useTranslation.js";
import { _ as _sfc_main$4 } from "./ExplorerLink.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$3 } from "./CopyToClipboard.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$1 } from "./FormattedAmount.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$2 } from "./Tooltip.vue_vue_type_script_setup_true_lang.js";
const _hoisted_1 = { class: "truncate" };
const _hoisted_2 = {
  key: 1,
  class: "cc-badge-red cc-none inline-flex"
};
const _hoisted_3 = { class: "relative max-w-full flex flex-col flex-nowrap ml-4 cc-area-highlight px-2 pb-1 my-1 space-y-1" };
const _hoisted_4 = {
  key: 0,
  class: "text-right break-words"
};
const _hoisted_5 = {
  key: 1,
  class: "cc-text-xs text-right break-words"
};
const _hoisted_6 = {
  key: 2,
  class: "cc-addr text-right break-all"
};
const _hoisted_7 = ["href"];
const _hoisted_8 = { class: "relative w-full flex flex-row flex-nowrap justify-center items-center" };
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "GridTxListTokenDetails",
  props: {
    asset: { type: Object, required: true },
    rightAlign: { type: Boolean, required: false, default: false },
    truncate: { type: Boolean, required: false, default: false },
    showDescription: { type: Boolean, required: false, default: false }
  },
  setup(__props) {
    var _a, _b, _c, _d, _e;
    const props = __props;
    const { t } = useTranslation();
    const { isAssetOnBlockList } = useGuard();
    const isADA = props.asset.p.length === 0;
    const assetIdBech32 = props.asset.f;
    const tokenMetadata = ref(getAssetInfoLight((_a = props.asset) == null ? void 0 : _a.p, (_b = props.asset) == null ? void 0 : _b.t.a));
    const hasValidURL = ref(!((_e = (_d = (_c = tokenMetadata.value) == null ? void 0 : _c.tr) == null ? void 0 : _d.u) == null ? void 0 : _e.includes("ipfs")));
    const showTokenDetails = ref(false);
    const isScam = ref(false);
    onMounted(async () => {
      var _a2, _b2, _c2, _d2;
      if (((_a2 = props.asset) == null ? void 0 : _a2.p) != null) {
        if (!tokenMetadata.value) {
          tokenMetadata.value = await getAssetInfo(props.asset.p, props.asset.t.a, true);
          hasValidURL.value = !((_d2 = (_c2 = (_b2 = tokenMetadata.value) == null ? void 0 : _b2.tr) == null ? void 0 : _c2.u) == null ? void 0 : _d2.includes("ipfs"));
        }
        isScam.value = isAssetOnBlockList(getAssetIdBech32(props.asset.p, props.asset.t.a));
      }
    });
    return (_ctx, _cache) => {
      var _a2, _b2, _c2, _d2, _e2, _f, _g, _h, _i, _j, _k, _l, _m, _n;
      return openBlock(), createElementBlock("div", {
        class: normalizeClass(["relative w-full max-w-full flex flex-col flex-nowrap text-sm", __props.rightAlign ? "items-end" : "items-start"])
      }, [
        createBaseVNode("div", {
          onClick: _cache[1] || (_cache[1] = withModifiers(($event) => showTokenDetails.value = isADA ? false : !showTokenDetails.value, ["stop"])),
          class: normalizeClass(["w-full max-w-full flex flex-row space-x-1", (__props.rightAlign ? "justify-end" : "justify-start") + " " + (isADA ? "" : "cursor-pointer")])
        }, [
          !isADA ? (openBlock(), createElementBlock("i", {
            key: 0,
            class: normalizeClass(["cursor-pointer", showTokenDetails.value ? "mdi mdi-chevron-down" : "mdi mdi-chevron-right"])
          }, null, 2)) : createCommentVNode("", true),
          createVNode(_sfc_main$1, {
            "balance-always-visible": __props.asset.t.q === "1",
            "text-c-s-s": "justify-end",
            amount: __props.asset.t.q,
            decimals: ((_b2 = (_a2 = tokenMetadata.value) == null ? void 0 : _a2.tr) == null ? void 0 : _b2.d) ?? 0,
            currency: "",
            onClicked: _cache[0] || (_cache[0] = ($event) => showTokenDetails.value = isADA ? false : !showTokenDetails.value)
          }, null, 8, ["balance-always-visible", "amount", "decimals"]),
          createBaseVNode("span", _hoisted_1, toDisplayString(unref(getAssetName)(__props.asset.t.a, tokenMetadata.value, true)), 1),
          isScam.value ? (openBlock(), createElementBlock("div", _hoisted_2, [
            createTextVNode(toDisplayString(unref(t)("common.scam.token.label")) + " ", 1),
            createVNode(_sfc_main$2, {
              anchor: "bottom middle",
              "transition-show": "scale",
              "transition-hide": "scale"
            }, {
              default: withCtx(() => [
                createTextVNode(toDisplayString(unref(t)("common.scam.token.description")), 1)
              ]),
              _: 1
            })
          ])) : createCommentVNode("", true)
        ], 2),
        withDirectives(createBaseVNode("div", _hoisted_3, [
          ((_d2 = (_c2 = tokenMetadata.value) == null ? void 0 : _c2.tr) == null ? void 0 : _d2.n) ? (openBlock(), createElementBlock("div", _hoisted_4, toDisplayString((_f = (_e2 = tokenMetadata.value) == null ? void 0 : _e2.tr) == null ? void 0 : _f.n), 1)) : createCommentVNode("", true),
          __props.showDescription && ((_h = (_g = tokenMetadata.value) == null ? void 0 : _g.tr) == null ? void 0 : _h.ds) ? (openBlock(), createElementBlock("div", _hoisted_5, toDisplayString((_j = (_i = tokenMetadata.value) == null ? void 0 : _i.tr) == null ? void 0 : _j.ds), 1)) : createCommentVNode("", true),
          hasValidURL.value ? (openBlock(), createElementBlock("div", _hoisted_6, [
            createBaseVNode("a", {
              href: ((_l = (_k = tokenMetadata.value) == null ? void 0 : _k.tr) == null ? void 0 : _l.u) ?? void 0,
              target: "_blank",
              rel: "noopener noreferrer"
            }, toDisplayString((_n = (_m = tokenMetadata.value) == null ? void 0 : _m.tr) == null ? void 0 : _n.u), 9, _hoisted_7)
          ])) : createCommentVNode("", true),
          createBaseVNode("div", _hoisted_8, [
            createVNode(_sfc_main$3, {
              "label-hover": unref(t)("wallet.summary.button.copy.token.fingerprint.hover"),
              "notification-text": unref(t)("wallet.summary.button.copy.token.fingerprint.notify"),
              "copy-text": unref(assetIdBech32),
              class: "pr-1 flex items-end cc-text-color-copy"
            }, null, 8, ["label-hover", "notification-text", "copy-text"]),
            createVNode(_sfc_main$4, {
              subject: __props.asset,
              type: "token",
              truncate: __props.truncate,
              label: unref(assetIdBech32),
              "label-c-s-s": "cc-addr ",
              class: "text-right"
            }, null, 8, ["subject", "truncate", "label"])
          ])
        ], 512), [
          [vShow, showTokenDetails.value]
        ])
      ], 2);
    };
  }
});
export {
  _sfc_main as _
};
