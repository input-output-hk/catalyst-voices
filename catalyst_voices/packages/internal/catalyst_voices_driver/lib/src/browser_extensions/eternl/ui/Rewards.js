import { d as defineComponent, f as computed, dm as getRewardAddressFromCred, K as networkId, u as unref, o as openBlock, c as createElementBlock, q as createVNode, e as createBaseVNode, t as toDisplayString, j as createCommentVNode, ae as useSelectedAccount, z as ref, C as onMounted, aG as onUnmounted, D as watch, n as normalizeClass, B as useFormatter, kn as getCalculatedEpoch, e_ as getRewardHistory, ko as getEpochStart, cZ as multiply, a7 as useQuasar, a8 as SyncState, c3 as isZero, aW as addSignalListener, gS as onEpochParamsUpdated, aX as removeSignalListener, a as createBlock, b as withModifiers, cf as getRandomId, aY as checkEpochParams, kp as onBuiltTxWithdrawal, g3 as getTxBuiltErrorMsg, f_ as ErrorBuildTx, bm as dispatchSignal, kq as doBuildTxWithdrawal } from "./index.js";
import { g as getRewardInfoRefId } from "./reward.js";
import { u as useNavigation } from "./useNavigation.js";
import { u as useTranslation } from "./useTranslation.js";
import { u as useAdaSymbol } from "./useAdaSymbol.js";
import { _ as _sfc_main$4 } from "./CopyToClipboard.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$5 } from "./ExplorerLink.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$3, a as _sfc_main$6 } from "./GridHeadline.vue_vue_type_script_setup_true_lang.js";
import { u as useBalanceVisible } from "./useBalanceVisible.js";
import { C as Chart, A as ArcElement, L as LineElement, B as BarElement, P as PointElement, e as BarController, f as BubbleController, D as DoughnutController, d as LineController, g as PieController, h as PolarAreaController, R as RadarController, S as ScatterController, b as CategoryScale, c as LinearScale, i as LogarithmicScale, j as RadialLinearScale, k as TimeScale, T as TimeSeriesScale, l as plugin_decimation, m as index, n as plugin_legend, o as plugin_title, p as plugin_tooltip } from "./chart.js";
import { G as GridSpace } from "./GridSpace.js";
import { G as GridButtonSecondary } from "./GridButtonSecondary.js";
import { _ as _sfc_main$7 } from "./GridTextArea.vue_vue_type_script_setup_true_lang.js";
import "./NetworkId.js";
import "./useTabId.js";
import "./Tooltip.vue_vue_type_script_setup_true_lang.js";
import "./Clipboard.js";
import "./_plugin-vue_export-helper.js";
import "./GridButton.vue_vue_type_script_setup_true_lang.js";
const _hoisted_1$2 = { key: 0 };
const _hoisted_2$2 = { class: "flex flex-col col-span-12 items-start" };
const _hoisted_3$1 = { class: "flex flex-row flex-nowrap col-span-12 items-start" };
const _hoisted_4 = {
  key: 0,
  class: "cc-text-xs cc-text-normal justify-end cc-text-color-caption ml-5"
};
const _sfc_main$2 = /* @__PURE__ */ defineComponent({
  __name: "GridStakeAddr",
  setup(__props) {
    const { t } = useTranslation();
    const {
      selectedAccountId,
      selectedWalletId,
      accountSettings,
      walletSettings
    } = useSelectedAccount();
    const rewardInfo = accountSettings.rewardInfo;
    const stakeKey = accountSettings.stakeKey;
    const path = accountSettings.stakeKeyPath;
    const identifier = computed(() => walletSettings.plate.value.checksum ?? "");
    const address = computed(() => {
      if (stakeKey.value) {
        return getRewardAddressFromCred(stakeKey.value.cred, networkId.value);
      }
      return "";
    });
    return (_ctx, _cache) => {
      return unref(stakeKey) ? (openBlock(), createElementBlock("div", _hoisted_1$2, [
        createVNode(_sfc_main$3, {
          label: unref(t)("wallet.summary.stakeinfo.key.label")
        }, null, 8, ["label"]),
        createBaseVNode("div", _hoisted_2$2, [
          createBaseVNode("div", _hoisted_3$1, [
            createVNode(_sfc_main$4, {
              "label-hover": unref(t)("wallet.transactions.button.copy.address.hover"),
              "notification-text": unref(t)("wallet.transactions.button.copy.address.notify"),
              "copy-text": address.value,
              class: "flex inline-flex items-center justify-center"
            }, null, 8, ["label-hover", "notification-text", "copy-text"]),
            createVNode(_sfc_main$5, {
              subject: unref(rewardInfo),
              type: "stake",
              label: address.value,
              "label-c-s-s": "cc-addr ml-1"
            }, null, 8, ["subject", "label"])
          ]),
          unref(path) ? (openBlock(), createElementBlock("span", _hoisted_4, toDisplayString(unref(path)) + toDisplayString(identifier.value ? " - " + identifier.value : ""), 1)) : createCommentVNode("", true)
        ])
      ])) : createCommentVNode("", true);
    };
  }
});
const _hoisted_1$1 = { class: "col-span-12 mb-1 cc-text-semi-bold flex justify-between items-center" };
const _hoisted_2$1 = { class: "col-span-12 cc-area-light p-2 pr-3 md:pl-2.5 md:pr-4" };
const _sfc_main$1 = /* @__PURE__ */ defineComponent({
  __name: "RewardChart",
  setup(__props) {
    Chart.register(
      ArcElement,
      LineElement,
      BarElement,
      PointElement,
      BarController,
      BubbleController,
      DoughnutController,
      LineController,
      PieController,
      PolarAreaController,
      RadarController,
      ScatterController,
      CategoryScale,
      LinearScale,
      LogarithmicScale,
      RadialLinearScale,
      TimeScale,
      TimeSeriesScale,
      plugin_decimation,
      index,
      plugin_legend,
      plugin_title,
      plugin_tooltip
    );
    const { it } = useTranslation();
    const {
      formatDatetime,
      formatADAString,
      formatADAValue,
      getDecimalNumber
    } = useFormatter();
    const { isBalanceVisible } = useBalanceVisible();
    const decimalNumber = getDecimalNumber();
    const {
      selectedAccountId,
      accountSettings
    } = useSelectedAccount();
    const rewardInfo = accountSettings.rewardInfo;
    accountSettings.stakeKey;
    const canvasRef = ref(null);
    const isCalculating = ref(false);
    const hasChartData = ref(false);
    const hideIfNoData = ref(true);
    ref("4px");
    let chart = null;
    let chartData = [];
    let chartLabels = [];
    function renderChart() {
      hideIfNoData.value = hasChartData.value;
      if (!canvasRef.value) {
        return;
      }
      const ctx = canvasRef.value.getContext("2d") ?? null;
      if (ctx && chartData.length > 0) {
        if (chart) {
          chart.destroy();
        }
        let backgroundColorPreset, borderColorPreset;
        backgroundColorPreset = "rgba(54, 162, 235, 0.2)";
        borderColorPreset = "rgba(54, 162, 235, 1)";
        chart = new Chart(ctx, {
          type: "bar",
          data: {
            labels: chartLabels,
            datasets: [{
              label: "Rewards",
              data: chartData,
              backgroundColor: backgroundColorPreset,
              borderColor: borderColorPreset,
              borderWidth: 1
            }]
          },
          options: {
            plugins: {
              tooltip: {
                callbacks: {
                  title: function(context) {
                    var _a;
                    const epochNo = Number(((_a = context[0].label) == null ? void 0 : _a.substr(1)) ?? 0);
                    if (epochNo === 0) return "Epoch Invalid";
                    return "Epoch " + epochNo;
                  },
                  footer: function(context) {
                    var _a;
                    const epochNo = Number(((_a = context[0].label) == null ? void 0 : _a.substr(1)) ?? 0);
                    if (epochNo === 0) return "Epoch Invalid";
                    return formatDatetime(getEpochStart(networkId.value, epochNo + 2).timestamp);
                  },
                  label: function(context) {
                    let label = "";
                    const lovelace = Number.isNaN(context.parsed.y) ? "0" : multiply(context.parsed.y, decimalNumber);
                    if (context.parsed.y !== null) {
                      label = " " + formatADAString(lovelace, isBalanceVisible.value);
                    }
                    return label;
                  },
                  labelTextColor: function(context) {
                    return "#34D399";
                  }
                },
                bodyFont: {
                  weight: "bold"
                },
                footerFont: {
                  size: 10
                }
              }
            },
            scales: {
              y: {
                beginAtZero: true,
                display: isBalanceVisible.value
              }
            },
            locale: "en-US"
          },
          // @ts-ignore
          crosshair: {
            enabled: false,
            sync: {
              enabled: false
            },
            pan: {
              enabled: false
            },
            snap: {
              enabled: false
            }
          }
        });
      }
    }
    async function generateChartData() {
      if (isCalculating.value) {
        return;
      }
      isCalculating.value = true;
      let currentEpochNo = getCalculatedEpoch(networkId.value);
      let refIdList = null;
      if (rewardInfo.value) {
        refIdList = await getRewardInfoRefId(rewardInfo.value);
      }
      if (currentEpochNo && refIdList && refIdList.length > 0) {
        const epochData = await getRewardHistory(selectedAccountId.value, refIdList[0], 24);
        chartLabels.length = 0;
        chartData.length = 0;
        let minEpoch = epochData.reduce((previousValue, currentValue) => currentValue.epochNo < previousValue ? currentValue.epochNo : previousValue, Number.MAX_SAFE_INTEGER);
        if (minEpoch === Number.MAX_SAFE_INTEGER) {
          for (let i = currentEpochNo - 10; i < currentEpochNo; i++) {
            chartLabels.push("e" + i);
            chartData.push({ x: 0, y: 0 });
          }
        } else {
          if (minEpoch < currentEpochNo - 20) {
            minEpoch = Math.max(minEpoch, currentEpochNo - 20);
            chartLabels.push("...");
            chartData.push({ y: 0, x: "..." });
          }
          for (let i = minEpoch; i < currentEpochNo - 1; i++) {
            const reward = epochData.find((item) => item.epochNo === i);
            if (reward == null ? void 0 : reward.rewards) {
              chartLabels.push("e" + reward.epochNo);
              chartData.push({ y: parseFloat(formatADAValue(reward.rewards.amount)), x: reward.epochNo });
            } else {
              chartLabels.push("e" + i);
              chartData.push({ x: 0, y: 0 });
            }
          }
        }
        hasChartData.value = chartData.length > 0;
        renderChart();
      } else if (currentEpochNo && chartData.length === 0) {
        for (let i = currentEpochNo - 5; i < currentEpochNo; i++) {
          chartLabels.push("epoch " + i);
          chartData.push({ x: 0, y: 0 });
        }
        hasChartData.value = chartData.length > 0;
        renderChart();
      }
      isCalculating.value = false;
    }
    onMounted(() => {
      generateChartData();
    });
    onUnmounted(() => {
      if (chart) {
        chart.destroy();
        hasChartData.value = false;
      }
    });
    watch(rewardInfo, () => {
      generateChartData();
    }, { deep: true });
    watch(isBalanceVisible, () => {
      generateChartData();
    });
    window.addEventListener("resize", () => {
      generateChartData();
    });
    return (_ctx, _cache) => {
      return hideIfNoData.value ? (openBlock(), createElementBlock("div", {
        key: 0,
        class: normalizeClass(["grid grid-cols-12", unref(networkId) === "mainnet" ? "col-span-12 md:col-span-6" : "col-span-12 md:col-span-6 " + (hasChartData.value ? "opacity-100" : "opacity-0")])
      }, [
        createBaseVNode("div", _hoisted_1$1, [
          createBaseVNode("span", null, toDisplayString(unref(it)("common.label.rewardsHistory")), 1)
        ]),
        createBaseVNode("div", _hoisted_2$1, [
          createBaseVNode("canvas", {
            ref_key: "canvasRef",
            ref: canvasRef,
            "aria-label": "rewards chart",
            role: "img"
          }, null, 512)
        ])
      ], 2)) : createCommentVNode("", true);
    };
  }
});
const _hoisted_1 = {
  key: 0,
  class: "col-span-12 flex flex-col"
};
const _hoisted_2 = {
  key: 0,
  class: "col-span-12 w-full"
};
const _hoisted_3 = {
  key: 1,
  class: "col-span-12"
};
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "Rewards",
  setup(__props) {
    const storeId = "Rewards" + getRandomId();
    const $q = useQuasar();
    const { it } = useTranslation();
    const { gotoWalletPage } = useNavigation();
    const { adaSymbol } = useAdaSymbol();
    const {
      selectedWalletId,
      selectedAccountId,
      appAccount,
      accountData,
      accountSettings
    } = useSelectedAccount();
    const rewardInfo = accountSettings.rewardInfo;
    let epochParams = null;
    const updateEpochParams = () => {
      try {
        epochParams = checkEpochParams(networkId.value);
      } catch (e) {
        console.error(e);
      }
    };
    updateEpochParams();
    const syncInfo = computed(() => {
      var _a;
      return (_a = appAccount.value) == null ? void 0 : _a.syncInfo;
    });
    const isSyncing = computed(() => {
      var _a;
      return ((_a = syncInfo.value) == null ? void 0 : _a.state) === SyncState.syncing;
    });
    const showWithdrawButton = computed(() => {
      var _a;
      return !isZero(((_a = accountData.value) == null ? void 0 : _a.balance.rewards) ?? "0") && !isSyncing.value;
    });
    const hasStakeHistory = ref(false);
    async function makeWithdrawal() {
      addSignalListener(onBuiltTxWithdrawal, storeId, (res, error) => {
        removeSignalListener(onBuiltTxWithdrawal, storeId);
        if (res == null ? void 0 : res.error) {
          const { msg, isWarning } = getTxBuiltErrorMsg(res ? res.error : ErrorBuildTx.missingAccountData, 0, { value: 0 }, adaSymbol);
          if (msg.length > 0) {
            $q.notify({
              type: isWarning ? "warning" : "negative",
              message: msg,
              position: "top-left",
              timeout: 8e3
            });
          }
        } else if (error) {
          $q.notify({
            type: "negative",
            message: error,
            position: "top-left",
            timeout: 8e3
          });
        }
      });
      await dispatchSignal(doBuildTxWithdrawal);
      removeSignalListener(onBuiltTxWithdrawal, storeId);
    }
    const checkStakeHistory = async () => {
      var _a;
      const rewardInfo2 = accountSettings.rewardInfo;
      if ((((_a = rewardInfo2.value) == null ? void 0 : _a.rewardCount) ?? 0) > 0) {
        hasStakeHistory.value = true;
        return;
      }
      let refIdList = null;
      if (rewardInfo2.value) {
        refIdList = await getRewardInfoRefId(rewardInfo2.value);
      }
      let currentEpochNo = getCalculatedEpoch(networkId.value);
      if (currentEpochNo && refIdList && refIdList.length > 0) {
        const epochData = await getRewardHistory(selectedAccountId.value, refIdList[0], 1);
        if (epochData.length > 0) {
          hasStakeHistory.value = true;
          return;
        }
      }
      hasStakeHistory.value = false;
    };
    const onGoToStaking = () => {
      gotoWalletPage("Staking");
    };
    const onGoToVoteDelegation = () => {
      gotoWalletPage("Voting", "governance");
    };
    onMounted(() => addSignalListener(onEpochParamsUpdated, storeId, updateEpochParams));
    onUnmounted(() => removeSignalListener(onEpochParamsUpdated, storeId));
    onMounted(async () => {
      await checkStakeHistory();
    });
    return (_ctx, _cache) => {
      var _a, _b, _c, _d, _e, _f, _g, _h;
      return openBlock(), createElementBlock("div", {
        class: normalizeClass(["grid grid-cols-12 gap-4 cc-text-sz", unref(networkId) === "mainnet" ? "col-span-12" : "col-span-12 md:col-span-12 "])
      }, [
        hasStakeHistory.value || ((_a = unref(rewardInfo)) == null ? void 0 : _a.registered) ? (openBlock(), createBlock(_sfc_main$1, { key: 0 })) : createCommentVNode("", true),
        createBaseVNode("div", {
          class: normalizeClass(["grid grid-cols-12 gap-4 cc-text-sz justify-end items-start", !((_b = unref(rewardInfo)) == null ? void 0 : _b.registered) ? "col-span-12 md:col-span-6" : "col-span-12 md:col-span-6"])
        }, [
          ((_c = unref(rewardInfo)) == null ? void 0 : _c.registered) ? (openBlock(), createElementBlock("div", _hoisted_1, [
            createVNode(_sfc_main$3, {
              label: unref(it)("wallet.summary.withdrawal.label")
            }, null, 8, ["label"]),
            createVNode(_sfc_main$6, {
              text: unref(it)("wallet.summary.withdrawal.text")
            }, null, 8, ["text"]),
            createVNode(GridSpace, { class: "my-1" }),
            createVNode(GridButtonSecondary, {
              class: "w-full text-right truncate mt-1",
              disabled: !showWithdrawButton.value,
              type: "button",
              label: isSyncing.value ? unref(it)("wallet.summary.withdrawal.button.syncing") : !showWithdrawButton.value ? unref(it)("wallet.summary.withdrawal.button.norewards") : unref(it)("wallet.summary.withdrawal.button.label"),
              onClick: _cache[0] || (_cache[0] = withModifiers(($event) => makeWithdrawal(), ["stop"]))
            }, null, 8, ["disabled", "label"]),
            createVNode(_sfc_main$2, { class: "mt-2" }),
            unref(epochParams) && unref(epochParams).isAtLeastConwayEra ? (openBlock(), createElementBlock("div", _hoisted_2, [
              unref(epochParams).isAtLeastConwayEra2 && (((_d = unref(rewardInfo)) == null ? void 0 : _d.govDelegationList.length) ?? 0) === 0 ? (openBlock(), createBlock(_sfc_main$7, {
                key: 0,
                class: "mt-2 cc-flex-fixed",
                css: "cc-text-semi-bold cc-rounded cc-banner-warning",
                "text-c-s-s": "",
                text: unref(it)("wallet.summary.stakeinfo.gov.nodelegation.warn"),
                icon: unref(it)("wallet.summary.stakeinfo.gov.icon.warning")
              }, null, 8, ["text", "icon"])) : unref(epochParams).isAtLeastConwayEra && (((_e = unref(rewardInfo)) == null ? void 0 : _e.govDelegationList.length) ?? 0) === 0 ? (openBlock(), createBlock(_sfc_main$7, {
                key: 1,
                class: "mt-2 cc-flex-fixed",
                css: "cc-rounded cc-banner-blue",
                "text-c-s-s": "",
                text: unref(it)("wallet.summary.stakeinfo.gov.nodelegation.info"),
                icon: unref(it)("wallet.summary.stakeinfo.gov.icon.info")
              }, null, 8, ["text", "icon"])) : !((_f = unref(rewardInfo)) == null ? void 0 : _f.hasActiveDRep) ? (openBlock(), createBlock(_sfc_main$7, {
                key: 2,
                class: "mt-2 cc-flex-fixed",
                css: "cc-text-semi-bold cc-rounded cc-banner-warning",
                "text-c-s-s": "",
                text: unref(it)("wallet.summary.stakeinfo.gov.inactive"),
                icon: unref(it)("wallet.summary.stakeinfo.gov.icon.warning")
              }, null, 8, ["text", "icon"])) : createCommentVNode("", true),
              (((_g = unref(rewardInfo)) == null ? void 0 : _g.govDelegationList.length) ?? 0) === 0 || !((_h = unref(rewardInfo)) == null ? void 0 : _h.hasActiveDRep) ? (openBlock(), createBlock(GridButtonSecondary, {
                key: 3,
                class: "w-full mt-2",
                label: unref(it)("wallet.voting.governance.delegation.new.button.governance"),
                onClick: _cache[1] || (_cache[1] = withModifiers(($event) => onGoToVoteDelegation(), ["stop"]))
              }, null, 8, ["label"])) : createCommentVNode("", true)
            ])) : createCommentVNode("", true)
          ])) : (openBlock(), createElementBlock("div", _hoisted_3, [
            createVNode(_sfc_main$3, {
              label: unref(it)("wallet.summary.withdrawal.staking.label")
            }, null, 8, ["label"]),
            createVNode(_sfc_main$6, {
              text: unref(it)("wallet.summary.withdrawal.staking.text")
            }, null, 8, ["text"]),
            createVNode(_sfc_main$2, { class: "mt-2" }),
            createVNode(GridSpace, { class: "my-1" }),
            createVNode(GridButtonSecondary, {
              class: "w-full text-right truncate mt-1",
              label: unref(it)("wallet.summary.withdrawal.staking.button"),
              onClick: _cache[2] || (_cache[2] = withModifiers(($event) => onGoToStaking(), ["stop"]))
            }, null, 8, ["label"])
          ]))
        ], 2)
      ], 2);
    };
  }
});
export {
  _sfc_main as default
};
