import { d as defineComponent, w as watchEffect, o as openBlock, c as createElementBlock, u as unref, b as withModifiers, e as createBaseVNode, n as normalizeClass, f as computed, g as dappAccountId, s as selectedAccountId, a as createBlock, h as withCtx, i as createTextVNode, j as createCommentVNode, k as dispatchSignalSync, l as doForceSyncImportantAccounts, m as activeConnectionNumber, t as toDisplayString, p as connectionNumber, q as createVNode, v as isNormalMode, x as isSignMode, y as isEnableMode, z as ref, A as useCurrencyAPI, B as useFormatter, C as onMounted, D as watch, E as useResizeObserver, F as withDirectives, G as vModelSelect, H as Fragment, I as renderList, Q as QSpinnerDots_default, J as vShow, K as networkId, L as api, M as getCalculatedEpochSlot, N as getEpochLength, O as chainTip, P as normalizeStyle, R as isRef, S as reactive, T as createSlots, U as guardedUpdateNetworkId, V as nextTick, W as usePreloader, X as isBetaApp, Y as WALLET_VERSION_BETA, Z as WALLET_VERSION, _ as isStagingApp, $ as isBexApp, a0 as isMobileApp, a1 as getCloseBannerIdDate, a2 as now$1, a3 as setCloseBannerIdDate, a4 as doRestrictFeatures, a5 as toRefs, a6 as useAppWallet, a7 as useQuasar, a8 as SyncState, a9 as timestampLocal, aa as MIN_SYNC_EXEC_DELAY_SEC, ab as withKeys, ac as doForceSyncAllAccounts, ad as getWalletGroupOpen, ae as useSelectedAccount, af as toggleWalletGroupOpen, ag as walletGroupNameList, ah as isWalletListLoading, ai as walletGroupMap, aj as languageTags, ak as supportedTimezones, al as appUseUtc, am as setAppLanguageTag, an as defaultLanguageTag, ao as setAppTimezone, ap as setUseUtc, aq as defaultTimezone, ar as appLanguageTag, as as appTimezone, at as createICurrencyItem, au as appCurrencies, av as setAppCurrency, aw as getSubmitApiEndpoint, ax as getSubmitApiEndpointList, ay as DEFAULT_ETERNL_ENDPOINT, az as addSubmitApiEndpoint, aA as renderSlot, aB as setSubmitApiEndpoint, aC as delSubmitApiEndpoint, aD as walletIdList, aE as createWalletDownloadable, aF as getObjRef, aG as onUnmounted, aH as QPagination_default, aI as useGuard, aJ as getFrankenAddress, aK as isBaseAddress, aL as isEnterpriseAddress, aM as isRewardsAddress, aN as clearLocalStorage, aO as deleteWallet, aP as sleep, aQ as onNetworkFeaturesUpdated, aR as getAutoSubmitTx, aS as isTestnet, aT as isCustomNetwork, aU as toggleAutoSubmitTx, aV as useRoute, aW as addSignalListener, aX as removeSignalListener, aY as checkEpochParams, aZ as ErrorSignTx, a_ as decryptText, a$ as isCatalystVotingRegistrationMetadata, b0 as safeFreeCSLObject, b1 as FixedTransaction, b2 as hash_transaction, b3 as toHexString, b4 as Transaction, b5 as getTransactionJSONFromCSL, b6 as reinjectWitnessSet, b7 as Vkeywitnesses, b8 as createCSLPrvKey, b9 as make_vkey_witness, ba as TransactionWitnessSet, bb as addCatalystRegistrationSignature, bc as generateCatalystRegistration, bd as hash_auxiliary_data, be as useWalletAccount, bf as useSubmitTx, bg as getSignTxCredList, bh as getTimestampFromSlot, bi as getUtxoHash, bj as hasLockedUtxos, bk as QSpinner_default, bl as useSignTx, bm as dispatchSignal, bn as doAddSignedTxList, bo as AppType, bp as Platform, bq as getTxSignErrorMsg, br as getTxSubmitErrorMsg, bs as useWitnesses, bt as ErrorTxCbor, bu as ErrorSubmitTx, bv as getAppInfo, bw as onTxSignSubmit, bx as onTxSignCancel, r as resolveComponent, by as uint8ArrayToUtf8String, bz as toHexArray, bA as blake2b224Str, bB as toBuffer, bC as useSignData, bD as ErrorSignData, bE as getDataSignErrorMsg, bF as getAccountKeyDetails, bG as onDataSignSubmit, bH as onDataSignCancel, bI as onBeforeMount, bJ as setNotifyFunction, bK as disconnectCardanoConnect, bL as onBeforeUnmount, bM as createStaticVNode } from "./index.js";
import { u as useTranslation } from "./useTranslation.js";
import { u as useNavigation } from "./useNavigation.js";
import { u as useMainMenuOpen } from "./useMainMenuOpen.js";
import { _ as _sfc_main$E } from "./IconButton.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$C } from "./Tooltip.vue_vue_type_script_setup_true_lang.js";
import { u as useDarkMode } from "./useDarkMode.js";
import { u as useDappAccount } from "./useDappAccount.js";
import { u as useBalanceVisible } from "./useBalanceVisible.js";
import { _ as _sfc_main$D } from "./HeaderLogoAnimation.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$F } from "./FormattedAmount.vue_vue_type_script_setup_true_lang.js";
import { M as Modal } from "./Modal.js";
import { _ as _sfc_main$I } from "./GridButtonPrimary.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$G, a as _sfc_main$H } from "./GridHeadline.vue_vue_type_script_setup_true_lang.js";
import { a as adapters, C as Chart, L as LineElement, P as PointElement, b as CategoryScale, c as LinearScale, T as TimeSeriesScale, d as LineController, p as plugin_tooltip } from "./chart.js";
import { _ as _export_sfc } from "./_plugin-vue_export-helper.js";
import { h as networkGroups, b as isEnabledNetworkId, i as isTestnetNetwork, s as setDevSettingsEnabled, j as isDappBrowserEnabled, k as isReportingEnabled, l as isDevSettingsEnabled } from "./NetworkId.js";
import { G as GridSpace } from "./GridSpace.js";
import { _ as _sfc_main$K } from "./GridTabs.vue_vue_type_script_setup_true_lang.js";
import { c as cardanoLogo } from "./defaultLogo.js";
import { _ as _sfc_main$J } from "./ExternalLink.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$L, a as _sfc_main$M } from "./WalletIcon.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$S } from "./SettingsItem.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$T } from "./AddressBook.vue_vue_type_script_setup_true_lang.js";
import { u as useExplorer, _ as _sfc_main$$ } from "./ExplorerLink.vue_vue_type_script_setup_true_lang.js";
import { G as GridInput } from "./GridInput.js";
import { _ as _sfc_main$N } from "./GridForm.vue_vue_type_script_setup_true_lang.js";
import { u as useDownload } from "./useDownload.js";
import { G as GridButtonSecondary } from "./GridButtonSecondary.js";
import { I as IconDelete } from "./IconDelete.js";
import { _ as _sfc_main$O } from "./ConfirmationModal.vue_vue_type_script_setup_true_lang.js";
import { I as IconPencil } from "./IconPencil.js";
import { _ as _sfc_main$P } from "./GridReceiveAddr.vue_vue_type_script_setup_true_lang.js";
import { p as processFile } from "./scanner.js";
import { _ as _sfc_main$Q } from "./GridButtonWarning.vue_vue_type_script_setup_true_lang.js";
import "./useTabId.js";
import { _ as _sfc_main$R } from "./GridToggle.vue_vue_type_script_setup_true_lang.js";
import { u as useLedgerDevice, a as useTrezorDevice } from "./useTrezorDevice.js";
import { _ as _sfc_main$U, u as useKeystoneDevice, s as signData, v as verifyData } from "./Keystone.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$V } from "./GridTextArea.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$Y } from "./GridLoading.vue_vue_type_script_setup_true_lang.js";
import { I as IconInfo } from "./IconInfo.js";
import { I as IconCheck } from "./IconCheck.js";
import { I as IconError } from "./IconError.js";
import { _ as _sfc_main$X } from "./GridFormSignWithPassword.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$W } from "./LedgerTransport.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$_ } from "./GridTxListBalance.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$Z } from "./GridTxListEntryBalance.vue_vue_type_script_setup_true_lang.js";
import { _ as _sfc_main$10 } from "./CopyToClipboard.vue_vue_type_script_setup_true_lang.js";
import { S } from "./vue-json-pretty.js";
import { W as WalletConnectManager } from "./WalletConnectManager.js";
import { e as entryList, _ as _sfc_main$11 } from "./DAppIframe.vue_vue_type_script_setup_true_lang.js";
import "./Clipboard.js";
import "./GridButton.vue_vue_type_script_setup_true_lang.js";
import "./lz-string.js";
import "./browser.js";
import "./GFEPassword.vue_vue_type_script_setup_true_lang.js";
import "./GridTxListUtxoListBadges.vue_vue_type_script_setup_true_lang.js";
import "./ReportLabelNewModal.vue_vue_type_script_setup_true_lang.js";
import "./GridTxListUtxoTokenList.vue_vue_type_script_setup_true_lang.js";
import "./GridTxListTokenDetails.vue_vue_type_script_setup_true_lang.js";
import "./AccessPasswordInputModal.vue_vue_type_script_setup_true_lang.js";
import "./GridButtonCountdown.vue_vue_type_script_setup_true_lang.js";
const _hoisted_1$A = {
  key: 0,
  class: "material-icons material-icons-outlined"
};
const _hoisted_2$t = {
  key: 1,
  class: "material-icons material-icons-outlined"
};
const _sfc_main$B = /* @__PURE__ */ defineComponent({
  __name: "DarkModeToggle",
  setup(__props) {
    const {
      isDarkMode,
      toggleDarkMode
    } = useDarkMode();
    watchEffect(() => {
      if (isDarkMode.value) {
        document.documentElement.classList.add("dark");
      } else {
        document.documentElement.classList.remove("dark");
      }
    });
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("button", {
        type: "button",
        onClick: _cache[0] || (_cache[0] = withModifiers(
          //@ts-ignore
          (...args) => unref(toggleDarkMode) && unref(toggleDarkMode)(...args),
          ["stop"]
        )),
        class: "relative h-full text-md sm:text-xl px-2.5 flex flex-col justify-center items-center cursor-pointer cc-text-highlight-hover"
      }, [
        unref(isDarkMode) ? (openBlock(), createElementBlock("span", _hoisted_1$A, "light_mode")) : (openBlock(), createElementBlock("span", _hoisted_2$t, "dark_mode"))
      ]);
    };
  }
});
const _hoisted_1$z = {
  key: 0,
  xmlns: "http://www.w3.org/2000/svg",
  viewBox: "0 0 24 24",
  class: "cc-fill-green w-full h-full -ml-1"
};
const _hoisted_2$s = {
  key: 1,
  xmlns: "http://www.w3.org/2000/svg",
  viewBox: "0 0 24 24",
  class: "cc-fill w-full h-full -ml-1"
};
const _hoisted_3$m = {
  key: 2,
  class: "mdi mdi-web absolute bottom-0 text-sm cc-text-green -ml-1",
  style: { "right": "3px" }
};
const _hoisted_4$l = {
  key: 3,
  class: "mdi mdi-web absolute bottom-0 text-sm cc-text-color -ml-1",
  style: { "right": "3px" }
};
const _sfc_main$A = /* @__PURE__ */ defineComponent({
  __name: "DAppConnectButton",
  setup(__props) {
    const { gotoDAppBrowserPage } = useNavigation();
    const { closeMainMenu } = useMainMenuOpen();
    const { hasDappAccount } = useDappAccount();
    function onClicked() {
      closeMainMenu();
      gotoDAppBrowserPage("DApps", "connect");
    }
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("button", {
        type: "button",
        onClick: withModifiers(onClicked, ["stop"]),
        class: "relative h-full w-10 text-md sm:text-xl px-2.5 flex flex-col justify-center items-center cursor-pointer cc-text-highlight-hover"
      }, [
        unref(hasDappAccount) ? (openBlock(), createElementBlock("svg", _hoisted_1$z, _cache[0] || (_cache[0] = [
          createBaseVNode("path", { d: "M 20.59375 2 L 17.09375 5.5 L 15.1875 3.59375 C 14.3875 2.79375 13.20625 2.79375 12.40625 3.59375 L 9.90625 6.09375\n  L 8.90625 5.09375 L 7.5 6.5 L 17.5 16.5 L 18.90625 15.09375 L 17.90625 14.09375\n  L 20.40625 11.59375 C 21.20625 10.79375 21.20625 9.6125 20.40625 8.8125 L 18.5 6.90625\n  L 22 3.40625 L 20.59375 2 z M 6.40625 7.59375 L 5 9 L 6 10 L 3.59375 12.40625 C 2.79375 13.20625 2.79375 14.3875 3.59375 15.1875\n  L 5.5 17.09375 L 2 20.59375 L 3.40625 22 L 6.90625 18.5 L 8.8125 20.40625 C 9.6125 21.20625 10.79375 21.20625 11.59375 20.40625\n  L 14 18 L 15 19 L 16.40625 17.59375 L 6.40625 7.59375 z" }, null, -1)
        ]))) : (openBlock(), createElementBlock("svg", _hoisted_2$s, _cache[1] || (_cache[1] = [
          createBaseVNode("path", { d: "M 14.8125 2 C 14.3125 2 13.80625 2.19375 13.40625 2.59375 L 11.90625 4.09375 L 10.90625 3.09375 L 9.5 4.5\n  L 11.8125 6.8125 L 9.1875 9.40625 L 10.59375 10.8125 L 13.1875 8.1875 L 15.8125 10.8125 L 13.1875 13.40625\n  L 14.59375 14.8125 L 17.1875 12.1875 L 19.5 14.5 L 20.90625 13.09375 L 19.90625 12.09375 L 21.40625 10.59375\n  C 22.20625 9.79375 22.20625 8.6125 21.40625 7.8125 L 19.5 5.90625 L 22 3.40625 L 20.59375 2 L 18.09375 4.5\n  L 16.1875 2.59375 C 15.7875 2.19375 15.3125 2 14.8125 2 z M 4.40625 9.59375 L 3 11 L 4 12 L 2.59375 13.40625\n  C 1.79375 14.20625 1.79375 15.3875 2.59375 16.1875 L 4.5 18.09375 L 2 20.59375 L 3.40625 22 L 5.90625 19.5\n  L 7.8125 21.40625 C 8.6125 22.20625 9.79375 22.20625 10.59375 21.40625 L 12 20 L 13 21 L 14.40625 19.59375 L 4.40625 9.59375 z" }, null, -1)
        ]))),
        unref(hasDappAccount) ? (openBlock(), createElementBlock("i", _hoisted_3$m)) : (openBlock(), createElementBlock("i", _hoisted_4$l))
      ]);
    };
  }
});
const _hoisted_1$y = ["aria-label"];
const _sfc_main$z = /* @__PURE__ */ defineComponent({
  __name: "BalanceVisibilityButton",
  setup(__props) {
    const {
      isBalanceVisible,
      setBalanceVisible
    } = useBalanceVisible();
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("button", {
        type: "button",
        onClick: _cache[0] || (_cache[0] = withModifiers(($event) => unref(setBalanceVisible)(!unref(isBalanceVisible)), ["stop"])),
        "aria-label": unref(isBalanceVisible) ? "hide balance" : "show balance",
        class: "relative h-full text-md sm:text-xl px-2.5 flex flex-col justify-center items-center cursor-pointer cc-text-highlight-hover"
      }, [
        createBaseVNode("i", {
          class: normalizeClass(unref(isBalanceVisible) ? "mdi mdi-eye" : "mdi mdi-eye-off")
        }, null, 2)
      ], 8, _hoisted_1$y);
    };
  }
});
const _hoisted_1$x = ["disabled"];
const _sfc_main$y = /* @__PURE__ */ defineComponent({
  __name: "WalletSyncButton",
  setup(__props) {
    const disabled = computed(() => !dappAccountId.value && !selectedAccountId.value);
    const onClickedSync = () => dispatchSignalSync(doForceSyncImportantAccounts);
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("button", {
        type: "button",
        "aria-label": "sync wallet",
        disabled: disabled.value,
        onClick: withModifiers(onClickedSync, ["stop"]),
        class: "relative h-full px-2.5 flex flex-col justify-center items-center text-md sm:text-xl cc-text-highlight-hover cursor-pointer"
      }, [
        _cache[1] || (_cache[1] = createBaseVNode("i", { class: "mdi mdi-sync" }, null, -1)),
        disabled.value ? (openBlock(), createBlock(_sfc_main$C, {
          key: 0,
          anchor: "bottom middle",
          "transition-show": "scale",
          "transition-hide": "scale"
        }, {
          default: withCtx(() => _cache[0] || (_cache[0] = [
            createTextVNode(" No wallet or dapp account selected. ")
          ])),
          _: 1
        })) : createCommentVNode("", true)
      ], 8, _hoisted_1$x);
    };
  }
});
const _hoisted_1$w = { class: "cc-text-green text-xs relative top-1 -left-2" };
const _hoisted_2$r = { class: "text-xs relative top-1 -left-2" };
const _sfc_main$x = /* @__PURE__ */ defineComponent({
  __name: "DAppPeerConnectButton",
  setup(__props) {
    const { gotoDirectConnect } = useNavigation();
    const { closeMainMenu } = useMainMenuOpen();
    function onClicked() {
      closeMainMenu();
      gotoDirectConnect("CardanoConnect", "manage");
    }
    return (_ctx, _cache) => {
      return unref(activeConnectionNumber) > 0 ? (openBlock(), createElementBlock("button", {
        key: 0,
        onClick: withModifiers(onClicked, ["stop"]),
        type: "button",
        "aria-label": "sync wallet",
        class: "relative h-full w-10 text-md sm:text-xl px-2.5 flex flex-col justify-center items-center cursor-pointer cc-text-highlight-hover"
      }, [
        _cache[0] || (_cache[0] = createBaseVNode("svg", {
          xmlns: "http://www.w3.org/2000/svg",
          viewBox: "0 0 24 24",
          class: "cc-fill-green w-full h-full -ml-1"
        }, [
          createBaseVNode("path", { d: "M 20.59375 2 L 17.09375 5.5 L 15.1875 3.59375 C 14.3875 2.79375 13.20625 2.79375 12.40625 3.59375 L 9.90625 6.09375\n  L 8.90625 5.09375 L 7.5 6.5 L 17.5 16.5 L 18.90625 15.09375 L 17.90625 14.09375\n  L 20.40625 11.59375 C 21.20625 10.79375 21.20625 9.6125 20.40625 8.8125 L 18.5 6.90625\n  L 22 3.40625 L 20.59375 2 z M 6.40625 7.59375 L 5 9 L 6 10 L 3.59375 12.40625 C 2.79375 13.20625 2.79375 14.3875 3.59375 15.1875\n  L 5.5 17.09375 L 2 20.59375 L 3.40625 22 L 6.90625 18.5 L 8.8125 20.40625 C 9.6125 21.20625 10.79375 21.20625 11.59375 20.40625\n  L 14 18 L 15 19 L 16.40625 17.59375 L 6.40625 7.59375 z" })
        ], -1)),
        _cache[1] || (_cache[1] = createBaseVNode("i", { class: "cc-text-green text-xs relative top-0 -left-2 transform rotate-45 inline-block" }, "P2P", -1)),
        createBaseVNode("i", _hoisted_1$w, toDisplayString(unref(activeConnectionNumber) + "/" + unref(connectionNumber)), 1)
      ])) : (openBlock(), createElementBlock("button", {
        key: 1,
        onClick: withModifiers(onClicked, ["stop"]),
        type: "button",
        "aria-label": "sync wallet",
        class: "relative h-full text-sm sm:text-xl px-2.5 flex flex-col justify-center items-center cursor-pointer cc-text-highlight-hover"
      }, [
        _cache[2] || (_cache[2] = createBaseVNode("svg", {
          xmlns: "http://www.w3.org/2000/svg",
          viewBox: "0 0 24 24",
          class: "cc-fill w-full h-full mt-2.5 -ml-1"
        }, [
          createBaseVNode("path", { d: "M 14.8125 2 C 14.3125 2 13.80625 2.19375 13.40625 2.59375 L 11.90625 4.09375 L 10.90625 3.09375 L 9.5 4.5\n  L 11.8125 6.8125 L 9.1875 9.40625 L 10.59375 10.8125 L 13.1875 8.1875 L 15.8125 10.8125 L 13.1875 13.40625\n  L 14.59375 14.8125 L 17.1875 12.1875 L 19.5 14.5 L 20.90625 13.09375 L 19.90625 12.09375 L 21.40625 10.59375\n  C 22.20625 9.79375 22.20625 8.6125 21.40625 7.8125 L 19.5 5.90625 L 22 3.40625 L 20.59375 2 L 18.09375 4.5\n  L 16.1875 2.59375 C 15.7875 2.19375 15.3125 2 14.8125 2 z" })
        ], -1)),
        _cache[3] || (_cache[3] = createBaseVNode("i", { class: "text-xs relative top-0 -left-2 transform inline-block" }, "P2P", -1)),
        createBaseVNode("i", _hoisted_2$r, toDisplayString(unref(activeConnectionNumber) + "/" + unref(connectionNumber)), 1)
      ]));
    };
  }
});
const _hoisted_1$v = { class: "relative w-full h-12 px-1.5 cc-flex-fixed cc-site-max-width mx-auto flex flex-row flex-nowrap justify-start items-center" };
const _hoisted_2$q = { class: "w-10 h-10 flex flex-row flex-nowrap justify-center items-center" };
const _hoisted_3$l = { class: "w-10 h-10 flex flex-row flex-nowrap justify-center items-center" };
const _hoisted_4$k = {
  key: 0,
  class: "w-10 h-10 flex flex-row flex-nowrap justify-center items-center"
};
const _hoisted_5$h = {
  key: 1,
  class: "w-10 h-10 flex flex-row flex-nowrap justify-center items-center"
};
const _hoisted_6$f = { class: "w-10 h-10 flex flex-row flex-nowrap justify-center items-center" };
const _hoisted_7$d = { class: "lg:hidden mr-0.5" };
const _sfc_main$w = /* @__PURE__ */ defineComponent({
  __name: "Header",
  setup(__props) {
    const { it } = useTranslation();
    const { gotoPage } = useNavigation();
    const {
      openMainMenu,
      toggleMainMenu,
      isMainMenuOpen
    } = useMainMenuOpen();
    const onClickedHome = () => {
      openMainMenu();
      if (isSignMode()) ;
      else if (isEnableMode()) {
        gotoPage("Connect");
      } else {
        gotoPage("LandingPage");
      }
    };
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("header", _hoisted_1$v, [
        createBaseVNode("button", {
          class: "group shrink flex flex-row flex-nowrap items-start justify-start cc-rounded cc-btn-focus h-3/4 cc-border-reset cc-btn-focus cc-text-semi-bold cc-text-xl text-center whitespace-nowrap",
          onClick: withModifiers(onClickedHome, ["stop"])
        }, [
          createVNode(_sfc_main$D)
        ]),
        _cache[0] || (_cache[0] = createBaseVNode("div", { class: "grow shrink" }, null, -1)),
        createBaseVNode("div", _hoisted_2$q, [
          createVNode(_sfc_main$y, { class: "text-2xl" })
        ]),
        createBaseVNode("div", _hoisted_3$l, [
          createVNode(_sfc_main$z, { class: "text-2xl" })
        ]),
        unref(isNormalMode)() ? (openBlock(), createElementBlock("div", _hoisted_4$k, [
          createVNode(_sfc_main$A)
        ])) : createCommentVNode("", true),
        unref(isNormalMode)() ? (openBlock(), createElementBlock("div", _hoisted_5$h, [
          createVNode(_sfc_main$x)
        ])) : createCommentVNode("", true),
        createBaseVNode("div", _hoisted_6$f, [
          createVNode(_sfc_main$B)
        ]),
        createBaseVNode("div", _hoisted_7$d, [
          createVNode(_sfc_main$E, {
            class: "w-10 h-10 text-2xl sm:text-3xl cc-text-highlight-hover",
            icon: unref(isMainMenuOpen) ? unref(it)("header.menu.close.icon") : unref(it)("header.menu.open.icon"),
            "aria-label": unref(isMainMenuOpen) ? "hide main menu" : "show main menu",
            onClick: withModifiers(unref(toggleMainMenu), ["stop"])
          }, null, 8, ["icon", "aria-label", "onClick"]),
          createVNode(_sfc_main$C, {
            anchor: "center right",
            self: "center left",
            "transition-show": "scale",
            "transition-hide": "scale"
          }, {
            default: withCtx(() => [
              createTextVNode(toDisplayString(unref(it)("header.menu.tooltip")), 1)
            ]),
            _: 1
          })
        ])
      ]);
    };
  }
});
const epochModalOpen = ref(false);
const useEpochModalOpen = () => {
  const openEpochModal = () => {
    epochModalOpen.value = true;
  };
  const closeEpochModal = () => {
    epochModalOpen.value = false;
  };
  const toggleEpochModal = () => {
    epochModalOpen.value = !epochModalOpen.value;
  };
  const isEpochModalOpen = computed(() => epochModalOpen.value);
  return {
    openEpochModal,
    closeEpochModal,
    toggleEpochModal,
    isEpochModalOpen
  };
};
const _hoisted_1$u = {
  key: 0,
  class: "mx-1"
};
const _sfc_main$v = /* @__PURE__ */ defineComponent({
  __name: "CurrencyConversionPrice",
  props: {
    currency: { type: Object, required: false },
    showDot: { type: Boolean, required: false, default: false }
  },
  emits: ["clicked"],
  setup(__props, { emit: __emit }) {
    const props = __props;
    const { activeCurrency } = useCurrencyAPI();
    const { getDecimalNumber } = useFormatter();
    const currency = computed(() => props.currency ?? activeCurrency.value);
    const decimals = computed(() => {
      let precision = 0;
      let tmp = activeCurrency.value.value;
      while (tmp < 1) {
        tmp *= 10;
        precision += 1;
        if (precision > 4) break;
      }
      return Math.min(precision + 3, 8);
    });
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", {
        class: "flex flex-row flex-nowrap",
        onClick: _cache[3] || (_cache[3] = ($event) => _ctx.$emit("clicked"))
      }, [
        __props.showDot ? (openBlock(), createElementBlock("span", _hoisted_1$u, toDisplayString("·"))) : createCommentVNode("", true),
        createVNode(_sfc_main$F, {
          amount: unref(getDecimalNumber)().toString(),
          "show-fraction": false,
          "balance-always-visible": "",
          onClicked: _cache[0] || (_cache[0] = ($event) => _ctx.$emit("clicked"))
        }, null, 8, ["amount"]),
        _cache[4] || (_cache[4] = createBaseVNode("span", { class: "mx-1" }, "=", -1)),
        currency.value && currency.value.value > 0 ? (openBlock(), createBlock(_sfc_main$F, {
          key: 1,
          amount: currency.value.value.toString(),
          decimals: decimals.value,
          currency: currency.value.id,
          "decimal-c-s-s": "cc-text-bold",
          "symbol-c-s-s": "cc-text-bold",
          "fraction-c-s-s": "cc-text-bold",
          "is-whole-number": "",
          "balance-always-visible": "",
          onClicked: _cache[1] || (_cache[1] = ($event) => _ctx.$emit("clicked"))
        }, null, 8, ["amount", "decimals", "currency"])) : (openBlock(), createElementBlock("span", {
          key: 2,
          onClicked: _cache[2] || (_cache[2] = ($event) => _ctx.$emit("clicked"))
        }, "N/A", 32))
      ]);
    };
  }
});
class LuxonError extends Error {
}
class InvalidDateTimeError extends LuxonError {
  constructor(reason) {
    super(`Invalid DateTime: ${reason.toMessage()}`);
  }
}
class InvalidIntervalError extends LuxonError {
  constructor(reason) {
    super(`Invalid Interval: ${reason.toMessage()}`);
  }
}
class InvalidDurationError extends LuxonError {
  constructor(reason) {
    super(`Invalid Duration: ${reason.toMessage()}`);
  }
}
class ConflictingSpecificationError extends LuxonError {
}
class InvalidUnitError extends LuxonError {
  constructor(unit) {
    super(`Invalid unit ${unit}`);
  }
}
class InvalidArgumentError extends LuxonError {
}
class ZoneIsAbstractError extends LuxonError {
  constructor() {
    super("Zone is an abstract class");
  }
}
const n = "numeric", s = "short", l = "long";
const DATE_SHORT = {
  year: n,
  month: n,
  day: n
};
const DATE_MED = {
  year: n,
  month: s,
  day: n
};
const DATE_MED_WITH_WEEKDAY = {
  year: n,
  month: s,
  day: n,
  weekday: s
};
const DATE_FULL = {
  year: n,
  month: l,
  day: n
};
const DATE_HUGE = {
  year: n,
  month: l,
  day: n,
  weekday: l
};
const TIME_SIMPLE = {
  hour: n,
  minute: n
};
const TIME_WITH_SECONDS = {
  hour: n,
  minute: n,
  second: n
};
const TIME_WITH_SHORT_OFFSET = {
  hour: n,
  minute: n,
  second: n,
  timeZoneName: s
};
const TIME_WITH_LONG_OFFSET = {
  hour: n,
  minute: n,
  second: n,
  timeZoneName: l
};
const TIME_24_SIMPLE = {
  hour: n,
  minute: n,
  hourCycle: "h23"
};
const TIME_24_WITH_SECONDS = {
  hour: n,
  minute: n,
  second: n,
  hourCycle: "h23"
};
const TIME_24_WITH_SHORT_OFFSET = {
  hour: n,
  minute: n,
  second: n,
  hourCycle: "h23",
  timeZoneName: s
};
const TIME_24_WITH_LONG_OFFSET = {
  hour: n,
  minute: n,
  second: n,
  hourCycle: "h23",
  timeZoneName: l
};
const DATETIME_SHORT = {
  year: n,
  month: n,
  day: n,
  hour: n,
  minute: n
};
const DATETIME_SHORT_WITH_SECONDS = {
  year: n,
  month: n,
  day: n,
  hour: n,
  minute: n,
  second: n
};
const DATETIME_MED = {
  year: n,
  month: s,
  day: n,
  hour: n,
  minute: n
};
const DATETIME_MED_WITH_SECONDS = {
  year: n,
  month: s,
  day: n,
  hour: n,
  minute: n,
  second: n
};
const DATETIME_MED_WITH_WEEKDAY = {
  year: n,
  month: s,
  day: n,
  weekday: s,
  hour: n,
  minute: n
};
const DATETIME_FULL = {
  year: n,
  month: l,
  day: n,
  hour: n,
  minute: n,
  timeZoneName: s
};
const DATETIME_FULL_WITH_SECONDS = {
  year: n,
  month: l,
  day: n,
  hour: n,
  minute: n,
  second: n,
  timeZoneName: s
};
const DATETIME_HUGE = {
  year: n,
  month: l,
  day: n,
  weekday: l,
  hour: n,
  minute: n,
  timeZoneName: l
};
const DATETIME_HUGE_WITH_SECONDS = {
  year: n,
  month: l,
  day: n,
  weekday: l,
  hour: n,
  minute: n,
  second: n,
  timeZoneName: l
};
class Zone {
  /**
   * The type of zone
   * @abstract
   * @type {string}
   */
  get type() {
    throw new ZoneIsAbstractError();
  }
  /**
   * The name of this zone.
   * @abstract
   * @type {string}
   */
  get name() {
    throw new ZoneIsAbstractError();
  }
  /**
   * The IANA name of this zone.
   * Defaults to `name` if not overwritten by a subclass.
   * @abstract
   * @type {string}
   */
  get ianaName() {
    return this.name;
  }
  /**
   * Returns whether the offset is known to be fixed for the whole year.
   * @abstract
   * @type {boolean}
   */
  get isUniversal() {
    throw new ZoneIsAbstractError();
  }
  /**
   * Returns the offset's common name (such as EST) at the specified timestamp
   * @abstract
   * @param {number} ts - Epoch milliseconds for which to get the name
   * @param {Object} opts - Options to affect the format
   * @param {string} opts.format - What style of offset to return. Accepts 'long' or 'short'.
   * @param {string} opts.locale - What locale to return the offset name in.
   * @return {string}
   */
  offsetName(ts, opts) {
    throw new ZoneIsAbstractError();
  }
  /**
   * Returns the offset's value as a string
   * @abstract
   * @param {number} ts - Epoch milliseconds for which to get the offset
   * @param {string} format - What style of offset to return.
   *                          Accepts 'narrow', 'short', or 'techie'. Returning '+6', '+06:00', or '+0600' respectively
   * @return {string}
   */
  formatOffset(ts, format) {
    throw new ZoneIsAbstractError();
  }
  /**
   * Return the offset in minutes for this zone at the specified timestamp.
   * @abstract
   * @param {number} ts - Epoch milliseconds for which to compute the offset
   * @return {number}
   */
  offset(ts) {
    throw new ZoneIsAbstractError();
  }
  /**
   * Return whether this Zone is equal to another zone
   * @abstract
   * @param {Zone} otherZone - the zone to compare
   * @return {boolean}
   */
  equals(otherZone) {
    throw new ZoneIsAbstractError();
  }
  /**
   * Return whether this Zone is valid.
   * @abstract
   * @type {boolean}
   */
  get isValid() {
    throw new ZoneIsAbstractError();
  }
}
let singleton$1 = null;
class SystemZone extends Zone {
  /**
   * Get a singleton instance of the local zone
   * @return {SystemZone}
   */
  static get instance() {
    if (singleton$1 === null) {
      singleton$1 = new SystemZone();
    }
    return singleton$1;
  }
  /** @override **/
  get type() {
    return "system";
  }
  /** @override **/
  get name() {
    return new Intl.DateTimeFormat().resolvedOptions().timeZone;
  }
  /** @override **/
  get isUniversal() {
    return false;
  }
  /** @override **/
  offsetName(ts, { format, locale }) {
    return parseZoneInfo(ts, format, locale);
  }
  /** @override **/
  formatOffset(ts, format) {
    return formatOffset(this.offset(ts), format);
  }
  /** @override **/
  offset(ts) {
    return -new Date(ts).getTimezoneOffset();
  }
  /** @override **/
  equals(otherZone) {
    return otherZone.type === "system";
  }
  /** @override **/
  get isValid() {
    return true;
  }
}
let dtfCache = {};
function makeDTF(zone) {
  if (!dtfCache[zone]) {
    dtfCache[zone] = new Intl.DateTimeFormat("en-US", {
      hour12: false,
      timeZone: zone,
      year: "numeric",
      month: "2-digit",
      day: "2-digit",
      hour: "2-digit",
      minute: "2-digit",
      second: "2-digit",
      era: "short"
    });
  }
  return dtfCache[zone];
}
const typeToPos = {
  year: 0,
  month: 1,
  day: 2,
  era: 3,
  hour: 4,
  minute: 5,
  second: 6
};
function hackyOffset(dtf, date) {
  const formatted = dtf.format(date).replace(/\u200E/g, ""), parsed = /(\d+)\/(\d+)\/(\d+) (AD|BC),? (\d+):(\d+):(\d+)/.exec(formatted), [, fMonth, fDay, fYear, fadOrBc, fHour, fMinute, fSecond] = parsed;
  return [fYear, fMonth, fDay, fadOrBc, fHour, fMinute, fSecond];
}
function partsOffset(dtf, date) {
  const formatted = dtf.formatToParts(date);
  const filled = [];
  for (let i = 0; i < formatted.length; i++) {
    const { type, value } = formatted[i];
    const pos = typeToPos[type];
    if (type === "era") {
      filled[pos] = value;
    } else if (!isUndefined(pos)) {
      filled[pos] = parseInt(value, 10);
    }
  }
  return filled;
}
let ianaZoneCache = {};
class IANAZone extends Zone {
  /**
   * @param {string} name - Zone name
   * @return {IANAZone}
   */
  static create(name) {
    if (!ianaZoneCache[name]) {
      ianaZoneCache[name] = new IANAZone(name);
    }
    return ianaZoneCache[name];
  }
  /**
   * Reset local caches. Should only be necessary in testing scenarios.
   * @return {void}
   */
  static resetCache() {
    ianaZoneCache = {};
    dtfCache = {};
  }
  /**
   * Returns whether the provided string is a valid specifier. This only checks the string's format, not that the specifier identifies a known zone; see isValidZone for that.
   * @param {string} s - The string to check validity on
   * @example IANAZone.isValidSpecifier("America/New_York") //=> true
   * @example IANAZone.isValidSpecifier("Sport~~blorp") //=> false
   * @deprecated For backward compatibility, this forwards to isValidZone, better use `isValidZone()` directly instead.
   * @return {boolean}
   */
  static isValidSpecifier(s2) {
    return this.isValidZone(s2);
  }
  /**
   * Returns whether the provided string identifies a real zone
   * @param {string} zone - The string to check
   * @example IANAZone.isValidZone("America/New_York") //=> true
   * @example IANAZone.isValidZone("Fantasia/Castle") //=> false
   * @example IANAZone.isValidZone("Sport~~blorp") //=> false
   * @return {boolean}
   */
  static isValidZone(zone) {
    if (!zone) {
      return false;
    }
    try {
      new Intl.DateTimeFormat("en-US", { timeZone: zone }).format();
      return true;
    } catch (e) {
      return false;
    }
  }
  constructor(name) {
    super();
    this.zoneName = name;
    this.valid = IANAZone.isValidZone(name);
  }
  /**
   * The type of zone. `iana` for all instances of `IANAZone`.
   * @override
   * @type {string}
   */
  get type() {
    return "iana";
  }
  /**
   * The name of this zone (i.e. the IANA zone name).
   * @override
   * @type {string}
   */
  get name() {
    return this.zoneName;
  }
  /**
   * Returns whether the offset is known to be fixed for the whole year:
   * Always returns false for all IANA zones.
   * @override
   * @type {boolean}
   */
  get isUniversal() {
    return false;
  }
  /**
   * Returns the offset's common name (such as EST) at the specified timestamp
   * @override
   * @param {number} ts - Epoch milliseconds for which to get the name
   * @param {Object} opts - Options to affect the format
   * @param {string} opts.format - What style of offset to return. Accepts 'long' or 'short'.
   * @param {string} opts.locale - What locale to return the offset name in.
   * @return {string}
   */
  offsetName(ts, { format, locale }) {
    return parseZoneInfo(ts, format, locale, this.name);
  }
  /**
   * Returns the offset's value as a string
   * @override
   * @param {number} ts - Epoch milliseconds for which to get the offset
   * @param {string} format - What style of offset to return.
   *                          Accepts 'narrow', 'short', or 'techie'. Returning '+6', '+06:00', or '+0600' respectively
   * @return {string}
   */
  formatOffset(ts, format) {
    return formatOffset(this.offset(ts), format);
  }
  /**
   * Return the offset in minutes for this zone at the specified timestamp.
   * @override
   * @param {number} ts - Epoch milliseconds for which to compute the offset
   * @return {number}
   */
  offset(ts) {
    const date = new Date(ts);
    if (isNaN(date)) return NaN;
    const dtf = makeDTF(this.name);
    let [year, month, day, adOrBc, hour, minute, second] = dtf.formatToParts ? partsOffset(dtf, date) : hackyOffset(dtf, date);
    if (adOrBc === "BC") {
      year = -Math.abs(year) + 1;
    }
    const adjustedHour = hour === 24 ? 0 : hour;
    const asUTC = objToLocalTS({
      year,
      month,
      day,
      hour: adjustedHour,
      minute,
      second,
      millisecond: 0
    });
    let asTS = +date;
    const over = asTS % 1e3;
    asTS -= over >= 0 ? over : 1e3 + over;
    return (asUTC - asTS) / (60 * 1e3);
  }
  /**
   * Return whether this Zone is equal to another zone
   * @override
   * @param {Zone} otherZone - the zone to compare
   * @return {boolean}
   */
  equals(otherZone) {
    return otherZone.type === "iana" && otherZone.name === this.name;
  }
  /**
   * Return whether this Zone is valid.
   * @override
   * @type {boolean}
   */
  get isValid() {
    return this.valid;
  }
}
let intlLFCache = {};
function getCachedLF(locString, opts = {}) {
  const key = JSON.stringify([locString, opts]);
  let dtf = intlLFCache[key];
  if (!dtf) {
    dtf = new Intl.ListFormat(locString, opts);
    intlLFCache[key] = dtf;
  }
  return dtf;
}
let intlDTCache = {};
function getCachedDTF(locString, opts = {}) {
  const key = JSON.stringify([locString, opts]);
  let dtf = intlDTCache[key];
  if (!dtf) {
    dtf = new Intl.DateTimeFormat(locString, opts);
    intlDTCache[key] = dtf;
  }
  return dtf;
}
let intlNumCache = {};
function getCachedINF(locString, opts = {}) {
  const key = JSON.stringify([locString, opts]);
  let inf = intlNumCache[key];
  if (!inf) {
    inf = new Intl.NumberFormat(locString, opts);
    intlNumCache[key] = inf;
  }
  return inf;
}
let intlRelCache = {};
function getCachedRTF(locString, opts = {}) {
  const { base, ...cacheKeyOpts } = opts;
  const key = JSON.stringify([locString, cacheKeyOpts]);
  let inf = intlRelCache[key];
  if (!inf) {
    inf = new Intl.RelativeTimeFormat(locString, opts);
    intlRelCache[key] = inf;
  }
  return inf;
}
let sysLocaleCache = null;
function systemLocale() {
  if (sysLocaleCache) {
    return sysLocaleCache;
  } else {
    sysLocaleCache = new Intl.DateTimeFormat().resolvedOptions().locale;
    return sysLocaleCache;
  }
}
let weekInfoCache = {};
function getCachedWeekInfo(locString) {
  let data = weekInfoCache[locString];
  if (!data) {
    const locale = new Intl.Locale(locString);
    data = "getWeekInfo" in locale ? locale.getWeekInfo() : locale.weekInfo;
    weekInfoCache[locString] = data;
  }
  return data;
}
function parseLocaleString(localeStr) {
  const xIndex = localeStr.indexOf("-x-");
  if (xIndex !== -1) {
    localeStr = localeStr.substring(0, xIndex);
  }
  const uIndex = localeStr.indexOf("-u-");
  if (uIndex === -1) {
    return [localeStr];
  } else {
    let options;
    let selectedStr;
    try {
      options = getCachedDTF(localeStr).resolvedOptions();
      selectedStr = localeStr;
    } catch (e) {
      const smaller = localeStr.substring(0, uIndex);
      options = getCachedDTF(smaller).resolvedOptions();
      selectedStr = smaller;
    }
    const { numberingSystem, calendar } = options;
    return [selectedStr, numberingSystem, calendar];
  }
}
function intlConfigString(localeStr, numberingSystem, outputCalendar) {
  if (outputCalendar || numberingSystem) {
    if (!localeStr.includes("-u-")) {
      localeStr += "-u";
    }
    if (outputCalendar) {
      localeStr += `-ca-${outputCalendar}`;
    }
    if (numberingSystem) {
      localeStr += `-nu-${numberingSystem}`;
    }
    return localeStr;
  } else {
    return localeStr;
  }
}
function mapMonths(f) {
  const ms = [];
  for (let i = 1; i <= 12; i++) {
    const dt = DateTime.utc(2009, i, 1);
    ms.push(f(dt));
  }
  return ms;
}
function mapWeekdays(f) {
  const ms = [];
  for (let i = 1; i <= 7; i++) {
    const dt = DateTime.utc(2016, 11, 13 + i);
    ms.push(f(dt));
  }
  return ms;
}
function listStuff(loc, length, englishFn, intlFn) {
  const mode = loc.listingMode();
  if (mode === "error") {
    return null;
  } else if (mode === "en") {
    return englishFn(length);
  } else {
    return intlFn(length);
  }
}
function supportsFastNumbers(loc) {
  if (loc.numberingSystem && loc.numberingSystem !== "latn") {
    return false;
  } else {
    return loc.numberingSystem === "latn" || !loc.locale || loc.locale.startsWith("en") || new Intl.DateTimeFormat(loc.intl).resolvedOptions().numberingSystem === "latn";
  }
}
class PolyNumberFormatter {
  constructor(intl, forceSimple, opts) {
    this.padTo = opts.padTo || 0;
    this.floor = opts.floor || false;
    const { padTo, floor, ...otherOpts } = opts;
    if (!forceSimple || Object.keys(otherOpts).length > 0) {
      const intlOpts = { useGrouping: false, ...opts };
      if (opts.padTo > 0) intlOpts.minimumIntegerDigits = opts.padTo;
      this.inf = getCachedINF(intl, intlOpts);
    }
  }
  format(i) {
    if (this.inf) {
      const fixed = this.floor ? Math.floor(i) : i;
      return this.inf.format(fixed);
    } else {
      const fixed = this.floor ? Math.floor(i) : roundTo(i, 3);
      return padStart(fixed, this.padTo);
    }
  }
}
class PolyDateFormatter {
  constructor(dt, intl, opts) {
    this.opts = opts;
    this.originalZone = void 0;
    let z = void 0;
    if (this.opts.timeZone) {
      this.dt = dt;
    } else if (dt.zone.type === "fixed") {
      const gmtOffset = -1 * (dt.offset / 60);
      const offsetZ = gmtOffset >= 0 ? `Etc/GMT+${gmtOffset}` : `Etc/GMT${gmtOffset}`;
      if (dt.offset !== 0 && IANAZone.create(offsetZ).valid) {
        z = offsetZ;
        this.dt = dt;
      } else {
        z = "UTC";
        this.dt = dt.offset === 0 ? dt : dt.setZone("UTC").plus({ minutes: dt.offset });
        this.originalZone = dt.zone;
      }
    } else if (dt.zone.type === "system") {
      this.dt = dt;
    } else if (dt.zone.type === "iana") {
      this.dt = dt;
      z = dt.zone.name;
    } else {
      z = "UTC";
      this.dt = dt.setZone("UTC").plus({ minutes: dt.offset });
      this.originalZone = dt.zone;
    }
    const intlOpts = { ...this.opts };
    intlOpts.timeZone = intlOpts.timeZone || z;
    this.dtf = getCachedDTF(intl, intlOpts);
  }
  format() {
    if (this.originalZone) {
      return this.formatToParts().map(({ value }) => value).join("");
    }
    return this.dtf.format(this.dt.toJSDate());
  }
  formatToParts() {
    const parts = this.dtf.formatToParts(this.dt.toJSDate());
    if (this.originalZone) {
      return parts.map((part) => {
        if (part.type === "timeZoneName") {
          const offsetName = this.originalZone.offsetName(this.dt.ts, {
            locale: this.dt.locale,
            format: this.opts.timeZoneName
          });
          return {
            ...part,
            value: offsetName
          };
        } else {
          return part;
        }
      });
    }
    return parts;
  }
  resolvedOptions() {
    return this.dtf.resolvedOptions();
  }
}
class PolyRelFormatter {
  constructor(intl, isEnglish, opts) {
    this.opts = { style: "long", ...opts };
    if (!isEnglish && hasRelative()) {
      this.rtf = getCachedRTF(intl, opts);
    }
  }
  format(count, unit) {
    if (this.rtf) {
      return this.rtf.format(count, unit);
    } else {
      return formatRelativeTime(unit, count, this.opts.numeric, this.opts.style !== "long");
    }
  }
  formatToParts(count, unit) {
    if (this.rtf) {
      return this.rtf.formatToParts(count, unit);
    } else {
      return [];
    }
  }
}
const fallbackWeekSettings = {
  firstDay: 1,
  minimalDays: 4,
  weekend: [6, 7]
};
class Locale {
  static fromOpts(opts) {
    return Locale.create(
      opts.locale,
      opts.numberingSystem,
      opts.outputCalendar,
      opts.weekSettings,
      opts.defaultToEN
    );
  }
  static create(locale, numberingSystem, outputCalendar, weekSettings, defaultToEN = false) {
    const specifiedLocale = locale || Settings.defaultLocale;
    const localeR = specifiedLocale || (defaultToEN ? "en-US" : systemLocale());
    const numberingSystemR = numberingSystem || Settings.defaultNumberingSystem;
    const outputCalendarR = outputCalendar || Settings.defaultOutputCalendar;
    const weekSettingsR = validateWeekSettings(weekSettings) || Settings.defaultWeekSettings;
    return new Locale(localeR, numberingSystemR, outputCalendarR, weekSettingsR, specifiedLocale);
  }
  static resetCache() {
    sysLocaleCache = null;
    intlDTCache = {};
    intlNumCache = {};
    intlRelCache = {};
  }
  static fromObject({ locale, numberingSystem, outputCalendar, weekSettings } = {}) {
    return Locale.create(locale, numberingSystem, outputCalendar, weekSettings);
  }
  constructor(locale, numbering, outputCalendar, weekSettings, specifiedLocale) {
    const [parsedLocale, parsedNumberingSystem, parsedOutputCalendar] = parseLocaleString(locale);
    this.locale = parsedLocale;
    this.numberingSystem = numbering || parsedNumberingSystem || null;
    this.outputCalendar = outputCalendar || parsedOutputCalendar || null;
    this.weekSettings = weekSettings;
    this.intl = intlConfigString(this.locale, this.numberingSystem, this.outputCalendar);
    this.weekdaysCache = { format: {}, standalone: {} };
    this.monthsCache = { format: {}, standalone: {} };
    this.meridiemCache = null;
    this.eraCache = {};
    this.specifiedLocale = specifiedLocale;
    this.fastNumbersCached = null;
  }
  get fastNumbers() {
    if (this.fastNumbersCached == null) {
      this.fastNumbersCached = supportsFastNumbers(this);
    }
    return this.fastNumbersCached;
  }
  listingMode() {
    const isActuallyEn = this.isEnglish();
    const hasNoWeirdness = (this.numberingSystem === null || this.numberingSystem === "latn") && (this.outputCalendar === null || this.outputCalendar === "gregory");
    return isActuallyEn && hasNoWeirdness ? "en" : "intl";
  }
  clone(alts) {
    if (!alts || Object.getOwnPropertyNames(alts).length === 0) {
      return this;
    } else {
      return Locale.create(
        alts.locale || this.specifiedLocale,
        alts.numberingSystem || this.numberingSystem,
        alts.outputCalendar || this.outputCalendar,
        validateWeekSettings(alts.weekSettings) || this.weekSettings,
        alts.defaultToEN || false
      );
    }
  }
  redefaultToEN(alts = {}) {
    return this.clone({ ...alts, defaultToEN: true });
  }
  redefaultToSystem(alts = {}) {
    return this.clone({ ...alts, defaultToEN: false });
  }
  months(length, format = false) {
    return listStuff(this, length, months, () => {
      const intl = format ? { month: length, day: "numeric" } : { month: length }, formatStr = format ? "format" : "standalone";
      if (!this.monthsCache[formatStr][length]) {
        this.monthsCache[formatStr][length] = mapMonths((dt) => this.extract(dt, intl, "month"));
      }
      return this.monthsCache[formatStr][length];
    });
  }
  weekdays(length, format = false) {
    return listStuff(this, length, weekdays, () => {
      const intl = format ? { weekday: length, year: "numeric", month: "long", day: "numeric" } : { weekday: length }, formatStr = format ? "format" : "standalone";
      if (!this.weekdaysCache[formatStr][length]) {
        this.weekdaysCache[formatStr][length] = mapWeekdays(
          (dt) => this.extract(dt, intl, "weekday")
        );
      }
      return this.weekdaysCache[formatStr][length];
    });
  }
  meridiems() {
    return listStuff(
      this,
      void 0,
      () => meridiems,
      () => {
        if (!this.meridiemCache) {
          const intl = { hour: "numeric", hourCycle: "h12" };
          this.meridiemCache = [DateTime.utc(2016, 11, 13, 9), DateTime.utc(2016, 11, 13, 19)].map(
            (dt) => this.extract(dt, intl, "dayperiod")
          );
        }
        return this.meridiemCache;
      }
    );
  }
  eras(length) {
    return listStuff(this, length, eras, () => {
      const intl = { era: length };
      if (!this.eraCache[length]) {
        this.eraCache[length] = [DateTime.utc(-40, 1, 1), DateTime.utc(2017, 1, 1)].map(
          (dt) => this.extract(dt, intl, "era")
        );
      }
      return this.eraCache[length];
    });
  }
  extract(dt, intlOpts, field) {
    const df = this.dtFormatter(dt, intlOpts), results = df.formatToParts(), matching = results.find((m) => m.type.toLowerCase() === field);
    return matching ? matching.value : null;
  }
  numberFormatter(opts = {}) {
    return new PolyNumberFormatter(this.intl, opts.forceSimple || this.fastNumbers, opts);
  }
  dtFormatter(dt, intlOpts = {}) {
    return new PolyDateFormatter(dt, this.intl, intlOpts);
  }
  relFormatter(opts = {}) {
    return new PolyRelFormatter(this.intl, this.isEnglish(), opts);
  }
  listFormatter(opts = {}) {
    return getCachedLF(this.intl, opts);
  }
  isEnglish() {
    return this.locale === "en" || this.locale.toLowerCase() === "en-us" || new Intl.DateTimeFormat(this.intl).resolvedOptions().locale.startsWith("en-us");
  }
  getWeekSettings() {
    if (this.weekSettings) {
      return this.weekSettings;
    } else if (!hasLocaleWeekInfo()) {
      return fallbackWeekSettings;
    } else {
      return getCachedWeekInfo(this.locale);
    }
  }
  getStartOfWeek() {
    return this.getWeekSettings().firstDay;
  }
  getMinDaysInFirstWeek() {
    return this.getWeekSettings().minimalDays;
  }
  getWeekendDays() {
    return this.getWeekSettings().weekend;
  }
  equals(other) {
    return this.locale === other.locale && this.numberingSystem === other.numberingSystem && this.outputCalendar === other.outputCalendar;
  }
  toString() {
    return `Locale(${this.locale}, ${this.numberingSystem}, ${this.outputCalendar})`;
  }
}
let singleton = null;
class FixedOffsetZone extends Zone {
  /**
   * Get a singleton instance of UTC
   * @return {FixedOffsetZone}
   */
  static get utcInstance() {
    if (singleton === null) {
      singleton = new FixedOffsetZone(0);
    }
    return singleton;
  }
  /**
   * Get an instance with a specified offset
   * @param {number} offset - The offset in minutes
   * @return {FixedOffsetZone}
   */
  static instance(offset2) {
    return offset2 === 0 ? FixedOffsetZone.utcInstance : new FixedOffsetZone(offset2);
  }
  /**
   * Get an instance of FixedOffsetZone from a UTC offset string, like "UTC+6"
   * @param {string} s - The offset string to parse
   * @example FixedOffsetZone.parseSpecifier("UTC+6")
   * @example FixedOffsetZone.parseSpecifier("UTC+06")
   * @example FixedOffsetZone.parseSpecifier("UTC-6:00")
   * @return {FixedOffsetZone}
   */
  static parseSpecifier(s2) {
    if (s2) {
      const r = s2.match(/^utc(?:([+-]\d{1,2})(?::(\d{2}))?)?$/i);
      if (r) {
        return new FixedOffsetZone(signedOffset(r[1], r[2]));
      }
    }
    return null;
  }
  constructor(offset2) {
    super();
    this.fixed = offset2;
  }
  /**
   * The type of zone. `fixed` for all instances of `FixedOffsetZone`.
   * @override
   * @type {string}
   */
  get type() {
    return "fixed";
  }
  /**
   * The name of this zone.
   * All fixed zones' names always start with "UTC" (plus optional offset)
   * @override
   * @type {string}
   */
  get name() {
    return this.fixed === 0 ? "UTC" : `UTC${formatOffset(this.fixed, "narrow")}`;
  }
  /**
   * The IANA name of this zone, i.e. `Etc/UTC` or `Etc/GMT+/-nn`
   *
   * @override
   * @type {string}
   */
  get ianaName() {
    if (this.fixed === 0) {
      return "Etc/UTC";
    } else {
      return `Etc/GMT${formatOffset(-this.fixed, "narrow")}`;
    }
  }
  /**
   * Returns the offset's common name at the specified timestamp.
   *
   * For fixed offset zones this equals to the zone name.
   * @override
   */
  offsetName() {
    return this.name;
  }
  /**
   * Returns the offset's value as a string
   * @override
   * @param {number} ts - Epoch milliseconds for which to get the offset
   * @param {string} format - What style of offset to return.
   *                          Accepts 'narrow', 'short', or 'techie'. Returning '+6', '+06:00', or '+0600' respectively
   * @return {string}
   */
  formatOffset(ts, format) {
    return formatOffset(this.fixed, format);
  }
  /**
   * Returns whether the offset is known to be fixed for the whole year:
   * Always returns true for all fixed offset zones.
   * @override
   * @type {boolean}
   */
  get isUniversal() {
    return true;
  }
  /**
   * Return the offset in minutes for this zone at the specified timestamp.
   *
   * For fixed offset zones, this is constant and does not depend on a timestamp.
   * @override
   * @return {number}
   */
  offset() {
    return this.fixed;
  }
  /**
   * Return whether this Zone is equal to another zone (i.e. also fixed and same offset)
   * @override
   * @param {Zone} otherZone - the zone to compare
   * @return {boolean}
   */
  equals(otherZone) {
    return otherZone.type === "fixed" && otherZone.fixed === this.fixed;
  }
  /**
   * Return whether this Zone is valid:
   * All fixed offset zones are valid.
   * @override
   * @type {boolean}
   */
  get isValid() {
    return true;
  }
}
class InvalidZone extends Zone {
  constructor(zoneName) {
    super();
    this.zoneName = zoneName;
  }
  /** @override **/
  get type() {
    return "invalid";
  }
  /** @override **/
  get name() {
    return this.zoneName;
  }
  /** @override **/
  get isUniversal() {
    return false;
  }
  /** @override **/
  offsetName() {
    return null;
  }
  /** @override **/
  formatOffset() {
    return "";
  }
  /** @override **/
  offset() {
    return NaN;
  }
  /** @override **/
  equals() {
    return false;
  }
  /** @override **/
  get isValid() {
    return false;
  }
}
function normalizeZone(input, defaultZone2) {
  if (isUndefined(input) || input === null) {
    return defaultZone2;
  } else if (input instanceof Zone) {
    return input;
  } else if (isString(input)) {
    const lowered = input.toLowerCase();
    if (lowered === "default") return defaultZone2;
    else if (lowered === "local" || lowered === "system") return SystemZone.instance;
    else if (lowered === "utc" || lowered === "gmt") return FixedOffsetZone.utcInstance;
    else return FixedOffsetZone.parseSpecifier(lowered) || IANAZone.create(input);
  } else if (isNumber(input)) {
    return FixedOffsetZone.instance(input);
  } else if (typeof input === "object" && "offset" in input && typeof input.offset === "function") {
    return input;
  } else {
    return new InvalidZone(input);
  }
}
const numberingSystems = {
  arab: "[٠-٩]",
  arabext: "[۰-۹]",
  bali: "[᭐-᭙]",
  beng: "[০-৯]",
  deva: "[०-९]",
  fullwide: "[０-９]",
  gujr: "[૦-૯]",
  hanidec: "[〇|一|二|三|四|五|六|七|八|九]",
  khmr: "[០-៩]",
  knda: "[೦-೯]",
  laoo: "[໐-໙]",
  limb: "[᥆-᥏]",
  mlym: "[൦-൯]",
  mong: "[᠐-᠙]",
  mymr: "[၀-၉]",
  orya: "[୦-୯]",
  tamldec: "[௦-௯]",
  telu: "[౦-౯]",
  thai: "[๐-๙]",
  tibt: "[༠-༩]",
  latn: "\\d"
};
const numberingSystemsUTF16 = {
  arab: [1632, 1641],
  arabext: [1776, 1785],
  bali: [6992, 7001],
  beng: [2534, 2543],
  deva: [2406, 2415],
  fullwide: [65296, 65303],
  gujr: [2790, 2799],
  khmr: [6112, 6121],
  knda: [3302, 3311],
  laoo: [3792, 3801],
  limb: [6470, 6479],
  mlym: [3430, 3439],
  mong: [6160, 6169],
  mymr: [4160, 4169],
  orya: [2918, 2927],
  tamldec: [3046, 3055],
  telu: [3174, 3183],
  thai: [3664, 3673],
  tibt: [3872, 3881]
};
const hanidecChars = numberingSystems.hanidec.replace(/[\[|\]]/g, "").split("");
function parseDigits(str) {
  let value = parseInt(str, 10);
  if (isNaN(value)) {
    value = "";
    for (let i = 0; i < str.length; i++) {
      const code = str.charCodeAt(i);
      if (str[i].search(numberingSystems.hanidec) !== -1) {
        value += hanidecChars.indexOf(str[i]);
      } else {
        for (const key in numberingSystemsUTF16) {
          const [min, max] = numberingSystemsUTF16[key];
          if (code >= min && code <= max) {
            value += code - min;
          }
        }
      }
    }
    return parseInt(value, 10);
  } else {
    return value;
  }
}
let digitRegexCache = {};
function resetDigitRegexCache() {
  digitRegexCache = {};
}
function digitRegex({ numberingSystem }, append = "") {
  const ns = numberingSystem || "latn";
  if (!digitRegexCache[ns]) {
    digitRegexCache[ns] = {};
  }
  if (!digitRegexCache[ns][append]) {
    digitRegexCache[ns][append] = new RegExp(`${numberingSystems[ns]}${append}`);
  }
  return digitRegexCache[ns][append];
}
let now = () => Date.now(), defaultZone = "system", defaultLocale = null, defaultNumberingSystem = null, defaultOutputCalendar = null, twoDigitCutoffYear = 60, throwOnInvalid, defaultWeekSettings = null;
class Settings {
  /**
   * Get the callback for returning the current timestamp.
   * @type {function}
   */
  static get now() {
    return now;
  }
  /**
   * Set the callback for returning the current timestamp.
   * The function should return a number, which will be interpreted as an Epoch millisecond count
   * @type {function}
   * @example Settings.now = () => Date.now() + 3000 // pretend it is 3 seconds in the future
   * @example Settings.now = () => 0 // always pretend it's Jan 1, 1970 at midnight in UTC time
   */
  static set now(n2) {
    now = n2;
  }
  /**
   * Set the default time zone to create DateTimes in. Does not affect existing instances.
   * Use the value "system" to reset this value to the system's time zone.
   * @type {string}
   */
  static set defaultZone(zone) {
    defaultZone = zone;
  }
  /**
   * Get the default time zone object currently used to create DateTimes. Does not affect existing instances.
   * The default value is the system's time zone (the one set on the machine that runs this code).
   * @type {Zone}
   */
  static get defaultZone() {
    return normalizeZone(defaultZone, SystemZone.instance);
  }
  /**
   * Get the default locale to create DateTimes with. Does not affect existing instances.
   * @type {string}
   */
  static get defaultLocale() {
    return defaultLocale;
  }
  /**
   * Set the default locale to create DateTimes with. Does not affect existing instances.
   * @type {string}
   */
  static set defaultLocale(locale) {
    defaultLocale = locale;
  }
  /**
   * Get the default numbering system to create DateTimes with. Does not affect existing instances.
   * @type {string}
   */
  static get defaultNumberingSystem() {
    return defaultNumberingSystem;
  }
  /**
   * Set the default numbering system to create DateTimes with. Does not affect existing instances.
   * @type {string}
   */
  static set defaultNumberingSystem(numberingSystem) {
    defaultNumberingSystem = numberingSystem;
  }
  /**
   * Get the default output calendar to create DateTimes with. Does not affect existing instances.
   * @type {string}
   */
  static get defaultOutputCalendar() {
    return defaultOutputCalendar;
  }
  /**
   * Set the default output calendar to create DateTimes with. Does not affect existing instances.
   * @type {string}
   */
  static set defaultOutputCalendar(outputCalendar) {
    defaultOutputCalendar = outputCalendar;
  }
  /**
   * @typedef {Object} WeekSettings
   * @property {number} firstDay
   * @property {number} minimalDays
   * @property {number[]} weekend
   */
  /**
   * @return {WeekSettings|null}
   */
  static get defaultWeekSettings() {
    return defaultWeekSettings;
  }
  /**
   * Allows overriding the default locale week settings, i.e. the start of the week, the weekend and
   * how many days are required in the first week of a year.
   * Does not affect existing instances.
   *
   * @param {WeekSettings|null} weekSettings
   */
  static set defaultWeekSettings(weekSettings) {
    defaultWeekSettings = validateWeekSettings(weekSettings);
  }
  /**
   * Get the cutoff year for whether a 2-digit year string is interpreted in the current or previous century. Numbers higher than the cutoff will be considered to mean 19xx and numbers lower or equal to the cutoff will be considered 20xx.
   * @type {number}
   */
  static get twoDigitCutoffYear() {
    return twoDigitCutoffYear;
  }
  /**
   * Set the cutoff year for whether a 2-digit year string is interpreted in the current or previous century. Numbers higher than the cutoff will be considered to mean 19xx and numbers lower or equal to the cutoff will be considered 20xx.
   * @type {number}
   * @example Settings.twoDigitCutoffYear = 0 // all 'yy' are interpreted as 20th century
   * @example Settings.twoDigitCutoffYear = 99 // all 'yy' are interpreted as 21st century
   * @example Settings.twoDigitCutoffYear = 50 // '49' -> 2049; '50' -> 1950
   * @example Settings.twoDigitCutoffYear = 1950 // interpreted as 50
   * @example Settings.twoDigitCutoffYear = 2050 // ALSO interpreted as 50
   */
  static set twoDigitCutoffYear(cutoffYear) {
    twoDigitCutoffYear = cutoffYear % 100;
  }
  /**
   * Get whether Luxon will throw when it encounters invalid DateTimes, Durations, or Intervals
   * @type {boolean}
   */
  static get throwOnInvalid() {
    return throwOnInvalid;
  }
  /**
   * Set whether Luxon will throw when it encounters invalid DateTimes, Durations, or Intervals
   * @type {boolean}
   */
  static set throwOnInvalid(t) {
    throwOnInvalid = t;
  }
  /**
   * Reset Luxon's global caches. Should only be necessary in testing scenarios.
   * @return {void}
   */
  static resetCaches() {
    Locale.resetCache();
    IANAZone.resetCache();
    DateTime.resetCache();
    resetDigitRegexCache();
  }
}
class Invalid {
  constructor(reason, explanation) {
    this.reason = reason;
    this.explanation = explanation;
  }
  toMessage() {
    if (this.explanation) {
      return `${this.reason}: ${this.explanation}`;
    } else {
      return this.reason;
    }
  }
}
const nonLeapLadder = [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334], leapLadder = [0, 31, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335];
function unitOutOfRange(unit, value) {
  return new Invalid(
    "unit out of range",
    `you specified ${value} (of type ${typeof value}) as a ${unit}, which is invalid`
  );
}
function dayOfWeek(year, month, day) {
  const d = new Date(Date.UTC(year, month - 1, day));
  if (year < 100 && year >= 0) {
    d.setUTCFullYear(d.getUTCFullYear() - 1900);
  }
  const js = d.getUTCDay();
  return js === 0 ? 7 : js;
}
function computeOrdinal(year, month, day) {
  return day + (isLeapYear(year) ? leapLadder : nonLeapLadder)[month - 1];
}
function uncomputeOrdinal(year, ordinal) {
  const table = isLeapYear(year) ? leapLadder : nonLeapLadder, month0 = table.findIndex((i) => i < ordinal), day = ordinal - table[month0];
  return { month: month0 + 1, day };
}
function isoWeekdayToLocal(isoWeekday, startOfWeek) {
  return (isoWeekday - startOfWeek + 7) % 7 + 1;
}
function gregorianToWeek(gregObj, minDaysInFirstWeek = 4, startOfWeek = 1) {
  const { year, month, day } = gregObj, ordinal = computeOrdinal(year, month, day), weekday = isoWeekdayToLocal(dayOfWeek(year, month, day), startOfWeek);
  let weekNumber = Math.floor((ordinal - weekday + 14 - minDaysInFirstWeek) / 7), weekYear;
  if (weekNumber < 1) {
    weekYear = year - 1;
    weekNumber = weeksInWeekYear(weekYear, minDaysInFirstWeek, startOfWeek);
  } else if (weekNumber > weeksInWeekYear(year, minDaysInFirstWeek, startOfWeek)) {
    weekYear = year + 1;
    weekNumber = 1;
  } else {
    weekYear = year;
  }
  return { weekYear, weekNumber, weekday, ...timeObject(gregObj) };
}
function weekToGregorian(weekData, minDaysInFirstWeek = 4, startOfWeek = 1) {
  const { weekYear, weekNumber, weekday } = weekData, weekdayOfJan4 = isoWeekdayToLocal(dayOfWeek(weekYear, 1, minDaysInFirstWeek), startOfWeek), yearInDays = daysInYear(weekYear);
  let ordinal = weekNumber * 7 + weekday - weekdayOfJan4 - 7 + minDaysInFirstWeek, year;
  if (ordinal < 1) {
    year = weekYear - 1;
    ordinal += daysInYear(year);
  } else if (ordinal > yearInDays) {
    year = weekYear + 1;
    ordinal -= daysInYear(weekYear);
  } else {
    year = weekYear;
  }
  const { month, day } = uncomputeOrdinal(year, ordinal);
  return { year, month, day, ...timeObject(weekData) };
}
function gregorianToOrdinal(gregData) {
  const { year, month, day } = gregData;
  const ordinal = computeOrdinal(year, month, day);
  return { year, ordinal, ...timeObject(gregData) };
}
function ordinalToGregorian(ordinalData) {
  const { year, ordinal } = ordinalData;
  const { month, day } = uncomputeOrdinal(year, ordinal);
  return { year, month, day, ...timeObject(ordinalData) };
}
function usesLocalWeekValues(obj, loc) {
  const hasLocaleWeekData = !isUndefined(obj.localWeekday) || !isUndefined(obj.localWeekNumber) || !isUndefined(obj.localWeekYear);
  if (hasLocaleWeekData) {
    const hasIsoWeekData = !isUndefined(obj.weekday) || !isUndefined(obj.weekNumber) || !isUndefined(obj.weekYear);
    if (hasIsoWeekData) {
      throw new ConflictingSpecificationError(
        "Cannot mix locale-based week fields with ISO-based week fields"
      );
    }
    if (!isUndefined(obj.localWeekday)) obj.weekday = obj.localWeekday;
    if (!isUndefined(obj.localWeekNumber)) obj.weekNumber = obj.localWeekNumber;
    if (!isUndefined(obj.localWeekYear)) obj.weekYear = obj.localWeekYear;
    delete obj.localWeekday;
    delete obj.localWeekNumber;
    delete obj.localWeekYear;
    return {
      minDaysInFirstWeek: loc.getMinDaysInFirstWeek(),
      startOfWeek: loc.getStartOfWeek()
    };
  } else {
    return { minDaysInFirstWeek: 4, startOfWeek: 1 };
  }
}
function hasInvalidWeekData(obj, minDaysInFirstWeek = 4, startOfWeek = 1) {
  const validYear = isInteger(obj.weekYear), validWeek = integerBetween(
    obj.weekNumber,
    1,
    weeksInWeekYear(obj.weekYear, minDaysInFirstWeek, startOfWeek)
  ), validWeekday = integerBetween(obj.weekday, 1, 7);
  if (!validYear) {
    return unitOutOfRange("weekYear", obj.weekYear);
  } else if (!validWeek) {
    return unitOutOfRange("week", obj.weekNumber);
  } else if (!validWeekday) {
    return unitOutOfRange("weekday", obj.weekday);
  } else return false;
}
function hasInvalidOrdinalData(obj) {
  const validYear = isInteger(obj.year), validOrdinal = integerBetween(obj.ordinal, 1, daysInYear(obj.year));
  if (!validYear) {
    return unitOutOfRange("year", obj.year);
  } else if (!validOrdinal) {
    return unitOutOfRange("ordinal", obj.ordinal);
  } else return false;
}
function hasInvalidGregorianData(obj) {
  const validYear = isInteger(obj.year), validMonth = integerBetween(obj.month, 1, 12), validDay = integerBetween(obj.day, 1, daysInMonth(obj.year, obj.month));
  if (!validYear) {
    return unitOutOfRange("year", obj.year);
  } else if (!validMonth) {
    return unitOutOfRange("month", obj.month);
  } else if (!validDay) {
    return unitOutOfRange("day", obj.day);
  } else return false;
}
function hasInvalidTimeData(obj) {
  const { hour, minute, second, millisecond } = obj;
  const validHour = integerBetween(hour, 0, 23) || hour === 24 && minute === 0 && second === 0 && millisecond === 0, validMinute = integerBetween(minute, 0, 59), validSecond = integerBetween(second, 0, 59), validMillisecond = integerBetween(millisecond, 0, 999);
  if (!validHour) {
    return unitOutOfRange("hour", hour);
  } else if (!validMinute) {
    return unitOutOfRange("minute", minute);
  } else if (!validSecond) {
    return unitOutOfRange("second", second);
  } else if (!validMillisecond) {
    return unitOutOfRange("millisecond", millisecond);
  } else return false;
}
function isUndefined(o) {
  return typeof o === "undefined";
}
function isNumber(o) {
  return typeof o === "number";
}
function isInteger(o) {
  return typeof o === "number" && o % 1 === 0;
}
function isString(o) {
  return typeof o === "string";
}
function isDate(o) {
  return Object.prototype.toString.call(o) === "[object Date]";
}
function hasRelative() {
  try {
    return typeof Intl !== "undefined" && !!Intl.RelativeTimeFormat;
  } catch (e) {
    return false;
  }
}
function hasLocaleWeekInfo() {
  try {
    return typeof Intl !== "undefined" && !!Intl.Locale && ("weekInfo" in Intl.Locale.prototype || "getWeekInfo" in Intl.Locale.prototype);
  } catch (e) {
    return false;
  }
}
function maybeArray(thing) {
  return Array.isArray(thing) ? thing : [thing];
}
function bestBy(arr, by, compare) {
  if (arr.length === 0) {
    return void 0;
  }
  return arr.reduce((best, next) => {
    const pair = [by(next), next];
    if (!best) {
      return pair;
    } else if (compare(best[0], pair[0]) === best[0]) {
      return best;
    } else {
      return pair;
    }
  }, null)[1];
}
function pick(obj, keys) {
  return keys.reduce((a, k) => {
    a[k] = obj[k];
    return a;
  }, {});
}
function hasOwnProperty(obj, prop) {
  return Object.prototype.hasOwnProperty.call(obj, prop);
}
function validateWeekSettings(settings) {
  if (settings == null) {
    return null;
  } else if (typeof settings !== "object") {
    throw new InvalidArgumentError("Week settings must be an object");
  } else {
    if (!integerBetween(settings.firstDay, 1, 7) || !integerBetween(settings.minimalDays, 1, 7) || !Array.isArray(settings.weekend) || settings.weekend.some((v) => !integerBetween(v, 1, 7))) {
      throw new InvalidArgumentError("Invalid week settings");
    }
    return {
      firstDay: settings.firstDay,
      minimalDays: settings.minimalDays,
      weekend: Array.from(settings.weekend)
    };
  }
}
function integerBetween(thing, bottom, top) {
  return isInteger(thing) && thing >= bottom && thing <= top;
}
function floorMod(x, n2) {
  return x - n2 * Math.floor(x / n2);
}
function padStart(input, n2 = 2) {
  const isNeg = input < 0;
  let padded;
  if (isNeg) {
    padded = "-" + ("" + -input).padStart(n2, "0");
  } else {
    padded = ("" + input).padStart(n2, "0");
  }
  return padded;
}
function parseInteger(string) {
  if (isUndefined(string) || string === null || string === "") {
    return void 0;
  } else {
    return parseInt(string, 10);
  }
}
function parseFloating(string) {
  if (isUndefined(string) || string === null || string === "") {
    return void 0;
  } else {
    return parseFloat(string);
  }
}
function parseMillis(fraction) {
  if (isUndefined(fraction) || fraction === null || fraction === "") {
    return void 0;
  } else {
    const f = parseFloat("0." + fraction) * 1e3;
    return Math.floor(f);
  }
}
function roundTo(number, digits, towardZero = false) {
  const factor = 10 ** digits, rounder = towardZero ? Math.trunc : Math.round;
  return rounder(number * factor) / factor;
}
function isLeapYear(year) {
  return year % 4 === 0 && (year % 100 !== 0 || year % 400 === 0);
}
function daysInYear(year) {
  return isLeapYear(year) ? 366 : 365;
}
function daysInMonth(year, month) {
  const modMonth = floorMod(month - 1, 12) + 1, modYear = year + (month - modMonth) / 12;
  if (modMonth === 2) {
    return isLeapYear(modYear) ? 29 : 28;
  } else {
    return [31, null, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31][modMonth - 1];
  }
}
function objToLocalTS(obj) {
  let d = Date.UTC(
    obj.year,
    obj.month - 1,
    obj.day,
    obj.hour,
    obj.minute,
    obj.second,
    obj.millisecond
  );
  if (obj.year < 100 && obj.year >= 0) {
    d = new Date(d);
    d.setUTCFullYear(obj.year, obj.month - 1, obj.day);
  }
  return +d;
}
function firstWeekOffset(year, minDaysInFirstWeek, startOfWeek) {
  const fwdlw = isoWeekdayToLocal(dayOfWeek(year, 1, minDaysInFirstWeek), startOfWeek);
  return -fwdlw + minDaysInFirstWeek - 1;
}
function weeksInWeekYear(weekYear, minDaysInFirstWeek = 4, startOfWeek = 1) {
  const weekOffset = firstWeekOffset(weekYear, minDaysInFirstWeek, startOfWeek);
  const weekOffsetNext = firstWeekOffset(weekYear + 1, minDaysInFirstWeek, startOfWeek);
  return (daysInYear(weekYear) - weekOffset + weekOffsetNext) / 7;
}
function untruncateYear(year) {
  if (year > 99) {
    return year;
  } else return year > Settings.twoDigitCutoffYear ? 1900 + year : 2e3 + year;
}
function parseZoneInfo(ts, offsetFormat, locale, timeZone = null) {
  const date = new Date(ts), intlOpts = {
    hourCycle: "h23",
    year: "numeric",
    month: "2-digit",
    day: "2-digit",
    hour: "2-digit",
    minute: "2-digit"
  };
  if (timeZone) {
    intlOpts.timeZone = timeZone;
  }
  const modified = { timeZoneName: offsetFormat, ...intlOpts };
  const parsed = new Intl.DateTimeFormat(locale, modified).formatToParts(date).find((m) => m.type.toLowerCase() === "timezonename");
  return parsed ? parsed.value : null;
}
function signedOffset(offHourStr, offMinuteStr) {
  let offHour = parseInt(offHourStr, 10);
  if (Number.isNaN(offHour)) {
    offHour = 0;
  }
  const offMin = parseInt(offMinuteStr, 10) || 0, offMinSigned = offHour < 0 || Object.is(offHour, -0) ? -offMin : offMin;
  return offHour * 60 + offMinSigned;
}
function asNumber(value) {
  const numericValue = Number(value);
  if (typeof value === "boolean" || value === "" || Number.isNaN(numericValue))
    throw new InvalidArgumentError(`Invalid unit value ${value}`);
  return numericValue;
}
function normalizeObject(obj, normalizer) {
  const normalized = {};
  for (const u in obj) {
    if (hasOwnProperty(obj, u)) {
      const v = obj[u];
      if (v === void 0 || v === null) continue;
      normalized[normalizer(u)] = asNumber(v);
    }
  }
  return normalized;
}
function formatOffset(offset2, format) {
  const hours = Math.trunc(Math.abs(offset2 / 60)), minutes = Math.trunc(Math.abs(offset2 % 60)), sign = offset2 >= 0 ? "+" : "-";
  switch (format) {
    case "short":
      return `${sign}${padStart(hours, 2)}:${padStart(minutes, 2)}`;
    case "narrow":
      return `${sign}${hours}${minutes > 0 ? `:${minutes}` : ""}`;
    case "techie":
      return `${sign}${padStart(hours, 2)}${padStart(minutes, 2)}`;
    default:
      throw new RangeError(`Value format ${format} is out of range for property format`);
  }
}
function timeObject(obj) {
  return pick(obj, ["hour", "minute", "second", "millisecond"]);
}
const monthsLong = [
  "January",
  "February",
  "March",
  "April",
  "May",
  "June",
  "July",
  "August",
  "September",
  "October",
  "November",
  "December"
];
const monthsShort = [
  "Jan",
  "Feb",
  "Mar",
  "Apr",
  "May",
  "Jun",
  "Jul",
  "Aug",
  "Sep",
  "Oct",
  "Nov",
  "Dec"
];
const monthsNarrow = ["J", "F", "M", "A", "M", "J", "J", "A", "S", "O", "N", "D"];
function months(length) {
  switch (length) {
    case "narrow":
      return [...monthsNarrow];
    case "short":
      return [...monthsShort];
    case "long":
      return [...monthsLong];
    case "numeric":
      return ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"];
    case "2-digit":
      return ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"];
    default:
      return null;
  }
}
const weekdaysLong = [
  "Monday",
  "Tuesday",
  "Wednesday",
  "Thursday",
  "Friday",
  "Saturday",
  "Sunday"
];
const weekdaysShort = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
const weekdaysNarrow = ["M", "T", "W", "T", "F", "S", "S"];
function weekdays(length) {
  switch (length) {
    case "narrow":
      return [...weekdaysNarrow];
    case "short":
      return [...weekdaysShort];
    case "long":
      return [...weekdaysLong];
    case "numeric":
      return ["1", "2", "3", "4", "5", "6", "7"];
    default:
      return null;
  }
}
const meridiems = ["AM", "PM"];
const erasLong = ["Before Christ", "Anno Domini"];
const erasShort = ["BC", "AD"];
const erasNarrow = ["B", "A"];
function eras(length) {
  switch (length) {
    case "narrow":
      return [...erasNarrow];
    case "short":
      return [...erasShort];
    case "long":
      return [...erasLong];
    default:
      return null;
  }
}
function meridiemForDateTime(dt) {
  return meridiems[dt.hour < 12 ? 0 : 1];
}
function weekdayForDateTime(dt, length) {
  return weekdays(length)[dt.weekday - 1];
}
function monthForDateTime(dt, length) {
  return months(length)[dt.month - 1];
}
function eraForDateTime(dt, length) {
  return eras(length)[dt.year < 0 ? 0 : 1];
}
function formatRelativeTime(unit, count, numeric = "always", narrow = false) {
  const units = {
    years: ["year", "yr."],
    quarters: ["quarter", "qtr."],
    months: ["month", "mo."],
    weeks: ["week", "wk."],
    days: ["day", "day", "days"],
    hours: ["hour", "hr."],
    minutes: ["minute", "min."],
    seconds: ["second", "sec."]
  };
  const lastable = ["hours", "minutes", "seconds"].indexOf(unit) === -1;
  if (numeric === "auto" && lastable) {
    const isDay = unit === "days";
    switch (count) {
      case 1:
        return isDay ? "tomorrow" : `next ${units[unit][0]}`;
      case -1:
        return isDay ? "yesterday" : `last ${units[unit][0]}`;
      case 0:
        return isDay ? "today" : `this ${units[unit][0]}`;
    }
  }
  const isInPast = Object.is(count, -0) || count < 0, fmtValue = Math.abs(count), singular = fmtValue === 1, lilUnits = units[unit], fmtUnit = narrow ? singular ? lilUnits[1] : lilUnits[2] || lilUnits[1] : singular ? units[unit][0] : unit;
  return isInPast ? `${fmtValue} ${fmtUnit} ago` : `in ${fmtValue} ${fmtUnit}`;
}
function stringifyTokens(splits, tokenToString) {
  let s2 = "";
  for (const token of splits) {
    if (token.literal) {
      s2 += token.val;
    } else {
      s2 += tokenToString(token.val);
    }
  }
  return s2;
}
const macroTokenToFormatOpts = {
  D: DATE_SHORT,
  DD: DATE_MED,
  DDD: DATE_FULL,
  DDDD: DATE_HUGE,
  t: TIME_SIMPLE,
  tt: TIME_WITH_SECONDS,
  ttt: TIME_WITH_SHORT_OFFSET,
  tttt: TIME_WITH_LONG_OFFSET,
  T: TIME_24_SIMPLE,
  TT: TIME_24_WITH_SECONDS,
  TTT: TIME_24_WITH_SHORT_OFFSET,
  TTTT: TIME_24_WITH_LONG_OFFSET,
  f: DATETIME_SHORT,
  ff: DATETIME_MED,
  fff: DATETIME_FULL,
  ffff: DATETIME_HUGE,
  F: DATETIME_SHORT_WITH_SECONDS,
  FF: DATETIME_MED_WITH_SECONDS,
  FFF: DATETIME_FULL_WITH_SECONDS,
  FFFF: DATETIME_HUGE_WITH_SECONDS
};
class Formatter {
  static create(locale, opts = {}) {
    return new Formatter(locale, opts);
  }
  static parseFormat(fmt) {
    let current = null, currentFull = "", bracketed = false;
    const splits = [];
    for (let i = 0; i < fmt.length; i++) {
      const c = fmt.charAt(i);
      if (c === "'") {
        if (currentFull.length > 0) {
          splits.push({ literal: bracketed || /^\s+$/.test(currentFull), val: currentFull });
        }
        current = null;
        currentFull = "";
        bracketed = !bracketed;
      } else if (bracketed) {
        currentFull += c;
      } else if (c === current) {
        currentFull += c;
      } else {
        if (currentFull.length > 0) {
          splits.push({ literal: /^\s+$/.test(currentFull), val: currentFull });
        }
        currentFull = c;
        current = c;
      }
    }
    if (currentFull.length > 0) {
      splits.push({ literal: bracketed || /^\s+$/.test(currentFull), val: currentFull });
    }
    return splits;
  }
  static macroTokenToFormatOpts(token) {
    return macroTokenToFormatOpts[token];
  }
  constructor(locale, formatOpts) {
    this.opts = formatOpts;
    this.loc = locale;
    this.systemLoc = null;
  }
  formatWithSystemDefault(dt, opts) {
    if (this.systemLoc === null) {
      this.systemLoc = this.loc.redefaultToSystem();
    }
    const df = this.systemLoc.dtFormatter(dt, { ...this.opts, ...opts });
    return df.format();
  }
  dtFormatter(dt, opts = {}) {
    return this.loc.dtFormatter(dt, { ...this.opts, ...opts });
  }
  formatDateTime(dt, opts) {
    return this.dtFormatter(dt, opts).format();
  }
  formatDateTimeParts(dt, opts) {
    return this.dtFormatter(dt, opts).formatToParts();
  }
  formatInterval(interval, opts) {
    const df = this.dtFormatter(interval.start, opts);
    return df.dtf.formatRange(interval.start.toJSDate(), interval.end.toJSDate());
  }
  resolvedOptions(dt, opts) {
    return this.dtFormatter(dt, opts).resolvedOptions();
  }
  num(n2, p = 0) {
    if (this.opts.forceSimple) {
      return padStart(n2, p);
    }
    const opts = { ...this.opts };
    if (p > 0) {
      opts.padTo = p;
    }
    return this.loc.numberFormatter(opts).format(n2);
  }
  formatDateTimeFromString(dt, fmt) {
    const knownEnglish = this.loc.listingMode() === "en", useDateTimeFormatter = this.loc.outputCalendar && this.loc.outputCalendar !== "gregory", string = (opts, extract) => this.loc.extract(dt, opts, extract), formatOffset2 = (opts) => {
      if (dt.isOffsetFixed && dt.offset === 0 && opts.allowZ) {
        return "Z";
      }
      return dt.isValid ? dt.zone.formatOffset(dt.ts, opts.format) : "";
    }, meridiem = () => knownEnglish ? meridiemForDateTime(dt) : string({ hour: "numeric", hourCycle: "h12" }, "dayperiod"), month = (length, standalone) => knownEnglish ? monthForDateTime(dt, length) : string(standalone ? { month: length } : { month: length, day: "numeric" }, "month"), weekday = (length, standalone) => knownEnglish ? weekdayForDateTime(dt, length) : string(
      standalone ? { weekday: length } : { weekday: length, month: "long", day: "numeric" },
      "weekday"
    ), maybeMacro = (token) => {
      const formatOpts = Formatter.macroTokenToFormatOpts(token);
      if (formatOpts) {
        return this.formatWithSystemDefault(dt, formatOpts);
      } else {
        return token;
      }
    }, era = (length) => knownEnglish ? eraForDateTime(dt, length) : string({ era: length }, "era"), tokenToString = (token) => {
      switch (token) {
        case "S":
          return this.num(dt.millisecond);
        case "u":
        case "SSS":
          return this.num(dt.millisecond, 3);
        case "s":
          return this.num(dt.second);
        case "ss":
          return this.num(dt.second, 2);
        case "uu":
          return this.num(Math.floor(dt.millisecond / 10), 2);
        case "uuu":
          return this.num(Math.floor(dt.millisecond / 100));
        case "m":
          return this.num(dt.minute);
        case "mm":
          return this.num(dt.minute, 2);
        case "h":
          return this.num(dt.hour % 12 === 0 ? 12 : dt.hour % 12);
        case "hh":
          return this.num(dt.hour % 12 === 0 ? 12 : dt.hour % 12, 2);
        case "H":
          return this.num(dt.hour);
        case "HH":
          return this.num(dt.hour, 2);
        case "Z":
          return formatOffset2({ format: "narrow", allowZ: this.opts.allowZ });
        case "ZZ":
          return formatOffset2({ format: "short", allowZ: this.opts.allowZ });
        case "ZZZ":
          return formatOffset2({ format: "techie", allowZ: this.opts.allowZ });
        case "ZZZZ":
          return dt.zone.offsetName(dt.ts, { format: "short", locale: this.loc.locale });
        case "ZZZZZ":
          return dt.zone.offsetName(dt.ts, { format: "long", locale: this.loc.locale });
        case "z":
          return dt.zoneName;
        case "a":
          return meridiem();
        case "d":
          return useDateTimeFormatter ? string({ day: "numeric" }, "day") : this.num(dt.day);
        case "dd":
          return useDateTimeFormatter ? string({ day: "2-digit" }, "day") : this.num(dt.day, 2);
        case "c":
          return this.num(dt.weekday);
        case "ccc":
          return weekday("short", true);
        case "cccc":
          return weekday("long", true);
        case "ccccc":
          return weekday("narrow", true);
        case "E":
          return this.num(dt.weekday);
        case "EEE":
          return weekday("short", false);
        case "EEEE":
          return weekday("long", false);
        case "EEEEE":
          return weekday("narrow", false);
        case "L":
          return useDateTimeFormatter ? string({ month: "numeric", day: "numeric" }, "month") : this.num(dt.month);
        case "LL":
          return useDateTimeFormatter ? string({ month: "2-digit", day: "numeric" }, "month") : this.num(dt.month, 2);
        case "LLL":
          return month("short", true);
        case "LLLL":
          return month("long", true);
        case "LLLLL":
          return month("narrow", true);
        case "M":
          return useDateTimeFormatter ? string({ month: "numeric" }, "month") : this.num(dt.month);
        case "MM":
          return useDateTimeFormatter ? string({ month: "2-digit" }, "month") : this.num(dt.month, 2);
        case "MMM":
          return month("short", false);
        case "MMMM":
          return month("long", false);
        case "MMMMM":
          return month("narrow", false);
        case "y":
          return useDateTimeFormatter ? string({ year: "numeric" }, "year") : this.num(dt.year);
        case "yy":
          return useDateTimeFormatter ? string({ year: "2-digit" }, "year") : this.num(dt.year.toString().slice(-2), 2);
        case "yyyy":
          return useDateTimeFormatter ? string({ year: "numeric" }, "year") : this.num(dt.year, 4);
        case "yyyyyy":
          return useDateTimeFormatter ? string({ year: "numeric" }, "year") : this.num(dt.year, 6);
        case "G":
          return era("short");
        case "GG":
          return era("long");
        case "GGGGG":
          return era("narrow");
        case "kk":
          return this.num(dt.weekYear.toString().slice(-2), 2);
        case "kkkk":
          return this.num(dt.weekYear, 4);
        case "W":
          return this.num(dt.weekNumber);
        case "WW":
          return this.num(dt.weekNumber, 2);
        case "n":
          return this.num(dt.localWeekNumber);
        case "nn":
          return this.num(dt.localWeekNumber, 2);
        case "ii":
          return this.num(dt.localWeekYear.toString().slice(-2), 2);
        case "iiii":
          return this.num(dt.localWeekYear, 4);
        case "o":
          return this.num(dt.ordinal);
        case "ooo":
          return this.num(dt.ordinal, 3);
        case "q":
          return this.num(dt.quarter);
        case "qq":
          return this.num(dt.quarter, 2);
        case "X":
          return this.num(Math.floor(dt.ts / 1e3));
        case "x":
          return this.num(dt.ts);
        default:
          return maybeMacro(token);
      }
    };
    return stringifyTokens(Formatter.parseFormat(fmt), tokenToString);
  }
  formatDurationFromString(dur, fmt) {
    const tokenToField = (token) => {
      switch (token[0]) {
        case "S":
          return "millisecond";
        case "s":
          return "second";
        case "m":
          return "minute";
        case "h":
          return "hour";
        case "d":
          return "day";
        case "w":
          return "week";
        case "M":
          return "month";
        case "y":
          return "year";
        default:
          return null;
      }
    }, tokenToString = (lildur) => (token) => {
      const mapped = tokenToField(token);
      if (mapped) {
        return this.num(lildur.get(mapped), token.length);
      } else {
        return token;
      }
    }, tokens = Formatter.parseFormat(fmt), realTokens = tokens.reduce(
      (found, { literal, val }) => literal ? found : found.concat(val),
      []
    ), collapsed = dur.shiftTo(...realTokens.map(tokenToField).filter((t) => t));
    return stringifyTokens(tokens, tokenToString(collapsed));
  }
}
const ianaRegex = /[A-Za-z_+-]{1,256}(?::?\/[A-Za-z0-9_+-]{1,256}(?:\/[A-Za-z0-9_+-]{1,256})?)?/;
function combineRegexes(...regexes) {
  const full = regexes.reduce((f, r) => f + r.source, "");
  return RegExp(`^${full}$`);
}
function combineExtractors(...extractors) {
  return (m) => extractors.reduce(
    ([mergedVals, mergedZone, cursor], ex) => {
      const [val, zone, next] = ex(m, cursor);
      return [{ ...mergedVals, ...val }, zone || mergedZone, next];
    },
    [{}, null, 1]
  ).slice(0, 2);
}
function parse(s2, ...patterns) {
  if (s2 == null) {
    return [null, null];
  }
  for (const [regex, extractor] of patterns) {
    const m = regex.exec(s2);
    if (m) {
      return extractor(m);
    }
  }
  return [null, null];
}
function simpleParse(...keys) {
  return (match2, cursor) => {
    const ret = {};
    let i;
    for (i = 0; i < keys.length; i++) {
      ret[keys[i]] = parseInteger(match2[cursor + i]);
    }
    return [ret, null, cursor + i];
  };
}
const offsetRegex = /(?:(Z)|([+-]\d\d)(?::?(\d\d))?)/;
const isoExtendedZone = `(?:${offsetRegex.source}?(?:\\[(${ianaRegex.source})\\])?)?`;
const isoTimeBaseRegex = /(\d\d)(?::?(\d\d)(?::?(\d\d)(?:[.,](\d{1,30}))?)?)?/;
const isoTimeRegex = RegExp(`${isoTimeBaseRegex.source}${isoExtendedZone}`);
const isoTimeExtensionRegex = RegExp(`(?:T${isoTimeRegex.source})?`);
const isoYmdRegex = /([+-]\d{6}|\d{4})(?:-?(\d\d)(?:-?(\d\d))?)?/;
const isoWeekRegex = /(\d{4})-?W(\d\d)(?:-?(\d))?/;
const isoOrdinalRegex = /(\d{4})-?(\d{3})/;
const extractISOWeekData = simpleParse("weekYear", "weekNumber", "weekDay");
const extractISOOrdinalData = simpleParse("year", "ordinal");
const sqlYmdRegex = /(\d{4})-(\d\d)-(\d\d)/;
const sqlTimeRegex = RegExp(
  `${isoTimeBaseRegex.source} ?(?:${offsetRegex.source}|(${ianaRegex.source}))?`
);
const sqlTimeExtensionRegex = RegExp(`(?: ${sqlTimeRegex.source})?`);
function int(match2, pos, fallback) {
  const m = match2[pos];
  return isUndefined(m) ? fallback : parseInteger(m);
}
function extractISOYmd(match2, cursor) {
  const item = {
    year: int(match2, cursor),
    month: int(match2, cursor + 1, 1),
    day: int(match2, cursor + 2, 1)
  };
  return [item, null, cursor + 3];
}
function extractISOTime(match2, cursor) {
  const item = {
    hours: int(match2, cursor, 0),
    minutes: int(match2, cursor + 1, 0),
    seconds: int(match2, cursor + 2, 0),
    milliseconds: parseMillis(match2[cursor + 3])
  };
  return [item, null, cursor + 4];
}
function extractISOOffset(match2, cursor) {
  const local = !match2[cursor] && !match2[cursor + 1], fullOffset = signedOffset(match2[cursor + 1], match2[cursor + 2]), zone = local ? null : FixedOffsetZone.instance(fullOffset);
  return [{}, zone, cursor + 3];
}
function extractIANAZone(match2, cursor) {
  const zone = match2[cursor] ? IANAZone.create(match2[cursor]) : null;
  return [{}, zone, cursor + 1];
}
const isoTimeOnly = RegExp(`^T?${isoTimeBaseRegex.source}$`);
const isoDuration = /^-?P(?:(?:(-?\d{1,20}(?:\.\d{1,20})?)Y)?(?:(-?\d{1,20}(?:\.\d{1,20})?)M)?(?:(-?\d{1,20}(?:\.\d{1,20})?)W)?(?:(-?\d{1,20}(?:\.\d{1,20})?)D)?(?:T(?:(-?\d{1,20}(?:\.\d{1,20})?)H)?(?:(-?\d{1,20}(?:\.\d{1,20})?)M)?(?:(-?\d{1,20})(?:[.,](-?\d{1,20}))?S)?)?)$/;
function extractISODuration(match2) {
  const [s2, yearStr, monthStr, weekStr, dayStr, hourStr, minuteStr, secondStr, millisecondsStr] = match2;
  const hasNegativePrefix = s2[0] === "-";
  const negativeSeconds = secondStr && secondStr[0] === "-";
  const maybeNegate = (num, force = false) => num !== void 0 && (force || num && hasNegativePrefix) ? -num : num;
  return [
    {
      years: maybeNegate(parseFloating(yearStr)),
      months: maybeNegate(parseFloating(monthStr)),
      weeks: maybeNegate(parseFloating(weekStr)),
      days: maybeNegate(parseFloating(dayStr)),
      hours: maybeNegate(parseFloating(hourStr)),
      minutes: maybeNegate(parseFloating(minuteStr)),
      seconds: maybeNegate(parseFloating(secondStr), secondStr === "-0"),
      milliseconds: maybeNegate(parseMillis(millisecondsStr), negativeSeconds)
    }
  ];
}
const obsOffsets = {
  GMT: 0,
  EDT: -4 * 60,
  EST: -5 * 60,
  CDT: -5 * 60,
  CST: -6 * 60,
  MDT: -6 * 60,
  MST: -7 * 60,
  PDT: -7 * 60,
  PST: -8 * 60
};
function fromStrings(weekdayStr, yearStr, monthStr, dayStr, hourStr, minuteStr, secondStr) {
  const result = {
    year: yearStr.length === 2 ? untruncateYear(parseInteger(yearStr)) : parseInteger(yearStr),
    month: monthsShort.indexOf(monthStr) + 1,
    day: parseInteger(dayStr),
    hour: parseInteger(hourStr),
    minute: parseInteger(minuteStr)
  };
  if (secondStr) result.second = parseInteger(secondStr);
  if (weekdayStr) {
    result.weekday = weekdayStr.length > 3 ? weekdaysLong.indexOf(weekdayStr) + 1 : weekdaysShort.indexOf(weekdayStr) + 1;
  }
  return result;
}
const rfc2822 = /^(?:(Mon|Tue|Wed|Thu|Fri|Sat|Sun),\s)?(\d{1,2})\s(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)\s(\d{2,4})\s(\d\d):(\d\d)(?::(\d\d))?\s(?:(UT|GMT|[ECMP][SD]T)|([Zz])|(?:([+-]\d\d)(\d\d)))$/;
function extractRFC2822(match2) {
  const [
    ,
    weekdayStr,
    dayStr,
    monthStr,
    yearStr,
    hourStr,
    minuteStr,
    secondStr,
    obsOffset,
    milOffset,
    offHourStr,
    offMinuteStr
  ] = match2, result = fromStrings(weekdayStr, yearStr, monthStr, dayStr, hourStr, minuteStr, secondStr);
  let offset2;
  if (obsOffset) {
    offset2 = obsOffsets[obsOffset];
  } else if (milOffset) {
    offset2 = 0;
  } else {
    offset2 = signedOffset(offHourStr, offMinuteStr);
  }
  return [result, new FixedOffsetZone(offset2)];
}
function preprocessRFC2822(s2) {
  return s2.replace(/\([^()]*\)|[\n\t]/g, " ").replace(/(\s\s+)/g, " ").trim();
}
const rfc1123 = /^(Mon|Tue|Wed|Thu|Fri|Sat|Sun), (\d\d) (Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec) (\d{4}) (\d\d):(\d\d):(\d\d) GMT$/, rfc850 = /^(Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sunday), (\d\d)-(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)-(\d\d) (\d\d):(\d\d):(\d\d) GMT$/, ascii = /^(Mon|Tue|Wed|Thu|Fri|Sat|Sun) (Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec) ( \d|\d\d) (\d\d):(\d\d):(\d\d) (\d{4})$/;
function extractRFC1123Or850(match2) {
  const [, weekdayStr, dayStr, monthStr, yearStr, hourStr, minuteStr, secondStr] = match2, result = fromStrings(weekdayStr, yearStr, monthStr, dayStr, hourStr, minuteStr, secondStr);
  return [result, FixedOffsetZone.utcInstance];
}
function extractASCII(match2) {
  const [, weekdayStr, monthStr, dayStr, hourStr, minuteStr, secondStr, yearStr] = match2, result = fromStrings(weekdayStr, yearStr, monthStr, dayStr, hourStr, minuteStr, secondStr);
  return [result, FixedOffsetZone.utcInstance];
}
const isoYmdWithTimeExtensionRegex = combineRegexes(isoYmdRegex, isoTimeExtensionRegex);
const isoWeekWithTimeExtensionRegex = combineRegexes(isoWeekRegex, isoTimeExtensionRegex);
const isoOrdinalWithTimeExtensionRegex = combineRegexes(isoOrdinalRegex, isoTimeExtensionRegex);
const isoTimeCombinedRegex = combineRegexes(isoTimeRegex);
const extractISOYmdTimeAndOffset = combineExtractors(
  extractISOYmd,
  extractISOTime,
  extractISOOffset,
  extractIANAZone
);
const extractISOWeekTimeAndOffset = combineExtractors(
  extractISOWeekData,
  extractISOTime,
  extractISOOffset,
  extractIANAZone
);
const extractISOOrdinalDateAndTime = combineExtractors(
  extractISOOrdinalData,
  extractISOTime,
  extractISOOffset,
  extractIANAZone
);
const extractISOTimeAndOffset = combineExtractors(
  extractISOTime,
  extractISOOffset,
  extractIANAZone
);
function parseISODate(s2) {
  return parse(
    s2,
    [isoYmdWithTimeExtensionRegex, extractISOYmdTimeAndOffset],
    [isoWeekWithTimeExtensionRegex, extractISOWeekTimeAndOffset],
    [isoOrdinalWithTimeExtensionRegex, extractISOOrdinalDateAndTime],
    [isoTimeCombinedRegex, extractISOTimeAndOffset]
  );
}
function parseRFC2822Date(s2) {
  return parse(preprocessRFC2822(s2), [rfc2822, extractRFC2822]);
}
function parseHTTPDate(s2) {
  return parse(
    s2,
    [rfc1123, extractRFC1123Or850],
    [rfc850, extractRFC1123Or850],
    [ascii, extractASCII]
  );
}
function parseISODuration(s2) {
  return parse(s2, [isoDuration, extractISODuration]);
}
const extractISOTimeOnly = combineExtractors(extractISOTime);
function parseISOTimeOnly(s2) {
  return parse(s2, [isoTimeOnly, extractISOTimeOnly]);
}
const sqlYmdWithTimeExtensionRegex = combineRegexes(sqlYmdRegex, sqlTimeExtensionRegex);
const sqlTimeCombinedRegex = combineRegexes(sqlTimeRegex);
const extractISOTimeOffsetAndIANAZone = combineExtractors(
  extractISOTime,
  extractISOOffset,
  extractIANAZone
);
function parseSQL(s2) {
  return parse(
    s2,
    [sqlYmdWithTimeExtensionRegex, extractISOYmdTimeAndOffset],
    [sqlTimeCombinedRegex, extractISOTimeOffsetAndIANAZone]
  );
}
const INVALID$2 = "Invalid Duration";
const lowOrderMatrix = {
  weeks: {
    days: 7,
    hours: 7 * 24,
    minutes: 7 * 24 * 60,
    seconds: 7 * 24 * 60 * 60,
    milliseconds: 7 * 24 * 60 * 60 * 1e3
  },
  days: {
    hours: 24,
    minutes: 24 * 60,
    seconds: 24 * 60 * 60,
    milliseconds: 24 * 60 * 60 * 1e3
  },
  hours: { minutes: 60, seconds: 60 * 60, milliseconds: 60 * 60 * 1e3 },
  minutes: { seconds: 60, milliseconds: 60 * 1e3 },
  seconds: { milliseconds: 1e3 }
}, casualMatrix = {
  years: {
    quarters: 4,
    months: 12,
    weeks: 52,
    days: 365,
    hours: 365 * 24,
    minutes: 365 * 24 * 60,
    seconds: 365 * 24 * 60 * 60,
    milliseconds: 365 * 24 * 60 * 60 * 1e3
  },
  quarters: {
    months: 3,
    weeks: 13,
    days: 91,
    hours: 91 * 24,
    minutes: 91 * 24 * 60,
    seconds: 91 * 24 * 60 * 60,
    milliseconds: 91 * 24 * 60 * 60 * 1e3
  },
  months: {
    weeks: 4,
    days: 30,
    hours: 30 * 24,
    minutes: 30 * 24 * 60,
    seconds: 30 * 24 * 60 * 60,
    milliseconds: 30 * 24 * 60 * 60 * 1e3
  },
  ...lowOrderMatrix
}, daysInYearAccurate = 146097 / 400, daysInMonthAccurate = 146097 / 4800, accurateMatrix = {
  years: {
    quarters: 4,
    months: 12,
    weeks: daysInYearAccurate / 7,
    days: daysInYearAccurate,
    hours: daysInYearAccurate * 24,
    minutes: daysInYearAccurate * 24 * 60,
    seconds: daysInYearAccurate * 24 * 60 * 60,
    milliseconds: daysInYearAccurate * 24 * 60 * 60 * 1e3
  },
  quarters: {
    months: 3,
    weeks: daysInYearAccurate / 28,
    days: daysInYearAccurate / 4,
    hours: daysInYearAccurate * 24 / 4,
    minutes: daysInYearAccurate * 24 * 60 / 4,
    seconds: daysInYearAccurate * 24 * 60 * 60 / 4,
    milliseconds: daysInYearAccurate * 24 * 60 * 60 * 1e3 / 4
  },
  months: {
    weeks: daysInMonthAccurate / 7,
    days: daysInMonthAccurate,
    hours: daysInMonthAccurate * 24,
    minutes: daysInMonthAccurate * 24 * 60,
    seconds: daysInMonthAccurate * 24 * 60 * 60,
    milliseconds: daysInMonthAccurate * 24 * 60 * 60 * 1e3
  },
  ...lowOrderMatrix
};
const orderedUnits$1 = [
  "years",
  "quarters",
  "months",
  "weeks",
  "days",
  "hours",
  "minutes",
  "seconds",
  "milliseconds"
];
const reverseUnits = orderedUnits$1.slice(0).reverse();
function clone$1(dur, alts, clear = false) {
  const conf = {
    values: clear ? alts.values : { ...dur.values, ...alts.values || {} },
    loc: dur.loc.clone(alts.loc),
    conversionAccuracy: alts.conversionAccuracy || dur.conversionAccuracy,
    matrix: alts.matrix || dur.matrix
  };
  return new Duration(conf);
}
function durationToMillis(matrix, vals) {
  let sum = vals.milliseconds ?? 0;
  for (const unit of reverseUnits.slice(1)) {
    if (vals[unit]) {
      sum += vals[unit] * matrix[unit]["milliseconds"];
    }
  }
  return sum;
}
function normalizeValues(matrix, vals) {
  const factor = durationToMillis(matrix, vals) < 0 ? -1 : 1;
  orderedUnits$1.reduceRight((previous, current) => {
    if (!isUndefined(vals[current])) {
      if (previous) {
        const previousVal = vals[previous] * factor;
        const conv = matrix[current][previous];
        const rollUp = Math.floor(previousVal / conv);
        vals[current] += rollUp * factor;
        vals[previous] -= rollUp * conv * factor;
      }
      return current;
    } else {
      return previous;
    }
  }, null);
  orderedUnits$1.reduce((previous, current) => {
    if (!isUndefined(vals[current])) {
      if (previous) {
        const fraction = vals[previous] % 1;
        vals[previous] -= fraction;
        vals[current] += fraction * matrix[previous][current];
      }
      return current;
    } else {
      return previous;
    }
  }, null);
}
function removeZeroes(vals) {
  const newVals = {};
  for (const [key, value] of Object.entries(vals)) {
    if (value !== 0) {
      newVals[key] = value;
    }
  }
  return newVals;
}
class Duration {
  /**
   * @private
   */
  constructor(config) {
    const accurate = config.conversionAccuracy === "longterm" || false;
    let matrix = accurate ? accurateMatrix : casualMatrix;
    if (config.matrix) {
      matrix = config.matrix;
    }
    this.values = config.values;
    this.loc = config.loc || Locale.create();
    this.conversionAccuracy = accurate ? "longterm" : "casual";
    this.invalid = config.invalid || null;
    this.matrix = matrix;
    this.isLuxonDuration = true;
  }
  /**
   * Create Duration from a number of milliseconds.
   * @param {number} count of milliseconds
   * @param {Object} opts - options for parsing
   * @param {string} [opts.locale='en-US'] - the locale to use
   * @param {string} opts.numberingSystem - the numbering system to use
   * @param {string} [opts.conversionAccuracy='casual'] - the conversion system to use
   * @return {Duration}
   */
  static fromMillis(count, opts) {
    return Duration.fromObject({ milliseconds: count }, opts);
  }
  /**
   * Create a Duration from a JavaScript object with keys like 'years' and 'hours'.
   * If this object is empty then a zero milliseconds duration is returned.
   * @param {Object} obj - the object to create the DateTime from
   * @param {number} obj.years
   * @param {number} obj.quarters
   * @param {number} obj.months
   * @param {number} obj.weeks
   * @param {number} obj.days
   * @param {number} obj.hours
   * @param {number} obj.minutes
   * @param {number} obj.seconds
   * @param {number} obj.milliseconds
   * @param {Object} [opts=[]] - options for creating this Duration
   * @param {string} [opts.locale='en-US'] - the locale to use
   * @param {string} opts.numberingSystem - the numbering system to use
   * @param {string} [opts.conversionAccuracy='casual'] - the preset conversion system to use
   * @param {string} [opts.matrix=Object] - the custom conversion system to use
   * @return {Duration}
   */
  static fromObject(obj, opts = {}) {
    if (obj == null || typeof obj !== "object") {
      throw new InvalidArgumentError(
        `Duration.fromObject: argument expected to be an object, got ${obj === null ? "null" : typeof obj}`
      );
    }
    return new Duration({
      values: normalizeObject(obj, Duration.normalizeUnit),
      loc: Locale.fromObject(opts),
      conversionAccuracy: opts.conversionAccuracy,
      matrix: opts.matrix
    });
  }
  /**
   * Create a Duration from DurationLike.
   *
   * @param {Object | number | Duration} durationLike
   * One of:
   * - object with keys like 'years' and 'hours'.
   * - number representing milliseconds
   * - Duration instance
   * @return {Duration}
   */
  static fromDurationLike(durationLike) {
    if (isNumber(durationLike)) {
      return Duration.fromMillis(durationLike);
    } else if (Duration.isDuration(durationLike)) {
      return durationLike;
    } else if (typeof durationLike === "object") {
      return Duration.fromObject(durationLike);
    } else {
      throw new InvalidArgumentError(
        `Unknown duration argument ${durationLike} of type ${typeof durationLike}`
      );
    }
  }
  /**
   * Create a Duration from an ISO 8601 duration string.
   * @param {string} text - text to parse
   * @param {Object} opts - options for parsing
   * @param {string} [opts.locale='en-US'] - the locale to use
   * @param {string} opts.numberingSystem - the numbering system to use
   * @param {string} [opts.conversionAccuracy='casual'] - the preset conversion system to use
   * @param {string} [opts.matrix=Object] - the preset conversion system to use
   * @see https://en.wikipedia.org/wiki/ISO_8601#Durations
   * @example Duration.fromISO('P3Y6M1W4DT12H30M5S').toObject() //=> { years: 3, months: 6, weeks: 1, days: 4, hours: 12, minutes: 30, seconds: 5 }
   * @example Duration.fromISO('PT23H').toObject() //=> { hours: 23 }
   * @example Duration.fromISO('P5Y3M').toObject() //=> { years: 5, months: 3 }
   * @return {Duration}
   */
  static fromISO(text, opts) {
    const [parsed] = parseISODuration(text);
    if (parsed) {
      return Duration.fromObject(parsed, opts);
    } else {
      return Duration.invalid("unparsable", `the input "${text}" can't be parsed as ISO 8601`);
    }
  }
  /**
   * Create a Duration from an ISO 8601 time string.
   * @param {string} text - text to parse
   * @param {Object} opts - options for parsing
   * @param {string} [opts.locale='en-US'] - the locale to use
   * @param {string} opts.numberingSystem - the numbering system to use
   * @param {string} [opts.conversionAccuracy='casual'] - the preset conversion system to use
   * @param {string} [opts.matrix=Object] - the conversion system to use
   * @see https://en.wikipedia.org/wiki/ISO_8601#Times
   * @example Duration.fromISOTime('11:22:33.444').toObject() //=> { hours: 11, minutes: 22, seconds: 33, milliseconds: 444 }
   * @example Duration.fromISOTime('11:00').toObject() //=> { hours: 11, minutes: 0, seconds: 0 }
   * @example Duration.fromISOTime('T11:00').toObject() //=> { hours: 11, minutes: 0, seconds: 0 }
   * @example Duration.fromISOTime('1100').toObject() //=> { hours: 11, minutes: 0, seconds: 0 }
   * @example Duration.fromISOTime('T1100').toObject() //=> { hours: 11, minutes: 0, seconds: 0 }
   * @return {Duration}
   */
  static fromISOTime(text, opts) {
    const [parsed] = parseISOTimeOnly(text);
    if (parsed) {
      return Duration.fromObject(parsed, opts);
    } else {
      return Duration.invalid("unparsable", `the input "${text}" can't be parsed as ISO 8601`);
    }
  }
  /**
   * Create an invalid Duration.
   * @param {string} reason - simple string of why this datetime is invalid. Should not contain parameters or anything else data-dependent
   * @param {string} [explanation=null] - longer explanation, may include parameters and other useful debugging information
   * @return {Duration}
   */
  static invalid(reason, explanation = null) {
    if (!reason) {
      throw new InvalidArgumentError("need to specify a reason the Duration is invalid");
    }
    const invalid = reason instanceof Invalid ? reason : new Invalid(reason, explanation);
    if (Settings.throwOnInvalid) {
      throw new InvalidDurationError(invalid);
    } else {
      return new Duration({ invalid });
    }
  }
  /**
   * @private
   */
  static normalizeUnit(unit) {
    const normalized = {
      year: "years",
      years: "years",
      quarter: "quarters",
      quarters: "quarters",
      month: "months",
      months: "months",
      week: "weeks",
      weeks: "weeks",
      day: "days",
      days: "days",
      hour: "hours",
      hours: "hours",
      minute: "minutes",
      minutes: "minutes",
      second: "seconds",
      seconds: "seconds",
      millisecond: "milliseconds",
      milliseconds: "milliseconds"
    }[unit ? unit.toLowerCase() : unit];
    if (!normalized) throw new InvalidUnitError(unit);
    return normalized;
  }
  /**
   * Check if an object is a Duration. Works across context boundaries
   * @param {object} o
   * @return {boolean}
   */
  static isDuration(o) {
    return o && o.isLuxonDuration || false;
  }
  /**
   * Get  the locale of a Duration, such 'en-GB'
   * @type {string}
   */
  get locale() {
    return this.isValid ? this.loc.locale : null;
  }
  /**
   * Get the numbering system of a Duration, such 'beng'. The numbering system is used when formatting the Duration
   *
   * @type {string}
   */
  get numberingSystem() {
    return this.isValid ? this.loc.numberingSystem : null;
  }
  /**
   * Returns a string representation of this Duration formatted according to the specified format string. You may use these tokens:
   * * `S` for milliseconds
   * * `s` for seconds
   * * `m` for minutes
   * * `h` for hours
   * * `d` for days
   * * `w` for weeks
   * * `M` for months
   * * `y` for years
   * Notes:
   * * Add padding by repeating the token, e.g. "yy" pads the years to two digits, "hhhh" pads the hours out to four digits
   * * Tokens can be escaped by wrapping with single quotes.
   * * The duration will be converted to the set of units in the format string using {@link Duration#shiftTo} and the Durations's conversion accuracy setting.
   * @param {string} fmt - the format string
   * @param {Object} opts - options
   * @param {boolean} [opts.floor=true] - floor numerical values
   * @example Duration.fromObject({ years: 1, days: 6, seconds: 2 }).toFormat("y d s") //=> "1 6 2"
   * @example Duration.fromObject({ years: 1, days: 6, seconds: 2 }).toFormat("yy dd sss") //=> "01 06 002"
   * @example Duration.fromObject({ years: 1, days: 6, seconds: 2 }).toFormat("M S") //=> "12 518402000"
   * @return {string}
   */
  toFormat(fmt, opts = {}) {
    const fmtOpts = {
      ...opts,
      floor: opts.round !== false && opts.floor !== false
    };
    return this.isValid ? Formatter.create(this.loc, fmtOpts).formatDurationFromString(this, fmt) : INVALID$2;
  }
  /**
   * Returns a string representation of a Duration with all units included.
   * To modify its behavior, use `listStyle` and any Intl.NumberFormat option, though `unitDisplay` is especially relevant.
   * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Intl/NumberFormat/NumberFormat#options
   * @param {Object} opts - Formatting options. Accepts the same keys as the options parameter of the native `Intl.NumberFormat` constructor, as well as `listStyle`.
   * @param {string} [opts.listStyle='narrow'] - How to format the merged list. Corresponds to the `style` property of the options parameter of the native `Intl.ListFormat` constructor.
   * @example
   * ```js
   * var dur = Duration.fromObject({ days: 1, hours: 5, minutes: 6 })
   * dur.toHuman() //=> '1 day, 5 hours, 6 minutes'
   * dur.toHuman({ listStyle: "long" }) //=> '1 day, 5 hours, and 6 minutes'
   * dur.toHuman({ unitDisplay: "short" }) //=> '1 day, 5 hr, 6 min'
   * ```
   */
  toHuman(opts = {}) {
    if (!this.isValid) return INVALID$2;
    const l2 = orderedUnits$1.map((unit) => {
      const val = this.values[unit];
      if (isUndefined(val)) {
        return null;
      }
      return this.loc.numberFormatter({ style: "unit", unitDisplay: "long", ...opts, unit: unit.slice(0, -1) }).format(val);
    }).filter((n2) => n2);
    return this.loc.listFormatter({ type: "conjunction", style: opts.listStyle || "narrow", ...opts }).format(l2);
  }
  /**
   * Returns a JavaScript object with this Duration's values.
   * @example Duration.fromObject({ years: 1, days: 6, seconds: 2 }).toObject() //=> { years: 1, days: 6, seconds: 2 }
   * @return {Object}
   */
  toObject() {
    if (!this.isValid) return {};
    return { ...this.values };
  }
  /**
   * Returns an ISO 8601-compliant string representation of this Duration.
   * @see https://en.wikipedia.org/wiki/ISO_8601#Durations
   * @example Duration.fromObject({ years: 3, seconds: 45 }).toISO() //=> 'P3YT45S'
   * @example Duration.fromObject({ months: 4, seconds: 45 }).toISO() //=> 'P4MT45S'
   * @example Duration.fromObject({ months: 5 }).toISO() //=> 'P5M'
   * @example Duration.fromObject({ minutes: 5 }).toISO() //=> 'PT5M'
   * @example Duration.fromObject({ milliseconds: 6 }).toISO() //=> 'PT0.006S'
   * @return {string}
   */
  toISO() {
    if (!this.isValid) return null;
    let s2 = "P";
    if (this.years !== 0) s2 += this.years + "Y";
    if (this.months !== 0 || this.quarters !== 0) s2 += this.months + this.quarters * 3 + "M";
    if (this.weeks !== 0) s2 += this.weeks + "W";
    if (this.days !== 0) s2 += this.days + "D";
    if (this.hours !== 0 || this.minutes !== 0 || this.seconds !== 0 || this.milliseconds !== 0)
      s2 += "T";
    if (this.hours !== 0) s2 += this.hours + "H";
    if (this.minutes !== 0) s2 += this.minutes + "M";
    if (this.seconds !== 0 || this.milliseconds !== 0)
      s2 += roundTo(this.seconds + this.milliseconds / 1e3, 3) + "S";
    if (s2 === "P") s2 += "T0S";
    return s2;
  }
  /**
   * Returns an ISO 8601-compliant string representation of this Duration, formatted as a time of day.
   * Note that this will return null if the duration is invalid, negative, or equal to or greater than 24 hours.
   * @see https://en.wikipedia.org/wiki/ISO_8601#Times
   * @param {Object} opts - options
   * @param {boolean} [opts.suppressMilliseconds=false] - exclude milliseconds from the format if they're 0
   * @param {boolean} [opts.suppressSeconds=false] - exclude seconds from the format if they're 0
   * @param {boolean} [opts.includePrefix=false] - include the `T` prefix
   * @param {string} [opts.format='extended'] - choose between the basic and extended format
   * @example Duration.fromObject({ hours: 11 }).toISOTime() //=> '11:00:00.000'
   * @example Duration.fromObject({ hours: 11 }).toISOTime({ suppressMilliseconds: true }) //=> '11:00:00'
   * @example Duration.fromObject({ hours: 11 }).toISOTime({ suppressSeconds: true }) //=> '11:00'
   * @example Duration.fromObject({ hours: 11 }).toISOTime({ includePrefix: true }) //=> 'T11:00:00.000'
   * @example Duration.fromObject({ hours: 11 }).toISOTime({ format: 'basic' }) //=> '110000.000'
   * @return {string}
   */
  toISOTime(opts = {}) {
    if (!this.isValid) return null;
    const millis = this.toMillis();
    if (millis < 0 || millis >= 864e5) return null;
    opts = {
      suppressMilliseconds: false,
      suppressSeconds: false,
      includePrefix: false,
      format: "extended",
      ...opts,
      includeOffset: false
    };
    const dateTime = DateTime.fromMillis(millis, { zone: "UTC" });
    return dateTime.toISOTime(opts);
  }
  /**
   * Returns an ISO 8601 representation of this Duration appropriate for use in JSON.
   * @return {string}
   */
  toJSON() {
    return this.toISO();
  }
  /**
   * Returns an ISO 8601 representation of this Duration appropriate for use in debugging.
   * @return {string}
   */
  toString() {
    return this.toISO();
  }
  /**
   * Returns a string representation of this Duration appropriate for the REPL.
   * @return {string}
   */
  [Symbol.for("nodejs.util.inspect.custom")]() {
    if (this.isValid) {
      return `Duration { values: ${JSON.stringify(this.values)} }`;
    } else {
      return `Duration { Invalid, reason: ${this.invalidReason} }`;
    }
  }
  /**
   * Returns an milliseconds value of this Duration.
   * @return {number}
   */
  toMillis() {
    if (!this.isValid) return NaN;
    return durationToMillis(this.matrix, this.values);
  }
  /**
   * Returns an milliseconds value of this Duration. Alias of {@link toMillis}
   * @return {number}
   */
  valueOf() {
    return this.toMillis();
  }
  /**
   * Make this Duration longer by the specified amount. Return a newly-constructed Duration.
   * @param {Duration|Object|number} duration - The amount to add. Either a Luxon Duration, a number of milliseconds, the object argument to Duration.fromObject()
   * @return {Duration}
   */
  plus(duration) {
    if (!this.isValid) return this;
    const dur = Duration.fromDurationLike(duration), result = {};
    for (const k of orderedUnits$1) {
      if (hasOwnProperty(dur.values, k) || hasOwnProperty(this.values, k)) {
        result[k] = dur.get(k) + this.get(k);
      }
    }
    return clone$1(this, { values: result }, true);
  }
  /**
   * Make this Duration shorter by the specified amount. Return a newly-constructed Duration.
   * @param {Duration|Object|number} duration - The amount to subtract. Either a Luxon Duration, a number of milliseconds, the object argument to Duration.fromObject()
   * @return {Duration}
   */
  minus(duration) {
    if (!this.isValid) return this;
    const dur = Duration.fromDurationLike(duration);
    return this.plus(dur.negate());
  }
  /**
   * Scale this Duration by the specified amount. Return a newly-constructed Duration.
   * @param {function} fn - The function to apply to each unit. Arity is 1 or 2: the value of the unit and, optionally, the unit name. Must return a number.
   * @example Duration.fromObject({ hours: 1, minutes: 30 }).mapUnits(x => x * 2) //=> { hours: 2, minutes: 60 }
   * @example Duration.fromObject({ hours: 1, minutes: 30 }).mapUnits((x, u) => u === "hours" ? x * 2 : x) //=> { hours: 2, minutes: 30 }
   * @return {Duration}
   */
  mapUnits(fn) {
    if (!this.isValid) return this;
    const result = {};
    for (const k of Object.keys(this.values)) {
      result[k] = asNumber(fn(this.values[k], k));
    }
    return clone$1(this, { values: result }, true);
  }
  /**
   * Get the value of unit.
   * @param {string} unit - a unit such as 'minute' or 'day'
   * @example Duration.fromObject({years: 2, days: 3}).get('years') //=> 2
   * @example Duration.fromObject({years: 2, days: 3}).get('months') //=> 0
   * @example Duration.fromObject({years: 2, days: 3}).get('days') //=> 3
   * @return {number}
   */
  get(unit) {
    return this[Duration.normalizeUnit(unit)];
  }
  /**
   * "Set" the values of specified units. Return a newly-constructed Duration.
   * @param {Object} values - a mapping of units to numbers
   * @example dur.set({ years: 2017 })
   * @example dur.set({ hours: 8, minutes: 30 })
   * @return {Duration}
   */
  set(values) {
    if (!this.isValid) return this;
    const mixed = { ...this.values, ...normalizeObject(values, Duration.normalizeUnit) };
    return clone$1(this, { values: mixed });
  }
  /**
   * "Set" the locale and/or numberingSystem.  Returns a newly-constructed Duration.
   * @example dur.reconfigure({ locale: 'en-GB' })
   * @return {Duration}
   */
  reconfigure({ locale, numberingSystem, conversionAccuracy, matrix } = {}) {
    const loc = this.loc.clone({ locale, numberingSystem });
    const opts = { loc, matrix, conversionAccuracy };
    return clone$1(this, opts);
  }
  /**
   * Return the length of the duration in the specified unit.
   * @param {string} unit - a unit such as 'minutes' or 'days'
   * @example Duration.fromObject({years: 1}).as('days') //=> 365
   * @example Duration.fromObject({years: 1}).as('months') //=> 12
   * @example Duration.fromObject({hours: 60}).as('days') //=> 2.5
   * @return {number}
   */
  as(unit) {
    return this.isValid ? this.shiftTo(unit).get(unit) : NaN;
  }
  /**
   * Reduce this Duration to its canonical representation in its current units.
   * Assuming the overall value of the Duration is positive, this means:
   * - excessive values for lower-order units are converted to higher-order units (if possible, see first and second example)
   * - negative lower-order units are converted to higher order units (there must be such a higher order unit, otherwise
   *   the overall value would be negative, see third example)
   * - fractional values for higher-order units are converted to lower-order units (if possible, see fourth example)
   *
   * If the overall value is negative, the result of this method is equivalent to `this.negate().normalize().negate()`.
   * @example Duration.fromObject({ years: 2, days: 5000 }).normalize().toObject() //=> { years: 15, days: 255 }
   * @example Duration.fromObject({ days: 5000 }).normalize().toObject() //=> { days: 5000 }
   * @example Duration.fromObject({ hours: 12, minutes: -45 }).normalize().toObject() //=> { hours: 11, minutes: 15 }
   * @example Duration.fromObject({ years: 2.5, days: 0, hours: 0 }).normalize().toObject() //=> { years: 2, days: 182, hours: 12 }
   * @return {Duration}
   */
  normalize() {
    if (!this.isValid) return this;
    const vals = this.toObject();
    normalizeValues(this.matrix, vals);
    return clone$1(this, { values: vals }, true);
  }
  /**
   * Rescale units to its largest representation
   * @example Duration.fromObject({ milliseconds: 90000 }).rescale().toObject() //=> { minutes: 1, seconds: 30 }
   * @return {Duration}
   */
  rescale() {
    if (!this.isValid) return this;
    const vals = removeZeroes(this.normalize().shiftToAll().toObject());
    return clone$1(this, { values: vals }, true);
  }
  /**
   * Convert this Duration into its representation in a different set of units.
   * @example Duration.fromObject({ hours: 1, seconds: 30 }).shiftTo('minutes', 'milliseconds').toObject() //=> { minutes: 60, milliseconds: 30000 }
   * @return {Duration}
   */
  shiftTo(...units) {
    if (!this.isValid) return this;
    if (units.length === 0) {
      return this;
    }
    units = units.map((u) => Duration.normalizeUnit(u));
    const built = {}, accumulated = {}, vals = this.toObject();
    let lastUnit;
    for (const k of orderedUnits$1) {
      if (units.indexOf(k) >= 0) {
        lastUnit = k;
        let own = 0;
        for (const ak in accumulated) {
          own += this.matrix[ak][k] * accumulated[ak];
          accumulated[ak] = 0;
        }
        if (isNumber(vals[k])) {
          own += vals[k];
        }
        const i = Math.trunc(own);
        built[k] = i;
        accumulated[k] = (own * 1e3 - i * 1e3) / 1e3;
      } else if (isNumber(vals[k])) {
        accumulated[k] = vals[k];
      }
    }
    for (const key in accumulated) {
      if (accumulated[key] !== 0) {
        built[lastUnit] += key === lastUnit ? accumulated[key] : accumulated[key] / this.matrix[lastUnit][key];
      }
    }
    normalizeValues(this.matrix, built);
    return clone$1(this, { values: built }, true);
  }
  /**
   * Shift this Duration to all available units.
   * Same as shiftTo("years", "months", "weeks", "days", "hours", "minutes", "seconds", "milliseconds")
   * @return {Duration}
   */
  shiftToAll() {
    if (!this.isValid) return this;
    return this.shiftTo(
      "years",
      "months",
      "weeks",
      "days",
      "hours",
      "minutes",
      "seconds",
      "milliseconds"
    );
  }
  /**
   * Return the negative of this Duration.
   * @example Duration.fromObject({ hours: 1, seconds: 30 }).negate().toObject() //=> { hours: -1, seconds: -30 }
   * @return {Duration}
   */
  negate() {
    if (!this.isValid) return this;
    const negated = {};
    for (const k of Object.keys(this.values)) {
      negated[k] = this.values[k] === 0 ? 0 : -this.values[k];
    }
    return clone$1(this, { values: negated }, true);
  }
  /**
   * Get the years.
   * @type {number}
   */
  get years() {
    return this.isValid ? this.values.years || 0 : NaN;
  }
  /**
   * Get the quarters.
   * @type {number}
   */
  get quarters() {
    return this.isValid ? this.values.quarters || 0 : NaN;
  }
  /**
   * Get the months.
   * @type {number}
   */
  get months() {
    return this.isValid ? this.values.months || 0 : NaN;
  }
  /**
   * Get the weeks
   * @type {number}
   */
  get weeks() {
    return this.isValid ? this.values.weeks || 0 : NaN;
  }
  /**
   * Get the days.
   * @type {number}
   */
  get days() {
    return this.isValid ? this.values.days || 0 : NaN;
  }
  /**
   * Get the hours.
   * @type {number}
   */
  get hours() {
    return this.isValid ? this.values.hours || 0 : NaN;
  }
  /**
   * Get the minutes.
   * @type {number}
   */
  get minutes() {
    return this.isValid ? this.values.minutes || 0 : NaN;
  }
  /**
   * Get the seconds.
   * @return {number}
   */
  get seconds() {
    return this.isValid ? this.values.seconds || 0 : NaN;
  }
  /**
   * Get the milliseconds.
   * @return {number}
   */
  get milliseconds() {
    return this.isValid ? this.values.milliseconds || 0 : NaN;
  }
  /**
   * Returns whether the Duration is invalid. Invalid durations are returned by diff operations
   * on invalid DateTimes or Intervals.
   * @return {boolean}
   */
  get isValid() {
    return this.invalid === null;
  }
  /**
   * Returns an error code if this Duration became invalid, or null if the Duration is valid
   * @return {string}
   */
  get invalidReason() {
    return this.invalid ? this.invalid.reason : null;
  }
  /**
   * Returns an explanation of why this Duration became invalid, or null if the Duration is valid
   * @type {string}
   */
  get invalidExplanation() {
    return this.invalid ? this.invalid.explanation : null;
  }
  /**
   * Equality check
   * Two Durations are equal iff they have the same units and the same values for each unit.
   * @param {Duration} other
   * @return {boolean}
   */
  equals(other) {
    if (!this.isValid || !other.isValid) {
      return false;
    }
    if (!this.loc.equals(other.loc)) {
      return false;
    }
    function eq(v1, v2) {
      if (v1 === void 0 || v1 === 0) return v2 === void 0 || v2 === 0;
      return v1 === v2;
    }
    for (const u of orderedUnits$1) {
      if (!eq(this.values[u], other.values[u])) {
        return false;
      }
    }
    return true;
  }
}
const INVALID$1 = "Invalid Interval";
function validateStartEnd(start, end) {
  if (!start || !start.isValid) {
    return Interval.invalid("missing or invalid start");
  } else if (!end || !end.isValid) {
    return Interval.invalid("missing or invalid end");
  } else if (end < start) {
    return Interval.invalid(
      "end before start",
      `The end of an interval must be after its start, but you had start=${start.toISO()} and end=${end.toISO()}`
    );
  } else {
    return null;
  }
}
class Interval {
  /**
   * @private
   */
  constructor(config) {
    this.s = config.start;
    this.e = config.end;
    this.invalid = config.invalid || null;
    this.isLuxonInterval = true;
  }
  /**
   * Create an invalid Interval.
   * @param {string} reason - simple string of why this Interval is invalid. Should not contain parameters or anything else data-dependent
   * @param {string} [explanation=null] - longer explanation, may include parameters and other useful debugging information
   * @return {Interval}
   */
  static invalid(reason, explanation = null) {
    if (!reason) {
      throw new InvalidArgumentError("need to specify a reason the Interval is invalid");
    }
    const invalid = reason instanceof Invalid ? reason : new Invalid(reason, explanation);
    if (Settings.throwOnInvalid) {
      throw new InvalidIntervalError(invalid);
    } else {
      return new Interval({ invalid });
    }
  }
  /**
   * Create an Interval from a start DateTime and an end DateTime. Inclusive of the start but not the end.
   * @param {DateTime|Date|Object} start
   * @param {DateTime|Date|Object} end
   * @return {Interval}
   */
  static fromDateTimes(start, end) {
    const builtStart = friendlyDateTime(start), builtEnd = friendlyDateTime(end);
    const validateError = validateStartEnd(builtStart, builtEnd);
    if (validateError == null) {
      return new Interval({
        start: builtStart,
        end: builtEnd
      });
    } else {
      return validateError;
    }
  }
  /**
   * Create an Interval from a start DateTime and a Duration to extend to.
   * @param {DateTime|Date|Object} start
   * @param {Duration|Object|number} duration - the length of the Interval.
   * @return {Interval}
   */
  static after(start, duration) {
    const dur = Duration.fromDurationLike(duration), dt = friendlyDateTime(start);
    return Interval.fromDateTimes(dt, dt.plus(dur));
  }
  /**
   * Create an Interval from an end DateTime and a Duration to extend backwards to.
   * @param {DateTime|Date|Object} end
   * @param {Duration|Object|number} duration - the length of the Interval.
   * @return {Interval}
   */
  static before(end, duration) {
    const dur = Duration.fromDurationLike(duration), dt = friendlyDateTime(end);
    return Interval.fromDateTimes(dt.minus(dur), dt);
  }
  /**
   * Create an Interval from an ISO 8601 string.
   * Accepts `<start>/<end>`, `<start>/<duration>`, and `<duration>/<end>` formats.
   * @param {string} text - the ISO string to parse
   * @param {Object} [opts] - options to pass {@link DateTime#fromISO} and optionally {@link Duration#fromISO}
   * @see https://en.wikipedia.org/wiki/ISO_8601#Time_intervals
   * @return {Interval}
   */
  static fromISO(text, opts) {
    const [s2, e] = (text || "").split("/", 2);
    if (s2 && e) {
      let start, startIsValid;
      try {
        start = DateTime.fromISO(s2, opts);
        startIsValid = start.isValid;
      } catch (e2) {
        startIsValid = false;
      }
      let end, endIsValid;
      try {
        end = DateTime.fromISO(e, opts);
        endIsValid = end.isValid;
      } catch (e2) {
        endIsValid = false;
      }
      if (startIsValid && endIsValid) {
        return Interval.fromDateTimes(start, end);
      }
      if (startIsValid) {
        const dur = Duration.fromISO(e, opts);
        if (dur.isValid) {
          return Interval.after(start, dur);
        }
      } else if (endIsValid) {
        const dur = Duration.fromISO(s2, opts);
        if (dur.isValid) {
          return Interval.before(end, dur);
        }
      }
    }
    return Interval.invalid("unparsable", `the input "${text}" can't be parsed as ISO 8601`);
  }
  /**
   * Check if an object is an Interval. Works across context boundaries
   * @param {object} o
   * @return {boolean}
   */
  static isInterval(o) {
    return o && o.isLuxonInterval || false;
  }
  /**
   * Returns the start of the Interval
   * @type {DateTime}
   */
  get start() {
    return this.isValid ? this.s : null;
  }
  /**
   * Returns the end of the Interval
   * @type {DateTime}
   */
  get end() {
    return this.isValid ? this.e : null;
  }
  /**
   * Returns whether this Interval's end is at least its start, meaning that the Interval isn't 'backwards'.
   * @type {boolean}
   */
  get isValid() {
    return this.invalidReason === null;
  }
  /**
   * Returns an error code if this Interval is invalid, or null if the Interval is valid
   * @type {string}
   */
  get invalidReason() {
    return this.invalid ? this.invalid.reason : null;
  }
  /**
   * Returns an explanation of why this Interval became invalid, or null if the Interval is valid
   * @type {string}
   */
  get invalidExplanation() {
    return this.invalid ? this.invalid.explanation : null;
  }
  /**
   * Returns the length of the Interval in the specified unit.
   * @param {string} unit - the unit (such as 'hours' or 'days') to return the length in.
   * @return {number}
   */
  length(unit = "milliseconds") {
    return this.isValid ? this.toDuration(...[unit]).get(unit) : NaN;
  }
  /**
   * Returns the count of minutes, hours, days, months, or years included in the Interval, even in part.
   * Unlike {@link Interval#length} this counts sections of the calendar, not periods of time, e.g. specifying 'day'
   * asks 'what dates are included in this interval?', not 'how many days long is this interval?'
   * @param {string} [unit='milliseconds'] - the unit of time to count.
   * @param {Object} opts - options
   * @param {boolean} [opts.useLocaleWeeks=false] - If true, use weeks based on the locale, i.e. use the locale-dependent start of the week; this operation will always use the locale of the start DateTime
   * @return {number}
   */
  count(unit = "milliseconds", opts) {
    if (!this.isValid) return NaN;
    const start = this.start.startOf(unit, opts);
    let end;
    if (opts == null ? void 0 : opts.useLocaleWeeks) {
      end = this.end.reconfigure({ locale: start.locale });
    } else {
      end = this.end;
    }
    end = end.startOf(unit, opts);
    return Math.floor(end.diff(start, unit).get(unit)) + (end.valueOf() !== this.end.valueOf());
  }
  /**
   * Returns whether this Interval's start and end are both in the same unit of time
   * @param {string} unit - the unit of time to check sameness on
   * @return {boolean}
   */
  hasSame(unit) {
    return this.isValid ? this.isEmpty() || this.e.minus(1).hasSame(this.s, unit) : false;
  }
  /**
   * Return whether this Interval has the same start and end DateTimes.
   * @return {boolean}
   */
  isEmpty() {
    return this.s.valueOf() === this.e.valueOf();
  }
  /**
   * Return whether this Interval's start is after the specified DateTime.
   * @param {DateTime} dateTime
   * @return {boolean}
   */
  isAfter(dateTime) {
    if (!this.isValid) return false;
    return this.s > dateTime;
  }
  /**
   * Return whether this Interval's end is before the specified DateTime.
   * @param {DateTime} dateTime
   * @return {boolean}
   */
  isBefore(dateTime) {
    if (!this.isValid) return false;
    return this.e <= dateTime;
  }
  /**
   * Return whether this Interval contains the specified DateTime.
   * @param {DateTime} dateTime
   * @return {boolean}
   */
  contains(dateTime) {
    if (!this.isValid) return false;
    return this.s <= dateTime && this.e > dateTime;
  }
  /**
   * "Sets" the start and/or end dates. Returns a newly-constructed Interval.
   * @param {Object} values - the values to set
   * @param {DateTime} values.start - the starting DateTime
   * @param {DateTime} values.end - the ending DateTime
   * @return {Interval}
   */
  set({ start, end } = {}) {
    if (!this.isValid) return this;
    return Interval.fromDateTimes(start || this.s, end || this.e);
  }
  /**
   * Split this Interval at each of the specified DateTimes
   * @param {...DateTime} dateTimes - the unit of time to count.
   * @return {Array}
   */
  splitAt(...dateTimes) {
    if (!this.isValid) return [];
    const sorted = dateTimes.map(friendlyDateTime).filter((d) => this.contains(d)).sort((a, b) => a.toMillis() - b.toMillis()), results = [];
    let { s: s2 } = this, i = 0;
    while (s2 < this.e) {
      const added = sorted[i] || this.e, next = +added > +this.e ? this.e : added;
      results.push(Interval.fromDateTimes(s2, next));
      s2 = next;
      i += 1;
    }
    return results;
  }
  /**
   * Split this Interval into smaller Intervals, each of the specified length.
   * Left over time is grouped into a smaller interval
   * @param {Duration|Object|number} duration - The length of each resulting interval.
   * @return {Array}
   */
  splitBy(duration) {
    const dur = Duration.fromDurationLike(duration);
    if (!this.isValid || !dur.isValid || dur.as("milliseconds") === 0) {
      return [];
    }
    let { s: s2 } = this, idx = 1, next;
    const results = [];
    while (s2 < this.e) {
      const added = this.start.plus(dur.mapUnits((x) => x * idx));
      next = +added > +this.e ? this.e : added;
      results.push(Interval.fromDateTimes(s2, next));
      s2 = next;
      idx += 1;
    }
    return results;
  }
  /**
   * Split this Interval into the specified number of smaller intervals.
   * @param {number} numberOfParts - The number of Intervals to divide the Interval into.
   * @return {Array}
   */
  divideEqually(numberOfParts) {
    if (!this.isValid) return [];
    return this.splitBy(this.length() / numberOfParts).slice(0, numberOfParts);
  }
  /**
   * Return whether this Interval overlaps with the specified Interval
   * @param {Interval} other
   * @return {boolean}
   */
  overlaps(other) {
    return this.e > other.s && this.s < other.e;
  }
  /**
   * Return whether this Interval's end is adjacent to the specified Interval's start.
   * @param {Interval} other
   * @return {boolean}
   */
  abutsStart(other) {
    if (!this.isValid) return false;
    return +this.e === +other.s;
  }
  /**
   * Return whether this Interval's start is adjacent to the specified Interval's end.
   * @param {Interval} other
   * @return {boolean}
   */
  abutsEnd(other) {
    if (!this.isValid) return false;
    return +other.e === +this.s;
  }
  /**
   * Returns true if this Interval fully contains the specified Interval, specifically if the intersect (of this Interval and the other Interval) is equal to the other Interval; false otherwise.
   * @param {Interval} other
   * @return {boolean}
   */
  engulfs(other) {
    if (!this.isValid) return false;
    return this.s <= other.s && this.e >= other.e;
  }
  /**
   * Return whether this Interval has the same start and end as the specified Interval.
   * @param {Interval} other
   * @return {boolean}
   */
  equals(other) {
    if (!this.isValid || !other.isValid) {
      return false;
    }
    return this.s.equals(other.s) && this.e.equals(other.e);
  }
  /**
   * Return an Interval representing the intersection of this Interval and the specified Interval.
   * Specifically, the resulting Interval has the maximum start time and the minimum end time of the two Intervals.
   * Returns null if the intersection is empty, meaning, the intervals don't intersect.
   * @param {Interval} other
   * @return {Interval}
   */
  intersection(other) {
    if (!this.isValid) return this;
    const s2 = this.s > other.s ? this.s : other.s, e = this.e < other.e ? this.e : other.e;
    if (s2 >= e) {
      return null;
    } else {
      return Interval.fromDateTimes(s2, e);
    }
  }
  /**
   * Return an Interval representing the union of this Interval and the specified Interval.
   * Specifically, the resulting Interval has the minimum start time and the maximum end time of the two Intervals.
   * @param {Interval} other
   * @return {Interval}
   */
  union(other) {
    if (!this.isValid) return this;
    const s2 = this.s < other.s ? this.s : other.s, e = this.e > other.e ? this.e : other.e;
    return Interval.fromDateTimes(s2, e);
  }
  /**
   * Merge an array of Intervals into a equivalent minimal set of Intervals.
   * Combines overlapping and adjacent Intervals.
   * @param {Array} intervals
   * @return {Array}
   */
  static merge(intervals) {
    const [found, final] = intervals.sort((a, b) => a.s - b.s).reduce(
      ([sofar, current], item) => {
        if (!current) {
          return [sofar, item];
        } else if (current.overlaps(item) || current.abutsStart(item)) {
          return [sofar, current.union(item)];
        } else {
          return [sofar.concat([current]), item];
        }
      },
      [[], null]
    );
    if (final) {
      found.push(final);
    }
    return found;
  }
  /**
   * Return an array of Intervals representing the spans of time that only appear in one of the specified Intervals.
   * @param {Array} intervals
   * @return {Array}
   */
  static xor(intervals) {
    let start = null, currentCount = 0;
    const results = [], ends = intervals.map((i) => [
      { time: i.s, type: "s" },
      { time: i.e, type: "e" }
    ]), flattened = Array.prototype.concat(...ends), arr = flattened.sort((a, b) => a.time - b.time);
    for (const i of arr) {
      currentCount += i.type === "s" ? 1 : -1;
      if (currentCount === 1) {
        start = i.time;
      } else {
        if (start && +start !== +i.time) {
          results.push(Interval.fromDateTimes(start, i.time));
        }
        start = null;
      }
    }
    return Interval.merge(results);
  }
  /**
   * Return an Interval representing the span of time in this Interval that doesn't overlap with any of the specified Intervals.
   * @param {...Interval} intervals
   * @return {Array}
   */
  difference(...intervals) {
    return Interval.xor([this].concat(intervals)).map((i) => this.intersection(i)).filter((i) => i && !i.isEmpty());
  }
  /**
   * Returns a string representation of this Interval appropriate for debugging.
   * @return {string}
   */
  toString() {
    if (!this.isValid) return INVALID$1;
    return `[${this.s.toISO()} – ${this.e.toISO()})`;
  }
  /**
   * Returns a string representation of this Interval appropriate for the REPL.
   * @return {string}
   */
  [Symbol.for("nodejs.util.inspect.custom")]() {
    if (this.isValid) {
      return `Interval { start: ${this.s.toISO()}, end: ${this.e.toISO()} }`;
    } else {
      return `Interval { Invalid, reason: ${this.invalidReason} }`;
    }
  }
  /**
   * Returns a localized string representing this Interval. Accepts the same options as the
   * Intl.DateTimeFormat constructor and any presets defined by Luxon, such as
   * {@link DateTime.DATE_FULL} or {@link DateTime.TIME_SIMPLE}. The exact behavior of this method
   * is browser-specific, but in general it will return an appropriate representation of the
   * Interval in the assigned locale. Defaults to the system's locale if no locale has been
   * specified.
   * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/DateTimeFormat
   * @param {Object} [formatOpts=DateTime.DATE_SHORT] - Either a DateTime preset or
   * Intl.DateTimeFormat constructor options.
   * @param {Object} opts - Options to override the configuration of the start DateTime.
   * @example Interval.fromISO('2022-11-07T09:00Z/2022-11-08T09:00Z').toLocaleString(); //=> 11/7/2022 – 11/8/2022
   * @example Interval.fromISO('2022-11-07T09:00Z/2022-11-08T09:00Z').toLocaleString(DateTime.DATE_FULL); //=> November 7 – 8, 2022
   * @example Interval.fromISO('2022-11-07T09:00Z/2022-11-08T09:00Z').toLocaleString(DateTime.DATE_FULL, { locale: 'fr-FR' }); //=> 7–8 novembre 2022
   * @example Interval.fromISO('2022-11-07T17:00Z/2022-11-07T19:00Z').toLocaleString(DateTime.TIME_SIMPLE); //=> 6:00 – 8:00 PM
   * @example Interval.fromISO('2022-11-07T17:00Z/2022-11-07T19:00Z').toLocaleString({ weekday: 'short', month: 'short', day: '2-digit', hour: '2-digit', minute: '2-digit' }); //=> Mon, Nov 07, 6:00 – 8:00 p
   * @return {string}
   */
  toLocaleString(formatOpts = DATE_SHORT, opts = {}) {
    return this.isValid ? Formatter.create(this.s.loc.clone(opts), formatOpts).formatInterval(this) : INVALID$1;
  }
  /**
   * Returns an ISO 8601-compliant string representation of this Interval.
   * @see https://en.wikipedia.org/wiki/ISO_8601#Time_intervals
   * @param {Object} opts - The same options as {@link DateTime#toISO}
   * @return {string}
   */
  toISO(opts) {
    if (!this.isValid) return INVALID$1;
    return `${this.s.toISO(opts)}/${this.e.toISO(opts)}`;
  }
  /**
   * Returns an ISO 8601-compliant string representation of date of this Interval.
   * The time components are ignored.
   * @see https://en.wikipedia.org/wiki/ISO_8601#Time_intervals
   * @return {string}
   */
  toISODate() {
    if (!this.isValid) return INVALID$1;
    return `${this.s.toISODate()}/${this.e.toISODate()}`;
  }
  /**
   * Returns an ISO 8601-compliant string representation of time of this Interval.
   * The date components are ignored.
   * @see https://en.wikipedia.org/wiki/ISO_8601#Time_intervals
   * @param {Object} opts - The same options as {@link DateTime#toISO}
   * @return {string}
   */
  toISOTime(opts) {
    if (!this.isValid) return INVALID$1;
    return `${this.s.toISOTime(opts)}/${this.e.toISOTime(opts)}`;
  }
  /**
   * Returns a string representation of this Interval formatted according to the specified format
   * string. **You may not want this.** See {@link Interval#toLocaleString} for a more flexible
   * formatting tool.
   * @param {string} dateFormat - The format string. This string formats the start and end time.
   * See {@link DateTime#toFormat} for details.
   * @param {Object} opts - Options.
   * @param {string} [opts.separator =  ' – '] - A separator to place between the start and end
   * representations.
   * @return {string}
   */
  toFormat(dateFormat, { separator = " – " } = {}) {
    if (!this.isValid) return INVALID$1;
    return `${this.s.toFormat(dateFormat)}${separator}${this.e.toFormat(dateFormat)}`;
  }
  /**
   * Return a Duration representing the time spanned by this interval.
   * @param {string|string[]} [unit=['milliseconds']] - the unit or units (such as 'hours' or 'days') to include in the duration.
   * @param {Object} opts - options that affect the creation of the Duration
   * @param {string} [opts.conversionAccuracy='casual'] - the conversion system to use
   * @example Interval.fromDateTimes(dt1, dt2).toDuration().toObject() //=> { milliseconds: 88489257 }
   * @example Interval.fromDateTimes(dt1, dt2).toDuration('days').toObject() //=> { days: 1.0241812152777778 }
   * @example Interval.fromDateTimes(dt1, dt2).toDuration(['hours', 'minutes']).toObject() //=> { hours: 24, minutes: 34.82095 }
   * @example Interval.fromDateTimes(dt1, dt2).toDuration(['hours', 'minutes', 'seconds']).toObject() //=> { hours: 24, minutes: 34, seconds: 49.257 }
   * @example Interval.fromDateTimes(dt1, dt2).toDuration('seconds').toObject() //=> { seconds: 88489.257 }
   * @return {Duration}
   */
  toDuration(unit, opts) {
    if (!this.isValid) {
      return Duration.invalid(this.invalidReason);
    }
    return this.e.diff(this.s, unit, opts);
  }
  /**
   * Run mapFn on the interval start and end, returning a new Interval from the resulting DateTimes
   * @param {function} mapFn
   * @return {Interval}
   * @example Interval.fromDateTimes(dt1, dt2).mapEndpoints(endpoint => endpoint.toUTC())
   * @example Interval.fromDateTimes(dt1, dt2).mapEndpoints(endpoint => endpoint.plus({ hours: 2 }))
   */
  mapEndpoints(mapFn) {
    return Interval.fromDateTimes(mapFn(this.s), mapFn(this.e));
  }
}
class Info {
  /**
   * Return whether the specified zone contains a DST.
   * @param {string|Zone} [zone='local'] - Zone to check. Defaults to the environment's local zone.
   * @return {boolean}
   */
  static hasDST(zone = Settings.defaultZone) {
    const proto = DateTime.now().setZone(zone).set({ month: 12 });
    return !zone.isUniversal && proto.offset !== proto.set({ month: 6 }).offset;
  }
  /**
   * Return whether the specified zone is a valid IANA specifier.
   * @param {string} zone - Zone to check
   * @return {boolean}
   */
  static isValidIANAZone(zone) {
    return IANAZone.isValidZone(zone);
  }
  /**
   * Converts the input into a {@link Zone} instance.
   *
   * * If `input` is already a Zone instance, it is returned unchanged.
   * * If `input` is a string containing a valid time zone name, a Zone instance
   *   with that name is returned.
   * * If `input` is a string that doesn't refer to a known time zone, a Zone
   *   instance with {@link Zone#isValid} == false is returned.
   * * If `input is a number, a Zone instance with the specified fixed offset
   *   in minutes is returned.
   * * If `input` is `null` or `undefined`, the default zone is returned.
   * @param {string|Zone|number} [input] - the value to be converted
   * @return {Zone}
   */
  static normalizeZone(input) {
    return normalizeZone(input, Settings.defaultZone);
  }
  /**
   * Get the weekday on which the week starts according to the given locale.
   * @param {Object} opts - options
   * @param {string} [opts.locale] - the locale code
   * @param {string} [opts.locObj=null] - an existing locale object to use
   * @returns {number} the start of the week, 1 for Monday through 7 for Sunday
   */
  static getStartOfWeek({ locale = null, locObj = null } = {}) {
    return (locObj || Locale.create(locale)).getStartOfWeek();
  }
  /**
   * Get the minimum number of days necessary in a week before it is considered part of the next year according
   * to the given locale.
   * @param {Object} opts - options
   * @param {string} [opts.locale] - the locale code
   * @param {string} [opts.locObj=null] - an existing locale object to use
   * @returns {number}
   */
  static getMinimumDaysInFirstWeek({ locale = null, locObj = null } = {}) {
    return (locObj || Locale.create(locale)).getMinDaysInFirstWeek();
  }
  /**
   * Get the weekdays, which are considered the weekend according to the given locale
   * @param {Object} opts - options
   * @param {string} [opts.locale] - the locale code
   * @param {string} [opts.locObj=null] - an existing locale object to use
   * @returns {number[]} an array of weekdays, 1 for Monday through 7 for Sunday
   */
  static getWeekendWeekdays({ locale = null, locObj = null } = {}) {
    return (locObj || Locale.create(locale)).getWeekendDays().slice();
  }
  /**
   * Return an array of standalone month names.
   * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/DateTimeFormat
   * @param {string} [length='long'] - the length of the month representation, such as "numeric", "2-digit", "narrow", "short", "long"
   * @param {Object} opts - options
   * @param {string} [opts.locale] - the locale code
   * @param {string} [opts.numberingSystem=null] - the numbering system
   * @param {string} [opts.locObj=null] - an existing locale object to use
   * @param {string} [opts.outputCalendar='gregory'] - the calendar
   * @example Info.months()[0] //=> 'January'
   * @example Info.months('short')[0] //=> 'Jan'
   * @example Info.months('numeric')[0] //=> '1'
   * @example Info.months('short', { locale: 'fr-CA' } )[0] //=> 'janv.'
   * @example Info.months('numeric', { locale: 'ar' })[0] //=> '١'
   * @example Info.months('long', { outputCalendar: 'islamic' })[0] //=> 'Rabiʻ I'
   * @return {Array}
   */
  static months(length = "long", { locale = null, numberingSystem = null, locObj = null, outputCalendar = "gregory" } = {}) {
    return (locObj || Locale.create(locale, numberingSystem, outputCalendar)).months(length);
  }
  /**
   * Return an array of format month names.
   * Format months differ from standalone months in that they're meant to appear next to the day of the month. In some languages, that
   * changes the string.
   * See {@link Info#months}
   * @param {string} [length='long'] - the length of the month representation, such as "numeric", "2-digit", "narrow", "short", "long"
   * @param {Object} opts - options
   * @param {string} [opts.locale] - the locale code
   * @param {string} [opts.numberingSystem=null] - the numbering system
   * @param {string} [opts.locObj=null] - an existing locale object to use
   * @param {string} [opts.outputCalendar='gregory'] - the calendar
   * @return {Array}
   */
  static monthsFormat(length = "long", { locale = null, numberingSystem = null, locObj = null, outputCalendar = "gregory" } = {}) {
    return (locObj || Locale.create(locale, numberingSystem, outputCalendar)).months(length, true);
  }
  /**
   * Return an array of standalone week names.
   * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/DateTimeFormat
   * @param {string} [length='long'] - the length of the weekday representation, such as "narrow", "short", "long".
   * @param {Object} opts - options
   * @param {string} [opts.locale] - the locale code
   * @param {string} [opts.numberingSystem=null] - the numbering system
   * @param {string} [opts.locObj=null] - an existing locale object to use
   * @example Info.weekdays()[0] //=> 'Monday'
   * @example Info.weekdays('short')[0] //=> 'Mon'
   * @example Info.weekdays('short', { locale: 'fr-CA' })[0] //=> 'lun.'
   * @example Info.weekdays('short', { locale: 'ar' })[0] //=> 'الاثنين'
   * @return {Array}
   */
  static weekdays(length = "long", { locale = null, numberingSystem = null, locObj = null } = {}) {
    return (locObj || Locale.create(locale, numberingSystem, null)).weekdays(length);
  }
  /**
   * Return an array of format week names.
   * Format weekdays differ from standalone weekdays in that they're meant to appear next to more date information. In some languages, that
   * changes the string.
   * See {@link Info#weekdays}
   * @param {string} [length='long'] - the length of the month representation, such as "narrow", "short", "long".
   * @param {Object} opts - options
   * @param {string} [opts.locale=null] - the locale code
   * @param {string} [opts.numberingSystem=null] - the numbering system
   * @param {string} [opts.locObj=null] - an existing locale object to use
   * @return {Array}
   */
  static weekdaysFormat(length = "long", { locale = null, numberingSystem = null, locObj = null } = {}) {
    return (locObj || Locale.create(locale, numberingSystem, null)).weekdays(length, true);
  }
  /**
   * Return an array of meridiems.
   * @param {Object} opts - options
   * @param {string} [opts.locale] - the locale code
   * @example Info.meridiems() //=> [ 'AM', 'PM' ]
   * @example Info.meridiems({ locale: 'my' }) //=> [ 'နံနက်', 'ညနေ' ]
   * @return {Array}
   */
  static meridiems({ locale = null } = {}) {
    return Locale.create(locale).meridiems();
  }
  /**
   * Return an array of eras, such as ['BC', 'AD']. The locale can be specified, but the calendar system is always Gregorian.
   * @param {string} [length='short'] - the length of the era representation, such as "short" or "long".
   * @param {Object} opts - options
   * @param {string} [opts.locale] - the locale code
   * @example Info.eras() //=> [ 'BC', 'AD' ]
   * @example Info.eras('long') //=> [ 'Before Christ', 'Anno Domini' ]
   * @example Info.eras('long', { locale: 'fr' }) //=> [ 'avant Jésus-Christ', 'après Jésus-Christ' ]
   * @return {Array}
   */
  static eras(length = "short", { locale = null } = {}) {
    return Locale.create(locale, null, "gregory").eras(length);
  }
  /**
   * Return the set of available features in this environment.
   * Some features of Luxon are not available in all environments. For example, on older browsers, relative time formatting support is not available. Use this function to figure out if that's the case.
   * Keys:
   * * `relative`: whether this environment supports relative time formatting
   * * `localeWeek`: whether this environment supports different weekdays for the start of the week based on the locale
   * @example Info.features() //=> { relative: false, localeWeek: true }
   * @return {Object}
   */
  static features() {
    return { relative: hasRelative(), localeWeek: hasLocaleWeekInfo() };
  }
}
function dayDiff(earlier, later) {
  const utcDayStart = (dt) => dt.toUTC(0, { keepLocalTime: true }).startOf("day").valueOf(), ms = utcDayStart(later) - utcDayStart(earlier);
  return Math.floor(Duration.fromMillis(ms).as("days"));
}
function highOrderDiffs(cursor, later, units) {
  const differs = [
    ["years", (a, b) => b.year - a.year],
    ["quarters", (a, b) => b.quarter - a.quarter + (b.year - a.year) * 4],
    ["months", (a, b) => b.month - a.month + (b.year - a.year) * 12],
    [
      "weeks",
      (a, b) => {
        const days = dayDiff(a, b);
        return (days - days % 7) / 7;
      }
    ],
    ["days", dayDiff]
  ];
  const results = {};
  const earlier = cursor;
  let lowestOrder, highWater;
  for (const [unit, differ] of differs) {
    if (units.indexOf(unit) >= 0) {
      lowestOrder = unit;
      results[unit] = differ(cursor, later);
      highWater = earlier.plus(results);
      if (highWater > later) {
        results[unit]--;
        cursor = earlier.plus(results);
        if (cursor > later) {
          highWater = cursor;
          results[unit]--;
          cursor = earlier.plus(results);
        }
      } else {
        cursor = highWater;
      }
    }
  }
  return [cursor, results, highWater, lowestOrder];
}
function diff(earlier, later, units, opts) {
  let [cursor, results, highWater, lowestOrder] = highOrderDiffs(earlier, later, units);
  const remainingMillis = later - cursor;
  const lowerOrderUnits = units.filter(
    (u) => ["hours", "minutes", "seconds", "milliseconds"].indexOf(u) >= 0
  );
  if (lowerOrderUnits.length === 0) {
    if (highWater < later) {
      highWater = cursor.plus({ [lowestOrder]: 1 });
    }
    if (highWater !== cursor) {
      results[lowestOrder] = (results[lowestOrder] || 0) + remainingMillis / (highWater - cursor);
    }
  }
  const duration = Duration.fromObject(results, opts);
  if (lowerOrderUnits.length > 0) {
    return Duration.fromMillis(remainingMillis, opts).shiftTo(...lowerOrderUnits).plus(duration);
  } else {
    return duration;
  }
}
const MISSING_FTP = "missing Intl.DateTimeFormat.formatToParts support";
function intUnit(regex, post = (i) => i) {
  return { regex, deser: ([s2]) => post(parseDigits(s2)) };
}
const NBSP = String.fromCharCode(160);
const spaceOrNBSP = `[ ${NBSP}]`;
const spaceOrNBSPRegExp = new RegExp(spaceOrNBSP, "g");
function fixListRegex(s2) {
  return s2.replace(/\./g, "\\.?").replace(spaceOrNBSPRegExp, spaceOrNBSP);
}
function stripInsensitivities(s2) {
  return s2.replace(/\./g, "").replace(spaceOrNBSPRegExp, " ").toLowerCase();
}
function oneOf(strings, startIndex) {
  if (strings === null) {
    return null;
  } else {
    return {
      regex: RegExp(strings.map(fixListRegex).join("|")),
      deser: ([s2]) => strings.findIndex((i) => stripInsensitivities(s2) === stripInsensitivities(i)) + startIndex
    };
  }
}
function offset(regex, groups) {
  return { regex, deser: ([, h, m]) => signedOffset(h, m), groups };
}
function simple(regex) {
  return { regex, deser: ([s2]) => s2 };
}
function escapeToken(value) {
  return value.replace(/[\-\[\]{}()*+?.,\\\^$|#\s]/g, "\\$&");
}
function unitForToken(token, loc) {
  const one = digitRegex(loc), two = digitRegex(loc, "{2}"), three = digitRegex(loc, "{3}"), four = digitRegex(loc, "{4}"), six = digitRegex(loc, "{6}"), oneOrTwo = digitRegex(loc, "{1,2}"), oneToThree = digitRegex(loc, "{1,3}"), oneToSix = digitRegex(loc, "{1,6}"), oneToNine = digitRegex(loc, "{1,9}"), twoToFour = digitRegex(loc, "{2,4}"), fourToSix = digitRegex(loc, "{4,6}"), literal = (t) => ({ regex: RegExp(escapeToken(t.val)), deser: ([s2]) => s2, literal: true }), unitate = (t) => {
    if (token.literal) {
      return literal(t);
    }
    switch (t.val) {
      case "G":
        return oneOf(loc.eras("short"), 0);
      case "GG":
        return oneOf(loc.eras("long"), 0);
      case "y":
        return intUnit(oneToSix);
      case "yy":
        return intUnit(twoToFour, untruncateYear);
      case "yyyy":
        return intUnit(four);
      case "yyyyy":
        return intUnit(fourToSix);
      case "yyyyyy":
        return intUnit(six);
      case "M":
        return intUnit(oneOrTwo);
      case "MM":
        return intUnit(two);
      case "MMM":
        return oneOf(loc.months("short", true), 1);
      case "MMMM":
        return oneOf(loc.months("long", true), 1);
      case "L":
        return intUnit(oneOrTwo);
      case "LL":
        return intUnit(two);
      case "LLL":
        return oneOf(loc.months("short", false), 1);
      case "LLLL":
        return oneOf(loc.months("long", false), 1);
      case "d":
        return intUnit(oneOrTwo);
      case "dd":
        return intUnit(two);
      case "o":
        return intUnit(oneToThree);
      case "ooo":
        return intUnit(three);
      case "HH":
        return intUnit(two);
      case "H":
        return intUnit(oneOrTwo);
      case "hh":
        return intUnit(two);
      case "h":
        return intUnit(oneOrTwo);
      case "mm":
        return intUnit(two);
      case "m":
        return intUnit(oneOrTwo);
      case "q":
        return intUnit(oneOrTwo);
      case "qq":
        return intUnit(two);
      case "s":
        return intUnit(oneOrTwo);
      case "ss":
        return intUnit(two);
      case "S":
        return intUnit(oneToThree);
      case "SSS":
        return intUnit(three);
      case "u":
        return simple(oneToNine);
      case "uu":
        return simple(oneOrTwo);
      case "uuu":
        return intUnit(one);
      case "a":
        return oneOf(loc.meridiems(), 0);
      case "kkkk":
        return intUnit(four);
      case "kk":
        return intUnit(twoToFour, untruncateYear);
      case "W":
        return intUnit(oneOrTwo);
      case "WW":
        return intUnit(two);
      case "E":
      case "c":
        return intUnit(one);
      case "EEE":
        return oneOf(loc.weekdays("short", false), 1);
      case "EEEE":
        return oneOf(loc.weekdays("long", false), 1);
      case "ccc":
        return oneOf(loc.weekdays("short", true), 1);
      case "cccc":
        return oneOf(loc.weekdays("long", true), 1);
      case "Z":
      case "ZZ":
        return offset(new RegExp(`([+-]${oneOrTwo.source})(?::(${two.source}))?`), 2);
      case "ZZZ":
        return offset(new RegExp(`([+-]${oneOrTwo.source})(${two.source})?`), 2);
      case "z":
        return simple(/[a-z_+-/]{1,256}?/i);
      case " ":
        return simple(/[^\S\n\r]/);
      default:
        return literal(t);
    }
  };
  const unit = unitate(token) || {
    invalidReason: MISSING_FTP
  };
  unit.token = token;
  return unit;
}
const partTypeStyleToTokenVal = {
  year: {
    "2-digit": "yy",
    numeric: "yyyyy"
  },
  month: {
    numeric: "M",
    "2-digit": "MM",
    short: "MMM",
    long: "MMMM"
  },
  day: {
    numeric: "d",
    "2-digit": "dd"
  },
  weekday: {
    short: "EEE",
    long: "EEEE"
  },
  dayperiod: "a",
  dayPeriod: "a",
  hour12: {
    numeric: "h",
    "2-digit": "hh"
  },
  hour24: {
    numeric: "H",
    "2-digit": "HH"
  },
  minute: {
    numeric: "m",
    "2-digit": "mm"
  },
  second: {
    numeric: "s",
    "2-digit": "ss"
  },
  timeZoneName: {
    long: "ZZZZZ",
    short: "ZZZ"
  }
};
function tokenForPart(part, formatOpts, resolvedOpts) {
  const { type, value } = part;
  if (type === "literal") {
    const isSpace = /^\s+$/.test(value);
    return {
      literal: !isSpace,
      val: isSpace ? " " : value
    };
  }
  const style = formatOpts[type];
  let actualType = type;
  if (type === "hour") {
    if (formatOpts.hour12 != null) {
      actualType = formatOpts.hour12 ? "hour12" : "hour24";
    } else if (formatOpts.hourCycle != null) {
      if (formatOpts.hourCycle === "h11" || formatOpts.hourCycle === "h12") {
        actualType = "hour12";
      } else {
        actualType = "hour24";
      }
    } else {
      actualType = resolvedOpts.hour12 ? "hour12" : "hour24";
    }
  }
  let val = partTypeStyleToTokenVal[actualType];
  if (typeof val === "object") {
    val = val[style];
  }
  if (val) {
    return {
      literal: false,
      val
    };
  }
  return void 0;
}
function buildRegex(units) {
  const re = units.map((u) => u.regex).reduce((f, r) => `${f}(${r.source})`, "");
  return [`^${re}$`, units];
}
function match(input, regex, handlers) {
  const matches = input.match(regex);
  if (matches) {
    const all = {};
    let matchIndex = 1;
    for (const i in handlers) {
      if (hasOwnProperty(handlers, i)) {
        const h = handlers[i], groups = h.groups ? h.groups + 1 : 1;
        if (!h.literal && h.token) {
          all[h.token.val[0]] = h.deser(matches.slice(matchIndex, matchIndex + groups));
        }
        matchIndex += groups;
      }
    }
    return [matches, all];
  } else {
    return [matches, {}];
  }
}
function dateTimeFromMatches(matches) {
  const toField = (token) => {
    switch (token) {
      case "S":
        return "millisecond";
      case "s":
        return "second";
      case "m":
        return "minute";
      case "h":
      case "H":
        return "hour";
      case "d":
        return "day";
      case "o":
        return "ordinal";
      case "L":
      case "M":
        return "month";
      case "y":
        return "year";
      case "E":
      case "c":
        return "weekday";
      case "W":
        return "weekNumber";
      case "k":
        return "weekYear";
      case "q":
        return "quarter";
      default:
        return null;
    }
  };
  let zone = null;
  let specificOffset;
  if (!isUndefined(matches.z)) {
    zone = IANAZone.create(matches.z);
  }
  if (!isUndefined(matches.Z)) {
    if (!zone) {
      zone = new FixedOffsetZone(matches.Z);
    }
    specificOffset = matches.Z;
  }
  if (!isUndefined(matches.q)) {
    matches.M = (matches.q - 1) * 3 + 1;
  }
  if (!isUndefined(matches.h)) {
    if (matches.h < 12 && matches.a === 1) {
      matches.h += 12;
    } else if (matches.h === 12 && matches.a === 0) {
      matches.h = 0;
    }
  }
  if (matches.G === 0 && matches.y) {
    matches.y = -matches.y;
  }
  if (!isUndefined(matches.u)) {
    matches.S = parseMillis(matches.u);
  }
  const vals = Object.keys(matches).reduce((r, k) => {
    const f = toField(k);
    if (f) {
      r[f] = matches[k];
    }
    return r;
  }, {});
  return [vals, zone, specificOffset];
}
let dummyDateTimeCache = null;
function getDummyDateTime() {
  if (!dummyDateTimeCache) {
    dummyDateTimeCache = DateTime.fromMillis(1555555555555);
  }
  return dummyDateTimeCache;
}
function maybeExpandMacroToken(token, locale) {
  if (token.literal) {
    return token;
  }
  const formatOpts = Formatter.macroTokenToFormatOpts(token.val);
  const tokens = formatOptsToTokens(formatOpts, locale);
  if (tokens == null || tokens.includes(void 0)) {
    return token;
  }
  return tokens;
}
function expandMacroTokens(tokens, locale) {
  return Array.prototype.concat(...tokens.map((t) => maybeExpandMacroToken(t, locale)));
}
class TokenParser {
  constructor(locale, format) {
    this.locale = locale;
    this.format = format;
    this.tokens = expandMacroTokens(Formatter.parseFormat(format), locale);
    this.units = this.tokens.map((t) => unitForToken(t, locale));
    this.disqualifyingUnit = this.units.find((t) => t.invalidReason);
    if (!this.disqualifyingUnit) {
      const [regexString, handlers] = buildRegex(this.units);
      this.regex = RegExp(regexString, "i");
      this.handlers = handlers;
    }
  }
  explainFromTokens(input) {
    if (!this.isValid) {
      return { input, tokens: this.tokens, invalidReason: this.invalidReason };
    } else {
      const [rawMatches, matches] = match(input, this.regex, this.handlers), [result, zone, specificOffset] = matches ? dateTimeFromMatches(matches) : [null, null, void 0];
      if (hasOwnProperty(matches, "a") && hasOwnProperty(matches, "H")) {
        throw new ConflictingSpecificationError(
          "Can't include meridiem when specifying 24-hour format"
        );
      }
      return {
        input,
        tokens: this.tokens,
        regex: this.regex,
        rawMatches,
        matches,
        result,
        zone,
        specificOffset
      };
    }
  }
  get isValid() {
    return !this.disqualifyingUnit;
  }
  get invalidReason() {
    return this.disqualifyingUnit ? this.disqualifyingUnit.invalidReason : null;
  }
}
function explainFromTokens(locale, input, format) {
  const parser = new TokenParser(locale, format);
  return parser.explainFromTokens(input);
}
function parseFromTokens(locale, input, format) {
  const { result, zone, specificOffset, invalidReason } = explainFromTokens(locale, input, format);
  return [result, zone, specificOffset, invalidReason];
}
function formatOptsToTokens(formatOpts, locale) {
  if (!formatOpts) {
    return null;
  }
  const formatter = Formatter.create(locale, formatOpts);
  const df = formatter.dtFormatter(getDummyDateTime());
  const parts = df.formatToParts();
  const resolvedOpts = df.resolvedOptions();
  return parts.map((p) => tokenForPart(p, formatOpts, resolvedOpts));
}
const INVALID = "Invalid DateTime";
const MAX_DATE = 864e13;
function unsupportedZone(zone) {
  return new Invalid("unsupported zone", `the zone "${zone.name}" is not supported`);
}
function possiblyCachedWeekData(dt) {
  if (dt.weekData === null) {
    dt.weekData = gregorianToWeek(dt.c);
  }
  return dt.weekData;
}
function possiblyCachedLocalWeekData(dt) {
  if (dt.localWeekData === null) {
    dt.localWeekData = gregorianToWeek(
      dt.c,
      dt.loc.getMinDaysInFirstWeek(),
      dt.loc.getStartOfWeek()
    );
  }
  return dt.localWeekData;
}
function clone(inst, alts) {
  const current = {
    ts: inst.ts,
    zone: inst.zone,
    c: inst.c,
    o: inst.o,
    loc: inst.loc,
    invalid: inst.invalid
  };
  return new DateTime({ ...current, ...alts, old: current });
}
function fixOffset(localTS, o, tz) {
  let utcGuess = localTS - o * 60 * 1e3;
  const o2 = tz.offset(utcGuess);
  if (o === o2) {
    return [utcGuess, o];
  }
  utcGuess -= (o2 - o) * 60 * 1e3;
  const o3 = tz.offset(utcGuess);
  if (o2 === o3) {
    return [utcGuess, o2];
  }
  return [localTS - Math.min(o2, o3) * 60 * 1e3, Math.max(o2, o3)];
}
function tsToObj(ts, offset2) {
  ts += offset2 * 60 * 1e3;
  const d = new Date(ts);
  return {
    year: d.getUTCFullYear(),
    month: d.getUTCMonth() + 1,
    day: d.getUTCDate(),
    hour: d.getUTCHours(),
    minute: d.getUTCMinutes(),
    second: d.getUTCSeconds(),
    millisecond: d.getUTCMilliseconds()
  };
}
function objToTS(obj, offset2, zone) {
  return fixOffset(objToLocalTS(obj), offset2, zone);
}
function adjustTime(inst, dur) {
  const oPre = inst.o, year = inst.c.year + Math.trunc(dur.years), month = inst.c.month + Math.trunc(dur.months) + Math.trunc(dur.quarters) * 3, c = {
    ...inst.c,
    year,
    month,
    day: Math.min(inst.c.day, daysInMonth(year, month)) + Math.trunc(dur.days) + Math.trunc(dur.weeks) * 7
  }, millisToAdd = Duration.fromObject({
    years: dur.years - Math.trunc(dur.years),
    quarters: dur.quarters - Math.trunc(dur.quarters),
    months: dur.months - Math.trunc(dur.months),
    weeks: dur.weeks - Math.trunc(dur.weeks),
    days: dur.days - Math.trunc(dur.days),
    hours: dur.hours,
    minutes: dur.minutes,
    seconds: dur.seconds,
    milliseconds: dur.milliseconds
  }).as("milliseconds"), localTS = objToLocalTS(c);
  let [ts, o] = fixOffset(localTS, oPre, inst.zone);
  if (millisToAdd !== 0) {
    ts += millisToAdd;
    o = inst.zone.offset(ts);
  }
  return { ts, o };
}
function parseDataToDateTime(parsed, parsedZone, opts, format, text, specificOffset) {
  const { setZone, zone } = opts;
  if (parsed && Object.keys(parsed).length !== 0 || parsedZone) {
    const interpretationZone = parsedZone || zone, inst = DateTime.fromObject(parsed, {
      ...opts,
      zone: interpretationZone,
      specificOffset
    });
    return setZone ? inst : inst.setZone(zone);
  } else {
    return DateTime.invalid(
      new Invalid("unparsable", `the input "${text}" can't be parsed as ${format}`)
    );
  }
}
function toTechFormat(dt, format, allowZ = true) {
  return dt.isValid ? Formatter.create(Locale.create("en-US"), {
    allowZ,
    forceSimple: true
  }).formatDateTimeFromString(dt, format) : null;
}
function toISODate(o, extended) {
  const longFormat = o.c.year > 9999 || o.c.year < 0;
  let c = "";
  if (longFormat && o.c.year >= 0) c += "+";
  c += padStart(o.c.year, longFormat ? 6 : 4);
  if (extended) {
    c += "-";
    c += padStart(o.c.month);
    c += "-";
    c += padStart(o.c.day);
  } else {
    c += padStart(o.c.month);
    c += padStart(o.c.day);
  }
  return c;
}
function toISOTime(o, extended, suppressSeconds, suppressMilliseconds, includeOffset, extendedZone) {
  let c = padStart(o.c.hour);
  if (extended) {
    c += ":";
    c += padStart(o.c.minute);
    if (o.c.millisecond !== 0 || o.c.second !== 0 || !suppressSeconds) {
      c += ":";
    }
  } else {
    c += padStart(o.c.minute);
  }
  if (o.c.millisecond !== 0 || o.c.second !== 0 || !suppressSeconds) {
    c += padStart(o.c.second);
    if (o.c.millisecond !== 0 || !suppressMilliseconds) {
      c += ".";
      c += padStart(o.c.millisecond, 3);
    }
  }
  if (includeOffset) {
    if (o.isOffsetFixed && o.offset === 0 && !extendedZone) {
      c += "Z";
    } else if (o.o < 0) {
      c += "-";
      c += padStart(Math.trunc(-o.o / 60));
      c += ":";
      c += padStart(Math.trunc(-o.o % 60));
    } else {
      c += "+";
      c += padStart(Math.trunc(o.o / 60));
      c += ":";
      c += padStart(Math.trunc(o.o % 60));
    }
  }
  if (extendedZone) {
    c += "[" + o.zone.ianaName + "]";
  }
  return c;
}
const defaultUnitValues = {
  month: 1,
  day: 1,
  hour: 0,
  minute: 0,
  second: 0,
  millisecond: 0
}, defaultWeekUnitValues = {
  weekNumber: 1,
  weekday: 1,
  hour: 0,
  minute: 0,
  second: 0,
  millisecond: 0
}, defaultOrdinalUnitValues = {
  ordinal: 1,
  hour: 0,
  minute: 0,
  second: 0,
  millisecond: 0
};
const orderedUnits = ["year", "month", "day", "hour", "minute", "second", "millisecond"], orderedWeekUnits = [
  "weekYear",
  "weekNumber",
  "weekday",
  "hour",
  "minute",
  "second",
  "millisecond"
], orderedOrdinalUnits = ["year", "ordinal", "hour", "minute", "second", "millisecond"];
function normalizeUnit(unit) {
  const normalized = {
    year: "year",
    years: "year",
    month: "month",
    months: "month",
    day: "day",
    days: "day",
    hour: "hour",
    hours: "hour",
    minute: "minute",
    minutes: "minute",
    quarter: "quarter",
    quarters: "quarter",
    second: "second",
    seconds: "second",
    millisecond: "millisecond",
    milliseconds: "millisecond",
    weekday: "weekday",
    weekdays: "weekday",
    weeknumber: "weekNumber",
    weeksnumber: "weekNumber",
    weeknumbers: "weekNumber",
    weekyear: "weekYear",
    weekyears: "weekYear",
    ordinal: "ordinal"
  }[unit.toLowerCase()];
  if (!normalized) throw new InvalidUnitError(unit);
  return normalized;
}
function normalizeUnitWithLocalWeeks(unit) {
  switch (unit.toLowerCase()) {
    case "localweekday":
    case "localweekdays":
      return "localWeekday";
    case "localweeknumber":
    case "localweeknumbers":
      return "localWeekNumber";
    case "localweekyear":
    case "localweekyears":
      return "localWeekYear";
    default:
      return normalizeUnit(unit);
  }
}
function guessOffsetForZone(zone) {
  if (!zoneOffsetGuessCache[zone]) {
    if (zoneOffsetTs === void 0) {
      zoneOffsetTs = Settings.now();
    }
    zoneOffsetGuessCache[zone] = zone.offset(zoneOffsetTs);
  }
  return zoneOffsetGuessCache[zone];
}
function quickDT(obj, opts) {
  const zone = normalizeZone(opts.zone, Settings.defaultZone);
  if (!zone.isValid) {
    return DateTime.invalid(unsupportedZone(zone));
  }
  const loc = Locale.fromObject(opts);
  let ts, o;
  if (!isUndefined(obj.year)) {
    for (const u of orderedUnits) {
      if (isUndefined(obj[u])) {
        obj[u] = defaultUnitValues[u];
      }
    }
    const invalid = hasInvalidGregorianData(obj) || hasInvalidTimeData(obj);
    if (invalid) {
      return DateTime.invalid(invalid);
    }
    const offsetProvis = guessOffsetForZone(zone);
    [ts, o] = objToTS(obj, offsetProvis, zone);
  } else {
    ts = Settings.now();
  }
  return new DateTime({ ts, zone, loc, o });
}
function diffRelative(start, end, opts) {
  const round = isUndefined(opts.round) ? true : opts.round, format = (c, unit) => {
    c = roundTo(c, round || opts.calendary ? 0 : 2, true);
    const formatter = end.loc.clone(opts).relFormatter(opts);
    return formatter.format(c, unit);
  }, differ = (unit) => {
    if (opts.calendary) {
      if (!end.hasSame(start, unit)) {
        return end.startOf(unit).diff(start.startOf(unit), unit).get(unit);
      } else return 0;
    } else {
      return end.diff(start, unit).get(unit);
    }
  };
  if (opts.unit) {
    return format(differ(opts.unit), opts.unit);
  }
  for (const unit of opts.units) {
    const count = differ(unit);
    if (Math.abs(count) >= 1) {
      return format(count, unit);
    }
  }
  return format(start > end ? -0 : 0, opts.units[opts.units.length - 1]);
}
function lastOpts(argList) {
  let opts = {}, args;
  if (argList.length > 0 && typeof argList[argList.length - 1] === "object") {
    opts = argList[argList.length - 1];
    args = Array.from(argList).slice(0, argList.length - 1);
  } else {
    args = Array.from(argList);
  }
  return [opts, args];
}
let zoneOffsetTs;
let zoneOffsetGuessCache = {};
class DateTime {
  /**
   * @access private
   */
  constructor(config) {
    const zone = config.zone || Settings.defaultZone;
    let invalid = config.invalid || (Number.isNaN(config.ts) ? new Invalid("invalid input") : null) || (!zone.isValid ? unsupportedZone(zone) : null);
    this.ts = isUndefined(config.ts) ? Settings.now() : config.ts;
    let c = null, o = null;
    if (!invalid) {
      const unchanged = config.old && config.old.ts === this.ts && config.old.zone.equals(zone);
      if (unchanged) {
        [c, o] = [config.old.c, config.old.o];
      } else {
        const ot = isNumber(config.o) && !config.old ? config.o : zone.offset(this.ts);
        c = tsToObj(this.ts, ot);
        invalid = Number.isNaN(c.year) ? new Invalid("invalid input") : null;
        c = invalid ? null : c;
        o = invalid ? null : ot;
      }
    }
    this._zone = zone;
    this.loc = config.loc || Locale.create();
    this.invalid = invalid;
    this.weekData = null;
    this.localWeekData = null;
    this.c = c;
    this.o = o;
    this.isLuxonDateTime = true;
  }
  // CONSTRUCT
  /**
   * Create a DateTime for the current instant, in the system's time zone.
   *
   * Use Settings to override these default values if needed.
   * @example DateTime.now().toISO() //~> now in the ISO format
   * @return {DateTime}
   */
  static now() {
    return new DateTime({});
  }
  /**
   * Create a local DateTime
   * @param {number} [year] - The calendar year. If omitted (as in, call `local()` with no arguments), the current time will be used
   * @param {number} [month=1] - The month, 1-indexed
   * @param {number} [day=1] - The day of the month, 1-indexed
   * @param {number} [hour=0] - The hour of the day, in 24-hour time
   * @param {number} [minute=0] - The minute of the hour, meaning a number between 0 and 59
   * @param {number} [second=0] - The second of the minute, meaning a number between 0 and 59
   * @param {number} [millisecond=0] - The millisecond of the second, meaning a number between 0 and 999
   * @example DateTime.local()                                  //~> now
   * @example DateTime.local({ zone: "America/New_York" })      //~> now, in US east coast time
   * @example DateTime.local(2017)                              //~> 2017-01-01T00:00:00
   * @example DateTime.local(2017, 3)                           //~> 2017-03-01T00:00:00
   * @example DateTime.local(2017, 3, 12, { locale: "fr" })     //~> 2017-03-12T00:00:00, with a French locale
   * @example DateTime.local(2017, 3, 12, 5)                    //~> 2017-03-12T05:00:00
   * @example DateTime.local(2017, 3, 12, 5, { zone: "utc" })   //~> 2017-03-12T05:00:00, in UTC
   * @example DateTime.local(2017, 3, 12, 5, 45)                //~> 2017-03-12T05:45:00
   * @example DateTime.local(2017, 3, 12, 5, 45, 10)            //~> 2017-03-12T05:45:10
   * @example DateTime.local(2017, 3, 12, 5, 45, 10, 765)       //~> 2017-03-12T05:45:10.765
   * @return {DateTime}
   */
  static local() {
    const [opts, args] = lastOpts(arguments), [year, month, day, hour, minute, second, millisecond] = args;
    return quickDT({ year, month, day, hour, minute, second, millisecond }, opts);
  }
  /**
   * Create a DateTime in UTC
   * @param {number} [year] - The calendar year. If omitted (as in, call `utc()` with no arguments), the current time will be used
   * @param {number} [month=1] - The month, 1-indexed
   * @param {number} [day=1] - The day of the month
   * @param {number} [hour=0] - The hour of the day, in 24-hour time
   * @param {number} [minute=0] - The minute of the hour, meaning a number between 0 and 59
   * @param {number} [second=0] - The second of the minute, meaning a number between 0 and 59
   * @param {number} [millisecond=0] - The millisecond of the second, meaning a number between 0 and 999
   * @param {Object} options - configuration options for the DateTime
   * @param {string} [options.locale] - a locale to set on the resulting DateTime instance
   * @param {string} [options.outputCalendar] - the output calendar to set on the resulting DateTime instance
   * @param {string} [options.numberingSystem] - the numbering system to set on the resulting DateTime instance
   * @param {string} [options.weekSettings] - the week settings to set on the resulting DateTime instance
   * @example DateTime.utc()                                              //~> now
   * @example DateTime.utc(2017)                                          //~> 2017-01-01T00:00:00Z
   * @example DateTime.utc(2017, 3)                                       //~> 2017-03-01T00:00:00Z
   * @example DateTime.utc(2017, 3, 12)                                   //~> 2017-03-12T00:00:00Z
   * @example DateTime.utc(2017, 3, 12, 5)                                //~> 2017-03-12T05:00:00Z
   * @example DateTime.utc(2017, 3, 12, 5, 45)                            //~> 2017-03-12T05:45:00Z
   * @example DateTime.utc(2017, 3, 12, 5, 45, { locale: "fr" })          //~> 2017-03-12T05:45:00Z with a French locale
   * @example DateTime.utc(2017, 3, 12, 5, 45, 10)                        //~> 2017-03-12T05:45:10Z
   * @example DateTime.utc(2017, 3, 12, 5, 45, 10, 765, { locale: "fr" }) //~> 2017-03-12T05:45:10.765Z with a French locale
   * @return {DateTime}
   */
  static utc() {
    const [opts, args] = lastOpts(arguments), [year, month, day, hour, minute, second, millisecond] = args;
    opts.zone = FixedOffsetZone.utcInstance;
    return quickDT({ year, month, day, hour, minute, second, millisecond }, opts);
  }
  /**
   * Create a DateTime from a JavaScript Date object. Uses the default zone.
   * @param {Date} date - a JavaScript Date object
   * @param {Object} options - configuration options for the DateTime
   * @param {string|Zone} [options.zone='local'] - the zone to place the DateTime into
   * @return {DateTime}
   */
  static fromJSDate(date, options = {}) {
    const ts = isDate(date) ? date.valueOf() : NaN;
    if (Number.isNaN(ts)) {
      return DateTime.invalid("invalid input");
    }
    const zoneToUse = normalizeZone(options.zone, Settings.defaultZone);
    if (!zoneToUse.isValid) {
      return DateTime.invalid(unsupportedZone(zoneToUse));
    }
    return new DateTime({
      ts,
      zone: zoneToUse,
      loc: Locale.fromObject(options)
    });
  }
  /**
   * Create a DateTime from a number of milliseconds since the epoch (meaning since 1 January 1970 00:00:00 UTC). Uses the default zone.
   * @param {number} milliseconds - a number of milliseconds since 1970 UTC
   * @param {Object} options - configuration options for the DateTime
   * @param {string|Zone} [options.zone='local'] - the zone to place the DateTime into
   * @param {string} [options.locale] - a locale to set on the resulting DateTime instance
   * @param {string} options.outputCalendar - the output calendar to set on the resulting DateTime instance
   * @param {string} options.numberingSystem - the numbering system to set on the resulting DateTime instance
   * @param {string} options.weekSettings - the week settings to set on the resulting DateTime instance
   * @return {DateTime}
   */
  static fromMillis(milliseconds, options = {}) {
    if (!isNumber(milliseconds)) {
      throw new InvalidArgumentError(
        `fromMillis requires a numerical input, but received a ${typeof milliseconds} with value ${milliseconds}`
      );
    } else if (milliseconds < -MAX_DATE || milliseconds > MAX_DATE) {
      return DateTime.invalid("Timestamp out of range");
    } else {
      return new DateTime({
        ts: milliseconds,
        zone: normalizeZone(options.zone, Settings.defaultZone),
        loc: Locale.fromObject(options)
      });
    }
  }
  /**
   * Create a DateTime from a number of seconds since the epoch (meaning since 1 January 1970 00:00:00 UTC). Uses the default zone.
   * @param {number} seconds - a number of seconds since 1970 UTC
   * @param {Object} options - configuration options for the DateTime
   * @param {string|Zone} [options.zone='local'] - the zone to place the DateTime into
   * @param {string} [options.locale] - a locale to set on the resulting DateTime instance
   * @param {string} options.outputCalendar - the output calendar to set on the resulting DateTime instance
   * @param {string} options.numberingSystem - the numbering system to set on the resulting DateTime instance
   * @param {string} options.weekSettings - the week settings to set on the resulting DateTime instance
   * @return {DateTime}
   */
  static fromSeconds(seconds, options = {}) {
    if (!isNumber(seconds)) {
      throw new InvalidArgumentError("fromSeconds requires a numerical input");
    } else {
      return new DateTime({
        ts: seconds * 1e3,
        zone: normalizeZone(options.zone, Settings.defaultZone),
        loc: Locale.fromObject(options)
      });
    }
  }
  /**
   * Create a DateTime from a JavaScript object with keys like 'year' and 'hour' with reasonable defaults.
   * @param {Object} obj - the object to create the DateTime from
   * @param {number} obj.year - a year, such as 1987
   * @param {number} obj.month - a month, 1-12
   * @param {number} obj.day - a day of the month, 1-31, depending on the month
   * @param {number} obj.ordinal - day of the year, 1-365 or 366
   * @param {number} obj.weekYear - an ISO week year
   * @param {number} obj.weekNumber - an ISO week number, between 1 and 52 or 53, depending on the year
   * @param {number} obj.weekday - an ISO weekday, 1-7, where 1 is Monday and 7 is Sunday
   * @param {number} obj.localWeekYear - a week year, according to the locale
   * @param {number} obj.localWeekNumber - a week number, between 1 and 52 or 53, depending on the year, according to the locale
   * @param {number} obj.localWeekday - a weekday, 1-7, where 1 is the first and 7 is the last day of the week, according to the locale
   * @param {number} obj.hour - hour of the day, 0-23
   * @param {number} obj.minute - minute of the hour, 0-59
   * @param {number} obj.second - second of the minute, 0-59
   * @param {number} obj.millisecond - millisecond of the second, 0-999
   * @param {Object} opts - options for creating this DateTime
   * @param {string|Zone} [opts.zone='local'] - interpret the numbers in the context of a particular zone. Can take any value taken as the first argument to setZone()
   * @param {string} [opts.locale='system\'s locale'] - a locale to set on the resulting DateTime instance
   * @param {string} opts.outputCalendar - the output calendar to set on the resulting DateTime instance
   * @param {string} opts.numberingSystem - the numbering system to set on the resulting DateTime instance
   * @param {string} opts.weekSettings - the week settings to set on the resulting DateTime instance
   * @example DateTime.fromObject({ year: 1982, month: 5, day: 25}).toISODate() //=> '1982-05-25'
   * @example DateTime.fromObject({ year: 1982 }).toISODate() //=> '1982-01-01'
   * @example DateTime.fromObject({ hour: 10, minute: 26, second: 6 }) //~> today at 10:26:06
   * @example DateTime.fromObject({ hour: 10, minute: 26, second: 6 }, { zone: 'utc' }),
   * @example DateTime.fromObject({ hour: 10, minute: 26, second: 6 }, { zone: 'local' })
   * @example DateTime.fromObject({ hour: 10, minute: 26, second: 6 }, { zone: 'America/New_York' })
   * @example DateTime.fromObject({ weekYear: 2016, weekNumber: 2, weekday: 3 }).toISODate() //=> '2016-01-13'
   * @example DateTime.fromObject({ localWeekYear: 2022, localWeekNumber: 1, localWeekday: 1 }, { locale: "en-US" }).toISODate() //=> '2021-12-26'
   * @return {DateTime}
   */
  static fromObject(obj, opts = {}) {
    obj = obj || {};
    const zoneToUse = normalizeZone(opts.zone, Settings.defaultZone);
    if (!zoneToUse.isValid) {
      return DateTime.invalid(unsupportedZone(zoneToUse));
    }
    const loc = Locale.fromObject(opts);
    const normalized = normalizeObject(obj, normalizeUnitWithLocalWeeks);
    const { minDaysInFirstWeek, startOfWeek } = usesLocalWeekValues(normalized, loc);
    const tsNow = Settings.now(), offsetProvis = !isUndefined(opts.specificOffset) ? opts.specificOffset : zoneToUse.offset(tsNow), containsOrdinal = !isUndefined(normalized.ordinal), containsGregorYear = !isUndefined(normalized.year), containsGregorMD = !isUndefined(normalized.month) || !isUndefined(normalized.day), containsGregor = containsGregorYear || containsGregorMD, definiteWeekDef = normalized.weekYear || normalized.weekNumber;
    if ((containsGregor || containsOrdinal) && definiteWeekDef) {
      throw new ConflictingSpecificationError(
        "Can't mix weekYear/weekNumber units with year/month/day or ordinals"
      );
    }
    if (containsGregorMD && containsOrdinal) {
      throw new ConflictingSpecificationError("Can't mix ordinal dates with month/day");
    }
    const useWeekData = definiteWeekDef || normalized.weekday && !containsGregor;
    let units, defaultValues, objNow = tsToObj(tsNow, offsetProvis);
    if (useWeekData) {
      units = orderedWeekUnits;
      defaultValues = defaultWeekUnitValues;
      objNow = gregorianToWeek(objNow, minDaysInFirstWeek, startOfWeek);
    } else if (containsOrdinal) {
      units = orderedOrdinalUnits;
      defaultValues = defaultOrdinalUnitValues;
      objNow = gregorianToOrdinal(objNow);
    } else {
      units = orderedUnits;
      defaultValues = defaultUnitValues;
    }
    let foundFirst = false;
    for (const u of units) {
      const v = normalized[u];
      if (!isUndefined(v)) {
        foundFirst = true;
      } else if (foundFirst) {
        normalized[u] = defaultValues[u];
      } else {
        normalized[u] = objNow[u];
      }
    }
    const higherOrderInvalid = useWeekData ? hasInvalidWeekData(normalized, minDaysInFirstWeek, startOfWeek) : containsOrdinal ? hasInvalidOrdinalData(normalized) : hasInvalidGregorianData(normalized), invalid = higherOrderInvalid || hasInvalidTimeData(normalized);
    if (invalid) {
      return DateTime.invalid(invalid);
    }
    const gregorian = useWeekData ? weekToGregorian(normalized, minDaysInFirstWeek, startOfWeek) : containsOrdinal ? ordinalToGregorian(normalized) : normalized, [tsFinal, offsetFinal] = objToTS(gregorian, offsetProvis, zoneToUse), inst = new DateTime({
      ts: tsFinal,
      zone: zoneToUse,
      o: offsetFinal,
      loc
    });
    if (normalized.weekday && containsGregor && obj.weekday !== inst.weekday) {
      return DateTime.invalid(
        "mismatched weekday",
        `you can't specify both a weekday of ${normalized.weekday} and a date of ${inst.toISO()}`
      );
    }
    if (!inst.isValid) {
      return DateTime.invalid(inst.invalid);
    }
    return inst;
  }
  /**
   * Create a DateTime from an ISO 8601 string
   * @param {string} text - the ISO string
   * @param {Object} opts - options to affect the creation
   * @param {string|Zone} [opts.zone='local'] - use this zone if no offset is specified in the input string itself. Will also convert the time to this zone
   * @param {boolean} [opts.setZone=false] - override the zone with a fixed-offset zone specified in the string itself, if it specifies one
   * @param {string} [opts.locale='system's locale'] - a locale to set on the resulting DateTime instance
   * @param {string} [opts.outputCalendar] - the output calendar to set on the resulting DateTime instance
   * @param {string} [opts.numberingSystem] - the numbering system to set on the resulting DateTime instance
   * @param {string} [opts.weekSettings] - the week settings to set on the resulting DateTime instance
   * @example DateTime.fromISO('2016-05-25T09:08:34.123')
   * @example DateTime.fromISO('2016-05-25T09:08:34.123+06:00')
   * @example DateTime.fromISO('2016-05-25T09:08:34.123+06:00', {setZone: true})
   * @example DateTime.fromISO('2016-05-25T09:08:34.123', {zone: 'utc'})
   * @example DateTime.fromISO('2016-W05-4')
   * @return {DateTime}
   */
  static fromISO(text, opts = {}) {
    const [vals, parsedZone] = parseISODate(text);
    return parseDataToDateTime(vals, parsedZone, opts, "ISO 8601", text);
  }
  /**
   * Create a DateTime from an RFC 2822 string
   * @param {string} text - the RFC 2822 string
   * @param {Object} opts - options to affect the creation
   * @param {string|Zone} [opts.zone='local'] - convert the time to this zone. Since the offset is always specified in the string itself, this has no effect on the interpretation of string, merely the zone the resulting DateTime is expressed in.
   * @param {boolean} [opts.setZone=false] - override the zone with a fixed-offset zone specified in the string itself, if it specifies one
   * @param {string} [opts.locale='system's locale'] - a locale to set on the resulting DateTime instance
   * @param {string} opts.outputCalendar - the output calendar to set on the resulting DateTime instance
   * @param {string} opts.numberingSystem - the numbering system to set on the resulting DateTime instance
   * @param {string} opts.weekSettings - the week settings to set on the resulting DateTime instance
   * @example DateTime.fromRFC2822('25 Nov 2016 13:23:12 GMT')
   * @example DateTime.fromRFC2822('Fri, 25 Nov 2016 13:23:12 +0600')
   * @example DateTime.fromRFC2822('25 Nov 2016 13:23 Z')
   * @return {DateTime}
   */
  static fromRFC2822(text, opts = {}) {
    const [vals, parsedZone] = parseRFC2822Date(text);
    return parseDataToDateTime(vals, parsedZone, opts, "RFC 2822", text);
  }
  /**
   * Create a DateTime from an HTTP header date
   * @see https://www.w3.org/Protocols/rfc2616/rfc2616-sec3.html#sec3.3.1
   * @param {string} text - the HTTP header date
   * @param {Object} opts - options to affect the creation
   * @param {string|Zone} [opts.zone='local'] - convert the time to this zone. Since HTTP dates are always in UTC, this has no effect on the interpretation of string, merely the zone the resulting DateTime is expressed in.
   * @param {boolean} [opts.setZone=false] - override the zone with the fixed-offset zone specified in the string. For HTTP dates, this is always UTC, so this option is equivalent to setting the `zone` option to 'utc', but this option is included for consistency with similar methods.
   * @param {string} [opts.locale='system's locale'] - a locale to set on the resulting DateTime instance
   * @param {string} opts.outputCalendar - the output calendar to set on the resulting DateTime instance
   * @param {string} opts.numberingSystem - the numbering system to set on the resulting DateTime instance
   * @param {string} opts.weekSettings - the week settings to set on the resulting DateTime instance
   * @example DateTime.fromHTTP('Sun, 06 Nov 1994 08:49:37 GMT')
   * @example DateTime.fromHTTP('Sunday, 06-Nov-94 08:49:37 GMT')
   * @example DateTime.fromHTTP('Sun Nov  6 08:49:37 1994')
   * @return {DateTime}
   */
  static fromHTTP(text, opts = {}) {
    const [vals, parsedZone] = parseHTTPDate(text);
    return parseDataToDateTime(vals, parsedZone, opts, "HTTP", opts);
  }
  /**
   * Create a DateTime from an input string and format string.
   * Defaults to en-US if no locale has been specified, regardless of the system's locale. For a table of tokens and their interpretations, see [here](https://moment.github.io/luxon/#/parsing?id=table-of-tokens).
   * @param {string} text - the string to parse
   * @param {string} fmt - the format the string is expected to be in (see the link below for the formats)
   * @param {Object} opts - options to affect the creation
   * @param {string|Zone} [opts.zone='local'] - use this zone if no offset is specified in the input string itself. Will also convert the DateTime to this zone
   * @param {boolean} [opts.setZone=false] - override the zone with a zone specified in the string itself, if it specifies one
   * @param {string} [opts.locale='en-US'] - a locale string to use when parsing. Will also set the DateTime to this locale
   * @param {string} opts.numberingSystem - the numbering system to use when parsing. Will also set the resulting DateTime to this numbering system
   * @param {string} opts.weekSettings - the week settings to set on the resulting DateTime instance
   * @param {string} opts.outputCalendar - the output calendar to set on the resulting DateTime instance
   * @return {DateTime}
   */
  static fromFormat(text, fmt, opts = {}) {
    if (isUndefined(text) || isUndefined(fmt)) {
      throw new InvalidArgumentError("fromFormat requires an input string and a format");
    }
    const { locale = null, numberingSystem = null } = opts, localeToUse = Locale.fromOpts({
      locale,
      numberingSystem,
      defaultToEN: true
    }), [vals, parsedZone, specificOffset, invalid] = parseFromTokens(localeToUse, text, fmt);
    if (invalid) {
      return DateTime.invalid(invalid);
    } else {
      return parseDataToDateTime(vals, parsedZone, opts, `format ${fmt}`, text, specificOffset);
    }
  }
  /**
   * @deprecated use fromFormat instead
   */
  static fromString(text, fmt, opts = {}) {
    return DateTime.fromFormat(text, fmt, opts);
  }
  /**
   * Create a DateTime from a SQL date, time, or datetime
   * Defaults to en-US if no locale has been specified, regardless of the system's locale
   * @param {string} text - the string to parse
   * @param {Object} opts - options to affect the creation
   * @param {string|Zone} [opts.zone='local'] - use this zone if no offset is specified in the input string itself. Will also convert the DateTime to this zone
   * @param {boolean} [opts.setZone=false] - override the zone with a zone specified in the string itself, if it specifies one
   * @param {string} [opts.locale='en-US'] - a locale string to use when parsing. Will also set the DateTime to this locale
   * @param {string} opts.numberingSystem - the numbering system to use when parsing. Will also set the resulting DateTime to this numbering system
   * @param {string} opts.weekSettings - the week settings to set on the resulting DateTime instance
   * @param {string} opts.outputCalendar - the output calendar to set on the resulting DateTime instance
   * @example DateTime.fromSQL('2017-05-15')
   * @example DateTime.fromSQL('2017-05-15 09:12:34')
   * @example DateTime.fromSQL('2017-05-15 09:12:34.342')
   * @example DateTime.fromSQL('2017-05-15 09:12:34.342+06:00')
   * @example DateTime.fromSQL('2017-05-15 09:12:34.342 America/Los_Angeles')
   * @example DateTime.fromSQL('2017-05-15 09:12:34.342 America/Los_Angeles', { setZone: true })
   * @example DateTime.fromSQL('2017-05-15 09:12:34.342', { zone: 'America/Los_Angeles' })
   * @example DateTime.fromSQL('09:12:34.342')
   * @return {DateTime}
   */
  static fromSQL(text, opts = {}) {
    const [vals, parsedZone] = parseSQL(text);
    return parseDataToDateTime(vals, parsedZone, opts, "SQL", text);
  }
  /**
   * Create an invalid DateTime.
   * @param {string} reason - simple string of why this DateTime is invalid. Should not contain parameters or anything else data-dependent.
   * @param {string} [explanation=null] - longer explanation, may include parameters and other useful debugging information
   * @return {DateTime}
   */
  static invalid(reason, explanation = null) {
    if (!reason) {
      throw new InvalidArgumentError("need to specify a reason the DateTime is invalid");
    }
    const invalid = reason instanceof Invalid ? reason : new Invalid(reason, explanation);
    if (Settings.throwOnInvalid) {
      throw new InvalidDateTimeError(invalid);
    } else {
      return new DateTime({ invalid });
    }
  }
  /**
   * Check if an object is an instance of DateTime. Works across context boundaries
   * @param {object} o
   * @return {boolean}
   */
  static isDateTime(o) {
    return o && o.isLuxonDateTime || false;
  }
  /**
   * Produce the format string for a set of options
   * @param formatOpts
   * @param localeOpts
   * @returns {string}
   */
  static parseFormatForOpts(formatOpts, localeOpts = {}) {
    const tokenList = formatOptsToTokens(formatOpts, Locale.fromObject(localeOpts));
    return !tokenList ? null : tokenList.map((t) => t ? t.val : null).join("");
  }
  /**
   * Produce the the fully expanded format token for the locale
   * Does NOT quote characters, so quoted tokens will not round trip correctly
   * @param fmt
   * @param localeOpts
   * @returns {string}
   */
  static expandFormat(fmt, localeOpts = {}) {
    const expanded = expandMacroTokens(Formatter.parseFormat(fmt), Locale.fromObject(localeOpts));
    return expanded.map((t) => t.val).join("");
  }
  static resetCache() {
    zoneOffsetTs = void 0;
    zoneOffsetGuessCache = {};
  }
  // INFO
  /**
   * Get the value of unit.
   * @param {string} unit - a unit such as 'minute' or 'day'
   * @example DateTime.local(2017, 7, 4).get('month'); //=> 7
   * @example DateTime.local(2017, 7, 4).get('day'); //=> 4
   * @return {number}
   */
  get(unit) {
    return this[unit];
  }
  /**
   * Returns whether the DateTime is valid. Invalid DateTimes occur when:
   * * The DateTime was created from invalid calendar information, such as the 13th month or February 30
   * * The DateTime was created by an operation on another invalid date
   * @type {boolean}
   */
  get isValid() {
    return this.invalid === null;
  }
  /**
   * Returns an error code if this DateTime is invalid, or null if the DateTime is valid
   * @type {string}
   */
  get invalidReason() {
    return this.invalid ? this.invalid.reason : null;
  }
  /**
   * Returns an explanation of why this DateTime became invalid, or null if the DateTime is valid
   * @type {string}
   */
  get invalidExplanation() {
    return this.invalid ? this.invalid.explanation : null;
  }
  /**
   * Get the locale of a DateTime, such 'en-GB'. The locale is used when formatting the DateTime
   *
   * @type {string}
   */
  get locale() {
    return this.isValid ? this.loc.locale : null;
  }
  /**
   * Get the numbering system of a DateTime, such 'beng'. The numbering system is used when formatting the DateTime
   *
   * @type {string}
   */
  get numberingSystem() {
    return this.isValid ? this.loc.numberingSystem : null;
  }
  /**
   * Get the output calendar of a DateTime, such 'islamic'. The output calendar is used when formatting the DateTime
   *
   * @type {string}
   */
  get outputCalendar() {
    return this.isValid ? this.loc.outputCalendar : null;
  }
  /**
   * Get the time zone associated with this DateTime.
   * @type {Zone}
   */
  get zone() {
    return this._zone;
  }
  /**
   * Get the name of the time zone.
   * @type {string}
   */
  get zoneName() {
    return this.isValid ? this.zone.name : null;
  }
  /**
   * Get the year
   * @example DateTime.local(2017, 5, 25).year //=> 2017
   * @type {number}
   */
  get year() {
    return this.isValid ? this.c.year : NaN;
  }
  /**
   * Get the quarter
   * @example DateTime.local(2017, 5, 25).quarter //=> 2
   * @type {number}
   */
  get quarter() {
    return this.isValid ? Math.ceil(this.c.month / 3) : NaN;
  }
  /**
   * Get the month (1-12).
   * @example DateTime.local(2017, 5, 25).month //=> 5
   * @type {number}
   */
  get month() {
    return this.isValid ? this.c.month : NaN;
  }
  /**
   * Get the day of the month (1-30ish).
   * @example DateTime.local(2017, 5, 25).day //=> 25
   * @type {number}
   */
  get day() {
    return this.isValid ? this.c.day : NaN;
  }
  /**
   * Get the hour of the day (0-23).
   * @example DateTime.local(2017, 5, 25, 9).hour //=> 9
   * @type {number}
   */
  get hour() {
    return this.isValid ? this.c.hour : NaN;
  }
  /**
   * Get the minute of the hour (0-59).
   * @example DateTime.local(2017, 5, 25, 9, 30).minute //=> 30
   * @type {number}
   */
  get minute() {
    return this.isValid ? this.c.minute : NaN;
  }
  /**
   * Get the second of the minute (0-59).
   * @example DateTime.local(2017, 5, 25, 9, 30, 52).second //=> 52
   * @type {number}
   */
  get second() {
    return this.isValid ? this.c.second : NaN;
  }
  /**
   * Get the millisecond of the second (0-999).
   * @example DateTime.local(2017, 5, 25, 9, 30, 52, 654).millisecond //=> 654
   * @type {number}
   */
  get millisecond() {
    return this.isValid ? this.c.millisecond : NaN;
  }
  /**
   * Get the week year
   * @see https://en.wikipedia.org/wiki/ISO_week_date
   * @example DateTime.local(2014, 12, 31).weekYear //=> 2015
   * @type {number}
   */
  get weekYear() {
    return this.isValid ? possiblyCachedWeekData(this).weekYear : NaN;
  }
  /**
   * Get the week number of the week year (1-52ish).
   * @see https://en.wikipedia.org/wiki/ISO_week_date
   * @example DateTime.local(2017, 5, 25).weekNumber //=> 21
   * @type {number}
   */
  get weekNumber() {
    return this.isValid ? possiblyCachedWeekData(this).weekNumber : NaN;
  }
  /**
   * Get the day of the week.
   * 1 is Monday and 7 is Sunday
   * @see https://en.wikipedia.org/wiki/ISO_week_date
   * @example DateTime.local(2014, 11, 31).weekday //=> 4
   * @type {number}
   */
  get weekday() {
    return this.isValid ? possiblyCachedWeekData(this).weekday : NaN;
  }
  /**
   * Returns true if this date is on a weekend according to the locale, false otherwise
   * @returns {boolean}
   */
  get isWeekend() {
    return this.isValid && this.loc.getWeekendDays().includes(this.weekday);
  }
  /**
   * Get the day of the week according to the locale.
   * 1 is the first day of the week and 7 is the last day of the week.
   * If the locale assigns Sunday as the first day of the week, then a date which is a Sunday will return 1,
   * @returns {number}
   */
  get localWeekday() {
    return this.isValid ? possiblyCachedLocalWeekData(this).weekday : NaN;
  }
  /**
   * Get the week number of the week year according to the locale. Different locales assign week numbers differently,
   * because the week can start on different days of the week (see localWeekday) and because a different number of days
   * is required for a week to count as the first week of a year.
   * @returns {number}
   */
  get localWeekNumber() {
    return this.isValid ? possiblyCachedLocalWeekData(this).weekNumber : NaN;
  }
  /**
   * Get the week year according to the locale. Different locales assign week numbers (and therefor week years)
   * differently, see localWeekNumber.
   * @returns {number}
   */
  get localWeekYear() {
    return this.isValid ? possiblyCachedLocalWeekData(this).weekYear : NaN;
  }
  /**
   * Get the ordinal (meaning the day of the year)
   * @example DateTime.local(2017, 5, 25).ordinal //=> 145
   * @type {number|DateTime}
   */
  get ordinal() {
    return this.isValid ? gregorianToOrdinal(this.c).ordinal : NaN;
  }
  /**
   * Get the human readable short month name, such as 'Oct'.
   * Defaults to the system's locale if no locale has been specified
   * @example DateTime.local(2017, 10, 30).monthShort //=> Oct
   * @type {string}
   */
  get monthShort() {
    return this.isValid ? Info.months("short", { locObj: this.loc })[this.month - 1] : null;
  }
  /**
   * Get the human readable long month name, such as 'October'.
   * Defaults to the system's locale if no locale has been specified
   * @example DateTime.local(2017, 10, 30).monthLong //=> October
   * @type {string}
   */
  get monthLong() {
    return this.isValid ? Info.months("long", { locObj: this.loc })[this.month - 1] : null;
  }
  /**
   * Get the human readable short weekday, such as 'Mon'.
   * Defaults to the system's locale if no locale has been specified
   * @example DateTime.local(2017, 10, 30).weekdayShort //=> Mon
   * @type {string}
   */
  get weekdayShort() {
    return this.isValid ? Info.weekdays("short", { locObj: this.loc })[this.weekday - 1] : null;
  }
  /**
   * Get the human readable long weekday, such as 'Monday'.
   * Defaults to the system's locale if no locale has been specified
   * @example DateTime.local(2017, 10, 30).weekdayLong //=> Monday
   * @type {string}
   */
  get weekdayLong() {
    return this.isValid ? Info.weekdays("long", { locObj: this.loc })[this.weekday - 1] : null;
  }
  /**
   * Get the UTC offset of this DateTime in minutes
   * @example DateTime.now().offset //=> -240
   * @example DateTime.utc().offset //=> 0
   * @type {number}
   */
  get offset() {
    return this.isValid ? +this.o : NaN;
  }
  /**
   * Get the short human name for the zone's current offset, for example "EST" or "EDT".
   * Defaults to the system's locale if no locale has been specified
   * @type {string}
   */
  get offsetNameShort() {
    if (this.isValid) {
      return this.zone.offsetName(this.ts, {
        format: "short",
        locale: this.locale
      });
    } else {
      return null;
    }
  }
  /**
   * Get the long human name for the zone's current offset, for example "Eastern Standard Time" or "Eastern Daylight Time".
   * Defaults to the system's locale if no locale has been specified
   * @type {string}
   */
  get offsetNameLong() {
    if (this.isValid) {
      return this.zone.offsetName(this.ts, {
        format: "long",
        locale: this.locale
      });
    } else {
      return null;
    }
  }
  /**
   * Get whether this zone's offset ever changes, as in a DST.
   * @type {boolean}
   */
  get isOffsetFixed() {
    return this.isValid ? this.zone.isUniversal : null;
  }
  /**
   * Get whether the DateTime is in a DST.
   * @type {boolean}
   */
  get isInDST() {
    if (this.isOffsetFixed) {
      return false;
    } else {
      return this.offset > this.set({ month: 1, day: 1 }).offset || this.offset > this.set({ month: 5 }).offset;
    }
  }
  /**
   * Get those DateTimes which have the same local time as this DateTime, but a different offset from UTC
   * in this DateTime's zone. During DST changes local time can be ambiguous, for example
   * `2023-10-29T02:30:00` in `Europe/Berlin` can have offset `+01:00` or `+02:00`.
   * This method will return both possible DateTimes if this DateTime's local time is ambiguous.
   * @returns {DateTime[]}
   */
  getPossibleOffsets() {
    if (!this.isValid || this.isOffsetFixed) {
      return [this];
    }
    const dayMs = 864e5;
    const minuteMs = 6e4;
    const localTS = objToLocalTS(this.c);
    const oEarlier = this.zone.offset(localTS - dayMs);
    const oLater = this.zone.offset(localTS + dayMs);
    const o1 = this.zone.offset(localTS - oEarlier * minuteMs);
    const o2 = this.zone.offset(localTS - oLater * minuteMs);
    if (o1 === o2) {
      return [this];
    }
    const ts1 = localTS - o1 * minuteMs;
    const ts2 = localTS - o2 * minuteMs;
    const c1 = tsToObj(ts1, o1);
    const c2 = tsToObj(ts2, o2);
    if (c1.hour === c2.hour && c1.minute === c2.minute && c1.second === c2.second && c1.millisecond === c2.millisecond) {
      return [clone(this, { ts: ts1 }), clone(this, { ts: ts2 })];
    }
    return [this];
  }
  /**
   * Returns true if this DateTime is in a leap year, false otherwise
   * @example DateTime.local(2016).isInLeapYear //=> true
   * @example DateTime.local(2013).isInLeapYear //=> false
   * @type {boolean}
   */
  get isInLeapYear() {
    return isLeapYear(this.year);
  }
  /**
   * Returns the number of days in this DateTime's month
   * @example DateTime.local(2016, 2).daysInMonth //=> 29
   * @example DateTime.local(2016, 3).daysInMonth //=> 31
   * @type {number}
   */
  get daysInMonth() {
    return daysInMonth(this.year, this.month);
  }
  /**
   * Returns the number of days in this DateTime's year
   * @example DateTime.local(2016).daysInYear //=> 366
   * @example DateTime.local(2013).daysInYear //=> 365
   * @type {number}
   */
  get daysInYear() {
    return this.isValid ? daysInYear(this.year) : NaN;
  }
  /**
   * Returns the number of weeks in this DateTime's year
   * @see https://en.wikipedia.org/wiki/ISO_week_date
   * @example DateTime.local(2004).weeksInWeekYear //=> 53
   * @example DateTime.local(2013).weeksInWeekYear //=> 52
   * @type {number}
   */
  get weeksInWeekYear() {
    return this.isValid ? weeksInWeekYear(this.weekYear) : NaN;
  }
  /**
   * Returns the number of weeks in this DateTime's local week year
   * @example DateTime.local(2020, 6, {locale: 'en-US'}).weeksInLocalWeekYear //=> 52
   * @example DateTime.local(2020, 6, {locale: 'de-DE'}).weeksInLocalWeekYear //=> 53
   * @type {number}
   */
  get weeksInLocalWeekYear() {
    return this.isValid ? weeksInWeekYear(
      this.localWeekYear,
      this.loc.getMinDaysInFirstWeek(),
      this.loc.getStartOfWeek()
    ) : NaN;
  }
  /**
   * Returns the resolved Intl options for this DateTime.
   * This is useful in understanding the behavior of formatting methods
   * @param {Object} opts - the same options as toLocaleString
   * @return {Object}
   */
  resolvedLocaleOptions(opts = {}) {
    const { locale, numberingSystem, calendar } = Formatter.create(
      this.loc.clone(opts),
      opts
    ).resolvedOptions(this);
    return { locale, numberingSystem, outputCalendar: calendar };
  }
  // TRANSFORM
  /**
   * "Set" the DateTime's zone to UTC. Returns a newly-constructed DateTime.
   *
   * Equivalent to {@link DateTime#setZone}('utc')
   * @param {number} [offset=0] - optionally, an offset from UTC in minutes
   * @param {Object} [opts={}] - options to pass to `setZone()`
   * @return {DateTime}
   */
  toUTC(offset2 = 0, opts = {}) {
    return this.setZone(FixedOffsetZone.instance(offset2), opts);
  }
  /**
   * "Set" the DateTime's zone to the host's local zone. Returns a newly-constructed DateTime.
   *
   * Equivalent to `setZone('local')`
   * @return {DateTime}
   */
  toLocal() {
    return this.setZone(Settings.defaultZone);
  }
  /**
   * "Set" the DateTime's zone to specified zone. Returns a newly-constructed DateTime.
   *
   * By default, the setter keeps the underlying time the same (as in, the same timestamp), but the new instance will report different local times and consider DSTs when making computations, as with {@link DateTime#plus}. You may wish to use {@link DateTime#toLocal} and {@link DateTime#toUTC} which provide simple convenience wrappers for commonly used zones.
   * @param {string|Zone} [zone='local'] - a zone identifier. As a string, that can be any IANA zone supported by the host environment, or a fixed-offset name of the form 'UTC+3', or the strings 'local' or 'utc'. You may also supply an instance of a {@link DateTime#Zone} class.
   * @param {Object} opts - options
   * @param {boolean} [opts.keepLocalTime=false] - If true, adjust the underlying time so that the local time stays the same, but in the target zone. You should rarely need this.
   * @return {DateTime}
   */
  setZone(zone, { keepLocalTime = false, keepCalendarTime = false } = {}) {
    zone = normalizeZone(zone, Settings.defaultZone);
    if (zone.equals(this.zone)) {
      return this;
    } else if (!zone.isValid) {
      return DateTime.invalid(unsupportedZone(zone));
    } else {
      let newTS = this.ts;
      if (keepLocalTime || keepCalendarTime) {
        const offsetGuess = zone.offset(this.ts);
        const asObj = this.toObject();
        [newTS] = objToTS(asObj, offsetGuess, zone);
      }
      return clone(this, { ts: newTS, zone });
    }
  }
  /**
   * "Set" the locale, numberingSystem, or outputCalendar. Returns a newly-constructed DateTime.
   * @param {Object} properties - the properties to set
   * @example DateTime.local(2017, 5, 25).reconfigure({ locale: 'en-GB' })
   * @return {DateTime}
   */
  reconfigure({ locale, numberingSystem, outputCalendar } = {}) {
    const loc = this.loc.clone({ locale, numberingSystem, outputCalendar });
    return clone(this, { loc });
  }
  /**
   * "Set" the locale. Returns a newly-constructed DateTime.
   * Just a convenient alias for reconfigure({ locale })
   * @example DateTime.local(2017, 5, 25).setLocale('en-GB')
   * @return {DateTime}
   */
  setLocale(locale) {
    return this.reconfigure({ locale });
  }
  /**
   * "Set" the values of specified units. Returns a newly-constructed DateTime.
   * You can only set units with this method; for "setting" metadata, see {@link DateTime#reconfigure} and {@link DateTime#setZone}.
   *
   * This method also supports setting locale-based week units, i.e. `localWeekday`, `localWeekNumber` and `localWeekYear`.
   * They cannot be mixed with ISO-week units like `weekday`.
   * @param {Object} values - a mapping of units to numbers
   * @example dt.set({ year: 2017 })
   * @example dt.set({ hour: 8, minute: 30 })
   * @example dt.set({ weekday: 5 })
   * @example dt.set({ year: 2005, ordinal: 234 })
   * @return {DateTime}
   */
  set(values) {
    if (!this.isValid) return this;
    const normalized = normalizeObject(values, normalizeUnitWithLocalWeeks);
    const { minDaysInFirstWeek, startOfWeek } = usesLocalWeekValues(normalized, this.loc);
    const settingWeekStuff = !isUndefined(normalized.weekYear) || !isUndefined(normalized.weekNumber) || !isUndefined(normalized.weekday), containsOrdinal = !isUndefined(normalized.ordinal), containsGregorYear = !isUndefined(normalized.year), containsGregorMD = !isUndefined(normalized.month) || !isUndefined(normalized.day), containsGregor = containsGregorYear || containsGregorMD, definiteWeekDef = normalized.weekYear || normalized.weekNumber;
    if ((containsGregor || containsOrdinal) && definiteWeekDef) {
      throw new ConflictingSpecificationError(
        "Can't mix weekYear/weekNumber units with year/month/day or ordinals"
      );
    }
    if (containsGregorMD && containsOrdinal) {
      throw new ConflictingSpecificationError("Can't mix ordinal dates with month/day");
    }
    let mixed;
    if (settingWeekStuff) {
      mixed = weekToGregorian(
        { ...gregorianToWeek(this.c, minDaysInFirstWeek, startOfWeek), ...normalized },
        minDaysInFirstWeek,
        startOfWeek
      );
    } else if (!isUndefined(normalized.ordinal)) {
      mixed = ordinalToGregorian({ ...gregorianToOrdinal(this.c), ...normalized });
    } else {
      mixed = { ...this.toObject(), ...normalized };
      if (isUndefined(normalized.day)) {
        mixed.day = Math.min(daysInMonth(mixed.year, mixed.month), mixed.day);
      }
    }
    const [ts, o] = objToTS(mixed, this.o, this.zone);
    return clone(this, { ts, o });
  }
  /**
   * Add a period of time to this DateTime and return the resulting DateTime
   *
   * Adding hours, minutes, seconds, or milliseconds increases the timestamp by the right number of milliseconds. Adding days, months, or years shifts the calendar, accounting for DSTs and leap years along the way. Thus, `dt.plus({ hours: 24 })` may result in a different time than `dt.plus({ days: 1 })` if there's a DST shift in between.
   * @param {Duration|Object|number} duration - The amount to add. Either a Luxon Duration, a number of milliseconds, the object argument to Duration.fromObject()
   * @example DateTime.now().plus(123) //~> in 123 milliseconds
   * @example DateTime.now().plus({ minutes: 15 }) //~> in 15 minutes
   * @example DateTime.now().plus({ days: 1 }) //~> this time tomorrow
   * @example DateTime.now().plus({ days: -1 }) //~> this time yesterday
   * @example DateTime.now().plus({ hours: 3, minutes: 13 }) //~> in 3 hr, 13 min
   * @example DateTime.now().plus(Duration.fromObject({ hours: 3, minutes: 13 })) //~> in 3 hr, 13 min
   * @return {DateTime}
   */
  plus(duration) {
    if (!this.isValid) return this;
    const dur = Duration.fromDurationLike(duration);
    return clone(this, adjustTime(this, dur));
  }
  /**
   * Subtract a period of time to this DateTime and return the resulting DateTime
   * See {@link DateTime#plus}
   * @param {Duration|Object|number} duration - The amount to subtract. Either a Luxon Duration, a number of milliseconds, the object argument to Duration.fromObject()
   @return {DateTime}
   */
  minus(duration) {
    if (!this.isValid) return this;
    const dur = Duration.fromDurationLike(duration).negate();
    return clone(this, adjustTime(this, dur));
  }
  /**
   * "Set" this DateTime to the beginning of a unit of time.
   * @param {string} unit - The unit to go to the beginning of. Can be 'year', 'quarter', 'month', 'week', 'day', 'hour', 'minute', 'second', or 'millisecond'.
   * @param {Object} opts - options
   * @param {boolean} [opts.useLocaleWeeks=false] - If true, use weeks based on the locale, i.e. use the locale-dependent start of the week
   * @example DateTime.local(2014, 3, 3).startOf('month').toISODate(); //=> '2014-03-01'
   * @example DateTime.local(2014, 3, 3).startOf('year').toISODate(); //=> '2014-01-01'
   * @example DateTime.local(2014, 3, 3).startOf('week').toISODate(); //=> '2014-03-03', weeks always start on Mondays
   * @example DateTime.local(2014, 3, 3, 5, 30).startOf('day').toISOTime(); //=> '00:00.000-05:00'
   * @example DateTime.local(2014, 3, 3, 5, 30).startOf('hour').toISOTime(); //=> '05:00:00.000-05:00'
   * @return {DateTime}
   */
  startOf(unit, { useLocaleWeeks = false } = {}) {
    if (!this.isValid) return this;
    const o = {}, normalizedUnit = Duration.normalizeUnit(unit);
    switch (normalizedUnit) {
      case "years":
        o.month = 1;
      case "quarters":
      case "months":
        o.day = 1;
      case "weeks":
      case "days":
        o.hour = 0;
      case "hours":
        o.minute = 0;
      case "minutes":
        o.second = 0;
      case "seconds":
        o.millisecond = 0;
        break;
    }
    if (normalizedUnit === "weeks") {
      if (useLocaleWeeks) {
        const startOfWeek = this.loc.getStartOfWeek();
        const { weekday } = this;
        if (weekday < startOfWeek) {
          o.weekNumber = this.weekNumber - 1;
        }
        o.weekday = startOfWeek;
      } else {
        o.weekday = 1;
      }
    }
    if (normalizedUnit === "quarters") {
      const q = Math.ceil(this.month / 3);
      o.month = (q - 1) * 3 + 1;
    }
    return this.set(o);
  }
  /**
   * "Set" this DateTime to the end (meaning the last millisecond) of a unit of time
   * @param {string} unit - The unit to go to the end of. Can be 'year', 'quarter', 'month', 'week', 'day', 'hour', 'minute', 'second', or 'millisecond'.
   * @param {Object} opts - options
   * @param {boolean} [opts.useLocaleWeeks=false] - If true, use weeks based on the locale, i.e. use the locale-dependent start of the week
   * @example DateTime.local(2014, 3, 3).endOf('month').toISO(); //=> '2014-03-31T23:59:59.999-05:00'
   * @example DateTime.local(2014, 3, 3).endOf('year').toISO(); //=> '2014-12-31T23:59:59.999-05:00'
   * @example DateTime.local(2014, 3, 3).endOf('week').toISO(); // => '2014-03-09T23:59:59.999-05:00', weeks start on Mondays
   * @example DateTime.local(2014, 3, 3, 5, 30).endOf('day').toISO(); //=> '2014-03-03T23:59:59.999-05:00'
   * @example DateTime.local(2014, 3, 3, 5, 30).endOf('hour').toISO(); //=> '2014-03-03T05:59:59.999-05:00'
   * @return {DateTime}
   */
  endOf(unit, opts) {
    return this.isValid ? this.plus({ [unit]: 1 }).startOf(unit, opts).minus(1) : this;
  }
  // OUTPUT
  /**
   * Returns a string representation of this DateTime formatted according to the specified format string.
   * **You may not want this.** See {@link DateTime#toLocaleString} for a more flexible formatting tool. For a table of tokens and their interpretations, see [here](https://moment.github.io/luxon/#/formatting?id=table-of-tokens).
   * Defaults to en-US if no locale has been specified, regardless of the system's locale.
   * @param {string} fmt - the format string
   * @param {Object} opts - opts to override the configuration options on this DateTime
   * @example DateTime.now().toFormat('yyyy LLL dd') //=> '2017 Apr 22'
   * @example DateTime.now().setLocale('fr').toFormat('yyyy LLL dd') //=> '2017 avr. 22'
   * @example DateTime.now().toFormat('yyyy LLL dd', { locale: "fr" }) //=> '2017 avr. 22'
   * @example DateTime.now().toFormat("HH 'hours and' mm 'minutes'") //=> '20 hours and 55 minutes'
   * @return {string}
   */
  toFormat(fmt, opts = {}) {
    return this.isValid ? Formatter.create(this.loc.redefaultToEN(opts)).formatDateTimeFromString(this, fmt) : INVALID;
  }
  /**
   * Returns a localized string representing this date. Accepts the same options as the Intl.DateTimeFormat constructor and any presets defined by Luxon, such as `DateTime.DATE_FULL` or `DateTime.TIME_SIMPLE`.
   * The exact behavior of this method is browser-specific, but in general it will return an appropriate representation
   * of the DateTime in the assigned locale.
   * Defaults to the system's locale if no locale has been specified
   * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/DateTimeFormat
   * @param formatOpts {Object} - Intl.DateTimeFormat constructor options and configuration options
   * @param {Object} opts - opts to override the configuration options on this DateTime
   * @example DateTime.now().toLocaleString(); //=> 4/20/2017
   * @example DateTime.now().setLocale('en-gb').toLocaleString(); //=> '20/04/2017'
   * @example DateTime.now().toLocaleString(DateTime.DATE_FULL); //=> 'April 20, 2017'
   * @example DateTime.now().toLocaleString(DateTime.DATE_FULL, { locale: 'fr' }); //=> '28 août 2022'
   * @example DateTime.now().toLocaleString(DateTime.TIME_SIMPLE); //=> '11:32 AM'
   * @example DateTime.now().toLocaleString(DateTime.DATETIME_SHORT); //=> '4/20/2017, 11:32 AM'
   * @example DateTime.now().toLocaleString({ weekday: 'long', month: 'long', day: '2-digit' }); //=> 'Thursday, April 20'
   * @example DateTime.now().toLocaleString({ weekday: 'short', month: 'short', day: '2-digit', hour: '2-digit', minute: '2-digit' }); //=> 'Thu, Apr 20, 11:27 AM'
   * @example DateTime.now().toLocaleString({ hour: '2-digit', minute: '2-digit', hourCycle: 'h23' }); //=> '11:32'
   * @return {string}
   */
  toLocaleString(formatOpts = DATE_SHORT, opts = {}) {
    return this.isValid ? Formatter.create(this.loc.clone(opts), formatOpts).formatDateTime(this) : INVALID;
  }
  /**
   * Returns an array of format "parts", meaning individual tokens along with metadata. This is allows callers to post-process individual sections of the formatted output.
   * Defaults to the system's locale if no locale has been specified
   * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/DateTimeFormat/formatToParts
   * @param opts {Object} - Intl.DateTimeFormat constructor options, same as `toLocaleString`.
   * @example DateTime.now().toLocaleParts(); //=> [
   *                                   //=>   { type: 'day', value: '25' },
   *                                   //=>   { type: 'literal', value: '/' },
   *                                   //=>   { type: 'month', value: '05' },
   *                                   //=>   { type: 'literal', value: '/' },
   *                                   //=>   { type: 'year', value: '1982' }
   *                                   //=> ]
   */
  toLocaleParts(opts = {}) {
    return this.isValid ? Formatter.create(this.loc.clone(opts), opts).formatDateTimeParts(this) : [];
  }
  /**
   * Returns an ISO 8601-compliant string representation of this DateTime
   * @param {Object} opts - options
   * @param {boolean} [opts.suppressMilliseconds=false] - exclude milliseconds from the format if they're 0
   * @param {boolean} [opts.suppressSeconds=false] - exclude seconds from the format if they're 0
   * @param {boolean} [opts.includeOffset=true] - include the offset, such as 'Z' or '-04:00'
   * @param {boolean} [opts.extendedZone=false] - add the time zone format extension
   * @param {string} [opts.format='extended'] - choose between the basic and extended format
   * @example DateTime.utc(1983, 5, 25).toISO() //=> '1982-05-25T00:00:00.000Z'
   * @example DateTime.now().toISO() //=> '2017-04-22T20:47:05.335-04:00'
   * @example DateTime.now().toISO({ includeOffset: false }) //=> '2017-04-22T20:47:05.335'
   * @example DateTime.now().toISO({ format: 'basic' }) //=> '20170422T204705.335-0400'
   * @return {string}
   */
  toISO({
    format = "extended",
    suppressSeconds = false,
    suppressMilliseconds = false,
    includeOffset = true,
    extendedZone = false
  } = {}) {
    if (!this.isValid) {
      return null;
    }
    const ext = format === "extended";
    let c = toISODate(this, ext);
    c += "T";
    c += toISOTime(this, ext, suppressSeconds, suppressMilliseconds, includeOffset, extendedZone);
    return c;
  }
  /**
   * Returns an ISO 8601-compliant string representation of this DateTime's date component
   * @param {Object} opts - options
   * @param {string} [opts.format='extended'] - choose between the basic and extended format
   * @example DateTime.utc(1982, 5, 25).toISODate() //=> '1982-05-25'
   * @example DateTime.utc(1982, 5, 25).toISODate({ format: 'basic' }) //=> '19820525'
   * @return {string}
   */
  toISODate({ format = "extended" } = {}) {
    if (!this.isValid) {
      return null;
    }
    return toISODate(this, format === "extended");
  }
  /**
   * Returns an ISO 8601-compliant string representation of this DateTime's week date
   * @example DateTime.utc(1982, 5, 25).toISOWeekDate() //=> '1982-W21-2'
   * @return {string}
   */
  toISOWeekDate() {
    return toTechFormat(this, "kkkk-'W'WW-c");
  }
  /**
   * Returns an ISO 8601-compliant string representation of this DateTime's time component
   * @param {Object} opts - options
   * @param {boolean} [opts.suppressMilliseconds=false] - exclude milliseconds from the format if they're 0
   * @param {boolean} [opts.suppressSeconds=false] - exclude seconds from the format if they're 0
   * @param {boolean} [opts.includeOffset=true] - include the offset, such as 'Z' or '-04:00'
   * @param {boolean} [opts.extendedZone=true] - add the time zone format extension
   * @param {boolean} [opts.includePrefix=false] - include the `T` prefix
   * @param {string} [opts.format='extended'] - choose between the basic and extended format
   * @example DateTime.utc().set({ hour: 7, minute: 34 }).toISOTime() //=> '07:34:19.361Z'
   * @example DateTime.utc().set({ hour: 7, minute: 34, seconds: 0, milliseconds: 0 }).toISOTime({ suppressSeconds: true }) //=> '07:34Z'
   * @example DateTime.utc().set({ hour: 7, minute: 34 }).toISOTime({ format: 'basic' }) //=> '073419.361Z'
   * @example DateTime.utc().set({ hour: 7, minute: 34 }).toISOTime({ includePrefix: true }) //=> 'T07:34:19.361Z'
   * @return {string}
   */
  toISOTime({
    suppressMilliseconds = false,
    suppressSeconds = false,
    includeOffset = true,
    includePrefix = false,
    extendedZone = false,
    format = "extended"
  } = {}) {
    if (!this.isValid) {
      return null;
    }
    let c = includePrefix ? "T" : "";
    return c + toISOTime(
      this,
      format === "extended",
      suppressSeconds,
      suppressMilliseconds,
      includeOffset,
      extendedZone
    );
  }
  /**
   * Returns an RFC 2822-compatible string representation of this DateTime
   * @example DateTime.utc(2014, 7, 13).toRFC2822() //=> 'Sun, 13 Jul 2014 00:00:00 +0000'
   * @example DateTime.local(2014, 7, 13).toRFC2822() //=> 'Sun, 13 Jul 2014 00:00:00 -0400'
   * @return {string}
   */
  toRFC2822() {
    return toTechFormat(this, "EEE, dd LLL yyyy HH:mm:ss ZZZ", false);
  }
  /**
   * Returns a string representation of this DateTime appropriate for use in HTTP headers. The output is always expressed in GMT.
   * Specifically, the string conforms to RFC 1123.
   * @see https://www.w3.org/Protocols/rfc2616/rfc2616-sec3.html#sec3.3.1
   * @example DateTime.utc(2014, 7, 13).toHTTP() //=> 'Sun, 13 Jul 2014 00:00:00 GMT'
   * @example DateTime.utc(2014, 7, 13, 19).toHTTP() //=> 'Sun, 13 Jul 2014 19:00:00 GMT'
   * @return {string}
   */
  toHTTP() {
    return toTechFormat(this.toUTC(), "EEE, dd LLL yyyy HH:mm:ss 'GMT'");
  }
  /**
   * Returns a string representation of this DateTime appropriate for use in SQL Date
   * @example DateTime.utc(2014, 7, 13).toSQLDate() //=> '2014-07-13'
   * @return {string}
   */
  toSQLDate() {
    if (!this.isValid) {
      return null;
    }
    return toISODate(this, true);
  }
  /**
   * Returns a string representation of this DateTime appropriate for use in SQL Time
   * @param {Object} opts - options
   * @param {boolean} [opts.includeZone=false] - include the zone, such as 'America/New_York'. Overrides includeOffset.
   * @param {boolean} [opts.includeOffset=true] - include the offset, such as 'Z' or '-04:00'
   * @param {boolean} [opts.includeOffsetSpace=true] - include the space between the time and the offset, such as '05:15:16.345 -04:00'
   * @example DateTime.utc().toSQL() //=> '05:15:16.345'
   * @example DateTime.now().toSQL() //=> '05:15:16.345 -04:00'
   * @example DateTime.now().toSQL({ includeOffset: false }) //=> '05:15:16.345'
   * @example DateTime.now().toSQL({ includeZone: false }) //=> '05:15:16.345 America/New_York'
   * @return {string}
   */
  toSQLTime({ includeOffset = true, includeZone = false, includeOffsetSpace = true } = {}) {
    let fmt = "HH:mm:ss.SSS";
    if (includeZone || includeOffset) {
      if (includeOffsetSpace) {
        fmt += " ";
      }
      if (includeZone) {
        fmt += "z";
      } else if (includeOffset) {
        fmt += "ZZ";
      }
    }
    return toTechFormat(this, fmt, true);
  }
  /**
   * Returns a string representation of this DateTime appropriate for use in SQL DateTime
   * @param {Object} opts - options
   * @param {boolean} [opts.includeZone=false] - include the zone, such as 'America/New_York'. Overrides includeOffset.
   * @param {boolean} [opts.includeOffset=true] - include the offset, such as 'Z' or '-04:00'
   * @param {boolean} [opts.includeOffsetSpace=true] - include the space between the time and the offset, such as '05:15:16.345 -04:00'
   * @example DateTime.utc(2014, 7, 13).toSQL() //=> '2014-07-13 00:00:00.000 Z'
   * @example DateTime.local(2014, 7, 13).toSQL() //=> '2014-07-13 00:00:00.000 -04:00'
   * @example DateTime.local(2014, 7, 13).toSQL({ includeOffset: false }) //=> '2014-07-13 00:00:00.000'
   * @example DateTime.local(2014, 7, 13).toSQL({ includeZone: true }) //=> '2014-07-13 00:00:00.000 America/New_York'
   * @return {string}
   */
  toSQL(opts = {}) {
    if (!this.isValid) {
      return null;
    }
    return `${this.toSQLDate()} ${this.toSQLTime(opts)}`;
  }
  /**
   * Returns a string representation of this DateTime appropriate for debugging
   * @return {string}
   */
  toString() {
    return this.isValid ? this.toISO() : INVALID;
  }
  /**
   * Returns a string representation of this DateTime appropriate for the REPL.
   * @return {string}
   */
  [Symbol.for("nodejs.util.inspect.custom")]() {
    if (this.isValid) {
      return `DateTime { ts: ${this.toISO()}, zone: ${this.zone.name}, locale: ${this.locale} }`;
    } else {
      return `DateTime { Invalid, reason: ${this.invalidReason} }`;
    }
  }
  /**
   * Returns the epoch milliseconds of this DateTime. Alias of {@link DateTime#toMillis}
   * @return {number}
   */
  valueOf() {
    return this.toMillis();
  }
  /**
   * Returns the epoch milliseconds of this DateTime.
   * @return {number}
   */
  toMillis() {
    return this.isValid ? this.ts : NaN;
  }
  /**
   * Returns the epoch seconds of this DateTime.
   * @return {number}
   */
  toSeconds() {
    return this.isValid ? this.ts / 1e3 : NaN;
  }
  /**
   * Returns the epoch seconds (as a whole number) of this DateTime.
   * @return {number}
   */
  toUnixInteger() {
    return this.isValid ? Math.floor(this.ts / 1e3) : NaN;
  }
  /**
   * Returns an ISO 8601 representation of this DateTime appropriate for use in JSON.
   * @return {string}
   */
  toJSON() {
    return this.toISO();
  }
  /**
   * Returns a BSON serializable equivalent to this DateTime.
   * @return {Date}
   */
  toBSON() {
    return this.toJSDate();
  }
  /**
   * Returns a JavaScript object with this DateTime's year, month, day, and so on.
   * @param opts - options for generating the object
   * @param {boolean} [opts.includeConfig=false] - include configuration attributes in the output
   * @example DateTime.now().toObject() //=> { year: 2017, month: 4, day: 22, hour: 20, minute: 49, second: 42, millisecond: 268 }
   * @return {Object}
   */
  toObject(opts = {}) {
    if (!this.isValid) return {};
    const base = { ...this.c };
    if (opts.includeConfig) {
      base.outputCalendar = this.outputCalendar;
      base.numberingSystem = this.loc.numberingSystem;
      base.locale = this.loc.locale;
    }
    return base;
  }
  /**
   * Returns a JavaScript Date equivalent to this DateTime.
   * @return {Date}
   */
  toJSDate() {
    return new Date(this.isValid ? this.ts : NaN);
  }
  // COMPARE
  /**
   * Return the difference between two DateTimes as a Duration.
   * @param {DateTime} otherDateTime - the DateTime to compare this one to
   * @param {string|string[]} [unit=['milliseconds']] - the unit or array of units (such as 'hours' or 'days') to include in the duration.
   * @param {Object} opts - options that affect the creation of the Duration
   * @param {string} [opts.conversionAccuracy='casual'] - the conversion system to use
   * @example
   * var i1 = DateTime.fromISO('1982-05-25T09:45'),
   *     i2 = DateTime.fromISO('1983-10-14T10:30');
   * i2.diff(i1).toObject() //=> { milliseconds: 43807500000 }
   * i2.diff(i1, 'hours').toObject() //=> { hours: 12168.75 }
   * i2.diff(i1, ['months', 'days']).toObject() //=> { months: 16, days: 19.03125 }
   * i2.diff(i1, ['months', 'days', 'hours']).toObject() //=> { months: 16, days: 19, hours: 0.75 }
   * @return {Duration}
   */
  diff(otherDateTime, unit = "milliseconds", opts = {}) {
    if (!this.isValid || !otherDateTime.isValid) {
      return Duration.invalid("created by diffing an invalid DateTime");
    }
    const durOpts = { locale: this.locale, numberingSystem: this.numberingSystem, ...opts };
    const units = maybeArray(unit).map(Duration.normalizeUnit), otherIsLater = otherDateTime.valueOf() > this.valueOf(), earlier = otherIsLater ? this : otherDateTime, later = otherIsLater ? otherDateTime : this, diffed = diff(earlier, later, units, durOpts);
    return otherIsLater ? diffed.negate() : diffed;
  }
  /**
   * Return the difference between this DateTime and right now.
   * See {@link DateTime#diff}
   * @param {string|string[]} [unit=['milliseconds']] - the unit or units units (such as 'hours' or 'days') to include in the duration
   * @param {Object} opts - options that affect the creation of the Duration
   * @param {string} [opts.conversionAccuracy='casual'] - the conversion system to use
   * @return {Duration}
   */
  diffNow(unit = "milliseconds", opts = {}) {
    return this.diff(DateTime.now(), unit, opts);
  }
  /**
   * Return an Interval spanning between this DateTime and another DateTime
   * @param {DateTime} otherDateTime - the other end point of the Interval
   * @return {Interval}
   */
  until(otherDateTime) {
    return this.isValid ? Interval.fromDateTimes(this, otherDateTime) : this;
  }
  /**
   * Return whether this DateTime is in the same unit of time as another DateTime.
   * Higher-order units must also be identical for this function to return `true`.
   * Note that time zones are **ignored** in this comparison, which compares the **local** calendar time. Use {@link DateTime#setZone} to convert one of the dates if needed.
   * @param {DateTime} otherDateTime - the other DateTime
   * @param {string} unit - the unit of time to check sameness on
   * @param {Object} opts - options
   * @param {boolean} [opts.useLocaleWeeks=false] - If true, use weeks based on the locale, i.e. use the locale-dependent start of the week; only the locale of this DateTime is used
   * @example DateTime.now().hasSame(otherDT, 'day'); //~> true if otherDT is in the same current calendar day
   * @return {boolean}
   */
  hasSame(otherDateTime, unit, opts) {
    if (!this.isValid) return false;
    const inputMs = otherDateTime.valueOf();
    const adjustedToZone = this.setZone(otherDateTime.zone, { keepLocalTime: true });
    return adjustedToZone.startOf(unit, opts) <= inputMs && inputMs <= adjustedToZone.endOf(unit, opts);
  }
  /**
   * Equality check
   * Two DateTimes are equal if and only if they represent the same millisecond, have the same zone and location, and are both valid.
   * To compare just the millisecond values, use `+dt1 === +dt2`.
   * @param {DateTime} other - the other DateTime
   * @return {boolean}
   */
  equals(other) {
    return this.isValid && other.isValid && this.valueOf() === other.valueOf() && this.zone.equals(other.zone) && this.loc.equals(other.loc);
  }
  /**
   * Returns a string representation of a this time relative to now, such as "in two days". Can only internationalize if your
   * platform supports Intl.RelativeTimeFormat. Rounds down by default.
   * @param {Object} options - options that affect the output
   * @param {DateTime} [options.base=DateTime.now()] - the DateTime to use as the basis to which this time is compared. Defaults to now.
   * @param {string} [options.style="long"] - the style of units, must be "long", "short", or "narrow"
   * @param {string|string[]} options.unit - use a specific unit or array of units; if omitted, or an array, the method will pick the best unit. Use an array or one of "years", "quarters", "months", "weeks", "days", "hours", "minutes", or "seconds"
   * @param {boolean} [options.round=true] - whether to round the numbers in the output.
   * @param {number} [options.padding=0] - padding in milliseconds. This allows you to round up the result if it fits inside the threshold. Don't use in combination with {round: false} because the decimal output will include the padding.
   * @param {string} options.locale - override the locale of this DateTime
   * @param {string} options.numberingSystem - override the numberingSystem of this DateTime. The Intl system may choose not to honor this
   * @example DateTime.now().plus({ days: 1 }).toRelative() //=> "in 1 day"
   * @example DateTime.now().setLocale("es").toRelative({ days: 1 }) //=> "dentro de 1 día"
   * @example DateTime.now().plus({ days: 1 }).toRelative({ locale: "fr" }) //=> "dans 23 heures"
   * @example DateTime.now().minus({ days: 2 }).toRelative() //=> "2 days ago"
   * @example DateTime.now().minus({ days: 2 }).toRelative({ unit: "hours" }) //=> "48 hours ago"
   * @example DateTime.now().minus({ hours: 36 }).toRelative({ round: false }) //=> "1.5 days ago"
   */
  toRelative(options = {}) {
    if (!this.isValid) return null;
    const base = options.base || DateTime.fromObject({}, { zone: this.zone }), padding = options.padding ? this < base ? -options.padding : options.padding : 0;
    let units = ["years", "months", "days", "hours", "minutes", "seconds"];
    let unit = options.unit;
    if (Array.isArray(options.unit)) {
      units = options.unit;
      unit = void 0;
    }
    return diffRelative(base, this.plus(padding), {
      ...options,
      numeric: "always",
      units,
      unit
    });
  }
  /**
   * Returns a string representation of this date relative to today, such as "yesterday" or "next month".
   * Only internationalizes on platforms that supports Intl.RelativeTimeFormat.
   * @param {Object} options - options that affect the output
   * @param {DateTime} [options.base=DateTime.now()] - the DateTime to use as the basis to which this time is compared. Defaults to now.
   * @param {string} options.locale - override the locale of this DateTime
   * @param {string} options.unit - use a specific unit; if omitted, the method will pick the unit. Use one of "years", "quarters", "months", "weeks", or "days"
   * @param {string} options.numberingSystem - override the numberingSystem of this DateTime. The Intl system may choose not to honor this
   * @example DateTime.now().plus({ days: 1 }).toRelativeCalendar() //=> "tomorrow"
   * @example DateTime.now().setLocale("es").plus({ days: 1 }).toRelative() //=> ""mañana"
   * @example DateTime.now().plus({ days: 1 }).toRelativeCalendar({ locale: "fr" }) //=> "demain"
   * @example DateTime.now().minus({ days: 2 }).toRelativeCalendar() //=> "2 days ago"
   */
  toRelativeCalendar(options = {}) {
    if (!this.isValid) return null;
    return diffRelative(options.base || DateTime.fromObject({}, { zone: this.zone }), this, {
      ...options,
      numeric: "auto",
      units: ["years", "months", "days"],
      calendary: true
    });
  }
  /**
   * Return the min of several date times
   * @param {...DateTime} dateTimes - the DateTimes from which to choose the minimum
   * @return {DateTime} the min DateTime, or undefined if called with no argument
   */
  static min(...dateTimes) {
    if (!dateTimes.every(DateTime.isDateTime)) {
      throw new InvalidArgumentError("min requires all arguments be DateTimes");
    }
    return bestBy(dateTimes, (i) => i.valueOf(), Math.min);
  }
  /**
   * Return the max of several date times
   * @param {...DateTime} dateTimes - the DateTimes from which to choose the maximum
   * @return {DateTime} the max DateTime, or undefined if called with no argument
   */
  static max(...dateTimes) {
    if (!dateTimes.every(DateTime.isDateTime)) {
      throw new InvalidArgumentError("max requires all arguments be DateTimes");
    }
    return bestBy(dateTimes, (i) => i.valueOf(), Math.max);
  }
  // MISC
  /**
   * Explain how a string would be parsed by fromFormat()
   * @param {string} text - the string to parse
   * @param {string} fmt - the format the string is expected to be in (see description)
   * @param {Object} options - options taken by fromFormat()
   * @return {Object}
   */
  static fromFormatExplain(text, fmt, options = {}) {
    const { locale = null, numberingSystem = null } = options, localeToUse = Locale.fromOpts({
      locale,
      numberingSystem,
      defaultToEN: true
    });
    return explainFromTokens(localeToUse, text, fmt);
  }
  /**
   * @deprecated use fromFormatExplain instead
   */
  static fromStringExplain(text, fmt, options = {}) {
    return DateTime.fromFormatExplain(text, fmt, options);
  }
  /**
   * Build a parser for `fmt` using the given locale. This parser can be passed
   * to {@link DateTime.fromFormatParser} to a parse a date in this format. This
   * can be used to optimize cases where many dates need to be parsed in a
   * specific format.
   *
   * @param {String} fmt - the format the string is expected to be in (see
   * description)
   * @param {Object} options - options used to set locale and numberingSystem
   * for parser
   * @returns {TokenParser} - opaque object to be used
   */
  static buildFormatParser(fmt, options = {}) {
    const { locale = null, numberingSystem = null } = options, localeToUse = Locale.fromOpts({
      locale,
      numberingSystem,
      defaultToEN: true
    });
    return new TokenParser(localeToUse, fmt);
  }
  /**
   * Create a DateTime from an input string and format parser.
   *
   * The format parser must have been created with the same locale as this call.
   *
   * @param {String} text - the string to parse
   * @param {TokenParser} formatParser - parser from {@link DateTime.buildFormatParser}
   * @param {Object} opts - options taken by fromFormat()
   * @returns {DateTime}
   */
  static fromFormatParser(text, formatParser, opts = {}) {
    if (isUndefined(text) || isUndefined(formatParser)) {
      throw new InvalidArgumentError(
        "fromFormatParser requires an input string and a format parser"
      );
    }
    const { locale = null, numberingSystem = null } = opts, localeToUse = Locale.fromOpts({
      locale,
      numberingSystem,
      defaultToEN: true
    });
    if (!localeToUse.equals(formatParser.locale)) {
      throw new InvalidArgumentError(
        `fromFormatParser called with a locale of ${localeToUse}, but the format parser was created for ${formatParser.locale}`
      );
    }
    const { result, zone, specificOffset, invalidReason } = formatParser.explainFromTokens(text);
    if (invalidReason) {
      return DateTime.invalid(invalidReason);
    } else {
      return parseDataToDateTime(
        result,
        zone,
        opts,
        `format ${formatParser.format}`,
        text,
        specificOffset
      );
    }
  }
  // FORMAT PRESETS
  /**
   * {@link DateTime#toLocaleString} format like 10/14/1983
   * @type {Object}
   */
  static get DATE_SHORT() {
    return DATE_SHORT;
  }
  /**
   * {@link DateTime#toLocaleString} format like 'Oct 14, 1983'
   * @type {Object}
   */
  static get DATE_MED() {
    return DATE_MED;
  }
  /**
   * {@link DateTime#toLocaleString} format like 'Fri, Oct 14, 1983'
   * @type {Object}
   */
  static get DATE_MED_WITH_WEEKDAY() {
    return DATE_MED_WITH_WEEKDAY;
  }
  /**
   * {@link DateTime#toLocaleString} format like 'October 14, 1983'
   * @type {Object}
   */
  static get DATE_FULL() {
    return DATE_FULL;
  }
  /**
   * {@link DateTime#toLocaleString} format like 'Tuesday, October 14, 1983'
   * @type {Object}
   */
  static get DATE_HUGE() {
    return DATE_HUGE;
  }
  /**
   * {@link DateTime#toLocaleString} format like '09:30 AM'. Only 12-hour if the locale is.
   * @type {Object}
   */
  static get TIME_SIMPLE() {
    return TIME_SIMPLE;
  }
  /**
   * {@link DateTime#toLocaleString} format like '09:30:23 AM'. Only 12-hour if the locale is.
   * @type {Object}
   */
  static get TIME_WITH_SECONDS() {
    return TIME_WITH_SECONDS;
  }
  /**
   * {@link DateTime#toLocaleString} format like '09:30:23 AM EDT'. Only 12-hour if the locale is.
   * @type {Object}
   */
  static get TIME_WITH_SHORT_OFFSET() {
    return TIME_WITH_SHORT_OFFSET;
  }
  /**
   * {@link DateTime#toLocaleString} format like '09:30:23 AM Eastern Daylight Time'. Only 12-hour if the locale is.
   * @type {Object}
   */
  static get TIME_WITH_LONG_OFFSET() {
    return TIME_WITH_LONG_OFFSET;
  }
  /**
   * {@link DateTime#toLocaleString} format like '09:30', always 24-hour.
   * @type {Object}
   */
  static get TIME_24_SIMPLE() {
    return TIME_24_SIMPLE;
  }
  /**
   * {@link DateTime#toLocaleString} format like '09:30:23', always 24-hour.
   * @type {Object}
   */
  static get TIME_24_WITH_SECONDS() {
    return TIME_24_WITH_SECONDS;
  }
  /**
   * {@link DateTime#toLocaleString} format like '09:30:23 EDT', always 24-hour.
   * @type {Object}
   */
  static get TIME_24_WITH_SHORT_OFFSET() {
    return TIME_24_WITH_SHORT_OFFSET;
  }
  /**
   * {@link DateTime#toLocaleString} format like '09:30:23 Eastern Daylight Time', always 24-hour.
   * @type {Object}
   */
  static get TIME_24_WITH_LONG_OFFSET() {
    return TIME_24_WITH_LONG_OFFSET;
  }
  /**
   * {@link DateTime#toLocaleString} format like '10/14/1983, 9:30 AM'. Only 12-hour if the locale is.
   * @type {Object}
   */
  static get DATETIME_SHORT() {
    return DATETIME_SHORT;
  }
  /**
   * {@link DateTime#toLocaleString} format like '10/14/1983, 9:30:33 AM'. Only 12-hour if the locale is.
   * @type {Object}
   */
  static get DATETIME_SHORT_WITH_SECONDS() {
    return DATETIME_SHORT_WITH_SECONDS;
  }
  /**
   * {@link DateTime#toLocaleString} format like 'Oct 14, 1983, 9:30 AM'. Only 12-hour if the locale is.
   * @type {Object}
   */
  static get DATETIME_MED() {
    return DATETIME_MED;
  }
  /**
   * {@link DateTime#toLocaleString} format like 'Oct 14, 1983, 9:30:33 AM'. Only 12-hour if the locale is.
   * @type {Object}
   */
  static get DATETIME_MED_WITH_SECONDS() {
    return DATETIME_MED_WITH_SECONDS;
  }
  /**
   * {@link DateTime#toLocaleString} format like 'Fri, 14 Oct 1983, 9:30 AM'. Only 12-hour if the locale is.
   * @type {Object}
   */
  static get DATETIME_MED_WITH_WEEKDAY() {
    return DATETIME_MED_WITH_WEEKDAY;
  }
  /**
   * {@link DateTime#toLocaleString} format like 'October 14, 1983, 9:30 AM EDT'. Only 12-hour if the locale is.
   * @type {Object}
   */
  static get DATETIME_FULL() {
    return DATETIME_FULL;
  }
  /**
   * {@link DateTime#toLocaleString} format like 'October 14, 1983, 9:30:33 AM EDT'. Only 12-hour if the locale is.
   * @type {Object}
   */
  static get DATETIME_FULL_WITH_SECONDS() {
    return DATETIME_FULL_WITH_SECONDS;
  }
  /**
   * {@link DateTime#toLocaleString} format like 'Friday, October 14, 1983, 9:30 AM Eastern Daylight Time'. Only 12-hour if the locale is.
   * @type {Object}
   */
  static get DATETIME_HUGE() {
    return DATETIME_HUGE;
  }
  /**
   * {@link DateTime#toLocaleString} format like 'Friday, October 14, 1983, 9:30:33 AM Eastern Daylight Time'. Only 12-hour if the locale is.
   * @type {Object}
   */
  static get DATETIME_HUGE_WITH_SECONDS() {
    return DATETIME_HUGE_WITH_SECONDS;
  }
}
function friendlyDateTime(dateTimeish) {
  if (DateTime.isDateTime(dateTimeish)) {
    return dateTimeish;
  } else if (dateTimeish && dateTimeish.valueOf && isNumber(dateTimeish.valueOf())) {
    return DateTime.fromJSDate(dateTimeish);
  } else if (dateTimeish && typeof dateTimeish === "object") {
    return DateTime.fromObject(dateTimeish);
  } else {
    throw new InvalidArgumentError(
      `Unknown datetime argument: ${dateTimeish}, of type ${typeof dateTimeish}`
    );
  }
}
/*!
 * chartjs-adapter-luxon v1.3.1
 * https://www.chartjs.org
 * (c) 2023 chartjs-adapter-luxon Contributors
 * Released under the MIT license
 */
const FORMATS = {
  datetime: DateTime.DATETIME_MED_WITH_SECONDS,
  millisecond: "h:mm:ss.SSS a",
  second: DateTime.TIME_WITH_SECONDS,
  minute: DateTime.TIME_SIMPLE,
  hour: { hour: "numeric" },
  day: { day: "numeric", month: "short" },
  week: "DD",
  month: { month: "short", year: "numeric" },
  quarter: "'Q'q - yyyy",
  year: { year: "numeric" }
};
adapters._date.override({
  _id: "luxon",
  // DEBUG
  /**
   * @private
   */
  _create: function(time) {
    return DateTime.fromMillis(time, this.options);
  },
  init(chartOptions) {
    if (!this.options.locale) {
      this.options.locale = chartOptions.locale;
    }
  },
  formats: function() {
    return FORMATS;
  },
  parse: function(value, format) {
    const options = this.options;
    const type = typeof value;
    if (value === null || type === "undefined") {
      return null;
    }
    if (type === "number") {
      value = this._create(value);
    } else if (type === "string") {
      if (typeof format === "string") {
        value = DateTime.fromFormat(value, format, options);
      } else {
        value = DateTime.fromISO(value, options);
      }
    } else if (value instanceof Date) {
      value = DateTime.fromJSDate(value, options);
    } else if (type === "object" && !(value instanceof DateTime)) {
      value = DateTime.fromObject(value, options);
    }
    return value.isValid ? value.valueOf() : null;
  },
  format: function(time, format) {
    const datetime = this._create(time);
    return typeof format === "string" ? datetime.toFormat(format) : datetime.toLocaleString(format);
  },
  add: function(time, amount, unit) {
    const args = {};
    args[unit] = amount;
    return this._create(time).plus(args).valueOf();
  },
  diff: function(max, min, unit) {
    return this._create(max).diff(this._create(min)).as(unit).valueOf();
  },
  startOf: function(time, unit, weekday) {
    if (unit === "isoWeek") {
      weekday = Math.trunc(Math.min(Math.max(0, weekday), 6));
      const dateTime = this._create(time);
      return dateTime.minus({ days: (dateTime.weekday - weekday + 7) % 7 }).startOf("day").valueOf();
    }
    return unit ? this._create(time).startOf(unit).valueOf() : time;
  },
  endOf: function(time, unit) {
    return this._create(time).endOf(unit).valueOf();
  }
});
const _hoisted_1$t = { class: "relative w-full h-full flex flex-col flex-nowrap justify-start items-start" };
const _hoisted_2$p = { class: "relative grow-0 shrink-0 w-full flex pb-2 sm:py-2 px-2 vertical-middle" };
const _hoisted_3$k = { class: "grow shrink flex flex-col flex-nowrap space-y-1" };
const _hoisted_4$j = { key: 0 };
const _hoisted_5$g = ["disabled"];
const _hoisted_6$e = ["value"];
const _hoisted_7$c = { class: "row justify-center cc-none md:block" };
const _hoisted_8$b = { class: "flex flex-row flex-nowrap cc-space-x-small" };
const _hoisted_9$a = ["disabled", "onClick"];
const _hoisted_10$9 = { class: "grow shrink flex flex-col flex-nowrap space-y-1" };
const _hoisted_11$9 = { key: 0 };
const _hoisted_12$8 = ["disabled"];
const _hoisted_13$8 = ["value"];
const _hoisted_14$6 = { class: "flex flex-row flex-nowrap space-x-1" };
const _hoisted_15$6 = ["disabled", "onClick"];
const _hoisted_16$6 = { class: "relative flex-1 w-full block p-2 cc-area-light" };
const _hoisted_17$6 = {
  key: 0,
  class: "z-max bg-grey-4 opacity-75"
};
const backgroundColorPreset = "rgba(54, 162, 235, 0.2)";
const borderColorPreset = "rgba(54, 162, 235, 1)";
const _sfc_main$u = /* @__PURE__ */ defineComponent({
  __name: "PriceChart",
  props: {
    tokenPolicyId: { type: String, required: false, default: null },
    tokenAssetName: { type: String, required: false, default: null }
  },
  emits: ["close", "loadingFinished", "loadingFailed"],
  setup(__props, { emit: __emit }) {
    Chart.register(
      LineElement,
      PointElement,
      CategoryScale,
      LinearScale,
      TimeSeriesScale,
      LineController,
      plugin_tooltip
    );
    const props = __props;
    const emit = __emit;
    const { t } = useTranslation();
    const { formatDatetime } = useFormatter();
    const { activeCurrency } = useCurrencyAPI();
    let chart = null;
    const canvasContainer = ref(null);
    const canvasRef = ref(null);
    const loading = ref(false);
    const availableDurations = ref([]);
    const availableIntervals = ref([]);
    const priceData = ref(null);
    const chartType = ref("line");
    const selectedDuration = ref(7);
    const selectedInterval = ref("15m");
    const showDurations = computed(() => availableDurations.value.length > 0);
    const showInterval = computed(() => availableIntervals.value.length > 0);
    const getLineConfig = (data) => {
      return {
        type: "line",
        data: {
          labels: data.chartLabels.concat(),
          datasets: [{
            data: data.chartData.concat(),
            label: "Price",
            backgroundColor: backgroundColorPreset,
            borderColor: borderColorPreset,
            pointBackgroundColor: borderColorPreset,
            borderWidth: 1,
            pointRadius: 1
          }]
        },
        options: {
          aspectRatio: 1,
          plugins: {
            tooltip: {
              mode: "nearest",
              bodyFont: {
                weight: "bold"
              },
              footerFont: {
                size: 10
              },
              callbacks: {
                title: (ctx) => "Price chart",
                footer: (ctx) => ctx[0].label,
                label: (ctx) => ctx.formattedValue + activeCurrency.value.symbol,
                labelTextColor: (ctx) => "#34D399"
              }
            }
          }
        }
      };
    };
    const getOhlcConfig = (data) => {
      return {
        type: "bar",
        data: {
          labels: [],
          datasets: [{
            data: data.chartData.concat(),
            label: "Price",
            backgroundColor: backgroundColorPreset,
            borderColor: borderColorPreset,
            borderWidth: 1,
            pointRadius: 1,
            //@ts-ignore
            color: {
              up: "#2c9b2c",
              down: "#c43030",
              unchanged: "#999"
            }
          }]
        },
        options: {
          plugins: {
            tooltip: {
              mode: "nearest",
              bodyFont: {
                weight: "bold"
              },
              footerFont: {
                size: 10
              },
              callbacks: {
                title: (ctx) => "OHLC Data",
                footer: (ctx) => {
                  let currentTimeStart = priceData.value.price[ctx[0].dataIndex].time;
                  while (String(currentTimeStart).length < 13) {
                    currentTimeStart *= 10;
                  }
                  if (ctx[0].dataIndex <= priceData.value.price.length - 2) {
                    let nextTimestamp = priceData.value.price[ctx[0].dataIndex + 1].time;
                    while (String(nextTimestamp).length < 13) {
                      nextTimestamp *= 10;
                    }
                    return formatDatetime(currentTimeStart) + " - " + formatDatetime(nextTimestamp);
                  }
                  return formatDatetime(currentTimeStart) + " - " + formatDatetime((/* @__PURE__ */ new Date()).getTime());
                },
                label: (ctx) => {
                  const currency = props.tokenPolicyId === null ? activeCurrency.value.symbol : "₳";
                  const ohlcDesc = ctx.formattedValue;
                  const valueO = (ohlcDesc.substring(0, ohlcDesc.indexOf("H:") - 1) + currency).replace("O:", "Open :");
                  const valueH = (ohlcDesc.substring(ohlcDesc.indexOf("H:"), ohlcDesc.indexOf("L:") - 1) + currency).replace("H:", "High  :");
                  const valueL = (ohlcDesc.substring(ohlcDesc.indexOf("L:"), ohlcDesc.indexOf("C:") - 1) + currency).replace("L:", "Low  :");
                  const valueC = (ohlcDesc.substring(ohlcDesc.indexOf("C:"), ohlcDesc.length) + currency).replace("C:", "Close:");
                  return [valueO, valueH, valueL, valueC];
                },
                labelTextColor: (ctx) => "#34D399"
              }
            }
          }
        }
      };
    };
    const getChartConfig = (data) => {
      if (chartType.value === "ohlc") return getOhlcConfig(data);
      return getLineConfig(data);
    };
    const updateData = (data) => {
      priceData.value = data ?? null;
      const pData = priceData.value;
      if (pData) {
        availableDurations.value = pData.supportedDurations;
        availableIntervals.value = pData.supportedInterval;
      } else {
        availableDurations.value = [];
        availableIntervals.value = [];
      }
    };
    const checkCachedPriceData = async (networkId2, request) => {
      return null;
    };
    const saveCachedPriceData = async (networkId2, request, data) => {
      if (!data) return;
      data.price[data.price.length - 1].time * 1e3;
    };
    const loadPriceData = async (networkId2) => {
      const request = {
        type: chartType.value,
        policyId: props.tokenPolicyId ?? null,
        assetName: props.tokenAssetName ?? "ADA",
        currency: activeCurrency.value.id ?? "usd",
        startTimestamp: null,
        durationInDays: selectedDuration.value,
        interval: selectedInterval.value
      };
      const cachedData = await checkCachedPriceData();
      if (cachedData) {
        updateData(cachedData);
        return;
      }
      const res = await api.post("/" + networkId2 + "/v1/misc/chart", request).catch((err) => {
        console.warn("Error: price chart: failed", networkId2);
      });
      if (!res || !res.data) {
        availableDurations.value = [];
        availableIntervals.value = [];
        throw "loadingFailed";
      }
      updateData(res.data ?? null);
      await saveCachedPriceData(networkId2, request, res.data ?? null);
    };
    const generateChartData = () => {
      var _a;
      let chartLabels = [];
      let chartData = [];
      (_a = priceData.value) == null ? void 0 : _a.price.forEach((priceDataEntry, index) => {
        var _a2, _b, _c, _d;
        let time = String(priceDataEntry.time);
        while (time.length < 13) {
          time += "0";
        }
        let timestamp = Number(time);
        chartLabels.push(formatDatetime(timestamp));
        if (chartType.value === "line") {
          chartData.push({ y: priceDataEntry.price, x: timestamp });
        }
        if (chartType.value === "ohlc") {
          chartData.push({
            x: timestamp,
            o: (_a2 = priceDataEntry.ohlcData) == null ? void 0 : _a2.open,
            h: (_b = priceDataEntry.ohlcData) == null ? void 0 : _b.high,
            l: (_c = priceDataEntry.ohlcData) == null ? void 0 : _c.low,
            c: (_d = priceDataEntry.ohlcData) == null ? void 0 : _d.close
          });
        }
      });
      return { chartLabels, chartData };
    };
    const updateChartData = (chartConfig) => {
      var _a, _b;
      if (!chart) {
        return;
      }
      if (chart.data) {
        while (((_a = chart.data.labels) == null ? void 0 : _a.length) ?? 0 > 0) {
          chart.data.labels.pop();
        }
        while (((_b = chart.data.datasets) == null ? void 0 : _b.length) ?? 0 > 0) {
          chart.data.datasets.pop();
        }
      }
      chart.data.labels = chartConfig.data.labels;
      chart.data.datasets.push(chartConfig.data.datasets[0]);
      chart.update();
    };
    const renderChart = (data) => {
      const canvas = canvasRef.value;
      if (canvas) {
        const chartConfig = getChartConfig(data);
        if (!chart || true) {
          try {
            if (chart) chart.destroy();
            if (canvasContainer.value) {
              chartConfig.options.aspectRatio = canvasContainer.value.clientWidth / canvasContainer.value.clientHeight;
              chartConfig.options.maintainAspectRatio = true;
            }
            chart = new Chart({ canvas }, chartConfig);
          } catch (e) {
            console.error(e);
          }
        } else {
          updateChartData(chartConfig);
        }
      }
    };
    const setTimeframe = async (days) => {
      const currentValue = selectedDuration.value;
      let newValue = 0;
      if (typeof days === "object") {
        newValue = days.target.options[days.target.options.selectedIndex].value;
      } else if (days === "max") {
        newValue = "max";
      } else if (typeof days === "number") {
        newValue = days;
      }
      if (newValue !== currentValue) {
        selectedDuration.value = newValue;
        reload();
      }
    };
    const setInterval = async (interval) => {
      const currentValue = selectedInterval.value;
      let newValue = "";
      if (interval && typeof interval === "object") {
        newValue = interval.target.options[interval.target.options.selectedIndex].value;
      } else {
        newValue = interval;
      }
      if (newValue !== currentValue) {
        selectedInterval.value = newValue;
        reload();
      }
    };
    const reload = async () => {
      loading.value = true;
      try {
        await loadPriceData(networkId.value);
        loading.value = false;
        if (canvasContainer.value) {
          renderChart(generateChartData());
        }
        emit("loadingFinished");
      } catch (e) {
        emit("loadingFailed");
      }
      loading.value = false;
    };
    onMounted(() => {
      reload();
    });
    watch(() => props.tokenPolicyId, () => {
      reload();
    });
    watch(chartType, () => {
      reload();
    });
    watch(canvasRef, () => {
      reload();
    });
    useResizeObserver(canvasContainer, (e) => {
      if (e && e.contentRect && chart) {
        chart.options.aspectRatio = e.contentRect.width / e.contentRect.height;
      }
      renderChart(generateChartData());
    });
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", _hoisted_1$t, [
        createBaseVNode("div", _hoisted_2$p, [
          createBaseVNode("div", {
            class: normalizeClass(showInterval.value ? "flex flex-row flex-nowrap space-x-2" : "flex flex-col sm:flex-row flex-nowrap sm:space-x-2 space-y-2 sm:space-y-0")
          }, [
            createBaseVNode("div", _hoisted_3$k, [
              createBaseVNode("div", null, [
                showInterval.value ? (openBlock(), createElementBlock("span", _hoisted_4$j, toDisplayString(unref(t)("wallet.chart.scale")) + ":", 1)) : createCommentVNode("", true)
              ]),
              createBaseVNode("div", null, [
                showInterval.value ? withDirectives((openBlock(), createElementBlock("select", {
                  key: 0,
                  disabled: loading.value,
                  class: "appearance-none visible md:hidden cc-rounded cc-dropdown h-8 text-xs",
                  name: "interval",
                  id: "interval",
                  "onUpdate:modelValue": _cache[0] || (_cache[0] = ($event) => selectedInterval.value = $event),
                  onChange: setInterval
                }, [
                  (openBlock(true), createElementBlock(Fragment, null, renderList(availableIntervals.value, (interval) => {
                    return openBlock(), createElementBlock("option", { value: interval }, toDisplayString(interval), 9, _hoisted_6$e);
                  }), 256))
                ], 40, _hoisted_5$g)), [
                  [vModelSelect, selectedInterval.value]
                ]) : createCommentVNode("", true),
                createBaseVNode("div", _hoisted_7$c, [
                  createBaseVNode("div", _hoisted_8$b, [
                    (openBlock(true), createElementBlock(Fragment, null, renderList(availableIntervals.value, (interval) => {
                      return openBlock(), createElementBlock("button", {
                        type: "button",
                        class: normalizeClass(["relative h-8 flex justify-center items-center cc-rounded px-2 py-1 focus:z-10", selectedInterval.value === interval ? "cc-tabs-button-active" : "cc-tabs-button"]),
                        disabled: loading.value,
                        onClick: ($event) => !loading.value && setInterval(interval)
                      }, [
                        createTextVNode(toDisplayString(interval) + " ", 1),
                        createVNode(_sfc_main$C, {
                          "tooltip-c-s-s": "whitespace-nowrap",
                          anchor: "bottom middle",
                          "transition-show": "scale",
                          "transition-hide": "scale"
                        }, {
                          default: withCtx(() => [
                            createTextVNode(toDisplayString(interval.charAt(interval.length - 1) === "d" ? interval.substring(0, interval.length - 1) + " day" : interval.charAt(interval.length - 1) === "m" ? interval.substring(0, interval.length - 1) + " minute" : interval.substring(0, interval.length - 1) + " hour"), 1)
                          ]),
                          _: 2
                        }, 1024)
                      ], 10, _hoisted_9$a);
                    }), 256))
                  ])
                ])
              ])
            ]),
            createBaseVNode("div", _hoisted_10$9, [
              createBaseVNode("div", null, [
                showDurations.value ? (openBlock(), createElementBlock("span", _hoisted_11$9, toDisplayString(unref(t)("wallet.chart.duration")) + ":", 1)) : createCommentVNode("", true)
              ]),
              createBaseVNode("div", null, [
                showDurations.value && showInterval.value ? withDirectives((openBlock(), createElementBlock("select", {
                  key: 0,
                  disabled: loading.value,
                  class: "h-8 cc-rounded cc-dropdown text-xs",
                  name: "duration",
                  id: "duration",
                  "onUpdate:modelValue": _cache[1] || (_cache[1] = ($event) => selectedDuration.value = $event),
                  onChange: setTimeframe
                }, [
                  (openBlock(true), createElementBlock(Fragment, null, renderList(availableDurations.value, (duration, index) => {
                    return openBlock(), createElementBlock("option", {
                      key: index,
                      value: duration
                    }, toDisplayString(duration + (duration !== "max" ? "d" : "")), 9, _hoisted_13$8);
                  }), 128))
                ], 40, _hoisted_12$8)), [
                  [vModelSelect, selectedDuration.value]
                ]) : createCommentVNode("", true),
                createBaseVNode("div", _hoisted_14$6, [
                  showDurations.value && !showInterval.value ? (openBlock(true), createElementBlock(Fragment, { key: 0 }, renderList(availableDurations.value, (duration, index) => {
                    return openBlock(), createElementBlock("button", {
                      type: "button",
                      class: normalizeClass(["relative h-8 flex justify-center items-center cc-rounded px-2 py-1 focus:z-10", selectedDuration.value === duration ? "cc-tabs-button-active" : "cc-tabs-button"]),
                      key: index,
                      disabled: loading.value,
                      onClick: ($event) => !loading.value && setTimeframe(duration)
                    }, toDisplayString(duration + (duration !== "max" ? "d" : "")), 11, _hoisted_15$6);
                  }), 128)) : createCommentVNode("", true)
                ]),
                _cache[2] || (_cache[2] = createBaseVNode("div", { class: "h-full mx-2" }, null, -1))
              ])
            ])
          ], 2)
        ]),
        createBaseVNode("div", _hoisted_16$6, [
          loading.value ? (openBlock(), createElementBlock("div", _hoisted_17$6, [
            createVNode(QSpinnerDots_default, {
              class: "absolute rounded-xl p-3",
              color: "gray",
              size: "3em",
              style: { "left": "50%", "top": "50%", "background": "gray", "opacity": "90%" }
            })
          ])) : createCommentVNode("", true),
          withDirectives(createBaseVNode("div", {
            class: "block relative w-full h-full",
            ref_key: "canvasContainer",
            ref: canvasContainer
          }, [
            createBaseVNode("canvas", {
              ref_key: "canvasRef",
              ref: canvasRef,
              class: "w-full",
              "aria-label": "price chart",
              role: "img"
            }, null, 512)
          ], 512), [
            [vShow, !loading.value]
          ])
        ])
      ]);
    };
  }
});
const PriceChart = /* @__PURE__ */ _export_sfc(_sfc_main$u, [["__scopeId", "data-v-dc5150ea"]]);
const _hoisted_1$s = { class: "grow-0 shrink-0 w-full flex flex-row flex-nowrap items-start justify-between border-b cc-p" };
const _hoisted_2$o = { class: "flex flex-col cc-text-sz" };
const _hoisted_3$j = { class: "grow-0 shrink-0 w-full flex flex-row flex-nowrap items-start justify-between border-b cc-p" };
const _hoisted_4$i = { class: "flex flex-col cc-text-sz" };
const _hoisted_5$f = { class: "p-4" };
const _hoisted_6$d = { class: "cc-text-md font-semibold" };
const _hoisted_7$b = { class: "mt-2 sm:mt-3 cc-text-md" };
const _hoisted_8$a = { class: "mt-4 cc-text-md font-semibold" };
const _hoisted_9$9 = { class: "mt-2 sm:mt-3 cc-text-md" };
const _hoisted_10$8 = { class: "flex mt-4" };
const _hoisted_11$8 = {
  class: "relative w-full cc-flex-fixed mb-1.5 cc-site-max-width mx-auto inline-block",
  id: "cc-epoch-container"
};
const _hoisted_12$7 = { class: "relative whitespace-nowrap capitalize cc-text-semi-bold" };
const _hoisted_13$7 = {
  key: 0,
  class: "inline flex flex-row flex-nowrap"
};
const _hoisted_14$5 = { class: "flex flex-row flex-nowrap" };
const _hoisted_15$5 = { class: "cc-none sm:block" };
const _hoisted_16$5 = { class: "cc-none sm:block" };
const _hoisted_17$5 = { class: "cc-none sm:block cc-text-light" };
const _hoisted_18$4 = { class: "lowercase" };
const _hoisted_19$4 = { class: "mdi mdi-help-circle mt-px normal-case" };
const _hoisted_20$4 = { key: 3 };
const _sfc_main$t = /* @__PURE__ */ defineComponent({
  __name: "EpochProgress",
  setup(__props) {
    const { c, it } = useTranslation();
    const { toggleEpochModal } = useEpochModalOpen();
    const { activeCurrency } = useCurrencyAPI();
    const calcSlotInEpoch = computed(() => getCalculatedEpochSlot(networkId.value));
    const calcSlotsInEpoch = computed(() => getEpochLength(networkId.value ?? "mainnet"));
    const calcPercent = computed(() => calcSlotInEpoch.value / calcSlotsInEpoch.value);
    const slotInEpoch = computed(() => {
      const _slotsInEpoch = chainTip.value.epochSlots.toString();
      let _slotInEpoch = chainTip.value.epochSlot.toString() ?? "0";
      while (_slotInEpoch.length < _slotsInEpoch.length) {
        _slotInEpoch = "0" + _slotInEpoch;
      }
      return _slotInEpoch;
    });
    const showModal = ref(false);
    const showChartSymbol = ref(true);
    const showChartModal = ref(false);
    const remainingTime = ref("");
    const openChartModal = () => {
      showChartModal.value = true;
    };
    const closeChartModal = () => {
      showChartModal.value = false;
    };
    const onClose = () => {
      showModal.value = false;
    };
    const openEpochModal = () => {
      showModal.value = true;
      toggleEpochModal();
    };
    function calculateRemainingTime(slotsRemaining) {
      const minutes = Math.floor(slotsRemaining / 60);
      const hours = Math.floor(minutes / 60);
      const days = Math.floor(hours / 24);
      let value = "";
      if (days > 0) {
        value += days + it("common.time.day");
      }
      let tmpHours = hours % 24;
      value += " " + (tmpHours < 10 ? "0" + tmpHours : tmpHours) + ":";
      let tmpMinutes = minutes % 60;
      value += (tmpMinutes < 10 ? "0" + tmpMinutes : tmpMinutes) + ":";
      let tmpSeconds = slotsRemaining % 60;
      value += tmpSeconds < 10 ? "0" + tmpSeconds : tmpSeconds;
      if (days < 0 || hours < 0 || tmpMinutes < 0 || tmpSeconds < 0) {
        remainingTime.value = "";
        return;
      }
      remainingTime.value = " ~" + value;
    }
    watchEffect(() => {
      calculateRemainingTime(chainTip.value.epochSlots - chainTip.value.epochSlot);
    });
    const openLink = (target) => {
      window.open(target, void 0, "noopener,noreferrer");
    };
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock(Fragment, null, [
        showChartModal.value ? (openBlock(), createBlock(Modal, {
          key: 0,
          "full-width-on-mobile": "",
          maxHeight: "",
          onClose: closeChartModal
        }, {
          header: withCtx(() => {
            var _a;
            return [
              createBaseVNode("div", _hoisted_1$s, [
                createBaseVNode("div", _hoisted_2$o, [
                  createVNode(_sfc_main$G, {
                    label: unref(it)("wallet.chart.headline") + " ADA/" + ((_a = unref(activeCurrency).id) == null ? void 0 : _a.toUpperCase())
                  }, null, 8, ["label"])
                ])
              ])
            ];
          }),
          content: withCtx(() => [
            createVNode(PriceChart)
          ]),
          _: 1
        })) : createCommentVNode("", true),
        showModal.value ? (openBlock(), createBlock(Modal, {
          key: 1,
          "full-width-on-mobile": "",
          onClose
        }, {
          header: withCtx(() => [
            createBaseVNode("div", _hoisted_3$j, [
              createBaseVNode("div", _hoisted_4$i, [
                createVNode(_sfc_main$G, {
                  label: unref(it)("common.network.epochModal.header")
                }, null, 8, ["label"]),
                createVNode(_sfc_main$H, {
                  text: unref(it)("common.network.epochModal.subHeader")
                }, null, 8, ["text"])
              ])
            ])
          ]),
          content: withCtx(() => [
            createBaseVNode("div", _hoisted_5$f, [
              createBaseVNode("p", _hoisted_6$d, toDisplayString(unref(it)('common.network.epochModal.steps["1"].title')), 1),
              createBaseVNode("p", _hoisted_7$b, toDisplayString(unref(it)('common.network.epochModal.steps["1"].description')), 1),
              _cache[2] || (_cache[2] = createBaseVNode("a", {
                target: "_blank",
                rel: "noopener noreferrer",
                href: "https://api.eternl.io/mainnet/v1/chain/tip",
                class: "font-semibold cc-text-highlight"
              }, "https://api.eternl.io/mainnet/v1/chain/tip", -1)),
              createBaseVNode("p", _hoisted_8$a, toDisplayString(unref(it)('common.network.epochModal.steps["2"].title')), 1),
              createBaseVNode("p", _hoisted_9$9, toDisplayString(unref(it)('common.network.epochModal.steps["2"].description')), 1),
              createBaseVNode("div", _hoisted_10$8, [
                createVNode(_sfc_main$I, {
                  class: "p-1 m-2 mb-0 initial flex-1 w-1/4",
                  label: unref(it)("common.network.epochModal.joinDiscord"),
                  onClick: _cache[0] || (_cache[0] = ($event) => openLink(unref(it)("common.url.discord")))
                }, null, 8, ["label"]),
                createVNode(_sfc_main$I, {
                  class: "p-1 m-2 mb-0 initial flex-1 w-1/4",
                  label: unref(it)("common.network.epochModal.joinTelegram"),
                  onClick: _cache[1] || (_cache[1] = ($event) => openLink(unref(it)("common.url.telegram")))
                }, null, 8, ["label"])
              ])
            ])
          ]),
          _: 1
        })) : createCommentVNode("", true),
        createBaseVNode("div", _hoisted_11$8, [
          createBaseVNode("div", {
            class: normalizeClass(["relative w-full px-1 py-0.5 overflow-hidden cc-site-max-width mx-auto cc-rounded-la cc-shadow cc-text-medium cc-text-xs cc-text-color-light text-center", unref(chainTip).onTip ? "cc-online" : "cc-offline"])
          }, [
            !unref(networkId) ? (openBlock(), createElementBlock("div", {
              key: 0,
              class: normalizeClass(["absolute cc-rounded-la top-0 left-0 h-full cc-shadow", unref(c)("gradient")]),
              style: "width: 100%"
            }, null, 2)) : createCommentVNode("", true),
            unref(chainTip).onTip ? (openBlock(), createElementBlock("div", {
              key: 1,
              class: normalizeClass(["absolute cc-rounded-la top-0 left-0 h-full opacity-100 cc-shadow", unref(c)("gradient")]),
              style: normalizeStyle("width: " + unref(chainTip).epochPercent + "%")
            }, null, 6)) : createCommentVNode("", true),
            createBaseVNode("div", _hoisted_12$7, [
              unref(chainTip).onTip ? (openBlock(), createElementBlock("div", _hoisted_13$7, [
                createBaseVNode("span", _hoisted_14$5, [
                  createBaseVNode("span", _hoisted_15$5, toDisplayString(unref(it)("common.label.epoch") + ":") + " ", 1),
                  createTextVNode(toDisplayString(unref(chainTip).epochNo), 1),
                  createBaseVNode("span", _hoisted_16$5, " : " + toDisplayString(slotInEpoch.value), 1),
                  _cache[3] || (_cache[3] = createTextVNode(" "))
                ]),
                createBaseVNode("span", _hoisted_17$5, "/" + toDisplayString(unref(chainTip).epochSlots) + " ", 1),
                _cache[5] || (_cache[5] = createTextVNode(" (")),
                createVNode(_sfc_main$F, {
                  amount: unref(chainTip).epochPercent.toString(),
                  percent: "",
                  "whole-c-s-s": "",
                  "fraction-c-s-s": "",
                  decimals: 2,
                  "text-c-s-s": "mr-1"
                }, null, 8, ["amount"]),
                createBaseVNode("span", _hoisted_18$4, toDisplayString(remainingTime.value) + ")", 1),
                unref(networkId) === "mainnet" ? (openBlock(), createBlock(_sfc_main$v, {
                  key: 0,
                  class: "normal-case cc-text-normal inline",
                  showDot: "",
                  onClicked: openChartModal
                })) : createCommentVNode("", true),
                unref(networkId) === "mainnet" && showChartSymbol.value ? (openBlock(), createElementBlock("span", {
                  key: 1,
                  class: "pl-1 cc-text-medium cursor-pointer text-green",
                  onClick: openChartModal
                }, _cache[4] || (_cache[4] = [
                  createBaseVNode("i", { class: "mdi mdi-chart-line-variant" }, null, -1)
                ]))) : createCommentVNode("", true)
              ])) : calcPercent.value < 0.01 ? (openBlock(), createElementBlock("span", {
                key: 1,
                onClick: openEpochModal
              }, [
                createBaseVNode("span", _hoisted_19$4, "  " + toDisplayString(unref(it)("common.network.newEpoch")), 1)
              ])) : unref(networkId) ? (openBlock(), createElementBlock("span", {
                key: 2,
                onClick: openEpochModal
              }, [
                _cache[6] || (_cache[6] = createBaseVNode("i", { class: "mdi mdi-help-circle mt-px" }, null, -1)),
                createTextVNode(" " + toDisplayString(unref(it)("common.network.status")) + ": " + toDisplayString(unref(it)("common.network.noconnection")), 1)
              ])) : (openBlock(), createElementBlock("span", _hoisted_20$4, " "))
            ])
          ], 2)
        ])
      ], 64);
    };
  }
});
const _hoisted_1$r = {
  key: 0,
  class: "absolute top-2 right-2 mdi mdi-circle text-xs-dense ml-0 cc-text-green-light"
};
const _hoisted_2$n = { class: "flex-none" };
const _hoisted_3$i = ["src"];
const _hoisted_4$h = { class: "" };
const _sfc_main$s = /* @__PURE__ */ defineComponent({
  __name: "NetworkItem",
  props: {
    uiNetworkId: { type: String, required: true }
  },
  emits: ["networkChange"],
  setup(__props, { emit: __emit }) {
    const props = __props;
    const emit = __emit;
    const { it } = useTranslation();
    const isActiveNetwork = computed(() => props.uiNetworkId === networkId.value);
    it("common.network." + props.uiNetworkId + ".label");
    it("common.network." + props.uiNetworkId + ".description");
    let icon = it("common.network." + props.uiNetworkId + ".icon");
    const link = it("common.network." + props.uiNetworkId + ".link");
    if (icon.length === 0) {
      icon = cardanoLogo;
    }
    function onNetworkSelected() {
      emit("networkChange", props.uiNetworkId);
    }
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", {
        class: normalizeClass(["relative cc-text-sz flex flex-row flex-nowrap justify-start items-start cursor-pointer p-4 gap-4", __props.uiNetworkId === "mainnet" ? "cc-area-highlight" : "cc-area-light"]),
        onClick: withModifiers(onNetworkSelected, ["stop"])
      }, [
        isActiveNetwork.value ? (openBlock(), createElementBlock("i", _hoisted_1$r)) : createCommentVNode("", true),
        createBaseVNode("div", _hoisted_2$n, [
          createBaseVNode("img", {
            class: "cc-icon-round-lg",
            loading: "lazy",
            src: unref(icon),
            alt: "network logo",
            onError: _cache[0] || (_cache[0] = ($event) => isRef(icon) ? icon.value = "" : icon = "")
          }, null, 40, _hoisted_3$i)
        ]),
        createBaseVNode("div", _hoisted_4$h, [
          createVNode(_sfc_main$G, {
            label: unref(it)("common.network." + __props.uiNetworkId + ".label")
          }, null, 8, ["label"]),
          createVNode(_sfc_main$H, {
            text: unref(it)("common.network." + __props.uiNetworkId + ".description")
          }, null, 8, ["text"]),
          unref(link) ? (openBlock(), createBlock(_sfc_main$J, {
            key: 0,
            url: unref(link),
            label: unref(link),
            "label-c-s-s": "cc-text-semi-bold cc-text-color cc-text-highlight-hover",
            class: "mt-2 whitespace-nowrap"
          }, null, 8, ["url", "label"])) : createCommentVNode("", true)
        ])
      ], 2);
    };
  }
});
const _hoisted_1$q = { class: "grow-0 shrink-0 w-full flex flex-row flex-nowrap items-start justify-between border-b cc-p" };
const _hoisted_2$m = { class: "flex flex-col cc-text-sz" };
const _hoisted_3$h = { class: "col-span-12 flex flex-col flex-nowrap gap-2" };
const _hoisted_4$g = {
  key: 1,
  class: "p-4 flex flex-col flex-nowrap gap-2"
};
const _hoisted_5$e = { class: "capitalize mr-1" };
const _sfc_main$r = /* @__PURE__ */ defineComponent({
  __name: "NetworkBadge",
  setup(__props) {
    var _a;
    const { it } = useTranslation();
    const { reloadPreloader } = usePreloader();
    const networkGroupList = reactive([]);
    const networkGroupMap = /* @__PURE__ */ new Map();
    const networkGroupIds = Object.keys(networkGroups).sort((a, b) => b === "Cardano" ? 1 : a.localeCompare(b));
    for (let i = 0; i < networkGroupIds.length; i++) {
      const group = networkGroupIds[i];
      if (networkGroups[group].some((n2) => isEnabledNetworkId(n2))) {
        networkGroupList.push({ id: group, label: group, index: i });
      }
    }
    for (const ng in networkGroups) {
      const list = networkGroups[ng];
      for (const networkId2 of list) {
        networkGroupMap.set(networkId2, networkGroupList.find((n2) => n2.id === ng));
      }
    }
    const currentNetworkGroup = ref(((_a = networkGroupMap.get(networkId.value)) == null ? void 0 : _a.index) ?? 0);
    const showModal = ref(false);
    const initialized = computed(() => chainTip.value.onTip ?? false);
    const networkStatus = computed(() => initialized.value ? it("common.network." + networkId.value + ".badge") : it("common.network." + networkId.value + ".badge") + ": " + it("common.network.offline"));
    const getMainNetworkList = (networkList) => networkList.filter((n2) => !isTestnetNetwork(n2) && isEnabledNetworkId(n2));
    const getTestNetworkList = (networkList) => networkList.filter((n2) => isTestnetNetwork(n2) && isEnabledNetworkId(n2));
    const onClose = () => {
      showModal.value = false;
    };
    const onClickedBadge = () => {
      showModal.value = true;
    };
    function onNetworkSwitch(networkId2) {
      reloadPreloader();
      guardedUpdateNetworkId(networkId2, true);
      nextTick(() => {
        onClose();
      });
    }
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock(Fragment, null, [
        showModal.value ? (openBlock(), createBlock(Modal, {
          key: 0,
          narrow: "",
          "full-width-on-mobile": "",
          onClose
        }, {
          header: withCtx(() => [
            createBaseVNode("div", _hoisted_1$q, [
              createBaseVNode("div", _hoisted_2$m, [
                createVNode(_sfc_main$G, {
                  label: unref(it)("common.network.label")
                }, null, 8, ["label"])
              ])
            ])
          ]),
          content: withCtx(() => [
            networkGroupList.length > 1 ? (openBlock(), createBlock(_sfc_main$K, {
              key: 0,
              class: "p-3 sm:p-5",
              index: currentNetworkGroup.value,
              tabs: networkGroupList
            }, createSlots({ _: 2 }, [
              renderList(networkGroupList, (networkGroup, index) => {
                return {
                  name: `tab${index}`,
                  fn: withCtx(() => [
                    createBaseVNode("div", _hoisted_3$h, [
                      (openBlock(true), createElementBlock(Fragment, null, renderList(getMainNetworkList(unref(networkGroups)[networkGroup.id]), (network, networkIndex) => {
                        return openBlock(), createElementBlock("div", { key: networkIndex }, [
                          createVNode(_sfc_main$s, {
                            "ui-network-id": network,
                            onNetworkChange: onNetworkSwitch
                          }, null, 8, ["ui-network-id"])
                        ]);
                      }), 128)),
                      getTestNetworkList(unref(networkGroups)[networkGroup.id]) ? (openBlock(), createBlock(GridSpace, {
                        key: 0,
                        hr: "",
                        label: unref(it)("common.network.networks.test"),
                        "label-c-s-s": "cc-text-md"
                      }, null, 8, ["label"])) : createCommentVNode("", true),
                      (openBlock(true), createElementBlock(Fragment, null, renderList(getTestNetworkList(unref(networkGroups)[networkGroup.id]), (network, networkIndex) => {
                        return openBlock(), createElementBlock("div", { key: networkIndex }, [
                          createVNode(_sfc_main$s, {
                            "ui-network-id": network,
                            onNetworkChange: onNetworkSwitch
                          }, null, 8, ["ui-network-id"])
                        ]);
                      }), 128))
                    ])
                  ])
                };
              })
            ]), 1032, ["index", "tabs"])) : (openBlock(), createElementBlock("div", _hoisted_4$g, [
              (openBlock(true), createElementBlock(Fragment, null, renderList(getMainNetworkList(unref(networkGroups)["Cardano"]), (network, networkIndex) => {
                return openBlock(), createElementBlock("div", { key: networkIndex }, [
                  createVNode(_sfc_main$s, {
                    "ui-network-id": network,
                    onNetworkChange: onNetworkSwitch
                  }, null, 8, ["ui-network-id"])
                ]);
              }), 128)),
              getTestNetworkList(unref(networkGroups)["Cardano"]) ? (openBlock(), createBlock(GridSpace, {
                key: 0,
                hr: "",
                label: unref(it)("common.network.networks.test"),
                "label-c-s-s": "cc-text-md"
              }, null, 8, ["label"])) : createCommentVNode("", true),
              (openBlock(true), createElementBlock(Fragment, null, renderList(getTestNetworkList(unref(networkGroups)["Cardano"]), (network, networkIndex) => {
                return openBlock(), createElementBlock("div", { key: networkIndex }, [
                  createVNode(_sfc_main$s, {
                    "ui-network-id": network,
                    onNetworkChange: onNetworkSwitch
                  }, null, 8, ["ui-network-id"])
                ]);
              }), 128))
            ]))
          ]),
          _: 1
        })) : createCommentVNode("", true),
        unref(networkId) ? (openBlock(), createElementBlock("div", {
          key: 1,
          class: normalizeClass(["absolute top-0 right-0 pl-2 pr-1.5 py-0.5 whitespace-nowrap cc-rounded-la-r cc-text-medium cc-text-xs cursor-pointer", [initialized.value ? " cc-online bg-purple-700 dark:bg-purple-900" : " cc-offline "]]),
          onClick: withModifiers(onClickedBadge, ["stop"])
        }, [
          createBaseVNode("span", _hoisted_5$e, toDisplayString(networkStatus.value), 1),
          createBaseVNode("i", {
            class: normalizeClass(["text-xs -mt-0.5 mdi", initialized.value ? "mdi mdi-check-circle text-purple-400 dark:text-purple-600 " : "mdi mdi-error text-gray-500"])
          }, null, 2)
        ], 2)) : createCommentVNode("", true)
      ], 64);
    };
  }
});
const _hoisted_1$p = {
  class: "relative w-full cc-flex-fixed cc-layout-mt cc-site-max-width mx-auto mb-1 sm:mb-2",
  id: "cc-footer-container"
};
const _hoisted_2$l = { class: "whitespace-nowrap text-center flex flex-row flex-nowrap space-x-1.5" };
const _hoisted_3$g = { class: "cc-none xxs:block mr-1" };
const _hoisted_4$f = { key: 0 };
const _hoisted_5$d = { key: 1 };
const _hoisted_6$c = { key: 2 };
const _hoisted_7$a = { key: 3 };
const _hoisted_8$9 = { key: 4 };
const _hoisted_9$8 = { key: 5 };
const _hoisted_10$7 = { key: 6 };
const _hoisted_11$7 = ["href"];
const _hoisted_12$6 = ["href"];
const _hoisted_13$6 = ["href"];
const _sfc_main$q = /* @__PURE__ */ defineComponent({
  __name: "Footer",
  setup(__props) {
    const { c, it } = useTranslation();
    const { gotoPage } = useNavigation();
    const { closeMainMenu } = useMainMenuOpen();
    function onClickedImprint() {
      closeMainMenu();
      if (isSignMode()) ;
      else if (isEnableMode()) {
        gotoPage("Connect");
      } else {
        gotoPage("Imprint");
      }
    }
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("footer", _hoisted_1$p, [
        createBaseVNode("div", {
          class: normalizeClass(["relative w-full py-0.5 px-1.5 overflow-hidden cc-rounded-la cc-shadow cc-online cc-text-medium cc-text-xs flex sm:justify-center items-center", unref(c)("gradient")])
        }, [
          createBaseVNode("div", _hoisted_2$l, [
            createBaseVNode("button", {
              class: "flex flex-row flex-nowrap",
              onClick: withModifiers(onClickedImprint, ["stop"])
            }, [
              createBaseVNode("span", _hoisted_3$g, toDisplayString(unref(it)("footer.label") + (/* @__PURE__ */ new Date()).getFullYear()) + " ·", 1),
              unref(isBetaApp)() ? (openBlock(), createElementBlock("span", _hoisted_4$f, toDisplayString(unref(WALLET_VERSION_BETA)) + " (", 1)) : (openBlock(), createElementBlock("span", _hoisted_5$d, toDisplayString(unref(WALLET_VERSION)) + " (", 1)),
              unref(isBetaApp)() ? (openBlock(), createElementBlock("span", _hoisted_6$c, "beta - ")) : createCommentVNode("", true),
              unref(isStagingApp)() ? (openBlock(), createElementBlock("span", _hoisted_7$a, "*")) : createCommentVNode("", true),
              unref(isBexApp)() ? (openBlock(), createElementBlock("span", _hoisted_8$9, "extension")) : unref(isMobileApp)() ? (openBlock(), createElementBlock("span", _hoisted_9$8, "mobile")) : (openBlock(), createElementBlock("span", _hoisted_10$7, "web")),
              _cache[0] || (_cache[0] = createBaseVNode("span", { class: "mr-1" }, toDisplayString(") · "), -1)),
              createBaseVNode("span", null, toDisplayString(unref(it)("footer.imprint")), 1)
            ]),
            _cache[4] || (_cache[4] = createBaseVNode("span", null, toDisplayString(" · "), -1)),
            createBaseVNode("a", {
              href: unref(it)("common.url.twitter"),
              target: "_blank",
              rel: "noopener noreferrer"
            }, _cache[1] || (_cache[1] = [
              createBaseVNode("i", { class: "fa-brands fa-twitter" }, null, -1)
            ]), 8, _hoisted_11$7),
            createBaseVNode("a", {
              href: unref(it)("common.url.telegram"),
              target: "_blank",
              rel: "noopener noreferrer"
            }, _cache[2] || (_cache[2] = [
              createBaseVNode("i", { class: "fa-brands fa-telegram" }, null, -1)
            ]), 8, _hoisted_12$6),
            createBaseVNode("a", {
              href: unref(it)("common.url.discord"),
              target: "_blank",
              rel: "noopener noreferrer"
            }, _cache[3] || (_cache[3] = [
              createBaseVNode("i", { class: "fa-brands fa-discord" }, null, -1)
            ]), 8, _hoisted_13$6)
          ]),
          createVNode(_sfc_main$r)
        ], 2)
      ]);
    };
  }
});
const useBanner = (bannerId, timeOut = 23 * 60 * 60 * 1e3) => {
  const open = ref(true);
  const openBanner = () => {
    open.value = true;
  };
  const closeBanner = () => {
    open.value = false;
    setCloseBannerIdDate(bannerId);
  };
  const isBannerVisible = computed(() => getCloseBannerIdDate(bannerId) === 0 || getCloseBannerIdDate(bannerId) + timeOut < now$1());
  const isBannerOpen = computed(() => open.value && isBannerVisible.value);
  return {
    openBanner,
    closeBanner,
    isBannerOpen
  };
};
const checkExtensionExists = () => {
  var _a, _b;
  return ((_b = (_a = window == null ? void 0 : window.cardano) == null ? void 0 : _a.eternl) == null ? void 0 : _b.name) === "eternl";
};
const openExtensionOrStore = (target = "_self") => {
  if (checkExtensionExists()) {
    window.open("chrome-extension://kmhcihpebfmpgmihbkipmjlmmioameka/index.html", target);
  } else {
    window.open("https://chrome.google.com/webstore/detail/kmhcihpebfmpgmihbkipmjlmmioameka", target);
  }
};
const openHome = (target = "_self") => {
  window.open("https://eternl.io", target, "noopener,noreferrer");
};
const useExtension = () => {
  return {
    checkExtensionExists,
    openExtensionOrStore,
    openHome
  };
};
const _hoisted_1$o = {
  key: 0,
  class: "relative flex-grow-0 mb-1.5 w-full cc-rounded-la cc-banner-green flex justify-center items-center text-center p-1 sm:p-2 h-80"
};
const _hoisted_2$k = { class: "cc-text-extra-bold block text-base sm:text-lg sm:-mb-1" };
const _hoisted_3$f = { class: "cc-text-extra-bold block text-sm sm:text-base cc-text-blue" };
const _hoisted_4$e = { class: "cc-text-extra-bold block text-sm sm:text-base darker" };
const _sfc_main$p = /* @__PURE__ */ defineComponent({
  __name: "BannerMoving",
  setup(__props) {
    const { it } = useTranslation();
    const {
      isBannerOpen,
      closeBanner
    } = useBanner("moving");
    const {
      openHome: openHome2
    } = useExtension();
    function onClicked() {
      openHome2("_blank");
    }
    function onClickedClose() {
      closeBanner();
    }
    const _isBannerOpen = computed(() => doRestrictFeatures() && !isBexApp() && isNormalMode() && isBannerOpen.value);
    return (_ctx, _cache) => {
      return _isBannerOpen.value ? (openBlock(), createElementBlock("div", _hoisted_1$o, [
        createBaseVNode("div", {
          class: "cc-text-extra-bold w-full cursor-pointer",
          onClick: withModifiers(onClicked, ["stop"])
        }, [
          createBaseVNode("span", _hoisted_2$k, toDisplayString(unref(it)("banner.moving.line0.part0")), 1),
          createBaseVNode("span", _hoisted_3$f, [
            createTextVNode(toDisplayString(unref(it)("banner.moving.line1.part0")) + " ", 1),
            createBaseVNode("b", null, [
              createBaseVNode("i", null, [
                createBaseVNode("u", null, toDisplayString(unref(it)("banner.moving.line1.part1")), 1)
              ])
            ]),
            createTextVNode(" " + toDisplayString(unref(it)("banner.moving.line1.part2")), 1)
          ]),
          createBaseVNode("span", _hoisted_4$e, [
            createTextVNode(toDisplayString(unref(it)("banner.moving.line3.part0")) + " ", 1),
            createBaseVNode("i", null, toDisplayString(unref(it)("banner.moving.line3.part1")), 1),
            createTextVNode(" " + toDisplayString(unref(it)("banner.moving.line3.part2")), 1)
          ])
        ]),
        createVNode(_sfc_main$E, {
          class: "w-10 h-10 absolute -right-1 -top-1 text-xl sm:text-2xl darker",
          icon: "mdi mdi-close-box-outline",
          "aria-label": "hide banner",
          onClick: withModifiers(onClickedClose, ["stop"])
        })
      ])) : createCommentVNode("", true);
    };
  }
});
const _imports_0 = "/images/walletconnect.svg";
const _hoisted_1$n = { class: "flex-1 flex flex-col flex-nowrap -mt-0.5 text-left" };
const _hoisted_2$j = ["innerHTML"];
const _hoisted_3$e = ["innerHTML"];
const _sfc_main$o = /* @__PURE__ */ defineComponent({
  __name: "NavButton",
  props: {
    label: { type: String, required: false, default: null },
    caption: { type: String, required: false, default: null },
    icon: { type: String, required: false, default: null },
    link: { type: String, default: "" },
    openLink: { type: Boolean, required: false, default: true },
    showCaptionOnMobile: { type: Boolean, required: false, default: false }
  },
  emits: ["clicked"],
  setup(__props, { emit: __emit }) {
    const props = __props;
    const emit = __emit;
    const { gotoPage } = useNavigation();
    const { closeMainMenu } = useMainMenuOpen();
    function onClicked() {
      if (props.openLink === true) {
        gotoPage(props.link);
        closeMainMenu();
      } else {
        emit("clicked");
      }
    }
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("button", {
        class: "group px-2 flex-1 cc-rounded cc-text-medium flex flex-row flex-nowrap justify-center items-center",
        onClick: withModifiers(onClicked, ["stop"])
      }, [
        __props.icon ? (openBlock(), createElementBlock("i", {
          key: 0,
          class: normalizeClass(["mr-2 sm:mr-3 text-2xl mdi", __props.icon])
        }, null, 2)) : createCommentVNode("", true),
        createBaseVNode("span", _hoisted_1$n, [
          __props.label ? (openBlock(), createElementBlock("span", {
            key: 0,
            class: "",
            innerHTML: __props.label
          }, null, 8, _hoisted_2$j)) : createCommentVNode("", true),
          __props.caption ? (openBlock(), createElementBlock("span", {
            key: 1,
            class: normalizeClass(["cc-text-xs", __props.showCaptionOnMobile ? "" : " cc-none sm:block"]),
            innerHTML: __props.caption
          }, null, 10, _hoisted_3$e)) : createCommentVNode("", true)
        ])
      ]);
    };
  }
});
const _hoisted_1$m = { class: "flex flex-col" };
const _hoisted_2$i = { class: "font-black" };
const _hoisted_3$d = { class: "relative h-full flex flex-col flex-nowrap justify-center space-y-0.5 ml-2" };
const _hoisted_4$d = {
  class: "relative cc-text-sz cc-text-bold mr-1 flex-1 flex items-center justify-between",
  style: { "line-height": "0.9rem" }
};
const _hoisted_5$c = {
  class: "break-all text-sm cc-text-semi-bold",
  style: { "line-height": "0.9rem" }
};
const _hoisted_6$b = {
  key: 0,
  class: "mdi mdi-cash-lock text-md ml-px cc-text-highlight",
  style: { "line-height": "0.1rem" }
};
const _hoisted_7$9 = {
  key: 1,
  class: "mdi mdi-circle text-xs ml-px cc-text-green",
  style: { "line-height": "0.1rem" }
};
const _hoisted_8$8 = {
  key: 0,
  class: "mdi mdi-sync-alert text-2xl cc-text-yellow"
};
const _hoisted_9$7 = {
  key: 1,
  class: "p-2"
};
const _hoisted_10$6 = {
  key: 2,
  class: "mdi mdi-sync text-2xl cc-text-gray"
};
const _hoisted_11$6 = {
  key: 3,
  class: "mdi mdi-sync text-2xl cc-text-highlight"
};
const _hoisted_12$5 = {
  key: 0,
  class: "flex flex-col"
};
const _hoisted_13$5 = {
  key: 1,
  class: "flex flex-col"
};
const _sfc_main$n = /* @__PURE__ */ defineComponent({
  __name: "WalletListButtonV2",
  props: {
    walletId: { type: String, required: true }
  },
  setup(__props) {
    const props = __props;
    const { walletId } = toRefs(props);
    const appWallet = useAppWallet(walletId);
    useQuasar();
    const { c } = useTranslation();
    const { openWallet } = useNavigation();
    const { closeMainMenu } = useMainMenuOpen();
    const syncInfo = computed(() => {
      var _a;
      return (_a = appWallet.value) == null ? void 0 : _a.syncInfo;
    });
    const syncError = computed(() => {
      var _a;
      return (_a = syncInfo.value) == null ? void 0 : _a.error;
    });
    const isSyncing = computed(() => {
      var _a;
      return ((_a = syncInfo.value) == null ? void 0 : _a.state) === SyncState.syncing;
    });
    const isIdle = computed(() => {
      var _a;
      return ((_a = syncInfo.value) == null ? void 0 : _a.state) === SyncState.idle;
    });
    const canSync = computed(() => {
      var _a;
      if (isIdle.value) {
        const lastSyncTimestamp = ((_a = syncInfo.value) == null ? void 0 : _a.stateTimestamp) ?? 0;
        return timestampLocal.value - lastSyncTimestamp > MIN_SYNC_EXEC_DELAY_SEC * 1e3;
      }
      return false;
    });
    function onClickedOpen() {
      if (isNormalMode()) {
        openWallet(walletId.value);
        closeMainMenu();
      }
    }
    const onClickedSync = () => {
      if (walletId.value && appWallet.value) {
        dispatchSignalSync(doForceSyncAllAccounts + "_" + walletId.value);
      }
    };
    return (_ctx, _cache) => {
      var _a, _b, _c;
      return ((_a = unref(appWallet)) == null ? void 0 : _a.data) ? (openBlock(), createElementBlock("div", {
        key: 0,
        class: normalizeClass(["relative flex flex-row flex-nowrap space-x-px justify-between items-center cursor-pointer py-2 sm:py-2.5 mb-px min-h-16 h-16 cc-bg-light-0 border-l-4 pl-2.5 pr-1.5", unref(appWallet).isSelectedWallet ? unref(c)("border") : unref(c)("hover")]),
        onKeydown: [
          _cache[6] || (_cache[6] = withKeys(($event) => onClickedOpen(), ["enter"])),
          _cache[7] || (_cache[7] = withKeys(($event) => onClickedOpen(), ["space"]))
        ],
        onClick: _cache[8] || (_cache[8] = withModifiers(($event) => onClickedOpen(), ["stop"]))
      }, [
        syncError.value ? (openBlock(), createBlock(_sfc_main$C, {
          key: 0,
          ref: "tt0",
          anchor: "top middle",
          offset: [0, 32],
          "transition-show": "scale",
          "transition-hide": "scale"
        }, {
          default: withCtx(() => [
            createBaseVNode("div", _hoisted_1$m, [
              createBaseVNode("div", _hoisted_2$i, toDisplayString(syncError.value.error), 1),
              createBaseVNode("div", null, toDisplayString(syncError.value.info), 1)
            ])
          ]),
          _: 1
        }, 512)) : createCommentVNode("", true),
        createBaseVNode("div", {
          class: "flex-grow flex-shrink flex flex-row flex-nowrap justify-start items-center cursor-pointer",
          onKeydown: [
            _cache[0] || (_cache[0] = withKeys(($event) => onClickedOpen(), ["enter"])),
            _cache[1] || (_cache[1] = withKeys(($event) => onClickedOpen(), ["space"]))
          ],
          onClick: _cache[2] || (_cache[2] = withModifiers(($event) => onClickedOpen(), ["stop"])),
          tabindex: "0"
        }, [
          createVNode(_sfc_main$L, {
            "icon-seed": ((_b = unref(appWallet)) == null ? void 0 : _b.data.settings.plate.image) ?? void 0,
            "icon-data": unref(appWallet).data.settings.plate.data ?? void 0
          }, null, 8, ["icon-seed", "icon-data"]),
          createBaseVNode("div", _hoisted_3$d, [
            createBaseVNode("div", _hoisted_4$d, [
              createBaseVNode("div", _hoisted_5$c, [
                createTextVNode(toDisplayString((_c = unref(appWallet)) == null ? void 0 : _c.data.settings.name) + " ", 1),
                unref(appWallet).isReadOnly ? (openBlock(), createElementBlock("i", _hoisted_6$b)) : createCommentVNode("", true),
                unref(appWallet).isDappWallet ? (openBlock(), createElementBlock("i", _hoisted_7$9)) : createCommentVNode("", true)
              ])
            ]),
            createVNode(_sfc_main$M, {
              balance: !unref(appWallet).accountsLoaded ? void 0 : unref(appWallet).data.balance,
              field: "coin",
              syncing: isSyncing.value || !unref(appWallet).accountsLoaded || unref(appWallet).syncInfo.isInitializing,
              "sync-info": unref(appWallet).syncInfo,
              "overwrite-decimals": 2,
              "hide-sync-button": "",
              dense: "",
              "prevent-copy": ""
            }, null, 8, ["balance", "syncing", "sync-info"])
          ]),
          _cache[9] || (_cache[9] = createBaseVNode("div", { class: "flex-grow flex-shrink" }, null, -1))
        ], 32),
        unref(appWallet).accountsLoaded && (isSyncing.value || unref(appWallet).hasManualSyncAccount) ? (openBlock(), createElementBlock("div", {
          key: 1,
          class: normalizeClass(["flex-grow-0 flex-shrink-0 h-full w-8 flex justify-center items-center", [isSyncing.value ? "pointer-events-none" : "cursor-pointer"]]),
          onKeydown: [
            _cache[3] || (_cache[3] = withKeys(($event) => onClickedSync(), ["enter"])),
            _cache[4] || (_cache[4] = withKeys(($event) => onClickedSync(), ["space"]))
          ],
          onClick: _cache[5] || (_cache[5] = withModifiers(($event) => onClickedSync(), ["stop"])),
          tabindex: "0"
        }, [
          syncError.value ? (openBlock(), createElementBlock("i", _hoisted_8$8)) : isSyncing.value ? (openBlock(), createElementBlock("div", _hoisted_9$7, [
            createVNode(QSpinnerDots_default, { class: "h-full w-full" })
          ])) : !canSync.value ? (openBlock(), createElementBlock("i", _hoisted_10$6)) : (openBlock(), createElementBlock("i", _hoisted_11$6)),
          !isSyncing.value ? (openBlock(), createBlock(_sfc_main$C, {
            key: 4,
            anchor: "top middle",
            offset: [0, 32],
            "transition-show": "scale",
            "transition-hide": "scale",
            "auto-hide": ""
          }, {
            default: withCtx(() => [
              canSync.value ? (openBlock(), createElementBlock("div", _hoisted_12$5, _cache[10] || (_cache[10] = [
                createBaseVNode("div", { class: "font-black" }, "Click to sync.", -1),
                createBaseVNode("div", null, "Click to manually sync all accounts of this wallet.", -1)
              ]))) : (openBlock(), createElementBlock("div", _hoisted_13$5, _cache[11] || (_cache[11] = [
                createBaseVNode("div", { class: "font-black" }, "Wallet already up-to-date.", -1),
                createBaseVNode("div", null, "Please wait a short while until the next sync.", -1)
              ])))
            ]),
            _: 1
          })) : (openBlock(), createBlock(_sfc_main$C, {
            key: 5,
            anchor: "top middle",
            offset: [0, 32],
            "transition-show": "scale",
            "transition-hide": "scale",
            "auto-hide": ""
          }, {
            default: withCtx(() => _cache[12] || (_cache[12] = [
              createBaseVNode("div", { class: "flex flex-col" }, [
                createBaseVNode("div", { class: "font-black" }, "Sync in progress."),
                createBaseVNode("div", null, "Please wait for the sync to finish.")
              ], -1)
            ])),
            _: 1
          }))
        ], 34)) : createCommentVNode("", true)
      ], 34)) : createCommentVNode("", true);
    };
  }
});
const _hoisted_1$l = { class: "truncate flex flex-row flex-nowrap justify-center items-center" };
const _hoisted_2$h = { class: "cc-text-bold" };
const _sfc_main$m = /* @__PURE__ */ defineComponent({
  __name: "WalletListGroupV2",
  props: {
    groupName: { type: String, required: true },
    walletIdList: { type: Array, required: true }
  },
  setup(__props) {
    const props = __props;
    const { isSelectedWallet } = useSelectedAccount();
    const showWalletGroup = getWalletGroupOpen(props.groupName);
    const toggleShow = () => {
      toggleWalletGroupOpen(props.groupName);
    };
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock(Fragment, null, [
        createBaseVNode("div", {
          class: normalizeClass(["relative flex flex-row justify-between items-center cc-text-sz sm:cc-text-sx cc-nav-group pl-2 h-8 border-t border-b mb-px border-l-4 cursor-pointer", unref(showWalletGroup) ? "border-b" : ""]),
          onClick: withModifiers(toggleShow, ["stop"])
        }, [
          createBaseVNode("div", _hoisted_1$l, [
            createBaseVNode("i", {
              class: normalizeClass(["relative mr-1 text-xl", unref(showWalletGroup) ? "mdi mdi-chevron-down" : "mdi mdi-chevron-right"]),
              tabindex: "0",
              onKeydown: [
                withKeys(toggleShow, ["enter"]),
                withKeys(toggleShow, ["space"])
              ]
            }, null, 34),
            createBaseVNode("span", null, "(" + toDisplayString(__props.walletIdList.length) + ") ", 1),
            createBaseVNode("span", _hoisted_2$h, toDisplayString(__props.groupName), 1)
          ])
        ], 2),
        (openBlock(true), createElementBlock(Fragment, null, renderList(__props.walletIdList, (id) => {
          return openBlock(), createElementBlock("div", {
            key: "walletList_" + id
          }, [
            unref(showWalletGroup) || unref(isSelectedWallet)(id) ? (openBlock(), createBlock(_sfc_main$n, {
              key: 0,
              "wallet-id": id
            }, null, 8, ["wallet-id"])) : createCommentVNode("", true)
          ]);
        }), 128))
      ], 64);
    };
  }
});
const _hoisted_1$k = {
  key: 0,
  class: "flex justify-center p-2"
};
const _sfc_main$l = /* @__PURE__ */ defineComponent({
  __name: "WalletListV2",
  setup(__props) {
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock(Fragment, null, [
        (openBlock(true), createElementBlock(Fragment, null, renderList(unref(walletGroupNameList), (groupName) => {
          return openBlock(), createElementBlock("div", {
            key: "walletGroupNameList_" + groupName
          }, [
            createVNode(_sfc_main$m, {
              "group-name": groupName,
              "wallet-id-list": unref(walletGroupMap)[groupName]
            }, null, 8, ["group-name", "wallet-id-list"])
          ]);
        }), 128)),
        unref(isWalletListLoading) ? (openBlock(), createElementBlock("div", _hoisted_1$k, [
          createVNode(QSpinnerDots_default, {
            color: "gray",
            size: "2em"
          })
        ])) : createCommentVNode("", true)
      ], 64);
    };
  }
});
const persistStatus = {
  NOT_PERSISTABLE: 0,
  PROMPT_TO_PERSIST: 1,
  PERSISTED: 2
};
const QUOTA_LIMIT = 90;
const persist = async () => {
  return await navigator.storage && navigator.storage.persist ? navigator.storage.persist().catch((reason) => {
    console.error(reason);
    return false;
  }) : void 0;
};
const showEstimatedQuota = async () => {
  return await navigator.storage && navigator.storage.estimate ? navigator.storage.estimate() : void 0;
};
const tryPersistWithoutPromtingUser = async () => {
  if (!navigator.storage || !navigator.storage.persisted) {
    return persistStatus.NOT_PERSISTABLE;
  }
  let persisted = await navigator.storage.persisted();
  if (persisted) {
    return persistStatus.PERSISTED;
  }
  if (!navigator.permissions || !navigator.permissions.query) {
    return persistStatus.PROMPT_TO_PERSIST;
  }
  const permission = await navigator.permissions.query({
    name: "persistent-storage"
  });
  if (permission.state === "granted") {
    persisted = await navigator.storage.persist();
    if (persisted) {
      return persistStatus.PERSISTED;
    } else {
      throw new Error("Failed to persist");
    }
  }
  if (permission.state === "prompt") {
    return persistStatus.PROMPT_TO_PERSIST;
  }
  return persistStatus.NOT_PERSISTABLE;
};
const getStorageQuotaPercent = async () => {
  let estimatedQuota = await showEstimatedQuota();
  if ((estimatedQuota == null ? void 0 : estimatedQuota.usage) && (estimatedQuota == null ? void 0 : estimatedQuota.quota)) {
    return Math.round((estimatedQuota == null ? void 0 : estimatedQuota.usage) / (estimatedQuota == null ? void 0 : estimatedQuota.quota) * 1e4) / 100;
  }
  throw new Error("Can not determine quota.");
};
const _hoisted_1$j = { class: "col-span-12 grid grid-cols-12 cc-gap pl-6 pr-2" };
const _hoisted_2$g = { class: "grow-0 shrink-0 w-full flex flex-row flex-nowrap items-start justify-between border-b cc-p" };
const _hoisted_3$c = { class: "flex flex-col cc-text-sz" };
const _hoisted_4$c = ["innerHTML"];
const _hoisted_5$b = { class: "p-4" };
const _hoisted_6$a = {
  key: 1,
  class: "col-span-12 flex"
};
const _hoisted_7$8 = { class: "w-full" };
const _hoisted_8$7 = { class: "float-left mr-2 justify-center align-middle content-center py-2" };
const _hoisted_9$6 = {
  class: "text-red-600",
  style: { "width": "24px", "height": "24px" },
  viewBox: "0 0 24 24"
};
const _hoisted_10$5 = {
  key: 2,
  class: "col-span-12 flex"
};
const _hoisted_11$5 = { class: "w-full" };
const _hoisted_12$4 = { class: "float-left mr-2 justify-center align-middle content-center py-4" };
const _hoisted_13$4 = {
  class: "text-yellow-600",
  style: { "width": "32px", "height": "32px" },
  viewBox: "0 0 24 24"
};
const _hoisted_14$4 = {
  key: 3,
  class: "col-span-12 flex cc-area-light p-2"
};
const _hoisted_15$4 = {
  key: 4,
  class: "col-span-12 flex"
};
const _hoisted_16$4 = { class: "w-full flex flex-row flex-nowrap" };
const _hoisted_17$4 = { class: "float-left h-auto justify-center align-middle content-center" };
const _hoisted_18$3 = {
  key: 0,
  class: "text-green-600 mr-2",
  style: { "width": "24px", "height": "24px" },
  viewBox: "0 0 24 24"
};
const _hoisted_19$3 = {
  key: 1,
  class: "text-yellow-600 mr-2 mt-4",
  style: { "width": "24px", "height": "24px" },
  viewBox: "0 0 24 24"
};
const _hoisted_20$3 = ["innerHTML"];
const _hoisted_21$3 = ["innerHTML"];
const _hoisted_22$3 = ["innerHTML"];
const _hoisted_23$1 = { class: "w-full flex mt-5" };
const _hoisted_24$1 = ["innerHTML"];
const _sfc_main$k = /* @__PURE__ */ defineComponent({
  __name: "StorageApi",
  setup(__props) {
    const { it } = useTranslation();
    const $q = useQuasar();
    const supportPersisting = ref(false);
    const needsPersisting = ref(false);
    const quota = ref("0");
    const quotaLimit = ref(QUOTA_LIMIT);
    const showQuotaWarning = ref(false);
    const showQuotaFull = ref(false);
    const showDescription = ref(false);
    const showModal = ref(false);
    const showModalType = ref("chrome");
    const quotaText = computed(
      () => {
        var _a;
        return ((_a = it("preferences.storage.quota.lowOnSpace")) == null ? void 0 : _a.replace("###LIMIT###", quotaLimit.value + "")) ?? it("preferences.storage.quota.lowOnSpace");
      }
    );
    const toggleDescription = () => {
      showDescription.value = !showDescription.value;
    };
    async function updateStatus() {
      const persistingStatus = await tryPersistWithoutPromtingUser();
      const isBrave = navigator.brave && await navigator.brave.isBrave() || false;
      if (isBrave) {
        supportPersisting.value = false;
        needsPersisting.value = false;
      } else if (persistingStatus === persistStatus.NOT_PERSISTABLE) {
        supportPersisting.value = false;
        needsPersisting.value = true;
      } else if (persistingStatus === persistStatus.PROMPT_TO_PERSIST) {
        supportPersisting.value = true;
        needsPersisting.value = true;
      } else if (persistingStatus === persistStatus.PERSISTED) {
        supportPersisting.value = true;
        needsPersisting.value = false;
        try {
          const estimatedQuota = await getStorageQuotaPercent();
          quota.value = estimatedQuota + "%";
          if (estimatedQuota > 90 && estimatedQuota < 100) {
            showQuotaWarning.value = true;
          } else if (estimatedQuota >= 100) {
            showQuotaFull.value = true;
          }
        } catch (e) {
          quota.value = it("preferences.storage.quota.unkown");
        }
      }
    }
    onMounted(() => {
      updateStatus();
    });
    const setAllowance = async () => {
      showModal.value = true;
      await setStorageAllowance();
      showModal.value = false;
    };
    const setStorageAllowance = async () => {
      const success = await persist();
      if (success) {
        supportPersisting.value = true;
        needsPersisting.value = false;
        updateStatus();
        $q.notify({
          type: "positive",
          message: it("preferences.storage.allow.success"),
          position: "top-left",
          timeout: 3e3
        });
      } else {
        $q.notify({
          type: "negative",
          message: it("preferences.storage.allow.fail"),
          position: "top-left",
          timeout: 3e3
        });
      }
    };
    const onClose = () => {
      showModal.value = false;
    };
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", _hoisted_1$j, [
        showModal.value ? (openBlock(), createBlock(Modal, {
          key: 0,
          narrow: "",
          "full-width-on-mobile": "",
          onClose
        }, {
          header: withCtx(() => [
            createBaseVNode("div", _hoisted_2$g, [
              createBaseVNode("div", _hoisted_3$c, [
                createVNode(_sfc_main$G, {
                  label: unref(it)("preferences.storage." + showModalType.value + ".modal.label")
                }, null, 8, ["label"])
              ])
            ])
          ]),
          content: withCtx(() => [
            createBaseVNode("div", {
              class: "p-4",
              innerHTML: unref(it)("preferences.storage." + showModalType.value + ".modal.info")
            }, null, 8, _hoisted_4$c),
            createBaseVNode("div", _hoisted_5$b, [
              createVNode(_sfc_main$I, {
                label: unref(it)("preferences.storage." + showModalType.value + ".modal.button"),
                link: setAllowance,
                class: "mt-2 px-2"
              }, null, 8, ["label"])
            ])
          ]),
          _: 1
        })) : createCommentVNode("", true),
        !supportPersisting.value && needsPersisting.value ? (openBlock(), createElementBlock("div", _hoisted_6$a, [
          createBaseVNode("div", _hoisted_7$8, [
            createBaseVNode("div", _hoisted_8$7, [
              (openBlock(), createElementBlock("svg", _hoisted_9$6, _cache[0] || (_cache[0] = [
                createBaseVNode("path", {
                  fill: "currentColor",
                  d: "M12,2L1,21H23M12,6L19.53,19H4.47M11,10V14H13V10M11,16V18H13V16"
                }, null, -1)
              ])))
            ]),
            createBaseVNode("div", null, [
              createTextVNode(toDisplayString(unref(it)("preferences.storage.status.noSupport")) + " ", 1),
              _cache[1] || (_cache[1] = createBaseVNode("br", null, null, -1)),
              createTextVNode(" " + toDisplayString(unref(it)("preferences.storage.status.supportedBrowsers")), 1)
            ])
          ])
        ])) : createCommentVNode("", true),
        supportPersisting.value && needsPersisting.value ? (openBlock(), createElementBlock("div", _hoisted_10$5, [
          createBaseVNode("div", _hoisted_11$5, [
            createBaseVNode("div", _hoisted_12$4, [
              (openBlock(), createElementBlock("svg", _hoisted_13$4, _cache[2] || (_cache[2] = [
                createBaseVNode("path", {
                  fill: "currentColor",
                  d: "M12,2L1,21H23M12,6L19.53,19H4.47M11,10V14H13V10M11,16V18H13V16"
                }, null, -1)
              ])))
            ]),
            createBaseVNode("div", null, [
              createTextVNode(toDisplayString(unref(it)("preferences.storage.status.notPersisted")) + " ", 1),
              _cache[3] || (_cache[3] = createBaseVNode("br", null, null, -1)),
              createVNode(_sfc_main$I, {
                label: unref(it)("preferences.storage.button.label"),
                link: setAllowance,
                class: "mt-2 px-2"
              }, null, 8, ["label"])
            ])
          ])
        ])) : createCommentVNode("", true),
        needsPersisting.value ? (openBlock(), createElementBlock("div", _hoisted_14$4, [
          createBaseVNode("i", {
            class: "mdi mdi-information-outline cursor-pointer pointer-events-auto mr-1",
            onClick: toggleDescription
          }),
          createVNode(_sfc_main$H, {
            class: "cc-text-semi-bold inline-block",
            text: unref(it)("preferences.storage.description.label")
          }, null, 8, ["text"]),
          createVNode(GridSpace, {
            hr: "",
            class: "mt-1 mb-3"
          }),
          showDescription.value ? (openBlock(), createBlock(_sfc_main$H, {
            key: 0,
            text: unref(it)("preferences.storage.description.caption")
          }, null, 8, ["text"])) : createCommentVNode("", true)
        ])) : createCommentVNode("", true),
        supportPersisting.value && !needsPersisting.value ? (openBlock(), createElementBlock("div", _hoisted_15$4, [
          createBaseVNode("div", _hoisted_16$4, [
            createBaseVNode("div", _hoisted_17$4, [
              !showQuotaWarning.value && !showQuotaFull.value ? (openBlock(), createElementBlock("svg", _hoisted_18$3, _cache[4] || (_cache[4] = [
                createBaseVNode("path", {
                  fill: "currentColor",
                  d: "M9,20.42L2.79,14.21L5.62,11.38L9,14.77L18.88,4.88L21.71,7.71L9,20.42Z"
                }, null, -1)
              ]))) : createCommentVNode("", true),
              showQuotaWarning.value || showQuotaFull.value ? (openBlock(), createElementBlock("svg", _hoisted_19$3, _cache[5] || (_cache[5] = [
                createBaseVNode("path", {
                  fill: "currentColor",
                  d: "M12,2L1,21H23M12,6L19.53,19H4.47M11,10V14H13V10M11,16V18H13V16"
                }, null, -1)
              ]))) : createCommentVNode("", true)
            ]),
            !showQuotaWarning.value && !showQuotaFull.value ? (openBlock(), createElementBlock("div", {
              key: 0,
              innerHTML: unref(it)("preferences.storage.status.persisted")
            }, null, 8, _hoisted_20$3)) : createCommentVNode("", true),
            showQuotaWarning.value ? (openBlock(), createElementBlock("div", {
              key: 1,
              innerHTML: quotaText.value
            }, null, 8, _hoisted_21$3)) : createCommentVNode("", true),
            showQuotaFull.value ? (openBlock(), createElementBlock("div", {
              key: 2,
              innerHTML: unref(it)("preferences.storage.quota.full")
            }, null, 8, _hoisted_22$3)) : createCommentVNode("", true)
          ]),
          createBaseVNode("div", _hoisted_23$1, [
            createBaseVNode("div", {
              innerHTML: unref(it)("preferences.storage.quota.label") + " " + quota.value
            }, null, 8, _hoisted_24$1)
          ])
        ])) : createCommentVNode("", true)
      ]);
    };
  }
});
const _sfc_main$j = /* @__PURE__ */ defineComponent({
  __name: "Checkbox",
  props: {
    id: { type: String, required: true },
    label: { type: String, required: false, default: "" },
    labelHover: { type: String, required: false, default: "" },
    customCSS: { type: String, required: false, default: "cursor-pointer flex flex-row items-center justify-center" },
    labelRight: { type: Boolean, required: false, default: true },
    labelCSS: { type: String, required: false, default: "ml-1" },
    checkIcon: { type: String, required: false, default: "mdi mdi-checkbox-blank-outline" },
    checkIconCheck: { type: String, required: false, default: "mdi mdi-checkbox-marked-outline" },
    iconCSS: { type: String, required: false, default: "" },
    defaultValue: { type: Boolean, required: false, default: false },
    disabled: { type: Boolean, required: false, default: false }
  },
  emits: ["checkToggle"],
  setup(__props, { emit: __emit }) {
    const props = __props;
    const emit = __emit;
    const iconStyle = computed(() => (checked.value ? props.checkIconCheck : props.checkIcon) + " " + props.iconCSS);
    const checked = ref(props.defaultValue);
    watch(() => props.defaultValue, (newValue) => {
      checked.value = newValue;
    });
    function onCheckboxToggle() {
      if (props.disabled) {
        return;
      }
      checked.value = !checked.value;
      emit("checkToggle", { id: props.id, checked: checked.value });
    }
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", {
        class: normalizeClass((__props.disabled ? "text-gray-400" : "") + " " + __props.customCSS),
        onClick: withModifiers(onCheckboxToggle, ["stop"])
      }, [
        __props.label && !__props.labelRight ? (openBlock(), createElementBlock("div", {
          key: 0,
          class: normalizeClass(["mr-1", __props.labelCSS])
        }, toDisplayString(__props.label), 3)) : createCommentVNode("", true),
        createBaseVNode("i", {
          class: normalizeClass(iconStyle.value)
        }, null, 2),
        __props.label && __props.labelRight ? (openBlock(), createElementBlock("div", {
          key: 1,
          class: normalizeClass(__props.labelCSS)
        }, toDisplayString(__props.label), 3)) : createCommentVNode("", true),
        __props.labelHover ? (openBlock(), createBlock(_sfc_main$C, {
          key: 2,
          "transition-show": "scale",
          "transition-hide": "scale"
        }, {
          default: withCtx(() => [
            createTextVNode(toDisplayString(__props.labelHover), 1)
          ]),
          _: 1
        })) : createCommentVNode("", true)
      ], 2);
    };
  }
});
const _hoisted_1$i = { class: "col-span-12 grid grid-cols-12 cc-gap pl-6 pr-2" };
const _hoisted_2$f = { class: "col-span-12 xs:col-span-7 sm:col-span-6 grid grid-cols-12 cc-gap" };
const _hoisted_3$b = ["selected", "value"];
const _hoisted_4$b = { class: "col-span-12 break-normal whitespace-pre-wrap" };
const _hoisted_5$a = ["selected", "value"];
const _hoisted_6$9 = { class: "col-span-12 xs:col-span-5 sm:col-span-6 flex flex-col flex-nowrap justify-start xs:items-end" };
const _hoisted_7$7 = { class: "cc-text-sz" };
const _sfc_main$i = /* @__PURE__ */ defineComponent({
  __name: "Formatting",
  setup(__props) {
    const { it } = useTranslation();
    const $q = useQuasar();
    const {
      formatDatetime
    } = useFormatter();
    const languageOptions = languageTags.sort((a, b) => a.region.localeCompare(b.region, "en-US"));
    const regions = languageTags.map((l2) => l2.region);
    const duplicateRegions = regions.filter((item, index) => regions.indexOf(item) !== index);
    const datetimeString = ref(formatDatetime(now$1()));
    async function onLanguageTagChange(event) {
      const selectedValue = event.target.options[event.target.options.selectedIndex].value;
      setAppLanguageTag(languageOptions.find((item) => item.languageTag === selectedValue) ?? defaultLanguageTag);
      datetimeString.value = formatDatetime(now$1());
      $q.notify({
        type: "positive",
        message: it("preferences.save"),
        position: "top-left",
        timeout: 4e3
      });
    }
    async function onTimezoneChange(event) {
      const selectedValue = event.target.options[event.target.options.selectedIndex].value;
      setAppTimezone(selectedValue ?? defaultTimezone);
      $q.notify({
        type: "positive",
        message: it("preferences.save"),
        position: "top-left",
        timeout: 4e3
      });
    }
    function onTimezoneToggle(event) {
      setUseUtc(event.checked);
      datetimeString.value = formatDatetime(now$1());
    }
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", _hoisted_1$i, [
        createBaseVNode("div", _hoisted_2$f, [
          createBaseVNode("select", {
            class: "col-span-12 cc-rounded-la cc-dropdown cc-text-sm",
            required: true,
            onChange: _cache[0] || (_cache[0] = ($event) => onLanguageTagChange($event))
          }, [
            (openBlock(true), createElementBlock(Fragment, null, renderList(unref(languageOptions), (tag) => {
              return openBlock(), createElementBlock("option", {
                key: tag.languageTag,
                selected: tag.languageTag === unref(appLanguageTag).languageTag,
                value: tag.languageTag
              }, toDisplayString(unref(duplicateRegions).includes(tag.region) ? `${tag.region} (${tag.language})` : tag.region), 9, _hoisted_3$b);
            }), 128))
          ], 32),
          createBaseVNode("div", _hoisted_4$b, toDisplayString(unref(it)("preferences.localization.timezone.caption")), 1),
          createBaseVNode("select", {
            class: "col-span-12 cc-rounded-la cc-dropdown cc-text-sm",
            required: true,
            onChange: _cache[1] || (_cache[1] = ($event) => onTimezoneChange($event))
          }, [
            (openBlock(true), createElementBlock(Fragment, null, renderList(unref(supportedTimezones), (tz) => {
              return openBlock(), createElementBlock("option", {
                key: tz,
                selected: tz === unref(appTimezone),
                value: tz
              }, toDisplayString(tz), 9, _hoisted_5$a);
            }), 128))
          ], 32),
          createVNode(_sfc_main$j, {
            id: "timezoneUTC",
            label: unref(it)("preferences.localization.formatting.timezone"),
            "label-c-s-s": "ml-2",
            "custom-c-s-s": "col-span-12 cursor-pointer flex flex-row flex-nowrap items-center justify-start mt-2",
            "default-value": unref(appUseUtc),
            onCheckToggle: onTimezoneToggle
          }, null, 8, ["label", "default-value"])
        ]),
        createVNode(GridSpace, {
          hr: "",
          class: "xs:cc-none my-1"
        }),
        createBaseVNode("div", _hoisted_6$9, [
          createBaseVNode("span", _hoisted_7$7, toDisplayString(datetimeString.value), 1),
          createVNode(_sfc_main$F, {
            amount: "1234567890",
            "text-c-s-s": "mb-1"
          })
        ])
      ]);
    };
  }
});
const _hoisted_1$h = { class: "col-span-12 grid grid-cols-12 cc-gap pl-6 pr-2" };
const _hoisted_2$e = ["selected", "value"];
const _sfc_main$h = /* @__PURE__ */ defineComponent({
  __name: "CurrencyConversion",
  props: {
    hideConversion: { type: Boolean, required: false, default: false }
  },
  setup(__props) {
    const { it } = useTranslation();
    const $q = useQuasar();
    const {
      activeCurrency,
      setActiveCurrency
    } = useCurrencyAPI();
    const currencyOptions = computed(() => [
      createICurrencyItem({ id: "Disable", value: 0, symbol: "" }),
      ...appCurrencies.value.currencies.sort((a, b) => (a.id ?? "?").localeCompare(b.id ?? "?", "en-US"))
    ]);
    async function onCurrencyChange(event) {
      const selectedValue = event.target.options[event.target.options.selectedIndex].value.toLowerCase();
      setAppCurrency(selectedValue);
      setActiveCurrency(selectedValue);
      $q.notify({
        type: "positive",
        message: it("preferences.save"),
        position: "top-left",
        timeout: 4e3
      });
    }
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", _hoisted_1$h, [
        createBaseVNode("select", {
          class: "col-span-12 xs:col-span-6 cc-rounded-la cc-dropdown cc-text-sm",
          required: true,
          onChange: _cache[0] || (_cache[0] = ($event) => onCurrencyChange($event))
        }, [
          (openBlock(true), createElementBlock(Fragment, null, renderList(currencyOptions.value, (currency) => {
            var _a;
            return openBlock(), createElementBlock("option", {
              key: currency.id,
              selected: currency.id === unref(activeCurrency).id,
              value: currency.id
            }, toDisplayString(currency.id === "Disable" ? unref(it)("common.label.disabled") : (_a = currency.id) == null ? void 0 : _a.toUpperCase()), 9, _hoisted_2$e);
          }), 128))
        ], 32),
        createVNode(GridSpace, {
          hr: "",
          class: "xs:cc-none mb-1 mt-3"
        }),
        createVNode(_sfc_main$v, { class: "col-span-12 xs:col-span-6 xs:justify-end items-center" })
      ]);
    };
  }
});
const _hoisted_1$g = { class: "col-span-12 flex flex-col flex-nowrap pl-6 pr-2 space-y-2" };
const _hoisted_2$d = {
  key: 0,
  class: "flex flex-row flex-nowrap justify-start items-center space-x-2"
};
const _hoisted_3$a = { class: "w-20 sm:w-32 flex justify-start items-center" };
const _hoisted_4$a = ["selected", "value"];
const _hoisted_5$9 = {
  key: 1,
  class: "flex flex-row flex-nowrap justify-start items-center space-x-2"
};
const _hoisted_6$8 = { class: "w-20 sm:w-32 flex justify-start items-center" };
const _hoisted_7$6 = ["selected", "value"];
const _hoisted_8$6 = {
  key: 2,
  class: "flex flex-row flex-nowrap justify-start items-center space-x-2"
};
const _hoisted_9$5 = { class: "w-20 sm:w-32 flex justify-start items-center" };
const _hoisted_10$4 = ["selected", "value"];
const _hoisted_11$4 = {
  key: 3,
  class: "flex flex-row flex-nowrap justify-start items-center space-x-2"
};
const _hoisted_12$3 = { class: "w-20 sm:w-32 flex justify-start items-center" };
const _hoisted_13$3 = ["selected", "value"];
const _hoisted_14$3 = {
  key: 4,
  class: "flex flex-row flex-nowrap justify-start items-center space-x-2"
};
const _hoisted_15$3 = { class: "w-20 sm:w-32 flex justify-start items-center" };
const _hoisted_16$3 = ["selected", "value"];
const _hoisted_17$3 = {
  key: 5,
  class: "flex flex-row flex-nowrap justify-start items-center space-x-2"
};
const _hoisted_18$2 = { class: "w-20 sm:w-32 flex justify-start items-center" };
const _hoisted_19$2 = ["selected", "value"];
const _hoisted_20$2 = {
  key: 6,
  class: "flex flex-row flex-nowrap justify-start items-center space-x-2"
};
const _hoisted_21$2 = { class: "w-20 sm:w-32 flex justify-start items-center" };
const _hoisted_22$2 = ["selected", "value"];
const _sfc_main$g = /* @__PURE__ */ defineComponent({
  __name: "BlockchainExplorer",
  setup(__props) {
    var _a, _b, _c, _d, _e, _f, _g;
    const { t, itd } = useTranslation();
    const {
      getExplorerList,
      getExplorerByType,
      setExplorerByType
    } = useExplorer();
    const $q = useQuasar();
    const activeBlockExplorer = ((_a = getExplorerByType("block")) == null ? void 0 : _a.id) ?? null;
    const activePoolExplorer = ((_b = getExplorerByType("pool")) == null ? void 0 : _b.id) ?? null;
    const activeAddressExplorer = ((_c = getExplorerByType("address")) == null ? void 0 : _c.id) ?? null;
    const activeStakeAddressExplorer = ((_d = getExplorerByType("stake")) == null ? void 0 : _d.id) ?? null;
    const activeTokenExplorer = ((_e = getExplorerByType("token")) == null ? void 0 : _e.id) ?? null;
    const activePolicyExplorer = ((_f = getExplorerByType("policy")) == null ? void 0 : _f.id) ?? null;
    const activeTransactionExplorer = ((_g = getExplorerByType("transaction")) == null ? void 0 : _g.id) ?? null;
    let blockExplorerList = [];
    let poolExplorerList = [];
    let stakeAddressExplorerList = [];
    let addressExplorerList = [];
    let tokenExplorerList = [];
    let policyExplorerList = [];
    let transactionExplorerList = [];
    const createFrontendExplorersList = () => {
      getExplorerList().map((c) => {
        if (c.blocksUrl) blockExplorerList.push({ value: c.id, caption: c.abbrev });
        if (c.poolUrl) poolExplorerList.push({ value: c.id, caption: c.abbrev });
        if (c.addressUrl) addressExplorerList.push({ value: c.id, caption: c.abbrev });
        if (c.stakeUrl) stakeAddressExplorerList.push({ value: c.id, caption: c.abbrev });
        if (c.tokenUrl) tokenExplorerList.push({ value: c.id, caption: c.abbrev });
        if (c.policyUrl) policyExplorerList.push({ value: c.id, caption: c.abbrev });
        if (c.txUrl) transactionExplorerList.push({ value: c.id, caption: c.abbrev });
      });
    };
    createFrontendExplorersList();
    function showSaved() {
      $q.notify({
        type: "positive",
        message: itd("preferences.save"),
        position: "top-left",
        timeout: 4e3
      });
    }
    const dispatchChangeEvent = () => {
      window.dispatchEvent(new CustomEvent("explorer-changed"));
    };
    function onExplorerChange(type, event) {
      setExplorerByType(type, event.target.options[event.target.options.selectedIndex].value);
      dispatchChangeEvent();
      showSaved();
    }
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", _hoisted_1$g, [
        unref(addressExplorerList).length > 0 ? (openBlock(), createElementBlock("div", _hoisted_2$d, [
          createBaseVNode("span", _hoisted_3$a, toDisplayString(unref(t)("setting.explorer.types.address")), 1),
          createBaseVNode("select", {
            class: "grow cc-rounded-la cc-dropdown cc-text-sm",
            required: true,
            onChange: _cache[0] || (_cache[0] = ($event) => onExplorerChange("address", $event))
          }, [
            (openBlock(true), createElementBlock(Fragment, null, renderList(unref(addressExplorerList), (explorer) => {
              return openBlock(), createElementBlock("option", {
                key: explorer,
                selected: explorer.value === unref(activeAddressExplorer),
                value: explorer.value
              }, toDisplayString(explorer.caption), 9, _hoisted_4$a);
            }), 128))
          ], 32)
        ])) : createCommentVNode("", true),
        unref(stakeAddressExplorerList).length > 0 ? (openBlock(), createElementBlock("div", _hoisted_5$9, [
          createBaseVNode("span", _hoisted_6$8, toDisplayString(unref(t)("setting.explorer.types.stake")), 1),
          createBaseVNode("select", {
            class: "grow cc-rounded-la cc-dropdown cc-text-sm",
            required: true,
            onChange: _cache[1] || (_cache[1] = ($event) => onExplorerChange("stake", $event))
          }, [
            (openBlock(true), createElementBlock(Fragment, null, renderList(unref(stakeAddressExplorerList), (explorer) => {
              return openBlock(), createElementBlock("option", {
                key: explorer,
                selected: explorer.value === unref(activeStakeAddressExplorer),
                value: explorer.value
              }, toDisplayString(explorer.caption), 9, _hoisted_7$6);
            }), 128))
          ], 32)
        ])) : createCommentVNode("", true),
        unref(blockExplorerList).length > 0 ? (openBlock(), createElementBlock("div", _hoisted_8$6, [
          createBaseVNode("span", _hoisted_9$5, toDisplayString(unref(t)("setting.explorer.types.block")), 1),
          createBaseVNode("select", {
            class: "grow cc-rounded-la cc-dropdown cc-text-sm",
            required: true,
            onChange: _cache[2] || (_cache[2] = ($event) => onExplorerChange("block", $event))
          }, [
            (openBlock(true), createElementBlock(Fragment, null, renderList(unref(blockExplorerList), (explorer) => {
              return openBlock(), createElementBlock("option", {
                key: explorer,
                selected: explorer.value === unref(activeBlockExplorer),
                value: explorer.value
              }, toDisplayString(explorer.caption), 9, _hoisted_10$4);
            }), 128))
          ], 32)
        ])) : createCommentVNode("", true),
        unref(poolExplorerList).length > 0 ? (openBlock(), createElementBlock("div", _hoisted_11$4, [
          createBaseVNode("span", _hoisted_12$3, toDisplayString(unref(t)("setting.explorer.types.pool")), 1),
          createBaseVNode("select", {
            class: "grow cc-rounded-la cc-dropdown cc-text-sm",
            required: true,
            onChange: _cache[3] || (_cache[3] = ($event) => onExplorerChange("pool", $event))
          }, [
            (openBlock(true), createElementBlock(Fragment, null, renderList(unref(poolExplorerList), (explorer) => {
              return openBlock(), createElementBlock("option", {
                key: explorer,
                selected: explorer.value === unref(activePoolExplorer),
                value: explorer.value
              }, toDisplayString(explorer.caption), 9, _hoisted_13$3);
            }), 128))
          ], 32)
        ])) : createCommentVNode("", true),
        unref(tokenExplorerList).length > 0 ? (openBlock(), createElementBlock("div", _hoisted_14$3, [
          createBaseVNode("span", _hoisted_15$3, toDisplayString(unref(t)("setting.explorer.types.token")), 1),
          createBaseVNode("select", {
            class: "grow cc-rounded-la cc-dropdown cc-text-sm",
            required: true,
            onChange: _cache[4] || (_cache[4] = ($event) => onExplorerChange("token", $event))
          }, [
            (openBlock(true), createElementBlock(Fragment, null, renderList(unref(tokenExplorerList), (explorer) => {
              return openBlock(), createElementBlock("option", {
                key: explorer,
                selected: explorer.value === unref(activeTokenExplorer),
                value: explorer.value
              }, toDisplayString(explorer.caption), 9, _hoisted_16$3);
            }), 128))
          ], 32)
        ])) : createCommentVNode("", true),
        unref(policyExplorerList).length > 0 ? (openBlock(), createElementBlock("div", _hoisted_17$3, [
          createBaseVNode("span", _hoisted_18$2, toDisplayString(unref(t)("setting.explorer.types.policy")), 1),
          createBaseVNode("select", {
            class: "grow cc-rounded-la cc-dropdown cc-text-sm",
            required: true,
            onChange: _cache[5] || (_cache[5] = ($event) => onExplorerChange("policy", $event))
          }, [
            (openBlock(true), createElementBlock(Fragment, null, renderList(unref(policyExplorerList), (explorer) => {
              return openBlock(), createElementBlock("option", {
                key: explorer,
                selected: explorer.value === unref(activePolicyExplorer),
                value: explorer.value
              }, toDisplayString(explorer.caption), 9, _hoisted_19$2);
            }), 128))
          ], 32)
        ])) : createCommentVNode("", true),
        unref(transactionExplorerList).length > 0 ? (openBlock(), createElementBlock("div", _hoisted_20$2, [
          createBaseVNode("span", _hoisted_21$2, toDisplayString(unref(t)("setting.explorer.types.transaction")), 1),
          createBaseVNode("select", {
            class: "grow cc-rounded-la cc-dropdown cc-text-sm",
            required: true,
            onChange: _cache[6] || (_cache[6] = ($event) => onExplorerChange("transaction", $event))
          }, [
            (openBlock(true), createElementBlock(Fragment, null, renderList(unref(transactionExplorerList), (explorer) => {
              return openBlock(), createElementBlock("option", {
                key: explorer,
                selected: explorer.value === unref(activeTransactionExplorer),
                value: explorer.value
              }, toDisplayString(explorer.caption), 9, _hoisted_22$2);
            }), 128))
          ], 32)
        ])) : createCommentVNode("", true)
      ]);
    };
  }
});
var define_process_env_default = {};
const _hoisted_1$f = { class: "col-span-12 grid grid-cols-12 cc-gap pl-6 pr-2" };
const _hoisted_2$c = { class: "col-span-12 lg:col-span-8 grid grid-cols-12" };
const _hoisted_3$9 = ["selected", "value"];
const _hoisted_4$9 = { class: "col-span-12 p-2 grid grid-cols-12 cc-gap ring-2 ring-yellow-500 cc-rounded mb-2 mt-3" };
const _hoisted_5$8 = { class: "col-span-12 flex flex-row flex-nowrap whitespace-pre-wrap text-yellow-500 cc-text-bold" };
const _hoisted_6$7 = { class: "col-span-12" };
const _hoisted_7$5 = { class: "mt-3" };
const _hoisted_8$5 = {
  key: 0,
  class: "mt-3"
};
const _hoisted_9$4 = { class: "grow-0 shrink-0 w-full flex flex-row flex-nowrap items-start justify-between border-b cc-p" };
const _hoisted_10$3 = { class: "flex flex-col cc-text-sz" };
const _hoisted_11$3 = { class: "p-4" };
const _sfc_main$f = /* @__PURE__ */ defineComponent({
  __name: "SubmitApiEndpoint",
  setup(__props) {
    const { it, itd } = useTranslation();
    const $q = useQuasar();
    const showModal = ref(false);
    const endpointInputNew = ref("");
    const endpointInputError = ref("");
    const apiEndpointSelect = ref();
    const isBexApp2 = ref(define_process_env_default.MODE === "bex");
    const submitApiEndpoint = getSubmitApiEndpoint(networkId.value);
    const submitApiEndpoints = getSubmitApiEndpointList(networkId.value);
    const disableDelete = computed(() => submitApiEndpoint.value === DEFAULT_ETERNL_ENDPOINT);
    if (submitApiEndpoints.value.length === 0 || !submitApiEndpoints.value.includes(DEFAULT_ETERNL_ENDPOINT)) {
      const list = submitApiEndpoints.value;
      list.push(DEFAULT_ETERNL_ENDPOINT);
      submitApiEndpoints.value = list;
    }
    if (submitApiEndpoint.value) {
      if (!submitApiEndpoints.value.includes(submitApiEndpoint.value)) {
        addSubmitApiEndpoint(networkId.value, submitApiEndpoint.value);
      }
    }
    async function onSubmitApiEndpointChange(event) {
      setSubmitApiEndpoint(networkId.value, event.target.options[event.target.options.selectedIndex].value);
      showSaved();
    }
    const showSaved = () => {
      $q.notify({
        type: "positive",
        message: itd("preferences.message.success"),
        position: "top-left",
        timeout: 4e3
      });
    };
    const onSubmit = () => {
      if (isValid()) {
        if (!submitApiEndpoints.value.includes(endpointInputNew.value)) {
          addSubmitApiEndpoint(networkId.value, endpointInputNew.value);
        }
        setSubmitApiEndpoint(networkId.value, endpointInputNew.value);
        showSaved();
        showModal.value = false;
      }
    };
    const onReset = () => {
      endpointInputNew.value = "";
    };
    const isValid = () => {
      if (!endpointInputNew.value.startsWith("http")) {
        endpointInputError.value = "You need to use http!";
        return false;
      }
      try {
        const url = new URL(endpointInputNew.value);
        endpointInputError.value = "";
        return true;
      } catch (error) {
        endpointInputError.value = error + "";
        return false;
      }
    };
    const onClose = () => {
      showModal.value = false;
    };
    const onAdd = () => {
      showModal.value = true;
    };
    const onDelete = (event) => {
      let entryToDelete = apiEndpointSelect.value.options[apiEndpointSelect.value.options.selectedIndex].value;
      const index = submitApiEndpoints.value.indexOf(entryToDelete);
      if (index >= 0) {
        delSubmitApiEndpoint(networkId.value, index);
      }
      setSubmitApiEndpoint(networkId.value, DEFAULT_ETERNL_ENDPOINT);
    };
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", _hoisted_1$f, [
        createBaseVNode("div", _hoisted_2$c, [
          withDirectives(createBaseVNode("select", {
            class: "col-span-12 lg:col-span-12 cc-rounded-la cc-dropdown cc-text-sm",
            ref_key: "apiEndpointSelect",
            ref: apiEndpointSelect,
            "onUpdate:modelValue": _cache[0] || (_cache[0] = ($event) => isRef(submitApiEndpoint) ? submitApiEndpoint.value = $event : null),
            required: true,
            onChange: _cache[1] || (_cache[1] = ($event) => onSubmitApiEndpointChange($event))
          }, [
            (openBlock(true), createElementBlock(Fragment, null, renderList(unref(submitApiEndpoints), (apiEndpoint) => {
              return openBlock(), createElementBlock("option", {
                key: "apiEndpoint",
                selected: apiEndpoint === unref(submitApiEndpoint),
                value: apiEndpoint
              }, toDisplayString(apiEndpoint), 9, _hoisted_3$9);
            }), 128))
          ], 544), [
            [vModelSelect, unref(submitApiEndpoint)]
          ])
        ]),
        createVNode(_sfc_main$I, {
          label: unref(it)("common.label.add"),
          link: onAdd,
          class: "col-span-6 col-start-1 lg:col-start-9 lg:col-span-2 max-h-11"
        }, null, 8, ["label"]),
        createVNode(_sfc_main$I, {
          label: unref(it)("common.label.delete"),
          link: onDelete,
          disabled: disableDelete.value,
          class: "col-span-6 col-start-7 lg:col-start-11 lg:col-span-2 max-h-11"
        }, null, 8, ["label", "disabled"]),
        createBaseVNode("div", _hoisted_4$9, [
          createBaseVNode("div", _hoisted_5$8, toDisplayString(unref(it)("preferences.submitApi.note.headline")), 1),
          createBaseVNode("div", _hoisted_6$7, [
            createBaseVNode("div", null, toDisplayString(unref(it)("preferences.submitApi.note.caption")), 1),
            createBaseVNode("div", _hoisted_7$5, toDisplayString(unref(it)("preferences.submitApi.note.description")), 1),
            !isBexApp2.value ? (openBlock(), createElementBlock("div", _hoisted_8$5, toDisplayString(unref(it)("preferences.submitApi.note.cors")), 1)) : createCommentVNode("", true)
          ])
        ]),
        showModal.value ? (openBlock(), createBlock(Modal, {
          key: 0,
          narrow: "",
          "full-width-on-mobile": "",
          onClose
        }, {
          header: withCtx(() => [
            createBaseVNode("div", _hoisted_9$4, [
              createBaseVNode("div", _hoisted_10$3, [
                createVNode(_sfc_main$G, {
                  label: unref(it)("preferences.submitApi.label")
                }, null, 8, ["label"]),
                createVNode(_sfc_main$H, {
                  text: unref(it)("preferences.submitApi.add.label")
                }, null, 8, ["text"])
              ])
            ])
          ]),
          content: withCtx(() => [
            createBaseVNode("div", _hoisted_11$3, [
              createVNode(_sfc_main$N, {
                onDoFormReset: onReset,
                onDoFormSubmit: onSubmit,
                "form-id": "SubmitApiEndpointInputForm",
                "reset-button-label": unref(it)("common.label.reset"),
                "submit-button-label": unref(it)("common.label.save")
              }, {
                content: withCtx(() => [
                  createVNode(GridInput, {
                    "input-text": endpointInputNew.value,
                    "onUpdate:inputText": _cache[2] || (_cache[2] = ($event) => endpointInputNew.value = $event),
                    "input-error": endpointInputError.value,
                    "onUpdate:inputError": _cache[3] || (_cache[3] = ($event) => endpointInputError.value = $event),
                    class: "col-span-12",
                    onOnSubmittable: isValid,
                    "input-id": "SubmitApiEndpointInput",
                    "input-hint": unref(it)("preferences.submitApi.inputHint"),
                    "skip-validation": true,
                    "text-id": "common.label.save"
                  }, null, 8, ["input-text", "input-error", "input-hint"])
                ]),
                btnBack: withCtx(() => [
                  renderSlot(_ctx.$slots, "btnBack")
                ]),
                _: 3
              }, 8, ["reset-button-label", "submit-button-label"])
            ])
          ]),
          _: 3
        })) : createCommentVNode("", true)
      ]);
    };
  }
});
const _hoisted_1$e = { class: "w-full col-span-12 pl-6 pr-2" };
const _hoisted_2$b = { class: "grid grid-cols-12 cc-gap" };
const _sfc_main$e = /* @__PURE__ */ defineComponent({
  __name: "ExportAllWalletsJson",
  setup(__props) {
    const { it } = useTranslation();
    const { downloadWallet } = useDownload();
    const $q = useQuasar();
    function sleep2(ms) {
      return new Promise((resolve) => setTimeout(resolve, ms));
    }
    async function exportWallets() {
      let successCnt = 0;
      for (const walletId of walletIdList.value) {
        await downloadWallet(createWalletDownloadable(walletId));
        await sleep2(500);
        successCnt++;
      }
      if (successCnt > 0) {
        $q.notify({
          type: "positive",
          message: `${successCnt} wallets out of ${walletIdList.value.length} total wallets successfully exported.`,
          position: "top-left",
          timeout: 7e3
        });
      } else {
        $q.notify({
          type: "warning",
          message: "No wallets exported.",
          position: "top-left",
          timeout: 4e3
        });
      }
    }
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", _hoisted_1$e, [
        createBaseVNode("div", _hoisted_2$b, [
          createVNode(GridButtonSecondary, {
            class: "col-span-12 xs:col-span-8 lg:col-span-9",
            link: exportWallets,
            disabled: !unref(walletIdList).length,
            label: unref(it)("preferences.exports.button.label"),
            icon: unref(it)("preferences.exports.button.icon")
          }, null, 8, ["disabled", "label", "icon"])
        ])
      ]);
    };
  }
});
const getConnectedOriginsMap = () => getObjRef("connectedOrigins", {});
const _hoisted_1$d = { class: "w-full col-span-12 pl-6 pr-2" };
const _hoisted_2$a = {
  key: 0,
  class: "cc-text-sz italic"
};
const _hoisted_3$8 = {
  key: 1,
  class: "item-text"
};
const _hoisted_4$8 = { class: "cc-rounded cc-area-light flex flex-col flex-nowrap p-2 px-4" };
const _hoisted_5$7 = { class: "table-auto divide-y border-spacing-2" };
const _hoisted_6$6 = { class: "cc-text-bold" };
const _hoisted_7$4 = { class: "text-right" };
const _hoisted_8$4 = { class: "divide-y" };
const _hoisted_9$3 = { class: "sm:min-w-16" };
const _hoisted_10$2 = { class: "break-all" };
const _hoisted_11$2 = {
  key: 0,
  class: "cc-badge-red whitespace-nowrap inline-block"
};
const _hoisted_12$2 = { class: "flex flex-col flex-nowrap space-y-2" };
const _hoisted_13$2 = {
  key: 0,
  class: "flex flex-row space-x-2"
};
const _hoisted_14$2 = {
  key: 1,
  class: "flex flex-row space-x-2"
};
const _hoisted_15$2 = { class: "flex flex-col" };
const _hoisted_16$2 = {
  key: 2,
  class: "flex flex-row space-x-2"
};
const _hoisted_17$2 = { class: "flex flex-col" };
const itemsOnPage$1 = 10;
const _sfc_main$d = /* @__PURE__ */ defineComponent({
  __name: "DAppWhitelist",
  props: {
    textId: { type: String, required: false, default: "preferences.dapp.allowlist" }
  },
  setup(__props) {
    const { t, itd } = useTranslation();
    const $q = useQuasar();
    const { isDomainOnBlockList } = useGuard();
    const siteSortOrderAsc = ref(true);
    const dAppWhiteList = getConnectedOriginsMap();
    const hasCIP30 = computed(() => Object.values(dAppWhiteList.value).some((access) => access.some((e) => e.cip === 30)));
    const hasCIP95 = computed(() => Object.values(dAppWhiteList.value).some((access) => access.some((e) => e.cip === 95)));
    const hasCIP104 = computed(() => Object.values(dAppWhiteList.value).some((access) => access.some((e) => e.cip === 104)));
    const currentPage = ref(1);
    const showPagination = computed(() => Object.keys(dAppWhiteList.value).length > itemsOnPage$1);
    const currentPageStart = computed(() => (currentPage.value - 1) * itemsOnPage$1);
    const maxPages = computed(() => Math.ceil(Object.keys(dAppWhiteList.value).length / itemsOnPage$1));
    const dAppWLFiltered = computed(() => {
      let tmpList = Object.keys(dAppWhiteList.value).sort((a, b) => a.localeCompare(b, "en-US"));
      if (!siteSortOrderAsc.value) {
        tmpList = tmpList.reverse();
      }
      return tmpList.slice(currentPageStart.value, currentPageStart.value + itemsOnPage$1);
    });
    const scamSites = ref([]);
    const showDeleteModal = ref({ display: false });
    const originToDelete = ref("");
    const cipToDelete = ref(0);
    const openDeleteModal = (origin, cip) => {
      originToDelete.value = origin;
      cipToDelete.value = cip;
      showDeleteModal.value.display = true;
    };
    function onRemoveSiteAccess() {
      const originList = getConnectedOriginsMap().value;
      const extensionList = originList[originToDelete.value];
      if (!extensionList) {
        return;
      }
      if (cipToDelete.value === 0 || originList[originToDelete.value].length === 1) {
        delete originList[originToDelete.value];
      } else {
        originList[originToDelete.value] = originList[originToDelete.value].filter((e) => e.cip !== cipToDelete.value);
      }
      dAppWhiteList.value = originList;
      getConnectedOriginsMap().value = originList;
      $q.notify({
        type: "positive",
        message: itd("preferences.save"),
        position: "top-left"
      });
      originToDelete.value = "";
      cipToDelete.value = 0;
      showDeleteModal.value.display = false;
    }
    const equalsStrArr = (a, b) => a.length === b.length && a.every((v, i) => v === b[i]);
    const equalsExtArr = (a, b) => a.length === b.length && a.every((v, i) => v.cip === b[i].cip);
    let _timeout = -1;
    const checkStorage = () => {
      clearTimeout(_timeout);
      _timeout = setTimeout(() => {
        const l1 = getConnectedOriginsMap().value;
        const l2 = dAppWhiteList.value;
        const l1Keys = Object.keys(l1);
        const l2Keys = Object.keys(l2);
        if (!equalsStrArr(l1Keys, l2Keys)) {
          dAppWhiteList.value = l1;
        } else {
          for (const origin in l1) {
            if (!equalsExtArr(l1[origin], l2[origin])) {
              dAppWhiteList.value = l1;
              break;
            }
          }
        }
        checkStorage();
      }, 5e3);
    };
    const checkWhitelist = async () => {
      for (let dAppUrl of Object.keys(dAppWhiteList.value)) {
        if (await isDomainOnBlockList(dAppUrl)) {
          scamSites.value.push(dAppUrl);
        }
      }
    };
    onMounted(async () => {
      checkStorage();
      await checkWhitelist();
    });
    onUnmounted(() => clearTimeout(_timeout));
    watch(dAppWhiteList, async () => {
      await checkWhitelist();
    });
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", _hoisted_1$d, [
        createVNode(_sfc_main$O, {
          title: unref(itd)(__props.textId + ".confirm.label"),
          caption: unref(itd)(__props.textId + ".confirm.message").replace("###origin###", originToDelete.value).replace("###cip###", cipToDelete.value === 0 ? " " : ` ${unref(itd)(__props.textId + ".type.cip" + cipToDelete.value + ".label")} `),
          "show-modal": showDeleteModal.value,
          onConfirm: _cache[0] || (_cache[0] = ($event) => onRemoveSiteAccess())
        }, null, 8, ["title", "caption", "show-modal"]),
        dAppWLFiltered.value.length === 0 ? (openBlock(), createElementBlock("span", _hoisted_2$a, toDisplayString(unref(itd)(__props.textId + ".empty")), 1)) : (openBlock(), createElementBlock("div", _hoisted_3$8, [
          createBaseVNode("div", _hoisted_4$8, [
            createBaseVNode("table", _hoisted_5$7, [
              createBaseVNode("thead", null, [
                createBaseVNode("tr", _hoisted_6$6, [
                  createBaseVNode("th", {
                    class: "text-left cursor-pointer",
                    onClick: _cache[1] || (_cache[1] = withModifiers(($event) => siteSortOrderAsc.value = !siteSortOrderAsc.value, ["stop"]))
                  }, [
                    createTextVNode(toDisplayString(unref(itd)(__props.textId + ".table.header.site")) + " ", 1),
                    createBaseVNode("i", {
                      class: normalizeClass(["cc-text-md", siteSortOrderAsc.value ? "mdi mdi-chevron-up" : "mdi mdi-chevron-down"])
                    }, null, 2)
                  ]),
                  createBaseVNode("th", _hoisted_7$4, toDisplayString(unref(itd)(__props.textId + ".table.header.access")), 1)
                ])
              ]),
              createBaseVNode("tbody", _hoisted_8$4, [
                (openBlock(true), createElementBlock(Fragment, null, renderList(dAppWLFiltered.value, (origin, index) => {
                  return openBlock(), createElementBlock("tr", {
                    class: "align-middle cc-text-sm",
                    key: origin
                  }, [
                    createBaseVNode("td", _hoisted_9$3, [
                      createBaseVNode("div", {
                        class: normalizeClass(["flex flex-row flex-nowrap space-x-2", index === 0 ? "my-1" : "my-0.5"])
                      }, [
                        createVNode(IconDelete, {
                          class: "h-5 flex-none cc-text-color-error cursor-pointer",
                          onClick: withModifiers(($event) => openDeleteModal(origin, 0), ["stop"])
                        }, null, 8, ["onClick"]),
                        createVNode(_sfc_main$C, {
                          anchor: "bottom middle",
                          "transition-show": "scale",
                          "transition-hide": "scale"
                        }, {
                          default: withCtx(() => [
                            createTextVNode(toDisplayString(unref(itd)(__props.textId + ".button.remove")), 1)
                          ]),
                          _: 1
                        }),
                        createBaseVNode("span", _hoisted_10$2, toDisplayString(origin), 1),
                        scamSites.value.includes(origin) ? (openBlock(), createElementBlock("span", _hoisted_11$2, toDisplayString(unref(t)("common.scam.token.label")), 1)) : createCommentVNode("", true)
                      ], 2)
                    ]),
                    createBaseVNode("td", null, [
                      createBaseVNode("div", {
                        class: normalizeClass(["flex flex-col xs:flex-row xs:justify-end items-end xs:items-start", index === 0 ? "my-1" : "my-0.5"])
                      }, [
                        (openBlock(true), createElementBlock(Fragment, null, renderList(unref(dAppWhiteList)[origin], (extension, index2) => {
                          return openBlock(), createElementBlock("div", {
                            class: "flex flex-row flex-nowrap items-center cc-badge-gray whitespace-nowrap ml-2",
                            key: index2
                          }, [
                            createBaseVNode("i", {
                              class: normalizeClass(["text-md", unref(itd)(__props.textId + ".type.cip" + extension.cip + ".icon")])
                            }, null, 2),
                            createVNode(IconDelete, {
                              class: "ml-2 h-5 flex-none cc-text-color-error cursor-pointer",
                              onClick: withModifiers(($event) => openDeleteModal(origin, extension.cip), ["stop"])
                            }, null, 8, ["onClick"]),
                            createVNode(_sfc_main$C, {
                              anchor: "bottom middle",
                              "transition-show": "scale",
                              "transition-hide": "scale"
                            }, {
                              default: withCtx(() => [
                                createTextVNode(toDisplayString(unref(itd)(__props.textId + ".button.remove")), 1)
                              ]),
                              _: 1
                            })
                          ]);
                        }), 128))
                      ], 2)
                    ])
                  ]);
                }), 128))
              ])
            ]),
            showPagination.value ? (openBlock(), createBlock(GridSpace, {
              key: 0,
              class: "mb-2"
            })) : createCommentVNode("", true),
            showPagination.value ? (openBlock(), createBlock(QPagination_default, {
              key: 1,
              modelValue: currentPage.value,
              "onUpdate:modelValue": _cache[2] || (_cache[2] = ($event) => currentPage.value = $event),
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
            }, null, 8, ["modelValue", "max"])) : createCommentVNode("", true),
            createVNode(GridSpace, {
              hr: "",
              class: normalizeClass(["mb-2", showPagination.value ? "mt-2" : "mt-0.5"])
            }, null, 8, ["class"]),
            createBaseVNode("div", _hoisted_12$2, [
              hasCIP30.value ? (openBlock(), createElementBlock("div", _hoisted_13$2, [
                createBaseVNode("i", {
                  class: normalizeClass(["text-md", unref(itd)(__props.textId + ".type.cip30.icon")])
                }, null, 2),
                _cache[3] || (_cache[3] = createBaseVNode("div", null, "=", -1)),
                createBaseVNode("div", null, toDisplayString(unref(itd)(__props.textId + ".type.cip30.label")), 1)
              ])) : createCommentVNode("", true),
              hasCIP95.value ? (openBlock(), createElementBlock("div", _hoisted_14$2, [
                createBaseVNode("i", {
                  class: normalizeClass(["text-md", unref(itd)(__props.textId + ".type.cip95.icon")])
                }, null, 2),
                _cache[4] || (_cache[4] = createBaseVNode("div", null, "=", -1)),
                createBaseVNode("div", _hoisted_15$2, [
                  createBaseVNode("span", null, toDisplayString(unref(itd)(__props.textId + ".type.cip95.label")), 1)
                ])
              ])) : createCommentVNode("", true),
              hasCIP104.value ? (openBlock(), createElementBlock("div", _hoisted_16$2, [
                createBaseVNode("i", {
                  class: normalizeClass(["text-md", unref(itd)(__props.textId + ".type.cip104.icon")])
                }, null, 2),
                _cache[5] || (_cache[5] = createBaseVNode("div", null, "=", -1)),
                createBaseVNode("div", _hoisted_17$2, [
                  createBaseVNode("span", null, toDisplayString(unref(itd)(__props.textId + ".type.cip104.label")), 1)
                ])
              ])) : createCommentVNode("", true)
            ])
          ])
        ]))
      ]);
    };
  }
});
const _hoisted_1$c = { class: "col-span-12 grid grid-cols-12 cc-gap pl-6 pr-2" };
const _sfc_main$c = /* @__PURE__ */ defineComponent({
  __name: "FrankenAddress",
  setup(__props) {
    const { t } = useTranslation();
    const address1 = ref("");
    const address1Error = ref("");
    const address1Valid = ref(false);
    const address2 = ref("");
    const address2Error = ref("");
    const address2Valid = ref(false);
    const frankenAddress = ref("");
    function onGenerateFrankenAddress() {
      if (!address1Valid.value || !address2Valid.value) return;
      frankenAddress.value = getFrankenAddress(networkId.value, address1.value, address2.value) ?? "";
    }
    function validateAddrInput(address, canBeEnterprise, canBeStake) {
      if (address.length === 0) return true;
      if (isBaseAddress(address, networkId.value)) return true;
      if (canBeEnterprise && isEnterpriseAddress(address, networkId.value)) return true;
      if (canBeStake && isRewardsAddress(address, networkId.value)) return true;
      return false;
    }
    let timeout1 = -1;
    watch(address1, () => {
      clearTimeout(timeout1);
      timeout1 = setTimeout(() => {
        if (!validateAddrInput(address1.value, true, false)) {
          address1Error.value = t("preferences.tool.frankenaddr.addr1error");
        }
        address1Valid.value = address1.value.length > 0 && address1Error.value.length === 0;
      }, 250);
    });
    let timeout2 = -1;
    watch(address2, () => {
      clearTimeout(timeout2);
      timeout2 = setTimeout(() => {
        if (!validateAddrInput(address2.value, false, true)) {
          address2Error.value = t("preferences.tool.frankenaddr.addr2error");
        }
        address2Valid.value = address2.value.length > 0 && address2Error.value.length === 0;
      }, 250);
    });
    function onReset1() {
      address1.value = "";
      address1Error.value = "";
      address1Valid.value = false;
      frankenAddress.value = "";
    }
    function onReset2() {
      address2.value = "";
      address2Error.value = "";
      address2Valid.value = false;
      frankenAddress.value = "";
    }
    const onPaste1 = async (e) => address1.value = await onPaste(e);
    const onPaste2 = async (e) => address2.value = await onPaste(e);
    const onPaste = async (e) => {
      var _a, _b;
      e.stopPropagation();
      e.preventDefault();
      let clipboardData = ((_a = e.clipboardData) == null ? void 0 : _a.getData("Text")) ?? "";
      const items = (_b = e.clipboardData) == null ? void 0 : _b.items;
      if (items) {
        let clipboardData1 = await getQrCodeData(items);
        if (clipboardData1) {
          clipboardData = clipboardData1;
        }
      }
      return clipboardData.trim().split(/(\s+)/).sort((a, b) => a.length - b.length).pop() ?? "";
    };
    const getQrCodeData = async (items) => {
      for (let i = 0; i < items.length; i++) {
        if (items[i] && items[i].type.indexOf("image") == -1) continue;
        if (items[i].kind === "file") {
          const blob = items[i].getAsFile();
          if (blob) {
            const scannedCode = await processFile(blob);
            if (scannedCode.content) {
              return scannedCode.content;
            }
          }
        }
      }
      return null;
    };
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", _hoisted_1$c, [
        createVNode(GridInput, {
          "input-text": address1.value,
          "onUpdate:inputText": _cache[0] || (_cache[0] = ($event) => address1.value = $event),
          "input-error": address1Error.value,
          "onUpdate:inputError": _cache[1] || (_cache[1] = ($event) => address1Error.value = $event),
          onEnter: onGenerateFrankenAddress,
          onReset: onReset1,
          onPaste: onPaste1,
          "input-hint": unref(t)("preferences.tool.frankenaddr.hint1"),
          alwaysShowInfo: false,
          showReset: true,
          "input-id": "inputAddr",
          "input-type": "text",
          class: "col-span-12"
        }, {
          "icon-prepend": withCtx(() => [
            createVNode(IconPencil, { class: "h-5 w-5" })
          ]),
          _: 1
        }, 8, ["input-text", "input-error", "input-hint"]),
        createVNode(GridInput, {
          "input-text": address2.value,
          "onUpdate:inputText": _cache[2] || (_cache[2] = ($event) => address2.value = $event),
          "input-error": address2Error.value,
          "onUpdate:inputError": _cache[3] || (_cache[3] = ($event) => address2Error.value = $event),
          onEnter: onGenerateFrankenAddress,
          onReset: onReset2,
          onPaste: onPaste2,
          "input-hint": unref(t)("preferences.tool.frankenaddr.hint2"),
          alwaysShowInfo: false,
          showReset: true,
          "input-id": "inputAddr",
          "input-type": "text",
          class: "col-span-12"
        }, {
          "icon-prepend": withCtx(() => [
            createVNode(IconPencil, { class: "h-5 w-5" })
          ]),
          _: 1
        }, 8, ["input-text", "input-error", "input-hint"]),
        createVNode(GridButtonSecondary, {
          class: "col-span-12 sm:col-start-7 sm:col-span-6",
          label: unref(t)("common.label.generate"),
          disabled: !address1Valid.value || !address2Valid.value,
          link: onGenerateFrankenAddress
        }, null, 8, ["label", "disabled"]),
        frankenAddress.value ? (openBlock(), createBlock(_sfc_main$P, {
          key: 0,
          "show-divider": false,
          text: frankenAddress.value
        }, null, 8, ["text"])) : createCommentVNode("", true)
      ]);
    };
  }
});
const _hoisted_1$b = {
  key: 0,
  class: "fixed top-0 bottom-0 cursor-pointer right-0 left-0 w-full h-full z-max cc-bg-overlay cc-text-white rounded-borders flex h-screen justify-center items-center"
};
const _hoisted_2$9 = { class: "text-center" };
const _hoisted_3$7 = { class: "justify-center align-middle grid place-items-center" };
const _hoisted_4$7 = { class: "w-full col-span-12 grid grid-cols-12 cc-gap" };
const _sfc_main$b = /* @__PURE__ */ defineComponent({
  __name: "ResetApplicationCache",
  emits: ["close"],
  setup(__props, { emit: __emit }) {
    const emit = __emit;
    const { it } = useTranslation();
    const $q = useQuasar();
    const deleteInProgress = ref(false);
    const status = ref("");
    async function onResetCache() {
      deleteInProgress.value = true;
      status.value = it("preferences.clearCache.inProgress");
      clearLocalStorage();
      setTimeout(() => {
        status.value = it("preferences.clearCache.finish");
        deleteInProgress.value = false;
        $q.notify({
          type: "positive",
          message: it("preferences.clearCache.finish"),
          position: "top-left",
          timeout: 2e3
        });
        guardedUpdateNetworkId(networkId.value, true);
        emit("close");
      }, 4e3);
    }
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock(Fragment, null, [
        deleteInProgress.value ? (openBlock(), createElementBlock("div", _hoisted_1$b, [
          createBaseVNode("div", _hoisted_2$9, [
            createBaseVNode("div", _hoisted_3$7, [
              createVNode(QSpinnerDots_default, {
                color: "gray",
                size: "4em"
              })
            ]),
            createBaseVNode("div", null, toDisplayString(status.value), 1)
          ])
        ])) : createCommentVNode("", true),
        createBaseVNode("div", _hoisted_4$7, [
          createVNode(_sfc_main$H, {
            text: unref(it)("preferences.clearCache.warning")
          }, null, 8, ["text"]),
          createVNode(_sfc_main$Q, {
            class: "col-span-12",
            link: onResetCache,
            disabled: deleteInProgress.value,
            label: unref(it)("preferences.clearCache.button.label"),
            icon: unref(it)("preferences.clearCache.button.icon")
          }, null, 8, ["disabled", "label", "icon"])
        ])
      ], 64);
    };
  }
});
const _hoisted_1$a = {
  key: 0,
  class: "fixed top-0 bottom-0 cursor-pointer right-0 left-0 w-full h-full z-max cc-bg-overlay cc-text-white rounded-borders flex h-screen justify-center items-center"
};
const _hoisted_2$8 = { class: "text-center" };
const _hoisted_3$6 = { class: "justify-center align-middle grid place-items-center" };
const _hoisted_4$6 = { class: "w-full col-span-12 grid grid-cols-12 cc-gap" };
const _hoisted_5$6 = { class: "col-span-12" };
const _sfc_main$a = /* @__PURE__ */ defineComponent({
  __name: "ResetApplication",
  emits: ["close"],
  setup(__props, { emit: __emit }) {
    const emit = __emit;
    const { it } = useTranslation();
    const $q = useQuasar();
    const toggled = ref(false);
    const searchInput = ref("");
    const searchInputError = ref("");
    const searchDisabled = ref(false);
    const toggleError = ref(false);
    const deleteInProgress = ref(false);
    const status = ref("");
    const randomConfirmationCode = () => {
      const min = Math.ceil(1e3);
      const max = Math.floor(9999);
      return Math.floor(Math.random() * (max - min)) + min;
    };
    const deletePhrase = it("preferences.reset.phrase.confirmation") + " #" + randomConfirmationCode();
    function validateSearchInput() {
      if (!isCorrectName() && searchInput.value !== "") {
        searchInputError.value = it("preferences.reset.toggle.acknowledged.error");
      } else {
        searchInputError.value = "";
      }
      return searchInputError.value;
    }
    function onReset() {
      searchInput.value = "";
      searchInputError.value = "";
    }
    watchEffect(() => {
      if (toggled.value) {
        toggleError.value = false;
      } else {
        onReset();
      }
      searchDisabled.value = !toggled.value;
    });
    const isCorrectName = () => {
      return searchInput.value === deletePhrase;
    };
    async function onDeleteWallet() {
      if (isCorrectName() && toggled.value) {
        deleteInProgress.value = true;
        let index = 0;
        let numWallets = walletIdList.value.length;
        for (const walletId of walletIdList.value) {
          status.value = it("preferences.reset.deleteWallets") + " " + (index + 1) + "/" + numWallets;
          await deleteWallet(walletId);
          await sleep(100);
          index++;
        }
        status.value = it("preferences.reset.deleteConfig");
        clearLocalStorage();
        status.value = it("preferences.reset.deleteFinish");
        deleteInProgress.value = false;
        $q.notify({
          type: "positive",
          message: it("preferences.reset.finish"),
          position: "top-left",
          timeout: 2e3
        });
        await guardedUpdateNetworkId(networkId.value, true);
        emit("close");
      }
      if (!isCorrectName()) {
        searchInputError.value = it("preferences.reset.toggle.acknowledged.error");
      }
      toggleError.value = !toggled.value;
    }
    const onPaste = (event) => {
      event.preventDefault();
      event.stopPropagation();
      $q.notify({
        type: "negative",
        message: it("preferences.reset.noPasting"),
        position: "top-left",
        timeout: 2e3
      });
    };
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock(Fragment, null, [
        deleteInProgress.value ? (openBlock(), createElementBlock("div", _hoisted_1$a, [
          createBaseVNode("div", _hoisted_2$8, [
            createBaseVNode("div", _hoisted_3$6, [
              createVNode(QSpinnerDots_default, {
                color: "gray",
                size: "4em"
              })
            ]),
            createBaseVNode("div", null, toDisplayString(unref(it)("preferences.reset.inDelete")), 1),
            createBaseVNode("div", null, toDisplayString(status.value), 1)
          ])
        ])) : createCommentVNode("", true),
        createBaseVNode("div", _hoisted_4$6, [
          createVNode(_sfc_main$H, {
            text: unref(it)("preferences.reset.warning")
          }, null, 8, ["text"]),
          createVNode(_sfc_main$R, {
            label: unref(it)("preferences.reset.toggle.acknowledged.label"),
            text: unref(it)("preferences.reset.toggle.acknowledged.text"),
            icon: unref(it)("preferences.reset.toggle.acknowledged.icon"),
            toggled: toggled.value,
            toggleError: toggleError.value,
            "onUpdate:toggled": _cache[0] || (_cache[0] = ($event) => toggled.value = $event),
            class: "col-span-12"
          }, null, 8, ["label", "text", "icon", "toggled", "toggleError"]),
          createBaseVNode("div", _hoisted_5$6, toDisplayString(unref(it)("preferences.reset.phrase.name")) + ': "' + toDisplayString(deletePhrase) + '" ', 1),
          createVNode(GridInput, {
            class: "col-span-12 mb-1",
            "input-text": searchInput.value,
            "onUpdate:inputText": _cache[1] || (_cache[1] = ($event) => searchInput.value = $event),
            "input-error": searchInputError.value,
            "onUpdate:inputError": _cache[2] || (_cache[2] = ($event) => searchInputError.value = $event),
            onLostFocus: validateSearchInput,
            onEnter: _cache[3] || (_cache[3] = ($event) => {
              validateSearchInput();
              onDeleteWallet();
            }),
            onReset,
            onPaste,
            label: unref(it)("preferences.reset.phrase.label"),
            "input-hint": unref(it)("preferences.reset.phrase.hint"),
            alwaysShowInfo: false,
            "input-id": "searchInput",
            "input-type": "text",
            inputDisabled: searchDisabled.value,
            "show-reset": true,
            "dense-input": ""
          }, {
            "icon-prepend": withCtx(() => [
              createVNode(IconPencil, { class: "h-5 w-5" })
            ]),
            _: 1
          }, 8, ["input-text", "input-error", "label", "input-hint", "inputDisabled"]),
          createVNode(_sfc_main$Q, {
            class: "col-span-12",
            link: onDeleteWallet,
            disabled: !toggled.value || !isCorrectName(),
            label: unref(it)("preferences.reset.button.label"),
            icon: unref(it)("preferences.reset.button.icon")
          }, null, 8, ["disabled", "label", "icon"])
        ])
      ], 64);
    };
  }
});
const _hoisted_1$9 = { class: "col-span-12 grid grid-cols-12 cc-gap pl-6 pr-2" };
const _sfc_main$9 = /* @__PURE__ */ defineComponent({
  __name: "DevSettings",
  emits: ["close"],
  setup(__props, { emit: __emit }) {
    const searchInput = ref("");
    const searchInputError = ref("");
    function validateSearchInput() {
      if (searchInput.value === "ADD_REPORTING") {
        setDevSettingsEnabled();
        dispatchSignalSync(onNetworkFeaturesUpdated);
      }
    }
    function onReset() {
      searchInput.value = "";
      searchInputError.value = "";
    }
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", _hoisted_1$9, [
        createVNode(GridInput, {
          class: "col-span-12 mb-1",
          "input-text": searchInput.value,
          "onUpdate:inputText": _cache[0] || (_cache[0] = ($event) => searchInput.value = $event),
          "input-error": searchInputError.value,
          "onUpdate:inputError": _cache[1] || (_cache[1] = ($event) => searchInputError.value = $event),
          onLostFocus: validateSearchInput,
          onEnter: validateSearchInput,
          onReset,
          alwaysShowInfo: false,
          "input-id": "searchInput",
          "input-type": "text",
          "show-reset": true,
          "dense-input": ""
        }, {
          "icon-prepend": withCtx(() => [
            createVNode(IconPencil, { class: "h-5 w-5" })
          ]),
          _: 1
        }, 8, ["input-text", "input-error"])
      ]);
    };
  }
});
const _hoisted_1$8 = { class: "min-h-40 flex flex-col flex-nowrap space-y-2 cc-p w-full overflow-auto" };
const _hoisted_2$7 = { class: "col-span-12 grid grid-cols-12 cc-gap-lg lg:ml-2" };
const _hoisted_3$5 = { class: "col-span-12 grid grid-cols-12" };
const _hoisted_4$5 = { class: "col-span-12 pl-6 mb-3 break-normal whitespace-pre-wrap" };
const _hoisted_5$5 = { class: "col-span-12 pl-6 mb-3 break-normal whitespace-pre-wrap" };
const _hoisted_6$5 = { class: "col-span-12 lg:ml-6 p-2 grid grid-cols-12 cc-gap cc-rounded cc-ring-highlight mb-2" };
const _hoisted_7$3 = { class: "col-span-12 flex flex-row flex-nowrap justify-center items-center whitespace-pre-wrap cc-text-bold cc-text-red-light" };
const _hoisted_8$3 = { class: "col-span-12 lg:ml-6 p-2 grid grid-cols-12 cc-gap cc-rounded cc-ring-red mb-2" };
const _hoisted_9$2 = { class: "col-span-12 flex flex-row flex-nowrap justify-center items-center whitespace-pre-wrap cc-text-bold cc-text-red-light" };
const _sfc_main$8 = /* @__PURE__ */ defineComponent({
  __name: "GlobalSettings",
  emits: ["close"],
  setup(__props, { emit: __emit }) {
    const { it } = useTranslation();
    const $q = useQuasar();
    const autoSubmit = getAutoSubmitTx();
    computed(() => getSubmitApiEndpoint(networkId.value).value !== DEFAULT_ETERNL_ENDPOINT);
    const isPersistable = ref(false);
    onMounted(async () => {
      try {
        const persistingStatus = await tryPersistWithoutPromtingUser();
        const isBrave = navigator.brave && await navigator.brave.isBrave() || false;
        isPersistable.value = !isBrave && persistingStatus !== persistStatus.NOT_PERSISTABLE;
      } catch (e) {
      }
    });
    const onToggleAutoSubmit = () => {
      toggleAutoSubmitTx();
      $q.notify({
        type: "positive",
        message: it("preferences.message.success"),
        position: "top-left"
      });
    };
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", _hoisted_1$8, [
        isPersistable.value && !unref(isMobileApp)() ? (openBlock(), createBlock(_sfc_main$S, {
          key: 0,
          label: unref(it)("preferences.storage.label"),
          caption: unref(it)("preferences.storage.caption"),
          openExpanded: false,
          "can-toggle": false,
          enabled: true
        }, {
          setting: withCtx(() => [
            createVNode(_sfc_main$k)
          ]),
          _: 1
        }, 8, ["label", "caption"])) : createCommentVNode("", true),
        createVNode(_sfc_main$S, {
          label: unref(it)("preferences.addressbook.label"),
          caption: unref(it)("preferences.addressbook.caption")
        }, {
          setting: withCtx(() => [
            createBaseVNode("div", _hoisted_2$7, [
              createVNode(_sfc_main$T, { "global-mode": true })
            ])
          ]),
          _: 1
        }, 8, ["label", "caption"]),
        createVNode(_sfc_main$S, {
          label: unref(it)("preferences.localization.label"),
          caption: unref(it)("preferences.localization.caption"),
          dense: ""
        }, {
          setting: withCtx(() => [
            createBaseVNode("div", _hoisted_3$5, [
              createVNode(GridSpace, {
                hr: "",
                class: "pl-6",
                "align-label": "left",
                "line-c-s-s": "cc-divide-color2",
                "label-c-s-s": "cc-text-sz cc-text-light-0 cc-text-bold",
                label: unref(it)("preferences.localization.formatting.label")
              }, null, 8, ["label"]),
              createBaseVNode("div", _hoisted_4$5, toDisplayString(unref(it)("preferences.localization.formatting.caption")), 1),
              createVNode(_sfc_main$i),
              createVNode(GridSpace, {
                hr: "",
                class: "pl-6 mt-4",
                "align-label": "left",
                "line-c-s-s": "cc-divide-color2",
                "label-c-s-s": "cc-text-sz cc-text-light-0 cc-text-bold",
                label: unref(it)("preferences.localization.currencyConversion.label")
              }, null, 8, ["label"]),
              createBaseVNode("div", _hoisted_5$5, toDisplayString(unref(it)("preferences.localization.currencyConversion.caption")), 1),
              createVNode(_sfc_main$h),
              createVNode(GridSpace, { class: "my-1" })
            ])
          ]),
          _: 1
        }, 8, ["label", "caption"]),
        !unref(isTestnet) && !unref(isCustomNetwork) ? (openBlock(), createBlock(_sfc_main$S, {
          key: 1,
          label: unref(it)("preferences.explorer.label"),
          caption: unref(it)("preferences.explorer.caption")
        }, {
          setting: withCtx(() => [
            createVNode(_sfc_main$g)
          ]),
          _: 1
        }, 8, ["label", "caption"])) : createCommentVNode("", true),
        createVNode(_sfc_main$S, {
          label: unref(it)("preferences.autoSubmit.label"),
          caption: unref(it)("preferences.autoSubmit.caption"),
          "can-toggle": true,
          "can-expand": true,
          enabled: unref(autoSubmit) === "1",
          onToggle: onToggleAutoSubmit
        }, null, 8, ["label", "caption", "enabled"]),
        createVNode(_sfc_main$S, {
          label: unref(it)("preferences.submitApi.label"),
          caption: unref(it)("preferences.submitApi.caption"),
          openExpanded: false,
          "can-toggle": false
        }, {
          setting: withCtx(() => [
            createVNode(_sfc_main$f)
          ]),
          _: 1
        }, 8, ["label", "caption"]),
        createVNode(_sfc_main$S, {
          label: unref(it)("preferences.exports.label"),
          caption: unref(it)("preferences.exports.caption")
        }, {
          setting: withCtx(() => [
            createVNode(_sfc_main$e)
          ]),
          _: 1
        }, 8, ["label", "caption"]),
        unref(isBexApp)() ? (openBlock(), createBlock(_sfc_main$S, {
          key: 2,
          label: unref(it)("preferences.dapp.allowlist.label"),
          caption: unref(it)("preferences.dapp.allowlist.caption")
        }, {
          setting: withCtx(() => [
            createVNode(_sfc_main$d)
          ]),
          _: 1
        }, 8, ["label", "caption"])) : createCommentVNode("", true),
        createVNode(_sfc_main$S, {
          label: unref(it)("preferences.tool.frankenaddr.label"),
          caption: unref(it)("preferences.tool.frankenaddr.caption")
        }, {
          setting: withCtx(() => [
            createVNode(_sfc_main$c)
          ]),
          _: 1
        }, 8, ["label", "caption"]),
        createVNode(_sfc_main$S, {
          label: unref(it)("preferences.clearCache.label"),
          caption: unref(it)("preferences.clearCache.caption")
        }, {
          setting: withCtx(() => [
            createBaseVNode("div", _hoisted_6$5, [
              createBaseVNode("div", _hoisted_7$3, toDisplayString(unref(it)("common.label.pleaseNote")), 1),
              createVNode(_sfc_main$b, {
                onClose: _cache[0] || (_cache[0] = ($event) => _ctx.$emit("close"))
              })
            ])
          ]),
          _: 1
        }, 8, ["label", "caption"]),
        createVNode(_sfc_main$S, {
          label: unref(it)("preferences.reset.label"),
          caption: unref(it)("preferences.reset.caption")
        }, {
          setting: withCtx(() => [
            createBaseVNode("div", _hoisted_8$3, [
              createBaseVNode("div", _hoisted_9$2, toDisplayString(unref(it)("wallet.settings.deldereg.dangerzone")), 1),
              createVNode(_sfc_main$a, {
                onClose: _cache[1] || (_cache[1] = ($event) => _ctx.$emit("close"))
              })
            ])
          ]),
          _: 1
        }, 8, ["label", "caption"]),
        createVNode(_sfc_main$S, {
          label: unref(it)("preferences.devsettings.label")
        }, {
          setting: withCtx(() => [
            createVNode(_sfc_main$9, {
              onClose: _cache[2] || (_cache[2] = ($event) => _ctx.$emit("close"))
            })
          ]),
          _: 1
        }, 8, ["label"])
      ]);
    };
  }
});
const _hoisted_1$7 = { class: "grow-0 shrink-0 w-full flex flex-row flex-nowrap items-start justify-between cc-bg-white-0 border-b cc-p" };
const _hoisted_2$6 = { class: "flex flex-col cc-text-sz" };
const _hoisted_3$4 = { class: "grow-0 shrink-0 w-full flex flex-row flex-nowrap items-start justify-between border-b cc-p" };
const _hoisted_4$4 = { class: "flex flex-col cc-text-sz" };
const _hoisted_5$4 = { class: "p-2 flex flex-col gap-2" };
const _hoisted_6$4 = { class: "flex-1 flex flex-col flex-nowrap -mt-0.5 text-left" };
const _hoisted_7$2 = ["innerHTML"];
const _hoisted_8$2 = ["innerHTML"];
const _hoisted_9$1 = { class: "flex-1 flex flex-col flex-nowrap -mt-0.5 text-left" };
const _hoisted_10$1 = ["innerHTML"];
const _hoisted_11$1 = ["innerHTML"];
const _hoisted_12$1 = { class: "flex-1 flex flex-col flex-nowrap -mt-0.5 text-left" };
const _hoisted_13$1 = ["innerHTML"];
const _hoisted_14$1 = ["innerHTML"];
const _hoisted_15$1 = { class: "relative cc-flex-fixed cc-layout-p h-16 sm:h-20 flex border-l-4 border-t border-b mb-px cc-bg-white-0-hover cc-border-hover" };
const _hoisted_16$1 = { class: "relative flex-grow flex-shrink min-h-20 mb-px" };
const _hoisted_17$1 = { class: "absolute w-full h-full overflow-y-auto flex flex-col flex-nowrap" };
const _hoisted_18$1 = { class: "flex-1 flex flex-col flex-nowrap -mt-0.5 text-left" };
const _hoisted_19$1 = ["innerHTML"];
const _hoisted_20$1 = { class: "flex-1 flex flex-col flex-nowrap -mt-0.5 text-left" };
const _hoisted_21$1 = ["innerHTML"];
const _hoisted_22$1 = ["innerHTML"];
const _hoisted_23 = {
  key: 2,
  class: "relative cc-flex-fixed flex justify-center items-center cc-layout-p cc-text-sm mb-px h-14 border-l-4 border-t border-b cc-bg-white-0-hover cc-border-hover"
};
const _hoisted_24 = { class: "relative cc-flex-fixed flex flex-row flex-nowrap justify-center items-center space-x-px cc-text-sm mb-px" };
const _sfc_main$7 = /* @__PURE__ */ defineComponent({
  __name: "NavSidebar",
  setup(__props) {
    const route = useRoute();
    const { it } = useTranslation();
    const {
      gotoPage,
      gotoDAppBrowserPage
    } = useNavigation();
    const {
      toggleMainMenu,
      closeMainMenu,
      isMainMenuOpen
    } = useMainMenuOpen();
    const showModal = ref(false);
    const showModalConnect = ref(false);
    const canHaveDappBrowser = ref(isDappBrowserEnabled(networkId.value));
    const canHaveReporting = ref(isReportingEnabled(networkId.value) && isDevSettingsEnabled());
    function onClickedConnect() {
      showModalConnect.value = true;
    }
    function onClickedDAppBrowser() {
      showModalConnect.value = false;
      closeMainMenu();
      gotoDAppBrowserPage("DApps", "favs");
    }
    function onClickedReport() {
      showModalConnect.value = false;
      closeMainMenu();
      gotoPage("Report");
    }
    function onClickedDirectConnect() {
      showModalConnect.value = false;
      closeMainMenu();
      gotoPage("CardanoConnect");
    }
    function onClickedWalletConnect() {
      showModalConnect.value = false;
      closeMainMenu();
      gotoPage("WalletConnect");
    }
    const onClose = () => {
      showModal.value = false;
      showModalConnect.value = false;
    };
    const openSettings = () => {
      showModal.value = true;
      toggleMainMenu();
    };
    function openPage(page) {
      gotoPage(page);
      closeMainMenu();
    }
    const updateFlags = () => {
      canHaveDappBrowser.value = isDappBrowserEnabled(networkId.value);
      canHaveReporting.value = isDevSettingsEnabled() && isReportingEnabled(networkId.value);
    };
    onMounted(() => {
      addSignalListener(onNetworkFeaturesUpdated, "NavSidebar", updateFlags);
    });
    onUnmounted(() => {
      removeSignalListener(onNetworkFeaturesUpdated, "NavSidebar");
    });
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock(Fragment, null, [
        showModal.value ? (openBlock(), createBlock(Modal, {
          key: 0,
          "half-wide": "",
          onClose
        }, {
          header: withCtx(() => [
            createBaseVNode("div", _hoisted_1$7, [
              createBaseVNode("div", _hoisted_2$6, [
                createVNode(_sfc_main$G, {
                  label: unref(it)("preferences.headline"),
                  "do-capitalize": ""
                }, null, 8, ["label"]),
                createVNode(_sfc_main$H, {
                  text: unref(it)("preferences.caption")
                }, null, 8, ["text"])
              ])
            ])
          ]),
          content: withCtx(() => [
            createVNode(_sfc_main$8, { onClose })
          ]),
          _: 1
        })) : createCommentVNode("", true),
        showModalConnect.value ? (openBlock(), createBlock(Modal, {
          key: 1,
          narrow: "",
          "full-width-on-mobile": "",
          onClose
        }, {
          header: withCtx(() => [
            createBaseVNode("div", _hoisted_3$4, [
              createBaseVNode("div", _hoisted_4$4, [
                createVNode(_sfc_main$G, { label: "Connect to dapps" })
              ])
            ])
          ]),
          content: withCtx(() => [
            createBaseVNode("div", _hoisted_5$4, [
              !unref(doRestrictFeatures)() && canHaveDappBrowser.value ? (openBlock(), createElementBlock("div", {
                key: 0,
                class: normalizeClass(["relative rounded cc-flex-fixed flex justify-center items-center cc-layout-p cc-text-sm mb-px h-14 border cc-bg-white-0-hover cc-border-hover", unref(route).name === "DApps" ? "cc-border-active cc-bg-white-0-active" : ""])
              }, [
                createBaseVNode("button", {
                  class: "group px-2 flex-1 cc-rounded cc-text-medium flex flex-row flex-nowrap justify-center items-center",
                  onClick: withModifiers(onClickedDAppBrowser, ["stop"])
                }, [
                  createBaseVNode("i", {
                    class: normalizeClass(["mr-2 sm:mr-3 text-2xl mdi", unref(it)("menu.main.dappbrowser.icon")])
                  }, null, 2),
                  createBaseVNode("span", _hoisted_6$4, [
                    createBaseVNode("span", {
                      class: "",
                      innerHTML: unref(it)("menu.main.dappbrowser.label")
                    }, null, 8, _hoisted_7$2),
                    createBaseVNode("span", {
                      class: "cc-text-xs",
                      innerHTML: unref(it)("menu.main.dappbrowser.caption")
                    }, null, 8, _hoisted_8$2)
                  ])
                ])
              ], 2)) : createCommentVNode("", true),
              !unref(doRestrictFeatures)() ? (openBlock(), createElementBlock("div", {
                key: 1,
                class: normalizeClass(["relative rounded cc-flex-fixed flex justify-center items-center cc-layout-p cc-text-sm mb-px h-14 border cc-bg-white-0-hover cc-border-hover", unref(route).name === "CardanoConnect" ? "cc-border-active cc-bg-white-0-active" : ""])
              }, [
                createBaseVNode("button", {
                  class: "relative group px-2 flex-1 cc-rounded cc-text-medium flex flex-row flex-nowrap justify-center items-center",
                  onClick: withModifiers(onClickedDirectConnect, ["stop"])
                }, [
                  createBaseVNode("i", {
                    class: normalizeClass(["mr-2 sm:mr-3 text-2xl mdi", unref(it)("menu.main.directconnect.icon")])
                  }, null, 2),
                  createBaseVNode("span", _hoisted_9$1, [
                    createBaseVNode("span", {
                      class: "",
                      innerHTML: unref(it)("menu.main.directconnect.label")
                    }, null, 8, _hoisted_10$1),
                    createBaseVNode("span", {
                      class: "cc-text-xs",
                      innerHTML: unref(it)("menu.main.directconnect.caption")
                    }, null, 8, _hoisted_11$1)
                  ]),
                  _cache[3] || (_cache[3] = createBaseVNode("div", { class: "absolute right-0 top-0 -mt-1 text-xs cc-text-gray" }, "beta", -1))
                ])
              ], 2)) : createCommentVNode("", true),
              !unref(doRestrictFeatures)() ? (openBlock(), createElementBlock("div", {
                key: 2,
                class: normalizeClass(["relative rounded cc-flex-fixed flex justify-center items-center cc-layout-p cc-text-sm mb-px h-14 border cc-bg-white-0-hover cc-border-hover", unref(route).name === "WalletConnect" ? "cc-border-active cc-bg-white-0-active" : ""])
              }, [
                createBaseVNode("button", {
                  class: "relative group px-2 flex-1 cc-rounded cc-text-medium flex flex-row flex-nowrap justify-center items-center",
                  onClick: withModifiers(onClickedWalletConnect, ["stop"])
                }, [
                  _cache[4] || (_cache[4] = createBaseVNode("img", {
                    class: "w-6 mr-2 sm:mr-3 text-2xl mdi mdi mdi-transit-connection-horizontal",
                    src: _imports_0,
                    alt: "icon walletconnect"
                  }, null, -1)),
                  createBaseVNode("span", _hoisted_12$1, [
                    createBaseVNode("span", {
                      class: "",
                      innerHTML: unref(it)("menu.main.walletconnect.label")
                    }, null, 8, _hoisted_13$1),
                    createBaseVNode("span", {
                      class: "cc-text-xs",
                      innerHTML: unref(it)("menu.main.walletconnect.caption")
                    }, null, 8, _hoisted_14$1)
                  ]),
                  _cache[5] || (_cache[5] = createBaseVNode("div", { class: "absolute right-0 top-0 -mt-1 text-xs cc-text-gray" }, "beta", -1))
                ])
              ], 2)) : createCommentVNode("", true)
            ])
          ]),
          _: 1
        })) : createCommentVNode("", true),
        createBaseVNode("div", {
          class: normalizeClass(["absolute z-40 inset-0 w-full h-full cursor-pointer cc-rounded-la overflow-hidden cc-bg-overlay cc-none lg:hidden", unref(isMainMenuOpen) ? "flex" : ""]),
          onClick: _cache[0] || (_cache[0] = withModifiers(
            //@ts-ignore
            (...args) => unref(toggleMainMenu) && unref(toggleMainMenu)(...args),
            ["stop"]
          ))
        }, null, 2),
        createBaseVNode("div", {
          class: normalizeClass(["absolute order-first z-50 w-full xs:w-72 overflow-hidden cc-rounded-la-l inset-0 cc-shadow cc-none lg:flex lg:relative cc-flex-fixed flex-col flex-nowrap cc-nav-bg", unref(isMainMenuOpen) ? "flex" : ""])
        }, [
          createBaseVNode("div", _hoisted_15$1, [
            createVNode(_sfc_main$o, {
              label: unref(it)("menu.main.add.label"),
              caption: unref(it)("menu.main.add.caption"),
              icon: unref(it)("menu.main.add.icon"),
              link: "WalletAdd",
              "do-open-network-page": true
            }, null, 8, ["label", "caption", "icon"])
          ]),
          createBaseVNode("div", _hoisted_16$1, [
            createBaseVNode("nav", _hoisted_17$1, [
              createVNode(_sfc_main$l)
            ])
          ]),
          !unref(doRestrictFeatures)() && canHaveReporting.value ? (openBlock(), createElementBlock("div", {
            key: 0,
            class: normalizeClass(["relative cc-flex-fixed flex justify-center items-center cc-layout-p cc-text-sm mb-px h-14 border-l-4 border-t border-b cc-bg-white-0-hover cc-border-hover", unref(route).name === "Report" ? "cc-border-active cc-bg-white-0-active" : ""])
          }, [
            createBaseVNode("button", {
              class: normalizeClass(["group px-2 flex-1 cc-rounded cc-text-medium flex flex-row flex-nowrap justify-center items-center", unref(route).name === "Report" ? "cc-border-active cc-bg-white-0-active" : ""]),
              onClick: withModifiers(onClickedReport, ["stop"])
            }, [
              createBaseVNode("i", {
                class: normalizeClass(["mr-2 sm:mr-3 text-2xl mdi", unref(it)("menu.main.report.icon")])
              }, null, 2),
              createBaseVNode("span", _hoisted_18$1, [
                createBaseVNode("span", {
                  class: "",
                  innerHTML: unref(it)("menu.main.report.label")
                }, null, 8, _hoisted_19$1)
              ])
            ], 2)
          ], 2)) : createCommentVNode("", true),
          !unref(doRestrictFeatures)() && canHaveDappBrowser.value ? (openBlock(), createElementBlock("div", {
            key: 1,
            class: normalizeClass(["relative cc-flex-fixed flex justify-center items-center cc-layout-p cc-text-sm mb-px h-14 border-l-4 border-t border-b cc-bg-white-0-hover cc-border-hover", unref(route).name === "DApps" ? "cc-border-active cc-bg-white-0-active" : ""])
          }, [
            createBaseVNode("button", {
              class: normalizeClass(["group px-2 flex-1 cc-rounded cc-text-medium flex flex-row flex-nowrap justify-center items-center", unref(route).name === "DApps" ? "cc-border-active cc-bg-white-0-active" : ""]),
              onClick: withModifiers(onClickedDAppBrowser, ["stop"])
            }, [
              createBaseVNode("i", {
                class: normalizeClass(["mr-2 sm:mr-3 text-2xl mdi", unref(it)("menu.main.dappbrowser.icon")])
              }, null, 2),
              createBaseVNode("span", _hoisted_20$1, [
                createBaseVNode("span", {
                  class: "",
                  innerHTML: unref(it)("menu.main.dappbrowser.label")
                }, null, 8, _hoisted_21$1),
                createBaseVNode("span", {
                  class: "cc-text-xs",
                  innerHTML: unref(it)("menu.main.dappbrowser.caption")
                }, null, 8, _hoisted_22$1)
              ])
            ], 2)
          ], 2)) : createCommentVNode("", true),
          !unref(doRestrictFeatures)() ? (openBlock(), createElementBlock("div", _hoisted_23, [
            createBaseVNode("button", {
              class: "group px-2 flex-1 cc-rounded cc-text-medium flex flex-row flex-nowrap justify-center items-center",
              onClick: withModifiers(onClickedConnect, ["stop"])
            }, [
              createBaseVNode("i", {
                class: normalizeClass(["mr-2 sm:mr-3 text-2xl mdi", "mdi mdi-transit-connection-horizontal"])
              }),
              _cache[6] || (_cache[6] = createBaseVNode("span", { class: "flex-1 flex flex-col flex-nowrap -mt-0.5 text-left" }, [
                createBaseVNode("span", {
                  class: "",
                  innerHTML: "All DApp connection options"
                })
              ], -1))
            ])
          ])) : createCommentVNode("", true),
          createBaseVNode("div", _hoisted_24, [
            createBaseVNode("div", {
              class: normalizeClass(["group px-2 flex-1 w-1/3 cursor-pointer h-14 border-l-4 border-t border-b cc-bg-white-0-hover cc-border-hover flex flex-col flex-nowrap justify-center items-center", unref(route).name === "Announcements" ? "cc-border-active cc-bg-white-0-active" : ""]),
              onClick: _cache[1] || (_cache[1] = withModifiers(($event) => openPage("Announcements"), ["stop", "prevent"]))
            }, [
              createBaseVNode("i", {
                class: normalizeClass(["text-2xl leading-6", unref(it)("menu.main.news.icon")])
              }, null, 2),
              _cache[7] || (_cache[7] = createBaseVNode("div", { class: "text-xs leading-4" }, "News", -1))
            ], 2),
            createBaseVNode("div", {
              class: normalizeClass(["group px-2 flex-1 w-1/3 cursor-pointer h-14 border-l-4 border-t border-b cc-bg-white-0-hover cc-border-hover flex flex-col flex-nowrap justify-center items-center", unref(route).name === "FAQ" ? "cc-border-active cc-bg-white-0-active" : ""]),
              onClick: _cache[2] || (_cache[2] = withModifiers(($event) => openPage("FAQ"), ["stop", "prevent"]))
            }, [
              createBaseVNode("i", {
                class: normalizeClass(["text-2xl leading-6", unref(it)("menu.main.faq.icon")])
              }, null, 2),
              _cache[8] || (_cache[8] = createBaseVNode("div", { class: "text-xs leading-4" }, "FAQ", -1))
            ], 2),
            createBaseVNode("div", {
              class: "group px-2 flex-1 w-1/3 cursor-pointer h-14 border-l-4 border-t border-b cc-bg-white-0-hover cc-border-hover flex flex-col flex-nowrap justify-center items-center",
              onClick: withModifiers(openSettings, ["stop", "prevent"])
            }, [
              createBaseVNode("i", {
                class: normalizeClass(["text-2xl leading-6", unref(it)("menu.main.prefs.icon")])
              }, null, 2),
              _cache[9] || (_cache[9] = createBaseVNode("div", { class: "text-xs leading-4" }, "App Settings", -1))
            ])
          ])
        ], 2)
      ], 64);
    };
  }
});
const signTransaction = async (accountData, walletData, txBuildRes, credList, password) => {
  var _a;
  let cslSignedTx;
  let cslWitnessSetOwned;
  let res = { error: "notExecuted" };
  try {
    const networkId2 = accountData.state.networkId;
    const epochParams = checkEpochParams(networkId2);
    if (!(txBuildRes == null ? void 0 : txBuildRes.builtTx)) {
      return { error: ErrorSignTx.missingTx };
    }
    if (!(txBuildRes == null ? void 0 : txBuildRes.txCbor)) {
      return { error: ErrorSignTx.missingTx };
    }
    if (!credList) {
      return { error: ErrorSignTx.missingKeysList };
    }
    if (!((_a = walletData.wallet.rootKey) == null ? void 0 : _a.prv)) {
      return { error: ErrorSignTx.missingRootKey };
    }
    const prvRootKeyBech32 = decryptText(walletData.wallet.rootKey.prv, password, walletData.wallet.rootKey.v ?? "");
    if (!prvRootKeyBech32) {
      return { error: ErrorSignTx.invalidPassword };
    }
    if (txBuildRes.cslAuxData && isCatalystVotingRegistrationMetadata(txBuildRes.cslAuxData)) {
      if (!txBuildRes.cslAuxData.metadata()) {
        return { error: ErrorSignTx.catalyst };
      }
      safeFreeCSLObject(txBuildRes.cslAuxData);
      txBuildRes.cslAuxData = processVoteRegistration(accountData, txBuildRes.cslTx, txBuildRes.cslTxBody, prvRootKeyBech32);
      safeFreeCSLObject(txBuildRes.cslTxHash);
      let cslTxHash;
      try {
        const cslFixedTx = FixedTransaction.new_from_body_bytes(txBuildRes.cslTxBody.to_bytes());
        cslTxHash = cslFixedTx.transaction_hash();
        safeFreeCSLObject(cslFixedTx);
      } catch (err) {
        if (err === "NOT_IMPLEMENTED") {
          console.warn("NOT_IMPLEMENTED > fallback cslTxHash");
          cslTxHash = hash_transaction(txBuildRes.cslTxBody);
        } else {
          throw err;
        }
      }
      txBuildRes.cslTxHash = cslTxHash;
      txBuildRes.txHash = toHexString(cslTxHash.to_bytes());
      txBuildRes.txCbor = null;
    }
    cslWitnessSetOwned = addVkeys(txBuildRes.cslTxHash, txBuildRes.cslWitnessSet, credList, prvRootKeyBech32);
    const witnessSetOwned = toHexString(cslWitnessSetOwned.to_bytes());
    cslSignedTx = Transaction.new(txBuildRes.cslTxBody, txBuildRes.cslWitnessSet, txBuildRes.cslAuxData);
    safeFreeCSLObject(txBuildRes.cslAuxData);
    txBuildRes.cslAuxData = cslSignedTx.auxiliary_data();
    const signedTxBytes = cslSignedTx.to_bytes();
    const signedTxHash = txBuildRes.txHash;
    const signedTx = getTransactionJSONFromCSL(networkId2, cslSignedTx);
    const signedTxSize = signedTxBytes.byteLength;
    signedTx.hash = signedTxHash;
    signedTx.size = signedTxSize;
    signedTx.time = now$1();
    signedTx.inputUtxoList = txBuildRes.builtTx.inputUtxoList;
    const signedTxHex = reinjectWitnessSet(txBuildRes.txCbor, toHexString(signedTxBytes), txBuildRes.cslWitnessSet);
    const signedTxWitnessSet = toHexString(txBuildRes.cslWitnessSet.to_bytes());
    const maxTxSize = epochParams.maxTxSize;
    signedTx.cbor = signedTxHex;
    res = {
      tx: signedTx,
      hash: signedTxHash,
      cbor: signedTxHex,
      witnessSet: signedTxWitnessSet,
      witnessSetOwned
    };
    if (signedTxSize > epochParams.maxTxSize) {
      res.error = ErrorSignTx.txSize + "." + signedTxSize + "." + maxTxSize;
    }
  } catch (err) {
    res = { error: err };
  }
  safeFreeCSLObject(cslSignedTx);
  safeFreeCSLObject(cslWitnessSetOwned);
  return res;
};
const addVkeys = (cslTxHash, cslWitnessSet, credList, prvRootKeyBech32) => {
  const cslVkeys = cslWitnessSet.vkeys() ?? Vkeywitnesses.new();
  const cslVkeysOwned = Vkeywitnesses.new();
  for (const cred of credList) {
    const prvKey = createCSLPrvKey(prvRootKeyBech32, cred.path);
    const prvKeyRaw = prvKey.to_raw_key();
    const vkeyWitness = make_vkey_witness(cslTxHash, prvKeyRaw);
    const vkeyWitnessSig = vkeyWitness.signature();
    const vkeyWitnessSig32 = vkeyWitnessSig.to_bech32();
    let keyIncluded = false;
    for (let i = 0; i < cslVkeys.len(); i++) {
      const _wit = cslVkeys.get(i);
      const _witSig = _wit.signature();
      keyIncluded = vkeyWitnessSig32 === _witSig.to_bech32();
      safeFreeCSLObject(_witSig);
      safeFreeCSLObject(_wit);
      if (keyIncluded) {
        break;
      }
    }
    if (!keyIncluded) {
      cslVkeys.add(vkeyWitness);
      cslVkeysOwned.add(vkeyWitness);
    }
    safeFreeCSLObject(vkeyWitnessSig);
    safeFreeCSLObject(vkeyWitness);
    safeFreeCSLObject(prvKeyRaw);
    safeFreeCSLObject(prvKey);
  }
  cslWitnessSet.set_vkeys(cslVkeys);
  const cslWitnessSetOwned = TransactionWitnessSet.new();
  cslWitnessSetOwned.set_vkeys(cslVkeysOwned);
  safeFreeCSLObject(cslVkeys);
  return cslWitnessSetOwned;
};
const processVoteRegistration = (accountData, cslTx, cslTxBody, prvRootKeyBech32) => {
  const prvKey = createCSLPrvKey(prvRootKeyBech32, accountData.keys.stake[0].path);
  const prvKeyRaw = prvKey.to_raw_key();
  const signedCatalystMeta = addCatalystRegistrationSignature(cslTx.auxiliary_data().metadata(), prvKeyRaw);
  const signedAuxData = generateCatalystRegistration(signedCatalystMeta);
  const auxDataHash = hash_auxiliary_data(signedAuxData);
  cslTxBody.set_auxiliary_data_hash(auxDataHash);
  safeFreeCSLObject(auxDataHash);
  safeFreeCSLObject(signedCatalystMeta);
  safeFreeCSLObject(prvKeyRaw);
  safeFreeCSLObject(prvKey);
  return signedAuxData;
};
const _hoisted_1$6 = {
  key: 1,
  class: "cc-page-p cc-grid"
};
const _hoisted_2$5 = {
  key: 3,
  class: "col-span-12 grid grid-cols-12 cc-gap"
};
const _hoisted_3$3 = {
  key: 6,
  class: "relative col-span-12 -top-2"
};
const _hoisted_4$3 = {
  key: 7,
  class: "relative col-span-12 grid grid-cols-12"
};
const _hoisted_5$3 = { class: "col-span-12 flex flex-row flex-nowrap items-center whitespace-pre-wrap cc-text-sz" };
const _hoisted_6$3 = {
  key: 8,
  class: "col-span-12 flex flex-col sm:flex-row flex-nowrap justify-between cc-rounded cc-banner-gray cc-gap p-2"
};
const _hoisted_7$1 = { class: "flex flex-col flex-nowrap cc-gap" };
const _hoisted_8$1 = {
  key: 10,
  class: "col-span-12 flex flex-col gap-3 cc-text-sz"
};
const _hoisted_9 = { class: "w-full flex flex-row flex-nowrap mt-1" };
const _hoisted_10 = {
  key: 0,
  class: "w-full flex flex-row flex-nowrap"
};
const _hoisted_11 = { class: "rounded-xl p-3 md:p-4 w-full cc-bg-highlight flex flex-row flex-nowrap justify-between items-center space-x-2" };
const _hoisted_12 = { class: "cc-text-bold w-full flex flex-col flex-nowrap flex-grow gap-1 break-normal" };
const _hoisted_13 = { class: "capitalize" };
const _hoisted_14 = {
  key: 0,
  class: "text-sm flex flex-col gap-2 cc-text-normal cc-text-white"
};
const _hoisted_15 = {
  key: 1,
  class: "w-full text-sm cc-text-normal whitespace-pre-wrap break-all"
};
const _hoisted_16 = {
  key: 0,
  class: "cc-flex-fixed flex flex-col flex-nowrap justify-end overflow-hidden"
};
const _hoisted_17 = {
  key: 20,
  class: "col-span-12 cc-px pb-2 sm:pb-2.5 pt-1 sm:pt-1.5 cc-text-sz cc-area-light flex flex-row flex-nowrap justify-between items-start"
};
const _hoisted_18 = { class: "inline-flex items-top self-start justify-center pt-1 relative" };
const _hoisted_19 = {
  key: 21,
  class: "col-span-12 flex flex-row justify-center"
};
const _hoisted_20 = { class: "col-span-12 flex flex-row justify-center" };
const _hoisted_21 = {
  key: 2,
  class: "cc-page-wallet cc-grid"
};
const _hoisted_22 = { class: "col-span-12 flex justify-center items-center" };
const itemsOnPage = 5;
const _sfc_main$6 = /* @__PURE__ */ defineComponent({
  __name: "SignTxConfirm",
  props: {
    type: { type: String, required: false, default: "" },
    textId: { type: String, required: true, default: "wallet.send.step" },
    showLabel: { type: Boolean, required: false, default: true },
    closeCounter: { type: Number, required: false, default: 0 }
  },
  emits: ["submit", "cancel", "submitted"],
  setup(__props, { emit: __emit }) {
    const props = __props;
    const emit = __emit;
    const { it } = useTranslation();
    const { openWalletPage } = useNavigation();
    const { downloadText } = useDownload();
    const $q = useQuasar();
    const {
      txBuildRes,
      txSubmitType,
      txBalance,
      totalBalance,
      accountId,
      walletId
    } = useSignTx();
    const {
      appAccount,
      accountData,
      accountSettings,
      walletData,
      walletSettings
    } = useWalletAccount(walletId, accountId);
    const { closeCounter } = toRefs(props);
    const walletName = walletSettings.name;
    const accountName = accountSettings.name;
    const isReadOnly = computed(() => !!walletData.value && walletData.value.wallet.signType === "readonly");
    const isMnemonic = computed(() => !!walletData.value && walletData.value.wallet.signType === "mnemonic");
    const isLedger = computed(() => !!walletData.value && walletData.value.wallet.signType === "ledger");
    const isTrezor = computed(() => !!walletData.value && walletData.value.wallet.signType === "trezor");
    const isKeystone = computed(() => !!walletData.value && walletData.value.wallet.signType === "keystone");
    const isHW = computed(() => isLedger.value || isTrezor.value || isKeystone.value);
    const isHWSigning = ref(false);
    let isHWSigningToid = -1;
    const {
      signTxWithLedger,
      getLedgerVersion,
      closeLedger
    } = useLedgerDevice();
    const {
      signTxWithTrezor,
      initiateTrezor
    } = useTrezorDevice();
    const {
      createKeystoneSignRequest,
      handleKeystoneSignature
    } = useKeystoneDevice();
    const {
      parseWitnesses
    } = useWitnesses();
    const {
      submitTx,
      doAutoSubmit
    } = useSubmitTx();
    const autoSubmit = ref(doAutoSubmit.value === "1");
    const keystoneUR = ref();
    const isLoading = ref(false);
    const txSignRes = ref(null);
    const _txSignRes = ref(null);
    const noOwnedKeys = ref(false);
    const usesLockedUTxO = ref(false);
    ref(null);
    const signError = ref("");
    const signErrorShowDebug = ref(false);
    const parseError = ref("");
    const hasParseError = computed(() => parseError.value.length > 0);
    const txList = ref([]);
    const txIndex = ref(0);
    const submitting = ref(false);
    const submitStatus = ref("");
    const submitInfo = ref("");
    const submitError = ref("");
    const submitSuccess = ref(false);
    const isMultiTx = ref(false);
    const isConfirmed = ref([]);
    const isAllConfirmed = ref(false);
    const isExpired = ref(false);
    const isAllTxValid = computed(() => {
      return txBuildRes.value != null && txBalance.value != null && (Array.isArray(txBuildRes.value) ? !txBuildRes.value.some((v) => v.builtTx == null) && Array.isArray(txBalance.value) && txBuildRes.value.length === txBalance.value.length : txBuildRes.value.builtTx != null);
    });
    const warning = computed(() => {
      var _a, _b;
      return Array.isArray(txBuildRes.value) ? ((_a = txBuildRes.value[t_currentPage.value - 1]) == null ? void 0 : _a.warning) ?? null : ((_b = txBuildRes.value) == null ? void 0 : _b.warning) ?? null;
    });
    const getWarningText = (warning2) => {
      let warningText = warning2;
      if (warning2 === ErrorTxCbor.auxDataMissing) {
        warningText = "Transaction metadata is hidden.";
      } else if (warning2 === ErrorTxCbor.auxDataMismatch) {
        warningText = "There is a mismatch between the attached metadata and the hash requested to sign. The metadata you see for this transaction is not what you sign!";
      }
      return warningText;
    };
    const getWarningColor = (warning2) => {
      let warningColor = "cc-banner-warning";
      if (warning2 === ErrorTxCbor.auxDataMissing) {
        warningColor = "cc-banner-gray";
      }
      return warningColor;
    };
    const tl_currentPage = ref(1);
    const tl_showPagination = computed(() => txList.value.length > itemsOnPage);
    const tl_currentPageStart = computed(() => (tl_currentPage.value - 1) * itemsOnPage);
    const tl_maxPages = computed(() => Math.ceil(txList.value.length / itemsOnPage));
    const txListPaged = computed(() => txList.value.slice(tl_currentPageStart.value, tl_currentPageStart.value + itemsOnPage));
    const t_currentPage = ref(1);
    const _tx = computed(() => {
      if (txSignRes.value && txSignRes.value.length >= t_currentPage.value) {
        return txSignRes.value[t_currentPage.value - 1].tx;
      } else if (txBuildRes.value) {
        return Array.isArray(txBuildRes.value) ? txBuildRes.value[t_currentPage.value - 1].builtTx : txBuildRes.value.builtTx;
      }
      return null;
    });
    let keystoneSignResolve = null;
    function signWithKeystone(ur) {
      return new Promise((resolve, reject) => {
        keystoneSignResolve = resolve;
        keystoneUR.value = ur;
      });
    }
    function onKeystoneClose() {
      if (keystoneSignResolve) {
        keystoneSignResolve({ error: "Scan rejected" });
        keystoneSignResolve = null;
      }
      keystoneUR.value = void 0;
    }
    function onKeystoneScan(data) {
      try {
        $q.notify({
          type: "positive",
          message: it("wallet.keystone.ok"),
          position: "top-left"
        });
        if (!accountData.value) {
          throw ErrorSignTx.missingAccountData;
        }
        const tx = Array.isArray(txBuildRes.value) ? txBuildRes.value[txIndex.value] : txBuildRes.value;
        if (!tx) {
          throw ErrorSignTx.missingTx;
        }
        if (keystoneSignResolve) {
          keystoneSignResolve(handleKeystoneSignature(accountData.value, tx, data.type, data.cbor));
        }
      } catch (err) {
        if (keystoneSignResolve) {
          keystoneSignResolve({ error: (err == null ? void 0 : err.message) ?? JSON.stringify(err) });
        }
      }
      keystoneUR.value = void 0;
    }
    const signTx = async (payload) => {
      var _a, _b, _c, _d, _e;
      signError.value = "";
      isConfirmed.value = [];
      isAllConfirmed.value = false;
      txSignRes.value = null;
      txList.value = [];
      try {
        if (!accountData.value) {
          throw ErrorSignTx.missingAccountData;
        }
        if (!walletData.value) {
          throw ErrorSignTx.missingWalletData;
        }
        if (!txBuildRes.value || !txBalance.value) {
          throw ErrorSignTx.missingTx;
        }
        if (isLedger.value || isTrezor.value) {
          clearTimeout(isHWSigningToid);
          isHWSigningToid = setTimeout(() => {
            isHWSigning.value = true;
          }, 250);
        }
        const resList = Array.isArray(txBuildRes.value) ? txBuildRes.value : [txBuildRes.value];
        const balanceList = Array.isArray(txBalance.value) ? txBalance.value : [txBalance.value];
        const resLen = resList.length;
        if (resLen !== balanceList.length) {
          throw ErrorSignTx.txBalanceMismatch;
        }
        for (let i = 0; i < resLen; i++) {
          _txSignRes.value = null;
          if (!appAccount.value) {
            continue;
          }
          if ((((_a = resList[i]) == null ? void 0 : _a.txCredList.length) ?? 0) === 0) {
            if (!resList[i]) {
              continue;
            }
            _txSignRes.value = {
              hash: resList[i].txHash,
              tx: resList[i].builtTx,
              cbor: resList[i].txCbor
            };
          } else {
            switch (accountData.value.account.signType) {
              case "ledger":
                _txSignRes.value = await signTxWithLedger(appAccount.value, resList[i], (_b = resList[i]) == null ? void 0 : _b.txCredList, i < resLen - 1);
                break;
              case "trezor":
                _txSignRes.value = await signTxWithTrezor(appAccount.value, walletData.value.wallet.id, resList[i], (_c = resList[i]) == null ? void 0 : _c.txCredList);
                break;
              case "keystone": {
                const ur = await createKeystoneSignRequest(appAccount.value, walletData.value, resList[i], (_d = resList[i]) == null ? void 0 : _d.txCredList);
                _txSignRes.value = await signWithKeystone(ur);
                break;
              }
              case "mnemonic":
                _txSignRes.value = await signTransaction(accountData.value, walletData.value, resList[i], (_e = resList[i]) == null ? void 0 : _e.txCredList, (payload == null ? void 0 : payload.password) ?? "");
                break;
            }
          }
          const res = _txSignRes.value;
          if (!res || !res.tx || res.error) {
            throw (res == null ? void 0 : res.error) ?? ErrorSignTx.failedToSign;
          }
          const signedTx = res.tx;
          signedTx.cbor = res.cbor;
          resList[i].builtTx = signedTx;
          await dispatchSignal(doAddSignedTxList, [signedTx]);
          if (res.hash) {
            balanceList[i].hash = res.hash;
          }
          submitStatus.value = it(props.textId + ".submit.status.sending");
          submitInfo.value = it(props.textId + ".submit.info.submitting");
          parseWitnesses(res.tx);
          if (txSignRes.value) {
            txSignRes.value.push(res);
          } else {
            txSignRes.value = [res];
          }
          if (txSubmitType.value === "cc") {
            const creds = getSignTxCredList(resList[i], accountData.value);
            isConfirmed.value.push(creds.allOwnedSigned && creds.allForeignSigned);
          } else {
            isConfirmed.value.push(true);
          }
          txList.value.push([res.hash, res.cbor]);
          txIndex.value++;
        }
        isAllConfirmed.value = !isConfirmed.value.some((confirmed) => !confirmed);
        if (doAutoSubmit.value) {
          setTimeout(() => {
            onSubmit();
          }, 25);
        }
      } catch (err) {
        console.warn("signTx: err:", err);
        hasSignError(err);
      }
      if (isHW.value) {
        isHWSigning.value = false;
        clearTimeout(isHWSigningToid);
        $q.loading.hide();
      }
    };
    const onSubmit = async () => {
      var _a;
      const txSubmitList = ((_a = txSignRes.value) == null ? void 0 : _a.filter((res2) => res2.cbor != null && res2.tx != null)) ?? [];
      if (txSubmitList.length === 0) {
        hasSubmitError({ error: ErrorSubmitTx.noTxToSubmit });
        return;
      }
      submitting.value = true;
      if (txSubmitType.value === "dapp") {
        emit("submit", txSubmitList.map((res2) => res2.witnessSetOwned ?? ""));
        emit("submitted");
        return;
      }
      if (!isAllConfirmed.value) {
        return;
      }
      const res = await submitTx(
        networkId.value,
        txSubmitList.length === 1 ? txSubmitList[0].cbor : txSubmitList.map((res2) => res2.cbor),
        txSubmitList.length === 1 ? txSubmitList[0].tx : txSubmitList.map((res2) => res2.tx)
      );
      if (!hasSubmitError(res)) {
        submitStatus.value = it(props.textId + ".submit.status.pending");
        submitInfo.value = it(props.textId + ".submit.info.waiting");
        setTimeout(() => {
          const txConfig = txBuildRes.value ? Array.isArray(txBuildRes.value) ? txBuildRes.value[0].txConfig : txBuildRes.value.txConfig : null;
          if (txConfig == null ? void 0 : txConfig.preventNavigation) ;
          else {
            openWalletPage("Transactions", walletId.value ?? void 0);
          }
          emit("submitted");
        }, 10);
      }
    };
    const onCancel = () => {
      if (isLedger.value) {
        closeLedger();
      }
      signError.value = "";
      isHWSigning.value = false;
      clearTimeout(isHWSigningToid);
      isLoading.value = false;
      isAllConfirmed.value = false;
      isConfirmed.value = [];
      isExpired.value = false;
      usesLockedUTxO.value = false;
      noOwnedKeys.value = false;
      $q.loading.hide();
      emit("cancel");
    };
    const onDownload = () => {
      if (txList.value.length > 0) {
        let content;
        if (txList.value.length > 1) {
          const contentArr = [];
          for (let i = 0; i < txList.value.length; i++) {
            contentArr.push({
              type: "Tx BabbageEra",
              description: isConfirmed.value[i] ? "signed" : "unsigned",
              cborHex: txList.value[i][1]
            });
          }
          content = contentArr;
        } else {
          content = {
            type: "Tx BabbageEra",
            description: isConfirmed.value[0] ? "signed" : "unsigned",
            cborHex: txList.value[0][1]
          };
        }
        downloadText(JSON.stringify(content, null, 2), "eternl-tx-" + (txList.value.length === 1 ? txList.value[0][0] : now$1().toString()) + "-" + (isAllConfirmed.value ? "signed" : "unsigned") + ".txt");
      }
    };
    const onDebugDownload = async () => {
      let errorMsg = "";
      if (hasParseError.value) {
        errorMsg = parseError.value;
      } else if (signError.value.length > 0) {
        errorMsg = signError.value;
      } else if (submitError.value.length > 0) {
        errorMsg = submitError.value;
      }
      const appInfo = getAppInfo();
      const debugData = {
        version: WALLET_VERSION,
        appInfo: {
          appType: Object.keys(AppType)[parseInt(appInfo.appType)],
          appMode: appInfo.appMode,
          platform: Object.keys(Platform)[parseInt(appInfo.platform)],
          environment: appInfo.environment,
          dappOrigin: appInfo.dappOrigin
        },
        error: errorMsg,
        txBuildRes: txBuildRes.value
      };
      try {
        if (isLedger.value) {
          debugData.ledger = getLedgerVersion();
        } else if (isTrezor.value) {
          debugData.trezor = await initiateTrezor();
        }
      } catch (err) {
      }
      await downloadText(JSON.stringify(debugData, null, 2), "eternl-debug-" + now$1().toString() + ".debug.json");
    };
    const onPasswordReset = () => {
      signError.value = "";
    };
    const hasSignError = (error) => {
      if (error) {
        console.error("signTx: hasSignError", error);
      }
      signError.value = getTxSignErrorMsg(error);
      if (error === ErrorSignTx.invalidPassword || (error == null ? void 0 : error.startsWith("Action rejected by user")) || (error == null ? void 0 : error.startsWith("Please unlock and open the Cardano app"))) {
        signErrorShowDebug.value = false;
      } else {
        signErrorShowDebug.value = true;
      }
      return signError.value.length > 0;
    };
    const hasSubmitError = (maybeError) => {
      if (maybeError == null ? void 0 : maybeError.error) {
        console.error("hasSubmitError", maybeError == null ? void 0 : maybeError.error);
      }
      submitError.value = getTxSubmitErrorMsg(maybeError == null ? void 0 : maybeError.error);
      return submitError.value.length > 0;
    };
    watch(txBuildRes, async (value) => {
      var _a, _b, _c, _d, _e;
      isLoading.value = true;
      isAllConfirmed.value = false;
      isConfirmed.value = [];
      isExpired.value = false;
      isMultiTx.value = value != null && Array.isArray(value) && value.length > 1;
      if (value) {
        const resList = Array.isArray(value) ? value : [value];
        const inputUtxoSet = /* @__PURE__ */ new Set();
        for (let i = 0; i < resList.length; i++) {
          if ((((_b = (_a = resList[i].builtTx) == null ? void 0 : _a.unknownInputUtxoList) == null ? void 0 : _b.length) ?? 0) > 0) {
            parseError.value = it(props.textId + ".confirm.error.unknownInputs");
            break;
          }
          txList.value.push([resList[i].txHash ?? "", resList[i].txCbor ?? ""]);
          if (accountData.value) {
            const creds = getSignTxCredList(resList[i], accountData.value);
            isConfirmed.value.push(creds.allOwnedSigned && creds.allForeignSigned);
          }
          if (!isExpired.value && ((_c = resList[i].builtTx) == null ? void 0 : _c.body.ttl)) {
            const ts = getTimestampFromSlot(networkId.value, parseInt(resList[i].builtTx.body.ttl));
            if (ts < now$1()) {
              isExpired.value = true;
            }
          }
          for (const input of ((_d = resList[i].builtTx) == null ? void 0 : _d.body.inputs) ?? []) {
            const utxo = `${input.transaction_id}#${input.index}`;
            if (inputUtxoSet.has(utxo)) {
              parseError.value = it(props.textId + ".confirm.multitx.doubleSpend") + utxo;
              break;
            }
            inputUtxoSet.add(utxo);
          }
        }
        isAllConfirmed.value = !isConfirmed.value.some((confirmed) => !confirmed);
        if (isAllConfirmed.value) {
          txSignRes.value = resList.map((res) => ({
            tx: res.builtTx,
            cbor: res.txCbor
          }));
          autoSubmit.value = false;
        }
        const inputHashList = /* @__PURE__ */ new Set();
        for (const res of resList) {
          for (const input of ((_e = res.builtTx) == null ? void 0 : _e.body.inputs) ?? []) {
            inputHashList.add(getUtxoHash(input));
          }
        }
        usesLockedUTxO.value = hasLockedUtxos(appAccount.value, Array.from(inputHashList));
        noOwnedKeys.value = resList.reduce((acc, curr) => curr.txCredList.length, 0) === 0;
      } else {
        usesLockedUTxO.value = false;
        noOwnedKeys.value = false;
      }
      isLoading.value = false;
    }, { immediate: true });
    watch(closeCounter, (value) => {
      onCancel();
    });
    return (_ctx, _cache) => {
      var _a;
      return openBlock(), createElementBlock(Fragment, null, [
        isKeystone.value ? (openBlock(), createBlock(_sfc_main$U, {
          key: 0,
          open: !!keystoneUR.value,
          "keystone-u-r": keystoneUR.value,
          onClose: onKeystoneClose,
          onDecode: onKeystoneScan
        }, null, 8, ["open", "keystone-u-r"])) : createCommentVNode("", true),
        unref(txBuildRes) ? (openBlock(), createElementBlock("div", _hoisted_1$6, [
          __props.showLabel ? (openBlock(), createBlock(_sfc_main$G, {
            key: 0,
            label: unref(it)(__props.textId + ".confirm.label"),
            class: "col-span-12"
          }, null, 8, ["label"])) : createCommentVNode("", true),
          createVNode(_sfc_main$G, {
            label: unref(walletName) + " - " + unref(accountName),
            class: "col-span-12",
            "do-capitalize": false
          }, null, 8, ["label"]),
          __props.showLabel ? (openBlock(), createBlock(_sfc_main$H, {
            key: 1,
            text: unref(it)(__props.textId + ".confirm.caption"),
            class: "col-span-12 cc-text-sz"
          }, null, 8, ["text"])) : createCommentVNode("", true),
          __props.showLabel && !isLoading.value ? (openBlock(), createBlock(GridSpace, {
            key: 2,
            hr: "",
            class: "col-span-12 my-0.5 sm:mt-2"
          })) : createCommentVNode("", true),
          isReadOnly.value ? (openBlock(), createElementBlock("div", _hoisted_2$5, [
            createVNode(_sfc_main$H, {
              text: unref(it)(__props.textId + ".confirm.info.readonly")
            }, null, 8, ["text"])
          ])) : createCommentVNode("", true),
          hasParseError.value ? (openBlock(), createBlock(_sfc_main$V, {
            key: 4,
            class: "col-span-12",
            css: "cc-rounded cc-banner-red",
            dense: "",
            icon: "mdi mdi-information-outline",
            html: "",
            text: parseError.value
          }, null, 8, ["text"])) : createCommentVNode("", true),
          hasParseError.value ? (openBlock(), createBlock(GridSpace, {
            key: 5,
            hr: "",
            class: "mt-0.5"
          })) : createCommentVNode("", true),
          isLedger.value && !isAllConfirmed.value && !hasParseError.value ? (openBlock(), createElementBlock("div", _hoisted_3$3, [
            createVNode(_sfc_main$W, { disabled: isHWSigning.value }, null, 8, ["disabled"]),
            createVNode(GridSpace, { hr: "" })
          ])) : createCommentVNode("", true),
          isHW.value || signError.value.length > 0 ? (openBlock(), createElementBlock("div", _hoisted_4$3, [
            isMnemonic.value ? (openBlock(), createBlock(GridSpace, { key: 0 })) : createCommentVNode("", true),
            createBaseVNode("div", _hoisted_5$3, [
              signError.value.length === 0 ? (openBlock(), createBlock(IconInfo, {
                key: 0,
                class: "w-7 flex-none mr-2"
              })) : (openBlock(), createBlock(IconError, {
                key: 1,
                class: "w-7 flex-none mr-2"
              })),
              signError.value.length === 0 ? (openBlock(), createBlock(_sfc_main$H, {
                key: 2,
                text: unref(it)(__props.textId + ".confirm.info." + (((_a = unref(walletData)) == null ? void 0 : _a.wallet.signType) ?? ""))
              }, null, 8, ["text"])) : (openBlock(), createBlock(_sfc_main$H, {
                key: 3,
                text: signError.value
              }, null, 8, ["text"]))
            ]),
            createVNode(GridSpace, {
              hr: "",
              class: "mt-3"
            })
          ])) : createCommentVNode("", true),
          (hasParseError.value || signError.value || submitError.value) && signErrorShowDebug.value ? (openBlock(), createElementBlock("div", _hoisted_6$3, [
            createBaseVNode("div", _hoisted_7$1, [
              createVNode(_sfc_main$H, {
                text: unref(it)(__props.textId + ".confirm.error.debug")
              }, null, 8, ["text"]),
              createVNode(_sfc_main$J, {
                url: "https://discord.gg/eternlwallet",
                label: "Discord (support ticket system)",
                "label-c-s-s": "cc-text-semi-bold hover:cc-text-blue"
              })
            ]),
            createVNode(_sfc_main$I, {
              class: "px-4",
              capitalize: false,
              label: unref(it)(__props.textId + ".confirm.button.debug"),
              link: onDebugDownload
            }, null, 8, ["label"])
          ])) : createCommentVNode("", true),
          (hasParseError.value || signError.value || submitError.value) && signErrorShowDebug.value ? (openBlock(), createBlock(GridSpace, {
            key: 9,
            hr: ""
          })) : createCommentVNode("", true),
          isAllConfirmed.value && !hasParseError.value ? (openBlock(), createElementBlock("div", _hoisted_8$1, [
            createBaseVNode("div", _hoisted_9, [
              isExpired.value || submitError.value ? (openBlock(), createBlock(IconError, {
                key: 0,
                class: "w-7 flex-none mr-2"
              })) : (openBlock(), createBlock(IconCheck, {
                key: 1,
                class: "w-7 flex-none mr-2 text-green-600"
              })),
              isExpired.value ? (openBlock(), createBlock(_sfc_main$H, {
                key: 2,
                text: unref(it)(__props.textId + ".confirm.error.expired"),
                class: "mt-1"
              }, null, 8, ["text"])) : submitError.value ? (openBlock(), createBlock(_sfc_main$H, {
                key: 3,
                text: unref(it)(__props.textId + ".confirm.error.submit"),
                class: "mt-1"
              }, null, 8, ["text"])) : autoSubmit.value ? (openBlock(), createBlock(_sfc_main$H, {
                key: 4,
                text: unref(it)(__props.textId + ".confirm.info.submitList"),
                class: "mt-1"
              }, null, 8, ["text"])) : (openBlock(), createBlock(_sfc_main$H, {
                key: 5,
                text: unref(it)(__props.textId + ".confirm.info.submit"),
                class: "mt-1"
              }, null, 8, ["text"]))
            ]),
            submitting.value ? (openBlock(), createElementBlock("div", _hoisted_10, [
              createBaseVNode("div", _hoisted_11, [
                createBaseVNode("div", _hoisted_12, [
                  createBaseVNode("span", _hoisted_13, toDisplayString(submitStatus.value), 1),
                  !submitError.value ? (openBlock(), createElementBlock("span", _hoisted_14, [
                    createBaseVNode("span", null, toDisplayString(submitInfo.value), 1),
                    (openBlock(true), createElementBlock(Fragment, null, renderList(txListPaged.value, (tx) => {
                      return openBlock(), createBlock(_sfc_main$$, {
                        key: tx[0],
                        subject: tx[0],
                        type: "transaction",
                        label: tx[0],
                        "label-c-s-s": "cc-addr cc-text-white ",
                        class: normalizeClass("cc-text-white ")
                      }, null, 8, ["subject", "label"]);
                    }), 128)),
                    tl_showPagination.value ? (openBlock(), createBlock(QPagination_default, {
                      key: 0,
                      modelValue: tl_currentPage.value,
                      "onUpdate:modelValue": _cache[0] || (_cache[0] = ($event) => tl_currentPage.value = $event),
                      max: tl_maxPages.value,
                      "max-pages": 6,
                      "boundary-numbers": "",
                      flat: "",
                      color: "teal-90",
                      "text-color": "teal-90",
                      "active-color": "teal-90",
                      "active-text-color": "teal-90",
                      "active-design": "unelevated"
                    }, null, 8, ["modelValue", "max"])) : createCommentVNode("", true)
                  ])) : createCommentVNode("", true),
                  submitError.value ? (openBlock(), createElementBlock("span", _hoisted_15, toDisplayString(submitError.value), 1)) : createCommentVNode("", true)
                ]),
                !submitError.value && !submitSuccess.value ? (openBlock(), createElementBlock("div", _hoisted_16, [
                  createVNode(QSpinner_default, {
                    color: "white",
                    size: "3em",
                    thickness: 2
                  })
                ])) : createCommentVNode("", true)
              ])
            ])) : createCommentVNode("", true)
          ])) : createCommentVNode("", true),
          !isAllConfirmed.value && isMnemonic.value && !hasParseError.value ? (openBlock(), createBlock(_sfc_main$X, {
            key: 11,
            class: "col-span-12",
            autocomplete: "off",
            "skip-validation": "",
            autofocus: "",
            onSubmit: signTx,
            onReset: onPasswordReset
          }, {
            btnBack: withCtx(() => [
              createVNode(GridButtonSecondary, {
                class: "col-start-0 col-span-6 sm:col-start-0 sm:col-span-3",
                type: "button",
                label: unref(it)("common.label.cancel"),
                link: onCancel
              }, null, 8, ["label"])
            ]),
            _: 1
          })) : createCommentVNode("", true),
          isHW.value ? renderSlot(_ctx.$slots, "btnBack", { key: 12 }, () => [
            createVNode(GridButtonSecondary, {
              class: "col-start-0 col-span-6 sm:col-start-0 sm:col-span-3",
              type: "button",
              label: unref(it)("common.label.cancel"),
              link: onCancel
            }, null, 8, ["label"])
          ]) : createCommentVNode("", true),
          !isAllConfirmed.value && isHW.value && !hasParseError.value ? (openBlock(), createBlock(_sfc_main$I, {
            key: 13,
            class: "col-start-7 col-span-6 sm:col-start-10 sm:col-span-3",
            disabled: isHWSigning.value,
            label: unref(it)(__props.textId + ".confirm.button.sign"),
            link: signTx
          }, null, 8, ["disabled", "label"])) : createCommentVNode("", true),
          isAllConfirmed.value && !autoSubmit.value && !hasParseError.value ? (openBlock(), createBlock(_sfc_main$I, {
            key: 14,
            class: "col-start-7 col-span-6 sm:col-start-10 sm:col-span-3",
            label: unref(it)(__props.textId + ".confirm.button.submit"),
            link: onSubmit,
            disabled: isExpired.value
          }, null, 8, ["label", "disabled"])) : createCommentVNode("", true),
          !hasParseError.value ? (openBlock(), createBlock(GridSpace, {
            key: 15,
            hr: "",
            class: "col-span-12 my-1"
          })) : createCommentVNode("", true),
          noOwnedKeys.value && !isAllConfirmed.value && !hasParseError.value ? (openBlock(), createBlock(_sfc_main$V, {
            key: 16,
            class: "col-span-12",
            "text-c-s-s": "cc-text-normal text-justify",
            css: "cc-rounded cc-banner-warning",
            label: unref(it)("common.tx.note.missingkeys.label"),
            text: unref(it)("common.tx.note.missingkeys.text"),
            icon: unref(it)("common.tx.note.missingkeys.icon")
          }, null, 8, ["label", "text", "icon"])) : createCommentVNode("", true),
          isHWSigning.value ? (openBlock(), createBlock(_sfc_main$V, {
            key: 17,
            class: "col-span-12",
            "text-c-s-s": "cc-text-normal text-justify flex flex-row flex-nowrap items-center gap-2",
            css: "cc-rounded cc-banner-blue",
            label: unref(it)("common.tx.note.ishwsigning.label"),
            text: unref(it)("common.tx.note.ishwsigning.text"),
            icon: unref(it)("common.tx.note.ishwsigning.icon"),
            animation: unref(it)("common.tx.note.ishwsigning.animation")
          }, null, 8, ["label", "text", "icon", "animation"])) : createCommentVNode("", true),
          noOwnedKeys.value && !isAllConfirmed.value && !hasParseError.value ? (openBlock(), createBlock(GridSpace, {
            key: 18,
            class: "col-span-12",
            hr: ""
          })) : createCommentVNode("", true),
          createVNode(_sfc_main$G, {
            label: unref(it)(__props.textId + ".confirm.preview.label") + " (Wallet: " + unref(walletName) + ", " + unref(accountName) + ")",
            class: "col-span-12",
            "do-capitalize": false
          }, null, 8, ["label"]),
          createVNode(_sfc_main$H, {
            text: unref(it)(__props.textId + ".confirm.preview.caption"),
            class: "col-span-12 cc-text-sz"
          }, null, 8, ["text"]),
          createVNode(_sfc_main$Y, { active: isLoading.value }, null, 8, ["active"]),
          usesLockedUTxO.value ? (openBlock(), createBlock(_sfc_main$V, {
            key: 19,
            class: "col-span-12",
            css: "cc-rounded cc-banner-warning",
            dense: "",
            icon: "mdi mdi-information-outline",
            text: unref(it)("wallet.send.locked.caption")
          }, null, 8, ["text"])) : createCommentVNode("", true),
          unref(totalBalance) && !isLoading.value ? (openBlock(), createElementBlock("div", _hoisted_17, [
            createBaseVNode("div", _hoisted_18, [
              createVNode(_sfc_main$G, {
                label: unref(it)(__props.textId + ".confirm.multitx.label")
              }, null, 8, ["label"])
            ]),
            createVNode(_sfc_main$Z, { "tx-balance": unref(totalBalance) }, null, 8, ["tx-balance"])
          ])) : createCommentVNode("", true),
          txList.value.length > 1 ? (openBlock(), createElementBlock("div", _hoisted_19, [
            createVNode(QPagination_default, {
              modelValue: t_currentPage.value,
              "onUpdate:modelValue": _cache[1] || (_cache[1] = ($event) => t_currentPage.value = $event),
              max: txList.value.length,
              "max-pages": 6,
              "boundary-numbers": "",
              flat: "",
              color: "teal-90",
              "text-color": "teal-90",
              "active-color": "teal-90",
              "active-text-color": "teal-90",
              "active-design": "unelevated"
            }, null, 8, ["modelValue", "max"])
          ])) : createCommentVNode("", true),
          warning.value ? (openBlock(), createBlock(_sfc_main$V, {
            key: 22,
            text: getWarningText(warning.value),
            class: "col-span-12",
            "text-c-s-s": "cc-text-normal text-justify",
            css: `cc-rounded ${getWarningColor(warning.value)}`
          }, null, 8, ["text", "css"])) : createCommentVNode("", true),
          unref(accountId) && isAllTxValid.value && !isLoading.value && _tx.value ? (openBlock(), createBlock(_sfc_main$_, {
            key: 23,
            "tx-balance": Array.isArray(unref(txBalance)) ? unref(txBalance)[t_currentPage.value - 1] : unref(txBalance),
            tx: _tx.value,
            "account-id": unref(accountId),
            "staging-tx": !isConfirmed.value[0],
            signed: isConfirmed.value[0],
            "always-open": "",
            "witness-check": ""
          }, null, 8, ["tx-balance", "tx", "account-id", "staging-tx", "signed"])) : createCommentVNode("", true),
          createBaseVNode("div", _hoisted_20, [
            txList.value.length > 1 ? (openBlock(), createBlock(QPagination_default, {
              key: 0,
              modelValue: t_currentPage.value,
              "onUpdate:modelValue": _cache[2] || (_cache[2] = ($event) => t_currentPage.value = $event),
              max: txList.value.length,
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
          txList.value.length > 0 ? (openBlock(), createBlock(_sfc_main$I, {
            key: 24,
            class: "col-start-7 col-span-6 sm:col-start-9 sm:col-span-4 px-4 mt-1",
            capitalize: false,
            label: unref(it)(__props.textId + ".confirm.button.download") + " (" + (isAllConfirmed.value ? "signed" : "unsigned") + ")",
            link: onDownload
          }, null, 8, ["label"])) : createCommentVNode("", true)
        ])) : (openBlock(), createElementBlock("div", _hoisted_21, [
          createBaseVNode("div", _hoisted_22, [
            createVNode(QSpinnerDots_default, {
              color: "gray",
              size: "2em"
            })
          ])
        ]))
      ], 64);
    };
  }
});
const _hoisted_1$5 = { class: "grow-0 shrink-0 w-full flex flex-row flex-nowrap items-start justify-between cc-bg-white-0 border-b cc-p" };
const _hoisted_2$4 = { class: "flex flex-col cc-text-sz" };
const _sfc_main$5 = /* @__PURE__ */ defineComponent({
  __name: "SignTxModal",
  setup(__props) {
    useTranslation();
    const {
      txBuildRes,
      resetSignTx
    } = useSignTx();
    const modelCloseCounter = ref(1);
    const onSubmit = (witnessSetList) => {
      dispatchSignal(onTxSignSubmit, witnessSetList);
      resetSignTx();
    };
    const onCancel = () => {
      dispatchSignal(onTxSignCancel);
      resetSignTx();
    };
    const onPreClose = () => {
      modelCloseCounter.value += 1;
    };
    const onSubmitDone = () => {
      setTimeout(() => {
        resetSignTx();
      }, 1e3);
    };
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", null, [
        !!unref(txBuildRes) ? (openBlock(), createBlock(Modal, {
          key: 0,
          "modal-container": "#eternl-sign",
          "half-wide": "",
          "full-width-on-mobile": "",
          onPreclose: onPreClose
        }, {
          header: withCtx(() => [
            createBaseVNode("div", _hoisted_1$5, [
              createBaseVNode("div", _hoisted_2$4, [
                createVNode(_sfc_main$G, {
                  label: "Sign transaction",
                  "do-capitalize": ""
                })
              ])
            ])
          ]),
          content: withCtx(() => [
            createVNode(_sfc_main$6, {
              "text-id": "wallet.send.step",
              closeCounter: modelCloseCounter.value,
              onSubmitted: onSubmitDone,
              onSubmit,
              onCancel
            }, null, 8, ["closeCounter"])
          ]),
          default: withCtx(() => [
            _cache[0] || (_cache[0] = createTextVNode(' @close ="onClose"> '))
          ]),
          _: 1
        })) : createCommentVNode("", true)
      ]);
    };
  }
});
const _hoisted_1$4 = { class: "w-full mb-4 text-left" };
const _hoisted_2$3 = {
  key: 0,
  class: "text-left"
};
const _hoisted_3$2 = { class: "cc-table-cell-left" };
const _hoisted_4$2 = {
  key: 1,
  class: "text-left"
};
const _hoisted_5$2 = { class: "cc-table-cell-left" };
const _hoisted_6$2 = { class: "cc-table-cell break-all max-h-24 overflow-y-auto cc-text-semi-bold" };
const _sfc_main$4 = /* @__PURE__ */ defineComponent({
  __name: "JsonTableView",
  props: {
    json: { type: Object, required: true, default: "{}" }
  },
  setup(__props) {
    useTranslation();
    const formatName = (text) => {
      if (typeof text !== "string") return text;
      const result = text.replace(/([A-Z])/g, " $1");
      return result.charAt(0).toUpperCase() + result.slice(1);
    };
    return (_ctx, _cache) => {
      const _component_JsonTableView = resolveComponent("JsonTableView", true);
      return openBlock(), createElementBlock("table", _hoisted_1$4, [
        (openBlock(true), createElementBlock(Fragment, null, renderList(__props.json, (tokenMeta, name, number) => {
          return openBlock(), createElementBlock(Fragment, null, [
            typeof tokenMeta === "object" ? (openBlock(), createElementBlock("tr", _hoisted_2$3, [
              createBaseVNode("th", _hoisted_3$2, toDisplayString(formatName(name)), 1),
              typeof tokenMeta === "object" ? (openBlock(), createBlock(_component_JsonTableView, {
                key: 0,
                json: tokenMeta,
                class: "cc-table-cell table-auto"
              }, null, 8, ["json"])) : createCommentVNode("", true)
            ])) : (openBlock(), createElementBlock("tr", _hoisted_4$2, [
              createBaseVNode("th", _hoisted_5$2, toDisplayString(formatName(name)), 1),
              createBaseVNode("th", _hoisted_6$2, toDisplayString(tokenMeta), 1)
            ]))
          ], 64);
        }), 256))
      ]);
    };
  }
});
const JsonTableView = /* @__PURE__ */ _export_sfc(_sfc_main$4, [["__scopeId", "data-v-990c94ea"]]);
const _hoisted_1$3 = {
  key: 1,
  class: "cc-page-p cc-grid"
};
const _hoisted_2$2 = {
  key: 3,
  class: "col-span-12 grid grid-cols-12 cc-gap"
};
const _hoisted_3$1 = {
  key: 4,
  class: "relative col-span-12 -top-2"
};
const _hoisted_4$1 = {
  key: 5,
  class: "relative col-span-12 grid grid-cols-12"
};
const _hoisted_5$1 = { class: "col-span-12 flex flex-row flex-nowrap items-center whitespace-pre-wrap cc-text-sz" };
const _hoisted_6$1 = {
  key: 11,
  class: "col-span-12"
};
const _hoisted_7 = { class: "relative cc-rounded cc-bg-txdetails my-1 p-1 px-2 col-span-12" };
const _hoisted_8 = { class: "w-full pb-1 pr-1 whitespace-pre-wrap font-mono overflow-auto" };
const _sfc_main$3 = /* @__PURE__ */ defineComponent({
  __name: "SignDataConfirm",
  props: {
    type: { type: String, required: false, default: "" },
    textId: { type: String, required: true, default: "" },
    showLabel: { type: Boolean, required: false, default: true }
  },
  emits: ["submit", "submitted", "cancel"],
  setup(__props, { emit: __emit }) {
    const emit = __emit;
    const { it } = useTranslation();
    const $q = useQuasar();
    const reqSignKeyReadable = ref("");
    const reqSignKeyType = ref("");
    const {
      addr,
      payload,
      txSubmitType,
      accountId,
      walletId
    } = useSignData();
    const {
      appAccount,
      accountData,
      walletData
    } = useWalletAccount(walletId, accountId);
    const isReadOnly = computed(() => !!walletData.value && walletData.value.wallet.signType === "readonly");
    const isMnemonic = computed(() => !!walletData.value && walletData.value.wallet.signType === "mnemonic");
    const isLedger = computed(() => !!walletData.value && walletData.value.wallet.signType === "ledger");
    const isTrezor = computed(() => !!walletData.value && walletData.value.wallet.signType === "trezor");
    const isKeystone = computed(() => !!walletData.value && walletData.value.wallet.signType === "keystone");
    const isHW = computed(() => isLedger.value || isTrezor.value || isKeystone.value);
    const payloadBlake = ref("");
    const isHWSigning = ref(false);
    let isHWSigningToid = -1;
    const {
      signMessageWithLedger,
      closeLedger
    } = useLedgerDevice();
    const {
      createKeystoneSignDataRequest,
      handleKeystoneSignData
    } = useKeystoneDevice();
    const keystoneUR = ref();
    const signedData = ref(null);
    const signError = ref("");
    const isConfirmed = ref(false);
    const hasErrors = ref(false);
    const errorMessage = ref("");
    const payloadDecoded = ref(uint8ArrayToUtf8String(toHexArray(payload.value ?? "00")));
    const isJsonData = ref(false);
    const onSubmit = async () => {
      var _a, _b;
      emit("submit", { signedData: {
        signature: ((_a = signedData.value) == null ? void 0 : _a.signature) ?? "",
        key: ((_b = signedData.value) == null ? void 0 : _b.key) ?? ""
      } });
      emit("submitted");
    };
    const doSignData = async (_payload) => {
      signError.value = "";
      isConfirmed.value = false;
      try {
        console.warn("signData: accountData.value:", accountData.value);
        console.warn("signData: walletData.value:", walletData.value);
        if (!appAccount.value) {
          throw ErrorSignData.missingAccountData;
        }
        if (!accountData.value) {
          throw ErrorSignData.missingAccountData;
        }
        if (!walletData.value) {
          throw ErrorSignData.missingWalletData;
        }
        if (isLedger.value || isTrezor.value) {
          clearTimeout(isHWSigningToid);
          isHWSigningToid = setTimeout(() => {
            isHWSigning.value = true;
          }, 250);
        }
        if (isMnemonic.value) {
          if (!(_payload == null ? void 0 : _payload.password)) {
            throw ErrorSignData.failedToSign;
          }
          signedData.value = signData(walletData.value, accountData.value, _payload.password, addr.value, payload.value);
          if (!signedData.value) {
            throw ErrorSignData.credentialNotFound;
          }
          verifyData(signedData.value, addr.value, payload.value);
        } else if (isLedger.value) {
          signedData.value = await signMessageWithLedger(appAccount.value, addr.value, payload.value);
          verifyData(signedData.value, addr.value, payload.value);
        } else if (isKeystone.value) {
          const ur = await createKeystoneSignDataRequest(appAccount.value, walletData.value, addr.value, payload.value);
          signedData.value = await signWithKeystone(ur);
          verifyData(signedData.value, addr.value, payload.value);
        }
        isConfirmed.value = true;
        setTimeout(() => {
          onSubmit();
        }, 25);
      } catch (err) {
        hasSignError(err);
      }
      if (isHW.value) {
        isHWSigning.value = false;
        clearTimeout(isHWSigningToid);
      }
    };
    const onPasswordReset = () => {
      signError.value = "";
    };
    const hasSignError = (error) => {
      console.error("signData: hasSignError", error);
      signError.value = getDataSignErrorMsg(error);
      return signError.value.length > 0;
    };
    const onCancel = () => {
      console.log("onCancel");
      if (isLedger.value) {
        closeLedger();
      }
      signError.value = "";
      isHWSigning.value = false;
      clearTimeout(isHWSigningToid);
      isConfirmed.value = false;
      emit("cancel");
    };
    let keystoneSignResolve = null;
    function signWithKeystone(ur) {
      return new Promise((resolve, reject) => {
        keystoneSignResolve = resolve;
        keystoneUR.value = ur;
      });
    }
    function onKeystoneClose() {
      if (keystoneSignResolve) {
        keystoneSignResolve({ error: "Scan rejected" });
        keystoneSignResolve = null;
      }
      keystoneUR.value = void 0;
    }
    function onKeystoneScan(data) {
      try {
        $q.notify({
          type: "positive",
          message: it("wallet.keystone.ok"),
          position: "top-left"
        });
        if (keystoneSignResolve) {
          keystoneSignResolve(handleKeystoneSignData(data.type, data.cbor));
        }
      } catch (err) {
        if (keystoneSignResolve) {
          keystoneSignResolve({ error: (err == null ? void 0 : err.message) ?? JSON.stringify(err) });
        }
      }
      keystoneUR.value = void 0;
    }
    watch(txSubmitType, async (value) => {
      isConfirmed.value = false;
      if (value) {
        if (walletData.value && accountData.value && addr.value && payload.value) {
          if (!isMnemonic.value && !isLedger.value && !isKeystone.value) {
            hasErrors.value = true;
            errorMessage.value = "Signing data is currently not supported by your hardware device (" + accountData.value.account.signType + ")";
          } else {
            const str = toHexArray(payload.value);
            try {
              payloadBlake.value = blake2b224Str(toBuffer(payload.value));
            } catch (err) {
            }
            if (str.length <= 0) {
              hasErrors.value = true;
              errorMessage.value = "The payload that you want to sign is not a hex string: " + payload.value;
            } else {
              try {
                payloadDecoded.value = JSON.parse(uint8ArrayToUtf8String(str));
                isJsonData.value = true;
                console.log("data to sign", payload.value);
              } catch (error) {
              }
            }
          }
        } else {
          hasErrors.value = true;
          errorMessage.value = "An input is missing.";
        }
        if (hasErrors.value) {
          $q.notify({
            type: "negative",
            message: "error: " + errorMessage.value,
            position: "top-left",
            timeout: 225e3
          });
        }
      } else {
        hasErrors.value = true;
        errorMessage.value = "";
      }
    }, { immediate: true });
    watchEffect(() => {
      const addressInput = addr.value;
      const appAccountInput = appAccount.value;
      if (addressInput && appAccountInput) {
        try {
          const details = getAccountKeyDetails(addressInput, appAccountInput == null ? void 0 : appAccountInput.data);
          reqSignKeyReadable.value = details.displayStr;
          reqSignKeyType.value = details.displayType;
        } catch (err) {
          hasErrors.value = true;
          errorMessage.value = getDataSignErrorMsg(err);
        }
      }
    });
    return (_ctx, _cache) => {
      var _a;
      return openBlock(), createElementBlock(Fragment, null, [
        isKeystone.value ? (openBlock(), createBlock(_sfc_main$U, {
          key: 0,
          open: !!keystoneUR.value,
          "keystone-u-r": keystoneUR.value,
          onClose: onKeystoneClose,
          onDecode: onKeystoneScan
        }, null, 8, ["open", "keystone-u-r"])) : createCommentVNode("", true),
        unref(txSubmitType) ? (openBlock(), createElementBlock("div", _hoisted_1$3, [
          __props.showLabel ? (openBlock(), createBlock(_sfc_main$G, {
            key: 0,
            label: unref(it)(__props.textId + ".label"),
            class: "col-span-12"
          }, null, 8, ["label"])) : createCommentVNode("", true),
          __props.showLabel ? (openBlock(), createBlock(_sfc_main$H, {
            key: 1,
            text: unref(it)(__props.textId + ".caption"),
            class: "col-span-12 cc-text-sz"
          }, null, 8, ["text"])) : createCommentVNode("", true),
          __props.showLabel ? (openBlock(), createBlock(GridSpace, {
            key: 2,
            hr: "",
            class: "col-span-12 my-0.5 sm:mt-2"
          })) : createCommentVNode("", true),
          isReadOnly.value ? (openBlock(), createElementBlock("div", _hoisted_2$2, [
            createVNode(_sfc_main$H, {
              text: unref(it)(__props.textId + ".info.readonly")
            }, null, 8, ["text"])
          ])) : createCommentVNode("", true),
          isLedger.value ? (openBlock(), createElementBlock("div", _hoisted_3$1, [
            createVNode(_sfc_main$W, { disabled: isHWSigning.value }, null, 8, ["disabled"]),
            createVNode(GridSpace, { hr: "" })
          ])) : createCommentVNode("", true),
          (isHW.value || signError.value.length > 0) && !isConfirmed.value ? (openBlock(), createElementBlock("div", _hoisted_4$1, [
            isMnemonic.value ? (openBlock(), createBlock(GridSpace, { key: 0 })) : createCommentVNode("", true),
            createBaseVNode("div", _hoisted_5$1, [
              signError.value.length === 0 ? (openBlock(), createBlock(IconInfo, {
                key: 0,
                class: "w-7 flex-none mr-2"
              })) : (openBlock(), createBlock(IconError, {
                key: 1,
                class: "w-7 flex-none mr-2"
              })),
              signError.value.length === 0 ? (openBlock(), createBlock(_sfc_main$H, {
                key: 2,
                text: unref(it)(__props.textId + ".info." + (((_a = unref(walletData)) == null ? void 0 : _a.wallet.signType) ?? ""))
              }, null, 8, ["text"])) : (openBlock(), createBlock(_sfc_main$H, {
                key: 3,
                text: signError.value
              }, null, 8, ["text"]))
            ]),
            createVNode(GridSpace, {
              hr: "",
              class: "mt-4 mb-0.5 sm:mb-2"
            })
          ])) : createCommentVNode("", true),
          !isConfirmed.value && isMnemonic.value ? (openBlock(), createBlock(_sfc_main$X, {
            key: 6,
            class: "col-span-12",
            autocomplete: "off",
            "skip-validation": "",
            onSubmit: doSignData,
            onReset: onPasswordReset
          }, {
            btnBack: withCtx(() => [
              createVNode(GridButtonSecondary, {
                class: "col-start-0 col-span-6 sm:col-start-0 sm:col-span-3",
                type: "button",
                label: unref(it)("common.label.cancel"),
                link: onCancel
              }, null, 8, ["label"])
            ]),
            _: 1
          })) : createCommentVNode("", true),
          !isConfirmed.value && isHW.value ? (openBlock(), createBlock(_sfc_main$I, {
            key: 7,
            class: "col-start-7 col-span-6 sm:col-start-10 sm:col-span-3",
            disabled: isHWSigning.value,
            label: unref(it)(__props.textId + ".button.sign"),
            link: doSignData
          }, null, 8, ["disabled", "label"])) : createCommentVNode("", true),
          createVNode(GridSpace, {
            hr: "",
            class: "col-span-12 my-0.5 sm:my-2"
          }),
          isHWSigning.value ? (openBlock(), createBlock(_sfc_main$V, {
            key: 8,
            class: "col-span-12",
            "text-c-s-s": "cc-text-normal text-justify flex flex-row flex-nowrap items-center gap-2",
            css: "cc-rounded cc-banner-blue",
            label: unref(it)("common.tx.note.ishwsigning.label"),
            text: unref(it)("common.tx.note.ishwsigning.text"),
            icon: unref(it)("common.tx.note.ishwsigning.icon"),
            animation: unref(it)("common.tx.note.ishwsigning.animation")
          }, null, 8, ["label", "text", "icon", "animation"])) : createCommentVNode("", true),
          isHWSigning.value ? (openBlock(), createBlock(GridSpace, {
            key: 9,
            class: "col-span-12 my-0.5 sm:my-2",
            hr: ""
          })) : createCommentVNode("", true),
          unref(payload) && !isJsonData.value ? (openBlock(), createBlock(_sfc_main$V, {
            key: 10,
            class: "col-span-12",
            "text-c-s-s": "cc-text-normal flex justify-start items-center",
            css: "cc-area-light",
            label: unref(it)(__props.textId + ".preview.label"),
            text: payloadDecoded.value + " (" + unref(payload) + ")",
            icon: unref(it)(__props.textId + ".preview.icon")
          }, null, 8, ["label", "text", "icon"])) : unref(payload) && isJsonData.value ? (openBlock(), createElementBlock("div", _hoisted_6$1, [
            createVNode(_sfc_main$G, {
              label: unref(it)(__props.textId + ".preview.table.label"),
              dense: "",
              class: ""
            }, null, 8, ["label"]),
            createVNode(JsonTableView, {
              class: "mt-2",
              json: payloadDecoded.value
            }, null, 8, ["json"]),
            createBaseVNode("div", _hoisted_7, [
              createVNode(_sfc_main$G, {
                label: unref(it)(__props.textId + ".preview.decoded.label"),
                dense: "",
                class: ""
              }, null, 8, ["label"]),
              createVNode(_sfc_main$10, {
                label: unref(it)("wallet.transactions.button.copy.sign.label"),
                "label-hover": unref(it)("wallet.transactions.button.copy.sign.hover"),
                "notification-text": unref(it)("wallet.transactions.button.copy.sign.notify"),
                "copy-text": JSON.stringify(payloadDecoded.value, null, 2),
                showCopiedContent: false,
                class: "flex items-center justify-center"
              }, null, 8, ["label", "label-hover", "notification-text", "copy-text"]),
              createBaseVNode("div", _hoisted_8, [
                createVNode(unref(S), {
                  showLength: "",
                  showDoubleQuotes: false,
                  deep: 0,
                  data: payloadDecoded.value
                }, null, 8, ["data"])
              ])
            ])
          ])) : createCommentVNode("", true),
          payloadBlake.value ? (openBlock(), createBlock(_sfc_main$V, {
            key: 12,
            class: "col-span-12",
            "text-c-s-s": "cc-text-normal flex justify-start items-center",
            css: "cc-area-light",
            label: "Blake2b224 hash of payload",
            text: payloadBlake.value,
            icon: unref(it)(__props.textId + ".preview.icon")
          }, null, 8, ["text", "icon"])) : createCommentVNode("", true),
          createVNode(_sfc_main$V, {
            class: "col-span-12",
            "text-c-s-s": "cc-text-normal flex justify-start items-center",
            css: "cc-area-light",
            "is-info": "",
            label: "Signature requested: " + reqSignKeyType.value + " key",
            text: reqSignKeyReadable.value,
            icon: unref(it)(__props.textId + ".preview.icon")
          }, null, 8, ["label", "text", "icon"])
        ])) : createCommentVNode("", true)
      ], 64);
    };
  }
});
const _hoisted_1$2 = { class: "grow-0 shrink-0 w-full flex flex-row flex-nowrap items-start justify-between cc-bg-white-0 border-b cc-p" };
const _hoisted_2$1 = { class: "flex flex-col cc-text-sz" };
const _sfc_main$2 = /* @__PURE__ */ defineComponent({
  __name: "SignDataModal",
  setup(__props) {
    useQuasar();
    useTranslation();
    const {
      txSubmitType,
      accountId,
      resetSignData
    } = useSignData();
    const onSubmit = (witnessSet) => {
      dispatchSignal(onDataSignSubmit, witnessSet);
      resetSignData();
    };
    const onCancel = () => {
      dispatchSignal(onDataSignCancel);
      resetSignData();
    };
    const onClose = onCancel;
    const onSubmitDone = () => {
      setTimeout(() => {
        resetSignData();
      }, 1e3);
    };
    return (_ctx, _cache) => {
      return openBlock(), createElementBlock("div", null, [
        !!unref(txSubmitType) ? (openBlock(), createBlock(Modal, {
          key: 0,
          "modal-container": "#eternl-sign-data",
          "half-wide": "",
          "full-width-on-mobile": "",
          onClose: unref(onClose)
        }, {
          header: withCtx(() => [
            createBaseVNode("div", _hoisted_1$2, [
              createBaseVNode("div", _hoisted_2$1, [
                createVNode(_sfc_main$G, {
                  label: "Sign data ",
                  "do-capitalize": ""
                })
              ])
            ])
          ]),
          content: withCtx(() => [
            createVNode(_sfc_main$3, {
              "text-id": "wallet.signdata.step.confirm",
              onSubmitted: onSubmitDone,
              onSubmit,
              onCancel
            })
          ]),
          _: 1
        }, 8, ["onClose"])) : createCommentVNode("", true)
      ]);
    };
  }
});
const _hoisted_1$1 = {
  key: 0,
  class: "absolute top-0 left-0 w-0 h-0 overflow-hidden"
};
const _sfc_main$1 = /* @__PURE__ */ defineComponent({
  __name: "DAppIframes",
  setup(__props) {
    const {
      dappAccountId: dappAccountId2,
      dappWalletId,
      accountData,
      walletData
    } = useDappAccount();
    const allowInit = ref(false);
    onMounted(() => {
      nextTick(() => {
        allowInit.value = true;
      });
    });
    return (_ctx, _cache) => {
      return unref(walletData) && unref(accountData) && allowInit.value ? (openBlock(), createElementBlock("div", _hoisted_1$1, [
        (openBlock(true), createElementBlock(Fragment, null, renderList(unref(entryList), (item) => {
          return openBlock(), createBlock(_sfc_main$11, {
            key: item.id + "_iframe_modal",
            walletId: unref(dappWalletId),
            accountId: unref(dappAccountId2),
            "dapp-connect": item,
            "is-staging": unref(isStagingApp)(),
            "html-id": item.id
          }, null, 8, ["walletId", "accountId", "dapp-connect", "is-staging", "html-id"]);
        }), 128))
      ])) : createCommentVNode("", true);
    };
  }
});
const _hoisted_1 = {
  class: "relative w-full h-full cc-layout-px cc-layout-py cc-text-color flex flex-col flex-nowrap",
  id: "cc-layout-container"
};
const _hoisted_2 = {
  class: "relative flex-grow w-full flex-1 cc-site-max-width mx-auto flex flex-col flex-nowrap",
  id: "cc-main-container"
};
const _hoisted_3 = {
  class: "relative flex-1 flex-grow-1 h-full overflow-hidden cc-rounded-la cc-shadow flex flex-row flex-nowrap",
  style: { "min-height": "222px" }
};
const _hoisted_4 = { class: "relative flex-1 w-full h-full" };
const _hoisted_5 = { class: "relative w-full h-full cc-rounded-la flex flex-row flex-nowrap cc-bg-light-1" };
const _hoisted_6 = { class: "relative h-full flex-1 overflow-hidden focus:outline-none flex flex-col flex-nowrap cc-text-sz" };
const _sfc_main = /* @__PURE__ */ defineComponent({
  __name: "NetworkLayout",
  setup(__props) {
    onBeforeMount(() => {
      setNotifyFunction(useQuasar().notify);
    });
    window.addEventListener("beforeunload", async () => {
      await disconnectCardanoConnect(networkId.value);
      await WalletConnectManager.getManager().disconnectAll();
    });
    onBeforeUnmount(async () => {
      await disconnectCardanoConnect(networkId.value);
      await WalletConnectManager.getManager().disconnectAll();
    });
    return (_ctx, _cache) => {
      const _component_router_view = resolveComponent("router-view");
      return openBlock(), createElementBlock(Fragment, null, [
        createBaseVNode("div", _hoisted_1, [
          _cache[0] || (_cache[0] = createBaseVNode("div", {
            class: "fixed inset-0 bg-gradient-to-r from-slate-350 to-stone-300 dark:from-slate-900 dark:to-stone-900",
            id: "cc-background-iframe-container"
          }, null, -1)),
          createVNode(_sfc_main$w),
          createVNode(_sfc_main$t),
          createBaseVNode("div", _hoisted_2, [
            createVNode(_sfc_main$p),
            createBaseVNode("div", _hoisted_3, [
              createBaseVNode("div", _hoisted_4, [
                createBaseVNode("div", _hoisted_5, [
                  createBaseVNode("main", _hoisted_6, [
                    createVNode(_component_router_view)
                  ])
                ])
              ]),
              createVNode(_sfc_main$7)
            ])
          ]),
          createVNode(_sfc_main$q)
        ]),
        _cache[1] || (_cache[1] = createStaticVNode('<div class="absolute top-0 left-0 cc-text-color cc-text-sz z-50" id="ccvaultio-modal"></div><div class="absolute top-0 left-0 cc-text-color cc-text-sz z-50" id="eternl-modal"></div><div class="absolute top-0 left-0 cc-text-color cc-text-sz z-100" id="eternl-dapp-store-iframe"></div><div class="absolute top-0 left-0 cc-text-color cc-text-sz z-[110]" id="eternl-dapp-store-sign"></div><div class="absolute top-0 left-0 cc-text-color cc-text-sz z-[120]" id="eternl-sign"></div><div class="absolute top-0 left-0 cc-text-color cc-text-sz z-[130]" id="eternl-sign-data"></div><div class="absolute top-0 left-0 cc-text-color cc-text-sz z-[150]" id="eternl-sign-keystone"></div><div class="absolute top-0 left-0 cc-text-color cc-text-sz z-[160]" id="eternl-password"></div>', 8)),
        createVNode(_sfc_main$1),
        createVNode(_sfc_main$5),
        createVNode(_sfc_main$2)
      ], 64);
    };
  }
});
export {
  _sfc_main as default
};
