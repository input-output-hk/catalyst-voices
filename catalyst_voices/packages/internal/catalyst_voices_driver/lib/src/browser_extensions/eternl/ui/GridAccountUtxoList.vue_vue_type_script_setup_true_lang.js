import { d as defineComponent, z as ref, C as onMounted, aW as addSignalListener, k1 as onAccountDataUpdated, k2 as onLockedUtxoToggled, aG as onUnmounted, aX as removeSignalListener, f as computed, u as unref, o as openBlock, c as createElementBlock, a as createBlock, j as createCommentVNode, q as createVNode, Q as QSpinnerDots_default, e as createBaseVNode, t as toDisplayString, n as normalizeClass, h as withCtx, i as createTextVNode, aH as QPagination_default, H as Fragment, I as renderList, cf as getRandomId, ae as useSelectedAccount, k3 as getLockedUtxos, k4 as cachePendingUtxoList, eW as compare, h7 as getOwnedCredFromAddrBech32, h8 as getDerivationPath } from "./index.js";
import { u as useTranslation } from "./useTranslation.js";
import { _ as _sfc_main$2 } from "./Tooltip.vue_vue_type_script_setup_true_lang.js";
import { G as GridSpace } from "./GridSpace.js";
import { _ as _sfc_main$3 } from "./GridAccountUtxoItem.vue_vue_type_script_setup_true_lang.js";
const _hoisted_1$1 = {
  key: 0,
  class: "col-span-12 cc-grid"
};
const _hoisted_2 = {
  key: 1,
  class: "col-span-12 w-full flex flex-row justify-center"
};
const _hoisted_3 = {
  key: 2,
  class: "col-span-12 grid grid-cols-12 gap-1"
};
const _hoisted_4 = { class: "col-span-12 cc-text-semi-bold flex flex-row justify-start items-center" };
const _hoisted_5 = { class: "mx-1" };
const _hoisted_6 = { class: "" };
const _hoisted_7 = { class: "col-span-12 flex justify-center" };
const _hoisted_8 = { class: "col-span-12 flex justify-center" };
const itemsOnPage = 5;
const _sfc_main$1 = /* @__PURE__ */ defineComponent({
  __name: "GridAccountUtxoTypeList",
  props: {
    utxoType: { type: String, required: true },
    label: { type: String, required: false, default: "wallet.summary.utxo.label" },
    badgeLabel: { type: String },
    badgeHint: { type: String },
    badgeHover: { type: String },
    badgeCss: { type: String, default: "cc-badge-gray" },
    showDivider: { type: Boolean, default: true },
    showBadge: { type: Boolean, default: true },
    showSelect: { type: Boolean, required: false, default: false }
  },
  setup(__props) {
    const props = __props;
    const storeId = "GridAccountUtxoTypeList" + getRandomId();
    const { it } = useTranslation();
    const {
      selectedAccountId,
      appAccount,
      accountData,
      utxoMap
    } = useSelectedAccount();
    const updating = ref(true);
    const showPagination = ref(false);
    const maxPages = ref(0);
    let utxoList = [];
    let numUtxos = ref("0");
    let numAllUtxos = ref(0);
    let numAddr = ref(0);
    let utxoItemList = ref([]);
    const updateList = async (_appAccount) => {
      if (!appAccount.value) {
        return;
      }
      if ((_appAccount == null ? void 0 : _appAccount.id) && appAccount.value.id !== (_appAccount == null ? void 0 : _appAccount.id)) {
        return;
      }
      const _utxoMap = utxoMap.value;
      if (!_utxoMap) {
        return;
      }
      if (!accountData.value) {
        return;
      }
      updating.value = utxoItemList.value.length === 0;
      if (props.utxoType === "collateral") {
        utxoList = _utxoMap.collateral;
      } else if (props.utxoType === "locked") {
        utxoList = getLockedUtxos(appAccount.value);
      } else if (props.utxoType === "pendingIn") {
        const {
          pendingInputList
        } = cachePendingUtxoList(appAccount.value);
        utxoList = pendingInputList.concat();
      } else if (props.utxoType === "pendingOut") {
        const {
          pendingOutputList
        } = cachePendingUtxoList(appAccount.value);
        utxoList = pendingOutputList.concat();
      } else {
        utxoList = _utxoMap[props.utxoType];
      }
      numAllUtxos.value = utxoList.length;
      switch (props.utxoType) {
        case "opk":
          numAllUtxos.value = _utxoMap.numOpk;
          break;
        case "opkosk":
          numAllUtxos.value = _utxoMap.numOpkOsk;
          break;
        case "opkesk":
          numAllUtxos.value = _utxoMap.numOpkEsk;
          break;
        case "epkosk":
          numAllUtxos.value = _utxoMap.numEpkOsk;
          break;
      }
      let _numUtxos = 0;
      let _numAddr = 0;
      const list = [];
      for (const utxo of utxoList) {
        let item = list.find((item2) => item2.bech32 === utxo.output.address);
        if (!item) {
          item = { bech32: utxo.output.address, list: [utxo], pathInfo: getPathInfo(utxo.output.address) };
          list.push(item);
          _numAddr++;
        } else {
          item.list.push(utxo);
        }
        _numUtxos++;
      }
      for (const item of list) {
        item.list.sort((a, b) => compare(a.output.amount.coin, ">", b.output.amount.coin) ? -1 : 1);
      }
      disposeList();
      utxoItemList.value = list;
      maxPages.value = Math.ceil(list.length / itemsOnPage);
      showPagination.value = maxPages.value > 1;
      numAddr.value = _numAddr;
      updating.value = false;
      if (_numUtxos !== numAllUtxos.value) {
        numUtxos.value = _numUtxos.toString() + " of " + numAllUtxos.value.toString();
      } else {
        numUtxos.value = _numUtxos.toString();
      }
    };
    const disposeList = () => {
      for (const utxo of utxoItemList.value) {
        utxo.list.length = 0;
      }
      utxoItemList.value.length = 0;
    };
    onMounted(() => {
      updateList(appAccount.value ?? null);
      addSignalListener(onAccountDataUpdated, storeId, updateList);
      if (props.utxoType === "locked") {
        addSignalListener(onLockedUtxoToggled, storeId, updateList);
      }
    });
    onUnmounted(() => {
      disposeList();
      removeSignalListener(onAccountDataUpdated, storeId);
      if (props.utxoType === "locked") {
        removeSignalListener(onLockedUtxoToggled, storeId);
      }
    });
    const getPathInfo = (addr) => {
      if (accountData.value) {
        const cred = getOwnedCredFromAddrBech32([accountData.value.keys], addr);
        if (cred) {
          return getDerivationPath(cred.path);
        }
      }
      return "";
    };
    const currentPage = ref(1);
    const currentPageStart = computed(() => (currentPage.value - 1) * itemsOnPage);
    const utxoListFiltered = computed(() => utxoItemList.value.slice(currentPageStart.value, currentPageStart.value + itemsOnPage));
    return (_ctx, _cache) => {
      return updating.value || unref(utxoList).length > 0 ? (openBlock(), createElementBlock("div", _hoisted_1$1, [
        __props.showDivider ? (openBlock(), createBlock(GridSpace, {
          key: 0,
          hr: "",
          class: "mt-0.5 mb-0.5"
        })) : createCommentVNode("", true),
        updating.value ? (openBlock(), createElementBlock("div", _hoisted_2, [
          createVNode(QSpinnerDots_default, {
            color: "gray",
            size: "2em"
          })
        ])) : (openBlock(), createElementBlock("div", _hoisted_3, [
          createBaseVNode("div", _hoisted_4, [
            createBaseVNode("div", null, toDisplayString(unref(it)(__props.label).replace("###utxo###", unref(numUtxos).toString()).replace("###addresses###", unref(numAddr).toString())), 1),
            createBaseVNode("span", _hoisted_5, toDisplayString(__props.badgeHint), 1),
            __props.badgeLabel && __props.showBadge ? (openBlock(), createElementBlock("div", {
              key: 0,
              class: normalizeClass(["h-5", __props.badgeCss])
            }, [
              createBaseVNode("span", _hoisted_6, toDisplayString(__props.badgeLabel), 1),
              __props.badgeHover ? (openBlock(), createBlock(_sfc_main$2, {
                key: 0,
                anchor: "bottom middle",
                "transition-show": "scale",
                "transition-hide": "scale"
              }, {
                default: withCtx(() => [
                  createTextVNode(toDisplayString(unref(it)(__props.badgeHover)), 1)
                ]),
                _: 1
              })) : createCommentVNode("", true)
            ], 2)) : createCommentVNode("", true)
          ]),
          showPagination.value ? (openBlock(), createBlock(GridSpace, {
            key: 0,
            hr: "",
            class: "mt-0.5 mb-0.5"
          })) : createCommentVNode("", true),
          createBaseVNode("div", _hoisted_7, [
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
          ]),
          showPagination.value ? (openBlock(), createBlock(GridSpace, {
            key: 1,
            hr: "",
            class: "mt-0.5 mb-0.5"
          })) : createCommentVNode("", true),
          (openBlock(true), createElementBlock(Fragment, null, renderList(utxoListFiltered.value, (item) => {
            return openBlock(), createBlock(_sfc_main$3, {
              key: item.bech32 + "_au",
              "utxo-item": item,
              "show-select": __props.showSelect,
              class: "col-span-12 cc-text-sz"
            }, null, 8, ["utxo-item", "show-select"]);
          }), 128)),
          showPagination.value ? (openBlock(), createBlock(GridSpace, {
            key: 2,
            hr: "",
            class: "mt-0.5 mb-0.5"
          })) : createCommentVNode("", true),
          createBaseVNode("div", _hoisted_8, [
            showPagination.value ? (openBlock(), createBlock(QPagination_default, {
              key: 0,
              modelValue: currentPage.value,
              "onUpdate:modelValue": _cache[1] || (_cache[1] = ($event) => currentPage.value = $event),
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
        ]))
      ])) : createCommentVNode("", true);
    };
  }
});
const _hoisted_1 = {
  key: 0,
  class: "col-span-12 cc-grid"
};
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "GridAccountUtxoList",
  props: {
    showSelect: { type: Boolean, required: false, default: false }
  },
  emits: ["selectionUpdate"],
  setup(__props, { emit: __emit }) {
    const { appAccount } = useSelectedAccount();
    const registered = computed(() => {
      var _a;
      const list = ((_a = appAccount.value) == null ? void 0 : _a.data.rewardInfoList) ?? [];
      if (list.length > 0) {
        const info = list[0];
        return info.registered;
      }
      return false;
    });
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock(Fragment, null, [
        createVNode(_sfc_main$1, {
          "utxo-type": "pendingIn",
          "show-divider": false,
          "show-badge": false,
          "show-select": __props.showSelect,
          "badge-label": "",
          "badge-hint": "(pending inputs, spent utxos)",
          "badge-css": "cc-badge-green"
        }, null, 8, ["show-select"]),
        createVNode(_sfc_main$1, {
          "utxo-type": "pendingOut",
          "show-divider": false,
          "show-badge": false,
          "show-select": __props.showSelect,
          "badge-label": "",
          "badge-hint": "(pending outputs, created utxos)",
          "badge-css": "cc-badge-green"
        }, null, 8, ["show-select"]),
        createVNode(_sfc_main$1, {
          "utxo-type": "opkosk",
          "show-divider": false,
          "show-badge": registered.value,
          "show-select": __props.showSelect,
          "badge-label": "earning rewards",
          "badge-hint": "(account payment key, account stake key)",
          "badge-css": "cc-badge-green"
        }, null, 8, ["show-badge", "show-select"]),
        createVNode(_sfc_main$1, {
          "utxo-type": "opk",
          "show-select": __props.showSelect,
          "badge-label": "not staked",
          "badge-hint": "(account payment key, no stake key)"
        }, null, 8, ["show-select"]),
        createVNode(_sfc_main$1, {
          "utxo-type": "opkesk",
          "show-select": __props.showSelect,
          "badge-label": "delegated externally",
          "badge-hint": "(account payment key, external stake key)",
          "badge-css": "cc-badge-yellow"
        }, null, 8, ["show-select"]),
        createVNode(_sfc_main$1, {
          "utxo-type": "epkosk",
          "show-badge": registered.value,
          "badge-label": "external funds, but earning rewards",
          "badge-hint": "(external payment key, account stake key)"
        }, null, 8, ["show-badge"]),
        !__props.showSelect ? (openBlock(), createElementBlock("div", _hoisted_1, [
          createVNode(_sfc_main$1, {
            "utxo-type": "collateral",
            label: "wallet.summary.utxo.collateralLabel",
            "badge-label": "collateral",
            "badge-hover": "wallet.settings.collateral.tag.hover",
            "badge-css": "cc-badge-blue"
          }),
          createVNode(_sfc_main$1, {
            "utxo-type": "locked",
            label: "wallet.summary.utxo.lockedLabel"
          })
        ])) : createCommentVNode("", true)
      ], 64);
    };
  }
});
export {
  _sfc_main as _
};
