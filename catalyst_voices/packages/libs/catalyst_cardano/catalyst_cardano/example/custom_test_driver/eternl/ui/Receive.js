import { d as defineComponent, a5 as toRefs, z as ref, f as computed, o as openBlock, c as createElementBlock, q as createVNode, u as unref, a as createBlock, j as createCommentVNode, H as Fragment, I as renderList, e as createBaseVNode, aH as QPagination_default, a7 as useQuasar, K as networkId, gv as provide, S as reactive, D as watch, C as onMounted, aW as addSignalListener, aQ as onNetworkFeaturesUpdated, aG as onUnmounted, aX as removeSignalListener, gw as getPaymentBaseAddressList, gx as getPaymentEnterpriseAddressList, gy as getChangeBaseAddressList, gz as getChangeEnterpriseAddressList, h as withCtx, Q as QSpinnerDots_default, n as normalizeClass, t as toDisplayString, b as withModifiers, cf as getRandomId, ae as useSelectedAccount } from "./index.js";
import { e as isStakingEnabled } from "./NetworkId.js";
import { u as useTranslation } from "./useTranslation.js";
import { _ as _sfc_main$2, a as _sfc_main$3 } from "./GridHeadline.vue_vue_type_script_setup_true_lang.js";
import { G as GridSpace } from "./GridSpace.js";
import { G as GridInput } from "./GridInput.js";
import { _ as _sfc_main$5 } from "./GridTabs.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$4 } from "./GridReceiveAddr.vue_vue_type_script_setup_true_lang.js";
import { I as IconPencil } from "./IconPencil.js";
import "./_plugin-vue_export-helper.js";
import "./IconError.js";
import "./useTabId.js";
import "./Tooltip.vue_vue_type_script_setup_true_lang.js";
import "./browser.js";
import "./CopyToClipboard.vue_vue_type_script_setup_true_lang.js";
import "./Clipboard.js";
import "./Modal.js";
const _hoisted_1$1 = {
  key: 0,
  class: "relative col-span-12 grid grid-cols-12 cc-page-gap"
};
const _hoisted_2$1 = { class: "col-span-12 flex justify-center" };
const _sfc_main$1 = /* @__PURE__ */ defineComponent({
  __name: "GridReceiveAddrResults",
  props: {
    headline: { type: String, default: "", required: true },
    text: { type: String, default: "", required: true },
    itemsOnPage: { type: Number, default: 10, required: false },
    isFilteredResult: { type: Boolean, default: false, required: false },
    hideOnEmptyResults: { type: Boolean, default: false, required: false },
    highlight: { type: Boolean, default: false, required: false },
    // TODO: Not too sure about Refs as props here.
    resultList: { type: Object, default: [], required: true }
  },
  setup(__props) {
    const props = __props;
    const { t } = useTranslation();
    const {
      resultList,
      isFilteredResult,
      hideOnEmptyResults
    } = toRefs(props);
    const currentPage = ref(1);
    const showPagination = computed(() => resultList.value.length > props.itemsOnPage);
    const currentPageStart = computed(() => (currentPage.value - 1) * props.itemsOnPage);
    const maxPages = computed(() => Math.ceil(resultList.value.length / props.itemsOnPage));
    const pagedResults = computed(() => resultList.value.slice(currentPageStart.value, currentPageStart.value + props.itemsOnPage));
    const hideContent = computed(() => hideOnEmptyResults.value && resultList.value.length === 0);
    return (_ctx, _cache) => {
      return !hideContent.value ? (openBlock(), createElementBlock("div", _hoisted_1$1, [
        createVNode(_sfc_main$2, {
          label: __props.headline,
          class: "mt-4"
        }, null, 8, ["label"]),
        !unref(isFilteredResult) ? (openBlock(), createBlock(_sfc_main$3, {
          key: 0,
          text: __props.text,
          class: "mb-4"
        }, null, 8, ["text"])) : createCommentVNode("", true),
        unref(isFilteredResult) && unref(resultList).length === 0 ? (openBlock(), createBlock(_sfc_main$3, {
          key: 1,
          text: unref(t)("wallet.receive.filter.error.empty"),
          class: "mb-4"
        }, null, 8, ["text"])) : createCommentVNode("", true),
        createVNode(GridSpace, { hr: "" }),
        (openBlock(true), createElementBlock(Fragment, null, renderList(pagedResults.value, (item) => {
          return openBlock(), createBlock(_sfc_main$4, {
            key: item.bech32,
            text: item.bech32,
            info: item.pathInfo,
            used: item.used,
            highlight: __props.highlight
          }, null, 8, ["text", "info", "used", "highlight"]);
        }), 128)),
        createBaseVNode("div", _hoisted_2$1, [
          showPagination.value ? (openBlock(), createBlock(QPagination_default, {
            key: 0,
            modelValue: currentPage.value,
            "onUpdate:modelValue": _cache[0] || (_cache[0] = ($event) => currentPage.value = $event),
            max: maxPages.value,
            "max-pages": 6,
            "boundary-numbers": "",
            flat: "",
            color: "teal-90",
            "text-color": "teal-90",
            "active-color": "teal-90",
            "active-text-color": "teal-90",
            "active-design": "unelevated"
          }, null, 8, ["modelValue", "max"])) : createCommentVNode("", true)
        ])
      ])) : createCommentVNode("", true);
    };
  }
});
const _hoisted_1 = { class: "cc-page-wallet cc-text-sz" };
const _hoisted_2 = {
  key: 0,
  class: "col-span-12 grid grid-cols-12 cc-gap"
};
const _hoisted_3 = { class: "col-span-12 cc-flex cc-area-light align-middle p-2" };
const _hoisted_4 = { class: "col-span-12 flex flex-col xs:flex-row flex-nowrap items-end" };
const _hoisted_5 = {
  key: 1,
  class: "relative col-span-12"
};
const _hoisted_6 = { class: "cc-text-semi-bold" };
const _hoisted_7 = {
  key: 2,
  class: "relative col-span-12 grid grid-cols-12 cc-page-gap"
};
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "Receive",
  setup(__props) {
    const storeId = "Receive" + getRandomId();
    const {
      selectedAccountId,
      selectedWalletId,
      accountData,
      accountSettings
    } = useSelectedAccount();
    const isSamEnabled = accountSettings.isSamEnabled;
    const receiveAddress = accountSettings.receiveAddress;
    const { t } = useTranslation();
    useQuasar();
    const showAllKeys = ref(false);
    const searchInputError = ref("");
    const searchInput = ref("");
    const searchRunning = ref(false);
    const minInputLength = ref(1);
    const filterTextId = ref("wallet.receive.filter.toggle");
    const filterType = ref(0);
    const showPrivacyNotice = ref(true);
    let stakeIsEnabled = isStakingEnabled(networkId.value);
    provide("searchTerm", searchInput);
    const optionsType = reactive([
      { id: "all", label: t(filterTextId.value + ".all.label").toLowerCase(), hover: t(filterTextId.value + ".all.info"), index: 0 },
      { id: "used", label: t(filterTextId.value + ".used.label"), hover: t(filterTextId.value + ".used.info"), index: 1 },
      { id: "unused", label: t(filterTextId.value + ".unused.label"), hover: t(filterTextId.value + ".unused.info"), index: 2 }
    ]);
    const validateSearchInput = (event) => {
      if (searchInput.value.length > 0 && searchInput.value.length < minInputLength.value) {
        searchInputError.value = t("wallet.receive.filter.error.minLength");
      } else {
        searchInputError.value = "";
      }
    };
    function onTypeFilter(index) {
      filterType.value = index;
      clearSearchTimeout();
      startSearchTimeout();
    }
    const resetFilter = () => {
      searchInput.value = "";
      searchInputError.value = "";
      searchRunning.value = false;
      clearSearchTimeout();
    };
    const hideListsOnEmptyResult = ref(true);
    const isFilteredResult = ref(false);
    const noResultsWarning = ref(false);
    let searchingTimeout = -1;
    const searchInputEmpty = computed(() => searchInput.value.length === 0);
    const filteredExternalAddrList = ref([]);
    const filteredInternalAddrList = ref([]);
    const filteredEnterpriseExternalAddrList = ref([]);
    const filteredEnterpriseInternalAddrList = ref([]);
    const initialBaseExternalAddrList = ref([]);
    const initialBaseInternalAddrList = ref([]);
    const initialEnterpriseExternalAddrList = ref([]);
    const initialEnterpriseInternalAddrList = ref([]);
    const listsOnPage = ref([
      filteredExternalAddrList,
      filteredInternalAddrList,
      filteredEnterpriseExternalAddrList,
      filteredEnterpriseInternalAddrList
    ]);
    const resultSize = ref(0);
    watch(searchInput, () => {
      validateSearchInput();
      clearSearchTimeout();
      if (searchInputEmpty.value) {
        isFilteredResult.value = false;
      }
      startSearchTimeout();
    });
    const updateStakeEnabledStatus = () => {
      const newState = isStakingEnabled(networkId.value);
      if (stakeIsEnabled === newState) {
        return;
      }
      stakeIsEnabled = newState;
      resetFilter();
      filteredExternalAddrList.value.splice(0);
      filteredInternalAddrList.value.splice(0);
      filteredEnterpriseExternalAddrList.value.splice(0);
      filteredEnterpriseInternalAddrList.value.splice(0);
      getAdditionalAddresses();
      initialBaseExternalAddrList.value = filteredExternalAddrList.value;
      initialBaseInternalAddrList.value = filteredInternalAddrList.value;
      initialEnterpriseExternalAddrList.value = filteredEnterpriseExternalAddrList.value;
      initialEnterpriseInternalAddrList.value = filteredEnterpriseInternalAddrList.value;
    };
    onMounted(() => {
      addSignalListener(onNetworkFeaturesUpdated, storeId, updateStakeEnabledStatus);
      getAdditionalAddresses();
      initialBaseExternalAddrList.value = filteredExternalAddrList.value;
      initialBaseInternalAddrList.value = filteredInternalAddrList.value;
      initialEnterpriseExternalAddrList.value = filteredEnterpriseExternalAddrList.value;
      initialEnterpriseInternalAddrList.value = filteredEnterpriseInternalAddrList.value;
    });
    onUnmounted(() => removeSignalListener(onNetworkFeaturesUpdated, storeId));
    const restoreAddressLists = () => {
      filteredExternalAddrList.value = initialBaseExternalAddrList.value;
      filteredInternalAddrList.value = initialBaseInternalAddrList.value;
      filteredEnterpriseExternalAddrList.value = initialEnterpriseExternalAddrList.value;
      filteredEnterpriseInternalAddrList.value = initialEnterpriseInternalAddrList.value;
    };
    const clearSearchTimeout = () => {
      searchRunning.value = false;
      clearTimeout(searchingTimeout);
    };
    const startSearchTimeout = () => {
      searchingTimeout = setTimeout(() => {
        restoreAddressLists();
        searchRunning.value = true;
        filterAddressesOnSearch();
      }, searchInput.value.length === 0 ? 0 : 300);
    };
    const filterAddressesOnSearch = () => {
      if (searchInput.value.length === 4 && Number(searchInput.value) || searchInput.value.includes("/") || searchInput.value.includes(" ") || searchInput.value.includes("'")) {
        filteredExternalAddrList.value = filteredExternalAddrList.value.filter(filterByPath);
        filteredInternalAddrList.value = filteredInternalAddrList.value.filter(filterByPath);
        filteredEnterpriseExternalAddrList.value = filteredEnterpriseExternalAddrList.value.filter(filterByPath);
        filteredEnterpriseInternalAddrList.value = filteredEnterpriseInternalAddrList.value.filter(filterByPath);
      } else {
        filteredExternalAddrList.value = filteredExternalAddrList.value.filter(filterByString);
        filteredInternalAddrList.value = filteredInternalAddrList.value.filter(filterByString);
        filteredEnterpriseExternalAddrList.value = filteredEnterpriseExternalAddrList.value.filter(filterByString);
        filteredEnterpriseInternalAddrList.value = filteredEnterpriseInternalAddrList.value.filter(filterByString);
      }
      isFilteredResult.value = true;
      if (filterType.value === 0 && searchInputEmpty.value) {
        isFilteredResult.value = false;
      }
      showAllKeys.value = true;
      searchRunning.value = false;
      resultSize.value = listsOnPage.value.map((list) => list.value.length).reduce((last, current) => last + current, 0);
      noResultsWarning.value = resultSize.value === 0;
    };
    const filterByPath = (address) => {
      let searchValue = searchInput.value ?? "";
      searchValue = searchValue.replace(/m\//gi, "");
      searchValue = searchValue.replace(/m /gi, "");
      searchValue = searchValue.replace(/m/gi, "");
      if (searchValue.includes("/")) {
        searchValue = searchValue.replace(/\//g, " ");
      }
      if (searchValue.includes("'")) {
        searchValue = searchValue.replace(/\'/g, "");
      }
      searchValue = searchValue.replace(/\s\s+/g, " ");
      if (filterType.value === 0) {
        return address.searchablePath.includes(searchValue);
      }
      if (filterType.value === 1 && address.used) {
        return searchInputEmpty.value || !searchInputEmpty.value && address.searchablePath.includes(searchValue);
      }
      if (filterType.value === 2 && !address.used) {
        return searchInputEmpty.value || !searchInputEmpty.value && address.searchablePath.includes(searchValue);
      }
      return false;
    };
    const transformInfo = (addr) => {
      addr.pathInfo = addr.pathInfo + " (" + (addr.used ? t("wallet.receive.used") : t("wallet.receive.unused")) + ")";
      return addr;
    };
    const filterByString = (address) => {
      if (filterType.value === 0) {
        return address.bech32.includes(searchInput.value);
      }
      if (filterType.value === 1 && address.used) {
        return searchInputEmpty.value || !searchInputEmpty.value && address.bech32.includes(searchInput.value);
      }
      if (filterType.value === 2 && !address.used) {
        return searchInputEmpty.value || !searchInputEmpty.value && address.bech32.includes(searchInput.value);
      }
      return false;
    };
    const receiveAddressList = reactive([]);
    watch(receiveAddress, (value) => {
      if (isSamEnabled.value && value) {
        receiveAddressList.splice(0, receiveAddressList.length, value);
      } else {
        const _accountData = accountData.value;
        if (_accountData) {
          const addrList = stakeIsEnabled ? getPaymentBaseAddressList(_accountData, true, 1) : getPaymentEnterpriseAddressList(_accountData, true, 1);
          receiveAddressList.splice(0, receiveAddressList.length, ...addrList.map(transformInfo));
        }
      }
    }, { immediate: true });
    function getAdditionalAddresses() {
      const _accountData = accountData.value;
      if (_accountData) {
        if (showAllKeys.value) {
          startSearchTimeout();
        }
        if (searchInputEmpty.value) {
          if (stakeIsEnabled) {
            updateBaseExternalAddrList(_accountData);
            updateBaseInternalAddrList(_accountData);
          }
          updateEnterpriseExternalAddrList(_accountData);
          updateEnterpriseInternalAddrList(_accountData);
        }
      }
    }
    function updateBaseExternalAddrList(accountData2) {
      if (filteredExternalAddrList.value.length !== 0) {
        return;
      }
      filteredExternalAddrList.value = getPaymentBaseAddressList(accountData2, false).map(transformInfo);
    }
    function updateBaseInternalAddrList(accountData2) {
      if (filteredInternalAddrList.value.length !== 0) {
        return;
      }
      filteredInternalAddrList.value = getChangeBaseAddressList(accountData2, false).map(transformInfo);
    }
    function updateEnterpriseExternalAddrList(accountData2) {
      if (filteredEnterpriseExternalAddrList.value.length !== 0) {
        return;
      }
      filteredEnterpriseExternalAddrList.value = getPaymentEnterpriseAddressList(accountData2, false).map(transformInfo);
    }
    function updateEnterpriseInternalAddrList(accountData2) {
      if (filteredEnterpriseInternalAddrList.value.length !== 0) {
        return;
      }
      filteredEnterpriseInternalAddrList.value = getChangeEnterpriseAddressList(accountData2, false).map(transformInfo);
    }
    const togglePrivacyNotice = () => {
      showPrivacyNotice.value = !showPrivacyNotice.value;
    };
    return (_ctx, _cache) => {
      var _a;
      return openBlock(), createElementBlock("div", _hoisted_1, [
        createVNode(_sfc_main$2, {
          label: unref(isSamEnabled) ? unref(t)("wallet.receive.current.static") : unref(t)("wallet.receive.current.headline")
        }, null, 8, ["label"]),
        createVNode(_sfc_main$3, {
          text: unref(t)("wallet.receive.current.caption")
        }, null, 8, ["text"]),
        createVNode(GridSpace, { hr: "" }),
        (openBlock(true), createElementBlock(Fragment, null, renderList(receiveAddressList, (item) => {
          return openBlock(), createBlock(_sfc_main$4, {
            key: item.bech32,
            text: item.bech32,
            info: item.pathInfo,
            used: item.used
          }, null, 8, ["text", "info", "used"]);
        }), 128)),
        !unref(isSamEnabled) ? (openBlock(), createElementBlock("div", _hoisted_2, [
          createBaseVNode("div", _hoisted_3, [
            createBaseVNode("i", {
              class: "mdi mdi-information-outline cursor-pointer pointer-events-auto mr-1",
              onClick: togglePrivacyNotice
            }),
            createVNode(_sfc_main$3, {
              class: "cc-text-semi-bold inline-block",
              text: unref(t)("wallet.receive.current.notice.label")
            }, null, 8, ["text"]),
            showPrivacyNotice.value ? (openBlock(), createBlock(_sfc_main$3, {
              key: 0,
              text: unref(t)("wallet.receive.current.notice.text")
            }, null, 8, ["text"])) : createCommentVNode("", true)
          ]),
          createVNode(GridSpace, {
            hr: "",
            class: "mt-1 mb-3"
          }),
          createBaseVNode("div", _hoisted_4, [
            createVNode(GridInput, {
              class: "col-span-12 mb-2",
              "input-text": searchInput.value,
              "onUpdate:inputText": _cache[0] || (_cache[0] = ($event) => searchInput.value = $event),
              "input-error": searchInputError.value,
              "onUpdate:inputError": _cache[1] || (_cache[1] = ($event) => searchInputError.value = $event),
              onLostFocus: validateSearchInput,
              onReset: resetFilter,
              label: unref(t)("wallet.receive.filter.label"),
              "input-info": unref(t)("wallet.receive.filter.caption"),
              "input-hint": unref(t)("wallet.receive.filter.hint"),
              "capitalize-label": false,
              showReset: "",
              autocomplete: "off",
              "input-id": "searchToken",
              "input-type": "text"
            }, {
              "icon-prepend": withCtx(() => [
                createVNode(IconPencil, { class: "h-5 w-5" })
              ]),
              "icon-append": withCtx(() => [
                searchRunning.value ? (openBlock(), createBlock(QSpinnerDots_default, {
                  key: 0,
                  color: "grey"
                })) : createCommentVNode("", true)
              ]),
              _: 1
            }, 8, ["input-text", "input-error", "label", "input-info", "input-hint"]),
            createBaseVNode("div", {
              class: normalizeClass(["ml-8 mb-0.5 mt-2 xs:mt-0 xs:pr-3", searchInputError.value ? "pb-7" : ""])
            }, [
              createVNode(_sfc_main$5, {
                tabs: optionsType,
                divider: false,
                onSelection: onTypeFilter,
                index: filterType.value
              }, {
                tab0: withCtx(() => _cache[3] || (_cache[3] = [])),
                tab1: withCtx(() => _cache[4] || (_cache[4] = [])),
                tab2: withCtx(() => _cache[5] || (_cache[5] = [])),
                _: 1
              }, 8, ["tabs", "index"])
            ], 2)
          ]),
          isFilteredResult.value && !noResultsWarning.value ? (openBlock(), createBlock(_sfc_main$3, {
            key: 0,
            class: "break-words",
            text: unref(t)("wallet.receive.filter.results").replace("####count####", ((_a = resultSize.value) == null ? void 0 : _a.toString()) ?? "")
          }, null, 8, ["text"])) : createCommentVNode("", true),
          noResultsWarning.value ? (openBlock(), createElementBlock("div", _hoisted_5, toDisplayString(unref(t)("wallet.receive.filter.error.empty")), 1)) : createCommentVNode("", true),
          createVNode(GridSpace, { hr: "" }),
          createBaseVNode("div", {
            onClick: _cache[2] || (_cache[2] = withModifiers(($event) => {
              showAllKeys.value = !showAllKeys.value;
              getAdditionalAddresses();
            }, ["stop"])),
            class: "col-span-12 cursor-pointer"
          }, [
            createBaseVNode("i", {
              class: normalizeClass(["mr-2", showAllKeys.value ? "mdi mdi-chevron-down" : "mdi mdi-chevron-right"])
            }, null, 2),
            createBaseVNode("span", _hoisted_6, toDisplayString(unref(t)("wallet.receive.advanced." + (!showAllKeys.value ? "show" : "hide"))), 1)
          ]),
          showAllKeys.value ? (openBlock(), createElementBlock("div", _hoisted_7, [
            createVNode(_sfc_main$1, {
              headline: unref(t)("wallet.receive.external.delegated.headline"),
              text: unref(t)("wallet.receive.external.delegated.caption"),
              "result-list": filteredExternalAddrList.value,
              "is-filtered-result": isFilteredResult.value,
              "hide-on-empty-results": hideListsOnEmptyResult.value,
              highlight: true
            }, null, 8, ["headline", "text", "result-list", "is-filtered-result", "hide-on-empty-results"]),
            createVNode(_sfc_main$1, {
              headline: unref(t)("wallet.receive.internal.delegated.headline"),
              text: unref(t)("wallet.receive.internal.delegated.caption"),
              "result-list": filteredInternalAddrList.value,
              "is-filtered-result": isFilteredResult.value,
              "hide-on-empty-results": hideListsOnEmptyResult.value,
              highlight: true
            }, null, 8, ["headline", "text", "result-list", "is-filtered-result", "hide-on-empty-results"]),
            createVNode(_sfc_main$1, {
              headline: unref(t)("wallet.receive.external.enterprise.headline"),
              text: unref(t)("wallet.receive.external.enterprise.caption"),
              "result-list": filteredEnterpriseExternalAddrList.value,
              "is-filtered-result": isFilteredResult.value,
              "hide-on-empty-results": hideListsOnEmptyResult.value,
              highlight: true
            }, null, 8, ["headline", "text", "result-list", "is-filtered-result", "hide-on-empty-results"]),
            createVNode(_sfc_main$1, {
              headline: unref(t)("wallet.receive.internal.enterprise.headline"),
              text: unref(t)("wallet.receive.internal.enterprise.caption"),
              "result-list": filteredEnterpriseInternalAddrList.value,
              "is-filtered-result": isFilteredResult.value,
              "hide-on-empty-results": hideListsOnEmptyResult.value,
              highlight: true
            }, null, 8, ["headline", "text", "result-list", "is-filtered-result", "hide-on-empty-results"])
          ])) : createCommentVNode("", true)
        ])) : createCommentVNode("", true)
      ]);
    };
  }
});
export {
  _sfc_main as default
};
