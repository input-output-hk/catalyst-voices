const __vite__mapDeps=(i,m=__vite__mapDeps,d=(m.f||(m.f=["ui/Rewards.js","ui/index.js","ui/NetworkId.js","assets/index.css","ui/reward.js","ui/useNavigation.js","ui/useTabId.js","ui/useTranslation.js","ui/useAdaSymbol.js","ui/CopyToClipboard.vue_vue_type_script_setup_true_lang.js","ui/Tooltip.vue_vue_type_script_setup_true_lang.js","ui/Clipboard.js","ui/ExplorerLink.vue_vue_type_script_setup_true_lang.js","ui/GridHeadline.vue_vue_type_script_setup_true_lang.js","ui/useBalanceVisible.js","ui/chart.js","ui/GridSpace.js","ui/_plugin-vue_export-helper.js","assets/GridSpace.css","ui/GridButtonSecondary.js","ui/GridButton.vue_vue_type_script_setup_true_lang.js","assets/GridButtonSecondary.css","ui/GridTextArea.vue_vue_type_script_setup_true_lang.js","ui/DelegationHistory.js","ui/FormattedAmount.vue_vue_type_script_setup_true_lang.js","ui/GridStakePoolList.vue_vue_type_script_setup_true_lang.js","ui/InlineButton.vue_vue_type_script_setup_true_lang.js","assets/GridStakePoolList.css","ui/QuickAccessList.js","ui/DAppIframe.vue_vue_type_script_setup_true_lang.js","ui/GridButtonCountdown.vue_vue_type_script_setup_true_lang.js","ui/GridButtonPrimary.vue_vue_type_script_setup_true_lang.js","assets/QuickAccessList.css","ui/AccountBalance.js","ui/AccountUtxoBalance.vue_vue_type_script_setup_true_lang.js","ui/Modal.js","assets/Modal.css","ui/ExternalLink.vue_vue_type_script_setup_true_lang.js","ui/GridAccountTokenBalance.js","ui/GridTokenList.vue_vue_type_script_setup_true_lang.js","ui/vue-json-pretty.js","assets/vue-json-pretty.css","ui/IconPencil.js","ui/GridInput.js","ui/IconError.js","assets/GridInput.css","ui/GridTabs.vue_vue_type_script_setup_true_lang.js","ui/lz-string.js","ui/image.js","ui/ExtBackground.js","ui/defaultLogo.js","assets/GridTokenList.css","ui/AccountList.js","ui/useTrezorDevice.js","ui/Keystone.vue_vue_type_script_setup_true_lang.js","ui/browser.js","ui/GridLoading.vue_vue_type_script_setup_true_lang.js","ui/IconInfo.js","ui/GridFormSignWithPassword.vue_vue_type_script_setup_true_lang.js","ui/GridForm.vue_vue_type_script_setup_true_lang.js","ui/GFEPassword.vue_vue_type_script_setup_true_lang.js","ui/LedgerTransport.vue_vue_type_script_setup_true_lang.js","ui/AccountItemBalance.vue_vue_type_script_setup_true_lang.js","ui/GridButtonWarning.vue_vue_type_script_setup_true_lang.js","ui/ConfirmationModal.vue_vue_type_script_setup_true_lang.js","ui/AccountUtxoList.js","ui/GridAccountUtxoList.vue_vue_type_script_setup_true_lang.js","ui/GridAccountUtxoItem.vue_vue_type_script_setup_true_lang.js","ui/IconButton.vue_vue_type_script_setup_true_lang.js","ui/GridTxListUtxoTokenList.vue_vue_type_script_setup_true_lang.js","ui/GridTxListTokenDetails.vue_vue_type_script_setup_true_lang.js"])))=>i.map(i=>d[i]);
import { u as useTranslation } from "./useTranslation.js";
import { _ as _sfc_main$4 } from "./GridTabs.vue_vue_type_script_setup_true_lang.js";
import { e as isStakingEnabled } from "./NetworkId.js";
import { o as openBlock, c as createElementBlock, q as createVNode, Q as QSpinnerDots_default, d as defineComponent, z as ref, h as withCtx, u as unref, eA as Transition, a as createBlock, j as createCommentVNode, H as Fragment, eB as defineAsyncComponent, eC as __vitePreload, aP as sleep, K as networkId, f as computed, C as onMounted, aW as addSignalListener, aQ as onNetworkFeaturesUpdated, aG as onUnmounted, aX as removeSignalListener, cf as getRandomId, ae as useSelectedAccount, ct as onErrorCaptured, S as reactive } from "./index.js";
import { _ as _export_sfc } from "./_plugin-vue_export-helper.js";
import "./useTabId.js";
import "./GridSpace.js";
import "./Tooltip.vue_vue_type_script_setup_true_lang.js";
const _sfc_main$3 = {};
const _hoisted_1$2 = { class: "col-span-12 flex justify-center items-center min-h-40" };
function _sfc_render(_ctx, _cache) {
  return openBlock(), createElementBlock("div", _hoisted_1$2, [
    createVNode(QSpinnerDots_default, {
      color: "gray",
      size: "2em",
      class: "col-span-12"
    })
  ]);
}
const AsyncLoader = /* @__PURE__ */ _export_sfc(_sfc_main$3, [["render", _sfc_render]]);
const _sfc_main$2 = /* @__PURE__ */ defineComponent({
  __name: "AsyncComponent",
  props: {
    component: { type: String, required: true, default: "Rewards" },
    delay: { type: Number, required: false, default: 0 }
  },
  setup(__props) {
    const props = __props;
    const loading = ref(false);
    const toid = setTimeout(() => {
      loading.value = true;
    }, 50);
    const AsyncComp = defineAsyncComponent({
      loader: () => {
        return new Promise(async (resolve) => {
          let component = null;
          switch (props.component) {
            case "Rewards":
              component = await __vitePreload(() => import("./Rewards.js"), true ? __vite__mapDeps([0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22]) : void 0);
              break;
            case "DelegationHistory":
              component = await __vitePreload(() => import("./DelegationHistory.js"), true ? __vite__mapDeps([23,1,2,3,4,7,24,14,11,13,16,17,18,25,9,10,12,8,26,27]) : void 0);
              break;
            case "QuickAccessList":
              component = await __vitePreload(() => import("./QuickAccessList.js"), true ? __vite__mapDeps([28,1,2,3,7,29,13,30,31,20,10,17,32]) : void 0);
              break;
            case "AccountBalance":
              component = await __vitePreload(() => import("./AccountBalance.js"), true ? __vite__mapDeps([33,1,2,3,7,24,14,11,10,16,17,18,34,5,6,35,36,37,31,20,13]) : void 0);
              break;
            case "GridAccountTokenBalance":
              component = await __vitePreload(() => import("./GridAccountTokenBalance.js"), true ? __vite__mapDeps([38,1,2,3,7,13,16,17,18,39,40,41,10,42,43,44,45,19,20,21,46,6,9,11,12,24,14,26,47,48,49,35,36,31,50,8,51]) : void 0);
              break;
            case "AccountList":
              component = await __vitePreload(() => import("./AccountList.js"), true ? __vite__mapDeps([52,1,2,3,7,5,6,53,54,55,13,22,10,56,35,17,36,19,20,21,31,16,18,57,44,58,59,60,43,45,61,62,24,14,11,4,25,9,12,8,26,27,63,64]) : void 0);
              break;
            case "AccountUtxoList":
              component = await __vitePreload(() => import("./AccountUtxoList.js"), true ? __vite__mapDeps([65,7,1,2,3,66,10,16,17,18,67,68,9,11,24,14,12,69,70,13]) : void 0);
              break;
            default:
              component = await __vitePreload(() => import("./Rewards.js"), true ? __vite__mapDeps([0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22]) : void 0);
              break;
          }
          if (props.delay > 0) {
            await sleep(props.delay);
          }
          clearTimeout(toid);
          loading.value = false;
          resolve(component);
        });
      }
    });
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock(Fragment, null, [
        createVNode(Transition, { name: "fade" }, {
          default: withCtx(() => [
            createVNode(unref(AsyncComp))
          ]),
          _: 1
        }),
        loading.value ? (openBlock(), createBlock(AsyncLoader, { key: 0 })) : createCommentVNode("", true)
      ], 64);
    };
  }
});
const _hoisted_1$1 = {
  key: 0,
  class: "col-span-12 grid grid-cols-12 gap-x-4 gap-y-0"
};
const _sfc_main$1 = /* @__PURE__ */ defineComponent({
  __name: "GridAccountBalance",
  setup(__props) {
    const storeId = "GridAccountBalance" + getRandomId();
    const { appAccount } = useSelectedAccount();
    const stakeIsEnabled = ref(isStakingEnabled(networkId.value));
    computed(() => {
      var _a;
      const list = ((_a = appAccount.value) == null ? void 0 : _a.data.rewardInfoList) ?? [];
      if (list.length > 0) {
        const info = list[0];
        return info.registered;
      }
      return false;
    });
    const updateStakeEnabledStatus = () => {
      stakeIsEnabled.value = isStakingEnabled(networkId.value);
    };
    onMounted(() => addSignalListener(onNetworkFeaturesUpdated, storeId, updateStakeEnabledStatus));
    onUnmounted(() => removeSignalListener(onNetworkFeaturesUpdated, storeId));
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock(Fragment, null, [
        unref(networkId) === "mainnet" ? (openBlock(), createElementBlock("div", _hoisted_1$1, [
          createVNode(_sfc_main$2, { component: "AccountBalance" }),
          createVNode(_sfc_main$2, { component: "QuickAccessList" })
        ])) : (openBlock(), createBlock(_sfc_main$2, {
          key: 1,
          component: "AccountBalance"
        })),
        stakeIsEnabled.value ? (openBlock(), createBlock(_sfc_main$2, {
          key: 2,
          component: "Rewards"
        })) : createCommentVNode("", true),
        stakeIsEnabled.value ? (openBlock(), createBlock(_sfc_main$2, {
          key: 3,
          component: "DelegationHistory",
          delay: 500
        })) : createCommentVNode("", true)
      ], 64);
    };
  }
});
const _hoisted_1 = { class: "cc-page-wallet" };
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "Summary",
  setup(__props) {
    const { it } = useTranslation();
    onErrorCaptured((e) => {
      console.error("Summary: onErrorCaptured", e);
      return true;
    });
    const optionsTabs = reactive([
      { id: "summary", label: it("menu.wallet.account.submenu.summary"), index: 0 },
      { id: "tokens", label: it("menu.wallet.account.submenu.tokenList"), index: 1 },
      { id: "utxos", label: it("menu.wallet.account.submenu.utxoList"), index: 2 },
      { id: "accounts", label: it("menu.wallet.account.submenu.accountList"), index: 3 }
    ]);
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", _hoisted_1, [
        createVNode(_sfc_main$4, { tabs: optionsTabs }, {
          tab0: withCtx(({ tabIndex }) => [
            createVNode(_sfc_main$1)
          ]),
          tab1: withCtx(() => [
            createVNode(_sfc_main$2, { component: "GridAccountTokenBalance" })
          ]),
          tab2: withCtx(() => [
            createVNode(_sfc_main$2, { component: "AccountUtxoList" })
          ]),
          tab3: withCtx(() => [
            createVNode(_sfc_main$2, { component: "AccountList" })
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
