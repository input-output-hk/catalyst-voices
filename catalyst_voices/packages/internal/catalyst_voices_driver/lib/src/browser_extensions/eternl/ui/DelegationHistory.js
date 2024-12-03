import { d as defineComponent, z as ref, f as computed, D as watch, aW as addSignalListener, kr as onPoolDataUpdated, aG as onUnmounted, aX as removeSignalListener, o as openBlock, c as createElementBlock, q as createVNode, u as unref, e as createBaseVNode, t as toDisplayString, a as createBlock, j as createCommentVNode, n as normalizeClass, H as Fragment, I as renderList, aH as QPagination_default, ae as useSelectedAccount, B as useFormatter, eZ as HistoryDB } from "./index.js";
import { a as updatePoolInEpochDatumList, u as updatePoolInRewardInfo, g as getRewardInfoRefId } from "./reward.js";
import { u as useTranslation } from "./useTranslation.js";
import { _ as _sfc_main$4 } from "./FormattedAmount.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$1, a as _sfc_main$2 } from "./GridHeadline.vue_vue_type_script_setup_true_lang.js";
import { G as GridSpace } from "./GridSpace.js";
import { _ as _sfc_main$3 } from "./GridStakePoolList.vue_vue_type_script_setup_true_lang.js";
import "./NetworkId.js";
import "./useBalanceVisible.js";
import "./Clipboard.js";
import "./_plugin-vue_export-helper.js";
import "./CopyToClipboard.vue_vue_type_script_setup_true_lang.js";
import "./Tooltip.vue_vue_type_script_setup_true_lang.js";
import "./ExplorerLink.vue_vue_type_script_setup_true_lang.js";
import "./useAdaSymbol.js";
import "./InlineButton.vue_vue_type_script_setup_true_lang.js";
const _hoisted_1 = { class: "col-span-12 grid grid-cols-12 gap-2" };
const _hoisted_2 = {
  key: 0,
  class: "col-span-12 grid grid-cols-12 gap-2"
};
const _hoisted_3 = { class: "col-span-12 md:col-span-6 2xl:col-span-4 flex flex-col flex-nowrap justify-center items-center" };
const _hoisted_4 = { class: "cc-text-sx cc-text-bold" };
const _hoisted_5 = { class: "cc-text-xs cc-text-color-caption mb-1" };
const _hoisted_6 = { key: 0 };
const _hoisted_7 = {
  key: 2,
  class: "overflow-hidden cc-area-undelegated flex-1 w-full min-h-40 inline-flex flex-col flex-nowrap justify-start items-start"
};
const _hoisted_8 = { class: "relative w-full flex-1 overflow-hidden flex justify-center items-center" };
const _hoisted_9 = { class: "flex-1 w-full h-full flex flex-col flex-nowrap justify-center items-center" };
const _hoisted_10 = { class: "col-span-12 md:col-span-6 2xl:col-span-4 flex flex-col flex-nowrap justify-center items-center" };
const _hoisted_11 = { class: "cc-text-sx cc-text-bold" };
const _hoisted_12 = { class: "cc-text-xs cc-text-color-caption mb-1" };
const _hoisted_13 = { key: 0 };
const _hoisted_14 = {
  key: 2,
  class: "overflow-hidden cc-area-undelegated flex-1 w-full min-h-40 inline-flex flex-col flex-nowrap justify-start items-start"
};
const _hoisted_15 = { class: "relative w-full flex-1 overflow-hidden flex justify-center items-center" };
const _hoisted_16 = { class: "flex-1 w-full h-full flex flex-col flex-nowrap justify-center items-center" };
const _hoisted_17 = { class: "col-span-12 md:col-span-6 2xl:col-span-4 flex flex-col flex-nowrap justify-center items-center" };
const _hoisted_18 = { class: "cc-text-sx cc-text-bold" };
const _hoisted_19 = { class: "cc-text-xs cc-text-color-caption mb-1" };
const _hoisted_20 = { key: 0 };
const _hoisted_21 = {
  key: 2,
  class: "overflow-hidden cc-area-undelegated flex-1 w-full min-h-40 inline-flex flex-col flex-nowrap justify-start items-start"
};
const _hoisted_22 = { class: "relative w-full flex-1 overflow-hidden flex justify-center items-center" };
const _hoisted_23 = { class: "flex-1 w-full h-full flex flex-col flex-nowrap justify-center items-center" };
const _hoisted_24 = { class: "col-span-12 item-text" };
const _hoisted_25 = { class: "cc-area-light flex flex-col flex-nowrap p-2 md:px-4" };
const _hoisted_26 = { class: "w-full flex flex-row flex-nowrap" };
const _hoisted_27 = { class: "w-10 sm:w-12 cc-flex-fixed cc-text-bold text-left mr-1" };
const _hoisted_28 = { class: "flex-1 cc-text-bold text-left mr-1" };
const _hoisted_29 = { class: "cc-flex-fixed cc-text-bold text-right" };
const _hoisted_30 = {
  key: 0,
  class: "w-full flex flex-col flex-nowrap ring-2 ring-yellow-500 cc-rounded my-2 p-2"
};
const _hoisted_31 = { class: "w-10 sm:w-12 cc-flex-fixed text-left mr-1" };
const _hoisted_32 = { class: "w-full flex-1 text-left whitespace-nowrap truncate mr-2" };
const _hoisted_33 = {
  key: 0,
  class: "flex flex-row flex-nowrap justify-start items-center cc-space-x"
};
const _hoisted_34 = { class: "item-text truncate" };
const _hoisted_35 = {
  key: 1,
  class: "flex flex-row flex-nowrap justify-start items-center cc-space-x"
};
const _hoisted_36 = { class: "item-text-poolid truncate text-xs" };
const _hoisted_37 = {
  key: 0,
  class: ""
};
const _hoisted_38 = { class: "cc-flex-fixed text-right" };
const _hoisted_39 = {
  key: 0,
  class: "flex flex-row flex-nowrap items-center justify-end cc-text-semi-bold"
};
const _hoisted_40 = {
  key: 0,
  class: "cc-text-red"
};
const _hoisted_41 = {
  key: 1,
  class: "cc-text-green"
};
const _hoisted_42 = {
  key: 2,
  class: "cc-text-inactive"
};
const _hoisted_43 = {
  key: 2,
  class: "flex flex-row flex-nowrap items-center justify-end"
};
const _hoisted_44 = { class: "cc-text-semi-bold cc-text-yellow" };
const _hoisted_45 = {
  key: 3,
  class: "flex flex-row flex-nowrap items-center justify-end"
};
const _hoisted_46 = { class: "cc-text-semi-bold cc-text-yellow" };
const _hoisted_47 = {
  key: 4,
  class: "flex flex-row flex-nowrap items-center justify-end"
};
const _hoisted_48 = { class: "cc-text-semi-bold cc-text-inactive" };
const _hoisted_49 = { class: "cc-text-xs cc-text-color-caption" };
const _hoisted_50 = { class: "w-10 sm:w-12 cc-flex-fixed text-left mr-1" };
const _hoisted_51 = { class: "w-full flex-1 text-left mr-1 whitespace-nowrap truncate mr-2" };
const _hoisted_52 = { class: "flex flex-row flex-nowrap justify-start items-center cc-space-x" };
const _hoisted_53 = { class: "item-text truncate" };
const _hoisted_54 = { class: "cc-flex-fixed text-right" };
const _hoisted_55 = { class: "cc-text-xs cc-text-color-caption" };
const itemsOnPage = 10;
const warningThreshold = 0.2;
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "DelegationHistory",
  setup(__props) {
    const {
      selectedAccountId,
      accountData,
      accountSettings
    } = useSelectedAccount();
    const rewardInfo = accountSettings.rewardInfo;
    accountSettings.stakeKey;
    const { t } = useTranslation();
    const { formatDatetime } = useFormatter();
    const currentEpochDelegation = ref([]);
    const nextDelegation = ref([]);
    const afterNextDelegations = ref([]);
    const epochData = ref([]);
    const refId = ref(-1);
    const rewardHistoryCount = ref(0);
    const hasHistory = ref(false);
    const hasDelegation = computed(() => currentEpochDelegation.value.length > 0 || nextDelegation.value.length > 0 || afterNextDelegations.value.length > 0);
    const currentPage = ref(1);
    const showPagination = computed(() => rewardHistoryCount.value > itemsOnPage);
    const currentPageStart = computed(() => (currentPage.value - 1) * itemsOnPage);
    const maxPages = computed(() => Math.ceil(rewardHistoryCount.value / itemsOnPage));
    const warningLevel = ref("high");
    const showHigPoolFeeWarning = computed(() => {
      const ced = currentEpochDelegation.value;
      if (typeof ced[0] === "string") {
        return false;
      }
      if (Array.isArray(ced) && ced.length > 0 && "ma" in ced[0]) {
        let feePercentage = ced[0].ma;
        if (feePercentage >= warningThreshold) {
          if (feePercentage >= 0.98999999) {
            warningLevel.value = "complete";
          }
          return true;
        }
      }
      return false;
    });
    async function generateDelegationList() {
      if (!rewardInfo.value) {
        return;
      }
      const _rewardInfo = await updatePoolInRewardInfo(rewardInfo.value);
      currentEpochDelegation.value = _rewardInfo.currentEpochDelegation;
      nextDelegation.value = _rewardInfo.nextDelegation;
      afterNextDelegations.value = _rewardInfo.afterNextDelegations;
    }
    async function updateDelegationHistory() {
      if (refId.value < 0) {
        return;
      }
      let _epochData;
      if (currentPageStart.value > 0 && rewardHistoryCount.value - currentPageStart.value < rewardHistoryCount.value / 2) {
        const offset = Math.max(rewardHistoryCount.value - currentPageStart.value - itemsOnPage, 0);
        _epochData = await HistoryDB.getRewardHistory(selectedAccountId.value, refId.value, itemsOnPage, offset, false);
      } else {
        _epochData = await HistoryDB.getRewardHistory(selectedAccountId.value, refId.value, itemsOnPage, currentPageStart.value);
      }
      updatePoolInEpochDatumList(_epochData);
      epochData.value = _epochData;
      hasHistory.value = true;
      let hasCurrentEpoch = false;
      for (const data of _epochData) {
        if (data.isCurrentEpoch) {
          hasCurrentEpoch = true;
          break;
        }
      }
      if (hasCurrentEpoch && rewardHistoryCount.value <= 10) {
        let _hasHistory = false;
        for (const data of _epochData) {
          if (data.delegation || data.deregistration || data.registration) {
            _hasHistory = true;
            break;
          }
        }
        hasHistory.value = _hasHistory;
      }
    }
    watch(currentPageStart, () => updateDelegationHistory());
    async function updateRewardHistoryCount() {
      if (selectedAccountId.value.length === 0 || !rewardInfo.value) {
        return;
      }
      const refIdList = await getRewardInfoRefId(rewardInfo.value);
      if (refIdList.length === 0) {
        return;
      }
      refId.value = refIdList[0];
      const _rewardHistoryCount = rewardHistoryCount.value;
      rewardHistoryCount.value = await HistoryDB.getRewardHistoryCount(selectedAccountId.value, refId.value);
      if (_rewardHistoryCount != rewardHistoryCount.value) {
        await updateDelegationHistory();
      }
    }
    const onUpdate = async () => {
      await generateDelegationList();
      await updateRewardHistoryCount();
    };
    addSignalListener(onPoolDataUpdated, "delegationHistory", onUpdate);
    onUnmounted(() => {
      removeSignalListener(onPoolDataUpdated, "delegationHistory");
    });
    watch(rewardInfo, () => {
      onUpdate();
    }, { immediate: true });
    return (_ctx, _cache) => {
      var _a;
      return openBlock(), createElementBlock("div", _hoisted_1, [
        hasDelegation.value ? (openBlock(), createElementBlock("div", _hoisted_2, [
          createVNode(GridSpace, {
            hr: "",
            class: "mt-2 mb-1"
          }),
          createVNode(_sfc_main$1, {
            label: unref(t)("wallet.summary.stakeinfo.upcoming.label")
          }, null, 8, ["label"]),
          createVNode(_sfc_main$2, {
            text: unref(t)("wallet.summary.stakeinfo.upcoming.caption")
          }, null, 8, ["text"]),
          createVNode(GridSpace, {
            hr: "",
            class: "mt-1 mb-1"
          }),
          createBaseVNode("div", _hoisted_3, [
            createBaseVNode("span", _hoisted_4, toDisplayString(unref(t)("wallet.summary.stakeinfo.upcoming.current")) + ": " + toDisplayString(((_a = unref(rewardInfo)) == null ? void 0 : _a.currentEpochNo) ?? "?"), 1),
            createBaseVNode("span", _hoisted_5, toDisplayString(unref(rewardInfo) ? unref(formatDatetime)(unref(rewardInfo).currentEpochStart) : "-"), 1),
            currentEpochDelegation.value.length > 0 && currentEpochDelegation.value.some((d) => typeof d === "string") ? (openBlock(), createElementBlock("div", _hoisted_6, toDisplayString(currentEpochDelegation.value[0]), 1)) : currentEpochDelegation.value.length > 0 ? (openBlock(), createBlock(_sfc_main$3, {
              key: 1,
              poolList: currentEpochDelegation.value,
              delegatedPoolList: currentEpochDelegation.value
            }, null, 8, ["poolList", "delegatedPoolList"])) : (openBlock(), createElementBlock("div", _hoisted_7, [
              createBaseVNode("div", _hoisted_8, [
                createBaseVNode("div", _hoisted_9, toDisplayString(unref(t)("wallet.delegation.info.undelegated")), 1)
              ])
            ]))
          ]),
          createBaseVNode("div", _hoisted_10, [
            createBaseVNode("span", _hoisted_11, toDisplayString(unref(t)("wallet.summary.stakeinfo.upcoming.next")) + ": " + toDisplayString(unref(rewardInfo) ? unref(rewardInfo).currentEpochNo + 1 : "?"), 1),
            createBaseVNode("span", _hoisted_12, toDisplayString(unref(rewardInfo) ? unref(formatDatetime)(unref(rewardInfo).nextEpochStart) : "-"), 1),
            nextDelegation.value.length > 0 && nextDelegation.value.some((d) => typeof d === "string") ? (openBlock(), createElementBlock("div", _hoisted_13, toDisplayString(nextDelegation.value[0]), 1)) : nextDelegation.value.length > 0 ? (openBlock(), createBlock(_sfc_main$3, {
              key: 1,
              poolList: nextDelegation.value,
              delegatedPoolList: nextDelegation.value
            }, null, 8, ["poolList", "delegatedPoolList"])) : (openBlock(), createElementBlock("div", _hoisted_14, [
              createBaseVNode("div", _hoisted_15, [
                createBaseVNode("div", _hoisted_16, toDisplayString(unref(t)("wallet.delegation.info.undelegated")), 1)
              ])
            ]))
          ]),
          createBaseVNode("div", _hoisted_17, [
            createBaseVNode("span", _hoisted_18, toDisplayString(unref(t)("wallet.summary.stakeinfo.upcoming.epoch")) + ": " + toDisplayString(unref(rewardInfo) ? unref(rewardInfo).currentEpochNo + 2 : "?"), 1),
            createBaseVNode("span", _hoisted_19, toDisplayString(unref(rewardInfo) ? unref(formatDatetime)(unref(rewardInfo).afterNextEpochStart) : "-"), 1),
            afterNextDelegations.value.length > 0 && afterNextDelegations.value.some((d) => typeof d === "string") ? (openBlock(), createElementBlock("div", _hoisted_20, toDisplayString(afterNextDelegations.value[0]), 1)) : afterNextDelegations.value.length > 0 ? (openBlock(), createBlock(_sfc_main$3, {
              key: 1,
              poolList: afterNextDelegations.value,
              delegatedPoolList: afterNextDelegations.value
            }, null, 8, ["poolList", "delegatedPoolList"])) : (openBlock(), createElementBlock("div", _hoisted_21, [
              createBaseVNode("div", _hoisted_22, [
                createBaseVNode("div", _hoisted_23, toDisplayString(unref(t)("wallet.delegation.info.undelegated")), 1)
              ])
            ]))
          ])
        ])) : createCommentVNode("", true),
        createVNode(GridSpace, {
          hr: "",
          class: "mt-2 mb-1"
        }),
        hasHistory.value ? (openBlock(), createElementBlock("div", {
          key: 1,
          class: normalizeClass(["col-span-12 grid grid-cols-12 gap-2", !hasDelegation.value ? "mt-0" : ""])
        }, [
          createVNode(_sfc_main$1, {
            label: unref(t)("wallet.summary.stakeinfo.history.label")
          }, null, 8, ["label"]),
          createVNode(_sfc_main$2, {
            text: unref(t)("wallet.summary.stakeinfo.history.caption")
          }, null, 8, ["text"]),
          createBaseVNode("div", _hoisted_24, [
            createBaseVNode("div", _hoisted_25, [
              createBaseVNode("div", _hoisted_26, [
                createBaseVNode("div", _hoisted_27, toDisplayString(unref(t)("wallet.summary.stakeinfo.history.epoch")), 1),
                createBaseVNode("div", _hoisted_28, toDisplayString(unref(t)("wallet.summary.stakeinfo.history.pool")), 1),
                createBaseVNode("div", _hoisted_29, toDisplayString(unref(t)("wallet.summary.stakeinfo.history.rewards")), 1)
              ]),
              showHigPoolFeeWarning.value ? (openBlock(), createElementBlock("div", _hoisted_30, [
                createVNode(_sfc_main$1, {
                  label: unref(t)("wallet.summary.stakeinfo.warning." + warningLevel.value + ".label")
                }, null, 8, ["label"]),
                createVNode(_sfc_main$2, {
                  text: unref(t)("wallet.summary.stakeinfo.warning." + warningLevel.value + ".caption")
                }, null, 8, ["text"])
              ])) : (openBlock(), createBlock(GridSpace, {
                key: 1,
                hr: "",
                class: "my-1"
              })),
              (openBlock(true), createElementBlock(Fragment, null, renderList(epochData.value, (ed, edIndex) => {
                var _a2, _b, _c, _d, _e, _f, _g, _h, _i, _j, _k, _l, _m;
                return openBlock(), createElementBlock("div", {
                  class: "w-full flex flex-col flex-nowrap",
                  key: "epochData" + ed.epochNo + (((_a2 = ed.rewards) == null ? void 0 : _a2.type) ?? "")
                }, [
                  edIndex !== 0 ? (openBlock(), createBlock(GridSpace, {
                    key: 0,
                    hr: "",
                    class: "my-0.5"
                  })) : createCommentVNode("", true),
                  ed.rewards && ed.rewards.type === "member" ? (openBlock(), createElementBlock("div", {
                    key: 1,
                    class: normalizeClass(["flex flex-row flex-nowrap justify-start items-center item-text", ed.isCurrentEpoch ? " " : ""])
                  }, [
                    createBaseVNode("div", _hoisted_31, toDisplayString(ed.epochNo), 1),
                    createBaseVNode("div", _hoisted_32, [
                      ed.poolItem.length > 0 ? (openBlock(), createElementBlock("div", _hoisted_33, [
                        createBaseVNode("span", _hoisted_34, toDisplayString(((_b = ed.poolItem[0].md) == null ? void 0 : _b.ticker) ? "[" + ((_c = ed.poolItem[0].md) == null ? void 0 : _c.ticker) + "]" : unref(t)("common.label.noname")) + " " + toDisplayString(((_d = ed.poolItem[0].md) == null ? void 0 : _d.name) ?? ""), 1)
                      ])) : (openBlock(), createElementBlock("div", _hoisted_35, [
                        createBaseVNode("span", _hoisted_36, [
                          ((_e = ed.delegation) == null ? void 0 : _e.poolHash.bech32) ? (openBlock(), createElementBlock("span", _hoisted_37, toDisplayString((_f = ed.delegation) == null ? void 0 : _f.poolHash.bech32) + " (no data available)", 1)) : createCommentVNode("", true)
                        ])
                      ]))
                    ]),
                    createBaseVNode("div", _hoisted_38, [
                      ed.state === 0 ? (openBlock(), createElementBlock("div", _hoisted_39, [
                        ed.deregistration ? (openBlock(), createElementBlock("span", _hoisted_40, toDisplayString(unref(t)("wallet.delegation.info.deregistered")), 1)) : ed.registration ? (openBlock(), createElementBlock("span", _hoisted_41, toDisplayString(unref(t)("wallet.delegation.info.registered")), 1)) : (openBlock(), createElementBlock("span", _hoisted_42, toDisplayString(unref(t)("wallet.delegation.info.undelegated")), 1))
                      ])) : ed.rewards && ed.state === 1 ? (openBlock(), createBlock(_sfc_main$4, {
                        key: 1,
                        amount: (_g = ed.rewards) == null ? void 0 : _g.amount,
                        colored: ((_h = ed.rewards) == null ? void 0 : _h.amount) !== "0",
                        "text-c-s-s": "justify-end " + (((_i = ed.rewards) == null ? void 0 : _i.amount) === "0" ? "cc-text-red" : "")
                      }, null, 8, ["amount", "colored", "text-c-s-s"])) : ed.state === 2 ? (openBlock(), createElementBlock("div", _hoisted_43, [
                        createBaseVNode("span", _hoisted_44, toDisplayString(unref(t)("wallet.delegation.info.pending")), 1)
                      ])) : ed.state === 3 ? (openBlock(), createElementBlock("div", _hoisted_45, [
                        createBaseVNode("span", _hoisted_46, toDisplayString(unref(t)("wallet.delegation.info.producing")), 1)
                      ])) : (openBlock(), createElementBlock("div", _hoisted_47, [
                        createBaseVNode("span", _hoisted_48, toDisplayString(unref(t)("wallet.delegation.info.delegated")), 1)
                      ])),
                      createBaseVNode("div", _hoisted_49, toDisplayString(unref(formatDatetime)(ed.tsSpendable)), 1)
                    ])
                  ], 2)) : (openBlock(), createElementBlock("div", {
                    key: 2,
                    class: normalizeClass(["flex flex-row flex-nowrap justify-start items-center item-text", ed.isCurrentEpoch ? " " : ""])
                  }, [
                    createBaseVNode("div", _hoisted_50, toDisplayString(ed.epochNo), 1),
                    createBaseVNode("div", _hoisted_51, [
                      createBaseVNode("div", _hoisted_52, [
                        createBaseVNode("span", _hoisted_53, [
                          createBaseVNode("span", null, toDisplayString(unref(t)("wallet.summary.stakeinfo.history." + ((_j = ed.rewards) == null ? void 0 : _j.type))), 1)
                        ])
                      ])
                    ]),
                    createBaseVNode("div", _hoisted_54, [
                      ed.rewards ? (openBlock(), createBlock(_sfc_main$4, {
                        key: 0,
                        amount: (_k = ed.rewards) == null ? void 0 : _k.amount,
                        colored: ((_l = ed.rewards) == null ? void 0 : _l.amount) !== "0",
                        "text-c-s-s": "justify-end " + (((_m = ed.rewards) == null ? void 0 : _m.amount) === "0" ? "cc-text-red" : "")
                      }, null, 8, ["amount", "colored", "text-c-s-s"])) : createCommentVNode("", true),
                      createBaseVNode("div", _hoisted_55, toDisplayString(unref(formatDatetime)(ed.tsSpendable)), 1)
                    ])
                  ], 2))
                ]);
              }), 128)),
              showPagination.value ? (openBlock(), createBlock(GridSpace, {
                key: 2,
                hr: "",
                class: "mt-0.5 mb-2"
              })) : createCommentVNode("", true),
              showPagination.value ? (openBlock(), createBlock(QPagination_default, {
                key: 3,
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
                "active-design": "unelevated",
                class: "self-center"
              }, null, 8, ["modelValue", "max"])) : createCommentVNode("", true)
            ])
          ])
        ], 2)) : createCommentVNode("", true)
      ]);
    };
  }
});
export {
  _sfc_main as default
};
