import { d as defineComponent, a5 as toRefs, z as ref, C as onMounted, w as watchEffect, jU as getSortedAssetDetailsList, f as computed, o as openBlock, c as createElementBlock, H as Fragment, I as renderList, q as createVNode, a as createBlock, j as createCommentVNode, aH as QPagination_default } from "./index.js";
import { u as useTranslation } from "./useTranslation.js";
import { G as GridSpace } from "./GridSpace.js";
import { _ as _sfc_main$1 } from "./GridTxListTokenDetails.vue_vue_type_script_setup_true_lang.js";
const _hoisted_1 = {
  key: 0,
  class: "relative w-full flex flex-col flex-nowrap items-end self-end space-y-0.5"
};
const _hoisted_2 = {
  key: 1,
  class: "flex justify-center min-w-48 pt-1"
};
const itemsOnPage = 5;
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "GridTxListUtxoTokenList",
  props: {
    balance: { type: Object, required: true }
  },
  setup(__props) {
    const props = __props;
    const { balance } = toRefs(props);
    useTranslation();
    const _sortedAssetDetailsList = ref([]);
    onMounted(() => {
      watchEffect(() => {
        _sortedAssetDetailsList.value = getSortedAssetDetailsList(balance.value.multiasset);
      });
    });
    const currentPage = ref(1);
    const showPagination = computed(() => _sortedAssetDetailsList.value.length > itemsOnPage);
    const currentPageStart = computed(() => (currentPage.value - 1) * itemsOnPage);
    const maxPages = computed(() => Math.ceil(_sortedAssetDetailsList.value.length / itemsOnPage));
    const assetListPaged = computed(() => _sortedAssetDetailsList.value.slice(currentPageStart.value, currentPageStart.value + itemsOnPage));
    return (_ctx, _cache) => {
      return assetListPaged.value.length > 0 ? (openBlock(), createElementBlock("div", _hoisted_1, [
        (openBlock(true), createElementBlock(Fragment, null, renderList(assetListPaged.value, (asset) => {
          return openBlock(), createElementBlock("div", {
            class: "relative w-full flex flex-row flex-nowrap items-center",
            key: asset.p + asset.t.a
          }, [
            createVNode(_sfc_main$1, {
              asset,
              rightAlign: true,
              truncate: ""
            }, null, 8, ["asset"])
          ]);
        }), 128)),
        showPagination.value ? (openBlock(), createBlock(GridSpace, {
          key: 0,
          hr: "",
          class: "w-full my-1"
        })) : createCommentVNode("", true),
        showPagination.value ? (openBlock(), createElementBlock("div", _hoisted_2, [
          createVNode(QPagination_default, {
            modelValue: currentPage.value,
            "onUpdate:modelValue": _cache[0] || (_cache[0] = ($event) => currentPage.value = $event),
            max: maxPages.value,
            "max-pages": 4,
            "boundary-numbers": "",
            flat: "",
            color: "teal-90",
            "text-color": "teal-90",
            "active-color": "teal-90",
            "active-text-color": "teal-90",
            "active-design": "unelevated"
          }, null, 8, ["modelValue", "max"])
        ])) : createCommentVNode("", true)
      ])) : createCommentVNode("", true);
    };
  }
});
export {
  _sfc_main as _
};
