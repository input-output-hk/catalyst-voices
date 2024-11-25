import { d as defineComponent, z as ref, D as watch, o as openBlock, c as createElementBlock, e as createBaseVNode, q as createVNode, H as Fragment, I as renderList, t as toDisplayString, u as unref, j as createCommentVNode, c6 as getAssetIdBech32, c7 as accAssetInfoMap, c8 as fetchAssetInfo, K as networkId, c9 as updateAccountAssetInfoMap, aI as useGuard, c5 as getAssetName, i as createTextVNode, h as withCtx } from "./index.js";
import { u as useTranslation } from "./useTranslation.js";
import { _ as _sfc_main$1 } from "./FormattedAmount.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$2 } from "./Tooltip.vue_vue_type_script_setup_true_lang.js";
const _hoisted_1 = { class: "inline-flex items-top self-start justify-center pt-1 relative w-1/3" };
const _hoisted_2 = { class: "relative col items-center w-full max-w-full" };
const _hoisted_3 = { class: "truncate" };
const _hoisted_4 = {
  key: 0,
  class: "cc-badge-red cc-none inline-flex"
};
const _hoisted_5 = {
  key: 0,
  class: "text-right"
};
const _hoisted_6 = { class: "cc-text-semi-bold" };
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "GridTxListEntryBalance",
  props: {
    txBalance: { type: Object, required: true },
    assetLimit: { type: Number, required: false, default: 2 }
  },
  emits: ["scamTokenFound"],
  setup(__props, { emit: __emit }) {
    const props = __props;
    const emit = __emit;
    const { t } = useTranslation();
    const assetsFiltered = ref([]);
    const assetCnt = ref(0);
    const { isAssetOnBlockList } = useGuard();
    const spamAssets = ref([]);
    const update = async (balance) => {
      var _a, _b;
      const list = [];
      let count = 0;
      if (balance.multiasset) {
        for (const policy of Object.entries(balance.multiasset)) {
          for (const asset of Object.entries(policy[1])) {
            count++;
            if (count <= props.assetLimit) {
              const assetKey = policy[0] + asset[0];
              if (isAssetOnBlockList(getAssetIdBech32(policy[0], asset[0]))) {
                spamAssets.value.push(assetKey);
                emit("scamTokenFound");
              }
              list.push({
                asset: {
                  p: policy[0],
                  t: {
                    a: asset[0],
                    q: asset[1]
                  }
                },
                info: null
              });
            }
          }
        }
        assetCnt.value = count;
        assetsFiltered.value = list;
        let missingInfo = null;
        for (const asset of assetsFiltered.value) {
          asset.info = ((_a = accAssetInfoMap.value[asset.asset.p]) == null ? void 0 : _a.find((a) => a.h === asset.asset.t.a)) ?? null;
          if (!asset.info) {
            if (!missingInfo) {
              missingInfo = { [asset.asset.p]: [asset.asset.t.a] };
            } else if (asset.asset.p in missingInfo) {
              missingInfo[asset.asset.p].push(asset.asset.t.a);
            } else {
              missingInfo[asset.asset.p] = [asset.asset.t.a];
            }
          }
        }
        if (missingInfo) {
          const infos = await fetchAssetInfo(networkId.value, missingInfo);
          updateAccountAssetInfoMap(infos);
          for (const asset of assetsFiltered.value) {
            if (!asset.info) {
              asset.info = ((_b = infos[asset.asset.p]) == null ? void 0 : _b.find((i) => i.h === asset.asset.t.a)) ?? null;
            }
          }
        }
      } else {
        assetCnt.value = count;
        assetsFiltered.value = [];
      }
    };
    watch(() => props.txBalance, () => update(props.txBalance), { deep: true, immediate: true });
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", _hoisted_1, [
        createBaseVNode("div", _hoisted_2, [
          createVNode(_sfc_main$1, {
            amount: __props.txBalance.coin,
            "text-c-s-s": "justify-end",
            colored: "",
            "with-sign": ""
          }, null, 8, ["amount"]),
          (openBlock(true), createElementBlock(Fragment, null, renderList(assetsFiltered.value, (asset, index) => {
            var _a, _b;
            return openBlock(), createElementBlock("div", {
              key: index,
              class: "flex flex-row justify-end space-x-1"
            }, [
              createVNode(_sfc_main$1, {
                "text-c-s-s": "justify-end",
                "with-sign": "",
                amount: asset.asset.t.q,
                decimals: ((_b = (_a = asset.info) == null ? void 0 : _a.tr) == null ? void 0 : _b.d) ?? 0,
                currency: ""
              }, null, 8, ["amount", "decimals"]),
              createBaseVNode("span", _hoisted_3, toDisplayString(unref(getAssetName)(asset.asset.t.a, asset.info, true)), 1),
              spamAssets.value.includes(asset.asset.p + asset.asset.t.a) ? (openBlock(), createElementBlock("div", _hoisted_4, [
                createTextVNode(toDisplayString(unref(t)("common.scam.token.label")) + " ", 1),
                createVNode(_sfc_main$2, {
                  anchor: "bottom middle",
                  "transition-show": "scale",
                  "transition-hide": "scale"
                }, {
                  default: withCtx(() => [
                    createTextVNode(toDisplayString(unref(t)("common.scam.token.hover")), 1)
                  ]),
                  _: 1
                })
              ])) : createCommentVNode("", true)
            ]);
          }), 128)),
          assetCnt.value > __props.assetLimit ? (openBlock(), createElementBlock("div", _hoisted_5, [
            createBaseVNode("span", _hoisted_6, toDisplayString(assetCnt.value - __props.assetLimit) + " ", 1),
            createBaseVNode("span", null, toDisplayString(unref(t)("wallet.transactions.token.more")), 1)
          ])) : createCommentVNode("", true)
        ])
      ]);
    };
  }
});
export {
  _sfc_main as _
};
