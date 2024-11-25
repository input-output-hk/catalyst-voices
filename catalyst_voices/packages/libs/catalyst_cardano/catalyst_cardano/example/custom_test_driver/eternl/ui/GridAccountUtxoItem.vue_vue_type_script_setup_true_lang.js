import { d as defineComponent, a5 as toRefs, z as ref, f as computed, u as unref, o as openBlock, c as createElementBlock, e as createBaseVNode, a as createBlock, aH as QPagination_default, j as createCommentVNode, t as toDisplayString, q as createVNode, H as Fragment, I as renderList, n as normalizeClass, b as withModifiers, h as withCtx, i as createTextVNode, ab as withKeys, bi as getUtxoHash, fM as dispatchSignalSyncTo, jZ as doToggleLockedUtxo, j_ as doToggleSelectedUtxo, ae as useSelectedAccount } from "./index.js";
import { u as useTranslation } from "./useTranslation.js";
import { _ as _sfc_main$4 } from "./IconButton.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$1 } from "./CopyToClipboard.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$5 } from "./FormattedAmount.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$3 } from "./Tooltip.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$2 } from "./ExplorerLink.vue_vue_type_script_setup_true_lang.js";
import { G as GridSpace } from "./GridSpace.js";
import { _ as _sfc_main$6 } from "./GridTxListUtxoTokenList.vue_vue_type_script_setup_true_lang.js";
const _hoisted_1 = {
  key: 0,
  class: "col-span-12 cc-text-sz"
};
const _hoisted_2 = { class: "col-span-12 min-w-96 flex justify-center" };
const _hoisted_3 = { class: "w-full flex flex-col flex-nowrap" };
const _hoisted_4 = { class: "cc-text-sm cc-text-semi-bold flex justify-between" };
const _hoisted_5 = {
  key: 0,
  class: "cc-text-xs cc-text-normal justify-end cc-text-color-caption"
};
const _hoisted_6 = { class: "w-full flex flex-row flex-nowrap justify-start items-start pt-1.5 space-x-0.5" };
const _hoisted_7 = { class: "w-full flex flex-row flex-nowrap justify-between mb-1" };
const _hoisted_8 = { class: "cc-text-sm cc-text-semi-bold" };
const _hoisted_9 = { class: "cc-text-sm cc-text-semi-bold" };
const _hoisted_10 = { class: "flex flex-row flex-nowrap whitespace-pre-wrap justify-start items-start pt-0.5" };
const _hoisted_11 = { class: "flex-0 mr-0.5" };
const _hoisted_12 = ["onClick"];
const _hoisted_13 = { class: "flex flex-row flex-nowrap justify-start items-start pt-1" };
const _hoisted_14 = { class: "pt-0.5" };
const _hoisted_15 = { class: "col-span-12 min-w-96 flex justify-center" };
const itemsOnPage = 10;
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "GridAccountUtxoItem",
  props: {
    utxoItem: { type: Object, required: true },
    showSelect: { type: Boolean, required: false, default: false },
    hideLock: { type: Boolean, required: false, default: false }
  },
  setup(__props) {
    const props = __props;
    const { utxoItem } = toRefs(props);
    const { it } = useTranslation();
    const {
      appAccount,
      utxoMap
    } = useSelectedAccount();
    const currentPage = ref(1);
    const showPagination = computed(() => ((utxoItem == null ? void 0 : utxoItem.value.list.length) ?? 0) > itemsOnPage);
    const maxPages = computed(() => Math.ceil(((utxoItem == null ? void 0 : utxoItem.value.list.length) ?? 0) / itemsOnPage));
    const currentPageStart = computed(() => (currentPage.value - 1) * itemsOnPage);
    const utxoListFiltered = computed(() => (utxoItem == null ? void 0 : utxoItem.value.list.slice(currentPageStart.value, currentPageStart.value + itemsOnPage)) ?? []);
    const isLocked = (utxo) => {
      var _a;
      return ((_a = utxoMap.value) == null ? void 0 : _a.locked.includes(getUtxoHash(utxo.input))) ?? false;
    };
    const isSelected = (utxo) => {
      var _a;
      return ((_a = utxoMap.value) == null ? void 0 : _a.selected.includes(getUtxoHash(utxo.input))) ?? false;
    };
    const onToggleLock = (utxo) => {
      dispatchSignalSyncTo(appAccount.value.id, doToggleLockedUtxo, utxo);
    };
    const onToggleSelected = (utxo) => {
      if (isLocked(utxo) || !appAccount.value) {
        return;
      }
      dispatchSignalSyncTo(appAccount.value.id, doToggleSelectedUtxo, utxo);
    };
    return (_ctx, _cache) => {
      return unref(utxoItem) ? (openBlock(), createElementBlock("div", _hoisted_1, [
        createBaseVNode("div", {
          class: normalizeClass(["cc-area-light flex flex-col flex-nowrap p-2", !__props.showSelect ? "md:px-4" : ""])
        }, [
          createBaseVNode("div", _hoisted_2, [
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
            key: 0,
            hr: "",
            class: "mt-2 mb-2"
          })) : createCommentVNode("", true),
          createBaseVNode("div", _hoisted_3, [
            createBaseVNode("div", _hoisted_4, [
              createBaseVNode("div", null, toDisplayString(unref(it)("wallet.summary.utxo.address")), 1),
              unref(utxoItem).pathInfo ? (openBlock(), createElementBlock("span", _hoisted_5, "(" + toDisplayString(unref(utxoItem).pathInfo) + ")", 1)) : createCommentVNode("", true)
            ]),
            createBaseVNode("div", _hoisted_6, [
              createVNode(_sfc_main$1, {
                "label-hover": unref(it)("wallet.summary.button.copy.utxo.address.hover"),
                "label-c-s-s": "",
                "notification-text": unref(it)("wallet.summary.button.copy.utxo.address.notify"),
                "copy-text": unref(utxoItem).bech32,
                class: ""
              }, null, 8, ["label-hover", "notification-text", "copy-text"]),
              createVNode(_sfc_main$2, {
                subject: unref(utxoItem),
                type: "address",
                label: unref(utxoItem).bech32,
                "label-c-s-s": "cc-addr text-left break-all"
              }, null, 8, ["subject", "label"])
            ])
          ]),
          createVNode(GridSpace, {
            hr: "",
            class: "my-2"
          }),
          createBaseVNode("div", _hoisted_7, [
            createBaseVNode("span", _hoisted_8, toDisplayString(unref(it)("wallet.summary.utxo.txhash")), 1),
            createBaseVNode("span", _hoisted_9, toDisplayString(unref(it)("wallet.summary.utxo.balance")), 1)
          ]),
          (openBlock(true), createElementBlock(Fragment, null, renderList(utxoListFiltered.value, (utxo, u_index) => {
            return openBlock(), createElementBlock("div", {
              class: "w-full flex flex-col flex-nowrap",
              key: u_index
            }, [
              u_index !== 0 ? (openBlock(), createBlock(GridSpace, {
                key: 0,
                hr: "",
                class: "my-2"
              })) : createCommentVNode("", true),
              createBaseVNode("div", {
                class: normalizeClass(["relative w-full flex flex-col sm:flex-row flex-nowrap justify-between space-x-2", isSelected(utxo) ? "px-1 cc-selected cc-rounded" : __props.hideLock ? "px-0" : "px-0"])
              }, [
                createBaseVNode("div", _hoisted_10, [
                  createBaseVNode("div", _hoisted_11, [
                    __props.showSelect ? (openBlock(), createElementBlock("div", {
                      key: 0,
                      class: normalizeClass(["px-1.5 mr-2 mt-1 mb-1.5 rounded cc-tabs-button", isLocked(utxo) ? "hover:cc-border-color" : "cursor-pointer"]),
                      onClick: withModifiers(($event) => onToggleSelected(utxo), ["prevent", "stop"])
                    }, [
                      createBaseVNode("i", {
                        class: normalizeClass(["text-lg", isLocked(utxo) ? "mdi mdi-lock-outline cc-text-red-light " : isSelected(utxo) ? "mdi mdi-minus cc-text-red-light " : "mdi mdi-plus cc-text-green "])
                      }, null, 2),
                      isLocked(utxo) ? (openBlock(), createBlock(_sfc_main$3, {
                        key: 0,
                        anchor: "bottom middle",
                        "transition-show": "scale",
                        "transition-hide": "scale"
                      }, {
                        default: withCtx(() => [
                          createTextVNode(toDisplayString(unref(it)("wallet.send.builder.modal.input.lockedHover")), 1)
                        ]),
                        _: 1
                      })) : createCommentVNode("", true)
                    ], 10, _hoisted_12)) : createCommentVNode("", true),
                    !__props.showSelect && !__props.hideLock ? (openBlock(), createBlock(_sfc_main$4, {
                      key: 1,
                      class: normalizeClass(["flex-none pointer-events-auto cursor-pointer px-1.5 mr-2 rounded cc-tabs-button", isLocked(utxo) ? " cc-text-red-light " : " cc-text-green "]),
                      icon: isLocked(utxo) ? "mdi mdi-lock-outline " : "mdi mdi-lock-open-outline ",
                      tabindex: "0",
                      "aria-label": isLocked(utxo) ? "unlock utxo" : "lock utxo",
                      onKeydown: [
                        withKeys(($event) => onToggleLock(utxo), ["enter"]),
                        withKeys(($event) => onToggleLock(utxo), ["space"])
                      ],
                      onClick: withModifiers(($event) => onToggleLock(utxo), ["stop"])
                    }, null, 8, ["icon", "class", "aria-label", "onKeydown", "onClick"])) : createCommentVNode("", true)
                  ]),
                  createBaseVNode("div", _hoisted_13, [
                    createVNode(_sfc_main$1, {
                      "label-hover": unref(it)("wallet.summary.button.copy.utxo.txhash.hover"),
                      "label-c-s-s": "cc-addr",
                      "notification-text": unref(it)("wallet.summary.button.copy.utxo.txhash.notify"),
                      "copy-text": unref(getUtxoHash)(utxo.input),
                      class: "flex flex-row flex-nowrap items-center mr-0.5"
                    }, null, 8, ["label-hover", "notification-text", "copy-text"]),
                    createVNode(_sfc_main$2, {
                      subject: utxo.input.transaction_id,
                      type: "transaction",
                      label: unref(getUtxoHash)(utxo.input),
                      "label-c-s-s": "cc-addr text-left break-all",
                      class: "mr-0.5"
                    }, null, 8, ["subject", "label"])
                  ])
                ]),
                createBaseVNode("div", _hoisted_14, [
                  createVNode(_sfc_main$5, {
                    amount: utxo.output.amount.coin,
                    "text-c-s-s": "w-full justify-end"
                  }, null, 8, ["amount"]),
                  createVNode(_sfc_main$6, {
                    balance: utxo.output.amount
                  }, null, 8, ["balance"])
                ])
              ], 2)
            ]);
          }), 128)),
          showPagination.value ? (openBlock(), createBlock(GridSpace, {
            key: 1,
            hr: "",
            class: "mt-2 mb-2"
          })) : createCommentVNode("", true),
          createBaseVNode("div", _hoisted_15, [
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
        ], 2)
      ])) : createCommentVNode("", true);
    };
  }
});
export {
  _sfc_main as _
};
