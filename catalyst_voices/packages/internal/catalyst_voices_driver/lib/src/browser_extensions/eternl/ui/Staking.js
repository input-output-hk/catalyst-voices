import { d as defineComponent, z as ref, w as watchEffect, S as reactive, K as networkId, D as watch, gA as updateFilteredPools, f as computed, o as openBlock, c as createElementBlock, q as createVNode, h as withCtx, a as createBlock, u as unref, j as createCommentVNode, e as createBaseVNode, gB as groupPoolDataList, gC as filteredPoolDataList, aS as isTestnet, gD as featuredPoolDataList, ae as useSelectedAccount } from "./index.js";
import { u as updatePoolInRewardInfo } from "./reward.js";
import { u as useTranslation } from "./useTranslation.js";
import { _ as _sfc_main$1, a as _sfc_main$2 } from "./GridHeadline.vue_vue_type_script_setup_true_lang.js";
import { G as GridSpace } from "./GridSpace.js";
import { G as GridInput } from "./GridInput.js";
import { _ as _sfc_main$4 } from "./GridTabs.vue_vue_type_script_setup_true_lang.js";
import { I as IconPencil } from "./IconPencil.js";
import { _ as _sfc_main$3 } from "./GridStakePoolList.vue_vue_type_script_setup_true_lang.js";
import "./NetworkId.js";
import "./_plugin-vue_export-helper.js";
import "./IconError.js";
import "./useTabId.js";
import "./Tooltip.vue_vue_type_script_setup_true_lang.js";
import "./CopyToClipboard.vue_vue_type_script_setup_true_lang.js";
import "./Clipboard.js";
import "./ExplorerLink.vue_vue_type_script_setup_true_lang.js";
import "./useAdaSymbol.js";
import "./FormattedAmount.vue_vue_type_script_setup_true_lang.js";
import "./useBalanceVisible.js";
import "./InlineButton.vue_vue_type_script_setup_true_lang.js";
const _hoisted_1 = { class: "cc-page-wallet cc-text-sz dark:text-cc-gray" };
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "Staking",
  setup(__props) {
    const { t } = useTranslation();
    const {
      selectedAccountId,
      accountData,
      accountSettings
    } = useSelectedAccount();
    const rewardInfo = accountSettings.rewardInfo;
    const stakeKey = accountSettings.stakeKey;
    const delegatedPoolList = ref([]);
    async function generateDelegationList() {
      delegatedPoolList.value.splice(0);
      if (stakeKey.value && rewardInfo.value) {
        const _rewardInfo = await updatePoolInRewardInfo(rewardInfo.value);
        for (const pool of _rewardInfo.afterNextDelegations) {
          if (typeof pool === "object") {
            delegatedPoolList.value.push(pool);
          }
        }
      }
    }
    watchEffect(() => {
      if (selectedAccountId.value && groupPoolDataList.value.length > 0 && rewardInfo.value) {
        generateDelegationList();
      }
    });
    const searchInput = ref("");
    const searchInputError = ref("");
    const searchDisabled = ref(false);
    const optionsTabs = reactive([
      { id: "ranked", label: t("wallet.staking.tab.ranked"), index: 0 }
      //{ id: 'md',       label: t('wallet.staking.tab.md') },
    ]);
    if (networkId.value === "mainnet") {
      optionsTabs.push({ id: "featured", label: t("wallet.staking.tab.featured"), index: 1 });
    }
    function validateSearchInput(external) {
      searchInputError.value = "";
      return searchInputError.value;
    }
    function resetFilter() {
      searchInput.value = "";
    }
    watch(searchInput, () => {
      validateSearchInput();
      updateFilteredPools(searchInput.value);
    });
    const showGroupPoolList = computed(() => searchInput.value.toLowerCase().length < 3);
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", _hoisted_1, [
        createVNode(_sfc_main$4, { tabs: optionsTabs }, {
          tab0: withCtx(() => [
            delegatedPoolList.value.length > 0 ? (openBlock(), createBlock(_sfc_main$1, {
              key: 0,
              label: unref(t)("wallet.staking.poollist.delegated.headline")
            }, null, 8, ["label"])) : createCommentVNode("", true),
            delegatedPoolList.value.length > 0 ? (openBlock(), createBlock(_sfc_main$2, {
              key: 1,
              text: unref(t)("wallet.staking.poollist.delegated.caption")
            }, null, 8, ["text"])) : createCommentVNode("", true),
            delegatedPoolList.value.length > 0 ? (openBlock(), createBlock(_sfc_main$3, {
              key: 2,
              poolList: delegatedPoolList.value,
              delegatedPoolList: delegatedPoolList.value,
              dense: "",
              selected: ""
            }, null, 8, ["poolList", "delegatedPoolList"])) : createCommentVNode("", true),
            delegatedPoolList.value.length > 0 ? (openBlock(), createBlock(GridSpace, {
              key: 3,
              hr: "",
              class: "mt-1 mb-1"
            })) : createCommentVNode("", true),
            createVNode(_sfc_main$1, {
              label: unref(t)("wallet.staking.poollist.headline")
            }, null, 8, ["label"]),
            createVNode(_sfc_main$2, {
              text: unref(t)("wallet.staking.poollist.caption")
            }, null, 8, ["text"]),
            createVNode(GridSpace, {
              hr: "",
              class: "mt-1 mb-1"
            }),
            createVNode(GridInput, {
              class: "col-span-12 sm:col-span-6 mb-1",
              "input-text": searchInput.value,
              "onUpdate:inputText": _cache[0] || (_cache[0] = ($event) => searchInput.value = $event),
              "input-error": searchInputError.value,
              "onUpdate:inputError": _cache[1] || (_cache[1] = ($event) => searchInputError.value = $event),
              onLostFocus: validateSearchInput,
              onReset: resetFilter,
              label: unref(t)("wallet.staking.search.label"),
              "input-hint": unref(t)("wallet.staking.search.hint"),
              alwaysShowInfo: false,
              "input-id": "searchInput",
              "input-type": "text",
              autocomplete: "name",
              inputDisabled: searchDisabled.value,
              "show-reset": true,
              "dense-input": ""
            }, {
              "icon-prepend": withCtx(() => [
                createVNode(IconPencil, { class: "h-5 w-5" })
              ]),
              _: 1
            }, 8, ["input-text", "input-error", "label", "input-hint", "inputDisabled"]),
            _cache[2] || (_cache[2] = createBaseVNode("div", { class: "cc-none lg:block lg:col-span-3" }, null, -1)),
            createVNode(GridSpace, {
              hr: "",
              class: "mb-1"
            }),
            createVNode(_sfc_main$3, {
              poolList: showGroupPoolList.value ? unref(groupPoolDataList) : unref(filteredPoolDataList),
              delegatedPoolList: delegatedPoolList.value,
              dense: ""
            }, null, 8, ["poolList", "delegatedPoolList"])
          ]),
          tab1: withCtx(() => [
            delegatedPoolList.value.length > 0 ? (openBlock(), createBlock(_sfc_main$1, {
              key: 0,
              label: unref(t)("wallet.staking.poollist.delegated.headline")
            }, null, 8, ["label"])) : createCommentVNode("", true),
            delegatedPoolList.value.length > 0 ? (openBlock(), createBlock(_sfc_main$2, {
              key: 1,
              text: unref(t)("wallet.staking.poollist.delegated.caption")
            }, null, 8, ["text"])) : createCommentVNode("", true),
            delegatedPoolList.value.length > 0 ? (openBlock(), createBlock(_sfc_main$3, {
              key: 2,
              poolList: delegatedPoolList.value,
              delegatedPoolList: delegatedPoolList.value,
              dense: "",
              selected: ""
            }, null, 8, ["poolList", "delegatedPoolList"])) : createCommentVNode("", true),
            delegatedPoolList.value.length > 0 ? (openBlock(), createBlock(GridSpace, {
              key: 3,
              hr: "",
              class: "mt-1 mb-1"
            })) : createCommentVNode("", true),
            !unref(isTestnet) ? (openBlock(), createBlock(_sfc_main$1, {
              key: 4,
              label: unref(t)("wallet.staking.poollist.featured.headline")
            }, null, 8, ["label"])) : createCommentVNode("", true),
            createVNode(_sfc_main$2, {
              text: unref(isTestnet) ? unref(t)("wallet.staking.poollist.featured.testnet") : unref(t)("wallet.staking.poollist.featured.caption")
            }, null, 8, ["text"]),
            createVNode(GridSpace, {
              hr: "",
              class: "mt-1 mb-1"
            }),
            !unref(isTestnet) ? (openBlock(), createBlock(_sfc_main$3, {
              key: 5,
              poolList: unref(featuredPoolDataList),
              delegatedPoolList: delegatedPoolList.value,
              dense: "",
              "no-rank": ""
            }, null, 8, ["poolList", "delegatedPoolList"])) : createCommentVNode("", true)
          ]),
          _: 1
        }, 8, ["tabs"])
      ]);
    };
  }
});
export {
  _sfc_main as default
};
